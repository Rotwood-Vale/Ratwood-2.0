// Bardic Inspo time - Datum/definition setup

#define BARD_T1 1
#define BARD_T2 2
#define BARD_T3 3
#define BARD_RESET_COOLDOWN 2 MINUTES

GLOBAL_LIST_INIT(learnable_songs, (list(/obj/effect/proc_holder/spell/invoked/song/dirge_fortune,
		/obj/effect/proc_holder/spell/invoked/song/discordant_dirge,
		/obj/effect/proc_holder/spell/invoked/song/furtive_fortissimo,
		/obj/effect/proc_holder/spell/invoked/song/intellectual_interval,
		/obj/effect/proc_holder/spell/invoked/song/resolute_refrain,
		/obj/effect/proc_holder/spell/invoked/song/recovery_song,
		/obj/effect/proc_holder/spell/invoked/song/fervor_song,
		/obj/effect/proc_holder/spell/invoked/song/pestilent_piedpiper,
		/obj/effect/proc_holder/spell/invoked/song/rejuvenation_song,
		/obj/effect/proc_holder/spell/invoked/song/accelakathist,
		)
))

GLOBAL_LIST_INIT(learnable_rhythms, (list(/obj/effect/proc_holder/spell/self/rhythm/resonating,
		/obj/effect/proc_holder/spell/self/rhythm/concussive,
		/obj/effect/proc_holder/spell/self/rhythm/regenerating,
		/obj/effect/proc_holder/spell/self/rhythm/malaise,
		)
))


/datum/inspiration
	var/mob/living/carbon/human/holder
	var/level = BARD_T1
	var/maxaudience = 2
	var/list/audience = list()
	var/maxsongs = BARD_T1 + 1
	var/songsbought = 0
	var/maxrhythms = 0
	var/rhythmsbought = 0
	var/datum/rhythm_tracker/rhythm_tracker
	var/is_picking = FALSE // mutex
	var/is_picking_rhythm = FALSE
	var/next_song_reset = 0
	var/next_rhythm_reset = 0

/datum/inspiration/Destroy(force)
	. = ..()
	holder?.inspiration = null
	holder = null
	QDEL_NULL(rhythm_tracker)
	STOP_PROCESSING(SSobj, src)



/mob/living/carbon/human/proc/in_audience(mob/living/carbon/human/audiencee)
	if(!src.mind)
		return FALSE
	if(!src.inspiration)
		return FALSE
		
	if(audiencee in src.inspiration.audience)
		return TRUE
	else
		return FALSE


/datum/inspiration/proc/grant_inspiration(mob/living/carbon/human/H, bard_tier)
	if(!H || !H.mind)
		return
	level = bard_tier
	maxaudience = 2*bard_tier
	maxsongs = bard_tier + 2
	if(bard_tier >= BARD_T2)
		maxrhythms = bard_tier
		if(!rhythm_tracker)
			rhythm_tracker = new
		H.verbs += list(/mob/living/carbon/human/proc/pickrhythms, /mob/living/carbon/human/proc/resetrhythms)
	if(bard_tier >= BARD_T3 && !H.mind.has_spell(/obj/effect/proc_holder/spell/self/crescendo))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/crescendo)
	H.verbs += list(/mob/living/carbon/human/proc/setaudience, /mob/living/carbon/human/proc/clearaudience, /mob/living/carbon/human/proc/checkaudience, /mob/living/carbon/human/proc/picksongs, /mob/living/carbon/human/proc/resetsongs)




/mob/living/carbon/human/proc/setaudience()
	set name = "Audience Choice"
	set category = "Inspiration"

	if(!inspiration)
		return FALSE
	if(inspiration.audience.len >= inspiration.maxaudience)
		to_chat(src, "I cannot maintain a audience larger than [inspiration.maxaudience]!")
		return FALSE
	var/list/folksnearby = list()
	for(var/mob/living/carbon/human/folks in view(7, loc))
		if(!src.in_audience(folks))
			folksnearby += folks

	if(!folksnearby)
		return
	var/target = tgui_input_list(src, "Who will you perform for?", "Audience Choice", folksnearby)
	if(target)
		inspiration.audience |= target


	return TRUE


/mob/living/carbon/human/proc/clearaudience()
	set name = "Clear Audience"
	set category = "Inspiration"
	if(!inspiration)
		return FALSE
	if(src.has_status_effect(/datum/status_effect/buff/playing_music)) // cant clear while playing
		return
	inspiration.audience = list()

	return TRUE


/mob/living/carbon/human/proc/checkaudience()
	set name = "Check Audience"
	set category = "Inspiration"

	if(!inspiration)
		return FALSE
	var/text = ""
	for(var/mob/living/carbon/human/folks in inspiration.audience)
		text += "[folks.real_name], "
	if(!text)
		return
	to_chat(src, "My audience members are: [text]")

	return TRUE
	

/datum/inspiration/New(mob/living/carbon/human/holder)
	. = ..()
	src.holder = holder
	holder?.inspiration = src
	ADD_TRAIT(holder, INSPIRING_MUSICIAN, "inspiration")


/mob/living/carbon/human/proc/picksongs()
	set name = "Fill Songbook"
	set category = "Inspiration"


	if(!mind)
		return
	if(inspiration.is_picking)
		return
	inspiration.is_picking = TRUE

	var/list/songs = GLOB.learnable_songs
	var/list/choices = list()

	for(var/i = 1, i <= songs.len, i++)
		var/obj/effect/proc_holder/spell/spell_item = songs[i]
		choices["[spell_item.name]"] = spell_item

	var/choice = input("Choose a song") as anything in choices
	var/obj/effect/proc_holder/spell/invoked/song/item = choices[choice]

	if(!item)
		inspiration.is_picking = FALSE
		return     // user canceled;
	if(alert(src, "[item.desc]", "[item.name]", "Learn", "Cancel") == "Cancel") //gives a preview of the spell's description to let people know what a spell does
		inspiration.is_picking = FALSE
		return

	for(var/obj/effect/proc_holder/spell/knownsong in mind.spell_list)
		if(knownsong.type == item.type)
			to_chat(src, span_warning("You already know this one!"))
			inspiration.is_picking = FALSE
			return
	var/obj/effect/proc_holder/spell/invoked/song/new_song = new item
	mind.AddSpell(new_song)
	inspiration.songsbought += 1
	if(inspiration.songsbought >= inspiration.maxsongs)
		verbs -= /mob/living/carbon/human/proc/picksongs
	inspiration.is_picking = FALSE

/mob/living/carbon/human/proc/resetsongs()
	set name = "Reset Songbook"
	set category = "Inspiration"

	if(!mind || !inspiration)
		return
	if(world.time < inspiration.next_song_reset)
		to_chat(src, span_warning("I need [DisplayTimeText(inspiration.next_song_reset - world.time)] before I can rewrite my songbook again."))
		return
	if(alert(src, "Forget all chosen songs and choose them again?", "Reset Songbook", "Reset", "Cancel") == "Cancel")
		return

	var/list/spells_to_remove = list()
	for(var/obj/effect/proc_holder/spell/knownsong in mind.spell_list)
		if(knownsong.type in GLOB.learnable_songs)
			spells_to_remove += knownsong

	if(!spells_to_remove.len)
		to_chat(src, span_warning("I have no chosen songs to forget."))
		return

	for(var/obj/effect/proc_holder/spell/knownsong in spells_to_remove)
		mind.RemoveSpell(knownsong)

	inspiration.songsbought = 0
	inspiration.next_song_reset = world.time + BARD_RESET_COOLDOWN
	verbs |= list(/mob/living/carbon/human/proc/picksongs)
	to_chat(src, span_notice("Memorized sheet music spils from my mind. I can choose my songs again."))

/mob/living/carbon/human/proc/pickrhythms()
	set name = "Choose Rhythms"
	set category = "Inspiration"

	if(!mind)
		return
	if(!inspiration || inspiration.level < BARD_T2)
		return
	if(inspiration.is_picking_rhythm)
		return
	if(inspiration.rhythmsbought >= inspiration.maxrhythms)
		verbs -= /mob/living/carbon/human/proc/pickrhythms
		return
	inspiration.is_picking_rhythm = TRUE

	var/list/choices = list()
	for(var/i = 1, i <= GLOB.learnable_rhythms.len, i++)
		var/obj/effect/proc_holder/spell/spell_item = GLOB.learnable_rhythms[i]
		choices["[spell_item.name]"] = spell_item

	var/choice = input("Choose a rhythm") as anything in choices
	var/obj/effect/proc_holder/spell/self/rhythm/item = choices[choice]

	if(!item)
		inspiration.is_picking_rhythm = FALSE
		return
	if(alert(src, "[item.desc]", "[item.name]", "Learn", "Cancel") == "Cancel")
		inspiration.is_picking_rhythm = FALSE
		return

	for(var/obj/effect/proc_holder/spell/knownrhythm in mind.spell_list)
		if(knownrhythm.type == item.type)
			to_chat(src, span_warning("You already know this rhythm!"))
			inspiration.is_picking_rhythm = FALSE
			return
	var/obj/effect/proc_holder/spell/self/rhythm/new_rhythm = new item
	mind.AddSpell(new_rhythm)
	inspiration.rhythmsbought += 1
	if(inspiration.rhythmsbought >= inspiration.maxrhythms)
		verbs -= /mob/living/carbon/human/proc/pickrhythms
	inspiration.is_picking_rhythm = FALSE

/mob/living/carbon/human/proc/resetrhythms()
	set name = "Reset Rhythms"
	set category = "Inspiration"

	if(!mind || !inspiration || inspiration.level < BARD_T2)
		return
	if(world.time < inspiration.next_rhythm_reset)
		to_chat(src, span_warning("I need [DisplayTimeText(inspiration.next_rhythm_reset - world.time)] before I can rewrite my rhythms again."))
		return
	if(alert(src, "Forget all chosen rhythms and choose them again?", "Reset Rhythms", "Reset", "Cancel") == "Cancel")
		return

	var/list/spells_to_remove = list()
	for(var/obj/effect/proc_holder/spell/knownrhythm in mind.spell_list)
		if(knownrhythm.type in GLOB.learnable_rhythms)
			spells_to_remove += knownrhythm

	if(!spells_to_remove.len)
		to_chat(src, span_warning("I have no chosen rhythms to forget."))
		return

	for(var/obj/effect/proc_holder/spell/knownrhythm in spells_to_remove)
		mind.RemoveSpell(knownrhythm)

	inspiration.rhythmsbought = 0
	if(inspiration.rhythm_tracker)
		if(inspiration.rhythm_tracker.decay_timer_id)
			deltimer(inspiration.rhythm_tracker.decay_timer_id)
			inspiration.rhythm_tracker.decay_timer_id = null
		inspiration.rhythm_tracker.greater_stacks = 0
		inspiration.rhythm_tracker.last_rhythm_type = 0
	inspiration.next_rhythm_reset = world.time + BARD_RESET_COOLDOWN
	verbs |= list(/mob/living/carbon/human/proc/pickrhythms)
	to_chat(src, span_notice("The harmonies escape me. I can choose my rhythms again."))

#undef BARD_RESET_COOLDOWN
