#define WHISPER_COOLDOWN 10 SECONDS
/obj/item/paper/scroll/quest
	name = "附魔契约卷轴"
	desc = "一份常被称作\"低语卷轴\"的卷轴。附有魔法，打开时会向持有者低声告知目标所在。\n\
	卷轴上的魔法防护使其难以被破坏或篡改。只有由契约持有人随身携带时，它才会低语。"
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "scroll_quest"
	var/base_icon_state = "scroll_quest"
	var/datum/quest/assigned_quest
	var/last_compass_direction = ""
	var/last_z_level_hint = ""
	var/last_whisper = 0 // Last time the scroll whispered to the user
	resistance_flags = FIRE_PROOF | LAVA_PROOF | INDESTRUCTIBLE | UNACIDABLE
	max_integrity = 1000
	armor = list("blunt" = 100, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 100, "acid" = 100)
	/// Weakref to the quest owner
	var/datum/weakref/quester_ref

/obj/item/paper/scroll/quest/Initialize(mapload)
	. = ..()
	if(assigned_quest)
		assigned_quest.quest_scroll = src
	update_quest_text()
	START_PROCESSING(SSprocessing, src)

/obj/item/paper/scroll/quest/Destroy()
	if(assigned_quest)
		// Return deposit if scroll is destroyed before completion
		if(!assigned_quest.complete)
			var/refund = assigned_quest.calculate_deposit()

			// First try to return to quest giver if available
			var/mob/giver = assigned_quest.quest_giver_reference?.resolve()
			if(giver && (giver in SStreasury.bank_accounts))
				SStreasury.bank_accounts[giver] += refund
				SStreasury.treasury_value -= refund
				SStreasury.log_entries += "-[refund] from treasury (contract scroll destroyed refund to giver [giver.real_name])"
			// Otherwise try quest receiver
			else if(assigned_quest.quest_receiver_reference)
				var/mob/receiver = assigned_quest.quest_receiver_reference.resolve()
				if(receiver && (receiver in SStreasury.bank_accounts))
					SStreasury.bank_accounts[receiver] += refund
					SStreasury.treasury_value -= refund
					SStreasury.log_entries += "-[refund] from treasury (contract scroll destroyed refund to receiver [receiver.real_name])"

		// Clean up the quest
		qdel(assigned_quest)
		assigned_quest = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/paper/scroll/quest/update_icon_state()
	if(open)
		icon_state = info ? "[base_icon_state]_info" : "[base_icon_state]"
	else
		icon_state = "[base_icon_state]_closed"


/obj/item/paper/scroll/quest/process()
	if(world.time > last_whisper + WHISPER_COOLDOWN)
		last_whisper = world.time
		target_whisper()

/obj/item/paper/scroll/quest/proc/target_whisper()
	if(!assigned_quest || assigned_quest.complete || !assigned_quest.quest_receiver_reference)
		return
	var/obj/itemloc = src.loc
	var/mob/quest_bearer = assigned_quest.quest_receiver_reference?.resolve()
	// I should refactor this out at some point
	if(!istype(itemloc, /mob/living))
		while(!istype(itemloc, /mob/living))
			if(isnull(itemloc))
				return
			itemloc = itemloc.loc
			if(istype(itemloc, /turf))
				return
	if(itemloc != quest_bearer)
		return
	if(open && quest_bearer)
		update_compass(quest_bearer)
		var/message = ""
		message = "[last_compass_direction]"
		if(last_z_level_hint)
			message += " ([last_z_level_hint])"
		to_chat(quest_bearer, span_info("卷轴低语着告诉你，目标位于 [message]。"))

/obj/item/paper/scroll/quest/examine(mob/user)
	. = ..()
	if(!assigned_quest)
		return
	if(!assigned_quest.quest_receiver_reference)
		. += span_notice("这份契约尚未被领取。打开它即可将其据为己有！")
	else if(assigned_quest.complete)
		. += span_notice("\n这份契约已经完成！把它带回告示板领取报酬。")
		. += span_info("\n把它放到账册旁边的标记区域。")
	else
		. += span_notice("\n这份契约仍在进行中。")

/obj/item/paper/scroll/quest/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(P.get_sharpness())
		to_chat(user, span_warning("这张附魔卷轴抗拒你撕毁它的尝试。"))
		return
	if(istype(P, /obj/item/paper)) // Prevent merging with other papers/scrolls
		to_chat(user, span_warning("魔法能量阻止你将它与其他卷轴合并。"))
		return
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!open)
			to_chat(user, span_warning("你得先打开卷轴。"))
			return
		if(!assigned_quest)
			to_chat(user, span_warning("这张契约卷轴不接受修改。"))
			return
	..()

/obj/item/paper/scroll/quest/fire_act(exposed_temperature, exposed_volume)
	return // Immune to fire

/obj/item/paper/scroll/quest/extinguish()
	return // No fire to extinguish

/obj/item/paper/scroll/quest/read(mob/user)
	refresh_compass(user)
	return ..()

/obj/item/paper/scroll/quest/attack_self(mob/user)
	. = ..()
	if(.)
		return

	// Only do claim logic if unclaimed
	if(!assigned_quest || assigned_quest.quest_receiver_reference)
		refresh_compass(user) // Refresh compass when opened by claimed user
		update_quest_text()
		return

	// Claim the quest
	assigned_quest.quest_receiver_reference = WEAKREF(user)
	assigned_quest.quest_receiver_name = user.real_name

	to_chat(user, span_notice("你将这份契约据为己有！"))
	update_quest_text()
	refresh_compass(user) // Update compass after claiming

/obj/item/paper/scroll/quest/proc/update_quest_text()
	if(!assigned_quest)
		return

	var/scroll_text = "<center>悬赏求助</center><br>"
	scroll_text += "<center><b>[assigned_quest.get_title()]</b></center><br><br>"
	scroll_text += "<b>发布者：</b> [assigned_quest.quest_giver_name ? "[assigned_quest.quest_giver_name]" : "佣兵公会"]。<br>"
	scroll_text += "<b>接取者：</b> [assigned_quest.quest_receiver_name ? assigned_quest.quest_receiver_name : "有缘者"]。<br>"
	scroll_text += "<b>类型：</b> [assigned_quest.quest_type] 契约。<br>"
	scroll_text += "<b>难度：</b> [assigned_quest.quest_difficulty]。<br><br>"

	if(last_compass_direction)
		scroll_text += "<b>方向：</b> 目标 [last_compass_direction]。 "
		if(last_z_level_hint)
			scroll_text += " ([last_z_level_hint])"
		scroll_text += "<br>"

	scroll_text += "<b>目标：</b> [assigned_quest.get_objective_text()]<br>"

	// Show progress if applicable
	if(assigned_quest.progress_required > 1)
		scroll_text += "<b>进度：</b> [assigned_quest.progress_current]/[assigned_quest.progress_required]<br>"

	scroll_text += "<b>地点：</b> [assigned_quest.get_location_text()]<br>"
	scroll_text += "<br><b>报酬：</b> 完成后可得 [assigned_quest.reward_amount] 玛门<br>"

	if(assigned_quest.complete)
		scroll_text += "<br><center><b>契约完成</b></center>"
		scroll_text += "<br><b>将此卷轴带回告示板领取报酬！</b>"
		scroll_text += "<br><i>把它放到账册旁边的标记区域。</i>"
	else
		scroll_text += "<br><i>卷轴中的魔法会随着你的进展自动更新。</i>"

	info = scroll_text
	update_icon()

/obj/item/paper/scroll/quest/proc/refresh_compass(mob/user)
	if(!assigned_quest || assigned_quest.complete)
		return FALSE

	// Update compass with precise directions
	update_compass(user)

	// Only update text if we have a valid direction
	if(last_compass_direction)
		update_quest_text()
		return TRUE

	return FALSE

/obj/item/paper/scroll/quest/proc/update_compass(mob/user)
	if(!assigned_quest || assigned_quest.complete)
		return

	var/turf/user_turf = user ? get_turf(user) : get_turf(src)
	if(!user_turf)
		last_compass_direction = "未检测到信号"
		last_z_level_hint = ""
		return

	// Reset compass values
	last_compass_direction = "正在搜寻目标……"
	last_z_level_hint = ""

	// Get target location from quest datum
	var/turf/target_turf = assigned_quest.get_target_location()
	if(!target_turf)
		last_compass_direction = "位置未知"
		last_z_level_hint = ""
		return

	// We want the target to know z level differences but verticality exists
	// We don't want to frustrate player by forcing them to track on the same z level
	// Especially cuz of how many transitions exist
	if(target_turf.z != user_turf.z)
		var/z_diff = abs(target_turf.z - user_turf.z)
		last_z_level_hint = target_turf.z > user_turf.z ? \
			"在你上方 [z_diff] 层" : \
			"在你下方 [z_diff] 层"

	// Calculate direction from user to target
	var/dx = target_turf.x - user_turf.x  // EAST direction
	var/dy = target_turf.y - user_turf.y  // NORTH direction
	var/distance = sqrt(dx*dx + dy*dy)

	// If very close, don't show direction
	if(distance <= 7)
		last_compass_direction = "就在附近"
		last_z_level_hint = ""
		return

	// Get precise direction text
	var/direction_text = get_precise_direction_between(user_turf, target_turf)
	if(!direction_text)
		direction_text = "方向不明"

	// Determine distance description
	var/distance_text
	switch(distance)
		if(0 to 14)
			distance_text = "非常靠近"
		if(15 to 40)
			distance_text = "接近"
		if(41 to 100)
			distance_text = ""
		if(101 to INFINITY)
			distance_text = "非常遥远"

	last_compass_direction = "[distance_text]，位于[direction_text]方向"
	if(!last_z_level_hint)
		last_z_level_hint = "与你处于同一层"

#undef WHISPER_COOLDOWN
