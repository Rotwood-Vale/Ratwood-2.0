/obj/effect/temp_visual/small_smoke/gunsmoke //smoke visual
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/small_smoke/gunsmoke/Initialize(mapload, set_dir, size_mult = 1)
	. = ..()
	if(set_dir)
		dir = set_dir
	var/matrix/M = matrix()
	M.Turn(rand(-45, 45))
	M.Scale((rand(11, 16) / 10) * size_mult)
	var/drift_x = 0
	var/drift_y = 0
	switch(dir)
		if(NORTH)
			drift_y = rand(8, 16)
			drift_x = rand(-8, 8)
		if(SOUTH)
			drift_y = rand(-16, -8)
			drift_x = rand(-8, 8)
		if(EAST)
			drift_x = rand(8, 16)
			drift_y = rand(-8, 8)
		if(WEST)
			drift_x = rand(-16, -8)
			drift_y = rand(-8, 8)

	M.Translate(drift_x, drift_y)
	spawn(1)
		if(src)
			animate(src, transform = M, alpha = 0, time = rand(10, 15), easing = SINE_EASING | EASE_OUT)
			spawn(20)
				if(src)
					qdel(src)

/obj/effect/temp_visual/small_smoke/gunsmoke/black
	color = COLOR_BLACK

/obj/item/gun/ballistic/revolver/rune/twilight_runelock
	name = "runelock pistol"
	desc = "An extremely lethal weapon. Uses runic magic instead of smokepowder."
	icon = 'icons/roguetown/weapons/guns32.dmi'
	icon_state = "runepistol2"
	var/icon_state_ready = "runepistol2-1"
	var/default_icon_state = "runepistol2"
	item_state = "runepistol2"
	possible_item_intents = list(/datum/intent/shoot/twilight_runelock, /datum/intent/arc/twilight_runelock, INTENT_GENERIC)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/twilight_runelock
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_BULKY
	spread = 10
	recoil = 3
	force = 10
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME | CLAMP_BREAK
	var/cocked = FALSE
	cartridge_wording = "runed sphere"
	load_sound = 'sound/firearm/musketload.ogg'
	fire_sound = 'sound/firearm/musketfire2.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 200
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel
	var/misfire_chance = 0
	var/reload_time = 8
	var/reload_stamina_cost = 30
	damfactor = 1
	per_scales_damage = TRUE
	var/critfactor = 0.7
	var/npcdamfactor = 4
	equip_delay_self = 1 SECONDS
	unequip_delay_self = 1 SECONDS
	inv_storage_delay = 1 SECONDS

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 30,"sturn" = -30,"wturn" = -30,"eturn" = 30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/shoot_with_empty_chamber()
	if(cocked)
		playsound(src.loc, 'sound/firearm/musketcock.ogg', 100, FALSE)
		cocked = FALSE
		icon_state = initial(icon_state)
		update_icon()

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/attack_self(mob/living/user)
	if(twohands_required)
		return
	if(altgripped || wielded)
		ungrip(user)
		return
		
	if(!cocked)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(HAS_TRAIT(H, TRAIT_INQUISITION) || (H.STAINT >= 15) || (H.merctype == 10))
				to_chat(H, span_info("I begin channeling runic energy into the runelock..."))
				var/adj_load_time = reload_time * 10
				if(H.mind)
					var/skill = H.get_skill_level(/datum/skill/combat/firearms)
					if(skill)
						adj_load_time = (reload_time * 10) / max(1, skill)
						
				if(do_after(H, adj_load_time, src))
					H.stamina_add(reload_stamina_cost)
					playsound(H, 'sound/magic/charged.ogg', 100, FALSE)
					user.visible_message(span_notice("[user] charges the runes along \the [src] with mana."))
					cocked = TRUE
			else
				to_chat(H, span_warning("I have absolutely no idea how to use this!"))
		else
			to_chat(user, span_warning("I have absolutely no idea how to use this!"))
	else
		if(alt_grips)
			altgrip(user)
		if(gripped_intents)
			wield(user)
			
	update_icon()

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/update_icon()
	if(cocked && icon_state_ready)
		icon_state = icon_state_ready
		item_state = icon_state_ready
	else
		icon_state = default_icon_state
		item_state = default_icon_state
	if(!ismob(loc))
		return
	var/mob/M = loc
	M.update_inv_hands()

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/powderflask))
		to_chat(user, span_warning("This weapon uses runic magic, not crude smokepowder! Channel its energy directly instead."))
		return
		
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		if(cocked)
			if((loc == user) && (user.get_inactive_held_item() != src) && (user.get_active_held_item() != src))
				return
			..()
		else
			to_chat(user, span_warning("I need to charge the runelock first!"))

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/examine(mob/living/carbon/human/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/u = user
		if(HAS_TRAIT(u, TRAIT_INQUISITION) || (u.STAINT >= 15) || (u.merctype == 10))
			if(cocked)
				if(chambered)
					. += span_notice("The runes are charged and the sphere is chambered. The weapon is ready to fire.")
				else
					. += span_notice("The runes are charged with energy, but no sphere is inserted.")
			else
				. += span_notice("Not charged.")
		else
			. += span_notice("The construction of the lock on this weapon is unfamiliar to you.")

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Runic locks require a special runed sphere. The weapon must be channeled with mana, loaded with a sphere, and then rammed with a rod before firing.")

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(chambered && HAS_TRAIT(user, TRAIT_PACIFISM))
		if(chambered.harmful)
			to_chat(user, span_warning("[src] is lethally chambered! You don't want to risk harming anyone..."))
			return
	var/skill = user.get_skill_level(/datum/skill/combat/firearms)
	if(skill)
		misfire_chance = max(0, misfire_chance - (skill * 2))
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	if(prob(misfire_chance))
		to_chat(user, span_warning("The [name] misfires!"))
		explosion(src, light_impact_range = 2, heavy_impact_range = 1, smoke = FALSE, soundin = 'sound/misc/explode/bomb.ogg')
		qdel(src)
		return
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/bullet/firearm/BB = CB.BB
		if(BB)
			BB.gunpowder_npc_critfactor *= npcdamfactor
			BB.critfactor *= critfactor
			BB.damage *= damfactor * get_per_damage_scaling(user)
	cocked = FALSE
	update_icon()
	var/shoot_dir = get_dir(src, target)
	new /obj/effect/temp_visual/small_smoke/gunsmoke(get_step(user, shoot_dir), shoot_dir)
	..()

/obj/item/ammo_box/magazine/internal/shot/twilight_runelock
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead/runelock
	caliber = "runed_sphere"
	max_ammo = 1
	start_empty = TRUE

/datum/intent/shoot/twilight_runelock
	chargedrain = 0

/datum/intent/shoot/twilight_runelock/get_chargetime()
	if(mastermob && chargetime)
		var/newtime = chargetime
		newtime = newtime + 75
		newtime = newtime / max(1, mastermob.get_skill_level(/datum/skill/combat/firearms))
		newtime = newtime + 20
		newtime = newtime - ((mastermob.STAPER)*1.5)
		if(newtime > 10)
			return newtime
		else
			return 10
	return chargetime

/datum/intent/arc/twilight_runelock
	chargetime = 1
	chargedrain = 0

/datum/intent/arc/twilight_runelock/get_chargetime()
	if(mastermob && chargetime)
		var/newtime = chargetime
		newtime = newtime + 70
		newtime = newtime / max(1, mastermob.get_skill_level(/datum/skill/combat/firearms))
		newtime = newtime + 20
		newtime = newtime - ((mastermob.STAPER)*1.5)
		if(newtime > 10)
			return newtime
		else
			return 10
	return chargetime

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/rifle
	name = "\"Doomsdae\""
	desc = "A relic of a new era, forged for the war that will end the history of creation as we know it. Crafted by Otavan master artificers and enchanted by the rune mages of Otava, this runic rifle is a weapon meant to crush the legions of darkness at the End of Times. The runes along its barrel are inscribed with the blood of heretics who paid for their betrayal of the true faith with their lives."
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "runelock"
	icon_state_ready = "runelock_loaded"
	default_icon_state = "runelock"
	item_state = "runelock"
	force_wielded = 15
	associated_skill = /datum/skill/combat/staves
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/shoot/twilight_runelock, /datum/intent/arc/twilight_runelock, INTENT_GENERIC)
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	experimental_onback = TRUE
	bigboy = TRUE
	wlength = WLENGTH_LONG
	slot_flags = ITEM_SLOT_BACK
	wdefense = 3
	can_parry = TRUE
	minstr = 6
	walking_stick = TRUE
	damfactor = 2
	critfactor = 1
	reload_time = 40
	reload_stamina_cost = 80

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/rifle/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 6,"nx" = 7,"ny" = 6,"wx" = -2,"wy" = 3,"ex" = 1,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -43,"sturn" = 43,"wturn" = 30,"eturn" = -30, "nflip" = 0, "sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -1,"wx" = -8,"wy" = 2,"ex" = 8,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -45,"sturn" = 45,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/gun/ballistic/revolver/rune/twilight_runelock/lesser
	name = "runelock pistol"
	desc = "A hastily-inscribed runelock. The runes are shallow and the channeling inefficient"
	damfactor = 0.8
