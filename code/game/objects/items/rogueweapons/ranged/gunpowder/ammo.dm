/**
 * Generic ammo used by handgonnes and arquebuses
 */

/obj/projectile/bullet/lead
	name = "lead sphere"
	damage = 80	//higher damage than crossbow, previously 75
	damage_type = BRUTE
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/lead
	range = 25		//Higher than arrow, but not halfway through the entire town.
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_STAB
	flag = "piercing"
	armor_penetration = 90	//fuck ya armor . previously 75
	speed = 0.1
	npc_simple_damage_mult = 2	//annihilate simplemobs

/obj/projectile/bullet/lead/on_hit(atom/target)
	. = ..()

	var/mob/living/L = firer
	if(!L || !L.mind) return

	var/skill_multiplier = 0

	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 5

	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/firearms, SKILL_LEVEL_LEGENDARY))
		L.mind.add_sleep_experience(/datum/skill/combat/firearms, L.STAINT * skill_multiplier)

/obj/projectile/bullet/grapeshot
	name = "grapeshot"
	damage = 15
	damage_type = BRUTE
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/grapeshot
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_STAB
	flag = "piercing"
	armor_penetration = 75
	speed = 0.1
	npc_simple_damage_mult = 2

/obj/projectile/bullet/grapeshot/on_hit(atom/target)
	. = ..()

	var/mob/living/L = firer
	if(!L || !L.mind) return

	var/skill_multiplier = 0

	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 5

	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/firearms, SKILL_LEVEL_LEGENDARY))
		L.mind.add_sleep_experience(/datum/skill/combat/firearms, L.STAINT * skill_multiplier)

/obj/projectile/bullet/rogue/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		var/list/screams = list("painscream", "paincrit")
		var/check = rand(1, 20)
		if(isliving(target))
			if(check > M.STACON)
				M.emote(screams)
				M.Knockdown(rand(15,30))
				M.Immobilize(rand(30,60))


/obj/item/ammo_casing/caseless/rogue/lead
	name = "iron sphere"
	desc = "A small iron sphere. This should go well with gunpowder."
	projectile_type = /obj/projectile/bullet/lead
	caliber = "lead_sphere"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball"
	dropshrink = 0.5
	max_integrity = 0.1

/obj/item/ammo_casing/caseless/rogue/grapeshot
	name = "grapeshot"
	desc = "A collection of tiny metal beads. This should go well with gunpowder."
	projectile_type = /obj/projectile/bullet/grapeshot
	caliber = "grapeshot"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "grapeshot"
	dropshrink = 0.5
	max_integrity = 0.1
	pellets = 6
	variance = 30
