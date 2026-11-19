//for antag huds. these are used at the /mob level
#define ANTAG_HUD		"1"
#define VAMPIRE_BLOOD_HUD	"2"

//by default everything in the hud_list of an atom is an image
//a value in hud_list with one of these will change that behavior
#define HUD_LIST_LIST 1
//rogue
#define ANTAG_HUD_TRAITOR 	1
#define ANTAG_HUD_REV		2
#define ANTAG_HUD_VAMPIRE	3
/// Deadites only, so they can tell each other apart from the infected who haven't turned
#define ANTAG_HUD_ZOMBIE	4
/// The lich and player skeletons
#define ANTAG_HUD_UNDEAD	5
#define ANTAG_HUD_WEREWOLF	6
#define ANTAG_HUD_BANDIT	7
#define ANTAG_HUD_ZIZO	8
// Notification action types
#define NOTIFY_JUMP "jump"
#define NOTIFY_ATTACK "attack"
#define NOTIFY_ORBIT "orbit"

/// cooldown for being shown the images for any particular data hud
#define ADD_HUD_TO_COOLDOWN 20
