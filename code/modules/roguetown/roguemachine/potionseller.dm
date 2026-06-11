/obj/structure/roguemachine/potionseller
	name = "药剂贩子"
	desc = "这东西的腹腔可以灌满液体，供你购买。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.1
	max_integrity = 0
	debris = list(/obj/item/grown/log/tree/small, /obj/item/roguegear, /obj/item/natural/glass)
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/list/held_items = list()
	locked = TRUE
	var/budget = 0
	var/wgain = 0
	var/is_crafted = FALSE
	var/keycontrol = "merchant"
	var/obj/item/reagent_containers/glass/bottle/inserted
	var/bottle_price = 10
	var/bottle_sold_max = 10

/obj/structure/roguemachine/potionseller/crafted
	is_crafted = TRUE
	max_integrity = 100

/obj/structure/roguemachine/potionseller/Initialize(mapload)
	. = ..()
	if(!reagents)
		create_reagents(200*3)
		reagents.flags |= NO_REACT
		reagents.flags &= ~OPENCONTAINER
	if(is_crafted) // spawn a key
		var/obj/item/roguekey/key = new /obj/item/roguekey/physician(get_turf(src))
		key.lockid = "random_potion_peddler_id_[rand(1,9999999)]" // I know, not foolproof
		key.name = "药剂贩子钥匙"
		keycontrol = key.lockid
	update_icon()

/obj/structure/roguemachine/potionseller/Destroy()
	if(reagents)
		qdel(reagents)
		reagents = null
	if(inserted)
		inserted.forceMove(drop_location())
		inserted = null
	if(budget > 0)
		budget2change(budget)
		budget = 0
	set_light(0)
	return ..()

/obj/structure/roguemachine/potionseller/proc/insert(obj/item/P, mob/living/user)
	if(!istype(P, /obj/item/reagent_containers/glass/bottle))
		to_chat(user, span_warning("这不是容器。"))
		return
	var/obj/item/reagent_containers/glass/bottle/B = P
	if(!B.reagents.total_volume)
		to_chat(user, span_warning("没有东西可以加入。"))
		return
	if(reagents.maximum_volume < B.reagents.total_volume + reagents.total_volume)
		to_chat(user, span_warning("机器已经装到满盖了。"))
		return
	testing("startadd")
	for(var/datum/reagent/to_add in B.reagents.reagent_list)
		var/already_exists = FALSE
		if(length(reagents.reagent_list))
			for(var/datum/reagent/existing in reagents.reagent_list)
				if(existing.type == to_add.type)
					already_exists = TRUE
					break
		if(!already_exists)
			held_items[to_add.type] = list()
			held_items[to_add.type]["NAME"] = to_add.name
			held_items[to_add.type]["PRICE"] = 0
		B.reagents.trans_to(src, B.reagents.total_volume, transfered_by = user)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)

/obj/structure/roguemachine/potionseller/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguecoin/gilbranze))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		budget += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == keycontrol)
			locked = !locked
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			update_icon()
			return attack_hand(user)
		else
			if(!locked)
				insert(P, user)
			else
				to_chat(user, span_warning("钥匙不对。"))
				return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		for(var/obj/item/roguekey/KE in K.keys)
			if(KE.lockid == keycontrol)
				locked = !locked
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				update_icon()
				return attack_hand(user)
	if(!locked)
		insert(P, user)
	else if(inserted)
		to_chat(user, span_warning("里面已经有东西了！"))
	else if(istype(P, /obj/item/reagent_containers/glass/bottle))
		if(user.transferItemToLoc(P, src))
			inserted = P
			return attack_hand(user)
		to_chat(user, span_warning("[P]粘在你手上了！"))
	..()

/obj/structure/roguemachine/potionseller/Topic(href, href_list)
	. = ..()
	if(href_list["buy"])
		var/datum/reagent/R = locate(href_list["buy"]) in held_items
		if(!R || !ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE) || !locked)
			return
		if(!inserted)
			say("我的药剂需要瓶子来装，旅人。")
			return
		var/price = held_items[R.type]["PRICE"]
		if(price > budget)
			say("我的药剂对你来说太贵了，旅人。")
			return
		var/quantity = 0
		var/volume = reagents.get_reagent_amount(R)
		var/buyer_volume = inserted.reagents.maximum_volume - inserted.reagents.total_volume
		if(buyer_volume < 1)
			say("[uppertext("\the [inserted]")] 对我的药剂来说太小了，旅人。")
			return
		if(price > 0)
			var/budget_vol = round(budget / price)
			if(budget_vol > volume)
				budget_vol = volume
			quantity = input(usr, "要买多少打兰？（你买得起 [budget_vol] [UNIT_FORM_STRING(budget_vol)]）", "\The [held_items[R.type]["NAME"]]") as num|null
		else
			quantity = input(usr, "要倒出多少打兰？", "\The [held_items[R.type]["NAME"]]") as num|null
		if(!usr.Adjacent(src))
			return
		quantity = round(quantity)
		if(quantity <= 0)
			to_chat(usr, span_warning("这台机器倒不出这么少的量。"))
			return
		if(quantity > buyer_volume)
			quantity = buyer_volume
		if(quantity > volume)
			quantity = volume
		if(price > 0)
			price *= quantity
			if(budget >= price)
				budget -= price
				wgain += price
				record_round_statistic(STATS_PEDDLER_REVENUE, price)
			else
				say("我的药剂对你来说太贵了，旅人。")
				return
		inserted.reagents.add_reagent(R.type, quantity)
		reagents.remove_reagent(R.type, quantity, FALSE)
		if(volume - quantity < 1)
			reagents.del_reagent(R.type)
			held_items -= R.type
			update_icon()
		playsound(loc, 'sound/misc/potionseller.ogg', 100, TRUE, -1)
	if(href_list["retrieve"])
		var/datum/reagent/R = locate(href_list["retrieve"]) in held_items
		if(!R || !ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/obj/item/reagent_containers/glass/bottle/alchemical/sold_bottle = new /obj/item/reagent_containers/glass/bottle/alchemical(get_turf(src))
		var/quantity = 0
		var/volume = reagents.get_reagent_amount(R)
		var/buyer_volume = sold_bottle.reagents.maximum_volume - sold_bottle.reagents.total_volume
		var/vol_max = min(buyer_volume,volume)
		quantity = input(usr, "要向[sold_bottle]中倒入多少打兰？（还可装 [vol_max] [UNIT_FORM_STRING(vol_max)]）", "\The [held_items[R.type]["NAME"]]") as num|null
		quantity = round(text2num(quantity))
		if(quantity <= 0 || !usr.Adjacent(src))
			qdel(sold_bottle)
			return
		if(quantity > buyer_volume)
			quantity = buyer_volume
		if(quantity > volume)
			quantity = volume
		sold_bottle.reagents.add_reagent(R.type, quantity)
		reagents.remove_reagent(R.type, quantity, FALSE)
		if(volume - quantity < 1)
			reagents.del_reagent(R.type)
			held_items -= R.type
			update_icon()
		if(!usr.put_in_hands(sold_bottle))
			sold_bottle.forceMove(get_turf(src))
		playsound(loc, 'sound/misc/potionseller.ogg', 100, TRUE, -1)
	if(href_list["change"])
		if(!usr.canUseTopic(src, BE_CLOSE) || !locked)
			return
		if(ishuman(usr))
			if(budget > 0)
				budget2change(budget, usr)
				budget = 0
	if(href_list["withdrawgain"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(ishuman(usr))
			if(wgain > 0)
				budget2change(wgain, usr)
				wgain = 0
	if(href_list["setname"])
		var/datum/reagent/R = locate(href_list["setname"]) in held_items
		if(!R || !usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(ishuman(usr))
			var/prename
			if(held_items[R.type]["NAME"])
				prename = held_items[R.type]["NAME"]
			var/newname = input(usr, "为这瓶药剂设置新名称", src, prename)
			if(newname)
				held_items[R.type]["NAME"] = newname
	if(href_list["setprice"])
		var/datum/reagent/R = locate(href_list["setprice"]) in held_items
		if(!R || !usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(ishuman(usr))
			var/preprice
			if(held_items[R]["PRICE"])
				preprice = held_items[R]["PRICE"]
			var/newprice = input(usr, "设置这瓶药剂每打兰的新价格（0 为免费）", src, preprice) as null|num
			if(newprice)
				if(newprice < 0.1)
					return attack_hand(usr)
				held_items[R]["PRICE"] = round(newprice, 0.1)
			else if(text2num(newprice) == 0)
				held_items[R]["PRICE"] = 0 // free!
	if(href_list["setbottleprice"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(ishuman(usr))
			var/newprice = input(usr, "设置瓶子的价格（0 为免费）", src, bottle_price) as null|num
			bottle_price = round(newprice)
			if(bottle_price < 0)
				bottle_price = 0
	if(href_list["buybottle"])
		if(!usr.canUseTopic(src, BE_CLOSE) || !locked)
			return
		if(ishuman(usr))
			if(bottle_sold_max < 1)
				say("我的瓶子全都卖光了，旅人。")
				return
			if(bottle_price > 0)
				if(budget < bottle_price)
					say("我的瓶子对你来说太贵了，旅人。")
					return
				budget -= bottle_price
				wgain += bottle_price
				record_round_statistic(STATS_PEDDLER_REVENUE, bottle_price)
			bottle_sold_max--
			var/obj/item/reagent_containers/glass/bottle/rogue/sold_bottle = new /obj/item/reagent_containers/glass/bottle/rogue(get_turf(src))
			if(!usr.put_in_hands(sold_bottle))
				sold_bottle.forceMove(get_turf(src))
	if(href_list["eject"])
		if(!inserted)
			return
		inserted.forceMove(drop_location())
		inserted = null
	return attack_hand(usr)

/obj/structure/roguemachine/potionseller/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	if(canread)
		contents = "<center>药剂贩子，一号机型<BR>"
		if(!locked)
			contents += "未上锁<BR><a href='?src=[REF(src)];setbottleprice=1'>设置瓶价：</a> [bottle_price ? bottle_price : "免费"]<HR>"
		else if(!inserted)
			contents += "未插入容器<BR><a href='?src=[REF(src)];buybottle=1'>[bottle_price ? "花费 [bottle_price] 玛门购买瓶子" : "免费拿取一个瓶子"]</a><HR>"
		else
			contents += "容器：<a href='?src=[REF(src)];eject=1'>[inserted]</a> ([round(inserted.reagents.total_volume)]/[round(inserted.reagents.maximum_volume)] 打兰)<HR>"
		if(locked)
			contents += "<a href='?src=[REF(src)];change=1'>已存入玛门：</a> [budget]<BR>"
		else
			contents += "<a href='?src=[REF(src)];withdrawgain=1'>已存利润：</a> [wgain]<BR>"
	else
		contents = "<center>[stars("药剂贩子，一号机型")]<BR>"
		if(!locked)
			contents += "[stars("未上锁")]<BR><a href='?src=[REF(src)];setbottleprice=1'>[stars("设置瓶价：")]</a> [bottle_price ? bottle_price : stars("免费")]<HR>"
		else if(!inserted)
			contents += "[stars("未插入容器")]<BR><a href='?src=[REF(src)];buybottle=1'>[bottle_price ? stars("花费 [bottle_price] 玛门购买瓶子") : stars("免费拿取一个瓶子")]</a><HR>"
		else
			contents += "[stars("容器")]: <a href='?src=[REF(src)];eject=1'>[stars("[inserted]")]</a> ([round(inserted.reagents.total_volume)]/[round(inserted.reagents.maximum_volume)] [stars("打兰")])<HR>"
		if(locked)
			contents += "<a href='?src=[REF(src)];change=1'>[stars("已存入玛门：")]</a> [budget]<BR>"
		else
			contents += "<a href='?src=[REF(src)];withdrawgain=1'>[stars("已存利润：")]</a> [wgain]<BR>"

	contents += "</center>"

	for(var/I in held_items)
		var/price = held_items[I]["PRICE"]
		var/namer = held_items[I]["NAME"]
		var/volume = reagents.get_reagent_amount(I)
		if(volume < 1) // do not sell reagents less than 1 dram
			continue
		if(!namer)
			held_items[I]["NAME"] = "东西"
			namer = "东西"
		if(locked)
			var/buy = !price ? "拿取" : "购买"
			price = !price ? "免费" : "每打兰 [price]"
			if(canread)
				contents += "[namer] ([volume] [UNIT_FORM_STRING(volume)]) - [price] <a href='?src=[REF(src)];buy=[REF(I)]'>[buy]</a>"
			else
				contents += "[stars(namer)] - [stars(price)] <a href='?src=[REF(src)];buy=[REF(I)]'>[stars("[buy]")]</a>"
		else
			if(canread)
				contents += "<a href='?src=[REF(src)];setname=[REF(I)]'>[namer]</a> ([volume] [UNIT_FORM_STRING(volume)]) - <a href='?src=[REF(src)];setprice=[REF(I)]'>每打兰 [price]</a> <a href='?src=[REF(src)];retrieve=[REF(I)]'>取出</a>"
			else
				contents += "<a href='?src=[REF(src)];setname=[REF(I)]'>[stars(namer)]</a> - <a href='?src=[REF(src)];setprice=[REF(I)]'>[price] [stars("每打兰")]</a> <a href='?src=[REF(src)];retrieve=[REF(I)]'>[stars("取出")]</a>"
		contents += "<BR>"

	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 300)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/potionseller/obj_break(damage_flag)
	..()
	held_items = list()
	reagents.clear_reagents()
	if(inserted)
		inserted.forceMove(drop_location())
		inserted = null
	if(budget > 0)
		budget2change(budget)
		budget = 0
	set_light(0)
	update_icon()
	icon_state = "streetvendor0"

/obj/structure/roguemachine/potionseller/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	if(!locked)
		icon_state = "streetvendor0"
		return
	else
		icon_state = "streetvendor1"
	if(held_items.len)
		set_light(1, 1, 1, l_color = "#1b7bf1")
		add_overlay(mutable_appearance(icon, "vendor-gen"))
