// ============================================================================
// 克林卡特 (Klinkat) —— 一味【精炼药剂(酒基)】
// ----------------------------------------------------------------------------
// 触发：5 级"力量"气味 + 水50/葡萄酒50/板油20；技能：大师。
// 效果：代谢期间【免疫致命一击(暴击/重创)】；因底料含酒，亦会微醺上头。
// 框架见 refining_framework.dm。
// ============================================================================

// 中文：成品试剂——克林卡特(Klinkat)。继承酒基药剂基类，喝下会像喝酒一样上头；
//       并在【代谢持续期间】赋予【免疫致命一击(暴击/重创)】——持续刷新暴击抗性，使重创无从落下。
/datum/reagent/consumable/ethanol/refined_potion/klinkat
	name = "克林卡特"										// In-game name (Klinkat).
	description = "循力量的气味、以清水、醇酒与板油为底精炼的浓厚酒剂，名曰'克林卡特'。饮下后筋骨仿佛裹上一层无形钢壳，再凶险的致命一击也难以撕开。"	// Flavour + hint.
	color = "#6b4a8c"										// Deep arcane purple.
	taste_description = "沉重而辛烈的酒"						// Taste flavour.
	boozepwr = 30											// Fallback; overridden per-brew (base drink + skill).

// 中文：代谢开始时——先经父链按 data 设定酒劲，再赋予暴击抗性特性(它是 try_resist_critical() 生效的前提)。
//   来源标签用唯一字符串 "klinkat_potion"，以便结束时精确移除、且不误删该 mob 自带的暴击抗性。
/datum/reagent/consumable/ethanol/refined_potion/klinkat/on_mob_metabolize(mob/living/M)
	. = ..()												// refined_potion: pull boozepwr from data first.
	ADD_TRAIT(M, TRAIT_CRITICAL_RESISTANCE, "klinkat_potion")	// Enable crit resistance for the duration.

// 中文：每代谢一拍——清除"暴击抗性冷却"(crit_resistance_cd)，使抗性计数永不累积到失效阈值，从而【持续免疫暴击】。
//   原版机制：仅有 TRAIT_CRITICAL_RESISTANCE 时，try_resist_critical 只能挡下冷却窗口内"前几次"重创；
//   每拍把该冷却跟踪器重置，则每次重创都按"第一次"被挡下 ≈ 整段持续期间免疫致命一击。
/datum/reagent/consumable/ethanol/refined_potion/klinkat/on_mob_life(mob/living/carbon/M)
	if(!M || QDELETED(M))									// Guard against missing/deleting mob.
		return ..()
	M.remove_status_effect(/datum/status_effect/debuff/crit_resistance_cd)	// Keep crit immunity from lapsing.
	return ..()												// -> ethanol on_mob_life: apply drunkenness at brewed boozepwr.

// 中文：代谢结束(药剂耗尽/被清除)时——移除本药施加的暴击抗性来源，恢复原状。
/datum/reagent/consumable/ethanol/refined_potion/klinkat/on_mob_end_metabolize(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_CRITICAL_RESISTANCE, "klinkat_potion")	// Drop the crit immunity when it runs out.
	return ..()												// Let the base finish up.

// 中文：示例配方——★按气味等级★：要求【5 级"力量"气味】+ 复合底料(水50 + 葡萄酒50 + 板油20) → 克林卡特。
//       "力量"是【魔力灵药】配方的气味；带它的现成材料(指向魔力灵药)有：骨粉[major,3]、魔力花粉[major,3]、
//       浆果粉[med,2] 等；如 骨粉(3)+浆果粉(2)=5 即满足。
//       底料含葡萄酒(水50+酒50+板油20，酒占比≈42%) → 克林卡特为酒基药剂(酒底含量30×50/120≈12.5 + 大师5×2=10 → 酒劲 23，微醺)。
/datum/alch_refining_formula/klinkat
	name = "克林卡特"										// Formula name.
	// 中文：★气味档①★ 要求"力量"气味累计达到 5 点(即"5 份力量")。
	required_scent = "力量"									// Require the "power" scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★复合底料★ 水 50 + 葡萄酒 50 + 板油 20。
	required_base = list(/datum/reagent/water = 50, /datum/reagent/consumable/ethanol/wine = 50, /datum/reagent/consumable/oil/tallow = 20)	// Composite base.
	// 中文：产物——30 单位克林卡特(酒基药剂；因底料含葡萄酒，按"酒底+技能"附带酒劲)。
	output_reagents = list(/datum/reagent/consumable/ethanol/refined_potion/klinkat = 30)	// Refined alcoholic output.
	// 中文：所需技能——大师(同时抬高酒劲，见酒基设定)。
	skill_required = SKILL_LEVEL_MASTER						// Master gate (also feeds the alcohol strength).
	// 中文：成功气味词。
	smells_like = "厚重的酒香"								// Success scent.
