/obj/effect/proc_holder/spell/invoked/wheel
	name = "The Wheel"
	desc = "Spins the wheel, either buffing or debuffing the targets fortune."
	overlay_state = "wheel" //Wheel of Fortune
	releasedrain = 10
	chargedrain = 0
	chargetime = 3
	range = 1
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/misc/letsgogambling.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 MINUTES

/obj/effect/proc_holder/spell/invoked/wheel/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.apply_status_effect(/datum/status_effect/wheel)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/ventriloquism
	name = "Ventriloquism"
	desc = "Throw one's voice into a object"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "ventril"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 1
	no_early_release = TRUE
	associated_skill = /datum/skill/magic/holy
	recharge_time = 15 SECONDS

/obj/effect/proc_holder/spell/invoked/ventriloquism/cast(list/targets, mob/user = usr)
	if(isobj(targets[1]))
		var/obj/target = targets[1]
		var/input_message = input(usr, "What shall [target] say?", src) as null|text
		target.say("[input_message]")
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/mastersillusion
	name = "Set Decoy"
	desc = "Creates a body double of yourself and makes you invisible, after a delay your clone explodes into smoke."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "disguise"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 1
	no_early_release = TRUE
	movement_interrupt = FALSE
	chargedloop = /datum/looping_sound/invokeholy
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 1 MINUTES
	var/firstcast = TRUE
	var/icon/clone_icon

/obj/effect/proc_holder/spell/invoked/mastersillusion/cast(list/targets, mob/living/carbon/human/user = usr)
	if(firstcast)
		to_chat(user, span_italics("...Oh, oh, thy visage is so grand! Let us prepare it for tricks!"))
		clone_icon = get_flat_human_icon("[user.real_name] decoy", null, null, DUMMY_HUMAN_SLOT_MANIFEST, GLOB.cardinals, TRUE, user, TRUE) // We can only set our decoy icon once. This proc is sort of expensive on generation.
		firstcast = FALSE
		name = "Master's Illusion"
		to_chat(user, "There we are... Perfect.")
		revert_cast()
		return
	var/turf/T = get_turf(user)
	var/holy_skill = user.get_skill_level(/datum/skill/magic/holy)
	var/scaled_skill = max(1, holy_skill)
	var/invis_seconds = min(6, 3 + FLOOR(scaled_skill / 2, 1))
	var/invis_time = invis_seconds SECONDS
	var/clone_duration = max(1 SECONDS, round(invis_time * 0.7))
	new /mob/living/simple_animal/hostile/rogue/xylixdouble(T, user, clone_icon, clone_duration)
	animate(user, alpha = 0, time = 0 SECONDS, easing = EASE_IN)
	user.mob_timers[MT_INVISIBILITY] = world.time + invis_time
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon/human, update_sneak_invis), TRUE), invis_time)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[user] fades back into view."), span_notice("You become visible again.")), invis_time)
	return TRUE

/mob/living/simple_animal/hostile/rogue/xylixdouble
	name = "Xylixian Double - You shouldnt be seeing this."
	desc = ""
	gender = NEUTER
	mob_biotypes = MOB_HUMANOID
	maxHealth = 20
	health = 20
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 50
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = TRUE
	loot = list(/obj/item/bomb/smoke/decoy)
	can_have_ai = FALSE
	AIStatus = AI_OFF
	ai_controller = /datum/ai_controller/mudcrab // doesnt really matter


/obj/item/bomb/smoke/decoy/Initialize(mapload)
	. = ..()
	playsound(loc, 'sound/magic/decoylaugh.ogg', 50)
	explode()

/mob/living/simple_animal/hostile/rogue/xylixdouble/Initialize(mapload, mob/living/carbon/human/copycat, icon/I, duration = 7 SECONDS)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal, death), TRUE), duration)
	icon = I
	name = copycat.name


/obj/effect/proc_holder/spell/invoked/mockery
	name = "Vicious Mockery"
	desc = "Mock your target, reducing their INT, SPD, STR and WIL for a time."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "mockery"
	releasedrain = 50
	associated_skill = /datum/skill/misc/music
	recharge_time = 2 MINUTES
	range = 7

/obj/effect/proc_holder/spell/invoked/mockery/cast(list/targets, mob/user = usr)
	playsound(get_turf(user), 'sound/magic/mockery.ogg', 40, FALSE)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		if(!target.can_hear()) // Vicious mockery requires people to be able to hear you.
			revert_cast()
			return FALSE
		target.apply_status_effect(/datum/status_effect/debuff/viciousmockery)
		SEND_SIGNAL(user, COMSIG_VICIOUSLY_MOCKED, target)
		record_round_statistic(STATS_PEOPLE_MOCKED)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/mockery/invocation(mob/user = usr)
	if(ishuman(user))
		switch(pick(1,2,3,4,5,6,7,8,9,10,11,12,13))
			if(1)
				user.say("Your mother was a Rous, and your father smelled of jacksberries!", forced = "spell")
			if(2)
				user.say("What are you going to do for a face when the Archdevil wants his arse back?!", forced = "spell")
			if(3)
				user.say("Wandought thine blades stand, much like thine loving parts!", forced = "spell")
			if(4)
				user.say("That's a face not even Eora could love!", forced = "spell")
			if(5)
				user.say("Your breath smells like raw butter and cheap beer!.", forced = "spell")
			if(6)
				user.say("I bite mine thumb, ser!", forced = "spell")
			if(7)
				user.say("But enough talk- have at thee!", forced = "spell")
			if(8)
				user.say("My grandmother fights better than you!", forced = "spell")
			if(9)
				user.say("Need you borrow mine spectacles? Come get them!", forced = "spell")
			if(10)
				user.say("How much sparring did it take to become this awful?!", forced = "spell")
			if(11)
				user.say("You may need a smith- for you seem ill-equipped for a battle of wits!", forced = "spell")
			if(12)
				user.say("Looks as if thou art PSY-DONE! No? Too soon? Alright.", forced = "spell")
			if(13)
				user.say("Ravox bring justice to your useless mentor, ser!", forced = "spell")

/datum/status_effect/debuff/viciousmockery
	id = "viciousmockery"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/viciousmockery
	duration = 600 // One minute
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -1,STATKEY_WIL = -1, STATKEY_INT = -3)

/atom/movable/screen/alert/status_effect/debuff/viciousmockery
	name = "Vicious Mockery"
	desc = "<span class='warning'>THAT ARROGANT BARD! ARGH!</span>\n"
	icon_state = "mockery"

/obj/effect/proc_holder/spell/self/xylixslip
	name = "Xylixian Slip"
	desc = "Jumps you up to 3 tiles away."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "slip"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 12 SECONDS
	devotion_cost = 30
	miracle = TRUE
	var/leap_dist = 4	//3 tiles (+1 to account for origin tile)
	var/static/list/sounds = list('sound/magic/xylix_slip1.ogg','sound/magic/xylix_slip2.ogg','sound/magic/xylix_slip2.ogg','sound/magic/xylix_slip3.ogg','sound/magic/xylix_slip4.ogg','sound/magic/xylix_slip4.ogg')

/obj/effect/proc_holder/spell/self/xylixslip/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user

	if(H.IsImmobilized() || !(H.mobility_flags & MOBILITY_STAND))
		revert_cast()
		return FALSE

	if(H.IsOffBalanced())
		H.visible_message(span_warning("[H] loses their footing!"))
		var/turnangle = (prob(50) ? 270 : 90)
		var/turndir = turn(dir, turnangle)
		var/dist = rand(1, 2)
		var/current_turf = get_turf(H)
		var/target_turf = get_ranged_target_turf(current_turf, turndir, dist)
		H.throw_at(target_turf, dist, 1, H, TRUE)
		playsound(H,'sound/magic/xylix_slip_fail.ogg', 100)
		H.Knockdown(10)
		return TRUE
	else
		var/current_turf = get_turf(H)
		var/turf/target_turf = get_ranged_target_turf(current_turf, H.dir, leap_dist)
		H.visible_message(span_warning("[H] slips away!"))
		H.throw_at(target_turf, leap_dist, 1, H, TRUE)
		if(target_turf.landsound)
			playsound(target_turf, target_turf.landsound, 100, FALSE)
		H.emote("jump", forced = TRUE)
		H.OffBalance(8 SECONDS)
		playsound(H, pick(sounds), 100, TRUE)
		return TRUE

/obj/effect/proc_holder/spell/invoked/abscond
	name = "Abscond"
	desc = "Disappear in a flash of smoke! (With a range of 4 tiles)"
	releasedrain = 30
	warnie = "spellwarning"
	movement_interrupt = TRUE
	associated_skill = /datum/skill/magic/holy
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "abscond"
	chargedrain = 1
	chargetime = 0 SECONDS
	recharge_time = 60 SECONDS
	hide_charge_effect = TRUE
	gesture_required = FALSE // Slippery
	devotion_cost = 100
	miracle = TRUE
	var/area_of_effect = 1
	var/max_range = 4
	var/turf/destination_turf
	var/turf/user_turf
	var/mutable_appearance/tile_effect
	var/mutable_appearance/target_effect
	var/datum/looping_sound/invokeshadow/shadowloop
	var/static/list/sounds = list('sound/magic/xylix_slip1.ogg','sound/magic/xylix_slip2.ogg','sound/magic/xylix_slip3.ogg','sound/magic/xylix_slip4.ogg')

//Resets the tile and turf effects.
/obj/effect/proc_holder/spell/invoked/abscond/proc/reset(silent = FALSE)
	if(tile_effect && destination_turf)
		destination_turf.cut_overlay(tile_effect)
		qdel(tile_effect)
		destination_turf = null
	if(user_turf && target_effect)
		user_turf.cut_overlay(target_effect)
		qdel(target_effect)
		user_turf = null
	update_icon()

/obj/effect/proc_holder/spell/invoked/abscond/proc/check_path(turf/Tu, turf/Tt)
	var/dist = get_dist(Tt, Tu)
	var/last_dir
	var/turf/last_step
	if(Tu.z > Tt.z) 
		last_step = get_step_multiz(Tu, DOWN)
	else if(Tu.z < Tt.z)
		last_step = get_step_multiz(Tu, UP)
	else 
		last_step = locate(Tu.x, Tu.y, Tu.z)
	var/success = FALSE
	for(var/i = 0, i <= dist, i++)
		last_dir = get_dir(last_step, Tt)
		var/turf/Tstep = get_step(last_step, last_dir)
		if(!Tstep.density)
			success = TRUE
			var/list/contents = Tstep.GetAllContents()
			for(var/obj/structure/bars/B in contents)
				success = FALSE
				return success
			var/list/cont = Tstep.GetAllContents(/obj/structure/roguewindow)
			for(var/obj/structure/roguewindow/W in cont)
				if(W.climbable && !W.opacity)	//It's climbable and can be seen through
					success = TRUE
					continue
				else if(!W.climbable)
					success = FALSE
					return success
		else
			success = FALSE
			return success
		last_step = Tstep
	return success

//Successful teleport, complete reset.
/obj/effect/proc_holder/spell/invoked/abscond/proc/tp(mob/user)
	if(destination_turf)
		if(do_teleport(user, destination_turf, no_effects=TRUE))
			log_admin("[user.real_name]([key_name(user)] Shadowstepped from X:[user_turf.x] Y:[user_turf.y] Z:[user_turf.z] to X:[destination_turf.x] Y:[destination_turf.y] Z:[destination_turf.z] in area: [get_area(destination_turf)]")
			if(user.m_intent == MOVE_INTENT_SNEAK)
				playsound(user_turf, pick(sounds), 20, TRUE)
				playsound(destination_turf, pick(sounds), 20, TRUE)
			else
				playsound(user_turf, pick(sounds), 100, TRUE)
				playsound(destination_turf, pick(sounds), 100, TRUE)
			reset(silent = TRUE)

/obj/effect/proc_holder/spell/invoked/abscond/cast(list/targets, mob/user)
	var/turf/O = get_turf(user)
	var/turf/T = get_turf(targets[1])
	var/datum/effect_system/smoke_spread/S = new /datum/effect_system/smoke_spread/fast
	if(!istransparentturf(T))
		var/reason
		if(max_range >= get_dist(user, T) && !T.density)
			if(check_path(get_turf(user), T))	//We check for opaque turfs or non-climbable windows in the way via a simple pathfind.
				if(get_dist(user, T) < 2 && user.z == T.z)
					to_chat(user, span_info("Too close!"))
					revert_cast()
					return FALSE
				to_chat(user, span_info("I begin to slip away!"))
				lockon(T, user)
				if(do_after(user, 3 SECONDS))
					S.set_up(1, O)
					S.start()
					tp(user)
					return TRUE
				else
					reset(silent = TRUE)
					revert_cast()
				return FALSE
			else
				to_chat(user, span_info("The path is blocked!"))
				revert_cast()
				return FALSE
		else if(get_dist(user, T) > max_range)
			reason = "It's too far."
			revert_cast()
			return FALSE
		else if (T.density)
			reason = "It's a wall!"
			revert_cast()
			return FALSE
		to_chat(user, span_info("I cannot slip there! "+"[reason]"))
	else
		to_chat(user, span_info("I cannot slip there!"))
		revert_cast()
		return
	. = ..()

//Plays affects at target Turf
/obj/effect/proc_holder/spell/invoked/abscond/proc/lockon(turf/T, mob/user)
	if(user.m_intent == MOVE_INTENT_SNEAK)
		playsound(T, 'sound/magic/shadowstep_destination.ogg', 20, FALSE, 5)
	else
		playsound(T, 'sound/magic/shadowstep_destination.ogg', 100, FALSE, 5)
	tile_effect = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "mist", layer = 18)
	target_effect = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "mist", layer = 18)
	user_turf = get_turf(user)
	destination_turf = T
	user_turf.add_overlay(target_effect)
	destination_turf.add_overlay(tile_effect)

/obj/effect/proc_holder/spell/invoked/mimicry
	name = "Mimicry"
	desc = "Play a sound of your choice at the targeted location, or assume the form of an item as a parlor trick, you brilliant jester."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "mimicry"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 12 SECONDS
	devotion_cost = 30
	miracle = TRUE
	var/parlor_hand_path = /obj/item/melee/touch_attack/parlor_trick
	var/list/soundpick = list(
		"Angry Skeleton" = 'sound/vo/mobs/skel/skeleton_scream (1).ogg',
		"Armor Break" = 'sound/combat/sharpness_loss1.ogg',
		"Attack Swing" = 'sound/combat/wooshes/bladed/wooshlarge (1).ogg',
		"Bell" = 'sound/misc/bell.ogg',
		"Bell Jingle" = 'sound/items/jinglebell1.ogg',
		"Broken Door" = 'sound/combat/hits/onwood/destroywalldoor.ogg',
		"Clap" = 'sound/vo/clap (1).ogg',
		"Clear Throat" = 'sound/vo/female/gen/clearthroat.ogg',
		"Defending" = 'sound/combat/clash_initiate.ogg',
		"Door Unlock" = 'sound/foley/doors/woodlock.ogg',
		"Explosion" = 'sound/magic/fireball.ogg',
		"Glass Shatter" = 'sound/combat/hits/onglass/glassbreak (2).ogg',
		"Goblin Jabber" = 'sound/vo/male/goblin/giggle (2).ogg',
		"Guard Houndstone" = 'sound/misc/garrisonscom.ogg',
		"Hallelujah" = 'sound/magic/hallelujah.ogg',
		"Howl" = 'sound/vo/mobs/wwolf/howl (1).ogg',
		"Jumping" = 'sound/vo/male/gen/jump.ogg',
		"Large Creecher Jump" = 'sound/vo/mobs/wwolf/jump (1).ogg',
		"Lockpick Click" = 'sound/items/pickbad.ogg',
		"Message" = 'sound/magic/message.ogg',
		"Psst" = 'sound/vo/psst.ogg',
		"Rat Chitter/SCOM" = 'sound/vo/mobs/rat/rat_life.ogg',
		"Relief" = 'sound/ddrelief.ogg',
		"Scream - Agony" = 'sound/vo/male/old/scream.ogg',
		"Scream - Rage" = 'sound/vo/female/gen/rage (1).ogg',
		"Skeleton Laugh" = 'sound/vo/mobs/skel/skeleton_laugh.ogg',
		"Snap Finger" = 'sound/foley/finger-snap.ogg',
		"Spider Chitter" = 'sound/vo/mobs/spider/idle (1).ogg',
		"Stress" = 'sound/ddstress.ogg',
		"Vicious Mockery" = 'sound/magic/mockery.ogg',
		"Volf Snarl" = 'sound/vo/mobs/vw/idle (1).ogg',
	)
/obj/item/melee/touch_attack/parlor_trick
	name = "parlor trick"
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#FFFFFF"
	slot_flags = ITEM_SLOT_BELT
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	var/can_use = 1
	var/datum/weakref/active_dummy_ref = null
	var/saved_appearance = null

/obj/item/melee/touch_attack/parlor_trick/afterattack()
	return

/obj/item/melee/touch_attack/parlor_trick/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/mask/cigarette/rollie/zig = /obj/item/clothing/mask/cigarette/rollie
	saved_appearance = initial(zig.appearance)

/obj/item/melee/touch_attack/parlor_trick/dropped()
	..()
	disrupt()
	qdel(src)

/obj/item/melee/touch_attack/parlor_trick/equipped()
	..()
	disrupt()

/obj/item/melee/touch_attack/parlor_trick/attack_self(mob/user)
	disrupt()
	qdel(src)

/obj/item/melee/touch_attack/parlor_trick/attack_obj(obj/item/interacting_with, mob/living/user, list/modifiers)
	make_copy(interacting_with, user)

/obj/item/melee/touch_attack/parlor_trick/attack_right(mob/user)
	qdel(src)

/obj/item/melee/touch_attack/parlor_trick/proc/make_copy(atom/target, mob/user)
	playsound(get_turf(src), 'sound/magic/decoylaugh.ogg', 20, TRUE, -6)
	to_chat(user, span_notice("Copied [target]."))
	var/obj/temp = new /obj()
	temp.appearance = target.appearance
	temp.layer = initial(target.layer)
	saved_appearance = temp.appearance

/obj/item/melee/touch_attack/parlor_trick/proc/check_sprite(atom/target)
	return icon_exists(target.icon, target.icon_state)

/obj/item/melee/touch_attack/parlor_trick/proc/toggle(mob/user)
	if(!can_use || !saved_appearance)
		return
	var/obj/effect/dummy/parlor_trick/active_dummy = active_dummy_ref?.resolve()
	if(active_dummy)
		eject_all()
		playsound(get_turf(src), 'sound/magic/decoylaugh.ogg', 20, TRUE, -6)
		qdel(active_dummy)
		active_dummy_ref = null
		to_chat(user, span_notice("You deactivate \the [src]."))
		new /obj/effect/temp_visual/gravpush(get_turf(src))
	else
		playsound(get_turf(src), 'sound/magic/decoylaugh.ogg', 20, TRUE, -6)
		var/obj/effect/dummy/parlor_trick/C = new/obj/effect/dummy/parlor_trick(user.drop_location())
		C.activate(user, saved_appearance, src)
		to_chat(user, span_notice("You activate \the [src]."))
		new /obj/effect/temp_visual/gravpush(get_turf(src))

/obj/item/melee/touch_attack/parlor_trick/proc/disrupt(delete_dummy = 1)
	var/obj/effect/dummy/parlor_trick/active_dummy = active_dummy_ref?.resolve()
	if(active_dummy)
		for(var/mob/M in active_dummy)
			to_chat(M, span_danger("Your parlor trick wanes!"))
		new /obj/effect/temp_visual/gravpush(loc)
		eject_all()
		if(delete_dummy)
			qdel(active_dummy)
		active_dummy_ref = null
		can_use = FALSE
		addtimer(VARSET_CALLBACK(src, can_use, TRUE), 2.5 SECONDS)

/obj/item/melee/touch_attack/parlor_trick/proc/eject_all()
	var/obj/effect/dummy/parlor_trick/active_dummy = active_dummy_ref?.resolve()
	if(!active_dummy)
		return
	for(var/atom/movable/A in active_dummy)
		A.forceMove(active_dummy.loc)
		if(ismob(A))
			var/mob/M = A
			M.reset_perspective(null)

/obj/effect/dummy/parlor_trick
	name = ""
	desc = ""
	density = FALSE
	var/can_move = 0
	var/obj/item/melee/touch_attack/parlor_trick/master = null

/obj/effect/dummy/parlor_trick/proc/pixel_shift(direction)
	if(CHECK_BITFIELD(direction, NORTH))
		pixel_y = min(pixel_y + 1, PIXEL_SHIFT_MAXIMUM)
	if(CHECK_BITFIELD(direction, EAST))
		pixel_x = min(pixel_x + 1, PIXEL_SHIFT_MAXIMUM)
	if(CHECK_BITFIELD(direction, SOUTH))
		pixel_y = max(pixel_y - 1, -PIXEL_SHIFT_MAXIMUM)
	if(CHECK_BITFIELD(direction, WEST))
		pixel_x = max(pixel_x - 1, -PIXEL_SHIFT_MAXIMUM)

/obj/effect/dummy/parlor_trick/proc/unpixel_shift()
	pixel_x = 0
	pixel_y = 0

/obj/effect/dummy/parlor_trick/proc/activate(mob/M, saved_appearance, obj/item/melee/touch_attack/parlor_trick/C)
	appearance = saved_appearance
	if(istype(M.buckled, /obj/vehicle))
		var/obj/vehicle/V = M.buckled
		V.unbuckle_mob(M, force = TRUE)
	M.forceMove(src)
	master = C
	master.active_dummy_ref = WEAKREF(src)


/obj/effect/dummy/parlor_trick/Destroy()
	if(master)
		master.disrupt(0)
		master = null
	return ..()

/obj/effect/dummy/parlor_trick/attackby()
	master.disrupt()

/obj/effect/dummy/parlor_trick/attack_hand()
	master.disrupt()

/mob/living/carbon/human/pixel_shift(direction)
	if(istype(loc, /obj/effect/dummy/parlor_trick))
		var/obj/effect/dummy/parlor_trick/D = loc
		D.pixel_shift(direction)
		is_shifted = TRUE
		return
	return ..()

/mob/living/carbon/human/unpixel_shift()
	if(istype(loc, /obj/effect/dummy/parlor_trick))
		var/obj/effect/dummy/parlor_trick/D = loc
		D.unpixel_shift()
		passthroughable = NONE
		is_shifted = FALSE
		return
	return ..()

/mob/living/carbon/human/send_speech(message, range = 7, obj/source = src, bubble_type, list/spans, datum/language/message_language = null, message_mode)
	. = ..()
	if(!istype(loc, /obj/effect/dummy/parlor_trick))
		return

	var/obj/effect/dummy/parlor_trick/D = loc
	var/list/hearers = get_hearers_in_view(range, source)
	for(var/mob/M in hearers)
		M.create_chat_message(D, message_language, message, spans, message_mode)

/obj/effect/proc_holder/spell/invoked/mimicry/proc/get_or_create_parlor_trick(mob/living/user)
	var/obj/item/melee/touch_attack/parlor_trick/active_hand = user.get_active_held_item()
	if(istype(active_hand))
		return active_hand

	for(var/obj/item/melee/touch_attack/parlor_trick/P in user.contents)
		if(!user.is_holding(P))
			if(!user.put_in_hands(P))
				to_chat(user, span_warning("My hands are full!"))
				return null
		return P

	var/obj/item/melee/touch_attack/parlor_trick/P = new parlor_hand_path(user)
	if(!user.put_in_hands(P))
		qdel(P)
		to_chat(user, span_warning("My hands are full!"))
		return null
	to_chat(user, span_notice("You channel a parlor trick into your hand."))
	return P
	
/obj/effect/proc_holder/spell/invoked/mimicry/cast(list/targets, mob/living/user)
	var/atom/target = targets[1]
	var/turf/T = get_turf(target)

	if(target == user)
		var/obj/item/melee/touch_attack/parlor_trick/P = get_or_create_parlor_trick(user)
		if(!P)
			revert_cast()
			return FALSE
		to_chat(user, span_notice("You channel a parlor trick into your hand. Use it on an object to copy, then right-click yourself to transform."))
		return TRUE

	if(isobj(target))
		var/obj/item/melee/touch_attack/parlor_trick/P = get_or_create_parlor_trick(user)
		if(!P)
			revert_cast()
			return FALSE
		P.make_copy(target, user)
		to_chat(user, span_notice("You channel a parlor trick miacle and copy [target]. Right-click yourself to transform."))
		return TRUE

	var/pickedsound = input(user, "Choose a sound, my wise bureaucrat.", "Mimic Sound") as anything in soundpick
	if(!pickedsound)
		revert_cast()
		return FALSE
	if(T)
		new /obj/effect/temp_visual/soundping(T)
		playsound(T, soundpick[pickedsound], 100)
		return TRUE
	else
		to_chat(user, "<span class='warning'>The trick failed you poor fool.</span>")
		revert_cast()
		return FALSE

/obj/effect/proc_holder/spell/invoked/projectile/fetch/miracle
	name = "Divine Fetch"
	miracle = TRUE
	devotion_cost = 10
	invocations = list()
	associated_skill = /datum/skill/magic/holy
	recharge_time = 5 SECONDS

/obj/effect/proc_holder/spell/invoked/projectile/fetch/miracle/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	if(T.z < user.z)
		to_chat(user, span_warning("You cannot use Divine Fetch below your floor!"))
		revert_cast()
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/invoked/projectile/repel/miracle
	name = "Divine Repel"
	miracle = TRUE
	devotion_cost = 14
	invocations = list()
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/projectile/repel/miracle/cast(list/targets, mob/living/user)
	var/turf/T = get_turf(targets[1])
	if(T.z < user.z)
		to_chat(user, span_warning("You cannot use Divine Repel below your floor!"))
		revert_cast()
		return FALSE
	return ..()

/obj/effect/proc_holder/spell/invoked/slick_trick_small/miracle
	name = "Xylixian Slipsquare"
	desc = "Create a tiny divine slick patch to trip the unwary."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "slipsquare1"
	miracle = TRUE
	devotion_cost = 30
	chargetime = 0.5 SECONDS
	invocations = list()
	associated_skill = /datum/skill/magic/holy
	recharge_time = 30 SECONDS

/obj/effect/proc_holder/spell/invoked/slick_trick/miracle
	name = "Grand Xylixian Slipsquare"
	desc = "Flood a wide area with divine slick patches that send victims to the floor."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "slipsquare2"
	miracle = TRUE
	devotion_cost = 60
	chargetime = 1 SECONDS
	invocations = list()
	associated_skill = /datum/skill/magic/holy
	recharge_time = 90 SECONDS
	area_of_effect_radius = 1 // 1 = 3x3

#define NOTHING "nothing"
#define XYLIX "xylix"
#define ASTRATA "astrata"
#define NOC "noc"
#define ZIZO "zizo"
#define RAVOX "ravox"
#define ABYSSOR "abyssor"
#define MALUM "malum"
#define EORA "eora"
#define NECRA "necra"
#define PESTRA "pestra"
#define DENDOR "dendor"
#define BAOTHA "baotha"
#define GRAGGAR "graggar"
#define MATTHIOS "matthios"

//JACKPOOOOOOOT 777
/datum/status_effect/xylix_blessed_luck
	id = "xylix_blessed_luck"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/xylix_blessed_luck

/datum/status_effect/xylix_blessed_luck/on_apply()
	var/random_luck = rand(2,4)
	effectedstats = list("fortune" = random_luck)
	. = ..()

/datum/status_effect/xylix_blessed_luck/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/xylix_blessed_luck
	name = "Xylixian Blessed Luck"
	desc = "Even though you haven't won one of his favors, he still favors you."
	icon_state = "status"

/particles/astartian_favor
	icon = 'icons/effects/particles/generic.dmi'
	icon_state = list("dot" = 8,"curl" = 1)
	width = 64
	height = 96
	color = 0
	color_change = 0.05
	count = 200
	spawning = 50
	gradient = list("#f37a34", "#FBAF4D", "#f02b1d", "#ff6d40")
	lifespan = 1.5 SECONDS
	fade = 1 SECONDS
	fadein = 0.1 SECONDS
	grow = -0.1
	velocity = generator("box", list(-3, -0.7), list(3,3), NORMAL_RAND)
	position = generator("sphere", 8, 8, LINEAR_RAND)
	scale = generator("vector", list(2, 2), list(4,4), NORMAL_RAND)
	drift = list(0)

//Astrata Jackpot
/datum/status_effect/astrata_favor
	id = "astrata_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 40 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/astrata_favor

/datum/status_effect/astrata_favor/on_apply()
	effectedstats = list("constitution" = rand(1, 3), "willpower" = rand(1, 3))
	ADD_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, XYLIX_LUCK_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, XYLIX_LUCK_TRAIT)
	ADD_TRAIT(owner, TRAIT_STEELHEARTED, XYLIX_LUCK_TRAIT)
	ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, XYLIX_LUCK_TRAIT)
	owner.particles = new /particles/astartian_favor()
	. = ..()

/datum/status_effect/astrata_favor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, XYLIX_LUCK_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, XYLIX_LUCK_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_STEELHEARTED, XYLIX_LUCK_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, XYLIX_LUCK_TRAIT)
	qdel(owner.particles)
	owner.particles = null
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/astrata_favor
	name = "Astrata's Favor"
	desc = "Although it was difficult to obtain, Xylix used it. You are practically immortal."
	icon_state = "status"

//Noc Jackpot
/datum/status_effect/noc_favor
	id = "noc_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/noc_favor

/datum/status_effect/noc_favor/on_apply()
	effectedstats = list("intelligence" = rand(1, 3), "speed" = rand(1, 3))
	owner.alpha = 127
	. = ..()

/datum/status_effect/noc_favor/on_remove()
	owner.alpha = 255
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/noc_favor
	name = "Noc's Favor"
	desc = "Knowledge, light and shadow of Noc covers you."
	icon_state = "status"

//Zizo punishment
/datum/status_effect/zizo_unfavor
	id = "zizo_unfavor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/zizo_unfavor

/datum/status_effect/zizo_unfavor/on_apply()
	effectedstats = list("strength" = -rand(1, 5), "perception" = -rand(1, 5), "intelligence" = -rand(1, 5), "constitution" = -rand(1, 5), "willpower" = -rand(1, 5), "speed" = -rand(1, 5))
	. = ..()

/datum/status_effect/zizo_unfavor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/zizo_unfavor
	name = "Zizo's Intervention"
	desc = "Your patron was not attentive enough and caught Zizo's attention. You feel weaker."
	icon_state = "status"

//Ravox Jackpot
/datum/status_effect/ravox_favor
	id = "ravox_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/ravox_favor

/datum/status_effect/ravox_favor/on_apply()
	effectedstats = list("strength" = rand(1, 3), "speed" = rand(1, 3), "willpower" = rand(1, 3))
	. = ..()

/datum/status_effect/ravox_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/ravox_favor
	name = "Favor of Ravox"
	desc = "The power of Ravox supports you."
	icon_state = "status"

//Malum Jackpot
/datum/status_effect/malum_favor
	id = "malum_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/malum_favor

/datum/status_effect/malum_favor/on_apply()
	effectedstats = list("constitution" = 1, "willpower" = rand(1, 5))
	. = ..()

/datum/status_effect/malum_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

//Baotha Jackpot
/datum/status_effect/baotha_favor
	id = "baotha_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/baotha_favor

/datum/status_effect/baotha_favor/on_apply()
	effectedstats = list("speed" = rand(2, 3))
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.drunkenness = max(C.drunkenness, 30)
	owner.apply_status_effect(/datum/status_effect/buff/druqks/baotha)
	if(owner.client?.prefs?.sexable)
		if(!owner.sexcon)
			owner.sexcon = new /datum/sex_controller(owner)
		owner.sexcon.set_arousal(110)
	. = ..()

/datum/status_effect/baotha_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/baotha_favor
	name = "Baotha's Favor"
	desc = "You feel euphoric, quick, very flushed and intoxicated."
	icon_state = "status"

//Graggar Jackpot
/datum/status_effect/graggar_favor
	id = "graggar_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/graggar_favor

/datum/status_effect/graggar_favor/on_apply()
	var/list/allowed_zones = list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/zone = pick(allowed_zones)
	var/obj/item/bodypart/BP = owner.get_bodypart(zone)
	if(BP)
		BP.add_wound(pick(/datum/wound/dynamic/bruise, /datum/wound/dynamic/slash, /datum/wound/dynamic/puncture))
		if(prob(25))
			BP.add_wound(/datum/wound/fracture)
	owner.visible_message(span_warning("[owner] suddenly winces as flesh tears and bruises under Graggar's wrath!"), span_userdanger("Pain blossoms across my body as Graggar's rage wounds me!"))
	. = ..()

/datum/status_effect/graggar_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/graggar_favor
	name = "Graggar's Favor"
	desc = "Violence turns inward. Blood and pain has been inflicted upon you!"
	icon_state = "status"

//Matthios Jackpot
/datum/status_effect/matthios_favor
	id = "matthios_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/matthios_favor

/datum/status_effect/matthios_favor/on_apply()
	var/meister_balance = SStreasury.bank_accounts[owner] ? SStreasury.bank_accounts[owner] : 0
	if(meister_balance > 0)
		var/stolen = min(rand(1, 10), meister_balance)
		SStreasury.bank_accounts[owner] -= stolen
		to_chat(owner, span_warning("Matthios skims [stolen] mammon from your meister!"))
	else
		to_chat(owner, span_notice("Matthios reaches for your meister, but finds it empty. Truly, a poor fool!"))
	. = ..()

/datum/status_effect/matthios_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/matthios_favor
	name = "Matthios' Favor"
	desc = "The Free-God palms coin from your meister with a crooked grin."
	icon_state = "status"

/atom/movable/screen/alert/status_effect/buff/malum_favor
	name = "Favor of Malum"
	desc = "Malum lends you his enduring strength and will."
	icon_state = "status"

//Eora Jackpot
/datum/status_effect/eora_favor
	id = "eora_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/eora_favor

/datum/status_effect/eora_favor/on_apply()
	if(!HAS_TRAIT(owner, TRAIT_UNSEEMLY))
		ADD_TRAIT(owner, TRAIT_BEAUTIFUL, XYLIX_LUCK_TRAIT)
	. = ..()

/datum/status_effect/eora_favor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_BEAUTIFUL, XYLIX_LUCK_TRAIT)
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/datum/status_effect/eora_favor/process()
	owner.adjustBruteLoss(-1.25)
	owner.adjustFireLoss(-1.25)
	. = ..()

/atom/movable/screen/alert/status_effect/buff/eora_favor
	name = "A Favor from Eora"
	desc = "Eora surrounds you with her love, soothing your wounds and making you glow with divine beauty."
	icon_state = "status"

//Necra Jackpot
/datum/status_effect/necra_favor
	id = "necra_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/necra_favor
	var/last_smoke = 0
	var/smoke_interval = 5 SECONDS

/datum/status_effect/necra_favor/on_apply()
	owner.AddElement(/datum/element/cleaning)
	last_smoke = world.time
	. = ..()

/datum/status_effect/necra_favor/process()
	. = ..()
	if(world.time >= last_smoke + smoke_interval)
		last_smoke = world.time
		emit_censer_smoke()

/datum/status_effect/necra_favor/proc/emit_censer_smoke()
	var/turf/origin = get_turf(owner)
	if(!origin)
		return
	for(var/turf/T in view(1, origin))
		if(T == origin)
			continue
		new /obj/effect/particle_effect/smoke/necra_censer(T)
	playsound(origin, 'sound/items/censer_use.ogg', 40, TRUE)

/datum/status_effect/necra_favor/on_remove()
	owner.RemoveElement(/datum/element/cleaning)
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/necra_favor
	name = "Necra's Favor"
	desc = "Necra's censer-smoke clings to your steps, cleansing the ground around you."
	icon_state = "status"

//Pestra Jackpot
/datum/status_effect/pestra_favor
	id = "pestra_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/pestra_favor

/datum/status_effect/pestra_favor/on_apply()
	playsound(owner, 'sound/misc/fliesloop.ogg', 100, FALSE, -1)
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.vomit()
		new /obj/item/natural/worms/leech(get_turf(C))
	owner.adjustToxLoss(-30)
	owner.apply_status_effect(/datum/status_effect/buff/healing, 5)
	owner.apply_status_effect(/datum/status_effect/buff/pestra_care)
	to_chat(owner, span_notice("A wet retch spills forth a leech as Pestra's swarm mends me from within."))
	. = ..()

/datum/status_effect/pestra_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/pestra_favor
	name = "Pestra's Favor"
	desc = "A leeching purge and crawling mercy ease poison and knit your wounds."
	icon_state = "status"

//Dendor Jackpot
/datum/status_effect/dendor_favor
	id = "dendor_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/dendor_favor

/datum/status_effect/dendor_favor/on_apply()
	owner.electrocute_act(30, owner)
	owner.emote("painscream")
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, XYLIX_LUCK_TRAIT)
	to_chat(owner, span_warning("You're suddenly jolted with a kneestinger's touch as Dendor's power lets you stride freely on uneven terrain for a short time!"))
	. = ..()

/datum/status_effect/dendor_favor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, XYLIX_LUCK_TRAIT)
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/dendor_favor
	name = "Dendor's Favor"
	desc = "Dendor's blessing jolts you with a kneestinger's touch and temporarily frees your stride from the grip of the earth."
	icon_state = "status"

//Abyssor Jackpot
/datum/status_effect/abyssor_favor
	id = "abyssor_favor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/abyssor_favor

/datum/status_effect/abyssor_favor/on_apply()
	playsound(owner, 'sound/misc/undertow.ogg', 75, FALSE)
	if(prob(50))
		owner.stamina_add(-round(owner.max_stamina * 0.8))
		owner.energy_add(-round(owner.max_energy * 0.2))
		owner.adjustOxyLoss(30)
		owner.losebreath += 2
		owner.Dizzy(10)
		owner.blur_eyes(10)
		owner.emote("drown")
		to_chat(owner, span_warning("Abyssor's depths seize your lungs and drag your breath away, draining your energy!"))
	else
		owner.stamina_add(round(owner.max_stamina * 0.8))
		owner.energy_add(round(owner.max_energy * 0.2))
		to_chat(owner, span_notice("A cool tide washes over your mind, restoring your energy."))
	. = ..()

/datum/status_effect/abyssor_favor/on_remove()
	. = ..()
	owner?.update_fov_angles()
	owner?.update_vision_cone()

/atom/movable/screen/alert/status_effect/buff/abyssor_favor
	name = "Abyssor's Favor"
	desc = "You awoke something you shouldn't have. It pulls your breath away, or may give you a second wind."
	icon_state = "status"

/obj/effect/proc_holder/spell/invoked/xylixlian_luck
	name = "Xylix's Fortune"
	desc = "Challenge your luck and your patron"
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "xylixfort"
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	recharge_time = 2 MINUTES
	miracle = TRUE
	devotion_cost = 50
	var/used_times = 0
	var/last_used = 0
	var/bonus_luck_threshould = 600

/obj/effect/proc_holder/spell/invoked/xylixlian_luck/Initialize(mapload)
	. = ..()

	last_used = world.time

/obj/effect/proc_holder/spell/invoked/xylixlian_luck/cast(list/targets,mob/living/carbon/human/user = usr)
	user.play_overhead_indicator('modular_twilight_axis/icons/mob/overhead_effects.dmi', "xylix_fortune", 30, MUTATIONS_LAYER, soundin = 'modular_twilight_axis/sound/slotmachine.ogg', y_offset = 24)

	to_chat(user, span_danger("Xylix gives you a chance to use one of his favors"))
	var/luck_bonus = 0
	luck_bonus -= used_times * 5
	luck_bonus += 1.9444 * ((world.time - last_used) / bonus_luck_threshould)
	var/list/patronChances = list(
								XYLIX = 100 - luck_bonus,			RAVOX = 60 -luck_bonus/2,
								EORA = 70 - luck_bonus/2,			NOTHING = 80 - luck_bonus,
								MALUM = 50 - luck_bonus/2,			NOC = 50 - luck_bonus,
								ABYSSOR = 45 - luck_bonus/2,
								NECRA = 50 - luck_bonus/2,
								PESTRA = 40 - luck_bonus/3,
								ASTRATA = 15 + luck_bonus * 1.5,	ZIZO = ceil(10-luck_bonus),
								DENDOR = 40 - luck_bonus/3,
								BAOTHA = 40 - luck_bonus/3,		GRAGGAR = 35 - luck_bonus/3,
								MATTHIOS = 45 - luck_bonus/3
								)

	var/list/chances = typelist("patronChances", patronChances)
	var/result = pickweight(chances)

	used_times += 1
	last_used = world.time

	switch(result)
		if(NOTHING)
			to_chat(user, span_danger("You won... Nothing!"))
		if(XYLIX)
			user.apply_status_effect(/datum/status_effect/xylix_blessed_luck)
			new /obj/item/roguecoin/gold(get_turf(user), 1)
			to_chat(user, span_danger("Xylix's fortune favors you!"))
		if(ASTRATA)
			user.apply_status_effect(/datum/status_effect/astrata_favor)
			to_chat(user, span_danger("The Light of Astrata gives you strength!"))
		if(NOC)
			user.apply_status_effect(/datum/status_effect/noc_favor)
			to_chat(user, span_danger("The shadow of Noc's silver light covers you!"))
		if(ZIZO)
			user.apply_status_effect(/datum/status_effect/zizo_unfavor)
			to_chat(user, span_danger("Zizo's face is mocking you!"))
		if(RAVOX)
			user.apply_status_effect(/datum/status_effect/ravox_favor)
			to_chat(user, span_danger("Ravox blesses you with power!"))
		if(ABYSSOR)
			user.apply_status_effect(/datum/status_effect/abyssor_favor)
			to_chat(user, span_danger("Abyssor's tide turns against or for you in an instant!"))
		if(MALUM)
			user.apply_status_effect(/datum/status_effect/malum_favor)
			to_chat(user, span_danger("Malum reforges your body and gives you energy!"))
		if(EORA)
			user.apply_status_effect(/datum/status_effect/eora_favor)
			to_chat(user, span_danger("Eora's love envelops you!"))
		if(NECRA)
			user.apply_status_effect(/datum/status_effect/necra_favor)
			to_chat(user, span_danger("Necra's censer-smoke follows your steps and purifies the way."))
		if(PESTRA)
			user.apply_status_effect(/datum/status_effect/pestra_favor)
			to_chat(user, span_danger("Pestra's swarm stirs in your gut, purging poison and stitching flesh."))
		if(DENDOR)
			user.apply_status_effect(/datum/status_effect/dendor_favor)
			to_chat(user, span_danger("Dendor's wild energy courses through you — if you can handle the kneestinger's kiss!"))
		if(BAOTHA)
			user.apply_status_effect(/datum/status_effect/baotha_favor)
			to_chat(user, span_danger("Baotha's haze grips your body and mind!"))
		if(GRAGGAR)
			user.apply_status_effect(/datum/status_effect/graggar_favor)
			to_chat(user, span_danger("Graggar's fury marks your flesh!"))
		if(MATTHIOS)
			user.apply_status_effect(/datum/status_effect/matthios_favor)
			to_chat(user, span_danger("Matthios steals from your meister as a lesson in greed!"))
	return ..()

#undef NOTHING
#undef XYLIX
#undef ASTRATA
#undef NOC
#undef ZIZO
#undef RAVOX
#undef ABYSSOR
#undef MALUM
#undef EORA
#undef NECRA
#undef PESTRA
#undef DENDOR
#undef BAOTHA
#undef GRAGGAR
#undef MATTHIOS
