// ============================================================================
// 自定义精炼药剂框架 (Custom Medicine-Refining Framework) —— 核心
// ----------------------------------------------------------------------------
// 中文总览：
//   需求：用【不同的液体底料(单一 或 复合)】 + 【原版炼金材料(/obj/item/alch 气味材料)】
//   在炼药锅中精炼出药剂；且【不新增任何材料】(只用现成的原版材料与现成液体)。
//
//   为什么必须新建炼药锅【子类型】：
//     原版炼药锅 /obj/machinery/light/rogue/cauldron 的 process() 把"液体底料"硬编码成【只认水】，
//     根本不读油/酒等其它液体；要让它读取液体底料，就必须改写 process()。而：
//       · 不得修改 cauldron.dm(在 modular_z121 之外)；
//       · 在本目录重定义 /obj/machinery/light/rogue/cauldron/process() 会"同名过程重复定义"而编译报错；
//       · 原版炼金材料是【固体投料物】，不会溶成试剂(没有 grind/juice 结果)，所以化学反应也读不到它们。
//     因此"固体气味材料 + 非水液体底料 → 新药"这一机制，只能通过【给炼药锅做子类型并覆盖 process()】实现。
//
//   本框架做法：
//     1) 子类型 /obj/machinery/light/rogue/cauldron/refining，覆盖 process()：
//        — 仍用【原版材料的气味积分】(major/med/minor_pot = 3/2/1，累计 >=5)选出一个"配方家族"；
//        — 再看锅里的【液体底料】：匹配到某条"精炼配方" → 产出新药；否则回退【原版水基行为】(向后兼容)。
//     2) 精炼配方用数据描述：/datum/alch_refining_formula，气味要求二选一(①按气味等级 required_scent /
//        ②按现成配方家族 base_recipe) + 液体底料 required_base + 产物 output_reagents。
//     3) ★酒基设定★：底料含【任意酒类】(乙醇子类)→ 成品为"酒基药剂"，喝下会像喝酒一样上头；酒劲(boozepwr)
//        = 酒底酒精含量(=酒劲×酒在底料中的占比) + 少量技能加成，并封顶；出炉时写入成品 data，随装瓶保留。
//
//   ★文件组织★：本文件只放【框架核心】(配方基类与算法、精炼炼药锅、合成配方、酒基药剂基类)。
//     每一味具体药水(成品试剂 + 其配方)各自独立成一个文件，置于 alchemy/refining_potions/ 下。
//     配方书"精炼药剂"分类的接入见 refining_guide.dm。新增药水：在 refining_potions/ 新建一个文件，
//     继承本框架的类型(/datum/alch_refining_formula 与/或 /datum/reagent/consumable/ethanol/refined_potion)即可，
//     再在 _load.dm 里 #include 它。
//
//   本文件全部内容位于 modular_z121 根目录之下，符合项目硬性约束。
// ============================================================================


// ============================================================================
// 0) "酒基药剂"设定常量 —— 让以酒为底的精炼药剂"喝起来像喝酒"，且技能越高酒劲越烈。
// ----------------------------------------------------------------------------
// 中文：成品酒劲(boozepwr) = 【酒底的"酒精含量"】 + 【少量技能加成】，并设安全上限。
//   · 酒底酒精含量(主导项)：= Σ(各酒类 boozepwr × 用量) ÷ 【整份底料总量】(含水/油等)，即"酒底强度 × 酒占比"。
//   · 技能加成(次要项)：PER_SKILL * skill_required。PER_SKILL 已大幅调小，弱化技能对酒劲的干扰。
//   · 上限 MAX：避免酒劲过高(原版 91+ 会醉死)，封顶在 80。
//   参考(原版 boozepwr)：淡啤酒=5、葡萄酒=30；35-40≈微醺、41-50≈一般醉、51-70≈大醉、71+≈烂醉。
// WHY: 用户要求酒劲与"酒在底料中的占比"挂钩，并削弱所需技能对酒劲的干扰。
#define ALCOHOL_POTION_BOOZE_PER_SKILL 2			// Small skill contribution per level (reduced from 8).
#define ALCOHOL_POTION_MAX_BOOZE 80				// Safety cap (keep below the lethal 91+ band).


// ============================================================================
// 1) 框架数据：精炼配方 /datum/alch_refining_formula。
// 中文：一条"精炼配方"= 用哪种现成材料气味 + 哪种液体底料 → 炼出什么(output_reagents)。
//   未来新增配方：继承本类，填 气味要求 / required_base / output_reagents 即可，全部使用【现成】路径。
// ============================================================================
/datum/alch_refining_formula
	// 中文：抽象基类标记——配方书据此(is_abstract)只列出【子类】(具体配方)，不列出本基类。
	abstract_type = /datum/alch_refining_formula			// Base is abstract; only concrete formulas list.
	// 中文：配方书中的分类名——固定归入"精炼药剂"区(见 refining_guide.dm 对炼金秘要的扩展)。
	var/category = "精炼药剂"								// Recipe-book category (Refined Potions).
	// 中文：配方名(成功提示/调试用)。
	var/name = "精炼药剂"									// Display name.
	// ========================================================================
	// 中文：★调配要求★——本配方靠什么材料气味触发。下面【二选一】(优先用气味档①)：
	//   ① 按【气味等级】(推荐，最灵活)：要求某种"气味"累计达到若干点(major/med/minor = 3/2/1)，与具体配方无关。
	//      例：required_scent = "春日"、required_scent_points = 5 ＝ "5 级春日气味"。
	//   ② 按【现成配方家族】(可选)：要求材料气味积分最高项恰为某个【现成】/datum/alch_cauldron_recipe。
	//      仅当未设 required_scent 时才使用本档。
	// ========================================================================
	// 中文：气味档①——所需气味词(对应某配方的 smells_like，如 "春日")。设了它即走"按气味等级"匹配。
	var/required_scent = null								// Smell string to require (e.g. "春日"). Mode ①.
	// 中文：气味档①——所需气味点数阈值(累计 >= 此值才满足)。默认 5。
	var/required_scent_points = 5							// Points threshold for required_scent.
	// 中文：气味档②——所需"材料气味家族"，一个【现成】的 /datum/alch_cauldron_recipe 路径(未设 required_scent 时生效)。
	var/base_recipe = null									// Existing recipe path the top scent must equal. Mode ②.
	// 中文：所需【液体底料】，关联列表 list(试剂路径 = 单位数)。可单一(如 葡萄酒=90)或复合(如 水=60, 油=30)。
	var/list/required_base = list()							// Liquid base: single or composite (existing reagents).
	// 中文：产物——精炼出的【新药】(成品试剂；成品是产出，不属于"输入材料")。
	var/list/output_reagents = list()						// The new refined potion(s).
	// 中文：★固体产物★——精炼出的【实体物品】路径列表(可选)。每个条目生成一件物品(要多件就重复列出该路径)。
	//   用于"产物不是液体试剂、而是一件成品道具"的配方(如防腐皂)。留空则本配方只产试剂。
	var/list/output_items = list()							// Optional solid item outputs (one item per list entry).
	// 中文：成功时显示的气味词。
	var/smells_like = "精炼药香"								// Flavour scent on success.
	// 中文：驾驭本配方所需的炼金技能等级(默认学徒，可按需提高)。
	var/skill_required = SKILL_LEVEL_APPRENTICE				// Min alchemy skill to brew it.

// 中文：判断本配方是否为【酒基】——其液体底料里只要含任意一种"酒精饮料"(乙醇的子类)即算。
/datum/alch_refining_formula/proc/is_alcoholic()
	for(var/base_reagent in required_base)					// Each liquid-base component.
		if(ispath(base_reagent, /datum/reagent/consumable/ethanol))	// Any alcoholic beverage?
			return TRUE										// It's an alcohol-based potion.
	return FALSE											// No alcohol in the base.

// 中文：取底料的"酒精含量"——= Σ(各酒类 boozepwr × 用量) ÷ 【整份底料总量】(含水/油等)，故天然体现酒的占比。
// WHY: 用户要求酒劲与"酒在底料中的占比"挂钩。用 initial(E.boozepwr) 读取该酒类型的出厂酒劲(E 只持有类型路径)。
/datum/alch_refining_formula/proc/get_base_alcohol_content()
	var/total_base_volume = 0								// Sum of ALL base amounts (the denominator/proportion).
	var/total_weighted = 0									// Sum of (boozepwr * amount) over alcoholic parts.
	for(var/base_reagent in required_base)					// Each liquid-base component.
		var/amount = required_base[base_reagent]			// Its amount in the base.
		total_base_volume += amount							// All components count toward the total volume.
		if(!ispath(base_reagent, /datum/reagent/consumable/ethanol))	// Not an alcoholic beverage.
			continue
		var/datum/reagent/consumable/ethanol/E = base_reagent	// Typed handle for initial().
		total_weighted += initial(E.boozepwr) * amount		// Add this drink's strength-weighted-by-amount.
	if(total_base_volume <= 0)								// No base at all.
		return 0
	return total_weighted / total_base_volume				// boozepwr averaged over the WHOLE base (proportion-aware).

// 中文：计算本配方成品应携带的酒精强度(boozepwr)。非酒基 → 0；酒基 → 【酒底酒精含量 + 少量技能加成】并封顶。
/datum/alch_refining_formula/proc/get_boozepwr()
	if(!is_alcoholic())										// Not alcohol-based.
		return 0
	var/strength = get_base_alcohol_content() + (ALCOHOL_POTION_BOOZE_PER_SKILL * skill_required)	// Content + small skill.
	return min(round(strength), ALCOHOL_POTION_MAX_BOOZE)	// Rounded & capped.

// 中文：全局缓存——所有精炼配方实例。声明一个新的全局列表(在本目录声明全局是允许的)。
GLOBAL_LIST_EMPTY(alch_refining_formulas)					// Lazily-filled list of all formula instances.

// 中文：惰性构建并返回精炼配方表(首次调用时实例化所有子类，之后复用缓存)。
/proc/get_alch_refining_formulas()
	if(!GLOB.alch_refining_formulas || !GLOB.alch_refining_formulas.len)	// Not built yet.
		GLOB.alch_refining_formulas = list()				// Fresh list.
		for(var/formula_type in subtypesof(/datum/alch_refining_formula))	// Every concrete formula.
			GLOB.alch_refining_formulas += new formula_type()	// Cache one instance each.
	return GLOB.alch_refining_formulas						// Hand back the cache.


// ============================================================================
// 2) 精炼炼药锅子类型：在原版炼药锅基础上，使其能读取液体底料。
// 中文：继承原版炼药锅的一切交互(投料/取料/贴图/初始化等)，仅【覆盖】熬制循环 process()。
// ============================================================================
/obj/machinery/light/rogue/cauldron/refining
	name = "精炼炼药锅"										// Distinct in-game name.
	desc = "一口内壁镶着导流纹的精铁药锅。除清水外，还能以油、酒等单一或复合液体为底料，循炼金材料的气味精炼出药剂。"	// Flavour + mechanic hint.

// 中文：覆盖熬制循环。节奏沿用原版(点火→投料→沸腾计时 0..20→第 20 拍结算)，但把"只认水的产物"
//       改为"按材料气味选出配方家族 + 按液体底料决定产物"。
// WHY not call ..(): 调用 ..() 会执行父级原版的水基熬制造成双重处理；故就地复刻父链燃料维护后自行实现。
/obj/machinery/light/rogue/cauldron/refining/process()
	// ---- 燃料/熄火维护：复刻自 /obj/machinery/light/process() 的逻辑 ----
	if(on && initial(fueluse) > 0)							// Only burn fuel while lit & fuel-driven.
		if(fueluse > 0)										// Still has fuel.
			fueluse = max(fueluse - 10, 0)					// Spend this tick's fuel.
		if(fueluse == 0)									// Ran dry.
			burn_out()										// Extinguish (zeroes brewing via inheritance).

	update_icon()											// Keep overlays current.

	if(!on)													// Fire out.
		return
	if(!ingredients.len)									// No materials loaded.
		return

	// ---- 沸腾计时(0..19)：锅内液体够多即升温(不限种类，具体底料留待结算校验) ----
	if(brewing < 20)										// Heating up.
		if(reagents.total_volume >= waterneed)				// Enough liquid (any kind) to boil.
			brewing++										// Advance.
			if(prob(10))									// Occasional bubbling SFX.
				playsound(src, "bubbles", 100, FALSE)
		return

	if(brewing != 20)										// Already finalized.
		return

	// ---- 第 20 拍：把【原版材料气味】同时按"配方路径"和"气味词"两种维度累计 ----
	var/list/outcomes = list()								// recipe path -> points (mode ②/fallback/gate).
	var/list/scent_points = list()							// smell string -> points (mode ①).
	for(var/obj/item/ing in ingredients)					// Each loaded material.
		if(!istype(ing, /obj/item/alch))					// Only scent materials count.
			continue
		var/obj/item/alch/alching = ing						// Typed access.
		// --- 按配方路径累计(3/2/1) ---
		if(alching.major_pot != null)						// Strong (3).
			outcomes[alching.major_pot] = (isnull(outcomes[alching.major_pot]) ? 0 : outcomes[alching.major_pot]) + 3
		if(alching.med_pot != null)							// Medium (2).
			outcomes[alching.med_pot] = (isnull(outcomes[alching.med_pot]) ? 0 : outcomes[alching.med_pot]) + 2
		if(alching.minor_pot != null)						// Faint (1).
			outcomes[alching.minor_pot] = (isnull(outcomes[alching.minor_pot]) ? 0 : outcomes[alching.minor_pot]) + 1
		// --- 按气味词累计(3/2/1)，供"按气味等级"匹配 ---
		if(alching.major_smell)								// Strong-tier smell (3).
			scent_points[alching.major_smell] = (isnull(scent_points[alching.major_smell]) ? 0 : scent_points[alching.major_smell]) + 3
		if(alching.med_smell)								// Medium-tier smell (2).
			scent_points[alching.med_smell] = (isnull(scent_points[alching.med_smell]) ? 0 : scent_points[alching.med_smell]) + 2
		if(alching.minor_smell)								// Faint-tier smell (1).
			scent_points[alching.minor_smell] = (isnull(scent_points[alching.minor_smell]) ? 0 : scent_points[alching.minor_smell]) + 1
	sortTim(outcomes, cmp = /proc/cmp_numeric_dsc, associative = 1)	// Highest-scoring recipe first.

	// 中文：气味积分最高的现成配方路径(可能为 null)，供气味档②与原版回退使用。
	var/top_recipe = outcomes.len ? outcomes[1] : null		// Winning existing recipe path (or null).

	// 中文：错误处理——没有炼金术士指引 → 什么也炼不出。
	if(!lastuser)											// No alchemist guided it.
		brewing = 0
		visible_message(span_info("没有炼金术士的指引，炼药锅什么都炼制不出来。"))
		return

	var/amt2raise = lastuser?.STAINT * 2					// XP on a brew attempt.

	// ---- 第 20 拍(分支 A)：尝试匹配一条"精炼配方"(气味要求 + 液体底料都满足) ----
	var/datum/alch_refining_formula/formula = find_refining_formula(scent_points, top_recipe)	// Match by scent/recipe + base.
	if(formula)												// A refined recipe applies.
		// 中文：技能不足 → 整锅腐坏。
		if(formula.skill_required > lastuser?.get_skill_level(/datum/skill/craft/alchemy))	// Skill gate.
			spoil_batch(amt2raise)
			return
		// 中文：消耗液体底料(逐种全部熬干)，销毁材料，注入新药。
		for(var/base_reagent in formula.required_base)		// Each base component.
			reagents.remove_reagent(base_reagent, reagents.get_reagent_amount(base_reagent))	// Boil it all away.
		for(var/obj/item/ing in ingredients)				// Spend materials.
			qdel(ing)
		ingredients = list()								// Reset materials.
		// 中文：注入成品。若是【酒基药剂】，则给成品附带"酒劲(boozepwr)"——存入试剂的 data(随装瓶/转移保留)。
		if(formula.output_reagents.len)						// Pour the refined potion in.
			var/booze = formula.get_boozepwr()				// Skill-scaled alcohol strength (0 if non-alcoholic).
			if(booze > 0)									// Alcohol-based potion.
				for(var/output_type in formula.output_reagents)	// Each output reagent.
					reagents.add_reagent(output_type, formula.output_reagents[output_type], list("boozepwr" = booze))	// Carry the booze strength.
			else											// Non-alcoholic potion: plain output.
				reagents.add_reagent_list(formula.output_reagents)
			// 中文：★固体产物★——若配方产出实体物品(如防腐皂)，逐一在锅子所在格生成(一个条目=一件)。
			//   这样"精炼配方"也能像原版配方那样产出成品道具，而不仅仅是液体试剂。
		if(formula.output_items.len)						// Any solid item outputs?
			for(var/itempath in formula.output_items)		// Each item path (one item per entry).
				new itempath(get_turf(src))					// Spawn it on the cauldron's turf.
		// 中文：反馈/统计/经验/音效/完成。
		visible_message(span_info("[src]沸腾完毕，精炼出了[formula.name]，散发着一股[formula.smells_like]的气味。"))
		record_featured_stat(FEATURED_STATS_ALCHEMISTS, lastuser)
		record_round_statistic(STATS_POTIONS_BREWED)
		lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
		playsound(src, "bubbles", 100, TRUE)
		playsound(src, 'sound/misc/smelter_fin.ogg', 30, FALSE)
		brewing = 21										// Done.
		return

	// ---- 第 20 拍(分支 B)：无精炼配方匹配 → 回退【原版水基行为】，炼现成配方的原本产物 ----
	if(!top_recipe || outcomes[top_recipe] < 5)				// No existing recipe reached the vanilla 5-pt gate.
		brewing = 0
		visible_message(span_info("[src]中的材料完全无法融合……"))
		playsound(src, 'sound/misc/smelter_fin.ogg', 30, FALSE)
		return
	var/datum/alch_cauldron_recipe/found_recipe = new top_recipe	// Instantiate the existing recipe.
	if(found_recipe.skill_required > lastuser?.get_skill_level(/datum/skill/craft/alchemy))	// Skill gate.
		qdel(found_recipe)
		spoil_batch(amt2raise)
		return
	var/water_amt = reagents.get_reagent_amount(/datum/reagent/water)	// How much water is present.
	if(water_amt < waterneed)								// Not enough water for the vanilla brew.
		brewing = 0
		visible_message(span_warning("[src]里没有合适的液体底料来炼制[found_recipe.name]，也没有对应的精炼配方。"))
		qdel(found_recipe)
		return
	reagents.remove_reagent(/datum/reagent/water, water_amt)	// Consume the water base.
	for(var/obj/item/ing in ingredients)					// Spend materials.
		qdel(ing)
	ingredients = list()									// Reset materials.
	if(found_recipe.output_reagents.len)					// Vanilla reagent output.
		reagents.add_reagent_list(found_recipe.output_reagents)
	if(found_recipe.output_items.len)						// Vanilla item output.
		for(var/itempath in found_recipe.output_items)
			new itempath(get_turf(src))
	visible_message(span_info("炼药锅沸腾完毕，散发出一股淡淡的[found_recipe.smells_like]气味。"))
	record_featured_stat(FEATURED_STATS_ALCHEMISTS, lastuser)
	record_round_statistic(STATS_POTIONS_BREWED)
	lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
	playsound(src, "bubbles", 100, TRUE)
	playsound(src, 'sound/misc/smelter_fin.ogg', 30, FALSE)
	brewing = 21											// Done.
	qdel(found_recipe)										// Free the temp recipe datum.

// 中文：在精炼配方表中找出第一条"气味要求满足 且 液体底料齐备"的配方；找不到返回 null。
//   参数 scent_points：按气味词累计的点数表(气味档①用)；top_recipe：气味积分最高的现成配方路径(气味档②用)。
/obj/machinery/light/rogue/cauldron/refining/proc/find_refining_formula(list/scent_points, top_recipe)
	for(var/datum/alch_refining_formula/F in get_alch_refining_formulas())	// Each known formula.
		// 中文：先判"气味要求"是否满足(档①优先：按气味等级；否则档②：按现成配方家族)。
		var/scent_ok = FALSE								// Did the scent/recipe trigger pass?
		if(F.required_scent)								// Mode ① — require N points of a smell.
			var/have = scent_points[F.required_scent]		// Accumulated points for that smell.
			if(isnull(have))								// Absent -> 0.
				have = 0
			if(have >= F.required_scent_points)				// Reached the required level?
				scent_ok = TRUE
		else if(F.base_recipe)								// Mode ② — require the top scent recipe to match.
			if(F.base_recipe == top_recipe)					// Materials' dominant recipe equals it?
				scent_ok = TRUE
		if(!scent_ok)										// Trigger not met.
			continue
		// 中文：逐项检查液体底料是否齐备。
		var/base_ok = TRUE									// Assume satisfied until a component is missing.
		for(var/base_reagent in F.required_base)			// Each required base component.
			if(!reagents.has_reagent(base_reagent, F.required_base[base_reagent]))	// Missing/insufficient.
				base_ok = FALSE
				break
		if(base_ok)											// All base components present.
			return F
	return null

// 中文：技能不足时的"整锅腐坏"惩罚——液体全变恶心物、材料损毁，但仍给少量经验(失败也是学习)。
/obj/machinery/light/rogue/cauldron/refining/proc/spoil_batch(amt2raise)
	brewing = 0
	visible_message(span_warning("锅中的材料混合成了一团恶心的烂泥！也许需要更高明的炼金术士才能处理这个配方。"))
	var/spoiled = reagents.total_volume						// Volume that spoils.
	reagents.clear_reagents()								// Dump the failed mixture.
	if(spoiled > 0)											// Replace with yuck.
		reagents.add_reagent(/datum/reagent/yuck, spoiled)
	for(var/obj/item/ing in ingredients)
		qdel(ing)
	ingredients = list()
	lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)


// ============================================================================
// 3) 取得途径：精炼炼药锅的合成配方。
// 中文：仿原版"炼金坩埚"的配方(材料路径均已验证存在)，难度更高，定位进阶装置。
// ============================================================================
/datum/crafting_recipe/roguetown/structure/refiningcauldron
	name = "精炼炼药锅"										// Shown in the craft menu.
	result = /obj/machinery/light/rogue/cauldron/refining	// What gets built.
	reqs = list(/obj/item/grown/log/tree/stick = 2,			// 2 sticks.
				/obj/item/natural/stone = 3,				// 3 stones.
				/obj/item/reagent_containers/glass/bucket/pot/stone = 1)	// 1 stone pot.
	verbage_simple = "组装"
	verbage = "组装"
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 2


// ============================================================================
// 4) 酒基药剂基类(共享) —— 所有"以酒为底"的精炼成品都应继承它。
// 中文：继承 /datum/reagent/consumable/ethanol，从而获得原版【完整的醉酒逻辑】(父类 on_mob_life 会按
//       boozepwr 累加 drunkenness)；其酒劲 boozepwr 由炼药锅出炉时按"配方"写入试剂的 data，于此处
//       (代谢开始时)读出生效，因而能随【装瓶/转移】一路保留——喝下时"像喝酒一样"上头。
//   (各具体酒基药水(暖心酒剂/温酒/克林卡特……)各自独立成文件，见 refining_potions/。)
// ============================================================================
/datum/reagent/consumable/ethanol/refined_potion
	name = "酒基药剂"										// Generic name (subtypes override).
	// 中文：兜底酒劲(若某瓶未被炼药锅写入 data 时的默认值)；正常出炉的成品会被按"酒底+技能"换算的强度覆盖。
	boozepwr = 30											// Fallback strength if no brew data present.

// 中文：代谢开始时(每瓶仅触发一次)把 data 里的酒劲读进 boozepwr；其后每拍的醉酒逻辑(父类)即按此生效。
/datum/reagent/consumable/ethanol/refined_potion/on_mob_metabolize(mob/living/M)
	. = ..()												// Let ethanol/consumable set up first.
	if(islist(data) && !isnull(data["boozepwr"]))			// Brew wrote a custom strength?
		boozepwr = data["boozepwr"]							// Apply the skill-scaled alcohol content.


// 中文：清理本文件作用域内的局部宏(仅 get_boozepwr 用到)，避免泄漏到全局编译环境。
#undef ALCOHOL_POTION_BOOZE_PER_SKILL
#undef ALCOHOL_POTION_MAX_BOOZE
