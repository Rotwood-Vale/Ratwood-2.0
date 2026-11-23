
/// Lying down to pretend to be dead, rather than being killed and regenerating
#define TORPOR_PHASE_RESTING "resting"
/// Dead, and waiting for dormancy before regenerating
#define TORPOR_PHASE_DORMANT "dormant"
/// Head or brain is missing, and in the process of regrowing it
#define TORPOR_PHASE_REGROWING "regrowing"
/// Can't regrow head/brain due to being too low of a tier, fucked.
#define TORPOR_PHASE_AWAITING "awaiting"
/// Regenerating generally until you're healthy enough to revive
#define TORPOR_PHASE_MENDING "mending"

/datum/status_effect/vampire_torpor
	id = "vampire_torpor"
	duration = -1
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/vampire_torpor
	/// The vampire's torpor component, which holds their mind and generation and handles their final death
	var/datum/component/vampire_torpor/torpor_comp
	/// TORPOR_VOLUNTARY or TORPOR_DEATH
	var/mode
	/// How long this death torpor lies dormant before mending, set from the vampire's generation
	var/dormant_needed = 0
	/// How much progress you have made through the dormant phase, can't be a timer as being in a coffin will halve it
	var/dormant_progress = 0
	/// Time spent actually mending, controls the over-time healing scaling
	var/mending_time = 0
	/// Mending put into growing a new head so far, out of TORPOR_HEAD_REGROW_AMOUNT
	var/head_regrow_progress = 0
	/// Hair, beard and the like from the severed head, kept in case the head is destroyed before the new one grows
	var/list/lost_head_features
	/// Health after the last mending tick, to tell when something is hurting them faster than they fix themselves
	var/last_health
	/// What they were last told under each notify_on_change() key, to avoid spamming messages
	var/list/last_notices = list()

/datum/status_effect/vampire_torpor/on_creation(mob/living/new_owner, torpor_mode = TORPOR_VOLUNTARY, datum/component/vampire_torpor/comp)
	mode = torpor_mode
	torpor_comp = comp || new_owner?.GetComponent(/datum/component/vampire_torpor)
	return ..()

/datum/status_effect/vampire_torpor/on_apply()
	. = ..()
	if(!ishuman(owner) || !torpor_comp)
		return FALSE
	var/mob/living/carbon/human/vampire = owner
	ADD_TRAIT(vampire, TRAIT_TORPOR, id)
	ADD_TRAIT(vampire, TRAIT_DEATHCOMA, id)
	ADD_TRAIT(vampire, TRAIT_NODEATH, id)
	ADD_TRAIT(vampire, TRAIT_FAKEDEATH, id)
	RegisterSignal(vampire, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(vampire, COMSIG_LIVING_TRY_OPEN_EYES, PROC_REF(on_try_open_eyes))
	RegisterSignal(vampire, COMSIG_LIVING_REVIVE, PROC_REF(on_revive))
	RegisterSignal(vampire, COMSIG_LIVING_CAN_BE_STAKED, PROC_REF(on_stake_check))
	RegisterSignal(vampire, COMSIG_LIVING_STAKED, PROC_REF(on_staked))
	RegisterSignal(vampire, COMSIG_LIVING_GET_SUCCUMB_WARNINGS, PROC_REF(on_get_succumb_warnings))
	RegisterSignal(vampire, COMSIG_LIVING_SUCCUMBED, PROC_REF(on_succumbed))
	vampire.clan?.disable_covens(vampire)
	vampire.exit_frenzymod()
	if(mode == TORPOR_DEATH)
		apply_death_torpor()
	else
		to_chat(vampire, span_notice("I sink into the horrible slumber of deathless Torpor. To any eye I am a corpse, and I will mend what hurts me. I wake when I open my eyes."))
	vampire.update_stat()

/datum/status_effect/vampire_torpor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_TORPOR, id)
	REMOVE_TRAIT(owner, TRAIT_DEATHCOMA, id)
	REMOVE_TRAIT(owner, TRAIT_NODEATH, id)
	REMOVE_TRAIT(owner, TRAIT_FAKEDEATH, id)
	REMOVE_TRAIT(owner, TRAIT_DEATHS_DOOR, id)
	UnregisterSignal(owner, list(
		COMSIG_PARENT_EXAMINE,
		COMSIG_LIVING_TRY_OPEN_EYES,
		COMSIG_LIVING_REVIVE,
		COMSIG_LIVING_CAN_BE_STAKED,
		COMSIG_LIVING_STAKED,
		COMSIG_LIVING_GET_SUCCUMB_WARNINGS,
		COMSIG_LIVING_SUCCUMBED,
	))
	owner.update_stat()
	owner.update_damage_hud()
	return ..()

/datum/status_effect/vampire_torpor/proc/on_examine(mob/living/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!isobserver(user) && !user?.mind?.has_antag_datum(/datum/antagonist/vampire))
		return
	examine_list += get_examine_text()

/// The slain can only open their eyes once the Curse is done holding them under
/datum/status_effect/vampire_torpor/proc/on_try_open_eyes(mob/living/source)
	SIGNAL_HANDLER
	var/refusal = get_rise_refusal()
	if(!refusal)
		return
	to_chat(source, span_warning(refusal))
	return COMPONENT_BLOCK_OPEN_EYES

/datum/status_effect/vampire_torpor/proc/on_revive(mob/living/source, full_heal, admin_revive)
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/vampire_torpor/proc/on_stake_check(mob/living/source, mob/living/user, obj/item/stake)
	SIGNAL_HANDLER
	return COMPONENT_STAKE_VULNERABLE

/datum/status_effect/vampire_torpor/proc/on_staked(mob/living/source, mob/living/user, obj/item/stake)
	SIGNAL_HANDLER
	source.visible_message(span_danger("[source] lets out a final, wretched howl as [source.p_their()] body crumbles to ash!"))
	torpor_comp.notify(span_userdanger("THE STAKE! MY HEART! NO-"))
	INVOKE_ASYNC(torpor_comp, TYPE_PROC_REF(/datum/component/vampire_torpor, die_for_good), TRUE)
	return COMPONENT_STAKE_HANDLED

// A vampire succumbing just ashes you, end of the line kiddo
/datum/status_effect/vampire_torpor/proc/on_get_succumb_warnings(mob/living/source, list/warnings)
	SIGNAL_HANDLER
	warnings += "If I give up, I let go of the Curse for good: my body will crumble to ASH, and I will NEVER rise again."

/datum/status_effect/vampire_torpor/proc/on_succumbed(mob/living/source)
	SIGNAL_HANDLER
	torpor_comp.final_death = TRUE
	to_chat(source, span_userdanger("I let go of the Curse. There will be no waking from this."))

/datum/status_effect/vampire_torpor/proc/enter_death_torpor()
	if(mode == TORPOR_DEATH)
		return
	apply_death_torpor()

/datum/status_effect/vampire_torpor/proc/apply_death_torpor()
	mode = TORPOR_DEATH
	mending_time = 0
	dormant_progress = 0
	dormant_needed = max(GENERATION_METHUSELAH + 1 - torpor_comp.get_generation(), 1) * 1 MINUTES
	ADD_TRAIT(owner, TRAIT_DEATHS_DOOR, id)
	set_eyes_closed(TRUE)
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "deathgasp")
	torpor_comp.notify(span_userdanger("My body fails, but the Curse will not let me go. I sink into a death torpor..."))
	owner.update_stat()
	owner.update_damage_hud()
	update_alert()

/datum/status_effect/vampire_torpor/proc/notify_on_change(key, text, style = "warning")
	if(last_notices[key] == text)
		return
	last_notices[key] = text
	if(text)
		torpor_comp.notify("<span class='[style]'>[text]</span>")

/datum/status_effect/vampire_torpor/proc/get_phase()
	if(mode != TORPOR_DEATH)
		return TORPOR_PHASE_RESTING
	if(is_dormant())
		return TORPOR_PHASE_DORMANT
	if(is_missing_vitals())
		return can_regrow() ? TORPOR_PHASE_REGROWING : TORPOR_PHASE_AWAITING
	return TORPOR_PHASE_MENDING

/datum/status_effect/vampire_torpor/proc/is_dormant()
	return mode == TORPOR_DEATH && dormant_progress < dormant_needed

/// How long the dormant phaze lasts, sped up inside a coffin or grave
/datum/status_effect/vampire_torpor/proc/dormant_rate()
	return in_resting_place() ? TORPOR_RESTING_PLACE_MULT : 1

/datum/status_effect/vampire_torpor/proc/dormant_time_left()
	return max(dormant_needed - dormant_progress, 0) / dormant_rate()

/// Whether their blood is strong enough to grow back a head or brain, the weaker generations have to get their own back
/datum/status_effect/vampire_torpor/proc/can_regrow()
	return torpor_comp.get_generation() >= GENERATION_ANCILLAE

/// Whether the vampire's mind is in their body. Decapitation or cutting out the brain carries it off with the brain
/datum/status_effect/vampire_torpor/proc/is_mind_home()
	var/datum/mind/vampire_mind = torpor_comp.get_mind()
	return !vampire_mind || vampire_mind.current == owner

/// Missing something only regrowth or its return can fix
/datum/status_effect/vampire_torpor/proc/is_missing_vitals()
	return !owner.get_bodypart(BODY_ZONE_HEAD) || !owner.getorganslot(ORGAN_SLOT_BRAIN) || !is_mind_home()

/// "head" or "brain", whichever they've lost, for telling them about it
/datum/status_effect/vampire_torpor/proc/lost_vital_name()
	return owner.get_bodypart(BODY_ZONE_HEAD) ? "brain" : "head"

/// Holy fire stops flesh from mending, but only while it actually burns, same as for anyone else
/datum/status_effect/vampire_torpor/proc/is_sundered()
	return owner.is_burning_with(/datum/status_effect/fire_handler/fire_stacks/sunder) || owner.is_burning_with(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed)

/datum/status_effect/vampire_torpor/tick(wait, delta_time)
	var/mob/living/carbon/human/vampire = owner
	if(vampire.stat == DEAD)
		qdel(src)
		return

	// capped so catchup doesnt go insane
	delta_time = min(delta_time, 5 SECONDS)

	if(mode == TORPOR_VOLUNTARY)
		if(!vampire.eyesclosed)
			wake()
			return
		if(!is_mended())
			mend(delta_time)
		notify_on_change("restored", is_mended() ? "My body is whole again. I can open my eyes whenever I wish." : null, "notice")
		return

	if(vampire.get_bodypart(BODY_ZONE_HEAD))
		head_regrow_progress = 0
	if(!is_missing_vitals())
		notify_on_change("vitals", null)
	else if(!handle_missing_vitals())
		return

	if(is_dormant())
		if(!vampire.eyesclosed)
			try_rise_early()
		dormant_progress += delta_time * dormant_rate()
		if(!is_dormant())
			torpor_comp.notify(span_notice("The dormancy lifts. My body begins to mend itself."))
		update_alert()
		return

	var/mended = mend(delta_time)
	if(is_missing_vitals() && can_regrow())
		if(!vampire.get_bodypart(BODY_ZONE_HEAD))
			grow_head(mended)
		else if(mended > 0)
			regrow_vitals()
	update_blocker()
	update_alert()
	if(is_missing_vitals())
		return
	if(!vampire.eyesclosed)
		try_rise_early()
		return
	if(is_mended())
		wake()
		return
	notify_on_change("can_rise", can_rise() ? "I am whole enough to rise. I can open my eyes to rise now, or keep mending until I am fully restored." : null, "notice")

/// Puts this tick's mending into a new head, telling the vampire and anyone watching as it takes shape
/datum/status_effect/vampire_torpor/proc/grow_head(mended)
	if(mended <= 0)
		return
	var/mob/living/carbon/human/vampire = owner
	var/old_stage = get_head_regrow_stage()
	head_regrow_progress += mended
	if(head_regrow_progress >= TORPOR_HEAD_REGROW_AMOUNT)
		regrow_vitals()
		return
	var/new_stage = get_head_regrow_stage()
	if(new_stage == old_stage)
		return
	switch(new_stage)
		if(1)
			vampire.visible_message(span_danger("The stump of [vampire]'s neck writhes as raw flesh begins to bud from it!"))
			torpor_comp.notify(span_notice("Flesh begins to bud from the stump of my neck. A new head is forming."))
		if(2)
			vampire.visible_message(span_danger("Bone and sinew twist up from [vampire]'s neck into the shape of a skull!"))
			torpor_comp.notify(span_notice("Bone and sinew knit themselves into a skull. My new head is half grown."))
		if(3)
			vampire.visible_message(span_danger("A raw, unfinished face pushes its way out of the flesh atop [vampire]'s neck!"))
			torpor_comp.notify(span_notice("A face forms on my new skull. It is nearly whole."))

/datum/status_effect/vampire_torpor/proc/get_head_regrow_percent()
	return round(100 * head_regrow_progress / TORPOR_HEAD_REGROW_AMOUNT)

/// 0 before anything has grown, then 1-3 as the new head buds, takes the shape of a skull, and forms a face
/datum/status_effect/vampire_torpor/proc/get_head_regrow_stage()
	if(head_regrow_progress <= 0)
		return 0
	return clamp(ceil(get_head_regrow_percent() / (100 / 3)), 1, 3)

/datum/status_effect/vampire_torpor/proc/get_mind_vessel()
	var/datum/mind/vampire_mind = torpor_comp.get_mind()
	var/mob/living/brain/brainmob = vampire_mind?.current
	if(!istype(brainmob) || QDELETED(brainmob))
		return null
	var/obj/item/organ/brain/lost_brain = brainmob.loc
	if(!istype(lost_brain) || QDELETED(lost_brain))
		return null
	if(istype(lost_brain.loc, /obj/item/bodypart/head))
		return lost_brain.loc
	return lost_brain

/datum/status_effect/vampire_torpor/proc/handle_missing_vitals()
	var/lost = lost_vital_name()
	var/obj/item/bodypart/head/severed_head = get_mind_vessel()
	if(istype(severed_head))
		lost_head_features = severed_head.bodypart_features?.Copy()
	if(can_regrow())
		notify_on_change("vitals", "My [lost] has been taken! My body will grow it anew as it mends, and draw me back into it.", "userdanger")
		return TRUE
	if(torpor_comp.get_mind() && !get_mind_vessel())
		torpor_comp.notify(span_userdanger("My [lost] is destroyed... and with it, the last of the Curse. I am truly dead."))
		torpor_comp.die_for_good(ash = FALSE)
		return FALSE
	notify_on_change("vitals", "My [lost] has been taken! My blood is too thin to grow it anew - I will not rise unless it is returned to me.", "userdanger")
	return TRUE

/datum/status_effect/vampire_torpor/proc/regrow_vitals()
	var/mob/living/carbon/human/vampire = owner
	var/obj/item/old_vessel = get_mind_vessel()
	var/regrew_head = FALSE
	if(!vampire.get_bodypart(BODY_ZONE_HEAD))
		if(!vampire.regenerate_limb(BODY_ZONE_HEAD))
			return
		regrew_head = TRUE
		regrow_head_features(old_vessel)
	restore_organs(allow_brain = TRUE)
	if(!vampire.getorganslot(ORGAN_SLOT_BRAIN))
		return

	var/datum/mind/vampire_mind = torpor_comp.get_mind()
	if(vampire_mind && vampire_mind.current != vampire)
		vampire_mind.transfer_to(vampire)
		vampire_mind.grab_ghost()
	notify_on_change("vitals", null)
	head_regrow_progress = 0

	if(old_vessel && !QDELETED(old_vessel))
		var/turf/vessel_turf = get_turf(old_vessel)
		vessel_turf?.visible_message(span_danger("[old_vessel] withers and crumbles to ash!"))
		if(vessel_turf)
			new /obj/item/ash(vessel_turf)
		qdel(old_vessel)

	set_eyes_closed(TRUE)
	if(regrew_head)
		vampire.update_body()
		vampire.update_hair()
		vampire.visible_message(span_danger("The last of the flesh atop [vampire]'s neck knits closed into a whole new head!"))
		to_chat(vampire, span_notice("My new head is whole. I am back in my body, and I can feel it mending around me."))
	else
		vampire.visible_message(span_danger("Something wet and dark swells to fill the hollow of [vampire]'s skull..."))
		to_chat(vampire, span_notice("A new brain swells to fill my skull. I am back in my body, and I can feel it mending around me."))

/datum/status_effect/vampire_torpor/proc/regrow_head_features(obj/item/old_vessel)
	var/obj/item/bodypart/head/new_head = owner.get_bodypart(BODY_ZONE_HEAD)
	if(!new_head)
		return
	var/list/features = lost_head_features
	var/obj/item/bodypart/head/old_head = istype(old_vessel, /obj/item/bodypart/head) ? old_vessel : null
	if(old_head && length(old_head.bodypart_features))
		features = old_head.bodypart_features.Copy()
	for(var/datum/bodypart_feature/feature as anything in features)
		old_head?.remove_bodypart_feature(feature)
		new_head.add_bodypart_feature(feature)
	lost_head_features = null

/// Heal based on what level your bloodheal is at
/// for delta_time worth of mending. Returns how much mending was done, 0 if something stopped it
/datum/status_effect/vampire_torpor/proc/mend(delta_time)
	var/mob/living/carbon/human/vampire = owner
	if(in_sunlight() || is_sundered())
		return 0
	var/seconds = delta_time / (1 SECONDS)
	if(mode == TORPOR_VOLUNTARY)
		var/vitae_cost = TORPOR_VOLUNTARY_VITAE_COST * seconds
		if(vampire.get_bloodpool() < vitae_cost)
			return 0
		vampire.adjust_bloodpool(-vitae_cost)

	mending_time += delta_time
	var/datum/coven/bloodheal = vampire.get_coven(/datum/coven/bloodheal)
	// half a point of brute and burn a second per level of Bloodheal, climbing from 1x to 3x over 5 minutes of mending
	var/heal_amount = 0.5 * max(bloodheal?.level, 1) * seconds
	heal_amount *= 1 + 2 * min(mending_time / (5 MINUTES), 1)
	if(in_resting_place())
		heal_amount *= TORPOR_RESTING_PLACE_MULT

	vampire.heal_overall_damage(heal_amount, heal_amount, updating_health = FALSE)
	vampire.adjustOxyLoss(-heal_amount, FALSE)
	vampire.adjustToxLoss(-heal_amount, FALSE)
	vampire.adjustCloneLoss(-heal_amount, FALSE)
	for(var/obj/item/organ/organ as anything in vampire.internal_organs)
		organ.applyOrganDamage(-heal_amount)
	vampire.updatehealth()
	var/list/crippling_names = list()
	for(var/datum/wound/wound as anything in vampire.get_wounds())
		if(is_crippling(wound))
			crippling_names[wound] = wound.name
	vampire.heal_all_wounds(heal_amount * 4)
	var/list/remaining_wounds = vampire.get_wounds()
	for(var/datum/wound/wound as anything in crippling_names)
		if(QDELETED(wound) || !(wound in remaining_wounds))
			torpor_comp.notify(span_notice("My [crippling_names[wound]] knits itself closed."))
	restore_organs()
	expel_embedded()
	return heal_amount

/datum/status_effect/vampire_torpor/proc/expel_embedded()
	var/mob/living/carbon/human/vampire = owner
	for(var/obj/item/bodypart/bodypart as anything in vampire.bodyparts)
		for(var/obj/item/embedded as anything in bodypart.embedded_objects)
			if(bodypart.remove_embedded_object(embedded))
				vampire.visible_message(span_warning("[vampire]'s flesh writhes and forces [embedded] out of [vampire.p_their()] [bodypart.name]!"))

/datum/status_effect/vampire_torpor/proc/restore_organs(allow_brain = FALSE)
	var/mob/living/carbon/human/vampire = owner
	if(!vampire.get_bodypart(BODY_ZONE_HEAD))
		return
	var/list/missing = get_missing_organ_slots()
	if(!length(missing) || ((ORGAN_SLOT_BRAIN in missing) && !allow_brain))
		return
	vampire.dna.species.regenerate_organs(vampire, null, FALSE)
	var/obj/item/organ/eyes/eyes = vampire.getorganslot(ORGAN_SLOT_EYES)
	if(vampire.clan && !istype(eyes, /obj/item/organ/eyes/night_vision/vampire))
		vampire.clan.implant_vampire_eyes(vampire)

/datum/status_effect/vampire_torpor/proc/get_missing_organ_slots()
	var/mob/living/carbon/human/vampire = owner
	var/datum/species/species = vampire.dna?.species
	. = list()
	if(!species)
		return
	var/list/slots = list()
	for(var/slot in vampire.dna.organ_dna)
		slots |= slot
	for(var/slot in species.organs)
		if(species.is_organ_slot_allowed(vampire, slot))
			slots |= slot
	for(var/slot in slots)
		if(vampire.getorganslot(slot))
			continue
		var/datum/organ_dna/organ_dna = vampire.dna.organ_dna[slot]
		if(organ_dna ? organ_dna.can_create_organ() : species.organs[slot])
			. += slot

// some wounds are lethal
/datum/status_effect/vampire_torpor/proc/get_crippling_wound()
	for(var/datum/wound/wound as anything in owner.get_wounds())
		if(is_crippling(wound))
			return wound
	return null

/datum/status_effect/vampire_torpor/proc/is_crippling(datum/wound/wound)
	if(isnull(wound.whp) || wound.whp <= 0)
		return FALSE
	return wound.mortal || wound.critical || wound.disabling || wound.severity >= WOUND_SEVERITY_CRITICAL

/datum/status_effect/vampire_torpor/proc/get_blocker()
	var/mob/living/carbon/human/vampire = owner
	if(in_sunlight())
		return "The sun scorches me, and I cannot mend beneath it."
	if(is_sundered())
		return "Holy fire burns in my flesh, and my wounds will not close while it does."
	if(!isnull(last_health) && vampire.health < last_health)
		return "I am being harmed faster than I can mend."
	switch(get_phase())
		if(TORPOR_PHASE_REGROWING)
			return "My new [lost_vital_name()] is still forming."
		if(TORPOR_PHASE_AWAITING)
			return "My [lost_vital_name()] must be returned to me before I can rise."
	var/datum/wound/crippling = get_crippling_wound()
	if(crippling)
		return "My [crippling.name] must close before I can rise."
	return null

/datum/status_effect/vampire_torpor/proc/update_blocker()
	notify_on_change("blocker", get_blocker())
	last_health = owner.health

/datum/status_effect/vampire_torpor/proc/is_mended()
	var/mob/living/carbon/human/vampire = owner
	return can_rise() && vampire.health >= vampire.maxHealth && vampire.getBruteLoss() + vampire.getFireLoss() <= 0

/datum/status_effect/vampire_torpor/proc/can_rise()
	var/mob/living/carbon/human/vampire = owner
	if(is_missing_vitals() || get_crippling_wound())
		return FALSE
	return vampire.health > vampire.crit_threshold

/// Why the slain can't open their eyes yet, null if they can
/datum/status_effect/vampire_torpor/proc/get_rise_refusal()
	switch(get_phase())
		if(TORPOR_PHASE_RESTING)
			return null
		if(TORPOR_PHASE_DORMANT)
			return "My eyes will not open. The torpor holds me for [DisplayTimeText(dormant_time_left(), 1)] yet."
	if(!can_rise())
		return get_blocker() || "My body is still too broken to rise."
	return null

/datum/status_effect/vampire_torpor/proc/try_rise_early()
	var/refusal = get_rise_refusal()
	if(refusal)
		torpor_comp.notify(span_warning(refusal))
		set_eyes_closed(TRUE)
		return
	wake()

/datum/status_effect/vampire_torpor/proc/in_sunlight()
	if(GLOB.tod != "day")
		return FALSE
	var/turf/vampire_turf = owner.loc
	return isturf(vampire_turf) && vampire_turf.can_see_sky()

/// A coffin, a grave, or a coffin in a grave
/datum/status_effect/vampire_torpor/proc/in_resting_place()
	return istype(owner.loc, /obj/structure/closet/crate/coffin) || istype(owner.loc, /obj/structure/closet/dirthole)

/datum/status_effect/vampire_torpor/proc/wake()
	var/mob/living/carbon/human/vampire = owner
	if(mode == TORPOR_DEATH)
		set_eyes_closed(FALSE)
		vampire.visible_message(
			span_danger("[vampire]'s corpse suddenly jolts, and rises once more!"),
			span_userdanger("Death releases its grip upon me. I rise again!"),
		)
		playsound(vampire, 'sound/misc/vampirespell.ogg', 50, TRUE)
	else
		to_chat(vampire, span_warning("I have recovered from Torpor."))
		vampire.playsound_local(vampire, 'sound/misc/vampirespell.ogg', 50, TRUE)
	qdel(src)

/datum/status_effect/vampire_torpor/proc/set_eyes_closed(closed)
	owner.eyesclosed = closed
	if(closed)
		owner.become_blind("eyelids")
	else
		owner.cure_blind("eyelids")
	if(!owner.hud_used)
		return
	for(var/atom/movable/screen/eye_intent/eye_button in owner.hud_used.static_inventory)
		eye_button.update_icon(owner)

/datum/status_effect/vampire_torpor/proc/update_alert()
	if(!linked_alert)
		return
	var/phase = get_phase()
	var/countdown = 0
	switch(phase)
		if(TORPOR_PHASE_RESTING)
			linked_alert.name = initial(linked_alert.name)
			linked_alert.desc = initial(linked_alert.desc)
		if(TORPOR_PHASE_DORMANT)
			linked_alert.name = "Torpor (Dormant)"
			linked_alert.desc = "The Curse holds me under. My body will begin to mend once this passes[in_resting_place() ? ", sooner for resting in a proper place" : ""]."
			countdown = dormant_time_left()
		if(TORPOR_PHASE_REGROWING)
			linked_alert.name = "Torpor (Regrowing [capitalize(lost_vital_name())])"
			linked_alert.desc = owner.get_bodypart(BODY_ZONE_HEAD) ? "A new brain is forming within my skull." : "A new head is forming atop my neck: [get_head_regrow_percent()]% grown."
		if(TORPOR_PHASE_AWAITING)
			linked_alert.name = "Torpor (Awaiting [capitalize(lost_vital_name())])"
			linked_alert.desc = "My [lost_vital_name()] has been taken. My blood is too thin to grow it anew, and I cannot rise until it is returned to me."
		if(TORPOR_PHASE_MENDING)
			linked_alert.name = "Torpor (Mending)"
			linked_alert.desc = "My flesh knits itself back together. [can_rise() ? "I am whole enough to rise - I can open my eyes to do so now, or rest until I am fully restored." : "I will rise once fully restored."]"
	if(phase != TORPOR_PHASE_RESTING && phase != TORPOR_PHASE_DORMANT)
		var/blocker = last_notices["blocker"]
		linked_alert.desc += "[blocker ? "<br><br>[blocker]" : ""]<br><br>If I give up at death's door, I will crumble to ash."
	linked_alert.update_countdown(countdown)

/datum/status_effect/vampire_torpor/proc/get_examine_text()
	var/they = owner.p_they(TRUE)
	switch(get_phase())
		if(TORPOR_PHASE_RESTING)
			return span_artery("[they] [owner.p_are()] resting in torpor.")
		if(TORPOR_PHASE_DORMANT)
			return span_artery("[they] [owner.p_are()] in a <b>death torpor</b>, lying dormant. [they] will begin to mend in [DisplayTimeText(dormant_time_left(), 1)].")
		if(TORPOR_PHASE_REGROWING)
			if(owner.get_bodypart(BODY_ZONE_HEAD))
				return span_artery("[they] [owner.p_are()] in a <b>death torpor</b>, and a new brain is forming within [owner.p_their()] skull.")
			return span_artery("This headless body lies in a <b>death torpor</b>, and a new head is growing from its neck: [get_head_regrow_percent()]% formed.")
		if(TORPOR_PHASE_AWAITING)
			if(owner.get_bodypart(BODY_ZONE_HEAD))
				return span_artery("[they] [owner.p_are()] in a <b>death torpor</b>, [owner.p_their()] skull hollowed out, awaiting the return of [owner.p_their()] brain.")
			return span_artery("This headless body lies in a <b>death torpor</b>, awaiting the return of its head.")
	return span_artery("[they] [owner.p_are()] in a <b>death torpor</b>, and [owner.p_are()] mending.")

/atom/movable/screen/alert/status_effect/vampire_torpor
	name = "Torpor"
	desc = "The deathless slumber. To any eye I am a corpse, and my body mends itself while I rest. I wake when I open my eyes."
	icon_state = "debuff"

#undef TORPOR_PHASE_RESTING
#undef TORPOR_PHASE_DORMANT
#undef TORPOR_PHASE_REGROWING
#undef TORPOR_PHASE_AWAITING
#undef TORPOR_PHASE_MENDING
