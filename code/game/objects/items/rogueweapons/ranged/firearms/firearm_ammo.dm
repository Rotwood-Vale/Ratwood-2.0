/**
 * Parent bullet.
 */
/obj/item/ammo_casing/caseless/bullet
	name = "PARENT SPHERE"
	desc = "YOU SHOULD NOT BE SEEING THIS. YELL AT CARL!!!"
	projectile_type = /obj/projectile/bullet/firearm
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball"
	possible_item_intents = list(/datum/intent/use)
	dropshrink = 0.5
	max_integrity = 0.1
	w_class = WEIGHT_CLASS_TINY

/obj/projectile/bullet/firearm
	name = "PARENT SMOKEPOWDER PROJECTILE"
	damage = 80//Do you see how infrequently these things fire...
	armor_penetration = 90//... and yet I need to explain?
	range = 30//We want this to go a few screens. Regardless.
	embedchance = 100//Yessir.
	speed = 0.1//Take a guess.
	npc_simple_damage_mult = 4//320, at 80 base.
	accuracy = 90//Their point. Very slow firing. Yet powerful and accurate.
	bonus_accuracy = 10//As opposed to using PER.
	damage_type = BRUTE
	woundclass = BCLASS_PIERCE//This assures pen, similar to crossbows.
	flag = "piercing"//Vestigial, but just in case we use another flag later.
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/bullet
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	var/stumble_strength = 4

/**
 * Generic ammo used by handgonnes and arquebuses
 */

/obj/item/ammo_casing/caseless/bullet/lead
	name = "lead sphere"
	desc = "A small lead sphere. This should go well with smokepowder."
	projectile_type = /obj/projectile/bullet/firearm/lead
	caliber = "lead_sphere"

/obj/projectile/bullet/firearm/lead
	name = "lead sphere"
	ammo_type = /obj/item/ammo_casing/caseless/bullet/lead

/obj/projectile/bullet/firearm/lead/on_hit(atom/target)
	. = ..()

	var/mob/living/L = firer
	if(!L || !L.mind)
		return

	var/skill_multiplier = 0

	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4

	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/firearms, SKILL_LEVEL_EXPERT))
		L.mind.add_sleep_experience(/datum/skill/combat/firearms, L.STAINT * skill_multiplier)

/**
 * Now, actual grapeshot, for the proper blunderbuss.
 */

/obj/item/ammo_casing/caseless/bullet/grapeshot
	name = "grapeshot"
	desc = "A collection of tiny metal beads. This should go well with smokepowder."
	projectile_type = /obj/projectile/bullet/firearm/grapeshot
	caliber = "grapeshot"
	icon_state = "grapeshot"
	pellets = 6//180 point blank, based on 30 damage.
	variance = 30

/obj/projectile/bullet/firearm/grapeshot
	name = "grapeshot"
	damage = 30
	range = 15
	npc_simple_damage_mult = 4//720 potential, if all hit.
	ammo_type = /obj/item/ammo_casing/caseless/bullet/grapeshot
	stumble_strength = 1//6 potential, if all hit.

/obj/projectile/bullet/firearm/grapeshot/on_hit(atom/target)
	. = ..()

	var/mob/living/L = firer
	if(!L || !L.mind)
		return

	var/skill_multiplier = 0

	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4

	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/firearms, SKILL_LEVEL_EXPERT))
		L.mind.add_sleep_experience(/datum/skill/combat/firearms, L.STAINT * skill_multiplier)


/*
Firearms adjusted to be shrilly.
This isn't the rework I wanted but it's ok for now.

The beat of 1-12 CON raised to 1-14 on RNG, or you're FUCKED.
Rather than immob, though, it's 2 seconds of knockdown.
You also get a hematoma, on top of base wounds when losing that check.
That hematoma is primarily only really a consideration for the blunderbuss.
Which is meant to apply a ton on impact. It'll paste no-armour characters.
Given every single blunderbuss projectile is checked. Teehee.

Additionally, we now apply staggered for already high stumble projectiles.
That is to say, we do away with stumble strength being used for slowdown if it's high enough, instead applying staggered.
So no stagger faffery with a blunderbuss, though standard rifles will apply it every hit. Blunderbuss is already strong enough.
A reminder that staggered, at time of addition, is a slow of 50% (1.5 multiplicative slowdown) & -2SPD/PER/CON, for 10 seconds.
- Carl
*/
/obj/projectile/bullet/firearm/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		var/list/screams = list("painscream", "paincrit", "agony")
		var/check = rand(1, 14)//Higher than 14CON to beat this every time.
		if(isliving(target))
			if(stumble_strength >= 4)//We only want this applied for standard projectiles.
				M.apply_status_effect(/datum/status_effect/debuff/staggered)
			else//Otherwise, fallback to that old application.
				M.Slowdown(stumble_strength)
			if(check > M.STACON)//Has to beat, not meet.
				M.emote(screams)//MY INSIDES ARE ON THE OUTSIDE!!!
				M.Knockdown(2 SECONDS)
				var/obj/item/bodypart/BP = M.get_bodypart(def_zone)
				BP.add_wound(/datum/wound/bruise/large)//Blunderbuss my beloved.
				BP.update_disabled()

//The actual pouches.
/obj/item/quiver/bullet
	name = "lead ball pouch"
	desc = "This pouch can hold a handful of musket balls, or, perhaps, grapeshot."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "slingpouch"//Need another sprite.
	item_state = "slingpouch"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_NECK
	max_storage = 8
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 64
	grid_width = 32

/obj/item/quiver/bullet/can_store_ammo(obj/item/ammo_casing/ammo)
	return istype(ammo, /obj/item/ammo_casing/caseless/bullet) && ammo.type != /obj/item/ammo_casing/caseless/bullet

/obj/item/quiver/bullet/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/bullet in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(bullet))
				break

/obj/item/quiver/bullet/attackby(obj/A, loc, params)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/bullet))
		if(arrows.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				if(!M.doUnEquip(A, TRUE, src, FALSE, silent = TRUE))
					return TRUE
			else
				A.forceMove(src)
			arrows |= A
			update_icon()
		else
			to_chat(loc, span_warning("Full!"))
		return
	if(istype(A, /obj/item/gun/ballistic/firearm))
		load_into_weapon(A, loc, params)
		return TRUE
	..()

/obj/item/quiver/bullet/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/bullet/update_icon()
	return

/obj/item/quiver/bullet/lead/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/bullet/lead/B = new(src)
		arrows += B
	update_icon()

/obj/item/quiver/bullet/grapeshot/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/bullet/grapeshot/B = new(src)
		arrows += B
	update_icon()
