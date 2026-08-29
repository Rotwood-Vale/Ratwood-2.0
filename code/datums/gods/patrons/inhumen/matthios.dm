/datum/patron/inhumen/matthios
	name = "Matthios"
	domain = "Greed, Theft, Dragons, True Freedom"
	desc = "The Manyfaced Matthios has no true form. Some see Him as a merry highwayman, some as a god of beggars, and others the father of all dragons. One thing is certain: His followers despise Astrata's nobility."
	worshippers = "Highwaymen, Downtrodden Peasants, Merchants, Slaves, Kobolds"
	virtues = "Varies; usually greed and commerce"
	sins = "Nobility, Sloth, Submitting to \"Unjust Hierarchies\""
	crafting_recipes = list(/datum/crafting_recipe/roguetown/sewing/bandithood)
	mob_traits = list(TRAIT_COMMIE, TRAIT_MATTHIOS_EYES, TRAIT_SEEPRICES_SHITTY)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison					= CLERIC_ORI,
					/obj/effect/proc_holder/spell/invoked/appraise						= CLERIC_ORI,
					/obj/effect/proc_holder/spell/targeted/touch/lesserknock/miracle	= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/transact						= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/lesser_heal 					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/blood_heal					= CLERIC_T1,
					/obj/effect/proc_holder/spell/invoked/equalize						= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/churnwealthy					= CLERIC_T3,
					/obj/effect/proc_holder/spell/invoked/resurrect/matthios			= CLERIC_T3, // Counterpart to anastasis
	)
	confess_lines = list(
		"MATTHIOS STEALS FROM THE WORTHLESS!",
		"MATTHIOS IS JUSTICE!",
		"MATTHIOS IS MY LORD!",
	)
	storyteller = /datum/storyteller/matthios

// When near coin of at least 100 mammon, zchurch, bad-cross, or ritual talk
/datum/patron/inhumen/matthios/can_pray(mob/living/follower)
	. = ..()
	// Allows prayer in the Zzzzzzzurch(!)
	if(istype(get_area(follower), /area/rogue/indoors/shelter/mountains))
		return TRUE
	// Allows prayer near EEEVIL psycross
	for(var/obj/structure/fluff/psycross/zizocross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("That acursed cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer if the user has more than 100 mammon on them.
	var/mammon_count = get_mammons_in_atom(follower)
	if(mammon_count >= 100)
		return TRUE
	// Spend 5/10 mammon to pray. Megachurch pastors be like.....
	var/obj/item/held_item = follower.get_active_held_item()
	var/helditemvalue = held_item.get_real_price()
	if(istype(held_item, /obj/item/roguecoin) && helditemvalue >= 5)
		qdel(held_item)
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/matthios in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Matthios to hear my prayers I must either be in the church of the abandoned, near an inverted psycross, flaunting wealth upon me of at least 100 mammon, or offer a coin of at least five mammon up to him!"))
	return FALSE

/datum/patron/inhumen/matthios/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus,
	is_inhumen
)
	*is_inhumen = TRUE
	*message_out = span_info("A wreath of... strange light passes over [target]?")
	*message_self = span_notice("I'm bathed in a... strange holy light?")

	if(HAS_TRAIT(target, TRAIT_COMMIE))
		*conditional_buff = TRUE
		*situational_bonus = 2.5

/// - MATTHIOS REVIVAL - ///


/obj/effect/proc_holder/spell/invoked/resurrect/matthios
	name = "Rekindled Exchange"
	desc = "Revives the target by invoking a deal with Matthios. In exchange for their lyfe returned, they will be placed\
	in a lasting debt to Him. Any coins within their hands will be spent paying off said debt. Blood for gold."
	debuff_type = /datum/status_effect/debuff/debt_indicator
	alt_required_items = list()
	required_items = list()
	sound = 'sound/magic/slimesquish.ogg'
	chargedloop = /datum/looping_sound/invokeascendant
	harms_undead = FALSE
	recharge_time = 2 MINUTES //Anastasis Equivalent
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "revival"
	action_icon_state = "revival"
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	required_structure = /obj/structure/fluff/psycross/matthios


#define NOBLE_MULTIPLIER 2.5

/datum/component/debt_collector
	var/debt_remaining = 0
	/// There's a couple instances where on_equip() is called twice incorrectly. I'm applying a small cooldown to prevent abuse of this...
	var/next_payment_time = 0

/datum/component/debt_collector/Initialize(start_debt = 200)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/human/H = parent
	if(HAS_TRAIT(H, TRAIT_NOBLE))
		debt_remaining = start_debt * NOBLE_MULTIPLIER
	else
		debt_remaining = start_debt
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))

/datum/component/debt_collector/proc/on_equip(mob/living/carbon/human/H, obj/item/I, slot)
	SIGNAL_HANDLER

	if(slot != ITEM_SLOT_HANDS)
		return

	if(world.time < next_payment_time)
		return

	// Set the cooldown immediately to "lock" this tick
	next_payment_time = world.time + 1

	// Only interact with standard currency, so no marques or psila
	if(istype(I, /obj/item/roguecoin/gold) || istype(I, /obj/item/roguecoin/silver) || istype(I, /obj/item/roguecoin/copper))
		addtimer(CALLBACK(src, PROC_REF(process_payment), H, I), 1)

/datum/component/debt_collector/proc/process_payment(mob/living/carbon/human/H, obj/item/roguecoin/C)
	var/total_real_value = C.get_real_price()
	if(debt_remaining <= 0)
		clear_debt(H)
		return

	if(total_real_value > debt_remaining)
		var/refund_budget = total_real_value - debt_remaining
		refund_budget = max(0, floor(refund_budget))
		to_chat(H, span_warning("A golden hand claims [C] and manifest the remainder."))

		qdel(C)
		// We need a delay to stop the old coin pile from merging with the refund prematurely. Delay one tick :D
		// I love coin code!!
		spawn(1)
			var/obj/structure/roguemachine/temp_ref = new /obj/structure/roguemachine()
			temp_ref.budget2change(refund_budget, H)
			qdel(temp_ref)

		debt_remaining = 0
		clear_debt(H)

	else
		debt_remaining -= total_real_value
		to_chat(H, span_warning("As you grasp [C], [total_real_value] worth of debt vanishes. Remaining: [debt_remaining]."))
		playsound(H, 'sound/foley/coins1.ogg', 50, TRUE)
		qdel(C)
		if(debt_remaining <= 0)
			clear_debt(H)

/datum/component/debt_collector/proc/clear_debt(mob/living/carbon/human/H)
	to_chat(H, span_nicegreen("The weight of your debt has lifted!"))
	H.remove_status_effect(/datum/status_effect/debuff/debt_indicator)
	qdel(src)

#undef NOBLE_MULTIPLIER

/atom/movable/screen/alert/status_effect/debuff/debt_indicator
	name = "Indentured Spirit"
	desc = "A spiritual debt weighs heavy on your soul, sapping your vitality. Standard coins you touch are consumed to appease Matthios."
	icon_state = "pom_regret"

/atom/movable/screen/alert/status_effect/debuff/debt_indicator/examine_ui(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b></span>"
	if(desc)
		inspec += "<br>[desc]"

	// Find the component to show the live debt count
	var/datum/component/debt_collector/DC = user.GetComponent(/datum/component/debt_collector)
	if(DC)
		inspec += "<br><span class='boldwarning'>Current Debt: [DC.debt_remaining] mammon.</span>"

	// Stat penalties logic from the base proc
	for(var/S in attached_effect?.effectedstats)
		if(attached_effect.effectedstats[S] > 0)
			inspec += "<br><span class='purple'>[S]</span> \Roman [attached_effect.effectedstats[S]]"
		else if(attached_effect.effectedstats[S] < 0)
			var/newnum = attached_effect.effectedstats[S] * -1
			inspec += "<br><span class='danger'>[S]</span> \Roman [newnum]"

	inspec += "<br>----------------------"
	to_chat(user, "[inspec.Join()]")

/datum/status_effect/debuff/debt_indicator
	id = "debt_indicator"
	// You should pay off the debt!
	duration = 45 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/debt_indicator
	effectedstats = list(
		STATKEY_STR = -2,
		STATKEY_SPD = -4,
		STATKEY_CON = -2
	)

/datum/status_effect/debuff/debt_indicator/on_apply()
	. = ..()
	owner.AddComponent(/datum/component/debt_collector, 200)
	to_chat(owner, span_userdanger("A cold, crushing weight settles over your limbs... you are indentured."))

/datum/status_effect/debuff/debt_indicator/on_remove()
	. = ..()
	to_chat(owner, span_nicegreen("The crushing weight lifts from your soul. You are free!"))
