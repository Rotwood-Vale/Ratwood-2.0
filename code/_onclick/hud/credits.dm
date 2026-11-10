/// Pause between the game-over splash and the first portrait.
#define CREDIT_START_DELAY (5 SECONDS)
/// Spawn interval bounds. The interval shrinks with roster size so the roll fits inside the reboot countdown.
#define CREDIT_SPAWN_INTERVAL_MAX (5 SECONDS)
#define CREDIT_SPAWN_INTERVAL_MIN (1 SECONDS)
/// How far (px) each portrait slides, right to left.
#define CREDIT_SLIDE_DISTANCE 288
/// Slowest slide. Sped up only when needed to keep same-lane portraits apart.
#define CREDIT_SLIDE_DURATION_MAX (9 SECONDS)
/// Minimum horizontal gap (px) between portraits in the same lane. Portraits are 96px wide.
#define CREDIT_MIN_SPACING 112
/// Portraits alternate between this many rows.
#define CREDIT_LANE_COUNT 2
#define CREDIT_LANE_HEIGHT 112
#define CREDIT_FADE_TIME (1 SECONDS)

/client/proc/RollCredits()
	set waitfor = FALSE
	if(credits_rolling)
		return
	var/list/roster = list()
	for(var/datum/mind/M as anything in SScrediticons.entries)
		roster += SScrediticons.entries[M]
	if(!length(roster))
		return

	// Fit the whole roster inside the reboot countdown.
	var/budget = CONFIG_GET(number/round_end_countdown) * 10 - CREDIT_START_DELAY - CREDIT_SLIDE_DURATION_MAX
	var/interval = clamp(budget / length(roster), CREDIT_SPAWN_INTERVAL_MIN, CREDIT_SPAWN_INTERVAL_MAX)
	// Portraits in the same lane spawn CREDIT_LANE_COUNT intervals apart; slide fast enough that they never overlap.
	var/slide_speed = max(CREDIT_SLIDE_DISTANCE / CREDIT_SLIDE_DURATION_MAX, CREDIT_MIN_SPACING / (interval * CREDIT_LANE_COUNT))
	var/slide_duration = CREDIT_SLIDE_DISTANCE / slide_speed

	credits_rolling = TRUE
	verbs += /client/proc/ClearCredits
	sleep(CREDIT_START_DELAY)
	var/lane = 0
	for(var/datum/credit_entry/entry as anything in roster)
		if(!credits_rolling)
			return
		new /atom/movable/screen/credit(null, entry, src, lane, slide_duration)
		lane = (lane + 1) % CREDIT_LANE_COUNT
		sleep(interval)
	sleep(slide_duration)
	credits_rolling = FALSE
	verbs -= /client/proc/ClearCredits

/client/proc/ClearCredits()
	set name = "Hide Credits"
	set category = "OOC"
	verbs -= /client/proc/ClearCredits
	credits_rolling = FALSE
	QDEL_LIST(credits)
	credits = null

/atom/movable/screen/credit
	mouse_opacity = MOUSE_OPACITY_ICON
	alpha = 0
	screen_loc = "1,1"
	layer = SPLASHSCREEN_LAYER
	plane = SPLASHSCREEN_PLANE
	var/client/parent
	var/datum/credit_entry/creditee
	var/upvoted
	var/atom/movable/screen/credit_portrait/portrait_holder

/atom/movable/screen/credit/Click()
	if(upvoted)
		return
	upvoted = TRUE
	var/image/I = new('icons/effects/effects.dmi', "hearty")
	I.pixel_x = rand(-32,32)
	animate(I, pixel_y = 64, alpha = 0, time = 18, flags = ANIMATION_PARALLEL)
	add_overlay(I)
	for(var/client/C in GLOB.clients)
		if(C == parent)
			continue
		for(var/atom/movable/screen/credit/CR in C.screen)
			if(CR.creditee == creditee)
				var/image/IR = new('icons/effects/effects.dmi', "hearty")
				IR.pixel_x = rand(-32,32)
				animate(IR, pixel_y = 64, alpha = 0, time = 18, flags = ANIMATION_PARALLEL)
				CR.add_overlay(IR)

/atom/movable/screen/credit/Initialize(mapload, datum/credit_entry/entry, client/P, lane = 0, slide_duration = CREDIT_SLIDE_DURATION_MAX)
	. = ..()
	if(!istype(entry) || !P)
		return INITIALIZE_HINT_QDEL
	parent = P
	creditee = entry
	var/voicecolor = entry.voice_color || "dc0174"
	var/credit_text = entry.title ? "[entry.name] the [entry.title]" : entry.name
	maptext = {"<span style='vertical-align:top; text-align:center;
				color: #[voicecolor]; font-size: 100%;
				text-shadow: 1px 1px 2px black, 0 0 1em black, 0 0 0.2em black;
				font-family: "Pterra";'>[credit_text]</span>"}
	maptext_x = -32
	maptext_y = 8
	maptext_width = 150
	if(entry.portrait)
		portrait_holder = new(null, entry.portrait)
		vis_contents += portrait_holder
	var/matrix/M = matrix(transform)
	M.Translate(224, 64 + lane * CREDIT_LANE_HEIGHT)
	transform = M
	M = matrix(transform)
	M.Translate(-CREDIT_SLIDE_DISTANCE, 0)
	animate(src, transform = M, time = slide_duration)
	animate(src, alpha = 255, time = CREDIT_FADE_TIME, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(src, PROC_REF(FadeOut)), slide_duration - CREDIT_FADE_TIME)
	QDEL_IN(src, slide_duration)
	P.screen += src
	LAZYADD(P.credits, src)

/atom/movable/screen/credit/Destroy()
	vis_contents.Cut()
	QDEL_NULL(portrait_holder)
	creditee = null
	var/client/P = parent
	if(!P)
		return ..()
	P.screen -= src
	LAZYREMOVE(P.credits, src)
	parent = null
	return ..()

/atom/movable/screen/credit/proc/FadeOut()
	animate(src, alpha = 0, time = CREDIT_FADE_TIME, flags = ANIMATION_PARALLEL)

/// The scaled, masked portrait shown inside a credit. Lives only in the credit's vis_contents.
/// All scaling and masking is done here with transform/filters, so the client does the drawing.
/atom/movable/screen/credit_portrait
	screen_loc = null
	appearance_flags = KEEP_TOGETHER
	vis_flags = VIS_INHERIT_ID | VIS_INHERIT_PLANE | VIS_INHERIT_LAYER

/atom/movable/screen/credit_portrait/Initialize(mapload, mutable_appearance/portrait)
	. = ..()
	if(!portrait)
		return
	var/static/icon/credit_mask = icon('icons/mob/clothing/under/masking_helpers.dmi', "credits")
	add_overlay(portrait)
	filters = filter(type = "alpha", icon = credit_mask) // keep the upper half: head and shoulders
	transform = matrix(3, 0, 32, 0, 3, 32) // 3x, anchored at the bottom-left like the old 96x96 icon

#undef CREDIT_START_DELAY
#undef CREDIT_SPAWN_INTERVAL_MAX
#undef CREDIT_SPAWN_INTERVAL_MIN
#undef CREDIT_SLIDE_DISTANCE
#undef CREDIT_SLIDE_DURATION_MAX
#undef CREDIT_MIN_SPACING
#undef CREDIT_LANE_COUNT
#undef CREDIT_LANE_HEIGHT
#undef CREDIT_FADE_TIME
