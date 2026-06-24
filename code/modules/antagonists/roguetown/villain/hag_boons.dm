// Hag Boon System - Spells, Buffs, Traits, and Curses
// These are the boon datum definitions that manifest from enchanted moss and magical items

/// Base hag boon datum
/datum/hag_boon
	var/true_name
	var/datum/component/hag_curio_tracker/tracker
	var/name = "Unnamed Boon"
	var/desc = "No description"
	var/points = 50 // Default point value for crafting
	var/hag_curse = FALSE // Mark curses separately
	var/hag_is_valid = TRUE
	var/hag_trait = FALSE
	var/transmutable = TRUE

/datum/hag_boon/New(_true_name, _tracker, set_points)
	true_name = _true_name
	tracker = _tracker
	if(!isnull(set_points))
		points = set_points
	. = ..()
	apply_to_target()

/datum/hag_boon/Destroy()
	remove_from_target()
	return ..()

/datum/hag_boon/proc/find_target()
	if(tracker)
		return tracker.find_target(true_name)
	return null

/datum/hag_boon/proc/apply_to_target()
	return

/datum/hag_boon/proc/remove_from_target()
	return

// ================== SPELLS ==================

/datum/hag_boon/spell
	name = "Spell"
	var/spell_type = null

/datum/hag_boon/spell/apply_to_target()
	var/mob/living/L = find_target()
	if(!L?.mind || !spell_type)
		return
	L.mind.AddSpell(new spell_type)

/datum/hag_boon/spell/remove_from_target()
	var/mob/living/L = find_target()
	if(!L?.mind || !spell_type)
		return
	L.mind.RemoveSpell(spell_type)

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

/datum/hag_boon/buff/curse/choking_moss
	name = "Choking Moss"
	desc = "Thick bog-filth clings to your throat and lungs."
	points = 40

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
	hag_trait = TRUE

/datum/hag_boon/trait/wyrd_labourer
	name = "Wyrd Labourer"
	desc = "Your hands are strong and unyielding. You can mend what others would discard."
	points = 60

/datum/hag_boon/trait/bogwalker
	name = "Bogwalker"
	desc = "The swamp does not slow you. You move through it as if walking on solid ground."
	points = 55

// ================== TRAIT CURSES ==================

/datum/hag_boon/trait/curse
	name = "Trait Curse"
	hag_curse = TRUE

/datum/hag_boon/trait/curse/ugly
	name = "Unseemly"
	desc = "Your face becomes uncanny and wrong."
	points = 10

/datum/hag_boon/trait/curse/ugly/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_UNSEEMLY, "hag_curse")

/datum/hag_boon/trait/curse/ugly/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_UNSEEMLY, "hag_curse")

/datum/hag_boon/trait/curse/silver_weakness
	name = "Silver Weakness"
	desc = "Silver burns like holy acid."
	points = 50

/datum/hag_boon/trait/curse/silver_weakness/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_SILVER_WEAK, "hag_curse")

/datum/hag_boon/trait/curse/silver_weakness/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_SILVER_WEAK, "hag_curse")

/datum/hag_boon/trait/curse/no_run
	name = "Sluggish Limbs"
	desc = "Your legs no longer answer urgent commands."
	points = 60

/datum/hag_boon/trait/curse/no_run/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_NORUN, "hag_curse")

/datum/hag_boon/trait/curse/no_run/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_NORUN, "hag_curse")

/datum/hag_boon/trait/curse/critical_weakness
	name = "Critical Weakness"
	desc = "Blows that others survive now cripple you."
	points = 75

/datum/hag_boon/trait/curse/critical_weakness/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_CRITICAL_WEAKNESS, "hag_curse")

/datum/hag_boon/trait/curse/critical_weakness/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_CRITICAL_WEAKNESS, "hag_curse")

/datum/hag_boon/trait/curse/no_spells
	name = "Spellbane Tongue"
	desc = "Ancient words catch in your throat before they can form."
	points = 100
	hag_is_valid = TRUE

/datum/hag_boon/trait/curse/mute
	name = "Silenced Tongue"
	desc = "Your voice is stolen by the Mossmother."
	points = 100

/datum/hag_boon/trait/curse/mute/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_PERMAMUTE, "hag_curse")

/datum/hag_boon/trait/curse/mute/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_PERMAMUTE, "hag_curse")

/datum/hag_boon/trait/curse/no_defense
	name = "Defenseless"
	desc = "You can no longer dodge nor parry."
	points = 100

/datum/hag_boon/trait/curse/no_defense/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_NODEF, "hag_curse")

/datum/hag_boon/trait/curse/no_defense/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_NODEF, "hag_curse")

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

/datum/hag_boon/item_debt
	name = "Item Debt"
	desc = "A mounting debt tied to accepted hag-crafted artifacts."
	points = 0
	transmutable = FALSE

/datum/hag_boon/item_debt/proc/add_points(amount)
	points += max(0, amount)

/datum/hag_boon/revival_debt
	name = "Soul Tether"
	desc = "A portion of your vitality is bound to the Hag who pulled you from the brink."
	points = 50
	transmutable = FALSE

// ================== CURSES (Direct curse tree) ==================

/datum/hag_boon/curse
	name = "Curse"
	hag_curse = TRUE

/datum/hag_boon/curse/rotting_touch
	name = "Rotting Touch"
	desc = "Your touch accelerates decay and decomposition."
	points = 65

/datum/hag_boon/curse_scar
	name = "Curse Scar"
	desc = "A lingering mark of corruption claimed by the Mossmother."
	transmutable = FALSE
