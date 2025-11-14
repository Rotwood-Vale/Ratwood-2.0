// Ratworld stash category classification for sizing and icon sheets
// Data-driven mapping from type path substrings to category metadata.

// Cache: type path string (lowercased) -> result list("id","w","h","icon")
GLOBAL_LIST_INIT(rw_item_class_cache, list())

// Category rules. Order doesn't matter; highest priority wins when multiple match.
GLOBAL_LIST_INIT(rw_item_categories, list(

    list(id = "dagger", patterns = list("/rogueweapon/huntingknife", "/rogueweapon/dagger", " dagger", " knife"), size = list(1,1), icon = 'icons/roguetown/weapons/daggers32.dmi', priority = 60),
    list(id = "sword_large", patterns = list("zweihander", "/rogueweapon/greatsword", " greatsword"), size = list(2,3), icon = 'icons/roguetown/weapons/swords64.dmi', priority = 55),
    list(id = "sword", patterns = list("/rogueweapon/sword", " longsword", " broadsword", " shortsword", " sword"), size = list(2,3), icon = 'icons/roguetown/weapons/swords32.dmi', priority = 50),
    list(id = "polearm", patterns = list(" spear", "/rogueweapon/spear", " halberd", " glaive", " polearm"), size = list(2,3), icon = 'icons/roguetown/weapons/polearms64.dmi', priority = 55),
    list(id = "mace", patterns = list(" warhammer", " hammer", " mace", " club"), size = list(1,2), icon = 'icons/roguetown/weapons/blunt32.dmi', priority = 45),
    list(id = "maul", patterns = list("/rogueweapon/mace/maul", " maul"), size = list(4,3), icon = 'icons/roguetown/weapons/blunt32.dmi', priority = 65),
    list(id = "axe", patterns = list("/rogueweapon/axe", " axe"), size = list(1,2), icon = 'icons/roguetown/weapons/axes32.dmi', priority = 45),
    list(id = "shield", patterns = list("/rogueweapon/shield", " shield"), size = list(2,2), icon = 'icons/roguetown/weapons/shields32.dmi', priority = 50),
    list(id = "whip", patterns = list("/rogueweapon/whip", " whip"), size = list(1,2), icon = 'icons/roguetown/weapons/whips32.dmi', priority = 40),
    list(id = "wrists", patterns = list("/clothing/wrists/", " bracers"), size = list(1,1), icon = 'icons/roguetown/clothing/wrists.dmi', priority = 50),
    list(id = "head", patterns = list("/clothing/head/", " helmet", " helm"), size = list(2,2), icon = 'icons/roguetown/clothing/head.dmi', priority = 45),
    list(id = "shirts", patterns = list("/clothing/shirts", "/clothing/shirt/", " shirt", " tunic"), size = list(2,2), icon = 'icons/roguetown/clothing/shirts.dmi', priority = 45),
    list(id = "pants", patterns = list("/clothing/pants/", " pants", " trousers"), size = list(2,2), icon = 'icons/roguetown/clothing/pants.dmi', priority = 45),
    list(id = "gloves", patterns = list("/clothing/gloves/", " gloves"), size = list(2,2), icon = 'icons/roguetown/clothing/gloves.dmi', priority = 40),
    list(id = "masks", patterns = list("/clothing/masks/", " mask"), size = list(2,2), icon = 'icons/roguetown/clothing/masks.dmi', priority = 50),
    list(id = "neck", patterns = list("/clothing/neck/", " necklace", " amulet"), size = list(1,1), icon = 'icons/roguetown/clothing/neck.dmi', priority = 50),
    list(id = "feet", patterns = list("/clothing/feet/", " boots", " shoes"), size = list(1,2), icon = 'icons/roguetown/clothing/feet.dmi', priority = 45),
    list(id = "belts", patterns = list("/clothing/belts/", " belt"), size = list(2,1), icon = 'icons/roguetown/clothing/belts.dmi', priority = 40),
    list(id = "cloaks", patterns = list("/clothing/cloaks/", " cloak"), size = list(2,3), icon = 'icons/roguetown/clothing/cloaks.dmi', priority = 45),
    list(id = "rings", patterns = list("/clothing/rings/", " ring/", " ring "), size = list(1,1), icon = 'icons/roguetown/clothing/rings.dmi', priority = 55),
    list(id = "armor_plate_chest", patterns = list("/roguetown/armor/plate", "/armor/plate", " cuirass", " breastplate", " plate"), size = list(3,3), icon = 'icons/roguetown/clothing/armor.dmi', priority = 60),
    list(id = "armor_chain_chest", patterns = list(" hauberk", " chainmail", "/roguetown/armor/chain"), size = list(2,3), icon = 'icons/roguetown/clothing/armor.dmi', priority = 58),
    list(id = "armor_leather_chest", patterns = list(" leather armor", " jerkin", "/roguetown/armor/leather"), size = list(2,2), icon = 'icons/roguetown/clothing/armor.dmi', priority = 50),
    list(id = "armor_plate_legs", patterns = list("/clothing/under/roguetown/platelegs", " platelegs", " greaves", " cuisses"), size = list(2,3), icon = 'icons/roguetown/clothing/armor.dmi', priority = 59),
    // Items
    // Books: include recipe_book and tome variants; 1x2 footprint
    list(id = "book", patterns = list("/recipe_book", "/spellbook", "/book", " tome", " grimoire", " book"), size = list(1,2), icon = 'icons/roguetown/items/books.dmi', priority = 52),
    list(id = "key", patterns = list("/key", " key"), size = list(1,1), icon = 'icons/roguetown/items/keys.dmi', priority = 40),
    list(id = "gem", patterns = list(" gem", "/gems/"), size = list(1,1), icon = 'icons/roguetown/items/gems.dmi', priority = 40),
    list(id = "food", patterns = list("/food", " bread", " meat", " fish", " cheese"), size = list(1,1), icon = 'icons/roguetown/items/food.dmi', priority = 30),
    list(id = "valuable", patterns = list(" coin", " currency", " mammon", " zenny", " treasure", " relic", " artifact"), size = list(1,1), icon = 'icons/roguetown/items/valuable.dmi', priority = 50),
    // Goblets and chalices: 1x2 vertical footprint
    list(id = "goblet", patterns = list(" goblet", "/goblet", " chalice", "/chalice"), size = list(1,2), icon = 'icons/roguetown/items/valuable.dmi', priority = 53)
))

// Classify an item or type path to stash category metadata
/proc/ratworld_classify_item_for_stash(target)
    var/lp
    if(istext(target))
        lp = lowertext(target)
    else if(istype(target, /obj/item))
        var/obj/item/I = target
        lp = lowertext("[I.type]")
    else
        return null
    if(!istext(lp) || !length(lp)) return null
    if(lp in GLOB.rw_item_class_cache)
        return GLOB.rw_item_class_cache[lp]
    var/best = null
    var/bestp = -100000
    for(var/list/R in GLOB.rw_item_categories)
        if(!islist(R)) continue
        var/list/pats = R["patterns"]
        if(!islist(pats) || !pats.len) continue
        var/match = FALSE
        for(var/p in pats)
            if(findtext(lp, lowertext("[p]"))) { match = TRUE; break }
        if(match)
            var/pri = isnum(R["priority"]) ? R["priority"] : 0
            if(pri > bestp)
                bestp = pri
                var/list/size = islist(R["size"]) ? R["size"] : list(1,1)
                best = list(
                    "id" = R["id"],
                    "w" = clamp(size[1], 1, 5),
                    "h" = clamp(size[2], 1, 5),
                    "icon" = R["icon"],
                    "state" = istext(R["state"]) ? R["state"] : null
                )
    if(best)
        GLOB.rw_item_class_cache[lp] = best
    return best
