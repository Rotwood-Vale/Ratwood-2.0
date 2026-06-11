//Handles donator modkit code - basically akin to old Citadel/F13 modkit donator system.
//Tl;dr - Click the assigned modkit to the object type's parent, it'll change it into the child. Modkits, aka enchanting kits, are what you get.
/obj/item/enchantingkit
	name = "塑形灵药"
	desc = "一个装有特殊塑形粉尘的小容器，最适合用来制成特定物品。"
	icon = 'modular_azurepeak/icons/obj/items/donor_objects.dmi'	//We default to here just to avoid tons of uneeded sprites.
	icon_state = "enchanting_kit"
	w_class = WEIGHT_CLASS_SMALL	//So can fit in a bag, we don't need these large. They're just used to apply to items.
	var/list/target_items = list()
	var/result_item = null

/obj/item/enchantingkit/pre_attack(obj/item/I, mob/user)
	if(is_type_in_list(I, target_items))
		var/obj/item/R = new result_item(get_turf(user))
		to_chat(user, span_notice("你将[src]施用于[I]，用其中的附魔粉尘与工具把它变成了[R]。"))
		R.name += " <font size = 1>([I.name])</font>"
		remove_item_from_storage(I)
		qdel(I)
		user.put_in_hands(R)
		qdel(src)
		return TRUE
	else
		return ..()

/////////////////////////////
// ! Player / Donor Kits ! //
/////////////////////////////

//Plexiant - Custom rapier type
/obj/item/enchantingkit/plexiant
	name = "“阿利塞奥刺剑”塑形灵药"
	target_items = list(/obj/item/rogueweapon/sword/rapier)		//Takes any subpated rapier and turns it into unique one.
	result_item = /obj/item/rogueweapon/sword/rapier/aliseo

//Ryebread - Custom estoc type
/obj/item/enchantingkit/ryebread
	name = "“沃特崔格”塑形灵药"
	target_items = list(/obj/item/rogueweapon/estoc)		//Takes any subpated rapier and turns it into unique one.
	result_item = /obj/item/rogueweapon/estoc/worttrager

//Srusu - Custom dress type
/obj/item/enchantingkit/srusu
	name = "“翡翠长裙”塑形灵药"
	target_items = list(/obj/item/clothing/suit/roguetown/shirt/dress)	//Literally any type of dress
	result_item = /obj/item/clothing/suit/roguetown/shirt/dress/emerald

//Strudle - Custom leather vest type
/obj/item/enchantingkit/strudle
	name = "“格伦泽尔霍夫特法师背心”塑形灵药"
	target_items = list(/obj/item/clothing/suit/roguetown/shirt/robe)
	result_item = /obj/item/clothing/suit/roguetown/shirt/robe/sofiavest

//Bat - Custom harp type
/obj/item/enchantingkit/bat
	name = "“手工竖琴”塑形灵药"
	target_items = list(/obj/item/rogue/instrument/harp)
	result_item = /obj/item/rogue/instrument/harp/handcarved

//Rebel - Custom visored sallet type
/obj/item/enchantingkit/rebel
	name = "“镀金面罩盔”塑形灵药"
	target_items = list(/obj/item/clothing/head/roguetown/helmet/sallet/visored)
	result_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored/gilded

//Bigfoot - Custom knight helm type
/obj/item/enchantingkit/bigfoot
	name = "“镀金骑士盔”塑形灵药"
	target_items = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight)
	result_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/gilded

//Bigfoot - Custom great axe type
/obj/item/enchantingkit/bigfoot_axe
	name = "“镀金巨斧”塑形灵药"
	target_items = list(/obj/item/rogueweapon/greataxe/steel)
	result_item = /obj/item/rogueweapon/greataxe/steel/gilded

//Zydras donator item - bathmatron padded dress
/obj/item/enchantingkit/zydras
	name = "“黑金丝裙”塑形灵药"
	target_items = list(/obj/item/clothing/suit/roguetown/shirt/dress/silkydress)
	result_item = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress/zydrasdress

//Eiren - Zweihander and sabres
/obj/item/enchantingkit/eiren
	name = "“悔恨”塑形灵药"
	target_items = list(/obj/item/rogueweapon/greatsword/zwei)		//now only takes the zwei and nothing else
	result_item = /obj/item/rogueweapon/greatsword/zwei/eiren

/obj/item/enchantingkit/eirensabre
	name = "“露奈”塑形灵药"
	target_items = list(/obj/item/rogueweapon/sword/sabre)
	result_item = /obj/item/rogueweapon/sword/sabre/eiren

/obj/item/enchantingkit/eirensabre2
	name = "“灰烬”塑形灵药"
	target_items = list(/obj/item/rogueweapon/sword/sabre)
	result_item = /obj/item/rogueweapon/sword/sabre/eiren/small

//pretzel - custom steel greatsword. PSYDON LYVES. PSYDON ENDVRES.
/obj/item/enchantingkit/waff
	name = "“哀泣者车床”塑形灵药"
	target_items = list(/obj/item/rogueweapon/greatsword)		// i, uh. i really do promise i'm only gonna use it on steel greatswords.
	result_item = /obj/item/rogueweapon/greatsword/weeperslathe

//inverserun claymore
/obj/item/enchantingkit/inverserun
	name = "“祈愿荆棘”塑形灵药"
	target_items = list(/obj/item/rogueweapon/greatsword/zwei)
	result_item = /obj/item/rogueweapon/greatsword/zwei/inverserun

//Zoe - Tytos Blackwood cloak
/obj/item/enchantingkit/zoe
	name = "“冥下少女裹尸布”塑形灵药"
	target_items = list(/obj/item/clothing/cloak/darkcloak/bear)
	result_item = /obj/item/clothing/cloak/raincloak/feather_cloak
