/datum/job/roguetown/knight
	title = "Knight"
	flag = KNIGHT
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	allowed_races = RACES_TOLERATED_UP
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	tutorial = "Having proven yourself both loyal and capable, you have been knighted to serve the realm as the royal family's sentry. \
	You listen to your Liege, the Marshal, and the Knight Captain, defending your Lord and realm - the last beacon of chivalry in these dark times. \
	You're wholly dedicated to the standing Regent and their safety. Do not fail."
	display_order = JDO_KNIGHT
	whitelist_req = TRUE
	outfit = /datum/outfit/job/roguetown/knight
	advclass_cat_rolls = list(CTAG_ROYALGUARD = 20)
	job_traits = list(TRAIT_NOBLE, TRAIT_STEELHEARTED, TRAIT_GUARDSMAN)
	give_bank_account = 22
	noble_income = 10
	min_pq = 8
	max_pq = null
	round_contrib_points = 2

	cmode_music = 'sound/music/combat_knight.ogg'
	social_rank = SOCIAL_RANK_MINOR_NOBLE
	job_subclasses = list(
		/datum/advclass/knight/heavy,
		/datum/advclass/knight/footknight,
		/datum/advclass/knight/mountedknight,
		/datum/advclass/knight/irregularknight
		)

/datum/outfit/job/roguetown/knight
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/knight/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/retinue))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "knight's tabard ([index])"
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Ser"
		if(should_wear_femme_clothes(H))
			honorary = "Dame"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)

/datum/outfit/job/roguetown/knight
	cloak = /obj/item/clothing/cloak/tabard/retinue
	neck = /obj/item/clothing/neck/roguetown/bevor
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/scomstone/bad/garrison
	backpack_contents = list(
		/obj/item/storage/keyring/guardknight = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
	)

/datum/outfit/job/roguetown/knight/pre_equip(mob/living/carbon/human/H)
	..()
	H.verbs |= /mob/living/carbon/human/proc/take_squire

/mob/living/carbon/human/proc/take_squire()
	set name = "Take Squire"
	set category = "Noble"

	if(stat)
		return
	if(!mind)
		return

	if(!src.mind.squire)
		var/list/folksnearby = list()
		for(var/mob/living/carbon/human/potential_squires in (view(1)))
			if(potential_squires.job == "Squire")
				folksnearby += potential_squires
		var/target = input(src, "Take as Squire") as null|anything in folksnearby
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/guy = target
			if(!guy)
				return
			if(guy == src)
				return
			if(!guy.mind)
				return
			src.say("Are you not my squire, [guy]?")

			var/prompt = alert(guy, "Do wish to be [src]'s squire?", "Squire", "Aye, m'lord!", "Nae, m'lord!")
			if(prompt == "Nae, m'lord!")
				guy.say("I hold no oath of service to you, [src]. You are mistaken.")
				return

			else
				guy.say("It is as you say, [src], I am your squire.")
				guy.mind.knight = src
				src.mind.squire = guy
				var/datum/status_effect/buff/knight_prox/new_knight = src.apply_status_effect(/datum/status_effect/buff/knight_prox)
				var/datum/status_effect/buff/squire_prox/new_squire = guy.apply_status_effect(/datum/status_effect/buff/squire_prox)
				new_squire.knight = src
				new_knight.squire = guy
				src.verbs -= /mob/living/carbon/human/proc/take_squire//You get one chance at actually retaining this guy. Sorry, buddy.

/*
Firstly, the squire's buffs and boons or whatever.
*/
/datum/status_effect/buff/squire_prox
	alert_type = /atom/movable/screen/alert/status_effect/buff/squire_prox
	var/mob/living/carbon/knight = null
	duration = -1

/atom/movable/screen/alert/status_effect/buff/squire_prox
	name = "Oath of Service"
	desc = "I am in service to a knight. We shan't fail, whatever our duty is."
	icon_state = "buff"

/datum/status_effect/buff/squire_prox/on_creation()
	spawn(5)//Why are you so gross and hacky?
		examine_text = span_slime("<small>SUBJECTPRONOUN is the squire of [owner.mind.knight.real_name].</small>")
	return ..()

/datum/status_effect/buff/squire_prox/tick()
	for(var/mob/living/carbon/H in view(5, owner))
		if(H == knight)
			if(!owner.has_stress_event(/datum/stressevent/squire_prox))
				owner.add_stress(/datum/stressevent/squire_prox)

/datum/status_effect/buff/squire_prox/on_remove()
	owner.mind.knight = null
	owner.add_stress(/datum/stressevent/lost_knight)
	owner.remove_status_effect(/datum/status_effect/buff/squire_prox)
	if(knight && knight.mind)
		knight.mind.squire = null
		knight.remove_status_effect(/datum/status_effect/buff/knight_prox)

/datum/stressevent/lost_knight
	stressadd = 8
	desc = span_cultsmall("My knight! Where have they gone?!")
	timer = 30 MINUTES//How could you have failed them, so horribly?

/datum/stressevent/squire_prox
	stressadd = -3
	desc = span_green("I am near my knight.")
	timer = 1 MINUTES

/*
Now, the knight's.
*/
/datum/status_effect/buff/knight_prox
	alert_type = /atom/movable/screen/alert/status_effect/buff/knight_prox
	var/mob/living/carbon/squire = null
	duration = -1

/atom/movable/screen/alert/status_effect/buff/knight_prox
	name = "Oath of Service"
	desc = "I have a squire in my service. They're in good hands."
	icon_state = "buff"

/datum/status_effect/buff/knight_prox/on_creation()
	spawn(5)//Why are you so gross and hacky?
		examine_text = span_slime("<small>SUBJECTPRONOUN is the knight of [owner.mind.squire.real_name], their ward.</small>")
	return ..()

/datum/status_effect/buff/knight_prox/tick()
	for(var/mob/living/carbon/H in view(5, owner))
		if(H == squire)
			if(!owner.has_stress_event(/datum/stressevent/knight_prox))
				owner.add_stress(/datum/stressevent/knight_prox)

/datum/status_effect/buff/knight_prox/on_remove()
	owner.mind.squire = null
	owner.add_stress(/datum/stressevent/lost_squire)
	owner.remove_status_effect(/datum/status_effect/buff/knight_prox)
	if(squire && squire.mind)
		squire.mind.knight = null
		squire.remove_status_effect(/datum/status_effect/buff/squire_prox)

/datum/stressevent/lost_squire
	stressadd = 8
	desc = span_cultsmall("My squire! Where have they gone?!")
	timer = 30 MINUTES//Maybe keep them alive?

/datum/stressevent/knight_prox
	stressadd = -3
	desc = span_green("I am near my squire.")
	timer = 1 MINUTES
