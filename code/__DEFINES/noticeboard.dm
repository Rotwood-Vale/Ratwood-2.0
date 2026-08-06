/// Global list to track all current viewers of noticeboards (drives the ES "new posting
/// since I last checked" examine() flavor).
GLOBAL_LIST_EMPTY(board_viewers)
/// Global list of active "notice" tier postings (regular player postings, expire after
/// NOTICEBOARD_NOTICE_LIFETIME).
GLOBAL_LIST_EMPTY(noticeboard_notices)
/// Global list of active "listing" tier postings (Standing Listings - certain offices only,
/// do not expire on a timer).
GLOBAL_LIST_EMPTY(noticeboard_listings)

// --- Economy 3 posting tier system ---
#define POSTING_TIER_NOTICE "notice"
#define POSTING_TIER_LISTING "listing"

#define NOTICEBOARD_NOTICE_LIFETIME (30 MINUTES)

#define NOTICEBOARD_TITLE_MAX_LENGTH 50
#define NOTICEBOARD_BODY_MAX_LENGTH 500
#define NOTICEBOARD_NAME_MAX_LENGTH 50
#define NOTICEBOARD_ROLE_MAX_LENGTH 50

#define NOTICEBOARD_LISTING_ROLES list( \
	"Bathmaster", \
	"Merchant", \
	"Innkeeper", \
	"Court Magician", \
	"Town Crier", \
	"Keeper", \
	"Steward", \
	"Grand Duke", \
	"Guildmaster", \
	"Head Physician", \
)

#define NOTICEBOARD_AUTHORITY_ROLES list( \
	"Man at Arms", \
	"Inquisitor", \
	"Knight", \
	"Sergeant", \
	"Orthodoxist", \
	"Absolver", \
	"Marshal", \
	"Hand", \
	"Grand Duke", \
)
