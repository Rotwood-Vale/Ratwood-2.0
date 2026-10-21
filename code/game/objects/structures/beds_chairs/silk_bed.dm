/obj/structure/bed/rogue/silk
	name = "silk bed"
	desc = "A shallow nest of woven silk. Web every surrounding floor tile to make it more comfortable."
	icon = 'icons/roguetown/misc/silk_bed.dmi'
	icon_state = "basic"
	sleepy = 2
	max_integrity = 60
	opacity = FALSE
	debris = list(/obj/item/natural/silk = 1)
	metalizer_result = null
	attacked_sound = 'sound/foley/cloth_rip.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	var/required_web_tiles = 0
	var/webbed_tiles = 0
	var/mutable_appearance/web_backdrop

/obj/structure/bed/rogue/silk/Initialize(mapload)
	. = ..()
	var/datum/component/hiding_spot/hiding = GetComponent(/datum/component/hiding_spot)
	if(hiding)
		qdel(hiding)
	if(prob(50))
		static_debris = list(/obj/item/natural/silk = 1)
	refresh_comfort()
	START_PROCESSING(SSobj, src)

/obj/structure/bed/rogue/silk/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/bed/rogue/silk/process(seconds_per_tick)
	refresh_comfort()

/// A bounded local scan also handles turf replacement and moved/deleted webs.
/obj/structure/bed/rogue/silk/proc/refresh_comfort()
	required_web_tiles = 0
	webbed_tiles = 0
	if(isturf(loc))
		for(var/turf/T in RANGE_TURFS(1, loc))
			if(T == loc || !isfloorturf(T))
				continue
			required_web_tiles++
			for(var/obj/structure/spider/stickyweb/web in T)
				if(QDELETED(web))
					continue
				webbed_tiles++
				break
	var/complete = required_web_tiles > 0 && webbed_tiles == required_web_tiles
	sleepy = complete ? 3 : 2
	icon_state = complete ? "complete" : "basic"
	var/backdrop_alpha = complete ? 200 : 100
	if(!web_backdrop || web_backdrop.alpha != backdrop_alpha)
		if(web_backdrop)
			underlays -= web_backdrop
		// Only the backdrop uses web transparency; the cocoon artwork stays intact.
		web_backdrop = mutable_appearance('modular/Mapping/icons/webbing.dmi', "stickyweb1", alpha = backdrop_alpha)
		underlays += web_backdrop


/obj/structure/bed/rogue/silk/examine(mob/user)
	refresh_comfort()
	. = ..()
	if(sleepy == 3)
		. += span_notice("The surrounding webbing makes this nest as comfortable as a proper bed.")
	else
		. += span_notice("This nest is as comfortable as a bedroll. [webbed_tiles] of [required_web_tiles] surrounding floor tiles are webbed; at least one is needed.")

/obj/structure/bed/rogue/silk/handle_layer()
	layer = BELOW_MOB_LAYER

/obj/structure/bed/rogue/silk/post_buckle_mob(mob/living/M)
	. = ..()
	M.reset_offsets("bed_buckle")
	refresh_comfort()

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
