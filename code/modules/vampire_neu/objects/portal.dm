/obj/structure/vampire/portalmaker
	name = "Rift Gate"
	icon_state = "obelisk"
	var/list/rift_portals = list()
	var/rift_zone_name
	var/rift_close_time = 0
	var/rift_timer

/obj/structure/vampire/portalmaker/Destroy()
	close_rift()
	return ..()

/obj/structure/vampire/portalmaker/attack_hand(mob/living/user)
	. = TRUE
	if(!user.is_kindred())
		to_chat(user, span_warning("The obelisk is cold to my touch."))
		return
	ui_interact(user)

/obj/structure/vampire/portalmaker/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/vampire/portalmaker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VampireRiftGate", name)
		ui.open()

/obj/structure/vampire/portalmaker/ui_static_data(mob/user)
	var/list/data = list()
	var/list/zones = list()
	for(var/area/rogue/zone in GLOB.sortedAreas)
		if(zone.town_area && !zone.hidden)
			zones |= zone.name
	data["zones"] = zones
	data["vitaeCost"] = RIFT_GATE_VITAE_COST
	data["portalDuration"] = RIFT_GATE_PORTAL_DURATION / (1 SECONDS)
	return data

/obj/structure/vampire/portalmaker/ui_data(mob/user)
	var/list/data = list()
	var/list/amulets = list()
	for(var/obj/item/clothing/neck/portalamulet/amulet in GLOB.vampire_objects)
		var/turf/anchor = get_rift_anchor(amulet)
		if(!anchor)
			continue
		amulets += list(list(
			"ref" = REF(amulet),
			"name" = amulet.name,
			"area" = get_area_name(anchor, TRUE),
		))
	var/mob/living/living_user = user
	data["amulets"] = amulets
	data["hasVitae"] = istype(living_user) && living_user.has_bloodpool_cost(RIFT_GATE_VITAE_COST)
	data["riftZone"] = rift_zone_name
	data["riftSecondsLeft"] = rift_zone_name ? max(round((rift_close_time - world.time) / (1 SECONDS)), 0) : 0
	return data

/obj/structure/vampire/portalmaker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/user = ui.user
	if(!istype(user) || !user.is_kindred())
		return

	switch(action)
		if("open_zone")
			var/list/zone_areas = get_town_zone_areas(params["zone"])
			if(!length(zone_areas))
				return
			return open_rift(user, zone_areas, params["zone"])
		if("open_amulet")
			var/obj/item/clothing/neck/portalamulet/amulet = locate(params["amulet"])
			if(!istype(amulet) || !(amulet in GLOB.vampire_objects))
				return
			var/turf/anchor = get_rift_anchor(amulet)
			if(!anchor)
				return
			var/area/anchor_area = get_area(anchor)
			return open_rift(user, list(anchor_area), anchor_area.name, anchor)
		if("close_rift")
			if(!length(rift_portals))
				return
			close_rift()
			return TRUE

/obj/structure/vampire/portalmaker/proc/get_town_zone_areas(zone_name)
	var/list/zone_areas = list()
	if(!istext(zone_name))
		return zone_areas
	for(var/area/rogue/zone in GLOB.sortedAreas)
		if(zone.town_area && !zone.hidden && zone.name == zone_name)
			zone_areas += zone
	return zone_areas

/obj/structure/vampire/portalmaker/proc/open_rift(mob/living/user, list/zone_areas, zone_name, turf/arrival)
	if(length(rift_portals))
		to_chat(user, span_warning("A rift is already open."))
		return
	if(!user.has_bloodpool_cost(RIFT_GATE_VITAE_COST))
		to_chat(user, span_warning("This costs [RIFT_GATE_VITAE_COST] vitae, I lack that."))
		return
	if(!get_rift_home() || !length(get_rift_mouths()))
		to_chat(user, span_warning("The rift finds no anchor within my domain."))
		return

	user.visible_message("[user] begins to summon a portal.", "I begin to summon a portal.")
	if(!do_after(user, 3 SECONDS, src))
		return
	if(length(rift_portals) || !user.has_bloodpool_cost(RIFT_GATE_VITAE_COST) || !user.client)
		return

	if(!arrival)
		arrival = pick_rift_arrival(zone_areas)
	if(!arrival)
		to_chat(user, span_warning("The rift finds no footing in [zone_name]."))
		return

	SStgui.close_user_uis(user, src)
	user.stop_sound_channel(CHANNEL_HEARTBEAT)
	var/mob/dead/observer/rogue/arcaneeye/rift/eye = new(user)
	SStgui.on_transfer(user, eye)
	eye.can_reenter_corpse = TRUE
	eye.ghostize_time = world.time
	eye.bind_rift(user, src, zone_areas, zone_name, arrival)
	eye.key = user.key
	return TRUE

/obj/structure/vampire/portalmaker/proc/finish_rift(mob/dead/observer/rogue/arcaneeye/rift/eye, turf/destination)
	var/mob/living/user = eye.vampirelord
	if(!rift_can_open_at(destination, eye.anchor, eye.zone_areas))
		to_chat(eye, span_warning("The rift will not open here."))
		return
	if(length(rift_portals))
		to_chat(eye, span_warning("A rift is already open."))
		return
	var/turf/home = get_rift_home()
	var/list/mouths = get_rift_mouths()
	if(QDELETED(user) || user.stat == DEAD || get_dist(user, src) > 1 || !user.has_bloodpool_cost(RIFT_GATE_VITAE_COST) || !home || !length(mouths))
		to_chat(eye, span_warning("The rift collapses before it can open."))
		eye.return_from_rift()
		return

	var/zone_name = eye.zone_name
	eye.return_from_rift()
	user.adjust_bloodpool(-RIFT_GATE_VITAE_COST)
	tear_rift(destination, home, mouths, zone_name)
	user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)
	SStgui.update_uis(src)
	return TRUE

/obj/structure/vampire/portalmaker/proc/tear_rift(turf/destination, turf/home, list/mouths, zone_name)
	var/turf/landing = get_rift_landing(destination)
	for(var/turf/mouth as anything in mouths)
		rift_portals += new /obj/structure/vampire/portal(mouth, src, landing)
	rift_portals += new /obj/structure/vampire/portal/homeward(destination, src, home)
	rift_zone_name = zone_name
	rift_close_time = world.time + RIFT_GATE_PORTAL_DURATION
	rift_timer = addtimer(CALLBACK(src, PROC_REF(close_rift)), RIFT_GATE_PORTAL_DURATION, TIMER_STOPPABLE)

/obj/structure/vampire/portalmaker/proc/close_rift()
	deltimer(rift_timer)
	rift_timer = null
	rift_zone_name = null
	rift_close_time = 0
	var/list/closing = rift_portals.Copy()
	rift_portals.Cut()
	for(var/obj/structure/vampire/portal/portal as anything in closing)
		if(QDELETED(portal))
			continue
		portal.visible_message(span_boldnotice("[portal] shudders before rapidly closing."))
		qdel(portal)
	SStgui.update_uis(src)

/obj/structure/vampire/portalmaker/proc/get_rift_home()
	for(var/obj/effect/landmark/vteleport/home in GLOB.landmarks_list)
		return get_turf(home)
	return null

/obj/structure/vampire/portalmaker/proc/get_rift_mouths()
	var/list/mouths = list()
	for(var/obj/effect/landmark/vteleportsending/mouth in GLOB.landmarks_list)
		mouths += get_turf(mouth)
	return mouths

/obj/structure/vampire/portalmaker/proc/get_rift_landing(turf/destination)
	var/list/landings = list()
	for(var/direction in GLOB.cardinals)
		var/turf/landing = get_step(destination, direction)
		if(landing && get_area(landing) == get_area(destination) && !istransparentturf(landing) && !landing.is_blocked_turf(TRUE))
			landings += landing
	if(!length(landings))
		return destination
	return pick(landings)

/obj/structure/vampire/portalmaker/proc/pick_rift_arrival(list/zone_areas)
	var/list/candidates = list()
	for(var/area/zone as anything in zone_areas)
		for(var/turf/zone_turf in zone)
			candidates += zone_turf
	for(var/turf/candidate as anything in shuffle(candidates))
		if(rift_can_open_at(candidate, candidate, zone_areas))
			return candidate
	return null

/obj/structure/vampire/portalmaker/proc/get_rift_anchor(obj/item/clothing/neck/portalamulet/amulet)
	var/turf/anchor = get_turf(amulet)
	var/area/anchor_area = get_area(anchor)
	if(!anchor || !anchor_area || anchor_area.hidden)
		return null
	return anchor

/obj/structure/vampire/portalmaker/proc/rift_can_open_at(turf/destination, turf/anchor, list/zone_areas)
	if(!istype(destination) || !istype(anchor) || destination.z != anchor.z || get_dist(destination, anchor) > RIFT_GATE_PLACEMENT_RANGE)
		return FALSE
	var/area/destination_area = get_area(destination)
	if(!destination_area || destination_area.hidden || !(destination_area in zone_areas))
		return FALSE
	if(istransparentturf(destination) || destination.is_blocked_turf(TRUE))
		return FALSE
	return !(locate(/obj/structure/vampire/portal) in destination)

/obj/structure/vampire/portal
	name = "Eerie Portal"
	icon_state = "portal"
	density = FALSE
	var/obj/structure/vampire/portalmaker/gate
	var/turf/exit

/obj/structure/vampire/portal/Initialize(mapload, obj/structure/vampire/portalmaker/rift_gate, turf/rift_exit)
	. = ..()
	gate = rift_gate
	exit = rift_exit
	set_light(3, 2, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC)
	playsound(loc, 'sound/misc/portalopen.ogg', 100, FALSE, pressure_affected = FALSE)
	visible_message(span_boldnotice("A sickening tear is heard as a sinister portal emerges."))

/obj/structure/vampire/portal/Destroy()
	gate?.rift_portals -= src
	gate = null
	exit = null
	return ..()

/obj/structure/vampire/portal/Crossed(atom/movable/AM, oldloc)
	. = ..()
	var/mob/living/traveler = AM
	if(!istype(traveler) || traveler.buckled || !exit)
		return
	var/turf/came_from = get_turf(oldloc)
	if(came_from && get_dist(came_from, src) > 1)
		return
	if(!allows_passage(traveler))
		return
	carry_through(traveler)

/obj/structure/vampire/portal/proc/allows_passage(mob/living/traveler)
	if(!bears_gate_amulet(traveler))
		to_chat(traveler, span_warning("Without a gate amulet, the rift will not carry me back."))
	return TRUE

/obj/structure/vampire/portal/proc/bears_gate_amulet(mob/living/traveler)
	for(var/obj/item/clothing/neck/portalamulet/amulet in GLOB.vampire_objects)
		if(get(amulet, /mob/living) == traveler)
			return TRUE
	return FALSE

/obj/structure/vampire/portal/proc/carry_through(mob/living/traveler)
	var/mob/living/carried = traveler.pulling
	if(!istype(carried) || !(carried in traveler.buckled_mobs))
		carried = null
	playsound(loc, 'sound/misc/portalenter.ogg', 100, FALSE, pressure_affected = FALSE)
	traveler.forceMove(exit)
	if(!carried)
		return
	traveler.stop_pulling()
	carried.forceMove(exit)
	traveler.start_pulling(carried, supress_message = TRUE)
	traveler.buckle_mob(carried, TRUE, TRUE, 90, 0, 0)

/obj/structure/vampire/portal/homeward/allows_passage(mob/living/traveler)
	if(bears_gate_amulet(traveler))
		return TRUE
	to_chat(traveler, span_warning("The rift will not carry me without a gate amulet."))
	return FALSE

/obj/item/clothing/neck/portalamulet
	name = "Gate Amulet"
	desc = "A clot of crystallized blood strung on a cord. The Rift Gate carries its bearer home, and whoever they bear upon their shoulder."
	icon_state = "bloodtooth"
	icon = 'icons/roguetown/clothing/neck.dmi'

/obj/item/clothing/neck/portalamulet/Initialize(mapload)
	GLOB.vampire_objects |= src
	. = ..()

/obj/item/clothing/neck/portalamulet/Destroy()
	GLOB.vampire_objects -= src
	return ..()

/mob/dead/observer/rogue/arcaneeye/rift
	var/obj/structure/vampire/portalmaker/gate
	var/list/zone_areas
	var/zone_name
	var/turf/anchor
	var/list/image/placement_images = list()
	var/client/placement_viewer
	var/sight_timer

/mob/dead/observer/rogue/arcaneeye/rift/Initialize(mapload)
	. = ..()
	verbs -= list(
		/mob/dead/observer/proc/dead_tele,
		/mob/dead/observer/rogue/arcaneeye/proc/scry_tele,
		/mob/dead/observer/rogue/arcaneeye/proc/cancel_scry,
		/mob/dead/observer/rogue/arcaneeye/proc/eye_down,
		/mob/dead/observer/rogue/arcaneeye/proc/eye_up,
		/mob/dead/observer/rogue/arcaneeye/proc/vampire_telepathy,
	)
	verbs += list(
		/mob/dead/observer/rogue/arcaneeye/rift/proc/open_rift_here,
		/mob/dead/observer/rogue/arcaneeye/rift/proc/return_from_rift,
	)
	name = "Rift Sight"

/mob/dead/observer/rogue/arcaneeye/rift/Destroy()
	hide_placement()
	deltimer(sight_timer)
	vampirelord = null
	gate = null
	zone_areas = null
	anchor = null
	return ..()

/mob/dead/observer/rogue/arcaneeye/rift/proc/bind_rift(mob/living/body, obj/structure/vampire/portalmaker/rift_gate, list/rift_zone_areas, rift_zone_name, turf/arrival)
	vampirelord = body
	gate = rift_gate
	zone_areas = rift_zone_areas
	zone_name = rift_zone_name
	anchor = arrival
	RegisterSignal(body, COMSIG_QDELETING, PROC_REF(on_body_deleted))
	RegisterSignal(rift_gate, COMSIG_QDELETING, PROC_REF(on_gate_deleted))
	forceMove(arrival)
	sight_timer = addtimer(CALLBACK(src, PROC_REF(return_from_rift)), RIFT_GATE_SIGHT_DURATION, TIMER_STOPPABLE)

/mob/dead/observer/rogue/arcaneeye/rift/proc/on_body_deleted(datum/source)
	SIGNAL_HANDLER
	vampirelord = null

/mob/dead/observer/rogue/arcaneeye/rift/proc/on_gate_deleted(datum/source)
	SIGNAL_HANDLER
	gate = null
	INVOKE_ASYNC(src, PROC_REF(return_from_rift))

/mob/dead/observer/rogue/arcaneeye/rift/Login()
	. = ..()
	show_placement()
	to_chat(src, span_notice("My sight settles in [zone_name]. I may drift up to [RIFT_GATE_PLACEMENT_RANGE] paces from here: <b>Open Rift Here</b> tears the rift where I stand, <b>Return to Body</b> abandons it."))

/mob/dead/observer/rogue/arcaneeye/rift/Logout()
	hide_placement()
	return ..()

/mob/dead/observer/rogue/arcaneeye/rift/Move(NewLoc, direct)
	var/turf/destination = NewLoc ? get_turf(NewLoc) : get_step(src, direct)
	if(!anchor || !destination || destination.z != anchor.z || get_dist(destination, anchor) > RIFT_GATE_PLACEMENT_RANGE)
		return FALSE
	return ..()

/mob/dead/observer/rogue/arcaneeye/rift/proc/show_placement()
	hide_placement()
	if(!client || !anchor)
		return
	for(var/turf/marked in range(RIFT_GATE_PLACEMENT_RANGE + 1, anchor))
		var/can_open = gate?.rift_can_open_at(marked, anchor, zone_areas)
		var/image/marker = image('icons/turf/overlays.dmi', marked, can_open ? "greenOverlay" : "redOverlay")
		marker.plane = ABOVE_LIGHTING_PLANE
		marker.alpha = 100
		placement_images += marker
	placement_viewer = client
	client.images += placement_images

/mob/dead/observer/rogue/arcaneeye/rift/proc/hide_placement()
	if(placement_viewer)
		placement_viewer.images -= placement_images
	placement_viewer = null
	placement_images.Cut()

/mob/dead/observer/rogue/arcaneeye/rift/proc/open_rift_here()
	set category = "Rift Sight"
	set name = "Open Rift Here"

	if(QDELETED(gate))
		return_from_rift()
		return
	gate.finish_rift(src, get_turf(src))

/mob/dead/observer/rogue/arcaneeye/rift/proc/return_from_rift()
	set category = "Rift Sight"
	set name = "Return to Body"

	hide_placement()
	deltimer(sight_timer)
	sight_timer = null
	if(!QDELETED(vampirelord))
		vampirelord.ckey = ckey
		qdel(src)
		return
	var/mob/dead/observer/rogue/ghost = new(src)
	ghost.key = key
	qdel(src)
