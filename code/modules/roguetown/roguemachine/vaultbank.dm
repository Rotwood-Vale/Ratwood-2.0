/obj/structure/roguemachine/vaultbank
	name = "\improper JAWBANK"
	desc = "Collects and secures the treasury of the Grand Duchy of the realm."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "jawbank"
	density = TRUE
	blade_dulling = DULLING_BASH
	obj_flags = CAN_BE_HIT
	animate_dmg = TRUE
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	var/drilling = FALSE
	var/has_reported = FALSE
	var/drilltime = 0
	var/og_treasury
	var/total_extorted = 0
	var/shaker = FALSE
	var/whineline = 0
	var/anguish = 0
	var/feedme = 0
	var/knockitoff = 0
	var/knockedoffbefore = 0
	var/drillgoal = 100

/obj/structure/roguemachine/vaultbank/update_icon()
	if(drilling)
		return
	if(!SStreasury.treasury_value)
		icon_state = "[initial(icon_state)]_empty"
	else
		icon_state = initial(icon_state)

	..()

/obj/structure/roguemachine/vaultbank/proc/feedme(obj/structure/roguemachine/vaultbank)
	feedme = rand(1,12)

	if(!prob(50))
		return

	switch(feedme)
		if(1)
			src.say("MORE. MORE. MORE.")
		if(2)
			src.say("I WILL KEEP IT SAFE.")
		if(3)
			src.say("I WILL TREASURE THAT.")
		if(4)
			src.say("MORE FOR THE DUCHY. MORE FOR ME.")
		if(5)
			src.say("TENS, HUNDREDS, THOUSANDS.")
		if(6)
			src.say("THERE IS NO SAFER PLACE FOR IT.")
		if(7)
			src.say("I'M AROUND YOUR BEST INTEREST.")
		if(8)
			src.say("IT WILL NEVER BE ENOUGH.")
		if(9)
			src.say("ANOTHER HANDFUL. ANOTHER ZENNY.")
		if(10)
			src.say("A LITTLE RICHER. NONE THE POORER.")
		if(11)
			src.say("EARNINGS SAVED. EARNINGS GIVEN.")
		else
			src.say("YOUR TREASURED TREASURY. ALWAYS SAFE WITH ME.")
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)


/obj/structure/roguemachine/vaultbank/proc/whine(obj/structure/roguemachine/vaultbank)
	whineline = rand(1,12)

	if(!prob(50))
		return

	switch(whineline)
		if(1)
			src.say("YOU SWING LIKE A PAUPER.")
		if(2)
			src.say("I AM TELLING THE NERVEMASTER.")
		if(3)
			src.say("THEY'LL HEAR YOU.")
		if(4)
			src.say("STOP THAT.")
		if(5)
			src.say("THAT IS THE DUCHY'S COIN.")
		if(6)
			src.say("YOU LOWLYFE.")
		if(7)
			src.say("THAT'S NOT YOURS.")
		if(8)
			src.say("THIS ISN'T A PROPER WITHDRAWAL.")
		if(9)
			src.say("I AM INSURED FOR THIS. ARE YOU?")
		if(10)
			src.say("YOU WON'T BREAK THIS BANK.")
		if(11)
			src.say("KEEP TRYING.")
		else
			src.say("QUIT IT.")
	playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/vaultbank/proc/anguish(obj/structure/roguemachine/vaultbank)
	anguish = rand(1,12)

	if(!prob(50))
		return

	switch(anguish)
		if(1)
			src.say("NO MORE OF THIS.")
		if(2)
			src.say("GIVE IT UP.")
		if(3)
			src.say("THE TREASURY REMAINS.")
		if(4)
			src.say("I STAY PUT.")
		if(5)
			src.say("CEASE.")
		if(6)
			src.say("LEAVE.")
		if(7)
			src.say("GO AWAY.")
		if(8)
			src.say("THEFT.")
		if(9)
			src.say("BE SMARTER THAN THIS.")
		if(10)
			src.say("YOU'RE A FOOL.")
		if(11)
			src.say("WHEN DOES THIS END?")
		else
			src.say("NOT YOUR COIN.")
	playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/vaultbank/proc/resetlump()
	og_treasury = null
	total_extorted = null
	update_icon()

/obj/structure/roguemachine/vaultbank/proc/gethit()
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+2, time = 0.5)
	animate(pixel_x = oldx-2, time = 0.5)
	animate(pixel_x = oldx, time = 0.5)

/obj/structure/roguemachine/vaultbank/proc/update_shaking()
	if(shaker)
		animate(src, pixel_x = 1, time = 0.5, loop = -1, flags = ANIMATION_RELATIVE, tag = "shaking")
		animate(pixel_x = -2, time = 0.5, flags = ANIMATION_RELATIVE)
		animate(pixel_x = 1, time = 0.5, flags = ANIMATION_RELATIVE)
	else
		animate(src, tag = "shaking", flags = ANIMATION_END_LOOP)

/obj/structure/roguemachine/vaultbank/proc/drill()
	if(!drilling)
		return
	if(drilltime >= drillgoal) // Our timer's cap. Drillgoal is the number we're aiming for.
		new /obj/item/coveter(loc)
		loc.visible_message(span_warning("The [src] hisses open, <b>finally broken.</b>"))
		playsound(src, 'sound/misc/DrillDone.ogg', 70, TRUE)
		icon_state = "[initial(icon_state)]_empty"
		budget2change(SStreasury.treasury_value, null)
		SStreasury.treasury_value -= SStreasury.treasury_value
		playsound(src, 'sound/misc/jawbankhit.ogg', 70, TRUE)
		shaker = FALSE
		update_shaking()
		drilling = FALSE
		has_reported = FALSE
		knockitoff = 0 // Reset the knock counter.
		knockedoffbefore = 0 // And reset this, too.
		drilltime = 0 // Reset the timer, they broke it open.
		return
	var/doneness = round(drilltime / drillgoal * 100)
	if(SStreasury.treasury_value == 0)
		drilltime = drillgoal
		drill(src)
	loc.visible_message(span_warning("A horrible scraping sound emanates from the Crown as it does its work... (<b>[doneness]%</b>)"))
	if(!has_reported)
		if(SStreasury.treasury_value >= 3000) // Adjustable. Mainly for GROSS WEALTH.
			if(drilltime >= 50) // Adjust this as you like. Currently, it'll alert once half-way done.
				src.say("DUCHY ALERTED.")
				playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
				send_ooc_note("A parasite of the Freefolk is breaking [src]! Location: The Vault", job = list("Grand Duke", "Steward", "Clerk"))
				has_reported = TRUE
		else
			src.say("DUCHY ALERTED.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
			send_ooc_note("A parasite of the Freefolk is breaking [src]! Location: The Vault", job = list("Grand Duke", "Steward", "Clerk"))
			has_reported = TRUE

	playsound(src, 'sound/misc/TheDrill.ogg', 50, TRUE)
	spawn(100) // The time it takes to complete an interval. If you adjust this, please adjust the sound too. It's 'about' perfect at 100. Anything less It'll start overlapping.
		var/taken = min(rand(5, 20), SStreasury.treasury_value)
		anguish()
		budget2change(taken, null)
		SStreasury.treasury_value -= taken
		visible_message(span_danger("The Crown just drilled [taken] mammon out of [src]!"))
		drilltime += 3 // Adjust this to increase or decrease how long it'll take to drill open.
		drill(src)

/obj/structure/roguemachine/vaultbank/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/coveter))
		var/mob/living/carbon/human/H = user
		if(!HAS_TRAIT(H, TRAIT_COMMIE))
			to_chat(user, "<font color='red'>I don't know what I'm doing with this thing!</font>")
			return
		if(SStreasury.treasury_value < 50)
			to_chat(user, "<font color='red'>These fools are completely broke. We'll get nothing out of this...</font>")
			return
		user.visible_message(span_warning("[user] is mounting the Crown onto [src]!"))
		if(!do_after(user, 5 SECONDS))
			return
		if(SStreasury.treasury_value >= 3000 | !has_reported | !knockedoffbefore)
			loc.visible_message(span_notice("The amount of coin within the treasury slows down [src]'s reaction time!"))
		if(drilling)
			return
		user.visible_message(span_warning("[user] mounts the Crown atop [src]!"))
		icon_state = "[initial(icon_state)]_crown"
		has_reported = FALSE
		drilling = TRUE
		shaker = TRUE
		update_shaking()
		drill(src)
		qdel(I)
		message_admins("[usr.key] has applied the Crustacean to [src].")
		return

	if(istype(I, /obj/item/roguecoin/gilbranze))
		return
	if(istype(I, /obj/item/roguecoin/inqcoin))
		return
	if(istype(I, /obj/item/roguecoin))
		var/value = I.get_real_price()
		user.visible_message(span_notice("[user] inserts [value] mammon into [src]."))
		SStreasury.give_money_treasury(value, "JAWBANK Deposit")
		update_icon()
		qdel(I)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		feedme()
		return

	if (!istype(I, /obj/item/rogueweapon))
		return

	if (I.d_type != BCLASS_BLUNT)
		return

	..()

	user.changeNext_move(CLICK_CD_INTENTCAP)
	if (!og_treasury)
		og_treasury = SStreasury.treasury_value
	var/puke_chance = (I.force > 25) ? 75 : 25
	var/extorted = min(rand(5, 20), SStreasury.treasury_value)
	gethit()
	if (drilling)
		playsound(src, 'sound/misc/drillhit.ogg', 70, TRUE)
		knockitoff += 1
		visible_message(span_info("The covetous crab is knocked slightly more loose from [src]! <b>[knockitoff]</b>!"))
		if(knockitoff >= 10) // DISMOUNT THAT CRAB
			playsound(src, 'sound/misc/bug.ogg', 70, TRUE)
			message_admins("[usr.key] has knocked the Crustacean off of [src].")
			visible_message(span_warning("The crab falls off of [src]!"))
			knockedoffbefore = 1
			new /obj/item/coveter(loc)
			icon_state = "[initial(icon_state)]"
			knockitoff = 0
			drilling = FALSE
			shaker = FALSE
		return

	addtimer(CALLBACK(src, PROC_REF(resetlump)), 1 MINUTES, TIMER_UNIQUE | TIMER_OVERRIDE)

	if(!prob(puke_chance))
		playsound(src, 'sound/misc/beep.ogg', 70, TRUE)
		user.visible_message(span_warning("..And yet, nothing happens."))
		return

	if(!SStreasury.treasury_value)
		playsound(src, 'sound/misc/machineno.ogg', 70, TRUE)
		user.visible_message(span_warning("..But [src] is empty!"))
		return

	playsound(src, 'sound/misc/jawbankhit.ogg', 70, TRUE)
	budget2change(extorted, null)
	SStreasury.treasury_value -= extorted
	visible_message(span_danger("[src] coughed up [extorted] mammon!"))
	playsound(src, 'sound/misc/coindispense.ogg', 70, TRUE)
	SStreasury.log_to_steward("-[extorted] mammon knocked loose from [src]!")
	total_extorted += extorted
	whine()

	if((total_extorted / og_treasury) * 100 >= rand(20, 25))
		if(SStreasury.treasury_value <= 125)
			resetlump(src)
			return
		var/lumpsum = round(SStreasury.treasury_value * rand(10, 20) / 100) // Lump-sum percentage. Adjust as you like.
		budget2change(lumpsum, null)
		SStreasury.treasury_value -= lumpsum
		visible_message(span_notice("[src] just spat up a total of [lumpsum] mammon - <b>A lump sum!</b>"))
		playsound(src, 'sound/misc/coindispense.ogg', 70, TRUE)
		anguish()
		send_ooc_note("Someone knocked a lump-sum loose from [src] at the Vault!", job = list("Grand Duke", "Steward", "Clerk"))
		SStreasury.log_to_steward("-[lumpsum] was the lump-sum knocked loose from [src]!")
		resetlump(src)

	update_icon()
	return ..()

/obj/structure/roguemachine/vaultbank/examine(mob/user)
	. += ..()
	. += span_notice("The treasury currently sits at: [SStreasury.treasury_value] mammon.")
