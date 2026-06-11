/datum/job/roguetown/druid
	title = "Druid"
	display_title = "德鲁伊"
	f_title = "Druidess"
	flag = DRUID
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 4
	spawn_positions = 4

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_patrons = ALL_DIVINE_PATRONS //gets set to dendor on the outfit anyways lol
	outfit = /datum/outfit/job/roguetown/druid
	social_rank = SOCIAL_RANK_YEOMAN
	tutorial = "你始终被荒野吸引，而荒野也同样回应着你。当那份召唤真正降临时，它来自 登多尔。你的庇主宣称自己统御一切自然，并承诺赐福给那些以祂之名为其领域带回平衡的人。森林才是你最自在的归处，你在那里与农家子弟们一同劳作……尽管有时，高墙之外的世界仍会在你灵魂深处唤起一股野性的渴望。"

	display_order = JDO_DRUID
	give_bank_account = TRUE
	min_pq = 0
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // this was originally druid music. i think its ok to have druids share it w/ wardens.

	//You're.. not REALLY a full-on church member, but being a druid implies you became a clergy-man of some sort; even if it's non-organized. So, still shouldn't be noble.
	virtue_restrictions = list(/datum/virtue/utility/noble)
	job_traits = list(TRAIT_SEEDKNOW, TRAIT_OUTDOORSMAN, TRAIT_RITUALIST, TRAIT_HOMESTEAD_EXPERT, TRAIT_WILDERNESSGUIDE, TRAIT_WOODWALKER)

	advclass_cat_rolls = list(CTAG_DRUID = 2)
	job_subclasses = list(
		/datum/advclass/druid
	)

/datum/advclass/druid
	name = "德鲁伊"
	tutorial = "你始终被荒野吸引，而荒野也同样回应着你。当那份召唤真正降临时，它来自 登多尔。 \
	你的庇主宣称自己统御一切自然，并承诺赐福给那些以祂之名为其领域带回平衡的人。 \
	森林才是你最自在的归处，你在那里与农家子弟们一同劳作……尽管有时，高墙之外的世界仍会在你灵魂深处唤起一股野性的渴望。"
	outfit = /datum/outfit/job/roguetown/druid/basic
	category_tags = list(CTAG_DRUID)
	subclass_languages = list(/datum/language/beast)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_PER = -1
	)
	subclass_skills = list(
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/druidic = SKILL_LEVEL_JOURNEYMAN, //Shapeshifting.
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT, //Druids know the forest and when it has been disturbed
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE, //To help them defend themselves with parrying
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE
	)

/datum/outfit/job/roguetown/druid
	name = "德鲁伊"
	jobtype = /datum/job/roguetown/druid
	allowed_patrons = list(/datum/patron/divine/dendor)
	has_loadout = TRUE

/datum/outfit/job/roguetown/druid/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	belt = /obj/item/storage/belt/rogue/leather/
	backr = /obj/item/rogueweapon/woodstaff
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/flashlight/flare/torch/lantern
	beltl = /obj/item/rogueweapon/whip //The whip itself is not often associated to many jobs. Druids feel like a thematic choice to have a self-defense whip
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff
	head = /obj/item/clothing/head/roguetown/dendormask
	id = /obj/item/clothing/neck/roguetown/psicross/dendor //Ring slot amulet for wildform so it is not dropping on the ground.
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
	backpack_contents = list(/obj/item/ritechalk, /obj/item/storage/keyring/churchie, /obj/item/seeds/treesap)
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/magic/holy, 5, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/magic/druidic, 5, TRUE)
	H.ambushable = FALSE

/datum/outfit/job/roguetown/druid/basic/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.put_in_hands(new /obj/item/rogueweapon/woodstaff(H)) //To encourage them to wander the forests and to help defend themselves

/datum/job/roguetown/druid/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	H.advsetup = 1
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")

	spawn(50)
		if(H && H.client)
			_delayed_path_choice(H)

/datum/job/roguetown/druid/proc/grant_old_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return

	REMOVE_TRAIT(H, TRAIT_CLERGYRADICAL, "job")
	H.reset_clergy_devotion(CLERIC_T4, CLERIC_REGEN_MAJOR, TRUE, CLERIC_REQ_4)
	to_chat(H, span_notice("我仍行于古老的虔信之道。"))

/datum/job/roguetown/druid/proc/grant_radical_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return

	ADD_TRAIT(H, TRAIT_CLERGYRADICAL, "job")
	H.miracle_points += 3
	H.church_favor += 1600
	H.reset_clergy_devotion(CLERIC_T4, CLERIC_REGEN_MAJOR, TRUE, CLERIC_REQ_4)
	to_chat(H, span_notice("我拥抱激进之路。"))

/datum/job/roguetown/druid/proc/_delayed_path_choice(mob/living/carbon/human/H)
	if(!H || !H.client || !H.mind)
		return

	var/choice = alert(H, "选择你的道路。", "德鲁伊教义", "守旧派", "激进派")

	if(choice == "激进派")
		grant_radical_path(H)
	else
		grant_old_path(H)
