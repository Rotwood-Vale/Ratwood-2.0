/datum/looping_sound/femhornylite
	mid_sounds = list('sound/vo/female/gen/se/horny1loop (1).ogg')
	mid_length = 470
	volume = 20
	extra_range = -4

/datum/looping_sound/femhornylitealt
	mid_sounds = list('sound/vo/female/gen/se/horny1loop (2).ogg')
	mid_length = 360
	volume = 20
	extra_range = -4

/datum/looping_sound/femhornymed
	mid_sounds = list('sound/vo/female/gen/se/horny2loop (1).ogg')
	mid_length = 420
	volume = 20
	extra_range = -4

/datum/looping_sound/femhornymedalt
	mid_sounds = list('sound/vo/female/gen/se/horny2loop (2).ogg')
	mid_length = 350
	volume = 20
	extra_range = -4

/datum/looping_sound/femhornyhvy
	mid_sounds = list('sound/vo/female/gen/se/horny3loop (1).ogg')
	mid_length = 440
	volume = 20
	extra_range = -4

/datum/looping_sound/femhornyhvyalt
	mid_sounds = list('sound/vo/female/gen/se/horny3loop (2).ogg')
	mid_length = 390
	volume = 20
	extra_range = -4

/mob/living
	var/can_do_sex = TRUE
	var/virginity = FALSE
	var/mpreg = FALSE
	var/mpreg_chance = IMPREG_PROB_DEFAULT

/**:
 * target/src is whomever the drag ends on. Inherited proc, needs to be a human.
 * user is the person who initiated the drag.
 * dragged is the object the drag was initiated on. Dragged may be anything.
 **/
/mob/living/carbon/human/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	var/mob/living/carbon/human/target = src

	if(user.mmb_intent)
		return ..()
	if(!istype(dragged))
		return
	// Need to drag yourself to the target.
	if(dragged != user)
		return
	if(!user.can_do_sex())
		to_chat(user, "<span class='warning'>I can't do this.</span>")
		return
	if(!user?.client?.prefs.sexable)
		to_chat(user, "<span class='warning'>I don't want to touch [target]. (Your ERP preference, in the options)</span>")
		return
	if(!target?.client?.prefs)
		to_chat(user, span_warning("[target] is simply not there. I can't do this."))
		log_combat(user, target, "tried ERP menu against d/ced")
		return
	if(!target.client.prefs.sexable)
		to_chat(user, "<span class='warning'>[target] doesn't want to be touched. (Their ERP preference, in the options)</span>")
		to_chat(target, "<span class='warning'>[user] failed to touch you. (Your ERP preference, in the options)</span>")
		log_combat(user, target, "tried unwanted ERP menu against")
		return
	user.sexcon.start(target)

/mob/living/proc/can_do_sex()
	return TRUE

/mob/living/carbon/human/proc/make_sucking_noise()
	if(gender == FEMALE)
		playsound(src, pick('sound/misc/mat/girlmouth (1).ogg','sound/misc/mat/girlmouth (2).ogg'), 25, TRUE, ignore_walls = FALSE)
	else
		playsound(src, pick('sound/misc/mat/guymouth (1).ogg','sound/misc/mat/guymouth (2).ogg','sound/misc/mat/guymouth (3).ogg','sound/misc/mat/guymouth (4).ogg','sound/misc/mat/guymouth (5).ogg'), 35, TRUE, ignore_walls = FALSE)

/mob/living/carbon/human/proc/try_impregnate(mob/living/carbon/human/wife)
	var/obj/item/organ/testicles/testes = getorganslot(ORGAN_SLOT_TESTICLES)
	if(!testes)
		return
	var/obj/item/organ/vagina/vag = wife.getorganslot(ORGAN_SLOT_VAGINA)
	if(!vag && !HAS_TRAIT(wife, TRAIT_BAOTHA_FERTILITY_BOON))
		return
	if(!is_virile())
		return
	if(vag)
		if(!wife.is_fertile())
			return
		var/prob_for_impreg = vag.impregnation_probability
		if(wife.sexcon.knotted_status) // if they're knotted, increased by two factor for dramatic impact
			prob_for_impreg =  min(prob_for_impreg * 2, IMPREG_PROB_MAX)
		if(HAS_TRAIT(wife, TRAIT_BAOTHA_FERTILITY_BOON))
			prob_for_impreg =  min(prob_for_impreg * 2, IMPREG_PROB_MAX) //if female has baotha boon increase chances
		if(prob(prob_for_impreg))
			vag.be_impregnated(src)
			vag.impregnation_probability = IMPREG_PROB_DEFAULT // Reset on success
		else
			vag.impregnation_probability = min(prob_for_impreg + IMPREG_PROB_INCREMENT, IMPREG_PROB_MAX)
	else
		var/prob_for_impreg = wife.mpreg_chance
		if(wife.sexcon.knotted_status)
			prob_for_impreg =  min(prob_for_impreg * 2, IMPREG_PROB_MAX)
		if(prob(prob_for_impreg))
			if(wife.mpreg)
				to_chat(wife, span_love("I feel a surge of warmth inside me again..."))
				return
			to_chat(wife, span_love("I feel a strange surge of warmth inside me... Am I pregnant?.."))
			wife.mpreg = TRUE
		else
			wife.mpreg_chance = min(prob_for_impreg + IMPREG_PROB_INCREMENT, IMPREG_PROB_MAX)

/mob/living/carbon/human/proc/get_highest_grab_state_on(mob/living/carbon/human/victim)
	var/grabstate = null
	if(r_grab && r_grab.grabbed == victim)
		if(grabstate == null || r_grab.grab_state > grabstate)
			grabstate = r_grab.grab_state
	if(l_grab && l_grab.grabbed == victim)
		if(grabstate == null || l_grab.grab_state > grabstate)
			grabstate = l_grab.grab_state
	return grabstate

/proc/add_cum_floor(turfu)
	if(!turfu || !isturf(turfu))
		return
	new /obj/effect/decal/cleanable/coom(turfu)
