

/obj/item/natural/hide
	name = "兽皮"
	icon_state = "hide"
	desc = "取自登多尔某种生物身上的皮。"
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 8
	dropshrink = 0.9

/obj/item/natural/cured/essence
	name = "荒野精华"
	icon_state = "wessence"
	desc = "一种注入了登多尔力量的神秘精华。仅仅握在手中，思绪便仿佛回到远古时代。"
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20
	grid_height = 32
	grid_width = 32
	dropshrink = 0.6

/obj/item/natural/fur
	name = "毛皮"
	icon_state = "wool1"
	desc = "取自登多尔某种生物身上的毛皮。"
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	color = "#5c5243"
	sellprice = 18

/obj/item/natural/fur/goat
	desc = "取自山羊。"
	icon_state = "pelt_gote"
	color = null

/obj/item/natural/fur/wolf
	desc = "取自狼。"
	icon_state = "pelt_volf"
	color = null

/obj/item/natural/fur/fox
	desc = "取自鹿狐。"
	icon_state = "pelt_fox"
	color = null

/obj/item/natural/fur/bobcat
	desc = "取自猞猁。"
	icon_state = "pelt_bobcat"
	color = null

/obj/item/natural/fur/mole
	desc = "取自鼹鼠。"
	icon_state = "pelt_mole"
	color = null

/obj/item/natural/fur/rat
	desc = "取自巨鼠。"
	icon_state = "pelt_rous"
	color = null

/obj/item/natural/fur/direbear
	desc = "取自登多尔最强大生物之一的毛皮。"
	icon_state = "pelt_direbear"
	color = "#33302b"
	sellprice = 28

/obj/item/natural/fur/rabbit
	desc = "取自兔。"
	icon_state = "wool2"
	color = "#cecac4"

/obj/item/natural/fur/raccoon	
	desc = "取自浣熊。"
	icon_state = "pelt_raccoon"
	color = null
	sellprice = 12

//RTD make this a storage item and make clickign on animals with things put it in storage
/obj/item/natural/saddle
	name = "鞍具"
	icon_state = "saddle"
	associated_skill = /datum/skill/misc/riding
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_L
	resistance_flags = FIRE_PROOF
	force = 0
	throwforce = 0
	sellprice = 10
	var/storage_type = /datum/component/storage/concrete/roguetown/saddle

/obj/item/natural/saddle/Initialize(mapload)
	. = ..()
	AddComponent(storage_type)

/obj/item/natural/saddle/attack(mob/living/target, mob/living/carbon/human/user)
	if(istype(target, /mob/living/simple_animal))
		testing("yea1")
		var/mob/living/simple_animal/S = target
		if(S.can_saddle && !S.ssaddle)
			testing("yea2")
			if(!target.has_buckled_mobs())
				user.visible_message(span_warning("[user]试图给[target]装上鞍具……"))
				if(do_after(user, 40, target = target))
					playsound(loc, 'sound/foley/saddledismount.ogg', 100, FALSE)
					user.dropItemToGround(src)
					S.ssaddle = src
					src.forceMove(S)
					S.update_icon()
		return
	..()

/mob/living/simple_animal
	var/can_saddle = FALSE
	var/obj/item/ssaddle
	var/simple_detect_bonus = 0 // A flat percentage bonus to our ability to detect sneaking people only. Use in lieu of giving mobs huge STAPER bonuses if you want them to be observant.

/obj/item/natural/bone
	name = "骨头"
	icon_state = "bone"
	desc = "无肉的遗骸。不论来自动物还是人，如今看来都别无二致。"
	blade_dulling = 0
	max_integrity = 20
	static_debris = null
	obj_flags = null
	firefuel = null
	w_class = WEIGHT_CLASS_NORMAL
	twohands_required = FALSE
	gripped_intents = null
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP
	bundletype = /obj/item/natural/bundle/bone

/obj/item/natural/hide/cured
	name = "鞣制皮革"
	icon_state = "leather"
	desc = "一块已经鞣制完成、现在可以加工的皮革。"
	sellprice = 7
	bundletype = /obj/item/natural/bundle/curred_hide

/obj/item/natural/bundle/curred_hide
	name = "一捆鞣制皮革"
	desc = "捆在一起的一堆鞣制皮革。"
	icon_state = "leatherroll1"
	maxamount = 10
	spitoutmouth = FALSE
	stacktype = /obj/item/natural/hide/cured
	stackname = "鞣制皮革"
	icon1 = "leatherroll1"
	icon1step = 5
	icon2 = "leatherroll2"
	icon2step = 10
	dropshrink = 0.9

/obj/item/natural/cured/essence
	name = "荒野精华"
	icon_state = "wessence"
	desc = "一大滴据说蕴含 Dendor 本源之力的神秘树液，\n\
	猎人与其他荒野居民常将其带在身上以求好运。熟练的裁缝可将它注入某些衣物或皮革中以提供防护。"
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20

/obj/item/natural/rabbitsfoot
	name = "兔脚"
	icon_state = "rabbitfoot"
	desc = "一只兔脚。象征好运的护符。"
	w_class = WEIGHT_CLASS_TINY
	sellprice = 10
