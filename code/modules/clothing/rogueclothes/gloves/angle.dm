/obj/item/clothing/gloves/roguetown/angle
	name = "重型皮手套"
	desc = "一副更厚重、额外加垫的皮手套。看起来很能挨打。近战防护尚可，耐用度也不错。"
	icon_state = "angle"
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	sellprice = 12
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
	salvage_result = /obj/item/natural/fur
	color = "#4d4d4d"
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	name = "格伦泽尔霍夫手套"
	desc = "格伦泽尔霍夫风格的华贵手套，与其说是防具，不如说是时尚宣言。"
	icon_state = "grenzelgloves"
	item_state = "grenzelgloves"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	color = "#ffffff"

/obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	name = "炉匠护手"
	color = "#ffffff"
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = 600 

/obj/item/clothing/gloves/roguetown/angle/pontifex
	name = "符文缠手"
	desc = "以纸与布缠成的绷带，上面写满强大的纳雷迪符文。它们足以在战斗中好好保护佩戴者的双手。"
	icon_state = "clothwraps"
	item_state = "clothwraps"
	color = "#ffffff"
