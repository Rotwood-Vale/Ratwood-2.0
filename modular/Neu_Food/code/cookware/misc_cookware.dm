// Please only put REALLY, REALLY MISCELLANEOUS stuff in here. Like rolling pins
/obj/item/kitchen/rollingpin
	name = "擀面杖"
	desc = ""
	icon = 'modular/Neu_Food/icons/cookware/misc.dmi'
	icon_state = "rolling_pin"
	force = 8
	throwforce = 5
	throw_speed = 1
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("猛击", "殴打", "棒打", "抽打", "重打")
	custom_price = 20
	grid_width = 32
	grid_height = 64

/obj/item/kitchen/rollingpin/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user]开始用[src]把自己的脑袋擀平！看起来是在自杀！</span>")
	return BRUTELOSS

/obj/item/tablecloth/silk
	name = "丝绸桌布"
	desc = "一块华美的丝绸桌布，专为外交宴席和其他重要场合铺设。"
	icon = 'modular/Neu_Food/icons/cookware/misc.dmi'
	icon_state = "tablecloth_silk"
	sellprice = 40
	w_class = WEIGHT_CLASS_NORMAL
