//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/axe/cut
	name = "劈砍"
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("切开", "挥砍")
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	animname = "劈砍"
	penfactor = 20
	chargetime = 0
	item_d_type = "slash"

/datum/intent/axe/chop
	name = "砍劈"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("砍劈", "劈开")
	animname = "砍劈"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = 35
	swingdelay = 10
	clickcd = 14
	item_d_type = "slash"

/datum/intent/axe/chop/scythe
	reach = 2

/datum/intent/axe/chop/stone
	penfactor = 5

/datum/intent/axe/chop/battle
	damfactor = 1.2 //36 on battleaxe
	penfactor = 40

/datum/intent/axe/cut/battle
	penfactor = 25

/datum/intent/axe/bash
	name = "猛砸"
	icon_state = "inbash"
	attack_verb = list("猛砸", "痛击")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 5
	damfactor = NONBLUNT_BLUNT_DAMFACTOR // Not a real blunt weapon, so less damage.
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

//axe objs ฅ^•ﻌ•^ฅ

/obj/item/rogueweapon/stoneaxe
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 18
	force_wielded = 20
	possible_item_intents = list(/datum/intent/axe/chop/stone)
	name = "石斧"
	desc = "一把粗糙的石斧。平衡极差。"
	icon_state = "stoneaxe"
	icon = 'icons/roguetown/weapons/axes32.dmi'
	item_state = "axe"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	//dropshrink = 0.75
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	swingsound = BLADEWOOSH_MED
	associated_skill = /datum/skill/combat/axes
	max_blade_int = 100
	minstr = 8
	wdefense = 1
	demolition_mod = 2
	w_class = WEIGHT_CLASS_BULKY
	wlength = WLENGTH_SHORT
	pickup_sound = 'sound/foley/equip/rummaging-03.ogg'
	gripped_intents = list(/datum/intent/axe/chop/stone)
	resistance_flags = FLAMMABLE
	special = /datum/special_intent/axe_swing

/obj/item/rogueweapon/stoneaxe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -11,"sy" = -8,"nx" = 12,"ny" = -8,"wx" = -5,"wy" = -8,"ex" = 6,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -4,"nx" = -5,"ny" = -4,"wx" = -5,"wy" = -3,"ex" = 7,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -45,"sturn" = 45,"wturn" = -45,"eturn" = 45,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

// Battle Axe
/obj/item/rogueweapon/stoneaxe/battle
	force = 25
	force_wielded = 30
	possible_item_intents = list(/datum/intent/axe/cut/battle, /datum/intent/axe/chop/battle, /datum/intent/axe/bash, /datum/intent/sword/peel)
	wlength = WLENGTH_LONG		//It's a big battle-axe.
	name = "战斧"
	desc = "一把钢制战斧。锋刃凶恶。"
	icon_state = "battleaxe"
	max_blade_int = 300
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2
	gripped_intents = list(/datum/intent/axe/cut/battle ,/datum/intent/axe/chop/battle, /datum/intent/axe/bash, /datum/intent/sword/peel)
	minstr = 9
	wdefense = 4

/obj/item/rogueweapon/stoneaxe/oath
	force = 30
	force_wielded = 40
	possible_item_intents = list(/datum/intent/axe/cut/battle, /datum/intent/axe/chop/battle, /datum/intent/axe/bash)
	name = "誓约"
	desc = "一把沉重的钢锻战斧，遍布无数守望者留下的痕迹。尽管蚀刻风化、握柄磨损，它的刃口依旧被磨得如剃刀般锋利，你甚至能在精细抛光的金属上看见自己的倒影。"
	icon_state = "oath"
	icon = 'icons/roguetown/weapons/64.dmi'
	max_blade_int = 500
	dropshrink = 0.75
	wlength = WLENGTH_LONG
	slot_flags = ITEM_SLOT_BACK
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	smeltresult = /obj/item/ingot/steel
	gripped_intents = list(/datum/intent/axe/cut/battle ,/datum/intent/axe/chop/battle, /datum/intent/axe/bash)
	minstr = 12
	wdefense = 5

/obj/item/rogueweapon/stoneaxe/oath/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -8,"sy" = -1,"nx" = 9,"ny" = -1,"wx" = -4,"wy" = -1,"ex" = 3,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -45,"sturn" = 45,"wturn" = 45,"eturn" = -45,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0,"wielded")
			if("wielded")
				return list("shrink" = 0.5,"sx" = 4,"sy" = -4,"nx" = -6,"ny" = -3,"wx" = -8,"wy" = -4,"ex" = 8,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0,"onback")
			if("onbelt")
				return list("shrink" = 0.5,"sx" = 1,"sy" = -1,"nx" = 1,"ny" = -1,"wx" = 4,"wy" = -1,"ex" = -1,"ey" = -1,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0,)

/obj/item/rogueweapon/stoneaxe/woodcut
	name = "伐木斧"
	force = 20
	force_wielded = 26
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/sword/peel)
	desc = "一把普通的铁制伐木斧。"
	icon_state = "axe"
	max_blade_int = 400
	smeltresult = /obj/item/ingot/iron
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/sword/peel)
	wdefense = 2

/obj/item/rogueweapon/stoneaxe/hurlbat
	name = "投战斧"
	desc = "它兼具投刃的轻巧流线与战斧的制止力，这种巧妙设计使投战斧能够以致命效率命中目标。尽管其历史起源众说纷纭，但它常见于瓦兰吉亚赏金猎人与残酷的草原民手中。"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	wbalance = WBALANCE_SWIFT
	minstr = 13 //Better hit those weights or go back to tossblades chuddy!
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	grid_height = 64
	grid_width = 32
	force = 20
	throwforce = 32 //You ever had an axe thrown at you?
	throw_speed = 6 //Batarangs, baby.
	max_integrity = 50 //Brittle design, hits hard, breaks quickly.
	armor_penetration = 40 //On-par with steel tossblades.
	wdefense = 1
	icon_state = "hurlbat"
	embedding = list("embedded_pain_multiplier" = 6, "embed_chance" = 50, "embedded_fall_chance" = 30) //high chance at embed, high chance to fall out on its own.
	possible_item_intents = list(/datum/intent/axe/chop/stone)
	gripped_intents = null
	sellprice = 1
	thrown_damage_flag = "piercing"		//Checks piercing type like an arrow.

/obj/item/rogueweapon/stoneaxe/hurlbat/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -6,"nx" = 11,"ny" = -3,"wx" = -4,"wy" = -3,"ex" = 5,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/stoneaxe/battle/abyssoraxe
	name = "潮裂者"
	desc = "一把仿照传闻中的“潮裂者”而制成的战斧，据说原器甚至能劈开海洋。钢刃仿佛低吟着海潮拍岸之声。"
	icon_state = "abyssoraxe"
	icon = 'icons/roguetown/weapons/axes32.dmi'
	max_integrity = 400 // higher int than usual

//Pickaxe-axe ; Technically both a tool and a weapon, but it goes here due to weapon function. Subtype of woodcutter axe, mostly a weapon.
/obj/item/rogueweapon/stoneaxe/woodcut/pick
	name = "普拉斯基斧"
	desc = "一种奇特组合，前端是鹤嘴镐，后端是短斧刃，可在两者之间切换使用。"
	icon_state = "paxe"
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/mace/warhammer/pick, /datum/intent/axe/bash)
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/mace/warhammer/pick, /datum/intent/axe/bash)
	smeltresult = /obj/item/ingot/steel
	wlength = WLENGTH_NORMAL
	toolspeed = 2
	max_integrity = 300 //+50, given it has no damage increase like the Warden's. Still not great for mining.
	demolition_mod = 1.75//75%, +25% over woodcutting. Still not on par with the sapper's 100%.

/obj/item/rogueweapon/stoneaxe/woodcut/wardenpick
	name = "守望者之斧"
	desc = "自远古以来由守望者打造的多用途战斧，既是工具，也是武器。"
	icon_state = "wardenpax"
	force = 22
	force_wielded = 28
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/mace/warhammer/pick, /datum/intent/axe/bash)
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/mace/warhammer/pick, /datum/intent/axe/bash)
	smeltresult = /obj/item/ingot/steel
	wlength = WLENGTH_NORMAL
	toolspeed = 2


// Copper Hatchet
/obj/item/rogueweapon/stoneaxe/handaxe/copper
	force = 13
	name = "铜手斧"
	desc = "一把铜制手斧。它不太耐用。"
	max_integrity = 100 // Half of the norm
	icon_state = "chatchet"
	smeltresult = /obj/item/ingot/copper

/obj/item/rogueweapon/stoneaxe/handaxe
	force = 18
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/sword/peel)
	name = "手斧"
	desc = "一把铁制手斧。"
	icon_state = "hatchet"
	minstr = 1
	max_blade_int = 400
	smeltresult = /obj/item/ingot/iron
	gripped_intents = null
	wdefense = 2
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 32
	grid_height = 96

/obj/item/rogueweapon/stoneaxe/woodcut/bronze
	name = "青铜斧"
	icon_state = "saxe"
	desc = "一根古老手杖，装有青铜斧头。这样的工具曾让人类得以从普赛多尼亚的荒野中开辟文明；如今，除死地的游牧蛮族部落外，已很少见到了。"
	color = "#f9d690" //Stopgap until unique sprites can be provided. Should be ~98% on point with the current bronze palette.
	force = 23 //Basic balance idea. Damage's between iron and steel, but with a sharper edge than steel. Probably not historically accurate, but we're here to have fun.
	force_wielded = 27
	max_blade_int = 550
	smeltresult = /obj/item/ingot/bronze
	wdefense = 2
	armor_penetration = 22 //In-between a hurblat and hatchet. Far harder to reproduce.
	throwforce = 32
	throw_speed = 6
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 33, "embedded_fall_chance" = 2)

/obj/item/rogueweapon/stoneaxe/woodcut/steel
	name = "钢斧"
	icon_state = "saxe"
	desc = "一把钢制伐木斧。性能比铁制同类好得多。"
	force = 26
	force_wielded = 28
	max_blade_int = 500
	smeltresult = /obj/item/ingot/steel
	wdefense = 3

/obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient
	name = "远古斧"
	desc = "一把抛光吉布兰泽短斧。维斯林以罪诱惑人心，让人贪求更好的祭品，也渴慕祂的神性。一击之下，鲜血自骨间喷涌，渗入泥土；那便是第一场谋杀。"
	icon_state = "ahandaxe"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient/decrepit
	name = "破旧斧"
	desc = "一把磨损青铜短斧。它来自赛昂彗星坠落之前的时代；那时人类锻造金属不是为了流血，而是为了更好地依照祂的形象塑造世界。"
	force = 17
	force_wielded = 20
	max_integrity = 180
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/datum/intent/axe/cut/long
	reach = 2

/datum/intent/axe/chop/long
	reach = 2

/obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter
	name = "伐木工斧"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "woodcutter"
	desc = "一把长柄木斧，握柄经过雕刻，选用优质木材打造。非常适合林业从业者。"
	max_integrity = 300		//100 higher than normal; basically it's main difference.
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/axe/bash, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/axe/cut/long, /datum/intent/axe/chop/long, /datum/intent/axe/bash, /datum/intent/sword/peel)
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_BULKY
	demolition_mod = 2.5			//Base is 1.25, so 25% extra. Helps w/ caprentry and building kinda.
	slot_flags = ITEM_SLOT_BACK		//Needs to go on back.
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE

/obj/item/rogueweapon/stoneaxe/woodcut/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -9,"sy" = -8,"nx" = 9,"ny" = -7,"wx" = -7,"wy" = -8,"ex" = 3,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 4,"sy" = -4,"nx" = -6,"ny" = -3,"wx" = -4,"wy" = -4,"ex" = 4,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -44,"sturn" = 45,"wturn" = -33,"eturn" = 33,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/stoneaxe/boneaxe
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 18
	force_wielded = 22
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	name = "骨斧"
	desc = "一把用骨头粗糙拼成的斧头。"
	icon_state = "boneaxe"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	//dropshrink = 0.75
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	swingsound = BLADEWOOSH_MED
	associated_skill = /datum/skill/combat/axes
	max_blade_int = 100
	minstr = 8
	wdefense = 1
	w_class = WEIGHT_CLASS_BULKY
	wlength = WLENGTH_SHORT
	pickup_sound = 'sound/foley/equip/rummaging-03.ogg'
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/stoneaxe/woodcut/silver
	name = "白银战斧"
	desc = "一把以纯银打造的厚重战斧。即便单手握持，只要奋力挥出，也足以一并劈开锁甲与血肉。"
	icon_state = "silveraxe"
	force = 20
	force_wielded = 25
	possible_item_intents = list(/datum/intent/axe/cut/battle, /datum/intent/axe/chop/battle, /datum/intent/axe/bash, /datum/intent/sword/peel)
	minstr = 11
	max_blade_int = 400
	smeltresult = /obj/item/ingot/silver
	gripped_intents = null
	wdefense = 5
	is_silver = TRUE
	blade_dulling = DULLING_SHAFT_METAL

/obj/item/rogueweapon/stoneaxe/woodcut/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/stoneaxe/battle/psyaxe
	name = "普赛顿战斧"
	desc = "一把覆有礼仪银层的华饰战斧。它堪称挑起与精灵使节冲突的头号元凶。"
	icon_state = "psyaxe"
	force = 25
	force_wielded = 30
	minstr = 11
	wdefense = 6
	blade_dulling = DULLING_SHAFT_METAL
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/stoneaxe/battle/psyaxe/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 1,\
	)

/obj/item/rogueweapon/stoneaxe/battle/psyaxe/old
	name = "耐战战斧"
	desc = "一把华饰战斧，银层因失于照料而黯淡失色。即便再微弱的光，也能刺破黑暗。"
	icon_state = "psyaxe"
	force = 20
	force_wielded = 25
	is_silver = FALSE
	smeltresult = /obj/item/ingot/steel
	color = COLOR_FLOORTILE_GRAY

/obj/item/rogueweapon/stoneaxe/battle/psyaxe/old/ComponentInitialize()
	return

/obj/item/rogueweapon/stoneaxe/battle/steppesman
	name = "阿夫尼瓦拉什卡斧"
	desc = "一把阿夫尼风格的钢斧，将致命武器与手杖结合为一体，因此末端也制成尖刺。它的平头便于握持，既能劈砍也能猛砸。要是你足够用力，大概也能拿它捅人。"
	possible_item_intents = list(/datum/intent/axe/cut/battle, /datum/intent/axe/chop/battle, /datum/intent/mace/smash, /datum/intent/mace/warhammer/pick)
	gripped_intents = list(/datum/intent/axe/cut/battle ,/datum/intent/axe/chop/battle, /datum/intent/stab, /datum/intent/mace/warhammer/pick)
	force_wielded = 28	//No damage changes for wielded/unwielded
	icon = 'icons/roguetown/weapons/axes32.dmi'
	icon_state = "valaskapick"
	demolition_mod = 2.5
	walking_stick = TRUE

/datum/intent/axe/cut/battle/greataxe
	reach = 2

/datum/intent/axe/chop/battle/greataxe
	reach = 2

/obj/item/rogueweapon/greataxe
	force = 15
	force_wielded = 30
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe, SPEAR_BASH)
	name = "巨斧"
	desc = "一把铁制巨斧，长柄单刃，专为彻底毁掉别人的一天而生……"
	icon_state = "igreataxe"
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 11
	max_blade_int = 200
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/axes
	wdefense = 6
	demolition_mod = 2

/obj/item/rogueweapon/greataxe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 5,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("altgrip") // for poleaxe alt grip
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 5,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 187,"sturn" = -7,"wturn" = 196,"eturn" = -22,"nflip" = 0,"sflip" = 2,"wflip" = 0,"eflip" = 2)


/obj/item/rogueweapon/greataxe/steel
	force = 15
	force_wielded = 30
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe, SPEAR_BASH)
	name = "钢巨斧"
	desc = "一把钢制巨斧，长柄单刃，专为彻底毁掉别人的一天而生……"
	icon_state = "sgreataxe"
	icon = 'icons/roguetown/weapons/64.dmi'
	minstr = 11
	max_blade_int = 250
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/greataxe/steel/necran
	name = "喘息"
	desc = "一把涂抹过香炉灰、又以麻布缠裹的斧头。它是刽子手的工具，却承载着远比单纯服役更重大的使命。\
	斧刃锋利，斧柄平衡得当。其上承载着安息的祝福。"
	icon_state = "necroberd"
	force = 18//+3, typical of Templar weapons.
	force_wielded = 33//As above. No peel, unlike Tidecleaver.
	max_blade_int = 300//+50
	max_integrity = 300//+50 - Tidecleaver is +150. This gets blade int AND integrity, by comparison.
	walking_stick = TRUE
	vorpal = TRUE // snicker snack this shit cuts heads off effortlessly (DO NOT PUT THIS ON ANYTHING ELSE UNLESS IT'S SUPER FUCKING RARE!!!)

/datum/intent/spear/bash/poleaxe
	name = "长柄斧猛击"
	damfactor = 1 // worse than dedicated mace
	reach = 2
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_STRONG

/datum/intent/mace/smash/poleaxe
	name = "长柄斧重砸"
	damfactor = 1 // worse than dedicated mace
	reach = 2
	clickcd = CLICK_CD_HEAVY // longer because of range
	blunt_chip_strength = BLUNT_CHIP_STRONG // eagle's beak uses BLUNT_CHIP_ABSURD instead

/obj/item/rogueweapon/greataxe/silver
	force = 15
	force_wielded = 25
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/mace/strike)
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe, /datum/intent/mace/rangedthrust)
	alt_intents = list(/datum/intent/spear/bash/poleaxe, /datum/intent/mace/smash/poleaxe, /datum/intent/mace/rangedthrust)
	name = "白银长柄斧"
	desc = "一把长柄斧，装有加固柄杆与纯银鸟喙斧头。它或许无法阻止黑暗本身，却能拖慢它的脚步，久到让无助者安全撤离。 </br>“越过天际，我看见星辰与旋纹；而在其下，是那些被我斩倒的恐怖。穿过黑暗，我望见我的家园与它美丽的光；只要我仍在战斗，它便会继续闪耀。永远屹立，永远坚守，直到天际归于沉寂，我的灵魂才会踏上归途……”"
	icon_state = "silverpolearm"
	icon = 'icons/roguetown/weapons/64.dmi'
	minstr = 12
	max_blade_int = 350
	max_integrity = 150 // compensates for the potential of using it to parry without actually using blunt parry integrity loss
	associated_skill = /datum/skill/combat/polearms // yes it is located in the axe folder and uses axe subtypes it is a polearm
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greataxe/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greataxe/psy
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/mace/strike)
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe, /datum/intent/mace/rangedthrust)
	alt_intents = list(/datum/intent/spear/bash/poleaxe, /datum/intent/mace/smash/poleaxe, /datum/intent/mace/rangedthrust)
	name = "普赛顿长柄斧"
	desc = "一把长柄斧，装有加固柄杆与合银鸟喙斧头。随着长剑的脆弱性愈发明显，普赛顿教团在灾难性的布拉斯滕吉尔大屠杀后，逐渐转向为圣武士装备更耐久的大型兵器。"
	icon_state = "silverpolearm"
	icon = 'icons/roguetown/weapons/64.dmi'
	minstr = 12
	max_blade_int = 350
	max_integrity = 150 // compensates for the potential of using it to parry without actually using blunt parry integrity loss
	associated_skill = /datum/skill/combat/polearms // yes it is located in the axe folder and uses axe subtypes it is a polearm
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/greataxe/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greataxe/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greataxe/steel/doublehead
	force = 15
	force_wielded = 35
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe, SPEAR_BASH)
	name = "双头钢巨斧"
	desc = "一把带有凶恶双刃斧头的钢制巨斧。无论是把人还是把树砍成残桩，它都很在行……"
	icon_state = "doublegreataxe"
	icon = 'icons/roguetown/weapons/64.dmi'
	max_blade_int = 175
	minstr = 12

/obj/item/rogueweapon/greataxe/steel/doublehead/graggar
	name = "凶暴巨斧"
	desc = "这把巨斧的刃口因原初动力而颤鸣，暴力啊，甜美的暴力！"
	icon_state = "graggargaxe"
	force = 20
	force_wielded = 40
	max_blade_int = 250
	icon = 'icons/roguetown/weapons/64.dmi'

/obj/item/rogueweapon/greataxe/steel/doublehead/graggar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "AXE", "RENDERED ASUNDER")

////////////////////////////////////////
// Unique loot axes; mostly from mobs //
////////////////////////////////////////

/obj/item/rogueweapon/greataxe/steel/doublehead/minotaur
	name = "牛头怪巨斧"
	desc = "一把巨大得惊人的重斧，是从登多最凶恶野兽冰冷的尸手中硬撬出来的。"
	icon_state = "minotaurgreataxe"
	max_blade_int = 250
	minstr = 14 //Double-headed greataxe with extra durability. Rare dungeon loot in minotaur dungeons; no longer drops from every single minotaur.

/obj/item/rogueweapon/stoneaxe/woodcut/troll
	name = "粗制重斧"
	desc = "这显然是一把为某种大型怪物打造的斧头。虽然设计粗陋，但分量十足……"
	icon_state = "trollaxe"
	force = 25
	force_wielded = 30					//Basically a slight better steel cutting axe.
	max_integrity = 150					//50% less than normal axe
	max_blade_int = 300
	minstr = 13							//Heavy, but still good.
	wdefense = 3						//Slightly better than norm, has 6 defense 2 handing it.
