// ============================================================================
// 精力药剂 (Vigor Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文总览(WHY/HOW)：
//   配方：5 级"火焰"气味 + 底料【情欲液 50 + 鲜乳(乳汁) 50】 → 50 单位精力药剂；技能：专家。
//   效果：药力持续期间，饮者【精力无穷、永不力竭】——不仅射精，【一切能达到高潮的性活动】(主动/被动
//         射精、阴部潮吹、容器射精、被挤奶取精……)都能一次又一次地进行而不会精疲力尽，仿佛体力取之不竭。
//
//   机制落点(为什么这样实现)：原版 sexcon(性控制器)用一条"精力槽" charge 来表示体力，而该槽是【所有高潮
//     路径的统一闸门】——
//     · is_spent() 判定 `charge < CHARGE_FOR_CLIMAX`：精力耗尽则【无法再高潮】，且欲望持续衰减(handle_charge)；
//     · 每条高潮路径(check_active_ejaculation / handle_passive_ejaculation / handle_container_ejaculation /
//       handle_cock_milking)结算前都会调用 is_spent() 把关；其中 can_ejaculate() 认【睾丸 或 阴道】两类器官，
//       故"射精"在引擎里也涵盖了【女性/受方的潮吹与高潮】，并非仅限男性。
//     · 每次高潮 after_ejaculation() 会扣除一份 CHARGE_FOR_CLIMAX，连续作战会迅速"精疲力尽"。
//   因此"精力无穷、可无限高潮"的最直接实现，就是【每个生命循环把 charge 顶满到 get_max_charge()】，
//   使 is_spent() 对【所有】高潮路径都永不为真，每次高潮的精力消耗被即时回满——饮者于是能无限次高潮。
//   一处顶满 charge 即覆盖全部高潮活动，无需逐路径打补丁。
//   (这是体力/精力效果，并非强制发情；故不去操纵 arousal——那是【媚药】的范畴，见 aphrodisiac.dm。)
//
//   ★合意前提★：与本分支所有 ERP/sexcon 类效果一致——仅对【开启了 ERP(prefs.sexable) 的人类】生效；
//   否则直接清空体积、无任何效果，尊重玩家意愿。
//
//   框架与精炼锅见 refining_framework.dm。本药为【非酒基】(底料无任何乙醇)，故成品为普通 /datum/reagent。
//   全部代码位于 modular_z121 根目录之下，符合项目硬性约束。
// ============================================================================

// 中文：成品试剂——精力药剂。继承基类 /datum/reagent(本药非酒基，无需酒精逻辑)。
//   通过逐拍把性控制器的"精力槽"顶满，实现"永不力竭、可无限高潮(任何性活动皆然)"的效果。
/datum/reagent/vigor_potion
	name = "精力药剂"										// In-game name (Vigor Potion).
	// 中文：检视/说明文本——点明"精力无穷、欲战不竭(无论何种性活动皆可无限尽兴)"的功效与合意前提的暗示。
	description = "循火焰般的热力、以情欲液与鲜乳精炼而成的赤金色药液。饮下后精力仿佛取之不竭，无论以何种方式纵情欢愉、几度登顶都不知疲倦。"	// Flavour + hint.
	reagent_state = LIQUID									// Drinkable liquid potion.
	color = "#e8a13c"										// Warm amber-gold (also tints the pot).
	taste_description = "灼热而甘醇，喉间一阵暖流"				// Taste flavour text.
	// 中文：代谢速率刻意调慢——50u 以此速率代谢可换来一段【可观的持续时长】(题目的"持续期间")，
	//       且无需额外计时器，药力耗尽即自然结束。
	metabolization_rate = 0.1 * REAGENTS_METABOLISM			// Slow burn -> a lasting duration (no extra timer).
	// 中文：半透明显示，与其它药水观感统一。
	alpha = 200												// Slight transparency, matching other potions.
	// 中文：标记本瓶药力是否已"正式生效"(通过了合意+人类校验)，用于结束时给出恰当的提示文案。
	var/active = FALSE										// Did the potion actually take effect (passed gates)?

// 中文：代谢开始时(每瓶仅触发一次)——做合意/人类校验并给出起效提示。
// WHY: sexcon(性控制器)仅 human 拥有；且所有 ERP 类效果必须尊重 prefs.sexable 合意开关。
/datum/reagent/vigor_potion/on_mob_metabolize(mob/living/carbon/M)
	..()
	// 中文：错误防护——目标缺失/正被删除则直接返回，避免空引用。
	if(!M || QDELETED(M))									// Guard against a missing/deleted mob.
		return
	// 中文：合意/人类前提——非人类(无 sexcon)或未开启 ERP 者：清空体积、不产生任何效果。
	//   (与媚药/催情酒同例：以 volume = 0 让药剂无害地立即代谢殆尽。)
	if(!ishuman(M) || !M.client?.prefs?.sexable)			// Consent / human gate.
		volume = 0											// Purge: no effect, harmless metabolise.
		return
	// 中文：校验通过——标记生效并提示玩家精力涌动。
	active = TRUE											// Effect is now live.
	to_chat(M, "<span class='aphrodisiac'>一股灼热的暖流自丹田奔涌而出，四肢百骸充满了仿佛无穷无尽的精力！</span>")	// Onset feedback.

// 中文：每代谢一拍——把性控制器的"精力槽"顶满，使饮者永不力竭、【任何高潮活动】皆可无限进行。
// WHY: is_spent() == (charge < CHARGE_FOR_CLIMAX) 是【所有高潮路径】的统一闸门(主动/被动射精、容器射精、
//      挤奶取精，且 can_ejaculate() 认睾丸或阴道→涵盖女性/受方潮吹)；精力耗尽则一律无法高潮且欲望衰减。
//      每拍回满 charge = get_max_charge() 即可让 is_spent() 对所有路径永不成立，并即时抵消每次高潮的精力消耗。
/datum/reagent/vigor_potion/on_mob_life(mob/living/carbon/M)
	// 中文：非人类无 sexcon——直接交回父级正常代谢，不报错。
	if(!ishuman(M))											// Only humans have a sexcon.
		return ..()
	var/mob/living/carbon/human/H = M						// Narrow type to reach human procs/vars.
	// 中文：中途若关闭了 ERP，立即失效清除(尊重玩家随时撤回合意)。
	if(!H.client?.prefs?.sexable)							// No longer consenting?
		volume = 0											// Purge -> ends this tick.
		return ..()
	// 中文：取得性控制器；理论上 human 恒有，但仍做空值防护以求稳健。
	var/datum/sex_controller/S = H.sexcon					// The sexcon (energy gauge lives here).
	if(isnull(S))											// Defensive: no controller -> nothing to refill.
		return ..()
	// 中文：★核心★ 直接把精力槽顶满(不走 set_charge 以避免反复弹出"没那么累了"的提示刷屏)。
	//   get_max_charge() = 最大可承载的高潮次数 × CHARGE_FOR_CLIMAX，足以缓冲生命循环间隔内的多次连续高潮。
	//   这一处顶满即覆盖【全部高潮路径】(射精/潮吹/容器/挤奶……)，因它们共用同一个 is_spent()/charge 闸门。
	S.charge = S.get_max_charge()							// Peg energy at max -> never spent, limitless climaxes of ANY kind.
	// 中文：偶尔给一句心流提示，强化"精力无穷"的代入感(低概率，避免刷屏)。
	if(prob(8))												// Occasional flavour line.
		to_chat(H, "<span class='love'>我感到精力充沛，仿佛永远不会疲倦……</span>")
	return ..()											// Let the base reagent finish (consume volume, etc.).

// 中文：代谢结束(药力耗尽/被清除/撤回合意)时——给出药效消退提示(仅在确曾生效时)。
//   注：charge 我们只是"逐拍顶满"，并未保存原值;停药后它会按原版规则(射精扣减/自然回充)恢复常态，无需手动还原。
/datum/reagent/vigor_potion/on_mob_end_metabolize(mob/living/carbon/M)
	// 中文：仅当药力确曾正式生效、且对象为有效 human 时才提示，避免对无效目标误报。
	if(active && ishuman(M) && !QDELETED(M))				// Only message if it really took hold.
		to_chat(M, "<span class='notice'>那股无穷的精力渐渐退去，久违的倦意重新涌上心头。</span>")	// Fade feedback.
	active = FALSE											// Reset state.
	..()

// ============================================================================
// 配方：★按气味等级①★ 5 级"火焰"气味 + 底料(情欲液 50 + 鲜乳 50) → 精力药剂 50。技能：专家。
// ----------------------------------------------------------------------------
// 中文：
//   · "火焰"是【锐眼药水(per_potion)】配方的气味；带它的现成材料(major=3 火焰)有：
//     西池烟叶粉(tobaccodust) 与 薄荷(mentha)。两者各 3 点 → 合计 6 ≥ 5，满足"5 级火焰"。
//   · 底料用【现成试剂】：情欲液/精液 /datum/reagent/erpjuice/cum 50 + 鲜乳(乳汁) /datum/reagent/consumable/milk 50。
//     总量 100 ≥ 精炼锅 waterneed(90)，足以煮沸开炼。
//   · 注意:find_refining_formula 用 has_reagent 做【精确类型】匹配,故 required_base 必须是【具体产出类型】
//     ——/datum/reagent/erpjuice/cum 与 /datum/reagent/consumable/milk 都是具体类型,正确。
//   · 本配方与原版"锐眼药水"(同样"火焰"气味、但以清水为底回退产出洞察 buff)以【液体底料】区分。
// ============================================================================
/datum/alch_refining_formula/vigor
	name = "精力药剂"										// Formula name.
	// 中文：★气味档①★ 要求"火焰"气味累计达到 5 点(即题目的"5 份火焰")。
	required_scent = "火焰"									// Require the "flame" scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★复合底料★ 情欲液 50 + 鲜乳 50(均为现成试剂)。
	required_base = list(/datum/reagent/erpjuice/cum = 50,	// 50 lust-fluid (semen)...
						/datum/reagent/consumable/milk = 50)	// ...+ 50 breast milk.
	// 中文：产物——50 单位精力药剂。
	output_reagents = list(/datum/reagent/vigor_potion = 50)	// Refined output: 50u Vigor Potion.
	// 中文：所需技能——专家。
	skill_required = SKILL_LEVEL_EXPERT						// Expert gate.
	// 中文：成功时的气味词。
	smells_like = "蓬勃的热力"								// Success scent.
