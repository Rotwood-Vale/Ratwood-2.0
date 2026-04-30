/obj/item/gun/ballistic/firearm/handgonne
	name = "handgonne"
	desc = "A tube of steel and hope. \
	An invention of Grenzelhoft siege smiths, independent of the Naledi conclave, yet reliant on smokepowder all the same. \
	Etched into the stock is a workshop stamp, though the production number is scratched off..."
	icon = 'modular_helmsguard/icons/weapons/handgonne.dmi'
	icon_state = "handgonne"
	item_state = "handgonne"

/obj/item/gun/ballistic/firearm/handgonne/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	var/accident_chance = 0
	var/firearm_skill = (user.get_skill_level(/datum/skill/combat/firearms))
	var/turf/knockback = get_ranged_target_turf(user, turn(user.dir, 180), rand(1,2))
	spread = (spread_num - firearm_skill)
	if(firearm_skill < 1)
		accident_chance =80

	if(firearm_skill < 2)
		accident_chance =50
	if(firearm_skill >= 2 && firearm_skill < 5)
		accident_chance =10
	if(firearm_skill >= 5)
		accident_chance =0
	if(HAS_TRAIT(user, TRAIT_FUSILIER))//Regardless of skill, we force it to 0 if you're trained properly.
		accident_chance =0
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

	spawn(rand(10,20))
		..()
		spawn (1)
			new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))
		spawn (5)
			new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 2))
		spawn (12)
			new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))

		for(var/mob/M in range(5, user))
			if(!M.stat)
				shake_camera(M, 3, 1)

		if(prob(accident_chance))
			user.flash_fullscreen("whiteflash")
			user.apply_damage(rand(5,15), BURN, pick(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND))
			user.visible_message(span_danger("[user] accidentally burnt themselves while firing the [src]."))
			user.emote("painscream")
			if(prob(60))
				user.dropItemToGround(src)
				user.Knockdown(rand(15,30))
				user.Immobilize(30)

		if(prob(accident_chance))
			user.visible_message(span_danger("[user] is knocked back by the recoil!"))
			user.throw_at(knockback, rand(1,2), 7)
			if(prob(accident_chance))
				user.dropItemToGround(src)
				user.Knockdown(rand(15,30))
				user.Immobilize(30)

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
	var/accident_chance = 0
	var/firearm_skill = (user.get_skill_level(/datum/skill/combat/firearms))
	var/turf/knockback = get_ranged_target_turf(user, turn(user.dir, 180), rand(1,2))
	spread = (spread_num - firearm_skill)
	if(firearm_skill < 1)
		accident_chance =80

	if(firearm_skill < 2)
		accident_chance =50
	if(firearm_skill >= 2 && firearm_skill < 5)
		accident_chance =10
	if(firearm_skill >= 5)
		accident_chance =0
	if(HAS_TRAIT(user, TRAIT_FUSILIER))//Regardless of skill, we force it to 0 if you're trained properly.
		accident_chance =0
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

	spawn(fire_delay)
		..()
		spawn (1)
			new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))
		spawn (5)
			new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 2))
		spawn (12)
			new/obj/effect/particle_effect/smoke/arquebus(get_ranged_target_turf(user, user.dir, 1))

		for(var/mob/M in range(5, user))
			if(!M.stat)
				shake_camera(M, 3, 1)

		if(prob(accident_chance))
			user.flash_fullscreen("whiteflash")
			user.apply_damage(rand(5,15), BURN, pick(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND))
			user.visible_message(span_danger("[user] accidentally burnt themselves while firing the [src]."))
			user.emote("painscream")
			if(prob(60))
				user.dropItemToGround(src)
				user.Knockdown(rand(15,30))
				user.Immobilize(30)

		if(prob(accident_chance))
			user.visible_message(span_danger("[user] is knocked back by the recoil!"))
			user.throw_at(knockback, rand(1,2), 7)
			if(prob(accident_chance))
				user.dropItemToGround(src)
				user.Knockdown(rand(15,30))
				user.Immobilize(30)

/obj/item/gun/ballistic/firearm/flintgonne/fusil
	name = "fusil"
	desc = "A smokepowder rifle of Otavii modification, provided in scant numbers to the even fewer fuseliers that remain. \
	A pairing of a Naledi-borne arquebus, with a similar mechanism to an Aavnic flintgonne."
	icon = 'modular_helmsguard/icons/weapons/fusil.dmi'//Not Helmsguard. Again. But no better a place to put it.
	icon_state = "fusil"//Flintgonne and Arquebus kitbash.
	item_state = "fusil"
	fire_delay = 8//Double the delay on firing speed when pulling the trigger.
