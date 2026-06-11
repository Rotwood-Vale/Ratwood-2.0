// Because no one fucking know about inheritance in this bleak codebase.
/obj/item/clothing/gloves/roguetown/leather
	name = "皮手套"
	desc = "由结实皮革制成的手套。几乎没什么防护，但总比没有强。"
	icon_state = "leather_gloves"
	armor = ARMOR_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT)
	max_integrity = ARMOR_INT_SIDE_LEATHER
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	unarmed_bonus = 1.1
	color = "#66584c"
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/leather/black
	color = CLOTHING_BLACK

/obj/item/clothing/gloves/roguetown/fingerless
	name = "露指手套"
	desc = "能吸收掌心汗水的布手套，同时让手指保持自由，便于精细操作。"
	icon_state = "fingerless_gloves"
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	nudist_approved = TRUE

/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves
	name = "露指手套"
	desc = "能吸收掌心汗水的布手套，同时让手指保持自由，便于精细操作。"
	icon_state = "shadowgloves"
	allowed_race = NON_DWARVEN_RACE_TYPES
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	name = "露指手套"
	desc = "能吸收掌心汗水的布手套，同时让手指保持自由，便于精细操作。"
	icon_state = "shadowgloves"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/gloves/roguetown/fingerless_leather
	name = "露指皮手套"
	desc = "一副深受锁匠、劳工和烟民喜爱的防护手套，用来在 \
	比普通手套更好地保留手部灵活性。"
	icon_state = "roguegloves"
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT)
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_CLOTH
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/gloves/roguetown/otavan
	name = "奥塔凡皮手套"
	desc = "一副沉重的奥塔凡皮手套，常为击剑手所用，以品质著称。"
	icon_state = "fencergloves"
	item_state = "fencergloves"
	armor = ARMOR_MAILLE
	prevent_crits = list(BCLASS_CHOP, BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	allowed_race = NON_DWARVEN_RACE_TYPES
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/otavan/inqgloves
	name = "宗审庭皮手套"
	desc = "大师级工艺的皮手套，以轻薄锁甲层加固。左手袖口垂着一串小念珠，温柔提醒着即便是宗审官也受祂权威约束。"
	icon_state = "inqgloves"
	item_state = "inqgloves"
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/gloves/roguetown/otavan/psygloves
	name = "赛顿皮手套"
	desc = "厚实的皮质连指手套，缝线严密、袖口收束，以保护祂子民的手掌不被刺穿。"
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST) //Equivalent to Heavy Leather Gloves. Deinherits the durability and exclusive critprot of Otavan gloves.
	icon_state = "psydongloves"
	item_state = "psydongloves"
	salvage_result = /obj/item/natural/hide/cured
	allowed_race = ALL_RACES_TYPES

// Eastern gloves
/obj/item/clothing/gloves/roguetown/eastgloves1
	name = "黑手套"
	desc = "剑士常用的利落手套。"
	icon_state = "eastgloves1"
	item_state = "eastgloves1"
	armor = ARMOR_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	resistance_flags = null
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

/obj/item/clothing/gloves/roguetown/eastgloves2
	name = "时髦手套"
	desc = "异乡帮派常戴的奇特手套。"
	icon_state = "eastgloves2"
	item_state = "eastgloves2"
	armor = ARMOR_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	resistance_flags = null
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

/obj/item/clothing/gloves/roguetown/leather/horsey
	name = "手臂束具"
	desc = "用于双臂的加固皮革绑带。"
	icon_state = "harms"
	item_state = "harms"
	slot_flags = ITEM_SLOT_GLOVES|ITEM_SLOT_HANDS
	body_parts_covered = HANDS|ARMS
	// sleeved = FALSE
	color = null
