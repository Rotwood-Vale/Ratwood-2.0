
/obj/item/clothing/under/roguetown/skirt
	name = "skirt"
	desc = "Long, flowing, and modest."
	icon_state = "skirt"
	item_state = "skirt"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	sleevetype = "skirt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	alternate_worn_layer = (SHIRT_LAYER)
	salvage_amount = 1

/obj/item/clothing/under/roguetown/skirt/random
	name = "skirt"

/obj/item/clothing/under/roguetown/skirt/random/Initialize(mapload)
	color = pick("#6b5445", "#435436", "#704542", "#79763f", CLOTHING_BLUE)
	..()

/obj/item/clothing/under/roguetown/skirt/blue
	color = CLOTHING_BLUE

/obj/item/clothing/under/roguetown/skirt/green
	color = CLOTHING_GREEN

/obj/item/clothing/under/roguetown/skirt/red
	color = CLOTHING_RED

/obj/item/clothing/under/roguetown/skirt/brown
	color = CLOTHING_BROWN

/obj/item/clothing/under/roguetown/skirt/black
	color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/skirt/gambeson
	name = "gambesoned kilt"
	desc = "Long, flowing, and modest; and more importantly, quilted for protection."
	icon_state = "patkilt"
	item_state = "patkilt"
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_LEG_LEATHER
	blocksound = SOFTUNDERHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	body_parts_covered = GROIN|LEGS
	cold_protection = GROIN | LEG_RIGHT | LEG_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	color = "#ad977d"
	var/shiftable = TRUE
	var/shifted = FALSE

/obj/item/clothing/under/roguetown/skirt/gambeson/attack_right(mob/user)
	if(!shiftable)
		return
	if(shifted)
		if(alert(user, "Would you like to wear your gambesoned kilt normally? This restores the new greyscaled style.",, "Yes", "No") != "No")
			icon_state = "patkilt"
			color = "#976E6B"
			update_icon()
			shifted = FALSE
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_pants()
			return
	else
		if(alert(user, "Would you like to wear your gambesoned kilt traditionally? This restores the original coloration.",, "Yes", "No") != "No")
			icon_state = "patkiltold"
			color = null
			update_icon()
			shifted = TRUE
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_pants()
			return

/obj/item/clothing/under/roguetown/skirt/kilt
	name = "kilt"
	desc = "Long, flowing, and modest; a traditional kilt."
	icon_state = "patkilt"
	item_state = "patkilt"
	armor = ARMOR_CLOTHING
	max_integrity = ARMOR_INT_LEG_LEATHER - 50
	blocksound = SOFTUNDERHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	body_parts_covered = GROIN|LEGS
	cold_protection = GROIN | LEG_RIGHT | LEG_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	color = "#ad977d"
	shiftable = FALSE

/obj/item/clothing/under/roguetown/skirt/gambeson/light
	name = "light gambesoned kilt"
	desc = "Long, flowing, and modest; a light padding lines the undercarriage, providing milder protection and warmth."
	icon_state = "patkilt"
	item_state = "patkilt"
	armor = ARMOR_PADDED_BAD
	max_integrity = ARMOR_INT_LEG_LEATHER - 50
	shiftable = FALSE

/obj/item/clothing/under/roguetown/skirt/gambeson/heavy
	name = "padded gambesoned kilt"
	desc = "Long, flowing, and modest; thickly padded, yet surprisingly unfettered in terms of agility."
	icon_state = "patkilt"
	item_state = "patkilt"
	armor = ARMOR_PADDED_GOOD
	max_integrity = ARMOR_INT_LEG_HARDLEATHER
	color = "#976E6B"

/obj/item/clothing/under/roguetown/skirt/gambeson/heavy/attack_right(mob/user)
	if(!shiftable)
		return
	if(shifted)
		if(alert(user, "Would you like to wear your padded gambesoned kilt normally? This restores the new greyscaled style.",, "Yes", "No") != "No")
			icon_state = "patkilt"
			color = "#976E6B"
			update_icon()
			shifted = FALSE
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_pants()
			return
	else
		if(alert(user, "Would you like to wear your padded gambesoned kilt traditionally? This restores the original coloration.",, "Yes", "No") != "No")
			icon_state = "patkiltold"
			color = null
			update_icon()
			shifted = TRUE
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_pants()
			return
