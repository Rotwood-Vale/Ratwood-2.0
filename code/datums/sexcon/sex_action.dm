/datum/sex_action
	abstract_type = /datum/sex_action
	var/name = "Zodomize"
	/// Time to do the act, modified by up to 2.5x speed by the speed toggle
	var/do_time = 3.3 SECONDS
	/// Whether the act is continous and will be done on repeat
	var/continous = TRUE
	/// Stamina cost per action, modified by up to 2.5x cost by the force toggle
	var/stamina_cost = 0.5
	/// Whether the action requires both participants to be on the same tile
	var/check_same_tile = TRUE
	/// Whether the same tile check can be bypassed by an aggro grab on the person
	var/aggro_grab_instead_same_tile = TRUE
	/// If TRUE, skips adjacency and instead requires direct line of sight within ranged_los_distance tiles
	var/ranged_los_action = FALSE
	var/ranged_los_distance = 7
	/// Whether the action is forbidden from being done while incapacitated (stun, handcuffed)
	var/check_incapacitated = TRUE
	/// Whether the action requires an aggressive grab on the victim
	var/require_grab = FALSE
	/// If a grab is required, this is the required state of it
	var/required_grab_state = GRAB_AGGRESSIVE
	/// Set the menu category for the action
	var/category = SEX_CATEGORY_MISC
	/// Set which part/oriface the user will be using
	var/user_sex_part = SEX_PART_NULL
	/// Set which part/oriface the target will be using
	var/target_sex_part = SEX_PART_NULL
	/// Only allow select actions to be done subtly
	var/subtle_supported = FALSE
	/// Only allow select actions to end with a knot-tie
	var/knot_on_finish = FALSE
	/// Requires can_use_penis() to be TRUE for the user in standard sex part checks.
	var/user_needs_functional = FALSE
	/// Requires chastity on user_sex_part, if supported by the affected part.
	var/user_needs_chastity = FALSE
	/// Requires chastity on target_sex_part, if supported by the affected part.
	var/target_needs_chastity = FALSE
	/// Requires can_use_penis() or can_use_vagina() to be TRUE for the target in standard sex part checks.
	/// This is mostly used for either active penetration OR for things that can't be done through chastity.
	var/target_needs_functional = FALSE
	/// If solo is TRUE, user must equal target.
	var/solo = FALSE

/datum/sex_action/proc/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(solo)
		if(user != target)
			return FALSE
	else if(user == target)
		return FALSE
	return has_accessible_needed_parts(user, target)

/datum/sex_action/proc/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return

/datum/sex_action/proc/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return

/datum/sex_action/proc/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return

/datum/sex_action/proc/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return FALSE

/datum/sex_action/proc/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(solo)
		if(user != target)
			return FALSE
	else if(user == target)
		return FALSE
	if(!has_all_needed_parts(user, null, user_sex_part, user_needs_chastity))
		return FALSE
	if(!has_all_needed_parts(target, user, target_sex_part, target_needs_chastity))
		return FALSE
	return TRUE

/datum/sex_action/proc/has_all_needed_parts(mob/living/carbon/human/actor, mob/living/carbon/human/user, parts_to_check = null, needs_chastity = FALSE)
	if(parts_to_check == SEX_PART_NULL) // & doesn't work here because it's 0
		return TRUE // no further checks
	// Needs ALL parts, not just one.
	// Because of that, this only checks ones that can fail
	// and only ever returns TRUE at the end.
	var/self = actor == user
	if(parts_to_check & SEX_PART_ANUS)
		if(self && !is_part_self_accessible(actor, SEX_PART_ANUS))
			return FALSE
		if(needs_chastity != !!actor.sexcon.has_chastity_anal())
			return FALSE
	if(parts_to_check & SEX_PART_GROIN)
		if(self && !is_part_self_accessible(actor, SEX_PART_GROIN))
			return FALSE
		// cage checks for either part
		if(needs_chastity != !!actor.sexcon.has_chastity_cage())
			return FALSE
	if(parts_to_check & SEX_PART_FEET) // but maybe this should have a limb check?
		if(self && !is_part_self_accessible(actor, SEX_PART_FEET))
			return FALSE
	if(parts_to_check & SEX_PART_FOOT) // this was added JUST to support single-foot foot licking actions. ugh
		if(self && !is_part_self_accessible(actor, SEX_PART_FOOT))
			return FALSE
	if((parts_to_check & SEX_PART_BREASTS) && !actor.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(parts_to_check & SEX_PART_JAWS)
		if(self && !is_part_self_accessible(actor, SEX_PART_JAWS))
			return FALSE
	if((parts_to_check & SEX_PART_CUNT))
		if(!actor.getorganslot(ORGAN_SLOT_VAGINA))
			return FALSE
		if(needs_chastity != !!actor.sexcon.has_chastity_vagina())
			return FALSE
	if((parts_to_check & SEX_PART_BALLS) && !actor.getorganslot(ORGAN_SLOT_TESTICLES))
		return FALSE
	var/obj/item/organ/penis/penis = actor.getorganslot(ORGAN_SLOT_PENIS)
	if((parts_to_check & SEX_PART_SLIT_SHEATH) && penis?.sheath_type != SHEATH_TYPE_SLIT)
		if(needs_chastity != !!actor.sexcon.has_chastity_penis())
			return FALSE
		return FALSE
	if((parts_to_check & SEX_PART_COCK) && !penis)
		if(needs_chastity != !!actor.sexcon.has_chastity_penis())
			return FALSE
		return FALSE
	if((parts_to_check & SEX_PART_TAIL) && !actor.getorganslot(ORGAN_SLOT_TAIL) && !islamia(actor))
		return FALSE
	return TRUE

// this proc is fail-open, e.g. it returns TRUE by default and all checks are early false returns
// (except for the null check at the start, i guess)
/datum/sex_action/proc/actor_parts_are_usable(mob/living/carbon/human/actor, mob/living/carbon/human/user, parts_to_check, needs_functional, needs_chastity)
	var/mob/living/carbon/human/accessor = user || actor // check this for access, but not self-restrictions
	if(parts_to_check == SEX_PART_NULL) // & doesn't work here because it's 0
		return TRUE // no further checks
	var/needs_groin_check = FALSE
	if((parts_to_check & SEX_PART_ANUS))
		if(needs_chastity != !!actor.sexcon.has_chastity_anal())
			return FALSE
		if(user == actor && !is_part_self_accessible(user, SEX_PART_ANUS))
			return FALSE
		needs_groin_check = TRUE
	if((parts_to_check & SEX_PART_GROIN))
		if(user == actor && !is_part_self_accessible(user, SEX_PART_GROIN))
			return FALSE
		// cage checks for either part
		if(needs_chastity != !!actor.sexcon.has_chastity_cage())
			return FALSE
		// doesn't allow grabs to give access
		if(!check_location_accessible(accessor, actor, BODY_ZONE_PRECISE_GROIN))
			return FALSE
	if((parts_to_check & SEX_PART_CUNT) && actor.getorganslot(ORGAN_SLOT_VAGINA))
		if(user == actor && !is_part_self_accessible(user, SEX_PART_CUNT))
			return FALSE
		if((needs_functional && !actor.sexcon.can_use_vagina()) || (needs_chastity != !!actor.sexcon.has_chastity_vagina()))
			return FALSE
		needs_groin_check = TRUE
	if((parts_to_check & SEX_PART_TAIL))
		if(!actor.getorganslot(ORGAN_SLOT_TAIL) && !islamia(actor))
			return FALSE
		needs_groin_check = TRUE
	var/obj/item/organ/penis/penis = actor.getorganslot(ORGAN_SLOT_PENIS)
	if(penis)
		if(parts_to_check & SEX_PART_COCK)
			if(user == actor && !is_part_self_accessible(user, SEX_PART_COCK))
				return FALSE
			// I hate chastity code so much
			// Todo combine *needs_functional and *needs_chastity into one bitflag
			if((needs_functional && !actor.sexcon.can_use_penis()) || (needs_chastity != !!actor.sexcon.has_chastity_penis()))
				return FALSE
			needs_groin_check = TRUE
		if((parts_to_check & SEX_PART_SLIT_SHEATH))
			if(user == actor && !is_part_self_accessible(user, SEX_PART_SLIT_SHEATH))
				return FALSE
			if(penis?.sheath_type != SHEATH_TYPE_SLIT)
				return FALSE
			needs_groin_check = TRUE
	if((parts_to_check & SEX_PART_BALLS) && actor.getorganslot(ORGAN_SLOT_TESTICLES))
		if(user == actor && !is_part_self_accessible(user, SEX_PART_BALLS))
			return FALSE
		needs_groin_check = TRUE
	if(needs_groin_check && !check_location_accessible(accessor, actor, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if((parts_to_check & SEX_PART_JAWS))
		if(!check_location_accessible(accessor, actor, BODY_ZONE_PRECISE_MOUTH))
			return FALSE
		// dullahan/etc check
		if(user == actor && !is_part_self_accessible(user, SEX_PART_JAWS))
			return FALSE
	if((parts_to_check & SEX_PART_FEET))
		// todo: do we need taur snowflake checks here?
		if(!check_location_accessible(accessor, actor, BODY_ZONE_PRECISE_L_FOOT) || !check_location_accessible(accessor, actor, BODY_ZONE_PRECISE_R_FOOT))
			return FALSE
		// i have no clue who'd make it so a species can do self-footjobs, but there's support for it i guess
		if(user == actor && !is_part_self_accessible(user, SEX_PART_FEET))
			return FALSE
	if(parts_to_check & SEX_PART_FOOT) // this was added JUST to support single-foot foot licking actions. ugh
		if(!check_location_accessible(accessor, actor, BODY_ZONE_PRECISE_L_FOOT) && !check_location_accessible(accessor, actor, BODY_ZONE_PRECISE_R_FOOT))
			return FALSE
		if(user == actor && !is_part_self_accessible(user, SEX_PART_FOOT))
			return FALSE
	var/needs_chest_check = parts_to_check & SEX_PART_CHEST
	if(parts_to_check & SEX_PART_BREASTS)
		if(!actor.getorganslot(ORGAN_SLOT_BREASTS))
			return FALSE
		if(user == actor && !is_part_self_accessible(user, SEX_PART_BREASTS))
			return FALSE
		needs_chest_check = TRUE
	if(parts_to_check & SEX_PART_CHEST)
		if(user == actor && !is_part_self_accessible(user, SEX_PART_CHEST))
			return FALSE
		needs_chest_check = TRUE
	if(needs_chest_check && !check_location_accessible(accessor, actor, BODY_ZONE_CHEST))
		return FALSE
	return TRUE

/datum/sex_action/proc/target_parts_are_accessible(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return actor_parts_are_usable(target, user, target_sex_part, target_needs_functional, target_needs_chastity)

/datum/sex_action/proc/user_parts_are_accessible(mob/living/carbon/human/user, mob/living/carbon/human/target)
	// no second argument -> no user -> don't restrict self-actions
	return actor_parts_are_usable(user, null, user_sex_part, user_needs_functional, user_needs_chastity)

/datum/sex_action/proc/has_accessible_needed_parts(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user_parts_are_accessible(user, target) && target_parts_are_accessible(user, target)

/// A helper to handle dullahans targeting their own heads without code duplication.
/// Generalised to handle any parts; the only ones we can use on ourselves are jaws for dullahans.
/datum/sex_action/proc/is_part_self_accessible(mob/living/carbon/human/actor, parts_to_check = null)
	// edit this to add exceptions for things like self-footjobs, self-foot-licking, etc for certain species
	// also maybe we need a way to disable these checks per-action
	if(parts_to_check & SEX_PART_JAWS)
		var/datum/species/dullahan/dullahan = actor.dna.species
		if(!istype(dullahan))
			return FALSE
		if(dullahan.headless && actor.is_holding(dullahan.my_head))
			return TRUE
	return FALSE

// chastity play abstract action, contains shared code for actions that interact with chastity devices
/datum/sex_action/chastityplay 
	abstract_type = /datum/sex_action/chastityplay

/datum/sex_action/chastityplay/proc/get_chastity_device_name(mob/living/carbon/human/owner)
	if(owner?.sexcon?.has_chastity_flat())
		return "flat cage"
	if(owner?.sexcon?.has_chastity_cage())
		return "cage"
	return "chastity device"

// Unified sound helper: supports single sound or list input with optional chance gating.
/datum/sex_action/chastityplay/proc/play_chastity_impact_sound(mob/living/carbon/human/target, sound_to_play, volume = 40, chance = 100, vary = TRUE, frequency = -1)
	if(!target || !sound_to_play)
		return FALSE
	if(chance < 100 && !prob(chance))
		return FALSE
	if(islist(sound_to_play))
		if(!length(sound_to_play))
			return FALSE
		playsound(get_turf(target), pick(sound_to_play), volume, vary, frequency)
		return TRUE
	playsound(get_turf(target), sound_to_play, volume, vary, frequency)
	return TRUE
