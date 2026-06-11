/obj/structure/plasticflaps
	name = "铁栏杆"
	desc = "看起来相当锈。"
	gender = PLURAL
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "bars_passage"
	density = FALSE
	anchored = TRUE
	CanAtmosPass = ATMOS_PASS_NO
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")

/obj/structure/plasticflaps/opaque
	opacity = TRUE

/obj/structure/plasticflaps/Initialize(mapload)
	. = ..()
	alpha = 0
	SSvis_overlays.add_vis_overlay(src, icon, icon_state, ABOVE_MOB_LAYER, plane, dir, add_appearance_flags = RESET_ALPHA) //you see mobs under it, but you hit them like they are above it

/obj/structure/plasticflaps/examine(mob/user)
	. = ..()
	if(anchored)
		. += span_notice("[src]被<b>拧</b>在了地板上。")
	else
		. += span_notice("[src]已经不再<i>拧</i>在地板上了，现在可以把这些栏杆<b>拆开</b>。")

/obj/structure/plasticflaps/screwdriver_act(mob/living/user, obj/item/W)
	if(..())
		return TRUE
	add_fingerprint(user)
	var/action = anchored ? "把[src]从地板上拧下来" : "把[src]拧到地板上"
	var/uraction = anchored ? "把[src]从地板上拧下来" : "把[src]拧到地板上"
	user.visible_message(span_warning("[user]开始[action]。"), span_notice("我开始[uraction]……"), span_hear("我听见一阵金属摩擦声。"))
	if(W.use_tool(src, user, 100, volume=100, extra_checks = CALLBACK(src, PROC_REF(check_anchored_state), anchored)))
		setAnchored(!anchored)
		to_chat(user, span_notice("我[anchored ? "把[src]从地板上拧下来了" : "把[src]拧到地板上了"]。"))
		return TRUE
	else
		return TRUE

/obj/structure/plasticflaps/proc/check_anchored_state(check_anchored)
	if(anchored != check_anchored)
		return FALSE
	return TRUE

/obj/structure/plasticflaps/CanAStarPass(ID, to_dir, caller)
	if(isliving(caller))
		var/mob/living/M = caller
		if(!M.ventcrawler && M.mob_size != MOB_SIZE_TINY)
			return FALSE
	var/atom/movable/M = caller
	if(M && M.pulling)
		return CanAStarPass(ID, to_dir, M.pulling)
	return TRUE //diseases, stings, etc can pass

/obj/structure/plasticflaps/CanPass(atom/movable/A, turf/T)
	if(istype(A) && (A.pass_flags & PASSGLASS))
		return prob(60)

	var/obj/structure/bed/B = A
	if(istype(A, /obj/structure/bed) && (B.has_buckled_mobs() || B.density))//if it's a bed/chair and is dense or someone is buckled, it will not pass
		return FALSE

	else if(isliving(A)) // You Shall Not Pass!
		var/mob/living/M = A
		if((M.mobility_flags & MOBILITY_STAND) && !M.ventcrawler && M.mob_size != MOB_SIZE_TINY)	//If your not laying down, or a ventcrawler or a small creature, no pass.
			return FALSE
	return ..()

/obj/structure/plasticflaps/Initialize(mapload)
	. = ..()
	air_update_turf(TRUE)

/obj/structure/plasticflaps/Destroy()
	var/atom/oldloc = loc
	. = ..()
	if (oldloc)
		oldloc.air_update_turf(1)
