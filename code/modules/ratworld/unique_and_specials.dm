/****************************************************
 * Ratworld unique naming and special attributes
 ****************************************************/

// Prefix/suffix pools per broad category
GLOBAL_LIST_INIT(rw_name_prefix_weapon, list("Grim", "Dire", "Blood", "Void", "Votive", "Storm", "Soul", "Night", "Sun", "Ashen", "Warden's", "Kingslayer", "Rift", "Gale", "Iron", "Eclipse", "Dread", "Whispering", "Howling"))
GLOBAL_LIST_INIT(rw_name_suffix_weapon, list("Fang", "Edge", "Reckoning", "Oath", "Promise", "Judgement", "Silence", "Hunger", "Ruin", "Dawn", "Dusk", "Pledge", "Vow", "Woe", "Saint", "Heretic", "Severance", "Betrayal", "Longing"))

GLOBAL_LIST_INIT(rw_name_prefix_armor, list("Bulwark of", "Aegis of", "Ward of", "Mantle of", "Hearth of", "Citadel of", "Garrison of", "Rampart of", "Kite of", "Vestige of", "Votive of", "Oaken", "Ironbound", "Stoneborn", "Wyrmhide"))
GLOBAL_LIST_INIT(rw_name_suffix_armor, list("Thorns", "Ash", "Resolve", "Endurance", "Courage", "Fortune", "Ages", "Embers", "Kings", "Queens", "Wolves", "Silent Oaths", "The North", "The Sun", "The Moor", "Eclipses"))

GLOBAL_LIST_INIT(rw_name_prefix_jewelry, list("Gilded", "Votive", "Saint's", "Sinner's", "Whispering", "Ashen", "Ornate", "Warden's", "Oathbound", "Seeker's", "Gambler's", "Runed", "Bloodbound"))
GLOBAL_LIST_INIT(rw_name_suffix_jewelry, list("Promise", "Design", "Thorn", "Light", "Fortune", "Kings", "Queens", "Mirth", "Gloom", "Veil", "Crossing", "Gaze", "Lot"))

// Decide item category for naming
/proc/_rw_name_category(obj/item/I)
    if(istype(I, /obj/item/rogueweapon) || istype(I, /obj/item/gun/ballistic/revolver/grenadelauncher/bow)) return "weapon"
    if(istype(I, /obj/item/clothing)) return "armor"
    if(istype(I, /obj/item/clothing/neck) || istype(I, /obj/item/clothing/ring)) return "jewelry"
    return "armor"

// Build a unique-style name: Prefix <BaseName> of Suffix
/proc/ratworld_generate_unique_name(obj/item/I)
    if(!I) return null
    var/base = I.name
    var/cat = _rw_name_category(I)
    var/prefix = "Ancient"
    var/suffix = "Might"
    if(cat == "weapon") { prefix = pick(GLOB.rw_name_prefix_weapon); suffix = pick(GLOB.rw_name_suffix_weapon) }
    else if(cat == "armor") { prefix = pick(GLOB.rw_name_prefix_armor); suffix = pick(GLOB.rw_name_suffix_armor) }
    else { prefix = pick(GLOB.rw_name_prefix_jewelry); suffix = pick(GLOB.rw_name_suffix_jewelry) }
    return "[prefix] [base] of [suffix]"

// Assign a powerful special attribute to the item based on its category
// Stores id and an associated chance/value in I.vars
/proc/ratworld_assign_special_attribute(obj/item/I)
    if(!I) return FALSE
    // Already has one
    if(istext(I.vars?["rw_special_id"])) return TRUE
    var/cat = _rw_name_category(I)
    if(cat == "weapon")
        // Weighted pick
        var/id = pick("crushing_blow", "deadly_strike", "slows_target", "astratas_light")
        var/ch_min = (id == "astratas_light") ? 1 : ((id == "slows_target") ? 5 : 5)
        var/ch_max = (id == "astratas_light") ? 1 : ((id == "slows_target") ? 15 : 10)
        I.vars["rw_special_id"] = id
        I.vars["rw_special_chance"] = rand(ch_min, ch_max)
        if(id == "slows_target") I.vars["rw_special_value"] = 4
        return TRUE
    if(cat == "armor")
        var/id2 = pick("thorns", "indestructible", "cannot_be_slowed")
        I.vars["rw_special_id"] = id2
        if(id2 == "thorns") I.vars["rw_special_chance"] = rand(5,10)
        return TRUE
    // jewelry
    var/id3 = pick("midas_touch", "magic_find")
    I.vars["rw_special_id"] = id3
    if(id3 == "midas_touch") I.vars["rw_special_chance"] = rand(1,5)
    else if(id3 == "magic_find") I.vars["rw_special_value"] = rand(1,3)
    return TRUE
