/obj/item/storage/fancy/shhig
	name = "Shhig Brand Zigs"
	desc = "Shhig's Brand Zigs; known for their smooth draw and complex flavour profile. Go on... give them a try. Your life expectancy isn't very high anyway."
	icon = 'icons/roguetown/items/smokebox.dmi'
	icon_state = "smokebox"
	item_state = "smokebox"
	icon_type = "smoke"
	dropshrink = 0.7

	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = null
	component_type = /datum/component/storage/concrete/grid/zigbox
	populate_contents = list(
		/obj/item/clothing/mask/cigarette/rollie/shhig,
		/obj/item/clothing/mask/cigarette/rollie/shhig,
		/obj/item/clothing/mask/cigarette/rollie/shhig,
		/obj/item/clothing/mask/cigarette/rollie/shhig,
		/obj/item/clothing/mask/cigarette/rollie/shhig,
		/obj/item/clothing/mask/cigarette/rollie/shhig,
	)



/obj/item/storage/fancy/shhig/attack_self(mob_user)
	return

/obj/item/clothing/mask/cigarette/rollie/shhig
	name = "shhig zig"
	desc = "This zig has a little indentation of a snake imprinted on to it."
	list_reagents = list(/datum/reagent/drug/nicotine = 30, /datum/reagent/consumable/shhig = 10)

/datum/reagent/consumable/shhig
	name = "Shhig Special Formula"
	color = "#d3a308"
	taste_description = "complex sharpness and notes of honey and venom"
