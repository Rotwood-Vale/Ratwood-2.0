// ============================================================================
// 恶意技艺（Malicious Skill）—— 隶属于玛勒姆献祭法阵的一项仪式
// ----------------------------------------------------------------------------
// 本文件在【已存在的】玛勒姆献祭法阵
//（`/obj/structure/ritualcircle/sacrifice/malum`，定义于 sacrifice_circles.dm）
// 之上【新增】一项仪式。DM 会跨文件合并同一类型的定义，因此在这里重新打开该类型
// 即可挂上新仪式，而【无需】改动那个共享的法阵文件——让本仪式完整地自成一个模块文件。
//
// 该仪式消耗放在法阵格子上的 1 铜锭 + 1 铁锭 + 1 银锭 + 1 金锭 + 1 圣钢锭
//（steelholy），随后给予主持者以下回报：
//   1. 武器/护甲/铁匠/冶炼 技能提升【至多到】2 级（学徒）
//   2. 解除这四项制造技能的等级上限（TRAIT_SMITHING_EXPERT）
//   3. 解锁所有受特质限制的铁砧锻造传承（TRAIT_KAZENGUNITE_SMITH）
//
// 遵循项目规则：仅存放于 modular_z121 之下，面向玩家的文本一律使用中文，
// 每一行都以注释解释其“为何如此”。
// ============================================================================

// --- 可调常量 ---------------------------------------------------------------
// 每项目标制造技能必定会达到的等级。2 级 = SKILL_LEVEL_APPRENTICE；
// 我们显式命名它，使“提升到 2 级”这一需求自带说明，且在技能枚举将来被重新编号时仍然可靠。
#define MALICIOUS_SKILL_BASE_RANK SKILL_LEVEL_APPRENTICE
// 在仪式选择菜单中显示、并在 switch 中用于匹配的标签文本。
// 用 define 保存，使菜单项与处理分支永远不会出现不一致。
#define MALICIOUS_SKILL_RITE_NAME "恶意毒艺"

// 重新打开玛勒姆献祭法阵以登记我们的仪式。在此设置这两个变量会与
// sacrifice_circles.dm 中的基础定义合并：基类 attack_hand() 已经强制校验
// patron == Malum、TRAIT_RITUALIST 特质、每次歇息只能一次的“仪式已耗尽”冷却，
// 并弹出选择菜单——因此我们只需提供菜单标题与所提供的仪式列表。
/obj/structure/ritualcircle/sacrifice/malum
	// 在仪式选择输入框中显示的标题。
	ritual_title = "玛勒姆的献祭仪式"
	// 本法阵当前提供的唯一仪式。日后若要新增仪式，只需在这里追加字符串
	//（并在下方补上对应的 switch 分支）即可。
	sacrifice_rites = list(MALICIOUS_SKILL_RITE_NAME)

// 将所选仪式分派给其处理过程。基类在玩家从 `sacrifice_rites` 中选取条目后，
// 会从 attack_hand() 中调用此过程。
/obj/structure/ritualcircle/sacrifice/malum/perform_sacrifice_rite(riteselection, mob/living/user)
	switch(riteselection)
		// 将我们的新仪式导向其专属过程。
		if(MALICIOUS_SKILL_RITE_NAME)
			return malicious_skill_rite(user)
	// 任何我们不认识的选项都会落到基类（基类会礼貌地提示
	//“此法阵没有这样的仪式”并返回 FALSE）。
	return ..()

// 本仪式所强化的四项制造技能。声明为一个文件级辅助过程，每次返回一份全新列表，
// 使“是否还有可获得的收益”的检查与实际授予的循环遍历完全相同的集合（单一可信来源）。
/obj/structure/ritualcircle/sacrifice/malum/proc/malicious_skill_targets()
	return list(
		/datum/skill/craft/weaponsmithing, // 武器锻造 —— 武器
		/datum/skill/craft/armorsmithing,  // 护甲锻造 —— 护甲
		/datum/skill/craft/blacksmithing,  // 铁匠   —— 通用铁器锻造
		/datum/skill/craft/smelting,       // 冶炼   —— 熔炼/冶炼
	)

// ----------------------------------------------------------------------------
// 仪式本体。
// 仅在仪式完整完成时返回 TRUE（让基类得知它已执行）；
// 任何中止/失败都返回 FALSE，从而不消耗任何祭品、也不提前花掉冷却
//（基类仅在本过程内部应用“仪式已耗尽”）。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/malum/proc/malicious_skill_rite(mob/living/user)
	// --- 守卫 1：只有血肉之躯的人类才能承载这份制造技艺。--
	// 技能持有者/特质均假定对象拥有人形心智；遇到其它任何情况（例如某只动物或构造体
	// 不知怎么触发了法阵）都明确地中止。
	if(!ishuman(user))
		to_chat(user, span_smallred("只有血肉之躯的工匠，才能承接这份恶意的技艺。"))
		return FALSE
	var/mob/living/carbon/human/H = user

	// 法阵自身所在的格子即“祭祀法阵”；祭品就摆放在这里。我们将其缓存下来，
	// 使下方每次扫描内容物时都查看同一个、正确的格子。
	var/turf/altar = get_turf(src)
	if(!altar)
		// 极端防御性处理：没有所在格子的法阵无法承放祭品。
		to_chat(H, span_warning("这道法阵无处安放祭品，仪式无法开始。"))
		return FALSE

	// --- 守卫 2：先行确认所有所需锭料是否齐备。--------
	// 我们在漫长的吟唱【之前】检查，免得让玩家站着念完咒，最后才被告知缺了某种锭料。
	if(!has_required_offerings(altar, H))
		return FALSE // has_required_offerings() 已经告知玩家缺了什么。

	// --- 守卫 3：拒绝毫无意义的献祭。-------------------------------
	// 如果主持者已经同时拥有“解除上限”特质、“知识”特质，且每一项目标技能都已达到/超过
	// 所授予的等级，那么这场仪式会白白烧掉五块锭料——因此我们中止，并为其保留材料。
	if(already_fully_empowered(H))
		to_chat(H, span_notice("玛勒姆的恶毒技艺早已铭刻在我的双手之中，无需再献。"))
		return FALSE

	// --- 吟唱阶段。----------------------------------------------------
	// 若使用者移动、被击晕，或动作以其它方式被打断，do_after() 会返回 FALSE；
	// 每一阶段都会重新确认祭品仍在此处，因此走开（或被人顺走某块锭料）都会
	// 干净利落地中止、且不消耗任何东西。这些台词呼应玛勒姆的领域：工艺、烈焰、毁灭、巧思。
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("玛勒姆啊，工艺与烈焰之主！请垂听这场献祭。")
	playsound(altar, 'sound/items/bsmithfail.ogg', 100, FALSE, -1)

	// 继续之前重新校验：等待期间世界状态可能已经改变。
	if(!has_required_offerings(altar, H))
		return FALSE
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("收下这铜、铁、银、金与圣钢，将它们的奥义熔炼进我的血脉！")
	playsound(altar, 'sound/items/bsmithfail.ogg', 100, FALSE, -1)

	if(!has_required_offerings(altar, H))
		return FALSE
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("纵使这技艺生来怀着恶意，我也甘愿背负——赐我无可匹敌的锻造之手！")
	to_chat(H, span_danger("一股灼热自胸膛奔涌而出，仿佛炉火正在你的骨髓里熊熊燃烧……"))

	// 收尾前最后一段较短的停顿，让高潮显得郑重而有意为之。
	if(!do_after(H, 30, target = src))
		return FALSE

	// --- 最终检查 + 消耗祭品。----------------------------------------
	// 在拿取任何东西之前进行最终的权威校验，使消耗步骤绝不会在已残缺的法阵上执行。
	if(!has_required_offerings(altar, H))
		return FALSE
	// 原子化地各移除一块所需锭料。如果在上述所有守卫之下消耗仍以某种方式失败，
	// 我们就中止，且不授予任何奖励。
	if(!consume_required_offerings(altar))
		to_chat(H, span_warning("祭品在最后一刻散落，仪式功亏一篑。"))
		return FALSE

	// --- 仪式成功的视觉与气氛表现。-----------------------------
	icon_state = "malum_active" // 魔法生效期间点亮符文。
	altar.visible_message(span_warning("一阵热浪自[H]脚下的法阵轰然腾起，铜铁银金与圣钢在白光中崩解、重铸，最终化作无形的技艺，烙入[H]的双手！"))
	playsound(altar, 'sound/magic/churn.ogg', 100, FALSE, -1)
	H.flash_fullscreen("redflash3") // 炽热熔炉般的闪光，与咒文相呼应。
	H.emote("agony")               // 这份知识是被烙印进体内的，并非温和地赐予。

	// --- 应用三项机制效果。----------------------------------------
	grant_malicious_skill(H)

	// 既然仪式已真正成功，就此花掉每日的仪式额度，使主持者必须先歇息，
	// 才能再进行下一次献祭（与其它祭坛采用同一规则）。
	H.apply_status_effect(/datum/status_effect/debuff/ritesexpended)

	// 给主持者的收尾确认。
	to_chat(H, span_nicegreen("玛勒姆收下了这场献祭。武器、护甲、铁匠与冶炼之道在我心中豁然贯通，恶意的锻艺再无桎梏。"))

	// 短暂展示之后，把符文图案重置回静默状态，复用基类的辅助过程，
	// 使时机与其它祭坛保持一致。
	addtimer(CALLBACK(src, PROC_REF(reset_rune_state)), 120)
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：四种所需锭料是否都摆在法阵格子上？
// `complain` 默认开启，使主流程能在一次调用中同时【检查】并【报告】；
// 它会列出每一种缺失的锭料，让玩家清楚知道还需补放什么。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/malum/proc/has_required_offerings(turf/altar, mob/living/user, complain = TRUE)
	// 防御性处理：没有有效的格子就不可能有祭品。
	if(!altar)
		return FALSE
	// `locate(类型) in 格子` 会返回第一个匹配的锭料（基于 istype）。这五种所需锭料
	// 都是 /obj/item/ingot 之下的同级类型，因此彼此之间不会被误匹配
	//（steelholy/silverblessed 是各自独立的同级类型，【并非】 steel/silver 的子类型）。
	var/obj/item/ingot/copper/copper_ingot = locate() in altar
	var/obj/item/ingot/iron/iron_ingot = locate() in altar
	var/obj/item/ingot/silver/silver_ingot = locate() in altar
	var/obj/item/ingot/gold/gold_ingot = locate() in altar
	var/obj/item/ingot/steelholy/steelholy_ingot = locate() in altar

	// 收集所有缺失之物的可读名称，以便给出清晰的反馈。
	var/list/missing = list()
	if(!copper_ingot)
		missing += "铜锭"
	if(!iron_ingot)
		missing += "铁锭"
	if(!silver_ingot)
		missing += "银锭"
	if(!gold_ingot)
		missing += "金锭"
	if(!steelholy_ingot)
		missing += "圣钢锭"

	// 有任何缺失 -> 视情况说明，然后报告失败。
	if(length(missing))
		if(complain && user)
			// 使用中文分隔符，使拼接后的列表在中文句子中读起来自然
			//（english_list 默认使用 " and "/", "）。
			to_chat(user, span_smallred("法阵上还缺少献祭所需之物：[english_list(missing, and_text = "、", comma_text = "、")]。需各放上一块铜锭、铁锭、银锭、金锭与圣钢锭。"))
		return FALSE
	// 四种（实为五种）皆已齐备。
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：从法阵格子上各移除【恰好一块】所需锭料。
// 仅在五种全部找到并删除时返回 TRUE；一旦有任何短缺，
// 便停止并返回 FALSE，使调用方能够中止而不会发生部分消耗。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/malum/proc/consume_required_offerings(turf/altar)
	if(!altar)
		return FALSE
	// 在消耗的那一刻重新定位每块锭料（不要信任先前捕获的引用，
	// 因为它们在此期间可能已被移动/qdel）。
	var/obj/item/ingot/copper/copper_ingot = locate() in altar
	var/obj/item/ingot/iron/iron_ingot = locate() in altar
	var/obj/item/ingot/silver/silver_ingot = locate() in altar
	var/obj/item/ingot/gold/gold_ingot = locate() in altar
	var/obj/item/ingot/steelholy/steelholy_ingot = locate() in altar
	// 此刻若有任何一块已不存在，便拒绝消耗其余的。
	if(!copper_ingot || !iron_ingot || !silver_ingot || !gold_ingot || !steelholy_ingot)
		return FALSE
	// 全部齐备 -> 各销毁一块。qdel 会干净地将它们从格子上移除。
	qdel(copper_ingot)
	qdel(iron_ingot)
	qdel(silver_ingot)
	qdel(gold_ingot)
	qdel(steelholy_ingot)
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：这场仪式是否对主持者毫无新增收益？
// 仅当其【同时】拥有两项强化特质，【且】每一项目标技能都已达到/超过基础等级时
// 才返回 TRUE —— 也就是说，这场献祭会被白白浪费。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/malum/proc/already_fully_empowered(mob/living/user)
	// 缺少任一特质都意味着仍有可获得的收益。
	if(!HAS_TRAIT(user, TRAIT_SMITHING_EXPERT))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_KAZENGUNITE_SMITH))
		return FALSE
	// 任一目标技能低于基础等级都意味着仍有可获得的收益。
	for(var/skill_path in malicious_skill_targets())
		if(user.get_skill_level(skill_path) < MALICIOUS_SKILL_BASE_RANK)
			return FALSE
	// 两项特质皆持有、且四项技能都已达到/超过基础等级 -> 无物可授。
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：实际应用这三项奖励。从仪式流程中拆分出来，
// 使授予逻辑能够独立地被测试/阅读，并清晰地逐条列出。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/malum/proc/grant_malicious_skill(mob/living/user)
	// 效果 1 —— 将每项目标制造技能提升【至多到】2 级。当技能已达到/超过目标时，
	// adjust_skillrank_up_to() 不做任何操作，因此一位老练的铁匠绝不会被把更高的
	// 等级拉回到学徒。
	for(var/skill_path in malicious_skill_targets())
		user.adjust_skillrank_up_to(skill_path, MALICIOUS_SKILL_BASE_RANK)

	// 效果 2 —— 解除这四项技能的等级上限。武器锻造/护甲锻造/铁匠/冶炼 各自的
	// `trait_uncap` 中都列有 TRAIT_SMITHING_EXPERT，它会把它们的有效上限提升到传奇
	//（见 get_effective_skill_cap()）。我们使用标准的 TRAIT_GENERIC 来源，使该特质
	// 永久存在（而非绑定在玩家可能丢弃的某件物品上）。
	if(!HAS_TRAIT(user, TRAIT_SMITHING_EXPERT))
		ADD_TRAIT(user, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)

	// 效果 3 —— 解锁所有受特质限制的铁砧锻造知识。藏于某个 `req_trait` 之后的铁砧
	// 配方，靠持有该特质来解锁；本代码库中受特质限制的锻造传承是风郡（Kazengunite）
	// 流派（TRAIT_KAZENGUNITE_SMITH），因此授予它便打开了铁砧上所有受特质限制的配方。
	if(!HAS_TRAIT(user, TRAIT_KAZENGUNITE_SMITH))
		ADD_TRAIT(user, TRAIT_KAZENGUNITE_SMITH, TRAIT_GENERIC)

// --- 清理本文件局部的 define，避免它们泄漏到其它文件中 -----
#undef MALICIOUS_SKILL_BASE_RANK
#undef MALICIOUS_SKILL_RITE_NAME
