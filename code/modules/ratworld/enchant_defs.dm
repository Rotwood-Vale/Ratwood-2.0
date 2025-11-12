// Ratworld enchant definitions (data-driven) derived from design sheet
// Each enchant has: id, name, category, slots (per-slot min/max and percent flag), max_total, notes
// Slot keys align to design columns; systems can pass an explicit slot key when rolling.

// Slot key constants (string literals used as keys)
#define RW_SLOT_1H "1H"
#define RW_SLOT_1H_SHIELD "1H_SHIELD"
#define RW_SLOT_2H_PHYS "2H_PHYS"
#define RW_SLOT_2H_MAGICAL "2H_MAGICAL"
#define RW_SLOT_CHEST "CHEST"
#define RW_SLOT_LEGS "LEGS"
#define RW_SLOT_FOOT "FOOT"
#define RW_SLOT_HEAD "HEAD"
#define RW_SLOT_HANDS "HANDS"
#define RW_SLOT_CLOAK "CLOAK"
#define RW_SLOT_NECKLACE "NECKLACE"
#define RW_SLOT_RING "RING"
#define RW_SLOT_ARMS "ARMS"
#define RW_SLOT_MASK "MASK"
#define RW_SLOT_SHIRT "SHIRT"

// Helper to construct a slot range entry
/proc/_rw_slot(minv, maxv, is_percent)
    return list("min" = minv, "max" = maxv, "percent" = is_percent)

// Global registry (id -> def)
GLOBAL_LIST_INIT(rw_enchant_defs, list(
    // PHYSICAL
    "phys_power_bonus" = list(
        "name" = "Phys Power Bonus",
        "category" = "PHYSICAL",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(1, 5, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(1, 5, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(1, 5, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(1, 5, TRUE),
            RW_SLOT_CHEST = _rw_slot(1, 5, TRUE),
            RW_SLOT_LEGS = _rw_slot(1, 5, TRUE),
            RW_SLOT_FOOT = _rw_slot(1, 5, TRUE),
            RW_SLOT_HEAD = _rw_slot(1, 5, TRUE),
            RW_SLOT_HANDS = _rw_slot(1, 5, TRUE),
            RW_SLOT_CLOAK = _rw_slot(1, 5, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(1, 5, TRUE),
            RW_SLOT_RING = _rw_slot(1, 5, TRUE),
            RW_SLOT_ARMS = _rw_slot(1, 5, TRUE),
            RW_SLOT_MASK = _rw_slot(1, 5, TRUE),
            RW_SLOT_SHIRT = _rw_slot(1, 5, TRUE)
        ),
        "max_total" = list("value" = 25, "percent" = TRUE)
    ),
    "phys_power" = list(
        "name" = "Phys Power",
        "category" = "PHYSICAL",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(1, 1, FALSE),
            RW_SLOT_1H_SHIELD = _rw_slot(1, 1, FALSE),
            RW_SLOT_2H_PHYS = _rw_slot(1, 1, FALSE),
            RW_SLOT_2H_MAGICAL = _rw_slot(1, 1, FALSE)
        ),
        "max_total" = list("value" = 2, "percent" = FALSE)
    ),
    "true_phys_damage" = list(
        "name" = "True Phys Damage",
        "category" = "PHYSICAL",
        "slots" = list(
            RW_SLOT_CLOAK = _rw_slot(1, 2, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(1, 2, TRUE),
            RW_SLOT_RING = _rw_slot(1, 2, TRUE)
        ),
        "max_total" = list("value" = 5, "percent" = TRUE)
    ),
    "armor_damage_bonus" = list(
        "name" = "Armor Damage Bonus",
        "category" = "PHYSICAL",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(1, 5, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(1, 5, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(1, 5, TRUE)
        ),
        "max_total" = list("value" = 10, "percent" = TRUE)
    ),

    // MAGICAL
    "magic_power_bonus" = list(
        "name" = "Magic Power Bonus",
        "category" = "MAGICAL",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(0.5, 10, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(0.5, 10, TRUE),
            RW_SLOT_CHEST = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_LEGS = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_FOOT = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_HEAD = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_HANDS = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_CLOAK = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(0.5, 10, TRUE),
            RW_SLOT_RING = _rw_slot(0.5, 10, TRUE),
            RW_SLOT_ARMS = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_MASK = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_SHIRT = _rw_slot(0.5, 3, TRUE)
        ),
        "max_total" = list("value" = 50, "percent" = TRUE)
    ),
    "true_magical_damage" = list(
        "name" = "True Magical Damage",
        "category" = "MAGICAL",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(1.5, 5, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(1.5, 5, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(1.5, 5, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(1.5, 5, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(1.5, 5, TRUE),
            RW_SLOT_RING = _rw_slot(1.5, 15, TRUE)
        ),
        "max_total" = list("value" = 25, "percent" = TRUE)
    ),
    "magic_penetration" = list(
        "name" = "Magic Penetration",
        "category" = "MAGICAL",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(1, 5, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(1, 5, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(1, 5, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(1, 5, TRUE),
            RW_SLOT_CHEST = _rw_slot(1, 5, TRUE),
            RW_SLOT_HEAD = _rw_slot(1, 5, TRUE),
            RW_SLOT_HANDS = _rw_slot(1, 5, TRUE),
            RW_SLOT_CLOAK = _rw_slot(1, 5, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(1, 5, TRUE),
            RW_SLOT_RING = _rw_slot(1, 5, TRUE),
            RW_SLOT_ARMS = _rw_slot(1, 5, TRUE),
            RW_SLOT_MASK = _rw_slot(1, 5, TRUE),
            RW_SLOT_SHIRT = _rw_slot(1, 5, TRUE)
        ),
        "max_total" = list("value" = 30, "percent" = TRUE)
    ),

    // NEUTRAL (race damage)
    "undead_race_damage_bonus" = list(
        "name" = "Undead Race Damage Bonus",
        "category" = "NEUTRAL",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(10, 200, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(10, 200, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(10, 200, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(10, 200, TRUE),
            RW_SLOT_CHEST = _rw_slot(5, 35, TRUE),
            RW_SLOT_LEGS = _rw_slot(5, 35, TRUE),
            RW_SLOT_FOOT = _rw_slot(5, 35, TRUE),
            RW_SLOT_HEAD = _rw_slot(5, 35, TRUE),
            RW_SLOT_HANDS = _rw_slot(5, 35, TRUE),
            RW_SLOT_CLOAK = _rw_slot(5, 35, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(5, 35, TRUE),
            RW_SLOT_RING = _rw_slot(5, 35, TRUE),
            RW_SLOT_ARMS = _rw_slot(5, 35, TRUE),
            RW_SLOT_MASK = _rw_slot(5, 35, TRUE),
            RW_SLOT_SHIRT = _rw_slot(5, 35, TRUE)
        ),
        "max_total" = list("value" = 450, "percent" = TRUE),
        "notes" = "capped 200% against player undead"
    ),
    "demon_race_damage_bonus" = list(
        "name" = "Demon Race Damage Bonus",
        "category" = "NEUTRAL",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(10, 200, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(10, 200, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(10, 200, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(10, 200, TRUE),
            RW_SLOT_CHEST = _rw_slot(5, 35, TRUE),
            RW_SLOT_LEGS = _rw_slot(5, 35, TRUE),
            RW_SLOT_FOOT = _rw_slot(5, 35, TRUE),
            RW_SLOT_HEAD = _rw_slot(5, 35, TRUE),
            RW_SLOT_HANDS = _rw_slot(5, 35, TRUE),
            RW_SLOT_CLOAK = _rw_slot(5, 35, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(5, 35, TRUE),
            RW_SLOT_RING = _rw_slot(5, 35, TRUE),
            RW_SLOT_ARMS = _rw_slot(5, 35, TRUE),
            RW_SLOT_MASK = _rw_slot(5, 35, TRUE),
            RW_SLOT_SHIRT = _rw_slot(5, 35, TRUE)
        ),
        "max_total" = list("value" = 450, "percent" = TRUE),
        "notes" = "capped 200% against demonic players"
    ),
    "goblin_race_damage_bonus" = list(
        "name" = "Goblin Race Damage Bonus",
        "category" = "NEUTRAL",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(20, 400, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(20, 400, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(20, 400, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(20, 400, TRUE),
            RW_SLOT_CHEST = _rw_slot(5, 35, TRUE),
            RW_SLOT_LEGS = _rw_slot(5, 35, TRUE),
            RW_SLOT_FOOT = _rw_slot(5, 35, TRUE),
            RW_SLOT_HEAD = _rw_slot(5, 35, TRUE),
            RW_SLOT_HANDS = _rw_slot(5, 35, TRUE),
            RW_SLOT_CLOAK = _rw_slot(5, 35, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(5, 35, TRUE),
            RW_SLOT_RING = _rw_slot(5, 35, TRUE),
            RW_SLOT_ARMS = _rw_slot(5, 35, TRUE),
            RW_SLOT_MASK = _rw_slot(5, 35, TRUE),
            RW_SLOT_SHIRT = _rw_slot(5, 35, TRUE)
        ),
        "max_total" = list("value" = 800, "percent" = TRUE),
        "notes" = "capped 200% against player goblins"
    ),

    // REDUCTIONS / DEFENSE
    "armor_rating_add" = list(
        "name" = "Armor Rating Add",
        "category" = "REDUCTIONS",
        "slots" = list(
            RW_SLOT_CHEST = _rw_slot(1, 2, FALSE),
            RW_SLOT_LEGS = _rw_slot(1, 2, FALSE),
            RW_SLOT_FOOT = _rw_slot(1, 2, FALSE),
            RW_SLOT_HEAD = _rw_slot(1, 2, FALSE),
            RW_SLOT_HANDS = _rw_slot(1, 2, FALSE),
            RW_SLOT_ARMS = _rw_slot(1, 2, FALSE),
            RW_SLOT_MASK = _rw_slot(1, 2, FALSE),
            RW_SLOT_SHIRT = _rw_slot(1, 2, FALSE)
        ),
        "max_total" = null,
        "notes" = "Adds +1 or +2 to ALL defensive ratings of that piece (capped to SS)."
    ),
    "durability_add" = list(
        "name" = "Durability Add",
        "category" = "REDUCTIONS",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(50, 200, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(50, 200, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(50, 200, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(50, 200, TRUE),
            RW_SLOT_CHEST = _rw_slot(50, 200, TRUE),
            RW_SLOT_LEGS = _rw_slot(50, 200, TRUE),
            RW_SLOT_FOOT = _rw_slot(50, 200, TRUE),
            RW_SLOT_HEAD = _rw_slot(50, 200, TRUE),
            RW_SLOT_HANDS = _rw_slot(50, 200, TRUE),
            RW_SLOT_CLOAK = _rw_slot(50, 200, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(50, 200, TRUE),
            RW_SLOT_RING = _rw_slot(50, 200, TRUE),
            RW_SLOT_ARMS = _rw_slot(50, 200, TRUE),
            RW_SLOT_MASK = _rw_slot(50, 200, TRUE),
            RW_SLOT_SHIRT = _rw_slot(50, 200, TRUE)
        ),
        "max_total" = null,
        "notes" = "Per piece"
    ),
    "projectile_damage_defense" = list(
        "name" = "Projectile Damage Defense",
        "category" = "REDUCTIONS",
        "slots" = list(
            RW_SLOT_1H_SHIELD = _rw_slot(15, 25, TRUE),
            RW_SLOT_CHEST = _rw_slot(15, 25, TRUE),
            RW_SLOT_LEGS = _rw_slot(15, 25, TRUE),
            RW_SLOT_FOOT = _rw_slot(15, 25, TRUE),
            RW_SLOT_HEAD = _rw_slot(15, 25, TRUE),
            RW_SLOT_ARMS = _rw_slot(15, 25, TRUE),
            RW_SLOT_SHIRT = _rw_slot(15, 25, TRUE)
        ),
        "max_total" = null,
        "notes" = "Per piece; increases chance projectile doesn't penetrate that body part"
    ),
    "magical_defense" = list(
        "name" = "Magical Defense",
        "category" = "REDUCTIONS",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(1, 10, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(1, 10, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(1, 10, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(1, 10, TRUE),
            RW_SLOT_CHEST = _rw_slot(10, 50, TRUE),
            RW_SLOT_LEGS = _rw_slot(10, 50, TRUE),
            RW_SLOT_FOOT = _rw_slot(10, 50, TRUE),
            RW_SLOT_HEAD = _rw_slot(10, 50, TRUE),
            RW_SLOT_HANDS = _rw_slot(10, 50, TRUE),
            RW_SLOT_CLOAK = _rw_slot(10, 50, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(10, 50, TRUE),
            RW_SLOT_RING = _rw_slot(10, 50, TRUE),
            RW_SLOT_ARMS = _rw_slot(10, 50, TRUE),
            RW_SLOT_MASK = _rw_slot(10, 50, TRUE),
            RW_SLOT_SHIRT = _rw_slot(10, 50, TRUE)
        ),
        "max_total" = list("value" = 75, "percent" = TRUE)
    ),
    "cooldown_reduction_bonus" = list(
        "name" = "Cooldown Reduction Bonus",
        "category" = "REDUCTIONS",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(0.5, 5, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(0.5, 5, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(0.5, 5, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(0.5, 5, TRUE),
            RW_SLOT_CLOAK = _rw_slot(0.5, 5, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(0.5, 5, TRUE),
            RW_SLOT_RING = _rw_slot(0.5, 5, TRUE)
        ),
        "max_total" = list("value" = 15.5, "percent" = TRUE)
    ),

    // ACTIONS
    "action_speed" = list(
        "name" = "Action Speed",
        "category" = "ACTIONS",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(1, 5, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(1, 5, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(1, 5, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(1, 5, TRUE),
            RW_SLOT_CHEST = _rw_slot(1, 5, TRUE),
            RW_SLOT_LEGS = _rw_slot(1, 5, TRUE),
            RW_SLOT_FOOT = _rw_slot(1, 5, TRUE),
            RW_SLOT_HEAD = _rw_slot(1, 5, TRUE),
            RW_SLOT_HANDS = _rw_slot(1, 5, TRUE),
            RW_SLOT_CLOAK = _rw_slot(1, 5, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(1, 5, TRUE),
            RW_SLOT_RING = _rw_slot(1, 5, TRUE),
            RW_SLOT_ARMS = _rw_slot(1, 5, TRUE),
            RW_SLOT_MASK = _rw_slot(1, 5, TRUE),
            RW_SLOT_SHIRT = _rw_slot(1, 5, TRUE)
        ),
        "max_total" = list("value" = 50, "percent" = TRUE),
        "notes" = "Affects most action bars including rituals and lockpicking"
    ),
    "spell_casting_speed" = list(
        "name" = "Spell Casting Speed",
        "category" = "ACTIONS",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(1, 5, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(1, 5, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(1, 5, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(1, 5, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(1, 5, TRUE),
            RW_SLOT_RING = _rw_slot(1, 5, TRUE)
        ),
        "max_total" = list("value" = 15, "percent" = TRUE)
    ),
    "speed_flat" = list(
        "name" = "Speed",
        "category" = "ACTIONS",
        "slots" = list(
            RW_SLOT_FOOT = _rw_slot(1, 4, FALSE)
        ),
        "max_total" = list("value" = 4, "percent" = FALSE),
        "notes" = "+1 to +4 move speed; +4 is very rare"
    ),

    // HEALTH
    "max_health_add" = list(
        "name" = "Max Health Add",
        "category" = "HEALTH",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(1, 10, FALSE),
            RW_SLOT_1H_SHIELD = _rw_slot(1, 10, FALSE),
            RW_SLOT_2H_PHYS = _rw_slot(1, 10, FALSE),
            RW_SLOT_2H_MAGICAL = _rw_slot(1, 10, FALSE),
            RW_SLOT_CHEST = _rw_slot(1, 10, FALSE),
            RW_SLOT_LEGS = _rw_slot(1, 10, FALSE),
            RW_SLOT_FOOT = _rw_slot(1, 10, FALSE),
            RW_SLOT_HEAD = _rw_slot(1, 10, FALSE),
            RW_SLOT_HANDS = _rw_slot(1, 10, FALSE),
            RW_SLOT_CLOAK = _rw_slot(1, 10, FALSE),
            RW_SLOT_NECKLACE = _rw_slot(1, 10, FALSE),
            RW_SLOT_RING = _rw_slot(1, 10, FALSE),
            RW_SLOT_ARMS = _rw_slot(1, 10, FALSE),
            RW_SLOT_MASK = _rw_slot(1, 10, FALSE),
            RW_SLOT_SHIRT = _rw_slot(1, 10, FALSE)
        ),
        "max_total" = list("value" = 100, "percent" = FALSE),
        "notes" = "Adds flat HP"
    ),
    "max_health_bonus" = list(
        "name" = "Max Health Bonus",
        "category" = "HEALTH",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(0.5, 1, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(0.5, 1, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(0.5, 1, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(0.5, 1, TRUE),
            RW_SLOT_CHEST = _rw_slot(0.5, 1.5, TRUE),
            RW_SLOT_LEGS = _rw_slot(0.5, 1.5, TRUE),
            RW_SLOT_FOOT = _rw_slot(0.5, 1.5, TRUE),
            RW_SLOT_HEAD = _rw_slot(0.5, 1.5, TRUE),
            RW_SLOT_HANDS = _rw_slot(0.5, 1.5, TRUE),
            RW_SLOT_CLOAK = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_RING = _rw_slot(0.5, 3, TRUE),
            RW_SLOT_ARMS = _rw_slot(0.5, 1.5, TRUE),
            RW_SLOT_MASK = _rw_slot(0.5, 1.5, TRUE),
            RW_SLOT_SHIRT = _rw_slot(0.5, 1.5, TRUE)
        ),
        "max_total" = list("value" = 16, "percent" = TRUE)
    ),

    // HEALING
    "outgoing_healing_add" = list(
        "name" = "Outgoing Healing Add",
        "category" = "HEALING",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(1, 1, FALSE),
            RW_SLOT_1H_SHIELD = _rw_slot(1, 1, FALSE),
            RW_SLOT_2H_PHYS = _rw_slot(1, 1, FALSE),
            RW_SLOT_2H_MAGICAL = _rw_slot(1, 1, FALSE),
            RW_SLOT_CLOAK = _rw_slot(1, 1, FALSE),
            RW_SLOT_NECKLACE = _rw_slot(1, 1, FALSE),
            RW_SLOT_RING = _rw_slot(1, 1, FALSE)
        ),
        "max_total" = list("value" = 4, "percent" = FALSE),
        "notes" = "Adds to healing_on_tick for miracles"
    ),

    // STATUSES
    "buff_duration_bonus" = list(
        "name" = "Buff Duration Bonus",
        "category" = "STATUSES",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(1, 10, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(1, 10, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(1, 10, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(1, 10, TRUE),
            RW_SLOT_CLOAK = _rw_slot(1, 10, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(1, 10, TRUE),
            RW_SLOT_RING = _rw_slot(1, 10, TRUE)
        ),
        "max_total" = list("value" = 30, "percent" = TRUE)
    ),
    "debuff_duration_bonus" = list(
        "name" = "Debuff Duration Bonus",
        "category" = "STATUSES",
        "slots" = list(
            RW_SLOT_1H = _rw_slot(1, 10, TRUE),
            RW_SLOT_1H_SHIELD = _rw_slot(1, 10, TRUE),
            RW_SLOT_2H_PHYS = _rw_slot(1, 10, TRUE),
            RW_SLOT_2H_MAGICAL = _rw_slot(1, 10, TRUE),
            RW_SLOT_CLOAK = _rw_slot(1, 10, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(1, 10, TRUE),
            RW_SLOT_RING = _rw_slot(1, 10, TRUE)
        ),
        "max_total" = list("value" = 30, "percent" = TRUE)
    ),

    // MISC
    "luck" = list(
        "name" = "Luck",
        "category" = "MISC",
        "slots" = list(
            RW_SLOT_CLOAK = _rw_slot(5, 50, TRUE),
            RW_SLOT_NECKLACE = _rw_slot(5, 100, TRUE),
            RW_SLOT_RING = _rw_slot(5, 200, TRUE)
        ),
        "max_total" = list("value" = 350, "percent" = TRUE),
        "notes" = "Affects enchanting, loot, crafting rarity, and crits (crits capped at 15%)"
    )
))

// Accessors
/proc/ratworld_get_enchant_def(id)
    return GLOB.rw_enchant_defs?[id]

// Returns a per-slot range entry for an enchant id
/proc/ratworld_get_enchant_slot_range(id, slot_key)
    var/list/def = ratworld_get_enchant_def(id)
    if(!islist(def)) return null
    var/list/slots = def["slots"]
    if(!islist(slots)) return null
    return slots[slot_key]

// Roll a value for a specific enchant and slot_key (returns number, is_percent)
/proc/ratworld_roll_enchant_value_for_slot(id, slot_key)
    var/list/r = ratworld_get_enchant_slot_range(id, slot_key)
    if(!islist(r)) return null
    var/minv = r["min"]
    var/maxv = r["max"]
    var/is_percent = r["percent"]
    if(isnull(minv) || isnull(maxv)) return null
    // Support fractional steps: roll in tenths if needed
    var/scale = (round(minv) != minv || round(maxv) != maxv) ? 10 : 1
    var/ival = rand(round(minv*scale), round(maxv*scale)) / scale
    return list("value" = ival, "percent" = is_percent)
