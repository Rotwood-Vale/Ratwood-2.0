#define NOC_VIGIL_STAGE_1 6 SECONDS
#define NOC_VIGIL_STAGE_2 10 SECONDS
#define NOC_VIGIL_STAGE_3 14 SECONDS

//Grants night vision if the user STANDS STILL !!!
//I don't know how laggy this is , it SHOULD NOT be THAT BAD ?
//I could not think of a BETTER METHOD .

/datum/component/noc_vigil
	var/timer
	var/stage = 0
	var/last_move

/datum/component/noc_vigil/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	last_move = world.time
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	schedule_check(NOC_VIGIL_STAGE_1)

/datum/component/noc_vigil/Destroy()
	deltimer(timer)
	set_stage(0)
	return ..()

/datum/component/noc_vigil/proc/schedule_check(delay)
	timer = addtimer(CALLBACK(src, PROC_REF(check_vigil)), delay, TIMER_STOPPABLE)

/datum/component/noc_vigil/proc/check_vigil()
	var/elapsed = world.time - last_move
	if(elapsed >= NOC_VIGIL_STAGE_3)
		set_stage(3)
		return
	if(elapsed >= NOC_VIGIL_STAGE_2)
		set_stage(2)
		schedule_check(NOC_VIGIL_STAGE_3 - elapsed)
		return
	if(elapsed >= NOC_VIGIL_STAGE_1)
		set_stage(1)
		schedule_check(NOC_VIGIL_STAGE_2 - elapsed)
		return
	schedule_check(NOC_VIGIL_STAGE_1 - elapsed)

/datum/component/noc_vigil/proc/set_stage(new_stage)
	if(new_stage == stage)
		return
	stage = new_stage
	var/mob/living/L = parent
	L.update_sight()

/datum/component/noc_vigil/proc/on_move(datum/source, atom/old_loc, dir)
	SIGNAL_HANDLER
	last_move = world.time
	if(!stage)
		return
	var/needs_new_timer = (stage == 3)
	set_stage(0)
	if(needs_new_timer)
		schedule_check(NOC_VIGIL_STAGE_1)

#undef NOC_VIGIL_STAGE_1
#undef NOC_VIGIL_STAGE_2
#undef NOC_VIGIL_STAGE_3
