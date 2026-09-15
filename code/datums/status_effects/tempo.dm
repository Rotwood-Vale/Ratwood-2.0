#define TEMPO_MAX_FILTER "tempo_max_glow"

/datum/status_effect/tempo
	id = "tempo"
	status_type = STATUS_EFFECT_REFRESH
	duration = -1 // Special handling. The list of attackers should auto-clear. Once it hits 0, the buff goes away
	alert_type = /atom/movable/screen/alert/status_effect/tempo
	/// Holds the particle effects for tempo
	var/obj/effect/abstract/particle_holder/tempo_particle
	/// Current level of our tempo, based on how many mobs are in our tempo_attackers
	var/tempo_level = 0
	/// Maximum tempo level this buff has reached. So that losing a level and then re-gaining a level does not replenish stamina again
	var/level_achieved = 0

/atom/movable/screen/alert/status_effect/tempo
	// Name, desc and icon state are meant to update per level
	name = "TEMPO"
	desc = "Two cowardly foes are attacking me. The need to focus has given me some light boons."
	icon_state = "tempo1"

/// Adjusts variables based on the number of attackers, gives stamina if this is the first time we hit the threshold
/datum/status_effect/tempo/proc/adjust_count(attackers)
	// Remove tempo if down to 0 attackers.
	// We won't remove it for 1 attacker, so that the conflict has to fully resolve before resetting the stamina gains
	// Do note, this does also mean you can keep the level 1 buffs for slightly longer until the effect fully wears off
	if(attackers <= 0)
		qdel(src)
		return

	// These stamina increases should only occur once per level achievement
	if(attackers == TEMPO_ONE && level_achieved < 1)
		owner.stamina = max((owner.stamina - owner.max_stamina / 3), 0)
		level_achieved = 1

	if(attackers == TEMPO_TWO && level_achieved < 2)
		owner.stamina = max((owner.stamina - owner.max_stamina / 2), 0)
		level_achieved = 2

	if(attackers >= TEMPO_MAX && level_achieved < 3)
		owner.stamina = max((owner.stamina - owner.max_stamina / 2), 0)
		level_achieved = 3

	// Now let's handle our *actual* level and their effects
	if(attackers == TEMPO_ONE)
		tempo_level = 1
		linked_alert.name = "Tempo One"
		linked_alert.desc = "Two cowardly foes are attacking me. The need to focus has given me some light boons."
		linked_alert.icon_state = "tempo1"

		to_chat(owner, span_info("Tempo!"))
		tempo_particle = new(owner, /particles/tempo/tempo_one, PARTICLE_ATTACH_MOB)
		REMOVE_TRAIT(owner, TRAIT_GRABIMMUNE, TRAIT_STATUS_EFFECT(id))
		REMOVE_TRAIT(owner, TRAIT_STRONGKICK, TRAIT_STATUS_EFFECT(id))
		owner.remove_filter(TEMPO_MAX_FILTER)

	if(attackers == TEMPO_TWO)
		tempo_level = 2
		linked_alert.name = "Tempo Two"
		linked_alert.desc = "Three on one! I am locked in. Greater boons come to me in the heat of battle."
		linked_alert.icon_state = "tempo2"

		to_chat(owner, span_notice("Tempo!!"))
		tempo_particle = new(owner, /particles/tempo/tempo_two, PARTICLE_ATTACH_MOB)
		REMOVE_TRAIT(owner, TRAIT_GRABIMMUNE, TRAIT_STATUS_EFFECT(id))
		REMOVE_TRAIT(owner, TRAIT_STRONGKICK, TRAIT_STATUS_EFFECT(id))
		owner.remove_filter(TEMPO_MAX_FILTER)

	if(attackers >= TEMPO_MAX)
		tempo_level = 3
		linked_alert.name = "Full Tempo"
		linked_alert.desc = "FOUR AND MORE! COME AND GET ME! I WILL NOT GO DOWN LIKE A KNAVE!"
		linked_alert.icon_state = "tempo3"

		to_chat(owner, span_notice("<b>TEMPO!!!</b>"))
		tempo_particle = new(owner, /particles/tempo/tempo_three, PARTICLE_ATTACH_MOB)
		var/filter = owner.get_filter(TEMPO_MAX_FILTER)
		if (!filter)
			owner.add_filter(TEMPO_MAX_FILTER, 2, list("type" = "outline", "color" = "#d3aa25", "alpha" = 80, "size" = 1))
		owner.playsound_local(owner, 'sound/combat/tempo_max.ogg', 35, TRUE)
		ADD_TRAIT(owner, TRAIT_GRABIMMUNE, TRAIT_STATUS_EFFECT(id))
		ADD_TRAIT(owner, TRAIT_STRONGKICK, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/tempo/on_remove()
	if(tempo_particle)
		QDEL_NULL(tempo_particle)
	REMOVE_TRAIT(owner, TRAIT_GRABIMMUNE, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_STRONGKICK, TRAIT_STATUS_EFFECT(id))
	owner.remove_filter(TEMPO_MAX_FILTER)
	return ..()
