//Rot-cure for revival sickness healing and rot-penalty reversal.
/obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure
	list_reagents = list(/datum/reagent/rotcure = 30)	//Should be enough for 2 usages.

/datum/reagent/rotcure
	name = "Rot-Cure"
	description = "A putrid substance that appears to be in perpetual motion. It smells and looks of living-sludge."
	color = "#034212"
	taste_description = "living sludge"
	overdose_threshold = 21	//Stops people from downing too much of it.
	metabolization_rate = 0.1

/datum/reagent/rotcure/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, 0.25*REM)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.5*REM)
	..()
	. = 1

/datum/reagent/rotcure/on_mob_life(mob/living/carbon/M)
	
	if(volume > 8)	//Roughly 1 sip from vial.
		var/datum/antagonist/zombie/was_zombie = get_deadite_antag_for_body(M)
		if(was_zombie)
			if(remove_rot(target = M, user = M, method = "alchemy", damage = 0,
			success_message = "The rot pours out from the pores of [M].",
			fail_message = "The rot fail to leave the body.", lethal = FALSE))
				M.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
		M.remove_status_effect(/datum/status_effect/zombie_infection) 
		M.remove_status_effect(/datum/status_effect/debuff/rotted)	//Removes de-rot debuff
		M.remove_status_effect(/datum/status_effect/debuff/revived)	//Removes the 15-minute temp revive debuff
	..()
