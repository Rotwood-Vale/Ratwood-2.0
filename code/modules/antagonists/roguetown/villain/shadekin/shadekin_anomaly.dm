/// Anomaly antagonist datum for Shadekin Anomaly role
/datum/antagonist/shadekin_anomaly
	name = "Anomaly"
	roundend_category = "Anomalies"
	antagpanel_category = "Anomaly"
	job_rank = ROLE_ANOMALY

/datum/antagonist/shadekin_anomaly/on_gain()
	. = ..()
	var/mob/living/carbon/human/H = owner?.current
	if(!H || !ishuman(H))
		return

	// Grant anomaly spells
	H.AddSpell(new /obj/effect/proc_holder/spell/self/shadekin_voidwalk)
	H.AddSpell(new /obj/effect/proc_holder/spell/self/shadekin_shadowrest)
	H.AddSpell(new /obj/effect/proc_holder/spell/self/shadekin_shroud)
	// Grant innate Snuff Lights ability (extinguish all lights in range)
	H.AddSpell(new /obj/effect/proc_holder/spell/self/zizo_snuff/shadekin)

	to_chat(H, span_boldwarning("You are a Shadekin Anomaly - a being of shadow and mystery."))
	to_chat(H, span_warning("RULES OF THE ANOMALY:"))
	to_chat(H, span_warning("1. You are a passive observer not meant to search for combat."))
	to_chat(H, span_warning("2. You should not interfere with kingdom business or politics."))
	to_chat(H, span_warning("3. You are curious and mischievous."))
	to_chat(H, span_warning("4. You are rarely seen. Use Void Walk to remain hidden."))
	to_chat(H, span_warning("5. If your energy runs out, you will collapse asleep wherever you are."))
	to_chat(H, span_warning("6. This is an RP-heavy role. Your interactions should create interesting roleplay moments."))
	to_chat(H, span_notice("Be the shadow in the corner. The curious presence. The unseen observer."))
