// Ratworld stash SFX configuration
// Tweak categories/patterns and sounds here.

// A category entry is list(
//   "id" = "potion",
//   "sounds" = list('sound/ratworld/stashsounds/potion1.ogg','sound/ratworld/stashsounds/potion2.ogg','sound/ratworld/stashsounds/potion3.ogg'),
//   "name_patterns" = list("potion","vial","bottle","flask"),
//   "path_patterns" = list(),
// )
// Order matters; first match wins unless special overrides apply in code (e.g., ring rarity, boots material).

GLOBAL_LIST_INIT(rw_stash_sfx_categories, list(
    list(
        "id" = "book",
        "sounds" = list('sound/ratworld/stashsounds/book_placed.ogg'),
        "name_patterns" = list("book"),
        "path_patterns" = list("/book")
    ),
    list(
        "id" = "ring",
        "sounds" = list('sound/ratworld/stashsounds/ring_placedown_common.ogg'), // epic+ handled in code
        "name_patterns" = list("ring"),
        "path_patterns" = list("/ring/")
    ),
    list(
        "id" = "necklace",
        "sounds" = list('sound/ratworld/stashsounds/necklace_place.ogg'),
        "name_patterns" = list("necklace","amulet"),
        "path_patterns" = list("/clothing/neck/")
    ),
    list(
        "id" = "key",
        "sounds" = list('sound/ratworld/stashsounds/key_placed.ogg'),
        "name_patterns" = list("key"),
        "path_patterns" = list("/key")
    ),
    list(
        "id" = "gem",
        "sounds" = list('sound/ratworld/stashsounds/gem.ogg'),
        "name_patterns" = list("gem"),
        "path_patterns" = list()
    ),
    list(
        "id" = "quiver",
        "sounds" = list('sound/ratworld/stashsounds/quiver_place.ogg'),
        "name_patterns" = list("quiver"),
        "path_patterns" = list("/quiver/")
    ),
    list(
        "id" = "crossbow",
        "sounds" = list('sound/ratworld/stashsounds/crossbow_placedown.ogg'),
        "name_patterns" = list("crossbow"),
        "path_patterns" = list("crossbow")
    ),
    list(
        "id" = "bow",
        "sounds" = list('sound/ratworld/stashsounds/bow.ogg'),
        "name_patterns" = list("bow"),
        "path_patterns" = list("/bow")
    ),
    list(
        "id" = "spear",
        "sounds" = list('sound/ratworld/stashsounds/spear_placed.ogg'),
        "name_patterns" = list("spear"),
        "path_patterns" = list("/spear/")
    ),
    list(
        "id" = "dagger",
        "sounds" = list('sound/ratworld/stashsounds/dagger_placedown.ogg'),
        "name_patterns" = list("dagger"),
        "path_patterns" = list("/dagger/")
    ),
    list(
        "id" = "largewep",
        "sounds" = list('sound/ratworld/stashsounds/largewep_placed.ogg'),
        "name_patterns" = list("zweihander","greatsword","longsword","sword","warhammer","halberd","glaive"),
        "path_patterns" = list("/weapon/")
    ),
    list(
        "id" = "chainmail",
        "sounds" = list('sound/ratworld/stashsounds/chainmail_iron.ogg'),
        "name_patterns" = list("hauberk","chain","coif","chainmail"),
        "path_patterns" = list("/chain")
    ),
    list(
        "id" = "plate_steel",
        "sounds" = list('sound/ratworld/stashsounds/plate_steel.ogg'),
        "name_patterns" = list("steel plate","steel cuisses","steel greaves","steel gauntlets"),
        "path_patterns" = list("/plate")
    ),
    list(
        "id" = "helm",
        "sounds" = list('sound/ratworld/stashsounds/helm_placedown.ogg'),
        "name_patterns" = list("helm","helmet"),
        "path_patterns" = list("/helmet")
    ),
    list(
        "id" = "boots_armor",
        "sounds" = list('sound/ratworld/stashsounds/boots_armor_placed.ogg'),
        "name_patterns" = list("boots","sabatons"),
        "path_patterns" = list("/clothing/feet/")
    ),
    list(
        "id" = "boots_leather",
        "sounds" = list('sound/ratworld/stashsounds/leather_boots_placed.ogg'),
        "name_patterns" = list("boots"),
        "path_patterns" = list("/clothing/feet/")
    ),
    list(
        "id" = "cloth",
        "sounds" = list('sound/ratworld/stashsounds/cloth.ogg'),
        "name_patterns" = list("bundle","cloth","shirt","pants","cloak","gloves","mask"),
        "path_patterns" = list("/clothing/")
    ),
    list(
        "id" = "food",
        "sounds" = list('sound/ratworld/stashsounds/foodstuff.ogg'),
        "name_patterns" = list("food","bread","meat","fish","cheese","apple","meal","pie","cake"),
        "path_patterns" = list("/food")
    ),
    list(
        "id" = "potion",
        "sounds" = list('sound/ratworld/stashsounds/potion1.ogg','sound/ratworld/stashsounds/potion2.ogg','sound/ratworld/stashsounds/potion3.ogg'),
        "name_patterns" = list("potion","vial","bottle","flask"),
        "path_patterns" = list()
    ),
    list(
        "id" = "plank",
        "sounds" = list('sound/ratworld/stashsounds/plank.ogg'),
        "name_patterns" = list("plank","log"),
        "path_patterns" = list()
    ),
    list(
        "id" = "stick",
        "sounds" = list('sound/ratworld/stashsounds/stick.ogg'),
        "name_patterns" = list("stick"),
        "path_patterns" = list()
    ),
    list(
        "id" = "rare_treasure",
        "sounds" = list('sound/ratworld/stashsounds/rare_treasure.ogg'),
        "name_patterns" = list("treasure","relic","artifact"),
        "path_patterns" = list()
    )
))
