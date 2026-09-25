#define NO_STUTTER 1
#define TONGUELESS_SPEECH 2
#define SIGNLANG 4

#define LANGUAGE_KNOWN "language_known"
#define LANGUAGE_SHADOWED "language_shadowed"

// Language sources. Languages are refcounted by source the same way traits are,
// so a temporary grant can never revoke a language something else also granted.
/// Default source. Use for permanent grants (jobs, patrons, virtues, prefs).
#define LANGUAGE_SOURCE_GENERIC "generic"
/// Languages a language_holder subtype declares in its own languages list.
#define LANGUAGE_SOURCE_INNATE "innate"
/// Granted by the mob's species, removed when the species is.
#define LANGUAGE_SOURCE_SPECIES "species"
/// Sentinel for removal only: drops the language no matter who granted it.
#define LANGUAGE_SOURCE_ALL "all"

// Language icon flags
#define LANGUAGE_HIDE_ICON_IF_UNDERSTOOD (1<<0)
#define LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD (1<<1)
