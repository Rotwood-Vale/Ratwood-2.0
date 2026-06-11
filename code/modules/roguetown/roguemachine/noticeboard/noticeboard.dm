/obj/structure/roguemachine/noticeboard
	name = "告示板"
	desc = "一块巨大的木制告示板，上面贴满了来自整个王国的告示。顶部还设有一只 ZAD告示台 的栖架。"
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "noticeboard0"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	blade_dulling = DULLING_BASH
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	var/current_category = "Postings"
	var/list/categories = list("Postings", "Premium Postings", "Scout Report")

/obj/structure/roguemachine/noticeboard/Initialize(mapload)
	. = ..()
	SSroguemachine.noticeboards += src

/datum/noticeboardpost
	var/title
	var/truepostername
	var/posterstitle
	var/poster
	var/message
	var/banner

/obj/structure/roguemachine/noticeboard/examine(mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		return
	if(user in GLOB.board_viewers)
		return
	else
		GLOB.board_viewers += user
		to_chat(user, span_smallred("自我上次查看后，又新增了一张告示！"))

/obj/structure/roguemachine/noticeboard/update_icon()
	. = ..()
	var/total_length = length(GLOB.noticeboard_posts) + length(GLOB.premium_noticeboardposts)
	switch(total_length)
		if(0)
			icon_state = "noticeboard0"
		if(1 to 3)
			icon_state = "noticeboard1"
		if(4 to 6)
			icon_state = "noticeboard2"
		else
			icon_state = "noticeboard3"

/obj/structure/roguemachine/noticeboard/Topic(href, href_list)
	. = ..()
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	if(href_list["changecategory"])
		current_category = href_list["changecategory"]
	if(href_list["makepost"])
		make_post(usr)
		return attack_hand(usr)
	if(href_list["premiumpost"])
		premium_post(usr)
		return attack_hand(usr)
	if(href_list["removepost"])
		remove_post(usr)
		return attack_hand(usr)
	if(href_list["authorityremovepost"])
		authority_removepost(usr)
		return attack_hand(usr)

	return attack_hand(usr)

/obj/structure/roguemachine/noticeboard/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	var/can_remove = FALSE
	var/can_premium = FALSE
	if(user.job in list("Man at Arms","Inquisitor", "Knight", "Sergeant", "Knight Captain", "Orthodoxist", "Absolver", "Marshal", "Hand")) //why was KC here but not marshal ?
		can_remove = TRUE
	if(user.job in list("Bathmaster","Merchant", "Innkeeper", "Steward", "Court Magician", "Town Crier", "Keeper"))
		can_premium = TRUE
	var/contents
	contents += "<center>告示板<BR>"
	contents += "--------------<BR>"
	var/selection = "Categories: "
	for(var/i = 1, i <= length(categories), i++)
		var/category = categories[i]
		if(category == current_category)
			selection += "<b>[current_category]</b> | "
		else if(i != length(categories))
			selection += "<a href='?src=[REF(src)];changecategory=[category]'>[category]</a> | "
		else
			selection += "<a href='?src=[REF(src)];changecategory=[category]'>[category]</a> "
	contents += selection + "<BR>"
	if(current_category in list("Postings", "Premium Postings"))
		contents += "<a href='?src=[REF(src)];makepost=1'>发布告示</a>"
		if(can_premium)
			contents += " | <a href='?src=[REF(src)];premiumpost=1'>发布高级告示</a><br>"
		else
			contents += "<br>"
		contents += "<a href='?src=[REF(src)];removepost=1'>移除我的告示</a><br>"
		if(can_remove)
			contents += "<a href='?src=[REF(src)];authorityremovepost=1'>权限：移除告示</a>"
		var/board_empty = TRUE
		switch(current_category)
			if("Postings")
				for(var/datum/noticeboardpost/saved_post in GLOB.noticeboard_posts)
					contents += saved_post.banner
					board_empty = FALSE
			if("Premium Postings")
				for(var/datum/noticeboardpost/saved_post in GLOB.premium_noticeboardposts)
					contents += saved_post.banner
					board_empty = FALSE
		if(board_empty)
			contents += "<br><span class='notice'>目前还没有任何告示！</span>"
	else if(current_category == "Scout Report")
		var/list/regional_threats = SSregionthreat.get_threat_regions_for_display()
		contents += "<h2>侦察报告</h2>"
		contents += "<hr></center>"
		for(var/T in regional_threats)
			var/datum/threat_region_display/TRS = T
			contents += ("<div>[TRS?.region_name]: <font color=[TRS?.danger_color]>[TRS?.danger_level]</font></div>")
		contents += "<hr>"
		contents += "侦察兵将地区危险度划分为：安全 -> 低危 -> 中等 -> 危险 -> 绝望 <br>"
		contents += "安全地区整体安稳，旅者通常不会遭到常见怪物或强盗伏击。<br>"
		contents += "低威胁地区通常不会出现重大威胁，强盗和怪物也多半是零散出没。<br>"
		contents += "只有 Vale Basin、Vale Grove 和 Terrorbog 能被彻底清剿为安全区域。<br>"
		contents += "未列出的地区不在守望者的管辖范围内，那些地方将长期充满危险。<br>"
		contents += "通过引诱恶徒与怪物在伏击时现身并将其击杀，可以降低地区危险度。守望者配发的信号号角有助于此事，但使用时务必谨慎。"
	var/datum/browser/popup = new(user, "NOTICEBOARD", "", 800, 650)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/noticeboard/proc/premium_post(mob/living/carbon/human/guy)
	if(guy.has_status_effect(/datum/status_effect/debuff/postcooldown))
		to_chat(guy, span_warning("我得再等一会儿才能发布下一张告示……"))
		return
	var/inputtitle = input(guy, "我的告示标题该写什么？", "NOTICEBOARD", null)
	if(!inputtitle)
		return
	var/inputmessage = stripped_multiline_input(guy, "这张告示我要写些什么？", "NOTICEBOARD", no_trim=TRUE)
	if(inputmessage)
		if(length(inputmessage) > 2000)
			to_chat(guy, span_warning("太长了！你这是要让它驮着整本小说跑腿吗！"))
			return
	else
		return
	var/inputname = input(guy, "我要在告示上署什么名字？", "NOTICEBOARD", null)
	if(!inputname)
		return
	var/inputrole = input(guy, "我要在告示上使用什么头衔？", "NOTICEBOARD", null)
	add_post(inputmessage, inputtitle, inputname, inputrole, guy.real_name, TRUE)
	guy.apply_status_effect(/datum/status_effect/debuff/postcooldown)
	message_admins("[ADMIN_LOOKUPFLW(guy)] has made a notice board post. The message was: [inputmessage]")
	for(var/obj/structure/roguemachine/noticeboard/board in SSroguemachine.noticeboards)
		if(board != src)
			playsound(board, 'sound/ambience/noises/birds (7).ogg', 50, FALSE, -1)
			board.visible_message(span_smallred("一只 ZAD告示台 落下，送来了一张新告示！"))
			board.update_icon()

/obj/structure/roguemachine/noticeboard/proc/make_post(mob/living/carbon/human/guy)
	if(guy.has_status_effect(/datum/status_effect/debuff/postcooldown))
		to_chat(guy, span_warning("我得再等一会儿才能发布下一张告示……"))
		return
	var/inputtitle = stripped_input(guy, "What shall the title of my posting be?", "NOTICEBOARD", null)
	if(!inputtitle)
		return
	if(length(inputtitle) > 50)
		to_chat(guy, span_warning("太长了！你这是要让那只 ZAD告示台 驮着小说跑腿吗！"))
		return
	var/inputmessage = stripped_multiline_input(guy, "What shall I write for this posting?", "NOTICEBOARD", no_trim=TRUE)
	if(inputmessage)
		if(length(inputmessage) > 2000)
			to_chat(guy, span_warning("太长了！你这是要让那只 ZAD告示台 驮着小说跑腿吗！"))
			return
	else
		return
	var/inputname = stripped_input(guy, "What name shall I use on the posting?", "NOTICEBOARD", null)
	if(!inputname)
		return
	if(length(inputname) > 50)
		to_chat(guy, span_warning("太长了！你这是要让那只 ZAD告示台 驮着小说跑腿吗！"))
		return
	var/inputrole = stripped_input(guy, "What personal title shall I use on the posting?", "NOTICEBOARD", null)
	if(length(inputrole) > 50)
		to_chat(guy, span_warning("太长了！你这是要让那只 ZAD告示台 驮着小说跑腿吗！"))
		return
	add_post(inputmessage, inputtitle, inputname, inputrole, guy.real_name, FALSE)
	guy.apply_status_effect(/datum/status_effect/debuff/postcooldown)
	message_admins("[ADMIN_LOOKUPFLW(guy)] has made a notice board post. The message was: [inputmessage]")
	for(var/obj/structure/roguemachine/noticeboard/board in SSroguemachine.noticeboards)
		board.update_icon()
		if(board != src)
			playsound(board, 'sound/ambience/noises/birds (7).ogg', 50, FALSE, -1)
			board.visible_message(span_smallred("一只 ZAD告示台 落下，送来了一张新告示！"))

/obj/structure/roguemachine/noticeboard/proc/remove_post(mob/living/carbon/human/guy)
	var/list/myposts_list = list()
	for(var/datum/noticeboardpost/removable_posts in GLOB.noticeboard_posts)
		if(removable_posts.truepostername == guy.real_name)
			myposts_list += removable_posts.title
	for(var/datum/noticeboardpost/removable_postspremium in GLOB.premium_noticeboardposts)
		if(removable_postspremium.truepostername == guy.real_name)
			myposts_list += removable_postspremium.title
	if(!myposts_list.len)
		to_chat(guy, span_warning("没有我能拆下的告示。"))
		return
	var/post2remove = input(guy, "我要拆下哪一张告示？", src) as null|anything in myposts_list
	if(!post2remove)
		return
	playsound(loc, 'sound/foley/dropsound/paper_drop.ogg', 50, FALSE, -1)
	loc.visible_message(span_smallred("[guy]撕下了一张告示！"))
	for(var/datum/noticeboardpost/removing_post in GLOB.noticeboard_posts)
		if(post2remove == removing_post.title && removing_post.truepostername == guy.real_name)
			GLOB.noticeboard_posts -= removing_post
			message_admins("[ADMIN_LOOKUPFLW(guy)] has removed their post, the message was [removing_post.message]")
	for(var/datum/noticeboardpost/removing_post in GLOB.premium_noticeboardposts)
		if(post2remove == removing_post.title && removing_post.truepostername == guy.real_name)
			GLOB.premium_noticeboardposts -= removing_post
			message_admins("[ADMIN_LOOKUPFLW(guy)] has removed their post, the message was [removing_post.message]")
	for(var/obj/structure/roguemachine/noticeboard/board in SSroguemachine.noticeboards)
		board.update_icon()
		if(board != src)
			playsound(board, 'sound/ambience/noises/birds (7).ogg', 50, FALSE, -1)
			board.visible_message(span_smallred("一只 ZAD告示台 落下，撤走了一张旧告示！"))

/obj/structure/roguemachine/noticeboard/proc/authority_removepost(mob/living/carbon/human/guy)
	var/list/posts_list = list()
	for(var/datum/noticeboardpost/removable_posts in GLOB.noticeboard_posts)
		posts_list += removable_posts.title
	if(!posts_list.len)
		to_chat(guy, span_warning("没有我能拆下的告示。"))
		return
	var/post2remove = input(guy, "Which post shall I take down?", src) as null|anything in posts_list
	if(!post2remove)
		return
	playsound(loc, 'sound/foley/dropsound/paper_drop.ogg', 50, FALSE, -1)
	loc.visible_message(span_smallred("[guy] tears down a posting!"))
	for(var/datum/noticeboardpost/removing_post in GLOB.noticeboard_posts)
		if(post2remove == removing_post.title)
			GLOB.noticeboard_posts -= removing_post
			message_admins("[ADMIN_LOOKUPFLW(guy)] has authoritavely removed a post, the message was [removing_post.message]")



/proc/add_post(message, chosentitle, chosenname, chosenrole, truename, premium)
	var/datum/noticeboardpost/new_post = new /datum/noticeboardpost
	new_post.poster = chosenname
	new_post.title = chosentitle
	new_post.message = message
	new_post.posterstitle = chosenrole
	new_post.truepostername = truename
	compose_post(new_post)
	GLOB.board_viewers = list()
	if(!premium)
		GLOB.noticeboard_posts += new_post
	else
		GLOB.premium_noticeboardposts += new_post



/proc/compose_post(datum/noticeboardpost/new_post)
	new_post.banner += "<center><b>[new_post.title]</b><BR>"
	new_post.banner += "[new_post.message]<BR>"
	new_post.banner += "- [new_post.poster]"
	if(new_post.posterstitle)
		new_post.banner += ", [new_post.posterstitle]"
	new_post.banner += "<BR>"
	new_post.banner += "--------------<BR>"

/datum/status_effect/debuff/postcooldown
	id = "postcooldown"
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/postcooldown

/atom/movable/screen/alert/status_effect/debuff/postcooldown
	name = "刚刚寄信"
	desc = "我得再等一会儿才能发布下一张告示！"
