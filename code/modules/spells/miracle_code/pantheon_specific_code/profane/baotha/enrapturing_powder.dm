//Enrapturing Powder - T2, basically a crackhead blowing cocaine in your face.

/obj/effect/proc_holder/spell/invoked/projectile/blowingdust
	name = "Enrapturing Powder"
	desc = "Blows dust of a potent drug at the target, applying a variety of effects. \
	Your intent will determine the drug thrown at the target. \n\
	\
	Feint intent will throw spice at the target, giving them +5 INT, +3 SPD, and -5 FOR. \n\
	\
	Aimed intent will throw moondust at the target, giving them +3 SPD, +3 WILL, and -2 INT. \n\
	\
	Strong intent will throw herozium at the target, giving them -5 SPD, +4 WILL, -3 INT, +3 CON, pain immunity, and resistance to damage slowdown. \n\
	\
	Swift intent will throw starsugar at the target, giving them +4 SPD, +4 WILL -3 INT, -3 CON, darkvision, and dodge expert."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "powder"
	clothes_req = FALSE
	range = 7	//POCKET OPIUM! 7 tiles because it's a projectile and it used to just travel across the entire screen anyway even at 3.
	associated_skill = /datum/skill/magic/holy
	projectile_type = /obj/projectile/magic/blowingdust
	chargedloop = /datum/looping_sound/invokeholy
	releasedrain = 10
	chargedrain = 0
	chargetime = 15
	recharge_time = 10 SECONDS
	invocation_type = "emote"
	invocations = list("flicks their wrist, filling the air in front of them with a fine powder.")
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/projectile/blowingdust/cast(list/targets, mob/user = user)
	switch(user.rmb_intent.name)
		if("feint")
			projectile_type = /obj/projectile/magic/blowingdust/spice
		if("aimed")
			projectile_type = /obj/projectile/magic/blowingdust/moondust
		if("strong")
			projectile_type = /obj/projectile/magic/blowingdust
		if("swift")
			projectile_type = /obj/projectile/magic/blowingdust/starsugar
		else
			projectile_type = /obj/projectile/magic/blowingdust

	. = ..()

/obj/projectile/magic/blowingdust
	name = "unholy dust"
	icon_state = "spark"
	nodamage = FALSE
	damage = 1
	poisontype = /datum/reagent/herozium
	poisonfeel = "burning" //Insufflation delivery method.
	poisonamount = 8 //Decent bit of high, three doses would be just above the overdose threshold if applied fast enough - in practice usually 4.

/obj/projectile/magic/blowingdust/starsugar
	name = "unholy dust"
	icon_state = "spark"
	nodamage = FALSE
	damage = 1
	poisontype = /datum/reagent/starsugar
	poisonfeel = "burning" //Insufflation go brr.
	poisonamount = 8 //Decent bit of high, three doses would be just above the overdose threshold if applied fast enough - in practice usually 4.

/obj/projectile/magic/blowingdust/spice
	name = "unholy dust"
	icon_state = "spark"
	nodamage = FALSE
	damage = 1
	poisontype = /datum/reagent/druqks
	poisonfeel = "burning" //Insufflation go brr.
	poisonamount = 4 //Lower than the others as it's got an OD threshold of 16 - takes 4 hits to OD if you hit it perfectly, but more like 5.

/obj/projectile/magic/blowingdust/moondust
	name = "unholy dust"
	icon_state = "spark"
	nodamage = FALSE
	damage = 1
	poisontype = /datum/reagent/moondust_purest
	poisonfeel = "burning" //Insufflation go brr.
	poisonamount = 8 //Decent bit of high, three doses would be just above the overdose threshold if applied fast enough - in practice usually 4.


/obj/projectile/magic/blowingdust/on_hit(target, mob/living/M)
	. = ..()
	if(!istype(M))
		return
	if(target)
		to_chat(target, span_warning("Gah! Something.. got in my - eyes.."))
		M.blur_eyes(2)
