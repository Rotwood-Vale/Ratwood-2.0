/obj/item/ritechalk
	name = "仪式粉笔"
	icon_state = "chalk"
	desc = "普通的白色粉笔。举行仪式时的实用工具。"
	icon = 'icons/roguetown/misc/rituals.dmi'
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = FALSE
	dropshrink = 0.6

/obj/item/ritechalk/attack_self(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user, span_smallred("我根本不知道该拿这东西做什么......"))
		return

	var/ritechoices = list()
	switch (user.patron?.type)
		if(/datum/patron/inhumen/graggar)
			ritechoices+="Rune of Violence"
		if(/datum/patron/inhumen/zizo)
			ritechoices+="Rune of ZIZO"
		if(/datum/patron/inhumen/matthios)
			ritechoices+="Rune of Transaction"
		if(/datum/patron/inhumen/baotha)
			ritechoices+="Rune of Hedonism"
		if(/datum/patron/divine/astrata)
			ritechoices+="Rune of Sun"
		if(/datum/patron/divine/noc)
			ritechoices+="Rune of Moon"
		if(/datum/patron/divine/dendor)
			ritechoices+="Rune of Beasts"
		if(/datum/patron/divine/malum)
			ritechoices+="Rune of Forge"
		if(/datum/patron/divine/xylix)
			ritechoices+="Rune of Trickery"
		if(/datum/patron/divine/necra)
			ritechoices+="Rune of Death"
		if(/datum/patron/divine/pestra)
			ritechoices+="Rune of Plague"
		if(/datum/patron/divine/eora)
			ritechoices+="Rune of Love"
		if(/datum/patron/divine/ravox)
			ritechoices+="Rune of Justice"
		if(/datum/patron/divine/abyssor)
			ritechoices+="Rune of Storm"
			ritechoices+="Rune of Stirring"
		if(/datum/patron/old_god)
			ritechoices+="Rune of Enduring"

	if(HAS_TRAIT(user, TRAIT_DREAMWALKER) && !("Rune of Stirring" in ritechoices))
		ritechoices+="Rune of Stirring"

	var/runeselection = input(user, "我要刻下哪一道符文？", src) as null|anything in ritechoices
	var/turf/step_turf = get_step(get_turf(user), user.dir)
	switch(runeselection)
		if("Rune of Sun")
			to_chat(user,span_cultsmall("我开始刻画她的辉耀符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/astrata(step_turf)
		if("Rune of Moon")
			to_chat(user, span_cultsmall("我开始刻画祂的智慧符文。"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/noc(step_turf)
		if("Rune of Beasts")
			to_chat(user,span_cultsmall("我开始刻画祂的狂乱符文。"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/dendor(step_turf)
		if("Rune of Forge")
			to_chat(user,span_cultsmall("我开始刻画祂们的工艺符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/malum(step_turf)
		if("Rune of Trickery")
			to_chat(user,span_cultsmall("我开始刻画祂的诡计符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/xylix(step_turf)
		if("Rune of Death")
			to_chat(user,span_cultsmall("我开始刻画她的拥抱符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/necra(step_turf)
		if("Rune of Plague")
			to_chat(user,span_cultsmall("我开始刻画她的疫病符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/pestra(step_turf)
		if("Rune of Love")
			to_chat(user,span_cultsmall("我开始刻画她的爱之符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/eora(step_turf)
		if("Rune of Justice")
			to_chat(user,span_cultsmall("我开始刻画祂的正义符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/ravox(step_turf)
		if("Rune of Storm")
			to_chat(user,span_cultsmall("我开始刻画祂的风暴符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/abyssor(step_turf)
		if("Rune of Stirring")
			to_chat(user,span_cultsmall("我开始刻画祂的梦之符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/abyssor_alt_inactive(step_turf)
		if("Rune of ZIZO")
			to_chat(user,span_cultsmall("我开始刻画她的知识符文......"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/zizo(step_turf)
		if("Rune of Transaction")
			to_chat(user,span_cultsmall("我开始刻画祂的交易符文。"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/matthios(step_turf)
		if("Rune of Violence")
			to_chat(user,span_cultsmall("我开始刻画屠戮符文。"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/graggar(step_turf)
		if("Rune of Hedonism")
			to_chat(user,span_cultsmall("我开始刻画沉溺符文。"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/baotha(step_turf)
		if("Rune of Enduring")
			to_chat(user,span_cultsmall("我开始刻下祂的圣徽。"))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/psydon(step_turf)
