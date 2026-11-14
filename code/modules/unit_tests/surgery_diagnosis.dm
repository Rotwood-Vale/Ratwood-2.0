/datum/unit_test/surgery_diagnosis/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human/consistent)
	TEST_ASSERT(!length(patient.get_missing_organs()), "An intact patient was diagnosed with missing organs")
	var/obj/item/organ/liver = patient.getorganslot(ORGAN_SLOT_LIVER)
	TEST_ASSERT(liver, "Patient did not start with a liver")
	liver.Remove(patient, TRUE)
	var/list/missing = patient.get_missing_organs()
	TEST_ASSERT_EQUAL(length(missing), 1, "Diagnosis should report exactly the removed organ")
	TEST_ASSERT(liver.name in missing, "Diagnosis did not name the missing liver")
	liver.Insert(patient, TRUE)
	TEST_ASSERT(!length(patient.get_missing_organs()), "Replacing an organ did not clear its diagnosis")
	var/datum/organ_dna/liver_dna = patient.dna.organ_dna[ORGAN_SLOT_LIVER]
	TEST_ASSERT(liver_dna, "Patient's liver anatomy was not recorded")
	liver.Remove(patient, TRUE)
	liver_dna.disabled = TRUE
	TEST_ASSERT(!length(patient.get_missing_organs()), "An intentionally absent organ was reported missing")
	liver_dna.disabled = FALSE
	liver.Insert(patient, TRUE)
	// A species without an appendix must not be diagnosed against human anatomy.
	patient.set_species(/datum/species/construct/metal)
	TEST_ASSERT(!length(patient.get_missing_organs()), "Construct anatomy produced a false missing-organ diagnosis")

	patient.set_species(/datum/species/dullahan)
	var/datum/species/dullahan/dullahan = patient.dna.species
	var/obj/item/bodypart/head/dullahan/head = dullahan.my_head
	var/obj/item/organ/eyes = patient.getorganslot(ORGAN_SLOT_EYES)
	TEST_ASSERT(head && eyes, "Dullahan did not start with a head and eyes")
	head.drop_limb(FALSE)
	TEST_ASSERT(!patient.getorganslot(ORGAN_SLOT_EYES) && eyes.loc == head, "Detaching the head did not move the eyes out of the body's organ slots")
	TEST_ASSERT(patient.put_in_active_hand(head), "Dullahan could not hold their detached head")
	TEST_ASSERT(!length(patient.get_missing_organs()), "Organs in the detached Dullahan head were reported missing")

	eyes.forceMove(get_turf(head))
	missing = patient.get_missing_organs()
	eyes.forceMove(head)
	head.attach_limb(patient)
	TEST_ASSERT_EQUAL(length(missing), 1, "Diagnosis should report exactly the organ removed from the detached head")
	TEST_ASSERT(eyes.name in missing, "Diagnosis did not name the eyes removed from the detached head")

/datum/unit_test/surgical_fire_healing/Run()
	var/mob/living/carbon/human/patient = allocate(/mob/living/carbon/human/consistent)
	var/obj/item/bodypart/chest = patient.get_bodypart(BODY_ZONE_CHEST)
	var/datum/wound/slash/incision/incision = chest.add_wound(/datum/wound/slash/incision)
	var/datum/wound/slash/cut = chest.add_wound(/datum/wound/slash)
	TEST_ASSERT(incision && cut, "Could not create surgical incision and ordinary cut")
	var/incision_health = incision.whp
	var/cut_health = cut.whp
	patient.cmode = FALSE
	var/datum/status_effect/buff/campfire/fire_healing = patient.apply_status_effect(/datum/status_effect/buff/campfire)
	TEST_ASSERT(fire_healing, "Could not apply fire healing")
	fire_healing.tick()
	TEST_ASSERT_EQUAL(incision.whp, incision_health, "Fire healing reduced an open incision")
	TEST_ASSERT(cut.whp < cut_health, "Fire healing no longer heals ordinary cuts")
	patient.remove_status_effect(/datum/status_effect/buff/campfire)
	var/datum/status_effect/buff/healing/campfire/hand_warming = patient.apply_status_effect(/datum/status_effect/buff/healing/campfire, 1)
	TEST_ASSERT(hand_warming, "Could not apply hand-warming healing")
	cut_health = cut.whp
	hand_warming.tick()
	TEST_ASSERT_EQUAL(incision.whp, incision_health, "Hand warming reduced an open incision")
	TEST_ASSERT(cut.whp < cut_health, "Hand warming no longer heals ordinary cuts")
	patient.remove_status_effect(/datum/status_effect/buff/healing/campfire)
	incision.sew_wound()
	TEST_ASSERT(!chest.has_wound(/datum/wound/slash/incision), "Suturing did not close the protected incision")
