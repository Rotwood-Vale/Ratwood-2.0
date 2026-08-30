

// /mob/living/simple_animal/hostile/retaliate/rogue/camel/find_food()
// 	..()
// 	var/obj/structure/spacevine/SV = locate(/obj/structure/spacevine) in loc
// 	if(SV)
// 		SV.eat(src)
// 		food = max(food + 30, 100)

/mob/living/simple_animal/hostile/retaliate/rogue/camel/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		if(ssaddle)
			var/mutable_appearance/saddlet = mutable_appearance(icon, "saddle-c-above", 4.3)
			add_overlay(saddlet)
			saddlet = mutable_appearance(icon, "saddle-c")
			add_overlay(saddlet)
		if(has_buckled_mobs())
			var/mutable_appearance/mounted = mutable_appearance(icon, "camel_mounted", 4.3)
			add_overlay(mounted)

/mob/living/simple_animal/hostile/retaliate/rogue/camel/tamed()
	..()
	deaggroprob = 30
	if(can_buckle)
		var/datum/component/riding/D = LoadComponent(/datum/component/riding)
		D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 10), TEXT_SOUTH = list(0, 10), TEXT_EAST = list(-6, 10), TEXT_WEST = list(6, 10)))
		D.set_vehicle_dir_layer(SOUTH, OBJ_LAYER)
		D.set_vehicle_dir_layer(NORTH, OBJ_LAYER)
		D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
		D.set_vehicle_dir_layer(WEST, OBJ_LAYER)

/mob/living/simple_animal/hostile/retaliate/rogue/camel/death()
	unbuckle_all_mobs()
	.=..()

/mob/living/simple_animal/hostile/retaliate/rogue/camel
	icon = 'modular_deserttown/icons/camel.dmi'
	name = "camel"
	desc = ""
	icon_state = "camel"
	icon_living = "camel"
	icon_dead = "camel_dead"
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_see = list("looks around.", "chews some leaves.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	move_to_delay = 8
	animal_species = /mob/living/simple_animal/hostile/retaliate/rogue/camel

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/natural/hide = 2)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
						/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/natural/hide = 3)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 4,
						/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/natural/hide = 3,
						/obj/item/natural/fur = 2)

	base_intents = list(/datum/intent/simple/headbutt)
	health = 156
	maxHealth = 156
	food_type = list(/obj/item/reagent_containers/food/snacks/grown/wheat,/obj/item/reagent_containers/food/snacks/grown/oat,/obj/item/reagent_containers/food/snacks/grown/apple)
	tame_chance = 25
	bonus_tame_chance = 15
	footstep_type = FOOTSTEP_MOB_SHOE
	pooptype = /obj/item/natural/poo/horse
	faction = list("saiga")
	attack_verb_continuous = "headbutts"
	attack_verb_simple = "headbutt"
	melee_damage_lower = 10
	melee_damage_upper = 25
	retreat_distance = 10
	minimum_distance = 10
	STASPD = 15
	STACON = 8
	STASTR = 12
	childtype = list(/mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigakid = 70, /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigaboy = 30)
	attack_sound = list('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
	can_buckle = TRUE
	buckle_lying = 0
	can_saddle = TRUE
	aggressive = 1
	remains_type = /obj/effect/decal/remains/saiga
	
/obj/effect/decal/remains/saiga
	name = "remains"
	gender = PLURAL
	icon_state = "skele"
	icon = 'icons/roguetown/mob/monster/saiga.dmi'

/mob/living/simple_animal/hostile/retaliate/rogue/saiga/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/saiga/pain (1).ogg','sound/vo/mobs/saiga/pain (2).ogg','sound/vo/mobs/saiga/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/saiga/death (1).ogg','sound/vo/mobs/saiga/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/saiga/idle (1).ogg','sound/vo/mobs/saiga/idle (2).ogg','sound/vo/mobs/saiga/idle (3).ogg','sound/vo/mobs/saiga/idle (4).ogg','sound/vo/mobs/saiga/idle (5).ogg','sound/vo/mobs/saiga/idle (6).ogg','sound/vo/mobs/saiga/idle (7).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/camel/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/camel/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()
