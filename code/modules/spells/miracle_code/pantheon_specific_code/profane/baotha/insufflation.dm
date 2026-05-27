// Insufflation - effectively just drugging yourself. Lets you pick, the same as Enrapturing Powder. T1, for now, to make up for the loss of the Baotha Blessing buff.

/obj/effect/proc_holder/spell/self/insufflation 
	name = "Insufflation"
	desc = "Imbibes yourself on one of four drugs, in Her name. Your intent will determine the drug ingested. \n\
	\
	Feint intent will dose you on Spice, giving you +5 INT, +3 SPD, and -5 FOR. \n\
	\
	Aimed intent will dose you on Moondust, giving you +3 SPD, +3 WILL, and -2 INT. \n\
	\
	Strong intent will dose you on Herozium, giving you -5 SPD, +4 WILL, -3 INT, +3 CON, pain immunity, and resistance to damage slowdown. \n\
	\
	Swift intent will dose you on Starsugar, giving you +4 SPD, +4 WILL -3 INT, -3 CON, darkvision, and dodge expert."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "powder"
	clothes_req = FALSE
	associated_skill = /datum/skill/magic/holy
	chargedloop = /datum/looping_sound/invokeholy
	releasedrain = 10
	chargedrain = 0
	chargetime = 15
	recharge_time = 10 SECONDS
	invocation_type = "emote"
	invocations = list("flicks their wrist, filling the air in front of them with a fine powder.")
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/self/insufflation/cast(list/targets, mob/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	switch(user.rmb_intent.name)
		if("feint")
			user.reagents.add_reagent(/datum/reagent/druqks, 4)
			return TRUE
		if("aimed")
			user.reagents.add_reagent(/datum/reagent/moondust_purest, 8)
			return TRUE
		if("strong")
			user.reagents.add_reagent(/datum/reagent/herozium, 8)
			return TRUE
		if("swift")
			user.reagents.add_reagent(/datum/reagent/starsugar, 8)
			return TRUE
		else
			user.reagents.add_reagent(/datum/reagent/herozium, 8)
			return TRUE
