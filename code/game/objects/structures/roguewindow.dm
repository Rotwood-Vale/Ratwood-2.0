
/obj/structure/roguewindow
	name = "window"
	desc = "A glass window."
	icon = 'icons/roguetown/misc/roguewindow.dmi'
	icon_state = "window-solid"
	layer = TABLE_LAYER
	density = TRUE
	anchored = TRUE
	opacity = FALSE
	max_integrity = 200
	integrity_failure = 0.5
	var/base_state = "window-solid"
	var/lockdir = 0
	var/brokenstate = 0
	blade_dulling = DULLING_BASHCHOP
	pass_flags = LETPASSTHROW
	climb_time = 20
	climb_offset = 10
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	break_sound = "glassbreak"
	destroy_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	var/window_lock_strength
	var/list/repair_costs = list(/obj/item/grown/log/tree/small, /obj/item/natural/glass)
	var/repair_skill = /datum/skill/craft/carpentry
	var/repair_started = FALSE

/obj/structure/roguewindow/Initialize()
	update_icon()
	..()

/obj/structure/roguewindow/obj_destruction(damage_flag)
	..()

/obj/structure/roguewindow/attacked_by(obj/item/I, mob/living/user)
	..()
	if(obj_broken || obj_destroyed)
		var/obj/effect/track/structure/new_track = SStracks.get_track(/obj/effect/track/structure, get_turf(src))
		message_admins("Window [obj_destroyed ? "destroyed" : "broken"] by [user?.real_name] using [I] [ADMIN_JMP(src)]")
		log_admin("Window [obj_destroyed ? "destroyed" : "broken"] by [user?.real_name] at X:[src.x] Y:[src.y] Z:[src.z] in area: [get_area(src)]")
		new_track.handle_creation(user)

/obj/structure/roguewindow/update_icon()
	if(brokenstate)
		icon_state = "[base_state]br"
		return
	icon_state = "[base_state]"

/obj/structure/roguewindow/proc/repairwindow(obj/item/I, mob/user)
	if(brokenstate)
		if(!repair_started)
			if(istype(I, repair_costs[1]))
				user.visible_message(span_notice("[user] starts repairing [src]."), \
				span_notice("I start repairing [src]."))
				playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
				if(do_after(user, (300 / user.get_skill_level(repair_skill)), target = src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
					qdel(I)
					playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
					repair_started = TRUE
					var/obj/cast_repair_cost_second = repair_costs[2]
					to_chat(user, span_notice("An additional [initial(cast_repair_cost_second.name)] is needed to finish the job."))
		else if(istype(I, repair_costs[2]))
			user.visible_message(span_notice("[user] starts repairing [src]."), \
			span_notice("I start repairing [src]."))
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			if(do_after(user, (300 / user.get_skill_level(repair_skill)), target = src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
				qdel(I)
				playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
				icon_state = "[base_state]"
				density = TRUE
				climbable = FALSE
				brokenstate = FALSE
				obj_broken = FALSE
				opacity = initial(opacity)
				obj_integrity = max_integrity
				repair_started = FALSE
				user.visible_message(span_notice("[user] repaired [src]."), \
				span_notice("I repaired [src]."))
	else if(obj_integrity < max_integrity && istype(I, repair_costs[1]))
		to_chat(user, span_warning("[obj_integrity]"))
		user.visible_message(span_notice("[user] starts repairing [src]."), \
		span_notice("I start repairing [src]."))
		playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		if(do_after(user, (300 / user.get_skill_level(repair_skill)), target = src)) // 1 skill = 30 secs, 2 skill = 15 secs etc.
			qdel(I)
			playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
			obj_integrity = obj_integrity + (max_integrity/2)
			if(obj_integrity > max_integrity)
				obj_integrity = max_integrity
			user.visible_message(span_notice("[user] repaired [src]."), \
			span_notice("I repaired [src]."))

/obj/structure/roguewindow/openclose/OnCrafted(dirin)
	dirin = turn(dirin, 180)
	lockdir = dirin
	. = ..(dirin)

/obj/structure/roguewindow/stained
	icon_state = null
	base_state = null
	opacity = TRUE
	max_integrity = 200
	integrity_failure = 0.5
	repair_costs = list(/obj/item/natural/glass, /obj/item/natural/glass)

/obj/structure/roguewindow/stained/silver
	icon_state = "stained-silver"
	base_state = "stained-silver"

/obj/structure/roguewindow/stained/yellow
	icon_state = "stained-yellow"
	base_state = "stained-yellow"

/obj/structure/roguewindow/stained/zizo
	icon_state = "stained-zizo"
	base_state = "stained-zizo"

/obj/structure/roguewindow/openclose
	icon_state = "woodwindowdir"
	base_state = "woodwindow"
	opacity = TRUE
	max_integrity = 200
	integrity_failure = 0.5
	window_lock_strength = 100

/obj/structure/roguewindow/openclose/OnCrafted(dirin)
	dir = turn(dirin, 180)
	lockdir = dir

/obj/structure/roguewindow/openclose/Initialize()
	..()
	lockdir = dir
	icon_state = base_state

/obj/structure/roguewindow/openclose/reinforced
	desc = "A glass window. This one looks reinforced with a metal mesh."
	icon_state = "reinforcedwindowdir"
	base_state = "reinforcedwindow"
	max_integrity = 800
	integrity_failure = 0.1
	window_lock_strength = 150
	repair_costs = list(/obj/item/ingot/iron, /obj/item/natural/glass)

/obj/structure/roguewindow/openclose/reinforced/OnCrafted(dirin)
	dir = turn(dirin, 180)
	lockdir = dir

/obj/structure/roguewindow/openclose/reinforced/Initialize()
	..()
	lockdir = dir
	icon_state = base_state

/obj/structure/roguewindow/openclose/reinforced/brick
	desc = "A glass window. This one looks reinforced with a metal frame."
	icon_state = "brickwindowdir"
	base_state = "brickwindow"
	max_integrity = 1000	//Better than reinforced by a bit; metal frame.

/obj/structure/roguewindow/openclose/reinforced/brick/OnCrafted(dirin)
	dir = turn(dirin, 180)
	lockdir = dir

/obj/structure/roguewindow/openclose/reinforced/brick/Initialize()
	..()
	lockdir = dir
	icon_state = base_state

/obj/structure/roguewindow/harem1
	name = "harem window"
	icon_state = "harem1-solid"
	base_state = "harem1-solid"
	repair_costs = list(/obj/item/natural/glass, /obj/item/natural/glass)

/obj/structure/roguewindow/harem2
	name = "harem window"
	icon_state = "harem2-solid"
	base_state = "harem2-solid"
	opacity = TRUE
	repair_costs = list(/obj/item/natural/glass, /obj/item/natural/glass)

/obj/structure/roguewindow/harem3
	name = "harem window"
	icon_state = "harem3-solid"
	base_state = "harem3-solid"
	repair_costs = list(/obj/item/natural/glass, /obj/item/natural/glass)

/obj/structure/roguewindow/openclose/Initialize()
	lockdir = dir
	icon_state = base_state
	GLOB.TodUpdate += src
	..()

/obj/structure/roguewindow/openclose/Destroy()
	GLOB.TodUpdate -= src
	return ..()

/obj/structure/roguewindow/openclose/update_tod(todd)
	update_icon()

/obj/structure/roguewindow/openclose/update_icon()
	var/isnight = FALSE
	if(GLOB.tod == "night")
		isnight = TRUE
	if(brokenstate)
		if(isnight)
			icon_state = "[base_state]br"
		else
			icon_state = "w-[base_state]br"
		return
	if(climbable)
		if(isnight)
			icon_state = "[base_state]op"
		else
			icon_state = "w-[base_state]op"
	else
		if(isnight)
			icon_state = "[base_state]"
		else
			icon_state = "w-[base_state]"

/obj/structure/roguewindow/openclose/attack_right(mob/user)
	var/mob/living/carbon/human/opener = user
	var/obj/item/held_knife = user.get_active_held_item()
//	var/lockpicking_check
	var/lockpicking_check_done
	if(get_dir(src,user) == lockdir)
		if(brokenstate)
			to_chat(user, span_warning("It's broken, that would be foolish."))
			return
		if(climbable)
			close_up(user)
		else
			open_up(user)
	else if(!(get_dir(src,user) == lockdir) && (istype(held_knife, /obj/item/rogueweapon/huntingknife)))
		var/lockprogress = 0
		var/locktreshold = window_lock_strength

		var/pickskill = user.get_skill_level(/datum/skill/misc/lockpicking)
		var/perbonus = opener.STAPER/4
		var/speedbonus = opener.STASPD/4
		var/picktime = 100
		var/pickchance = 10
		var/moveup = 10
		var/break_me = max_integrity * integrity_failure - 5
		var/bonus_on_closing = 1
		if(climbable)
			bonus_on_closing = 1.1

		picktime -= (pickskill * 8 + perbonus * 5 + speedbonus * 5 + held_knife.picklvl * 2)
		picktime = clamp(picktime, 20, 70)

		moveup += (pickskill * 6 + perbonus + speedbonus/2 + held_knife.picklvl * 2)
		moveup = clamp(moveup, 10, 100)

		pickchance += pickskill * 11 + perbonus * 4 + speedbonus * 3
		pickchance *= held_knife.picklvl
		pickchance *= bonus_on_closing
		pickchance = clamp(pickchance, 1, 96)

		if(brokenstate)
			to_chat(user, span_warning("It's broken, that would be foolish."))
			return
		else
			if(!climbable)
				to_chat(user, ("<span class='deadsay'>I slide [held_knife] through [src] seal...</span>"))
			while(!QDELETED(held_knife) && (lockprogress < locktreshold))
				if(!do_after(user, picktime, target = src))
					break
				if(prob(pickchance))
					lockprogress += moveup
					playsound(src.loc, pick('sound/items/pickgood1.ogg','sound/items/pickgood2.ogg'), 5, TRUE)
					to_chat(user, "<span class='warning'>Click... [pickchance]% chance to succeed...</span>")
					if(user.mind)
						add_sleep_experience(opener, /datum/skill/misc/lockpicking, opener.STAINT/2)
					if(lockprogress >= locktreshold)
						record_featured_stat(FEATURED_STATS_CRIMINALS, user)
						GLOB.azure_round_stats[STATS_LOCKS_PICKED]++
						lockpicking_check_done = 1
						break
					else
						continue
				else
					playsound(loc, 'sound/items/pickbad.ogg', 40, TRUE)
					obj_integrity = break_me
					held_knife.take_damage(10, BRUTE, "blunt")
					to_chat(user, "<span class='warning'>Clack. [100 - pickchance]% chance to fuck up.</span>")
					add_sleep_experience(opener, /datum/skill/misc/lockpicking, opener.STAINT/4)
					playsound(src, break_sound, 100)
					log_admin("Window broken at X:[src.x] Y:[src.y] Z:[src.z] in area: [get_area(src)]")
					loud_message("A loud crash of a window getting broken rings out", hearing_distance = 14)
					new /obj/item/natural/glass_shard (get_turf(src))
					new /obj/effect/decal/cleanable/debris/glassy(get_turf(src))
					brokenstate = TRUE
					climbable = TRUE
					opacity = FALSE
					update_icon()
					var/obj/effect/track/structure/new_track = new(get_turf(src))
					new_track.handle_creation(user)
					user.visible_message(
						span_warning("[user] fucks up! The window is broken!!"),
						span_danger("I fucked up!! FUCK!!"))
					return

			if(climbable && (lockpicking_check_done == 1))
				close_up(user)
				user.visible_message(
					span_notice("[user] closes the window!!"),
					span_notice("I close the window!"))
			else if(!climbable && (lockpicking_check_done == 1))
				to_chat(user, "<span class='deadsay'>The locking mechanism gives...</span>")
				var/obj/effect/track/structure/new_track = new(get_turf(src))
				new_track.handle_creation(user)
				open_up(user)
				user.visible_message(
					span_notice("[user] pries open [src] with [held_knife]!!"),
					span_notice("I pry [src] open!"))
	else
		to_chat(user, span_warning("The window doesn't close from this side."))

/obj/structure/roguewindow/proc/open_up(mob/user)
	visible_message(span_info("[user] opens [src]."))
	playsound(src, 'sound/foley/doors/windowup.ogg', 100, FALSE)
	climbable = TRUE
	opacity = FALSE
	update_icon()

/obj/structure/roguewindow/proc/force_open()
	playsound(src, 'sound/foley/doors/windowup.ogg', 100, FALSE)
	climbable = TRUE
	opacity = FALSE
	update_icon()

/obj/structure/roguewindow/proc/close_up(mob/user)
	visible_message(span_info("[user] closes [src]."))
	playsound(src, 'sound/foley/doors/windowdown.ogg', 100, FALSE)
	climbable = FALSE
	opacity = TRUE
	update_icon()


/obj/structure/roguewindow/CanAStarPass(ID, to_dir, caller)
	. = ..()
	var/atom/movable/mover = caller
	if(!. && istype(mover) && (mover.pass_flags & PASSTABLE) && climbable)
		return TRUE

/obj/structure/roguewindow/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSTABLE) && climbable)
		return 1
	if(isliving(mover))
		if(mover.throwing)
			if(!climbable)
				if(!iscarbon(mover))
					take_damage(10)
				else
					var/mob/living/carbon/dude = mover
					var/base_damage = 20
					take_damage(base_damage * (dude.STASTR / 10))
			if(brokenstate || climbable)
				if(ishuman(mover))
					var/mob/living/carbon/human/dude = mover
					if(prob(100 - clamp((dude.get_skill_level(/datum/skill/misc/athletics) + dude.get_skill_level(/datum/skill/misc/climbing)) * 10 - (!dude.is_jumping * 30), 10, 100)))
						var/obj/item/bodypart/head/head = dude.get_bodypart(BODY_ZONE_HEAD)
						head.receive_damage(20)
						dude.Stun(5 SECONDS)
						dude.Knockdown(5 SECONDS)
						dude.add_stress(/datum/stressevent/hithead)
						dude.visible_message(
							span_warning("[dude] hits their head as they fly through the window!"),
							span_danger("I hit my head on the window frame!"))
				return 1
	else if(isitem(mover))
		var/obj/item/I = mover
		if(I.throwforce >= 10)
			take_damage(I.throwforce)
			if(brokenstate)
				return 1
		else
			return !density
	return ..()

/obj/structure/roguewindow/attackby(obj/item/W, mob/user, params)
	if(user.get_skill_level(repair_skill) > 0 && (istype(W, repair_costs[1]) || istype(W, repair_costs[2]))) // At least 1 skill level needed
		repairwindow(W, user)
	else
		return ..()

/obj/structure/roguewindow/attack_paw(mob/living/user)
	attack_hand(user)

/obj/structure/roguewindow/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(brokenstate)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(HAS_TRAIT(user, TRAIT_BASHDOORS))
		src.take_damage(15)
		return
	src.visible_message(span_info("[user] knocks on [src]."))
	add_fingerprint(user)
	playsound(src, 'sound/misc/glassknock.ogg', 100)

/obj/structure/roguewindow/obj_break(damage_flag)
	if(!brokenstate)
		attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
		log_admin("Window broken at X:[src.x] Y:[src.y] Z:[src.z] in area: [get_area(src)]")
		loud_message("A loud crash of a window getting broken rings out", hearing_distance = 14)
		new /obj/item/natural/glass_shard (get_turf(src))
		new /obj/effect/decal/cleanable/debris/glassy(get_turf(src))
		climbable = TRUE
		brokenstate = TRUE
		opacity = FALSE
	update_icon()
	..()


/obj/structure/roguewindow/examine(mob/user)
	. = ..()
	var/obj/cast_repair_cost_first = repair_costs[1]
	var/obj/cast_repair_cost_second = repair_costs[2]
	if((!repair_started) && (obj_integrity < max_integrity))
		. += span_notice("A [initial(cast_repair_cost_first.name)] can be used to repair it.")
		if(brokenstate)
			. += span_notice("An additional [initial(cast_repair_cost_second.name)] is needed to finish repairs.")
	if(repair_started)
		. += span_notice("An additional [initial(cast_repair_cost_second.name)] is needed to finish repairs.")
