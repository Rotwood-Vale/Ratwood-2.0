// T0: Snuffs out fires/lights around area of the caster, greater range with higher HOLY skill

/datum/action/cooldown/spell/zizo_snuff
	name = "Snuff Lights"
	desc = "Extinguish all lights in range, with your Miracles skill increasing range."
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "snufflight"
	invocations = list("exhales a dark grey smog, choking any lights nearby.")
	invocation_type = INVOCATION_EMOTE
	sound = 'sound/magic/zizo_snuff.ogg'
	associated_skill = /datum/skill/magic/holy
	associated_stat = null
	charge_required = FALSE
	click_to_activate = FALSE
	cooldown_time = 20 SECONDS
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 30
	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = 10
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	zizo_spell = TRUE
	var/snuff_range = 2

/datum/action/cooldown/spell/zizo_snuff/cast(atom/cast_on)
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/checkrange = snuff_range + owner.get_skill_level(/datum/skill/magic/holy)
	for(var/obj/O in range(checkrange, owner))
		O.extinguish()
	for(var/mob/M in range(checkrange, owner))
		for(var/obj/O in M.contents)
			O.extinguish()
	return TRUE
