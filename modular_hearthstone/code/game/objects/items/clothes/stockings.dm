/obj/item/legwears
	name = "长袜（内穿）"
	desc = "纯为美观而制的腿部衣物，在宫廷和妓院里都很流行。"
	icon = 'modular_hearthstone/icons/obj/items/clothes/stockings.dmi'
	icon_state = "stockings"
	slot_flags = ITEM_SLOT_MOUTH
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	obj_flags = CAN_BE_HIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	blade_dulling = DULLING_CUT
	max_integrity = 200
	integrity_failure = 0.1
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	dropshrink = 0.8
	var/gendered
	var/race
	var/datum/bodypart_feature/legwear/legwears_feature
	var/covers_breasts = FALSE
	sewrepair = TRUE
	salvage_result = /obj/item/natural/cloth
	throw_speed = 0.5
	var/sprite_acc = /datum/sprite_accessory/legwear/stockings

/obj/item/legwears/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.legwear_socks)
			if(!get_location_accessible(H, BODY_ZONE_PRECISE_L_FOOT))
				return
			if(!get_location_accessible(H, BODY_ZONE_PRECISE_R_FOOT))
				return
			if(!legwears_feature)
				var/datum/bodypart_feature/legwear/legwear_new = new /datum/bodypart_feature/legwear()
				legwear_new.set_accessory_type(sprite_acc, color, H)
				legwears_feature = legwear_new
			user.visible_message(span_notice("[user]试着给[H]穿上[src]……"))
			if(do_after(user, 50, needhand = 1, target = H))
				var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
				user.dropItemToGround(src)
				forceMove(H)
				H.legwear_socks = src
				legwears_feature.accessory_colors = color
				chest.add_bodypart_feature(legwears_feature)

/obj/item/legwears/Destroy()
	legwears_feature = null
	return ..()

/obj/item/legwears/random/Initialize(mapload)
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/legwears/white
	color = "#e6e5e5"

/obj/item/legwears/black
	color = CLOTHING_BLACK

/obj/item/legwears/blue
	color = CLOTHING_BLUE

/obj/item/legwears/red
	color = "#6F0000"

/obj/item/legwears/purple
	color = "#664357"

//Silk variants

/obj/item/legwears/silk
	name = "丝绸长袜"
	desc = "纯为美观而制的腿部衣物。以轻薄丝绸制成，深受贵族喜爱。"
	icon_state = "silk"

/obj/item/legwears/silk/random/Initialize(mapload)
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/legwears/silk/white
	color = "#e6e5e5"

/obj/item/legwears/silk/black
	color = CLOTHING_BLACK

/obj/item/legwears/silk/blue
	color = CLOTHING_BLUE

/obj/item/legwears/silk/red
	color = "#6F0000"

/obj/item/legwears/silk/purple
	color = "#664357"

//Fishnets

/obj/item/legwears/fishnet
	name = "网袜"
	desc = "一种在风尘女子中颇受欢迎的腿部衣物。"
	icon_state = "fishnet"

/obj/item/legwears/fishnet/random/Initialize(mapload)
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/legwears/fishnet/white
	color = "#e6e5e5"

/obj/item/legwears/fishnet/black
	color = CLOTHING_BLACK

/obj/item/legwears/fishnet/blue
	color = CLOTHING_BLUE

/obj/item/legwears/fishnet/red
	color = "#6F0000"

/obj/item/legwears/fishnet/purple
	color = "#664357"

/obj/item/legwears/thigh_high
	name = "过膝长袜"
	desc = "一种在打算前往寒冷地区的人群中颇受欢迎的腿部衣物。"
	icon_state = "thigh"

/obj/item/legwears/thigh_high/random/Initialize(mapload)
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/legwears/thigh_high/white
	color = "#e6e5e5"

/obj/item/legwears/knee_high
	name = "及膝长袜"
	desc = "一种在偏爱高筒靴的人群中颇受欢迎的腿部衣物。"
	icon_state = "knee"

/obj/item/legwears/knee_high/random/Initialize(mapload)
	. = ..()
	color = pick("#e6e5e5", CLOTHING_BLACK, CLOTHING_BLUE, "#6F0000", "#664357")

/obj/item/legwears/knee_high/white
	color = "#e6e5e5"

// Supply

/datum/supply_pack/rogue/wardrobe/suits/stockings_white //just paint them yourself ffs
	name = "白色长袜"
	cost = 10
	contains = list(
					/obj/item/legwears/white,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_thigh_white
	name = "白色过膝长袜"
	cost = 10
	contains = list(
					/obj/item/legwears/thigh_high/white,
				)

/datum/supply_pack/rogue/wardrobe/suits/stockings_knee_white
	name = "白色及膝长袜"
	cost = 10
	contains = list(
					/obj/item/legwears/knee_high/white,
				)

//Silk

/datum/supply_pack/rogue/wardrobe/suits/stockings_white_silk
	name = "白色丝绸长袜"
	cost = 30
	contains = list(
					/obj/item/legwears/silk/white,
				)

//Fishnets

/datum/supply_pack/rogue/wardrobe/suits/stockings_white_fishnet
	name = "白色网袜"
	cost = 5
	contains = list(
					/obj/item/legwears/fishnet/white,
				)

// Craft

/datum/crafting_recipe/roguetown/sewing/stockings_white
	name = "长袜（1纤维，1布料）"
	result = list(/obj/item/legwears/white)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stockings_thigh_white
	name = "长袜-过膝（1纤维，1布料）"
	result = list(/obj/item/legwears/thigh_high/white)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stockings_knee_white
	name = "长袜-及膝（1纤维，1布料）"
	result = list(/obj/item/legwears/knee_high)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stockings_white_silk
	name = "丝绸长袜（1纤维，1丝绸）"
	result = list(/obj/item/legwears/silk/white)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/stockings_white_fishnet
	name = "网袜（2纤维）"
	result = list(/obj/item/legwears/fishnet/white)
	reqs = list(/obj/item/natural/fibers = 2)
	craftdiff = 3
