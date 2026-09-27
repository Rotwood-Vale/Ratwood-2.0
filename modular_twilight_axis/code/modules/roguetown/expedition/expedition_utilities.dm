
/obj/structure/mineral_door
	var/boss_door_id = null

/obj/structure/mineral_door/Initialize(mapload)
	. = ..()
	if(boss_door_id)
		GLOB.boss_mineral_doors += src

/obj/structure/mineral_door/Destroy()
	if(boss_door_id)
		GLOB.boss_mineral_doors -= src
	return ..()

/obj/structure/mineral_door/proc/unlock_and_open()
	locked = FALSE
	force_open()
	playsound(src, openSound, 100, FALSE)
	visible_message(span_boldnotice("[src] unlocks with a heavy clatter and swings wide open!"))

/obj/structure/mineral_door/secret/unlock_and_open()
	locked = FALSE
	force_open()
	playsound(src, openSound || 'sound/foley/stone_scrape.ogg', 100, FALSE)
	visible_message(span_boldnotice("A hidden mechanism rumbles within the masonry, and the secret passage slides wide open!"))
