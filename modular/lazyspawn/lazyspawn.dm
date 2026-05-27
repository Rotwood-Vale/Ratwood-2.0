#define LAZY_MOB_DEFAULT_TRIGGER_RANGE 5
#define LAZY_MOB_AMBUSH_TRIGGER_RANGE 3

#define LAZY_MOB_MIN_SPAWN_DELAY 5 SECONDS
#define LAZY_MOB_MAX_SPAWN_DELAY 15 SECONDS

/// turf key -> /obj/effect/lazy_mob_trigger
/// один trigger object на turf, даже если рядом несколько спавнеров
var/global/list/lazy_mob_triggers_by_turf = list()


/proc/lazy_mob_trigger_key(turf/T)
	if(!T)
		return null

	return "[T.x]|[T.y]|[T.z]"


/obj/effect/lazy_mob_trigger
	name = "lazy mob trigger"
	desc = "Invisible lazy mob trigger."

	anchored = TRUE
	density = FALSE
	opacity = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_ABSTRACT

	/// Spawners attached to this trigger turf.
	var/list/linked_spawners = list()


/obj/effect/lazy_mob_trigger/Crossed(atom/movable/AM)
	. = ..()

	if(!AM)
		return

	if(!isliving(AM))
		return

	var/mob/living/L = AM

	if(!L.client)
		return

	if(L.stat == DEAD)
		return

	if(isobserver(L))
		return

	if(!linked_spawners || !length(linked_spawners))
		return

	for(var/obj/effect/lazy_mob_spawner/S as anything in linked_spawners)
		if(!S)
			continue

		S.arm_lazy_spawn(L)


/obj/effect/lazy_mob_trigger/proc/add_spawner(obj/effect/lazy_mob_spawner/S)
	if(!S)
		return FALSE

	if(!linked_spawners)
		linked_spawners = list()

	if(!(S in linked_spawners))
		linked_spawners += S

	return TRUE


/obj/effect/lazy_mob_trigger/proc/remove_spawner(obj/effect/lazy_mob_spawner/S)
	if(!S)
		return FALSE

	if(linked_spawners)
		linked_spawners -= S

	if(!linked_spawners || !length(linked_spawners))
		var/turf/T = get_turf(src)
		var/key = lazy_mob_trigger_key(T)

		if(key && lazy_mob_triggers_by_turf[key] == src)
			lazy_mob_triggers_by_turf -= key

		qdel(src)

	return TRUE


/obj/effect/lazy_mob_spawner
	name = "lazy mob spawner"
	desc = "Spawns its mob after a living player crosses its invisible trigger ring."

	anchored = TRUE
	density = FALSE
	opacity = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_ABSTRACT
	var/mob_type = null
	var/trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE
	var/spawn_delay_min = LAZY_MOB_MIN_SPAWN_DELAY
	var/spawn_delay_max = LAZY_MOB_MAX_SPAWN_DELAY
	var/spawned = FALSE
	var/pending_spawn = FALSE
	var/list/registered_lazy_triggers = list()


/obj/effect/lazy_mob_spawner/Initialize(mapload)
	. = ..()

	if(!mob_type)
		return

	build_lazy_trigger_ring()


/obj/effect/lazy_mob_spawner/Destroy()
	clear_lazy_trigger_ring()
	return ..()


/obj/effect/lazy_mob_spawner/proc/build_lazy_trigger_ring()
	var/turf/origin = get_turf(src)
	if(!origin)
		return FALSE

	if(trigger_range <= 0)
		return FALSE

	if(!registered_lazy_triggers)
		registered_lazy_triggers = list()

	for(var/dx = -trigger_range, dx <= trigger_range, dx++)
		for(var/dy = -trigger_range, dy <= trigger_range, dy++)
			if(max(abs(dx), abs(dy)) != trigger_range)
				continue
			var/turf/T = locate(origin.x + dx, origin.y + dy, origin.z)
			if(!T)
				continue
			var/key = lazy_mob_trigger_key(T)
			if(!key)
				continue
			var/obj/effect/lazy_mob_trigger/trigger = lazy_mob_triggers_by_turf[key]
			if(!trigger)
				trigger = new /obj/effect/lazy_mob_trigger(T)
				lazy_mob_triggers_by_turf[key] = trigger
			trigger.add_spawner(src)
			if(!(trigger in registered_lazy_triggers))
				registered_lazy_triggers += trigger
	return TRUE


/obj/effect/lazy_mob_spawner/proc/clear_lazy_trigger_ring()
	if(!registered_lazy_triggers)
		return FALSE

	for(var/obj/effect/lazy_mob_trigger/trigger as anything in registered_lazy_triggers)
		if(!trigger)
			continue
		trigger.remove_spawner(src)
	registered_lazy_triggers = null
	return TRUE


/obj/effect/lazy_mob_spawner/proc/arm_lazy_spawn(mob/living/player)
	if(spawned)
		return FALSE
	if(pending_spawn)
		return FALSE
	if(!player)
		return FALSE
	if(!player.client)
		return FALSE
	if(player.stat == DEAD)
		return FALSE
	if(isobserver(player))
		return FALSE
	if(!mob_type)
		return FALSE
	var/turf/spawn_turf = get_turf(src)
	if(!spawn_turf)
		return FALSE
	if(player.z != spawn_turf.z)
		return FALSE
	pending_spawn = TRUE
	var/min_delay = min(spawn_delay_min, spawn_delay_max)
	var/max_delay = max(spawn_delay_min, spawn_delay_max)
	addtimer(CALLBACK(src, PROC_REF(delayed_spawn_mob)), rand(min_delay, max_delay))

	return TRUE


/obj/effect/lazy_mob_spawner/proc/delayed_spawn_mob()
	if(spawned)
		return FALSE
	pending_spawn = FALSE
	return spawn_mob()


/obj/effect/lazy_mob_spawner/proc/spawn_mob()
	if(spawned)
		return FALSE
	if(!mob_type)
		return FALSE
	var/turf/spawn_turf = get_turf(src)
	if(!spawn_turf)
		return FALSE
	spawned = TRUE
	var/mob/living/spawned_mob = new mob_type(spawn_turf)
	if(!spawned_mob)
		spawned = FALSE
		return FALSE

	spawned_mob.dir = dir
	qdel(src)

	return TRUE


/obj/effect/lazy_mob_spawner/skeleton_bow
	name = "lazy skeleton bow spawner"
	mob_type = /mob/living/simple_animal/hostile/rogue/skeleton/bow
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/skeleton_npc
	name = "lazy skeleton npc spawner"
	mob_type = /mob/living/carbon/human/species/skeleton/npc
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/haunt
	name = "lazy haunt spawner"
	mob_type = /mob/living/simple_animal/hostile/rogue/haunt
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/troll_axe
	name = "lazy troll axe spawner"
	mob_type = /mob/living/simple_animal/hostile/retaliate/rogue/troll/axe
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/goblin_cave
	name = "lazy cave goblin spawner"
	mob_type = /mob/living/carbon/human/species/goblin/npc/cave
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/orc_marauder
	name = "lazy orc marauder spawner"
	mob_type = /mob/living/carbon/human/species/orc/npc/marauder
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/skeleton_medium
	name = "lazy medium skeleton spawner"
	mob_type = /mob/living/carbon/human/species/skeleton/npc/medium
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/deepone
	name = "lazy deepone spawner"
	mob_type = /mob/living/simple_animal/hostile/rogue/deepone
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/goblin_ambush_cave
	name = "lazy cave ambush goblin spawner"
	mob_type = /mob/living/carbon/human/species/goblin/npc/ambush/cave
	trigger_range = LAZY_MOB_AMBUSH_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/skeleton_rockhill
	name = "lazy rockhill skeleton spawner"
	mob_type = /mob/living/carbon/human/species/skeleton/npc/rockhill
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/mirespider_angry
	name = "lazy angry mirespider spawner"
	mob_type = /mob/living/simple_animal/hostile/retaliate/rogue/mirespider/angry
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/spider_rock
	name = "lazy rock spider spawner"
	mob_type = /mob/living/simple_animal/hostile/retaliate/rogue/spider/rock
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/northern_bum_ambush
	name = "lazy northern bum ambush spawner"
	mob_type = /mob/living/carbon/human/species/human/northern/bum/ambush
	trigger_range = LAZY_MOB_AMBUSH_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/infernal_imp
	name = "lazy infernal imp spawner"
	mob_type = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/skeleton_cultist
	name = "lazy skeleton cultist spawner"
	mob_type = /mob/living/carbon/human/species/skeleton/npc/cultist
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE


/obj/effect/lazy_mob_spawner/wolf_undead
	name = "lazy undead wolf spawner"
	mob_type = /mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead
	trigger_range = LAZY_MOB_DEFAULT_TRIGGER_RANGE