/mob/living/carbon/human/proc/apply_expedition_badge(goal)
	ADD_TRAIT(src, TRAIT_EXPEDITION_MEMBER, TRAIT_GENERIC)
	to_chat(src, "<h2 style='color: gold;'>You have been consecrated for the Crusade for [goal]!</h2>")
	to_chat(src, span_boldnotice("March to the borderlands gateway with your vanguard!"))
	playsound(src, 'sound/misc/bell.ogg', 50, FALSE)
	update_hud_crusader()

/mob/living/carbon/human/proc/remove_expedition_badge()
	REMOVE_TRAIT(src, TRAIT_EXPEDITION_MEMBER, TRAIT_GENERIC)
	update_hud_crusader()

/mob/living/carbon/human/proc/update_hud_crusader()
	return

/proc/complete_expedition(success = TRUE)
	if(GLOB.expedition_status == EXPEDITION_COMPLETED)
		return

	if(success)
		GLOB.expedition_status = EXPEDITION_COMPLETED
		priority_announce(
			"Rejoice! The royal expedition has vanquished the ancient terror and returns victorious with great riches!",
			"EXPEDITION TRIUMPH",
			'sound/misc/bell.ogg',
			"Captain"
		)
	else
		GLOB.expedition_status = EXPEDITION_COMPLETED
		priority_announce(
			"Mournful tidings. The royal expedition has fallen in the dark depths. The realm weeps for its vanguard.",
			"EXPEDITION LOST",
			'sound/misc/lawspurged.ogg',
			"Captain"
		)

	for(var/mob/living/carbon/human/member in GLOB.expedition_party)
		if(!QDELETED(member))
			member.remove_expedition_badge()
	GLOB.expedition_party.Cut()

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
