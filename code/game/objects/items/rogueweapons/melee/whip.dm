/obj/item/rogueweapon/whip
	force = 21
	possible_item_intents = list(/datum/intent/whip/lash, /datum/intent/whip/crack, /datum/intent/whip/punish)
	name = "whip"
	desc = "A leather whip, tipped with a flintknapped stone. Though intended to shepherd unruly livestock, the tip's jagged points also suffice at leaving assailants with horrific lacerations."
	icon_state = "whip"
	icon = 'icons/roguetown/weapons/whips32.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.75
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BELT
	associated_skill = /datum/skill/combat/whipsflails
	sewrepair = TRUE //Whips are mostly leather, with only a bit of metal or stone at the end. Should hopefully make more sense.
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = WHIPWOOSH
	throwforce = 5
	wdefense = 0
	minstr = 6
	grid_width = 32
	grid_height = 64
	special = /datum/special_intent/whip_coil
	wbalance = WBALANCE_SWIFT

/obj/item/rogueweapon/whip/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -2,"wx" = -7,"wy" = -3,"ex" = 3,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 22,"sturn" = -23,"wturn" = -23,"eturn" = 29,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//Lash = default, can't dismember, so more range and some pen.
/datum/intent/whip/lash
	name = "lash"
	blade_class = BCLASS_LASHING
	attack_verb = list("lashes", "cracks")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 7
	penfactor = 30
	reach = 3
	icon_state = "inlash"
	item_d_type = "slash"

//Crack = cut damage, can dismember, so lower range.
/datum/intent/whip/crack
	name = "crack"
	blade_class = BCLASS_CUT				//Lets you dismember
	attack_verb = list("cracks", "strikes") //something something dwarf fotresss
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 10
	damfactor = 1.1
	penfactor = 20
	reach = 2
	icon_state = "incrack"
	item_d_type = "slash"

//Punish = Non-lethal sorta damage.
/datum/intent/whip/punish
	name = "punish"
	blade_class = BCLASS_PUNISH
	attack_verb = list("lashes", "cracks")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 5
	damfactor = 1.2							//No range, gets bonus damage - using this even on weak SHOULD let you get perma-scars then.
	penfactor = BLUNT_DEFAULT_PENFACTOR		//No pen cus punishment intent.
	reach = 1								//No range, cus not meant to be a flat-out combat intent.
	icon_state = "inpunish"
	item_d_type = "slash"

//Holy Lash = 1:1 to the Lash, but permits dismemberment. Partially functions like the original whip. Keep this restricted to whips with high strength requirements and alloyed tips.
/datum/intent/whip/lash/holy
	name = "holy lash"
	blade_class = BCLASS_CUT
	attack_verb = list("lashes", "cracks")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 7
	penfactor = 30 // Total AP potential of 53-55, discounting strength bonuses. Will likely penetrate non-slash resistant light armor, but fail to chunk through maille and plate.
	reach = 3
	icon_state = "inlash"
	item_d_type = "slash"

//Ranged mace-like mode - merc unique for Nagaika (steppesman)
/datum/intent/whip/crack/blunt
	name = "bludgen"
	blade_class = BCLASS_BLUNT
	penfactor = BLUNT_DEFAULT_PENFACTOR
	recovery = 6
	reach = 2			//Less range than a normal whip by 1 compared to crack.
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/obj/item/rogueweapon/whip/nagaika
	name = "nagaika whip"
	desc = "A short but heavy leather whip, sporting a blunt reinforced tip and a longer handle."
	icon_state = "nagaika"
	force = 25		//Same as a cudgel/sword for intent purposes. Basically a 2 range cudgel while one-handing.
	possible_item_intents = list(/datum/intent/whip/crack/blunt, /datum/intent/whip/lash, /datum/intent/sword/strike)
	wdefense = 1	//Akin to a cudgel, still terrible at parrying though. Better than nothing I guess; thing is used irl as a counter-weapon to knives.

/obj/item/rogueweapon/whip/xylix
	name = "cackle lash"
	desc = "The chimes of this whip are said to sound as the trickster's laughter itself."
	icon_state = "xylixwhip"
	force = 24

/obj/item/rogueweapon/whip/antique
	name = "Repenta En"
	desc = "A multi-tailed whip that's extremely well-maintained. The gilded handle first burdens the hand with its inordinate weight, and then the mind with an unsettling realization; this is not a tool of honor. </br>'Ravox stands for justice, not murder.'"
	force = 25
	minstr = 11
	icon_state = "gwhip"

/obj/item/rogueweapon/whip/blacksteel
	name = "blacksteel whip"
	desc = "An elegant whip, corded from besilked leather and tipped with blacksteel. Too refined for torture, too precious for combat; what is one to do with such an enigmatic tool?"
	icon_state = "bs_whip"
	force = 25
	possible_item_intents = list(/datum/intent/whip/lash/holy, /datum/intent/whip/crack, /datum/intent/whip/punish)
	minstr = 9
	wdefense = 1
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/whip/antique/psywhip
	name = "Daybreak"
	desc = "A chain-linked whip, meticulously assembled from a hundred pieces of blessed silver. Its origins are steeped in mythos: most believe it to originate from an ancient bloodline of vampyre-killers, which once saved Psydonia from a powerful lyckerlorde. Whether it was happenstance or fate itself that eventually led it into your grasp, however, is better left unspoken. </br>'There, upon the Cathedral's ceiling, was painted a scene-most-beautiful: of a robed Psydon standing before the Archdevil, parting the nite's sky with a crack from His fiery whip. Just as He had done prior, so too must you bring daelight to the darkness.'"
	icon_state = "psywhip"
	is_silver = TRUE
	force = 25
	possible_item_intents = list(/datum/intent/whip/lash/holy, /datum/intent/whip/crack, /datum/intent/whip/punish)
	minstr = 12
	wdefense = 0
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/silver
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/whip/antique/psywhip/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 0,\
	)

/obj/item/rogueweapon/whip/silver
	name = "silver whip"
	desc = "A hefty, silver whip. The uncoiled leather is tipped with a silver barb, which can sunder the blighted from a remarkable distance. </br>'Die, monster! You don't belong in this world!'"
	icon_state = "silverwhip"
	force = 23 //Experimental change - adds a +2 to force, as a bridge between handweapons and blunt weapons. Higher strength minimum. Do not raise above 25, unless you want to resurrect maille-shatterers.
	possible_item_intents = list(/datum/intent/whip/lash/holy, /datum/intent/whip/crack, /datum/intent/whip/punish)
	minstr = 12 //Locks 100% effectiveness - and partially disables ranged dismemberment - unless you either have a +2 STR statpack or are a dedicated melee combatant.
	wdefense = 0
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/whip/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/whip/psywhip_lesser
	name = "psydonic whip"
	desc = "An ornate whip, plated in a ceremonial veneer of silver. Crack the leather and watch as the apostates clammer aside."
	icon_state = "psywhip_lesser"
	possible_item_intents = list(/datum/intent/whip/lash/holy, /datum/intent/whip/crack, /datum/intent/whip/punish)
	force = 23
	minstr = 6 // makes it so psyaltrist can actually use it properly
	wdefense = 0
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/whip/psywhip_lesser/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/whip/spiderwhip
	name = "lashkiss whip"
	desc = "A drow whip of crimson cordage with a fierce-looking razor of blacksteel at its tip. The grip sports a metal knuckle guard perfect for clobbering surface dwellers in the jaw."
	icon_state = "spiderwhip"
	possible_item_intents = list(/datum/intent/whip/lash/holy, /datum/intent/whip/crack, /datum/intent/whip/punish, /datum/intent/dagger/sucker_punch) // sucker as a little flavor and bonus. 
	force = 22
	minstr = 10 //meant for a medium armor mounted soldier. With the +2 from the drow merc statspread, it should cover most statpack silliness save for Wary.  

/obj/item/rogueweapon/whip/bronze
	name = "bronze whip"
	desc = "A heavy whip, corded from thick leather and adorned with a razor-sharp bronzehead. In ancient tymes, this shepherd's weapon once repelled the gnashing teeth of bloodthirsty nitebeasts: now, it separates limb-from-trunk with thunderous claps. </br>Holding this whip imbues you with determination.. and a rather odd hankering for turkey dinners."
	icon_state = "bronzewhip"
	force = 21 //Same damage as the leathers.
	minstr = 13 //Dodgemasters need-not apply. Intended for the 'Belmont'-esque archetype of Barbarians, and greatly punishes those who would try and take it for the sake of non-thematic cheesing.
	wdefense = 0
	possible_item_intents = list(/datum/intent/whip/lash/holy, /datum/intent/whip/crack, /datum/intent/whip/punish) //Able to dismember at range. 'Holy' is a catchall term, in this case.
	smeltresult = /obj/item/ingot/bronze
	wbalance = WBALANCE_HEAVY

/datum/intent/whip/lash/urumi
	name = "urumi lash"
	blade_class = BCLASS_CUT
	attack_verb = list("lashes", "slices")
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	chargetime = 0.5 SECONDS
	recovery = 7
	penfactor = 20
	reach = 3
	icon_state = "inlash"
	item_d_type = "slash"

/datum/intent/whip/lash/urumi/heavy
	name = "heavy urumi lash"//i'm a hack
	blade_class = BCLASS_CUT
	attack_verb = list("lashes", "slices")
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	chargetime = 0.8 SECONDS // longer charge cause heavy balance I guess
	recovery = 7
	penfactor = 30
	reach = 3
	icon_state = "inlash"
	item_d_type = "slash"

/datum/intent/whip/crack/urumi/heavy
	name = "heavy urumi crack"
	blade_class = BCLASS_CHOP //why not
	attack_verb = list("cracks", "slashes")
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	chargetime = 0.7 SECONDS
	recovery = 10
	damfactor = 1.1
	penfactor = 25
	reach = 2
	icon_state = "incrack"
	item_d_type = "slash"

/datum/intent/whip/crack/urumi
	name = "urumi crack"
	blade_class = BCLASS_CHOP //why not
	attack_verb = list("cracks", "slashes")
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	chargetime = 0.9 SECONDS
	recovery = 10
	damfactor = 1.1
	penfactor = 15
	reach = 2
	icon_state = "incrack"
	item_d_type = "slash"

/datum/intent/whip/thrust // elden ring nonsense, but cool
	name = "urumi thrust"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts", "skewers", "shiskebabs", "perforates")
	animname = "stab"
	icon_state = "instab"
	reach = 3
	chargetime = 1 SECONDS // can't spam
	clickcd = CLICK_CD_CHARGED
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 30
	item_d_type = "stab"
	effective_range = 3
	effective_range_type = EFF_RANGE_EXACT

/datum/intent/whip/thrust/heavy // elden ring nonsense, but cool
	name = "urumi thrust"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts", "skewers", "shiskebabs", "perforates")
	animname = "stab"
	icon_state = "instab"
	reach = 3
	chargetime = 1.2 SECONDS // can't spam
	clickcd = CLICK_CD_CHARGED
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 40
	item_d_type = "stab"
	effective_range = 3
	effective_range_type = EFF_RANGE_EXACT

/obj/item/rogueweapon/whip/urumi
	name = "urumi"
	desc = "Two dazzling lengths of razor sharp steel coiling outwards from a knucklebowed hilt. Somewhere between a sword and a whip, this flexible weapon is as much a danger to the wielder as it is their target."
	icon_state = "urumi"
	force = 30//higher force but intents that have less AP and require charging up like flail smash, think spinning the blade before you hit.
	minstr = 10
	wdefense = 0//use a shield or dodge
	possible_item_intents = list(/datum/intent/whip/lash/urumi, /datum/intent/whip/crack/urumi, /datum/intent/whip/thrust, /datum/intent/dagger/sucker_punch)
	max_integrity = 100
	max_blade_int = 100//actually have to worry about sharpening them
	anvilrepair = /datum/skill/craft/weaponsmithing
	sewrepair = FALSE//cant sew a metal coil dumbdumb
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/whip/urumi/iron
	name = "iron urumi"
	desc = "A dazzling length of sharp iron coiling outwards from a knucklebowed hilt. Somewhere between a sword and a whip, this flexible weapon is as much a danger to the wielder as it is their target."
	icon_state = "i_urumi"
	force = 28
	minstr = 8
	max_integrity = 200
	max_blade_int = 200 // not sure how else to make this not just the worse version of the steel variant
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/whip/urumi/bronze
	name = "bronze urumi"
	desc = "A dazzling length bronze coiling outwards from a knucklebowed hilt. A heftier and ancient design for a more robustly built fighter."
	icon_state = "b_urumi"
	force = 30
	minstr = 12
	possible_item_intents = list(/datum/intent/whip/lash/urumi/heavy, /datum/intent/whip/crack/urumi/heavy, /datum/intent/whip/thrust/heavy, /datum/intent/dagger/sucker_punch)
	wbalance = WBALANCE_HEAVY
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/whip/urumi/silver
	name = "silver urumi"
	desc = "Two lengths of shimmering silver coiling outwards from a knucklebowed hilt. These hefty blades demand strength and dexterity from the aspiring sunderer of the unholy."
	icon_state = "silver_urumi"
	force = 33
	minstr = 12
	possible_item_intents = list(/datum/intent/whip/lash/urumi/heavy, /datum/intent/whip/crack/urumi/heavy, /datum/intent/whip/thrust/heavy, /datum/intent/dagger/sucker_punch)
	max_integrity = 150
	max_blade_int = 150
	is_silver = TRUE
	wbalance = WBALANCE_HEAVY
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/whip/urumi/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/whip/urumi/blacksteel
	name = "blacksteel urumi"
	desc = "Two lengths of precious blacksteel coiling outwards from a finely ornamented hilt. As much an artpiece as it is weapon."
	icon_state = "bs_urumi"
	force = 33
	minstr = 11
	max_integrity = 280
	max_blade_int = 280
	smeltresult = /obj/item/ingot/blacksteel
