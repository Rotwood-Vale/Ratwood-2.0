/obj/projectile/magic/bloodlightning
	name = "blood bolt"
	expose_caster_on_deflect = TRUE
	tracer_type = /obj/effect/projectile/tracer/blood
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	damage = 80
	damage_type = BURN
	nodamage = FALSE
	speed = 0.3
	flag = "fire"
	light_color = "#802121"
	light_outer_range = 7

/obj/projectile/magic/bloodlightning/on_hit(target, blocked = FALSE)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			if(out_of_effective_range())
				return
			if(blocked < 100)
				L.lightning_shock(src)
	qdel(src)
