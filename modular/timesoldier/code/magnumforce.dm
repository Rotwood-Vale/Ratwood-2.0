//shoutout to those who have elite ball knowledge and know what the filename is a reference to.


/obj/item/gun/ballistic/heavysniper
	var/bolt_open = FALSE
	name = "KZ-41 'Last Rites'"
	desc = "<span class='yellow'><i>I can still remember when this weapon was given to us. We were fighting on the borders of Grenzelhoft with the Otavans, and this beauty came in a shipment alongside others, and some ammo.<br>We were...stunned at how effective it was. It killed deadites in a singular shot to the head, and tore through lyfeblood armor like it was hot butter. It wouldn't take long for it to be made a war-crime to use it on your fellow man.<br> KZ-41 - it stood for an obvious name.<br>KILL ZIZITES.</i></span>"
	icon = 'modular/timesoldier/sprites/gun.dmi'
	icon_state = "heavysniper"
	experimental_inhand = TRUE
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	mag_type = /obj/item/ammo_box/magazine/internal/heavysniper
	internal_magazine = TRUE
	semi_auto = FALSE // this is slightly misleading. process_chamber() starts with if !semi_auto return. without it, firing would let the normal ballistic code process the chamber immediately afterwards.
	load_sound = 'modular/timesoldier/sounds/kzload.ogg'
	fire_sound = 'modular/timesoldier/sounds/kzfire.ogg'
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/shoot/firearm, /datum/intent/arc/firearm, INTENT_GENERIC)
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	recoil = 4

/obj/item/ammo_box/magazine/internal/heavysniper
	name = "KZ-41 internal magazine"
	desc = "you shouldn't be seeing this i don't think."
	ammo_type = /obj/item/ammo_casing/brutal_round
	caliber = "brutal"
	max_ammo = 1
	multiload = 0
	start_empty = TRUE


/obj/item/gun/ballistic/heavysniper/attack_self(mob/living/user)
	if(wielded)
		ungrip(user)
		return
	wield(user)


/obj/item/gun/ballistic/heavysniper/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_casing/brutal_round)) 
		if(!bolt_open)
			to_chat(user, "<span class='red'>The bolt is closed. You can't load a round into the chamber.</span>")
			return
	return ..()


/obj/item/gun/ballistic/heavysniper/update_icon()
	..()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"


/obj/item/gun/ballistic/heavysniper/can_shoot()
	if(bolt_open)
		return FALSE
	return !!chambered?.BB // is the bolt closed, and is there actually a b ullet inside the chambered casing?

/obj/item/gun/ballistic/heavysniper/shoot_with_empty_chamber(mob/living/user as mob|obj)
	if(bolt_open)
		to_chat(user, "<span class='red'>The bolt is open. You can't fire the weapon.</span>")
		playsound(src, 'modular/timesoldier/sounds/gun_empty.ogg', 100)
		return
	return ..()


/obj/item/gun/ballistic/heavysniper/attack_right(mob/user)
	if(user.get_active_held_item()) // shout out to you carl for allowing me to blatantly paste your code from the other guns. i will forever love you.
		return
	if(!bolt_open)
		playsound(src, 'modular/timesoldier/sounds/kzopen.ogg', 50)
		bolt_open = TRUE
		if(chambered)
			chambered.forceMove(drop_location())
			chambered.bounce_away(TRUE)
			chambered = null
		update_icon()

	else
		playsound(src, 'modular/timesoldier/sounds/kzclose.ogg', 50)
		bolt_open = FALSE
		chamber_round()
		update_icon()

/obj/item/gun/ballistic/heavysniper/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(user.client)
		if(user.client.chargedprog >=100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0

	return ..()


/obj/item/gun/ballistic/heavysniper/getonmobprop(tag) // im just copying the arguebus values. if it works, it works i hope! edit: it worked great.
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.9,
					"sx" = -7, "sy" = 6,
					"nx" = 7,  "ny" = 6,
					"wx" = -2, "wy" = 3,
					"ex" = 1,  "ey" = 3,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = -43,
					"sturn" = 43,
					"wturn" = 30,
					"eturn" = -30,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 0
				)
			if("wielded")
				return list(
					"shrink" = 0.9,
					"sx" = 5,  "sy" = -2,
					"nx" = -5, "ny" = -1,
					"wx" = -8, "wy" = 2,
					"ex" = 8,  "ey" = 2,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 1,
					"nturn" = -45,
					"sturn" = 45,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 8,
					"eflip" = 0
				)
			if("onback")
				return list(
					"shrink" = 0.8,
					"sx" = -1, "sy" = 0,
					"nx" = 1,  "ny" = 0,
					"wx" = 0,  "wy" = 0,
					"ex" = 0,  "ey" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 90,
					"eturn" = -90,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0
				)


// looking at how temperance 13 does it.
/obj/item/gun/ballistic/heavysniper/shoot_live_shot(mob/living/user as mob|obj, pointblank = 0, mob/pbtarget = null, message = 1)
	..()
	for(var/mob/living/M in range(60, user))
		if(!M.client)
			continue

		var/dist = get_dist(M, user)

		if(dist >= 8 && dist <= 60)
			var/distant_volume = 60

			if(dist <= 30)
				distant_volume = 100

			M.playsound_local(
				get_turf(M),
				'modular/timesoldier/sounds/distant1.ogg',
				distant_volume,
				FALSE
			)



