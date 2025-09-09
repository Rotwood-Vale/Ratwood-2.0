/datum/job/roguetown/prince
	title = "Prince"
	f_title = "Princess"
	flag = PRINCE
	department_flag = YOUNGFOLK
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	f_title = "Princess"
	allowed_races = RACES_SHUNNED_UP //Maybe a system to force-pick lineage based on king and queen should be implemented. (No it shouldn't.)
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT)
	advclass_cat_rolls = list(CTAG_HEIR = 20)

	tutorial = "You've never felt the gnawing of the winter, never known the bite of hunger and certainly have never known a honest day's work. You are as free as any bird in the sky, and you may revel in your debauchery for as long as your parents remain upon the throne: But someday you'll have to grow up, and that will be the day your carelessness will cost you more than a few mammons."

	display_order = JDO_PRINCE
	give_bank_account = 30
	noble_income = 20
	min_pq = 1
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_noble.ogg'
	job_traits = list(TRAIT_NOBLE)
	job_subclasses = list(
		/datum/advclass/heir/daring,
		/datum/advclass/heir/bookworm,
		/datum/advclass/heir/aristocrat,
		/datum/advclass/heir/inbred,
		/datum/advclass/heir/scamp
	)

/datum/job/roguetown/prince/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	if(ishuman(H))
		var/mob/living/carbon/human/Q = H
		Q.advsetup = 1
		Q.invisibility = INVISIBILITY_MAXIMUM
		Q.become_blind("advsetup")

/datum/advclass/heir/daring
	name = "Daring Twit"
	tutorial = "You're a somebody, someone important. It only makes sense you want to make a name for yourself, to gain your own glory so people see how great you really are beyond your bloodline. Plus, if you're beloved by the people for your exploits you'll be chosen! Probably. Shame you're as useful and talented as a squire, despite your delusions to the contrary."
	outfit = /datum/outfit/job/roguetown/heir/daring
	category_tags = list(CTAG_HEIR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1,
	)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_NOBLE)

/datum/outfit/job/roguetown/heir/daring/pre_equip(mob/living/carbon/human/H)
	..()

	// Equipment choice - only affects clothing/gear, not skills
	var/equipment_choice = input(H, "Choose your equipment style", "Equipment Choice") as anything in list("Wartime Outfit", "Traditional Dress")

	if(equipment_choice == "Wartime Outfit")
		// Original daring twit equipment
		head = /obj/item/clothing/head/roguetown/circlet
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/royal
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
		belt = /obj/item/storage/belt/rogue/leather
		beltl = /obj/item/rogueweapon/sword/sabre
		beltr = /obj/item/storage/keyring/heir
		neck = /obj/item/storage/belt/rogue/pouch/coins/rich
		backr = /obj/item/storage/backpack/rogue/satchel
	else
		// Bookworm clothing/equipment only
		if(should_wear_masc_clothes(H))
			pants = /obj/item/clothing/under/roguetown/tights/random
			armor = /obj/item/clothing/suit/roguetown/armor/longcoat
			shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
		if(should_wear_femme_clothes(H))
			shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
		head = /obj/item/clothing/head/roguetown/circlet
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		beltr = /obj/item/storage/keyring/heir
		beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/special
		backr = /obj/item/storage/backpack/rogue/satchel
		shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
		mask = /obj/item/clothing/mask/rogue/spectacles
		neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	
	// Give 2 in every weapon skill regardless of equipment choice
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/slings, 2, TRUE)
		
	// Keep original non-weapon skills
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)

/datum/advclass/heir/bookworm
	name = "Introverted Bookworm"
	tutorial = "Despite your standing, sociability is not your strong suit, and you have kept mostly to yourself and your books. This hardly makes you a favourite among the lords and ladies of the court, and an exit from your room is often met with amusement from nobility and servants alike. But maybe... just maybe, some of your reading interests may be bearing fruit."
	outfit = /datum/outfit/job/roguetown/heir/bookworm
	traits_applied = list(TRAIT_ARCYNE_T1, TRAIT_MAGEARMOR)
	category_tags = list(CTAG_HEIR)
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
		STATKEY_CON = -1,
		STATKEY_LCK = 1,
	)

/datum/outfit/job/roguetown/heir/bookworm/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/random
		armor = /obj/item/clothing/suit/roguetown/armor/longcoat
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	head = /obj/item/clothing/head/roguetown/circlet
	belt = /obj/item/storage/belt/rogue/leather/cloth/lady
	beltr = /obj/item/storage/keyring/heir
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	backr = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	mask = /obj/item/clothing/mask/rogue/spectacles
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich

	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H.mind.adjust_spellpoints(9)

/datum/advclass/heir/aristocrat
	name = "Sheltered Aristocrat"
	tutorial = "Life has been kind to you; you've an entire keep at your disposal, servants to wait on you, and a whole retinue of guards to guard you. You've nothing to prove; just live the good life and you'll be a lord someday, too. A lack of ambition translates into a lacking skillset beyond schooling, though, and your breaks from boredom consist of being a damsel or court gossip."
	outfit = /datum/outfit/job/roguetown/heir/aristocrat
	traits_applied = list(TRAIT_SEEPRICES_SHITTY, TRAIT_GOODLOVER)
	category_tags = list(CTAG_HEIR)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_STR = -1,
		STATKEY_INT = 2,
		STATKEY_LCK = 1,
		STATKEY_SPD = 1
	)

/datum/outfit/job/roguetown/heir/aristocrat/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/heir
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	backr = /obj/item/storage/backpack/rogue/satchel
	if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
		belt = /obj/item/storage/belt/rogue/leather
		shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	if(should_wear_femme_clothes(H))
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		head = /obj/item/clothing/head/roguetown/hennin
		armor = /obj/item/clothing/suit/roguetown/armor/silkcoat
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)

/datum/advclass/heir/inbred
	name = "Inbred wastrel"
	tutorial = "Your bloodline ensures Psydon smiles upon you by divine right, the blessing of nobility... until you were born, anyway. You are a child forsaken, and even though your body boils as you go about your day, your spine creaks, and your drooling form needs to be waited on tirelessly you are still considered more important then the peasant that keeps the town fed and warm. Remind them of that fact when your lungs are particularly pus free."
	outfit = /datum/outfit/job/roguetown/heir/inbred
	traits_applied = list(TRAIT_CRITICAL_WEAKNESS, TRAIT_NORUN)
	category_tags = list(CTAG_HEIR)
	//They already can't run, no need to do speed and torture their move speed.
	subclass_stats = list(
		STATKEY_STR = -2,
		STATKEY_PER = -2,
		STATKEY_INT = -2,
		STATKEY_CON = -2,
		STATKEY_WIL = -2,
		STATKEY_LCK = -2
	)

/datum/outfit/job/roguetown/heir/inbred/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/keyring/heir
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	if(should_wear_femme_clothes(H))
		belt = /obj/item/storage/belt/rogue/leather/cloth/lady
		head = /obj/item/clothing/head/roguetown/hennin
		armor = /obj/item/clothing/suit/roguetown/armor/silkcoat
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
	H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, pick(0,0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)

/datum/advclass/heir/scamp
	name = "Nettlesome Scamp"
	tutorial = "The stories told to you by your bedside of valiant rogues and thieves with hearts of gold saving the worlds. The misunderstood hero. The clammor of Knights, the dull books of the arcyne and the wise never interested you. So you donned the cloak, and with your plump figure learned the arts of stealth. Surely the populace will be forgiving of your antics."
	outfit = /datum/outfit/job/roguetown/heir/scamp
	traits_applied = list(TRAIT_SEEPRICES_SHITTY)
	category_tags = list(CTAG_HEIR)
	//Not standard weighted. Not intended to be considering the stat ceilings. -F
	subclass_stats = list(
	STATKEY_STR = -3,
	STATKEY_CON = -3,
	STATKEY_SPD = 4,
	STATKEY_PER = 2,
	STATKEY_INT = 2,
	STATKEY_WIL = 1,
	STATKEY_LCK = 1,
	)
	adv_stat_ceiling = list(STAT_STRENGTH = 8, STAT_CONSTITUTION = 8, STAT_SPEED = 15)	//don't get caught

/datum/outfit/job/roguetown/heir/scamp/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/circlet
	mask = /obj/item/clothing/head/roguetown/roguehood/black
	neck = /obj/item/storage/keyring/heir
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/quiver/sling/iron
	beltr = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
	backr = /obj/item/storage/backpack/rogue/satchel
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/nightman
	cloak = /obj/item/clothing/cloak/half/shadowcloak

	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/lockpickring/mundane = 1,
	)
					
	H.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/slings, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
