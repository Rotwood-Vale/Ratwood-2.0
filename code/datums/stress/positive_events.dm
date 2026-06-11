/datum/stressevent/psyprayer
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("诸神正向我微笑。")

/datum/stressevent/chastity_devout
	timer = INFINITY
	stressadd = -1
	desc = span_green("这份束缚让我心神安定。")

/datum/stressevent/chastity_masochist
	timer = INFINITY
	stressadd = -1
	desc = span_green("这些尖刺让我愉快地保持专注。")

/datum/stressevent/chastity_church
	timer = INFINITY
	stressadd = -1
	desc = span_green("在这束缚中，我的誓言显得更加坚定。")

/datum/stressevent/seeblessed
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("神圣之地令我心神宁静。")

/datum/stressevent/viewsinpunish
	timer = 5 MINUTES
	stressadd = -2
	desc = span_green("我看到罪人受到了惩罚！")

/datum/stressevent/joke
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("我听到了个不错的笑话。")

/datum/stressevent/tragedy
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("到头来，生活也没那么糟。")

/datum/stressevent/blessed
	timer = 60 MINUTES
	stressadd = -2
	desc = span_green("我感受到一股安抚人心的存在。")

/datum/stressevent/gnoll_graggar
	timer = 1 MINUTES
	stressadd = -2
	desc = span_green("是 Gnoll！Graggar 的祝福庇佑着我！")

/datum/stressevent/triumph
	timer = 10 MINUTES
	stressadd = -5
	desc = span_boldgreen("我回想起了一次 TRIUMPH。")

/datum/stressevent/drunk
	timer = 1 MINUTES
	stressadd = -2
	desc = list(span_green("酒精缓解了痛苦。"),span_green("酒精啊，我真正的朋友。"))

/datum/stressevent/pweed
	timer = 1 MINUTES
	stressadd = -2
	desc = list(span_green("一口令人放松的烟。"),span_green("一口风味十足的烟。"))

/datum/stressevent/menthasmoke
	timer = 1 MINUTES
	stressadd = -1
	desc = list(span_blue("喉咙里泛起一阵清凉。"))

/datum/stressevent/weed
	timer = 5 MINUTES
	stressadd = -4
	desc = span_blue("甜叶啊，我爱你。")

/datum/stressevent/high
	timer = 5 MINUTES
	stressadd = -4
	desc = span_blue("我飘得厉害，别把我的天穹夺走。")

/datum/stressevent/stuffed
	timer = 20 MINUTES
	stressadd = -1
	desc = span_green("我吃得饱饱的！感觉真好。")

/datum/stressevent/goodsnack
	timer = 8 MINUTES
	stressadd = -1
	desc = list(span_green("那份零嘴味道真不错。"), span_green("可口的小点心。"))

/datum/stressevent/greatsnack
	timer = 10 MINUTES
	stressadd = -2
	desc = list(span_green("那份零嘴太棒了！我已经等不及下一份。"), span_green("真棒的小点心！我之后该再来一份。"))

/datum/stressevent/goodmeal
	timer = 10 MINUTES
	stressadd = -1
	desc = list(span_green("那顿饭相当不错。"), span_green("总算吃上了一顿像样的饭。"))

/datum/stressevent/greatmeal
	timer = 15 MINUTES
	stressadd = -2
	desc = list(span_green("那顿饭真是美味！"), span_green("我像贵族一样饱餐了一顿，真痛快！"))

/datum/stressevent/sweet
	timer = 8 MINUTES
	stressadd = -2
	desc = list(span_green("甜食总能让人心情变好。"), span_green("甜美的慰藉。"))

/datum/stressevent/hydrated
	timer = 10 MINUTES
	stressadd = -1
	desc = span_green("我的口渴得到了缓解，真提神。")

/datum/stressevent/prebel
	timer = 5 MINUTES
	stressadd = -5
	desc = span_boldgreen("打倒暴政！")

/datum/stressevent/fresh_haircut
	timer = 60 MINUTES
	stressadd = -2
	desc = span_green("我的头发刚被精心修剪打理过。")

/datum/stressevent/music
	timer = 1 MINUTES
	stressadd = -1
	desc = span_green("一段悦耳的旋律让我放松下来。")

/datum/stressevent/music/two
	stressadd = -2
	desc = span_green("这段旋律为我的心神带来柔和的宁静。")
	timer = 2 MINUTES

/datum/stressevent/music/three
	stressadd = -2
	desc = span_green("附近有位技艺娴熟之人正在演奏，抚慰着我的神经。")
	timer = 4 MINUTES

/datum/stressevent/music/four
	stressadd = -3
	desc = span_green("高超的演奏让整个世界都变得轻盈起来。")
	timer = 6 MINUTES

/datum/stressevent/music/five
	stressadd = -3
	timer = 8 MINUTES
	desc = span_boldgreen("一场大师级的演出！我感动得说不出话。")

/datum/stressevent/music/six
	stressadd = -4
	timer = 10 MINUTES
	desc = span_boldgreen("传奇般的乐声充满了空气，令我的灵魂都为之震颤！")

/datum/stressevent/vblood
	stressadd = -5
	desc = span_boldred("处子之血！")
	timer = 5 MINUTES

/datum/stressevent/bathwater
	stressadd = -1
	desc = span_blue("真让人放松。")
	timer = 1 MINUTES

/datum/stressevent/sakura_view
	stressadd = -2
	timer = 30 MINUTES
	desc = span_green("樱花之美令我心生宁静。")

/datum/stressevent/flower_view
	stressadd = -1
	timer = 15 MINUTES
	desc = span_green("看到那些漂亮的花朵让我心情振奋！")

/datum/stressevent/bathwater/on_apply(mob/living/user)
	. = ..()
	if(user.client)
		record_round_statistic(STATS_BATHS_TAKEN)
		// SEND_SIGNAL(user, COMSIG_BATH_TAKEN)

/datum/stressevent/beautiful
	stressadd = -2
	desc = span_green("那张脸简直是件艺术品！")
	timer = 2 MINUTES

/datum/stressevent/night_owl
	stressadd = -3
	desc = span_green("夜晚是如此宁静而令人放松。")
	timer = 20 MINUTES

/datum/stressevent/ozium
	stressadd = -99
	desc = span_blue("我吸了一口，进入了一个没有痛苦的世界。")
	timer = 2 MINUTES

/datum/stressevent/moondust
	stressadd = -6
	desc = span_boldgreen("Moondust 正在我体内奔涌。")
	timer = 4 MINUTES

/datum/stressevent/starsugar
	stressadd = -1
	desc = span_boldgreen("我的心脏狂跳，血液奔流，整个人像被紧紧拧在一起。我现在都能跑场马拉松。")
	timer = 4 MINUTES

/datum/stressevent/moondust_purest
	stressadd = -8
	desc = span_boldgreen("纯粹的 Moondust 正在我体内奔涌！")
	timer = 4 MINUTES

/datum/stressevent/campfire
	stressadd = -1
	desc = span_green("火焰的温暖令人安心。")
	timer = 5 MINUTES

/datum/stressevent/puzzle_easy
	stressadd = -1
	desc = span_green("那道谜题让我暂时忘却了这些乏味烦闷。")
	timer = 10 MINUTES

/datum/stressevent/puzzle_medium
	stressadd = -2
	desc = span_green("我解开了一道略有难度的谜题。要是现实中的问题也这么简单就好了。")
	timer = 10 MINUTES

/datum/stressevent/puzzle_hard
	stressadd = -3
	desc = span_green("我解开了一道颇具挑战的谜题。")
	timer = 10 MINUTES

/datum/stressevent/puzzle_impossible
	stressadd = -4
	desc = span_boldgreen("我解开了一道极其困难的谜题。Xylix 正对我微笑，就连 Noc 想必也会觉得这很了不起。")
	timer = 15 MINUTES

/datum/stressevent/noble_lavish_food
	stressadd = -4
	desc = span_green("这才是真正配得上我身份的盛宴。")
	timer = 30 MINUTES

/datum/stressevent/wine_okay
	stressadd = -1
	desc = span_green("那杯饮品还不错。")
	timer = 10 MINUTES

/datum/stressevent/wine_good
	stressadd = -2
	desc = span_green("不错的佳酿总是顺喉易饮。")
	timer = 10 MINUTES

/datum/stressevent/wine_great
	stressadd = -3
	desc = span_blue("这年份酒绝对精妙无比，毫无疑问。")
	timer = 10 MINUTES

/datum/stressevent/favourite_food
	stressadd = -1
	desc = span_green("我吃到了自己最爱的食物！")
	timer = 5 MINUTES

/datum/stressevent/favourite_food/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_event(/datum/stressevent/favourite_food))
		return FALSE
	else if(ishuman(user))
		var/mob/living/carbon/human/human_eater = user
		if(human_eater.culinary_preferences && human_eater.culinary_preferences[CULINARY_FAVOURITE_FOOD])
			var/favorite_food_type = human_eater.culinary_preferences[CULINARY_FAVOURITE_FOOD]
			var/obj/item/reagent_containers/food/snacks/favorite_food_instance = favorite_food_type
			timer = timer * max(initial(favorite_food_instance.faretype), 1)
			return TRUE

/datum/stressevent/favourite_drink
	stressadd = -1
	desc = span_green("我喝到了自己最爱的饮品！")
	timer = 5 MINUTES

/datum/stressevent/favourite_drink/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_event(/datum/stressevent/favourite_drink))
		return FALSE
	else if(ishuman(user))
		var/mob/living/carbon/human/human_drinker = user
		if(human_drinker.culinary_preferences && human_drinker.culinary_preferences[CULINARY_FAVOURITE_DRINK])
			var/favorite_drink_type = human_drinker.culinary_preferences[CULINARY_FAVOURITE_DRINK]
			var/datum/reagent/consumable/favorite_drink_instance = favorite_drink_type
			timer = timer * max(1 + initial(favorite_drink_instance.quality), 1)
			return TRUE

/datum/stressevent/hated_food
	stressadd = 1
	desc = span_red("我竟不得不吃下自己最讨厌的食物！")
	timer = 10 MINUTES

/datum/stressevent/hated_food/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_event(/datum/stressevent/hated_food))
		return FALSE

/datum/stressevent/hated_drink
	stressadd = 1
	desc = span_red("我竟不得不喝下自己最讨厌的饮品！")
	timer = 10 MINUTES

/datum/stressevent/hated_drink/can_apply(mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(user.has_stress_event(/datum/stressevent/hated_drink))
		return FALSE

/datum/stressevent/meditation
	timer = 10 MINUTES
	stressadd = -1
	desc = span_green("我的冥想颇有收获。")

/datum/stressevent/bathcleaned
	timer = 20 MINUTES
	stressadd = -3
	desc = span_green("我感觉自己洁净无瑕！")

/datum/stressevent/bath
	timer = 10 MINUTES
	stressadd = -1
	desc = span_green("我稍微干净了一些。")


/datum/stressevent/pacified
	timer = 30 MINUTES
	stressadd = -5
	desc = span_green("我的烦恼全都被冲洗干净了！")

/datum/stressevent/peacecake
	timer = 5 MINUTES
	stressadd = -3
	desc = span_green("我的烦恼慢慢消散了。")

/datum/stressevent/noble_bowed_to
	timer = 5 MINUTES
	stressadd = -3
	desc = span_green("有人给予了我作为贵族应得的尊重。")

/datum/stressevent/noble_bowed_to/can_apply(mob/living/user)
	return HAS_TRAIT(user, TRAIT_NOBLE)

/datum/stressevent/noble_bowed_at
	timer = 10 MINUTES
	stressadd = -5
	desc = span_green("一位贵族向我鞠躬了！我当真受人尊敬！")

/datum/stressevent/noble_bowed_at/can_apply(mob/living/user)
	return !HAS_TRAIT(user, TRAIT_NOBLE)

/datum/stressevent/perfume
	stressadd = -1
	desc = span_green("一股令人安宁的芬芳笼罩着我。")
	timer = 10 MINUTES

/datum/stressevent/astrata_grandeur
	timer = 30 MINUTES
	stressadd = -2
	desc = span_green("Astrata 的光辉正耀眼地穿透我。我绝不能让任何人忘记这一点。")

/datum/stressevent/graggar_culling_finished
	stressadd = -1
	desc = span_green("我战胜了自己的宿敌！Graggar 如今正眷顾着我！")
	timer = INFINITY

/datum/stressevent/eoran_blessing
	stressadd = -1
	desc = span_info("一位 Eoran 将其光辉洒在了我身上。")
	timer = 5 MINUTES

/datum/stressevent/eoran_blessing_greater
	stressadd = -2
	desc = span_info("一位虔诚的 Eoran 将其光辉洒在了我身上。")
	timer = 10 MINUTES

/datum/stressevent/guillotinekill
	stressadd = -5
	desc = span_green("真是一场不错的现代娱乐。")
	timer = 10 MINUTES

/datum/stressevent/gazeuponme
	stressadd = -5
	desc = span_green("我是在 Ten 注视下的异端……我的 Patron 以我为傲！")
	timer = INFINITY

/datum/stressevent/sermon
	stressadd = -5
	desc = span_green("这场布道让我深受鼓舞。")
	timer = 20 MINUTES

/datum/stressevent/goodloving
	timer = 5 MINUTES
	stressadd = -3
	desc = "<span class='green'>我得到了爱意，而那感觉美妙无比！</span>"


/datum/stressevent/dimwitted
	timer = 10 MINUTES
	stressadd = -4
	desc = span_green("一切都变得简单而美好……")

/datum/stressevent/feebleminded
	timer = 10 MINUTES
	stressadd = -10
	desc = span_green("嘿嘿……")


/datum/stressevent/champion
	stressadd = -3
	desc = span_green("我就在我的受护者身边！")
	timer = 1 MINUTES

/datum/stressevent/ward
	stressadd = -3
	desc = span_green("我就在我的 Champion 身边！哦，哦，Champion！")
	timer = 1 MINUTES

/datum/stressevent/blessed_weapon
	stressadd = -3
	timer = INFINITY
	desc = span_green("我正挥舞着一把受祝福的武器！")

/datum/stressevent/hand_fed_fruit
	stressadd = -1
	timer = 5 MINUTES
	desc = span_green("何等奢靡！")

/datum/stressevent/fermented_crab_good
	stressadd = -1
	desc = span_green("那发酵螃蟹绝不是最可口的菜肴，但体内涌现的青春活力值得这份牺牲！")
	timer = 3 MINUTES

/datum/stressevent/dragon_scale
	stressadd = -6
	desc = span_suppradio("Hoardmaster 的贪婪正在拨弄我的心智……")
	timer = INFINITY

/datum/stressevent/oath_ring
	stressadd = -1
	desc = span_aiprivradio("我的誓言支撑着我继续前行。一步一步地走下去。我还能坚持多久？又已经过去多久了？")
	timer = INFINITY

/datum/stressevent/keep_standard
	stressadd = -4
	desc = span_aiprivradio("那面旗帜诉说着确定无疑。")
	timer = INFINITY

/datum/stressevent/keep_standard_lesser
	stressadd = -3
	desc = span_aiprivradio("那面旗帜正在呼唤我！它知道我们终将见证胜利！")
	timer = 3 MINUTES

/datum/stressevent/parasolrain
	timer = 1 MINUTES
	stressadd = -2
	desc = list(span_blue("撑伞漫步雨中，实在惬意。"))

/datum/stressevent/bloodrevel
	timer = 1 MINUTES
	stressadd = 4
	desc = span_red("天上下着血雨！愿我的 Patron 受赞颂！")

/datum/stressevent/fireflies
	timer = 10 MINUTES
	stressadd = -5
	desc = span_boldgreen("多么奇妙的萤火虫啊……")

/datum/stressevent/xylixian_fate
	timer = 10 MINUTES
	stressadd = -2
	desc = span_green("Xylix 将命运之线编向了我这一边！毫无疑问，我正受眷顾！")
