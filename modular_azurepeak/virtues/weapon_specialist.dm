/datum/virtue/combat/weapon_specialist
	name = "Weapon Specialist"
	desc = "I trained with several weapons of my choice, mastering their use and keeping them close at hand."
	custom_text = "Select weapons to specialize in (up to 3 points). You will receive each weapon stashed and a matching skill bonus."
	category = "feats"
	virtue_cost = 2
	var/max_points = 3
	var/list/weapon_options = list(
		// CLASSIC COMBINATIONS FROM DELETED VIRTUES
		"Duelist's Set" = list(
			"items" = list(/obj/item/rogueweapon/sword/short/messer/iron/virtue, /obj/item/rogueweapon/huntingknife/idagger/virtue),
			"skills" = list(/datum/skill/combat/swords, /datum/skill/combat/knives),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 3
		),
		"Dungeoneer's Set" = list(
			"items" = list(/obj/item/rogueweapon/stoneaxe/woodcut, /obj/item/rogueweapon/whip),
			"skills" = list(/datum/skill/combat/axes, /datum/skill/combat/whipsflails),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 3
		),
		"Militiaman's Set" = list(
			"items" = list(/obj/item/rogueweapon/spear, /obj/item/rogueweapon/mace),
			"skills" = list(/datum/skill/combat/polearms, /datum/skill/combat/maces),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 3
		),
		"Shepherd's Tools" = list(
			"items" = list(/obj/item/rogueweapon/woodstaff/quarterstaff/iron, /obj/item/gun/ballistic/revolver/grenadelauncher/sling, /obj/item/quiver/sling/iron),
			"skills" = list(/datum/skill/combat/staves, /datum/skill/combat/slings),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 3
		),
		"Archer's Set" = list(
			"items" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve, /obj/item/quiver/arrows),
			"skills" = list(/datum/skill/combat/bows),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 3
		),
		"Pugilist, Bronze Knuckles (Pair)" = list(
			"items" = list(/obj/item/rogueweapon/knuckles/bronzeknuckles, /obj/item/rogueweapon/knuckles/bronzeknuckles),
			"skills" = list(/datum/skill/combat/unarmed, /datum/skill/combat/wrestling),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 3
		),

		"Pugilist, Bronze Katar (Pair)" = list(
			"items" = list(/obj/item/rogueweapon/katar/bronze, /obj/item/rogueweapon/katar/bronze),
			"skills" = list(/datum/skill/combat/unarmed, /datum/skill/combat/wrestling),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 3
		),

		"Iron Arming Sword" = list(
			"items" = list(/obj/item/rogueweapon/sword/iron),
			"skills" = list(/datum/skill/combat/swords),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 2
		),
		"Bronze Arming Sword" = list(
			"items" = list(/obj/item/rogueweapon/sword/bronze),
			"skills" = list(/datum/skill/combat/swords),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 2
		),
		"Iron Messer" = list(
			"items" = list(/obj/item/rogueweapon/sword/short/messer/iron/virtue),
			"skills" = list(/datum/skill/combat/swords),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 1
		),
		"Iron Short Sword" = list(
			"items" = list(/obj/item/rogueweapon/sword/short/iron),
			"skills" = list(/datum/skill/combat/swords),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 1
		),
		"Iron Saber" = list(
			"items" = list(/obj/item/rogueweapon/sword/saber/iron),
			"skills" = list(/datum/skill/combat/swords),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 2
		),
		
		"Bronze Hunting Knife" = list(
			"items" = list(/obj/item/rogueweapon/huntingknife/bronze),
			"skills" = list(/datum/skill/combat/knives),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 1
		),
		"Iron Parrying Dagger" = list(
			"items" = list(/obj/item/rogueweapon/huntingknife/idagger/virtue),
			"skills" = list(/datum/skill/combat/knives),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 1
		),
		
		"Bronze Axe" = list(
			"items" = list(/obj/item/rogueweapon/stoneaxe/woodcut/bronze),
			"skills" = list(/datum/skill/combat/axes),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 2
		),
		"Iron Axe" = list(
			"items" = list(/obj/item/rogueweapon/stoneaxe/woodcut),
			"skills" = list(/datum/skill/combat/axes),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 2
		),
		"Iron Greataxe" = list(
			"items" = list(/obj/item/rogueweapon/greataxe),
			"skills" = list(/datum/skill/combat/axes),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 3
		),
		
		"Bronze Mace" = list(
			"items" = list(/obj/item/rogueweapon/mace/bronze),
			"skills" = list(/datum/skill/combat/maces),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 2
		),
		"Iron Mace" = list(
			"items" = list(/obj/item/rogueweapon/mace),
			"skills" = list(/datum/skill/combat/maces),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 2
		),
		"Iron Flail" = list(
			"items" = list(/obj/item/rogueweapon/flail),
			"skills" = list(/datum/skill/combat/maces),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 2
		),
		"Iron Warhammer" = list(
			"items" = list(/obj/item/rogueweapon/mace/warhammer),
			"skills" = list(/datum/skill/combat/maces),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 2
		),
		"Bronze Spear" = list(
			"items" = list(/obj/item/rogueweapon/spear/bronze),
			"skills" = list(/datum/skill/combat/polearms),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 2
		),
		"Wooden Spear" = list(
			"items" = list(/obj/item/rogueweapon/spear),
			"skills" = list(/datum/skill/combat/polearms),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 1
		),
		
		"Leather Whip" = list(
			"items" = list(/obj/item/rogueweapon/whip),
			"skills" = list(/datum/skill/combat/whipsflails),
			"min_level" = SKILL_LEVEL_JOURNEYMAN,
			"max_level" = SKILL_LEVEL_JOURNEYMAN,
			"cost" = 1
		),
	)

/datum/virtue/combat/weapon_specialist/apply_to_human(mob/living/carbon/human/recipient)
	var/remaining_points = max_points
	var/list/choices = list()
	for(var/weapon_name in weapon_options)
		var/list/option = weapon_options[weapon_name]
		var/cost = option["cost"]
		// Add cost to the display name
		choices["[weapon_name] ([cost]pt)"] = weapon_name
	
	var/list/selected = list()
	while(remaining_points > 0 && length(choices))
		var/prompt = "Select a weapon - You have [remaining_points] point\s remaining ([max_points - remaining_points]/[max_points] spent):"
		var/chosen_display = input(recipient, prompt, "Weapon Specialization") as null|anything in choices
		if(!chosen_display)
			break
		
		var/chosen = choices[chosen_display]
		var/list/option = weapon_options[chosen]
		var/cost = option["cost"]
		if(cost > remaining_points)
			to_chat(recipient, span_warning("Not enough points for [chosen] ([cost]pt). You have [remaining_points]pt remaining."))
			continue
		
		selected += chosen
		remaining_points -= cost
		choices -= chosen_display
	
	if(length(selected))
		for(var/chosen in selected)
			var/list/option = weapon_options[chosen]
			
			// Add weapons to stashed items
			if(option["items"])
				var/list/items = option["items"]
				var/list/item_count = list() // Track how many of each item type we've added
				for(var/item_type in items)
					// Use the actual item name from the item type
					var/obj/item/temp_item = item_type
					var/item_name = initial(temp_item.name)
					
					// If we've already added this item type, append a number to make it unique
					if(item_count[item_type])
						item_count[item_type]++
						item_name = "[item_name] [item_count[item_type]]"
					else
						item_count[item_type] = 1
					
					recipient.mind?.special_items[item_name] = item_type
			
			// Adjust skill levels
			if(option["skills"])
				var/list/skills = option["skills"]
				var/min_level = option["min_level"]
				var/max_level = option["max_level"]
				for(var/skill in skills)
					if(recipient.get_skill_level(skill) < min_level)
						recipient.adjust_skillrank_up_to(skill, min_level, silent = TRUE)
					else
						recipient.adjust_skillrank_up_to(skill, max_level, silent = TRUE)
