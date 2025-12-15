/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/spookmanor
	map_file_name = "spookmanor.dmm"
	realm_name = "The Manor"
	slot_adjust = list(
		/datum/job/roguetown/villager = 42,
		/datum/job/roguetown/adventurer = 69
	)
	title_adjust = list(
		/datum/job/roguetown/lord = list(display_title = "Baron", f_title = "Baroness")
		/datum/job/roguetown/physician = list(display_title = "Manor Doctor")
	)
	tutorial_adjust = list(
		/datum/job/roguetown/lord = "The Gronnmen are coming."
		/datum/job/roguetown/knight = "You live here when you aren't out on crusades.."
	)
