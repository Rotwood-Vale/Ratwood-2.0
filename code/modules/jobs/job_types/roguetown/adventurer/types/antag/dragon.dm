/datum/job/roguetown/dragon
	title = "Dragon"
	flag = DRAGON
	antag_job = TRUE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = list(/datum/species/dracon)
	tutorial = "You are an ancient dragon, guarding a hoard of treasure. Strike deals with mortals, protect your territory, and secure a future for your brood."
	outfit = null
	outfit_female = null
	display_order = JDO_DRAGON
	show_in_credits = TRUE
	min_pq = 10
	max_pq = null

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_DRAGON = 20)
	PQ_boost_divider = 10
	round_contrib_points = 4

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES
	quirk_restrictions = list(/datum/quirk/noble) // Matthios hates nobles.
	job_subclasses = list(
		/datum/advclass/dragon
	)

/datum/job/roguetown/dragon/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Ensure dragons are represented in the antagonist list.
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/dragon))
			var/datum/antagonist/new_antag = new /datum/antagonist/dragon()
			H.mind.add_antag_datum(new_antag)
			H.verbs |= /mob/living/carbon/human/proc/dragon_inspect_skin


/mob/living/carbon/human/proc/apply_dragon_preferences(initial_setup = TRUE)
	// Species swaps do not always clear extra body zones from prior forms.
	// Purge lamia/taur leftovers so dragons only use dragon body setup.
	ensure_not_taur()

	reset_dragon_sprite_scale()

	// Dragon role always belongs to Matthios, regardless of the source slot's faith.
	set_patron(/datum/patron/inhumen/matthios)

	if(initial_setup)
		// Dragons should be a blank slate at spawn; strip inherited vice/virtue state from base character prefs.
		if(length(vices))
			for(var/datum/charflaw/vice as anything in vices)
				vice.on_removal(src)
		if(charflaw && !(charflaw in vices))
			charflaw.on_removal(src)
		vices = list()
		charflaw = null

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

	icon_state = "dragon"
	dna?.species?.custom_base_icon = "dragon"

	hairstyle = "Bald"
	facial_hairstyle = "Shaved"
	// dna?.

	var/obj/item/organ/breasts/breasts = getorganslot(ORGAN_SLOT_BREASTS)
	if(breasts)
		breasts.Remove(src)
		qdel(breasts)

	update_body()
	ambushable = FALSE
	add_mob_descriptor(/datum/mob_descriptor/stature/dragon)
	return TRUE

/mob/living/carbon/human/proc/reset_dragon_sprite_scale()
	if(!dna?.features)
		return FALSE
	dna.features["body_size"] = BODY_SIZE_NORMAL
	dna.update_body_size()
	return TRUE

/datum/outfit/job/roguetown/dragon/proc/don_scales(mob/living/carbon/human/H)
	if(H.mind)
		H.apply_dragon_preferences()
		H.set_blindness(0)
		H.regenerate_icons()
		H.AddSpell(new /obj/effect/proc_holder/spell/self/claws/dragon)
		H.AddSpell(new /obj/effect/proc_holder/spell/self/message)
		H.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/spitfire)
		H.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball)
		H.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball/greater)
		H.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball/artillery)
		to_chat(H, span_boldwarning("As a Dragon, you are a political entity in the duchy. \
									You are not a mindless beast who chomps peasants and abducts cows. \
									Bargain with the lesser races, strike deals with seekers of riches, \
									and ensure a mutually profitable conclusion for you and your trading partners alike. \
									You sit in a precarious spot of not being a big enough nuisance to justify the resources it would take to hunt you down. \
									Ensure you do not draw the ire of the duchy, lest they wipe your brood off the map, once and for all."))

/mob/living/carbon/human/proc/dragon_inspect_skin()
	set name = "Inspect Scales"
	set category = "Dragon"
	set desc = "Examine your draconic scales armor"
	if(!istype(skin_armor, /obj/item/clothing/suit/roguetown/armor/regenerating/skin/dragon_armor))
		to_chat(src, span_warning("You don't have any scales to inspect!"))
		return
	var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/dragon_armor/DA = skin_armor
	DA.Topic(null, list("inspect" = "1"), src)


/datum/advclass/dragon
	name = "Dragon"
	tutorial = "You are a dragon who has decided to make the local duchy their home. Walk the fine line between self-enrichment and being hunted down for causing too much grief.\
				Strike deals with locals who stumble upon your lair, and ensure the legacy of your brood will endure for millenia to come."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/dragon)
	outfit = /datum/outfit/job/roguetown/dragon
	cmode_music = 'sound/music/combat_matthios.ogg'
	category_tags = list(CTAG_DRAGON)
	applies_post_equipment = FALSE
	traits_applied = list()
	subclass_stats = list(
		STATKEY_STR = 5,
		STATKEY_CON = 5,
		STATKEY_WIL = 5,
		STATKEY_SPD = -3,
		STATKEY_INT = 5,
		STATKEY_PER = 5
	)
	// Great wrestlers and butchers. Okay swimmers and climbers. Not very good at anything else.
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/dragon/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/dragon)
		H.def_intent_change(INTENT_PARRY)
		H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/dragon_armor(H)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		don_scales(H)
