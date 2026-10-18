/datum/patron/old_god
	name = "Psydon"
	domain = "Life, Creation, Compassion and Perseverance"
	desc = "The One arrived to PSYDONIA on the COMET SYON, reshaping the barren world in His image. He was struck down by the Necromantress Zizo; some believe Him dead, others slumbering. May we ENDURE in His name."
	worshippers = "Ancient Dwarves and Elves, Zybantines, Otavans, Those Who Dream of Peace"
	virtues = "Peace, Resilience, Stubbornness"
	sins = "Witchcraft, Sadism, Overindulgence"
	associated_faith = /datum/faith/old_god
	mob_traits = list(TRAIT_PSYDONIAN_GRIT)
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/self/check_boot				= CLERIC_T0,
					/obj/effect/proc_holder/spell/invoked/psydonendure			= CLERIC_T1,
					/obj/effect/proc_holder/spell/self/psydonrespite			= CLERIC_T2,
					/obj/effect/proc_holder/spell/invoked/psydefy				= CLERIC_T3,
	)
	energy_color = COLOR_PATRON_PSYDON
	traits_tier = list(TRAIT_PSYDONITE = CLERIC_T1)
	confess_lines = list(
		"THERE IS ONLY ONE TRUE GOD!",
		"PSYDON YET LYVES! PSYDON YET ENDURES!",
		"REBUKE THE HEATHEN, SUNDER THE MONSTER!",
		"WITH EVERY BROKEN BONE, I SWORE I LYVED!",
		"FORGIVE THEM, ALLFATHER, FOR THEY KNOW-NOT WHAT THEY DO!",
		"BARE WITNESS, MY GOD; THE SACRIFICE MADE MANIFEST!",
	)


/obj/effect/proc_holder/spell/self/check_boot
	name = "BOOT-CHECK"
	desc = "Checks your boot for variety of items."
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "BOOTCHECK"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = null
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 MINUTES
	miracle = TRUE
	devotion_cost = 30
	range = 1
	var/static/list/lootpool = list(/obj/item/flowercrown/rosa,
	/obj/item/bouquet/rosa,
	/obj/item/jingle_bells,
	/obj/item/bouquet/salvia,
	/obj/item/bouquet/calendula,
	/obj/item/roguecoin/gold,
	/obj/item/roguecoin/silver,
	/obj/item/roguecoin/copper,
	/obj/item/alch/atropa,
	/obj/item/alch/salvia,
	/obj/item/alch/artemisia,
	/obj/item/alch/rosa,
	/obj/item/rogueweapon/huntingknife/idagger/navaja,
	/obj/item/lockpick,
	/obj/item/reagent_containers/glass/bottle/alchemical/strpot,
	/obj/item/reagent_containers/glass/bottle/alchemical/endpot,
	/obj/item/reagent_containers/glass/bottle/alchemical/conpot,
	/obj/item/reagent_containers/glass/bottle/alchemical/lucpot,
	/obj/item/reagent_containers/glass/bottle/rogue/poison,
	/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
	/obj/item/needle,
	/obj/item/natural/rock,
	/obj/item/natural/bundle/cloth,
	/obj/item/natural/bundle/fibers,
	/obj/item/clothing/suit/roguetown/armor/leather/hide/bikini,
	/obj/item/reagent_containers/glass/bottle/waterskin/milk,
	/obj/item/reagent_containers/food/snacks/rogue/bread,
	/obj/item/reagent_containers/food/snacks/grown/apple,
	/obj/item/natural/worms,
	/obj/item/natural/worms/leech,
	/obj/item/reagent_containers/food/snacks/rogue/psycrossbun,
	/obj/item/clothing/neck/roguetown/psicross,
	/obj/item/clothing/neck/roguetown/psicross/wood,
	/obj/item/rope/chain,
	/obj/item/rope,
	/obj/item/clothing/neck/roguetown/collar/leather,
	/obj/item/natural/dirtclod,
	/obj/item/reagent_containers/glass/cup/wooden,
	/obj/item/natural/glass,
	/obj/item/clothing/shoes/roguetown/sandals,
	/obj/item/alch/transisdust)

/obj/effect/proc_holder/spell/self/check_boot/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	var/obj/item/found_thing
	if(H.get_stress_amount() < 0 && H.STALUC > 10)
		found_thing = new /obj/item/roguecoin/gold
	else if(H.STALUC == 10)
		found_thing = new /obj/item/roguecoin/silver
	else
		found_thing = new /obj/item/roguecoin/copper
	to_chat(H, span_info("A coin in my boot? Psydon smiles upon me!"))
	H.put_in_hands(found_thing, FALSE)
	if(prob(H.STALUC + H.get_skill_level(associated_skill)))
		var/extra_path = pick(lootpool)
		var/obj/item/extra_thing = new extra_path(get_turf(user))
		to_chat(H, span_info("Ah, of course! I almost forgot I had this stashed away for a perfect occasion."))
		H.put_in_hands(extra_thing, FALSE)
	return TRUE



/////////////////////////////////
// Does God Hear Your Prayer ? //
/////////////////////////////////
// no he's dead - ok maybe he does

/datum/patron/old_god/can_pray(mob/living/follower)
	. = ..()
	. = TRUE
	// Allows prayer near psycross.
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer if raining and outside. Psydon weeps.
	if(GLOB.forecast == "rain")
		if(istype(get_area(follower), /area/rogue/outdoors))
			return TRUE
	// Allows prayer if bleeding.
	if(follower.bleed_rate > 0)
		return TRUE
	// Allows prayer if holding silver psycross.
	if(istype(follower.get_active_held_item(), /obj/item/clothing/neck/roguetown/psicross/silver))
		return TRUE
	if(HAS_TRAIT(follower, TRAIT_LUX_FREAK)) // the ones that became psydons temple in of themselves
		return TRUE
	to_chat(follower, span_danger("For Psydon to hear my prayer I must either must be near a Pantheon Cross, shed my own blood in penitence, hold one of his silver holy symbols, or bask in his rain; as Psydon weeps for his children.."))
	return FALSE

//////////////////////////////////
// 	    ENDVRE. AS DOES HE.    //
////////////////////////////////

/obj/effect/proc_holder/spell/invoked/psydonendure
	name = "ENDURE"
	desc = "At the cost of some lyfe sustaining blood, I can mend the wounds of my target."
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "ENDURE"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/ENDVRE.ogg'
	invocations = list("LYVE, ENDURE!") // holy larp yelling for healing is silly
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS
	miracle = TRUE
	devotion_cost = 40


/obj/effect/proc_holder/spell/invoked/psydonendure/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/brute = target.getBruteLoss()
		var/burn = target.getFireLoss()
		var/list/wAmount = target.get_wounds()
		var/conditional_buff = FALSE
		var/situational_bonus = 0
		var/psicross_bonus = 0
		var/pp = 0
		var/damtotal = brute + burn
		var/zcross_trigger = FALSE
		if(user.patron?.undead_hater && (target.mob_biotypes & MOB_UNDEAD)) // YOU ARE NO LONGER MORTAL. NO LONGER OF HIM. PSYDON WEEPS.
			target.visible_message(span_danger("[target] shudders with a strange stirring feeling!"), span_userdanger("It hurts. You feel like weeping."))
			target.adjustBruteLoss(40)
			return TRUE

		// Bonuses! Flavour! SOVL!
		for(var/obj/item/clothing/neck/current_item in target.get_equipped_items(TRUE))
			if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient, /obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/decrepit, /obj/item/clothing/neck/roguetown/psicross/silver,	/obj/item/clothing/neck/roguetown/psicross/g))
				pp += 1
				if(pp >= 12 & target == user) // A harmless easter-egg. Only applies on self-cast. You'd have to be pretty deliberate to wear 12 of them.
					target.visible_message(span_danger("[target]'s many psycrosses reverberate with a strange, ephemeral sound..."), span_userdanger("HE must be waking up! I can hear it! I'm ENDURING so much!"))
					playsound(user, 'sound/magic/PSYDONE.ogg', 100, FALSE)
					sleep(60)
					user.psydo_nyte()
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(20)
					user.psydo_nyte()
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(15)
					user.psydo_nyte()
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(10)
					user.gib()
					return FALSE

				switch(current_item.type) // Target-based worn Psicross Piety bonus. For fun.
					if(/obj/item/clothing/neck/roguetown/psicross/wood)
						psicross_bonus = 0.1
					if(/obj/item/clothing/neck/roguetown/psicross/decrepit)
						psicross_bonus = 0.2
					if(/obj/item/clothing/neck/roguetown/psicross)
						psicross_bonus = 0.3
					if(/obj/item/clothing/neck/roguetown/psicross/silver)
						psicross_bonus = 0.4
					if(/obj/item/clothing/neck/roguetown/psicross/g) // PURITY AFLOAT.
						psicross_bonus = 0.4
					if(/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient)
						zcross_trigger = TRUE

		if(damtotal >= 300) // ARE THEY ENDURING MUCH, IN ONE WAY OR ANOTHER?
			situational_bonus += 0.3

		if(wAmount.len > 5)
			situational_bonus += 0.3

		if (situational_bonus > 0)
			conditional_buff = TRUE

		target.visible_message(span_info("A strange stirring feeling pours from [target]!"), span_info("Sentimental thoughts drive away my pain..."))
		var/psyhealing = 3
		psyhealing += psicross_bonus

		if(HAS_TRAIT(user, TRAIT_LUX_FREAK) && zcross_trigger) // LUX ABOMINATIONS WONT STOP SO EASLY!!!
			user.visible_message(span_warning("[user] shudders as their eyes briefly wash over with a sickly shade of silver!"), span_userdanger("Ice shoots up my spine as the ARCHENEMY's laughter resonates in my skull! I will ENDURE this trial!"))
			zcross_trigger = FALSE

		if (conditional_buff & !zcross_trigger)
			to_chat(user, "In <b>ENDURING</b> so much, become <b>EMBOLDENED</b>!")
			psyhealing += situational_bonus

		if (zcross_trigger)
			user.visible_message(span_warning("[user] shuddered. Something's very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
			user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
			user.adjustBruteLoss(25)
			return FALSE

		target.apply_status_effect(/datum/status_effect/buff/psyhealing, psyhealing)
		user.set_blood_volume(max(user.get_blood_volume()-30, 0))//We don't care about scaling, for this one.
		return TRUE

	revert_cast()
	return FALSE


/obj/effect/proc_holder/spell/invoked/psydefy
	name = "DEFY"
	desc = "I can give a dying person or myself enough strength to ENDURE just a bit longer, to have a chance to leave their mark on the world before their flame goes out. (ONLY USABLE ON PEOPLE IN CRIT / Using it while in crit will self cast)"
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "DEFY"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/ENDVRE.ogg'
	invocation_type = "none" // needs to be castable when uncontius
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 6 MINUTES
	miracle = TRUE
	stat_allowed = TRUE // Has a specific check for the dead, crit people can still self-cast
	gesture_required = FALSE
	devotion_cost = 150
	cast_without_targets = TRUE

/obj/effect/proc_holder/spell/invoked/psydefy/cast(list/targets, mob/living/user)
	if(user.stat == DEAD)
		to_chat(user, span_warning("You're dead, it's to late for displays of willpower."))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/target = null
	if(user.stat != CONSCIOUS)
		target = user
	if(!target && ishuman(targets[1]))
		target = targets[1]
	else if(!target)
		to_chat(user, span_warning("[name] only works on humanoids about to die that have enough will to ENDVRE!"))
		revert_cast()
		return FALSE

	var/wAmount = LAZYLEN(target.get_wounds())
	var/damtotal = target.getBruteLoss() + target.getFireLoss() + target.getToxLoss()

	if(!target.stat) // this is first as all the others give you information about target
		to_chat(user, span_warning("They are not in dire enought state for this miracle."))
		revert_cast()
		return FALSE
	if(target.stat == UNCONSCIOUS && !(damtotal >= 100 || wAmount > 0 || target.get_blood_volume() < BLOOD_VOLUME_OKAY) && target.IsSleeping()) // very long way of saying NO to sleep casting
		to_chat(user, span_warning("They are sleeping peacefully, there is no reason for them to stir so roughly."))
		revert_cast()
		return FALSE
	if(target.stat == DEAD) // are dead
		to_chat(user, span_warning("They're already dead!"))
		revert_cast()
		return FALSE
	if(target.mob_biotypes & MOB_UNDEAD) // still dead
		to_chat(user, span_warning("The unlyving cannot ENDVRE!"))
		revert_cast()
		return FALSE
	if(HAS_TRAIT(target, TRAIT_PARALYSIS))
		to_chat(user, span_warning("They're paralyzed, no amount of willpower will get them to move."))
		revert_cast()
		return FALSE
	if(istype(target.patron, /datum/patron/divine/necra)) // worship death
		to_chat(user, span_warning("They worship death, they do not have enough will to ENDVRE through their end."))
		revert_cast()
		return FALSE
	if(istype(target.patron, /datum/patron/inhumen/zizo)) // thinks they will get raised as undead
		to_chat(user, span_warning("They dont fear death, they dont see it as an end."))
		revert_cast()
		return FALSE
	if(HAS_TRAIT(target, TRAIT_NOBREATH)) // no avoiding oxy consequencess
		to_chat(user, span_warning("They dont see themselves as dying and lack a will to resist it."))
		revert_cast()
		return FALSE

	var/time = 30 SECONDS
	if(HAS_TRAIT(user, TRAIT_LUX_FREAK)) // extra bonus for absolver/stigmata for being full suports
		time += 15 SECONDS
	var/holy_skill = user.get_skill_level(src.associated_skill)
	time += holy_skill * 5 SECONDS
	target.apply_status_effect(/datum/status_effect/death_defiance, time) // max time is 1 minute 15 seconds for absolver/stigmata with legendary skill

	if(!HAS_TRAIT(user, TRAIT_LUX_FREAK)) // extra bonus for absolver/stigmata for being full suports
		user.apply_damage(100, BRUTE, spread_damage = TRUE)
		user.adjust_blood_volume(-100)

	return TRUE
	

/atom/movable/screen/alert/status_effect/death_defiance
	name = "Death Defience"
	desc = "I WILL NOT GO INTO THE NIGHT QUIETLY!"
	icon_state = "buff"

/datum/status_effect/death_defiance // TLDR = you dont die from tox, oxy, you cant be crit state, get crit resistance/reset it stacks, and get some will and con. You are not immortal, but your close to that
	id = "death_defy"
	effectedstats = list("willpower" = 5, "constitution" = 3)
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/death_defiance

/datum/status_effect/death_defiance/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/death_defiance/on_apply() // quite similar to martyrs ult
	. = ..()
	ADD_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_NOLIMBDISABLE, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_NOHUNGER, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_NOSLEEP, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_SHOCKIMMUNE, TRAIT_STATUS_EFFECT(id)) // no 12 seconds of stun on your last moments
	ADD_TRAIT(owner, TRAIT_NOPAIN, TRAIT_STATUS_EFFECT(id)) // pure adrenaline
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_BREADY, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_TOXIMMUNE, TRAIT_STATUS_EFFECT(id)) // doesnt heal them but does prevent further damage
	ADD_TRAIT(owner, TRAIT_NOHARDCRIT, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_NOSOFTCRIT, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_NODEATH, TRAIT_STATUS_EFFECT(id)) // I think it only stops oxy death?
	ADD_TRAIT(owner, TRAIT_NOBREATH, TRAIT_STATUS_EFFECT(id)) // sadly needed

	owner.setOxyLoss(0,TRUE)
	owner.remove_status_effect(/datum/status_effect/debuff/crit_resistance_cd) // resets crit resistance
	owner.remove_status_effect(STATUS_EFFECT_SLEEPING) 
	owner.remove_status_effect(/datum/status_effect/incapacitating/knockdown)
	owner.remove_status_effect(/datum/status_effect/incapacitating/stun) 
	owner.remove_status_effect(/datum/status_effect/incapacitating/unconscious)
	owner.stat = CONSCIOUS
	owner.update_stat()
	owner.energy_add(700)
	owner.stamina_add(-100) // rise back with full strength
	owner.visible_message(span_boldwarning("[owner] rises back on their feet, defying death with every movement."), span_boldwarning("I feel a surge of energy as I DEFY death."))
	owner.emote("scream", TRUE)
	owner.set_resting(FALSE, FALSE)
	owner.add_filter("death_defience", 2, list("type" = "outline", "color" = "#2e0000", "alpha" = 25,  "size" = 2))


/datum/status_effect/death_defiance/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_NOLIMBDISABLE, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_NOHUNGER, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_NOSLEEP, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_SHOCKIMMUNE, TRAIT_STATUS_EFFECT(id)) // no 12 seconds of stun on your last moments
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, TRAIT_STATUS_EFFECT(id)) // pure adrenaline
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_BREADY, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_TOXIMMUNE, TRAIT_STATUS_EFFECT(id)) // doesnt heal them but does prevent further damage
	REMOVE_TRAIT(owner, TRAIT_NOHARDCRIT, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_NOSOFTCRIT, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_NODEATH, TRAIT_STATUS_EFFECT(id)) // I think it only stops oxy death?
	REMOVE_TRAIT(owner, TRAIT_NOBREATH, TRAIT_STATUS_EFFECT(id)) // sadly needed

	owner.energy_add(-700)
	owner.stamina_add(100)
	owner.Stun(15 SECONDS)
	owner.Knockdown(15 SECONDS)
	if(!HAS_TRAIT(owner, TRAIT_DNR)) // last mercy to the ones without a second chance
		owner.adjustOxyLoss(130, TRUE)
	owner.update_stat()
	owner.visible_message(span_boldwarning("The strange energy filling the [owner] runs out, and their bathered body falls."), span_boldwarning("I feel my newfound energy and will to resist leave me."))
	owner.remove_filter("death_defience")



	
