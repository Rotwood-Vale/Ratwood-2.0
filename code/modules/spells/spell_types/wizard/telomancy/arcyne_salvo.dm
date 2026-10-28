/obj/projectile/magic/arcyne_salvo
	name = "arcyne bolt"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "arcyne_bolt"
	damage = 30
	nodamage = FALSE
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	range = SPELL_RANGE_PROJECTILE
	speed = MAGE_PROJ_FAST
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	intdamfactor = 1
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'
	ricochets_max = 2
	ricochet_chance = 100
	ricochet_auto_aim_angle = 40
	ricochet_auto_aim_range = 5
	ricochet_incidence_leeway = 40
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1

/obj/projectile/magic/arcyne_salvo/arc
	name = "arced arcyne bolt"
	damage = 23
	arcshot = TRUE

/obj/projectile/magic/arcyne_salvo/on_hit(target)
	hitsound = pick('sound/combat/hits/blunt/shovel_hit.ogg', 'sound/combat/hits/blunt/shovel_hit2.ogg', 'sound/combat/hits/blunt/shovel_hit3.ogg')
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] dissipates harmlessly against [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()
