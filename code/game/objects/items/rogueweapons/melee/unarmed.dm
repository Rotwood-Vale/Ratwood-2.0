/// INTENT DATUMS	v
/datum/intent/katar/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = PEN_LIGHT
	chargetime = 0
	swingdelay = 0
	damfactor = 1.2
	clickcd = CLICK_CD_QUICK
	item_d_type = "slash"

/datum/intent/katar/thrust
	name = "thrust"
	icon_state = "instab"
	attack_verb = list("thrusts")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_LIGHT
	chargetime = 0
	clickcd = CLICK_CD_QUICK
	item_d_type = "stab"

/datum/intent/axe/chop/arbelos
	damfactor = 1.3
	clickcd = CLICK_CD_QUICK //Quicker than a conventional axe, but slower than a katar.

/datum/intent/axe/cut/arbelos
	damfactor = 1.15
	clickcd = CLICK_CD_FAST //Same speed as a katar, but with reduced penetration and half-damage. Main appeal's the chopper.

/datum/intent/katar/thrust/arbelos
	penfactor = PEN_LIGHT
	damfactor = 0.8
	clickcd = CLICK_CD_QUICK //Slower than a regular thrust, with slightly less penetration and damage. Inverse to the katar.


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

/obj/item/rogueweapon/katar/bronze/gladiator
	name = "arbelos"
	icon_state = "bronzescissor"
	item_state = "bronzescissor"
	desc = "A sharpened axhead that's been mounted onto a bronze gauntlet. Popularized at the turn of the millennium within the Underdark's gladiatorial arenas, \
	it triumphs over the katar when it comes to thawrting blows and cleaving skulls. The wooden handle used to connect its axhead to the gauntlet is fragile, however; \
	all it takes is a precise strike to neuter such a weapon."
	wdefense = 5 //Much higher than usual for most unarmed weapons..
	max_integrity = 150 //..and tougher, too.
	max_blade_int = 150 // Reduced sharpness, however, as a result. Such a weapon is built for gladitorial combat, not the rigors of the wilderness. Keep it sharpened
	possible_item_intents = list(/datum/intent/axe/chop/arbelos, /datum/intent/axe/cut/arbelos, /datum/intent/katar/thrust/arbelos)
	thrown_bclass = BCLASS_CHOP

/obj/item/rogueweapon/katar/abyssor
	name = "barotrauma"
	desc = "A gift from a creature of the sea. The claw is sharpened to a wicked edge."
	icon_state = "abyssorclaw"
	force = 27
	max_integrity = 80

// swapped from katar to pata cause it's cool. Otherwise indentical
/obj/item/rogueweapon/katar/bronze
	name = "bronze pata"
	desc = "A fusion of gauntlet and dagger that sits above the user's fist. Commonly used by those proficient at unarmed fighting."
	icon_state = "pata_bronze"
	force = 21 //-3 damage malus, same as the knuckles.
	max_integrity = 80
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/katar/punchdagger
	name = "punch dagger"
	desc = "A weapon that combines the ergonomics of the Zybantine katar with the capabilities of the Western Psydonian \"knight-killers\". It can be tied around the wrist."
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
	desc = "A type of punch dagger of Czwarteki make initially designed to level the playing field with an orc in fisticuffs, its serrated edges and longer, thinner point are designed to maximize pain for the recipient. It's aptly given the name of \"corkscrew\", and this specific one has the colours of Szöréndnížina. Can be worn on your ring slot."
	force = 18
	icon_state = "freiplug"
	slot_flags = ITEM_SLOT_RING
	icon = 'icons/roguetown/weapons/special/freifechter32.dmi'
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/thrust/pick, /datum/intent/mace/smash)

/obj/item/rogueweapon/katar/punchdagger/aav
	name = "aavnic punchdagger"
	desc = "A type of punch dagger of Aavnic make initially designed to level the playing field with an orc in fisticuffs, its serrated edges and longer, thinner point are designed to maximize pain for the recipient. It's aptly given the name of \"corkscrew\", and this specific one has the colours of a Steppesman's banner. Can be worn on your ring slot."
	icon_state = "avplug"
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
	desc = "A pair of uniquely reinforced iron claws forged with the addition of bone by the Zayran shamans of the Northern Empty. \
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

/obj/item/rogueweapon/handclaw/blacksteel
	name = "blacksteel eagle claws"
	desc = "A magnificent pair of blacksteel claws. While the Northern Empty is unfamiliar with blacksteel, they are familiar with an alloy of \
			startingly similar repute; blacker-than-black, impossibly strong, and purported to've been the remains of divine matter. Such were wielded by \
			a legendary champion of the Fjall - one whose valor, though forgotten by tyme, still echoes throughout the world they saved. \
			</br>'Here in the wake, I know when the noose was set, but the truth is that I regret what I have left!'"
	icon_state = "bskatarclaw"
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	wdefense = 8
	force = 35
	possible_item_intents = list(/datum/intent/claw/cut/gronn, /datum/intent/claw/lunge/gronn, /datum/intent/claw/rend)
	wbalance = WBALANCE_HEAVY
	max_blade_int = 350
	smeltresult = /obj/item/ingot/blacksteel
	sharpness_mod = 2

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
	penfactor = PEN_MEDIUM

/datum/intent/claw/lunge/steel
	damfactor = 1.2
	swingdelay = 12
	clickcd = CLICK_CD_HEAVY
	penfactor = PEN_MEDIUM

/datum/intent/claw/lunge/gronn
	damfactor = 1.1
	swingdelay = 5
	clickcd = 10
	penfactor = PEN_MEDIUM

/datum/intent/claw/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	item_d_type = "slash"
	demolition_mod = 0.05

/datum/intent/claw/cut/iron
	penfactor = PEN_LIGHT
	swingdelay = 8
	damfactor = 1.4
	clickcd = CLICK_CD_HEAVY

/datum/intent/claw/cut/steel
	penfactor = PEN_LIGHT
	swingdelay = 4
	damfactor = 1.3
	clickcd = CLICK_CD_HEAVY

/datum/intent/claw/cut/gronn
	penfactor = PEN_LIGHT
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
	penfactor = PEN_NONE
	damfactor = 2.5
	clickcd = CLICK_CD_HEAVY
	no_early_release = TRUE
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_d_type = "slash"
	misscost = 10
	intent_intdamage_factor = 0.05
	sharpness_penalty = 2

/datum/intent/claw/rend/steel
	damfactor = 3
