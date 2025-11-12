// Centralized SFX selection for Ratworld stash interactions
// Edit here to adjust audio for deposit / withdraw / move.
// Future: could load from external JSON or config.

// Returns a sound file path based on item path/name and action
/proc/ratworld_select_stash_sound(obj/item/I, action)
	if(!action) action = "generic"
	var/laction = lowertext(action)
	if(laction == "pickup")
		return 'sound/ratworld/pickup.ogg'
	if(laction == "coin_deposit")
		return 'sound/ratworld/stashsounds/coin_deposit.ogg'
	// Default place sound if no category match
	var/base_sound = 'sound/ratworld/stashsounds/cloth.ogg'
	// Try modular category mapping first
	if(I)
		var/lname = lowertext("[I.name]")
		var/lpath = lowertext("[I.type]")
		for(var/list/C in GLOB.rw_stash_sfx_categories)
			if(!islist(C)) continue
			var/list/name_patterns = C["name_patterns"]
			var/list/path_patterns = C["path_patterns"]
			var/matched = FALSE
			if(islist(name_patterns))
				for(var/pat in name_patterns)
					if(findtext(lname, lowertext(pat))) { matched = TRUE; break }
			if(!matched && islist(path_patterns))
				for(var/pp in path_patterns)
					if(findtext(lpath, lowertext(pp))) { matched = TRUE; break }
			if(matched)
				var/list/sounds = C["sounds"]
				if(islist(sounds) && sounds.len)
					base_sound = (sounds.len == 1) ? sounds[1] : pick(sounds)
				break
	// Fallback / additional overrides below (ring rarity, boots material etc.)
	var/lpath = I ? lowertext("[I.type]") : ""
	var/lname = I ? lowertext("[I.name]") : ""
	// Order matters: specific before generic
	if(length(lpath) || length(lname))
		// Books
		if(findtext(lpath, "/book") || findtext(lname, "book"))
			return 'sound/ratworld/stashsounds/book_placed.ogg'
		// Rings (rarity not known here; default to common ring sound)
		if(findtext(lpath, "/ring/") || findtext(lname, "ring"))
			var/rar = 0
			if(I)
				if("rarity_tier" in I.vars)
					rar = I.vars["rarity_tier"]
				else if("rarity" in I.vars)
					rar = I.vars["rarity"]
			if(rar >= RW_RARITY_EPIC)
				return 'sound/ratworld/stashsounds/ring_placedown_rare.ogg'
			return 'sound/ratworld/stashsounds/ring_placedown_common.ogg'
		// Necklaces
		if(findtext(lpath, "/clothing/neck/") || findtext(lname, "necklace") || findtext(lname, "amulet"))
			return 'sound/ratworld/stashsounds/necklace_place.ogg'
		// Keys
		if(findtext(lpath, "/key") || findtext(lname, "key"))
			return 'sound/ratworld/stashsounds/key_placed.ogg'
		// Gems
		if(findtext(lpath, "gem") || findtext(lname, "gem"))
			return 'sound/ratworld/stashsounds/gem.ogg'
		// Quiver
		if(findtext(lpath, "quiver") || findtext(lname, "quiver"))
			return 'sound/ratworld/stashsounds/quiver_place.ogg'
		// Crossbow
		if(findtext(lpath, "crossbow") || findtext(lname, "crossbow"))
			return 'sound/ratworld/stashsounds/crossbow_placedown.ogg'
		// Bow
		if(findtext(lpath, "/bow") || (findtext(lname, "bow") && !findtext(lname, "crossbow")))
			return 'sound/ratworld/stashsounds/bow.ogg'
		// Spear
		if(findtext(lpath, "spear") || findtext(lname, "spear"))
			return 'sound/ratworld/stashsounds/spear_placed.ogg'
		// Daggers
		if(findtext(lpath, "dagger") || findtext(lname, "dagger"))
			return 'sound/ratworld/stashsounds/dagger_placedown.ogg'
		// Large weapons (zweihander, greatsword, sword, warhammer, mace, halberd, glaive)
		if(findtext(lname, "zweihander") || findtext(lname, "greatsword") || findtext(lname, "longsword") || findtext(lname, "sword") || findtext(lname, "warhammer") || findtext(lname, "halberd") || findtext(lname, "glaive") || findtext(lpath, "/weapon/"))
			base_sound = 'sound/ratworld/stashsounds/largewep_placed.ogg'
		// Chainmail and chain components
		if(findtext(lname, "hauberk") || findtext(lname, "chain") || findtext(lname, "coif") || findtext(lname, "chainmail") || findtext(lpath, "/chain"))
			return 'sound/ratworld/stashsounds/chainmail_iron.ogg'
		// Plate steel
		if((findtext(lname, "plate") || findtext(lpath, "/plate")) && findtext(lname, "steel"))
			return 'sound/ratworld/stashsounds/plate_steel.ogg'
		// Helmets (metal)
		if((findtext(lname, "helm") || findtext(lpath, "/helmet")) && (findtext(lname, "steel") || findtext(lname, "iron")))
			return 'sound/ratworld/stashsounds/helm_placedown.ogg'
		// Boots: steel/iron armor boots first
		if((findtext(lpath, "/clothing/feet/") || findtext(lname, "boots")) && (findtext(lname, "steel") || findtext(lname, "iron")))
			return 'sound/ratworld/stashsounds/boots_armor_placed.ogg'
		// Leather/regular boots
		if(findtext(lpath, "/clothing/feet/") || findtext(lname, "boots"))
			if(findtext(lname, "leather") || findtext(lname, "hide"))
				return 'sound/ratworld/stashsounds/leather_boots_placed.ogg'
			return 'sound/ratworld/stashsounds/cloth.ogg'
		// Clothing (non-boots): shirts, pants, cloaks, gloves, masks, bundles
		if(findtext(lpath, "/clothing/") || findtext(lname, "bundle") || findtext(lname, "cloth"))
			return 'sound/ratworld/stashsounds/cloth.ogg'
		// Foodstuffs
		if(findtext(lpath, "/food") || findtext(lname, "food") || findtext(lname, "bread") || findtext(lname, "meat") || findtext(lname, "fish") || findtext(lname, "cheese"))
			return 'sound/ratworld/stashsounds/foodstuff.ogg'
		// Potions / bottles / vials / flasks: pick one of three for variation
		if(findtext(lname, "potion") || findtext(lname, "vial") || findtext(lname, "bottle") || findtext(lname, "flask"))
			return pick('sound/ratworld/stashsounds/potion1.ogg','sound/ratworld/stashsounds/potion2.ogg','sound/ratworld/stashsounds/potion3.ogg')
		// Wooden planks/logs (not sticks)
		if(findtext(lname, "plank") || (findtext(lname, "log") && !findtext(lname, "stick")))
			return 'sound/ratworld/stashsounds/plank.ogg'
		// Sticks
		if(findtext(lname, "stick"))
			return 'sound/ratworld/stashsounds/stick.ogg'
		// Treasure / rare treasure
		if(findtext(lname, "treasure") || findtext(lname, "relic") || findtext(lname, "artifact"))
			return 'sound/ratworld/stashsounds/rare_treasure.ogg'
	return base_sound

// Play stash sound with standard volume & optional variation
/proc/ratworld_play_stash_sfx(mob/living/user, obj/item/I, action)
	if(!user) return
	var/sound_path = ratworld_select_stash_sound(I, action)
	if(sound_path)
		playsound(get_turf(user), sound_path, 60, TRUE)

// Error SFX helper (collision, UID issues, invalid moves)
/proc/ratworld_play_stash_error(mob/living/user)
	if(!user) return
	playsound(get_turf(user), 'sound/ratworld/no_can_do.ogg', 70, TRUE)
