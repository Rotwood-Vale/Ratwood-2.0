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
	tutorial = "你已证明自己既忠诚又堪用，因此受封为骑士，作为王室的哨卫守护王国。\
	你听命于君主、元帅与骑士统领，捍卫你的领主与领地，那是这黑暗时代里最后的骑士精神灯塔。\
	你的一切都献给当下的摄政者及其安危。切莫失职。"
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
		var/honorary = "爵士"
		if(should_wear_femme_clothes(H))
			honorary = "女爵"
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

/mob/living/carbon/human/proc/take_squire()
	set name = "收侍从"
	set category = "贵族"

	if(stat)
		return
	if(!mind)
		return

	if(!src.mind.squire)
		var/list/folksnearby = list()
		for(var/mob/living/carbon/human/potential_squires in (view(1)))
			if(potential_squires.job == "Squire")
				folksnearby += potential_squires
		var/target = input(src, "收谁为侍从？") as null|anything in folksnearby
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/guy = target
			if(!guy)
				return
			if(guy == src)
				return
			if(!guy.mind)
				return
			src.say("你不正是我的侍从吗，[guy]？")

			var/prompt = alert(guy, "你愿意成为[src]的侍从吗？", "侍从", "愿意，大人！", "不愿，大人！")
			if(prompt == "不愿，大人！")
				guy.say("我并未向你立下效忠誓言，[src]。你认错人了。")
				return

			else
				guy.say("正如你所说，[src]，我是你的侍从。")
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
	name = "效忠誓约"
	desc = "我正侍奉一位骑士。无论职责为何，我们都不会失手。"
	icon_state = "buff"

/datum/status_effect/buff/squire_prox/on_creation()
	spawn(5)//Why are you so gross and hacky?
		examine_text = span_slime("<small>SUBJECTPRONOUN是[owner.mind.knight.real_name]的侍从。</small>")
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
	desc = span_cultsmall("我的骑士！他们去哪了？！")
	timer = 30 MINUTES//How could you have failed them, so horribly?

/datum/stressevent/squire_prox
	stressadd = -3
	desc = span_green("我就在我的骑士身旁。")
	timer = 1 MINUTES

/*
Now, the knight's.
*/
/datum/status_effect/buff/knight_prox
	alert_type = /atom/movable/screen/alert/status_effect/buff/knight_prox
	var/mob/living/carbon/squire = null
	duration = -1

/atom/movable/screen/alert/status_effect/buff/knight_prox
	name = "效忠誓约"
	desc = "我麾下有一名侍从。他正由我亲自照看。"
	icon_state = "buff"

/datum/status_effect/buff/knight_prox/on_creation()
	spawn(5)//Why are you so gross and hacky?
		examine_text = span_slime("<small>SUBJECTPRONOUN是[owner.mind.squire.real_name]的骑士与监护人。</small>")
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
	desc = span_cultsmall("我的侍从！他们去哪了？！")
	timer = 30 MINUTES//Maybe keep them alive?

/datum/stressevent/knight_prox
	stressadd = -3
	desc = span_green("我就在我的侍从身旁。")
	timer = 1 MINUTES
