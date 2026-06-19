// ============================================================================
// 腐朽与瘟疫之灾（Disaster of Decay and Plague）—— 隶属于佩斯特拉献祭法阵的一项仪式
// ----------------------------------------------------------------------------
// 在【已存在的】佩斯特拉献祭法阵
//（`/obj/structure/ritualcircle/sacrifice/pestra`，定义于 sacrifice_circles.dm）
// 之上新增一项仪式。DM 会跨文件合并同一类型的定义，因此在这里重新打开该类型即可
// 挂上新仪式，而【无需】改动那个共享的法阵文件。
//
// 该仪式要求法阵格子上备齐四样祭品：1 份心兽之血、1 份灰烬、1 只水蛭、1 瓶治腐药剂。
// 成功时消耗这四样祭品，并向法阵 14 格半径内、所有【非十神信徒】施加一段 3 分钟的瘟疫；
// 佩斯特拉自身的十神信众（以及其余九柱神的信徒）则因受神庇佑而免疫。
//
// 遵循项目规则：仅存放于 modular_z121 之下，面向玩家的文本一律使用中文，
// 每一处过程、变量与逻辑块上方都以中文注释解释其“为何如此”。
//
// 依赖项（均已在构建中，未作改动）：
//   - 仪式基础框架：modular_z121\rites\sacrifice_circles.dm
//   - 心兽之血：/obj/item/heart_blood_canister/filled 或 /obj/item/heart_blood_vial/filled
//       （code\modules\roguetown\roguemachine\heartbeast\heart_canisters.dm）
//   - 灰烬：/obj/item/ash（code\game\objects\items\rogueitems\natural\ash.dm）
//   - 水蛭：/obj/item/natural/worms/leech（code\modules\roguetown\roguejobs\fisher\leeches.dm）
//   - 治腐药剂：/obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure
//       （modular_azurepeak\code\modules\reagents\reagent_containers\rotcure.dm，已 include）
//   - 瘟疫 debuff：/datum/status_effect/debuff/pestilent_plague
//       （code\modules\spells\roguetown\acolyte\pestra\pestra_status_effects.dm）
//   - 十神名册：ALL_DIVINE_PATRONS（code\__DEFINES\roguetown.dm）
// 需在 modular_z121\_load.dm 中登记（置于 sacrifice_circles.dm 之后）。
// ============================================================================

// --- 可调常量 ---------------------------------------------------------------
// 在仪式选择菜单中显示、并在分派 switch 中用于匹配的标签文本；用 define 保存，
// 使二者永远保持一致、不会悄然出现偏差。
#define PESTRA_PLAGUE_RITE_NAME "腐朽与瘟疫之灾"
// 瘟疫波及的半径（以格计）。规格要求为 14 格。
#define PESTRA_PLAGUE_RADIUS 14
// 瘟疫在受害者身上持续的时间。规格要求为 3 分钟。
#define PESTRA_PLAGUE_DURATION (3 MINUTES)

// 重新打开佩斯特拉献祭法阵以登记我们的仪式。基类 attack_hand()
//（在 sacrifice_circles.dm 中）已经强制校验 patron == Pestra、TRAIT_RITUALIST 特质、
// 每次歇息只能一次的“仪式已耗尽”冷却，并弹出选择菜单——因此我们只需提供菜单标题与仪式列表。
/obj/structure/ritualcircle/sacrifice/pestra
	// 在仪式选择输入框中显示的标题。
	ritual_title = "佩斯特拉的献祭仪式"
	// 本法阵提供的仪式。日后若要新增佩斯特拉仪式，只需在这里追加字符串
	//（并在下方补上对应的 switch 分支）即可。
	sacrifice_rites = list(PESTRA_PLAGUE_RITE_NAME)

// 将所选仪式分派给其处理过程；在玩家从 `sacrifice_rites` 中选取条目后，
// 由基类 attack_hand() 调用。
/obj/structure/ritualcircle/sacrifice/pestra/perform_sacrifice_rite(riteselection, mob/living/user)
	switch(riteselection)
		// 将我们的仪式导向其专属过程。
		if(PESTRA_PLAGUE_RITE_NAME)
			return pestra_plague_rite(user)
	// 未识别的选项 -> 基类会礼貌地提示“没有这样的仪式”并退出。
	return ..()

// ----------------------------------------------------------------------------
// 仪式本体。
// 仅在仪式完整完成时返回 TRUE；任何中止/失败都返回 FALSE，从而不消耗任何祭品、
// 也不提前花掉每日的“仪式已耗尽”冷却（基类仅在本过程内成功时才标记其耗尽）。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/pestra/proc/pestra_plague_rite(mob/living/user)
	// --- 守卫 1：只有人类才能主持这场献祭。----------------------------
	// 后续流程假定主持者为人形（信仰、台词等）；其它情况明确中止。
	if(!ishuman(user))
		to_chat(user, span_smallred("唯有凡人之躯，才能在佩斯特拉面前主持这场仪式。"))
		return FALSE
	var/mob/living/carbon/human/H = user

	// 法阵自身所在的格子即“祭祀法阵”；祭品摆放于此，瘟疫也以此为圆心扩散。缓存它。
	var/turf/altar = get_turf(src)
	if(!altar)
		// 防御性处理：没有所在格子的法阵无法承放祭品、也无从确定波及范围。
		to_chat(H, span_warning("这道法阵无处安放祭品，仪式无法开始。"))
		return FALSE

	// --- 守卫 2：在漫长吟唱【之前】确认四样祭品齐备。----
	// 提前检查，免得让玩家站着念完咒，最后才被告知缺了某样祭品。
	if(!has_required_offerings(altar, H))
		return FALSE // has_required_offerings() 已经报告了缺失之物。

	// --- 吟唱阶段。----------------------------------------------------
	// do_after() 若被打断（移动/眩晕）会返回 FALSE；每一阶段都重新确认祭品仍在，
	// 因此走开（或被人顺走祭品）都会干净地中止、不消耗任何东西。
	// 台词呼应佩斯特拉的领域：腐朽、瘟疫、苍蝇之群与“以病疫净化不洁”。
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("佩斯特拉啊，腐朽与瘟疫的女王，苍蝇之群的母亲！请垂听我的祈求。")
	playsound(altar, 'sound/misc/fliesloop.ogg', 80, FALSE, -1)

	// 继续之前重新校验（等待期间世界状态可能已经改变）。
	if(!has_required_offerings(altar, H))
		return FALSE
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("我献上心兽之血、灰烬、活蛭与治腐之药——以生与死、净与秽，喂养你的疫群。")
	playsound(altar, 'sound/misc/fliesloop.ogg', 80, FALSE, -1)

	if(!has_required_offerings(altar, H))
		return FALSE
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("让不敬十神的渎神者，皆在你的腐朽中溃烂、在你的瘟疫中颤栗吧！")
	to_chat(H, span_danger("一股腐臭自法阵中蒸腾而起，无数嗡鸣的虫翼仿佛就在耳畔扇动……"))

	// 收尾前最后一段较短的停顿，让高潮显得郑重而有意为之。
	if(!do_after(H, 30, target = src))
		return FALSE

	// --- 最终校验 + 消耗祭品。--------------------------------
	// 在拿取任何东西之前进行权威校验，使消耗绝不会在已残缺的法阵上执行。
	if(!has_required_offerings(altar, H))
		return FALSE
	// 原子化地各移除一样祭品；若以某种方式失败，则中止后续效果。
	if(!consume_required_offerings(altar))
		to_chat(H, span_warning("祭品在最后一刻散落，仪式功亏一篑。"))
		return FALSE

	// --- 仪式成功的视觉与气氛表现。----------------------------
	icon_state = "pestra_active" // 魔法生效期间点亮符文。
	altar.visible_message(span_warning("法阵猛地喷涌出一团墨绿的腐雾，化作密密麻麻的蝇群，向四面八方汹涌扩散！"))
	playsound(altar, 'sound/misc/fliesloop.ogg', 100, FALSE, extrarange = 7)

	// --- 释放瘟疫。----------------------------------------------------
	// 向半径内的非十神信徒施加瘟疫，并取回实际感染的人数以给出如实反馈。
	var/afflicted = unleash_plague(altar, H)

	// 既然仪式已真正成功，就此花掉每日的仪式额度（与其它祭坛采用同一规则），
	// 使主持者必须先歇息才能进行下一次。
	H.apply_status_effect(/datum/status_effect/debuff/ritesexpended)

	// 给主持者的收尾确认，并如实报告波及人数（可能为 0：附近没有可感染的渎神者）。
	if(afflicted > 0)
		to_chat(H, span_nicegreen("佩斯特拉收下了这场献祭。腐朽与瘟疫已降临于 [afflicted] 名不敬十神之人。"))
	else
		to_chat(H, span_notice("佩斯特拉收下了这场献祭，但四下里并无可供瘟疫吞噬的渎神者。"))

	// 短暂延迟后把符文重置回静默状态，复用基类辅助过程，使时机与其它祭坛保持一致。
	addtimer(CALLBACK(src, PROC_REF(reset_rune_state)), 120)
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：在法阵格子上查找“心兽之血”，找到则返回该物品，否则返回 null。
// 心兽之血有两种盛装形态（罐装/瓶装），且必须是【已灌注】的版本（filled），
// 空容器不含血、不能作数。两者皆可，任取其一。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/pestra/proc/find_heartblood(turf/altar)
	if(!altar)
		return null
	// 先找灌满的心血罐。
	var/obj/item/found = locate(/obj/item/heart_blood_canister/filled) in altar
	if(found)
		return found
	// 再找灌满的心血瓶。
	found = locate(/obj/item/heart_blood_vial/filled) in altar
	return found

// ----------------------------------------------------------------------------
// 辅助：四样祭品是否都摆在法阵格子上？
// `complain` 默认开启，使主流程能在一次调用中同时【检查】并【报告】；
// 它会列出每一样缺失的祭品，让玩家清楚知道还需补放什么。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/pestra/proc/has_required_offerings(turf/altar, mob/living/user, complain = TRUE)
	// 防御性处理：没有格子就没有祭品。
	if(!altar)
		return FALSE
	// 逐一定位四样祭品。心兽之血走专用查找（兼容罐/瓶两种灌注形态）；
	// 其余三样用 `locate(类型) in 格子`（基于 istype）。
	var/heartblood = find_heartblood(altar)
	var/obj/item/ash/ash_item = locate() in altar
	var/obj/item/natural/worms/leech/leech_item = locate() in altar
	var/obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure/rotcure_item = locate() in altar

	// 收集所有缺失之物的名称，以便给出清晰、可操作的反馈。
	var/list/missing = list()
	if(!heartblood)
		missing += "心兽之血（灌注的心血罐或心血瓶）"
	if(!ash_item)
		missing += "灰烬"
	if(!leech_item)
		missing += "水蛭"
	if(!rotcure_item)
		missing += "治腐药剂"

	// 有任何缺失 -> 视情况说明，然后报告失败。
	if(length(missing))
		if(complain && user)
			// 使用中文分隔符，使拼接后的列表在句中读起来自然
			//（english_list 默认使用 " and "/", "）。
			to_chat(user, span_smallred("法阵上还缺少献祭所需之物：[english_list(missing, and_text = "、", comma_text = "、")]。"))
		return FALSE
	// 四样皆已齐备。
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：从法阵格子上各移除【恰好一样】祭品。
// 仅在四样全部找到并删除时返回 TRUE；一旦有任何短缺，便停止并返回 FALSE，
// 使调用方能够中止而不会发生部分消耗。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/pestra/proc/consume_required_offerings(turf/altar)
	if(!altar)
		return FALSE
	// 在消耗的那一刻重新定位（不要信任先前捕获的引用——它们在吟唱期间可能已被移动或 qdel）。
	var/obj/item/heartblood = find_heartblood(altar)
	var/obj/item/ash/ash_item = locate() in altar
	var/obj/item/natural/worms/leech/leech_item = locate() in altar
	var/obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure/rotcure_item = locate() in altar
	// 此刻若有任何一样已不存在，便拒绝消耗其余的。
	if(!heartblood || !ash_item || !leech_item || !rotcure_item)
		return FALSE
	// 全部齐备 -> 各销毁一样。qdel 会干净地将它们从格子上移除。
	qdel(heartblood)
	qdel(ash_item)
	qdel(leech_item)
	qdel(rotcure_item)
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：某人是否为“十神信徒”？
// 十神 = ALL_DIVINE_PATRONS 中的十柱神祇。其信徒受神庇佑，免疫这场瘟疫；
// 而异神信徒（炼狱诸神）、普赛顿信徒、以及无信仰者皆视为“非十神信徒”。
// 传入预先缓存好的十神名册，避免在循环中反复展开该 define（每次展开都会新建一份列表）。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/pestra/proc/is_ten_god_believer(mob/living/carbon/human/H, list/ten_gods)
	// 没有任何信仰 -> 不是十神信徒。
	if(!H.patron)
		return FALSE
	// 其主神类型是否在十神名册之内。
	return (H.patron.type in ten_gods)

// ----------------------------------------------------------------------------
// 释放瘟疫：向法阵半径内、所有非十神信徒的活人施加 3 分钟的瘟疫。
// 返回实际被感染的人数，便于给出如实反馈。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/pestra/proc/unleash_plague(turf/altar, mob/living/user)
	// 防御性处理：没有圆心就无从扩散。
	if(!altar)
		return 0
	// 仅展开一次十神名册并缓存，供下方循环复用（性能与清晰兼顾）。
	var/list/ten_gods = ALL_DIVINE_PATRONS
	// 统计实际被瘟疫波及的人数。
	var/afflicted = 0
	// 遍历圆心半径内的所有人形（range(N, 圆心) 返回该方形范围内的原子，for 会按类型过滤）。
	for(var/mob/living/carbon/human/victim in range(PESTRA_PLAGUE_RADIUS, altar))
		// 已失效的对象跳过。
		if(QDELETED(victim))
			continue
		// 不感染尸体——瘟疫只折磨活人。
		if(victim.stat == DEAD)
			continue
		// 十神信徒受庇佑，免疫此疫。
		if(is_ten_god_believer(victim, ten_gods))
			continue
		// 施加我们的 3 分钟瘟疫 debuff（详见下方的 disaster 子类型）。
		victim.apply_status_effect(/datum/status_effect/debuff/pestilent_plague/disaster)
		afflicted++
	return afflicted

// ============================================================================
// 3 分钟版的瘟疫 debuff。
// 直接继承佩斯特拉既有的 /datum/status_effect/debuff/pestilent_plague，从而复用其
// 全部表现（施加时的钝伤与不适提示、每若干秒的持续钝伤、绿色腐光描边、随机痛苦台词、
// CON/STR 属性削弱），仅把持续时间改为规格要求的 3 分钟，并赋予独立 id，
// 以免与原版瘟疫（60 秒）在同一目标身上相互覆盖。
// 注意：此处只是在 modular_z121 中【新增】一个子类型，并未改动 code/ 下的原文件。
// ============================================================================
/datum/status_effect/debuff/pestilent_plague/disaster
	// 独立 id：与原版 60 秒瘟疫区分开，避免二者互相顶替。
	id = "pestilent_plague_disaster"
	// 规格要求的持续时间：3 分钟。
	duration = PESTRA_PLAGUE_DURATION

// --- 清理本文件局部的 define，避免它们泄漏到其它文件中 ---------
#undef PESTRA_PLAGUE_RITE_NAME
#undef PESTRA_PLAGUE_RADIUS
#undef PESTRA_PLAGUE_DURATION
