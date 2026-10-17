#define MT_STYGIAN "stygian"
#define STYGIAN_DR_DURATION 1 SECONDS

/obj/projectile/energy/stygian
	name = "stygian harpe"
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	range = 7 // Let you pressure a whole screen, in theory
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "stygian"
	max_range = MAGE_LONG_PROJ_RANGE // Effective range is lower than its maximal range
	damage = 34
	damage_type = BRUTE
	woundclass = BCLASS_STAB
	armor_penetration = PEN_LIGHT
	speed = MAGE_PROJ_VERY_SLOW
	flag = "stab"
	hitsound = 'sound/combat/hits/bladed/genstab (1).ogg'
	var/reduced_damage = 7 // 34 + 7 * 4 = 62. A point blank is gonna be as much damage as most of your melee Ferramantic attack, on purpose as a ranged pressure tool as not as a replacement to compete with your fancy NotSpecial

/obj/projectile/energy/stygian/prehit(atom/target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.mob_timers[MT_STYGIAN] && world.time < M.mob_timers[MT_STYGIAN] + STYGIAN_DR_DURATION)
			damage = reduced_damage
			no_crit = TRUE
		else
			M.mob_timers[MT_STYGIAN] = world.time
	return ..()

/obj/projectile/energy/stygian/on_hit(target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] shatters harmlessly against [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()

#undef MT_STYGIAN
#undef STYGIAN_DR_DURATION
