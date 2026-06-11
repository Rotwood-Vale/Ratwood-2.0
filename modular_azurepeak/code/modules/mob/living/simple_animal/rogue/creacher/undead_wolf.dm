//I'm not calling this undead_volf I want code to be searchable kthx

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead
//I'm not inhereting base wolf either because it uses cursed elements and AI.
	icon = 'modular_hearthstone/icons/mob/wolf_undead.dmi'
	name = "死灵狼"
	desc = "一头被拖入不死之途的狼，正不屈地龇牙低吼，渴求着新鲜血肉。"
	icon_state = "wolf"
	icon_living = "wolf"
	icon_dead = "wolf_dead"
	var/icon_downed = "wolf_downed"
	gender = NEUTER
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite/volf)
	botched_butcher_results = list(/obj/item/alch/viscera = 1, /obj/item/alch/sinew = 1, /obj/item/natural/bone = 2)
	butcher_results = list(/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 1,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/bone = 3)
	perfect_butcher_results = list(/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/fur/wolf = 1,
						/obj/item/natural/bone = 4)

	faction = list("zombie")
	mob_biotypes = MOB_UNDEAD
	melee_damage_lower = 24
	melee_damage_upper = 34
	health = WOLF_HEALTH_UNDEAD
	maxHealth = WOLF_HEALTH_UNDEAD
	dodgetime = 40
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 7
	STASTR = 7
	STASPD = 12
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = 44 SECONDS
	aggressive = 1
	remains_type = /obj/effect/decal/remains/wolf

	var/leg_health = 100
	var/max_leg_health = 100
	var/head_health = 75
	var/max_head_health = 75
	var/reinimation_timer = 15 MINUTES
	var/is_downed = FALSE
	var/legs_broken = FALSE

	retreat_health = 0
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')

	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/undead/wolf

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/Initialize(mapload)
	. = ..()
	REMOVE_TRAIT(src, TRAIT_SIMPLE_WOUNDS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_RIGIDMOVEMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	src.AddComponent(/datum/component/infection_spreader)

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/death()
	if(is_downed)
		visible_message(span_danger("[src]的脑袋被砸成了肉泥！"))
		. = ..()
		update_icon()
		ai_controller.set_ai_status(AI_STATUS_OFF)
	else
		visible_message(span_notice("[src]轰然倒地，身躯被打得惨不忍睹，可它的脑袋依旧维持着那无止尽的凝视。"))
		is_downed = TRUE
		ai_controller.movement_delay = 100
		icon_state = icon_downed
		icon_living = icon_downed
		adjustBruteLoss(-250)
		stat = CONSCIOUS
		update_icon()
		// If you don't kill it, it will become a threat again.
		addtimer(CALLBACK(src, .proc/reanimation), reinimation_timer)
		return

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/proc/reanimation()
	if(!QDELETED(src) && stat != DEAD)
		visible_message(span_danger("[src]又站了起来。"))
		health = maxHealth
		leg_health = max_leg_health
		head_health = max_head_health
		legs_broken = FALSE
		icon_state = "wolf"
		icon_living = "wolf"
		ai_controller.movement_delay = initial(ai_controller.movement_delay)
		is_downed = FALSE
		stat = CONSCIOUS
		update_icon()

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/apply_damage(damage, damagetype, def_zone, blocked, forced)
	. = ..()
	if(is_downed)
		if(def_zone == "head" || \
		   def_zone == "nose" || \
		   def_zone == "mouth" || \
		   def_zone == "neck")

			head_health -= damage
			if(head_health <= 0 && stat != DEAD)
				head_health = 0
				death()

	if(def_zone == "foreleg" || def_zone == "leg")
		leg_health -= damage
		if(leg_health <= 0 && !legs_broken)
			leg_health = 0
			legs_broken = TRUE
			ai_controller.movement_delay += 10
			visible_message(span_notice("[src]慢了下来，断裂的腿在地上拖行。"))

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/vw/pain (1).ogg','sound/vo/mobs/vw/pain (2).ogg','sound/vo/mobs/vw/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/vw/death (1).ogg','sound/vo/mobs/vw/death (2).ogg','sound/vo/mobs/vw/death (3).ogg','sound/vo/mobs/vw/death (4).ogg','sound/vo/mobs/vw/death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/idle (3).ogg','sound/vo/mobs/vw/idle (4).ogg')
		if("cidle")
			return pick('sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/bark (3).ogg','sound/vo/mobs/vw/bark (4).ogg','sound/vo/mobs/vw/bark (5).ogg','sound/vo/mobs/vw/bark (6).ogg','sound/vo/mobs/vw/bark (7).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead/simple_limb_hit(zone)
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
			return "嘴部"
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
			return "后肢"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "后肢"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "腹部"
		if(BODY_ZONE_PRECISE_GROIN)
			return "尾部"
		if(BODY_ZONE_HEAD)
			return "头部"
		if(BODY_ZONE_R_LEG)
			return "后肢"
		if(BODY_ZONE_L_LEG)
			return "后肢"
		if(BODY_ZONE_R_ARM)
			return "前肢"
		if(BODY_ZONE_L_ARM)
			return "前肢"
	return ..()
