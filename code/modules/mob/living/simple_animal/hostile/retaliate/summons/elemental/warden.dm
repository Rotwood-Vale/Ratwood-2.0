
/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "大地守望者"
	icon_state = "warden"
	icon_living = "warden"
	icon_dead = "vvd"
	summon_primer = "你是一名守望者，中型的元素生物。像你这样的元素生物不遗余力地守卫着自己的位面免受入侵。如今你被从故乡拖入了一个新世界，这个世界显然远比你精心守护的位面更加动荡。你将如何应对这些事件，只有时间才能揭晓。"
	summon_tier = 2
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 12
	base_intents = list(/datum/intent/simple/elemental_unarmed)
	butcher_results = list()
	faction = list("elemental")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 340
	maxHealth = 340
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
	simple_detect_bonus = 20
	deaggroprob = 0
	canparry = TRUE
	defprob = 30
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	rapid = TRUE
	attack_sound = 'sound/combat/hits/onstone/wallhit.ogg'
	dodgetime = 30
	aggressive = 1

	STACON = 15
	STAWIL = 15
	STASTR = 10
	STASPD = 6

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden/Initialize(mapload)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden/death(gibbed)
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/magic/elemental/shard(deathspot)
	new /obj/item/magic/elemental/shard(deathspot)
	new /obj/item/magic/elemental/shard(deathspot)
	new /obj/item/magic/elemental/shard(deathspot)
	new /obj/item/magic/elemental/mote(deathspot)
	new /obj/item/magic/elemental/mote(deathspot)
	new /obj/item/magic/elemental/mote(deathspot)
	new /obj/item/magic/elemental/mote(deathspot)
	update_icon()
	spill_embedded_objects()
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden/AttackingTarget(atom/movable/target)
	if(SEND_SIGNAL(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, target) & COMPONENT_HOSTILE_NO_PREATTACK)
		return FALSE //but more importantly return before attack_animal called
	SEND_SIGNAL(src, COMSIG_HOSTILE_ATTACKINGTARGET, target)
	in_melee = TRUE
	if(!target)
		return
	if(isstructure(target))
		var/obj/structure/S = target
		if(S.anchored)
			return target.attack_animal(src)
	yeet(target)
	if(!QDELETED(target))
		return target.attack_animal(src)

/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden/proc/yeet(atom/movable/target)
	var/atom/throw_target = get_edge_target_turf(src, get_dir(src, target)) //ill be real I got no idea why this worked.
	target.throw_at(throw_target, 7, 4)
	if(isliving(target))
		var/mob/living/L = target
		L.adjustBruteLoss(20)
