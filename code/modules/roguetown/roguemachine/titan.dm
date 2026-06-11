GLOBAL_LIST_EMPTY(outlawed_players)
GLOBAL_LIST_EMPTY(lord_decrees)
GLOBAL_LIST_EMPTY(court_agents)
GLOBAL_LIST_INIT(laws_of_the_land, initialize_laws_of_the_land())
GLOBAL_VAR_INIT(last_crown_announcement_time, -1000)

/proc/initialize_laws_of_the_land()
	var/list/laws = strings("laws_of_the_land.json", "lawsets")
	var/list/lawsets_weighted = list()
	for(var/lawset_name as anything in laws)
		var/list/lawset = laws[lawset_name]
		lawsets_weighted[lawset_name] = lawset["weight"]
	var/chosen_lawset = pickweight(lawsets_weighted)
	return laws[chosen_lawset]["laws"]

/obj/structure/roguemachine/titan
	name = "咽喉"
	desc = "戴上王冠者才能掌控这奇异之物。若别无他法，就高呼“咽喉的秘密！”"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = ""
	density = FALSE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.5
	max_integrity = 0
	anchored = TRUE
	var/mode = 0

/obj/structure/roguemachine/titan/obj_break(damage_flag)
	..()
	cut_overlays()
//	icon_state = "[icon_state]-br"
	set_light(0)
	return

/obj/structure/roguemachine/titan/Destroy()
	lose_hearing_sensitivity()
	set_light(0)
	return ..()

/obj/structure/roguemachine/titan/Initialize(mapload)
	. = ..()
	icon_state = null
	become_hearing_sensitive()
//	var/mutable_appearance/eye_lights = mutable_appearance(icon, "titan-eyes")
//	eye_lights.plane = ABOVE_LIGHTING_PLANE //glowy eyes
//	eye_lights.layer = ABOVE_LIGHTING_LAYER
//	add_overlay(eye_lights)
	set_light(5)

/obj/structure/roguemachine/titan/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, message)
//	. = ..()
	if(speaker == src)
		return
	if(speaker.loc != loc)
		return
	if(obj_broken)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	var/nocrown
	if(!istype(H.head, /obj/item/clothing/head/roguetown/crown/serpcrown))
		nocrown = TRUE
	var/notlord = TRUE
	if(SSticker.rulermob == H || SSticker.regentmob == H)
		notlord = FALSE

	if(mode)
		if(findtext(message, "nevermind"))
			mode = 0
			return
	if(findtext(message, "summon crown")) //This must never fail, thus place it before all other modestuffs.
		if(!SSroguemachine.crown)
			new /obj/item/clothing/head/roguetown/crown/serpcrown(src.loc)
			say("王冠已被召来！")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		if(SSroguemachine.crown)
			var/obj/item/clothing/head/roguetown/crown/serpcrown/I = SSroguemachine.crown
			if(!I)
				I = new /obj/item/clothing/head/roguetown/crown/serpcrown(src.loc)
			if(I && !ismob(I.loc))//You MUST MUST MUST keep the Crown on a person to prevent it from being summoned (magical interference)
				var/area/crown_area = get_area(I)
				if(crown_area && istype(crown_area, /area/rogue/indoors/town/vault) && notlord) //Anti throat snipe from vault
					say("王冠在宝库之中。")
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					return
				I.anti_stall()
				I = new /obj/item/clothing/head/roguetown/crown/serpcrown(src.loc)
				say("王冠已被召来！")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				return
			if(ishuman(I.loc))
				var/mob/living/carbon/human/HC = I.loc
				if(HC.stat != DEAD)
					if(I in HC.held_items)
						say("[HC.real_name]持有王冠！")
						playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
						return
					if(HC.head == I)
						say("[HC.real_name]戴着王冠！")
						playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
						return
				else
					HC.dropItemToGround(I, TRUE) //If you're dead, forcedrop it, then move it.
			I.forceMove(src.loc)
			say("王冠已被召来！")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	if(findtext(message, "summon key"))
		if(nocrown)
			say("你需要王冠。")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		if(!SSroguemachine.key)
			new /obj/item/roguekey/lord(src.loc)
			say("钥匙已被召来！")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		if(SSroguemachine.key)
			var/obj/item/roguekey/lord/I = SSroguemachine.key
			if(!I)
				I = new /obj/item/roguekey/lord(src.loc)
			if(I && !ismob(I.loc))
				I.anti_stall()
				I = new /obj/item/roguekey/lord(src.loc)
				say("钥匙已被召来！")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				return
			if(ishuman(I.loc))
				var/mob/living/carbon/human/HC = I.loc
				if(HC.stat != DEAD)
					say("[HC.real_name]持有钥匙！")
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					return
				else
					HC.dropItemToGround(I, TRUE) //If you're dead, forcedrop it, then move it.
			I.forceMove(src.loc)
			say("钥匙已被召来！")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	switch(mode)
		if(0)
			if(findtext(message, "secrets of the throat"))
				say("我的命令有：发布法令、发布公告、设定税率、宣布法外、召来王冠、召来钥匙、制定律法、移除律法、清除律法、清除法令、成为摄政、改变颜色、算了")
				playsound(src, 'sound/misc/machinelong.ogg', 100, FALSE, -1)
			if(findtext(message, "make announcement"))
				if(nocrown)
					say("你需要王冠。")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if (world.time < GLOB.last_crown_announcement_time + 2 MINUTES)
					say(("还没到再次发布公告的时候，我的陛下。"))
					return
				if(!SScommunications.can_announce(H))
					say("我必须积蓄力量！")
					return
				say("开口吧，他们会听见。")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				mode = 1
				return
			if(findtext(message, "make decree"))
				if(!SScommunications.can_announce(H))
					say("我必须积蓄力量！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("你不是我的主人！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("开口吧，他们会服从。")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				mode = 2
				return
			if(findtext(message, "purge decrees"))
				if(!SScommunications.can_announce(H))
					say("我必须积蓄力量！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("你不是我的主人！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("所有法令都将被清除！")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				purge_decrees()
				return
			if(findtext(message, "make law"))
				if(!SScommunications.can_announce(H))
					say("我必须积蓄力量！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("你不是我的主人！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("开口吧，他们会服从。")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				mode = 4
				return
			if(findtext(message, "remove law"))
				if(!SScommunications.can_announce(H))
					say("我必须积蓄力量！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("你不是我的主人！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				var/message_clean = replacetext(message, "remove law", "")
				var/law_index = text2num(message_clean) || 0
				if(!law_index || !GLOB.laws_of_the_land[law_index])
					say("那条律法并不存在！")
					return
				say("那条律法将被抹去！")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				remove_law(law_index)
				return
			if(findtext(message, "purge laws"))
				if(!SScommunications.can_announce(H))
					say("我必须积蓄力量！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(notlord || nocrown)
					say("你不是我的主人！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("所有律法都将被清除！")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				purge_laws()
				return
			if(findtext(message, "declare outlaw"))
				if(notlord || nocrown)
					say("你不是我的主人！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("该宣布谁为法外之徒？")
				playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
				mode = 3
				return
			if(findtext(message, "set taxes"))
				if(notlord || nocrown)
					say("你不是我的主人！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("新的税率将会是……")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				give_tax_popup(H)
				return
			if(findtext(message, "become regent"))
				if(nocrown)
					say("你需要王冠。")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(SSticker.rulermob && SSticker.rulermob == H) //failsafe for edge cases
					say("无人能与你共享王座，主人。")
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					SSticker.regentmob = null
					return
				if(SSticker.rulermob != null)
					say("真正的领主已经在这片土地上了。")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(!(HAS_TRAIT(H, TRAIT_NOBLE)))
					say("你没有成为摄政的贵族之血。")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(!(H.job in GLOB.noble_positions))
					say("你与这片土地过于疏离，无法成为摄政。")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(SSticker.regentday == GLOB.dayspassed)
					say("今天已经册立过一位摄政了！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(SSticker.regentmob == H)
					say("你已经是摄政了！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				become_regent(H)
				return
			if(findtext(message, "change colors"))
				if(notlord || nocrown)
					say("你不是我的主人！")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("为你的国度选择颜色吧，我的陛下。")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				H.lord_color_choice()
				return

		if(1)
			make_announcement(H, raw_message)
			mode = 0
		if(2)
			make_decree(H, raw_message)
			mode = 0
		if(3)
			declare_outlaw(H, message)
			mode = 0
		if(4)
			if(!SScommunications.can_announce(speaker))
				return
			make_law(raw_message)
			mode = 0

/obj/structure/roguemachine/titan/proc/give_tax_popup(mob/living/carbon/human/user)
	if(!Adjacent(user))
		return
	var/datum/taxsetter/taxsetter = new("慷慨领主的谕令")
	taxsetter.ui_interact(user)

/obj/structure/roguemachine/titan/proc/make_announcement(mob/living/user, raw_message)
	if(!SScommunications.can_announce(user))
		return
	try_make_rebel_decree(user)

	SScommunications.make_announcement(user, FALSE, raw_message)
	GLOB.last_crown_announcement_time = world.time

/obj/structure/roguemachine/titan/proc/try_make_rebel_decree(mob/living/user)
	if(!SScommunications.can_announce(user))
		return
	var/datum/antagonist/prebel/P = user.mind?.has_antag_datum(/datum/antagonist/prebel)
	if(P)
		if(P.rev_team)
			if(P.rev_team.members.len < 3)
				to_chat(user, "<span class='warning'>我这边还需要更多人，才能宣告胜利。</span>")
			else
				for(var/datum/objective/prebel/obj in user.mind.get_all_objectives())
					obj.completed = TRUE
				if(!SSmapping.retainer.head_rebel_decree)
					user.mind.adjust_triumphs(1)
				SSmapping.retainer.head_rebel_decree = TRUE

/obj/structure/roguemachine/titan/proc/make_decree(mob/living/user, raw_message)
	var/datum/antagonist/prebel/rebel_datum = user.mind?.has_antag_datum(/datum/antagonist/prebel)
	if(rebel_datum)
		if(rebel_datum.rev_team?.members.len < 3)
			to_chat(user, "<span class='warning'>我这边还需要更多人，才能宣告胜利。</span>")
		else
			for(var/datum/objective/prebel/obj in user.mind.get_all_objectives())
				obj.completed = TRUE
			if(!SSmapping.retainer.head_rebel_decree)
				user.mind.adjust_triumphs(1)
			SSmapping.retainer.head_rebel_decree = TRUE
	record_round_statistic(STATS_LAWS_AND_DECREES_MADE)
	SScommunications.make_announcement(user, TRUE, raw_message)

/obj/structure/roguemachine/titan/proc/declare_outlaw(mob/living/user, raw_message)
	if(!SScommunications.can_announce(user))
		return
	if(user.job)
		if(!istype(SSjob.GetJob(user.job), /datum/job/roguetown/lord))
			return
	else
		return
	return make_outlaw(raw_message)

/proc/make_outlaw(raw_message)
	if(raw_message in GLOB.outlawed_players)
		GLOB.outlawed_players -= raw_message
		priority_announce("[raw_message] is no longer an outlaw in the realm.", "The [SSticker.rulertype] Decrees", 'sound/misc/royal_decree.ogg', "Captain")
		return FALSE
	var/found = FALSE
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.real_name == raw_message)
			found = TRUE
	if(!found)
		return FALSE
	GLOB.outlawed_players += raw_message
	priority_announce("[raw_message] has been declared an outlaw and must be captured or slain.", "The [SSticker.rulertype] Decrees", 'sound/misc/royal_decree2.ogg', "Captain")
	return TRUE

/proc/make_law(raw_message)
	GLOB.laws_of_the_land += raw_message
	priority_announce("[length(GLOB.laws_of_the_land)]. [raw_message]", "A LAW IS DECLARED", pick('sound/misc/new_law.ogg', 'sound/misc/new_law2.ogg'), "Captain")
	record_round_statistic(STATS_LAWS_AND_DECREES_MADE)

/proc/remove_law(law_index)
	if(!GLOB.laws_of_the_land[law_index])
		return
	var/law_text = GLOB.laws_of_the_land[law_index]
	GLOB.laws_of_the_land -= law_text
	priority_announce("[law_index]. [law_text]", "A LAW IS ABOLISHED", pick('sound/misc/new_law.ogg', 'sound/misc/new_law2.ogg'), "Captain")
	record_round_statistic(STATS_LAWS_AND_DECREES_MADE, -1)

/proc/purge_laws()
	GLOB.laws_of_the_land = list()
	priority_announce("All laws of the land have been purged!", "LAWS PURGED", 'sound/misc/lawspurged.ogg', "Captain")

/proc/purge_decrees()
	GLOB.lord_decrees = list()
	priority_announce("All of the land's prior decrees have been purged!", "DECREES PURGED", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain")

/proc/become_regent(mob/living/carbon/human/H)
	priority_announce("[H.name], the [H.get_role_title()], sits as the regent of the realm.", "A New Regent Resides", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain")
	SSticker.regentmob = H
	SSticker.regentday = GLOB.dayspassed
