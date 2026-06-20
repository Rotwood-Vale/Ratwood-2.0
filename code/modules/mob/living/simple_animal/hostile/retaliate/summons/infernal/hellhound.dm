
/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "地狱犬"
	icon_state = "hellhound"
	icon_living = "hellhound"
	icon_dead = "vvd"
	summon_primer = "你是一头地狱犬，中等体型、由高温与烈焰构成的犬类生物。你在地狱位面中以肆意狩猎、焚烧万物为乐。如今你被从故乡拖入了一个新世界，而这个世界显然极度缺乏火焰。你将如何应对这些事件，只有时间才能揭晓。"
	summon_tier = 2
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list()
	faction = list("infernal")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 270
	maxHealth = 270
	melee_damage_lower = 15
	melee_damage_upper = 17
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 7
	STASTR = 9
	STASPD = 13
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	candodge = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	dodgetime = 30
	aggressive = 1
	var/flame_cd

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound/death(gibbed)
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/magic/infernal/fang(deathspot)
	new /obj/item/magic/infernal/fang(deathspot)
	new /obj/item/magic/infernal/fang(deathspot)
	new /obj/item/magic/infernal/fang(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	new /obj/item/magic/infernal/ash(deathspot)
	update_icon()
	spill_embedded_objects()
	qdel(src)


/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound/AttackingTarget()
	if(SEND_SIGNAL(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, target) & COMPONENT_HOSTILE_NO_PREATTACK)
		return FALSE //but more importantly return before attack_animal called
	SEND_SIGNAL(src, COMSIG_HOSTILE_ATTACKINGTARGET, target)
	in_melee = TRUE
	if(!target)
		return
	if(world.time >= src.flame_cd + 10 SECONDS)
		var/mob/living/targetted = target
		if(!isliving(target))
			return
		targetted.adjust_fire_stacks(5)
		targetted.ignite_mob()
		targetted.visible_message(span_danger("[src]把[target]点燃了！"))
		src.flame_cd = world.time
	if(!QDELETED(target))
		return target.attack_animal(src)
