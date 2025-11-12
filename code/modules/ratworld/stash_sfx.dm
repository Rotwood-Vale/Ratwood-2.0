// Centralized SFX selection for Ratworld stash interactions
// Edit here to adjust audio for deposit / withdraw / move.
// Future: could load from external JSON or config.

// Returns a sound file path based on item path/name and action
// Small classifier that maps an item to a category token
/proc/ratworld_get_item_sfx_class(obj/item/I)
	if(!I) return "cloth"
	var/lname = lowertext("[I.name]")
	var/lpath = lowertext("[I.type]")
	// Precious drinking vessels count as treasure-like
	if(findtext(lname, "goblet") || findtext(lname, "chalice")) return "treasure"
	// Raw materials like ore and coal should sound stone-like
	if(findtext(lname, "ore") || findtext(lname, "coal") || findtext(lpath, "/ore") || findtext(lpath, "/coal")) return "stone"
	if(findtext(lpath, "/book") || findtext(lname, "book")) return "book"
	if(findtext(lpath, "/ring/") || findtext(lname, "ring"))
		var/rar = 0
		if("rarity_tier" in I.vars)
			rar = I.vars["rarity_tier"]
		else if("rarity" in I.vars)
			rar = I.vars["rarity"]
		if(rar >= RW_RARITY_EPIC) return "ring_rare"
		return "ring_common"
	if(findtext(lpath, "/clothing/neck/") || findtext(lname, "necklace") || findtext(lname, "amulet")) return "necklace"
	if(findtext(lpath, "/key") || findtext(lname, "key")) return "key"
	if(findtext(lpath, "gem") || findtext(lname, "gem")) return "gem"
	if(findtext(lpath, "quiver") || findtext(lname, "quiver")) return "quiver"
	if(findtext(lpath, "crossbow") || findtext(lname, "crossbow")) return "crossbow"
	if(findtext(lpath, "/bow") || (findtext(lname, "bow") && !findtext(lname, "crossbow"))) return "bow"
	if(findtext(lpath, "spear") || findtext(lname, "spear")) return "spear"
	if(findtext(lpath, "dagger") || findtext(lname, "dagger")) return "dagger"
	if(findtext(lname, "zweihander") || findtext(lname, "greatsword") || findtext(lname, "longsword") || findtext(lname, "sword") || findtext(lname, "warhammer") || findtext(lname, "halberd") || findtext(lname, "glaive") || findtext(lpath, "/weapon/") || findtext(lpath, "/rogueweapon/")) return "large_weapon"
	if(findtext(lname, "hauberk") || findtext(lname, "chain") || findtext(lname, "coif") || findtext(lname, "chainmail") || findtext(lpath, "/chain")) return "chainmail"
	if((findtext(lname, "plate") || findtext(lpath, "/plate")) && findtext(lname, "steel")) return "plate_steel"
	if((findtext(lname, "helm") || findtext(lpath, "/helmet")) && (findtext(lname, "steel") || findtext(lname, "iron"))) return "helm_metal"
	if((findtext(lpath, "/clothing/feet/") || findtext(lname, "boots")) && (findtext(lname, "steel") || findtext(lname, "iron"))) return "boots_metal"
	if(findtext(lpath, "/clothing/feet/") || findtext(lname, "boots"))
		if(findtext(lname, "leather") || findtext(lname, "hide")) return "boots_leather"
		return "cloth"
	if(findtext(lpath, "/clothing/") || findtext(lname, "bundle") || findtext(lname, "cloth")) return "cloth"
	if(findtext(lpath, "/food") || findtext(lname, "food") || findtext(lname, "bread") || findtext(lname, "meat") || findtext(lname, "fish") || findtext(lname, "cheese")) return "food"
	if(findtext(lname, "potion") || findtext(lname, "vial") || findtext(lname, "bottle") || findtext(lname, "flask")) return "potion"
	if(findtext(lname, "plank") || (findtext(lname, "log") && !findtext(lname, "stick"))) return "plank"
	if(findtext(lname, "stick")) return "stick"
	if(findtext(lname, "treasure") || findtext(lname, "relic") || findtext(lname, "artifact")) return "treasure"
	return "cloth"

// Switch-based dispatcher for final sound selection
/proc/ratworld_select_stash_sound(obj/item/I, action)
	if(!action) action = "generic"
	var/laction = lowertext(action)
	switch(laction)
		if("pickup")
			// For pickup (drag start) use a lighter version per category if available
			var/list/Cp = ratworld_classify_item_for_stash(I)
			if(islist(Cp))
				var/idp = Cp["id"]
				if(idp == "dagger" || idp == "sword" || idp == "sword_large")
					return 'sound/ratworld/stashsounds/dagger_placedown.ogg'
				if(idp == "shield")
					return 'sound/ratworld/stashsounds/helm_placedown.ogg'
				if(idp == "axe" || idp == "mace" || idp == "polearm")
					return 'sound/ratworld/stashsounds/largewep_placed.ogg'
				if(idp == "book")
					return 'sound/ratworld/stashsounds/book_placed.ogg'
				if(idp == "ring" || idp == "rings")
					return 'sound/ratworld/stashsounds/ring_placedown_common.ogg'
			return 'sound/ratworld/pickup.ogg'
		if("coin_deposit")
			return 'sound/ratworld/stashsounds/coin_deposit.ogg'
		// default: continue
	// Default place sound
	var/default_sound = 'sound/ratworld/stashsounds/cloth.ogg'
	// Try modular category mapping first (may yield direct sound selection)
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
					return (sounds.len == 1) ? sounds[1] : pick(sounds)
				break
	// Heuristic classification then switch dispatch
	var/cls = ratworld_get_item_sfx_class(I)
	switch(cls)
		if("stone")                 return 'sound/foley/hit_rock.ogg'
		if("book")                  return 'sound/ratworld/stashsounds/book_placed.ogg'
		if("ring_rare")              return 'sound/ratworld/stashsounds/ring_placedown_rare.ogg'
		if("ring_common")            return 'sound/ratworld/stashsounds/ring_placedown_common.ogg'
		if("necklace")               return 'sound/ratworld/stashsounds/necklace_place.ogg'
		if("key")                    return 'sound/ratworld/stashsounds/key_placed.ogg'
		if("gem")                    return 'sound/ratworld/stashsounds/gem.ogg'
		if("quiver")                 return 'sound/ratworld/stashsounds/quiver_place.ogg'
		if("crossbow")               return 'sound/ratworld/stashsounds/crossbow_placedown.ogg'
		if("bow")                    return 'sound/ratworld/stashsounds/bow.ogg'
		if("spear")                  return 'sound/ratworld/stashsounds/spear_placed.ogg'
		if("dagger")                 return 'sound/ratworld/stashsounds/dagger_placedown.ogg'
		if("large_weapon")           return 'sound/ratworld/stashsounds/largewep_placed.ogg'
		if("chainmail")              return 'sound/ratworld/stashsounds/chainmail_iron.ogg'
		if("plate_steel")            return 'sound/ratworld/stashsounds/plate_steel.ogg'
		if("helm_metal")             return 'sound/ratworld/stashsounds/helm_placedown.ogg'
		if("boots_metal")            return 'sound/ratworld/stashsounds/boots_armor_placed.ogg'
		if("boots_leather")          return 'sound/ratworld/stashsounds/leather_boots_placed.ogg'
		if("food")                   return 'sound/ratworld/stashsounds/foodstuff.ogg'
		if("potion")                 return pick('sound/ratworld/stashsounds/potion1.ogg','sound/ratworld/stashsounds/potion2.ogg','sound/ratworld/stashsounds/potion3.ogg')
		if("plank")                  return 'sound/ratworld/stashsounds/plank.ogg'
		if("stick")                  return 'sound/ratworld/stashsounds/stick.ogg'
		if("treasure")               return 'sound/ratworld/stashsounds/rare_treasure.ogg'
		if("cloth")                  return default_sound
		else                          return default_sound

// Play stash sound with standard volume & optional variation
/proc/ratworld_play_stash_sfx(mob/living/user, obj/item/I, action)
	if(!user) return
	var/sound_path = ratworld_select_stash_sound(I, action)
	if(sound_path)
		// Slightly louder (was 60) and no pitch variation
		playsound(get_turf(user), sound_path, 75, FALSE)

// Error SFX helper (collision, UID issues, invalid moves)
/proc/ratworld_play_stash_error(mob/living/user)
	if(!user) return
	// Disable pitch variation for error as well
	playsound(get_turf(user), 'sound/ratworld/no_can_do.ogg', 80, FALSE)
