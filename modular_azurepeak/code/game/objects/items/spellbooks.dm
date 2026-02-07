#define ROCK_CHARGE_REDUCTION 0.15
#define GEM_CHARGE_REDUCTION 0.25

/obj/item/book/spellbook
	var/open = FALSE
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "spellbookbrown_0"
	slot_flags = ITEM_SLOT_HIP
	var/base_icon_state = "spellbookbrown"
	unique = TRUE
	firefuel = 2 MINUTES
	dropshrink = 0.6
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	force = 5
	associated_skill = /datum/skill/misc/reading
	possible_item_intents = list(/datum/intent/use, /datum/intent/special/magicarc)
	name = "\improper tome of the arcyne"
	desc = "A crackling, glowing book, filled with runes and symbols that hurt the mind to stare at."
	var/picked
	var/born_of_rock = FALSE
	var/owner = null
	var/list/allowed_readers = list()
	var/bookquality = 1
	var/pages_to_mastery = 7
	var/used = FALSE
	var/list/remarks = list("Recall that place of white and black, so cold after its season of heat...",
		"Time slips away as I devour each pictograph and sigil...",
		"Noc is a shrewd God, and his followers' writings are no different...",
		"The smell of wet rain fills the room with every turned page...",
		"Helical text spans the page like a winding puzzle...",
		"Tracing a finger over one rune renders  my hand paralyzed, if only for a moment...",
		"This page clearly details the benefits of swampweed on one's capacity to conceptualize the arcyne...",
		"Conceptualize. Theorize. Feel. Flow. Manifest...",
		"Passion. Strength. Power. Victory. The tenets through which we break the chains of reality...",
		"Magick is to be kept close, a guarded secret. Noc changed the rules again. I need to catch up...",
		"Didn't I just read this page...?",
		"A lone illustration of Noc's visage fills this page, his stony gaze boring into my soul...",
		"My eyes begin to lid as I finish this chapter. These symbols cast a heavy fog over my mind...",
		"Silver. Blade. Mana. Blood. These are the ingredients I'll need to imbibe the very ground with arcyne abilities...",
		"Elysium incants speak to me in an extinct tongue immortalized on parchment...",
		"My mind wanders and waves. Z's temptations draw close, but I weather through as I finally finish this chapter...",
		"I close my eye's for but a moment, and the competing visages of Noc and Z stare into my very soul. I see them blink, and my eyelids open...",
		"I am the Root. The Root is me. I must reach it, and the Tree...",
		"I feel the arcyne circuits running through my body, empowered with each word I read...",
		"Am I reading? Are these words, symbols or inane scribbles? I cannot be sure, yet with each one my eyes glaze over, I can feel the arcyne pulse within me...")

/obj/item/book/spellbook/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/book/spellbook/examine(mob/user)
	. = ..()
	. += span_notice("Reading it allows you to study the arcyne mysteries and gain spell points.")
	if(born_of_rock)
		. += span_notice("This tome was made from a magical stone instead of a proper gem. Holding it in your hand with it open reduces spell charge time by [ROCK_CHARGE_REDUCTION * 100]%")
	else
		. += span_notice("This tome was made from a gem. Holding it in your hand with it open reduces spell charge time by [GEM_CHARGE_REDUCTION * 100]%")

/obj/item/book/spellbook/attack_self(mob/user)
	if(!open)
		attack_right(user)
		return
	if(used)
		to_chat(user, span_warning("I've already studied this tome recently. I need rest before I can focus on it again."))
		return
	if(user.mind?.has_changed_spell == TRUE)
		to_chat(user, span_notice("I struggle to study my arcane notes more. Perhaps a good rest would help."))
		return FALSE
	on_reading_start(user)
	if(do_after(user, pages_to_mastery * 3 SECONDS, target = src))
		on_reading_finished(user)
	user.update_inv_hands()

/obj/item/book/spellbook/rmb_self(mob/user)
	attack_right(user)
	return

/obj/item/book/spellbook/proc/on_reading_start(mob/user)
	to_chat(user, span_notice("Arcyne mysteries abound in this enigmatic tome, gift of Noc..."))

/obj/item/book/spellbook/proc/on_reading_finished(mob/user)
	var/mob/living/carbon/human/gamer = user
	if(gamer != owner && !allowed_readers.Find(gamer))
		to_chat(user, span_notice("What was that gibberish? Even for the arcyne it was completely illegible!"))
		recoil(user)
		return
	user.mind?.has_changed_spell = TRUE
	var/mob/living/reader = user
	var/qualityoflearn = (reader.STAINT*2 + (user.get_skill_level(/datum/skill/misc/reading)* 5) + (user.get_skill_level(/datum/skill/magic/arcane)*5))
/*
	if(reader.has_status_effect(/datum/status_effect/buff/weed))
		to_chat(user, span_smallgreen("Swampweed truly does open one's third eye to the secrets of the arcyne..."))
		qualityoflearn += 10
	var/obj/effect/decal/cleanable/roguerune/rune = (locate(/obj/effect/decal/cleanable/roguerune) in range(1, user))
	if(rune)
		to_chat(user, span_cultsmall("The rune beneath my feet glows..."))
		qualityoflearn += rune.spellbonus
		rune.do_invoke_glow()
*/
	if(!isarcyne(user))
		if (gamer != owner)
			qualityoflearn = 1
		else
			qualityoflearn *= 0.5
			qualityoflearn = min(qualityoflearn, 15)
	if (born_of_rock)
		if(iskobold(user))
			qualityoflearn *= 1.5
		else
			qualityoflearn *= 1.2
	if(iskobold(user) && !born_of_rock)
		qualityoflearn *= 0.1
	user.visible_message(span_warning("[user] is filled with arcyne energy! You witness [user.p_their()] body convulse and spark brightly."), \
	span_notice("Noc blesses me. I have been granted knowledge and wisdom beyond my years, this tome's mysteries unveiled one at a time."))
	qualityoflearn = qualityoflearn / 100
	//var/spellpoints = (src.bookquality * qualityoflearn)
	var/spellpoints = 2
	if(reader.has_status_effect(/datum/status_effect/buff/weed))
		to_chat(user, span_smallgreen("Swampweed truly does open one's third eye to the secrets of the arcyne..."))
		spellpoints = 3
	else
		var/obj/effect/decal/cleanable/roguerune/rune = (locate(/obj/effect/decal/cleanable/roguerune) in range(1, user))
		if(rune)
			to_chat(user, span_cultsmall("The rune beneath my feet glows..."))
			spellpoints = 3
			rune.do_invoke_glow()
		else if(prob(25))
			to_chat(user, span_smallgreen("Eureka! I've made a breakthrough..."))
			spellpoints = 3
	spellpoints = CEILING(spellpoints, 1)
	gamer.mind?.adjust_spellpoints(spellpoints)
	user.log_message("successfully studied their spellbook and gained spellpoints", LOG_ATTACK, color="orange")
	onlearned(user)
	if(prob(55))
		to_chat(user, span_notice("Confounded arcyne mysteries, my notes have gone in circles. I must sleep before I can bring myself to open this damned thing again..."))
		user.mind?.add_sleep_experience(/datum/skill/misc/reading, reader.STAINT*10)
	to_chat(user, span_small("My notes include passages I've read before, but don't understand. I must sleep on their meaning..."))

/obj/item/book/spellbook/proc/onlearned(mob/user)
	used = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_used)), 10 MINUTES)

/obj/item/book/spellbook/proc/reset_used()
	used = FALSE

/obj/item/book/spellbook/proc/recoil(mob/user)
	user.visible_message(span_warning("[src] shoots out a spark of angry, arcyne energy at [user]!"))
	var/mob/living/gamer = user
	gamer.electrocute_act(5, src)

/obj/item/book/spellbook/attack(mob/living/M, mob/living/carbon/human/user)
	if (M.stat != DEAD)
		if(user == M)
			to_chat(user, span_warning("I'm already chained to this tome!"))
			return
		if(ishuman(M))
			M.visible_message(span_danger("[user] beats [M] over the head with [src]!"), \
								span_danger("[user] beats [M] over the head with [src]!"))
			if(src.allowed_readers.len <= 2 && !src.allowed_readers.Find(user))
				src.allowed_readers += M
			else
				to_chat(user, span_smallnotice("I can't chain this pleboid to my tome..."))
			playsound(src, "punch", 25, TRUE, -1)
			return
	return ..()

/obj/item/book/spellbook/proc/get_cdr()
	if(born_of_rock)
		return ROCK_CHARGE_REDUCTION
	else
		return GEM_CHARGE_REDUCTION

/obj/item/book/spellbook/attack_right(mob/user)
	if(!picked)
		var/list/designlist = list("green", "yellow", "brown")
		var/mob/living/carbon/human/gamer = user
		if(gamer.job == "Court Magician")
			designlist = list("steel", "gem", "skin", "mimic")
			bookquality = max(3, bookquality)
		var/the_time = world.time
		var/design = input(user, "Select a design.","Spellbook Design") as null|anything in designlist
		if(!design)
			return
		if(world.time > (the_time + 30 SECONDS))
			return
		base_icon_state = "spellbook[design]"
		update_icon()
		picked = TRUE
		return
	if(owner == null)
		owner = user
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	curpage = 1
	update_icon()
	user.update_inv_hands()

/obj/item/book/spellbook/update_icon()
	icon_state = "[base_icon_state]_[open]"

/obj/item/spellbook_unfinished
	var/pages_left = 4
	name = "bound scrollpaper"
	dropshrink = 0.6
	icon = 'icons/roguetown/items/books.dmi'
	icon_state ="basic_book_0"
	desc = "Thick scroll paper bound at the spine. It lacks pages."
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("bashed", "whacked", "educated")
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	pickup_sound =  'sound/blank.ogg'

/obj/item/spellbook_unfinished/pre_arcyne
	name = "tome in waiting"
	icon_state = "spellbook_unfinished"
	desc = "A fully bound tome of scroll paper. It's lacking a certain arcyne energy."
	grid_width = 32
	grid_height = 64

/obj/item/natural/hide/attackby(obj/item/P, mob/living/carbon/human/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/paper/scroll))
		if(isturf(loc)&& (found_table))
			var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane))*5))
			if(do_after(user, crafttime, target = src))
				playsound(loc, 'sound/items/book_close.ogg', 100, TRUE)
				to_chat(user, span_notice("I add the first few pages to the leather cover..."))
				new /obj/item/spellbook_unfinished(loc)
				qdel(P)
				qdel(src)
		else
			to_chat(user, "<span class='warning'>You need to put the [src] on a table to work on it.</span>")
	else
		return ..()

/obj/item/spellbook_unfinished/attackby(obj/item/P, mob/living/carbon/human/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/paper/scroll))
		if(isturf(loc)&& (found_table))
			var/crafttime = (60 - ((user.get_skill_level(/datum/skill/magic/arcane))*5))
			if(do_after(user, crafttime, target = src))
				if(pages_left > 0)
					playsound(loc, 'sound/items/book_page.ogg', 100, TRUE)
					pages_left -= 1
					to_chat(user, span_notice("[pages_left+1] left..."))
					qdel(P)
				else
					playsound(loc, 'sound/items/book_open.ogg', 100, TRUE)
					if(isarcyne(user))
						to_chat(user, span_notice("The book is bound. I must find a catalyst to channel the arcyne into it now."))
					else
						to_chat(user, span_notice("I've made an empty book of thick, useless scroll paper. I can't even thumb through it!"))
					new /obj/item/spellbook_unfinished/pre_arcyne(loc)
					qdel(P)
					qdel(src)
		else
			to_chat(user, "<span class='warning'>You need to put the [src] on a table to work on it.</span>")
	else
		return ..()

/obj/item/spellbook_unfinished/pre_arcyne/attackby(obj/item/P, mob/living/carbon/human/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/roguegem))
		if(isturf(loc)&& (found_table))
			var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane))*5))
			if(do_after(user, crafttime, target = src))
				if(isarcyne(user))
					playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
					user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder seeps into the [src]."), \
						span_notice("I run my arcyne energy into the crystal. It shatters and seeps into the cover of the tome! Runes and symbols of an unknowable language cover its pages now..."))
					var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
					newbook.owner = user
					newbook.desc += " Traces of [P] dust linger in its margins."
					newbook.bookquality = max(2, min(5, floor(P.sellprice / 30)))
					qdel(P)
					qdel(src)
				else
					if(prob(1))
						playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
						user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder seeps into the [src]."), \
							span_notice("By the Ten! That gem just exploded -- and my useless tome is filled with gleaming energy and strange letters!"))
						var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
						newbook.owner = user
						newbook.desc += " Traces of [P] dust linger in its margins."
						newbook.bookquality = max(2, min(5, floor(P.sellprice / 30)))
						qdel(P)
						qdel(src)
					else
						playsound(loc, 'modular_azurepeak/sound/spellbooks/icicle.ogg', 100, TRUE)
						user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder just kind of sits on top of the [src]. Awkward."), \
							span_notice("... why and how did I just crush this gem into a worthless scroll-book? What a WASTE of mammon!"))
						qdel(P)
					return ..()
		else
			to_chat(user, "<span class='warning'>You need to put [src] on a table to work on it.</span>")
	else if (istype(P, /obj/item/natural/stone))
		var/obj/item/natural/stone/the_rock = P
		if (the_rock.magic_power)
			if(isturf(loc) && (found_table))
				var/crafttime = ((130 - the_rock.magic_power) - ((user.get_skill_level(/datum/skill/magic/arcane))*5))
				if(do_after(user, crafttime, target = src))
					if (isarcyne(user))
						playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
						user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder seeps into the [src]."), \
							span_notice("I join my arcyne energy with that of the magical stone in my hands, which shudders briefly before dissolving into motes of ash. Runes and symbols of an unknowable language cover its pages now..."))
						to_chat(user, span_notice("...yet even for an enigma of the arcyne, these characters are unlike anything I've seen before. They're going to be -much- harder to understand..."))
						var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
						newbook.owner = user
						newbook.born_of_rock = TRUE
						newbook.bookquality = max(1, floor(the_rock.magic_power / 3))
						newbook.desc += " Traces of multicolored stone limn its margins."
						qdel(P)
						qdel(src)
					else
						if (prob(the_rock.magic_power))
							playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
							user.visible_message(span_warning("[user] carefully sets down [the_rock] upon [src]. Nothing happens for a moment or three, then suddenly, the glow surrounding the stone becomes as liquid, seeps down and soaks into the tome!"), \
							span_notice("I knew this stone was special! Its colourful magick has soaked into my tome and given me gift of mystery!"))
							to_chat(user, span_notice("...what in the world does any of this scribbling possibly mean?"))
							var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
							newbook.owner = user
							newbook.born_of_rock = TRUE
							newbook.bookquality = max(1, floor(the_rock.magic_power / 3))
							newbook.desc += " Traces of multicolored stone limn its margins."
							qdel(P)
							qdel(src)
						else
							user.visible_message(span_warning("[user] sets down [the_rock] upon the surface of [src] and watches expectantly. Without warning, the rock violently pops like a squashed gourd!"), \
							span_notice("No! My precious stone! It musn't have wanted to share its mysteries with me..."))
							user.electrocute_act(5, src)
							qdel(P)
		else
			to_chat(user, span_notice("This is a mere rock - it has no arcyne potential. Bah!"))
			return ..()
	else
		return ..()
