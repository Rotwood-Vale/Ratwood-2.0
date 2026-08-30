// Howl channel recipients — used in howl_channels list to define who can hear a howl.
#define HOWL_CHANNEL_WEREWOLF "werewolf" // Werewolves (/datum/antagonist/werewolf and subtypes)
#define HOWL_CHANNEL_DRUID    "druid"    // Druids, Dendorite Acolytes, and users with Call of the Moon
#define HOWL_CHANNEL_GNOLL    "gnoll"    // Gnolls (/datum/antagonist/gnoll)

GLOBAL_LIST_INIT(wolf_prefixes, list("Red", "Moon", "Bloody", "Hairy", "Eager", "Sharp", "Dark", "Silver",
									"Night", "Savage", "Fierce", "Iron", "Storm", "Wild", "Fierce", "Grim",
									"Crimson", "Midnight", "Steel", "Vicious"))
GLOBAL_LIST_INIT(wolf_suffixes, list("Fang", "Claw", "Stalker", "Prowler", "Roar", "Ripper", "Howl", "Hunt", "Hunter",
									"Bane", "Wrath", "Terror", "Fury", "Scar", "Shredder", "Maul", "Rage", "Scourge",
									"Ravager", "Seeker", "Raider"))
