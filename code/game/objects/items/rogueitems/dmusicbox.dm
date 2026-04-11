GLOBAL_LIST_EMPTY(musicboxes) //list of all music boxes
GLOBAL_VAR_INIT(musicboxes_last_upload, 0) //last time of the last upload, to prevent multiple uploads within seconds of eachother
GLOBAL_VAR_INIT(musicboxes_last_download, 0) //last time of the last download, to prevent new tracks downloaded for every client too frequently

/datum/looping_sound/dmusloop
	mid_sounds = list()
	mid_length = 12000 // 20 minutes to force a loop. File size determines server load, not audio length. Low bitrate .ogg files can run long and have their uses as ambient sound.
	volume = 100
	falloff = 2
	extra_range = 10	// Up from 5, fill a room.
	var/stress2give = /datum/stressevent/music
	persistent_loop = TRUE
	channel = CHANNEL_CMUSIC1

/datum/looping_sound/dmusloop/on_hear_sound(mob/M)
	. = ..()
	if(stress2give)
		if(isliving(M))
			var/mob/living/carbon/L = M
			L.add_stress(stress2give)

/obj/item/dmusicbox
	name = "dwarven music box"
	desc = "It is essential that the deepest caves be tuned to the right frequency of vibrations."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mbox0"
	gripped_intents = list(INTENT_GENERIC)
	w_class = WEIGHT_CLASS_HUGE
	twohands_required = TRUE
	force = 20
	throwforce = 20
	throw_range = 2
	var/datum/looping_sound/dmusloop/soundloop
	var/curfile
	var/playing = FALSE
	var/loaded = TRUE
	var/lastfilechange = 0
	var/curvol = 100
	var/playingnewtrack = FALSE
	anvilrepair = /datum/skill/craft/blacksmithing

/obj/item/dmusicbox/Initialize(mapload)
	GLOB.musicboxes += src
	soundloop = new(src, FALSE)
//	soundloop.start()
	update_icon()
	. = ..()

/obj/item/dmusicbox/Destroy()
	GLOB.musicboxes.Remove(src)
	playing = FALSE
	soundloop.stop()
	return ..()

/obj/item/dmusicbox/update_icon()
	if(playing)
		icon_state = "mboxon"
	else
		icon_state = "mbox[loaded]"

/obj/item/dmusicbox/attackby(obj/item/P, mob/user, params)
	if(!loaded)
		if(istype(P, /obj/item/roguecoin/copper))
			loaded=TRUE
			qdel(P)
			update_icon()
			playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
			return
	. = ..()

/obj/item/dmusicbox/rmb_self(mob/user)
	attack_right(user)
	return

/obj/item/dmusicbox/attack_right(mob/user)
	. = ..()
	if(.)
		return
	if(loc != user)
		return
	if(!user.ckey)
		return
	if(playing)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(lastfilechange)
		if(world.time < lastfilechange + 3 MINUTES)
			say("NOT YET!")
			return
	if(!loaded)
		say("ONE COIN, A COPPER COIN FOR AN AFTERNOON OF JOY!")
		return
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/infile = input(user, "CHOOSE A NEW SONG", src) as null|file

	if(!infile)
		return

	if(!loaded)
		return

	if(world.time < GLOB.musicboxes_last_upload + 30 SECONDS)
		say("NOT YET!")
		return

	var/filename = "[infile]"
	var/file_ext = LOWER_TEXT(copytext(filename, -4))
	var/file_size = length(infile)

	if(file_ext != ".ogg")
		to_chat(user, span_warning("SONG MUST BE AN OGG."))
		return
	if(file_size > 6485760)
		to_chat(user, span_warning("TOO BIG. 6 MEGS OR LESS."))
		return
	lastfilechange = world.time
	GLOB.musicboxes_last_upload = world.time
	var/rng_number = "[rand(1,99)]" // prevent chance of file overwriting
	fcopy(infile,"data/jukeboxuploads/[user.ckey]/[rng_number][filename]")
	curfile = file("data/jukeboxuploads/[user.ckey]/[rng_number][filename]")

	loaded = FALSE
	playingnewtrack = TRUE
	update_icon()


/obj/item/dmusicbox/attack_self(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(!playing)
		if(curfile)
			var/new_channel = find_free_channel()
			if(!new_channel)
				to_chat(user, span_warning("TOO MANY MUSIC BOXES IN USE AT THE SAME TIME IN THE WORLD."))
				return
			if(playingnewtrack)
				if(world.time < GLOB.musicboxes_last_download + 15 SECONDS)
					to_chat(user, span_warning("STILL UPLOADING...")) // lie to the player, we don't want too many server wide music downloads to halt the round too frequently
					return
				GLOB.musicboxes_last_download = world.time
				playingnewtrack = FALSE
			playing = TRUE
			soundloop.channel = new_channel
			soundloop.mid_sounds = list(curfile)
			soundloop.cursound = null
			soundloop.start()
	else
		playing = FALSE
		soundloop.stop()
	update_icon()

/obj/item/dmusicbox/proc/find_free_channel()
	var/free_channel = 1|2|4|8
	for(var/obj/item/dmusicbox/musicbox in GLOB.musicboxes)
		if(!musicbox.playing || musicbox.soundloop.stopped)
			continue
		switch(musicbox.soundloop.channel)
			if(CHANNEL_CMUSIC1)
				free_channel &= ~1
			if(CHANNEL_CMUSIC2)
				free_channel &= ~2
			if(CHANNEL_CMUSIC3)
				free_channel &= ~4
			if(CHANNEL_CMUSIC4)
				free_channel &= ~8
	if(!free_channel) // no channels free, abort
		return 0

	if(free_channel&1)
		return CHANNEL_CMUSIC1
	if(free_channel&2)
		return CHANNEL_CMUSIC2
	if(free_channel&4)
		return CHANNEL_CMUSIC3
	if(free_channel&8)
		return CHANNEL_CMUSIC4
	return 0
