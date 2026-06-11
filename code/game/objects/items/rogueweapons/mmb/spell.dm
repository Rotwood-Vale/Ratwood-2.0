/datum/intent/spell
	name = "法术"
	tranged = 1
	chargedrain = 0
	chargetime = 0
	warnie = "aimwarn"
	warnoffset = 0

/datum/intent/spell/can_charge()
	if(mastermob?.next_move > world.time)
		if(mastermob.client.last_cooldown_warn + 10 < world.time)
			to_chat(mastermob, span_warning("我还没准备好这么做！"))
			mastermob.client.last_cooldown_warn = world.time
		return FALSE
	return TRUE

/datum/intent/spell/on_mmb(atom/target, mob/living/user, params)
	if(!user.ranged_ability?.InterceptClickOn(user, params, target)) // Returns true on success, returns FALSE on fail to cast
		user.stop_attack()
		return
	user.changeNext_move(clickcd)
	if(releasedrain)
		user.stamina_add(releasedrain)
