/datum/wound/artery
	name = "动脉断裂"
	check_name = span_artery("<B>动脉</B>")
	severity = WOUND_SEVERITY_CRITICAL
	crit_message = "鲜血从%VICTIM的%BODYPART喷涌而出！"
	sound_effect = 'sound/combat/crit.ogg'
	whp = 50
	sewn_whp = 20
	bleed_rate = ARTERY_LIMB_BLEEDRATE
	sewn_bleed_rate = 0.2
	clotting_threshold = null
	sewn_clotting_threshold = null
	woundpain = 50
	sewn_woundpain = 20
	mob_overlay = "s1"
	sewn_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE
	critical = TRUE
	sleep_healing = 0.5 //so breathless characters dont stuck near death forever
	embed_chance = 75

	werewolf_infection_probability = 100

/datum/wound/artery/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/artery) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/artery/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("paincrit", TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/artery/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	affected.temporary_crit_paralysis(10 SECONDS)

/datum/wound/artery/neck
	name = "颈动脉撕裂"
	check_name = span_artery("<B>颈动脉</B>")
	severity = WOUND_SEVERITY_FATAL
	crit_message = "鲜血从%VICTIM的喉咙喷涌而出！"
	whp = 100
	sewn_whp = 25
	bleed_rate = 50
	sewn_bleed_rate = 0.5
	woundpain = 60
	sewn_woundpain = 30
	mob_overlay = "s1_throat"
	mortal = TRUE

/datum/wound/artery/neck/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/artery/neck/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/artery/chest
	name = "主动脉夹层"
	check_name = span_artery("<B>主动脉</B>")
	severity = WOUND_SEVERITY_FATAL
	whp = 100
	sewn_whp = 35
	bleed_rate = 50
	sewn_bleed_rate = 0.8
	woundpain = 100
	sewn_woundpain = 50
	mortal = TRUE

/datum/wound/artery/chest/on_mob_gain(mob/living/affected)
	. = ..()
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.vomit(blood = TRUE)
	var/static/list/heartaches = list(
		"噢噢噢我的心脏！",
		"我的心脏！好痛！",
		"我要死了！",
		"我的心脏裂开了！",
		"我的心脏在流血！",
	)
	to_chat(affected, span_userdanger("[pick(heartaches)]"))

/datum/wound/artery/chest/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.stat && prob(5))
		carbon_owner.vomit(1, blood = TRUE, stun = TRUE)

/datum/wound/artery/reattachment
	name = "断肢再植"
	check_name = span_artery("<B>未缝合</B>")
	severity = WOUND_SEVERITY_FATAL
	whp = 100
	sewn_whp = 25
	bleed_rate = 50
	sewn_bleed_rate = 0.5
	woundpain = 60
	sewn_woundpain = 30
	disabling = TRUE
