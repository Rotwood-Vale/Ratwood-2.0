/mob/living/simple_animal/hostile/retaliate/ghost
	name = "幽灵"
	desc = ""
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	icon_living = "ghost"
	mob_biotypes = MOB_SPIRIT
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "穿过了"
	response_help_simple = "穿过"
	a_intent = INTENT_HARM
	healable = 0
	speed = 0
	maxHealth = 40
	health = 40
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 15
	del_on_death = 1
	emote_see = list("默默哭泣", "呻吟", "喃喃自语")
	attack_verb_continuous = "抓住了"
	attack_verb_simple = "抓住"
	attack_sound = 'sound/blank.ogg'
	speak_emote = list("哭泣")
	deathmessage = "哀嚎着，瓦解为一堆灵质！"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	movement_type = FLYING
	gold_core_spawnable = NO_SPAWN //too spooky for science
	var/ghost_hairstyle
	var/ghost_hair_color
	var/mutable_appearance/ghost_hair
	var/ghost_facial_hairstyle
	var/ghost_facial_hair_color
	var/mutable_appearance/ghost_facial_hair
	var/random = TRUE //if you want random names for ghosts or not

/mob/living/simple_animal/hostile/retaliate/ghost/Initialize(mapload)
	. = ..()
	give_hair()
	set_light(1, 1, 2) // same glowing as visible player ghosts
	if(random)
		switch(rand(0,1))
			if(0)
				name = "[pick(GLOB.first_names_male)] [pick(GLOB.last_names)]的幽灵"
			if(1)
				name = "[pick(GLOB.first_names_female)] [pick(GLOB.last_names)]的幽灵"


/mob/living/simple_animal/hostile/retaliate/ghost/proc/give_hair()
	if(ghost_hairstyle != null)
		ghost_hair = mutable_appearance('icons/mob/human_face.dmi', "hair_[ghost_hairstyle]", -HAIR_LAYER)
		ghost_hair.alpha = 200
		ghost_hair.color = ghost_hair_color
		add_overlay(ghost_hair)
	if(ghost_facial_hairstyle != null)
		ghost_facial_hair = mutable_appearance('icons/mob/human_face.dmi', "facial_[ghost_facial_hairstyle]", -HAIR_LAYER)
		ghost_facial_hair.alpha = 200
		ghost_facial_hair.color = ghost_facial_hair_color
		add_overlay(ghost_facial_hair)

/mob/living/simple_animal/hostile/retaliate/gaseousform
	name = "气态雾气"
	desc = ""
	icon = 'icons/mob/mob.dmi'
	icon_state = "mist"
	icon_living = "mist"
	mob_biotypes = MOB_SPIRIT
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "穿过了"
	response_help_simple = "穿过"
	base_intents = list(/datum/intent/simple/claw)
	a_intent = INTENT_HARM
	healable = 0
	speed = 0
	maxHealth = 40
	health = 40
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 15
	del_on_death = 1
	emote_see = list("飘荡")
	attack_verb_continuous = "抓住了"
	attack_verb_simple = "抓住"
	attack_sound = 'sound/blank.ogg'
	speak_emote = list("哀嚎")
	deathmessage = "哀嚎着，瓦解为一堆灵质！"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	movement_type = FLYING
	rot_type = null
	gold_core_spawnable = NO_SPAWN //too spooky for science
	var/random = TRUE //if you want random names for ghosts or not

/mob/living/simple_animal/hostile/retaliate/gaseousform/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal/hostile/retaliate/gaseousform, revert), "VAMPIRE LORD"), 10 SECONDS)

/mob/living/simple_animal/hostile/retaliate/gaseousform/proc/revert()
	qdel()

/mob/living/simple_animal/hostile/retaliate/gaseousform/Move(NewLoc, direct)
	var/oldloc = loc

	if(NewLoc)
		var/NewLocTurf = get_turf(NewLoc)
		if(istype(NewLocTurf, /turf/closed/mineral/rogue/bedrock)) // prevent going out of bounds.
			return
		if(istype(NewLocTurf, /turf/closed/wall)) // gas can go through doors/windows but not walls
			return
		forceMove(NewLoc)
		update_parallax_contents()
	else
		forceMove(get_turf(src))  //Get out of closets and such as a ghost
		if((direct & NORTH) && y < world.maxy)
			y++
		else if((direct & SOUTH) && y > 1)
			y--
		if((direct & EAST) && x < world.maxx)
			x++
		else if((direct & WEST) && x > 1)
			x--

	Moved(oldloc, direct)
