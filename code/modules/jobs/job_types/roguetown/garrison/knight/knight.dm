/datum/job/roguetown/knight
	title = "Knight"
	flag = KNIGHT
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	allowed_races = RACES_TOLERATED_UP
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
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

		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob, cloak_and_title_setup)), 50)

/datum/outfit/job/roguetown/knight
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
	H.verbs |= /mob/living/carbon/human/proc/end_squire_connection

/mob/living/carbon/human/proc/take_squire()
	set name = "Take Squire"
	set category = "Noble"

	if(stat)
		return
	if(!mind)
		return
	if(mind.squire_bond_cooldown_until > world.time)
		to_chat(src, span_warning("I must wait [DisplayTimeText(mind.squire_bond_cooldown_until - world.time)] before taking another squire."))
		return

	if(!src.mind.squire)
		var/list/folksnearby = list()
		for(var/mob/living/carbon/human/potential_squires in (view(1)))
			if(potential_squires.job == "Squire")
				folksnearby += potential_squires
		if(!length(folksnearby))
			to_chat(src, span_warning("No eligible squires are close enough to take into service."))
			return
		var/target = input(src, "Take as Squire") as null|anything in folksnearby
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/guy = target
			if(!guy)
				return
			if(guy == src)
				return
			if(!guy.mind)
				return
			if(guy.mind.knight)
				to_chat(src, span_warning("[guy] is already sworn to a knight."))
				return
			if(guy.mind.squire_bond_cooldown_until > world.time)
				to_chat(src, span_warning("[guy] must wait [DisplayTimeText(guy.mind.squire_bond_cooldown_until - world.time)] before swearing a new oath."))
				return
			src.say("Are you not my squire, [guy]?")

			var/prompt = alert(guy, "Do wish to be [src]'s squire?", "Squire", "Aye, m'lord!", "Nae, m'lord!")
			if(prompt == "Nae, m'lord!")
				guy.say("I hold no oath of service to you, [src]. You are mistaken.")
				return

			else
				if(src.mind.squire || guy.mind.knight)
					return
				guy.say("It is as you say, [src], I am your squire.")
				guy.mind.knight = src
				src.mind.squire = guy
				var/datum/status_effect/buff/knight_prox/new_knight = src.apply_status_effect(/datum/status_effect/buff/knight_prox)
				var/datum/status_effect/buff/squire_prox/new_squire = guy.apply_status_effect(/datum/status_effect/buff/squire_prox)
				new_squire.knight = src
				new_knight.squire = guy
				src.verbs -= /mob/living/carbon/human/proc/take_squire//You get one chance at actually retaining this guy. Sorry, buddy.

/mob/living/carbon/human/proc/end_squire_connection()
	set name = "End Squire Bond"
	set category = "Noble"
	var/static/squire_bond_cooldown_duration = 5 MINUTES

	if(stat)
		return
	if(!mind)
		return
	if(mind.assigned_role != "Knight" && mind.assigned_role != "Squire")
		return

	var/mob/living/carbon/human/linked = null
	if(ishuman(mind.squire))
		linked = mind.squire
	else if(ishuman(mind.knight))
		linked = mind.knight

	if(!linked)
		to_chat(src, span_warning("I am not bound by oath to a knight or squire."))
		return

	if(alert(src, "End your oath with [linked]?", "Oath of Service", "End Bond", "Keep Bond") != "End Bond")
		return
	if(mind)
		mind.suppress_next_squire_bond_loss_stress = TRUE
		mind.squire_bond_cooldown_until = world.time + squire_bond_cooldown_duration
	if(linked.mind)
		linked.mind.suppress_next_squire_bond_loss_stress = TRUE
		linked.mind.squire_bond_cooldown_until = world.time + squire_bond_cooldown_duration

	if(mind.assigned_role == "Knight")
		if(!has_status_effect(/datum/status_effect/buff/knight_prox))
			mind.squire = null
			if(linked.mind)
				linked.mind.knight = null
			if(linked.has_status_effect(/datum/status_effect/buff/squire_prox))
				linked.remove_status_effect(/datum/status_effect/buff/squire_prox)
			else
				mind.suppress_next_squire_bond_loss_stress = FALSE
				if(linked.mind)
					linked.mind.suppress_next_squire_bond_loss_stress = FALSE
		remove_status_effect(/datum/status_effect/buff/knight_prox)
		verbs |= /mob/living/carbon/human/proc/take_squire
		to_chat(src, span_notice("I release [linked] from my service."))
		if(linked != src)
			to_chat(linked, span_notice("[src] has ended your oath of service."))
	else
		if(!has_status_effect(/datum/status_effect/buff/squire_prox))
			mind.knight = null
			if(linked.mind)
				linked.mind.squire = null
			if(linked.has_status_effect(/datum/status_effect/buff/knight_prox))
				linked.remove_status_effect(/datum/status_effect/buff/knight_prox)
			else
				mind.suppress_next_squire_bond_loss_stress = FALSE
				if(linked.mind)
					linked.mind.suppress_next_squire_bond_loss_stress = FALSE
		remove_status_effect(/datum/status_effect/buff/squire_prox)
		to_chat(src, span_notice("I am no longer in [linked]'s service."))
		if(linked != src)
			to_chat(linked, span_notice("[src] has ended their oath of service."))

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
	if(owner.mind?.suppress_next_squire_bond_loss_stress)
		owner.mind.suppress_next_squire_bond_loss_stress = FALSE
	else
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
	if(owner.mind?.suppress_next_squire_bond_loss_stress)
		owner.mind.suppress_next_squire_bond_loss_stress = FALSE
	else
		owner.add_stress(/datum/stressevent/lost_squire)
	owner.remove_status_effect(/datum/status_effect/buff/knight_prox)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.verbs |= /mob/living/carbon/human/proc/take_squire
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
