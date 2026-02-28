/mob/living/simple_animal/hostile/rogue/ghost/wraith
	name = "wraith"
	desc = "The vengeful spirit of a woman, ever seeking to feast upon the essence of the living." 
	icon = 'modular_helmsguard/icons/mob/wraiths.dmi'
	icon_state = "wraith"
	icon_living = "wraith"
	icon_dead = null
	mob_biotypes = MOB_UNDEAD|MOB_SPIRIT
	movement_type = FLYING
	incorporeal_move = INCORPOREAL_MOVE_JAUNT
	layer = GHOST_LAYER
	environment_smash = ENVIRONMENT_SMASH_NONE
	pass_flags = PASSTABLE|PASSGRILLE
	base_intents = list(/datum/intent/simple/claw/wraith)
/*	emote_see = list("floats hauntingly","weeps mourningly", "laments vengefully")*/
	gender = FEMALE
	speak_chance = 100
	turns_per_move = 2
	response_help_continuous = "passes through"
	response_help_simple = "pass through"
	dodging = TRUE
	dodge_prob = 60
	maxHealth = 200
	health = 200
//	layer = 16
//	plane = 16
	spacewalk = TRUE
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	speed = -5
	move_to_delay = 2 //delay for the automated movement.
	harm_intent_damage = 1
	obj_damage = 1
	melee_damage_lower = 15
	melee_damage_upper = 25
	attack_same = FALSE
	attack_sound = 'sound/combat/wooshes/bladed/wooshmed (1).ogg'
	dodge_sound = 'sound/combat/dodge.ogg'
	parry_sound = "bladedmedium"
	d_intent = INTENT_DODGE
	speak_emote = list("laments", "cries", "whimpers")
	del_on_death = TRUE
	STALUC = 20
	STACON = 10
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	loot = list(/obj/effect/particle_effect/water)
	minbodytemp = 0
	faction = list("undead")
	footstep_type = null
	defprob = 20 //ghost attack
//	defdrain = 8
	dodgetime = 10
	canparry = TRUE
	retreat_health = null
	can_buckle = TRUE
	patron = /datum/patron/inhumen/zizo		//So they can be hurt by holy fire/healing


/mob/living/simple_animal/hostile/rogue/ghost/wraith/Initialize()
	. = ..()
	icon_state = "wraith[rand(1, 3)]"

/mob/living/simple_animal/hostile/rogue/ghost/wraith/attacked_by(obj/item/I, mob/living/user)
	if(I && istype(I, /obj/item) && !I.is_silver)
		user.visible_message(span_danger("\The [I.name] passes through the [src.name]!"))
		return // Ignore attacks from weapons that are not silver
	..()

/mob/living/simple_animal/hostile/rogue/ghost/wraith/throw_impact(obj/item/I, mob/living/user)
	if(I)
		user.visible_message(span_danger("\The [I.name] passes through the [src.name]!"))
		return // Ignore thrown items
	if(I && istype(I, /obj/item/rogueweapon) && I.is_silver)
		user.visible_message(span_danger("\The [I.name] strikes the [src.name], harming it!"))
		return ..() // Resume parent procedure if hit by a rogueweapon with is_silver
	..()


/mob/living/simple_animal/hostile/rogue/ghost/wraith/Bump(obj/item/I)
	. = ..()
	if(I)
		src.visible_message(span_danger("\The [I.name] passes through the [src.name]!"))
		return // Ignore thrown items
	if(I && istype(I, /obj/item/rogueweapon) && I.is_silver)
		src.visible_message(span_danger("\The [I.name] strikes the [src.name], harming it!"))
		return ..() // Resume parent procedure if hit by a rogueweapon with is_silver
	..()

/mob/living/simple_animal/hostile/rogue/ghost/wraith/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_flag)
	// Handle interactions when hit by an object
	if(AM && istype(AM, /obj/item) && istype(AM, /obj/item/rogueweapon))
		var/obj/item/rogueweapon/thrown = AM
		if(thrown.is_silver)
			visible_message(span_danger("\The [AM.name] strikes the [src.name], harming it!"))
			return ..() // Resume parent procedure if hit by a rogueweapon with is_silver
		else
			visible_message(span_danger("\The [AM.name] passes through the [src.name]!"))
			return


/mob/living/simple_animal/hostile/rogue/ghost/wraith/bullet_act(obj/projectile/P)
	if(P)
		P.visible_message(span_danger("\The [P.name] passes through the [src.name]!"))
		return FALSE // Ignore projectiles
	..()


/mob/living/simple_animal/hostile/rogue/ghost/wraith/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	return FALSE

/mob/living/simple_animal/hostile/rogue/ghost/wraith/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "head"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "head"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "hand"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "hand"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "tail"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "tail"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "body"
		if(BODY_ZONE_PRECISE_GROIN)
			return "body"
		if(BODY_ZONE_PRECISE_R_INHAND)
			return "body"
		if(BODY_ZONE_PRECISE_L_INHAND)
			return "body"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "tail"
		if(BODY_ZONE_L_LEG)
			return "tail"
		if(BODY_ZONE_R_ARM)
			return "arm"
		if(BODY_ZONE_L_ARM)
			return "arm"
		if(BODY_ZONE_CHEST)
			return "chest"

	return ..()

/mob/living/simple_animal/hostile/rogue/ghost/wraith/death(gibbed)
	if(buckled && iscarbon(buckled)) // If the wraith is buckled to a carbon mob
		var/mob/living/carbon/C = buckled
		C.unbuckle_mob(src, TRUE)
	emote("death")
	..()

/mob/living/simple_animal/hostile/rogue/ghost/wraith/Life()
	. = ..()
	if(!target)
		if(prob(90))
			emote(pick("idle"), TRUE)

/mob/living/simple_animal/hostile/rogue/ghost/wraith/taunted(mob/user)
	emote("aggro")
	GiveTarget(user)
	return


/mob/living/simple_animal/hostile/rogue/ghost/wraith/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/wraith/wraith_scream.ogg','sound/vo/mobs/wraith/wraith_scream2.ogg','sound/vo/mobs/wraith/wraith_scream3.ogg','sound/vo/mobs/wraith/wraith_scream4.ogg','sound/vo/mobs/wraith/wraith_scream5.ogg')
		if("idle")
			return pick('sound/vo/mobs/wraith/wraith_cry.ogg','sound/vo/mobs/wraith/wraith_cry2.ogg','sound/vo/mobs/wraith/wraith_cry3.ogg','sound/vo/mobs/wraith/wraith_cry4.ogg','sound/vo/mobs/wraith/wraith_cry5.ogg')
		if("death")
			return pick('sound/vo/mobs/wraith/wraith_death.ogg', 'sound/vo/mobs/wraith/wraith_death2.ogg')

/mob/living/simple_animal/hostile/rogue/ghost/wraith/AttackingTarget()
	. = ..()
	emote("aggro")
	var/mob/living/carbon/C = target

	if(!buckled)
		if(. && prob(60) && iscarbon(C))
			C.Immobilize(50)
			C.visible_message(span_danger("\The [src] paralyzes \the [C] in fear!"), 
			span_danger("\The [src] paralyzes me!"))
			emote("aggro")
		if(prob(10) && iscarbon(C))
			emote("aggro")
			Immobilize(2 SECONDS) // Immobilize the wraith for 2 seconds
			visible_message(span_danger("\The [src] lets out an ear-piercing wail!"))
			for(var/mob/living/carbon/target in view(5, src))// Check for other carbon mobs in view
				if(target.stat == CONSCIOUS)
					shake_camera(target, 3 SECONDS, 3) // Shake the camera of the target
					target.Jitter(15 SECONDS)// Stutter the target for 3 seconds
					target.Stun(3 SECONDS) // Stun the target for 3 seconds  
					if(target.STACON < 15 && prob(50)) // If the target's STACON is less than 15, there's a chance to knockdown
						target.Knockdown(3 SECONDS) // Knockdown the target for 3 seconds
						target.Stun(5 SECONDS) // Stun the target for 5 seconds
	if(!buckled && prob(30) && iscarbon(C) && C.stat == CONSCIOUS && !C.has_buckled_mobs())
		grapples(C) // Attempt to grapple the target


/mob/living/simple_animal/hostile/rogue/ghost/wraith/attack_hand(mob/living/carbon/human/C)
	if(buckled == C) // If the wraith is buckled to a carbon mob
		var/success_chance = C.STACON
		var/success_check = rand(1,2)
		C.visible_message(span_danger("\The [C] struggles against \the [src]'s grasp!"))
		if(success_chance >= success_check)
			var/turf/throw_range = get_ranged_target_turf(C, C.dir, rand(3, 5))
			C.visible_message(span_danger("\The [C] manages to break free from \the [src]'s grasp!"))
			C.unbuckle_all_mobs()
			Immobilize(3 SECONDS)
			Stun(3 SECONDS) // Stun the wraith for a short time after being thrown
			src.throw_at(throw_range, 1, 7)
			// Immobilize the wraith for a short time after being thrown
		else
			C.visible_message(span_danger("\The [C] struggles but cannot break free from \the [src]'s grasp!"))
			return



/mob/living/simple_animal/hostile/rogue/ghost/wraith/proc/grapples(mob/living/carbon/C)
	C.buckle_mob(src, TRUE, TRUE, FALSE, 0, 0) // Buckle the wraith to the target
	C.visible_message(span_danger("\The [src] strangles \the [C]'s with its cold ghostly hands!"), \
	span_danger("\The [src] is strangling me with its cold ghostly hands!"))


/datum/intent/simple/claw/wraith
	attack_verb = list("claws", "scratches", "lacerates")
	blade_class = BCLASS_CHOP
	animname = "cut"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	chargetime = 0
	penfactor = 10
	swingdelay = 8
