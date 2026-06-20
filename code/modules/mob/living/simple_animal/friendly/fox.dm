//Foxxy
/mob/living/simple_animal/pet/fox
	name = "狐狸"
	desc = ""
	icon = 'icons/mob/pets.dmi'
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	speak = list("Ack-Ack","Ack-Ack-Ack-Ackawoooo","Geckers","Awoo","Tchoff")
	speak_emote = list("嘎嘎叫", "吠叫")
	emote_hear = list("嚎叫。","吠叫。")
	emote_see = list("摇了摇头。", "颤抖着。")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3)
	response_help_continuous = "抚摸了"
	response_help_simple = "抚摸"
	response_disarm_continuous = "轻轻推开了"
	response_disarm_simple = "轻轻推开"
	response_harm_continuous = "踢了"
	response_harm_simple = "踢"
	gold_core_spawnable = FRIENDLY_SPAWN

	footstep_type = FOOTSTEP_MOB_CLAW

//Captain fox
/mob/living/simple_animal/pet/fox/Renault
	name = "雷诺"
	desc = ""
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
