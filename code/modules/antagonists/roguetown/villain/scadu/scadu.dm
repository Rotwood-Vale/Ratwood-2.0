/datum/antagonist/scadu
	name = "Scadu"
	roundend_category = "Scadu"
	antagpanel_category = "Scadu"
	job_rank = "Scadu"
	rogue_enabled = TRUE
	show_name_in_check_antagonists = TRUE

	var/lux = 0
	var/lux_max = 100
	var/list/obj/structure/scadu_monument/monuments = list()
	var/monuments_placed = 0
	var/monument_limit = 3
	var/corpses_absorbed = 0
	var/mob/dead/observer/rogue/scadu/scadu_mob = null

/datum/antagonist/scadu/on_gain()
	. = ..()
	owner.special_role = name

/datum/antagonist/scadu/on_removal()
	for(var/obj/structure/scadu_monument/M in monuments)
		if(!QDELETED(M))
			M.go_dormant()
	scadu_mob = null
	..()

/datum/antagonist/scadu/proc/add_lux(amount)
	lux = min(lux + amount, lux_max)

/datum/antagonist/scadu/proc/spend_lux(amount)
	if(lux < amount)
		return FALSE
	lux -= amount
	return TRUE

/datum/antagonist/scadu/proc/count_standing_monuments()
	var/count = 0
	for(var/obj/structure/scadu_monument/M in monuments)
		if(!QDELETED(M) && M.standing)
			count++
	return count

/datum/antagonist/scadu/proc/register_monument(obj/structure/scadu_monument/M)
	monuments |= M
	monuments_placed++
	M.start_lux_loop()
	to_chat(scadu_mob, span_notice("A monument rises. ([count_standing_monuments()] standing | [monuments_placed]/[monument_limit] placed)"))

/datum/antagonist/scadu/proc/on_monument_destroyed(obj/structure/scadu_monument/M)
	monuments -= M
	to_chat(scadu_mob, span_danger("A monument has been toppled! ([count_standing_monuments()] standing | [monuments_placed]/[monument_limit] placed)"))
	if(count_standing_monuments() || monuments_placed < monument_limit)
		return
	GLOB.scadu_slot_closed = TRUE
	GLOB.scadu_persistent_datum = null
	to_chat(scadu_mob, span_userdanger("Your monuments are gone."))
	scadu_mob.returntolobby()

/datum/antagonist/scadu/proc/absorb_corpse()
	corpses_absorbed++
	monument_limit = 3 + (corpses_absorbed / 2)
	lux_max = 100 + (corpses_absorbed * 20)
	to_chat(scadu_mob, span_userdanger("You consume the remnant soul. Lux cap: [lux_max] | Monument limit: [monument_limit]"))

/datum/antagonist/scadu/antag_panel_data()
	return "Lux: [lux]/[lux_max] | Monuments: [count_standing_monuments()] standing, [monuments_placed]/[monument_limit] placed | Corpses: [corpses_absorbed]"
