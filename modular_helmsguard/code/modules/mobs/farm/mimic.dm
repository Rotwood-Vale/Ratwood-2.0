/mob/living/simple_animal/hostile/rogue/mimic
	icon = 'modular_hearthstone/icons/mob/mimic.dmi'
	name = "拟态怪"
	icon_state = "mimic"
	icon_living = "mimic"
	icon_dead = null
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 1
	see_in_dark = 10
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/mimic)
	faction = list("undead")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 200
	maxHealth = 200
	melee_damage_lower = 35
	melee_damage_upper = 45
	vision_range = 3
	aggro_vision_range = 8
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	obj_damage = 1
	retreat_distance = 0
	minimum_distance = 0
	footstep_type = FOOTSTEP_HARD_CLAW
	STACON = 12
	STASTR = 5
	STASPD = 15
	defprob = 40
	defdrain = 10
	retreat_health = 0
	attack_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')
	loot = list(/obj/item/organ/eyes/mimic, /obj/item/organ/tongue/mimic, /obj/effect/gibspawner/human/bodypartless, /obj/structure/closet/crate/chest/reward)
	dodgetime = 0
	rot_type = null
	del_on_death = TRUE
//	stat_attack = UNCONSCIOUS

/obj/item/organ/eyes/mimic
	icon = 'modular_hearthstone/icons/mob/mimic_drop.dmi'
	icon_state = "eye"
	desc = "一只拟态怪那充血带血丝的肉眼。"

/obj/item/organ/tongue/mimic
	icon = 'modular_hearthstone/icons/mob/mimic_drop.dmi'
	icon_state = "tongue"
	desc = "一条拟态怪细长而滑腻的舌头。"

/mob/living/simple_animal/hostile/rogue/mimic/death(gibbed)
	emote("death")
	..()

/mob/living/simple_animal/hostile/rogue/mimic/taunted(mob/user)
	emote("aggro")
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/rogue/mimic/Life()
	..()
	if(pulledby)
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/rogue/mimic/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/mimic/mimic_attack.ogg','sound/vo/mobs/mimic/mimic_attack2.ogg','sound/vo/mobs/mimic/mimic_attack3.ogg')
		if("death")
			return pick('sound/vo/mobs/mimic/mimic_death.ogg')
		if("idle")
			return pick('sound/vo/mobs/mimic/mimic_idle.ogg', 'sound/vo/mobs/mimic/mimic_idle2.ogg')


/mob/living/simple_animal/hostile/rogue/mimic/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "头部"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "头部"
		if(BODY_ZONE_PRECISE_NOSE)
			return "鼻部"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "口部"
		if(BODY_ZONE_PRECISE_SKULL)
			return "头部"
		if(BODY_ZONE_PRECISE_EARS)
			return "头部"
		if(BODY_ZONE_PRECISE_NECK)
			return "颈部"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "前肢"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "前肢"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "腿部"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "腿部"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "腹部"
		if(BODY_ZONE_PRECISE_GROIN)
			return "尾部"
		if(BODY_ZONE_HEAD)
			return "头部"
		if(BODY_ZONE_R_LEG)
			return "腿部"
		if(BODY_ZONE_L_LEG)
			return "腿部"
		if(BODY_ZONE_R_ARM)
			return "前肢"
		if(BODY_ZONE_L_ARM)
			return "前肢"
	return ..()

/mob/living/simple_animal/hostile/rogue/mimic/AttackingTarget()
	. = ..()
	emote("aggro")
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(prob(50) && iscarbon(C) && Adjacent(C) && (C.mobility_flags & MOBILITY_STAND))
			src.loc = C.loc
			C.Immobilize(50)
			C.Stun(100)
			C.Knockdown(100)
			C.visible_message(span_danger("\The [src] 用它巨大而血肉模糊的利爪将 \the [C] 按倒在地！"), \
					span_danger("\The [src] 用它巨大而血肉模糊的利爪把我按倒在地！"))
			emote("aggro")



/datum/intent/simple/mimic
	name = "拟态怪"
	icon_state = "instrike"
	attack_verb = list("撕裂", "啃咬", "抓挠", "挥砍")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "genchop"
	chargetime = 20
	penfactor = 10
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_d_type = "stab"
