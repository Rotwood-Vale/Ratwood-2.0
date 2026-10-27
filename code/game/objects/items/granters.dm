
///books that teach things (intrinsic actions like bar flinging, spells like fireball or smoke, or martial arts)///

/obj/item/book/granter
	due_date = 0 // Game time in deciseconds
	unique = 1   // 0  Normal book, 1  Should not be treated as normal book, unable to be copied, unable to be modified
	var/list/remarks = list() //things to read about while learning.
	var/pages_to_mastery = 3 //Essentially controls how long a mob must keep the book in his hand to actually successfully learn
	var/reading = FALSE //sanity
	var/oneuse = TRUE //default this is true, but admins can var this to 0 if we wanna all have a pass around of the rod form book
	var/used = FALSE //only really matters if oneuse but it might be nice to know if someone's used it for admin investigations perhaps

/obj/item/book/granter/proc/turn_page(mob/user)
	playsound(user, pick('sound/blank.ogg'), 30, TRUE)
	if(do_after(user,50, user))
		if(remarks.len)
			to_chat(user, span_notice("[pick(remarks)]"))
		else
			to_chat(user, span_notice("I keep reading..."))
		return TRUE
	return FALSE

/obj/item/book/granter/proc/recoil(mob/user) //nothing so some books can just return

/obj/item/book/granter/proc/already_known(mob/user)
	return FALSE

/obj/item/book/granter/proc/on_reading_start(mob/user)
	to_chat(user, span_notice("I start reading [name]..."))

/obj/item/book/granter/proc/on_reading_stopped(mob/user)
	to_chat(user, span_notice("I stop reading..."))

/obj/item/book/granter/proc/on_reading_finished(mob/user)
	to_chat(user, span_notice("I finish reading [name]!"))

/obj/item/book/granter/proc/onlearned(mob/user)
	used = TRUE


/obj/item/book/granter/attack_self(mob/living/user)
	if(reading)
		to_chat(user, span_warning("I'm already reading this!"))
		return FALSE
	if(!user.can_read(src))
		return FALSE
	if(already_known(user))
		return FALSE
/*	AZURE PEAK REMOVAL -- UNUSED ANYWAY
	if(user.STAINT < 12)
			to_chat(user, span_warning("You can't make sense of the sprawling runes!"))
			return FALSE */
	if(used && oneuse)
		to_chat(user, span_warning("This fount of knowledge was not meant to be sipped from twice!"))
		recoil(user)
		return FALSE
	on_reading_start(user)
	reading = TRUE
	for(var/i=1, i<=pages_to_mastery, i++)
		if(!turn_page(user))
			reading = FALSE
			on_reading_stopped()
			return FALSE
	if(do_after(user, 50, user))
		reading = FALSE
		on_reading_finished(user)
		return TRUE
	reading = FALSE //failsafe
	return FALSE

/obj/item/book/granter/spell
	grid_width = 64
	grid_height = 32

	var/spell
	var/spellname = "conjure bugs"

/obj/item/book/granter/spell/already_known(mob/user)
	if(!spell)
		return TRUE
	if(user.mind.has_spell(spell, specific = TRUE))
		to_chat(user, span_warning("You've already read this one!"))
		return TRUE
	return FALSE

/obj/item/book/granter/spell/on_reading_start(mob/user)
	to_chat(user, span_notice("I start reading about casting [spellname]..."))

/obj/item/book/granter/spell/on_reading_finished(mob/user)
	to_chat(user, span_notice("I feel like you've experienced enough to cast [spellname]!"))
	var/datum/S = new spell
	user.mind.AddSpell(S)
	user.log_message("learned the spell [spellname] ([S])", LOG_ATTACK, color="orange")
	onlearned(user)

/obj/item/book/granter/spell/random
	icon_state = "random_book"

/obj/item/book/granter/spell/random/Initialize(mapload)
	. = ..()
	var/static/banned_spells = list(/obj/item/book/granter/spell/mimery_blockade)
	var/real_type = pick(subtypesof(/obj/item/book/granter/spell) - banned_spells)
	new real_type(loc)
	return INITIALIZE_HINT_QDEL

///ACTION BUTTONS///

/obj/item/book/granter/action
	var/granted_action
	var/actionname = "catching bugs" //might not seem needed but this makes it so you can safely name action buttons toggle this or that without it fucking up the granter, also caps

/obj/item/book/granter/action/already_known(mob/user)
	if(!granted_action)
		return TRUE
	for(var/datum/action/A in user.actions)
		if(A.type == granted_action)
			to_chat(user, span_warning("I already know all about [actionname]!"))
			return TRUE
	return FALSE

/obj/item/book/granter/action/on_reading_start(mob/user)
	to_chat(user, span_notice("I start reading about [actionname]..."))

/obj/item/book/granter/action/on_reading_finished(mob/user)
	to_chat(user, span_notice("I feel like you've got a good handle on [actionname]!"))
	var/datum/action/G = new granted_action
	G.Grant(user)
	onlearned(user)

//Crafting Recipe books

/obj/item/book/granter/crafting_recipe
	var/list/crafting_recipe_types = list()

/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	for(var/crafting_recipe_type in crafting_recipe_types)
		var/datum/crafting_recipe/R = crafting_recipe_type
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		to_chat(user,span_notice("I learned how to make [initial(R.name)]."))


/obj/item/book/granter/trait
	var/granted_trait = null
	var/required_language = null

/obj/item/book/granter/trait/attack_self(mob/living/user)
	if(required_language && !user.has_language(required_language))
		to_chat(user, span_warning("I can't make heads or tails of the writing in this book."))
		return FALSE
	return ..()

/obj/item/book/granter/trait/already_known(mob/user)
	if(!granted_trait)
		return TRUE
	if(HAS_TRAIT(user, granted_trait))
		to_chat(user, span_warning("I already know these techniques!"))
		return TRUE
	return FALSE

/obj/item/book/granter/trait/on_reading_start(mob/user)
	to_chat(user, span_notice("I start studying the diagrams and written techniques within..."))

/obj/item/book/granter/trait/on_reading_finished(mob/user)
	to_chat(user, span_notice("I feel I have grasped the techniques described in [name]."))
	ADD_TRAIT(user, granted_trait, TRAIT_GENERIC)
	onlearned(user)


/obj/item/book/granter/trait/kazengunite_smith
	name = "Kajutsu no Densho"
	desc = "A worn manual of Kazengunite smithing techniques, dense with diagrams and characters. The cover bears the mark of the Kouken order. Requires knowledge of Kazengunese to decipher."
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "basic_book_0"
	granted_trait = TRAIT_KAZENGUNITE_SMITH
	required_language = /datum/language/kazengunese
	pages_to_mastery = 10
	remarks = list(
		"The opening chapter describes the smelting of tamahagane — a bloom steel drawn from iron-rich sand fed slowly into a clay furnace over three days of unbroken fire. Only from this is true Kazengunite steel born.",
		"A dense passage explains tanren: the bloom is broken apart, sorted by carbon content, then folded repeatedly under the hammer. Each fold doubles the layers. The text warns against over-folding — too many passes burns away the very quality one seeks.",
		"The kobuse method is illustrated at length: a jacket of harder steel is wrapped around a softer core, then welded shut by hammer. The hard edge holds; the soft spine absorbs. Neither alone would suffice.",
		"Several pages are devoted to tsuchioki — the application of a clay and charcoal paste before quenching. Thick along the spine, thin along the edge. The differential cooling shapes the hardened zone, the yakiba.",
		"A vivid account of yaki-ire: the blade is heated until it no longer draws a magnet, then plunged edge-first into water. The author warns the smith to trust the colour of the steel, not the count of heartbeats.",
		"The armor chapters begin with kozane — individual scales no larger than a thumb, each pierced and lacquered many times over before assembly. The text emphasises that the lacquer is not decoration; it is armour against rust.",
		"Detailed instructions on odoshi follow: the silk or leather cords that lace the kozane together in offset rows. The pattern distributes force across the surface. An improperly laced row, the author notes, collapses under a single good blow.",
		"The kabuto section describes the shaping of the hachi — the bowl — from triangular plates riveted at their edges and finished with a turned peak. Each rivet must be peened flush, then lacquered over. A proud rivet will catch a blade.",
		"A short but precise section covers the kote — gauntlet construction. Chain segments are riveted between small rectangular plates along the back of the hand and fingers. The inside of the wrist is lined with padded fabric; the steel protects only what needs protecting.",
		"The final chapter addresses the nodowa, or gorget: rings of small chain, backed by a stiffened collar, fastened at the throat with a silk drawcord. The author notes that the gorget is the most often neglected piece, and the most often fatal omission.",
	)

//! --BLACKSTONE SCROLLS-- !/
/obj/item/book/granter/spell/fly
	name = "Scroll of Fly"
	desc = "Teaches you how to cast Fly."
	spell = /datum/action/cooldown/spell/fly
	spellname = "Fly"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scrolldarkred"
	oneuse = TRUE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'
	remarks = list("Volāre supra terram..", "Levitas mentis..", "Ascéndere in aethera..")

/obj/item/book/granter/spell/fly/onlearned(mob/living/carbon/user)
	..()
	if(oneuse)
		name = "siphoned scroll"
		desc = "A scroll once inscribed with magical scripture. The surface is now barren of knowledge, siphoned by someone else. It's utterly useless."
		icon_state = "scroll"
		user.visible_message(span_warning("[src] has had its magic ink ripped from the scroll!"))
