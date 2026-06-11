/datum/advclass/homesteader
	name = "平民"
	tutorial = "你不隶属于任何行会，也不侍奉任何主人。别人往往只精于一门手艺，而你学会了因地制宜，什么活计都能接来做。无论你最终成为熟练工匠、荒野生存者，还是别的什么人，你的路都由自己走出来。今天，你打算干哪一行？"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/homesteader
	maximum_possible_slots = 10 // Should never fill, for the purpose of players to know what types towners are in round at the menu
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	subclass_stats = list(
		STATKEY_SPD = -1,
		STATKEY_STR = 1,
		STATKEY_CON = 1,
		STATKEY_INT = 2,
	)


//	adaptive_name = FALSE


	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,  //They don't get massive skilll list anymore aside of journeyman in few key areas.
	)

/datum/outfit/job/roguetown/homesteader/pre_equip(mob/living/carbon/human/H)
	..()
	// Homesteader cosmetic title selection
	H.adjust_blindness(-3)
	var/cosmetic_titles = list(
	"钓手",
	"工匠", "女工匠",
	"屠夫",
	"匠人", "女匠人",
	"信徒", "女信徒",
	"田工",
	"采集人",
	"林守",
	"自耕地主",
	"园丁",
	"巧匠",
	"乡野人",
	"草药师",
	"自耕民", "女自耕民",
	"持家人",
	"家主", "持家丈夫", "主妇",
	"猎人",
	"苦工",
	"小贵族",
	"石匠",
	"护工", "修女",
	"望族",
	"开拓者",
	"探矿人",
	"学者",
	"抄写员",
	"世家后嗣",
	"拓居者",
	"牧人",
	"铁匠",
	"乡镇医师",
	"乡镇巡林人",
	"商匠", "女商匠",
	"侍役",
	"村民",
	"织工",
	"村姑",
	"樵夫", "女樵夫",
	"外科郎中",
	"村姑", "侍役")
	var/cosmetic_choice = input(H, "选择你的外观称号。", "外观称号") as anything in cosmetic_titles

	switch(cosmetic_choice)
		if("信徒")
			to_chat(H, span_notice("你是信徒，是一名虔诚信奉信仰与乡里的平民。"))
			H.mind.cosmetic_class_title = "信徒"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("女信徒")
			to_chat(H, span_notice("你是女信徒，是一名虔诚信奉信仰与乡里的平民。"))
			H.mind.cosmetic_class_title = "女信徒"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("田工")
			to_chat(H, span_notice("你是田工，是在田地与泥土间劳作的人。"))
			H.mind.cosmetic_class_title = "田工"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("田间妇")
			to_chat(H, span_notice("你是田间妇，是在田地与泥土间劳作的人。"))
			H.mind.cosmetic_class_title = "田间妇"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("巧匠")
			to_chat(H, span_notice("你是巧匠，擅长零碎手艺与修补活计。"))
			H.mind.cosmetic_class_title = "巧匠"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("女巧匠")
			to_chat(H, span_notice("你是女巧匠，擅长零碎手艺与修补活计。"))
			H.mind.cosmetic_class_title = "女巧匠"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("乡野人")
			to_chat(H, span_notice("你是乡野人，是过着清贫日子的乡间住民。"))
			H.mind.cosmetic_class_title = "乡野人"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("草药师")
			to_chat(H, span_notice("你是草药师，熟知植物与它们的疗效。"))
			H.mind.cosmetic_class_title = "草药师"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("自耕民")
			to_chat(H, span_notice("你是自耕民，是开垦土地并守住家园的人。"))
			H.mind.cosmetic_class_title = "自耕民"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("女自耕民")
			to_chat(H, span_notice("你是女自耕民，是开垦土地并守住家园的人。"))
			H.mind.cosmetic_class_title = "女自耕民"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("家主")
			to_chat(H, span_notice("你是家主，是家宅与亲族的照看者。"))
			H.mind.cosmetic_class_title = "家主"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("持家丈夫")
			to_chat(H, span_notice("你是持家丈夫，是家宅与亲族的照看者。"))
			H.mind.cosmetic_class_title = "持家丈夫"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("主妇")
			to_chat(H, span_notice("你是主妇，是家宅与亲族的照看者。"))
			H.mind.cosmetic_class_title = "主妇"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("猎人")
			to_chat(H, span_notice("你是猎人，擅长追踪与猎捕野物。"))
			H.mind.cosmetic_class_title = "猎人"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("苦工")
			to_chat(H, span_notice("你是苦工，是个勤苦耐劳的平民。"))
			H.mind.cosmetic_class_title = "苦工"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("小贵族")
			to_chat(H, span_notice("你是小贵族，是门第不高的年轻贵胄。"))
			H.mind.cosmetic_class_title = "小贵族"
			H.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("女苦工")
			to_chat(H, span_notice("你是女苦工，是个勤苦耐劳的平民。"))
			H.mind.cosmetic_class_title = "女苦工"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("村民")
			to_chat(H, span_notice("你是村民，是聚落中的寻常百姓。"))
			H.mind.cosmetic_class_title = "村民"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("村妇")
			to_chat(H, span_notice("你是村妇，是聚落中的寻常百姓。"))
			H.mind.cosmetic_class_title = "村妇"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("工匠")
			to_chat(H, span_notice("你是工匠，精于自己的手艺与营生。"))
			H.mind.cosmetic_class_title = "工匠"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("女工匠")
			to_chat(H, span_notice("你是女工匠，精于自己的手艺与营生。"))
			H.mind.cosmetic_class_title = "女工匠"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("望族")
			to_chat(H, span_notice("你是望族出身，是富裕阶层的一员。"))
			H.mind.cosmetic_class_title = "望族"
			H.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("世家后嗣")
			to_chat(H, span_notice("你是世家后嗣，是贵胄血脉的后代。"))
			H.mind.cosmetic_class_title = "世家后嗣"
			H.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("开拓者")
			to_chat(H, span_notice("你是开拓者，是敢于在新土地上扎根的人。"))
			H.mind.cosmetic_class_title = "开拓者"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("女开拓者")
			to_chat(H, span_notice("你是女开拓者，是敢于在新土地上扎根的人。"))
			H.mind.cosmetic_class_title = "女开拓者"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("拓居者")
			to_chat(H, span_notice("你是拓居者，是在陌生土地上安家的人。"))
			H.mind.cosmetic_class_title = "拓居者"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("女拓居者")
			to_chat(H, span_notice("你是女拓居者，是在陌生土地上安家的人。"))
			H.mind.cosmetic_class_title = "女拓居者"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("商匠")
			to_chat(H, span_notice("你是商匠，精于买卖与手艺。"))
			H.mind.cosmetic_class_title = "商匠"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("女商匠")
			to_chat(H, span_notice("你是女商匠，精于买卖与手艺。"))
			H.mind.cosmetic_class_title = "女商匠"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("侍役")
			to_chat(H, span_notice("你是侍役，是为人跑腿服侍的下手。"))
			H.mind.cosmetic_class_title = "侍役"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("村民")
			to_chat(H, span_notice("你是村民，是聚落中的寻常百姓。"))
			H.mind.cosmetic_class_title = "村民"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("村妇")
			to_chat(H, span_notice("你是村妇，是聚落中的寻常百姓。"))
			H.mind.cosmetic_class_title = "村妇"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("织工")
			to_chat(H, span_notice("你是织工，擅长纺织与布料。"))
			H.mind.cosmetic_class_title = "织工"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("村姑")
			to_chat(H, span_notice("你是村姑，是出身卑微的乡野姑娘。"))
			H.mind.cosmetic_class_title = "村姑"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("樵夫")
			to_chat(H, span_notice("你是樵夫，最熟悉森林与木材。"))
			H.mind.cosmetic_class_title = "樵夫"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("女樵夫")
			to_chat(H, span_notice("你是女樵夫，最熟悉森林与木材。"))
			H.mind.cosmetic_class_title = "女樵夫"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("匠人")
			to_chat(H, span_notice("你是匠人，精于自己的行当。"))
			H.mind.cosmetic_class_title = "匠人"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("女匠人")
			to_chat(H, span_notice("你是女匠人，精于自己的行当。"))
			H.mind.cosmetic_class_title = "女匠人"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("采集人")
			to_chat(H, span_notice("你是采集人，靠从荒野搜罗所得为生。"))
			H.mind.cosmetic_class_title = "采集人"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("护工")
			to_chat(H, span_notice("你是护工，照料病人与伤者。"))
			H.mind.cosmetic_class_title = "护工"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("修女")
			to_chat(H, span_notice("你是修女，投身于信仰与服侍。"))
			H.mind.cosmetic_class_title = "修女"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("外科郎中")
			to_chat(H, span_notice("你是外科郎中，精于刀剪治疗与医术。"))
			H.mind.cosmetic_class_title = "外科郎中"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("钓手")
			to_chat(H, span_notice("你是钓手，善于垂钓与捕捞。"))
			H.mind.cosmetic_class_title = "钓手"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("织工")
			to_chat(H, span_notice("你是织工，擅长纺织与布料。"))
			H.mind.cosmetic_class_title = "织工"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("石匠")
			to_chat(H, span_notice("你是石匠，擅长石工与建筑。"))
			H.mind.cosmetic_class_title = "石匠"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("林守")
			to_chat(H, span_notice("你是林守，看护林地与木材。"))
			H.mind.cosmetic_class_title = "林守"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("乡镇巡林人")
			to_chat(H, span_notice("你是乡镇巡林人，守护道路与荒野。"))
			H.mind.cosmetic_class_title = "乡镇巡林人"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("探矿人")
			to_chat(H, span_notice("你是探矿人，四处寻找矿石与财运。"))
			H.mind.cosmetic_class_title = "探矿人"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("自耕地主")
			to_chat(H, span_notice("你是自耕地主，拥有属于自己的土地。"))
			H.mind.cosmetic_class_title = "自耕地主"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("持家人")
			to_chat(H, span_notice("你是持家人，维系着炉火与家宅。"))
			H.mind.cosmetic_class_title = "持家人"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("乡镇医师")
			to_chat(H, span_notice("你是乡镇医师，医治寻常百姓的病痛。"))
			H.mind.cosmetic_class_title = "乡镇医师"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("抄写员")
			to_chat(H, span_notice("你是抄写员，保管文字与记录。"))
			H.mind.cosmetic_class_title = "抄写员"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("世家后嗣")
			to_chat(H, span_notice("你是世家后嗣，是贵族家门的继承者。"))
			H.mind.cosmetic_class_title = "世家后嗣"
			H.social_rank = SOCIAL_RANK_MINOR_NOBLE
		if("学者")
			to_chat(H, span_notice("你是学者，通晓书本与知识。"))
			H.mind.cosmetic_class_title = "学者"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("屠夫")
			to_chat(H, span_notice("你是屠夫，擅长处理肉食与买卖。"))
			H.mind.cosmetic_class_title = "屠夫"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("园丁")
			to_chat(H, span_notice("你是园丁，打理花木与土壤。"))
			H.mind.cosmetic_class_title = "园丁"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("牧人")
			to_chat(H, span_notice("你是牧人，照看着自己的羊群。"))
			H.mind.cosmetic_class_title = "牧人"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("铁匠")
			to_chat(H, span_notice("你是铁匠，能锻打金属与工具。"))
			H.mind.cosmetic_class_title = "铁匠"
			H.social_rank = SOCIAL_RANK_YEOMAN
		if("村姑")
			to_chat(H, span_notice("你是村姑，是出身卑微的乡野姑娘。"))
			H.mind.cosmetic_class_title = "村姑"
			H.social_rank = SOCIAL_RANK_PEASANT
		if("侍役")
			to_chat(H, span_notice("你是侍役，是习惯为人奔走差遣的下手。"))
			H.mind.cosmetic_class_title = "侍役"
			H.social_rank = SOCIAL_RANK_PEASANT

	// STAT PACK SELECTION
	var/stat_packs = list("灵巧型 - 速度 +2，体质 +1，力量 -1，意志 -1", "书虫型 - 智力 +1，感知 +2，意志 +2，力量 -2，体质 -2", "壮实型 - 力量 +1，体质 +1，意志 +1，智力 -1", "均衡型 - 无变化")
	var/stat_choice = input(H, "选择你的属性倾向。[1/1]", "属性包选择") as anything in stat_packs

	switch(stat_choice)
		if("灵巧型 - 速度 +2，体质 +1，力量 -1，意志 -1")
			to_chat(H, span_notice("你身手灵活，动作轻快。"))
			H.change_stat(STATKEY_SPD, 2)
			H.change_stat(STATKEY_WIL, -1)
			H.change_stat(STATKEY_STR, -1)
			H.change_stat(STATKEY_CON, 1)
		if("书虫型 - 智力 +1，感知 +2，意志 +2，力量 -2，体质 -2")
			to_chat(H, span_notice("你博闻多识，也更有主见。"))
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_PER, 2)
			H.change_stat(STATKEY_WIL, 2)
			H.change_stat(STATKEY_STR, -2)
			H.change_stat(STATKEY_CON, -2)
		if("壮实型 - 力量 +1，体质 +1，意志 +1，智力 -1")
			to_chat(H, span_notice("你体魄强健，也更能吃苦。"))
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_CON, 1)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_INT, -1)
		if("均衡型 - 无变化")
			to_chat(H, span_notice("你各方面都相当均衡。"))
			// No stat changes for all-rounded

	// INVENTORY SELECTION
	// Profession Set Combinations
	var/profession_sets = list(
		"医士套装" = list(
			/obj/item/bedroll,
			/obj/item/rogueweapon/huntingknife/scissors,
			/obj/item/storage/belt/rogue/surgery_bag/full,
			/obj/item/storage/belt/rogue/pouch/medicine,
			/obj/effect/proc_holder/spell/invoked/diagnose/secular,
			/obj/item/storage/magebag/alchemist,
			/obj/item/folding_table_stored
		),
		"供给者套装" = list(
			/obj/item/storage/roguebag/food,
			/obj/item/folding_table_stored,
			/obj/item/storage/meatbag,
			/obj/item/millstone,
			/obj/item/rogueweapon/hoe
		),
		"探矿套装" = list(
			/obj/item/rogueweapon/hammer/steel,
			/obj/item/folding_table_stored,
			/obj/item/lockpickring/mundane,
			/obj/item/rogueweapon/pick,
			/obj/item/rogueweapon/huntingknife/scissors,
			/obj/item/rogueweapon/scabbard/gwstrap
		),
		"铁匠套装" = list(
			/obj/item/rogueweapon/hammer/copper,
			/obj/item/rogueweapon/tongs,
			/obj/item/rogueweapon/huntingknife/bronze,
			/obj/item/ingot/iron,
			/obj/item/ingot/iron,
			/obj/item/rogueore/coal
		),
		"工匠套装" = list(
			/obj/item/rogueweapon/stoneaxe/handaxe,
			/obj/item/rogueweapon/hammer/steel,
			/obj/item/folding_table_stored
		),
		"猎人套装" = list(
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow,
			/obj/item/quiver/arrows,
			/obj/item/rogueweapon/huntingknife/bronze,
			/obj/item/storage/meatbag,
			/obj/item/natural/worms,
			/obj/item/natural/worms
		),
		"渔夫套装" = list(
			/obj/item/fishingrod,
			/obj/item/natural/worms,
			/obj/item/natural/worms,
			/obj/item/natural/worms,
			/obj/item/rogueweapon/huntingknife/bronze,
			/obj/item/storage/roguebag
		),
		"裁缝套装" = list(
			/obj/item/rogueweapon/huntingknife/scissors,
			/obj/item/needle,
			/obj/item/natural/cloth,
			/obj/item/natural/cloth,
			/obj/item/natural/cloth,
			/obj/item/natural/bundle/fibers
		),
		"抄写员套装" = list(
			/obj/item/paper,
			/obj/item/paper,
			/obj/item/paper,
			/obj/item/paper/scroll,
			/obj/item/natural/feather
		)
	)

	// Daily Tools - basic combination
	var/daily_tools_combos = list(
		"青铜斧 + 青铜刀 + 刀鞘" = list(/obj/item/rogueweapon/stoneaxe/woodcut/bronze, /obj/item/rogueweapon/huntingknife/bronze, /obj/item/rogueweapon/scabbard/sheath),
		"简易弓 + 箭袋" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow, /obj/item/quiver/arrows),
		"铁矛 + 备用匕首" = list(/obj/item/rogueweapon/spear, /obj/item/rogueweapon/huntingknife/bronze, /obj/item/rogueweapon/scabbard/gwstrap),
		"鱼竿 + 蠕虫" = list(/obj/item/fishingrod, /obj/item/natural/worms, /obj/item/natural/worms),
		"镰刀 + 农锄" = list(/obj/item/rogueweapon/sickle, /obj/item/rogueweapon/hoe),
		"矿镐 + 铜锤" = list(/obj/item/rogueweapon/pick, /obj/item/rogueweapon/hammer/copper),
		"棍棒 + 绳索" = list(/obj/item/rogueweapon/mace/cudgel, /obj/item/rope, /obj/item/rope)
	)

	if(H.mind)
		// Select two profession sets
		for(var/i in 1 to 1)
			var/profession_set_name = input(H, "选择一套职业装备。[i]/1", "职业套装") as anything in profession_sets
			if(profession_set_name)
				var/profession_list = profession_sets[profession_set_name]
				var/counter = 1
				for(var/item_path in profession_list)
					if(ispath(item_path, /obj/effect/proc_holder/spell))
						// Handle spells - add directly to mind
						H.AddSpell(new item_path)
					else
						// Handle regular items - add to special_items with actual item name
						var/item_name = initial(item_path:name)
						var/unique_key = "[item_name] ([profession_set_name] [counter])"
						H.mind.special_items[unique_key] = item_path
					counter++
				if(profession_set_name == "Craftsman Set")
					ADD_TRAIT(H, TRAIT_MASTER_CARPENTER, TRAIT_GENERIC)
					ADD_TRAIT(H, TRAIT_MASTER_MASON, TRAIT_GENERIC)
				if(profession_set_name in profession_sets)
					profession_sets -= profession_set_name

		// Select one daily tools combo
		var/combo_name = input(H, "选择一组日常工具。[1/1]", "日用工具") as anything in daily_tools_combos
		if(combo_name)
			var/combo_list = daily_tools_combos[combo_name]
			var/counter = 1
			for(var/item_path in combo_list)
				var/item_name = initial(item_path:name)
				var/unique_key = "[item_name] ([combo_name] [counter])"
				H.mind.special_items[unique_key] = item_path
				counter++

	// OUTFIT SELECTION
	var/outfit_styles = list(
		"苦工 - 工人背心、长裤、靴子",
		"田间帮手 - 草帽、短衫、长裤",
		"樵夫 - 兜帽、工装背心、护腕",
		"渔夫 - 渔帽、短衫、工作背心",
		"工匠 - 长袍、紧身裤、毛皮披风",
		"裁缝 - 护裙、白色上衣、布腰带",
		"旅人 - 半披风、内衬衣、靴子",
		"乡野人 - 毛帽、短衫、皮靴",
		"矿工 - 武装帽、长裤、工作背心",
		"艺人 - 华帽、长衣、半披风",
		"朴素学者 - 眼镜、学者袍、披肩帽",
		"乡间人 - 草帽、女式上衣、短靴"
	)

	var/outfit_choice = input(H, "选择你的穿着风格。", "服装风格") as anything in outfit_styles

	// Set base items
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor

	switch(outfit_choice)
		if("苦工 - 工人背心、长裤、靴子")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
				head = /obj/item/clothing/head/roguetown/roguehood/random
			else
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
				pants = /obj/item/clothing/under/roguetown/trou
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
				head = /obj/item/clothing/head/roguetown/armingcap

		if("田间帮手 - 草帽、短衫、长裤")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				pants = /obj/item/clothing/under/roguetown/trou
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/strawhat

		if("樵夫 - 兜帽、工装背心、护腕")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			else
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
				pants = /obj/item/clothing/under/roguetown/trou
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/roguehood
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather

		if("渔夫 - 渔帽、短衫、工作背心")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
			else
				pants = /obj/item/clothing/under/roguetown/tights/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/fisherhat

		if("工匠 - 长袍、紧身裤、毛皮披风")
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			cloak = /obj/item/clothing/cloak/raincloak/furcloak
			head = /obj/item/clothing/head/roguetown/hatblu

		if("裁缝 - 护裙、白色上衣、布腰带")
			armor = /obj/item/clothing/suit/roguetown/armor/armordress
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			cloak = /obj/item/clothing/cloak/raincloak/furcloak
			belt = /obj/item/storage/belt/rogue/leather/cloth/lady

		if("旅人 - 半披风、内衬衣、靴子")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				pants = /obj/item/clothing/under/roguetown/trou
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			cloak = /obj/item/clothing/cloak/half
			head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood

		if("乡野人 - 毛帽、短衫、皮靴")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				pants = /obj/item/clothing/under/roguetown/trou
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			head = /obj/item/clothing/head/roguetown/hatfur

		if("矿工 - 武装帽、长裤、工作背心")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/brown
			else
				armor = /obj/item/clothing/suit/roguetown/armor/workervest
				pants = /obj/item/clothing/under/roguetown/trou
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
			head = /obj/item/clothing/head/roguetown/armingcap
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather

		if("艺人 - 华帽、长衣、半披风")
			shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			cloak = /obj/item/clothing/cloak/half
			head = /obj/item/clothing/head/roguetown/fancyhat
			belt = /obj/item/storage/belt/rogue/leather/cloth

		if("朴素学者 - 眼镜、学者袍、披肩帽")
			shirt = /obj/item/clothing/suit/roguetown/shirt/robe/archivist
			pants = /obj/item/clothing/under/roguetown/tights/random
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			head = /obj/item/clothing/head/roguetown/chaperon
			mask = /obj/item/clothing/mask/rogue/spectacles

		if("乡间人 - 草帽、女式上衣、短靴")
			if(H.pronouns == SHE_HER || H.pronouns == THEY_THEM_F)
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
			else
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
				pants = /obj/item/clothing/under/roguetown/trou
			shoes = /obj/item/clothing/shoes/roguetown/shortboots
			head = /obj/item/clothing/head/roguetown/strawhat
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	backl = /obj/item/storage/backpack/rogue/backpack

//Debloats their contents
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/rogueweapon/handsaw = 1,
						/obj/item/dye_brush = 1,
						/obj/item/reagent_containers/powder/salt = 1,
						/obj/item/reagent_containers/food/snacks/rogue/cheddar = 2,
						/obj/item/natural/cloth = 2,
						/obj/item/flashlight/flare/torch/lantern = 1,
//						/obj/item/book/rogue/yeoldecookingmanual = 1,
//						/obj/item/natural/worms = 2,
						/obj/item/rogueweapon/shovel/small = 1,
						/obj/item/rogueweapon/chisel = 1,
	)



	if(H.mind)
		// Skill selection with readable names
		var/misc_skills = list(
			"偷窃" = /datum/skill/misc/stealing,
			"音乐" = /datum/skill/misc/music,
			"阅读" = /datum/skill/misc/reading,
			"医术" = /datum/skill/misc/medicine,
			"追踪" = /datum/skill/misc/tracking,
			"开锁" = /datum/skill/misc/lockpicking,
			"潜行" = /datum/skill/misc/sneaking,
			"骑术" = /datum/skill/misc/riding
		)
		var/labor_skills = list(
			"农耕" = /datum/skill/labor/farming,
			"伐木" = /datum/skill/labor/lumberjacking,
			"捕鱼" = /datum/skill/labor/fishing,
			"屠宰" = /datum/skill/labor/butchering,
			"采矿" = /datum/skill/labor/mining
		)
		var/craft_skills = list(
			"缝纫" = /datum/skill/craft/sewing,
			"陶艺" = /datum/skill/craft/ceramics,
			"木工" = /datum/skill/craft/carpentry,
			"石工" = /datum/skill/craft/masonry,
			"工程" = /datum/skill/craft/engineering,
			"炼金" = /datum/skill/craft/alchemy,
			"鞣制" = /datum/skill/craft/tanning,
			"烹饪" = /datum/skill/craft/cooking,
			"武器锻造" = /datum/skill/craft/weaponsmithing,
			"护甲锻造" = /datum/skill/craft/armorsmithing,
			"铁匠锻造" = /datum/skill/craft/blacksmithing,
			"冶炼" = /datum/skill/craft/smelting
		)
		var/combat_skills = list(
			"斧术" = /datum/skill/combat/axes,
			"徒手" = /datum/skill/combat/unarmed,
			"刀术" = /datum/skill/combat/knives,
			"摔跤" = /datum/skill/combat/wrestling,
			"鞭与链枷" = /datum/skill/combat/whipsflails,
			"弓术" = /datum/skill/combat/bows,
			"弩术" = /datum/skill/combat/crossbows,
			"长柄武器" = /datum/skill/combat/polearms,
			"盾术" = /datum/skill/combat/shields,
			"投石索" = /datum/skill/combat/slings,
			"剑术" = /datum/skill/combat/swords,
			"锤术" = /datum/skill/combat/maces
		)

		// Select one skill to EXPERT
		var/expert_skill_name = input(H, "选择一项升至专家的技能。[1/1]", "技能选择") as anything in misc_skills + labor_skills + craft_skills
		if(expert_skill_name)
			H.adjust_skillrank_up_to(misc_skills[expert_skill_name] || labor_skills[expert_skill_name] || craft_skills[expert_skill_name], SKILL_LEVEL_EXPERT, TRUE)
			if(expert_skill_name in misc_skills)
				misc_skills -= expert_skill_name
			if(expert_skill_name in labor_skills)
				labor_skills -= expert_skill_name
			if(expert_skill_name in craft_skills)
				craft_skills -= expert_skill_name

		// Select four skills to JOURNEYMAN (from any category)
		for(var/i in 1 to 4)
			var/journeyman_name = input(H, "选择一项升至熟练的技能。[i]/4", "技能选择") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(journeyman_name)
				H.adjust_skillrank_up_to(misc_skills[journeyman_name] || labor_skills[journeyman_name] || craft_skills[journeyman_name] || combat_skills[journeyman_name], SKILL_LEVEL_JOURNEYMAN, TRUE)
				if(journeyman_name in misc_skills)
					misc_skills -= journeyman_name
				if(journeyman_name in labor_skills)
					labor_skills -= journeyman_name
				if(journeyman_name in craft_skills)
					craft_skills -= journeyman_name
				if(journeyman_name in combat_skills)
					combat_skills -= journeyman_name

		// Select two skills to APPRENTICE
		for(var/i in 1 to 3)
			var/apprentice_name = input(H, "选择一项升至学徒的技能。[i]/3", "技能选择") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(apprentice_name)
				H.adjust_skillrank_up_to(misc_skills[apprentice_name] || labor_skills[apprentice_name] || craft_skills[apprentice_name] || combat_skills[apprentice_name], SKILL_LEVEL_APPRENTICE, TRUE)
				if(apprentice_name in misc_skills)
					misc_skills -= apprentice_name
				if(apprentice_name in labor_skills)
					labor_skills -= apprentice_name
				if(apprentice_name in craft_skills)
					craft_skills -= apprentice_name
				if(apprentice_name in combat_skills)
					combat_skills -= apprentice_name

		// Select four skills to NOVICE
		for(var/i in 1 to 5)
			var/novice_name = input(H, "选择一项升至新手的技能。[i]/5", "技能选择") as anything in misc_skills + labor_skills + craft_skills + combat_skills
			if(novice_name)
				H.adjust_skillrank_up_to(misc_skills[novice_name] || labor_skills[novice_name] || craft_skills[novice_name] || combat_skills[novice_name], SKILL_LEVEL_NOVICE, TRUE)
				if(novice_name in misc_skills)
					misc_skills -= novice_name
				if(novice_name in labor_skills)
					labor_skills -= novice_name
				if(novice_name in craft_skills)
					craft_skills -= novice_name
				if(novice_name in combat_skills)
					combat_skills -= novice_name
