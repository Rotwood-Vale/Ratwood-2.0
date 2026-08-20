/obj/effect/proc_holder/spell/invoked/projectile/fetch
	name = "Fetch"
	desc = "Shoot out a magical bolt that draws in the target struck towards the caster. Only skilled practitioners can use this spell while being grabbed."
	clothes_req = FALSE
	range = 15
	projectile_type = /obj/projectile/magic/fetch
	sound = list('sound/magic/magnet.ogg')
	active = FALSE
	human_req = TRUE
	releasedrain = 5
	chargedrain = 0
	chargetime = 0
	warnie = "spellwarning"
	overlay_state = "fetch"
	no_early_release = TRUE
	charging_slowdown = 1
	spell_tier = 2
	invocations = list("Recolligere")
	invocation_type = "whisper"
	hide_charge_effect = TRUE // essential for rogue mage
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	cost = 2 // Combat spell, but of slighlty less obvious use
	xp_gain = TRUE

/obj/effect/proc_holder/spell/invoked/projectile/fetch/cast_check(skipcharge, mob/user)
	. = ..()
	if (ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if (human_user && human_user.pulledby != null && human_user.get_skill_level(associated_skill) < 5)
			to_chat(human_user, span_warning("You can't make the proper hand movements while being grabbed! Woe!"))
			return FALSE

/obj/projectile/magic/fetch/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[target] repells the fetch!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
