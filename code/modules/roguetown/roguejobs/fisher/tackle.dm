/obj/item/fishing
	name = "fishing tackle"
	desc = "A rod attachment that modifies fishing performance, such as hook timing, line strength, depth, fish size, and rarity."
	icon = 'icons/roguetown/items/fishing.dmi'
	icon_state = "twinereel"
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 1
	//affects line hp
	var/linehealth = 0
	//affects margin of error and error mult
	var/difficultymod
	//multiplier to deep fish added to the fishing list. added to base chance dependent on targeted water tile z level and water tile
	var/deepfishingweight
	//affects fish rarity
	var/list/raritymod
	//affects fish size
	var/list/sizemod
	//affects how long the window is to hook a fish
	var/hookmod
	var/attachtype
	var/max_durability = 100
	var/durability = 100

/obj/item/fishing/Initialize(mapload)
	. = ..()
	max_durability = max(1, max_durability)
	max_integrity = max_durability
	obj_integrity = clamp(durability, 0, max_integrity)
	durability = obj_integrity

/obj/item/fishing/proc/get_durability_percent()
	if(max_integrity <= 0)
		return 0
	return round((obj_integrity / max_integrity) * 100)

/obj/item/fishing/proc/adjust_durability(amount)
	if(amount <= 0)
		return FALSE
	obj_integrity = max(0, obj_integrity - amount)
	durability = obj_integrity
	return obj_integrity <= 0

/obj/item/fishing/examine(mob/user)
	. = ..()
	if(attachtype)
		. += span_notice("Attachment type: [attachtype].")
	if(linehealth)
		. += span_notice("Line Toughness: [format_fishing_signed_value(linehealth)] (line strength modifier).")
	if(hookmod)
		. += span_notice("Bite Modifier: [format_fishing_signed_value(hookmod)] (hook timing modifier).")
	if(difficultymod)
		. += span_notice("Fight Ease: [format_fishing_signed_value(difficultymod)] (handling difficulty modifier).")
	if(deepfishingweight)
		. += span_notice("Depth Pull: [format_fishing_signed_value(deepfishingweight)] (depth pull modifier).")
	if(islist(raritymod) && length(raritymod))
		. += span_notice("Rarity Chance: [format_fishing_mod_list(raritymod)] (rarity bias).")
	if(islist(sizemod) && length(sizemod))
		. += span_notice("Size Bias: [format_fishing_mod_list(sizemod)].")

/obj/item/fishing/reel
	attachtype = "reel"

/obj/item/fishing/reel/twine
	name = "twine fishing line"
	desc = "A simple fishing line made out of woven fibers. Cheap, but breaks easily."
	linehealth = 5
	difficultymod = 1
	max_durability = 50
	durability = 50

/obj/item/fishing/reel/leather
	name = "leather fishing line"
	desc = "A fishing line made out of leather. Far stronger than twine, but its visibility makes fish more wary."
	icon_state = "leatherreel"
	linehealth = 8
	hookmod = -3
	max_durability = 100
	durability = 100

/obj/item/fishing/reel/silk
	name = "silk fishing line"
	desc = "A fishing line made out of woven silk. Strong and thin, it's a common choice among seasoned fisherman."
	icon_state = "silkreel"
	linehealth = 10
	difficultymod = -1
	max_durability = 120
	durability = 120

/obj/item/fishing/reel/deluxe
	name = "deluxe fishing line"
	desc = "Extremely sought after by seasoned fisherman, this fishing line was blessed by Abyssorians in their underwater temples. A perfect fishing line, if not for the cost."
	icon_state = "deluxereel"
	linehealth = 14
	hookmod = 3
	difficultymod = -2
	max_durability = 150
	durability = 150

/obj/item/fishing/hook
	attachtype = "hook"

/obj/item/fishing/hook/wooden
	name = "wooden fishing hook"
	desc = "A fishing hook consisting of a small piece of wood, carved to points on both ends. More likely to fall out."
	icon_state = "gorgehook"
	difficultymod = 1
	hookmod = -1
	sizemod = list("normal" = -1, "large" = -1, "huge" = -1, "prize" = -2)
	deepfishingweight = -1
	max_durability = 75
	durability = 75

/obj/item/fishing/hook/thorn
	name = "thorn fishing hook"
	desc = "A fishing hook carved out of a thorn. Effective, but fragile."
	icon_state = "thornhook"
	difficultymod = 2
	linehealth = -2
	max_durability = 50
	durability = 50

/obj/item/fishing/hook/iron
	name = "iron fishing hook"
	desc = "An iron fishing hook. Reliable."
	icon_state = "ironhook"
	linehealth = 2
	max_durability = 120
	durability = 120

/obj/item/fishing/hook/steel
	name = "steel fishing hook"
	desc = "A high-end steel hook with excellent bite control and reinforced shank."
	icon_state = "ironhook"
	linehealth = 3
	hookmod = 1
	difficultymod = -1
	max_durability = 150
	durability = 150

/obj/item/fishing/hook/deluxe
	name = "deluxe wooden lure hook"
	desc = "A small wooden lure, painted to look like a small fish. It functions as a hook and tends to scare off smaller fish. It has two hooks, giving it a chance to hook in another fish."
	icon_state = "deluxehook"
	difficultymod = 2
	raritymod = list("gold" = 1, "ultra" = 1, "rare"= 1, "com"= -3)
	sizemod = list("tiny" = -4, "small" = -3, "normal" = -2, "large" = 2, "huge" = 3, "prize" = 4)
	max_durability = 150
	durability = 150

/obj/item/fishing/line //short for line attachment
	name = "deprecated tackle line"
	desc = "A deprecated base tackle item. Use a bobber or sinker instead."
	attachtype = null
	var/bobber = FALSE

/obj/item/fishing/line/bobber
	attachtype = "line"
	name = "wooden bobber"
	desc = "A wooden bobber. Keeps the hook floating in the water and helps you reel in fish."
	icon_state = "bobber"
	hookmod = 4
	deepfishingweight = -2
	bobber = TRUE
	max_durability = 100
	durability = 100

/obj/item/fishing/line/sinker
	attachtype = "line"
	name = "stone sinker"
	desc = "A stone sinker. Keeps the hook low to catch fish that lurk at the bottom of the water."
	icon_state = "sinker"
	deepfishingweight = 1
	sizemod = list("normal" = -1, "large" = -1, "huge" = -1, "prize" = -2)
	max_durability = 100
	durability = 100
/obj/item/fishing/bait
	isbait = TRUE
	baitpenalty = 0
	fishingMods = list(
		"commonFishingMod" = 1,
		"rareFishingMod" = 1,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0,
		"cheeseFishingMod" = 0
	)

	var/list/fishinglist = list(/obj/item/reagent_containers/food/snacks/fish/eel = 2)
	sizemod = list("tiny" = -2, "small" = -2, "normal" = -1, "large" = 1, "huge" = 1, "prize" = 0)
	var/deeplist
	//whether or not this bait has a special catch behaviour
	var/specialcatch
	//chance to do that behaviour
	var/specialchance
	//whether this behaviour overrides size
	var/specialsize
	//whether this behaviour overrides rarity
	var/specialrarity
	//whether this catches a unique fish/object
	var/specialfishtype
	//whether this specialcatch drops the new thing at the targeted turf instead of at the fisher's feet
	var/specialturfcatch

/obj/item/fishing/bait/proc/makespecial(obj/item/specialify)//put in the new item caught and this should change it in some way, change color, give it a glow and increased size, unique icon, whatever
	return

/obj/item/fishing/bait/Initialize(mapload)
	. = ..()
	sync_bait_durability()

/obj/item/fishing/bait/examine(mob/user)
	. = ..()
	for(var/line in get_bait_modifier_lines())
		. += span_notice(line)

/obj/item/proc/get_bait_modifier_lines()
	var/list/lines = list()
	if(!isbait)
		return lines
	sync_bait_durability()
	lines += "Bait durability: [get_bait_durability_percent()]%"
	var/bite_modifier = -baitpenalty
	if(bite_modifier)
		lines += "Bite Modifier: [format_fishing_signed_value(bite_modifier)] (from bait quality)."
	if(islist(fishingMods) && length(fishingMods))
		lines += "Catch Bias: [format_fishing_pull_mod_list(fishingMods)]."
	if("sizemod" in vars && islist(vars["sizemod"]) && length(vars["sizemod"]))
		lines += "Size Bias: [format_fishing_mod_list(vars["sizemod"])]."
	if("raritymod" in vars && islist(vars["raritymod"]) && length(vars["raritymod"]))
		lines += "Rarity Chance: [format_fishing_mod_list(vars["raritymod"])] (rarity bias)."
	if("deepfishingweight" in vars && vars["deepfishingweight"])
		lines += "Depth Pull: [format_fishing_signed_value(vars["deepfishingweight"])] (depth pull modifier)."
	if("deeplist" in vars && islist(vars["deeplist"]) && length(vars["deeplist"]))
		lines += "Deep Lures: [length(vars["deeplist"])] entries."
	if("specialcatch" in vars && vars["specialcatch"])
		lines += "Special Chance: [vars["specialchance"] || 0]%."
	return lines

/obj/item/fishing/bait/meat
	name = "chum bait"
	desc = "A small amount of meat, rolled into a ball. Attracts predators and dangerous prey from the waters."
	icon_state = "meatbait"
	baitresilience = 90
	bait_max_durability = 90
	fishingMods = list(
		"commonFishingMod" = 1.2,
		"rareFishingMod" = 0.5,
		"treasureFishingMod" = 0.4,
		"trashFishingMod" = 1.3,
		"dangerFishingMod" = 1.6,
		"ceruleanFishingMod" = 0,
		"cheeseFishingMod" = 0
	)
	sizemod = list(
		"tiny" = 0,
		"small" = 0,
		"normal" = 1,
		"large" = 1,
		"huge" = 0,
		"prize" = -1
	)
	fishinglist = list(
		/obj/item/reagent_containers/food/snacks/fish/eel = 2,
		/obj/item/reagent_containers/food/snacks/fish/salmon = 1,
		/obj/item/reagent_containers/food/snacks/fish/bass = 1,
	)

/obj/item/fishing/bait/fly
	name = "fly bait"
	desc = "A feathered lure for fly fishing. Attracts smaller, aggressive and rarer freshwater fish."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "feather"
	baitpenalty = -3
	baitresilience = 90
	bait_max_durability = 90
	fishingMods = list(
		"commonFishingMod" = 0.8,
		"rareFishingMod" = 1.2,
		"treasureFishingMod" = 0.6,
		"trashFishingMod" = 0.6,
		"dangerFishingMod" = 0.9,
		"ceruleanFishingMod" = 0,
		"cheeseFishingMod" = 0
	)
	sizemod = list(
		"tiny" = 2,
		"small" = 2,
		"normal" = 1,
		"large" = -2,
		"huge" = -2,
		"prize" = -1
	)
	fishinglist = list(
		/obj/item/reagent_containers/food/snacks/fish/salmon = 3,
		/obj/item/reagent_containers/food/snacks/fish/salmon/black_headed = 2,
		/obj/item/reagent_containers/food/snacks/fish/bass = 3,
	)

/obj/item/fishing/bait/dough
	name = "doughy bait"
	desc = "A small amount of dough, rolled into a ball. A general-purpose bait for all your fishing needs."
	baitresilience = 90
	bait_max_durability = 90
	fishingMods = list(
		"commonFishingMod" = 1.05,
		"rareFishingMod" = 1.0,
		"treasureFishingMod" = 1.0,
		"trashFishingMod" = 1.0,
		"dangerFishingMod" = 1.0,
		"ceruleanFishingMod" = 0,
		"cheeseFishingMod" = 0
	)
	fishinglist = list(/obj/item/reagent_containers/food/snacks/fish/carp = 2)
	icon = 'icons/roguetown/items/food.dmi'
	icon_state = "doughslice"

/obj/item/fishing/bait/gray
	name = "gray bait"
	desc = "A small amount of dough and meat, rolled into a ball. Attracts more common fish with ease. Water dwelling predators hate it."
	icon_state = "mixedbait"
	baitpenalty = -2
	baitresilience = 90
	bait_max_durability = 90
	fishingMods = list(
		"commonFishingMod" = 1.2,
		"rareFishingMod" = 1.0,
		"treasureFishingMod" = 1.0,
		"trashFishingMod" = 1.0,
		"dangerFishingMod" = 0.8,
		"ceruleanFishingMod" = 0,
		"cheeseFishingMod" = 0
	)
	fishinglist = list(/obj/item/reagent_containers/food/snacks/fish/carp = 1,
					/obj/item/reagent_containers/food/snacks/fish/eel = 1)

/obj/item/fishing/bait/speckled
	name = "speckled bait"
	desc = "A complex blend of meat, flour, and berries rolled into a ball. Attracts deep-water and large fish."
	icon_state = "speckledbait"
	baitresilience = 90
	bait_max_durability = 90
	fishingMods = list(
		"commonFishingMod" = 0.8,
		"rareFishingMod" = 1.15,
		"treasureFishingMod" = 1.1,
		"trashFishingMod" = 0.5,
		"dangerFishingMod" = 1.0,
		"ceruleanFishingMod" = 0,
		"cheeseFishingMod" = 0
	)
	sizemod = list(
		"tiny" = -3,
		"small" = -2,
		"normal" = 0,
		"large" = 1,
		"huge" = 2,
		"prize" = 2
	)
	deepfishingweight = 1
	fishinglist = list(/obj/item/reagent_containers/food/snacks/fish/carp = 1,
					/obj/item/reagent_containers/food/snacks/fish/eel = 1)
	deeplist = list(/obj/item/reagent_containers/food/snacks/fish/angler = 2,
					/obj/item/reagent_containers/food/snacks/fish/clownfish = 1)

/obj/item/fishing/bait/deluxe
	name = "enchanted bait"
	desc = "A ball of unknown ingredients, formulated by Abyssorian priests. Attracts the rarest and largest fish." //waiting for more fishing content
	icon_state = "deluxebait"
	baitpenalty = -2
	baitresilience = 120
	bait_max_durability = 120
	fishingMods = list(
		"commonFishingMod" = 0.8,
		"rareFishingMod" = 1.25,
		"treasureFishingMod" = 1.25,
		"trashFishingMod" = 0.6,
		"dangerFishingMod" = 1.0,
		"ceruleanFishingMod" = 0,
		"cheeseFishingMod" = 0
	)
	sizemod = list("tiny" = -2, "small" = -2, "normal" = -1, "large" = 1, "huge" = 1, "prize" = 2)
	deepfishingweight = 1
	fishinglist = list(/obj/item/reagent_containers/food/snacks/fish/carp = 1,
					/obj/item/reagent_containers/food/snacks/fish/angler = 1)
	deeplist = list(/obj/item/reagent_containers/food/snacks/fish/angler = 2,
					/obj/item/reagent_containers/food/snacks/fish/clownfish = 1)

	specialcatch = TRUE
	specialchance = 20

	specialsize = list(
		"diffmod" = 2,
		"accmod" = 3,
		"health" = 5,
		"costmod" = 4,
		"hookmod" = 2,
		"type" = "prize",
	)
	specialrarity = list(
		"diffmod" = 1,
		"accmod" = 2,
		"health" = 3,
		"costmod" = 10,
		"hookmod" = 2,
		"type" = "Zizoid",
	)
	specialfishtype = list(
		"diffmod" = 2,
		"accmod" = 3,
		"health" = 5,
		"costmod" = 4,
		"hookmod" = 2,
		"type" = /obj/item/reagent_containers/food/snacks/fish/clownfish,
	)

/proc/pickweightmerge(list/List, list/add)//i need a way to merge multiple lists for my shenanigannery to work. remove this if fishing ever stops needing this
	var/list/returner = List
	var/addlength = length(add)
	while(addlength > 0)
		var/returnerlength = length(returner)
		var/find = FALSE
		while(returnerlength > 0)
			if(add[addlength] == returner[returnerlength])
				find = TRUE
				returner[returner[addlength]] += add[add[addlength]]
				break
			returnerlength--
		if(!find)
			returner += add[addlength]
			returner[add[addlength]] = add[add[addlength]]
		addlength--
	return returner

/proc/format_fishing_signed_value(value)
	if(!isnum(value))
		return "0"
	if(value > 0)
		return "+[value]"
	return "[value]"

/proc/format_fishing_mod_list(list/mods)
	if(!islist(mods) || !length(mods))
		return "none"
	var/list/parts = list()
	for(var/key in mods)
		var/value = mods[key]
		if(isnum(value))
			parts += "[key] [format_fishing_signed_value(value)]"
		else
			parts += "[key]: [value]"
	return english_list(parts)

/proc/format_fishing_pull_mod_list(list/mods)
	if(!islist(mods) || !length(mods))
		return "neutral"
	var/list/label_map = list(
		"commonFishingMod" = "Common",
		"rareFishingMod" = "Rare",
		"treasureFishingMod" = "Treasure",
		"trashFishingMod" = "Trash",
		"dangerFishingMod" = "Danger",
		"ceruleanFishingMod" = "Cerulean",
		"cheeseFishingMod" = "Cheese",
	)
	var/list/parts = list()
	for(var/key in label_map)
		if(!(key in mods))
			continue
		var/value = mods[key]
		if(!isnum(value))
			continue
		var/neutral = (key == "ceruleanFishingMod" || key == "cheeseFishingMod") ? 0 : 1
		if(value == neutral)
			continue
		if(neutral == 1)
			var/pct = round((value - 1) * 100)
			parts += "[label_map[key]] [format_fishing_signed_value(pct)]%"
		else
			parts += "[label_map[key]] [format_fishing_signed_value(value)]"
	if(!length(parts))
		return "neutral"
	return english_list(parts)

/proc/removenegativeweights(list/L)
	var/list/R = L
	for(var/item in R)
		if(R[item] < 0)
			R[item] = 0
	return R
