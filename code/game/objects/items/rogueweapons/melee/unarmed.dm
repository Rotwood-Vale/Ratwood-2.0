/// INTENT DATUMS	v

/datum/intent/katar/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 0
	chargetime = 0
	swingdelay = 0
	clickcd = CLICK_CD_FAST
	item_d_type = "slash"

/datum/intent/katar/thrust
	name = "thrust"
	icon_state = "instab"
	attack_verb = list("thrusts")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 40
	chargetime = 0
	clickcd = CLICK_CD_FAST
	item_d_type = "stab"

/datum/intent/knuckles/strike
	name = "punch"
	blade_class = BCLASS_BLUNT
	attack_verb = list("punches", "clocks")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = CLICK_CD_FAST
	damfactor = 1.1
	swingdelay = 0
	icon_state = "inpunch"
	item_d_type = "blunt"

/datum/intent/knuckles/smash
	name = "smash"
	blade_class = BCLASS_SMASH
	attack_verb = list("smashes")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
	damfactor = 1.1
	clickcd = CLICK_CD_MELEE
	swingdelay = 8
	intent_intdamage_factor = 1.35
	icon_state = "insmash"
	item_d_type = "blunt"

//Knuckle utility. Use it to line up strikes. -2PER, -1LCK.
//Open up a feint window with it. 10 seconds duration.
/datum/intent/effect/daze/unarmed
	attack_verb = list("strikes")
	damfactor = 0.8
	swingdelay = 8//Same as smash.
	intent_effect = /datum/status_effect/debuff/dazed/unarmed

/// INTENT DATUMS	^

/obj/item/rogueweapon/katar
	slot_flags = ITEM_SLOT_HIP
	force = 18//Two more than a punch dagger.
	possible_item_intents = list(/datum/intent/katar/cut, /datum/intent/katar/thrust)
	name = "katar"
	desc = "A blade that sits above the users fist. Commonly used by those proficient at unarmed fighting"
	icon_state = "katar"
	icon = 'icons/roguetown/weapons/32.dmi'
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	max_blade_int = 200
	max_integrity = 120
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	throwforce = 12
	wdefense = 0	//Meant to be used with bracers
	wbalance = WBALANCE_SWIFT
	thrown_bclass = BCLASS_CUT
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	grid_height = 64
	grid_width = 32
	sharpness_mod = 2	//Can't parry, so it decays quicker on-hit.

/obj/item/rogueweapon/katar/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 1,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 110,"sturn" = -110,"wturn" = -110,"eturn" = 110,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/katar/abyssor
	name = "barotrauma"
	desc = "A gift from a creature of the sea. The claw is sharpened to a wicked edge."
	icon_state = "abyssorclaw"
	force = 21	//Its thrust will be able to pen 80 stab armor if the wielder has 17 STR. (With softcap)
	max_integrity = 120

/obj/item/rogueweapon/katar/psydon
	name = "psydonian katar"
	desc = "An exotic weapon taken from the hands of wandering monks, an esoteric design to the Otavan Orthodoxy. Special care was taken into account towards the user's knuckles: silver-tipped steel from tip to edges, and His holy cross reinforcing the heart of the weapon, with curved shoulders to allow its user to deflect incoming blows - provided they lead it in with the blade."
	icon_state = "psykatar"

/obj/item/rogueweapon/katar/psydon/ComponentInitialize()
	. = ..()							//+3 force, +50 int, +1 def, make silver
	add_psyblessed_component(is_preblessed = FALSE, bonus_force = 3, bonus_sharpness = 0, bonus_integrity = 50, bonus_wdef = 1, make_silver = TRUE)

/obj/item/rogueweapon/katar/punchdagger
	name = "punch dagger"
	desc = "A weapon that combines the ergonomics of the Ranesheni katar with the capabilities of the Western Psydonian \"knight-killers\". It can be tied around the wrist."
	slot_flags = ITEM_SLOT_WRISTS
	max_integrity = 120		//Steel dagger -30
	force = 15		//Steel dagger -5
	throwforce = 8
	thrown_bclass = BCLASS_STAB
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/thrust/pick)
	icon_state = "plug"

/obj/item/rogueweapon/katar/punchdagger/frei
	name = "vývrtka"
	desc = "A type of punch dagger of Aavnic make initially designed to level the playing field with an orc in fisticuffs, its serrated edges and longer, thinner point are designed to maximize pain for the recipient. It's aptly given the name of \"corkscrew\", and this specific one has the colours of Szöréndnížina. Can be worn on your ring slot."
	icon_state = "freiplug"
	slot_flags = ITEM_SLOT_RING

/obj/item/rogueweapon/katar/punchdagger/aav
	name = "vývrtka"//I'm creatively bankrupt.
	desc = "A type of punch dagger of Aavnic make initially designed to level the playing field with an orc in fisticuffs, its serrated edges and longer, thinner point are designed to maximize pain for the recipient. It's aptly given the name of \"corkscrew\", and this specific one has the colours of a Steppesman's banner. Can be worn on your ring slot."
	icon_state = "avplug"
	slot_flags = ITEM_SLOT_RING

//TODO: Add caestus, for an unarmed option with defence.
/obj/item/rogueweapon/knuckles
	name = "steel knuckles"
	desc = "A mean looking pair of steel knuckles."
	force = 22
	possible_item_intents = list(/datum/intent/knuckles/strike, /datum/intent/knuckles/smash, /datum/intent/effect/daze/unarmed)
	icon = 'icons/roguetown/weapons/32.dmi'
	icon_state = "steelknuckle"
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/pugilism/unarmparry (1).ogg','sound/combat/parry/pugilism/unarmparry (2).ogg','sound/combat/parry/pugilism/unarmparry (3).ogg')
	sharpness = IS_BLUNT
	max_integrity = 150
	swingsound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	throwforce = 12
	wdefense = 4	//Meant to be used with bracers. Temp for now.
	wbalance = WBALANCE_NORMAL
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	grid_width = 64
	grid_height = 32

/obj/item/rogueweapon/knuckles/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.2,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 1,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 110,"sturn" = -110,"wturn" = -110,"eturn" = 110,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.1,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/knuckles/bronzeknuckles
	name = "bronze knuckles"
	desc = "A mean looking pair of bronze knuckles. Mildly heavier than it's steel counterpart."
	icon_state = "bronzeknuckle"
	force = 18
	max_integrity = 200
	wdefense = 6	//Meant to be used with bracers. Temp for now.
	wbalance = WBALANCE_HEAVY
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/knuckles/aknuckles
	name = "decrepit knuckles"
	desc = "a set of knuckles made of ancient metals, Aeon's grasp wither their form."
	icon_state = "aknuckle"
	force = 12
	max_integrity = 100
	smeltresult = /obj/item/ingot/aalloy
	blade_dulling = DULLING_SHAFT_CONJURED

/obj/item/rogueweapon/knuckles/paknuckles
	name = "ancient knuckles"
	desc = "a set of knuckles made of ancient metals, Aeon's grasp has been lifted from their form."
	icon_state = "aknuckle"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/knuckles/eora
	name = "close caress"
	desc = "Some times call for a more intimate approach."
	force = 25
	icon_state = "eoraknuckle"

/obj/item/rogueweapon/knuckles/psydon
	name = "psydonian knuckles"
	desc = "A simple piece of harm molded in a holy mixture of steel and silver, finished with three stumps - Psydon's crown - to crush the heretics' garments and armor into smithereens."
	icon_state = "psyknuckle"

/obj/item/rogueweapon/knuckles/psydon/ComponentInitialize()
	. = ..()							//+3 force, +50 int, +1 def, make silver
	add_psyblessed_component(is_preblessed = FALSE, bonus_force = 3, bonus_sharpness = 0, bonus_integrity = 50, bonus_wdef = 1, make_silver = TRUE)

//This has 11 WD. Eeeeugh....
/obj/item/rogueweapon/knuckles/bronzeknuckles/zizoconstruct
	name = "construct knuckles"
	desc = "A vicous pair of bronze knuckles designed specifically for constructs. There is a terrifying, hollow spike in the center of the grip. There doesn't seem to be a way to wield it without impaling yourself."
	color = "#5f1414"
	max_integrity = 500
	wdefense = 11	//Meant to be used with bracers. Temp for now.
	anvilrepair = /datum/skill/craft/engineering

/obj/item/rogueweapon/knuckles/bronzeknuckles/zizoconstruct/pickup(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_BLOODLOSS_IMMUNE))
		to_chat(user, "<font color='purple'> You attempt to wield the knuckles. The spike sinks deeply into your hand, piercing it and drinking deep of your vital energies!</font>")
		user.adjustBruteLoss(15)
		user.Stun(40)
		playsound(get_turf(user), 'sound/misc/drink_blood.ogg', 100)
	..()
