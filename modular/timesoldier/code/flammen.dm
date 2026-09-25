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
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	nondirectional_sprite = TRUE
	damage = 10
	damage_type = BURN
	armor_penetration = 0
	range = 5
	speed = 0.8

/obj/effect/hotspot/timesoldier_fire/proc/start_scorcher_spread(radius = 1)
	spread_origin = get_turf(src)
	if(!spread_origin)
		return

	max_spread_radius = radius
	spread_radius = 1

	addtimer(CALLBACK(src, PROC_REF(spread_next_ring)), 2)

/obj/projectile/bullet/firearm/timesoldier_fire/proc/create_scorcher_fire(atom/target)
	var/turf/T = get_turf(target)
	if(!T)
		return

	var/obj/effect/hotspot/timesoldier_fire/F = locate(/obj/effect/hotspot/timesoldier_fire) in T

	if(!F)
		F = new /obj/effect/hotspot/timesoldier_fire(T)

	if(!F.spread_origin)
		F.start_scorcher_spread(1)


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

/obj/projectile/bullet/firearm/timesoldier_fire/on_hit(atom/target, blocked = FALSE)
	. = ..()

	create_scorcher_fire(target)

	if(isliving(target))
		var/mob/living/L = target
		L.adjust_fire_stacks(40)
		L.ignite_mob()
		L.apply_status_effect(/datum/status_effect/debuff/timesoldier_scorcher_agony)

/obj/projectile/bullet/firearm/timesoldier_fire/Destroy()
	if(fired)
		create_scorcher_fire(get_turf(src))

	return ..()

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
	dropshrink = 0.6
	pixel_x = -16
	pixel_y = -16
	bigboy = TRUE
	mag_type = /obj/item/ammo_box/magazine/timesoldier_fire
	internal_magazine = TRUE
	semi_auto = TRUE
	automatic = 0
	canMouseDown = TRUE
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(
		/datum/intent/shoot/firearm,
		/datum/intent/arc/firearm,
		INTENT_GENERIC
	)

	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	recoil = 0
	var/flamesprayer_firing = FALSE
	var/atom/flamesprayer_target
	var/mob/living/flamesprayer_user

/datum/status_effect/debuff/timesoldier_scorcher_agony
	id = "timesoldier_scorcher_agony"
	duration = 12 SECONDS
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/status_effect/debuff/timesoldier_scorcher_agony/on_apply()
	. = ..()

	if(owner.stat == CONSCIOUS && !HAS_TRAIT(owner, TRAIT_NOPAIN))
		owner.emote("firescream", forced = TRUE)

	return TRUE

/datum/status_effect/debuff/timesoldier_scorcher_agony/tick()
	if(!owner || owner.stat != CONSCIOUS)
		return

	if(HAS_TRAIT(owner, TRAIT_NOPAIN))
		return

	if(owner.fire_stacks <= 0)
		qdel(src)
		return

	owner.emote("firescream", forced = TRUE)



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


/obj/item/gun/ballistic/timesoldier_fire_wep/onMouseDown(object, location, params, mob/user)
	if(!isliving(user))
		return

	var/mob/living/L = user

	if(!wielded)
		return

	flamesprayer_firing = TRUE
	flamesprayer_target = object
	flamesprayer_user = L

	// pevent the normal click-on-release from firing an extra shot
	if(L.client)
		L.client.tcompare = null

	addtimer(CALLBACK(src, PROC_REF(flamesprayer_fire_loop)), 1)

/obj/item/gun/ballistic/timesoldier_fire_wep/onMouseDrag(src_object, over_object, src_location, over_location, params, mob/user)
	if(!flamesprayer_firing)
		return

	if(over_object)
		flamesprayer_target = over_object

/obj/item/gun/ballistic/timesoldier_fire_wep/onMouseUp(object, location, params, mob/user)
	stop_flamesprayer()

/obj/item/gun/ballistic/timesoldier_fire_wep/proc/stop_flamesprayer()
	flamesprayer_firing = FALSE
	flamesprayer_target = null
	flamesprayer_user = null

/obj/item/gun/ballistic/timesoldier_fire_wep/proc/flamesprayer_fire_loop()
	if(!flamesprayer_firing)
		return

	var/mob/living/L = flamesprayer_user

	if(!L || QDELETED(L))
		stop_flamesprayer()
		return

	if(L.incapacitated())
		stop_flamesprayer()
		return

	if(L.get_active_held_item() != src)
		stop_flamesprayer()
		return

	if(!wielded)
		stop_flamesprayer()
		return

	if(!flamesprayer_target || QDELETED(flamesprayer_target))
		stop_flamesprayer()
		return

	if(!can_trigger_gun(L))
		stop_flamesprayer()
		return

	if(!can_shoot())
		shoot_with_empty_chamber(L)
		stop_flamesprayer()
		return

	process_fire(
		flamesprayer_target,
		L,
		TRUE,
		null,
		"",
		0
	)

	if(flamesprayer_firing)
		addtimer(CALLBACK(src, PROC_REF(flamesprayer_fire_loop)), 2)
