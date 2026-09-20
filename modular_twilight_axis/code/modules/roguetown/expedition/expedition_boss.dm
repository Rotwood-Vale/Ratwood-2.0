GLOBAL_LIST_EMPTY(expedition_loot_spawners)
GLOBAL_LIST_EMPTY(boss_mineral_doors)


/obj/effect/mapping_helpers/secret_door_creator/Initialize(mapload)
	if(!isclosedturf(get_turf(src)))
		return ..()
	var/turf/closed/source_turf = get_turf(src)
	var/obj/structure/mineral_door/secret/new_door = new door_type(source_turf)

	new_door.name = source_turf.name
	new_door.desc = source_turf.desc
	new_door.icon = source_turf.icon
	new_door.icon_state = source_turf.icon_state

	if(boss_door_id)
		new_door.boss_door_id = boss_door_id
		GLOB.boss_mineral_doors |= new_door

	if(redstone_id)
		new_door.redstone_id = redstone_id
		GLOB.redstone_objs += new_door
		new_door.LateInitialize()

	if(override_floor || length(source_turf.baseturfs) < 1)
		source_turf.ChangeTurf(floor_turf)
	else
		source_turf.ChangeTurf(source_turf.baseturfs[1])

	return ..()

/obj/structure/mineral_door/secret/unlock_and_open()
	locked = FALSE
	force_open()
	visible_message(span_boldnotice("A hidden mechanism rumbles within the masonry, and the secret passage slides wide open!"))

/proc/open_linked_doors(target_door_id)
	if(!target_door_id)
		return
	var/found = FALSE
	for(var/obj/structure/mineral_door/D as anything in GLOB.boss_mineral_doors)
		if(D.boss_door_id == target_door_id)
			D.unlock_and_open()
			found = TRUE

	if(!found)
		log_game("\[BOSS DOOR\] No door with boss_door_id '[target_door_id]' was found in GLOB.boss_mineral_doors.")


/obj/effect/temp_visual/baroness_dying_expedition
	name = "Baroness"
	desc = "The corpse of the baroness. Seems she was mortal after all."
	layer = ABOVE_OPEN_TURF_LAYER
	icon = 'icons/mob/baroness.dmi'
	icon_state = "baronessdead"
	anchored = TRUE
	duration = 10
	randomdir = FALSE

/obj/effect/temp_visual/baroness_dying_expedition/Initialize(mapload)
	. = ..()
	visible_message(span_boldannounce("The Baroness' staff shatters and she crumples to the floor."))
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, say), "Mistress!...", null, list("colossus", "yell"))

/obj/effect/temp_visual/baroness_dying_expedition/Destroy()
	for(var/mob/M in range(7, src))
		shake_camera(M, 7, 1)
	var/turf/T = get_turf(src)
	playsound(T, 'sound/vo/female/gen/deathgurgle (1).ogg', 80, TRUE, TRUE)
	return ..()

/mob/living/simple_animal/hostile/boss/baroness/expedition
	loot = list(/obj/effect/temp_visual/baroness_dying_expedition)
	var/target_door_id = null

/mob/living/simple_animal/hostile/boss/baroness/expedition/death(gibbed)
	if(stat == DEAD)
		return

	if(target_door_id)
		open_linked_doors(target_door_id)

	return ..()


/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/expedition
	name = "void dragon"
	desc = "An ancient, terrifying creature of the abyss, guarding the forgotten halls."
	loot = list()
	var/target_door_id = null

/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/expedition/death(gibbed)
	var/turf/deathspot = get_turf(src)
	. = ..()
	if(deathspot)
		for(var/obj/item/clothing/ring/dragon_ring/R in deathspot)
			qdel(R)
		for(var/obj/item/book/granter/spell_points/voiddragon/B in deathspot)
			qdel(B)
		for(var/obj/item/roguekey/mage/dragon/K in deathspot)
			qdel(K)

		if(target_door_id)
			open_linked_doors(target_door_id)


/obj/effect/temp_visual/lich_dying_expedition
	name = "Lich"
	desc = ""
	layer = ABOVE_OPEN_TURF_LAYER
	icon = 'icons/mob/evilpope.dmi'
	icon_state = "popedeath"
	anchored = TRUE
	duration = 30
	randomdir = FALSE

/obj/effect/temp_visual/lich_dying_expedition/Initialize(mapload)
	. = ..()
	visible_message(span_boldannounce("The Archlich collapses into a pile of dust and bone, unholy energy dispersing into the air!"))
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, say), "Impossible!", null, list("colossus", "yell"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(trigger_boss_victory), get_turf(src)), 3 SECONDS)

/obj/effect/temp_visual/lich_dying_expedition/Destroy()
	for(var/mob/M in range(7, src))
		shake_camera(M, 7, 1)
	var/turf/T = get_turf(src)
	playsound(T, 'sound/vo/mobs/skel/skeleton_death (5).ogg', 80, TRUE, TRUE)
	new /obj/item/roguekey/mage/lich(T)
	return ..()

/mob/living/simple_animal/hostile/boss/lich/expedition
	loot = list(/obj/effect/temp_visual/lich_dying_expedition)

/mob/living/simple_animal/hostile/boss/lich/expedition/death(gibbed)
	if(stat == DEAD)
		return
	if(gibbed)
		new /obj/item/roguekey/mage/lich(get_turf(src))
		trigger_boss_victory(get_turf(src))
	return ..()


/proc/trigger_boss_victory(turf/death_turf)
	if(!death_turf)
		return

	var/turf/portal_turf = get_step(death_turf, NORTH) || death_turf
	new /obj/structure/expedition_gate/return_home(portal_turf)

	if(length(GLOB.expedition_loot_spawners))
		for(var/obj/effect/spawner/lootdrop/expedition/spawner in GLOB.expedition_loot_spawners.Copy())
			if(!QDELETED(spawner))
				spawner.trigger_loot()
		GLOB.expedition_loot_spawners.Cut()

	for(var/mob/living/carbon/human/crusader in GLOB.expedition_party)
		if(!QDELETED(crusader))
			to_chat(crusader, "<h2 style='color: gold;'>VICTORY! The Archlich has been vanquished! Claim your spoils and assemble at the triumphant gateway!</h2>")
			playsound(crusader, 'sound/misc/bell.ogg', 80, FALSE)


/obj/effect/spawner/lootdrop/expedition
	name = "expedition boss reward spawner"
	desc = "Spawns glorious expedition rewards when the guardian is defeated."
	icon = 'icons/roguetown/helpers/spawnerhelpers.dmi'
	icon_state = "cot"
	layer = OBJ_LAYER
	
	lootcount = 4
	lootdoubles = FALSE
	fan_out_items = TRUE
	invisibility = INVISIBILITY_OBSERVER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/list/loot_weapons = list(
		/obj/item/rogueweapon/fishspear/depthseek = 30,
		/obj/item/rogueweapon/halberd/capglaive = 15,
		/obj/item/rogueweapon/sword/long/exe/berserk = 20,
		/obj/item/rogueweapon/sword/long/exe/berserk/dragonslayer = 20
	)

	var/list/loot_wealth = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich = 40,
		/obj/item/clothing/ring/statdorpel = 50,
		/obj/item/clothing/ring/dragon_ring = 50
	)

/obj/effect/spawner/lootdrop/expedition/Initialize(mapload)
	..()
	GLOB.expedition_loot_spawners += src
	return null

/obj/effect/spawner/lootdrop/expedition/Destroy()
	GLOB.expedition_loot_spawners -= src
	return ..()

/obj/effect/spawner/lootdrop/expedition/proc/trigger_loot()
	switch(GLOB.expedition_goal)
		if("Weapons of Legend")
			loot = loot_weapons.Copy()
		if("Lost Wealth")
			loot = loot_wealth.Copy()
		else
			loot = loot_wealth.Copy()

	if(loot && loot.len)
		var/turf/T = loc
		var/loot_spawned = 0
		while((lootcount - loot_spawned) && loot.len)
			var/lootspawn = pickweight(loot)
			while(islist(lootspawn))
				lootspawn = pickweight(lootspawn)
			if(!lootdoubles)
				loot.Remove(lootspawn)

			if(lootspawn)
				var/atom/movable/spawned_loot = new lootspawn(T)
				if(!fan_out_items)
					if(pixel_x != 0)
						spawned_loot.pixel_x = pixel_x
					if(pixel_y != 0)
						spawned_loot.pixel_y = pixel_y
				else
					if(loot_spawned)
						spawned_loot.pixel_x = spawned_loot.pixel_y = ((!(loot_spawned % 2) * loot_spawned / 2) * -1) + ((loot_spawned % 2) * (loot_spawned + 1) / 2 * 1)
			loot_spawned++

	qdel(src)
