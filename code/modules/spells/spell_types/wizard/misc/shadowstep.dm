/datum/action/cooldown/spell/blink/shadowstep
	source_aspect = /datum/magic_aspect/pseudo/spellfist
	name = "Shadowstep"
	desc = "Project your shadow to swap places with it, teleporting several feet away."
	cost = 3
	xp_gain = TRUE
	releasedrain = 30
	warnie = "spellwarning"
	movement_interrupt = TRUE
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "shadowstep"
	chargedrain = 1
	chargetime = 0 SECONDS
	recharge_time = 15 SECONDS
	hide_charge_effect = TRUE
	gesture_required = TRUE // Mobility spell
	spell_tier = 2
	req_items = list(/obj/item/clothing/mask/rogue/lordmask/naledi)
	// This is super telegraphed so it shouldn't need any whisper. It can stay silent as a unique.
	var/area_of_effect = 1
	var/max_range = 7
	var/turf/destination_turf
	var/turf/user_turf
	var/mutable_appearance/tile_effect
	var/mutable_appearance/target_effect

/datum/action/cooldown/spell/blink/shadowstep/vizier
	cooldown_time = 24 SECONDS

/obj/effect/temp_visual/blink/shadowstep
	icon_state = "curse"
	light_color = COLOR_PALE_PURPLE_GRAY
