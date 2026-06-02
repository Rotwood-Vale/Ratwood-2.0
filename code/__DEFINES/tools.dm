// Tool types
#define TOOL_NONE			"none" //exclusively used for surgery validation
#define TOOL_HAND			"hand" //exclusively used for surgery validation
#define TOOL_SHARP			"sharp"	//exclusively used for surgery validation
#define TOOL_HOT			"hot" //exclusively used for surgery validation
#define TOOL_CROWBAR 		"crowbar"
#define TOOL_MULTITOOL 		"multitool"
#define TOOL_SCREWDRIVER 	"screwdriver"
#define TOOL_WIRECUTTER 	"wirecutter"
#define TOOL_WRENCH 		"wrench"
#define TOOL_WELDER 		"welder"
#define TOOL_ANALYZER		"analyzer"
#define TOOL_MINING			"mining"
#define TOOL_SHOVEL			"shovel"
#define TOOL_RETRACTOR	 	"retractor"
#define TOOL_HEMOSTAT 		"hemostat"
#define TOOL_CAUTERY 		"cautery"
#define TOOL_DRILL			"drill"
#define TOOL_SCALPEL		"scalpel"
#define TOOL_SAW			"saw"
#define TOOL_BONESETTER		"bonesetter"
#define TOOL_SUTURE			"suture"
#define TOOL_IMPROVISED_RETRACTOR "improvised_retractor"
#define TOOL_IMPROVISED_HEMOSTAT "improvised_hemostat"
#define TOOL_IMPROVISED_SAW	"improvsaw"
#define TOOL_DRUIDIC_CATALYST	"druidic_catalyst" // Shared tool behaviour for harvest bloomstone and druidic staff required recipes

// Bush sapling growth stages and timers — defined here so items/ files compiled before structures/roguetown can reference them.
#define BUSHSAP_STAGE_SAPLING 1
#define BUSHSAP_STAGE_BUDDING 2
#define BUSHSAP_STAGE_MATURE  3

#define BUSHSAP_STAGE_TIME   (5 MINUTES)
#define BUSHSAP_HEDGE_TIME   (5 MINUTES)
#define BUSHSAP_DEATH_TICKS  60   // negative-progress seconds before withering

#define TOOL_IMPROVISED_SCALPEL "improvised_scalpel"
// If delay between the start and the end of tool operation is less than MIN_TOOL_SOUND_DELAY,
// tool sound is only played when op is started. If not, it's played twice.
#define MIN_TOOL_SOUND_DELAY 20
