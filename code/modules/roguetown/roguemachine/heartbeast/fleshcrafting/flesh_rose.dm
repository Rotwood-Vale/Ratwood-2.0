/obj/item/black_rose
	icon = 'icons/mob/actions/pestramiracles.dmi'
	icon_state = "rot"
	name = "黑玫瑰"
	desc = "一朵散发着病态甜香的玫瑰，像涂了蜜的腐肉。它黯淡的花瓣间仿佛缠着黑色黏浆，而那黏浆会从你的指尖旁退开。"
	w_class = WEIGHT_CLASS_SMALL
	var/effect_desc = "你知道这东西可以被植入 佩斯特拉 信徒体内，用于承载祛腐神迹。它会庇护她的追随者。"

/obj/item/black_rose/examine(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/c = user
		if(c.patron.type == /datum/patron/divine/pestra)
			. += span_info(effect_desc)
