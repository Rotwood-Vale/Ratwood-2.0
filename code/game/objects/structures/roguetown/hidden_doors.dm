/// Random open phrases shared by every secret wall with the same redstone_id, keyed by "[redstone_id]"
GLOBAL_LIST_EMPTY(secret_wall_phrases)

/*
 * Secret wall controller. Sits invisibly on a real wall tile, which stays untouched while closed,
 * so the look, smoothing, examine, climbing and damage are all the wall's own.
 * Opening swaps the tile for a floor and closing puts the recorded wall back.
 * Triggered by linked levers (redstone_id) or by a human speaking open_phrase next to it.
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

	/// Spoken next to the wall to open it. Left empty, a random phrase is picked (shared by the redstone_id group)
	var/open_phrase
	/// Role types allowed to ask the wall for "help", "say phrase" and "set phrase"
	var/list/vip
	/// How long it stays open before trying to close. 0 means a trigger while open closes it instead
	var/auto_close_delay = 5 SECONDS
	/// Direction the wall slides when opening. Null picks a neighbouring closed turf
	var/slide_dir
	/// Floor placed while open, if override_floor is set or the wall has no baseturf
	var/turf/open/floor_turf = /turf/open/floor/rogue/blocks
	/// Use floor_turf instead of the wall's first baseturf
	var/override_floor = TRUE
	var/speaking_distance = 1
	var/lang = /datum/language/common
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
	/// Weakrefs to things that sat on the tile while it was a wall. They don't block closing
	var/list/resident_refs

/obj/structure/secret_wall_controller/Initialize(mapload, _redstone_id, _open_phrase, list/_vip, _auto_close_delay, _slide_dir, _floor_turf, _override_floor)
	// set before the parent call so redstone linkage happens in the normal LateInitialize pass
	if(_redstone_id)
		redstone_id = _redstone_id
	if(_open_phrase)
		open_phrase = _open_phrase
	if(_vip)
		vip = _vip
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
	if(!length(open_phrase))
		open_phrase = get_shared_phrase()
	become_hearing_sensitive()
	RegisterSignal(T, COMSIG_TURF_CHANGE, PROC_REF(on_turf_change))

/obj/structure/secret_wall_controller/Destroy()
	lose_hearing_sensitivity()
	var/turf/T = get_turf(src)
	if(T)
		UnregisterSignal(T, COMSIG_TURF_CHANGE)
	if(close_timer)
		deltimer(close_timer)
		close_timer = null
	resident_refs = null
	return ..()

/// The random phrase for our redstone_id group, made on first use
/obj/structure/secret_wall_controller/proc/get_shared_phrase()
	if(!redstone_id)
		return open_word() + " " + magic_word()
	var/key = "[redstone_id]"
	if(!GLOB.secret_wall_phrases[key])
		GLOB.secret_wall_phrases[key] = open_word() + " " + magic_word()
	return GLOB.secret_wall_phrases[key]

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

/obj/structure/secret_wall_controller/proc/trigger(mob/user)
	if(switching)
		return
	if(!is_open)
		open_wall(user)
		return
	if(auto_close_delay || close_timer) // auto mode ignores triggers, and a close is already pending
		return
	try_close(user)

/obj/structure/secret_wall_controller/proc/open_wall(mob/user)
	var/turf/closed/T = get_turf(src)
	if(!isclosedturf(T))
		return
	wall_type = T.type
	wall_integrity = T.turf_integrity
	wall_dir = T.dir
	wall_icon_state = T.icon_state
	resident_refs = list()
	for(var/atom/movable/AM in T)
		var/datum/weakref/ref = WEAKREF(AM)
		if(AM != src && ref)
			resident_refs += ref

	var/turf/open/new_floor = floor_turf
	if(!override_floor && T.baseturfs)
		new_floor = islist(T.baseturfs) ? T.baseturfs[1] : T.baseturfs
	if(!ispath(new_floor, /turf/open))
		new_floor = floor_turf

	wall_appearance = T.appearance
	var/dir_to_slide = get_slide_dir()
	self_changing = TRUE
	var/turf/new_turf = T.ChangeTurf(new_floor)
	self_changing = FALSE
	placed_floor_type = new_turf.type
	floor_replaced = FALSE
	is_open = TRUE

	switching = TRUE
	new /obj/effect/secret_wall_slide(new_turf, wall_appearance, dir_to_slide, FALSE, slide_time)
	play_grind_sound(user)
	addtimer(VARSET_CALLBACK(src, switching, FALSE), slide_time)
	if(auto_close_delay)
		close_timer = addtimer(CALLBACK(src, PROC_REF(try_close)), auto_close_delay, TIMER_STOPPABLE)

/obj/structure/secret_wall_controller/proc/try_close(mob/user)
	close_timer = null
	if(!is_open)
		return
	if(switching) // still sliding open, try again once it's done
		close_timer = addtimer(CALLBACK(src, PROC_REF(try_close)), slide_time, TIMER_STOPPABLE)
		return
	var/turf/T = get_turf(src)
	if(floor_replaced || T.type != placed_floor_type)
		qdel(src)
		return
	if(is_blocked(T))
		close_timer = addtimer(CALLBACK(src, PROC_REF(try_close)), 5 SECONDS, TIMER_STOPPABLE)
		return
	switching = TRUE
	density = TRUE // nobody steps in while it slides shut
	var/obj/effect/secret_wall_slide/slide = new(T, wall_appearance, get_slide_dir(), TRUE, slide_time)
	play_grind_sound(user)
	addtimer(CALLBACK(src, PROC_REF(finish_close), slide), slide_time)

/obj/structure/secret_wall_controller/proc/finish_close(obj/effect/secret_wall_slide/slide)
	switching = FALSE
	density = FALSE
	var/turf/T = get_turf(src)
	if(floor_replaced || T.type != placed_floor_type)
		qdel(slide)
		qdel(src)
		return
	if(is_blocked(T)) // something got in anyway, back off and retry
		qdel(slide)
		close_timer = addtimer(CALLBACK(src, PROC_REF(try_close)), 5 SECONDS, TIMER_STOPPABLE)
		return
	self_changing = TRUE
	var/turf/closed/wall = T.ChangeTurf(wall_type)
	self_changing = FALSE
	is_open = FALSE
	resident_refs = null
	if(!isnull(wall_integrity))
		wall.turf_integrity = wall_integrity
	if(wall_dir)
		wall.setDir(wall_dir)
	if(!wall.smooth && wall_icon_state)
		wall.icon_state = wall_icon_state
	qdel(slide)

/// Any living mob, item or structure on the tile that wasn't already in the wall
/obj/structure/secret_wall_controller/proc/is_blocked(turf/T)
	var/list/residents = list()
	for(var/datum/weakref/ref as anything in resident_refs)
		var/atom/movable/AM = ref.resolve()
		if(AM)
			residents += AM
	for(var/atom/movable/AM in T)
		if(AM == src || (AM in residents))
			continue
		if(isliving(AM))
			return TRUE
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
	if(speaker == src)
		return FALSE
	if(!ishuman(speaker) || !original_message) // no original_message means an emote
		return FALSE
	if(get_dist(speaker, src) > speaking_distance)
		return FALSE
	var/mob/living/carbon/human/H = speaker
	var/message2recognize = sanitize_hear_message(original_message)

	if(is_type_in_list(H.mind?.assigned_role, vip)) //are they a VIP?
		if(findtext(message2recognize, "help"))
			send_speech(span_purple("'say phrase'... 'set phrase'..."), speaking_distance, src, message_language = lang, message_mode = MODE_WHISPER)
			return TRUE
		if(findtext(message2recognize, "say phrase"))
			send_speech(span_purple("[open_phrase]..."), speaking_distance, src, message_language = lang, message_mode = MODE_WHISPER)
			return TRUE
		if(findtext(message2recognize, "set phrase"))
			INVOKE_ASYNC(src, PROC_REF(prompt_new_phrase), H)
			return TRUE

	var/phrase = open_phrase ? sanitize_hear_message(open_phrase) : null
	if(!length(phrase) || !findtext(message2recognize, phrase))
		return FALSE
	log_game("[key_name(H)] spoke the phrase of the secret wall with redstone id \"[redstone_id]\" at [AREACOORD(src)]")
	trigger(H)
	return TRUE

/// "set phrase" changes the phrase for the whole redstone_id group
/obj/structure/secret_wall_controller/proc/prompt_new_phrase(mob/living/carbon/human/H)
	var/new_pass = stripped_input(H, "What should the new open phrase be?")
	if(!length(new_pass) || QDELETED(src) || QDELETED(H))
		return
	if(redstone_id)
		GLOB.secret_wall_phrases["[redstone_id]"] = new_pass
		for(var/obj/structure/secret_wall_controller/W in GLOB.redstone_objs)
			if(W.redstone_id == redstone_id)
				W.open_phrase = new_pass
	open_phrase = new_pass
	log_game("[key_name(H)] set the phrase of secret walls with redstone id \"[redstone_id]\" to \"[new_pass]\" at [AREACOORD(src)]")
	send_speech(span_purple("It is done, [flavor_name()]..."), speaking_distance, src, message_language = lang, message_mode = MODE_WHISPER)

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

/proc/close_word()
	var/list/close_word = list(
		"close",
		"seal",
		"still",
		"fade",
		"retreat",
		"consume",
		"envelope",
		"hide",
		"halt",
		"cease",
		"vanish",
		"end"
		)
	return pick(close_word)


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

/proc/flavor_name()
	var/list/flavor_name = list(
		"my friend",
		"love",
		"my love",
		"honey",
		"darling",
		"stranger",
		"companion",
		"mate",
		"you harlot",
		"comrade",
		"fellow",
		"chum",
		"bafoon"
		)
	return pick(flavor_name)
