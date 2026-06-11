
/obj/item/natural/feather
	name = "羽毛"
	icon_state = "feather"
	possible_item_intents = list(/datum/intent/use)
	desc = "一根蓬松的羽毛。"
	force = 0
	throwforce = 0
	obj_flags = null
	firefuel = null
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	body_parts_covered = null
	experimental_onhip = TRUE
	max_integrity = 20
	muteinmouth = TRUE
	spitoutmouth = FALSE
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.75

//reproduces some code from pens so that we can utilize feathers for renaming objects

/obj/item/natural/feather/afterattack(obj/O, mob/living/user, proximity)
	. = ..()
	if(isobj(O) && proximity && (O.obj_flags & UNIQUE_RENAME))
		var/penchoice = input(user, "你想修改什么？", "重命名还是修改描述？") as null|anything in list("重命名","修改描述")
		if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
			return
		if(penchoice == "重命名")
			var/input = stripped_input(user,"你想把[O.name]命名为什么？", ,"", MAX_NAME_LEN)
			var/oldname = O.name
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			if(!input)
				return
			if(oldname == input)
				to_chat(user, span_notice("我把[O.name]改成了……嗯……还是[O.name]。"))
			else
				O.name = "[input] ([initial(O.name)])"
				to_chat(user, span_notice("[oldname]已成功更名为[input]。"))
				O.renamedByPlayer = TRUE

		if(penchoice == "修改描述")
			var/input = stripped_input(user,"在这里填写[O.name]的描述", ,"", 250)
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			O.desc = input
			to_chat(user, span_notice("我已成功修改[O.name]的描述。"))
