/datum/advclass/gnoll_impure
	name = "Impure Gnoll"
	allowed_races = RACES_NO_CONSTRUCT
	tutorial = "You have proven yourself worthy to Graggar, and he's granted you his blessing most divine. Now you hunt for worthy opponents, seeking out those strong enough to make you bleed."
	min_pq = 0
	applies_post_equipment = FALSE

	category_tags = list(CTAG_GNOLL_IMPURE)
	outfit = /datum/outfit/job/roguetown/gnoll_impure
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_UNLYCKERABLE)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 5,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2
	)
	// Despite being flavored as a blank slate, we do want them to be fun to fight
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
	)
	cmode_music = 'sound/music/combat_graggar.ogg'

/datum/outfit/job/roguetown/gnoll_impure

/datum/outfit/job/roguetown/gnoll_impure/pre_equip(mob/living/carbon/human/H)
	if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/gnoll))
		var/datum/antagonist/new_antag = new /datum/antagonist/gnoll()
		H.mind.add_antag_datum(new_antag)
		H.verbs |= /mob/living/carbon/human/proc/gnoll_inspect_skin
	H.set_species(/datum/species/gnoll)
	H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/impure(H)
	don_pelt(H)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/impure
	icon_state = null
	max_integrity = 400
	repair_time = 14 SECONDS
	armor = ARMOR_GNOLL_WEAK

/datum/outfit/job/roguetown/gnoll_impure/proc/don_pelt(mob/living/carbon/human/H)
	if(H.mind)
		H.apply_gnoll_preferences()

		H.set_blindness(0)
		H.regenerate_icons()
		H.AddSpell(new /obj/effect/proc_holder/spell/self/claws/gnoll)
		H.set_patron(/datum/patron/inhumen/graggar)

		to_chat(H, span_bignotice("Born out of echoes of violence, I am no true champion of graggar. But whoever summoned me is, even if they don't heed his call. They've bested his mightiests gnolls, ready to provide a worthy challenge. As long as they don't deny me worthy duels, I shall serve them."))
