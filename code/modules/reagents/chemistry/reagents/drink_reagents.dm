

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rougetown Reagents - Ported from Dreamkeep
/datum/reagent/consumable/acorn_powder
	name = "橡果粉"
	description = "一种带苦味的细腻粉末。"
	color = "#dcb137"
	quality = DRINK_VERYGOOD
	taste_description = "苦涩的泥土气息"

/datum/reagent/consumable/acorn_powder/on_mob_life(mob/living/carbon/M)
	M.energy_add(8)
	..()

/datum/reagent/consumable/Acoffee
	name = "橡果咖啡"
	description = "一杯苦香宜人、提神醒脑的饮品"
	color = "#800000"
	quality = DRINK_VERYGOOD
	taste_description = "浓郁的泥土气息"
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	overdose_threshold = null
	var/hydration = 8
	var/metabolized_acoffee = 0

// you metabolize the coffee and it tracks it
/datum/reagent/consumable/Acoffee/on_mob_add(mob/living/carbon/M)
	metabolized_acoffee = 0

/datum/reagent/consumable/Acoffee/on_mob_life(mob/living/carbon/M)
	metabolized_acoffee += metabolization_rate

	// Apply the effects of Acorn Coffee
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.adjust_hydration(hydration)
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+10, BLOOD_VOLUME_NORMAL)
	M.energy_add(8)
	M.dizziness = max(0, M.dizziness - 5)
	M.drowsyness = max(0, M.drowsyness - 3)
	M.SetSleeping(0, FALSE)

	// Remove the sleepytime status effect after consumption
	if(metabolized_acoffee >= metabolization_rate)
		if(M.has_status_effect(/datum/status_effect/debuff/sleepytime))
			M.remove_status_effect(/datum/status_effect/debuff/sleepytime)
			M.remove_stress(/datum/stressevent/sleepytime)
			to_chat(M, span_green("这杯咖啡让我清醒专注多了！"))
			M.visible_message(span_info("[M]的眼神重新聚焦，脸上的倦意也随之消散。"))
			M.adjust_triumphs(1)
			if(M.mind?.sleep_adv)
				M.mind.sleep_adv.sleep_adv_points += 3
				M.mind.sleep_adv.advance_cycle()

	..()

/datum/chemical_reaction/alch/acoffee
	name = "橡果咖啡"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/Acoffee
	required_temp = 374
	results = list(/datum/reagent/consumable/Acoffee = 6)
	required_reagents = list(/datum/reagent/consumable/acorn_powder = 1, /datum/reagent/water = 5)

/datum/chemical_reaction/alch/acoffee/on_reaction(mob/user, obj/item/reagent_containers/container, total_volume)
	. = ..()
	if(container)
		// Remove all leftover water
		container.reagents.del_reagent(/datum/reagent/water)

/datum/reagent/consumable/milk
	name = "牛奶"
	description = "一种由哺乳动物乳腺产生的白色不透明液体。"
	color = "#DFDFDF" // rgb: 223, 223, 223
	taste_description = "牛奶"
	glass_icon_state = "glass_white"
	glass_name = "一杯牛奶"
	glass_desc = ""

/datum/reagent/consumable/milk/on_mob_life(mob/living/carbon/M)
	if(M.getBruteLoss() && prob(20))
		M.heal_bodypart_damage(1,0, 0)
		. = 1
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.adjust_hydration(10)
		if(H.blood_volume < BLOOD_VOLUME_NORMAL)
			H.blood_volume = min(H.blood_volume+10, BLOOD_VOLUME_NORMAL)
	..()
