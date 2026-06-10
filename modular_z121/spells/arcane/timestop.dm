#define TIMESTOP_FIELD_HALF_SIZE 2
#define TIMESTOP_FIELD_DURATION (9 SECONDS)
#define TIMESTOP_REFRESH_INTERVAL 1
#define TIMESTOP_HOLD_DURATION (1 SECONDS)
#define TIMESTOP_NULL_COLOR "__timestop_null_color__"
#define TIMESTOP_MUTE_SOURCE "timestop"
#define TIMESTOP_ACTION_ICON 'modular_z121/assets/spells/timestop/actions_spells.dmi'
#define TIMESTOP_FIELD_ICON 'modular_z121/assets/spells/timestop/160x160.dmi'
#define TIMESTOP_SOUND 'modular_z121/assets/spells/timestop/timeparadox2.ogg'

/proc/timestop_gray_color()
	return "#F5F5F5"

/proc/timestop_square_turfs(atom/center, half_size = TIMESTOP_FIELD_HALF_SIZE)
	. = list()
	var/turf/center_turf = get_turf(center)
	if(!center_turf)
		return

	var/min_x = max(center_turf.x - half_size, 1)
	var/max_x = min(center_turf.x + half_size, world.maxx)
	var/min_y = max(center_turf.y - half_size, 1)
	var/max_y = min(center_turf.y + half_size, world.maxy)

	for(var/x in min_x to max_x)
		for(var/y in min_y to max_y)
			var/turf/T = locate(x, y, center_turf.z)
			if(T)
				. += T

/obj/effect/timestop_field
	name = "stopped time"
	icon = TIMESTOP_FIELD_ICON
	icon_state = "time"
	alpha = 125
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	pixel_x = -64
	pixel_y = -64
	var/mob/living/caster
	var/expires_at = 0
	var/next_refresh = 0
	var/list/affected_turfs
	var/list/grayed_atoms
	var/list/original_colors
	var/list/stopped_movables

/obj/effect/timestop_field/New(loc, mob/living/new_caster)
	..()
	caster = new_caster
	affected_turfs = timestop_square_turfs(src)
	grayed_atoms = list()
	original_colors = list()
	stopped_movables = list()

	if(!caster || !affected_turfs?.len)
		qdel(src)
		return

	playsound(src, TIMESTOP_SOUND, 75, TRUE)

	for(var/turf/affected_turf as anything in affected_turfs)
		RegisterSignal(affected_turf, COMSIG_ATOM_ENTERED, PROC_REF(on_turf_entered))

	expires_at = world.time + TIMESTOP_FIELD_DURATION
	next_refresh = 0
	refresh_field()
	START_PROCESSING(SSfastprocess, src)

/obj/effect/timestop_field/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	if(affected_turfs?.len)
		for(var/turf/affected_turf as anything in affected_turfs)
			UnregisterSignal(affected_turf, COMSIG_ATOM_ENTERED)
	release_stopped_movables()
	if(grayed_atoms?.len)
		for(var/atom/A as anything in grayed_atoms.Copy())
			restore_atom_color(A)
	affected_turfs = null
	grayed_atoms = null
	original_colors = null
	stopped_movables = null
	caster = null
	playsound(src, TIMESTOP_SOUND, 75, TRUE, frequency = -1)
	return ..()

/obj/effect/timestop_field/process()
	if(world.time >= expires_at)
		qdel(src)
		return PROCESS_KILL
	if(world.time < next_refresh)
		return

	next_refresh = world.time + TIMESTOP_REFRESH_INTERVAL
	refresh_field()

/obj/effect/timestop_field/proc/is_in_field(atom/thing)
	if(!thing)
		return FALSE
	if(isturf(thing))
		return thing in affected_turfs
	return get_turf(thing) in affected_turfs

/obj/effect/timestop_field/proc/track_atom_color(atom/A)
	if(!A || QDELETED(A) || A == src || A == caster || (A in grayed_atoms))
		return

	grayed_atoms += A
	var/original_color = A.color
	original_colors[REF(A)] = isnull(original_color) ? TIMESTOP_NULL_COLOR : original_color
	A.color = timestop_gray_color()

/obj/effect/timestop_field/proc/restore_atom_color(atom/A)
	if(!A)
		return

	var/ref = REF(A)
	if(ref in original_colors)
		if(!QDELETED(A))
			var/original_color = original_colors[ref]
			A.color = (original_color == TIMESTOP_NULL_COLOR) ? null : original_color
		original_colors[ref] = null
	grayed_atoms -= A

/obj/effect/timestop_field/proc/on_turf_entered(datum/source, atom/movable/arrived, atom/oldloc)
	SIGNAL_HANDLER
	if(!arrived || QDELETED(arrived) || arrived == src || arrived == caster)
		return
	if(!is_in_field(arrived))
		return

	track_atom_color(arrived)
	apply_stasis(arrived)

/obj/effect/timestop_field/proc/block_stasis_move(datum/source, atom/newloc)
	SIGNAL_HANDLER
	if(is_in_field(source))
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/obj/effect/timestop_field/proc/block_stasis_click(datum/source, atom/target, params)
	SIGNAL_HANDLER
	if(is_in_field(source))
		return COMSIG_MOB_CANCEL_CLICKON

/obj/effect/timestop_field/proc/apply_stasis(atom/movable/thing)
	if(!thing || QDELETED(thing) || thing == src || thing == caster)
		return
	if(!isliving(thing) && !istype(thing, /obj/projectile))
		return

	var/list/state = stopped_movables[thing]
	if(!state)
		state = list()
		stopped_movables[thing] = state
		RegisterSignal(thing, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(block_stasis_move))

	if(isliving(thing))
		var/mob/living/target = thing
		if(!("had_paralyzed" in state))
			state["had_paralyzed"] = (target.AmountParalyzed() > 0)
		if(!("had_immobilized" in state))
			state["had_immobilized"] = (target.AmountImmobilized() > 0)
		if(!("had_mute" in state))
			state["had_mute"] = HAS_TRAIT(target, TRAIT_MUTE)
		if(!state["click_block_registered"])
			RegisterSignal(target, COMSIG_MOB_CLICKON, PROC_REF(block_stasis_click))
			state["click_block_registered"] = TRUE
		ADD_TRAIT(target, TRAIT_MUTE, TIMESTOP_MUTE_SOURCE)
		target.clear_typing_indicator()
		target.cmode = 0
		target.Paralyze(TIMESTOP_HOLD_DURATION)
		target.Immobilize(TIMESTOP_HOLD_DURATION)
	else if(istype(thing, /obj/projectile))
		var/obj/projectile/projectile = thing
		if(!("had_paused" in state))
			state["had_paused"] = projectile.paused
		projectile.paused = TRUE

/obj/effect/timestop_field/proc/release_stasis(atom/movable/thing)
	if(!stopped_movables)
		return

	var/list/state = stopped_movables[thing]
	if(!state)
		return

	if(!QDELETED(thing))
		UnregisterSignal(thing, COMSIG_MOVABLE_PRE_MOVE)
		if(isliving(thing))
			var/mob/living/target = thing
			UnregisterSignal(target, COMSIG_MOB_CLICKON)
			if(!state["had_paralyzed"] && target.AmountParalyzed() <= (TIMESTOP_HOLD_DURATION + TIMESTOP_REFRESH_INTERVAL))
				target.SetParalyzed(0)
			if(!state["had_immobilized"] && target.AmountImmobilized() <= (TIMESTOP_HOLD_DURATION + TIMESTOP_REFRESH_INTERVAL))
				target.SetImmobilized(0)
			if(!state["had_mute"])
				REMOVE_TRAIT(target, TRAIT_MUTE, TIMESTOP_MUTE_SOURCE)
		else if(istype(thing, /obj/projectile))
			var/obj/projectile/projectile = thing
			projectile.paused = !!state["had_paused"]

	stopped_movables -= thing

/obj/effect/timestop_field/proc/release_stopped_movables()
	if(!stopped_movables?.len)
		return

	for(var/atom/movable/thing as anything in stopped_movables.Copy())
		release_stasis(thing)

/obj/effect/timestop_field/proc/refresh_field()
	if(grayed_atoms?.len)
		for(var/atom/tracked_atom as anything in grayed_atoms.Copy())
			if(QDELETED(tracked_atom) || !is_in_field(tracked_atom) || tracked_atom == caster)
				restore_atom_color(tracked_atom)

	if(stopped_movables?.len)
		for(var/atom/movable/stopped_thing as anything in stopped_movables.Copy())
			if(QDELETED(stopped_thing) || !is_in_field(stopped_thing) || stopped_thing == caster)
				release_stasis(stopped_thing)

	for(var/turf/affected_turf as anything in affected_turfs)
		track_atom_color(affected_turf)
		for(var/atom/movable/movable_atom as anything in affected_turf)
			if(movable_atom == src || movable_atom == caster)
				continue
			track_atom_color(movable_atom)
			apply_stasis(movable_atom)

/obj/effect/proc_holder/spell/self/timestop
	name = "时间暂停"
	desc = "暂停一小片区域的时间9s，这是能征服世界的力量啊！WRYYYYYYY！"
	school = "transmutation"
	action_icon = TIMESTOP_ACTION_ICON
	action_icon_state = "time"
	overlay_state = "time"
	cost = 16
	releasedrain = 500
	chargedrain = 10
	chargetime = 0
	recharge_time = 2 MINUTES
	cooldown_min = 2 MINUTES
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 4
	gesture_required = TRUE
	invocations = list("THE WORLD!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	sound = null
	miracle = FALSE
	xp_gain = TRUE

/obj/effect/proc_holder/spell/self/timestop/choose_targets(mob/user = usr)
	if(!user)
		revert_cast()
		return

	var/cast_time = get_chargetime()
	if(cast_time > 0)
		user.visible_message(span_warning("[user] 高举魔力，仿佛要将整个世界都拽入静止！"), span_notice("我高举魔力，世界啊，准备静止吧......"))
		if(!do_after(user, cast_time, target = user, progress = TRUE))
			to_chat(user, span_warning("我的时流操控被打断了！"))
			revert_cast(user)
			return

	user.visible_message(
		span_warning("[user] 宛如君临世界的魔王般张狂高喝：\"THE WORLD!\""),
		span_notice("我张狂地高喝：\"THE WORLD!\" 世界啊，停下吧！")
	)
	var/list/original_invocations = invocations
	var/original_invocation_type = invocation_type
	invocations = null
	invocation_type = "none"
	perform(null, user = user)
	invocations = original_invocations
	invocation_type = original_invocation_type


/obj/effect/proc_holder/spell/self/timestop/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/turf/origin = get_turf(user)
	if(!origin)
		revert_cast()
		return FALSE

	new /obj/effect/timestop_field(origin, user)
	user.visible_message(span_warning("[user] 将周遭的时流生生扭入一片灰白死寂的静止之中！"), span_notice("我将身边一小片区域的时间彻底暂停，而自己仍游离于静止之外。"))
	return TRUE

#undef TIMESTOP_FIELD_HALF_SIZE
#undef TIMESTOP_FIELD_DURATION
#undef TIMESTOP_REFRESH_INTERVAL
#undef TIMESTOP_HOLD_DURATION
#undef TIMESTOP_NULL_COLOR
#undef TIMESTOP_MUTE_SOURCE
#undef TIMESTOP_ACTION_ICON
#undef TIMESTOP_FIELD_ICON
#undef TIMESTOP_SOUND
