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
	intent_intdamage_factor = 1.15
	swingdelay = 0
	icon_state = "inpunch"
	item_d_type = "blunt"

/datum/intent/knuckles/smash
	name = "smash"
	blade_class = BCLASS_SMASH
	attack_verb = list("smashes")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
	damfactor = 1.5
	clickcd = CLICK_CD_MELEE
	swingdelay = 8
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
	intdamage_factor = 1.15
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

/obj/item/rogueweapon/handclaw
	slot_flags = ITEM_SLOT_HIP
	name = "iron Hound Claws"
	desc = "A pair of heavily curved claws, styled after beasts of the wilds for rending bare flesh, \
			A show of the continual worship and veneration of beasts of strength in Gronn."
	icon_state = "ironclaws"
	icon = 'icons/roguetown/weapons/32.dmi'
	wdefense = 0
	force = 18 //alternative to katar
	possible_item_intents = list(/datum/intent/claw/cut/iron)
	wbalance = WBALANCE_NORMAL
	max_blade_int = 200
	max_integrity = 120
	gripsprite = FALSE
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	swingsound = BLADEWOOSH_SMALL
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	throwforce = 10
	thrown_bclass = BCLASS_CUT
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	grid_height = 96
	grid_width = 32

/obj/item/rogueweapon/handclaw/steel
	name = "steel Mantis Claws"
	desc = "A pair of steel claws, An uncommon sight in Gronn as they do not forge their own steel, \
			Their longer blades offer superior offense. Tear them apart."
	icon_state = "steelclaws"
	icon = 'icons/roguetown/weapons/32.dmi'
	force = 20 //2 more dmg because steel
	possible_item_intents = list(/datum/intent/claw/cut/steel)
	max_blade_int = 220 //10% more blade integrity . Wow!
	smeltresult = /obj/item/ingot/steel
	sharpness_mod = 2

/obj/item/rogueweapon/handclaw/gronn
	name = "Gronn Beast Claws"
	desc = "A pair of uniquely reinforced iron claws forged with the addition of bone by the Iskarn shamans of the Northern Empty. \
			Their unique design aids them in slipping between the plates in armor and their light weight supports rapid aggressive slashes. \
			'To see the claws of the four, Is to see the true danger of the north. Not man, Not land but beast. We are all prey in their eyes.'"
	icon_state = "gronnclaws"
	icon = 'icons/roguetown/weapons/32.dmi'
	force = 22 //+4dmg compared to iron + swift balance for the random chance you're a Speed Freak
	max_blade_int = 220
	possible_item_intents = list(/datum/intent/claw/cut/gronn, /datum/intent/claw/disarm)
	wbalance = WBALANCE_SWIFT


/obj/item/rogueweapon/handclaw/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 1,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 110,"sturn" = -110,"wturn" = -110,"eturn" = 110,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/claw/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes", "lacerates")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	item_d_type = "slash"

/datum/intent/claw/cut/iron
	penfactor = 15
	swingdelay = 0
	clickcd = CLICK_CD_MELEE	//make it a bit worse since they're the worst handclaws

/datum/intent/claw/cut/steel
	penfactor = 20
	swingdelay = 0
	clickcd = CLICK_CD_FAST

/datum/intent/claw/cut/gronn
	penfactor = 25
	swingdelay = 0
	damfactor = 1.1
	clickcd = CLICK_CD_FAST

//YOU CLAW THEIR HANDS TO TAKE THEIR WEAPONS. FUCK'EM UP!!
/datum/intent/claw/disarm
	name = "disarm"
	icon_state = "intake"
	animname = "strike"
	blade_class = null	//We don't use a blade class because it has on damage.
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 10	//Equal in delay to a SMASH intent. Previously 2. Let's try balancing it
	damfactor = 0.1	//No real damage
	clickcd = 30	//Can't spam this; long delay. Previously 20. Let's try balancing it!
	item_d_type = "blunt"

/obj/item/rogueweapon/handclaw/attack(mob/living/M, mob/living/user, bodyzone_hit)
	. = ..()
	var/skill_diff = 0
	if(istype(user.used_intent, /datum/intent/claw/disarm))
		var/obj/item/I
		if(user.zone_selected == BODY_ZONE_PRECISE_L_HAND && M.active_hand_index == 1)
			I = M.get_active_held_item()
		else
			if(user.zone_selected == BODY_ZONE_PRECISE_R_HAND && M.active_hand_index == 2)
				I = M.get_active_held_item()
			else
				I = M.get_inactive_held_item()
		if(user.mind)
			skill_diff += (user.get_skill_level(/datum/skill/combat/unarmed))	//You check your unarmed skill
		if(M.mind)
			skill_diff -= (M.get_skill_level(/datum/skill/combat/wrestling))	//They check their wrestling skill to stop the weapon from being pulled.
		user.stamina_add(rand(3,8))
		var/probby = clamp((((2 + (((user.STASTR - M.STASTR)/4) + skill_diff)) * 8)), 5, 95)	//nerfing further. Previously 3 and times 10
		if(I)
			if(M.mind)
				if(I.associated_skill)
					probby -= M.get_skill_level(I.associated_skill) * 4	//let's nerf this var a little bit. Expert unarmed means you get 16% more. Master means 20% more. Previously 5
			var/obj/item/mainhand = user.get_active_held_item()
			var/obj/item/offhand = user.get_inactive_held_item()
			if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && istype(offhand, mainhand))
				probby += 20	//If you're mad enough to use TWO claws, may as well! You're depending on your bracers
			if(prob(probby))
				M.dropItemToGround(I, force = FALSE, silent = FALSE)
				user.stop_pulling()
				user.put_in_inactive_hand(I)
				M.visible_message(span_danger("[user] takes [I] from [M]'s hand!"), \
				span_userdanger("[user] takes [I] from my hand!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
				user.changeNext_move(12)//avoids instantly attacking with the new weapon
				playsound(src.loc, 'sound/combat/weaponr1.ogg', 100, FALSE, -1) //sound queue to let them know that they got disarmed
				if(!M.mind)	//If you hit an NPC - they pick up weapons instantly. So, we do more stuff.
					M.Stun(12)
			else
				//probby += 20 		we take it out of equation to not make disarm That Good
				if(prob(probby))
					M.dropItemToGround(I, force = FALSE, silent = FALSE)
					M.visible_message(span_danger("[user] disarms [M] of [I]!"), \
					span_userdanger("[user] disarms me of [I]!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
					if(!M.mind)
						M.Stun(20)	//high delay to pick up weapon
					else
						M.Stun(6)	//slight delay to pick up the weapon
				else
					user.Immobilize(10)
					M.Immobilize(10)
					M.visible_message(span_notice("[user.name] struggles to disarm [M.name]!"))
					playsound(src.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
		if(!isliving(M))
			to_chat(user, span_warning("You cannot disarm this enemy!"))
			return
		else
			to_chat(user, span_warning("They aren't holding anything on that hand!"))
			return
