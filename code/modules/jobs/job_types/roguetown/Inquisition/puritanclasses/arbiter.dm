//The Arbiter. It leans entirely into the martial miracle setup.
//They get the full set, as a pseudo-flagellant.
//Think of it like the radical, obsessive faith guy. Old puritan.
//Middling skills. Half-half stats. A niche. Outside of their miracles.
/datum/advclass/puritan/arbiter
	name = "Arbiter"
	tutorial = "Unlike Ordinators or Inspectors, Arbiters serve an entirely different purpose. \
	Drawn from a flock of warrior-priests, they still fight to this day within rot-scoured lands. Uniquely attuned to the rot's touch. \
	With the aid of rare and dangerous greater miracles, they sniff out the taint. One heretic at a time, to be put to a pyre."
	outfit = /datum/outfit/job/roguetown/puritan/arbiter
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_PURITAN)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_MEDIUMARMOR,
		TRAIT_SILVER_BLESSED,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_INQUISITION,
		TRAIT_PURITAN,
		TRAIT_OUTLANDER
		)//-1 stats over Ordinator/Inspector, if counting STR/SPD as 2 each. +1 over in a respective area when selecting their sect.
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/puritan/arbiter/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
	cloak = /obj/item/clothing/cloak/cape/inquisitor
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/arbiter
	belt = /obj/item/storage/belt/rogue/leather/arbiter
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/arbiter
	backr =  /obj/item/storage/backpack/rogue/satchel/otavan
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltl = /obj/item/quiver/bolts
	mask = /obj/item/clothing/mask/rogue/sack/psy/arbiter
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	id = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/storage/keyring/puritan = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/paper/inqslip/arrival/inq = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3) //Capped to T1 miracles.
	if(H.mind)//The entire spread of greater miracles, barring the lux bolt. For obvious reasons.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_retribution)//Rebuke, but blood cost and worse.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_inspire)//CtA, but blood cost and... kind of worse.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_inviolability)//A shield against the undead.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_sacrosanctity)//To get your blood back, m'lord.

/datum/outfit/job/roguetown/puritan/arbiter/choose_loadout(mob/living/carbon/human/H)
	. = ..()//Just as with the stats, this has a mixture of weapon choice between Ordinators and Inspectors. A less-used weapon list.
	var/weapons = list("Psydonic Broadsword", "Daybreak (Whip)", "Stigmata (Halberd)", "Consecratia (Flail)")
	var/weapon_choice = input(H,"FIND YOUR TRUTHS.", "WIELD THEM IN HIS NAME.") as anything in weapons
	switch(weapon_choice)
		if("Psydonic Broadsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/kriegmesser/psy/preblessed(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Daybreak (Whip)")
			H.put_in_hands(new /obj/item/rogueweapon/whip/antique/psywhip(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		if("Stigmata (Halberd)")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/psyhalberd/relic(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("Consecratia (Flail)")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail/psyflail/relic(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
	//Now, for their 'sect'. They can either choose a heavy gambeson and +1SPD, or inquisitor coat and +1STR.
	var/sect = list("Ancient - Gilbranze, Gambesons & Speed", "New Age - Silver, Overcoats & Strength")
	var/sect_choice = input(H,"FIND YOUR SECT", "WHAT ARE WE?") as anything in sect
	switch(sect_choice)
		if("Ancient - Gilbranze, Gambesons & Speed")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/arbiter, SLOT_HEAD, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/otavan/psygloves/arbiter, SLOT_GLOVES, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq/arbiter, SLOT_ARMOR, TRUE)
			H.change_stat(STATKEY_SPD, 1)//We'll probably drop this.
		if("New Age - Silver, Overcoats & Strength")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/arbiter/vice, SLOT_HEAD, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/otavan/psygloves/arbiter/vice, SLOT_GLOVES, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/arbiter, SLOT_ARMOR, TRUE)
			H.change_stat(STATKEY_STR, 1)//As above. But for now we'll see if it's ok.

/*
Below are the Arbiter's funny things.
Reused from OldRW. But cool. Soulful, even.
Here because they're unused elsewhere.
*/
/obj/item/storage/belt/rogue/leather/arbiter
	name = "webbing"
	desc = "A leather belt, paired with some Otavan style webbing and pouches. <br>\
	A style pioneered by an arbiters, a century or two ago. Maintained by those who require much of the same."
	icon_state = "overseerbelt"
	item_state = "overseerbelt"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	w_class = WEIGHT_CLASS_BULKY

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq/arbiter
	name = "arbiter gambeson"
	desc = "A heavy, padded gambeson that provides adequate protection against unarmed innocents. \
	It reeks of smokepowder and sulphur. Common of sanctification rituals."
	icon_state = "overseerjacket"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	sleeved = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/arbiter
	name = "arbiter brigandine"
	desc = "A heavy, reinforced brigandine coat. Set in a tasteful burgundy covering, backed by silver plating. \
	It's sure not to leave anyone indifferent, for they'll come to know it. In time."
	icon_state = "viceseercoat"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	sleeved = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	boobed = TRUE
	is_silver = TRUE

/obj/item/clothing/gloves/roguetown/otavan/psygloves/arbiter
	name = "arbiter gloves"
	desc = "Heavy, thick leather gloves, adorned with bright strips."
	icon_state = "overseergloves"
	item_state = "overseergloves"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'

/obj/item/clothing/gloves/roguetown/otavan/psygloves/arbiter/vice
	icon_state = "viceseergloves"
	item_state = "viceseergloves"

/obj/item/clothing/head/roguetown/helmet/arbiter
	name = "arbiter mask"
	desc = "An iconic, gilbranze mask, depicting the visage of Him. Weeping, as He is."
	icon_state = "overseermask"
	item_state = "overseermask"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	flags_inv = HIDEFACE
	body_parts_covered = FACE|HEAD|HAIR|EARS|NOSE
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	sewrepair = TRUE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/purifiedaalloy
	var/active_item = FALSE

/obj/item/clothing/head/roguetown/helmet/arbiter/vice
	desc = "An iconic, silver mask depicting the visage of Him. Weeping, as He is."
	icon_state = "viceseermask"
	item_state = "viceseermask"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

//The intent of the trait was to frighten heretics, if they saw the user with it present.
//Alas...
/obj/item/clothing/head/roguetown/helmet/arbiter/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		active_item = TRUE
//		ADD_TRAIT(user, TRAIT_ARBITER, TRAIT_GENERIC)
		to_chat(user, span_red("With such a mask over your face, all judgement is waived. For who but a heretic might argue your purpose?"))
	return

/obj/item/clothing/head/roguetown/helmet/arbiter/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
//	REMOVE_TRAIT(user, TRAIT_ARBITER, TRAIT_GENERIC)
	to_chat(user, span_red("As if flooded with sudden clarity, perhaps your actions might require a steady hand..."))

/obj/item/clothing/mask/rogue/sack/psy/arbiter
	name = "arbiter hood"
	desc = "You wouldn't hide your face if there was another way. It's not as if you've no reason for it. \
	Would they ever understand? Truly?"
	icon_state = "overseerhood"
	item_state = "overseerhood"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEEARS
	body_parts_covered = FACE|EARS|MOUTH|NECK
	slot_flags = ITEM_SLOT_MASK
	sewrepair = TRUE

/obj/item/clothing/under/roguetown/heavy_leather_pants/arbiter
	name = "heavy trousers"
	desc = "A pair of heavy, washed-out trousers in grey colors."
	icon_state = "overseerpants"
	item_state = "overseerpants"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	sleeved = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'

/obj/item/clothing/suit/roguetown/shirt/undershirt/arbiter
	icon_state = "overseershirt"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	sleeved = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	color = null
