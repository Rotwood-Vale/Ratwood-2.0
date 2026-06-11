//Lazily shoving all donator fluff items in here for now. Feel free to make this a sub-folder or something, I think it's just easier to keep a list here and just modify as needed.

//Plexiant's donator item - rapier
/obj/item/rogueweapon/sword/rapier/aliseo
	name = "阿利塞奥刺剑"
	desc = "这把细剑配有钢制剑身与装饰性镀银。其设计繁复华美，却仍保有经典伊特鲁斯卡风格的实用性；剑首嵌着一枚切割翠石，柄部精致皮革握把上还刻有家族纹章。"
	icon_state = "plex"
	icon = 'modular_azurepeak/icons/obj/items/donor_weapons_64.dmi'

//Ryebread's donator item - estoc
/obj/item/rogueweapon/estoc/worttrager
	name = "沃特崔格"
	desc = "一把进口的格伦泽尔霍夫特细剑，做工极其精良，通体不见军械坊标记，只留有匠人铭记与天顶城印玺。这把剑配有胡桃木握柄，十字护手中镶着一枚淡色蓝晶。剑根处刻着拉沃克斯的经文。"
	icon_state = "mansa"
	icon = 'modular_azurepeak/icons/obj/items/donor_weapons_64.dmi'

//Srusu's donator item - dress
/obj/item/clothing/suit/roguetown/shirt/dress/emerald
	name = "翡翠长裙"
	desc = "一件丝滑柔顺的翡翠绿长裙，只适合最优雅的淑女。"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR	//Goes either slot, no armor on it after all.
	icon_state = "laciedress"
	sleevetype = "laciedress"
	icon = 'modular_azurepeak/icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'modular_azurepeak/icons/clothing/onmob/donor_sleeves_armor.dmi'

//Strudles donator item - mage vest (same as robes)
/obj/item/clothing/suit/roguetown/shirt/robe/sofiavest
	name = "格伦泽尔霍夫特法师背心"
	desc = "一件常见于格伦泽尔霍夫特法师学院成员身上的背心。"
	icon_state = "sofiavest"
	item_state = "sofiavest"
	sleevetype = "sofiavest"
	icon = 'modular_azurepeak/icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'modular_azurepeak/icons/clothing/onmob/donor_sleeves_armor.dmi'
	flags_inv = HIDEBOOB
	color = null
	nodismemsleeves = TRUE // prevents sleeves from being torn

//Bat's donator item - custom harp sprite
/obj/item/rogue/instrument/harp/handcarved
	name = "手工竖琴"
	desc = "一把手工制作的竖琴。"
	icon_state = "batharp"
	icon = 'modular_azurepeak/icons/obj/items/donor_objects.dmi'

//Rebel0's donator item - visored sallet with a hood on under it. (Same as normal sallet)
/obj/item/clothing/head/roguetown/helmet/sallet/visored/gilded
	name = "镀金面罩盔"
	desc = "一顶带有镀金饰边的钢制头盔，能够保护耳朵、鼻子与双眼。"
	icon_state = "gildedsallet_visor"
	item_state = "gildedsallet_visor"
	icon = 'modular_azurepeak/icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing/onmob/donor_clothes.dmi'

//Bigfoot's donator item - knight helmet with gilded pattern
/obj/item/clothing/head/roguetown/helmet/heavy/knight/gilded
	name = "镀金骑士盔"
	desc = "一顶高贵骑士所佩戴的钢盔，辅以镀金饰边收束全貌。"
	icon_state = "gildedknight"
	item_state = "gildedknight"
	icon = 'modular_azurepeak/icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/knight/gilded/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

//Bigfoot's donator item - steel great axe with gilded pattern
/obj/item/rogueweapon/greataxe/steel/gilded
	name = "镀金巨斧"
	desc = "一柄镀金钢制巨斧，长柄单刃，专为彻底毁掉某人的一天而生。"
	icon_state = "orin"
	icon = 'modular_azurepeak/icons/obj/items/donor_weapons_64.dmi'

//Zydras donator item - merchant dress
/obj/item/clothing/suit/roguetown/shirt/dress/silkydress/zydrasdress //Recolored silky dress
	name = "黑金丝裙"
	desc = "一件华美的黑金长裙。看起来其中的衬垫已经被拆除了。"
	icon_state = "zydrasdress"
	item_state = "zydrasdress"
	sleevetype = "zydrasdress"
	icon = 'modular_azurepeak/icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'modular_azurepeak/icons/clothing/onmob/donor_sleeves_armor.dmi' //No sleeves

//Eiren's donator items - zweihander and sabres
/obj/item/rogueweapon/greatsword/zwei/eiren
	name = "悔恨"
	desc = "人们将愿望的小火苗汇聚在一起......为了不让它们熄灭，我们会把自己的火焰也投入所能找到的最大火堆之中。但你知道吗......我并未带着火焰而来。对我而言，也许我只是漫步到篝火旁，想稍微取取暖......"
	icon_state = "eiren"
	icon = 'modular_azurepeak/icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/sword/sabre/eiren
	name = "露奈"
	desc = "双刃其一，于诺克之光下铸成，如一缕抚慰心神的清明吐息。唯有在此，唯有仅此一处，明月与火焰方曾并存。"
	icon_state = "eiren2"
	icon = 'modular_azurepeak/icons/obj/items/donor_weapons.dmi'
	sheathe_icon = "eiren2"

/obj/item/rogueweapon/sword/sabre/eiren/small
	name = "灰烬"
	desc = "双刃其二，生自阿斯特拉塔的怒火，是一团狂烈燃烧的激情之焰。唯有在此，唯有仅此一处，命运才曾被斩断撕裂。"
	icon_state = "eiren3"
	icon = 'modular_azurepeak/icons/obj/items/donor_weapons.dmi'
	sheathe_icon = "eiren3"

//pretzel's special sword
/obj/item/rogueweapon/greatsword/weeperslathe
	name = "哀泣者车床"
	desc = "这是一把以钢重铸的吉尔青铜巨剑复刻品。剑身上刻着一句宣言：“我命虽短，却无惧一死。”" 
	icon_state = "weeperslathe"
	icon = 'modular_azurepeak/icons/obj/items/donor_weapons_64.dmi'

//inverserun's claymore
/obj/item/rogueweapon/greatsword/zwei/inverserun
	name = "祈愿荆棘"
	desc = "承诺会带来痛苦，摘取玫瑰亦然。怀抱希望会痛，凝视阿斯特拉塔光辉之美亦然。重新站起来吧。纵使荆棘在前，也别忘记你的誓言。"
	icon_state = "inverse"
	icon = 'modular_azurepeak/icons/obj/items/donor_weapons_64.dmi'

/obj/item/clothing/cloak/raincloak/feather_cloak
	name = "冥下少女裹尸布"
	desc = "这件精美斗篷由内克拉侍者的羽毛制成，每一件都赐予帷幕女士所偏爱的子嗣。它虽不提供任何实体防护，却也许能确保冥下少女的目光从未远离其穿戴者......"
	icon_state = "feather_cloak"
	item_state = "feather_cloak"
	icon = 'modular_azurepeak/icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing/onmob/donor_clothes.dmi'
	boobed = FALSE
	sleeved = 'modular_azurepeak/icons/clothing/onmob/donor_sleeves_armor.dmi'
	sleevetype = "feather_cloak"
	hoodtype = /obj/item/clothing/head/hooded/rainhood/feather_hood

/obj/item/clothing/head/hooded/rainhood/feather_hood
	name = "羽饰兜帽"
	desc = "它既能为我遮挡风雨，也能掩去我的身份。"
	icon_state = "feather_hood"
	item_state = "feather_hood"
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDETAIL
	block2add = FOV_BEHIND
	icon = 'modular_azurepeak/icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing/onmob/donor_clothes.dmi'
