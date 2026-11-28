// Set dressing for the bandit camp: the gang's standard and wall banner, and a ruined throne that Matthios whispers through.

/obj/structure/fluff/brigand_standard
	name = "brigand standard"
	desc = "A ragged standard on a crooked pole, its cloth stitched from stolen finery. Where it flies, the Freefolk answer to no lord."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "brigand_standard"
	layer = BELOW_OBJ_LAYER
	resistance_flags = FLAMMABLE
	max_integrity = 100
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/// The standard's cloth without its pole, hung on a wall. Map it on the tile below the wall with pixel_y = 32, like the other wall banners.
/obj/structure/fluff/walldeco/brigand_banner
	name = "brigand banner"
	desc = "The Freefolk's colours, torn and moth-eaten, nailed up to mark the place as theirs. Every rip in it was paid for by someone else."
	icon_state = "brigand_banner"

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
	/// The throne's layer while nobody sits in it, restored when they get up
	var/empty_layer
	var/static/list/whispers = list(
		"There can ALWAYS be more...",
		"It is NEVER enough...",
		"They all have SO much, we must TAKE it...",
		"They keep it all for themselves...",
		"Once a King sat here. Power fades, only wealth remains...",
		"Make HIM proud...",
		"More gold, we need more...",
		"You are HIS chosen. Take what is OURS...",
	)

/obj/structure/ruined_throne/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/ruined_throne/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 8)
	// Maps may raise the throne above mobs so its tall back covers what stands behind it; drop under the sitter while seated
	if(isnull(empty_layer))
		empty_layer = layer
	layer = min(empty_layer, BELOW_MOB_LAYER)
	next_whisper = world.time + 20 SECONDS
	START_PROCESSING(SSobj, src)

/obj/structure/ruined_throne/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE
	M.reset_offsets("bed_buckle")
	if(!length(buckled_mobs))
		if(!isnull(empty_layer))
			layer = empty_layer
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

/// A chandelier that came down and smashed on the floor. Floor debris: it can be walked over.
/obj/structure/fluff/fallen_chandelier
	name = "fallen chandelier"
	desc = "A chandelier that has torn free of the ceiling and smashed itself on the floor. Its candles lie scattered in pools of old wax."
	icon = 'icons/roguetown/misc/tallwide.dmi'
	icon_state = "chand_fallen"
	pixel_x = -9
	layer = BELOW_OBJ_LAYER
	blade_dulling = DULLING_BASH
	attacked_sound = list('sound/combat/hits/onmetal/sheet (1).ogg')

/// A heap of fallen stone filling a single tile. Dense and not climbable, so it blocks the way.
/obj/structure/rubble
	name = "rubble"
	desc = "A heap of broken stone where part of the ceiling came down. There is no getting past it."
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "rubble1"
	density = TRUE
	anchored = TRUE
	opacity = FALSE
	climbable = FALSE
	layer = TABLE_LAYER
	max_integrity = 300
	blade_dulling = DULLING_BASH
	attacked_sound = 'sound/foley/hit_rock.ogg'
	destroy_sound = 'sound/foley/smash_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 3)

/obj/structure/rubble/Initialize(mapload)
	. = ..()
	icon_state = "rubble[rand(1,3)]"
