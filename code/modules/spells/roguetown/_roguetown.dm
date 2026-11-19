//pseudo ranged or melee ability, invocation on mmb


/obj/effect/proc_holder/spell/invoked
	name = "invoked spell"
	range = 7
	selection_type = "range"
	no_early_release = TRUE
	recharge_time = 30
	charge_type = "recharge"
	invocation_type = "shout"
	var/active_sound

/obj/effect/proc_holder/spell/update_icon()
	if(!action)
		return
	action.button_icon_state = "[base_icon_state][active]"
	if(overlay_state)
		action.overlay_state = overlay_state
	action.name = name
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/invoked/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!can_cast(user))
		start_recharge()
		deactivate(user)
		return
	if(active)
		deactivate(user)
	else
		if(active_sound)
			user.playsound_local(user,active_sound,100,vary = FALSE)
		active = TRUE
		add_ranged_ability(user, null, TRUE)
		on_activation(user)
	update_icon()
	start_recharge()

/obj/effect/proc_holder/spell/invoked/deactivate(mob/living/user) //Deactivates the currently active spell (icon click)
	..()
	active = FALSE
	remove_ranged_ability(null)
	on_deactivation(user)

/obj/effect/proc_holder/spell/invoked/proc/on_activation(mob/user)
	return

/obj/effect/proc_holder/spell/invoked/proc/on_deactivation(mob/user)
	return

/obj/effect/proc_holder/spell/invoked/InterceptClickOn(mob/living/caller, params, atom/target)
	. = ..()
	if(.)
		return FALSE
	var/list/modifiers = params2list(params)
	if(!modifiers["middle"])
		return TRUE
	if(!can_cast(caller) || !cast_check(FALSE, ranged_ability_user))
		return FALSE
	var/client/client = caller.client
	var/percentage_progress = client?.chargedprog
	var/charge_progress = client?.progress // This is in seconds, same unit as chargetime
	var/goal = get_chargetime() //if we have no chargetime then we can freely cast (and no early release flag was not set)
	var/minimum = get_minimum_cast_time()
	if((goal || minimum) && (!client || client.charging_spell != src))
		to_chat(caller, span_warning("[name] was not finished charging! It fizzles."))
		revert_cast(caller)
		return FALSE
	if(minimum)
		// Preserve early-release spells above the floor, but never permit an instant cast.
		// Mouse progress is capped at the goal captured when this charge started.
		var/required_charge = no_early_release ? max(client?.goal, minimum) : minimum
		if(!client || charge_progress < required_charge)
			to_chat(caller, span_warning("[name] was not finished charging! It fizzles."))
			revert_cast(caller)
			return FALSE
	else if(no_early_release) //This is to stop half-channeled spells from casting as the repeated-casts somehow bypass into this function.
		if(percentage_progress < 100 && charge_progress < goal)//Conditions for failure: a) not 100% progress, b) charge progress less than goal
			to_chat(usr, span_warning("[name] was not finished charging! It fizzles."))
			revert_cast(caller)
			return FALSE
	if(perform(list(target), TRUE, user = ranged_ability_user))
		return TRUE

/obj/effect/proc_holder/spell/invoked/projectile
	var/obj/projectile/projectile_type = /obj/projectile/magic/teleport
	var/list/projectile_var_overrides = list()
	var/projectile_amount = 1	//Projectiles per cast.
	var/current_amount = 0	//How many projectiles left.
	var/projectiles_per_fire = 1		//Projectiles per fire. Probably not a good thing to use unless you override ready_projectile().
	gesture_required = TRUE // All projectiles are offensive and should be locked to not handcuff

/obj/effect/proc_holder/spell/invoked/projectile/proc/ready_projectile(obj/projectile/P, atom/target, mob/user, iteration)
	return

/obj/effect/proc_holder/spell/invoked/projectile/cast(list/targets, mob/living/user)
	. = ..()
	var/target = targets[1]
	var/turf/T = user.loc
	var/turf/U = get_step(user, user.dir) // Get the tile infront of the move, based on their direction
	if(!isturf(U) || !isturf(T))
		return FALSE
	fire_projectile(user, target)
	update_icon()
	start_recharge()
	return TRUE

/obj/effect/proc_holder/spell/invoked/projectile/proc/fire_projectile(mob/living/user, atom/target)
	current_amount--
	for(var/i in 1 to projectiles_per_fire)
		var/obj/projectile/P = new projectile_type(user.loc)
		if(istype(P, /obj/projectile/magic/bloodsteal))
			var/obj/projectile/magic/bloodsteal/B = P
			B.sender = user
		P.def_zone = user.zone_selected
		// Accuracy modification code, same as bow rebalance PR
		P.accuracy += (user.STAPER - 9) * 4
		P.bonus_accuracy += (user.STAPER - 8) * 3
		if(user.mind)
			P.bonus_accuracy += (user.get_skill_level(associated_skill) * 5) // +5% per level
		P.firer = user
		P.preparePixelProjectile(target, user)
		for(var/V in projectile_var_overrides)
			if(P.vars[V])
				P.vv_edit_var(V, projectile_var_overrides[V])
		ready_projectile(P, target, user, i)
		P.fire()
	return TRUE

/obj/effect/proc_holder/spell/invoked/projectile/get_spell_statistics(mob/living/user)
	var/list/stats = ..(user)
	// Remove the casting range line - not meaningful for projectile spells
	for(var/i in stats)
		if(findtext(i, "Range:"))
			stats -= i
			break
	// Show the projectile's actual range
	var/proj_range = initial(projectile_type.range)
	if(proj_range)
		stats.Insert(1, span_info("Projectile range: [proj_range] tiles"))
	return stats

/obj/effect/proc_holder/spell/invoked/projectile/generate_wiki_html(mob/user)
	var/html = ..(user)
	if(!ispath(projectile_type, /obj/projectile))
		return html

	var/proj_damage = initial(projectile_type:damage)
	var/proj_damage_type = initial(projectile_type:damage_type)
	var/proj_range = initial(projectile_type:range)
	var/proj_speed = initial(projectile_type:speed)
	var/proj_ap = initial(projectile_type:armor_penetration)
	var/proj_npc_mult = initial(projectile_type:npc_simple_damage_mult)
	var/proj_nodamage = initial(projectile_type:nodamage)

	var/tiles_per_second = proj_speed > 0 ? round(10 / proj_speed, 0.1) : "Instant"

	html += {"
		<hr>
		<h3 style='border-bottom: 1px solid currentColor; padding-bottom: 4px;'>Projectile</h3>
		<table>
			<tr><th>Projectile Range</th><td>[proj_range] tiles</td></tr>
			<tr><th>Speed</th><td>[tiles_per_second] tiles/sec</td></tr>
	"}

	if(!proj_nodamage)
		html += {"
			<tr><th>Damage</th><td>[proj_damage] [proj_damage_type]</td></tr>
		"}
		if(proj_npc_mult != 1)
			html += {"
				<tr><th>NPC Damage Mult</th><td>[proj_npc_mult]x</td></tr>
			"}

	if(proj_ap)
		html += {"
			<tr><th>Armor Penetration</th><td>[proj_ap]</td></tr>
		"}

	if(projectile_amount > 1)
		html += {"
			<tr><th>Projectiles per Cast</th><td>[projectile_amount]</td></tr>
		"}

	html += {"
		</table>
	"}
	return html
