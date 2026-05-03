/datum/advclass/fisher
	name = "Fisher"
	tutorial = "You are a fisherman, with your bag of bait and your fishing rod, you are one of few who can reliably get a stable source of meat around here"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/fisher
	subclass_social_rank = SOCIAL_RANK_PEASANT
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	traits_applied = list(TRAIT_CAUTIOUS_FISHER, TRAIT_HOMESTEAD_EXPERT)
	maximum_possible_slots = 20 // Should never fill, for the purpose of players to know what types towners are in round at the menu
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_LCK = 2,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE, //Wrestling down those nasty carp.
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/fisher/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.age == AGE_OLD)
		H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_MASTER, TRUE)
	else
		H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_EXPERT, TRUE)
	if(H.pronouns == HE_HIM || H.pronouns == THEY_THEM || H.pronouns == IT_ITS)
		pants = /obj/item/clothing/under/roguetown/tights/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		neck = /obj/item/storage/belt/rogue/pouch/coins/poor
		head = /obj/item/clothing/head/roguetown/fisherhat
		armor = /obj/item/clothing/suit/roguetown/armor/workervest
		backl = /obj/item/storage/backpack/rogue/satchel
		belt = /obj/item/storage/belt/rogue/leather
		backr = /obj/item/fishingrod/fisher
		beltr = /obj/item/cooking/pan
		beltl = null
		backpack_contents = list(
							/obj/item/natural/worms = 2,
							/obj/item/rogueweapon/shovel/small = 1,
							/obj/item/flashlight/flare/torch = 1,
							/obj/item/flint = 1,
							/obj/item/recipe_book/fishing = 1,
							/obj/item/recipe_book/survival = 1,
							)
	else
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		neck = /obj/item/storage/belt/rogue/pouch/coins/poor
		head = /obj/item/clothing/head/roguetown/fisherhat
		backl = /obj/item/storage/backpack/rogue/satchel
		belt = /obj/item/storage/belt/rogue/leather
		backr = /obj/item/fishingrod/fisher
		beltr = /obj/item/cooking/pan
		beltl = null
		backpack_contents = list(
							/obj/item/natural/worms = 2,
							/obj/item/rogueweapon/shovel/small = 1,
							/obj/item/flashlight/flare/torch = 1,
							/obj/item/flint = 1,
							/obj/item/recipe_book/fishing = 1,
							)

/datum/outfit/job/roguetown/adventurer/fisher/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	if(H?.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/digworms)
	var/obj/item/rogueweapon/scabbard/sheath/S = new /obj/item/rogueweapon/scabbard/sheath(H)
	H.equip_to_slot_or_del(S, SLOT_BELT_L, TRUE)
	if(!QDELETED(S))
		var/obj/item/rogueweapon/huntingknife/K = new /obj/item/rogueweapon/huntingknife(S)
		S.sheathed = K
		S.update_icon(H)

/obj/effect/proc_holder/spell/invoked/digworms
	name = "Dig Bait"
	desc = "Dig around wet mud for worms, grubs, and leeches."
	overlay_state = "dig"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/digworms/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(user)
	var/atom/target_atom = user
	if(length(targets))
		target_atom = targets[1]
	var/turf/target_turf = get_turf(target_atom)
	if(!target_turf)
		target_turf = T
	if(get_dist(user, target_turf) > 1)
		to_chat(user, span_warning("I need to dig on mud right beside me."))
		return FALSE
	var/valid_tile = FALSE
	if(istype(target_turf, /turf/open/water/river/muddy))
		valid_tile = TRUE
	else if(istype(target_turf, /turf/open/floor/rogue/dirt) && target_turf:muddy)
		valid_tile = TRUE
	if(!valid_tile)
		to_chat(user, span_warning("I need to do this on wet mud."))
		return FALSE
	var/digtime = pick(10 SECONDS, 15 SECONDS, 20 SECONDS, 25 SECONDS, 30 SECONDS)
	var/digamount = pick(2, 3, 4, 5)
	playsound(target_turf, 'sound/items/dig_shovel.ogg', 25, TRUE)
	to_chat(user, span_warning("I start to dig through the wet mud..."))
	if(!do_after(user, digtime, target = target_turf))
		to_chat(user, span_warning("I need to stay still to dig for bait!"))
		return FALSE
	for(var/i = 1, i <= digamount, i++)
		var/spawn_type = pickweight(list(
			/obj/item/natural/worms = 5,
			/obj/item/natural/worms/grubs = 3,
			/obj/item/natural/worms/leech = 2,
		))
		var/obj/item/I = new spawn_type(target_turf)
		user.dropItemToGround(I)
	to_chat(user, span_notice("I dig up some bait from the mud!"))
	return TRUE
