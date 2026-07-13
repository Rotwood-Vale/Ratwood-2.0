// ============================================================================
// 虚弱药水 (Potion of Weakness) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文总览(WHY / HOW)：
//   配方：5 级"缓慢的微风"气味 + 底料【板油(leaf lard) 60】 → 30 单位虚弱药水；技能：熟练(炼金 3 级)。
//   效果：饮下后一段时间内——【力量 -8】(四肢发软、气力尽失，clamp 到下限 1，不会低于 1)。
//   消化速度：每 1 单位 30 秒(见 metabolization_rate 注释)；故 30 单位 ≈ 900 秒 ≈ 15 分钟的持续药效。
//   产量：30 单位。
//
//   ★为什么选"缓慢的微风"气味★：
//     "缓慢的微风"是原版【耐力毒药(stam_poison)】配方的 smells_like，且【尚未】被任何自定义精炼配方占用
//     (题目要求"取一种未被使用、且等级 5 的自定义药水气味")。它本属"毒药"一系、意象为"迟滞、乏力的气流"——
//     用一味【削弱耐力的毒药】之气去精炼出一味【令人虚弱、力量骤减】的药水，气味与药效在主题上相得益彰。
//     现实可达性：ingredients.dm 中【蒲公英(taraxacum)】的 major_pot 指向 stam_poison(3 点)、
//     【聚合草(symphitum)】的 med_pot 指向 stam_poison(2 点)，二者同投即得 3+2=5 ≥ 5，稳定凑齐"5 级缓慢的
//     微风"气味，玩家可复现，且无需新增任何材料。
//     (说明：为何不用力量药剂 str_potion 的气味"雨后泥土"这一更直白的反讽——那味气味已被【硬化药剂
//      hardened_potion】占用，不再"未使用"，故改取同样贴切且仍空置的"缓慢的微风"。)
//
//   ★机制落点(为什么这样实现)★：
//     效果由一个自定义【减益状态 /datum/status_effect/debuff/weakness_potion】承载，随药剂的代谢生命周期
//     "同生共死"——代谢开始时施加、每代谢拍刷新其计时(令其贯穿整个消化过程)、代谢结束时解除。
//     · 力量 -8：借用状态基类的 effectedstats 机制。★关键★：本汉化分支里 change_stat() 用 STATKEY_STR
//       ("力量")作为键做 switch 分发；若误用英文字面量 "strength" 作为键，会【匹配不到、静默失效】
//       (与愚人药水踩过的 INT 之坑同源)。故这里必须用 STATKEY_STR，才能真正把力量降下来(且基类会自动 clamp
//       到 [1,20]、并在移除时经 BUFSTR 缓冲精确还原——见 code/modules/mob/living/stats.dm 的 change_stat)。
//     · 纯表演性质的小反馈(发软、踉跄的 emote / 上手与解除的提示文本)，仅作观感、不影响机制。
//
//   框架与精炼锅见 refining_framework.dm。本药【非酒基】(底料为板油这类油脂、无任何乙醇)，故成品为普通
//   /datum/reagent，不携带 boozepwr。全部代码位于 modular_z121 根目录之下，符合项目硬性约束。
// ============================================================================


// 中文：★消化速度常量★——题面要求【每 1 单位 30 秒】。生命循环(SSmobs, wait=20)每 2 秒触发一次
//   on_mob_life，每次移除 metabolization_rate 单位；故"每单位耗时(秒) = 2 ÷ metabolization_rate"。
//   要 30 秒/单位 ⇒ metabolization_rate = 2 ÷ 30 = 1/15 ≈ 0.0667。抽为宏，便于日后统一调参。
#define WEAKNESS_POTION_SECONDS_PER_UNIT 30			// Digest one unit every 30 seconds.

// 中文：★力量惩罚常量★——题面要求"力量 -8"。抽为宏，逻辑与文案共用一个真值来源，避免改动时不一致。
#define WEAKNESS_POTION_STR_PENALTY 8				// Strength reduced by 8 while the potion lasts.


// ============================================================================
// 1) 减益状态：虚弱药水的效果本体(力量 -8)。
// 中文：继承 /datum/status_effect/debuff(其 status_type 已是 STATUS_EFFECT_REFRESH——重复施加只会刷新
//   计时、不会重复跑 on_apply，故可安全地每代谢拍施加一次以维持药效)。
// ============================================================================

// 中文：状态生效期间显示在屏幕上的提示图标(复用原版"饥饿/虚弱"档位图标 hunger3，其意象正是"身体撑不住了"，
//   与"虚弱"主题契合，且与状态基类共用同一 alert 图集，无需新增美术)。
/atom/movable/screen/alert/status_effect/weakness_potion
	name = "虚弱"											// Alert title.
	desc = "浑身……使不上劲……手脚都软了……"				// Flavour: sapped strength.
	icon_state = "hunger3"								// Reuse the existing "frail/weak" alert sprite.

/datum/status_effect/debuff/weakness_potion
	id = "weakness_potion"								// Unique id (drives the by-id refresh path).
	// 中文：★安全网计时★——正常情况下由药剂每 2 秒刷新一次；万一药剂被异常清除而未走 on_mob_end_metabolize，
	//   本状态也会在 1 分钟后自行到期解除，绝不会永久卡住玩家。
	duration = 1 MINUTES								// Safety-net duration; refreshed every 2s while digesting.
	status_type = STATUS_EFFECT_REFRESH					// Re-applying only refreshes the timer (never re-runs on_apply).
	// 中文：★力量 -8★——★必须用 STATKEY_STR("力量")作为键★，否则 change_stat 的 switch 匹配不到而静默失效
	//   (与愚人药水的 INT 之坑同源)。基类 on_apply/on_remove 会自动施加/还原，并把结果经 BUFSTR 缓冲
	//   clamp 在 [1,20](即最多降到 1，不会到 0 或负)，移除时精确还原。
	effectedstats = list(STATKEY_STR = -WEAKNESS_POTION_STR_PENALTY)	// -8 Strength (auto-clamped, auto-restored by base).
	alert_type = /atom/movable/screen/alert/status_effect/weakness_potion	// The on-screen indicator above.

// 中文：状态施加(每次"新建"实例时仅触发一次)——在基类施加力量惩罚后，给出"浑身发软"的文字反馈。
/datum/status_effect/debuff/weakness_potion/on_apply()
	. = ..()											// Base applies effectedstats (STR -8) & builds the alert; returns TRUE/FALSE.
	// 中文：错误处理——基类拒绝(返回 FALSE)或宿主非 /mob/living(无从承载状态)时，不再附加后续反馈。
	if(!. || !isliving(owner))							// Base rejected, or owner can't carry the effect.
		return .
	// 中文：施加成功的文字反馈(纯提示，不影响机制)。
	owner.visible_message(span_warning("[owner]的双肩骤然垮塌下来，四肢像被抽走了力气般发起软来。"), \
						span_userdanger("一股难言的虚脱感从骨髓里泛起，浑身的力气仿佛都被抽干了……"))	// Onset feedback.
	return .

// 中文：每一状态拍——偶尔来点"发软/踉跄"的小动作强化观感(纯表演，不改任何机制；力量惩罚由基类 effectedstats
//   在 on_apply 时一次性施加、并在 on_remove 时还原，无需每拍重复处理)。
/datum/status_effect/debuff/weakness_potion/tick()
	..()												// Let the base do its per-tick bookkeeping.
	// 中文：错误处理——宿主已失效则直接返回，避免对无效对象操作而运行时报错。
	if(QDELETED(owner) || !isliving(owner))				// Guard against a missing/invalid owner.
		return
	if(prob(8))											// Occasional "feeling weak" flavour.
		owner.emote(pick("gasp", "groan"))				// Gasping / groaning under the frailty (both are valid /mob/living emotes).


// ============================================================================
// 2) 成品试剂——虚弱药水。非酒基 → 直接继承 /datum/reagent(不走酒基 refined_potion 基类)。
//   设计：效果与药剂"同生共死"——代谢开始施加减益、每拍刷新其计时、代谢结束解除。
// ============================================================================
/datum/reagent/weakness_potion
	name = "虚弱药水"										// In-game name (Potion of Weakness).
	// 中文：检视/说明文本——点明"循耐力毒药之'缓慢的微风'气、以板油精炼、饮后短时力量大减"的功效。
	description = "一瓶循'缓慢的微风'之气(本是耐力毒药的气息)、以板油精炼而成的灰浊黏浆，触之滑腻、闻之滞涩。饮下后一股虚脱感会顺着骨髓蔓延开来，令人力量大减、四肢发软，连举手投足都变得沉重吃力。"	// Flavour + hint.
	reagent_state = LIQUID								// Drinkable liquid potion.
	color = "#9a9782"									// Murky greyish tan (a sapped, lifeless hue).
	taste_description = "一口滑腻、滞涩，尾韵泛着令人乏力的苦味"	// Taste flavour text (enervating dullness).
	// 中文：半透明显示，与其它自定义药水观感统一。
	alpha = 200											// Slight transparency, matching other potions.
	// 中文：★消化速度★= 每单位 30 秒(见上方宏推导)：REAGENTS_METABOLISM(=1) * 2 / 30 = 1/15 单位/拍。
	metabolization_rate = REAGENTS_METABOLISM * 2 / WEAKNESS_POTION_SECONDS_PER_UNIT	// 1/15 u per 2s-tick = 30s per unit.

// 中文：代谢开始时(每瓶仅触发一次)——校验目标后施加"虚弱"减益，并对异常给出诚实反馈。
/datum/reagent/weakness_potion/on_mob_metabolize(mob/living/M)
	. = ..()											// Let the base reagent set up first.
	// 中文：错误处理——目标缺失/正被删除则直接返回，避免对无效对象施加状态而运行时报错。
	if(!M || QDELETED(M))								// No valid drinker.
		return
	// 中文：错误处理——减益仅对 /mob/living 有意义(力量属性 STASTR 定义在 /mob/living)；非 living 无从承载，
	//   给出诚实提示后照常代谢、不施加效果。
	if(!isliving(M))									// Effect only applies to living mobs.
		to_chat(M, span_warning("虚弱药水在体内空流转，却找不到可供削弱的气力。"))	// Honest non-living notice.
		return
	// 中文：施加"虚弱"减益(力量 -8)。文字反馈由状态的 on_apply 负责。
	M.apply_status_effect(/datum/status_effect/debuff/weakness_potion)	// Apply the debuff (fresh instance).
	// 中文：错误处理——极少数情况下状态可能未成功建立；据此给出诚实反馈而非假装成功。
	if(!M.has_status_effect(/datum/status_effect/debuff/weakness_potion))	// Debuff somehow failed to attach?
		to_chat(M, span_warning("一阵无力感掠过四肢，却又很快退去，虚弱药水未能真正抽走你的气力。"))	// Honest failure message.

// 中文：每代谢一拍——刷新(REFRESH)减益的计时，使其贯穿整个消化过程(30 单位≈15 分钟)，随后交给父类完成常规代谢。
//   apply_status_effect 对已存在的 REFRESH 型状态只会重置计时、不会重复施加效果，故可安全地每拍调用。
/datum/reagent/weakness_potion/on_mob_life(mob/living/carbon/M)
	// 中文：错误处理——目标缺失/正被删除 → 跳过刷新，仍交给父类收尾以保持代谢推进(否则药剂会卡住不减少)。
	if(!M || QDELETED(M))								// Guard against a missing/deleting mob.
		return ..()
	// 中文：仅对有效 living 刷新；既能在初次未挂上时补挂，也能维持已挂上的计时。
	if(isliving(M))										// Living target?
		M.apply_status_effect(/datum/status_effect/debuff/weakness_potion)	// Create-or-refresh (REFRESH just resets the timer).
	return ..()											// Standard metabolism (consumes metabolization_rate, decrements volume).

// 中文：代谢结束(药剂耗尽/被清除)时——解除"虚弱"减益，让气力随药力散尽而恢复，并给出"力量回归"的提示。
/datum/reagent/weakness_potion/on_mob_end_metabolize(mob/living/M)
	// 中文：仅对有效目标解除并反馈(减益的 on_remove 会经 BUFSTR 精确还原力量)。
	if(M && !QDELETED(M))								// Valid target?
		M.remove_status_effect(/datum/status_effect/debuff/weakness_potion)	// Lift the debuff (restores strength).
		to_chat(M, span_notice("虚脱感如潮水般退去，气力重新回到了四肢百骸之中。"))	// Recovery feedback.
	return ..()											// Let the base finish up (final volume cleanup, etc.).


// ============================================================================
// 3) 精炼配方：★按气味等级(气味档①)★ —— 5 级"缓慢的微风"气味 + 底料(板油 60) → 虚弱药水 30。技能：熟练(炼金 3 级)。
// ----------------------------------------------------------------------------
// 中文：
//   · "缓慢的微风"是【耐力毒药(stam_poison)】配方的气味，且未被其它精炼配方占用(题目要求"未使用的 5 级气味")。
//     带此气味、指向 stam_poison 的现成材料有：蒲公英(taraxacum, major=3)、聚合草(symphitum, med=2)、
//     重楼(paris, minor=1)、缬草(valeriana, minor=1)…… 取【蒲公英 + 聚合草】即 3+2=5 ≥ 5，稳定满足"5 级"。
//   · 底料用【现成试剂】：板油(leaf lard) /datum/reagent/consumable/oil/tallow 60。板油是油脂、非乙醇，
//     故成品【非酒基】，output 直接注入普通试剂、不携带 boozepwr。
//   · ★注意★ has_reagent 判定为【精确类型】，故底料须写成具体产出类型 /datum/reagent/consumable/oil/tallow。
//   · ★煮沸阈值★：精炼锅的 waterneed 已在 refining_framework.dm 下调为 60(为愚人药水同款 60 单位底料而设)，
//     故本配方 60 单位的板油底料同样能正常起沸熬制，无需额外改动。
// ============================================================================
/datum/alch_refining_formula/weakness_potion
	name = "虚弱药水"										// Formula name.
	// 中文：★气味档①★ 要求"缓慢的微风"气味累计达到 5 点(即题目的"5 级未使用气味")。
	required_scent = "缓慢的微风"							// Require the "slow breeze" scent (stam_poison's smell, unused)...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points; taraxacum 3 + symphitum 2 = 5).
	// 中文：★单一底料★ 板油(leaf lard) 60(现成试剂；油脂非酒 → 成品非酒基)。
	required_base = list(/datum/reagent/consumable/oil/tallow = 60)	// Base: 60 leaf lard (tallow).
	// 中文：产物——30 单位虚弱药水(单批产出 30)。
	output_reagents = list(/datum/reagent/weakness_potion = 30)	// Refined output: 30u Potion of Weakness.
	// 中文：所需技能——熟练(炼金 3 级，SKILL_LEVEL_JOURNEYMAN == 3)。技能不足则整锅腐坏(框架 spoil_batch 处理)。
	skill_required = SKILL_LEVEL_JOURNEYMAN					// Alchemy Level 3 (Journeyman) gate.
	// 中文：成功时的气味词。
	smells_like = "乏力滞涩的浊气"							// Success scent.


// 中文：清理本文件作用域内的局部宏，避免它们泄漏到全局编译环境、与他处同名定义冲突。
#undef WEAKNESS_POTION_SECONDS_PER_UNIT
#undef WEAKNESS_POTION_STR_PENALTY
