/datum/advclass/mercenary/newmoon
	name = "New Moon Spellblade"
	tutorial = "The New Moon Spellblades of Zybantia are the remnants of a fallen Nocite monastery in an unknown region of Lalvestine, \
	the last major stronghold of the Ten in the Zybantian Empire. \
	Their monastic lyfestyle and devotion collapsed quickly under the weight of the Rot, and they were forced from a lyfe of devout solitude \
	into that of a common sellsword; Noc�s blessings proving rather useful when slaying monsters and men alike. \
	For whatever reason, you find yourself in the region, offering your skills to the highest bidder. Knowledge is power."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/tabaxi,
		/datum/species/anthromorph,
		/datum/species/demihuman,
		/datum/species/elf/wood,
		/datum/species/tieberian
	)
	outfit = /datum/outfit/job/roguetown/mercenary/newmoon
	cmode_music = 'sound/music/combat_desertrider.ogg'
	class_select_category = CLASS_CAT_ZYBANTU
	subclass_languages = list(/datum/language/celestial)
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = -2,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 6)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
	)

	extra_context = "Restricted to: Tabaxi | Wild-Kin | Half-Kin | Elves | Tiefling."

/datum/outfit/job/roguetown/mercenary/newmoon
	allowed_patrons = list(/datum/patron/divine/noc)

/datum/outfit/job/roguetown/mercenary/newmoon/pre_equip(mob/living/carbon/human/H)
	..()
	r_hand = /obj/item/rogueweapon/sword/sabre/newmoon
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	head = /obj/item/clothing/head/roguetown/roguehood/reinforced/newmoon
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/newmoon
	armor = /obj/item/clothing/suit/roguetown/armor/leather/newmoon_jacket
	beltr = /obj/item/rogueweapon/scabbard/sword
	beltl = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/neck/roguetown/psicross/noc

	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/lockpick = 1,
		)

	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = "blade"

	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
		H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
		H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
		H.mind.AddSpell(new /datum/action/cooldown/spell/blade_storm)
		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

//Their sabre. Peel capable when off. Does burn when on. OldRW rage inducing classic, returned.
//Now properly inflicts burn wounds, on top of the burn type damage. Very painful.
/obj/item/rogueweapon/sword/sabre/newmoon
	name = "freezing saber"
	desc = "A fragile sabre adorned with a bright blue freezing mist. Holding the blade feels like it might give you frostbite."
	icon = 'icons/roguetown/weapons/32.dmi'
	icon_state = "nm_saber"
	force = 22//Dropped to 14 when on. Fire damage is a hell of a thing. -8, overall.
	max_integrity = 200//+50
	max_blade_int = 150//-50
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	damtype = BRUTE
	light_color = LIGHT_COLOR_BLUE
	var/on = FALSE

/datum/intent/sword/freeze
	name = "freeze"
	icon_state = "insmoke"//Is it funny yet? Get it?
	attack_verb = list("freezes")
	animname = "chop"
	hitsound = list('sound/combat/hits/pick/genpick (1).ogg')
	penfactor = 60
	swingdelay = 8//+2
//	damfactor = 1.2//Not with new wounds!!!!
	blade_class = BCLASS_BURN

/obj/item/rogueweapon/sword/sabre/newmoon/update_icon()
	if(on)
		icon_state = "nm_saber_freeze"
	else
		icon_state = "nm_saber"

/obj/item/rogueweapon/sword/sabre/newmoon/attack_self(mob/user)
	if(on)
		on = FALSE
		damtype = BRUTE
		possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/strike)
		force = 22
	else
		user.visible_message(span_warning("[user]'s blade lights up with a blue flame."))
		on = TRUE
		damtype = BURN
		possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/freeze, /datum/intent/sword/strike)
		force = 14//Remember, BURN DAMAGE.
	playsound(user, pick('sound/magic/magic_nulled.ogg'), 100, TRUE)
	if(user.a_intent)
		var/datum/intent/I = user.a_intent
		if(istype(I))
			I.afterchange()
	user.update_a_intents()
	update_icon()

//The clothing.
/obj/item/clothing/suit/roguetown/armor/leather/newmoon_jacket
	name = "New Moon coat"
	desc = "Light, fancy, yet still fairly protective. This teal coat is a signature of the New Moon Holy Order with a noc amulet upon the middle of the chestpiece."
	icon_state = "newmoon_jacket"
	item_state = "newmoon_jacket"
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER

/obj/item/clothing/head/roguetown/roguehood/reinforced/newmoon
	color = "#78a3c9"

/obj/item/clothing/suit/roguetown/shirt/tunic/newmoon
	color = "#78a3c9"
