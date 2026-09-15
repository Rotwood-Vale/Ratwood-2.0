/datum/unit_test/species_whitelist_check/Run()
	for(var/datum/species/S as anything in subtypesof(/datum/species))
		if(is_abstract(S))
			continue
		if(initial(S.changesource_flags) == NONE)
			Fail("A species type was detected with no changesource flags: [S]")
