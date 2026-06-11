// LIGHT ARMORS

/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn
	name = "掠袭者头盔"
	desc = "以硬化皮革制成并雕有兽骨头面，外形近似人类头颅的头盔，来自空寂北境的独特设计。 \
			据说在伊斯卡恩，这副面容足以惊走战场上败者的亡魂 \
			并阻止内克拉或驼鹿之灵让他们化作幽魂徘徊。"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnleatherhelm"
	item_state = "gronnleatherhelm"
	block2add = null
	body_parts_covered = HEAD|HAIR|EARS|EYES|NOSE
	worn_x_dimension = 32
	worn_y_dimension = 32
	cold_protection = HEAD
	min_cold_protection_temperature = 50

/obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn
	name = "掠袭者披肩"
	desc = "以骨骼与硬化皮革精心制成的披肩。在保持轻便的同时，对荒野威胁提供卓越防护， \
			伊斯卡恩流行在肩头饰以狼皮与狼头，让伟兽始终伴你左右。"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnleatherarmor"
	item_state = "gronnleatherarmor"
	armor = ARMOR_GRONN_LIGHT
	cold_protection = CHEST
	min_cold_protection_temperature = 50

/obj/item/clothing/under/roguetown/trou/leather/gronn
	name = "毛皮裤"
	desc = "一条沿腿部加有骨质强化的硬化皮裤， \
			野性十足的设计，对钝击与劈砍有出色防护，也能抵御野兽的袭击。"
	icon_state = "gronnleatherpants"
	item_state = "gronnleatherpants"
	armor = ARMOR_GRONN_LIGHT
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH)
	max_integrity = ARMOR_INT_LEG_HARDLEATHER
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	armor = ARMOR_GRONN_LIGHT
	cold_protection = GROIN
	min_cold_protection_temperature = 50

/obj/item/clothing/gloves/roguetown/angle/gronn
	name = "毛衬皮手套"
	desc = "厚实加垫的手套，为最严酷的气候与荒野中最凶猛的野兽而制。"
	icon_state = "gronnleathergloves"
	item_state = "gronnleathergloves"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	color = "#ffffff"
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/gloves/roguetown/angle/gronnfur
	name = "毛衬骨手套"
	desc = "一双硬化皮手套，腕部加有骨质强化\
			与手背相连，能提供卓越防护，抵御\
			野兽之爪，以及采集者常遇见的自然荆棘与植物抓伤。"
	icon_state = "gronnfurgloves"
	item_state = "gronnfurgloves"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	unarmed_bonus = 1.25
	max_integrity = 250
	color = "#ffffff"
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	name = "驼鹿兜帽"
	desc = "外表朴素却异常坚固的兽皮兜帽，上有一对沉重巨角。它是伊斯卡恩萨满第四试炼的奖赏: 在最终狩猎中独自猎杀一头咧嘴驼鹿，并以其头颅制成兜帽。"
	body_parts_covered = HEAD|HAIR|EARS|NOSE
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/gronn.dmi'
	icon_state = "gronnfurhood"
	item_state = "gronnfurhood"
	bloody_icon = 'icons/effects/blood64.dmi'
	armor = ARMOR_LEATHER_GOOD
	flags_inv = HIDEEARS|HIDEFACE
	worn_x_dimension = 32
	worn_y_dimension = 48
	sellprice = 10
	prevent_crits = list(BCLASS_BLUNT, BCLASS_TWIST)
	anvilrepair = null
	smeltresult = null
	sewrepair = TRUE
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_HELMET_HARDLEATHER
	salvage_result = /obj/item/natural/hide/cured
	var/on = FALSE
	var/lux_consumed = FALSE
	var/lux_color = LIGHT_COLOR_CYAN
	adjustable = CAN_CADJUST
	light_color = LIGHT_COLOR_ORANGE
	light_system = MOVABLE_LIGHT
	light_outer_range = 3
	light_power = 1
	toggle_icon_state = TRUE

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.remove_status_effect(/datum/status_effect/debuff/lost_shaman_hood)
		H.remove_stress(/datum/stressevent/shamanhoodlost)

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/dropped(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.merctype == 1) //Atgervi
			H.apply_status_effect(/datum/status_effect/debuff/lost_shaman_hood)
			H.add_stress(/datum/stressevent/shamanhoodlost)

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/Initialize(mapload)
	. = ..()
	set_light_on(FALSE)

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/MiddleClick(mob/user)
	if(.)
		return
	if(adjustable == CADJUSTED)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	toggle_helmet_light(user)
	to_chat(user, span_info("我将 [src] 点[on ? "亮" : "灭"]。"))

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/proc/toggle_helmet_light(mob/living/user)
	on = !on
	set_light_on(on)
	if(on)
		playsound(loc, 'sound/effects/hood_ignite.ogg', 100, TRUE)
		do_sparks(2, FALSE, user)
	else
		playsound(loc, 'sound/misc/toggle_lamp.ogg', 100)
	update_icon()

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/update_icon()
	if(adjustable == CADJUSTED)
		..()
		return
	if(on)
		icon_state = "gronnfurhood_lit[lux_consumed ? "3" : "2"]"
		item_state = "gronnfurhood_lit[lux_consumed ? "3" : "2"]"
	else
		icon_state = "gronnfurhood"
		item_state = "gronnfurhood"
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_head()
	..()

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/lux))
		if(adjustable == CADJUSTED)
			to_chat(user, span_warning("兜帽必须拉起才能这样做！"))
			return
		if(lux_consumed)
			to_chat(user, span_warning("它已经被注入过了。"))
			return
		to_chat(user, span_warning("我将灵魂能量注入兜帽！"))
		lux_consumed = TRUE
		set_light_range_power_color(6, 2, lux_color) //The light is doubled
		if(!on)
			toggle_helmet_light(user)
		else
			update_icon()
		qdel(I)
	. = ..()


/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			playsound(src, 'sound/foley/equip/rummaging-03.ogg', 50, TRUE)
			if(on)
				toggle_helmet_light(user)
			if(toggle_icon_state)
				icon_state = "gronnfurhood_down"
				item_state = "gronnfurhood_down"
			adjustable = CADJUSTED
			flags_inv = null
			body_parts_covered = null
		else if(adjustable == CADJUSTED)
			playsound(src, 'sound/foley/equip/cloak (3).ogg', 50, TRUE)
			ResetAdjust(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_neck()
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/ResetAdjust(mob/user)
	. = ..()
	if(on)
		set_light_on(FALSE)
	update_icon()


// MEDIUM ARMOR -- Iron reskins

/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel
	name = "欧内尔头盔"
	desc = "一顶能很好保护双眼与头部的全覆面头盔， \
			据说在格隆，涂有刺眼金色染料的狭缝能赋予佩戴者如鸟般锐利的目光。"
	icon_state = "gronnhelm"
	item_state = "gronnhelm"

/obj/item/clothing/suit/roguetown/armor/brigandine/gronn
	name = "拜林长链甲"
	desc = "格隆风格的链甲衫，外覆皮革外衣 \
			提供额外防护与更佳行动性。常被海上劫掠者使用。"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnchain"
	item_state = "gronnchain"
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/gloves/roguetown/chain/gronn
	name = "拜林手套"
	desc = "一副带链片的皮手套，可保护手腕与手背。"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnchaingloves"
	item_state = "gronnchaingloves"

/obj/item/clothing/under/roguetown/splintlegs/iron/gronn
	name = "拜林锁甲裤"
	desc = "一条锁甲裤，内衬皮质护裆，兼顾防护与舒适。"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnchainpants"
	item_state = "gronnchainpants"


// HEAVY ARMOR -- ditto

/obj/item/clothing/head/roguetown/helmet/heavy/bucket/gronn
	name = "诺尔西角盔"
	desc = "带角的铁盔，异域风格的独特设计。\
	其造型仿照传说中自遥远之地入侵而来的骑士形象。粗暴而朴实。"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/gronn.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	icon_state = "gronnplatehelm"
	item_state = "gronnplatehelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 1
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/suit/roguetown/armor/plate/iron/gronn
	name = "诺尔西铁板甲"
	desc = "饰有垂甲与圆盘护片的奇特铁胸甲，据说那景象足以撼动军阵。"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnplate"
	item_state = "gronnplate"
	boobed = FALSE
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/gloves/roguetown/plate/iron/gronn
	name = "诺尔西铁臂铠"
	desc = "铁臂铠，设计朴素却实用。挨上一拳就会留下可怕的伤痕。"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnplategloves"
	item_state = "gronnplategloves"

/obj/item/clothing/under/roguetown/platelegs/iron/gronn
	name = "诺尔西铁护腿"
	desc = "铁制护腿加覆一层皮革以提升舒适与缓冲，膝部饰有骷髅与月相般的纹样。"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnplatepants"
	item_state = "gronnplatepants"

/obj/item/clothing/shoes/roguetown/boots/armor/iron/gronn
	name = "诺尔西铁靴"
	desc = "铁靴，以皮带系缚。 \
			防护出色，一则古老传说讲述了一位伟大战士鏖战千秋，直到 \
			一名英雄以长矛刺穿了他的脚。许多人因此格外重视足部防护。"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnplateboots"
	item_state = "gronnplateboots"
