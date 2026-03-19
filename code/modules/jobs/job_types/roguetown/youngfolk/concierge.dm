//A mostly harmless but supernatural assistant for Wretches.
/datum/job/roguetown/concierge
	title = "Concierge"
	flag = CONCIERGE
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = RACES_NO_CONSTRUCT //The Powers That Be would not give their agent an inorganic form. Also to filter out robot roleplayers.
	tutorial = "Assigned by The Powers That Be to cater to this world's particularly wicked individuals of interest, you have been granted an almost perfect disguise, but you are authorised to use only a fraction of your former power, and you may not harm inhabitants of this plane of existence. Directly."
	cmode_music = 'sound/music/combat_maniac2.ogg'

	spells = list(/obj/effect/proc_holder/spell/invoked/diagnose/secular, /obj/effect/proc_holder/spell/targeted/touch/prestidigitation, /obj/effect/proc_holder/spell/invoked/mending, /obj/effect/proc_holder/spell/self/recall, /obj/effect/proc_holder/spell/invoked/mirror_transform, /obj/effect/proc_holder/spell/invoked/create_campfire, /obj/effect/proc_holder/spell/self/message)
	outfit = /datum/outfit/job/roguetown/concierge
	display_order = JDO_CONCIERGE
	show_in_credits = FALSE
	min_pq = 30 //Not high grief potential, but high roleplaying standards
	max_pq = null

	obsfuscated_job = TRUE
	class_categories = TRUE

	advclass_cat_rolls = list(CTAG_CONCIERGE = 2)
	job_subclasses = list(
		/datum/advclass/concierge
	)
	PQ_boost_divider = 10
	round_contrib_points = 3

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(/datum/virtue/heretic/zchurch_keyholder, /datum/virtue/utility/noble, /datum/virtue/combat/rotcured, /datum/virtue/utility/resident) //There probably should be more restrictions
	carebox_table = /datum/carebox_table/wretch
	job_traits = list(TRAIT_STEELHEARTED,
	TRAIT_OUTLAW,
	TRAIT_HERESIARCH,
	TRAIT_SELF_SUSTENANCE,
	TRAIT_ZURCH,
	TRAIT_CRITICAL_RESISTANCE,
	TRAIT_DECEIVING_MEEKNESS,
	TRAIT_NOSTINK,
	TRAIT_EMPATH,
	TRAIT_EXTEROCEPTION,
	TRAIT_NOPAIN,
	TRAIT_NOMOOD,
	TRAIT_NOBREATH,
	TRAIT_NOHUNGER,
	TRAIT_SHOCKIMMUNE,
	TRAIT_GRAVEROBBER,
	TRAIT_PACIFISM,
	TRAIT_ANTISCRYING,
	TRAIT_DARKVISION,
	TRAIT_TOLERANT,
	TRAIT_SEEPRICES,
	TRAIT_CICERONE,
	TRAIT_SEEDKNOW,
	)

/datum/job/roguetown/concierge/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Assign wretch antagonist datum so wretches appear in antag list
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/wretch))
			var/datum/antagonist/new_antag = new /datum/antagonist/wretch()
			H.mind.add_antag_datum(new_antag)
		if(H.charflaw)
			QDEL_NULL(H.charflaw) //Get rid of the player's chosen vice, because they already start with Unsettling Beauty.

/datum/advclass/concierge
	name = "Concierge"
	tutorial = "Assigned by The Powers That Be to cater to this world's particularly wicked individuals of interest, you have been granted an almost perfect disguise, but you are authorised to use only a fraction of your former power, and you may not harm inhabitants of this plane of existence. Directly."
	outfit = /datum/outfit/job/roguetown/concierge/basic
	category_tags = list(CTAG_CONCIERGE)
	subclass_stats = list(
		STATKEY_INT = 2,
	) //+2 INT to learn skills a bit faster, but otherwise has no need for stats.
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry= SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/concierge/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_patron(/datum/patron/godless)
	pants = /obj/item/clothing/under/roguetown/trou/formal
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	backl = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/suspenders/butler
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/flint = 1,
		/obj/item/rope/chain = 1,
		/obj/item/soap = 1,
		)
