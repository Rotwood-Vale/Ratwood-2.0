/datum/job/roguetown/lady
	title = "Consort"
	flag = LADY
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	advclass_cat_rolls = list(CTAG_CONSORT = 20)

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	tutorial = "Whether through love, politics or guile, you have become the Grand Duke's most trusted confidant--and likely friend--throughout your marriage. Your loyalty and perhaps even your love will be tested this day... for the daggers that threaten your beloved are as equally pointed at your own throat."

	spells = list(/obj/effect/proc_holder/spell/self/convertrole/servant,
	/obj/effect/proc_holder/spell/self/grant_nobility)
	outfit = /datum/outfit/job/roguetown/lady

	display_order = JDO_LADY
	give_bank_account = 50
	noble_income = 22
	min_pq = 5
	max_pq = null
	round_contrib_points = 3
	advjob_examine = TRUE
	job_subclasses = list(
		/datum/advclass/lady/heartthrob,
		/datum/advclass/lady/sapio,
		/datum/advclass/lady/housespouse,
		/datum/advclass/lady/trophy
	)

/datum/advclass/lady/heartthrob
// swords-themed consort. since there's only one of them, it's better than suitor and prince. this will be a running theme.
	name = "Heartthrob"
	tutorial = "A former swordsman, either through battle or through bravado you won the Grand Duke's heart. Your sword arm may have gotten rusty with time, but you're still more than capable of showing any would-be assassins the meaning of 'til Death do us part'."
	outfit = /datum/outfit/job/roguetown/lady/heartthrob
	category_tags = list(CTAG_CONSORT)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_KEENEARS, TRAIT_DECEIVING_MEEKNESS, TRAIT_NOBLE)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_WIL = 2,
		STATKEY_SPD = 3,
		STATKEY_STR = -1,
		STATKEY_LCK = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/lady/heartthrob/pre_equip(mob/living/carbon/human/H) //tbd - ideally i don't want them to start with fantastic armor, but there's very little choice in medium armors. maybe i'll switch them to light instead?
	..()
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/storage/keyring/royal
	beltr = /obj/item/rogueweapon/scabbard/sword/noble
	backr = /obj/item/storage/backpack/rogue/satchel
	l_hand = /obj/item/rogueweapon/sword/rapier/dec
	id = /obj/item/scomstone/garrison
	if(should_wear_femme_clothes(H))
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
		armor = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
	else if(should_wear_masc_clothes(H))
		cloak = /obj/item/clothing/cloak/darkcloak/bear
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
//		SSticker.rulermob = H

/datum/advclass/lady/sapio
// wizard consort. better than wizard prince, not QUITE as good statswise as wizard duke or magic-wise as magos. also lacks access to alchemy expert.
	name = "Sapio"
	tutorial = "An intellectual of note, your wits and wiles captured the Grand Duke's attention, and later, their heart. They say love is the most powerful magic, but you're still not quite convinced it beats a fireball."
	outfit = /datum/outfit/job/roguetown/lady/sapio
	category_tags = list(CTAG_CONSORT)
	traits_applied = list(TRAIT_ARCYNE_T3, TRAIT_KEENEARS, TRAIT_INTELLECTUAL, TRAIT_NOBLE)
	subclass_stats = list( // 9 stats total, 6 without the leadership carrot. based on heartfelt magos. i'd consider -2 con too but that's rough.
		STATKEY_INT = 4,
		STATKEY_PER = 3,
		STATKEY_CON = -1,
		STATKEY_WIL = 2,
		STATKEY_STR = -2,
		STATKEY_LCK = 3,
	)
	subclass_spellpoints = 24
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/lady/sapio/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/storage/keyring/royal
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/woodstaff/emerald/blacksteelstaff/royal
	id = /obj/item/scomstone/garrison
	if(should_wear_femme_clothes(H))
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
		armor = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
		pants = /obj/item/clothing/under/roguetown/trou/formal/shorts
	else if(should_wear_masc_clothes(H))
		cloak = /obj/item/clothing/cloak/darkcloak/bear
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
		pants = /obj/item/clothing/under/roguetown/tights/black
	backpack_contents = list(
		/obj/item/roguegem/amethyst = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/recipe_book/magic = 1,
		/obj/item/chalk = 1,
	)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/message) 
//		SSticker.rulermob = H

/datum/advclass/lady/trophy
// This is just the regular Consort as it is right now, along with the ridiculous 15 points of extra stats.
	name = "Trophy"
	tutorial = "You were once an individual of some note. A Noble, an envoy, a suitor. Now, either for politics, metrics or just to save your - or your beloved's, skin, you're nothing but the Grand Duke's armpiece. Smile for the people, wave for the crowds, scheme from the shadows."
	outfit = /datum/outfit/job/roguetown/lady/trophy
	category_tags = list(CTAG_CONSORT)
	traits_applied = list(TRAIT_SEEPRICES, TRAIT_KEENEARS, TRAIT_LIGHT_STEP, TRAIT_NUTCRACKER, TRAIT_NOBLE)
	subclass_stats = list( // 10 stats total, 7 without the carrot. based on consort's current stat block.
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 2,
		STATKEY_LCK = 3,
	)
	subclass_skills = list(
	    /datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
	    /datum/skill/misc/sneaking = SKILL_LEVEL_LEGENDARY,
	    /datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
	    /datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	    /datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	    /datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	    /datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
	    /datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
	    /datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/lady/trophy/pre_equip(mob/living/carbon/human/H) //tbd - though this might just be fine as is, considering it's base consort
	..()
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltl = /obj/item/storage/keyring/royal
	beltr = /obj/item/rogueweapon/scabbard/sheath
	id = /obj/item/scomstone/garrison
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	handr = /obj/item/rogueweapon/huntingknife/idagger/steel
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		pants = /obj/item/clothing/under/roguetown/trou/formal/shorts
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
		cloak = /obj/item/clothing/cloak/darkcloak/bear
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/medicine,
		/obj/item/lockpick/goldpin,
	)
//		SSticker.rulermob = H

/datum/advclass/lady/housespouse
// Housewife RP class. 15 points of stats along with trophy because why not, honestly.
	name = "Homemaker"
	tutorial = "Through your caring ways and dutiful nature, you provide for your beloved and your children in the way you're best at. You're very aware that the household of your beloved is well-manned with servants to cook and clean, but you don't care. After all, food tastes much better when it's made with love."
	outfit = /datum/outfit/job/roguetown/lady/housespouse
	category_tags = list(CTAG_CONSORT)
	traits_applied = list(TRAIT_CICERONE, TRAIT_SEEDKNOW, TRAIT_KEENEARS, TRAIT_GOODLOVER, TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_NOBLE)
	subclass_stats = list( //10 stats total, 7 without carrot. based on senechal. high int for skill progression and crafting %
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
		STATKEY_STR = 1,
		STATKEY_LCK = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN, //so they can tend to their lovely garden ofc
	)

/datum/outfit/job/roguetown/lady/housespouse/pre_equip(mob/living/carbon/human/H) //tbd - something cute and homely but still noble.
	..()
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	beltl = /obj/item/storage/keyring/royal
	id = /obj/item/scomstone/garrison
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/cooking/pan
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
		pants = /obj/item/clothing/under/roguetown/trou/formal/shorts
		cloak = /obj/item/clothing/cloak/lordcloak/ladycloak
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
		cloak = /obj/item/clothing/cloak/darkcloak/bear
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/scissors/steel,
		/obj/item/needle,
		/obj/item/kitchen/rollingpin,
		/obj/item/rogueweapon/huntingknife/cleaver,
	)
//		SSticker.rulermob = H

/datum/job/roguetown/exlady
	title = "Consort Dowager"
	flag = LADY
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	display_order = JDO_LADY
	give_bank_account = TRUE

/datum/outfit/job/roguetown/lady
	job_bitflag = BITFLAG_ROYALTY

/obj/effect/proc_holder/spell/self/convertrole/servant
	name = "Recruit Servant"
	new_role = "Servant"
	overlay_state = "recruit_servant"
	recruitment_faction = "Servants"
	recruitment_message = "Serve the crown, %RECRUIT!"
	accept_message = "FOR THE CROWN!"
	refuse_message = "I refuse."
	recharge_time = 100

