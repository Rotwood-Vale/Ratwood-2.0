// ============================================================================
// 暖心酒剂 (Heart-warming Tonic) —— 一味【精炼药剂(酒基)】
// ----------------------------------------------------------------------------
// 触发：5 级"春日"气味 + 葡萄酒 90；技能：学徒。
// 效果：饮用提振心情(负压力)；因底料为酒，故同时像喝酒一样微醺上头。
// 框架(配方基类/炼药锅/酒基基类)见 refining_framework.dm；本文件只放本药的成品试剂与配方。
// ============================================================================

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
	// 中文：消化速度——【每 1 单位约维持 6 秒】。1 单位维持 2/rate 秒；要 6 秒 → rate = 2/6 = 1/3 ≈ 0.333。
	//   (覆盖父类乙醇默认的 0.5；正常无 baotha_revelry 世界特性时按此生效。)
	metabolization_rate = REAGENTS_METABOLISM / 3			// ~1 unit per 6 seconds.

// 中文：每代谢一拍——先给饮用者提振心情，再交由父链(酒基→乙醇)施加醉酒效果。
/datum/reagent/consumable/ethanol/refined_potion/heartwarming_tonic/on_mob_life(mob/living/carbon/M)
	if(!M || QDELETED(M))									// Guard against missing/deleting mob.
		return ..()
	if(M.stat == CONSCIOUS)									// Only conscious mobs feel mood.
		M.add_stress(/datum/stressevent/heartwarming_tonic)	// Apply the positive mood.
	return ..()												// -> ethanol on_mob_life: apply drunkenness at brewed boozepwr.

// 中文：示例配方——★按气味等级★(气味档①)：要求【5 级"春日"(春季)气味】+ 单一葡萄酒底料 → 暖心酒剂。
//       不镜像任何现成配方，纯靠气味等级。带"春日"气味的现成材料：玫瑰、沼泽烟叶粉(各 3 级)，
//       两味同投即 6 点 >= 5，满足"5 级春日气味"。
/datum/alch_refining_formula/heart_tonic
	name = "暖心酒剂"										// Formula name.
	// 中文：★气味档①★ 要求"春日"气味累计达到 5 点(即"5 级春日气味")。无需指定任何现成配方。
	required_scent = "春日"									// Require the spring scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★单一替代底料★ 只用葡萄酒 90(完全不用水)。
	required_base = list(/datum/reagent/consumable/ethanol/wine = 90)	// Single non-water base.
	// 中文：产物——50 单位暖心酒剂(酒基药剂；因底料为葡萄酒，出炉时会按本配方技能附带酒劲)。
	output_reagents = list(/datum/reagent/consumable/ethanol/refined_potion/heartwarming_tonic = 50)	// Refined alcoholic output.
	// 中文：成功气味词。
	smells_like = "醇酒暖意"									// Success scent.
	// 中文：本配方为【酒基】(纯葡萄酒底，占比100%，boozepwr 30)：成品喝下会像喝酒一样上头。
	//       酒劲＝酒底含量30(纯酒) + 技能加成(学徒2×2=4) = 34(微醺)。换更烈的酒、或提高酒在底料中的占比，酒劲随之增强。
	skill_required = SKILL_LEVEL_APPRENTICE					// Skill gate (also feeds the alcohol strength).
