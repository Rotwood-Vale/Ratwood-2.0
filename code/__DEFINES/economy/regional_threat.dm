#define DANGER_SAFE_FLOOR 0
#define DANGER_SAFE_LIMIT 10
#define DANGER_LOW_FLOOR 11
#define DANGER_LOW_LIMIT 20
#define DANGER_MODERATE_FLOOR 21
#define DANGER_MODERATE_LIMIT 30
#define DANGER_DANGEROUS_FLOOR 31
#define DANGER_DANGEROUS_LIMIT 40
#define DANGER_DIRE_FLOOR 41
#define DANGER_DIRE_LIMIT 60
// Danger levels. Each danger level is defined as an ambush that can happen. Every time this fire, this number iterates.
#define DANGER_LEVEL_SAFE "Safe"
#define DANGER_LEVEL_LOW "Low"
#define DANGER_LEVEL_MODERATE "Moderate"
#define DANGER_LEVEL_DANGEROUS "Dangerous"
#define DANGER_LEVEL_BLEAK "Bleak"

#define THREAT_REGION_AZURE_BASIN "Rotwood Vale Basin"
#define THREAT_REGION_AZURE_GROVE "Rotwood Vale Grove"
#define THREAT_REGION_AZUREAN_COAST "Rotwood Vale Coast"
#define THREAT_REGION_MOUNT_DECAP "Mount Decapitation"
#define THREAT_REGION_TERRORBOG "Terrorbog"
// AP-only naming kept for economic_region.dm; the Underdark's role is played by the Terrorbog here.
#define THREAT_REGION_UNDERDARK THREAT_REGION_TERRORBOG
//Rockhill versions
#define THREAT_REGION_ROCKHILL_BASIN "Rockhill Basin"
#define THREAT_REGION_ROCKHILL_BOG_NORTH "Northern Terrorbog"
#define THREAT_REGION_ROCKHILL_BOG_WEST "Western Terrorbog"
#define THREAT_REGION_ROCKHILL_BOG_SOUTH "Southern Terrorbog"
#define THREAT_REGION_ROCKHILL_BOG_SUNKMIRE "Terrorbog Sunken Mire"
#define THREAT_REGION_ROCKHILL_WOODS_NORTH "Murderwood North"
#define THREAT_REGION_ROCKHILL_WOODS_SOUTH "Murderwood South"
#define THREAT_REGION_ROCKHILL_OUTER_GROVE "Rockhill Outer Grove"
//Deserttown versions
#define THREAT_REGION_DESERT_NEAR "Al-Ashur Dunes"
#define THREAT_REGION_DESERT_DEEP "The Deep Dunes"
//BYOS versions
#define THREAT_REGION_JUNGLE "The Dread Jungle"
#define THREAT_REGION_ISLAND "New Kingsfield outskirts"
#define LOWPOP_THRESHOLD 30 // When do we give highpop tick?

// Threat Point (TP) tier ladder, the "cost" of a single NPC to the quest kill-budget system
// Set on mob subtypes in questing/threat_points.dm.
// A kill quest spends a tp_budget composing its warband; each mob's threat_point is its price.
#define THREAT_TRASH 8       // Fox, raccoon, bigrat, mire crawler, all goblins - trivial critters
#define THREAT_LOW 10        // Wolf, bobcat, badger, honeyspider, supereasy/medium skeleton
#define THREAT_MODERATE 14   // Mossback, mole, easy/pirate/bogguard skeleton, highwayman, searaider, militia deserter
#define THREAT_HIGH 20       // Bog deserter, orc footsoldier, mutated spider
#define THREAT_TOUGH 25      // Upgraded bog deserter, hard skeleton, orc berserker/marauder, drow raider
#define THREAT_DANGEROUS 30  // Troll, bog troll, minotaur, direbear, drider
#define THREAT_ELITE 50      // Treasure hunter, mirespider lurker/paralytic, dwarf skeleton - boss-tier mobs

// Threat Points removed from a region's latent ambush pressure per "band" a kill quest clears.
#define THREAT_POINTS_PER_BAND 50
