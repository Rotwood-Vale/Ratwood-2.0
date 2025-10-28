/obj/effect/proc_holder/spell/invoked/aerosolize/greater
	name = "Greater Aerosolize"
	desc = "Turns a container of liquid into a large fog containing the reagents of that liquid."
	overlay_state = "aerosolize"
	range = 9 //so you can cast it without being in it
	spell_tier = 4 //highest tier mages only
	invocations = list("Major Converti in Nebulam!")
	cost = 6

	xp_gain = TRUE
	miracle = FALSE
	
/obj/effect/proc_holder/spell/invoked/aerosolize/greater/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1]) //check for turf
	if(T)
		var/obj/item/held_item = user.get_active_held_item() //get held item
		var/obj/item/reagent_containers/con = held_item //get held item
		if(con)
			if(con.spillable)
				if(con.reagents.total_volume > 0)
					var/datum/reagents/R = con.reagents
					var/datum/effect_system/smoke_spread/chem/smoke = new
					smoke.set_up(R, 3, T, FALSE)
					smoke.start()

					user.visible_message(span_warning("[user] sprays the contents of the [held_item], creating a massive cloud!"), span_warning("You spray the contents of the [held_item], creating a massive cloud!"))
					con.reagents.clear_reagents() //empty the container
					playsound(user, 'sound/magic/webspin.ogg', 100)
				else
					to_chat(user, "<span class='warning'>The [held_item] is empty!</span>")
					revert_cast()
			else
				to_chat(user, "<span class='warning'>I can't get access to the contents of this [held_item]!</span>")
				revert_cast()
		else
			to_chat(user, "<span class='warning'>I need to hold a container to cast this!</span>")
			revert_cast()
	else
		to_chat(user, "<span class='warning'>I couldn't find a good place for this!</span>")
		revert_cast()
