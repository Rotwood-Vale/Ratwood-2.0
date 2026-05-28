/obj/structure/ritualcircle/matthios/proc/matthiosarmaments(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_COMMIE))
		loc.visible_message(span_cult("THE RITE REJECTS ONE WITHOUT GREED IN THEIR HEART!!"))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
	target.emote("Agony")
	playsound(loc, 'sound/misc/smelter_fin.ogg', 50)
	if(HAS_TRAIT(target, TRAIT_INFINITE_STAMINA) || (target.mob_biotypes & MOB_UNDEAD))
		loc.visible_message(span_cult("[target]'s rotten lux pours from their nose like viscous tar, sizzling and bubbling around the rune. The solution erupts upwards, searing their skin!"))
		target.adjustFireLoss(200) //This gets spread across all limbs, 500+ is needed before it knocks someone out.
		playsound(src,'sound/misc/lava_death.ogg', rand(30,60), TRUE)
		return
	loc.visible_message(span_cult("[target]'s lux pours from their nose, into the rune, gleaming golds sizzles. Molten gold and metals swirl into armor, seered to their skin."))
	spawn(20)
		playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
		target.equipOutfit(/datum/outfit/job/roguetown/gildedrite)
		target.apply_status_effect(/datum/status_effect/debuff/devitalised)
		if(!HAS_TRAIT(target, TRAIT_OVERTHERETIC))
			ADD_TRAIT(target, TRAIT_OVERTHERETIC, TRAIT_MIRACLE)
		spawn(40)
			to_chat(target, span_cult("More to the maw, this shall help feed our greed."))

/// Performs the de-noblification ritual, which requires a noble character in the center of the circle. TRUE on success, FALSE on failure.
/obj/structure/ritualcircle/matthios/proc/defenestration()
	var/mob/living/carbon/human/victim = null
	for(var/mob/living/carbon/human/H in get_turf(src))
		if(HAS_TRAIT(H, TRAIT_OUTLAW))
			continue

		if(!H.is_noble() || H.has_status_effect(/datum/status_effect/debuff/ritualdefiled))
			continue

		victim = H
		break

	if(!victim)
		return FALSE

	playsound(loc, 'sound/combat/gib (1).ogg', 100, FALSE, -1)
	loc.visible_message(span_cult("[victim]'s lux pours from their nose, into the rune... Transforming into freshly mint zennies!"))
	new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
	new /obj/item/roguecoin/silver/pile(get_turf(src))
	new /obj/item/roguecoin/silver/pile(get_turf(src))
	if(victim.mind?.assigned_role in GLOB.noble_positions) // Intentionally stacked with rulermob/regent/prince to get extra payout for royals
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
	// Draining nobility from the duke or the heirs increases payout and causes CHAOS. Astrata weeps!
	if((victim == SSticker.rulermob) || (victim == SSticker.regentmob) || (victim.mind?.assigned_role in list ("Prince", "Princess")))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		// Astrata loses her bearing due to this vile ritual
		priority_announce("The Noble Gift of Astrata was tainted! The Sun, she is weeping!", "Bad Omen", 'sound/misc/evilevent.ogg')
		var/datum/round_event_control/lightsout/E = new()
		E.req_omen = FALSE
		E.earliest_start = 0
		E.min_players = 0
		E.runEvent()

		var/datum/round_event_control/haunts/H = new()
		H.req_omen = FALSE
		H.earliest_start = 0
		H.min_players = 0
		if(LAZYLEN(GLOB.hauntstart))
			H.runEvent()

	victim.Stun(60)
	victim.Knockdown(60)
	to_chat(victim, span_userdanger("UNIMAGINABLE PAIN!"))
	victim.apply_status_effect(/datum/status_effect/debuff/ritualdefiled)

	to_chat(victim, span_userdanger("ASTRATA WEEPS!"))
	victim.emote("Agony")
	REMOVE_TRAIT(victim, TRAIT_NOBLE, TRAIT_GENERIC)
	REMOVE_TRAIT(victim, TRAIT_NOBLE, TRAIT_VIRTUE)
	ADD_TRAIT(victim, TRAIT_DEFILED_NOBLE, TRAIT_GENERIC)
	playsound(loc, 'sound/misc/evilevent.ogg', 100, FALSE, -1)
	to_chat(victim, span_cult("You feel your Astrata's gift of nobility stripped from you, the inhumen feasting upon it!"))
	return TRUE

/datum/outfit/job/roguetown/gildedrite/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/matthios
	pants = /obj/item/clothing/under/roguetown/platelegs/matthios
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/matthios
	gloves = /obj/item/clothing/gloves/roguetown/plate/matthios
	head = /obj/item/clothing/head/roguetown/helmet/heavy/matthios
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	backr = /obj/item/rogueweapon/flail/peasantwarflail/matthios
	H.mind.AddSpell(new /datum/action/cooldown/spell/mending/lesser)
