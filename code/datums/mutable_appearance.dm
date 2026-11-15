// Mutable appearances are an inbuilt byond datastructure. Read the documentation on them by hitting F1 in DM.
// Basically use them instead of images for overlays/underlays and when changing an object's appearance if you're doing so with any regularity.
// Unless you need the overlay/underlay to have a different direction than the base object. Then you have to use an image due to a bug.

// Mutable appearances are children of images, just so you know.

/mutable_appearance/New()
	..()
	plane = FLOAT_PLANE // No clue why this is 0 by default yet images are on FLOAT_PLANE
						// And yes this does have to be in the constructor, BYOND ignores it if you set it as a normal var

// Helper similar to image()
/proc/mutable_appearance(icon, icon_state = "", layer = FLOAT_LAYER, plane = FLOAT_PLANE, alpha = 255)
	var/mutable_appearance/MA = new()
	MA.icon = icon
	MA.icon_state = icon_state
	MA.layer = layer
	MA.plane = plane
	MA.alpha = alpha
	return MA

/// Split directional artwork so changing direction selects the proper layer without regenerating overlays.
/proc/set_north_appearance_layer(list/appearance_list, north_layer)
	var/list/north_appearances = list()
	for(var/mutable_appearance/appearance as anything in appearance_list)
		var/icon/other_directions = icon(appearance.icon, appearance.icon_state)
		var/icon/north_direction = icon(appearance.icon, appearance.icon_state)
		var/icon/blank = icon(appearance.icon, appearance.icon_state, NORTH)
		blank.Blend("#ffffff00", ICON_MULTIPLY)
		other_directions.Insert(blank, "", NORTH)
		for(var/direction in list(SOUTH, EAST, WEST))
			north_direction.Insert(blank, "", direction)
		var/mutable_appearance/north_appearance = new(appearance)
		north_appearance.icon = north_direction
		north_appearance.icon_state = ""
		north_appearance.layer = north_layer
		north_appearances += north_appearance
		appearance.icon = other_directions
		appearance.icon_state = ""
	appearance_list += north_appearances
