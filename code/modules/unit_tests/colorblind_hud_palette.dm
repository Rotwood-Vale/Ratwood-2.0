/datum/unit_test/colorblind_hud_palette

/datum/unit_test/colorblind_hud_palette/Run()
	var/datum/preferences/prefs = new

	TEST_ASSERT_EQUAL(prefs.hud_colorblind_palette, HUD_COLORBLIND_NONE, "New preferences should use the default HUD palette.")
	TEST_ASSERT_EQUAL(prefs.get_roguehud_icon(), 'icons/mob/roguehud.dmi', "Default palette should use the normal Rogue HUD.")
	TEST_ASSERT_EQUAL(prefs.get_rogueheat_icon(), 'icons/mob/rogueheat.dmi', "Default palette should use the normal Rogue heat HUD.")

	TEST_ASSERT(prefs.set_hud_colorblind_palette(HUD_COLORBLIND_DEUTERANOPIA), "Deuteranopia palette should be accepted.")
	TEST_ASSERT_EQUAL(prefs.get_roguehud_icon(), 'icons/mob/roguehud_deuten.dmi', "Deuteranopia palette should use the deuten Rogue HUD.")
	TEST_ASSERT_EQUAL(prefs.get_rogueheat_icon(), 'icons/mob/rogueheat_deuten.dmi', "Deuteranopia palette should use the deuten Rogue heat HUD.")

	TEST_ASSERT(prefs.set_hud_colorblind_palette(HUD_COLORBLIND_PROTANOPIA), "Protanopia palette should be accepted.")
	TEST_ASSERT_EQUAL(prefs.get_roguehud_icon(), 'icons/mob/roguehud_protan.dmi', "Protanopia palette should use the protan Rogue HUD.")
	TEST_ASSERT_EQUAL(prefs.get_rogueheat_icon(), 'icons/mob/rogueheat_protan.dmi', "Protanopia palette should use the protan Rogue heat HUD.")

	TEST_ASSERT(prefs.set_hud_colorblind_palette(HUD_COLORBLIND_TRITANOPIA), "Tritanopia palette should be accepted.")
	TEST_ASSERT_EQUAL(prefs.get_roguehud_icon(), 'icons/mob/roguehud_tritan.dmi', "Tritanopia palette should use the tritan Rogue HUD.")
	TEST_ASSERT_EQUAL(prefs.get_rogueheat_icon(), 'icons/mob/rogueheat_tritan.dmi', "Tritanopia palette should use the tritan Rogue heat HUD.")

	TEST_ASSERT(!prefs.set_hud_colorblind_palette("invalid"), "Unknown palettes should be rejected.")
	TEST_ASSERT_EQUAL(prefs.hud_colorblind_palette, HUD_COLORBLIND_TRITANOPIA, "Invalid palette attempts should keep the last valid palette.")

	var/atom/movable/screen/screen_object = new
	screen_object.icon = 'icons/mob/roguehud.dmi'
	screen_object.apply_colorblind_hud_palette(prefs)
	TEST_ASSERT_EQUAL(screen_object.icon, 'icons/mob/roguehud_tritan.dmi', "Rogue HUD screen objects should refresh to the active palette.")

	screen_object.icon = 'icons/mob/rogueheat.dmi'
	screen_object.apply_colorblind_hud_palette(prefs)
	TEST_ASSERT_EQUAL(screen_object.icon, 'icons/mob/rogueheat_tritan.dmi', "Rogue heat screen objects should refresh to the active palette.")

	qdel(screen_object)
