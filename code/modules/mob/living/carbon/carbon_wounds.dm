/mob/living/carbon/get_embedded_objects()
	. = ..()
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(!length(bodypart.embedded_objects))
			continue
		. += bodypart.embedded_objects

#define EMBEDDED_LEG_ARROW_SLOWDOWN 0.5
#define EMBEDDED_LEG_ARROW_SLOWDOWN_MAX 1.5

/// Arrows lodged in the legs slow us down until they're pulled out.
/mob/living/carbon/proc/update_embedded_leg_slowdown()
	var/arrows = 0
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(!(bodypart.body_zone in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_TAUR)))
			continue
		for(var/obj/item/embedded as anything in bodypart.embedded_objects)
			if(istype(embedded, /obj/item/ammo_casing/caseless/rogue/arrow))
				arrows++
	if(!arrows)
		remove_movespeed_modifier(MOVESPEED_ID_EMBEDDED_LEG_ARROWS)
		return
	var/slowdown = min(arrows * EMBEDDED_LEG_ARROW_SLOWDOWN, EMBEDDED_LEG_ARROW_SLOWDOWN_MAX)
	add_movespeed_modifier(MOVESPEED_ID_EMBEDDED_LEG_ARROWS, update = TRUE, priority = 100, override = TRUE, multiplicative_slowdown = slowdown, movetypes = GROUND)

#undef EMBEDDED_LEG_ARROW_SLOWDOWN
#undef EMBEDDED_LEG_ARROW_SLOWDOWN_MAX

/// Redraws objects lodged in this mob. Only humans draw them.
/mob/living/carbon/proc/update_embedded_arrow_overlays(facing, from_turn = FALSE)
	return

/// Which side of us `origin` lies on, relative to the way we're facing (EMBED_ENTRY_*).
/mob/living/proc/get_embed_entry_side(atom/origin)
	var/from_dir = origin ? get_dir(src, origin) : NONE
	if(!from_dir || (from_dir & dir))
		return EMBED_ENTRY_FRONT
	if(from_dir & REVERSE_DIR(dir))
		return EMBED_ENTRY_BACK
	return (from_dir & turn(dir, 90)) ? EMBED_ENTRY_LEFT : EMBED_ENTRY_RIGHT

/mob/living/carbon/get_wounds()
	. = ..()
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(!length(bodypart.wounds))
			continue
		. += bodypart.wounds
