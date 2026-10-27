/// a scabbard must have a valid icon state, or either a default fallback
/datum/unit_test/scabbard_sprites

/datum/unit_test/scabbard_sprites/Run()
	var/list/blades = list()
	for(var/scabbard_type in subtypesof(/obj/item/rogueweapon/scabbard))
		var/obj/item/rogueweapon/scabbard/scabbard = allocate(scabbard_type)
		var/list/candidates = scabbard.valid_blades || (scabbard.valid_blade && typesof(scabbard.valid_blade))
		if(!candidates)
			continue
		for(var/blade_type in candidates)
			if(is_abstract(blade_type))
				continue
			var/obj/item/rogueweapon/blade = blades[blade_type]
			if(!blade)
				blade = allocate(blade_type)
				blades[blade_type] = blade
			if(!scabbard.weapon_check(null, blade))
				continue
			scabbard.sheathed = blade
			scabbard.update_icon()
			if(!icon_exists(scabbard.icon, scabbard.icon_state))
				TEST_FAIL("[scabbard_type] accepts [blade_type] but [scabbard.icon] has no \"[scabbard.icon_state]\" state, and no fallback")
			scabbard.sheathed = null
			scabbard.update_icon()
