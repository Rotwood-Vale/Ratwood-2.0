//T3: Revel in Death - Increase bleeding and pain of a target.
/datum/action/cooldown/spell/revel_in_death
	name = "Revel in Death"
	desc = "Increases the bleeding and pain of a target. Their blood-loss amount scales with every point of constitution over ten. \
	Those with ten or less constituion will instead have a flat rate (x1.25)."
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "bloodsteal"
	recharge_time = 1 MINUTES
	chargetime = 10
	chargedrain = 0
	chargedloop = /datum/looping_sound/invokeevil
	invocations = list("SINISTAR, MAKE THEM BLEED!")
	invocation_type = "shout"
	sound = 'sound/magic/bleed_out.ogg'
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 70

/datum/action/cooldown/spell/revel_in_death/cast(list/targets, mob/living/user = usr)
	var/mob/living/carbon/human/human = targets[1]

	if(!istype(human) || human == user)
		to_chat(user, span_danger("THAT WONT WORK!"))
		revert_cast()
		return FALSE

	if(spell_guard_check(human, TRUE))
		human.visible_message(span_warning("[human] resists the bloodlust!"))
		return TRUE
	
	human.apply_status_effect(/datum/status_effect/debuff/bloody_mess)
	human.apply_status_effect(/datum/status_effect/debuff/sensitive_nerves)

	return TRUE

///////////////////////
/// Status-Effects ///
/////////////////////

/datum/status_effect/debuff/bloody_mess
	id = "bloodymess"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bloody_mess
	duration = 20 SECONDS // this is EASILY enough time to kill someone w/ the effect.

/atom/movable/screen/alert/status_effect/debuff/bloody_mess
	name = "Bloody Mess"
	desc = "My bleeding is quickened! I must grip my wounds, or I will lose myself steadfast!"

/datum/status_effect/debuff/bloody_mess/on_apply()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/physiology/phy = H.physiology 
	var/con_mod = H.STACON - 10
	// con mod needs to be greater than 1 for scaling
	if(con_mod > 0)
		// ensure their gotten con mod does not go below 1 or exceed the bleedrate cap.
		con_mod = clamp(con_mod, 1, CONSTITUTION_BLEEDRATE_CAP - 10)
		// this ""equalizes"" high con ppl into bleeding more, but they SHOULD generally still 
		// bleed less than if they had just 10 con. remember: this numbers gets sent THRU their con score after.
		phy.bleed_mod = 1.15 + (con_mod * 0.1) // at 15 con you'll bleed from a wound by .825
	else
		phy.bleed_mod = 1.15 // if you already have low con, we're not going to turbofuck you. ok?
	H.visible_message(span_warning("[owner]'s blood runs thin and begins GUSHING out of their wounds!"), span_danger("A FOUL SPELL IS CAUSING ME TO BLEED EN MASSE!"))

/datum/status_effect/debuff/bloody_mess/on_remove()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/physiology/phy = H.physiology 
	phy.bleed_mod = initial(phy.bleed_mod) // con can lower from the bleeding so we want it to just directly be set back to the initial
	H.visible_message(span_warning("[owner] has their wounds calm..."), span_warning("My wounds stop bleeding so heavily!"))






/datum/status_effect/debuff/sensitive_nerves
	id = "sensitivenerves"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/sensitive_nerves
	duration = 20 SECONDS // this is EASILY enough time to kill someone w/ the effect.

/atom/movable/screen/alert/status_effect/debuff/sensitive_nerves
	name = "Sensitive Nerves"
	desc = "IT HURTS!!! MY WOUNDS BITE INTO MY FLESH WITH SUCH RABID FEROCITY!"

/datum/status_effect/debuff/sensitive_nerves/on_apply()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/physiology/phy = H.physiology 
	var/pain_mod = phy.pain_mod
	phy.pain_mod = pain_mod * 1.25 // this then gets reduced by wil, among other things. change as needed.
	H.visible_message(span_warning("[owner] looks to be in great pain, their wounds BLACKENING!"), span_danger("EVERYTHING HURTS!! MY WOUNDS PAIN HAS INCREASED!!"))

/datum/status_effect/debuff/sensitive_nerves/on_remove()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/physiology/phy = H.physiology 
	var/pain_mod = phy.pain_mod
	phy.pain_mod = pain_mod / 1.25 // this should be a define fuuuck
	H.visible_message(span_warning("[owner]'s wounds suddenly return to normal!"), span_warning("My magickally induced pain subsides!"))
