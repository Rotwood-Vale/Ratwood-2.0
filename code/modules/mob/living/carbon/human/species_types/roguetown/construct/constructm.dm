/mob/living/carbon/human/species/construct/metal
	race = /datum/species/construct/metal
	construct = 1

/datum/species/construct/metal
	name = "Metal Construct"
	id = "constructm"
	desc = "<b>Metallic Construct</b><br>\
	Masterworks of artifice, metal constructs are as the name implies- entirely constructed by mortal hands. They are beings not of flesh and blood, but cold metal and the arcyne. Constructs are said to originate from works of Zizo, and they hail from the far-off lands of the Southern Empty- a great city of artifice, where the only artificers capable of understanding what is necessary to create the constructs live. For some reason, they have found themselves travelling out of the empty, as of late. Children of the Resonator Siphon.<br>\
	(+1 Willpower, -2 Speed)<br>\
	(Insomnia, No hunger, no blood.)"

	construct = 1
	skin_tone_wording = "Material"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY,NOBLOOD)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = 1
	possible_ages = ALL_AGES_LIST
	skinned_type = /obj/item/ingot/steel
	disliked_food = NONE
	liked_food = NONE
	inherent_traits = list(
		TRAIT_NOHUNGER,
		TRAIT_BLOODLOSS_IMMUNE,
		TRAIT_NOBREATH,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_TOXIMMUNE,
		TRAIT_NOSLEEP,
		TRAIT_NOMETABOLISM,
		TRAIT_NOPAIN,
		)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mcom.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fcom.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_BREASTS = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		OFFSET_BREASTS_F = list(0,-1), \
		)
	race_bonus = list(STAT_WILLPOWER = 1, STAT_SPEED = -2)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/construct,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/construct,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/construct,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/construct,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/construct,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/construct,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/construct,
		)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/crest,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/ears/demihuman,
		/datum/customizer/organ/horns/demihuman,
		/datum/customizer/organ/tail/demihuman,
		/datum/customizer/organ/snout/anthro,
		/datum/customizer/organ/wings/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/testicles/anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/construct_plating_light,
		/datum/body_marking_set/construct_plating_medium,
		/datum/body_marking_set/construct_plating_heavy,
		)
	body_markings = list(
		/datum/body_marking/eyeliner,
		/datum/body_marking/plain,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/construct_plating_light,
		/datum/body_marking/construct_plating_medium,
		/datum/body_marking/construct_plating_heavy,
		/datum/body_marking/construct_head_standard,
		/datum/body_marking/construct_head_round,
		/datum/body_marking/construct_standard_eyes,
		/datum/body_marking/construct_visor_eyes,
		/datum/body_marking/construct_psyclops_eye,
	)

	restricted_virtues = list(/datum/virtue/utility/noble, /datum/virtue/utility/deathless)

/datum/species/construct/metal/check_roundstart_eligible()
	return TRUE

/datum/species/construct/metal/get_skin_list()
	return list(
		"Brass" = CONSTRUCT_BRASS,
		"Iron" = CONSTRUCT_IRON,
		"Steel" = CONSTRUCT_STEEL,
		"Bronze" = CONSTRUCT_BRONZE,
		"Toper" = CONSTRUCT_TOPER,
		"Coal" = CONSTRUCT_COAL,
		"Cobalt" = CONSTRUCT_COBALT,
		"Granite" = CONSTRUCT_GRANITE,
		"Jade" = CONSTRUCT_JADE,
		"Amythortz" = CONSTRUCT_AMETHYST,
		"Silver" = CONSTRUCT_SILVER,
		"Coral" = CONSTRUCT_CORAL,
		"Gold" = CONSTRUCT_GOLD,
		"Limestone" = CONSTRUCT_LIMESTONE,
		"Copper" = CONSTRUCT_COPPER,
		"Rust" = CONSTRUCT_RUST,
		"Obsidian" = CONSTRUCT_OBSIDIAN,
		"Lapis" = CONSTRUCT_LAPIS,
		"Basalt" = CONSTRUCT_BASALT
	)

/datum/species/construct/metal/get_hairc_list()
	return sortList(list(

	"black - midnight" = "1d1b2b",

	"red - blood" = "822b2b"

	))

/datum/species/construct/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.construct = TRUE

/datum/species/construct/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.construct = FALSE


//construct upgrade item so they can gain skills
/obj/item/construct_skill_core
	icon = 'icons/roguetown/items/misc.dmi'
	name = "construct skill exhibitor"
	desc = "A series of gears joined around a copper rod. When inserted into a Construct's head, it will allow them to grow their skills beyond their original design."
	icon_state = "construct_upgrade"
	w_class = WEIGHT_CLASS_SMALL
	smeltresult = /obj/item/ingot/bronze
	///allow construct to use it on themselves without skill reqs, exclusively used for the black market ver
	var/self_usable = FALSE
	///to avoid situations where the dialog box is open but you click the golem again with it
	var/in_use = FALSE 

/obj/item/construct_skill_core/blackmarket
	name = "modified construct skill exhibitor"
	desc = "A series of gears joined around a copper rod. When inserted into a Golem's head, it will allow them to grow their skills beyond their original design. This one looks like it was purposefully altered to allow Golems to use it themselves."
	self_usable = TRUE

/obj/item/construct_skill_core/examine(mob/user)
	. = ..()
	if(in_use)
		. += span_warning("It's spinning and whirring.")

/obj/item/construct_skill_core/attack(mob/living/T, mob/U)
	if(!ishuman(U))
		return
	var/mob/living/user = U
	if(!ishuman(T))
		to_chat(user, span_warning("[T] is not a Construct. It will have no effect."))
		return

	var/mob/living/carbon/human/M = T
	if(!M.construct)
		if(user == M)
			to_chat(user, span_warning("I am not a Construct. It will have no effect."))//Golems can't upgrade themselves anyway, but I think it's at least somewhat useful to say something when an organic tries to use it on themselves
		else
			to_chat(user, span_warning("[M] is not a Construct. It will have no effect."))
		return
	if(user.construct && !self_usable)
		to_chat(user, span_warning("I am unable to modify Constructs. I must ask another."))//Golems NEED to ask organics to modify them.
		return
	if(user.get_skill_level(/datum/skill/craft/engineering) < 3 && !self_usable) //need to be at least level 3 skill level in engineering to use this
		to_chat(user, span_warning("I fiddle around trying to properly insert [src] into [M], but I'm not skilled enough."))
		return
	if(in_use)
		to_chat(user, span_warning("I can't- [src] is still working."))
		return

	var/list/learnable_skills = list()
	var/list/skill_datums = list()
	if(!M.mind)
		return
	for(var/skill_type in SSskills.all_skills)
		var/datum/skill/skill = GetSkillRef(skill_type)
		if(skill in M.skills?.known_skills)
			if(M?.mind?.sleep_adv.enough_sleep_xp_to_advance(skill_type, 1))
				LAZYADD(learnable_skills, skill)//we need the actual names of the skill_types so the dialog boxes say "Skill" rather than the type path
				LAZYADD(skill_datums,skill_type)//hold the skill datums so we can reference them later to use in our leveling up procs

	if(!length(learnable_skills))//don't waste the core if we can't use it
		to_chat(user, span_warning("[M] has no new skills to develop."))
		return

	in_use = TRUE
	smeltresult = null //edge case where you'd fully activate it and then smelt it before the golem selects their skill to level, I like denying the smelt more than denying the skill up
	var/time_to_upgrade = 130
	time_to_upgrade -= (user.get_skill_level(/datum/skill/craft/engineering) * 10)//starts at 10 seconds normally, reduced by 1 second per each engineering skill level above 3

	user.visible_message(span_notice("[user] presses [src] against [M]'s head."), span_notice("I begin to insert [src] into [M]'s head."))
	if(!do_mob(user, M, time_to_upgrade))
		disable()
		return

	var/skill_choice = input(M, "Improve yourself.","Skills") as null|anything in learnable_skills
	if(!skill_choice)
		return
	for(var/real_skill in skill_datums)//really ugly but I can't think of a way to implement this to show the skill names properly in the dialog box. real_skill is the actual datum for the skill rather than the "Skill" string
		if(skill_choice == GetSkillRef(real_skill))
			if(!M?.mind?.sleep_adv.enough_sleep_xp_to_advance(real_skill, 1))//this should only ever happen if you try and install two knowledge cores at the same time for the same skill, which we don't want to happen
				user.visible_message(span_notice("[src] fizzles in [user]'s hand."), span_notice("[src] fizzles and returns to a resting state."))
				disable()
				return
			M.mind.sleep_adv.adjust_sleep_xp(real_skill, -M.mind.sleep_adv.get_requried_sleep_xp_for_skill(real_skill, 1))
			M.adjust_skillrank(real_skill, 1, FALSE)
			//GLOB.scarlet_round_stats[STATS_SKILLS_DREAMED]++ //up for debate whether golems gaining skills like this should count
			M.visible_message(span_notice("[M] absorbs [src]."), span_notice("I absorb [src] into myself, becoming more skilled."))
			if(M.get_skill_level(real_skill) >= 4)//if our skill is now expert or more, gain a triumph
				to_chat(M, span_boldgreen("Gaining such exquisite expertise in [LOWER_TEXT(skill_choice)] is a true TRIUMPH."))
				M.adjust_triumphs(1)
			M.allmig_reward++//we also need to do this for RCP and endround triumphs- it's the closest thing Golems have to sleeping.
			qdel(src)
			return
		else //if you click "cancel" in the dialog
			user.visible_message(span_notice("[src] deactivates in [user]'s hand."), span_notice("[src] turns off. Perhaps [M] does not yet wish to improve?"))
			disable()
			return

/obj/item/construct_skill_core/proc/disable() //reset it to inactive mode to be paired later on
	in_use = FALSE
	smeltresult = /obj/item/ingot/bronze
	
