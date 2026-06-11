/datum/skill/labor
	abstract_type = /datum/skill/labor
	name = "劳作"
	desc = ""
	color = "#78c472"

/datum/skill/labor/farming
	name = "农耕"
	desc = "让我能够辨认种子，并提高农务相关工作的效率与成功率。"
	dreams = list(
		"……粪肥的气味曾令人作呕，如今却闻起来像是机会。土地饥渴难耐，而我也愿意为此双手沾泥……",
		"……我不断刨地、犁田，直到肌肉酸痛不已。白日漫长，而今天摘下的苹果，很快就会被做成可口的派……",
		"……我跪在泥土间，为亲手播下的种子浇水。一垄垄作物在眼前延展，青翠而茁壮。想到我的劳作很快就会化作丰收，我心中满是满足……"
	)
	expert_name = "农夫"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/labor/mining
	name = "采矿"
	desc = "提高采矿速度。"
	dreams = list(
		"……岩石崩裂，面前的石壁轰然让开。漫长的一天让我的鹤嘴镐满是裂痕，残破不堪。就在这时，我挖进了一处亮得古怪的洞窟……",
		"……古老岩层中渗出赤红闪耀的光芒，它的守望者是一位矮小而蓄须的隐士，正向我提出有关最强钢铁的谜题……",
		"……那位矮人大师向我发问：‘最坚之材乃吾等所求；我自群山与浅滩中采得，却又并非金属。’这位古老矿工被地底污浊的空气呛得咳嗽，随后继续说道……",
		"……宝石在他掌中闪闪发亮，老矮人沙哑地问道：‘我必须四分锻成。我是什么？’……",
		"……随后，谜底忽然来到我心头，仿佛它一直就在那里。一块煤。矮人满意地微笑着，将山之心递到了我手中……"
	)
	expert_name = "矿工"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/labor/fishing
	name = "钓鱼"
	desc = "提高垂钓速度，最短可降至 2 秒，并提升上鱼概率。至少需要新手水平，才能避免沉重惩罚。"
	dreams = list(
		"……我在深渊般虚空中的小船上，笨拙地试着解开缠成死结的鱼线，感觉像过去了好几个时辰。一只巨大、苍白而布满老茧的手从我手中接过鱼线，顷刻间便将其理顺……",
		"……老商人点了点头，递给我一小袋鱼饵：蚯蚓、蛆虫，甚至还有几片奶酪。据说每一样都能为我再带来一份 Abyssor 的恩赐……"
	)
	expert_name = "渔夫"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SURVIVAL_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/labor/butchering
	name = "屠宰"
	desc = "提高屠宰速度，增加分解肢体时的收获。若高于剥皮工艺技能，则会改用它决定鞣制兽皮时的速度、产量与获得荒野精华的概率。"
	dreams = list(
		"……一个像是父亲的人拧断了家里公鸡的脖子。他一边开膛，一边谈论血污与节俭，让我看得目不转睛……",
		"……我的双手沾满鲜血，正用屠夫围裙擦拭时，门铃响了。一位戴兜帽的顾客走进肉铺，瞥了我一眼染血的装束，若有所思地问我今天卖什么肉……",
		"……刀锋划过油脂、筋络与骨头，尸体在我手下逐渐分解。屠夫之艺，便是将生命转化为养分……",
	)
	expert_name = "屠夫"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SEWING_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SURVIVAL_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/labor/lumberjacking
	name = "伐木"
	desc = "提高伐木速度。达到新手或以上时，至少能从树上获得两根小木料。技能越高，最低产量与获得荒野精华的概率也越高。"
	dreams = list(
		"……木屑四散飞溅，大树轰然倒地，雷鸣般的巨响在整片森林中回荡……",
		"……我拉着锯子，对面的蓄须伐木工也一同发力。参天橡树发出低沉呻吟，摇摇欲坠……"
	)
	expert_name = "伐木工"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)
