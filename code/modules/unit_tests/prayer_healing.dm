/datum/unit_test/prayer_cooldown/Run()
	var/mob/living/carbon/human/follower = allocate(/mob/living/carbon/human/consistent)
	follower.set_patron(/datum/patron/divine/astrata)
	var/datum/patron/patron = follower.patron
	var/prayer = "Grant me the strength to endure."
	ADD_TRAIT(follower, TRAIT_CONVICTION, TRAIT_SOURCE_UNIT_TESTS)

	TEST_ASSERT(!patron.hear_prayer(follower, "Help me"), "A short prayer was accepted")
	TEST_ASSERT_NULL(follower.mob_timers[MT_PSYPRAY], "A rejected prayer started the cooldown")
	TEST_ASSERT(!follower.has_status_effect(/datum/status_effect/prayer_cooldown), "A rejected prayer created a cooldown alert")

	TEST_ASSERT(patron.hear_prayer(follower, prayer), "The first valid prayer was rejected")
	var/last_prayer = follower.mob_timers[MT_PSYPRAY]
	TEST_ASSERT_EQUAL(last_prayer, world.time, "An accepted prayer did not record its time")
	var/datum/status_effect/prayer_cooldown/cooldown = follower.has_status_effect(/datum/status_effect/prayer_cooldown)
	TEST_ASSERT(cooldown, "An accepted Martyr prayer did not create the cooldown alert")
	TEST_ASSERT_EQUAL(cooldown.duration, last_prayer + 1 MINUTES, "The cooldown alert does not match the prayer cooldown")
	TEST_ASSERT(cooldown.linked_alert, "Prayer Recovering has no alert")
	cooldown.linked_alert.update_countdown(cooldown.duration - world.time)
	TEST_ASSERT_EQUAL(cooldown.linked_alert.last_countdown_text, "1:00", "Prayer Recovering does not show a one-minute countdown")
	TEST_ASSERT(icon_exists(cooldown.linked_alert.icon, cooldown.linked_alert.icon_state), "Prayer Recovering has no icon")

	sleep(1)
	TEST_ASSERT(!patron.hear_prayer(follower, prayer), "An immediate repeat bypassed the cooldown")
	TEST_ASSERT_EQUAL(follower.mob_timers[MT_PSYPRAY], last_prayer, "An early retry restarted the cooldown")
	TEST_ASSERT_EQUAL(cooldown.duration, last_prayer + 1 MINUTES, "An early retry restarted the alert countdown")

	follower.mob_timers[MT_PSYPRAY] = world.time - 1 MINUTES
	cooldown.duration = world.time
	TEST_ASSERT(patron.hear_prayer(follower, prayer), "A prayer at the cooldown boundary was rejected")
	TEST_ASSERT_EQUAL(follower.mob_timers[MT_PSYPRAY], world.time, "The next successful prayer did not restart the cooldown")
	TEST_ASSERT_EQUAL(cooldown.duration, world.time + 1 MINUTES, "A prayer at the expiry boundary did not refresh the existing countdown")
	TEST_ASSERT(!patron.hear_prayer(follower, prayer), "A second success allowed another immediate prayer")
	cooldown.duration = world.time - 1
	cooldown.process()
	TEST_ASSERT(!follower.has_status_effect(/datum/status_effect/prayer_cooldown), "The expired cooldown alert was not removed")

	var/mob/living/carbon/human/ordinary_follower = allocate(/mob/living/carbon/human/consistent)
	ordinary_follower.set_patron(/datum/patron/divine/astrata)
	TEST_ASSERT(ordinary_follower.patron.hear_prayer(ordinary_follower, prayer), "An ordinary follower's first prayer was rejected")
	TEST_ASSERT(!ordinary_follower.has_status_effect(/datum/status_effect/prayer_cooldown), "A follower without Conviction received the Martyr cooldown alert")
	TEST_ASSERT(!ordinary_follower.patron.hear_prayer(ordinary_follower, prayer), "The shared prayer cooldown was not enforced for an ordinary follower")

/datum/unit_test/prayer_healing/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human/consistent)
	var/obj/item/bodypart/chest = patient.get_bodypart(BODY_ZONE_CHEST)
	var/datum/wound/slash/cut = chest.add_wound(/datum/wound/slash)
	TEST_ASSERT(cut, "Could not create a wound to test prayer healing")
	patient.adjustBruteLoss(30)
	patient.set_blood_volume(BLOOD_VOLUME_NORMAL - 30)

	var/datum/status_effect/buff/healing/prayer/self_heal = patient.apply_status_effect(/datum/status_effect/buff/healing/prayer, 2)
	var/datum/status_effect/buff/healing/prayer_power/received_heal = patient.apply_status_effect(/datum/status_effect/buff/healing/prayer_power, 6)
	TEST_ASSERT(self_heal && received_heal, "The two prayer effects could not coexist")
	TEST_ASSERT_EQUAL(self_heal.duration - world.time, 12 SECONDS, "Self-prayer lost its duration")
	TEST_ASSERT_EQUAL(received_heal.duration - world.time, 2 SECONDS, "Received prayer lost its duration")
	TEST_ASSERT_EQUAL(self_heal.healing_on_tick, 2 * self_heal.tech_healing_modifier, "Self-prayer lost its healing rate")
	TEST_ASSERT_EQUAL(received_heal.healing_on_tick, 6 * received_heal.tech_healing_modifier, "Received prayer lost its healing rate")

	var/brute_before = patient.getBruteLoss()
	var/blood_before = patient.get_blood_volume()
	var/wound_before = cut.whp
	self_heal.tick()
	TEST_ASSERT(patient.getBruteLoss() < brute_before, "Self-prayer did not heal brute damage")
	TEST_ASSERT(patient.get_blood_volume() > blood_before, "Self-prayer did not restore blood")
	TEST_ASSERT(cut.whp < wound_before, "Self-prayer did not heal the wound")
	brute_before = patient.getBruteLoss()
	received_heal.tick()
	TEST_ASSERT(patient.getBruteLoss() < brute_before, "Received prayer did not heal brute damage")

	self_heal.linked_alert.update_countdown(self_heal.duration - world.time)
	received_heal.linked_alert.update_countdown(received_heal.duration - world.time)
	TEST_ASSERT_EQUAL(self_heal.linked_alert.icon_state, "lesser_heal", "Self-prayer does not use the healing icon")
	TEST_ASSERT_EQUAL(received_heal.linked_alert.icon_state, "lesser_heal", "Received prayer does not use the healing icon")
	TEST_ASSERT_EQUAL(self_heal.linked_alert.last_countdown_text, "12s", "Self-prayer countdown is incorrect")
	TEST_ASSERT_EQUAL(received_heal.linked_alert.last_countdown_text, "2s", "Received prayer countdown is incorrect")

	self_heal.duration = world.time + 1 SECONDS
	var/received_expiry = received_heal.duration
	patient.apply_status_effect(/datum/status_effect/buff/healing/prayer, 2)
	TEST_ASSERT_EQUAL(self_heal.duration - world.time, 12 SECONDS, "Self-prayer did not refresh independently")
	TEST_ASSERT_EQUAL(received_heal.duration, received_expiry, "Self-prayer changed the received-prayer timer")
	var/self_expiry = self_heal.duration
	received_heal.duration = world.time + 1
	patient.apply_status_effect(/datum/status_effect/buff/healing/prayer_power, 6)
	TEST_ASSERT_EQUAL(received_heal.duration - world.time, 2 SECONDS, "Received prayer did not refresh independently")
	TEST_ASSERT_EQUAL(self_heal.duration, self_expiry, "Received prayer changed the self-prayer timer")

	patient.remove_status_effect(/datum/status_effect/buff/healing/prayer)
	patient.remove_status_effect(/datum/status_effect/buff/healing/prayer_power)
	received_heal = patient.apply_status_effect(/datum/status_effect/buff/healing/prayer_power, 6)
	self_heal = patient.apply_status_effect(/datum/status_effect/buff/healing/prayer, 2)
	TEST_ASSERT(self_heal && received_heal, "Received prayer suppressed a later self-prayer")
	TEST_ASSERT_EQUAL(self_heal.duration - world.time, 12 SECONDS, "Received prayer shortened a later self-prayer")
	TEST_ASSERT_EQUAL(self_heal.healing_on_tick, 2 * self_heal.tech_healing_modifier, "Received prayer changed a later self-prayer's rate")
	received_heal.duration = world.time - 1
	received_heal.process()
	TEST_ASSERT(!patient.has_status_effect(/datum/status_effect/buff/healing/prayer_power), "The expired received-prayer effect was not removed")
	TEST_ASSERT(patient.has_status_effect(/datum/status_effect/buff/healing/prayer), "Expiring received prayer removed self-prayer")
