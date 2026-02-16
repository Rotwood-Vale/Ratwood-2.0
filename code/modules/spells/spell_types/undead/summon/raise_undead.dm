/obj/effect/proc_holder/spell/invoked/raise_undead
	name = "Raise Greater Undead"
	desc = "Raise a single greater skeleton that serves you. They are imbued with a fragment of a soul and is more intelligent than usual, simple-minded lesser undead.\n\
	Should the spell fails to find a suitable soul, a mindless undead will be summoned in its place with decrepit equipment.\n\
	This will only happen if you are in combat mode, to avoid any accident."
	clothes_req = FALSE
	range = 1
	overlay_state = "animate"
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 60
	warnie = "spellwarning"
	glow_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	no_early_release = TRUE
	movement_interrupt = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	gesture_required = TRUE // Summon spell
	associated_skill = /datum/skill/magic/arcane
	recharge_time = 60 SECONDS

/obj/effect/proc_holder/spell/invoked/raise_undead/cast(list/targets, mob/living/user)
	..()

	// Check if lich has reached their greater skeleton cap
	if(user.mind)
		var/datum/antagonist/lich/lich_datum = user.mind.has_antag_datum(/datum/antagonist/lich)
		if(lich_datum)
			if(lich_datum.greater_skeleton_count >= lich_datum.greater_skeleton_cap)
				to_chat(user, span_warning("You cannot summon more greater skeletons at this time. ([lich_datum.greater_skeleton_count]/[lich_datum.greater_skeleton_cap])"))
				revert_cast()
				return FALSE

	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		revert_cast()
		return FALSE

	var/list/candidates = pollGhostCandidates("Do you want to play as a Lich's skeleton?", ROLE_LICH_SKELETON, null, null, 10 SECONDS, POLL_IGNORE_LICH_SKELETON)
	if(!LAZYLEN(candidates))
		var/message = "The depths are hollow."
		if(user.cmode)
			message += " A decrepit skeleton rises instead."
			backup_summon(T)
		to_chat(user, span_warning(message))
		return TRUE

	var/mob/C = pick(candidates)
	if(!C || !istype(C, /mob/dead))
		revert_cast()
		return FALSE

	if (istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	var/mob/living/carbon/human/species/skeleton/no_equipment/target = new /mob/living/carbon/human/species/skeleton/no_equipment(T)
	target.key = C.key
	SSjob.EquipRank(target, "Fortified Skeleton", TRUE)
	ADD_TRAIT(target, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	target.copy_known_languages_from(user, TRUE)
	target.visible_message(span_warning("[target]'s eyes light up with an eerie glow!"))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "FORTIFIED SKELETON"), 3 SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	
	// Track the greater skeleton
	if(user.mind)
		var/datum/antagonist/lich/lich_datum = user.mind.has_antag_datum(/datum/antagonist/lich)
		if(lich_datum)
			lich_datum.greater_skeleton_count++
			lich_datum.greater_skeletons += target
			RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(on_skeleton_death), lich_datum)
			to_chat(user, span_notice("Greater skeletons: [lich_datum.greater_skeleton_count]/[lich_datum.greater_skeleton_cap]"))
	
	return TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead/proc/backup_summon(var/turf/T)
	var/skeleton_roll = rand(1, 3)
	// 66% chance of medium 33% of heavy
	switch(skeleton_roll)
		if(1 to 2) // 66% chance
			new /mob/living/carbon/human/species/skeleton/npc/medium(T)
		if(3) // 33% chance
			new /mob/living/carbon/human/species/skeleton/npc/hard(T)
	return TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead/proc/on_skeleton_death(mob/living/skeleton, datum/antagonist/lich/lich_datum)
	SIGNAL_HANDLER
	if(lich_datum)
		lich_datum.greater_skeleton_count = max(0, lich_datum.greater_skeleton_count - 1)
		lich_datum.greater_skeletons -= skeleton
		if(lich_datum.owner?.current)
			to_chat(lich_datum.owner.current, span_warning("One of your greater skeletons has been destroyed. ([lich_datum.greater_skeleton_count]/[lich_datum.greater_skeleton_cap])"))
