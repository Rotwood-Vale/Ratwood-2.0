/obj/item/gun/ballistic/firearm/handgonne
	name = "handgonne"
	desc = "A tube of steel and hope. \
	An invention of Grenzelhoft siege smiths, independent of the Naledi conclave, yet reliant on smokepowder all the same. \
	Etched into the stock is a workshop stamp, though the production number is scratched off..."
	icon = 'modular_helmsguard/icons/weapons/handgonne.dmi'
	icon_state = "handgonne"
	item_state = "handgonne"

/obj/item/gun/ballistic/firearm/handgonne/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
			adjust_experience(user, /datum/skill/combat/firearms, user.STAINT * 4)
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	gunpowder = FALSE
	reloaded = FALSE
	spark_act()

	playsound(src, "modular_helmsguard/sound/arquebus/fuse.ogg", 100)

	var/released_spread = spread
	spawn(rand(10,20))
		..(target, user, message, params, zone_override, bonus_spread, released_spread)

/obj/item/gun/ballistic/firearm/flintgonne
	name = "flintgonne"
	desc = "A smokepowder rifle of Aavnic make. \
	This particular example is forged in large quantities for the newly formed Royal Strelki, to be used against the recent inhumen revolts in the region. \
	Its presence further south is rare, but not unheard of. A true blend of cost-effectiveness."
	icon = 'modular_helmsguard/icons/weapons/flintgonne.dmi'//Not Helmsguard. OldRW original, I think? But it's no better a place to put it.
	icon_state = "flintgonne"
	item_state = "flintgonne"
	var/fire_delay = 4//Reliable, unlike the handgonne, but not instant.

//Handgonne, but quicker. Much quicker. But still not point and fire.
/obj/item/gun/ballistic/firearm/flintgonne/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
			adjust_experience(user, /datum/skill/combat/firearms, user.STAINT * 4)
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	gunpowder = FALSE
	reloaded = FALSE
	spark_act()

	playsound(src, "sound/items/flint.ogg", 100)

	var/released_spread = spread
	spawn(fire_delay)
		..(target, user, message, params, zone_override, bonus_spread, released_spread)

/obj/item/gun/ballistic/firearm/flintgonne/fusil
	name = "fusil"
	desc = "A smokepowder rifle of Otavii modification, provided in scant numbers to the even fewer fuseliers that remain. \
	A pairing of a Naledi-borne arquebus, with a similar mechanism to an Aavnic flintgonne."
	icon = 'modular_helmsguard/icons/weapons/fusil.dmi'//Not Helmsguard. Again. But no better a place to put it.
	icon_state = "fusil"//Flintgonne and Arquebus kitbash.
	item_state = "fusil"
	fire_delay = 8//Double the delay on firing speed when pulling the trigger.
