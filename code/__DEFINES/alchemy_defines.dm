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
#define EFFECT_NAUSEA "nausea"

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
#define EFFECT_GREATER_NAUSEA "greater_nausea"

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
	EFFECT_NAUSEA = EFFECT_GREATER_NAUSEA,
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
	EFFECT_HEAL_BRUTE = "herbal",
	EFFECT_HEAL_BURN = "oniony",
	EFFECT_HEAL_TOX = "medicinal",
	EFFECT_RESTORE_STAMINA = "fresh",
	EFFECT_RESTORE_MANA = "crisp",
	EFFECT_RESTORE_BLOOD = "iron-rich",
	EFFECT_RESTORE_DEVOTION = "sacred",
	EFFECT_DAMAGE_BRUTE = "pungent",
	EFFECT_DAMAGE_BURN = "charred",
	EFFECT_DAMAGE_TOX = "rotten",
	EFFECT_DRAIN_STAMINA = "uric",
	EFFECT_DRAIN_MANA = "stale",
	EFFECT_DRAIN_BLOOD = "oxidized",
	EFFECT_DRAIN_DEVOTION = "vile",
	EFFECT_FORTIFY_STRENGTH = "strong",
	EFFECT_FORTIFY_PERCEPTION = "sharp",
	EFFECT_FORTIFY_INTELLIGENCE = "floral",
	EFFECT_FORTIFY_CONSTITUTION = "earthy",
	EFFECT_FORTIFY_ENDURANCE = "oaken",
	EFFECT_FORTIFY_SPEED = "fleeting",
	EFFECT_FORTIFY_LUCK = "sweet",
	EFFECT_WEAKEN_STRENGTH = "weak",
	EFFECT_WEAKEN_PERCEPTION = "musty",
	EFFECT_WEAKEN_INTELLIGENCE = "bitter",
	EFFECT_WEAKEN_CONSTITUTION = "mildewy",
	EFFECT_WEAKEN_ENDURANCE = "dry",
	EFFECT_WEAKEN_SPEED = "flat",
	EFFECT_WEAKEN_LUCK = "sour",
	EFFECT_BLINDNESS = "smoky",
	EFFECT_SILENCE = "muted",
	EFFECT_DEAFEN = "dull",
	EFFECT_NO_PAIN = "bland",
	EFFECT_WEAKNESS = "faint",
	EFFECT_INVISIBILITY = "airy",
	EFFECT_NAUSEA = "fecal",
	EFFECT_MAGIC_RESIST = "ozone-like",
	EFFECT_CRIT_RESIST = "musky",
	EFFECT_FEATHER_FALL = "light",
	EFFECT_FIRE_IMMUNE = "warm",
	EFFECT_FROST_IMMUNE = "cool",
	EFFECT_FIRE_STACKS = "spicy",
	EFFECT_FROST_STACKS = "minty",
	EFFECT_SHOCK_DAMAGE = "citrusy",
	EFFECT_GREATER_HEAL_BRUTE = "herbaceous",
	EFFECT_GREATER_HEAL_BURN = "acrid",
	EFFECT_GREATER_HEAL_TOX = "antiseptic",
	EFFECT_GREATER_RESTORE_STAMINA = "invigorating",
	EFFECT_GREATER_RESTORE_MANA = "piercing",
	EFFECT_GREATER_RESTORE_BLOOD = "ferrous",
	EFFECT_GREATER_RESTORE_DEVOTION = "hallowed",
	EFFECT_GREATER_DAMAGE_BRUTE = "noxious",
	EFFECT_GREATER_DAMAGE_BURN = "scorched",
	EFFECT_GREATER_DAMAGE_TOX = "putrid",
	EFFECT_GREATER_DRAIN_STAMINA = "ammoniac",
	EFFECT_GREATER_DRAIN_MANA = "rancid",
	EFFECT_GREATER_DRAIN_BLOOD = "rusted",
	EFFECT_GREATER_DRAIN_DEVOTION = "profane",
	EFFECT_GREATER_FORTIFY_STRENGTH = "potent",
	EFFECT_GREATER_FORTIFY_PERCEPTION = "razor-sharp",
	EFFECT_GREATER_FORTIFY_INTELLIGENCE = "fragrant",
	EFFECT_GREATER_FORTIFY_CONSTITUTION = "loamy",
	EFFECT_GREATER_FORTIFY_ENDURANCE = "timbered",
	EFFECT_GREATER_FORTIFY_SPEED = "fleeting",
	EFFECT_GREATER_FORTIFY_LUCK = "cloying",
	EFFECT_GREATER_WEAKEN_STRENGTH = "feeble",
	EFFECT_GREATER_WEAKEN_PERCEPTION = "moldered",
	EFFECT_GREATER_WEAKEN_INTELLIGENCE = "caustic",
	EFFECT_GREATER_WEAKEN_CONSTITUTION = "withered",
	EFFECT_GREATER_WEAKEN_ENDURANCE = "arid",
	EFFECT_GREATER_WEAKEN_SPEED = "insipid",
	EFFECT_GREATER_WEAKEN_LUCK = "acerbic",
	EFFECT_GREATER_BLINDNESS = "sooty",
	EFFECT_GREATER_SILENCE = "deadened",
	EFFECT_GREATER_DEAFEN = "muffled",
	EFFECT_GREATER_NO_PAIN = "tasteless",
	EFFECT_GREATER_WEAKNESS = "wan",
	EFFECT_GREATER_INVISIBILITY = "ethereal",
	EFFECT_GREATER_NAUSEA = "feculent",
	EFFECT_GREATER_MAGIC_RESIST = "ozonic",
	EFFECT_GREATER_CRIT_RESIST = "animalic",
	EFFECT_GREATER_FEATHER_FALL = "weightless",
	EFFECT_GREATER_FIRE_IMMUNE = "searing",
	EFFECT_GREATER_FROST_IMMUNE = "gelid",
	EFFECT_GREATER_FIRE_STACKS = "fiery",
	EFFECT_GREATER_FROST_STACKS = "icy",
	EFFECT_GREATER_SHOCK_DAMAGE = "zingy"
))

// Global associative list mapping effects to paired words [adjective, noun] for potion naming
GLOBAL_LIST_INIT(alchemy_effect_words, list(
	EFFECT_HEAL_BRUTE = list("mending", "heal"),
	EFFECT_HEAL_BURN = list("soothing", "balm"),
	EFFECT_HEAL_TOX = list("curing", "antidote"),
	EFFECT_RESTORE_STAMINA = list("energizing", "vigor"),
	EFFECT_RESTORE_MANA = list("invigorating", "essence"),
	EFFECT_RESTORE_BLOOD = list("engorging", "fluid"),
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
	EFFECT_NAUSEA = list("nauseating", "retch"),
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
	EFFECT_GREATER_NAUSEA = list("nauseating", "greater retch"),
	EFFECT_GREATER_MAGIC_RESIST = list("warding", "greater aegis"),
	EFFECT_GREATER_CRIT_RESIST = list("fortified", "greater guard"),
	EFFECT_GREATER_FEATHER_FALL = list("floating", "greater descent"),
	EFFECT_GREATER_FIRE_IMMUNE = list("fireproof", "greater fire ward"),
	EFFECT_GREATER_FROST_IMMUNE = list("frostproof", "greater frost ward"),
	EFFECT_GREATER_ELECTRIC_IMMUNE = list("grounding", "greater shock ward"),
	EFFECT_GREATER_FIRE_STACKS = list("blazing", "greater inferno"),
	EFFECT_GREATER_FROST_STACKS = list("freezing", "greater frost"),
	EFFECT_GREATER_SHOCK_DAMAGE = list("crackling", "greater lightning")
))
