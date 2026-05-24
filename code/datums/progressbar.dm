#define PROGRESSBAR_HEIGHT 6
#define PROGRESSBAR_ANIMATION_TIME 5

/datum/progressbar
	var/goal = 1
	var/last_progress = 0
	var/image/bar
	var/shown = 0
	var/mob/user
	var/listindex

/datum/progressbar/New(mob/User, goal_number, atom/target)
	. = ..()
	if (!istype(target))
		EXCEPTION("Invalid target given")
	if (goal_number)
		goal = goal_number
	bar = image('icons/effects/progessbar.dmi', target, "prog_bar_0", HUD_LAYER)
	bar.plane = ABOVE_HUD_PLANE
	bar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	user = User

	LAZYINITLIST(user.progressbars)
	LAZYINITLIST(user.progressbars[bar.loc])
	var/list/bars = user.progressbars[bar.loc]
	bars.Add(src)
	listindex = bars.len
	bar.pixel_y = 0
	bar.alpha = 0
	animate(bar, pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)), alpha = 255, time = PROGRESSBAR_ANIMATION_TIME, easing = SINE_EASING)

/datum/progressbar/proc/update(progress)
	for(var/mob/M in get_hearers_in_view(world.view, src, RECURSIVE_CONTENTS_CLIENT_MOBS))
		if(!M.client) // still need to check just in case
			continue
		M.client.images += bar // no need for |=, images is deduplicated engine-side which is far faster

	progress = CLAMP(progress, 0, goal)
	last_progress = progress
	bar.icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"
	if (!shown)
		shown = TRUE

/datum/progressbar/proc/shiftDown()
	--listindex
	bar.pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1))
	var/dist_to_travel = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1)) - PROGRESSBAR_HEIGHT
	animate(bar, pixel_y = dist_to_travel, time = PROGRESSBAR_ANIMATION_TIME, easing = SINE_EASING)

/datum/progressbar/Destroy()
	if(last_progress != goal)
		bar.icon_state = "[bar.icon_state]_fail"
	for(var/I in user.progressbars[bar.loc])
		var/datum/progressbar/P = I
		if(P != src && P.listindex > listindex)
			P.shiftDown()

	var/list/bars = user.progressbars[bar.loc]
	bars.Remove(src)
	if(!bars.len)
		LAZYREMOVE(user.progressbars, bar.loc)

	animate(bar, alpha = 0, time = PROGRESSBAR_ANIMATION_TIME)
	addtimer(CALLBACK(src, PROC_REF(remove_from_clients)), PROGRESSBAR_ANIMATION_TIME, TIMER_CLIENT_TIME)
	return ..()

/datum/progressbar/proc/remove_from_clients()
	QDEL_NULL(bar) // deleting an image clears it from all clients

#undef PROGRESSBAR_ANIMATION_TIME
#undef PROGRESSBAR_HEIGHT
