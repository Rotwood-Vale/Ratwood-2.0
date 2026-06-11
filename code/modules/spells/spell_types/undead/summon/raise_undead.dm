/obj/effect/proc_holder/spell/invoked/raise_undead
	name = "唤起高阶亡灵"
	desc = "唤起一具为你效命的高阶骷髅。它被注入了一缕灵魂残片，比寻常头脑简单的低阶亡灵更具智慧。\n\
	若法术找不到合适的灵魂，就会转而召出一具装备破旧、毫无心智的亡灵替代。\n\
	为避免意外，这种情况只会在你处于战斗模式时发生。"
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
		to_chat(user, span_warning("目标地点被阻挡了。我的召唤无法显现。"))
		revert_cast()
		return FALSE

	var/list/candidates = pollGhostCandidates("Do you want to play as a Lich's skeleton?", ROLE_LICH_SKELETON, null, null, 10 SECONDS, POLL_IGNORE_LICH_SKELETON)
	if(!LAZYLEN(candidates))
		var/message = "深渊空无一物。"
		if(user.cmode)
			message += " 取而代之爬起的是一具破败骷髅。"
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
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
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
