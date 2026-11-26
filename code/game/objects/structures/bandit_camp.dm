// Set dressing for the bandit camp: the gang's standing banner and a ruined throne that Matthios whispers through.

/obj/structure/fluff/brigand_banner
	name = "brigand banner"
	desc = "A ragged standard on a crooked pole, its cloth stitched from stolen finery. Where it flies, the Freefolk answer to no lord."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "brigand_banner"
	layer = BELOW_OBJ_LAYER
	resistance_flags = FLAMMABLE
	max_integrity = 100
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/// Looks and seats like the ducal throne, but is only decoration. Whoever sits in it hears Matthios.
/obj/structure/ruined_throne
	name = "ruined throne"
	desc = "A noble seat dragged from some fallen manor, its gilding scraped away coin by coin. It still remembers being sat upon by kings."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "throne_ruined"
	density = FALSE
	can_buckle = TRUE
	pixel_x = -32
	max_integrity = 999999
	buckle_lying = FALSE
	obj_flags = NONE
	/// world.time of the sitter's next whisper
	var/next_whisper = 0
	/// The last line whispered, so it is not repeated straight away
	var/last_whisper
	var/static/list/whispers = list(
		"More. There is always more gold.",
		"Their coffers groan while your belly does. Take what is owed.",
		"What the few hoard belongs to all. Make it so.",
		"The idol hungers. Feed it.",
		"A crown is only gold someone else has not yet taken.",
		"Count it again. It is not enough.",
		"Every lock is a lie the rich tell themselves.",
		"You sit where a king once sat. Kings fall. Gold remains.",
	)

/obj/structure/ruined_throne/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/ruined_throne/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 8)
	next_whisper = world.time + 20 SECONDS
	START_PROCESSING(SSobj, src)

/obj/structure/ruined_throne/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE
	M.reset_offsets("bed_buckle")
	if(!length(buckled_mobs))
		STOP_PROCESSING(SSobj, src)

/obj/structure/ruined_throne/process()
	if(!length(buckled_mobs))
		return PROCESS_KILL
	var/mob/living/sitter = buckled_mobs[1]
	if(sitter.stat != CONSCIOUS)
		next_whisper = world.time + 20 SECONDS
		return
	if(world.time < next_whisper)
		return
	next_whisper = world.time + rand(60, 120) SECONDS
	last_whisper = pick(whispers - last_whisper)
	to_chat(sitter, "<font color='#e6b422'><i>[last_whisper]</i></font>")
	sitter.playsound_local(get_turf(sitter), 'sound/misc/coininsert.ogg', 25, FALSE)
