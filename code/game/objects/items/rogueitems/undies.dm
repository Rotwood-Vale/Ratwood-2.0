/obj/item/undies
	name = "短裤"
	desc = "绝对必需品。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "briefs"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	blade_dulling = DULLING_CUT
	max_integrity = 200
	integrity_failure = 0.1
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	slot_flags = ITEM_SLOT_MOUTH
	var/gendered
	var/race
	var/datum/bodypart_feature/underwear/undies_feature
	var/covers_breasts = FALSE
	sewrepair = TRUE
	var/covers_rear = TRUE
	grid_height = 32
	grid_width = 32
	throw_speed = 0.5
	var/sprite_acc = /datum/sprite_accessory/underwear/briefs

/obj/item/undies/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.underwear)
			if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
				return
			if(!undies_feature)
				var/datum/bodypart_feature/underwear/undies_new = new /datum/bodypart_feature/underwear()
				undies_new.set_accessory_type(sprite_acc, color, H)
				undies_feature = undies_new
			user.visible_message(span_notice("[user]试图把[src]给[H]穿上……"))
			if(do_after(user, 50, needhand = 1, target = H))
				var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
				chest.add_bodypart_feature(undies_feature)
				user.dropItemToGround(src)
				forceMove(H)
				H.underwear = src
				undies_feature.accessory_colors = color

/obj/item/undies/Destroy()
	undies_feature = null
	return ..()

/obj/item/undies/bikini
	name = "比基尼"
	icon_state = "bikini"
	covers_breasts = TRUE
	sprite_acc = /datum/sprite_accessory/underwear/bikini

/obj/item/undies/panties
	name = "内裤"
	icon_state = "panties"
	sprite_acc = /datum/sprite_accessory/underwear/panties

/obj/item/undies/leotard
	name = "紧身衣"
	icon_state = "leotard"
	covers_breasts = TRUE
	sprite_acc = /datum/sprite_accessory/underwear/leotard

/obj/item/undies/athletic_leotard
	name = "运动紧身衣"
	icon_state = "athletic_leotard"
	covers_breasts = TRUE
	sprite_acc = /datum/sprite_accessory/underwear/athletic_leotard

/obj/item/undies/braies
	name = "亚麻衬裤"
	desc = "一条亚麻内裤；赛多尼亚最常见的款式。"
	icon_state = "braies"
	sprite_acc = /datum/sprite_accessory/underwear/braies

/obj/item/undies/loinclothunder
	name = "小号缠裆布"
	desc = "一条调到如内衣般贴身的紧致缠裆布，适合喜欢透风的人。"
	icon_state = "loinclothunder"
	covers_rear = FALSE

// Craft

/datum/crafting_recipe/roguetown/sewing/loinclothunder
	name = "小号缠裆布（1布）"
	result = list(/obj/item/undies/loinclothunder)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/loinclothadjusttwo
	name = "把小号缠裆布改松（裤装）"
	result = list(/obj/item/clothing/under/roguetown/loincloth)
	reqs = list(/obj/item/undies/loinclothunder = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/undies
	name = "短裤（1纤维，1布）"
	result = list(/obj/item/undies)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/bikini
	name = "比基尼（1纤维，2布）"
	result = list(/obj/item/undies/bikini)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/panties
	name = "内裤（1布）"
	result = list(/obj/item/undies/panties)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/leotard
	name = "紧身衣（1纤维，1丝绸）"
	result = list(/obj/item/undies/leotard)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/athletic_leotard
	name = "运动紧身衣（1纤维，1丝绸）"
	result = list(/obj/item/undies/athletic_leotard)
	reqs = list(/obj/item/natural/silk = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/braies
	name = "亚麻衬裤（1布）"
	result = list(/obj/item/undies/braies)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2
