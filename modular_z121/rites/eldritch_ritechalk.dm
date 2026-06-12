// 异界仪式粉笔会根据使用者当前的信仰，绘制出对应神明的献祭法阵。
/proc/z121_get_sacrifice_circle_type(patron_type)
	switch(patron_type)
		if(/datum/patron/inhumen/graggar)
			return /obj/structure/ritualcircle/sacrifice/graggar
		if(/datum/patron/inhumen/zizo)
			return /obj/structure/ritualcircle/sacrifice/zizo
		if(/datum/patron/inhumen/matthios)
			return /obj/structure/ritualcircle/sacrifice/matthios
		if(/datum/patron/inhumen/baotha)
			return /obj/structure/ritualcircle/sacrifice/baotha
		if(/datum/patron/divine/astrata)
			return /obj/structure/ritualcircle/sacrifice/astrata
		if(/datum/patron/divine/noc)
			return /obj/structure/ritualcircle/sacrifice/noc
		if(/datum/patron/divine/dendor)
			return /obj/structure/ritualcircle/sacrifice/dendor
		if(/datum/patron/divine/malum)
			return /obj/structure/ritualcircle/sacrifice/malum
		if(/datum/patron/divine/xylix)
			return /obj/structure/ritualcircle/sacrifice/xylix
		if(/datum/patron/divine/necra)
			return /obj/structure/ritualcircle/sacrifice/necra
		if(/datum/patron/divine/pestra)
			return /obj/structure/ritualcircle/sacrifice/pestra
		if(/datum/patron/divine/eora)
			return /obj/structure/ritualcircle/sacrifice/eora
		if(/datum/patron/divine/ravox)
			return /obj/structure/ritualcircle/sacrifice/ravox
		if(/datum/patron/divine/abyssor)
			return /obj/structure/ritualcircle/sacrifice/abyssor
		if(/datum/patron/old_god)
			return /obj/structure/ritualcircle/sacrifice/psydon
	return null

/proc/z121_get_sacrifice_circle_name(patron_type)
	switch(patron_type)
		if(/datum/patron/inhumen/graggar)
			return "格拉加尔的献祭法阵"
		if(/datum/patron/inhumen/zizo)
			return "齐佐的献祭法阵"
		if(/datum/patron/inhumen/matthios)
			return "马西奥斯的献祭法阵"
		if(/datum/patron/inhumen/baotha)
			return "巴奥莎的献祭法阵"
		if(/datum/patron/divine/astrata)
			return "阿斯特拉塔的献祭法阵"
		if(/datum/patron/divine/noc)
			return "诺克的献祭法阵"
		if(/datum/patron/divine/dendor)
			return "登多尔的献祭法阵"
		if(/datum/patron/divine/malum)
			return "玛勒姆的献祭法阵"
		if(/datum/patron/divine/xylix)
			return "赛利克斯的献祭法阵"
		if(/datum/patron/divine/necra)
			return "内克拉的献祭法阵"
		if(/datum/patron/divine/pestra)
			return "佩斯特拉的献祭法阵"
		if(/datum/patron/divine/eora)
			return "伊欧拉的献祭法阵"
		if(/datum/patron/divine/ravox)
			return "拉沃克斯的献祭法阵"
		if(/datum/patron/divine/abyssor)
			return "阿比索尔的献祭法阵"
		if(/datum/patron/old_god)
			return "普赛顿的献祭法阵"
	return null

/obj/item/ritechalk/eldritch
	name = "异界仪式粉笔"
	desc = "浸透异界气息的仪式粉笔。它会顺着使用者的信仰，描绘出对应神明的献祭法阵。"

/obj/item/ritechalk/eldritch/attack_self(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user, span_smallred("我不明白该如何驱使这股异界仪式之力。"))
		return

	var/patron_type = user.patron?.type
	if(!patron_type)
		to_chat(user, span_smallred("没有信仰指引，这根粉笔也无从回应。"))
		return

	var/circle_type = z121_get_sacrifice_circle_type(patron_type)
	var/circle_name = z121_get_sacrifice_circle_name(patron_type)
	if(!circle_type || !circle_name)
		to_chat(user, span_smallred("这股异界力量没有回应我的信仰。"))
		return

	var/turf/step_turf = get_step(get_turf(user), user.dir)
	if(!isturf(step_turf))
		return

	to_chat(user, span_cultsmall("我开始描绘[circle_name]。"))
	if(do_after(user, 30, src))
		playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
		new circle_type(step_turf)
