/datum/component/familial_bond
	var/mob/living/carbon/human/bonded_with
	var/bond_duration
	var/bond_strength = 100 // Bond strength affects range and clarity of sensing
	var/last_health_check = 0
	var/last_location_ping = 0
	var/ping_cooldown = 30 SECONDS
	var/health_check_interval = 15 SECONDS
	var/max_sensing_range = 50 // Maximum range for sensing on same z-level
	var/emergency_threshold = 30 // Health percentage that triggers emergency alerts

/datum/component/familial_bond/Initialize(mob/living/carbon/human/target, duration)
	if(!istype(target) || !istype(parent))
		return COMPONENT_INCOMPATIBLE

	bonded_with = target
	bond_duration = duration
	last_health_check = world.time
	last_location_ping = world.time

	// Notify both parties of the bond formation
	var/mob/living/carbon/human/parent_mob = parent
	to_chat(parent_mob, span_purple("我感到自己正与[bonded_with]建立起一股温暖的灵魂联结。"))
	to_chat(bonded_with, span_purple("我感到自己正与[parent_mob]建立起一股温暖的灵魂联结。"))

	// Set up termination timer
	addtimer(CALLBACK(src, PROC_REF(end_bond)), duration)
	START_PROCESSING(SSprocessing, src)

	// Register signal handlers for enhanced interaction
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_parent_death))
	RegisterSignal(bonded_with, COMSIG_LIVING_DEATH, PROC_REF(on_bonded_death))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_movement))

/datum/component/familial_bond/Destroy()
	UnregisterSignal(parent, list(COMSIG_LIVING_DEATH, COMSIG_MOVABLE_MOVED))
	if(bonded_with)
		UnregisterSignal(bonded_with, COMSIG_LIVING_DEATH)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/component/familial_bond/process()
	if(!bonded_with || QDELETED(bonded_with) || !parent || QDELETED(parent))
		end_bond()
		return

	var/mob/living/carbon/human/parent_mob = parent

	// Check if we're still on the same server/existence plane
	if(bonded_with.z == 0 || parent_mob.z == 0)
		return

	// Periodic health monitoring
	if(world.time >= last_health_check + health_check_interval)
		check_bonded_health()
		last_health_check = world.time

	// Location sensing with reduced frequency
	if(world.time >= last_location_ping + ping_cooldown)
		provide_location_sense()
		last_location_ping = world.time

	// Bond strength naturally degrades over time (adds realism)
	if(prob(5))
		bond_strength = max(bond_strength - 1, 20)

/datum/component/familial_bond/proc/check_bonded_health()
	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob || !bonded_with)
		return

	var/bonded_health_percent = (bonded_with.health / bonded_with.maxHealth) * 100

	// Emergency health alerts
	if(bonded_health_percent <= emergency_threshold)
		to_chat(parent_mob, span_danger("我的胸口猛然一痛 - [bonded_with] 正身陷险境！"))
		// Add a subtle screen effect
		parent_mob.overlay_fullscreen("familial_pain", /atom/movable/screen/fullscreen/painflash, 1)
		addtimer(CALLBACK(parent_mob, TYPE_PROC_REF(/mob, clear_fullscreen), "familial_pain"), 3 SECONDS)

	// Mutual health awareness at close range
	if(get_dist(parent_mob, bonded_with) <= 7 && parent_mob.z == bonded_with.z)
		if(bonded_health_percent <= 50)
			to_chat(parent_mob, span_warning("我感知到[bonded_with]受伤了。"))
		else if(bonded_health_percent >= 90)
			to_chat(parent_mob, span_notice("我感知到[bonded_with]状态安好。"))

/datum/component/familial_bond/proc/provide_location_sense()
	var/mob/living/carbon/human/parent_mob = parent
	if(!parent_mob || !bonded_with)
		return

	// Different z-levels
	if(parent_mob.z != bonded_with.z)
		to_chat(parent_mob, span_info("我感知到[bonded_with]位于另一层存在之中。"))
		return

	var/distance = get_dist(parent_mob, bonded_with)
	var/direction = get_dir(parent_mob, bonded_with)

	// Range check based on bond strength
	var/effective_range = max_sensing_range * (bond_strength / 100)
	if(distance > effective_range)
		to_chat(parent_mob, span_info("我与[bonded_with]的联结过于遥远，已难以清晰感知。"))
		return

	// Provide detailed location information based on distance
	var/distance_desc
	var/direction_text = dir2text(direction)

	switch(distance)
		if(0 to 3)
			distance_desc = "非常近"
		if(4 to 7)
			distance_desc = "就在附近"
		if(8 to 15)
			distance_desc = "有些距离"
		if(16 to 25)
			distance_desc = "很远"
		if(26 to INFINITY)
			distance_desc = "极远"

	// Add emotional context based on bond strength
	var/bond_feeling = ""
	if(bond_strength >= 80)
		bond_feeling = " 这份联结强烈而温暖。"
	else if(bond_strength >= 50)
		bond_feeling = " 这份纽带十分稳固。"
	else if(bond_strength >= 30)
		bond_feeling = " 这份联结显得有些微弱。"
	else
		bond_feeling = " 这份纽带正在衰弱。"

	to_chat(parent_mob, span_info("我感知到[bonded_with]位于我的[direction_text]方向[distance_desc]处。[bond_feeling]"))

/datum/component/familial_bond/proc/on_parent_death(mob/living/source)
	SIGNAL_HANDLER

	if(bonded_with)
		to_chat(bonded_with, span_danger("随着你与[source]之间的纽带被死亡斩断，我感到可怕的空虚。"))
		bonded_with.add_stress(/datum/stressevent/bond_death)
	end_bond()

/datum/component/familial_bond/proc/on_bonded_death(mob/living/source)
	SIGNAL_HANDLER

	var/mob/living/carbon/human/parent_mob = parent
	if(parent_mob)
		to_chat(parent_mob, span_danger("随着我与[source]之间的纽带被死亡斩断，我感到可怕的空虚。"))
		parent_mob.add_stress(/datum/stressevent/bond_death)
	end_bond()

/datum/component/familial_bond/proc/on_movement(mob/living/source)
	SIGNAL_HANDLER

	// Chance to feel movement of bonded person when very close
	if(get_dist(source, bonded_with) <= 3 && prob(30))
		to_chat(bonded_with, span_info("我感知到[source]正在附近移动。"))

/datum/component/familial_bond/proc/strengthen_bond(amount = 10)
	bond_strength = min(bond_strength + amount, 100)
	var/mob/living/carbon/human/parent_mob = parent
	to_chat(parent_mob, span_purple("我的亲族纽带变得更强了。"))
	if(bonded_with)
		to_chat(bonded_with, span_purple("我的亲族纽带变得更强了。"))

/datum/component/familial_bond/proc/weaken_bond(amount = 15)
	bond_strength = max(bond_strength - amount, 10)
	var/mob/living/carbon/human/parent_mob = parent
	to_chat(parent_mob, span_warning("我的亲族纽带变弱了。"))
	if(bonded_with)
		to_chat(bonded_with, span_warning("我的亲族纽带变弱了。"))

	if(bond_strength <= 10)
		to_chat(parent_mob, span_danger("我的亲族纽带几乎要断裂了！"))
		// Chance for early termination if bond is too weak
		if(prob(25))
			end_bond()

/datum/component/familial_bond/proc/end_bond()
	var/mob/living/carbon/human/parent_mob = parent

	if(parent_mob)
		to_chat(parent_mob, span_info("我的亲族纽带渐渐消散，但那份联结的记忆仍旧留存。"))
		parent_mob.add_stress(/datum/stressevent/bond_ended)

	if(bonded_with)
		to_chat(bonded_with, span_info("我的亲族纽带渐渐消散，但那份联结的记忆仍旧留存。"))
		bonded_with.add_stress(/datum/stressevent/bond_ended)

	STOP_PROCESSING(SSprocessing, src)
	qdel(src)

/datum/stressevent/bond_death
	desc = "与我缔结纽带之人已经死去。我感到内心一片空洞。"
	stressadd = 6
	timer = 30 MINUTES

/datum/stressevent/bond_ended
	desc = "一段亲族纽带已经终结，但我仍感激我们曾共享的联结。"
	stressadd = -1
	timer = 10 MINUTES
