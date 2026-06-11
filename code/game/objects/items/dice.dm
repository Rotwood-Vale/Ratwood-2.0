/*****************************Dice Bags********************************/

/obj/item/storage/pill_bottle/dice
	name = "游戏骰袋"
	desc = ""
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"
	grid_height = 64
	grid_width = 32
	var/last_shake_time
	var/list/special_die = list(
				/obj/item/dice/d1,
				/obj/item/dice/d2,
				/obj/item/dice/fudge,
				/obj/item/dice/d6/space,
				/obj/item/dice/d00,
				/obj/item/dice/eightbd20,
				/obj/item/dice/fourdd6,
				/obj/item/dice/d100
				)
	component_type = /datum/component/storage/concrete/roguetown/dice_pouch

/obj/item/storage/pill_bottle/dice/PopulateContents()
	new /obj/item/dice/d4(src)
	new /obj/item/dice/d6(src)
	new /obj/item/dice/d6(src)
	new /obj/item/dice/d8(src)
	new /obj/item/dice/d10(src)
	new /obj/item/dice/d12(src)
	new /obj/item/dice/d20(src)
//	var/picked = pick(special_die)
//	new picked(src)

/obj/item/storage/pill_bottle/dice/suicide_act(mob/user)
	user.visible_message(span_suicide("[user]正在和死神豪赌！看起来[user.p_theyre()]是在试图自杀！"))
	return (OXYLOSS)

/obj/item/storage/pill_bottle/dice/farkle
	name = "法克尔骰袋"

/obj/item/storage/pill_bottle/dice/farkle/PopulateContents()
	new /obj/item/dice/d6(src)
	new /obj/item/dice/d6(src)
	new /obj/item/dice/d6(src)
	new /obj/item/dice/d6(src)
	for(var/i in 1 to 2)
		if(prob(7))
			new /obj/item/dice/d6/ebony(src)
		else
			new /obj/item/dice/d6(src)


/obj/item/storage/pill_bottle/dice/hazard

/obj/item/storage/pill_bottle/dice/hazard/PopulateContents()
	new /obj/item/dice/d6(src)
	new /obj/item/dice/d6(src)
	new /obj/item/dice/d6(src)
	for(var/i in 1 to 2)
		if(prob(7))
			new /obj/item/dice/d6/ebony(src)
		else
			new /obj/item/dice/d6(src)

/*****************************Dice********************************/

/obj/item/dice //depreciated d6, use /obj/item/dice/d6 if you actually want a d6
	name = "骰子"
	desc = ""
	icon = 'icons/obj/dice.dmi'
	icon_state = "d6"
	dropshrink = 0.75
	w_class = WEIGHT_CLASS_TINY
	var/sides = 6
	var/result = null
	var/list/special_faces = list() //entries should match up to sides var if used
	var/microwave_riggable = TRUE

	var/rigged = DICE_NOT_RIGGED
	var/rigged_value
	var/dicetype

/obj/item/dice/examine()
	. = ..()
	. += span_notice("它停在了[result]点。")

/obj/item/dice/Initialize(mapload)
	. = ..()
	if(!result)
		result = roll(sides)
	update_icon()
	dicetype = name
	name = "[dicetype] ([result])"

/obj/item/dice/suicide_act(mob/user)
	user.visible_message(span_suicide("[user]正在和死神豪赌！看起来[user.p_theyre()]是在试图自杀！"))
	return (OXYLOSS)

/obj/item/dice/attack_right(mob/user)
	if(HAS_TRAIT(user, TRAIT_BLACKLEG))
		var/list/possible_outcomes = list()
		var/special = FALSE
		if(special_faces.len == sides)
			possible_outcomes.Add(special_faces)
			special = TRUE
		else
			for(var/i in 1 to sides)
				possible_outcomes += i
		var/outcome = input(user, "要把下一次结果设成什么？", "骰子") as null|anything in possible_outcomes
		if(special)
			outcome = special_faces.Find(outcome)
		if(!outcome)
			return
		rigged = DICE_BASICALLY_RIGGED
		rigged_value = outcome
		return
	. = ..()

/obj/item/dice/d1
	name = "1面骰"
	desc = ""
	icon_state = "d1"
	sides = 1

/obj/item/dice/d2
	name = "2面骰"
	desc = ""
	icon_state = "d2"
	sides = 2

/obj/item/dice/d4
	name = "4面骰"
	desc = ""
	icon_state = "d4"
	sides = 4

/obj/item/dice/d4/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, 1, 4) //1d4 damage

/obj/item/dice/d6
	name = "6面骰"

/obj/item/dice/d6/ebony
	name = "乌木骰子"
	desc = ""
	icon_state = "de6"
	microwave_riggable = FALSE // You can't melt wood in the microwave

/obj/item/dice/d6/space
	name = "太空方块"
	desc = ""
	icon_state = "spaced6"

/obj/item/dice/d6/space/Initialize(mapload)
	. = ..()
	if(prob(10))
		name = "太空方块"

/obj/item/dice/fudge
	name = "命运骰"
	desc = ""
	sides = 3 //shhh
	icon_state = "fudge"
	special_faces = list("减","空白","加")

/obj/item/dice/d8
	name = "8面骰"
	desc = ""
	icon_state = "d8"
	sides = 8

/obj/item/dice/d10
	name = "10面骰"
	desc = ""
	icon_state = "d10"
	sides = 10

/obj/item/dice/d00
	name = "00面骰"
	desc = ""
	icon_state = "d00"
	sides = 10

/obj/item/dice/d12
	name = "12面骰"
	desc = ""
	icon_state = "d12"
	sides = 12

/obj/item/dice/d20
	name = "20面骰"
	desc = ""
	icon_state = "d20"
	sides = 20

/obj/item/dice/d100
	name = "100面骰"
	desc = ""
	icon_state = "d100"
	w_class = WEIGHT_CLASS_SMALL
	sides = 100

/obj/item/dice/d100/update_icon()
	return

/obj/item/dice/eightbd20
	name = "奇异20面骰"
	desc = ""
	icon_state = "8bd20"
	sides = 20
	special_faces = list("肯定如此","十拿九稳","毫无疑问","当然是","你尽可放心","依我看，是的","多半如此","前景不错","是","迹象表明是","答复模糊，再问一次","稍后再问","现在最好别告诉你","现在无法预测","集中精神再问一次","别指望了","我的回答是否定的","我的消息来源说不","前景不太妙","非常可疑")

/obj/item/dice/eightbd20/update_icon()
	return

/obj/item/dice/fourdd6
	name = "4枚6面骰复合骰"
	desc = ""
	icon_state = "4dd6"
	sides = 48
	special_faces = list("方块面：1-1","方块面：1-2","方块面：1-3","方块面：1-4","方块面：1-5","方块面：1-6","方块面：2-1","方块面：2-2","方块面：2-3","方块面：2-4","方块面：2-5","方块面：2-6","方块面：3-1","方块面：3-2","方块面：3-3","方块面：3-4","方块面：3-5","方块面：3-6","方块面：4-1","方块面：4-2","方块面：4-3","方块面：4-4","方块面：4-5","方块面：4-6","方块面：5-1","方块面：5-2","方块面：5-3","方块面：5-4","方块面：5-5","方块面：5-6","方块面：6-1","方块面：6-2","方块面：6-3","方块面：6-4","方块面：6-5","方块面：6-6","方块面：7-1","方块面：7-2","方块面：7-3","方块面：7-4","方块面：7-5","方块面：7-6","方块面：8-1","方块面：8-2","方块面：8-3","方块面：8-4","方块面：8-5","方块面：8-6")

/obj/item/dice/fourdd6/update_icon()
	return

/obj/item/dice/attack_self(mob/user)
	diceroll(user)

/obj/item/dice/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	diceroll(thrownby)
	. = ..()

/obj/item/dice/proc/diceroll(mob/user)
	result = roll(sides)
	if(rigged != DICE_NOT_RIGGED && result != rigged_value)
		if(rigged == DICE_BASICALLY_RIGGED && prob(CLAMP(1/(sides - 1) * 100, 25, 80)))
			result = rigged_value
		else if(rigged == DICE_TOTALLY_RIGGED)
			result = rigged_value

	. = result

	var/fake_result = roll(sides)//Daredevil isn't as good as he used to be
	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "天生 20！"
	else if(sides == 20 && result == 1)
		comment = "哎呀，运气真差。"
	update_icon()
	if(initial(icon_state) == "d00")
		result = (result - 1)*10
	if(special_faces.len == sides)
		result = special_faces[result]
	if(user != null) //Dice was rolled in someone's hand
		user.visible_message(span_notice("[user]掷出了[src]。它落在[result]点。[comment]"), \
							span_notice("我掷出了[src]。它落在[result]点。[comment]"), \
							span_hear("我听见[src]滚动的声音，听起来像是[fake_result]点。"))
	else if(!src.throwing) //Dice was thrown and is coming to rest
		visible_message(span_notice("[src]滚停了下来，落在[result]点。[comment]"))
	name = "[dicetype] ([result])"

/obj/item/dice/update_icon()
	cut_overlays()
	add_overlay("[src.icon_state]-[src.result]")
