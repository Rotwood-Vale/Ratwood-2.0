/datum/looping_sound/musloop
	mid_sounds = list()
	mid_length = 2400 // Whoever wrote this is giving me an aneurism
	volume = 70
	extra_range = 8
	falloff = 0
	persistent_loop = TRUE
	var/stress2give = /datum/stressevent/music
	channel = CHANNEL_JUKEBOX

/datum/looping_sound/musloop/on_hear_sound(mob/M)
	. = ..()
	if(stress2give)
		if(isliving(M))
			var/mob/living/carbon/L = M
			L.add_stress(stress2give)

/obj/structure/roguemachine/musicbox
	name = "蜡筒音乐机"
	desc = "一台为了记录布道而发明的奇妙装置。它如今为我们带来了来自异界的奇异音乐。"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "music0"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	var/datum/looping_sound/musloop/soundloop
	var/list/init_curfile = list('sound/music/jukeboxes/gen/tavern1.ogg') // A list of songs that curfile is set to on init. MUST BE IN ONE OF THE MUSIC_TAVCAT_'s.
	var/curfile // The current track that is playing right now
	var/playing = FALSE // If music is playing or not. playmusic() deals with this don't mess with it.
	var/curvol = 50 // The current volume at which audio is played. MAPPERS MAY TOUCH THIS.
	var/playuponspawn = FALSE // Does the music box start playing music when it first spawns in? MAPPERS MAY TOUCH THIS.
	var/list/static/songlist_otherworldly = list(
		"Lore" = 'sound/music/jukeboxes/otherworld/ac-ler.ogg',
		"Landmarks of Lullabies" = 'sound/music/jukeboxes/otherworld/ac-lol.ogg',
		"Waters of Sacrifice" = 'sound/music/jukeboxes/otherworld/acn-wos.ogg',
		"Solar Wind" = 'sound/music/jukeboxes/otherworld/av_solar.ogg',
		"Balthasar" = 'sound/music/jukeboxes/otherworld/ac-balthasar.ogg',
		"Dead Windmills" = 'sound/music/jukeboxes/otherworld/dead_windmills.ogg',
		"In Heaven Everythin" = 'sound/music/jukeboxes/otherworld/in_heaven_eif.ogg',
		"Jazznocn" = 'sound/music/jukeboxes/otherworld/jazznocn.ogg',
		"Vivalaluna-Damla" = 'sound/music/jukeboxes/otherworld/vivalaluna-damla.ogg',
		"Shades of Futility" = 'sound/music/jukeboxes/otherworld/fb-sofutile.ogg',
		"Mr Doubt" = 'sound/music/jukeboxes/otherworld/mr_doubt.ogg'
	)
	var/list/static/songlist_generic = list(\
		"Song 1" = 'sound/music/jukeboxes/gen/tavern1.ogg',
		"Song 2" = 'sound/music/jukeboxes/gen/tavern2.ogg',
		"Song 3" = 'sound/music/jukeboxes/gen/tavern3.ogg'
	)
	var/list/static/songlist_oldschool = list(\
		"Autumn Voyage" = 'sound/music/jukeboxes/oldschool/Autumn_Voyage.ogg',
		"Fanfare" = 'sound/music/jukeboxes/oldschool/Fanfare.ogg',
		"Greatness" = 'sound/music/jukeboxes/oldschool/Greatness.ogg',
		"Medieval" = 'sound/music/jukeboxes/oldschool/Medieval.ogg',
		"Sea Shanty2" = 'sound/music/jukeboxes/oldschool/Sea_Shanty2.ogg',
		"Shine" = 'sound/music/jukeboxes/oldschool/Shine.ogg',
		"Spirit" = 'sound/music/jukeboxes/oldschool/Spirit.ogg',
		"Still Night" = 'sound/music/jukeboxes/oldschool/Still_Night.ogg',
		"Venture" = 'sound/music/jukeboxes/oldschool/Venture.ogg',
		"Yesteryear" = 'sound/music/jukeboxes/oldschool/Yesteryear.ogg'
	)

/obj/structure/roguemachine/musicbox/Initialize(mapload)
	. = ..()
	curfile = pick(init_curfile)
	soundloop = new(src, FALSE)
	if(playuponspawn)
		start_playing()

/obj/structure/roguemachine/musicbox/Destroy()
	. = ..()
	qdel(soundloop) //jesus fuck who is using hard dels in this day and age

/obj/structure/roguemachine/musicbox/update_icon()
	icon_state = "music[playing]"

/obj/structure/roguemachine/musicbox/proc/toggle_music()
	if(!playing)
		start_playing()
	else
		stop_playing()

/obj/structure/roguemachine/musicbox/proc/start_playing()
	playing = TRUE
	soundloop.set_mid_sounds(list(curfile))
	soundloop.volume = curvol
	soundloop.start()
	testing("Music: V[soundloop.volume] C[soundloop.cursound] T[soundloop.thingshearing]")
	update_icon()

/obj/structure/roguemachine/musicbox/proc/stop_playing()
	playing = FALSE
	soundloop.stop()
	update_icon()

/obj/structure/roguemachine/musicbox/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return

	user.changeNext_move(CLICK_CD_INTENTCAP)

	var/button_selection = input(user, "我要按哪个按钮？", "[src]") as null | anything in list("停止/开始","更换曲目","调节音量")
	if(!Adjacent(user))
		return
	if(!button_selection)
		to_chat(user, span_info("我改变主意了……"))
		return
	user.visible_message(span_info("[user]按下了[src]上的一个按钮。"),span_info("我按下了[src]上的一个按钮。"))
	playsound(loc, pick('sound/misc/keyboard_select (1).ogg','sound/misc/keyboard_select (2).ogg','sound/misc/keyboard_select (3).ogg','sound/misc/keyboard_select (4).ogg'), 100, FALSE, -1)

	if(button_selection=="停止/开始")
		toggle_music()

	if(button_selection=="更换曲目")
		var/songlists_selection = input(user, "选择哪一组曲目？", "[src]") as null | anything in list("异界", "通用", "旧式")
		playsound(loc, pick('sound/misc/keyboard_select (1).ogg','sound/misc/keyboard_select (2).ogg','sound/misc/keyboard_select (3).ogg','sound/misc/keyboard_select (4).ogg'), 100, FALSE, -1)
		user.visible_message(span_info("[user]按下了[src]上的一个按钮。"),span_info("我按下了[src]上的一个按钮。"))
		var/chosen_songlists_selection = null
		switch(songlists_selection)
			if("异界")
				chosen_songlists_selection = songlist_otherworldly
			if("通用")
				chosen_songlists_selection = songlist_generic
			if("旧式")
				chosen_songlists_selection = songlist_oldschool
		var/song_selection = input(user, "我要播放哪首曲子？", "[src]") as null | anything in chosen_songlists_selection
		if(!Adjacent(user))
			return
		if(!song_selection)
			to_chat(user, span_info("我改变主意了……"))
			return
		playsound(loc, pick('sound/misc/keyboard_select (1).ogg','sound/misc/keyboard_select (2).ogg','sound/misc/keyboard_select (3).ogg','sound/misc/keyboard_select (4).ogg'), 100, FALSE, -1)
		user.visible_message(span_info("[user]按下了[src]上的一个按钮。"),span_info("我按下了[src]上的一个按钮。"))
		curfile = chosen_songlists_selection[song_selection]
		stop_playing()
		start_playing()

	if(button_selection=="调节音量")
		var/volume_selection = input(user, "你想把音量调到多大？", "[src]（当前音量：[curvol]/[100]）") as num|null
		if(!Adjacent(user))
			return
		if(!volume_selection)
			to_chat(user, span_info("我改变主意了……"))
			return
		if(volume_selection == curvol)
			to_chat(user, span_info("旋钮本来就在这个音量上！"))
			return
		playsound(loc, pick('sound/misc/keyboard_select (1).ogg','sound/misc/keyboard_select (2).ogg','sound/misc/keyboard_select (3).ogg','sound/misc/keyboard_select (4).ogg'), 100, FALSE, -1)
		user.visible_message(span_info("[user]按下了[src]上的一个按钮。"),span_info("我按下了[src]上的一个按钮。"))
		volume_selection = clamp(volume_selection, 1, 100)
		if(curvol<volume_selection)
			to_chat(user, span_info("我把[src]调得更响了。"))
		else
			to_chat(user, span_info("我把[src]调得更轻了。"))
		curvol = volume_selection
		stop_playing()
		start_playing()

/obj/structure/roguemachine/musicbox/tavern
	init_curfile = list(
		'sound/music/jukeboxes/gen/tavern1.ogg',
		'sound/music/jukeboxes/gen/tavern2.ogg',
		'sound/music/jukeboxes/gen/tavern3.ogg',
		'sound/music/jukeboxes/otherworld/ac-lol.ogg',
		'sound/music/jukeboxes/otherworld/ac-balthasar.ogg',
		'sound/music/jukeboxes/otherworld/vivalaluna-damla.ogg',
	)
	curvol = 65
	playuponspawn = TRUE
/* The fuck is this
/obj/structure/roguemachine/musicbox/Initialize(mapload)
	. = ..()
	soundloop.extra_range = 12
	soundloop.falloff = 6
*/
