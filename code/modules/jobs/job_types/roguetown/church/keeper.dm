/datum/job/roguetown/keeper
	title = "Keeper"
	display_title = "守护人"
	tutorial = "有人容貌残缺、遭人厌弃，也有人只是满怀对 佩斯特拉 的使命感与虔敬。 \
	你们之中有些人严重畸变、毁容，或身染恶疾。 \
	但无论如何，即便是外表完好的人，也都能感受到那份代价正让自己的力量日渐萎缩。 \
	总得有人去采集净化 lux 所需的圣血，让 Pestra 赐下的医道得以延续。 \
	很不幸，那个人就是你。没错，你正是此地负责看护 Pestra 神圣心兽的人。 \
	你要研究它、滋养它，好让 Pestra 的医术即便在 Ferentia 最偏远的地方也能生根开花。 \
	记住，你并不直接隶属于圣座教会，本地主教不是你的上司。你首先服从的是 Pestra 的教派本身。"
	flag = KEEPER
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	allowed_races = ACCEPTED_RACES
	allowed_ages = ALL_AGES_LIST
	allowed_patrons = list(/datum/patron/divine/pestra)

	outfit = /datum/outfit/job/roguetown/keeper
	display_order = JDO_KEEPER
	give_bank_account = 1
	min_pq = 10
	max_pq = null
	round_contrib_points = 5

	job_traits = list(
		TRAIT_MEDICINE_EXPERT, TRAIT_HOMESTEAD_EXPERT,
		TRAIT_ALCHEMY_EXPERT, TRAIT_SEWING_EXPERT,
		TRAIT_SURVIVAL_EXPERT, TRAIT_NOSTINK,
		TRAIT_STEELHEARTED, TRAIT_RITUALIST,
	)

	//You're part of a Pestran sect. Not nobility.
	virtue_restrictions = list(/datum/virtue/utility/noble)

	advclass_cat_rolls = list(CTAG_KEEPER = 2)
	job_subclasses = list(
		/datum/advclass/keeper
	)

/datum/advclass/keeper
	name = "守护人"
	tutorial = "有人容貌残缺、遭人厌弃，也有人只是满怀对 佩斯特拉 的使命感与虔敬。 \
	你们之中有些人严重畸变、毁容，或身染恶疾。 \
	但无论如何，即便是外表完好的人，也都能感受到那份代价正让自己的力量日渐萎缩。 \
	总得有人去采集净化 lux 所需的圣血，让 Pestra 赐下的医道得以延续。 \
	很不幸，那个人就是你。没错，你正是此地负责看护 Pestra 神圣心兽的人。 \
	你要研究它、滋养它，好让 Pestra 的医术即便在 Ferentia 最偏远的地方也能生根开花。 \
	记住，你并不直接隶属于圣座教会，本地主教不是你的上司。你首先服从的是 Pestra 的教派本身。"
	outfit = /datum/outfit/job/roguetown/keeper/basic
	category_tags = list(CTAG_KEEPER)
	// No perception as to dissuade picking statpacks to negate the strength penalty.
	// Positive stat delta of 3. It's lower than a towner (5) & Acolyte (7), but you have outlier stats and master skills, so less stats for you.
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 5,
		STATKEY_CON = 3,
		STATKEY_STR = -5,
		STATKEY_PER = 2
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
	)
	adv_stat_ceiling = list(STAT_STRENGTH = 6)

/datum/job/roguetown/keeper/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L

	spawn(50)
		if(H && H.client)
			_delayed_path_choice(H)

/datum/job/roguetown/keeper/proc/_delayed_path_choice(mob/living/carbon/human/H)
	if(!H || !H.client || !H.mind)
		return

	var/choice = alert(H, "选择你的道路。", "看守人教义", "守旧派", "激进派")

	if(choice == "激进派")
		grant_radical_path(H)
	else
		grant_old_path(H)

/datum/outfit/job/roguetown/keeper/basic/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/psicross/pestra
	cloak = /obj/item/clothing/cloak/templar/pestran
	gloves = /obj/item/clothing/gloves/roguetown/leather
	head = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
							/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
							/obj/item/heart_canister = 2,
							/obj/item/heart_blood_vial/filled = 2,
							/obj/item/heart_blood_canister/filled = 1,
							/obj/item/heart_blood_vial = 5,
							/obj/item/heart_blood_canister = 1,
							/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1,
							/obj/item/roguekey/keeper = 1,
							/obj/item/roguekey/keeper_inner = 1,
							/obj/item/storage/keyring/churchie = 1,
							/obj/item/ritechalk = 1,
							/obj/item/rogueweapon/scabbard/sheath = 2)
	H.put_in_hands(new /obj/item/storage/belt/rogue/surgery_bag/full/physician(H), TRUE)


/datum/job/roguetown/keeper/proc/grant_old_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return

	REMOVE_TRAIT(H, TRAIT_CLERGYRADICAL, "job")

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)

	to_chat(H, span_notice("我仍走在 佩斯特拉 旧有的虔敬之道上。"))


/datum/job/roguetown/keeper/proc/grant_radical_path(mob/living/carbon/human/H)
	if(!H || !H.mind || !H.patron)
		return

	ADD_TRAIT(H, TRAIT_CLERGYRADICAL, "job")

	H.miracle_points += 3
	H.church_favor += 1500

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)

	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/self/learnmiracle))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/learnmiracle, H)
	if(!H.mind.has_spell(/obj/effect/proc_holder/spell/invoked/resurrect/pestra))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/resurrect/pestra, H)

	to_chat(H, span_notice("我拥抱 佩斯特拉 的激进教义。"))
