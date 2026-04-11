//The Martyr is a WEAPON of the Church.
//There is no hopium to be had.
//You subsist off faith.
//You LYVE for the faith.
//You'll die for it, too.
/datum/job/roguetown/martyr
	title = "Martyr"
	department_flag = CHURCHMEN
	faction = "Station"
	tutorial = "Prayer. Conviction. Intent. \
	Words they'd drilled into your skull, from the moment of induction, up until your assignment as the Prelate's ward. \
	A crimson gild upon your soul, a taint that can't be cleared. For you are a weapon of the Holy See. No more. No less. \
	Defend the Prelate. Give up no hallowed ground. Die for the Ten."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	allowed_patrons = ALL_DIVINE_PATRONS
	outfit = /datum/outfit/job/roguetown/martyr
	min_pq = 10 //Cus it's a Martyr of the Ten. Get it.
	max_pq = null
	round_contrib_points = 4
	total_positions = 1
	spawn_positions = 1
	display_order = JDO_MARTYR
	social_rank = SOCIAL_RANK_NOBLE
	give_bank_account = TRUE

	cmode_music = 'sound/music/combat_martyrsafe.ogg'
	job_traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
		TRAIT_SILVER_BLESSED,
		TRAIT_EMPATH,
		TRAIT_MEDICINE_EXPERT,
		TRAIT_DUALWIELDER,
		TRAIT_VOTARY,
		TRAIT_CONVICTION
	)

	//No undeath-adjacent virtues for a role that can sacrifice itself. The Ten like their sacrifices 'pure'.
	//They get those traits during sword activation, anyway.
	//Dual wielder is there to stand-in for ambidextrous in case they activate their sword in their off-hand.
	virtue_restrictions = list(/datum/virtue/utility/noble, /datum/virtue/combat/rotcured, /datum/virtue/utility/deadened,
	/datum/virtue/utility/deathless, /datum/virtue/combat/dualwielder, /datum/virtue/heretic/zchurch_keyholder)

	advclass_cat_rolls = list(CTAG_MARTYR = 2)
	job_subclasses = list(
		/datum/advclass/martyr
	)

/datum/advclass/martyr
	name = "Martyr"
	tutorial = "Prayer. Conviction. Intent. \
	Words they'd drilled into your skull, from the moment of induction, up until your assignment as the Prelate's ward. \
	A crimson gild upon your soul, a taint that can't be cleared. For you are a weapon of the Holy See. No more. No less. \
	Defend the Prelate. Give up no hallowed ground. Die for the Ten."
	outfit = /datum/outfit/job/roguetown/martyr/basic
	subclass_languages = list(/datum/language/grenzelhoftian)
	category_tags = list(CTAG_MARTYR)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_INT = 1
	)
	subclass_skills = list(
	//No, they don't get any miracles. Their miracle is being able to use their weapon at all.
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
	)
	extra_context = "This class allows the player to choose a unique boon on spawn, providing access to rare traits."

/datum/outfit/job/roguetown/martyr
	job_bitflag = BITFLAG_HOLY_WARRIOR
	has_loadout = TRUE//For their boons.

/datum/outfit/job/roguetown/martyr/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltr = /obj/item/storage/keyring/priest
	beltl = /obj/item/storage/belt/rogue/pouch/coins/rich
	r_hand = /obj/item/rogueweapon/scabbard/sword
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/shield/tower/holysee
	gloves = /obj/item/clothing/gloves/roguetown/chain
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	neck = /obj/item/clothing/neck/roguetown/bevor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/holysee
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/platelegs/holysee
	cloak = /obj/item/clothing/cloak/holysee
	head = /obj/item/clothing/head/roguetown/helmet/heavy/holysee
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/silver = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()

/datum/outfit/job/roguetown/martyr/basic/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/boons = list("Endurance", "Indefatigable", "Hollow")
	var/boon_choice = input(H,"Choose your BOON.", "TAKE UP THE SEE'S GIFT") as anything in boons
	switch(boon_choice)
//Generic boons.
		if("Endurance")//Hard dismemberment. Pair with ult for funny results.
			ADD_TRAIT(H, TRAIT_HARDDISMEMBER, TRAIT_GENERIC)
		if("Indefatigable")//Battle ready, which provides energy over time and you can remain in combat mode.
			ADD_TRAIT(H, TRAIT_BREADY, TRAIT_GENERIC)
		if("Hollow")//Magic isn't real.
			ADD_TRAIT(H, TRAIT_ANTIMAGIC, TRAIT_GENERIC)//While you're immune to it...
			ADD_TRAIT(H, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)//... you may NEVER cast magic.
			ADD_TRAIT(H, TRAIT_COUNTERCOUNTERSPELL, TRAIT_GENERIC)//Because it's funny.
//Patron boons. LATER.
