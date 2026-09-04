//config files
#define CONFIG_GET(X) global.config.Get(/datum/config_entry/##X)
#define CONFIG_SET(X, Y) global.config.Set(/datum/config_entry/##X, ##Y)

// used for cases where the config may be accessed prior to config initialization, like in the runtime error viewer
#define CONFIG_GET_OR_DEFAULT(X) (global.config?.entries_by_type ? global.config.Get(/datum/config_entry/##X) : /datum/config_entry/##X::config_entry_value)

#ifndef MATURESERVER
#define CONFIG_MAPS_FILE "mapsrw.txt"
#else
#define CONFIG_MAPS_FILE "maps.txt"
#endif
//flags
/// can't edit
#define CONFIG_ENTRY_LOCKED 1
/// can't see value
#define CONFIG_ENTRY_HIDDEN 2

#define SIGNAL_HANDLER SHOULD_NOT_SLEEP(TRUE)
