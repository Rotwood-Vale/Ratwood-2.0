/mob/living/simple_animal/hostile/retaliate/rogue/drider //lol
	icon = 'icons/roguetown/mob/monster/drider.dmi'
	name = "drider spider"
	desc = ""
	pixel_x = -2
	pixel_y = 7
	faction = list("spider_lowers")
	gender = MALE
	icon_state = "drider"
	icon_living = "drider"
	icon_dead = "drider_dead"
	animal_species = null
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 3, /obj/item/natural/bone = 3)
	base_intents = list(/datum/intent/simple/bite/mirespider_lurker)
	health = 660
	maxHealth = 660
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	milkies = FALSE
	melee_damage_lower = 60
	melee_damage_upper = 90
	retreat_distance = 0
	minimum_distance = 0
	retreat_health = 0.3
	STASPD = 18
	STACON = 8
	STASTR = 10
	tame = FALSE
	food_type = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat,
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten,
		/obj/item/organ,
		/obj/item/reagent_containers/food/snacks/rogue/truffles,
		/obj/item/reagent_containers/food/snacks/grown/apple,
	)
	tame_chance = 5
	bonus_tame_chance = 5
	can_saddle = TRUE
	can_buckle = TRUE
	aggressive = 1
	move_to_delay = 8

/mob/living/simple_animal/hostile/retaliate/rogue/drider/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/drider/Initialize(mapload)
	. = ..()
	food_typecache -= typesof(/obj/item/organ/brain)//no round removing someone with your spider
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE2, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFIRE, TRAIT_GENERIC)
	bbarding = new /obj/item/clothing/barding/drider(src)

/mob/living/simple_animal/hostile/retaliate/rogue/drider/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		if(ssaddle)
			var/mutable_appearance/saddlet = mutable_appearance(icon, "saddle-above", 4.3)
			add_overlay(saddlet)
			saddlet = mutable_appearance(icon, "saddle")
			add_overlay(saddlet)
		if(has_buckled_mobs())
			var/mutable_appearance/mounted = mutable_appearance(icon, "drider_mounted", 4.3)
			add_overlay(mounted)

/mob/living/simple_animal/hostile/retaliate/rogue/drider/tamed()
	..()
	deaggroprob = 20
	if(can_buckle)
		var/datum/component/riding/D = LoadComponent(/datum/component/riding)
		D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 9), TEXT_SOUTH = list(0, 9), TEXT_EAST = list(-1, 9), TEXT_WEST = list(-1, 9)))
		D.set_riding_offsets(2, list(TEXT_NORTH = list(0, 1), TEXT_SOUTH = list(0, 17), TEXT_EAST = list(-9, 9), TEXT_WEST = list(7, 9)))
		D.set_vehicle_dir_layer(NORTH, MOB_LAYER+0.5)
		D.set_vehicle_dir_layer(SOUTH, OBJ_LAYER)
		D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
		D.set_vehicle_dir_layer(WEST, OBJ_LAYER)

/mob/living/simple_animal/hostile/retaliate/rogue/drider/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/spider/aggro (1).ogg','sound/vo/mobs/spider/aggro (2).ogg','sound/vo/mobs/spider/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/spider/pain.ogg')
		if("death")
			return pick('sound/vo/mobs/spider/death.ogg')
		if("idle")
			return pick('sound/vo/mobs/spider/idle (1).ogg','sound/vo/mobs/spider/idle (2).ogg','sound/vo/mobs/spider/idle (3).ogg','sound/vo/mobs/spider/idle (4).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/drider/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/drider/eat_plants()
	..()
	var/obj/structure/vine/SV = locate(/obj/structure/vine) in loc
	if(SV)
		SV.eat(src)
		food = max(food + 30, 100)

/mob/living/simple_animal/hostile/retaliate/rogue/drider/Life()
	..()
	if(stat == CONSCIOUS)
		if(!pulledby)
			for(var/direction in shuffle(list(1,2,4,8,5,6,9,10)))
				var/step = get_step(src, direction)
				if(step)
					if(locate(/obj/structure/vine) in step || locate(/obj/structure/glowshroom) in step)
						Move(step, get_dir(src, step))
	if(stat != DEAD)
		if(has_buckled_mobs())
			icon_state = "drider_mounted"
			icon_living = "drider_mounted"
		else
			icon_state = "drider"
			icon_living = "drider"

/mob/living/simple_animal/hostile/retaliate/rogue/drider/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "snout"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "snout"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/drider/tame/saddled/Initialize(mapload)
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()
/// Handles driders climbing up z-levels. Prior to this, they were uniquely able to fall down Z-levels without taking damage, i.e. climbing down.
/mob/living/simple_animal/hostile/retaliate/rogue/drider/proc/can_climb_with(mob/living/rider)
	if(QDELETED(rider) || !tame || anchored || incapacitated() || IsImmobilized() || !(mobility_flags & MOBILITY_MOVE))
		return FALSE
	if(rider.buckled != src || rider.loc != loc || rider.incapacitated() || rider.IsImmobilized())
		return FALSE
	var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding)
	return riding_datum && riding_datum.driver == rider

/mob/living/simple_animal/hostile/retaliate/rogue/drider/proc/get_climb_target(turf/closed/wall)
	if(!isturf(loc) || QDELETED(wall) || !wall.wallclimb || wall.z != z || get_dist(src, wall) != 1)
		return null
	if(!(get_dir(src, wall) in GLOB.cardinals))
		return null
	var/turf/open/transparent/openspace/opening = get_step_multiz(src, UP)
	if(!istype(opening) || !can_zTravel(opening, UP))
		return null
	var/turf/open/landing = get_step_multiz(wall, UP)
	if(!istype(landing) || istype(landing, /turf/open/transparent/openspace))
		return null
	if(!opening.CanPass(src, landing) || !landing.CanPass(src, opening))
		return null
	for(var/atom/movable/blocker in opening)
		if(!blocker.CanPass(src, landing))
			return null
	for(var/atom/movable/blocker in landing)
		if(!blocker.CanPass(src, opening))
			return null
	return landing

/mob/living/simple_animal/hostile/retaliate/rogue/drider/proc/climb_terrain(turf/closed/wall, mob/living/rider)
	if(!can_climb_with(rider))
		return FALSE
	var/turf/start = get_turf(src)
	var/turf/landing = get_climb_target(wall)
	if(!landing)
		to_chat(rider, span_warning("My drider cannot find a clear ledge to climb onto here."))
		return FALSE
	rider.visible_message(span_notice("[rider] guides [src] up [wall]..."), span_notice("I guide [src] up [wall]..."))
	if(!do_after(rider, 2 SECONDS, needhand = FALSE, target = src, extra_checks = CALLBACK(src, PROC_REF(can_climb_with), rider)))
		return FALSE
	if(QDELETED(src) || !can_climb_with(rider) || loc != start || get_climb_target(wall) != landing)
		return FALSE
	setDir(get_dir(src, wall))
	// The hostile animal forceMove override brings all buckled passengers along.
	if(!forceMove(landing))
		return FALSE
	var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding)
	riding_datum.last_vehicle_move = world.time
	playsound(src, 'sound/foley/climb.ogg', 100, TRUE)
	return TRUE
