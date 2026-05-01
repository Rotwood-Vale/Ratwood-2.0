/*
	UNDERBELLY EXCLUSIVE WEAPONS
	Four weapons unique to the Criminal Underbelly. Not sold anywhere else.
	Gut Spiller - compact close-range firearm, the Gutter King's signature.
	Abomination  - double-shot volleygun with mordhau grip and axe slot.
	Devastator   - heavy long-arm, devastating but ponderous.
	Defacer      - spiked steel knuckles, hits harder but breaks faster.
*/

// =====================================================
// GUT SPILLER - compact pistol, short range carnage
// purchase_sound_key = "smallgun"
// Pepperbox-style: six pre-loaded chambers, no ramrod between shots.
// =====================================================
/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller
	name = "Ironshot Repeater mark 1"
	desc = "A sophisticated and upgraded repeating arquebus pistol designed by Ser Ironshot, with a modified internal body to hold three lead spheres. <br> This is clearly a cheaper copy, which likes to jam."
	icon = 'modular_underbelly/sprites/scumguns.dmi'
	icon_state = "repeating_pistol"
	lefthand_file = 'modular_underbelly/sprites/scumguns.dmi'
	righthand_file = 'modular_underbelly/sprites/scumguns.dmi'
	item_state = "repeating_pistol"
	force = 14
	spread = 6
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	var/rounds_remaining = 2
	var/pending_rounds = 0
	/// Set when the firing mechanism jams. Cleared by right-clicking to fix it.
	var/jammed = FALSE

/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_ADDED, PROC_REF(block_blood_decal))
	chambered = new /obj/item/ammo_casing/caseless/bullet/lead(src)
	reloaded = TRUE
	gunpowder = TRUE
	transform = matrix().Scale(0.5, 0.5)

/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller/proc/block_blood_decal(datum/source, datum/component/C)
	SIGNAL_HANDLER
	if(istype(C, /datum/component/decal/blood))
		qdel(C)

/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/quiver/bullet/lead))
		var/obj/item/quiver/bullet/lead/Q = A
		var/mob/living/carbon/human/H = user
		if(!istype(H) || H.job != "Scum")
			to_chat(user, span_warning("Only Scum know how to spin-load the [src]."))
			return
		if(!gunpowder)
			to_chat(user, span_warning("You must fill the [src] with smokepowder first!"))
			return
		var/free_rounds = 3 - (pending_rounds + rounds_remaining + (chambered ? 1 : 0))
		if(free_rounds <= 0)
			to_chat(user, span_warning("The [src]'s cylinder is already full!"))
			return
		if(!length(Q.arrows))
			to_chat(user, span_warning("There are no lead balls left in [Q]."))
			return
		var/firearm_skill = user.get_skill_level(/datum/skill/combat/firearms)
		user.visible_message(span_notice("[user] flicks [src] into a spin and starts feeding the cylinder from [Q]."))
		playsound(src, 'modular_helmsguard/sound/arquebus/gunspin.ogg', 80, TRUE)
		if(do_after(user, max(10, load_time - (firearm_skill * 2)), src))
			var/loaded = 0
			while(loaded < free_rounds && length(Q.arrows))
				var/obj/item/ammo_casing/caseless/bullet/lead/shot = Q.arrows[Q.arrows.len]
				Q.arrows -= shot
				qdel(shot)
				loaded++
			if(!loaded)
				to_chat(user, span_warning("There are no lead balls left in [Q]."))
				return
			loaded += pending_rounds
			if(chambered)
				rounds_remaining += loaded
			else
				rounds_remaining = loaded - 1
				chambered = new /obj/item/ammo_casing/caseless/bullet/lead(src)
			pending_rounds = 0
			Q.update_icon()
			reloaded = TRUE
			gunpowder = TRUE
			user.visible_message(span_notice("[user] snaps the [src] shut, fully stuffed with lead."))
		return
	if(istype(A, /obj/item/ammo_casing))
		if(!istype(A, /obj/item/ammo_casing/caseless/bullet/lead))
			to_chat(user, span_warning("The [src] only fires lead balls."))
			return
		if(!gunpowder)
			to_chat(user, span_warning("You must fill the [src] with smokepowder first!"))
			return
		if(pending_rounds + rounds_remaining + (chambered ? 1 : 0) >= 3)
			to_chat(user, span_warning("The [src]'s cylinder is already full!"))
			return
		playsound(src, "modular_helmsguard/sound/arquebus/insert.ogg", 100)
		user.visible_message(span_notice("[user] drops a lead ball into the cylinder of [src]."))
		pending_rounds++
		qdel(A)
		return
	if(istype(A, /obj/item/ramrod) && pending_rounds > 0)
		var/obj/item/ramrod/R = A
		var/firearm_skill = user.get_skill_level(/datum/skill/combat/firearms)
		user.visible_message(span_notice("[user] begins loading the [R.name] into [src]."))
		playsound(src, "modular_helmsguard/sound/arquebus/ramrod.ogg", 100)
		if(do_after(user, load_time - (firearm_skill * 2), src))
			user.visible_message(span_notice("[user] finishes loading the [src]."))
			if(chambered)
				rounds_remaining += pending_rounds
			else
				rounds_remaining = pending_rounds - 1
				chambered = new /obj/item/ammo_casing/caseless/bullet/lead(src)
			pending_rounds = 0
			reloaded = TRUE
		return
	return ..()

/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller/can_shoot()
	if(!chambered)
		return FALSE
	if(jammed)
		return FALSE
	return TRUE

/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller/shoot_live_shot(mob/living/user, pointblank = 0, mob/pbtarget = null, message = 1)
	// Misfire chance: base 15%, reduced by 1% per luck point above 10, floored at 3%.
	var/misfire_chance = clamp(15 - (user.STALUC - 10), 3, 15)
	if(prob(misfire_chance))
		jammed = TRUE
		playsound(user, 'modular_helmsguard/sound/arquebus/musketcock.ogg', 60, FALSE)
		user.visible_message(span_warning("[user]'s [src] clicks - it's jammed!"), span_warning("The [src] jams! Right-click it to clear the mechanism."))
		return
	return ..()

/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller/attack_right(mob/user)
	if(!jammed)
		return ..()
	var/firearm_skill = user.get_skill_level(/datum/skill/combat/firearms)
	var/fix_time = clamp(40 - firearm_skill * 6, 15, 40)
	user.visible_message(span_notice("[user] works at clearing the jam in [src]..."))
	playsound(src, "modular_helmsguard/sound/arquebus/ramrod.ogg", 60, TRUE)
	if(do_after(user, fix_time, src))
		jammed = FALSE
		user.visible_message(span_notice("[user] clears the jam in [src]."))
		to_chat(user, span_notice("The mechanism is clear."))

/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(next_chamber)), 1 SECONDS)

/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller/proc/next_chamber()
	if(QDELETED(src))
		return
	if(!QDELETED(chambered))
		qdel(chambered)
	chambered = null
	if(rounds_remaining > 0)
		rounds_remaining--
		chambered = new /obj/item/ammo_casing/caseless/bullet/lead(src)
		reloaded = TRUE
		gunpowder = TRUE

// =====================================================
// IRONSHOT MARK 1 - single-shot, ram and powder, the cheap workman's pistol.
// Same handling as a stock arquebus pistol, just a Scum-fab reskin.
// =====================================================
/obj/item/gun/ballistic/firearm/arquebus_pistol/ironshot
	name = "Ironshot Mark 1"
	desc = "A sophisticated descendant of the arquebus pistol, made by Ser Ironshot, royal engineer. \
	Functionally the same as an arquebus pistol, this is clearly coming from Kingsfield."
	icon = 'modular_underbelly/sprites/scumguns.dmi'
	icon_state = "hunter_pistol_loading"
	lefthand_file = 'modular_underbelly/sprites/scumguns.dmi'
	righthand_file = 'modular_underbelly/sprites/scumguns.dmi'
	item_state = "hunter_pistol_loading"
	force = 12
	spread = 8
	/// TRUE while the breech is open. Required for loading powder/ball; closed by ramming, opened by use-in-hand.
	var/breech_open = TRUE

/obj/item/gun/ballistic/firearm/arquebus_pistol/ironshot/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_ADDED, PROC_REF(block_blood_decal))
	transform = matrix().Scale(0.5, 0.5)

/obj/item/gun/ballistic/firearm/arquebus_pistol/ironshot/proc/block_blood_decal(datum/source, datum/component/C)
	SIGNAL_HANDLER
	if(istype(C, /datum/component/decal/blood))
		qdel(C)

/obj/item/gun/ballistic/firearm/arquebus_pistol/ironshot/update_icon()
	. = ..()
	if(breech_open)
		icon_state = "hunter_pistol_loading"
		item_state = "hunter_pistol_loading"
	else
		icon_state = "hunter_pistol"
		item_state = "hunter_pistol"

/obj/item/gun/ballistic/firearm/arquebus_pistol/ironshot/shoot_live_shot(mob/living/user, pointblank = 0, mob/pbtarget = null, message = 1)
	if(recoil)
		shake_camera(user, recoil + 1, recoil)
	playsound(user, 'modular_underbelly/sound/gun/fire_ironshot.ogg', fire_sound_volume, vary_fire_sound)
	show_sensory_effect(user, 5, "gunfire", user.dir)
	if(message)
		user.visible_message(span_danger("[user] shoots [src]!"), span_danger("I shoot [src]!"), COMBAT_MESSAGE_RANGE)

/obj/item/gun/ballistic/firearm/arquebus_pistol/ironshot/attack_self(mob/living/user)
	if(twohands_required || altgripped || wielded || alt_intents || gripped_intents)
		return ..()
	if(breech_open)
		if(!chambered || !gunpowder)
			to_chat(user, span_warning("Powder and ball go in before you shut it."))
			return
		breech_open = FALSE
		reloaded = TRUE
		playsound(src, 'modular_underbelly/sound/gun/load_ironshot.ogg', 90, FALSE)
		user.visible_message(span_notice("[user] snaps [src] shut. Ready."))
		update_icon()
		return
	breech_open = TRUE
	playsound(src, 'modular_underbelly/sound/gun/open_ironshot.ogg', 70, FALSE)
	user.visible_message(span_notice("[user] cracks [src] open."))
	update_icon()

/obj/item/gun/ballistic/firearm/arquebus_pistol/ironshot/attackby(obj/item/A, mob/user, params)
	var/firearm_skill = user.get_skill_level(/datum/skill/combat/firearms)
	var/load_time_skill = load_time - (firearm_skill * 2)

	if(istype(A, /obj/item/ammo_casing))
		if(!breech_open)
			to_chat(user, span_warning("[src] is shut. Crack it open first."))
			return
		if(chambered)
			to_chat(user, span_warning("There is already a [chambered] in [src]!"))
			return
		if(!gunpowder)
			to_chat(user, span_warning("I must pour smokepowder into [src] first!"))
			return
		if((loc == user) && (user.get_inactive_held_item() != src))
			return
		playsound(src, 'modular_underbelly/sound/gun/load_bullet.ogg', 90, FALSE)
		user.visible_message(span_notice("[user] seats a [A] into the open breech of [src]."))
		if(!user.transferItemToLoc(A, src))
			return
		chambered = A
		update_icon()
		return

	if(istype(A, /obj/item/powderflask))
		if(!breech_open)
			to_chat(user, span_warning("[src] is shut. Crack it open first."))
			return
		if(gunpowder)
			to_chat(user, span_warning("[src] is already primed!"))
			return
		playsound(src, "modular_helmsguard/sound/arquebus/pour_powder.ogg", 100)
		if(do_after(user, load_time_skill, src))
			user.visible_message(span_notice("[user] tips powder into [src]'s pan."))
			gunpowder = TRUE
			update_icon()
		return
	return ..()

// =====================================================
// ABOMINATION - double-shot volleygun, mordhau hybrid
// Breech-loaded: smokepowder then up to two lead spheres. Fires one at a time.
// Use-in-hand to flip between gun grip and mordhau grip.
// Axe slot: attach any stoneaxe subtype. Remove with a hammer.
// Scum-only: the runes on the frame refuse to cooperate for outsiders.
// =====================================================
/obj/item/gun/ballistic/firearm/abomination
	name = "abomination"
	desc = "Vile, putrid, disgusting... two flingonnes stuck together with leather reinforced old rope, a butt-end reinforced with steel... \
	There's a slot that could fit an axe... There's some weird runes itched on the weapon, clearly of arcyne origin."
	icon = 'modular_underbelly/sprites/vollygun.dmi'
	icon_state = "volley"
	item_state = "volley"
	bigboy = FALSE
	gripsprite = FALSE
	force = 22
	force_wielded = 28
	w_class = WEIGHT_CLASS_BULKY
	wlength = WLENGTH_NORMAL
	slot_flags = ITEM_SLOT_BACK
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/shoot/firearm, /datum/intent/arc/firearm, /datum/intent/mace/strike/wood)
	alt_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash)
	cartridge_wording = "lead ball"
	load_time = 60
	minstr = 8
	/// Number of lead balls currently loaded.
	var/balls_loaded = 0
	/// Maximum balls the weapon can hold. Raised to 3 by the capacity upgrade.
	var/max_balls = 2
	/// Axe strapped into the frame slot. Any stoneaxe subtype.
	var/obj/item/rogueweapon/stoneaxe/attached_axe = null

/obj/item/gun/ballistic/firearm/abomination/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_ADDED, PROC_REF(block_blood_decal))
	if(myrod)
		qdel(myrod)
		myrod = null

/obj/item/gun/ballistic/firearm/abomination/proc/block_blood_decal(datum/source, datum/component/C)
	SIGNAL_HANDLER
	if(istype(C, /datum/component/decal/blood))
		qdel(C)

/obj/item/gun/ballistic/firearm/abomination/update_icon()
	. = ..()
	if(altgripped)
		icon_state = attached_axe ? "volly_axe_alt" : "volley_alt"
	else
		icon_state = attached_axe ? "volley_axe" : "volley"
	item_state = icon_state

/obj/item/gun/ballistic/firearm/abomination/getmoboverlay(tag, prop, behind = FALSE, mirrored = FALSE)
	var/static/list/abom_onmob = list()
	var/used_index = icon_state
	var/key = "[tag][behind][mirrored][used_index]"
	var/icon/onmob = abom_onmob[key]
	if(!onmob || force_reupdate_inhand)
		if(force_reupdate_inhand)
			has_behind_state = null
		onmob = fcopy_rsc(generateonmob(tag, prop, behind, mirrored, used_index))
		abom_onmob[key] = onmob
	return onmob

/obj/item/gun/ballistic/firearm/abomination/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -2,"sy" = -1,"nx" = 1,"ny" = 4,"wx" = -5,"wy" = 2,"ex" = 3,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -6,"sturn" = -3,"wturn" = 0,"eturn" = -6,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.5,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -1,"wx" = -7,"wy" = 0,"ex" = 6,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -45,"sturn" = 45,"wturn" = -35,"eturn" = 35,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/gun/ballistic/firearm/abomination/attack_right(mob/user)
	flip_grip(user)

/obj/item/gun/ballistic/firearm/abomination/attack_self(mob/living/user)
	if(wielded || altgripped)
		ungrip(user)
		update_icon()
		return
	wield(user)
	update_icon()

/obj/item/gun/ballistic/firearm/abomination/proc/flip_grip(mob/living/carbon/user)
	if(!istype(user) || user.incapacitated())
		return
	if(!(src in user.held_items))
		to_chat(user, span_warning("I need to be holding [src]."))
		return
	if(user.get_active_held_item() != src)
		user.swap_hand(user.get_held_index_of_item(src))
	if(user.get_active_held_item() != src)
		return
	if(user.get_num_arms() < 2 || user.get_inactive_held_item())
		to_chat(user, span_warning("I need both hands free to flip [src]."))
		return
	if(altgripped)
		altgripped = FALSE
		wielded = TRUE
		user.visible_message(span_notice("[user] flips [src] back to firing position."))
	else
		altgripped = TRUE
		wielded = TRUE
		user.visible_message(span_notice("[user] flips [src] around, gripping the barrels as a club."))
	if(force_wielded)
		update_force_dynamic()
	wdefense_dynamic = (wdefense + wdefense_wbonus)
	playsound(loc, pick('sound/combat/weaponr1.ogg','sound/combat/weaponr2.ogg'), 100, TRUE)
	update_transform()
	update_icon()
	user.update_inv_hands()
	user.update_a_intents()

/obj/item/gun/ballistic/firearm/abomination/attackby(obj/item/A, mob/user, params)
	var/firearm_skill = user.get_skill_level(/datum/skill/combat/firearms)
	if(istype(A, /obj/item/powderflask))
		if(gunpowder)
			to_chat(user, span_warning("[src] is already primed!"))
			return
		if(balls_loaded > 0)
			to_chat(user, span_warning("Empty the barrels before reloading powder."))
			return
		playsound(src, "modular_helmsguard/sound/arquebus/pour_powder.ogg", 100)
		if(do_after(user, load_time - (firearm_skill * 2), src))
			user.visible_message(span_notice("[user] tips powder into [src]."))
			gunpowder = TRUE
		return
	if(istype(A, /obj/item/ammo_casing/caseless/bullet/lead))
		if(!gunpowder)
			to_chat(user, span_warning("Pour smokepowder in first."))
			return
		if(balls_loaded >= max_balls)
			to_chat(user, span_warning("Both barrels are already loaded."))
			return
		playsound(src, 'modular_underbelly/sound/gun/load_bullet.ogg', 90, FALSE)
		user.visible_message(span_notice("[user] drops a ball into [src]."))
		qdel(A)
		balls_loaded++
		reloaded = TRUE
		return
	if(istype(A, /obj/item/ammo_casing))
		to_chat(user, span_warning("[src] only fires lead balls."))
		return
	if(istype(A, /obj/item/rogueweapon/stoneaxe))
		if(attached_axe)
			to_chat(user, span_warning("There's already an axe fitted."))
			return
		var/obj/item/rogueweapon/stoneaxe/AX = A
		user.visible_message(span_notice("[user] begins lashing [AX] to [src]..."))
		if(do_after(user, 20, src))
			if(attached_axe || QDELETED(AX))
				return
			if(!user.transferItemToLoc(AX, src))
				return
			attached_axe = AX
			force = 24
			force_wielded = 27
			alt_intents = list(/datum/intent/axe/chop/stone)
			if(altgripped && user.get_active_held_item() == src)
				user.update_a_intents()
			update_icon()
			user.visible_message(span_notice("[user] straps [AX] to [src]."))
		return
	if(istype(A, /obj/item/rogueweapon/hammer))
		if(!attached_axe)
			to_chat(user, span_warning("Nothing to pry loose."))
			return
		user.visible_message(span_notice("[user] works the hammer against the bindings on [src]..."))
		if(do_after(user, 30, src))
			if(!attached_axe)
				return
			var/obj/item/rogueweapon/stoneaxe/AX = attached_axe
			attached_axe = null
			force = initial(force)
			force_wielded = initial(force_wielded)
			AX.forceMove(get_turf(user))
			alt_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash)
			if(altgripped && user.get_active_held_item() == src)
				user.update_a_intents()
			update_icon()
			user.visible_message(span_notice("[user] knocks [AX] free of [src]."))
		return
	if(istype(A, /obj/item/ramrod))
		to_chat(user, span_warning("A ramrod won't help here."))
		return
	return ..()

/obj/item/gun/ballistic/firearm/abomination/can_shoot()
	if(altgripped)
		return FALSE
	return gunpowder && balls_loaded >= 1

/obj/item/gun/ballistic/firearm/abomination/shoot_live_shot(mob/living/user, pointblank = 0, mob/pbtarget = null, message = 1)
	playsound(user, 'modular_underbelly/sound/gun/abomination_shoot.ogg', 100, TRUE, extrarange = 10)
	show_sensory_effect(user, 6, "gunfire", user.dir)
	if(message)
		user.visible_message(span_danger("[user] fires [src]!"), span_danger("I fire [src]!"), COMBAT_MESSAGE_RANGE)

/obj/item/gun/ballistic/firearm/abomination/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(!HAS_TRAIT(user, TRAIT_UNDERBELLY_SCUM))
		to_chat(user, span_warning("You don't know how to use this...thing."))
		return
	if(!chambered)
		chambered = new /obj/item/ammo_casing/caseless/bullet/lead(src)
	reloaded = TRUE
	. = ..()
	chambered = null
	balls_loaded = max(0, balls_loaded - 1)
	if(balls_loaded > 0)
		gunpowder = TRUE
		reloaded = TRUE

/obj/item/gun/ballistic/firearm/abomination/attack(mob/living/M, mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_UNDERBELLY_SCUM))
		to_chat(user, span_warning("You don't know how to use this...thing."))
		return
	return ..()

/obj/item/gun/ballistic/firearm/abomination/Destroy()
	if(attached_axe)
		attached_axe.forceMove(get_turf(src))
		attached_axe = null
	return ..()

/obj/item/gun/ballistic/firearm/abomination/handle_atom_del(atom/A)
	if(A == attached_axe)
		attached_axe = null
		force = initial(force)
		force_wielded = initial(force_wielded)
		alt_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash)
		update_icon()
	return ..()

// =====================================================
// HAND CANNON - one-shot, quite long range, gibs the dumb.
// Quite fast to load. Deals less damage than a fireball.
// =====================================================
/obj/item/ammo_casing/caseless/bullet/cannonball
	name = "cannonball"
	desc = "An iron sphere the size of a fist. Or a kobold's head, if you really want to go there."
	projectile_type = /obj/projectile/bullet/firearm/lead
	caliber = "cannonball"
	icon = 'modular_underbelly/sprites/cannonballs.dmi'
	icon_state = "ball"
	w_class = WEIGHT_CLASS_SMALL

GLOBAL_LIST_INIT(cannon_loadable_species, typecacheof(list(
	/datum/species/kobold,
	/datum/species/goblin,
	/datum/species/goblinp,
	/datum/species/dwarf,
	/datum/species/anthromorphsmall,
)))

/obj/effect/cannonshot
	name = "cannonball"
	desc = "Get out of the way."
	icon = 'modular_underbelly/sprites/cannonballs.dmi'
	icon_state = "ball_VFX"
	anchored = FALSE
	density = FALSE
	move_resist = MOVE_FORCE_NORMAL
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE
	var/mob/living/firer

/obj/effect/cannonshot/Initialize(mapload, mob/living/source, travel_dir)
	. = ..()
	firer = source
	switch(travel_dir)
		if(WEST)
			transform = matrix(-1, 0, 0, 0, 1, 0)
		if(NORTH)
			transform = turn(matrix(), -90)
		if(SOUTH)
			transform = turn(matrix(), 90)

/obj/effect/cannonshot/proc/detonate()
	var/turf/T = get_turf(src)
	if(T && firer)
		new /obj/effect/temp_visual/explosion(T)
		for(var/mob/living/L in range(1, T))
			if(L == firer)
				continue
			if(!L.mind && !L.client)
				L.visible_message(span_danger("[L] is torn apart by the blast!"))
				L.gib()
				continue
			for(var/zone in list(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
				L.apply_damage(8, BRUTE, zone)
			L.Knockdown(60)
			shake_camera(L, 5, 4)
			var/throw_dir = get_dir(T, L) || firer.dir
			L.safe_throw_at(get_edge_target_turf(T, throw_dir), 4, 1, firer, force = MOVE_FORCE_EXTREMELY_STRONG)
	qdel(src)

/obj/effect/cannonshot/Bump(atom/A)
	if(A && !isturf(A) && !ismob(A))
		detonate()
		return
	..()

/obj/item/gun/ballistic/firearm/cannon
	name = "hand cannon"
	desc = "A stubby barrel of black iron, which could, within theory shoot kobolds. \
	A relic from a foundry of a very creative dwarf. Loading it is a chore. This could probably blow something up real good."
	icon = 'modular_underbelly/sprites/scumguns.dmi'
	icon_state = "cannon"
	item_state = "cannon"
	force = 24
	spread = 0
	w_class = WEIGHT_CLASS_BULKY
	wlength = WLENGTH_SHORT
	walking_stick = FALSE
	bigboy = TRUE
	gripsprite = FALSE
	possible_item_intents = list(/datum/intent/shoot/firearm, /datum/intent/arc/firearm, /datum/intent/mace/strike/wood)
	gripped_intents = null
	slot_flags = ITEM_SLOT_BACK
	cartridge_wording = "cannonball"
	load_time = 80
	minstr = 13
	var/mob/living/loaded_passenger

/obj/item/gun/ballistic/firearm/cannon/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_casing))
		if(!istype(A, /obj/item/ammo_casing/caseless/bullet/cannonball))
			to_chat(user, span_warning("Only a cannonball fits down this barrel."))
			return
		if(chambered)
			to_chat(user, span_warning("The barrel is already loaded!"))
			return
		playsound(src, 'modular_helmsguard/sound/arquebus/insert.ogg', 100)
		user.visible_message(span_notice("[user] forces a cannonball down the barrel of [src]."))
		if(!user.transferItemToLoc(A, src))
			return
		chambered = A
		gunpowder = TRUE
		reloaded = TRUE
		return
	if(istype(A, /obj/item/powderflask))
		to_chat(user, span_warning("The cannonball is its own charge - just shove it down."))
		return
	if(istype(A, /obj/item/ramrod))
		to_chat(user, span_warning("The barrel is too wide for a ramrod."))
		return
	return ..()

/obj/item/gun/ballistic/firearm/cannon/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_ADDED, PROC_REF(block_blood_decal))
	gunpowder = TRUE

/obj/item/gun/ballistic/firearm/cannon/proc/block_blood_decal(datum/source, datum/component/C)
	SIGNAL_HANDLER
	if(istype(C, /datum/component/decal/blood))
		qdel(C)

/obj/item/gun/ballistic/firearm/cannon/update_icon()
	if(QDELETED(src))
		return
	cut_overlays()
	icon_state = initial(icon_state)

/obj/item/gun/ballistic/firearm/cannon/getmoboverlay(tag, prop, behind = FALSE, mirrored = FALSE)
	var/static/list/cannon_onmob = list()
	var/used_index = "cannon"
	var/key = "[tag][behind][mirrored][used_index]"
	var/icon/onmob = cannon_onmob[key]
	if(!onmob || force_reupdate_inhand)
		if(force_reupdate_inhand)
			has_behind_state = null
		onmob = fcopy_rsc(generateonmob(tag, prop, behind, mirrored, used_index))
		cannon_onmob[key] = onmob
	return onmob

/obj/item/gun/ballistic/firearm/cannon/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -8,"sy" = -6,"nx" = 5,"ny" = -2,"wx" = -10,"wy" = -3,"ex" = 7,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = -14,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.7,"sx" = -8,"sy" = -6,"nx" = 5,"ny" = -2,"wx" = -7,"wy" = -4,"ex" = 7,"ey" = -4,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0,"nturn" = -13,"sturn" = -14,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)

/obj/item/gun/ballistic/firearm/cannon/can_shoot()
	if(!chambered || !reloaded)
		return FALSE
	return TRUE

/obj/item/gun/ballistic/firearm/cannon/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(!user)
		return
	if(user.STASTR < minstr)
		to_chat(user, span_danger("[src] wrenches free of my grip - too damn heavy!"))
		user.visible_message(span_warning("[src] kicks out of [user]'s hands!"))
		user.dropItemToGround(src, TRUE)
		user.Knockdown(40)
		gunpowder = FALSE
		reloaded = FALSE
		if(loaded_passenger)
			eject_passenger()
		else if(chambered)
			qdel(chambered)
			chambered = null
		return
	user.visible_message(span_warning("[user] braces [src] - the fuse hisses!"), span_warning("I touch the fuse to [src]..."))
	playsound(user, 'modular_helmsguard/sound/arquebus/insert.ogg', 60, TRUE)
	var/turf/origin = get_step(user, user.dir)
	if(!origin)
		return
	var/fire_dir = user.dir
	var/turf/edge = get_edge_target_turf(user, fire_dir)
	if(!do_after(user, 5, src))
		return
	playsound(user, 'modular_underbelly/sound/gun/cannon_fire.ogg', 100, TRUE, extrarange = 14)
	show_sensory_effect(user, 7, "gunfire", user.dir)
	show_sensory_effect(user, 7, "gunfire", fire_dir)
	shake_camera(user, 4, 3)
	user.visible_message(span_danger("[user] fires [src] - the air ITSELF cracks!"), span_danger("I fire [src]!"))
	user.adjustStaminaLoss(40)
	if(loaded_passenger)
		launch_passenger(user, edge)
	else
		launch_shot(user, origin, edge, fire_dir)
	gunpowder = FALSE
	reloaded = FALSE
	if(chambered)
		qdel(chambered)
		chambered = null

/obj/item/gun/ballistic/firearm/cannon/proc/launch_shot(mob/living/firer, turf/origin, turf/edge, fire_dir)
	var/obj/effect/cannonshot/shot = new(origin, firer, fire_dir)
	shot.throw_at(edge, 30, 0.6, firer, FALSE, callback = CALLBACK(shot, TYPE_PROC_REF(/obj/effect/cannonshot, detonate)))

/obj/item/gun/ballistic/firearm/cannon/proc/launch_passenger(mob/living/firer, turf/edge)
	var/mob/living/M = loaded_passenger
	loaded_passenger = null
	M.forceMove(get_step(firer, firer.dir) || get_turf(firer))
	M.visible_message(span_danger("[M] is launched out of [src]!"))
	M.safe_throw_at(edge, 12, 2, firer, force = MOVE_FORCE_EXTREMELY_STRONG)

/obj/item/gun/ballistic/firearm/cannon/proc/eject_passenger()
	if(!loaded_passenger)
		return
	loaded_passenger.forceMove(get_turf(src))
	loaded_passenger = null

/obj/item/gun/ballistic/firearm/cannon/attack(mob/living/M, mob/living/user)
	if(try_load_passenger(M, user))
		return TRUE
	return ..()

/obj/item/gun/ballistic/firearm/cannon/afterattack(atom/target, mob/living/user, flag, params)
	if(ishuman(target) && !chambered && !loaded_passenger)
		if(try_load_passenger(target, user))
			return
	return ..()

/obj/item/gun/ballistic/firearm/cannon/proc/try_load_passenger(mob/living/M, mob/living/user)
	if(!ishuman(M) || M == user || !user.Adjacent(M))
		return FALSE
	if(loaded_passenger || chambered)
		return FALSE
	var/mob/living/carbon/human/H = M
	if(!is_type_in_typecache(H.dna?.species, GLOB.cannon_loadable_species))
		return FALSE
	load_passenger(H, user)
	return TRUE

/obj/item/gun/ballistic/firearm/cannon/proc/load_passenger(mob/living/carbon/human/H, mob/living/user)
	user.visible_message(span_danger("[user] starts shoving [H] head-first into [src]!"), span_danger("I start cramming [H] down the barrel of [src]..."))
	playsound(src, 'modular_helmsguard/sound/arquebus/insert.ogg', 80, TRUE)
	if(!do_after(user, 30, H))
		return
	if(loaded_passenger || chambered || !H.Adjacent(user))
		return
	H.forceMove(src)
	loaded_passenger = H
	gunpowder = TRUE
	reloaded = TRUE
	user.visible_message(span_danger("[user] crams [H] into [src]!"))

/obj/item/gun/ballistic/firearm/cannon/MouseDrop_T(mob/living/dropping, mob/living/user)
	if(!istype(dropping) || !istype(user))
		return
	if(loaded_passenger || chambered)
		to_chat(user, span_warning("[src] is already loaded."))
		return
	if(!Adjacent(user) || !dropping.Adjacent(user))
		return
	if(!ishuman(dropping))
		to_chat(user, span_warning("[dropping] won't fit."))
		return
	var/mob/living/carbon/human/H = dropping
	if(!is_type_in_typecache(H.dna?.species, GLOB.cannon_loadable_species))
		to_chat(user, span_warning("[dropping] is too big to stuff down the barrel."))
		return
	user.visible_message(span_danger("[user] starts shoving [dropping] head-first into [src]!"), span_danger("I start cramming [dropping] down the barrel of [src]..."))
	playsound(src, 'modular_helmsguard/sound/arquebus/insert.ogg', 80, TRUE)
	if(!do_after(user, 30, dropping))
		return
	if(loaded_passenger || chambered || !dropping.Adjacent(user))
		return
	dropping.forceMove(src)
	loaded_passenger = dropping
	gunpowder = TRUE
	reloaded = TRUE
	user.visible_message(span_danger("[user] crams [dropping] into [src]!"))

/obj/item/gun/ballistic/firearm/cannon/can_shoot()
	if(loaded_passenger)
		return TRUE
	if(!chambered || !reloaded)
		return FALSE
	return TRUE

/obj/item/gun/ballistic/firearm/cannon/attack_hand(mob/user)
	if(loaded_passenger && loc != user)
		user.visible_message(span_notice("[user] hauls [loaded_passenger] back out of [src]."))
		eject_passenger()
		return
	return ..()

/obj/item/gun/ballistic/firearm/cannon/Destroy()
	if(loaded_passenger)
		eject_passenger()
	return ..()

/obj/item/gun/ballistic/firearm/cannon/handle_atom_del(atom/A)
	if(A == loaded_passenger)
		loaded_passenger = null
	return ..()

// =====================================================
// DEVASTATOR - heavy double-shot blunderbuss
// purchase_sound_key = "biggun"
// Two grapeshots per full reload cycle.
// =====================================================
/obj/item/gun/ballistic/firearm/devastator
	name = "devastator"
	desc = "A blunderbuss with a reinforced barrel and an ugly extended magazine. \
	It fires a spread wide enough to catch everyone in the room. \
	Nobody who sees it pointed at them tries their luck."
	icon = 'modular_underbelly/sprites/lungpuncher.dmi'
	icon_state = "lungpuncher"
	lefthand_file = 'modular_underbelly/sprites/lungpuncher.dmi'
	righthand_file = 'modular_underbelly/sprites/lungpuncher.dmi'
	item_state = "lungpuncher1"
	bigboy = FALSE
	gripsprite = TRUE
	cartridge_wording = "grapeshot"
	force = 22
	spread = 15
	var/rounds_remaining = 0
	/// Max grapeshots the barrel can hold. Raised to 3 by the capacity upgrade kit.
	var/max_capacity = 2
	/// Set when the firing mechanism jams. Cleared by right-clicking to fix it.
	var/jammed = FALSE

/obj/item/gun/ballistic/firearm/devastator/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_ADDED, PROC_REF(block_blood_decal))

/obj/item/gun/ballistic/firearm/devastator/proc/block_blood_decal(datum/source, datum/component/C)
	SIGNAL_HANDLER
	if(istype(C, /datum/component/decal/blood))
		qdel(C)

// the reason why im doing this is because the sprite gets super buggy if it gets blood on it and i cba fixing it.

/obj/item/gun/ballistic/firearm/devastator/getonmobprop(tag)
	switch(tag)
		if("gen")
			return list("shrink" = 0.6,"sx" = -12,"sy" = 6,"nx" = 9,"ny" = 7,"wx" = -6,"wy" = 6,"ex" = 4,"ey" = 6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -20,"sturn" = 10,"wturn" = 19,"eturn" = -17,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
		if("wielded")
			return list("shrink" = 0.6,"sx" = 2,"sy" = -3,"nx" = -3,"ny" = 5,"wx" = -6,"wy" = -4,"ex" = 3,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = 8,"sturn" = 49,"wturn" = -43,"eturn" = 39,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
		if("altgrip")
			return null
		if("onback")
			return null
	return ..()

/obj/item/gun/ballistic/firearm/devastator/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/quiver/bullet/grapeshot))
		var/obj/item/quiver/bullet/grapeshot/Q = A
		if(!gunpowder)
			to_chat(user, span_warning("You must fill the [src] with smokepowder first!"))
			return
		if(!length(Q.arrows))
			to_chat(user, span_warning("There is no grapeshot left in [Q]."))
			return
		if(rounds_remaining + (chambered ? 1 : 0) >= max_capacity)
			to_chat(user, span_warning("The [src] is already fully loaded!"))
			return
		var/obj/item/ammo_casing/caseless/bullet/grapeshot/shot = Q.arrows[Q.arrows.len]
		Q.arrows -= shot
		qdel(shot)
		Q.update_icon()
		playsound(src, "modular_helmsguard/sound/arquebus/insert.ogg", 100)
		user.visible_message(span_notice("[user] forces a grapeshot down the barrel of the [src]."))
		if(chambered)
			rounds_remaining++
		else
			chambered = new /obj/item/ammo_casing/caseless/bullet/grapeshot(src)
			reloaded = TRUE
		return
	if(istype(A, /obj/item/ammo_casing))
		if(!istype(A, /obj/item/ammo_casing/caseless/bullet/grapeshot))
			to_chat(user, span_warning("The [src] only fires grapeshot."))
			return
		if(!gunpowder)
			to_chat(user, span_warning("You must fill the [src] with smokepowder first!"))
			return
		if(rounds_remaining + (chambered ? 1 : 0) >= max_capacity)
			to_chat(user, span_warning("The [src] is already fully loaded!"))
			return
		playsound(src, "modular_helmsguard/sound/arquebus/insert.ogg", 100)
		user.visible_message(span_notice("[user] forces a [A] down the barrel of the [src]."))
		if(chambered)
			rounds_remaining++
		else
			chambered = new /obj/item/ammo_casing/caseless/bullet/grapeshot(src)
			reloaded = TRUE
		qdel(A)
		return
	return ..()

/obj/item/gun/ballistic/firearm/devastator/can_shoot()
	if(!chambered)
		return FALSE
	if(jammed)
		return FALSE
	return TRUE

/obj/item/gun/ballistic/firearm/devastator/shoot_live_shot(mob/living/user, pointblank = 0, mob/pbtarget = null, message = 1)
	// Misfire chance: base 20%, reduced by 2% per luck point above 10, floored at 5%.
	var/misfire_chance = clamp(40 - (user.STALUC - 10) * 2, 5, 40)
	if(prob(misfire_chance))
		jammed = TRUE
		playsound(user, 'modular_helmsguard/sound/arquebus/musketcock.ogg', 80, FALSE)
		user.visible_message(span_warning("[user]'s [src] clicks — it's jammed!"), span_warning("The [src] jams! Right-click it to clear the mechanism."))
		return
	if(recoil)
		shake_camera(user, recoil + 1, recoil)
	playsound(user, 'modular_underbelly/sound/gun/fire_shotgun_01.ogg', fire_sound_volume, vary_fire_sound)
	show_sensory_effect(user, 5, "gunfire", user.dir)
	if(message)
		user.visible_message(span_danger("[user] shoots [src]!"), span_danger("I shoot [src]!"), COMBAT_MESSAGE_RANGE)

// Right-click to clear a jam. Takes longer with low firearms skill.
/obj/item/gun/ballistic/firearm/devastator/attack_right(mob/user)
	if(!jammed)
		to_chat(user, span_notice("The [src] is fine."))
		return
	var/firearm_skill = user.get_skill_level(/datum/skill/combat/firearms)
	var/fix_time = clamp(60 - firearm_skill * 8, 20, 60) // 60 at skill 0, 20 at skill 5+
	user.visible_message(span_notice("[user] works at clearing the jam in [src]..."))
	playsound(src, "modular_helmsguard/sound/arquebus/ramrod.ogg", 80, TRUE)
	if(do_after(user, fix_time, src))
		jammed = FALSE
		user.visible_message(span_notice("[user] clears the jam in [src]."))
		to_chat(user, span_notice("The mechanism is clear."))

/obj/item/gun/ballistic/firearm/devastator/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(next_chamber)), 1 SECONDS)

/obj/item/gun/ballistic/firearm/devastator/proc/next_chamber()
	if(QDELETED(src))
		return
	if(!QDELETED(chambered))
		qdel(chambered)
	chambered = null
	if(rounds_remaining > 0)
		rounds_remaining--
		chambered = new /obj/item/ammo_casing/caseless/bullet/grapeshot(src)
		reloaded = TRUE
		gunpowder = TRUE


// =====================================================
// DEFACER - steel knuckles counterpart that deals more damage but is less durable.
// purchase_sound_key = "spikedknucks"
// =====================================================
/obj/item/rogueweapon/knuckles/defacer
	name = "defacer"
	desc = "Knuckles that were hardened with a mixture of the ancient alloys used by Vampyres, and Steel. \
	It's less durable than its steel knuckle counterpart, but hurts more."
	force = 32
	max_integrity = 100
	color = "#C86820"

// =====================================================
// GUN UPGRADE KITS - Scum exclusives, apply to any underbelly firearm
// Use on the gun in-hand to install. One-time each.
// =====================================================

/// Upgrade kit base type. Apply to a gut_spiller, venator, or devastator.
/obj/item/underbelly_upgrade
	icon = 'modular_helmsguard/icons/obj/items/arquebus_items.dmi'
	icon_state = "ramrod"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP

/obj/item/underbelly_upgrade/damage
	name = "reinforced firing pin"
	desc = "A hardened pin assembly machined to hit powder charges harder. Improves damage output of any Scum firearm."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "wcog"

/obj/item/underbelly_upgrade/damage/afterattack(atom/target, mob/living/user, flag, params)
	if(!flag)
		return
	var/obj/item/gun/ballistic/firearm/G = target
	if(!istype(G) || !(istype(G, /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller) || istype(G, /obj/item/gun/ballistic/firearm/abomination) || istype(G, /obj/item/gun/ballistic/firearm/devastator)))
		to_chat(user, span_warning("[src] can only be fitted to underbelly firearms."))
		return
	if(G.force >= initial(G.force) + 5)
		to_chat(user, span_warning("[G] already has a damage upgrade fitted."))
		return
	G.force += 5
	G.force_wielded += 5
	to_chat(user, span_notice("You fit the [src] into [G]. It'll hit harder now."))
	qdel(src)

/obj/item/underbelly_upgrade/silencer
	name = "baffled powder sleeve"
	desc = "A sleeve of treated wool packed inside the barrel assembly. Absorbs most of the powder smoke on discharge. The mark won't see it coming."
	icon_state = "powderflask"

/obj/item/underbelly_upgrade/silencer/afterattack(atom/target, mob/living/user, flag, params)
	if(!flag)
		return
	var/obj/item/gun/ballistic/firearm/G = target
	if(!istype(G) || !(istype(G, /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller) || istype(G, /obj/item/gun/ballistic/firearm/abomination) || istype(G, /obj/item/gun/ballistic/firearm/devastator)))
		to_chat(user, span_warning("[src] can only be fitted to underbelly firearms."))
		return
	if(G.suppress_smoke)
		to_chat(user, span_warning("[G] already has a smoke suppressor fitted."))
		return
	G.suppress_smoke = TRUE
	to_chat(user, span_notice("You pack the [src] into [G]. No more cloud every time you pull the trigger."))
	qdel(src)

/obj/item/underbelly_upgrade/capacity
	name = "extended cylinder plate"
	desc = "A machined insert that opens up one more chamber in the cylinder — or squeezes one more round into the bolt housing. Whoever made this had steady hands."
	icon = 'icons/roguetown/items/anvil_casting.dmi'
	icon_state = "base_plate"

/obj/item/underbelly_upgrade/capacity/afterattack(atom/target, mob/living/user, flag, params)
	if(!flag)
		return
	if(istype(target, /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller))
		var/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller/G = target
		if(G.rounds_remaining >= 7)
			to_chat(user, span_warning("[G] already has a capacity upgrade fitted."))
			return
		G.rounds_remaining++
		to_chat(user, span_notice("You fit the [src] into [G]. One more round in the cylinder."))
		qdel(src)
		return
	if(istype(target, /obj/item/gun/ballistic/firearm/abomination))
		var/obj/item/gun/ballistic/firearm/abomination/G = target
		if(G.max_balls >= 3)
			to_chat(user, span_warning("[G] already has a capacity upgrade fitted."))
			return
		G.max_balls = 3
		to_chat(user, span_notice("You fit the [src] into [G]. One more ball fits down those barrels."))
		qdel(src)
		return
	if(istype(target, /obj/item/gun/ballistic/firearm/devastator))
		var/obj/item/gun/ballistic/firearm/devastator/G = target
		if(G.max_capacity >= 3)
			to_chat(user, span_warning("[G] already has a capacity upgrade fitted."))
			return
		G.max_capacity = 3
		to_chat(user, span_notice("You fit the [src] into [G]. One more grapeshot loaded."))
		qdel(src)
		return
	to_chat(user, span_warning("[src] can only be fitted to underbelly firearms."))

/obj/item/underbelly_upgrade/aim
	name = "filed sights"
	desc = "Carefully filed iron sights, realigned to account for drift. Drops the effective spread on any underbelly firearm."
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lockpick"

/obj/item/underbelly_upgrade/aim/afterattack(atom/target, mob/living/user, flag, params)
	if(!flag)
		return
	var/obj/item/gun/ballistic/firearm/G = target
	if(!istype(G) || !(istype(G, /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller) || istype(G, /obj/item/gun/ballistic/firearm/abomination) || istype(G, /obj/item/gun/ballistic/firearm/devastator)))
		to_chat(user, span_warning("[src] can only be fitted to underbelly firearms."))
		return
	if(G.aim_upgrade)
		to_chat(user, span_warning("[G] already has filed sights fitted."))
		return
	G.aim_upgrade = TRUE
	G.spread_num = max(0, G.spread_num - 3)
	to_chat(user, span_notice("You fit the [src] onto [G]. The sights are sharper now."))
	qdel(src)
