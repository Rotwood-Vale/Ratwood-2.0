/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "大地爬行者"
	summon_primer = "你是一名爬行者，小型的元素生物。像你这样的元素生物在无穷无尽的时光中漫游于自己的位面。如今你被从故乡拖入了一个新世界，这个世界显然远比你精心守护的位面更加动荡。你将如何应对这些事件，只有时间才能揭晓。"
	summon_tier = 1
	icon_state = "crawler"
	icon_living = "crawler"
	icon_dead = "vvd"
	gender = MALE
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 8
	base_intents = list(/datum/intent/simple/elemental_unarmed)
	butcher_results = list()
	faction = list("elemental")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 120
	maxHealth = 120
	melee_damage_lower = 15
	melee_damage_upper = 17
	vision_range = 8
	aggro_vision_range = 11
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 20
	candodge = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = 'sound/combat/hits/onstone/wallhit.ogg'
	attack_verb_continuous = "捶击"
	attack_verb_simple = "捶击"
	dodgetime = 0
	aggressive = 1

	STACON = 13
	STAWIL = 13
	STASTR = 8
	STASPD = 8

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler/Initialize(mapload)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler/death(gibbed)
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/magic/elemental/mote(deathspot)
	new /obj/item/magic/elemental/mote(deathspot)
	new /obj/item/magic/elemental/mote(deathspot)
	new /obj/item/magic/elemental/mote(deathspot)
	new /obj/item/magic/elemental/mote(deathspot)
	new /obj/item/magic/elemental/mote(deathspot)
	update_icon()
	QDEL_IN(src, 1)
