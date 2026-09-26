// DA LOADOUTS.

/datum/component/storage/concrete/roguetown/backpack/timesoldier
	screen_max_rows = 8
	screen_max_columns = 6
	max_w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/backpack/rogue/backpack/timesoldier
	name = "expeditionary backpack"
	desc = "A large, expeditionary backpack often used by Kingsfield forces to carry enough supplies to keep a soldier alive away from friendly lines for a while."
	icon = 'modular/timesoldier/sprites/gear.dmi'
	icon_state = "WU_backpack"
	component_type = /datum/component/storage/concrete/roguetown/backpack/timesoldier

// so uhm the shit the soldier gets is pretty hefty and wont fit in a regular backpack. lotsa stuff.

// ========TEMPERANCE===========

/datum/outfit/timesoldier/temperance
	name = "Time Soldier - Marksman"

	// clothing
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/timesoldier/temperance/eb_armor
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/timesoldier/temperance/uniform

	mask = /obj/item/clothing/mask/rogue/facemask/steel/confessor/timesoldier/temperance/redmask
	head = /obj/item/clothing/head/roguetown/veiled/timesoldier/temperance/veil
	cloak = /obj/item/clothing/cloak/poncho/timesoldier/temperance/poncho
	shoes = /obj/item/clothing/shoes/roguetown/boots/footwraps/padded/timesoldier/temperance/boots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	belt = /obj/item/storage/belt/rogue/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/angle

	// main stuff
	backl = /obj/item/storage/backpack/rogue/backpack/timesoldier
	backr = /obj/item/gun/ballistic/heavysniper

	beltl = /obj/item/quiver/bullet/brutals
	beltr = /obj/item/storage/backpack/rogue/satchel/short/timesoldier_ifak

	neck = /obj/item/reagent_containers/glass/bottle/waterskin/timesoldier

	// big stuff first so the tetris inventory gets a chance
	// to place it before all the little garbage fills the gaps.
	backpack_contents = list(
		/obj/item/storage/belt/rogue/surgery_bag/full = 1,
		/obj/item/clothing/head/roguetown/helmet/sallet/visored = 1,

		/obj/item/tent_kit/ger = 1,
		/obj/item/rogueweapon/shovel/small = 1,
		/obj/item/rogueweapon/mace/warhammer/steel = 1,

		/obj/item/rogueweapon/huntingknife/idagger/steel/kukri = 1,

		/obj/item/quiver/bullet/brutals = 2,

		/obj/item/flashlight/flare/torch/lantern = 1,

		/obj/item/reagent_containers/food/snacks/rogue/timesoldier/ferenchow = 4,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 2,

		/obj/item/natural/bundle/cloth/bandage/full = 2,
		/obj/item/needle = 1
	)
	



/proc/apply_timesoldier_temperance_stats(mob/living/carbon/human/H)
	if(!H)
		return

	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_PER, 5)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_SPD, 3)

	H.taints_loot = FALSE // taints loot in testing. this should fix.

	for(var/obj/item/I in H.get_equipped_items(TRUE) + H.held_items)
		I.unmark_as_looted() // had to add this as well.

/proc/apply_timesoldier_temperance_skills(mob/living/carbon/human/H)
	if(!H)
		return

	// combat
	H.adjust_skillrank_up_to(/datum/skill/combat/firearms, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)

	// fieldwork
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/tracking, SKILL_LEVEL_JOURNEYMAN, TRUE)

	// education / technical training
	H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/engineering, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)


/proc/apply_timesoldier_temperance_traits(mob/living/carbon/human/H)
	if(!H)
		return

	// fieldcraft
	ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_LONGSTRIDER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_WOODSMAN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SURVIVAL_EXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_PERFECT_TRACKER, TRAIT_GENERIC)

	// military training
	ADD_TRAIT(H, TRAIT_FUSILIER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)

// FINAL SET UP====

/proc/apply_timesoldier_temperance(mob/living/carbon/human/H)
	if(!H)
		return

	H.equipOutfit(/datum/outfit/timesoldier/temperance)

	// rosacrown because we must maintain our aura.
	if(H.cloak)
		var/obj/item/flowercrown/rosa/rosa_crown = new(H.cloak.loc)

		if(!SEND_SIGNAL(H.cloak, COMSIG_TRY_STORAGE_INSERT, rosa_crown, null, TRUE, TRUE))
			rosa_crown.forceMove(get_turf(H))

	apply_timesoldier_temperance_stats(H)
	apply_timesoldier_temperance_skills(H)
	apply_timesoldier_temperance_traits(H)




// ARSONIST

/datum/outfit/timesoldier/arsonist
	name = "Time Soldier - Arsonist"

	// clothing
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/timesoldier_arsonist

	head = /obj/item/clothing/head/roguetown/helmet/leather/timesoldier_arsonist

	// same general field gear as Temperance
	shoes = /obj/item/clothing/shoes/roguetown/boots/footwraps/padded/timesoldier/temperance/boots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	belt = /obj/item/storage/belt/rogue/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/angle

	// main stuff
	backl = /obj/item/storage/backpack/rogue/backpack/timesoldier
	backr = /obj/item/gun/ballistic/timesoldier_fire_wep

	beltr = /obj/item/storage/backpack/rogue/satchel/short/timesoldier_ifak

	neck = /obj/item/reagent_containers/glass/bottle/waterskin/timesoldier

	// same expeditionary kit, but with Hei Long Pao canisters
	// instead of KZ-41 ammunition.
	backpack_contents = list(
		/obj/item/storage/belt/rogue/surgery_bag/full = 1,

		/obj/item/tent_kit/ger = 1,
		/obj/item/rogueweapon/shovel/small = 1,
		/obj/item/rogueweapon/mace/warhammer/steel = 1,

		/obj/item/rogueweapon/huntingknife/idagger/steel/kukri = 1,

		/obj/item/ammo_box/magazine/timesoldier_fire = 3,

		/obj/item/flashlight/flare/torch/lantern = 1,

		/obj/item/reagent_containers/food/snacks/rogue/timesoldier/ferenchow = 4,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 2,

		/obj/item/natural/bundle/cloth/bandage/full = 2,
		/obj/item/needle = 1
	)

/proc/apply_timesoldier_arsonist_stats(mob/living/carbon/human/H)
	if(!H)
		return

	// Built more like an assault trooper than a marksman.
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_WIL, 3)
	H.change_stat(STATKEY_SPD, 2)

	H.taints_loot = FALSE

	for(var/obj/item/I in H.get_equipped_items(TRUE) + H.held_items)
		I.unmark_as_looted()


/proc/apply_timesoldier_arsonist_skills(mob/living/carbon/human/H)
	if(!H)
		return

	// combat
	H.adjust_skillrank_up_to(/datum/skill/combat/firearms, SKILL_LEVEL_MASTER, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)

	// assault / fieldwork
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/tracking, SKILL_LEVEL_APPRENTICE, TRUE)

	// technical training
	H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/engineering, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_JOURNEYMAN, TRUE)


/proc/apply_timesoldier_arsonist_traits(mob/living/carbon/human/H)
	if(!H)
		return

	// fieldcraft
	ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_LONGSTRIDER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SURVIVAL_EXPERT, TRAIT_GENERIC)

	// military training
	ADD_TRAIT(H, TRAIT_FUSILIER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)


// final stuff====

/proc/apply_timesoldier_arsonist(mob/living/carbon/human/H)
	if(!H)
		return

	H.equipOutfit(/datum/outfit/timesoldier/arsonist)

	apply_timesoldier_arsonist_stats(H)
	apply_timesoldier_arsonist_skills(H)
	apply_timesoldier_arsonist_traits(H)
