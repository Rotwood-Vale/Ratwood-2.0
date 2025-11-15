//bombs+flowers

/obj/structure/roguemachine/duoface
	name = "Croesus"
	desc = "Twin-faced guild vendor of the Rialto pattern. A brass plate reads: “Pecunia non olet.” The ledger bears an old Hanse seal."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

	var/budget = 0
	var/current_tab = "Bombs"

	var/list/flavor_lines = list(
		"“Caveat emptor.”",
		"“Lex mercatoria remembers every debt.”",
		"“Gresham whispers: bad coin hunts the good.”",
		"“Mercury tallies, Plutus delivers.”",
		"“Midas clause: refunds turn to lead.”",
		"“Florins, ducats, thalers, mammon - coin is coin.”",
		"“By Croesus’ measure, all wealth is weight.”",
		"“From souk to bazaar to bourse.”",
		"“Counted on a Medici ledger.”",
		"“Stamped with the Hanse mark.”"
	)
// autismo tablets no tab
	var/list/bombs = list(
		list("name"="Smoke bomb",               "type"=/obj/item/smokebomb,                 "price"=50),
		list("name"="Impact grenade (contact)", "type"=/obj/item/impact_grenade/explosion,  "price"=50),
		list("name"="Impact grenade (smoke)",   "type"=/obj/item/impact_grenade/smoke,      "price"=50),
		list("name"="Impact grenade (poison)",  "type"=/obj/item/impact_grenade/poison_gas, "price"=50),
		list("name"="Impact grenade (healing)", "type"=/obj/item/impact_grenade/healing_gas,"price"=50),
		list("name"="Impact grenade (fire)",    "type"=/obj/item/impact_grenade/fire_gas,   "price"=50),
		list("name"="Impact grenade (blind)",   "type"=/obj/item/impact_grenade/blind_gas,  "price"=50),
		list("name"="Impact grenade (mute)",    "type"=/obj/item/impact_grenade/mute_gas,   "price"=50),
		list("name"="Blackpowder stick",        "type"=/obj/item/tntstick,                  "price"=100),
		list("name"="Bomb satchel",             "type"=/obj/item/satchel_bomb,              "price"=300)
	)

	var/list/flowers = list(
		list("name"="Purple lily",            "type"=/obj/item/clothing/head/flowers/purple_lily,            "price"=30),
		list("name"="Snapdragon",             "type"=/obj/item/clothing/head/flowers/snapdragon,             "price"=30),
		list("name"="Red-purple rose",        "type"=/obj/item/clothing/head/flowers/redpurple_rose,         "price"=30),
		list("name"="Purple burdock flower",  "type"=/obj/item/clothing/head/flowers/burdock_flower_purple,  "price"=30),
		list("name"="Yellow lily",            "type"=/obj/item/clothing/head/flowers/yellow_lily,            "price"=30),
		list("name"="Pink burdock flower",    "type"=/obj/item/clothing/head/flowers/burdock_flower_pink,    "price"=30),
		list("name"="White yarrow",           "type"=/obj/item/clothing/head/flowers/yarrow_white,           "price"=30),
		list("name"="Pink rose",              "type"=/obj/item/clothing/head/flowers/rose_pink,              "price"=30),
		list("name"="Red roses rose",         "type"=/obj/item/clothing/head/flowers/roses_red,              "price"=30),
		list("name"="Peony",                  "type"=/obj/item/clothing/head/flowers/peony,                  "price"=30),
		list("name"="Pink-forget-me-not",     "type"=/obj/item/clothing/head/flowers/forget_me_not_alt,      "price"=30),
		list("name"="Forget-me-not",          "type"=/obj/item/clothing/head/flowers/forget_me_not,          "price"=30),
		list("name"="Blue rose",              "type"=/obj/item/clothing/head/flowers/blue_rose,              "price"=30),
		list("name"="Orange rose",            "type"=/obj/item/clothing/head/flowers/orange_rose,            "price"=30),
		list("name"="Sunflower",              "type"=/obj/item/clothing/head/flowers/sunflower,              "price"=30),
		list("name"="Yellow bells",           "type"=/obj/item/clothing/head/flowers/yellow_bells,           "price"=30),
		list("name"="Poppy",                  "type"=/obj/item/clothing/head/flowers/poppy,                  "price"=30),
		list("name"="Blue and purple bells",  "type"=/obj/item/clothing/head/flowers/blue_purple_bells,      "price"=30),
		list("name"="Iris",                   "type"=/obj/item/clothing/head/flowers/iris,                   "price"=30),
		list("name"="Muscaris",               "type"=/obj/item/clothing/head/flowers/muscaris,               "price"=30),
		list("name"="Lavander",               "type"=/obj/item/clothing/head/flowers/lavander,               "price"=30),
		list("name"="Milva",                  "type"=/obj/item/clothing/head/flowers/milva,                  "price"=30),
		list("name"="Yellow iris",            "type"=/obj/item/clothing/head/flowers/yellow_iris,            "price"=30)
	)


/obj/structure/roguemachine/duoface/Initialize()
	. = ..()
	refresh_icon()

/obj/structure/roguemachine/duoface/proc/refresh_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = "#1b7bf1")
	add_overlay(mutable_appearance(icon, "vendor-merch"))

/obj/structure/roguemachine/duoface/examine(mob/user)
	. = ..()
	. += "<span class='info'>An old motto is etched here: <b>Pecunia non olet</b>.</span>"
	. += "<span class='notice'>[pick(src.flavor_lines)]</span>"


/obj/structure/roguemachine/duoface/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguecoin/aalloy)) return
	if(istype(P, /obj/item/roguecoin/inqcoin)) return
	if(istype(P, /obj/item/roguecoin))
		var/val = 0
		if(hascall(P, "get_real_price"))
			val = max(0, call(P, "get_real_price")())
		if(val > 0)
			budget += val
			qdel(P)
			refresh_icon()
			playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
			return attack_hand(user)
	..()


/obj/structure/roguemachine/duoface/attack_hand(mob/living/user)
	. = ..()
	if(.) return
	if(!ishuman(user)) return

	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/gold_menu.ogg', 100, FALSE, -1)

	var/flv = pick(src.flavor_lines)
	var/html = ""
	html += "<center><b>CROESUS</b> <small>(Rialto Pattern)</small><br>"
	html += "<i>[flv]</i><br>Balance: [budget]</center><hr>"

	var/list/tabs = list("Bombs","Flowers")
	html += "<center>"
	for(var/t in tabs)
		if(t == current_tab)
			html += "<b>[t]</b>"
		else
			html += "<a href='?src=[REF(src)];tab=[t]'>[t]</a>"
		if(t != tabs[tabs.len])
			html += " | "
	html += "</center><br>"

	if(current_tab == "Bombs")
		var/list/listing = bombs
		html += "<table width='100%'>"
		for(var/i = 1, i <= listing.len, i++)
			var/list/E = listing[i]
			var/name  = E["name"]
			var/price = E["price"]
			html += "<tr><td>[name]</td><td align='right'>[price]</td><td width='80' align='right'>"
			if(price <= budget)
				html += "<a href='?src=[REF(src)];buybomb=[i]'>BUY</a>"
			else
				html += "<span style='color:#888'>BUY</span>"
			html += "</td></tr>"
		html += "</table>"
	else
		var/list/listing2 = flowers
		html += "<table width='100%'>"
		for(var/j = 1, j <= listing2.len, j++)
			var/list/F = listing2[j]
			var/name2  = F["name"]
			var/price2 = F["price"] 
			html += "<tr><td>[name2]</td><td align='right'>[price2]</td><td width='80' align='right'>"
			if(price2 <= budget)
				html += "<a href='?src=[REF(src)];buyflower=[j]'>BUY</a>"
			else
				html += "<span style='color:#888'>BUY</span>"
			html += "</td></tr>"
		html += "</table>"

	var/datum/browser/popup = new(user, "DUOFACE_VENDOR", "", 520, 620)
	popup.set_content(html)
	popup.open()


/obj/structure/roguemachine/duoface/Topic(href, href_list)
	. = ..()
	if(!ishuman(usr)) return
	if(!usr.canUseTopic(src, BE_CLOSE)) return

	if(href_list["tab"])
		var/next = href_list["tab"]
		if(next == "Bombs" || next == "Flowers")
			current_tab = next
		return attack_hand(usr)

	if(href_list["buybomb"])
		var/idx = text2num(href_list["buybomb"])
		if(!isnum(idx) || idx < 1 || idx > bombs.len)
			return attack_hand(usr)

		var/list/E = bombs[idx]
		var/price = E["price"]
		var/path  = E["type"]
		if(price > budget)
			say("Not enough!")
			return attack_hand(usr)
		if(!ispath(path))
			say("Item misconfigured.")
			return attack_hand(usr)

		budget -= price
		var/turf/T = get_turf(usr)
		new path(T)
		return attack_hand(usr)

	if(href_list["buyflower"])
		var/idf = text2num(href_list["buyflower"])
		if(!isnum(idf) || idf < 1 || idf > flowers.len)
			return attack_hand(usr)

		var/list/F = flowers[idf]
		var/price2 = F["price"] 
		var/path2  = F["type"]
		if(price2 > budget)
			say("Not enough!")
			return attack_hand(usr)
		if(!ispath(path2))
			say("Item misconfigured.")
			return attack_hand(usr)

		budget -= price2
		var/turf/T2 = get_turf(usr)
		new path2(T2)
		return attack_hand(usr)