/obj/item/storage/backpack/rogue/satchel/short/timesoldier_ifak
	name = "individiual aid satchel"
	desc = "<span class='yellow'><i>Whenever crates of this stuff came around, we knew we'd have to start digging into our own wounds that following dae. Doubles as a small satchel, too.</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	icon_state = "ifak" // ditto as above

/obj/item/reagent_containers/glass/bottle/waterskin/timesoldier
	name = "iron canteen"
	desc = "Also known as the Soldier's Drink, it's commonly used by the Grenzelhoft Military in long expeditions. How did it end up here, though?"

	volume = 225
	list_reagents = list(
		/datum/reagent/water = 200,
		/datum/reagent/consumable/ethanol/gin = 25)


// GRENAAAAADEEEEEE

// fragmentation

/obj/projectile/bullet/timesoldier_shrapnel
	name = "shrapnel fragment"
	desc = "A jagged piece of violently propelled metal."

	damage = 55
	damage_type = BRUTE
	armor_penetration = 20

	hitscan = FALSE
	range = 7

	// use piercing armor protection, but produce cutting wounds.
	flag = "piercing"
	woundclass = BCLASS_CUT

	// makes already badly damaged limbs much easier to sever.
	dismemberment = 20

	// da fragment originates on top of da grenade,
	// so don't let its source interfere with collision.
	ignore_source_check = TRUE


// shrapnel burst pretty much copy pasted from temp13

/proc/timesoldier_shrapnel_burst(atom/origin, radius = 6)
	if(!origin)
		return

	var/turf/origin_turf = get_turf(origin)
	if(!origin_turf)
		return

	// get only the outer ring of the radius.
	// each turf along this ring becomes one direction for a fragment.
	var/list/outer_ring = circle_range_turfs(origin_turf, radius)

	if(radius > 1)
		outer_ring -= circle_range_turfs(origin_turf, radius - 1)

	for(var/turf/target_turf as anything in outer_ring)
		var/obj/projectile/bullet/timesoldier_shrapnel/P = new(origin_turf)

		// shrapnel should only travel about as far as the burst itself.
		P.range = radius + 1

		P.def_zone = pick(
			BODY_ZONE_L_LEG,
			BODY_ZONE_R_LEG,
			BODY_ZONE_CHEST,
			BODY_ZONE_HEAD,
			BODY_ZONE_L_ARM,
			BODY_ZONE_R_ARM)

		P.preparePixelProjectile(target_turf, origin)
		P.firer = origin
		P.fire()

// hey guys watch what happens when i toss this live grenade under a pain stunned peasant

/proc/timesoldier_pointblank_shrapnel(mob/living/victim, atom/source, fragment_count = 8)
	if(!victim || !source)
		return

	for(var/i in 1 to fragment_count)
		var/obj/projectile/bullet/timesoldier_shrapnel/P = new(get_turf(victim))

		P.firer = source

		P.def_zone = pick(
			BODY_ZONE_L_LEG,
			BODY_ZONE_R_LEG,
			BODY_ZONE_CHEST,
			BODY_ZONE_HEAD,
			BODY_ZONE_L_ARM,
			BODY_ZONE_R_ARM)

		// let Ratwood handle armor, damage, wounds and dismemberment normally.
		victim.bullet_act(P, P.def_zone)

		if(!QDELETED(P))
			qdel(P)


// STIELHANDGRANATE

/obj/item/timesoldier/grenade/stick
	name = "Stielhandgranate"
	desc = "A Grenzelhoftian marvel. It was invented to replace the impact grenade most would know in this time, this is a lot more deadly."

	icon = 'modular/timesoldier/sprites/nu_guns.dmi'
	icon_state = "sticknade"

	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 32
	grid_height = 64

	throw_range = 7
	throw_speed = 0.5
	throwforce = 5

	var/fuze = 4 SECONDS
	var/armed = FALSE
	var/detonation_time


/obj/item/timesoldier/grenade/stick/attack_self(mob/user)
	. = ..()

	if(armed)
		to_chat(user, span_warning("[src] is already armed!"))
		return

	arm(user)


/obj/item/timesoldier/grenade/stick/proc/arm(mob/user)
	if(armed)
		return

	armed = TRUE
	icon_state = "sticknade_active"

	detonation_time = world.time + fuze

	visible_message(
		span_warning("[user] arms [src]!"),
		span_userdanger("I arm [src]!")
	)

	playsound(src, pick(
		'modular/timesoldier/sounds/wepons/pin1.ogg',
		'modular/timesoldier/sounds/wepons/pin2.ogg'), 80, FALSE)

	START_PROCESSING(SSfastprocess, src)

	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()


/obj/item/timesoldier/grenade/stick/process()
	if(!armed)
		STOP_PROCESSING(SSfastprocess, src)
		return

	if(world.time >= detonation_time)
		detonate()


/obj/item/timesoldier/grenade/stick/ex_act()
	if(QDELETED(src))
		return

	detonate()


/obj/item/timesoldier/grenade/stick/proc/detonate()
	if(QDELETED(src))
		return

	STOP_PROCESSING(SSfastprocess, src)

	var/turf/T = get_turf(src)
	if(!T)
		qdel(src)
		return

	visible_message(span_danger("[src] explodes!"))

	// anyone directly on top of the grenade is uhhhhh....probably fucked.
	for(var/mob/living/L in T)
		timesoldier_pointblank_shrapnel(L, src, 16)

	// send the rest of the fragments out into the surrounding area.
	timesoldier_shrapnel_burst(src, 6)

	// the explosive charge itself is intentionally small.
	// the fragmentation is supposed to do most of the killing.
	explosion(
		T,
		devastation_range = 0,
		heavy_impact_range = 1,
		light_impact_range = 1,
		flash_range = 0,
		smoke = FALSE,
		soundin = pick(
			'modular/timesoldier/sounds/wepons/arty1.ogg',
			'modular/timesoldier/sounds/wepons/arty2.ogg',
			'modular/timesoldier/sounds/wepons/arty3.ogg')
	)

	qdel(src)
