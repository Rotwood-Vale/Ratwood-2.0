/obj/item/storage/belt/rogue/surgery_bag
	name = "surgeon's bag"
	desc = "Made to hold everything a people-butcher will need. Contains a list of implements... what even IS a Sisrat?"
	icon = 'icons/clothing/storage.dmi'
	mob_overlay_icon = null
	icon_state = "surgery_bag"
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	content_overlays = FALSE
	bloody_icon_state = "bodyblood"
	sewrepair = TRUE
	component_type = /datum/component/storage/concrete/roguetown/surgery_bag
	populate_contents = list(
		/obj/item/weapon/surgery/scalpel,
		/obj/item/weapon/surgery/saw,
		/obj/item/weapon/surgery/hemostat/first,
		/obj/item/weapon/surgery/hemostat/second, //Different types for multiple surgery sites. 
		/obj/item/weapon/surgery/hemostat/third,
		/obj/item/weapon/surgery/retractor,
		/obj/item/weapon/surgery/retractor,
		/obj/item/weapon/surgery/bonesetter,
		/obj/item/weapon/surgery/cautery,
		/obj/item/weapon/surgery/hammer,
		/obj/item/natural/bundle/cloth/bandage/full,
		/obj/item/needle
	)

/obj/item/storage/belt/rogue/surgery_bag/full/physician
	populate_contents = list(
	/obj/item/weapon/surgery/scalpel,
	/obj/item/weapon/surgery/saw,
	/obj/item/weapon/surgery/hemostat/first,  //Different types for multiple surgery sites. 
	/obj/item/weapon/surgery/hemostat/second,
	/obj/item/weapon/surgery/hemostat/third,
	/obj/item/weapon/surgery/retractor,
	/obj/item/weapon/surgery/retractor,
	/obj/item/weapon/surgery/bonesetter,
	/obj/item/weapon/surgery/cautery,
	/obj/item/natural/bundle/cloth/bandage/full,
	/obj/item/weapon/surgery/hammer,
	/obj/item/needle/pestra //Gets the special needle!
	)

/obj/item/storage/belt/rogue/surgery_bag/full/improv
	populate_contents = list(
		/obj/item/weapon/surgery/saw/improv,
		/obj/item/weapon/surgery/hemostat/improv,
		/obj/item/weapon/surgery/retractor/improv,
		/obj/item/natural/bundle/cloth/bandage/full,
		/obj/item/needle/aalloy
	)

/obj/item/storage/belt/rogue/surgery_bag/empty
	populate_contents = list(
	)

/obj/item/storage/belt/rogue/pouch/medicine
	populate_contents = list(
	/obj/item/needle,
	/obj/item/natural/bundle/cloth/bandage/full,
	/obj/item/reagent_containers/glass/bottle/alchemical/healthpot
	)

/obj/item/storage/belt/rogue/surgery_bag/empty
	populate_contents = list(
	)
