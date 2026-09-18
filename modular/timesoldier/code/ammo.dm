/obj/item/ammo_casing/brutal_round
	name = "zizite killer round"
	desc = "<span class='yellow'><i>We've been fighting this war against the Zizites for decades. It's been over 60 years by now. <br>It's exhausting. Though, after the efforts from Kingsfield and from the Zybantine sands, we've managed to create something beyond the lead spheres of the past. This turns any deadite to gore, and any skeleton's bones to dust.<br> No matter how hard their Avantyne is.</i></span>"
	icon = 'modular/timesoldier/sprites/gun.dmi'
	icon_state = "lcasing1"
	caliber = "brutal"
	projectile_type = /obj/projectile/bullet/firearm/brutal_round


/obj/projectile/bullet/firearm/brutal_round
	name = "zizite killer round"
	hitscan = TRUE
	damage = 200
	armor_penetration = 95
	range = 60
	ammo_type = /obj/item/ammo_casing/brutal_round

/obj/item/ammo_casing/brutal_round/update_icon()
	..()
	if(!BB)
		icon_state = "lcasing-spent"
		name = "spent zizite killer round"
	else
		icon_state = initial(icon_state)
		name = initial(name)
