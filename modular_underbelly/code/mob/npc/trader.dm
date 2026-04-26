GLOBAL_LIST_INIT(trader_idle_lines, world.file2list("strings/rt/trader_idle.txt"))
GLOBAL_LIST_INIT(trader_purchase_lines, world.file2list("strings/rt/trader_purchase.txt"))
GLOBAL_LIST_INIT(trader_broke_lines, world.file2list("strings/rt/trader_broke.txt"))
GLOBAL_LIST_INIT(trader_browsing_lines, world.file2list("strings/rt/trader_browsing.txt"))

/mob/living/carbon/human/species/human/northern/underbelly_trader
	name = "The Trader"
	real_name = "The Trader"
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
	/// Time of last purchase voice line, cooldown to avoid spam
	var/last_purchase_line = 0
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
	equipOutfit(new /datum/outfit/job/roguetown/underbelly_trader_npc)
	next_restock = world.time + (25 MINUTES)
	shop.do_restock()
	addtimer(CALLBACK(src, PROC_REF(idle_voice_tick)), rand(20, 45) SECONDS)
	addtimer(CALLBACK(src, PROC_REF(restock_tick)), 25 MINUTES)

/mob/living/carbon/human/species/human/northern/underbelly_trader/Destroy()
	QDEL_NULL(shop)
	return ..()

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/idle_voice_tick()
	if(!shopping && !QDELETED(src) && stat == CONSCIOUS)
		var/mob/living/carbon/human/nearby = locate(/mob/living/carbon/human) in view(4, src)
		if(nearby && nearby != src && nearby.dna?.species)
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
		say(pick(GLOB.trader_idle_lines))
	addtimer(CALLBACK(src, PROC_REF(idle_voice_tick)), rand(20, 45) SECONDS)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/restock_tick()
	if(QDELETED(src))
		return
	shop.do_restock()
	next_restock = world.time + (25 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(restock_tick)), 25 MINUTES)

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_purchase(mob/user)
	if(world.time < last_purchase_line + (30 SECONDS))
		return
	last_purchase_line = world.time
	say(pick(GLOB.trader_purchase_lines))

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_no_coin(mob/user)
	say(pick(GLOB.trader_broke_lines))

/mob/living/carbon/human/species/human/northern/underbelly_trader/proc/on_browse_too_long(mob/user)
	if(world.time < last_browse_nag + (60 SECONDS))
		return
	last_browse_nag = world.time
	say(pick(GLOB.trader_browsing_lines))

/mob/living/carbon/human/species/human/northern/underbelly_trader/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(!Adjacent(H))
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

// Outfit
/datum/outfit/job/roguetown/underbelly_trader_npc
	name = "Underbelly Trader"

/datum/outfit/job/roguetown/underbelly_trader_npc/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/merchant
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	pants = /obj/item/clothing/under/roguetown/tights/sailor
	head = /obj/item/clothing/head/roguetown/chaperon/brown
	belt = /obj/item/storage/belt/rogue/leather/rope
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
