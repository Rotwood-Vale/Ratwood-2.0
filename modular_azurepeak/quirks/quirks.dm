// Quirks are mostly for flavor or provide very little (or focused on roleplay) benefits.
// At best they should be very minor conveniences as a reward for leaning into vices.
// The baseline point_cost is one.

/datum/quirk/acquiredtastes
	name = "Acquired Tastes"
	desc = "Despite my unorthodox tastes, I'm always prepared to handle a guest with the toys I keep stashed."
	custom_text = "This quirk adds a bag containing various sexual instruments including a small vial of emberwine to your stash."
	added_stashed_items = list("Bag of Fetish Gear" = /obj/item/storage/roguebag/fetish)

/datum/quirk/annoyingface
	name = "Annoying Face"
	desc = "I am cursed with an odd voice and appearance."
	point_cost = 0
	added_traits = list(TRAIT_COMICSANS)

/datum/quirk/deadnose
	name = "Dead Nose"
	desc = "My nose is numb to the smell of decay."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that already has a dead nose!"
	added_traits = list(TRAIT_NOSTINK)
	incompatible_traits = list(TRAIT_NOSTINK)

/datum/quirk/disgracednoble
	name = "Disgraced Noble"
	desc = "I was a scion of a noble house... long ago. Now I am a commoner, and my family name is a source of shame."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a noble!"
	added_traits = list(TRAIT_DISGRACED_NOBLE)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/dwarvenchef
	name = "Dwarven Chef"
	desc = "A dwarf once showed me the trick to cutting a proper pretzel from butterdough."
	custom_text = "Lets you cut pretzels from butterdough."
	warning_text = "This quirk does nothing if you are already a dwarf!"
	added_traits = list(TRAIT_DWARVEN_CHEF)

/datum/quirk/empath
	name = "Empath"
	desc = "I can notice when people are in pain."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already an empath!"
	added_traits = list(TRAIT_EMPATH)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_traits = list(TRAIT_EMPATH)

/datum/quirk/fabledlover
	name = "Fabled Lover"
	desc = "It's a lucky thing to share my bed."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a fabled lover!"
	point_cost = 2
	added_traits = list(TRAIT_GOODLOVER)
	incompatible_virtues = list(/datum/virtue/utility/socialite, /datum/virtue/utility/performer)
	incompatible_traits = list(TRAIT_GOODLOVER)

/datum/quirk/gossiper
	name = "Gossiper"
	desc = "Despite my lowborn blood, I've made a habit out of brushing shoulders with the nobility and learning their secrets."
	custom_text = "Lets you view noble gossip."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a noble!"
	point_cost = 2
	added_traits = list(TRAIT_GOSSIPER)
	incompatible_virtues = list(/datum/virtue/utility/tracker)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/hobbyistmusician
	name = "Hobbyist Musician"
	desc = "I've dabbled in music over the years, and I've stashed away an instrument of my own."
	custom_text = "Comes with a stashed instrument of your choice. You choose the instrument after spawning in."
	added_skills = list(list(/datum/skill/misc/music, 1, 6))

/datum/quirk/hobbyistmusician/apply_to_human(mob/living/carbon/human/recipient)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/customization_trait, pick_stashed_instrument), recipient), 50)

/datum/quirk/largeframe
	name = "Large Frame"
	desc = "I'm simply built bigger than most. My strength and hardiness has nothing to show for my size, though."
	custom_text = "This quirk increases your sprite size. Incompatible with the Giant virtue."
	point_cost = 3
	incompatible_virtues = list(/datum/virtue/size/giant)

/datum/quirk/largeframe/apply_to_human(mob/living/carbon/human/recipient)
	recipient.transform = recipient.transform.Scale(1.25, 1.25)
	recipient.transform = recipient.transform.Translate(0, (0.25 * 16))
	recipient.update_transform()

/datum/quirk/redolent
	name = "Redolent"
	desc = "My body odor is strong and distinct. Without regular baths, others will notice..."
	point_cost = 1
	added_traits = list(TRAIT_REDOLENT)

/datum/quirk/redolent/apply_to_human(mob/living/carbon/human/recipient)
	var/datum/status_effect/redolent/strong_smell = recipient.apply_status_effect(/datum/status_effect/redolent)
	strong_smell.redolent_scent_type = recipient.client?.prefs?.redolent_type || "Neutral"
	strong_smell.redolent_scent = recipient.client?.prefs?.redolent_scent || ""

/datum/status_effect/redolent
	id = "redolent"
	duration = 999 MINUTES
	alert_type = null

	/// How others perceive our scent
	var/redolent_scent_type = REDOLENT_SMELL_NEUTRAL
	/// Player-written description of our scent.
	var/redolent_scent = null
	/// If the smell is currently suppressed
	COOLDOWN_DECLARE(smell_suppressed)
	/// Cooldown before we emit another scent to people around
	COOLDOWN_DECLARE(emit_scent)

/datum/status_effect/redolent/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_wash))

/datum/status_effect/redolent/on_remove()
	UnregisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT)
	return ..()

/datum/status_effect/redolent/process(wait)
	. = ..()
	if(!COOLDOWN_FINISHED(src, smell_suppressed))
		return
	emit_smell()

/// Temporarily suppressed the status and particle effects for a time after being cleaned
/datum/status_effect/redolent/proc/on_wash(datum/source, clean)
	SIGNAL_HANDLER
	if(clean < CLEAN_MEDIUM) // Weak cleaning won't wash it away
		return
	to_chat(owner, span_notice("I scrub the stink away. I should stay fresh for a while."))
	COOLDOWN_START(src, smell_suppressed, 30 MINUTES)

/datum/status_effect/redolent/proc/get_examine_text()
	if(!COOLDOWN_FINISHED(src, smell_suppressed)) // Means they have been washed so not currently stinky
		return
	var/scent_text = "an unusual scent"
	if(!isnull(redolent_scent))
		scent_text = html_encode(redolent_scent)
	switch(redolent_scent_type)
		if(REDOLENT_SMELL_GOOD)
			return "<span style='color:#FFB6C1'>They smell of [scent_text].</span>"
		if(REDOLENT_SMELL_NEUTRAL)
			return "<span style='color:#d8cf8a'>They smell of [scent_text].</span>"
		if(REDOLENT_SMELL_BAD)
			return span_greentext("They reek of [scent_text].")

/// Called by process, emits our scent
/datum/status_effect/redolent/proc/emit_smell()
	if(!COOLDOWN_FINISHED(src, emit_scent))
		return
	COOLDOWN_START(src, emit_scent, 30 SECONDS)

	// Emits the visual effect
	switch(redolent_scent_type)
		if(REDOLENT_SMELL_GOOD)
			new /obj/effect/temp_visual/pleasant_scent(get_turf(owner))
		if(REDOLENT_SMELL_BAD)
			new /obj/effect/temp_visual/flies(get_turf(owner))

	// Emits a stench in an AOE
	for(var/mob/living/nearby in view(2, owner))
		if(nearby == owner) // Immune to your own stench
			continue
		if(nearby.stat) // Unconscious can't smell
			continue
		if(HAS_TRAIT(nearby, TRAIT_MISSING_NOSE)) // No nose
			continue
		if(HAS_TRAIT(nearby, TRAIT_NOSTINK)) // Numb to smells
			continue
		if(HAS_TRAIT(nearby, TRAIT_NOBREATH)) // Can't breath / Holding breath
			continue
		switch(redolent_scent_type)
			if(REDOLENT_SMELL_GOOD)
				if(!nearby.has_stress_event(/datum/stressevent/pleasant_scent))
					to_chat(nearby, "<span class='warning' style='color:#ffb6c1'>A pleasant scent drifts through the air.</span>")
					nearby.add_stress(/datum/stressevent/pleasant_scent)
			if(REDOLENT_SMELL_NEUTRAL)
				if(!nearby.has_stress_event(/datum/stressevent/prominent_scent))
					to_chat(nearby, "<span class='warning' style='color:#d8cf8a'>There's a prominent scent in the air.</span>")
					nearby.add_stress(/datum/stressevent/prominent_scent)
			if(REDOLENT_SMELL_BAD)
				if(!nearby.has_stress_event(/datum/stressevent/stinky_aura))
					to_chat(nearby, "<span class='warning' style='color:#48c75a'>Something nearby reeks.</span>")
					nearby.add_stress(/datum/stressevent/stinky_aura)

/// Applies our stench to someone else
/datum/status_effect/redolent/proc/apply_on_contact(mob/living/carbon/human/target)
	// Step 1: Check to see if they have OUR smell
	for(var/datum/status_effect/redolent/stinky_contact/stink_to_check in target.has_status_effect_list(/datum/status_effect/redolent/stinky_contact))
		if(stink_to_check.redolent_scent == redolent_scent) // Check if they have our custom string
			// If they do, we refresh their smell
			stink_to_check.refresh()
			return

	// Step 2: Apply our smell if they don't already have ours
	var/datum/status_effect/redolent/stinky_contact/applied_smell = target.apply_status_effect(/datum/status_effect/redolent/stinky_contact)
	applied_smell.redolent_scent_type = redolent_scent_type
	applied_smell.redolent_scent = redolent_scent
	applied_smell.notify_new_stinker()
	// Yes, this means a person can smell of many things at once

/datum/status_effect/redolent/stinky_contact // Temporary subtype. Works the same as normal, except it can be washed away and expire
	id = "stinky_contact"
	duration = 15 MINUTES
	tick_interval = 5 SECONDS
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = /atom/movable/screen/alert/status_effect/debuff/stinky_contact // Fancy alert letting you know you've become a stinker

/// Lets the smelly person that they have now become smelly
/datum/status_effect/redolent/stinky_contact/proc/notify_new_stinker()
	switch(redolent_scent_type)
		if(REDOLENT_SMELL_GOOD)
			to_chat(owner, span_notice("I share someone else's pleasant scent now!"))
		if(REDOLENT_SMELL_NEUTRAL)
			to_chat(owner, span_notice("I stink of someone else now..."))
		if(REDOLENT_SMELL_BAD)
			to_chat(owner, span_warning("I reek of someone else's stench now...ew..."))

/datum/status_effect/redolent/stinky_contact/on_wash(datum/source, clean)
	if(clean < CLEAN_MEDIUM) // Weak cleaning won't wash it away
		return
	to_chat(owner, span_notice("I scrub the smell away..."))
	qdel(src)

/datum/status_effect/redolent/stinky_contact/on_remove()
	to_chat(owner, span_notice("The lingering scent finally fades off me."))
	return ..()

/atom/movable/screen/alert/status_effect/debuff/stinky_contact
	name = "Musked"
	desc = "Someone's stench rubbed off on me. I should be able to wash it off, or wait it out."
	icon_state = "debuff"

/datum/quirk/hunted
	name = "Marked by Gnolls"
	desc = "For one reason or another, I have been deemed a target worthy of Graggar's champions. I hear their cackles anywhere I go."
	warning_text = "<span style='font-size:120%;'>THIS QUIRK ENCOURAGES GNOLLS TO HUNT YOU DOWN!</span><br>\
	You may potentially be killed in the process!"
	point_cost = 0
	added_traits = list(TRAIT_GNOLL_HUNTED)
	var/attempts_left = 10

// I genuinely couldn't tell you why this needs to be a thing, but it existed when hunted was a vice.
// Therefore, we're keeping the behavior now that it's a quirk.
/datum/quirk/hunted/apply_to_human(mob/living/carbon/human/recipient)
	log_hunted_pick(recipient)

/datum/quirk/hunted/proc/log_hunted_pick(mob/living/carbon/human/H)
	if(!H.name) // The vice version of hunted used Life() for its timing, so deleted mobs would automatically stop timing.
		if(attempts_left <= 0) // We're not riding off of that anymore, so let's have it give up after ten attemps a la Lawless.
			return
		attempts_left--
		addtimer(CALLBACK(src, PROC_REF(log_hunted_pick), H), 1 SECONDS)
		return
	log_hunted("[H.ckey] playing as [H.name] had the hunted trait by quirk.")

/datum/quirk/assassintarget
	name = "Marked for Death"
	desc = "Something in my past has made me a target. I'm always looking over my shoulder."
	warning_text = "<span style='font-size:120%;'>THIS QUIRK ENCOURAGES ASSASSINS TO HUNT YOU DOWN!</span><br>\
	You may be PERMANENTLY KILLED WITHOUT ESCALATION in the process!"
	point_cost = 0
	added_traits = list(TRAIT_ASSASSIN_TARGET)

/datum/quirk/nightowl
	name = "Night Owl"
	desc = "I've always preferred Noc over his other half."
	added_traits = list(TRAIT_NIGHT_OWL)

// Gives minor nobility, but what is a minor noble anyways?
// If we were being realistic then only the grand duke and baron would be real nobles.
// I guess we're saying that real nobility is people who are recognized by Astrata??????????
// Who fucking cares, bro.
/datum/quirk/noble
	name = "Noble"
	desc = "By birth, blade or brain, I carry noble blood, if only a minor and untitled line of it. I've cleverly stashed away a healthy amount of coinage, alongside a familial heirloom."
	custom_text = "This quirk grants you MINOR nobility, meaning you are still subjected to the Great Writ and poll tax."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a noble!"
	point_cost = 4
	added_traits = list(TRAIT_NOBLE)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))
	added_stashed_items = list(
	"Heirloom Amulet" = /obj/item/clothing/neck/roguetown/ornateamulet/noble,
	"Hefty Coinpurse" = /obj/item/storage/belt/rogue/pouch/coins/virtuepouch
	)
	incompatible_vices = list(/datum/charflaw/lawless)
	incompatible_quirks = list(/datum/quirk/disgracednoble, /datum/quirk/gossiper)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/noble/apply_to_human(mob/living/carbon/human/recipient)
	SStreasury.noble_incomes[recipient] += 15
	recipient.social_rank = max(recipient.social_rank, SOCIAL_RANK_MINOR_NOBLE)

/datum/quirk/outdoorsy
	name = "Outdoorsy"
	desc = "My experience in the wilds allows me to fall asleep on surfaces like treebranches as if they were beds."
	custom_text = "This does not make branches effective beds or allow you to walk on them, simply that you can sleep on them easily."
	added_traits = list(TRAIT_OUTDOORSMAN)
	incompatible_virtues = list(/datum/virtue/utility/woodwalker)

/datum/quirk/pretty
	name = "Pretty"
	desc = "I'm no great beauty, but people seem to like looking at my face well enough."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already beautiful!"
	point_cost = 2
	added_traits = list(TRAIT_PRETTY)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly)
	incompatible_traits = list(TRAIT_BEAUTIFUL)

/datum/quirk/rawdiet
	name = "Raw Diet"
	desc = "Be it from unnatural anatomy or simply a bizarre tolerance, I can eat raw meat and uncooked food as if it were natural."
	custom_text = "Lets you eat raw meat and uncooked food without getting poisoned. Rotten food, organs, and dirty water will still poison you."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that already possesses an unnatural metabolism!"
	point_cost = 2
	added_traits = list(TRAIT_RAW_EATER)
	incompatible_virtues = list(/datum/virtue/utility/feral_appetite)
	incompatible_traits = list(TRAIT_NASTY_EATER, TRAIT_ORGAN_EATER, TRAIT_WILD_EATER)

/datum/quirk/roughlover
	name = "Rough Lover"
	desc = "With strong intent, I am a violent partner in bed. Breaking pelvis and spirit alike."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a bedbreaker!"
	point_cost = 2
	added_traits = list(TRAIT_DEATHBYSNUSNU)
	incompatible_traits = list(TRAIT_DEATHBYSNUSNU)

/datum/quirk/scarred
	name = "Scarred"
	desc = "My face bears terrible scars that make identification difficult, but not impossible."
	point_cost = 0
	added_traits = list(TRAIT_SCARRED)

/datum/quirk/secondvoice
	name = "Second Voice"
	desc = "From performance, deception, or by a need to change yourself in uncanny ways, you've acquired a second, perfect voice. You may switch between them at any point."
	custom_text = "Grants access to a new 'Memory' tab. It will have the options for setting and changing your voice."
	incompatible_vices = list(/datum/charflaw/mute, /datum/charflaw/unintelligible)

/datum/quirk/secondvoice/apply_to_human(mob/living/carbon/human/recipient)
	recipient.verbs += /mob/living/carbon/human/proc/changevoice
	recipient.verbs += /mob/living/carbon/human/proc/swapvoice

/datum/quirk/ugly
	name = "Ugly"
	desc = "My face is ugly and makes everyone who looks at me miserable."
	point_cost = 0
	added_traits = list(TRAIT_UNSEEMLY)
	incompatible_virtues = list(/datum/virtue/utility/socialite)

/datum/quirk/underdarkchef
	name = "Underdark Chef"
	desc = "I've picked up a few culinary secrets from the Underdark. Spider meat is more versatile than you'd think."
	custom_text = "Allows you to prepare recipes utilizing spider meat."
	warning_text = "This quirk does nothing if you are already a drow!"
	added_traits = list(TRAIT_UNDERDARK_CHEF)

/datum/quirk/unsettling
	name = "Unsettling"
	desc = "My appearance is deeply unsettling to most. There's something profoundly wrong about my features."
	point_cost = 1
	added_traits = list(TRAIT_UNSETTLING)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly, /datum/quirk/pretty)

/datum/quirk/selfaware
	name = "Self Aware"
	desc = "I've always been conscious about how hurt my body can get."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that already has self aware!"
	added_traits = list(TRAIT_SELF_AWARE)
	incompatible_traits = list(TRAIT_SELF_AWARE)
