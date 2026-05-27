//Numbing Pleasure - T3, halves pain from target for a period of time. (Similar to Ravox's without any blood-clotting and better pain suppression + good mood buff.)
/obj/effect/proc_holder/spell/invoked/painkiller
	name = "Numbing Pleasure"
	desc = "Numbs the targets pain and improves their mood."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "pleasure"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	sound = 'sound/magic/timestop.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 90 SECONDS
	miracle = TRUE
	devotion_cost = 75

/obj/effect/proc_holder/spell/invoked/painkiller/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/mob/living/carbon/human/human_target = target
		var/datum/physiology/phy = human_target.physiology
		if(target.mob_biotypes & MOB_UNDEAD)
			return FALSE	//No, you don't get to feel good. You're a undead mob. Feel bad.
		target.visible_message(span_info("[target] twitches and shivers as a strange warmth radiates from them!"), span_notice("The pain from my wounds melts into sweet suffering. This feels... right."))
		phy.pain_mod *= 0.5	//Literally halves your pain modifier.
		addtimer(CALLBACK(src, PROC_REF(restore_pain_mod), phy), 1 MINUTES)
		target.apply_status_effect(/datum/status_effect/buff/vitae)					//+2 Fortune and mood buff
		return TRUE

/obj/effect/proc_holder/spell/invoked/painkiller/proc/restore_pain_mod(datum/physiology/physiology)
	if(!physiology)
		return

	physiology.pain_mod /= 0.5
