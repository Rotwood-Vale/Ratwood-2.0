/obj/item/perfume
	name = "香水瓶"
	desc = "一瓶闻起来令人愉悦的香氛。"
	icon = 'icons/roguetown/items/perfume.dmi'
	icon_state = "perfume-bottle-empty"

	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	resistance_flags = FLAMMABLE // Let it be burnt to be disposed
	dropshrink = 0.6

	/// What fragrance is the perfume
	var/datum/pollutant/fragrance/fragrance_type
	/// How many uses remaining has it got
	var/uses_remaining = 10

/obj/item/perfume/Initialize(mapload)
	. = ..()
	if(!fragrance_type)
		uses_remaining = 0
	update_icon()

/obj/item/perfume/pickup()
	. = ..()
	update_icon()

/obj/item/perfume/update_icon()
	. = ..()
	var/mutable_appearance/perfume_overlay = mutable_appearance(icon, "perfume-bottle-overlay")
	if(!uses_remaining)
		underlays.Cut()
	else
		perfume_overlay.color = fragrance_type.color
		underlays.Add(perfume_overlay)

/obj/item/perfume/examine(mob/user)
	. = ..()
	if(uses_remaining)
		. += "还剩[uses_remaining]次使用。"
	else
		. += "里面空了。"

/obj/item/perfume/afterattack(atom/target, mob/user)
	. = ..()
	if(.)
		return
	if(!ismovable(target))
		return
	if(!uses_remaining)
		to_chat(user, span_warning("[src]已经空了！"))
		update_icon()
		return

	uses_remaining--
	update_icon()
	if(target == user)
		user.visible_message(span_notice("[user]用[src]朝[user.p_them()]自己喷洒。"), span_notice("你朝自己喷洒了[src]。"))
	else
		user.visible_message(span_notice("[user]用[src]朝[target]喷洒。"), span_notice("你朝[target]喷洒了[src]。"))
	var/turf/my_turf = get_turf(user)
	my_turf.pollute_turf(fragrance_type, 20)
	user.changeNext_move(CLICK_CD_RANGE*2)
	playsound(user.loc, 'sound/items/perfume.ogg', 100, TRUE)
	target.AddComponent(/datum/component/temporary_pollution_emission, fragrance_type, 5, 10 MINUTES)

/obj/item/perfume/random/Initialize(mapload)
	fragrance_type = pick(subtypesof(/datum/pollutant/fragrance))
	name = fragrance_type.name + " perfume"
	. = ..()

/obj/item/perfume/lavender
	name = "薰衣草香水"
	fragrance_type = /datum/pollutant/fragrance/lavender

/obj/item/perfume/cherry
	name = "樱桃香水"
	fragrance_type = /datum/pollutant/fragrance/cherry

/obj/item/perfume/rose
	name = "玫瑰香水"
	fragrance_type = /datum/pollutant/fragrance/rose

/obj/item/perfume/jasmine
	name = "茉莉香水"
	fragrance_type = /datum/pollutant/fragrance/jasmine

/obj/item/perfume/mint
	name = "薄荷香水"
	fragrance_type = /datum/pollutant/fragrance/mint

/obj/item/perfume/vanilla
	name = "香草香水"
	fragrance_type = /datum/pollutant/fragrance/vanilla

/obj/item/perfume/pear
	name = "梨香香水"
	fragrance_type = /datum/pollutant/fragrance/pear

/obj/item/perfume/strawberry
	name = "草莓香水"
	fragrance_type = /datum/pollutant/fragrance/strawberry

/obj/item/perfume/cinnamon
	name = "肉桂香水"
	fragrance_type = /datum/pollutant/fragrance/cinnamon

// "Premium" perfumes they are more expensive by default
// No special mechanical effects
/obj/item/perfume/frankincense
	name = "乳香香水"
	fragrance_type = /datum/pollutant/fragrance/frankincense

/obj/item/perfume/sandalwood
	name = "檀香香水"
	fragrance_type = /datum/pollutant/fragrance/sandalwood

/obj/item/perfume/myrrh
	name = "没药香水"
	fragrance_type = /datum/pollutant/fragrance/myrrh
