/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/rockhill
	map_file_name = "rockhill.dmm"
	realm_name = "Rockhill"
	blacklist = list()
	// slot_adjust = list(
	// 	/datum/job/roguetown/villager = 42,
	// // 	/datum/job/roguetown/adventurer = 69
	// )
	title_adjust = list(
		/datum/job/roguetown/physician = list(display_title = "Court Physician")
	)
	tutorial_adjust = list(
		/datum/job/roguetown/physician = "You are a master physician, trusted by the Duke to administer expert care to the court,\
		its protectors and its subjects. While primarily a resident of the keep in the keep's medical quarters, you also have access\
		 to local hightown clinic, where lesser licensed apothecaries ply their trade under your occasional tutelage.\
		clinic."
		
		/datum/job/roguetown/bogguardsman = "Typically a denizen of the sparsely populated regions surrounding Rockhill, you volunteered up with the wardens--a group of ranger types who keep a vigil over Lowtown and the untamed wilderness. \
				While Wardens have no higher authority, operating as a fraternity of rangers, you will be called upon as members of the garrison by the Marshal or the Crown. \
				Serve their will, hold the lowtown fort, and recieve what a ranger craves the most - freedom and safety."
				
		// /datum/job/roguetown/archivist = "CHANGE THIS!! - Teach people skills, whether DIRECTLY or by writing SKILLBOOKS. You and the Veteran next door teach people shit."
	
	)
	species_adjust = list()
	sexes_adjust = list()
