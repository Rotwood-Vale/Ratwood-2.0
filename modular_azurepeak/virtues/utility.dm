/datum/virtue/utility/noble
	name = "贵胄"
	desc = "无论凭借出身、武勇还是才智，我都是这片土地上受王室认可的贵族，也享有与之相称的一切好处。我还巧妙地藏起了一笔可观钱财，以及一件家传遗物。"
	added_traits = list(TRAIT_NOBLE)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))
	added_stashed_items = list("传家护符" = /obj/item/clothing/neck/roguetown/ornateamulet/noble,
								"厚实钱袋" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch)

/datum/virtue/utility/noble/apply_to_human(mob/living/carbon/human/recipient)
	SStreasury.noble_incomes[recipient] += 15

/datum/virtue/utility/socialite
	name = "社交名流"
	desc = "我在社交场合如鱼得水，能轻易读出他人情绪，也总能迷住身边的人。无论什么聚会，我的存在感都不会被忽视。"
	custom_text = "与“丑陋”美德不兼容。获得共情洞察。"
	added_traits = list(TRAIT_BEAUTIFUL, TRAIT_GOODLOVER, TRAIT_EMPATH)
	added_stashed_items = list(
		"手镜" = /obj/item/handmirror)

/datum/virtue/utility/socialite/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(HAS_TRAIT(recipient, TRAIT_UNSEEMLY))
		to_chat(recipient, "你的吸引力被抵消了！你变得平平无奇。")
		if(HAS_TRAIT(recipient, TRAIT_BEAUTIFUL))
			REMOVE_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
		REMOVE_TRAIT(recipient, TRAIT_UNSEEMLY, TRAIT_VIRTUE)

/datum/virtue/utility/deadened
	name = "麻木"
	desc = "过去那场可怖的变故深深染透了我的人生，而如今，我已感受不到任何东西。"
	added_traits = list(TRAIT_NOMOOD, TRAIT_DETACHED)

/datum/virtue/utility/light_steps
	name = "轻步无声"
	desc = "多年的潜行摸索让我的脚步变得安静，也让我的蜷身步态快了不少。"
	added_traits = list(TRAIT_LIGHT_STEP)
	added_skills = list(list(/datum/skill/misc/sneaking, 3, 6))

/datum/virtue/utility/resident
	name = "居民"
	desc = "我是这片土地上的居民。我在城市金库里有账户，也在城里有一处住处。"
	added_traits = list(TRAIT_RESIDENT)

/datum/virtue/utility/resident/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient?.mind)
		return

	var/assigned_role = recipient.mind.assigned_role
	if(!(assigned_role in list("Adventurer", "Mercenary", "Court Agent")))
		return

	sync_towner_knowledge(recipient)
	SSjob.sync_resident_wanderer_knowledge(recipient, TRUE)

/datum/virtue/utility/resident/proc/sync_towner_knowledge(mob/living/carbon/human/recipient)
	if(!recipient?.mind)
		return

	var/datum/job/roguetown/villager/towner_job = SSjob.GetJob("Towner")
	if(!towner_job)
		return

	for(var/X in towner_job.peopleknowme)
		for(var/datum/mind/MF in get_minds(X))
			if(isnull(recipient.mind?.special_role) && (MF?.special_role in list(ROLE_VAMPIRE, ROLE_NBEAST, ROLE_BANDIT, ROLE_LICH, ROLE_WRETCH, ROLE_UNBOUND_DEATHKNIGHT)))
				continue
			recipient.mind.person_knows_me(MF)

	for(var/X in towner_job.peopleiknow)
		for(var/datum/mind/MF in get_minds(X))
			if(isnull(recipient.mind?.special_role) && (MF?.special_role in list(ROLE_VAMPIRE, ROLE_NBEAST, ROLE_BANDIT, ROLE_LICH, ROLE_WRETCH, ROLE_UNBOUND_DEATHKNIGHT)))
				continue
			recipient.mind.i_know_person(MF)

/datum/virtue/utility/failed_squire
	name = "落选侍从"
	desc = "我曾是受训中的侍从，却未能最终成为骑士。虽然荣光之梦早已破碎，但我仍保留着维护与修理装备的知识，包括如何擦亮武器和甲胄。"
	added_traits = list(TRAIT_SQUIRE_REPAIR)
	added_stashed_items = list(
		"锤子" = /obj/item/rogueweapon/hammer/iron,
		"抛光膏" = /obj/item/polishing_cream,
		"细刷" = /obj/item/armor_brush
	)

/datum/virtue/utility/failed_squire/apply_to_human(mob/living/carbon/human/recipient)
	to_chat(recipient, span_notice("尽管你没能成为骑士，但你在装备维护与修理上的训练依旧派得上用场。"))
	to_chat(recipient, span_notice("你可以从树、雕像或时钟里取回自己的锤子和抛光工具。"))

/datum/virtue/utility/linguist
	name = "学识渊博"
	desc = "我一生都浸润在书卷与各地见闻之中，不论是旅行还是命运的安排，都让我结识了许多博学之士与异乡人。我因此学会了多种语言，也养成了随身记述的习惯。我能准确判断他人的本事。"
	custom_text = "将“评估”收益提升至最大，并额外获知目标属性加成。开局可额外选择学习3种语言。+1智力。"
	added_traits = list(TRAIT_INTELLECTUAL)
	added_skills = list(list(/datum/skill/misc/reading, 3, 6))
	added_stashed_items = list(
		"Quill" = /obj/item/natural/feather,
		"Scroll #1" = /obj/item/paper/scroll,
		"Scroll #2" = /obj/item/paper/scroll,
		"Book Crafting Kit" = /obj/item/book_crafting_kit
	)

/datum/virtue/utility/linguist/apply_to_human(mob/living/carbon/human/recipient)
	recipient.change_stat(STATKEY_INT, 1)
	addtimer(CALLBACK(src, .proc/linguist_apply, recipient), 50)

/datum/virtue/utility/linguist/proc/linguist_apply(mob/living/carbon/human/recipient)
	var/static/list/selectable_languages = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/orcish,
		/datum/language/hellspeak,
		/datum/language/draconic,
		/datum/language/celestial,
		/datum/language/grenzelhoftian,
		/datum/language/canilunzt,
		/datum/language/kazengunese,
		/datum/language/otavan,
		/datum/language/etruscan,
		/datum/language/gronnic,
		/datum/language/hammerholdian,
		/datum/language/aavnic,
		/datum/language/abyssal,
		/datum/language/merar
	)

	var/list/choices = list()
	for(var/language_type in selectable_languages)
		if(recipient.has_language(language_type))
			continue
		var/datum/language/a_language = new language_type()
		choices[a_language.name] = language_type

	if(length(choices))	//If this isn't true then we have no new languages learn -- we probably picked archivist
		var/lang_count = 3
		var/count = lang_count
		for(var/i in 1 to lang_count)
			var/chosen_language = input(recipient, "选择你额外掌握的口语。", "美德：剩余[count]次") as null|anything in choices
			if(chosen_language)
				var/language_type = choices[chosen_language]
				recipient.grant_language(language_type)
				choices -= chosen_language
				to_chat(recipient, span_info("我回想起了[chosen_language]的知识……"))
				count--

/datum/virtue/utility/deathless
	name = "不朽"
	desc = "某种邪异魔法使我内里近乎不死不生，我不再饥饿，也无需呼吸。"
	added_traits = list(TRAIT_NOHUNGER, TRAIT_NOBREATH)

/datum/virtue/utility/deathless/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(HAS_TRAIT(recipient, TRAIT_HEMOPHAGE))
		to_chat(recipient, "我对生命之血的依赖无法被切断！")
		REMOVE_TRAIT(recipient, TRAIT_NOHUNGER, TRAIT_VIRTUE)

/datum/virtue/utility/feral_appetite
	name = "野性食欲"
	desc = "生食、有毒食物或腐坏食物都奈何不了我强韧的消化系统。"
	added_traits = list(TRAIT_NASTY_EATER)

/datum/virtue/utility/feral_appetite/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(HAS_TRAIT(recipient, TRAIT_HEMOPHAGE))
		to_chat(recipient, "我对生命之血的依赖无法被切断！")
		REMOVE_TRAIT(recipient, TRAIT_NASTY_EATER, TRAIT_VIRTUE)

/datum/virtue/utility/night_vision
	name = "夜视"
	desc = "我的双眼足以看穿令人窒闷的黑暗。与“色盲”癖性不兼容。"
	added_traits = list(TRAIT_DARKVISION)
	custom_text = "新增一个切换色盲视效的按钮，以便在黑暗中视物。若同时选择“色盲”癖性，你将永久处于色盲状态。"

/datum/virtue/utility/night_vision/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.charflaw)
		if(recipient.charflaw.type == /datum/charflaw/colorblind)
			to_chat(recipient, "你的双眼已永久失去辨色能力。")
		else
			recipient.verbs += /mob/living/carbon/human/proc/toggleblindness

/datum/virtue/utility/performer
	name = "表演者"
	desc = "音乐、艺术与表演伴我走过一生。我藏好了一件自己最喜爱的乐器，也懂得如何取悦他人，以及如何让起哄者闭嘴。"
	custom_text = "自带一件你预先藏好的乐器。进入游戏后可自行选择乐器种类。"
	added_traits = list(TRAIT_NUTCRACKER, TRAIT_GOODLOVER)
	added_skills = list(list(/datum/skill/misc/music, 4, 6)) //Allows them uplaod custom music

/datum/virtue/utility/performer/apply_to_human(mob/living/carbon/human/recipient)
	addtimer(CALLBACK(src, .proc/performer_apply, recipient), 50)

/datum/virtue/utility/performer/proc/performer_apply(mob/living/carbon/human/recipient)
	var/list/instruments = list()
	for(var/instrument_type in subtypesof(/obj/item/rogue/instrument))
		if(instrument_type == /obj/item/rogue/instrument/harp/handcarved)
			continue //Skip the donator personal item harp.
		var/obj/item/rogue/instrument/instr = new instrument_type()
		instruments[instr.name] = instrument_type
		qdel(instr)  // Clean up the temporary instance

	var/chosen_name = input(recipient, "我藏了哪件乐器？", "藏匿物") as null|anything in instruments
	if(chosen_name)
		var/instrument_type = instruments[chosen_name]
		recipient.mind?.special_items[chosen_name] = instrument_type

/datum/virtue/utility/mean
	name = "后天嗜好"
	desc = "尽管你的嗜好颇为离经叛道，你仍懂得如何让床伴措手不及、败下阵来。激情之中总会发生些“意外”，或许你也乐在其中；与你同床，本就是一场赌局。好在你总备着些私藏“小玩意”来招待客人。"
	added_traits = list(TRAIT_DEATHBYSNUSNU, TRAIT_NUTCRACKER)
	added_stashed_items = list("Bag of Fetish Gear" = /obj/item/storage/roguebag/fetish)

/datum/virtue/utility/larcenous
	name = "惯偷"
	desc = "无论是受人所托，还是你那空洞心中对刺激的渴望驱使，你总会去觊觎不属于自己的东西。你知道该如何开锁，也早已为此偷偷藏好了一串钥匙。"
	added_stashed_items = list("Lockpick Ring" = /obj/item/lockpickring/mundane)
	added_skills = list(list(/datum/skill/misc/lockpicking, 3, 6))

/datum/virtue/utility/granary
	name = "精明补给者"
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	desc = "你曾在码头或其周边讨生活，顺手摸走一袋没人会在意的补给，以备不时之需。闲暇时，你也学会了些烹饪与钓鱼的门道。"
	added_stashed_items = list("Bag of Food" = /obj/item/storage/roguebag/food)
	added_skills = list(list(/datum/skill/craft/cooking, 3, 6),
						list(/datum/skill/labor/fishing, 2, 6))

/datum/virtue/utility/forester
	name = "林地行者"
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	desc = "森林才是你的家，至少曾经如此。你始终渴望重返林间、再度自由游荡，也未曾忘记如何自给自足地活下去。"
	added_stashed_items = list("Trusty hoe" = /obj/item/rogueweapon/hoe)
	added_skills = list(list(/datum/skill/craft/cooking, 2, 2),
						list(/datum/skill/misc/athletics, 2, 2),
						list(/datum/skill/labor/farming, 2, 2),
						list(/datum/skill/labor/fishing, 2, 2),
						list(/datum/skill/labor/lumberjacking, 2, 2)
	)

/datum/virtue/utility/homesteader
	name = "朝圣者（-3 TRI）"
	added_traits = list(TRAIT_HOMESTEAD_EXPERT)
	desc= "正如人们所说，“心安之处即为家园”。你深谙生活劳作之道，也早已藏好重新开始所需的一切：猎刀、趁手的锄头，以及一袋杂项补给。"
	triumph_cost = 3
	added_stashed_items = list(
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Bag of Food" = /obj/item/storage/roguebag/food,
		"Hunting Knife" = /obj/item/rogueweapon/huntingknife
	)
	added_skills = list(list(/datum/skill/craft/cooking, 3, 3),
						list(/datum/skill/misc/athletics, 2, 2),
						list(/datum/skill/labor/farming, 3, 3),
						list(/datum/skill/labor/fishing, 3, 3),
						list(/datum/skill/labor/lumberjacking, 2, 2),
						list(/datum/skill/combat/knives, 2, 2)
	)

/datum/virtue/utility/ugly
	name = "丑陋"
	desc = "无论是家族恶习、你自己的选择，还是赛利克斯残酷命运的掷骰，你都变得令人不忍直视。蜷缩在城镇无人问津的角落缝隙中，你早已习惯那些伴随你而来的恶臭。尸体对你而言并不发臭，而那大概也是你唯一能拥有的“陪伴”。"
	custom_text = "与“美貌”美德不兼容。"
	added_traits = list(TRAIT_UNSEEMLY, TRAIT_NOSTINK)

/datum/virtue/utility/ugly/handle_traits(mob/living/carbon/human/recipient)
	..()
	if(HAS_TRAIT(recipient, TRAIT_BEAUTIFUL))
		to_chat(recipient, "你的丑陋被抵消了！你恢复成了常人模样。")
		REMOVE_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)
		REMOVE_TRAIT(recipient, TRAIT_UNSEEMLY, TRAIT_VIRTUE)

/datum/virtue/utility/secondvoice
	name = "第二嗓音"
	desc = "或因表演，或因欺瞒，又或是出于某种怪异的自我改造，你获得了第二副完美的嗓音。你可随时在两种声音间切换。"
	custom_text = "解锁新的“记忆”标签页，可在其中设置并切换你的声音。"

/datum/virtue/utility/secondvoice/apply_to_human(mob/living/carbon/human/recipient)
	recipient.verbs += /mob/living/carbon/human/proc/changevoice
	recipient.verbs += /mob/living/carbon/human/proc/swapvoice

/datum/virtue/utility/keenears
	name = "灵敏听觉"
	desc = "无论是为躲避当局、亲友，还是神明慷慨却古怪的馈赠，你都练就了敏锐的听觉。即便看不见说话者，你也能辨认其身份，他们的低语在你耳中更是格外清晰。"
	added_traits = list(TRAIT_KEENEARS)
	custom_text = "即使目标不在视野中，你也能辨认出熟人说话的声音。无视障碍，你都能听见上下楼层的正常交谈。你还能多隔1格听见悄声细语。"

/datum/virtue/utility/tracker
	name = "侦探"
	desc = "你很早就明白，追踪一个人的能力，既能用来维护法律，也同样能用来逃避它。"
	added_skills = list(list(/datum/skill/misc/tracking, 3, 6))
	added_traits = list(TRAIT_SLEUTH)
	custom_text = "- 右键点击痕迹后，你可标记留下它的人<i>（需要专家技能，且并非该美德独占）</i>。\n- 之后发现的同一目标痕迹会自动高亮；若其当前未潜行或隐形，目标本人也会一并高亮。\n- 缩短追踪冷却，可立即检查痕迹，且移动不再打断追踪。\n- 额外地，无论<i>你自己</i>是否具有贵族身份，都能阅读他人的贵族流言。"

/datum/virtue/utility/bronzearm_r
	name = "青铜臂（右）"
	desc = "凭借人脉或财富，我的一只手臂被替换成了由青铜与齿轮构成的义肢，能够抓握并持物。也因此，我顺带学会了一点工程学。"
	custom_text = "将你的右臂替换为青铜义肢。与“木臂（右）”癖性不兼容。"
	added_skills = list(list(/datum/skill/craft/engineering, 1, 6))

/datum/virtue/utility/bronzearm_r/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	var/obj/item/bodypart/O = recipient.get_bodypart(BODY_ZONE_R_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	if(recipient.charflaw)
		if(recipient.charflaw.type == /datum/charflaw/limbloss/arm_r)
			to_chat(recipient, span_info("我愚蠢地信了个骗子，竟想把我的木臂换成一条青铜臂。结果它散架了。如今我连手臂都没了。"))
		else
			var/obj/item/bodypart/r_arm/prosthetic/bronzeright/L = new()
			L.attach_limb(recipient)

/datum/virtue/utility/bronzearm_l
	name = "青铜臂（左）"
	desc = "凭借人脉或财富，我的一只手臂被替换成了由青铜与齿轮构成的义肢，能够抓握并持物。也因此，我顺带学会了一点工程学。"
	custom_text = "将你的左臂替换为青铜义肢。与“木臂（左）”癖性不兼容。"
	added_skills = list(list(/datum/skill/craft/engineering, 1, 6))

/datum/virtue/utility/bronzearm_l/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	var/obj/item/bodypart/O = recipient.get_bodypart(BODY_ZONE_L_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	if(recipient.charflaw)
		if(recipient.charflaw.type == /datum/charflaw/limbloss/arm_l)
			to_chat(recipient, span_info("我愚蠢地信了个骗子，竟想把我的木臂换成一条青铜臂。结果它散架了。如今我连手臂都没了。"))
		else
			var/obj/item/bodypart/l_arm/prosthetic/bronzeleft/L = new()
			L.attach_limb(recipient)

/datum/virtue/utility/woodwalker
	name = "林行者"
	desc = "在荒野中历经多年锻炼后，我已学会自信地穿行林地而不折断枝条。我甚至能轻踏树叶而不坠落，还能从灌木中采集到双倍的收获。我也能舒舒服服地睡在树枝上。"
	added_traits = list(TRAIT_WOODWALKER, TRAIT_OUTDOORSMAN)

/datum/virtue/heretic/zchurch_keyholder
	name = "亵渎钥匙持有者"
	desc = "“神圣”圣座有他们染血的地盘，我们也有我们的。在他们眼皮底下，我们向真正的诸神祈祷，我知道本地异端密会的所在。保密至关重要；一旦暴露，我必死无疑。"
	added_traits = list(TRAIT_ZURCH)

/datum/virtue/utility/mountable
	name = "可骑乘"
	desc = "你受过训练，或被训练成了合适的坐骑。别人可以像骑赛加羚一样骑乘你。"
	added_traits = list(TRAIT_PONYGIRL_RIDEABLE)

/datum/virtue/utility/tolerant
	name = "耐受"
	desc = "无论是因旅行见识，还是因相处照料，你对某些族类就是不觉得有什么问题。"
	custom_text = "当你看到特定种族时，不会触发负面压力事件。"
	added_traits = list(TRAIT_TOLERANT)

// Apprentice-level virtues - provide broad skill sets without traits or items
// Max skill level is Apprentice (level 2), allowing varied work without full progression

/datum/virtue/utility/survivalist_novice
	name = "新手求生者"
	desc = "我曾在荒野中生活，学会了靠土地求生。我会狩猎、追踪、钓鱼、设陷与屠宰猎物，这些都是在文明高墙之外活下去所必需的本领。"
	added_skills = list(
		list(/datum/skill/misc/tracking, 1, 2),
		list(/datum/skill/labor/butchering, 1, 2),
		list(/datum/skill/craft/tanning, 1, 2),
		list(/datum/skill/combat/polearms, 1, 2),
		list(/datum/skill/combat/slings, 1, 2),
		list(/datum/skill/craft/crafting, 1, 2),
		list(/datum/skill/craft/cooking, 1, 2),
		list(/datum/skill/labor/lumberjacking, 1, 2),
		list(/datum/skill/misc/climbing, 1, 2),
		list(/datum/skill/misc/swimming, 1, 2),
		list(/datum/skill/misc/sneaking, 1, 2),
		list(/datum/skill/misc/medicine, 1, 1)
	)

/datum/virtue/utility/homesteader_novice
	name = "新手定居者"
	desc = "我懂得如何维持一处家园，耕种土地、烹煮饭食、劈柴劳作，以及一切自给自足所需的日常辛劳。"
	added_skills = list(
		list(/datum/skill/labor/farming, 1, 2),
		list(/datum/skill/craft/cooking, 1, 2),
		list(/datum/skill/labor/lumberjacking, 1, 2),
		list(/datum/skill/misc/lockpicking, 1, 2),
		list(/datum/skill/misc/climbing, 1, 2),
		list(/datum/skill/misc/athletics, 1, 2),
		list(/datum/skill/labor/fishing, 1, 2),
		list(/datum/skill/craft/masonry, 1, 2),
		list(/datum/skill/craft/carpentry, 1, 2),
		list(/datum/skill/craft/crafting, 1, 2),
		list(/datum/skill/combat/maces, 1, 2),
		list(/datum/skill/combat/axes, 1, 2)
	)

/datum/virtue/utility/artisan_novice
	name = "新手工匠"
	desc = "我学会了制作工艺的基础，能处理金属、布料与黏土。在工坊里我称得上样样都会一点，却样样都不算精通。"
	added_skills = list(
		list(/datum/skill/craft/crafting, 1, 2),
		list(/datum/skill/craft/blacksmithing, 1, 2),
		list(/datum/skill/craft/sewing, 1, 2),
		list(/datum/skill/craft/smelting, 1, 2),
		list(/datum/skill/craft/weaponsmithing, 1, 2),
		list(/datum/skill/craft/armorsmithing, 1, 2),
		list(/datum/skill/combat/knives, 1, 2),
		list(/datum/skill/craft/ceramics, 1, 2),
		list(/datum/skill/craft/engineering, 1, 2)
	)

/datum/virtue/utility/healer_novice
	name = "新手医者"
	desc = "我钻研过疗愈之术，懂得包扎伤口、调配药剂，并理解医学与炼金术的基础。"
	added_skills = list(
		list(/datum/skill/misc/medicine, 1, 2),
		list(/datum/skill/craft/alchemy, 1, 2),
		list(/datum/skill/misc/reading, 1, 2),
		list(/datum/skill/craft/crafting, 1, 2),
		list(/datum/skill/craft/sewing, 1, 2),
		list(/datum/skill/craft/cooking, 1, 2),
		list(/datum/skill/combat/knives, 1, 2)
	)
