GLOBAL_LIST_EMPTY(mirage_markers)
GLOBAL_DATUM(mirage_controller, /datum/mirage_controller)

/obj/effect/mirage_marker/Initialize(mapload)
	. = ..()
	GLOB.mirage_markers += src

/obj/effect/mirage_marker/Destroy()
	GLOB.mirage_markers -= src
	return ..()

/obj/effect/mirage_marker
	name = "mirage location"
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
/datum/map_overlay
	var/datum/map_template/template

	var/list/original_tiles = list()
	var/list/original_objects = list()
	var/list/template_objects = list()

	var/width = 20
	var/height = 20
	var/list/created_objects = list()
	var/turf/current_location
	var/list/original_contents = list()

/datum/map_overlay/mirage_oasis/New()
	. = ..()
	template = new /datum/map_template/mirage_oasis
	if(template.width)
		width = template.width
	if(template.height)
		height = template.height


/datum/map_overlay/proc/GetAreaContents(turf/start)
	var/list/contents = list()
	for(var/turf/T in block(
		start,
		locate(
			start.x + width - 1,
			start.y + height - 1,
			start.z)))
		for(var/atom/movable/A in T)
			contents += A
	return contents

/datum/map_overlay/var/list/protected_types = list(
	/obj/structure,
	/obj/item/natural/rock
)

/datum/map_overlay/proc/SaveArea(turf/start)
	current_location = start
	original_tiles.Cut()
	original_objects.Cut()
	for(var/turf/T in block(
		start,
		locate(start.x + width - 1, start.y + height - 1, start.z)))
		original_tiles[T] = T.type
		for(var/obj/O in T)
			for(var/type in protected_types)
				if(istype(O, type))
					original_objects[O] = T
					break
	return GetAreaContents(start)

/datum/map_overlay/proc/ShieldOriginalObjects()
	for(var/obj/O as anything in original_objects)
		if(QDELETED(O))
			continue
		O.moveToNullspace()

/datum/map_overlay/proc/UnshieldOriginalObjects()
	for(var/obj/O as anything in original_objects)
		if(QDELETED(O))
			continue
		var/turf/T = original_objects[O]
		if(!QDELETED(T))
			O.forceMove(T)


/datum/map_overlay/proc/RestoreArea()
	for(var/turf/T in original_tiles)

		var/type = original_tiles[T]

		if(T.type != type)
			T.ChangeTurf(
				type,
				flags = CHANGETURF_IGNORE_AIR
			)

/datum/map_overlay/proc/Apply(turf/start)
	if(!start)
		return
	var/list/before = SaveArea(start)
	ShieldOriginalObjects() // stays shielded for the whole oasis lifespan now
	template.load(start)
	var/list/after = GetAreaContents(start)
	template_objects = after - before

	original_contents.Cut()
	for(var/atom/movable/A in template_objects)
		if(length(A.contents))
			original_contents[A] = A.contents.Copy()

/datum/map_overlay/proc/Remove()
	for(var/atom/movable/A in template_objects)
		if(QDELETED(A))
			continue
		var/list/spawn_contents = original_contents[A]
		for(var/atom/movable/inner in A.contents)
			if(spawn_contents && (inner in spawn_contents))
				qdel(inner)
			else
				inner.forceMove(get_turf(A))
		qdel(A)

	RestoreArea() // turfs are already clear of pre-existing objects, safe to ChangeTurf directly
	UnshieldOriginalObjects() // bring the rocks back now that the oasis is fully gone

	template_objects.Cut()
	original_tiles.Cut()
	original_objects.Cut()
	original_contents.Cut()


/datum/map_overlay/proc/MoveTo(turf/new_location)

	Remove()

	Apply(new_location)



/////MIRAGE CONTROLLER/////
/datum/mirage_controller
	var/datum/map_overlay/mirage_oasis/oasis

	var/list/markers = list()
	var/obj/effect/mirage_marker/current_marker

/datum/mirage_controller/New()
	oasis = new


/datum/mirage_controller/proc/IsValidOasisLocation(turf/start)
	for(var/turf/T in block(start, locate(start.x + oasis.width - 1, start.y + oasis.height - 1, start.z)))
		if(!T)
			return FALSE
		for(var/mob/living/L in T)
			return FALSE
	return TRUE

/datum/mirage_controller/proc/MoveOasis()
	if(!GLOB.mirage_markers.len)
		return FALSE
	var/list/candidates = GLOB.mirage_markers.Copy()
	if(current_marker)
		candidates -= current_marker
	if(!candidates.len)
		return FALSE // only one marker exists total, nothing else to move to
	while(candidates.len)
		var/obj/effect/mirage_marker/M = pick(candidates)
		candidates -= M
		var/turf/T = get_turf(M)
		if(IsValidOasisLocation(T))
			oasis.MoveTo(T)
			current_marker = M
			return TRUE
	return FALSE