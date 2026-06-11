//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/sword/cut
	name = "挥斩"
	icon_state = "incut"
	attack_verb = list("切开", "挥砍")
	animname = "cut"
	blade_class = BCLASS_CUT
	chargetime = 0
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	swingdelay = 0
	damfactor = 1.1
	item_d_type = "slash"

/datum/intent/sword/cut/arming
	damfactor = 1.2
	clickcd = 10 // Versatile, this create 26 EDPS instead of 20. But still easily beaten by the Sabre

/datum/intent/sword/cut/militia
	penfactor = 30
	damfactor = 1.2
	chargetime = 0.2

/datum/intent/sword/cut/short
	clickcd = 9
	damfactor = 1

/datum/intent/sword/chop/militia
	penfactor = 50
	chargetime = 0.5
	swingdelay = 0
	damfactor = 1.0

/datum/intent/sword/thrust
	name = "刺击"
	icon_state = "instab"
	attack_verb = list("刺击")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 20
	chargetime = 0
	swingdelay = 0
	item_d_type = "stab"

/datum/intent/sword/thrust/short
	clickcd = 8
	damfactor = 1.1
	penfactor = 30

/datum/intent/sword/thrust/arming
	clickcd = 10 // Less than rapier
	penfactor = 35 // 22 + 35 = 57. Beats light leather slightly more than rapier per strike, but less strike

/datum/intent/sword/thrust/long
	penfactor = 30 // 2h Longsword already have 30 damage. This let it pierce light armor easily
	// Their cut is actually pretty decent when 2handed and should be inferior to zwei.

/datum/intent/sword/thrust/krieg
	damfactor = 0.9

/datum/intent/sword/thrust/blunt
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	attack_verb = list("顶刺", "戳击")
	penfactor = BLUNT_DEFAULT_PENFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/sword/strike
	name = "柄击"
	icon_state = "instrike"
	attack_verb = list("猛砸", "重击")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 0
	damfactor = NONBLUNT_BLUNT_DAMFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_MINUSCULE

// A weaker strike for sword with high damage so that it don't end up becoming better than mace
/datum/intent/sword/strike/bad
	damfactor = 0.7

/datum/intent/sword/peel
	name = "剥甲"
	icon_state = "inpeel"
	attack_verb = list("<font color ='#e7e7e7'>剥甲</font>")
	animname = "cut"
	blade_class = BCLASS_PEEL
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 0
	damfactor = 0.01
	item_d_type = "slash"
	peel_divisor = 4

/datum/intent/sword/peel/big
	name = "巨剑剥甲"
	attack_verb = list("<font color ='#e7e7e7'>轻剥甲</font>")
	reach = 2
	peel_divisor = 5

/datum/intent/sword/peel/weak
	name = "弱剥甲"
	peel_divisor = 8

/datum/intent/sword/chop
	name = "劈砍"
	icon_state = "inchop"
	attack_verb = list("砍劈", "劈开")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = 30
	swingdelay = 8
	damfactor = 1.0
	item_d_type = "slash"

/datum/intent/sword/chop/short
	damfactor = 0.9

/datum/intent/sword/chop/long
	reach = 2

/datum/intent/sword/cut/falx
	penfactor = 20

/datum/intent/sword/chop/falx
	penfactor = 40

/datum/intent/sword/cut/krieg
	damfactor = 1.2
	clickcd = 10

/datum/intent/sword/thrust/krieg
	damfactor = 0.8

/datum/intent/rend/krieg
	intent_intdamage_factor = 0.2
	sharpness_penalty = 2

/datum/intent/rend/krieg/short
	damfactor = 1.8
	swingdelay = 2

//sword objs ฅ^•ﻌ•^ฅ

/obj/item/rogueweapon/sword
	name = "单手剑"
	desc = "一柄装有十字护手的长钢剑。数代以来，单手剑一直都是普赛多尼亚最经典的战争兵器。"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 22
	force_wielded = 25
	possible_item_intents = list(/datum/intent/sword/cut/arming, /datum/intent/sword/thrust/arming, /datum/intent/sword/strike, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut/arming, /datum/intent/sword/thrust/arming, /datum/intent/sword/strike, /datum/intent/sword/peel)
	damage_deflection = 14
	icon_state = "sword1"
	sheathe_icon = "sword1"
	icon = 'icons/roguetown/weapons/swords32.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	parrysound = list(
		'sound/combat/parry/bladed/bladedmedium (1).ogg',
		'sound/combat/parry/bladed/bladedmedium (2).ogg',
		'sound/combat/parry/bladed/bladedmedium (3).ogg',
		)
	swingsound = BLADEWOOSH_MED
	associated_skill = /datum/skill/combat/swords
	max_blade_int = 200
	max_integrity = 150
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_BULKY
	pickup_sound = 'sound/foley/equip/swordlarge1.ogg'
	holster_sound = 'sound/items/wood_sharpen.ogg'
	flags_1 = CONDUCT_1
	throwforce = 10
	thrown_bclass = BCLASS_CUT
	//dropshrink = 0.75
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	minstr = 7
	sellprice = 30
	wdefense = 4
	grid_width = 32
	grid_height = 64

	equip_delay_self = 1.5 SECONDS
	unequip_delay_self = 1.5 SECONDS
	inv_storage_delay = 1.5 SECONDS
	edelay_type = 1
	special = /datum/special_intent/shin_swipe

/obj/item/rogueweapon/sword/Initialize(mapload)
	. = ..()
	var/rand_icon = "sword[rand(1,3)]"
	if(icon_state == "sword1")
		icon_state = "[rand_icon]"
		sheathe_icon = "[rand_icon]"

/obj/item/rogueweapon/sword/iron
	name = "铁单手剑"
	desc = "一柄装有十字护手的长铁剑。数代以来，单手剑一直都是普赛多尼亚最经典的战争兵器，这把则是它更廉价的铁制版本。"
	icon_state = "isword"
	minstr = 6
	smeltresult = /obj/item/ingot/iron
	max_integrity = 100
	sellprice = 10
	sheathe_icon = "isword"

/obj/item/rogueweapon/sword/bronze
	name = "青铜单手剑"
	desc = "一柄装有十字护手的青铜长剑。数代以来，单手剑一直都是普赛多尼亚最经典的战争兵器，而这把几乎可算是它们共同的祖型。虽不及短剑厚重，但作为单手兵器，它依旧手感均衡。"
	icon_state = "sword3"
	force = 23 //Iron- and steel arming swords have the same force. +2 to mimic the one-handed nature of bronze swords.
	force_wielded = 25
	color = "#f9d690"
	minstr = 5
	smeltresult = /obj/item/ingot/bronze
	max_blade_int = 250
	max_integrity = 125
	sheathe_icon = "decsword1" //Placeholder. Close enough.

/obj/item/rogueweapon/sword/falx
	name = "法尔克斯弯刀"
	desc = "一种由农用镰刀演化而来的奇特弯剑。它的刃口向内弯曲，因此很适合切割与劈砍。"
	force = 22
	possible_item_intents = list(/datum/intent/sword/cut/falx,  /datum/intent/sword/chop/falx, /datum/intent/sword/strike, /datum/intent/sword/peel)
	icon_state = "falx"
	max_blade_int = 250
	max_integrity = 125
	gripped_intents = null
	minstr = 4
	wdefense = 6

/obj/item/rogueweapon/sword/decorated
	name = "华饰单手剑"
	desc = "一柄用于礼仪陈设的贵重单手剑，带有精致皮握柄与细工雕刻的金色十字护手。"
	icon_state = "decsword1"
	sellprice = 140

/obj/item/rogueweapon/sword/decorated/Initialize(mapload)
	. = ..()
	var/rand_icon = "decsword[rand(1,3)]"
	if(icon_state == "decsword1")
		icon_state = "[rand_icon]"
		sheathe_icon = "[rand_icon]"

/obj/item/rogueweapon/sword/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -4,"nx" = -6,"ny" = 2,"wx" = -8,"wy" = 1,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -30,"sturn" = 45,"wturn" = -30,"eturn" = 30,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/stone
	force = 17 //Weaker than a short sword
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/chop)
	gripped_intents = null
	name = "石剑"
	desc = "它看似一把剑，实则只是把细长打制石片绑在雕刻木柄上的粗糙仿制品。"
	icon_state = "stone_sword"
	max_blade_int = 100
	max_integrity = 70
	anvilrepair = /datum/skill/craft/crafting
	smeltresult = null
	minstr = 4
	wdefense = 4
	sellprice = 10

/obj/item/rogueweapon/sword/long
	name = "长剑"
	desc = "一件致命而平衡完美的武器。长剑是流传于整个普赛多尼亚无数传说与神话中的主角，常见于贵族之手，也仍被数量日渐稀少的大师决斗家所持。\
		它在格伦泽霍夫与厄特鲁斯卡诸帝国中具有极高文化意义，许多传奇剑士都在那里开创并完善了沿用至今的战技。"
	force = 25
	force_wielded = 30
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/long, /datum/intent/sword/strike, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/long, /datum/intent/sword/peel, /datum/intent/sword/chop)
	alt_intents = list(/datum/intent/effect/daze, /datum/intent/sword/strike, /datum/intent/sword/bash)
	icon_state = "longsword"
	icon = 'icons/roguetown/weapons/64.dmi'
	item_state = "longsword"
	sheathe_icon = "longsword"
	lefthand_file = 'icons/mob/inhands/weapons/roguebig_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/roguebig_righthand.dmi'
	swingsound = BLADEWOOSH_LARGE
	pickup_sound = 'sound/foley/equip/swordlarge2.ogg'
	bigboy = 1
	wlength = WLENGTH_LONG
	gripsprite = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	associated_skill = /datum/skill/combat/swords
	throwforce = 15
	thrown_bclass = BCLASS_CUT
	max_blade_int = 280
	wdefense_wbonus = 4
	smeltresult = /obj/item/ingot/steel
	special = /datum/special_intent/side_sweep

/obj/item/rogueweapon/sword/long/training
	name = "训练剑"
	desc = "这种剑剑尖钝化、刃口迟钝，常用于训练，受伤风险不高。"
	force = 5
	force_wielded = 8
	sharpness = IS_BLUNT
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/sword/thrust/blunt, /datum/intent/sword/peel/weak)
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/sword/thrust/blunt, /datum/intent/sword/peel/weak)
	icon_state = "feder"
	throwforce = 5
	thrown_bclass = BCLASS_BLUNT

/obj/item/rogueweapon/sword/long/church
	name = "圣座长剑"
	desc = "一柄受过祝圣的长剑，由圣座圣堂武士持用，坚定不移地抵御邪恶。据说它诞生于天穹帝国崩塌之后，是普赛多尼亚诸长剑共同的先祖：一位古老的玛卢姆祭司在人类最黑暗的时刻受神启而铸成的杰作。数百年后，它依旧是刺穿异教徒与怪物的理想之选。 </br>“我乃深渊黑暗中的执光者……” </br>“……我乃秩序的持守者，也是污秽之前的屏障……” </br>“……愿诸神引导我手，愿非人者在我面前战栗。”"
	icon_state = "churchsword"
	max_blade_int = 300
	max_integrity = 180

/obj/item/rogueweapon/sword/long/undivided/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list(
				"shrink" = 0.65,
				"sx" = -14,
				"sy" = -8,
				"nx" = 15,
				"ny" = -7,
				"wx" = -10,
				"wy" = -5,
				"ex" = 7,
				"ey" = -6,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = -13,
				"sturn" = 110,
				"wturn" = -60,
				"eturn" = -30,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 8,
				"eflip" = 1,
				)
			if("onback") return list(
				"shrink" = 0.65,
				"sx" = -1,
				"sy" = 2,
				"nx" = 0,
				"ny" = 2,
				"wx" = 2,
				"wy" = 1,
				"ex" = 0,
				"ey" = 1,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 70,
				"eturn" = 15,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 1,
				"eflip" = 1,
				"northabove" = 1,
				"southabove" = 0,
				"eastabove" = 0,
				"westabove" = 0,
				)
			if("wielded") return list(
				"shrink" = 0.6,
				"sx" = 3,
				"sy" = 5,
				"nx" = -3,
				"ny" = 5,
				"wx" = -9,
				"wy" = 4,
				"ex" = 9,
				"ey" = 1,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 0,
				"eturn" = 15,
				"nflip" = 8,
				"sflip" = 0,
				"wflip" = 8,
				"eflip" = 0,
				)
			if("onbelt") return list(
				"shrink" = 0.4,
				"sx" = -4,
				"sy" = -6,
				"nx" = 5,
				"ny" = -6,
				"wx" = 0,
				"wy" = -6,
				"ex" = -1,
				"ey" = -6,
				"nturn" = 100,
				"sturn" = 156,
				"wturn" = 90,
				"eturn" = 180,
				"nflip" = 0,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 0,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				)



/obj/item/rogueweapon/sword/long/church
	name = "圣座长剑"
	desc = "一柄受过祝圣的长剑，由圣座圣堂武士持用，坚定不移地抵御邪恶。据说它诞生于天穹帝国崩塌之后，是普赛多尼亚诸长剑共同的先祖：一位古老的玛卢姆祭司在人类最黑暗的时刻受神启而铸成的杰作。数百年后，它依旧是刺穿异教徒与怪物的理想之选。 </br>“我乃深渊黑暗中的执光者……” </br>“……我乃秩序的持守者，也是污秽之前的屏障……” </br>“……愿诸神引导我手，愿非人者在我面前战栗。”"
	icon_state = "churchsword"
	max_blade_int = 250
	max_integrity = 180

/obj/item/rogueweapon/sword/long/holysee_lesser
	name = "蚀辉长剑"//Is the name similar to the 'eclipsum sword'? Yeah. Almost identical. Still better than decablade.
	desc = "只需一滴神圣蚀辉，剑锋便会升起。镀金、闪耀、灼热辉光，温暖我魂，也焚尽我敌。"
	icon_state = "eclipsum"
	sheathe_icon = "eclipsum"
	max_blade_int = 300
	max_integrity = 180
	force = 28
	force_wielded = 33

/obj/item/rogueweapon/sword/long/holysee_lesser/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list(
				"shrink" = 0.65,
				"sx" = -14,
				"sy" = -8,
				"nx" = 15,
				"ny" = -7,
				"wx" = -10,
				"wy" = -5,
				"ex" = 7,
				"ey" = -6,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = -13,
				"sturn" = 110,
				"wturn" = -60,
				"eturn" = -30,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 8,
				"eflip" = 1,
				)
			if("onback") return list(
				"shrink" = 0.65,
				"sx" = -1,
				"sy" = 2,
				"nx" = 0,
				"ny" = 2,
				"wx" = 2,
				"wy" = 1,
				"ex" = 0,
				"ey" = 1,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 70,
				"eturn" = 15,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 1,
				"eflip" = 1,
				"northabove" = 1,
				"southabove" = 0,
				"eastabove" = 0,
				"westabove" = 0,
				)
			if("wielded") return list(
				"shrink" = 0.6,
				"sx" = 3,
				"sy" = 5,
				"nx" = -3,
				"ny" = 5,
				"wx" = -9,
				"wy" = 4,
				"ex" = 9,
				"ey" = 1,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 0,
				"eturn" = 15,
				"nflip" = 8,
				"sflip" = 0,
				"wflip" = 8,
				"eflip" = 0,
				)
			if("onbelt") return list(
				"shrink" = 0.4,
				"sx" = -4,
				"sy" = -6,
				"nx" = 5,
				"ny" = -6,
				"wx" = 0,
				"wy" = -6,
				"ex" = -1,
				"ey" = -6,
				"nturn" = 100,
				"sturn" = 156,
				"wturn" = 90,
				"eturn" = 180,
				"nflip" = 0,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 0,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				)

/obj/item/rogueweapon/sword/long/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.5, "sx" = -14, "sy" = -8, "nx" = 15, "ny" = -7, "wx" = -10, "wy" = -5, "ex" = 7, "ey" = -6, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -13, "sturn" = 110, "wturn" = -60, "eturn" = -30, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded") return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback") return list("shrink" = 0.5, "sx" = -1, "sy" = 2, "nx" = 0, "ny" = 2, "wx" = 2, "wy" = 1, "ex" = 0, "ey" = 1, "nturn" = 0, "sturn" = 0, "wturn" = 70, "eturn" = 15, "nflip" = 1, "sflip" = 1, "wflip" = 1, "eflip" = 1, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)
			if("onbelt") return list("shrink" = 0.4, "sx" = -4, "sy" = -6, "nx" = 5, "ny" = -6, "wx" = 0, "wy" = -6, "ex" = -1, "ey" = -6, "nturn" = 100, "sturn" = 156, "wturn" = 90, "eturn" = 180, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)
			if("altgrip") return list("shrink" = 0.6,"sx" = 2,"sy" = 3,"nx" = -7,"ny" = 1,"wx" = -8,"wy" = 0,"ex" = 8,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -135,"sturn" = -35,"wturn" = 45,"eturn" = 145,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)

/obj/item/rogueweapon/sword/long/etruscan
	name = "篮护长剑"
	desc = "一种少见而华丽的长剑，拥有类似刺剑与小剑的复合护手。其剑身留有明显未开锋区，便于无甲半剑握持，并以卡洛里亚钢制成。"
	icon_state = "elongsword"

/obj/item/rogueweapon/sword/long/frei		//Challenge weapon
	name = "决斗长剑"
	desc = "羽剑是格伦泽霍夫击剑公会推广的一类训练剑，其名意为“羽毛”，正与其构造相符：更薄、更轻、未开锋却更平衡，甚至还带有挡刃结构。自由剑士们常会自行改造它们，磨出锋刃与尖端以投入真正的决斗，而这把就是其中一个例子，也正因如此，它通常走不出决斗坑。"
	icon_state = "sharpfeder"
	force = 22
	force_wielded = 27
	wdefense = 5		//+1
	wbalance = WBALANCE_SWIFT

/obj/item/rogueweapon/sword/long/zizo
	name = "阿凡泰因长剑"
	desc = "一把邪异、反常而不似此世之物的长剑，并非出自任何铸剑师之手。它是对这个世界现状的憎恨所凝成的实体，不遵循任何设计原则，只剩恶意与愤怒。"
	icon_state = "zizosword"
	sheathe_icon = "zizosword"
	force = 30
	force_wielded = 35
	equip_delay_self = 0
	unequip_delay_self = 0

/obj/item/rogueweapon/sword/long/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "SWORD")

/obj/item/rogueweapon/sword/long/heirloom
	name = "古旧长剑"
	desc = "一把年代久远的钢制长剑，如今更多只是陈设。也许是家传遗物，也许曾属于某位死去的骑士。"
	force = 20
	force_wielded = 32
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike, /datum/intent/sword/chop)
	icon_state = "heirloom"
	sheathe_icon = "heirloom"

/obj/item/rogueweapon/sword/long/heirloom/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.5, "sx" = -14, "sy" = -8, "nx" = 15, "ny" = -7, "wx" = -10, "wy" = -5, "ex" = 7, "ey" = -6, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -13, "sturn" = 110, "wturn" = -60, "eturn" = -30, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded") return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback") return list("shrink" = 0.5, "sx" = -1, "sy" = 2, "nx" = 0, "ny" = 2, "wx" = 2, "wy" = 1, "ex" = 0, "ey" = 1, "nturn" = 0, "sturn" = 0, "wturn" = 70, "eturn" = 15, "nflip" = 1, "sflip" = 1, "wflip" = 1, "eflip" = 1, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)
			if("onbelt") return list("shrink" = 0.3, "sx" = -4, "sy" = -6, "nx" = 5, "ny" = -6, "wx" = 0, "wy" = -6, "ex" = -1, "ey" = -6, "nturn" = 100, "sturn" = 156, "wturn" = 90, "eturn" = 180, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)

/obj/item/rogueweapon/sword/long/judgement
	name = "“审判”"
	desc = "一把工艺繁复的长剑，剑刃由阿夫纳尔最上等的维什沃钢打造，握柄则以当地“玛穆克”巨兽雕刻而成的象牙制成，外观当真独一无二。"
	icon_state = "judgement"
	item_state = "judgement"
	sheathe_icon = "judgement"
	wbalance = WBALANCE_HEAVY
	sellprice = 363
	static_price = TRUE

/obj/item/rogueweapon/sword/long/judgement/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.4,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/judgement/ascendant //meant to be insanely OP; solo antag wep
	name = "“救赎者”"
	desc = "一把锻造精巧、威能非凡的长剑。正如布道者所言：“主是我的高塔，祂赐我力量，去摧毁敌人的作为。”"
	force = 50
	force_wielded = 70
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike, /datum/intent/sword/chop)
	icon_state = "crucified"
	sheathe_icon = "crucified"
	item_state = "judgement"
	smeltresult = /obj/item/ingot/steel
	sellprice = 999
	static_price = TRUE
	max_integrity = 9999


/obj/item/rogueweapon/sword/long/judgement/vlord
	name = "“脓血之牙”"
	desc = "一把由诡异钢材锻成的不洁长剑。绿色结晶团块覆盖着剑刃与柄首，它的锋口与锯齿比任何大师剑匠锻出的兵刃都更坚硬、更锋利。"
	force = 40
	force_wielded = 55
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/peel, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike, /datum/intent/sword/chop)
	icon_state = "vlord"
	item_state = "vlord"
	wbalance = WBALANCE_NORMAL
	max_integrity = 9999
	sellprice = 363
	static_price = TRUE
	equip_delay_self = 0
	unequip_delay_self = 0

/obj/item/rogueweapon/sword/long/judgement/vlord/Initialize(mapload)
	. = ..()
	SEND_GLOBAL_SIGNAL(COMSIG_NEW_ICHOR_FANG_SPAWNED, src)
	RegisterSignal(SSdcs, COMSIG_NEW_ICHOR_FANG_SPAWNED, PROC_REF(on_recall))

/obj/item/rogueweapon/sword/long/judgement/vlord/proc/on_recall(obj/new_sword)
	if(new_sword == src)
		return

	src.visible_message(span_warning("[src]碎裂成灰，灰烬也随风飘散而去。"))
	qdel(src)

/obj/item/rogueweapon/sword/long/marlin
	name = "沙拉尔弯刀"
	desc = "一把尺寸颇大却出奇灵活的双手弯刀。它与普赛多尼亚西北部的长剑材质相近，但明显更加轻盈。"
	force = 26
	force_wielded = 31
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike, /datum/intent/sword/chop, /datum/intent/sword/peel)
	icon_state = "marlin"
	item_state = "marlin"
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	swingsound = BLADEWOOSH_SMALL
	wlength = WLENGTH_LONG
	minstr = 6
	sellprice = 42
	wdefense = 5

/obj/item/rogueweapon/sword/long/marlin/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//Incredibly heavy. Focused on two-handing.
/obj/item/rogueweapon/sword/long/exe
	name = "行刑长剑"
	desc = "一柄剑身额外加重并经过强化的长剑。对不熟悉它的人来说极难驾驭。"
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/exe, /datum/intent/rend, /datum/intent/sword/peel)
	icon_state = "exe"
	force = 20//-5 compared to longsword. -2 with standard. Wield it!
	minstr = 12
	wbalance = WBALANCE_HEAVY//This thing is MASSIVE.
	slot_flags = ITEM_SLOT_BACK //Too big for hip
//Longer to equip/unequip. I guess. If it has to have a back slot.
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS

/datum/intent/sword/thrust/exe
	swingdelay = 4	//Slight delay to stab; big and heavy.
	penfactor = BLUNT_DEFAULT_PENFACTOR //Flat tip? I don't know, man. This intent won't penetrate anything but it damages armor more.
	intent_intdamage_factor = 1.3 //This is basically like getting hit by a mace.

/obj/item/rogueweapon/sword/long/exe/astrata
	name = "“曜日审判”"
	desc = "一柄极其罕见的行刑长剑，通体覆有黄金与黄铜。两道分离的剑刃向外伸展，并在华饰繁复的护手附近重新汇合。这把武器象征着秩序。"
	icon_state = "astratasword"
	max_integrity = 200//+50
	force = 23//Typical +3, for a Templar weapon.
	force_wielded = 33//As above.
	vorpal = TRUE // snicker snack this shit cuts heads off effortlessly (DO NOT PUT THIS ON ANYTHING ELSE UNLESS IT'S SUPER FUCKING RARE!!!)

/obj/item/rogueweapon/sword/long/exe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 3,"nx" = -1,"ny" = 2,"wx" = 3,"wy" = 4,"ex" = -1,"ey" = 5,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 20,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/sword/long/exe/cloth
	icon_state = "terminusest"
	name = "“终焉已至”"
	desc = "一柄古老而受损的行刑长剑，饰有青铜剑首与护手。带血的布条长年缠绕在未开锋根部，仿佛随时准备用来擦净剑身。"
	vorpal = TRUE // snicker snack this shit cuts heads off effortlessly (DO NOT PUT THIS ON ANYTHING ELSE UNLESS IT'S SUPER FUCKING RARE!!!)

/obj/item/rogueweapon/sword/long/exe/cloth/rmb_self(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(user, "clothwipe", 100, TRUE)
	SEND_SIGNAL(src, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRONG)
	user.visible_message(span_warning("[user]用其上的布条擦拭[src]。"),span_notice("我用其上的布条擦拭[src]。"))
	return

/obj/item/rogueweapon/sword/long/oldpsysword
	name = "耐战长剑"
	desc = "一柄带有倾斜护手的钢制长剑。普赛顿教团的低阶神职者常佩带此剑；尽管不具银的锋芒，但只要一击到位，依旧足以制服人类与怪物。"
	icon_state = "opsysword"
	sheathe_icon = "opsysword"
	dropshrink = 1

/obj/item/rogueweapon/sword/long/psysword
	name = "普赛顿长剑"
	desc = "一柄做工精良的长剑，覆有礼仪用途的华饰银层，专为斩杀人类与怪物而造。 </br>“普赛顿会引领那些心怀祂的人抵达最终凯旋之所。邪恶不再触及他们，他们也不再悲伤。”"
	icon_state = "psysword"
	sheathe_icon = "psysword"
	force = 20
	force_wielded = 25
	minstr = 9
	wdefense = 6
	dropshrink = 1
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/sword/long/psysword/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/long/psysword/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/long/silver
	name = "白银长剑"
	desc = "一柄以纯银铸刃的长剑。它的重量压的不只是你的手，还有你的灵魂；那是一道无言誓约，要你挺身对抗潜伏于长夜中的恐怖。 </br>“挥剑要精准，也要有其意义，诸神的征募者。长夜漫漫，无数恶徒都在图谋文明的覆灭，而阿斯特拉塔的目光却望向别处。只要你仍持此剑，责任就仍在召唤你。”"
	icon_state = "silverlongsword"
	sheathe_icon = "psysword"
	force = 20
	force_wielded = 25
	minstr = 9
	wdefense = 6
	dropshrink = 1
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/sword/long/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/long/kriegmesser/silver
	name = "白银阔剑"
	desc = "一柄装有纯银剑刃的双手阔剑。每一次挥动都比上一次更费力，但绝非徒然。一击足以折断死徒的腿骨，转瞬之间再下一击，便能让胆汁与牙齿洒满泥土。"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "silverbroadsword"
	sheathe_icon = "psysword"
	force = 20
	force_wielded = 25
	minstr = 11
	wdefense = 6
	possible_item_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/chop/falx, /datum/intent/rend/krieg, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/thrust/krieg, /datum/intent/rend/krieg, /datum/intent/sword/strike)
	alt_intents = null // Can't mordhau this
	smeltresult = /obj/item/ingot/silver
	is_silver = TRUE

/obj/item/rogueweapon/sword/long/kriegmesser/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/long/kriegmesser/psy
	name = "普赛顿阔剑"
	desc = "粉碎、劈裂、惩戒；一片凝固的漆黑之海上缀着猩红斑点。宽恕、珍惜、坚守；那是某人的意志，被祝圣为在万物尽失时拯救普赛多尼亚。 </br>“即便在这里也并不安全，连这座坟墓都已遭人亵渎。可仍有人以愤怒的笔迹在碑上刻下了字句：希望独行……”"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "silverbroadsword"
	sheathe_icon = "psysword"
	force = 20
	force_wielded = 25
	minstr = 11
	wdefense = 6
	possible_item_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/chop/falx, /datum/intent/rend/krieg, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/thrust/krieg, /datum/intent/rend/krieg, /datum/intent/sword/strike)
	alt_intents = null // Can't mordhau this
	smeltresult = /obj/item/ingot/silverblessed
	is_silver = TRUE

/obj/item/rogueweapon/sword/long/kriegmesser/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/short
	name = "钢短剑"
	desc = "单手剑更短、也更加古老的兄长。尽管它比今日诸剑古老了数个世纪，仍作为廉价副武器被盾兵与弓手广泛使用。"
	possible_item_intents = list(/datum/intent/sword/cut/short, /datum/intent/sword/thrust/short, /datum/intent/sword/peel)
	icon_state = "swordshort"
	sheathe_icon = "swordshort"
	gripped_intents = null
	minstr = 4
	wdefense = 4
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 32
	grid_height = 96

/obj/item/rogueweapon/sword/short/ancient
	name = "远古短剑"
	desc = "一把以吉布兰泽锻成并细细打磨的副武器短剑。它诞生于祂牺牲之后、她飞升之前；是那场毫无意义之战的贡税，由一群尚不知世界即将终结的争斗孩童所发动。"
	icon_state = "ashortsword"
	sheathe_icon = "ashortsword"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/sword/short/ancient/decrepit
	name = "破旧短剑"
	desc = "一把由磨损青铜打造、刃口崩裂的副武器短剑。很难判断它本就铸得如此短小，还是一把长剑最终只剩下了这截残身。"
	force = 18
	max_integrity = 75
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/sword/short/iron
	name = "铁短剑"
	desc = "单手剑更短、也更加古老的兄长。尽管它比今日诸剑古老了数个世纪，仍作为廉价副武器被盾兵与弓手广泛使用。而这把铁制版本比它们都更久远。"
	icon_state = "iswordshort"
	sheathe_icon = "iswordshort"
	wdefense = 3
	smeltresult = /obj/item/ingot/iron
	max_integrity = 100
	sellprice = 10

/obj/item/rogueweapon/sword/short/kazengun
	name = "钢小太刀"
	desc = "一柄锋利如剃刀的短剑，剑身上清晰可见波纹状锻焊纹理。"
	possible_item_intents = list(
		/datum/intent/sword/cut/short,
		/datum/intent/sword/thrust/short,
		/datum/intent/sword/peel,
		/datum/intent/sword/chop/short,
		)
	icon_state = "eastshortsword"
	sheathe_icon = "mulyeog"

/obj/item/rogueweapon/sword/short/falchion
	name = "法刀"
	desc = "一种单刃剑，外形与猎剑相近，起源可追溯至奥塔瓦。无论平民还是骑士都常使用它，既善切割，也能突刺。"
	force = 22
	icon_state = "falchion"
	wdefense = 6
	w_class = WEIGHT_CLASS_BULKY // Did not fit in a bag before path rework. Does not fit in a bag now either.
	sheathe_icon = "falchion"
	max_blade_int = 250

/obj/item/rogueweapon/sword/short/gladius
	name = "短剑"
	desc = "一柄前端略宽、没有护手的青铜短剑。最适合与盾配合，直直捅进敌人的肚腹。"
	icon_state = "gladius"
	sheathe_icon = "gladius"
	max_integrity = 200
	smeltresult = /obj/item/ingot/bronze
	wdefense = 3

/obj/item/rogueweapon/sword/short/gladius/ancient
	name = "远古短剑"
	desc = "一柄以吉布兰泽锻成并磨得锃亮的短剑。它深受齐佐不死军团士兵喜爱，而这件古旧兵器只有一个简单用途：把蒙昧蠢货的内脏掏出来。"
	icon_state = "agladius"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/sword/short/gladius/ancient/decrepit
	name = "破旧短剑"
	desc = "一把由磨损青铜打造的厚重短剑。它曾是骄傲军团士兵的副武器；如今，它是野心与牺牲的产物。"
	force = 18
	max_integrity = 150
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/sword/short/iron/chipped
	name = "缺口铁短剑"
	desc = "一把受损的古旧铁短剑。它看起来更加迟钝，也显得不太好使。"
	force = 17
	icon_state = "iswordshort_d"
	sheathe_icon = "iswordshort_d"
	max_integrity = 75

/obj/item/rogueweapon/sword/short/psy
	name = "普赛顿短剑"
	desc = "尽管剑刃已断，这把昔日的长剑仍在更短、更快、却丝毫不减致命的新形态中找到了新的使命。正如祂一般，无论如何都坚持不屈。"
	icon_state = "psyswordshort"
	sheathe_icon = "psyswordshort"
	force = 20
	force_wielded = 20
	minstr = 7
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/sword/short/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/short/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/short/silver
	name = "白银短剑"
	desc = "一柄以纯银铸刃的短剑。在描绘普赛多尼亚十字军修会的典籍边注中，最具代表性的身影莫过于披挂锁甲的圣武士：一手持鸢盾，另一手握着这把闪耀的副武器。"
	icon = 'icons/roguetown/weapons/daggers32.dmi'
	icon_state = "silverswordshort"
	sheathe_icon = "psyswordshort"
	force = 20
	force_wielded = 20
	minstr = 7
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/sword/short/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/short/messer
	name = "钢猎剑"
	desc = "一把据称源自格伦泽的“Großesmesser”，意为“大刀”。这是一种供民用与军用的基础单刃剑，尤其擅长挥砍与劈斩，并以钢打造。\
	它能完全胜任猎剑的用途，而这一把还更加耐用。"
	icon_state = "smesser"
	force = 24	//Hunting sword + 4
	max_blade_int = 250	//Sword + 50
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/rend/krieg/short, /datum/intent/axe/chop, /datum/intent/sword/peel)	//1.8x rend, similar to partizan
	minstr = 6	// Hunting sword +2
	wdefense = 4	//Hunting sword +2

/obj/item/rogueweapon/sword/short/messer/iron
	name = "猎剑"
	desc = "一把基础单刃剑，通常用于了结猎获物。它擅长挥砍与劈斩，由铁制成。\
	这是一件相当可靠且价格低廉的自卫武器。"
	icon_state = "imesser"
	minstr = 4
	wdefense = 2
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	smeltresult = /obj/item/ingot/iron
	max_integrity = 100
	sellprice = 10
	sheathe_icon = "isword"

/obj/item/rogueweapon/sword/short/messer/iron/virtue
	name = "决斗猎剑"
	desc = "一把为决斗用途改制的基础铁制猎剑，加装了护手，并采用更纤细的握柄，以兼顾舒适与速度。"
	icon_state = "dmesser"
	swingsound = BLADEWOOSH_SMALL
	wdefense = 3
	wbalance = WBALANCE_SWIFT

/obj/item/rogueweapon/sword/short/messer/copper
	name = "铜猎剑"
	desc = "一把铜制猎剑。杀伤力逊于它的铁制同类。"
	force = 20 // Worse force. This weapon has steel integ instead of iron integ. Don't ask me why, it was that way before too.
	icon_state = "cmesser"
	minstr = 4
	wdefense = 2
	smeltresult = /obj/item/ingot/copper

/obj/item/rogueweapon/sword/sabre
	name = "军刀"
	desc = "一种极受欢迎的骑兵背刃剑，起源于纳莱迪，随后一路向北传播，在阿夫纳尔被称作“萨布利亚”，并恶名昭彰地成为大统领骠骑兵最偏爱的武器。"
	icon_state = "saber"
	sheathe_icon = "saber"
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust/sabre, /datum/intent/sword/peel, /datum/intent/sword/strike)
	gripped_intents = null
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	swingsound = BLADEWOOSH_SMALL
	minstr = 5
	wdefense = 7		//Same as rapier
	wbalance = WBALANCE_SWIFT

/datum/intent/sword/cut/sabre
	clickcd = 8		//Faster than sword by 4
	damfactor = 1.25	//Better than rapier (Base is 1.1 for swords)
	penfactor = 10		//Very slight buff to pen on cut mode. Still weaker then sword-chop mode.

/datum/intent/sword/thrust/sabre
	clickcd = 9			//Fast but still not as fast as rapier n' shittier.
	damfactor = 0.9		//10% worse	than base

/obj/item/rogueweapon/sword/sabre/dec
	icon_state = "decsaber"
	sheathe_icon = "decsaber"
	sellprice = 140

/obj/item/rogueweapon/sword/sabre/ancient
	name = "远古寇派什弯剑"
	desc = "一把以吉尔布兰兹锻成、抛光如新的钩形剑。昔日，西翁彗星的辉光曾照耀这把刀刃；如今，挥舞它的人甚至已不记得祂牺牲前的世界。"
	smeltresult = /obj/item/ingot/aaslag
	icon_state = "akhopesh"

/obj/item/rogueweapon/sword/sabre/ancient/decrepit
	name = "破旧寇派什弯剑"
	desc = "一把以残旧青铜打造的钩形剑。它的设计不仅令人费解，甚至像是早于历史本身。"
	force = 18
	max_integrity = 115
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/sword/sabre/iron
	name = "铁军刀"
	desc = "一把为纳莱迪线列步兵量产的军刀。其配件简朴，属于军用品级，但结构结实，刀刃的威胁性丝毫不逊于别的兵刃。"
	smeltresult = /obj/item/ingot/iron
	max_integrity = 100
	icon_state = "isaber"
	sellprice = 10

/obj/item/rogueweapon/sword/sabre/steppesman
	name = "阿夫尼卡沙什卡"
	desc = "一把出自北地阿夫尼风格的无护手单刃单手刀，黄铜柄首被塑成扎德兽首。它的弧度介于大曲度军刀与直剑之间，兼顾挥砍与刺击，但纯粹防御性稍弱。"
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust/sabre, /datum/intent/rend, /datum/intent/sword/chop)
	wdefense = 5
	minstr = 6
	icon_state = "shashka"
	sheathe_icon = "shashka"

//Unique church sword - slightly better than regular sabre due to falx chop.
/obj/item/rogueweapon/sword/sabre/nockhopesh
	name = "月辉寇派什弯剑"
	desc = "一把源自纳莱迪的镰形剑，其设计脱胎于古代移民曾使用的一种战斧，象征着权力与征服。尤其这一把还是由发蓝钢锻成。"
	icon_state = "nockhopesh"
	force = 25	//Base is 22
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/chop/falx, /datum/intent/sword/peel)
	max_integrity = 200

/obj/item/rogueweapon/sword/sabre/elf
	name = "精灵军刀"
	desc = "这把制作精良的军刀采用了精灵风格设计。"
	icon_state = "esaber"
	item_state = "esaber"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 25
	force_wielded = 25
	minstr = 7
	wdefense = 9
	last_used = 0
	is_silver = FALSE
	smeltresult = /obj/item/ingot/gold
	smelt_bar_num = 2

/obj/item/rogueweapon/sword/sabre/stalker
	name = "潜猎者军刀"
	desc = "一把曾经优雅的秘银刀刃，如今在阳光的注视下逐渐黯淡。"
	icon_state = "spidersaber"
	force = 25 // same as elf sabre
	force_wielded = 25
	minstr = 7
	wdefense = 9

/obj/item/rogueweapon/sword/sabre/shamshir
	name = "沙姆希尔弯刀"
	desc = "一把弯曲的单手长剑。这类弯刀是齐班廷骑手最具代表性的武装，其名源自萨玛语，意为“虎爪”。"
	force = 24
	wdefense = 6 // two more force than sabre so let's consider this a fair tradeoff for the damage buff
	icon_state = "tabi"
	icon = 'icons/roguetown/weapons/64.dmi'
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/peel, /datum/intent/sword/strike) // whoever gave this chop as a supposed upside is tripping because it's weaker than sabre cut
	bigboy = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	dropshrink = 0.75

/obj/item/rogueweapon/sword/sabre/shamshir/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/rapier
	name = "刺剑"
	desc = "一种几乎可以说是全新问世的剑型，拥有笔直、纤长且尖锐的剑刃，专为单手持用而设计。\
		它起源于厄特鲁斯卡群岛，其名来自“spada ropera”（字面意为“礼服剑”），因为它最初首先是一种配饰。\
		与此同时，群岛上也正发展出一门尚且年轻的配套技艺，因其讲究巧劲而被称作“Destreza”。"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "rapier"
	sheathe_icon = "rapier"
	bigboy = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	dropshrink = 0.75
	possible_item_intents = list(/datum/intent/sword/thrust/rapier, /datum/intent/sword/cut/rapier, /datum/intent/sword/peel)
	special = /datum/special_intent/piercing_lunge
	gripped_intents = null
	parrysound = list(
		'sound/combat/parry/bladed/bladedthin (1).ogg',
		'sound/combat/parry/bladed/bladedthin (2).ogg',
		'sound/combat/parry/bladed/bladedthin (3).ogg',
		)
	swingsound = BLADEWOOSH_SMALL
	minstr = 6
	wdefense = 7
	wbalance = WBALANCE_SWIFT

/obj/item/rogueweapon/sword/rapier/vaquero
	name = "杯护手刺剑"
	desc = "一种特殊的厄特鲁斯卡刺剑变体。它的杯形护手相比当下刺剑的传统设计更易制造，同时也更能护手。"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "cup_hilt_rapier"
	wdefense = 8
	force = 25

/obj/item/rogueweapon/sword/rapier/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list(
				"shrink" = 0.5,
				"sx" = -14,
				"sy" = -8,
				"nx" = 15,
				"ny" = -7,
				"wx" = -10,
				"wy" = -5,
				"ex" = 7,
				"ey" = -6,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = -13,
				"sturn" = 110,
				"wturn" = -60,
				"eturn" = -30,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 8,
				"eflip" = 1,
				)
			if("onback") return list(
				"shrink" = 0.5,
				"sx" = -1,
				"sy" = 2,
				"nx" = 0,
				"ny" = 2,
				"wx" = 2,
				"wy" = 1,
				"ex" = 0,
				"ey" = 1,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 70,
				"eturn" = 15,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 1,
				"eflip" = 1,
				"northabove" = 1,
				"southabove" = 0,
				"eastabove" = 0,
				"westabove" = 0,
				)
			if("onbelt") return list(
				"shrink" = 0.4,
				"sx" = -4,
				"sy" = -6,
				"nx" = 5,
				"ny" = -6,
				"wx" = 0,
				"wy" = -6,
				"ex" = -1,
				"ey" = -6,
				"nturn" = 100,
				"sturn" = 156,
				"wturn" = 90,
				"eturn" = 180,
				"nflip" = 0,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 0,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				)

/datum/intent/sword/cut/rapier
	clickcd = 10
	damfactor = 0.75

/datum/intent/sword/thrust/rapier
	clickcd = 8
	damfactor = 1.1
	penfactor = 30

/obj/item/rogueweapon/sword/rapier/dec
	name = "装饰刺剑"
	desc = "一把古怪而廉价、似乎毫无实际用途的刺剑，却又莫名让人联想到某场戛然而止的惊天逆转。\n<i>“你会知晓他的名字。你会知晓他的使命。然后你会死。”</i>"
	icon_state = "decrapier"
	sheathe_icon = "decrapier"
	sellprice = 140

/obj/item/rogueweapon/sword/rapier/silver
	name = "白银刺剑"
	desc = "一把篮形护手刺剑，装配着纯银细刃。它因石丘镇的猎巫人而留名于世，虽说落在未经训练之人手里会显得笨重，却意外地擅长格挡与还击。"
	icon_state = "silverrapier"
	sheathe_icon = "psyrapier"
	max_integrity = 225
	max_blade_int = 225
	force = 20
	force_wielded = 20
	minstr = 8
	wdefense = 8
	smeltresult = /obj/item/ingot/silver
	is_silver = TRUE

/obj/item/rogueweapon/sword/rapier/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/rapier/psy
	name = "普赛顿刺剑"
	desc = "一把篮形护手刺剑，装配着纯银细刃。如此华美的兵器不仅能穿透异教徒锁甲的缝隙，也象征着奥塔凡外交使节的权威。"
	icon_state = "silverrapier"
	sheathe_icon = "rapier"
	max_integrity = 225
	max_blade_int = 225
	force = 20
	force_wielded = 20
	minstr = 8
	wdefense = 8
	smeltresult = /obj/item/ingot/silverblessed
	is_silver = TRUE

/obj/item/rogueweapon/sword/rapier/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/rapier/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/rapier/psy/relic
	name = "“圣餐”"
	desc = "厄特鲁斯卡的剑型，落入奥塔凡工艺之手。圣玛卢姆的铁匠打造出一柄独一无二的纤薄剑刃，能迅速刺穿那些多数人声称原本并不存在的缝隙，将不洁者与恶徒一并钉穿。<b>浸银钢刃加冕于篮形护手之上，使正义之手免遭伤害。</b>"
	icon_state = "psyrapier"
	sheathe_icon = "psyrapier"
	max_integrity = 300
	max_blade_int = 300
	force = 20
	force_wielded = 20
	minstr = 8
	wdefense = 8
	smeltresult = /obj/item/ingot/silver
	is_silver = TRUE

/obj/item/rogueweapon/sword/rapier/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/rapier/lord
	name = "疯公之剑"
	desc = "一件王室传家宝，其螺旋篮形护手上镶嵌着切工精美的宝石。它带着岁月磨出的包浆，那些原本锋锐鲜明的纹样已被无数双手磨得圆钝。古老传闻称，这件武器曾见证那场把疯公城堡夷为废墟、连公爵本人都焚成灰烬的围攻。"
	icon_state = "lordrap"
	sheathe_icon = "lordrapier"
	sellprice = 150
	max_integrity = 300
	max_blade_int = 300
	wdefense = 7

/obj/item/rogueweapon/sword/rapier/eora
	name = "“心弦”"
	desc = "一把专为侍奉艾欧拉女士而打造的比尔博柄刺剑。留给那些温言已无用武之地、唯有刺穿人心的时刻。"
	icon = 'icons/roguetown/weapons/swords32.dmi'
	icon_state = "eorarapier"
	sheathe_icon = "eorarapier"
	grid_width = 32
	grid_height = 64
	dropshrink = 0
	bigboy = FALSE
	force = 25 // Same statline as the cup hilted etruscan rapier
	wdefense = 8

/obj/item/rogueweapon/sword/rapier/courtphysician
	name = "cane blade"
	desc = "A steel blade with a gold handle, intended to be concealed inside of a cane, bears the visage of a vulture on its pommel."
	icon = 'icons/roguetown/weapons/swords32.dmi'
	icon_state = "doccaneblade"
	sheathe_icon = "doccaneblade"
	sellprice = 100 //Gold handle
	grid_width = 32
	grid_height = 64
	dropshrink = 0
	bigboy = FALSE
	possible_item_intents = list(/datum/intent/sword/thrust/rapier, /datum/intent/sword/cut/rapier)
	gripped_intents = null
	force_wielded = 0

/obj/item/rogueweapon/sword/rapier/hand
	name = "dark sister"
	desc = "A tool made for nobler tasks than shedding blood, discreet and ever ready, as you should be too."
	pixel_y = 0
	pixel_x = 0
	bigboy = FALSE
	icon = 'icons/roguetown/weapons/special/hand32.dmi'
	icon_state = "staffblade"
	item_state = "staffblade"
	sheathe_icon = "staffblade"

/obj/item/rogueweapon/sword/cutlass
	name = "短弯刀"
	desc = "水手的拿手货：一把短而宽的军刀，略带弧度的刀刃专为劈斩优化。"
	icon_state = "cutlass"
	force = 23
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/chop, /datum/intent/sword/peel)
	gripped_intents = null
	wdefense = 6
	wbalance = WBALANCE_SWIFT
	sheathe_icon = "cutlass"


/obj/item/rogueweapon/sword/silver
	name = "白银单手剑"
	desc = "一把装有纯银剑刃的单手剑。它是整个普赛多尼亚的吸血鬼、夜兽与亡骸的克星；受诅血肉会在圣焰中爆裂，不洁者的狂妄也会扭曲成凡人的恐惧。"
	icon_state = "silversword"
	sheathe_icon = "silversword"
	force = 18
	force_wielded = 23
	minstr = 9
	wdefense = 5
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver
	smelt_bar_num = 2
	max_blade_int = 230
	max_integrity = 200

/obj/item/rogueweapon/sword/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list(
				"shrink" = 0.5,
				"sx" = -14,
				"sy" = -8,
				"nx" = 15,
				"ny" = -7,
				"wx" = -10,
				"wy" = -5,
				"ex" = 7,
				"ey" = -6,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = -13,
				"sturn" = 110,
				"wturn" = -60,
				"eturn" = -30,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 8,
				"eflip" = 1,
				)
			if("onback") return list(
				"shrink" = 0.5,
				"sx" = -1,
				"sy" = 2,
				"nx" = 0,
				"ny" = 2,
				"wx" = 2,
				"wy" = 1,
				"ex" = 0,
				"ey" = 1,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 70,
				"eturn" = 15,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 1,
				"eflip" = 1,
				"northabove" = 1,
				"southabove" = 0,
				"eastabove" = 0,
				"westabove" = 0,
				)
			if("wielded") return list(
				"shrink" = 0.6,
				"sx" = 3,
				"sy" = 5,
				"nx" = -3,
				"ny" = 5,
				"wx" = -9,
				"wy" = 4,
				"ex" = 9,
				"ey" = 1,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 0,
				"eturn" = 15,
				"nflip" = 8,
				"sflip" = 0,
				"wflip" = 8,
				"eflip" = 0,
				)
			if("onbelt") return list(
				"shrink" = 0.4,
				"sx" = -4,
				"sy" = -6,
				"nx" = 5,
				"ny" = -6,
				"wx" = 0,
				"wy" = -6,
				"ex" = -1,
				"ey" = -6,
				"nturn" = 100,
				"sturn" = 156,
				"wturn" = 90,
				"eturn" = 180,
				"nflip" = 0,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 0,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				)

/obj/item/rogueweapon/sword/long/rhomphaia
	name = "罗姆法亚弯剑"
	desc = "一种与法尔克斯相似的古剑，关键区别在于其弧度较浅，因此因兼具精准挥击与刺击能力而令人畏惧。"
	force = 25
	force_wielded = 30
	possible_item_intents = list(/datum/intent/sword/cut/falx, /datum/intent/sword/strike, /datum/intent/sword/chop/falx, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut/falx, /datum/intent/sword/strike, /datum/intent/sword/chop/falx, /datum/intent/sword/peel)
	icon_state = "rhomphaia"
	smeltresult = /obj/item/ingot/steel
	max_integrity = 125

/obj/item/rogueweapon/sword/long/rhomphaia/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list(
				"shrink" = 0.5,
				"sx" = -14,
				"sy" = -8,
				"nx" = 15,
				"ny" = -7,
				"wx" = -10,
				"wy" = -5,
				"ex" = 7,
				"ey" = -6,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = -13,
				"sturn" = 110,
				"wturn" = -60,
				"eturn" = -30,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 8,
				"eflip" = 1,
				)
			if("onback") return list(
				"shrink" = 0.5,
				"sx" = -1,
				"sy" = 2,
				"nx" = 0,
				"ny" = 2,
				"wx" = 2,
				"wy" = 1,
				"ex" = 0,
				"ey" = 1,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 70,
				"eturn" = 15,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 1,
				"eflip" = 1,
				"northabove" = 1,
				"southabove" = 0,
				"eastabove" = 0,
				"westabove" = 0,
				)
			if("wielded") return list(
				"shrink" = 0.6,
				"sx" = 3,
				"sy" = 5,
				"nx" = -3,
				"ny" = 5,
				"wx" = -9,
				"wy" = 4,
				"ex" = 9,
				"ey" = 1,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 0,
				"eturn" = 15,
				"nflip" = 8,
				"sflip" = 0,
				"wflip" = 8,
				"eflip" = 0,
				)
			if("onbelt") return list(
				"shrink" = 0.4,
				"sx" = -4,
				"sy" = -6,
				"nx" = 5,
				"ny" = -6,
				"wx" = 0,
				"wy" = -6,
				"ex" = -1,
				"ey" = -6,
				"nturn" = 100,
				"sturn" = 156,
				"wturn" = 90,
				"eturn" = 180,
				"nflip" = 0,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 0,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				)

/obj/item/rogueweapon/sword/long/rhomphaia/copper
	name = "铜罗姆法亚弯剑"
	desc = "一种与法尔克斯相似的古剑，区别在于弧度较浅，因此因兼具精准挥击与刺击能力而令人畏惧。这一把由铜制成，因此更弱。"
	icon_state = "crhomphaia"
	force = 22
	force_wielded = 26
	max_integrity = 100
	smeltresult = /obj/item/ingot/copper

/obj/item/rogueweapon/sword/long/oathkeeper
	name = "誓约守望"
	desc = "一把华丽的金色长剑，剑柄嵌有红宝石，作为嘉奖授予为王冠英勇效命的骑士统领。"
	sellprice = 140
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	icon_state = "kingslayer"
	sheathe_icon = "kingslayer"

/obj/item/rogueweapon/sword/long/oathkeeper/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/holysee
	name = "圣蚀长剑"
	desc = "一把大师级工艺打造的长剑，由与主教佩剑相同的神圣合金锻成。当你的手指扣住剑柄时，一股受祝福的感受直抵灵魂深处：那是挺身抗恶的决意，以及将邪祟逐出这个世界的坚定。 </br>“……愿其蒙福，得以持有力量并带来希望，无论是在白昼，还是黑夜……”"
	icon_state = "seeblade"
	force = 35
	force_wielded = 50
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/peel, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/peel, /datum/intent/sword/chop)
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver
	smelt_bar_num = 2
	wdefense = 7
	max_blade_int = 777
	max_integrity = 999

/obj/item/rogueweapon/sword/long/holysee/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 0,\
		added_def = 0,\
	)

/obj/item/rogueweapon/sword/long/holysee/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list(
				"shrink" = 0.65,
				"sx" = -14,
				"sy" = -8,
				"nx" = 15,
				"ny" = -7,
				"wx" = -10,
				"wy" = -5,
				"ex" = 7,
				"ey" = -6,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = -13,
				"sturn" = 110,
				"wturn" = -60,
				"eturn" = -30,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 8,
				"eflip" = 1,
				)
			if("onback") return list(
				"shrink" = 0.65,
				"sx" = -1,
				"sy" = 2,
				"nx" = 0,
				"ny" = 2,
				"wx" = 2,
				"wy" = 1,
				"ex" = 0,
				"ey" = 1,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 70,
				"eturn" = 15,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 1,
				"eflip" = 1,
				"northabove" = 1,
				"southabove" = 0,
				"eastabove" = 0,
				"westabove" = 0,
				)
			if("wielded") return list(
				"shrink" = 0.6,
				"sx" = 3,
				"sy" = 5,
				"nx" = -3,
				"ny" = 5,
				"wx" = -9,
				"wy" = 4,
				"ex" = 9,
				"ey" = 1,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 0,
				"eturn" = 15,
				"nflip" = 8,
				"sflip" = 0,
				"wflip" = 8,
				"eflip" = 0,
				)
			if("onbelt") return list(
				"shrink" = 0.4,
				"sx" = -4,
				"sy" = -6,
				"nx" = 5,
				"ny" = -6,
				"wx" = 0,
				"wy" = -6,
				"ex" = -1,
				"ey" = -6,
				"nturn" = 100,
				"sturn" = 156,
				"wturn" = 90,
				"eturn" = 180,
				"nflip" = 0,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 0,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				)

/obj/item/rogueweapon/sword/long/kriegmesser
	name = "双手大刀"
	desc = "一把大型双手剑，拥有单刃剑身、十字护手与近似刀柄的握把。\
	它注定要以双手挥舞，也是格伦泽霍夫雇佣兵之间颇受欢迎的武器。"
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "kriegmesser"
	possible_item_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/chop/falx, /datum/intent/rend/krieg, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/thrust/krieg, /datum/intent/rend/krieg, /datum/intent/sword/strike)
	alt_intents = null // Can't mordhau this
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo
	name = "双手刀"
	desc = "风间郡甲拳众所用的一种长刃兵器，是将斩击之艺发挥到极致的武器。"
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "ssangsudo"
	sheathe_icon = "ssangsudo"
	gripped_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/rend, /datum/intent/sword/strike) // better rend by .05

/obj/item/rogueweapon/sword/long/dec
	name = "华饰长剑"
	desc = "一把为礼仪排场而打造的华贵长剑，配有上等皮革握柄与精雕细刻的镀金十字护手。\
	剑身两面各刻有一句铭文，一面写着“愿祢的国降临”，另一面则写着“愿祢的旨意成就”。"
	icon_state = "declongsword"
	sellprice = 140

// kazengite content
// Stronger offense less defense sword meant to be paired w/ scabbard for parrying
/obj/item/rogueweapon/sword/sabre/mulyeog
	force = 25
	name = "环刀" // From Korean Hwangdo - Lit. Military Sword / Sabre, noted for less curves than a Japanese katana.
	desc = "一把被割喉匪徒与地痞流氓常用的异域单刃剑。剑柄上系着红穗，据说能带来好运。"
	sheathe_icon = "mulyeog"
	icon_state = "eastsword1"
	smeltresult = /obj/item/ingot/steel
	wdefense = 3

/obj/item/rogueweapon/sword/sabre/mulyeog/rumahench
	name = "卢马环刀"
	desc = "一把异域钢制单刃剑，血槽上饰有云纹，剑身刻着卢马氏族的徽记。"
	icon_state = "eastsword2"
	force = 27
	max_integrity = 200
	sharpness_mod = 2
	sellprice = 50

/obj/item/rogueweapon/sword/sabre/mulyeog/rumacaptain
	force = 27
	name = "三正刀"
	desc = "一把染有金色光泽、血槽饰有云纹的长剑，独一无二，是卢马氏族内部地位的象征。"
	icon_state = "eastsword3"
	max_integrity = 200
	sharpness_mod = 2
	sellprice = 150

/obj/item/rogueweapon/sword/sabre/hook
	force = 20
	name = "钩剑"
	desc = "一把前端带钩的钢剑，极其适合缴械敌人。它的背刃同样开锋，护手末端也像被磨成了尖刺。"
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "hook_sword"
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust/hook, /datum/intent/sword/strike, /datum/intent/sword/disarm)
	max_integrity = 180
	wdefense = 5

/obj/item/rogueweapon/sword/sabre/hook/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list(
				"shrink" = 0.5,
				"sx" = -14,
				"sy" = -8,
				"nx" = 15,
				"ny" = -7,
				"wx" = -10,
				"wy" = -5,
				"ex" = 7,
				"ey" = -6,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = -13,
				"sturn" = 110,
				"wturn" = -60,
				"eturn" = -30,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 8,
				"eflip" = 1,
				)
			if("onback") return list(
				"shrink" = 0.5,
				"sx" = -1,
				"sy" = 2,
				"nx" = 0,
				"ny" = 2,
				"wx" = 2,
				"wy" = 1,
				"ex" = 0,
				"ey" = 1,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 70,
				"eturn" = 15,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 1,
				"eflip" = 1,
				"northabove" = 1,
				"southabove" = 0,
				"eastabove" = 0,
				"westabove" = 0,
				)
			if("onbelt") return list(
				"shrink" = 0.4,
				"sx" = -4,
				"sy" = -6,
				"nx" = 5,
				"ny" = -6,
				"wx" = 0,
				"wy" = -6,
				"ex" = -1,
				"ey" = -6,
				"nturn" = 100,
				"sturn" = 156,
				"wturn" = 90,
				"eturn" = 180,
				"nflip" = 0,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 0,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				)

/datum/intent/sword/thrust/hook
	damfactor = 0.9

//Snowflake version of hand-targeting disarm intent.
/datum/intent/sword/disarm
	name = "缴械"
	icon_state = "intake"
	animname = "strike"
	blade_class = null	//We don't use a blade class because it has on damage.
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 2	//Small delay to hook
	damfactor = 0.1	//No real damage
	clickcd = 22	//Can't spam this; long delay.
	item_d_type = "blunt"

/obj/item/rogueweapon/sword/sabre/hook/attack(mob/living/M, mob/living/user, bodyzone_hit)
	. = ..()
	var/skill_diff = 0
	if(istype(user.used_intent, /datum/intent/sword/disarm))
		var/obj/item/I
		if(user.zone_selected == BODY_ZONE_PRECISE_L_HAND && M.active_hand_index == 1)
			I = M.get_active_held_item()
		else
			if(user.zone_selected == BODY_ZONE_PRECISE_R_HAND && M.active_hand_index == 2)
				I = M.get_active_held_item()
			else
				I = M.get_inactive_held_item()
		if(user.mind)
			skill_diff += (user.get_skill_level(/datum/skill/combat/swords))	//You check your sword skill
		if(M.mind)
			skill_diff -= (M.get_skill_level(/datum/skill/combat/wrestling))	//They check their wrestling skill to stop the weapon from being pulled.
		user.stamina_add(rand(3,8))
		var/probby = clamp((((3 + (((user.STASTR - M.STASTR)/4) + skill_diff)) * 10)), 5, 95)
		if(I)
			if(M.mind)
				if(I.associated_skill)
					probby -= M.get_skill_level(I.associated_skill) * 5
			var/obj/item/mainhand = user.get_active_held_item()
			var/obj/item/offhand = user.get_inactive_held_item()
			if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && istype(offhand, mainhand))
				probby += 20	//We give notable bonus to dual-wielders who use two hooked swords.
			if(prob(probby))
				M.dropItemToGround(I, force = FALSE, silent = FALSE)
				user.stop_pulling()
				user.put_in_inactive_hand(I)
				M.visible_message(span_danger("[user]从[M]手中夺走了[I]！"), \
				span_userdanger("[user]从我手里夺走了[I]！"), span_hear("我听见一阵令人牙酸的扭打声！"), COMBAT_MESSAGE_RANGE)
				user.changeNext_move(12)//avoids instantly attacking with the new weapon
				playsound(src.loc, 'sound/combat/weaponr1.ogg', 100, FALSE, -1) //sound queue to let them know that they got disarmed
				if(!M.mind)	//If you hit an NPC - they pick up weapons instantly. So, we do more stuff.
					M.Stun(10)
			else
				probby += 20
				if(prob(probby))
					M.dropItemToGround(I, force = FALSE, silent = FALSE)
					M.visible_message(span_danger("[user]将[M]手中的[I]打落了！"), \
					span_userdanger("[user]把我手中的[I]打落了！"), span_hear("我听见一阵令人牙酸的扭打声！"), COMBAT_MESSAGE_RANGE)
					if(!M.mind)
						M.Stun(20)	//high delay to pick up weapon
					else
						M.Stun(6)	//slight delay to pick up the weapon
				else
					user.Immobilize(10)
					M.Immobilize(10)
					M.visible_message(span_notice("[user.name]拼命想缴掉[M.name]的武器！"))
					playsound(src.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
		if(!isliving(M))
			to_chat(user, span_warning("你无法缴这名敌人的械！"))
			return
		else
			to_chat(user, span_warning("对方那只手上什么都没拿！"))
			return

/obj/item/rogueweapon/sword/attack(mob/living/M, mob/living/user)
	if(user == M && user.used_intent && user.used_intent.blade_class == BCLASS_STAB && istype(user.rmb_intent, /datum/rmb_intent/weak))
		if(user.zone_selected == BODY_ZONE_PRECISE_STOMACH || user.zone_selected == BODY_ZONE_CHEST)
			if(user.doing)
				to_chat(user, span_warning("你已经在自我开膛的过程中！"))
				return
			user.visible_message(span_danger("[user]把[src]抵在自己腹部，准备开膛自己！"), span_notice("我把刀刃抵在腹部，开始慢慢推进……"))
			if(!do_after(user, 40, 1, user, 1)) // 4 seconds, hand required, target self, show progress
				to_chat(user, span_warning("你在真正开膛自己前停下了！"))
				return
			// Disembowelment success: drop organs
			var/list/spilled_organs = list()
			var/obj/item/organ/stomach/stomach = user.getorganslot(ORGAN_SLOT_STOMACH)
			if(stomach)
				spilled_organs += stomach
			var/obj/item/organ/liver/liver = user.getorganslot(ORGAN_SLOT_LIVER)
			if(liver)
				spilled_organs += liver
			var/obj/item/organ/heart/heart = user.getorganslot(ORGAN_SLOT_HEART)
			if(heart)
				spilled_organs += heart
			for(var/obj/item/organ/spilled as anything in spilled_organs)
				spilled.Remove(user)
				spilled.forceMove(user.drop_location())
			user.visible_message(span_danger("[user]开膛了自己，内脏哗啦啦流了出来！"), span_notice("当内脏从体内滑出时，我感到一阵可怖的剧痛！"))
			user.emote("scream", null, null, TRUE, TRUE) // forced scream
			user.overlay_fullscreen("painflash", /atom/movable/screen/fullscreen/painflash)
			return
	..()

/obj/item/rogueweapon/sword/capsabre // just a better sabre, unique knight captain weapon
	name = "“法理”"
	desc = "一把为船长打造的华贵军刀，这件独一无二的黑钢杰作正是为维护法度而生。"
	icon_state = "capsabre"
	icon = 'icons/roguetown/weapons/special/captain.dmi'
	force = 25 // same as elvish sabre
	max_integrity = 200 // more integrity because blacksteel, a bit less than the flamberge
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust/sabre, /datum/intent/sword/peel, /datum/intent/sword/strike)
	gripped_intents = null
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	swingsound = BLADEWOOSH_SMALL
	minstr = 5
	wdefense = 7
	wbalance = WBALANCE_SWIFT
	sellprice = 100 // lets not make it too profitable
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/sword/blacksteel
	name = "黑钢单手剑"
	desc = "一柄装有十字护手的长黑钢剑刃。数代以来，单手剑一直都是普赛多尼亚最经典的战争兵器，而这一把显然比钢制同类昂贵得多。"
	icon_state = "bs_sword"
	minstr = 6
	smeltresult = /obj/item/ingot/blacksteel
	max_integrity = 300
	sellprice = 150
	sheathe_icon = "sword1"

/obj/item/rogueweapon/sword/decorated/blacksteel
	name = "华饰单手剑"
	desc = "一把为礼仪排场而打造的华贵单手剑，拥有上等皮革握柄、精雕细刻的镀金十字护手，整片剑刃皆由黑钢打造。"
	icon_state = "bs_swordregal"
	max_integrity = 280
	sellprice = 200

/obj/item/rogueweapon/sword/long/shotel
	name = "钢索特尔弯刀"
	icon_state = "shotel_steel"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "一把具有齐班廷风格的长曲刃。"
	possible_item_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop/long) //Shotels get 2 tile reach.
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop/long)
	swingsound = BLADEWOOSH_LARGE
	parrysound = "largeblade"
	pickup_sound = "brandish_blade"
	bigboy = TRUE
	wlength = WLENGTH_LONG
	gripsprite = FALSE // OAUGHHHH!!! OAUGUUGHh!!!!1 aaaaAAAAAHH!!!
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	dropshrink = 0.8
	max_integrity = 150 //Sword with two tile reach but very low integrity.
	max_blade_int = 150

/obj/item/rogueweapon/sword/long/shotel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.4,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/shotel/iron
	name = "铁索特尔弯刀"
	icon_state = "shotel_iron"
	swingsound = BLADEWOOSH_LARGE
	max_integrity = 100
	max_blade_int = 100
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/sword/long/shotel/iron/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.4,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


//Elven weapons sprited and added by Jam
/obj/item/rogueweapon/sword/short/elf
	name = "精灵短剑"
	desc = "这把线条流畅的剑采用了经典的精灵风格设计。"
	icon_state = "elfsword"
	sellprice = 40
	sheathe_icon = "elfsword"

/obj/item/rogueweapon/sword/long/elf
	name = "精灵长剑"
	desc = "这把强劲而流畅的剑采用了经典的精灵风格设计。"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "elflongsword"
	sellprice = 50
	sheathe_icon = "elfsword"
