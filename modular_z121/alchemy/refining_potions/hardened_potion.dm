// ============================================================================
// 硬化药剂 (Hardened Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文总览(WHY / HOW)：
//   配方：5 级"雨后泥土"气味 + 底料【清水 70 + 生命药水 30】 → 30 单位硬化药剂；技能：专家。
//   效果：药力持续期间，饮者【承受的钝击(Brute)伤害降低 20%】——皮肉如覆石甲，硬碰硬更耐揍。
//   消化速度：每 1 单位约维持 3 秒(见 metabolization_rate 注释)。
//
//   ★为什么选"雨后泥土"气味★：
//     该气味是原版【山岳肌力药剂(str_potion)】的 smells_like，且【尚未】被任何自定义精炼配方占用
//     (其余精炼药水已分别用掉 火焰/大地/平静/纯净…… 等气味)。题目要求"取一种未被使用、且等级 5 的
//     自定义药水气味"，"雨后泥土"正好满足；而"泥土/岩石"的意象也与"硬化"主题浑然一体。
//     现实可达性：ingredients.dm 中多种材料的 major/med/minor_pot 指向 str_potion，凭 2 份主气味材料
//     (3+3=6 ≥ 5)即可凑齐"5 级雨后泥土"，玩家可稳定复现。
//
//   ★机制落点(为什么这样实现)★：
//     人类承伤的最终结算在 species.dm 的 apply_damage()：
//         damage_amount = damage * hit_percent * brutemod * H.physiology.brute_mod   (BRUTE 分支)
//     其中 /datum/physiology/brute_mod 是"来自一切来源的钝击伤害系数"(默认 1)，且 physiology 数据
//     【不随换种族而清空】——是承伤减免最稳、最全覆盖的挂载点。因此本药在代谢期间把该系数乘以 0.80
//     (= 1 - 20%)，即可让【任何来源】的钝击伤害统一少吃两成；药效结束再原样除回，精确还原。
//     ——遵循 physiology 内 do_after_speed 的注释约定：临时改动只用 *= / /=，避免覆盖其它并发修正。
//
//   ★适用对象★：brute_mod 仅存在于【人类(human)的 physiology】上；非人类 carbon 无此数据，故防御减免
//     只对人类生效。非人类饮用不会报错，只是单纯代谢、不获得减伤(并给出提示)。
//
//   框架与精炼锅见 refining_framework.dm。本药【非酒基】(底料无任何乙醇)，故成品为普通 /datum/reagent。
//   全部代码位于 modular_z121 根目录之下，符合项目硬性约束。
// ============================================================================


// 中文：★减伤常量★——钝击伤害降低的比例(0.20 = 降低 20%)。抽为宏，便于日后统一调参、避免魔法数字散落。
// WHY: 题目明确"Reduces Brute damage taken by 20%"，此处集中定义一次，减伤幅度与提示文案共享同一来源。
#define HARDENED_POTION_BRUTE_REDUCTION 0.20		// Fraction of brute damage removed while active (20%).


// 中文：成品试剂——硬化药剂。继承 /datum/reagent/medicine(归入"药剂"大类，无酒精逻辑)。
//   通过在代谢期间下调 physiology.brute_mod 实现"钝击减伤 20%"，代谢结束精确还原。
/datum/reagent/medicine/hardened_potion
	name = "硬化药剂"											// In-game name (Hardened Potion).
	// 中文：检视/说明文本——点明"以清水与生命药水循雨后泥土之气精炼、令皮肉如石、少受钝击"的功效。
	description = "循雨后泥土的气息、以清水与生命药水精炼而成的灰褐色浓浆。饮下后皮肉隐隐泛起石纹般的坚硬触感，拳脚棍棒之类的钝击都难再伤其分毫。"	// Flavour + hint.
	reagent_state = LIQUID									// Drinkable liquid potion.
	color = "#8a8574"										// Earthen stone-grey (also tints the pot).
	taste_description = "湿土与冷石的粗粝"						// Taste flavour text.
	// 中文：★消化速度★——题目要求【每 1 单位 3 秒】。生命循环(SSmobs)每 2 秒触发一次 on_mob_life，
	//   而每次移除 metabolization_rate 单位；欲让 1 单位耗时 3 秒 → 每拍(2 秒)应移除 2/3 单位。
	//   故 rate = REAGENTS_METABOLISM * 2 / 3 ≈ 0.667 单位/拍 = 1 单位 / 3 秒。
	metabolization_rate = REAGENTS_METABOLISM * 2 / 3		// ~1 unit per 3 seconds (2s tick * 2/3 unit).
	// 中文：半透明显示，与其它药水观感统一。
	alpha = 200												// Slight transparency, matching other potions.
	// 中文：保存"本瓶实际施加的减伤乘子"(如 0.80)。代谢开始写入、结束时用它精确除回，
	//   即便日后调整减伤幅度也能一一对应还原；同一瓶药自始至终是同一试剂实例，实例变量即可胜任。
	var/applied_brute_mult = 0								// The exact multiplier we applied (0 = not applied yet).
	// 中文：标记本瓶药力是否已"正式生效"(通过了人类校验并成功施加减伤)，用于结束时给出恰当提示、避免误报。
	var/active = FALSE										// Did the potion actually take effect?

// 中文：代谢开始时(每瓶仅触发一次)——校验人类、下调 physiology.brute_mod、给出起效提示。
// WHY: brute_mod 仅挂在 human 的 physiology 上；只有人类才能获得减伤。非人类只提示、不改数据，安全返回。
/datum/reagent/medicine/hardened_potion/on_mob_metabolize(mob/living/carbon/M)
	. = ..()												// Let the medicine/reagent base set up first.
	// 中文：错误防护——目标缺失/正被删除则直接返回，避免空引用。
	if(!M || QDELETED(M))									// Guard against a missing/deleted mob.
		return
	// 中文：适用对象校验——非人类无 physiology.brute_mod，无从减伤：给出提示后照常代谢，不做任何改动。
	if(!ishuman(M))											// Only humans carry a physiology datum.
		to_chat(M, span_warning("这药似乎只对血肉之躯的凡人起效，你的身体并无变化。"))	// Non-human notice.
		return
	var/mob/living/carbon/human/H = M						// Narrow type to reach physiology.
	// 中文：稳健性防护——理论上 human 恒有 physiology，但仍空值校验，缺失则不施加、不报错。
	if(isnull(H.physiology))								// Defensive: no physiology -> nothing to modify.
		return
	// 中文：★核心★ 计算并施加减伤乘子(= 1 - 20% = 0.80)，用 *= 叠乘以尊重其它并发的 brute_mod 修正。
	applied_brute_mult = 1 - HARDENED_POTION_BRUTE_REDUCTION	// e.g. 0.80 -> take 80% brute (20% less).
	H.physiology.brute_mod *= applied_brute_mult			// Multiply in our reduction (stacks safely with others).
	// 中文：标记生效并提示玩家"皮肉如石"。
	active = TRUE											// Effect is now live.
	to_chat(M, span_notice("一层石纹般的坚硬感自皮下漫开，拳脚棍棒的钝击仿佛都被硬生生卸去了几分。"))	// Onset feedback.

// 中文：代谢结束(药剂耗尽/被清除)时——精确还原 physiology.brute_mod 并给出消退提示。
// WHY: 用 /= applied_brute_mult 除回我们当初乘上的那一份，恰好抵消，不影响期间其它效果对 brute_mod 的增减。
/datum/reagent/medicine/hardened_potion/on_mob_end_metabolize(mob/living/carbon/M)
	// 中文：仅当确曾生效、乘子有效、且对象仍为有效 human 时才还原，避免对无效目标误操作。
	if(active && applied_brute_mult > 0 && ishuman(M) && !QDELETED(M))	// Only revert what we really applied.
		var/mob/living/carbon/human/H = M					// Typed access.
		// 中文：physiology 仍可能因极端情形缺失，故再做一次空值防护后才除回。
		if(!isnull(H.physiology))							// Defensive: physiology still present?
			H.physiology.brute_mod /= applied_brute_mult	// Exactly undo our multiplier.
		to_chat(M, span_warning("皮下那层坚石般的护体之感渐渐软化、消散了。"))	// Fade feedback.
	// 中文：复位状态，避免残留标记在同类型对象复用/调试时误导。
	active = FALSE											// Reset live flag.
	applied_brute_mult = 0									// Reset stored multiplier.
	return ..()												// Let the base finish up (final volume cleanup, etc.).

// ============================================================================
// 配方：★按气味等级①★ 5 级"雨后泥土"气味 + 底料(清水 70 + 生命药水 30) → 硬化药剂 30。技能：专家。
// ----------------------------------------------------------------------------
// 中文：
//   · "雨后泥土"是【山岳肌力药剂(str_potion)】配方的气味，且未被其它精炼配方占用(题目要求"未使用的 5 级气味")。
//     带此气味、指向 str_potion 的现成材料计有多种(major=3 两种、med=2 一种、minor=1 三种)；
//     取 2 份主气味材料即得 6 ≥ 5，稳定满足"5 级雨后泥土"。
//   · 底料用【现成试剂】：清水 /datum/reagent/water 70 + 生命药水 /datum/reagent/medicine/healthpot 30。
//     总量 100 ≥ 精炼锅 waterneed(90)，足以煮沸开炼；且二者均为【具体类型】，与 find_refining_formula
//     的 has_reagent 精确匹配相符(生命药水正是原版"生命灵药"配方的产物 healthpot，非抽象基类)。
//   · 无任何乙醇 → 成品非酒基，故 output 直接注入普通试剂，不携带 boozepwr。
// ============================================================================
/datum/alch_refining_formula/hardened
	name = "硬化药剂"											// Formula name.
	// 中文：★气味档①★ 要求"雨后泥土"气味累计达到 5 点(即题目的"5 级未使用气味")。
	required_scent = "雨后泥土"								// Require the "petrichor" scent (str_potion, unused)...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★复合底料★ 清水 70 + 生命药水 30(均为现成试剂)。
	required_base = list(/datum/reagent/water = 70,			// 70 water...
						/datum/reagent/medicine/healthpot = 30)	// ...+ 30 Health Potion.
	// 中文：产物——30 单位硬化药剂。
	output_reagents = list(/datum/reagent/medicine/hardened_potion = 30)	// Refined output: 30u Hardened Potion.
	// 中文：所需技能——专家。
	skill_required = SKILL_LEVEL_EXPERT						// Expert gate.
	// 中文：成功时的气味词。
	smells_like = "坚石与湿土的粗粝气"							// Success scent.


// 中文：清理本文件作用域内的局部宏，避免"减伤比例"宏泄漏到全局编译环境、与他处同名定义冲突。
#undef HARDENED_POTION_BRUTE_REDUCTION
