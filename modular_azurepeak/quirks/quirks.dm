// Quirks are mostly for flavor or provide very little (or focused on roleplay) benefits.
// At best they should be very minor conveniences as a reward for leaning into vices.
// The baseline point_cost is one.

/datum/quirk/blooddrinker
	name = "Blood Drinker"
	point_cost = 1
	desc = "Blood quenches my thirst without turning my stomach."
	custom_text = "Drinking blood, including dirty blood, restores one third as much thirst as the same amount of water, without blood-induced nausea. Normal food and water remain usable."
	warning_text = "This quirk costs nothing and does not apply to Hemophages, Vampires, Lickers, or others who already do not need food or water when their quirks are applied."
	added_traits = list(TRAIT_BLOOD_DRINKER)
	incompatible_traits = list(TRAIT_HEMOPHAGE, TRAIT_NOHUNGER)

/datum/quirk/blooddrinker/blocked_by_incompatible_traits(mob/living/carbon/human/recipient)
	if(recipient.spawned_as_licker)
		return "Licker"
	return ..()

/datum/quirk/amphibious
	name = "Amphibious"
	point_cost = 1
	desc = "Through some quirk of my heritage, I can breathe in water just as readily as in air."
	custom_text = "Allows breathing underwater."
	added_traits = list(TRAIT_WATERBREATHING)

/datum/quirk/fat_knot
	name = "Fat Knot"
	point_cost = 0
	desc = "My knot is thick enough to always keep partners stuck on it."
	custom_text = "Counts as Large cock size for movement retention. This lets you always drag knotted people behind you hands-free."
	added_traits = list(TRAIT_FAT_KNOT)

/datum/quirk/high_production
	name = "High Production"
	point_cost = 0
	desc = "My body produces a larger volume of seed than average."
	custom_text = "Counts as having Large testicle size for how much cum you can store and release."
	added_traits = list(TRAIT_HIGH_PRODUCTION)

/datum/quirk/acquiredtastes
	name = "Acquired Tastes"
	desc = "Despite my unorthodox tastes, I'm always prepared to handle a guest with the toys, assorted gear and emberwine I keep stashed."
	custom_text = "Adds a Bag of Fetish Gear containing a blindfold, a rope leash, a leather collar, regular and flat chastity cages, a chastity belt, emberwine, a wooden toy, cloth, a chain, a whip, and a branding iron to your stash."
	added_stashed_items = list("Bag of Fetish Gear" = /obj/item/storage/roguebag/fetish)

/datum/quirk/accursedtastes
	name = "Accursed Tastes"
	desc = "Some keepsakes are harder to part with than others. I keep an assortment of toys and a cursed collar and cursed chastity cage stashed for the right company."
	custom_text = "Adds a Bag of Cursed Fetish Gear containing a cursed collar and chastity cage, a blindfold, a rope leash, emberwine, a wooden dildo, cloth, a chain, a whip, and a branding iron to your stash."
	added_stashed_items = list("Bag of Cursed Fetish Gear" = /obj/item/storage/roguebag/cursed_keepsakes)
	incompatible_quirks = list(/datum/quirk/acquiredtastes)

/datum/quirk/saccharine_keepsake
	name = "Saccharine Keepsake"
	point_cost = 1
	desc = "I keep a pink crayon imbued with Baotha's saccharine blessing."
	custom_text = "Adds a reusable magical crayon to your stash. Any holder can use it to draw Baotha's fertility mark on a character's exposed lower abdomen. It enables pregnancy without the usual reproductive anatomy."
	added_stashed_items = list("Saccharine Crayon" = /obj/item/baotha_crayon)

/datum/quirk/dream_dust
	name = "Dream Dust"
	point_cost = 2
	desc = "I keep a little dream dust tucked away for when the occasion calls for it."
	custom_text = "Adds a bag containing three portions of Zizo's Bane powder to your stash."
	added_stashed_items = list("Bag of Zizo's Bane Powder" = /obj/item/storage/roguebag/zizobane_stash)

/datum/quirk/overly_fertile
	name = "Overly Fertile"
	point_cost = 0
	desc = "Life finds fertile ground in me. My body has an unusual gift for nurturing new life, even where nature would ordinarily draw the line."
	custom_text = "Restores fertility to existing reproductive organs and manticore tails, enables pregnancy without the usual reproductive anatomy, and grants the same increased pregnancy chance as Marked by Baotha. Does not add a brand or an addiction, and does not stack with Baotha's fertility boon."
	added_traits = list(TRAIT_OVERLY_FERTILE)

/datum/quirk/overly_fertile/apply_to_human(mob/living/carbon/human/recipient)
	var/obj/item/organ/vagina/reproductive_organ = recipient.getorganslot(ORGAN_SLOT_VAGINA)
	if(reproductive_organ)
		reproductive_organ.fertility = TRUE
	var/obj/item/organ/tail/manticore/tail = get_manticore_tail(recipient)
	if(tail)
		tail.fertility = TRUE

/datum/quirk/orgasmdenier
	name = "Orgasm Denier"
	point_cost = 0
	desc = "I know just when to hold back, leaving my partner wanting more."
	custom_text = "Adds an Orgasm Denial toggle to your ERP panel, off by default. During paired panel actions, it can prevent your partner's climax and reset their arousal to 30, if they have Enable Edging Content turned on. Denial adds 6 stress for 5 minutes without stacking; a successful climax clears it."
	added_traits = list(TRAIT_ORGASM_DENIER)

/datum/quirk/heightened_sensitivity
	name = "Heightened Sensitivity"
	point_cost = 0
	desc = "Even the slightest stimulation sends a shiver through me."
	custom_text = "Receive four times the usual arousal from arousal gains, excluding standard solo panel actions."
	added_traits = list(TRAIT_HEIGHTENED_SENSITIVITY)
	incompatible_quirks = list(/datum/quirk/dulled_sensitivity)
	incompatible_traits = list(TRAIT_DULLED_SENSITIVITY)

/datum/quirk/dulled_sensitivity
	name = "Dulled Sensitivity"
	point_cost = 0
	desc = "It takes more stimulation to stir my senses."
	custom_text = "Receive half the usual arousal from arousal gains, excluding standard solo panel actions."
	added_traits = list(TRAIT_DULLED_SENSITIVITY)
	incompatible_quirks = list(/datum/quirk/heightened_sensitivity)
	incompatible_traits = list(TRAIT_HEIGHTENED_SENSITIVITY)

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
	point_cost = 0
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
	warning_text = "This quirk does not apply if you are playing a role that is already a fabled lover!"
	point_cost = 1
	added_traits = list(TRAIT_GOODLOVER)
	incompatible_virtues = list(/datum/virtue/utility/socialite, /datum/virtue/background/performer)
	incompatible_traits = list(TRAIT_GOODLOVER)

/datum/quirk/gossiper
	name = "Gossiper"
	desc = "Despite my lowborn blood, I've made a habit out of brushing shoulders with the nobility and learning their secrets."
	custom_text = "Lets you view noble gossip."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a noble!"
	point_cost = 1
	added_traits = list(TRAIT_GOSSIPER)
	incompatible_virtues = list(/datum/virtue/background/tracker)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/hobbyistmusician
	name = "Hobbyist Musician"
	desc = "I've dabbled in music over the years, and I've stashed away an instrument of my own."
	custom_text = "Comes with a stashed instrument of your choice. You choose the instrument after spawning in."
	added_skills = list(list(/datum/skill/misc/music, 1, 6))

/datum/quirk/hobbyistmusician/apply_to_human(mob/living/carbon/human/recipient)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/customization_trait, pick_stashed_instrument), recipient), 50)

/datum/quirk/largeframe
	added_traits = list(TRAIT_LARGE_FRAME)
	name = "Large Frame"
	desc = "I'm simply built bigger than most. My strength and hardiness has nothing to show for my size, though."
	custom_text = "This quirk increases your sprite size. Incompatible with the Giant virtue."
	point_cost = 0
	incompatible_virtues = list(/datum/virtue/size/giant)

/datum/quirk/largeframe/apply_to_human(mob/living/carbon/human/recipient)
	recipient.transform = recipient.transform.Scale(1.25, 1.25)
	recipient.transform = recipient.transform.Translate(0, (0.25 * 16))
	recipient.update_transform()

/datum/quirk/resilientlover
	name = "Resilient Lover"
	desc = "My body is resilient during intimacy."
	custom_text = "Take one third of oxygen and brute damage from ERP panel mechanics and prevent pelvis and jaw fractures from those actions. Automatic pain complaints are suppressed; critical pain sounds become softer groans while preserving sadomasochistic vices satisfaction."
	point_cost = 0
	added_traits = list(TRAIT_RESILIENT_LOVER)

/datum/quirk/poppable
	name = "Size Sensitive"
	desc = "My body is fragile during intimacy."
	custom_text = "Run the risk of being seriously, fatally injured during rough intimacy."
	point_cost = 0
	added_traits = list(TRAIT_POPPABLE)

/datum/quirk/redolent
	name = "Redolent"
	desc = "My body odor is strong and distinct. Without regular baths, others will notice..."
	point_cost = 1
	added_traits = list(TRAIT_REDOLENT)

/datum/quirk/redolent/apply_to_human(mob/living/carbon/human/recipient)
	recipient.redolent_scent_type = recipient.client?.prefs?.redolent_type || "Neutral"
	recipient.redolent_scent = recipient.client?.prefs?.redolent_scent || ""

// Redolent scent state and behavior. This is purely quirk-driven now: the quirk applies
// TRAIT_REDOLENT, the mob holds the scent state, and life.dm drives handle_redolent_scent().
/mob/living/carbon/human
	/// How others perceive our scent: "Gross", "Neutral" or "Pleasant".
	var/redolent_scent_type = "Neutral"
	/// Player-written description of our scent.
	var/redolent_scent = ""
	/// Bathing suppresses our scent until this world.time.
	var/redolent_suppressed_until = 0
	/// The last time our scent aura pulsed.
	var/redolent_last_aura_tick = 0

/mob/living/carbon/human/proc/is_redolent_reeking()
	return HAS_TRAIT(src, TRAIT_REDOLENT) && world.time >= redolent_suppressed_until

/mob/living/carbon/human/proc/redolent_on_bath()
	redolent_suppressed_until = world.time + 30 MINUTES
	remove_status_effect(/datum/status_effect/debuff/redolent_stink)
	to_chat(src, span_notice("I scrub the stink away. I should stay fresh for a while."))

/mob/living/carbon/human/proc/redolent_apply_contact_stink(mob/living/carbon/human/target)
	target.apply_status_effect(/datum/status_effect/debuff/stinky_contact, redolent_scent_type, redolent_scent)

/mob/living/carbon/human/proc/handle_redolent_scent()
	var/should_reek = is_redolent_reeking() && can_smell()

	if(should_reek && mind?.antag_datums)
		for(var/datum/antagonist/D in mind.antag_datums)
			if(istype(D, /datum/antagonist/vampire/lord) || istype(D, /datum/antagonist/werewolf) || istype(D, /datum/antagonist/skeleton) || istype(D, /datum/antagonist/zombie) || istype(D, /datum/antagonist/lich))
				should_reek = FALSE
				break

	if(should_reek && redolent_scent_type != "Pleasant")
		apply_status_effect(/datum/status_effect/debuff/redolent_stink)
	else
		remove_status_effect(/datum/status_effect/debuff/redolent_stink)

	if(!should_reek)
		return
	if(world.time < redolent_last_aura_tick + redolent_aura_tick_delay(redolent_scent_type))
		return
	redolent_last_aura_tick = world.time
	redolent_visual_effect(src, redolent_scent_type)
	redolent_stink_aura(src, redolent_scent_type)

/// Scent immunity prevents discomfort, not recognition of a smell.
/mob/living/carbon/human/proc/get_redolent_examine_lines(mob/user)
	var/list/lines = list()
	if(!user || user == src)
		return lines
	var/turf/scent_turf = get_turf(src)
	var/turf/viewer_turf = get_turf(user)
	if(!scent_turf || !viewer_turf || scent_turf.z != viewer_turf.z || get_dist(viewer_turf, scent_turf) > 3)
		return lines
	if(isliving(user))
		var/mob/living/living_user = user
		if(!living_user.can_smell())
			return lines
	if(is_redolent_reeking())
		lines += redolent_examine_text(redolent_scent_type, redolent_scent)
	var/datum/status_effect/debuff/stinky_contact/contact_stink = has_status_effect(/datum/status_effect/debuff/stinky_contact)
	if(contact_stink)
		lines |= contact_stink.get_examine_text()
	return lines

/proc/redolent_aura_tick_delay(scent_type)
	return 30 SECONDS

/proc/redolent_examine_text(scent_type, scent)
	var/scent_text = html_encode(scent || "an unusual scent")
	switch(scent_type)
		if("Gross")
			return span_greentext("They reek of [scent_text].")
		if("Pleasant")
			return "<span style='color:#FFB6C1'>They smell of [scent_text].</span>"
	return "<span style='color:#d8cf8a'>They smell of [scent_text].</span>"

/proc/redolent_visual_effect(mob/living/carbon/human/H, scent_type)
	switch(scent_type)
		if("Gross")
			new /obj/effect/temp_visual/flies(get_turf(H))
		if("Pleasant")
			new /obj/effect/temp_visual/pleasant_scent(get_turf(H))

/proc/redolent_stink_aura(mob/living/carbon/human/H, scent_type)
	for(var/mob/living/nearby in view(2, H))
		if(nearby == H)
			continue
		if(nearby.stat)
			continue
		if(!nearby.can_smell())
			continue
		if(HAS_TRAIT(nearby, TRAIT_NOSTINK))
			continue
		if(HAS_TRAIT(nearby, TRAIT_NOBREATH))
			continue
		switch(scent_type)
			if("Gross")
				if(!nearby.has_stress_event(/datum/stressevent/stinky_aura))
					to_chat(nearby, "<span class='warning' style='color:#48c75a'>Something nearby reeks.</span>")
					nearby.add_stress(/datum/stressevent/stinky_aura)
			if("Neutral")
				if(!nearby.has_stress_event(/datum/stressevent/prominent_scent))
					to_chat(nearby, "<span class='warning' style='color:#d8cf8a'>There's a prominent scent in the air.</span>")
					nearby.add_stress(/datum/stressevent/prominent_scent)
			if("Pleasant")
				if(!nearby.has_stress_event(/datum/stressevent/pleasant_scent))
					to_chat(nearby, "<span class='warning' style='color:#ffb6c1'>A pleasant scent drifts through the air.</span>")
					nearby.add_stress(/datum/stressevent/pleasant_scent)

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

/datum/quirk/hunted/handle_traits(mob/living/carbon/human/recipient)
	. = ..()
	if(recipient.islatejoin && !recipient.hunted_latejoin_announced)
		// Finish applying the quirk and class setup before advertising a trackable target.
		addtimer(CALLBACK(recipient, TYPE_PROC_REF(/mob/living/carbon/human, announce_hunted_latejoin)), 0)

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
	desc = "By birth, blade or brain, I carry noble blood, if only a minor and untitled line of it, with no estate to support me. I've kept a familial heirloom as a reminder of my lineage."
	custom_text = "This quirk grants only MINOR nobility, without estate income or the Great Writ's tax exemption."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a noble!"
	point_cost = 1
	added_traits = list(TRAIT_NOBLE)
	added_skills = list(list(/datum/skill/misc/reading, 1, 6))
	added_stashed_items = list(
	"Heirloom Amulet" = /obj/item/clothing/neck/roguetown/ornateamulet/noble
	)
	incompatible_vices = list(/datum/charflaw/lawless)
	incompatible_quirks = list(/datum/quirk/disgracednoble, /datum/quirk/gossiper)
	incompatible_traits = list(TRAIT_NOBLE)

/datum/quirk/noble/apply_to_human(mob/living/carbon/human/recipient)
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
	point_cost = 1
	added_traits = list(TRAIT_PRETTY)
	incompatible_virtues = list(/datum/virtue/utility/socialite)
	incompatible_quirks = list(/datum/quirk/ugly)
	incompatible_traits = list(TRAIT_BEAUTIFUL)

/datum/quirk/rawdiet
	name = "Raw Diet"
	desc = "Be it from unnatural anatomy or simply a bizarre tolerance, I can eat raw meat and uncooked food as if it were natural."
	custom_text = "Lets you eat raw meat and uncooked food without getting poisoned. Rotten food, organs, and dirty water will still poison you."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that already possesses an unnatural metabolism!"
	point_cost = 1
	added_traits = list(TRAIT_RAW_EATER)
	incompatible_virtues = list(/datum/virtue/utility/feral_appetite)
	incompatible_traits = list(TRAIT_NASTY_EATER, TRAIT_ORGAN_EATER, TRAIT_WILD_EATER)

/datum/quirk/roughlover
	name = "Rough Lover"
	desc = "With strong intent, I am a violent partner in bed. Breaking pelvis and spirit alike."
	warning_text = "This quirk costs nothing and does not apply if you are playing a role that is already a bedbreaker!"
	point_cost = 0
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

/datum/quirk/virgin
	name = "Virgin"
	point_cost = 0
	desc = "I am inexperienced with intimacy, and attractive people leave me flustered."
	custom_text = "Starts you as a virgin. Choose who attracts you. Their company and touch can leave you flustered; unwanted attention feels uncomfortable. Your first experience replaces these nerves with brief confidence or unease. Anal first experiences are tracked separately."
	added_traits = list(TRAIT_VIRGIN_NERVES)

/datum/quirk/virgin/apply_to_human(mob/living/carbon/human/recipient)
	recipient.virginity = TRUE
	recipient.anal_virginity = TRUE
	recipient.AddComponent(/datum/component/virgin_nerves)
	recipient.AddComponent(/datum/component/anal_inexperience)
