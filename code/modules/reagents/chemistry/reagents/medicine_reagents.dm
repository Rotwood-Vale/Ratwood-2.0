//////////////////////////////////////////////////////////////////////////////////////////
					// MEDICINE REAGENTS
//////////////////////////////////////////////////////////////////////////////////////

// where all the reagents related to medicine go.

/datum/reagent/medicine
	name = "药剂"
	taste_description = "苦味"

/datum/reagent/medicine/on_mob_life(mob/living/carbon/M)
	current_cycle++
	. = ..()

/datum/reagent/medicine/salglu_solution
	name = "盐糖溶液"
	description = "每次代谢周期有 33% 概率治疗钝伤与烧伤，也可作为临时血液替代品。"
	reagent_state = LIQUID
	color = "#DCDCDC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 60
	taste_description = "甜味和咸味"
	var/last_added = 0
	var/maximum_reachable = BLOOD_VOLUME_NORMAL - 10	//So that normal blood regeneration can continue with salglu active

/datum/reagent/medicine/salglu_solution/on_mob_life(mob/living/carbon/M)
	if(last_added)
		M.blood_volume -= last_added
		last_added = 0
	if(M.blood_volume < maximum_reachable)	//Can only up to double my effective blood level.
		var/amount_to_add = min(M.blood_volume, volume*5)
		var/new_blood_level = min(M.blood_volume + amount_to_add, maximum_reachable)
		last_added = new_blood_level - M.blood_volume
		M.blood_volume = new_blood_level
	if(prob(33))
		M.adjustBruteLoss(-0.5*REM, 0)
		M.adjustFireLoss(-0.5*REM, 0)
		. = TRUE
	..()

/datum/reagent/medicine/salglu_solution/overdose_process(mob/living/M)
	if(prob(3))
		to_chat(M, "<span class='warning'>我嘴里发咸。</span>")
		holder.add_reagent(/datum/reagent/consumable/sodiumchloride, 1)
		holder.remove_reagent(/datum/reagent/medicine/salglu_solution, 0.5)
	else if(prob(3))
		to_chat(M, "<span class='warning'>我嘴里发甜。</span>")
		holder.add_reagent(/datum/reagent/consumable/sugar, 1)
		holder.remove_reagent(/datum/reagent/medicine/salglu_solution, 0.5)
	if(prob(33))
		M.adjustBruteLoss(0.5*REM, FALSE, FALSE, BODYPART_ORGANIC)
		M.adjustFireLoss(0.5*REM, FALSE, FALSE, BODYPART_ORGANIC)
		. = TRUE
	..()

/datum/reagent/medicine/vital_essence
	name = "命髓"
	description = "一种自血液中夺取而来的精华，可恢复肉体、体力与口渴。"
	reagent_state = LIQUID
	color = "#7a0000"
	taste_description = "温热的命髓"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/medicine/vital_essence/on_mob_life(mob/living/carbon/M)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume + 5, BLOOD_VOLUME_NORMAL)
	if(!HAS_TRAIT(M, TRAIT_INFINITE_STAMINA))
		M.energy_add(10)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(5) // something between red and strong red. We cannot drink water 
	if(volume > 0.99)
		M.adjustBruteLoss(-1 * REM, 0)
		M.adjustFireLoss(-1 * REM, 0)
		M.adjustOxyLoss(-1, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1 * REM)
		M.adjustCloneLoss(-1 * REM, 0)
	return ..()
