/datum/unit_test/horse_taur_assets/Run()
	var/datum/species/anthromorph/species = new
	var/list/taurs = species.get_taur_list()
	TEST_ASSERT(/obj/item/bodypart/taur/horse in taurs, "The existing Saiga Body must remain available.")
	TEST_ASSERT(/obj/item/bodypart/taur/equine in taurs, "Horse Body must be available alongside Saiga Body.")
	TEST_ASSERT(!(/obj/item/bodypart/taur/equine in species.allowed_taur_types), "Building the picker must not mutate the species list.")
	qdel(species)
	var/obj/item/bodypart/taur/equine/horse = allocate(/obj/item/bodypart/taur/equine)
	// Taurize normally supplies all three colors before rendering the body.
	horse.taur_color = COLOR_WHITE
	horse.taur_markings = COLOR_WHITE
	horse.taur_tertiary = COLOR_WHITE
	TEST_ASSERT_EQUAL(horse.color_blend_mode, ICON_MULTIPLY, "Horse colors must preserve the supplied shading.")
	var/list/body_appearances = horse.get_limb_icon(FALSE)
	var/image/front_below = body_appearances[4]
	TEST_ASSERT_EQUAL(front_below.layer, -(BODY_BEHIND_LAYER + 0.1), "The front strip must draw below the normal genital layer.")
	var/icon/front_south = icon(front_below.icon, "", SOUTH)
	TEST_ASSERT_NOTNULL(front_south.GetPixel(32, 7), "The South view must retain the separated center strip.")
	for(var/direction in list(NORTH, EAST, WEST))
		var/icon/other_view = icon(front_below.icon, "", direction)
		TEST_ASSERT_NULL(other_view.GetPixel(32, 7), "The below-body strip must not affect other directions.")
	var/list/states = icon_states(horse.taur_clothing_icon)
	var/list/expected_clothing_states = list(
		"leather_h", "chainmail_h", "plate_h", "padded_h",
		"caparison_h", "caparison-tabard_h", "psydon_h", "astrata_h",
		"saddle_h", "saddlebag_h", "plate-tasset1_h", "plate-tasset2_h",
	)
	for(var/state in expected_clothing_states)
		TEST_ASSERT(state in states, "Missing horse clothing state: [state]")
	var/datum/sprite_accessory/ears/horse/ears = SPRITE_ACCESSORY(/datum/sprite_accessory/ears/horse)
	var/list/ear_states = icon_states(ears.icon)
	for(var/state in list("horse_ADJ_1", "horse_ADJ_2", "horse_FRONT_1", "horse_FRONT_2"))
		TEST_ASSERT(state in ear_states, "Missing horse ear state: [state]")

/datum/unit_test/horse_taur_cape_controls/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	human.Taurize(/obj/item/bodypart/taur/equine)
	var/datum/intent/kick/kick = allocate(/datum/intent/kick, human)
	human.mmb_intent = kick
	var/list/cape_types = typesof(/obj/item/clothing/cloak/cape)
	cape_types |= typesof(/obj/item/clothing/cloak/citywatch)
	cape_types += list(
		/obj/item/clothing/cloak/ordinatorcape,
		/obj/item/clothing/cloak/captain,
		/obj/item/clothing/cloak/duelistcape,
		/obj/item/clothing/cloak/psydonicironcape,
	)
	for(var/cape_type in cape_types)
		var/obj/item/clothing/cloak/cape = allocate(cape_type)
		cape.forceMove(human)
		human.cloak = cape
		var/normal_layer = cape.alternate_worn_layer
		cape.MiddleClick(human)
		TEST_ASSERT_EQUAL(cape.alternate_worn_layer, UNDER_ARMOR_LAYER, "[cape_type] must tuck when its MMB handler is invoked.")
		human.update_inv_cloak_real()
		TEST_ASSERT_NOTNULL(human.overlays_standing[UNDER_ARMOR_LAYER], "[cape_type] must retain its tucked appearance.")
		cape.MiddleClick(human)
		TEST_ASSERT(cape.wear_over_taur, "[cape_type] must offer a separate taur-draped position.")
		human.update_inv_cloak_real()
		TEST_ASSERT_NOTNULL(human.overlays_standing[TABARD_LAYER], "[cape_type] must show fitted cloth over the taur body.")
		cape.MiddleClick(human)
		TEST_ASSERT(!cape.wear_over_taur, "[cape_type] must leave the taur-draped position when the third MMB restores normal wear.")
		TEST_ASSERT_EQUAL(cape.alternate_worn_layer, normal_layer, "[cape_type] must restore its original position.")
		TEST_ASSERT_EQUAL(human.mmb_intent, kick, "Adjusting clothing must preserve the selected combat intent.")
		human.cloak = null
		cape.forceMove(run_loc_floor_bottom_left)

/datum/unit_test/horse_taur_cape_layers/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	human.Taurize(/obj/item/bodypart/taur/equine)
	var/obj/item/bodypart/taur/equine/horse = human.get_taur_tail()
	var/obj/item/clothing/cloak/cape/puritan/cape = allocate(/obj/item/clothing/cloak/cape/puritan)
	cape.forceMove(human)
	human.cloak = cape
	var/list/original_panels = human.get_sleeves_layer(cape, 0, CLOAK_LAYER)
	human.update_inv_cloak_real()
	var/list/panels = human.overlays_standing[CLOAK_LAYER]
	TEST_ASSERT(length(panels) && length(panels) == length(original_panels), "The Exorcist cape must retain its front panels.")
	var/occluded_pixels = 0
	for(var/index in 1 to length(panels))
		var/mutable_appearance/original = original_panels[index]
		var/mutable_appearance/clipped = panels[index]
		var/icon/mask = horse.get_north_clothing_mask(32, 32, clipped.pixel_x, clipped.pixel_y)
		var/icon/north_mask = icon(mask, "", NORTH)
		for(var/direction in list(SOUTH, NORTH, EAST, WEST))
			var/icon/expected = icon(original.icon, original.icon_state, direction)
			var/icon/actual = icon(clipped.icon, clipped.icon_state, direction)
			for(var/x in 1 to 32)
				for(var/y in 1 to 32)
					var/expected_pixel = expected.GetPixel(x, y)
					if(direction == NORTH && isnull(north_mask.GetPixel(x, y)))
						if(expected_pixel)
							occluded_pixels++
						expected_pixel = null
					TEST_ASSERT_EQUAL(actual.GetPixel(x, y), expected_pixel, "Cape panels must hide behind the horse silhouette only in North.")
	TEST_ASSERT(occluded_pixels, "The test must exercise cape pixels that would otherwise overlap the horse body.")
	cape.MiddleClick(human)
	human.update_inv_cloak_real()
	TEST_ASSERT_EQUAL(cape.alternate_worn_layer, UNDER_ARMOR_LAYER, "The selected position must tuck the worn cape beneath armor.")
	var/list/tucked = human.overlays_standing[UNDER_ARMOR_LAYER]
	TEST_ASSERT(islist(tucked) && length(tucked) == 2, "Tucking must retain the cape body and fitted taur cloth.")
	var/mutable_appearance/tucked_body = tucked[1]
	var/mutable_appearance/tucked_cloth = tucked[2]
	TEST_ASSERT_EQUAL(tucked_cloth.layer, -(SHIRT_LAYER + 0.1), "Tucked cloth must remain below padding and armor.")
	TEST_ASSERT_EQUAL(tucked_body.layer, -UNDER_ARMOR_LAYER, "The cape body must use the tucked layer.")
	panels = human.overlays_standing[CLOAK_LAYER]
	for(var/mutable_appearance/panel as anything in panels)
		TEST_ASSERT_EQUAL(panel.layer, -UNDER_ARMOR_LAYER, "Cape front panels must tuck under armor with the body.")
	cape.MiddleClick(human)
	human.update_inv_cloak_real()
	TEST_ASSERT(cape.wear_over_taur, "The selected position must drape the cape over the taur body.")
	var/mutable_appearance/draped_cloth = human.overlays_standing[TABARD_LAYER]
	TEST_ASSERT_NOTNULL(draped_cloth, "The draped cape must have a fitted taur overlay.")
	TEST_ASSERT_EQUAL(draped_cloth.icon_state, "caparison_h", "Horse drapes must use the fitted horse cloth artwork.")
	TEST_ASSERT_EQUAL(draped_cloth.layer, -TABARD_LAYER, "Draped cloth must sit above taur armor.")
	panels = human.overlays_standing[CLOAK_LAYER]
	for(var/index in 1 to length(panels))
		var/mutable_appearance/original = original_panels[index]
		var/mutable_appearance/draped = panels[index]
		var/icon/expected = icon(original.icon, original.icon_state, NORTH)
		var/icon/actual = icon(draped.icon, draped.icon_state, NORTH)
		for(var/x in 1 to 32)
			for(var/y in 1 to 32)
				TEST_ASSERT_EQUAL(actual.GetPixel(x, y), expected.GetPixel(x, y), "Draped front panels must remain visible over the taur in North.")
	cape.MiddleClick(human)
	human.update_inv_cloak_real()
	TEST_ASSERT(!cape.wear_over_taur, "Normal wear must restore normal shoulder wear.")
	TEST_ASSERT_NULL(human.overlays_standing[TABARD_LAYER], "Normal shoulder wear must remove the fitted body drape.")
	TEST_ASSERT_EQUAL(cape.alternate_worn_layer, initial(cape.alternate_worn_layer), "Normal wear must restore the normal cape position.")
	TEST_ASSERT_NULL(human.overlays_standing[UNDER_ARMOR_LAYER], "Untucking must remove the previous tucked overlay.")
	panels = human.overlays_standing[CLOAK_LAYER]
	for(var/mutable_appearance/panel as anything in panels)
		TEST_ASSERT_EQUAL(panel.layer, -CLOAK_LAYER, "Untucking must restore front-panel priority.")

/datum/unit_test/horse_taur_markings/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	human.Taurize(/obj/item/bodypart/taur/equine)
	var/obj/item/bodypart/taur/equine/horse = human.get_taur_tail()
	var/list/without_markings = horse.get_limb_icon(FALSE)
	var/plain_key = horse.generate_limb_cache_key(FALSE, FALSE)
	var/list/markings = list(BODY_ZONE_L_LEG = list("Horse Socks (HorseTaur)" = "FFF0D4", "Horse Hooves (HorseTaur)" = "282630"))
	apply_markings_to_body_parts(markings, human)
	var/list/with_markings = horse.get_limb_icon(FALSE)
	TEST_ASSERT_EQUAL(length(with_markings), length(without_markings) + 2, "Both optional markings must render on the wide taur body.")
	TEST_ASSERT_NOTEQUAL(plain_key, horse.generate_limb_cache_key(FALSE, FALSE), "Changing markings must invalidate cached body appearances.")
	apply_markings_to_body_parts(list(), human)
	var/list/removed = horse.get_limb_icon(FALSE)
	TEST_ASSERT_EQUAL(length(removed), length(without_markings), "Removing optional markings must restore the unmarked body.")
	human.Taurize(/obj/item/bodypart/taur/horse)
	var/obj/item/bodypart/taur/saiga = human.get_taur_tail()
	TEST_ASSERT_EQUAL(saiga.taur_icon_state, "saiga_s", "Legacy horse paths must still use Saiga Body artwork.")

/datum/unit_test/horse_taur_cloth_layers/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	human.Taurize(/obj/item/bodypart/taur/equine)
	var/obj/item/bodypart/taur/equine/horse = human.get_taur_tail()
	var/obj/item/clothing/cloak/tabard/tabard = allocate(/obj/item/clothing/cloak/tabard)
	tabard.forceMove(human)
	human.cloak = tabard
	tabard.alternate_worn_layer = UNDER_ARMOR_LAYER
	human.update_inv_cloak_real()
	var/list/tucked = human.overlays_standing[UNDER_ARMOR_LAYER]
	TEST_ASSERT(islist(tucked) && length(tucked) == 2, "Tucking a tabard must retain both humanoid and taur cloth overlays.")
	var/mutable_appearance/wide_cloth = tucked[2]
	TEST_ASSERT_EQUAL(wide_cloth.layer, -(SHIRT_LAYER + 0.1), "Tucked taur cloth must draw beneath padding and armor.")
	var/obj/item/caparison/caparison = allocate(/obj/item/caparison)
	TEST_ASSERT_EQUAL(horse.get_caparison_state(caparison), "caparison", "Plain caparisons must select fitted horse artwork.")
	caparison.forceMove(human)
	horse.applied_caparison = caparison
	caparison.taur_wearer = horse
	var/list/with_cloth = horse.get_limb_icon(FALSE)
	caparison.remove_from_taur()
	var/list/without_cloth = horse.get_limb_icon(FALSE)
	TEST_ASSERT_EQUAL(length(with_cloth), length(without_cloth) + 1, "Applied caparisons must add one independently removable overlay.")
	TEST_ASSERT_NULL(horse.applied_caparison, "Removing cloth must clear its body reference.")
	TEST_ASSERT_NULL(caparison.taur_wearer, "Removing cloth must clear its item reference.")
	TEST_ASSERT_EQUAL(get_turf(caparison), get_turf(human), "Removed cloth must return to the floor.")
	tabard.MiddleClick(human)
	TEST_ASSERT(tabard.wear_over_taur, "Tabard MMB must advance from tucked cloth to the body drape.")
	tabard.MiddleClick(human)
	TEST_ASSERT(!tabard.wear_over_taur, "The next tabard MMB must restore normal wear.")
	TEST_ASSERT_EQUAL(tabard.alternate_worn_layer, initial(tabard.alternate_worn_layer), "Normal tabard wear must retain its original layer.")
	tabard.MiddleClick(human)
	TEST_ASSERT_EQUAL(tabard.alternate_worn_layer, UNDER_ARMOR_LAYER, "The next tabard MMB must tuck under armor again.")

/datum/unit_test/horse_taur_underwear/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	var/obj/item/bodypart/chest = human.get_bodypart(BODY_ZONE_CHEST)
	var/datum/sprite_accessory/underwear/briefs/accessory = SPRITE_ACCESSORY(/datum/sprite_accessory/underwear/briefs)
	var/list/normal = accessory.get_appearance(null, chest, "#FF00FF")
	TEST_ASSERT_EQUAL(length(normal), 1, "Humanoid underwear must retain its normal overlay.")
	human.Taurize(/obj/item/bodypart/taur/equine)
	var/list/taur = accessory.get_appearance(null, chest, "#FF00FF")
	TEST_ASSERT_EQUAL(length(taur), 2, "Taur underwear needs separate north and other-direction overlays.")
	var/mutable_appearance/front = taur[1]
	var/mutable_appearance/back = taur[2]
	TEST_ASSERT_EQUAL(front.layer, -BODY_LAYER, "South/east/west underwear must retain its original layer.")
	TEST_ASSERT_EQUAL(back.layer, -(BODYPARTS_LAYER + 0.1), "North underwear must be behind the taur body.")
	var/mutable_appearance/original = normal[1]
	for(var/direction in list(SOUTH, NORTH, EAST, WEST))
		var/icon/front_icon = icon(front.icon, "", direction)
		var/icon/back_icon = icon(back.icon, "", direction)
		var/icon/expected = icon(original.icon, original.icon_state, direction)
		for(var/x in 1 to 32)
			for(var/y in 1 to 32)
				TEST_ASSERT_EQUAL(front_icon.GetPixel(x, y), direction == NORTH ? null : expected.GetPixel(x, y), "Front artwork must exclude only north.")
				TEST_ASSERT_EQUAL(back_icon.GetPixel(x, y), direction == NORTH ? expected.GetPixel(x, y) : null, "Back artwork must contain only north.")

	human.Taurize(/obj/item/bodypart/taur/horse)
	var/list/saiga_underwear = accessory.get_appearance(null, chest, "#FF00FF")
	TEST_ASSERT_EQUAL(length(saiga_underwear), 1, "Other taur bodies must retain their original underwear rendering.")

/datum/unit_test/horse_taur_testicles/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	human.underwear = null
	human.Taurize(/obj/item/bodypart/taur/equine)
	var/obj/item/organ/penis/penis = allocate(/obj/item/organ/penis/knotted)
	penis.Insert(human)
	penis.set_accessory_type(/datum/sprite_accessory/penis/knotted)
	penis.penis_taur_mode = TRUE
	penis.sheath_type = SHEATH_TYPE_NONE
	var/obj/item/organ/testicles/testes = allocate(/obj/item/organ/testicles)
	testes.Insert(human)
	testes.set_accessory_type(/datum/sprite_accessory/testicles/pair, "#FF0000")
	for(var/exposed in list(FALSE, TRUE))
		human.sexcon.bottom_exposed = exposed
		// Exercise the full organ pipeline and the later modular adjustment override.
		var/list/appearances = testes.get_bodypart_overlay(human.get_bodypart(BODY_ZONE_CHEST))
		TEST_ASSERT_EQUAL(length(appearances), 2, "The active modular renderer must retain separate north and other-direction overlays.")
		var/mutable_appearance/front = appearances[1]
		var/mutable_appearance/rear = appearances[2]
		TEST_ASSERT_EQUAL(front.layer, -BODY_FRONT_LAYER, "Other directions must keep the original front layer.")
		TEST_ASSERT_EQUAL(rear.layer, -(BODY_ADJ_LAYER + 0.1), "North must remain below the tail after exposure and device layer adjustments.")
		var/icon/front_north = icon(front.icon, "", NORTH)
		for(var/x in 1 to 64)
			for(var/y in 1 to 32)
				TEST_ASSERT_NULL(front_north.GetPixel(x, y), "The front overlay must not leak north-facing anatomy above the tail.")

/datum/unit_test/horse_taur_vagina/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	human.underwear = null
	var/obj/item/organ/vagina/vagina = allocate(/obj/item/organ/vagina)
	vagina.Insert(human)
	vagina.set_accessory_type(/datum/sprite_accessory/vagina/human, "#FF0000")
	var/obj/item/bodypart/chest = human.get_bodypart(BODY_ZONE_CHEST)
	var/list/humanoid = vagina.get_bodypart_overlay(chest)
	TEST_ASSERT_EQUAL(length(humanoid), 1, "Humanoid vagina artwork must retain its normal overlay.")
	human.Taurize(/obj/item/bodypart/taur/equine)
	for(var/exposed in list(FALSE, TRUE))
		human.sexcon.bottom_exposed = exposed
		var/list/appearances = vagina.get_bodypart_overlay(chest)
		TEST_ASSERT_EQUAL(length(appearances), 2, "Horse vagina artwork needs separate north and other-direction layers.")
		var/mutable_appearance/front = appearances[1]
		var/mutable_appearance/rear = appearances[2]
		TEST_ASSERT_EQUAL(front.layer, -BODY_FRONT_LAYER, "Other directions must retain the original front layer.")
		TEST_ASSERT_EQUAL(rear.layer, -(BODY_ADJ_LAYER + 0.1), "North must sit below the tail after exposure handling.")
		var/icon/front_north = icon(front.icon, "", NORTH)
		for(var/x in 1 to 32)
			for(var/y in 1 to 32)
				TEST_ASSERT_NULL(front_north.GetPixel(x, y), "The front overlay must not show north-facing anatomy above the tail.")
	vagina.vagina_taur_enabled = FALSE
	TEST_ASSERT(!vagina.is_visible(), "Disabling taur vagina visuals must still hide the organ.")
	vagina.vagina_taur_enabled = TRUE
	human.Taurize(/obj/item/bodypart/taur/horse)
	var/list/saiga = vagina.get_bodypart_overlay(chest)
	TEST_ASSERT_EQUAL(length(saiga), 1, "Other taur bodies must retain their existing rendering.")

/datum/unit_test/horse_taur_footsteps/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	human.Taurize(/obj/item/bodypart/taur/equine)
	var/datum/component/footstep/footsteps = human.GetComponent(/datum/component/footstep)
	TEST_ASSERT_NOTNULL(footsteps, "Horse Body must retain the human footstep component.")
	var/obj/item/bodypart/taur/equine/horse = human.get_taur_tail()
	TEST_ASSERT_EQUAL(human.get_bodypart(BODY_ZONE_L_LEG), horse, "Left-leg lookups must resolve to the taur body.")
	TEST_ASSERT_EQUAL(human.get_bodypart(BODY_ZONE_R_LEG), horse, "Right-leg lookups must resolve to the taur body.")
	for(var/obj/item/bodypart/part as anything in human.bodyparts)
		TEST_ASSERT(!(part.body_zone in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)), "The taur must replace both humanoid leg bodyparts.")
	var/turf/open/floor = get_turf(human)
	var/old_footstep = floor.footstep
	floor.footstep = FOOTSTEP_FLOOR
	human.m_intent = MOVE_INTENT_WALK
	footsteps.steps = 1
	var/turf/open/prepared = footsteps.prepare_step()
	human.movement_type |= FLYING
	var/turf/open/flying_step = footsteps.prepare_step()
	human.movement_type &= ~FLYING
	human.Taurize(/obj/item/bodypart/taur/horse)
	footsteps.steps = 1
	var/turf/open/other_taur_step = footsteps.prepare_step()
	// Restore the shared floor before assertions, including when a check fails.
	floor.footstep = old_footstep
	TEST_ASSERT_EQUAL(prepared, floor, "A horse without humanoid legs must still prepare a hoofstep.")
	TEST_ASSERT_NULL(flying_step, "Flying horses must not make hoofsteps.")
	TEST_ASSERT_EQUAL(other_taur_step, floor, "Saiga leg lookups must retain their existing footstep eligibility.")

/datum/unit_test/horse_taur_armor_priority/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	human.Taurize(/obj/item/bodypart/taur/equine)
	var/obj/item/bodypart/taur/equine/horse = human.get_taur_tail()
	var/obj/item/clothing/suit/roguetown/armor/plate/full/armor = allocate(/obj/item/clothing/suit/roguetown/armor/plate/full)
	armor.forceMove(human)
	human.wear_armor = armor
	human.update_inv_armor_real()
	var/list/appearances = human.overlays_standing[ARMOR_LAYER]
	TEST_ASSERT_EQUAL(length(appearances), 4, "Horse armor must retain its humanoid, fitted barding, and two tasset overlays.")
	var/mutable_appearance/barding = appearances[2]
	TEST_ASSERT_EQUAL(barding.layer, -ARMOR_LAYER, "Horse barding must retain its existing clothing stack priority.")
	var/icon/mask = horse.get_north_clothing_mask(32, 32, 0, 0)
	var/icon/north = icon(mask, "", NORTH)
	TEST_ASSERT_NULL(north.GetPixel(16, 10), "The horse's rear silhouette must occlude clothing.")
	TEST_ASSERT_NOTNULL(north.GetPixel(16, 28), "The human upper chest must remain available for armor.")
	for(var/direction in list(SOUTH, EAST, WEST))
		var/icon/other = icon(mask, "", direction)
		TEST_ASSERT_NOTNULL(other.GetPixel(16, 10), "Other directions must retain their original clothing pixels.")
	// Exercise detail overlays as well as the root icon without modifying the cached source.
	var/icon/opaque_icon = icon('icons/blanks/32x32.dmi', "nothing")
	opaque_icon.Opaque(COLOR_WHITE)
	for(var/direction in list(NORTH, EAST, WEST))
		opaque_icon.Insert(icon(opaque_icon, "", SOUTH), "", direction)
	var/mutable_appearance/source = mutable_appearance(opaque_icon)
	source.overlays += mutable_appearance(opaque_icon)
	var/list/clothing = list(source)
	horse.occlude_north_clothing(clothing)
	var/mutable_appearance/clipped = clothing[1]
	var/mutable_appearance/detail = clipped.overlays[1]
	var/icon/clipped_north = icon(clipped.icon, "", NORTH)
	var/icon/detail_north = icon(detail.icon, "", NORTH)
	TEST_ASSERT_NULL(clipped_north.GetPixel(16, 10), "Humanoid armor must not show through the horse body.")
	TEST_ASSERT_NULL(detail_north.GetPixel(16, 10), "Armor details must not bypass the body's north occlusion.")
	var/icon/original_north = icon(source.icon, "", NORTH)
	TEST_ASSERT_NOTNULL(original_north.GetPixel(16, 10), "Clipping must not mutate the shared original icon.")
	human.Taurize(/obj/item/bodypart/taur/horse)
	human.update_inv_armor_real()
	var/list/saiga = human.overlays_standing[ARMOR_LAYER]
	TEST_ASSERT_EQUAL(length(saiga), 2, "Saiga armor must retain its humanoid and barding overlays without horse tassets.")
