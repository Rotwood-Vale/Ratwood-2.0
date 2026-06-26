// ============================================================================
// 自定义精炼药剂框架 (Custom Medicine-Refining Framework)
// ----------------------------------------------------------------------------
// 中文总览（按用户最终确认重做）：
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
//     (此前曾尝试纯化学反应方案，但反应只能读试剂、读不到固体气味材料，故对本机制不适用。)
//
//   本框架做法：
//     1) 子类型 /obj/machinery/light/rogue/cauldron/refining，覆盖 process()：
//        — 仍用【原版材料的气味积分】(major/med/minor_pot = 3/2/1，累计 >=5)选出一个"配方家族"
//          (这是个【现成】的 /datum/alch_cauldron_recipe，例如 生命药水 / 耐力药水)；
//        — 再看锅里的【液体底料】：
//            · 若匹配到某条"精炼配方"(见下) → 产出该配方的【新药】(液体底料决定炼成什么)；
//            · 否则回退【原版行为】：以水为底，炼出该现成配方原本的产物(向后兼容，普通药水照做)。
//     2) 精炼配方用数据描述：/datum/alch_refining_formula，声明
//        "气味要求" + "所需液体底料(required_base，单一/复合)" + "产物(output_reagents)"。
//        其中"气味要求"二选一：
//          ① 按【气味等级】：required_scent + required_scent_points，如"5 级春日气味"——不必镜像任何现成配方；
//          ② 按【现成配方家族】：base_recipe，要求材料气味积分最高项为某现成配方(兼容旧式写法)。
//        未来新增配方只需继承它、用【现成气味/现成液体】填好字段——不触碰任何材料，符合"只用原版材料"。
//     3) ★酒基设定★：若配方的液体底料含【任意酒类】(乙醇子类，泛指游戏内所有酒)，则其成品为"酒基药剂"——
//        喝下会像喝酒一样【上头醉酒】。酒劲(boozepwr) = 【所用酒底的酒劲(加权平均)】 + 【所需技能加成】，
//        并封顶在安全值：即"酒底越烈、所需技能越高，成品越烈"。出炉时炼药锅算出酒劲写入成品试剂的 data，
//        随装瓶/转移保留；成品继承 /datum/reagent/consumable/ethanol/refined_potion 即自动享有此设定
//        (见 0 节常量与 is_alcoholic()/get_base_alcohol_strength()/get_boozepwr())。
//
//   本文件全部内容位于 modular_z121 根目录之下，符合项目硬性约束。
// ============================================================================


// ============================================================================
// 0) "酒基药剂"设定常量 —— 让以酒为底的精炼药剂"喝起来像喝酒"，且技能越高酒劲越烈。
// ----------------------------------------------------------------------------
// 中文：成品酒劲(boozepwr) = 【所用酒底的酒劲】 + 【技能加成】，并设安全上限。
//   · 酒底酒劲：取底料中各酒类(乙醇子类)按用量【加权平均】的原版 boozepwr —— 用越烈的酒，成品越烈。
//   · 技能加成：PER_SKILL * skill_required —— 所需炼金技能越高，越烈。
//   · 上限 MAX：避免酒劲过高(原版 91+ 会醉死)，封顶在 80(≈烂醉但不致死)。
//   参考(原版 boozepwr)：淡啤酒=5、葡萄酒=30；35-40≈微醺、41-50≈一般醉、51-70≈大醉、71+≈烂醉。
//   举例(技能数值：学徒2/老手3/专家4/大师5/传奇6)：
//     葡萄酒底(30)+学徒(2) → 30+16=46(一般醉)；葡萄酒底+传奇(6) → 30+48=78(大醉，封顶内)；
//     淡啤酒底(5)+学徒(2) → 5+16=21(微醺)。可见"酒越烈"与"技能越高"都会抬高酒劲。
// WHY a formula: 用户要"通用设定"，对【所有】酒基精炼药剂自动生效，且同时受【技能】与【酒底强度】两方面影响。
#define ALCOHOL_POTION_BOOZE_PER_SKILL 8			// Skill contribution per required alchemy level.
#define ALCOHOL_POTION_MAX_BOOZE 80				// Safety cap (keep below the lethal 91+ band).


// ============================================================================
// 1) 框架数据：精炼配方 /datum/alch_refining_formula。
// 中文：一条"精炼配方"= 用哪种现成材料气味(base_recipe) + 哪种液体底料(required_base) → 炼出什么(output_reagents)。
//   未来新增配方：继承本类，填 base_recipe / required_base / output_reagents 即可，全部使用【现成】路径。
// ============================================================================
/datum/alch_refining_formula
	// 中文：配方名(成功提示/调试用)。
	var/name = "精炼药剂"									// Display name.
	// ========================================================================
	// 中文：★调配要求★——本配方靠什么材料气味触发。下面【二选一】(优先用气味档①)：
	//   ① 按【气味等级】(推荐，最灵活)：要求某种"气味"累计达到若干点，与具体配方无关。
	//      炼药锅会把每件材料缓存好的 major_smell/med_smell/minor_smell 按 3/2/1 累加到对应气味上。
	//      例：required_scent = "春日"、required_scent_points = 5 ＝ "5 级春日(春季)气味"。
	//      (现成材料里带"春日"气味的有：玫瑰、沼泽烟叶粉，各为 3 级，凑两味即 6 点 >= 5。)
	//   ② 按【现成配方家族】(可选)：要求材料气味积分最高项恰为某个【现成】/datum/alch_cauldron_recipe。
	//      仅当未设 required_scent 时才使用本档。
	// WHY 两种模式: 用户希望"不必镜像某条现成配方"，故新增气味档①；同时保留配方档②以兼容旧式写法。
	// ========================================================================
	// 中文：气味档①——所需气味词(对应某配方的 smells_like，如 "春日")。设了它即走"按气味等级"匹配。
	var/required_scent = null								// Smell string to require (e.g. "春日"). Mode ①.
	// 中文：气味档①——所需气味点数阈值(累计 >= 此值才满足)。默认 5(即"5 级")。
	var/required_scent_points = 5							// Points threshold for required_scent.
	// 中文：气味档②——所需"材料气味家族"，一个【现成】的 /datum/alch_cauldron_recipe 路径(未设 required_scent 时生效)。
	var/base_recipe = null									// Existing recipe path the top scent must equal. Mode ②.
	// 中文：所需【液体底料】，关联列表 list(试剂路径 = 单位数)。可单一(如 葡萄酒=90)或复合(如 水=60, 油=30)。
	var/list/required_base = list()							// Liquid base: single or composite (existing reagents).
	// 中文：产物——精炼出的【新药】(成品试剂；成品是产出，不属于"输入材料")。
	var/list/output_reagents = list()						// The new refined potion(s).
	// 中文：成功时显示的气味词。
	var/smells_like = "精炼药香"								// Flavour scent on success.
	// 中文：驾驭本配方所需的炼金技能等级(默认学徒，可按需提高)。
	var/skill_required = SKILL_LEVEL_APPRENTICE				// Min alchemy skill to brew it.

// 中文：判断本配方是否为【酒基】——其液体底料里只要含任意一种"酒精饮料"(乙醇的子类)即算。
// WHY: 用户指明"酒精"泛指游戏里的【所有酒类】，而它们都继承自 /datum/reagent/consumable/ethanol，
//      故用 ispath(..., ethanol) 一网打尽，无需逐一枚举具体酒水。
/datum/alch_refining_formula/proc/is_alcoholic()
	// 中文：遍历底料各组分，命中任一乙醇子类即返回真。
	for(var/base_reagent in required_base)					// Each liquid-base component.
		if(ispath(base_reagent, /datum/reagent/consumable/ethanol))	// Any alcoholic beverage?
			return TRUE										// It's an alcohol-based potion.
	return FALSE											// No alcohol in the base.

// 中文：取底料中各【酒类】组分按用量【加权平均】的原版酒劲(boozepwr)——代表"所用酒水本身有多烈"。
// WHY weighted by amount: 复合酒底(如 啤酒+威士忌)按各自用量折中；非酒组分(水/油等)不计入。
//      用 initial(E.boozepwr) 读取该酒类型的【出厂酒劲】(E 只是持有类型路径，不实例化)。
/datum/alch_refining_formula/proc/get_base_alcohol_strength()
	// 中文：累计"酒类用量"与"酒劲×用量"，用于求加权平均。
	var/total_amount = 0									// Sum of alcoholic base amounts.
	var/total_weighted = 0									// Sum of (boozepwr * amount).
	for(var/base_reagent in required_base)					// Each liquid-base component.
		// 中文：跳过非酒组分(水、板油等)。
		if(!ispath(base_reagent, /datum/reagent/consumable/ethanol))	// Not an alcoholic beverage.
			continue
		// 中文：把类型路径放进带类型的变量，便于用 initial() 读它的出厂酒劲。
		var/datum/reagent/consumable/ethanol/E = base_reagent	// Typed handle for initial().
		var/amount = required_base[base_reagent]			// How much of this drink the base uses.
		total_amount += amount								// Tally amount.
		total_weighted += initial(E.boozepwr) * amount		// Tally strength-weighted-by-amount.
	// 中文：没有酒(理论上 is_alcoholic 已挡住) → 0。
	if(total_amount <= 0)									// No alcohol present.
		return 0
	// 中文：加权平均酒劲。
	return total_weighted / total_amount					// Amount-weighted average boozepwr.

// 中文：计算本配方成品应携带的酒精强度(boozepwr)。非酒基 → 0；酒基 → 【酒底酒劲 + 技能加成】并封顶。
// WHY: 把"酒越烈/技能越高都更烈、但不致死"的设定收敛到一处，对所有酒基配方统一生效。
/datum/alch_refining_formula/proc/get_boozepwr()
	// 中文：非酒基配方不产生酒劲。
	if(!is_alcoholic())										// Not alcohol-based.
		return 0
	// 中文：成品酒劲 = 酒底加权平均酒劲 + 每级技能加成 * 所需技能等级。
	var/strength = get_base_alcohol_strength() + (ALCOHOL_POTION_BOOZE_PER_SKILL * skill_required)	// Base-drink + skill.
	// 中文：四舍五入并封顶到安全上限，避免出现"喝一口就醉死"的成品。
	return min(round(strength), ALCOHOL_POTION_MAX_BOOZE)	// Rounded & capped.

// 中文：全局缓存——所有精炼配方实例。声明一个新的全局列表(在本目录声明全局是允许的)。
GLOBAL_LIST_EMPTY(alch_refining_formulas)					// Lazily-filled list of all formula instances.

// 中文：惰性构建并返回精炼配方表(首次调用时实例化所有子类，之后复用缓存)。
// WHY lazy: 不便改动 global_lists.dm 的初始化流程，故首次用到时自建，零侵入。
/proc/get_alch_refining_formulas()
	// 中文：尚未构建则现在构建。
	if(!GLOB.alch_refining_formulas || !GLOB.alch_refining_formulas.len)	// Not built yet.
		GLOB.alch_refining_formulas = list()				// Fresh list.
		// 中文：实例化 /datum/alch_refining_formula 的每个子类(基类被 subtypesof 自动排除)。
		for(var/formula_type in subtypesof(/datum/alch_refining_formula))	// Every concrete formula.
			GLOB.alch_refining_formulas += new formula_type()	// Cache one instance each.
	return GLOB.alch_refining_formulas						// Hand back the cache.


// ============================================================================
// 2) 精炼炼药锅子类型：在原版炼药锅基础上，使其能读取液体底料。
// 中文：继承原版炼药锅的一切交互(投料/取料/贴图/初始化等)，仅【覆盖】熬制循环 process()。
// ============================================================================
/obj/machinery/light/rogue/cauldron/refining
	// 中文：名称/描述，点明它能用多种液体底料精炼药剂。
	name = "精炼炼药锅"										// Distinct in-game name.
	desc = "一口内壁镶着导流纹的精铁药锅。除清水外，还能以油、酒等单一或复合液体为底料，循炼金材料的气味精炼出药剂。"	// Flavour + mechanic hint.

// 中文：覆盖熬制循环。节奏沿用原版(点火→投料→沸腾计时 0..20→第 20 拍结算)，但把"只认水的产物"
//       改为"按材料气味选出配方家族 + 按液体底料决定产物"。
// WHY not call ..(): 调用 ..() 会执行父级原版的水基熬制造成双重处理；故就地复刻父链燃料维护后自行实现。
/obj/machinery/light/rogue/cauldron/refining/process()
	// ---- 燃料/熄火维护：复刻自 /obj/machinery/light/process() 的逻辑 ----
	// 中文：火亮且本类型消耗燃料时按 10/拍 递减，耗尽则熄火(burn_out 经继承会连带把 brewing 归零)。
	if(on && initial(fueluse) > 0)							// Only burn fuel while lit & fuel-driven.
		if(fueluse > 0)										// Still has fuel.
			fueluse = max(fueluse - 10, 0)					// Spend this tick's fuel.
		if(fueluse == 0)									// Ran dry.
			burn_out()										// Extinguish (zeroes brewing via inheritance).

	// 中文：每拍刷新贴图。
	update_icon()											// Keep overlays current.

	// 中文：火熄/无材料 → 不熬制。
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

	// 中文：仅第 20 拍结算；21 表示已完成的空闲态。
	if(brewing != 20)										// Already finalized.
		return

	// ---- 第 20 拍：把【原版材料气味】同时按"配方路径"和"气味词"两种维度累计 ----
	// 中文：outcomes 按【配方路径】累计(用于气味档②与原版回退、5 点门槛)；
	//       scent_points 按【气味词(smells_like)】累计(用于气味档①"按气味等级"匹配)。
	//       材料的气味词来自其初始化时缓存的 major_smell/med_smell/minor_smell(= 各 pot 配方的 smells_like)。
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

	// 中文：气味积分最高的现成配方路径(可能为 null，若没投任何带气味的材料)，供气味档②与原版回退使用。
	var/top_recipe = outcomes.len ? outcomes[1] : null		// Winning existing recipe path (or null).

	// 中文：错误处理——没有炼金术士指引 → 什么也炼不出(在动用任何材料/液体之前先判)。
	if(!lastuser)											// No alchemist guided it.
		brewing = 0
		visible_message(span_info("没有炼金术士的指引，炼药锅什么都炼制不出来。"))
		return

	// 中文：炼成给予的经验(按操作者智力)。
	var/amt2raise = lastuser?.STAINT * 2					// XP on a brew attempt.

	// ---- 第 20 拍(分支 A)：尝试匹配一条"精炼配方"(气味要求 + 液体底料都满足) ----
	// 中文：气味(档①等级 或 档②家族)决定"做哪一类"，液体底料决定"精炼成什么"——这是本框架的核心。
	//       精炼配方各自带阈值，不依赖下面那条"5 点"原版门槛。
	var/datum/alch_refining_formula/formula = find_refining_formula(scent_points, top_recipe)	// Match by scent/recipe + base.
	if(formula)												// A refined recipe applies.
		// 中文：技能不足 → 整锅腐坏(见 spoil_batch)。
		if(formula.skill_required > lastuser?.get_skill_level(/datum/skill/craft/alchemy))	// Skill gate.
			spoil_batch(amt2raise)
			return
		// 中文：消耗液体底料(逐种全部熬干)，销毁材料，注入新药。
		for(var/base_reagent in formula.required_base)		// Each base component.
			reagents.remove_reagent(base_reagent, reagents.get_reagent_amount(base_reagent))	// Boil it all away.
		for(var/obj/item/ing in ingredients)				// Spend materials.
			qdel(ing)
		ingredients = list()								// Reset materials.
		// 中文：注入成品。若是【酒基药剂】，则给成品附带"酒劲(boozepwr)"——存入试剂的 data，
		//       使其在装瓶/转移后仍随试剂保留(copy_data 会复制 data)，喝下时即按此酒劲令人醉酒。
		if(formula.output_reagents.len)						// Pour the refined potion in.
			var/booze = formula.get_boozepwr()				// Skill-scaled alcohol strength (0 if non-alcoholic).
			if(booze > 0)									// Alcohol-based potion.
				for(var/output_type in formula.output_reagents)	// Each output reagent.
					// 中文：每种成品各用一份独立的 data 列表(避免共享引用)，写入酒劲。
					reagents.add_reagent(output_type, formula.output_reagents[output_type], list("boozepwr" = booze))	// Carry the booze strength.
			else											// Non-alcoholic potion: plain output.
				reagents.add_reagent_list(formula.output_reagents)
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
	// 中文：先套用原版的"5 点"门槛——气味积分最高的现成配方需达到 5 点，否则视为无法融合。
	if(!top_recipe || outcomes[top_recipe] < 5)				// No existing recipe reached the vanilla 5-pt gate.
		brewing = 0
		visible_message(span_info("[src]中的材料完全无法融合……"))
		playsound(src, 'sound/misc/smelter_fin.ogg', 30, FALSE)
		return
	// 中文：保持向后兼容——精炼锅也能照常炼制所有普通药水(以水为底)。
	var/datum/alch_cauldron_recipe/found_recipe = new top_recipe	// Instantiate the existing recipe.
	// 中文：技能不足 → 腐坏。
	if(found_recipe.skill_required > lastuser?.get_skill_level(/datum/skill/craft/alchemy))	// Skill gate.
		qdel(found_recipe)
		spoil_batch(amt2raise)
		return
	// 中文：原版以水为底；水不足则提示"既无合适底料、也无精炼配方"。
	var/water_amt = reagents.get_reagent_amount(/datum/reagent/water)	// How much water is present.
	if(water_amt < waterneed)								// Not enough water for the vanilla brew.
		brewing = 0
		visible_message(span_warning("[src]里没有合适的液体底料来炼制[found_recipe.name]，也没有对应的精炼配方。"))
		qdel(found_recipe)
		return
	// 中文：消耗全部水，销毁材料，注入原版产物(及可能的固定产出物品)。
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
// WHY a helper: 把"匹配逻辑"独立出来，process() 更清晰，未来也便于复用。
/obj/machinery/light/rogue/cauldron/refining/proc/find_refining_formula(list/scent_points, top_recipe)
	// 中文：遍历所有精炼配方。
	for(var/datum/alch_refining_formula/F in get_alch_refining_formulas())	// Each known formula.
		// 中文：先判"气味要求"是否满足(档①优先：按气味等级；否则档②：按现成配方家族)。
		var/scent_ok = FALSE								// Did the scent/recipe trigger pass?
		if(F.required_scent)								// Mode ① — require N points of a smell.
			// 中文：取该气味当前累计点数(缺省为 0)，达到阈值即满足。
			var/have = scent_points[F.required_scent]		// Accumulated points for that smell.
			if(isnull(have))								// Absent -> 0.
				have = 0
			if(have >= F.required_scent_points)				// Reached the required level?
				scent_ok = TRUE
		else if(F.base_recipe)								// Mode ② — require the top scent recipe to match.
			if(F.base_recipe == top_recipe)					// Materials' dominant recipe equals it?
				scent_ok = TRUE
		// 中文：气味要求不满足则跳过本配方。
		if(!scent_ok)										// Trigger not met.
			continue
		// 中文：逐项检查液体底料是否齐备。
		var/base_ok = TRUE									// Assume satisfied until a component is missing.
		for(var/base_reagent in F.required_base)			// Each required base component.
			if(!reagents.has_reagent(base_reagent, F.required_base[base_reagent]))	// Missing/insufficient.
				base_ok = FALSE
				break
		// 中文：气味与底料都满足 → 命中。
		if(base_ok)											// All base components present.
			return F
	// 中文：无匹配。
	return null

// 中文：技能不足时的"整锅腐坏"惩罚——液体全变恶心物、材料损毁，但仍给少量经验(失败也是学习)。
// WHY a helper: 两个分支(精炼/回退)都要用同一套腐坏处理，抽出避免重复。
/obj/machinery/light/rogue/cauldron/refining/proc/spoil_batch(amt2raise)
	// 中文：归零计时并提示。
	brewing = 0
	visible_message(span_warning("锅中的材料混合成了一团恶心的烂泥！也许需要更高明的炼金术士才能处理这个配方。"))
	// 中文：把全部液体 1:1 变成恶心物。
	var/spoiled = reagents.total_volume						// Volume that spoils.
	reagents.clear_reagents()								// Dump the failed mixture.
	if(spoiled > 0)											// Replace with yuck.
		reagents.add_reagent(/datum/reagent/yuck, spoiled)
	// 中文：损毁材料并清空列表。
	for(var/obj/item/ing in ingredients)
		qdel(ing)
	ingredients = list()
	// 中文：失败也给经验。
	lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)


// ============================================================================
// 3) 取得途径：精炼炼药锅的合成配方。
// 中文：仿原版"炼金坩埚"的配方(材料路径均已验证存在)，难度更高，定位进阶装置。
// ============================================================================
/datum/crafting_recipe/roguetown/structure/refiningcauldron
	// 中文：合成菜单显示名。
	name = "精炼炼药锅"										// Shown in the craft menu.
	// 中文：产物——精炼锅。
	result = /obj/machinery/light/rogue/cauldron/refining	// What gets built.
	// 中文：所需材料(与原版炼金坩埚一致，确保路径有效)：2 树枝 + 3 石头 + 1 石锅。
	reqs = list(/obj/item/grown/log/tree/stick = 2,			// 2 sticks.
				/obj/item/natural/stone = 3,				// 3 stones.
				/obj/item/reagent_containers/glass/bucket/pot/stone = 1)	// 1 stone pot.
	// 中文：动作文本。
	verbage_simple = "组装"
	verbage = "组装"
	// 中文：炼金技能制作，难度 2(高于基础坩埚的 1)。
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 2


// ============================================================================
// 4) 成品试剂(产出，非"输入材料"，符合"材料须现成、成品可新建")。
// ============================================================================

// --- 凝脂润肤膏：示例一(复合底料)的产物 ---
// 中文：归入药剂大类；每代谢一拍温和愈合烧伤与轻微外伤。
/datum/reagent/medicine/tallow_salve
	name = "凝脂润肤膏"										// In-game name.
	description = "循生命草木的气味、以清水与板油复合为底在炼药锅中精炼而成的温润药膏，能舒缓灼伤、抚平皮肉的细小创口。"	// Flavour + hint.
	reagent_state = LIQUID									// Salve liquid.
	color = "#e8c873"										// Warm tallow-yellow.
	taste_description = "油脂的暖香"							// Taste flavour.
	metabolization_rate = REAGENTS_METABOLISM				// Standard metabolism.

// 中文：每代谢一拍的疗效——主疗烧伤、辅疗外伤。
/datum/reagent/medicine/tallow_salve/on_mob_life(mob/living/carbon/M)
	if(!M || QDELETED(M))									// Guard against missing/deleting mob.
		return ..()
	M.adjustFireLoss(-3)									// Soothe burns.
	M.adjustBruteLoss(-1)									// Minor brute mending.
	return ..()

// --- 酒基药剂基类：所有"以酒为底"的精炼成品都应继承它 ---
// 中文：继承 /datum/reagent/consumable/ethanol，从而获得原版【完整的醉酒逻辑】(父类 on_mob_life 会按
//       boozepwr 累加 drunkenness)；其酒劲 boozepwr 由炼药锅出炉时按"配方技能"写入试剂的 data，于此处
//       (代谢开始时)读出生效，因而能随【装瓶/转移】一路保留——喝下时"像喝酒一样"上头，且技能越高越烈。
// WHY a dedicated base: 让"酒基设定"通用化——未来任意酒基成品只要继承本类，即自动享有"技能越高酒越烈"。
/datum/reagent/consumable/ethanol/refined_potion
	name = "酒基药剂"										// Generic name (subtypes override).
	// 中文：兜底酒劲(若某瓶未被炼药锅写入 data 时的默认值)；正常出炉的成品会被按技能换算的强度覆盖。
	boozepwr = 30											// Fallback strength if no brew data present.

// 中文：代谢开始时(每瓶仅触发一次)把 data 里的酒劲读进 boozepwr；其后每拍的醉酒逻辑(父类)即按此生效。
/datum/reagent/consumable/ethanol/refined_potion/on_mob_metabolize(mob/living/M)
	. = ..()												// Let ethanol/consumable set up first.
	// 中文：data 由炼药锅出炉时写入 list("boozepwr" = 按技能换算的强度)；存在则覆盖默认酒劲。
	if(islist(data) && !isnull(data["boozepwr"]))			// Brew wrote a custom strength?
		boozepwr = data["boozepwr"]							// Apply the skill-scaled alcohol content.

// --- 暖心酒剂：示例二(单一酒底)的产物，本身即一味【酒基药剂】 ---
// 中文：暖心酒剂带来的正面心情事件(负压力 = 心情变好)。
/datum/stressevent/heartwarming_tonic
	timer = 3 MINUTES										// Duration of the warmth.
	stressadd = -3											// Positive mood (stress relief).
	desc = span_green("一口暖心酒剂下肚，浑身都暖洋洋的。")	// Mood-readout source line.

// 中文：成品试剂——暖心酒剂；继承酒基药剂基类，故喝下会像喝酒一样上头(酒劲由配方所需技能决定)。
/datum/reagent/consumable/ethanol/refined_potion/heartwarming_tonic
	name = "暖心酒剂"										// In-game name.
	description = "循春日花木的气味、单以醇酒为底在炼药锅中精炼的暖红色酒剂，入喉生暖、微醺上头，令人心情舒畅。"	// Flavour + hint.
	color = "#b5402f"										// Warm wine-red.
	taste_description = "温热的醇酒"							// Taste flavour.
	// 中文：兜底酒劲(若某瓶未被炼药锅写入 data 时的默认值)；正常出炉时由炼药锅按"酒底+技能"覆盖。
	boozepwr = 30											// Fallback; overridden per-brew (base drink + skill).

// 中文：每代谢一拍——先给饮用者提振心情，再交由父链(酒基→乙醇)施加醉酒效果。
/datum/reagent/consumable/ethanol/refined_potion/heartwarming_tonic/on_mob_life(mob/living/carbon/M)
	if(!M || QDELETED(M))									// Guard against missing/deleting mob.
		return ..()
	if(M.stat == CONSCIOUS)									// Only conscious mobs feel mood.
		M.add_stress(/datum/stressevent/heartwarming_tonic)	// Apply the positive mood.
	return ..()												// -> ethanol on_mob_life: apply drunkenness at brewed boozepwr.


// ============================================================================
// 5) 示例精炼配方(全部使用【现成材料 + 现成液体】，未新增任何材料)。
// ----------------------------------------------------------------------------
// 中文：玩家用【原版材料】把气味凑够要求，再配上指定【液体底料】即可精炼出新药。两种触发方式各演示一例：
//   · 示例一(气味档②·按现成配方家族)：材料气味指向"生命药水"
//             (如 聚合草[major=生命药水] + 蒲公英[med=生命药水] = 5 点)，
//             配【复合底料 水60 + 板油30】→ 凝脂润肤膏。(同样的材料若只配清水，则回退炼成普通生命药水。)
//   · 示例二(气味档①·按气味等级)：要求【5 级"春日"气味】
//             (如 玫瑰[major=春日,3] + 沼泽烟叶粉[major=春日,3] = 6 点)，
//             配【单一底料 葡萄酒90】→ 暖心酒剂。无需镜像任何现成配方。
// ============================================================================

// 中文：示例一——复合底料(水 + 油)，把"生命药水家族"的材料精炼成凝脂润肤膏。
/datum/alch_refining_formula/tallow_salve
	name = "凝脂润肤膏"										// Formula name.
	// 中文：材料气味须指向【现成的"生命药水"配方】。
	base_recipe = /datum/alch_cauldron_recipe/health_potion	// Existing recipe the materials smell like.
	// 中文：★复合底料★ 水 60 + 板油 30(均为现成试剂；板油＝leaf lard，比通用燃油更贴合"凝脂"药膏)。
	required_base = list(/datum/reagent/water = 60, /datum/reagent/consumable/oil/tallow = 30)	// Composite base (water + tallow/leaf-lard).
	// 中文：产物——60 单位凝脂润肤膏。
	output_reagents = list(/datum/reagent/medicine/tallow_salve = 60)	// Refined output.
	// 中文：成功气味词。
	smells_like = "温润油脂"									// Success scent.

// 中文：示例二——★按气味等级★触发(气味档①)：要求【5 级"春日"(春季)气味】+ 单一葡萄酒底料 → 暖心酒剂。
//       不镜像任何现成配方，纯靠气味等级。带"春日"气味的现成材料：玫瑰、沼泽烟叶粉(各 3 级)，
//       两味同投即 6 点 >= 5，满足"5 级春日气味"。
/datum/alch_refining_formula/heart_tonic
	name = "暖心酒剂"										// Formula name.
	// 中文：★气味档①★ 要求"春日"气味累计达到 5 点(即"5 级春日气味")。无需指定任何现成配方。
	required_scent = "春日"									// Require the spring scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★单一替代底料★ 只用葡萄酒 90(完全不用水)。
	required_base = list(/datum/reagent/consumable/ethanol/wine = 90)	// Single non-water base.
	// 中文：产物——60 单位暖心酒剂(酒基药剂；因底料为葡萄酒，出炉时会按本配方技能附带酒劲)。
	output_reagents = list(/datum/reagent/consumable/ethanol/refined_potion/heartwarming_tonic = 60)	// Refined alcoholic output.
	// 中文：成功气味词。
	smells_like = "醇酒暖意"									// Success scent.
	// 中文：本配方为【酒基】(底料为葡萄酒，boozepwr 30)：成品喝下会像喝酒一样上头。
	//       酒劲＝酒底30 + 技能加成(学徒2×8=16) = 46(一般醉)。把 skill_required 调高、或换更烈的酒底，酒劲随之增强。
	skill_required = SKILL_LEVEL_APPRENTICE					// Skill gate (also feeds the alcohol strength).


// 中文：清理本文件作用域内的局部宏，避免泄漏到全局编译环境。
#undef ALCOHOL_POTION_BOOZE_PER_SKILL
#undef ALCOHOL_POTION_MAX_BOOZE
