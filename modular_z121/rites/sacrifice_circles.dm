// 龙魂觉醒仪式会消耗施术者手中的虚空石，因此需要统一的查找入口。
/proc/z121_find_dragon_voidstone(mob/living/carbon/human/H)
	if(!H)
		return null
	var/obj/item/magic/voidstone/active_voidstone = H.get_active_held_item()
	if(istype(active_voidstone))
		return active_voidstone
	var/obj/item/magic/voidstone/inactive_voidstone = H.get_inactive_held_item()
	if(istype(inactive_voidstone))
		return inactive_voidstone
	return null

// 献祭法阵沿用原版 ritual circle 基类，便于保留擦除和梦行者限制等现有规则。
/obj/structure/ritualcircle/sacrifice
	name = "献祭法阵"
	desc = "一道在异界回响中绘成的献祭法阵。"
	icon_state = "psydon_chalky"
	var/patron_type = null
	var/ritual_title = "献祭仪式"
	var/list/sacrifice_rites = list()

/obj/structure/ritualcircle/sacrifice/attack_hand(mob/living/user)
	if(!..())
		return
	if(patron_type && (user.patron?.type != patron_type))
		to_chat(user, span_smallred("我不知该如何向这道法阵献祭。"))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user, span_smallred("我不知该如何向这道法阵献祭。"))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user, span_smallred("我今日已经完成了足够多的仪式，必须先休息。"))
		return
	if(!sacrifice_rites?.len)
		to_chat(user, span_notice("这道献祭法阵此刻没有回应我的仪式请求。"))
		return

	var/riteselection = input(user, ritual_title, src) as null|anything in sacrifice_rites
	if(!riteselection)
		return
	perform_sacrifice_rite(riteselection, user)

/obj/structure/ritualcircle/sacrifice/proc/perform_sacrifice_rite(riteselection, mob/living/user)
	to_chat(user, span_notice("这道献祭法阵暂时还没有可以完成的仪式。"))
	return FALSE

/obj/structure/ritualcircle/sacrifice/proc/reset_rune_state()
	icon_state = initial(icon_state)

/obj/structure/ritualcircle/sacrifice/astrata
	name = "阿斯特拉塔的献祭法阵"
	desc = "一道献给阿斯特拉塔的献祭法阵，暖意在纹路间缓缓流转。"
	icon_state = "astrata_chalky"
	patron_type = /datum/patron/divine/astrata

/obj/structure/ritualcircle/sacrifice/noc
	name = "诺克的献祭法阵"
	desc = "一道献给诺克的献祭法阵，月色般的幽辉停留其上。"
	icon_state = "noc_chalky"
	patron_type = /datum/patron/divine/noc

/obj/structure/ritualcircle/sacrifice/dendor
	name = "登多尔的献祭法阵"
	desc = "一道献给登多尔的献祭法阵，野性与古老鳞息在其上翻涌。"
	icon_state = "dendor_chalky"
	patron_type = /datum/patron/divine/dendor
	ritual_title = "登多尔的献祭仪式"
	sacrifice_rites = list("龙魂觉醒")

/obj/structure/ritualcircle/sacrifice/dendor/perform_sacrifice_rite(riteselection, mob/living/user)
	switch(riteselection)
		if("龙魂觉醒")
			return dragon_soul_awakening(user)
	return ..()

/obj/structure/ritualcircle/sacrifice/dendor/proc/dragon_soul_awakening(mob/living/user)
	if(!ishuman(user))
		to_chat(user, span_smallred("只有凡人的血肉之躯才能承受这场献祭。"))
		return FALSE

	var/mob/living/carbon/human/H = user
	if(!z121_is_dragon_wildshape_eligible(H))
		to_chat(H, span_smallred("只有信仰登多尔的德鲁伊，才能完成龙魂觉醒。"))
		return FALSE

	if(H.mind?.has_spell(/obj/effect/proc_holder/spell/self/wildshape/dragon, TRUE))
		to_chat(H, span_notice("龙魂早已在我体内苏醒，无需再次献祭。"))
		return FALSE

	if(!z121_find_dragon_voidstone(H))
		to_chat(H, span_smallred("我必须手持一枚虚空石，才能唤来龙魂的回应。"))
		return FALSE

	if(!do_after(H, 50))
		return FALSE
	H.say("树父啊，请聆听我的献祭！")
	playsound(loc, 'sound/vo/mobs/vw/idle (1).ogg', 100, FALSE, -1)

	if(!do_after(H, 50))
		return FALSE
	H.say("我献上虚空之核，恳请你赐我龙魂！")
	playsound(loc, 'sound/vo/mobs/vw/idle (4).ogg', 100, FALSE, -1)

	if(!do_after(H, 30))
		return FALSE

	var/obj/item/magic/voidstone/offering = z121_find_dragon_voidstone(H)
	if(!offering)
		to_chat(H, span_smallred("失去了手中的虚空石，龙魂觉醒的献祭就此中断。"))
		return FALSE

	if(H.mind?.has_spell(/obj/effect/proc_holder/spell/self/wildshape/dragon, TRUE))
		to_chat(H, span_notice("龙魂早已在我体内苏醒，无需再次献祭。"))
		return FALSE

	icon_state = "dendor_active"
	loc.visible_message(span_warning("[H] 在法阵前发出低沉的咆哮，古老的龙魂随之翻涌！"))
	playsound(loc, 'sound/vo/mobs/wwolf/howl (2).ogg', 100, FALSE, -1)
	qdel(offering)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/wildshape/dragon, H)
	H.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
	H.flash_fullscreen("redflash3")
	H.emote("agony")
	to_chat(H, span_notice("登多尔收下了这枚虚空石。龙魂在我体内苏醒，我现在可以施放荒野形态-龙了。"))
	addtimer(CALLBACK(src, PROC_REF(reset_rune_state)), 120)
	return TRUE

/obj/structure/ritualcircle/sacrifice/malum
	name = "玛勒姆的献祭法阵"
	desc = "一道献给玛勒姆的献祭法阵，锤痕与火星在符线间静静沉淀。"
	icon_state = "malum_chalky"
	patron_type = /datum/patron/divine/malum

/obj/structure/ritualcircle/sacrifice/xylix
	name = "赛利克斯的献祭法阵"
	desc = "一道献给赛利克斯的献祭法阵，诡笑似乎仍在法阵边缘回响。"
	icon_state = "xylix_chalky"
	patron_type = /datum/patron/divine/xylix

/obj/structure/ritualcircle/sacrifice/necra
	name = "内克拉的献祭法阵"
	desc = "一道献给内克拉的献祭法阵，寒意如同送葬般缠绕其上。"
	icon_state = "necra_chalky"
	patron_type = /datum/patron/divine/necra

/obj/structure/ritualcircle/sacrifice/pestra
	name = "佩斯特拉的献祭法阵"
	desc = "一道献给佩斯特拉的献祭法阵，病与生在其上反复轮转。"
	icon_state = "pestra_chalky"
	patron_type = /datum/patron/divine/pestra

/obj/structure/ritualcircle/sacrifice/eora
	name = "伊欧拉的献祭法阵"
	desc = "一道献给伊欧拉的献祭法阵，柔和而危险的情感在法阵间悄然漫开。"
	icon_state = "eora_chalky"
	patron_type = /datum/patron/divine/eora

/obj/structure/ritualcircle/sacrifice/ravox
	name = "拉沃克斯的献祭法阵"
	desc = "一道献给拉沃克斯的献祭法阵，庄严的锋芒凝在每一笔刻痕里。"
	icon_state = "ravox_chalky"
	patron_type = /datum/patron/divine/ravox

/obj/structure/ritualcircle/sacrifice/abyssor
	name = "阿比索尔的献祭法阵"
	desc = "一道献给阿比索尔的献祭法阵，潮声与雷鸣在暗处低语。"
	icon_state = "abyssor_chalky"
	patron_type = /datum/patron/divine/abyssor

/obj/structure/ritualcircle/sacrifice/zizo
	name = "齐佐的献祭法阵"
	desc = "一道献给齐佐的献祭法阵，秘密与知识像阴影一样流动。"
	icon_state = "zizo_chalky"
	patron_type = /datum/patron/inhumen/zizo

/obj/structure/ritualcircle/sacrifice/matthios
	name = "马西奥斯的献祭法阵"
	desc = "一道献给马西奥斯的献祭法阵，交易与代价在其中无声对价。"
	icon_state = "matthios_chalky"
	patron_type = /datum/patron/inhumen/matthios

/obj/structure/ritualcircle/sacrifice/graggar
	name = "格拉加尔的献祭法阵"
	desc = "一道献给格拉加尔的献祭法阵，暴戾的血气在纹路间鼓噪。"
	icon_state = "graggar_chalky"
	patron_type = /datum/patron/inhumen/graggar

/obj/structure/ritualcircle/sacrifice/baotha
	name = "巴奥莎的献祭法阵"
	desc = "一道献给巴奥莎的献祭法阵，甜美与沉沦在其中缓慢发酵。"
	icon_state = "baotha_chalky"
	patron_type = /datum/patron/inhumen/baotha

/obj/structure/ritualcircle/sacrifice/psydon
	name = "普赛顿的献祭法阵"
	desc = "一道献给普赛顿的献祭法阵，古老而顽固的意志沉睡其间。"
	icon_state = "psydon_chalky"
	patron_type = /datum/patron/old_god
