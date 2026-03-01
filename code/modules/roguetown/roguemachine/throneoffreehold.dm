GLOBAL_VAR(announcement_throne)

/obj/structure/roguethrone/announcement
	name = "throne of Freehold"
	desc = "No "
	icon = 'icons/roguetown/misc/freethrone.dmi'
	icon_state = "freeholdthrone"
	density = FALSE
	can_buckle = TRUE
	pixel_x = -32
	max_integrity = 999999
	buckle_lying = FALSE
	obj_flags = NONE

	/// 0 = idle, 1 = waiting for normal announcement, 2 = waiting for raid announcement
	var/mode = 0
	var/next_announcement_time = 0
	var/raid_called = FALSE

/obj/structure/roguethrone/announcement/Initialize()
	. = ..()
	if(GLOB.announcement_throne == null)
		GLOB.announcement_throne = src

/obj/structure/roguethrone/announcement/Destroy()
	if(GLOB.announcement_throne == src)
		GLOB.announcement_throne = null
	return ..()

/obj/structure/roguethrone/announcement/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, message)
	if(speaker == src)
		return
	if(speaker.loc != loc)
		return
	if(!ishuman(speaker))
		return
	if(obj_broken)
		return
	if(!length(buckled_mobs))
		return
	if(buckled_mobs[1] != speaker)
		return

	var/mob/living/carbon/human/H = speaker

	if(mode)
		if(findtext(message, "nevermind"))
			mode = 0
			say("Very well.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return

	switch(mode)
		if(0)
			if(findtext(message, "secrets of the throne"))
				say("My commands are: Make Announcement, Announce Raid, Nevermind")
				playsound(src, 'sound/misc/machinelong.ogg', 100, FALSE, -1)
				return

			if(findtext(message, "make announcement"))
				if(world.time < next_announcement_time)
					say("Tis not yet time for another announcement. Wait [DisplayTimeText(next_announcement_time - world.time)].")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(!SScommunications.can_announce(H))
					say("I must gather my strength!")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("Speak and they will hear.")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				mode = 1
				return

			if(findtext(message, "announce raid"))
				if(raid_called)
					say("A raid has already been declared from this throne.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				if(!HAS_TRAIT(H, TRAIT_FREEHOLDER))
					say("Only freeholders may call a raid from this throne.")
					playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
					return
				say("Speak and the realm shall be called to raid.")
				playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
				mode = 2
				return

		if(1)
			make_throne_announcement(H, raw_message)
			mode = 0
			return

		if(2)
			make_raid_announcement(H, raw_message)
			mode = 0
			return

/obj/structure/roguethrone/announcement/proc/make_throne_announcement(mob/living/user, raw_message)
	if(world.time < next_announcement_time)
		return
	if(!SScommunications.can_announce(user))
		return
	if(!raw_message || !length(trim(raw_message)))
		return

	next_announcement_time = world.time + 10 MINUTES
	SScommunications.make_announcement(user, FALSE, raw_message)

/obj/structure/roguethrone/announcement/proc/make_raid_announcement(mob/living/user, raw_message)
	if(raid_called)
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_FREEHOLDER))
		return FALSE
	if(!raw_message || !length(trim(raw_message)))
		return FALSE

	priority_announce("[user.real_name] calls for a raid: [raw_message]", "A RAID IS DECLARED", 'sound/misc/royal_decree2.ogg', "The warboss")
	raid_called = TRUE
	return TRUE
