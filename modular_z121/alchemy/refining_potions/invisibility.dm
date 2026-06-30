// ============================================================================
// 隐身药水 (Invisibility Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 触发：5 级"纯净"气味 + 水70/魔力药水30；技能：大师。
// 效果：代谢期间【隐身】(复用原版隐形术机制：alpha→0 + MT_INVISIBILITY 计时器)。
// 框架见 refining_framework.dm。
// ============================================================================

// 中文：成品试剂——隐身药水。复用原版【隐形术】的隐身机制：把 alpha 渐隐为 0，并把 mob_timers[MT_INVISIBILITY]
//       推到未来——只要该计时器在未来，原版 update_sneak_invis() 就会让其保持隐形(rogue_sneaking)。
//       每代谢一拍刷新该计时器(并在被某些动作显形后重新淡隐)，使隐身【持续整个代谢期】；药剂耗尽即现形。
/datum/reagent/invisibility_potion
	name = "隐身药水"										// In-game name (Invisibility Potion).
	description = "循纯净的气味、以清水与魔力药水为底精炼的澄澈药水。饮下后身形如薄雾般淡去，隐没于无形之中。"	// Flavour + hint.
	reagent_state = LIQUID									// Liquid potion.
	color = "#cfe8ffaa"										// Pale, near-transparent blue.
	taste_description = "几乎尝不出的清冽"					// Taste flavour (almost nothing).
	// 中文：消化速度——【每 1 单位约维持 1 秒】。代谢每约 2 秒一拍消耗 rate 单位 → 1 单位维持 2/rate 秒；要 1 秒 → rate = 2。
	metabolization_rate = 2 * REAGENTS_METABOLISM			// ~1 unit per 1 second.

// 中文：代谢开始时——渐隐为 0、设置隐形计时器、并调用 update_sneak_invis() 即时进入隐形态。
/datum/reagent/invisibility_potion/on_mob_metabolize(mob/living/M)
	. = ..()												// Base setup.
	// 中文：提示与淡隐(1 秒渐隐到全透明)。
	M.visible_message(span_warning("[M]开始在空气中渐渐淡去！"), span_notice("我的身形开始隐没。"))	// Fade-out message.
	animate(M, alpha = 0, time = 1 SECONDS, easing = EASE_IN)	// Visually turn invisible.
	// 中文：把隐形计时器推到未来；原版 update_sneak_invis 据此维持隐形。每拍会刷新它(见 on_mob_life)。
	M.mob_timers[MT_INVISIBILITY] = world.time + 10 SECONDS	// Keep-alive window (refreshed each life tick).
	M.update_sneak_invis()									// Enter the sneaking/invisible state now.

// 中文：每代谢一拍——刷新隐形计时器(防止中途到期)，并在因攻击/受击等被显形后重新淡隐，确保"持续隐身"。
/datum/reagent/invisibility_potion/on_mob_life(mob/living/carbon/M)
	if(!M || QDELETED(M))									// Guard against missing/deleting mob.
		return ..()
	// 中文：持续把计时器顶在未来，使隐身贯穿整个代谢期(代谢结束才由 end_metabolize 显形)。
	M.mob_timers[MT_INVISIBILITY] = world.time + 10 SECONDS	// Refresh keep-alive.
	// 中文：若某些动作把 alpha 调回(显形)，则重新淡隐并刷新隐形态。
	if(M.alpha != 0)										// Got revealed by some action?
		animate(M, alpha = 0, time = 0.5 SECONDS)			// Fade back to invisible.
		M.update_sneak_invis()								// Re-assert the invisible state.
	return ..()												// Standard metabolism finish.

// 中文：代谢结束(药剂耗尽/被清除)时——清空隐形计时器并以 reset=TRUE 强制现形(恢复 alpha)。
/datum/reagent/invisibility_potion/on_mob_end_metabolize(mob/living/M)
	M.mob_timers[MT_INVISIBILITY] = 0						// Drop the invisibility keep-alive.
	M.update_sneak_invis(TRUE)								// Force reveal + restore alpha (reset path).
	M.visible_message(span_warning("[M]重新显现在众人眼前。"), span_notice("我重新显露了身形。"))	// Reappear message.
	return ..()												// Let the base finish up.

// 中文：示例配方——★按气味等级★：要求【5 级"纯净"气味】+ 复合底料(水70 + 魔力药水30) → 隐身药水。
//       "纯净"是【强效解毒剂】配方的气味；带它的现成材料(指向强效解毒剂)有：银粉[major,3]、尾骨[major,3]、
//       精制盐[med,2] 等；如 银粉(3)+精制盐(2)=5 即满足。
//       底料：水70 + 魔力药水30(均为现成试剂；魔力药水在此作为液体底料组分，无酒 → 成品非酒基)。
/datum/alch_refining_formula/invisibility
	name = "隐身药水"										// Formula name.
	// 中文：★气味档①★ 要求"纯净"气味累计达到 5 点(即"5 份纯净")。
	required_scent = "纯净"									// Require the "purity" scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★复合底料★ 水 70 + 魔力药水 30。
	required_base = list(/datum/reagent/water = 70, /datum/reagent/medicine/manapot = 30)	// Composite base (water + mana potion).
	// 中文：产物——30 单位隐身药水。
	output_reagents = list(/datum/reagent/invisibility_potion = 30)	// Refined output.
	// 中文：所需技能——大师。
	skill_required = SKILL_LEVEL_MASTER						// Master gate.
	// 中文：成功气味词。
	smells_like = "缥缈无形"									// Success scent.
