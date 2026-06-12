/obj/item/reagent_containers/glass/bowl
	name = "木碗"
	desc = "埏埴以为器，当其无，有器之用"
	icon = 'modular/Neu_Food/icons/cookware/bowl.dmi'
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	icon_state = "bowl"
	force = 5
	throwforce = 5
	reagent_flags = OPENCONTAINER
	amount_per_transfer_from_this = 7
	possible_transfer_amounts = list(7)
	dropshrink = 1
	w_class = WEIGHT_CLASS_NORMAL
	volume = 30
	obj_flags = CAN_BE_HIT
	sellprice = 1
	drinksounds = list('sound/items/drink_cup (1).ogg','sound/items/drink_cup (2).ogg','sound/items/drink_cup (3).ogg','sound/items/drink_cup (4).ogg','sound/items/drink_cup (5).ogg')
	fillsounds = list('sound/items/fillcup.ogg')

/obj/item/reagent_containers/glass/bowl/decrepit
	name = "残旧碗"
	icon_state = "abowl"
	sellprice = 15

/obj/item/reagent_containers/glass/bowl/iron
	name = "铁碗"
	icon_state = "bowl_iron"
	sellprice = 20

/obj/item/reagent_containers/glass/bowl/gold
	name = "金碗"
	icon_state = "bowl_gold"
	sellprice = 120

/obj/item/reagent_containers/glass/bowl/silver
	name = "银碗"
	icon_state = "bowl_silver"
	sellprice = 96
	is_silver = TRUE

/obj/item/reagent_containers/glass/bowl/carved
	name = "雕花碗"
	desc = "你本不该看到这个。"
	icon_state = "abowl"
	sellprice = 0

/obj/item/reagent_containers/glass/bowl/carved/jade
	name = "玉碗"
	desc = "一只用玉雕成的碗。"
	icon_state = "bowl_jade"
	sellprice = 55

/obj/item/reagent_containers/glass/bowl/carved/onyxa
	name = "缟玛瑙碗"
	desc = "一只用缟玛瑙雕成的碗。"
	icon_state = "bowl_onyxa"
	sellprice = 35

/obj/item/reagent_containers/glass/bowl/carved/rose
	name = "玫瑰石碗"
	desc = "一只用玫瑰石雕成的碗。"
	icon_state = "bowl_rose"
	sellprice = 20

/obj/item/reagent_containers/glass/bowl/carved/amber
	name = "琥珀碗"
	desc = "一只用琥珀雕成的碗。"
	icon_state = "bowl_amber"
	sellprice = 55

/obj/item/reagent_containers/glass/bowl/carved/turq
	name = "蔚蓝石碗"
	desc = "一只用蔚蓝石雕成的碗。"
	icon_state = "bowl_turq"
	sellprice = 80

/obj/item/reagent_containers/glass/bowl/carved/shell
	name = "贝壳碗"
	desc = "一只用贝壳雕成的碗。"
	icon_state = "bowl_shell"
	sellprice = 15

/obj/item/reagent_containers/glass/bowl/carved/coral
	name = "心石碗"
	desc = "一只用心石雕成的碗。"
	icon_state = "bowl_coral"
	sellprice = 65

/obj/item/reagent_containers/glass/bowl/carved/opal
	name = "蛋白石碗"
	desc = "一只用蛋白石雕成的碗。"
	icon_state = "bowl_opal"
	sellprice = 85

/obj/item/reagent_containers/glass/bowl/tin
	name = "锡碗"
	icon_state = "bowl_tin"
	sellprice = 20

/obj/item/reagent_containers/glass/bowl/update_icon()
	cut_overlays()
	if(reagents)
		if(reagents.total_volume > 0)
			if(reagents.total_volume <= 11)
				var/mutable_appearance/filling = mutable_appearance(icon, "bowl_low")
				filling.color = mix_color_from_reagents(reagents.reagent_list)
				add_overlay(filling)
		if(reagents.total_volume > 11)
			if(reagents.total_volume <= 22)
				var/mutable_appearance/filling = mutable_appearance(icon, "bowl_half")
				filling.color = mix_color_from_reagents(reagents.reagent_list)
				add_overlay(filling)
		if(reagents.total_volume > 22)
			if(reagents.has_reagent(/datum/reagent/consumable/soup/porridge/oatmeal, 10))
				var/mutable_appearance/filling = mutable_appearance(icon, "bowl_oatmeal")
				filling.color = mix_color_from_reagents(reagents.reagent_list)
				add_overlay(filling)
			if(reagents.has_reagent(/datum/reagent/consumable/soup/stew/chicken, 17) || reagents.has_reagent(/datum/reagent/consumable/soup/stew/meat, 17) || reagents.has_reagent(/datum/reagent/consumable/soup/stew/fish, 17 || reagents.has_reagent(/datum/reagent/consumable/soup/stew/rabbit, 17)))
				var/mutable_appearance/filling = mutable_appearance(icon, "bowl_stew")
				filling.color = mix_color_from_reagents(reagents.reagent_list)
				add_overlay(filling)
			else
				var/mutable_appearance/filling = mutable_appearance(icon, "bowl_full")
				filling.color = mix_color_from_reagents(reagents.reagent_list)
				add_overlay(filling)
	else
		icon_state = "bowl"

/obj/item/reagent_containers/glass/bowl/on_reagent_change(changetype)
	..()
	update_icon()

/obj/item/reagent_containers/glass/bowl/attackby(obj/item/I, mob/user, params) // lets you eat with a spoon from a bowl
	. = ..()
	if(istype(I, /obj/item/kitchen/spoon))
		if(reagents.total_volume > 0)
			if(do_after(user, 1 SECONDS, target = src))
				playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
				visible_message(span_info("[user]从[src]中取食。"))
				addtimer(CALLBACK(reagents, TYPE_PROC_REF(/datum/reagents, trans_to), user, min(amount_per_transfer_from_this,5), TRUE, TRUE, FALSE, user, FALSE, INGEST), 5)
		return TRUE
