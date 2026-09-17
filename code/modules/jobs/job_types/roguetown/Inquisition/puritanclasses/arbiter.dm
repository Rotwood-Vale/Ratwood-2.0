//The Arbiter. The Unassuming Chaplain. The Charming Reverend. The Secretly Jacked Minister.
//A full set of miracles, but not a fully-blown Absolver. You'll be able to hold your own if one is missing.
//Meant to appear as an honest bureaucrat, and not a zealous witch-hunter or a platebeast psychopath.
//Deceiving Meekness and Intellectual. Combat-Capable, although you truly shine when you "inspire" your orthodoxists. With money. Because you're obscenely rich. 
/datum/advclass/puritan/arbiter
	name = "Arbiter"
	tutorial = "You are a humble, yet venerated warrior-priest, specially trained by the sacred Order of Saint Vicquemare in ENDVRING the harshest of environments to spread the word of HIM. \
	Some join in missionary efforts, whilst others operate alone in monastic travels. Despite their sociability and immense funding from the order, most Arbiters work alone. \
	You have chosen a different path - enrolling as a Bureaucrat of the Otavan Embassy, you intend on seeking out the rot from within, manipulating their turmoil to suit the needs of the Otavan Holy See."
	outfit = /datum/outfit/job/roguetown/puritan/arbiter
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/combat_arbiter.ogg'
	category_tags = list(CTAG_PURITAN)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_CRITICAL_RESISTANCE, //Light armor exclusive, they need this. 
		TRAIT_SILVER_BLESSED,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_INQUISITION,
		TRAIT_PURITAN,
		TRAIT_OUTLANDER,
		TRAIT_RITUALIST, //Mostly fluff, but made to deconvert people.
		TRAIT_DECEIVING_MEEKNESS, //guarded virtue to prevent others from seeing through your friendly facade
		TRAIT_INTELLECTUAL, //To assess your foes
		TRAIT_IGNOREDAMAGESLOWDOWN,
		TRAIT_NOBLE,
		)//Their faith is their shield. They don't need "armor" or "dodging". 
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 1,
		STATKEY_INT = 3,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER, //Sleeper build
		/datum/skill/misc/swimming = SKILL_LEVEL_MASTER, //The peak of athleticism
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER, //The Prelate gets master wrestling, why can't you?
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT, //I KICK ASS FOR GOD
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"Particularly Hefty Tome of Psydon" = /obj/item/rogueweapon/mace/cudgel/psyble
	)

/datum/job/roguetown/puritan/arbiter/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
//Title stuff. This is super sloppy.
		var/prev_real_name = H.real_name
		var/prev_name = H.name
//Default fallback title.
		var/title = "Reverend"
//Actual titles now, based on pronouns.
		switch(H.pronouns)
			if(SHE_HER)
				title = "Vestal"
			if(SHE_HER_M)
				title = "Vestal"
			if(HE_HIM)
				title = "Monseigneur"
			if(HE_HIM_F)
				title = "Monseigneur"
//Now apply the actual title.
		H.real_name = "[title] [prev_real_name]"
		H.name = "[title] [prev_name]"

//Inconspicuous outfit - this is intentional.
/datum/outfit/job/roguetown/puritan/arbiter/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/arbiter
	belt = /obj/item/storage/belt/rogue/leather/double
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	beltl = /obj/item/flashlight/flare/torch/lantern
	mask = /obj/item/clothing/mask/rogue/facemask/psydonmask
	head = /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns
	wrists = /obj/item/clothing/wrists/roguetown/bracers/arbiter
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	id = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/storage/keyring/puritan = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1,
		/obj/item/paper/inqslip/arrival/inq = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/scomstone = 1,
		)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)	//Minor regen, starts maxed out.
	if(H.mind)//The entire spread of greater miracles, barring the lux bolt. For obvious reasons.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_retribution)//Rebuke, but blood cost and worse.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_inspire)//CtA, but blood cost and... kind of worse.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_inviolability)//A shield against the undead.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_sacrosanctity)//To get your blood back, m'lord.

/datum/outfit/job/roguetown/puritan/arbiter/choose_loadout(mob/living/carbon/human/H)
	. = ..()//All of their weapon choices are easily-concealable.
	var/weapons = list("Blessed Psydonic Handmace", "Blessed Psydonic Shortsword", "Blessed Psydonic Knuckleduster")
	var/weapon_choice = input(H,"FIND YOUR TRUTHS.", "WIELD THEM IN HIS NAME.") as anything in weapons
	switch(weapon_choice)
		if("Blessed Psydonic Handmace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/psy/preblessed(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 5, TRUE)
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_PER, 1)
		if("Daybreak (Whip)")
			H.put_in_hands(new /obj/item/rogueweapon/whip/antique/psywhip(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 5, TRUE)
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_PER, 1)
		if("Blessed Psydonic Shortsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/psy/preblessed(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
			H.change_stat(STATKEY_STR, -1)
			H.change_stat(STATKEY_SPD, 2)
		if("Blessed Psydonic Knuckleduster")
			H.put_in_hands(new /obj/item/rogueweapon/knuckles/psydon/preblessed(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 5, TRUE)
	//The whole "Sect" shit was stupid and didn't work. Go pick between money or extra virtues.
	var/sect = list("MIND - Keen Ears & Cicerone", "MATTER - Extra Coinage & Financial Acumen")
	var/sect_choice = input(H,"FIND YOUR METHODOLOGY", "MIND OR MATTER?") as anything in sect
	switch(sect_choice)
		if("MIND - Keen Ears & Cicerone")
			ADD_TRAIT(H, TRAIT_KEENEARS, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)
		if("MATTER - Extra Coinage & Financial Acumen")
			H.equip_to_slot_or_del(new /obj/item/storage/belt/rogue/pouch/coins/veryrich, SLOT_BELT_R, TRUE)
			ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)

/*
Arbiter's old shit. 
It's ugly, unsprited, and generally just not desired by the community.
Commenting it out for now, just in case any inhand sprites get drawn.
*/

/*
/obj/item/storage/belt/rogue/leather/arbiter
	name = "webbing"
	desc = "A leather belt, paired with some Otavan style webbing and pouches. <br>\
	A style pioneered by an arbiters, a century or two ago. Maintained by those who require much of the same."
	icon_state = "overseerbelt"
	item_state = "overseerbelt"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	w_class = WEIGHT_CLASS_BULKY
	dropshrink = null

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq/arbiter
	name = "arbiter gambeson"
	desc = "A heavy, padded gambeson that provides adequate protection against unarmed innocents. \
	It reeks of smokepowder and sulphur. Common of sanctification rituals."
	icon_state = "overseerjacket"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	sleeved = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	dropshrink = null

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
	dropshrink = null

/obj/item/clothing/gloves/roguetown/otavan/psygloves/arbiter
	name = "arbiter gloves"
	desc = "Heavy, thick leather gloves, adorned with bright strips."
	icon_state = "overseergloves"
	item_state = "overseergloves"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	dropshrink = null

/obj/item/clothing/gloves/roguetown/otavan/psygloves/arbiter/vice
	icon_state = "viceseergloves"
	item_state = "viceseergloves"
	dropshrink = null

/obj/item/clothing/head/roguetown/helmet/arbiter
	name = "arbiter mask"
	desc = "An iconic gilbranze mask, depicting the visage of HIM. Weeping, as HE is."
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
	smeltresult = /obj/item/ingot/aaslag
	var/active_item = FALSE
	dropshrink = null

/obj/item/clothing/head/roguetown/helmet/arbiter/vice
	desc = "An iconic, silver mask depicting the visage of HIM. Weeping, as HE is."
	icon_state = "viceseermask"
	item_state = "viceseermask"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver
	dropshrink = null

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
	dropshrink = null

/obj/item/clothing/under/roguetown/heavy_leather_pants/arbiter
	name = "heavy trousers"
	desc = "A pair of heavy, washed-out trousers in grey colors."
	icon_state = "overseerpants"
	item_state = "overseerpants"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	sleeved = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	dropshrink = null

/obj/item/clothing/suit/roguetown/shirt/undershirt/arbiter
	icon_state = "overseershirt"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	sleeved = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	color = null
	dropshrink = null
*/
