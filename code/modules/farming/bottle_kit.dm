/obj/item/bottle_kit
	name = "装瓶套件"
	desc = "一包彩色瓶子和一些标签。"
	icon = 'icons/obj/brewing.dmi'
	icon_state = "bottler_box"
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 32
	grid_height = 32
	var/glass_colour = "brew_bottle"
	var/fake_glass_name = "蓝色"

/obj/item/bottle_kit/examine(mob/user)
	. = ..()
	if(fake_glass_name)
		. += span_info("该套件当前设置为[fake_glass_name]的瓶子。")
	. += span_info("你可以使用套件更改瓶子的颜色。点击已完成发酵的发酵桶/蒸馏器来装瓶其产物。")	

/obj/item/bottle_kit/attack_self(mob/user as mob)
	..()
	glass_picker(user)

/obj/item/bottle_kit/proc/glass_picker(mob/user as mob)
	var/list/options = list()
	options["蓝色"] = "brew_bottle"
	options["红色"] = "brew_red_bottle"
	options["绿色"] = "brew_green_bottle"
	options["白色"] = "brew_white_bottle"
	options["黑炭色"] = "brew_coal_bottle"
	options["青铜色"] = "brew_fancy_bottle"
	options["暗紫色"] = "brew_funky_bottle"
	options["天蓝色"] = "brew_sky_bottle"
	options["褪色黄铜色"] = "brew_saint_po_bottle"
	options["焦糖色"] = "brew_gold_bottle"
	options["海蓝色"] = "brew_pianowoman_bottle"
	options["褪尘色"] = "brew_noir_bottle"
	options["蜜糖色"] = "brew_bees_bottle"

	if(!options.len)
		to_chat(user, span_info("装瓶套件目前仅限普通蓝色瓶子。哎呀！"))
		glass_colour = "brew_bottle"
		fake_glass_name = "蓝"
		return

	var/choice = input(user, "你选择什么颜色？", name) as anything in options

	var/printing_choice = options[choice]

	if(!printing_choice)
		glass_colour = "brew_bottle"
		fake_glass_name = "蓝色"
		return

	fake_glass_name = choice
	glass_colour = printing_choice
