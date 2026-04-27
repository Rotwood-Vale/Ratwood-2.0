// A golden effigy of a cockroach. Drop it in the right vault and leave it alone.
// Every 90 seconds it quietly mints coin from the stonework. Breaks eventually.

/obj/item/golden_cockroach
	name = "golden cockroach"
	desc = "A small effigy of a cockroach cast in gold. Warm to the touch and heavier than it looks."
	icon = 'icons/mob/animal.dmi'
	icon_state = "cockroach"
	color = "#FFD700"
	w_class = WEIGHT_CLASS_TINY
	/// TIMER_STOPPABLE handle for the generation cycle
	var/cycle_timer = null
	var/cycles = 0
	var/alerted = FALSE

/obj/item/golden_cockroach/Initialize(mapload)
	. = ..()
	cycle_timer = addtimer(CALLBACK(src, PROC_REF(tick)), 90 SECONDS, TIMER_STOPPABLE)

/obj/item/golden_cockroach/Destroy()
	if(cycle_timer)
		deltimer(cycle_timer)
		cycle_timer = null
	return ..()

/obj/item/golden_cockroach/proc/tick()
	cycle_timer = null
	if(QDELETED(src))
		return
	if(!isturf(loc))
		cycle_timer = addtimer(CALLBACK(src, PROC_REF(tick)), 90 SECONDS, TIMER_STOPPABLE)
		return
	var/area/A = get_area(src)
	if(!istype(A, /area/rogue/indoors/town/vault) && !istype(A, /area/rogue/indoors/town/bath))
		cycle_timer = addtimer(CALLBACK(src, PROC_REF(tick)), 90 SECONDS, TIMER_STOPPABLE)
		return
	cycles++
	if(!alerted && cycles >= 3)
		alerted = TRUE
		send_ooc_note("Something seems off in the treasury. Not enough to put your finger on - but the numbers don't quite add up.", job = list("Steward"))
	new /obj/item/roguecoin/gold(loc, rand(12, 20))
	if(prob(45))
		visible_message(span_warning("A small golden shape crumbles silently to dust."))
		qdel(src)
		return
	cycle_timer = addtimer(CALLBACK(src, PROC_REF(tick)), 90 SECONDS, TIMER_STOPPABLE)
