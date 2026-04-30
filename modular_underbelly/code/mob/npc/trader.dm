/mob/living/carbon/human/species/human/northern/underbelly_trader
	name = "The Trader"
	real_name = "The Trader"
	headshot_link = "https://i.gyazo.com/16d387beb13c61d07dee379ebe7b967d.png"
	voice_type = VOICE_TYPE_MASC
	flavortext = "A shoddy humen in a black longcoat and a jade mask. They seem to be willing to make some deals with the Scum, but to what extent?"
	ooc_notes = "Ever seen a NPC with flavortext before? First time for everythin', mate."
	wander = TRUE
	aggressive = 0
	mode = NPC_AI_IDLE
	flee_in_pain = FALSE
	rude = FALSE
	ambushable = FALSE
	possible_rmb_intents = list()
	faction = list("underbelly", "station")

	var/datum/underbelly_shop/shop
	/// Whether the trader is currently serving a customer, suppresses idle lines
	var/shopping = FALSE
	/// Time of last browsing-too-long nag
	var/last_browse_nag = 0
	/// When the shop stock next refreshes
	var/next_restock = 0

/mob/living/carbon/human/species/human/northern/underbelly_trader/Initialize(mapload)
	. = ..()
	set_species(/datum/species/human/northern)
	shop = new /datum/underbelly_shop(src)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/underbelly_trader/after_creation()
	..()
	job = "Trader"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	delete_equipment()
	equipOutfit(new /datum/outfit/job/roguetown/underbelly_trader_npc)
	fully_replace_character_name(null, "The Trader")
	name_override = "The Trader"
	social_rank = SOCIAL_RANK_SCUM
	if(dna)
		dna.real_name = "The Trader"
	next_restock = world.time + (25 MINUTES)
	shop.do_restock()
	addtimer(CALLBACK(src, PROC_REF(idle_voice_tick)), rand(20, 45) SECONDS)
	addtimer(CALLBACK(src, PROC_REF(restock_tick)), 25 MINUTES)

/mob/living/carbon/human/species/human/northern/underbelly_trader/Destroy()
	QDEL_NULL(shop)
	return ..()

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/idle_voice_tick()
	if(!shopping && !QDELETED(src) && stat == CONSCIOUS)
		var/mood_roll = rand(1, 10)
		if(mood_roll <= 2)
			visible_message(span_notice("[src] hums gently."))
			playsound(src, 'modular_underbelly/sound/trader/humming.ogg', 55, FALSE)
			addtimer(CALLBACK(src, PROC_REF(idle_voice_tick)), rand(25, 50) SECONDS)
			return
		if(mood_roll <= 4)
			var/chatter = rand(1, 3)
			switch(chatter)
				if(1)
					say("What's that? How have we procured these curiosities? Hehehe...you don't wanna know, mate...")
					playsound(src, 'modular_underbelly/sound/trader/idlechatter1.ogg', 60, FALSE)
				if(2)
					say("Ouugh...my back is killing me...yils haven't been kind to us, I suppose...")
					playsound(src, 'modular_underbelly/sound/trader/idlechatter2.ogg', 60, FALSE)
				if(3)
					say("Sigh....I guess everyone needs a hobby...")
					playsound(src, 'modular_underbelly/sound/trader/idlechatter3.ogg', 60, FALSE)
			addtimer(CALLBACK(src, PROC_REF(idle_voice_tick)), rand(30, 60) SECONDS)
			return
		if(mood_roll > 6)
			addtimer(CALLBACK(src, PROC_REF(idle_voice_tick)), rand(20, 45) SECONDS)
			return
		var/mob/living/carbon/human/nearby
		for(var/mob/living/carbon/human/H in view(4, src))
			if(H == src || !H.client)
				continue
			nearby = H
			break
		if(nearby && nearby.dna?.species)
			var/quip
			// Special cases first
			if(nearby.mind?.has_antag_datum(/datum/antagonist/vampire))
				quip = pick(
					"We don't sell bloodbags. And I'm not a bloodbag. Piss off.",
					"I don't appreciate your tone. And here I thought elves were stuck up. You take the cake, friend, well done.",
					"That thing down there still work? We don't have serums for that in stock.",
				)
			else
				var/sid = nearby.dna.species.id
				switch(sid)
					if("gnoll")
						quip = pick(
							"Who the fark brought this thing in here? The Boss will BE UPSET.",
							"Sorry, mate, but if ye ain't buying, fark off, you're getting hair all over.",
						)
					if("werewolf")
						quip = pick(
							"Someone really has to get their mutt in check.",
							"I know we're Scum and all, but this is a new low.",
						)
					if("aasimar")
						quip = pick(
							"What the hell are your kind doing here? Ye lost, mate?",
							"Is it true Psydon was your mate?",
						)
					if("arachnid")
						quip = pick(
							"Never was big on spiders. Especially oversized ones.",
							"What cobweb did you crawl out of, mate?",
						)
					if("akula")
						quip = pick(
							"You know, your kin are great at piracy. Maybe you can bring home some good stuff - and live up to yer stereotype, yeah?",
							"You ever wonder why your kind can drown? Makes you wonder.",
						)
					if("anthromorphsmall")
						quip = pick(
							"Careful, mate. The stuff I've got is about twice your size, haha!",
							"Sorry, we're outta cheese. Or are we? You should check my stock.",
						)
					if("elfd")
						quip = pick(
							"I suppose I can tolerate you. If you've got coin, that is.",
							"Please, for the love of--....just... don't talk, that accent is pissing me off.",
						)
					if("doll")
						quip = pick(
							"Whoever made you, truly tried to make your features...obscene.",
							"Sorry, we don't take this kind of goods.",
						)
					if("dracon")
						quip = pick(
							"You know, you fellas are supposed to be noble-blooded. Seeing you all the way down here? Absolutely comical.",
							"How far you've fallen, mate.",
						)
					if("dwarf", "dwarfm")
						quip = pick(
							"Short legs, big pockets. I hope.",
							"Dwarves always pay. That's why I like dwarves.",
							"Someone get this Big Man a Devastator. They'd look diabolical!",
						)
					if("elf", "elfw")
						quip = pick(
							"Don't get high and mighty with me, tree hugger.",
							"I should jack up the prices just for you. But I won't, I'm just that nice.",
							"Ugh. Just PLEASE don't talk me to death about how 'you're the most beautiful person in the room' again.",
						)
					if("moth")
						quip = pick(
							"I hope you got coin, otherwise, flutter off, fluffball.",
							"Sorry, we're out of lampterns. Or are we? Should check.",
						)
					if("gnome")
						quip = pick(
							"...Yeah, you're about who I expected to be my customer.",
							"What do you call a dwarf without a beard? That guy.",
						)
					if("halforc")
						quip = pick(
							"You ever get so emotionally charged, you just killed someone? Yes? Then you're gonna love what I got for you.",
							"You know, I can sometimes stock one of those big mauls. You'd seem the type.",
						)
					if("helf")
						quip = pick(
							"Humens and Elves just get on like that? Here I thought your parents would have standards.",
							"...Well, at least you're not as talkative as yer mum. She's an elf, right?",
						)
					if("demihuman")
						quip = pick(
							"Some would call you a mutt. Me? I'll call you my next customer, and good friend.",
							"I wonder, do you have two sets of ears? You know, the ones on your head, and the ones where they're supposed to be.",
						)
					if("harpy")
						quip = pick(
							"Ey, Squawker. We've got some crossbows you can piss people off with. I think.",
							"...Sorry, I was thinking of fry-bird again.",
						)
					if("humen")
						quip = pick(
							"Welcome back, friend. I hope your good choices aren't as vanilla as you are.",
							"Nothing wrong with being a humen among all the other freeks. Don't listen to those guys.",
						)
					if("kobold")
						quip = pick(
							"...No, we won't trade 'shinies' for store credit. Bog off!",
							"Don't get punted. Or do, I don't kinkshame.",
							"Hands where I can see them, lil' guy.",
						)
					if("lamia")
						quip = pick(
							"You ever poison anyone with those fangs?",
							"They'll PROBABLY not hear you coming. Or slithering.",
						)
					if("lupian")
						quip = pick(
							"Easy, doggo. Don't bite the merchandise.",
							"You got coin, or are you just sniffing around?",
						)
					if("construct", "constructm")
						quip = pick(
							"Did you lot make this thing? Color me impressed.",
							"Sorry, we're out of oil. Kingsfield guards that with their LYVES.",
						)
					if("revenant")
						quip = pick(
							"Don't care if yer dead, yer coin don't rot.",
							"The dead speak no lies. Usually. Ask Necra, since yer so close to 'er.",
						)
					if("lizardfolk")
						quip = pick(
							"Don't get hissy with me.",
							"Ssssorry, we're out of...sorry, I just had to say that.",
						)
					if("tabaxi")
						quip = pick(
							"Don't cough up a hairball in my shop, or I'll kick your arse out.",
							"Am I the only one that finds this guy insufferable?",
						)
					if("tiefling")
						quip = pick(
							"Relax, I don't charge extra for hellspawn. Can't say the same about the Flipsiders.",
							"Fire will rise in your wake, with my goods, friend.",
						)
					if("vulpkanin")
						quip = pick(
							"Sly, is that you?....Sorry, mistook you for an ol' friend.",
							"There's only two of you. The biggest twinks, or the most obscene things. There is no inbetween.",
							"Don't swipe my goods, friend. I'd say they're fairly priced.",
						)
					if("goblinp")
						quip = pick(
							"You're about who I expected to be down here, really.",
							"Did you know there's a camp with your people around here in the sewers? Are you related to them?",
							"I've got my eye on you, friend.",
						)
					if("anthromorph")
						quip = pick(
							"I do not need to know your tragic backstory. I do need your coin, though.",
							"Furred, scaled, skinned, I don't care what you are, let's just do business.",
						)
			if(quip)
				say(quip)
				addtimer(CALLBACK(src, PROC_REF(idle_voice_tick)), rand(30, 60) SECONDS)
				return
	addtimer(CALLBACK(src, PROC_REF(idle_voice_tick)), rand(20, 45) SECONDS)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/restock_tick()
	if(QDELETED(src))
		return
	shop.do_restock()
	next_restock = world.time + (25 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(restock_tick)), 25 MINUTES)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_purchase(mob/user, sound_key)
	var/sound_file
	switch(sound_key)
		if("biggun")
			sound_file = pick(
				'modular_underbelly/sound/trader/purchase_biggun1.ogg',
				'modular_underbelly/sound/trader/purchase_biggun2.ogg',
				'modular_underbelly/sound/trader/purchase_biggun3.ogg',
				'modular_underbelly/sound/trader/purchase_biggun4.ogg',
				'modular_underbelly/sound/trader/purchase_biggun5.ogg',
				'modular_underbelly/sound/trader/purchase_biggun6.ogg',
				'modular_underbelly/sound/trader/purchase_biggun7.ogg',
				'modular_underbelly/sound/trader/purchase_biggun8.ogg',
				'modular_underbelly/sound/trader/purchase_biggun9.ogg',
				'modular_underbelly/sound/trader/purchase_biggun10.ogg',
			)
		if("mediumgun")
			sound_file = pick(
				'modular_underbelly/sound/trader/purchase_mediumgun1.ogg',
				'modular_underbelly/sound/trader/purchase_mediumgun2.ogg',
				'modular_underbelly/sound/trader/purchase_mediumgun3.ogg',
				'modular_underbelly/sound/trader/purchase_mediumgun4.ogg',
				'modular_underbelly/sound/trader/purchase_mediumgun5.ogg',
				'modular_underbelly/sound/trader/purchase_mediumgun6.ogg',
				'modular_underbelly/sound/trader/purchase_mediumgun7.ogg',
				'modular_underbelly/sound/trader/purchase_mediumgun8.ogg',
				'modular_underbelly/sound/trader/purchase_mediumgun9.ogg',
			)
		if("smallgun")
			sound_file = pick(
				'modular_underbelly/sound/trader/purchase_smallgun1.ogg',
				'modular_underbelly/sound/trader/purchase_smallgun2.ogg',
				'modular_underbelly/sound/trader/purchase_smallgun3.ogg',
				'modular_underbelly/sound/trader/purchase_smallgun4.ogg',
				'modular_underbelly/sound/trader/purchase_smallgun5.ogg',
				'modular_underbelly/sound/trader/purchase_smallgun6.ogg',
				'modular_underbelly/sound/trader/purchase_smallgun7.ogg',
			)
		if("spikedknucks")
			sound_file = 'modular_underbelly/sound/trader/purchase_spikedknucks.ogg'
		if("deaddrop")
			sound_file = 'modular_underbelly/sound/trader/purchase_deaddrop.ogg'
		else
			sound_file = pick(
				'modular_underbelly/sound/trader/purchase_allurs.ogg',
				'modular_underbelly/sound/trader/purchase_anythingelse.ogg',
				'modular_underbelly/sound/trader/purchase_asuwish.ogg',
				'modular_underbelly/sound/trader/purchase_chuckle.ogg',
				'modular_underbelly/sound/trader/purchase_dazzled.ogg',
				'modular_underbelly/sound/trader/purchase_dealstruck.ogg',
				'modular_underbelly/sound/trader/purchase_dontalways.ogg',
				'modular_underbelly/sound/trader/purchase_eye.ogg',
				'modular_underbelly/sound/trader/purchase_finesse.ogg',
				'modular_underbelly/sound/trader/purchase_goodtaste.ogg',
				'modular_underbelly/sound/trader/purchase_grave.ogg',
				'modular_underbelly/sound/trader/purchase_iknew.ogg',
				'modular_underbelly/sound/trader/purchase_interesting.ogg',
				'modular_underbelly/sound/trader/purchase_knack.ogg',
				'modular_underbelly/sound/trader/purchase_lookatu.ogg',
				'modular_underbelly/sound/trader/purchase_notbad.ogg',
				'modular_underbelly/sound/trader/purchase_overprep.ogg',
				'modular_underbelly/sound/trader/purchase_pleasure.ogg',
				'modular_underbelly/sound/trader/purchase_sometins.ogg',
				'modular_underbelly/sound/trader/purchase_stockingup.ogg',
				'modular_underbelly/sound/trader/purchase_tastes.ogg',
				'modular_underbelly/sound/trader/purchase_thanku.ogg',
				'modular_underbelly/sound/trader/purchase_thatcash.ogg',
				'modular_underbelly/sound/trader/purchase_upgrade1.ogg',
				'modular_underbelly/sound/trader/purchase_upgrade2.ogg',
				'modular_underbelly/sound/trader/purchase_upgrade3.ogg',
				'modular_underbelly/sound/trader/purchase_wisechoice.ogg',
			)
	user.playsound_local(user, sound_file, 75, FALSE)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_no_coin(mob/user)
	user.playsound_local(user, pick(
		'modular_underbelly/sound/trader/urbroke1.ogg',
		'modular_underbelly/sound/trader/urbroke2.ogg',
		'modular_underbelly/sound/trader/urbroke3.ogg',
		'modular_underbelly/sound/trader/urbroke4.ogg',
		'modular_underbelly/sound/trader/urbroke5.ogg',
		'modular_underbelly/sound/trader/urbroke6.ogg',
		'modular_underbelly/sound/trader/urbroke7.ogg',
		'modular_underbelly/sound/trader/urbroke8.ogg',
	), 75, FALSE)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_browse_too_long(mob/user)
	if(world.time < last_browse_nag + (60 SECONDS))
		return
	last_browse_nag = world.time
	var/nag = rand(1, 4)
	switch(nag)
		if(1)
			say("You just gon' stand there or wot?")
			playsound(src, 'modular_underbelly/sound/trader/nag1.ogg', 65, FALSE)
		if(2)
			say("Time is money, mate.")
			playsound(src, 'modular_underbelly/sound/trader/nag2.ogg', 65, FALSE)
		if(3)
			say("Take ALL the time you need...")
			playsound(src, 'modular_underbelly/sound/trader/nag3.ogg', 65, FALSE)
		if(4)
			say("Not seeing anything you like, stranger?")
			playsound(src, 'modular_underbelly/sound/trader/nag4.ogg', 65, FALSE)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/_lux_payout(obj/item/I)
	if(istype(I, /obj/item/reagent_containers/lux))
		return rand(140, 180)
	if(istype(I, /obj/item/reagent_containers/lux_impure))
		return rand(70, 100)
	return 0

/mob/living/carbon/human/species/human/northern/underbelly_trader/attackby(obj/item/I, mob/living/user, params)
	if(!istype(I, /obj/item/parcel/dead_drop) \
		&& !istype(I, /obj/item/paper/scroll/dead_drop_contract) \
		&& !istype(I, /obj/item/reagent_containers/lux) \
		&& !istype(I, /obj/item/reagent_containers/lux_impure))
		return ..()
	if(!istype(user, /mob/living/carbon/human))
		return ..()
	var/mob/living/carbon/human/H = user
	if(istype(I, /obj/item/reagent_containers/lux) || istype(I, /obj/item/reagent_containers/lux_impure))
		if(H.job != "Ripper")
			to_chat(H, span_warning("[src] glances at [I.name] and waves [src.p_their()] hand. \"I don't deal in this, friend. That's the Ripper's department.\""))
			return
		if(stat != CONSCIOUS)
			to_chat(H, span_warning("[src] is in no state to receive a delivery."))
			return
		var/gold_payout = _lux_payout(I)
		if(!gold_payout)
			to_chat(H, span_warning("[src] looks at [I.name] and shakes [src.p_their()] head. \"Can't move that.\""))
			return
		var/sold_name = I.name
		qdel(I)
		var/obj/item/roguecoin/gold/coins = new(get_turf(H), gold_payout)
		H.put_in_hands(coins)
		visible_message(span_notice("[src] pockets [sold_name] with a nod."))
		on_purchase(H, null)
		return
	if(stat != CONSCIOUS)
		to_chat(H, span_warning("[src] is in no state to receive a delivery."))
		return
	if(istype(I, /obj/item/parcel/dead_drop))
		var/obj/item/parcel/dead_drop/parcel = I
		if(HAS_TRAIT(H, TRAIT_UNDERBELLY_SCUM))
			to_chat(H, span_warning("[src] eyes the parcel and shakes [src.p_their()] head. \"Not from one of your own. Send a clean pair of hands.\""))
			return
		if(!parcel.bound_ckey || parcel.bound_ckey != H.ckey)
			to_chat(H, span_warning("[src] glances at the parcel and waves [src.p_their()] hand. \"That ain't your delivery, friend.\""))
			return
		var/obj/item/paper/scroll/dead_drop_contract/C = parcel.contract_ref?.resolve()
		parcel.contract_ref = null
		qdel(parcel)
		var/obj/item/roguecoin/gold/payout = new(get_turf(H), rand(5, 10))
		H.put_in_hands(payout)
		if(C)
			C.parcel_ref = null
			C.ready_to_redeem = TRUE
		visible_message(span_notice("[src] takes the parcel, slips a few coins to [H], and makes a small mark on a scrap of paper."))
		say("Tell whoever sent you the deal's stamped. They know where to find me.")
		return
	// Contract redemption (Flinger/Gutter King cashing in after the parcel was delivered).
	var/obj/item/paper/scroll/dead_drop_contract/C = I
	if(H.job != "Flinger" && H.job != "Gutter King")
		to_chat(H, span_warning("[src] eyes the contract. \"That's not yours to cash, friend.\""))
		return
	if(!C.ready_to_redeem)
		to_chat(H, span_warning("[src] glances at the contract. \"Parcel ain't been delivered yet. Get a runner on it.\""))
		return
	C.parcel_ref = null
	qdel(C)
	var/obj/item/roguecoin/gold/payout = new(get_turf(H), rand(15, 25))
	H.put_in_hands(payout)
	visible_message(span_notice("[src] tears the contract in half and settles the debt with [H]."))
	on_deaddrop_success(H)

/mob/living/carbon/human/species/human/northern/underbelly_trader/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(!Adjacent(H))
		return
	if(stat != CONSCIOUS)
		to_chat(H, span_warning("[src] isn't in any state to do business."))
		return
	if(!HAS_TRAIT(H, TRAIT_UNDERBELLY_SCUM))
		to_chat(H, span_warning("[src] eyes you up and shakes [src.p_their()] head."))
		say("Not for you, friend.")
		return
	if(!GLOB.underbelly_chute)
		to_chat(H, span_warning("The chute doesn't seem to be active."))
		return
	shopping = TRUE
	wander = FALSE
	setDir(get_dir(src, H))
	shop.ui_interact(H)
	addtimer(CALLBACK(src, PROC_REF(resume_wander)), 5 MINUTES)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/resume_wander()
	if(QDELETED(src))
		return
	shopping = FALSE
	wander = TRUE

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_no_stock(mob/user)
	user.playsound_local(user, pick(
		'modular_underbelly/sound/trader/shop_nostock.ogg',
		'modular_underbelly/sound/trader/shop_nostock2.ogg',
		'modular_underbelly/sound/trader/shop_nostock3.ogg',
	), 70, FALSE)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_shop_open(mob/user)
	user.playsound_local(user, pick(
		'modular_underbelly/sound/trader/shop_open1.ogg',
		'modular_underbelly/sound/trader/shop_open2.ogg',
		'modular_underbelly/sound/trader/shop_open3.ogg',
		'modular_underbelly/sound/trader/shop_open4.ogg',
		'modular_underbelly/sound/trader/shop_open5.ogg',
		'modular_underbelly/sound/trader/shop_open6.ogg',
		'modular_underbelly/sound/trader/shop_open7.ogg',
		'modular_underbelly/sound/trader/shop_open8.ogg',
		'modular_underbelly/sound/trader/shop_open9.ogg',
		'modular_underbelly/sound/trader/shop_open10.ogg',
		'modular_underbelly/sound/trader/shop_open11.ogg',
		'modular_underbelly/sound/trader/shop_open12.ogg',
		'modular_underbelly/sound/trader/shop_open13.ogg',
		'modular_underbelly/sound/trader/shop_open14.ogg',
		'modular_underbelly/sound/trader/shop_open15.ogg',
	), 70, FALSE)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_shop_open_newstock(mob/user)
	user.playsound_local(user, pick(
		'modular_underbelly/sound/trader/shop_open_newstock.ogg',
		'modular_underbelly/sound/trader/shop_open_newstock2.ogg',
		'modular_underbelly/sound/trader/shop_open_newstock3.ogg',
		'modular_underbelly/sound/trader/shop_open_newstock4.ogg',
		'modular_underbelly/sound/trader/shop_open_newstock5.ogg',
		'modular_underbelly/sound/trader/shop_open_newstock6.ogg',
		'modular_underbelly/sound/trader/shop_open_newstock7.ogg',
	), 70, FALSE)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_shop_close(mob/user)
	user.playsound_local(user, pick(
		'modular_underbelly/sound/trader/shop_close1.ogg',
		'modular_underbelly/sound/trader/shop_close2.ogg',
		'modular_underbelly/sound/trader/shop_close3.ogg',
		'modular_underbelly/sound/trader/shop_close4.ogg',
		'modular_underbelly/sound/trader/shop_close8.ogg',
		'modular_underbelly/sound/trader/shop_close9.ogg',
	), 70, FALSE)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_nopurchase_close(mob/user)
	var/npc = rand(1, 3)
	switch(npc)
		if(1)
			say("Next time, buy something, ey?")
			playsound(src, 'modular_underbelly/sound/trader/nopurchase_close.ogg', 70, FALSE)
		if(2)
			say("Hmph, suit yourself, stranger.")
			playsound(src, 'modular_underbelly/sound/trader/nopurchase_close2.ogg', 70, FALSE)
		if(3)
			say("Oi oi! Where you off to?!")
			playsound(src, 'modular_underbelly/sound/trader/nopurchase_close3.ogg', 70, FALSE)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_tab_main(mob/user)
	user.playsound_local(user, 'modular_underbelly/sound/trader/shop_openmainshop.ogg', 70, FALSE)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_tab_exclusives(mob/user)
	user.playsound_local(user, pick(
		'modular_underbelly/sound/trader/shop_openexclusives1.ogg',
		'modular_underbelly/sound/trader/shop_openexclusives2.ogg',
	), 70, FALSE)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_deaddrop_success(mob/user)
	user.playsound_local(user, pick(
		'modular_underbelly/sound/trader/success_deaddrop.ogg',
		'modular_underbelly/sound/trader/success_deaddrop2.ogg',
		'modular_underbelly/sound/trader/success_deaddrop3.ogg',
		'modular_underbelly/sound/trader/success_deaddrop4.ogg',
		'modular_underbelly/sound/trader/success_deaddrop5.ogg',
		'modular_underbelly/sound/trader/success_deaddrop6.ogg',
		'modular_underbelly/sound/trader/success_deaddrop7.ogg',
		'modular_underbelly/sound/trader/success_deaddrop8.ogg',
		'modular_underbelly/sound/trader/success_deaddrop9.ogg',
	), 75, FALSE)

/obj/item/clothing/mask/rogue/facemask/carved/jademask/trader
	name = "Trader's Visage"
	desc = "A jade mask worn by the Underbelly's broker, equal parts invitation and warning."
	flags_inv = NONE

// Outfit
/datum/outfit/job/roguetown/underbelly_trader_npc
	name = "Underbelly Trader"

/datum/outfit/job/roguetown/underbelly_trader_npc/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/mask/rogue/facemask/carved/jademask/trader
	head = /obj/item/clothing/head/roguetown/puritan/scum
	armor = null
	cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	belt = /obj/item/storage/belt/rogue/leather/double
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backr = /obj/item/storage/backpack/rogue/backpack
