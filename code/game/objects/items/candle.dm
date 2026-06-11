#define CANDLE_LUMINOSITY	3
/obj/item/candle
	name = "蜡烛"
	desc = "一根烛芯反复浸入熔化的蜂蛛蜡中制成的蜡烛。"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = FALSE
	possible_item_intents = list(/datum/intent/use) //If this affects candles lighting anything, remove this entire line to fix it.
	light_color = LIGHT_COLOR_FIRE
	heat = 1000
	dropshrink = 0.85
	var/wax = 1000
	var/lit = FALSE
	var/infinite = FALSE
	var/start_lit = FALSE

/obj/item/candle/lit
	start_lit = TRUE
	icon_state = "candle1_lit"

/obj/item/candle/Initialize(mapload)
	. = ..()
	if(start_lit)
		light()

/obj/item/candle/update_icon()
	icon_state = "candle[(wax > 400) ? ((wax > 750) ? 1 : 2) : 3][lit ? "_lit" : ""]"

/obj/item/candle/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(lit)
		A.fire_act()

/obj/item/candle/Crossed(H as mob|obj)
	if(ishuman(H)) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		if(M.m_intent == MOVE_INTENT_RUN)
			wax = 100
			put_out_candle()

/obj/item/candle/fire_act(added, maxstacks)
	if(!lit)
		light()
		return TRUE
	return ..()

/obj/item/candle/spark_act()
	fire_act()

/obj/item/candle/get_temperature()
	return lit * heat

/obj/item/candle/proc/light(show_message)
	if(!lit)
		lit = TRUE
		if(show_message)
			usr.visible_message(show_message)
		set_light(CANDLE_LUMINOSITY)
		START_PROCESSING(SSobj, src)
		update_icon()

/obj/item/candle/proc/put_out_candle()
	if(!lit)
		return
	lit = FALSE
	update_icon()
	set_light(0)
	return TRUE

/obj/item/candle/extinguish()
	put_out_candle()
	return ..()

/obj/item/candle/process()
	if(!lit)
		return PROCESS_KILL
	if(!infinite)
		wax--
	if(!wax)
		new /obj/item/trash/candle(loc)
		qdel(src)
	update_icon()
	open_flame()

/obj/item/candle/attack_self(mob/user)
	if(put_out_candle())
		user.visible_message(span_notice("[user]吹灭了[src]。"))

/obj/item/candle/yellow
	icon = 'icons/roguetown/items/lighting.dmi'

/obj/item/candle/yellow/lit
	start_lit = TRUE
	icon_state = "candle1_lit"

/obj/item/candle/eora
	icon = 'icons/roguetown/items/lighting.dmi'
	name = "艾欧拉之烛"
	desc = "一支相当可爱的蜡烛，泛着淡淡红晕。"
	color = "#f858b5ff"
	light_color = "#ff13d8ff"
	infinite = TRUE

/obj/item/candle/eora/lit
	start_lit = TRUE
	icon_state = "candle1_lit"

/obj/item/candle/infinite
	infinite = TRUE
	start_lit = TRUE

/obj/item/candle/skull
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "skullcandle"
	desc = "一种相当骇人的持烛方式。适合墓穴和尘封的古老图书馆。"
	infinite = TRUE

/obj/item/candle/skull/update_icon()
	icon_state = "skullcandle[lit ? "_lit" : ""]"

/obj/item/candle/skull/lit
	start_lit = TRUE
	icon_state = "skullcandle_lit"

/obj/item/candle/candlestick
	name = "烛台原型"
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "gcandelabra"
	infinite = TRUE
	desc = "赋予所有小型真烛台特性的烛台原型。你本不该看到这个，请上报。"
	possible_item_intents = list(/datum/intent/use, /datum/intent/hit) //so you can bash someone's head in with a candlestick
	force = 12 //slightly higher than a silver goblet, good improvised weapon, it even has a handle!

/obj/item/candle/candlestick/gold
	name = "三头金烛台"
	desc = "烛台的三头金制版本，每个烛台现在有更多烛臂和蜡烛。"
	icon_state = "gcandelabra"
	sellprice = 40

/obj/item/candle/candlestick/gold/update_icon()
	icon_state = "gcandelabra[lit ? "_lit" : ""]"

/obj/item/candle/candlestick/gold/lit
	icon_state = "gcandelabra_lit"
	start_lit = TRUE

/obj/item/candle/candlestick/silver
	name = "三头银烛台"
	desc = "烛台的三头银制版本，每个烛台现在有更多烛臂和蜡烛。"
	icon_state = "scandelabra"
	sellprice = 60
	is_silver = TRUE

/obj/item/candle/candlestick/silver/update_icon()
	icon_state = "scandelabra[lit ? "_lit" : ""]"

/obj/item/candle/candlestick/silver/lit
	icon_state = "scandelabra_lit"
	start_lit = TRUE

/obj/item/candle/candlestick/gold/single
	name = "单头金烛台"
	desc = "一根金色烛杆，末端有个小尖托，能稳稳插住蜡烛。真要走投无路，大概也能拿它敲人。"
	icon_state = "singlegcandelabra"
	sellprice = 30

/obj/item/candle/candlestick/gold/single/update_icon()
	icon_state = "singlegcandelabra[lit ? "_lit" : ""]"

/obj/item/candle/candlestick/gold/single/lit
	icon_state = "singlegcandelabra_lit"
	start_lit = TRUE

/obj/item/candle/candlestick/silver/single
	name = "单头银烛台"
	desc = "一根金色烛杆，末端有个小尖托，能稳稳插住蜡烛。真要走投无路，大概也能拿它敲人。"
	icon_state = "singlescandelabra"
	sellprice = 50

/obj/item/candle/candlestick/silver/single/update_icon()
	icon_state = "singlescandelabra[lit ? "_lit" : ""]"

/obj/item/candle/candlestick/silver/single/lit
	icon_state = "singlescandelabra_lit"
	start_lit = TRUE

/obj/item/candle/gold
	name = "金蜡烛"
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "gcandle"
	sellprice = 30

/obj/item/candle/gold/update_icon()
	icon_state = "gcandle[lit ? "_lit" : ""]"

/obj/item/candle/gold/lit
	icon_state = "gcandle_lit"
	start_lit = TRUE

/obj/item/candle/silver
	name = "银蜡烛"
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "scandle"
	infinite = TRUE
	sellprice = 50
	is_silver = TRUE

/obj/item/candle/silver/update_icon()
	icon_state = "scandle[lit ? "_lit" : ""]"

/obj/item/candle/silver/lit
	icon_state = "scandle_lit"
	start_lit = TRUE

#undef CANDLE_LUMINOSITY
