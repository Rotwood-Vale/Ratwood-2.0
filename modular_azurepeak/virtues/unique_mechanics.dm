// Unique Mechanical Virtues - Special abilities that change gameplay

/datum/virtue/unique
	category = "feats"

// ============================================
// FERAL INSTINCTS - Natural Weapons
// ============================================

// Weaker version of werewolf claws

/obj/item/rogueweapon/wolf_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

// WOLF SPELLS //
/obj/effect/proc_holder/spell/self/feral_claws
	name = "Feral Claws"
	desc = "!"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 20 //2 seconds
	ignore_cockblock = TRUE
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/feral_claws/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/feral_claw/left/l
	var/obj/item/rogueweapon/feral_claw/right/r

	l = user.get_active_held_item()
	r = user.get_inactive_held_item()
	if(extended)
		if(istype(l, /obj/item/rogueweapon/feral_claw))
			user.dropItemToGround(l, TRUE)
			qdel(l)
		if(istype(r, /obj/item/rogueweapon/feral_claw))
			user.dropItemToGround(r, TRUE)
			qdel(r)
		//user.visible_message("Your claws retract.", "You feel your claws retracting.", "You hear a sound of claws retracting.")
		extended = FALSE
	else
		l = new(user,1)
		r = new(user,2)
		user.put_in_hands(l, TRUE, FALSE, TRUE)
		user.put_in_hands(r, TRUE, FALSE, TRUE)
		//user.visible_message("Your claws extend.", "You feel your claws extending.", "You hear a sound of claws extending.")
		extended = TRUE


// Weaker feral claw weapon (compared to werewolf)
/obj/item/rogueweapon/feral_claw
	name = "feral claws"
	desc = "Sharp natural claws."
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	max_blade_int = 600
	max_integrity = 600
	force = 15 // Much weaker than werewolf (25)
	block_chance = 0
	wdefense = 1
	armor_penetration = 10 // Lower than werewolf (15)
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_SHORT
	wbalance = WBALANCE_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = "bladedsmall"
	swingsound = BLADEWOOSH_SMALL
	possible_item_intents = list(/datum/intent/unarmed/claw/feral, /datum/intent/uanrmed/claw/rend)
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL

/obj/item/rogueweapon/feral_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/feral_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/feral_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/datum/intent/unarmed/claw/feral
	name = "slash"
	icon_state = "instrike"
	attack_verb = list("slashes", "claws")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	chargetime = 0
	penfactor = 10
	swingdelay = 1
	candodge = TRUE
	canparry = TRUE
	item_d_type = "slash"


/datum/intent/uanrmed/claw/rend
	name = "rend"
	icon_state = "inrend"
	attack_verb = list("rends", "tears")
	animname = "cut"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	chargetime = 0
	penfactor = 15
	swingdelay = 1
	candodge = TRUE
	canparry = TRUE
	item_d_type = "slash"



// ============ SCORCHED STATUS EFFECTS ============

// Moon-Touched (Noc-Scorched virtue)
/datum/status_effect/moon_touched
	id = "moon_touched"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/moon_touched

/datum/status_effect/moon_touched/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_SILVER_WEAK, "moon_touched")
	ADD_TRAIT(owner, TRAIT_NOCSIGHT, "moon_touched")
	return TRUE

/datum/status_effect/moon_touched/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SILVER_WEAK, "moon_touched")
	REMOVE_TRAIT(owner, TRAIT_NOCSIGHT, "moon_touched")

/atom/movable/screen/alert/status_effect/moon_touched
	name = "Moon-Touched"
	desc = "The moonlight has awakened something primal in me. My night vision sharpens but my body burns and my mind is slipping..."
	icon_state = "nite_bad"

// Sun-Scorched (Astrata-Scorched virtue)
/datum/status_effect/sun_scorched
	id = "sun_scorched"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/sun_scorched

/datum/status_effect/sun_scorched/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, "sun_scorched")
	ADD_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, "sun_scorched")
	return TRUE

/datum/status_effect/sun_scorched/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, "sun_scorched")
	REMOVE_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, "sun_scorched")

/atom/movable/screen/alert/status_effect/sun_scorched
	name = "Sun-Scorched"
	desc = "Astrata's light burns through me. My wounds are grave, silver cuts deep, and the sun strips me of my resilience."
	icon_state = "sun_bad"

// Blood Hunger (Astrata-Scorched virtue)
/datum/status_effect/debuff/blood_hunger_t1
	id = "blood_hunger_t1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_hunger_t1
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -1)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/blood_hunger_t1
	name = "Blood Thirst"
	desc = "I'm getting thirsty... I need blood soon."
	icon_state = "debuff"

/datum/status_effect/debuff/blood_hunger_t2
	id = "blood_hunger_t2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_hunger_t2
	effectedstats = list(STATKEY_STR = -2, STATKEY_SPD = -2, STATKEY_END = -1)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/blood_hunger_t2
	name = "Severe Blood Thirst"
	desc = "The hunger grows unbearable. I NEED blood!"
	icon_state = "debuff"

/datum/status_effect/debuff/blood_hunger_t3
	id = "blood_hunger_t3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blood_hunger_t3
	effectedstats = list(STATKEY_STR = -3, STATKEY_SPD = -3, STATKEY_END = -2, STATKEY_WIL = -2)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/blood_hunger_t3
	name = "Starving for Blood"
	desc = "I'm losing control! The beast within demands blood!"
	icon_state = "debuff"

// Meat Hunger (Noc-Scorched virtue)
/datum/status_effect/debuff/meat_hunger_t1
	id = "meat_hunger_t1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/meat_hunger_t1
	effectedstats = list(STATKEY_END = -1, STATKEY_WIL = -1)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/meat_hunger_t1
	name = "Bestial Hunger"
	desc = "The beast stirs... I need raw meat."
	icon_state = "debuff"

/datum/status_effect/debuff/meat_hunger_t2
	id = "meat_hunger_t2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/meat_hunger_t2
	effectedstats = list(STATKEY_END = -2, STATKEY_WIL = -2, STATKEY_INT = -1)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/meat_hunger_t2
	name = "Ravenous Hunger"
	desc = "My thoughts turn feral. I NEED flesh!"
	icon_state = "debuff"

/datum/status_effect/debuff/meat_hunger_t3
	id = "meat_hunger_t3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/meat_hunger_t3
	effectedstats = list(STATKEY_END = -3, STATKEY_WIL = -3, STATKEY_INT = -2, STATKEY_STR = -1)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/meat_hunger_t3
	name = "Feral Starvation"
	desc = "The beast is taking over! I cannot think straight!"
	icon_state = "debuff"
