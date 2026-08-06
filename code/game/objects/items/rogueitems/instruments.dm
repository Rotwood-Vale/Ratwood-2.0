/datum/looping_sound/instrument
	mid_length = 120000 // 20 minutes. Previously 4 minutes for no reason. Songs are restricted to 6 megs. If you have twenty minutes of mono low bitrate or one minute of studio quality orchestra, it makes no difference to the server.
	volume = 100
	extra_range = 10	// Increase sound range.
	persistent_loop = TRUE
	var/stress2give = /datum/stressevent/music
	sound_group = /datum/sound_group/instruments

GLOBAL_LIST_EMPTY(instrument_band_lobbies)

/proc/instrument_band_member_id(mob/living/user)
	if(!user)
		return null
	if(user.mind)
		return "[REF(user.mind)]"
	return "[REF(user)]"

/datum/instrument_band_slot
	var/member_id
	var/member_name
	var/instrument_type
	var/instrument_name
	var/song_file
	var/datum/weakref/instrument_ref
	var/datum/weakref/mob_ref

/datum/instrument_band_lobby
	var/owner_id
	var/owner_name
	var/datum/weakref/owner_ref
	var/list/member_slots = list() // key: instrument instance ref text

/datum/instrument_band_lobby/proc/register_owner(mob/living/user, obj/item/rogue/instrument/instrument, song_file)
	owner_id = instrument_band_member_id(user)
	owner_name = user.real_name
	owner_ref = WEAKREF(user)
	// Registering a new band is a clean slate — wipe ALL previous member slots
	// so instruments from prior sessions don't silently carry over.
	member_slots = list()
	add_or_replace_member(user, instrument, song_file)

/datum/instrument_band_lobby/proc/add_or_replace_member(mob/living/user, obj/item/rogue/instrument/instrument, song_file)
	var/member_id = instrument_band_member_id(user)
	if(!member_id || !instrument || !song_file)
		return FALSE
	var/slot_key = "[REF(instrument)]"
	var/datum/instrument_band_slot/slot = member_slots[slot_key]
	if(!slot)
		slot = new
		member_slots[slot_key] = slot
	var/old_member = slot.member_name
	slot.member_id = member_id
	slot.member_name = user.real_name
	slot.instrument_type = slot_key
	slot.instrument_name = instrument.name
	slot.song_file = song_file
	slot.instrument_ref = WEAKREF(instrument)
	slot.mob_ref = WEAKREF(user)

	if(owner_id && owner_id != member_id)
		var/mob/living/owner_mob = owner_ref?.resolve()
		if(owner_mob)
			if(old_member && old_member != user.real_name)
				to_chat(owner_mob, span_notice("[user.real_name] replaced [old_member] on [instrument.name] in your band lobby."))
			else
				to_chat(owner_mob, span_notice("[user.real_name] joined your band lobby with [instrument.name]."))
	return TRUE

/datum/instrument_band_lobby/proc/remove_member_by_id(member_id)
	for(var/slot_key in member_slots.Copy())
		var/datum/instrument_band_slot/slot = member_slots[slot_key]
		if(slot?.member_id == member_id)
			member_slots -= slot_key

/datum/instrument_band_lobby/proc/remove_member_by_instrument(obj/item/rogue/instrument/instrument)
	if(!instrument)
		return
	var/slot_key = "[REF(instrument)]"
	if(member_slots[slot_key])
		member_slots -= slot_key

/datum/instrument_band_lobby/proc/get_active_slots()
	var/list/active_slots = list()
	for(var/slot_key in member_slots.Copy())
		var/datum/instrument_band_slot/slot = member_slots[slot_key]
		if(!slot)
			member_slots -= slot_key
			continue
		var/obj/item/rogue/instrument/instrument = slot.instrument_ref?.resolve()
		if(!instrument || QDELETED(instrument))
			member_slots -= slot_key
			continue
		active_slots += slot
	return active_slots

/datum/instrument_band_lobby/proc/get_title()
	if(owner_name)
		return "[owner_name]'s Band"
	return "Unnamed Band"

/datum/instrument_band_lobby/proc/is_within_range(atom/reference, range = 10)
	if(!reference)
		return FALSE
	var/turf/reference_turf = get_turf(reference)
	if(!reference_turf)
		return FALSE
	for(var/datum/instrument_band_slot/slot in get_active_slots())
		var/obj/item/rogue/instrument/instrument = slot.instrument_ref?.resolve()
		if(!instrument)
			continue
		var/turf/check_turf = get_turf(instrument)
		// Organs are moved to nullspace on Insert(), so get_turf() returns null.
		// Fall back to the registered mob's turf in that case.
		if(!check_turf)
			var/mob/living/slot_mob = slot.mob_ref?.resolve()
			check_turf = get_turf(slot_mob)
		if(!check_turf)
			continue
		if(get_dist(reference_turf, check_turf) <= range)
			return TRUE
	return FALSE

/datum/instrument_band_lobby/proc/stop_all_playing_members()
	for(var/datum/instrument_band_slot/slot in get_active_slots())
		var/obj/item/rogue/instrument/instrument = slot.instrument_ref?.resolve()
		if(!instrument)
			continue
		if(!instrument.playing && !instrument.groupplaying)
			continue
		var/atom/stop_source = instrument
		if(isliving(instrument.loc))
			stop_source = instrument.loc
		else if(instrument.not_held)
			// not_held organs are in nullspace; resolve the mob from the stored weakref.
			var/mob/living/slot_mob = slot.mob_ref?.resolve()
			if(slot_mob)
				stop_source = slot_mob
		instrument.playing = FALSE
		instrument.groupplaying = FALSE
		instrument.soundloop.stop(stop_source)
		if(isliving(stop_source))
			var/mob/living/holder = stop_source
			holder.remove_status_effect(/datum/status_effect/buff/playing_music)
			if(instrument.not_held)
				holder.remove_status_effect(/datum/status_effect/buff/harpy_sing)

/// Returns the singleton instruments sound group, cached after first lookup.
/datum/looping_sound/instrument/proc/_get_sound_group()
	RETURN_TYPE(/datum/sound_group/instruments)
	var/static/datum/sound_group/instruments/cached
	if(!cached)
		for(var/datum/sound_group/g in GLOB.created_sound_groups)
			if(istype(g, /datum/sound_group/instruments))
				cached = g
				break
	return cached

// attach_loop_to_all_clients() sends a vol=0 sound to every client before the
// song has actually started, pre-populating their played_loops with a stale entry.
// When the real play() fires, playsound_local finds them already in thingshearing
// and only issues a volume update on the finished silent sound instead of
// sending it fresh — so clients never hear it. Skip this entirely for instruments;
// the initial playsound() in play() covers in-range clients, and the update_sounds()
// rescan in SSsoundloopers covers late-joiners via GLOB.persistent_sound_loops.
/datum/looping_sound/instrument/attach_loop_to_all_clients()
	return

/datum/looping_sound/instrument/New(_parent, start_immediately=FALSE, _direct=FALSE, _channel = 0)
	. = ..(_parent, FALSE, _direct, _channel)
	// Parent assigned a channel via round-robin; return it to the pool since
	// channels are only held while actively playing, not while idle.
	if(channel)
		_get_sound_group()?.return_channel(channel)
		channel = null
	if(start_immediately)
		start()

/datum/looping_sound/instrument/Destroy()
	// If destroyed while actively playing, return the channel to the instruments
	// pool rather than letting the base Destroy() leak it to SSsounds' general pool.
	if(channel)
		_get_sound_group()?.return_channel(channel)
		channel = null
	return ..()

/datum/looping_sound/instrument/start(atom/on_behalf_of, sync_anchor)
	if(sync_anchor)
		starttime = sync_anchor
	if(!channel)
		channel = _get_sound_group()?.checkout_channel()
		if(!channel)
			log_game("INSTRUMENT: All [/datum/sound_group/instruments::channel_count] instrument channels in use simultaneously - [parent]")
			return FALSE
	..()
	return TRUE

// Thingshearing was previously cleared BEFORE calling ..() which meant
// the parent stop() had nothing to iterate over and silently did nothing.
// We now let the parent run first, THEN clear thingshearing, and THEN free
// the channel. The manual GLOB.clients loop handles clients whose played_loops
// entry may have been missed by the parent.
/datum/looping_sound/instrument/stop(null_parent)
	if(channel)
		. = ..(null_parent)  // Parent runs first with thingshearing intact.
		for(var/client/C in GLOB.clients)
			if(!(src in C.played_loops))
				continue
			var/list/L = C.played_loops[src]
			var/sound/SD = L?["SOUND"]
			var/stop_channel = SD?.channel || channel
			if(C.mob)
				C.mob.stop_sound_channel(stop_channel)
			else
				SEND_SOUND(C, sound(null, repeat = 0, wait = 0, channel = stop_channel))
			C.played_loops -= src
		thingshearing = list()  // Clear AFTER parent and client loop are done.
		// Return the channel to the group pool so other instruments can use it.
		_get_sound_group()?.return_channel(channel)
		channel = null
	else
		. = ..(null_parent)

/obj/item/rogue/instrument
	name = ""
	desc = ""
	icon = 'icons/roguetown/items/music.dmi'
	icon_state = ""
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK_R|ITEM_SLOT_BACK_L
	can_parry = TRUE
	force = 23
	throwforce = 7
	throw_range = 4
	var/lastfilechange = 0
	var/curvol = 100
	var/datum/looping_sound/instrument/soundloop
	var/list/song_list = list()
	var/note_color = "#7f7f7f"
	var/groupplaying = FALSE
	var/curfile = ""
	var/playing = FALSE
	grid_height = 64
	grid_width = 32
	var/not_held = FALSE

/obj/item/rogue/instrument/equipped(mob/living/user, slot)
	. = ..()
	if(playing && user.get_active_held_item() != src)
		stop_music(user) 

/obj/item/rogue/instrument/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = 0,"sy" = 2,"nx" = 1,"ny" = -4,"wx" = -1,"wy" = 2,"ex" = 7,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = -2,"eturn" = -2,"nflip" = 8,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogue/instrument/Initialize(mapload)
	soundloop = new(src, FALSE)
	ensure_timed_tracks()
	. = ..()

/obj/item/rogue/instrument/Destroy()
	qdel(soundloop)
	. = ..()

/obj/item/rogue/instrument/dropped(mob/living/user, silent)
	..()
	stop_music(user)

/obj/item/rogue/instrument/proc/check_file(infile, filename, user)
	var/file_ext = LOWER_TEXT(copytext(filename, -4))
	var/file_size = length(infile)

	if(file_ext != ".ogg")
		return "SONG MUST BE AN OGG."
	//if(file_size > 4 * 1024 * 1024)
		//return "TOO BIG. 4 MEGS OR LESS."

	message_admins("[ADMIN_LOOKUPFLW(user)] uploaded a song [filename] of size [file_size / 1000000] (~MB).")
	return null

/obj/item/rogue/instrument/attack_self(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(playing)
		return
	ui_interact(user)

/obj/item/rogue/instrument/accord //made all the instruments in alphabetical order bcuz why not?
	name = "accordion"
	desc = "A harmonious vessel of nostalgia and celebration."
	icon_state = "accordion"
	song_list = list("Her Healing Tears" = 'sound/music/instruments/accord (1).ogg',
	"Peddler's Tale" = 'sound/music/instruments/accord (2).ogg',
	"We Toil Together" = 'sound/music/instruments/accord (3).ogg',
	"Just One More, Tavern Wench" = 'sound/music/instruments/accord (4).ogg',
	"Moonlight Carnival" = 'sound/music/instruments/accord (5).ogg',
	"'Ye Best Be Goin'" = 'sound/music/instruments/accord (6).ogg',
	"Beloved Blue" = 'sound/music/instruments/accord (7).ogg')

/obj/item/rogue/instrument/drum
	name = "drum"
	desc = "Fashioned from taut skins across a sturdy frame, pulses like a giant heartbeat."
	icon_state = "drum"
	song_list = list("Barbarian's Moot" = 'sound/music/instruments/drum (1).ogg',
	"Muster the Wardens" = 'sound/music/instruments/drum (2).ogg',
	"The Earth That Quakes" = 'sound/music/instruments/drum (3).ogg',
	"The Power" = 'sound/music/instruments/drum (4).ogg', //BG3 Song
	"Bard Dance" = 'sound/music/instruments/drum (5).ogg', // BG3 Song
	"Old Time Battles" = 'sound/music/instruments/drum (6).ogg') // BG3 Song

/obj/item/rogue/instrument/flute
	name = "flute"
	desc = "A row of slender hollow tubes of varying lengths that produce a light airy sound when blown across."
	icon_state = "flute"
	song_list = list("Half-Dragon's Ten Mammon" = 'sound/music/instruments/flute (1).ogg',
	"'The Local Favorite'" = 'sound/music/instruments/flute (2).ogg',
	"Rous in the Cellar" = 'sound/music/instruments/flute (3).ogg',
	"Her Boots, So Incandescent" = 'sound/music/instruments/flute (4).ogg',
	"Moondust Minx" = 'sound/music/instruments/flute (5).ogg',
	"Quest to the Ends" = 'sound/music/instruments/flute (6).ogg',
	"Spit Shine" = 'sound/music/instruments/flute (7).ogg',
	"The Power" = 'modular_azurepeak/sound/music/instruments/flute (8).ogg', //Baldur's Gate 3 Song
	"Bard Dance" = 'modular_azurepeak/sound/music/instruments/flute (9).ogg', //Baldur's Gate 3 Song
	"Old Time Battles" = 'modular_azurepeak/sound/music/instruments/flute (10).ogg') //Baldur's Gate 3 Song

/obj/item/rogue/instrument/guitar
	name = "guitar"
	desc = "This is a guitar, chosen instrument of wanderers and the heartbroken." // YIPPEE I LOVE GUITAR
	icon_state = "guitar"
	song_list = list("Fire-Cast Shadows" = 'sound/music/instruments/guitar (1).ogg',
	"The Forced Hand" = 'sound/music/instruments/guitar (2).ogg',
	"Regrets Unpaid" = 'sound/music/instruments/guitar (3).ogg',
	"'Took the Mammon and Ran'" = 'sound/music/instruments/guitar (4).ogg',
	"Poor Man's Tithe" = 'sound/music/instruments/guitar (5).ogg',
	"In His Arms Ye'll Find Me" = 'sound/music/instruments/guitar (6).ogg',
	"El Odio" = 'sound/music/instruments/guitar (7).ogg',
	"Danza De Las Lanzas" = 'sound/music/instruments/guitar (8).ogg',
	"The Feline, Forever Returning" = 'sound/music/instruments/guitar (9).ogg',
	"El Beso Carmesí" = 'sound/music/instruments/guitar (10).ogg',
	"The Queen's High Seas" = 'sound/music/instruments/guitar (11).ogg',
	"Harsh Testimony" = 'sound/music/instruments/guitar (12).ogg',
	"Someone Fair" = 'sound/music/instruments/guitar (13).ogg',
	"Daisies in Bloom" = 'sound/music/instruments/guitar (14).ogg')

/obj/item/rogue/instrument/harp
	name = "harp"
	desc = "A harp of elven craftsmanship."
	icon_state = "harp"
	song_list = list("Through Thine Window, He Glanced" = 'sound/music/instruments/harb (1).ogg',
	"The Lady of Red Silks" = 'sound/music/instruments/harb (2).ogg',
	"Eora Doth Watches" = 'sound/music/instruments/harb (3).ogg',
	"On the Breeze" = 'sound/music/instruments/harb (4).ogg',
	"Never Enough" = 'sound/music/instruments/harb (5).ogg',
	"Sundered Heart" = 'sound/music/instruments/harb (6).ogg',
	"Corridors of Time" = 'sound/music/instruments/harb (7).ogg',
	"Determination" = 'sound/music/instruments/harb (8).ogg')

/obj/item/rogue/instrument/hurdygurdy
	name = "hurdy-gurdy"
	desc = "A knob-driven, wooden string instrument that reminds you of the oceans far."
	icon_state = "hurdygurdy"
	song_list = list("Ruler's One Ring" = 'sound/music/instruments/hurdy (1).ogg',
	"Tangled Trod" = 'sound/music/instruments/hurdy (2).ogg',
	"Motus" = 'sound/music/instruments/hurdy (3).ogg',
	"Becalmed" = 'sound/music/instruments/hurdy (4).ogg',
	"The Bloody Throne" = 'sound/music/instruments/hurdy (5).ogg',
	"We Shall Sail Together" = 'sound/music/instruments/hurdy (6).ogg')

/obj/item/rogue/instrument/lute
	name = "lute"
	desc = "Its graceful curves were designed to weave joyful melodies."
	icon_state = "lute"
	song_list = list("A Knight's Return" = 'sound/music/instruments/lute (1).ogg',
	"Amongst Fare Friends" = 'sound/music/instruments/lute (2).ogg',
	"The Road Traveled by Few" = 'sound/music/instruments/lute (3).ogg',
	"Tip Thine Tankard" = 'sound/music/instruments/lute (4).ogg',
	"A Reed On the Wind" = 'sound/music/instruments/lute (5).ogg',
	"Jests On Steel Ears" = 'sound/music/instruments/lute (6).ogg',
	"Merchant in the Mire" = 'sound/music/instruments/lute (7).ogg',
	"The Power" = 'modular_azurepeak/sound/music/instruments/lute (8).ogg', //Baldur's Gate 3 Song
	"Bard Dance" = 'modular_azurepeak/sound/music/instruments/lute (9).ogg', //Baldur's Gate 3 Song
	"Old Time Battles" = 'modular_azurepeak/sound/music/instruments/lute (10).ogg') //Baldur's Gate 3 Song

/obj/item/rogue/instrument/psyaltery
	name = "psyaltery"
	desc = "A traditional form of boxed zither or box-harp that may be played plucked, with a plectrum or with hammers. They are particularly associated with divine beings, aasimars and liturgies."
	icon_state = "psyaltery"
	song_list = list(
	"Disciples Tower" = 'sound/music/instruments/psyaltery (1).ogg',
	"Green Sleeves" = 'sound/music/instruments/psyaltery (2).ogg',
	"Midyear Melancholy" = 'sound/music/instruments/psyaltery (3).ogg',
	"Santa Psydonia" = 'sound/music/instruments/psyaltery (4).ogg',
	"Le Venardine" = 'sound/music/instruments/psyaltery (5).ogg',
	"Azurea Fair" = 'sound/music/instruments/psyaltery (6).ogg',
	"Amoroso" = 'sound/music/instruments/psyaltery (7).ogg',
	"Lupian's Lullaby" = 'sound/music/instruments/psyaltery (8).ogg',
	"White Wine Before Breakfast" = 'sound/music/instruments/psyaltery (9).ogg',
	"Chevalier de Naledi" = 'sound/music/instruments/psyaltery (10).ogg')

/obj/item/rogue/instrument/shamisen
	name = "shamisen"
	desc = "The shamisen, or simply «three strings», is an kazengunese stringed instrument with a washer, which is usually played with the help of a bachi."
	icon_state = "shamisen"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	song_list = list(
	"A Rambling Tongue" = 'sound/music/instruments/shamisen A Rambling Tongue.ogg',
	"Ashitaka" = 'sound/music/instruments/shamisen The Legend of Ashitaka.ogg',
	"Daimyo Dreamwalker" = 'sound/music/instruments/shamisen Daimyo Dreamwalker.ogg',
	"Emperor of Flame" = 'sound/music/instruments/shamisen Emperor of Flame.ogg',
	"Fire Phoenix" = 'sound/music/instruments/shamisen Fire Phoenix.ogg',
	"Kaiju Islands" = 'sound/music/instruments/shamisen Kaiju Islands.ogg',
	"Lavender Village" = 'sound/music/instruments/shamisen Lavender Village.ogg',
	"Morning Is Coming" = 'sound/music/instruments/shamisen Morning is Coming.ogg',
	"Pouncing Shadow" = 'sound/music/instruments/shamisen Pouncing Shadow.ogg',
	"Rising Sun" = 'sound/music/instruments/shamisen Rising Sun.ogg',
	"Those Who Fight" = 'sound/music/instruments/shamisen Those Who Fight.ogg',
	"Village in the Mountains" = 'sound/music/instruments/shamisen Village in the Mountains.ogg',
	"Winning the Soul" = 'sound/music/instruments/shamisen Winning the Soul.ogg',
	"Cursed Apple" = 'sound/music/instruments/shamisen (1).ogg',
	"Fire Dance" = 'sound/music/instruments/shamisen (2).ogg',
	"Lute" = 'sound/music/instruments/shamisen (3).ogg',
	"Tsugaru Ripple" = 'sound/music/instruments/shamisen (4).ogg',
	"Tsugaru" = 'sound/music/instruments/shamisen (5).ogg',
	"Season" = 'sound/music/instruments/shamisen (6).ogg',
	"Parade" = 'sound/music/instruments/shamisen (7).ogg',
	"Koshiro" = 'sound/music/instruments/shamisen (8).ogg')

/obj/item/rogue/instrument/vocals/harpy_vocals
	name = "harpy's song"
	desc = "The blessed essence of harpysong. How did you get this... you monster!"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "harpysong"		//Pulsating heart energy thing.
	not_held = TRUE

/obj/item/rogue/instrument/trumpet
	name = "trumpet"
	desc = "A long brass tube twisted around with a flared end. It has a few valves to press on the top."
	icon_state = "trumpet"
	song_list = list("Royal Entrance" = 'sound/music/instruments/trumpet (1).ogg',
	"Royal Exit" = 'sound/music/instruments/trumpet (2).ogg',
	"Royal News" = 'sound/music/instruments/trumpet (3).ogg',
	"Royal Fanfare" = 'sound/music/instruments/trumpet (4).ogg',
	"Royal Fanfare 2" = 'sound/music/instruments/trumpet (5).ogg',
	"Royal Wedding" = 'sound/music/instruments/trumpet (6).ogg', //It has a little bit of organ in the background that I couldn't completely remove
	"Honoring the Fallen" = 'sound/music/instruments/trumpet (7).ogg')

/obj/item/rogue/instrument/bagpipe
	name = "bagpipe"
	desc = "A commonly used woodwind instrument using enclosed reeds fed from a constant reservoir of air in the form of a bag."
	grid_width = 64
	grid_height = 32
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "bagpipe"
	song_list = list("Dainty Man" = 'sound/music/instruments/bagpipe (1).ogg',
	"Harpy in the Morning" = 'sound/music/instruments/bagpipe (2).ogg',
	"Heartfelt Forever" = 'sound/music/instruments/bagpipe (3).ogg',
	"Homeward Jig" = 'sound/music/instruments/bagpipe (4).ogg',
	"On the Sea Shore" = 'sound/music/instruments/bagpipe (5).ogg',
	"Soldier's Rest" = 'sound/music/instruments/bagpipe (6).ogg',
	"Otavan Madame" = 'sound/music/instruments/bagpipe (7).ogg')

/obj/item/rogue/instrument/banjo
	name = "banjo"
	desc = "A stringed instrument with a thin membrane stretched over a circular-bodied frame, typically played by plucking or strumming. It has a certain twangy sound commonly heard in folk music."
	grid_width = 64
	grid_height = 32
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "banjo"
	song_list = list("Bog Man's Jig" = 'sound/music/instruments/banjo (1).ogg',
	"Pockets Full o' Mammon" = 'sound/music/instruments/banjo (2).ogg',
	"Kickin' the Muck Off" = 'sound/music/instruments/banjo (3).ogg',
	"Soggy Shoes n' Bilgewater Boots" = 'sound/music/instruments/banjo (4).ogg',
	"Nothin' but Fog" = 'sound/music/instruments/banjo (5).ogg',
	"The Tipsy Toad" = 'sound/music/instruments/banjo (6).ogg',
	"Tangled in th' Reeds" = 'sound/music/instruments/banjo (7).ogg')

/obj/item/rogue/instrument/harmonica
	name = "harmonica"
	desc = "A small, rectangular wind instrument played by blowing air through reeds."
	grid_width = 32
	grid_height = 32
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "harmonica"
	song_list = list("Deep in the Peat" = 'sound/music/instruments/harmonica (1).ogg',
	"Militia Man's Woes" = 'sound/music/instruments/harmonica (2).ogg',
	"My Chilly Bones" = 'sound/music/instruments/harmonica (3).ogg',
	"Lonesome by the Campfire" = 'sound/music/instruments/harmonica (4).ogg',
	"Herding in the Heat" = 'sound/music/instruments/harmonica (5).ogg',
	"Soaked to the Bone" = 'sound/music/instruments/harmonica (6).ogg',
	"To Our Friends Felled" = 'sound/music/instruments/harmonica (7).ogg')

/obj/item/rogue/instrument/jawharp
	name = "jaw harp"
	desc = "A vibrating reed attached to a sturdy frame, originally crafted in the Gronn Steppes. It produces a buzzing sound that mimics the winds of the plains."
	dropshrink = 0.6
	grid_width = 32
	grid_height = 32
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "jawharp"
	song_list = list("Fly Away" = 'sound/music/instruments/jawharp (1).ogg',
	"Nomad's Call" = 'sound/music/instruments/jawharp (2).ogg',
	"Spirit of the Steppes" = 'sound/music/instruments/jawharp (3).ogg',
	"The Mountain of Wisdom" = 'sound/music/instruments/jawharp (4).ogg',
	"Who Told You" = 'sound/music/instruments/jawharp (5).ogg')
/obj/item/rogue/instrument/jawharp/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.2,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 1,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 110,"sturn" = -110,"wturn" = -110,"eturn" = 110,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.1,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogue/instrument/viola
	name = "viola"
	desc = "The prim and proper Viola, every prince's first instrument taught."
	icon_state = "viola"
	song_list = list("Far Flung Tale" = 'sound/music/instruments/viola (1).ogg',
	"G Major Cello Suite No. 1" = 'sound/music/instruments/viola (2).ogg',
	"Ursine's Home" = 'sound/music/instruments/viola (3).ogg',
	"Mead, Gold and Blood" = 'sound/music/instruments/viola (4).ogg',
	"Gasgow's Reel" = 'sound/music/instruments/viola (5).ogg',
	"The Power" = 'sound/music/instruments/viola (6).ogg', //BG3 Song, I KNOW THIS ISNT A VIOLIN, LEAVE ME ALONE
	"Bard Dance" = 'sound/music/instruments/viola (7).ogg', // BG3 Song
	"Old Time Battles" = 'sound/music/instruments/viola (8).ogg') // BG3 Song


/obj/item/rogue/instrument/vocals
	name = "vocalist's talisman"
	desc = "This talisman emanates a soft shimmer of light. When held, it can amplify and even change a bard's voice."
	icon_state = "vtalisman"
	song_list = list("Harpy's Call (Feminine)" = 'sound/music/instruments/vocalsf (1).ogg',
	"Necra's Lullaby (Feminine)" = 'sound/music/instruments/vocalsf (2).ogg',
	"Death Touched Aasimar (Feminine)" = 'sound/music/instruments/vocalsf (3).ogg',
	"Our Mother, Our Divine (Feminine)" = 'sound/music/instruments/vocalsf (4).ogg',
	"Wed, Forever More (Feminine)" = 'sound/music/instruments/vocalsf (5).ogg',
	"Paper Boats (Feminine + Vocals)" = 'sound/music/instruments/vocalsf (6).ogg',
	"The Dragon's Blood Surges (Masculine)" = 'sound/music/instruments/vocalsm (1).ogg',
	"Timeless Temple (Masculine)" = 'sound/music/instruments/vocalsm (2).ogg',
	"Angel's Earnt Halo (Masculine)" = 'sound/music/instruments/vocalsm (3).ogg',
	"A Fabled Choir (Masculine)" = 'sound/music/instruments/vocalsm (4).ogg',
	"A Pained Farewell (Masculine + Feminine)" = 'sound/music/instruments/vocalsx (1).ogg',
	"The Power (Whistling)" = 'sound/music/instruments/vocalsx (2).ogg',
	"Bard Dance (Whistling)" = 'sound/music/instruments/vocalsx (3).ogg',
	"Old Time Battles (Whistling)" = 'sound/music/instruments/vocalsx (4).ogg')
