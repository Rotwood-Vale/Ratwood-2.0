/obj/item/kitchen/fork
	name = "木叉"
	icon = 'modular/Neu_Food/icons/cookware/fork.dmi'
	icon_state = "fork_wooden"
	flags_1 = CONDUCT_1
	hitsound = 'sound/blank.ogg'
	force = 8
	throwforce = 5
	w_class = WEIGHT_CLASS_TINY
	max_blade_int = 40
	max_integrity = 40
	wbalance = WBALANCE_SWIFT
	thrown_bclass = BCLASS_STAB
	possible_item_intents = list(/datum/intent/use, /datum/intent/dagger/thrust/fork)
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')

/datum/intent/dagger/thrust/fork
	penfactor = 20

/obj/item/kitchen/fork/decrepit
	name = "破旧叉子"
	icon_state = "afork"
	color = "#bb9696"
	sellprice = 0

/obj/item/kitchen/fork/iron
	name = "铁叉"
	icon_state = "fork_iron"
	sellprice = 6

/obj/item/kitchen/fork/tin
	name = "锡叉"
	icon_state = "fork_tin"
	sellprice = 6

/obj/item/kitchen/fork/gold
	name = "金叉"
	icon_state = "fork_gold"
	sellprice = 30

/obj/item/kitchen/fork/silver
	name = "银叉"
	icon_state = "fork_silver"
	sellprice = 24
	is_silver = TRUE

/obj/item/kitchen/fork/carved
	name = "雕花叉"
	icon_state = "afork"
	sellprice = 0

/obj/item/kitchen/fork/carved/shell
	name = "贝壳叉"
	icon_state = "fork_shell"
	sellprice = 15

/obj/item/kitchen/fork/carved/rose
	name = "玫瑰石叉"
	icon_state = "fork_rose"
	sellprice = 20

/obj/item/kitchen/fork/carved/jade
	name = "玉叉"
	icon_state = "fork_jade"
	sellprice = 55

/obj/item/kitchen/fork/carved/onyxa
	name = "缟玛瑙叉"
	icon_state = "fork_onyxa"
	sellprice = 35

/obj/item/kitchen/fork/carved/turq
	name = "蔚蓝石叉"
	icon_state = "fork_turq"
	sellprice = 80

/obj/item/kitchen/fork/carved/coral
	name = "心石叉"
	icon_state = "fork_coral"
	sellprice = 65

/obj/item/kitchen/fork/carved/amber
	name = "琥珀叉"
	icon_state = "fork_amber"
	sellprice = 55

/obj/item/kitchen/fork/carved/opal
	name = "欧泊叉"
	icon_state = "fork_opal"
	sellprice = 85
