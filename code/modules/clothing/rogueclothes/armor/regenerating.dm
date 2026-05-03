// REGENERATING ARMOUR

#define COMBAT_TAG_DURATION 30 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating
	name = "regenerating armour"
	desc = "Abstract parent. Contact developer if you see this."
	icon_state = null
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR

	/// Feedback messages
	var/repairmsg_begin = "My armour begins to slowly mend its abuse.."
	var/repairmsg_continue = "My armour mends some of its abuse.."
	var/repairmsg_stop = "My armour stops mending from the onslaught!"
	var/repairmsg_end = "My armour has become taut with newfound vigor!"

	/// Combat timer that prevents you from healing while taking damage
	var/combat_timer
	/// Recursive timer that slowly regenerates the armor
	var/reptimer
	/// Time taken for regeneration
	var/repair_time = 10 SECONDS
	/// If the armor regen is stopped by a combat tag
	var/combat_taggable = FALSE

/obj/item/clothing/suit/roguetown/armor/regenerating/equipped(mob/user, slot)
	. = ..()
	UnregisterSignal(user, list(COMSIG_SPECIES_ATTACKED_BY, COMSIG_LIVING_ARMOR_CHECKED, COMSIG_MOB_APPLY_DAMGE))
	if(slot == SLOT_SHIRT || slot == SLOT_ARMOR)
		RegisterSignal(user, list(COMSIG_SPECIES_ATTACKED_BY, COMSIG_LIVING_ARMOR_CHECKED, COMSIG_MOB_APPLY_DAMGE), PROC_REF(on_attacked_by))

/// Combat tag system, makes your skin stop regenning if you are attacked by anything
/obj/item/clothing/suit/roguetown/armor/regenerating/proc/on_attacked_by(datum/source)
	SIGNAL_HANDLER
	if(!combat_taggable) // This means constant in-combat regen
		if(!reptimer && obj_integrity < max_integrity)
			reptimer = addtimer(CALLBACK(src, PROC_REF(begin_repair)), repair_time, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)
		return

	combat_timer = addtimer(CALLBACK(src, PROC_REF(begin_repair)), COMBAT_TAG_DURATION, TIMER_UNIQUE|TIMER_OVERRIDE)
	if(timeleft(reptimer))
		to_chat(loc, span_notice(repairmsg_stop))
	deltimer(reptimer)
	return

/// Start repairing the armor
/obj/item/clothing/suit/roguetown/armor/regenerating/proc/begin_repair()
	to_chat(loc, span_notice(repairmsg_begin))
	armour_regen(skip_message = TRUE)

/// Recursive loop that fixes the armor
/obj/item/clothing/suit/roguetown/armor/regenerating/proc/armour_regen(repair_percent = 0.2 * max_integrity, skip_message = FALSE)
	obj_integrity = min(obj_integrity + repair_percent, max_integrity)
	if(obj_broken)
		obj_fix(full_repair = FALSE)

	if(obj_integrity >= max_integrity)
		to_chat(loc, span_notice(repairmsg_end))
		deltimer(reptimer)
		return

	if(!skip_message)
		to_chat(loc, span_notice(repairmsg_continue))

	reptimer = addtimer(CALLBACK(src, PROC_REF(armour_regen)), repair_time, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

// SKIN ARMOUR

/obj/item/clothing/suit/roguetown/armor/regenerating/skin
	name = "regenerating skin"
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

	resistance_flags = FIRE_PROOF
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = COVERAGE_FULL
	flags_inv = null //Exposes the chest and-or breasts.
	surgery_cover = FALSE //Should permit surgery and other invasive processes.
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor_class = ARMOR_CLASS_LIGHT
	blocksound = SOFTUNDERHIT
	blade_dulling = DULLING_BASHCHOP
	armor = ARMOR_PADDED
	nudist_approved = TRUE

	repairmsg_begin = "My skin begins to slowly mend its abuse.."
	repairmsg_continue = "My skin mends some of its abuse.."
	repairmsg_stop = "My skin stops mending from the onslaught!"
	repairmsg_end = "My skin has become taut with newfound vigor!"

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/Initialize(mapload)
	..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/dropped(mob/living/carbon/human/user)
	..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple
	name = "disciple's skin"
	desc = "It's far more than just an oath. </br>'AEON, PSYDON, ADONAI - ENTROPY, HUMENITY, DIVINITY. A TRINITY THAT IS ONE, \
	YET THREE; KNOWN BY ALL, YET FORGOTTEN TO TYME.' </br>'A CORPSE. \
	I AM LIVING ON A FUCKING CORPSE. HE IS THE WORLD, AND THE WORLD IS ROTTING AWAY. \
	HEAVEN CLOSED ITS GATES TO US, LONG AGO.' </br>'YET, HIS CHILDREN PERSIST; AND AS LONG AS THEY DO, SO MUST I. \
	HAPPINESS MUST BE FOUGHT FOR.'"
	armor = list("blunt" = 30, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0) //Custom value; padded gambeson's slash- and stab- armor.
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	repair_time = 20 SECONDS
	max_integrity = 300

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/weak
	name = "tough skin"
	desc = "My skin has always been tough enough to stop most cuts and bruises, with time it will mend."
	armor = list("blunt" = 30, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0)
	max_integrity = 300
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	combat_taggable = TRUE

#undef COMBAT_TAG_DURATION
