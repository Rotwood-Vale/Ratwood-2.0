//T0: Graggar cuffbreak
/obj/effect/proc_holder/spell/self/graggar_chainbreak
	name = "Break the Chains"
	desc = "Snap off your restraints with unholy help."
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "breakchains"
	recharge_time = 10 MINUTES //Goes down pretty signifcantly if you have high holy level.
	invocations = list("GRAGGAR BREAK MY CHAINS!", "GRAGGAR SET ME FREE!", "SLAUGHTER RESUMED!")
	invocation_type = "shout"
	sound = 'sound/magic/break_chains.ogg'
	miracle = TRUE
	releasedrain = 10
	devotion_cost = 50
	antimagic_allowed = FALSE

/obj/effect/proc_holder/spell/self/graggar_chainbreak/cast(list/targets, mob/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.handcuffed || H.legcuffed)
		H.visible_message(span_danger("[H]'s restraints loosen under inhumen pressure!"))
		H.uncuff()
		return TRUE
	else
		revert_cast()
		return FALSE
