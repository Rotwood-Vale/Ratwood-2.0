/datum/component/empathic_obsession
	var/mob/living/carbon/human/obsession_target
	var/obsession_duration
	var/obsession_intensity = 100 // How strongly the caster is obsessed (affects mood penalties)
	var/last_health_check = 0
	var/last_proximity_check = 0
	var/health_check_interval = 10 SECONDS
	var/proximity_check_interval = 15 SECONDS
	var/max_comfortable_distance = 10 // Distance before anxiety kicks in
	var/last_known_health = 100
	var/separation_anxiety_active = FALSE
	var/critical_health_threshold = 40
	var/panic_mode = FALSE

/datum/component/empathic_obsession/Initialize(mob/living/carbon/human/target, duration)
	if(!istype(target) || !istype(parent))
		return COMPONENT_INCOMPATIBLE

	obsession_target = target
	obsession_duration = duration
	last_health_check = world.time
	last_proximity_check = world.time
	last_known_health = (target.health / target.maxHealth) * 100

	var/mob/living/carbon/human/parent_mob = parent
	to_chat(parent_mob, span_purple("我感到自己正与[target]建立起强烈的情感联结。他们的安危对我而言变得无比重要。"))

	// Initial positive mood from forming the bond
	parent_mob.add_stress(/datum/stressevent/empathic_bond_formed)

	// Set up termination timer
	addtimer(CALLBACK(src, PROC_REF(end_obsession)), duration)
	START_PROCESSING(SSprocessing, src)

	// Register signal handlers
	RegisterSignal(obsession_target, COMSIG_LIVING_DEATH, PROC_REF(on_target_death))
	RegisterSignal(obsession_target, COMSIG_LIVING_REVIVE, PROC_REF(on_target_revive))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_parent_death))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_parent_moved))

/datum/component/empathic_obsession/Destroy()
	if(obsession_target)
		UnregisterSignal(obsession_target, list(COMSIG_LIVING_DEATH, COMSIG_LIVING_REVIVE))
	UnregisterSignal(parent, list(COMSIG_LIVING_DEATH, COMSIG_MOVABLE_MOVED))
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/empathic_obsession/process()
	if(!obsession_target || QDELETED(obsession_target) || !parent || QDELETED(parent))
		end_obsession()
		return

	// Periodic health monitoring
	if(world.time >= last_health_check + health_check_interval)
		monitor_target_health()
		last_health_check = world.time

	// Proximity anxiety checks
	if(world.time >= last_proximity_check + proximity_check_interval)
		check_proximity_anxiety()
		last_proximity_check = world.time

	// Obsession intensity can fluctuate based on circumstances
	adjust_obsession_intensity()

/datum/component/empathic_obsession/proc/monitor_target_health()
	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob || !obsession_target)
		return

	var/current_health = (obsession_target.health / obsession_target.maxHealth) * 100
	var/health_change = current_health - last_known_health

	// React to health changes
	if(health_change < -15) // Significant health loss
		to_chat(parent_mob, span_danger("一阵痛苦涌上心头 - [obsession_target] 正在受伤！"))
		parent_mob.add_stress(/datum/stressevent/obsession_target_hurt)

		// Visual distress effect
		parent_mob.overlay_fullscreen("empathic_distress", /atom/movable/screen/fullscreen/painflash, 2)
		addtimer(CALLBACK(parent_mob, TYPE_PROC_REF(/mob, clear_fullscreen), "empathic_distress"), 5 SECONDS)

	else if(health_change > 15) // Significant healing
		to_chat(parent_mob, span_notice("随着[obsession_target]恢复，我感到如释重负。"))
		parent_mob.add_stress(/datum/stressevent/obsession_target_healed)
		parent_mob.remove_stress(/datum/stressevent/obsession_target_hurt)

	// Critical health panic
	if(current_health <= critical_health_threshold && !panic_mode)
		enter_panic_mode()
	else if(current_health > critical_health_threshold && panic_mode)
		exit_panic_mode()

	last_known_health = current_health

/datum/component/empathic_obsession/proc/check_proximity_anxiety()
	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob || !obsession_target)
		return

	var/distance = get_dist(parent_mob, obsession_target)
	var/different_z = (parent_mob.z != obsession_target.z)

	// Separation anxiety
	if(distance > max_comfortable_distance || different_z)
		if(!separation_anxiety_active)
			separation_anxiety_active = TRUE
			to_chat(parent_mob, span_warning("与[obsession_target]分离让我感到焦虑。"))
			parent_mob.add_stress(/datum/stressevent/separation_anxiety)
	else
		if(separation_anxiety_active)
			separation_anxiety_active = FALSE
			to_chat(parent_mob, span_notice("[obsession_target]就在附近，我的心情平静了不少。"))
			parent_mob.remove_stress(/datum/stressevent/separation_anxiety)
			parent_mob.add_stress(/datum/stressevent/proximity_comfort)

/datum/component/empathic_obsession/proc/adjust_obsession_intensity()
	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob)
		return

	// Intensity increases with stress and decreases with comfort
	if(separation_anxiety_active || panic_mode)
		obsession_intensity = min(obsession_intensity + 2, 150)
	else if(get_dist(parent_mob, obsession_target) <= 3)
		obsession_intensity = max(obsession_intensity - 1, 50)

	// Provide feedback on obsession level changes
	if(obsession_intensity >= 120 && prob(5))
		to_chat(parent_mob, span_warning("我的思绪总是不由自主地回到[obsession_target]身上，根本停不下来。"))
	else if(obsession_intensity <= 60 && prob(5))
		to_chat(parent_mob, span_notice("一想到[obsession_target]，我稍微安心了一些。"))

/datum/component/empathic_obsession/proc/enter_panic_mode()
	panic_mode = TRUE
	var/mob/living/carbon/human/parent_mob = parent

	to_chat(parent_mob, span_userdanger("压倒性的恐慌席卷而来 - [obsession_target] 命在旦夕！"))
	parent_mob.add_stress(/datum/stressevent/obsession_panic)

	// Strong visual effect
	parent_mob.overlay_fullscreen("empathic_panic", /atom/movable/screen/fullscreen/high, 1)

	// Compulsive behavior - try to move toward target if possible
	if(get_dist(parent_mob, obsession_target) <= 20 && parent_mob.z == obsession_target.z)
		parent_mob.create_walk_to(5 SECONDS, obsession_target)
		to_chat(parent_mob, span_danger("我强烈地想立刻赶到[obsession_target]身边！"))

/datum/component/empathic_obsession/proc/exit_panic_mode()
	panic_mode = FALSE
	var/mob/living/carbon/human/parent_mob = parent

	to_chat(parent_mob, span_notice("[obsession_target]似乎正在恢复，我感到极大的宽慰。"))
	parent_mob.remove_stress(/datum/stressevent/obsession_panic)
	parent_mob.add_stress(/datum/stressevent/crisis_relief)
	parent_mob.clear_fullscreen("empathic_panic")

/datum/component/empathic_obsession/proc/on_target_death(mob/living/source)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob)
		return

	to_chat(parent_mob, span_userdanger("随着[source]死去，毁灭般的空虚吞没了我。仿佛我的一部分也一同死去了。"))

	// Severe negative mood effects
	parent_mob.add_stress(/datum/stressevent/obsession_death)
	parent_mob.remove_stress(/datum/stressevent/empathic_bond_formed)
	parent_mob.remove_stress(/datum/stressevent/proximity_comfort)
	parent_mob.remove_stress(/datum/stressevent/crisis_relief)

	// Dramatic visual effect
	parent_mob.overlay_fullscreen("empathic_death", /atom/movable/screen/fullscreen/blind, 2)
	addtimer(CALLBACK(parent_mob, TYPE_PROC_REF(/mob, clear_fullscreen), "empathic_death"), 10 SECONDS)

	// Extend obsession duration due to grief
	obsession_duration += 20 MINUTES
	addtimer(CALLBACK(src, PROC_REF(end_obsession)), obsession_duration)

/datum/component/empathic_obsession/proc/on_target_revive(mob/living/source)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob)
		return

	to_chat(parent_mob, span_purple("随着[source]重返人世，压倒性的喜悦与宽慰涌上心头！"))
	parent_mob.add_stress(/datum/stressevent/obsession_revival)
	parent_mob.remove_stress(/datum/stressevent/obsession_death)
	panic_mode = FALSE

/datum/component/empathic_obsession/proc/on_parent_death(mob/living/source)
	SIGNAL_HANDLER
	end_obsession()

/datum/component/empathic_obsession/proc/on_parent_moved(mob/living/source)
	SIGNAL_HANDLER
	// Reset proximity check timer when parent moves to get immediate feedback
	last_proximity_check = world.time - proximity_check_interval

/datum/component/empathic_obsession/proc/end_obsession()
	var/mob/living/carbon/human/parent_mob = parent

	if(parent_mob)
		to_chat(parent_mob, span_info("我对[obsession_target]那股强烈的情感联结渐渐消退了，但回忆仍在。"))
		parent_mob.add_stress(/datum/stressevent/obsession_ended)

		// Clear all obsession-related mood events
		parent_mob.remove_stress(/datum/stressevent/empathic_bond_formed)
		parent_mob.remove_stress(/datum/stressevent/separation_anxiety)
		parent_mob.remove_stress(/datum/stressevent/proximity_comfort)
		parent_mob.remove_stress(/datum/stressevent/obsession_panic)
		parent_mob.remove_stress(/datum/stressevent/crisis_relief)
		parent_mob.remove_stress(/datum/stressevent/obsession_target_hurt)
		parent_mob.remove_stress(/datum/stressevent/obsession_target_healed)

		parent_mob.clear_fullscreen("empathic_panic")
		parent_mob.clear_fullscreen("empathic_distress")

	STOP_PROCESSING(SSprocessing, src)
	qdel(src)


// Missing mood events for the empathic obsession component

/datum/stressevent/empathic_bond_formed
	desc = "我与某个特别之人之间生出了深厚的情感联结。"
	stressadd = -3
	timer = 30 MINUTES

/datum/stressevent/obsession_target_hurt
	desc = "我深深在乎的人受伤了！我仿佛也感受到了他们的痛楚。"
	stressadd = 4
	timer = 10 MINUTES

/datum/stressevent/obsession_target_healed
	desc = "想到对我重要的人正在恢复，我感到宽慰。"
	stressadd = -2
	timer = 5 MINUTES

/datum/stressevent/separation_anxiety
	desc = "远离与我心意相连之人，让我感到焦虑。"
	stressadd = 3
	timer = 0 // Persistent while active

/datum/stressevent/proximity_comfort
	desc = "待在我所关心的人身边，让我感到平静而安心。"
	stressadd = -2
	timer = 5 MINUTES

/datum/stressevent/obsession_panic
	desc = "一想到某人的安危，我就被恐慌彻底淹没！"
	stressadd = 6
	timer = 0 // Persistent while active

/datum/stressevent/crisis_relief
	desc = "危机过去后，我感到无比宽慰。"
	stressadd = -4
	timer = 15 MINUTES

/datum/stressevent/obsession_death
	desc = "与我深深相连之人已经死去。我心如刀割。"
	stressadd = 8
	timer = 60 MINUTES

/datum/stressevent/obsession_revival
	desc = "我珍视之人重返人世！我感到难以言喻的喜悦！"
	stressadd = -6
	timer = 30 MINUTES

/datum/stressevent/obsession_ended
	desc = "一段强烈的情感联结已经消散，但我仍珍藏着那份回忆。"
	stressadd = -1
	timer = 10 MINUTES
