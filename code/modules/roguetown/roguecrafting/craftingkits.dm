// CRAFTING KITS SYSTEM
// Based on Eoran food blessing component system
// Allows Cooks, Blacksmiths, and Seamsters to create enhancement kits

// ==================== COOK FOOD SEASONING KITS ====================

#define SEASONED_FOOD_FILTER "seasonedfood"
#define MAX_FOOD_SEASONINGS 2

/datum/component/seasoned_food
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/mob/living/caster
	var/quality
	var/skill
	var/bitesize_mod
	var/effect_type // "healing", "wellfed", "energized", "clearheaded"

/datum/component/seasoned_food/Initialize(mob/living/_caster, var/cooking_skill, var/_effect_type = "healing")
	if(!isitem(parent) || !istype(parent, /obj/item/reagent_containers/food/snacks))
		return COMPONENT_INCOMPATIBLE

	var/obj/item/reagent_containers/food/snacks/F = parent
	
	// Check how many seasonings already applied
	var/seasoning_count = 0
	var/list/existing_types = list()
	for(var/datum/component/seasoned_food/SF in F.GetComponents(/datum/component/seasoned_food))
		seasoning_count++
		existing_types += SF.effect_type
	
	// Check if this type already applied
	if(_effect_type in existing_types)
		return COMPONENT_INCOMPATIBLE
	
	// Check max seasonings
	if(seasoning_count >= MAX_FOOD_SEASONINGS)
		return COMPONENT_INCOMPATIBLE

	caster = _caster
	skill = cooking_skill
	effect_type = _effect_type
	quality = F.faretype
	bitesize_mod = 1 / F.bitesize
	F.faretype = clamp(skill + 1, 1, 5)
	
	// Different outline colors for different effect types
	var/filter_name = "seasoned_[effect_type]"
	switch(effect_type)
		if("healing")
			F.add_filter(filter_name, 1, list("type" = "outline", "color" = "#ff69b4", "size" = 1)) // Pink
		if("wellfed")
			F.add_filter(filter_name, 1, list("type" = "outline", "color" = "#ff4500", "size" = 1)) // Red-orange
		if("energized")
			F.add_filter(filter_name, 1, list("type" = "outline", "color" = "#ffff00", "size" = 1)) // Yellow
		if("clearheaded")
			F.add_filter(filter_name, 1, list("type" = "outline", "color" = "#00bfff", "size" = 1)) // Cyan
		if("sweet")
			F.add_filter(filter_name, 1, list("type" = "outline", "color" = "#ff1493", "size" = 1)) // Deep pink
		if("smoky")
			F.add_filter(filter_name, 1, list("type" = "outline", "color" = "#8b4513", "size" = 1)) // Saddle brown
		if("bitter")
			F.add_filter(filter_name, 1, list("type" = "outline", "color" = "#556b2f", "size" = 1)) // Dark olive
		if("tangy")
			F.add_filter(filter_name, 1, list("type" = "outline", "color" = "#00ff7f", "size" = 1)) // Spring green
	
	RegisterSignal(F, COMSIG_FOOD_EATEN, .proc/on_food_eaten)

/datum/component/seasoned_food/proc/on_food_eaten(datum/source, mob/living/eater, mob/living/feeder)
	SIGNAL_HANDLER
	if(eater == caster)
		eater.visible_message(span_notice("[caster] recognizes their own cooking."))
		return

	// Duration and power scale with skill
	var/base_duration = (2 + skill) MINUTES
	var/bonus_amount = clamp(1 + round(skill / 3), 1, 3) // 1-3 stat bonus based on skill
	
	// Apply effect based on seasoning type
	switch(effect_type)
		if("healing")
			// Healing over time based on skill and quality
			var/heal_amount = (quality + skill) * bitesize_mod
			eater.apply_status_effect(/datum/status_effect/buff/healing, heal_amount)
			to_chat(eater, span_green("The medicinal herbs ease your pain."))
		if("wellfed")
			// STR/CON bonus scaled by skill
			eater.apply_status_effect(/datum/status_effect/buff/foodbuff_strength, base_duration, bonus_amount)
			to_chat(eater, span_green("The rich flavors invigorate your body."))
		if("energized")
			// SPD/END bonus scaled by skill
			eater.apply_status_effect(/datum/status_effect/buff/foodbuff_speed, base_duration, bonus_amount)
			to_chat(eater, span_green("The zesty spices quicken your step."))
		if("clearheaded")
			// INT/WIL bonus scaled by skill
			eater.apply_status_effect(/datum/status_effect/buff/foodbuff_mind, base_duration, bonus_amount)
			to_chat(eater, span_green("The fragrant herbs sharpen your thoughts."))
		if("sweet")
			// PER/INT bonus - heightens senses and clarity
			eater.apply_status_effect(/datum/status_effect/buff/foodbuff_perception, base_duration, bonus_amount)
			to_chat(eater, span_green("The sweet flavors heighten your awareness."))
		if("smoky")
			// CON/END bonus - hearty and filling
			eater.apply_status_effect(/datum/status_effect/buff/foodbuff_fortitude, base_duration, bonus_amount)
			to_chat(eater, span_green("The smoky flavors fortify your resolve."))
		if("bitter")
			// WIL/END bonus - bracing and resilient
			eater.apply_status_effect(/datum/status_effect/buff/foodbuff_resilience, base_duration, bonus_amount)
			to_chat(eater, span_green("The bitter taste steels your determination."))
		if("tangy")
			// SPD/PER bonus - quick and alert
			eater.apply_status_effect(/datum/status_effect/buff/foodbuff_agility, base_duration, bonus_amount)
			to_chat(eater, span_green("The tangy zest sharpens your reflexes."))

/obj/item/seasoning_kit
	name = "spice pouch"
	desc = "A small pouch containing various herbs and spices for cooking."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "spice_AP"
	w_class = WEIGHT_CLASS_SMALL
	var/uses = 3
	var/effect_type = "healing"

/obj/item/seasoning_kit/attack_self(mob/user)
	var/list/choices = list(
		"Medicinal Herbs" = "healing",
		"Savory Spices" = "wellfed",
		"Peppery Blend" = "energized",
		"Aromatic Mix" = "clearheaded",
		"Sweet Glaze" = "sweet",
		"Smoky Rub" = "smoky",
		"Bitter Herbs" = "bitter",
		"Tangy Citrus" = "tangy"
	)
	var/choice = input(user, "What herbs to use?", "Prepare Spices") as anything in choices
	if(!choice)
		return
	effect_type = choices[choice]
	
	switch(effect_type)
		if("healing")
			to_chat(user, span_notice("You pick out medicinal herbs."))
			desc = "Medicinal herbs for healing."
		if("wellfed")
			to_chat(user, span_notice("You select savory spices."))
			desc = "Rich, savory spices."
		if("energized")
			to_chat(user, span_notice("You measure out peppery spices."))
			desc = "Sharp, peppery spices."
		if("clearheaded")
			to_chat(user, span_notice("You gather aromatic herbs."))
			desc = "Fragrant, aromatic herbs."
		if("sweet")
			to_chat(user, span_notice("You prepare a sweet glaze."))
			desc = "Honey and sweet spices."
		if("smoky")
			to_chat(user, span_notice("You mix a smoky rub."))
			desc = "Deep, smoky seasoning."
		if("bitter")
			to_chat(user, span_notice("You gather bitter herbs."))
			desc = "Bitter, bracing herbs."
		if("tangy")
			to_chat(user, span_notice("You prepare tangy citrus."))
			desc = "Zesty citrus and herbs."

/obj/item/seasoning_kit/afterattack(atom/target, mob/living/user, proximity_flag)
	. = ..()
	if(!proximity_flag)
		return
	// Click directly on food to season it
	if(!istype(target, /obj/item/reagent_containers/food/snacks))
		return
	
	var/obj/item/reagent_containers/food/snacks/food = target
	
	// Check current seasoning count
	var/seasoning_count = 0
	var/list/existing_types = list()
	for(var/datum/component/seasoned_food/SF in food.GetComponents(/datum/component/seasoned_food))
		seasoning_count++
		existing_types += SF.effect_type
	
	if(seasoning_count >= MAX_FOOD_SEASONINGS)
		to_chat(user, span_warning("This food has too many seasonings already!"))
		return
	
	if(effect_type in existing_types)
		to_chat(user, span_warning("This food already has these spices!"))
		return
	
	var/cooking_skill = user.get_skill_level(/datum/skill/craft/cooking)
	if(!food.AddComponent(/datum/component/seasoned_food, user, cooking_skill, effect_type))
		to_chat(user, span_warning("Something went wrong!"))
		return
	
	var/effect_name
	switch(effect_type)
		if("healing")
			effect_name = "medicinal herbs"
		if("wellfed")
			effect_name = "savory spices"
		if("energized")
			effect_name = "pepper"
		if("clearheaded")
			effect_name = "aromatic herbs"
		if("sweet")
			effect_name = "sweet glaze"
		if("smoky")
			effect_name = "smoky rub"
		if("bitter")
			effect_name = "bitter herbs"
		if("tangy")
			effect_name = "tangy citrus"
	
	to_chat(user, span_notice("You season [food] with [effect_name]."))
	uses--
	if(uses <= 0)
		qdel(src)
	return TRUE

// ==================== BLACKSMITH ARMOR KITS ====================

#define MAX_ARMOR_MODIFICATIONS 3

/datum/component/armor_modification
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/mod_type
	var/smith_skill

/datum/component/armor_modification/Initialize(var/_mod_type, var/_skill)
	if(!istype(parent, /obj/item/clothing))
		return COMPONENT_INCOMPATIBLE
	
	var/obj/item/clothing/armor = parent
	
	// Check current modification count
	var/mod_count = 0
	var/list/existing_mods = list()
	for(var/datum/component/armor_modification/AM in armor.GetComponents(/datum/component/armor_modification))
		mod_count++
		existing_mods += AM.mod_type
	
	// Check if same type already applied
	if(_mod_type in existing_mods)
		return COMPONENT_INCOMPATIBLE
	
	// Check max modifications
	if(mod_count >= MAX_ARMOR_MODIFICATIONS)
		return COMPONENT_INCOMPATIBLE
	
	mod_type = _mod_type
	smith_skill = _skill
	apply_modification(armor)
	
	// Register signals for equipped/dropped
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))

/datum/component/armor_modification/proc/on_equipped(datum/source, mob/user, slot)
	SIGNAL_HANDLER
	
	if(!isliving(user))
		return
	
	var/mob/living/H = user
	
	// Apply status effects based on modification type
	switch(mod_type)
		if("riveted")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/strong))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/strong)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/slow))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("layered")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/enduring))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/enduring)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/dulled))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/dulled)
		if("fitted")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/speed))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/speed)
		if("studded")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/slow))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("hardened")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/tough))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/tough)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/veryslow))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/veryslow)
		if("quilted")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/enduring))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/enduring)

/datum/component/armor_modification/proc/on_dropped(datum/source, mob/user)
	SIGNAL_HANDLER
	
	if(!isliving(user))
		return
	
	var/mob/living/H = user
	
	// Remove status effects based on modification type
	switch(mod_type)
		if("riveted")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/strong)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("layered")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/enduring)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/dulled)
		if("fitted")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/speed)
		if("studded")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("hardened")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/tough)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/veryslow)
		if("quilted")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/enduring)

/datum/component/armor_modification/proc/apply_modification(obj/item/clothing/armor)
	// Skill affects the magnitude of modifications
	var/skill_mod = clamp(5 + (smith_skill * 2), 5, 20)
	var/negative_mod = -clamp(20 + (smith_skill * 3), 20, 35)
	
	var/filter_name = "mod_[mod_type]"
	switch(mod_type)
		if("riveted")
			// +blunt armor (+STR), -pierce armor, heavy (-SPD), vulnerable to fire
			armor.armor = armor.armor.modifyRating(blunt = skill_mod, piercing = negative_mod, fire = -20)
			// Clamp values to 0-100 range
			armor.armor = armor.armor.modifyRating(
				blunt = clamp(armor.armor.getRating("blunt"), 0, 100) - armor.armor.getRating("blunt"),
				piercing = clamp(armor.armor.getRating("piercing"), 0, 100) - armor.armor.getRating("piercing"),
				fire = clamp(armor.armor.getRating("fire"), 0, 100) - armor.armor.getRating("fire")
			)
			if(!findtext(armor.name, "riveted"))
				armor.name = "riveted [armor.name]"
			armor.add_filter(filter_name, 1, list("type" = "outline", "color" = "#696969", "size" = 1))
		if("layered")
			// +pierce armor (+END), -blunt armor, bulky (-PER), flammable
			armor.armor = armor.armor.modifyRating(piercing = skill_mod, blunt = negative_mod, fire = -20)
			// Clamp values to 0-100 range
			armor.armor = armor.armor.modifyRating(
				blunt = clamp(armor.armor.getRating("blunt"), 0, 100) - armor.armor.getRating("blunt"),
				piercing = clamp(armor.armor.getRating("piercing"), 0, 100) - armor.armor.getRating("piercing"),
				fire = clamp(armor.armor.getRating("fire"), 0, 100) - armor.armor.getRating("fire")
			)
			if(!findtext(armor.name, "layered"))
				armor.name = "layered [armor.name]"
			armor.add_filter(filter_name, 1, list("type" = "outline", "color" = "#8b7355", "size" = 1))
		if("fitted")
			// Better mobility (+SPD), much less protection
			armor.armor = armor.armor.modifyRating(blunt = -25, piercing = -25, fire = -15)
			// Clamp values to 0-100 range
			armor.armor = armor.armor.modifyRating(
				blunt = clamp(armor.armor.getRating("blunt"), 0, 100) - armor.armor.getRating("blunt"),
				piercing = clamp(armor.armor.getRating("piercing"), 0, 100) - armor.armor.getRating("piercing"),
				fire = clamp(armor.armor.getRating("fire"), 0, 100) - armor.armor.getRating("fire")
			)
			if(!findtext(armor.name, "fitted"))
				armor.name = "fitted [armor.name]"
			armor.add_filter(filter_name, 1, list("type" = "outline", "color" = "#556b2f", "size" = 1))
		if("studded")
			// Balanced protection increase, heavier and less flexible
			var/balanced_mod = clamp(3 + smith_skill, 3, 10)
			armor.armor = armor.armor.modifyRating(blunt = balanced_mod, piercing = balanced_mod, fire = -15)
			// Clamp values to 0-100 range
			armor.armor = armor.armor.modifyRating(
				blunt = clamp(armor.armor.getRating("blunt"), 0, 100) - armor.armor.getRating("blunt"),
				piercing = clamp(armor.armor.getRating("piercing"), 0, 100) - armor.armor.getRating("piercing"),
				fire = clamp(armor.armor.getRating("fire"), 0, 100) - armor.armor.getRating("fire")
			)
			if(!findtext(armor.name, "studded"))
				armor.name = "studded [armor.name]"
			armor.add_filter(filter_name, 1, list("type" = "outline", "color" = "#a9a9a9", "size" = 1))
		if("hardened")
			// Heavy blunt protection (+CON), very weak to piercing, very heavy (-2 SPD)
			var/heavy_mod = clamp(8 + (smith_skill * 2), 8, 25)
			armor.armor = armor.armor.modifyRating(blunt = heavy_mod, piercing = -25, fire = -20)
			// Clamp values to 0-100 range
			armor.armor = armor.armor.modifyRating(
				blunt = clamp(armor.armor.getRating("blunt"), 0, 100) - armor.armor.getRating("blunt"),
				piercing = clamp(armor.armor.getRating("piercing"), 0, 100) - armor.armor.getRating("piercing"),
				fire = clamp(armor.armor.getRating("fire"), 0, 100) - armor.armor.getRating("fire")
			)
			if(!findtext(armor.name, "hardened"))
				armor.name = "hardened [armor.name]"
			armor.add_filter(filter_name, 1, list("type" = "outline", "color" = "#2f4f4f", "size" = 1))
		if("quilted")
			// Comfortable padding (+END +pierce), very weak to blunt
			armor.armor = armor.armor.modifyRating(blunt = -25, piercing = 5, fire = -25)
			// Clamp values to 0-100 range
			armor.armor = armor.armor.modifyRating(
				blunt = clamp(armor.armor.getRating("blunt"), 0, 100) - armor.armor.getRating("blunt"),
				piercing = clamp(armor.armor.getRating("piercing"), 0, 100) - armor.armor.getRating("piercing"),
				fire = clamp(armor.armor.getRating("fire"), 0, 100) - armor.armor.getRating("fire")
			)
			if(!findtext(armor.name, "quilted"))
				armor.name = "quilted [armor.name]"
			armor.add_filter(filter_name, 1, list("type" = "outline", "color" = "#daa520", "size" = 1))

/obj/item/armor_kit
	name = "armor materials"
	desc = "Materials for modifying armor."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pri_arm"
	w_class = WEIGHT_CLASS_SMALL
	var/kit_type = "riveted"

/obj/item/armor_kit/riveted
	name = "iron rivets"
	desc = "Heavy iron rivets that can reinforce armor against impacts."
	kit_type = "riveted"

/obj/item/armor_kit/layered
	name = "cloth padding"
	desc = "Layers of cloth padding for protection against cuts."
	kit_type = "layered"

/obj/item/armor_kit/fitted
	name = "leather straps"
	desc = "Quality leather straps for a better fit."
	kit_type = "fitted"

/obj/item/armor_kit/studded
	name = "metal studs"
	desc = "Small metal studs for balanced protection."
	kit_type = "studded"

/obj/item/armor_kit/hardened
	name = "steel plates"
	desc = "Thick steel plates for superior protection."
	kit_type = "hardened"

/obj/item/armor_kit/quilted
	name = "quilted fabric"
	desc = "Quilted fabric padding for comfort and protection."
	kit_type = "quilted"

/obj/item/armor_kit/afterattack(atom/target, mob/living/user, proximity_flag)
	. = ..()
	if(!proximity_flag)
		return
	// Click directly on armor to modify it
	if(!istype(target, /obj/item/clothing))
		return
	
	var/obj/item/clothing/armor = target
	
	// Check if it's armor (has armor_class)
	if(!armor.armor_class || armor.armor_class == ARMOR_CLASS_NONE)
		to_chat(user, span_warning("This isn't armor!"))
		return
	
	// Check blacksmithing skill
	var/smith_skill = user.get_skill_level(/datum/skill/craft/blacksmithing)
	if(smith_skill < 2) // Requires at least apprentice
		to_chat(user, span_warning("I don't have the skill to work armor!"))
		return
	
	// Check current modifications
	var/mod_count = 0
	var/list/existing_mods = list()
	for(var/datum/component/armor_modification/AM in armor.GetComponents(/datum/component/armor_modification))
		mod_count++
		existing_mods += AM.mod_type
	
	if(mod_count >= MAX_ARMOR_MODIFICATIONS)
		to_chat(user, span_warning("This armor has too many modifications!"))
		return
	
	if(kit_type in existing_mods)
		to_chat(user, span_warning("This armor already has this modification!"))
		return
	
	if(!armor.AddComponent(/datum/component/armor_modification, kit_type, smith_skill))
		to_chat(user, span_warning("Something went wrong!"))
		return
	
	to_chat(user, span_notice("You apply [name] to [armor]."))
	qdel(src)
	return TRUE

// ==================== BLACKSMITH WEAPON KITS ====================

#define MAX_WEAPON_MODIFICATIONS 3

/datum/component/weapon_modification
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/mod_type
	var/smith_skill

/datum/component/weapon_modification/Initialize(var/_mod_type, var/_skill)
	if(!istype(parent, /obj/item))
		return COMPONENT_INCOMPATIBLE
	
	var/obj/item/weapon = parent
	
	// Check if it's a weapon with wdefense (combat weapon)
	if(isnull(weapon.wdefense))
		return COMPONENT_INCOMPATIBLE
	
	// Check current modifications
	var/mod_count = 0
	var/list/existing_mods = list()
	for(var/datum/component/weapon_modification/WM in weapon.GetComponents(/datum/component/weapon_modification))
		mod_count++
		existing_mods += WM.mod_type
	
	// Check if same type already applied
	if(_mod_type in existing_mods)
		return COMPONENT_INCOMPATIBLE
	
	// Check max modifications
	if(mod_count >= MAX_WEAPON_MODIFICATIONS)
		return COMPONENT_INCOMPATIBLE
	
	mod_type = _mod_type
	smith_skill = _skill
	apply_modification(weapon)
	
	// Register signals for equipped/dropped
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))

/datum/component/weapon_modification/proc/on_equipped(datum/source, mob/user, slot)
	SIGNAL_HANDLER
	
	if(!isliving(user))
		return
	
	var/mob/living/H = user
	
	// Apply status effects based on modification type
	switch(mod_type)
		if("honed")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/speed))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/speed)
		if("weighted")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/enduring))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/enduring)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/slow))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("oiled")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/perceptive))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/perceptive)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/weakened))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/weakened)
		if("serrated")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/strong))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/strong)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/tiring))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/tiring)
		if("guarded")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/tough))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/tough)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/slow))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("reinforced")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/powerhouse))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/powerhouse)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/slow))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/slow)

/datum/component/weapon_modification/proc/on_dropped(datum/source, mob/user)
	SIGNAL_HANDLER
	
	if(!isliving(user))
		return
	
	var/mob/living/H = user
	
	// Remove status effects based on modification type
	switch(mod_type)
		if("honed")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/speed)
		if("weighted")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/enduring)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("oiled")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/perceptive)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/weakened)
		if("serrated")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/strong)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/tiring)
		if("guarded")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/tough)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("reinforced")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/powerhouse)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/slow)

/datum/component/weapon_modification/proc/apply_modification(obj/item/weapon)
	// Skill affects modification strength
	var/damage_bonus = clamp(2 + round(smith_skill * 0.7), 2, 8)
	var/defense_bonus = clamp(1 + round(smith_skill * 0.5), 1, 5)
	
	var/filter_name = "wmod_[mod_type]"
	switch(mod_type)
		if("honed")
			// +damage (+SPD), -parry, quick strikes
			weapon.force_dynamic += damage_bonus
			weapon.wdefense_dynamic -= 1
			if(!findtext(weapon.name, "honed"))
				weapon.name = "honed [weapon.name]"
			weapon.add_filter(filter_name, 1, list("type" = "outline", "color" = "#dc143c", "size" = 1))
		if("weighted")
			// +parry (+WIL), -damage, heavy (-SPD)
			weapon.wdefense_dynamic += defense_bonus
			weapon.force_dynamic -= 2
			if(!findtext(weapon.name, "weighted"))
				weapon.name = "weighted [weapon.name]"
			weapon.add_filter(filter_name, 1, list("type" = "outline", "color" = "#4169e1", "size" = 1))
		if("oiled")
			// +armor penetration (+PER), -defense, slippery (-STR)
			var/pen_bonus = clamp(0.2 + (smith_skill * 0.05), 0.2, 0.5)
			weapon.intdamage_factor += pen_bonus
			weapon.wdefense_dynamic -= 2
			if(!findtext(weapon.name, "oiled"))
				weapon.name = "oiled [weapon.name]"
			weapon.add_filter(filter_name, 1, list("type" = "outline", "color" = "#daa520", "size" = 1))
		if("serrated")
			// High damage (+STR), reduced defense, jagged (-WIL)
			var/high_damage = clamp(3 + smith_skill, 3, 10)
			weapon.force_dynamic += high_damage
			weapon.wdefense_dynamic -= 2
			if(!findtext(weapon.name, "serrated"))
				weapon.name = "serrated [weapon.name]"
			weapon.add_filter(filter_name, 1, list("type" = "outline", "color" = "#8b0000", "size" = 1))
		if("guarded")
			// High defense bonus (+CON), heavier (-SPD), reduced damage
			var/high_defense = clamp(2 + round(smith_skill * 0.8), 2, 8)
			weapon.wdefense_dynamic += high_defense
			weapon.force_dynamic -= 2
			if(!findtext(weapon.name, "guarded"))
				weapon.name = "guarded [weapon.name]"
			weapon.add_filter(filter_name, 1, list("type" = "outline", "color" = "#4682b4", "size" = 1))
		if("reinforced")
			// Balanced improvement (+STR +CON), heavier (-SPD)
			var/balanced = clamp(1 + round(smith_skill * 0.4), 1, 4)
			weapon.force_dynamic += balanced
			weapon.wdefense_dynamic += balanced
			weapon.wbalance -= 0.5
			if(!findtext(weapon.name, "reinforced"))
				weapon.name = "reinforced [weapon.name]"
			weapon.add_filter(filter_name, 1, list("type" = "outline", "color" = "#708090", "size" = 1))

/obj/item/weapon_kit
	name = "weapon materials"
	desc = "Materials for modifying weapons."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "thornneedlestring"
	w_class = WEIGHT_CLASS_SMALL
	var/kit_type = "honed"

/obj/item/weapon_kit/honed
	name = "whetstone"
	desc = "A fine whetstone for sharpening blades."
	kit_type = "honed"

/obj/item/weapon_kit/weighted
	name = "counterweights"
	desc = "Metal weights to balance a weapon."
	kit_type = "weighted"

/obj/item/weapon_kit/oiled
	name = "weapon oil"
	desc = "Quality oil that helps blades penetrate armor."
	kit_type = "oiled"

/obj/item/weapon_kit/serrated
	name = "serration file"
	desc = "A file for adding wicked serrations to a blade."
	kit_type = "serrated"

/obj/item/weapon_kit/guarded
	name = "crossguard"
	desc = "An improved guard for better defense."
	kit_type = "guarded"

/obj/item/weapon_kit/reinforced
	name = "reinforcing bands"
	desc = "Metal bands to strengthen a weapon."
	kit_type = "reinforced"

/obj/item/weapon_kit/afterattack(atom/target, mob/living/user, proximity_flag)
	. = ..()
	if(!proximity_flag)
		return
	// Click directly on weapon to modify it
	if(!isitem(target))
		return
	
	var/obj/item/weapon = target
	
	// Check if it's a weapon
	if(isnull(weapon.wdefense))
		to_chat(user, span_warning("This isn't a weapon!"))
		return
	
	// Check blacksmithing or weaponsmithing skill
	var/smith_skill = max(user.get_skill_level(/datum/skill/craft/blacksmithing), user.get_skill_level(/datum/skill/craft/weaponsmithing))
	if(smith_skill < 3) // Requires journeyman
		to_chat(user, span_warning("I don't have the skill to work weapons!"))
		return
	
	// Check current modifications
	var/mod_count = 0
	var/list/existing_mods = list()
	for(var/datum/component/weapon_modification/WM in weapon.GetComponents(/datum/component/weapon_modification))
		mod_count++
		existing_mods += WM.mod_type
	
	if(mod_count >= MAX_WEAPON_MODIFICATIONS)
		to_chat(user, span_warning("This weapon has too many modifications!"))
		return
	
	if(kit_type in existing_mods)
		to_chat(user, span_warning("This weapon already has this modification!"))
		return
	
	if(!weapon.AddComponent(/datum/component/weapon_modification, kit_type, smith_skill))
		to_chat(user, span_warning("Something went wrong!"))
		return
	
	to_chat(user, span_notice("You apply [name] to [weapon]."))
	qdel(src)
	return TRUE

// ==================== SEAMSTER CLOTHING KITS (LIGHT ARMOR) ====================

#define MAX_CLOTHING_MODIFICATIONS 3

/datum/component/clothing_modification
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/mod_type
	var/sewing_skill

/datum/component/clothing_modification/Initialize(var/_mod_type, var/_skill)
	if(!istype(parent, /obj/item/clothing))
		return COMPONENT_INCOMPATIBLE
	
	var/obj/item/clothing/cloth = parent
	
	// Only works on light armor
	if(cloth.armor_class != ARMOR_CLASS_LIGHT)
		return COMPONENT_INCOMPATIBLE
	
	// Check current modifications
	var/mod_count = 0
	var/list/existing_mods = list()
	for(var/datum/component/clothing_modification/CM in cloth.GetComponents(/datum/component/clothing_modification))
		mod_count++
		existing_mods += CM.mod_type
	
	// Check if same type already applied
	if(_mod_type in existing_mods)
		return COMPONENT_INCOMPATIBLE
	
	// Check max modifications
	if(mod_count >= MAX_CLOTHING_MODIFICATIONS)
		return COMPONENT_INCOMPATIBLE
	
	mod_type = _mod_type
	sewing_skill = _skill
	apply_modification(cloth)
	
	// Register signals for equipped/dropped
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))

/datum/component/clothing_modification/proc/on_equipped(datum/source, mob/user, slot)
	SIGNAL_HANDLER
	
	if(!isliving(user))
		return
	
	var/mob/living/H = user
	
	// Apply status effects based on modification type
	switch(mod_type)
		if("embroidered")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/perceptive))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/perceptive)
		if("mended")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/tough))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/tough)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/slow))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("tailored")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/speed))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/speed)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/clever))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/clever)
		if("reinforced")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/enduring))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/enduring)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/slow))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("padded")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/tough))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/tough)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/dulled))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/dulled)
		if("weatherproofed")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/enduring))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/enduring)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/slow))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("lined")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/strong))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/strong)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/tiring))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/tiring)
		if("pocketed")
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/clever))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/clever)
			if(!H.has_status_effect(/datum/status_effect/buff/equipmod/slow))
				H.apply_status_effect(/datum/status_effect/buff/equipmod/slow)

/datum/component/clothing_modification/proc/on_dropped(datum/source, mob/user)
	SIGNAL_HANDLER
	
	if(!isliving(user))
		return
	
	var/mob/living/H = user
	
	// Remove status effects based on modification type
	switch(mod_type)
		if("embroidered")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/perceptive)
		if("mended")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/tough)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("tailored")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/speed)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/clever)
		if("reinforced")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/enduring)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("padded")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/tough)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/dulled)
		if("weatherproofed")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/enduring)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/slow)
		if("lined")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/strong)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/tiring)
		if("pocketed")
			H.remove_status_effect(/datum/status_effect/buff/equipmod/clever)
			H.remove_status_effect(/datum/status_effect/buff/equipmod/slow)

/datum/component/clothing_modification/proc/apply_modification(obj/item/clothing/cloth)
	// Skill affects modification strength
	var/skill_mod = clamp(3 + (sewing_skill * 2), 3, 15)
	var/negative_mod = -clamp(20 + (sewing_skill * 2), 20, 30)
	
	var/filter_name = "cmod_[mod_type]"
	switch(mod_type)
		if("embroidered")
			// Elegant appearance (+PER), much less protection
			cloth.armor = cloth.armor.modifyRating(blunt = -25, piercing = -25, fire = -20)
			// Clamp values to 0-100 range
			cloth.armor = cloth.armor.modifyRating(
				blunt = clamp(cloth.armor.getRating("blunt"), 0, 100) - cloth.armor.getRating("blunt"),
				piercing = clamp(cloth.armor.getRating("piercing"), 0, 100) - cloth.armor.getRating("piercing"),
				fire = clamp(cloth.armor.getRating("fire"), 0, 100) - cloth.armor.getRating("fire")
			)
			if(!findtext(cloth.name, "embroidered"))
				cloth.name = "embroidered [cloth.name]"
			cloth.add_filter(filter_name, 1, list("type" = "outline", "color" = "#daa520", "size" = 1))
		if("mended")
			// +pierce (+CON), -blunt armor, patchy (-SPD, flammable)
			cloth.armor = cloth.armor.modifyRating(piercing = skill_mod, blunt = negative_mod, fire = -20)
			// Clamp values to 0-100 range
			cloth.armor = cloth.armor.modifyRating(
				blunt = clamp(cloth.armor.getRating("blunt"), 0, 100) - cloth.armor.getRating("blunt"),
				piercing = clamp(cloth.armor.getRating("piercing"), 0, 100) - cloth.armor.getRating("piercing"),
				fire = clamp(cloth.armor.getRating("fire"), 0, 100) - cloth.armor.getRating("fire")
			)
			if(!findtext(cloth.name, "mended"))
				cloth.name = "mended [cloth.name]"
			cloth.add_filter(filter_name, 1, list("type" = "outline", "color" = "#8b7355", "size" = 1))
		if("tailored")
			// Better fit (+SPD +INT), much less protection
			cloth.armor = cloth.armor.modifyRating(blunt = -25, piercing = -25, fire = -20)
			// Clamp values to 0-100 range
			cloth.armor = cloth.armor.modifyRating(
				blunt = clamp(cloth.armor.getRating("blunt"), 0, 100) - cloth.armor.getRating("blunt"),
				piercing = clamp(cloth.armor.getRating("piercing"), 0, 100) - cloth.armor.getRating("piercing"),
				fire = clamp(cloth.armor.getRating("fire"), 0, 100) - cloth.armor.getRating("fire")
			)
			if(!findtext(cloth.name, "tailored"))
				cloth.name = "tailored [cloth.name]"
			cloth.add_filter(filter_name, 1, list("type" = "outline", "color" = "#4169e1", "size" = 1))
		if("reinforced")
			// Extra padding (+blunt armor, +END), heavier and hot (-SPD, -fire)
			cloth.armor = cloth.armor.modifyRating(blunt = skill_mod, piercing = negative_mod, fire = -25)
			// Clamp values to 0-100 range
			cloth.armor = cloth.armor.modifyRating(
				blunt = clamp(cloth.armor.getRating("blunt"), 0, 100) - cloth.armor.getRating("blunt"),
				piercing = clamp(cloth.armor.getRating("piercing"), 0, 100) - cloth.armor.getRating("piercing"),
				fire = clamp(cloth.armor.getRating("fire"), 0, 100) - cloth.armor.getRating("fire")
			)
			if(!findtext(cloth.name, "reinforced"))
				cloth.name = "reinforced [cloth.name]"
			cloth.add_filter(filter_name, 1, list("type" = "outline", "color" = "#696969", "size" = 1))
		if("padded")
			// Comfortable cushioning (+CON, +pierce), bulky and flammable (-PER, -fire)
			cloth.armor = cloth.armor.modifyRating(piercing = skill_mod, blunt = negative_mod, fire = -25)
			// Clamp values to 0-100 range
			cloth.armor = cloth.armor.modifyRating(
				blunt = clamp(cloth.armor.getRating("blunt"), 0, 100) - cloth.armor.getRating("blunt"),
				piercing = clamp(cloth.armor.getRating("piercing"), 0, 100) - cloth.armor.getRating("piercing"),
				fire = clamp(cloth.armor.getRating("fire"), 0, 100) - cloth.armor.getRating("fire")
			)
			if(!findtext(cloth.name, "padded"))
				cloth.name = "padded [cloth.name]"
			cloth.add_filter(filter_name, 1, list("type" = "outline", "color" = "#deb887", "size" = 1))
		if("weatherproofed")
			// Fire resistant (+fire armor, +END), stiff and heavy (-SPD, -pierce)
			var/fire_mod = clamp(10 + (sewing_skill * 3), 10, 25)
			cloth.armor = cloth.armor.modifyRating(fire = fire_mod, piercing = negative_mod, blunt = -15)
			// Clamp values to 0-100 range
			cloth.armor = cloth.armor.modifyRating(
				blunt = clamp(cloth.armor.getRating("blunt"), 0, 100) - cloth.armor.getRating("blunt"),
				piercing = clamp(cloth.armor.getRating("piercing"), 0, 100) - cloth.armor.getRating("piercing"),
				fire = clamp(cloth.armor.getRating("fire"), 0, 100) - cloth.armor.getRating("fire")
			)
			if(!findtext(cloth.name, "weatherproofed"))
				cloth.name = "weatherproofed [cloth.name]"
			cloth.add_filter(filter_name, 1, list("type" = "outline", "color" = "#2f4f4f", "size" = 1))
		if("lined")
			// Warm insulation (+fire resist, +STR), cumbersome (-blunt, -END)
			var/warm_mod = clamp(8 + (sewing_skill * 2), 8, 20)
			cloth.armor = cloth.armor.modifyRating(fire = warm_mod, blunt = negative_mod, piercing = -15)
			// Clamp values to 0-100 range
			cloth.armor = cloth.armor.modifyRating(
				blunt = clamp(cloth.armor.getRating("blunt"), 0, 100) - cloth.armor.getRating("blunt"),
				piercing = clamp(cloth.armor.getRating("piercing"), 0, 100) - cloth.armor.getRating("piercing"),
				fire = clamp(cloth.armor.getRating("fire"), 0, 100) - cloth.armor.getRating("fire")
			)
			if(!findtext(cloth.name, "lined"))
				cloth.name = "lined [cloth.name]"
			cloth.add_filter(filter_name, 1, list("type" = "outline", "color" = "#8b4513", "size" = 1))
		if("pocketed")
			// Extra storage (+INT), minimal armor and awkward (-all armor, -SPD)
			cloth.armor = cloth.armor.modifyRating(blunt = -20, piercing = -20, fire = -15)
			// Clamp values to 0-100 range
			cloth.armor = cloth.armor.modifyRating(
				blunt = clamp(cloth.armor.getRating("blunt"), 0, 100) - cloth.armor.getRating("blunt"),
				piercing = clamp(cloth.armor.getRating("piercing"), 0, 100) - cloth.armor.getRating("piercing"),
				fire = clamp(cloth.armor.getRating("fire"), 0, 100) - cloth.armor.getRating("fire")
			)
			// Add actual storage capability - 2 small items
			if(!cloth.GetComponent(/datum/component/storage))
				var/datum/component/storage/STR = cloth.AddComponent(/datum/component/storage/concrete/roguetown/belt)
				if(STR)
					STR.max_items = 2
					STR.max_w_class = WEIGHT_CLASS_SMALL
			if(!findtext(cloth.name, "pocketed"))
				cloth.name = "pocketed [cloth.name]"
			cloth.add_filter(filter_name, 1, list("type" = "outline", "color" = "#a0522d", "size" = 1))

/obj/item/clothing_kit
	name = "sewing materials"
	desc = "Materials for modifying clothing."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "garrote_snap"
	w_class = WEIGHT_CLASS_SMALL
	var/kit_type = "embroidered"

/obj/item/clothing_kit/embroidered
	name = "decorative thread"
	desc = "Fine thread for embroidering protective patterns."
	kit_type = "embroidered"

/obj/item/clothing_kit/mended
	name = "repair patches"
	desc = "Tough fabric patches for reinforcement."
	kit_type = "mended"

/obj/item/clothing_kit/tailored
	name = "fitting pins"
	desc = "Pins and thread for a better fit."
	kit_type = "tailored"

/obj/item/clothing_kit/reinforced
	name = "padding material"
	desc = "Extra padding for improved protection."
	kit_type = "reinforced"

/obj/item/clothing_kit/padded
	name = "cushioning layers"
	desc = "Soft layers for comfort and light protection."
	kit_type = "padded"

/obj/item/clothing_kit/weatherproofed
	name = "waterproofing wax"
	desc = "Treated fabric for weather resistance."
	kit_type = "weatherproofed"

/obj/item/clothing_kit/lined
	name = "fur lining"
	desc = "Warm fur for insulation."
	kit_type = "lined"

/obj/item/clothing_kit/pocketed
	name = "hidden pockets"
	desc = "Extra pockets for carrying supplies."
	kit_type = "pocketed"

/obj/item/clothing_kit/afterattack(atom/target, mob/living/user, proximity_flag)
	. = ..()
	if(!proximity_flag)
		return
	// Click directly on clothing to modify it
	if(!istype(target, /obj/item/clothing))
		return
	
	var/obj/item/clothing/cloth = target
	
	// Only works on light armor
	if(cloth.armor_class != ARMOR_CLASS_LIGHT)
		to_chat(user, span_warning("This only works on light armor!"))
		return
	
	// Check sewing skill
	var/sewing_skill = user.get_skill_level(/datum/skill/craft/sewing)
	if(sewing_skill < 3) // Requires journeyman
		to_chat(user, span_warning("I don't have the skill to modify clothing!"))
		return
	
	// Check current modifications
	var/mod_count = 0
	var/list/existing_mods = list()
	for(var/datum/component/clothing_modification/CM in cloth.GetComponents(/datum/component/clothing_modification))
		mod_count++
		existing_mods += CM.mod_type
	
	if(mod_count >= MAX_CLOTHING_MODIFICATIONS)
		to_chat(user, span_warning("This garment has too many modifications!"))
		return
	
	if(kit_type in existing_mods)
		to_chat(user, span_warning("This garment already has this modification!"))
		return
	
	if(!cloth.AddComponent(/datum/component/clothing_modification, kit_type, sewing_skill))
		to_chat(user, span_warning("Something went wrong!"))
		return
	
	to_chat(user, span_notice("You apply [name] to [cloth]."))
	qdel(src)
	return TRUE

// ==================== CRAFTING RECIPES ====================

// --- COOK SEASONING KITS ---

/datum/crafting_recipe/roguetown/cooking/spice_pouch
	name = "spice pouch"
	result = /obj/item/seasoning_kit
	reqs = list(
		/obj/item/reagent_containers/powder/salt = 1,
		/obj/item/natural/fibers = 1
	)
	craftdiff = 1
	subtype_reqs = TRUE
	tools = list(/obj/item/reagent_containers/glass/mortar, /obj/item/pestle)
	skillcraft = /datum/skill/craft/cooking

// --- BLACKSMITH ARMOR KITS ---

/datum/crafting_recipe/roguetown/anvil/armor_kit_riveted
	name = "iron rivets"
	result = /obj/item/armor_kit/riveted
	reqs = list(
		/obj/item/ingot/iron = 1
	)
	craftdiff = 2
	tools = list(/obj/item/rogueweapon/hammer)
	skillcraft = /datum/skill/craft/blacksmithing

/datum/crafting_recipe/roguetown/anvil/armor_kit_layered
	name = "cloth padding"
	result = /obj/item/armor_kit/layered
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/fibers = 2
	)
	craftdiff = 2
	tools = list(/obj/item/rogueweapon/hammer)
	skillcraft = /datum/skill/craft/blacksmithing

/datum/crafting_recipe/roguetown/anvil/armor_kit_fitted
	name = "leather straps"
	result = /obj/item/armor_kit/fitted
	reqs = list(
		/obj/item/natural/hide = 1
	)
	craftdiff = 2
	tools = list(/obj/item/rogueweapon/hammer)
	skillcraft = /datum/skill/craft/blacksmithing

/datum/crafting_recipe/roguetown/anvil/armor_kit_studded
	name = "metal studs"
	result = /obj/item/armor_kit/studded
	reqs = list(
		/obj/item/ingot/iron = 1
	)
	craftdiff = 2
	tools = list(/obj/item/rogueweapon/hammer)
	skillcraft = /datum/skill/craft/blacksmithing

/datum/crafting_recipe/roguetown/anvil/armor_kit_hardened
	name = "steel plates"
	result = /obj/item/armor_kit/hardened
	reqs = list(
		/obj/item/ingot/steel = 1
	)
	craftdiff = 3
	tools = list(/obj/item/rogueweapon/hammer)
	skillcraft = /datum/skill/craft/blacksmithing

/datum/crafting_recipe/roguetown/anvil/armor_kit_quilted
	name = "quilted fabric"
	result = /obj/item/armor_kit/quilted
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 3
	)
	craftdiff = 2
	tools = list(/obj/item/rogueweapon/hammer)
	skillcraft = /datum/skill/craft/blacksmithing

// --- BLACKSMITH WEAPON KITS ---

/datum/crafting_recipe/roguetown/anvil/weapon_kit_honed
	name = "whetstone"
	result = /obj/item/weapon_kit/honed
	reqs = list(
		/obj/item/natural/stone = 2
	)
	craftdiff = 3
	tools = list(/obj/item/rogueweapon/hammer)
	skillcraft = /datum/skill/craft/weaponsmithing

/datum/crafting_recipe/roguetown/anvil/weapon_kit_weighted
	name = "counterweights"
	result = /obj/item/weapon_kit/weighted
	reqs = list(
		/obj/item/ingot/iron = 1,
		/obj/item/natural/cloth = 1
	)
	craftdiff = 3
	tools = list(/obj/item/rogueweapon/hammer)
	skillcraft = /datum/skill/craft/weaponsmithing

/datum/crafting_recipe/roguetown/anvil/weapon_kit_oiled
	name = "weapon oil"
	result = /obj/item/weapon_kit/oiled
	reqs = list(
		/obj/item/reagent_containers/food/snacks/fat = 1,
		/obj/item/natural/cloth = 1
	)
	craftdiff = 3
	tools = list(/obj/item/rogueweapon/hammer)
	skillcraft = /datum/skill/craft/weaponsmithing

/datum/crafting_recipe/roguetown/anvil/weapon_kit_serrated
	name = "serration file"
	result = /obj/item/weapon_kit/serrated
	reqs = list(
		/obj/item/ingot/iron = 1
	)
	craftdiff = 4
	tools = list(/obj/item/rogueweapon/hammer)
	skillcraft = /datum/skill/craft/weaponsmithing

/datum/crafting_recipe/roguetown/anvil/weapon_kit_guarded
	name = "crossguard"
	result = /obj/item/weapon_kit/guarded
	reqs = list(
		/obj/item/ingot/steel = 1
	)
	craftdiff = 4
	tools = list(/obj/item/rogueweapon/hammer)
	skillcraft = /datum/skill/craft/weaponsmithing

/datum/crafting_recipe/roguetown/anvil/weapon_kit_reinforced
	name = "reinforcing bands"
	result = /obj/item/weapon_kit/reinforced
	reqs = list(
		/obj/item/ingot/iron = 2
	)
	craftdiff = 4
	tools = list(/obj/item/rogueweapon/hammer)
	skillcraft = /datum/skill/craft/weaponsmithing

// --- SEAMSTER CLOTHING KITS ---

/datum/crafting_recipe/roguetown/sewing/clothing_kit_embroidered
	name = "decorative thread"
	result = /obj/item/clothing_kit/embroidered
	reqs = list(
		/obj/item/natural/fibers = 3
	)
	craftdiff = 3
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing

/datum/crafting_recipe/roguetown/sewing/clothing_kit_mended
	name = "repair patches"
	result = /obj/item/clothing_kit/mended
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 2
	)
	craftdiff = 3
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing

/datum/crafting_recipe/roguetown/sewing/clothing_kit_tailored
	name = "fitting pins"
	result = /obj/item/clothing_kit/tailored
	reqs = list(
		/obj/item/natural/cloth = 1,
		/obj/item/natural/silk = 1
	)
	craftdiff = 3
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing

// ==================== EQUIPMENT MODIFICATION STATUS EFFECTS ====================

// Armor/Clothing/Weapon mod stat effects
/datum/status_effect/buff/equipmod
	effectedstats = list()
	alert_type = /atom/movable/screen/alert/status_effect/buff/equipmod

/datum/status_effect/buff/equipmod/on_apply()
	if(!effectedstats || !effectedstats.len)
		return FALSE
	return TRUE

/atom/movable/screen/alert/status_effect/buff/equipmod
	name = "Equipment Modification"
	desc = "Modified equipment affects my abilities."
	icon_state = "buff"

// SPD boost
/datum/status_effect/buff/equipmod/speed
	id = "equipmod_speed"
	effectedstats = list(STATKEY_SPD = 1)

/atom/movable/screen/alert/status_effect/buff/equipmod/speed
	name = "Swift"
	desc = "Light equipment increases my speed."

// SPD penalty -1
/datum/status_effect/buff/equipmod/slow
	id = "equipmod_slow"
	effectedstats = list(STATKEY_SPD = -1)

/atom/movable/screen/alert/status_effect/buff/equipmod/slow
	name = "Burdened"
	desc = "Heavy equipment slows me down."

// SPD penalty -2
/datum/status_effect/buff/equipmod/veryslow
	id = "equipmod_veryslow"
	effectedstats = list(STATKEY_SPD = -2)

/atom/movable/screen/alert/status_effect/buff/equipmod/veryslow
	name = "Heavily Burdened"
	desc = "Very heavy equipment greatly slows me down."

// CON boost
/datum/status_effect/buff/equipmod/tough
	id = "equipmod_tough"
	effectedstats = list(STATKEY_CON = 1)

/atom/movable/screen/alert/status_effect/buff/equipmod/tough
	name = "Fortified"
	desc = "Reinforced equipment toughens me up."

// PER boost
/datum/status_effect/buff/equipmod/perceptive
	id = "equipmod_perceptive"
	effectedstats = list(STATKEY_PER = 1)

/atom/movable/screen/alert/status_effect/buff/equipmod/perceptive
	name = "Sharp-Eyed"
	desc = "Fine craftsmanship heightens my senses."

// STR boost
/datum/status_effect/buff/equipmod/strong
	id = "equipmod_strong"
	effectedstats = list(STATKEY_STR = 1)

/atom/movable/screen/alert/status_effect/buff/equipmod/strong
	name = "Empowered"
	desc = "Well-balanced equipment empowers my strikes."

// WIL boost
/datum/status_effect/buff/equipmod/enduring
	id = "equipmod_enduring"
	effectedstats = list(STATKEY_WIL = 1)

/atom/movable/screen/alert/status_effect/buff/equipmod/enduring
	name = "Enduring"
	desc = "Sturdy equipment improves my stamina."

// STR+CON combo
/datum/status_effect/buff/equipmod/powerhouse
	id = "equipmod_powerhouse"
	effectedstats = list(STATKEY_STR = 1, STATKEY_CON = 1)

/atom/movable/screen/alert/status_effect/buff/equipmod/powerhouse
	name = "Powerhouse"
	desc = "Heavy equipment makes me feel powerful and tough."

// PER debuff
/datum/status_effect/buff/equipmod/dulled
	id = "equipmod_dulled"
	effectedstats = list(STATKEY_PER = -1)

/atom/movable/screen/alert/status_effect/buff/equipmod/dulled
	name = "Dulled Senses"
	desc = "Heavy modifications dull my awareness."

// STR debuff
/datum/status_effect/buff/equipmod/weakened
	id = "equipmod_weakened"
	effectedstats = list(STATKEY_STR = -1)

/atom/movable/screen/alert/status_effect/buff/equipmod/weakened
	name = "Weakened"
	desc = "Poorly balanced equipment weakens my strikes."

// WIL debuff
/datum/status_effect/buff/equipmod/tiring
	id = "equipmod_tiring"
	effectedstats = list(STATKEY_WIL = -1)

/atom/movable/screen/alert/status_effect/buff/equipmod/tiring
	name = "Tiring"
	desc = "This equipment drains my stamina."

// INT boost
/datum/status_effect/buff/equipmod/clever
	id = "equipmod_clever"
	effectedstats = list(STATKEY_INT = 1)

/atom/movable/screen/alert/status_effect/buff/equipmod/clever
	name = "Clear-Minded"
	desc = "Fine equipment sharpens my mind."

// ==================== FOOD BUFF STATUS EFFECTS ====================

// Hearty Spices - STR/CON buff (skill-scaled)
/datum/status_effect/buff/foodbuff_strength
	id = "foodbuff_strength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff_strength
	var/bonus = 1

/datum/status_effect/buff/foodbuff_strength/on_creation(mob/living/new_owner, duration = 2 MINUTES, bonus_amount = 1)
	src.duration = duration
	src.bonus = bonus_amount
	return ..()

/datum/status_effect/buff/foodbuff_strength/on_apply()
	if(owner.stat == DEAD)
		return FALSE
	effectedstats = list(STATKEY_STR = bonus, STATKEY_CON = bonus)
	to_chat(owner, span_green("I feel stronger!"))
	owner.add_stress(/datum/stressevent/goodmeal)
	return TRUE

/datum/status_effect/buff/foodbuff_strength/on_remove()
	to_chat(owner, span_warning("The strength fades."))
	return ..()

/atom/movable/screen/alert/status_effect/buff/foodbuff_strength
	name = "Hearty Meal"
	desc = "The rich food strengthens my body."
	icon_state = "foodbuff"

// Energizing Blend - SPD/END buff (skill-scaled)
/datum/status_effect/buff/foodbuff_speed
	id = "foodbuff_speed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff_speed
	var/bonus = 1

/datum/status_effect/buff/foodbuff_speed/on_creation(mob/living/new_owner, duration = 2 MINUTES, bonus_amount = 1)
	src.duration = duration
	src.bonus = bonus_amount
	return ..()

/datum/status_effect/buff/foodbuff_speed/on_apply()
	if(owner.stat == DEAD)
		return FALSE
	effectedstats = list(STATKEY_SPD = bonus, STATKEY_WIL = bonus)
	to_chat(owner, span_green("I feel quicker!"))
	owner.add_stress(/datum/stressevent/goodmeal)
	return TRUE

/datum/status_effect/buff/foodbuff_speed/on_remove()
	to_chat(owner, span_warning("The energy fades."))
	return ..()

/atom/movable/screen/alert/status_effect/buff/foodbuff_speed
	name = "Energized"
	desc = "The spicy food quickens my steps."
	icon_state = "foodbuff"

// Mental Clarity - INT/WIL buff (skill-scaled)
/datum/status_effect/buff/foodbuff_mind
	id = "foodbuff_mind"
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff_mind
	var/bonus = 1

/datum/status_effect/buff/foodbuff_mind/on_creation(mob/living/new_owner, duration = 2 MINUTES, bonus_amount = 1)
	src.duration = duration
	src.bonus = bonus_amount
	return ..()

/datum/status_effect/buff/foodbuff_mind/on_apply()
	if(owner.stat == DEAD)
		return FALSE
	effectedstats = list(STATKEY_INT = bonus, STATKEY_WIL = bonus)
	to_chat(owner, span_green("My mind sharpens!"))
	owner.add_stress(/datum/stressevent/goodmeal)
	return TRUE

/datum/status_effect/buff/foodbuff_mind/on_remove()
	to_chat(owner, span_warning("My clarity fades."))
	return ..()

/atom/movable/screen/alert/status_effect/buff/foodbuff_mind
	name = "Clear Headed"
	desc = "The fragrant herbs sharpen my thoughts."
	icon_state = "foodbuff"

// Sweet Glaze - PER/INT buff (skill-scaled)
/datum/status_effect/buff/foodbuff_perception
	id = "foodbuff_perception"
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff_perception
	var/bonus = 1

/datum/status_effect/buff/foodbuff_perception/on_creation(mob/living/new_owner, duration = 2 MINUTES, bonus_amount = 1)
	src.duration = duration
	src.bonus = bonus_amount
	return ..()

/datum/status_effect/buff/foodbuff_perception/on_apply()
	if(owner.stat == DEAD)
		return FALSE
	effectedstats = list(STATKEY_PER = bonus, STATKEY_INT = bonus)
	to_chat(owner, span_green("My senses sharpen!"))
	owner.add_stress(/datum/stressevent/goodmeal)
	return TRUE

/datum/status_effect/buff/foodbuff_perception/on_remove()
	to_chat(owner, span_warning("The heightened awareness fades."))
	return ..()

/atom/movable/screen/alert/status_effect/buff/foodbuff_perception
	name = "Heightened Senses"
	desc = "The sweet flavors sharpen my awareness."
	icon_state = "foodbuff"

// Smoky Rub - CON/END buff (skill-scaled)
/datum/status_effect/buff/foodbuff_fortitude
	id = "foodbuff_fortitude"
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff_fortitude
	var/bonus = 1

/datum/status_effect/buff/foodbuff_fortitude/on_creation(mob/living/new_owner, duration = 2 MINUTES, bonus_amount = 1)
	src.duration = duration
	src.bonus = bonus_amount
	return ..()

/datum/status_effect/buff/foodbuff_fortitude/on_apply()
	if(owner.stat == DEAD)
		return FALSE
	effectedstats = list(STATKEY_CON = bonus, STATKEY_WIL = bonus)
	to_chat(owner, span_green("I feel fortified!"))
	owner.add_stress(/datum/stressevent/goodmeal)
	return TRUE

/datum/status_effect/buff/foodbuff_fortitude/on_remove()
	to_chat(owner, span_warning("The fortitude fades."))
	return ..()

/atom/movable/screen/alert/status_effect/buff/foodbuff_fortitude
	name = "Fortified"
	desc = "The smoky flavors strengthen my resolve."
	icon_state = "foodbuff"

// Bitter Herbs - WIL/END buff (skill-scaled)
/datum/status_effect/buff/foodbuff_resilience
	id = "foodbuff_resilience"
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff_resilience
	var/bonus = 1

/datum/status_effect/buff/foodbuff_resilience/on_creation(mob/living/new_owner, duration = 2 MINUTES, bonus_amount = 1)
	src.duration = duration
	src.bonus = bonus_amount
	return ..()

/datum/status_effect/buff/foodbuff_resilience/on_apply()
	if(owner.stat == DEAD)
		return FALSE
	effectedstats = list(STATKEY_WIL = bonus, STATKEY_WIL = bonus)
	to_chat(owner, span_green("My will steels!"))
	owner.add_stress(/datum/stressevent/goodmeal)
	return TRUE

/datum/status_effect/buff/foodbuff_resilience/on_remove()
	to_chat(owner, span_warning("The resilience fades."))
	return ..()

/atom/movable/screen/alert/status_effect/buff/foodbuff_resilience
	name = "Resilient"
	desc = "The bitter taste steels my determination."
	icon_state = "foodbuff"

// Tangy Citrus - SPD/PER buff (skill-scaled)
/datum/status_effect/buff/foodbuff_agility
	id = "foodbuff_agility"
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff_agility
	var/bonus = 1

/datum/status_effect/buff/foodbuff_agility/on_creation(mob/living/new_owner, duration = 2 MINUTES, bonus_amount = 1)
	src.duration = duration
	src.bonus = bonus_amount
	return ..()

/datum/status_effect/buff/foodbuff_agility/on_apply()
	if(owner.stat == DEAD)
		return FALSE
	effectedstats = list(STATKEY_SPD = bonus, STATKEY_PER = bonus)
	to_chat(owner, span_green("I feel nimble!"))
	owner.add_stress(/datum/stressevent/goodmeal)
	return TRUE

/datum/status_effect/buff/foodbuff_agility/on_remove()
	to_chat(owner, span_warning("The nimbleness fades."))
	return ..()

/atom/movable/screen/alert/status_effect/buff/foodbuff_agility
	name = "Nimble"
	desc = "The tangy zest quickens my reflexes."
	icon_state = "foodbuff"
