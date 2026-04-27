/// A bulk trade shipment purchased from the underbelly shop. Tear it open to unpack the goods.
/obj/item/underbelly_shipment
	name = "trade shipment"
	desc = "A huge wrapped bulk package. Someone spent real coin getting this here."
	icon = 'modular/Neu_Food/icons/cookware/ration.dmi'
	icon_state = "ration_large"
	w_class = WEIGHT_CLASS_HUGE
	/// Item type this shipment contains.
	var/content_type
	/// Display name for the contents, used in name and desc.
	var/content_name = "goods"
	/// Number of items sealed inside. Rolled on Initialize.
	var/sealed_amount = 0

/obj/item/underbelly_shipment/Initialize(mapload)
	. = ..()
	sealed_amount = rand(12, 24)
	name = "[content_name] shipment"
	desc = "A heavily wrapped bulk package of [content_name]. Tear it open to unpack [sealed_amount] [content_name]."

/obj/item/underbelly_shipment/examine(mob/user)
	. = ..()
	. += span_notice("Contains [sealed_amount] [content_name]. Activate it in-hand to break the seal.")

/obj/item/underbelly_shipment/attack_self(mob/user)
	user.visible_message(
		span_notice("[user] tears open [src], spilling the contents onto the ground."),
		span_notice("You tear open [src], unpacking [sealed_amount] [content_name].")
	)
	var/turf/T = get_turf(user)
	for(var/i = 1 to sealed_amount)
		new content_type(T)
	qdel(src)

/obj/item/underbelly_shipment/iron_ore
	content_type = /obj/item/rogueore/iron
	content_name = "iron ore"

/obj/item/underbelly_shipment/coal
	content_type = /obj/item/rogueore/coal
	content_name = "coal"

/obj/item/underbelly_shipment/copper_ore
	content_type = /obj/item/rogueore/copper
	content_name = "copper ore"

/obj/item/underbelly_shipment/tin_ore
	content_type = /obj/item/rogueore/tin
	content_name = "tin ore"

/obj/item/underbelly_shipment/stone
	content_type = /obj/item/natural/stone
	content_name = "stone"

/obj/item/underbelly_shipment/wood
	content_type = /obj/item/grown/log/tree/small
	content_name = "short logs"

/obj/item/underbelly_shipment/flour
	content_type = /obj/item/reagent_containers/powder/flour
	content_name = "flour"

/obj/item/underbelly_shipment/grain
	content_type = /obj/item/reagent_containers/food/snacks/grown/wheat
	content_name = "grain"

/obj/item/underbelly_shipment/seeds
	content_type = /obj/item/seeds/wheat
	content_name = "wheat seeds"

/obj/item/underbelly_shipment/gabagool
	content_type = /obj/item/reagent_containers/food/snacks/rogue/meat/gabagool
	content_name = "gabagool"

/obj/item/underbelly_shipment/gabagool/Initialize(mapload)
	. = ..()  
	sealed_amount = rand(2, 5)
	name = "[content_name] shipment"
	desc = "A very carefully wrapped parcel of [content_name]. Contains [sealed_amount]. Handle with care."
