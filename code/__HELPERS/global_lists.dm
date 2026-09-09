//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/make_datum_reference_lists()
	// this has to be done here so that we know GLOB.typecache_living exists
	GLOB.emote_list = init_emote_list()

	init_species()

	// Keybindings
	init_keybindings()

	for(var/datum/crafting_recipe/R as anything in GLOB.crafting_recipes)
		R.build_display_cache()

	init_faiths()
	init_patrons()

	init_statpacks()

	init_combat_music()

/proc/init_subtypes_assoc(prototype)
	. = list()
	for(var/path in subtypesof(prototype))
		.[path] = new path()

/proc/init_wildshapes()
	. = list()
	for(var/mob/living/carbon/human/species/wildshape/shape as anything in subtypesof(/mob/living/carbon/human/species/wildshape))
		.[shape::name] = shape

/proc/init_charflaw_singletons()
	. = list()
	for (var/path in subtypesof(/datum/charflaw))
		.[path] = new path()

//creates every subtype of prototype (excluding prototype) and adds it to list L.
//if no list/L is provided, one is created.
/proc/init_subtypes(prototype, list/L)
	if(!istype(L))
		L = list()
	for(var/path in subtypesof(prototype))
		L += new path()
	return L

//returns a list of paths to every subtype of prototype (excluding prototype)
//if no list/L is provided, one is created.
/proc/init_paths(prototype, list/L)
	if(!istype(L))
		L = list()
		for(var/path in subtypesof(prototype))
			L+= path
		return L

//Surgeries
/proc/init_surgeries()
	. = list()
	for(var/path in subtypesof(/datum/surgery))
		. += new path()
	sortList(., GLOBAL_PROC_REF(cmp_typepaths_asc))

//Surgery steps
/proc/init_surgery_steps()
	. = list()
	for(var/path in subtypesof(/datum/surgery_step))
		. += new path()
	sortList(., GLOBAL_PROC_REF(cmp_typepaths_asc))

// Anvil recipes
/proc/init_anvil_recipes()
	. = list()
	for(var/datum/anvil_recipe/path as anything in subtypesof(/datum/anvil_recipe))
		if(!path::name || !path::i_type)
			continue
		. += new path()

// Faiths
/proc/init_faiths()
	for(var/path in subtypesof(/datum/faith))
		var/datum/faith/faith = new path()
		GLOB.faithlist[path] = faith
		if(faith.preference_accessible)
			GLOB.preference_faiths[path] = faith

// Patron Gods
/proc/init_patrons()
	for(var/path in subtypesof(/datum/patron))
		var/datum/patron/patron = new path()
		GLOB.patronlist[path] = patron
		LAZYINITLIST(GLOB.patrons_by_faith[patron.associated_faith])
		GLOB.patrons_by_faith[patron.associated_faith][path] = patron
		if(patron.preference_accessible)
			GLOB.preference_patrons[path] = patron

//Species
/proc/init_species()
	for(var/species_path in subtypesof(/datum/species))
		// this is done just to get the name, I guess if anything changes the species name on init we can't just use `species_path::name`
		var/datum/species/species = new species_path()
		GLOB.species_list[species.name] = species_path
		qdel(species)
	sortList(GLOB.species_list, GLOBAL_PROC_REF(cmp_typepaths_asc))

// Ported from Lethalstone
/proc/init_statpacks()
	. = list()
	for (var/path in subtypesof(/datum/statpack))
		.[path] = new path()
	sortList(., GLOBAL_PROC_REF(cmp_text_dsc))

/proc/init_combat_music()
	// Combat Music Overrides
	for (var/path in subtypesof(/datum/combat_music))
		var/datum/combat_music/combat_music = new path()
		GLOB.cmode_tracks_by_type[path] = combat_music
		cmode_track_to_namelist(combat_music)
