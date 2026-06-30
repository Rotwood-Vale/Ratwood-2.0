// ============================================================================
// 温酒 (Warm Wine) —— 一味【精炼药剂(酒基)】
// ----------------------------------------------------------------------------
// 触发：5 级"甜浆果"气味 + 水50/葡萄酒50；技能：专家。
// 效果：代谢期间【免疫寒冷】(TRAIT_RESISTCOLD)；因底料含酒，亦会微醺上头。
// 框架见 refining_framework.dm。
// ============================================================================

// 中文：成品试剂——温酒(Warm wine)。继承酒基药剂基类，故喝下会像喝酒一样上头(酒劲随配方技能/酒底而定)；
//       并在【代谢持续期间】赋予【抗寒】——免疫寒冷伤害，待药剂代谢殆尽即消失。
/datum/reagent/consumable/ethanol/refined_potion/warm_wine
	name = "温酒"											// In-game name (Warm wine).
	description = "循甜浆果的气味、以清水与醇酒各半为底精炼的温热酒剂。一股暖流自腹中升起，将彻骨的寒意尽数驱散。"	// Flavour + hint.
	color = "#9b3b3b"										// Warm mulled-wine red.
	taste_description = "暖暖的香料酒"						// Taste flavour.
	boozepwr = 30											// Fallback; overridden per-brew (base drink + skill).

// 中文：代谢开始时——先经父链按 data 设定酒劲，再赋予"抗寒"特性。
//   来源标签用唯一字符串 "warm_wine_potion"，以便结束时精确移除、且不会误删该 mob 自带(如哥布林)的抗寒。
/datum/reagent/consumable/ethanol/refined_potion/warm_wine/on_mob_metabolize(mob/living/M)
	. = ..()												// refined_potion: pull boozepwr from data first.
	// 中文：赋予抗寒——人/猴/亡魂等的生命循环在 HAS_TRAIT(TRAIT_RESISTCOLD) 时跳过寒冷伤害，即"免疫寒冷"。
	ADD_TRAIT(M, TRAIT_RESISTCOLD, "warm_wine_potion")		// Cold immunity for the potion's duration.

// 中文：代谢结束(药剂耗尽/被清除)时——移除本药施加的抗寒来源，恢复原状。
/datum/reagent/consumable/ethanol/refined_potion/warm_wine/on_mob_end_metabolize(mob/living/M)
	// 中文：仅移除"温酒"这一来源；若该 mob 本就自带抗寒(如哥布林)，不受影响。
	REMOVE_TRAIT(M, TRAIT_RESISTCOLD, "warm_wine_potion")	// Drop the cold immunity when it runs out.
	return ..()												// Let the base finish up.

// 中文：示例配方——★按气味等级★：要求【5 级"甜浆果"气味】+ 复合底料(水50 + 葡萄酒50) → 温酒。
//       "甜浆果"是【生命药水】配方的气味；带它的现成材料(指向生命药水)有：聚合草[major,3]、荨麻[major,3]、
//       缬草[major,3]、蒲公英[med,2]、内脏[med,2]、尾骨[med,2] 等；如 聚合草(3)+蒲公英(2)=5 即满足。
//       底料含葡萄酒(水50+酒50，占比50%) → 温酒为酒基药剂(酒底含量30×0.5=15 + 专家4×2=8 → 酒劲 23，微醺)。
/datum/alch_refining_formula/warm_wine
	name = "温酒"											// Formula name.
	// 中文：★气味档①★ 要求"甜浆果"气味累计达到 5 点(即"5 份甜浆果")。
	required_scent = "甜浆果"								// Require the sweet-berry scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★复合底料★ 水 50 + 葡萄酒 50(各半)。
	required_base = list(/datum/reagent/water = 50, /datum/reagent/consumable/ethanol/wine = 50)	// Composite base (half water, half wine).
	// 中文：产物——50 单位温酒(酒基药剂；因底料含葡萄酒，按"酒底+技能"附带酒劲)。
	output_reagents = list(/datum/reagent/consumable/ethanol/refined_potion/warm_wine = 50)	// Refined alcoholic output.
	// 中文：所需技能——专家(同时抬高酒劲，见酒基设定)。
	skill_required = SKILL_LEVEL_EXPERT						// Expert gate (also feeds the alcohol strength).
	// 中文：成功气味词。
	smells_like = "温热的果酒香"								// Success scent.
