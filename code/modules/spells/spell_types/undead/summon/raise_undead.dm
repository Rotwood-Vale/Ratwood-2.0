/obj/effect/proc_holder/spell/invoked/raise_undead
	name = "Raise Greater Undead"
	desc = "Raise a single greater skeleton that serves you. They are imbued with a fragment of a soul and is more intelligent than usual, simple-minded lesser undead.\n\
	Should the spell fails to find a suitable soul, a mindless undead will be summoned in its place with decrepit equipment.\n\
	This will only happen if you are in combat mode, to avoid any accident."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "skeleton"
	clothes_req = FALSE
	range = 7
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 60
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	gesture_required = TRUE // Summon spell
	associated_skill = /datum/skill/magic/arcane
	recharge_time = 60 SECONDS

/obj/effect/proc_holder/spell/invoked/raise_undead/cast(list/targets, mob/living/user)
	..()

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
	target.copy_known_languages_from(user, TRUE)
	target.visible_message(span_warning("[target]'s eyes light up with an eerie glow!"))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "FORTIFIED SKELETON"), 3 SECONDS)
	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	target.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/skeleton_lichseek)
	target.pronouns = IT_ITS
	return TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead/proc/backup_summon(turf/T)
	var/skeleton_roll = rand(1, 3)
	// 66% chance of medium 33% of heavy
	switch(skeleton_roll)
		if(1 to 2) // 66% chance
			new /mob/living/carbon/human/species/skeleton/npc/medium(T)
		if(3) // 33% chance
			new /mob/living/carbon/human/species/skeleton/npc/hard(T)
	return TRUE

// the special spell skeletons summoned with above gets. Lets them locate the nearest Lich.
/obj/effect/proc_holder/spell/invoked/skeleton_lichseek
	name = "Seek Master"
	desc = "Locate the nearest Lich."
	overlay_state = "ZIZO"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = list('modular_azurepeak/sound/mobs/abyssal/murderbeast.ogg')
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	miracle = FALSE
	devotion_cost = 0

/obj/effect/proc_holder/spell/invoked/skeleton_lichseek/cast(list/targets, mob/living/user)
	if(!istype(user, /mob/living/carbon/human/species/skeleton))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/species/skeleton/skeleton = user
	var/mob/living/closest_lich
	var/closest_dist = INFINITY

	for(var/datum/antagonist/A in GLOB.antagonists)
		if(!istype(A, /datum/antagonist/lich))
			continue

		var/datum/antagonist/lich/lich = A
		var/mob/living/lich_mob = lich.owner?.current
		if(!lich_mob || QDELETED(lich_mob))
			continue

		var/dist = get_dist(skeleton, lich_mob)
		if(dist < closest_dist)
			closest_dist = dist
			closest_lich = lich_mob

	if(!closest_lich)
		to_chat(skeleton, span_warning("You cannot sense your Master."))
		return FALSE

	to_chat(skeleton, span_warning("[closest_dist] meters away, [dir2text(get_dir(skeleton, closest_lich))]..."))
	return TRUE
