/obj/item/reagent_containers/glass/cup
	name = "金属杯"
	desc = "一只结实的金属杯。常见于战士、典狱官与其他强壮之人的手中。"
	icon = 'modular/Neu_Food/icons/cookware/cup.dmi'
	icon_state = "iron"
	force = 5
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	throwforce = 10
	reagent_flags = OPENCONTAINER
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	dropshrink = 0.85
	w_class = WEIGHT_CLASS_NORMAL
	experimental_inhand = FALSE
	volume = 25
	obj_flags = CAN_BE_HIT
	sellprice = 7
	drinksounds = list('sound/items/drink_cup (1).ogg','sound/items/drink_cup (2).ogg','sound/items/drink_cup (3).ogg','sound/items/drink_cup (4).ogg','sound/items/drink_cup (5).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	anvilrepair = /datum/skill/craft/blacksmithing
	var/rolling = FALSE
	var/max_dice = 6
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/update_icon(dont_fill=FALSE)
	testing("cupupdate")

	cut_overlays()

	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]filling")

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		add_overlay(filling)
	if(max_dice)
		var/dice_count = 0
		for(var/obj/item/dice/D in contents)
			dice_count++
		if(dice_count)
			dice_count = min(3, dice_count)
		add_overlay(mutable_appearance(icon, "[icon_state]dice[dice_count]"))

/obj/item/reagent_containers/glass/cup/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/dice) && max_dice)
		if(reagents && reagents.total_volume)
			to_chat(user, span_warning("[src]里装满了液体！没法把骰子放进去。"))
			return TRUE

		if(length(contents) >= max_dice)
			to_chat(user, span_warning("[src]最多只能装[max_dice]枚骰子。"))
			return TRUE

		I.forceMove(src)
		user.visible_message(
			span_notice("[user]把[I]丢进了[src]。"),
			span_notice("我把[I]丢进了[src]。")
		)
		update_icon()
		return TRUE
	. = ..()

/obj/item/reagent_containers/glass/cup/attack_self(mob/user)
	if(!max_dice)
		return
	if(rolling)
		return
	if(!contents)
		return
	var/list/dice_in_cup = list()
	for(var/obj/item/dice/D in contents)
		dice_in_cup += D

	if(!dice_in_cup.len)
		return

	playsound(src, 'sound/items/cup_dice_roll.ogg', 100, TRUE)
	if(do_after(user, 1.5 SECONDS))
		rolling = TRUE
		user.visible_message(
			span_notice("[user]摇晃着[src]，把里面的骰子全都掷了出去！"),
			span_notice("我摇晃[src]，把里面的骰子全都掷了出去！")
		)

		var/turf/target_turf = get_step(user.loc, user.dir)
		if(!target_turf)
			target_turf = get_turf(user)

		for(var/obj/item/dice/D in dice_in_cup)
			D.forceMove(get_turf(user))
			D.throw_at(target_turf, 1, 2, user)

		rolling = FALSE
		update_icon()

/obj/item/reagent_containers/glass/cup/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return ..()

	if(istype(target, /obj/item/dice) && max_dice)
		if(reagents && reagents.total_volume)
			to_chat(user, span_warning("[src]里装满了液体！没法把骰子舀进去。"))
			return

		var/turf/T = get_turf(target)
		var/list/scooped = list()
		for(var/obj/item/dice/D in T)
			if(length(contents) >= max_dice)
				break
			D.forceMove(src)
			scooped += D

		if(scooped.len)
			user.visible_message(
				span_notice("[user]用[src]舀起了[replacetext(replacetext(replacetext(english_list(scooped), ", and ", "、"), " and ", "、"), ", ", "、")]。"),
				span_notice("我用[src]舀起了[replacetext(replacetext(replacetext(english_list(scooped), ", and ", "、"), " and ", "、"), ", ", "、")]。")
			)
		update_icon()
		return TRUE

	return ..()

/obj/item/reagent_containers/glass/cup/examine()
	. = ..()
	if (max_dice)
		var/dice_count = 0
		for(var/obj/item/dice/D in contents)
			dice_count++
		if(dice_count)
			. += span_info("杯子里有[dice_count]枚[dice_count > 1 ? "骰子" : "骰子"]。")

/obj/item/reagent_containers/glass/cup/onfill(obj/target, mob/user, silent = FALSE)
	..()
	if(max_dice && contents)
		for(var/obj/item/dice/D in contents)
			user.visible_message(
				span_notice("[user]在往[src]里倒液体时，不小心把[D]洒了出来！"),
				span_notice("我在往[src]里倒液体时，不小心把[D]洒了出来！")
			)
			D.forceMove(get_turf(user))
			update_icon()


/obj/item/reagent_containers/glass/cup/wooden
	name = "木杯"
	desc = "这只杯子低语着酒后斗殴与盛宴的传说。"
	resistance_flags = FLAMMABLE
	icon_state = "wooden"
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	anvilrepair = null
	sellprice = 0
	metalizer_result = /obj/item/reagent_containers/glass/cup
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/steel
	name = "钢制高脚杯"
	desc = "一只钢制高脚杯，表面饰有铆钉。"
	icon_state = "steel"
	sellprice = 10
	force = 10
	throwforce = 15

/obj/item/reagent_containers/glass/cup/decrepitmug
	name = "破旧马克杯"
	desc = "磨损的青铜盘绕成杯。数百年前，冒险者们会在这里大笑、传颂传奇；而如今，只剩下一张张空椅和空桌。"
	color = "#bb9696"
	icon_state = "amug"
	sellprice = 5
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/decrepitgob
	name = "破旧高脚杯"
	desc = "磨损的青铜盘绕成一只弯柄酒杯。很难想象它曾属于一位贵族；然而，它却比那早已衰败的血脉存续得更久。"
	color = "#bb9696"
	icon_state = "agoblet"
	sellprice = 10
	force = 10
	throwforce = 15

/obj/item/reagent_containers/glass/cup/silver
	name = "银制高脚杯"
	desc = "一只银制高脚杯，表面经过细致打磨。"
	icon_state = "silver"
	sellprice = 48
	last_used = 0
	is_silver = TRUE
	force = 10
	throwforce = 15

/obj/item/reagent_containers/glass/cup/silver/small
	name = "银杯"
	desc = "一只银杯，表面经过细致打磨。"
	icon_state = "scup"
	sellprice = 20
	is_silver = TRUE
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/golden
	name = "金制高脚杯"
	desc = "这只高脚杯散发着奢华与庄严的气息。"
	icon_state = "golden"
	sellprice = 50
	force = 10
	throwforce = 15

/obj/item/reagent_containers/glass/cup/golden/small
	name = "金杯"
	desc = "这只杯子散发着奢华与庄严的气息。"
	icon_state = "gcup"
	sellprice = 40
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/golden/poison
	list_reagents = list(/datum/reagent/toxin/killersice = 1, /datum/reagent/consumable/ethanol/elfred = 20)
	force = 10
	throwforce = 15

/obj/item/reagent_containers/glass/cup/tin
	name = "锡制高脚杯"
	desc = "一只锡制高脚杯，比银器便宜，但同样闪亮！"
	icon_state = "tgoblet"
	sellprice = 12

/obj/item/reagent_containers/glass/cup/tin/small
	name = "锡杯"
	desc = "一只锡杯，比银器便宜，但同样闪亮！"
	icon_state = "tcup"
	sellprice = 8

/obj/item/reagent_containers/glass/cup/skull
	name = "颅骨高脚杯"
	desc = "那空洞的眼窝诉说着被遗忘的黑暗仪式。"
	dropshrink = 1
	icon_state = "skull"
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/ceramic
	name = "茶杯"
	desc = "一只陶瓷制成的茶杯，用来盛茶。"
	dropshrink = 0.7
	icon_state = "cup"
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	sellprice = 10
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/ceramic/examine()
	. = ..()
	. += span_info("可以用染料刷为它上釉。")

/obj/item/reagent_containers/glass/cup/ceramic/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(istype(I, /obj/item/dye_brush))
		if(reagents.total_volume)
			to_chat(user, span_notice("杯子里还有液体时，我没法给它上釉。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("我用染料刷给杯子上了釉。"))
			new /obj/item/reagent_containers/glass/cup/ceramic/fancy(get_turf(src))
			qdel(src)
		return

/obj/item/reagent_containers/glass/cup/ceramic/fancy
	name = "华丽茶杯"
	desc = "一只华丽的陶瓷茶杯，用来盛茶。"
	icon_state = "cup_fancy"
	sellprice = 12
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/carved
	name = "雕刻杯"
	desc = "你本不该看到这个。"
	dropshrink = 1
	icon_state = "agoblet"
	sellprice = 0

/obj/item/reagent_containers/glass/cup/carved/jade
	name = "玉杯"
	desc = "一只用玉雕成的朴素杯子。"
	dropshrink = 1
	icon_state = "cup_jade"
	sellprice = 55

/obj/item/reagent_containers/glass/cup/carved/turq
	name = "蔚蓝石杯"
	desc = "一只用蔚蓝石雕成的朴素杯子。"
	dropshrink = 1
	icon_state = "cup_turq"
	sellprice = 80

/obj/item/reagent_containers/glass/cup/carved/amber
	name = "琥珀杯"
	desc = "一只用琥珀雕成的朴素杯子。"
	dropshrink = 1
	icon_state = "cup_amber"
	sellprice = 55

/obj/item/reagent_containers/glass/cup/carved/coral
	name = "心石杯"
	desc = "一只用心石雕成的朴素杯子。"
	dropshrink = 1
	icon_state = "cup_coral"
	sellprice = 65

/obj/item/reagent_containers/glass/cup/carved/onyxa
	name = "缟玛瑙杯"
	desc = "一只用缟玛瑙雕成的朴素杯子。"
	dropshrink = 1
	icon_state = "cup_onyxa"
	sellprice = 35

/obj/item/reagent_containers/glass/cup/carved/shell
	name = "贝壳杯"
	desc = "一只用贝壳雕成的朴素杯子。"
	dropshrink = 1
	icon_state = "cup_shell"
	sellprice = 15

/obj/item/reagent_containers/glass/cup/carved/opal
	name = "欧泊杯"
	desc = "一只用欧泊雕成的朴素杯子。"
	dropshrink = 1
	icon_state = "cup_opal"
	sellprice = 85

/obj/item/reagent_containers/glass/cup/carved/rose
	name = "玫瑰石杯"
	desc = "一只用玫瑰石雕成的朴素杯子。"
	dropshrink = 1
	icon_state = "cup_rose"
	sellprice = 20

/obj/item/reagent_containers/glass/cup/carved/jadefancy
	name = "华丽玉杯"
	desc = "一只用玉雕成的华丽杯子。"
	dropshrink = 1
	icon_state = "fancycup_jade"
	sellprice = 65

/obj/item/reagent_containers/glass/cup/carved/turqfancy
	name = "华丽蔚蓝石杯"
	desc = "一只用蔚蓝石雕成的华丽杯子。"
	dropshrink = 1
	icon_state = "fancycup_turq"
	sellprice = 90

/obj/item/reagent_containers/glass/cup/carved/opalfancy
	name = "华丽欧泊杯"
	desc = "一只用欧泊雕成的华丽杯子。"
	dropshrink = 1
	icon_state = "fancycup_opal"
	sellprice = 95

/obj/item/reagent_containers/glass/cup/carved/coralfancy
	name = "华丽心石杯"
	desc = "一只用心石雕成的华丽杯子。"
	dropshrink = 1
	icon_state = "fancycup_coral"
	sellprice = 75

/obj/item/reagent_containers/glass/cup/carved/amberfancy
	name = "华丽琥珀杯"
	desc = "一只用琥珀雕成的华丽杯子。"
	dropshrink = 1
	icon_state = "fancycup_amber"
	sellprice = 65

/obj/item/reagent_containers/glass/cup/carved/shellfancy
	name = "华丽贝壳杯"
	desc = "一只用贝壳雕成的华丽杯子。"
	dropshrink = 1
	icon_state = "fancycup_shell"
	sellprice = 25

/obj/item/reagent_containers/glass/cup/carved/rosefancy
	name = "华丽玫瑰石杯"
	desc = "一只用玫瑰石雕成的华丽杯子。"
	dropshrink = 1
	icon_state = "fancycup_rose"
	sellprice = 30

/obj/item/reagent_containers/glass/cup/carved/onyxafancy
	name = "华丽缟玛瑙杯"
	desc = "一只用缟玛瑙雕成的华丽杯子。"
	dropshrink = 1
	icon_state = "fancycup_onyxa"
	sellprice = 45
