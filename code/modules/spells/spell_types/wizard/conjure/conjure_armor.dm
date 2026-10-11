/obj/effect/proc_holder/spell/self/conjure_armor
	name = "Conjure Armor"
	desc = "Conjure a fate weaver, a magical field that turns away arrows but does nothing against melee weapons.\n\
	It blocks three projectiles before it shatters."
	overlay_state = "conjure_armor"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 50
	chargedrain = 1
	chargetime = 3 SECONDS
	no_early_release = TRUE
	recharge_time = 60 SECONDS

	warnie = "spellwarning"
	antimagic_allowed = FALSE
	charging_slowdown = 3
	cost = 2
	spell_tier = 2 // Spellblade tier.

	invocations = list("Cladum Fati!") //destiny's defeat!
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_MEDIUM

	var/ward_type = /datum/status_effect/buff/projectile_ward
	var/datum/status_effect/buff/projectile_ward/ward

/obj/effect/proc_holder/spell/self/conjure_armor/Destroy()
	QDEL_NULL(ward)
	return ..()

/obj/effect/proc_holder/spell/self/conjure_armor/Click()
	if(ward)
		qdel(ward)
		return TRUE
	return ..()

/obj/effect/proc_holder/spell/self/conjure_armor/cast(list/targets, mob/living/user = usr)
	user.visible_message("[user]'s existence briefly jitters, conjuring protection from doomed fates!")
	ward = user.apply_status_effect(ward_type)
	ward.spell = src
	return TRUE

/obj/effect/proc_holder/spell/self/conjure_armor/miracle
	associated_skill = /datum/skill/magic/holy

#define PROJECTILE_WARD_FILTER "projectile_ward_glow"

/datum/status_effect/buff/projectile_ward
	id = "projectile_ward"
	alert_type = /atom/movable/screen/alert/status_effect/buff/projectile_ward
	duration = -1
	examine_text = "<font color='yellow'>SUBJECTPRONOUN is surrounded by a shimmering field!</font>"
	var/integrity = 3
	var/blocks_magic = FALSE
	var/outline_colour = "#d8c34a"
	var/obj/effect/proc_holder/spell/self/conjure_armor/spell

/atom/movable/screen/alert/status_effect/buff/projectile_ward
	name = "Fate Weaver"
	desc = "Fate propels arrows away from my body!"

/datum/status_effect/buff/projectile_ward/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_ATOM_BULLET_ACT, PROC_REF(block_projectile))
	owner.add_filter(PROJECTILE_WARD_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))

/datum/status_effect/buff/projectile_ward/proc/block_projectile(datum/source, obj/projectile/P, def_zone)
	SIGNAL_HANDLER
	if((P.flag == "magic" || istype(P, /obj/projectile/magic)) != blocks_magic)
		return
	playsound(owner, 'sound/combat/parry/shield/magicshield (1).ogg', 100, TRUE)
	do_sparks(2, FALSE, owner)
	owner.visible_message(span_warning("[P] is turned aside by the field around [owner]!"))
	if(--integrity <= 0)
		playsound(owner, 'sound/foley/breaksound.ogg', 100, TRUE)
		do_sparks(6, FALSE, owner)
		owner.visible_message(span_warning("The field around [owner] shatters!"))
		qdel(src)
	return COMPONENT_ATOM_BLOCK_BULLET

/datum/status_effect/buff/projectile_ward/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_ATOM_BULLET_ACT)
	owner.remove_filter(PROJECTILE_WARD_FILTER)
	if(!QDELETED(spell))
		spell.ward = null
		spell.charge_counter = 0
		spell.start_recharge()
