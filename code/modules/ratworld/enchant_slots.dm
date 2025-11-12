// Ratworld enchant slot utilities: map items to slot keys and list eligible enchants

// Guess a slot key for an item based on its type/name. Admin UI can override.
/proc/ratworld_slot_key_for_item(obj/item/I)
    if(!I) return RW_SLOT_1H
    var/lp = lowertext("[I.type]")
    // Naive heuristics
    if(findtext(lp, "/shield")) return RW_SLOT_1H_SHIELD
    if(findtext(lp, "/twohand") || findtext(lp, "/2h") || findtext(lp, "/great") || findtext(lp, "/halberd") || findtext(lp, "/polearm")) return RW_SLOT_2H_PHYS
    // Armor pieces
    if(findtext(lp, "/chest") || findtext(lp, "/armor/chest") || findtext(lp, "/breast")) return RW_SLOT_CHEST
    if(findtext(lp, "/leg") || findtext(lp, "/greaves") || findtext(lp, "/pants") || findtext(lp, "/trouser")) return RW_SLOT_LEGS
    if(findtext(lp, "/boot") || findtext(lp, "/shoe")) return RW_SLOT_FOOT
    if(findtext(lp, "/helm") || findtext(lp, "/hat") || findtext(lp, "/hood")) return RW_SLOT_HEAD
    if(findtext(lp, "/glove") || findtext(lp, "/gauntlet")) return RW_SLOT_HANDS
    if(findtext(lp, "/cloak") || findtext(lp, "/cape")) return RW_SLOT_CLOAK
    if(findtext(lp, "/neck") || findtext(lp, "/amulet") || findtext(lp, "/pendant")) return RW_SLOT_NECKLACE
    if(findtext(lp, "/ring")) return RW_SLOT_RING
    if(findtext(lp, "/arm") || findtext(lp, "/bracer")) return RW_SLOT_ARMS
    if(findtext(lp, "/mask")) return RW_SLOT_MASK
    if(findtext(lp, "/shirt") || findtext(lp, "/tunic")) return RW_SLOT_SHIRT
    // Default to 1H
    return RW_SLOT_1H

// String-based variant to avoid instantiation; maps a type path string to a slot key
/proc/ratworld_slot_key_for_path(path_text)
    if(!istext(path_text)) return RW_SLOT_1H
    var/lp = lowertext(path_text)
    // Weapons
    if(findtext(lp, "/rogueweapon/shield") || findtext(lp, "/shield")) return RW_SLOT_1H_SHIELD
    if(findtext(lp, "/rogueweapon/great") || findtext(lp, "zweihander") || findtext(lp, "/twohand") || findtext(lp, "/2h")) return RW_SLOT_2H_PHYS
    if(findtext(lp, "/rogueweapon/spear") || findtext(lp, "/halberd") || findtext(lp, "/glaive") || findtext(lp, "/polearm")) return RW_SLOT_2H_PHYS
    if(findtext(lp, "/rogueweapon/staff") || findtext(lp, "/staff")) return RW_SLOT_2H_MAGICAL
    if(findtext(lp, "/rogueweapon/")) return RW_SLOT_1H
    // Armor & clothing
    if(findtext(lp, "/clothing/head/") || findtext(lp, " helmet") || findtext(lp, " helm")) return RW_SLOT_HEAD
    if(findtext(lp, "/clothing/masks/")) return RW_SLOT_MASK
    if(findtext(lp, "/clothing/gloves/")) return RW_SLOT_HANDS
    if(findtext(lp, "/clothing/wrists/") || findtext(lp, " bracers")) return RW_SLOT_ARMS
    if(findtext(lp, "/clothing/cloaks/") || findtext(lp, " cloak")) return RW_SLOT_CLOAK
    if(findtext(lp, "/clothing/neck/") || findtext(lp, " necklace") || findtext(lp, " amulet")) return RW_SLOT_NECKLACE
    if(findtext(lp, "/clothing/rings/") || findtext(lp, " ring/") || findtext(lp, " ring ")) return RW_SLOT_RING
    if(findtext(lp, "/clothing/feet/") || findtext(lp, " boots") || findtext(lp, " shoes")) return RW_SLOT_FOOT
    if(findtext(lp, "/clothing/pants/") || findtext(lp, " trousers") || findtext(lp, " greaves")) return RW_SLOT_LEGS
    if(findtext(lp, "/clothing/shirt") || findtext(lp, "/clothing/shirts") || findtext(lp, "/clothing/under/")) return RW_SLOT_SHIRT
    if(findtext(lp, "/armor/plate") || findtext(lp, " breastplate") || findtext(lp, " cuirass") || findtext(lp, " chest")) return RW_SLOT_CHEST
    if(findtext(lp, "/armor/chain") || findtext(lp, "/armor/leather")) return RW_SLOT_CHEST
    if(findtext(lp, "/platelegs") || findtext(lp, " cuisses")) return RW_SLOT_LEGS
    // Generic fallbacks
    if(findtext(lp, "/leg") || findtext(lp, "/greaves") || findtext(lp, "/pants") || findtext(lp, "/trouser")) return RW_SLOT_LEGS
    if(findtext(lp, "/boot") || findtext(lp, "/shoe")) return RW_SLOT_FOOT
    if(findtext(lp, "/helm") || findtext(lp, "/hat") || findtext(lp, "/hood")) return RW_SLOT_HEAD
    if(findtext(lp, "/glove") || findtext(lp, "/gauntlet")) return RW_SLOT_HANDS
    if(findtext(lp, "/cloak") || findtext(lp, "/cape")) return RW_SLOT_CLOAK
    if(findtext(lp, "/neck") || findtext(lp, "/amulet") || findtext(lp, "/pendant")) return RW_SLOT_NECKLACE
    if(findtext(lp, "/ring")) return RW_SLOT_RING
    if(findtext(lp, "/arm") || findtext(lp, "/bracer")) return RW_SLOT_ARMS
    if(findtext(lp, "/mask")) return RW_SLOT_MASK
    if(findtext(lp, "/shirt") || findtext(lp, "/tunic")) return RW_SLOT_SHIRT
    return RW_SLOT_1H

// Return a list of enchant ids eligible for a given slot key
/proc/ratworld_list_enchants_for_slot(slot_key)
    var/list/out = list()
    if(!istext(slot_key)) return out
    for(var/id in GLOB.rw_enchant_defs)
        var/list/def = GLOB.rw_enchant_defs[id]
        if(!islist(def)) continue
        var/list/slots = def["slots"]
        if(islist(slots) && slots[slot_key])
            out += id
    return out
