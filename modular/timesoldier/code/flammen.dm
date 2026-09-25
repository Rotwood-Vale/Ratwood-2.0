/obj/effect/hotspot/timesoldier_fire
	name = "scorching fire"
	desc = "A roaring, clinging flame."
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"

	life = 20
	firelevel = 3

	var/spread_radius = 0
	var/max_spread_radius = 0
	var/turf/spread_origin

/obj/effect/hotspot/timesoldier_fire/process()
	. = ..()

	if(QDELETED(src))
		return
	
	icon_state = "3"

/obj/effect/hotspot/timesoldier_fire/handle_automatic_spread()
	return


/obj/projectile/bullet/firearm/timesoldier_fire
	name = "incendiary stream"
	desc = "Best get out of the way!"
	damage = 10
	damage_type = BURN
	armor_penetration = 0
	range = 5

/obj/effect/hotspot/timesoldier_fire/proc/start_scorcher_spread(radius = 3)
	spread_origin = get_turf(src)
	if(!spread_origin)
		return

	max_spread_radius = radius
	spread_radius = 1

	addtimer(CALLBACK(src, PROC_REF(spread_next_ring)), 2)


/obj/effect/hotspot/timesoldier_fire/proc/spread_next_ring()
	if(QDELETED(src))
		return

	if(!spread_origin)
		return

	if(spread_radius > max_spread_radius)
		return

	var/list/current_ring = circle_range_turfs(spread_origin, spread_radius)

	if(spread_radius > 1)
		var/list/previous_ring = circle_range_turfs(spread_origin, spread_radius - 1)
		current_ring -= previous_ring
	else
		current_ring -= spread_origin

	for(var/turf/T as anything in current_ring)
		if(T.density)
			continue

		if(!is_in_sight(spread_origin, T))
			continue

		if(locate(/obj/effect/hotspot/timesoldier_fire) in T)
			continue

		new /obj/effect/hotspot/timesoldier_fire(T)

	spread_radius++

	if(spread_radius <= max_spread_radius)
		addtimer(CALLBACK(src, PROC_REF(spread_next_ring)), 2)

/obj/projectile/bullet/firearm/timesoldier_fire/on_hit(atom/target, blocked=FALSE)
	. = ..()

	var/turf/T = get_turf(target)
	if(T && !locate(/obj/effect/hotspot/timesoldier_fire) in T)
		new /obj/effect/hotspot/timesoldier_fire(T)

	if(isliving(target))
		var/mob/living/L = target
		L.adjust_fire_stacks(40)
		L.ignite_mob()


/obj/item/ammo_casing/timesoldier_fire
	name = "incendiary fuel charge"
	desc = "you shouldn't be seeing this i dont think"
	icon_state = null
	caliber = "scorcher"
	projectile_type = /obj/projectile/bullet/firearm/timesoldier_fire

/obj/item/ammo_box/magazine/timesoldier_fire
	name = "Flamesprayer Fuel Tank"
	desc = "Technically you shouldn't be seeing this either but this might be a by-product of admin stuff."
	icon_state = null
	ammo_type = /obj/item/ammo_casing/timesoldier_fire
	max_ammo = 500


/obj/item/gun/ballistic/timesoldier_fire_wep
	name = "flamesprayer"
	desc = "<span class='yellow'><i>Nothing short of liquid brutality, the flamesprayer belonged to a gang of troublemakers called 'The Scum', but they decided to serve the Crown by giving us the schematic for this.</i></span>"
	icon = 'modular/timesoldier/sprites/scumguns.dmi'
	icon_state = "flamesprayer"
	item_state = "flamesprayer_inhand"
	lefthand_file = 'modular/timesoldier/sprites/scumguns.dmi'
	righthand_file = 'modular/timesoldier/sprites/scumguns.dmi'
	experimental_inhand = FALSE
	mag_type = /obj/item/ammo_box/magazine/timesoldier_fire
	internal_magazine = TRUE
	semi_auto = TRUE
	automatic = 2
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(
		/datum/intent/shoot/firearm,
		/datum/intent/arc/firearm,
		INTENT_GENERIC
	)

	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	recoil = 0


/obj/item/gun/ballistic/timesoldier_fire_wep/attack_self(mob/living/user)
	if(wielded)
		ungrip(user)
		return

	wield(user)

/obj/item/gun/ballistic/timesoldier_fire_wep/can_shoot()
	if(!wielded)
		return FALSE

	return ..()

/obj/item/gun/ballistic/timesoldier_fire_wep/shoot_with_empty_chamber(mob/living/user as mob|obj)
	if(!wielded)
		to_chat(user, span_warning("I need to brace [src] with both hands before firing it.")) // it would be so cool holding the flamesprayer in one hand and then a bottle of beer in the other. metal.
		return

	return ..()

/obj/item/gun/ballistic/timesoldier_fire_wep/process_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	if(chambered)
		qdel(chambered)
		chambered = null

	if(chamber_next_round && magazine?.ammo_count())
		chamber_round()
