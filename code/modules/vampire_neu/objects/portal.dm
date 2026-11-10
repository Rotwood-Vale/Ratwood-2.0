#define RIFT_GATE_VITAE_COST 1000

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
	return data

/obj/structure/vampire/portalmaker/ui_data(mob/user)
	var/list/data = list()
	var/list/amulets = list()
	for(var/obj/item/clothing/neck/portalamulet/amulet in GLOB.vampire_objects)
		amulets += list(list(
			"ref" = REF(amulet),
			"name" = amulet.name,
			"area" = get_area_name(amulet, TRUE) || "Unknown",
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

	user.visible_message("[user] begins to summon a portal.", "I begin to summon a portal.")
	if(!do_after(user, 3 SECONDS, src))
		return
	if(QDELETED(amulet) || amulet.uses <= 0 || (sending_portal && sending) || !user.has_bloodpool_cost(RIFT_GATE_VITAE_COST))
		return

	var/turf/destination = get_turf(amulet)
	if(!destination)
		return

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
	return TRUE

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

#undef RIFT_GATE_VITAE_COST
