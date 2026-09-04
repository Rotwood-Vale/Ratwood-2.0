/**
 * Expanding circular shockwave.
 *
 * Radius is fully configurable, from a few tiles up to the whole map, so the
 * cost model matters more than the effect. Nothing here iterates turfs: a
 * map-wide radius would mean tens of thousands of turfs per z-level, almost all
 * of them empty. Instead the destructible types register themselves in
 * GLOB.shockwave_targets, and a wave costs one pass over that list - on the
 * order of a thousand entries for a full map - plus a pass over the player list.
 *
 * That pass buckets everything by distance up front. Each tick afterwards only
 * touches the buckets the wavefront has just crossed, which is what gives the
 * travelling ring for free.
 */

/// Everything a shockwave can act on. Members register themselves below.
GLOBAL_LIST_EMPTY(shockwave_targets)

/// Plane master keys the distortion filter is applied to, as hud_used indexes
/// them. All of them must move together or the layers visibly desync.
GLOBAL_LIST_INIT(shockwave_distorted_planes, list(
	"[FLOOR_PLANE]",
	"[WALL_PLANE]",
	"[GAME_PLANE_LOWER]",
	"[GAME_PLANE]",
	"[GAME_PLANE_FOV_HIDDEN]",
	"[GAME_PLANE_UPPER]",
	"[GAME_PLANE_HIGHEST]",
))

/// Damage dealt at the epicentre before falloff. Windows need 100 to break,
/// chairs topple past 5, leaves die at 10.
#define SHOCKWAVE_BASE_DAMAGE 150
/// Beyond this many tiles the epicentre is well off screen, so the screen-space
/// distortion has nothing to bend and is skipped.
#define SHOCKWAVE_DISTORT_RANGE 30
#define SHOCKWAVE_FILTER "shockwave_ripple"

/**
 * Registry membership.
 *
 * Hooked on New rather than Initialize purely to stay modular: all three types
 * already define Initialize in core, and DM will not take a second definition of
 * the same proc on the same type from another file.
 *
 * Registration goes before ..() because /atom/New can qdel the atom while
 * initialising it. Registering afterwards would let Destroy run first and leave
 * a deleted object in the list forever.
 */

/obj/structure/roguewindow/New()
	GLOB.shockwave_targets += src
	return ..()

/obj/structure/roguewindow/Destroy()
	GLOB.shockwave_targets -= src
	return ..()

/obj/structure/chair/wood/rogue/New()
	GLOB.shockwave_targets += src
	return ..()

/obj/structure/chair/wood/rogue/Destroy()
	GLOB.shockwave_targets -= src
	return ..()

/obj/structure/flora/newleaf/New()
	GLOB.shockwave_targets += src
	return ..()

/obj/structure/flora/newleaf/Destroy()
	GLOB.shockwave_targets -= src
	return ..()

/// Fires a shockwave. See /datum/shockwave for the arguments.
/proc/shockwave(atom/epicenter, radius = 15, power = 1, speed = 2, silent = FALSE)
	return new /datum/shockwave(epicenter, radius, power, speed, silent)

/datum/shockwave
	/// Epicentre, cached as coordinates so we never re-resolve the turf.
	var/cx
	var/cy
	var/cz
	/// Maximum reach in tiles.
	var/radius
	/// Scales damage and every mob effect. 1 is a full-strength blast.
	var/power
	/// Tiles the wavefront advances each tick. Larger radii want a larger value.
	var/speed
	/// rings[n] holds the targets whose distance rounds to n - 1.
	var/list/rings
	/// Same bucketing for mobs, which take different effects.
	var/list/mob_rings
	/// How far the front has already swept.
	var/front = 0

/datum/shockwave/New(atom/epicenter, radius = 15, power = 1, speed = 2, silent = FALSE)
	set waitfor = FALSE

	var/turf/center = get_turf(epicenter)
	if(!center || radius < 1)
		return

	cx = center.x
	cy = center.y
	cz = center.z
	src.radius = round(radius)
	src.power = power
	src.speed = max(1, round(speed))

	gather()
	if(!silent)
		announce(center)
	sweep()

/// Single pass over the registries, bucketing everything in reach by distance.
/// This is the whole cost of a wave; everything after it is bucket lookups.
/datum/shockwave/proc/gather()
	var/radius_sq = radius * radius
	rings = new /list(radius + 1)
	mob_rings = new /list(radius + 1)
	// Pre-built so the hot loop can Add() in place. `rings[n] += x` would go
	// through index assignment, rebuilding the inner list on every append.
	for(var/i in 1 to radius + 1)
		rings[i] = list()
		mob_rings[i] = list()

	for(var/atom/movable/target as anything in GLOB.shockwave_targets)
		if(QDELETED(target))
			continue
		var/turf/spot = get_turf(target)
		if(!spot || spot.z != cz)
			continue
		var/dx = spot.x - cx
		var/dy = spot.y - cy
		var/spread = dx * dx + dy * dy
		// Reject on the square first; sqrt only for what actually landed.
		if(spread > radius_sq)
			continue
		var/list/bucket = rings[round(sqrt(spread)) + 1]
		bucket.Add(target)

	for(var/mob/viewer as anything in GLOB.player_list)
		if(QDELETED(viewer))
			continue
		var/turf/spot = get_turf(viewer)
		if(!spot || spot.z != cz)
			continue
		var/dx = spot.x - cx
		var/dy = spot.y - cy
		var/spread = dx * dx + dy * dy
		if(spread > radius_sq)
			continue
		var/list/bucket = mob_rings[round(sqrt(spread)) + 1]
		bucket.Add(viewer)

/// Everyone on the z hears it, scaled by how far out they are.
/datum/shockwave/proc/announce(turf/center)
	for(var/mob/listener as anything in GLOB.player_list)
		var/turf/spot = get_turf(listener)
		if(!spot || spot.z != cz)
			continue
		var/distance = get_dist(spot, center)
		var/volume = 100 * power * (1 - (distance / max(radius, 1)) * 0.7)
		if(volume <= 0)
			continue
		listener.playsound_local(center, 'sound/misc/explode/explosion.ogg', volume, TRUE)

/// Walks the front outward, striking the buckets it crosses.
/datum/shockwave/proc/sweep()
	set waitfor = FALSE

	while(front < radius)
		var/next = min(front + speed, radius)
		for(var/ring in (front + 1) to next)
			strike(ring)
		front = next
		if(front >= radius)
			break
		stoplag(1)

/datum/shockwave/proc/strike(ring)
	// Linear falloff, so power is what lands at the centre and nothing at the rim.
	var/falloff = 1 - ((ring - 1) / radius)
	if(falloff <= 0)
		return

	var/list/targets = rings[ring]
	if(length(targets))
		var/damage = SHOCKWAVE_BASE_DAMAGE * power * falloff
		if(damage > 0)
			for(var/obj/target as anything in targets)
				// take_damage carries each type's own reaction: chairs topple
				// into a loose item, windows run obj_break, leaves just die.
				if(!QDELETED(target))
					target.take_damage(damage, BRUTE, "blunt")
			CHECK_TICK

	var/list/viewers = mob_rings[ring]
	if(length(viewers))
		for(var/mob/viewer as anything in viewers)
			if(!QDELETED(viewer))
				stagger(viewer, falloff, ring)
		CHECK_TICK

/datum/shockwave/proc/stagger(mob/viewer, falloff, ring)
	var/strength = power * falloff

	shake_camera(viewer, 3 + round(5 * strength), strength)

	if(iscarbon(viewer))
		var/mob/living/carbon/victim = viewer
		victim.soundbang_act(1, 10 * strength, 8 * strength, 20 * strength)

	if(ring <= SHOCKWAVE_DISTORT_RANGE)
		distort(viewer, strength)

/**
 * Screen-space ripple on the world plane masters.
 *
 * Plane master filters are screen-space, so the ripple origin has to be worked
 * out per viewer as a pixel offset from their own viewport centre - there is no
 * way to anchor it in the world. An atom-level filter cannot do this at all; it
 * would only distort the atom it sits on, not the world behind it.
 */
/datum/shockwave/proc/distort(mob/viewer, strength)
	if(!viewer.client || !viewer.hud_used)
		return
	var/turf/eye = get_turf(viewer)
	if(!eye)
		return

	var/offset_x = (cx - eye.x) * world.icon_size
	var/offset_y = (cy - eye.y) * world.icon_size
	var/size = 8 + round(24 * strength)
	var/duration = 0.6 SECONDS

	for(var/key in GLOB.shockwave_distorted_planes)
		var/atom/movable/screen/plane_master/plane = viewer.hud_used.plane_masters[key]
		if(!plane)
			continue
		// Identical parameters on every plane, or the layers tear apart.
		plane.add_filter(SHOCKWAVE_FILTER, 1, ripple_filter(
			radius = 0,
			size = size,
			falloff = 1,
			x = offset_x,
			y = offset_y,
		))
		plane.transition_filter(SHOCKWAVE_FILTER, list("radius" = 480, "size" = 0), duration)
		addtimer(CALLBACK(plane, TYPE_PROC_REF(/atom/movable, remove_filter), SHOCKWAVE_FILTER), duration)

/client/proc/fenysha_shockwave()
	set category = "Fun"
	set name = "Shockwave"
	set desc = "Fires an expanding shockwave outward from your location."
	if(!check_rights(R_FUN))
		return

	var/turf/epicenter = get_turf(mob)
	if(!epicenter)
		return

	var/radius = input(usr, "Radius in tiles. The map is [world.maxx]x[world.maxy].", "Shockwave", 15) as num|null
	if(isnull(radius) || radius < 1)
		return
	var/power = input(usr, "Power. 1 is a full-strength blast.", "Shockwave", 1) as num|null
	if(isnull(power))
		return
	var/speed = input(usr, "Tiles the front advances per tick.", "Shockwave", 2) as num|null
	if(isnull(speed))
		return

	log_admin("[key_name(src)] fired a shockwave at [epicenter.x],[epicenter.y],[epicenter.z] radius [radius] power [power].")
	message_admins("[key_name_admin(src)] fired a shockwave, radius [radius] power [power] [ADMIN_JMP(epicenter)]")
	shockwave(epicenter, radius, power, speed)

#undef SHOCKWAVE_BASE_DAMAGE
#undef SHOCKWAVE_DISTORT_RANGE
#undef SHOCKWAVE_FILTER
