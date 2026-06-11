/mob/living/simple_animal/hostile/retaliate/rogue/orc
	name = "野蛮兽人"
	desc = "一头看起来凶狠而粗野的生物。"
	icon = 'modular_hearthstone/icons/mob/simple_orcs.dmi'
	icon_state = "savageorc"
	icon_living = "savageorc"
	icon_dead = "savageorc_dead"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BEAST
	robust_searching = 1
	speak_chance = 5
	turns_per_move = 2
	move_to_delay = 3
	STACON = 9
	STASTR = 14
	STASPD = 13
	maxHealth = ORC_HEALTH
	health = ORC_HEALTH
	harm_intent_damage = 15
	melee_damage_lower = 25
	melee_damage_upper = 30
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	limb_destroyer = 1
	base_intents = list(/datum/intent/simple/axe/orc)
	attack_verb_continuous = "劈砍"
	attack_verb_simple = "劈砍"
	attack_sound = 'sound/blank.ogg'
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 50
	speak_emote = list("咆哮")
	speak = list("WAAAGH！", "碾碎他们，杀光他们！", "你们根本不该来这里！", "把他们全宰了！", "杀光一切！", "哈哈哈！去死吧！")
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/savageorc,
			/obj/item/rogueweapon/stoneaxe/boneaxe,
			/obj/effect/decal/cleanable/blood)
	faction = list("orcs")
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = TRUE
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
						/obj/item/natural/hide = 2, /obj/item/natural/bundle/bone/full = 1)
	aggressive = TRUE

//new ai, old ai off
	can_have_ai = FALSE //disable native ai
	AIStatus = AI_OFF
	ai_controller = /datum/ai_controller/orc

/mob/living/simple_animal/hostile/retaliate/rogue/orc/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ai_retaliate)

/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc2
	icon_state = "savageorc2"
	icon_living = "savageorc2"
	icon_dead = "savageorc2"
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/savageorc2,
			/obj/item/rogueweapon/stoneaxe/boneaxe,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder
	name = "兽人掠夺者"
	icon_state = "orcmarauder"
	icon_living = "orcmarauder"
	icon_dead = "orcmarauder"
	base_intents = list(/datum/intent/sword/cut)
	ai_controller = /datum/ai_controller/elite_orc
	melee_damage_lower = 30
	melee_damage_upper = 35
	armor_penetration = 35
	maxHealth = ORC_HEALTH * 2 //TWICE THE ORC
	health = ORC_HEALTH * 2
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/orcmarauder,
			/obj/item/rogueweapon/sword/short/messer/iron,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder/spear
	icon_state = "orcmarauder_spear"
	icon_living = "orcmarauder_spear"
	icon_dead = "orcmarauder_spear"
	base_intents = list(/datum/intent/spear/thrust/orcthrust)
	ai_controller = /datum/ai_controller/spear_orc
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/orcmarauder,
			/obj/item/rogueweapon/spear,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder/ravager
	icon_state = "orcravager"
	icon_living = "orcravager"
	icon_dead = "orcravager"
	ai_controller = /datum/ai_controller/elite_orc
	melee_damage_lower = 40
	melee_damage_upper = 50
	armor_penetration = 40
	maxHealth = ORC_HEALTH * 5
	health = ORC_HEALTH * 5
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/orcravager,
			/obj/item/rogueweapon/halberd/bardiche,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/retaliate/rogue/orc/spear
	icon_state = "savageorc_spear"
	icon_living = "savageorc_spear"
	icon_dead = "savageorc_spear"
	ai_controller = /datum/ai_controller/spear_orc
	base_intents = list(/datum/intent/spear/thrust/orcthrust)
	melee_damage_lower = 30
	melee_damage_upper = 30
	armor_penetration = 35
	attack_verb_continuous = list("stabs", "slashes", "skewers")
	attack_verb_simple = "刺击"
	attack_verb_continuous = list("刺击", "劈砍", "穿刺")
	attack_sound = 'sound/blank.ogg'
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/savageorc,
			/obj/item/rogueweapon/spear/bonespear,
			/obj/effect/decal/cleanable/blood)


	footstep_type = FOOTSTEP_MOB_BAREFOOT

/mob/living/simple_animal/hostile/retaliate/rogue/orc/spear2
	icon_state = "savageorc_spear2"
	icon_living = "savageorc_spear2"
	icon_dead = "savageorc_spear2"
	ai_controller = /datum/ai_controller/spear_orc
	base_intents = list(/datum/intent/spear/thrust/orcthrust)
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/savageorc2,
			/obj/item/rogueweapon/spear/bonespear,
			/obj/effect/decal/cleanable/blood)

/datum/intent/simple/axe/orc
	clickcd = ORC_ATTACK_SPEED

/datum/intent/spear/thrust/orcthrust
	clickcd = ORC_ATTACK_SPEED * 1.2
	//slower swing timer because it has 2 reach

/mob/living/simple_animal/hostile/retaliate/rogue/orc/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/simple_orcs/orc_yell.ogg','sound/vo/mobs/simple_orcs/orc_yell2.ogg','sound/vo/mobs/simple_orcs/orc_yell3.ogg', 'sound/vo/mobs/simple_orcs/orc_yell4.ogg')
		if("pain")
			return pick('sound/vo/mobs/simple_orcs/orc_pain.ogg','sound/vo/mobs/simple_orcs/orc_pain2.ogg','sound/vo/mobs/simple_orcs/orc_pain3.ogg', 'sound/vo/mobs/simple_orcs/orc_pain4.ogg')
		if("death")
			return pick('sound/vo/mobs/simple_orcs/orc_death.ogg','sound/vo/mobs/simple_orcs/orc_death2.ogg','sound/vo/mobs/simple_orcs/orc_death3.ogg','sound/vo/mobs/simple_orcs/orc_death4.ogg','sound/vo/mobs/simple_orcs/orc_death5.ogg',
			'sound/vo/mobs/simple_orcs/orc_death6.ogg')
		if("idle")
			return pick('sound/vo/mobs/simple_orcs/orc_idle.ogg','sound/vo/mobs/simple_orcs/orc_idle2.ogg','sound/vo/mobs/simple_orcs/orc_idle3.ogg','sound/vo/mobs/simple_orcs/orc_idle4.ogg')


/mob/living/simple_animal/hostile/retaliate/rogue/orc/Life()
	. = ..()
	if(!target)
		if(prob(3))
			emote(pick("idle"), TRUE)


/mob/living/simple_animal/hostile/retaliate/rogue/orc/taunted(mob/user)
	emote("aggro")
	GiveTarget(user)
	return


/mob/living/simple_animal/hostile/retaliate/rogue/orc/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "右眼"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "左眼"
		if(BODY_ZONE_PRECISE_NOSE)
			return "鼻子"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "嘴巴"
		if(BODY_ZONE_PRECISE_SKULL)
			return "头骨"
		if(BODY_ZONE_PRECISE_EARS)
			return "耳朵"
		if(BODY_ZONE_PRECISE_NECK)
			return "脖子"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "左手"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "右手"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "左脚"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "右脚"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "腹部"
		if(BODY_ZONE_PRECISE_GROIN)
			return "裆部"
		if(BODY_ZONE_HEAD)
			return "头部"
		if(BODY_ZONE_R_LEG)
			return "右腿"
		if(BODY_ZONE_L_LEG)
			return "左腿"
		if(BODY_ZONE_R_ARM)
			return "右臂"
		if(BODY_ZONE_L_ARM)
			return "左臂"
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/orc/ranged
	name = "野蛮兽人弓手"
	desc = "一头看起来凶狠而粗野的生物。这头带着弓。"
	icon_state = "orcbow"
	icon_living = "orcbow"
	icon_dead = "orcbow"
	projectiletype = /obj/projectile/bullet/reusable/arrow/orc
	projectilesound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	casingtype = /obj/item/ammo_casing/caseless/rogue/arrow
	ranged = TRUE
	retreat_distance = 2
	minimum_distance = 5
	ranged_cooldown_time = 60
	check_friendly_fire = 1
	loot = list(
			/obj/effect/mob_spawn/human/orc/corpse/savageorc2,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow,
			/obj/item/ammo_casing/caseless/rogue/arrow/stone,
			/obj/item/ammo_casing/caseless/rogue/arrow/stone,
			/obj/item/ammo_casing/caseless/rogue/arrow/stone,
			/obj/effect/decal/cleanable/blood,
			)
	maxHealth = ORC_HEALTH * 0.5
	health = ORC_HEALTH * 0.5

	can_have_ai = FALSE //disable native ai
	AIStatus = AI_OFF
	ai_controller = /datum/ai_controller/orc_ranged

/mob/living/simple_animal/hostile/retaliate/rogue/orc/ranged/Initialize(mapload)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/orc/death(gibbed)
	..()
	update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/orc/event
	ai_controller = /datum/ai_controller/orc/event
/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc2/event
	ai_controller = /datum/ai_controller/orc/event
/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder/event
	ai_controller = /datum/ai_controller/orc/event
/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder/spear/event
	ai_controller = /datum/ai_controller/elite_orc/event
/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder/ravager/event
	ai_controller = /datum/ai_controller/elite_orc/event
/mob/living/simple_animal/hostile/retaliate/rogue/orc/spear/event
	ai_controller = /datum/ai_controller/orc/event
/mob/living/simple_animal/hostile/retaliate/rogue/orc/spear2/event
	ai_controller = /datum/ai_controller/orc/event
	
/mob/living/simple_animal/hostile/retaliate/rogue/orc/ranged/event
	ai_controller = /datum/ai_controller/orc_ranged/event
