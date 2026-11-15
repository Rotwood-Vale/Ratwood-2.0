GLOBAL_VAR_INIT(expedition_base_z, 0)
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

		if(template.width && template.height)
			spawn_x = clamp(spawn_x, 1, max(1, world.maxx - template.width))
			spawn_y = clamp(spawn_y, 1, max(1, world.maxy - template.height))

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

/datum/map_template/expedition
	abstract_type = /datum/map_template/expedition
	var/level_number = 1

/datum/map_template/expedition/level_1
	abstract_type = /datum/map_template/expedition/level_1
	level_number = 1

/datum/map_template/expedition/level_1/crypt
	name = "Level 1 - Forgotten Crypt"
	mappath = "_maps/expedition/expedition_lvl1/easy_lvl1.dmm"

/datum/map_template/expedition/level_1/cave
	name = "Level 1 - Dark Caves"
	mappath = "_maps/expedition/expedition_lvl1/cave_lvl1.dmm"

/datum/map_template/expedition/level_2
	abstract_type = /datum/map_template/expedition/level_2
	level_number = 2

/datum/map_template/expedition/level_2/dragon_desert
	name = "Level 2 - Dragon's Desert"
	mappath = "_maps/expedition/expedition_lvl2/easy_lvl2.dmm"

/datum/map_template/expedition/level_2/flooded_grotto
	name = "Level 2 - Flooded Grotto"
	mappath = "_maps/expedition/expedition_lvl2/tower_lvl2.dmm"

/datum/map_template/expedition/level_3
	abstract_type = /datum/map_template/expedition/level_3
	level_number = 3

/datum/map_template/expedition/level_3/baroness_castle
	name = "Level 3 - Baroness Keep"
	mappath = "_maps/expedition/expedition_lvl3/Boss_easy.dmm"

/datum/map_template/expedition/level_3/trap_mid
	name = "Level 3 - Lava"
	mappath = "_maps/expedition/expedition_lvl3/trap_mid.dmm"

/datum/map_template/expedition/level_4
	abstract_type = /datum/map_template/expedition/level_4
	level_number = 4

/datum/map_template/expedition/level_4/lich_crypt
	name = "Level 4 - Sanctum of the Archlich"
	mappath = "_maps/expedition/expedition_extra/extra_lvl4.dmm"


/obj/structure/expedition_gate/level_1_exit
	name = "descending rift"
	stage_number = 1

/obj/structure/expedition_gate/level_2_exit
	name = "descending rift"
	stage_number = 2

/obj/structure/expedition_gate/level_3_exit
	name = "abyssal threshold"
	color = "#ff0d00"
	stage_number = 3

/obj/structure/expedition_marker/entry/level_1
	stage_number = 1
	stage_name = "Depth I: Forgotten Depths"
	level_objectives = list(
		"explore" = "Descend deeper into the ruins",
		"find_rift" = "Find the Descending Rift"
	)

/obj/structure/expedition_marker/entry/level_1/crypt
	stage_name = "Depth I: Forgotten river"

/obj/structure/expedition_marker/entry/level_1/cave
	stage_name = "Depth I: Gloomy Caverns"
	level_objectives = list(
		"explore" = "Navigate through the jagged caves",
		"find_rift" = "Find the Descending Rift"
	)


/obj/structure/expedition_marker/entry/level_2
	stage_number = 2
	stage_name = "Depth II: Perilous Domain"
	level_objectives = list(
		"survive" = "Survive the perils of the depth",
		"reach_gate" = "Enter the Descending Rift"
	)

/obj/structure/expedition_marker/entry/level_2/dragon_desert
	stage_name = "Depth II: Desert of the Dragon"
	level_objectives = list(
		"voiddragon" = "Slay the Void Dragon",
		"reach_gate" = "Enter the Descending Rift"
	)

/obj/structure/expedition_marker/entry/level_2/tower
	stage_name = "Depth II: Ancient Tower"
	level_objectives = list(
		"fishboss" = "Defeat the Duke of the Deep",
		"reach_gate" = "Enter the Descending Rift"
	)

/obj/structure/expedition_marker/entry/level_3
	stage_number = 3
	stage_name = "Depth III: High Hold"
	level_objectives = list(
		"explore" = "Infiltrate the stronghold",
		"teleport_chamber" = "Find the passage forward"
	)

/obj/structure/expedition_marker/entry/level_3/baroness_castle
	stage_name = "Depth III: Baroness's Keep"
	level_objectives = list(
		"baroness" = "Defeat the Baroness",
		"teleport_chamber" = "Enter the Convergence Chamber"
	)

/obj/structure/expedition_marker/entry/level_3/trap_mid
	stage_name = "Depth III: lava see"
	level_objectives = list(
		"slay_boss" = "Slay the master of the depth",
		"teleport_chamber" = "Enter the Convergence Chamber"
	)

/obj/structure/expedition_marker/entry/level_4
	stage_number = 4
	stage_name = "Final Depth: The Abyss"
	level_objectives = list(
		"slay_boss" = "Slay the master of the depth",
		"loot" = "Claim the treasures and escape"
	)

/obj/structure/expedition_marker/entry/level_4/lich_crypt
	stage_name = "Final Depth: Sanctum of Bones"
	level_objectives = list(
		"slay_boss" = "Slay the Archlich",
		"loot" = "Claim the treasures and escape"
	)

/obj/structure/expedition_marker/entry/boss_chamber
	stage_number = 4
	stage_name = "Final Depth: Sanctum of Bones"
	level_objectives = list(
		"slay_boss" = "Slay the Archlich",
		"loot" = "Claim the treasures and escape"
	)
