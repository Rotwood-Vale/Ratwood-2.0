/datum/wound/fracture
	name = "骨折"
	check_name = span_bone("<B>骨折</B>")
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"骨头碎裂了！",
		"骨头断了！",
		"%BODYPART被重创了！",
		"断骨刺穿了皮肉！",
	)
	sound_effect = "wetbreak"
	whp = 40
	woundpain = 100
	mob_overlay = "frac"
	can_sew = FALSE
	can_cauterize = FALSE
	disabling = TRUE
	critical = TRUE
	sleep_healing = 0 // no sleep healing that is silly

	werewolf_infection_probability = 0
	/// Whether or not we can be surgically set
	var/can_set = TRUE
	/// Emote we use when applied
	var/gain_emote = "paincrit"

	// Limbs bleed worse, but bleed for far shorter periods than slashes etc.
	bleed_rate = 15				// Artery is 20, but doesn't stop.
	clotting_threshold = 0.25	// Grusome slash is 0.4
	clotting_rate = 0.60		// Normally it's only 0.02, this is huge compared to that.
	bypass_bloody_wound_check = TRUE	//We bypass this proc-checkfor fractures.

//Ooze stuff start
/datum/wound/fracture/can_apply_to_bodypart(obj/item/bodypart/affected)
	if(isooze(affected.owner))
		return FALSE
	return ..()
//Ooze stuff end

/datum/wound/fracture/get_visible_name(mob/user)
	. = ..()
	if(passive_healing)
		. += " <span class='green'>(已复位)</span>"

/datum/wound/fracture/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/fracture) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/fracture/on_mob_gain(mob/living/affected)
	. = ..()
	if(gain_emote)
		affected.emote(gain_emote, TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/fracture/proc/set_bone()
	if(!can_set)
		return FALSE
	sleep_healing = max(sleep_healing, 1)
	passive_healing = max(passive_healing, 1)
	heal_wound(initial(whp)/1.6) //heal a little more than of maximum fracture
	can_set = FALSE
	return TRUE

/datum/wound/fracture/head
	name = "颅骨骨折"
	check_name = span_bone("<B>颅裂</B>")
	crit_message = list(
		"头骨以骇人的方式碎裂了！",
		"脑袋被砸烂了！",
		"头骨裂开了！",
		"头骨凹陷下去了！",
	)
	sound_effect = "headcrush"
	whp = 150
	sleep_healing = 0
	/// Most head fractures are serious enough to cause paralysis.
	var/paralysis = TRUE
	/// Some head fractures instantly kill you if you have critical weakness. Others won't.
	mortal = TRUE
	/// Some head fractures will knock your lights out, if not flat-out paralyze you.
	var/knockout = 10	//10 tick knockout (1 sec)

/datum/wound/fracture/head/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_DISFIGURED, "[type]")
	if(knockout)
		affected.Unconscious(knockout)
	if(paralysis)
		ADD_TRAIT(affected, TRAIT_NO_BITE, "[type]")
		ADD_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
		ADD_TRAIT(affected, TRAIT_NOPAIN, "[type]")
		if(iscarbon(affected))
			var/mob/living/carbon/carbon_affected = affected
			carbon_affected.update_disabled_bodyparts()

/datum/wound/fracture/head/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_DISFIGURED, "[type]")
	if(paralysis)
		REMOVE_TRAIT(affected, TRAIT_NO_BITE, "[type]")
		REMOVE_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
		REMOVE_TRAIT(affected, TRAIT_NOPAIN, "[type]")
		if(iscarbon(affected))
			var/mob/living/carbon/carbon_affected = affected
			carbon_affected.update_disabled_bodyparts()

/datum/wound/fracture/head/on_life()
	. = ..()
	owner?.stuttering = max(owner.stuttering, 5)

/datum/wound/fracture/head/brain
	name = "凹陷性颅骨骨折"
	severity = WOUND_SEVERITY_FATAL
	crit_message = list(
		"颅骨被刺穿了！",
		"颅骨被贯穿了！",
		"颅骨被撕裂了！",
	)
	embed_chance = 100	// Didn't we remove embeding..?
	bleed_rate = 10		// Aooouuugh.. my brain..
	knockout = 20
	paralysis = TRUE

/datum/wound/fracture/head/eyes
	name = "眶骨骨折"
	crit_message = list(
		"眶骨被刺穿了！",
		"眶骨被贯穿了！",
		"眼窝被刺穿了！",
		"眼窝被贯穿了！",
	)
	embed_chance = 100
	clotting_threshold = 0.4	//Eye-bone fucked
	paralysis = FALSE			//Fucks your eyes, but won't paralyze you anymore.

/datum/wound/fracture/head/eyes/on_mob_gain(mob/living/affected)
	. = ..()
	affected.become_blind("[type]")
	addtimer(CALLBACK(affected, TYPE_PROC_REF(/mob/living, cure_blind), "[type]"), 30 SECONDS)
	affected.become_nearsighted("[type]")

/datum/wound/fracture/head/eyes/on_mob_loss(mob/living/affected)
	. = ..()
	affected.cure_blind("[type]")	//Fallback incase you somehow get un-skullcracked before the timer.
	affected.cure_nearsighted("[type]")

/datum/wound/fracture/head/ears
	name = "颞骨骨折"
	severity = WOUND_SEVERITY_FATAL
	crit_message = list(
		"眶骨被刺穿了！",
		"颞骨被贯穿了！",
		"耳道被刺穿了！",
		"耳道被贯穿了！",
	)
	embed_chance = 100
	paralysis = FALSE
	knockout = 25
	clotting_threshold = 0.3	//Ears gonna bleed worse than just a fracture

/datum/wound/fracture/head/ears/on_mob_gain(mob/living/affected)
	. = ..()
	to_chat(affected, span_warning("耳中先是嗡鸣，随后一切声音骤然消失！"))
	affected.confused += 25	//Drunk-walk effect, basically.
	affected.dizziness += 25
	ADD_TRAIT(affected, TRAIT_DEAF, "[type]")

/datum/wound/fracture/head/ears/on_mob_loss(mob/living/affected)
	. = ..()
	to_chat(affected, span_notice("我的听觉正慢慢恢复回来.."))
	affected.confused -= 25
	affected.dizziness -= 25
	REMOVE_TRAIT(affected, TRAIT_DEAF, "[type]")

/datum/wound/fracture/head/nose
	name = "鼻骨骨折"
	crit_message = list(
		"鼻骨被刺穿了！",
		"鼻骨被贯穿了！",
	)
	paralysis = FALSE	//Fucks your nose, but won't paralyze you anymore.
	knockout = 20		//Longer knockout than a normal head-fracture
	clotting_threshold = 0.3	//Nose bleeds as bad as ears gonna bleed worse than just a fracture

/datum/wound/fracture/head/nose/on_mob_gain(mob/living/affected)
	. = ..()
	affected.confused += 15	//Strong-drunk-walk effect, basically.
	affected.dizziness += 15
	ADD_TRAIT(affected, TRAIT_MISSING_NOSE, "[type]")
	ADD_TRAIT(affected, TRAIT_DISFIGURED, "[type]")

/datum/wound/fracture/head/nose/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_MISSING_NOSE, "[type]")
	REMOVE_TRAIT(affected, TRAIT_DISFIGURED, "[type]")

/datum/wound/fracture/mouth
	name = "下颌骨骨折"
	check_name = span_bone("下颌骨骨折")
	crit_message = list(
		"下颌骨利落地裂开了！",
		"下巴被砸碎了！",
		"下巴碎裂了！",
		"下巴凹陷下去了！",
	)
	mortal = FALSE
	whp = 50
	bleed_rate = 5				//Lower than others, still bad though. 
	clotting_threshold = 0.3	//Slightly higher still
	clotting_rate = 0.1			//Slower clotting, not bad though for bleeder wound.

/datum/wound/fracture/mouth/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_NO_BITE, "[type]")
	ADD_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/fracture/mouth/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_NO_BITE, "[type]")
	REMOVE_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/fracture/neck
	name = "颈椎骨折"
	check_name = span_bone("<B>颈部</B>")
	crit_message = list(
		"脊椎以惊人的方式碎裂了！",
		"脊椎断裂了！",
		"脊椎开裂了！",
		"脊椎断了！",
	)
	whp = 100

/datum/wound/fracture/neck/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
	ADD_TRAIT(affected, TRAIT_NOPAIN, "[type]")
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.update_disabled_bodyparts()
	if(HAS_TRAIT(affected, TRAIT_CRITICAL_WEAKNESS))
		affected.emote("deathgurgle", forced = TRUE)
		affected.death()

/datum/wound/fracture/neck/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
	REMOVE_TRAIT(affected, TRAIT_NOPAIN, "[type]")
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.update_disabled_bodyparts()

/datum/wound/fracture/chest
	name = "肋骨骨折"
	check_name = span_bone("<B>肋骨</B>")
	crit_message = list(
		"肋骨以惊人的方式碎裂了！",
		"肋骨被砸碎了！",
		"肋骨被重创了！",
		"胸廓凹陷下去了！",
	)
	whp = 50
	bleed_rate = 25				//Higher than artery
	clotting_threshold = 1		//Will always bleed bad
	clotting_rate = 1			//Good clotting rate; within 24 ticks (~3 seconds) will lower heavily.

/datum/wound/fracture/chest/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Immobilize(15)		//Stuns you, major downside
	if(istype(affected, /mob/living/carbon)) // Intended for PVE skeletons
		var/mob/living/carbon/CA = affected
		if(HAS_TRAIT(CA, TRAIT_CRITICAL_WEAKNESS) && (NOBLOOD in CA.dna.species.species_traits))
			CA.death()

/datum/wound/fracture/chest/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.stat && prob(5))
		carbon_owner.vomit(1, blood = TRUE, stun = TRUE)

/datum/wound/fracture/groin
	name = "骨盆骨折"
	check_name = span_bone("<B>骨盆</B>")
	crit_message = list(
		"骨盆以惊人的方式碎裂了！",
		"骨盆被砸碎了！",
		"骨盆被重创了！",
		"骨盆底塌陷下去了！",
	)
	whp = 50
	gain_emote = "groin"	//MY PIINTLE!!!!
	mortal = FALSE
	bleed_rate = 5
	clotting_threshold = 1
	clotting_rate = 0.5

/datum/wound/fracture/groin/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Immobilize(15)
	ADD_TRAIT(affected, TRAIT_PARALYSIS_R_LEG, "[type]")
	ADD_TRAIT(affected, TRAIT_PARALYSIS_L_LEG, "[type]")
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.update_disabled_bodyparts()

/datum/wound/fracture/groin/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_PARALYSIS_R_LEG, "[type]")
	REMOVE_TRAIT(affected, TRAIT_PARALYSIS_L_LEG, "[type]")
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.update_disabled_bodyparts()
