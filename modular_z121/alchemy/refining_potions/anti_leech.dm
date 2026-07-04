// ============================================================================
// 防蚂蟥药水 (Anti-Leech Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文总览(WHY 这样设计)：
//   · 需求：底料 = 水70 + 普通毒药30；技能 = 炼金 3 级(熟练/Journeyman)；
//     气味 = 某个"未被其它精炼配方占用"的气味，且达到 5 级；效果 = 药效期间水蛭不再叮咬(吸血)饮用者；
//     消化速度 = 每 1 单位维持 12 秒；单批产出 50 单位。
//   · 气味选择：全部精炼配方已用掉 春日/甜浆果/力量/纯净/平静/大地/浆果派/炽热的甜香/清新空气/火焰 等；
//     "死亡"(=毒药(浆果) berrypoison 配方的 smells_like)【尚未被任何精炼配方占用】，且与"毒药底料"主题契合
//     (以死亡与毒的气息驱避嗜血水蛭)，因此选它作为触发气味。★携带"死亡"气味的现成材料★(pot→berrypoison)：
//     浆果粉[major,3]、洋甘菊[major,3]、颠茄[med,2]；如 浆果粉(3)+洋甘菊(3)=6 或 浆果粉(3)+颠茄(2)=5 即达 5 级。
//   · "普通毒药"= /datum/reagent/berrypoison(原版"毒药（浆果）"配方产物，最基础的毒药)。底料无酒 → 成品非酒基。
//   · 框架见 refining_framework.dm：配方以 required_scent(气味档①)+required_base(液体底料)+output_reagents 描述。
//
//   ★效果实现思路(WHY 用"主动驱离"而非改水蛭代码)★：
//     原版水蛭 /obj/item/natural/worms/leech 的吸血只发生在它【嵌入宿主肢体(is_embedded)】之后——
//     其 process()/on_embed_life() 会在 is_embedded 为真时抽血(host.blood_volume -= ...)；一旦脱离肢体即停止。
//     但水蛭代码在 modular_z121 之外，按项目硬性约束【不得修改】，也无法在本目录重定义其同名过程(会"过程重复定义"报错)。
//     因此本药在【代谢开始时】及【此后每个生命循环拍】主动巡检饮用者身上"正在吸血的水蛭"，把它们从肢体上剥离并落地——
//     水蛭一旦脱离即无法继续吸血，等效于"药效期间水蛭咬不动你"。同时给饮用者挂上自定义特性 TRAIT_ANTILEECH，
//     既作为"驱蛭护体"的状态标记，也为未来更深的引擎/水蛭子类型接入(直接拒绝嵌入)预留判定钩子。
//
//   本文件全部内容位于 modular_z121 根目录之下，符合项目硬性约束。
// ============================================================================

// 中文：★自定义特性★——"驱蛭护体"。作为本药的状态标记：
//   · 由成品试剂在代谢期间挂/摘，供本药的驱离逻辑作为"是否生效"的判定门；
//   · 为将来"水蛭尝试嵌入前先检查宿主是否 HAS_TRAIT(TRAIT_ANTILEECH) 而直接拒绝"这类更彻底的接入预留钩子。
//   WHY 用字符串常量：本代码库特性即以 #define TRAIT_X "x" 形式声明；经查引擎未定义 TRAIT_ANTILEECH，无冲突。
#define TRAIT_ANTILEECH "antileech"						// Custom trait: leeches won't bite the bearer.
// 中文：特性来源标签——保证只由"本药"挂/摘该特性，精确移除、互不干扰(可叠加其它来源而不误删)。
#define ANTILEECH_TRAIT_SOURCE "anti_leech_potion"		// Unique source tag for add/remove symmetry.


// ============================================================================
// 1) 成品试剂：防蚂蟥药水。非酒基 → 直接继承 /datum/reagent(不走酒基 refined_potion 基类)。
// ============================================================================
/datum/reagent/anti_leech_potion
	name = "防蚂蟥药水"										// In-game name (Anti-Leech Potion).
	description = "循死亡的气息、以清水与浆果毒药为底精炼的暗绿色药剂。饮下后周身弥漫一缕腐苦的死气，嗜血的水蛭再不愿附着吸咬。"	// Flavour + hint.
	reagent_state = LIQUID									// A liquid potion.
	color = "#3b4a2f"										// Murky poison-green.
	taste_description = "腐苦的死气"							// Taste flavour on drink.
	// 中文：消化速度——【每 1 单位维持 12 秒】。原理：reagents.metabolize() 每个 carbon 生命拍(2 秒)调用一次，
	//   每次消耗 metabolization_rate 单位 → 每单位维持 2/rate 秒；要 12 秒 → rate = 2/12 = 1/6 ≈ 0.167。
	metabolization_rate = REAGENTS_METABOLISM / 6			// ~1 unit per 12 seconds (spec: 12s/unit).

// 中文：代谢开始时(每瓶仅触发一次)——挂上"驱蛭护体"特性，立即清一次身上的吸血水蛭，并给出反馈。
/datum/reagent/anti_leech_potion/on_mob_metabolize(mob/living/M)
	. = ..()												// Base reagent setup first.
	if(!M)													// 错误处理：无有效目标则直接返回，避免空引用。
		return
	ADD_TRAIT(M, TRAIT_ANTILEECH, ANTILEECH_TRAIT_SOURCE)	// Mark the bearer as leech-warded.
	repel_biting_leeches(M)									// Immediately shake off any leech already biting.
	to_chat(M, span_notice("一缕腐苦的死气自我的血肉间渗出，嗜血的水蛭再不愿沾附上来。"))	// Feedback on drink.

// 中文：代谢期间每一拍——持续巡检并剥离新附上来的吸血水蛭，使"药效期间水蛭咬不动你"真正生效。
//   WHY 每拍都做：水蛭可能在两拍之间新附上；每 2 秒清一次，令其至多沾附极短时间即被甩落，无法完成一次有效吸血循环。
/datum/reagent/anti_leech_potion/on_mob_life(mob/living/carbon/M)
	if(M)													// 错误处理：目标有效才巡检(极端情况下 M 可能为空)。
		repel_biting_leeches(M)								// Sweep off any freshly-attached biting leech.
	return ..()												// Let the base handle metabolism/volume decay.

// 中文：代谢结束(药剂耗尽/被清除)时——摘掉本药施加的"驱蛭护体"来源并反馈；不影响其它来源(若有)。
/datum/reagent/anti_leech_potion/on_mob_end_metabolize(mob/living/M)
	if(M)													// 错误处理：目标有效才操作。
		REMOVE_TRAIT(M, TRAIT_ANTILEECH, ANTILEECH_TRAIT_SOURCE)	// Drop only THIS source's ward.
		to_chat(M, span_warning("那缕驱避水蛭的死气渐渐消散了。"))	// Feedback on expiry.
	return ..()												// Let the base finish up.

// 中文：核心驱离逻辑——把【正在吸血】的水蛭从饮用者身上剥离(落回其脚下地块，不再嵌入即停止吸血)。
//   WHY 只剥离"正在吸血"的：奇勒(cheele 注血)/深渊水蛭(abyssoid，blood_sucking=0 不吸血)属良性，不应误伤；
//   故仅处理 giving==FALSE(处于吸血模式) 且 blood_sucking>0(确实会抽血) 的水蛭。
/datum/reagent/anti_leech_potion/proc/repel_biting_leeches(mob/living/M)
	if(!M)													// 错误处理：无有效目标 → 无事可做。
		return
	if(!HAS_TRAIT(M, TRAIT_ANTILEECH))						// 防御性：仅在护体生效时驱离(理论上恒真，双保险)。
		return
	// 中文：先【快照】所有待剥离的水蛭再统一处理——因为剥离会修改肢体的 embedded_objects 列表，
	//   若边遍历边删会破坏迭代；快照可避免"在迭代中修改集合"的隐患。
	var/list/biters = list()								// Snapshot of blood-sucking leeches to detach.
	// --- 分支①：carbon(有肢体)——水蛭经 attack() 嵌入某个肢体的 embedded_objects 里 ---
	if(iscarbon(M))											// Reagent drinkers are carbons; leeches embed in bodyparts.
		var/mob/living/carbon/C = M							// Typed handle for bodyparts access.
		for(var/obj/item/bodypart/BP as anything in C.bodyparts)	// Each of the drinker's bodyparts.
			if(!BP)											// 错误处理：跳过空肢体槽。
				continue
			for(var/obj/item/natural/worms/leech/L in BP.embedded_objects)	// Each embedded leech there.
				if(L.giving)								// It's injecting blood (cheele) — benign, leave it.
					continue
				if(L.blood_sucking <= 0)					// It can't actually drain (abyssoid) — leave it.
					continue
				biters += L									// Mark this biting leech for removal.
	// --- 分支②：无肢体嵌入(simple_embedded_objects)——防御性兜底,涵盖非常规嵌入情形 ---
	for(var/obj/item/natural/worms/leech/L in M.simple_embedded_objects)	// Non-bodypart embeds (fallback).
		if(L.giving || L.blood_sucking <= 0)				// Skip benign / non-draining leeches.
			continue
		biters |= L											// Union-add (avoid duplicates).
	if(!length(biters))										// 无吸血水蛭 → 提前返回(常态,零开销)。
		return
	// 中文：逐个剥离——水蛭的 loc 即它咬入的肢体(见原版 leeches.dm)。用与水蛭"自我脱落"相同的
	//   bodypart.remove_embedded_object()：它会清掉 is_embedded 并把水蛭落到饮用者脚下地块。
	for(var/obj/item/natural/worms/leech/L in biters)		// Detach each marked biter.
		var/removed = FALSE									// Track whether removal succeeded.
		var/obj/item/bodypart/BP = L.loc					// A biting leech's loc is the bodypart it pierced.
		if(istype(BP))										// Bodypart-embedded case.
			removed = BP.remove_embedded_object(L)			// Same call the leech uses to fall off (drops to turf).
		if(!removed)										// 兜底：非肢体嵌入(或上面失败) → 用 mob 级移除。
			M.simple_remove_embedded_object(L)				// Fallback removal for simple/edge embeds.
	// 中文：一次性反馈(仅在确有水蛭被甩落时)，避免每拍空刷屏。
	to_chat(M, span_warning("附在身上的水蛭嫌恶地松了口，纷纷跌落。"))	// Feedback when leeches are shaken off.


// ============================================================================
// 2) 精炼配方：★按气味等级(气味档①)★ —— 5 级"死亡"气味 + 水70/毒药30 → 防蚂蟥药水。
//   触发气味"死亡"来自现成材料(浆果粉/洋甘菊/颠茄，其 pot 指向 berrypoison 配方)，不新增任何材料。
//   底料水70 + 普通毒药(berrypoison)30，无酒 → 成品非酒基。技能门槛：炼金 3 级(熟练/Journeyman)。
// ============================================================================
/datum/alch_refining_formula/anti_leech
	name = "防蚂蟥药水"										// Formula name.
	// 中文：★气味档①★ 要求"死亡"气味累计达到 5 点(即"5 级死亡气味")。
	//   如 浆果粉(major→berrypoison,3) + 洋甘菊(major→berrypoison,3)=6，或 浆果粉(3)+颠茄(med→berrypoison,2)=5 均满足。
	required_scent = "死亡"									// Require the "death" scent (berrypoison's smell)...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★复合底料★ 清水 70 + 普通毒药(浆果毒药)30，均为现成试剂,无酒 → 成品非酒基。
	//   注意 has_reagent 判定为【精确类型】,故普通毒药须写成具体产出类型 /datum/reagent/berrypoison。
	required_base = list(/datum/reagent/water = 70, /datum/reagent/berrypoison = 30)	// Base: 70 water + 30 common poison.
	// 中文：产物——50 单位防蚂蟥药水(单批产出 50)。
	output_reagents = list(/datum/reagent/anti_leech_potion = 50)	// Refined output: 50 units.
	// 中文：所需技能——炼金 3 级(熟练/Journeyman)。
	skill_required = SKILL_LEVEL_JOURNEYMAN					// Alchemy level 3 gate.
	// 中文：成功时的气味词。
	smells_like = "腐苦的死气"								// Success scent.


// 中文：清理本文件作用域内的局部宏,避免泄漏到全局编译环境(与框架文件同样的良好习惯)。
#undef TRAIT_ANTILEECH
#undef ANTILEECH_TRAIT_SOURCE
