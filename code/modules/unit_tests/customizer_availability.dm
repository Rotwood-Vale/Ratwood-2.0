/datum/unit_test/taur_customizer_catalogues/Run()
	var/datum/preferences/prefs = allocate(/datum/preferences/taur_genital_test)
	var/datum/species/species = allocate(/datum/species/human)
	species.customizers = list(/datum/customizer/organ/penis/human, /datum/customizer/organ/testicles/anthro)
	prefs.pref_species = species
	var/list/ordinary = species.customizers.Copy()
	TEST_ASSERT_EQUAL(length(prefs.get_customizers()), 2, "Ordinary bodies retain the species catalogue.")
	prefs.taur_type = /obj/item/bodypart/taur/canine
	var/list/active = prefs.get_customizers()
	TEST_ASSERT(/datum/customizer/organ/penis/taur in active, "A taur must receive the separate taur catalogue.")
	TEST_ASSERT(/datum/customizer/organ/testicles/taur in active, "Both organs need separate taur settings.")
	TEST_ASSERT(!(/datum/customizer/organ/penis/human in active), "Ordinary choices must not appear for a taur.")
	TEST_ASSERT_EQUAL(length(prefs.get_customizers(TRUE)), 4, "Both catalogues must remain valid for saving.")
	active.Cut()
	TEST_ASSERT_EQUAL(species.customizers[1], ordinary[1], "Body selection must not mutate shared species settings.")
	for(var/body in list(/obj/item/bodypart/taur/goat, /obj/item/bodypart/taur/lamia))
		prefs.taur_type = body
		TEST_ASSERT(/datum/customizer/organ/penis/human in prefs.get_customizers(), "Excluded body types must retain ordinary customization.")
	prefs.taur_type = null
	TEST_ASSERT(/datum/customizer/organ/penis/human in prefs.get_customizers(), "Switching back restores the ordinary catalogue.")
	species.customizers = list()
	prefs.taur_type = /obj/item/bodypart/taur/canine
	TEST_ASSERT_EQUAL(length(prefs.get_customizers(TRUE)), 0, "A taur body must not add organ slots absent from the species.")

/datum/unit_test/taur_customizer_saved_entries/Run()
	var/datum/preferences/prefs = allocate(/datum/preferences/taur_genital_test)
	var/datum/species/species = allocate(/datum/species/human)
	species.customizers = list(/datum/customizer/organ/penis/anthro, /datum/customizer/organ/testicles/anthro)
	prefs.pref_species = species
	prefs.gender = MALE
	prefs.validate_customizer_entries()
	allocated += prefs.customizer_entries
	var/datum/customizer_entry/organ/penis/ordinary = prefs.get_customizer_entry_for_customizer_type(/datum/customizer/organ/penis/anthro)
	var/datum/customizer_entry/organ/penis/taur = prefs.get_customizer_entry_for_customizer_type(/datum/customizer/organ/penis/taur)
	ordinary.penis_size = MIN_PENIS_SIZE
	ordinary.accessory_colors = "#123456#ABCDEF"
	ordinary.functional = FALSE
	taur.penis_size = MAX_PENIS_SIZE
	taur.set_massive(TRUE)
	taur.accessory_colors = "#654321#FEDCBA"
	prefs.taur_type = /obj/item/bodypart/taur/canine
	prefs.validate_customizer_entries()
	TEST_ASSERT(prefs.wants_massive_pintle(), "Purchase the active taur selection.")
	var/list/organs = prefs.get_organ_dna_list()
	allocated += organs[ORGAN_SLOT_PENIS]
	allocated += organs[ORGAN_SLOT_TESTICLES]
	var/datum/organ_dna/penis/dna = organs[ORGAN_SLOT_PENIS]
	TEST_ASSERT_EQUAL(dna.accessory_type, taur.accessory_type, "Taur DNA must not be overwritten by an inactive ordinary entry.")
	TEST_ASSERT_EQUAL(dna.penis_size, MAX_PENIS_SIZE, "Taur settings are independent of ordinary settings.")
	var/savefile/saved = new
	saved["entries"] << prefs.customizer_entries
	saved["entries"] >> prefs.customizer_entries
	allocated += prefs.customizer_entries
	prefs.taur_type = null
	prefs.validate_customizer_entries()
	ordinary = prefs.get_customizer_entry_for_customizer_type(/datum/customizer/organ/penis/anthro)
	taur = prefs.get_customizer_entry_for_customizer_type(/datum/customizer/organ/penis/taur)
	TEST_ASSERT_EQUAL(ordinary.accessory_colors, "#123456#ABCDEF", "Ordinary colors must survive saving and a body switch.")
	TEST_ASSERT_EQUAL(ordinary.penis_size, MIN_PENIS_SIZE, "Ordinary size must survive a body switch.")
	TEST_ASSERT(!prefs.wants_massive_pintle(), "An inactive taur selection must never authorize a purchase.")
	TEST_ASSERT(!ordinary.functional, "Ordinary functionality must remain unchanged.")
	TEST_ASSERT_EQUAL(taur.accessory_colors, "#654321#FEDCBA", "Inactive taur colors must remain saved.")
	organs = prefs.get_organ_dna_list()
	dna = organs[ORGAN_SLOT_PENIS]
	allocated += dna
	allocated += organs[ORGAN_SLOT_TESTICLES]
	TEST_ASSERT_EQUAL(dna.accessory_type, ordinary.accessory_type, "Ordinary DNA must not be overwritten by inactive taur settings.")
	prefs.gender = FEMALE
	prefs.genderize_customizer_entries()
	TEST_ASSERT(ordinary.disabled && taur.disabled, "Gender defaults must update both catalogues.")

/datum/unit_test/taur_ordinary_save_upgrade/Run()
	var/datum/preferences/prefs = allocate(/datum/preferences/taur_genital_test)
	var/datum/species/species = allocate(/datum/species/human)
	prefs.pref_species = species
	species.customizers = list(/datum/customizer/organ/penis/anthro, /datum/customizer/organ/testicles/anthro)
	prefs.taur_type = /obj/item/bodypart/taur/deer
	var/datum/customizer/member = CUSTOMIZER(/datum/customizer/organ/penis/anthro)
	var/datum/customizer_entry/organ/penis/old = member.create_customizer_entry(prefs, /datum/customizer_choice/organ/penis/equine)
	old.set_penis_size(MAX_PENIS_SIZE)
	old.sheath_type = SHEATH_TYPE_SLIT
	old.accessory_colors = "#654321#FEDCBA"
	old.disabled = TRUE
	var/datum/customizer/gonads = CUSTOMIZER(/datum/customizer/organ/testicles/anthro)
	var/datum/customizer_entry/organ/testicles/pair = gonads.make_default_customizer_entry(prefs)
	pair.virility = FALSE
	pair.ball_size = MAX_TESTICLES_SIZE
	prefs.customizer_entries = list(old, pair)
	prefs.validate_customizer_entries()
	allocated += prefs.customizer_entries
	var/datum/customizer_entry/organ/penis/created = prefs.get_customizer_entry_for_customizer_type(/datum/customizer/organ/penis/taur)
	TEST_ASSERT_EQUAL(created.accessory_type, /datum/sprite_accessory/penis/taur/flared, "An existing taur's equine form must migrate to Flared.")
	TEST_ASSERT(created.disabled && created.penis_size == old.penis_size && created.sheath_type == old.sheath_type, "Preserve the original slot settings.")
	TEST_ASSERT_EQUAL(created.accessory_colors, old.accessory_colors, "Preserve the original palette.")
	var/datum/customizer_entry/organ/testicles/created_pair = prefs.get_customizer_entry_for_customizer_type(/datum/customizer/organ/testicles/taur)
	TEST_ASSERT(!created_pair.virility && created_pair.ball_size == pair.ball_size, "Preserve gonad settings on upgrade.")

/datum/unit_test/customizer_stale_entry/Run()
	var/datum/preferences/prefs = allocate(/datum/preferences/taur_genital_test)
	var/datum/species/species = allocate(/datum/species/human)
	species.customizers = list(/datum/customizer/organ/penis/anthro)
	prefs.pref_species = species
	var/datum/customizer/customizer = CUSTOMIZER(/datum/customizer/organ/penis/anthro)
	var/datum/customizer_entry/entry = customizer.make_default_customizer_entry(prefs)
	allocated += entry
	prefs.customizer_entries = list(entry)
	TEST_ASSERT(prefs.can_edit_customizer_entry(customizer, entry), "An active entry should be editable.")
	prefs.taur_type = /obj/item/bodypart/taur/canine
	TEST_ASSERT(!prefs.can_edit_customizer_entry(customizer, entry), "Switching bodies must invalidate a pending ordinary dialog.")
	prefs.taur_type = null
	prefs.customizer_entries = list()
	TEST_ASSERT(!prefs.can_edit_customizer_entry(customizer, entry), "Switching characters must invalidate the old entry.")
	prefs.customizer_entries = list(entry)
	species.customizers = list()
	TEST_ASSERT(!prefs.can_edit_customizer_entry(customizer, entry), "Removed species customizers must reject stale links.")
	TEST_ASSERT(!prefs.can_edit_customizer_entry(null, entry), "A missing customizer must be rejected.")

/datum/unit_test/taur_choice_migration/Run()
	var/datum/preferences/prefs = allocate(/datum/preferences/taur_genital_test)
	var/datum/species/species = allocate(/datum/species/human)
	species.customizers = list(/datum/customizer/organ/penis/anthro)
	prefs.pref_species = species
	prefs.taur_type = /obj/item/bodypart/taur/canine
	var/datum/customizer_entry/organ/penis/old = new
	old.customizer_type = /datum/customizer/organ/penis/taur
	old.customizer_choice_type = /datum/customizer_choice/organ/penis/taur
	old.accessory_type = /datum/sprite_accessory/penis/taur/flared
	old.accessory_colors = "#123456#ABCDEF"
	old.penis_size = MAX_PENIS_SIZE
	old.sheath_type = SHEATH_TYPE_SLIT
	old.disabled = TRUE
	old.set_massive(TRUE)
	prefs.customizer_entries = list(old)
	prefs.validate_customizer_entries()
	allocated += prefs.customizer_entries
	TEST_ASSERT_EQUAL(old.customizer_choice_type, /datum/customizer_choice/organ/penis/taur/flared, "Legacy saves must preserve the selected form.")
	TEST_ASSERT_EQUAL(prefs.get_customizer_entry_for_customizer_type(old.customizer_type), old, "Migration must preserve the entry.")
	var/datum/customizer/customizer = CUSTOMIZER(old.customizer_type)
	var/datum/customizer_entry/organ/penis/replacement = customizer.create_customizer_entry(prefs, /datum/customizer_choice/organ/penis/taur/tentacle)
	allocated += replacement
	TEST_ASSERT_EQUAL(replacement.accessory_type, /datum/sprite_accessory/penis/taur/tentacle, "Changing choice must change the form.")
	TEST_ASSERT_EQUAL(replacement.accessory_colors, old.accessory_colors, "Changing shape must preserve both colors.")
	TEST_ASSERT_EQUAL(replacement.penis_size, MAX_PENIS_SIZE, "Changing shape must preserve size.")
	TEST_ASSERT_EQUAL(replacement.sheath_type, SHEATH_TYPE_SLIT, "Changing shape must preserve sheath.")
	TEST_ASSERT(replacement.massive, "Changing shape must preserve the purchase preference.")
	TEST_ASSERT(replacement.disabled, "Changing shape must preserve disabled state.")

/datum/unit_test/taur_mirror_catalogue/Run()
	var/list/ordinary = get_mirror_genital_options(ORGAN_SLOT_PENIS, null)
	for(var/accessory_type in subtypesof(/datum/sprite_accessory/penis))
		TEST_ASSERT_EQUAL((accessory_type in ordinary), !ispath(accessory_type, /datum/sprite_accessory/penis/taur), "Ordinary Mirror retains exactly the ordinary appearances.")
	var/list/taur = get_mirror_genital_options(ORGAN_SLOT_PENIS, /obj/item/bodypart/taur/canine)
	var/datum/customizer/catalogue = CUSTOMIZER(/datum/customizer/organ/penis/taur)
	TEST_ASSERT_EQUAL(length(taur), length(catalogue.customizer_choices), "Mirror must expose every selectable taur form.")
	for(var/choice_type in catalogue.customizer_choices)
		var/datum/customizer_choice/organ/choice = CUSTOMIZER_CHOICE(choice_type)
		TEST_ASSERT_EQUAL(taur[choice.default_accessory], choice.organ_type, "Mirror and Features must create the same organ for an empty slot.")
	var/list/ordinary_testicles = get_mirror_genital_options(ORGAN_SLOT_TESTICLES, null)
	TEST_ASSERT(/datum/sprite_accessory/testicles/pair in ordinary_testicles, "Ordinary Pair must remain selectable.")
	TEST_ASSERT(!(/datum/sprite_accessory/testicles/taur in ordinary_testicles), "Ordinary Mirror must exclude taur Pair.")
	var/list/taur_testicles = get_mirror_genital_options(ORGAN_SLOT_TESTICLES, /obj/item/bodypart/taur/canine)
	TEST_ASSERT_EQUAL(length(taur_testicles), 2, "Taur bodies offer Pair and Hidden.")
	TEST_ASSERT(!(/datum/sprite_accessory/testicles/taur/hidden in ordinary_testicles), "Ordinary Mirror must exclude taur Hidden.")
	TEST_ASSERT_EQUAL(taur_testicles[/datum/sprite_accessory/testicles/taur], /obj/item/organ/testicles, "Taur Pair creates testicles.")

/datum/unit_test/taur_mirror_preserves_organ/Run()
	var/mob/living/carbon/human/person = allocate(/mob/living/carbon/human/consistent)
	person.Taurize(/obj/item/bodypart/taur/deer)
	var/obj/item/organ/penis/member = person.getorganslot(ORGAN_SLOT_PENIS)
	if(member)
		member.Remove(person, TRUE)
		qdel(member)
	var/list/options = get_mirror_genital_options(ORGAN_SLOT_PENIS, /obj/item/bodypart/taur/deer)
	TEST_ASSERT(apply_mirror_genital_appearance(person, ORGAN_SLOT_PENIS, /datum/sprite_accessory/penis/taur/flared, options), "Mirror must create the selected shape for an empty slot.")
	member = person.getorganslot(ORGAN_SLOT_PENIS)
	TEST_ASSERT(istype(member, /obj/item/organ/penis/equine), "Flared must create an equine organ.")
	member.set_penis_size(MAX_PENIS_SIZE)
	member.set_massive(TRUE)
	member.damage = 7
	member.branded_writing = "test"
	member.set_accessory_type(member.accessory_type, "#654321#FEDCBA")
	TEST_ASSERT(apply_mirror_genital_appearance(person, ORGAN_SLOT_PENIS, /datum/sprite_accessory/penis/taur/tapered, options), "Mirror must allow another appearance.")
	TEST_ASSERT_EQUAL(person.getorganslot(ORGAN_SLOT_PENIS), member, "Styling must keep the same organ.")
	TEST_ASSERT_EQUAL(member.accessory_type, /datum/sprite_accessory/penis/taur/tapered, "The selected sprite must actually change.")
	TEST_ASSERT(member.massive && member.damage == 7 && member.branded_writing == "test", "Styling must preserve Massive, damage and branding.")
	TEST_ASSERT_EQUAL(member.accessory_colors, "#654321#FEDCBA", "Styling must preserve the palette.")

/datum/unit_test/taur_hidden_testicles/Run()
	var/datum/preferences/prefs = allocate(/datum/preferences/taur_genital_test)
	var/datum/species/species = allocate(/datum/species/anthromorph)
	prefs.pref_species = species
	prefs.gender = MALE
	prefs.taur_type = /obj/item/bodypart/taur/canine
	prefs.validate_customizer_entries()
	allocated += prefs.customizer_entries
	var/datum/customizer_entry/organ/testicles/entry = prefs.get_customizer_entry_for_customizer_type(/datum/customizer/organ/testicles/taur)
	var/datum/customizer_choice/organ/testicles/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
	entry.ball_size = MAX_TESTICLES_SIZE
	entry.virility = FALSE
	entry.accessory_colors = "#ABCDEF"
	choice.set_accessory_type(prefs, /datum/sprite_accessory/testicles/taur/hidden, entry)
	var/list/organ_dna = prefs.get_organ_dna_list()
	for(var/slot in organ_dna)
		allocated += organ_dna[slot]
	var/datum/organ_dna/testicles/dna = organ_dna[ORGAN_SLOT_TESTICLES]
	TEST_ASSERT(dna && dna.can_create_organ(), "Hidden must still create an organ.")
	TEST_ASSERT_EQUAL(dna.accessory_type, /datum/sprite_accessory/testicles/taur/hidden, "Hidden must be applied through the saved accessory.")
	TEST_ASSERT_EQUAL(dna.accessory_colors, "#ABCDEF", "Hiding the sprite must preserve its color.")

	var/mob/living/carbon/human/person = allocate(/mob/living/carbon/human/consistent)
	person.Taurize(prefs.taur_type)
	person.sexcon.bottom_exposed = TRUE
	var/obj/item/organ/testicles/pair = dna.create_organ()
	allocated += pair
	pair.Insert(person, TRUE, FALSE)
	var/obj/item/bodypart/chest = person.get_bodypart(BODY_ZONE_CHEST)
	TEST_ASSERT_NULL(pair.get_bodypart_overlay(chest), "Hidden does not produce a sprite while exposed.")

	var/list/options = get_mirror_genital_options(ORGAN_SLOT_TESTICLES, prefs.taur_type)
	TEST_ASSERT(apply_mirror_genital_appearance(person, ORGAN_SLOT_TESTICLES, /datum/sprite_accessory/testicles/taur, options), "Mirror must allow restoring Pair.")
	TEST_ASSERT_EQUAL(person.getorganslot(ORGAN_SLOT_TESTICLES), pair, "Mirror must retain the existing organ.")
	TEST_ASSERT(length(pair.get_bodypart_overlay(chest)), "Restoring Pair must show the sprite.")
	TEST_ASSERT(pair.ball_size == MAX_TESTICLES_SIZE && !pair.virility, "Changing visibility must retain size and fertility.")

/datum/unit_test/taur_render_body_changes/Run()
	var/mob/living/carbon/human/person = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/recipient = allocate(/mob/living/carbon/human/consistent)
	person.Taurize(/obj/item/bodypart/taur/tiger)
	var/obj/item/organ/penis/member = allocate(/obj/item/organ/penis/knotted)
	member.Insert(person, TRUE, FALSE)
	member.accessory_type = /datum/sprite_accessory/penis/taur/knotted
	member.accessory_colors = "#123456#ABCDEF"
	member.penis_size = MAX_PENIS_SIZE
	member.sheath_type = SHEATH_TYPE_SLIT
	member.erect_state = ERECT_STATE_PARTIAL
	var/original_key = member.get_icon_cache_key(null)
	TEST_ASSERT_EQUAL(member.get_render_accessory_type(), member.accessory_type, "Taur art must be selected on the taur body.")
	person.ensure_not_taur()
	TEST_ASSERT_EQUAL(member.get_render_accessory_type(), /datum/sprite_accessory/penis/knotted, "Losing the taur body must select ordinary art.")
	TEST_ASSERT(member.get_icon_cache_key(null) != original_key, "Body changes must invalidate chest overlay caches.")
	person.Taurize(/obj/item/bodypart/taur/horse)
	TEST_ASSERT_EQUAL(member.get_icon_cache_key(null), original_key, "Bodies using the same sprite set should reuse the same cache key.")
	member.Remove(person, TRUE)
	member.Insert(recipient, TRUE, FALSE)
	TEST_ASSERT_EQUAL(member.get_render_accessory_type(), /datum/sprite_accessory/penis/knotted, "A new ordinary owner must get ordinary art.")
	recipient.Taurize(/obj/item/bodypart/taur/canine)
	TEST_ASSERT_EQUAL(member.get_render_accessory_type(), /datum/sprite_accessory/penis/taur/knotted, "Returning to a taur body must restore taur art.")
	TEST_ASSERT_EQUAL(member.accessory_colors, "#123456#ABCDEF", "Rendering must preserve both colors.")
	TEST_ASSERT_EQUAL(member.penis_size, MAX_PENIS_SIZE, "Rendering must preserve size.")
	TEST_ASSERT_EQUAL(member.sheath_type, SHEATH_TYPE_SLIT, "Rendering must preserve sheath.")
	TEST_ASSERT_EQUAL(member.erect_state, ERECT_STATE_PARTIAL, "Rendering must preserve state.")
	member.accessory_type = /datum/sprite_accessory/penis/flared
	TEST_ASSERT_EQUAL(member.get_render_accessory_type(), /datum/sprite_accessory/penis/taur/flared, "Ordinary art must adapt to a new taur owner.")
	member.accessory_type = /datum/sprite_accessory/penis/tapered_mammal
	TEST_ASSERT_EQUAL(member.get_render_accessory_type(), /datum/sprite_accessory/penis/taur/tapered, "Mammalian Tapered must use its existing taur equivalent.")
	TEST_ASSERT_EQUAL(member.accessory_type, /datum/sprite_accessory/penis/tapered_mammal, "Choosing compatible art must preserve the stored mammalian form.")
	recipient.ensure_not_taur()
	TEST_ASSERT_EQUAL(member.get_render_accessory_type(), /datum/sprite_accessory/penis/tapered_mammal, "Removing the taur body must restore the original mammalian form.")
	recipient.Taurize(/obj/item/bodypart/taur/canine)
	member.accessory_type = /datum/sprite_accessory/penis/hemi
	TEST_ASSERT_EQUAL(member.get_render_accessory_type(), /datum/sprite_accessory/penis/hemi, "Unsupported forms must not silently become a different anatomy.")
	member.Remove(recipient, TRUE)
	var/obj/item/organ/testicles/testicles = allocate(/obj/item/organ/testicles)
	testicles.Insert(person, TRUE, FALSE)
	testicles.accessory_type = /datum/sprite_accessory/testicles/pair
	TEST_ASSERT_EQUAL(testicles.get_render_accessory_type(), /datum/sprite_accessory/testicles/taur, "Ordinary Pair must adapt to taur owners.")
	testicles.accessory_type = /datum/sprite_accessory/testicles/taur
	person.ensure_not_taur()
	TEST_ASSERT_EQUAL(testicles.get_render_accessory_type(), /datum/sprite_accessory/testicles/pair, "Taur Pair must remain visible after the body is removed.")
	testicles.Remove(person, TRUE)
