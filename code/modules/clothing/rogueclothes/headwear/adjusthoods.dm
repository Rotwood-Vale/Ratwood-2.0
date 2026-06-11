
// REAL hoods

/obj/item/clothing/head/roguetown/roguehood
	name = "兜帽"
	desc = ""
	color = CLOTHING_BROWN
	icon_state = "basichood"
	item_state = "basichood"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi' //Overrides slot icon behavior
	alternate_worn_layer  = 8.9 //On top of helmet
	body_parts_covered = NECK|HAIR|EARS|HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	sleevetype = null
	sleeved = null
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 100
	sewrepair = TRUE
	block2add = FOV_BEHIND
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	armor = ARMOR_CLOTHING
	nudist_approved = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/roguehood/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/cloak (3).ogg', null, (UPD_HEAD|UPD_MASK))	//Standard hood

/obj/item/clothing/head/roguetown/roguehood/MiddleClick(mob/user)
	overarmor = !overarmor
	to_chat(user, span_info("我把\the [src][overarmor ? "戴在头发里面" : "戴在头发外面"]。"))
	if(overarmor)
		alternate_worn_layer = HOOD_LAYER //Below Hair Layer
	else
		alternate_worn_layer = BACK_LAYER //Above Hair Layer
	user.update_inv_wear_mask()
	user.update_inv_head()

/obj/item/clothing/head/roguetown/roguehood/red
	color = CLOTHING_RED

/obj/item/clothing/head/roguetown/roguehood/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/roguehood/darkgreen
	color = "#264d26"

/obj/item/clothing/head/roguetown/roguehood/random/Initialize(mapload)
	color = pick("#544236", "#435436", "#543836", "#79763f")
	..()

/obj/item/clothing/head/roguetown/roguehood/mage/Initialize(mapload)
	color = pick("#4756d8", "#759259", "#bf6f39", "#c1b144", "#b8252c")
	..()

/obj/item/clothing/head/roguetown/roguehood/reinforced
	name = "加固兜帽"
	armor = ARMOR_REINFORCED_HOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	max_integrity = 120//+20 over base. -30 from previous value.
	blocksound = SOFTHIT
	nudist_approved = FALSE // armored
	cold_protection = HEAD
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/head/roguetown/roguehood/shalal
	name = "库菲亚头巾"
	desc = "沙漠原住民佩戴的防护头巾。"
	color = "#b8252c"
	icon_state = "shalal"
	item_state = "shalal"
	flags_inv = HIDEHAIR|HIDEFACIALHAIR|HIDEFACE
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi' //Overrides slot icon behavior
	alternate_worn_layer  = 8.9 //On top of helmet
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	blocksound = SOFTHIT
	mask_override = TRUE
	overarmor = FALSE
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	nudist_approved = TRUE
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = HEAD
	max_heat_protection_temperature = 600

/obj/item/clothing/head/roguetown/roguehood/shalal/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/roguehood/shalal/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab
	name = "希贾布头巾"
	desc = "如伤口涌出的鲜血般垂落，这份布与丝的献礼披至肩头。其上带有纳莱迪针线活的鲜明印记。"
	item_state = "hijab"
	icon_state = "deserthood"
	flags_inv = HIDEEARS|HIDEHAIR	//Does not hide face.
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_NECK
	block2add = null

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/zyb
	name = "衬垫头巾"
	desc = "常见于长途穿越沙漠的人们，既能抵御酷热，也多少能防住那些在凉爽夜里游荡的野兽。"
	max_integrity = 100
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_NECK
	armor = ARMOR_SPELLSINGER //basically the same as a warscholar hood
	item_state = "hijab"
	icon_state = "deserthood"
	naledicolor = TRUE
	nudist_approved = FALSE // armored

/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood
	name = "厚实兜帽"
	desc = "这团厚实的粗麻布把你的头裹得严严实实，既能抵御恶劣天气，也能挡住爱管闲事的主角们。"
	color = CLOTHING_BROWN
	body_parts_covered = HEAD|HAIR|EARS|NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_NECK
	item_state = "heavyhood"
	icon_state = "heavyhood"
	nudist_approved = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = 50
	heat_protection = null
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/yoruku
	name = "暗影兜帽"
	desc = "它的位置恰到好处，刚好把面容遮得难以辨认。"
	color = CLOTHING_BLACK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_NECK

/obj/item/clothing/head/roguetown/roguehood/poacher
	name = "风化守林人兜帽"
	desc = "一顶皮革兜帽，缝得比寻常更大，好容纳头盔。折断的左鹿角上沾着干涸血迹。真正自由的代价，总是由别人的性命来支付。"
	color = null
	icon_state = "poacherhood"
	item_state = "poacherhood"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 200

	name = "风化守林人兜帽"
	desc = "一顶皮革兜帽，缝得比寻常更大，好容纳头盔。折断的左鹿角上残留着些许干血。真正自由的代价，总是由别人的性命来支付。"
	icon_state = "poacherhood"
	item_state = "poacherhood"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden64.dmi'

// Holy Hoods

/obj/item/clothing/head/roguetown/roguehood/astrata
	name = "太阳兜帽"
	desc = "一顶由崇奉阿斯特拉塔者佩戴的兜帽。赞美初升之阳！"
	color = null
	icon_state = "astratahood"
	item_state = "astratahood"
	icon = 'icons/roguetown/clothing/head.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 100
	resistance_flags = FIRE_PROOF
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/abyssor
	name = "深渊兜帽"
	desc = "一顶由阿比索尔信徒佩戴的兜帽，带有独特的珊瑚状面具。他们到底是怎么看见外面的？"
	color = null
	icon_state = "abyssorhood"
	item_state = "abyssorhood"
	icon = 'icons/roguetown/clothing/head.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 100
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/ravoxgorget
	name = "拉沃克斯罩袍护喉"
	color = null
	icon_state = "ravoxgorget"
	item_state = "ravoxgorget"
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDENECK
	dynamic_hair_suffix = ""
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	block2add = null

//............... Feldshers Hood ............... //
/obj/item/clothing/head/roguetown/roguehood/feld
	name = "军医兜帽"
	desc = "我的疗法最为有效。"
	icon_state = "feldhood"
	item_state = "feldhood"
	body_parts_covered = HEAD|EARS|NOSE
	color = null
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

//............... Physicians Hood ............... //
/obj/item/clothing/head/roguetown/roguehood/phys
	name = "医师兜帽"
	desc = "我的疗法大多时候都有效。"
	icon_state = "surghood"
	item_state = "surghood"
	body_parts_covered = HEAD|EARS|NOSE
	color = null
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

//Agnostic variants for use in the loadout.

/obj/item/clothing/head/roguetown/roguehood/shroudscarlet
	name = "猩红罩巾"
	desc = "一顶飘逸的兜帽，带着研碎玫瑰的气息。"
	icon_state = "feldhood"
	item_state = "feldhood"
	body_parts_covered = HEAD|EARS|NOSE
	color = null
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/shroudblack
	name = "黑色罩巾"
	desc = "一顶飘逸的兜帽，带着阴燃木炭的气息。"
	icon_state = "surghood"
	item_state = "surghood"
	body_parts_covered = HEAD|EARS|NOSE
	color = null
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/shroudwhite
	name = "白色罩巾"
	desc = "一顶飘逸的兜帽，带着白雪的气息。"
	icon_state = "whitehood"
	item_state = "whitehood"
	body_parts_covered = HEAD|EARS|NOSE
	color = null
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

//Psydonite hoods.

/obj/item/clothing/head/roguetown/roguehood/psydon
	name = "赛顿兜帽"
	desc = "一顶由赛顿门徒佩戴的兜帽，常与配套罩袍一同穿着。布料掺入施法纤维，能提供些许防护。"
	icon_state = "psydonhood"
	item_state = "psydonhood"
	color = null
	blocksound = SOFTHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	body_parts_covered = NECK | HEAD | HAIR
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = ARMOR_SPELLSINGER
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 200
	nudist_approved = FALSE // armored

/obj/item/clothing/head/roguetown/roguehood/psydon/confessor
	name = "告解者兜帽"
	desc = "一件宽松的皮制衣物，能在行进间收紧。它能挡住雨水、鲜血，以及污秽者的泪水。"
	icon_state = "confessorhood"
	item_state = "confessorhood"
	color = null
	body_parts_covered = NECK | HEAD | HAIR
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = ARMOR_SPELLSINGER
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 200
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/roguetown/roguehood/hierophant
	name = "大祭司披巾"
	desc = "一顶厚实兜帽，既可在需要时罩住整个头部，也可只当围巾使用。布料掺入施法纤维，能同时抵御恶魔与凡人。"
	max_integrity = 100
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = ARMOR_SPELLSINGER
	icon_state = "deserthood"
	item_state = "deserthood"
	naledicolor = TRUE
	nudist_approved = FALSE // armored
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/pontifex
	name = "教宗披巾"
	desc = "一顶纤薄兜帽，布料虽薄却致密，富有弹性又柔韧，保证活动自如。布料掺入施法纤维，能同时抵御恶魔与凡人。"
	max_integrity = 100
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = ARMOR_SPELLSINGER
	icon_state = "monkhood"
	item_state = "monkhood"
	naledicolor = TRUE
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	nudist_approved = FALSE // armored

/obj/item/clothing/head/roguetown/roguehood/sojourner
	name = "旅者罩巾"
	desc = "一件传统衣物，由那些穿越纳莱迪诅咒沙丘、熬过孤寂朝圣的人所携带。 \
	像头盔一样，它能挡下致命一击；但与头盔不同，它也能避免你的咒文出错。 </br>\
	'..我们曾受试炼；我们也曾有纵欲与堕落之地。我们本该肩并着肩守望兄弟姐妹，确保无人坠落。 \
	可我们全都失足了。我们全都放任一切变成如今这副模样。 \
	那些游荡街头、从床边掳走孩子、吞食妻子并折断丈夫的恶魔。 \
	它们就是我们，是我们亲手造出的扭曲与堕落。它们是人类眼中的人类，由我们自身扭曲的奥术显化而成..'"
	icon_state = "surghood"
	item_state = "surghood"
	color = "#a88d8d"
	resistance_flags = FIRE_PROOF
	armor = ARMOR_SPELLSINGER //Higher-tier protection for pugilist-centric classes. Fits the 'glass cannon' style, and prevents instant death through a glancing headshot on the intended archetype.
	blade_dulling = DULLING_BASHCHOP
	body_parts_covered = HEAD|HAIR|EARS
	max_integrity = ARMOR_INT_SIDE_STEEL //High leather-tier protection and critical resistances, steel-tier integrity. Integrity boost encourages hand-to-hand parrying. Weaker than the Psydonic Thorns.
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	nudist_approved = FALSE // armored
