/mob/living/simple_animal/hostile/retaliate/frog
	name = "青蛙"
	desc = ""
	icon_state = "frog"
	icon_living = "frog"
	icon_dead = "frog_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("呱呱","呱呱")
	emote_see = list("转圈跳。", "抖动。")
	speak_chance = 1
	turns_per_move = 5
	maxHealth = 15
	health = 15
	melee_damage_lower = 5
	melee_damage_upper = 5
	attack_verb_continuous = "咬了"
	attack_verb_simple = "咬"
	response_help_continuous = "抚摸了"
	response_help_simple = "抚摸"
	response_disarm_continuous = "捅了"
	response_disarm_simple = "捅"
	response_harm_continuous = "拍扁了"
	response_harm_simple = "拍扁"
	density = FALSE
	ventcrawler = VENTCRAWLER_ALWAYS
	faction = list("hostile")
	attack_sound = 'sound/blank.ogg'
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	gold_core_spawnable = HOSTILE_SPAWN
	var/stepped_sound = 'sound/blank.ogg'

/mob/living/simple_animal/hostile/retaliate/frog/Initialize(mapload)
	. = ..()
	if(prob(1))
		name = "稀有青蛙"
		desc = ""
		icon_state = "rare_frog"
		icon_living = "rare_frog"
		icon_dead = "rare_frog_dead"

/mob/living/simple_animal/hostile/retaliate/frog/Crossed(AM as mob|obj)
	if(!stat && isliving(AM))
		var/mob/living/L = AM
		if(L.mob_size > MOB_SIZE_TINY)
			playsound(src, stepped_sound, 50, TRUE)
