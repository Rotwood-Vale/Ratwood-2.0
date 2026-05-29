/datum/wound/charring
	name = "severe burn"
	check_name = span_warning("<B>CHARRED</B>")
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"The flesh is seared to the bone!",
		"The %BODYPART is charred black!",
		"The skin blisters and splits open!",
		"The flesh crackles and chars!",
	)
	sound_effect = list('sound/combat/hits/burn (1).ogg', 'sound/combat/hits/burn (2).ogg')
	whp = 60
	woundpain = 80
	mob_overlay = ""
	can_sew = FALSE
	can_cauterize = FALSE
	disabling = TRUE
	critical = TRUE
	bleed_rate = 0
	bypass_bloody_wound_check = TRUE
	var/gain_emote = "painscream"

/datum/wound/charring/get_sound_effect(mob/living/affected, obj/item/bodypart/affected_bodypart)
	return pick(sound_effect)

/datum/wound/charring/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/charring) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/charring/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	affected.temporary_crit_paralysis(15 SECONDS)

/datum/wound/charring/on_mob_gain(mob/living/affected)
	. = ..()
	if(gain_emote)
		affected.emote(gain_emote, TRUE)
	affected.Slowdown(15)
	shake_camera(affected, 2, 2)
	playsound(affected, 'sound/health/burning.ogg', 60, TRUE)
	if(HAS_TRAIT(affected, TRAIT_NOBREATH)) //for vamps, revenants, skeletons and other breathless folk - you die after two crits. If you've gotten to the point where you can be crit, you were likely dead anyways.
		var/burn_crit_count = 0
		for(var/datum/wound/charring/char_wound in affected.get_wounds())
			burn_crit_count++
		if(burn_crit_count >= 2)
			affected.visible_message(span_boldwarning("[affected]'s body is consumed by searing burns!"))
			to_chat(affected, span_boldwarning("The searing heat overwhelms my body!"))
			affected.emote("deathgasp", TRUE)
			affected.death()
		else
			to_chat(affected, span_userdanger("Searing heat scorches through me - another burn like this will be fatal!"))

/datum/wound/charring/chest
	name = "torso charring"
	crit_message = list(
		"The torso is seared!",
		"The chest is charred black!",
		"The ribcage crackles with heat!",
	)
	mortal = TRUE

/datum/wound/charring/chest/on_mob_gain(mob/living/affected)
	if(mortal && HAS_TRAIT(affected, TRAIT_CRITICAL_WEAKNESS))
		affected.emote("deathgasp", TRUE)
	. = ..()

/datum/wound/charring/head
	name = "head charring"
	crit_message = list(
		"The skull is seared!",
		"The face is charred beyond recognition!",
		"The head is engulfed in searing heat!",
	)
	mortal = TRUE

/datum/wound/charring/head/on_mob_gain(mob/living/affected)
	if(mortal && HAS_TRAIT(affected, TRAIT_CRITICAL_WEAKNESS))
		affected.emote("deathgasp", TRUE)
	. = ..()

