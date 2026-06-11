/obj/structure/closet/crate/coffin/sarcophagus
	name = "石棺"
	icon_state = "sarcophagus"
	desc = "供体面死者安息之处。"
	anchored = TRUE
	resistance_flags = null
	open_sound_volume = 25
	close_sound_volume = 50
	max_integrity = 120
	icon = 'modular_helmsguard/icons/obj/structure/crypt.dmi'
	open_sound = 'sound/foley/doors/stoneopen.ogg'
	close_sound = 'sound/foley/doors/stoneclose.ogg'
	var/occupant = null //the occupant of the sarcophagus, if any

/obj/structure/closet/crate/coffin/sarcophagus/alt
	icon_state = "sarcophagus2"

/obj/structure/closet/crate/coffin/sarcophagus/alt2
	icon_state = "sarcophagus3"

/obj/structure/closet/crate/coffin/sarcophagus/alt3
	icon_state = "sarcophagus4"


/obj/structure/sarcophagus
	name = "石棺"
	icon = 'modular_helmsguard/icons/obj/structure/crypt.dmi'
	icon_state = "sarcophagus_abandoned"
	anchored = TRUE
	density = TRUE

/obj/structure/sarcophagus/alt
	icon_state = "sarcophagus_abandoned2"

/obj/structure/closet/crate/coffin/sarcophagus/open(mob/living/user)
	if(opened)
		return
	if(user)
		if(!can_open(user))
			return
	if(do_after(usr, 30, target = src))
		playsound(loc, open_sound, open_sound_volume, FALSE, -3)
		opened = TRUE
		if(!dense_when_open)
			density = FALSE
	//	climb_time *= 0.5 //it's faster to climb onto an open thing
		dump_contents()
		update_icon()
		return 1


/obj/structure/closet/crate/coffin/sarcophagus/close(mob/living/user)
	if(!opened)
		return FALSE
	if(user)
		if(!can_close(user))
			return FALSE
	if(do_after(usr, 30, target = src))
		take_contents()
		playsound(loc, close_sound, close_sound_volume, FALSE, -3)
	//	climb_time = initial(climb_time)
		opened = FALSE
		density = TRUE
		update_icon()
		return TRUE

/obj/effect/spawner/lootdrop/roguetown/dungeon/corpses
	loot = list(
	/mob/living/carbon/human/species/skeleton/dead/adventurer = 5,
	/mob/living/carbon/human/species/skeleton/dead/manatarms = 7,
	/mob/living/carbon/human/species/skeleton/dead/knight = 1,
	/mob/living/carbon/human/species/skeleton/dead/noble = 3,
	/obj/effect/decal/remains/human = 5,
		)
	lootcount = 1

/obj/effect/spawner/lootdrop/roguetown/dungeon/corpses_no_soldiers
	loot = list(
	/mob/living/carbon/human/species/skeleton/dead/adventurer = 5,
	/mob/living/carbon/human/species/skeleton/dead/noble = 3,
	/obj/effect/decal/remains/human = 5,
		)
	lootcount = 1

/obj/structure/closet/crate/coffin/sarcophagus/danger
	name = "石棺"
	icon_state = "sarcophagus"
	var/springed = FALSE

/obj/structure/closet/crate/coffin/sarcophagus/danger/alt
	icon_state = "sarcophagus2"

/obj/structure/closet/crate/coffin/sarcophagus/danger/alt2
	icon_state = "sarcophagus3"

/obj/structure/closet/crate/coffin/sarcophagus/danger/alt3
	icon_state = "sarcophagus4"



/obj/structure/closet/crate/coffin/sarcophagus/danger/open(mob/living/user)
	if(opened)
		return
	if(user)
		if(!can_open(user))
			return
	if(do_after(usr, 30, target = src))
		playsound(loc, open_sound, open_sound_volume, FALSE, -3)
		opened = TRUE
		if(!dense_when_open)
			density = FALSE
		springed = TRUE
		dump_contents()
		update_icon()
		new /mob/living/carbon/human/species/skeleton/npc/ambush(get_turf(src))
		return 1
	..()

/obj/structure/closet/crate/coffin/sarcophagus/dungeon/alt
	icon_state = "sarcophagus2"

/obj/structure/closet/crate/coffin/sarcophagus/dungeon/alt2
	icon_state = "sarcophagus3"

/obj/structure/closet/crate/coffin/sarcophagus/dungeon/alt3
	icon_state = "sarcophagus4"


/obj/structure/closet/crate/coffin/sarcophagus/dungeon/PopulateContents()
	..()
	occupant = pick(/mob/living/carbon/human/species/skeleton/dead/adventurer,
					/mob/living/carbon/human/species/skeleton/dead/noble,
					) 
	new occupant(src)


/obj/effect/spawner/lootdrop/roguetown/sarcophagi
	name = "石棺群"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "redskull"
	loot = list(
	/obj/structure/closet/crate/coffin/sarcophagus/danger = 10,
	/obj/structure/closet/crate/coffin/sarcophagus/danger/alt = 10,
	/obj/structure/closet/crate/coffin/sarcophagus/danger/alt2 = 10,
	/obj/structure/closet/crate/coffin/sarcophagus/danger/alt3 = 10,
	/obj/structure/closet/crate/coffin/sarcophagus/dungeon = 10,
	/obj/structure/closet/crate/coffin/sarcophagus/dungeon/alt = 10,
	/obj/structure/closet/crate/coffin/sarcophagus/dungeon/alt2 = 10,
	/obj/structure/closet/crate/coffin/sarcophagus/dungeon/alt3 = 10,
	/obj/structure/closet/crate/coffin/sarcophagus = 5,
	/obj/structure/closet/crate/coffin/sarcophagus/alt = 5,
	/obj/structure/closet/crate/coffin/sarcophagus/alt2 = 5,
	/obj/structure/closet/crate/coffin/sarcophagus/alt3 = 5,
	/obj/structure/sarcophagus = 1,
	/obj/structure/sarcophagus/alt =1.
	)
	lootcount = 1

