/datum/reagent/miasmagas
	name = "瘴气"
	description = "."
	color = "#801E28" // rgb: 128, 30, 40
	taste_description = "恶臭"
	metabolization_rate = 1

/datum/reagent/miasmagas/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M, TRAIT_NOSTINK))
		M.add_nausea(15)
		M.add_stress(/datum/stressevent/miasmagas)
	return ..()


/datum/reagent/rogueacid
	name = "盗镇酸液"
	description = "."
	reagent_state = LIQUID
	color = "#5eff00"
	taste_description = "灼烧感"
	self_consuming = TRUE

/datum/reagent/rogueacid/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	M.adjustFireLoss(35, 0)
	..()

//Might be worth putting in toxins?
//Not used for anything but Lamia bites.
/datum/reagent/lam_venom
	name = "拉弥亚毒液"
	description = ""
	reagent_state = LIQUID
	color = "#083b1c"
	taste_description = "液态火焰"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM * 3
	harmful = TRUE//Antidote can purge it.

/datum/reagent/lam_venom/on_mob_life(mob/living/carbon/M)
//This won't bother Lamia characters.
	if(islamia(M))
		return ..()
//Looks a lot worse than it is. Caps someone's max stamina, effectively, in half.
//Acts as a drain for energy as a result, too.
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		if(M.stamina <= M.max_stamina/2)
			M.stamina_add(10)
//You're seeing things, brother. A screenflash at such a low rate.
//To notify them, if the stamina capping and energy drain doesn't.
	M.adjust_drugginess(1)
//Fluff text and emote.
	if(prob(10))
		to_chat(M, span_warning("我的血肉在燃烧！"))
		if(prob(1))
			M.emote("agony")
	return ..()
