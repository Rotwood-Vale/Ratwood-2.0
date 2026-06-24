// Hag Boon System - Spells, Buffs, Traits, and Curses
// These are the boon datum definitions that manifest from enchanted moss and magical items

/// Base hag boon datum
/datum/hag_boon
	var/name = "Unnamed Boon"
	var/desc = "No description"
	var/points = 50 // Default point value for crafting
	var/hag_curse = FALSE // Mark curses separately

// ================== SPELLS ==================

/datum/hag_boon/spell
	name = "Spell"

/datum/hag_boon/spell/spider_speak
	name = "Spider's Whisper"
	desc = "Communicate with spiders and small creatures."
	points = 45

/datum/hag_boon/spell/twist_food
	name = "Twist Food"
	desc = "Transform foodstuffs into nourishing meals."
	points = 60

/datum/hag_boon/spell/find_riches
	name = "Find Riches"
	desc = "Locate valuables hidden in the world."
	points = 70

/datum/hag_boon/spell/banish
	name = "Banish"
	desc = "Send enemies to distant places."
	points = 85

// ================== BUFFS ==================

/datum/hag_boon/buff
	name = "Blessing"

/datum/hag_boon/buff/storm_rebirth
	name = "Storm Rebirth"
	desc = "Resilience in the face of adversity. You always come back."
	points = 75

/datum/hag_boon/buff/natural_communion
	name = "Natural Communion"
	desc = "Communicate with nature itself. The forest accepts you."
	points = 65

/datum/hag_boon/buff/creeping_moss
	name = "Creeping Moss"
	desc = "Moss grows on your skin, slowly mending wounds."
	points = 70

// ================== CURSES (Buffs with curse flag) ==================

/datum/hag_boon/buff/curse
	name = "Curse"
	hag_curse = TRUE

/datum/hag_boon/buff/curse/waterlogged
	name = "Waterlogged"
	desc = "Your lungs fill with water, yet you do not drown. You are bound to the bogs."
	points = 55

/datum/hag_boon/buff/curse/slumber
	name = "Cursed Slumber"
	desc = "Sleep calls to you, incessant and hungry."
	points = 50

// ================== TRAITS ==================

/datum/hag_boon/trait
	name = "Trait"

/datum/hag_boon/trait/wyrd_labourer
	name = "Wyrd Labourer"
	desc = "Your hands are strong and unyielding. You can mend what others would discard."
	points = 60

/datum/hag_boon/trait/bogwalker
	name = "Bogwalker"
	desc = "The swamp does not slow you. You move through it as if walking on solid ground."
	points = 55

// ================== ITEM BOONS ==================

/datum/hag_boon/item
	name = "Item Boon"

/datum/hag_boon/item/hag_axe
	name = "Gnarled Axe"
	desc = "A wickedly sharp axe that regrows on natural turf."
	points = 80

/datum/hag_boon/item/hag_sword
	name = "Gnarled Sword"
	desc = "A perfectly balanced blade that mends itself on sacred ground."
	points = 75

/datum/hag_boon/item/hag_spear
	name = "Gnarled Polearm"
	desc = "A long reach weapon that regenerates when planted in soil."
	points = 75

/datum/hag_boon/item/wyrd_cross
	name = "Wyrd Cross"
	desc = "A mystical cross that shifts between forms to suit the wielder."
	points = 100

// ================== CURSES (Direct curse tree) ==================

/datum/hag_boon/curse
	name = "Curse"
	hag_curse = TRUE

/datum/hag_boon/curse/rotting_touch
	name = "Rotting Touch"
	desc = "Your touch accelerates decay and decomposition."
	points = 65
