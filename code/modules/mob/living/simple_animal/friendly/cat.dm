//Cat
/mob/living/simple_animal/pet/cat
	name = "猫"
	desc = "令人讨厌却又珍贵的除害伙伴。也因其对害虫的敌意而成为圣佩斯特拉仁慈一面的象征。"
	icon = 'icons/mob/pets.dmi'
	icon_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	gender = MALE
	speak = list("Meow!", "Esp!", "Purr!", "HSSSSS")
	speak_emote = list("呼噜叫", "喵喵叫")
	emote_hear = list("喵喵叫。", "咪咪叫。")
	emote_see = list("摇了摇头。", "颤抖着。")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	density = FALSE // moveblocking cat is annoying as hell
	pass_flags = PASSMOB
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 1
	animal_species = /mob/living/simple_animal/pet/cat
	childtype = list(/mob/living/simple_animal/pet/cat/kitten)
	butcher_results = list(
					/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
					/obj/item/organ/ears/cat = 1,
					/obj/item/organ/tail/cat = 1,
					)
	response_help_continuous = "抚摸了"
	response_help_simple = "抚摸"
	response_disarm_continuous = "轻轻推开了"
	response_disarm_simple = "轻轻推开"
	response_harm_continuous = "踢了"
	response_harm_simple = "踢"
	STASTR = 3
	STAWIL = 4
	STASPD = 3
	STACON = 3
	var/turns_since_scan = 0
	gold_core_spawnable = FRIENDLY_SPAWN

	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/pet/cat/Initialize(mapload)
	. = ..()
	verbs += /mob/living/proc/lay_down

/mob/living/simple_animal/pet/cat/update_mobility()
	..()
	if(client && stat != DEAD)
		if (resting)
			icon_state = "[icon_living]_rest"
		else
			icon_state = "[icon_living]"
	regenerate_icons()


/mob/living/simple_animal/pet/cat/Crossed(mob/living/L) // Gato Basado - makes it leave when people step too close
	. = ..()
	if(L)
		if(health > 1)
			icon_state = "[icon_living]"
			set_resting(FALSE)
			update_mobility()
			if(isturf(loc))
				dir = pick(GLOB.cardinals)
				step(src, dir)
			if(!stat && resting && !buckled)
				return

/mob/living/simple_animal/proc/personal_space()
	if(locate(/mob/living/carbon) in get_turf(src))
		sleep(1)
		dir = pick(GLOB.alldirs)
		step(src, dir)
		personal_space()
	else
		return

/mob/living/simple_animal/pet/cat/rogue/inn
	name = "客栈猫"
	desc = "这只又老又肥的猫让客栈免于鼠患……据说如此。它好像大多数时候都在晒太阳讨零食。"
	health = 5000
	maxHealth = 5000

/mob/living/simple_animal/pet/cat/rogue/black
	name = "黑猫"
	desc = "长着灯笼般的双眼，叫声如骨头的碰撞。黑猫对涅克拉来说是神圣的，据说会将游荡的亡灵带到运骨人那里。"
	gender = FEMALE
	icon = 'icons/roguetown/topadd/takyon/Cat.dmi'
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"

/mob/living/simple_animal/pet/cat/rogue/archibald
	name = "阿奇巴尔德"
	desc = "来自北方的罕见无牙蜘蛛——不会咬你，但会一直盯着你！"
	icon = 'icons/roguetown/mob/monster/spider.dmi'
	icon_state = "honeys"
	icon_living = "honeys"
	icon_dead = "honeys-dead"
	speak_emote = list("唧唧叫")
	emote_hear = list("唧唧叫")

/mob/living/simple_animal/pet/cat/rogue/rat
	name = "鲍里斯"
	desc = "靠着城堡一辈子积攒的粮食吃饱喝足，再杀这头野兽已经毫无意义。因为它已经赢了。"
	icon = 'icons/roguetown/mob/monster/bigrat.dmi'
	icon_state = "rat"
	icon_living = "rat"
	icon_dead = "rat1"
	speak_emote = list("吱吱叫")
	emote_hear = list("吱吱叫")

/mob/living/simple_animal/pet/cat/original
	name = "贝茜"
	desc = ""
	gender = FEMALE
	icon_state = "original"
	icon_living = "original"
	icon_dead = "original_dead"
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/kitten
	name = "小猫"
	desc = ""
	icon_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	density = FALSE
	pass_flags = PASSMOB
	mob_size = MOB_SIZE_SMALL

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/pet/cat/Runtime
	name = "Runtime"
	desc = ""
	icon_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
	var/list/family = list()//var restored from savefile, has count of each child type
	var/list/children = list()//Actual mob instances of children
	var/cats_deployed = 0
	var/memory_saved = FALSE

/mob/living/simple_animal/pet/cat/Runtime/Initialize(mapload)
	if(prob(5))
		icon_state = "original"
		icon_living = "original"
		icon_dead = "original_dead"
	Read_Memory()
	. = ..()

/mob/living/simple_animal/pet/cat/Runtime/Life()
	if(!cats_deployed && SSticker.current_state >= GAME_STATE_SETTING_UP)
		Deploy_The_Cats()
	if(!stat && SSticker.current_state == GAME_STATE_FINISHED && !memory_saved)
		Write_Memory()
		memory_saved = TRUE
	..()

/mob/living/simple_animal/pet/cat/Runtime/make_babies()
	var/mob/baby = ..()
	if(baby)
		children += baby
		return baby

/mob/living/simple_animal/pet/cat/Runtime/death()
	if(!memory_saved)
		Write_Memory(TRUE)
	..()

/mob/living/simple_animal/pet/cat/Runtime/proc/Read_Memory()
	if(fexists("data/npc_saves/Runtime.sav")) //legacy compatability to convert old format to new
		var/savefile/S = new /savefile("data/npc_saves/Runtime.sav")
		S["family"] >> family
		fdel("data/npc_saves/Runtime.sav")
	else
		var/json_file = file("data/npc_saves/Runtime.json")
		if(!fexists(json_file))
			return
		var/list/json = json_decode(file2text(json_file))
		family = json["family"]
	if(isnull(family))
		family = list()

/mob/living/simple_animal/pet/cat/Runtime/proc/Write_Memory(dead)
	var/json_file = file("data/npc_saves/Runtime.json")
	var/list/file_data = list()
	family = list()
	if(!dead)
		for(var/mob/living/simple_animal/pet/cat/kitten/C in children)
			if(istype(C,type) || C.stat || !C.z || (C.flags_1 & HOLOGRAM_1))
				continue
			if(C.type in family)
				family[C.type] += 1
			else
				family[C.type] = 1
	file_data["family"] = family
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/mob/living/simple_animal/pet/cat/Runtime/proc/Deploy_The_Cats()
	cats_deployed = 1
	for(var/cat_type in family)
		if(family[cat_type] > 0)
			for(var/i in 1 to min(family[cat_type],100)) //Limits to about 500 cats, you wouldn't think this would be needed (BUT IT IS)
				new cat_type(loc)

/mob/living/simple_animal/pet/cat/Proc
	name = "Proc"
	gender = MALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE

/mob/living/simple_animal/pet/cat/Life()
	if(!stat && !buckled && !client)
		if(prob(1))
			emote("me", 1, pick("伸出肚皮让人摸。", "摇了摇尾巴。", "躺下了。"))
			icon_state = "[icon_living]_rest"
			set_resting(TRUE)
		else if (prob(1))
			emote("me", 1, pick("坐下了。", "蹲在后腿上。", "警觉地看着。"))
			icon_state = "[icon_living]_sit"
			set_resting(TRUE)
		else if (prob(2))
			if (resting)
				emote("me", 1, pick("站起来喵喵叫。", "四处走动。", "不再休息了。"))
				icon_state = "[icon_living]"
				set_resting(FALSE)
			else
				emote("me", 1, pick("梳理着毛。", "抽动着胡须。", "抖了抖毛。"))

		else if (prob(1))
			playsound(src, pick(
							'sound/vo/mobs/cat/cat_meow1.ogg',
							'sound/vo/mobs/cat/cat_meow2.ogg',
							'sound/vo/mobs/cat/cat_meow3.ogg',
							'sound/vo/mobs/cat/cat_purr1.ogg',
							'sound/vo/mobs/cat/cat_purr2.ogg',
							'sound/vo/mobs/cat/cat_purr3.ogg',
							'sound/vo/mobs/cat/cat_purr4.ogg',
							), 100, TRUE)

	..()

	make_babies()

// Life proc inherent to roguecats only
/mob/living/simple_animal/pet/cat/rogue/Life()
	..()
	// Gato Basado - catches RT rats too when not too lazy
	if((src.loc) && isturf(src.loc))
		if(!resting && !buckled && stat != DEAD)
			for(var/obj/item/reagent_containers/food/snacks/smallrat/M in view(1,src))
				if(Adjacent(M))
					if(!M.dead)
						walk_towards(src, M, 1)
						sleep(3)
						visible_message("<span class='notice'>\The [src]杀死了老鼠！</span>")
						M.obj_destruction()
						stop_automated_movement = 0
						break





/mob/living/simple_animal/pet/cat/rogue/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if( (isdarkelf(M)) ) // l´cursed bonbonbon
		wuv(-1, M)
	else
		switch(M.used_intent.type)
			if(INTENT_HELP)
				wuv(1, M)
			if(INTENT_HARM)
				wuv(-1, M)


/mob/living/simple_animal/pet/cat/proc/wuv(change, mob/M)
	if(change)
		if(change > 0)
			if(M && stat != DEAD)
				new /obj/effect/temp_visual/heart(loc)
				emote("me", 1, "呼噜呼噜！")
				if(flags_1 & HOLOGRAM_1)
					return
		else
			if(M && stat != DEAD)
				emote("me", 1, "嘶嘶叫！")

/mob/living/simple_animal/pet/cat/inn/attack_hand(mob/living/carbon/human/M) // Gato Basado - not all pets are welcome
	. = ..()
	if((isdarkelf(M)))  // l´cursed bonbonbon
		visible_message("<span class='notice'>猫对[M]嘶嘶叫并厌恶地退开了。</span>")
		icon_state = "[icon_living]"
		set_resting(FALSE)
		update_mobility()
		playsound(get_turf(src), 'modular/Creechers/sound/cathiss.ogg', 80, TRUE, -1)
		dir = pick(GLOB.alldirs)
		step(src, dir)
		personal_space()

	if(M.mind && M.mind.has_antag_datum(/datum/antagonist/vampire))
		visible_message("<span class='notice'>猫对[M]嘶嘶叫并厌恶地退开了。</span>")
		icon_state = "[icon_living]"
		set_resting(FALSE)
		update_mobility()
		playsound(get_turf(src), 'modular/Creechers/sound/cathiss.ogg', 80, TRUE, -1)
		dir = pick(GLOB.alldirs)
		step(src, dir)
		personal_space()
