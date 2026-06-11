/obj/effect/proc_holder/spell/invoked/mindlink
	name = "心灵链接"
	desc = "与一名盟友建立持续三分钟的心灵链接。发言前输入 ,y 即可进行心灵交流。"
	clothes_req = FALSE
	overlay_state = "mindlink"
	associated_skill = /datum/skill/magic/arcane
	cost = 2
	xp_gain = TRUE
	recharge_time = 3 MINUTES
	spell_tier = 3
	invocations = list("心念相连。")
	invocation_type = "whisper"

	// Charged spell variables
	chargedloop = /datum/looping_sound/invokegen
	chargedrain = 1
	chargetime = 20
	releasedrain = 25
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	warnie = "spellwarning"
	ignore_los = TRUE

/obj/effect/proc_holder/spell/invoked/mindlink/cast(list/targets, mob/living/user)
	. = ..()
	if(!istype(user))
		return

	var/list/possible_targets = list()
	if(user.mind.known_people.len)
		for(var/people in user.mind.known_people)
			possible_targets += people
	else
		to_chat(user, span_warning("没有我认识的人可供建立心灵链接！"))
		revert_cast()
		return FALSE

	possible_targets = sortList(possible_targets)

	if(user.client)
		possible_targets = list(user.real_name) + possible_targets // Oohhhhhh this looks bad. But this is supposed to append ourselves at the start of the ordered list.

	user.emote("me", 1, "'s eyes briefly glow with an otherworldly light.", TRUE, custom_me = TRUE)

	var/first_target_name = input(user, "选择第一个链接对象", "心灵链接") as null|anything in possible_targets

	if(!first_target_name)
		revert_cast()
		return FALSE

	var/mob/living/first_target

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == first_target_name)
			first_target = HL

	possible_targets -= first_target_name

	var/second_target_name = input(user, "选择第二个链接对象", "心灵链接") as null|anything in possible_targets

	if(!second_target_name)
		revert_cast()
		return FALSE

	var/mob/living/second_target

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == second_target_name)
			second_target = HL

	// Check if either target is a zad
	if(istype(first_target, /mob/living/simple_animal/hostile/retaliate/bat/crow) || istype(second_target, /mob/living/simple_animal/hostile/retaliate/bat/crow))
		to_chat(user, span_warning("扎德不受心灵链接影响！"))
		revert_cast()
		return FALSE

	user.visible_message(span_notice("[user]轻触太阳穴，凝神专注......"), span_notice("我在[first_target]与[second_target]之间建立起一道心灵连接......"))

	// Create the mindlink
	var/datum/mindlink/link = new(first_target, second_target)
	GLOB.mindlinks += link

	to_chat(first_target, span_notice("你已与[second_target]建立心灵链接！发言前输入 ,m 即可进行心灵交流。"))
	to_chat(second_target, span_notice("你已与[first_target]建立心灵链接！发言前输入 ,m 即可进行心灵交流。"))

	addtimer(CALLBACK(src, PROC_REF(break_link), link), 3 MINUTES)
	return TRUE

/obj/effect/proc_holder/spell/invoked/mindlink/proc/break_link(datum/mindlink/link)
	if(!link)
		return

	to_chat(link.owner, span_warning("你与[link.target]之间的心灵链接逐渐消散......"))
	to_chat(link.target, span_warning("你与[link.owner]之间的心灵链接逐渐消散......"))

	GLOB.mindlinks -= link
	qdel(link)

/obj/effect/proc_holder/spell/invoked/mindlink/proc/break_mindlink_if_zad(mob/living/shifter, new_type)
	if(new_type == /mob/living/simple_animal/hostile/retaliate/bat/crow)
		for(var/datum/mindlink/link in GLOB.mindlinks)
			if(shifter == link.owner || shifter == link.target)
				to_chat(link.owner, span_warning("[shifter]化作扎德，心灵链接随之断裂！"))
				to_chat(link.target, span_warning("[shifter]化作扎德，心灵链接随之断裂！"))
				GLOB.mindlinks -= link
				qdel(link)


