//These guys get miracles AND a set of pre-learned spells AND anti-magic.
//They don't need much else. They're stupid powerful.
//Do not numberfuck them if you can help it. I beg you.
/datum/advclass/sojourner
	name = "Sojourner"
	tutorial = "Naledi scholars, bereft of their home, were sent around Grimoria searching for purpose. They'd found it in Otava, \
	within the hallowed halls that honed their gifts and refined the knowledge they'd held. Attached to the Inquisitor, you've one purpose. \
	Show them that the fall wasn't pointless."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/sojourner
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_INQUISITION)
	subclass_social_rank = SOCIAL_RANK_MINOR_NOBLE
	traits_applied = list(
		TRAIT_MAGEARMOR,
		TRAIT_ALCHEMY_EXPERT
	)
	subclass_stats = list(//This does not follow the typical 8 stat setup.
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_STR = -1,
		STATKEY_SPD = -1,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass has a unique spell, in the form of an 'arcyne barrier'. So long as it's active, the user is immune to magic, yet still capable of casting it."

/datum/outfit/job/roguetown/sojourner
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/sojourner/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
//So it's first.
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.
//Now we do the spells. If this turns out to be absurd, we tone it back. Simple as. But with poor stats and skills...
//This is 26 spellpoints in total, not counting their barrier, which is unique and unobtanium, but 3, which puts it to 29.
//For context, Heirophant gets 25 total, with 6 of those being liquid free spellpoints.
	if(H.mind)
		//Integral spells.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/conjure_armor/barrier)//Anti-magic.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/message)
		//Buff spells, next.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/guidance)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/hawks_eyes)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stoneskin)
		//Now, utility. Consider removing fetch, if fetch-slow is absurd. But that's the case for any mage.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/forcewall/greater)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)
		//Frost spells. Slowdown city. Hue city. Frigid. Or something.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/snap_freeze)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/frostbolt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/frostbite)//Used by Sojourners only.

	head = /obj/item/clothing/head/roguetown/roguehood/sojourner
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi/sojourner
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/naledi
	neck = /obj/item/clothing/neck/roguetown/psicross/g //Naledians covet gold far more than the Orthodoxists cover silver. Emphasizes their nature as 'visitors', more-so than anything else.
	id = /obj/item/clothing/ring/signet
	r_hand = /obj/item/rogueweapon/woodstaff/diamond/blacksteelstaff
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	belt = /obj/item/storage/belt/rogue/leather/rope/dark
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	cloak = /obj/item/clothing/cloak/psydontabard/alt
	backpack_contents = list(/obj/item/roguekey/inquisition = 1,
	/obj/item/paper/inqslip/arrival/ortho = 1,
	/obj/item/roguegem/amethyst/naledi = 1,
	/obj/item/spellbook_unfinished/pre_arcyne = 1)
