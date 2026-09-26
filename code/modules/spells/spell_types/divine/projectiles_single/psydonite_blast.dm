/////////////////////////////////
// PSYDON... BLASssss-- huh?  //
////////////////////////////////

//A joke spell for missionaries, there's a 99% chance you get a rock, a 1% you get a boulder from your shoe
//Hilarious

/obj/effect/proc_holder/spell/invoked/psydon/enduring_blast //Hilarious
	name = "ENDURING BLAST"
	desc = "'Now, where did I put that..?' </br>Checks your boot - or failing that, your surroundings - for something worthy of enacting HIS divine fury."
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "ENDURINGBLAST"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = null
	range = 1
	sound = null
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	miracle = TRUE
	devotion_cost = 10

/obj/effect/proc_holder/spell/invoked/psydon/enduring_blast/cast(list/targets, mob/living/user)
	. = ..()
	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/H = user
	var/turf/T = get_turf(user)
	if(!T)
		return FALSE

	var/obj/item/found_thing
	if(prob(99))
		found_thing = new /obj/item/natural/stone/enduring(T)
		to_chat(H, span_info("I pluck a [found_thing] from my boot, for unleashing his wraith upon HIS enemies!"))
	else
		found_thing = new /obj/item/natural/rock(T) //HILARIOUS
		to_chat(H, span_info("I pluck a [found_thing] from my boot... wait, how did that even fit in there?!"))

	if(!H.put_in_hands(found_thing, FALSE))
		found_thing.forceMove(T)

	return TRUE
