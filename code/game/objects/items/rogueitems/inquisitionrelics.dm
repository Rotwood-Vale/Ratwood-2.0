// Reliquary Box and key - The Box Which contains these
/obj/structure/reliquarybox
	name = "奥塔凡圣髑匣"
	desc = "一个令人不安的赤红匣柜，锁头结构极其繁复。它似乎只适配某一把特定钥匙。谨慎抉择。"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "chestweird1"
	anchored = TRUE
	density = TRUE
	var/opened = FALSE

/obj/item/roguekey/psydonkey
	icon_state = "birdkey"
	name = "圣髑匣钥匙"
	desc = "一把只能使用一次，却足以放出灾厄的钥匙。谨慎抉择。"

/obj/structure/reliquarybox/attackby(obj/item/W, mob/user, params)
	if(ishuman(user))
		if(istype(W, /obj/item/roguekey/psydonkey))
			if(opened)
				to_chat(user, span_info("圣髑匣已经被打开过了……"))
				return
			qdel(W)
			to_chat(user, span_info("圣髑匣开启时吞没了我手中的钥匙，我不由得思索，究竟有何等力量被赐予了我们……"))
			playsound(loc, 'sound/foley/doors/lock.ogg', 60)
			to_chat(user,)
			var/relics = list("忧郁手摇匣 - 反魔法", "破晓 - 白银长鞭", "圣痕 - 白银长戟", "伪典 - 白银巨剑", "Golgatha - SYON 碎片香炉")
			var/relicchoice = input(user, "选择你的器物", "圣遗物") as anything in relics
			var/obj/choice
			switch(relicchoice)
				if("忧郁手摇匣 - 反魔法")
					choice = /obj/item/psydonmusicbox
				if("破晓 - 白银长鞭")
					choice = /obj/item/rogueweapon/whip/antique/psywhip
				if("圣痕 - 白银长戟")
					choice = /obj/item/rogueweapon/halberd/psyhalberd
					user.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)	//We make sure the weapon is usable by the Inquisitor.
				if("伪典 - 白银巨剑")
					choice = /obj/item/rogueweapon/greatsword/psygsword
					user.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)		//Ditto.
				if("Golgatha - SYON 碎片香炉")
					choice = /obj/item/flashlight/flare/torch/lantern/psycenser
			to_chat(user, span_info("我已选定圣遗物，愿祂引导我的手。"))
			var/obj/structure/closet/crate/chest/inqreliquary/realchest = new /obj/structure/closet/crate/chest/inqreliquary(get_turf(src))
			realchest.PopulateContents()
			choice = new choice(realchest)
			qdel(src)



// Soul Churner - Music box which applies magic resistance to Inquisition members, greatly mood debuffs everyone not a Psydon worshipper.
/obj/item/psydonmusicbox
	name = "忧郁手摇匣"
	desc = ""
	icon_state = "psydonmusicbox"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_HUGE
	var/cranking = FALSE
	force = 15
	max_integrity = 100
	attacked_sound = 'sound/combat/hits/onwood/education2.ogg'
	gripped_intents = list(/datum/intent/hit)
	possible_item_intents = list(/datum/intent/hit)
	obj_flags = CAN_BE_HIT
	twohands_required = TRUE
	var/datum/looping_sound/psydonmusicboxsound/soundloop

/obj/item/psydonmusicbox/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(usr, TRAIT_INQUISITION))
		desc = "一件出自奥塔凡大教堂秘法工坊深处的圣遗物。十四个异端的灵魂被束缚在一起，它们会尖啸，并替我们抵御魔法。最好别让异端知晓它的真相，只在危急时刻将其动用。"
	else
		desc = "一个手摇驱动的音乐匣，侧面印着奥塔凡宗教裁判所的徽记。它散发着沉重而阴郁的气息……"

/obj/item/psydonmusicbox/attack_self(mob/living/user)
	. = ..()
	if(!HAS_TRAIT(usr, TRAIT_INQUISITION))
		user.add_stress(/datum/stressevent/soulchurnerhorror)
		to_chat(user, (span_cultsmall("每摇动一次，我都能感受到那股痛苦，我到底在做什么？！")))
	cranking = !cranking
	update_icon()
	if(cranking)
		if(!HAS_TRAIT(user, INSPIRING_MUSICIAN))
			user.apply_status_effect(/datum/status_effect/buff/cranking_soulchurner)
		else if(alert(user, "要让这些声音和鸣，还是任其尖啸？", "魂魄搅磨匣", "和鸣", "尖啸") != "尖啸")
			user.apply_status_effect(/datum/status_effect/buff/quelling_soulchurner)
		else
			user.apply_status_effect(/datum/status_effect/buff/cranking_soulchurner)
		soundloop.start()
		var/songhearers = view(7, user)
		for(var/mob/living/carbon/human/target in songhearers)
			to_chat(target,span_cultsmall("[user]开始摇动魂魄搅磨匣……"))
	if(!cranking)
		soundloop.stop()
		user.remove_status_effect(/datum/status_effect/buff/cranking_soulchurner)
		user.remove_status_effect(/datum/status_effect/buff/quelling_soulchurner)

/obj/item/psydonmusicbox/Initialize(mapload)
	soundloop = new(src, FALSE)
	. = ..()

/obj/item/psydonmusicbox/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	src.visible_message(span_cult("无数灵魂如洪流般从破裂的匣中逃出！"))
	return ..()

/obj/item/psydonmusicbox/update_icon()
	if(cranking)
		icon_state = "psydonmusicbox_active"
	else
		icon_state = "psydonmusicbox"

/obj/item/psydonmusicbox/dropped(mob/living/user, silent)
	..()
	cranking = FALSE
	update_icon()
	if(soundloop)
		soundloop.stop()
		user.remove_status_effect(/datum/status_effect/buff/cranking_soulchurner)
		user.remove_status_effect(/datum/status_effect/buff/quelling_soulchurner)

/obj/item/psydonmusicbox/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 0,"nx" = 11,"ny" = 1,"wx" = 0,"wy" = 1,"ex" = 4,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = 0,"wturn" = 0,"eturn" = 39,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 8)

/atom/movable/screen/alert/status_effect/buff/cranking_soulchurner
	name = "摇动中的魂魄搅磨匣"
	desc = "我正让这扭曲的器具苏醒……"
	icon_state = "buff"

/datum/status_effect/buff/cranking_soulchurner
	id = "crankchurner"
	alert_type = /atom/movable/screen/alert/status_effect/buff/cranking_soulchurner
	var/effect_color
	var/pulse = 0
	var/ticks_to_apply = 10
	var/astratanlines =list("'她的光已离我而去！我这是在哪？！'", "'砸碎这鬼东西吧，让我最后再感受一次她的温暖！'", "'我是王族……他们为什么要这样对我……？'")
	var/noclines =list("'比月光还要寒冷……'", "'再没有任何智慧能触及我了……'", "'求求你帮帮我，我想念群星……'")
	var/necralines =list("'他们把我从她的掌握中夺走了，只留下永恒的折磨……'", "'Necra！求求你！我太累了！放我走吧！'", "'我迷失了，迷失在一片被窃取的终局之海里。'")
	var/abyssorlines =list("'我再也感受不到海岸上的风了……'", "'我们在这里被搅得比鱼群还要紧密……'", "'求你放了我吧，让我回到大海……'")
	var/ravoxlines =list("'Ravox 的同道！砍下这个 Otava 狗崽子的脑袋！把我从这该死的妖术里放出去！'", "'这里既无公义，也无荣耀，只有无穷无尽的疲惫……'", "'我曾祈求一场死于刀剑之下的结局……'")
	var/pestralines =list("'我只是想让自己的药方更加完善……'", "'愿千重瘟疫降临在这台被诅咒机器的持有者身上！Pestra！你听不见我吗？！'", "'我能感到他们从我身边擦过时所承受的痛苦……'")
	var/eoralines =list("'每一次抚触都像有千万根骨头同时碎裂……'", "'她是异端，可我又怎么下得去手伤害她？！'", "'对不起！我只是想要和平！求你放了我！'")
	var/dendorlines =list("'祂的疯狂正在呼唤我！呃啊啊……'", "'砸碎这口箱子吧，好让我们用泥土与根须呛死这个 Otava 人！'", "'我想念叶间回响的祂之声……求你放我出去……'")
	var/xylixlines =list("'一、二、三、四，二、二、三、四。怎么，你觉得这很烦？'", "'你知道吗，这里面还有十三个别的家伙！多棒的观众啊，他们甚至连座位都离不开！'", "'我当然全押了！我还以为他手里只是高牌 A 呢！'", "'不，XYLIX'S FORTUNE 没说错，这回的情况确实糟得很。'")
	var/malumlines =list("'这台遭诅咒机器的结构是可以被重塑的……求你把它砸开……'", "'我的技艺本能改变整个世界……'", "'放我出去吧，让我回到我的学徒身边，求你了……'")
	var/matthioslines =list("'我最后一笔交易……他再也收不到我应有的价值了……全被这些怪物夺走了……'", "'同道啊，我被锁进了这可怖的机关里，放我出去！'", "'我能感觉到我们的镣铐正彼此纠缠着……'")
	var/zizolines =list("'ZIZO！我的魔法失灵了！把这些 PSYDONIAN 狗崽子全都劈死！'", "'密教徒？这里有扭曲的魔法，提防那音乐！我们的声音全被强迫着唱了出来！'", "'毁掉这口箱子，杀了持有者。你们的魔法就能得到自由。'")
	var/graggarlines =list("'受膏者！砍下这个 Otava 人的脑袋！'", "'受膏者！砸碎这口箱子，我们就能一起把他们杀光！'", "'GRAGGAR，赐我力量，让我挣断自己的枷锁！'")
	var/baothalines =list("'我怀念 ozium 的温度……在这里我什么也感觉不到……'", "'放纵之徒，把我从这机关里救出去吧，我有的是东西想与你分享。'", "'我的完美，全被这些 Otava 怪物夺走了！'")
	var/psydonianlines =list("'放我们出去！放我们出去！我们受的苦已经够多了！'", "'求求你，放了我们！", "我们想念自己的家人！'", "'等我们逃出去，就会一路追杀你到坟墓里。'")
/datum/status_effect/buff/cranking_soulchurner/on_creation(mob/living/new_owner, stress, colour)
	effect_color = "#800000"
	return ..()

/datum/status_effect/buff/cranking_soulchurner/tick()
	var/obj/effect/temp_visual/music_rogue/M = new /obj/effect/temp_visual/music_rogue(get_turf(owner))
	M.color = "#800000"
	pulse += 1
	if (pulse >= ticks_to_apply)
		pulse = 0
		if(!HAS_TRAIT(owner, TRAIT_INQUISITION))
			owner.add_stress(/datum/stressevent/soulchurnerhorror)
		for (var/mob/living/carbon/human/H in hearers(7, owner))
			if (!H.client)
				continue
			if (!H.has_stress_event(/datum/stressevent/soulchurner))
				switch(H.patron?.type)
					if(/datum/patron/old_god)
						if (!H.has_stress_event(/datum/stressevent/soulchurnerpsydon))
							H.add_stress(/datum/stressevent/soulchurnerpsydon)
							to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
							to_chat(H, (span_cultsmall(pick(psydonianlines))))
						if(HAS_TRAIT(H, TRAIT_INQUISITION))
							H.apply_status_effect(/datum/status_effect/buff/churnerprotection)
					if(/datum/patron/inhumen/matthios)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(matthioslines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/inhumen/zizo)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(zizolines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/inhumen/graggar)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(graggarlines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/inhumen/baotha)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(baothalines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/astrata)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(astratanlines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/noc)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(noclines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/necra)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(necralines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/pestra)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(pestralines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/malum)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(malumlines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/dendor)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(dendorlines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/xylix)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(xylixlines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/eora)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(eoralines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/abyssor)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(abyssorlines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/ravox)
						to_chat(H, (span_hypnophrase("歌声中有一道声音正在呼唤你……")))
						to_chat(H, (span_cultsmall(pick(ravoxlines))))
						H.add_stress(/datum/stressevent/soulchurner)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)

/atom/movable/screen/alert/status_effect/buff/quelling_soulchurner
	name = "镇抚中的魂魄搅磨匣"
	desc = "我正让这扭曲的器具苏醒，压下那些声音……"
	icon_state = "buff"

/datum/status_effect/buff/quelling_soulchurner
	id = "quellchurner"
	alert_type = /atom/movable/screen/alert/status_effect/buff/quelling_soulchurner
	var/effect_color
	var/pulse = 0
	var/ticks_to_apply = 10

/datum/status_effect/buff/quelling_soulchurner/on_creation(mob/living/new_owner, stress, colour)
	effect_color = "#800000"
	return ..()

/datum/status_effect/buff/quelling_soulchurner/tick()
	var/obj/effect/temp_visual/music_rogue/M = new /obj/effect/temp_visual/music_rogue(get_turf(owner))
	M.color = "#800000"
	pulse += 1
	if (pulse >= ticks_to_apply)
		pulse = 0
		if(!HAS_TRAIT(owner, TRAIT_INQUISITION))
			owner.add_stress(/datum/stressevent/soulchurnerhorror)
		for (var/mob/living/carbon/human/H in hearers(7, owner))
			if(!H.client)
				continue
			if(HAS_TRAIT(H, TRAIT_INQUISITION))
				H.apply_status_effect(/datum/status_effect/buff/churnerprotection)
/*
Inquisitorial armory down here

/obj/structure/closet/crate/chest/inqarmory

/obj/structure/closet/crate/chest/inqarmory/PopulateContents()
	.=..()
	new /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger(src)
	new /obj/item/rogueweapon/greatsword/psygsword(src)
	new /obj/item/rogueweapon/halberd/psyhalberd(src)
	new /obj/item/rogueweapon/whip/psywhip_lesser
	new /obj/item/rogueweapon/flail/sflail/psyflail
	new /obj/item/rogueweapon/spear/psyspear(src)
	new /obj/item/rogueweapon/sword/long/psysword(src)
	new /obj/item/rogueweapon/mace/goden/psy(src)
	new /obj/item/rogueweapon/stoneaxe/battle/psyaxe(src)
	*/

/obj/item/flashlight/flare/torch/lantern/psycenser
	name = "Golgatha香炉"
	desc = "一具工艺精绝的香炉，开启时会散发出阴森香气，令普希冬信徒的血肉与钢铁再度振奋。据说其中封存着 SYON 彗星的一块不稳定碎片，若处置失当，后果难料。"
	icon_state = "psycenser"
	item_state = "psycenser"
	light_outer_range = 8
	light_color ="#70d1e2"
	possible_item_intents = list(/datum/intent/mace/smash/flail/golgotha)
	fuel = 999 MINUTES
	force = 30
	var/next_smoke
	var/smoke_interval = 2 SECONDS
	is_silver = TRUE //container uses the same color palette as blessed silver and it also contains part of the comet syon

/obj/item/flashlight/flare/torch/lantern/psycenser/examine(mob/user)
	. = ..()
	if(fuel > 0)
		. += span_info("若将其开启，它或许能祝福普希冬的武器与信奉普希冬者。")
		. += span_warning("在开启状态下用它猛砸生物，会引发毁灭性爆炸并使其彻底报废。")
	if(fuel <= 0)
		. += span_info("它已经耗尽了。")

/obj/item/flashlight/flare/torch/lantern/psycenser/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -2,"sy" = -4,"nx" = 9,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 2,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 45, "sturn" = 45,"wturn" = 45,"eturn" = 45,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 45,"sturn" = 45,"wturn" = 45,"eturn" = 45,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/flashlight/flare/torch/lantern/psycenser/attack_self(mob/user)
	if(fuel > 0)
		if(on)
			turn_off()
			possible_item_intents = list(/datum/intent/mace/smash/flail/golgotha)
			user.update_a_intents()
		else
			playsound(src.loc, 'sound/items/censer_on.ogg', 100)
			possible_item_intents = list(/datum/intent/mace/smash/flail/golgotha, /datum/intent/bless)
			user.update_a_intents()
			on = TRUE
			update_brightness()
			//force = on_damage
			if(soundloop)
				soundloop.start()
			if(ismob(loc))
				var/mob/M = loc
				M.update_inv_hands()
			START_PROCESSING(SSobj, src)
	else if(fuel <= 0 && user.used_intent.type == /datum/intent/weep)
		to_chat(user, span_info("它已经耗尽了。你不禁悲从中来。"))
		user.emote("cry")

/obj/item/flashlight/flare/torch/lantern/psycenser/process()
	if(on && next_smoke < world.time)
		new /obj/effect/temp_visual/censer_dust(get_turf(src))
		next_smoke = world.time + smoke_interval


/obj/item/flashlight/flare/torch/lantern/psycenser/turn_off()
	playsound(src.loc, 'sound/items/censer_off.ogg', 100)
	if(soundloop)
		soundloop.stop()
	STOP_PROCESSING(SSobj, src)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()
		M.update_inv_belt()
	damtype = BRUTE


/obj/item/flashlight/flare/torch/lantern/psycenser/fire_act(added, maxstacks)
	return

/obj/item/flashlight/flare/torch/lantern/psycenser/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()	//We smashed a guy with it turned on. Bad idea!
	if(ismob(A) && on && (user.used_intent.type == /datum/intent/mace/smash/flail/golgotha) && user.cmode)
		user.visible_message(span_warningbig("[user]猛砸露出的[src]，将其中的 SYON 碎片击得粉碎！"))
		explosion(get_turf(A),devastation_range = 2, heavy_impact_range = 3, light_impact_range = 4, flame_range = 2, flash_range = 4, smoke = FALSE)
		fuel = 0
		turn_off()
		icon_state = "psycenser-broken"
		possible_item_intents = list(/datum/intent/weep)
		user.update_a_intents()
		for(var/mob/living/carbon/human/H in view(get_turf(src)))
			if(H.patron?.type == /datum/patron/old_god)	//Psydonites get VERY depressed seeing an artifact get turned into an ulapool caber.
				H.add_stress(/datum/stressevent/syoncalamity)
	if(isitem(A) && on && user.used_intent.type == /datum/intent/bless)
		var/datum/component/silverbless/CP = A.GetComponent(/datum/component/silverbless)
		if(CP)
			if(!CP.is_blessed && (CP.silver_type & SILVER_PSYDONIAN))
				playsound(user, 'sound/magic/censercharging.ogg', 100)
				user.visible_message(span_info("[user]将[src]举在[A]上方……"))
				if(do_after(user, 50, target = A))
					CP.try_bless(BLESSING_PSYDONIAN)
					new /obj/effect/temp_visual/censer_dust(get_turf(A))
			else
				to_chat(user, span_info("它已经受过祝福了。"))
	if(ishuman(A) && on && (user.used_intent.type == /datum/intent/bless))
		var/mob/living/carbon/human/H = A
		if(H.patron?.type == /datum/patron/old_god)
			if(!H.has_status_effect(/datum/status_effect/buff/censerbuff))
				playsound(user, 'sound/magic/censercharging.ogg', 100)
				user.visible_message(span_info("[user]将[src]举在[A]上方……"))
				if(do_after(user, 50, target = A))
					H.apply_status_effect(/datum/status_effect/buff/censerbuff)
					to_chat(H, span_notice("彗星尘使你精神一振。"))
					playsound(H, 'sound/magic/holyshield.ogg', 100)
					new /obj/effect/temp_visual/censer_dust(get_turf(H))
			else
				to_chat(user, span_warning("他们已经受过祝福了。"))

		else
			to_chat(user, span_warning("他们并不与我们同信。"))

/datum/component/psyblessed
	var/is_blessed
	var/pre_blessed
	var/added_force
	var/added_blade_int
	var/added_int
	var/added_def
	var/silver

/datum/component/psyblessed/Initialize(preblessed = FALSE, force, blade_int, int, def, makesilver)
	if(!istype(parent, /obj/item/rogueweapon))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ITEM_OBJFIX, PROC_REF(on_fix))
	pre_blessed = preblessed
	added_force = force
	added_blade_int = blade_int
	added_int = int
	added_def = def
	silver = makesilver
	if(pre_blessed)
		apply_bless()

/datum/component/psyblessed/proc/on_examine(datum/source, mob/user, list/examine_list)
	if(!is_blessed)
		examine_list += span_info("<font color = '#cfa446'>此物可受彗星SYON残留碎片祝圣。在那之前，它这银与钢混杂的不纯合金还无法独自侵蚀非人之敌。</font>")
	if(is_blessed)
		examine_list += span_info("<font color = '#46bacf'>此物已受彗星SYON祝圣。</font>")
		if(silver)
			examine_list += span_info("它已被灌注了<b>白银</b>。")

/datum/component/psyblessed/proc/try_bless()
	if(!is_blessed)
		apply_bless()
		play_effects()
		return TRUE
	else
		return FALSE

/datum/component/psyblessed/proc/play_effects()
	if(isitem(parent))
		var/obj/item/I = parent
		playsound(I, 'sound/magic/holyshield.ogg', 100)
		I.visible_message(span_notice("彗星SYON的尘埃落在[I]上，它随之泛起力量的辉光！"))

/datum/component/psyblessed/proc/apply_bless()
	if(isitem(parent))
		var/obj/item/I = parent
		is_blessed = TRUE
		I.force += added_force
		if(I.force_wielded)
			I.force_wielded += added_force
		if(I.max_blade_int)
			I.max_blade_int += added_blade_int
			I.blade_int = I.max_blade_int
		I.max_integrity += added_int
		I.obj_integrity = I.max_integrity
		I.wdefense += added_def
		if(silver)
			I.is_silver = silver
			I.smeltresult = /obj/item/ingot/silver
		I.name = "受祝福的[I.name]"
		I.AddComponent(/datum/component/metal_glint)

// This is called right after the object is fixed and all of its force / wdefense values are reset to initial. We re-apply the relevant bonuses.
/datum/component/psyblessed/proc/on_fix()
	var/obj/item/rogueweapon/I = parent
	I.force += added_force
	if(I.force_wielded)
		I.force_wielded += added_force
	I.wdefense += added_def

/obj/effect/temp_visual/censer_dust
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	duration = 8

/obj/item/inqarticles/indexer
	name = "\improper 索引针"
	desc = "一支受祝福的安瓿，带有可伸缩的刃尖，旨在通过血液学进一步收集情报。持续从个体身上抽取血液，直至索引针发出闭锁声，再将其寄回奥塔瓦登记入册。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "indexer"
	item_state = "indexer"
	throw_speed = 3
	throw_range = 7
	grid_height = 32
	grid_width = 32
	throwforce = 15
	force = 4
	tool_behaviour = null
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP
	sharpness = IS_SHARP
	experimental_inhand = TRUE
	w_class = WEIGHT_CLASS_SMALL
	intdamage_factor = 0
	sellprice = 0
	verb_exclaim = "尖啸"
	var/cursedblood
	var/active
	var/mob/living/carbon/subject
	var/full
	var/timestaken
	var/working

/obj/item/inqarticles/indexer/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(active)
		playsound(user, 'sound/items/indexer_shut.ogg', 65, TRUE)
		possible_item_intents = list(/datum/intent/use)
		user.update_a_intents()
		if(!full)
			if(!timestaken)
				active = FALSE
				working = FALSE
				icon_state = "indexer"
			else
				icon_state = "indexer_full"
				working = FALSE
				active = FALSE
	update_icon()

/obj/item/inqarticles/indexer/dropped(mob/living/carbon/human/user, slot)
	. = ..()
	if(active)
		possible_item_intents = list(/datum/intent/use)
		user.update_a_intents()
		playsound(user, 'sound/items/indexer_shut.ogg', 65, TRUE)
		if(!full)
			if(!timestaken)
				active = FALSE
				working = FALSE
				icon_state = "indexer"
			else
				icon_state = "indexer_full"
				working = FALSE
				active = FALSE
	update_icon()

/obj/item/inqarticles/indexer/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/inqarticles/indexer/attack_self(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		if(!working)
			if(!active)
				if(!full)
					possible_item_intents = list(/datum/intent/use, /datum/intent/dagger/cut)
					tool_behaviour = TOOL_SCALPEL
					user.update_a_intents()
					playsound(src, 'sound/items/indexer_open.ogg', 75, FALSE, 3)
					if(timestaken)
						active = TRUE
						icon_state = "indexer_used"
					else
						active = TRUE
						icon_state = "indexer_ready"
				else
					to_chat(user, span_notice("它已经可以送回奥塔瓦了。"))
			else
				playsound(src, 'sound/items/indexer_shut.ogg', 75, FALSE, 3)
				possible_item_intents = list(/datum/intent/use)
				tool_behaviour = initial(tool_behaviour)
				user.update_a_intents()
				if(!full)
					if(!timestaken)
						active = FALSE
						icon_state = "indexer"
					else
						icon_state = "indexer_full"
						active = FALSE
		update_icon()
		return

/obj/item/inqarticles/indexer/proc/fullreset(mob/user)
	possible_item_intents = list(/datum/intent/use)
	user.update_a_intents()
	cursedblood = initial(cursedblood)
	working = initial(working)
	subject = initial(subject)
	full = initial(full)
	timestaken = initial(timestaken)
	desc = initial(desc)
	active = FALSE
	icon_state = "indexer"
	update_icon()

/obj/item/inqarticles/indexer/attack_right(mob/user)
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		if(alert(user, "要清空索引针吗？", "索引处理中……", "是", "否") != "否")
			playsound(src, 'sound/items/indexer_empty.ogg', 75, FALSE, 3)
			visible_message(span_warning("[src]将里面的内容彻底煮干了！"))
			fullreset(user)
		else
			return
	else
		return

/obj/item/inqarticles/indexer/proc/takeblood(mob/living/M, mob/living/user)
	if(timestaken >= 8)
		playsound(src, 'sound/items/indexer_finished.ogg', 75, FALSE, 3)
		working = FALSE
		full = TRUE
		visible_message(span_warning("[src]完成了抽血！"))
		active = FALSE
		desc += span_notice(" 它已经装满了！")
		if(cursedblood)
			playsound(src, 'sound/items/indexer_cursed.ogg', 100, FALSE, 3)
			possible_item_intents = list(/datum/intent/use)
			user.update_a_intents()
			active = FALSE
			working = TRUE
			icon_state = "indexer_cursed"
			update_icon()
			src.say("诅咒之血！")
			return
		icon_state = "indexer_primed"
		update_icon()
		return

	working = TRUE
	playsound(src, 'sound/items/indexer_working.ogg', 75, FALSE, 3)
	if(active && working && !full)
		if(do_after(user, 20, FALSE, M))
			M.flash_fullscreen("redflash3")
			subject = M
			if(!HAS_TRAIT(M, TRAIT_NOPAIN) || !HAS_TRAIT(M, TRAIT_NOPAINSTUN))
				if(prob(15))
					M.emote("whimper", forced = TRUE)
				else if(prob(15))
					M.emote("painmoan", forced = TRUE)
			desc = initial(desc)
			desc += span_notice(" 它装着[subject.real_name]的血液！")
			visible_message(span_warning("[src]正在从[M]身上抽取血液！"))
			playsound(M, 'sound/combat/hits/bladed/genstab (1).ogg', 30, FALSE, -1)
			timestaken++
			M.blood_volume = max(M.blood_volume-30, 0)
			M.handle_blood()
			icon_state = "indexer_used"
			if(M.mind)
				if(M.mind.has_antag_datum(/datum/antagonist/werewolf, FALSE))
					cursedblood = 3
				if(M.mind.has_antag_datum(/datum/antagonist/werewolf/lesser, FALSE))
					cursedblood = 2
				if(M.mind.has_antag_datum(/datum/antagonist/vampire, FALSE))
					cursedblood = 2
				if(M.mind.has_antag_datum(/datum/antagonist/vampire))
					cursedblood = 3
			update_icon()
			takeblood(M, user)
		else
			working = FALSE

/obj/item/inqarticles/indexer/attack(mob/living/M, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		if(!active)
			to_chat(user, span_warning("它还没有准备好。"))
			return
		if(subject)
			if(M != subject)
				return
		if(HAS_TRAIT(M, TRAIT_BLOODLOSS_IMMUNE))
			to_chat(user, span_warning("他们没有能供采样的血液。"))
			return
		if(istype(M, /mob/living/carbon/human/species/skeleton))
			to_chat(user, span_warning("我不觉得宗教裁判所如今会多重视骨髓。"))
			return
		if(!M.mind)
			return
		if(full)
			to_chat(user, span_warning("它已经满了。"))
			return
		visible_message(span_warning("[user]抬手要用[src]刺向[M]！"))
		if(do_after(user, 20, FALSE, M))
			takeblood(M, user)
		else
			return
	else
		to_chat(user, span_warning("我不知道该怎么用这个。"))

/obj/item/inqarticles/tallowpot
	name = "封蜡锅"
	desc = "一只用来盛放蜡料或熔化红脂蜡的小金属锅。便于给印戒蘸蜡并压出印痕。火把、提灯或蜡烛的热度就足以融化红脂蜡，用于给文书盖印。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "tallowpot"
	item_state = "tallowpot"
	dropshrink = 0.9
	throw_speed = 1
	throw_range = 3
	throwforce = 5
	possible_item_intents = list(/datum/intent/use)
	grid_height = 32
	grid_width = 32
	obj_flags = CAN_BE_HIT
	experimental_inhand = TRUE
	w_class = WEIGHT_CLASS_SMALL
	intdamage_factor = 0
	embedding = null
	var/obj/item/reagent_containers/food/snacks/tallow/loaded_tallow
	var/loaded_inquisitorial_tallow = FALSE
	var/remaining
	var/heatedup
	var/messageshown = 1
	sellprice = 0

/obj/item/inqarticles/tallowpot/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)	// For making sure it melts.

/obj/item/inqarticles/tallowpot/Destroy()
	loaded_tallow = null
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/inqarticles/tallowpot/process()
	if(loaded_tallow && QDELETED(loaded_tallow))
		loaded_tallow = null
		loaded_inquisitorial_tallow = FALSE
		remaining = 0
		update_icon()

	if(heatedup > 0)
		heatedup -= 4
		remaining = max(remaining - -20, 0)
		messageshown = 0
	else
		if(loaded_tallow)
			if(!messageshown)
				visible_message(span_info("The [loaded_tallow] in [src] hardens again."))
				messageshown = 1
			update_icon()
	if(remaining == 0)
		if(loaded_tallow && !QDELETED(loaded_tallow))
			QDEL_NULL(loaded_tallow)
		else
			loaded_tallow = null
		loaded_inquisitorial_tallow = FALSE
		update_icon()

/obj/item/inqarticles/tallowpot/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/reagent_containers/food/snacks/tallow))
		if(!loaded_tallow)
			if(user.transferItemToLoc(I, src, TRUE))
				loaded_tallow = I
				loaded_inquisitorial_tallow = istype(I, /obj/item/reagent_containers/food/snacks/tallow/red)
				remaining = 300
				update_icon()
		else
			to_chat(user, span_info("[src]里已经有 [loaded_tallow]了。"))

	if(istype(I, /obj/item/flashlight/flare/torch/))
		heatedup = 28
		visible_message(span_info("[user]用[I]加热着[src]。"))
		update_icon()

	if(istype(I, /obj/item/candle/)) //Could optimize this, probably. Allows candles to be used in lighting up the tallow, too.	Remove if torches and lampterns suddenly stop working for this.
		heatedup = 28
		visible_message(span_info("[user]用[I]加热着[src]。"))
		update_icon()

	if(istype(I, /obj/item/clothing/ring/signet))
		if(loaded_tallow && !loaded_inquisitorial_tallow)
			to_chat(user, span_warning("我必须使用审判庭蜡油来签署官方公文。"))
			return
		if(heatedup)
			var/obj/item/clothing/ring/signet/ring = I
			ring.tallowed = TRUE
			ring.update_icon()

	if(istype(I, /obj/item/seal))
		if(loaded_tallow && heatedup)
			var/obj/item/seal/seal = I
			seal.tallowed = TRUE
			seal.update_icon()

/obj/item/inqarticles/tallowpot/examine(mob/user)
	. = ..()
	if(!loaded_tallow || QDELETED(loaded_tallow))
		. += span_info("它是空的。")
		return
	if(loaded_inquisitorial_tallow)
		. += span_info("它当前装有审判庭火漆。")
	else if(istype(loaded_tallow, /obj/item/reagent_containers/food/snacks/tallow/soft))
		. += span_info("它当前装有软动物脂。")
	else
		. += span_info("它当前装有动物脂。")
	if(heatedup)
		. += span_notice("火漆已融化，可以进行盖印。")
	else
		. += span_warning("火漆已凝固，必须重新加热才能进行盖印。")


/obj/item/inqarticles/tallowpot/update_icon()
	. = ..()
	if(loaded_tallow && !QDELETED(loaded_tallow))
		if(istype(loaded_tallow, /obj/item/reagent_containers/food/snacks/tallow/soft))
			icon_state = "tallowpot_filled_soft"
			if(heatedup)
				icon_state = "tallowpot_melted_soft"
		else
			icon_state = "[initial(icon_state)]_filled"
			if(heatedup)
				icon_state = "[initial(icon_state)]_melted"
	else
		icon_state = "[initial(icon_state)]"


/obj/item/rope/inqarticles/inquirycord
	name = "审讯绳索"
	desc = "一段厚实的皮革审讯绳索，先后浸过圣水与染液，再经祝圣并缀入咒法。既适合拘捕敌人，也适合在最糟的时候重新穿装器具。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "inqcordage"
	item_state = "inqcordage"
	throw_speed = 1
	throw_range = 3
	throwforce = 5
	breakouttime = 8 SECONDS
	slipouttime = 900 // 1:30.
	possible_item_intents = list(/datum/intent/tie)
	cuffsound = 'sound/misc/cordage.ogg'
	grid_height = 32
	grid_width = 32
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	experimental_inhand = TRUE
	w_class = WEIGHT_CLASS_SMALL
	intdamage_factor = 0
	embedding = null
	sellprice = 0

/obj/item/rope/inqarticles/inquirycord/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/inqarticles/garrote // Do not give this item out freely to other classes. Do not subtype this item for other classes. This is intended purely as the Confessor's identifying sidegrade, and as a bonus for the Inspector INQ. I will be very sad if you disregard this comment. Thank you. - Yische.
	name = "\proper 缉拿绞索" // It's nonlethal. It's so silly and fun.
	desc = "一件更受普希冬白银教团隐秘派系偏爱的阴森器具；一段浸过圣水与染液、又经祝圣并缀入咒法的厚皮审讯绳索，被穿系在两枚铁环之间。极适合用于拘捕。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "garrote"
	item_state = "garrote"
	gripsprite = TRUE
	throw_speed = 3
	throw_range = 7
	grid_height = 32
	grid_width = 32
	throwforce = 15
	force_wielded = 0
	force = 0
	obj_flags = CAN_BE_HIT
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	experimental_inhand = TRUE
	wieldsound = TRUE
	max_integrity = 200
	w_class = WEIGHT_CLASS_SMALL
	can_parry = FALSE
	break_sound = 'sound/items/garrotebreak.ogg'
	gripped_intents = list(/datum/intent/garrote/grab, /datum/intent/garrote/choke)
	var/mob/living/victim
	var/obj/item/grabbing/currentgrab
	var/mob/living/lastcarrier
	var/active = FALSE
	intdamage_factor = 0
	var/choke_damage = 10
	integrity_failure = 0.01
	embedding = null
	sellprice = 0

/obj/item/inqarticles/garrote/obj_break(damage_flag)
	obj_broken = TRUE
	if(!ismob(loc))
		return
	var/mob/M = loc
	active = FALSE
	if(altgripped || wielded)
		ungrip(M, FALSE)
		wipeslate(lastcarrier)
		if(lastcarrier.pulling)
			lastcarrier.stop_pulling()
	if(break_sound)
		playsound(get_turf(src), break_sound, 80, TRUE)
	update_icon()
	to_chat(M, "[src]啪地一声断开了……！")
	name = "\proper 断裂的缉拿绞索"

/obj/item/inqarticles/garrote/update_damaged_state()
	icon_angle = initial(icon_angle)
	icon_state = "garrote_snap"

/obj/item/inqarticles/garrote/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/garrote/choke
	name = "勒喉"
	icon_state = "inchoke"
	desc = "用于开始勒晕目标。"
	no_attack = TRUE

/datum/intent/garrote/grab
	name = "缠绕"
	icon_state = "ingrab"
	desc = "用于把它绕到目标身上。"
	no_attack = TRUE

/obj/item/inqarticles/garrote/proc/wipeslate(mob/user)
	if(victim)
		REMOVE_TRAIT(victim, TRAIT_MUTE, "garroteCordage")
		REMOVE_TRAIT(victim, TRAIT_GARROTED, TRAIT_GENERIC)
		victim = null
		currentgrab = null
	if(wielded)
		ungrip(user, FALSE)
		active = FALSE
		playsound(loc, 'sound/items/garroteshut.ogg', 65, TRUE)

/obj/item/inqarticles/garrote/attack_self(mob/user)
	if(obj_broken)
		to_chat(user, span_warning("它现在已经没用了，不过……"))
		to_chat(user, span_notice("我还能用更多绳索或粗绳把它重新穿好。"))
		return
	if(wielded)
		ungrip(user, FALSE)
		active = FALSE
		if(user.pulling)
			user.stop_pulling()
		playsound(loc, 'sound/items/garroteshut.ogg', 65, TRUE)
		wipeslate(user)
		return
	if(gripped_intents)
		wield(user, FALSE)
		active = TRUE
		if(wielded)
			playsound(loc, pick('sound/items/garrote.ogg', 'sound/items/garrote2.ogg'), 65, TRUE)
			return

/obj/item/inqarticles/garrote/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	lastcarrier = user
	wipeslate(lastcarrier)
	if(active)
		if(lastcarrier.pulling)
			lastcarrier.stop_pulling()
		playsound(user, 'sound/items/garroteshut.ogg', 65, TRUE)
		active = FALSE
	if(!obj_broken)
		if(icon_state != initial(icon_state))
			icon_state = initial(icon_state)
			icon_angle = initial(icon_angle)

/obj/item/inqarticles/garrote/dropped(mob/user, silent)
	. = ..()
	wipeslate(lastcarrier)
	if(active)
		if(lastcarrier.pulling)
			lastcarrier.stop_pulling()
		playsound(user, 'sound/items/garroteshut.ogg', 65, TRUE)
		active = FALSE
	if(!obj_broken)
		if(icon_state != initial(icon_state))
			icon_state = initial(icon_state)
			icon_angle = initial(icon_angle)

/obj/item/inqarticles/garrote/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/rope/inqarticles/inquirycord) || (istype(I, /obj/item/rope) && !istype(I, /obj/item/rope/chain)))
		user.visible_message(span_warning("[user]开始用[I]重新穿接[src]。"))
		if(do_after(user, 8 SECONDS))
			qdel(I)
			obj_broken = FALSE
			obj_integrity = max_integrity
			icon_state = initial(icon_state)
			icon_angle = initial(icon_angle)
			name = initial(name)
		else
			user.visible_message(span_warning("[user]停下了重新穿接[src]。"))
		return

/obj/item/inqarticles/garrote/afterattack(mob/living/target, mob/living/user, proximity_flag, click_parameters)
	if(istype(user.used_intent, /datum/intent/garrote/grab))	// Grab your target first.
		if(!iscarbon(target))
			return
		if(!proximity_flag)
			return
		if(victim == target)
			return
		if(user.pulling)
			user.stop_pulling(FALSE)
		if(HAS_TRAIT(target, TRAIT_GRABIMMUNE))
			playsound(loc, pick('sound/items/garrote.ogg', 'sound/items/garrote2.ogg'), 65, TRUE)
			user.visible_message(span_danger("[target]从[user]试图用[src]缠住自己的一击中滑脱了！"))
			return
		// THROAT TARGET RESTRICTION. HEAVILY REQUESTED.
		if(user.zone_selected != "neck")
			to_chat(user, span_warning("我得把它绕到对方喉咙上。"))
			return
		if(HAS_TRAIT(target, TRAIT_GARROTED))
			to_chat(user, span_warning("他们喉咙上已经缠着一个了。"))
			return
		victim = target
		playsound(loc, 'sound/items/garrotegrab.ogg', 100, TRUE)
		ADD_TRAIT(user, TRAIT_NOTIGHTGRABMESSAGE, TRAIT_GENERIC)
		ADD_TRAIT(user, TRAIT_NOSTRUGGLE, TRAIT_GENERIC)
		ADD_TRAIT(target, TRAIT_GARROTED, TRAIT_GENERIC)
		ADD_TRAIT(target, TRAIT_MUTE, "garroteCordage")
		if(target != user)
			user.start_pulling(target, state = 1, supress_message = TRUE, item_override = src)
		user.visible_message(span_danger("[user]将[src]缠上了[target]的喉咙！"))
		user.stamina_add(25)
		user.changeNext_move(CLICK_CD_MELEE)
		REMOVE_TRAIT(user, TRAIT_NOSTRUGGLE, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_NOTIGHTGRABMESSAGE, TRAIT_GENERIC)
		var/obj/item/grabbing/I = user.get_inactive_held_item()
		if(istype(I, /obj/item/grabbing/))
			I.icon_state = null
			currentgrab = I

	if(istype(user.used_intent, /datum/intent/garrote/choke))	// Get started.
		if(!victim)
			to_chat(user, span_warning("我到底在勒谁？什么？"))
			return
		if(!proximity_flag)
			return
		if(user.zone_selected != "neck")
			to_chat(user, span_warning("我得收紧喉部。"))
			return
		user.stamina_add(rand(4, 8))
		var/mob/living/carbon/C = victim
		// if(get_location_accessible(C, BODY_ZONE_PRECISE_NECK))
		playsound(loc, pick('sound/items/garrotechoke1.ogg', 'sound/items/garrotechoke2.ogg', 'sound/items/garrotechoke3.ogg', 'sound/items/garrotechoke4.ogg', 'sound/items/garrotechoke5.ogg'), 100, TRUE)
		if(prob(40))
			C.emote("choke")
		C.adjustOxyLoss(choke_damage)
		if(!C.mind) // NPCs can be choked out twice as fast
			C.adjustOxyLoss(choke_damage)
		C.visible_message(span_danger("[user][pick("用绞索勒住了", "使其窒息")] [C]！"), \
		span_userdanger("[user][pick("用绞索勒住了", "使我窒息了")]我！"), span_hear("我听见了令人不寒而栗的绳索摩擦声！"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger("我[pick("用绞索勒住了", "使其窒息了")][C]！"))
		user.changeNext_move(CLICK_CD_RESIST)	//Stops spam for choking.

/obj/item/clothing/head/inqarticles/blackbag
	name = "黑头套"
	desc = "一个缀满法术织纹的厚垫袋，专门用来闷住里面传出的哭喊。由于材料厚重，未经训练的人往往很难顺利套上或取下。"
	icon_state = "blackbag"
	item_state = "blackbag"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	blocksound = SOFTHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	armor = ARMOR_BLACKBAG
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PEEL, BCLASS_PIERCE, BCLASS_CHOP, BCLASS_LASHING, BCLASS_STAB)
	unequip_delay_self = 45
	equip_delay_other = 360 SECONDS // No getting around it. Cheater. LEFT CLICK THEM!!!
	equip_delay_self = 360 SECONDS
	max_integrity = 10000 // No breaking it. NO CHEAP FRAGS.
	body_parts_inherent = FULL_HEAD
	strip_delay = 10
	slot_flags = ITEM_SLOT_HEAD
	body_parts_covered = FULL_HEAD
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = NONE
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	grid_width = 32
	grid_height = 64
	var/worn = FALSE
	var/bagging = FALSE
	var/headgear

/obj/item/clothing/head/inqarticles/blackbag/proc/bagsound(mob/living/M)
	if(bagging)
		playsound(M, pick('sound/misc/blackbag.ogg','sound/misc/blackbag2.ogg','sound/misc/blackbag3.ogg','sound/misc/blackbag4.ogg','sound/misc/blackbag5.ogg'), 100, TRUE, 4)
	else
		return

/obj/item/clothing/head/inqarticles/blackbag/proc/bagcheck(mob/living/M)
	var/timer = 10
	bagsound(M)
	for(timer, timer < 120, timer += 10)
		if(bagging)
			addtimer(CALLBACK(src, PROC_REF(bagsound), M), timer)

/obj/item/clothing/head/inqarticles/blackbag/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!iscarbon(M))
		return
	if(HAS_TRAIT(M, TRAIT_BAGGED))
		to_chat(user, span_warning("他们已经被套上头套了。"))
		return
	headgear = M.get_item_by_slot(SLOT_HEAD)
	var/trained = FALSE
	var/timetobag = 8 SECONDS
	if(HAS_TRAIT(user, TRAIT_BLACKBAGGER))
		trained = TRUE
		timetobag = 4 SECONDS
	user.visible_message(span_danger("[user][trained ? "熟练地" : "笨拙地"]试图给[M]套上黑头套！"))
	if(HAS_TRAIT(M, TRAIT_GRABIMMUNE))
		user.visible_message(span_danger("[M]从[user]试图给其套上黑头套的动作中滑脱了！"))
		playsound(M, pick('sound/misc/blackbag.ogg','sound/misc/blackbag2.ogg','sound/misc/blackbag3.ogg','sound/misc/blackbag4.ogg','sound/misc/blackbag5.ogg'), 100, TRUE, 4)
		return
	if(!M.stat)
		/* if(HAS_TRAIT(user, TRAIT_BLACKBAGGER) && !M.cmode) It was too much to handle. Too cold to hold.
			bagging = TRUE
			bagsound(M)
			M.transferItemToLoc(headgear, src)
			M.equip_to_slot(src, SLOT_HEAD) // Has to be unsafe otherwise it won't work on unconscious people. Ugh.
			bagging = FALSE
		else*/
		bagging = TRUE
		bagcheck(M)
		if(do_after(user, timetobag, FALSE, M))
			bagging = FALSE
			M.transferItemToLoc(headgear, src)
			M.equip_to_slot(src, SLOT_HEAD) // Has to be unsafe otherwise it won't work on unconscious people. Ugh.
		else
			bagging = FALSE
	else
		bagging = TRUE
		bagcheck(M)
		if(do_after(user, timetobag / 2, FALSE, M))
			bagging = FALSE
			M.transferItemToLoc(headgear, src)
			M.equip_to_slot(src, SLOT_HEAD) // Has to be unsafe otherwise it won't work on unconscious people. Ugh.
		else
			bagging = FALSE

/obj/item/clothing/head/inqarticles/blackbag/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(user.head == src)
		obj_integrity = max_integrity
		bagging = FALSE
		user.become_blind("blindfold_[REF(src)]")
		playsound(user, pick('sound/misc/blackbagequip.ogg', 'sound/misc/blackbagequip2.ogg'), 100, TRUE, 4)
		user.playsound_local(src, 'sound/misc/blackbagloop.ogg', 100, FALSE)
		worn = TRUE
		ADD_TRAIT(user, TRAIT_BAGGED, TRAIT_GENERIC)

/obj/item/clothing/head/inqarticles/blackbag/dropped(mob/living/carbon/human/user)
	..()
	if(worn == TRUE)
		user.cure_blind("blindfold_[REF(src)]")
		worn = FALSE
		obj_integrity = max_integrity
		REMOVE_TRAIT(user, TRAIT_BAGGED, TRAIT_GENERIC)
		user.equip_to_slot(headgear, SLOT_HEAD)
		var/list/datum/wound/w_List = user.get_wounds()
		if(w_List.len)
			for(var/datum/wound/targetwound in w_List)
				if (istype(targetwound, /datum/wound/dismemberment))
					user.dropItemToGround(headgear)
					return
		headgear = initial(headgear)
		playsound(user, pick('sound/misc/blackunbag.ogg'), 100, TRUE, 4)
		user.emote("gasp", forced = TRUE)
		return

/obj/item/clothing/head/inqarticles/blackbag/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,
				"sx" = -4,
				"sy" = -7,
				"nx" = 6,
				"ny" = -6,
				"wx" = -2,
				"wy" = -7,
				"ex" = -1,
				"ey" = -7,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 0,
				"eturn" = 0,
				"nflip" = 8,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/inqarticles/bmirror
	name = "黑镜"
	desc = ""
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bmirror"
	item_state = "bmirror"
	grid_height = 64
	grid_width = 32
	throw_speed = 3
	throw_range = 7
	throwforce = 15
	force = 15
	dropshrink = 0
	hitsound = 'sound/blank.ogg'
	sellprice = 0
	resistance_flags = FIRE_PROOF
	var/opened = FALSE
	var/fedblood = FALSE
	var/whofedme
	var/bloody = FALSE
	var/openstate = "open"
	var/usesleft = 3
	var/active = FALSE
	var/broken = FALSE
	var/mob/living/carbon/human/target
	var/atom/movable/screen/alert/blackmirror/effect
	var/datum/looping_sound/blackmirror/soundloop

/obj/item/inqarticles/bmirror/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(usr, TRAIT_INQUISITION))
		desc = "一件奥塔凡宗教裁判所量产的圣遗物。黑镜的确切运作方式仍是严密守护的秘密，据说值得人为之送命。"
	else
		desc = ""

/obj/item/inqarticles/bmirror/proc/donefixating()
	bloody = TRUE
	active = FALSE
	fedblood = FALSE
	openstate = "bloody"
	whofedme = null
	target.clear_alert("blackmirror", TRUE)
	target.playsound_local(src, 'sound/items/blackeye.ogg', 40, FALSE)
	effect = null
	target = null
	usesleft--
	soundloop.stop()
	visible_message(span_info("[src]自行蒙上了一层刺骨寒雾。"))
	playsound(src, 'sound/items/blackmirror_no.ogg', 100, FALSE)
	update_icon()
	sleep(2 SECONDS)
	if(usesleft == 0)
		broken = TRUE
		playsound(src, 'sound/items/blackmirror_break.ogg', 100, FALSE)
		visible_message(span_info("[src]轰然碎裂，寒雾从四散的碎片间涌入死寂的空气。"))
		openstate = "broken"
		update_icon()

/obj/item/inqarticles/bmirror/attack_self(mob/living/user)
	..()
	if(!user.mind)
		return
	if(!opened)
		to_chat(user, span_warning("它还没打开。"))
		return
	if(broken && bloody)
		to_chat(user, span_warning("镜子已经碎了，无法再使用。"))
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			to_chat(user, span_notice("如果我把它清理干净，就能送回宗教裁判所修理。"))
		return
	if(broken && !bloody)
		to_chat(user, span_warning("镜子已经碎了，无法再使用。至少它现在是干净的。"))
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			to_chat(user, span_notice("现在可以通过“HERMES”把它退回去了。我应该能拿回两枚马克。"))
		return
	if(bloody)
		to_chat(user, span_warning("镜面已经起雾了。再次使用前，我得用布把上面的血擦干净。"))
		return
	if(!fedblood)
		to_chat(user, span_warning("看起来它得喂血之后才能正常运作。"))
		return
	if(!active)
		var/input = input(user, "你在寻找谁？", "代价已经付清") as text|null
		if(!input)
			return
		if(!user.key)
			return
		for(var/mob/living/carbon/human/HL in GLOB.player_list)
		//	to_chat(world, "going through mob: [HL] | real_name: [HL.real_name] | input: [input] | [world.time]") Mirror-bugsplatter. Disregard this.
			if(HL.real_name == input)
				target = HL
				active = TRUE
				effect = target.throw_alert("blackmirror", /atom/movable/screen/alert/blackmirror, override = TRUE)
				effect.source = src
				target.playsound_local(src, 'sound/items/blackeye_warn.ogg', 100, FALSE)
				playsound(src, 'sound/items/blackmirror_active.ogg', 100, FALSE)
				openstate = "active"
				addtimer(CALLBACK(src, PROC_REF(donefixating)), 2 MINUTES, TIMER_UNIQUE)
				message_admins("SCRYING: [user.real_name] ([user.ckey]) has fixated on [target.real_name] ([target.ckey]) via black mirror.")
				log_game("SCRYING: [user.real_name] ([user.ckey]) has fixated on [target.real_name] ([target.ckey]) via black mirror.")
				soundloop.start()
				return update_icon()
		playsound(src, 'sound/items/blackmirror_no.ogg', 100, FALSE)
		to_chat(user, span_warning("[src]发出了刺耳的摩擦声。"))
		return
	var/lookat = null
	if(alert(user, "你要看向哪里？", "黑镜", "血源", "锁定目标") != "血源")
		lookat = target
	else
		lookat = whofedme
	playsound(src, 'sound/items/blackmirror_use.ogg', 100, FALSE)
	ADD_TRAIT(user, TRAIT_NOSSDINDICATOR, "blackmirror")
	var/mob/dead/observer/screye/blackmirror/S = user.scry_ghost()
	if(!S)
		return
	S.ManualFollow(lookat)
	S.add_client_colour(/datum/client_colour/nocshaded)
	user.visible_message(span_warning("[user]凝视着[src]，双眼渐渐失神……"))
	addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 4 SECONDS)
	sleep(41)
	REMOVE_TRAIT(user, TRAIT_NOSSDINDICATOR, "blackmirror")
	playsound(user, 'sound/items/blackeye.ogg', 100, FALSE)
	return

/obj/item/inqarticles/bmirror/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(!user.mind)
		return
	if(opened)
		if(whofedme)
			to_chat(user, span_warning("它已经喂过血了。"))
			return
		if(broken)
			to_chat(user, span_warning("它已经坏了。"))
			return
		if(bloody)
			to_chat(user, span_warning("镜面已经起雾了。再次使用前，我得用布把它擦干净。"))
			return
		if(M == user)
			user.visible_message(span_notice("[user]将自己按向[src]的针尖。"))
			if(do_after(user, 30))
				playsound(src, 'sound/items/blackmirror_needle.ogg', 95, FALSE, 3)
				user.flash_fullscreen("redflash3")
				user.adjustBruteLoss(40)
				user.blood_volume = max(user.blood_volume-240, 0)
				user.handle_blood()
				whofedme = user
				openstate = "bloody"
				fedblood = TRUE
				return update_icon()
			return
		else
			user.visible_message(span_notice("[user]试图用[src]的针尖刺向[M]。"))
			if(do_after(user, 60, target = M))
				playsound(M, 'sound/items/blackmirror_needle.ogg', 95, FALSE, 3)
				M.flash_fullscreen("redflash3")
				M.blood_volume = max(user.blood_volume-240, 0)
				M.adjustBruteLoss(40)
				M.handle_blood()
				whofedme = M
				openstate = "bloody"
				fedblood = TRUE
				return update_icon()
			return
	else
		to_chat(user, span_warning("我得先把它打开。"))
		return


/obj/item/inqarticles/bmirror/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/natural/cloth))
		if(broken && bloody)
			if(do_after(user, 30))
				user.visible_message(span_info("[user]用[I]擦拭着[src]。"))
				openstate = "cleaned"
				bloody = FALSE
				update_icon()
			return
		if(bloody)
			if(do_after(user, 30))
				user.visible_message(span_info("[user]用[I]擦去了[src]上的雾气与血迹。"))
				openstate = "open"
				bloody = FALSE
				update_icon()
		return

/obj/item/inqarticles/bmirror/attack_right(mob/user, obj/item/T)
	..()
	if(!user.mind)
		return
	if(istype(T, /obj/item/inqarticles/bmirror))
		openorshut()
	else
		openorshut()

/obj/item/inqarticles/bmirror/proc/openorshut()
	if(opened)
		if(effect)
			target.clear_alert("blackmirror", TRUE)
			effect = null
			target.playsound_local(src, 'sound/items/blackeye.ogg', 40, FALSE)
		playsound(src, 'sound/items/blackmirror_shut.ogg', 100, FALSE)
		soundloop.stop()
		opened = FALSE
		icon_state = "[initial(icon_state)]"
		update_icon_state()
		return
	playsound(src, 'sound/items/blackmirror_open.ogg', 100, FALSE)
	if(target)
		target.playsound_local(src, 'sound/items/blackeye_warn.ogg', 100, FALSE)
		effect = target.throw_alert("blackmirror", /atom/movable/screen/alert/blackmirror, override = TRUE)
		effect.source = src
	if(active)
		soundloop.start()
	opened = TRUE
	return update_icon()

/obj/item/inqarticles/bmirror/update_icon()
	if(opened)
		icon_state = "[initial(icon_state)]_[openstate]"
	else
		icon_state = "[initial(icon_state)]"
	update_icon_state()

/obj/item/inqarticles/bmirror/Initialize(mapload)
	soundloop = new(src, FALSE)
	. = ..()

/obj/item/inqarticles/bmirror/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	return ..()


/atom/movable/screen/alert/blackmirror
	name = "黑眼"
	desc = "看着我。我看得见你。"
	icon_state = "blackeye"
	var/obj/item/inqarticles/bmirror/source

/atom/movable/screen/alert/blackmirror/handle_click()
	var/mob/living/L = usr
	var/lookat = null

	if(alert(L, "继续看下去，你会发现什么？", "黑眼凝视", "血源", "镜子") != "血源")
		lookat = source
	else
		lookat = source.whofedme
	playsound(L, 'sound/items/blackmirror_use.ogg', 100, FALSE)
	ADD_TRAIT(L, TRAIT_NOSSDINDICATOR, "blackmirror")
	var/mob/dead/observer/screye/blackmirror/S = L.scry_ghost()
	if(!S)
		return
	S.ManualFollow(lookat)
	S.add_client_colour(/datum/client_colour/nocshaded)
	L.visible_message(span_warning("[L]向内凝视，双眼逐渐失神……"))
	addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 4 SECONDS)
	REMOVE_TRAIT(L, TRAIT_NOSSDINDICATOR, "blackmirror")
	sleep(41)
	playsound(L, 'sound/items/blackeye.ogg', 100, FALSE)
	return

// FINISH THIS AT YOUR LEISURE. I'M JUST LEAVING IT HERE UNIMPLEMENTED. IT'S INTENDED TO WORK AS A COMBINATION OF THE NOC FAR-SIGHT AND THE NOCSHADES. HAVE FUN! - YISCHE
/obj/item/inqarticles/spyglass
	name = "奥塔凡夜影目镜"
	desc = ""
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "spyglass"
	item_state = "spyglass"
	grid_height = 32
	grid_width = 32

/obj/item/inqarticles/spyglass/attack_self(mob/living/user)
	. = ..()


/obj/item/skeleton_key
	name = "万能钥匙"
	desc = "一件多年前在突袭吉佐信徒教派时缴获的半异端物件。它能打开你想打开的任何锁。"
	icon_state = "skeleton_key"
	icon = 'icons/roguetown/items/keys.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH|ITEM_SLOT_NECK
	resistance_flags = FIRE_PROOF
	max_integrity = 100
	always_destroy = TRUE
