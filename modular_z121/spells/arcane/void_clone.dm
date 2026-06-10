#define VOID_CLONE_TRAIT_SOURCE "void_clone_custom"
#define VOID_CLONE_CHECK_INTERVAL (1 SECONDS)

/mob/living/carbon/human
	var/datum/void_clone_link/void_clone_link_custom

/datum/void_clone_link
	var/mob/living/carbon/human/original_body
	var/mob/living/carbon/human/clone_body
	var/cleanup_started = FALSE
	var/next_check = 0

/datum/void_clone_link/New(mob/living/carbon/human/original, mob/living/carbon/human/clone)
	. = ..()
	original_body = original
	clone_body = clone
	if(original_body)
		original_body.void_clone_link_custom = src
	if(clone_body)
		clone_body.void_clone_link_custom = src
	ensure_switch_spell()
	sync_current_body_spell_access()
	START_PROCESSING(SSfastprocess, src)

/datum/void_clone_link/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	if(original_body?.void_clone_link_custom == src)
		original_body.void_clone_link_custom = null
	if(clone_body?.void_clone_link_custom == src)
		clone_body.void_clone_link_custom = null
	original_body = null
	clone_body = null
	return ..()

/datum/void_clone_link/process()
	if(cleanup_started)
		return
	if(world.time < next_check)
		return
	next_check = world.time + VOID_CLONE_CHECK_INTERVAL

	if(QDELETED(clone_body) || !clone_body)
		cleanup_clone(FALSE)
		return

	if((clone_body.stat == DEAD) || (clone_body.health <= HEALTH_THRESHOLD_DEAD) || should_force_collapse())
		cleanup_clone(TRUE)
		return

	sync_current_body_spell_access()

/datum/void_clone_link/proc/should_force_collapse()
	if(!clone_body || QDELETED(clone_body))
		return FALSE
	if(clone_body.InCritical())
		return TRUE

	var/total_damage = clone_body.getBruteLoss() + clone_body.getFireLoss() + clone_body.getToxLoss() + clone_body.getOxyLoss() + clone_body.getCloneLoss()
	if(total_damage >= clone_body.maxHealth)
		return TRUE
	return FALSE

/datum/void_clone_link/proc/get_linked_mind()
	if(clone_body?.mind)
		return clone_body.mind
	if(original_body?.mind)
		return original_body.mind
	return null

/datum/void_clone_link/proc/ensure_switch_spell()
	var/datum/mind/M = get_linked_mind()
	if(!M || M.has_spell(/obj/effect/proc_holder/spell/self/void_clone_switch, TRUE))
		return
	M.AddSpell(new /obj/effect/proc_holder/spell/self/void_clone_switch)

/datum/void_clone_link/proc/remove_switch_spell()
	var/datum/mind/M = get_linked_mind()
	if(!M)
		return
	var/obj/effect/proc_holder/spell/switch_spell = M.get_spell(/obj/effect/proc_holder/spell/self/void_clone_switch, TRUE)
	if(switch_spell)
		M.RemoveSpell(switch_spell)

/datum/void_clone_link/proc/sync_current_body_spell_access()
	var/datum/mind/M = get_linked_mind()
	if(!M || !M.current)
		return

	var/mob/living/current_body = M.current
	var/obj/effect/proc_holder/spell/clone_spell = M.get_spell(/obj/effect/proc_holder/spell/self/void_clone, TRUE)
	if(clone_spell?.action)
		if(current_body == clone_body)
			if(clone_spell.action.owner == current_body)
				clone_spell.action.Remove(current_body)
		else if(clone_spell.action.owner != current_body)
			clone_spell.action.Grant(current_body)

	var/obj/effect/proc_holder/spell/learn_spell = M.get_spell(/obj/effect/proc_holder/spell/self/learnspell)
	if(learn_spell?.action)
		if(current_body == clone_body)
			if(learn_spell.action.owner == current_body)
				learn_spell.action.Remove(current_body)
		else if(learn_spell.action.owner != current_body)
			learn_spell.action.Grant(current_body)

	var/obj/effect/proc_holder/spell/switch_spell = M.get_spell(/obj/effect/proc_holder/spell/self/void_clone_switch, TRUE)
	if(switch_spell?.action && switch_spell.action.owner != current_body)
		switch_spell.action.Grant(current_body)

/datum/void_clone_link/proc/cleanup_clone(force_return)
	if(cleanup_started)
		return
	cleanup_started = TRUE

	var/datum/mind/M = get_linked_mind()
	var/mob/living/carbon/human/old_clone = clone_body
	var/mob/living/carbon/human/old_original = original_body

	if(force_return && M && old_original && !QDELETED(old_original) && M.current == old_clone)
		M.transfer_to(old_original)
		to_chat(old_original, span_userdanger("濒临崩溃的虚空分身把我的意识猛地拽回了本体！"))

	remove_switch_spell()

	if(old_clone && !QDELETED(old_clone))
		old_clone.visible_message(span_warning("[old_clone] 的虚空躯壳开始寸寸崩裂，最后像碎裂的傀儡般塌陷消散！"))
		if(old_original && !QDELETED(old_original))
			to_chat(old_original, span_warning("我与虚空分身之间的联系彻底断裂了。"))
		qdel(old_clone)

	qdel(src)

/obj/effect/proc_holder/spell/self/void_clone
	name = "分身术"
	desc = "以虚空石神奇的力量临时构建一个可以远程操控的躯体。"
	overlay_state = "shapeshift"
	associated_skill = /datum/skill/magic/arcane
	cost = 6
	xp_gain = TRUE
	releasedrain = 100
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 MINUTES
	cooldown_min = 30 MINUTES
	warnie = "spellwarning"
	spell_tier = 3
	invocations = list("虚空，塑我伪身！")
	invocation_type = "shout"
	glow_color = "#7f5bff"
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE
	movement_interrupt = TRUE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	human_req = TRUE
	miracle = FALSE
	gesture_required = TRUE

/obj/effect/proc_holder/spell/self/void_clone/choose_targets(mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast(user)
		return
	if(H.void_clone_link_custom)
		to_chat(H, span_warning("我的虚空分身尚未崩解，无法再次施展分身术。"))
		revert_cast(H)
		return

	var/obj/item/magic/voidstone/focus = H.get_active_held_item()
	if(!istype(focus))
		to_chat(H, span_warning("我必须在手中握着一块 voidstone，才能塑造分身。"))
		revert_cast(H)
		return

	H.visible_message(span_warning("[H] 手中的 voidstone 漂浮至半空，开始微微扭曲。"), span_notice("我举起手中的 voidstone，让它在掌前浮起并缓缓扭曲。"))
	if(!continue_clone_channel(H, focus, 15 SECONDS, "我的虚空塑形在最初的共鸣中崩散了。"))
		return

	H.visible_message(span_warning("扭曲的 voidstone 表面裂出暗色纹路，一具与 [H] 极其相似的人形轮廓开始在空中显现。"), span_notice("voidstone 的表面裂出暗色纹路，我的轮廓正被一点点描摹出来。"))
	if(!continue_clone_channel(H, focus, 15 SECONDS, "那具尚未成形的轮廓突然涣散了。"))
		return

	H.visible_message(span_warning("那道人形轮廓渐渐凝实，四肢、面容与身躯像被无形之手一点点雕刻出来。"), span_notice("虚空正在照着我的形体塑造身躯，四肢和面容都开始变得清晰。"))
	if(!continue_clone_channel(H, focus, 15 SECONDS, "我对虚空分身的塑造被强行打断了。"))
		return

	H.visible_message(span_warning("虚空构筑出的空壳终于立起，只差最后一道心念注入，它便会成为 [H] 的伪身。"), span_notice("那具空壳已然成形，只差最后一缕心念，我便能进入其中。"))
	if(!continue_clone_channel(H, focus, 15 SECONDS, "最后的注魂失败了，虚空塑成的身躯当场垮塌。"))
		return

	perform(null, user = H)

/obj/effect/proc_holder/spell/self/void_clone/cast(list/targets, mob/living/carbon/human/user = usr)
	if(!istype(user))
		revert_cast()
		return FALSE
	if(user.void_clone_link_custom)
		to_chat(user, span_warning("我的虚空分身尚未崩解，无法再次施展分身术。"))
		revert_cast(user)
		return FALSE

	var/obj/item/magic/voidstone/focus = user.get_active_held_item()
	if(!istype(focus))
		to_chat(user, span_warning("失去了手中的 voidstone，分身塑造自然也就失败了。"))
		revert_cast(user)
		return FALSE

	var/turf/spawn_turf = find_clone_spawn_turf(user)
	if(!spawn_turf)
		to_chat(user, span_warning("周围没有足够稳固的空间供分身成形。"))
		revert_cast(user)
		return FALSE

	var/mob/living/carbon/human/clone = new /mob/living/carbon/human(spawn_turf)
	if(!clone)
		to_chat(user, span_warning("虚空未能回应我的塑形。"))
		revert_cast(user)
		return FALSE

	clone.copy_physical_features(user)
	clone.copy_known_languages_from(user, TRUE)
	clone.faction = islist(user.faction) ? user.faction.Copy() : user.faction
	clone.set_patron(user.patron)
	clone.fully_replace_character_name(null, user.real_name)
	clone.regenerate_icons()
	clone.update_body()

	copy_stable_traits(user, clone)
	apply_puppet_traits(clone)
	apply_clone_stat_penalty(user, clone)

	user.temporarilyRemoveItemFromInventory(focus, TRUE)
	qdel(focus)

	var/datum/mind/M = user.mind
	if(!M)
		qdel(clone)
		revert_cast(user)
		return FALSE

	M.transfer_to(clone)
	var/datum/void_clone_link/link = new(user, clone)
	addtimer(CALLBACK(link, TYPE_PROC_REF(/datum/void_clone_link, sync_current_body_spell_access)), 0.1 SECONDS)

	clone.visible_message(span_warning("[clone] 睁开双眼，仿佛一具刚被心念点亮的空壳。"), span_notice("我的意识被猛地牵入新塑成的虚空分身之中。"))
	to_chat(clone, span_notice("分身拥有我的法术与技艺，但在我操控它时，无法使用分身术与学习法术。"))
	if(user)
		to_chat(user, span_notice("我的本体留在原地，而意识已投入新塑成的虚空分身之中。"))
	return TRUE

/obj/effect/proc_holder/spell/self/void_clone/proc/continue_clone_channel(mob/living/carbon/human/user, obj/item/magic/voidstone/focus, wait_time, fail_text)
	if(!istype(user) || !istype(focus))
		revert_cast(user)
		return FALSE
	if(user.void_clone_link_custom)
		to_chat(user, span_warning("已有分身存在，虚空不再回应新的塑形。"))
		revert_cast(user)
		return FALSE
	if(user.get_active_held_item() != focus)
		to_chat(user, span_warning("我必须始终握住那块 voidstone，才能维持分身塑造。"))
		revert_cast(user)
		return FALSE
	if(!do_after(user, wait_time, target = user, progress = TRUE))
		to_chat(user, span_warning("[fail_text]"))
		revert_cast(user)
		return FALSE
	if(user.get_active_held_item() != focus)
		to_chat(user, span_warning("手中的 voidstone 脱离了掌控，分身术随之瓦解。"))
		revert_cast(user)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/void_clone/proc/find_clone_spawn_turf(mob/living/carbon/human/user)
	if(!user)
		return null
	var/turf/origin = get_turf(user)
	if(!origin)
		return null
	var/turf/front = get_step(user, user.dir)
	if(isturf(front) && !front.density)
		return front
	for(var/turf/T in orange(1, origin))
		if(!T.density)
			return T
	return origin

/obj/effect/proc_holder/spell/self/void_clone/proc/copy_stable_traits(mob/living/carbon/human/source, mob/living/carbon/human/clone)
	if(!source?.status_traits || !clone)
		return
	var/list/allowed_sources = list(JOB_TRAIT, ROUNDSTART_TRAIT, TRAIT_VIRTUE, ADVENTURER_TRAIT, INNATE_TRAIT)
	for(var/trait in source.status_traits)
		var/list/sources = source.status_traits[trait]
		if(!islist(sources))
			continue
		for(var/source_tag in allowed_sources)
			if(source_tag in sources)
				ADD_TRAIT(clone, trait, VOID_CLONE_TRAIT_SOURCE)
				break

/obj/effect/proc_holder/spell/self/void_clone/proc/apply_puppet_traits(mob/living/carbon/human/clone)
	if(!clone)
		return
	var/list/puppet_traits = list(
		TRAIT_NOSLEEP,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOPAIN,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_NOMETABOLISM,
		TRAIT_NOHUNGER
	)
	for(var/trait in puppet_traits)
		ADD_TRAIT(clone, trait, VOID_CLONE_TRAIT_SOURCE)
	if(!(NOBLOOD in clone.dna.species.species_traits))
		clone.dna.species.species_traits += NOBLOOD
	clone.reagents?.end_metabolization(clone, keep_liverless = TRUE)

/obj/effect/proc_holder/spell/self/void_clone/proc/apply_clone_stat_penalty(mob/living/carbon/human/source, mob/living/carbon/human/clone)
	if(!source || !clone)
		return
	var/list/stat_names = list(STAT_STRENGTH, STAT_PERCEPTION, STAT_INTELLIGENCE, STAT_CONSTITUTION, STAT_WILLPOWER, STAT_SPEED, STAT_FORTUNE)
	for(var/stat in stat_names)
		var/target_value = max(source.get_stat(stat) - 2, 1)
		var/difference = target_value - clone.get_stat(stat)
		if(difference)
			clone.change_stat(stat, difference)

/obj/effect/proc_holder/spell/self/void_clone_switch
	name = "切换身体"
	desc = "在本体与虚空分身之间切换操控。"
	overlay_state = "blink"
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 1 SECONDS
	cooldown_min = 1 SECONDS
	associated_skill = /datum/skill/magic/arcane
	miracle = FALSE
	gesture_required = FALSE
	invocation_type = "none"

/obj/effect/proc_holder/spell/self/void_clone_switch/cast(list/targets, mob/living/carbon/human/user = usr)
	if(!istype(user))
		revert_cast()
		return FALSE
	var/datum/void_clone_link/link = user.void_clone_link_custom
	if(!link)
		to_chat(user, span_warning("我感应不到任何仍然存在的虚空分身。"))
		revert_cast(user)
		return FALSE
	if(QDELETED(link.clone_body) || !link.clone_body || QDELETED(link.original_body) || !link.original_body)
		link.cleanup_clone(FALSE)
		revert_cast(user)
		return FALSE

	var/datum/mind/M = user.mind
	if(!M)
		revert_cast(user)
		return FALSE

	var/mob/living/carbon/human/target_body = (user == link.original_body) ? link.clone_body : link.original_body
	if(!target_body || QDELETED(target_body))
		link.cleanup_clone(FALSE)
		revert_cast(user)
		return FALSE

	user.visible_message(span_notice("[user] 的双眼短暂失焦，意识仿佛被一根看不见的丝线猛地拽向了别处。"))
	M.transfer_to(target_body)
	link.sync_current_body_spell_access()
	to_chat(target_body, span_notice("我的意识顺着虚空中的暗线，切换到了另一具身体。"))
	return TRUE

#undef VOID_CLONE_TRAIT_SOURCE
#undef VOID_CLONE_CHECK_INTERVAL
