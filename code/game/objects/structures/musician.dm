
#define MUSICIAN_HEARCHECK_MINDELAY 4
#define MUSIC_MAXLINES 300
#define MUSIC_MAXLINECHARS 50

/datum/song
	var/name = "未命名"
	var/list/lines = new()
	var/tempo = 5			// delay between notes

	var/playing = 0			// if we're playing
	var/help = 0			// if help is open
	var/edit = 1			// if we're in editing mode
	var/repeat = 0			// number of times remaining to repeat
	var/max_repeats = 10	// maximum times we can repeat

	var/instrumentDir = "piano"		// the folder with the sounds
	var/instrumentExt = "ogg"		// the file extension
	var/obj/instrumentObj = null	// the associated obj playing the sound
	var/last_hearcheck = 0
	var/list/hearing_mobs

/datum/song/New(dir, obj, ext = "ogg")
	tempo = sanitize_tempo(tempo)
	instrumentDir = dir
	instrumentObj = obj
	instrumentExt = ext

/datum/song/Destroy()
	instrumentObj = null
	return ..()

// note is a number from 1-7 for A-G
// acc is either "b", "n", or "#"
// oct is 1-8 (or 9 for C)
/datum/song/proc/playnote(mob/user, note, acc as text, oct)
	// handle accidental -> B<>C of E<>F
	if(acc == "b" && (note == 3 || note == 6)) // C or F
		if(note == 3)
			oct--
		note--
		acc = "n"
	else if(acc == "#" && (note == 2 || note == 5)) // B or E
		if(note == 2)
			oct++
		note++
		acc = "n"
	else if(acc == "#" && (note == 7)) //G#
		note = 1
		acc = "b"
	else if(acc == "#") // mass convert all sharps to flats, octave jump already handled
		acc = "b"
		note++

	// check octave, C is allowed to go to 9
	if(oct < 1 || (note == 3 ? oct > 9 : oct > 8))
		return

	// now generate name
	var/soundfile = "sound/instruments/[instrumentDir]/[ascii2text(note+64)][acc][oct].[instrumentExt]"
	soundfile = file(soundfile)
	// make sure the note exists
	if(!fexists(soundfile))
		return
	// and play
	var/turf/source = get_turf(instrumentObj)
	if((world.time - MUSICIAN_HEARCHECK_MINDELAY) > last_hearcheck)
		LAZYCLEARLIST(hearing_mobs)
		for(var/mob/M in get_hearers_in_view(15, source))
			LAZYADD(hearing_mobs, M)
		last_hearcheck = world.time

	var/sound/music_played = sound(soundfile)
	for(var/i in hearing_mobs)
		var/mob/M = i
		if(HAS_TRAIT(user, TRAIT_MUSICIAN) && isliving(M))
			var/mob/living/L = M
			L.apply_status_effect(STATUS_EFFECT_GOOD_MUSIC)
		if(!M.client || !(M.client.prefs.toggles & SOUND_INSTRUMENTS))
			continue
		M.playsound_local(source, null, 100, falloff = 5, S = music_played)

/datum/song/proc/updateDialog(mob/user)
	instrumentObj.updateDialog()		// assumes it's an object in world, override if otherwise

/datum/song/proc/shouldStopPlaying(mob/user)
	if(instrumentObj)
		if(!user.canUseTopic(instrumentObj, BE_CLOSE, FALSE, NO_TK))
			return TRUE
		return !instrumentObj.anchored		// add special cases to stop in subclasses
	else
		return TRUE

/datum/song/proc/playsong(mob/user)
	while(repeat >= 0)
		var/cur_oct[7]
		var/cur_acc[7]
		for(var/i = 1 to 7)
			cur_oct[i] = 3
			cur_acc[i] = "n"

		for(var/line in lines)
			for(var/beat in splittext(LOWER_TEXT(line), ","))
				var/list/notes = splittext(beat, "/")
				for(var/note in splittext(notes[1], "-"))
					if(!playing || shouldStopPlaying(user))//If the instrument is playing, or special case
						playing = FALSE
						hearing_mobs = null
						return
					if(!length(note))
						continue
					var/cur_note = text2ascii(note) - 96
					if(cur_note < 1 || cur_note > 7)
						continue
					for(var/i=2 to length(note))
						var/ni = copytext(note,i,i+1)
						if(!text2num(ni))
							if(ni == "#" || ni == "b" || ni == "n")
								cur_acc[cur_note] = ni
							else if(ni == "s")
								cur_acc[cur_note] = "#" // so shift is never required
						else
							cur_oct[cur_note] = text2num(ni)
					if(user.dizziness > 0 && prob(user.dizziness / 2))
						cur_note = CLAMP(cur_note + rand(round(-user.dizziness / 10), round(user.dizziness / 10)), 1, 7)
					if(user.dizziness > 0 && prob(user.dizziness / 5))
						if(prob(30))
							cur_acc[cur_note] = "#"
						else if(prob(42))
							cur_acc[cur_note] = "b"
						else if(prob(75))
							cur_acc[cur_note] = "n"
					playnote(user, cur_note, cur_acc[cur_note], cur_oct[cur_note])
				if(notes.len >= 2 && text2num(notes[2]))
					sleep(sanitize_tempo(tempo / text2num(notes[2])))
				else
					sleep(tempo)
		repeat--
	hearing_mobs = null
	playing = FALSE
	repeat = 0
	updateDialog(user)

/datum/song/proc/interact(mob/user)
	var/dat = ""

	if(lines.len > 0)
		dat += "<H3>播放</H3>"
		if(!playing)
			dat += "<A href='?src=[REF(src)];play=1'>播放</A> <SPAN CLASS='linkOn'>停止</SPAN><BR><BR>"
			dat += "重复曲目："
			dat += repeat > 0 ? "<A href='?src=[REF(src)];repeat=-10'>-</A><A href='?src=[REF(src)];repeat=-1'>-</A>" : "<SPAN CLASS='linkOff'>-</SPAN><SPAN CLASS='linkOff'>-</SPAN>"
			dat += " [repeat] 次 "
			dat += repeat < max_repeats ? "<A href='?src=[REF(src)];repeat=1'>+</A><A href='?src=[REF(src)];repeat=10'>+</A>" : "<SPAN CLASS='linkOff'>+</SPAN><SPAN CLASS='linkOff'>+</SPAN>"
			dat += "<BR>"
		else
			dat += "<SPAN CLASS='linkOn'>播放</SPAN> <A href='?src=[REF(src)];stop=1'>停止</A><BR>"
			dat += "剩余重复次数：<B>[repeat]</B><BR>"
	if(!edit)
		dat += "<BR><B><A href='?src=[REF(src)];edit=2'>显示编辑器</A></B><BR>"
	else
		dat += "<H3>编辑</H3>"
		dat += "<B><A href='?src=[REF(src)];edit=1'>隐藏编辑器</A></B>"
		dat += " <A href='?src=[REF(src)];newsong=1'>开始新曲</A>"
		dat += " <A href='?src=[REF(src)];import=1'>导入曲谱</A><BR><BR>"
		var/bpm = round(600 / tempo)
		dat += "速度：<A href='?src=[REF(src)];tempo=[world.tick_lag]'>-</A> [bpm] 拍/分钟 <A href='?src=[REF(src)];tempo=-[world.tick_lag]'>+</A><BR><BR>"
		var/linecount = 0
		for(var/line in lines)
			linecount += 1
			dat += "第[linecount]行：<A href='?src=[REF(src)];modifyline=[linecount]'>编辑</A> <A href='?src=[REF(src)];deleteline=[linecount]'>X</A> [line]<BR>"
		dat += "<A href='?src=[REF(src)];newline=1'>新增一行</A><BR><BR>"
		if(help)
			dat += "<B><A href='?src=[REF(src)];help=1'>隐藏帮助</A></B><BR>"
			dat += {"
					每一行由一串和弦组成，和弦之间用逗号 (,) 分隔，每个和弦中的音符用连字符 (-) 分隔。<br>
					同一和弦中的所有音符会同时演奏，和弦时值由当前速度决定。<br>
					<br>
					音符通过音名表示，也可以额外写上升降号和八度数字。<br>
					默认情况下，每个音都是 3 组的自然音；若你改过某个音，它会记住这个设定。<br>
					例如：<i>C,D,E,F,G,A,B</i> 会演奏一段 C 大调音阶。<br>
					音符一旦加上升降号，就会被记住：<i>C,C4,C,C3</i> 实际上是 <i>C3,C4,C4,C3</i><br>
					和弦只需用连字符连接各个音符即可：<i>A-C#,Cn-E,E-G#,Gn-B</i><br>
					空和弦代表停顿：<i>C,E,,C,G</i><br>
					若想让某个和弦时值不同，可在结尾写上 /x，和弦时值会变成速度 / x：<i>C,G/2,E/4</i><br>
					综合示例：<i>E-E4/4,F#/2,G#/8,B/8,E3-E4/4</i>
					<br>
					每一行最多可有 [MUSIC_MAXLINECHARS] 个字符。<br>
					一首曲子最多只能包含 [MUSIC_MAXLINES] 行。<br>
					"}
		else
			dat += "<B><A href='?src=[REF(src)];help=2'>显示帮助</A></B><BR>"

	var/datum/browser/popup = new(user, "instrument", instrumentObj.name, 700, 500)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(instrumentObj.icon, instrumentObj.icon_state))
	popup.open()

/datum/song/proc/ParseSong(text)
	set waitfor = FALSE
	//split into lines
	lines = splittext(text, "\n")
	if(lines.len)
		if(copytext(lines[1],1,6) == "BPM: ")
			tempo = sanitize_tempo(600 / text2num(copytext(lines[1],6)))
			lines.Cut(1,2)
		else
			tempo = sanitize_tempo(5) // default 120 BPM
		if(lines.len > MUSIC_MAXLINES)
			to_chat(usr, "行数太多！")
			lines.Cut(MUSIC_MAXLINES + 1)
		var/linenum = 1
		for(var/l in lines)
			if(length(l) > MUSIC_MAXLINECHARS)
				to_chat(usr, "第[linenum]行太长了！")
				lines.Remove(l)
			else
				linenum++
		updateDialog(usr)		// make sure updates when complete

/datum/song/Topic(href, href_list)
	if(!usr.canUseTopic(instrumentObj, BE_CLOSE, FALSE, NO_TK))
		usr << browse(null, "window=instrument")
		usr.unset_machine()
		return

	instrumentObj.add_fingerprint(usr)

	if(href_list["newsong"])
		lines = new()
		tempo = sanitize_tempo(5) // default 120 BPM
		name = ""

	else if(href_list["import"])
		var/t = ""
		do
			t = html_encode(input(usr, "请粘贴整首曲谱，按规定格式输入：", text("[]", name), t)  as message)
			if(!usr.canUseTopic(instrumentObj, BE_CLOSE, FALSE, NO_TK))
				return

			if(length(t) >= MUSIC_MAXLINES * MUSIC_MAXLINECHARS)
				var/cont = input(usr, "你的输入太长了！还要继续编辑吗？", "", "继续") in list("继续", "取消")
				if(!usr.canUseTopic(instrumentObj, BE_CLOSE, FALSE, NO_TK))
					return
				if(cont == "取消")
					break
		while(length(t) > MUSIC_MAXLINES * MUSIC_MAXLINECHARS)
		ParseSong(t)

	else if(href_list["help"])
		help = text2num(href_list["help"]) - 1

	else if(href_list["edit"])
		edit = text2num(href_list["edit"]) - 1

	if(href_list["repeat"]) //Changing this from a toggle to a number of repeats to avoid infinite loops.
		if(playing)
			return //So that people cant keep adding to repeat. If the do it intentionally, it could result in the server crashing.
		repeat += round(text2num(href_list["repeat"]))
		if(repeat < 0)
			repeat = 0
		if(repeat > max_repeats)
			repeat = max_repeats

	else if(href_list["tempo"])
		tempo = sanitize_tempo(tempo + text2num(href_list["tempo"]))

	else if(href_list["play"])
		playing = TRUE
		INVOKE_ASYNC(src, PROC_REF(playsong), usr)

	else if(href_list["newline"])
		var/newline = html_encode(input("输入这一行：", instrumentObj.name) as text|null)
		if(!newline || !usr.canUseTopic(instrumentObj, BE_CLOSE, FALSE, NO_TK))
			return
		if(lines.len > MUSIC_MAXLINES)
			return
		if(length(newline) > MUSIC_MAXLINECHARS)
			newline = copytext(newline, 1, MUSIC_MAXLINECHARS)
		lines.Add(newline)

	else if(href_list["deleteline"])
		var/num = round(text2num(href_list["deleteline"]))
		if(num > lines.len || num < 1)
			return
		lines.Cut(num, num+1)

	else if(href_list["modifyline"])
		var/num = round(text2num(href_list["modifyline"]),1)
		var/content = html_encode(input("输入这一行：", instrumentObj.name, lines[num]) as text|null)
		if(!content || !usr.canUseTopic(instrumentObj, BE_CLOSE, FALSE, NO_TK))
			return
		if(length(content) > MUSIC_MAXLINECHARS)
			content = copytext(content, 1, MUSIC_MAXLINECHARS)
		if(num > lines.len || num < 1)
			return
		lines[num] = content

	else if(href_list["stop"])
		playing = FALSE
		hearing_mobs = null

	updateDialog(usr)
	return

/datum/song/proc/sanitize_tempo(new_tempo)
	new_tempo = abs(new_tempo)
	return max(round(new_tempo, world.tick_lag), world.tick_lag)

// subclass for handheld instruments, like violin
/datum/song/handheld

/datum/song/handheld/updateDialog(mob/user)
	instrumentObj.interact(user)

/datum/song/handheld/shouldStopPlaying()
	if(instrumentObj)
		return !isliving(instrumentObj.loc)
	else
		return TRUE


//////////////////////////////////////////////////////////////////////////


/obj/structure/piano
	name = "迷你魔音琴"
	icon = 'icons/obj/musician.dmi'
	icon_state = "minimoog"
	anchored = TRUE
	density = TRUE
	var/datum/song/song

/obj/structure/piano/unanchored
	anchored = FALSE

/obj/structure/piano/Initialize(mapload)
	. = ..()
	song = new("piano", src)

	if(prob(50) && icon_state == initial(icon_state))
		name = "迷你魔音琴"
		desc = ""
		icon_state = "minimoog"
	else
		name = "钢琴"
		desc = ""
		icon_state = "piano"

/obj/structure/piano/Destroy()
	qdel(song)
	song = null
	return ..()

/obj/structure/piano/Initialize(mapload)
	. = ..()
	if(mapload)
		song.tempo = song.sanitize_tempo(song.tempo) // tick_lag isn't set when the map is loaded

/obj/structure/piano/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	interact(user)

/obj/structure/piano/interact(mob/user)
	if(!user || !anchored)
		return

	if(!user.IsAdvancedToolUser())
		to_chat(user, span_warning("我的手还不够灵巧，做不了这事！"))
		return 1
	user.set_machine(src)
	song.interact(user)

/obj/structure/piano/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I, 40)
	return TRUE
