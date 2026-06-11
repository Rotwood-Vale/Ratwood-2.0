/obj/item/natural/cloth/bandage
	name = "绷带"
	icon = 'icons/roguetown/items/surgery.dmi'
	icon_state = "bandageroll"
	desc = "一种经过处理的特殊布料，专门用来处理流血的伤口。比起普通的布片，它能更好更快地止血。"
	bundletype = /obj/item/natural/bundle/cloth/bandage
	bandage_effectiveness = 0.25
	bandage_health = 300 //High HP so it can last some time on more serious wounds like arteries, total of 225 blood soaked
	bandage_speed = 4 SECONDS

/obj/item/natural/cloth/bandage/attack_right(mob/user)
	return

/obj/item/natural/bundle/cloth/bandage
	name = "绷带卷"
	icon = 'icons/roguetown/items/surgery.dmi'
	icon_state = "bandageroll1"
	desc = "一卷拼接好的绷带，方便携带。流血者的最佳伙伴。"
	maxamount = 4 //balanced...? You'd die of bloodloss before all of them were dirty.
	stacktype = /obj/item/natural/cloth/bandage
	stackname = "卷绷带"
	icon1 = "bandageroll1"
	icon1step = 3
	icon2 = "bandageroll2"
	icon2step = 4

/obj/item/natural/bundle/cloth/bandage/full
	icon_state = "bandageroll2"
	amount = 4
