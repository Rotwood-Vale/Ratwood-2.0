/obj/effect/proc_holder/spell/self/suicidebomb
	name = "Calcic Outburst"
	desc = "Explode in a wonderful blast of osseous shrapnel."
	overlay_state = "tragedy"
	chargedrain = 0
	chargetime = 0
	recharge_time = 10 SECONDS
	sound = 'sound/magic/swap.ogg'
	warnie = "spellwarning"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	stat_allowed = TRUE
	var/exp_heavy = 3
	var/exp_light = 5
	var/exp_flash = 5
	var/exp_fire = 4

/obj/effect/proc_holder/spell/self/suicidebomb/cast(list/targets, mob/living/user = usr)
	..()
	if(!user)
		return FALSE
	if(user.stat == DEAD)
		return FALSE
	if(alert(user, "Do you wish to sacrifice this vessel in a powerful explosion?", "ELDRITCH BLAST", "Yes", "No") == "No")
		return FALSE
	playsound(get_turf(user), 'sound/magic/antimagic.ogg', 100)
	user.visible_message(
		span_danger("[user] begins to shake violently, a blindingly bright light beginning to emanate from them!"), 
		span_danger("Powerful energy begins to expand outwards from inside me!")
	)

	user.Immobilize(5 SECONDS)
	user.Knockdown(5 SECONDS)
	user.Jitter(5 SECONDS) //Makes you shake + Telegraphs a bit more with a scream
	user.emote("scream")

	addtimer(CALLBACK(src, PROC_REF(lichdeath), user), 5 SECONDS)

/obj/effect/proc_holder/spell/self/suicidebomb/proc/lichdeath(mob/living/user)
	var/datum/antagonist/lich/lichman = user.mind.has_antag_datum(/datum/antagonist/lich)
	explosion(get_turf(user), -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire, soundin = 'sound/misc/explode/incendiary (1).ogg')
	if(lichman && user.stat != DEAD && lichman.consume_phylactery(0)) // Use phylactery at 0 timer. Die if none.
		return TRUE

	user.death()
	return TRUE

/obj/effect/proc_holder/spell/self/suicidebomb/lesser
	name = "Lesser Calcic Outburst"
	desc = "Explode in a wonderful blast of osseous shrapnel."
	exp_heavy = 0
	exp_light = 2
	exp_flash = 2
	exp_fire = 0

/obj/effect/proc_holder/spell/self/sapperbomb
	name = "Calcic Obliteration"
	desc = "Explode in a wonderful arcayne blast of osseous shrapnel, specially prepared to tear down the walls and buildings that would halt the advance of your fellow legionnaries. \
	takes more time to explode compared to regular calic outburst, cannot be triggered manually by your Exarch."
	overlay_state = "firewalk"
	chargedrain = 0
	chargetime = 0
	recharge_time = 10 SECONDS
	sound = 'sound/magic/swap.ogg'
	warnie = "spellwarning"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	stat_allowed = TRUE

/obj/effect/proc_holder/spell/self/sapperbomb/cast(list/targets, mob/living/user = usr)
	..()
	if(!user)
		revert_cast()
		return FALSE
	if(user.stat == DEAD)
		revert_cast()
		return FALSE
	if(alert(user, "Do you wish to sacrifice this vessel in a specialised powerful explosion?", "ELDRITCH SAPPER BLAST", "Yes", "No") == "No")
		revert_cast()
		return FALSE

	user.Immobilize(8 SECONDS)
	user.Knockdown(8 SECONDS)
	user.Jitter(8 SECONDS) //Makes you shake + Telegraphs a bit more with a scream
	user.emote("scream")

	addtimer(CALLBACK(src, PROC_REF(sapper_explode), user), 8 SECONDS) //A bit of reaction time, this explosion is absolutely horrifying to be inside of and will fuck you up.
	return TRUE

/obj/effect/proc_holder/spell/proc/sapper_explode(mob/living/user)


	playsound(get_turf(user), 'sound/magic/soulshot.ogg', 100) //Unique que a sapper has popped off
	user.visible_message(
		span_danger("[user] begins to shake and convulse violently, slowly beginning to glow in a violently blinding light that emanates from them!")
	)

	explosion(get_turf(user), 3, 3, 4, 4, flame_range = 2, soundin = 'sound/misc/explode/incendiary (1).ogg') //This will destroy walls and absolutely FUCK UP people nearby.

	user.gib()
	return TRUE
