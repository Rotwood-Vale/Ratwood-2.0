/// DEFINITIONS ///
#define CLERIC_ORI -1
#define CLERIC_T0 0
#define CLERIC_T1 1
#define CLERIC_T2 2
#define CLERIC_T3 3
#define CLERIC_T4 4

#define CLERIC_REQ_0 0
#define CLERIC_REQ_1 250
#define CLERIC_REQ_2 400
#define CLERIC_REQ_3 750
#define CLERIC_REQ_4 1000

#define CLERIC_REGEN_DEVOTEE 0.3
#define CLERIC_REGEN_WEAK 0.1 //Would be better to just do away with devotion entirely, but oh well.
#define CLERIC_REGEN_MINOR 0.5
#define CLERIC_REGEN_MAJOR 0.8
#define CLERIC_REGEN_WITCH 1.5
#define CLERIC_REGEN_ABSOLVER 5

// Cleric Holder Datums

/datum/devotion
	/// Mob that owns this datum
	var/mob/living/carbon/human/holder
	/// Patron this holder is for
	var/datum/patron/patron
	/// Current devotion we are holding
	var/devotion = 0
	/// Maximum devotion we can hold at once
	var/max_devotion = CLERIC_REQ_1
	/// Current progression (experience)
	var/progression = 0
	/// Maximum progression (experience) we can achieve
	var/max_progression = CLERIC_REQ_4
	/// Current spell tier, basically
	var/level = CLERIC_T0
	/// Last spell tier, to prevent duplicating miracles
	var/last_level = null
	/// How much devotion is gained per process call
	var/passive_devotion_gain = 0
	/// How much progression is gained per process call
	var/passive_progression_gain = 0
	/// How much devotion is gained per prayer cycle
	var/prayer_effectiveness = 2
	/// Spells we have granted thus far
	var/list/granted_spells
	///suppress granting miracles updating from devotion level up
	var/suppress_grants = FALSE

/datum/devotion/New(mob/living/carbon/human/holder, datum/patron/patron)
	. = ..()
	src.holder = holder
	holder?.devotion = src
	src.patron = patron
	holder?.hud_used?.initialize_bloodpool()
	holder?.hud_used?.bloodpool.set_fill_color("#3C41A4")
	if (patron.type == /datum/patron/inhumen/zizo || patron.type == /datum/patron/divine/necra)
		ADD_TRAIT(holder, TRAIT_DEATHSIGHT, "devotion")

/datum/devotion/Destroy(force)
	. = ..()
	if (patron.type == /datum/patron/inhumen/zizo || patron.type == /datum/patron/divine/necra)
		REMOVE_TRAIT(holder, TRAIT_DEATHSIGHT, "devotion")
	holder?.hud_used?.shutdown_bloodpool()
	holder?.devotion = null
	holder = null
	patron = null
	granted_spells = null
	STOP_PROCESSING(SSobj, src)

/datum/devotion/process()
	if(!passive_devotion_gain && !passive_progression_gain)
		return PROCESS_KILL
	var/devotion_multiplier = 1
	if(holder?.mind)
		devotion_multiplier += (holder.get_skill_level(/datum/skill/magic/holy) / SKILL_LEVEL_LEGENDARY)
	update_devotion((passive_devotion_gain * devotion_multiplier), (passive_progression_gain * devotion_multiplier), silent = TRUE)

/datum/devotion/proc/check_devotion(obj/effect/proc_holder/spell/spell)
	if(devotion - spell.devotion_cost < 0)
		return FALSE
	return TRUE

/datum/devotion/proc/update_devotion(dev_amt, prog_amt, silent = FALSE)
	devotion = clamp(devotion + dev_amt, 0, max_devotion)
	holder?.hud_used?.bloodpool?.name = "Devotion: [devotion]"
	holder?.hud_used?.bloodpool?.desc = "Devotion: [devotion]/[max_devotion]"
	if(devotion <= 0)
		holder?.hud_used?.bloodpool?.set_value(0, 1 SECONDS)
	else
		holder?.hud_used?.bloodpool?.set_value((100 / (max_devotion / devotion)) / 100, 1 SECONDS)
	//Max devotion limit
	if((devotion >= max_devotion) && !silent)
		to_chat(holder, span_warning("I have reached the limit of my devotion..."))
	if(!prog_amt) // no point in the rest if it's just an expenditure
		return TRUE
	progression = clamp(progression + prog_amt, 0, max_progression)
	switch(level)
		if(CLERIC_T0)
			if(progression >= CLERIC_REQ_1)
				level = CLERIC_T1
		if(CLERIC_T1)
			if(progression >= CLERIC_REQ_2)
				level = CLERIC_T2
		if(CLERIC_T2)
			if(progression >= CLERIC_REQ_3)
				level = CLERIC_T3
		if(CLERIC_T3)
			if(progression >= CLERIC_REQ_4)
				level = CLERIC_T4
	if(!holder?.mind)
		return FALSE
	if(level != last_level)
		try_add_spells(silent = silent)
		last_level = level
	return TRUE

/datum/devotion/proc/_grant_all_patron_miracles_direct(mob/living/carbon/human/H, max_tier = null)
	if(!H || !H.mind || !H.patron)
		return

	if(length(H.patron.miracles))
		for(var/spell_type in H.patron.miracles)
			if(!ispath(spell_type, /obj/effect/proc_holder/spell))
				continue
			if(!isnull(max_tier) && H.patron.miracles[spell_type] > max_tier)
				continue
			if(H.mind.has_spell(spell_type))
				continue

			var/obj/effect/proc_holder/spell/newspell = new spell_type
			if(newspell)
				H.mind.AddSpell(newspell, H)

	if(length(H.patron.traits_tier))
		for(var/trait in H.patron.traits_tier)
			if(!isnull(max_tier) && H.patron.traits_tier[trait] > max_tier)
				continue
			ADD_TRAIT(H, trait, TRAIT_MIRACLE)

/datum/devotion/proc/_is_clergy_radical(mob/living/carbon/human/H) //yes i know
	if(!H)
		return FALSE
	return HAS_TRAIT(H, TRAIT_CLERGYRADICAL)

/datum/devotion/proc/_is_learnmiracle_eligible(mob/living/carbon/human/H) //yes i know
	if(!H || !H.mind)
		return FALSE
	return HAS_TRAIT(H, TRAIT_CLERGYRADICAL)

/datum/devotion/proc/try_add_spells(silent = FALSE)
	if(!holder?.mind || !patron)
		return FALSE
	if(_is_clergy_radical(holder))
		return FALSE
	if(suppress_grants)
		return FALSE
	if(patron)
		if(length(patron.miracles))
			for(var/spell_type in patron.miracles)
				var/required_tier = patron.miracles[spell_type]
				if(required_tier <= level)
					if(holder.mind.has_spell(spell_type))
						continue

					var/obj/effect/proc_holder/spell/newspell = new spell_type
					if(!silent)
						to_chat(holder, span_boldnotice("I have unlocked a new spell: [newspell]"))
					holder.mind.AddSpell(newspell, holder)
					LAZYADD(granted_spells, newspell)

		if(length(patron.traits_tier))
			for(var/trait in patron.traits_tier)
				var/required_tier = patron.traits_tier[trait]
				if(required_tier <= level)
					if(!silent)
						to_chat(holder, span_boldnotice("I have unlocked a new trait: [trait]"))
					ADD_TRAIT(holder, trait, TRAIT_MIRACLE)


//The main proc that distributes all the needed devotion tweaks to the given class.
//cleric_tier 		- The cleric tier that the holder will get spells of immediately.
//passive_gain 		- Passive devotion gain, if any, will begin processing this datum.
//devotion_limit	- The CLERIC_REQ max_devotion and max_progression will be set to. Devotee overrides this with its own value!
//start_maxed		- Whether this class starts out with all devotion maxed. Mostly used by Acolytes & Priests to spawn with everything.

/datum/devotion/proc/grant_miracles(mob/living/carbon/human/H, cleric_tier = CLERIC_T0, passive_gain = 0, devotion_limit, start_maxed = FALSE)
	if(!H || !H.mind || !patron)
		return
	level = cleric_tier
	if(devotion_limit)
		max_devotion = devotion_limit
		max_progression = devotion_limit
	if(passive_gain)
		passive_devotion_gain = passive_gain
		passive_progression_gain = passive_gain
		START_PROCESSING(SSobj, src)
	if(start_maxed)
		max_devotion = CLERIC_REQ_4
		devotion = max_devotion
		update_devotion(max_devotion, CLERIC_REQ_4, silent = TRUE)
	else
		update_devotion(50, 50, silent = TRUE)
	H.verbs += list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)

	if(_is_learnmiracle_eligible(H))
		var/miracle_menu_path = text2path("/obj/effect/proc_holder/spell/self/learnmiracle")
		if(miracle_menu_path)
			if(!H.mind.has_spell(miracle_menu_path))
				var/obj/effect/proc_holder/spell/L = new miracle_menu_path
				if(L)
					H.mind.AddSpell(L, H)

// Debug verb
/mob/living/carbon/human/proc/devotionchange()
	set name = "(DEBUG)Change Devotion"
	set category = "-Special Verbs-"

	if(!devotion)
		return FALSE

	var/changeamt = input(src, "My devotion is [devotion.devotion]. How much to change?", "How much to change?") as null|num
	if(!changeamt)
		return FALSE
	devotion.update_devotion(changeamt)
	return TRUE

/mob/living/carbon/human/proc/devotionreport()
	set name = "Check Devotion"
	set category = "Cleric"

	if(!devotion)
		return FALSE

	to_chat(src,"My devotion is [devotion.devotion].")
	return TRUE

/mob/living/carbon/human/proc/clericpray()
	set name = "Give Prayer"
	set category = "Cleric"

	if(!devotion)
		return FALSE

	if (HAS_TRAIT(src, TRAIT_WITCH))
		to_chat(src, span_warning("What need have I to pray? I draw my power from the old ways, whether my patron likes it or not."))
		return FALSE

	var/prayersesh = 0
	visible_message("[src] kneels their head in prayer to the Gods.", "I kneel my head in prayer to [devotion.patron.name].")
	for(var/i in 1 to 50)
		if(devotion.devotion >= devotion.max_devotion)
			to_chat(src, span_warning("I have reached the limit of my devotion..."))
			break
		if(!do_after(src, 30))
			break
		var/devotion_multiplier = 1
		if(mind)
			devotion_multiplier += (get_skill_level(/datum/skill/magic/holy) / SKILL_LEVEL_LEGENDARY)
		var/prayer_effectiveness = round(devotion.prayer_effectiveness * devotion_multiplier)
		devotion.update_devotion(prayer_effectiveness, prayer_effectiveness)
		prayersesh += prayer_effectiveness
	visible_message("[src] concludes their prayer.", "I conclude my prayer.")
	to_chat(src, "<font color='purple'>I gained [prayersesh] devotion!</font>")
	return TRUE

/mob/living/carbon/human/proc/reset_clergy_devotion(cleric_tier, passive_gain, start_maxed = FALSE, devotion_limit = CLERIC_REQ_4)
	if(!mind || !patron)
		return FALSE
	var/datum/devotion/D = devotion
	if(D)
		if(length(D.granted_spells))
			for(var/obj/effect/proc_holder/spell/S in D.granted_spells)
				mind.RemoveSpell(S)
		STOP_PROCESSING(SSobj, D)
		D.patron = patron
		D.devotion = 0
		D.max_devotion = CLERIC_REQ_1
		D.progression = 0
		D.max_progression = CLERIC_REQ_4
		D.level = CLERIC_T0
		D.last_level = null
		D.passive_devotion_gain = 0
		D.passive_progression_gain = 0
		D.granted_spells = null
		D.suppress_grants = FALSE
	else
		D = new /datum/devotion(src, patron)
	D.grant_miracles(src, cleric_tier = cleric_tier, passive_gain = passive_gain, devotion_limit = devotion_limit, start_maxed = start_maxed)
	return TRUE

/mob/living/carbon/human/proc/changevoice()
	set name = "Change Second Voice (Can only use Once!)"
	set category = "Memory"

	var/newcolor = input(src, "Choose your character's SECOND voice color:", "VIRTUE","#a0a0a0") as color|null
	if(newcolor)
		second_voice = sanitize_hexcolor(newcolor)
		src.verbs -= /mob/living/carbon/human/proc/changevoice
		return TRUE
	else
		return FALSE

/mob/living/carbon/human/proc/swapvoice()
	set name = "Swap Voice"
	set category = "Memory"

	if(!second_voice)
		to_chat(src, span_info("I haven't decided on my second voice yet."))
		return FALSE
	if(voice_color != second_voice)
		original_voice = voice_color
		voice_color = second_voice
		to_chat(src, span_info("I've changed my voice to the second one."))
	else
		voice_color = original_voice
		to_chat(src, span_info("I've returned to my natural voice."))
	return TRUE

/mob/living/carbon/human/proc/toggleblindness()
	set name = "Toggle Colorblindness"
	set category = "Memory"

	if(!get_client_color(/datum/client_colour/monochrome))
		add_client_colour(/datum/client_colour/monochrome)
	else
		remove_client_colour(/datum/client_colour/monochrome)

/mob/living/carbon/human/proc/togglecombatawareness()
	set name = "Toggle Combat Awareness"
	set category = "Memory"

	if(HAS_TRAIT(src, TRAIT_COMBAT_AWARE))
		REMOVE_TRAIT(src, TRAIT_COMBAT_AWARE, TRAIT_VIRTUE)
	else
		ADD_TRAIT(src, TRAIT_COMBAT_AWARE, TRAIT_VIRTUE)
	to_chat(src, "I will see [HAS_TRAIT(src, TRAIT_COMBAT_AWARE) ? "more" : "less"] combat information now.")
