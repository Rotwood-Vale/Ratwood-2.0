// ============================================================================
// 飞行药水 (Flying Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文总览：
//   触发(气味)：5 级"清新空气"气味(对应原版"耐力灵药"配方的 smells_like)。
//   液体底料：清水 70 + 魔力药水 30(均为现成试剂；无酒 → 成品非酒基)。
//   产物：50 单位飞行药水。
//   技能：专家(Expert)。
//   效果：饮下后在【药剂尚在体内代谢的整段时间里】持续获得【飞行术】状态效果
//         (复用 spells/arcane/flight.dm 的 /datum/status_effect/buff/magic_flight)；
//         药剂代谢殆尽即落地。即"飞行随药效存续，而非固定时长"。
//   消化速度：每单位 12 秒(故 50 单位 ≈ 600 秒 ≈ 10 分钟的总飞行时间)。
//   框架见 refining_framework.dm；本文件只描述"成品试剂 + 其配方"。
//
//   为什么复用现成的飞行术状态效果而非另造一套：
//     spells/arcane/flight.dm 已经把"托离地面/落地/影子/耐力无限/续接刷新"等完整逻辑
//     封装进 /datum/status_effect/buff/magic_flight，并支持以【自定义时长】施加
//     (apply_status_effect(type, duration))。直接复用既保证效果"真正执行"，又避免重复实现。
//
//   如何"让飞行严格随药效存续"：
//     不再用固定计时——改为【代谢开始时】以"无限时长"(-1)施加飞行术(永不自行到期)，
//     【每代谢一拍】校验其仍在身上(被外力移除则补回)，【代谢结束时】(药剂耗尽)主动移除。
//     这样飞行的起止与药剂在体内的起止严格一致。
// ============================================================================

// 中文：消化速度——题面要求"每单位 12 秒"。集中成宏，便于日后调参。
// WHY: reagents.metabolize() 由 SSmobs 驱动，wait=20(即每 2 秒)调用一次，每次扣除 metabolization_rate 单位；
//      故"每单位耗时(秒) = 2 ÷ metabolization_rate"。要 12 秒/单位 ⇒ metabolization_rate = 2 ÷ 12 = 1/6 ≈ 0.1667。
#define FLYING_POTION_SECONDS_PER_UNIT 12					// Digest one unit every 12 seconds.

// 中文：成品试剂——飞行药水。非酒基 → 直接继承 /datum/reagent(不走酒基 refined_potion 基类)。
//   设计：飞行术与药剂"同生共死"——代谢开始施加(无限时长)、每拍补稳、代谢结束移除。
/datum/reagent/flying_potion
	name = "飞行药水"										// In-game name (Flying Potion).
	description = "循清新空气的气味、以清水与魔力药水为底精炼的轻盈药水。饮下后身体如羽毛般失重，可凌空飞行；药力散尽便缓缓落回地面。"	// Flavour + hint.
	reagent_state = LIQUID									// Liquid potion.
	color = "#bfe6ffcc"										// Pale sky-blue (airy).
	taste_description = "一阵掠过舌尖的清风"					// Taste flavour (a passing breeze).
	// 中文：消化速度 = 每单位 12 秒。基准：每 2 秒(SSmobs.wait=20)代谢一拍、每拍扣 REAGENTS_METABOLISM(=1) ⇒ 基准 2 秒/单位；
	//       乘以"基准拍秒数 2"再除以"目标 12 秒/单位"，即 1×2/12 = 1/6 ≈ 0.1667 单位/拍 ⇒ 恰好 12 秒/单位。
	metabolization_rate = REAGENTS_METABOLISM * 2 / FLYING_POTION_SECONDS_PER_UNIT	// 1/6 u per 2s-tick = 12s per unit.

// 中文：代谢开始时(每"一份"药剂仅触发一次)——校验目标后以【无限时长】施加飞行术，使其只随药剂存续、不自行到期。
/datum/reagent/flying_potion/on_mob_metabolize(mob/living/M)
	. = ..()												// Let the base reagent set up first.
	// 中文：错误处理——目标缺失/正在删除 → 直接返回，避免对无效对象施加效果而运行时报错。
	if(!M || QDELETED(M))									// No valid drinker.
		return
	// 中文：错误处理——飞行术状态效果仅对 /mob/living 有意义；非 living 不应、也无法承载该 buff。
	if(!isliving(M))										// Effect only applies to living mobs.
		return
	// 中文：记录是否已处于飞行术下——用于给出"续接"或"初次升空"的差异化提示(纯文字反馈)。
	var/already_flying = M.has_status_effect(/datum/status_effect/buff/magic_flight)	// Already aloft?
	// 中文：以"无限时长"挂上飞行术(见 ensure_flight)，使其只随药剂存续、永不自行到期。
	ensure_flight(M)										// Flight persists for the whole potion duration.
	// 中文：错误处理——极少数情况下状态效果可能未成功创建(如被其它系统阻止)；据此给出诚实反馈。
	if(!M.has_status_effect(/datum/status_effect/buff/magic_flight))	// Apply somehow failed?
		to_chat(M, span_warning("一股轻盈感涌起又骤然消散，飞行药水的魔力未能托起我。"))	// Honest failure message.
		return
	// 中文：成功反馈——区分"初次升空"与"续接已有飞行术"，纯文字提示，不影响机制。
	if(already_flying)										// Was already flying.
		to_chat(M, span_notice("飞行药水的轻盈在体内重新充盈，托举我的力量又续上了。"))	// Refresh feedback.
	else													// First time aloft from this drink.
		M.visible_message(span_notice("[M]的身体忽然变得轻飘飘的，缓缓离开了地面。"), span_notice("飞行药水的魔力托起了我，我飞了起来！"))	// Lift-off feedback.

// 中文：施加/维持飞行术并把它"钉成永久"——避免直接用 apply_status_effect(...,-1) 触发 magic_flight 的
//       refresh(-1)：那会把 duration 算成 world.time-1(过去) 而被 process() 立即移除(等于把飞行掐断)。
//   故：若已在飞(可能来自法术或上一口药)，直接把现有实例的 duration 设为 -1(永久)，并抑制"剩 10 秒"警告；
//       若尚未在飞，则以无限时长全新施加。返回该飞行术实例(失败为 null)。
// WHY: magic_flight 是 STATUS_EFFECT_REFRESH，重复 apply 会走 refresh 分支；而其 refresh 对 -1 处理有缺陷，
//      直接操作实例的 duration 才能稳妥地"钉成永久"，把起止完全交给本药剂的代谢生命周期。
/datum/reagent/flying_potion/proc/ensure_flight(mob/living/M)
	// 中文：取当前飞行术实例(若有)。has_status_effect 返回实例或 null。
	var/datum/status_effect/buff/magic_flight/FX = M.has_status_effect(/datum/status_effect/buff/magic_flight)	// Existing flight?
	if(FX)													// Already flying (spell or earlier sip).
		FX.duration = -1									// Pin to permanent (won't auto-expire while potion lasts).
		FX.ending_warning_sent = TRUE						// Suppress the "10s left" warning (irrelevant here).
		return FX											// Maintained.
	// 中文：尚未在飞——以无限时长(-1)全新施加(走 apply 的"全新创建"分支，不触发有缺陷的 refresh)。
	return M.apply_status_effect(/datum/status_effect/buff/magic_flight, -1)	// Fresh, permanent flight.

// 中文：每代谢一拍——只要药剂仍在体内，就保证飞行术仍挂在身上(被外力移除则补回并钉成永久)，
//       从而让飞行"严格随药效存续"；随后调用父类完成本拍的常规代谢(扣减 metabolization_rate)。
/datum/reagent/flying_potion/on_mob_life(mob/living/carbon/M)
	// 中文：错误处理——目标缺失/正在删除 → 跳过补稳，仍交给父类收尾以保持代谢推进。
	if(!M || QDELETED(M))									// Guard against missing/deleting mob.
		return ..()
	// 中文：每拍都确保飞行术在身且为永久(若被外力移除则补回)，使飞行贯穿整个药效期。
	ensure_flight(M)										// Re-assert flight while the potion lasts.
	return ..()												// Standard metabolism (consumes metabolization_rate).

// 中文：代谢结束(药剂耗尽/被清除)时——主动移除飞行术，让飞行随药效一同终止(落地由 magic_flight 的 on_remove 处理)。
/datum/reagent/flying_potion/on_mob_end_metabolize(mob/living/M)
	// 中文：错误处理——仅对有效目标移除，避免对无效对象操作报错。
	if(M && !QDELETED(M))									// Valid target?
		M.remove_status_effect(/datum/status_effect/buff/magic_flight)	// End flight when the potion is gone.
	return ..()												// Let the base finish up.

// 中文：精炼配方——★按气味等级★：要求【5 级"清新空气"气味】+ 复合底料(水70 + 魔力药水30) → 飞行药水。
//   "清新空气"是原版【耐力灵药】(stamina_potion)配方的 smells_like；带该气味的现成材料有：
//     金丝桃(hypericum)[major,3]、种子粉(seeddust)/风之精质(airdust)/西池烟叶粉(tobaccodust)/圣蓟(benedictus)[med,2]、
//     薄荷(mentha)[minor,1] 等。例：金丝桃(3)+种子粉(2)=5 即达成 5 级气味门槛(须为不同类型，原版禁止重复投料)。
/datum/alch_refining_formula/flying
	name = "飞行药水"										// Formula name.
	// 中文：★气味档①★ 要求"清新空气"气味累计达到 5 点(即题面的"5 份清新空气")。
	required_scent = "清新空气"								// Require the "fresh air" scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★复合底料★ 清水 70 + 魔力药水 30(均为现成试剂；不含酒 → 成品非酒基)。
	required_base = list(/datum/reagent/water = 70, /datum/reagent/medicine/manapot = 30)	// Composite base (water + mana potion).
	// 中文：产物——50 单位飞行药水。
	output_reagents = list(/datum/reagent/flying_potion = 50)	// Refined output (50 units).
	// 中文：所需技能——专家。技能不足则整锅腐坏(框架 spoil_batch 处理)。
	skill_required = SKILL_LEVEL_EXPERT						// Expert gate.
	// 中文：成功气味词。
	smells_like = "拂面清风"									// Success scent.

// 中文：清理本文件作用域内的局部宏，避免泄漏到全局编译环境。
#undef FLYING_POTION_SECONDS_PER_UNIT
