/datum/coven/zizo
	name = "Zizo"
	desc = "The Coven of the God-Head, Necra's mortal twin who slew PSYDON and shattered his comet. The snow elf Zinoviya was denied divinity, so she took it by force through the Dark Art. Vampires of this coven are necromancers who channel the Second Coming of the Rot, seeking comet shards to join Zizo's corrupted throne and rebuild the world through mass extinction."
	power_type = /datum/coven_power/zizo
	max_level = 4
	icon_state = "zizo"
	is_god_coven = TRUE

/datum/coven_power/zizo

// Level 1 - Raise Thrall
/datum/coven_power/zizo/raise_thrall
	name = "Raise Thrall"
	desc = "Reanimate a corpse as your undead servant. Zizo's gift to those who embrace undeath."
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 3
	cooldown_length = 120 SECONDS

/datum/coven_power/zizo/raise_thrall/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!istype(target, /obj/effect/decal/remains) && !istype(target, /mob/living/carbon/human))
		to_chat(user, span_warning("I need a corpse to raise."))
		return FALSE
	
	user.visible_message(span_danger("[user] channels necromantic energy into [target]!"))
	playsound(get_turf(target), 'sound/magic/churn.ogg', 100, TRUE)
	
	var/mob/living/simple_animal/hostile/rogue/skeleton/S = new(get_turf(target))
	
	
	if(istype(target, /obj/effect/decal/remains))
		qdel(target)
	
	return TRUE

// Level 2 - Necrotic Bolt
/datum/coven_power/zizo/necrotic_bolt
	name = "Necrotic Bolt"
	desc = "Hurl a bolt of death energy that withers flesh and drains life. The power of the necromancer queen."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 7
	cooldown_length = 60 SECONDS

/datum/coven_power/zizo/necrotic_bolt/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!isliving(target))
		to_chat(user, span_warning("I can only strike the living."))
		return FALSE
	
	var/mob/living/victim = target
	user.visible_message(span_danger("A bolt of necrotic energy flies from [user] toward [victim]!"))
	
	victim.adjustBruteLoss(35)
	victim.adjustFireLoss(15)
	to_chat(victim, span_userdanger("Necrotic energy withers my flesh!"))
	
	user.adjustBruteLoss(-20)
	user.blood_volume = min(user.blood_volume + 20, BLOOD_VOLUME_MAXIMUM)
	
	playsound(get_turf(victim), 'sound/magic/vlightning.ogg', 100, TRUE)
	
	return TRUE

// Level 3 - Undying Form
/datum/coven_power/zizo/undying_form
	name = "Undying Form"
	desc = "Embrace your undead nature fully, becoming immune to many mortal weaknesses. Death cannot claim what is already dead."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 150 SECONDS
	var/form_duration = 60 SECONDS

/datum/coven_power/zizo/undying_form/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_userdanger("I embrace undeath fully!"))
	user.visible_message(span_danger("[user] becomes wreathed in necrotic energy!"))
	
	ADD_TRAIT(user, TRAIT_CABAL, "undying_form")
	ADD_TRAIT(user, TRAIT_ZIZOSIGHT, "undying_form")
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "undying_form")
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, "undying_form")
	ADD_TRAIT(user, TRAIT_NOSTINK, "undying_form")
	
	user.mob_biotypes |= MOB_UNDEAD
	
	addtimer(CALLBACK(src, PROC_REF(remove_form), user), form_duration)
	return TRUE

/datum/coven_power/zizo/undying_form/proc/remove_form(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_CABAL, "undying_form")
	REMOVE_TRAIT(user, TRAIT_ZIZOSIGHT, "undying_form")
	REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "undying_form")
	REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "undying_form")
	REMOVE_TRAIT(user, TRAIT_NOSTINK, "undying_form")
	to_chat(user, span_warning("The undying form fades..."))

// Level 4 - Lich Ascension
/datum/coven_power/zizo/lich_ascension
	name = "Lich Ascension"
	desc = "Ascend as Zizo's chosen, becoming a lich with immense necromantic power. Command the dead and wither the living with your very presence."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	var/ascension_duration = 50 SECONDS

/datum/coven_power/zizo/lich_ascension/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("I ASCEND AS THE LICH! DEATH ANSWERS TO ME!"))
	user.visible_message(span_danger("[user] transforms into a powerful lich!"))
	
	user.set_light(8, 6, "#00ff00")
	ADD_TRAIT(user, TRAIT_CABAL, "lich_ascension")
	ADD_TRAIT(user, TRAIT_ZIZOSIGHT, "lich_ascension")
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "lich_ascension")
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, "lich_ascension")
	ADD_TRAIT(user, TRAIT_NOSTINK, "lich_ascension")
	user.mob_biotypes |= MOB_UNDEAD
	
	// Summon undead army
	for(var/i in 1 to 4)
		var/turf/T = get_step(user, pick(GLOB.cardinals))
		var/mob/living/simple_animal/hostile/rogue/skeleton/S = new(T)
		S.faction = user.faction
	
	addtimer(CALLBACK(src, PROC_REF(end_ascension), user), ascension_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/zizo/lich_ascension/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		end_ascension(user)
		return
	
	user.adjustBruteLoss(-12)
	user.adjustFireLoss(-12)
	
	for(var/mob/living/L in view(5, user))
		if(L == user)
			continue
		if(L.mob_biotypes & MOB_UNDEAD)
			continue
		
		L.adjustBruteLoss(12)
		to_chat(L, span_userdanger("The lich's presence withers me!"))

/datum/coven_power/zizo/lich_ascension/proc/end_ascension(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_CABAL, "lich_ascension")
		REMOVE_TRAIT(user, TRAIT_ZIZOSIGHT, "lich_ascension")
		REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "lich_ascension")
		REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "lich_ascension")
		REMOVE_TRAIT(user, TRAIT_NOSTINK, "lich_ascension")
		user.set_light(0)
		to_chat(user, span_warning("The lich ascension ends..."))
