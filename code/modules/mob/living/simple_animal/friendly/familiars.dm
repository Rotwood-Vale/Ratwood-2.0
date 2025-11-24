#define FAMILIAR_SEE_IN_DARK 6
#define FAMILIAR_MIN_BODYTEMP 200
#define FAMILIAR_MAX_BODYTEMP 400

/*
	Familiar list and buffs below.
	Sprites by Diltyrr (those aren't good gah)

	Quick AI pictures idea for each of them : https://imgbox.com/g/MvanomKazA
*/

/mob/living/simple_animal/pet/familiar
	name = "Generic Wizard familiar"
	desc = "The spirit of what makes a familiar (You shouldn't be seeing this.)"

	icon = 'icons/roguetown/mob/familiars.dmi'

	butcher_results = list(/obj/item/natural/stone = 1)

	pass_flags = PASSMOB //We don't want them to block players.
	base_intents = list(INTENT_HELP)
	melee_damage_lower = 1
	melee_damage_upper = 2

	dextrous = TRUE
	gender = MALE

	speak_chance = 1
	turns_per_move = 5
	mob_size = MOB_SIZE_SMALL
	density = FALSE
	see_in_dark = FAMILIAR_SEE_IN_DARK
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = FAMILIAR_MIN_BODYTEMP
	maxbodytemp = FAMILIAR_MAX_BODYTEMP
	unsuitable_atmos_damage = 1
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	faction = list("rogueanimal", "neutral")
	speed = 0.8
	breedchildren = 0 //Yeah no, I'm not falling for this one.
	dodgetime = 20
	held_items = list(null, null)
	pooptype = null
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	var/obj/item/mouth = null

	var/buff_given = list()
	var/mob/living/carbon/familiar_summoner = null
	var/inherent_spell = null
	var/summoning_emote = null

	var/flight_capable = FALSE
	var/flight_time = 2 SECONDS

//As far as I am aware, you cannot pat out fire as a familiar at least not in time for it to not kill you, this seems fair.
/mob/living/simple_animal/pet/familiar/fire_act(added, maxstacks)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living, extinguish_mob)), 1 SECONDS)

/mob/living/simple_animal/pet/familiar/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CHUNKYFINGERS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	AddComponent(/datum/component/footstep, footstep_type)
	if(flight_capable)
		verbs += list(/mob/living/simple_animal/pet/familiar/proc/fly_up,
		/mob/living/simple_animal/pet/familiar/proc/fly_down)

/mob/living/simple_animal/pet/familiar/proc/fly_up()
	set category = "Flight"
	set name = "Fly Up"

	if(src.pulledby != null)
		to_chat(src, span_notice("I can't fly away while being grabbed!"))
		return
	src.visible_message(span_notice("[src] begins to ascend!"), span_notice("You take flight..."))
	if(do_after(src, flight_time))
		if(src.pulledby == null)
			src.zMove(UP, TRUE)
			to_chat(src, span_notice("I fly up."))
		else
			to_chat(src, span_notice("I can't fly away while being grabbed!"))

/mob/living/simple_animal/pet/familiar/proc/fly_down()
	set category = "Flight"
	set name = "Fly Down"

	if(src.pulledby != null)
		to_chat(src, span_notice("I can't fly away while being grabbed!"))
		return
	src.visible_message(span_notice("[src] begins to descend!"), span_notice("You take flight..."))
	if(do_after(src, flight_time))
		if(src.pulledby == null)
			src.zMove(DOWN, TRUE)
			to_chat(src, span_notice("I fly down."))
		else
			to_chat(src, span_notice("I can't fly away while being grabbed!"))

/mob/living/simple_animal/pet/familiar/proc/can_bite()
	for(var/obj/item/grabbing/grab in grabbedby) //Grabbed by the mouth
		if(grab.sublimb_grabbed == BODY_ZONE_PRECISE_MOUTH)
			return FALSE

	return TRUE

/mob/living/simple_animal/pet/familiar/examine(mob/user)
	. = ..()
	var/datum/familiar_prefs/fpref = src.client?.prefs.familiar_prefs
	if(fpref && (fpref.familiar_flavortext || fpref.familiar_headshot_link || fpref.familiar_ooc_notes))
		. += "<a href='?src=[REF(src)];task=view_fam_headshot;'>Examine closer</a>"

/datum/status_effect/buff/familiar
	duration = -1

/mob/living/simple_animal/pet/familiar/death()
	. = ..()
	emote("deathgasp")
	if(familiar_summoner)
		to_chat(familiar_summoner, span_warning("[src.name] has fallen, and your bond dims. Yet in the quiet beyond, a flicker of their essence remains."))

/mob/living/simple_animal/pet/familiar/Destroy()
	if(familiar_summoner)
		if(buff_given)
			familiar_summoner.remove_status_effect(buff_given)
		if(familiar_summoner.mind)
			familiar_summoner.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/message_familiar)
	return ..()

/mob/living/simple_animal/pet/familiar/pondstone_toad
	name = "Pondstone Toad"
	desc = "This damp, heavy toad pulses with unseen strength. Its skin is cool and lined with mineral veins."
	animal_species = "Pondstone Toad"
	summoning_emote = "A deep thrum echoes beneath your feet, and a mossy toad pushes itself free from the earth, humming low."
	icon_state = "pondstone"
	icon_living = "pondstone"
	icon_dead = "pondstone_dead"
	buff_given = /datum/status_effect/buff/familiar/settled_weight
	inherent_spell = list(/obj/effect/proc_holder/spell/self/stillness_of_stone)
	STASTR = 11
	STAPER = 7
	STAINT = 9
	STACON = 11
	STASPD = 5
	STALUC = 9
	speak = list("Hrrrm.", "Grrup.", "Blorp.")
	speak_emote = list("croaks low", "grumbles")
	emote_hear = list("croaks lowly.", "lets out a bubbling sound.")
	emote_see = list("shudders like stone.", "thumps softly in place.")
	var/icon/original_icon = null
	var/original_icon_state = ""
	var/original_icon_living = ""
	var/original_name = ""
	var/stoneform = FALSE

/datum/status_effect/buff/familiar/settled_weight
	id = "settled_weight"
	effectedstats = list(STATKEY_STR = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/settled_weight

/atom/movable/screen/alert/status_effect/buff/familiar/settled_weight
	name = "Settled Weight"
	desc = "You feel just a touch more grounded. Pushing back has become a little easier."


/mob/living/simple_animal/pet/familiar/mist_lynx
	name = "Mist Lynx"
	desc = "A ghostlike lynx, its eyes gleaming like twin moons. It never seems to blink, even when you're not looking."
	animal_species = "Mist Lynx"
	summoning_emote = "Mist coils into feline shape, resolving into a lynx with pale fur and unblinking silver eyes."
	icon_state = "mist"
	icon_living = "mist"
	icon_dead = "mist_dead"
	alpha = 150
	buff_given = /datum/status_effect/buff/familiar/silver_glance
	inherent_spell = list(/obj/effect/proc_holder/spell/self/lurking_step, /obj/effect/proc_holder/spell/invoked/veilbound_shift)
	pass_flags = PASSGRILLE | PASSMOB
	STASTR = 6
	STAPER = 11
	STAINT = 9
	STACON = 7
	STAWIL = 9
	STASPD = 13
	STALUC = 9
	speak = list("...") // mostly silent
	speak_emote = list("purrs softly", "whispers")
	emote_hear = list("lets out a soft yowl.", "whispers almost silently.")
	emote_see = list("pads in a circle.", "vanishes briefly, then reappears.")
	var/list/saved_trails = list()

/datum/status_effect/buff/familiar/silver_glance
	id = "silver_glance"
	effectedstats = list(STATKEY_PER = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/silver_glance

/atom/movable/screen/alert/status_effect/buff/familiar/silver_glance
	name = "Silver Glance"
	desc = "There's a flicker at the edge of your vision. You notice what others pass by."

/mob/living/simple_animal/pet/familiar/rune_rat
	name = "Rune Rat"
	desc = "This rat leaves fading runes in the air as it twitches. The smell of old paper clings to its fur."
	animal_species = "Rune Rat"
	summoning_emote = "A faint spark dances through the air. A rat with a softly glowing tail scampers into existence."
	icon_state = "runerat"
	icon_living = "runerat"
	icon_dead = "runerat_dead"
	buff_given = /datum/status_effect/buff/familiar/threaded_thoughts
	inherent_spell = list(/obj/effect/proc_holder/spell/self/inscription_cache, /obj/effect/proc_holder/spell/self/recall_cache)
	STASTR = 5
	STAPER = 9
	STAINT = 11
	STACON = 7
	STAWIL = 8
	STASPD = 11
	speak = list("Skrii!", "Tik-tik.", "Chrr.")
	speak_emote = list("squeaks", "chatters")
	emote_hear = list("squeaks thoughtfully.", "sniffs the air.")
	emote_see = list("twitches its tail in patterns.", "skitters in a loop.")
	var/stored_books = list()
	var/storage_limit = 5

/datum/status_effect/buff/familiar/threaded_thoughts
	id = "threaded_thoughts"
	effectedstats = list(STATKEY_INT = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/threaded_thoughts

/atom/movable/screen/alert/status_effect/buff/familiar/threaded_thoughts
	name = "Threaded Thoughts"
	desc = "Your thoughts gather more easily, like threads pulled into a tidy weave."

/mob/living/simple_animal/pet/familiar/vaporroot_wisp
	name = "Vaporroot Wisp"
	desc = "This vaporroot wisp shimmers and shifts like smoke but feels solid enough to lean on."
	animal_species = "Vaporroot"
	summoning_emote = "A swirl of silvery mist gathers, coalescing into a small wisp of vaporroot."
	icon_state = "vaporroot"
	icon_living = "vaporroot"
	icon_dead = "vaporroot_dead"
	alpha = 150
	buff_given = /datum/status_effect/buff/familiar/quiet_resilience
	inherent_spell = list(/obj/effect/proc_holder/spell/self/soothing_bloom)
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	movement_type = FLYING
	flight_capable = TRUE
	STASTR = 4
	STACON = 11
	STAWIL = 9
	STASPD = 8
	speak = list("Fffff...", "Whuuuh.")
	speak_emote = list("whispers", "murmurs")
	emote_hear = list("hums softly.", "emits a calming mist.")
	emote_see = list("swirls in place.", "dissolves briefly.")

/datum/status_effect/buff/familiar/quiet_resilience
	id = "quiet_resilience"
	effectedstats = list(STATKEY_WIL = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/quiet_resilience

/atom/movable/screen/alert/status_effect/buff/familiar/quiet_resilience
	name = "Quiet Resilience"
	desc = "A calm strength hums beneath your skin. You breathe a little deeper."

/mob/living/simple_animal/pet/familiar/ashcoiler
	name = "Ashcoiler"
	desc = "This long-bodied snake coils slowly, like a heated rope. Its breath carries a faint scent of burnt herbs."
	summoning_emote = "Dust rises and circles before coiling into a gray-scaled creature that radiates dry, residual warmth."
	animal_species = "Ashcoiler"
	icon_state = "ashcoiler"
	icon_living = "ashcoiler"
	icon_dead = "ashcoiler_dead"
	butcher_results = list(/obj/item/ash = 1)
	buff_given = /datum/status_effect/buff/familiar/desert_bred_tenacity
	inherent_spell = list(/obj/effect/proc_holder/spell/self/smolder_shroud)
	STASTR = 7
	STAPER = 8
	STAINT = 9
	STACON = 9
	STAWIL = 11
	STASPD = 8
	STALUC = 8
	speak = list("Ssshh...", "Hhsss.", "Ffff.")
	speak_emote = list("hisses", "rasps")
	emote_hear = list("hisses faintly.", "breathes a puff of ash.")
	emote_see = list("slowly coils and uncoils.", "shifts weight in rhythm.")

/datum/status_effect/buff/familiar/desert_bred_tenacity
	id = "desert_bred_tenacity"
	effectedstats = list(STATKEY_WIL = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/desert_bred_tenacity

/atom/movable/screen/alert/status_effect/buff/familiar/desert_bred_tenacity
	name = "Desert-Bred Tenacity"
	desc = "You feel steady and patient, like something that has survived years without rain."

/mob/living/simple_animal/pet/familiar/glimmer_hare
	name = "Glimmer Hare"
	desc = "A quick, nervy creature. Light bends strangely around its translucent body."
	summoning_emote = "The air glints, and a translucent hare twitches into existence."
	animal_species = "Glimmer Hare"
	icon_state = "glimmer"
	icon_living = "glimmer"
	icon_dead = "glimmer_dead"
	buff_given = /datum/status_effect/buff/familiar/lightstep
	inherent_spell = list(/obj/effect/proc_holder/spell/invoked/blink/glimmer_hare)
	STASTR = 4
	STAPER = 9
	STACON = 6
	STAWIL = 9
	STASPD = 9
	STALUC = 11
	alpha = 150
	speak = list("Tik!", "Tch!", "Hah!")
	speak_emote = list("chatters quickly", "chirps")
	emote_hear = list("thumps the ground.", "scatters some dust.")
	emote_see = list("dashes suddenly, then stops.", "vibrates subtly.")

/datum/status_effect/buff/familiar/lightstep
	id = "lightstep"
	effectedstats = list(STATKEY_SPD = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/lightstep

/atom/movable/screen/alert/status_effect/buff/familiar/lightstep
	name = "Lightstep"
	desc = "You move with just a touch more ease."

/mob/living/simple_animal/pet/familiar/hollow_antlerling
	name = "Hollow Antlerling"
	desc = "A dog-sized deer with gleaming hollow antlers that emit flute-like sounds."
	summoning_emote = "A musical chime sounds. A tiny deer with antlers like bone flutes steps gently into view."
	animal_species = "Hollow Antlerling"
	icon_state = "antlerling"
	icon_living = "antlerling"
	icon_dead = "antlerling_dead"
	buff_given = /datum/status_effect/buff/familiar/soft_favor
	inherent_spell = list(/obj/effect/proc_holder/spell/self/verdant_veil)
	STASTR = 6
	STACON = 8
	STAWIL = 9
	STASPD = 9
	STALUC = 11
	speak = list("Hrrn.", "Mnnn.", "Chuff.")
	speak_emote = list("chimes softly", "calls out")
	emote_hear = list("lets out a musical chime.")
	emote_see = list("flickers like a mirage.", "steps just out of reach of falling dust.")

/datum/status_effect/buff/familiar/soft_favor
	id = "soft_favor"
	effectedstats = list(STATKEY_SPD = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/soft_favor

/atom/movable/screen/alert/status_effect/buff/familiar/soft_favor
	name = "Soft Favor"
	desc = "Fortune seems to tilt in your direction."

/mob/living/simple_animal/pet/familiar/gravemoss_serpent
	name = "Gravemoss Serpent"
	desc = "Its scales are flecked with lichen and grave-dust. Wherever it passes, roots twitch faintly in the soil."
	summoning_emote = "The ground heaves faintly as a long, moss-veiled serpent uncoils from it."
	animal_species = "Gravemoss Serpent"
	icon_state = "gravemoss"
	icon_living = "gravemoss"
	icon_dead = "gravemoss_dead"
	butcher_results = list(/obj/item/natural/dirtclod = 1)
	buff_given = /datum/status_effect/buff/familiar/burdened_coil
	inherent_spell = list(/obj/effect/proc_holder/spell/self/scent_of_the_grave)
	STASTR = 11
	STAPER = 8
	STAINT = 9
	STAWIL = 11
	STASPD = 6
	STALUC = 8
	speak = list("Grhh...", "Sssrrrh.", "Urrh.")
	speak_emote = list("hisses low", "mutters")
	emote_hear = list("rumbles from deep within.", "hisses like wind in roots.")
	emote_see = list("sinks halfway into the earth.", "gazes steadily.")

/datum/status_effect/buff/familiar/burdened_coil
	id = "burdened_coil"
	effectedstats = list(STATKEY_STR = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/burdened_coil

/atom/movable/screen/alert/status_effect/buff/familiar/burdened_coil
	name = "Burdened Coil"
	desc = "You feel grounded and steady, as if strength coils beneath your skin."

/mob/living/simple_animal/pet/familiar/starfield_crow
	name = "Starfield Zad"
	desc = "Its glossy feathers shimmer with shifting constellations, eyes gleaming with uncanny awareness even in the darkest shadows."
	summoning_emote = "A rift in the air reveals a fragment of the starry void, from which a sleek zad with feathers like the night sky takes flight."
	animal_species = "Starfield Crow"
	icon_state = "crow_flying"
	icon_living = "crow_flying"
	icon_dead = "crow_dead"
	butcher_results = list(/obj/item/roguegem/amethyst = 1)//Worth effectively nothing. Calm down.
	buff_given = /datum/status_effect/buff/familiar/starseam
	inherent_spell = list(/obj/effect/proc_holder/spell/self/starseers_cry)
	pass_flags = PASSTABLE | PASSMOB
	movement_type = FLYING
	flight_capable = TRUE
	STASTR = 4
	STAPER = 11
	STACON = 6
	STAWIL = 8
	STALUC = 11
	speak = list("Kraa.", "Caw.", "Krrrk.")
	speak_emote = list("caws quietly", "croaks")
	emote_hear = list("lets out a knowing caw.", "chirps like stars ticking.")
	emote_see = list("flickers through constellations.", "tilts its head and vanishes for a second.")

/datum/status_effect/buff/familiar/starseam
	id = "starseam"
	effectedstats = list(STATKEY_PER = 1, STATKEY_LCK = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/starseam

/atom/movable/screen/alert/status_effect/buff/familiar/starseam
	name = "Starseam"
	desc = "You feel nudged by distant patterns. The world flows more legibly."

/mob/living/simple_animal/pet/familiar/emberdrake
	name = "Emberdrake"
	desc = "Tiny and warm to the touch, this drake's wingbeats stir old memories. Runes flicker behind it like afterimages."
	summoning_emote = "A hush falls as glowing ash collects into a fluttering emberdrake."
	animal_species = "Emberdrake"
	icon_state = "emberdrake"
	icon_living = "emberdrake"
	icon_dead = "emberdrake_dead"
	butcher_results = list(/obj/item/ash = 1)
	buff_given = /datum/status_effect/buff/familiar/steady_spark
	inherent_spell = list(/obj/effect/proc_holder/spell/invoked/pyroclastic_puff)
	STASTR = 9
	STAPER = 8
	STAINT = 11
	STACON = 11
	STAWIL = 9
	STASPD = 8
	STALUC = 8
	speak = list("Ffff.", "Rrrhh.", "Chhhh.")
	speak_emote = list("crackles", "speaks warmly")
	emote_hear = list("rumbles like a hearth.", "flickers with flame.")
	emote_see = list("glows briefly brighter.", "leaves a brief heat haze.")

/datum/status_effect/buff/familiar/steady_spark
	id = "steady_spark"
	effectedstats = list(STATKEY_INT = 1, STATKEY_CON = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/steady_spark

/atom/movable/screen/alert/status_effect/buff/familiar/steady_spark
	name = "Steady Spark"
	desc = "Your thoughts don't burn, they smolder. Clear, slow, and lasting."

/mob/living/simple_animal/pet/familiar/ripplefox
	name = "Ripplefox"
	desc = "They flickers when not directly observed. Leaves no tracks. You're not always sure they're still nearby."
	summoning_emote = "A ripple in the air becomes a sleek fox, their fur twitching between shades of color as they pads forth."
	animal_species = "Ripplefox"
	icon_state = "ripple"
	icon_living = "ripple"
	icon_dead = "ripple_dead"
	buff_given = /datum/status_effect/buff/familiar/subtle_slip
	inherent_spell = list(/obj/effect/proc_holder/spell/self/phantom_flicker)
	STASTR = 5
	STACON = 8
	STAWIL = 9
	STASPD = 11
	STALUC = 11
	speak = list("Yip!", "Hrrnk.", "Tchk-tchk.")
	speak_emote = list("whispers fast", "speaks quickly")
	emote_hear = list("lets out a playful yip.", "laughs like water in motion.")
	emote_see = list("blurs like a ripple.", "isn't where it was a second ago.")

/datum/status_effect/buff/familiar/subtle_slip
	id = "subtle_slip"
	effectedstats = list(STATKEY_SPD = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/subtle_slip

/atom/movable/screen/alert/status_effect/buff/familiar/subtle_slip
	name = "Subtle Slip"
	desc = "Things seem a bit looser around you, a gap, a chance, a beat ahead."

/mob/living/simple_animal/pet/familiar/whisper_stoat
	name = "Whisper Stoat"
	desc = "Its gaze is too knowing. It tilts its head as if listening to something inside your skull."
	summoning_emote = "A thought twists into form, a tiny stoat slinks into view."
	animal_species = "Whisper Stoat"
	icon_state = "whisper"
	icon_living = "whisper"
	icon_dead = "whisper_dead"
	buff_given = /datum/status_effect/buff/familiar/noticed_thought
	inherent_spell = list(/obj/effect/proc_holder/spell/self/phantasm_fade)
	STASTR = 5
	STAPER = 11
	STAINT = 11
	STACON = 7
	STAWIL = 8
	STASPD = 11
	STALUC = 9
	speak = list("Tchhh.", "Hmm.", "Skkk.")
	speak_emote = list("mutters", "speaks softly")
	emote_hear = list("murmurs in your direction.", "makes a sound you forget instantly.")
	emote_see = list("wraps around a shadow.", "slips behind a thought.")

/datum/status_effect/buff/familiar/noticed_thought
	id = "noticed_thought"
	effectedstats = list(STATKEY_PER = 1, STATKEY_INT = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/noticed_thought

/atom/movable/screen/alert/status_effect/buff/familiar/noticed_thought
	name = "Noticed Thought"
	desc = "Everything makes just a bit more sense. You catch patterns more quickly."

/mob/living/simple_animal/pet/familiar/thornback_turtle
	name = "Thornback Turtle"
	desc = "It barely moves, but seems unshakable. Vines twist gently around its limbs."
	summoning_emote = "The ground gives a slow rumble. A turtle with a bark-like shell emerges from the soil."
	animal_species = "Thornback Turtle"
	icon_state = "thornback"
	icon_living = "thornback"
	icon_dead = "thornback_dead"
	buff_given = /datum/status_effect/buff/familiar/worn_stone
	inherent_spell = list(/obj/effect/proc_holder/spell/self/verdant_sprout)
	STASPD = 5
	STAPER = 7
	STAINT = 9
	STACON = 11
	STAWIL = 12
	STALUC = 8
	speak = list("Hrmm.", "Grunk.", "Mmm.")
	speak_emote = list("rumbles", "speaks slowly")
	emote_hear = list("grunts like shifting boulders.", "sighs like old wood.")
	emote_see = list("retracts slightly into its shell.", "blinks slowly.")

/datum/status_effect/buff/familiar/worn_stone
	id = "worn_stone"
	effectedstats = list(STATKEY_STR = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/worn_stone

/atom/movable/screen/alert/status_effect/buff/familiar/worn_stone
	name = "Worn Stone"
	desc = "Nothing feels urgent. You can take your time... and take a hit."
