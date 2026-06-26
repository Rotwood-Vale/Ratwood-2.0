/mob/living/simple_animal/hostile/retaliate
	var/list/enemies = list()
	stop_automated_movement_when_pulled = TRUE
	use_lazy_target_scan = FALSE

/mob/living/simple_animal/hostile/retaliate/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(M.used_intent.type == INTENT_HELP)
		if(enemies.len)
			if(tame)
				enemies = list()
				src.visible_message(span_notice("[src] calms down."))
				LoseTarget()

/mob/living/simple_animal/hostile/retaliate
	var/aggressive = 0

/mob/living/simple_animal/hostile/retaliate/ListTargets()
	if(!(AIStatus == NPC_AI_OFF))
		if(aggressive)
			return ..()
		else
			if(!enemies.len)
				return list()
			var/list/see = ..()
			see &= enemies // Remove all entries that aren't in enemies
			return see

/mob/living/simple_animal/hostile/retaliate/proc/DismemberBody(mob/living/L)
	//Lets keep track of this to see if we start getting wounded while eating.
	testing("[src]_eating_[L]")
	//I dont know why but the do_after for health needs this to be defined like this.
	var/list/check_health = list("health" = src.health)

	if(L.stat != CONSCIOUS)
		src.visible_message(span_danger("[src] starts to rip apart [L]!"))
		if(attack_sound)
			playsound(src, pick(attack_sound), 100, TRUE, -1)
		//If their health is decreased at all during the 10 seconds the dismemberment will fail and they will lose target.
		if(do_after(user = src, delay = 10 SECONDS, target = L, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob, break_do_after_checks), check_health, FALSE)))
			//If its carbon remove a limb, if its some animal just gib it.
			if(iscarbon(L))
				var/mob/living/carbon/C = L
				var/obj/item/bodypart/limb
				var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
				for(var/zone in limb_list)
					limb = C.get_bodypart(zone)
					if(limb)
						limb.dismember()
						return TRUE
				limb = C.get_bodypart(BODY_ZONE_HEAD)
				if(limb)
					limb.dismember()
					return TRUE
				limb = C.get_bodypart(BODY_ZONE_CHEST)
				if(limb)
					if(!limb.dismember())
						C.gib()
					return TRUE
			else
				L.gib()
				return TRUE
		LoseTarget()

/mob/living/simple_animal/hostile/retaliate/proc/Retaliate()
	toggle_ai(AI_ON)

	// saving hearers to an intermediary list disables certain byond optimizations
	// so we just use it directly in the for loop
	for(var/mob/living/bystander in hearers(vision_range, src))
		if(bystander == src)
			continue
		if(attack_same || !faction_check_mob(bystander))
			enemies |= bystander

	if(attack_same)
		return 0 // we aren't buddies with our faction so we don't warn them about enemies
	for(var/mob/living/simple_animal/hostile/retaliate/ally in hearers(vision_range, src))
		if(ally.attack_same)
			continue
		if(faction_check_mob(ally))
			ally.enemies |= enemies
	return 0

/mob/living/simple_animal/hostile/retaliate/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0 && stat == CONSCIOUS)
		Retaliate()
