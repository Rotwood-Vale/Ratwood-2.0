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

/// The heart HUD follows blood changes made through the setter, and poison stays visible while the mob is bleeding.
/datum/unit_test/blood_volume_heart_hud

/datum/unit_test/blood_volume_heart_hud/Run()
	var/mob/living/carbon/human/consistent/subject = allocate(/mob/living/carbon/human/consistent)
	subject.hud_used = new /datum/hud/human(subject)
	var/atom/movable/screen/healths/blood/heart = subject.hud_used.bloods
	TEST_ASSERT(istype(heart), "The human HUD has no heart indicator.")

	subject.set_blood_volume(200)
	TEST_ASSERT(subject.blood_hud_dirty, "set_blood_volume() did not mark the heart HUD for a refresh.")
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
