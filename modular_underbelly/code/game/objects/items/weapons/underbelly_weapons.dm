/*
	UNDERBELLY EXCLUSIVE WEAPONS
	Four weapons unique to the Criminal Underbelly. Not sold anywhere else.
	Gut Spiller - compact close-range firearm, the Gutter King's signature.
	Venator      - medium-range reliable sidearm for the well-funded Scum.
	Devastator   - heavy long-arm, devastating but ponderous.
	Defacer      - spiked knuckle-knife, close and brutal.
*/

// =====================================================
// GUT SPILLER - compact pistol, short range carnage
// purchase_sound_key = "smallgun"
// Pepperbox-style: six pre-loaded chambers, no ramrod between shots.
// =====================================================
/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller
	name = "gut spiller"
	desc = "A squat, scrappy six-shooter with a modified internal body to hold more lead, with a cost. Close range only - past ten paces it's just noise. \
	Inside ten paces, it lives up to its name."
	icon_state = "pistol"
	item_state = "pistol"
	force = 14
	spread = 6
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	var/rounds_remaining = 5
	var/pending_rounds = 0

/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller/Initialize(mapload)
	. = ..()
	chambered = new /obj/item/ammo_casing/caseless/bullet/lead(src)
	reloaded = TRUE
	gunpowder = TRUE

/obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_casing))
		if(!istype(A, /obj/item/ammo_casing/caseless/bullet/lead))
			to_chat(user, span_warning("The [src] only fires lead balls."))
			return
		if(!gunpowder)
			to_chat(user, span_warning("You must fill the [src] with smokepowder first!"))
			return
		if(pending_rounds + rounds_remaining + (chambered ? 1 : 0) >= 6)
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
	return TRUE

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
// VENATOR - three-shot bolt-action rifle
// purchase_sound_key = "mediumgun"
// Holds 3 lead spheres. Rack the bolt (right-click) between shots.
// =====================================================
/obj/item/gun/ballistic/firearm/flintgonne/venator
	name = "venator"
	desc = "A modified Otavan flintgonne with a hexagonal barrel, it has a bolt racking mechanism. Unreliable, but accurate for its class, and markedly difficult to find. \
	Someone clearly had it stolen from the Inquisition, and modified it."
	icon_state = "pistol"
	item_state = "pistol"
	force = 12
	spread = 2
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	var/rounds_remaining = 2
	var/pending_rounds = 0

/obj/item/gun/ballistic/firearm/flintgonne/venator/Initialize(mapload)
	. = ..()
	chambered = new /obj/item/ammo_casing/caseless/bullet/lead(src)
	reloaded = TRUE
	gunpowder = TRUE

/obj/item/gun/ballistic/firearm/flintgonne/venator/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_casing))
		if(!istype(A, /obj/item/ammo_casing/caseless/bullet/lead))
			to_chat(user, span_warning("The [src] only fires lead balls."))
			return
		if(!gunpowder)
			to_chat(user, span_warning("You must fill the [src] with smokepowder first!"))
			return
		if(pending_rounds + rounds_remaining + (chambered ? 1 : 0) >= 3)
			to_chat(user, span_warning("The [src]'s bolt is already packed to capacity!"))
			return
		playsound(src, "modular_helmsguard/sound/arquebus/insert.ogg", 100)
		user.visible_message(span_notice("[user] slides a lead ball into the [src]."))
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

// Right-click to cycle the bolt and ready the next round.
/obj/item/gun/ballistic/firearm/flintgonne/venator/attack_right(mob/user)
	if(user.get_active_held_item())
		return
	if(reloaded)
		to_chat(user, span_notice("The [src] is already cocked."))
		return
	if(!rounds_remaining && (!magazine || !magazine.ammo_count()))
		to_chat(user, span_warning("The [src]'s cylinder is empty."))
		return
	playsound(src, 'modular_helmsguard/sound/arquebus/musketcock.ogg', 80, TRUE)
	user.visible_message(span_notice("[user] racks the bolt on [src]."))
	addtimer(CALLBACK(src, PROC_REF(cycle_bolt)), 1 SECONDS)

/obj/item/gun/ballistic/firearm/flintgonne/venator/proc/cycle_bolt()
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
	else
		chamber_round()
		if(chambered)
			reloaded = TRUE
			gunpowder = TRUE

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
	icon = 'icons/roguetown/weapons/guns32.dmi'
	icon_state = "blunderbuss"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	item_state = "blunderbuss"
	bigboy = FALSE
	gripsprite = FALSE
	cartridge_wording = "grapeshot"
	force = 22
	spread = 15
	var/rounds_remaining = 0
	var/pending_grapeshots = 0

/obj/item/gun/ballistic/firearm/devastator/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/gun/ballistic/firearm/devastator/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/quiver/bullet/grapeshot))
		var/obj/item/quiver/bullet/grapeshot/Q = A
		if(!gunpowder)
			to_chat(user, span_warning("You must fill the [src] with smokepowder first!"))
			return
		if(!length(Q.arrows))
			to_chat(user, span_warning("There is no grapeshot left in [Q]."))
			return
		if(pending_grapeshots + rounds_remaining + (chambered ? 1 : 0) >= 2)
			to_chat(user, span_warning("The [src] is already fully loaded!"))
			return
		var/obj/item/ammo_casing/caseless/bullet/grapeshot/shot = Q.arrows[Q.arrows.len]
		Q.arrows -= shot
		qdel(shot)
		Q.update_icon()
		playsound(src, "modular_helmsguard/sound/arquebus/insert.ogg", 100)
		user.visible_message(span_notice("[user] forces a grapeshot down the barrel of the [src]."))
		pending_grapeshots++
		return
	if(istype(A, /obj/item/ammo_casing))
		if(!istype(A, /obj/item/ammo_casing/caseless/bullet/grapeshot))
			to_chat(user, span_warning("The [src] only fires grapeshot."))
			return
		if(!gunpowder)
			to_chat(user, span_warning("You must fill the [src] with smokepowder first!"))
			return
		if(pending_grapeshots + rounds_remaining + (chambered ? 1 : 0) >= 2)
			to_chat(user, span_warning("The [src] is already fully loaded!"))
			return
		playsound(src, "modular_helmsguard/sound/arquebus/insert.ogg", 100)
		user.visible_message(span_notice("[user] forces a [A] down the barrel of the [src]."))
		pending_grapeshots++
		qdel(A)
		return
	if(istype(A, /obj/item/ramrod) && pending_grapeshots > 0)
		var/obj/item/ramrod/R = A
		var/firearm_skill = user.get_skill_level(/datum/skill/combat/firearms)
		user.visible_message(span_notice("[user] begins ramming the [R.name] down the barrel of the [src]."))
		playsound(src, "modular_helmsguard/sound/arquebus/ramrod.ogg", 100)
		if(do_after(user, load_time - (firearm_skill * 2), src))
			user.visible_message(span_notice("[user] has finished loading the [src]."))
			if(chambered)
				rounds_remaining += pending_grapeshots
			else
				rounds_remaining = pending_grapeshots - 1
				chambered = new /obj/item/ammo_casing/caseless/bullet/grapeshot(src)
			pending_grapeshots = 0
			reloaded = TRUE
		return
	return ..()

/obj/item/gun/ballistic/firearm/devastator/can_shoot()
	if(!chambered)
		return FALSE
	return TRUE

/obj/item/gun/ballistic/firearm/devastator/shoot_live_shot(mob/living/user, pointblank = 0, mob/pbtarget = null, message = 1)
	if(recoil)
		shake_camera(user, recoil + 1, recoil)
	playsound(user, 'modular_underbelly/sound/gun/fire_devastator.ogg', fire_sound_volume, vary_fire_sound)
	show_sensory_effect(user, 5, "gunfire", user.dir)
	if(message)
		user.visible_message(span_danger("[user] shoots [src]!"), span_danger("I shoot [src]!"), COMBAT_MESSAGE_RANGE)

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
// DEFACER - spiked knuckle-knife
// purchase_sound_key = "spikedknucks"
// =====================================================
/obj/item/rogueweapon/katar/punchdagger/defacer
	name = "defacer"
	desc = "A punchdagger with a very sharp steel tooth welded along the top of the grip. \
	It'll open a face just as easily as a door."
	force = 14
	force_wielded = 18
	icon_state = "punchdagger"
