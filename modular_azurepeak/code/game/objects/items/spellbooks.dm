#define ROCK_CHARGE_REDUCTION 0.15
#define GEM_CHARGE_REDUCTION 0.25

/* Spellbook
Intended to be a reward or a goal for pure mage, allowing them to reset and swap out 2 spells per day (3 with T3+ arcyne), and
decreases charge time if held opened in hand, for pure mage build + aesthetics.
*/

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
	desc = "A crackling, glowing book, filled with runes and symbols that hurt the mind to stare at. Can be used to unbind spells, or to assist the caster in arcing some of their projectiles."
	var/picked // if the book has had it's style picked or not
	var/born_of_rock = FALSE // was a magical stone used to make it instead of a gem

/obj/item/book/spellbook/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete)
	var/datum/component/storage/storage = GetComponent(/datum/component/storage)
	storage.max_items = 1
	storage.max_w_class = WEIGHT_CLASS_SMALL

/obj/item/book/spellbook/MiddleClick(mob/living/user, params)
	if(!user.mind)
		return ..()
	if(!user.Adjacent(src) && loc != user)
		to_chat(user, span_warning("I need to be closer to bind this tome."))
		return TRUE
	for(var/obj/effect/proc_holder/spell/self/magos_book_bind/bind_spell in user.mind.spell_list)
		bind_spell.bound_spellbook = src
		to_chat(user, span_notice("I bind [src] to my arcyne grasp. I can now recall it with Magos' Book Bind."))
		playsound(src, 'sound/magic/charged.ogg', 50, TRUE)
		return TRUE
	return ..()

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
	var/unbind_limit = (HAS_TRAIT(user, TRAIT_ARCYNE_T3) || HAS_TRAIT(user, TRAIT_ARCYNE_T4)) ? 3 : 2
	. += span_notice("Reading it once per day allows you to unbind up to [unbind_limit] spells and refund their spell points.")
	if(born_of_rock)
		. += span_notice("This tome was made from a magical stone instead of a proper gem. Holding it in your hand with it open reduces spell charge time by [ROCK_CHARGE_REDUCTION * 100]%")
	else
		. += span_notice("This tome was made from a gem. Holding it in your hand with it open reduces spell charge time by [GEM_CHARGE_REDUCTION * 100]%")

/obj/item/book/spellbook/attack_self(mob/user)
	if(!open)
		attack_right(user)
		return
	..()
	user.update_inv_hands()

/obj/item/book/spellbook/rmb_self(mob/user)
	attack_right(user)
	return

// Override
/obj/item/book/spellbook/read(mob/user)
	change_spells()
	return FALSE

/obj/item/book/spellbook/proc/change_spells(mob/living/user = usr)
	var/datum/mind/user_mind = user.mind
	if(!user_mind) return // How??
	var/unbind_limit = (HAS_TRAIT(user, TRAIT_ARCYNE_T3) || HAS_TRAIT(user, TRAIT_ARCYNE_T4)) ? 3 : 2
	var/list/resettable_spells = list()
	var/list/spell_list = user_mind.spell_list
	for(var/i = 1, i <= spell_list.len, i++)
		var/obj/effect/proc_holder/spell/spell = spell_list[i]
		if(spell.refundable == TRUE)
			if(spell.cost > 0)
				resettable_spells["[spell.name]: [spell.cost]"] = spell_list[i]
	if(!resettable_spells.len && user_mind.strained_spell_unbinds < 2)
		to_chat(user, span_warning("I have no spells to unbind!"))
		return
	if(user_mind.free_spell_unbinds < unbind_limit)
		user_mind.has_changed_spell = TRUE //To pre-empt a halting duplication in the for loop here
		for(var/i = user_mind.free_spell_unbinds + 1, i <= unbind_limit, i++)
			var/remaining_unbinds = unbind_limit - user_mind.free_spell_unbinds
			var/choice = input(user, "Choose a spell to unbind. I have [remaining_unbinds] unbind[remaining_unbinds == 1 ? "" : "s"] remaining today.") as null|anything in resettable_spells
			var/obj/effect/proc_holder/spell/item = resettable_spells[choice]
			if(!item)
				break
			var/spell_cost = item.cost
			if(user_mind.RemoveSpell(item))
				user_mind.free_spell_unbinds++
				user_mind.used_spell_points -= spell_cost
				resettable_spells.Remove(choice)
				user_mind.check_learnspell()
			if(!resettable_spells.len)
				break
		if(!user_mind.free_spell_unbinds)
			user_mind.has_changed_spell = FALSE
			return
	if(user_mind.free_spell_unbinds < unbind_limit || (!resettable_spells.len && user_mind.strained_spell_unbinds < 2))
		return
	var/obj/item/active_item = user.get_active_held_item()
	var/obj/item/inactive_item = user.get_inactive_held_item()
	var/obj/item/held_lux
	if(active_item != src && (istype(active_item, /obj/item/reagent_containers/lux) || istype(active_item, /obj/item/reagent_containers/lux_impure)))
		held_lux = active_item
	else if(inactive_item != src && (istype(inactive_item, /obj/item/reagent_containers/lux) || istype(inactive_item, /obj/item/reagent_containers/lux_impure)))
		held_lux = inactive_item
	if(!user_mind.has_fed_spellbook_lux && (istype(held_lux, /obj/item/reagent_containers/lux) || istype(held_lux, /obj/item/reagent_containers/lux_impure)))
		var/lux_prompt = "THE SYMBOLS ON THE PAGE GLOW AND VIBRATE, AS IF THEY'RE LEECHED TOWARDS YOUR OTHER HAND..\n\nFEED THE BOOK WITH LUX?"
		if(alert(user, lux_prompt, "THE TOME HUNGERS", "FEED THE BOOK", "NAY") == "FEED THE BOOK")
			if(!do_after(user, 5 SECONDS, target = src))
				return
			if(user.get_active_held_item() != held_lux && user.get_inactive_held_item() != held_lux)
				to_chat(user, span_warning("The tome's symbols dim as the lux leaves my hand."))
				return
			playsound(user, 'sound/magic/charged.ogg', 75, TRUE)
			user_mind.has_fed_spellbook_lux = TRUE
			qdel(held_lux)
			var/lux_choice = input(user, "Choose a spell to unbind.") as null|anything in resettable_spells
			var/obj/effect/proc_holder/spell/lux_item = resettable_spells[lux_choice]
			if(!lux_item)
				return
			var/lux_spell_cost = lux_item.cost
			if(user_mind.RemoveSpell(lux_item))
				user_mind.used_spell_points -= lux_spell_cost
				resettable_spells.Remove(lux_choice)
				user_mind.check_learnspell()
			return
	if(user_mind.strained_spell_unbinds >= 3) // shouldn't actually happen because of the previous limit check, but just to be safe.
		to_chat(user, span_warning("The tome's symbols lie still. I can force nothing more from them today."))
		return
	var/strain = user_mind.strained_spell_unbinds + 1
	var/prompt
	switch(strain)
		if(1)
			prompt = "THE SYMBOLS ON THE PAGE PULSATE INQUISITIVELY. YOU MAY BE ABLE TO UNBIND ANOTHER SPELL, BUT IT WILL LEAVE A COST ON YOUR MIND."
		if(2)
			prompt = "THE SYMBOLS ON THE PAGE PULSATE HUNGRILY. YOU MAY BE ABLE TO UNBIND ANOTHER SPELL, BUT IT WILL LEAVE A WITHERING, EXSANGUINATED COST ON YOUR SPIRIT. \n\n (WARNING: THIS WILL LYFE END YOU WITHOUT PREPARATION!!)"
		if(3)
			prompt = "THE SYMBOLS ON THE PAGE PULSATE GREEDILY. YOU MAY BE ABLE TO UNBIND ANOTHER SPELL, BUT IT WILL LEAVE A DIRE, FATAL COST ON YOUR BODY.\n\n(WARNING: THIS WILL LYFE END YOU!!)"
	if(alert(user, prompt, "THE TOME BECKONS", "PUSH FORWARD", "NAY") != "PUSH FORWARD")
		return
	if(!do_after(user, 5 SECONDS, target = src))
		return
	user_mind.strained_spell_unbinds++
	if(strain == 3)
		var/turf/death_turf = get_turf(user)
		user.emote("scream", forced = TRUE)
		to_chat(user, span_bigbold(span_userdanger("MY BODY TWISTS AND CONTORTS.. THIS WAS A MISTAKE!!")))
		playsound(user, 'sound/magic/fleshtostone.ogg', 100, TRUE)
		if(ishuman(user))
			var/mob/living/carbon/human/twisted_user = user
			for(var/obj/item/bodypart/bodypart in twisted_user.bodyparts)
				bodypart.add_wound(/datum/wound/fracture)
		user.adjustBruteLoss(5000)
		if(user.stat != DEAD)
			user.death()
		new /obj/item/reagent_containers/lux_impure(death_turf)
		if(istype(death_turf, /turf/open/floor/rogue/dirt))
			new /obj/structure/flora/roguegrass/herb/manabloom(death_turf) // remember us.. remember that we once lived..
		return
	playsound(user, 'sound/magic/charged.ogg', 75, TRUE)
	switch(strain)
		if(1)
			user.apply_status_effect(/datum/status_effect/debuff/mana_burden)
		if(2)
			user.apply_status_effect(/datum/status_effect/debuff/mana_toxicity)
			if(iscarbon(user))
				var/mob/living/carbon/bloodless_user = user
				bloodless_user.blood_volume = 0 // everything has a price.
	var/choice = input(user, "Choose a spell to unbind.") as null|anything in resettable_spells
	var/obj/effect/proc_holder/spell/item = resettable_spells[choice]
	if(!item)
		return
	var/spell_cost = item.cost
	if(user_mind.RemoveSpell(item))
		user_mind.used_spell_points -= spell_cost
		resettable_spells.Remove(choice)
		user_mind.check_learnspell()

/obj/item/book/spellbook/proc/get_cdr()
	if(born_of_rock)
		return ROCK_CHARGE_REDUCTION
	else
		return GEM_CHARGE_REDUCTION

/obj/item/book/spellbook/attack_right(mob/user)
	if(!picked)
		var/list/designlist = list("green", "yellow", "brown", "steel", "gem", "skin", "mimic", "wyrdbark", "sunfire", "abyssal", "cinder", "vessel", "edgebound", "sovereign")
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

/// Book slapcrafting

/obj/item/spellbook_unfinished
	var/pages_left = 4
	name = "bound scrollpaper"
	dropshrink = 0.6
	icon = 'icons/roguetown/items/books.dmi'
	icon_state ="basic_book_0"
	desc = "Thick scroll paper bound at the spine. It lacks pages."
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
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
					newbook.desc += " Traces of [P] dust linger in its margins."
					qdel(P)
					qdel(src)
				else
					if(prob(1))
						playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
						user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder seeps into the [src]."), \
							span_notice("By the Ten! That gem just exploded -- and my useless tome is filled with gleaming energy and strange letters!"))
						var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
						newbook.desc += " Traces of [P] dust linger in its margins."
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
						newbook.born_of_rock = TRUE
						newbook.desc += " Traces of multicolored stone limn its margins."
						qdel(P)
						qdel(src)
					else
						if (prob(the_rock.magic_power)) // for reference, this is never higher than 15 and usually significantly lower
							playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
							user.visible_message(span_warning("[user] carefully sets down [the_rock] upon [src]. Nothing happens for a moment or three, then suddenly, the glow surrounding the stone becomes as liquid, seeps down and soaks into the tome!"), \
							span_notice("I knew this stone was special! Its colourful magick has soaked into my tome and given me gift of mystery!"))
							to_chat(user, span_notice("...what in the world does any of this scribbling possibly mean?"))
							var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
							newbook.born_of_rock = TRUE
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
