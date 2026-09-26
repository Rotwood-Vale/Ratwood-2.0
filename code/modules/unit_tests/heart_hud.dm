/// Blood only changes through set_blood_volume(): it clamps, and it notifies exactly once per real change.
/datum/unit_test/blood_volume_setter
	var/notifications = 0
	var/last_notified_volume

/datum/unit_test/blood_volume_setter/proc/on_blood_volume_changed(mob/living/source, new_volume)
	SIGNAL_HANDLER
	notifications++
	last_notified_volume = new_volume

/datum/unit_test/blood_volume_setter/Run()
	var/mob/living/carbon/human/consistent/subject = allocate(/mob/living/carbon/human/consistent)
	RegisterSignal(subject, COMSIG_LIVING_BLOOD_VOLUME_CHANGED, PROC_REF(on_blood_volume_changed))

	subject.set_blood_volume(300)
	TEST_ASSERT_EQUAL(subject.get_blood_volume(), 300, "set_blood_volume() did not store the new volume.")
	TEST_ASSERT_EQUAL(notifications, 1, "set_blood_volume() did not send COMSIG_LIVING_BLOOD_VOLUME_CHANGED.")
	TEST_ASSERT_EQUAL(last_notified_volume, 300, "COMSIG_LIVING_BLOOD_VOLUME_CHANGED carried the wrong volume.")

	subject.set_blood_volume(300)
	TEST_ASSERT_EQUAL(notifications, 1, "Setting the same volume notified again.")

	subject.set_blood_volume(-50)
	TEST_ASSERT_EQUAL(subject.get_blood_volume(), 0, "Blood volume went below zero.")
	subject.set_blood_volume(BLOOD_VOLUME_MAXIMUM * 2)
	TEST_ASSERT_EQUAL(subject.get_blood_volume(), BLOOD_VOLUME_MAXIMUM, "Blood volume went above BLOOD_VOLUME_MAXIMUM.")
	subject.adjust_blood_volume(-10)
	TEST_ASSERT_EQUAL(subject.get_blood_volume(), BLOOD_VOLUME_MAXIMUM - 10, "adjust_blood_volume() did not apply the delta.")
	TEST_ASSERT_EQUAL(notifications, 4, "Every real change must notify exactly once.")

	subject.set_blood_volume(200)
	notifications = 0
	subject.restore_blood()
	TEST_ASSERT_EQUAL(subject.get_blood_volume(), BLOOD_VOLUME_NORMAL, "restore_blood() did not restore blood.")
	TEST_ASSERT_EQUAL(notifications, 1, "restore_blood() changed blood without going through set_blood_volume().")

	subject.set_nutrition(NUTRITION_LEVEL_FED)
	subject.set_hydration(HYDRATION_LEVEL_FULL)
	subject.set_blood_volume(BLOOD_VOLUME_SURVIVE)
	notifications = 0
	subject.handle_passive_blood()
	TEST_ASSERT(subject.get_blood_volume() > BLOOD_VOLUME_SURVIVE, "handle_passive_blood() did not regenerate blood for a fed and watered mob.")
	TEST_ASSERT_EQUAL(notifications, 1, "handle_passive_blood() changed blood without going through set_blood_volume().")

	ADD_TRAIT(subject, TRAIT_TOXINLOVER, TRAIT_SOURCE_UNIT_TESTS)
	subject.set_blood_volume(BLOOD_VOLUME_NORMAL)
	notifications = 0
	subject.adjustToxLoss(-2)
	REMOVE_TRAIT(subject, TRAIT_TOXINLOVER, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(subject.get_blood_volume() < BLOOD_VOLUME_NORMAL, "Healing toxins on a TRAIT_TOXINLOVER mob did not drain blood.")
	TEST_ASSERT_EQUAL(notifications, 1, "adjustToxLoss() on a TRAIT_TOXINLOVER mob changed blood without going through set_blood_volume().")

/// Every correct way to change a heart input marks the heart for a refresh, even with updating_health off.
/datum/unit_test/heart_hud_inputs

/datum/unit_test/heart_hud_inputs/Run()
	var/mob/living/carbon/human/consistent/subject = allocate(/mob/living/carbon/human/consistent)
	subject.hud_used = new /datum/hud/human(subject)
	var/obj/item/bodypart/chest = subject.get_bodypart(BODY_ZONE_CHEST)
	TEST_ASSERT_NOTNULL(chest, "The test human has no chest.")

	subject.flush_injury_huds()
	subject.adjust_blood_volume(-10)
	TEST_ASSERT(subject.blood_hud_dirty, "adjust_blood_volume() did not mark the heart.")

	subject.flush_injury_huds()
	subject.adjustToxLoss(5, FALSE)
	TEST_ASSERT(subject.blood_hud_dirty, "adjustToxLoss() did not mark the heart.")
	subject.flush_injury_huds()
	subject.setToxLoss(0, FALSE)
	TEST_ASSERT(subject.blood_hud_dirty, "setToxLoss() did not mark the heart.")
	subject.flush_injury_huds()
	subject.adjustOxyLoss(5, FALSE)
	TEST_ASSERT(subject.blood_hud_dirty, "adjustOxyLoss() did not mark the heart.")
	subject.flush_injury_huds()
	subject.setOxyLoss(0, FALSE)
	TEST_ASSERT(subject.blood_hud_dirty, "setOxyLoss() did not mark the heart.")

	subject.flush_injury_huds()
	chest.receive_damage(brute = 10)
	TEST_ASSERT(subject.pain_hud_dirty, "receive_damage() did not mark pain.")
	subject.flush_injury_huds()
	chest.heal_damage(10, 0, 0)
	TEST_ASSERT(subject.pain_hud_dirty, "heal_damage() did not mark pain.")
	subject.flush_injury_huds()
	chest.set_damage(5, 5)
	TEST_ASSERT(subject.pain_hud_dirty, "set_damage() did not mark pain.")
	chest.set_damage(0, 0)

	var/datum/wound/wound = chest.add_wound(/datum/wound/bruise/small, silent = TRUE)
	TEST_ASSERT_NOTNULL(wound, "Could not apply a test wound.")
	subject.flush_injury_huds()
	wound.set_woundpain(wound.woundpain + 10)
	TEST_ASSERT(subject.pain_hud_dirty, "set_woundpain() did not mark pain.")

	subject.flush_injury_huds()
	subject.adjust_pain_mod(2)
	TEST_ASSERT(subject.pain_hud_dirty, "adjust_pain_mod() did not mark pain.")
	subject.adjust_pain_mod(0.5)

	subject.flush_injury_huds()
	ADD_TRAIT(subject, TRAIT_ADRENALINE_RUSH, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(subject.pain_hud_dirty, "Gaining TRAIT_ADRENALINE_RUSH did not mark pain.")
	subject.flush_injury_huds()
	REMOVE_TRAIT(subject, TRAIT_ADRENALINE_RUSH, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(subject.pain_hud_dirty, "Losing TRAIT_ADRENALINE_RUSH did not mark pain.")

/// The heart shows what the inputs say: blood loss, poison and suffocation together, and pain from limb damage.
/datum/unit_test/heart_hud_display

/datum/unit_test/heart_hud_display/Run()
	var/mob/living/carbon/human/consistent/subject = allocate(/mob/living/carbon/human/consistent)
	subject.hud_used = new /datum/hud/human(subject)
	var/atom/movable/screen/healths/blood/heart = subject.hud_used.bloods
	TEST_ASSERT(istype(heart), "The human HUD has no heart indicator.")

	subject.set_blood_volume(200)
	subject.flush_injury_huds()
	TEST_ASSERT_EQUAL(heart.icon_state, "dam60", "The heart did not follow blood loss.")

	subject.restore_blood()
	subject.flush_injury_huds()
	TEST_ASSERT_EQUAL(heart.icon_state, "dam0", "The heart did not follow restore_blood().")

	subject.set_blood_volume(392)
	subject.setToxLoss(40)
	subject.setOxyLoss(60)
	subject.flush_injury_huds()
	TEST_ASSERT_EQUAL(heart.icon_state, "dam30", "The heart did not follow blood loss alongside poison.")
	TEST_ASSERT_EQUAL(heart.tox_layer.icon_state, "toxloss40", "Poison is hidden while the mob is bleeding.")
	TEST_ASSERT_EQUAL(heart.tox_layer.alpha, 255, "The poison layer is transparent while the mob is bleeding.")
	TEST_ASSERT_EQUAL(heart.oxy_layer.icon_state, "oxyloss60", "Suffocation is hidden while the mob is bleeding.")

	subject.setToxLoss(0)
	subject.flush_injury_huds()
	TEST_ASSERT_EQUAL(heart.tox_layer.alpha, 0, "The poison layer stayed visible after the poison was healed.")

	var/obj/item/bodypart/chest = subject.get_bodypart(BODY_ZONE_CHEST)
	chest.receive_damage(brute = 30)
	subject.flush_injury_huds()
	TEST_ASSERT_EQUAL(heart.pain_layer.alpha, 255, "Limb damage did not show pain on the heart.")
	chest.heal_damage(30, 0, 0)
	subject.flush_injury_huds()
	TEST_ASSERT_EQUAL(heart.pain_layer.alpha, 0, "Pain stayed on the heart after the limb healed.")

/// The pain threshold follows live willpower and pain traits, so the heart agrees with pain stuns.
/datum/unit_test/pain_threshold_is_live

/datum/unit_test/pain_threshold_is_live/Run()
	var/mob/living/carbon/human/consistent/subject = allocate(/mob/living/carbon/human/consistent)
	subject.STAWIL = 14
	TEST_ASSERT_EQUAL(subject.get_pain_threshold(), 140, "The pain threshold ignored the current willpower.")

	ADD_TRAIT(subject, TRAIT_ADRENALINE_RUSH, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT_EQUAL(subject.get_pain_threshold(), 190, "The pain threshold ignored TRAIT_ADRENALINE_RUSH.")
	REMOVE_TRAIT(subject, TRAIT_ADRENALINE_RUSH, TRAIT_SOURCE_UNIT_TESTS)

	ADD_TRAIT(subject, TRAIT_NOPAIN, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT_EQUAL(subject.get_pain_threshold(), 250, "The pain threshold ignored TRAIT_NOPAIN.")
	REMOVE_TRAIT(subject, TRAIT_NOPAIN, TRAIT_SOURCE_UNIT_TESTS)
