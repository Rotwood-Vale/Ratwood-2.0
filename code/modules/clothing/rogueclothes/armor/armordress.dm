


//LIGHT ARMOR//

/obj/item/clothing/suit/roguetown/armor/armordress
	slot_flags = ITEM_SLOT_ARMOR
	name = "衬垫连衣裙"
	desc = "这件连衣裙内衬了皮革来增强防护。弩箭和箭矢还是会轻易穿透。"
	body_parts_covered = COVERAGE_FULL
	icon_state = "armordress"
	armor = ARMOR_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT)
	blocksound = SOFTHIT
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor_class = ARMOR_CLASS_LIGHT
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/suit/roguetown/armor/armordress/alt
	icon_state = "armordressalt"

//................ Winter Dress ............... //
/obj/item/clothing/suit/roguetown/armor/armordress/winterdress
	name = "冬季连衣裙"
	icon = 'icons/roguetown/clothing/shirts_royalty.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_royalty.dmi'
	desc = "厚实、衬垫充足且舒适的连衣裙，深受冬季贵族欢迎。"
	body_parts_covered = COVERAGE_FULL
	icon_state = "winterdress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_royalty.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2

/obj/item/clothing/suit/roguetown/armor/armordress/winterdress/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch //For the duchess nobody else
	desc = "一件厚实、衬垫充足且舒适的连衣裙，离开城堡时既保暖又安全。"
	armor = ARMOR_PADDED_GOOD

/obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/armor/armordress/winterdress/monarch/Destroy()
	GLOB.lordcolor -= src
	return ..()
