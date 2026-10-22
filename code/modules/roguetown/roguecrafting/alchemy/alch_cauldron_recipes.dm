/datum/alch_cauldron_recipe/health_potion
	name = "Elixir of Health I"
	skill_required = SKILL_LEVEL_APPRENTICE
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_RED = 2)
	output_reagents = list(/datum/reagent/medicine/healthpot = 100)

/datum/alch_cauldron_recipe/big_health_potion
	name = "Elixir of Health II"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_RED = 4)
	output_reagents = list(/datum/reagent/medicine/stronghealth = 50)

/datum/alch_cauldron_recipe/antidote
	name = "Antidote I"
	skill_required = SKILL_LEVEL_APPRENTICE
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_GREEN = 2)
	output_reagents = list(/datum/reagent/medicine/antidote = 100)

/datum/alch_cauldron_recipe/strong_antidote
	name = "Antidote II"
	skill_required = SKILL_LEVEL_JOURNEYMAN
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_GREEN = 4)
	output_reagents = list(/datum/reagent/medicine/strong_antidote = 100)

/datum/alch_cauldron_recipe/mana_potion
	name = "Elixir of Mana I"
	skill_required = SKILL_LEVEL_APPRENTICE
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_BLUE = 2)
	output_reagents = list(/datum/reagent/medicine/manapot = 100)

/datum/alch_cauldron_recipe/big_mana_potion
	name = "Elixir of Mana II"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_BLUE = 4)
	output_reagents = list(/datum/reagent/medicine/strongmana = 100)

/datum/alch_cauldron_recipe/spd_potion
	name = "Potion of Fleet Foot"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_GREEN = 3, ALCH_RUNE_BLUE = 2)
	output_reagents = list(/datum/reagent/buff/speed = 30)

/datum/alch_cauldron_recipe/lck_potion
	name = "Potion of Seven Clovers"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_RED = 2, ALCH_RUNE_GREEN = 2, ALCH_RUNE_BLUE = 2)
	output_reagents = list(/datum/reagent/buff/fortune = 30)

/datum/alch_cauldron_recipe/str_potion
	name = "Potion of Mountain Muscles"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/consumable/ethanol/wine
	required_runes = list(ALCH_RUNE_RED = 4, ALCH_RUNE_BLUE = 1)
	output_reagents = list(/datum/reagent/buff/strength = 30)

/datum/alch_cauldron_recipe/berrypoison
	name = "Berry Poison"
	skill_required = SKILL_LEVEL_JOURNEYMAN
	required_base = /datum/reagent/consumable/ethanol/wine
	required_runes = list(ALCH_RUNE_RED = 1, ALCH_RUNE_GREEN = 2)
	output_reagents = list(/datum/reagent/berrypoison = 100)

/datum/alch_cauldron_recipe/stam_poison
	name = "Stamina Poison"
	skill_required = SKILL_LEVEL_JOURNEYMAN
	required_base = /datum/reagent/consumable/ethanol/wine
	required_runes = list(ALCH_RUNE_GREEN = 2, ALCH_RUNE_BLUE = 1)
	output_reagents = list(/datum/reagent/stampoison = 100)

/datum/alch_cauldron_recipe/big_stam_poison
	name = "Strong Stamina Poison"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/consumable/ethanol/wine
	required_runes = list(ALCH_RUNE_RED = 1, ALCH_RUNE_GREEN = 3, ALCH_RUNE_BLUE = 1)
	output_reagents = list(/datum/reagent/strongstampoison = 100)

/datum/alch_cauldron_recipe/doompoison
	name = "Doom Poison"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/consumable/ethanol/wine
	required_runes = list(ALCH_RUNE_RED = 3, ALCH_RUNE_GREEN = 3)
	output_reagents = list(/datum/reagent/strongpoison = 100)

/datum/alch_cauldron_recipe/aphrodisiac
	name = "Aphrodisiac Wine"
	skill_required = SKILL_LEVEL_JOURNEYMAN
	required_base = /datum/reagent/consumable/ethanol/wine
	required_runes = list(ALCH_RUNE_RED = 3, ALCH_RUNE_GREEN = 1, ALCH_RUNE_BLUE = 1)
	output_reagents = list(/datum/reagent/consumable/ethanol/beer/emberwine = 60)

/datum/alch_cauldron_recipe/fire_potion
	name = "Potion of Fire Warding"
	skill_required = SKILL_LEVEL_MASTER
	required_base = /datum/reagent/consumable/ethanol/wine
	required_runes = list(ALCH_RUNE_RED = 4, ALCH_RUNE_BLUE = 4)
	output_reagents = list(/datum/reagent/fire_resist = 30)

/datum/alch_cauldron_recipe/stamina_potion
	name = "Elixir of Stamina I"
	skill_required = SKILL_LEVEL_APPRENTICE
	required_base = /datum/reagent/consumable/milk
	required_runes = list(ALCH_RUNE_RED = 1, ALCH_RUNE_GREEN = 1)
	output_reagents = list(/datum/reagent/medicine/stampot = 100)

/datum/alch_cauldron_recipe/big_stamina_potion
	name = "Elixir of Stamina II"
	skill_required = SKILL_LEVEL_JOURNEYMAN
	required_base = /datum/reagent/consumable/milk
	required_runes = list(ALCH_RUNE_RED = 2, ALCH_RUNE_GREEN = 2)
	output_reagents = list(/datum/reagent/medicine/strongstam = 100)

/datum/alch_cauldron_recipe/con_potion
	name = "Potion of Stone Flesh"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/consumable/milk
	required_runes = list(ALCH_RUNE_RED = 3, ALCH_RUNE_GREEN = 2)
	output_reagents = list(/datum/reagent/buff/constitution = 30)

/datum/alch_cauldron_recipe/end_potion
	name = "Potion of Enduring Fortitude"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/consumable/milk
	required_runes = list(ALCH_RUNE_RED = 2, ALCH_RUNE_GREEN = 3)
	output_reagents = list(/datum/reagent/buff/endurance = 30)

/datum/alch_cauldron_recipe/per_potion
	name = "Potion of Keen Eye"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/consumable/milk
	required_runes = list(ALCH_RUNE_RED = 1, ALCH_RUNE_BLUE = 4)
	output_reagents = list(/datum/reagent/buff/perception = 30)

/datum/alch_cauldron_recipe/int_potion
	name = "Potion of Keen Mind"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/consumable/milk
	required_runes = list(ALCH_RUNE_GREEN = 1, ALCH_RUNE_BLUE = 4)
	output_reagents = list(/datum/reagent/buff/intelligence = 30)

/datum/alch_cauldron_recipe/temp_potion
	name = "Potion of Equilibrium"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/consumable/milk
	required_runes = list(ALCH_RUNE_RED = 3, ALCH_RUNE_BLUE = 3)
	output_reagents = list(/datum/reagent/buff/temperature_normalize = 30)

/datum/alch_cauldron_recipe/mythic_recall
	name = "Chronowarp Tincture"
	skill_required = SKILL_LEVEL_JOURNEYMAN
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_BLUE = 3, ALCH_RUNE_RED = 1)
	output_reagents = list(/datum/reagent/magic/recall = 30)

/datum/alch_cauldron_recipe/mythic_transmutation
	name = "Beastblood Transmutagen"
	skill_required = SKILL_LEVEL_EXPERT
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_BLUE = 2, ALCH_RUNE_RED = 3, ALCH_RUNE_GREEN = 3)
	output_reagents = list(/datum/reagent/magic/transmutation = 30)

/datum/alch_cauldron_recipe/mythic_mimicry
	name = "Mirage Draught"
	skill_required = SKILL_LEVEL_MASTER
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_BLUE = 4, ALCH_RUNE_GREEN = 3, ALCH_RUNE_RED = 1)
	output_reagents = list(/datum/reagent/magic/mimicry = 30)

/datum/alch_cauldron_recipe/frankenbrew
	name = "Reanimation Elixir"
	skill_required = SKILL_LEVEL_MASTER
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_BLUE = 3, ALCH_RUNE_GREEN = 3, ALCH_RUNE_RED = 4)
	output_reagents = list(/datum/reagent/frankenbrew  = 48)

/datum/alch_cauldron_recipe/mythic_health
	name = "Elixir of Life III"
	skill_required = SKILL_LEVEL_MASTER
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_RED = 4)
	requires_rainbow = TRUE
	output_reagents = list(/datum/reagent/medicine/mythic/health = 60)

/datum/alch_cauldron_recipe/mythic_mana
	name = "Archon's Surge III"
	skill_required = SKILL_LEVEL_MASTER
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_BLUE = 4)
	requires_rainbow = TRUE
	output_reagents = list(/datum/reagent/medicine/mythic/mana = 60)

/datum/alch_cauldron_recipe/mythic_stamina
	name = "Endless Wind III"
	skill_required = SKILL_LEVEL_MASTER
	required_base = /datum/reagent/consumable/milk
	required_runes = list(ALCH_RUNE_RED = 2, ALCH_RUNE_GREEN = 2)
	requires_rainbow = TRUE
	output_reagents = list(/datum/reagent/medicine/mythic/stamina = 60)


/datum/alch_cauldron_recipe/mythic_antidote
	name = "Pestra's Cleansing III"
	skill_required = SKILL_LEVEL_MASTER
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_GREEN = 4)
	requires_rainbow = TRUE
	output_reagents = list(/datum/reagent/medicine/mythic/antidote = 60)

/datum/alch_cauldron_recipe/mythic_strength
	name = "Titan's Might III"
	skill_required = SKILL_LEVEL_MASTER
	required_base = /datum/reagent/consumable/ethanol/wine
	required_runes = list(ALCH_RUNE_RED = 4, ALCH_RUNE_BLUE = 1)
	requires_rainbow = TRUE
	output_reagents = list(/datum/reagent/medicine/mythic/strength = 40)

/datum/alch_cauldron_recipe/mythic_speed
	name = "Phantom Celerity III"
	skill_required = SKILL_LEVEL_MASTER
	required_base = /datum/reagent/water
	required_runes = list(ALCH_RUNE_GREEN = 3, ALCH_RUNE_BLUE = 2)
	requires_rainbow = TRUE
	output_reagents = list(/datum/reagent/medicine/mythic/speed = 40)

/datum/alch_cauldron_recipe/mythic_constitution
	name = "Adamantine Flesh III"
	skill_required = SKILL_LEVEL_MASTER
	required_base = /datum/reagent/consumable/milk
	required_runes = list(ALCH_RUNE_RED = 3, ALCH_RUNE_GREEN = 2)
	requires_rainbow = TRUE
	output_reagents = list(/datum/reagent/medicine/mythic/constitution = 40)

/datum/alch_cauldron_recipe/mythic_fire_resist
	name = "Infernal Sovereign III"
	skill_required = SKILL_LEVEL_MASTER
	required_base = /datum/reagent/consumable/ethanol/wine
	required_runes = list(ALCH_RUNE_RED = 4, ALCH_RUNE_BLUE = 4)
	requires_rainbow = TRUE
	output_reagents = list(/datum/reagent/medicine/mythic/fire_resist = 40)

/datum/alch_cauldron_recipe/mythic_poison
	name = "Venom of the Void III"
	skill_required = SKILL_LEVEL_MASTER
	required_base = /datum/reagent/consumable/ethanol/wine
	required_runes = list(ALCH_RUNE_RED = 3, ALCH_RUNE_GREEN = 3)
	requires_rainbow = TRUE
	output_reagents = list(/datum/reagent/medicine/mythic/strong_poison = 60)

