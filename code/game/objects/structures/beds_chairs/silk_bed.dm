/obj/structure/bed/rogue/silk
	name = "silk bed"
	desc = "Soft silk bedding spread across the floor. Weave here again to add a sheltering silk veil and improve its comfort."
	icon = 'icons/roguetown/misc/silk_bed.dmi'
	icon_state = "basic"
	sleepy = 2
	max_integrity = 60
	opacity = FALSE
	debris = list(/obj/item/natural/silk = 1)
	metalizer_result = null
	attacked_sound = 'sound/foley/cloth_rip.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	/// A second weave adds the overhead silk veil and ordinary-bed comfort.
	var/upgraded = FALSE
	var/mutable_appearance/web_foreground

/obj/structure/bed/rogue/silk/Initialize(mapload)
	. = ..()
	var/datum/component/hiding_spot/hiding = GetComponent(/datum/component/hiding_spot)
	if(hiding)
		qdel(hiding)
	if(prob(50))
		static_debris = list(/obj/item/natural/silk = 1)
	refresh_silk_appearance()

/obj/structure/bed/rogue/silk/proc/upgrade()
	if(upgraded)
		return FALSE
	upgraded = TRUE
	sleepy = 3
	refresh_silk_appearance()
	return TRUE

/// Both layers tile seamlessly; neighboring beds need no shared state or processing.
/obj/structure/bed/rogue/silk/proc/refresh_silk_appearance()
	icon_state = upgraded ? "complete" : "basic"
	if(upgraded && !web_foreground)
		// Like chair armrests: escape the structure's lower plane without raising the floor silk.
		web_foreground = mutable_appearance(icon, "complete_front", ABOVE_ALL_MOB_LAYER, GAME_PLANE_UPPER)
		web_foreground.appearance_flags |= KEEP_APART
		overlays += web_foreground

/obj/structure/bed/rogue/silk/examine(mob/user)
	. = ..()
	if(upgraded)
		. += span_notice("A sheltering silk veil covers this soft bedding. It offers the comfort of a proper bed.")
	else
		. += span_notice("This floor covering offers bedroll-level comfort. Weave a silk bed here again to add a sheltering veil and improve it.")

/obj/structure/bed/rogue/silk/handle_layer()
	layer = BELOW_OBJ_LAYER

/obj/structure/bed/rogue/silk/post_buckle_mob(mob/living/M)
	. = ..()
	M.reset_offsets("bed_buckle")

// Silk has no wooden mattress to wear out independently of its integrity.
/obj/structure/bed/rogue/silk/damage_bed(dam_value)
	return

/obj/structure/bed/rogue/silk/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WRENCH)
		to_chat(user, span_notice("There are no bolts in the silk. Use a snipping tool to harvest it."))
		return TRUE
	return ..()

/obj/structure/bed/rogue/silk/attacked_by(obj/item/I, mob/living/user)
	if(user.used_intent?.type != /datum/intent/snip)
		return ..()
	var/snip_time = max(1 SECONDS, 5 SECONDS - user.get_skill_level(/datum/skill/craft/sewing) * 1 SECONDS)
	if(!do_after(user, snip_time, target = src))
		return TRUE
	if(QDELETED(src) || QDELETED(I) || !user.Adjacent(src) || user.get_active_held_item() != I)
		return TRUE
	var/turf/T = get_turf(src)
	var/amount = rand(1, 2)
	user.visible_message(span_notice("[user] snips [src] up into silk."))
	user.mind?.add_sleep_experience(/datum/skill/craft/sewing, user.STAINT / 2)
	playsound(src, 'sound/items/flint.ogg', 100, TRUE)
	qdel(src)
	for(var/i in 1 to amount)
		new /obj/item/natural/silk(T)
	return TRUE

/obj/structure/bed/rogue/silk/CanPass(atom/movable/mover, turf/target)
	if(mover in buckled_mobs)
		return TRUE
	if(isliving(mover))
		if(!HAS_TRAIT(mover, TRAIT_WEBWALK) && prob(50))
			to_chat(mover, span_warning("I get stuck in the silk for a moment."))
			return FALSE
	else if(istype(mover, /obj/projectile))
		return prob(30)
	return TRUE

/obj/structure/bed/rogue/silk/fire_act(added, maxstacks)
	var/turf/T = get_turf(src)
	visible_message(span_warning("[src] catches fire!"))
	qdel(src)
	if(T)
		new /obj/effect/hotspot(T)
