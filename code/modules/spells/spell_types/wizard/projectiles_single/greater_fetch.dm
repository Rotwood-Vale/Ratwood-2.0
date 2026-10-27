/datum/action/cooldown/spell/projectile/fetch/greater
	name = "Greater Fetch"
	desc = "Shoot out a magical bolt that draws in whatever it strikes towards the caster, be it a freestanding item or a creature."
	spell_color = GLOW_COLOR_KINESIS
	attunement_school = ASPECT_NAME_KINESIS

	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Recolligere")

	cooldown_time = 10 SECONDS

	projectile_type = /obj/projectile/magic/fetch/greater

	spell_tier = 2

/obj/projectile/magic/fetch/greater
	name = "bolt of greater fetching"
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE

/obj/projectile/magic/fetch/greater/on_hit(atom/target)
	if(!isliving(target))
		return ..()
	var/mob/living/living_target = target
	if(!firer || living_target.anti_magic_check())
		living_target.visible_message(span_warning("[src] vanishes on contact with [target]!"))
		return BULLET_ACT_BLOCK
	if(firer.pulledby == living_target)
		return
	living_target.safe_throw_at(get_step(firer, get_dir(firer, target)), 200, 4)
	new /datum/magic_throw_slip_watcher(living_target)
	log_combat(firer, living_target, "fetched", src)
