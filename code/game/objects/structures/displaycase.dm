/obj/structure/displaycase
	name = "展示柜"
	icon_state = "glassbox0"
	desc = ""
	density = TRUE
	anchored = TRUE
	resistance_flags = ACID_PROOF
	armor = ARMOR_DISPLAYCASE
	max_integrity = 200
	integrity_failure = 0.25
	var/obj/item/showpiece = null
	var/alert = TRUE
	var/open = FALSE
	var/openable = TRUE
	var/start_showpiece_type = null //add type for items on display
	var/list/start_showpieces = list() //Takes sublists in the form of list("type" = /obj/item/bikehorn, "trophy_message" = "henk")
	var/trophy_message = ""

/obj/structure/displaycase/Initialize(mapload)
	. = ..()
	if(start_showpieces.len && !start_showpiece_type)
		var/list/showpiece_entry = pick(start_showpieces)
		if (showpiece_entry && showpiece_entry["type"])
			start_showpiece_type = showpiece_entry["type"]
			if (showpiece_entry["trophy_message"])
				trophy_message = showpiece_entry["trophy_message"]
	if(start_showpiece_type)
		showpiece = new start_showpiece_type (src)
	update_icon()

/obj/structure/displaycase/Destroy()
	if(showpiece)
		QDEL_NULL(showpiece)
	return ..()

/obj/structure/displaycase/examine(mob/user)
	. = ..()
	if(alert)
		. += "<span class='notice'>已接入防盗系统。</span>"
	if(showpiece)
		. += "<span class='notice'>里面陈列着[showpiece]。</span>"
	if(trophy_message)
		. += "铭牌上写着：\n [trophy_message]"


/obj/structure/displaycase/proc/dump()
	if (showpiece)
		showpiece.forceMove(loc)
		showpiece = null

/obj/structure/displaycase/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(src.loc, 'sound/blank.ogg', 75, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/blank.ogg', 100, TRUE)

/obj/structure/displaycase/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		dump()
		if(!disassembled)
			new /obj/item/natural/glass_shard( src.loc )
	qdel(src)

/obj/structure/displaycase/obj_break(damage_flag)
	..()

	if(!obj_broken && !(flags_1 & NODECONSTRUCT_1))
		density = FALSE
		new /obj/item/natural/glass_shard( src.loc )
		playsound(src, "shatter", 70, TRUE)
		update_icon()

/obj/structure/displaycase/update_icon()
	return

/obj/structure/displaycase/attackby(obj/item/W, mob/user, params)
	if(W.GetID() && !obj_broken && openable)
		if(allowed(user))
			to_chat(user,  "<span class='notice'>我[open ? "关上了":"打开了"][src]。</span>")
			toggle_lock(user)
		else
			to_chat(user,  "<span class='alert'>拒绝访问。</span>")
	else if(W.tool_behaviour == TOOL_WELDER && user.used_intent.type == INTENT_HELP && !obj_broken)
		if(obj_integrity < max_integrity)
			if(!W.tool_start_check(user, amount=5))
				return

			to_chat(user, "<span class='notice'>我开始修理[src]……</span>")
			if(W.use_tool(src, user, 40, amount=5, volume=50))
				obj_integrity = max_integrity
				update_icon()
				to_chat(user, "<span class='notice'>我修好了[src]。</span>")
		else
			to_chat(user, "<span class='warning'>[src]本来就完好无损！</span>")
		return
	else if(!alert && W.tool_behaviour == TOOL_CROWBAR && openable) //Only applies to the lab cage and player made display cases
		if(obj_broken)
			if(showpiece)
				to_chat(user, "<span class='warning'>先把里面展示的物品取出来！</span>")
			else
				to_chat(user, "<span class='notice'>我拆除了这个已经损坏的展示柜。</span>")
				qdel(src)
		else
			to_chat(user, "<span class='notice'>我开始[open ? "关上":"打开"][src]……</span>")
			if(W.use_tool(src, user, 20))
				to_chat(user,  "<span class='notice'>我[open ? "关上了":"打开了"][src]。</span>")
				toggle_lock(user)
	else if(open && !showpiece)
		if(user.transferItemToLoc(W, src))
			showpiece = W
			to_chat(user, "<span class='notice'>我把[W]放进了展示柜里。</span>")
			update_icon()
	else
		return ..()

/obj/structure/displaycase/proc/toggle_lock(mob/user)
	open = !open
	update_icon()

/obj/structure/displaycase/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if (showpiece && (obj_broken || open))
		to_chat(user, "<span class='notice'>我关闭了展示柜内置的悬浮力场。</span>")
		log_combat(user, src, "deactivates the hover field of")
		dump()
		src.add_fingerprint(user)
		update_icon()
		return
	else
	    //prevents remote "kicks" with TK
		if (!Adjacent(user))
			return
		if (user.used_intent.type == INTENT_HELP)
			user.examinate(src)
			return
		user.visible_message("<span class='danger'>[user]踹了展示柜一脚。</span>", null, null, COMBAT_MESSAGE_RANGE)
		log_combat(user, src, "kicks")
		user.do_attack_animation(src, ATTACK_EFFECT_KICK)
		take_damage(2)

/obj/structure/displaycase/trophy
	name = "战利品展示柜"
	desc = ""
	var/placer_key = ""
	var/added_roundstart = TRUE
	var/is_locked = TRUE

	alert = TRUE
	integrity_failure = 0
	openable = FALSE

/obj/structure/displaycase/trophy/Initialize(mapload)
	. = ..()
	GLOB.trophy_cases += src

/obj/structure/displaycase/trophy/Destroy()
	GLOB.trophy_cases -= src
	return ..()

/obj/structure/displaycase/trophy/attackby(obj/item/W, mob/user, params)

	if(!user.Adjacent(src)) //no TK museology
		return
	if(user.used_intent.type == INTENT_HARM)
		return ..()

	if(user.is_holding_item_of_type(/obj/item/key/displaycase))
		if(added_roundstart)
			is_locked = !is_locked
			to_chat(user, "<span class='notice'>我[!is_locked ? "打开了" : "锁上了"]展示柜。</span>")
		else
			to_chat(user, "<span class='warning'>锁芯卡死了，根本打不开！</span>")
		return

	if(is_locked)
		to_chat(user, "<span class='warning'>这展示柜被一把老式机械锁严严实实锁住了。也许你该去找馆长要钥匙？</span>")
		return

	if(!added_roundstart)
		to_chat(user, "<span class='warning'>你已经往这个展示柜里放过新的东西了！</span>")
		return

	if(user.transferItemToLoc(W, src))

		if(showpiece)
			to_chat(user, "<span class='notice'>我按下一个按钮，[showpiece]便沉进了展示柜底部。</span>")
			QDEL_NULL(showpiece)

		to_chat(user, "<span class='notice'>我把[W]放进了展示柜里。</span>")
		showpiece = W
		added_roundstart = FALSE
		update_icon()

		placer_key = user.ckey

		trophy_message = W.desc //default value

		var/chosen_plaque = stripped_input(user, "你想让铭牌上写什么？默认内容为物品描述。", "战利品铭牌")
		if(chosen_plaque)
			if(user.Adjacent(src))
				trophy_message = chosen_plaque
				to_chat(user, "<span class='notice'>我设置好了铭牌文字。</span>")
			else
				to_chat(user, "<span class='warning'>我离得太远，没法设置铭牌文字！</span>")

		SSpersistence.SaveTrophy(src)
		return TRUE

	else
		to_chat(user, "<span class='warning'>[W]黏在你的手上了，没法把它放进[src.name]里！</span>")

	return

/obj/structure/displaycase/trophy/dump()
	if (showpiece)
		if(added_roundstart)
			visible_message("<span class='danger'>[showpiece]碎成了一地尘灰！</span>")
			new /obj/item/ash(loc)
			QDEL_NULL(showpiece)
		else
			..()

/obj/item/key/displaycase
	name = "展示柜钥匙"
	desc = ""

/obj/item/showpiece_dummy
	name = "廉价仿制品"

/obj/item/showpiece_dummy/Initialize(mapload, path)
	. = ..()
	var/obj/item/I = path
	name = initial(I.name)
	icon = initial(I.icon)
	icon_state = initial(I.icon_state)
