// Healing Effects
#define EFFECT_HEAL_BRUTE "heal_brute"
#define EFFECT_HEAL_BURN "heal_burn"
#define EFFECT_HEAL_TOX "heal_toxin"
#define EFFECT_RESTORE_BLOOD "restore_blood"
#define EFFECT_RESTORE_STAMINA "restore_stamina"
#define EFFECT_RESTORE_MANA "restore_mana"
#define EFFECT_RESTORE_DEVOTION "restore_devotion"

//damaging effects
#define EFFECT_DAMAGE_BRUTE "damage_brute"
#define EFFECT_DAMAGE_BURN "damage_burn"
#define EFFECT_DAMAGE_TOX "damage_toxin"
#define EFFECT_DRAIN_BLOOD "drain_blood"
#define EFFECT_DRAIN_STAMINA "drain_stamina"
#define EFFECT_DRAIN_MANA "drain_mana"
#define EFFECT_DRAIN_DEVOTION "drain_devotion"

//stat buffs
#define EFFECT_FORTIFY_STRENGTH "fortify_strength"
#define EFFECT_FORTIFY_PERCEPTION "fortify_perception"
#define EFFECT_FORTIFY_INTELLIGENCE "fortify_intelligence"
#define EFFECT_FORTIFY_CONSTITUTION "fortify_constitution"
#define EFFECT_FORTIFY_ENDURANCE "fortify_endurance"
#define EFFECT_FORTIFY_SPEED "fortify_speed"
#define EFFECT_FORTIFY_LUCK "fortify_luck"

//stat debuffs
#define EFFECT_WEAKEN_STRENGTH "weaken_strength"
#define EFFECT_WEAKEN_PERCEPTION "weaken_perception"
#define EFFECT_WEAKEN_INTELLIGENCE "weaken_intelligence"
#define EFFECT_WEAKEN_CONSTITUTION "weaken_constitution"
#define EFFECT_WEAKEN_ENDURANCE "weaken_endurance"
#define EFFECT_WEAKEN_SPEED "weaken_speed"
#define EFFECT_WEAKEN_LUCK "weaken_luck"

// Status Effects
#define EFFECT_BLINDNESS "blindness"
#define EFFECT_SILENCE "silence"
#define EFFECT_DEAFEN "deafen"
#define EFFECT_NO_PAIN "no_pain"
#define EFFECT_WEAKNESS "weakness"
#define EFFECT_INVISIBILITY "invisibility"

// Resistance
#define EFFECT_MAGIC_RESIST "magic_resist"
#define EFFECT_CRIT_RESIST "crit_resist"
#define EFFECT_FEATHER_FALL "feather_fall"
#define EFFECT_FIRE_IMMUNE "fire_immune"
#define EFFECT_FROST_IMMUNE "frost_immune"
#define EFFECT_ELECTRIC_IMMUNE "electric_immune"

// Elemental Effects
#define EFFECT_FIRE_STACKS "fire_stacks"
#define EFFECT_FROST_STACKS "frost_slow"
#define EFFECT_SHOCK_DAMAGE "shock_damage"

// Greater Healing Effects
#define EFFECT_GREATER_HEAL_BRUTE "greater_heal_brute"
#define EFFECT_GREATER_HEAL_BURN "greater_heal_burn"
#define EFFECT_GREATER_HEAL_TOX "greater_heal_toxin"
#define EFFECT_GREATER_RESTORE_BLOOD "greater_restore_blood"
#define EFFECT_GREATER_RESTORE_STAMINA "greater_restore_stamina"
#define EFFECT_GREATER_RESTORE_MANA "greater_restore_mana"
#define EFFECT_GREATER_RESTORE_DEVOTION "greater_restore_devotion"

// Greater damaging effects
#define EFFECT_GREATER_DAMAGE_BRUTE "greater_damage_brute"
#define EFFECT_GREATER_DAMAGE_BURN "greater_damage_burn"
#define EFFECT_GREATER_DAMAGE_TOX "greater_damage_toxin"
#define EFFECT_GREATER_DRAIN_BLOOD "greater_drain_blood"
#define EFFECT_GREATER_DRAIN_STAMINA "greater_drain_stamina"
#define EFFECT_GREATER_DRAIN_MANA "greater_drain_mana"
#define EFFECT_GREATER_DRAIN_DEVOTION "greater_drain_devotion"

//Greater stat buffs
#define EFFECT_GREATER_FORTIFY_STRENGTH "greater_fortify_strength"
#define EFFECT_GREATER_FORTIFY_PERCEPTION "greater_fortify_perception"
#define EFFECT_GREATER_FORTIFY_INTELLIGENCE "greater_fortify_intelligence"
#define EFFECT_GREATER_FORTIFY_CONSTITUTION "greater_fortify_constitution"
#define EFFECT_GREATER_FORTIFY_ENDURANCE "greater_fortify_endurance"
#define EFFECT_GREATER_FORTIFY_SPEED "greater_fortify_speed"
#define EFFECT_GREATER_FORTIFY_LUCK "greater_fortify_luck"

//Greater stat debuffs
#define EFFECT_GREATER_WEAKEN_STRENGTH "greater_weaken_strength"
#define EFFECT_GREATER_WEAKEN_PERCEPTION "greater_weaken_perception"
#define EFFECT_GREATER_WEAKEN_INTELLIGENCE "greater_weaken_intelligence"
#define EFFECT_GREATER_WEAKEN_CONSTITUTION "greater_weaken_constitution"
#define EFFECT_GREATER_WEAKEN_ENDURANCE "greater_weaken_endurance"
#define EFFECT_GREATER_WEAKEN_SPEED "greater_weaken_speed"
#define EFFECT_GREATER_WEAKEN_LUCK "greater_weaken_luck"

//Greater Status Effects
#define EFFECT_GREATER_BLINDNESS "greater_blindness"
#define EFFECT_GREATER_SILENCE "greater_silence"
#define EFFECT_GREATER_DEAFEN "greater_deafen"
#define EFFECT_GREATER_NO_PAIN "greater_no_pain"
#define EFFECT_GREATER_WEAKNESS "greater_weakness"
#define EFFECT_GREATER_INVISIBILITY "greater_invisibility"

//Greater Resistance
#define EFFECT_GREATER_MAGIC_RESIST "greater_magic_resist"
#define EFFECT_GREATER_CRIT_RESIST "greater_crit_resist"
#define EFFECT_GREATER_FEATHER_FALL "greater_feather_fall"
#define EFFECT_GREATER_FIRE_IMMUNE "greater_fire_immune"
#define EFFECT_GREATER_FROST_IMMUNE "greater_frost_immune"
#define EFFECT_GREATER_ELECTRIC_IMMUNE "greater_electric_immune"

//Greater Elemental Effects
#define EFFECT_GREATER_FIRE_STACKS "greater_fire_stacks"
#define EFFECT_GREATER_FROST_STACKS "greater_frost_slow"
#define EFFECT_GREATER_SHOCK_DAMAGE "greater_shock_damage"


// Global map: normal effect → GREATER effect
GLOBAL_LIST_INIT(alchemy_effect_greater_versions, list(
	EFFECT_HEAL_BRUTE = EFFECT_GREATER_HEAL_BRUTE,
	EFFECT_HEAL_BURN = EFFECT_GREATER_HEAL_BURN,
	EFFECT_HEAL_TOX = EFFECT_GREATER_HEAL_TOX,
	EFFECT_RESTORE_BLOOD = EFFECT_GREATER_RESTORE_BLOOD,
	EFFECT_RESTORE_STAMINA = EFFECT_GREATER_RESTORE_STAMINA,
	EFFECT_RESTORE_MANA = EFFECT_GREATER_RESTORE_MANA,
	EFFECT_RESTORE_DEVOTION = EFFECT_GREATER_RESTORE_DEVOTION,
	EFFECT_DAMAGE_BRUTE = EFFECT_GREATER_DAMAGE_BRUTE,
	EFFECT_DAMAGE_BURN = EFFECT_GREATER_DAMAGE_BURN,
	EFFECT_DAMAGE_TOX = EFFECT_GREATER_DAMAGE_TOX,
	EFFECT_DRAIN_BLOOD = EFFECT_GREATER_DRAIN_BLOOD,
	EFFECT_DRAIN_STAMINA = EFFECT_GREATER_DRAIN_STAMINA,
	EFFECT_DRAIN_MANA = EFFECT_GREATER_DRAIN_MANA,
	EFFECT_DRAIN_DEVOTION = EFFECT_GREATER_DRAIN_DEVOTION,
	EFFECT_FORTIFY_STRENGTH = EFFECT_GREATER_FORTIFY_STRENGTH,
	EFFECT_FORTIFY_PERCEPTION = EFFECT_GREATER_FORTIFY_PERCEPTION,
	EFFECT_FORTIFY_INTELLIGENCE = EFFECT_GREATER_FORTIFY_INTELLIGENCE,
	EFFECT_FORTIFY_CONSTITUTION = EFFECT_GREATER_FORTIFY_CONSTITUTION,
	EFFECT_FORTIFY_ENDURANCE = EFFECT_GREATER_FORTIFY_ENDURANCE,
	EFFECT_FORTIFY_SPEED = EFFECT_GREATER_FORTIFY_SPEED,
	EFFECT_FORTIFY_LUCK = EFFECT_GREATER_FORTIFY_LUCK,
	EFFECT_WEAKEN_STRENGTH = EFFECT_GREATER_WEAKEN_STRENGTH,
	EFFECT_WEAKEN_PERCEPTION = EFFECT_GREATER_WEAKEN_PERCEPTION,
	EFFECT_WEAKEN_INTELLIGENCE = EFFECT_GREATER_WEAKEN_INTELLIGENCE,
	EFFECT_WEAKEN_CONSTITUTION = EFFECT_GREATER_WEAKEN_CONSTITUTION,
	EFFECT_WEAKEN_ENDURANCE = EFFECT_GREATER_WEAKEN_ENDURANCE,
	EFFECT_WEAKEN_SPEED = EFFECT_GREATER_WEAKEN_SPEED,
	EFFECT_WEAKEN_LUCK = EFFECT_GREATER_WEAKEN_LUCK,
	EFFECT_BLINDNESS = EFFECT_GREATER_BLINDNESS,
	EFFECT_SILENCE = EFFECT_GREATER_SILENCE,
	EFFECT_DEAFEN = EFFECT_GREATER_DEAFEN,
	EFFECT_NO_PAIN = EFFECT_GREATER_NO_PAIN,
	EFFECT_WEAKNESS = EFFECT_GREATER_WEAKNESS,
	EFFECT_INVISIBILITY = EFFECT_GREATER_INVISIBILITY,
	EFFECT_MAGIC_RESIST = EFFECT_GREATER_MAGIC_RESIST,
	EFFECT_CRIT_RESIST = EFFECT_GREATER_CRIT_RESIST,
	EFFECT_FEATHER_FALL = EFFECT_GREATER_FEATHER_FALL,
	EFFECT_FIRE_IMMUNE = EFFECT_GREATER_FIRE_IMMUNE,
	EFFECT_FROST_IMMUNE = EFFECT_GREATER_FROST_IMMUNE,
	EFFECT_ELECTRIC_IMMUNE = EFFECT_GREATER_ELECTRIC_IMMUNE,
	EFFECT_FIRE_STACKS = EFFECT_GREATER_FIRE_STACKS,
	EFFECT_FROST_STACKS = EFFECT_GREATER_FROST_STACKS,
	EFFECT_SHOCK_DAMAGE = EFFECT_GREATER_SHOCK_DAMAGE
))

// Helper proc to get GREATER version of an effect
/proc/get_greater_effect(effect)
	return GLOB.alchemy_effect_greater_versions[effect] || effect

// Helper proc to upgrade effects list to GREATER versions
/proc/upgrade_effects_to_greater(list/effects)
	if(!effects || !effects.len)
		return list()
	var/list/greater_effects = list()
	for(var/effect in effects)
		greater_effects += get_greater_effect(effect)
	return greater_effects

// Global associative list mapping effects to their smells (includes basic effects, GREATER use same smells)
GLOBAL_LIST_INIT(alchemy_effect_smells, list(
	EFFECT_HEAL_BRUTE = "wet moss",
	EFFECT_HEAL_BURN = "oniony balm",
	EFFECT_HEAL_TOX = "medicinal cloves",
	EFFECT_RESTORE_STAMINA = "fresh herbs",
	EFFECT_RESTORE_MANA = "crisp mint",
	EFFECT_RESTORE_BLOOD = "iron-rich earth",
	EFFECT_RESTORE_DEVOTION = "sacred incense",
	EFFECT_DAMAGE_BRUTE = "sharp thorns",
	EFFECT_DAMAGE_BURN = "charred wood",
	EFFECT_DAMAGE_TOX = "rotten fungus",
	EFFECT_DRAIN_STAMINA = "wilted leaves",
	EFFECT_DRAIN_MANA = "stale air",
	EFFECT_DRAIN_BLOOD = "metallic tang",
	EFFECT_DRAIN_DEVOTION = "dark smoke",
	EFFECT_FORTIFY_STRENGTH = "musky root",
	EFFECT_FORTIFY_PERCEPTION = "sharp citrus",
	EFFECT_FORTIFY_INTELLIGENCE = "pungent sage",
	EFFECT_FORTIFY_CONSTITUTION = "earthy bark",
	EFFECT_FORTIFY_ENDURANCE = "robust pine",
	EFFECT_FORTIFY_SPEED = "zesty ginger",
	EFFECT_FORTIFY_LUCK = "sweet vanilla",
	EFFECT_WEAKEN_STRENGTH = "sour berry",
	EFFECT_WEAKEN_PERCEPTION = "musty mildew",
	EFFECT_WEAKEN_INTELLIGENCE = "bitter herb",
	EFFECT_WEAKEN_CONSTITUTION = "stale leaves",
	EFFECT_WEAKEN_ENDURANCE = "faded wood",
	EFFECT_WEAKEN_SPEED = "flat citrus",
	EFFECT_WEAKEN_LUCK = "bland grain",
	EFFECT_BLINDNESS = "smoky ash",
	EFFECT_SILENCE = "muted lavender",
	EFFECT_DEAFEN = "dull chamomile",
	EFFECT_NO_PAIN = "soothing aloe",
	EFFECT_WEAKNESS = "faint musk",
	EFFECT_INVISIBILITY = "foggy dew",
	EFFECT_MAGIC_RESIST = "crackling ozone",
	EFFECT_CRIT_RESIST = "hardened bark",
	EFFECT_FEATHER_FALL = "light dandelion",
	EFFECT_FIRE_IMMUNE = "warm cinnamon",
	EFFECT_FROST_IMMUNE = "cool eucalyptus",
	EFFECT_FIRE_STACKS = "spicy pepper",
	EFFECT_FROST_STACKS = "icy mint",
	EFFECT_SHOCK_DAMAGE = "electric citrus",
	EFFECT_GREATER_HEAL_BRUTE = "rich camphor",
	EFFECT_GREATER_HEAL_BURN = "potent sweat",
	EFFECT_GREATER_HEAL_TOX = "strong menthol",
	EFFECT_GREATER_RESTORE_STAMINA = "vibrant tang",
	EFFECT_GREATER_RESTORE_MANA = "intense basil",
	EFFECT_GREATER_RESTORE_BLOOD = "deep iron",
	EFFECT_GREATER_RESTORE_DEVOTION = "holy frankincense",
	EFFECT_GREATER_DAMAGE_BRUTE = "piercing needles",
	EFFECT_GREATER_DAMAGE_BURN = "scorched ember",
	EFFECT_GREATER_DAMAGE_TOX = "toxic mold",
	EFFECT_GREATER_DRAIN_STAMINA = "withered vine",
	EFFECT_GREATER_DRAIN_MANA = "stagnant air",
	EFFECT_GREATER_DRAIN_BLOOD = "thick iron",
	EFFECT_GREATER_DRAIN_DEVOTION = "dark smog",
	EFFECT_GREATER_FORTIFY_STRENGTH = "strong musk",
	EFFECT_GREATER_FORTIFY_PERCEPTION = "piercing lemon",
	EFFECT_GREATER_FORTIFY_INTELLIGENCE = "elevated rosemary",
	EFFECT_GREATER_FORTIFY_CONSTITUTION = "sturdy oak",
	EFFECT_GREATER_FORTIFY_ENDURANCE = "robust cedar",
	EFFECT_GREATER_FORTIFY_SPEED = "fleeting ginger",
	EFFECT_GREATER_FORTIFY_LUCK = "rich honey",
	EFFECT_GREATER_WEAKEN_STRENGTH = "intense sourberry",
	EFFECT_GREATER_WEAKEN_PERCEPTION = "thick mold",
	EFFECT_GREATER_WEAKEN_INTELLIGENCE = "strong bitterness",
	EFFECT_GREATER_WEAKEN_CONSTITUTION = "withered bark",
	EFFECT_GREATER_WEAKEN_ENDURANCE = "brittle wood",
	EFFECT_GREATER_WEAKEN_SPEED = "stale zest",
	EFFECT_GREATER_WEAKEN_LUCK = "tasteless grain",
	EFFECT_GREATER_BLINDNESS = "dense smoke",
	EFFECT_GREATER_SILENCE = "heavy lavender",
	EFFECT_GREATER_DEAFEN = "thick chamomile",
	EFFECT_GREATER_NO_PAIN = "powerful aloe",
	EFFECT_GREATER_WEAKNESS = "strong musk",
	EFFECT_GREATER_INVISIBILITY = "thick fog",
	EFFECT_GREATER_MAGIC_RESIST = "intense ozone",
	EFFECT_GREATER_CRIT_RESIST = "solid bark",
	EFFECT_GREATER_FEATHER_FALL = "fluffy dandelion",
	EFFECT_GREATER_FIRE_IMMUNE = "rich cinnamon",
	EFFECT_GREATER_FROST_IMMUNE = "deep eucalyptus",
	EFFECT_GREATER_FIRE_STACKS = "fiery chili",
	EFFECT_GREATER_FROST_STACKS = "sharp menthol",
	EFFECT_GREATER_SHOCK_DAMAGE = "volatile citrus"
))

// Global associative list mapping effects to paired words [adjective, noun] for potion naming
GLOBAL_LIST_INIT(alchemy_effect_words, list(
	EFFECT_HEAL_BRUTE = list("mending", "heal"),
	EFFECT_HEAL_BURN = list("soothing", "balm"),
	EFFECT_HEAL_TOX = list("curing", "antidote"),
	EFFECT_RESTORE_STAMINA = list("energizing", "vigor"),
	EFFECT_RESTORE_MANA = list("invigorating", "essence"),
	EFFECT_RESTORE_BLOOD = list("vital", "fluid"),
	EFFECT_RESTORE_DEVOTION = list("sacred", "elixir"),
	EFFECT_DAMAGE_BRUTE = list("wounding", "bane"),
	EFFECT_DAMAGE_BURN = list("scorching", "blight"),
	EFFECT_DAMAGE_TOX = list("poisonous", "venom"),
	EFFECT_DRAIN_STAMINA = list("fatiguing", "draught"),
	EFFECT_DRAIN_MANA = list("exhausting", "drain"),
	EFFECT_DRAIN_BLOOD = list("sapping", "leech"),
	EFFECT_DRAIN_DEVOTION = list("darkening", "shade"),
	EFFECT_FORTIFY_STRENGTH = list("mighty", "power"),
	EFFECT_FORTIFY_PERCEPTION = list("keen", "sight"),
	EFFECT_FORTIFY_INTELLIGENCE = list("brilliant", "mind"),
	EFFECT_FORTIFY_CONSTITUTION = list("hardy", "body"),
	EFFECT_FORTIFY_ENDURANCE = list("enduring", "fortitude"),
	EFFECT_FORTIFY_SPEED = list("swift", "motion"),
	EFFECT_FORTIFY_LUCK = list("fortunate", "blessing"),
	EFFECT_WEAKEN_STRENGTH = list("enfeebling", "curse"),
	EFFECT_WEAKEN_PERCEPTION = list("dulling", "fog"),
	EFFECT_WEAKEN_INTELLIGENCE = list("clouding", "mire"),
	EFFECT_WEAKEN_CONSTITUTION = list("frail", "wilt"),
	EFFECT_WEAKEN_ENDURANCE = list("weary", "drain"),
	EFFECT_WEAKEN_SPEED = list("sluggish", "sloth"),
	EFFECT_WEAKEN_LUCK = list("jinxed", "misfortune"),
	EFFECT_BLINDNESS = list("darkening", "shadow"),
	EFFECT_SILENCE = list("muting", "silence"),
	EFFECT_DEAFEN = list("deafening", "roar"),
	EFFECT_NO_PAIN = list("numbing", "ease"),
	EFFECT_WEAKNESS = list("feeble", "frailty"),
	EFFECT_INVISIBILITY = list("unseen", "cloak"),
	EFFECT_MAGIC_RESIST = list("warding", "aegis"),
	EFFECT_CRIT_RESIST = list("fortified", "guard"),
	EFFECT_FEATHER_FALL = list("floating", "descent"),
	EFFECT_FIRE_IMMUNE = list("fireproof", "fire ward"),
	EFFECT_FROST_IMMUNE = list("frostproof", "frost ward"),
	EFFECT_ELECTRIC_IMMUNE = list("grounding", "shock ward"),
	EFFECT_FIRE_STACKS = list("blazing", "inferno"),
	EFFECT_FROST_STACKS = list("freezing", "frost"),
	EFFECT_SHOCK_DAMAGE = list("crackling", "lightning"),
	// Greater Effects use same words
	EFFECT_GREATER_HEAL_BRUTE = list("mending", "greater heal"),
	EFFECT_GREATER_HEAL_BURN = list("soothing", "greater balm"),
	EFFECT_GREATER_HEAL_TOX = list("curing", "greater antidote"),
	EFFECT_GREATER_RESTORE_STAMINA = list("energizing", "greater vigor"),
	EFFECT_GREATER_RESTORE_MANA = list("invigorating", "greater essence"),
	EFFECT_GREATER_RESTORE_BLOOD = list("vital", "greater fluid"),
	EFFECT_GREATER_RESTORE_DEVOTION = list("sacred", "greater elixir"),
	EFFECT_GREATER_DAMAGE_BRUTE = list("wounding", "greater bane"),
	EFFECT_GREATER_DAMAGE_BURN = list("scorching", "greater blight"),
	EFFECT_GREATER_DAMAGE_TOX = list("poisonous", "greater venom"),
	EFFECT_GREATER_DRAIN_STAMINA = list("fatiguing", "greater draught"),
	EFFECT_GREATER_DRAIN_MANA = list("exhausting", "greater drain"),
	EFFECT_GREATER_DRAIN_BLOOD = list("sapping", "greater leech"),
	EFFECT_GREATER_DRAIN_DEVOTION = list("darkening", "greater shade"),
	EFFECT_GREATER_FORTIFY_STRENGTH = list("mighty", "greater power"),
	EFFECT_GREATER_FORTIFY_PERCEPTION = list("keen", "greater sight"),
	EFFECT_GREATER_FORTIFY_INTELLIGENCE = list("brilliant", "greater mind"),
	EFFECT_GREATER_FORTIFY_CONSTITUTION = list("hardy", "greater body"),
	EFFECT_GREATER_FORTIFY_ENDURANCE = list("enduring", "greater fortitude"),
	EFFECT_GREATER_FORTIFY_SPEED = list("swift", "greater motion"),
	EFFECT_GREATER_FORTIFY_LUCK = list("fortunate", "greater blessing"),
	EFFECT_GREATER_WEAKEN_STRENGTH = list("enfeebling", "greater curse"),
	EFFECT_GREATER_WEAKEN_PERCEPTION = list("dulling", "greater fog"),
	EFFECT_GREATER_WEAKEN_INTELLIGENCE = list("clouding", "greater mire"),
	EFFECT_GREATER_WEAKEN_CONSTITUTION = list("frail", "greater wilt"),
	EFFECT_GREATER_WEAKEN_ENDURANCE = list("weary", "greater drain"),
	EFFECT_GREATER_WEAKEN_SPEED = list("sluggish", "greater sloth"),
	EFFECT_GREATER_WEAKEN_LUCK = list("jinxed", "greater misfortune"),
	EFFECT_GREATER_BLINDNESS = list("darkening", "greater shadow"),
	EFFECT_GREATER_SILENCE = list("muting", "greater silence"),
	EFFECT_GREATER_DEAFEN = list("deafening", "greater roar"),
	EFFECT_GREATER_NO_PAIN = list("numbing", "greater ease"),
	EFFECT_GREATER_WEAKNESS = list("feeble", "greater frailty"),
	EFFECT_GREATER_INVISIBILITY = list("unseen", "greater cloak"),
	EFFECT_GREATER_MAGIC_RESIST = list("warding", "greater aegis"),
	EFFECT_GREATER_CRIT_RESIST = list("fortified", "greater guard"),
	EFFECT_GREATER_FEATHER_FALL = list("floating", "greater descent"),
	EFFECT_GREATER_FIRE_IMMUNE = list("fireproof", "greater fire ward"),
	EFFECT_GREATER_FROST_IMMUNE = list("frostproof", "greater frost ward"),
	EFFECT_GREATER_ELECTRIC_IMMUNE = list("grounding", "greater shock ward"),
))

// Helper proc to get smell description for an effect
/proc/get_effect_smell(effect)
	return GLOB.alchemy_effect_smells[effect] || "strange essence"

// Helper proc to get word pair for an effect [adjective, noun]
/proc/get_effect_words(effect)
	return GLOB.alchemy_effect_words[effect] || list("strange", "brew")

// Helper proc to generate potion name from effects list
/proc/generate_potion_name(list/effects)
	if(!effects || !effects.len)
		return "alchemical potion"
	
	// 3 or more effects = "strange brew"
	if(effects.len >= 3)
		return "strange brew"
	
	// 1 effect: use ONLY first word (adjective) from that effect
	if(effects.len == 1)
		var/list/words = get_effect_words(effects[1])
		return "[words[1]]"
	
	// 2 effects: mix adjective from first with noun from second
	if(effects.len == 2)
		var/list/words1 = get_effect_words(effects[1])
		var/list/words2 = get_effect_words(effects[2])
		return "[words1[1]] [words2[2]]"
	
	return "alchemical potion"

// Helper proc to blend colors
/proc/blend_colors(color1, color2, ratio = 0.5)
	if(!color1 || !color2)
		return color1 || color2 || "#FFFFFF"
	
	var/r1 = hex2num(copytext(color1, 2, 4))
	var/g1 = hex2num(copytext(color1, 4, 6))
	var/b1 = hex2num(copytext(color1, 6, 8))
	
	var/r2 = hex2num(copytext(color2, 2, 4))
	var/g2 = hex2num(copytext(color2, 4, 6))
	var/b2 = hex2num(copytext(color2, 6, 8))
	
	var/r = round(r1 * (1 - ratio) + r2 * ratio)
	var/g = round(g1 * (1 - ratio) + g2 * ratio)
	var/b = round(b1 * (1 - ratio) + b2 * ratio)
	
	return rgb(r, g, b)

// Add alchemy effects variable to all reagents (simple list, no datum wrapper)
/datum/reagent
	var/list/alchemy_effects = null
	var/smell_description = null  // For alchemy smells

// Helper proc to set alchemy effects on a reagent
/datum/reagent/proc/set_alchemy_effects(list/effect_list)
	if(!effect_list || !effect_list.len)
		alchemy_effects = null
		return
	alchemy_effects = effect_list.Copy()

// Proc to get common effects between two reagents
/proc/get_common_alchemy_effects(datum/reagent/R1, datum/reagent/R2)
	if(!R1?.alchemy_effects || !R2?.alchemy_effects)
		return list()
	
	var/list/common = list()
	for(var/effect in R1.alchemy_effects)
		if(effect in R2.alchemy_effects)
			common += effect
	
	return common

// Check if mixing should occur and perform it
/datum/reagents/proc/try_alchemy_mixing()
	if(!my_atom)
		return FALSE
	
	// Need at least 2 reagents to mix
	if(reagent_list.len < 2)
		return FALSE
	
	// Find pairs of reagents with common effects
	for(var/i = 1 to reagent_list.len)
		var/datum/reagent/R1 = reagent_list[i]
		if(!R1.alchemy_effects || !R1.alchemy_effects.len)
			continue
			
		for(var/j = i+1 to reagent_list.len)
			var/datum/reagent/R2 = reagent_list[j]
			if(!R2.alchemy_effects || !R2.alchemy_effects.len)
				continue
			
			// Check if both reagents share any common source herbs - if so, skip
			if(istype(R1, /datum/reagent/herb_extract) && istype(R2, /datum/reagent/herb_extract))
				var/datum/reagent/herb_extract/E1 = R1
				var/datum/reagent/herb_extract/E2 = R2
				if(E1.source_herb_name && E2.source_herb_name)
					// Split by hyphen to get all source herbs
					var/list/herbs1 = splittext(E1.source_herb_name, "-")
					var/list/herbs2 = splittext(E2.source_herb_name, "-")
					var/has_common_herb = FALSE
					for(var/herb1 in herbs1)
						if(herb1 in herbs2)
							has_common_herb = TRUE
							break
					if(has_common_herb)
						continue  // Share a common herb source, don't mix
			
			// Get common effects
			var/list/common = get_common_alchemy_effects(R1, R2)
			if(!common || !common.len)
				continue
			
			// Found a match! Create combined extract with all common effects
			// Calculate amount to convert (minimum of the two reagents)
			var/convert_amount = min(R1.volume, R2.volume)
			convert_amount = min(convert_amount, 30)  // Max 30 units per mix
			
			// Remove source reagents
			remove_reagent(R1.type, convert_amount)
			remove_reagent(R2.type, convert_amount)
			
			// Create a new tonic with combined effects (2 reagents → 1 mixed extract)
			var/datum/reagent/herb_extract/tonic/mixed = new()
			mixed.alchemy_effects = common.Copy()
			
			// Combine herb names to prevent re-mixing
			var/datum/reagent/herb_extract/E1 = R1
			var/datum/reagent/herb_extract/E2 = R2
			mixed.source_herb_name = "[E1.source_herb_name]-[E2.source_herb_name]"
			
			// Generate name based on effects
			mixed.name = generate_potion_name(common)
			mixed.description = "A potion created by mixing reagents with common alchemical properties."
			
			// Blend colors (50/50 mix)
			mixed.color = blend_colors(R1.color, R2.color, 0.5)
			
			// Combine smells from effects
			var/list/smell_parts = list()
			for(var/effect in common)
				var/smell = get_effect_smell(effect)
				if(smell && !(smell in smell_parts))
					smell_parts += smell
			mixed.smell_description = smell_parts.Join(", ")
			
			// Combine tastes
			if(R1.taste_description && R2.taste_description)
				mixed.taste_description = "[R1.taste_description] and [R2.taste_description]"
			else
				mixed.taste_description = R1.taste_description || R2.taste_description || "alchemical essence"
			
			// Blend alpha (transparency)
			if(isnum(R1.alpha) && isnum(R2.alpha))
				mixed.alpha = round((R1.alpha + R2.alpha) / 2)
			
			// Add the mixed extract (2 reagents → 1 potion, so half the amount)
			add_reagent_data(mixed, convert_amount * 0.5)
			
			// Notify
			if(istype(my_atom, /obj/item/reagent_containers))
				my_atom.visible_message("<span class='notice'>[my_atom] bubbles as the reagents combine into a potion!</span>")
			
			return TRUE
	
	return FALSE

// Helper to add a reagent with custom data (used for dynamic alchemy mixing)
/datum/reagents/proc/add_reagent_data(datum/reagent/R, amount)
	if(!R || amount <= 0)
		return
	
	// Check if we already have this reagent type
	var/datum/reagent/existing = has_reagent(R.type)
	if(existing)
		existing.volume += amount
		if(R.alchemy_effects && R.alchemy_effects.len)
			// Merge effects if they're not already present
			if(!existing.alchemy_effects)
				existing.alchemy_effects = list()
			for(var/effect in R.alchemy_effects)
				if(!(effect in existing.alchemy_effects))
					existing.alchemy_effects += effect
	else
		// Add new reagent
		R.volume = amount
		R.holder = src
		reagent_list += R
		if(R.alchemy_effects && R.alchemy_effects.len)
			R.alchemy_effects = R.alchemy_effects.Copy()
	
	update_total()
	my_atom?.on_reagent_change(ADD_REAGENT)
	handle_reactions()
	return TRUE
