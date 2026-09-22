GLOBAL_VAR_INIT(expedition_base_z, 0)

/datum/map_template/expedition
	abstract_type = /datum/map_template/expedition
	var/level_number = 1

/datum/map_template/expedition/level_1
	abstract_type = /datum/map_template/expedition/level_1
	level_number = 1

/datum/map_template/expedition/level_1/easy
	name = "Level 1 - Easy"
	mappath = "_maps/expedition/expedition_lvl1/easy_lvl1.dmm"

/datum/map_template/expedition/level_2
	abstract_type = /datum/map_template/expedition/level_2
	level_number = 2

/datum/map_template/expedition/level_2/easy
	name = "Level 2 - Easy"
	mappath = "_maps/expedition/expedition_lvl2/easy_lvl2.dmm"

/datum/map_template/expedition/level_3
	abstract_type = /datum/map_template/expedition/level_3
	level_number = 3

/datum/map_template/expedition/level_3/boss_easy
	name = "Level 3 - Easy Boss"
	mappath = "_maps/expedition/expedition_lvl3/Boss_easy.dmm"

/datum/map_template/expedition/level_4
	abstract_type = /datum/map_template/expedition/level_4
	level_number = 4

/datum/map_template/expedition/level_4/extra
	name = "Level 4 - Extra"
	mappath = "_maps/expedition/expedition_extra/extra_lvl4.dmm"

SUBSYSTEM_DEF(expedition_loader)
	name = "Expedition World Loader"
	init_order = INIT_ORDER_DUNGEON
	flags = SS_NO_FIRE

/datum/controller/subsystem/expedition_loader/Initialize(start_timeofday)
	build_expedition_world()
	return ..()

/datum/controller/subsystem/expedition_loader/proc/build_expedition_world()
	var/start_z = find_expedition_base_z()
	if(!start_z)
		return

	GLOB.expedition_base_z = start_z

	var/list/sector_offsets = list(
		list("x" = 10,  "y" = 10),
		list("x" = 105, "y" = 10),
		list("x" = 10,  "y" = 105),
		list("x" = 105, "y" = 105)
	)

	for(var/level = 1 to 4)
		var/parent_type = text2path("/datum/map_template/expedition/level_[level]")
		if(!parent_type)
			continue

		var/list/possible_templates = list()
		for(var/path in subtypesof(parent_type))
			if(is_abstract(path))
				continue
			possible_templates += path

		if(!length(possible_templates))
			continue

		var/chosen_path = pick(possible_templates)
		var/datum/map_template/template = new chosen_path()

		var/list/coords = sector_offsets[level]
		var/spawn_x = coords["x"]
		var/spawn_y = coords["y"]
		var/target_z = start_z

		if(spawn_x + template.width > world.maxx || spawn_y + template.height > world.maxy)
			spawn_x = 1
			spawn_y = 1
			target_z = start_z + (level - 1)

		var/turf/spawn_turf = locate(spawn_x, spawn_y, target_z)
		if(spawn_turf)
			template.load(spawn_turf)

/datum/controller/subsystem/expedition_loader/proc/find_expedition_base_z()
	if(!SSmapping || !length(SSmapping.z_list))
		return 0

	for(var/datum/space_level/SL in SSmapping.z_list)
		if(findtext(SL.name, "Expedition Base"))
			return SL.z_value

	return 0
