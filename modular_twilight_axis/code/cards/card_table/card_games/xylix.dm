/datum/card_table_session/proc/xylix_tier(mob/user)
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !istype(H.patron, /datum/patron/divine/xylix) || !H.devotion)
		return -1
	return max(CLERIC_T0, min(CLERIC_T4, H.devotion.level))

/datum/card_table_session/proc/xylix_holy_skill(mob/user)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return 0
	return H.get_skill_level(/datum/skill/magic/holy)

/datum/card_table_session/proc/xylix_caught_chance(mob/user)
	var/mob/living/carbon/human/H = user
	var/skill = max(SKILL_LEVEL_NOVICE, xylix_holy_skill(user))
	var/chance = 70 - (skill * 10)
	if(istype(H))
		chance -= max(H.STALUC - 10, 0) * 2
	return clamp(chance, 5, 95)

/datum/card_table_session/proc/xylix_peek_count(mob/user)
	switch(xylix_tier(user))
		if(CLERIC_T0)
			return 1
		if(CLERIC_T1, CLERIC_T2)
			return 3
		if(CLERIC_T3, CLERIC_T4)
			return 5
	return 0

/datum/card_table_session/proc/xylix_opponent_chance(mob/user)
	switch(xylix_tier(user))
		if(CLERIC_T3)
			return 25
		if(CLERIC_T4)
			return 50
	return 0

/datum/card_table_session/proc/xylix_can_choose_card(mob/user)
	var/tier = xylix_tier(user)
	return tier >= CLERIC_T2 && user && user.ckey && !(user.ckey in xylix_cheat_used) && game_type == CARD_TABLE_GAME_BLACKJACK

/datum/card_table_session/proc/xylix_reveal_key(viewer_ckey, target_ckey)
	return "[viewer_ckey]|[target_ckey]"

/datum/card_table_session/proc/xylix_seen_for(viewer_ckey, target_ckey)
	var/key = xylix_reveal_key(viewer_ckey, target_ckey)
	var/list/seen = xylix_seen_cards[key]
	if(!islist(seen))
		seen = list()
		xylix_seen_cards[key] = seen
	return seen

/datum/card_table_session/proc/xylix_try_reveal_opponent_card(mob/user, datum/card_table_player/target)
	if(!user || !user.ckey || !target || target.left || target.ckey == user.ckey)
		return
	var/chance = xylix_opponent_chance(user)
	if(!chance || !prob(chance))
		return
	var/list/unseen = list()
	var/list/seen = xylix_seen_for(user.ckey, target.ckey)
	for(var/i = 1, i <= target.hand.len, i++)
		if(!(i in seen))
			unseen += i
	if(!unseen.len)
		return
	seen += pick(unseen)
	to_chat(user, span_notice("For a moment, Xylix shows you one of [target.name]'s cards."))

/datum/card_table_session/proc/xylix_try_reveal_for_turn_holder(datum/card_table_player/turn_holder)
	if(!turn_holder)
		return
	for(var/datum/card_table_player/player in players)
		if(player.left || player == turn_holder)
			continue
		var/mob/M = card_table_find_mob_by_ckey(player.ckey)
		xylix_try_reveal_opponent_card(M, turn_holder)

/datum/card_table_session/proc/xylix_check_exposure(mob/user)
	if(!user || !prob(xylix_caught_chance(user)))
		return FALSE
	var/msg = "[card_table_display_name(user)] is watching the deck a little too closely."
	for(var/datum/card_table_player/player in players)
		if(player.left)
			continue
		var/mob/M = card_table_find_mob_by_ckey(player.ckey)
		if(M && M != user)
			to_chat(M, span_warning(msg))
	for(var/ckey in observers)
		var/mob/O = card_table_find_mob_by_ckey(ckey)
		if(O && O != user)
			to_chat(O, span_warning(msg))
	to_chat(user, span_warning("Xylix's fingers slip. Someone may have noticed your cheating."))
	return TRUE
