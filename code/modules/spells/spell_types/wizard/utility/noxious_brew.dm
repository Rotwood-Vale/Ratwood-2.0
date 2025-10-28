//Fizzledip's Noxious Brew spell, fills a container with a gross assortment of reagents
//Intended to be used with Aerosolize to create a gross smoke cloud of harmless yet funny reagents
/obj/effect/proc_holder/spell/self/noxious_brew
	name = "Noxious Brew"
	desc = "Fills a container with a gross assortment of reagents."
	cost = 2
	xp_gain = TRUE
	releasedrain = 30
	recharge_time = 30 SECONDS
	warnie = "spellwarning"
	spell_tier = 1
	associated_skill = /datum/skill/magic/arcane
	overlay_state = null
	var/list/reagent_options = list(
		/datum/reagent/consumable/soup/stew/yucky,
		/datum/reagent/consumable/soup/stew/fish,
		/datum/reagent/consumable/soup/veggie/cabbage,
		///datum/reagent/consumable/soup/stew/berry_poisoned,
		/datum/reagent/water/gross,
		/datum/reagent/consumable/soup/poo
	)
	invocations = list("Putor Infusio")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/self/noxious_brew/cast(mob/user)
	. = ..()
	
	//get held item
	var/obj/item/held_item = user.get_active_held_item()
	var/obj/item/reagent_containers/con = held_item
	if(con)
		if(con.spillable)
			if(!con.reagents.holder_full())
				var/fillable_volume = con.reagents.maximum_volume - con.reagents.total_volume

				var/main_ingredient = reagent_options[rand(1, reagent_options.len)]
				var/secondary_ingredient = reagent_options[rand(1, reagent_options.len)]
				var/tertiary_ingredient = reagent_options[rand(1, reagent_options.len)]

				con.reagents.add_reagent(main_ingredient, fillable_volume*0.6)
				con.reagents.add_reagent(secondary_ingredient, fillable_volume*0.3)
				con.reagents.add_reagent(tertiary_ingredient, fillable_volume*0.1)
				user.visible_message(span_warning("[user] extends a hand over the [held_item] as a smelly concoction sprays from [user.p_their()] fingertips!"), span_warning("You fill the [held_item] with a noxious brew!"))
				playsound(user, 'sound/magic/webspin.ogg', 100)
			else
				to_chat(user, "<span class='warning'>The [held_item] is full!</span>")
				revert_cast()
		else
			to_chat(user, "<span class='warning'>I can't get access to the inside of this [held_item]!</span>")
			revert_cast()
	else
		to_chat(user, "<span class='warning'>I need to hold a container to cast this!</span>")
		revert_cast()
