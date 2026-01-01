//A sidegrade of arcane bolt, for the Sojourner. Frost themed.
//Worse damage than arcane bolt, paired with frost bolt's effects.
//Retains frost bolt's damage. Gets a HORRID arced shot for applying slowdown through groups.
/obj/effect/proc_holder/spell/invoked/projectile/ice_shard
	name = "Ice Shard"
	desc = "A spell to conjure a shard of ice. Wickedly sharp. The bane of creechurs from Zybantu to the lands of the Naledi. A lost art."
	range = 12
	projectile_type = /obj/projectile/energy/ice_shard
	overlay_state = "ice_shard"//temp
	sound = list('sound/magic/whiteflame.ogg')
	active = FALSE

	releasedrain = 30//10 more than arcane bolt.
	chargedrain = 1
	chargetime = 2 SECONDS
	recharge_time = 6 SECONDS//2 more seconds than arcane bolt.
	human_req = TRUE

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	antimagic_allowed = FALSE //can you use it if you are antimagicked?
	charging_slowdown = 3
	spell_tier = 2
	invocations = list("Hasta Glacialis!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_LOW
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane //can be arcane, druidic, blood, holy
	cost = 3

	xp_gain = TRUE
	miracle = FALSE

/obj/effect/proc_holder/spell/invoked/projectile/ice_shard/cast(list/targets, mob/user = user)
	var/mob/living/carbon/human/H = user
	var/datum/intent/a_intent = H.a_intent
	if(istype(a_intent, /datum/intent/special/magicarc))
		projectile_type = /obj/projectile/energy/ice_shard/arc
	else
		projectile_type = /obj/projectile/energy/ice_shard
	. = ..()

/obj/projectile/energy/ice_shard
	name = "shard of ice"
	icon_state = "ice_2"
	damage = 20
	npc_simple_damage_mult = 2
	woundclass = BCLASS_STAB
	range = 12
	speed = 1
	nodamage = FALSE
	hitsound = 'sound/combat/hits/pick/genpick (2).ogg'

/obj/projectile/energy/ice_shard/arc
	name = "arced shard of ice"
	damage = 10
	arcshot = TRUE

/obj/projectile/energy/ice_shard/on_hit(target)
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
			if(L.has_status_effect(/datum/status_effect/buff/frostbite))
				return
			else
				if(L.has_status_effect(/datum/status_effect/buff/frost))
					playsound(get_turf(target), 'sound/combat/fracture/fracturedry (1).ogg', 80, TRUE, soundping = TRUE)
					L.remove_status_effect(/datum/status_effect/buff/frost)
					L.apply_status_effect(/datum/status_effect/buff/frostbite)
				else
					L.apply_status_effect(/datum/status_effect/buff/frost)
			new /obj/effect/temp_visual/snap_freeze(get_turf(L))
	qdel(src)
