//goat
/mob/living/simple_animal/hostile/retaliate/goat
	name = "山羊"
	desc = ""
	icon_state = "goat"
	icon_living = "goat"
	icon_dead = "goat_dead"
	speak = list("EHEHEHEHEH","eh?")
	speak_emote = list("叫唤")
	emote_hear = list("叫唤。")
	emote_see = list("摇了摇头。", "跺了跺脚。", "环顾四周瞪着。")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 4)
	response_help_continuous = "抚摸了"
	response_help_simple = "抚摸"
	response_disarm_continuous = "轻轻推开了"
	response_disarm_simple = "轻轻推开"
	response_harm_continuous = "踢了"
	response_harm_simple = "踢"
	faction = list("neutral")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	attack_same = 0
	attack_verb_continuous = "踢了"
	attack_verb_simple = "踢"
	attack_sound = 'sound/blank.ogg'
	health = 40
	maxHealth = 40
	minbodytemp = 180
	melee_damage_lower = 1
	melee_damage_upper = 2
	environment_smash = ENVIRONMENT_SMASH_NONE
	stop_automated_movement_when_pulled = 1
	blood_volume = BLOOD_VOLUME_NORMAL
	food_type = list(/obj/item/reagent_containers/food/snacks/grown)
	var/obj/item/udder/udder = null

	footstep_type = FOOTSTEP_MOB_SHOE

/mob/living/simple_animal/hostile/retaliate/goat/Initialize(mapload)
	udder = new()
	. = ..()

/mob/living/simple_animal/hostile/retaliate/goat/Destroy()
	qdel(udder)
	udder = null
	return ..()

/mob/living/simple_animal/hostile/retaliate/goat/Life()
	. = ..()
	if(.)
		//chance to go crazy and start wacking stuff
		if(!enemies.len && prob(1))
			Retaliate()

		if(enemies.len && prob(10))
			enemies = list()
			LoseTarget()
			src.visible_message(span_notice("[src]冷静了下来。"))
	if(stat == CONSCIOUS)
		udder.generateMilk()
		eat_plants()
		if(!pulledby)
			for(var/direction in shuffle(list(1,2,4,8,5,6,9,10)))
				var/step = get_step(src, direction)
				if(step)
					if(locate(/obj/structure/vine) in step || locate(/obj/structure/glowshroom) in step)
						Move(step, get_dir(src, step))

/mob/living/simple_animal/hostile/retaliate/goat/Retaliate()
	..()
	src.visible_message(span_danger("[src]眼中闪过邪恶的光芒。"))

/mob/living/simple_animal/hostile/retaliate/goat/attackby(obj/item/O, mob/user, params)
	if(stat == CONSCIOUS && istype(O, /obj/item/reagent_containers/glass))
		udder.milkAnimal(O, user)
		return 1
	else
		return ..()

//cow
/mob/living/simple_animal/cow
	name = "奶牛"
	desc = ""
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("moo?","moo","MOOOOOO")
	speak_emote = list("哞哞叫")
	emote_hear = list("咀嚼着。")
	emote_see = list("摇了摇头。", "咀嚼着反刍物。")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat = 6)
	response_help_continuous = "抚摸了"
	response_help_simple = "抚摸"
	response_disarm_continuous = "轻轻推开了"
	response_disarm_simple = "轻轻推开"
	response_harm_continuous = "踢了"
	response_harm_simple = "踢"
	attack_verb_continuous = "踢了"
	attack_verb_simple = "踢"
	attack_sound = 'sound/blank.ogg'
	health = 100
	maxHealth = 100
	var/obj/item/udder/udder = null
	gold_core_spawnable = FRIENDLY_SPAWN
	blood_volume = BLOOD_VOLUME_NORMAL
	food_type = list(/obj/item/reagent_containers/food/snacks/grown/wheat, /obj/item/reagent_containers/food/snacks/grown/oat)
	tame_chance = 25
	bonus_tame_chance = 15
	footstep_type = FOOTSTEP_MOB_SHOE
	pooptype = /obj/item/natural/poo/cow

/mob/living/simple_animal/cow/Initialize(mapload)
	if(gender == FEMALE)
		udder = new()
	. = ..()

/mob/living/simple_animal/cow/Destroy()
	if(udder)
		qdel(udder)
		udder = null
	return ..()

/mob/living/simple_animal/cow/attackby(obj/item/O, mob/user, params)
	if(gender == FEMALE && stat == CONSCIOUS && istype(O, /obj/item/reagent_containers/glass))
		udder.milkAnimal(O, user)
		return 1
	else
		return ..()

/mob/living/simple_animal/cow/tamed()
	. = ..()
	can_buckle = TRUE
	buckle_lying = FALSE
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 8), TEXT_SOUTH = list(0, 8), TEXT_EAST = list(-2, 8), TEXT_WEST = list(2, 8)))
	D.set_riding_offsets(2, list(TEXT_NORTH = list(0, 0), TEXT_SOUTH = list(0, 16), TEXT_EAST = list(-10, 8), TEXT_WEST = list(10, 8)))
	D.set_vehicle_dir_layer(SOUTH, ABOVE_MOB_LAYER)
	D.set_vehicle_dir_layer(NORTH, OBJ_LAYER)
	D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
	D.set_vehicle_dir_layer(WEST, OBJ_LAYER)

/mob/living/simple_animal/cow/Life()
	. = ..()
	if(stat == CONSCIOUS && gender == FEMALE)
		udder.generateMilk()

/mob/living/simple_animal/cow/attack_hand(mob/living/carbon/M)
	if(gender == FEMALE && !stat && M.used_intent.type == INTENT_DISARM && icon_state != "[initial(icon_state)]_tip")
		M.visible_message(span_warning("[M]把[src]推倒了。"),
			span_notice("我把[src]推倒了。"))
		to_chat(src, span_danger("我被[M]推倒了！"))
		Paralyze(60, ignore_canstun = TRUE)
		icon_state = "[initial(icon_state)]_tip"
		spawn(rand(20,50))
			if(!stat && M)
				icon_state = icon_living
				var/external
				var/internal
				switch(pick(1,2,3,4))
					if(1,2,3)
						var/text = pick("哀求地看着", "恳求地看着",
							"带着一副听天由命的表情看着")
						external = "[src][text][M]。"
						internal = "你[text][M]。"
					if(4)
						external = "[src]似乎对命运逆来顺受。"
						internal = "你对自己的命运逆来顺受。"
				visible_message(span_notice("[external]"),
					span_revennotice("[internal]"))
	else
		..()

/mob/living/simple_animal/chick
	name = "\improper 雏鸡"
	desc = ""
	icon_state = "chick"
	icon_living = "chick"
	icon_dead = "chick_dead"
	icon_gib = "chick_gib"
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	speak_emote = list("啾啾叫")
	emote_hear = list("啾啾叫。")
	emote_see = list("啄了啄地面。","扑扇着小翅膀。")
	density = FALSE
	speak_chance = 2
	turns_per_move = 2
	butcher_results = list(/obj/item/reagent_containers/food/snacks/fat = 1)
	response_help_continuous = "抚摸了"
	response_help_simple = "抚摸"
	response_disarm_continuous = "轻轻推开了"
	response_disarm_simple = "轻轻推开"
	response_harm_continuous = "踢了"
	response_harm_simple = "踢"
	attack_verb_continuous = "踢了"
	attack_verb_simple = "踢"
	food_type = list(/obj/item/reagent_containers/food/snacks/grown/wheat)
	health = 3
	maxHealth = 3
	ventcrawler = VENTCRAWLER_ALWAYS
	var/amount_grown = 0
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	gold_core_spawnable = FRIENDLY_SPAWN

	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/chick/Initialize(mapload)
	. = ..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple_animal/chick/Life()
	. =..()
	if(!.)
		return
	if(!stat && !ckey)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			new /mob/living/simple_animal/hostile/retaliate/rogue/chicken(src.loc)
			qdel(src)

/mob/living/simple_animal/chick/holo/Life()
	..()
	amount_grown = 0

/mob/living/simple_animal/chicken
	name = "\improper 鸡"
	desc = ""
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	icon_state = "chicken_brown"
	icon_living = "chicken_brown"
	icon_dead = "chicken_brown_dead"
	speak = list("Cluck!","BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	speak_emote = list("咯咯叫","咕咕低鸣")
	emote_hear = list("咯咯叫。")
	emote_see = list("啄了啄地面。","凶狠地扑扇着翅膀。")
	density = FALSE
	speak_chance = 2
	turns_per_move = 3
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat = 1)
	var/egg_type = /obj/item/reagent_containers/food/snacks/egg
	food_type = list(/obj/item/reagent_containers/food/snacks/grown/wheat, /obj/item/reagent_containers/food/snacks/grown/oat)
	response_help_continuous = "抚摸了"
	response_help_simple = "抚摸"
	response_disarm_continuous = "轻轻推开了"
	response_disarm_simple = "轻轻推开"
	response_harm_continuous = "踢了"
	response_harm_simple = "踢"
	attack_verb_continuous = "踢了"
	attack_verb_simple = "踢"
	health = 15
	maxHealth = 15
	ventcrawler = VENTCRAWLER_ALWAYS
	var/eggsleft = 0
	var/eggsFertile = TRUE
	var/body_color
	var/icon_prefix = "chicken"
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	var/list/feedMessages = list("它开心地咯咯叫。","它开心地咯咯叫。")
	var/list/layMessage = EGG_LAYING_MESSAGES
	var/list/validColors = list("brown","black","white")
	gold_core_spawnable = FRIENDLY_SPAWN
	var/static/chicken_count = 0

	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/chicken/Initialize(mapload)
	. = ..()
	if(!body_color)
		body_color = pick(validColors)
	icon_state = "[icon_prefix]_[body_color]"
	icon_living = "[icon_prefix]_[body_color]"
	icon_dead = "[icon_prefix]_[body_color]_dead"
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	++chicken_count

/mob/living/simple_animal/chicken/Destroy()
	--chicken_count
	return ..()

/mob/living/simple_animal/chicken/attackby(obj/item/O, mob/user, params)
	if(food_typecache?[O.type]) //feedin' dem chickens
		if(!stat && eggsleft < 8)
			var/feedmsg = "[user]喂了[O]给[name]！[pick(feedMessages)]"
			user.visible_message(feedmsg)
			qdel(O)
			eggsleft += rand(1, 4)
		else
			to_chat(user, span_warning("[name]看起来不饿！"))
	else
		..()

/mob/living/simple_animal/chicken/Life()
	. =..()
	if(!.)
		return
	if((!stat && prob(3) && eggsleft > 0) && egg_type)
		visible_message(span_alertalien("[src] [pick(layMessage)]"))
		eggsleft--
		var/obj/item/E = new egg_type(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(eggsFertile)
			if(chicken_count < MAX_CHICKENS && prob(25))
				START_PROCESSING(SSobj, E)

/obj/item/reagent_containers/food/snacks/egg/var/amount_grown = 0
/obj/item/reagent_containers/food/snacks/egg/process()
	..()
	if(fertile)
		if(isturf(loc))
			amount_grown += rand(1,2)
			if(amount_grown >= 100)
				visible_message(span_notice("[src]伴随着轻微的裂壳声孵化了。"))
				new /mob/living/simple_animal/chick(get_turf(src))
				STOP_PROCESSING(SSobj, src)
				qdel(src)


/obj/item/udder
	name = "乳房"
	var/in_use // so you can't spam milking sounds

/obj/item/udder/Initialize(mapload)
	create_reagents(100)
	reagents.add_reagent(/datum/reagent/consumable/milk, rand(0,20))
	. = ..()

/obj/item/udder/proc/generateMilk()
	reagents.add_reagent(/datum/reagent/consumable/milk, 1)

/obj/item/udder/proc/milkAnimal(obj/O, mob/user)
	var/obj/item/reagent_containers/glass/G = O
	if(in_use)
		return
	if(G.reagents.total_volume >= G.volume)
		to_chat(user, span_warning("[O]已经满了。"))
		return
	if(!reagents.has_reagent(/datum/reagent/consumable/milk, 5))
		to_chat(user, "<span class='warning'>乳房干了。再等一等……</span>")
		return
	beingmilked()
	playsound(O, pick('modular/Creechers/sound/milking1.ogg', 'modular/Creechers/sound/milking2.ogg'), 100, TRUE, -1)
	if(do_after(user, 20, target = src))
		reagents.trans_to(O, rand(5,10))
		user.visible_message("<span class='notice'>[user]用\the [O]给[src]挤奶。</span>", "<span class='notice'>我用\the [O]给[src]挤奶。</span>")

/obj/item/udder/proc/beingmilked()
	in_use = TRUE
	sleep(20)
	in_use = FALSE

//grenchensnacker

/mob/living/simple_animal/grenchensnacker
	name = "格伦钦斯纳克"
	desc = "它为什么那样笑"
	icon_state = "grenchen"
	icon_living = "grenchen"
	icon_dead = "grenchen_dead"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("GRA","AH!","HEEHEHE")
	speak_emote = list("吱吱尖叫")
	emote_hear = list("切齿作响。")
	emote_see = list("跳舞。", "凝视着。")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/roguekey/porta = 1)
	response_help_continuous = "抚摸了"
	response_help_simple = "抚摸"
	response_disarm_continuous = "轻轻推开了"
	response_disarm_simple = "轻轻推开"
	response_harm_continuous = "踢了"
	response_harm_simple = "踢"
	attack_verb_continuous = "踢了"
	attack_verb_simple = "踢"
	attack_sound = 'sound/blank.ogg'
	health = 100
	maxHealth = 100
	gold_core_spawnable = FRIENDLY_SPAWN
	blood_volume = BLOOD_VOLUME_NORMAL
	food_type = list(/obj/item/rogueore/gold, /obj/item/rogueore/silver)
	tame_chance = 25
	bonus_tame_chance = 15
	footstep_type = FOOTSTEP_MOB_SHOE
