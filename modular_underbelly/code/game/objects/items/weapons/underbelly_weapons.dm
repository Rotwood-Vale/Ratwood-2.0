/*
	UNDERBELLY EXCLUSIVE WEAPONS
	Four weapons unique to the Criminal Underbelly. Not sold anywhere else.
	Gut Spiller - compact close-range firearm, the Gutter King's signature.
	Venator      - medium-range reliable sidearm for the well-funded Scum.
	Devastator   - heavy long-arm, devastating but ponderous.
	Defacer      - spiked steel knuckles, hits harder but breaks faster.
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
	icon_state = "pistol3"
	item_state = "pistol3"
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
	if(istype(A, /obj/item/quiver/bullet/lead))
		var/obj/item/quiver/bullet/lead/Q = A
		var/mob/living/carbon/human/H = user
		if(!istype(H) || H.job != "Scum")
			to_chat(user, span_warning("Only Scum know how to spin-load the [src]."))
			return
		if(!gunpowder)
			to_chat(user, span_warning("You must fill the [src] with smokepowder first!"))
			return
		var/free_rounds = 6 - (pending_rounds + rounds_remaining + (chambered ? 1 : 0))
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
	icon_state = "flintgonne"
	item_state = "flintgonne"
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
	var/max_capacity = 4
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
	if(!istype(G) || !(istype(G, /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller) || istype(G, /obj/item/gun/ballistic/firearm/flintgonne/venator) || istype(G, /obj/item/gun/ballistic/firearm/devastator)))
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
	if(!istype(G) || !(istype(G, /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller) || istype(G, /obj/item/gun/ballistic/firearm/flintgonne/venator) || istype(G, /obj/item/gun/ballistic/firearm/devastator)))
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
	if(istype(target, /obj/item/gun/ballistic/firearm/flintgonne/venator))
		var/obj/item/gun/ballistic/firearm/flintgonne/venator/G = target
		if(G.rounds_remaining >= 3)
			to_chat(user, span_warning("[G] already has a capacity upgrade fitted."))
			return
		G.rounds_remaining++
		to_chat(user, span_notice("You fit the [src] into [G]. One more ball in the bolt housing."))
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
	if(!istype(G) || !(istype(G, /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller) || istype(G, /obj/item/gun/ballistic/firearm/flintgonne/venator) || istype(G, /obj/item/gun/ballistic/firearm/devastator)))
		to_chat(user, span_warning("[src] can only be fitted to underbelly firearms."))
		return
	if(G.aim_upgrade)
		to_chat(user, span_warning("[G] already has filed sights fitted."))
		return
	G.aim_upgrade = TRUE
	G.spread_num = max(0, G.spread_num - 3)
	to_chat(user, span_notice("You fit the [src] onto [G]. The sights are sharper now."))
	qdel(src)
