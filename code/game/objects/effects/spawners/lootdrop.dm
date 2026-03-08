/obj/effect/spawner/lootdrop
	icon = 'icons/helpers/spawnerhelpers.dmi'
	icon_state = "cot"
	layer = OBJ_LAYER
	//how many items will be spawned
	var/lootcount = 1
	//if the same item can be spawned twice
	var/lootdoubles = TRUE
	//a list of possible items to spawn e.g. list(/obj/item, /obj/structure, /obj/effect)
	var/list/loot
	//Whether the items should be distributed to offsets 0,1,-1,2,-2,3,-3.. This overrides pixel_x/y on the spawner itself
	var/fan_out_items = TRUE
	var/probby = 100
	var/list/spawned

/obj/effect/spawner/lootdrop/Initialize(mapload)
	..()
	if(loot && loot.len)
		var/turf/T = loc
		var/loot_spawned = 0
		while((lootcount-loot_spawned) && loot.len)
			var/lootspawn = pickweight(loot)
			while(islist(lootspawn))
				lootspawn = pickweight(lootspawn)
			if(!lootdoubles)
				loot.Remove(lootspawn)

			if(lootspawn)
				var/atom/movable/spawned_loot = new lootspawn(T)
				if (!fan_out_items)
					if (pixel_x != 0)
						spawned_loot.pixel_x = pixel_x
					if (pixel_y != 0)
						spawned_loot.pixel_y = pixel_y
				else
					if (loot_spawned)
						spawned_loot.pixel_x = spawned_loot.pixel_y = ((!(loot_spawned%2)*loot_spawned/2)*-1)+((loot_spawned%2)*(loot_spawned+1)/2*1)
			loot_spawned++
		do_spawn()
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/lootdrop/proc/do_spawn()
	if(prob(probby))
		if(!spawned)
			return
		var/obj/new_type = pick(spawned)
		new new_type(get_turf(src))
