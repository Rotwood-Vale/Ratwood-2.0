// ============================================================================
// 媚药 (Aphrodisiac, forced estrus) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 触发：5 级"炽热的甜香"气味 + 情欲液(精液)100；技能：专家。
// 效果：饮者被迫发情并持续高潮，直到与他人交合方能解除(或药力代谢殆尽)；仅对开启 ERP 的玩家生效。
// 框架见 refining_framework.dm。沿用原版催情机制(sexcon.aphrodisiac，参见余烬酒)。
// ============================================================================

// 中文：成品试剂——媚药。沿用原版"催情"机制(sexcon.aphrodisiac 倍率，参见余烬酒)，但更猛烈：
//       代谢期间强制【发情】(aphrodisiac 倍率拉高、欲望被顶满)，由 sexcon 的被动射精逻辑持续触发【高潮】；
//       直到饮用者【与他人发生性行为】(current_action 进行中且 target 非己)，药力即被清除；否则维持到药剂代谢殆尽。
//   ★合意前提：与原版催情试剂一致，仅对开启了 ERP(prefs.sexable) 的玩家生效；否则直接清除、无任何效果。
/datum/reagent/forced_estrus_aphrodisiac
	name = "媚药"											// In-game name (aphrodisiac).
	description = "循炽热甜香、以情欲液为底精炼的绯红药液。饮下后情潮翻涌、欲火难耐，唯有与人交合方能平息。"	// Flavour + hint.
	reagent_state = LIQUID									// Liquid potion.
	color = "#c71f5a"										// Hot pink-red.
	taste_description = "炽烈的甜香"							// Taste flavour.
	metabolization_rate = 0.1 * REAGENTS_METABOLISM			// Slow burn -> a lasting duration (the fallback timer).
	// 中文：标记是否已施加 aphrodisiac 加成，确保结束时只精确扣除我们加过的那一份。
	var/applied = FALSE										// Did we add our aphrodisiac bonus?

// 中文：代谢开始时——(合意+人类前提满足后)拉高发情倍率，进入强制发情态。
/datum/reagent/forced_estrus_aphrodisiac/on_mob_metabolize(mob/living/carbon/human/C)
	..()
	// 中文：仅对开启 ERP 的人类生效；否则清空体积、直接失效(尊重玩家意愿，与原版催情试剂同例)。
	if(!ishuman(C) || !C?.client?.prefs?.sexable)			// Consent / human gate.
		volume = 0											// Purge: no effect.
		return
	C.sexcon.aphrodisiac += 2								// Strong forced estrus (disables resist/freeze).
	applied = TRUE											// Remember to remove it on end.
	to_chat(C, "<span class='aphrodisiac'>一股滚烫的情潮自小腹炸开，瞬间席卷全身——我发情了，而且根本停不下来！</span>")	// Onset.

// 中文：每代谢一拍——把欲望顶满以持续诱发高潮；若已与他人交合则清除药力。
/datum/reagent/forced_estrus_aphrodisiac/on_mob_life(mob/living/carbon/human/C)
	// 中文：非人类无 sexcon，直接交回父级。
	if(!ishuman(C))											// Only humans have a sexcon.
		return ..()
	// 中文：中途若关闭了 ERP，立即失效清除。
	if(!C?.client?.prefs?.sexable)							// No longer consenting?
		volume = 0											// Purge.
		return ..()
	var/datum/sex_controller/S = C.sexcon					// The sexcon controller.
	// 中文：解除条件——正与【他人】进行性行为(有进行中的动作且对象不是自己)，药力消退。
	if(S.current_action != null && S.target && S.target != C)	// Partnered sex in progress?
		to_chat(C, "<span class='love_high'>交合的快意终于平息了体内的躁动，药力随之消退……</span>")	// Relief.
		volume = 0											// Purge -> on_mob_end_metabolize restores the multiplier.
		return ..()
	// 中文：强制发情/持续高潮——解冻并把欲望顶到上限；sexcon 的被动射精逻辑会据此持续诱发高潮。
	S.arousal_frozen = FALSE									// Estrus can't be frozen.
	S.set_arousal(MAX_AROUSAL)								// Peg arousal at max -> continuous passive orgasms.
	if(prob(15))											// Occasional heavy moan for flavour.
		C.emote("sexmoanhvy", forced = TRUE)
	return ..()

// 中文：代谢结束(药剂耗尽/被清除/交合解除)时——扣除我们加过的发情倍率，恢复常态。
/datum/reagent/forced_estrus_aphrodisiac/on_mob_end_metabolize(mob/living/carbon/human/C)
	// 中文：仅在确实加过时才扣除，避免误扣到 0 以下。
	if(applied && ishuman(C) && C?.sexcon)					// Only undo what we applied.
		C.sexcon.aphrodisiac -= 2							// Remove our forced-estrus bonus.
		applied = FALSE
	..()

// 中文：示例配方——★按气味等级★：要求【5 级"炽热的甜香"气味】+ 单一底料(情欲液 100) → 媚药。
//       "炽热的甜香"是【催情酒】配方的气味；带它的现成材料(指向催情酒)有：肌腱[major,3]、玫瑰[med,2]、
//       沼泽烟叶粉[med,2] 等；如 肌腱(3)+玫瑰(2)=5 即满足。
//       注：与原版【催情酒】(同样"炽热的甜香"气味，但以清水为底回退产出余烬酒)以【液体底料】区分。
/datum/alch_refining_formula/aphrodisiac_forced
	name = "媚药"											// Formula name.
	// 中文：★气味档①★ 要求"炽热的甜香"气味累计达到 5 点(即"5 份炽热甜香")。
	required_scent = "炽热的甜香"							// Require the "sweet heat" scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★单一底料★ 情欲液 100(性活动体液；精液 /datum/reagent/erpjuice/cum)。
	required_base = list(/datum/reagent/erpjuice/cum = 100)	// Single base: 100 lust-fluid (semen).
	// 中文：产物——50 单位媚药。
	output_reagents = list(/datum/reagent/forced_estrus_aphrodisiac = 50)	// Refined output.
	// 中文：所需技能——专家。
	skill_required = SKILL_LEVEL_EXPERT						// Expert gate.
	// 中文：成功气味词。
	smells_like = "勾人的甜香"								// Success scent.
