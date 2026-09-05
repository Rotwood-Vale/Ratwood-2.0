/**
 * Expanding circular shockwave.
 *
 * Radius is fully configurable, from a few tiles up to the whole map, so the
 * cost model matters more than the effect. The destructible types register
 * themselves in GLOB.shockwave_targets, and a wave costs one pass over that
 * list - on the order of a thousand entries for a full map - plus a pass over
 * the player list. No turf sweep at that scale: a map-wide radius would mean
 * tens of thousands of turfs per z-level, almost all of them empty.
 *
 * Walls and loose objects are the exception, because neither can live in the
 * registry. They are found by an actual turf scan, but a hard bounded one that
 * never grows with radius - see gather_walls.
 *
 * Both passes bucket everything by distance up front. Each tick afterwards only
 * touches the buckets the wavefront has just crossed, which is what gives the
 * travelling ring for free.
 */

/// Everything a shockwave can act on. Members register themselves below.
GLOBAL_LIST_EMPTY(shockwave_targets)

/// Ripple settings, kept live so they can be tuned in game rather than
/// recompiled. Edited by the "Shockwave: Visuals" verb, or by VV on the global.
/proc/shockwave_visual_defaults()
	return list(
		"amplitude base" = 12,
		"amplitude gain" = 40,
		"band falloff" = 0.5,
		"duration ds" = 9,
		// Floor on the derived duration. A small blast works out to
		// (radius * 32) / (speed * 32) ticks, so a radius 3 wave at speed 3 is
		// a single tick and simply cannot be seen. Only ever raises it.
		"min duration ds" = 4,
		"end amplitude" = 0.35,
		"travel px" = 480,
		// 0 means the whole blast. Anything lower than the radius leaves the
		// people past it taking the hit with nothing on screen to explain it,
		// and capping it saves nothing worth having - there is one ripple per
		// player, so the count follows the playercount, not the radius.
		"range tiles" = 0,
		// The plane masters sit at screen_loc "CENTER", but this HUD's visual
		// centre does not line up with it - the same reason several plane
		// masters carry a commented out "CENTER-2" and the weather plane still
		// uses one. Calibrated by eye rather than derived; adjust in the panel
		// if the ripple drifts off the epicentre.
		"origin x px" = 64,
		"origin y px" = 0,
		// Blooms the ring out of each viewer instead of out of the epicentre,
		// paced by "duration ds" rather than by the front. Only sensible for a
		// wave that reaches everyone at once - see distort().
		"centre on viewer" = 0,
	)

GLOBAL_LIST_INIT(shockwave_visuals, shockwave_visual_defaults())

/// How hard a wave hits and what it costs to break through. Read once per wave
/// into the datum, so tuning mid-flight never changes a blast already running.
/proc/shockwave_damage_defaults()
	return list(
		"base damage" = 150,
		"wall damage mult" = 4,
		"wall absorb scale" = 4000,
		"wall hold" = 0.35,
		"wall range per power" = 24,
		"wall range cap" = 64,
		"z cost" = 8,
		"knockdown floor" = 0.25,
		"knockdown time ds" = 60,
		"body damage" = 5,
		"ringing volume" = 45,
		"ringing time ds" = 80,
		// Off by default: throwing every loose item is a big, messy change to
		// what a blast does, so it is opted into rather than assumed.
		"throw objects" = 0,
		"throw range" = 5,
		"throw speed" = 2,
		// Off makes a wave visual only: nothing is gathered to break and the
		// wall scan is skipped entirely, so only the player pass runs. Every
		// effect in stagger() still lands - the map just does not change.
		"destroy" = 1,
		// Ignores z linkage and the radius when deciding who is caught, so an
		// event wide blast reaches every player wherever they are standing.
		"reach all players" = 0,
		// Floor under the distance falloff. Normally the rim gets nothing;
		// raise it when everyone is meant to feel the wave regardless of range.
		"strength floor" = 0,
	)

GLOBAL_LIST_INIT(shockwave_damage, shockwave_damage_defaults())

/// Default blast shape, used by the verb and the tuner's fire button.
/proc/shockwave_blast_defaults()
	return list(
		"radius" = 15,
		"power" = 1,
		"speed" = 2,
		"z reach" = 1,
	)

GLOBAL_LIST_INIT(shockwave_blast, shockwave_blast_defaults())

/**
 * Plane master keys the distortion filter is applied to, as hud_used indexes
 * them. All of them must move together or the layers visibly desync.
 *
 * Every plane here must override backdrop(), because that is what removes the
 * ripple afterwards and the base implementation is empty. GAME_PLANE_HIGHEST is
 * deliberately absent for that reason - it belongs to the vampire blood-sight
 * plane master, which has no override, so a filter left there would never clear.
 */
GLOBAL_LIST_INIT(shockwave_distorted_planes, list(
	"[FLOOR_PLANE]",
	"[WALL_PLANE]",
	"[GAME_PLANE_LOWER]",
	"[GAME_PLANE]",
	"[GAME_PLANE_FOV_HIDDEN]",
	"[GAME_PLANE_UPPER]",
))

#define SHOCKWAVE_FILTER "shockwave_ripple"
/**
 * Channel the ear ringing loops on.
 *
 * It has to be addressable so it can be faded and stopped, but the reserved
 * block above CHANNEL_HIGHEST_AVAILABLE is full and lowering that ceiling means
 * editing core. Sitting on the top of the dynamic pool is the safe compromise:
 * BYOND allocates from the bottom, so this is the last channel it would hand
 * out on its own.
 */
#define CHANNEL_SHOCKWAVE_RINGING CHANNEL_HIGHEST_AVAILABLE
/// Angular sectors the wave is split into. Energy is tracked per sector, so a
/// wall only drains the direction it actually stands in the way of.
#define SHOCKWAVE_SECTORS 16

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

// The whole flora tree, so grass, bushes, undergrowth and leaves all clear.
// Trees and branches come along too; at default power they take damage without
// being destroyed, since they carry far more integrity than the blast deals.
/obj/structure/flora/New()
	GLOB.shockwave_targets += src
	return ..()

/obj/structure/flora/Destroy()
	GLOB.shockwave_targets -= src
	return ..()

/**
 * Fires a shockwave. See /datum/shockwave for the arguments.
 *
 * `visuals` and `tuning` override individual GLOB.shockwave_visuals and
 * GLOB.shockwave_damage keys for this blast only, so a particular source can
 * look or hit differently without moving the numbers everyone else uses. Any
 * key from the matching defaults proc is valid.
 */
/proc/shockwave(atom/epicenter, radius = 15, power = 1, speed = 2, silent = FALSE, mob/spare_shake, z_reach = 1, list/visuals, list/tuning)
	return new /datum/shockwave(epicenter, radius, power, speed, silent, spare_shake, z_reach, visuals, tuning)

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
	/// How many linked z-levels up and down the wave carries.
	var/z_reach = 1
	/// Indexed by z: extra tiles of distance for that level, null if out of reach.
	var/list/z_costs
	/// Remaining energy per angular sector, spent by whatever the front breaks.
	var/list/sector_energy
	// Snapshot of GLOB.shockwave_damage, taken once so a wave stays consistent
	// even if the numbers are retuned while it is still travelling.
	var/base_damage
	var/wall_mult
	var/absorb_scale
	var/wall_hold
	var/wall_range_per_power
	var/wall_range_cap
	var/z_cost_per_level
	var/knockdown_floor
	var/knockdown_time
	var/body_damage
	var/ringing_volume
	var/ringing_time
	var/throw_objects
	var/throw_range
	var/throw_speed
	/// Whether the wave touches the map at all. Off leaves only player effects.
	var/destroy
	/// Whether every player is caught, ignoring z linkage and radius.
	var/reach_all
	/// Lower bound on the distance falloff, so the rim is not always nothing.
	var/strength_floor
	/// Loose movables by ring, mapped to the sector they sit in.
	var/list/throw_rings
	/// Per-blast overrides layered over GLOB.shockwave_visuals, or null.
	var/list/visual_overrides
	/// Tiles out to which viewers get the distortion, honouring any override.
	var/distort_range
	/// Whether the ripple is centred on the viewer rather than the epicentre.
	var/centre_on_viewer
	/// rings[n] maps each target at that distance to the sector it sits in.
	var/list/rings
	/// Same bucketing for mobs, which take different effects.
	var/list/mob_rings
	/// How far the front has already swept.
	var/front = 0
	/**
	 * Client spared the camera shake, so whoever set this off can watch it.
	 *
	 * Keyed on the client rather than the mob because the client is what
	 * shake_camera actually moves, and because someone watching their own
	 * shockwave will usually aghost to do it - that swaps which mob they are
	 * without swapping which screen shakes, and a mob-keyed exemption stops
	 * matching the moment they do.
	 */
	var/client/unshaken

/datum/shockwave/New(atom/epicenter, radius = 15, power = 1, speed = 2, silent = FALSE, mob/spare_shake, z_reach = 1, list/visuals, list/tuning)
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
	unshaken = spare_shake?.client
	src.z_reach = max(0, round(z_reach))
	visual_overrides = visuals
	// Resolved here rather than read from the global at use time, so a blast
	// that overrides its range actually gets it - stagger() has no view of the
	// override list otherwise.
	if(visuals && ("range tiles" in visuals))
		distort_range = visuals["range tiles"]
	else
		distort_range = GLOB.shockwave_visuals["range tiles"]
	if(distort_range <= 0)
		distort_range = src.radius
	if(visuals && ("centre on viewer" in visuals))
		centre_on_viewer = visuals["centre on viewer"]
	else
		centre_on_viewer = GLOB.shockwave_visuals["centre on viewer"]

	var/list/tune = GLOB.shockwave_damage
	// Copied only when something actually overrides, same as the visuals.
	if(length(tuning))
		tune = tune.Copy()
		for(var/key in tuning)
			tune[key] = tuning[key]
	base_damage = tune["base damage"]
	wall_mult = tune["wall damage mult"]
	absorb_scale = max(1, tune["wall absorb scale"])
	wall_hold = tune["wall hold"]
	wall_range_per_power = tune["wall range per power"]
	wall_range_cap = tune["wall range cap"]
	z_cost_per_level = tune["z cost"]
	knockdown_floor = tune["knockdown floor"]
	knockdown_time = tune["knockdown time ds"]
	body_damage = tune["body damage"]
	ringing_volume = tune["ringing volume"]
	ringing_time = tune["ringing time ds"]
	throw_objects = tune["throw objects"]
	throw_range = tune["throw range"]
	throw_speed = tune["throw speed"]
	destroy = tune["destroy"]
	reach_all = tune["reach all players"]
	strength_floor = tune["strength floor"]

	map_z_reach()
	gather()
	gather_walls()
	paint()
	if(!silent)
		announce(center)
	sweep()

/**
 * Works out which z-levels the wave carries to, and what each one costs.
 *
 * Walks the map's own up/down linkage rather than assuming z +/- 1 is
 * physically above or below - unconnected levels are separate places, and a
 * blast in a cellar has no business rattling an unrelated dungeon.
 */
/datum/shockwave/proc/map_z_reach()
	z_costs = new /list(world.maxz)
	if(cz < 1 || cz > world.maxz)
		return
	z_costs[cz] = 0

	var/list/links = SSmapping.multiz_levels
	for(var/direction in 1 to 2)
		var/up = (direction == 1)
		var/z = cz
		for(var/step in 1 to z_reach)
			var/list/link = (z >= 1 && z <= length(links)) ? links[z] : null
			if(!link || !link[up ? Z_LEVEL_UP : Z_LEVEL_DOWN])
				break
			z += up ? 1 : -1
			if(z < 1 || z > world.maxz)
				break
			z_costs[z] = step * z_cost_per_level

/// Which angular sector an offset from the epicentre falls in.
/datum/shockwave/proc/sector_of(dx, dy)
	if(!dx && !dy)
		return 1
	var/angle = arctan(dx, dy)
	if(angle < 0)
		angle += 360
	return (round(angle / (360 / SHOCKWAVE_SECTORS)) % SHOCKWAVE_SECTORS) + 1

/// Single pass over the registries, bucketing everything in reach by distance.
/// This is the whole cost of a wave; everything after it is bucket lookups.
/datum/shockwave/proc/gather()
	sector_energy = new /list(SHOCKWAVE_SECTORS)
	for(var/i in 1 to SHOCKWAVE_SECTORS)
		sector_energy[i] = power

	rings = new /list(radius + 1)
	mob_rings = new /list(radius + 1)
	throw_rings = new /list(radius + 1)
	// Pre-built so the hot loop can write straight into them. `rings[n] += x`
	// would go through index assignment, rebuilding the inner list every time.
	for(var/i in 1 to radius + 1)
		rings[i] = list()
		mob_rings[i] = list()
		throw_rings[i] = list()

	// Skipped wholesale for a visual only wave. Leaving the buckets empty is
	// what makes it free: strike() finds nothing to hit and never looks again.
	if(destroy)
		for(var/atom/movable/target as anything in GLOB.shockwave_targets)
			if(QDELETED(target))
				continue
			var/turf/spot = get_turf(target)
			if(!spot)
				continue
			var/z_cost = (spot.z >= 1 && spot.z <= length(z_costs)) ? z_costs[spot.z] : null
			if(isnull(z_cost))
				continue
			// What is left of the radius once the climb between levels is paid for.
			var/reach = radius - z_cost
			if(reach < 1)
				continue
			var/dx = spot.x - cx
			var/dy = spot.y - cy
			var/spread = dx * dx + dy * dy
			// Reject on the square first; sqrt only for what actually landed.
			if(spread > reach * reach)
				continue
			var/list/bucket = rings[round(sqrt(spread) + z_cost) + 1]
			bucket[target] = sector_of(dx, dy)

	for(var/mob/viewer as anything in GLOB.player_list)
		if(QDELETED(viewer))
			continue
		var/turf/spot = get_turf(viewer)
		if(!spot)
			continue
		var/dx = spot.x - cx
		var/dy = spot.y - cy
		var/spread = dx * dx + dy * dy
		var/index
		if(reach_all)
			// Nobody is rejected and no level costs anything. Clamped to the
			// rim so someone standing past the radius still lands in a bucket
			// and is swept when the front finishes, rather than being dropped.
			index = min(round(sqrt(spread)), radius) + 1
		else
			var/z_cost = (spot.z >= 1 && spot.z <= length(z_costs)) ? z_costs[spot.z] : null
			if(isnull(z_cost))
				continue
			var/reach = radius - z_cost
			if(reach < 1)
				continue
			if(spread > reach * reach)
				continue
			index = round(sqrt(spread) + z_cost) + 1
		var/list/bucket = mob_rings[index]
		bucket[viewer] = sector_of(dx, dy)

/**
 * Buckets wall turfs near the blast.
 *
 * Walls are turfs, so they cannot live in the object registry. They are scanned
 * instead, over a range that scales with power but is hard capped - a full-map
 * wave would otherwise sweep every turf on every level it touches. Walls only
 * fall near the epicentre anyway, so the cap costs nothing visible.
 */
/datum/shockwave/proc/gather_walls()
	if(!destroy)
		return
	var/range = min(radius, min(wall_range_cap, round(wall_range_per_power * power)))
	if(range < 1)
		return

	for(var/z in 1 to length(z_costs))
		var/z_cost = z_costs[z]
		if(isnull(z_cost))
			continue
		var/reach = min(range, radius - z_cost)
		if(reach < 1)
			continue
		var/turf/low = locate(max(1, cx - reach), max(1, cy - reach), z)
		var/turf/high = locate(min(world.maxx, cx + reach), min(world.maxy, cy + reach), z)
		if(!low || !high)
			continue
		var/reach_sq = reach * reach
		for(var/turf/found as anything in block(low, high))
			var/dx = found.x - cx
			var/dy = found.y - cy
			var/spread = dx * dx + dy * dy
			if(spread > reach_sq)
				continue
			var/sector = sector_of(dx, dy)
			var/index = round(sqrt(spread) + z_cost) + 1

			if(istype(found, /turf/closed/wall))
				var/list/bucket = rings[index]
				bucket[found] = sector
				continue

			if(!throw_objects)
				continue
			// Open turf: sweep up anything loose sitting on it. Mobs are left
			// out - they get knocked down rather than launched.
			var/list/loose = throw_rings[index]
			for(var/atom/movable/thing in found)
				if(thing.anchored || ismob(thing))
					continue
				loose[thing] = sector
		CHECK_TICK

/// Everyone the wave reaches hears it, scaled by how far out they are.
/datum/shockwave/proc/announce(turf/center)
	for(var/mob/listener as anything in GLOB.player_list)
		var/turf/spot = get_turf(listener)
		if(!spot)
			continue
		var/distance
		if(reach_all)
			// get_dist is no use across unlinked levels, so measure flat. The
			// bang has to arrive for the same people the wave does.
			var/dx = spot.x - cx
			var/dy = spot.y - cy
			distance = min(round(sqrt(dx * dx + dy * dy)), radius)
		else
			var/z_cost = (spot.z >= 1 && spot.z <= length(z_costs)) ? z_costs[spot.z] : null
			if(isnull(z_cost))
				continue
			distance = get_dist(spot, center) + z_cost
		var/volume = 100 * power * max(1 - (distance / max(radius, 1)) * 0.7, strength_floor)
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
	// Linear falloff, so power is what lands at the centre and nothing at the
	// rim - unless a floor is set, in which case the rim gets that much.
	var/falloff = max(1 - ((ring - 1) / radius), strength_floor)
	if(falloff <= 0)
		return

	var/list/targets = rings[ring]
	if(length(targets))
		for(var/atom/target as anything in targets)
			if(QDELETED(target))
				continue
			var/sector = targets[target]
			var/energy = sector_energy[sector]
			// This direction is spent already - something ahead absorbed it.
			if(energy <= 0)
				continue
			var/strength = energy * falloff
			if(isturf(target))
				breach(target, sector, strength)
				continue
			var/obj/thing = target
			var/damage = base_damage * strength
			var/absorbed = min(damage, thing.obj_integrity)
			// take_damage carries each type's own reaction: chairs topple into
			// a loose item, windows run obj_break, leaves just die.
			thing.take_damage(damage, BRUTE, "blunt")
			sector_energy[sector] -= absorbed / absorb_scale
		CHECK_TICK

	var/list/loose = throw_rings[ring]
	if(length(loose))
		for(var/atom/movable/thing as anything in loose)
			if(QDELETED(thing) || thing.anchored)
				continue
			var/energy = sector_energy[loose[thing]]
			if(energy <= 0)
				continue
			hurl(thing, energy * falloff)
		CHECK_TICK

	var/list/viewers = mob_rings[ring]
	if(length(viewers))
		for(var/mob/viewer as anything in viewers)
			if(QDELETED(viewer))
				continue
			var/energy = sector_energy[viewers[viewer]]
			if(energy <= 0)
				continue
			stagger(viewer, energy * falloff, ring)
		CHECK_TICK

/**
 * Puts the front through one wall and charges the sector for it.
 *
 * Breaking through costs energy in proportion to what the wall had left, so
 * stone drains far more than a tent does. A wall that holds reflects the front
 * instead, and most of that direction stops there.
 */
/datum/shockwave/proc/breach(turf/wall, sector, strength)
	if(!istype(wall, /turf/closed/wall) || wall.turf_integrity <= 0)
		return
	var/damage = base_damage * wall_mult * strength
	// With wall damage turned off entirely, walls simply are not part of the
	// model - they must not silently drain every sector instead.
	if(damage <= 0)
		return
	var/before = wall.turf_integrity

	// Mirrors turf/take_damage's own deflection check, so the wave is never
	// charged for a hit that never landed.
	if(damage >= wall.damage_deflection)
		wall.take_damage(damage, BRUTE, "blunt")

	// A destroyed wall is replaced in place, so it stops being a wall turf.
	if(!istype(wall, /turf/closed/wall) || wall.turf_integrity <= 0)
		sector_energy[sector] -= min(damage, before) / absorb_scale
	else
		sector_energy[sector] *= wall_hold

/// Launches one loose object away from the epicentre.
/datum/shockwave/proc/hurl(atom/movable/thing, strength)
	// Same bar the tornado uses, so anything too heavy for wind stays put.
	if(thing.move_resist > MOVE_FORCE_EXTREMELY_STRONG)
		return
	var/turf/spot = get_turf(thing)
	if(!spot)
		return

	var/distance = max(1, round(throw_range * strength))

	// Anything sitting exactly on the epicentre has no outward direction of its
	// own, so it gets scattered instead.
	var/direction
	if(spot.x == cx && spot.y == cy)
		direction = pick(GLOB.alldirs)
	else
		direction = get_dir(locate(cx, cy, spot.z), spot)

	var/turf/destination = get_ranged_target_turf(spot, direction, distance)
	if(!destination)
		return
	thing.throw_at(destination, distance, throw_speed, spin = TRUE)

/datum/shockwave/proc/stagger(mob/viewer, strength, ring)
	if(viewer.client != unshaken)
		shake_camera(viewer, 3 + round(5 * strength), strength)

	if(isliving(viewer))
		var/mob/living/victim = viewer
		// Knockdown itself checks CANKNOCKDOWN and stun immunity, so anything
		// that should stay standing still does.
		if(strength >= knockdown_floor)
			var/static/list/floored = list(
				"The ground bucks and throws me down!",
				"A wall of force slams through me and takes my legs!",
				"The world lurches - I am thrown from my feet!",
			)
			victim.Knockdown(knockdown_time * strength)
			to_chat(victim, span_userdanger(pick(floored)))
		else
			var/static/list/rattled = list(
				"A deep shudder rolls through the ground beneath me.",
				"The earth trembles under my feet.",
			)
			to_chat(victim, span_danger(pick(rattled)))

		// Spread rather than aimed at one limb: the whole body takes the front.
		var/bruising = body_damage * strength
		if(bruising > 0)
			victim.take_overall_damage(bruising)

		if(iscarbon(victim))
			var/mob/living/carbon/deafened = victim
			// Returns how far the bang got past ear protection, so earmuffs
			// spare the ringing as well as the deafness.
			var/got_through = deafened.soundbang_act(1, 10 * strength, 8 * strength, 20 * strength)
			if(got_through > 0)
				shockwave_ringing(deafened, strength, ringing_volume, ringing_time)

	// The ripple is not fired here - see paint(). It is one animation started
	// when the blast does, so it stays locked to the front.

/**
 * Screen-space ripple on the world plane masters.
 *
 * Plane master filters are screen-space, so the ripple origin has to be worked
 * out per viewer as a pixel offset from their own viewport centre - there is no
 * way to anchor it in the world. An atom-level filter cannot do this at all; it
 * would only distort the atom it sits on, not the world behind it.
 */
/**
 * Puts the ring on everyone who will see it, at the moment the blast begins.
 *
 * Not when the front reaches them: the ring is centred on the epicentre and
 * expands outward, so one animation started now passes every viewer at their
 * own correct moment. Firing it per-arrival meant nobody ever saw the wave
 * coming, only leaving.
 */
/datum/shockwave/proc/paint()
	for(var/ring in 1 to min(distort_range, radius) + 1)
		var/list/viewers = mob_rings[ring]
		if(!length(viewers))
			continue
		// Falloff by distance only. Sector energy is not spent yet at this
		// point, and the ring is one continuous animation rather than something
		// re-evaluated as walls eat into it.
		var/strength = power * max(1 - ((ring - 1) / radius), strength_floor)
		if(strength <= 0)
			continue
		for(var/mob/viewer as anything in viewers)
			if(!QDELETED(viewer))
				distort(viewer, strength)

/datum/shockwave/proc/distort(mob/viewer, strength)
	var/turf/eye = get_turf(viewer)
	if(!eye)
		return
	/*
	 * Out of the viewer, not out of the epicentre.
	 *
	 * A ring locked to the front is right when the front is what matters: it
	 * crosses each person as the damage reaches them. It is useless for a wave
	 * that hits everyone at once, because the front then has to cross the whole
	 * map in the time the moment is supposed to last. At a map radius that
	 * works out around 400px a tick against a 480px viewport - the ring is on
	 * and off a screen inside a single tick, which is why nothing was visible.
	 *
	 * Handing it no reach and no front drops it onto the same path the tuner's
	 * preview uses: a bloom out of the middle of the screen, sized by
	 * "travel px" and paced by "duration ds".
	 */
	if(centre_on_viewer)
		shockwave_ripple(viewer, 0, 0, strength, 0, 0, visual_overrides)
		return
	shockwave_ripple(viewer,
		(cx - eye.x) * world.icon_size,
		(cy - eye.y) * world.icon_size,
		strength,
		radius * world.icon_size,
		speed * world.icon_size,
		visual_overrides)

/**
 * Rings someone's ears.
 *
 * The clip carries its own onset punch and decay, so this is a one shot rather
 * than a loop being faded by hand - it hits hard the moment the front arrives
 * and rings out on its own. It still goes on an addressable channel so a weak
 * blast can be cut short rather than ringing for the full tail.
 */
/proc/shockwave_ringing(mob/victim, strength, volume, duration)
	var/level = volume * strength
	if(level <= 0)
		return

	SEND_SOUND(victim, sound('modular_fenysha_events/sound/ear_ringing.wav',
		repeat = FALSE, wait = 0, volume = level, channel = CHANNEL_SHOCKWAVE_RINGING))

	// Scaled by strength, so a glancing blast rings briefly and a direct one
	// gets the whole tail. At full strength this matches the clip length and
	// nothing is cut.
	var/cut_after = duration * strength
	if(cut_after > 0)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(shockwave_ringing_stop), victim), cut_after)

/// Cuts the ringing channel early, for blasts that did not earn a full tail.
/proc/shockwave_ringing_stop(mob/victim)
	if(!victim)
		return
	SEND_SOUND(victim, sound(null, repeat = FALSE, wait = 0, channel = CHANNEL_SHOCKWAVE_RINGING))

/**
 * Puts one ripple on a viewer's world planes.
 *
 * Split out from the shockwave itself so the tuner can preview it without
 * setting anything off. Reads GLOB.shockwave_visuals every time, so edits made
 * in game take effect on the next ripple with no recompile.
 */
/proc/shockwave_ripple(mob/viewer, offset_x = 0, offset_y = 0, strength = 1, reach_px = 0, front_px_per_tick = 0, list/overrides)
	if(!viewer?.client || !viewer.hud_used)
		return

	var/list/tune = GLOB.shockwave_visuals
	// Copied only when something actually overrides, so the common path stays a
	// plain read of the global.
	if(length(overrides))
		tune = tune.Copy()
		for(var/key in overrides)
			tune[key] = overrides[key]
	var/size = tune["amplitude base"] + round(tune["amplitude gain"] * strength)
	offset_x += tune["origin x px"]
	offset_y += tune["origin y px"]

	/*
	 * The ring is centred on the epicentre and grows outward, so it has to
	 * start out at the viewer's own distance from it rather than at zero.
	 * Starting at zero means that for anyone far from the blast the ring
	 * finishes expanding before it ever reaches their screen, and they see
	 * nothing at all - which is exactly what happens when the epicentre is off
	 * screen. Starting level with them also puts the sweep at the right moment:
	 * the front is arriving now, so the ring should be crossing them now.
	 */
	var/from_origin = sqrt(offset_x * offset_x + offset_y * offset_y)

	/*
	 * Where the ring stops, and how long it takes to get there.
	 *
	 * A real blast hands us both: it ends at the blast radius and moves at the
	 * front's own speed, so the ring keeps pace with the damage instead of
	 * drifting out of step with it. Without those - a bare preview - it falls
	 * back to the tuned span and duration.
	 */
	/*
	 * The ring starts as a point at the epicentre and grows at exactly the rate
	 * the front travels, so its radius always equals the front's radius. That
	 * is what keeps the visual and the damage together: it crosses each person
	 * at the instant the wave reaches them, and the approach is visible rather
	 * than the ring appearing on top of them already.
	 *
	 * The minimum duration is only for a preview, which has no front to match.
	 * Applying it to a real blast would slow the ring below the wave and pull
	 * the two apart - to make a small blast readable, lower its speed instead,
	 * which slows both together.
	 */
	var/end_radius = reach_px > 0 ? reach_px : from_origin + tune["travel px"]
	var/duration
	if(front_px_per_tick > 0)
		duration = end_radius / front_px_per_tick
	else
		duration = max(tune["min duration ds"], tune["duration ds"])
	duration = max(1, duration)

	for(var/key in GLOB.shockwave_distorted_planes)
		var/atom/movable/screen/plane_master/plane = viewer.hud_used.plane_masters[key]
		if(!plane)
			continue
		// Appended raw and animated on the filter object itself, the way the
		// druqks effect does it. The named-filter API cannot be used here:
		// add_filter and transition_filter both run update_filters(), which
		// rebuilds `filters` from filter_data alone - that discards the running
		// animation, and takes the ambient occlusion and blur that backdrop()
		// sets raw down with it.
		// Identical parameters on every plane, or the layers tear apart.
		plane.filters += filter(arglist(ripple_filter(
			radius = 0,
			size = size,
			falloff = tune["band falloff"],
			x = offset_x,
			y = offset_y,
		)))
		var/ripple = plane.filters[plane.filters.len]
		// Amplitude decays but never reaches zero, which would be invisible.
		// Linear, not eased: the front travels at a constant rate, so easing the
		// ring would visibly desync it from the damage arriving.
		animate(ripple, radius = end_radius, size = size * tune["end amplitude"], time = duration, easing = LINEAR_EASING)
		// backdrop() is the codebase's own reset for a plane master's filters,
		// so it drops the ripple and puts the occlusion back in one go.
		addtimer(CALLBACK(plane, TYPE_PROC_REF(/atom/movable/screen/plane_master, backdrop), viewer), duration)

/client/proc/fenysha_shockwave()
	set category = "Fun"
	set name = "Shockwave"
	set desc = "Sets off a shockwave here using the current settings."
	if(!check_rights(R_FUN))
		return

	var/turf/epicenter = get_turf(mob)
	if(!epicenter)
		return
	fire_shockwave(epicenter, mob)

/// Shared by the verb and the tuner's fire button, so both stay in step.
/proc/fire_shockwave(turf/epicenter, mob/caster)
	var/list/blast = GLOB.shockwave_blast
	if(caster?.client)
		log_admin("[key_name(caster)] set off a shockwave at [epicenter.x],[epicenter.y],[epicenter.z] radius [blast["radius"]] power [blast["power"]].")
		message_admins("[key_name_admin(caster)] set off a shockwave, radius [blast["radius"]] power [blast["power"]] [ADMIN_JMP(epicenter)]")
	// The caster is spared the shake so they can watch the distortion.
	return shockwave(epicenter, blast["radius"], blast["power"], blast["speed"], FALSE, caster, blast["z reach"])

#undef SHOCKWAVE_FILTER
#undef CHANNEL_SHOCKWAVE_RINGING
#undef SHOCKWAVE_SECTORS
