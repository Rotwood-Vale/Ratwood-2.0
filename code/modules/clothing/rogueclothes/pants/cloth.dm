/obj/item/clothing/under/roguetown/tights
	name = "紧身裤"
	desc = "一条贴身合体的紧身裤。"
	gender = PLURAL
	icon_state = "tights"
	item_state = "tights"
//	adjustable = CAN_CADJUST

/obj/item/clothing/under/roguetown/tights/random/Initialize(mapload)
	color = pick("#544236", "#435436", "#543836", "#79763f")
	..()

/obj/item/clothing/under/roguetown/tights/black
	color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/tights/red
	color = CLOTHING_RED

/obj/item/clothing/under/roguetown/tights/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/under/roguetown/tights/jester
	desc = "滑稽的紧身裤！"
	color = "#1E3B20"

/obj/item/clothing/under/roguetown/tights/lord
	color = "#865c9c"

/obj/item/clothing/under/roguetown/tights/vagrant
	r_sleeve_status = SLEEVE_TORN
	body_parts_covered = GROIN|LEG_LEFT

/obj/item/clothing/under/roguetown/tights/vagrant/l
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = GROIN|LEG_RIGHT

/obj/item/clothing/under/roguetown/tights/vagrant/Initialize(mapload)
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	..()

/obj/item/clothing/under/roguetown/tights/sailor
	name = "水手裤"
	icon_state = "sailorpants"
	salvage_amount = 1

/obj/item/clothing/under/roguetown/tights/puritan
	name = "礼装马裤"
	icon_state = "monkpants"
	item_state = "monkpants"
	color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/webs
	name = "蛛丝下装"
	desc = "由蛛丝织成的精细下装，是幽暗地域中颇受欢迎的时尚。"
	gender = PLURAL
	icon_state = "webs"
	item_state = "webs"
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	salvage_result = /obj/item/natural/silk
	salvage_amount = 1

/obj/item/clothing/under/roguetown/loincloth
	name = "宽大兜裆布"
	desc = ""
	icon_state = "loincloth"
	item_state = "loincloth"
//	adjustable = CAN_CADJUST
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	dropshrink = null

/obj/item/clothing/under/roguetown/loincloth/brown
	color = CLOTHING_BROWN

/obj/item/clothing/under/roguetown/loincloth/pink
	color = "#b98ae3"
