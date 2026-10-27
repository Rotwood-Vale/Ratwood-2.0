/obj/item/clothing/mask/rogue/spectacles/fancy
	name = "fancy spectacles"
	desc = "Delicate, thin-lensed spectacles of foreign make, their craft finer than most local wares."
	icon = 'modular_rmh/icons/clothing/fancy_spectacles.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/onmob/fancy_spectacles.dmi'
	icon_state = "glasses"

/obj/item/clothing/mask/rogue/spectacles/fancy_dark
	name = "fancy spectacles"
	desc = "Delicate, thin-lensed spectacles of foreign make, their craft finer than most local wares."
	icon = 'modular_rmh/icons/clothing/fancy_spectacles.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/onmob/fancy_spectacles.dmi'
	icon_state = "glasses_dark"

//LOADOUT

/datum/loadout_item/fancy_spectacles
	name = "fancy spectacles"
	path = /obj/item/clothing/mask/rogue/spectacles/fancy
	triumph_cost = 2

/datum/loadout_item/fancy_spectaclesd
	name = "fancy spectacles (alt)"
	path = /obj/item/clothing/mask/rogue/spectacles/fancy_dark
	triumph_cost = 2
