/obj/item/clothing/head/roguetown/helmet
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	name = "简易头盔"
	desc = "一顶设计再朴素不过的头盔。"
	body_parts_covered = HEAD|HAIR|NOSE
	icon_state = "nasal"
	sleevetype = null
	sleeved = null
	resistance_flags = FIRE_PROOF
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	clothing_flags = CANT_SLEEP_IN
	dynamic_hair_suffix = "+generic"
	bloody_icon_state = "helmetblood"
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	sewrepair = FALSE
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_HELMET_STEEL
	grid_height = 64
	grid_width = 64
	experimental_onhip = TRUE
	experimental_inhand = TRUE

/obj/item/clothing/head/roguetown/helmet/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	if(flags_inv & HIDE_HEADTOP)
		flags_inv &= ~HIDE_HEADTOP
	else
		flags_inv |= HIDE_HEADTOP
	user.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -5,"sy" = -3,"nx" = 0,"ny" = 0,"wx" = 0,"wy" = -3,"ex" = 2,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.42,"sx" = -3,"sy" = -8,"nx" = 6,"ny" = -8,"wx" = -1,"wy" = -8,"ex" = 3,"ey" = -8,"nturn" = 180,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 1,"sflip" = 0,"wflip" = 0,"eflip" = 8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/clothing/head/roguetown/helmet/skullcap
	name = "骷髅帽"
	desc = "一顶覆盖头顶的铁制护顶盔。"
	icon_state = "skullcap"
	body_parts_covered = HEAD|HAIR
	max_integrity = ARMOR_INT_HELMET_IRON
	smeltresult = /obj/item/ingot/iron

// Copper lamellar cap
/obj/item/clothing/head/roguetown/helmet/coppercap
	name = "札甲帽"
	desc = "一顶由铜制成的厚重札甲帽。尽管材质原始，但这种设计依然有效，足以保护头部。"
	icon_state = "lamellar"
	smeltresult = /obj/item/ingot/copper
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_HELMET_LEATHER

/obj/item/clothing/head/roguetown/helmet/horned
	name = "角饰帽"
	desc = "一顶两侧伸出双角的铁盔。"
	icon_state = "hornedcap"
	body_parts_covered = HEAD|HAIR
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_HELMET_IRON

/obj/item/clothing/head/roguetown/helmet/winged
	name = "翼饰帽"
	desc = "一顶两侧饰有双翼的头盔。"
	icon_state = "wingedcap"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	body_parts_covered = HEAD|HAIR
	dropshrink = null

/obj/item/clothing/head/roguetown/helmet/kettle
	name = "锅盔"
	desc = "一顶保护头顶与两侧的钢盔。"
	icon_state = "kettle"
	body_parts_covered = HEAD|HAIR|EARS
	armor = ARMOR_PLATE

/obj/item/clothing/head/roguetown/helmet/kettle/iron
	name = "铁锅盔"
	desc = "一顶铁制锅盔，可保护头顶与头部两侧。"
	icon_state = "ikettle"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_HELMET_IRON

/obj/item/clothing/head/roguetown/helmet/kettle/ancient
	name = "古老的锅盔"
	desc = "一顶经过打磨的吉尔青铜锅盔，保护着头顶和两侧。当涉及不洁之战时，绝不能阻挡 ZIZO 的凝视。不死弩炮手们践行着一种奇特的方法，将染色的布料系在盔檐周围；难道他们，也能思考和产生联想吗？"
	icon_state = "ancientkettle"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/head/roguetown/helmet/kettle/ancient/decrepit
	name = "破旧的锅盔"
	desc = "一顶磨损的青铜锅盔，保护着头顶和两侧。戴在复活的征召兵头皮上，这是极恶势力即将围城的前兆；而戴在毫无血肉的弩炮手头骨上，这多半意味着你该趴下了。"
	max_integrity = ARMOR_INT_HELMET_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/head/roguetown/helmet/kettle/wide
	name = "宽檐锅盔"
	desc = "一顶保护头顶与两侧的钢盔。这顶看起来比其他同类更宽。"
	icon_state = "kettlewide"

/obj/item/clothing/head/roguetown/helmet/kettle/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist + GLOB.pridelist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		if(choice in GLOB.pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/kettle/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/sallet
	name = "萨雷特盔"
	icon_state = "sallet"
	desc = "一顶保护耳部的钢盔。"
	smeltresult = /obj/item/ingot/steel
	body_parts_covered = HEAD|HAIR|EARS

/obj/item/clothing/head/roguetown/helmet/sallet/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist + GLOB.pridelist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		if(choice in GLOB.pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/sallet/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/sallet/iron
	name = "铁萨勒盔"
	icon_state = "isallet"
	desc = "一顶保护耳部的铁盔。"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_HELMET_IRON

/obj/item/clothing/head/roguetown/helmet/sallet/visored
	name = "带面罩萨勒盔"
	desc = "一顶保护耳朵、鼻子与眼睛的钢盔。"
	icon_state = "sallet_visor"
	adjustable = CAN_CADJUST
	flags_inv = HIDEFACE|HIDESNOUT|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES
	block2add = FOV_BEHIND
	smelt_bar_num = 2
	armor = ARMOR_PLATE

/obj/item/clothing/head/roguetown/helmet/sallet/shishak
	name = "钢希沙克盔"
	desc = "一顶阿夫尼克风格的平顶装饰钢盔，顶部带有尖刺，垂落的锁子甲层可保护头部两侧甚至颈部。"
	body_parts_covered = HEAD|EARS|HAIR|NECK
	max_integrity = ARMOR_INT_HELMET_STEEL + 50
	icon_state = "shishak"

/obj/item/clothing/head/roguetown/helmet/sallet/shishak
	name = "钢希沙克盔"
	desc = "一顶阿夫尼克风格的平顶装饰钢盔，顶部带有尖刺，垂落的锁子甲层可保护头部两侧甚至颈部。"
	body_parts_covered = HEAD|EARS|HAIR|NECK
	max_integrity = ARMOR_INT_HELMET_STEEL + 50
	icon_state = "shishak"

/obj/item/clothing/head/roguetown/helmet/sallet/hussarhelm
	name = "骠骑兵头盔"
	desc = "一顶由察瓦尔泰基骠骑兵佩戴的头盔，造型华丽，设计用于在冲锋时保护佩戴者免受流矢与弩箭袭击。"
	body_parts_covered = HEAD|EARS|HAIR|NECK
	max_integrity = ARMOR_INT_HELMET_STEEL + 50
	icon_state = "hussarhelm"

/obj/item/clothing/head/roguetown/helmet/sallet/visored/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), HIDEHAIR, null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Sallet. Does not hide anything when opened.

/obj/item/clothing/head/roguetown/helmet/sallet/visored/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist + GLOB.pridelist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		if(choice in GLOB.pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/sallet/visored/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/sallet/visored/iron
	name = "铁带面罩萨勒盔"
	icon_state = "isallet_visor"
	desc = "一顶保护耳朵、鼻子与眼睛的铁盔。"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_HELMET_IRON

/obj/item/clothing/head/roguetown/helmet/sallet/elven
	desc = "一顶覆有薄金镀层、专为精灵林地守卫打造的钢盔。"
	icon_state = "bascinet_novisor"
	item_state = "bascinet_novisor"
	color = COLOR_ASSEMBLY_GOLD

/obj/item/clothing/head/roguetown/helmet/sallet/zyb
	name = "库拉赫德"
	desc = "一顶结实的锥形头盔，在帝国历次征战中都立下过功劳。成千上万顶这样的头盔随军起伏前行时，蔚为壮观。比丢了它更丢脸的，只有把自己的勋章也弄丢。"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	icon_state = "raneshen"
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'


/obj/item/clothing/head/roguetown/helmet/sallet/warden
	flags_inv = HIDEFACE|HIDESNOUT
	body_parts_covered = FULL_HEAD
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND

/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf
	name = "守林人狼首骨盔"
	desc = "一具巨大而骇人的白色沃尔夫头骨，内侧覆钢并加上衬垫，再配以钢制链甲面罩与亚麻罩巾一同穿戴。这类战利品常与终生狩猎守林人及其后裔联系在一起。"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	icon_state = "skullmet_volf"

/obj/item/clothing/head/roguetown/helmet/sallet/warden/goat
	name = "守林人羊首骨盔"
	desc = "一具巨大而骇人的山谷巨公羊角骨，内侧覆钢并加上衬垫，再配以钢制链甲面罩与亚麻罩巾一同穿戴。这类战利品常与终生林务守卫及其后裔联系在一起。"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	icon_state = "skullmet_goat"

/obj/item/clothing/head/roguetown/helmet/sallet/warden/bear
	name = "守林人熊首骨盔"
	desc = "一具巨大而骇人的恐熊头骨，内侧覆钢并加上衬垫，再配以钢制链甲面罩与亚麻罩巾一同穿戴。这类战利品常与终生猎人及其后裔联系在一起。"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	icon_state = "skullmet_bear"

/obj/item/clothing/head/roguetown/roguehood/warden
	name = "守林人兜帽"
	desc = "一顶猎人用皮革兜帽，内有两层亚麻衬里，缝制得比平时更大，好容纳头盔或兽骨头罩。"
	color = null
	icon_state = "wardenhood"
	item_state = "wardenhood"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	resistance_flags = FIRE_PROOF
	toggle_icon_state = TRUE
	max_integrity = 200

/obj/item/clothing/head/roguetown/roguehood/warden/antler
	name = "守林人鹿角兜帽"
	desc = "一顶猎人用皮革兜帽，内有两层亚麻衬里，缝制得比平时更大以容纳头盔，并装上了老赛加羚的大角。"
	icon_state = "wardenhoodalt"
	item_state = "wardenhoodalt"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'

/obj/item/clothing/head/roguetown/helmet/sallet/beastskull
	name = "兽首骨盔"
	desc = "一颗长角野兽的头骨，被雕琢并制成头盔，内侧还嵌入了一顶钢制护顶帽。"
	icon_state = "marauder_head"
	body_parts_covered = HEAD|EARS|HAIR
	max_integrity = ARMOR_INT_HELMET_STEEL + 50
	smeltresult = /obj/item/ingot/steel
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'

/obj/item/clothing/head/roguetown/helmet/otavan
	name = "奥塔瓦头盔"
	desc = "一顶奥塔瓦制式的头盔，结构类似赛顿式阿米特盔，但配有棱角分明的开缝面罩。"
	icon_state = "otavahelm"
	item_state = "otavahelm"
	adjustable = CAN_CADJUST
	emote_environment = 3
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#e08828"

/obj/item/clothing/head/roguetown/helmet/otavan/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/otavan/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -5,"sy" = -3,"nx" = 0,"ny" = 0,"wx" = 0,"wy" = -3,"ex" = 2,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.32,"sx" = -3,"sy" = -8,"nx" = 6,"ny" = -8,"wx" = -1,"wy" = -8,"ex" = 3,"ey" = -8,"nturn" = 180,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 1,"sflip" = 0,"wflip" = 0,"eflip" = 8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/clothing/head/roguetown/helmet/otavan/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), HIDEEARS, null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Otavan. Only hides ears when open.

/obj/item/clothing/head/roguetown/helmet/elvenbarbute
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	name = "精灵巴布塔盔"
	desc = "它能紧贴精灵的头部轮廓，并为他们更尖的耳朵留有专门的开槽。"
	body_parts_covered = FULL_HEAD
	body_parts_covered = HEAD|HAIR|NOSE
	flags_inv = HIDEEARS|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	icon_state = "elven_barbute_full"
	item_state = "elven_barbute_full"
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	clothing_flags = 0
	block2add = FOV_BEHIND

/obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged
	name = "翼饰精灵巴布塔盔"
	desc = "精灵巴布塔盔的翼饰版本。他们一向以虚荣闻名。"
	icon_state = "elven_barbute_winged"
	item_state = "elven_barbute_winged"

/obj/item/clothing/head/roguetown/helmet/bascinet
	name = "盆盔"
	desc = "一顶钢制盆盔。虽然没有面罩，但仍能保护头部与耳朵。"
	icon_state = "bascinet_novisor"
	item_state = "bascinet_novisor"
	emote_environment = 3
	body_parts_covered = HEAD|HAIR|EARS
	flags_inv = HIDEEARS|HIDEHAIR
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface
	name = "猪面盆盔"
	desc = "一顶带猪面面罩的钢制盆盔，可保护整个头部与面部。插上一根羽毛，展示你的家族或效忠色彩。"
	icon_state = "hounskull"
	item_state = "hounskull"
	adjustable = CAN_CADJUST
	emote_environment = 3
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "羽饰") as anything in GLOB.colorlist + GLOB.pridelist
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull
	name = "犬首盆盔"
	desc = "一顶带锥形面罩的盆盔，深受有吻部和须毛者喜爱。可在边缘插上一根羽毛以展示你的效忠色彩。"
	icon_state = "bascinet"


/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet


/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "羽饰") as anything in GLOB.colorlist
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
	if(istype(W, /obj/item/natural/cloth) && !altdetail_tag)
		var/choicealt = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist + GLOB.pridelist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		altdetail_color = GLOB.colorlist[choicealt]
		altdetail_tag = "_detailalt"
		if(choicealt in GLOB.pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()


/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
	name = "\improper 伊特鲁斯卡盆盔"
	desc = "一顶带直式面罩的钢制盆盔，也就是\"掀面式盆盔\"，会大幅限制视野。它虽最早诞生于伊特鲁斯卡，如今也在格伦泽尔霍夫被广泛使用。"
	icon_state = "klappvisier"
	item_state = "klappvisier"
	adjustable = CAN_CADJUST
	emote_environment = 3
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2

/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "选择一种颜色。", "饰边") as anything in GLOB.colorlist + GLOB.pridelist
		user.visible_message(span_warning("[user]把[W]加到了[src]上。"))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = GLOB.colorlist[choice]
		detail_tag = "_detail"
		if(choice in GLOB.pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/kettle/jingasa
	name = "阵笠"
	desc = "一顶以钢加固的锥形帽，边缘饰有布料装饰。它在保护头部与耳朵的同时，也能为眼睛遮挡阳光。"
	icon_state = "kazengunmedhelm"
	item_state = "kazengunmedhelm"
	detail_tag = "_detail"
	detail_color = "#FFFFFF"

/obj/item/clothing/head/roguetown/helmet/kettle/jingasa/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

//............... Eora Helmet ............... //
/obj/item/clothing/head/roguetown/helmet/sallet/eoran
	name = "伊欧拉头盔"
	desc = "一顶朴素却可靠的头盔，锻造风格很典型地属于伊欧拉信徒。其上饰有数圈花环与其他彩色装饰，并附有记述佩戴者所属支部功绩与惩戒的符记。"
	icon_state = "eorahelmsallet"
	item_state = "eorahelmsallet"

// Warden Helmets
/obj/item/clothing/head/roguetown/helmet/bascinet/antler
	name = "守林人头盔"
	desc = "一顶野性十足、带吻部的阿米特盔，向外伸出老赛加羚的大角。山谷居民在荒野中见到这副模样并不会恐惧，因为它只与罗特伍德守林人相关。"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden64.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	icon_state = "wardenhelm"
	adjustable = CAN_CADJUST
	worn_x_dimension = 64
	worn_y_dimension = 64
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/obj/item/clothing/head/roguetown/helmet/bascinet/antler/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)	//Standard helmet

/obj/item/clothing/head/roguetown/helmet/sallet/warden
	flags_inv = HIDEFACE|HIDESNOUT
	body_parts_covered = FULL_HEAD
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND

/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf
	name = "守林人狼首骨盔"
	desc = "一具巨大而骇人的白色沃尔夫头骨，内侧覆钢并加上衬垫，再配以钢制链甲面罩与亚麻罩巾一同穿戴。这类战利品常与终生狩猎守林人及其后裔联系在一起。"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	icon_state = "skullmet_volf"

/obj/item/clothing/head/roguetown/helmet/sallet/warden/goat
	name = "守林人羊首骨盔"
	desc = "一具巨大而骇人的山谷巨公羊角骨，内侧覆钢并加上衬垫，再配以钢制链甲面罩与亚麻罩巾一同穿戴。这类战利品常与终生林务守卫及其后裔联系在一起。"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	icon_state = "skullmet_goat"

/obj/item/clothing/head/roguetown/helmet/sallet/warden/bear
	name = "守林人熊首骨盔"
	desc = "一具巨大而骇人的恐熊头骨，内侧覆钢并加上衬垫，再配以钢制链甲面罩与亚麻罩巾一同穿戴。这类战利品常与终生猎人及其后裔联系在一起。"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	icon_state = "skullmet_bear"

/obj/item/clothing/head/roguetown/roguehood/warden
	name = "守林人兜帽"
	desc = "一顶猎人用皮革兜帽，内有两层亚麻衬里，缝制得比平时更大，好容纳头盔或兽骨头罩。"
	color = null
	icon_state = "wardenhood"
	item_state = "wardenhood"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 200

/obj/item/clothing/head/roguetown/roguehood/warden/antler
	name = "守林人鹿角兜帽"
	desc = "一顶猎人用皮革兜帽，内有两层亚麻衬里，缝制得比平时更大以容纳头盔，并装上了老赛加羚的大角。"
	icon_state = "wardenhoodalt"
	item_state = "wardenhoodalt"
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'

//Gronn
/obj/item/clothing/head/roguetown/helmet/nomadhelmet
	name = "游牧头盔"
	desc = "一顶带有皮革护颈的铁盔。"
	icon_state = "nomadhelmet"
	item_state = "nomadhelmet"
	max_integrity = ARMOR_INT_HELMET_LEATHER
	flags_inv = HIDEHAIR
	body_parts_covered = HEAD|HAIR|EARS|NOSE|NECK
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_STAB)
	max_integrity = 250
	smeltresult = /obj/item/ingot/iron
	dropshrink = null


	//----------------- INFAREDBARON/HATS.DM ---------------------
/obj/item/clothing/head/roguetown/helmet/citywatch
	name = "城卫头盔"
	desc = "一顶厚重的头盔，尤为坚固耐用，配发给城卫使用。"
	icon = 'icons/roguetown/clothing/licensed-infraredbaron/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/licensed-infraredbaron/onmob/armor.dmi'
	icon_state = "citywatch_helmet"
	item_state = "citywatch_helmet"
	armor_class = ARMOR_CLASS_MEDIUM
	body_parts_covered = HEAD|HAIR|EARS
	flags_inv = HIDEHAIR
	smeltresult = /obj/item/ingot/steel
	emote_environment = 3
	dropshrink = null
