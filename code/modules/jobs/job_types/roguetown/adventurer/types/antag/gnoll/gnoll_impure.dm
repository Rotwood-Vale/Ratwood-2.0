/datum/advclass/gnoll_impure
	name = "不纯豺狼人"
	allowed_races = RACES_NO_CONSTRUCT
	tutorial = "你已向 格拉加 证明了自己的价值，而他也赐下了至高的祝福。如今你要去追猎配得上你的对手，寻找那些强到足以让你流血的人。"
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

		to_chat(H, span_bignotice("我诞生于暴力的余响，并非 格拉加 真正的冠军。可召来我的那人却是，即便他们并未回应他的呼唤。他们击败了他最强大的豺狼人，足以献上一场配得上的挑战。只要他们不拒绝我应得的决斗，我便会为其效力。"))
