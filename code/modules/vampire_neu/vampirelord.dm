/datum/antagonist/vampire/lord
	name = "Methuselah"
	roundend_category = "Vampires"
	antagpanel_category = "Vampire"
	job_rank = ROLE_VAMPIRE
	generation = GENERATION_METHUSELAH
	rogue_enabled = TRUE
	show_in_antagpanel = TRUE
	antag_hud_type = ANTAG_HUD_VAMPIRE
	antag_hud_name = "vamplord"
	confess_lines = list(
		"I AM ANCIENT!",
		"I AM THE LAND!",
		"ONE OF THE FIRST SIRES!",
	)
	show_in_roundend = TRUE
	var/ascended = FALSE

/datum/antagonist/vampire/lord/get_antag_cap_weight()
	return 3

/datum/antagonist/vampire/lord/on_gain()
	. = ..()
	addtimer(CALLBACK(owner.current, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "[name]"), 5 SECONDS)

	owner.unknow_all_people()
	for(var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)
	for(var/datum/mind/MF in get_minds("Vampire Spawn"))
		owner.i_know_person(MF)
		owner.person_knows_me(MF)

	var/mob/living/carbon/human/H = owner.current
	H.equipOutfit(/datum/outfit/job/vamplord)
	H.set_patron(/datum/patron/inhumen/zizo)
	H.verbs |= /mob/living/carbon/human/proc/demand_submission
	H.maxbloodpool += 3000
	H.adjust_bloodpool(3000)
	for(var/S in MOBSTATS)
		H.change_stat(S, 2)
	H.forceMove(pick(GLOB.vlord_starts))

/datum/antagonist/vampire/lord/greet()
	to_chat(owner.current, span_userdanger("I am ancient. I am the Land. And I am now awoken to trespassers upon my domain."))
	. = ..()

/datum/outfit/job/vamplord/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank_up_to(/datum/skill/magic/blood, 6, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/vampire
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltr = /obj/item/storage/belt/pouch/coins/veryrich
	head  = /obj/item/clothing/head/roguetown/vampire
	beltl = /obj/item/roguekey/vampire
	cloak = /obj/item/clothing/cloak/cape/puritan
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel/black
	l_hand = /obj/item/rogueweapon/sword/long/judgement/vlord
	H.ambushable = FALSE

/*------VERBS-----*/

// NEW VERBS
/mob/living/carbon/human/proc/demand_submission()
	set name = "Demand Submission"
	set category = "VAMPIRE"
	if(SSmapping.retainer.king_submitted)
		to_chat(src, span_warning("I am already the Master of [SSmapping.config.map_name]."))
		return

	var/mob/living/carbon/ruler = SSticker.rulermob

	if(!ruler || (get_dist(src, ruler) > 1))
		to_chat(src, span_warning("The Master of [SSmapping.config.map_name] is not beside me."))
		return

	if(ruler.stat <= CONSCIOUS)
		to_chat(src, span_warning("[ruler] is still conscious."))
		return

	switch(alert(ruler, "Submit and Pledge Allegiance to [name]?", "SUBMISSION", "Yes", "No"))
		if("Yes")
			SSmapping.retainer.king_submitted = TRUE
		if("No")
			to_chat(ruler, span_boldnotice("I refuse!"))
			to_chat(src, span_boldnotice("[p_they(TRUE)] refuse[ruler.p_s()]!"))

/mob/living/carbon/human/proc/punish_spawn()
	set name = "Punish Minion"
	set category = "VAMPIRE"

	var/list/possible = list()
	for(var/datum/mind/V in SSmapping.retainer.vampires)
		if(V.special_role == "Vampire Spawn")
			possible[V.current.real_name] = V.current
	for(var/datum/mind/D in SSmapping.retainer.death_knights)
		possible[D.current.real_name] = D.current
	var/name_choice = input(src, "Who to punish?", "PUNISHMENT") as null|anything in possible
	if(!name_choice)
		return
	var/mob/living/carbon/human/choice = possible[name_choice]
	if(!choice || QDELETED(choice))
		return
	var/punishmentlevels = list("Pause", "Pain", "DESTROY")
	var/punishment = input(src, "Severity?", "PUNISHMENT") as null|anything in punishmentlevels
	if(!punishment)
		return
	switch(punishment)
		if("Pain")
			to_chat(choice, span_boldnotice("You are wracked with pain as your master punishes you!"))
			choice.apply_damage(30, BRUTE)
			choice.emote_scream()
			playsound(choice, 'sound/misc/obey.ogg', 100, FALSE, pressure_affected = FALSE)
		if("Pause")
			to_chat(choice, span_boldnotice("Your body is frozen in place as your master punishes you!"))
			choice.Paralyze(300)
			choice.emote_scream()
			playsound(choice, 'sound/misc/obey.ogg', 100, FALSE, pressure_affected = FALSE)
		if("DESTROY")
			to_chat(choice, span_boldnotice("You feel only darkness. Your master no longer has use of you."))
			addtimer(CALLBACK(choice, TYPE_PROC_REF(/mob/living, dust)), 10 SECONDS)
	visible_message(span_danger("[src] reaches out, gripping [choice]'s soul, inflicting punishment!"), ignored_mobs = list(choice))

////////Outfits////////
/obj/item/clothing/under/roguetown/platelegs/vampire
	name = "ancient plate greaves"
	desc = "Ornate greaves forged in the age of the Naledi war-scholars. The metal bears an unnatural sheen, as if the Sanguine Noctis itself flows through its surface."
	gender = PLURAL
	icon_state = "vpants"
	item_state = "vpants"
	sewrepair = FALSE
	armor = ARMOR_VAMP
	max_integrity = ARMOR_INT_LEG_ANTAG
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = PLATEHIT
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/roguetown/shirt/vampire
	slot_flags = ITEM_SLOT_SHIRT
	name = "regal silks"
	desc = "A set of ornate robes with a sash coming across the breast. The fabric appears impossibly preserved, woven with threads that seem to drink in the light—relics from an age when Naledi scholars walked the world."
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	icon_state = "vrobe"
	item_state = "vrobe"
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/head/roguetown/vampire
	name = "crown of darkness"
	desc = "A crown of blackened metal that seems to absorb light itself. Worn by those who bear the curse of the Sanguine Noctis, it symbolizes dominion over death and the eternal night."
	icon_state = "vcrown"
	body_parts_covered = null
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = null
	sellprice = 1000
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/roguetown/armor/chainmail/iron/vampire
	icon_state = "vunder"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	name = "ancient chain shirt"
	desc = "A chain shirt of impossible craftsmanship, each link cold to the touch. The chains seem to whisper of the ritual within the Umbra Chasm, where Archmagister Valerius first shed the blood of the god Psydon."
	body_parts_covered = COVERAGE_TORSO
	body_parts_inherent = FULL_BODY
	armor_class = ARMOR_CLASS_HEAVY
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PEEL, BCLASS_PIERCE, BCLASS_CHOP, BCLASS_LASHING, BCLASS_STAB)
	armor = ARMOR_VAMP
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/roguetown/armor/plate/vampire
	slot_flags = ITEM_SLOT_ARMOR
	name = "ancient ceremonial plate"
	desc = "Ceremonial armor worn during the profane rites of the First Sires. The metal is infused with the Sanguine Noctis, granting it strength beyond mortal understanding. Etched runes tell of the fall of the Naledi and the birth of eternal hunger."
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = FULL_BODY
	icon_state = "vplate"
	item_state = "vplate"
	armor = ARMOR_VAMP
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PEEL, BCLASS_PIERCE, BCLASS_CHOP, BCLASS_LASHING, BCLASS_STAB)
	nodismemsleeves = TRUE
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	allowed_sex = list(MALE, FEMALE)
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 40
	armor_class = ARMOR_CLASS_HEAVY
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/shoes/roguetown/boots/armor/vampire
	name = "ancient ceremonial plated boots"
	desc = "Heavy boots worn by the First Sires during their transformation. The metal plates are stained with an ancient darkness, forever marked by the corrupted Argentum that birthed the curse."
	body_parts_covered = FEET
	body_parts_inherent = FULL_BODY
	icon_state = "vboots"
	item_state = "vboots"
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PEEL, BCLASS_PIERCE, BCLASS_CHOP, BCLASS_LASHING, BCLASS_STAB)
	max_integrity = ARMOR_INT_LEG_ANTAG
	color = null
	blocksound = PLATEHIT
	armor = ARMOR_VAMP
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/head/roguetown/helmet/heavy/vampire
	name = "ancient ceremonial helm"
	desc = "A fearsome helm bearing the visage of Archmagister Valerius upon the visor. Forged from metals infused with the Sanguine Noctis, it grants the wearer a presence of terrible majesty—the face of one who defied divinity itself."
	icon_state = "vhelmet"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	body_parts_inherent = FULL_BODY
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PEEL, BCLASS_PIERCE, BCLASS_CHOP, BCLASS_LASHING, BCLASS_STAB)
	block2add = FOV_BEHIND
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/active_item = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/vampire/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == SLOT_HEAD)
		active_item = TRUE
		ADD_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)

/obj/item/clothing/head/roguetown/helmet/heavy/vampire/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	REMOVE_TRAIT(user, TRAIT_BITERHELM, TRAIT_GENERIC)

/obj/item/clothing/gloves/roguetown/chain/vampire
	name = "ancient ceremonial gloves"
	desc = "Gauntlets worn by the Naledi war-scholars who partook in the forbidden ritual. Each finger is encased in chains of unnatural cold, forever bound to the curse they embraced."
	icon_state = "vgloves"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	armor = ARMOR_VAMP
	body_parts_inherent = FULL_BODY
	max_integrity = ARMOR_INT_SIDE_ANTAG
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PEEL, BCLASS_PIERCE, BCLASS_CHOP, BCLASS_LASHING, BCLASS_STAB)

/obj/structure/vampire/necromanticbook // Used to summon undead to attack town/defend manor.
	name = "Tome of Souls"
	desc = "An ancient grimoire bound in leather of unknown origin. Its pages contain the secrets of the Sanguine Noctis—the knowledge to bind souls, command the dead, and bend reality to the will of those who bear the curse."
	icon_state = "tome"
	var/list/useoptions = list("Create Death Knight", "Steal the Sun")
	var/sunstolen = FALSE