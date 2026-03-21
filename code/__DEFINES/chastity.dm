#define CHASTITY_HARDMODE_DISABLED 0
#define CHASTITY_HARDMODE_ENABLED 1

/// Root directory for all chastity flavor-text JSON banks.
/// Used by pick_chastity_string() and anywhere a raw strings() call targets the chastity string dir.
#define CHASTITY_STRINGS_PATH "modular/code/game/objects/items/lewd/chastity/strings"

/// Picks a random entry from a chastity string bank.
/// Usage: pick_chastity_string("chastity_lock_messages.json", "chastity_lock_denial")
#define pick_chastity_string(FILE, KEY) (pick(strings(FILE, KEY, CHASTITY_STRINGS_PATH)))