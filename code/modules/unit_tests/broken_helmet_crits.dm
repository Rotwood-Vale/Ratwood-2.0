/datum/unit_test/broken_helmet_crits/Run()
	var/mob/living/carbon/human/consistent/human = allocate(/mob/living/carbon/human/consistent)
	var/obj/item/clothing/head/roguetown/helmet/heavy/helmet = allocate(/obj/item/clothing/head/roguetown/helmet/heavy, human)
	human.equip_to_slot(helmet, SLOT_HEAD)
	helmet.obj_integrity = 50

	TEST_ASSERT(human.checkcritarmor(BODY_ZONE_HEAD, BCLASS_PICK), "An intact heavy helmet should prevent pick crits.")

	human.run_armor_check(
		BODY_ZONE_HEAD,
		"stab",
		armor_penetration = 80,
		damage = 26,
		blade_dulling = BCLASS_PICK,
	)

	TEST_ASSERT(helmet.obj_broken, "The controlled hit should break the helmet.")
	TEST_ASSERT_EQUAL(helmet.obj_integrity, 24, "The breaking hit should leave the helmet above zero integrity.")
	TEST_ASSERT(!human.checkcritarmor(BODY_ZONE_HEAD, BCLASS_PICK), "A broken helmet should not prevent pick crits.")

/datum/unit_test/skin_armor_crits/Run()
	var/mob/living/carbon/human/consistent/human = allocate(/mob/living/carbon/human/consistent)
	var/obj/item/clothing/suit/roguetown/armor/skin_armor/bear_skin/skin = allocate(/obj/item/clothing/suit/roguetown/armor/skin_armor/bear_skin, human)
	human.skin_armor = skin

	TEST_ASSERT_EQUAL(human.get_best_worn_armor(BODY_ZONE_HEAD, "slash"), skin, "Natural armor should be used for normal armor checks.")
	TEST_ASSERT(human.checkcritarmor(BODY_ZONE_HEAD, BCLASS_CUT), "Natural armor should also prevent its listed crit classes.")
