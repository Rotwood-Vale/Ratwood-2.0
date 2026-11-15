/// Paid crime records are never part of the payable head_bounties list.
GLOBAL_LIST_EMPTY(castifico_penance_records)

/datum/castifico_penance_record
	var/subject_name
	var/list/crime_banners = list()
	var/paid_amount = 0
	var/remaining_duration = 0
	var/escaped = FALSE
	var/obj/item/clothing/neck/roguetown/collar/prisoner/active_collar

/datum/castifico_penance_record/Destroy()
	if(subject_name && GLOB.castifico_penance_records[subject_name] == src)
		GLOB.castifico_penance_records -= subject_name
	crime_banners = null
	active_collar = null
	return ..()

/proc/get_incomplete_penance_listings()
	var/list/entries = list()
	for(var/subject_name in GLOB.castifico_penance_records)
		var/datum/castifico_penance_record/record = GLOB.castifico_penance_records[subject_name]
		if(!istype(record) || QDELETED(record))
			continue
		for(var/banner in record.crime_banners)
			entries += "<b>REWARD CLAIMED &mdash; PENANCE INCOMPLETE</b><br>[banner]<br>"
	return jointext(entries, "")

/mob/living/proc/get_castifico_penance_record()
	if(!real_name)
		return
	var/datum/castifico_penance_record/record = GLOB.castifico_penance_records[real_name]
	if(istype(record) && !QDELETED(record))
		return record

/mob/living/proc/has_current_bounty()
	if(!real_name)
		return FALSE
	for(var/datum/bounty/bounty as anything in GLOB.head_bounties)
		if(!QDELETED(bounty) && (bounty.target == real_name || bounty.target_hidden == real_name))
			return TRUE
	return FALSE

/obj/structure/roguemachine/bounty
	name = "EXCIDIUM"
	desc = "Created by a fanatical sect of devout followers of Ravox, this machine sets bounties."
	icon = 'icons/roguetown/topadd/statue1.dmi'
	icon_state = "baldguy"
	density = FALSE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	max_integrity = 999999
	var/budget
	
/datum/bounty
	var/target
	var/target_hidden
	var/target_race
	var/gender
	var/target_body_type
	var/target_body
	var/target_body_prefix
	var/target_height
	var/target_voice
	var/target_voice_prefix
	var/target_hidden_voice
	var/target_hidden_voice_prefix
	var/amount
	var/reason
	var/employer

	/// Whats displayed when consulting the bounties
	var/banner
	///Is this a bandit bounty?
	var/bandit

/obj/structure/roguemachine/bounty/attack_hand(mob/user)

	if(!ishuman(user)) return

	// We need to check the user's bank account later
	var/mob/living/carbon/human/H = user

	// Main Menu
	var/list/choices = list("Consult Bounties", "Consult Unpaid Taxes", "Set Bounty", "Print List of Bounties", "Remove Bounty", "Collect Change")
	var/selection = input(user, "The Excidium listens", src) as null|anything in choices

	if(!Adjacent(user, src)) // User can move while selecting, sanity check
		return

	switch(selection)

		if("Consult Bounties")
			consult_bounties(H)

		if("Consult Unpaid Taxes")
			consult_unpaid_taxes(H)

		if("Set Bounty")
			set_bounty(H)

		if("Print List of Bounties")
			print_bounty_scroll(H)

		if("Remove Bounty")
			remove_bounty(H)

/obj/structure/roguemachine/bounty/attackby(obj/item/P, mob/user, params)

	if(!(ishuman(user))) return


///Shows all active bounties to the user.
/obj/structure/roguemachine/bounty/proc/consult_bounties(mob/living/carbon/human/user)
	var/bounty_found = FALSE
	var/consult_menu
	consult_menu += "<center>BOUNTIES<BR>"
	consult_menu += "--------------<BR>"
	for(var/datum/bounty/saved_bounty in GLOB.head_bounties)
		consult_menu += saved_bounty.banner
		bounty_found = TRUE
	var/incomplete_penance = get_incomplete_penance_listings()
	if(length(incomplete_penance))
		consult_menu += incomplete_penance
		bounty_found = TRUE

	if(bounty_found)
		var/datum/browser/popup = new(user, "BOUNTIES", "", 500, 300, src)
		popup.set_content(consult_menu)
		popup.open()
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(user_moved))
	else
		say("No bounties are currently active.")

/// Shows current poll-tax debts in the same consultation window as bounties.
/obj/structure/roguemachine/bounty/proc/consult_unpaid_taxes(mob/living/carbon/human/user)
	if(!user || !user.client || !Adjacent(user, src) || !SStreasury)
		return

	var/debt_found = FALSE
	var/consult_menu = "<center>UNPAID TAXES<BR>--------------<BR>"
	for(var/mob/living/owner in SStreasury.poll_tax_owed)
		if(QDELETED(owner))
			continue
		var/owed = SStreasury.poll_tax_owed[owner]
		if(owed <= 0)
			continue
		consult_menu += "[html_encode(owner.real_name)]: [owed] mammons<BR>"
		debt_found = TRUE

	if(debt_found)
		var/datum/browser/popup = new(user, "BOUNTIES", "", 500, 300, src)
		popup.set_content(consult_menu)
		popup.open()
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(user_moved))
	else
		say("No unpaid taxes are currently recorded.")

/// Closes the consultation window when its reader leaves the machine.
/obj/structure/roguemachine/bounty/proc/user_moved(mob/former_user)
	SIGNAL_HANDLER

	if(!istype(former_user))
		return

	if(Adjacent(former_user, src))
		return

	UnregisterSignal(former_user, COMSIG_MOVABLE_MOVED)
	former_user << browse(null, "window=BOUNTIES")

/obj/structure/roguemachine/bounty/proc/remove_bounty(mob/living/carbon/human/user)
	var/list/bounty_list = list()

	for(var/datum/bounty/removable_bounties in GLOB.head_bounties)
		if(removable_bounties.employer == user.real_name)
			bounty_list += removable_bounties.target

	if(!bounty_list.len)
		say("You have no active bounty listings to remove.")
		return

	var/target_name = input(user, "Whose name shall be struck from the wanted list?", src) as null|anything in bounty_list
	if(!target_name)
		return

	say("Removing [target_name] from bounty list...")

	for(var/datum/bounty/removing_bounty in GLOB.head_bounties)
		if(removing_bounty.target == target_name && user.real_name == removing_bounty.employer)
			GLOB.head_bounties -= removing_bounty
			scom_announce("The bounty posting on [target_name] has been removed.")
			message_admins("[ADMIN_LOOKUPFLW(user)] has removed the bounty on [ADMIN_LOOKUPFLW(target_name)]")
			return
	say("Error. Bounty no longer active.")

///Sets a bounty on a target player through user input.
///@param user: The player setting the bounty.
/obj/structure/roguemachine/bounty/proc/set_bounty(mob/living/carbon/human/user)
	var/list/eligible_players = list()

	if(user.mind.known_people.len)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.real_name in user.mind.known_people)
				eligible_players[H.real_name] = H
	else
		to_chat(user, span_warning("I don't know anyone."))
		return

	var/choice = input(user, "Whose name shall be etched on the wanted list?", src) as null|anything in eligible_players
	if(isnull(choice))
		say("No target selected.")
		return

	var/mob/living/carbon/human/target = eligible_players[choice]

	var/amount = input(user, "How many mammons shall be stained red for their demise?", src) as null|num
	if(isnull(amount))
		say("Invalid amount.")
		return
	if(amount < 100)
		say("Insufficient amount. Bounty must be at least 100 mammon.")
		return
	if(amount > 500)
		say("Insufficient amount. Bounties cannot be more than 500 mammon.")
		return

	// Has user a bank account?
	if(!SStreasury.has_account(user))
		say("You have no bank account.")
		return

	// Has user enough money?
	if(SStreasury.get_balance(user) < amount)
		say("Insufficient balance funds.")
		return

	var/reason = input(user, "For what sins do you summon the hounds of hell?", src) as null|text
	if(isnull(reason) || reason == "")
		say("No reason given.")
		return

	var/confirm = input(user, "Do you dare unleash this darkness upon the world? Your name will be known.", src) as null|anything in list("Yes", "No")
	if(isnull(confirm) || confirm == "No") return

	var/datum/fund/user_account = SStreasury.get_account(user)
	amount = round(amount)
	SStreasury.burn(user_account, amount, "bounty placement - [target.real_name]")

	var/race = target.dna.species
	var/gender = target.gender
	var/list/d_list = target.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, target, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, target, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, target, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")

	// Finally create bounty
	add_bounty(target.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, amount, FALSE, reason, user.real_name)

	//Announce it locally and on scomm
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	var/bounty_announcement = "The Excidium hungers for [target]."
	say(bounty_announcement)
	scom_announce(bounty_announcement)

	message_admins("[ADMIN_LOOKUPFLW(user)] has set a bounty on [ADMIN_LOOKUPFLW(target)] with the reason of: '[reason]'")

/proc/add_bounty(target_realname, race, gender, descriptor_height, descriptor_body, descriptor_voice, amount, bandit_status, reason, employer_name)
	var/datum/bounty/new_bounty = new /datum/bounty
	new_bounty.amount = amount
	new_bounty.target = target_realname
	new_bounty.bandit = bandit_status
	new_bounty.reason = html_encode(reason)
	new_bounty.employer = employer_name
	new_bounty.target_race = race
	new_bounty.target_height = LOWER_TEXT(descriptor_height)
	new_bounty.target_body = LOWER_TEXT(descriptor_body)
	if(descriptor_body == "Average" || descriptor_body == "Athletic")
		var/bro_unreal = "an "
		new_bounty.target_body_prefix = LOWER_TEXT(bro_unreal += descriptor_body)
	else
		var/bro_real = "a "
		new_bounty.target_body_prefix = LOWER_TEXT(bro_real += descriptor_body)
	if(descriptor_voice == "Ordinary" || descriptor_voice == "Androgynous")
		var/bro_unreal = "an "
		new_bounty.target_voice_prefix = LOWER_TEXT(bro_unreal += descriptor_voice)
	else
		var/bro_real = "a "
		new_bounty.target_voice_prefix = LOWER_TEXT(bro_real += descriptor_voice)
	if(gender == MALE)
		new_bounty.target_body_type = "masculine"
	else
		new_bounty.target_body_type = "feminine"
	compose_bounty(new_bounty)
	GLOB.head_bounties += new_bounty

/proc/add_bounty_noface(target_realname, race, gender, descriptor_height, descriptor_body, descriptor_voice, amount, bandit_status, reason, employer_name)
	var/datum/bounty/new_bounty_noface = new /datum/bounty
	new_bounty_noface.target_hidden = target_realname
	new_bounty_noface.amount = amount
	new_bounty_noface.target_race = race
	if(gender == MALE)
		new_bounty_noface.target_body_type = "masculine"
	else
		new_bounty_noface.target_body_type = "feminine"
	new_bounty_noface.target_height = LOWER_TEXT(descriptor_height)
	if(descriptor_body == "Average" || descriptor_body == "Athletic")
		var/bro_unreal = "an "
		new_bounty_noface.target_body_prefix = LOWER_TEXT(bro_unreal += descriptor_body)
	else
		var/bro_real = "a "
		new_bounty_noface.target_body_prefix = LOWER_TEXT(bro_real += descriptor_body)
	if(descriptor_voice == "Ordinary" || descriptor_voice == "Anrdogynous")
		var/bro_unreal = "an "
		new_bounty_noface.target_voice_prefix = LOWER_TEXT(bro_unreal += descriptor_voice)
	else
		var/bro_real = "a "
		new_bounty_noface.target_voice_prefix = LOWER_TEXT(bro_real += descriptor_voice)
	new_bounty_noface.target_voice = LOWER_TEXT(descriptor_voice)
	new_bounty_noface.target_body = LOWER_TEXT(descriptor_body)
	//new_bounty_noface.target_voice = LOWER_TEXT(descriptor_voice)
	new_bounty_noface.bandit = bandit_status
	new_bounty_noface.reason = reason
	new_bounty_noface.employer = employer_name
	//var/list/lines = build_cool_description(get_mob_descriptors(obscure_name, user), target)
	compose_bounty_noface(new_bounty_noface)
	GLOB.head_bounties += new_bounty_noface

/proc/add_bounty_obscure(target_realname, race, gender, descriptor_height, descriptor_body, descriptor_voice, amount, bandit_status, reason, employer_name)
	var/datum/bounty/new_bounty_obscure = new /datum/bounty
	new_bounty_obscure.target_hidden = target_realname
	new_bounty_obscure.amount = amount
	new_bounty_obscure.target_race = race
	if(gender == MALE)
		new_bounty_obscure.target_body_type = "masculine"
	else
		new_bounty_obscure.target_body_type = "feminine"
	new_bounty_obscure.target_height = LOWER_TEXT(descriptor_height)
	if(descriptor_body == "Average" || descriptor_body == "Athletic")
		var/bro_unreal = "an "
		new_bounty_obscure.target_body_prefix = LOWER_TEXT(bro_unreal += descriptor_body)
	else
		var/bro_real = "a "
		new_bounty_obscure.target_body_prefix = LOWER_TEXT(bro_real += descriptor_body)
	if(descriptor_voice == "Ordinary" || descriptor_voice == "Anrdogynous")
		var/bro_unreal = "an "
		new_bounty_obscure.target_hidden_voice_prefix = LOWER_TEXT(bro_unreal += descriptor_voice)
	else
		var/bro_real = "a "
		new_bounty_obscure.target_hidden_voice_prefix = LOWER_TEXT(bro_real += descriptor_voice)
	new_bounty_obscure.target_hidden_voice = LOWER_TEXT(descriptor_voice)
	new_bounty_obscure.target_body = LOWER_TEXT(descriptor_body)
	//new_bounty_obscure.target_voice = LOWER_TEXT(descriptor_voice)
	new_bounty_obscure.bandit = bandit_status
	new_bounty_obscure.reason = reason
	new_bounty_obscure.employer = employer_name
	//var/list/lines = build_cool_description(get_mob_descriptors(obscure_name, user), target)
	compose_bounty_obscure(new_bounty_obscure)
	GLOB.head_bounties += new_bounty_obscure

///Composes a random bounty banner based on the given bounty info.
///@param new_bounty:  The bounty datum.
/proc/compose_bounty(datum/bounty/new_bounty)
	switch(rand(1, 3))
		if(1)
			new_bounty.banner += "A dire bounty hangs upon the capture of [new_bounty.target], for '[new_bounty.reason]'.<BR>"
			new_bounty.banner += "They are a criminal belonging to the [new_bounty.target_race] race, going by the following description: they are [new_bounty.target_height], of a [new_bounty.target_body_type] build and they have [new_bounty.target_body_prefix] physique. They speak with [new_bounty.target_voice_prefix] voice.'.<BR>"
			new_bounty.banner += "The patron, [new_bounty.employer], offers [new_bounty.amount] mammons for the task.<BR>"
		if(2)
			new_bounty.banner += "The capture of [new_bounty.target] is wanted for '[new_bounty.reason]''.<BR>"
			new_bounty.banner += "They are a reprobate belonging to the [new_bounty.target_race] race, going by the following description: they are [new_bounty.target_height], of a [new_bounty.target_body_type] build and they have [new_bounty.target_body_prefix] physique. They speak with [new_bounty.target_voice_prefix] voice.'.<BR>"
			new_bounty.banner += "The employer, [new_bounty.employer], offers [new_bounty.amount] mammons for the deed.<BR>"
		if(3)
			new_bounty.banner += "[new_bounty.employer] hath offered to pay [new_bounty.amount] mammons for the capture of [new_bounty.target].<BR>"
			new_bounty.banner += "By reason of the following: '[new_bounty.reason]'.<BR>"
			new_bounty.banner += "They are a heathen belonging to the [new_bounty.target_race] race, going by the following description: they are [new_bounty.target_height], of a [new_bounty.target_body_type] build and they have [new_bounty.target_body_prefix] physique. They speak with [new_bounty.target_voice_prefix] voice.'.<BR>"
	new_bounty.banner += "--------------<BR>"

/proc/compose_bounty_noface(datum/bounty/new_bounty_noface)
	switch(rand(1, 3))
		if(1)
			new_bounty_noface.banner += "A dire bounty hangs upon the capture of an outlaw belonging to the [new_bounty_noface.target_race] race, going by the following description: they are [new_bounty_noface.target_height], of a [new_bounty_noface.target_body_type] build and they have [new_bounty_noface.target_body_prefix] physique. They speak with [new_bounty_noface.target_voice_prefix] voice. They are wanted for '[new_bounty_noface.reason]'.<BR>"
			new_bounty_noface.banner += "The patron, [new_bounty_noface.employer], offers [new_bounty_noface.amount] mammons for the task.<BR>"
		if(2)
			new_bounty_noface.banner += "The capture of a criminal of [new_bounty_noface.target_race] ancestry. This bounty been authorised by [new_bounty_noface.employer] for '[new_bounty_noface.reason]'. Their description is as follows: they are of a [new_bounty_noface.target_height] height, of a [new_bounty_noface.target_body_type] build, they have [new_bounty_noface.target_body_prefix] physique and they speak with [new_bounty_noface.target_voice_prefix] voice.<BR>"
			new_bounty_noface.banner += "The employer, [new_bounty_noface.employer], offers [new_bounty_noface.amount] mammons for the deed, they are to be brought in dead or alive.<BR>"
		if(3)
			new_bounty_noface.banner += "[new_bounty_noface.employer] hath offered to pay [new_bounty_noface.amount] mammons for the capture of a criminal of [new_bounty_noface.target_race] ancestry. They've been described to be of a [new_bounty_noface.target_height] stature with [new_bounty_noface.target_body_prefix] physique with a [new_bounty_noface.target_body_type] build. Their voice is [new_bounty_noface.target_voice].<BR>"
			new_bounty_noface.banner += "By reason of the following: '[new_bounty_noface.reason]'.<BR>"
	new_bounty_noface.banner += "--------------<BR>"

/proc/compose_bounty_obscure(datum/bounty/new_bounty_obscure)
	switch(rand(1, 3))
		if(1)
			new_bounty_obscure.banner += "A dire bounty hangs upon the capture of an outlaw belonging to the [new_bounty_obscure.target_race] race, going by the following description: they are [new_bounty_obscure.target_height], of a [new_bounty_obscure.target_body_type] build and they have [new_bounty_obscure.target_body_prefix] physique. They are wanted for '[new_bounty_obscure.reason]'.<BR>"
			new_bounty_obscure.banner += "The patron, [new_bounty_obscure.employer], offers [new_bounty_obscure.amount] mammons for the task.<BR>"
		if(2)
			new_bounty_obscure.banner += "The capture of a criminal of [new_bounty_obscure.target_race] ancestry. This bounty been authorised by [new_bounty_obscure.employer] for '[new_bounty_obscure.reason]'. Their description is as follows: they are of a [new_bounty_obscure.target_height] height, of a [new_bounty_obscure.target_body_type] build and they have [new_bounty_obscure.target_body_prefix] physique.<BR>"
			new_bounty_obscure.banner += "The employer, [new_bounty_obscure.employer], offers [new_bounty_obscure.amount] mammons for the deed, they are to be brought in dead or alive.<BR>"
		if(3)
			new_bounty_obscure.banner += "[new_bounty_obscure.employer] hath offered to pay [new_bounty_obscure.amount] mammons for the capture of a criminal of [new_bounty_obscure.target_race] ancestry. They've been described to be of a [new_bounty_obscure.target_height] stature with [new_bounty_obscure.target_body_prefix] physique with a [new_bounty_obscure.target_body_type] build.<BR>"
			new_bounty_obscure.banner += "By reason of the following: '[new_bounty_obscure.reason]'.<BR>"
	new_bounty_obscure.banner += "--------------<BR>"

/obj/structure/roguemachine/bounty/proc/print_bounty_scroll(mob/living/carbon/human/user)
	if(!length(GLOB.head_bounties) && !length(GLOB.castifico_penance_records))
		say("No bounties are currently active.")
		return

	var/cost = (user.job in GLOB.garrison_positions) ? 10 : 50
	var/choice = alert(user, "Print an enchanted list of bounties and incomplete penances for [cost] mammons?", "Print Bounty Scroll", "Yes", "No")
	if(choice != "Yes")
		return

	if(!SStreasury.has_account(user))
		say("You have no bank account.")
		return

	if(SStreasury.get_balance(user) < cost)
		say("Insufficient funds in account. [cost] mammons required.")
		return

	SStreasury.transfer(SStreasury.get_account(user), SStreasury.discretionary_fund, cost, "bounty scroll fee")

	var/obj/item/paper/scroll/bounty/scroll = new(get_turf(src))
	scroll.update_bounty_text()
	playsound(src, 'sound/items/scroll_open.ogg', 100, TRUE)
	visible_message(span_notice("The [src] prints out a weathered scroll."))
	say("Your scroll is ready.")

/obj/item/paper/scroll/bounty
	name = "enchanted bounty scroll"
	desc = "A weathered scroll enchanted to list the active bounties from the Excidium."
	icon_state = "scroll"
	open = FALSE

/obj/item/paper/scroll/bounty/examine(mob/user)
	. = ..()
	if(open)
		update_bounty_text()

/obj/item/paper/scroll/bounty/read(mob/user)
	update_bounty_text()
	return ..()

/obj/item/paper/scroll/bounty/proc/update_bounty_text()
	var/scroll_text = "<center>WANTED BY THE EXCIDIUM</center><br><br>"

	for(var/datum/bounty/saved_bounty in GLOB.head_bounties)
		scroll_text += saved_bounty.banner
		scroll_text += "<br>"
	scroll_text += get_incomplete_penance_listings()

	info = scroll_text

/obj/structure/chair/freedomchair
	name = "LIBERTAS"
	desc = "A modified collaring machine that safely removes Castifico collars. Right-click it with someone seated to remove their collar."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "evilchair"
	blade_dulling = DULLING_BASH
	color = "#F75D59"
	item_chair = null
	anchored = TRUE
	var/processing = FALSE
	var/mob/living/processing_subject
	var/break_after_use = FALSE

/obj/structure/chair/freedomchair/crafted
	desc = "A crafted collar-removal machine. It removes one Castifico collar before falling apart."
	break_after_use = TRUE

/obj/structure/chair/freedomchair/post_unbuckle_mob(mob/living/M)
	. = ..()
	if(processing_subject == M)
		processing_subject = null

/obj/structure/chair/freedomchair/attack_right(mob/living/carbon/human/A)
	. = ..()
	if(.)
		return
	if(!ishuman(A) || QDELETED(A) || !A.Adjacent(src) || A.incapacitated())
		return
	if(processing)
		to_chat(A, span_notice("A RECKONING IS ALREADY UNDERWAY. WAIT YOUR TURN."))
		return
	processing = TRUE
	remove_collar(A)
	if(!QDELETED(src))
		processing_subject = null
		processing = FALSE

/obj/structure/chair/freedomchair/proc/remove_collar(mob/living/carbon/human/A)
	var/mob/living/carbon/human/M = LAZYLEN(buckled_mobs) ? buckled_mobs[1] : null
	if(!ishuman(M) || QDELETED(M) || M.buckled != src)
		say("CANNOT BEGIN WITHOUT SUBJECT BUCKLED.")
		return
	var/obj/item/clothing/neck/roguetown/collar/prisoner/collar = M.get_item_by_slot(SLOT_NECK)
	if(!istype(collar))
		say("NO CURSED COLLAR FOUND. ABORT.")
		return
	processing_subject = M
	if(!do_after(A, 3 SECONDS, TRUE, M))
		return
	if(QDELETED(src) || QDELETED(A) || QDELETED(M) || QDELETED(collar))
		return
	if(processing_subject != M || M.buckled != src || !A.Adjacent(src) || A.incapacitated() || M.get_item_by_slot(SLOT_NECK) != collar)
		return
	var/datum/castifico_penance_record/record = collar.penance_record
	if(!M.dropItemToGround(collar, TRUE))
		say("COLLAR REMOVAL FAILED. TRY AGAIN.")
		return
	if(!QDELETED(record))
		record.escaped = TRUE
	playsound(src, 'sound/items/pickgood1.ogg', 50, TRUE, -1)
	say("COLLAR DISCARDED. FREEDOM, AT LAST...")
	unbuckle_mob(M, TRUE)
	if(!QDELETED(src) && break_after_use)
		visible_message(span_notice("[src] shudders and falls apart, its work complete."))
		qdel(src)

/obj/structure/chair/arrestchair
	name = "CASTIFICO"
	desc = "A bounty-processing chair. Right-click it with someone seated to clear their outstanding bounties and fit a temporary pacification collar. The collar prevents harmful attacks and blocks most spellcasting. Its duration depends on the bounty amount."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "evilchair"
	blade_dulling = DULLING_BASH
	item_chair = null
	anchored = TRUE
	var/processing = FALSE
	var/mob/living/processing_subject
	max_integrity = 999999

/obj/structure/chair/arrestchair/post_unbuckle_mob(mob/living/M)
	. = ..()
	// Leaving the seat invalidates this procedure even if the same person sits again.
	if(processing_subject == M)
		processing_subject = null

/obj/structure/chair/arrestchair/attack_right(mob/living/carbon/human/A)
	. = ..()
	if(.)
		return
	if(!ishuman(A) || QDELETED(A) || !A.Adjacent(src) || A.incapacitated())
		return
	if(processing)
		to_chat(A, span_notice("A RECKONING IS ALREADY UNDERWAY. WAIT YOUR TURN."))
		return
	if(HAS_TRAIT(A, TRAIT_OUTLAW))
		to_chat(A, span_warning("THE MACHINE WANTS YOU."))
		return
	processing = TRUE
	fit_collar(A)
	if(!QDELETED(src))
		processing_subject = null
		processing = FALSE

/obj/structure/chair/arrestchair/proc/get_subject_bounties(mob/living/carbon/human/M)
	var/list/matching_bounties = list()
	if(!M.real_name)
		return matching_bounties
	for(var/datum/bounty/bounty as anything in GLOB.head_bounties)
		if(!QDELETED(bounty) && (bounty.target == M.real_name || bounty.target_hidden == M.real_name))
			matching_bounties += bounty
	return matching_bounties

/obj/structure/chair/arrestchair/proc/get_subject_reward(mob/living/carbon/human/M, list/bounties)
	var/reward = 0
	for(var/datum/bounty/bounty as anything in bounties)
		reward += bounty.amount
	if(M.stat == DEAD)
		reward /= 2
	return reward

/obj/structure/chair/arrestchair/proc/fit_collar(mob/living/carbon/human/A)
	var/mob/living/carbon/human/M = LAZYLEN(buckled_mobs) ? buckled_mobs[1] : null
	if(!ishuman(M) || QDELETED(M) || M.buckled != src)
		say(ismob(M) ? "SUBJECT UNRECOGNIZED. RECKONING ABORTED." : "NO SUBJECT SEATED. NOTHING TO RECKON.")
		return
	var/list/bounties = get_subject_bounties(M)
	var/datum/castifico_penance_record/record = M.get_castifico_penance_record()
	if(!length(bounties) && !record)
		say("NO BOUNTY UPON THIS ONE. RELEASED.")
		unbuckle_mob(M, TRUE)
		return
	if(!M.get_bodypart(BODY_ZONE_HEAD))
		say("COLLAR CANNOT BE FITTED. RECKONING ABORTED.")
		return
	if(istype(M.get_item_by_slot(SLOT_NECK), /obj/item/clothing/neck/roguetown/collar/prisoner))
		say("THIS ONE ALREADY BEARS THEIR PENANCE.")
		return
	if(record && !QDELETED(record.active_collar))
		say("THIS ONE ALREADY BEARS THEIR PENANCE.")
		return
	processing_subject = M
	var/list/stage_messages = list("COMMENCING RECKONING...", "ASSESSING VALUE OF LYFE...", "PENANCE DECREED. PREPARING THE COLLAR...")
	var/list/stage_delays = list(4 SECONDS, 4 SECONDS, 4 SECONDS)
	for(var/stage in 1 to length(stage_messages))
		say(stage_messages[stage])
		if(!do_after(A, stage_delays[stage], TRUE, M))
			return
		if(QDELETED(src) || QDELETED(A) || QDELETED(M))
			return
		if(processing_subject != M || M.buckled != src || !A.Adjacent(src) || A.incapacitated() || HAS_TRAIT(A, TRAIT_OUTLAW) || !M.get_bodypart(BODY_ZONE_HEAD))
			return
	// Bounties may have been cleared or changed during preparation.
	bounties = get_subject_bounties(M)
	record = M.get_castifico_penance_record()
	if(!length(bounties) && !record)
		say("NO BOUNTY UPON THIS ONE. RELEASED.")
		unbuckle_mob(M, TRUE)
		return
	var/reward = get_subject_reward(M, bounties)
	if(record && !QDELETED(record.active_collar))
		say("THIS ONE ALREADY BEARS THEIR PENANCE.")
		return
	var/obj/item/old_neck_item = M.get_item_by_slot(SLOT_NECK)
	if(istype(old_neck_item, /obj/item/clothing/neck/roguetown/collar/prisoner))
		say("THIS ONE ALREADY BEARS THEIR PENANCE.")
		return
	if(old_neck_item && !M.dropItemToGround(old_neck_item, TRUE))
		say("COLLARING FAILED. THE BOUNTY REMAINS.")
		return
	// Inventory callbacks may have moved the occupant or changed their sentence.
	if(QDELETED(src) || QDELETED(A) || QDELETED(M) || processing_subject != M || M.buckled != src || !A.Adjacent(src) || A.incapacitated() || M.get_castifico_penance_record() != record)
		return
	bounties = get_subject_bounties(M)
	if(!length(bounties) && !record)
		say("NO BOUNTY UPON THIS ONE. RELEASED.")
		unbuckle_mob(M, TRUE)
		return
	if(record && !QDELETED(record.active_collar))
		return
	reward = get_subject_reward(M, bounties)
	var/obj/item/clothing/neck/roguetown/collar/prisoner/collar = new(get_turf(M))
	collar.bounty_amount = reward
	if(record)
		// Resume unserved time. Only newly claimed crimes can add to the sentence.
		collar.sentence_duration = record.remaining_duration + max(0, get_castifico_sentence_duration(record.paid_amount + reward) - get_castifico_sentence_duration(record.paid_amount))
	if(!M.equip_to_slot_or_del(collar, SLOT_NECK, TRUE))
		say("COLLARING FAILED. THE BOUNTY REMAINS.")
		return
	if(QDELETED(collar) || M.get_item_by_slot(SLOT_NECK) != collar)
		if(!QDELETED(collar))
			qdel(collar)
		say("COLLARING FAILED. THE BOUNTY REMAINS.")
		return
	// Commit the paid archive only after successful fitting; no delays precede payment.
	if(!record)
		record = new
		record.subject_name = M.real_name
	for(var/datum/bounty/claimed_bounty as anything in bounties)
		record.crime_banners += claimed_bounty.banner
	record.paid_amount += reward
	record.remaining_duration = max(1, collar.sentence_end_time - world.time)
	record.escaped = FALSE
	record.active_collar = collar
	collar.penance_record = record
	GLOB.castifico_penance_records[record.subject_name] = record
	GLOB.head_bounties -= bounties
	budget2change(reward)
	playsound(src, 'sound/items/pickgood1.ogg', 50, TRUE, -1)
	M.visible_message(span_notice("The Castifico fastens a collar around [M]'s neck."))
	say(length(bounties) ? "A BOUNTY HAS BEEN SATED." : "PENANCE RESUMED.")
	unbuckle_mob(M, TRUE)

/obj/structure/chair/arrestchair/proc/budget2change(budget, mob/user, specify)
	var/turf/T
	if(!user || (!ismob(user)))
		T = get_turf(src)
	else
		T = get_turf(user)
	if(!budget || budget <= 0)
		return
	budget = floor(budget)
	var/type_to_put
	var/zenars_to_put
	if(specify)
		switch(specify)
			if("GOLD")
				zenars_to_put = budget/10
				type_to_put = /obj/item/roguecoin/gold
			if("SILVER")
				zenars_to_put = budget/5
				type_to_put = /obj/item/roguecoin/silver
			if("BRONZE")
				zenars_to_put = budget
				type_to_put = /obj/item/roguecoin/copper
	else
		var/highest_found = FALSE
		var/zenars = floor(budget/10)
		if(zenars)
			budget -= zenars * 10
			highest_found = TRUE
			type_to_put = /obj/item/roguecoin/gold
			zenars_to_put = zenars
		zenars = floor(budget/5)
		if(zenars)
			budget -= zenars * 5
			if(!highest_found)
				highest_found = TRUE
				type_to_put = /obj/item/roguecoin/silver
				zenars_to_put = zenars
			else
				new /obj/item/roguecoin/silver(T, zenars)
		if(budget >= 1)
			if(!highest_found)
				type_to_put = /obj/item/roguecoin/copper
				zenars_to_put = budget
			else
				new /obj/item/roguecoin/copper(T, budget)
	if(!type_to_put || zenars_to_put < 1)
		return
	new type_to_put(T, floor(zenars_to_put))
	playsound(T, 'sound/misc/coindispense.ogg', 100, FALSE, -1)

/proc/has_bounty(mob/living/carbon/human/H)
	for (var/datum/bounty/existing_bounty in GLOB.head_bounties)
		if (existing_bounty.target == H.real_name)
			return TRUE

	return FALSE
