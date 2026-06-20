/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "地狱小鬼"
	icon_state = "imp"
	icon_living = "imp"
	icon_dead = "vvd"
	summon_primer = "你是一只小鬼，一种在地狱位面中以自娱自乐和吃肉的时光中消磨的小型生物。如今你被从故乡拖入了一个新世界，而这个世界显然极度缺乏火焰。你将如何应对这些事件，只有时间才能揭晓。"
	summon_tier = 1
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/unarmed/claw)
	butcher_results = list()
	faction = list("infernal")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 70
	maxHealth = 70
	melee_damage_lower = 15
	melee_damage_upper = 17
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	ranged = TRUE
	ranged_cooldown = 40
	projectiletype = /obj/projectile/magic/firebolt
	retreat_distance = 4
	minimum_distance = 3
	food_type = list()
	movement_type = FLYING
	pooptype = null
	STACON = 7
	STASTR = 6
	STASPD = 12
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	candodge = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = 'sound/combat/hits/bladed/smallslash (1).ogg'
	attack_verb_continuous = "抓了"
	attack_verb_simple = "抓"
	dodgetime = 30
	aggressive = 1

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)

/obj/projectile/magic/firebolt
	name = "火球"
	icon_state = "fireball"
	damage = 20
	damage_type = BURN
	nodamage = FALSE
	armor_penetration = 0
	flag = "magic"
	hitsound = 'sound/blank.ogg'

/obj/projectile/magic/firebolt/on_hit(target)
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			M.visible_message(span_warning("[src]接触到[target]后消散了！"))
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp/death(gibbed)
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	update_icon()
	spill_embedded_objects()
	qdel(src)


/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)
