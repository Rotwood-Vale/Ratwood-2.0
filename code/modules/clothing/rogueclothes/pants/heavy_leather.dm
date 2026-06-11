/obj/item/clothing/under/roguetown/heavy_leather_pants
	name = "硬化皮裤"
	desc = "厚实兽皮裁切缝成一条防护力极强的长裤。致密皮革足以\
	挡开偏斜而来的劈砍。"
	gender = PLURAL
	icon_state = "roguepants"
	item_state = "roguepants"
	sewrepair = TRUE
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	armor = ARMOR_LEATHER_GOOD
	sellprice = 18
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_LEG_HARDLEATHER
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	resistance_flags = FIRE_PROOF
	armor_class = ARMOR_CLASS_LIGHT
	salvage_result = /obj/item/natural/hide/cured
	cold_protection = LEG_RIGHT | LEG_LEFT | GROIN
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	name = "硬化皮短裤"
	desc = "一条由厚皮制成的短裤，虽然不如长裤防护周全，却因行动便利而受到一些人喜爱。"
	icon_state = "rogueshorts"
	item_state = "rogueshorts"
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	body_parts_covered = GROIN
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	cold_protection = GROIN

/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	name = "Otava皮裤"
	desc = "由Otava裁缝制成的带垫皮甲长裤，品质十分出众。"
	icon_state = "fencerpants"
	cold_protection = GROIN | LEG_RIGHT | LEG_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	name = "击剑马裤"
	desc = "一条宽松马裤，在腰部与腿部做了皮革加固，并配有护裆。"
	icon_state = "fencingbreeches"
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#5E4440"
	allowed_race = NON_DWARVEN_RACE_TYPES
	heat_protection = GROIN | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = 600

/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic/Initialize(mapload)
	..()
	update_icon()

/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	name = "Grenzelhoft绗缝裤"
	desc = "带垫长裤，提供额外舒适与防护，并装点着鲜亮色彩。"
	icon_state = "grenzelpants"
	item_state = "grenzelpants"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	detail_tag = "_detail"
	var/picked = FALSE
	armor_class = ARMOR_CLASS_LIGHT
	color = "#262927"
	detail_color = "#FFFFFF"
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	cold_protection = GROIN | LEG_RIGHT | LEG_LEFT
	min_cold_protection_temperature = 50

/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "选择一种颜色。", "格伦泽尔霍夫配色") as anything in GLOB.colorlist
		var/playerchoice = GLOB.colorlist[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_pants()

/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
	name = "割喉客长裤"
	desc = "带有内缝皮革的异域长裤。"
	icon_state = "eastpants1"
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	name = "古怪破裤"
	desc = "Kazengun穷苦人常穿的古怪裤子。或者，是想借此张扬时尚态度的人。"
	icon_state = "eastpants2"
	allowed_race = NON_DWARVEN_RACE_TYPES

//Gronn
/obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
	name = "游牧长裤"
	desc = "穿在草原服饰内侧的贴身皮裤。"
	icon_state = "nomadpants"
	max_integrity = ARMOR_INT_LEG_HARDLEATHER
	armor = ARMOR_LEATHER
	cold_protection = GROIN | LEG_RIGHT | LEG_LEFT
	min_cold_protection_temperature = 50
	dropshrink = null

/obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun //no, not 'eastpants3', silly!
	name = "衬甲长裤"
	desc = "Kazengun农民常穿的一种长裤。所用布料相当结实，大概能挡下几记攻击。"
	icon_state = "baggypants"
	item_state = "baggypants"
	heat_protection = GROIN | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants
	name = "丝质紧身裤"
	desc = "贴身的腿部衣物，几乎贴得有些过头。"
	icon_state = "shadowpants"
	allowed_race = NON_DWARVEN_RACE_TYPES
	heat_protection = GROIN | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = 600

/obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt
	name = "青铜锁甲裙"
	desc = "一件及膝锁甲裙，由数百枚小型青铜环打造而成。它能保护大腿免受斩击，却不会拖慢步伐。"
	icon_state = "chain_skirt"
	item_state = "chain_skirt"
	color = "#f9d690"
	blocksound = CHAINHIT
	resistance_flags = FIRE_PROOF
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/bronze //Reskinned version of the Barbarian's heavy leather trousers. 1:1 functionality, but without the ability to sew-repair.
	cold_protection = null
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	dropshrink = null
