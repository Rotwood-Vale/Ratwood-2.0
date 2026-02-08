//The antipope. Except not really. Charlatan that pushes forward the idea that the Inhumen are superior, or something.
//Locked to Inhumen specifically so this gimmick works. Just a middling miraclist with HANDS.
//Gets the ability to torture, recycled from normal heretic, combined with EVIL sermons.
//It doesn't get any actual, proper combat skills, now. Lets hope that sees to it not being as funny.
#define EVIL_PRIEST_SERMON_COOLDOWN (30 MINUTES)
/datum/advclass/wretch/antipope
	name = "Doomsayer"
	tutorial = "ONLY THE INHUMEN CAN SAVE THIS REALM! THE TENNITES ARE WRONG! YOU ARE THE MOUTHPIECE!"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/antipope
	cmode_music = 'sound/music/combat_holy.ogg'
	category_tags = list(CTAG_WRETCH)
//Seer to see other Inhumen.
	traits_applied = list(TRAIT_HERETIC_SEER, TRAIT_RITUALIST, TRAIT_GRAVEROBBER, TRAIT_RESONANCE, TRAIT_OVERTHERETIC)
//Inverse of Priest. Kind of? STR instead of INT. CON/SPD instead of WIL.
	subclass_stats = list(
		STATKEY_STR = 4,//No armour skill. No DE/CR. Gains for Graggar.
		STATKEY_CON = 2,
		STATKEY_SPD = 2,
	)
	maximum_possible_slots = 1//There can only be one antipope.
	subclass_skills = list(//Priest but not. Unlike the stats, we don't want to invert that. This'll be funny.
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,//Show them who's the boss, buddy.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "Inhumen exclusive. No wretch bounty, for the purpose of infiltration and doomsaying. Given EVIL sermon abilities, torture and other quirks."

//A mix of monk and mage for kit. Kind of.
/datum/outfit/job/roguetown/wretch/antipope/pre_equip(mob/living/carbon/human/H)
	if(!istype(H.patron, /datum/patron/inhumen))
		H.set_patron(/datum/patron/inhumen/zizo)//If you're not of the Inhumen before? You are now!
	head = /obj/item/clothing/head/roguetown/roguehood
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/knuckles
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/woodstaff/quarterstaff
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/ritechalk = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
	)

	if(istype (H.patron, /datum/patron/inhumen/zizo))
		H.mind?.current.faction += "[H.name]_faction"

	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_heal)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/silence)//Shut that guy up!
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/nondetection)//For the purposes of meeting folks.
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/message)//See above.
	H.verbs |= /mob/living/carbon/human/proc/completesermon_evil
	H.verbs |= /mob/living/carbon/human/proc/revelations

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()

/mob/living/carbon/human/proc/completesermon_evil()
	set name = "EVIL Sermon"
	set category = "Antipope"

	if (!mind)
		return

	//ANYWHERE, really, EXCEPT the chapel.
	if (istype(get_area(src), /area/rogue/indoors/town/church/chapel))
		to_chat(src, span_warning("I can't do this here! They'll know!"))
		return FALSE

	if (!COOLDOWN_FINISHED(src, evil_priest_sermon))
		to_chat(src, span_warning("You cannot inspire others so early."))
		return

	src.visible_message(span_notice("[src] begins preaching a sermon..."))

	if (!do_after(src, 120, target = src)) // 120 seconds
		src.visible_message(span_warning("[src] stops preaching."))
		return

	src.visible_message(span_notice("[src] finishes the sermon, inspiring those nearby!"))
	playsound(src.loc, 'sound/magic/ahh2.ogg', 80, TRUE)
	COOLDOWN_START(src, evil_priest_sermon, EVIL_PRIEST_SERMON_COOLDOWN)

	for (var/mob/living/carbon/human/H in view(7, src))
		if (!H.patron)
			continue
		//We invert the sermon positives and negatives. Wild how that works.
		if (istype(H.patron, /datum/patron/divine))
			H.apply_status_effect(/datum/status_effect/debuff/hereticsermon)
			H.add_stress(/datum/stressevent/heretic_on_sermon)
			to_chat(H, span_warning("Your patron seethes with disapproval."))
		else if (istype(H.patron, /datum/patron/inhumen))
			H.apply_status_effect(/datum/status_effect/buff/sermon)
			H.add_stress(/datum/stressevent/sermon)
			to_chat(H, span_notice("You feel a divine affirmation from your patron."))
		else
			// Other patrons - fluff only
			to_chat(H, span_notice("Nothing seems to happen to you."))

	return TRUE

/mob/living/carbon/human/proc/revelations()
	set name = "Revelations"
	set category = "Antipope"
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
	if(!istype(S, /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy))
		to_chat(src, span_warning("I need to be holding a zcross to extract this divination!"))
		return
	for(var/obj/structure/fluff/psycross/zizocross/N in oview(5, src))
		found = N
	if(!found)
		to_chat(src, span_warning("I need a large profane shrine structure nearby to extract this divination!"))
		return
	if(!H.stat)
		var/static/list/faith_lines = list(
			"THE TRUTH SHALL SET YOU FREE!",
			"WHO IS YOUR GOD!?",
			"ARE YOU FAITHFUL!?",
			"WHO IS YOUR SHEPHERD!?",
		)
		src.visible_message(span_warning("[src] shoves the decrepit zcross into [H]'s lux!"))
		say(pick(faith_lines), spans = list("torture"))
		H.emote("agony", forced = TRUE)

		if(!(do_mob(src, H, 10 SECONDS)))
			return
		H.confess_sins("patron")
		return
	to_chat(src, span_warning("This one is not in a ready state to be questioned..."))
