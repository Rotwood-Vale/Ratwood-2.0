/*
	MAURICE

	The Gutter King's messenger mole. Spawned by The Word to deliver the boss' message
	directly to each Scum member. Not hostile, not durable, doesn't stick around.
	Just digs up, says his piece, and goes.
*/

/mob/living/simple_animal/pet/maurice
	name = "maurice"
	desc = "A small, well-travelled mole. He seems to know something you don't."
	icon = 'icons/roguetown/mob/monster/mole.dmi'
	icon_state = "mole"
	icon_living = "mole"
	icon_dead = "mole_dead"
	gender = MALE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	density = FALSE
	pass_flags = PASSMOB
	turns_per_move = 0
	speak_chance = 0
	see_in_dark = 6
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "nudges aside"
	response_disarm_simple = "nudge aside"
	response_harm_continuous = "prods"
	response_harm_simple = "prod"
	melee_damage_lower = 0
	melee_damage_upper = 0
	faction = list("rogueanimal", "neutral")
	maxHealth = 1
	health = 1
	pooptype = null
	butcher_results = null
	///The message being delivered. Set before sending.
	var/pending_message = null
	///Name of the Gutter King who sent the message.
	var/sender_name = null
	///If TRUE, this Maurice lives here and won't qdel after delivering.
	var/permanent = FALSE
	///Home turf for permanent Maurice to return to after delivery.
	var/turf/home_turf = null

/mob/living/simple_animal/pet/maurice/Initialize(mapload)
	. = ..()
	transform = transform.Scale(0.4, 0.4)
	if(permanent)
		home_turf = get_turf(src)

/mob/living/simple_animal/pet/maurice/attack_hand(mob/user)
	switch(rand(1, 4))
		if(1)
			visible_message(span_notice("Maurice shuffles contentedly under [user]'s hand."))
		if(2)
			visible_message(span_notice("Maurice's little nose twitches. He tolerates this."))
		if(3)
			visible_message(span_notice("Maurice pushes his snout into [user]'s palm briefly."))
		if(4)
			visible_message(span_notice("Maurice regards [user] with calm, impenetrable eyes."))

/mob/living/simple_animal/pet/maurice/attackby(obj/item/I, mob/user, params)
	visible_message(span_notice("Maurice sidesteps [user]'s prod with quiet dignity."))

///Delivers the message. Permanent Maurice walks to the target and whispers; temp ones dig up and whisper in place.
/mob/living/simple_animal/pet/maurice/proc/deliver(mob/living/carbon/human/target)
	if(QDELETED(src) || QDELETED(target))
		return

	if(permanent)
		// Walk over to the target
		walk_to(src, target, 1, 4)
		var/elapsed = 0
		while(get_dist(src, target) > 1 && elapsed < 20 SECONDS)
			sleep(0.5 SECONDS)
			elapsed += 0.5 SECONDS
			if(QDELETED(src) || QDELETED(target))
				walk(src, 0)
				return
		walk(src, 0)
		if(QDELETED(src) || QDELETED(target))
			return
	else
		visible_message(span_notice("The dirt nearby shifts. A small mole nose pokes through, then the rest of maurice follows."))
		sleep(1.5 SECONDS)
		if(QDELETED(src) || QDELETED(target))
			return

	whisper("\"[pending_message]\"", forced = "maurice")

	sleep(3 SECONDS)
	if(QDELETED(src))
		return

	if(permanent)
		visible_message(span_notice("Maurice tucks his nose back under his paws and goes still."))
		if(home_turf)
			walk_to(src, home_turf, 0, 4)
	else
		visible_message(span_notice("Maurice sniffs the air once, then disappears back into the earth."))
		qdel(src)

// Place this subtype on the map. He lives here.
/mob/living/simple_animal/pet/maurice/resident
	permanent = TRUE
	emote_see = list("shuffles in place.", "twitches his nose.", "scratches idly at the dirt.")

