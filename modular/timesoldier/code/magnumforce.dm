//shoutout to those who have elite ball knowledge and know what the filename is a reference to.


/obj/item/gun/ballistic/heavysniper
	var/bolt_open = FALSE
	name = "KZ-41 'Last Rites'"
	desc = "<span class='yellow'><i>I can still remember when this weapon was given to us. We were fighting on the borders of Grenzelhoft with the Otavans, and this beauty came in a shipment alongside others, and some ammo.<br>We were...stunned at how effective it was. It killed deadites in a singular shot to the head, and tore through lyfeblood armor like it was hot butter. It wouldn't take long for it to be made a war-crime to use it on your fellow man.<br> KZ-41 - it stood for an obvious name.<br>KILL ZIZITES.</i></span>"
	icon = 'modular/timesoldier/sprites/gun.dmi'
	icon_state = "heavysniper"
	mag_type = /obj/item/ammo_box/magazine/internal/heavysniper
	internal_magazine = TRUE
	semi_auto = FALSE // this is slightly misleading. process_chamber() starts with if !semi_auto return. without it, firing would let the normal ballistic code process the chamber immediately afterwards.

/obj/item/ammo_box/magazine/internal/heavysniper
	name = "KZ-41 internal magazine"
	desc = "you shouldn't be seeing this i don't think."
	ammo_type = /obj/item/ammo_casing/brutal_round
	caliber = "brutal"
	max_ammo = 1
	multiload = 0
	start_empty = TRUE


/obj/item/gun/ballistic/heavysniper/attack_self(mob/living/user)
	if(!bolt_open)
		bolt_open = TRUE
		if(chambered)
			chambered.forceMove(drop_location())
			chambered.bounce_away(TRUE)
			chambered = null
		update_icon()

	else
		bolt_open = FALSE
		chamber_round()
		update_icon()


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
