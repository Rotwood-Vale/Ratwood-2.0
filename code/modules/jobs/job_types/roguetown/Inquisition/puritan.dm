#define PURITAN_BROADCAST_COOLDOWN (5 MINUTES)

/datum/job/roguetown/puritan
	title = "Inquisitor"
	flag = PURITAN
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT		//Would you trust a machine to handle a role that requires non-logical intuition and commanding? Maybe. Could undo this if the community likes it. Purpose-built supermachines sound cool, too.
	allowed_patrons = list(/datum/patron/old_god) //Requires your character's patron to be Psydon. This role is explicitly designed to be played by Psydonites, only, and almost everything they have - down to the equipment and statblock - is rooted in Psydonism. Do NOT make this accessable to other faiths, unless you go through the efforts of redesigning it from the ground up.
	tutorial = "You are a puritan of the Psydonic doctrine. You are to be feared, ruthless, and answerable to Psydon alone. Otava has dispatched you to The Vale as an olive branch, silver-tipped and poisoned at the stem. You are an outsider here, and you will be treated as one. Use it. Forge alliances where they serve you, discard them when they do not, and never forget that your loyalty is to the Inquisition's dominion, not to the factions of this foreign land. Beneath your sanctimonious banner, corruption is a tool, cruelty towards 'heretics' is doctrine, and false accusations are merely expedient truths. You are not here to be liked. You are here to be feared and to ensure that fear serves Psydon's will, or at the very least, your own."
	whitelist_req = TRUE
	cmode_music = 'sound/music/inquisitorcombat.ogg'
	selection_color = JCOLOR_INQUISITION

	outfit = /datum/outfit/job/roguetown/puritan
	display_order = JDO_PURITAN
	advclass_cat_rolls = list(CTAG_PURITAN = 20)
	give_bank_account = 30
	min_pq = 30
	max_pq = null
	round_contrib_points = 2
	social_rank = SOCIAL_RANK_NOBLE
	job_subclasses = list(
		/datum/advclass/puritan/inspector,
		/datum/advclass/puritan/ordinator,
		/datum/advclass/puritan/arbiter
	)

/datum/outfit/job/roguetown/puritan
	name = "Inquisitor"
	jobtype = /datum/job/roguetown/puritan
	job_bitflag = BITFLAG_HOLY_WARRIOR	//Counts as church.
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/puritan/post_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs += /mob/living/carbon/human/proc/inquisitor_broadcast

/obj/item/clothing/gloves/roguetown/chain/blk
		color = CLOTHING_GREY

/obj/item/clothing/under/roguetown/chainlegs/blk
		color = CLOTHING_GREY

/obj/item/clothing/suit/roguetown/armor/plate/blk
		color = CLOTHING_GREY

/obj/item/clothing/shoes/roguetown/boots/armor/blk
		color = CLOTHING_GREY

/mob/living/carbon/human/proc/faith_test()
	set name = "Test Faith"
	set category = "Interrogation"
	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/obj/item/S = get_inactive_held_item()
	var/found = null
	if(!istype(I) || !ishuman(I.grabbed))
		to_chat(src, span_warning("I don't have a victim in my hands!"))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("I already torture myself."))
		return
	if (!H.restrained())
		to_chat(src, span_warning ("My victim needs to be restrained in order to do this!"))
		return
	if(!istype(S, /obj/item/clothing/neck/roguetown/psicross/silver))
		to_chat(src, span_warning("I need to be holding a silver psycross to extract this divination!"))
		return
	for(var/obj/structure/fluff/psycross/N in oview(5, src))
		found = N
	if(!found)
		to_chat(src, span_warning("I need a large psycross structure nearby to extract this divination!"))
		return
	if(!H.stat)
		var/static/list/faith_lines = list(
			"TO WHOM DO YOU PRAY!?",
			"WHO IS YOUR GOD!?",
			"ARE YOU FAITHFUL!?",
			"WHO IS YOUR SHEPHERD!?",
		)
		src.visible_message(span_warning("[src] shoves the silver psycross in [H]'s face!"))
		say(pick(faith_lines), spans = list("torture"))
		H.emote("agony", forced = TRUE)

		if(!(do_mob(src, H, 10 SECONDS)))
			return
		src.visible_message(span_warning("[src]'s silver psycross abruptly catches flame, burning away in an instant!"))
		H.confess_sins("patron")
		qdel(S)
		return
	to_chat(src, span_warning("This one is not in a ready state to be questioned..."))

/mob/living/carbon/human/proc/confess_sins(confession_type = "antag")
	var/static/list/innocent_lines = list(
		"I AM NO SINNER!",
		"I'M INNOCENT!",
		"I HAVE NOTHING TO CONFESS!",
		"I AM FAITHFUL!",
	)
	var/list/confessions = list()
	switch(confession_type)
		if("patron")
			if(length(patron?.confess_lines))
				confessions += patron.confess_lines
		if("antag")
			for(var/datum/antagonist/antag in mind?.antag_datums)
				if(!length(antag.confess_lines))
					continue
				confessions += antag.confess_lines
	if(length(confessions))
		say(pick(confessions), spans = list("torture"))
		return
	say(pick(innocent_lines), spans = list("torture"))

/mob/living/carbon/human/proc/torture_victim()
	set name = "Reveal Allegiance"
	set category = "Interrogation"
	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/obj/item/S = get_inactive_held_item()
	var/found = null
	if(!istype(I) || !ishuman(I.grabbed))
		to_chat(src, span_warning("I don't have a victim in my hands!"))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("I already torture myself."))
		return
	if (!H.restrained())
		to_chat(src, span_warning ("My victim needs to be restrained in order to do this!"))
		return
	if(!istype(S, /obj/item/clothing/neck/roguetown/psicross/silver))
		to_chat(src, span_warning("I need to be holding a silver psycross to extract this divination!"))
		return
	for(var/obj/structure/fluff/psycross/N in oview(5, src))
		found = N
	if(!found)
		to_chat(src, span_warning("I need a large psycross structure nearby to extract this divination!"))
		return
	if(!H.stat)
		var/static/list/torture_lines = list(
			"CONFESS!",
			"TELL ME YOUR SECRETS!",
			"SPEAK!",
			"YOU WILL SPEAK!",
			"TELL ME!",
		)
		say(pick(torture_lines), spans = list("torture"))
		H.emote("agony", forced = TRUE)

		if(!(do_mob(src, H, 10 SECONDS)))
			return
		src.visible_message(span_warning("[src]'s silver psycross abruptly catches flame, burning away in an instant!"))
		H.confess_sins("antag")
		qdel(S)
		return
	to_chat(src, span_warning("This one is not in a ready state to be questioned..."))

/mob/living/carbon/human/proc/inquisitor_broadcast()
	set name = "Issue Announcement"
	set category = "Inquisitor"
	if(stat)
		return
	var/announcementinput = input("Speak to your flock! Issue an announcement unto the Inquisition.", "Issue an announcement!") as text|null
	if(announcementinput)
		if(!src.can_speak_vocal())
			to_chat(src, span_warning("I can't speak!"))
			return FALSE
		var/area/A = get_area(src)
		if(!istype(A, /area/rogue/indoors/inq))
			to_chat(src, span_warning("I can only speak from within the Inquisition."))
			return FALSE
		if(!COOLDOWN_FINISHED(src, inquisitor_broadcast))
			to_chat(src, span_warning("You must wait before issuing another announcement."))
			return FALSE
		visible_message(span_warning("[src] takes a deep breath, preparing to issue an announcement..."))
		if(do_after(src, 15 SECONDS, target = src))
			say(announcementinput)
			for(var/mob/living/carbon/human/M in GLOB.human_list)
				var/datum/job/J = SSjob.GetJob(M.mind?.assigned_role)
				if(J?.department_flag == INQUISITION)
					to_chat(M, span_boldnotice("<big><b>Inquisitor [src.real_name] announces:</b> [announcementinput]</big>"))
			COOLDOWN_START(src, inquisitor_broadcast, PURITAN_BROADCAST_COOLDOWN)
		else
			to_chat(src, span_warning("Your announcement was interrupted!"))
			return FALSE
