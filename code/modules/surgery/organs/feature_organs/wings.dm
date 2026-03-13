/obj/item/organ/wings
	name = "wings"
	desc = "A pair of wings. Those may or may not allow you to fly... or at the very least flap."
	visible_organ = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_WINGS
	///Whether the wings should grant flight on insertion.
	var/unconditional_flight
	///What species get flights thanks to those wings. Important for moth wings
	var/list/flight_for_species
	///Whether a wing can be opened by the *wing emote. The sprite use a "_open" suffix, before their layer
	var/can_open
	///Whether an openable wing is currently opened
	var/is_open
	///Whether the owner of wings has flight thanks to the wings
	var/granted_flight

	icon = 'icons/mob/sprite_accessory/wings/wings_64x32.dmi'
	icon_state = "harpyfolded_FRONT"

//TODO: Well you know what this flight stuff is a bit complicated and hardcoded, this is enough for now

/obj/item/organ/wings/moth
	name = "fluvian wings"
	desc = "A pair of fuzzy moth wings."
	flight_for_species = list("moth")

/obj/item/organ/wings/dracon
	name = "drakian wings"
	desc = "A pair of majestic drakian wings."
//	flight_for_species = list("dracon") we'll revisit this later it's probably moth sprite only


/obj/item/organ/wings/anthro
	name = "wild-kin wings"

/obj/item/organ/wings/flight
	unconditional_flight = TRUE
	can_open = TRUE

/obj/item/organ/wings/flight/angel
	name = "angel wings"
	desc = "A pair of magnificent, feathery wings. They look strong enough to lift you up in the air."

/obj/item/organ/wings/flight/dragon
	name = "dragon wings"
	desc = "A pair of intimidating, membranous wings. They look strong enough to lift you up in the air."

/obj/item/organ/wings/flight/megamoth
	name = "megamoth wings"
	desc = "A pair of horrifyingly large, fuzzy wings. They look strong enough to lift you up in the air."

/obj/item/organ/wings/flight/night_kin
	name = "Vampire Wings"
	accessory_type = /datum/sprite_accessory/wings/large/gargoyle
	/// Flight datum
	var/datum/action/item_action/organ_action/use/flight/fly

/obj/item/organ/wings/harpy // we could... make it an arm subtype... but im lazy!
	name = "harpy wings"
	desc = "Oh, to fly again and feel the wind..."
	should_regenerate = TRUE
	var/list/nullspace_items = list()

/obj/item/organ/wings/harpy/Insert(mob/living/carbon/human/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(M.mind)
		if(isharpy(M))
			M.mind.AddSpell(new /obj/effect/proc_holder/spell/self/harpy_flight)
			src.nullspace_items += new /obj/item/rogueweapon/huntingknife/idagger/harpy_talons
			M.skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/harpy_skin
		else
			to_chat(M, span_bloody("I have the wings, yes... BUT HOW THE FARK DO I USE THEM?!!"))

/obj/item/organ/wings/harpy/Remove(mob/living/carbon/human/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(M.mind)
		M.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/harpy_flight)

/obj/effect/proc_holder/spell/self/harpy_flight
	name = "Harpy Flight"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	overlay_state = "zad"
	movement_interrupt = FALSE
	associated_skill = null
	antimagic_allowed = TRUE
	ignore_cockblock = TRUE
	recharge_time = 5
	miracle = FALSE
	var/baseline_stamina_cost = 9
	var/list/swoop_sound = list(
		'sound/foley/footsteps/flight_sounds/swooping1.ogg',
		'sound/foley/footsteps/flight_sounds/swooping2.ogg',
		'sound/foley/footsteps/flight_sounds/swooping3.ogg'
	)

/obj/effect/proc_holder/spell/self/harpy_flight/cast(mob/living/carbon/human/user)
	var/harpy_AC = user.highest_ac_worn()
	if(harpy_AC == ARMOR_CLASS_NONE)
		if(!user.buckled)
			if(!user.pulledby)
				if(!user.has_status_effect(/datum/status_effect/debuff/harpy_flight))
					if(user.mobility_flags & MOBILITY_STAND)
						if(!user.restrained(ignore_grab = FALSE))
							if(HAS_TRAIT(user, TRAIT_INFINITE_STAMINA))
								to_chat(user, span_bloody("I am too energetic to control my flight!</br>AGHH!!"))
								user.Knockdown(10)
							else
								user.visible_message(span_notice("[user] prepares to take flight."))
								if(do_after(user, 3 SECONDS))
									var/athletics_skill = max(user.get_skill_level(/datum/skill/misc/athletics), SKILL_LEVEL_NOVICE)
									var/stamina_cost_final = round((baseline_stamina_cost - athletics_skill), 1)
									user.apply_status_effect(/datum/status_effect/debuff/harpy_flight, stamina_cost_final)
									playsound(user, pick(swoop_sound), 100)
									user.emote("wingsfly", forced = TRUE)
									if(prob(1)) // somebody, call saint jiub!!
										playsound(user, 'sound/foley/footsteps/flight_sounds/cliffracer.ogg', 100)
						else
							to_chat(user, span_bloody("The chains are restricting my freedom!!"))
					else
						to_chat(user, span_bloody("I can't fly while imbalanced like this! AGHH!!"))
				else
					to_chat(user, span_bloody("Wah, back on the ground! How... quaint!!")) // sad emoji
					user.remove_status_effect(/datum/status_effect/debuff/harpy_flight)
					playsound(user, pick(swoop_sound), 100)
					user.emote("wingsfly", forced = TRUE)
			else
				to_chat(user, span_bloody("SOMEONE'S <b>HOLDING ME</b>, I CAN'T GET OFF THE GROUND LIKE THIS! </br> THE CRUELTY!!"))
		else
			to_chat(user, span_bloody("I CAN'T GET OFF THE GROUND WHILE... STUCK LIKE THIS!!"))
	else
		to_chat(user, span_bloody("THE ARMOR WEIGHS ME DOWN!!")) // LIGHT ON YO FEET SOULJA
