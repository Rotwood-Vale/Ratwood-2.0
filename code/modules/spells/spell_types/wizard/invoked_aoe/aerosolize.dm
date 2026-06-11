/obj/effect/proc_holder/spell/invoked/aerosolize
	name = "雾化术" //once again renamed to fit better :)
	desc = "将一容器液体化作烟雾，其中仍含有那液体本身的试剂成分。"
	overlay_state = "aerosolize"
	releasedrain = 50
	chargetime = 3
	recharge_time = 30 SECONDS
	range = 6
	warnie = "spellwarning"
	movement_interrupt = FALSE
	no_early_release = FALSE
	chargedloop = null
	sound = 'sound/magic/whiteflame.ogg'
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocations = list("化作烟雾！")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	gesture_required = TRUE // Spell w/ offensive potential, but don't matter cuz you have no hands. Still, consistency
	cost = 3

	xp_gain = TRUE
	miracle = FALSE
	
/obj/effect/proc_holder/spell/invoked/aerosolize/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1]) //check for turf
	if(T)
		var/obj/item/held_item = user.get_active_held_item() //get held item
		var/obj/item/reagent_containers/con = held_item //get held item
		if(con)
			if(con.spillable)
				if(con.reagents.total_volume > 0)
					var/datum/reagents/R = con.reagents
					var/datum/effect_system/smoke_spread/chem/smoke = new
					smoke.set_up(R, 1, T, FALSE)
					smoke.start()

					user.visible_message(span_warning("[user] 将 [held_item] 里的东西喷洒开来，化作一团烟雾！"), span_warning("我将 [held_item] 里的东西喷洒开来，化作一团烟雾！"))
					con.reagents.clear_reagents() //empty the container
					playsound(user, 'sound/magic/webspin.ogg', 100)
				else
					to_chat(user, "<span class='warning'>[held_item] 是空的！</span>")
					revert_cast()
			else
				to_chat(user, "<span class='warning'>我没法取用 [held_item] 里的内容！</span>")
				revert_cast()
		else
			to_chat(user, "<span class='warning'>我必须手持一个容器才能施放此术！</span>")
			revert_cast()
	else
		to_chat(user, "<span class='warning'>我找不到合适的位置来施放这个法术！</span>")
		revert_cast()
