// Admin-spawnable test guns for the beam projectiles in beams.dm.
// Self-recharging so they need no ammo boxes or magazines - spawn one, pick the ranged intent, fire.

/obj/item/gun/energy_beam
	name = "beam emitter"
	desc = ""
	icon = 'icons/obj/guns/energy.dmi'
	icon_state = "laser"
	item_state = "gun"
	fire_sound = 'sound/magic/obeliskbeam.ogg'
	fire_sound_volume = 60
	vary_fire_sound = FALSE
	dry_fire_sound = 'sound/magic/magic_nulled.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	/// Casing spawned into the chamber and refilled after every shot.
	var/casing_type = /obj/item/ammo_casing/energy_beam
	/// Deciseconds before the chamber refills.
	var/recharge_time = 8
	/// Icon state shown while the chamber is empty.
	var/empty_state = "laser_empty"
	var/recharging = FALSE

/obj/item/gun/energy_beam/Initialize(mapload)
	. = ..()
	chambered = new casing_type(src)
	update_icon()

/obj/item/gun/energy_beam/can_shoot()
	return chambered?.BB

/obj/item/gun/energy_beam/process_chamber()
	if(recharging || !chambered)
		return FALSE
	recharging = TRUE
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(finish_recharge)), recharge_time)
	return TRUE

/obj/item/gun/energy_beam/proc/finish_recharge()
	recharging = FALSE
	chambered?.newshot()
	update_icon()

/obj/item/gun/energy_beam/update_icon()
	icon_state = chambered?.BB ? initial(icon_state) : empty_state
	return ..()

/obj/item/ammo_casing/energy_beam
	name = "beam lens"
	desc = ""
	icon_state = "s-casing"
	caliber = "beam"
	projectile_type = /obj/projectile/beam/laser
	heavy_metal = FALSE

// ---------------------------------------------------------------------------
// Concrete test guns, one per beam family. Hitscan variants resolve their whole
// path on fire and leave a tracer, so they are the ones to look at for tracer,
// muzzle flash and impact flash behaviour.
// ---------------------------------------------------------------------------

/obj/item/gun/energy_beam/laser
	name = "laser gun"
	casing_type = /obj/item/ammo_casing/energy_beam

/obj/item/gun/energy_beam/laser/hitscan
	name = "laser gun (hitscan)"
	icon_state = "retro"
	empty_state = "retro_empty"
	casing_type = /obj/item/ammo_casing/energy_beam/hitscan

/obj/item/ammo_casing/energy_beam/hitscan
	projectile_type = /obj/projectile/beam/laser/hitscan

/obj/item/gun/energy_beam/cannon
	name = "heavy laser cannon"
	icon_state = "lasercannon"
	empty_state = "lasercannon_empty"
	recharge_time = 20
	casing_type = /obj/item/ammo_casing/energy_beam/heavy

/obj/item/ammo_casing/energy_beam/heavy
	projectile_type = /obj/projectile/beam/laser/heavy/hitscan

/obj/item/gun/energy_beam/xray
	name = "\improper X-ray gun"
	icon_state = "xray"
	empty_state = "xray_empty"
	recharge_time = 12
	casing_type = /obj/item/ammo_casing/energy_beam/xray

/obj/item/ammo_casing/energy_beam/xray
	projectile_type = /obj/projectile/beam/xray/hitscan

/obj/item/gun/energy_beam/disabler
	name = "disabler"
	icon_state = "taser"
	empty_state = "taser_empty"
	fire_sound = 'sound/magic/heraldzap.ogg'
	recharge_time = 6
	casing_type = /obj/item/ammo_casing/energy_beam/disabler

/obj/item/ammo_casing/energy_beam/disabler
	projectile_type = /obj/projectile/beam/disabler
	harmful = FALSE

/obj/item/gun/energy_beam/pulse
	name = "pulse rifle"
	icon_state = "pulse"
	empty_state = "pulse_empty"
	recharge_time = 16
	casing_type = /obj/item/ammo_casing/energy_beam/pulse

/obj/item/ammo_casing/energy_beam/pulse
	projectile_type = /obj/projectile/beam/pulse/hitscan

/// Damage and sprite scale climb with distance, so fire it down a long corridor.
/obj/item/gun/energy_beam/accelerator
	name = "laser accelerator"
	icon_state = "caplaser"
	empty_state = "caplaser_empty"
	recharge_time = 14
	casing_type = /obj/item/ammo_casing/energy_beam/accelerator

/obj/item/ammo_casing/energy_beam/accelerator
	projectile_type = /obj/projectile/beam/laser/accelerator
