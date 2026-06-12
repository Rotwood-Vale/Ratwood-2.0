/obj/item/reagent_containers/food/snacks/fish
	name = "鱼"
	desc = "鲜血沾在银亮的鱼皮上，银色鳞片仍在微微发光。"
	icon_state = "carp"
	icon = 'modular/Neu_food/icons/raw/raw_fish.dmi'
	verb_say = "咕噜"
	verb_yell = "咕噜噜"
	obj_flags = CAN_BE_HIT
	var/dead = TRUE
	var/no_rarity_sprite = FALSE // Whether this fish has rarity based sprites. If not, don't change icon states
	var/sinkable = TRUE
	max_integrity = 50
	sellprice = 10
	dropshrink = 0.6
	slices_num = 2
	slice_bclass = BCLASS_CHOP
	chopping_sound = TRUE
	var/rarity_rank = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = 3)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/fish
	eat_effect = /datum/status_effect/debuff/uncookedfood
	cooked_smell = /datum/pollutant/food/cooked_fish

/obj/item/reagent_containers/food/snacks/fish/dead
	dead = TRUE

/obj/item/reagent_containers/food/snacks/fish/Initialize(mapload)
	. = ..()
	var/rarity = pickweight(list("gold" = 1, "ultra" = 40, "rare"= 50, "com"= 900))
	if(!no_rarity_sprite)
		icon_state = "[initial(icon_state)][rarity]"
	switch(rarity)
		if("gold")
			sellprice = sellprice * 10
			name = "传奇[initial(name)]"
			rarity_rank = 3
		if("ultra")
			sellprice = sellprice * 4
			name = "超稀有[initial(name)]"
			rarity_rank = 2
		if("rare")
			sellprice = sellprice * 2
			name = "稀有[initial(name)]"
			rarity_rank = 1
		if("com")
			name = "普通[initial(name)]"
	if(!dead)
		START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/food/snacks/fish/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(dead)
		..()
	else
		if(isturf(user.loc))
			src.forceMove(user.loc)
		to_chat(user, span_warning("太滑了！"))
		return

/obj/item/reagent_containers/food/snacks/fish/process()
	if(!isturf(loc)) //no floating out of bags
		return
	if(prob(50) && !dead)
		dir = pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		step(src, dir)

/obj/item/reagent_containers/food/snacks/fish/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/reagent_containers/food/snacks/fish/deconstruct()
	if(!dead)
		dead = TRUE
//		icon_state = "[icon_state]"
		STOP_PROCESSING(SSobj, src)
		return 1

/obj/item/reagent_containers/food/snacks/fish/after_throw(datum/callback/callback)
	. = ..()
	sinkable = TRUE

/obj/item/reagent_containers/food/snacks/fish/salmon
	name = "鲑鱼"
	desc = "一种孤独又骇人的淡水生物，终生都在寻找配偶。不过吃起来倒是不错。"
	icon_state = "salmon"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 15
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon

/obj/item/reagent_containers/food/snacks/fish/plaice
	name = "鲽鱼"
	desc = "常见又受欢迎的食用比目鱼，不论贵族还是农户的餐桌上都能见到。"
	icon_state = "plaice"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 15
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice

/obj/item/reagent_containers/food/snacks/fish/mudskipper
	name = "弹涂鱼"
	desc = "一种鬼鬼祟祟的生物，总爱躲在浑水里，把自己那副怪模怪样藏起来。"
	icon_state = "mudskipper"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mudskipper
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/mudskipper

/obj/item/reagent_containers/food/snacks/fish/bass
	name = "海鲈鱼"
	desc = "要不是它摆在这儿，我还真没看见鲈鱼。"
	icon_state = "seabass"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 10
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/bass
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/bass

/obj/item/reagent_containers/food/snacks/fish/sunny
	name = "日耀鱼"
	desc = "这可怜的小东西贪恋着阿斯特拉塔的光，仿佛那能让自己变强。它却不知道，奇迹还得靠信仰。"
	icon_state = "sunny"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 3
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny

/obj/item/reagent_containers/food/snacks/fish/carp
	name = "鲤鱼"
	desc = "一种翻搅河底淤泥的生物，勉强能拿来充饥。"
	faretype = FARE_IMPOVERISHED
	icon_state = "carp"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/carp

/obj/item/reagent_containers/food/snacks/fish/clownfish
	name = "小丑鱼"
	desc = "这条鱼给阴沉的世界添上了一抹鲜亮色彩。"
	icon_state = "clownfish"
	faretype = FARE_NEUTRAL
	sellprice = 40
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish

/obj/item/reagent_containers/food/snacks/fish/angler
	name = "鮟鱇鱼"
	desc = "一种令人不安的深渊掠食者。"
	faretype = FARE_NEUTRAL
	icon_state = "angler"
	sellprice = 15
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/angler
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/angler

/obj/item/reagent_containers/food/snacks/fish/eel
	name = "鳗鱼"
	desc = "细长滑溜的鳗鱼，在黑水之中蜿蜒穿行。"
	icon_state = "eel"
	faretype = FARE_NEUTRAL
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/eel
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/eel

/obj/item/reagent_containers/food/snacks/fish/sole
	name = "鳎鱼"
	desc = "这种丑陋的比目鱼又黏又滑，两只眼都长在头的一侧，和脚可没半点关系。"
	icon_state = "sole"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sole
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/sole

/obj/item/reagent_containers/food/snacks/fish/cod
	name = "鳕鱼"
	desc = "噢，是条鳕鱼！你能不能“鳕”我再递一块鱼饵？"
	icon_state = "cod"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/cod

/obj/item/reagent_containers/food/snacks/fish/creepy_eel
	name = "深渊鳗"
	desc = "捡起我捡起我捡起我捡起我捡起我捡起我！"
	icon_state = "creepy_eel"
	faretype = FARE_IMPOVERISHED
	no_rarity_sprite = TRUE
	var/was_i_picked_up = FALSE
	dropshrink = 0

/obj/item/reagent_containers/food/snacks/fish/creepy_eel/pickup(mob/living/user)
	if(!was_i_picked_up && ishuman(user))
		teleport_to_dream(user, 1, 1)
		was_i_picked_up = TRUE
		desc = "一条滑腻的鳗鱼。看着它时，你莫名感到一种诡异的平常……你确信它完全没有任何古怪之处。它简直就是世上最普通的东西。"
	..()

/obj/item/reagent_containers/food/snacks/fish/creepy_squid
	name = "脑形乌贼"
	desc = "它让我有点不太舒服……"
	icon_state = "creepy_squid"
	faretype = FARE_IMPOVERISHED
	no_rarity_sprite = TRUE
	dropshrink = 0

/obj/item/reagent_containers/food/snacks/fish/creepy_squid/examine(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(ishuman(H) && !HAS_TRAIT(H, TRAIT_NOMOOD) && H.patron.type != /datum/patron/divine/abyssor)
		. += span_danger("我仔细端详这只乌贼时，看见它的身躯延展成一头凶恶可怖的幽影怪物。无数触手接上遍布尖刺的肢体，一只巨大独眼正回瞪着我。幻象随即消散……")
		H.add_stress(/datum/stressevent/creepy_squid)
		H.emote("scream")
		H.Knockdown(1)
	else if(H.patron.type == /datum/patron/divine/abyssor)
		. += span_notice("这是我此生所见最美丽的生灵。")
		user.add_stress(/datum/stressevent/creepy_squid_happy)

/datum/stressevent/creepy_squid
	timer = 5 MINUTES
	stressadd = 2
	desc = span_danger("我不知道自己究竟看见了什么，可那可怖形体的残影仍在我视野边缘徘徊。")

/datum/stressevent/creepy_squid_happy
	timer = 25 MINUTES
	stressadd = -1
	desc = span_notice("看到那只美丽的乌贼让我打从心底高兴！")

/obj/item/reagent_containers/food/snacks/fish/creepy_shark
	name = "虹彩掠夺者"
	desc = "它的鳞片以一种诡异而令人不安的方式折射着光。"
	icon_state = "creepy_shark"
	faretype = FARE_IMPOVERISHED
	no_rarity_sprite = TRUE
	dropshrink = 0
	var/loot_spawn_cooldown

// I'll probably give this a cooler effect later, but scope creep ahhh.
/obj/item/reagent_containers/food/snacks/fish/creepy_shark/attack_self(mob/user)
	if(world.time < loot_spawn_cooldown)
		var/time_left = (loot_spawn_cooldown - world.time) / (1 MINUTES)
		var/minutes_left = round(time_left, 0.1)
		to_chat(user, span_warning("[src]显得死气沉沉。还要大约[minutes_left]分钟才能再次产出。"))
		return TRUE

	var/obj/effect/spawner/lootdrop/roguetown/abyssor/table = new /obj/effect/spawner/lootdrop/roguetown/abyssor
	var/list/loot_table = table.loot
	if(!loot_table || !loot_table.len)
		to_chat(user, span_warning("[src]微微闪烁，却什么都没有发生。"))
		return TRUE

	var/lootspawn = pickweight(loot_table)

	if(!lootspawn)
		to_chat(user, span_warning("[src]微微闪烁，却什么都没有发生。"))
		return TRUE

	var/obj/item/I = new lootspawn()

	if(user.put_in_hands(I))
		to_chat(user, span_notice("[src]轻轻闪烁，[I]的重量忽然在你手中凝成实体！"))
	else
		I.forceMove(user.drop_location())
		to_chat(user, span_notice("[src]轻轻闪烁，[I]出现在你脚边！"))

	loot_spawn_cooldown = world.time + 30 MINUTES
	return TRUE

/obj/item/reagent_containers/food/snacks/fish/creepy_shark/examine(mob/user)
	. = ..()
	if(loot_spawn_cooldown && world.time < loot_spawn_cooldown)
		var/time_left = (loot_spawn_cooldown - world.time) / (1 MINUTES)
		var/minutes_left = round(time_left, 0.1)
		. += span_notice("它现在还很沉寂，暂时不能挤压。还需要大约[minutes_left]分钟。")
	else
		. += span_notice("你几乎能听见它催促你把它握在手里用力一挤。")
