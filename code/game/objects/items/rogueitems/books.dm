/obj/item/book/rogue
	var/open = FALSE
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "basic_book_0"
	slot_flags = ITEM_SLOT_HIP
	var/base_icon_state = "basic_book"
	unique = TRUE
	firefuel = 5 MINUTES
	dropshrink = 0.6
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	force = 5
	associated_skill = /datum/skill/misc/reading
	grid_width = 32
	grid_height = 32

/obj/item/book/rogue/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/book/rogue/attack_self(mob/user)
	if(!open)
		attack_right(user)
		return
	..()
	user.update_inv_hands()

/obj/item/book/rogue/rmb_self(mob/user)
	attack_right(user)
	return

/obj/item/book/rogue/read(mob/user)
	if(!open)
		to_chat(user, span_info("先把我打开。"))
		return FALSE
	. = ..()

/obj/item/book/rogue/attackby(obj/item/I, mob/user, params)
	return

/obj/item/book/rogue/attack_right(mob/user)
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	curpage = 1
	update_icon()
	user.update_inv_hands()

/obj/item/book/rogue/update_icon()
	icon_state = "[base_icon_state]_[open]"

/obj/item/book/rogue/secret/ledger
	name = "卡塔托玛账本"
	icon_state = "ledger_0"
	base_icon_state = "ledger"
	title = "Catatoma"
	dat = "要创建一份货运订单，请把纸莎草卷轴用在我身上。"

/obj/item/book/rogue/secret/ledger/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/paper/scroll/cargo))
		if(!open)
			to_chat(user, span_info("先把我打开。"))
			return FALSE
		var/obj/item/paper/scroll/cargo/C = I
		if(C.orders.len > 4)
			to_chat(user, span_warning("订单太多了。"))
			return
		var/picked_cat = input(user, "分类", "货运账本") as null|anything in sortList(SSmerchant.supply_cats)
		if(!picked_cat)
			testing("yeye")
			return
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.group == picked_cat)
				pax += PA

		var/datum/supply_pack/picked_pack = input(user, "货单", "货运账本") as null|anything in sortList(pax)
		if(!picked_pack)
			return

		C.orders += picked_pack
		C.rebuild_info()
		return
	if(istype(I, /obj/item/paper/scroll))
		if(!open)
			to_chat(user, span_info("先把我打开。"))
			return FALSE
		var/obj/item/paper/scroll/P = I
		if(P.info)
			to_chat(user, span_warning("这里已经写了东西。"))
			return
		var/picked_cat = input(user, "分类", "货运账本") as null|anything in sortList(SSmerchant.supply_cats)
		if(!picked_cat)
			return
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.group == picked_cat)
				pax += PA
		var/datum/supply_pack/picked_pack = input(user, "货单", "货运账本") as null|anything in sortList(pax)
		if(!picked_pack)
			return
		var/obj/item/paper/scroll/cargo/C = new(user.loc)

		C.orders += picked_pack
		C.rebuild_info()
		user.dropItemToGround(P)
		qdel(P)
		user.put_in_active_hand(C)
	..()

/obj/item/book/rogue/bibble
	name = "十圣诗篇与圣行"
	desc = "神圣万神殿的诗篇与圣行汇编，分为三部。</br>未裂之世 - 坠落之前的时代，戴西安议会的功业 </br>毁灭 - 敌者的崛起，唯一者的陨落 </br> 黎明 - 十圣的奠基，新希望的降临"
	icon_state = "bibble_0"
	base_icon_state = "bibble"
	title = "十圣诗篇与圣行"
	dat = "gott.json"
	possible_item_intents = list(
		/datum/intent/use, 
		/datum/intent/bless,
	)

/obj/item/book/rogue/bibble/read(mob/user)
	if(!open)
		to_chat(user, span_info("先把我打开。"))
		return FALSE
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		return
	if(in_range(user, src) || isobserver(user))
		user.changeNext_move(CLICK_CD_MELEE)
		var/list/choices = list("未裂之世", "毁灭", "黎明")
		var/section_choice = input(user,"我要读哪一部分？", "神圣启迪") as anything in choices
		var/chosentxt
		switch(section_choice)
			if("未裂之世")
				chosentxt = 'strings/visage.txt'
			if("毁灭")
				chosentxt = 'strings/decanomicon.txt'
			if("黎明")
				chosentxt = 'strings/newdawn.txt'
		var/m
		var/list/verses = world.file2list(chosentxt)
		m = pick(verses)
		if(m)
			user.say(m)

/obj/item/book/rogue/bibble/attack(atom/M, mob/user)
	if(user.mind?.assigned_role == "Bishop" && user.used_intent?.type == /datum/intent/bless && isliving(M))
		if(!user.can_read(src))
			to_chat(user, span_warning("我看不懂这些潦草的黑色字迹。"))
			return
		var/mob/living/to_bless = M
		to_bless.apply_status_effect(/datum/status_effect/buff/blessed)
		to_bless.add_stress(/datum/stressevent/blessed)
		user.visible_message(span_notice("[user]祝福了[M]。"))
		playsound(user, 'sound/magic/bless.ogg', 100, FALSE)
		return

/obj/item/book/rogue/bibble/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(user.mind?.assigned_role == "Bishop" && isitem(target) && user.used_intent?.type == /datum/intent/bless)
		var/datum/component/silverbless/CP = target.GetComponent(/datum/component/silverbless)
		if(!CP)
			to_chat(user, span_info("[target]无法被祝圣。"))
			return
		else if(!CP.is_blessed && (CP.silver_type & SILVER_TENNITE))
			playsound(user, 'sound/magic/censercharging.ogg', 100)
			user.visible_message(span_info("[user]将[src]悬于[target]之上……"))
			if(do_after(user, 5 SECONDS, target = target))
				CP.try_bless(BLESSING_TENNITE)
				new /obj/effect/temp_visual/censer_dust(get_turf(target))
			return
		else
			to_chat(user, span_info("它已经被祝圣过了。"))
			return

/obj/item/book/rogue/bibble/psy
	name = "普西顿圣典"
	desc = "'而祂哭泣。不是为你，不是为我，而是为这一切。' </br>一本皮面典籍，记述着正教会所奉持的信条；这是世上最大的普西顿教派。Otava 神职者近来发明的“哈劳斯印刷机”，确保普西多尼亚的每一处角落都能沐于祂的教诲之光。书中分为三部圣约，各以天鹅绒束带标记。</br>诗篇 - 神职智慧之圣约，昭示诠释。 </br>创世 - 普西多尼亚起源之圣约，记述往昔。 </br>祷文 - 意志之圣约，用以驱邪与咏唱。"
	icon_state = "psyble_0"
	base_icon_state = "psyble"
	title = "psyble"
	dat = "gott.json"
	var/sect = "sect1"

/obj/item/book/rogue/bibble/psy/attack(mob/living/M, mob/user)
	return

/obj/item/book/rogue/bibble/psy/read(mob/living/carbon/human/user)
	if(!open)
		to_chat(user, span_info("先把它打开。"))
		return FALSE
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		return
	if(in_range(user, src) || isobserver(user))
		user.changeNext_move(CLICK_CD_MELEE)
		var/m
		if(sect)
			var/list/verses = world.file2list("strings/psy[sect].txt")
			m = pick(verses)
			if(m)
				if(prob(1) && sect == "sect1")
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					user.say("PSY 23:4……于是 ZEZUS 哭泣了；因为他已被 JVDAS 的镀银标枪击倒，而 JVDAS 正是 PSYDON 最虔诚的信徒。")
					user.psydo_nyte()
				else
					user.say(m)

/obj/item/book/rogue/bibble/psy/MiddleClick(mob/user, params)
	. = ..()
	var/sects = list("诗篇", "创世", "祷文")
	var/sect_choice = input(user, "选择你的圣约", "普西多尼亚") as anything in sects
	switch(sect_choice)
		if("诗篇")
			sect = "sect1"
		if("创世")
			sect = "sect2"
		if("祷文")
			sect = "sect3"

/datum/status_effect/buff/blessed
	id = "blessed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/blessed
	effectedstats = list(STATKEY_LCK = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/blessed
	name = "受祝福"
	desc = ""
	icon_state = "buff"


/obj/item/book/rogue/law
	name = "正义法典"
	desc = "由费伦提亚王国王冠颁布，作为此地疆域的法律框架。"
	icon_state ="lawtome_0"
	base_icon_state = "lawtome"
	bookfile = "law_2.json"

/obj/item/book/rogue/cooking
	name = "适合领主的风味"
	desc = ""
	icon_state ="book_0"
	base_icon_state = "book"
	bookfile = "cooking.json"

		//no more theif stole the books
/obj/item/book/rogue/knowledge1
	name = "知识之书"
	desc = ""
	icon_state ="book5_0"
	base_icon_state = "book5"
	bookfile = "knowledge.json"


/obj/item/book/rogue/secret/xylix
	name = "黄金之书"
	desc = "<font color='red'><blink>一本不祥之书，蕴藏着难以言说的力量。</blink></font>"
	icon_state ="xylix_0"
	base_icon_state = "xylix"
	bookfile = "xylix.json"

/obj/item/book/rogue/xylix/attack_self(mob/user)
	if(!open)
		attack_right(user)
		return
	..()
	user.update_inv_hands()
	to_chat(user, span_notice("你感觉有笑声在脑海中回荡。"))

/obj/item/book/rogue/secret/thefireisgone
	name = "火焰已逝"
	desc = "{<font color='red'><blink>由诸神最伟大的愚者所写下的古老典籍</blink></font>}"
	icon_state ="book6_0"
	base_icon_state = "book6"
	bookfile = "thefireisgone.json"

//player made books
/obj/item/book/rogue/tales1
	name = "旧日逸闻杂谈"
	desc = "作者：Alamere J Wevensworth"
	icon_state ="book_0"
	base_icon_state = "book"
	bookfile = "tales1.json"

/obj/item/book/rogue/festus
	name = "费斯图斯之书"
	desc = "作者不详"
	icon_state ="book2_0"
	base_icon_state = "book2"
	bookfile = "tales2.json"


/obj/item/book/rogue/tales3
	name = "群峰与彼方的神话传奇 第一卷"
	desc = "作者：Arbalius the Younger"
	icon_state ="book3_0"
	base_icon_state = "book3"
	bookfile = "tales3.json"

/obj/item/book/rogue/bookofpriests
	name = "萨弗里亚圣书"
	desc = ""
	icon_state ="knowledge_0"
	base_icon_state = "knowledge"
	bookfile = "holyguide.json"

/obj/item/book/rogue/robber
	name = "盗匪读本"
	desc = "作者：Flavius of Dendor"
	icon_state ="basic_book_0"
	base_icon_state = "basic_book"
	bookfile = "tales4.json"

/obj/item/book/rogue/cardgame
	name = "《Graystone's Torment》基础规则"
	desc = "作者：Johnus of Doe"
	icon_state ="basic_book_0"
	base_icon_state = "basic_book"
	bookfile = "tales5.json"

/obj/item/book/rogue/blackmountain
	name = "《Zabrekalrek：黑山传奇》第一部"
	desc = "著者：Gorrek Tale-Writer，译者：Hargrid Men-Speaker。"
	icon_state ="book6_0"
	base_icon_state = "book6"
	bookfile = "tales6.json"

/obj/item/book/rogue/beardling
	name = "石与岩 - 胡须崽的识字书与故事集"
	desc = "由矮人联邦发行"
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "tales7.json"

/obj/item/book/rogue/abyssor
	name = "海上居民的故事"
	desc = "作者：Bellum Aegir"
	icon_state ="book2_0"
	base_icon_state = "book2"
	bookfile = "tales8.json"

/obj/item/book/rogue/necra
	name = "献给Necra的葬仪"
	desc = "作者：Hunlaf，掘墓人。修订：Lenore，Necra 祭司。"
	icon_state ="book6_0"
	base_icon_state = "book6"
	bookfile = "tales9.json"

/obj/item/book/rogue/noc
	name = "寻梦者"
	desc = "作者：Hunlaf，掘墓人。修订：Lenore，Necra 祭司。"
	icon_state ="book6_0"
	base_icon_state = "book6"
	bookfile = "tales10.json"

/obj/item/book/rogue/fishing
	name = "《Fontaine高等渔业指南》"
	desc = "作者：Ford Fontaine"
	icon_state ="book2_0"
	base_icon_state = "book2"
	bookfile = "tales11.json"

/obj/item/book/rogue/sword
	name = "六种愚行：持剑求生之道"
	desc = "作者：Theodore Spillguts"
	icon_state ="book5_0"
	base_icon_state = "book5"
	bookfile = "tales12.json"

/obj/item/book/rogue/arcyne
	name = "潜伏魔法：Arcyne之力从何而来？"
	desc = "作者：Kildren Birchwood，魔法学者"
	icon_state ="book4_0"
	base_icon_state = "book4"
	bookfile = "tales13.json"

/obj/item/book/rogue/nitebeast
	name = "夜兽传说"
	desc = "作者：Paquetto the Scholar"
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "tales14.json"

/obj/item/book/rogue/naledi1
	name = "战学者之路 第一卷"
	desc = "作者：Jatholemew von Rittensquatter, Esq"
	icon_state = "knowledge_0"
	base_icon_state = "knowledge"
	bookfile = "naledi1.json"

/obj/item/book/rogue/naledi2
	name = "战学者之路 第三卷"
	desc = "作者：Jatholemew von Rittensquatter, Esq"
	icon_state = "book8_0"
	base_icon_state = "book8"
	bookfile = "naledi2.json"

/obj/item/book/rogue/naledi3
	name = "战学者之路 第七卷"
	desc = "作者：Jatholemew von Rittensquatter, Esq"
	icon_state = "book7_0"
	base_icon_state = "book7"
	bookfile = "naledi3.json"

/obj/item/book/rogue/naledi4
	name = "战学者之路 第二十卷"
	desc = "作者：Jatholemew von Rittensquatter, Esq"
	icon_state = "book6_0"
	base_icon_state = "book6"
	bookfile = "naledi4.json"


/obj/item/book/rogue/playerbook
	var/player_book_text
	var/player_book_title
	var/player_book_author
	var/player_book_icon
	var/player_book_author_ckey
	var/is_in_round_player_generated
	var/list/book_icons = list(
	"病绿色铜纹压印" = "book8",
	"白色黑曜压印" = "book7",
	"黑色石英压印" = "book6",
	"蓝色红宝压印" = "book5",
	"绿色紫晶压印" = "book4",
	"紫色祖母绿压印" = "book3",
	"红色蓝宝压印" = "book2",
	"棕色金纹压印" = "book1",
	"棕色无压印封面" = "basic_book")
	name = "无名书册"
	desc = "由一位无名作者写就。"
	icon_state = "basic_book_0"
	base_icon_state = "basic_book"
	override_find_book = TRUE

/obj/item/book/rogue/playerbook/Initialize(mapload, in_round_player_generated, mob/living/in_round_player_mob, text)
	. = ..()
	is_in_round_player_generated = in_round_player_generated
	if(is_in_round_player_generated)
		player_book_text = text
		INVOKE_ASYNC(src, PROC_REF(prompt_for_contents), in_round_player_mob)
	else
		pick_random_book()

//Just rewrite this entirely. STRIP_HTML_SIMPLE might be insufficient, but that's just the tip of the iceberg.area
//This needs to check if an input is valid via reject_bad_text, and if not prompt the user again.
/obj/item/book/rogue/playerbook/proc/prompt_for_contents(mob/living/in_round_player_mob)
	while(!player_book_author_ckey) // doesn't have to be this, but better than defining a bool.
		player_book_title = capitalize(STRIP_HTML_SIMPLE(input(in_round_player_mob, "你想给这本书起什么标题？（最多 42 个字符）", "标题", "未知"), MAX_NAME_LEN))
		player_book_author = STRIP_HTML_SIMPLE(input(in_round_player_mob, "作者署名要写什么？（最多 42 个字符）", "作者", ""), MAX_NAME_LEN)
		player_book_icon = book_icons[input(in_round_player_mob, "选择一种书籍样式", "书籍样式") as anything in book_icons]
		player_book_author_ckey = in_round_player_mob.ckey
		//This gives the icon_state name, not the descriptive name, i. e. "book8", instead of "Sickly green with embossed Bronze"
		if(alert("确认？:\n标题：[player_book_title]\n作者：[player_book_author]\n封面：[player_book_icon]", "", "是", "否") == "否")
			player_book_author_ckey = null
		message_admins("[player_book_author_ckey]([in_round_player_mob.real_name]) has generated the player book: [player_book_title]")

	name = "[player_book_title]"
	desc = "作者：[player_book_author]"
	icon_state = "[player_book_icon]_0"
	base_icon_state = "[player_book_icon]"
	pages = list("<b3><h3>标题：[player_book_title]<br>作者：[player_book_author]</b><h3>[player_book_text]")

/obj/item/book/rogue/playerbook/proc/pick_random_book()
	var/list/player_book_titles = SSlibrarian.pull_player_book_titles()
	var/list/chosen_book = SSlibrarian.file2playerbook(pick(player_book_titles))

	player_book_title = chosen_book["book_title"]
	player_book_author = chosen_book["author"]
	player_book_author_ckey = chosen_book["author_ckey"]
	player_book_icon = chosen_book["icon"]
	player_book_text = chosen_book["text"]

	name = "[player_book_title]"
	desc = "作者：[player_book_author]"
	icon_state = "[player_book_icon]_0"
	base_icon_state = "[player_book_icon]"
	pages = list("<b3><h3>标题：[player_book_title]<br>作者：[player_book_author]</b><h3>[player_book_text]")


/obj/item/manuscript
	name = "2 页手稿"
	desc = "一份两页的手稿，期望有朝一日能成为一本书。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "manuscript"
	dir = 2
	resistance_flags = FLAMMABLE
	grid_width = 32
	grid_height = 64
	dropshrink = 0.8
	var/number_of_pages = 2
	var/compiled_pages = null
	var/list/page_texts = list()
	var/qdel_source = FALSE

/obj/item/manuscript/examine()
	. = ..()
	. += span_info("它现在有[number_of_pages]页。可用纸张继续添页，再用制书工具包完成装订。")

/obj/item/manuscript/attackby(obj/item/I, mob/living/user)
	// why is a book crafting kit using the craft system, but crafting a book isn't? Well the crafting system for *some reason* is made in such a way as to make reworking it to allow you to put reqs vars in the crafted item near *impossible.*
	if(istype(I, /obj/item/book_crafting_kit))
		qdel(I)
		var/obj/item/book/rogue/playerbook/PB = new /obj/item/book/rogue/playerbook(get_turf(loc), TRUE, user, compiled_pages)
		if(user.Adjacent(PB))
			PB.add_fingerprint(user)
			user.put_in_hands(PB)
		return qdel(src)

	if(!istype(I, /obj/item/paper))
		return
	var/obj/item/paper/P = I
	if(!(P.info))
		to_chat(user, "纸上必须先写有文字，才能加入手稿！")
		return
	if(number_of_pages == 8)
		to_chat(user, "这摞手稿最多不能超过 8 页！")
		return

	++number_of_pages
	name = "[number_of_pages] 页手稿"
	desc = "一份[number_of_pages]页的手稿，期望有朝一日能成为一本书。"
	page_texts += P.info
	compiled_pages += "<p>[P.info]</p>"
	qdel(P)

	update_icon()
	return ..()

/obj/item/manuscript/examine(mob/user)
	. = ..()
	. += "<a href='?src=[REF(src)];read=1'>阅读</a>"

/obj/item/manuscript/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["close"])
		var/mob/user = usr
		if(user?.client && user.hud_used)
			if(user.hud_used.reads)
				user.hud_used.reads.destroy_read()
			user << browse(null, "window=reading")

	var/literate = usr.is_literate()
	if(!usr.canUseTopic(src, BE_CLOSE, literate))
		return

	if(href_list["read"])
		read(usr)

/obj/item/manuscript/attack_self(mob/user)
	read(user)

/obj/item/manuscript/proc/read(mob/user)
	user << browse_rsc('html/book.png')
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		return
	if(in_range(user, src) || isobserver(user))
		var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style type=\"text/css\">
					body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes>"}
		for(var/I in page_texts)
			dat += "<p>[I]</p>"
		dat += "<br>"
		dat += "</body></html>"
		user << browse(dat, "window=reading;size=1000x700;can_close=1;can_minimize=0;can_maximize=0;can_resize=0;titlebar=1")
		onclose(user, "reading", src)
	else
		return span_warning("离得太远了，没法阅读。")

/obj/item/manuscript/update_icon()
	. = ..()
	switch(number_of_pages)
		if(2)
			dir = SOUTH
		if(3)
			dir = NORTH
		if(4)
			dir = EAST
		if(5)
			dir = WEST
		if(6)
			dir = SOUTHEAST
		if(7)
			dir = SOUTHWEST
		if(8)
			dir = NORTHWEST

/obj/item/manuscript/fire_act(added, maxstacks)
	..()
	if(!(resistance_flags & FIRE_PROOF))
		add_overlay("paper_onfire_overlay")

/obj/item/manuscript/attack_hand(mob/user)
	if(istype(user, /mob/living) && src.loc == user)
		var/mob/living/L = user
		var/obj/item/paper/P = new /obj/item/paper(get_turf(src.loc))
		L.put_in_active_hand(P)
		L.put_in_inactive_hand(src)
		P.icon_state = "paperwrite"
		P.info = page_texts[length(page_texts)]
		page_texts -= page_texts[length(page_texts)]
		--number_of_pages
		if(number_of_pages == 1)
			var/obj/item/paper/P_two = new /obj/item/paper(get_turf(src.loc))
			P_two.icon_state = "paperwrite"
			P_two.info = page_texts[length(page_texts)]
			qdel_source = TRUE
			. = ..()
			src.loc = get_turf(src.loc)
			L.put_in_hands(P_two)
			qdel(src)
			return
		else
			update_icon()
			name = "[number_of_pages] 页手稿"
			desc = "一份[number_of_pages]页的手稿，期望有朝一日能成为一本书。"
			return

	. = ..()

/obj/item/book_crafting_kit
	name = "制书工具包"
	desc = "对写好的手稿使用，以制作成书。"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "book_crafting_kit"
	dropshrink = 0.7

/obj/item/book/rogue/swatchbook
	name = "裁缝色卡簿"
	desc = "允许你从裁缝行会那套繁复得近乎夸张的已知色谱中精确挑选色相与明暗。选定后，可配合染缸使用以套用该色样。"
	icon_state = "swatchbook_0"
	base_icon_state = "swatchbook"
	title = "swatchbook"
	var/swatchbookcolor = "#000000"

/obj/item/book/rogue/swatchbook/read(mob/user)
	if(istype(user, /mob/living) && src.loc == user)
		if(!user.client || !user.hud_used)
			return
		else
			var/hexcolor = "#FFFFFF"
			hexcolor = sanitize_hexcolor(color_pick_sanitized(usr, "选择你的染色：", "染料", null, 0.2, 1), 6, TRUE)
			if(hexcolor == "#000000")
				swatchbookcolor = "#FFFFFF"
			else
				swatchbookcolor = hexcolor
			updateUsrDialog()
	else
		return

/obj/item/book/rogue/bibble/zizo
	name = "她的真理辞典"
	desc = "只要领悟她的教诲，终有一日我们将踏上她走过的道路。此卷为圣座明令禁阅之书，记述了野心之女士齐佐的凡世生涯与升格历程——或至少，是她那群“救赎”信徒所讲述的版本。"
	icon = 'icons/roguetown/items/bookszizo.dmi'
	icon_state = "zizoble_0"
	base_icon_state = "zizoble"
	title = "她之真理辞典"
	dat = "gott.json"

/obj/item/book/rogue/bibble/zizo/attack(mob/living/M, mob/user)
	return

/obj/item/book/rogue/bibble/zizo/MiddleClick(mob/user, params)
	return

/obj/item/book/rogue/bibble/zizo/read(mob/living/carbon/human/user)
	if(!open)
		to_chat(user, span_info("先把它打开。"))
		return FALSE
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		return
	if(in_range(user, src) || isobserver(user))
		user.changeNext_move(CLICK_CD_MELEE)
		var/m
		var/list/verses = world.file2list("strings/zizobibble.txt")
		m = pick(verses)
		user.say(m)
