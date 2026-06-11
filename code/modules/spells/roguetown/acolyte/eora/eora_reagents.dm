//Dummy fluid for effect
/datum/reagent/medicine/revival_fluid
	name = "Eora 灵膏"
	description = "一种奇迹般的液体，会缓慢治愈死者，在伤口弥合后将其重新带回人世。"
	color = "#cd2be2"
	metabolization_rate = REAGENTS_METABOLISM
	taste_description = "冰冷的希望"

/obj/item/reagent_containers/glass/bottle/revival
	name = "一瓶 Eora 灵膏"
	desc = "瓶中是不祥的紫罗兰色液体，仿佛正随着微光轻轻脉动。容器由奇异的闪烁玻璃制成，看起来十分脆弱。"
	list_reagents = list(/datum/reagent/medicine/revival_fluid = 48)

/obj/item/reagent_containers/glass/bottle/revival/attack(mob/living/M, mob/living/user)
	if(M.stat < DEAD)
		to_chat(user, "他们还没死！")
		return FALSE
	if(!M.mind)
		to_chat(user, "[M] 的心脏已经沉寂。")
		return FALSE

	. = ..()
	if(iscarbon(M))
		if(HAS_TRAIT(M, TRAIT_DNR) && M.stat == DEAD)
			to_chat(user, span_warning("[M] 再也不可能回来了。"))
			return FALSE
		M.apply_status_effect(/datum/status_effect/buff/eoran_balm_effect)
	to_chat(user, span_notice("这只瓶子在使用后碎裂了！"))
	qdel(src)
	return TRUE
