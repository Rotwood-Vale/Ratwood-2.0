/// Open phrases shared by every secret wall with the same secret_door_access, keyed by secret_door_access_key()
GLOBAL_LIST_EMPTY(secret_wall_phrases)
/// Phrases a mapper fixed with open_phrase, keyed like secret_wall_phrases. The first one set wins
GLOBAL_LIST_EMPTY(secret_wall_fixed_phrases)
/// Secret walls that tell some roles their phrase
GLOBAL_LIST_EMPTY(secret_walls_with_access)

/*
 * Secret wall controller. Sits invisibly on a real wall tile, which stays untouched while closed,
 * so the look, smoothing, examine, climbing and damage are all the wall's own.
 * Opening swaps the tile for a floor and closing puts the recorded wall back.
 * Triggered by linked levers (redstone_id) or by a human speaking its phrase next to it.
 */
/obj/structure/secret_wall_controller
	name = "wall"
	desc = ""
	icon = 'icons/effects/hidden_door.dmi' // only seen in the map editor
	icon_state = "hidden_door"
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	nomouseover = TRUE
	density = FALSE
	anchored = TRUE
	move_resist = INFINITY
	resistance_flags = INDESTRUCTIBLE
	interaction_flags_atom = NONE
	obj_flags = NONE

	/// Spoken next to the wall to open it. Left empty, a random phrase is picked. With secret_door_access set, it is the whole access group's phrase
	var/open_phrase
	/// Job types told the phrase through Recall Passphrases. Walls with the same list share one phrase
	var/list/secret_door_access
	/// Rough description of where the wall is, shown by Recall Passphrases. Falls back to the area name
	var/secret_door_locale
	/// secret_door_access_key() of our secret_door_access, null without one
	var/access_key
	/// How long it stays open before trying to close. 0 means a trigger while open closes it instead
	var/auto_close_delay = 5 SECONDS
	/// Direction the wall slides when opening. Null picks a neighbouring closed turf
	var/slide_dir
	/// Floor placed while open, if override_floor is set or the wall has no baseturf
	var/turf/open/floor_turf = /turf/open/floor/rogue/blocks
	/// Use floor_turf instead of the wall's first baseturf
	var/override_floor = TRUE
	var/speaking_distance = 1
	/// How long the slide visual takes
	var/slide_time = 1 SECONDS

	/// The wall restored on closing
	var/turf/closed/wall_type
	var/wall_integrity
	var/wall_dir
	var/wall_icon_state
	/// The wall's appearance when it opened, reused for the closing slide
	var/wall_appearance
	/// The floor type we placed, to tell whether someone replaced it while open
	var/turf/open/placed_floor_type
	var/is_open = FALSE
	/// Mid slide, triggers are ignored
	var/switching = FALSE
	/// Set around our own ChangeTurf calls so on_turf_change() ignores them
	var/self_changing = FALSE
	/// The tile was replaced from outside while open
	var/floor_replaced = FALSE
	/// Pending close attempt
	var/close_timer
	/// Wait before retrying a blocked close
	var/close_retry_delay = 5 SECONDS
	/// Weakrefs to non-living things that sat on the tile while it was a wall. They don't block closing
	var/list/resident_refs

/obj/structure/secret_wall_controller/Initialize(mapload, _redstone_id, _open_phrase, list/_secret_door_access, _secret_door_locale, _auto_close_delay, _slide_dir, _floor_turf, _override_floor)
	// set before the parent call so redstone linkage happens in the normal LateInitialize pass
	if(_redstone_id)
		redstone_id = _redstone_id
	if(_open_phrase)
		open_phrase = _open_phrase
	if(_secret_door_access)
		secret_door_access = _secret_door_access
	if(_secret_door_locale)
		secret_door_locale = _secret_door_locale
	if(!isnull(_auto_close_delay))
		auto_close_delay = _auto_close_delay
	if(_slide_dir)
		slide_dir = _slide_dir
	if(_floor_turf)
		floor_turf = _floor_turf
	if(!isnull(_override_floor))
		override_floor = _override_floor
	. = ..()
	var/turf/T = get_turf(src)
	if(!isclosedturf(T))
		log_mapping("[src] spawned on non-wall turf [T ? T.type : "null"] at [AREACOORD(src)], deleting")
		return INITIALIZE_HINT_QDEL
	icon = null
	wall_type = T.type
	name = T.name
	if(length(secret_door_access))
		access_key = secret_door_access_key(secret_door_access)
	setup_phrase()
	become_hearing_sensitive()
	RegisterSignal(T, COMSIG_TURF_CHANGE, PROC_REF(on_turf_change))
	if(access_key)
		GLOB.secret_walls_with_access += src
		for(var/mob/living/carbon/human/H as anything in GLOB.human_list) // walls loaded mid-round still reach those already playing
			H.check_secret_passphrases()

/obj/structure/secret_wall_controller/Destroy()
	GLOB.secret_walls_with_access -= src
	lose_hearing_sensitivity()
	var/turf/T = get_turf(src)
	if(T)
		UnregisterSignal(T, COMSIG_TURF_CHANGE)
	if(close_timer)
		deltimer(close_timer)
		close_timer = null
	resident_refs = null
	return ..()

/// Picks our phrase, or our access group's phrase which a mapper-set open_phrase overrides
/obj/structure/secret_wall_controller/proc/setup_phrase()
	if(!access_key)
		if(!length(open_phrase))
			open_phrase = random_open_phrase()
		return
	if(!length(open_phrase))
		if(!GLOB.secret_wall_phrases[access_key])
			GLOB.secret_wall_phrases[access_key] = random_open_phrase()
		return
	var/fixed_phrase = GLOB.secret_wall_fixed_phrases[access_key]
	if(fixed_phrase && fixed_phrase != open_phrase)
		log_mapping("[src] at [AREACOORD(src)] sets open_phrase \"[open_phrase]\" but its access group already uses \"[fixed_phrase]\"")
		return
	GLOB.secret_wall_fixed_phrases[access_key] = open_phrase
	GLOB.secret_wall_phrases[access_key] = open_phrase

/// The phrase that opens this wall
/obj/structure/secret_wall_controller/proc/get_phrase()
	if(access_key)
		return GLOB.secret_wall_phrases[access_key]
	return open_phrase

/obj/structure/secret_wall_controller/proc/on_turf_change(datum/source, path, list/new_baseturfs, flags, list/post_change_callbacks)
	SIGNAL_HANDLER
	if(self_changing)
		return
	if(is_open)
		floor_replaced = TRUE // checked when it next tries to close
		return
	qdel(src) // the wall was smashed or replaced, leave whatever is there now

/obj/structure/secret_wall_controller/redstone_triggered(mob/user)
	trigger(user)

/// Returns "opened" or "closed" when it did either, for logging
/obj/structure/secret_wall_controller/proc/trigger(mob/user)
	if(switching)
		return
	if(!is_open)
		return open_wall(user) ? "opened" : null
	if(auto_close_delay) // auto mode ignores triggers while open
		return
	if(close_timer) // a blocked close is pending, cancel it and stay open
		deltimer(close_timer)
		close_timer = null
		return
	return try_close(user) ? "closed" : null

/obj/structure/secret_wall_controller/proc/schedule_close(delay)
	close_timer = addtimer(CALLBACK(src, PROC_REF(try_close)), delay, TIMER_STOPPABLE)

/// Our own ChangeTurf, which on_turf_change() ignores
/obj/structure/secret_wall_controller/proc/change_own_turf(turf/T, new_type)
	self_changing = TRUE
	. = T.ChangeTurf(new_type)
	self_changing = FALSE

/// Someone replaced our floor while open
/obj/structure/secret_wall_controller/proc/is_floor_replaced(turf/T)
	return floor_replaced || T.type != placed_floor_type

/obj/structure/secret_wall_controller/proc/open_wall(mob/user)
	var/turf/closed/T = get_turf(src)
	if(!isclosedturf(T))
		return FALSE
	wall_type = T.type
	wall_integrity = T.turf_integrity
	wall_dir = T.dir
	wall_icon_state = T.icon_state
	resident_refs = list()
	for(var/atom/movable/AM in T)
		if(AM == src || isliving(AM))
			continue
		var/datum/weakref/ref = WEAKREF(AM)
		if(ref)
			resident_refs += ref

	var/turf/open/new_floor = floor_turf
	if(!override_floor && T.baseturfs)
		new_floor = islist(T.baseturfs) ? T.baseturfs[1] : T.baseturfs
	if(!ispath(new_floor, /turf/open))
		new_floor = floor_turf

	wall_appearance = T.appearance
	var/dir_to_slide = get_slide_dir()
	var/turf/new_turf = change_own_turf(T, new_floor)
	placed_floor_type = new_turf.type
	floor_replaced = FALSE
	is_open = TRUE

	switching = TRUE
	new /obj/effect/secret_wall_slide(new_turf, wall_appearance, dir_to_slide, FALSE, slide_time)
	play_grind_sound(user)
	addtimer(CALLBACK(src, PROC_REF(finish_open)), slide_time)
	if(auto_close_delay)
		schedule_close(auto_close_delay)
	return TRUE

/obj/structure/secret_wall_controller/proc/finish_open()
	switching = FALSE

/// Returns TRUE if it started sliding shut
/obj/structure/secret_wall_controller/proc/try_close(mob/user)
	close_timer = null
	if(!is_open)
		return FALSE
	if(switching) // still sliding open, try again once it's done
		schedule_close(slide_time)
		return FALSE
	var/turf/T = get_turf(src)
	if(is_floor_replaced(T))
		qdel(src)
		return FALSE
	if(is_blocked(T))
		schedule_close(close_retry_delay)
		return FALSE
	switching = TRUE
	density = TRUE // nobody steps in while it slides shut
	var/obj/effect/secret_wall_slide/slide = new(T, wall_appearance, get_slide_dir(), TRUE, slide_time)
	play_grind_sound(user)
	addtimer(CALLBACK(src, PROC_REF(finish_close), slide), slide_time)
	return TRUE

/obj/structure/secret_wall_controller/proc/finish_close(obj/effect/secret_wall_slide/slide)
	switching = FALSE
	density = FALSE
	var/turf/T = get_turf(src)
	if(is_floor_replaced(T))
		qdel(slide)
		qdel(src)
		return
	if(is_blocked(T)) // something got in anyway, back off and retry
		qdel(slide)
		schedule_close(close_retry_delay)
		return
	var/turf/closed/wall = change_own_turf(T, wall_type)
	is_open = FALSE
	resident_refs = null
	if(!isnull(wall_integrity))
		wall.turf_integrity = wall_integrity
	if(wall_dir)
		wall.setDir(wall_dir)
	if(!wall.smooth && wall_icon_state)
		wall.icon_state = wall_icon_state
	qdel(slide)

/// Any living mob on the tile, or any item or structure that wasn't already in the wall
/obj/structure/secret_wall_controller/proc/is_blocked(turf/T)
	var/list/residents = list()
	for(var/datum/weakref/ref as anything in resident_refs)
		var/atom/movable/AM = ref.resolve()
		if(AM)
			residents += AM
	for(var/atom/movable/AM in T)
		if(AM == src)
			continue
		if(isliving(AM)) // living mobs always block, even ones already there when it opened
			return TRUE
		if(AM in residents)
			continue
		if(isobj(AM) && !iseffect(AM))
			return TRUE
	return FALSE

/obj/structure/secret_wall_controller/proc/get_slide_dir()
	if(slide_dir)
		return slide_dir
	for(var/check_dir in GLOB.cardinals)
		if(isclosedturf(get_step(src, check_dir)))
			return check_dir
	return WEST

/obj/structure/secret_wall_controller/proc/play_grind_sound(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.m_intent == MOVE_INTENT_SNEAK)
			playsound(src, 'sound/foley/stone_scrape.ogg', 15, TRUE, -6)
			return
	playsound(src, 'sound/foley/stone_scrape.ogg', 80, TRUE, -3)

/obj/structure/secret_wall_controller/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	. = ..()
	if(!ishuman(speaker) || !original_message) // no original_message means an emote
		return FALSE
	if(get_dist(speaker, src) > speaking_distance)
		return FALSE
	var/phrase = get_phrase()
	if(!length(phrase) || !findtext(sanitize_hear_message(original_message), sanitize_hear_message(phrase)))
		return FALSE
	// only this wall acts, any other wall in range that heard its phrase acts on its own
	var/action = trigger(speaker)
	if(action)
		log_game("[key_name(speaker)] [action] a secret wall by phrase at [AREACOORD(src)]")
	return TRUE

/// The wall's look sliding into (or out of) a neighbouring wall
/obj/effect/secret_wall_slide
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/secret_wall_slide/Initialize(mapload, wall_appearance, slide_dir, closing = FALSE, slide_time = 1 SECONDS)
	. = ..()
	if(wall_appearance)
		appearance = wall_appearance
	name = ""
	opacity = FALSE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = WALL_PLANE
	layer = CLOSED_TURF_LAYER - 0.01 // under the neighbouring wall it slides into
	var/offset_x = 0
	var/offset_y = 0
	if(slide_dir & EAST)
		offset_x = world.icon_size
	else if(slide_dir & WEST)
		offset_x = -world.icon_size
	if(slide_dir & NORTH)
		offset_y = world.icon_size
	else if(slide_dir & SOUTH)
		offset_y = -world.icon_size
	if(closing)
		pixel_x = offset_x
		pixel_y = offset_y
		alpha = 0
		animate(src, pixel_x = 0, pixel_y = 0, alpha = 255, time = slide_time)
		QDEL_IN(src, slide_time + 1 SECONDS) // the controller deletes it once the wall is back
	else
		animate(src, pixel_x = offset_x, pixel_y = offset_y, alpha = 0, time = slide_time)
		QDEL_IN(src, slide_time)

/proc/open_word()
	var/list/open_word = list(
		"open",
		"pass",
		"part",
		"break",
		"reveal",
		"unbar",
		"gape", //You wanted this.
		"extend",
		"widen",
		"unfold",
		"rise"
		)
	return pick(open_word)

/proc/magic_word()
	var/list/magic_word = list(
		"sesame",
		"abyss",
		"fire",
		"wind",
		"earth",
		"shadow",
		"night",
		"oblivion",
		"void",
		"time",
		"dead",
		"decay",
		"gods",
		"ancient",
		"twisted",
		"corrupt",
		"secrets",
		"lore",
		"text",
		"ritual",
		"sacrifice",
		"deal",
		"pact",
		"bargain",
		"ritual",
		"dream",
		"nightmare",
		"vision",
		"hunger",
		"lust",
		"necra",
		"noc",
		"psydon"
		)
	return pick(magic_word)

/proc/random_open_phrase()
	return open_word() + " " + magic_word()

/// Same for any two lists holding the same job types, whatever their order
/proc/secret_door_access_key(list/access)
	var/list/paths = list()
	for(var/path in access)
		paths |= "[path]"
	return jointext(sortList(paths), ";")

/// The secret walls whose phrase our current role is told
/mob/living/carbon/human/proc/known_secret_walls()
	. = list()
	if(!mind?.assigned_role)
		return
	var/datum/job/job = SSjob.GetJob(mind.assigned_role)
	if(!job)
		return
	for(var/obj/structure/secret_wall_controller/W as anything in GLOB.secret_walls_with_access)
		if(is_type_in_list(job, W.secret_door_access))
			. += W

/// Gives Recall Passphrases, with a one-time note, once any secret wall tells our role its phrase. notify gets the note if we have no key yet
/mob/living/carbon/human/proc/check_secret_passphrases(mob/notify)
	if((/mob/living/carbon/human/proc/recall_passphrases in verbs) || !length(known_secret_walls()))
		return
	verbs |= /mob/living/carbon/human/proc/recall_passphrases
	to_chat(notify || src, span_notice("I know of hidden passages. I can <i>Recall Passphrases</i>."))

/mob/living/carbon/human/proc/recall_passphrases()
	set name = "Recall Passphrases"
	set category = "IC"
	var/list/locales_by_phrase = list()
	var/list/area_by_phrase = list() // fallback when no wall sharing the phrase has a locale
	for(var/obj/structure/secret_wall_controller/W as anything in known_secret_walls())
		var/phrase = W.get_phrase()
		if(!locales_by_phrase[phrase])
			locales_by_phrase[phrase] = list()
			var/area/A = get_area(W)
			area_by_phrase[phrase] = A?.name
		if(W.secret_door_locale)
			locales_by_phrase[phrase] |= W.secret_door_locale
	if(!length(locales_by_phrase))
		to_chat(src, span_notice("I can't recall any passphrases."))
		return
	var/list/lines = list(span_notice("I recall these passphrases:"))
	for(var/phrase in locales_by_phrase)
		var/list/locales = locales_by_phrase[phrase]
		lines += "\"[phrase]\": [length(locales) ? jointext(locales, ", ") : area_by_phrase[phrase]]"
	to_chat(src, lines.Join("\n"))
