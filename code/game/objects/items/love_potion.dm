//Love potion - Charged Pink
/obj/item/lovepotion
	name = "爱情魔药"
	desc = "一瓶粉色药剂，散发着若有若无的甜美果香。标签上写着“爱情魔药”，声称它几乎能让任何人都对你心生渴望。"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "lovebottle"
	grid_width = 64
	grid_height = 64
	dropshrink = 0.8

/obj/item/lovepotion/attack(mob/living/carbon/human/M, mob/user)
	if(!isliving(M) || M.stat == DEAD)
		to_chat(user, span_warning("爱情魔药只能被活物代谢。我最好别白白浪费它！"))
		return ..()
	if(user == M)
		to_chat(user, span_warning("我自己喝下这药太冒险了。我该把它喂给我所渴求的人！"))
		return ..()
	if(M.has_status_effect(STATUS_EFFECT_INLOVE))
		to_chat(user, span_warning("[M]早已被对别人的痴迷吞没了！"))
		return ..()

	M.visible_message(span_danger("[user]开始给[M]灌下爱情魔药！"),
		span_danger("[user]开始给你灌下爱情魔药！"))

	if(!do_after(user, 50, target = M))
		return
	to_chat(user, span_notice("我给[M]灌下了爱情魔药！"))
	to_chat(M, span_notice("药液顺着喉咙流下时，我尝到了草莓的味道。心脏在胸腔中剧烈跳动，脑海也渐渐被关于[user]的念头所吞没。无论这是真爱，还是痴狂执念，都已经无关紧要。因为[user]终将属于我。"))
	if(M.mind)
		M.mind.store_memory("你痴迷于[user]。")
	M.faction |= "[REF(user)]"
	M.apply_status_effect(STATUS_EFFECT_INLOVE, user)
	qdel(src)
