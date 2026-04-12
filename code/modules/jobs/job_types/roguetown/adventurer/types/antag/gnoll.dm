/datum/job/roguetown/gnoll
	title = "Gnoll"
	flag = GNOLL
	antag_job = TRUE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = RACES_NO_CONSTRUCT
	tutorial = "You have proven yourself worthy to Graggar, and he's granted you his blessing most divine. Now you hunt for worthy opponents, seeking out those strong enough to make you bleed."
	outfit = null
	outfit_female = null
	display_order = JDO_GNOLL
	show_in_credits = TRUE
	min_pq = 30 //Same as wretches for now
	max_pq = null

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_GNOLL = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(/datum/virtue/utility/noble) //Are you for real?
	job_subclasses = list(
		/datum/advclass/gnoll/berserker,
		/datum/advclass/gnoll/knight,
		/datum/advclass/gnoll/templar,
		/datum/advclass/gnoll/shaman,
	)

/datum/job/roguetown/gnoll/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Ensure gnolls are represented in the antagonist list.
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/gnoll))
			var/datum/antagonist/new_antag = new /datum/antagonist/gnoll()
			H.mind.add_antag_datum(new_antag)
			H.verbs |= /mob/living/carbon/human/proc/gnoll_inspect_skin


/mob/living/carbon/human/proc/apply_gnoll_preferences(initial_setup = TRUE)
	if(!client?.prefs?.gnoll_prefs)
		return FALSE

	// Species swaps do not always clear extra body zones from prior forms.
	// Purge lamia/taur leftovers so gnolls only use gnoll body setup.
	clear_non_gnoll_bodyparts()

	reset_gnoll_sprite_scale()

	// Gnoll role always belongs to Graggar, regardless of the source slot's faith.
	set_patron(/datum/patron/inhumen/graggar)

	if(initial_setup)
		// Gnolls should be a blank slate at spawn; strip inherited vice/virtue state from base character prefs.
		if(length(vices))
			for(var/datum/charflaw/vice as anything in vices)
				vice.on_removal(src)
		if(charflaw && !(charflaw in vices))
			charflaw.on_removal(src)
		vices = list()
		charflaw = null
		statpack = null
		headshot_link = null

	// Gnolls should not inherit player-authored social metadata from their base slot.
	rumour = null
	noble_gossip = null

	if(status_traits)
		for(var/trait in status_traits.Copy())
			if(HAS_TRAIT_FROM(src, trait, TRAIT_VIRTUE))
				REMOVE_TRAIT(src, trait, TRAIT_VIRTUE)

	// Explicitly purge known lamia/mount carryover paths that can survive species swaps.
	REMOVE_TRAIT(src, TRAIT_PONYGIRL_RIDEABLE, BODY_ZONE_TAUR)
	REMOVE_TRAIT(src, TRAIT_PONYGIRL_RIDEABLE, TRAIT_VIRTUE)
	REMOVE_TRAIT(src, TRAIT_PONYGIRL_RIDEABLE, TRAIT_GENERIC)
	REMOVE_TRAIT(src, TRAIT_LAMIAN_TAIL, INNATE_TRAIT)
	REMOVE_TRAIT(src, TRAIT_LAMIAN_TAIL, TRAIT_VIRTUE)
	REMOVE_TRAIT(src, TRAIT_LAMIAN_TAIL, TRAIT_GENERIC)

	var/datum/gnoll_prefs/prefs = client.prefs.gnoll_prefs

	// Gnolls are assigned their own subclass statlines later in equip flow; wipe inherited statpack roll during initial setup only.
	if(initial_setup)
		roll_stats()
	refresh_live_vocal_preferences()

	fully_replace_character_name(real_name, prefs.ensure_gnoll_name())

	if(prefs.gnoll_pronouns)
		pronouns = prefs.gnoll_pronouns

	icon_state = prefs.pelt_type || "firepelt"
	dna?.species?.custom_base_icon = prefs.pelt_type || "firepelt"

	var/wants_penis = !!prefs.genitals["penis"]
	var/wants_vagina = !!prefs.genitals["vagina"]
	var/wants_breasts = !!prefs.genitals["breasts"]

	var/obj/item/organ/penis/penis = getorganslot(ORGAN_SLOT_PENIS)
	if(wants_penis)
		if(!penis)
			penis = new /obj/item/organ/penis/knotted/big()
			penis.Insert(src, TRUE, FALSE)
		var/obj/item/organ/testicles/testicles = getorganslot(ORGAN_SLOT_TESTICLES)
		if(!testicles)
			testicles = new()
			testicles.Insert(src, TRUE, FALSE)
	else if(penis)
		penis.Remove(src)
		qdel(penis)
		var/obj/item/organ/testicles/testicles = getorganslot(ORGAN_SLOT_TESTICLES)
		if(testicles)
			testicles.Remove(src)
			qdel(testicles)

	var/obj/item/organ/vagina/vagina = getorganslot(ORGAN_SLOT_VAGINA)
	if(wants_vagina)
		if(!vagina)
			vagina = new /obj/item/organ/vagina()
			vagina.accessory_type = /datum/sprite_accessory/vagina/furred
			vagina.Insert(src, TRUE, FALSE)
	else if(vagina)
		vagina.Remove(src)
		qdel(vagina)

	var/obj/item/organ/breasts/breasts = getorganslot(ORGAN_SLOT_BREASTS)
	if(wants_breasts)
		if(!breasts)
			breasts = new()
			breasts.Insert(src, TRUE, FALSE)
	else if(breasts)
		breasts.Remove(src)
		qdel(breasts)

	update_body()
	ambushable = FALSE
	clear_mob_descriptors()
	add_mob_descriptor(/datum/mob_descriptor/stature/gnoll)
	add_mob_descriptor(prefs.descriptor_height || /datum/mob_descriptor/height/moderate)
	add_mob_descriptor(prefs.descriptor_body || /datum/mob_descriptor/body/muscular)
	add_mob_descriptor(prefs.descriptor_fur || /datum/mob_descriptor/fur/coarse)
	add_mob_descriptor(prefs.descriptor_voice || /datum/mob_descriptor/voice/growly)
	add_mob_descriptor(prefs.descriptor_muzzle || /datum/mob_descriptor/face/gnoll/long_muzzle)
	add_mob_descriptor(prefs.descriptor_expression || /datum/mob_descriptor/face_exp/gnoll/alert)
	return TRUE

/mob/living/carbon/human/proc/clear_non_gnoll_bodyparts()
	for(var/obj/item/bodypart/part as anything in bodyparts.Copy())
		if(part.body_zone != BODY_ZONE_TAUR)
			continue
		part.drop_limb(1)
		qdel(part)

	// Taur bodies replace both legs, so restore a standard biped layout.
	ensure_not_taur()

/mob/living/carbon/human/proc/reset_gnoll_sprite_scale()
	if(!dna?.features)
		return FALSE
	dna.features["body_size"] = BODY_SIZE_NORMAL
	dna.update_body_size()
	return TRUE

/datum/outfit/job/roguetown/gnoll/proc/don_pelt(mob/living/carbon/human/H)
	if(H.mind)
		H.apply_gnoll_preferences()
		H.set_blindness(0)
		H.regenerate_icons()
		H.AddSpell(new /obj/effect/proc_holder/spell/self/claws/gnoll)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/howl/gnoll)
		H.AddComponent(/datum/component/gnoll_combat_tracker)

		var/obj/effect/proc_holder/spell/invoked/gnoll_sniff/F = new()
		var/obj/effect/proc_holder/spell/invoked/invisibility/gnoll/I = new()

		var/obj/effect/proc_holder/spell/invoked/abduct/S = new /obj/effect/proc_holder/spell/invoked/abduct()
		S.destination_turf = get_turf(H) // Set the anchor to where they spawn/don the outfit
		H.AddSpell(S)
		H.AddSpell(F)
		H.AddSpell(I)

		to_chat(H, span_boldwarning("As a Gnoll, roleplaying expectations still apply. Gnolls are cunning hunters, not mindless beasts. \
									The Dark Star expects much of you; there is little glory in slaughtering the meek."))
		to_chat(H, span_biginfo("You are not interested in the lowest-hanging fruit, and effortless catches bore your Master. Rushing to take these quarries is <i>beneath you.</i> \n") \
			+ span_notice("Rather, it is best to seek the worthiest among your prey, and to ensure a thrilling hunt for all involved."))
		to_chat(H, span_biginfo("*-------*"))

		var/mode = SSgnoll_scaling.get_gnoll_scaling()
		if(mode == GNOLL_SCALING_NONE)
			to_chat(H, span_smallnotice("There will not be any gnoll reinforcements this week, as far as I can tell. ") + span_info("I must rely on cunning over numbers."))
		else if(mode != GNOLL_SCALING_DOUBLE)
			to_chat(H, span_smallnotice("I can expect to be joined by my pack this week. ") + span_info("I should wait for them and group up."))
		else
			to_chat(H, span_smallnotice("My pack is small this week. ") + span_info("I should regroup with the other gnolls, and avoid reckless fights until we can hunt together."))
		to_chat(H, span_info("Patience and careful planning are the virtues of my craft. If I can't isolate my mark, it would be wise to stalk another. \n\
									When tracking difficult marks, I should set up camp and make alliances out in the field."))
		to_chat(H, span_warning("The Bandit filth are unworthy of my assistance."))
		to_chat(H, span_biginfo("*------*"))

/mob/living/carbon/human/proc/gnoll_inspect_skin()
	set name = "Inspect Pelt"
	set category = "Gnoll"
	set desc = "Examine your gnoll skin armor"
	if(!istype(skin_armor, /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor))
		to_chat(src, span_warning("You don't have any gnoll skin armor to inspect!"))
		return
	var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/GA = skin_armor
	GA.Topic(null, list("inspect" = "1"), src)
