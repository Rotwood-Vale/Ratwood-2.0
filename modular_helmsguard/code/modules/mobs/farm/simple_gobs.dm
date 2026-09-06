// GOBLIN
/mob/living/simple_animal/hostile/retaliate/rogue/goblin
	name = "goblin"
	desc = ""
	icon = 'modular_hearthstone/icons/mob/simple_orcs.dmi'
	icon_state = "goblinarcher"
	icon_living = "goblinarcher"
	icon_dead = "goblinarcher_dead"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BEAST
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	robust_searching = 1
	ranged_cooldown = 6 SECONDS 
	speak_chance = 5
	turns_per_move = 1
	move_to_delay = 3
	STACON = 9
	STASTR = 14
	STASPD = 13
	maxHealth = 70
	health = 70
	harm_intent_damage = 15
	melee_damage_lower = 25
	melee_damage_upper = 30
	vision_range = 7
	aggro_vision_range = 9
	projectiletype = /obj/projectile/bullet/reusable/arrow/orc
	projectilesound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	check_friendly_fire = 1
	base_intents = list(/datum/intent/simple/axe)
	attack_verb_continuous = "hacks"
	attack_verb_simple = "hack"
	attack_sound = 'sound/blank.ogg'
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 50
	defdrain = 20
	obj_damage = 1
	speak_emote = list("grunts")
	loot = list(/obj/effect/mob_spawn/human/npc/goblin/normal,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow,
			/obj/item/quiver/arrows,
			/obj/effect/decal/cleanable/blood)
	faction = list("orcs")
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = TRUE
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
						/obj/item/natural/hide = 2, /obj/item/natural/bundle/bone/full = 1)
	aggressive = 1
	can_have_ai = FALSE //disable native ai
	AIStatus = AI_OFF
	ai_controller = /datum/ai_controller/orc_ranged


/mob/living/simple_animal/hostile/retaliate/rogue/goblin/cave
	icon_state = "goblinarcher2"
	icon_living = "goblinarcher2"
	icon_dead = "goblinarcher2_dead"
	loot = list(/obj/effect/mob_spawn/human/npc/goblin/goblin_cave,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow,
			/obj/item/quiver/arrows,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/retaliate/rogue/goblin/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/goblin/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/gob/aggro (1).ogg','sound/vo/mobs/gob/aggro (2).ogg','sound/vo/mobs/gob/aggro (3).ogg', 'sound/vo/mobs/gob/aggro (4).ogg')
		if("pain")
			return pick('sound/vo/mobs/gob/pain (1).ogg','sound/vo/mobs/gob/pain (2).ogg','sound/vo/mobs/gob/pain (3).ogg', 'sound/vo/mobs/gob/pain (4).ogg', 'sound/vo/mobs/gob/pain (5).ogg')
		if("death")
			return pick('sound/vo/mobs/gob/gobdeath.ogg','sound/vo/mobs/gob/gobdeath2.ogg','sound/vo/mobs/gob/gobdeath3.ogg','sound/vo/mobs/gob/gobdeath4.ogg')
		if("idle")
			return pick('sound/vo/mobs/gob/idle (1).ogg','sound/vo/mobs/gob/idle (2).ogg', 'sound/vo/mobs/gob/idle (3).ogg','sound/vo/mobs/gob/idle (4).ogg', 'sound/vo/mobs/gob/idle (5).ogg')


/mob/living/simple_animal/hostile/retaliate/rogue/goblin/Life()
	. = ..()
	if(!target)
		if(prob(3))
			emote(pick("idle"), TRUE)


/mob/living/simple_animal/hostile/retaliate/rogue/goblin/taunted(mob/user)
	emote("aggro")
	GiveTarget(user)
	return
