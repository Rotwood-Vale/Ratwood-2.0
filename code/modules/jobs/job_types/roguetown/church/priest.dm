GLOBAL_LIST_EMPTY(apostasy_players)
GLOBAL_LIST_EMPTY(cursed_players)
GLOBAL_LIST_EMPTY(excommunicated_players)
GLOBAL_LIST_EMPTY(heretical_players)
GLOBAL_LIST_EMPTY(priest_swap_timers)
#define PRIEST_ANNOUNCEMENT_COOLDOWN (2 MINUTES)
#define PRIEST_SERMON_COOLDOWN (30 MINUTES)
#define PRIEST_APOSTASY_COOLDOWN (10 MINUTES)
#define PRIEST_EXCOMMUNICATION_COOLDOWN (10 MINUTES)
#define PRIEST_CURSE_COOLDOWN (15 MINUTES)
#define PRIEST_SWAP_COOLDOWN (20 MINUTES)


/datum/job/roguetown/priest
	title = "Bishop"
	flag = PRIEST
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = JCOLOR_CHURCH
	f_title = "Bishop"
	allowed_races = RACES_NO_CONSTRUCT		//Too recent arrivals to ascend to priesthood.
	allowed_patrons = ALL_DIVINE_PATRONS
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "在这被不义之人充斥的世间，唯有神圣才是真正重要之物。 \
	哭泣之神早已离我们而去，取而代之的是十神统御凡世，而你要将祂们的智慧传讲给一切仍愿聆听神意之人。无信者正越来越多。 \
	你必须引领他们走向敬畏诸神的未来，因为你是圣座的一名主教。"
	whitelist_req = FALSE
	cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'

	spells = list(/obj/effect/proc_holder/spell/invoked/cure_rot, /obj/effect/proc_holder/spell/self/convertrole/templar, /obj/effect/proc_holder/spell/self/convertrole/monk, /obj/effect/proc_holder/spell/invoked/projectile/divineblast, /obj/effect/proc_holder/spell/invoked/wound_heal, /obj/effect/proc_holder/spell/invoked/takeapprentice)
	outfit = /datum/outfit/job/roguetown/priest
	display_order = JDO_PRIEST
	give_bank_account = 115
	min_pq = 5 // You should know the basics of things if you're going to lead the town's entire religious sector
	max_pq = null
	round_contrib_points = 5
	social_rank = SOCIAL_RANK_ROYAL
	//No nobility for you, being a member of the clergy means you gave UP your nobility. It says this in many of the church tutorial texts.
	virtue_restrictions = list(/datum/virtue/utility/noble)
	job_traits = list(
		TRAIT_CHOSEN,
		TRAIT_RITUALIST,
		TRAIT_GRAVEROBBER,
		TRAIT_RESONANCE,
		TRAIT_VOTARY,
		TRAIT_HOMESTEAD_EXPERT,
		TRAIT_HOLYWARRIOR,
	)
	advclass_cat_rolls = list(CTAG_BISHOP = 2)
	job_subclasses = list(
		/datum/advclass/bishop
	)

/datum/job/roguetown/priest/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
//Name stuff.
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/title = "主教"
		H.real_name = "[title] [prev_real_name]"
		H.name = "[title] [prev_name]"

		spawn(50)
			if(H && H.client)
				_delayed_path_choice(H)

/datum/advclass/bishop
	name = "主教"
	tutorial = "在这被不义之人充斥的世间，唯有神圣才是真正重要之物。 \
	哭泣之神早已离我们而去，取而代之的是十神统御凡世，而你要将祂们的智慧传讲给一切仍愿聆听神意之人。无信者正越来越多。 \
	你必须引领他们走向敬畏诸神的未来，因为你是圣座的一名主教。"
	outfit = /datum/outfit/job/roguetown/priest/basic
	subclass_languages = list(/datum/language/grenzelhoftian)
	category_tags = list(CTAG_BISHOP)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 2,
		STATKEY_STR = -1,
		STATKEY_CON = -1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"《十神箴行录》" = /obj/item/book/rogue/bibble,
	)

/datum/outfit/job/roguetown/priest
	job_bitflag = BITFLAG_HOLY_WARRIOR
	has_loadout = TRUE
	allowed_patrons = list(/datum/patron/divine/astrata)

/datum/outfit/job/roguetown/priest/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	neck = /obj/item/clothing/neck/roguetown/psicross/silver/undivided
	head = /obj/item/clothing/head/roguetown/priestmask
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	beltl = /obj/item/storage/keyring/priest
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	id = /obj/item/clothing/ring/active/nomag
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/priest
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/needle/pestra = 1,
		/obj/item/natural/worms/leech/cheele = 1, //little buddy
		/obj/item/ritechalk = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/holysee = 1,	//Unique knife from the Holy See
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/mini_flagpole/church,
	)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/holy, 6, TRUE)

	H.verbs |= /mob/living/carbon/human/proc/coronate_lord
	H.verbs |= /mob/living/carbon/human/proc/churchannouncement
	H.verbs |= /mob/living/carbon/human/proc/churchexcommunicate //your button against clergy
	H.verbs |= /mob/living/carbon/human/proc/churchpriestcurse //snowflake priests button. Will not sacrifice them
	H.verbs |= /mob/living/carbon/human/proc/churcheapostasy //punish the lamb reward the wolf
	H.verbs |= /mob/living/carbon/human/proc/completesermon
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic_priest)

/datum/job/roguetown/priest/proc/_pick_loyalist_miracles(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return
	var/t3_count = 2
	var/list/t4 = list()
	var/list/t3 = list()
	for(var/path as anything in GLOB.patrons_by_faith[/datum/faith/divine])
		var/datum/patron/patron = GLOB.patronlist[path]
		if(!patron || !patron.name)
			continue
		for(var/miracle in patron.miracles)
			var/obj/effect/proc_holder/checked_miracle = miracle
			if(patron.miracles[checked_miracle] == CLERIC_T4 && (initial(checked_miracle.priest_excluded) == FALSE))
				t4[initial(checked_miracle.name)] = checked_miracle
			if(patron.miracles[checked_miracle] == CLERIC_T3 && (initial(checked_miracle.priest_excluded) == FALSE))
				t3[initial(checked_miracle.name)] = checked_miracle
	for(var/miracle in t4)
		if(H.mind.has_spell(t4[miracle]))
			t4.Remove(miracle)
	for(var/miracle in t3)
		if(H.mind.has_spell(t3[miracle]))
			t3.Remove(miracle)
	var/t4_choice = input(H, "选择你的四阶神迹。", "领受神启") as anything in t4
	if(t4_choice)
		var/obj/effect/proc_holder/chosen_miracle = t4[t4_choice]
		H.mind.AddSpell(new chosen_miracle)
	for(var/i in 1 to t3_count)
		var/t3_choice = input(H, "选择你的三阶神迹。", "领受神启（剩余 [t3_count] 次）") as anything in t3
		if(t3_choice)
			var/obj/effect/proc_holder/chosen_miracle = t3[t3_choice]
			H.mind.AddSpell(new chosen_miracle)
			t3.Remove(t3_choice)
			t3_count--

/datum/job/roguetown/priest/proc/_delayed_path_choice(mob/living/carbon/human/H)
	if(!H || !H.client || !H.mind)
		return

	var/choice = alert(H, "选择你的道路。", "主教教义", "守旧派", "激进派")

	if(choice == "激进派")
		src.grant_radical_path(H)
	else
		src.grant_old_path(H)

/datum/job/roguetown/priest/proc/grant_old_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return
	REMOVE_TRAIT(H, TRAIT_CLERGYRADICAL, "job")
	H.verbs -= /mob/living/carbon/human/proc/change_patron
	H.reset_clergy_devotion(CLERIC_T4, CLERIC_REGEN_MAJOR, TRUE, CLERIC_REQ_4)
	_pick_loyalist_miracles(H)
	to_chat(H, span_notice("我仍将走在旧有的虔敬之道上。"))

/datum/job/roguetown/priest/proc/grant_radical_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return
	ADD_TRAIT(H, TRAIT_CLERGYRADICAL, "job")
	H.church_favor += 2400
	H.miracle_points += 8
	H.verbs |= /mob/living/carbon/human/proc/change_patron
	H.reset_clergy_devotion(CLERIC_T4, CLERIC_REGEN_MAJOR, TRUE, CLERIC_REQ_4)
	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/invoked/convert_heretic_priest))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic_priest, H)
	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/invoked/cure_rot))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/cure_rot, H)
	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/self/convertrole/templar))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/templar, H)
	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/self/convertrole/monk))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/monk, H)
	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/invoked/projectile/divineblast))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast, H)
	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/invoked/wound_heal))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_heal, H)
	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/invoked/takeapprentice))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/takeapprentice, H)
	to_chat(H, span_notice("我拥抱激进之道。"))

/datum/job/priest/vice //just used to change the priest title
	title = "Vice Priest"
	display_title = "副司祭"
	f_title = "Vice Priestess"
	flag = PRIEST
	department_flag = CHURCHMEN
	total_positions = 0
	spawn_positions = 0

/mob/living/carbon/human/proc/coronate_lord()
	set name = "加冕"
	set category = "Priest"
	to_chat (src, span_warning("为新统治者加冕，并将其灵魂与山谷王座绑定，是一项极其沉重的仪式。任何刚被加冕的高贵领主都将无法再被复活。你最好事先说清这一点。"))
	if(!mind)
		return
	if(world.time < 30 MINUTES)
		to_chat(src, span_warning("在一周之始便行加冕，是个不祥之兆。"))
		return FALSE
	if(!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("我得在礼拜堂里举行这件事。"))
		return FALSE
	for(var/mob/living/carbon/human/HU in get_step(src, src.dir))
		if(!HU.mind)
			continue
		if(HU.mind.assigned_role == "Grand Duke")
			continue
		if(!HU.head)
			continue
		if(!istype(HU.head, /obj/item/clothing/head/roguetown/crown/serpcrown))
			continue

		//Abdicate previous King
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.mind)
				if(HL.mind.assigned_role == "Grand Duke")
					HL.mind.assigned_role = "Towner" //So they don't get the innate traits of the king
			//would be better to change their title directly, but that's not possible since the title comes from the job datum
			if(HL.job == "Grand Duke")
				HL.job = "Duke Emeritus"

		//Coronate new King (or Queen)
		HU.mind.assigned_role = "Grand Duke"
		HU.job = "Grand Duke"
		//ADD_TRAIT(HU, TRAIT_DNR, JOB_TRAIT)
		SSticker.set_ruler_mob(HU)
		SSticker.regentmob = null
		var/dispjob = mind.assigned_role
		removeomen(OMEN_NOLORD)
		say("奉诸神之权威，我宣布你为整个山谷的统治者！")
		priority_announce("[real_name]，现任[dispjob]，已指定 [HU.real_name] 为 [SSmapping.map_adjustment.realm_name] 的继承者！", title = "[HU.real_name] 万岁！", sound = 'sound/misc/bell.ogg')
		var/datum/job/roguetown/nomoredukes = SSjob.GetJob("Grand Duke")
		if(nomoredukes)
			nomoredukes.total_positions = -1000 //We got what we got now.

/mob/living/carbon/human/proc/churchannouncement()
	set name = "布告"
	set category = "Priest"

	if(stat)
		return

	if (!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("我得在礼拜堂里进行此事。"))
		return FALSE

	var/announcementinput = input("向整个山谷高声宣告", "发布布告") as text|null
	if(announcementinput)
		if(!src.can_speak_vocal())
			to_chat(src,span_warning("我发不出声音！"))
			return FALSE
		if (!COOLDOWN_FINISHED(src, priest_announcement))
			to_chat(src, span_warning("你必须稍候片刻，才能再次宣讲。"))
			return
		visible_message(span_warning("[src] 深吸了一口气，准备向众人宣告些什么……"))
		if(do_after(src, 15 SECONDS, target = src)) // Reduced to 15 seconds from 30 on the original Herald PR. 15 is well enough time for sm1 to shove you.
			say(announcementinput)
			priority_announce("[announcementinput]", "主教布道", 'sound/misc/bell.ogg', sender = src)
			COOLDOWN_START(src, priest_announcement, PRIEST_ANNOUNCEMENT_COOLDOWN)
		else
			to_chat(src, span_warning("你的宣告被打断了！"))
			return FALSE

/obj/effect/proc_holder/spell/self/convertrole/templar
	name = "招募圣殿武士"
	new_role = "Templar"
	overlay_state = "recruit_templar"
	recruitment_faction = "Templars"
	recruitment_message = "侍奉十神吧，%RECRUIT！"
	accept_message = "为了十神！"
	refuse_message = "我拒绝。"

/obj/effect/proc_holder/spell/self/convertrole/monk
	name = "招募侍僧"
	new_role = "Acolyte"
	overlay_state = "recruit_acolyte"
	recruitment_faction = "Church"
	recruitment_message = "侍奉十神吧，%RECRUIT！"
	accept_message = "为了十神！"
	refuse_message = "我拒绝。"

/mob/living/carbon/human/proc/completesermon()
	set name = "布道"
	set category = "Priest"

	if (!mind)
		return

	if (!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("我得在礼拜堂里举行此事。"))
		return FALSE

	if (!COOLDOWN_FINISHED(src, priest_sermon))
		to_chat(src, span_warning("你现在还不能如此早地激励众人。"))
		return

	src.visible_message(span_notice("[src] 开始布道宣讲……"))

	if (!do_after(src, 120, target = src)) // 120 seconds
		src.visible_message(span_warning("[src] 停止了布道。"))
		return

	src.visible_message(span_notice("[src] 完成了布道，激励了附近众人！"))
	playsound(src.loc, 'sound/magic/bless.ogg', 80, TRUE)
	COOLDOWN_START(src, priest_sermon, PRIEST_SERMON_COOLDOWN)

	for (var/mob/living/carbon/human/H in view(7, src))
		if (!H.patron)
			continue

		if (istype(H.patron, /datum/patron/divine))
			H.apply_status_effect(/datum/status_effect/buff/sermon)
			H.add_stress(/datum/stressevent/sermon)
			to_chat(H, span_notice("你感受到了来自自己神祇的神圣肯定。"))

		else if (istype(H.patron, /datum/patron/inhumen))
			H.apply_status_effect(/datum/status_effect/debuff/hereticsermon)
			H.add_stress(/datum/stressevent/heretic_on_sermon)
			to_chat(H, span_warning("你的神祇因不悦而躁动不安。"))

		else
			// Other patrons - fluff only
			to_chat(H, span_notice("你身上似乎什么也没发生。"))

	return TRUE

/mob/living/carbon/human/proc/churchecancurse(mob/living/carbon/human/H, apostasy = FALSE)
	if (!H.devotion && apostasy)
		to_chat(src, span_warning("此人与十神的联系太过浅薄。"))
		return FALSE

	//Flavor messages for cursing certain god's faithful.
	//Dendor works in mysterious ways.
	if (istype(H.patron, /datum/patron/divine/dendor))
		to_chat(src, span_warning("你能强烈感受到疯狂之神 登多尔 的存在。此人体内的狼性在微弱的束缚下挣扎翻腾、躁动不安。"))
		//If we check this here there's no need to apply this trait preemtively to a bunch of people, and allows for greater fluff feedback.
		ADD_TRAIT(H, TRAIT_CURSE_RESIST, TRAIT_GENERIC)

	//Abyssor's clergy are gripped by his dream.
	if (istype(H.patron, /datum/patron/divine/abyssor))
		to_chat(src, span_warning("梦者 阿比索尔 已将这人牢牢攥在掌中。十神之光也只能勉强刺入那深渊般的黑暗。"))
		ADD_TRAIT(H, TRAIT_CURSE_RESIST, TRAIT_GENERIC)

	//Let's not curse heretical antags.
	if(HAS_TRAIT(H, TRAIT_HERESIARCH))
		to_chat(src, span_warning("此人的神祇庇护着他，使其免受压制。"))
		return FALSE

	return TRUE

/mob/living/carbon/human/proc/churcheapostasy(mob/living/carbon/human/H in GLOB.player_list)
	set name = "判为叛教"
	set category = "Priest"

	if (stat)
		return

	var/found = FALSE
	var/inputty = input("对某人施加叛教判罚，剥夺其使用神迹的能力……（再次施加可解除）", "罪人之名") as text|null

	if (!inputty)
		return

	if (!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("我得在十神圣堂中执行此事。"))
		return FALSE

	if(!src.key)
		return

	if(!src.mind || !src.mind.do_i_know(name=inputty))
		to_chat(src, span_warning("我不认识这个名字的人。"))
		return

	if (inputty in GLOB.apostasy_players)
		GLOB.apostasy_players -= inputty
		priority_announce("[real_name] 已宽恕 [inputty]。其信奉的神祇再次聆听到了他们的祈祷！", title = "叛教解除", sound = 'sound/misc/bell.ogg')
		message_admins("APOSTASY: [real_name] ([ckey]) has used forgiven apostasy at [H.real_name] ([H.ckey])")
		log_game("APOSTASY: [real_name] ([ckey]) has used forgiven apostasy at [H.real_name] ([H.ckey])")

		if (H.real_name == inputty)
			if (istype(H.patron, /datum/patron/divine) && H.devotion)
				H.remove_status_effect(/datum/status_effect/debuff/apostasy)
				H.remove_stress(/datum/stressevent/apostasy)

		return TRUE

	if (H.real_name == inputty)
		if (!COOLDOWN_FINISHED(src, priest_apostasy))
			to_chat(src, span_warning("你必须等待片刻，才能再给下一人打上标记。"))
			return

		//Check if we can curse this person.
		if(!churchecancurse(H))
			return

		found = TRUE
		GLOB.apostasy_players += inputty
		COOLDOWN_START(src, priest_apostasy, PRIEST_APOSTASY_COOLDOWN)

		var/curse_resist = HAS_TRAIT(H, TRAIT_CURSE_RESIST)

		if (istype(H.patron, /datum/patron/divine))
			H.apply_status_effect(/datum/status_effect/debuff/apostasy, curse_resist)
			H.add_stress(/datum/stressevent/apostasy)
			to_chat(H, span_warning("一阵神圣的寂静降临在你身上。你的神祇再也听不见你的祈祷了……"))
		else
			to_chat(H, span_warning("一阵神圣的寂静降临在你身上……"))

		priority_announce("[real_name] 已将羞辱之印加诸 [inputty] 之身。他们的祈祷再也无人聆听。", title = "叛教", sound = 'sound/misc/excomm.ogg')
		message_admins("APOSTASY: [real_name] ([ckey]) has used apostasy at [H.real_name] ([H.ckey])")
		log_game("APOSTASY: [real_name] ([ckey]) has used apostasy at [H.real_name] ([H.ckey])")
		return TRUE

	if (!found)
		return FALSE

	return

/mob/living/carbon/human/proc/churchexcommunicate(mob/living/carbon/human/H in GLOB.player_list)
	set name = "逐出教门"
	set category = "Priest"

	if (stat)
		return

	var/found = FALSE
	var/inputty = input("将某人逐出十神信众之列……（再次施加可解除）", "罪人之名") as text|null

	if (!inputty)
		return

	if (!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("我得在十神圣堂中执行此事。"))
		return FALSE

	if(!src.key)
		return

	if(!src.mind || !src.mind.do_i_know(name=inputty))
		to_chat(src, span_warning("我不认识这个名字的人。"))
		return

	if (inputty in GLOB.excommunicated_players)
		GLOB.excommunicated_players -= inputty
		priority_announce("[real_name] 已使 [inputty] 与教会重归于好。他们再一次成为羊群中的一员！", title = "重归教门", sound = 'sound/misc/bell.ogg')
		message_admins("EXCOMMUNICATION: [real_name] ([ckey]) has reconciled [H.real_name] ([H.ckey])")
		log_game("EXCOMMUNICATION: [real_name] ([ckey]) has reconciled [H.real_name] ([H.ckey])")

		if (H.real_name == inputty)
			REMOVE_TRAIT(H, TRAIT_EXCOMMUNICATED, TRAIT_GENERIC)

			if (H.patron)
				if (istype(H.patron, /datum/patron/divine))
					H.remove_stress(/datum/stressevent/excommunicated)
					H.remove_status_effect(/datum/status_effect/debuff/excomm)
					to_chat(H, span_warning("你不再是腐朽的空壳，你又一次行走在他们的光辉之中。"))
				else
					return
		return

	if (H.real_name == inputty)
		if (!COOLDOWN_FINISHED(src, priest_excommunicate))
			to_chat(src, span_warning("你必须等待片刻，才能再逐出另一人。"))
			return // Anybody can still be excommunicated, so no extra checks here since it's purely RP and not mechanical.
		found = TRUE
		ADD_TRAIT(H, TRAIT_EXCOMMUNICATED, TRAIT_GENERIC)
		COOLDOWN_START(src, priest_excommunicate, PRIEST_EXCOMMUNICATION_COOLDOWN)

		if (H.patron)
			if (istype(H.patron, /datum/patron/divine))
				H.add_stress(/datum/stressevent/excommunicated)
				H.apply_status_effect(/datum/status_effect/debuff/excomm)
				to_chat(H, span_warning("你的神圣之光已被斩断。诸神都将背对你而去。"))
			else
				return

		if (!found)
			return FALSE

	GLOB.excommunicated_players += inputty
	priority_announce("[real_name] 已将 [inputty] 逐出教门！蒙羞吧！", title = "逐出教门", sound = 'sound/misc/excomm.ogg')
	message_admins("EXCOMMUNICATION: [real_name] ([ckey]) has excommunicated [H.real_name] ([H.ckey])")
	log_game("EXCOMMUNICATION: [real_name] ([ckey]) has excommunicated [H.real_name] ([H.ckey])")

	return

/* PRIEST CURSE - powerful debuffs to punish ppl outside church otherwise use apostasy
code\modules\admin\verbs\divinewrath.dm has a variant with all the gods so keep that updated if this gets any changes.*/
/mob/living/carbon/human/proc/churchpriestcurse(mob/living/carbon/human/H in GLOB.player_list)
	set name = "神罚诅咒"
	set category = "Priest"

	if (stat)
		return

	var/target_name = input("谁将承受诅咒？", "目标姓名") as text|null

	if (!target_name)
		return

	if (!istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("我得在十神圣堂中执行此事。"))
		return FALSE

	if(!src.key)
		return

	if(!src.mind || !src.mind.do_i_know(name=target_name))
		to_chat(src, span_warning("我不认识这个名字的人。"))
		return

	var/list/curse_choices = list(
		"Astrata 之咒" = /datum/curse/astrata,
		"Noc 之咒" = /datum/curse/noc,
		"Dendor 之咒" = /datum/curse/dendor,
		"Abyssor 之咒" = /datum/curse/abyssor,
		"Ravox 之咒" = /datum/curse/ravox,
		"Necra 之咒" = /datum/curse/necra,
		"Xylix 之咒" = /datum/curse/xylix,
		"Pestra 之咒" = /datum/curse/pestra,
		"Malum 之咒" = /datum/curse/malum,
		"Eora 之咒" = /datum/curse/eora,
	)

	var/curse_pick = input("选择要施加或解除的诅咒。", "选择诅咒") as null|anything in curse_choices
	if (!curse_pick)
		return

	var/curse_type = curse_choices[curse_pick]

	if (H.real_name == target_name)
		var/datum/curse/temp = new curse_type()

		if (H.is_cursed(temp))
			H.remove_curse(temp)
			priority_announce("[real_name] 已从 [H.real_name] 身上解除 [curse_pick]！他们再一次成为羊群中的一员！", title = "赎免", sound = 'sound/misc/bell.ogg')
			message_admins("DIVINE CURSE: [real_name] ([ckey]) has removed [curse_pick] from [H.real_name]) ") //[ADMIN_LOOKUPFLW(user)] Maybe add this here if desirable but dunno.
			log_game("DIVINE CURSE: [real_name] ([ckey]) has removed [curse_pick] from [H.real_name])")
		else
			if (length(H.curses) >= 1)
				to_chat(src, span_syndradio("[H.real_name] 已经遭受了另一种诅咒。"))
				message_admins("DIVINE CURSE: [real_name] ([ckey]) has attempted to strike [H.real_name] ([H.ckey] with [curse_pick])")
				log_game("DIVINE CURSE: [real_name] ([ckey]) has attempted to strike [H.real_name] ([H.ckey] with [curse_pick])")
				return

			if (!COOLDOWN_FINISHED(src, priest_curse))
				to_chat(src, span_warning("你必须等待片刻，才能再次降下诅咒。"))
				return

			//Check if we can curse this person.
			if(!churchecancurse(H))
				return

			COOLDOWN_START(src, priest_curse, PRIEST_CURSE_COOLDOWN)
			H.add_curse(curse_type)

			priority_announce("[real_name] 已以 [curse_pick] 击中 [H.real_name]！蒙羞吧！", title = "神判", sound = 'sound/misc/excomm.ogg')
			message_admins("DIVINE CURSE: [real_name] ([ckey]) has stricken [H.real_name] ([H.ckey] with [curse_pick])")
			log_game("DIVINE CURSE: [real_name] ([ckey]) has stricken [H.real_name] ([H.ckey] with [curse_pick])")

		return

/mob/living/carbon/human/proc/change_patron()
	set name = "改易信奉"
	set category = "Priest"

	if(!mind)
		return

	if(!HAS_TRAIT(src, TRAIT_CLERGYRADICAL))
		to_chat(src, span_warning("唯有激进派主教才可抛弃旧教义。"))
		return

	var/key = REF(src)
	var/next_swap = GLOB.priest_swap_timers[key]
	if(!isnum(next_swap))
		next_swap = 0

	if(world.time < next_swap)
		to_chat(src, span_warning("你必须等待片刻，才能再次改易信奉。"))
		return

	var/list/god_choice = list()
	var/list/god_type = list()

	for(var/path as anything in GLOB.patrons_by_faith[/datum/faith/divine])
		var/datum/patron/patron_choice = GLOB.patronlist[path]
		if(!patron_choice || !patron_choice.name)
			continue

		god_choice += list("[patron_choice.name]" = icon(icon = 'icons/mob/overhead_effects.dmi', icon_state = "sign_[patron_choice.name]"))
		god_type[patron_choice.name] = patron_choice.type

	var/string_choice = show_radial_menu(src, src, god_choice, require_near = FALSE)
	if(!string_choice)
		return
	var/new_patron_type = god_type[string_choice]
	if(!new_patron_type)
		return
	if(patron && istype(patron, new_patron_type))
		to_chat(src, span_info("你已在追随 [string_choice]。"))
		return
	patron = new new_patron_type()
	if(devotion && ("patron" in devotion.vars))
		devotion.patron = patron
	GLOB.priest_swap_timers[key] = world.time + PRIEST_SWAP_COOLDOWN
	if(string_choice == "Astrata")
		to_chat(src, "<font color='yellow'>天穹必将回报于汝。汝再度承载吾之伟力。</font>")
	else
		to_chat(src, "<font color='yellow'>汝今已宣称信奉 [string_choice]。</font>")
	to_chat(src, "<font color='yellow'>汝之神迹维持不变。</font>")

/obj/effect/proc_holder/spell/invoked/convert_heretic_priest
	name = "赦免异端"
	desc = "将一名异端重新带回教会的羊群。需要对方自愿接受，且施法耗时很长。"
	invocations = list("让这只迷失的羔羊重归羊群。")
	invocation_type = "whisper"
	sound = 'sound/magic/bless.ogg'
	devotion_cost = 100
	recharge_time = 20 MINUTES
	chargetime = 10 SECONDS
	associated_skill = /datum/skill/magic/holy
	overlay_state = "convert_heretic"

/obj/effect/proc_holder/spell/invoked/convert_heretic_priest/cast(list/targets, mob/living/carbon/human/user)
	var/mob/living/carbon/human/target = targets[1]

	if(!ishuman(target))
		revert_cast()
		return FALSE

	if(!HAS_TRAIT(target, TRAIT_HERESIARCH))
		to_chat(user, span_warning("[target] 并未被敌方标记为异端！"))
		revert_cast()
		return FALSE

	if(alert(target, "[user.real_name] 正试图让你重新归入教会。你接受吗？", "归正请求", "接受", "拒绝") != "接受")
		to_chat(user, span_warning("[target] 拒绝了你的归正提议。"))
		revert_cast()
		return FALSE

	// Remove from excommunication lists
	if(target.real_name in GLOB.excommunicated_players)
		GLOB.excommunicated_players -= target.real_name

	// Remove heretic traits
	REMOVE_TRAIT(target, TRAIT_HERESIARCH, TRAIT_GENERIC)
	REMOVE_TRAIT(target, TRAIT_EXCOMMUNICATED, TRAIT_GENERIC)

	// Remove divine punishments
	target.remove_status_effect(/datum/status_effect/debuff/excomm)
	target.remove_stress(/datum/stressevent/excommunicated)

	// Save devotion state
	var/saved_level = CLERIC_T0
	var/saved_max_progression = CLERIC_T1
	var/saved_devotion_gain = CLERIC_REGEN_MINOR

	if(target.devotion)
		saved_level = target.devotion.level
		saved_devotion_gain = target.devotion.passive_devotion_gain
		saved_max_progression = target.devotion.max_progression

		// Remove all granted spells
		for(var/obj/effect/proc_holder/spell/S in target.devotion.granted_spells)
			target.mind.RemoveSpell(S)

		target.devotion.Destroy()

	// Convert to priest's patron
	target.patron = new user.patron.type()

	// Grant new devotion
	var/datum/devotion/new_devotion = new /datum/devotion(target, target.patron)
	target.devotion = new_devotion
	new_devotion.grant_miracles(target, saved_level, saved_devotion_gain, saved_max_progression)

	// Apply revival debuff as a small cost to conversion in addition to the cooldown
	user.apply_status_effect(/datum/status_effect/debuff/devitalised)
	target.apply_status_effect(/datum/status_effect/debuff/devitalised)

	var/announcement_text = "[user.real_name] 已将 [target.real_name] 带回教会的羊群之中！[target.real_name] 现在信奉 [user.patron.name]！"
	priority_announce(announcement_text, title = "救赎", sound = 'sound/misc/bell.ogg')
	message_admins("HERETIC CONVERSION: [user.real_name] ([user.ckey]) has converted [target.real_name] ([target.ckey]) to [user.patron.name]")
	log_game("HERETIC CONVERSION: [user.real_name] ([user.ckey]) converted [target.real_name] ([target.ckey]) to [user.patron.name]")
	to_chat(user, span_danger("你已使 [target.name] 改而信奉 [user.patron.name]！"))
	to_chat(target, span_danger("当你拥抱 [user.patron.name] 时，你感到异端之重正从灵魂中悄然剥落！"))

	return TRUE
