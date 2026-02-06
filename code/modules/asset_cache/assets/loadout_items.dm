/datum/asset/spritesheet/loadout_items
	name = "loadout_items"

/datum/asset/spritesheet/loadout_items/create_spritesheets()
	for(var/datum/loadout_item/item as anything in GLOB.loadout_items)
		var/obj/item/I = item.path
		var/icon = I::icon
		var/icon_state = I::icon_state
		
		if(!icon || !icon_state)
			continue

		Insert("[sanitize_css_class_name("loadout_item_[REF(item)]")]", icon, icon_state)
