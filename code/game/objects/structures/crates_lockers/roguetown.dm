/obj/structure/closet/crate/chest
	name = "宝箱"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "chest3s"
	base_icon_state = "chest3s"
	drag_slowdown = 2
	open_sound = 'sound/misc/chestopen.ogg'
	close_sound = 'sound/misc/chestclose.ogg'
	keylock = TRUE
	locked = FALSE
	sellprice = 1
	max_integrity = 200
	blade_dulling = DULLING_BASHCHOP
	mob_storage_capacity = 2
	allow_dense = FALSE

/obj/structure/closet/crate/chest/gold
	icon_state = "chest3"
	base_icon_state = "chest3"

/obj/structure/closet/crate/chest/inqreliquary
	name = "奥塔凡圣匣"
	desc = "一只令人不安的红色匣柜，锁孔结构异常繁复，似乎只适配某一把特定钥匙。可得慎选。"
	icon_state = "chestweird1"
	base_icon_state = "chestweird1"

/obj/structure/closet/crate/chest/inqcrate
	name = "奥塔凡宝箱"
	desc = "一只令人不安的红色宝箱，镶着被黑染浸过的银饰。"
	icon_state = "chestweird2"
	base_icon_state = "chestweird2"	

//obj/structure/closet/crate/chest/Initialize(mapload)
//	. = ..()
//	base_icon_state = "chestweird2"
//	update_icon()

/obj/structure/closet/crate/chest/merchant
	lockid = "shop"
	locked = TRUE
	masterkey = TRUE

/obj/structure/closet/crate/chest/lootbox/PopulateContents()
	var/list/loot = list(/obj/item/cooking/pan=33,
		/obj/item/bomb=6,
		/obj/item/rogueweapon/huntingknife/idagger=33,
		/obj/item/clothing/suit/roguetown/armor/gambeson=33,
		/obj/item/clothing/suit/roguetown/armor/leather=33,
		/obj/item/roguestatue/gold/loot=1,
		/obj/item/ingot/iron=22,
		/obj/item/rogueweapon/huntingknife/cleaver=22,
		/obj/item/rogueweapon/mace=22,
		/obj/item/clothing/cloak/raincloak/mortus=22,
		/obj/item/reagent_containers/food/snacks/butter=22,
		/obj/item/clothing/mask/cigarette/pipe=10,
		/obj/item/clothing/mask/cigarette/pipe/westman=10,
		/obj/item/storage/backpack/rogue/satchel=33,
		/obj/item/storage/roguebag=33,
		/obj/item/roguegem/ruby=1,
		/obj/item/roguegem/blue=2,
		/obj/item/roguegem/violet=4,
		/obj/item/roguegem/green=6,
		/obj/item/roguegem/yellow=10,
		/obj/item/roguecoin/silver/pile=4,
		/obj/item/rogueweapon/pick=23,
		/obj/item/riddleofsteel=2,
		/obj/item/clothing/neck/roguetown/talkstone=2)
	if(prob(70))
		var/I = pickweight(loot)
		new I(src)

/obj/structure/closet/crate/roguecloset
	name = "柜橱"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	base_icon_state = "closet"
	icon_state = "closet"
	drag_slowdown = 4
	horizontal = FALSE
	allow_dense = FALSE
	open_sound = 'sound/foley/doors/creak.ogg'
	close_sound = 'sound/foley/latch.ogg'
	max_integrity = 200
	blade_dulling = DULLING_BASHCHOP
	dense_when_open = FALSE
	mob_storage_capacity = 2

/obj/structure/closet/crate/roguecloset/inn/south
	base_icon_state = "closet3"
	icon_state = "closet3"
	dir = SOUTH
	pixel_y = 16

/obj/structure/closet/crate/roguecloset/inn
	base_icon_state = "closet3"
	icon_state = "closet3"

/obj/structure/closet/crate/roguecloset/inn/chest
	base_icon_state = "woodchest"
	icon_state = "woodchest"

/obj/structure/closet/crate/roguecloset/dark
	base_icon_state = "closetdark"
	icon_state = "closetdark"

/obj/structure/closet/crate/roguecloset/lord
	keylock = TRUE
	lockid = "lord"
	locked = TRUE
	masterkey = TRUE
	base_icon_state = "closetlord"
	icon_state = "closetlord"

/obj/structure/closet/crate/drawer
	name = "抽屉柜"
	desc = "一个木制抽屉柜。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "drawer5"
	base_icon_state = "drawer5"
	drag_slowdown = 2
	open_sound = 'sound/misc/chestopen.ogg'
	close_sound = 'sound/misc/chestclose.ogg'
	keylock = FALSE
	locked = FALSE
	sellprice = 1
	max_integrity = 50
	blade_dulling = DULLING_BASHCHOP
	mob_storage_capacity = 1
	allow_dense = FALSE

/obj/structure/closet/crate/drawer/inn
	name = "抽屉柜"
	desc = "一个木制抽屉柜。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "drawer5"
	base_icon_state = "drawer5"
	dir = SOUTH
	pixel_y = 16

/obj/structure/closet/crate/drawer/drawer1 // five unique dresser sprites needing five different structures for five different crafting recipes
	name = "抽屉柜"
	desc = "一个木制抽屉柜。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "drawer1"
	base_icon_state = "drawer1"

/obj/structure/closet/crate/drawer/drawer2
	name = "抽屉柜"
	desc = "一个木制抽屉柜。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "drawer2"
	base_icon_state = "drawer2"

/obj/structure/closet/crate/drawer/drawer3
	name = "抽屉柜"
	desc = "一个木制抽屉柜。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "drawer3"
	base_icon_state = "drawer3"

/obj/structure/closet/crate/drawer/drawer4
	name = "抽屉柜"
	desc = "一个木制抽屉柜。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "drawer4"
	base_icon_state = "drawer4"

//Stonekeep port
/obj/structure/closet/crate/chest/crate
	name = "板条箱"
	base_icon_state = "woodchest"
	icon_state = "woodchest"

/obj/structure/closet/crate/chest/wicker
	name = "柳条篮"
	desc = "纤维编织而成的廉价储物箱。"
	base_icon_state = "wicker"
	icon_state = "wicker"
	open_sound = 'sound/items/book_open.ogg'
	open_sound = 'sound/items/book_close.ogg'
	close_sound = 'sound/items/book_close.ogg'

/obj/structure/closet/crate/chest/neu
	name = "结实橡木箱"
	icon_state = "chest_neu"
	base_icon_state = "chest_neu"

/obj/structure/closet/crate/chest/neu_iron
	name = "加固宝箱"
	icon_state = "chestiron_neu"
	base_icon_state = "chestiron_neu"

/obj/structure/closet/crate/chest/neu_fancy
	name = "华饰宝箱"
	icon_state = "chestfancy_neu"
	base_icon_state = "chestfancy_neu"

/obj/structure/closet/crate/chest/old_crate
	name = "旧木箱"
	base_icon_state = "woodchestalt"
	icon_state = "woodchestalt"

/obj/structure/closet/crate/drawer/random
	icon_state = "drawer1"
	base_icon_state = "drawer1"
	pixel_y = 8

/obj/structure/closet/crate/drawer/random/Initialize(mapload)
	. = ..()
	if(icon_state == "drawer1")
		base_icon_state = "drawer[rand(1,4)]"
		icon_state = "[base_icon_state]"
	else
		base_icon_state = "drawer1"
		pixel_y = 8
/**
 * Closet preset for the duke ().
 * When opened for the first time by the ruler mob - spawns the blacksteel armor set.
 * Done to prevent nobles taking regency just to loot blacksteel
*/
/obj/structure/closet/crate/roguecloset/lord/duke_preset
	desc = "表面覆满了奇异的符文，在黑暗中似乎会鼓动着某种能量。"
	/// Set to TRUE after it has spawned the gear.
	var/has_spawned_gear = FALSE

/obj/structure/closet/crate/roguecloset/lord/duke_preset/Initialize(mapload)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_TICKER_RULERMOB_SET, PROC_REF(spawn_blacksteel))

/obj/structure/closet/crate/roguecloset/lord/duke_preset/Destroy()
	UnregisterSignal(SSdcs, COMSIG_TICKER_RULERMOB_SET)
	return ..()

/obj/structure/closet/crate/roguecloset/lord/duke_preset/proc/spawn_blacksteel(mob/living/user)
	if(has_spawned_gear)
		return

	new /obj/item/rogueweapon/sword/long/judgement(get_turf(src))
	new /obj/item/clothing/wrists/roguetown/bracers(get_turf(src))
	new /obj/item/storage/belt/rogue/leather/steel/tasset(get_turf(src))
	new /obj/item/clothing/gloves/roguetown/blacksteel/modern/plategloves(get_turf(src))
	new /obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet(get_turf(src))
	new /obj/item/clothing/shoes/roguetown/boots/blacksteel/modern/plateboots(get_turf(src))
	new /obj/item/clothing/suit/roguetown/armor/plate/modern/blacksteel_full_plate(get_turf(src))
	new /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern(get_turf(src))
	has_spawned_gear = TRUE
	close()
