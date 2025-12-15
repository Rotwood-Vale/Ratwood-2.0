/mob/living/carbon/human/species/wildshape/fox //The baseline and tracker of the wildshapes 
	name = "Vernard"
	race = /datum/species/shapefox
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/wolf_skin
	//This is basically just Wolf & Cat form combined, think rogue form

/mob/living/carbon/human/species/wildshape/fox/gain_inherent_skills()
	. = ..()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE) //Stalking

		src.STASTR = 8
		src.STACON = 6
		src.STAPER = 10
		src.STASPD = 16

		AddSpell(new /obj/effect/proc_holder/spell/self/foxclaws)
		real_name = "Vernard" //So we don't get a random name
		faction += "wolfs" // Foxes have the same faction code-wise so leaving it for now

// FOX SPECIES DATUM //
/datum/species/shapefox
	name = "vernard"
	id = "shapefox"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY, //All of these are dendorite transformations, they are ALL blessed by dendor
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_BREADY, //Ambusher
		TRAIT_ORGAN_EATER,
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER, //Decapping might cause them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_PIERCEIMMUNE, //Prevents weapon dusting and caltrop effects due to them transforming when killed/stepping on shards.
		TRAIT_LONGSTRIDER
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

/datum/species/shapefox/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/idle (3).ogg'), 80, TRUE, -1)

/datum/species/shapefox/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/roguetown/mob/monster/fox.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = "fox"
	H.update_damage_overlays()
	return TRUE

/datum/species/shapefox/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/shapefox/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE

// FOX SPECIFIC ITEMS //
/obj/item/clothing/suit/roguetown/armor/skin_armor/fox_skin
	slot_flags = null
	name = "fox's skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_LEATHER //It's literally a wolf, shouldn't be more than this
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 100 //Less than leather, it's full-body and foments hit and run
	item_flags = DROPDEL

/datum/intent/simple/fox //Like a less defense dagger
	name = "claw"
	clickcd = 10
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "cut"
	hitsound = "genslash"
	penfactor = 10
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntswoosh"
	item_d_type = "slash"

/obj/item/rogueweapon/fox_claw //Like a less defense dagger
	name = "fox claw"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/misc32.dmi'
	max_blade_int = 600
	max_integrity = 600
	force = 20
	block_chance = 0
	wdefense = 2
	blade_dulling = DULLING_SHAFT_WOOD
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE //I just think this is cool as fuck, sue me
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	possible_item_intents = list(/datum/intent/simple/fox)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/fox_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/fox_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/fox_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

// FOX SPELLS //
/obj/effect/proc_holder/spell/self/foxclaws
	name = "Vernard Claws"
	desc = "!"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 20 //2 seconds
	ignore_cockblock = TRUE
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/foxclaws/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/fox_claw/left/l
	var/obj/item/rogueweapon/fox_claw/right/r

	l = user.get_active_held_item()
	r = user.get_inactive_held_item()
	if(extended)
		if(istype(l, /obj/item/rogueweapon/fox_claw))
			user.dropItemToGround(l, TRUE)
			qdel(l)
		if(istype(r, /obj/item/rogueweapon/fox_claw))
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
