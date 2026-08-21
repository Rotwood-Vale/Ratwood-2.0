// Threat Point (TP) assignments for the quest kill-budget system (ported from AP #6849/#7000).
// AP declares threat_point on /mob/living and sets it across ~40 NPC files as part of its ambush
// budget system. ES never ported that system, so we introduce the var here and set it out-of-block
// on the ES mob roster, mirroring AP's tier values. A kill quest spends a tp_budget composing its
// warband; each mob's threat_point is its price. Subtypes inherit unless overridden below.
//
// Ratwood deviation: several AP mobs have no ES equivalent - the quest factions substitute those, so we
// only need TP on the ES paths the (substituted) factions actually reference. See threat_points
// tier ladder in code/__DEFINES/economy/regional_threat.dm.

/mob/living/var/threat_point = 0

// --- Greenskins -----------------------------------------------------------------------------
// Base goblin npc covers all ambush/cave/hell/moon/sea variants via inheritance.
/mob/living/carbon/human/species/goblin/npc/threat_point = THREAT_TRASH
/mob/living/carbon/human/species/orc/npc/footsoldier/threat_point = THREAT_HIGH
/mob/living/carbon/human/species/orc/npc/marauder/threat_point = THREAT_TOUGH
/mob/living/carbon/human/species/orc/npc/berserker/threat_point = THREAT_TOUGH
/mob/living/carbon/human/species/orc/npc/warlord/threat_point = THREAT_ELITE

// --- Drow -----------------------------------------------------------------------------------
/mob/living/carbon/human/species/elf/dark/drowraider/threat_point = THREAT_TOUGH

// --- Human outlaws / raiders / deserters ----------------------------------------------------
/mob/living/carbon/human/species/human/northern/highwayman/threat_point = THREAT_MODERATE
/mob/living/carbon/human/species/human/northern/searaider/threat_point = THREAT_MODERATE
/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/threat_point = THREAT_ELITE
/mob/living/carbon/human/species/human/northern/bog_deserters/threat_point = THREAT_DANGEROUS

// --- Skeletons (AP tunes each tier individually) --------------------------------------------
/mob/living/carbon/human/species/skeleton/npc/supereasy/threat_point = THREAT_LOW
/mob/living/carbon/human/species/skeleton/npc/easy/threat_point = THREAT_MODERATE
/mob/living/carbon/human/species/skeleton/npc/medium/threat_point = THREAT_LOW
/mob/living/carbon/human/species/skeleton/npc/mediumspread/threat_point = THREAT_MODERATE
/mob/living/carbon/human/species/skeleton/npc/hard/threat_point = THREAT_TOUGH
/mob/living/carbon/human/species/skeleton/npc/hardspread/threat_point = THREAT_TOUGH
/mob/living/carbon/human/species/skeleton/npc/bogguard/threat_point = THREAT_MODERATE
/mob/living/carbon/human/species/skeleton/npc/dungeon/lich/threat_point = THREAT_ELITE

// --- Wild beasts & creachers ----------------------------------------------------------------
/mob/living/simple_animal/hostile/retaliate/rogue/fox/threat_point = THREAT_TRASH
/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/threat_point = THREAT_TRASH
/mob/living/simple_animal/hostile/retaliate/rogue/wolf/threat_point = THREAT_LOW
/mob/living/simple_animal/hostile/retaliate/rogue/spider/threat_point = THREAT_LOW
/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated/threat_point = THREAT_HIGH
/mob/living/simple_animal/hostile/retaliate/rogue/mole/threat_point = THREAT_MODERATE
/mob/living/simple_animal/hostile/retaliate/rogue/mossback/threat_point = THREAT_MODERATE
/mob/living/simple_animal/hostile/retaliate/rogue/direbear/threat_point = THREAT_DANGEROUS
/mob/living/simple_animal/hostile/retaliate/rogue/troll/threat_point = THREAT_DANGEROUS
/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/threat_point = THREAT_DANGEROUS

// --- Elemental & infernal summons -----------------------------------------------------------
/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth/threat_point = 80
/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler/threat_point = 15
/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden/threat_point = 30
/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound/threat_point = THREAT_MODERATE
/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp/threat_point = THREAT_LOW
/mob/living/simple_animal/hostile/retaliate/rogue/infernal/watcher/threat_point = 70
