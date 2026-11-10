/// Guards the end-of-round credits capture: a player character in a credited job, wearing clothes,
/// must produce a portrait, transient layers (held items) must not get into it, and the flattened
/// wanted-poster icon must not come out blank.
/// Clothes are equipped directly rather than through a job outfit, because many job outfits read the
/// player's client in pre_equip() and a test mob has none.
/datum/unit_test/credits_capture

/datum/unit_test/credits_capture/Run()
	var/datum/job/credited_job
	for(var/datum/job/J as anything in SSjob.occupations)
		if(J.show_in_credits)
			credited_job = J
			break
	TEST_ASSERT_NOTNULL(credited_job, "No job with show_in_credits exists")

	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human/species/human/northern)
	var/datum/mind/M = new /datum/mind("credits_unit_test")
	M.current = H
	H.mind = M
	M.set_assigned_role(credited_job)

	H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/shirt/undershirt(H), SLOT_SHIRT, TRUE)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/tights(H), SLOT_PANTS, TRUE)
	H.process_pending_icon_updates()
	TEST_ASSERT(H.wear_shirt, "Test human ([H.dna?.species?.type]) failed to put on a shirt")
	TEST_ASSERT(H.wear_pants, "Test human ([H.dna?.species?.type]) failed to put on pants")

	// Sentinels make the layer filtering checkable without depending on any particular item's sprites.
	var/mutable_appearance/held_sentinel = mutable_appearance('icons/blanks/32x32.dmi', "credits_test_held", -HANDS_LAYER)
	var/mutable_appearance/worn_sentinel = mutable_appearance('icons/blanks/32x32.dmi', "credits_test_worn", -NECK_LAYER)
	// An oversized back item with negative offsets, like a polearm. These used to blank the whole poster.
	var/mutable_appearance/big_sentinel = mutable_appearance('icons/roguetown/weapons/polearms64.dmi', "boarspear", -BACK_LAYER)
	big_sentinel.pixel_x = -16
	big_sentinel.pixel_y = -16
	var/old_hands = H.overlays_standing[HANDS_LAYER]
	var/old_neck = H.overlays_standing[NECK_LAYER]
	var/old_back = H.overlays_standing[BACK_LAYER]
	var/list/neck_with_sentinel = list(worn_sentinel)
	if(old_neck)
		neck_with_sentinel += old_neck
	H.overlays_standing[HANDS_LAYER] = held_sentinel
	H.overlays_standing[NECK_LAYER] = neck_with_sentinel
	H.overlays_standing[BACK_LAYER] = big_sentinel

	var/datum/credit_entry/entry = SScrediticons.capture(H)

	H.overlays_standing[HANDS_LAYER] = old_hands
	H.overlays_standing[NECK_LAYER] = old_neck
	H.overlays_standing[BACK_LAYER] = old_back
	SScrediticons.entries -= M
	H.mind = null
	M.current = null

	TEST_ASSERT_NOTNULL(entry, "capture() returned no entry for a keyed mind in [credited_job.title]")
	TEST_ASSERT_NOTNULL(entry.portrait, "Credit entry for [credited_job.title] has no portrait")
	TEST_ASSERT(length(entry.portrait.overlays) > 1, "Portrait has no clothing/body overlays")

	var/found_worn = FALSE
	for(var/image/overlay as anything in entry.portrait.overlays)
		TEST_ASSERT(overlay.icon_state != "credits_test_held", "Held-item layer leaked into the credits portrait")
		if(overlay.icon_state == "credits_test_worn")
			found_worn = TRUE
	TEST_ASSERT(found_worn, "Worn layer was dropped from the credits portrait")

	// The wanted-poster flattening must survive the oversized back item and still show the upper body.
	var/icon/poster = SScrediticons.build_poster_icon(entry.portrait)
	TEST_ASSERT_EQUAL(poster.Width(), 96, "Poster icon has the wrong width")
	TEST_ASSERT_EQUAL(poster.Height(), 48, "Poster icon has the wrong height")
	var/visible = count_opaque(poster)
	TEST_ASSERT(visible > 500, "Poster icon is blank or nearly blank ([visible] visible pixels)")

/datum/unit_test/credits_capture/proc/count_opaque(icon/I)
	. = 0
	for(var/x in 1 to I.Width())
		for(var/y in 1 to I.Height())
			if(I.GetPixel(x, y))
				.++
