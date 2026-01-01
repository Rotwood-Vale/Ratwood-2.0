/// INTENT DATUMS	v
/datum/intent/katar/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 20
	chargetime = 0
	swingdelay = 0
	damfactor = 1.3
	clickcd = CLICK_CD_FAST
	item_d_type = "slash"

/datum/intent/katar/thrust
	name = "thrust"
	icon_state = "instab"
	attack_verb = list("thrusts")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 25
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
	clickcd = 8
	swingdelay = 0
	icon_state = "inpunch"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR // This might be a mistake

/datum/intent/knuckles/smash
	name = "smash"
	blade_class = BCLASS_SMASH
	attack_verb = list("smashes")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = CLICK_CD_MELEE
	swingdelay = 8
	icon_state = "insmash"
	item_d_type = "blunt"

/datum/intent/knuckles/strike/wallop
	name = "wallop"
	blade_class = BCLASS_TWIST
	attack_verb = list("wallops", "thwacks", "thwamps")
	damfactor = 1.1
	intent_intdamage_factor = 0.6
	icon_state = "inbash"	// Wallop is too long for a button; placeholder.

//Knuckle utility. Use it to line up strikes. -2PER, -1LCK.
//Open up a feint window with it. 10 seconds duration.
/datum/intent/effect/daze/unarmed
	attack_verb = list("strikes")
	damfactor = 0.8
	swingdelay = 8//Same as smash.
	intent_effect = /datum/status_effect/debuff/dazed/unarmed

/// INTENT DATUMS	^

//Weaponry.

/obj/item/rogueweapon/katar
	slot_flags = ITEM_SLOT_HIP
	force = 24
	possible_item_intents = list(/datum/intent/katar/cut, /datum/intent/katar/thrust)
	name = "katar"
	desc = "A steel blade that sits above the user's fist. Commonly used by those proficient at unarmed fighting."
	icon_state = "katar"
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	max_blade_int = 200
	max_integrity = 80
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	throwforce = 12
	wdefense = 0	//Meant to be used with bracers
	wbalance = WBALANCE_NORMAL
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
	force = 27	//Its thrust will be able to pen 80 stab armor if the wielder has 17 STR. (With softcap)
	max_integrity = 80

/obj/item/rogueweapon/katar/bronze
	name = "bronze katar"
	desc = "A bronze blade that sits above the user's fist. Commonly used by those proficient at unarmed fighting."
	force = 21 //-3 damage malus, same as the knuckles.
	color = "#f9d690" //Not perfect, but should nearly replicate the bronze knuckle's palette. Someone could replace with an actual palette swap in the .dmi, when able.
	max_integrity = 80
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/katar/punchdagger
	name = "punch dagger"
	desc = "A weapon that combines the ergonomics of the Ranesheni katar with the capabilities of the Western Psydonian \"knight-killers\". It can be tied around the wrist."
	slot_flags = ITEM_SLOT_WRISTS
	max_integrity = 120		//Steel dagger -30
	force = 15		//Steel dagger -5
	throwforce = 8
	wdefense = 0	//Hell no!
	thrown_bclass = BCLASS_STAB
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/thrust/pick)
	icon_state = "plug"

/obj/item/rogueweapon/katar/punchdagger/frei
	name = "vývrtka"
	desc = "A type of punch dagger of Aavnic make initially designed to level the playing field with an orc in fisticuffs, its serrated edges and longer, thinner point are designed to maximize pain for the recipient. It's aptly given the name of \"corkscrew\", and this specific one has the colours of Szöréndnížina. Can be worn on your ring slot."
	icon_state = "freiplug"
	slot_flags = ITEM_SLOT_RING

/obj/item/rogueweapon/katar/psydon
	name = "psydonic katar"
	desc = "An exotic weapon taken from the hands of wandering monks, an esoteric design to the Otavan Orthodoxy. Special care was taken into account towards the user's knuckles: silver-tipped steel from tip to edges, and His holy cross reinforcing the heart of the weapon, with curved shoulders to allow its user to deflect incoming blows - provided they lead it in with the blade."
	icon_state = "psykatar"
	force = 19
	wdefense = 3
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/katar/psydon/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/knuckles/psydon
	name = "psydonic knuckles"
	desc = "A simple piece of harm molded in a holy mixture of steel and silver, finished with three stumps - Psydon's crown - to crush the heretics' garments and armor into smithereens."
	icon_state = "psyknuckle"
	force = 22
	wdefense = 5
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/knuckles/psydon/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/knuckles/psydon/old
	name = "enduring knuckles"
	desc = "A simple piece of harm molded in a holy mixture of steel and silver, its holy blessing long since faded. You are HIS weapon, you needn't fear Aeon."
	icon_state = "psyknuckle"
	force = 17
	is_silver = FALSE
	smeltresult = /obj/item/ingot/steel
	color = COLOR_FLOORTILE_GRAY

/obj/item/rogueweapon/knuckles/psydon/old/ComponentInitialize()
	return

/obj/item/rogueweapon/knuckles
	name = "steel knuckles"
	desc = "A mean looking pair of steel knuckles."
	force = 25
	possible_item_intents = list(/datum/intent/knuckles/strike,/datum/intent/knuckles/smash, /datum/intent/knuckles/strike/wallop, /datum/intent/effect/daze/unarmed)
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	icon_state = "steelknuckle"
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/pugilism/unarmparry (1).ogg','sound/combat/parry/pugilism/unarmparry (2).ogg','sound/combat/parry/pugilism/unarmparry (3).ogg')
	sharpness = IS_BLUNT
	max_integrity = 200
	swingsound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	throwforce = 12
	wdefense = 4
	wbalance = WBALANCE_SWIFT
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
	desc = "A mean looking pair of bronze knuckles. Mildly heavier than it's steel counterpart, making it a solid defensive option, if less wieldy."
	force = 22
	possible_item_intents = list(/datum/intent/knuckles/strike, /datum/intent/knuckles/smash, /datum/intent/knuckles/strike/wallop)
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	icon_state = "bronzeknuckle"
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/pugilism/unarmparry (1).ogg','sound/combat/parry/pugilism/unarmparry (2).ogg','sound/combat/parry/pugilism/unarmparry (3).ogg')
	sharpness = IS_BLUNT
	max_integrity = 200
	swingsound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	throwforce = 12
	wdefense = 6
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/knuckles/aknuckles
	name = "decrepit knuckles"
	desc = "a set of knuckles made of ancient metals, Aeon's grasp wither their form."
	icon_state = "aknuckle"
	force = 12
	max_integrity = 100
	wdefense = 4
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
	force = 24
	icon_state = "eoraknuckle"

//Claws. God, I hate these.
/obj/item/rogueweapon/handclaw
	slot_flags = ITEM_SLOT_HIP
	name = "Iron Hound Claws"
	desc = "A pair of heavily curved claws, styled after beasts of the wilds for rending bare flesh, \
			A show of the continual worship and veneration of beasts of strength in Gronn."
	icon_state = "ironclaws"
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	wdefense = 5
	force = 30
	possible_item_intents = list(/datum/intent/claw/cut/iron, /datum/intent/claw/lunge/iron, /datum/intent/claw/rend)
	wbalance = WBALANCE_NORMAL
	max_blade_int = 300
	max_integrity = 200
	gripsprite = FALSE
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	swingsound = BLADEWOOSH_SMALL
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	throwforce = 12
	thrown_bclass = BCLASS_CUT
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	grid_height = 96
	grid_width = 32

/obj/item/rogueweapon/handclaw/steel
	name = "Steel Mantis Claws"
	desc = "A pair of steel claws, An uncommon sight in Gronn as they do not forge their own steel, \
			Their longer blades offer a superior defence option but their added weight slows them down."
	icon_state = "steelclaws"
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	wdefense = 6
	force = 35
	possible_item_intents = list(/datum/intent/claw/cut/steel, /datum/intent/claw/lunge/steel, /datum/intent/claw/rend/steel)
	wbalance = WBALANCE_HEAVY
	max_blade_int = 180
	max_integrity = 200
	smeltresult = /obj/item/ingot/steel
	sharpness_mod = 2

/obj/item/rogueweapon/handclaw/gronn
	name = "Gronn Beast Claws"
	desc = "A pair of uniquely reinforced iron claws forged with the addition of bone by the Iskarn shamans of the Northern Empty. \
			Their unique design aids them in slipping between the plates in armor and their light weight supports rapid aggressive slashes. \
			'To see the claws of the four, Is to see the true danger of the north. Not man, Not land but beast. We are all prey in their eyes.'"
	icon_state = "gronnclaws"
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	wdefense = 3
	force = 25
	possible_item_intents = list(/datum/intent/claw/cut/gronn, /datum/intent/claw/lunge/gronn, /datum/intent/claw/rend)
	wbalance = WBALANCE_SWIFT
	max_blade_int = 200
	max_integrity = 200

/obj/item/rogueweapon/handclaw/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 1,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 110,"sturn" = -110,"wturn" = -110,"eturn" = 110,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/claw/lunge
	name = "lunge"
	icon_state = "inimpale"
	attack_verb = list("lunges")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')

/datum/intent/claw/lunge/iron
	damfactor = 1.2
	swingdelay = 8
	clickcd = CLICK_CD_MELEE
	penfactor = 35

/datum/intent/claw/lunge/steel
	damfactor = 1.2
	swingdelay = 12
	clickcd = CLICK_CD_HEAVY
	penfactor = 35

/datum/intent/claw/lunge/gronn
	damfactor = 1.1
	swingdelay = 5
	clickcd = 10
	penfactor = 45

/datum/intent/claw/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	item_d_type = "slash"

/datum/intent/claw/cut/iron
	penfactor = 20
	swingdelay = 8
	damfactor = 1.4
	clickcd = CLICK_CD_HEAVY

/datum/intent/claw/cut/steel
	penfactor = 10
	swingdelay = 4
	damfactor = 1.3
	clickcd = CLICK_CD_HEAVY

/datum/intent/claw/cut/gronn
	penfactor = 30
	swingdelay = 0
	damfactor = 1.1
	clickcd = CLICK_CD_MELEE

/datum/intent/claw/rend
	name = "rend"
	icon_state = "inrend"
	attack_verb = list("rends")
	animname = "cut"
	blade_class = BCLASS_CHOP
	reach = 1
	penfactor = BLUNT_DEFAULT_PENFACTOR
	damfactor = 2.5
	clickcd = CLICK_CD_HEAVY
	no_early_release = TRUE
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_d_type = "slash"
	misscost = 10
	intent_intdamage_factor = 0.05

/datum/intent/claw/rend/steel
	damfactor = 3
