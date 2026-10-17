/obj/item/rogueweapon/greatsword
	force = 14
	force_wielded = 35
	possible_item_intents = list(/datum/intent/sword/chop,/datum/intent/sword/strike) //bash is for nonlethal takedowns, only targets limbs
	// Design Intent: I have a big fucking sword and I want to cut everything in sight.
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/thrust/zwei, /datum/intent/sword/cut/zwei/cleave, /datum/intent/sword/cut/zwei/sweep)
	alt_intents = list(/datum/intent/effect/daze, /datum/intent/sword/strike, /datum/intent/sword/bash)
	name = "greatsword"
	desc = "Might be able to chop anything in half!"
	icon_state = "gsw"
	parrysound = list(
		'sound/combat/parry/bladed/bladedlarge (1).ogg',
		'sound/combat/parry/bladed/bladedlarge (2).ogg',
		'sound/combat/parry/bladed/bladedlarge (3).ogg',
		)
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 9
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/swords
	max_blade_int = 300
	wdefense = 5
	smelt_bar_num = 3
	special = /datum/special_intent/greatsword_swing

/obj/item/rogueweapon/greatsword/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("altgrip")
				return list("shrink" = 0.6,"sx" = 4,"sy" = 0,"nx" = -7,"ny" = 1,"wx" = -8,"wy" = 0,"ex" = 8,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -135,"sturn" = -35,"wturn" = 45,"eturn" = 145,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)

/obj/item/rogueweapon/greatsword/ancient
	name = "ancient greatsword"
	desc = "A massive blade, forged from polished gilbranze. Your kind will discover your true nature, in wrath and ruin. You will take to the stars and burn them out, one by one. Only when the last star turns to dust, will you finally realize that She was trying to save you from Man's greatest foe; oblivion."
	icon_state = "ancient_gsw"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/greatsword/ancient/decrepit
	name = "decrepit greatsword"
	desc = "A massive blade, wrought in frayed bronze. It is too big to be called a sword; massive, thick, heavy, and far too rough. Indeed, this blade was more like a heap of raw metal."
	force = 10
	force_wielded = 25
	max_integrity = 150
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/greatsword/iron
	name = "iron greatsword"
	desc = "Wrought in iron. Heftier and less sturdier than its steel equivalent - but it still does the job."
	icon_state = "igsw"
	max_blade_int = 200
	max_integrity = 200
	wdefense = 4
	smelt_bar_num = 3
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/greatsword/zwei
	name = "claymore"
	desc = "This is much longer than a common greatsword, and well balanced too!"
	icon_state = "claymore"
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 3
	max_blade_int = 220
	wdefense = 4
	force = 12
	force_wielded = 30

/obj/item/rogueweapon/greatsword/grenz
	name = "steel zweihander"
	icon_state = "steelzwei"
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 3
	max_blade_int = 240
	wdefense = 4
	force = 14
	force_wielded = 35

/obj/item/rogueweapon/greatsword/grenz/flamberge
	name = "steel flamberge"
	desc = "A close relative of the Grenzelhoftian \"zweihander\", favored by Otavan nobility. The name comes from its unique, flame-shaped blade; a labor only surmountable by Psydonia's finest weaponsmiths."
	icon_state = "steelflamberge"
	max_blade_int = 200
	max_integrity = 180
	wdefense = 6
	force = 14
	force_wielded = 35
/obj/item/rogueweapon/greatsword/grenz/flamberge/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/greatsword/zizo
	name = "avantyne greatsword"
	desc = "Malediction made manifest; the greatweapon of an otherworldly champion, unfazed by the thickest plates and the toughest flesh. Let no one stop the \
	march of Her disciples, towards the filament's sputtering wound. Take thine birthright and ascend to the heavens beyond, or die trying."
	icon_state = "zizogsw"
	unenchantable = TRUE
	force = 20
	force_wielded = 40
	max_blade_int = 500
	max_integrity = 500

/obj/item/rogueweapon/greatsword/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "GREATSWORD")

/obj/item/rogueweapon/greatsword/grenz/flamberge/ravox
	name = "Censure"
	desc = "A blade that invites imagery of hope. Of men clad in shattered plate and bearing blackened pauldrons, \
	standing at His side. To correct Her wrongs, as they sought the censure of divine tyranny. \
	<small>Even now, it smells of ash.</small>"
	icon_state = "ravoxflamberge"
	max_integrity = 240
	max_blade_int = 240
	wdefense = 7//You are truly unique, m'lord.

/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel
	name = "blacksteel flamberge"
	desc = "An uncommon kind of sword with a characteristically undulating style of blade, made with an equally rare metal. \
	The wave in the blade is considered to contribute a flame-like quality to its appearance, turning it into a menacing sight. \
	\"Flaming swords\" are often the protagonists of Otavan epics and other knights' tales."
	icon_state = "blackflamb"
	force = 25
	force_wielded = 40
	max_blade_int = 200
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/greatsword/psygsword
	name = "psydonic greatsword"
	desc = "It is said that a Psydonian smith was guided by Saint Malum himself to forge such a formidable blade, and given the task to slay a daemon preying on the Otavan farmlands. The design was retrieved, studied, and only a few replicas made - for they believe it dulls its edge."
	icon_state = "silverexealt"
	minstr = 11//+2, in exchange for the better defense. Is this really a problem? C'mon. It didn't need -5 force.
	wdefense = 6
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/greatsword/psygsword/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/psygsword/relic
	name = "Apocrypha"
	desc = "In the Otavan mosaics, Saint Ravox - bare in all but a beaked helmet and loincloth - is often depicted wielding such an imposing greatweapon against the Dark Star, Graggar. Regardless of whether this relic was actually wielded by divinity-or-not, its unparallel strength will nevertheless command even the greatest foes to fall."
	icon_state = "psygsword"
	possible_item_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/thrust/exe, /datum/intent/sword/chop/heavy, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/rend, /datum/intent/sword/thrust/exe, /datum/intent/sword/chop/cleave)

/obj/item/rogueweapon/greatsword/psygsword/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/bsword/psy
	name = "forgotten blade"
	desc = "'Let His name be naught but forgot'n.'"
	icon_state = "oldpsybroadsword"
	force = 20
	force_wielded = 25
	minstr = 11
	wdefense = 6
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/chop, /datum/intent/sword/thrust, /datum/intent/rend/krieg)
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop, /datum/intent/sword/lunge, /datum/intent/sword/thrust/estoc)
	alt_intents = list(/datum/intent/effect/daze, /datum/intent/sword/strike, /datum/intent/sword/bash)
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/bsword/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/bsword/psy/relic
	name = "Creed"
	desc = "Psydonian prayers and Tennite smiths, working as one to craft a weapon to slay the Four. A heavy and large blade, favored by Saint Ravox, to lay waste to those who threaten His flock. The crossguard's psycross reflects even the faintest of Noc's light. You're the light - show them the way."
	icon_state = "psybroadsword"
	force = 25
	force_wielded = 25
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/bsword/psy/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.5, "sx" = -14, "sy" = -8, "nx" = 15, "ny" = -7, "wx" = -10, "wy" = -5, "ex" = 7, "ey" = -6, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -13, "sturn" = 110, "wturn" = -60, "eturn" = -30, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded") return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback") return list("shrink" = 0.5, "sx" = -1, "sy" = 2, "nx" = 0, "ny" = 2, "wx" = 2, "wy" = 1, "ex" = 0, "ey" = 1, "nturn" = 0, "sturn" = 0, "wturn" = 70, "eturn" = 15, "nflip" = 1, "sflip" = 1, "wflip" = 1, "eflip" = 1, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)
			if("onbelt") return list("shrink" = 0.3, "sx" = -4, "sy" = -6, "nx" = 5, "ny" = -6, "wx" = 0, "wy" = -6, "ex" = -1, "ey" = -6, "nturn" = 100, "sturn" = 156, "wturn" = 90, "eturn" = 180, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)

/obj/item/rogueweapon/greatsword/bsword/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/bsword/psy/unforgotten
	name = "unforgotten blade"
	desc = "High Inquisitor Archibald once recorded an expedition of seven brave Adjudicators into Gronnian snow-felled wastes to root out evil. Its leader, Holy Ordinator Guillemin, was said to have held on for seven daes and seven nights against darksteel-clad heretics before Psydon acknowledged his endurance. Nothing but his blade remained - his psycross wrapped around its hilt in remembrance."
	icon_state = "forgottenblade"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/bsword/psy/unforgotten/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/estoc
	name = "estoc"
	desc = "A sword possessed of a quite long and tapered blade that is intended to be thrust between the \
	gaps in an opponent's armor. The hilt is wrapped tight in black leather."
	icon_state = "estoc"
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 20
	force_wielded = 25
	possible_item_intents = list(
		/datum/intent/sword/thrust,
		/datum/intent/sword/strike,
	)
	gripped_intents = list(
		/datum/intent/sword/thrust/estoc/lunge,
		/datum/intent/sword/thrust/long/halfsword,
		/datum/intent/sword/strike,
	)
	bigboy = TRUE
	gripsprite = TRUE
	special = /datum/special_intent/piercing_lunge
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/swords
	max_blade_int = 400
	max_integrity = 300
	wdefense = 3
	wdefense_wbonus = 6
	smelt_bar_num = 2

/obj/item/rogueweapon/estoc/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6, "sx" = -6, "sy" = 7, "nx" = 6, "ny" = 8, "wx" = 0, "wy" = 6, "ex" = -1, "ey" = 8, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -50, "sturn" = 40, "wturn" = 50, "eturn" = -50, "nflip" = 0, "sflip" = 8, "wflip" = 8, "eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)


/////////////////////
// Special Weapon! //
/////////////////////


/datum/intent/sword/thrust/estoc/dragonslayer
	name = "impale"
	icon_state = "inimpale"
	penfactor = 55
	attack_verb = list("impales", "runs through")
	reach = 2
	damfactor = 1.25
	clickcd = 55
	swingdelay = 15
	cleave = /datum/cleave_pattern/lance

/datum/intent/sword/chop/dragonslayer
	name = "eviscerate"
	icon_state = "inrend"
	blade_class = BCLASS_CHOP
	attack_verb = list("splits", "eviscerates")
	animname = "chop"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = 40
	damfactor = 2
	swingdelay = 15
	reach = 2
	clickcd = 55
	item_d_type = "slash"

/datum/intent/sword/smash/dragonslayer
	name = "pulverize"
	blade_class = BCLASS_SMASH
	attack_verb = list("clangs", "pulverizes")
	hitsound = list('sound/combat/hits/blunt/frying_pan(1).ogg', 'sound/combat/hits/blunt/frying_pan(2).ogg', 'sound/combat/hits/blunt/frying_pan(3).ogg', 'sound/combat/hits/blunt/frying_pan(4).ogg')
	penfactor = PEN_NONE
	reach = 2
	damfactor = 2.5
	swingdelay = 25
	clickcd = 55
	icon_state = "insmash"
	item_d_type = "blunt"

/datum/intent/sword/sucker_punch/dragonslayer
	name = "unevadable haymaker"
	icon_state = "inpunch"
	attack_verb = list("punches", "throttles", "clocks")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg', 'sound/combat/hits/kick/kick.ogg')
	damfactor = 4
	penfactor = PEN_NONE
	clickcd = 55
	recovery = 15
	item_d_type = "blunt"
	parriable_intent = FALSE
	dodgeable_intent = FALSE

/datum/intent/sword/flay/dragonslayer
	name = "flay"
	icon_state = "inpeel"
	attack_verb = list("<font color ='#e7e7e7'>flays</font>")
	animname = "cut"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/frying_pan(1).ogg', 'sound/combat/hits/blunt/frying_pan(2).ogg', 'sound/combat/hits/blunt/frying_pan(3).ogg', 'sound/combat/hits/blunt/frying_pan(4).ogg')
	reach = 2
	penfactor = PEN_NONE
	swingdelay = 15
	clickcd = 50
	damfactor = 0.5
	item_d_type = "slash"

/datum/intent/sword/cut/exe/sweep/dragonslayer
	name = "vorpal sweep"
	icon_state = "insweep"
	attack_verb = list("sweeps through", "cuts across")
	clickcd = CLICK_CD_GLACIAL
	reach = 2
	damfactor = 2 // Hits harder but clunkier
	cleave = /datum/cleave_pattern/frontal_arc
	desc = "A heavy sweep that cuts through targets to the front."

//

/obj/item/rogueweapon/sword/long/exe/berserk/dragonslayer
	name = "\"Daemonslayer\""
	desc = "'That thing was too big to be called a sword. Too big, too thick, too heavy, and too rough. No, it was more like a large hunk of silver.' </br>Intimidatingly massive, unfathomably powerful, and - above all else - a testament to one's guts."
	icon_state = "machaslayer"
	icon = 'icons/roguetown/weapons/swords64.dmi'
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	possible_item_intents = list(/datum/intent/sword/thrust/estoc/dragonslayer, /datum/intent/sword/sucker_punch/dragonslayer, /datum/intent/sword/flay/dragonslayer)
	gripped_intents = list(/datum/intent/sword/chop/dragonslayer, /datum/intent/sword/thrust/estoc/dragonslayer, /datum/intent/sword/smash/dragonslayer, /datum/intent/sword/cut/exe/sweep/dragonslayer)
	force = 35
	force_wielded = 55
	minstr = 15
	minstr_req = TRUE//You MUST have the required strength. No exceptions.
	wdefense = 15
	var/coverage = 65//greatsword ds3 has 65 physical def. This is completely arbitrary but should be funny
	max_integrity = 555
	max_blade_int = 555
	alt_intents = null
	is_silver = TRUE
	smeltresult = /obj/item/rogueweapon/sword/long/exe/berserk//Too thick to completely melt.

/obj/item/rogueweapon/sword/long/exe/berserk/dragonslayer/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 0,\
		added_def = 0,\
	)

//snowflake coverage passive blocking for the funny super sword
/obj/item/rogueweapon/sword/long/exe/berserk/dragonslayer/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the projectile", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
	var/mob/attacker
	var/obj/item/I
	if(attack_type == THROWN_PROJECTILE_ATTACK)
		if(istype(hitby, /obj/item))
			I = hitby
		if(I?.thrownby)
			attacker = I.thrownby
	if(attack_type == PROJECTILE_ATTACK)
		var/obj/projectile/P = hitby
		if(P?.firer)
			attacker = P.firer
	if(attacker && istype(attacker))
		if (!owner.can_see_cone(attacker))
			return FALSE
		if(obj_broken)
			return FALSE
		if(prob(coverage))
			owner.visible_message(span_danger("[owner] swings [src] forward in an arc, swatting the [hitby] away!"))
			playsound(src, BLADEWOOSH_LARGE, 100, TRUE, -1) //HOME RUN!!!
			return TRUE
	return FALSE

//Elven weapons sprited and added by Jam

/obj/item/rogueweapon/greatsword/elf
	possible_item_intents = list(/datum/intent/sword/chop,/datum/intent/sword/strike) //bash is for nonlethal takedowns, only targets limbs
	// Design Intent: It is pretty purely a two-handed weapon. In one hand it's a bit clumsy.
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/rend, /datum/intent/sword/thrust/zwei, /datum/intent/sword/strike/bad)
	alt_intents = list(null)//can't be alt-gripped. Sharpness is greater to compensate.
	name = "elven curveblade"
	desc = "The Elven Curveblade is a traditional weapon, its practice as much a dance as a method of death. Flowing like the water's current, let its path lead to your enemy's throat."
	icon_state = "elfcurveblade"
	wlength = WLENGTH_LONG//less reach than greatsword!
	minstr = 7//lighter
	wdefense = 8//better defence than greatsword
	max_blade_int = 350 // 50 more than greatsword.
	sellprice = 60
