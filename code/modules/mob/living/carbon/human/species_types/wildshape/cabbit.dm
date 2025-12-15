/mob/living/carbon/human/species/wildshape/cabbit //The baseline and tracker of the wildshapes
	name = "Cabbit"
	race = /datum/species/shapecabbit
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/cabbit_skin
	// The form when you gotta go fast and want to be cute

/mob/living/carbon/human/species/wildshape/cabbit/gain_inherent_skills()
	. = ..()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE) //Run and hide if you can

		src.STASTR = 2
		src.STACON = 2
		src.STAWIL = 7
		src.STAPER = 12
		src.STASPD = 20 //May be overtuned with dodge expert, but this thing is so fragile
		src.STALUC = 15 //Xylyx's critters

		AddSpell(new /obj/effect/proc_holder/spell/self/cabbitclaws)
		real_name = "Cabbit" //So we don't get a random name
		faction += "cabbits"

// CABBIT SPECIES DATUM //
/datum/species/shapecabbit
	name = "cabbit"
	id = "shapecabbit"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY, //All of these are dendorite transformations, they are ALL blessed by dendor
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER, //Decapping wildshapes causes them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_DODGEEXPERT,
		TRAIT_BRITTLE,
		TRAIT_LEAPER
	)
	inherent_biotypes = MOB_HUMANOID
	armor = 5
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		)

	languages = list(
		/datum/language/beast,
		/datum/language/common,
	)

/datum/species/shapecabbit/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/roguetown/mob/cabbit.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = "cabbit"
	H.update_damage_overlays()
	return TRUE

/datum/species/shapecabbit/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/shapecabbit/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE

// CABBIT SPECIFIC ITEMS //
/obj/item/clothing/suit/roguetown/armor/skin_armor/cabbit_skin
	slot_flags = null
	name = "cabbit's skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_LEATHER
	blocksound = SOFTHIT
	sewrepair = FALSE
	max_integrity = 1 //You get a single 'lucky' hit as a cabbit
	item_flags = DROPDEL

/datum/intent/simple/cabbit //Like a less defense dagger
	name = "claw"
	clickcd = 8
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("claws", "cuts", "scratches")
	animname = "cut"
	hitsound = "genslash"
	penfactor = 10
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntswoosh"
	item_d_type = "slash"

/obj/item/rogueweapon/cabbit_claw //Backscratcher
	name = "cabbit claw"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/misc32.dmi'
	max_blade_int = 200
	max_integrity = 200
	force = 8 //Pitiful, literally less than a wooden stick or a thrown toy
	block_chance = 0
	wdefense = 1
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_SHORT
	wbalance = WBALANCE_SWIFT
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE //I just think this is cool as fuck, sue me
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = BLADEWOOSH_MED
	possible_item_intents = list(/datum/intent/simple/cabbit)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/cabbit_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/cabbit_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/cabbit_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

// CABBIT SPELLS //
/obj/effect/proc_holder/spell/self/cabbitclaws
	name = "Cabbit Claws"
	desc = "!"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 20 //2 seconds
	ignore_cockblock = TRUE
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/cabbitclaws/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/cabbit_claw/left/l
	var/obj/item/rogueweapon/cabbit_claw/right/r

	l = user.get_active_held_item()
	r = user.get_inactive_held_item()
	if(extended)
		if(istype(l, /obj/item/rogueweapon/cabbit_claw))
			user.dropItemToGround(l, TRUE)
			qdel(l)
		if(istype(r, /obj/item/rogueweapon/cabbit_claw))
			user.dropItemToGround(r, TRUE)
			qdel(r)
		//user.visible_message("Your claws retract.", "You feel your claws retracting.", "You hear a sound of claws retracting.")
		extended = FALSE
	else
		l = new(user,1)
		r = new(user,2)
		user.put_in_hands(l, TRUE, FALSE, TRUE)
		user.put_in_hands(r, TRUE, FALSE, TRUE)
		//user.visible_message("Your claws extend.", "You feel your claws extending.", "You hear a sound of claws extending.")
		extended = TRUE
