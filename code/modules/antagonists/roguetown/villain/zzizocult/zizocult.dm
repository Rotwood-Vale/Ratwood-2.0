#define LIST_PRAISE_ZIZO list("Praise Zizo!", "Hail Zizo!", "Glory to the Pale Lady!", "ZIZO! ZIZO! ZIZO!")

/datum/antagonist/zizocultist
	name = "Zizoid Cultist"
	roundend_category = "Zizoid Cultists"
	antagpanel_category = "Zizoid Cult"
	job_rank = ROLE_ZIZOIDCULTIST
	confess_lines = list(
		"DEATH TO THE TEN!",
		"PRAISE ZIZO!",
		"I AM THE FUTURE!",
		"NO GODS! ONLY MASTERS!",
	)
	var/islesser = TRUE
	var/change_stats = TRUE
	var/list/innate_traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_CABAL,
	)

/datum/antagonist/zizocultist/leader
	name = "Zizoid Cultist"
	islesser = FALSE
	innate_traits = list(
		TRAIT_DECEIVING_MEEKNESS,
		TRAIT_STEELHEARTED,
		TRAIT_NOMOOD,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_CABAL,
	)

/datum/antagonist/zizocultist/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	for(var/trait in innate_traits)
		ADD_TRAIT(M, trait, "zizocultist")

/datum/antagonist/zizocultist/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	for(var/trait in innate_traits)
		REMOVE_TRAIT(M, trait, "zizocultist")

/datum/antagonist/zizocultist/on_gain()
	. = ..()
	var/mob/living/carbon/human/H = owner.current
	SSmapping.retainer.cultists |= owner
	H.set_patron(/datum/patron/inhumen/zizo)
	H.cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'
	H.playsound_local(get_turf(H), 'sound/music/maniac.ogg', 80, FALSE, pressure_affected = FALSE)
	H.verbs |= /mob/living/carbon/human/proc/praise
	H.verbs |= /mob/living/carbon/human/proc/communicate
	H.verbs |= /mob/living/carbon/human/proc/draw_sigil
	H.verbs |= /mob/living/carbon/human/proc/zizo_lore
	H.verbs |= /mob/living/carbon/human/proc/zizo_objectives
	H.purity = FALSE

	H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_JOURNEYMAN)

	owner.special_role = ROLE_ZIZOIDCULTIST
	add_objective(/datum/objective/zizo)
	H.verbs |= /mob/living/carbon/human/proc/release_minion
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT)
	H.grant_language(/datum/language/undead)
	new /datum/antag_setup(owner.current)
	greet()

/datum/antagonist/zizocultist/greet()
	to_chat(owner, span_danger("I'm a cultist to the ALMIGHTY. They call it the UNSPEAKABLE. A new future begins."))
	owner.announce_objectives()

/datum/antagonist/zizocultist/leader/greet()
	to_chat(owner, span_danger("I'm a cultist to the ALMIGHTY. They call it the UNSPEAKABLE. I require LACKEYS to make my RITUALS easier. I SHALL ASCEND."))
	owner.announce_objectives()

/datum/antagonist/zizocultist/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/zizocultist/leader))
		return span_boldnotice("OUR LEADER!")
	if(istype(examined_datum, /datum/antagonist/zizocultist))
		return span_boldnotice("A cultist of ZIZO.")
	if(istype(examined_datum, /datum/antagonist/assassin))
		return span_boldnotice("A GRAGGAROID! A CULTIST OF GRAGGAR!")

/datum/antagonist/zizocultist/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(.)
		if(new_owner.current == SSticker.rulermob)
			return FALSE
		if(new_owner.unconvertable)
			return FALSE

/datum/antagonist/zizocultist/proc/add_cultist(datum/mind/cult_mind)
	cult_mind.add_antag_datum(/datum/antagonist/zizocultist)
	return TRUE

/datum/antagonist/zizocultist/proc/add_objective(datum/objective/O)
	objectives += new O

/datum/antagonist/zizocultist/proc/remove_objective(datum/objective/O)
	objectives -= O

/datum/objective/zizo
	name = "ASCEND"
	explanation_text = "Ensure that a member of the cult ASCENDS. You can look at your research menu to familiarize myself with your rituals."
	team_explanation_text = "Ensure that a member of the cult ASCENDS. You can look at your research menu to familiarize myself with your rituals."
	triumph_count = 5

/datum/objective/zizo/check_completion()
	if(SSmapping.retainer.cult_ascended)
		return TRUE

/datum/objective/zizoserve
	name = "Serve your Leader"
	explanation_text = "Ensure that a member of the cult ASCENDS. You can look at your research menu to familiarize myself with your rituals."
	team_explanation_text = "Ensure that a member of the cult ASCENDS. You can look at your research menu to familiarize myself with your rituals."
	triumph_count = 3

/datum/objective/zizoserve/check_completion()
	if(SSmapping.retainer.cult_ascended)
		return TRUE

/mob/living/carbon/human/proc/praise()
	set name = "Praise the Dark Lady!"
	set category = "ZIZO"

	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return
	say(pick(LIST_PRAISE_ZIZO), spans = list("god_zizo"), sanitize = FALSE, language = /datum/language/undead)
	playsound(src, 'sound/vo/cult/praise.ogg', 45, 1)
	log_say("[src] has praised zizo! (zizo cultist verb)")
	if(!ishuman(src))
		return
	var/mob/living/carbon/human/cultist = src
	if((/datum/zizogoal/worshipzizo in cultist.zizo_goals) || (/datum/zizogoal/worshipzizo_church in cultist.zizo_goals))
		var/turf/churchcheck = get_turf(cultist)
		if(istype(churchcheck, /area/rogue/indoors/town/church))
			complete_zgoal(cultist, /datum/zizogoal/worshipzizo_church)
		var/observers = 0
		var/complete = FALSE
		for(var/mob/living/carbon/human/L in hearers(7, cultist))
			if(observers > 2)
				complete = TRUE
				break
			if(L == cultist)
				continue
			if(L.stat == DEAD)
				continue
			if(!L.mind)
				continue
			if(is_zizo(L))
				continue
			observers++
		if(complete == TRUE)
			complete_zgoal(cultist, /datum/zizogoal/worshipzizo)

/mob/living/carbon/human/proc/zizo_objectives()
	set name = "Secret Objectives"
	set category = "ZIZO"

	if(!ishuman(src))
		return
	var/mob/living/carbon/human/cultist = src
	if(!cultist.zizo_goals)
		reroll_goals(cultist)
	for(var/datum/zizogoal/gl in cultist.zizo_goals)
		to_chat(cultist, span_notice("<B>[gl.name]:</B> [gl.desc]<BR><B>[gl.reward] SECRETS.</B>"))

/mob/living/carbon/human/proc/communicate()
	set name = "Communicate with Cult"
	set category = "ZIZO"

	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return

	var/speak = input("What do you speak of?", "ZIZO") as text|null
	if(!speak)
		return
	whisper("O schlet'a ty'schkotot ty'skvoro...")
	sleep(5)
	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return
	whisper("[speak]")

	for(var/datum/mind/V in SSmapping.retainer.cultists)
		to_chat(V, "<span style = \"font-size:110%; font-weight:bold\"><span style = 'color:#8a13bd'>A message from </span><span style = 'color:#[voice_color]'>[real_name]</span>: [speak]</span>")
		playsound_local(V.current, 'sound/vo/cult/skvor.ogg', 100)

	log_say("[key_name(src)] used cultist telepathy to say: [speak]")

/mob/living/carbon/human/proc/release_minion()
	set name = "Release Lackey"
	set category = "ZIZO"

	if(stat == DEAD)
		return

	var/list/mob/living/carbon/human/possible = list()
	for(var/datum/mind/V in SSmapping.retainer.cultists)
		if(V.special_role == "Zizoid Lackey")
			possible |= V.current

	var/mob/living/carbon/human/choice = input(src, "Whom do you no longer have use for?", "ZIZO") as null|anything in possible
	if(choice)
		var/alert = tgui_alert(src, "Are you sure?", "ZIZO", list("Yes", "Cancel"))
		if(alert == "Yes")
			visible_message(span_danger("[src] reaches out, ripping up [choice]'s soul!"))
			to_chat(choice, span_danger("I HAVE FAILED MY LEADER! I HAVE FAILED ZIZO! NOTHING ELSE BUT DEATH REMAINS FOR ME NOW!"))
			sleep(20)
			choice.gib()
			SSmapping.retainer.cultists -= choice.mind

#undef LIST_PRAISE_ZIZO

/mob/living/carbon/human/proc/zizo_lore()
	set name = "Research"
	set category = "ZIZO"
	GLOB.zizo_research.open(src)
