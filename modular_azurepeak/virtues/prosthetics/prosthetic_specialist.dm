/datum/virtue/prosthetics/prosthetic_specialist
	name = "Prosthetic Limbs"
	desc = "Through wealth, connections, or misfortune, some of my limbs have been replaced with prosthetic ones. I can choose which limbs and what materials they appear to be made from."
	custom_text = "Select up to 4 prosthetic limbs. Each limb grants +1 Engineering skill. You can choose bronze, iron, steel, or gold appearance for each limb. All prosthetics have the same performance as bronze limbs - only appearance differs."
	category = "feats"
	virtue_cost = 2
	var/max_selections = 4
	var/list/limb_options = list(
		"Left Arm - Bronze" = list(
			"limb_type" = /obj/item/bodypart/l_arm/prosthetic/bronzeleft,
			"zone" = BODY_ZONE_L_ARM,
			"conflicts" = list(/datum/charflaw/limbloss/arm_l)
		),
		"Left Arm - Iron" = list(
			"limb_type" = /obj/item/bodypart/l_arm/prosthetic/bronzeleft/iron_cosmetic,
			"zone" = BODY_ZONE_L_ARM,
			"conflicts" = list(/datum/charflaw/limbloss/arm_l)
		),
		"Left Arm - Steel" = list(
			"limb_type" = /obj/item/bodypart/l_arm/prosthetic/bronzeleft/steel_cosmetic,
			"zone" = BODY_ZONE_L_ARM,
			"conflicts" = list(/datum/charflaw/limbloss/arm_l)
		),
		"Left Arm - Gold" = list(
			"limb_type" = /obj/item/bodypart/l_arm/prosthetic/bronzeleft/gold_cosmetic,
			"zone" = BODY_ZONE_L_ARM,
			"conflicts" = list(/datum/charflaw/limbloss/arm_l)
		),
		"Right Arm - Bronze" = list(
			"limb_type" = /obj/item/bodypart/r_arm/prosthetic/bronzeright,
			"zone" = BODY_ZONE_R_ARM,
			"conflicts" = list(/datum/charflaw/limbloss/arm_r)
		),
		"Right Arm - Iron" = list(
			"limb_type" = /obj/item/bodypart/r_arm/prosthetic/bronzeright/iron_cosmetic,
			"zone" = BODY_ZONE_R_ARM,
			"conflicts" = list(/datum/charflaw/limbloss/arm_r)
		),
		"Right Arm - Steel" = list(
			"limb_type" = /obj/item/bodypart/r_arm/prosthetic/bronzeright/steel_cosmetic,
			"zone" = BODY_ZONE_R_ARM,
			"conflicts" = list(/datum/charflaw/limbloss/arm_r)
		),
		"Right Arm - Gold" = list(
			"limb_type" = /obj/item/bodypart/r_arm/prosthetic/bronzeright/gold_cosmetic,
			"zone" = BODY_ZONE_R_ARM,
			"conflicts" = list(/datum/charflaw/limbloss/arm_r)
		),
		"Left Leg - Bronze" = list(
			"limb_type" = /obj/item/bodypart/l_leg/prosthetic/bronzeleft,
			"zone" = BODY_ZONE_L_LEG
		),
		"Left Leg - Iron" = list(
			"limb_type" = /obj/item/bodypart/l_leg/prosthetic/bronzeleft/iron_cosmetic,
			"zone" = BODY_ZONE_L_LEG
		),
		"Left Leg - Steel" = list(
			"limb_type" = /obj/item/bodypart/l_leg/prosthetic/bronzeleft/steel_cosmetic,
			"zone" = BODY_ZONE_L_LEG
		),
		"Left Leg - Gold" = list(
			"limb_type" = /obj/item/bodypart/l_leg/prosthetic/bronzeleft/gold_cosmetic,
			"zone" = BODY_ZONE_L_LEG
		),
		"Right Leg - Bronze" = list(
			"limb_type" = /obj/item/bodypart/r_leg/prosthetic/bronzeright,
			"zone" = BODY_ZONE_R_LEG
		),
		"Right Leg - Iron" = list(
			"limb_type" = /obj/item/bodypart/r_leg/prosthetic/bronzeright/iron_cosmetic,
			"zone" = BODY_ZONE_R_LEG
		),
		"Right Leg - Steel" = list(
			"limb_type" = /obj/item/bodypart/r_leg/prosthetic/bronzeright/steel_cosmetic,
			"zone" = BODY_ZONE_R_LEG
		),
		"Right Leg - Gold" = list(
			"limb_type" = /obj/item/bodypart/r_leg/prosthetic/bronzeright/gold_cosmetic,
			"zone" = BODY_ZONE_R_LEG
		)
	)

/datum/virtue/prosthetics/prosthetic_specialist/apply_to_human(mob/living/carbon/human/recipient)
	var/selections_remaining = max_selections
	var/list/choices = list()
	
	// Build choice list with zone indicators
	for(var/limb_name in limb_options)
		choices += limb_name
	
	var/list/selected_zones = list() // Track which zones have been selected
	var/list/selected = list()
	
	while(selections_remaining > 0 && length(choices))
		var/prompt = "Select a prosthetic limb - You have [selections_remaining] selection(s) remaining ([max_selections - selections_remaining]/[max_selections] selected):"
		var/chosen = input(recipient, prompt, "Prosthetic Limbs") as null|anything in choices
		if(!chosen)
			break
		
		var/list/option = limb_options[chosen]
		var/zone = option["zone"]
		
		// Check if this zone is already selected
		if(zone in selected_zones)
			to_chat(recipient, span_warning("You've already selected a prosthetic for [zone]. You can only have one prosthetic per limb."))
			continue
		
		// Check for conflicts with character flaws
		if(recipient.charflaw && option["conflicts"])
			for(var/conflict_type in option["conflicts"])
				if(recipient.charflaw.type == conflict_type)
					to_chat(recipient, span_warning("[chosen] conflicts with your Wood Arm/Leg vice. The prosthetic falls apart, leaving you with no limb."))
					break
		
		selected += chosen
		selected_zones += zone
		selections_remaining--
		
		// Remove all options for this zone from choices
		for(var/other_choice in limb_options)
			var/list/other_option = limb_options[other_choice]
			if(other_option["zone"] == zone)
				choices -= other_choice
	
	// Apply selected prosthetics
	if(length(selected))
		var/skill_bonus = 0
		for(var/chosen in selected)
			var/list/option = limb_options[chosen]
			var/zone = option["zone"]
			var/limb_type = option["limb_type"]
			
			// Check for conflict again before applying
			var/has_conflict = FALSE
			if(recipient.charflaw && option["conflicts"])
				for(var/conflict_type in option["conflicts"])
					if(recipient.charflaw.type == conflict_type)
						has_conflict = TRUE
						break
			
			if(!has_conflict)
				// Remove existing limb
				var/obj/item/bodypart/O = recipient.get_bodypart(zone)
				if(O)
					O.drop_limb()
					qdel(O)
				
				// Attach new prosthetic
				var/obj/item/bodypart/L = new limb_type()
				L.attach_limb(recipient)
				skill_bonus++
		
		// Add engineering skill based on number of prosthetics
		if(skill_bonus > 0)
			recipient.adjust_skillrank_up_to(/datum/skill/craft/engineering, skill_bonus, TRUE)
			to_chat(recipient, span_info("I've learned about engineering from studying my prosthetic limbs. (+[skill_bonus] Engineering)"))
