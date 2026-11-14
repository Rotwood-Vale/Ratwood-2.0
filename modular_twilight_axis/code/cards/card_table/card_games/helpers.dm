/proc/card_table_display_name(mob/user)
	if(!user)
		return "Unknown"
	if(user.real_name)
		return user.real_name
	return user.name

/proc/card_table_find_mob_by_ckey(ckey)
	if(!ckey)
		return null
	for(var/client/C)
		if(C.ckey == ckey)
			return C.mob
	return null

/proc/card_table_card_label(list/card)
	if(!islist(card))
		return "?"
	return "[card["rank"]][card["suit"]]"

/proc/card_table_card_value(list/card)
	if(!islist(card))
		return 0
	return text2num("[card["value"]]")

/proc/card_table_card_rank_value(list/card)
	if(!islist(card))
		return 0
	return text2num("[card["rank_value"]]")

/proc/card_table_make_deck()
	var/list/deck = list()
	for(var/suit in list("H", "S", "C", "D"))
		deck += list(list("rank" = "A", "suit" = suit, "value" = 11, "rank_value" = 14))
		for(var/i in 2 to 10)
			deck += list(list("rank" = "[i]", "suit" = suit, "value" = i, "rank_value" = i))
		deck += list(list("rank" = "J", "suit" = suit, "value" = 10, "rank_value" = 11))
		deck += list(list("rank" = "Q", "suit" = suit, "value" = 10, "rank_value" = 12))
		deck += list(list("rank" = "K", "suit" = suit, "value" = 10, "rank_value" = 13))
	return shuffle(deck)
