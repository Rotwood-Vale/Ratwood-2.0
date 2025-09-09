/datum/job/roguetown/hand
	title = "Hand"
	flag = HAND
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = RACES_SHUNNED_UP	//No noble constructs.
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/hand
	advclass_cat_rolls = list(CTAG_HAND = 20)
	display_order = JDO_HAND
	tutorial = "Whether by outstanding merit or petty favoritism, you are the Archduke’s most trusted representative and advisor. Your authority is second only to the Archduke themselves. The weight of your words can shape policy, stir conflict, or silence dissent. Let none forget whose will you carry, and do not fail your benefactor."
	whitelist_req = TRUE
	give_bank_account = 44
	noble_income = 22
	min_pq = 9 //The second most powerful person in the realm...
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/cmode/nobility/combat_spymaster.ogg'
	job_traits = list(TRAIT_NOBLE)
	job_subclasses = list(
		/datum/advclass/hand/hand,
		/datum/advclass/hand/spymaster,
		/datum/advclass/hand/advisor
	)

/datum/outfit/job/roguetown/hand
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/steel
	beltr = /obj/item/rogueweapon/scabbard/sword
	beltl = /obj/item/rogueweapon/scabbard/sheath
	job_bitflag = BITFLAG_ROYALTY

/datum/job/roguetown/hand/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
	
		addtimer(CALLBACK(src, PROC_REF(know_agents), H), 50)

/datum/job/roguetown/hand/proc/know_agents(var/mob/living/carbon/human/H)
	if(!GLOB.court_agents.len)
		to_chat(H, span_notice("You begun the week with no agents."))
	else
		to_chat(H, span_notice("We begun the week with these agents:"))
		for(var/name in GLOB.court_agents)
			to_chat(H, span_notice(name))



/datum/advclass/hand/hand
	name = "Hand"
	tutorial = "You serve as both soldier and strategist to the Noble-Family, wielding steel and intrigue with potent ability. Let no man forget whose ear you whisper into, your stratagems have claimed more lives than any spymaster's plots ever could."
	outfit = /datum/outfit/job/roguetown/hand/handclassic

	category_tags = list(CTAG_HAND)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 3,
		STATKEY_STR = 2
	)

//Classical hand start - same as before, nothing changed. 
/datum/outfit/job/roguetown/hand/handclassic/pre_equip(mob/living/carbon/human/H)
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	backr = /obj/item/storage/backpack/rogue/satchel/black
	l_hand = /obj/item/rogueweapon/huntingknife/idagger/dtace
	r_hand = /obj/item/rogueweapon/sword/rapier/dec
	backpack_contents = list(
		/obj/item/storage/keyring/hand = 1
		)
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/hand
	pants = /obj/item/clothing/under/roguetown/tights/black
	id = /obj/item/scomstone/garrison
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 1, TRUE)

/datum/advclass/hand/spymaster
	name = "Spymaster"
	tutorial = "You serve as both spymaster and confidant to the Noble-Family, wielding cloak and dagger schemes with potent ability. Let no man forget whose ear you whisper into, your plots have claimed more lives than any strategist's steel ever could."
	outfit = /datum/outfit/job/roguetown/hand/spymaster

	category_tags = list(CTAG_HAND)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_DODGEEXPERT, TRAIT_PERFECT_TRACKER)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_PER = 2,
		STATKEY_INT = 2,
		STATKEY_STR = -1,
	)

//Spymaster start. More similar to the rogue adventurer - loses heavy armor and sword skills for more sneaky stuff. 
/datum/outfit/job/roguetown/hand/spymaster/pre_equip(mob/living/carbon/human/H)
	backr = /obj/item/storage/backpack/rogue/satchel/black
	l_hand = /obj/item/rogueweapon/huntingknife/idagger/dtace
	r_hand = /obj/item/rogueweapon/sword/rapier/dec
	backpack_contents = list(
		/obj/item/storage/keyring/hand = 1,
		/obj/item/lockpickring/mundane = 1
		)
	if(H.dna.species.type in NON_DWARVEN_RACE_TYPES)
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/shadowrobe
		cloak = /obj/item/clothing/cloak/half/shadowcloak
		gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves
		mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask
		pants = /obj/item/clothing/under/roguetown/trou/shadowpants
		id = /obj/item/scomstone/garrison
	else
		cloak = /obj/item/clothing/cloak/raincloak/mortus //cool spymaster cloak
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
		backr = /obj/item/storage/backpack/rogue/satchel/black
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/hand
		pants = /obj/item/clothing/under/roguetown/tights/black
		id = /obj/item/scomstone/garrison
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 5, TRUE) // not like they're gonna break into the vault.
	H.grant_language(/datum/language/thievescant)

/datum/advclass/hand/advisor
	name = "Advisor"
	tutorial = "You serve as both scholar and advisor to the Noble-Family, wielding knowledge and magicks with potent ability. Let no man forget whose ear you whisper into, your sage advice has saved more lives than any strategist’s orders or spymaster’s schemes could ever claim to."
	outfit = /datum/outfit/job/roguetown/hand/advisor

	category_tags = list(CTAG_HAND)
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T2)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 3,
	)

//Advisor start. Trades combat skills for more knowledge and skills - for older hands, hands that don't do combat - people who wanna play wizened old advisors. 
/datum/outfit/job/roguetown/hand/advisor/pre_equip(mob/living/carbon/human/H)
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	backr = /obj/item/storage/backpack/rogue/satchel/black
	l_hand = /obj/item/rogueweapon/huntingknife/idagger/dtace
	r_hand = /obj/item/rogueweapon/sword/rapier/dec
	backpack_contents = list(
		/obj/item/storage/keyring/hand = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1 //starts with a vial of poison, like all wizened evil advisors do!
		)
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/hand
	pants = /obj/item/clothing/under/roguetown/tights/black
	id = /obj/item/scomstone/garrison
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE)
	if(H.mind)
		H.mind.adjust_spellpoints(15)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	if(H.age == AGE_OLD)
		H.change_stat(STATKEY_SPD, -1)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_INT, 1)
		H.change_stat(STATKEY_PER, 1)
		H.mind?.adjust_spellpoints(3)


