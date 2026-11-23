/datum/unit_test/taur_genital_body_selection/Run()
	for(var/body_type in list(/obj/item/bodypart/taur/canine, /obj/item/bodypart/taur/horse, /obj/item/bodypart/taur/deer))
		TEST_ASSERT(uses_taur_genital_sprites(body_type), "Quadruped bodies should use the alternate sprite set.")
	for(var/body_type in list(null, /obj/item/bodypart/taur, /obj/item/bodypart/taur/centipede, /obj/item/bodypart/taur/goat, /obj/item/bodypart/taur/lamia, /obj/item/bodypart/taur/mermaid, /obj/item/bodypart/chest, "/obj/item/bodypart/taur/canine", 1))
		TEST_ASSERT(!uses_taur_genital_sprites(body_type), "Unsupported input [body_type] must retain ordinary sprites.")
	for(var/body_type in list(/obj/item/bodypart/taur/centipede, /obj/item/bodypart/taur/ant, /obj/item/bodypart/taur/insect, /obj/item/bodypart/taur/spider, /obj/item/bodypart/taur/wasp))
		TEST_ASSERT(!uses_taur_genital_sprites(body_type), "Arthropod bodies must use ordinary sprites.")
		TEST_ASSERT_EQUAL(resolve_taur_genital_accessory(/datum/sprite_accessory/penis/taur/knotted, body_type), /datum/sprite_accessory/penis/knotted, "Saved taur forms must resolve to ordinary sprites on arthropod bodies.")
		TEST_ASSERT_EQUAL(resolve_taur_genital_accessory(/datum/sprite_accessory/testicles/taur, body_type), /datum/sprite_accessory/testicles/pair, "Saved taur testicles must resolve to ordinary sprites on arthropod bodies.")

/datum/unit_test/taur_genital_placement/Run()
	var/mob/living/carbon/human/person = allocate(/mob/living/carbon/human/consistent)
	var/obj/item/organ/penis/member = allocate(/obj/item/organ/penis)
	member.accessory_type = /datum/sprite_accessory/penis/taur/knotted
	member.Insert(person, TRUE, FALSE)
	member.erect_state = ERECT_STATE_HARD

	person.Taurize(/obj/item/bodypart/taur/horse)
	var/base_key = member.get_icon_cache_key(null)
	var/list/keys = list(base_key)
	var/list/body_types = list(/obj/item/bodypart/taur/canine, /obj/item/bodypart/taur/deer, /obj/item/bodypart/taur/sloog)
	for(var/body_type in body_types)
		person.Taurize(body_type)
		var/placed_key = member.get_icon_cache_key(null)
		TEST_ASSERT(!(placed_key in keys), "Different placements must have distinct limb cache keys.")
		keys += placed_key

	for(var/accessory_type in subtypesof(/datum/sprite_accessory/penis/taur))
		var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
		person.Taurize(/obj/item/bodypart/taur/horse)
		var/list/base_appearances = accessory.get_overlay(accessory.get_icon_state(member, null, person), "#FFFFFF#777777")
		var/mutable_appearance/base_sprite = base_appearances[1]
		for(var/body_type in body_types)
			person.Taurize(body_type)
			var/list/placed_appearances = accessory.get_overlay(accessory.get_icon_state(member, null, person), "#FFFFFF#777777")
			var/mutable_appearance/placed_sprite = placed_appearances[1]
			TEST_ASSERT_EQUAL(placed_sprite.pixel_y, base_sprite.pixel_y, "Offsets belong to the frame.")
			for(var/direction in GLOB.cardinals)
				var/icon/expected = icon(base_sprite.icon, base_sprite.icon_state, direction)
				switch(body_type)
					if(/obj/item/bodypart/taur/canine)
						expected.Shift(SOUTH, 2)
					if(/obj/item/bodypart/taur/deer)
						expected.Shift(NORTH, 2)
					if(/obj/item/bodypart/taur/sloog)
						if(direction == EAST || direction == WEST)
							expected.Shift(REVERSE_DIR(direction), 6)
							expected.Shift(SOUTH, 2)
				var/icon/actual = icon(placed_sprite.icon, placed_sprite.icon_state, direction)
				TEST_ASSERT(!taur_sprite_images_differ(expected, actual), "Placement differs from expected for [body_type], [accessory_type], direction [direction].")

/datum/unit_test/taur_genital_cache_states/Run()
	var/obj/item/organ/penis/member = allocate(/obj/item/organ/penis)
	for(var/accessory_type in list(/datum/sprite_accessory/penis/knotted, /datum/sprite_accessory/penis/taur/knotted))
		member.accessory_type = accessory_type
		member.penis_size = DEFAULT_PENIS_SIZE
		member.erect_state = ERECT_STATE_NONE
		member.sheath_type = SHEATH_TYPE_NORMAL
		var/original_key = member.get_icon_cache_key(null)
		TEST_ASSERT_EQUAL(member.get_icon_cache_key(null), original_key, "Unchanged appearance must reuse its cache key.")
		member.erect_state = ERECT_STATE_HARD
		TEST_ASSERT(member.get_icon_cache_key(null) != original_key, "Erection changes must not reuse the relaxed image's cache key.")
		member.erect_state = ERECT_STATE_NONE
		member.penis_size = MIN_PENIS_SIZE
		TEST_ASSERT(member.get_icon_cache_key(null) != original_key, "Different member sizes must not share a cache key.")
		member.penis_size = DEFAULT_PENIS_SIZE
		member.sheath_type = SHEATH_TYPE_SLIT
		TEST_ASSERT(member.get_icon_cache_key(null) != original_key, "Slit and sheath must not share a cache key.")
		member.sheath_type = SHEATH_TYPE_NORMAL
		TEST_ASSERT_EQUAL(member.get_icon_cache_key(null), original_key, "Restoring appearance must restore its reusable key.")
	member.penis_size = MAX_PENIS_SIZE
	member.erect_state = ERECT_STATE_HARD
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(/datum/sprite_accessory/penis/taur/knotted)
	var/unpaid_key = member.get_icon_cache_key(null)
	TEST_ASSERT_EQUAL(accessory.get_icon_state(member, null, null), "m_penis_knotted_2_1", "Large uses the ordinary frame until Massive is active.")
	member.set_massive(TRUE)
	TEST_ASSERT(member.get_icon_cache_key(null) != unpaid_key, "Massive must invalidate the cache.")
	TEST_ASSERT_EQUAL(accessory.get_icon_state(member, null, null), "m_penis_knotted_3_1", "Massive enables the largest taur frame.")
	var/obj/item/organ/testicles/testicles = allocate(/obj/item/organ/testicles)
	for(var/accessory_type in list(/datum/sprite_accessory/testicles/pair, /datum/sprite_accessory/testicles/taur))
		testicles.accessory_type = accessory_type
		testicles.ball_size = MIN_TESTICLES_SIZE
		var/original_key = testicles.get_icon_cache_key(null)
		testicles.ball_size = MAX_TESTICLES_SIZE
		TEST_ASSERT(testicles.get_icon_cache_key(null) != original_key, "Different testicle sizes must not share a cache key.")
		testicles.ball_size = MIN_TESTICLES_SIZE
		TEST_ASSERT_EQUAL(testicles.get_icon_cache_key(null), original_key, "Restoring testicle size must restore its reusable key.")

/datum/unit_test/taur_genital_customizer_anatomy/Run()
	var/datum/preferences/prefs = allocate(/datum/preferences/taur_genital_test)
	var/datum/customizer/customizer = CUSTOMIZER(/datum/customizer/organ/penis/taur)
	var/list/expected_organs = list(/obj/item/organ/penis/knotted, /obj/item/organ/penis/equine, /obj/item/organ/penis/tapered, /obj/item/organ/penis/barbed_knotted, /obj/item/organ/penis/tentacle)
	TEST_ASSERT_EQUAL(length(customizer.customizer_choices), 5, "Only the five dedicated taur shapes should be selectable.")
	var/i = 0
	for(var/choice_type in customizer.customizer_choices)
		var/datum/customizer_choice/organ/penis/choice = CUSTOMIZER_CHOICE(choice_type)
		var/datum/customizer_entry/organ/penis/entry = customizer.create_customizer_entry(prefs, choice_type)
		allocated += entry
		entry.accessory_colors = "#123456#ABCDEF"
		entry.penis_size = MIN_PENIS_SIZE
		entry.functional = FALSE
		entry.sheath_type = SHEATH_TYPE_SLIT
		var/datum/organ_dna/penis/dna = choice.create_organ_dna(entry, prefs)
		allocated += dna
		i++
		TEST_ASSERT_EQUAL(dna.organ_type, expected_organs[i], "The choice must declare its actual organ mechanics.")
		TEST_ASSERT_EQUAL(dna.accessory_type, choice.default_accessory, "DNA must select the separate taur accessory.")
		TEST_ASSERT_EQUAL(dna.accessory_colors, "#123456#ABCDEF", "DNA must preserve both colors.")
		TEST_ASSERT_EQUAL(dna.penis_size, MIN_PENIS_SIZE, "Visual size clamping must not affect DNA.")
		TEST_ASSERT(dna.functional, "Taur organs must remain functional without a preference toggle.")
		TEST_ASSERT_EQUAL(dna.sheath_type, SHEATH_TYPE_SLIT, "The selected sheath must survive imprinting.")

/// Preferences fixture without client, savefile or random-character initialization.
/datum/preferences/taur_genital_test/New()
	return

/datum/unit_test/taur_genital_functional_option/Run()
	var/datum/preferences/prefs = allocate(/datum/preferences/taur_genital_test)
	var/datum/customizer_choice/organ/penis/choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/organ/penis/taur/knotted)
	var/datum/customizer_entry/organ/penis/entry = new
	allocated += entry
	entry.functional = FALSE
	entry.accessory_type = /datum/sprite_accessory/penis/taur/flared
	entry.accessory_colors = "#FFFFFF#777777"
	prefs.taur_type = /obj/item/bodypart/taur/canine
	var/list/menu = choice.show_pref_choices(prefs, entry, /datum/customizer/organ/penis/anthro)
	TEST_ASSERT(!findtext(jointext(menu, ""), "customizer_task=functional"), "Taur UI must not offer Functional.")
	choice.handle_topic(null, list("customizer_task" = "functional"), prefs, entry, /datum/customizer/organ/penis/anthro)
	TEST_ASSERT_EQUAL(entry.functional, FALSE, "A stale taur link must not change saved preferences.")
	var/datum/organ_dna/penis/taur_dna = choice.create_organ_dna(entry, prefs)
	allocated += taur_dna
	TEST_ASSERT_EQUAL(taur_dna.functional, TRUE, "Legacy FALSE must not remain as an inaccessible taur setting.")
	TEST_ASSERT_EQUAL(entry.functional, FALSE, "Taur defaults must not erase the saved normal-body preference.")
	prefs.taur_type = null
	choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/organ/penis/equine)
	entry.accessory_type = /datum/sprite_accessory/penis/flared
	menu = choice.show_pref_choices(prefs, entry, /datum/customizer/organ/penis/anthro)
	TEST_ASSERT(findtext(jointext(menu, ""), "customizer_task=functional"), "Ordinary bodies retain the existing option.")
	var/datum/organ_dna/penis/normal_dna = choice.create_organ_dna(entry, prefs)
	allocated += normal_dna
	TEST_ASSERT_EQUAL(normal_dna.functional, FALSE, "Ordinary body settings must remain unchanged.")
	choice.handle_topic(null, list("customizer_task" = "functional"), prefs, entry, /datum/customizer/organ/penis/anthro)
	TEST_ASSERT_EQUAL(entry.functional, TRUE, "The ordinary-body toggle must still work.")

/datum/unit_test/taur_genital_render/Run()
	var/obj/item/organ/penis/member = allocate(/obj/item/organ/penis)
	for(var/accessory_type in subtypesof(/datum/sprite_accessory/penis/taur))
		var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
		for(var/size in MIN_PENIS_SIZE to MAX_PENIS_SIZE)
			member.penis_size = size
			for(var/state in ERECT_STATE_NONE to ERECT_STATE_HARD)
				member.erect_state = state
				for(var/sheath in SHEATH_TYPE_NONE to SHEATH_TYPE_SLIT)
					member.sheath_type = sheath
					var/state_name = accessory.get_icon_state(member, null, null)
					TEST_ASSERT("[state_name]_BEHIND_primary" in icon_states(accessory.icon), "Every supported state must exist in the source DMI.")
					var/list/appearances = accessory.get_overlay(state_name, "#FFFFFF#777777")
					TEST_ASSERT_EQUAL(length(appearances), 1, "Use one ordinary accessory overlay.")
					var/mutable_appearance/appearance = appearances[1]
					var/icon/rendered = icon(appearance.icon, appearance.icon_state)
					TEST_ASSERT_EQUAL(rendered.Width(), 64, "Retain the source width.")
					TEST_ASSERT_EQUAL(rendered.Height(), 32, "Retain the source height.")
					TEST_ASSERT_EQUAL(appearance.pixel_x, -16, "Center the 64-pixel sprite on the 32-pixel body.")
					TEST_ASSERT_EQUAL(appearance.pixel_y, 0, "Use the source vertical placement.")
					TEST_ASSERT_EQUAL(appearance.layer, -BODY_BEHIND_LAYER, "Use the source BEHIND layer.")
					TEST_ASSERT_EQUAL(member.penis_size, size, "Rendering must not change mechanical size.")
		var/list/first = accessory.get_overlay(accessory.get_icon_state(member, null, null), "#FFFFFF#777777")
		var/list/second = accessory.get_overlay(accessory.get_icon_state(member, null, null), "#FFFFFF#777777")
		var/mutable_appearance/a = first[1]
		var/mutable_appearance/b = second[1]
		TEST_ASSERT(a != b, "Owners must not share mutable appearances.")
	var/obj/item/organ/testicles/testicles = allocate(/obj/item/organ/testicles)
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(/datum/sprite_accessory/testicles/taur)
	for(var/size in MIN_TESTICLES_SIZE to MAX_TESTICLES_SIZE)
		testicles.ball_size = size
		var/state_name = accessory.get_icon_state(testicles, null, null)
		TEST_ASSERT("[state_name]_FRONT" in icon_states(accessory.icon), "The testicle state must exist in the source DMI.")
		var/list/appearances = accessory.get_overlay(state_name, "#777777")
		TEST_ASSERT_EQUAL(length(appearances), 1, "Testicles use one ordinary accessory overlay.")
		var/mutable_appearance/appearance = appearances[1]
		TEST_ASSERT_EQUAL(appearance.layer, -BODY_FRONT_LAYER, "Retain the testicle FRONT layer.")
	var/datum/sprite_accessory/ordinary = SPRITE_ACCESSORY(/datum/sprite_accessory/penis/flared)
	TEST_ASSERT_EQUAL(ordinary.icon, 'icons/mob/sprite_accessory/genitals/pintle.dmi', "Do not mutate shared ordinary accessories.")

/datum/unit_test/taur_genital_invalid_sizes/Run()
	var/obj/item/organ/penis/member = allocate(/obj/item/organ/penis)
	var/obj/item/organ/testicles/testicles = allocate(/obj/item/organ/testicles)
	var/datum/sprite_accessory/penis_accessory = SPRITE_ACCESSORY(/datum/sprite_accessory/penis/taur/knotted)
	var/datum/sprite_accessory/testicle_accessory = SPRITE_ACCESSORY(/datum/sprite_accessory/testicles/taur)
	for(var/size in list(null, -1, 4, 6, 1.5, "2"))
		member.penis_size = size
		testicles.ball_size = size
		TEST_ASSERT_NULL(penis_accessory.get_icon_state(member, null, null), "Invalid sizes must not render.")
		TEST_ASSERT_NULL(testicle_accessory.get_icon_state(testicles, null, null), "Invalid sizes must not render.")

/datum/unit_test/taur_genital_colors/Run()
	var/obj/item/organ/penis/member = allocate(/obj/item/organ/penis)
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(/datum/sprite_accessory/penis/taur/flared)
	member.sheath_type = SHEATH_TYPE_NORMAL
	for(var/state in ERECT_STATE_NONE to ERECT_STATE_HARD)
		member.erect_state = state
		var/list/base = accessory.get_overlay(accessory.get_icon_state(member, null, null), "#FF0000#00FF00")
		var/list/member_changed = accessory.get_overlay(accessory.get_icon_state(member, null, null), "#0000FF#00FF00")
		var/list/sheath_changed = accessory.get_overlay(accessory.get_icon_state(member, null, null), "#FF0000#0000FF")
		var/mutable_appearance/base_appearance = base[1]
		var/mutable_appearance/member_appearance = member_changed[1]
		var/mutable_appearance/sheath_appearance = sheath_changed[1]
		TEST_ASSERT(taur_sprite_images_differ(icon(base_appearance.icon, base_appearance.icon_state), icon(member_appearance.icon, member_appearance.icon_state)), "Member color affects the tip, including one SOUTH pixel when retracted.")
		if(state == ERECT_STATE_NONE)
			TEST_ASSERT(!taur_sprite_images_differ(icon(base_appearance.icon, base_appearance.icon_state), icon(member_appearance.icon, member_appearance.icon_state), EAST), "The retracted EAST frame is entirely sheath and must ignore Member color.")
		TEST_ASSERT_EQUAL(taur_sprite_images_differ(icon(base_appearance.icon, base_appearance.icon_state), icon(sheath_appearance.icon, sheath_appearance.icon_state)), state != ERECT_STATE_HARD, "Sheath color must affect the sheath, not exposed anatomy.")
	TEST_ASSERT_EQUAL(accessory.color_key_names[2], "Sheath / slit", "The separate taur accessory labels its own colors.")
	var/datum/sprite_accessory/ordinary = SPRITE_ACCESSORY(/datum/sprite_accessory/penis/flared)
	TEST_ASSERT_EQUAL(ordinary.color_key_names[2], "Skin", "Ordinary accessory labels remain unchanged.")

/proc/taur_sprite_images_differ(icon/first, icon/second, only_direction = 0)
	for(var/direction in list(SOUTH, NORTH, EAST, WEST))
		if(only_direction && direction != only_direction)
			continue
		var/icon/a = icon(first, dir = direction)
		var/icon/b = icon(second, dir = direction)
		for(var/x in 1 to a.Width())
			for(var/y in 1 to a.Height())
				if(a.GetPixel(x, y) != b.GetPixel(x, y))
					return TRUE
	return FALSE
