/obj/effect/proc_holder/spell/invoked/projectile/deathgrasp //Fetch + Frost Bolt, exclusive to Ancient Champion. Instant cast, but can't fetch objects and has much more punishing CD. Try not to miss.
	name = "Death's Grasp"
	desc = "Shoot out an unholy projectile that draws in the target struck towards the caster. The target struck will be slowed for some time."
	clothes_req = FALSE
	range = 15
	projectile_type = /obj/projectile/magic/deathgrasp
	sound = list('sound/magic/soulsteal.ogg')
	active = FALSE
	human_req = TRUE
	releasedrain = 20
	recharge_time = 20 SECONDS //50% effective uptime
	chargedrain = 0
	chargetime = 0
	warnie = "spellwarning"
	overlay_state = "fetch"
	no_early_release = TRUE
	charging_slowdown = 1
	spell_tier = 2
	invocations = list("Nauk-avurn!")
	invocation_type = "shout"
	hide_charge_effect = TRUE
	chargedloop = /datum/looping_sound/invokeascendant
	associated_skill = /datum/skill/magic/arcane
	xp_gain = FALSE
	zizo_spell = TRUE

/datum/status_effect/buff/deathgrasped
	id = "deathgrasped"
	alert_type = /atom/movable/screen/alert/status_effect/buff/deathgrasped
	duration = 10 SECONDS
	effectedstats = list("speed" = -4) //Skillcheck for dodgemaxxers: if they switch from Dodge to Parry, they'll live.

/atom/movable/screen/alert/status_effect/buff/deathgrasped
	name = "Grasped"
	desc = "My legs are held down by invisible hands."
	icon_state = "debuff"

/obj/projectile/magic/deathgrasp
	name = "grasp of death"
	icon_state = "cursehand0"
	range = 15

/obj/projectile/magic/deathgrasp/on_hit(target)
	. = ..()
	var/atom/throw_target = get_step(firer, get_dir(firer, target))
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check() || !firer)
			L.visible_message(span_warning("[src] vanishes on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		L.throw_at(throw_target, 200, 4)
		if(L.has_status_effect(/datum/status_effect/buff/deathgrasped)) //Reapply effect, no frostbite-equivalent -- it's already pretty oppressive
			L.remove_status_effect(/datum/status_effect/buff/deathgrasped)
			L.apply_status_effect(/datum/status_effect/buff/deathgrasped)
		else
			L.apply_status_effect(/datum/status_effect/buff/deathgrasped)
