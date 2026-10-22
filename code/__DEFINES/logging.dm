//Investigate logging defines
#define INVESTIGATE_ATMOS			"atmos"
#define INVESTIGATE_BOTANY			"botany"
#define INVESTIGATE_CARGO			"cargo"
#define INVESTIGATE_EXPERIMENTOR	"experimentor"
#define INVESTIGATE_RECORDS			"records"
#define INVESTIGATE_SINGULO			"singulo"
#define INVESTIGATE_SUPERMATTER		"supermatter"
#define INVESTIGATE_TELESCI			"telesci"
#define INVESTIGATE_WIRES			"wires"
#define INVESTIGATE_PORTAL			"portals"
#define INVESTIGATE_RESEARCH		"research"
#define INVESTIGATE_HALLUCINATIONS	"hallucinations"
#define INVESTIGATE_RADIATION		"radiation"
#define INVESTIGATE_EXONET			"exonet"
#define INVESTIGATE_NANITES			"nanites"
#define INVESTIGATE_PRESENTS		"presents"

#define LOG_COLOR_SEVERE	"#c000ff"

// Logging types for log_message()
#define LOG_ATTACK			(1 << 0)
#define LOG_SAY				(1 << 1)
#define LOG_WHISPER			(1 << 2)
#define LOG_EMOTE			(1 << 3)
#define LOG_DSAY			(1 << 4)
#define LOG_PDA				(1 << 5)
#define LOG_CHAT			(1 << 6)
#define LOG_COMMENT			(1 << 7)
#define LOG_TELECOMMS		(1 << 8)
#define LOG_OOC				(1 << 9)
#define LOG_ADMIN			(1 << 10)
#define LOG_OWNERSHIP		(1 << 11)
#define LOG_GAME			(1 << 12)
#define LOG_ADMIN_PRIVATE	(1 << 13)
#define LOG_ASAY			(1 << 14)
#define LOG_MECHA			(1 << 15)
#define LOG_VIRUS			(1 << 16)
#define LOG_CLONING			(1 << 17)
#define LOG_LOOC			(1 << 18)
#define LOG_SEEN			(1 << 19)

#define SEEN_LOG_SAY 1
#define SEEN_LOG_EMOTE 2
#define SEEN_LOG_ATTACK 3
#define SEEN_LOG_OFFSCREEN_DIST 7

/// Colours log_seen() stamps on a seen copy. The POV panel reads these back to tell speech from emotes, so
/// they are shared rather than written twice: a literal at one end and not the other fails silently
#define SEEN_COLOR_SAY "orange"
#define SEEN_COLOR_EMOTE "grey"
#define SEEN_COLOR_ATTACK "red"
/// log_combat stamps a receipt the same colour speech gets. Deliberately its own name: the two mean
/// different things and only the panel's kind checks keep a hit from reading as a spoken line
#define LOG_COLOR_RECEIPT "orange"

#define WITNESS_NAME 1
#define WITNESS_DIST 2
#define WITNESS_TAG 3

/// Keys log_message() copies out of its meta list, read back by the POV panel. Named rather than quoted at
/// both ends: the list takes any key it is handed, so a misspelling would store fine and read null forever
#define LOG_META_EVENT "event"
#define LOG_META_WITNESSES "witnesses"
#define LOG_META_TARGET "target"
#define LOG_META_ATTACKER "attacker"
#define LOG_META_RECEIPT "receipt"

//Individual logging panel pages
#define INDIVIDUAL_ATTACK_LOG		(LOG_ATTACK)
#define INDIVIDUAL_SAY_LOG			(LOG_SAY | LOG_WHISPER | LOG_DSAY)
#define INDIVIDUAL_EMOTE_LOG		(LOG_EMOTE)
#define INDIVIDUAL_COMMS_LOG		(LOG_PDA | LOG_CHAT | LOG_COMMENT | LOG_TELECOMMS)
#define INDIVIDUAL_OOC_LOG			(LOG_OOC | LOG_ADMIN)
#define INDIVIDUAL_LOOC_LOG			(LOG_LOOC | LOG_ADMIN)
#define INDIVIDUAL_OWNERSHIP_LOG	(LOG_OWNERSHIP)
#define INDIVIDUAL_SHOW_ALL_LOG		(LOG_ATTACK | LOG_SAY | LOG_WHISPER | LOG_EMOTE | LOG_DSAY | LOG_PDA | LOG_CHAT | LOG_COMMENT | LOG_TELECOMMS | LOG_OOC | LOG_ADMIN | LOG_OWNERSHIP | LOG_GAME)

//LOG_SEEN and INDIVIDUAL_POV_LOG are deliberately not in Show All
#define INDIVIDUAL_SEEN_LOG		(LOG_SEEN)
#define INDIVIDUAL_POV_LOG		(1 << 20)

#define LOGSRC_CLIENT "Client"
#define LOGSRC_MOB "Mob"
