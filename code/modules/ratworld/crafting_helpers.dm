 /****************************************************
 * Ratworld crafting helpers
 ****************************************************/

// Map a crafter's skill level into Expert/Master/Legendary tiers.
// Uses the specific crafting skill appropriate for the item.


/proc/ratworld_get_crafting_tier(mob/living/crafter, obj/item/I)
	if(!crafter || !I)
		return null

	var/level = 0

	// Weapons (not bows): weaponsmithing
	if(istype(I, /obj/item/rogueweapon))
		level = crafter.get_skill_level(/datum/skill/craft/weaponsmithing)
	// Bows: generic crafting skill (based on recipe, not type path; use crafting skill)
	else if(istype(I, /obj/item/gun/ballistic/revolver/grenadelauncher/bow))
		level = crafter.get_skill_level(/datum/skill/craft/crafting)
	// Armor (leather vs metal): use tanning for leather, armorsmithing for other armor
	else if(istype(I, /obj/item/clothing/suit/roguetown/armor/leather))
		level = crafter.get_skill_level(/datum/skill/craft/tanning)
	// Metal armors: armorsmithing
	else if(istype(I, /obj/item/clothing/suit/roguetown/armor))
		level = crafter.get_skill_level(/datum/skill/craft/armorsmithing)
	// Cloth clothing (non-armor): sewing
	else if(istype(I, /obj/item/clothing))
		level = crafter.get_skill_level(/datum/skill/craft/sewing)
	// Fallback metalwork: blacksmithing
	else
		level = crafter.get_skill_level(/datum/skill/craft/blacksmithing)

	if(level >= 7)
		return "legendary"
	if(level >= 5)
		return "master"
	if(level >= 3)
		return "expert"

	return null

// Roll crafted rarity for armors, weapons, and bows only.
/proc/ratworld_roll_crafted_rarity(mob/living/crafter, obj/item/I)
	if(!I || !crafter)
		return RW_RARITY_COMMON
	// Only apply to armor/weapon/bow categories; others default to common
	if(!(istype(I, /obj/item/rogueweapon) || istype(I, /obj/item/clothing) || istype(I, /obj/item/gun/ballistic/revolver/grenadelauncher/bow)))
		return RW_RARITY_COMMON

	var/tier = ratworld_get_crafting_tier(crafter, I)
	if(isnull(tier))
		// Below Expert: cannot craft magical items
		return RW_RARITY_COMMON

	// Base chances in percent for each tier, from design doc
	var/list/chances = list()
	if(tier == "expert")
		chances[RW_RARITY_MAGIC] = 5
		chances[RW_RARITY_RARE] = 1.5
		chances[RW_RARITY_EPIC] = 0.25
		chances[RW_RARITY_LEGENDARY] = 0.15
		chances[RW_RARITY_UNIQUE] = 0.005
		chances[RW_RARITY_ARTIFACT] = 0.000005
	else if(tier == "master")
		chances[RW_RARITY_MAGIC] = 10
		chances[RW_RARITY_RARE] = 2.5
		chances[RW_RARITY_EPIC] = 0.5
		chances[RW_RARITY_LEGENDARY] = 0.25
		chances[RW_RARITY_UNIQUE] = 0.05
		chances[RW_RARITY_ARTIFACT] = 0.0005
	else if(tier == "legendary")
		chances[RW_RARITY_MAGIC] = 15
		chances[RW_RARITY_RARE] = 5
		chances[RW_RARITY_EPIC] = 1
		chances[RW_RARITY_LEGENDARY] = 0.5
		chances[RW_RARITY_UNIQUE] = 0.09
		chances[RW_RARITY_ARTIFACT] = 0.005
	else
		return RW_RARITY_COMMON

	// Convert percentages into a 0-100 scale (common is the remainder)
	var/total_non_common = 0.0
	for(var/r in chances)
		total_non_common += chances[r]

	var/roll = rand() * 100 // 0-100 float
	var/cumulative = 0.0

	// Artifact down to Magic
	var/list/order = list(RW_RARITY_ARTIFACT, RW_RARITY_UNIQUE, RW_RARITY_LEGENDARY, RW_RARITY_EPIC, RW_RARITY_RARE, RW_RARITY_MAGIC)
	for(var/r in order)
		var/p = chances[r]
		if(!p) continue
		cumulative += p
		if(roll <= cumulative)
			return r

	// Otherwise, it's common
	return RW_RARITY_COMMON
