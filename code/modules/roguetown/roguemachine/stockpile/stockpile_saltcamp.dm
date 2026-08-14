#define SALT_CHANCE_MAX 300
#define SALT_CHANCE_DEFAULT_TOTAL 200
#define SALT_CHANCE_PERCENT(max_salt) (100/max_salt)
#define SALT_CHANCE_INTEREST_RATE (60 MINUTES) // time to reach max interest
#define SALT_CHANCE_INTEREST_DEFAULT (5)
#define SALT_CHANCE_INTEREST_MAX (10) // max interest mul factor

GLOBAL_LIST_EMPTY(saltminestockpilemachines)
GLOBAL_LIST_EMPTY(saltmineticketmachines)

/obj/structure/roguemachine/stockpile_saltcamp
	name = "XYLIX'S PENANCE"
	desc = "Xylix determines if we shall be granted freedom, or ignored for eternity."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "stockpile_vendor"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	obj_flags = INDESTRUCTIBLE

	var/list/salt_accounts = list()
	var/list/salt_accounts_timestamp = list()
	var/list/salt_accounts_interest_max = list()
	var/list/salt_accounts_max = list()
	var/list/salt_ticket_win = list()

	var/salt_spent_on_gambling = 0
	var/gambling_active = FALSE

	var/salt_chance_default = SALT_CHANCE_DEFAULT_TOTAL
	var/interest_rate_default = SALT_CHANCE_INTEREST_DEFAULT

/obj/structure/roguemachine/stockpile_saltcamp/Initialize(mapload)
	. = ..()
	GLOB.saltminestockpilemachines += src

/obj/structure/roguemachine/stockpile_saltcamp/Destroy()
	GLOB.saltminestockpilemachines -= src
	salt_accounts = null
	salt_accounts_timestamp = null
	salt_accounts_interest_max = null
	salt_accounts_max = null
	salt_ticket_win = null
	return ..()

/obj/structure/roguemachine/stockpile_saltcamp/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_DUNGEONMASTER_LABOR_CAMP))
		. += span_info("The winning tickets from the machine are [span_boldwarning("highly")] sought after as collector items.")
	else
		. += span_info("Right click to deposit all the salt in front of the machine.")

/obj/structure/roguemachine/stockpile_saltcamp/proc/get_salt_interest(mob/user)
	if(!user || !ishuman(user))
		return 0
	var/mob/living/carbon/human/H = user

	var/target_name = H.real_name
	for(var/X in salt_accounts) // already got an account
		if(X == target_name)
			return CLAMP(world.time - salt_accounts_timestamp[X], 1, SALT_CHANCE_INTEREST_RATE) / SALT_CHANCE_INTEREST_RATE * salt_accounts_interest_max[target_name]

	salt_accounts += target_name // make account
	salt_accounts[target_name] = 0
	salt_accounts_timestamp += target_name
	salt_accounts_timestamp[target_name] = world.time
	salt_accounts_interest_max += target_name
	salt_accounts_interest_max[target_name] = interest_rate_default
	salt_accounts_max += target_name
	salt_accounts_max[target_name] = salt_chance_default
	salt_ticket_win += target_name
	salt_ticket_win[target_name] = 0

	return 0

/obj/structure/roguemachine/stockpile_saltcamp/proc/reset_salt_timestamp(mob/user, didwewinaticket = FALSE)
	if(!user || !ishuman(user))
		return 0
	var/mob/living/carbon/human/H = user

	var/target_name = H.real_name
	for(var/X in salt_accounts) // already got an account
		if(X == target_name)
			salt_accounts_timestamp[target_name] = world.time
			if(didwewinaticket)
				salt_ticket_win[target_name] += 1
			return

	salt_accounts += target_name // make account
	salt_accounts[target_name] = 0
	salt_accounts_timestamp += target_name
	salt_accounts_timestamp[target_name] = world.time
	salt_accounts_interest_max += target_name
	salt_accounts_interest_max[target_name] = SALT_CHANCE_INTEREST_DEFAULT
	salt_accounts_max += target_name
	salt_accounts_max[target_name] = SALT_CHANCE_DEFAULT_TOTAL
	salt_ticket_win += target_name
	salt_ticket_win[target_name] = 0

/obj/structure/roguemachine/stockpile_saltcamp/proc/get_salt_balance(mob/user)
	if(!user || !ishuman(user))
		return 0
	var/mob/living/carbon/human/H = user

	var/target_name = H.real_name
	for(var/X in salt_accounts) // already got an account
		if(X == target_name)
			var/balance = salt_accounts[X]
			var/interest = CLAMP(world.time - salt_accounts_timestamp[X], 1, SALT_CHANCE_INTEREST_RATE) / SALT_CHANCE_INTEREST_RATE * salt_accounts_interest_max[target_name]
			return balance * (1 + interest)

	salt_accounts += target_name // make account
	salt_accounts[target_name] = 0
	salt_accounts_timestamp += target_name
	salt_accounts_timestamp[target_name] = world.time
	salt_accounts_interest_max += target_name
	salt_accounts_interest_max[target_name] = interest_rate_default
	salt_accounts_max += target_name
	salt_accounts_max[target_name] = salt_chance_default
	salt_ticket_win += target_name
	salt_ticket_win[target_name] = 0

	return salt_accounts[target_name]

/obj/structure/roguemachine/stockpile_saltcamp/proc/get_salt_max(mob/user)
	if(!user || !ishuman(user))
		return 0
	var/mob/living/carbon/human/H = user

	var/target_name = H.real_name
	for(var/X in salt_accounts) // already got an account
		if(X == target_name)
			return salt_accounts_max[target_name]

	salt_accounts += target_name // make account
	salt_accounts[target_name] = 0
	salt_accounts_timestamp += target_name
	salt_accounts_timestamp[target_name] = world.time
	salt_accounts_interest_max += target_name
	salt_accounts_interest_max[target_name] = interest_rate_default
	salt_accounts_max += target_name
	salt_accounts_max[target_name] = salt_chance_default
	salt_ticket_win += target_name
	salt_ticket_win[target_name] = 0

	return salt_accounts_max[target_name]

/obj/structure/roguemachine/stockpile_saltcamp/proc/add_salt_balance(mob/user, amt = 0)
	if(!user || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	var/target_name = H.real_name
	for(var/X in salt_accounts) // already got an account
		if(X == target_name)
			salt_accounts[X] += amt
			if(salt_accounts[X] < 0)
				salt_accounts[X] = 0
			return

	salt_accounts += target_name // make account
	salt_accounts[target_name] = amt
	salt_accounts_timestamp += target_name
	salt_accounts_timestamp[target_name] = world.time
	salt_accounts_interest_max += target_name
	salt_accounts_interest_max[target_name] = interest_rate_default
	salt_accounts_max += target_name
	salt_accounts_max[target_name] = salt_chance_default
	salt_ticket_win += target_name
	salt_ticket_win[target_name] = 0

/obj/structure/roguemachine/stockpile_saltcamp/proc/set_salt_balance(mob/user, amt = 0)
	if(!user || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	var/target_name = H.real_name
	for(var/X in salt_accounts) // already got an account
		if(X == target_name)
			salt_accounts[X] = amt
			return

	salt_accounts += target_name // make account
	salt_accounts[target_name] = amt
	salt_accounts_timestamp += target_name
	salt_accounts_timestamp[target_name] = world.time
	salt_accounts_interest_max += target_name
	salt_accounts_interest_max[target_name] = interest_rate_default
	salt_accounts_max += target_name
	salt_accounts_max[target_name] = salt_chance_default
	salt_ticket_win += target_name
	salt_ticket_win[target_name] = 0

/obj/structure/roguemachine/stockpile_saltcamp/proc/get_odds_of_winning(mob/user)
	var/balance = get_salt_balance(user)
	var/max_salt = get_salt_max(user)
	if(balance >= max_salt)
		return 100
	
	balance *= SALT_CHANCE_PERCENT(max_salt)
	return balance

/obj/structure/roguemachine/stockpile_saltcamp/proc/get_interest_string(mob/user)
	var/interest = get_salt_interest(user)
	if(interest <= 0)
		return "<font color='#f54646'>0%</font>"
	interest = round(interest/1,0.01)*100
	var/string
	if(interest < 10)
		string = "<font color='#f54646'>"
	else if(interest < 20)
		string = "<font color='#f36c6c'>"	
	else if(interest < 40)
		string = "<font color='#f5b546'>"
	else if(interest < 60)
		string = "<font color='#cff546'>"
	else if(interest < 80)
		string = "<font color='#acf546'>"
	else if(interest < 100)
		string = "<font color='#4ff546'>"
	else
		string = "<font color='#4ff546'>"
	string += "[interest]%</font>"
	return string

/obj/structure/roguemachine/stockpile_saltcamp/proc/get_odds_of_winning_string(mob/user)
	var/balance = get_odds_of_winning(user)
	var/string
	if(balance <= 0)
		return "<font color='#f54646'>[pick("NO CHANCE", "NO SALT, NO CHANCE", "FOOL, MINE SOME SALT!", "GO MINE, YOU DULLARD!")]</font>"
	else if(balance < 10)
		string = "<font color='#f54646'>"
	else if(balance < 20)
		string = "<font color='#f36c6c'>"	
	else if(balance < 40)
		string = "<font color='#f5b546'>"
	else if(balance < 60)
		string = "<font color='#cff546'>"
	else if(balance < 80)
		string = "<font color='#acf546'>"
	else if(balance < 100)
		string = "<font color='#4ff546'>"
	else
		return "<font color='#4ff546'>[pick("WHY ARE YOU STILL HERE?!", "YOU ARE A SHAMEFUL FOOL!", "ARE YOU COMPENSATING?", "PLEASE, GO OUTSIDE!", "DID THEY FORGET YOU!?")]</font>"
	string += "[round(balance,0.5)]%</font>"
	return string

/obj/structure/roguemachine/stockpile_saltcamp/proc/roll_for_ticket(mob/user)
	gambling_active = TRUE
	playsound(src, 'sound/misc/letsgogambling.ogg', 100, FALSE, -1)
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+1, time = 1)
	animate(pixel_x = oldx-1, time = 1)
	animate(pixel_x = oldx, time = 1)
	sleep(50)
	var/prob_of_winning = get_odds_of_winning(user)
	if(prob_of_winning >= 100 || prob(prob_of_winning)) // we won!
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		gambling_active = FALSE
		return TRUE
	playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
	gambling_active = FALSE
	return FALSE

/obj/structure/roguemachine/stockpile_saltcamp/Topic(href, href_list)
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	if(gambling_active)
		return
	switch(href_list["task"])
		if("roll")
			var/current_balance = get_salt_balance(usr)
			if(current_balance <= 0)
				src.say(pick("Eager fool; you need salt to gamble for freedom.", "You are missing your salt.", "A criminal without salt is no criminal at all.", "To play the game, you must first salt the ground."))
				return
			close_ui(usr)
			src.say("Bow to Xylix and shall luck bless you.")
			if(!roll_for_ticket(usr)) // if we lost the game (like you just did lol), add to spent counter and reset account back to zero
				salt_spent_on_gambling += current_balance
				set_salt_balance(usr, 0)
				src.say(pick("Better luck next tyme, criminal.", "You've lost! May your tears aid your rock culling.", "Such folly, better luck next tyme!", "Ha-ha! You salt drinker, never had a chance to win!"))
				return
			set_salt_balance(usr, 0)
			src.say("Oh lookie here, we have ourselves a winner!!")
			playsound(src, 'sound/misc/triumph_win_twnn.ogg', 100, FALSE, -1)
			var/obj/item/detroyt_toll/ive_got_a_golden_ticket = new /obj/item/detroyt_toll(get_turf(src))
			if(!ive_got_a_golden_ticket) // something something went very very wrong... refund player
				set_salt_balance(usr, current_balance)
				return
			reset_salt_timestamp(usr, TRUE) // reset their interest progress
			ive_got_a_golden_ticket.sellprice = round(rand(current_balance, current_balance*3), 1) // set the value between salt spent on gambling for ticket, and three times
			if(!usr.put_in_hands(ive_got_a_golden_ticket))
				ive_got_a_golden_ticket.forceMove(get_turf(src))

/obj/structure/roguemachine/stockpile_saltcamp/proc/close_ui(mob/living/user)
	if(!user?.mind?.current)
		return
	user.mind.current << browse(null, "window=saltcamp")

/obj/structure/roguemachine/stockpile_saltcamp/attack_hand(mob/living/user, menu_name)
	. = ..()
	if(.)
		return
	if(gambling_active)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)

	var/contents = "<center>FEED THE MACHINE - WIN YOUR <font color='#ab8000'>FREEDOM</font><BR>"
	contents += "----------<BR>"
	contents += "DEPOSIT SALT TO INCREASE LUCK<BR>"
	contents += "CURRENT INTEREST RATE: [get_interest_string(user)]<BR>"
	contents += "CURRENT ODDS: [get_odds_of_winning_string(user)]<BR>"
	contents += "----------<BR>"
	contents += "<a href='?src=[REF(src)];task=roll'>(ROLL FOR FREEDOM)</a><BR>"
	contents += "</center>"

	var/datum/browser/popup = new(user, "saltcamp", "", 500, 500)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/stockpile_saltcamp/proc/attemptsell(obj/item/reagent_containers/powder/salt/I, mob/H, message = TRUE, sound = TRUE)
	if(!istype(I))
		return FALSE
	qdel(I)
	add_salt_balance(H, 1)
	if(sound == TRUE)
		playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	if(message == TRUE)
		say("Salt has been deposited. Your chances are now [round(get_odds_of_winning(H),0.5)]% of winning.")
	return TRUE

/obj/structure/roguemachine/stockpile_saltcamp/attackby(obj/item/P, mob/user, params)
	if(gambling_active)
		return FALSE
	if(ishuman(user))
		if(istype(P, /obj/item/reagent_containers/powder/salt))
			attemptsell(P, user, TRUE, TRUE)
			return FALSE
	. = ..()

/obj/structure/roguemachine/stockpile_saltcamp/attack_right(mob/user)
	if(gambling_active)
		return
	if(ishuman(user))
		var/found_salt = FALSE
		for(var/obj/I in get_turf(src))
			found_salt |= attemptsell(I, user, FALSE, FALSE)
		if(found_salt)
			say("Salt has been deposited. Your chances are now [round(get_odds_of_winning(user),0.5)]% of winnings.")
		playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/ticket_manager
	name = "Ticket Manager Deluxe"
	desc = "This machine controls the punishment for victims of the salt mines."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "submit"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	obj_flags = INDESTRUCTIBLE
	var/out_of_service = FALSE
	var/datum/weakref/stockpile_ref = null

/obj/structure/roguemachine/ticket_manager/proc/does_name_exist(obj/structure/roguemachine/stockpile_saltcamp/stockpile, name_to_check)
	var/total_accounts = length(stockpile.salt_accounts)
	for(var/i = 1; i <= total_accounts; i++)
		if(stockpile.salt_accounts[i] == name_to_check)
			return TRUE
	return FALSE

/obj/structure/roguemachine/ticket_manager/Topic(href, href_list)
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	var/obj/structure/roguemachine/stockpile_saltcamp/stockpile = null
	if(!out_of_service)
		if(stockpile_ref)
			stockpile = stockpile_ref.resolve()
			if(QDELETED(stockpile) || !istype(stockpile)) // machine doesn't exist
				out_of_service = TRUE
		else
			stockpile = locate(/obj/structure/roguemachine/stockpile_saltcamp) in GLOB.saltminestockpilemachines // we're assuming there is only ever one of these machines in the world
			if(stockpile)
				stockpile_ref = WEAKREF(stockpile)
			else
				out_of_service = TRUE
	if(out_of_service || !stockpile) // aka there isn't any other machine in this world
		say("Sorry, machine out of service!")
		return
	switch(href_list["task"])
		if("withdraw")
			var/amount = round(stockpile.salt_spent_on_gambling, 1)
			if(amount > 0)
				budget2change(amount, usr)
				stockpile.salt_spent_on_gambling = 0
		if("set_salt")
			var/name = href_list["name"]
			if(!does_name_exist(stockpile, name)) // sanity check name argument
				return
			var/new_max = input(usr, "Set the maximum salt needed to assure a 100% win", src, stockpile.salt_accounts_max[name]) as null
			if(!isnum(new_max))
				return
			new_max = round(new_max, 1)
			if(new_max < 10)
				to_chat(usr, span_danger("You cannot set to a value lower than 10!"))
				return
			if(new_max > SALT_CHANCE_MAX)
				to_chat(usr, span_danger("You cannot set to a value higher than [SALT_CHANCE_MAX]!"))
				return
			stockpile.salt_accounts_max[name] = new_max
		if("set_salt_default")
			var/new_max = input(usr, "Set the maximum salt needed to assure a 100% win", src, stockpile.salt_chance_default) as null
			if(!isnum(new_max))
				return
			new_max = round(new_max, 1)
			if(new_max < 10)
				to_chat(usr, span_danger("You cannot set to a value lower than 10!"))
				return
			if(new_max > SALT_CHANCE_MAX)
				to_chat(usr, span_danger("You cannot set to a value higher than [SALT_CHANCE_MAX]!"))
				return
			stockpile.salt_chance_default = new_max
		if("set_interest")
			var/name = href_list["name"]
			if(!does_name_exist(stockpile, name)) // sanity check name argument
				return
			var/new_max = input(usr, "Set the maximum interest rate percentage (1 hour for max interest)", src, stockpile.salt_accounts_interest_max[name] * 100) as null
			if(!isnum(new_max))
				return
			new_max = round(new_max, 1)
			if(new_max < 0)
				to_chat(usr, span_danger("You cannot set to a value lower than 0%!"))
				return
			if(new_max > SALT_CHANCE_INTEREST_MAX * 100)
				to_chat(usr, span_danger("You cannot set to a value higher than [SALT_CHANCE_INTEREST_MAX * 100]%!"))
				return
			stockpile.salt_accounts_interest_max[name] = new_max / 100
		if("set_interest_default")
			var/new_max = input(usr, "Set the maximum interest rate percentage (1 hour for max interest)", src, stockpile.interest_rate_default * 100) as null
			if(!isnum(new_max))
				return
			new_max = round(new_max, 1)
			if(new_max < 0)
				to_chat(usr, span_danger("You cannot set to a value lower than 0%!"))
				return
			if(new_max > SALT_CHANCE_INTEREST_MAX * 100)
				to_chat(usr, span_danger("You cannot set to a value higher than [SALT_CHANCE_INTEREST_MAX * 100]%!"))
				return
			stockpile.interest_rate_default = new_max / 100
		if("reset_interest")
			var/name = href_list["name"]
			if(!does_name_exist(stockpile, name)) // sanity check name argument
				return
			var/answer = tgui_alert(usr, "Reset [name]'s interest progression to 0%?", "Please answer in [DisplayTimeText(100)]", list("Yes", "Cancel"), 100)
			if(!answer || answer != "Yes")
				return
			stockpile.salt_accounts_timestamp[name] = world.time
	return attack_hand(usr)

/obj/structure/roguemachine/ticket_manager/attack_hand(mob/living/user, menu_name)
	. = ..()
	if(.)
		return
	var/obj/structure/roguemachine/stockpile_saltcamp/stockpile = null
	if(!out_of_service)
		if(stockpile_ref)
			stockpile = stockpile_ref.resolve()
			if(QDELETED(stockpile) || !istype(stockpile)) // machine doesn't exist
				out_of_service = TRUE
		else
			stockpile = locate(/obj/structure/roguemachine/stockpile_saltcamp) in GLOB.saltminestockpilemachines // we're assuming there is only ever one of these machines in the world
			if(stockpile)
				stockpile_ref = WEAKREF(stockpile)
			else
				out_of_service = TRUE
	if(out_of_service) // aka there isn't any other machine in this world
		say("Sorry, machine out of service!")
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)

	var/gambled_salt = round(stockpile.salt_spent_on_gambling, 1)
	var/total_accounts = length(stockpile.salt_accounts)
	var/contents = "<center>SALT MANAGER DELUXE<BR>"
	contents += "Where tears become fears<BR>"
	contents += "----------<BR>"
	contents += "SALT GAMBLED AWAY: [gambled_salt]<BR>"
	if(gambled_salt > 0)
		contents += "<a href='?src=[REF(src)];task=withdraw'>(WITHDRAW GAMBLED SALT AS COINS)</a><BR>"
	contents += "Salt Mined Max Default: <a href='?src=[REF(src)];task=set_salt_default;'>[stockpile.salt_chance_default]</a> | Interest Rate Default: <a href='?src=[REF(src)];task=set_interest_default;'>[stockpile.interest_rate_default * 100]%</a><BR>"
	contents += "</center>"
	if(total_accounts > 0)
		contents += "<hr><BR>"
		contents += "<table><tr><th>Prisoner Name</th><th>Salt Mined</th><th>Interest Rate</th></tr>"
		for(var/i = 1; i <= total_accounts; i++)
			var/name = stockpile.salt_accounts[i]
			var/salt = stockpile.salt_accounts[name]
			var/salt_max = stockpile.salt_accounts_max[name]
			var/interest = stockpile.salt_accounts_interest_max[name] * 100
			if(salt == 0 && stockpile.salt_ticket_win[name] > 0) // don't show ticket winners who have left the mines
				continue
			contents += "<tr><td>[name]</td>"
			contents += "<td>[salt] salt / <a href='?src=[REF(src)];task=set_salt;name=[name]'>[salt_max] max</a></td>"
			contents += "<td><a href='?src=[REF(src)];task=set_interest;name=[name]'>[interest]%</a> "
			contents += "(<a href='?src=[REF(src)];task=reset_interest;name=[name]'>reset progress</a>)</td></tr>"
		contents += "</table>"

	var/datum/browser/popup = new(user, "saltmanager", "", 800, 500)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/ticket_master
	name = "Ticket Slide"
	desc = "Only ticket winners may get to ride the sorrid slide to freedom. Looks like it will strip whoever passes through."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "headeater"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	obj_flags = INDESTRUCTIBLE
	var/out_of_service = FALSE
	var/obj/structure/roguemachine/ticket_master/slide_other_end = null
	var/gid

/obj/structure/roguemachine/ticket_master/Initialize(mapload)
	. = ..()
	GLOB.saltmineticketmachines += src

/obj/structure/roguemachine/ticket_master/Destroy()
	GLOB.saltmineticketmachines -= src
	if(!out_of_service && slide_other_end)
		slide_other_end.slide_other_end = null
		slide_other_end.out_of_service = TRUE
	..()

/obj/structure/roguemachine/ticket_master/attack_hand(mob/living/user, menu_name)
	. = ..()
	if(.)
		return
	if(out_of_service) // aka the mapper forgot to link the other machine
		say("Sorry, slide out of service!")
	else
		say("You must first earn your freedom with the ticket.")

/obj/structure/roguemachine/ticket_master/attackby(obj/item/P, mob/user, params)
	if(!out_of_service && !slide_other_end)
		for(var/obj/structure/roguemachine/ticket_master/O in GLOB.saltmineticketmachines)
			if(O.gid == gid && src != O)
				slide_other_end = O
				O.slide_other_end = src
		if(!slide_other_end)
			out_of_service = TRUE
	if(out_of_service) // aka the mapper forgot to link the other machine
		say("Sorry, slide out of service!")
		return ..()
	if(ishuman(user))
		var/mob/living/carbon/human/winner = user
		if(istype(P, /obj/item/detroyt_toll))
			if(winner.buckled) // don't stay remote-buckled
				winner.buckled.unbuckle_mob(winner, TRUE)
			var/turf/T = get_turf(slide_other_end)
			if(T)
				playsound(src, 'sound/misc/disposalflush.ogg', 50, FALSE, -1)
				playsound(slide_other_end, 'sound/misc/disposalflush.ogg', 50, FALSE, -1)
				for(var/obj/item/W in winner)
					if(W == P) // don't drop ticket
						continue
					if(istype(W, /obj/item/undies)) // let them keep their modesty
						continue
					if(HAS_TRAIT(W, TRAIT_NO_SELF_UNEQUIP) || HAS_TRAIT(W, TRAIT_NODROP) || HAS_TRAIT(W, CURSED_ITEM_TRAIT))
						continue
					winner.dropItemToGround(W)
				winner.regenerate_icons()
				if(do_teleport(winner, T, channel = TELEPORT_CHANNEL_FREE, forced = TRUE))
					winner.Paralyze(5 SECONDS, ignore_canstun = TRUE)
					to_chat(winner, span_danger("You are instantly sucked into the slide!"))
				else
					to_chat(winner, span_danger("Something stops you from being pulled into the slide!"))
		else
			say("You must first earn your freedom with the ticket.")
		return FALSE
	. = ..()

#undef SALT_CHANCE_MAX
#undef SALT_CHANCE_DEFAULT_TOTAL
#undef SALT_CHANCE_PERCENT
#undef SALT_CHANCE_INTEREST_RATE
#undef SALT_CHANCE_INTEREST_DEFAULT
#undef SALT_CHANCE_INTEREST_MAX
