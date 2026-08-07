// ============================================================================
// 禁欲药水 (Forced Chastity Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文总览(WHY/HOW)：
//   配方：5 级"平静"气味 + 底料【乳汁 30 + 情欲液 30】 → 50 单位禁欲药水；技能：熟练。
//      气味材料：1 artemisia(草药,3pt) + 1 alchemical ozium(炼金臭葱石,2pt) = 5pt，两种不同类型可同锅。
//   效果：药力持续期间（约 8 分钟，50u × 10s/u），饮者体内快感不断累积攀升，却始终无法达到高潮——
//         精力槽被持续压制为零，使一切高潮路径(is_spent)皆被阻断；同时逐拍推高情欲值(arousal)
//         以抵消因"力竭"带来的情欲衰减，令快感被锁在高位、欲泄而不能。
//   ★药效结束后★：压抑了整段药效期的欲望如决堤般释放——精力瞬间拉满、情欲推向顶峰，
//         触发连续多次的报复性高潮，伴有分阶段的文本演出。
//
//   机制落点(为什么这样实现)：
//     · is_spent() 判定 `charge < CHARGE_FOR_CLIMAX`：精力耗尽则无法高潮——这是【所有高潮路径】
//       (主动/被动射精、容器射精、挤奶取精……)的统一闸门。将 charge 锁定为 0，即从根源上阻断一切高潮。
//     · handle_charge()(sexcon 每拍)在 is_spent 为真时会扣除 arousal(SPENT_AROUSAL_RATE=3/秒，
//       且 arousal>60 时额外-20)，使快感迅速流失。本药水逐拍把 arousal 补回并推高，令快感不降反升。
//     · 不冻结 arousal(arousal_frozen=FALSE)，因此性行为中的 receive_sex_action 仍能正常叠加快感，
//       不会阻断"感受快感"的体验——只是到达巅峰的出口被锁死了。
//     · 这与【精力药剂】(vigor_potion)恰成镜像：精力药剂把 charge 顶满→可无限高潮；
//       禁欲药水把 charge 压零→永远无法高潮。
//     · 路径与【媚药】(/datum/reagent/forced_estrus_aphrodisiac) 同级，同属 ERP 类精炼药水。
//
//   ★合意前提★：与本分支所有 ERP/sexcon 类效果一致——仅对【开启了 ERP(prefs.sexable) 的人类】生效；
//   否则直接清空体积、无任何效果，尊重玩家意愿。
//
//   框架与精炼锅见 refining_framework.dm。本药为【非酒基】(底料无任何乙醇)，故成品为普通 /datum/reagent。
//   全部代码位于 modular_z121 根目录之下，符合项目硬性约束。
// ============================================================================

// 中文：消化速度——30 单位持续约 5 分钟(300 秒)。
//   SSmobs.wait=20(每 2 秒)调用一次 metabolize()，每次扣除 metabolization_rate 单位。
//   目标：30 单位 ÷ (X 单位/拍) = 150 拍(300 秒) ⇒ X = 30/150 = 0.2 单位/拍。
#define ABSTINENCE_POTION_SECONDS_PER_UNIT 10	// Digest one unit every 10 seconds → 30u × 10s = 300s (5 min).

// ============================================================================
// 全局 proc —— 禁欲药水的高潮回调（不受 reagent GC 影响）
//   必须在 reagent 定义之前声明，否则 DM 编译器在 GLOBAL_PROC_REF 中找不到引用。
//   只用 WEAKREF 引用人体，目标消失则自动跳过。
// ============================================================================

// 中文：第一波高潮——即刻的报复性释放。
/proc/chastity_climax_first_wave(datum/weakref/ref)
	var/mob/living/carbon/human/H = ref?.resolve()
	if(!H || QDELETED(H))
		return
	var/datum/sex_controller/S = H.sexcon
	if(!S)
		return
	S.charge = S.get_max_charge()
	S.set_arousal(MAX_AROUSAL - 8)
	H.visible_message(span_warning("[H]的身体猛地弓起，发出一声压抑不住的哭叫——仿佛全身都在剧烈地痉挛！"), \
					span_userdanger("第一波高潮如同雷霆般劈穿了身体——视野瞬间炸成一片空白，除了那股吞噬一切的快感，什么都感觉不到了！！！"))
	H.emote("moan", forced = TRUE)

// 中文：第二波高潮——紧接而至，毫不留情。
/proc/chastity_climax_second_wave(datum/weakref/ref)
	var/mob/living/carbon/human/H = ref?.resolve()
	if(!H || QDELETED(H))
		return
	var/datum/sex_controller/S = H.sexcon
	if(!S)
		return
	S.charge = S.get_max_charge()
	S.set_arousal(MAX_AROUSAL - 8)
	H.visible_message(span_warning("[H]还没从第一波的余韵中缓过来，第二波高潮便毫不留情地碾了过来——[H.p_they()]双腿一软，几乎站立不住。"), \
					span_userdanger("又来——！！第二波浪潮比第一波更加猛烈，仿佛要把积攒了这么久的欲望一口气全部榨干！意识被冲得七零八落，连呼吸都忘了……"))
	H.emote("moan", forced = TRUE)

// 中文：余韵——漫长的高潮终于退去。
/proc/chastity_climax_afterglow(datum/weakref/ref)
	var/mob/living/carbon/human/H = ref?.resolve()
	if(!H || QDELETED(H))
		return
	to_chat(H, span_love("漫长的狂潮终于渐渐退去……身体还在不受控制地微微颤抖，四肢酸软得几乎抬不起来。"))
	to_chat(H, span_notice("那道枷锁真的消失了。身体——终于重新属于自己了。"))
	if(prob(30))
		H.emote("moan", forced = TRUE)

// 中文：成品试剂——禁欲药水(强制贞洁)。通过把精力槽压零阻断一切高潮，同时逐拍推高情欲值以维持快感。
//   路径与媚药(/datum/reagent/forced_estrus_aphrodisiac)同级。
/datum/reagent/forced_chastity_potion
	name = "禁欲药水"										// In-game name (Forced Chastity Potion).
	description = "循平静的草木气息、以乳汁与情欲液精炼而成的乳白色浊液。饮下后一股燥热自小腹升起，快感在体内层层堆叠、愈演愈烈——却仿佛被一道无形的枷锁牢牢扼住，无论如何都无法攀上顶峰。"	// Flavour + hint.
	reagent_state = LIQUID									// Drinkable liquid potion.
	color = "#f5e6d3"										// Creamy, milky white.
	taste_description = "甜腻中带着一丝腥涩，入喉后下腹隐隐发烫"	// Taste flavour text.
	// 中文：代谢速率 = 基准 × 2 / 每单位秒数 = 1 × 2 / 10 = 0.2 单位/拍 ⇒ 恰好 10 秒消化 1 单位。
	//   30 单位 × 10 秒/单位 = 300 秒 = 5 分钟。
	metabolization_rate = REAGENTS_METABOLISM * 2 / ABSTINENCE_POTION_SECONDS_PER_UNIT	// 0.2 u per 2s-tick = 10s per unit.
	alpha = 200												// Slight transparency, matching other potions.
	var/active = FALSE										// Did the potion actually take effect (passed gates)?
	var/flavor_tick = 0										// Tick counter for flavour interval.
	var/flavor_cycle = 0									// Rotates through 10 different flavour messages.

// 中文：代谢开始时(每瓶仅触发一次)——做合意/人类校验并给出起效提示。
/datum/reagent/forced_chastity_potion/on_mob_metabolize(mob/living/carbon/M)
	..()
	if(!M || QDELETED(M))
		return
	if(!ishuman(M) || !M.client?.prefs?.sexable)
		volume = 0
		return
	active = TRUE
	flavor_tick = 0
	flavor_cycle = -1
	to_chat(M, "<span class='aphrodisiac'>一股燥热自小腹升起，欲望在体内翻涌积聚——可每当快要触及巅峰时，便仿佛被一道无形的枷锁紧紧扼住，怎么也越不过那道门槛……</span>")

// 中文：每代谢一拍——精力槽压零阻断高潮，逐拍推高情欲值，并轮换多条心流提示。
/datum/reagent/forced_chastity_potion/on_mob_life(mob/living/carbon/M)
	if(!ishuman(M))
		return ..()
	var/mob/living/carbon/human/H = M
	if(!H.client?.prefs?.sexable)
		volume = 0
		return ..()
	var/datum/sex_controller/S = H.sexcon
	if(isnull(S))
		return ..()
	// ★核心①★ 精力槽压零——阻断一切高潮。
	S.charge = 0
	// ★核心②★ 推高情欲值，抵消力竭衰减。
	var/new_arousal = S.arousal + 30
	if(new_arousal > 130)
		new_arousal = 130
	S.set_arousal(new_arousal)
	// ★核心③★ 轮换多条心流提示，约每 16 秒(8 拍)一条，10 条为一个完整循环。
	flavor_tick++
	if(flavor_tick >= 8)
		flavor_tick = 0
		src.flavor_cycle = (src.flavor_cycle + 1) % 10
		switch(src.flavor_cycle)
			if(0)
				to_chat(H, "<span class='love'>快感在体内横冲直撞，却怎么也找不到出口……</span>")
			if(1)
				to_chat(H, "<span class='love'>一股又一股的热潮涌上脑门，却在即将决堤的刹那被生生按了回去。</span>")
			if(2)
				to_chat(H, "<span class='love'>身体深处传来阵阵空虚的痉挛，每一寸肌肤都在尖叫着渴望释放……</span>")
			if(3)
				to_chat(H, "<span class='love'>像是被悬在悬崖边缘——能看见深渊，却永远掉不下去。</span>")
			if(4)
				to_chat(H, "<span class='love'>腰腹无意识地绷紧又松弛，一次又一次地重复着徒劳的努力。</span>")
			if(5)
				to_chat(H, "<span class='love'>欲望如同沸腾的岩浆在血管里奔涌，偏偏被一道冰冷的石壁死死堵住。</span>")
			if(6)
				to_chat(H, "<span class='love'>眼角已经泛起了生理性的泪花，那种求而不得的焦灼几乎要把人逼疯……</span>")
			if(7)
				to_chat(H, "<span class='love'>每一次呼吸都带着灼热的喘息，仿佛空气本身都变得稠密而沉重。</span>")
			if(8)
				to_chat(H, "<span class='love'>双腿不由自主地绞紧，试图从无意义的摩擦中偷得一丝慰藉——却是徒劳。</span>")
			if(9)
				to_chat(H, "<span class='love'>脑海里一片混沌，只剩下一个念头：什么时候才能结束这场甜蜜的酷刑？</span>")
	return ..()

// 中文：代谢结束时——枷锁消散，积压了整段药效期的欲望报复性释放，连续高潮。
/datum/reagent/forced_chastity_potion/on_mob_end_metabolize(mob/living/carbon/M)
	if(!active || !ishuman(M) || QDELETED(M))
		active = FALSE
		return ..()
	var/mob/living/carbon/human/H = M
	// 中文：未开 ERP 者——仅有平静结束提示，不触发高潮。
	if(!H.client?.prefs?.sexable)
		to_chat(H, span_notice("那道无形的枷锁悄然消散，身体重获平静。"))
		active = FALSE
		return ..()
	var/datum/sex_controller/S = H.sexcon
	if(isnull(S))
		to_chat(H, span_notice("那道无形的枷锁终于消散——压抑已久的情欲如决堤般涌出，身体重新属于自己了。"))
		active = FALSE
		return ..()

	// ★药效结束——枷锁崩解★
	// 中文：精力瞬间拉满，情欲推至顶峰。sexcon 在后续处理中会自然触发连续高潮。
	S.charge = S.get_max_charge()
	S.set_arousal(MAX_AROUSAL - 5)							// 145/150，紧贴极限——一点即炸。

	// 中文：★阶段式文本演出★——使用全局 proc 回调（避免 reagent GC 后回调失效）。
	to_chat(H, "<span class='aphrodisiac'><b>那道无形的枷锁——终于崩碎了。</b></span>")
	to_chat(H, "<span class='love'>压抑了太久的欲望如同冲破堤坝的洪水，以摧枯拉朽之势席卷了全身的每一根神经！！</span>")
	if(prob(50))
		H.emote("moan", forced = TRUE)

	// 中文：使用 GLOBAL_PROC_REF 而非 PROC_REF——全局 proc 不受 reagent GC 影响。
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(chastity_climax_first_wave), WEAKREF(H)), 2 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(chastity_climax_second_wave), WEAKREF(H)), 4.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(chastity_climax_afterglow), WEAKREF(H)), 8 SECONDS)

	active = FALSE
	..()

// ============================================================================
// 配方：★按气味等级①★ 5 级"calming"(平静)气味 + 底料(乳汁 30 + 情欲液 30) → 禁欲药水 50。技能：熟练。
// ----------------------------------------------------------------------------
// 中文：
//   · "平静"是原版【七叶草药剂】(lck_potion)配方的 smells_like。气味材料(两种不同类型)：
//     artemisia(草药, major=3pt) + alchemical ozium(炼金臭葱石, med=2pt) = 5pt 正好达标。
//     且两者不同类型，可同时放入炼药锅。artemisia 是采集草药，ozium 是炼金台合成物。
//   · 底料减半：乳汁 30 + 情欲液 30 = 60，恰好达到精炼锅起沸下限(waterneed=60)。
//   · 产物提升为 50 单位，消化率不变(10s/u)，药效约 8 分钟。
//   · 与【驱兽药水】(同气味"calming"但底料为水+魔力药水)以液体底料区分。
// ============================================================================
/datum/alch_refining_formula/forced_chastity
	name = "禁欲药水"										// Formula name.
	required_scent = "平静"								// lck_potion(七叶草药剂) 的 smells_like。
	required_scent_points = 5								// >= 5: 1 artemisia(3) + 1 alchemical ozium(2) = 5.
	required_base = list(/datum/reagent/consumable/milk = 30,	// 30 breast milk (halved)...
						/datum/reagent/erpjuice/cum = 30)		// ...+ 30 lust-fluid (halved) = 60 total.
	output_reagents = list(/datum/reagent/forced_chastity_potion = 50)	// 50u Forced Chastity Potion.
	skill_required = SKILL_LEVEL_JOURNEYMAN					// Journeyman gate.
	smells_like = "压抑的欲望"								// Success scent.

#undef ABSTINENCE_POTION_SECONDS_PER_UNIT
