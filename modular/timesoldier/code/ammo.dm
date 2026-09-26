/obj/item/ammo_casing/brutal_round
	name = "zizite killer round"
	desc = "<span class='yellow'><i>We've been fighting this war against the Zizites for decades. It's been over 60 years by now. <br>It's exhausting. Though, after the efforts from Kingsfield and from the Zybantine sands, we've managed to create something beyond the lead spheres of the past. This turns any deadite to gore, and any skeleton's bones to dust.<br> No matter how hard their Avantyne is.</i></span>"
	icon = 'modular/timesoldier/sprites/nu_guns.dmi'
	icon_state = "kz41_bullet"
	caliber = "brutal"
	projectile_type = /obj/projectile/bullet/firearm/brutal_round


/obj/projectile/bullet/firearm/brutal_round
	name = "zizite killer round"
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/tracer/aiming
	color = "#FFD45A"
	dismemberment = 20
	damage = 200
	armor_penetration = 95
	range = 60
	ammo_type = /obj/item/ammo_casing/brutal_round

/obj/item/quiver/bullet/brutals
	name = "BRUTALITY round box"
	desc = "<span class='yellow'><i>A box meant to dispense BRUTALITY towards Zizites, also known as BRUTAL rounds, or Zizite Killers.<br>When that crazy Dwarf from Kingsfield invented this kind of projectile that surpassed the lead sphere, the entire war on Zizo changed.<br>The Zizites barely adapted the blackpowder to their undead troops, but we adapted and overcame them.</i></span>"
	max_storage = 20 // this might be overkill. oh well!!! :wilted_rose:
	icon = 'modular/timesoldier/sprites/nu_guns.dmi'
	icon_state = "kz_box"

/obj/item/quiver/bullet/brutals/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/brutal_round/B = new()
		arrows += B
	update_icon()


/obj/item/ammo_casing/brutal_round/update_icon()
	..()
	if(!BB)
		icon_state = "kz41_spent"
		name = "spent zizite killer round"
	else
		icon_state = initial(icon_state)
		name = initial(name)


// yummy brain mush
/obj/projectile/bullet/firearm/brutal_round/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if (!ishuman(target))
		return
	
	var/mob/living/carbon/human/H = target

	if(blocked >= 100)
		return
	
	if(check_zone(def_zone) != BODY_ZONE_HEAD)
		return

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/fracture/head/brain, FALSE, TRUE)
	H.death()
	// a reference to simo hayha from record of ragnarok killing a god with a sniper bullet to the head.
	// the bullet is so fucking powerful, it bypasses godmode.
