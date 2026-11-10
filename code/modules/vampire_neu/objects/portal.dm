/obj/structure/vampire/portalmaker
	name = "Rift Gate"
	icon_state = "obelisk"
	var/sending = FALSE

/obj/structure/vampire/portalmaker/attack_hand(mob/living/user)
	. = TRUE
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
	data["vitaeCost"] = RIFT_GATE_VITAE_COST
	data["placementRange"] = RIFT_GATE_PLACEMENT_RANGE
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
			"uses" = amulet.uses,
		))
	var/mob/living/living_user = user
	data["amulets"] = amulets
	data["hasVitae"] = istype(living_user) && living_user.has_bloodpool_cost(RIFT_GATE_VITAE_COST)
	data["sendingActive"] = sending
	return data

/obj/structure/vampire/portalmaker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/user = ui.user
	if(!istype(user))
		return

	var/obj/item/clothing/neck/portalamulet/amulet = locate(params["amulet"])
	if(!istype(amulet) || !(amulet in GLOB.vampire_objects))
		return

	switch(action)
		if("open_return")
			return open_rift(user, amulet, FALSE)
		if("open_sending")
			return open_rift(user, amulet, TRUE)

/obj/structure/vampire/portalmaker/proc/open_rift(mob/living/user, obj/item/clothing/neck/portalamulet/amulet, sending_portal)
	if(sending_portal && sending)
		to_chat(user, "A portal is already active!")
		return
	if(!user.has_bloodpool_cost(RIFT_GATE_VITAE_COST))
		to_chat(user, span_warning("This costs [RIFT_GATE_VITAE_COST] vitae, I lack that."))
		return
	if(!get_rift_anchor(amulet))
		to_chat(user, span_warning("The rift cannot reach that anchor."))
		return

	user.visible_message("[user] begins to summon a portal.", "I begin to summon a portal.")
	if(!do_after(user, 3 SECONDS, src))
		return
	if(QDELETED(amulet) || amulet.uses <= 0 || (sending_portal && sending) || !user.has_bloodpool_cost(RIFT_GATE_VITAE_COST))
		return

	var/turf/anchor = get_rift_anchor(amulet)
	if(!anchor || !user.client)
		return

	SStgui.close_user_uis(user, src)
	user.stop_sound_channel(CHANNEL_HEARTBEAT)
	var/mob/dead/observer/rogue/arcaneeye/rift/eye = new(user)
	SStgui.on_transfer(user, eye)
	eye.can_reenter_corpse = TRUE
	eye.ghostize_time = world.time
	eye.bind_rift(user, src, amulet, anchor, sending_portal)
	eye.key = user.key
	return TRUE

/obj/structure/vampire/portalmaker/proc/finish_rift(mob/dead/observer/rogue/arcaneeye/rift/eye, turf/destination)
	var/mob/living/user = eye.vampirelord
	var/obj/item/clothing/neck/portalamulet/amulet = eye.amulet
	var/sending_portal = eye.sending_portal
	if(!rift_can_open_at(destination, eye.anchor))
		to_chat(eye, span_warning("The rift will not open here."))
		return
	if(sending_portal && sending)
		to_chat(eye, span_warning("A portal is already active!"))
		return
	if(QDELETED(user) || user.stat == DEAD || get_dist(user, src) > 1 || QDELETED(amulet) || amulet.uses <= 0 || !(amulet in GLOB.vampire_objects) || !user.has_bloodpool_cost(RIFT_GATE_VITAE_COST))
		to_chat(eye, span_warning("The rift collapses before it can open."))
		eye.return_from_rift()
		return

	eye.return_from_rift()
	user.adjust_bloodpool(-RIFT_GATE_VITAE_COST)
	amulet.uses -= 1
	if(sending_portal)
		new /obj/effect/landmark/vteleportsenddest(destination)
		create_portal()
	else
		var/obj/effect/landmark/vteleportdestination/return_point = new(destination)
		return_point.amuletname = amulet.name
		create_portal_return(amulet.name, 3000)
	user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)
	if(amulet.uses <= 0)
		amulet.visible_message("[amulet] shatters!")
		qdel(amulet)
	SStgui.update_uis(src)
	return TRUE

/obj/structure/vampire/portalmaker/proc/get_rift_anchor(obj/item/clothing/neck/portalamulet/amulet)
	var/turf/anchor = get_turf(amulet)
	var/area/anchor_area = get_area(anchor)
	if(!anchor || !anchor_area || anchor_area.hidden)
		return null
	return anchor

/obj/structure/vampire/portalmaker/proc/rift_can_open_at(turf/destination, turf/anchor)
	if(!istype(destination) || !istype(anchor) || destination.z != anchor.z)
		return FALSE
	if(get_dist(destination, anchor) > RIFT_GATE_PLACEMENT_RANGE)
		return FALSE
	if(destination.density || istransparentturf(destination))
		return FALSE
	var/area/destination_area = get_area(destination)
	return destination_area && !destination_area.hidden

/obj/structure/vampire/portal
	name = "Eerie Portal"
	icon_state = "portal"
	var/duration = 999
	var/spawntime = null
	density = FALSE

/obj/structure/vampire/portal/Initialize(mapload)
	. = ..()
	set_light(3, 2, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC)
	playsound(loc, 'sound/misc/portalopen.ogg', 100, FALSE, pressure_affected = FALSE)

	addtimer(CALLBACK(src, PROC_REF(delete)), 60 SECONDS)

/obj/structure/vampire/portal/proc/delete()
	visible_message(span_boldnotice("[src] shudders before rapidly closing."))
	qdel(src)

/obj/structure/vampire/portal/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		for(var/obj/effect/landmark/vteleport/dest in GLOB.landmarks_list)
			playsound(loc, 'sound/misc/portalenter.ogg', 100, FALSE, pressure_affected = FALSE)
			AM.forceMove(dest.loc)
			break

/obj/structure/vampire/portal/sending
	name = "Eerie Portal"
	icon_state = "portal"
	duration = 999
	spawntime = null
	var/turf/destloc

/obj/structure/vampire/portal/sending/Crossed(atom/movable/AM)
	if(isliving(AM))
		for(var/obj/effect/landmark/vteleportsenddest/V in GLOB.landmarks_list)
			AM.forceMove(V.loc)

/obj/structure/vampire/portal/sending/Destroy()
	for(var/obj/effect/landmark/vteleportsenddest/V in GLOB.landmarks_list)
		qdel(V)
	for(var/obj/structure/vampire/portalmaker/P in GLOB.vampire_objects)
		P.sending =  FALSE
	return ..()

/obj/structure/vampire/portalmaker/proc/create_portal_return(aname,duration)
	for(var/obj/effect/landmark/vteleportdestination/Vamp in GLOB.landmarks_list)
		if(Vamp.amuletname == aname)
			var/obj/structure/vampire/portal/P = new(get_turf(Vamp))
			P.duration = duration
			P.spawntime = world.time
			P.visible_message(span_boldnotice("A sickening tear is heard as a sinister portal emerges."))
		qdel(Vamp)

/obj/structure/vampire/portalmaker/proc/create_portal(choice,duration)
	sending = TRUE
	for(var/obj/effect/landmark/vteleportsending/S in GLOB.landmarks_list)
		var/obj/structure/vampire/portal/sending/P = new(S.loc)
		P.visible_message(span_boldnotice("A sickening tear is heard as a sinister portal emerges."))

/obj/item/clothing/neck/portalamulet
	name = "Gate Amulet"
	icon_state = "bloodtooth"
	icon = 'icons/roguetown/clothing/neck.dmi'
	var/uses = 3

/obj/item/clothing/neck/portalamulet/Initialize(mapload)
	GLOB.vampire_objects |= src
	. = ..()

/obj/item/clothing/neck/portalamulet/Destroy()
	GLOB.vampire_objects -= src
	return ..()

/* DISABLED FOR NOW
/obj/item/clothing/neck/portalamulet/attack_self(mob/user, params)
	. = ..()
	if(alert(user, "Create a portal?", "PORTAL GEM", "Yes", "No") == "Yes")
		uses -= 1
		var/obj/effect/landmark/vteleportdestination/Vamp = new(loc)
		Vamp.amuletname = name
		for(var/obj/structure/vampire/portalmaker/P in GLOB.vampire_objects)
			P.create_portal_return(name, 3000)
		user.playsound_local(get_turf(src), 'sound/misc/portalactivate.ogg', 100, FALSE, pressure_affected = FALSE)
		if(uses <= 0)
			visible_message("[src] shatters!")
			qdel(src)
*/

/mob/dead/observer/rogue/arcaneeye/rift
	var/obj/structure/vampire/portalmaker/gate
	var/obj/item/clothing/neck/portalamulet/amulet
	var/turf/anchor
	var/sending_portal = FALSE
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
	amulet = null
	anchor = null
	return ..()

/mob/dead/observer/rogue/arcaneeye/rift/proc/bind_rift(mob/living/body, obj/structure/vampire/portalmaker/rift_gate, obj/item/clothing/neck/portalamulet/rift_amulet, turf/rift_anchor, rift_sending)
	vampirelord = body
	gate = rift_gate
	amulet = rift_amulet
	anchor = rift_anchor
	sending_portal = rift_sending
	RegisterSignal(body, COMSIG_QDELETING, PROC_REF(on_body_deleted))
	RegisterSignal(rift_gate, COMSIG_QDELETING, PROC_REF(on_gate_deleted))
	RegisterSignal(rift_amulet, COMSIG_QDELETING, PROC_REF(on_amulet_deleted))
	forceMove(rift_anchor)
	sight_timer = addtimer(CALLBACK(src, PROC_REF(return_from_rift)), RIFT_GATE_SIGHT_DURATION, TIMER_STOPPABLE)

/mob/dead/observer/rogue/arcaneeye/rift/proc/on_body_deleted(datum/source)
	SIGNAL_HANDLER
	vampirelord = null

/mob/dead/observer/rogue/arcaneeye/rift/proc/on_gate_deleted(datum/source)
	SIGNAL_HANDLER
	gate = null
	INVOKE_ASYNC(src, PROC_REF(return_from_rift))

/mob/dead/observer/rogue/arcaneeye/rift/proc/on_amulet_deleted(datum/source)
	SIGNAL_HANDLER
	amulet = null

/mob/dead/observer/rogue/arcaneeye/rift/Login()
	. = ..()
	show_placement()
	to_chat(src, span_notice("My sight passes through the anchor. I may drift up to [RIFT_GATE_PLACEMENT_RANGE] paces from it: <b>Open Rift Here</b> tears the rift where I stand, <b>Return to Body</b> abandons it."))

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
		var/can_open = gate?.rift_can_open_at(marked, anchor)
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
