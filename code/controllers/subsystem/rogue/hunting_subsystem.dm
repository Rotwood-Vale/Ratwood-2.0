GLOBAL_LIST_INIT(bog_mire, list(
	/area/rogue/outdoors/bog,
	/area/rogue/outdoors/bog/north,
	/area/rogue/outdoors/bog/south,
	/area/rogue/outdoors/bograt,
	/area/rogue/outdoors/bograt/north,
	/area/rogue/outdoors/bograt/south,
	/area/rogue/outdoors/bograt/west,
	/area/rogue/outdoors/bograt/sunken,
	/area/rogue/under/cavewet/bogcaves,
	/area/rogue/under/cavewet/bogcaves/west,
	/area/rogue/under/cavewet/bogcaves/central,
	/area/rogue/under/cavewet/bogcaves/south,
	/area/rogue/under/cavewet/bogcaves/north,
	/area/rogue/under/cavewet/bogcaves/coastcaves
))

GLOBAL_LIST_INIT(underdark, list(
	/area/rogue/under/underdark,
	/area/rogue/under/underdark/south,
	/area/rogue/under/underdark/north,
	/area/rogue/under/underdark/rockhill,
	/area/rogue/under/underdark/rockhill/east,
	/area/rogue/under/underdark/rockhill/west,
	/area/rogue/under/underdarker,
	/area/rogue/under/underdarker/rockhill,
	/area/rogue/under/cavewet
))

GLOBAL_LIST_INIT(main_forest, list(
	/area/rogue/outdoors/woods,
	/area/rogue/outdoors/woods/north,
	/area/rogue/outdoors/woods/northeast,
	/area/rogue/outdoors/woods/southeast,
	/area/rogue/outdoors/woods/south,
	/area/rogue/outdoors/woods/southwest,
	/area/rogue/outdoors/woods/northwest,
	/area/rogue/outdoors/woodsrat,
	/area/rogue/outdoors/woodsrat/north,
	/area/rogue/outdoors/woodsrat/south
))

GLOBAL_LIST_INIT(coastal_forest, list(
	/area/rogue/outdoors/beach,
	/area/rogue/outdoors/beach/north,
	/area/rogue/outdoors/beach/south,
	/area/rogue/outdoors/beach/byos,
	/area/rogue/outdoors/beach/forest,
	/area/rogue/outdoors/beach/forest/north,
	/area/rogue/outdoors/beach/forest/south
))

GLOBAL_LIST_INIT(jungle_island, list(
	/area/rogue/outdoors/jungle,
	/area/rogue/outdoors/byos,
	/area/rogue/outdoors/town/byos,
	/area/rogue/under/cavewet/byos,
	/area/rogue/under/cavewet/byos/banditcove
))

GLOBAL_LIST_INIT(mountains, list(
	/area/rogue/outdoors/mountains,
	/area/rogue/outdoors/mountains/deception,
	/area/rogue/outdoors/mountains/decap,
	/area/rogue/outdoors/mountains/decap/rockhill,
	/area/rogue/outdoors/mountains/decap/stepbelow,
	/area/rogue/outdoors/mountains/decap/gunduzirak,
	/area/rogue/outdoors/mountains/decap/minotaurfort
))

GLOBAL_LIST_INIT(caves, list(
	/area/rogue/indoors/cave,
	/area/rogue/under/cave,
	/area/rogue/under/cave/spider,
	/area/rogue/under/cavewet,
	/area/rogue/under/cavelava,
	/area/rogue/outdoors/caves,
	/area/rogue/outdoors/spidercave
))

SUBSYSTEM_DEF(hunting)
	name = "Hunting"
	wait = 5 MINUTES
	runlevels = RUNLEVEL_GAME
	flags = 0
	/// List of landmark objects waiting to spawn a new trail
	var/list/active_spawners = list()
	/// List of key-value pairs that's an area, and a static list of linked areas that area belongs to.
	var/list/area_lookup = list()

// Uncomment debug comments to debug!
/datum/controller/subsystem/hunting/fire(resumed = 0)
	if(!(SSticker.current_state == GAME_STATE_PLAYING && active_spawners.len > 0))
		return
	//to_chat(world, span_alert("SSHunting: Firing. Managing [active_spawners.len] spawner landmarks."))

	var/amount_to_respawn = max(1, round(active_spawners.len * 0.25))

	for(var/i in 1 to amount_to_respawn)
		var/obj/effect/landmark/hunting_spawner/JS = pick(active_spawners)
		if(!JS || QDELETED(JS))
			active_spawners -= JS
			continue

		//to_chat(world, span_alert("SSHunting: Spawning new trail at [JS.x], [JS.y]."))
		JS.respawn_trail()

/datum/controller/subsystem/hunting/Initialize()
	. = ..()
	for(var/group_type in subtypesof(/datum/hunting_area_group))
		var/datum/hunting_area_group/GA = new group_type()
		var/list/group_list = GA.get_areas()

		if(!group_list || !group_list.len)
			qdel(GA)
			continue

		for(var/area_path in group_list)
			area_lookup[area_path] = group_list
		qdel(GA)

/datum/controller/subsystem/hunting/proc/get_linked_areas(area_type)
	// Return the cached reference, or a unique list if it's a "solo" area
	return area_lookup[area_type] || list(area_type)

// These are used just to provide a memory-optimized way to link areas together on trail init.
// Since every track references the same lists, this should be optimized? If not, slap me.
/datum/hunting_area_group

/datum/hunting_area_group/proc/get_areas()
	return list()

/datum/hunting_area_group/bog_mire/get_areas()
	return GLOB.bog_mire

/datum/hunting_area_group/underdark/get_areas()
	return GLOB.underdark

/datum/hunting_area_group/coastal_forest/get_areas()
	return GLOB.coastal_forest

/datum/hunting_area_group/main_forest/get_areas()
	return GLOB.main_forest

/datum/hunting_area_group/jungle_island/get_areas()
	return GLOB.jungle_island

/datum/hunting_area_group/mountains/get_areas()
	return GLOB.mountains

/datum/hunting_area_group/caves/get_areas()
	return GLOB.caves
