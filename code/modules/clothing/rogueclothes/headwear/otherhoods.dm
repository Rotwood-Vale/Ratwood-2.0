/obj/item/clothing/head/roguetown/antlerhood
	name = "鹿角兜帽"
	desc = "一顶适合德鲁伊与萨满佩戴的兜帽。"
	color = null
	flags_inv = HIDEEARS|HIDEHAIR
	icon_state = "antlerhood"
	item_state = "antlerhood"
	icon = 'icons/roguetown/clothing/head.dmi'
	body_parts_covered = HEAD|HAIR|EARS|NECK
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	max_integrity = 80
	armor = ARMOR_CLOTHING
	prevent_crits = list(BCLASS_TWIST)
	anvilrepair = null
	blocksound = SOFTHIT
	nudist_approved = TRUE
	salvage_result = /obj/item/natural/hide
	salvage_amount = 1
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/beekeeper
	name = "养蜂人的兜帽"
	desc = ""
	flags_inv = HIDEEARS|HIDEHAIR
	icon_state = "beekeeper"
	item_state = "beekeeper"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	alternate_worn_layer  = 8.9 //On top of helmet
	body_parts_covered = HEAD|HAIR|EARS|NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	sleevetype = null
	sleeved = null
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CANT_CADJUST
	toggle_icon_state = FALSE
	max_integrity = 100
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/nochood
	name = "月兜帽"
	desc = "一顶由 Noc 信徒佩戴的兜帽，配有新月形面具。"
	color = null
	icon_state = "nochood"
	item_state = "nochood"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	dynamic_hair_suffix = ""
	nudist_approved = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/necrahood
	name = "死亡罩巾"
	desc = "暗色布缕垂落，遮住你的整个头部，并在微风中轻轻飘动。常为引渡亡者前往来世之人所佩戴。"
	color = null
	icon_state = "necrahood"
	item_state = "necrahood"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	dynamic_hair_suffix = ""
	nudist_approved = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/necramask
	name = "死者面具"
	desc = "一顶在下巴处饰有颌骨装饰的兜帽，一些 Necra 的追随者会将其作为虔敬的象征佩戴。"
	color = null
	icon_state = "deathface"
	item_state = "deathface"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi' //Overrides slot icon behavior
	body_parts_covered = NECK|MOUTH //Jaw bone
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEEARS|HIDESNOUT|HIDEHAIR|HIDEFACIALHAIR
	dynamic_hair_suffix = ""
	mask_override = TRUE
	nudist_approved = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/dendormask
	name = "荆棘面具"
	desc = "一副由木头与荆棘制成、供侍奉 Dendor 的德鲁伊佩戴的面具。"
	color = null
	icon_state = "dendormask"
	item_state = "dendormask"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	body_parts_covered = MOUTH
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	dynamic_hair_suffix = ""
	mask_override = TRUE
	nudist_approved = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/necromhood
	name = "死灵法师兜帽"
	color = null
	icon_state = "necromhood"
	item_state = "necromhood"
	body_parts_covered = NECK
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	dynamic_hair_suffix = ""
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/menacing
	name = "麻袋兜帽"
	desc = "一种刽子手常戴来遮掩面容的兜帽；这种身份的污名，以及其所涉及的一切血腥工作，使许多刽子手本身也成了被排斥之人。"
	icon_state = "menacing"
	item_state = "menacing"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	dynamic_hair_suffix = ""
	nudist_approved = TRUE
	color = "#999999"
	//dropshrink = 0.75
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/menacing/bandit
	icon_state = "bandithood"
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/jester
	name = "弄臣帽子"
	desc = "一顶模样滑稽、缀着叮当作响铃铛的帽子。"
	icon_state = "jester"
	item_state = "jester"
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	dynamic_hair_suffix = "+generic"
	flags_inv = HIDEEARS
	detail_color = CLOTHING_WHITE
	color = CLOTHING_AZURE
	altdetail_color = CLOTHING_WHITE
	nudist_approved = TRUE

/obj/item/clothing/head/roguetown/jester/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/jester/lordcolor(primary,secondary)
	detail_color = secondary
	color = primary
	update_icon()

/obj/item/clothing/head/roguetown/jester/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS, 2)
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/head/roguetown/jester/jester/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/head/roguetown/jester/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	if(flags_inv & HIDE_HEADTOP)
		flags_inv &= ~HIDE_HEADTOP
	else
		flags_inv |= HIDE_HEADTOP
	user.update_inv_head()
	user.update_fov_angles()
	user.update_vision_cone()
