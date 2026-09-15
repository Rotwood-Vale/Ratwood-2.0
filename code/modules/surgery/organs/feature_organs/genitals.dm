/obj/item/organ/penis
	name = "penis"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_PENIS
	organ_dna_type = /datum/organ_dna/penis
	accessory_type = /datum/sprite_accessory/penis/human
	var/sheath_type = SHEATH_TYPE_NONE
	var/erect_state = ERECT_STATE_NONE
	var/penis_type = PENIS_TYPE_PLAIN
	var/penis_size = DEFAULT_PENIS_SIZE
	var/functional = TRUE
	var/branded_writing = ""

/obj/item/organ/penis/Initialize(mapload)
	. = ..()

/obj/item/organ/penis/proc/update_erect_state()
	var/oldstate = erect_state
	var/new_state = ERECT_STATE_NONE

	if(owner)
		var/mob/living/carbon/human/human = owner
		if(!human?.sexcon.can_use_penis())
			new_state = ERECT_STATE_NONE
		else if(human.sexcon.arousal > 20 && human.sexcon.manual_arousal == 1 || human.sexcon.manual_arousal == 4)
			new_state = ERECT_STATE_HARD
		else if(human.sexcon.arousal > 10 && human.sexcon.manual_arousal == 1 || human.sexcon.manual_arousal == 3)
			new_state = ERECT_STATE_PARTIAL
		else
			new_state = ERECT_STATE_NONE

	erect_state = new_state
	if(oldstate != erect_state && owner)
		owner.update_body_parts(TRUE)

/obj/item/organ/penis/knotted
	name = "knotted penis"
	penis_type = PENIS_TYPE_KNOTTED
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/knotted/big
	penis_size = 3

/obj/item/organ/penis/equine
	name = "equine penis"
	penis_type = PENIS_TYPE_EQUINE
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/equine_knotted
	name = "equine knotted penis"
	penis_type = PENIS_TYPE_EQUINE_KNOTTED
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/equine_slit
	name = "equine penis"
	penis_type = PENIS_TYPE_EQUINE
	sheath_type = SHEATH_TYPE_SLIT

/obj/item/organ/penis/equine_knotted_slit
	name = "equine knotted penis"
	penis_type = PENIS_TYPE_EQUINE_KNOTTED
	sheath_type = SHEATH_TYPE_SLIT

/obj/item/organ/penis/tapered_mammal
	name = "tapered penis"
	penis_type = PENIS_TYPE_TAPERED
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/tapered
	name = "tapered penis"
	penis_type = PENIS_TYPE_TAPERED
	sheath_type = SHEATH_TYPE_SLIT

/obj/item/organ/penis/tapered_knotted
	name = "tapered knotted penis"
	penis_type = PENIS_TYPE_TAPERED_KNOTTED
	sheath_type = SHEATH_TYPE_SLIT

/obj/item/organ/penis/tapered_knotted_mammal
	name = "tapered knotted penis"
	penis_type = PENIS_TYPE_TAPERED_KNOTTED
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/tapered_double
	name = "hemi tapered penis"
	penis_type = PENIS_TYPE_TAPERED_DOUBLE
	sheath_type = SHEATH_TYPE_SLIT

/obj/item/organ/penis/tapered_double_mammal
	name = "hemi tapered penis"
	penis_type = PENIS_TYPE_TAPERED_DOUBLE
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/tapered_double_knotted
	name = "hemi knotted tapered penis"
	penis_type = PENIS_TYPE_TAPERED_DOUBLE_KNOTTED
	sheath_type = SHEATH_TYPE_SLIT

/obj/item/organ/penis/tapered_double_knotted_mammal
	name = "hemi knotted tapered penis (sheath)"
	penis_type = PENIS_TYPE_TAPERED_DOUBLE_KNOTTED
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/barbed
	name = "barbed penis"
	penis_type = PENIS_TYPE_BARBED
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/barbed_knotted
	name = "barbed knotted penis"
	penis_type = PENIS_TYPE_BARBED_KNOTTED
	sheath_type = SHEATH_TYPE_NORMAL

/obj/item/organ/penis/tentacle
	name = "tentacle penis"
	penis_type = PENIS_TYPE_TENTACLE
	sheath_type = SHEATH_TYPE_NONE

	
/obj/item/organ/vagina
	name = "vagina"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_VAGINA
	accessory_type = /datum/sprite_accessory/vagina/human
	var/pregnant = FALSE
	var/fertility = TRUE
	var/impregnation_probability = IMPREG_PROB_DEFAULT
	var/branded_writing = ""

/obj/item/organ/vagina/proc/be_impregnated(mob/living/carbon/human/father)
	if(!owner)
		return FALSE
	if(owner.stat == DEAD)
		return FALSE
	if(pregnant)
		to_chat(owner, span_love("I feel a surge of warmth in my belly again..."))
		return FALSE
	to_chat(owner, span_love("I feel a surge of warmth in my belly, I'm definitely pregnant!"))
	pregnant = TRUE
	//TODO add a way to trigger lactating when pregnancy happens
	return TRUE

/obj/item/organ/breasts
	name = "breasts"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BREASTS
	organ_dna_type = /datum/organ_dna/breasts
	accessory_type = /datum/sprite_accessory/breasts/pair
	var/breast_size = DEFAULT_BREASTS_SIZE
	var/lactating = FALSE
	var/milk_stored = 0
	var/milk_max = 75
	var/branded_writing = ""
	var/can_jiggle = TRUE
	var/is_jiggling = FALSE
	var/jiggle_endless = FALSE
	var/jiggle_costs_stamina = FALSE
	var/jiggle_cycles_left = 0
	var/jiggle_timerid
	var/static/list/jiggle_interrupt_signals = list(
		COMSIG_MOB_ITEM_ATTACK,
		COMSIG_MOB_ITEM_BEING_ATTACKED,
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_MOB_ATTACKED_BY_HAND,
		COMSIG_MOB_APPLY_DAMGE,
	)

/obj/item/organ/breasts/New()
	..()
	milk_max = max(75, breast_size * 100)

/obj/item/organ/breasts/Destroy()
	stop_jiggle()
	return ..()

/obj/item/organ/breasts/get_icon_cache_key(obj/item/bodypart/bodypart)
	return "[..()]-[breast_size]-[is_jiggling]"

/obj/item/organ/breasts/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	stop_jiggle()
	return ..()

/obj/item/organ/breasts/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	stop_jiggle()
	return ..()

/obj/item/organ/breasts/proc/start_jiggle(duration, endless = FALSE, costs_stamina = FALSE)
	if(is_jiggling || !ishuman(owner))
		return FALSE
	is_jiggling = TRUE
	jiggle_endless = endless
	jiggle_costs_stamina = costs_stamina
	jiggle_cycles_left = endless ? 0 : max(1, round(duration / BREAST_JIGGLE_CYCLE, 1))
	var/mob/living/carbon/human/H = owner
	RegisterSignal(H, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_MOB_ATTACK_HAND), PROC_REF(on_jiggle_attacking))
	RegisterSignal(H, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(on_jiggle_attacked_with_item))
	RegisterSignal(H, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(on_jiggle_attacked_by_hand))
	RegisterSignal(H, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_jiggle_damaged))
	H.update_body_parts(TRUE)
	jiggle_cycle()
	return TRUE

/obj/item/organ/breasts/proc/jiggle_cycle()
	jiggle_timerid = null
	if(!is_jiggling)
		return
	var/mob/living/carbon/human/H = owner
	if(QDELETED(H) || !ishuman(H) || H.stat != CONSCIOUS || H.cmode || H.doing || !(H.mobility_flags & MOBILITY_STAND))
		stop_jiggle()
		return
	if(jiggle_costs_stamina && !H.jiggle_stamina_is_free())
		var/cycle_cost = BREAST_JIGGLE_STAMINA_PER_SECOND * (BREAST_JIGGLE_CYCLE / (1 SECONDS))
		if(jiggle_endless)
			cycle_cost *= BREAST_JIGGLE_ENDLESS_STAMINA_MULT
		if(!H.stamina_add(cycle_cost))
			stop_jiggle()
			return
	H.do_jiggle_hop()
	if(!jiggle_endless)
		jiggle_cycles_left--
		if(jiggle_cycles_left <= 0)
			stop_jiggle()
			return
	jiggle_timerid = addtimer(CALLBACK(src, PROC_REF(jiggle_cycle)), BREAST_JIGGLE_CYCLE, TIMER_STOPPABLE)

/obj/item/organ/breasts/proc/stop_jiggle()
	if(jiggle_timerid)
		deltimer(jiggle_timerid)
		jiggle_timerid = null
	if(!is_jiggling)
		return
	is_jiggling = FALSE
	jiggle_endless = FALSE
	jiggle_costs_stamina = FALSE
	jiggle_cycles_left = 0
	var/mob/living/carbon/human/H = owner
	if(QDELETED(H) || !ishuman(H))
		return
	UnregisterSignal(H, jiggle_interrupt_signals)
	H.update_body_parts(TRUE)

/obj/item/organ/breasts/proc/interrupt_jiggle(mob/living/attacker)
	if(attacker?.used_intent?.type == INTENT_HELP)
		return
	stop_jiggle()

/obj/item/organ/breasts/proc/on_jiggle_attacking(datum/source)
	SIGNAL_HANDLER
	interrupt_jiggle(owner)

/obj/item/organ/breasts/proc/on_jiggle_attacked_with_item(datum/source, mob/living/victim, mob/living/attacker)
	SIGNAL_HANDLER
	interrupt_jiggle(attacker)

/obj/item/organ/breasts/proc/on_jiggle_attacked_by_hand(datum/source, mob/living/attacker, mob/living/victim)
	SIGNAL_HANDLER
	interrupt_jiggle(attacker)

/obj/item/organ/breasts/proc/on_jiggle_damaged(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damage <= 0)
		return
	stop_jiggle()

/obj/item/organ/testicles
	name = "testicles"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TESTICLES
	organ_dna_type = /datum/organ_dna/testicles
	accessory_type = /datum/sprite_accessory/testicles/pair
	var/ball_size = DEFAULT_TESTICLES_SIZE
	var/virility = TRUE
	var/branded_writing = ""

/obj/item/organ/testicles/internal
	name = "internal testicles"
	visible_organ = FALSE
	accessory_type = /datum/sprite_accessory/none
