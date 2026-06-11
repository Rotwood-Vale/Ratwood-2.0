/obj/item/storage/belt
	name = "腰带"
	desc = ""
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "utilitybelt"
	item_state = "utility"
	slot_flags = ITEM_SLOT_BELT
	attack_verb = list("抽打", "鞭笞", "教训")
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	var/content_overlays = FALSE //If this is true, the belt will gain overlays based on what it's holding

/obj/item/storage/belt/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]开始用[src]抽打[user.p_them()]自己！看起来[user.p_theyre()]是想自杀！"))
	return BRUTELOSS

/obj/item/storage/belt/update_icon()
	cut_overlays()
	if(content_overlays)
		for(var/obj/item/I in contents)
			var/mutable_appearance/M = I.get_belt_overlay()
			add_overlay(M)
	..()

/obj/item/storage/belt/Initialize(mapload)
	. = ..()
	update_icon()
