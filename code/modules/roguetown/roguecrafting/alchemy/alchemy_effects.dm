// Elder Scrolls-style Alchemy Effect System
// Each reagent has a list of effects that can be discovered through combination

// Alchemy effect types - MASSIVELY EXPANDED (72 base effects + 72 GREATER variants = 144 total)

// Original 21 Effects
#define EFFECT_HEAL_BRUTE "heal_brute"
#define EFFECT_HEAL_BURN "heal_burn"
#define EFFECT_HEAL_TOX "heal_toxin"
#define EFFECT_RESTORE_STAMINA "restore_stamina"
#define EFFECT_RESTORE_ENERGY "restore_energy"
#define EFFECT_RESTORE_BLOOD "restore_blood"
#define EFFECT_FORTIFY_STRENGTH "fortify_strength"
#define EFFECT_FORTIFY_PERCEPTION "fortify_perception"
#define EFFECT_FORTIFY_INTELLIGENCE "fortify_intelligence"
#define EFFECT_FORTIFY_CONSTITUTION "fortify_constitution"
#define EFFECT_FORTIFY_ENDURANCE "fortify_endurance"
#define EFFECT_FORTIFY_SPEED "fortify_speed"
#define EFFECT_FORTIFY_LUCK "fortify_luck"
#define EFFECT_PARALYZE "paralyze"
#define EFFECT_BLINDNESS "blindness"
#define EFFECT_SILENCE "silence"
#define EFFECT_SLOW "slow"
#define EFFECT_WEAKNESS "weakness"
#define EFFECT_POISON "poison"
#define EFFECT_DAMAGE_STAMINA "damage_stamina"
#define EFFECT_DAMAGE_ENERGY "damage_energy"

// Fire/Frost/Elemental Effects (12 new)
#define EFFECT_FIRE_STACKS "fire_stacks"
#define EFFECT_FROST_SLOW "frost_slow"
#define EFFECT_SHOCK_DAMAGE "shock_damage"
#define EFFECT_ACID_BURN "acid_burn"
#define EFFECT_HEAT_RESISTANCE "heat_resistance"
#define EFFECT_COLD_RESISTANCE "cold_resistance"
#define EFFECT_FIRE_IMMUNITY "fire_immunity"
#define EFFECT_FROST_IMMUNITY "frost_immunity"
#define EFFECT_ELECTRIC_RESISTANCE "electric_resistance"
#define EFFECT_ACID_RESISTANCE "acid_resistance"
#define EFFECT_MAGIC_RESISTANCE "magic_resistance"
#define EFFECT_PHYSICAL_RESISTANCE "physical_resistance"

// Trait-Based Buffs (15 new)
#define EFFECT_IRON_STOMACH "iron_stomach"
#define EFFECT_KEEN_SENSES "keen_senses"
#define EFFECT_SILENT_STEP "silent_step"
#define EFFECT_SURE_FOOTED "sure_footed"
#define EFFECT_QUICK_HANDS "quick_hands"
#define EFFECT_THICK_SKIN "thick_skin"
#define EFFECT_REGENERATE_ALL "regenerate_all"
#define EFFECT_BLOOD_REGENERATION "blood_regeneration"
#define EFFECT_STAMINA_REGENERATION "stamina_regeneration"
#define EFFECT_CLARITY "clarity"
#define EFFECT_NIGHT_VISION "night_vision"
#define EFFECT_WATER_BREATHING "water_breathing"
#define EFFECT_FEATHER_FALL "feather_fall"
#define EFFECT_POISON_IMMUNITY "poison_immunity"
#define EFFECT_DISEASE_IMMUNITY "disease_immunity"

// Combat Effects (10 new)
#define EFFECT_BATTLE_FURY "battle_fury"
#define EFFECT_CRITICAL_STRIKE "critical_strike"
#define EFFECT_ARMOR_PENETRATION "armor_penetration"
#define EFFECT_RIPOSTE "riposte"
#define EFFECT_LAST_STAND "last_stand"
#define EFFECT_BERSERK "berserk"
#define EFFECT_ADRENALINE "adrenaline"
#define EFFECT_WEAPON_DAMAGE "weapon_damage"
#define EFFECT_SPELL_POWER "spell_power"
#define EFFECT_DODGE_CHANCE "dodge_chance"

// Debuffs (8 new)
#define EFFECT_CONFUSION "confusion"
#define EFFECT_FEAR "fear"
#define EFFECT_DISEASE "disease"
#define EFFECT_CURSE "curse"
#define EFFECT_NAUSEA "nausea"
#define EFFECT_BLEEDING "bleeding"
#define EFFECT_CRIPPLE "cripple"
#define EFFECT_VULNERABILITY "vulnerability"

// Special Effects (6 new)
#define EFFECT_INVISIBILITY "invisibility"
#define EFFECT_LEVITATE "levitate"
#define EFFECT_HASTE "haste"
#define EFFECT_DETECT_MAGIC "detect_magic"
#define EFFECT_TRANSMUTE "transmute"
#define EFFECT_SUMMON_FAMILIAR "summon_familiar"

// GREATER Effect Variants (for concentrated/advanced extracts)
// Original 21
#define EFFECT_GREATER_HEAL_BRUTE "greater_heal_brute"
#define EFFECT_GREATER_HEAL_BURN "greater_heal_burn"
#define EFFECT_GREATER_HEAL_TOX "greater_heal_toxin"
#define EFFECT_GREATER_RESTORE_STAMINA "greater_restore_stamina"
#define EFFECT_GREATER_RESTORE_ENERGY "greater_restore_energy"
#define EFFECT_GREATER_RESTORE_BLOOD "greater_restore_blood"
#define EFFECT_GREATER_FORTIFY_STRENGTH "greater_fortify_strength"
#define EFFECT_GREATER_FORTIFY_PERCEPTION "greater_fortify_perception"
#define EFFECT_GREATER_FORTIFY_INTELLIGENCE "greater_fortify_intelligence"
#define EFFECT_GREATER_FORTIFY_CONSTITUTION "greater_fortify_constitution"
#define EFFECT_GREATER_FORTIFY_ENDURANCE "greater_fortify_endurance"
#define EFFECT_GREATER_FORTIFY_SPEED "greater_fortify_speed"
#define EFFECT_GREATER_FORTIFY_LUCK "greater_fortify_luck"
#define EFFECT_GREATER_PARALYZE "greater_paralyze"
#define EFFECT_GREATER_BLINDNESS "greater_blindness"
#define EFFECT_GREATER_SILENCE "greater_silence"
#define EFFECT_GREATER_SLOW "greater_slow"
#define EFFECT_GREATER_WEAKNESS "greater_weakness"
#define EFFECT_GREATER_POISON "greater_poison"
#define EFFECT_GREATER_DAMAGE_STAMINA "greater_damage_stamina"
#define EFFECT_GREATER_DAMAGE_ENERGY "greater_damage_energy"

// Fire/Frost/Elemental GREATER
#define EFFECT_GREATER_FIRE_STACKS "greater_fire_stacks"
#define EFFECT_GREATER_FROST_SLOW "greater_frost_slow"
#define EFFECT_GREATER_SHOCK_DAMAGE "greater_shock_damage"
#define EFFECT_GREATER_ACID_BURN "greater_acid_burn"
#define EFFECT_GREATER_HEAT_RESISTANCE "greater_heat_resistance"
#define EFFECT_GREATER_COLD_RESISTANCE "greater_cold_resistance"
#define EFFECT_GREATER_FIRE_IMMUNITY "greater_fire_immunity"
#define EFFECT_GREATER_FROST_IMMUNITY "greater_frost_immunity"
#define EFFECT_GREATER_ELECTRIC_RESISTANCE "greater_electric_resistance"
#define EFFECT_GREATER_ACID_RESISTANCE "greater_acid_resistance"
#define EFFECT_GREATER_MAGIC_RESISTANCE "greater_magic_resistance"
#define EFFECT_GREATER_PHYSICAL_RESISTANCE "greater_physical_resistance"

// Trait-Based Buffs GREATER
#define EFFECT_GREATER_IRON_STOMACH "greater_iron_stomach"
#define EFFECT_GREATER_KEEN_SENSES "greater_keen_senses"
#define EFFECT_GREATER_SILENT_STEP "greater_silent_step"
#define EFFECT_GREATER_SURE_FOOTED "greater_sure_footed"
#define EFFECT_GREATER_QUICK_HANDS "greater_quick_hands"
#define EFFECT_GREATER_THICK_SKIN "greater_thick_skin"
#define EFFECT_GREATER_REGENERATE_ALL "greater_regenerate_all"
#define EFFECT_GREATER_BLOOD_REGENERATION "greater_blood_regeneration"
#define EFFECT_GREATER_STAMINA_REGENERATION "greater_stamina_regeneration"
#define EFFECT_GREATER_CLARITY "greater_clarity"
#define EFFECT_GREATER_NIGHT_VISION "greater_night_vision"
#define EFFECT_GREATER_WATER_BREATHING "greater_water_breathing"
#define EFFECT_GREATER_FEATHER_FALL "greater_feather_fall"
#define EFFECT_GREATER_POISON_IMMUNITY "greater_poison_immunity"
#define EFFECT_GREATER_DISEASE_IMMUNITY "greater_disease_immunity"

// Combat Effects GREATER
#define EFFECT_GREATER_BATTLE_FURY "greater_battle_fury"
#define EFFECT_GREATER_CRITICAL_STRIKE "greater_critical_strike"
#define EFFECT_GREATER_ARMOR_PENETRATION "greater_armor_penetration"
#define EFFECT_GREATER_RIPOSTE "greater_riposte"
#define EFFECT_GREATER_LAST_STAND "greater_last_stand"
#define EFFECT_GREATER_BERSERK "greater_berserk"
#define EFFECT_GREATER_ADRENALINE "greater_adrenaline"
#define EFFECT_GREATER_WEAPON_DAMAGE "greater_weapon_damage"
#define EFFECT_GREATER_SPELL_POWER "greater_spell_power"
#define EFFECT_GREATER_DODGE_CHANCE "greater_dodge_chance"

// Debuffs GREATER
#define EFFECT_GREATER_CONFUSION "greater_confusion"
#define EFFECT_GREATER_FEAR "greater_fear"
#define EFFECT_GREATER_DISEASE "greater_disease"
#define EFFECT_GREATER_CURSE "greater_curse"
#define EFFECT_GREATER_NAUSEA "greater_nausea"
#define EFFECT_GREATER_BLEEDING "greater_bleeding"
#define EFFECT_GREATER_CRIPPLE "greater_cripple"
#define EFFECT_GREATER_VULNERABILITY "greater_vulnerability"

// Special Effects GREATER
#define EFFECT_GREATER_INVISIBILITY "greater_invisibility"
#define EFFECT_GREATER_LEVITATE "greater_levitate"
#define EFFECT_GREATER_HASTE "greater_haste"
#define EFFECT_GREATER_DETECT_MAGIC "greater_detect_magic"
#define EFFECT_GREATER_TRANSMUTE "greater_transmute"
#define EFFECT_GREATER_SUMMON_FAMILIAR "greater_summon_familiar"

// Global map: normal effect → GREATER effect
GLOBAL_LIST_INIT(alchemy_effect_greater_versions, list(
	EFFECT_HEAL_BRUTE = EFFECT_GREATER_HEAL_BRUTE,
	EFFECT_HEAL_BURN = EFFECT_GREATER_HEAL_BURN,
	EFFECT_HEAL_TOX = EFFECT_GREATER_HEAL_TOX,
	EFFECT_RESTORE_STAMINA = EFFECT_GREATER_RESTORE_STAMINA,
	EFFECT_RESTORE_ENERGY = EFFECT_GREATER_RESTORE_ENERGY,
	EFFECT_RESTORE_BLOOD = EFFECT_GREATER_RESTORE_BLOOD,
	EFFECT_FORTIFY_STRENGTH = EFFECT_GREATER_FORTIFY_STRENGTH,
	EFFECT_FORTIFY_PERCEPTION = EFFECT_GREATER_FORTIFY_PERCEPTION,
	EFFECT_FORTIFY_INTELLIGENCE = EFFECT_GREATER_FORTIFY_INTELLIGENCE,
	EFFECT_FORTIFY_CONSTITUTION = EFFECT_GREATER_FORTIFY_CONSTITUTION,
	EFFECT_FORTIFY_ENDURANCE = EFFECT_GREATER_FORTIFY_ENDURANCE,
	EFFECT_FORTIFY_SPEED = EFFECT_GREATER_FORTIFY_SPEED,
	EFFECT_FORTIFY_LUCK = EFFECT_GREATER_FORTIFY_LUCK,
	EFFECT_PARALYZE = EFFECT_GREATER_PARALYZE,
	EFFECT_BLINDNESS = EFFECT_GREATER_BLINDNESS,
	EFFECT_SILENCE = EFFECT_GREATER_SILENCE,
	EFFECT_SLOW = EFFECT_GREATER_SLOW,
	EFFECT_WEAKNESS = EFFECT_GREATER_WEAKNESS,
	EFFECT_POISON = EFFECT_GREATER_POISON,
	EFFECT_DAMAGE_STAMINA = EFFECT_GREATER_DAMAGE_STAMINA,
	EFFECT_DAMAGE_ENERGY = EFFECT_GREATER_DAMAGE_ENERGY,
	EFFECT_FIRE_STACKS = EFFECT_GREATER_FIRE_STACKS,
	EFFECT_FROST_SLOW = EFFECT_GREATER_FROST_SLOW,
	EFFECT_SHOCK_DAMAGE = EFFECT_GREATER_SHOCK_DAMAGE,
	EFFECT_ACID_BURN = EFFECT_GREATER_ACID_BURN,
	EFFECT_HEAT_RESISTANCE = EFFECT_GREATER_HEAT_RESISTANCE,
	EFFECT_COLD_RESISTANCE = EFFECT_GREATER_COLD_RESISTANCE,
	EFFECT_FIRE_IMMUNITY = EFFECT_GREATER_FIRE_IMMUNITY,
	EFFECT_FROST_IMMUNITY = EFFECT_GREATER_FROST_IMMUNITY,
	EFFECT_ELECTRIC_RESISTANCE = EFFECT_GREATER_ELECTRIC_RESISTANCE,
	EFFECT_ACID_RESISTANCE = EFFECT_GREATER_ACID_RESISTANCE,
	EFFECT_MAGIC_RESISTANCE = EFFECT_GREATER_MAGIC_RESISTANCE,
	EFFECT_PHYSICAL_RESISTANCE = EFFECT_GREATER_PHYSICAL_RESISTANCE,
	EFFECT_IRON_STOMACH = EFFECT_GREATER_IRON_STOMACH,
	EFFECT_KEEN_SENSES = EFFECT_GREATER_KEEN_SENSES,
	EFFECT_SILENT_STEP = EFFECT_GREATER_SILENT_STEP,
	EFFECT_SURE_FOOTED = EFFECT_GREATER_SURE_FOOTED,
	EFFECT_QUICK_HANDS = EFFECT_GREATER_QUICK_HANDS,
	EFFECT_THICK_SKIN = EFFECT_GREATER_THICK_SKIN,
	EFFECT_REGENERATE_ALL = EFFECT_GREATER_REGENERATE_ALL,
	EFFECT_BLOOD_REGENERATION = EFFECT_GREATER_BLOOD_REGENERATION,
	EFFECT_STAMINA_REGENERATION = EFFECT_GREATER_STAMINA_REGENERATION,
	EFFECT_CLARITY = EFFECT_GREATER_CLARITY,
	EFFECT_NIGHT_VISION = EFFECT_GREATER_NIGHT_VISION,
	EFFECT_WATER_BREATHING = EFFECT_GREATER_WATER_BREATHING,
	EFFECT_FEATHER_FALL = EFFECT_GREATER_FEATHER_FALL,
	EFFECT_POISON_IMMUNITY = EFFECT_GREATER_POISON_IMMUNITY,
	EFFECT_DISEASE_IMMUNITY = EFFECT_GREATER_DISEASE_IMMUNITY,
	EFFECT_BATTLE_FURY = EFFECT_GREATER_BATTLE_FURY,
	EFFECT_CRITICAL_STRIKE = EFFECT_GREATER_CRITICAL_STRIKE,
	EFFECT_ARMOR_PENETRATION = EFFECT_GREATER_ARMOR_PENETRATION,
	EFFECT_RIPOSTE = EFFECT_GREATER_RIPOSTE,
	EFFECT_LAST_STAND = EFFECT_GREATER_LAST_STAND,
	EFFECT_BERSERK = EFFECT_GREATER_BERSERK,
	EFFECT_ADRENALINE = EFFECT_GREATER_ADRENALINE,
	EFFECT_WEAPON_DAMAGE = EFFECT_GREATER_WEAPON_DAMAGE,
	EFFECT_SPELL_POWER = EFFECT_GREATER_SPELL_POWER,
	EFFECT_DODGE_CHANCE = EFFECT_GREATER_DODGE_CHANCE,
	EFFECT_CONFUSION = EFFECT_GREATER_CONFUSION,
	EFFECT_FEAR = EFFECT_GREATER_FEAR,
	EFFECT_DISEASE = EFFECT_GREATER_DISEASE,
	EFFECT_CURSE = EFFECT_GREATER_CURSE,
	EFFECT_NAUSEA = EFFECT_GREATER_NAUSEA,
	EFFECT_BLEEDING = EFFECT_GREATER_BLEEDING,
	EFFECT_CRIPPLE = EFFECT_GREATER_CRIPPLE,
	EFFECT_VULNERABILITY = EFFECT_GREATER_VULNERABILITY,
	EFFECT_INVISIBILITY = EFFECT_GREATER_INVISIBILITY,
	EFFECT_LEVITATE = EFFECT_GREATER_LEVITATE,
	EFFECT_HASTE = EFFECT_GREATER_HASTE,
	EFFECT_DETECT_MAGIC = EFFECT_GREATER_DETECT_MAGIC,
	EFFECT_TRANSMUTE = EFFECT_GREATER_TRANSMUTE,
	EFFECT_SUMMON_FAMILIAR = EFFECT_GREATER_SUMMON_FAMILIAR
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
	EFFECT_HEAL_BURN = "soothing balm",
	EFFECT_HEAL_TOX = "purity",
	EFFECT_RESTORE_STAMINA = "fresh air",
	EFFECT_RESTORE_ENERGY = "clean air",
	EFFECT_RESTORE_BLOOD = "iron and life",
	EFFECT_FORTIFY_STRENGTH = "power",
	EFFECT_FORTIFY_PERCEPTION = "sharp clarity",
	EFFECT_FORTIFY_INTELLIGENCE = "arcane essence",
	EFFECT_FORTIFY_CONSTITUTION = "mountain air",
	EFFECT_FORTIFY_ENDURANCE = "earth",
	EFFECT_FORTIFY_SPEED = "a swift breeze",
	EFFECT_FORTIFY_LUCK = "fortune",
	EFFECT_PARALYZE = "stagnant air",
	EFFECT_BLINDNESS = "darkness",
	EFFECT_SILENCE = "muffled void",
	EFFECT_SLOW = "thick molasses",
	EFFECT_WEAKNESS = "decay",
	EFFECT_POISON = "death",
	EFFECT_DAMAGE_STAMINA = "exhaustion",
	EFFECT_DAMAGE_ENERGY = "draining cold",
	EFFECT_FIRE_STACKS = "burning embers",
	EFFECT_FROST_SLOW = "icy chill",
	EFFECT_SHOCK_DAMAGE = "crackling lightning",
	EFFECT_ACID_BURN = "caustic fumes",
	EFFECT_HEAT_RESISTANCE = "warm protection",
	EFFECT_COLD_RESISTANCE = "cool shield",
	EFFECT_FIRE_IMMUNITY = "flame ward",
	EFFECT_FROST_IMMUNITY = "frost ward",
	EFFECT_ELECTRIC_RESISTANCE = "static barrier",
	EFFECT_ACID_RESISTANCE = "neutralizing aura",
	EFFECT_MAGIC_RESISTANCE = "arcane ward",
	EFFECT_PHYSICAL_RESISTANCE = "iron skin",
	EFFECT_IRON_STOMACH = "digestive fortitude",
	EFFECT_KEEN_SENSES = "heightened awareness",
	EFFECT_SILENT_STEP = "hushed movement",
	EFFECT_SURE_FOOTED = "steady balance",
	EFFECT_QUICK_HANDS = "nimble fingers",
	EFFECT_THICK_SKIN = "hardened flesh",
	EFFECT_REGENERATE_ALL = "renewal",
	EFFECT_BLOOD_REGENERATION = "blood renewal",
	EFFECT_STAMINA_REGENERATION = "enduring breath",
	EFFECT_CLARITY = "clear mind",
	EFFECT_NIGHT_VISION = "cat's eyes",
	EFFECT_WATER_BREATHING = "fish lungs",
	EFFECT_FEATHER_FALL = "soft landing",
	EFFECT_POISON_IMMUNITY = "toxin ward",
	EFFECT_DISEASE_IMMUNITY = "disease ward",
	EFFECT_BATTLE_FURY = "war rage",
	EFFECT_CRITICAL_STRIKE = "lethal precision",
	EFFECT_ARMOR_PENETRATION = "piercing might",
	EFFECT_RIPOSTE = "defensive counter",
	EFFECT_LAST_STAND = "desperate strength",
	EFFECT_BERSERK = "feral rage",
	EFFECT_ADRENALINE = "rushing energy",
	EFFECT_WEAPON_DAMAGE = "keen edge",
	EFFECT_SPELL_POWER = "arcane might",
	EFFECT_DODGE_CHANCE = "elusive grace",
	EFFECT_CONFUSION = "muddled thoughts",
	EFFECT_FEAR = "creeping dread",
	EFFECT_DISEASE = "festering sickness",
	EFFECT_CURSE = "dark hex",
	EFFECT_NAUSEA = "roiling stomach",
	EFFECT_BLEEDING = "flowing blood",
	EFFECT_CRIPPLE = "broken movement",
	EFFECT_VULNERABILITY = "exposed weakness",
	EFFECT_INVISIBILITY = "unseen presence",
	EFFECT_LEVITATE = "weightless float",
	EFFECT_HASTE = "quickened time",
	EFFECT_DETECT_MAGIC = "mystic sight",
	EFFECT_TRANSMUTE = "matter change",
	EFFECT_SUMMON_FAMILIAR = "spirit calling"
))

// Global associative list mapping effects to paired words [adjective, noun] for potion naming
GLOBAL_LIST_INIT(alchemy_effect_words, list(
	EFFECT_HEAL_BRUTE = list("mending", "heal"),
	EFFECT_HEAL_BURN = list("soothing", "balm"),
	EFFECT_HEAL_TOX = list("curing", "antidote"),
	EFFECT_RESTORE_STAMINA = list("energizing", "vigor"),
	EFFECT_RESTORE_ENERGY = list("invigorating", "essence"),
	EFFECT_RESTORE_BLOOD = list("vital", "fluid"),
	EFFECT_FORTIFY_STRENGTH = list("mighty", "power"),
	EFFECT_FORTIFY_PERCEPTION = list("keen", "sight"),
	EFFECT_FORTIFY_INTELLIGENCE = list("brilliant", "mind"),
	EFFECT_FORTIFY_CONSTITUTION = list("hardy", "body"),
	EFFECT_FORTIFY_ENDURANCE = list("enduring", "fortitude"),
	EFFECT_FORTIFY_SPEED = list("swift", "motion"),
	EFFECT_FORTIFY_LUCK = list("fortunate", "blessing"),
	EFFECT_PARALYZE = list("binding", "lock"),
	EFFECT_BLINDNESS = list("darkening", "shadow"),
	EFFECT_SILENCE = list("muting", "silence"),
	EFFECT_SLOW = list("sluggish", "draught"),
	EFFECT_WEAKNESS = list("enfeebling", "curse"),
	EFFECT_POISON = list("toxic", "venom"),
	EFFECT_DAMAGE_STAMINA = list("draining", "fatigue"),
	EFFECT_DAMAGE_ENERGY = list("exhausting", "drain"),
	EFFECT_FIRE_STACKS = list("blazing", "inferno"),
	EFFECT_FROST_SLOW = list("freezing", "frost"),
	EFFECT_SHOCK_DAMAGE = list("crackling", "lightning"),
	EFFECT_ACID_BURN = list("caustic", "acid"),
	EFFECT_HEAT_RESISTANCE = list("warming", "shield"),
	EFFECT_COLD_RESISTANCE = list("cooling", "ward"),
	EFFECT_FIRE_IMMUNITY = list("fireproof", "protection"),
	EFFECT_FROST_IMMUNITY = list("frostproof", "guard"),
	EFFECT_BATTLE_FURY = list("raging", "fury"),
	EFFECT_CRITICAL_STRIKE = list("deadly", "strike"),
	EFFECT_ARMOR_PENETRATION = list("piercing", "edge"),
	EFFECT_RIPOSTE = list("counter", "parry"),
	EFFECT_BERSERK = list("frenzied", "rage"),
	EFFECT_INVISIBILITY = list("unseen", "cloak"),
	EFFECT_HASTE = list("quickened", "speed"),
	EFFECT_CONFUSION = list("muddled", "confusion"),
	EFFECT_FEAR = list("terrifying", "dread"),
	EFFECT_NAUSEA = list("sickening", "nausea"),
	EFFECT_BLEEDING = list("hemorrhaging", "blood")
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
