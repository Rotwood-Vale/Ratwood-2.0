/obj/item/clothing/neck/roguetown
	name = "项链"
	desc = ""
	icon = 'icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/neck.dmi'
	bloody_icon_state = "bodyblood"
	experimental_inhand = FALSE
	alternate_worn_layer = NECK_LAYER
	sewrepair = FALSE //most neck items are necklaces or armor
	var/overarmor

/obj/item/clothing/neck/roguetown/examine()
	. = ..()
	if(bell)
		. += span_info("它上面系着一个<a href='?src=[REF(src)];removebell=1'>铃铛</a>。")

/obj/item/clothing/neck/roguetown/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["removebell"])
		remove_bell(usr)

/obj/item/clothing/neck/roguetown/proc/remove_bell(mob/user)
	if(!bell)
		return
	if(!Adjacent(user))
		to_chat(user, span_warning("我倒是很想把那铃铛摘下来，可我离得不够近。"))
		return
	for(var/obj/item/catbell/bell in src)
		user.put_in_hands(bell)
		break
	bell = FALSE
	bellsound = FALSE
	qdel(src.GetComponent(/datum/component/squeak))
	to_chat(user, span_info("我把[src]上的铃铛取了下来。"))

/obj/item/clothing/neck/roguetown/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/catbell))
		var/obj/item/catbell/bell = I
		if(src.bellsound || src.bell) //Already has a bell, can't attach another one.
			to_chat(user, span_info("[src]已经挂着铃铛了！"))
			return
		to_chat(user, span_info("我把\the [bell]挂到了[src]上。"))
		src.bell = TRUE
		src.bellsound = TRUE
		src.AddComponent(/datum/component/squeak, bell.jingle_sounds, 50, 100, 1)
		I.forceMove(src)
	..()

/obj/item/clothing/neck/roguetown/MiddleClick(mob/user, params)
	. = ..()
	if((user.zone_selected == BODY_ZONE_PRECISE_NOSE) && (cansnout == TRUE))
		if(snouting == TRUE)
			snouting = FALSE
			flags_inv += HIDESNOUT
		else
			snouting = TRUE
			flags_inv -= HIDESNOUT
		to_chat(user, span_info("我[snouting ? "给\the [src]留出吻部空间" : "把\the [src]戴得更紧"]."))
		if(snouting)
			icon_state = "[initial(icon_state)]_snout"
		else
			icon_state = "[initial(icon_state)]"
	else
		overarmor = !overarmor
		to_chat(user, span_info("我[overarmor ? "把\the [src]穿在护甲外面" : "把\the [src]穿在护甲下面"]."))
		if(overarmor)
			alternate_worn_layer = NECK_LAYER
		else
			alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_neck()
	user.update_inv_cloak()
	user.update_inv_armor()
	user.update_inv_shirt()

/obj/item/clothing/neck/roguetown/coif
	name = "护头巾"
	desc = "便宜又容易制作，总比让脖子裸露在外强。"
	icon_state = "coif"
	item_state = "coif"
	color = CLOTHING_BROWN
	flags_inv = HIDEHAIR
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	blocksound = SOFTHIT
	body_parts_covered = NECK|HAIR|EARS|HEAD
	armor = ARMOR_PADDED_BAD
	max_integrity = ARMOR_INT_CHEST_LIGHT_BASE
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	sewrepair = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/neck/roguetown/coif/padded
	name = "衬垫护头巾"
	desc = "一顶便宜朴素的棉甲护头巾，可单独佩戴，也可戴在头盔下面。总比没有强。"
	icon_state = "ccoif"
	item_state = "ccoif"
	color = "#ad977d"
	body_parts_covered = NECK|HAIR|EARS|HEAD
	armor = ARMOR_PADDED //gambeson for head
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)

/obj/item/clothing/neck/roguetown/coif/heavypadding
	name = "厚实衬垫护头巾"
	desc = "一顶更厚实的衬垫护头巾，可单独佩戴，也可戴在头盔下面。层层穿戴妥当后，哪怕在最繁忙的日子里也能撑住。"
	icon_state = "fullpadded"
	item_state = "fullpadded"
	color = "#976E6B"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	body_parts_covered = NECK|HAIR|EARS|HEAD|MOUTH
	armor = ARMOR_PADDED_GOOD //full padded gambeson basically
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_CHOP)

/obj/item/clothing/neck/roguetown/coif/heavypadding/ComponentInitialize()
	return

/obj/item/clothing/neck/roguetown/coif/heavypadding/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "fullpadded_down"
			flags_inv = HIDEHAIR
			body_parts_covered = NECK|HAIR|EARS|HEAD
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_neck()
				H.update_inv_head()
		else if(adjustable == CADJUSTED)
			adjustable = CADJUSTED_MORE
			if(toggle_icon_state)
				icon_state = "fullpadded_neck"
			flags_inv = null
			body_parts_covered = NECK
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_neck()
				H.update_inv_head()
		else if(adjustable == CADJUSTED_MORE)
			ResetAdjust(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_neck()
			H.update_inv_head()

/obj/item/clothing/neck/roguetown/coif/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, null, null, (UPD_HEAD|UPD_MASK|UPD_NECK))	//Soundless coif

/obj/item/clothing/neck/roguetown/leather
	name = "硬化皮革护喉"
	desc = "结实，耐用，能让你的脖子少挨几下狠的。"
	icon_state = "lgorget"
	slot_flags = ITEM_SLOT_NECK
	blocksound = SOFTHIT
	body_parts_covered = NECK
	body_parts_inherent = NECK
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_SMASH)
	sewrepair = TRUE
	sellprice = 10
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/neck/roguetown/chaincoif
	name = "锁链护头巾"
	desc = "比普通护喉提供更全面的覆盖，但相应地也牺牲了一些防护。"
	icon_state = "chaincoif"
	item_state = "chaincoif"
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	flags_inv = HIDEHAIR
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_SIDE_STEEL
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	body_parts_covered = NECK|HAIR|EARS|HEAD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	blocksound = CHAINHIT
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/neck/roguetown/chaincoif/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/chain_equip.ogg', null, (UPD_HEAD|UPD_MASK|UPD_NECK))	//Chain coif.

/obj/item/clothing/neck/roguetown/chaincoif/ancient
	name = "远古护头巾"
	desc = "打磨光亮的吉尔青铜环彼此相扣，组成一顶翻卷起伏的罩帽。愿拯救这垂死世界的不是荆棘冠冕，而是野心之冠；由束缚的金属与染污的骨骸构成，在齐佐的意志下焕发生机，宣告她迄今为止最伟大的造物即将到来。"
	icon_state = "achaincoif"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/neck/roguetown/chaincoif/ancient/decrepit
	name = "破旧护头巾"
	desc = "磨损的青铜环彼此相扣，组成一顶翻卷起伏的罩帽。连接处布满弹片、箭镞与矛尖，仿佛全都来自一片连历史与军团兵都已湮没于时光的战场。"
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	name = "锁链披肩"
	desc = "一件更厚实耐用的颈部防具，拉起时还能遮住口部。"
	icon_state = "chainmantle"
	armor = ARMOR_MAILLE
	body_parts_covered = NECK|MOUTH
	slot_flags = ITEM_SLOT_NECK
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	cansnout = TRUE
	dropshrink = 0.8

/obj/item/clothing/neck/roguetown/chaincoif/chainmantle/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (NECK), null, null, 'sound/foley/equip/equip_armor_chain.ogg', null, (UPD_HEAD|UPD_MASK|UPD_NECK))	//Chain coif.

/obj/item/clothing/neck/roguetown/chaincoif/iron
	name = "铁锁链护头巾"
	desc = "一顶由精工铁环编成的护头巾。虽然不是钢，但金属就是金属，也许真能救你一命。"
	icon_state = "ichaincoif"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_SIDE_IRON

/obj/item/clothing/neck/roguetown/chaincoif/full
	name = "全覆式锁链护头巾"
	icon_state = "fchaincoif"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	resistance_flags = FIRE_PROOF
	body_parts_covered = NECK|MOUTH|NOSE|HAIR|EARS|HEAD
	adjustable = CAN_CADJUST
	cansnout = TRUE

/obj/item/clothing/neck/roguetown/chaincoif/full/ComponentInitialize()
	return

/obj/item/clothing/neck/roguetown/chaincoif/full/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "chaincoif"
			flags_inv = HIDEHAIR
			body_parts_covered = NECK|HAIR|EARS|HEAD
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_neck()
				H.update_inv_head()
		else if(adjustable == CADJUSTED)
			adjustable = CADJUSTED_MORE
			if(toggle_icon_state)
				icon_state = "chaincoif_t"
			flags_inv = null
			body_parts_covered = NECK
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_neck()
				H.update_inv_head()
		else if(adjustable == CADJUSTED_MORE)
			ResetAdjust(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_neck()
			H.update_inv_head()

/obj/item/clothing/neck/roguetown/chaincoif/full/black
	color = "#323232"

/obj/item/clothing/neck/roguetown/bevor
	name = "护颚"
	desc = "一组用于保护颈部的钢板。"
	icon_state = "bevor"
	armor = ARMOR_PLATE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	max_integrity = ARMOR_INT_SIDE_STEEL
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK|MOUTH|NOSE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	blocksound = PLATEHIT
	cansnout = TRUE

/obj/item/clothing/neck/roguetown/bevor/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/items/visor.ogg', null, (UPD_HEAD|UPD_MASK|UPD_NECK)) // adjustable falling buffe for the bevor

/obj/item/clothing/neck/roguetown/bevor/iron
	name = "铁护颚"
	desc = "一组用于保护颈部的铁板。"
	icon_state = "ibevor"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_SIDE_IRON

/obj/item/clothing/neck/roguetown/gorget
	name = "护喉"
	desc = "一组用于保护颈部的铁板。"
	icon_state = "gorget"
	armor = ARMOR_PLATE
	smeltresult = /obj/item/ingot/iron
	anvilrepair = /datum/skill/craft/armorsmithing
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	max_integrity = ARMOR_INT_SIDE_IRON
	resistance_flags = FIRE_PROOF
	body_parts_inherent = NECK
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = PLATEHIT

/obj/item/clothing/neck/roguetown/gorget/steel
	name = "钢护喉"
	smeltresult = /obj/item/ingot/steel
	max_integrity = ARMOR_INT_SIDE_STEEL
	icon_state = "sgorget"

/obj/item/clothing/neck/roguetown/gorget/steel/ancient
	name = "远古护喉"
	desc = "打磨光亮的吉尔布兰泽护片层层相叠，以守护颈部。脊柱是灵与肉之间的神圣脉络，绝不可断裂，否则她的赐福也将随之失落。"
	icon_state = "ancientgorget"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/neck/roguetown/gorget/steel/ancient/decrepit
	name = "破旧护喉"
	desc = "磨损的青铜护片彼此交叠，覆盖住颈部。两侧布满原始粗陋的刮痕，而中央看起来却像是曾被长矛一击贯穿。"
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/neck/roguetown/gorget/copper
	name = "护颈"
	icon_state = "copperneck"
	desc = "一种古旧而朴素的颈部防具，平民更多把它当成配饰。但再差的防护，也总比没有强。"
	armor = ARMOR_PLATE_BAD
	smeltresult = /obj/item/ingot/copper

/obj/item/clothing/neck/roguetown/fencerguard
	name = "击剑守卫"
	icon_state = "fencercollar"
	armor = ARMOR_PLATE
	smeltresult = /obj/item/ingot/steel
	anvilrepair = /datum/skill/craft/armorsmithing
	max_integrity = ARMOR_INT_SIDE_STEEL
	body_parts_inherent = NECK
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = PLATEHIT
	allowed_race = NON_DWARVEN_RACE_TYPES
	detail_tag = "_detail"
	color = "#5058c1"
	detail_color = "#e98738"
	var/picked = FALSE

/obj/item/clothing/neck/roguetown/fencerguard/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "选择一种颜色。", "奥塔瓦配色") as anything in GLOB.colorlist
		var/playerchoice = GLOB.colorlist[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_icon()

/obj/item/clothing/neck/roguetown/fencerguard/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/neck/roguetown/fencerguard/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/neck/roguetown/gorget/forlorncollar
	name = "弗雷卡勒"
	desc = "自然从不知何为怜悯。"
	icon_state = "iwolfcollaralt"

/obj/item/clothing/neck/roguetown/gorget/steel/kazengun
	name = "卡曾郡护喉"
	desc = "一圈圈相互咬合的金属环围住咽喉。卡曾郡的甲士佩戴它的理由，与普西多尼亚的骑士们别无二致。"
	icon_state = "kazengunneckguard"

/obj/item/clothing/neck/roguetown/gorget/cursed_collar // minor flavor swap so people know it's a scam shitty knockoff.
	name = "次级诅咒颈圈"
	desc = "一条似乎散发着不祥气息的金属项圈，是其工造原型的拙劣仿品。\n看起来你得靠别人帮忙才能把它取下来。"
	icon_state = "cursed_collar"
	item_state = "cursed_collar"
	armor = ARMOR_CLOTHING
	smeltresult = /obj/item/ingot/iron
	anvilrepair = /datum/skill/craft/armorsmithing
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	prevent_crits = list()
	blocksound = PLATEHIT
	leashable = TRUE

/obj/item/clothing/neck/roguetown/gorget/cursed_collar/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_SELF_UNEQUIP, CURSED_ITEM_TRAIT)

/obj/item/clothing/neck/roguetown/psicross
	name = "教十字"
	desc = "'每断一根骨头，我都发誓自己仍活着！'"
	icon_state = "psycross"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	possible_item_intents = list(/datum/intent/use, /datum/intent/special/magicarc)
	sellprice = 10
	experimental_onhip = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	grid_width = 32
	grid_height = 32
	nudist_approved = TRUE
	dropshrink = 0.6

/obj/item/clothing/neck/roguetown/psicross/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	..()

	if(slot == SLOT_WRISTS)
		mob_overlay_icon = 'icons/roguetown/clothing/onmob/wrists.dmi'
		sleeved = 'icons/roguetown/clothing/onmob/wrists.dmi'
	if(slot == SLOT_NECK)
		mob_overlay_icon = initial(mob_overlay_icon)
		sleeved = initial(sleeved)

	return TRUE

/obj/item/clothing/neck/roguetown/psicross/attack_right(mob/user)
	..()
	user.emote("pray")
	return

/obj/item/clothing/neck/roguetown/psicross/inhumen
	name = "倒置普赛圣十字"
	desc = "一个来自仍有理由相信它的时代的野心象征。"
	icon_state = "zcross_iron"

/obj/item/clothing/neck/roguetown/psicross/inhumen/ancient
	name = "远古齐佐十字"
	desc = "'野心。命运。升华。神所颁下、由人完成的诫命。她将我们自现实的边缘召来，又在临终前以嘶哑之息吐露最后的真相：火焰已逝，而世界也将很快步其后尘。'"
	icon_state = "zcross_a"
	color = "#bb9696"

/obj/item/clothing/neck/roguetown/psicross/undivided
	name = "圣座护符"
	desc = "一枚通常由圣座权势人物佩戴的护符。数百年来始终坚定地对抗黑暗。\
	既是地位的象征，也是恩典的标记。"
	icon_state = "undivided"

/obj/item/clothing/neck/roguetown/psicross/astrata
	name = "阿斯特拉塔护符"
	desc = "正如太阳必然升起，明日也终将到来。"
	icon_state = "astrata"

/obj/item/clothing/neck/roguetown/psicross/silver/astrata
	name = "祝圣阿斯特拉塔护符"
	desc = "与普通的阿斯特拉塔护符相似，只是这一枚由白银制成并受过祝福。女王不会讨价还价，也不会退让。她的追随者更不会如此，尤其是她的神职者们，因为随着普希顿离去，阿斯特拉塔承担起了祂血脉延续的重担。万物皆在她的视界之内，而整个国度同样也在你的职责范围之中。坚定前行吧，否则一旦她移开目光，一切都将坠入异端的灾祸。"
	icon_state = "astrata"

/obj/item/clothing/neck/roguetown/psicross/noc
	name = "诺克护符"
	desc = "总有更多值得知晓，更多值得学习，更多值得成为。"
	icon_state = "noc"

/obj/item/clothing/neck/roguetown/psicross/abyssor
	name = "阿比索护符"
	desc = "畏惧未知，便是背离了最伟大的奥秘。"
	icon_state = "abyssor"
	salvage_result = /obj/item/pearl/blue
	salvage_amount = 1

/obj/item/clothing/neck/roguetown/psicross/dendor
	name = "登多尔护符"
	desc = "如果你非要崇拜什么，那就崇拜生命吧，连最细微、最蠕动的一点都别落下。"
	icon_state = "dendor"

/obj/item/clothing/neck/roguetown/psicross/necra
	name = "内克拉护符"
	desc = "死亡的必然提醒着你，要珍惜自己仍握在手中的时光。"
	icon_state = "necra"

/obj/item/clothing/neck/roguetown/psicross/pestra
	name = "佩斯特拉护符"
	desc = "健康之人所戴的王冠，唯有病者方能看见。"
	icon_state = "pestra"

/obj/item/clothing/neck/roguetown/psicross/ravox
	name = "拉沃克斯护符"
	desc = "你究竟为何而战？"
	icon_state = "ravox"

/obj/item/clothing/neck/roguetown/psicross/malum
	name = "玛卢姆护符"
	desc = "自灰烬之中，万物再生。"
	icon_state = "malum"

/obj/item/clothing/neck/roguetown/psicross/eora
	name = "伊欧拉护符"
	desc = "在这充满恐惧与苦难的世界里，我们拥有的唯有彼此。"
	icon_state = "eora"

/obj/item/clothing/neck/roguetown/psicross/xylix
	name = "赛利克斯护符"
	desc = "在此生之中，笑容比任何刀锋都更锐利。"
	icon_state = "xylix"

/obj/item/clothing/neck/roguetown/psicross/wood
	name = "木制教十字"
	desc = "'一个一无所有的人，也依然可以怀有信仰！'"
	icon_state = "psycross_w"
	item_state = "psycross_w"
	sellprice = 0
	salvage_result = /obj/item/grown/log/tree/stick
	salvage_amount = 1

/obj/item/clothing/neck/roguetown/psicross/decrepit
	name = "破旧教十字"
	desc = "'那是一颗足以将人类的一切敌人撕裂殆尽的彗星；祂的力量何其优雅！祂的牺牲又何其高贵！可如今祂却沉眠不醒，不知晓自己的努力最终结出了怎样的果实。祂叹息着，也哭泣着。'"
	icon_state = "psycross_a"
	color = "#bb9696"

/obj/item/clothing/neck/roguetown/psicross/silver
	name = "银教十字"
	desc = "'恐怖仍在延续，而我也一样！'"
	icon_state = "psycross_s"
	item_state = "psycross_s"
	sellprice = 50
	is_silver = TRUE

/obj/item/clothing/neck/roguetown/psicross/silver/equipped(mob/user, slot)
	. = ..()
	if(isliving(user) && (slot_flags & slotdefine2slotbit(slot))) //worn in a slot this cross actually goes in
		ADD_TRAIT(user, TRAIT_WORN_SILVER_PSICROSS, REF(src))

/obj/item/clothing/neck/roguetown/psicross/silver/dropped(mob/user)
	. = ..()
	if(isliving(user))
		REMOVE_TRAIT(user, TRAIT_WORN_SILVER_PSICROSS, REF(src))

/obj/item/clothing/neck/roguetown/psicross/g
	name = "金色教十字"
	desc = "'纯洁高悬，因为乐园正在彼岸等待！'"
	icon_state = "psycross_g"
	item_state = "psycross_g"
	sellprice = 100

/obj/item/clothing/neck/roguetown/psicross/reform
	name = "改革派教十字"
	desc = "一枚尖端向内弯折的教十字。神已死去，但祂留下的这个世界依旧美丽，值得被热爱。用你全身每一根断骨去坚持吧。"
	sellprice = 0
	icon_state = "psycross_reform"

/obj/item/clothing/neck/roguetown/psicross/pearl //put it as a psycross so it can be used for miracles
	name = "珍珠护符"
	icon_state = "pearlcross"
	desc = "一枚由白珍珠制成的护符，通常由渔夫或水手佩戴。"
	sellprice = 80
	salvage_result = /obj/item/pearl
	salvage_amount = 3 // Pearls are easy to cut off from an amulet

/obj/item/clothing/neck/roguetown/psicross/bpearl
	name = "蓝色珍珠护符"
	icon_state = "bpearlcross"
	desc = "一枚由稀有蓝珍珠制成的护符，通常由祭司与阿比索信徒佩戴，也会被船长当作幸运护身符。"
	sellprice = 220
	salvage_result = /obj/item/pearl/blue
	salvage_amount = 3 // Pearls are easy to cut off from an amulet

/obj/item/clothing/neck/roguetown/psicross/shell
	name = "牡蛎贝壳项链"
	icon_state = "oyster_necklace"
	desc = "一串由海贝穿成的项链，它们相互碰撞时发出的平静声响，让人联想到甲壳类挥动的螯肢。它提醒着你，尽管人类早已不再生活于水中，阿比索却始终记得我们的起源。"
	sellprice = 25
	salvage_result = /obj/item/oystershell
	salvage_amount = 5

/obj/item/clothing/neck/roguetown/psicross/shell/bracelet
	name = "贝壳手环"
	icon_state = "oyster_bracelet"
	desc = "一只由海贝串成的手环，粗糙的外壳与光亮的内里提醒着你，阿比索的子嗣总会把最好的馈赠藏在海浪之下最深的地方。"
	sellprice = 15
	slot_flags = ITEM_SLOT_WRISTS
	salvage_result = /obj/item/oystershell
	salvage_amount = 3

/obj/item/clothing/neck/roguetown/talkstone
	name = "话石"
	desc = "在寂静时分，它会轻声低语，仿佛正试图解读沉默本身。"
	icon_state = "talkstone"
	item_state = "talkstone"
	dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	allowed_race = CLOTHED_RACES_TYPES
	sellprice = 70
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/neck/roguetown/horus
	name = "鉴价护符"
	desc = "一枚嵌着完美眼眸的护符。它对万物都视而不见，唯独看得到金光闪耀之物。"
	icon_state = "horus"
	dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 80
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/neck/roguetown/horus/examine()
	. = ..()
	. += span_info("点击地面或物品即可查看其价值，别点桌子。")

/obj/item/clothing/neck/roguetown/horus/afterattack(atom/A, mob/user, params)
	. = ..()
	var/total_sellprice = 0
	if(isturf(A))
		for(var/obj/item/I in A.contents)
			total_sellprice += I.sellprice
		to_chat(user, span_notice("地上的所有东西一共值 [total_sellprice] 枚马蒙。"))
	else if(istype(A, /obj/item))
		var/obj/item/I = A
		total_sellprice += I.sellprice
		for(var/obj/item/item in I.contents)
			total_sellprice += item.sellprice
		to_chat(user, span_notice("该物品及其内容物一共值 [total_sellprice] 枚马蒙。"))

/obj/item/clothing/neck/roguetown/shalal
	name = "沙漠骑手徽章"
	desc = "以赞拜廷佣兵第一次军饷中的银子铸成。这些受雇刀兵之间保留着一项传统：把它送给某人，就象征自己欠了对方一份人情，而在需要之时，任何其他佣兵都应替其偿还。"
	icon_state = "shalal"
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS|ITEM_SLOT_RING		//Hey I guess you could pretend it is wrapped around your hand? Just keep it on, don't be a hoe.
	dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 30		// what if the economy crashes...........
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/neck/roguetown/ornateamulet
	name = "华美护符"
	desc = "一枚由纯金打造而成的美丽护符。"
	icon_state = "ornateamulet"
	dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 100
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/neck/roguetown/ornateamulet/noble
	var/choicename = FALSE
	name = "传家护符"
	desc = "一枚代表显赫贵族家族的华美护符。"
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_WRISTS|ITEM_SLOT_HIP
	sellprice = 10

/obj/item/clothing/neck/roguetown/ornateamulet/noble/attack_right(mob/user)
	if(choicename)
		return
	var/current_time = world.time
	var/namechoice = input(user, "输入新名称", "重命名物品")
	if(namechoice)
		name = namechoice
		choicename = TRUE
	else
		return
	if(world.time > (current_time + 30 SECONDS))
		return

/obj/item/clothing/neck/roguetown/skullamulet
	name = "骷髅护符"
	desc = "黄金被塑造成骷髅的模样，再串成一枚护符。"
	icon_state = "skullamulet"
	dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 100
	anvilrepair = /datum/skill/craft/armorsmithing
	nudist_approved = TRUE

/obj/item/clothing/neck/roguetown/psicross/naledi
	name = "纳莱迪教十字手环"
	desc = "一件来自异乡的奇特信仰圣徽。它以圆环构成三叉的普希顿教十字，体现着纳莱迪人对普希顿永恒不灭的信念。"
	icon_state = "psybracelet"
	item_state = null

/obj/item/clothing/neck/roguetown/collar
	name = "项圈"
	icon = 'modular/icons/obj/leashes_collars.dmi'
	mob_overlay_icon = 'modular/icons/mob/collars_leashes.dmi'
	desc = "这是一个调试用父物品。如果你看到了它，请去朝程序员喵一声。"
	icon_state = "collar_rope"
	item_state = "collar_rope"
	resistance_flags = FIRE_PROOF
	dropshrink = 0.6
	leashable = TRUE
	bellsound = FALSE
	bell = FALSE
	salvage_result = null
	nudist_approved = TRUE

/obj/item/clothing/neck/roguetown/collar/leather
	name = "皮革颈圈"
	desc = "一条结实的皮革项圈。"
	icon = 'modular/icons/obj/leashes_collars.dmi'
	mob_overlay_icon = 'modular/icons/mob/collars_leashes.dmi'
	icon_state = "leathercollar"
	item_state = "leathercollar"
	leashable = TRUE
	resistance_flags = FIRE_PROOF
	bellsound = FALSE
	bell = FALSE

/obj/item/clothing/neck/roguetown/collar/cowbell
	name = "牛铃颈圈"
	desc = "一只皮革颈圈，上面挂着叮当作响的牛铃。"
	icon = 'modular/icons/obj/leashes_collars.dmi'
	mob_overlay_icon = 'modular/icons/mob/collars_leashes.dmi'
	icon_state = "cowbellcollar"
	item_state = "cowbellcollar"
	leashable = TRUE
	resistance_flags = FIRE_PROOF
	bellsound = TRUE

/obj/item/clothing/neck/roguetown/collar/cowbell/Initialize(mapload)
		. = ..()
		AddComponent(/datum/component/squeak, SFX_CBJINGLE, 50, 100, 1) //We want squeak so wearer jingles if touched while wearing collar

/obj/item/clothing/neck/roguetown/collar/catbell
	name = "猫铃颈圈"
	desc = "一只皮革颈圈，上面挂着叮铃作响的猫铃。"
	icon = 'modular/icons/obj/leashes_collars.dmi'
	mob_overlay_icon = 'modular/icons/mob/collars_leashes.dmi'
	icon_state = "catbellcollar"
	item_state = "catbellcollar"
	leashable = TRUE
	resistance_flags = FIRE_PROOF
	bellsound = TRUE

/obj/item/clothing/neck/roguetown/collar/catbell/Initialize(mapload)
		. = ..()
		AddComponent(/datum/component/squeak, SFX_COLLARJINGLE, 50, 100, 1) //We want squeak so wearer jingles if touched while wearing collar

/obj/item/clothing/neck/roguetown/collar/feldcollar
	name = "田工颈圈"
	icon = 'icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/neck.dmi'
	desc = "一条结实的皮革项圈，常由田间劳作的人佩戴。"
	icon_state = "feldcollar"
	item_state = "feldcollar"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_MASK
	body_parts_covered = NECK|FACE
	nudist_approved = TRUE

/obj/item/clothing/neck/roguetown/collar/surgcollar
	name = "医用颈圈"
	icon = 'icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/neck.dmi'
	desc = "一条为医疗从业者设计的专用项圈，带有加固衬垫。"
	icon_state = "surgcollar"
	item_state = "surgcollar"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_MASK
	body_parts_covered = NECK|FACE
	nudist_approved = TRUE

/obj/item/clothing/neck/roguetown/luckcharm
	name = "幸运护符"
	desc = "一条兔猫脚项链。有人说它会带来好运，而把它挂在脖子上时，这份好运似乎更灵验。"
	icon_state = "luckcharm"
	sellprice = 15
	possible_item_intents = list(/datum/intent/use, /datum/intent/special/magicarc)
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	grid_width = 32
	grid_height = 32
	var/goodluckactivated = FALSE
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 1
	nudist_approved = TRUE

/obj/item/clothing/neck/roguetown/luckcharm/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_NECK)
		user.change_stat(STATKEY_LCK, 1) //how much luck stat it gives when equipped
		goodluckactivated = TRUE
	return

/obj/item/clothing/neck/roguetown/luckcharm/dropped(mob/living/carbon/human/user)
	. = ..()
	if(goodluckactivated == TRUE)
		user.change_stat(STATKEY_LCK, -1) //how much luck stat taken away when unequipped
		goodluckactivated = FALSE
	return

/obj/item/clothing/neck/roguetown/skullamulet/gemerald
	name = "绿宝石骷髅护符"
	desc = "一块巨大的绿宝石被精细雕琢成骷髅，并固定在链条上。</br>它是在嘲笑我，对吧？"
	slot_flags = ITEM_SLOT_NECK
	icon_state = "skullamulet"
	color = "#00FF00"
	resistance_flags = FIRE_PROOF
	sellprice = 222
	smeltresult = /obj/item/roguegem/green

//

/obj/item/clothing/neck/roguetown/psicross/malum/secret
	name = "谜痕护符"
	desc = "一条熟悉的项链，触手灼热得惊人。然而无论它有多烫，金属都不会灼伤我的皮肉。</br>它低语着神启；我敢把它戴上吗？"
	icon_state = "malum"
	sellprice = 333
	edelay_type = 1
	equip_delay_self = 33
	smeltresult = /obj/item/riddleofsteel
	var/active_item

/obj/item/clothing/neck/roguetown/psicross/malum/secret/Initialize(mapload)
	..()
	filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,2),rand(127,128),rand(254,255)))

/obj/item/clothing/neck/roguetown/psicross/malum/secret/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_NECK)
		active_item = TRUE
		to_chat(user, span_hypnophrase("……暖意流过我的血脉，而我却并未灼伤；恰恰相反，我的头脑比以往任何时候都更清明……</br>……发光的符文自我眼前掠过，渐渐解译为熔炉中最伟大的秘密……</br>'黑钢与黄金，萨菲拉与布洛兹，以白银教十字束缚，方能催发龙之怒火。'</br>'四枚附魔戒指，以白银相系。绿宝石、缟玛瑙、阿密索兹、龙红石，合而为一，即为全能。'</br>'五块白银锭，龙戒残片与泣血教十字，一截巨木，以及这枚护符中所蕴之物；足以诛灭维斯林的恶魔。'"))
		user.change_stat(STATKEY_INT, 3)
		user.change_stat(STATKEY_LCK, 3)
		user.change_stat(STATKEY_STR, -3)
		ADD_TRAIT(user, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
		ADD_TRAIT(user, TRAIT_FORGEBLESSED, TRAIT_GENERIC)
	return

/obj/item/clothing/neck/roguetown/psicross/malum/secret/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_monkeyhive("……那些符文化作难以分辨的污痕，随后再次消散回这个世界。就在那一瞬间，你几乎忘了掌心中灼烧般的热度……</br>……也许，这东西更适合被放进炽热闷烧的熔炉里……"))
		user.change_stat(STATKEY_INT, -3)
		user.change_stat(STATKEY_LCK, -3)
		user.change_stat(STATKEY_STR, 3)
		REMOVE_TRAIT(user, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_FORGEBLESSED, TRAIT_GENERIC)
		active_item = FALSE
	return

//

/obj/item/clothing/neck/roguetown/psicross/weeping
	name = "泣血教十字"
	desc = "'让祂的名字就此被遗忘吧。'</br>这种合金很熟悉，却又不可言说。鲜血自教十字内部的裂缝中渗出，永远停留在半凝固的状态。致命的寒意扯住你的脖颈，你的脸颊也湿漉漉的，那是眼泪吗？"
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_WRISTS
	icon_state = "psicrossblood"
	max_integrity = 666
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	edelay_type = 1
	equip_delay_self = 66
	smeltresult = /obj/item/ingot/weeping
	sellprice = 666
	var/active_item

/obj/item/clothing/neck/roguetown/psicross/weeping/Initialize(mapload)
	..()
	filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(254,255),rand(1,2),rand(1,2)))

/obj/item/clothing/neck/roguetown/psicross/weeping/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_NECK)
		active_item = TRUE
		to_chat(user, span_red("当你戴上这枚教十字时，锁链如铁钳般骤然勒紧你的脖颈！可怕的痛苦感将你彻底吞没，仿佛人类的一切苦难都被强塞进了你的灵魂！你的胸口冰冷彻骨，血液却沸腾得比熔岩更炽热！普西多尼亚的恶徒或许残暴无情，但你将比他们更甚！</br>你陷入狂暴了！"))
		user.change_stat(STATKEY_STR, 3)
		user.change_stat(STATKEY_CON, -3)
		user.change_stat(STATKEY_WIL, 3)
		ADD_TRAIT(user, TRAIT_PSYCHOSIS, TRAIT_GENERIC) //Imitates the fact that you are, in fact, going bonkers.
		ADD_TRAIT(user, TRAIT_NOCSHADES, TRAIT_GENERIC) //Roughly ~30% reduced vision with a sharp red overlay. Provides night vision in the visible tiles.
		ADD_TRAIT(user, TRAIT_DNR, TRAIT_GENERIC) //If you die while the necklace's on, that's it. Technically saveable if someone knows to remove the necklace, before attempting resurrection.
		ADD_TRAIT(user, TRAIT_STRONGKICK, TRAIT_GENERIC)
		ADD_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
	return

/obj/item/clothing/neck/roguetown/psicross/weeping/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_monkeyhive("……转瞬之间，那股狂乱便退去了。熟悉的暖意重新爬回你的胸口。尽管你的神志已经清明，那个念头却仍挥之不去：方才真只是某种不适，还是别的什么？</br>……也许，这东西更适合被放进炽热闷烧的熔炉里……"))
		user.change_stat(STATKEY_STR, -3)
		user.change_stat(STATKEY_CON, 3)
		user.change_stat(STATKEY_WIL, -3)
		REMOVE_TRAIT(user, TRAIT_PSYCHOSIS, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_NOCSHADES, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_DNR, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_STRONGKICK, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
		active_item = FALSE
	return

/obj/item/clothing/neck/roguetown/collar/prisoner
	name = "卡斯提菲科项圈"
	icon_state = "castifico_collar"
	item_state = "castifico_collar"
	desc = "一只会锁死在脖子上的金属项圈，几乎不可能自行摘下。它似乎被某种邪恶魔法附了咒……"
	var/active_item
	var/bounty_amount
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NONE //it's not armor
	leashable = TRUE

/obj/item/clothing/neck/roguetown/collar/prisoner/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/neck/roguetown/collar/prisoner/dropped(mob/living/carbon/human/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_PACIFISM, "castificocollar")
	REMOVE_TRAIT(user, TRAIT_SPELLCOCKBLOCK, "castificocollar")
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/neck/roguetown/collar/prisoner/proc/timerup(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_PACIFISM, "castificocollar")
	REMOVE_TRAIT(user, TRAIT_SPELLCOCKBLOCK, "castificocollar")
	visible_message(span_warning("卡斯提菲科项圈咔哒一声打开，从[user]颈上脱落，摔在地上四散开来，他们的赎罪结束了。"))
	say("你的赎罪已经完成。")
	for(var/name in GLOB.outlawed_players)
		if(user.real_name == name)
			GLOB.outlawed_players -= user.real_name
			priority_announce("[user.real_name] 已完成其赎罪。在拉沃克斯之眼中，正义已然得伸。", "赎罪", 'sound/misc/bell.ogg')
	playsound(src.loc, pick('sound/items/pickgood1.ogg','sound/items/pickgood2.ogg'), 5, TRUE)
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/neck/roguetown/collar/prisoner/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_NECK)
		active_item = TRUE
		to_chat(user, span_warning("这条受诅咒的项圈让我失去了反抗之意！"))
		ADD_TRAIT(user, TRAIT_PACIFISM, "castificocollar")
		ADD_TRAIT(user, TRAIT_SPELLCOCKBLOCK, "castificocollar")
		if(HAS_TRAIT(user, TRAIT_RITUALIST))
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
		var/timer = 5 MINUTES //Base timer is 5 minutes, additional time added per bounty amount

		if(bounty_amount >= 10)
			var/additional_time = bounty_amount * 0.1 // 10 mammon = 1 minute
			additional_time = round(additional_time)
			timer += additional_time MINUTES

		var/timer_minutes = timer / 600

		addtimer(CALLBACK(src, PROC_REF(timerup), user), timer)
		say("你的赎罪将在 [timer_minutes] 分钟后完成。")
	return

/obj/item/clothing/neck/roguetown/collar/woolen
	name = "毛织颈圈"
	desc = "一条由毛料与布匹制成的厚实舒适项圈，虽然不提供防护，但确实能让你的脖子暖和起来。"
	icon_state = "woolencollar"
	item_state = "woolencollar"
	icon = 'icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/neck.dmi'
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_MOUTH
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	color = CLOTHING_BLACK
	muteinmouth = FALSE
	spitoutmouth = FALSE
	sewrepair = TRUE

//This is a super good neck slot item, granting +2LCK/Darkvision/HardDismember/NoDamageSlowdown.
//Horrible compared to +2 in all stats and the 10k durability it used to have. But you can't have it all.
//You can get these so easily that it's just dumb for them to be so absurd. Especially now with explosive bandits and the like.
//Now it self repairs as a funny kind of protection. Provides negatives to those who can't wear it, too.
/obj/item/clothing/neck/roguetown/dragon_scale
	name = "龙鳞项链"
	desc = "一条黑钢链子，串过了十余枚藏宝主的金牙。\
	它也许是赐予佩戴者的礼物，也许是在疯狂中夺来的纪念，已无关紧要。\
	只要被认定为值得之人，戴上这条项链便会得到藏宝主的恩赐。<br>\
	若是不配，那就……"
	icon_state = "bktrinket"
	max_integrity = 666
	armor = ARMOR_DRAGONSCALE
	//Provides the full array, since this isn't a +2 to literally everything stat wise now. Although armour does this anyways, I suppose.
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_PIERCE, BCLASS_PICK, BCLASS_BLUNT)
	blocksound = PLATEHIT
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 666
	static_price = TRUE
	smeltresult = /obj/item/riddleofsteel
	anvilrepair = /datum/skill/craft/armorsmithing
	var/active_item = FALSE
	var/repair_amount = 40
	var/repair_time = 2 MINUTES
	var/last_repair

/obj/item/clothing/neck/roguetown/dragon_scale/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == SLOT_NECK)
		active_item = TRUE
		if(user.mind.special_role == "Bandit")
			to_chat(user, span_suppradio("藏宝主的意志开始与我的意志交融。巨大的<b>贪欲</b>充斥着我的脑海。"))
			user.change_stat(STATKEY_LCK, 2)
			user.add_stress(/datum/stressevent/dragon_scale)
			ADD_TRAIT(user, TRAIT_DARKVISION, CULT_TRAIT)//Close enough to a cult. No duplicates beyond dreamer.
			ADD_TRAIT(user, TRAIT_HARDDISMEMBER, CULT_TRAIT)//Too angry to lose a limb, or something.
			ADD_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, CULT_TRAIT)//Can't tag 'em to slow 'em.
			armor = getArmor("blunt" = 100, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 50, "acid" = 0)
		else
			to_chat(user, span_suicide("这条项链……我听见有个声音在嘲弄我！"))
			ADD_TRAIT(user, TRAIT_PSYCHOSIS, CULT_TRAIT)
			user.hallucination = INFINITY
			armor = getArmor("blunt" = 0, "slash" = 0, "stab" = 0, "piercing" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/neck/roguetown/dragon_scale/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	if(user.mind.special_role == "Bandit")
		to_chat(user, span_monkeyhive("藏宝主对我心智的掌控减弱了。难道我还不够吗？我能感受到那份失望。"))
		user.change_stat(STATKEY_LCK, -2)
		user.remove_stress(/datum/stressevent/dragon_scale)
		REMOVE_TRAIT(user, TRAIT_DARKVISION, CULT_TRAIT)
		REMOVE_TRAIT(user, TRAIT_HARDDISMEMBER, CULT_TRAIT)
		REMOVE_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, CULT_TRAIT)
	else
		to_chat(user, span_suicide("<b>把它从我身边拿开！！</b>"))
		REMOVE_TRAIT(user, TRAIT_PSYCHOSIS, CULT_TRAIT)
		user.hallucination = 0
		armor = getArmor("blunt" = 100, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 50, "acid" = 0)

/obj/item/clothing/neck/roguetown/dragon_scale/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	. = ..()
	if(obj_integrity < max_integrity)
		START_PROCESSING(SSobj, src)
		return

/obj/item/clothing/neck/roguetown/dragon_scale/process()
	if(obj_integrity >= max_integrity)
		STOP_PROCESSING(SSobj, src)
		src.visible_message(span_notice("[src]在藏宝主的影响下修复着自己，扭曲又弯折。"), vision_distance = 1)
		return
	else if(world.time > src.last_repair + src.repair_time)
		src.last_repair = world.time
		obj_integrity = min(obj_integrity + src.repair_amount, src.max_integrity)
	..()

/obj/item/clothing/neck/roguetown/carved
	name = "雕刻护符"
	desc = "你本不该看到这个。"
	icon_state = "psycross_w"
	item_state = "psycross_w"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 0
	salvage_result = null
	smeltresult = null
	nudist_approved = TRUE
	dropshrink = 0.75

/obj/item/clothing/neck/roguetown/carved/jadeamulet
	name = "玉护符"
	desc = "一枚由玉雕成的护符。"
	icon_state = "amulet_jade"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 60

/obj/item/clothing/neck/roguetown/carved/turqamulet
	name = "天青石护符"
	desc = "一枚由天青石雕成的护符。"
	icon_state = "amulet_turq"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 85

/obj/item/clothing/neck/roguetown/carved/onyxaamulet
	name = "缟玛瑙护符"
	desc = "一枚由缟玛瑙雕成的护符。"
	icon_state = "amulet_onyxa"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 40

/obj/item/clothing/neck/roguetown/carved/coralamulet
	name = "心石护符"
	desc = "一枚由心石雕成的护符。"
	icon_state = "amulet_coral"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 70

/obj/item/clothing/neck/roguetown/carved/amberamulet
	name = "琥珀护符"
	desc = "一枚由琥珀雕成的护符。"
	icon_state = "amulet_amber"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 60

/obj/item/clothing/neck/roguetown/carved/opalamulet
	name = "欧泊护符"
	desc = "一枚由欧泊雕成的护符。"
	icon_state = "amulet_opal"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 90

/obj/item/clothing/neck/roguetown/carved/roseamulet
	name = "玫瑰石护符"
	desc = "一枚由玫瑰石雕成的护符。"
	icon_state = "amulet_rose"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 25

/obj/item/clothing/neck/roguetown/carved/shellamulet
	name = "贝壳护符"
	desc = "一枚由贝壳雕成的护符。"
	icon_state = "amulet_shell"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 25

/obj/item/clothing/neck/roguetown/carved/chitinamulet
	name = "甲壳护符"
	desc = "一枚由甲虫甲壳雕成的护符。"
	icon_state = "amulet_shell"
	color = "#7B8C5E"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 20

// AP port. 

/obj/item/clothing/neck/roguetown/psicross/inhumen/g
	name = "金色倒置教十字"
	desc = "'你可愿活得甘美纵情？死亡不过是一道镣铐；若你想挣脱它冰冷的钳握，你所要做的……不过是把信念托付于我。'"
	icon_state = "zcross_g"
	resistance_flags = FIRE_PROOF
	sellprice = 100

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
	name = "马西奥斯护符"
	desc = "他曾只是黑暗中的一簇火焰。而今，他的信众将一同燃得比暴君般的太阳更炽烈。"
	icon_state = "matthios"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS|ITEM_SLOT_RING
	smeltresult = null

/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
	name = "格拉格护符"
	desc = "鲜血只会通往荣耀，而暴力孕育神性。绝不止于此。征服，不过是胜利的另一种名字。"
	icon_state = "graggar"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS|ITEM_SLOT_RING
	smeltresult = null

/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze
	name = "青铜格拉格护符"
	desc = "'一切都会消失，连同你所爱的一切与每一个人！当最后一团火焰也被彻底掐灭之后，你还剩下什么？！'</br>‎  </br>'……你。我至少还会有你。'"
	icon_state = "graggar_b"
	item_state = "graggar_b"
	sellprice = 25

/obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
	name = "巴欧萨护符"
	desc = "一个由黄金铸成的空洞承诺。它沉甸甸地压着甜酒化作毒药的记忆，也承载着那份迟迟不肯消散的悲伤所带来的慰藉。"
	icon_state = "baotha"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS|ITEM_SLOT_RING
	smeltresult = null

/obj/item/clothing/neck/roguetown/psicross/ten
	name = "十圣护符"
	desc = "十圣永恒不灭，团结即为力量。数百年来始终坚定地对抗黑暗。"
	icon_state = "undivided"
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS|ITEM_SLOT_RING

/obj/item/clothing/neck/roguetown/psicross/silver/undivided
	name = "银十圣护符"
	desc = "白银为护，永恒为印；以十圣之名，我命你滚回地狱！"
	icon_state = "undivided_s"
	sellprice = 50
