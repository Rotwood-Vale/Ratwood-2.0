// ============================================================================
// 麻痹毒药 (Paralytic Poison) —— 一味【精炼药剂(非酒·毒药)】
// ----------------------------------------------------------------------------
// 中文总览（为什么这样设计 / 如何落实）：
//   触发(气味)：★5 级"恐惧"气味★。"恐惧"是原版【强效魔力灵药】(big_mana_potion)配方的 smells_like，
//               此前【尚无任何自定义精炼药剂占用】，符合题面"任取一种未被占用的自定义药水(5 级)气味"的
//               要求；而"恐惧"意象——令人僵直、动弹不得的惊惧——与一味【使人麻痹瘫软】的毒药主题高度契合。
//               现实可达性：ingredients.dm 中【纯净精质(magicdust)】的 major_pot 指向 big_mana_potion(3 点)、
//               【金粉(golddust)】的 major_pot 亦指向 big_mana_potion(3 点)，二者同投即得 3+3=6 ≥ 5，稳定凑齐
//               "5 级恐惧"气味(须为不同类型，原版禁止重复投料)，玩家可复现，且无需新增任何材料。
//   液体底料：清水 50 + 板油(tallow/leaf lard) 20 + 毒药(berrypoison) 30(题面"50 水 + 20 板油 + 30 毒药")。
//             三者皆为现成试剂、且都不含酒 → 成品为【非酒基】药剂(直接继承 /datum/reagent，不携带 boozepwr)。
//             ★注意★ has_reagent 判定为【精确类型】，故底料须写成具体产出类型(如 /datum/reagent/berrypoison)。
//   技能要求：炼金 4 级(SKILL_LEVEL_EXPERT 专家)——即题面"Alchemy-Level4"。技能不足则整锅腐坏(框架 spoil_batch)。
//   产物：30 单位麻痹毒药。
//   消化速度：每单位 6 秒(故 30 单位 ≈ 180 秒 ≈ 3 分钟的持续麻痹)。
//
//   ★效果——按饮用者【体质(constitution / endurance)】分档的麻痹(题面三档)★，只在药剂尚在体内代谢期间生效：
//     ① 体质 18-20(最能抵抗)：仅【舌头发麻】——无法说话。
//     ② 体质 14-17(中等)：在①之上，【手臂亦发麻】——无法拾取或使用任何物品。
//     ③ 体质 ≤13(最脆弱)：【周身发麻】——当场瘫倒在地，无法移动、无法说话、无法做出任何其它动作。
//     (档位在【饮下(代谢开始)那一刻】按体质锁定：毒性一旦渗入体内，其麻痹程度就由当时的体质决定——
//      符合直觉，也让实现稳健；见 apply_paralysis_effects 里的注释。)
//
//   ★为什么用这些引擎机制来"真正落实"上述效果(而非另造系统)★：
//     · 无法说话(所有档)——TRAIT_MUTE：say.dm 检查它即直接闭口(与气化之躯药水同源做法)。
//     · 无法拾取/使用物品(中/低档)——监听 COMSIG_MOB_CLICKON 并返回 COMSIG_MOB_CANCEL_CLICKON。该信号在
//       /mob/ClickOn 最前端(click.dm)发出、早于一切攻击/拾取/使用分发；一旦取消，所有鼠标点击(攻击/拾取/
//       使用/点选式施法)全被拦下——恰好对应"手臂发麻、拿不起也用不了东西"。而【键盘移动】不经 ClickOn，故
//       中档("手麻但仍能走动")的移动不受影响(与气化之躯的"只能移动"拦截同源)。
//     · 当场瘫倒、无法移动/行动(低档)——Paralyze()：施加 STATUS_EFFECT_PARALYZED(其定义即"无法移动、无法
//       使用物品、无法站起"，见 __DEFINES/status_effects.dm)，使其瘫倒在地。再叠加 TRAIT_EMOTEMUTE(禁一切
//       动作 emote，emotes.dm 检查它)与 TRAIT_SPELLCOCKBLOCK(禁动作栏主动施法，spell.dm cast_check 检查它)，
//       连同上面的 TRAIT_MUTE(禁言)与点击拦截(禁一切手部操作)，共同兑现"不能移动、说话或做任何其它动作"。
//       (低档每代谢拍重新 Paralyze 一小段时长，使瘫痪贯穿整个药效期；结束时清零，立即恢复。)
//
//   框架见 refining_framework.dm；成品瓶见 items/custom_potion_bottles.dm。
//   本文件全部内容位于 modular_z121 之下，符合项目硬性约束。
// ============================================================================


// ----------------------------------------------------------------------------
// 中文：★消化速度常量★——题面要求【每 1 单位 6 秒】。生命循环(SSmobs, wait=20)每 2 秒触发一次 on_mob_life，
//   每次移除 metabolization_rate 单位；故"每单位耗时(秒) = 2 ÷ metabolization_rate"。要 6 秒/单位 ⇒
//   metabolization_rate = REAGENTS_METABOLISM(=1) × 2 ÷ 6 = 1/3。抽为宏，便于日后统一调参。
// ----------------------------------------------------------------------------
#define PARALYTIC_POISON_SECONDS_PER_UNIT 6					// Digest one unit every 6 seconds.

// ----------------------------------------------------------------------------
// 中文：本药剂施加各类"特性(trait)"时统一使用的来源标识(source)。用【同一 source】成对添加/移除，才能精确撤销，
//   绝不误伤其它系统对同一 trait 的施加(例如别处也可能给同一 mob 加了 TRAIT_MUTE)。取一个本药剂专属的常量。
// ----------------------------------------------------------------------------
#define PARALYTIC_POISON_TRAIT_SOURCE "paralytic_poison"	// Unique trait source for clean paired add/remove.

// ----------------------------------------------------------------------------
// 中文：★体质分档阈值★——题面三档：18-20 只麻舌、14-17 加麻臂、≤13 全身瘫倒。抽为宏，逻辑与文案共用真值来源。
//   注：本 fork 属性上限一般为 20；若出现被增益到 >20 的极端情形，按"≥18 只麻舌"处理(最轻档)，合乎"体质越高越抗"。
// ----------------------------------------------------------------------------
#define PARALYTIC_POISON_CON_TONGUE_MIN 18					// CON >= 18 : tongue-only numbness (can't speak).
#define PARALYTIC_POISON_CON_ARMS_MIN 14					// CON 14-17 : arms also numb (can't pick up / use items).
															// CON <= 13 : whole-body numbness (collapse; can't move/speak/act).

// ----------------------------------------------------------------------------
// 中文：★瘫痪档每拍重施的时长★——略大于代谢拍间隔(2 秒)，以便"每拍续一小段"就能把瘫痪连续维持住，
//   又不会在药效结束后仍拖着长尾(结束时另会主动清零)。
// ----------------------------------------------------------------------------
#define PARALYTIC_POISON_PARALYZE_DURATION (3 SECONDS)		// Re-applied each 2s tick to keep the collapse continuous.


// ============================================================================
// 成品试剂——麻痹毒药。非酒基 → 直接继承 /datum/reagent(不走酒基 refined_potion 基类)。
//   设计：麻痹效果与药剂"同生共死"——代谢开始按体质锁定档位并施加、每代谢拍补稳、代谢结束精确解除。
// ============================================================================
/datum/reagent/paralytic_poison
	name = "麻痹毒药"											// In-game name (Paralytic Poison).
	// 中文：检视/说明文本——点明气味来源(恐惧)、底料(水/板油/毒药精炼)、以及"按体质分档麻痹"的功效。
	description = "一瓶循'恐惧'之气(本是强效魔力灵药的气息)、以清水、板油与毒液精炼而成的暗浊毒浆，触之黏冷、闻之令舌根发紧。饮下后毒性会顺着神经蔓延，令人依体质强弱而生轻重不一的麻痹：体质强者仅舌头发麻、难以言语；体质中平者连手臂也一并发麻、拿不起也用不了东西；体质孱弱者更会周身失觉、当场瘫软倒地、动弹不得。"	// Flavour + full mechanic hint.
	reagent_state = LIQUID									// Drinkable liquid poison.
	color = "#5c6b4a"										// Murky, sickly greyish-green (a toxic hue).
	taste_description = "一口黏冷、发苦，随即舌尖泛起阵阵刺麻的死寂"	// Taste flavour (numbing, bitter, deadening).
	// 中文：半透明显示，与其它自定义药水观感统一。
	alpha = 200												// Slight transparency, matching other potions.
	// 中文：★消化速度★= 每单位 6 秒(见上方宏推导)：REAGENTS_METABOLISM(=1) × 2 / 6 = 1/3 单位/拍。
	metabolization_rate = REAGENTS_METABOLISM * 2 / PARALYTIC_POISON_SECONDS_PER_UNIT	// 1/3 u per 2s-tick = 6s per unit.

	// 中文：★效果是否已施加★——一次性守卫，保证"施加麻痹"的整套动作只执行一次(防止代谢重入导致重复注册信号/重复加特性)。
	var/effects_active = FALSE								// One-shot guard so apply/remove each run exactly once.
	// 中文：★锁定的档位★——0=未定；1=仅麻舌(禁言)；2=麻舌+麻臂(禁言+禁手);3=全身瘫倒(禁言+禁动作+禁手+瘫痪)。
	//   于代谢开始按体质一次性判定并锁定(见 apply_paralysis_effects 的注释)，供每拍补稳与结束解除时参照。
	var/applied_tier = 0									// Locked severity tier (1=tongue, 2=+arms, 3=collapse).
	// 中文：★是否已封锁"手部操作"(点击拦截已注册)★——用于结束时精确注销信号，避免在未注册时误注销。
	var/hands_blocked = FALSE								// Did WE register the click-cancel handler?

// ----------------------------------------------------------------------------
// 中文：点击拦截信号处理器——手臂发麻期间，任何鼠标点击(攻击/拾取/使用/点选式施法…)都被取消，
//   兑现"拿不起、也用不了任何物品"。COMSIG_MOB_CLICKON 在 /mob/ClickOn 最前端发出(先于一切分发)，
//   返回 COMSIG_MOB_CANCEL_CLICKON 即整单取消。键盘移动不经 ClickOn，故本拦截【不影响移动】。
// WHY SIGNAL_HANDLER: 信号回调必须是非睡眠过程；此处仅做取消，符合 SHOULD_NOT_SLEEP。
// ----------------------------------------------------------------------------
/datum/reagent/paralytic_poison/proc/block_poison_click(mob/source, atom/target, params)
	SIGNAL_HANDLER											// Must not sleep — pure cancel.
	return COMSIG_MOB_CANCEL_CLICKON						// Cancel the click entirely (numb arms can't act on it).

// ----------------------------------------------------------------------------
// 中文：按饮用者体质【锁定并施加】麻痹效果——集中处理三档差异，且每一项施加都记录足迹，便于结束时精确还原。
//   以 effects_active 作一次性守卫，防止代谢重入导致"重复注册信号/重复加特性"。仅对有效 /mob/living 施加。
//   ★为何在此一次性判定档位(而非每拍重判)★：中毒的轻重取决于毒性渗入身体时的体质；锁定档位既贴合直觉，
//   又避免了"体质临时波动导致档位反复横跳、增益/特性反复增删"的边界复杂度，令实现稳健、可预测。
// ----------------------------------------------------------------------------
/datum/reagent/paralytic_poison/proc/apply_paralysis_effects(mob/living/M)
	// 中文：错误处理——目标缺失/正在删除 → 直接返回，避免对无效对象操作而运行时报错。
	if(!M || QDELETED(M))									// No valid drinker.
		return
	// 中文：错误处理——本效果只对 /mob/living 有意义(属性、特性、Paralyze 都定义在 living 层)；非 living 无从承载。
	if(!isliving(M))										// Effect only applies to living mobs.
		to_chat(M, span_warning("麻痹毒药在体内空流转，却找不到可供麻痹的血肉之躯。"))	// Honest non-living notice.
		return
	// 中文：一次性守卫——已施加则不重复。
	if(effects_active)										// Already applied for this potion instance.
		return
	effects_active = TRUE									// Latch: from now on we own the applied effects.

	// ---- 读取体质(constitution / endurance)并据此锁定档位 ----
	// 中文：get_stat(STAT_CONSTITUTION) 返回该 mob 的当前体质数值(STACON)。据题面三档判定：
	//   ≥18 → 档1(仅麻舌)；14-17 → 档2(麻舌+麻臂)；≤13 → 档3(全身瘫倒)。
	var/con = M.get_stat(STAT_CONSTITUTION)					// Current constitution/endurance value.
	if(con >= PARALYTIC_POISON_CON_TONGUE_MIN)				// 18-20 (or higher): most resistant.
		applied_tier = 1									// Tier 1: tongue-only numbness.
	else if(con >= PARALYTIC_POISON_CON_ARMS_MIN)			// 14-17: moderate.
		applied_tier = 2									// Tier 2: tongue + arms numbness.
	else													// 13 and below: most vulnerable.
		applied_tier = 3									// Tier 3: whole-body collapse.

	// ---- 所有档位共有：舌头发麻 → 无法说话(TRAIT_MUTE) ----
	// 中文：三档都含"舌麻失语"，故无条件施加禁言特性(say.dm 检查 TRAIT_MUTE 直接闭口)。
	ADD_TRAIT(M, TRAIT_MUTE, PARALYTIC_POISON_TRAIT_SOURCE)	// Numb tongue — can't speak (all tiers).

	// ---- 档2 与 档3：手臂发麻 → 拦截一切鼠标点击，拿不起/用不了物品 ----
	// 中文：override=TRUE 防御性避免"同源同信号重复注册"抛错(极端重入场景)。记录 hands_blocked 以便结束时注销。
	if(applied_tier >= 2)									// Arms numb (tiers 2 & 3).
		RegisterSignal(M, COMSIG_MOB_CLICKON, PROC_REF(block_poison_click), override = TRUE)	// Cancel all clicks (no pickup/use).
		hands_blocked = TRUE								// Remember we registered it.

	// ---- 档3：全身发麻 → 瘫倒在地 + 禁动作(emote) + 禁动作栏施法；配合上面的禁言与禁手，即"不能移动/说话/做任何事" ----
	if(applied_tier >= 3)									// Whole-body collapse (tier 3).
		ADD_TRAIT(M, TRAIT_EMOTEMUTE, PARALYTIC_POISON_TRAIT_SOURCE)		// Can't emote (emotes.dm checks TRAIT_EMOTEMUTE).
		ADD_TRAIT(M, TRAIT_SPELLCOCKBLOCK, PARALYTIC_POISON_TRAIT_SOURCE)	// Can't action-bar cast (spell.dm cast_check).
		// 中文：立刻瘫倒——ignore_canstun=TRUE 让麻痹对"抗击倒"目标也可靠生效(毒药理应无差别地令人瘫软)。
		//   施加 STATUS_EFFECT_PARALYZED(=无法移动/使用物品/站起)，随后每代谢拍续期(见 on_mob_life)。
		M.Paralyze(PARALYTIC_POISON_PARALYZE_DURATION, ignore_canstun = TRUE)	// Collapse to the ground now.

	// ---- 施加成功的分档文字反馈(纯提示，不影响机制) ----
	switch(applied_tier)									// Tier-specific onset message.
		if(1)												// Tongue only.
			M.visible_message(span_warning("[M]的嘴唇僵了一下，似乎有些说不出话来。"), \
							span_userdanger("一阵刺麻顺着舌根漫开——你的舌头发僵，再也吐不出清晰的言语！"))	// Tier 1 feedback.
		if(2)												// Tongue + arms.
			M.visible_message(span_warning("[M]的手臂僵硬地垂了下来，手指也不听使唤了。"), \
							span_userdanger("刺麻感从舌根蔓延到双臂——你的舌头发僵、双手也失了知觉，再握不住任何东西！"))	// Tier 2 feedback.
		if(3)												// Whole body.
			M.visible_message(span_warning("[M]浑身一软，直挺挺地瘫倒在地，动也动不了！"), \
							span_userdanger("刺麻感瞬间席卷全身——你四肢失觉、当场瘫软倒地，动弹不得、也发不出半点声音！"))	// Tier 3 feedback.

// ----------------------------------------------------------------------------
// 中文：解除麻痹——把 apply_paralysis_effects 施加过的一切【精确还原】(只撤销我们加的部分)，恢复正常。
// ----------------------------------------------------------------------------
/datum/reagent/paralytic_poison/proc/remove_paralysis_effects(mob/living/M)
	// 中文：一次性守卫——未施加则无需还原(防止重复解除)。
	if(!effects_active)										// Nothing was applied / already reverted.
		return
	effects_active = FALSE									// Un-latch.
	// 中文：错误处理——目标缺失/正在删除 → 无从(也无需)还原，直接返回(守卫已复位，避免残留)。
	if(!M || QDELETED(M))									// Nothing to restore on an invalid mob.
		return

	// ---- 解除禁言(所有档) ----
	REMOVE_TRAIT(M, TRAIT_MUTE, PARALYTIC_POISON_TRAIT_SOURCE)			// Can speak again.

	// ---- 解除点击拦截(档2/3，仅当我们注册过) ----
	if(hands_blocked)										// We registered the click-cancel handler.
		UnregisterSignal(M, COMSIG_MOB_CLICKON)				// Clicks (pickup/use) work again.
		hands_blocked = FALSE								// Reset bookkeeping.

	// ---- 解除禁动作/禁施法与瘫痪(档3) ----
	if(applied_tier >= 3)									// Was a whole-body collapse.
		REMOVE_TRAIT(M, TRAIT_EMOTEMUTE, PARALYTIC_POISON_TRAIT_SOURCE)		// Can emote again.
		REMOVE_TRAIT(M, TRAIT_SPELLCOCKBLOCK, PARALYTIC_POISON_TRAIT_SOURCE)	// Can cast again.
		// 中文：立刻清零瘫痪，让人随药力散尽而立即能动(否则要等最后一段续期自然到期，最多拖 3 秒)。
		M.SetParalyzed(0)									// Clear the paralysis immediately.

	applied_tier = 0										// Reset the locked tier.

// 中文：代谢开始时(每"一份"药剂仅触发一次)——校验目标后按体质锁定档位并施加麻痹。
/datum/reagent/paralytic_poison/on_mob_metabolize(mob/living/M)
	. = ..()												// Let the base reagent set up first.
	// 中文：错误处理——目标无效则不施加效果(避免对无效对象操作报错)；apply_paralysis_effects 内部亦有守卫。
	if(!M || QDELETED(M))									// No valid drinker.
		return
	apply_paralysis_effects(M)								// Lock tier by constitution & apply the numbness.

// 中文：每代谢一拍——① 若处于"瘫倒档"则续期瘫痪(使其贯穿整个药效)；随后交给父类扣减用量并推进代谢。
//   (禁言/禁手/禁动作是特性与信号，一次施加即持续存在，无需每拍重复；仅 Paralyze 会自然到期，故只它需续期。)
/datum/reagent/paralytic_poison/on_mob_life(mob/living/carbon/M)
	// 中文：错误处理——目标缺失/正在删除 → 跳过续期，仍交给父类收尾以保持代谢推进(否则药剂会卡住不减少)。
	if(!M || QDELETED(M))									// Guard against a missing/deleting mob.
		return ..()
	// 中文：仅"全身瘫倒档"需要每拍续期瘫痪，令其连续维持不中断(ignore_canstun 保证对抗击倒目标也可靠)。
	if(effects_active && applied_tier >= 3 && isliving(M))	// Collapse tier still in effect?
		M.Paralyze(PARALYTIC_POISON_PARALYZE_DURATION, ignore_canstun = TRUE)	// Refresh the collapse so it never lapses.
	return ..()												// Standard metabolism (consumes metabolization_rate, decrements volume).

// 中文：代谢结束(药剂耗尽/被清除)时——精确解除麻痹(只撤销我们加过的部分)，恢复正常，并给出"知觉回归"的提示。
/datum/reagent/paralytic_poison/on_mob_end_metabolize(mob/living/M)
	// 中文：仅对有效目标解除并反馈(remove_paralysis_effects 内部亦有守卫)。
	if(M && !QDELETED(M))									// Valid target?
		var/was_active = effects_active						// Remember whether we actually had an effect to lift.
		remove_paralysis_effects(M)							// Revert everything we applied (only our own additions).
		if(was_active)										// Only message if we had actually numbed them.
			to_chat(M, span_notice("刺麻的死寂感缓缓退去，知觉重新回到了四肢百骸与舌尖，你又能动、能言了。"))	// Recovery feedback.
	return ..()												// Let the base finish up (final volume cleanup, etc.).


// ============================================================================
// 精炼配方：★按气味等级(气味档①)★ —— 5 级"恐惧"气味 + 底料(水50 + 板油20 + 毒药30) → 麻痹毒药 30。技能：专家(炼金 4 级)。
// ----------------------------------------------------------------------------
// 中文：
//   · "恐惧"是【强效魔力灵药(big_mana_potion)】配方的气味，且未被其它精炼配方占用(题面要求"未使用的 5 级气味")。
//     带此气味、指向 big_mana_potion 的现成材料有：纯净精质(magicdust, major=3)、金粉(golddust, major=3)、
//     水之精质/原初精质(major=int_potion, med=big_mana_potion=2)、焦尘粉(feaudust, med=2)…… 取【纯净精质 + 金粉】
//     即 3+3=6 ≥ 5，稳定满足"5 级恐惧"气味(两种不同材料，符合原版禁止重复投料的规则)。
//   · 底料用【现成试剂】：清水 50 + 板油(tallow) 20 + 毒药(berrypoison) 30。三者均非乙醇，故成品【非酒基】，
//     output 直接注入普通试剂、不携带 boozepwr。
//   · ★注意★ has_reagent 判定为【精确类型】，故底料须写成具体产出类型(水/板油/毒药皆为具体可产出试剂)。
//   · ★煮沸阈值★：本配方底料合计 50+20+30 = 100 单位，远超精炼锅的起沸下限 waterneed(60，见 refining_framework.dm)，
//     可正常起沸熬制，无需额外改动。
// ============================================================================
/datum/alch_refining_formula/paralytic_poison
	name = "麻痹毒药"										// Formula name.
	// 中文：★气味档①★ 要求"恐惧"气味累计达到 5 点(即题目的"5 级未使用气味")。
	required_scent = "恐惧"									// Require the "fear" scent (big_mana_potion's smell, unused)...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points; magicdust 3 + golddust 3 = 6).
	// 中文：★复合底料★ 清水 50 + 板油(tallow) 20 + 毒药(berrypoison) 30(现成试剂；无酒 → 成品非酒基)。
	required_base = list(/datum/reagent/water = 50,			// 50 water.
						/datum/reagent/consumable/oil/tallow = 20,	// 20 leaf lard (tallow).
						/datum/reagent/berrypoison = 30)	// 30 poison (berrypoison).
	// 中文：产物——30 单位麻痹毒药(单批产出 30)。
	output_reagents = list(/datum/reagent/paralytic_poison = 30)	// Refined output: 30u Paralytic Poison.
	// 中文：所需技能——专家(炼金 4 级，SKILL_LEVEL_EXPERT == 4)。技能不足则整锅腐坏(框架 spoil_batch 处理)。
	skill_required = SKILL_LEVEL_EXPERT						// Alchemy Level 4 (Expert) gate.
	// 中文：成功时的气味词。
	smells_like = "令人舌根发紧的死寂毒气"					// Success scent.


// 中文：清理本文件作用域内的局部宏，避免它们泄漏到全局编译环境、与他处同名定义冲突。
#undef PARALYTIC_POISON_SECONDS_PER_UNIT
#undef PARALYTIC_POISON_TRAIT_SOURCE
#undef PARALYTIC_POISON_CON_TONGUE_MIN
#undef PARALYTIC_POISON_CON_ARMS_MIN
#undef PARALYTIC_POISON_PARALYZE_DURATION
