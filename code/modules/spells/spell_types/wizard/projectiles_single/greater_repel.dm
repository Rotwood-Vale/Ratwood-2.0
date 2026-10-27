/datum/action/cooldown/spell/projectile/repel/greater
	name = "Greater Repel"
	desc = "Shoot out a magical bolt that pushes whatever it strikes away from the caster, be it a freestanding item or a creature. Instead of repelling a target, it will throw an object in your hand if cast while in throw mode."
	spell_color = GLOW_COLOR_KINESIS
	attunement_school = ASPECT_NAME_KINESIS

	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Exmoveo!")
	invocation_type = INVOCATION_SHOUT

	cooldown_time = 20 SECONDS

	projectile_type = /obj/projectile/magic/repel/greater

	spell_tier = 2

/obj/projectile/magic/repel/greater
	name = "bolt of greater repelling"
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE

/obj/projectile/magic/repel/greater/on_hit(atom/target)
	if(!isliving(target))
		return ..()
	var/mob/living/living_target = target
	if(!firer || living_target.anti_magic_check())
		living_target.visible_message(span_warning("[src] vanishes on contact with [target]!"))
		return BULLET_ACT_BLOCK
	living_target.safe_throw_at(get_edge_target_turf(firer, get_dir(firer, target)), 7, 4)
	new /datum/magic_throw_slip_watcher(living_target)
	log_combat(firer, living_target, "repelled", src)
