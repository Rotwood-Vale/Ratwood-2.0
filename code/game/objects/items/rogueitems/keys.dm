
/obj/item/roguekey
	name = "钥匙"
	desc = "一把毫不起眼的铁钥匙。"
	icon_state = "iron"
	icon = 'icons/roguetown/items/keys.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.75
	throwforce = 0
	lockhash = 0
	lockid = null
	var/hardmode_indestructible = FALSE
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH|ITEM_SLOT_NECK
	drop_sound = 'sound/items/gems (1).ogg'
	anvilrepair = /datum/skill/craft/blacksmithing
	resistance_flags = FIRE_PROOF
	experimental_inhand = FALSE

	grid_height = 32
	grid_width = 32

/obj/item/roguekey/Initialize(mapload)
	. = ..()
	if(lockid)
		if(GLOB.lockids[lockid])
			lockhash = GLOB.lockids[lockid]
		else
			lockhash = rand(100,999)
			while(lockhash in GLOB.lockhashes)
				lockhash = rand(100,999)
			GLOB.lockhashes += lockhash
			GLOB.lockids[lockid] = lockhash

/obj/item/lockpick
	name = "撬锁器"
	desc = "一小片锋利的金属，在没有钥匙时可用来开锁。"
	icon_state = "lockpick"
	icon = 'icons/roguetown/items/keys.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.75
	throwforce = 0
	max_integrity = 10
	picklvl = 1
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH|ITEM_SLOT_NECK
	destroy_sound = 'sound/items/pickbreak.ogg'
	resistance_flags = FIRE_PROOF
	associated_skill = /datum/skill/misc/lockpicking	//Doesn't do anything, for tracking purposes only
	always_destroy = TRUE

	grid_width = 32
	grid_height = 64

/obj/item/lockpick/goldpin
	name = "金发簪"
	desc = "常被富有的交际花与贵族用来固定发丝与衣物。"
	icon_state = "goldpin"
	item_state = "goldpin"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_HIP
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	experimental_onhip = FALSE
	possible_item_intents = list(/datum/intent/use, /datum/intent/stab)
	force = 10
	throwforce = 5
	max_integrity = null
	dropshrink = 0.7
	drop_sound = 'sound/items/gems (2).ogg'
	destroy_sound = 'sound/items/pickbreak.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	associated_skill = /datum/skill/misc/lockpicking
	var/material = "gold"

	grid_width = 32
	grid_height = 32

/obj/item/lockpick/goldpin/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_BELT_R)
		icon_state = "[material]pin_beltr"
		user.update_inv_belt()
	if(slot == SLOT_BELT_L)
		icon_state = "[material]pin_beltl"
		user.update_inv_belt()
	else
		icon_state = "[material]pin"
		user.update_icon()

/obj/item/lockpick/goldpin/silver
	name = "银发簪"
	desc = "常被富有的交际花与贵族用来固定发丝与衣物。这一支是银制的，颇为罕见。"
	icon_state = "silverpin"
	item_state = "silverpin"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	material = "silver"
	is_silver = TRUE

/obj/item/roguekey/lord
	name = "总钥匙"
	desc = "领主的钥匙。"
	icon_state = "bosskey"
	lockid = "lord"
	visual_replacement = /obj/item/roguekey/royal

/obj/item/roguekey/lord/Initialize(mapload)
	. = ..()
	if(SSroguemachine.key)
		qdel(src)
	else
		SSroguemachine.key = src

/obj/item/roguekey/lord/proc/anti_stall()
	src.visible_message(span_warning("谷地之钥碎成尘埃，灰烬幽幽飘向要塞的方向。"))
	SSroguemachine.key = null //Do not harddel.
	qdel(src) //Anti-stall

/obj/item/roguekey/lord/pre_attack(target, user, params)
	. = ..()
	if(istype(target, /obj/structure/closet))
		var/obj/structure/closet/C = target
		if(C.masterkey)
			lockhash = C.lockhash
	if(istype(target, /obj/structure/mineral_door))
		var/obj/structure/mineral_door/D = target
		if(D.masterkey)
			lockhash = D.lockhash

/obj/item/roguekey/royal
	name = "王室钥匙"
	desc = "通往王室寝宫的钥匙，连握在手里都显得高傲。"
	icon_state = "ekey"
	lockid = "royal"

/obj/item/roguekey/manor
	name = "庄园钥匙"
	desc = "这把钥匙能打开庄园的任意门。"
	icon_state = "mazekey"
	lockid = "manor"

/obj/item/roguekey/manor/guestroom/i
	name = "Manor Guestroom I Key"
	desc = "This key will open the manor first guestroom."
	icon_state = "mazekey"
	lockid = "guestroom1"

/obj/item/roguekey/manor/guestroom/ii
	name = "Manor Guestroom II Key"
	desc = "This key will open the manor second guestroom."
	icon_state = "mazekey"
	lockid = "guestroom2"

/obj/item/roguekey/manor/guestroom/iii
	name = "Manor Guestroom III Key"
	desc = "This key will open the manor third guestroom."
	icon_state = "mazekey"
	lockid = "guestroom3"

/obj/item/roguekey/manor/counsilroom/i
	name = "Counsillor's Room I Key"
	desc = "This key will open the manor first councilroom."
	icon_state = "mazekey"
	lockid = "counsil1"

/obj/item/roguekey/manor/counsilroom/ii
	name = "Counsillor's Room II Key"
	desc = "This key will open the manor second councilroom."
	icon_state = "mazekey"
	lockid = "counsil2"

/obj/item/roguekey/manor/counsilroom/iii
	name = "Counsillor's Room III Key"
	desc = "This key will open the manor third councilroom."
	icon_state = "mazekey"
	lockid = "counsil3"

/obj/item/roguekey/heir
	name = "继承人房间钥匙"
	desc = "一把令人垂涎的钥匙，属于此地继承人房门。"
	icon_state = "hornkey"
	lockid = "heir"

/obj/item/roguekey/garrison
	name = "城卫钥匙"
	desc = "这把钥匙属于城镇守卫。"
	icon_state = "spikekey"
	lockid = "garrison"

/obj/item/roguekey/sergeant
	name = "军士钥匙"
	desc = "这把钥匙属于武装卫兵的军士。"
	icon_state = "spikekey"
	lockid = "sergeant"

/obj/item/roguekey/warden
	name = "哨塔钥匙"
	desc = "这把钥匙属于看守。"
	icon_state = "spikekey"
	lockid = "warden"

/obj/item/roguekey/dungeon
	name = "地牢钥匙"
	desc = "这把钥匙应该能打开地牢里生锈的栅栏与门。"
	icon_state = "rustkey"
	lockid = "dungeon"

/obj/item/roguekey/vault
	name = "金库钥匙"
	desc = "这把钥匙能打开宏伟的金库。"
	icon_state = "cheesekey"
	lockid = "vault"

/obj/item/roguekey/sheriff
	name = "骑士队长钥匙"
	desc = "这把钥匙属于卫队长。"
	icon_state = "cheesekey"
	lockid = "sheriff"

/obj/item/roguekey/bailiff
	name = "执达吏钥匙"
	desc = "这把钥匙属于执达吏。"
	icon_state = "cheesekey"
	lockid = "sheriff"

/obj/item/roguekey/armory
	name = "军械库钥匙"
	desc = "这把钥匙能打开驻军军械库。"
	icon_state = "hornkey"
	lockid = "armory"

/obj/item/roguekey/knight
	name = "骑士钥匙"
	desc = "这是一把通往骑士居室的钥匙。"
	icon_state = "ekey"
	lockid = "knight"

/obj/item/roguekey/merchant
	name = "商人钥匙"
	desc = "一把商人的钥匙。"
	icon_state = "cheesekey"
	lockid = "merchant"

/obj/item/roguekey/shop
	name = "店铺钥匙"
	desc = "这把钥匙能开启并锁上店门。"
	icon_state = "ekey"
	lockid = "shop"

/obj/item/roguekey/townie // For use in round-start available houses in town. Do not use default lockID.
	name = "城镇住宅钥匙"
	desc = "某位镇民家中的钥匙，希望它没弄丢。"
	icon_state = "brownkey"
	lockid = "townie"

/obj/item/roguekey/bath // For use in round-start available bathhouse quarters. Do not use default lockID.
	name = "浴场宿舍钥匙"
	desc = "员工宿舍的钥匙，希望它没弄丢。"
	icon_state = "brownkey"
	lockid = "bath"

/obj/item/roguekey/tavern
	name = "酒馆钥匙"
	desc = "这把钥匙应当能开关酒馆里的任何门。"
	icon_state = "hornkey"
	lockid = "tavern"

/obj/item/roguekey/tavernkeep
	name = "旅店老板钥匙"
	desc = "这把钥匙能开关旅店老板的卧室门。"
	icon_state = "greenkey"
	lockid = "innkeep"

/obj/item/roguekey/crier
	name = "传令官钥匙"
	desc = "这把钥匙应当能开关传令官的办公室。"
	icon_state = "cheesekey"
	lockid = "crier"

/obj/item/roguekey/keeper
	name = "兽祠钥匙"
	desc = "这把钥匙应当能开关心兽的圣所。"
	icon_state = "beastkey"
	lockid = "keeper"

/obj/item/roguekey/keeper_inner
	name = "兽祠内门钥匙"
	desc = "这把钥匙应当能开关兽祠内部的铁门。"
	icon_state = "beastkey2"
	lockid = "keeper2"

/obj/item/roguekey/tavern/village
	lockid = "vtavern"

/obj/item/roguekey/roomi/village
	lockid = "vroomi"

/obj/item/roguekey/roomii/village
	lockid = "vroomii"

/obj/item/roguekey/roomiii/village
	lockid = "vroomiii"

/obj/item/roguekey/roomiv/village
	lockid = "vroomiv"

/obj/item/roguekey/roomv/village
	lockid = "vroomv"

/obj/item/roguekey/roomvi/village
	lockid = "vroomvi"

/obj/item/roguekey/roomi
	name = "I号客房钥匙"
	desc = "第一间客房的钥匙。"
	icon_state = "brownkey"
	lockid = "roomi"

/obj/item/roguekey/roomii
	name = "二号客房钥匙"
	desc = "第二间客房的钥匙。"
	icon_state = "brownkey"
	lockid = "roomii"

/obj/item/roguekey/roomiii
	name = "三号客房钥匙"
	desc = "第三间客房的钥匙。"
	icon_state = "brownkey"
	lockid = "roomiii"

/obj/item/roguekey/roomiv
	name = "四号客房钥匙"
	desc = "第四间客房的钥匙。"
	icon_state = "brownkey"
	lockid = "roomiv"

/obj/item/roguekey/roomv
	name = "五号客房钥匙"
	desc = "第五间客房的钥匙。"
	icon_state = "brownkey"
	lockid = "roomv"

/obj/item/roguekey/roomvi
	name = "六号客房钥匙"
	desc = "第六间客房的钥匙。"
	icon_state = "brownkey"
	lockid = "roomvi"

/obj/item/roguekey/roomvii
	name = "七号客房钥匙"
	desc = "第七间客房的钥匙。"
	icon_state = "brownkey"
	lockid = "roomvii"

/obj/item/roguekey/roomviii
	name = "八号客房钥匙"
	desc = "第八间客房的钥匙。"
	icon_state = "brownkey"
	lockid = "roomviii"

/obj/item/roguekey/roomix
	name = "九号客房钥匙"
	desc = "第九间客房的钥匙。"
	icon_state = "brownkey"
	lockid = "roomix"

/obj/item/roguekey/roomx
	name = "十号客房钥匙"
	desc = "第十间客房的钥匙。"
	icon_state = "brownkey"
	lockid = "roomx"

/obj/item/roguekey/roomhunt
	name = "HUNT套房钥匙"
	desc = "通往 HUNT 套房的钥匙，那是本地旅店的顶层客房。"
	icon_state = "brownkey"
	lockid = "roomhunt"

/obj/item/roguekey/fancyroomi
	name = "豪华客房一钥匙"
	desc = "第一间豪华客房的钥匙。"
	icon_state = "hornkey"
	lockid = "fancyi"

/obj/item/roguekey/fancyroomii
	name = "豪华客房二钥匙"
	desc = "第二间豪华客房的钥匙。"
	icon_state = "hornkey"
	lockid = "fancyii"

/obj/item/roguekey/fancyroomiii
	name = "豪华客房三钥匙"
	desc = "第三间豪华客房的钥匙。"
	icon_state = "hornkey"
	lockid = "fancyiii"

/obj/item/roguekey/fancyroomiv
	name = "豪华客房四钥匙"
	desc = "第四间豪华客房的钥匙。"
	icon_state = "hornkey"
	lockid = "fancyiv"

/obj/item/roguekey/fancyroomv
	name = "豪华客房五钥匙"
	desc = "第五间豪华客房的钥匙。"
	icon_state = "hornkey"
	lockid = "fancyv"

//vampire mansion//
/obj/item/roguekey/vampire
	name = "宅邸钥匙"
	desc = "通往吸血鬼领主宅邸的钥匙。"
	icon_state = "vampkey"
	lockid = "mansionvampire"

/obj/item/roguekey/vampire/guest

	name = "宅邸客房钥匙"
	icon_state = "brownkey"
	lockid = "mansionvampire_guest"

/obj/item/roguekey/vampire/maid
	name = "宅邸女仆钥匙"
	icon_state = "ekey"
	lockid = "mansionvampire_maid"
//

/obj/item/roguekey/crafterguild
	name = "工匠公会钥匙"
	desc = "通往工匠公会的钥匙。"
	icon_state = "brownkey"
	lockid = "crafterguild"

/obj/item/roguekey/craftermaster
	name = "工匠公会会长钥匙"
	desc = "工匠公会会长持有的钥匙。"
	icon_state = "hornkey"
	lockid = "craftermaster"

/obj/item/roguekey/walls
	name = "城墙钥匙"
	desc = "这是一把生锈的钥匙。"
	icon_state = "rustkey"
	lockid = "walls"

/obj/item/roguekey/bandit
	name = "旧钥匙"
	desc = "这是一把生锈的钥匙。"
	icon_state = "rustkey"
	lockid = "bandit"

/obj/item/roguekey/farm
	name = "农舍钥匙"
	desc = "这是一把生锈的钥匙，能打开农舍的门。"
	icon_state = "rustkey"
	lockid = "farm"

/obj/item/roguekey/butcher
	name = "屠户钥匙"
	desc = "这是一把生锈的钥匙，能打开屠户的门。"
	icon_state = "rustkey"
	lockid = "butcher"

/obj/item/roguekey/church
	name = "教堂钥匙"
	desc = "这把青铜钥匙应当能打开教堂中几乎所有的门。"
	icon_state = "brownkey"
	lockid = "church"

/obj/item/roguekey/priest
	name = "主教钥匙"
	desc = "这是教堂的总钥匙。"
	icon_state = "cheesekey"
	lockid = "priest"

/obj/item/roguekey/tower
	name = "高塔钥匙"
	desc = "这把钥匙应当能打开高塔中的一切门锁。"
	icon_state = "greenkey"
	lockid = "tower"

/obj/item/roguekey/mage
	name = "宫廷法师钥匙"
	desc = "这是宫廷法师的钥匙。它像在盯着你……"
	icon_state = "eyekey"
	lockid = "mage"

/obj/item/roguekey/graveyard
	name = "墓穴钥匙"
	desc = "这把生锈的钥匙属于守墓人。"
	icon_state = "rustkey"
	lockid = "graveyard"


/obj/item/roguekey/tailor
	name = "裁缝钥匙"
	desc = "这把钥匙能打开裁缝铺，钥身上缠着一缕细线。"
	icon_state = "brownkey"
	lockid = "tailor"

/obj/item/roguekey/nightman
	name = "浴场主事钥匙"
	desc = "这把华贵的钥匙能打开浴场主事的办公室，以及他的金库。"
	icon_state = "greenkey"
	lockid = "nightman"

/obj/item/roguekey/nightmaiden
	name = "浴场钥匙"
	desc = "这把华贵的钥匙能打开浴场内部的门。"
	icon_state = "bathkey"
	lockid = "nightmaiden"

/obj/item/roguekey/nightmaiden/rooms/i
	name = "baths room I key"
	desc = "This regal key opens the baths first room."
	icon_state = "bathkey"
	lockid = "lux1"

/obj/item/roguekey/nightmaiden/rooms/ii
	name = "baths room II key"
	desc = "This regal key opens the baths second room."
	icon_state = "bathkey"
	lockid = "lux2"

/obj/item/roguekey/nightmaiden/rooms/iii
	name = "baths room III key"
	desc = "This regal key opens the baths third room."
	icon_state = "bathkey"
	lockid = "lux3"

/obj/item/roguekey/nightmaiden/rooms/iv
	name = "baths room IV key"
	desc = "This regal key opens the baths fourth room."
	icon_state = "bathkey"
	lockid = "lux4"

/obj/item/roguekey/nightmaiden/rooms/v
	name = "baths room V key"
	desc = "This regal key opens the baths fifth room."
	icon_state = "bathkey"
	lockid = "lux5"

/obj/item/roguekey/nightmaiden/rooms/punish
	name = "baths punishment room  key"
	desc = "This regal key opens the baths punishment room."
	icon_state = "spikekey"
	lockid = "punishroom"

/obj/item/roguekey/nightmaiden/rooms/steam
	name = "baths steam room key"
	desc = "This regal key opens the baths steam room."
	icon_state = "bathkey"
	lockid = "steam"

/obj/item/roguekey/mercenary
	name = "佣兵钥匙"
	desc = "毕竟，佣兵总不至于把门直接踹开吧。"
	icon_state = "greenkey"
	lockid = "merc"

/obj/item/roguekey/mercenary/bedrooms
	name = "佣兵铺位一钥匙"
	desc = "毕竟，佣兵总不至于把门直接踹开吧。"
	icon_state = "greenkey"
	lockid = "merc_bunk_i"

/obj/item/roguekey/mercenary/bedrooms/ii
	name = "佣兵铺位二钥匙"
	lockid = "merc_bunk_ii"

/obj/item/roguekey/mercenary/bedrooms/iii
	name = "佣兵铺位三钥匙"
	lockid = "merc_bunk_iii"

/obj/item/roguekey/mercenary/bedrooms/iv
	name = "佣兵铺位四钥匙"
	lockid = "merc_bunk_iv"

/obj/item/roguekey/mercenary/bedrooms/v
	name = "佣兵铺位五钥匙"
	lockid = "merc_bunk_v"

/obj/item/roguekey/mercenary/bedrooms/vi
	name = "佣兵铺位六钥匙"
	lockid = "merc_bunk_vi"

/obj/item/roguekey/mercenary/bedrooms/vii
	name = "佣兵铺位七钥匙"
	lockid = "merc_bunk_vii"

/obj/item/roguekey/mercenary/bedrooms/viii
	name = "佣兵铺位八钥匙"
	lockid = "merc_bunk_viii"

/obj/item/roguekey/physician
	name = "城镇医师钥匙"
	desc = "这把钥匙带着草药香气，触感令人安心。"
	icon_state = "greenkey"
	lockid = "physician"

/obj/item/roguekey/courtphysician
	name = "宫廷医师钥匙"
	desc = "这把钥匙带着草药香气，触感令人安心。这一把尤显尊贵。"
	icon_state = "greenkey"
	lockid = "cphysician"

/obj/item/roguekey/puritan
	name = "清教徒钥匙"
	desc = "这是一把做工精巧的钥匙。" // i have no idea what is this key about
	icon_state = "mazekey"
	lockid = "puritan"

/obj/item/roguekey/inquisition
	name = "审判所钥匙"
	desc = "这把钥匙能打开通往教堂地下室的门，那里正是审判所驻留之处。"
	icon_state = "brownkey"
	lockid = "inquisition"

/obj/item/roguekey/inhumen
	name = "旧牢房钥匙"
	desc = "一把古旧生锈的钥匙，看起来像是某间牢房的。"
	icon_state = "rustkey"
	lockid = "inhumen"

/obj/item/roguekey/hand
	name = "右手大臣钥匙"
	desc = "这把华贵的钥匙属于大公的右手大臣。"
	icon_state = "cheesekey"
	lockid = "hand"

/obj/item/roguekey/steward
	name = "总管钥匙"
	desc = "这把钥匙属于宫廷那位贪婪的总管。"
	icon_state = "cheesekey"
	lockid = "steward"

/obj/item/roguekey/archive
	name = "档案室钥匙"
	desc = "这把钥匙看起来几乎没被使用过。"
	icon_state = "ekey"
	lockid = "archive"

/obj/item/roguekey/servant
	name = "仆役钥匙"
	desc = "公爵仆役所用的钥匙，希望它没弄丢……"
	icon_state = "brownkey"
	lockid = "servant"

//grenchensnacker
/obj/item/roguekey/porta
	name = "奇异钥匙"
	desc = "这把钥匙难道被某个法师锁匠施过魔法……？"//what is grenchensnacker.
	icon_state = "eyekey"
	lockid = "porta"

//Apartment and shop keys
/obj/item/roguekey/apartments
	name = ""
	icon_state = ""
	lockid = ""

/obj/item/roguekey/apartments/apartment1
	name = "公寓一钥匙"
	icon_state = "brownkey"
	lockid = "apartment1"

/obj/item/roguekey/apartments/apartment2
	name = "公寓二钥匙"
	icon_state = "brownkey"
	lockid = "apartment2"

/obj/item/roguekey/apartments/apartment3
	name = "公寓三钥匙"
	icon_state = "brownkey"
	lockid = "apartment3"

/obj/item/roguekey/apartments/apartment4
	name = "公寓四钥匙"
	icon_state = "brownkey"
	lockid = "apartment4"

/obj/item/roguekey/apartments/stall1
	name = "摊位一钥匙"
	icon_state = "brownkey"
	lockid = "stall1"

/obj/item/roguekey/apartments/stall2
	name = "摊位二钥匙"
	icon_state = "brownkey"
	lockid = "stall2"

/obj/item/roguekey/apartments/stall3
	name = "摊位三钥匙"
	icon_state = "brownkey"
	lockid = "stall3"

/obj/item/roguekey/apartments/stall4
	name = "摊位四钥匙"
	icon_state = "brownkey"
	lockid = "stall4"

/obj/item/roguekey/apartments/stable1
	name = "马厩一钥匙"
	icon_state = "brownkey"
	lockid = "stable1"

/obj/item/roguekey/apartments/stable2
	name = "马厩二钥匙"
	icon_state = "brownkey"
	lockid = "stable2"

/obj/item/roguekey/apartments/stablemaster_1
	name = "马夫马厩一钥匙"
	icon_state = "brownkey"
	lockid = "stable_master_1"

/obj/item/roguekey/apartments/stablemaster_2
	name = "马夫马厩二钥匙"
	icon_state = "brownkey"
	lockid = "stable_master_2"

/obj/item/roguekey/apartments/stablemaster_3
	name = "马夫马厩三钥匙"
	icon_state = "brownkey"
	lockid = "stable_master_3"

/obj/item/roguekey/apartments/stablemaster_4
	name = "马夫马厩四钥匙"
	icon_state = "brownkey"
	lockid = "stable_master_4"

/obj/item/roguekey/apartments/stablemaster_5
	name = "马夫马厩五钥匙"
	icon_state = "brownkey"
	lockid = "stable_master_5"

/obj/item/roguekey/apartments/stablemaster
	name = "马夫钥匙"
	icon_state = "brownkey"
	lockid = "stablemaster"

//bathhouse lockers

/obj/item/roguekey/bathlocker1
	name = "储物柜一钥匙"
	desc = "第一只储物柜的钥匙。"
	icon_state = "brownkey"
	lockid = "bathlocker1"

/obj/item/roguekey/bathlocker2
	name = "储物柜二钥匙"
	desc = "第二只储物柜的钥匙。"
	icon_state = "brownkey"
	lockid = "bathlocker2"

/obj/item/roguekey/bathlocker3
	name = "储物柜三钥匙"
	desc = "第三只储物柜的钥匙。"
	icon_state = "brownkey"
	lockid = "bathlocker3"

/obj/item/roguekey/bathlocker4
	name = "储物柜四钥匙"
	desc = "第四只储物柜的钥匙。"
	icon_state = "brownkey"
	lockid = "bathlocker4"

/obj/item/roguekey/bathlocker5
	name = "储物柜五钥匙"
	desc = "第五只储物柜的钥匙。"
	icon_state = "brownkey"
	lockid = "bathlocker5"

/obj/item/roguekey/bathlocker6
	name = "储物柜六钥匙"
	desc = "第六只储物柜的钥匙。"
	icon_state = "brownkey"
	lockid = "bathlocker6"

//BYOS keys
/obj/item/roguekey/tribal
	name = "部族钥匙"
	desc = "一把古老生锈的钥匙，虽然磨损严重，却保存得很好。"
	icon_state = "rustkey"
	lockid = "tribal"

/obj/item/roguekey/tribalchief
	name = "酋长钥匙"
	desc = "一把古老生锈的钥匙，虽然磨损严重，却保存得很好，比其他钥匙更华丽。"
	icon_state = "bosskey"
	lockid = "tribalchief"

//custom key
/obj/item/roguekey/custom
	name = "定制钥匙"
	desc = "一把由铁匠打造的定制钥匙。"
	icon_state = "brownkey"

/obj/item/roguekey/custom/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		var/input = (input(user, "你想给这把钥匙起什么名字？", "", "") as text)
		if(input)
			name = input + "钥匙"
			to_chat(user, span_notice("你将这把钥匙改名为[name]。"))

/obj/item/roguekey/lord/attack(mob/M, mob/user, def_zone) // lord's key opens any chastity device without checks and never breaks, because the lord is merciful like that. Petition the duke to have your cage unlocked unlucky squire! 
	var/handled = modular_chastity_attack(M, user, def_zone)
	if(!isnull(handled))
		return handled
	return ..()

/obj/item/lockpick/attack(mob/M, mob/user, def_zone) // handles lockpicking code for chastity devices. Yes, this is intentionally separate from the roguekey/chastity attack proc, because it has a chance to fail and break the pick, and lord's key can bypass the checks and never break.
	var/handled = modular_chastity_attack(M, user, def_zone)
	if(!isnull(handled))
		return handled
	return ..()

// Spectral lockpick from the Lesser Knock spell: attempt chastity picking first.
// If the target has no chastity device (or isn't human), fall through to ..() which triggers the
// touch_attack dispel logic — so the spell still cancels correctly on non-device targets.
/obj/item/melee/touch_attack/lesserknock/attack(mob/M, mob/user, def_zone)
	var/handled = modular_chastity_attack(M, user, def_zone)
	if(!isnull(handled))
		return handled
	return ..()


//custom key blank
/obj/item/customblank //i'd prefer not to make a seperate item for this honestly
	name = "空白定制钥匙"
	desc = "一把尚未刻出齿纹的钥匙，拥有无限可能……"
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "brownkey"
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.75
	lockhash = 0

/obj/item/customblank/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		var/input = input(user, "你想把这把钥匙的编号设成什么？", "", 0) as num
		input = max(0, input)
		to_chat(user, span_notice("你将钥匙编号设为了[input]。"))
		lockhash = 10000 + input //having custom lock ids start at 10000 leaves it outside the range that opens normal doors, so you can't make a key that randomly unlocks existing key ids like the church

/obj/item/customblank/attack_right(mob/user)
	if(istype(user.get_active_held_item(), /obj/item/roguekey))
		var/obj/item/roguekey/held = user.get_active_held_item()
		src.lockhash = held.lockhash
		to_chat(user, span_notice("你将[held]的齿纹拓印到了[src]上。"))
	else if(istype(user.get_active_held_item(), /obj/item/customlock))
		var/obj/item/customlock/held = user.get_active_held_item()
		src.lockhash = held.lockhash
		to_chat(user, span_notice("你将[src]细调至与锁芯内部相配。"))
	else if(istype(user.get_active_held_item(), /obj/item/rogueweapon/hammer) && src.lockhash != 0)
		var/obj/item/roguekey/custom/F = new (get_turf(src))
		F.lockhash = src.lockhash
		to_chat(user, span_notice("你完成了[F]。"))
		qdel(src)


//custom lock unfinished
/obj/item/customlock
	name = "未完成的锁"
	desc = "一把尚未调好锁销的锁，拥有无限可能……"
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lock"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.75
	lockhash = 0

/obj/item/customlock/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		var/input = input(user, "你想把这把锁的编号设成什么？", "", 0) as num
		input = max(0, input)
		to_chat(user, span_notice("你将锁的编号设为了[input]。"))
		lockhash = 10000 + input //same deal as the customkey
	else if(istype(I, /obj/item/roguekey))
		var/obj/item/roguekey/ID = I
		if(ID.lockhash == src.lockhash)
			to_chat(user, span_notice("[I]在[src]中顺畅转动。"))
		else
			to_chat(user, span_warning("[I]卡在[src]里了。"))
	else if(istype(I, /obj/item/customblank))
		var/obj/item/customblank/ID = I
		if(ID.lockhash == src.lockhash)
			to_chat(user, span_notice("[I]在[src]中顺畅转动。")) //this makes no sense since the teeth aren't formed yet but i want people to be able to check whether the locks theyre making actually fit
		else
			to_chat(user, span_warning("[I]卡在[src]里了。"))

/obj/item/customlock/attack_right(mob/user)
	if(istype(user.get_active_held_item(), /obj/item/roguekey))//i need to figure out how to avoid these massive if/then trees, this sucks
		var/obj/item/roguekey/held = user.get_active_held_item()
		src.lockhash = held.lockhash
		to_chat(user, span_notice("你将锁芯内部调校为匹配[held]。")) //locks for non-custom keys
	else if(istype(user.get_active_held_item(), /obj/item/customblank))
		var/obj/item/customblank/held = user.get_active_held_item()
		src.lockhash = held.lockhash
		to_chat(user, span_notice("你将锁芯内部调校为匹配[held]。"))
	else if(istype(user.get_active_held_item(), /obj/item/rogueweapon/hammer) && src.lockhash != 0)
		var/obj/item/customlock/finished/F = new (get_turf(src))
		F.lockhash = src.lockhash
		to_chat(user, span_notice("你完成了[F]。"))
		qdel(src)

//finished lock
/obj/item/customlock/finished
	name = "锁"
	desc = "一把可供钥匙使用的定制铁锁。"
	var/holdname = ""

/obj/item/customlock/finished/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		src.holdname = input(user, "你想给它起什么名字？", "", "") as text
		if(holdname)
			to_chat(user, span_notice("你给[name]标上了[holdname]。"))
	else
		..()

/obj/item/customlock/finished/attack_right(mob/user)//does nothing. probably better ways to do this but whatever

/obj/item/customlock/finished/attack_obj(obj/structure/K, mob/living/user)
	if(istype(K, /obj/structure/closet))
		var/obj/structure/closet/KE = K
		if(KE.keylock == TRUE)
			to_chat(user, span_warning("[K]已经有锁了。"))
		else
			KE.keylock = TRUE
			KE.lockhash = src.lockhash
			KE.lock_strength = 100
			if(src.holdname)
				KE.name = (src.holdname + " " + KE.name)
			to_chat(user, span_notice("你把[src]装到了[K]上。"))
			qdel(src)
	if(istype(K, /obj/structure/mineral_door))
		var/obj/structure/mineral_door/KE = K
		if(KE.keylock == TRUE)
			to_chat(user, span_warning("[K]已经有锁了。"))
		else
			KE.keylock = TRUE
			KE.lockhash = src.lockhash
			KE.lock_strength = 100
			if(src.holdname)
				KE.name = src.holdname
			to_chat(user, span_notice("你把[src]装到了[K]上。"))
			qdel(src)
	if(istype(K, /obj/structure/englauncher))
		var/obj/structure/englauncher/KE = K
		if(KE.keylock == TRUE)
			to_chat(user, span_warning("[K]已经有锁了。"))
		else
			KE.keylock = TRUE
			KE.lockhash = src.lockhash
			if(src.holdname)
				KE.name = src.holdname
			to_chat(user, span_notice("你把[src]装到了[K]上。"))
			qdel(src)
