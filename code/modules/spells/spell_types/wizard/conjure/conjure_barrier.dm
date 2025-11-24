//Sojourner exclusive. Meant to facilitate being super protected from magic. Don't hand this out.
//Full anti-magic, with a unique trait to allow the user to cast under the effects of it.
/obj/effect/proc_holder/spell/self/conjure_armor/barrier
	name = "Conjure Barrier"
	desc = "Conjure an arcyne barrier. Granting long-lasting protection from attacks of an arcyne nature. Your armor slot must be free to use this.\n\
	The barrier lasts until it is broken, a new one is summoned, or the spell is forgotten."
	overlay_state = "DEFY"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 50
	chargedrain = 1
	chargetime = 3 SECONDS
	no_early_release = TRUE
	recharge_time = 3 MINUTES

	warnie = "spellwarning"
	no_early_release = TRUE
	antimagic_allowed = FALSE
	charging_slowdown = 3

	invocations = list("Fatum deterritum!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cost = 3
	spell_tier = 4

	objtoequip = /obj/item/clothing/suit/roguetown/arcyne_barrier
	slottoequip = SLOT_ARMOR
	checkspot = "armor"

/obj/effect/proc_holder/spell/self/conjure_armor/barrier/Destroy()
	if(src.conjured_armor)
		conjured_armor.visible_message(span_warning("The [conjured_armor]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(conjured_armor)
	return ..()

/obj/item/clothing/suit/roguetown/arcyne_barrier
	name = "arcyne barrier"
	desc = "An art mastered by Naledi Sojourners. To forego protection in favour of dispersion. \
	A barrier against the winds of fate, powered by their own spark. \
	Magyks will have no effect upon the wearer."
	max_integrity = 25//Intended to be easy to break.
	break_sound = 'modular_azurepeak/sound/spellbooks/crystal.ogg'
	drop_sound = 'modular_azurepeak/sound/spellbooks/glass.ogg'
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "DEFY"
	slot_flags = ITEM_SLOT_ARMOR
	mob_overlay_icon = null
	sleeved = null
	boobed = FALSE
	flags_inv = null
	armor_class = ARMOR_CLASS_LIGHT
	blade_dulling = DULLING_BASHCHOP
	blocksound = PLATEHIT
	armor = ARMOR_BARRIER//20 across the board, except fire and acid, get 30.
	body_parts_covered = COVERAGE_FULL | COVERAGE_HEAD_NOSE | NECK | HANDS | FEET

/obj/item/clothing/suit/roguetown/arcyne_barrier/equipped(mob/living/user)
	. = ..()
	if(!QDELETED(src))
		user.apply_status_effect(/datum/status_effect/buff/arcyne_barrier)

/obj/item/clothing/suit/roguetown/arcyne_barrier/proc/dispel()
	if(!QDELETED(src))
		src.visible_message(span_warning("The [src]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(src)

/obj/item/clothing/suit/roguetown/arcyne_barrier/obj_break()
	. = ..()
	if(!QDELETED(src))
		dispel()

/obj/item/clothing/suit/roguetown/arcyne_barrier/attack_hand(mob/living/user)
	. = ..()
	if(!QDELETED(src))
		dispel()

/obj/item/clothing/suit/roguetown/arcyne_barrier/dropped(mob/living/user)
	. = ..()
	user.remove_status_effect(/datum/status_effect/buff/arcyne_barrier)
	if(!QDELETED(src))
		dispel()

#define ARCBARRIER_FILTER "arcyne_barrier"

/datum/status_effect/buff/arcyne_barrier
	id = "arcyne_barrier"
	alert_type = /atom/movable/screen/alert/status_effect/buff/arcyne_barrier
	duration = -1
	examine_text = "<font color='blue'>SUBJECTPRONOUN is wreathed by sparks of the arcyne!"
	var/outline_colour = "#12f0f0"

/atom/movable/screen/alert/status_effect/buff/arcyne_barrier
	name = "Arcyne Barrier"
	desc = "The spark of the arcyne surrounds me, protecting my form from the winds of fate!"

/datum/status_effect/buff/arcyne_barrier/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_SPELL_DISPERSION, MAGIC_TRAIT)

	var/filter = owner.get_filter(ARCBARRIER_FILTER)
	if (!filter)
		owner.add_filter(ARCBARRIER_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))

/datum/status_effect/buff/arcyne_barrier/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_SPELL_DISPERSION, MAGIC_TRAIT)
	owner.remove_filter(ARCBARRIER_FILTER)
