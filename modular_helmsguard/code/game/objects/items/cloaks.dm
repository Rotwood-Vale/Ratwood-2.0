
/// HOSPITALER
/obj/item/clothing/cloak/stabard/hospitaler
	color = "#1e4c88"
	detail_tag = "_psy"
	detail_color = "#ecf4ff"
	boobed_detail = FALSE

/obj/item/clothing/cloak/stabard/hospitaler/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/stabard/hospitaler/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一个样式。","罩袍样式") as null|anything in list("默认", "金十字", "杰鲁亚", "黑金", "黑白")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design == "金十字")
		detail_color = "#b5b004"
	if(design == "杰鲁亚")
		detail_color = "#b5b004"
		color = "#249589"
	if(design == "黑金")
		detail_color = CLOTHING_YELLOW
		color = CLOTHING_BLACK
	if(design == "黑白")
		detail_color = CLOTHING_WHITE
		color = CLOTHING_BLACK
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "不满意") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE



/obj/item/clothing/cloak/tabard/hospitaler
	color = "#1e4c88"
	detail_tag = "_psy"
	detail_color = "#fdfdfd"
	boobed_detail = FALSE


/obj/item/clothing/cloak/tabard/hospitaler/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/tabard/hospitaler/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一个样式。","罩袍样式") as null|anything in list("默认", "金十字", "杰鲁亚", "黑金", "黑白")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design == "金十字")
		detail_color = "#b5b004"
	if(design == "杰鲁亚")
		detail_color = "#b5b004"
		color = "#249589"
	if(design == "黑金")
		detail_color = CLOTHING_YELLOW
		color = CLOTHING_BLACK
	if(design == "黑白")
		detail_color = CLOTHING_WHITE
		color = CLOTHING_BLACK
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "不满意") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE


/// TEMPLARS



/obj/item/clothing/cloak/stabard/crusaders
	detail_tag = "_psy"
	detail_color = "#ffffff"
	boobed_detail = FALSE


/obj/item/clothing/cloak/stabard/crusaders/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/stabard/crusaders/attack_right(mob/user)
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "选择一个样式。","罩袍样式") as null|anything in list("默认", "金十字", "杰鲁亚", "黑金", "黑白")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design == "金十字")
		detail_color = "#b5b004"
	if(design == "杰鲁亚")
		detail_color = "#b5b004"
		color = "#249589"
	if(design == "黑金")
		detail_color = CLOTHING_YELLOW
		color = CLOTHING_BLACK
	if(design == "黑白")
		detail_color = CLOTHING_WHITE
		color = CLOTHING_BLACK
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(alert("你对自己的纹章满意吗？", "纹章", "满意", "不满意") != "满意")
		detail_color = initial(detail_color)
		color = initial(color)
		update_icon()
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE
