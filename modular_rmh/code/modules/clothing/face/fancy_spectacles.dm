/obj/item/clothing/mask/rogue/spectacles/fancy
	name = "精致眼镜"
	desc = "一副来自异地的纤巧薄片眼镜，做工比本地大多数货色都更精细。"
	icon = 'modular_rmh/icons/clothing/fancy_spectacles.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/onmob/fancy_spectacles.dmi'
	icon_state = "glasses"

/obj/item/clothing/mask/rogue/spectacles/fancy_dark
	name = "精致眼镜"
	desc = "一副来自异地的纤巧薄片眼镜，做工比本地大多数货色都更精细。"
	icon = 'modular_rmh/icons/clothing/fancy_spectacles.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/onmob/fancy_spectacles.dmi'
	icon_state = "glasses_dark"

//LOADOUT

/datum/loadout_item/fancy_spectacles
	name = "精致眼镜"
	path = /obj/item/clothing/mask/rogue/spectacles/fancy
	triumph_cost = 2

/datum/loadout_item/fancy_spectaclesd
	name = "精致眼镜（另一款）"
	path = /obj/item/clothing/mask/rogue/spectacles/fancy_dark
	triumph_cost = 2
