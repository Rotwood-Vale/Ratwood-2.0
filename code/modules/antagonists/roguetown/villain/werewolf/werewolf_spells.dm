/obj/effect/proc_holder/spell/self/howl
	name = "Howl"
	desc = "Howl to the moon to communicate with my fellow wolves. Do beware, those versed in beasttongue may be listening."
	overlay_state = "howl"
	antimagic_allowed = TRUE
	recharge_time = 600 //1 minute
	ignore_cockblock = TRUE
	var/use_language = FALSE
	var/list/howl_sounds = list('sound/vo/mobs/wwolf/howl (1).ogg','sound/vo/mobs/wwolf/howl (2).ogg')
	var/list/howl_sounds_far = list('sound/vo/mobs/wwolf/howldist (1).ogg','sound/vo/mobs/wwolf/howldist (2).ogg')
	var/howl_antag_type = /datum/antagonist/werewolf
	// Who can hear this howl. Use HOWL_CHANNEL_* constants. Default: werewolves and druids.
	var/list/howl_channels = list(HOWL_CHANNEL_WEREWOLF, HOWL_CHANNEL_DRUID)
	var/howl_distance_limit = 50
	var/howl_distance_volume = 50
	var/howl_prompt_text = "Howl at the hidden moon..."
	var/howl_prompt_title = "MOONCURSED"
	var/howl_announcement_target = "hidden moon"

/obj/effect/proc_holder/spell/self/howl/proc/is_druid_howl_listener(mob/player)
	if(!player?.mind)
		return FALSE

	if(player.mind.assigned_role == "Druid" || player.mind.assigned_role == "Druidess")
		return TRUE

	var/mob/living/carbon/human/human_player = player
	if(istype(human_player) && human_player.patron?.type == /datum/patron/divine/dendor && player.mind.assigned_role == "Acolyte")
		return TRUE

	if(player.mind.get_spell(/obj/effect/proc_holder/spell/self/howl/call_of_the_moon))
		return TRUE

	return FALSE

/obj/effect/proc_holder/spell/self/howl/cast(mob/user = usr)
	..()
	var/message = input(howl_prompt_text, howl_prompt_title) as text|null
	if(!message) return

	var/datum/antagonist/antag_data = user.mind.has_antag_datum(howl_antag_type)

	// sound played for owner
	playsound(user, pick(howl_sounds_far), 75, TRUE)

	for(var/mob/player in GLOB.player_list)

		if(!player.mind) continue
		if(isbrain(player)) continue
		var/speaker_name = (antag_data && hasvar(antag_data, "wolfname")) ? antag_data:wolfname : user.real_name

		// Admin ghost visibility
		if(IsAdminGhost(player))
			to_chat(player, span_notice("[speaker_name] howls to the [howl_announcement_target]: [message]"))
			continue

		// Check each named channel to see if this player qualifies to hear the howl
		var/can_hear = FALSE
		if(HOWL_CHANNEL_WEREWOLF in howl_channels)
			can_hear = can_hear || player.mind.has_antag_datum(/datum/antagonist/werewolf)
		if(HOWL_CHANNEL_DRUID in howl_channels)
			can_hear = can_hear || is_druid_howl_listener(player)
		if(HOWL_CHANNEL_GNOLL in howl_channels)
			can_hear = can_hear || player.mind.has_antag_datum(/datum/antagonist/gnoll)
		if(can_hear)
			to_chat(player, span_boldannounce("[speaker_name] howls to the [howl_announcement_target]: [message]"))

		//sound played for other players
		if(player == user) continue
		var/player_distance = get_dist(player, user)
		if(player_distance > 7 && player_distance <= howl_distance_limit)
			player.playsound_local(get_turf(player), pick(howl_sounds_far), howl_distance_volume, FALSE, pressure_affected = FALSE)

	user.log_message("howls: [message] ([howl_antag_type])", LOG_GAME)

/obj/effect/proc_holder/spell/self/claws
	name = "Lupine Claws"
	desc = "Unsheathe your claws"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 20 //2 seconds
	ignore_cockblock = TRUE
	var/list/extended_claw_record = list(FALSE, FALSE)
	var/claw_type = /obj/item/rogueweapon/werewolf_claw

/obj/effect/proc_holder/spell/self/claws/cast(list/targets, mob/user)
	. = ..()
	var/list/current_hands = list(FALSE, FALSE)
	current_hands[LEFT_HANDS] = user.get_item_for_held_index(LEFT_HANDS)
	current_hands[RIGHT_HANDS] = user.get_item_for_held_index(RIGHT_HANDS)
	var/extending_claws = FALSE
	// note the potential (and intentional) double negative for having a hand for that index; if you're missing
	// that arm, we need to return a truthy value to flip into a falsy value, so you don't try to extend claws
	// if you're missing one arm and trying to free up the other hand from your current claws
	if(!(current_hands[LEFT_HANDS] || !user.has_hand_for_held_index(LEFT_HANDS)) || !(current_hands[RIGHT_HANDS] || !user.has_hand_for_held_index(RIGHT_HANDS)))
		extending_claws = TRUE
	//LEFT_HANDS = 1, RIGHT_HANDS = 2, see code/__DEFINES/inventory.dm
	for(var/hand_index = 1, hand_index < 3, hand_index++)
		var/current_item = current_hands[hand_index]
		if(extending_claws)
			// don't try to force a claw into a hand holding something, like a succulent limb inconveniently
			// attached to a victim
			if(current_hands[hand_index])
				continue
			// don't try to force a claw into a hand that was detached from you, non-succulently
			if(!user.has_hand_for_held_index(hand_index))
				continue
			var/new_claw
			if(hand_index == LEFT_HANDS)
				var/left_claw_path = text2path("[claw_type]/left")
				new_claw = new left_claw_path(user)
				user.put_in_l_hand(new_claw)
				extended_claw_record[LEFT_HANDS] = new_claw
			else
				var/right_claw_path = text2path("[claw_type]/right")
				new_claw = new right_claw_path(user)
				user.put_in_r_hand(new_claw)
				extended_claw_record[RIGHT_HANDS] = new_claw
			RegisterSignal(new_claw, COMSIG_QDELETING, PROC_REF(clear_claw_entry))
			continue
		var/claw_entry = extended_claw_record[hand_index]
		if(claw_entry && current_item != claw_entry)
			var/msg = "[user] held item wasn't extended_claw_entry as expected; Expected: [claw_entry], Got: [current_item]"
			log_admin(msg)
			log_runtime(msg)
		if(istype(current_item, claw_type))
			if(!claw_entry)
				var/msg = "[user] had a werewolf claw that wasn't being tracked by the claw entries: [current_item]"
				log_admin(msg)
				log_runtime(msg)
			user.temporarilyRemoveItemFromInventory(I = current_item, force = TRUE)
			qdel(current_item)
		extended_claw_record[hand_index] = FALSE		
	return TRUE

/obj/effect/proc_holder/spell/self/claws/proc/clear_claw_entry(datum/source)
	SIGNAL_HANDLER
	var/claw_index = extended_claw_record.Find(source)
	if(claw_index)
		extended_claw_record[claw_index] = FALSE
