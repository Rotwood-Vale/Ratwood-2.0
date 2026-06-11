/obj/item/clothing/gloves/roguetown/elven_gloves
	name = "染纹精灵手套"
	desc = "内里衬着柔软而活着的叶片与泥土。它们很容易吸走湿气。"
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "welfhand"
	item_state = "welfhand"
	armor = list("blunt" = 100, "slash" = 10, "stab" = 110, "piercing" = 20, "fire" = 0, "acid" = 0)//Resistant to blunt and stab, super weak to slash.
	prevent_crits = list(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PICK)
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = 200
	anvilrepair = /datum/skill/craft/carpentry
	sewrepair = FALSE
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/// Dendor ritual variant of the woad elven gloves — grown from the Treefather's sanctified root.
/obj/item/clothing/gloves/roguetown/elven_gloves/druidic
	name = "受祝德鲁伊手套"
	desc = "由受树父祝福滋养的根须编织而成的护手。活木能吸收冲击，并减轻本会撕裂血肉的劈砍。"
	armor = list("blunt" = 100, "slash" = 65, "stab" = 130, "piercing" = 20, "fire" = 0, "acid" = 0)

/obj/item/clothing/gloves/roguetown/elven_gloves/druidic/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("druid_blessed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/clothing/gloves/roguetown/elven_gloves/druidic/pickup(mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.patron?.type == /datum/patron/divine/dendor)
		return
	H.electrocute_act(30, src)
	H.mob_timers["kneestinger"] = world.time
	to_chat(H, span_warning("[name] 拒绝了我的握持，唯有树父的信徒才配承受这份恩赐！"))

/obj/item/clothing/gloves/roguetown/bandages
	name = "缠手绷带"
	desc = "厚织绷带缠在双手上。它会吸收掌心汗水、强化你的拳头，并保护指关节不被打飞的牙齿割伤。"
	sleeved = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon = 'icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon_state = "clothwraps"
	item_state = "clothwraps"
	armor = ARMOR_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT)
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
	nudist_approved = TRUE
	salvage_result = /obj/item/natural/cloth
	unarmed_bonus = 1.125 //Sublight armor with minimal durability, but a greater unarmed damage multiplier. More damage than leather, less than maille. Loadout-selectable.
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/bandages/weighted
	name = "配重缠手"
	desc = "厚织绷带缠在双手上，并配有加垫指节配重。它会吸收掌心汗水、强化你的拳头，并保护指关节不被打飞的牙齿割伤。"
	unarmed_bonus = 1.225 //Craftable. Given to non-specialized Monks and other certain subclasses. Provides a +25% unarmed damage bonus over plate gauntlets.

/obj/item/clothing/gloves/roguetown/bandages/pugilist
	name = "搏击缠手"
	desc = "厚织绷带缠在双手上，并配有合金指节配重。它会吸收掌心汗水、强化你的拳头，并保护指关节不被打飞的牙齿割伤。"
	unarmed_bonus = 1.3 //Non-craftable. Restricted to Monks who've specialized in unarmed combat, and nothing else.
