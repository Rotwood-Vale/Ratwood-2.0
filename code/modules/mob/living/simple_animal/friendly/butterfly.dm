/mob/living/simple_animal/butterfly
	name = "蝴蝶"
	desc = ""
	icon_state = "butterfly"
	icon_living = "butterfly"
	icon_dead = "butterfly_dead"
	turns_per_move = 1
	response_help_continuous = "驱赶了"
	response_help_simple = "驱赶"
	response_disarm_continuous = "拂开了"
	response_disarm_simple = "拂开"
	response_harm_continuous = "拍扁了"
	response_harm_simple = "拍扁"
	speak_emote = list("扑扇翅膀")
	maxHealth = 2
	health = 2
	harm_intent_damage = 1
	friendly_verb_continuous = "轻碰了"
	friendly_verb_simple = "轻碰"
	density = FALSE
	movement_type = FLYING
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	ventcrawler = VENTCRAWLER_ALWAYS
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	gold_core_spawnable = FRIENDLY_SPAWN
	verb_say = "扑扇着翅膀"
	verb_ask = "好奇地扑扇着翅膀"
	verb_exclaim = "剧烈地扑扇着翅膀"
	verb_yell = "剧烈地扑扇着翅膀"

/mob/living/simple_animal/butterfly/Initialize(mapload)
	. = ..()
	var/newcolor = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)
