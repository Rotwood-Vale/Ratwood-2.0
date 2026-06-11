/datum/component/caltrop
	var/min_damage
	var/max_damage
	var/probability
	var/flags

	var/cooldown = 0

/datum/component/caltrop/Initialize(_min_damage = 0, _max_damage = 0, _probability = 100,  _flags = NONE)
	min_damage = _min_damage
	max_damage = max(_min_damage, _max_damage)
	probability = _probability
	flags = _flags

	RegisterSignal(parent, list(COMSIG_MOVABLE_CROSSED), PROC_REF(Crossed))

/datum/component/caltrop/proc/Crossed(datum/source, atom/movable/AM)
	var/atom/A = parent

	if(!prob(probability))
		return

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(HAS_TRAIT(H, TRAIT_PIERCEIMMUNE) || HAS_TRAIT(H, TRAIT_LAMIAN_TAIL) || HAS_TRAIT(H, TRAIT_NATURALARMOR))
			return

		if(HAS_TRAIT(H, TRAIT_CALTROPIMMUNE))
			return

		if((flags & CALTROP_IGNORE_WALKERS) && H.m_intent == MOVE_INTENT_WALK)
			return

		var/picked_def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		var/obj/item/bodypart/O = H.get_bodypart(picked_def_zone)
		if(!istype(O))
			return
		if(O.status == BODYPART_ROBOTIC)
			return

		var/feetCover = (H.wear_armor && (H.wear_armor.body_parts_covered & FEET)) || (H.wear_pants && (H.wear_pants.body_parts_covered & FEET))

		if(!(flags & CALTROP_BYPASS_SHOES) && (H.shoes || feetCover))
			return

		if((H.movement_type & FLYING) || H.buckled)
			return

		var/damage = rand(min_damage, max_damage)
		if(HAS_TRAIT(H, TRAIT_LIGHT_STEP))
			damage *= 0.25
		H.apply_damage(damage, BRUTE, picked_def_zone)

		if(cooldown < world.time - 10) //cooldown to avoid message spam.
			if(!H.incapacitated(ignore_restraints = TRUE))
				H.visible_message(span_danger("[H]踩到了[A]。"), \
						span_danger("我踩到了[A]！"))
			else
				H.visible_message(span_danger("[H]在[A]上滑倒了！"), \
						span_danger("我在[A]上滑倒了！"))

			cooldown = world.time
		H.Paralyze(60)
