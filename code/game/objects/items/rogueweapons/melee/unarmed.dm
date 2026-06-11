/// INTENT DATUMS	v
/datum/intent/katar/cut
	name = "切割"
	icon_state = "incut"
	attack_verb = list("切开", "挥砍")
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
	name = "突刺"
	icon_state = "instab"
	attack_verb = list("突刺")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 25
	chargetime = 0
	clickcd = CLICK_CD_FAST
	item_d_type = "stab"

/datum/intent/knuckles/strike
	name = "拳击"
	blade_class = BCLASS_BLUNT
	attack_verb = list("拳击", "重击")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = 8
	swingdelay = 0
	icon_state = "inpunch"
	item_d_type = "blunt"
	intent_intdamage_factor = 1
	//We want chipping, m'lord.
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_WEAK

/datum/intent/knuckles/smash
	name = "猛砸"
	blade_class = BCLASS_SMASH
	attack_verb = list("猛砸")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = CLICK_CD_MELEE
	swingdelay = 8
	icon_state = "insmash"
	item_d_type = "blunt"
	//We want chipping, m'lord.
	blunt_chipping = TRUE
	blunt_chip_strength = BLUNT_CHIP_STRONG

/datum/intent/knuckles/strike/wallop
	name = "痛殴"
	blade_class = BCLASS_TWIST
	attack_verb = list("痛殴", "狠击", "猛抽")
	damfactor = 1.1
	intent_intdamage_factor = 0.6
	icon_state = "inbash"	// Wallop is too long for a button; placeholder.

//Knuckle utility. Use it to line up strikes. -2PER, -1LCK.
//Open up a feint window with it. 10 seconds duration.
/datum/intent/effect/daze/unarmed
	attack_verb = list("打击")
	damfactor = 0.8
	swingdelay = 8//Same as smash.
	intent_effect = /datum/status_effect/debuff/dazed/unarmed

/// INTENT DATUMS	^

//Weaponry.

/obj/item/rogueweapon/katar
	slot_flags = ITEM_SLOT_HIP
	force = 24
	possible_item_intents = list(/datum/intent/katar/cut, /datum/intent/katar/thrust)
	name = "拳刃"
	desc = "一柄架于持用者拳上的钢刃，常见于精通徒手搏斗之人手中。"
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
	name = "“气压创伤”"
	desc = "来自海中异兽的赠礼。这只利爪被磨出了阴毒锋锐的刃口。"
	icon_state = "abyssorclaw"
	force = 27	//Its thrust will be able to pen 80 stab armor if the wielder has 17 STR. (With softcap)
	max_integrity = 80

/obj/item/rogueweapon/katar/bronze
	name = "青铜拳刃"
	desc = "一柄架于持用者拳上的青铜刃，常见于精通徒手搏斗之人手中。"
	force = 21 //-3 damage malus, same as the knuckles.
	color = "#f9d690" //Not perfect, but should nearly replicate the bronze knuckle's palette. Someone could replace with an actual palette swap in the .dmi, when able.
	max_integrity = 80
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/katar/punchdagger
	name = "冲拳匕首"
	desc = "一种结合了齐班廷拳刃握持结构与西境普赛顿“骑士杀手”杀伤能力的武器。它可以系在手腕上。"
	slot_flags = ITEM_SLOT_WRISTS
	max_integrity = 120		//Steel dagger -30
	force = 15		//Steel dagger -5
	throwforce = 8
	wdefense = 0	//Hell no!
	thrown_bclass = BCLASS_STAB
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/thrust/pick)
	icon_state = "plug"

/obj/item/rogueweapon/katar/punchdagger/frei
	name = "开瓶钻"
	desc = "一种阿夫尼克式冲拳匕首，最初是为在徒手斗殴中与兽人抗衡而设计。它的锯齿边缘与更长、更细的尖锋，都是为了将痛楚最大化，因此得名“开瓶钻”；这一把还带着 Szorendnizina 的配色。可佩戴在戒指栏位。"
	icon_state = "freiplug"
	slot_flags = ITEM_SLOT_RING

/obj/item/rogueweapon/katar/punchdagger/aav
	name = "开瓶钻"
	desc = "一种阿夫尼克式冲拳匕首，最初是为在徒手斗殴中与兽人抗衡而设计。它的锯齿边缘与更长、更细的尖锋，都是为了将痛楚最大化，因此得名“开瓶钻”；这一把则采用了草原人的旗帜配色。可佩戴在戒指栏位。"
	icon_state = "avplug"
	slot_flags = ITEM_SLOT_RING

/obj/item/rogueweapon/katar/psydon
	name = "普赛顿拳刃"
	desc = "这是一种自云游僧侣手中传出的异域武器，其设计对奥塔凡正教而言颇为玄秘。它特别照顾了使用者的拳部防护：自尖端至刃缘皆为镶银钢材，中央又由祂的圣十字加固，弯曲护肩还能让持用者以刃身引导来袭打击。"
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
	name = "普赛顿指虎"
	desc = "一件以圣化钢银合金铸成的朴素凶器，前端收成三枚凸角，即普赛顿之冠，足以把异端的衣袍与护甲一并砸成碎片。"
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
	name = "耐战指虎"
	desc = "一件以圣化钢银合金铸成的朴素凶器，只是其神圣祝福早已褪去。你本就是祂的兵器，无须畏惧 Aeon。"
	icon_state = "psyknuckle"
	force = 17
	is_silver = FALSE
	smeltresult = /obj/item/ingot/steel
	color = COLOR_FLOORTILE_GRAY

/obj/item/rogueweapon/knuckles/psydon/old/ComponentInitialize()
	return

/obj/item/rogueweapon/knuckles
	name = "钢指虎"
	desc = "一对看起来就不好惹的钢制指虎。"
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
	special = /datum/special_intent/upper_cut

/obj/item/rogueweapon/knuckles/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.2,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 1,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 110,"sturn" = -110,"wturn" = -110,"eturn" = 110,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.1,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/knuckles/bronzeknuckles
	name = "青铜指虎"
	desc = "一对看起来就不好惹的青铜指虎。它比钢制同类略重一些，虽没那么灵活，却是更扎实的防御选择。"
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

/obj/item/rogueweapon/knuckles/ancient
	name = "远古指虎"
	desc = "一对由远古合金铸成的指虎，Aeon 对它们形体的桎梏已被解除。"
	icon_state = "aknuckle"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/knuckles/ancient/decrepit
	name = "破旧指虎"
	desc = "一对由远古合金铸成的指虎，只是它们的形体已在 Aeon 的掌握下衰败枯朽。"
	force = 12
	max_integrity = 100
	wdefense = 4
	blade_dulling = DULLING_SHAFT_CONJURED

/obj/item/rogueweapon/knuckles/eora
	name = "“贴身轻抚”"
	desc = "有些时候，事情就该用更贴近肌肤的方式来解决。"
	force = 24
	icon_state = "eoraknuckle"

//Claws. God, I hate these.
/obj/item/rogueweapon/handclaw
	slot_flags = ITEM_SLOT_HIP
	name = "铁猎犬爪"
	desc = "一对大幅弯曲的利爪，仿照荒野猛兽的爪形打造，专为撕开裸露血肉而生。 \
			它也彰显着格隆恩人对强悍野兽长久不衰的崇拜与敬畏。"
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
	name = "钢螳螂爪"
	desc = "一对钢制利爪，在格隆恩算是罕见之物，毕竟他们并不自行锻钢。 \
			更长的刃部带来了更优秀的防御能力，但额外重量也拖慢了它们。"
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
	name = "格隆恩兽爪"
	desc = "一对由北境空原的伊斯卡恩萨满以骨材加固锻成的独特铁爪。 \
			它们的特殊设计有助于滑入甲片缝隙之间，而轻巧重量也支持迅猛凶狠的连斩。 \
			“见到那四爪之形，便算见到了北境真正的危险。不是人，也不是土地，而是野兽。在它们眼里，我们皆是猎物。”"
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
	name = "突进"
	icon_state = "inimpale"
	attack_verb = list("突进")
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
	name = "切割"
	icon_state = "incut"
	attack_verb = list("切开", "挥砍")
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
	name = "撕裂"
	icon_state = "inrend"
	attack_verb = list("撕裂")
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
	sharpness_penalty = 2

/datum/intent/claw/rend/steel
	damfactor = 3
