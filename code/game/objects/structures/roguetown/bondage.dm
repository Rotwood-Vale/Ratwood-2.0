/obj/structure/bondage
	name = "束具"
	desc = "一种粗糙的束具，用来把人固定在原地。"
	icon = 'icons/roguetown/misc/structure.dmi'
	anchored = TRUE
	density = TRUE
	can_buckle = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	buckle_prevents_pull = TRUE
	buckleverb = "绑上"
	breakoutextra = 4 MINUTES
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg', 'sound/combat/hits/onwood/woodimpact (2).ogg')
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 200
	resistance_flags = NONE

	var/strap_self_time = 2 SECONDS
	var/strap_other_time = 4 SECONDS

/obj/structure/bondage/Initialize(mapload)
	. = ..()
	LAZYINITLIST(buckled_mobs)

/obj/structure/bondage/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if(!anchored)
		return FALSE

	if(has_buckled_mobs())
		return FALSE

	if(force)
		return ..()

	var/mob/living/user = usr
	if(!user)
		return ..()

	if(!istype(M, /mob/living/carbon/human))
		to_chat(user, span_warning("[M.p_they()]看起来没法被这样好好固定进去！"))
		return FALSE

	if(M != user)
		var/valid_restraint = FALSE
		var/mob/living/carbon/carbon = M
		if(carbon.handcuffed)
			valid_restraint = TRUE

		if(!valid_restraint)
			for(var/obj/item/grabbing/G in M.grabbedby)
				if(G.grab_state >= GRAB_AGGRESSIVE)
					valid_restraint = TRUE
					break

		if(!valid_restraint)
			to_chat(user, span_warning("我得抓得更狠，或者先把他们束缚住，才能把人塞进[src]。"))
			return FALSE

		M.visible_message(span_danger("[user]开始把[M]绑到[src]上！"), \
			span_userdanger("[user]开始把你绑到[src]上！"))

		if(!do_after(user, strap_other_time, src))
			return FALSE
	else
		M.visible_message(span_notice("[user]开始把自己摆进[src]里……"), \
			span_notice("我开始把自己摆进[src]里……"))

		if(!do_after(user, strap_self_time, src))
			return FALSE

		// this is a *HACK* to force an layering render update, as when the mob faces the same direction as the gloryhole, they'll appear over it (remove this in the future when that bug is fixed)
		if(istype(src, /obj/structure/bondage/gloryhole) && user?.client && (dir == user.dir))
			user.setDir(dir)

	return ..(M, force, FALSE)

/obj/structure/bondage/chains
	name = "锁链"
	desc = "用螺栓牢牢固定住的沉重锁链。"
	icon_state = "CHAINS"
	base_pixel_x = 0
	base_pixel_y = 0
	pixel_x = 0
	pixel_y = 0
	density = FALSE
	layer = ABOVE_MOB_LAYER
	attacked_sound = list('sound/combat/hits/onmetal/metalimpact (1).ogg', 'sound/combat/hits/onmetal/metalimpact (2).ogg')
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	buckleverb = "锁上"

/obj/structure/bondage/x_pillory
	name = "十字刑架"
	desc = "一个十字形的残酷束缚架。"
	icon_state = "x_pillory"
	layer = OBJ_LAYER
	plane = GAME_PLANE
	var/buckle_offset_x = 0
	var/buckle_offset_y = 2

/obj/structure/bondage/x_pillory/post_buckle_mob(mob/living/M)
	. = ..()
	M.set_mob_offsets("bed_buckle", _x = buckle_offset_x, _y = buckle_offset_y)

/obj/structure/bondage/x_pillory/post_unbuckle_mob(mob/living/M)
	. = ..()
	M.reset_offsets("bed_buckle")

/obj/structure/bondage/x_pillory/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	// Someone else is unbuckling the victim
	if(user != buckled_mob)
		user.visible_message(span_notice("[user]开始把[buckled_mob]从[src]上解下来……"), \
			span_notice("你开始把[buckled_mob]从[src]上解下来……"))
		if(do_after(user, 3 SECONDS, src))
			return ..()
		return

	// Victim trying to unbuckle self
	to_chat(user, span_warning("你奋力挣扎着对抗那些勒紧的绑带……"))
	if(do_after(user, 10 SECONDS, src))
		user.visible_message(span_warning("[user]设法把自己从[src]上解开了！"), \
			span_notice("你设法把自己从[src]上解开了！"))
		return ..()

/obj/structure/bondage/gloryhole
	name = "木隔板"
	desc = "一块开了可疑孔洞的木制隔板。"
	icon_state = "gloryhole"
	dir = SOUTH
	density = TRUE
	layer = MOB_LAYER
	plane = GAME_PLANE
	buckleverb = "摆上"
	var/buckle_offset_x = 0
	var/buckle_offset_y = 1

/obj/structure/bondage/gloryhole/examine(mob/user)
	. = ..()
	if(isobserver(user))
		return
	. += "右键可走到[src]前。"

/obj/structure/bondage/gloryhole/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if(M && ishuman(M) && !has_buckled_mobs())
		if(loc != M?.loc)
			to_chat(M, span_warning("我得再靠近一点才能对着[src]就位。"))
			return FALSE
	return ..()

/obj/structure/bondage/gloryhole/post_buckle_mob(mob/living/M)
	. = ..()
	M.set_mob_offsets("bed_buckle", _x = buckle_offset_x, _y = buckle_offset_y)
	M.layer = LYING_MOB_LAYER
	M.plane = GAME_PLANE_LOWER

/obj/structure/bondage/gloryhole/post_unbuckle_mob(mob/living/M)
	. = ..()
	M.reset_offsets("bed_buckle")
	M.plane = initial(M.plane)

/obj/structure/bondage/gloryhole/attack_right(mob/living/user)
	. = ..()
	if(!ishuman(user) || !(user.mobility_flags & MOBILITY_STAND)) // must be standing
		return

	if(.)
		return
	var/adir = get_dir(loc, user)
	switch(adir)
		if(EAST)
			animate(user, pixel_x = -28, time = 2.7)
		if(SOUTH)
			animate(user, pixel_y = 26, time = 2.7)
		if(WEST)
			animate(user, pixel_x = 28, time = 2.7)
		else
			return
	user.is_shifted = TRUE
	user.passthroughable |= (NORTH | EAST | SOUTH | WEST)

/obj/structure/bondage/gloryhole/CanPass(atom/movable/mover, turf/target)
	if(has_buckled_mobs())
		return FALSE
	return get_dir(loc, mover) != dir

/obj/structure/bondage/gloryhole/Initialize(mapload)
	. = ..()
	init_connect_loc_element()

/obj/structure/bondage/gloryhole/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	if(!has_buckled_mobs() || !ishuman(dragged))
		return ..()
	var/mob/living/buckled_user = locate() in buckled_mobs
	if(isnull(buckled_user) || !istype(buckled_user)) // nobody's home, abort
		return ..()
	if((buckled_user == user) && ishuman(user) && ishuman(dragged) && !user.mmb_intent) // if buckled mob middle click dragged onto non-gloryhole buckled mob, open sexcon
		dragged.MiddleMouseDrop_T(user, user)
		return
	if((dragged == user) && ishuman(user) && !user.mmb_intent) // if non-buckled mob middle click dragged onto gloryhole buckled mob, open sexcon
		buckled_user.MiddleMouseDrop_T(user, user)
		return
	return ..()

/obj/structure/bondage/gloryhole/proc/init_connect_loc_element()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/bondage/gloryhole/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER

	if(dir in CORNERDIRS)
		return

	if(isobserver(leaving))
		return

	if(get_dir(leaving.loc, new_location) != dir)
		return

	leaving.Bump(src)
	return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/bondage/torture_table
	name = "刑讯台"
	desc = "一张专门用来束缚俘虏的残酷桌台。"
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "tort_table"
	base_pixel_x = -16
	base_pixel_y = 0
	pixel_x = -16
	pixel_y = 0
	layer = TABLE_LAYER
	plane = GAME_PLANE
	buckle_lying = 90
	breakoutextra = 2 MINUTES
	max_integrity = 250
	debris = list(/obj/item/natural/wood/plank = 1)
	var/buckle_offset_y = 8

/obj/structure/bondage/torture_table/post_buckle_mob(mob/living/M)
	. = ..()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = buckle_offset_y)

/obj/structure/bondage/torture_table/post_unbuckle_mob(mob/living/M)
	. = ..()
	M.reset_offsets("bed_buckle")

/obj/structure/bondage/torture_table/user_unbuckle_mob(mob/living/buckled_mob, mob/living/user)
	// Someone else is unbuckling the victim
	if(user != buckled_mob)
		user.visible_message(span_notice("[user]开始把[buckled_mob]从[src]上解链下来……"), \
			span_notice("你开始把[buckled_mob]从[src]上解链下来……"))
		if(do_after(user, 3 SECONDS, src))
			return ..()
		return

	// Victim trying to unbuckle self (long struggle)
	to_chat(user, span_warning("你奋力挣扎着对抗那些勒紧的锁链……"))
	if(do_after(user, 3 MINUTES, src))
		user.visible_message(span_warning("[user]设法把自己从[src]上挣脱了！"), \
			span_notice("你设法把自己从[src]上挣脱了！"))
		return ..()

/obj/structure/bondage/torture_table/lever
	name = "刑讯台拉杆"
	desc = "一张带有内置拉杆机构的刑讯台。右键使用拉杆。"
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "tort_table_lever"

/obj/structure/bondage/torture_table/lever/attack_right(mob/user)
	. = ..()
	if(.)
		return
	if(!has_buckled_mobs())
		to_chat(user, span_warning("这里没人能让你继续拧紧锁链……"))
		return
	var/mob/living/L = locate() in buckled_mobs
	if(!L)
		return
	if(user == L)
		to_chat(user, span_warning("我够不到拉杆……"))
		return
	playsound(src, 'sound/foley/winch.ogg', 100, extrarange = 3)
	user.visible_message(span_warning("[user]开始收紧束在[L]身上的锁链！"), span_warning("你开始收紧锁链！"))
	if(do_after(user, 2 SECONDS, src))
		var/mob/living/L_double_check = locate() in buckled_mobs
		if(!L_double_check || L != L_double_check) // they got off, abort
			return
		var/def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
		var/obj/item/bodypart/BP = L.get_bodypart(def_zone)
		if(BP)
			L.visible_message(span_boldwarning("锁链猛地收紧，撕进了[L]的[BP.name]！"), span_userdanger("锁链撕进了我的[BP.name]！"))
			L.emote("agony")
			BP.add_wound(/datum/wound/fracture)
			BP.update_disabled()
			L.apply_damage(90, BRUTE, def_zone)
			L.Paralyze(80)
