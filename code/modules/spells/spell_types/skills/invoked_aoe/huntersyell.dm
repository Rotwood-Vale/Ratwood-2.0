//A skill to help hunters scare away woodland threats
/obj/effect/proc_holder/spell/invoked/huntersyell
	name = "猎人吼喝"
	desc = "我发出一声吼喝，驱散林中的野兽。这是我长久栖居此地、狩猎多年的经验所成。对更聪明的生物无效。"
	overlay_state = "tamebeast"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 17 MINUTES //useful for driving away beasts but can't be spammed or over used, more of an emergency skill
	antimagic_allowed = TRUE
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg' //I'd like a shout of some kind to add here.
	range = 5
	var/scareable_factions = list("saiga", "chickens", "cows", "goats", "wolfs", "spiders", "rats", "fae", "trolls")

/obj/effect/proc_holder/spell/invoked/huntersyell/cast(list/targets, mob/living/user)
	. = ..()
	visible_message(span_green("[usr] 发出一声震耳欲聋的吼喝，将附近的野兽惊退了！"))
	var/scared = FALSE
	for(var/mob/living/simple_animal/hostile/retaliate/animal in get_hearers_in_view(7, usr))
		//if((animal.mob_biotypes & MOB_UNDEAD))
		//	continue
		if(faction_check(animal.faction, scareable_factions))
			animal.aggressive = FALSE
			if(animal.ai_controller)
				animal.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
				animal.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
				animal.ai_controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, TRUE)
				animal.ai_controller.set_blackboard_key(BB_BASIC_MOB_NEXT_FLEEING, world.time + 10 SECONDS)
			user.emote("warcry")
			to_chat(usr, "随着这一声吼喝，[animal] 被你惊得逃开了。")
	return scared
