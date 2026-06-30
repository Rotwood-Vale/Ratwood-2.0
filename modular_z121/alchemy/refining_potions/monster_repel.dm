// ============================================================================
// 驱兽药水 (Monster-Repelling Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 触发：5 级"平静"气味 + 水70/魔力药水30；技能：大师。
// 效果：代谢期间，饮用者采集(踩草丛/折树枝等)不再触发伏击刷怪(ambushable=FALSE)。
// 框架见 refining_framework.dm。
// ============================================================================

// 中文：成品试剂——驱兽药水。原版"伏击系统"在玩家采集(踩踏草丛/折断树枝/采石采纤等)时调用
//       consider_ambush()，并由 get_will_block_ambush() 判定：若该 mob 的 ambushable() 为假即直接拦下、
//       不刷怪。故本药在【代谢期间】把饮用者的 ambushable 置为 FALSE → 采集不再凭空引出怪物；结束即还原。
/datum/reagent/monster_repel_potion
	name = "驱兽药水"										// In-game name (Monster-Repelling Potion).
	description = "循平静的气味、以清水与魔力药水为底精炼的安神药水。饮下后周身萦绕一缕宁和气息，蛰伏的野兽与怪物再不会因你的惊扰而扑出。"	// Flavour + hint.
	reagent_state = LIQUID									// Liquid potion.
	color = "#8fbf8f"										// Calm sage green.
	taste_description = "草木的宁和"							// Taste flavour.
	metabolization_rate = REAGENTS_METABOLISM				// Standard metabolism (controls duration).
	// 中文：保存施加前的 ambushable 原值，结束时精确还原(无论该 mob 原本可否被伏击)。
	//   同一瓶药从代谢开始到结束是同一个试剂实例，故用实例变量保存/读取即可，无需 data。
	var/prev_ambushable = TRUE								// Saved prior ambush state.

// 中文：代谢开始时——记录原 ambushable 并置 FALSE，使采集动作不再触发伏击刷怪。
/datum/reagent/monster_repel_potion/on_mob_metabolize(mob/living/M)
	. = ..()												// Base setup.
	prev_ambushable = M.ambushable							// Remember the prior state.
	M.ambushable = FALSE									// Suppress ambush spawns for the duration.
	to_chat(M, span_notice("一缕宁和的气息萦绕周身，蛰伏的野兽仿佛不再留意到我。"))	// Feedback on drink.

// 中文：代谢结束(药剂耗尽/被清除)时——还原 ambushable 原值。
/datum/reagent/monster_repel_potion/on_mob_end_metabolize(mob/living/M)
	M.ambushable = prev_ambushable							// Restore the prior ambush state.
	to_chat(M, span_warning("那缕驱避野兽的宁和气息渐渐消散了。"))	// Feedback on expiry.
	return ..()												// Let the base finish up.

// 中文：示例配方——★按气味等级★：要求【5 级"平静"气味】+ 复合底料(水70 + 魔力药水30) → 驱兽药水。
//       "平静"是【七叶草药剂】配方的气味；带它的现成材料(指向七叶草药剂)有：艾蒿[major,3]、炼金奥兹姆[med,2]；
//       如 艾蒿(3)+炼金奥兹姆(2)=5 即满足。
//       底料：水70 + 魔力药水30(均为现成试剂，无酒 → 成品非酒基)。
/datum/alch_refining_formula/monster_repel
	name = "驱兽药水"										// Formula name.
	// 中文：★气味档①★ 要求"平静"气味累计达到 5 点(即"5 份平静")。
	required_scent = "平静"									// Require the "calm" scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★复合底料★ 水 70 + 魔力药水 30。
	required_base = list(/datum/reagent/water = 70, /datum/reagent/medicine/manapot = 30)	// Composite base (water + mana potion).
	// 中文：产物——30 单位驱兽药水。
	output_reagents = list(/datum/reagent/monster_repel_potion = 30)	// Refined output.
	// 中文：所需技能——大师。
	skill_required = SKILL_LEVEL_MASTER						// Master gate.
	// 中文：成功气味词。
	smells_like = "宁和的草木气"								// Success scent.
