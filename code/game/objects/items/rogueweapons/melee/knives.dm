//intent datums :3

/datum/intent/dagger
	clickcd = 8

/datum/intent/dagger/cut
	name = "切割"
	icon_state = "incut"
	attack_verb = list("切开", "挥砍")
	animname = "切割"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 0
	chargetime = 0
	swingdelay = 0
	clickcd = 10
	item_d_type = "slash"

/// For unusually heavy daggers with a strong cutting edge.
/datum/intent/dagger/cut/heavy
	name = "重切"
	damfactor = 1.2
	penfactor = 20
	clickcd = 11

/datum/intent/dagger/thrust
	name = "突刺"
	icon_state = "instab"
	attack_verb = list("突刺")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 40
	chargetime = 0
	clickcd = 8
	item_d_type = "stab"

// A slightly weaker thrust for daggers with a curved blade, or which otherwise aren't very good at stabbing.
/datum/intent/dagger/thrust/weak
	name = "偏锋刺"
	damfactor = 0.8

/datum/intent/dagger/thrust/pick
	name = "冰镐刺"
	icon_state = "inpick"
	attack_verb = list("刺入", "贯穿")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 80
	clickcd = 14
	swingdelay = 12
	damfactor = 1.1
	blade_class = BCLASS_PICK

/datum/intent/dagger/sucker_punch
	name = "必中一拳"
	icon_state = "inpunch"
	attack_verb = list("猛击", "戳击", "痛殴", "挥掠")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg', 'sound/combat/hits/kick/kick.ogg')
	damfactor = 0.6 // Less damage than a normal attack I don't want this to be better than stabbing
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = 14
	recovery = 10
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	canparry = FALSE
	candodge = FALSE

/datum/intent/dagger/chop
	name = "劈砍"
	icon_state = "inchop"
	attack_verb = list("劈砍")
	animname = "劈砍"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 10
	damfactor = 1.5
	swingdelay = 5
	clickcd = 10
	item_d_type = "slash"

/datum/intent/dagger/chop/cleaver
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = 30

//knife and dagger objs ฅ^•ﻌ•^ฅ

/obj/item/rogueweapon/huntingknife
	force = 12
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/dagger/chop)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	name = "猎刀"
	desc = "猎人珍爱的随身之物。只要磨得够锋利，它就能陪你熬过荒野。"
	icon_state = "huntingknife"
	sheathe_icon = "huntingknife"
	icon = 'icons/roguetown/weapons/daggers32.dmi'
	item_state = "bone_dagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	gripsprite = FALSE
	dropshrink = 0.8
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	max_blade_int = 200
	max_integrity = 175
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/knives
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	throwforce = 12
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	thrown_bclass = BCLASS_CUT
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	picklvl = 1

	grid_height = 64
	grid_width = 32
	equip_delay_self = 1 SECONDS
	unequip_delay_self = 1 SECONDS
	inv_storage_delay = 1 SECONDS
	edelay_type = 1

	//flipping knives has a cooldown on to_chat to reduce chatspam
	COOLDOWN_DECLARE(flip_cooldown)

/obj/item/rogueweapon/huntingknife/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -10,"sy" = 0,"nx" = 11,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/huntingknife/rmb_self(mob/user)
	. = ..()
	if(.)
		return

	SpinAnimation(4, 2) // The spin happens regardless of the cooldown

	if(!COOLDOWN_FINISHED(src, flip_cooldown))
		return

	COOLDOWN_START(src, flip_cooldown, 3 SECONDS)
	if((user.get_skill_level(/datum/skill/combat/knives) < 3) && prob(40))
		user.visible_message(
			span_danger("[user]想耍转[src]时，反倒把它甩掉了！"),
			span_userdanger("我想耍转[src]时，反倒把它甩掉了！"),
		)
		var/mob/living/carbon/human/unfortunate_idiot = user
		var/dropped_knife_target = pick(
			BODY_ZONE_PRECISE_L_FOOT,
			BODY_ZONE_PRECISE_R_FOOT,
			)
		unfortunate_idiot.apply_damage(src.force, BRUTE, dropped_knife_target)
		user.dropItemToGround(src, TRUE)
	else
		user.visible_message(
			span_notice("[user]让[src]在[user.p_their()]指间打转"),
			span_notice("我让[src]在指间打转"),
		)
		playsound(src, 'sound/foley/equip/swordsmall1.ogg', 20, FALSE)

	return



/obj/item/rogueweapon/huntingknife/copper
	name = "铜刀"
	desc = "一把铜制小刀。耐久略差。"
	icon_state = "cdagger"
	max_integrity = 75
	smeltresult = null // TODO: We don't have partial melt so coping time
	picklvl = 0.5

/obj/item/rogueweapon/huntingknife/bronze
	name = "青铜匕首"
	desc = "一柄宽阔的青铜刃，装在木制握柄上。古时的劳工与祭司都将它视若珍宝，既可应付日常劳作，也可用于祭祀仪式。"
	icon_state = "chefsknife"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/bronze, /datum/intent/dagger/sucker_punch, /datum/intent/dagger/thrust/bronze)
	color = "#f9d690"
	force = 18
	throwforce = 18
	max_blade_int = 225
	max_integrity = 175
	smeltresult = /obj/item/ingot/bronze
	picklvl = 0.8

/datum/intent/dagger/thrust/bronze
	name = "穿刺突刺"
	icon_state = "inpick"
	attack_verb = list("刺入", "贯穿")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 55
	clickcd = 12
	swingdelay = 6 //Halfway point between a 'stab' and 'pick'.
	damfactor = 1.05
	blade_class = BCLASS_PICK

/datum/intent/dagger/chop/bronze
	name = "楔锋劈砍"
	icon_state = "inchop"
	attack_verb = list("劈砍")
	animname = "劈砍"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 15
	damfactor = 1.3
	swingdelay = 5
	clickcd = 10
	item_d_type = "slash"

/obj/item/rogueweapon/huntingknife/cleaver
	force = 15
	name = "切肉刀"
	desc = "剁！剁！剁！"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver)
	icon_state = "cleaver"
	icon = 'icons/roguetown/weapons/daggers32.dmi'
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	throwforce = 15
	slot_flags = ITEM_SLOT_HIP
	thrown_bclass = BCLASS_CHOP
	w_class = WEIGHT_CLASS_NORMAL
	smeltresult = /obj/item/ingot/steel
	picklvl = 0.8

/obj/item/rogueweapon/huntingknife/cleaver/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,
"sx" = -10,
"sy" = 0,
"nx" = 13,
"ny" = 2,
"wx" = -8,
"wy" = 2,
"ex" = 5,
"ey" = 2,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 21,
"sturn" = -18,
"wturn" = -18,
"eturn" = 21,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/huntingknife/chefknife
	force = 15
	name = "厨刀"
	desc = "把它留在厨房里！"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver, /datum/intent/dagger/thrust)
	icon_state = "chefsknife"
	icon = 'icons/roguetown/weapons/daggers32.dmi'
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	throwforce = 15
	slot_flags = ITEM_SLOT_HIP
	thrown_bclass = BCLASS_CUT
	w_class = WEIGHT_CLASS_SMALL
	smeltresult = /obj/item/ingot/steel
	picklvl = 0.9

/obj/item/rogueweapon/huntingknife/combat
	force = 20
	name = "赛克斯短刀"
	desc = "一把大得吓人的侧佩短刀，数百年来一直被格伦泽尔人与北方人兼作战斗短刀与日常工具使用。"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver, /datum/intent/dagger/sucker_punch, /datum/intent/dagger/thrust/combat)
	icon_state = "combatknife"
	sheathe_icon = "combatknife"
	icon = 'icons/roguetown/weapons/daggers32.dmi'
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	throwforce = 16
	minstr = 9
	wdefense = 4
	slot_flags = ITEM_SLOT_HIP
	thrown_bclass = BCLASS_CHOP
	w_class = WEIGHT_CLASS_NORMAL
	smeltresult = /obj/item/ingot/steel
	picklvl = 1.1

/obj/item/rogueweapon/huntingknife/combat/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -10,"sy" = 0,"nx" = 11,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/dagger/thrust/combat
	name = "楔锋突刺"
	icon_state = "instab"
	attack_verb = list("剜刺")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 20
	damfactor = 0.9
	chargetime = 0
	clickcd = 8
	item_d_type = "stab"

/obj/item/rogueweapon/huntingknife/idagger
	possible_item_intents = list(/datum/intent/dagger/thrust,/datum/intent/dagger/cut, /datum/intent/dagger/thrust/pick, /datum/intent/dagger/sucker_punch)
	force = 15
	max_integrity = 100
	name = "铁匕首"
	desc = "这是一把常见的铁匕首。"
	icon_state = "idagger"
	sheathe_icon = "idagger"
	smeltresult = /obj/item/ingot/iron
	picklvl = 1.0

/obj/item/rogueweapon/huntingknife/idagger/virtue
	possible_item_intents = list(/datum/intent/dagger/thrust,/datum/intent/dagger/cut, /datum/intent/dagger/thrust/pick, /datum/intent/dagger/sucker_punch)
	force = 12
	throwforce = 12
	max_integrity = 100
	name = "格挡匕首"
	desc = "一把带延长护手的匕首，护手两端上翘，可用于架住来袭的武器。"
	icon_state = "ddagger"
	sheathe_icon = "idagger"
	smeltresult = /obj/item/ingot/iron
	wdefense = 7
	picklvl = 1.0

/* Wooden Daggers.
*  Intents, followed by the weapon itself.
*
*/
/datum/intent/dagger/thrust/wood
	penfactor = 15 //it is still a pointy piece of wood!
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')

/datum/intent/dagger/thrust/pick/wood
	penfactor = 35 //it is still a pointy piece of wood!
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')

/obj/item/rogueweapon/huntingknife/idagger/wood
	name = "木匕首"
	desc = "一把木制匕首。很适合训练。"
	icon_state = "wdagger"
	possible_item_intents = list(/datum/intent/dagger/thrust/wood, /datum/intent/dagger/sucker_punch, /datum/intent/dagger/thrust/pick/wood)
	force = 4 //half of a wielded wood sword's.
	thrown_bclass = BCLASS_BLUNT
	max_integrity = 90
	smeltresult = /obj/item/ash //It's a wooden dagger. What did you expect to happen?
	associated_skill = /datum/skill/combat/knives
	anvilrepair = /datum/skill/craft/carpentry //Wood swords get this, too.
	resistance_flags = FLAMMABLE //...It's made of wood.
	picklvl = 0.7

/obj/item/rogueweapon/huntingknife/idagger/steel
	name = "钢匕首"
	desc = "这是一把实心钢制匕首，更加耐用。"
	icon_state = "sdagger"
	sheathe_icon = "sdagger"
	force = 20
	max_integrity = 150
	smeltresult = /obj/item/ingot/steel
	picklvl = 1.1

/obj/item/rogueweapon/huntingknife/idagger/steel/ancient
	name = "远古匕首"
	desc = "一柄由抛光吉尔青铜锻成的短刃。暴力引导野心，而野心将使这世界挣脱死亡的锁链。齐佐，齐佐，齐佐——我呼唤你；唤来不死者，好让你的伟业得以成就！"
	icon_state = "adagger"
	sheathe_icon = "adagger"
	smeltresult = /obj/item/ingot/aaslag
	picklvl = 0.7

/obj/item/rogueweapon/huntingknife/idagger/steel/ancient/decrepit
	name = "破旧匕首"
	desc = "一柄短刃，以磨损青铜打造并嵌入朽木握柄之中。昔日军团士兵的鞘片仍粘在这暗淡无光的合金上。"
	force = 12
	max_integrity = 75
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/huntingknife/idagger/steel/corroded
	name = "蚀毒匕首"
	desc = "一柄阴毒凶险的施毒匕首，刃上满是锯齿与缺口。弯曲的钢护手托住指节，确保持用者不会把那致命剂量误施在自己身上。 </br>我可以把大多数毒药涂在这把匕首上，确保下一击留下一个溃烂惊喜。"
	icon_state = "pdagger"
	sheathe_icon = "pdagger"

/obj/item/rogueweapon/huntingknife/idagger/warden_machete
	possible_item_intents = list(/datum/intent/dagger/thrust/weak, /datum/intent/dagger/cut/heavy, /datum/intent/dagger/chop/cleaver, /datum/intent/dagger/sucker_punch) // Stronger cut and chop, but no pick.
	force = 22 // Slightly more damage than a steel dagger.
	max_integrity = 130 // Slightly less integrity than a steel dagger.
	name = "守望者赛克斯"
	desc = "一把磨损明显的赛克斯短刀，由守望者兄弟会同时当作工具与武器使用。它砍倒人的效率几乎 \
	和劈开灌木一样高，只是没有更现代的钢制工具那么耐用。相比突刺，它更适合挥砍。"
	icon_state = "warden_machete"
	sheathe_icon = "warden_machete"

/obj/item/rogueweapon/huntingknife/idagger/steel/corroded/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/tipped_item)	//Lets you tip your weapon in poison

/obj/item/rogueweapon/huntingknife/idagger/steel/dirk
	name = "獠牙匕首"
	desc = "一柄由卓尔打造的凶险匕首，装着残忍弯曲、形似利齿的刀刃。"
	icon_state = "spiderdagger"
	sheathe_icon = "spiderdagger"
	force = 22 // Same as elvish dagger
	smeltresult = null

/obj/item/rogueweapon/huntingknife/idagger/steel/holysee
	name = "蚀辉匕首"
	desc = "一缕天光，被塑成了这柄优雅匕首。合金本身放射着辉耀，提醒人们无论长夜多么深沉，终将仍有黎明随后而至。这样的匕首只配属于圣座的主教与司祭，既象征他们神授的权柄，也用于仪式性的放血。 </br>“……来吧，吾之子嗣，再次受膏于万神殿的光辉之中……”"
	force = 30 //The only instance of this dagger existing, outside of special admin-ran events, is when the Priest joins. They spawn with this on their person. Should be safe from Judgement-tier thefts.
	throwforce = 33
	throw_speed = 3
	armor_penetration = 50 //Only accounted for when thrown. Plays into the idea of 'divine intervention' - a literal 'hail mary' when facing down a terrible beast.
	embedding = list("embedded_pain_multiplier" = 1, "embed_chance" = 99, "embedded_fall_chance" = 0) //The 'last resort' for a Bishop. Ensures penetration and embedding, at the cost of the dagger itself.
	max_integrity = 222
	max_blade_int = 333
	icon_state = "gsdagger"
	sheathe_icon = "gsdagger"
	smeltresult = /obj/item/ingot/silver
	is_silver = TRUE
	picklvl = 1.1

/obj/item/rogueweapon/huntingknife/idagger/steel/holysee/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle
	name ="瘟灾之镰"
	desc = "邪恶的锋刃只会带来污秽的欢愉。"
	icon_state = "pestrasickle"
	force = 22 // 10% - This is a 8 clickCD weapon
	max_integrity = 200

/obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/tipped_item)	//Lets you tip your weapon in poison

/obj/item/rogueweapon/huntingknife/idagger/dtace
	name = "“缄默”"
	desc = "正是右手之人的右手，这截狭长钢刃专为迅速解决种种小麻烦而备。"
	icon_state = "stiletto"
	sheathe_icon = "stiletto"
	force = 25
	max_integrity = 200
	smeltresult = /obj/item/ingot/steel
	picklvl = 1.3

/obj/item/rogueweapon/huntingknife/idagger/dtace/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/tipped_item)	//Lets you tip your weapon in poison

/obj/item/rogueweapon/huntingknife/idagger/steel/parrying
	name = "钢制格挡匕首"
	force = 12
	throwforce = 12
	desc = "这是一把由实心钢打造的格挡匕首，可用护手卡住对手的兵器。不过，它的锋利度也因此稍差一些。"
	sheathe_icon = "spdagger"
	max_integrity = 175
	wdefense = 8		//This way with expert dagger skill you'd have ~12 defense. 1 higher than a kiteshield, but no arrow protection.
	picklvl = 1.1

/obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero
	name = "船帆匕首"
	force = 15
	throwforce = 15
	desc = "这是一种在厄特鲁斯卡群岛颇受欢迎、防护性极强的格挡匕首，装有一片造型朴素、形如船帆的金属护手。"
	max_integrity = 200
	wdefense = 9		//This way with expert dagger skill you'd have ~13 defense. 2 higher than a kiteshield, but no arrow protection.
	icon_state = "sail_dagger"
	picklvl = 1.1

/obj/item/rogueweapon/huntingknife/idagger/steel/special
	icon_state = "sdaggeralt"
	sheathe_icon = "sdaggeralt"

/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
	name = "钢短刀"
	desc = "一把自风间群岛进口的钢制短刀。坚实的刀身带着微微弧度，嵌入装饰华美的圆形护手之中。打蜡的 \
	绞绳缠柄让握持更加稳固。"
	icon_state = "eastdagger"
	sheathe_icon = "tanto"
	picklvl = 1.2

/obj/item/rogueweapon/huntingknife/idagger/silver
	name = "银匕首"
	desc = "一把纯银匕首；它是吸血鬼、狼人、死徒以及其他一切不洁夜行怪物的克星。掠过刃锋的微光都会化作刺目的炫芒。"
	icon_state = "sildagger"
	sheathe_icon = "sildagger"
	force = 15
	wdefense = 6
	sellprice = 50
	smeltresult = /obj/item/ingot/silver
	last_used = 0
	is_silver = TRUE
	picklvl = 1.1

/obj/item/rogueweapon/huntingknife/idagger/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/huntingknife/idagger/silver/stake
	name = "银尖木桩"
	desc = "一截自乳香木上折下的树枝，被削成尖锐细长的木桩，末端还包着受祝圣的白银。它足以让大多数不洁怪物永远安息，但前提是必须刺穿它们的心脏。"
	icon_state = "stake" //Should hopefully autogenerate an inhand. Need to politely ask a coder to import a custom sprite for this stake, later.
	icon = 'icons/roguetown/items/natural.dmi'
	force = 20
	throwforce = 20
	wdefense = 0
	max_integrity = 50
	sellprice = 50
	slot_flags = ITEM_SLOT_HIP
	smeltresult = /obj/item/rogueore/coal
	last_used = 0
	is_silver = TRUE
	equip_delay_self = 0 //No delay when stowing away, without a scabbard.
	unequip_delay_self = 0 //No delay when drawing.
	inv_storage_delay = 0 //No delay when retrieving from a storage slot.

/obj/item/rogueweapon/huntingknife/idagger/silver/stake/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 0,\
		added_def = 0,\
	)

/obj/item/rogueweapon/huntingknife/idagger/silver/stake/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 0,\
		added_def = 0,\
	)

/obj/item/rogueweapon/huntingknife/idagger/silver/stake/preblessed/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 0,\
		added_def = 0,\
	)

/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
	name = "普赛顿匕首"
	desc = "一柄装饰华美的匕首，覆有礼仪性的银层薄镀。若落在虔诚信徒猎手手中，它便是吸血鬼与狼人之灾。"
	icon_state = "psydagger"
	sheathe_icon = "psydagger"
	smeltresult = /obj/item/ingot/silverblessed
	sellprice = 70
	picklvl = 1.1

/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 2,\
	)
	sellprice += 200

/obj/item/weapon/knife/dagger/silver/arcyne
	name = "紫辉银匕首"
	desc = "这把匕首泛着微弱紫光。活银正沿着它的刀刃缓缓流转。"
	var/is_bled = FALSE
	picklvl = 1.1

/obj/item/weapon/knife/dagger/silver/arcyne/Initialize(mapload)
	. = ..()
	filter(type="drop_shadow", x=0, y=0, size=2, offset=1, color=rgb(128, 0, 128, 1))

/obj/item/weapon/knife/dagger/silver/attackby(obj/item/M, mob/user, params)
	if(istype(M,/obj/item/rogueore/cinnabar))
		var/crafttime = (60 - ((user.get_skill_level(/datum/skill/magic/arcane)) * 5))
		if(do_after(user, crafttime, target = src))
			playsound(loc, 'sound/magic/scrapeblade.ogg', 100, TRUE)
			to_chat(user, span_notice("我把奥术魔力压入刃中，它随即鼓动起深沉的紫辉……"))
			var/obj/arcyne_knife = new /obj/item/weapon/knife/dagger/silver/arcyne
			qdel(M)
			qdel(src)
			user.put_in_active_hand(arcyne_knife)
	else
		return ..()

/obj/item/weapon/knife/dagger/silver/arcyne/attack_self(mob/living/carbon/human/user)
	if(!isarcyne(user))
		return
	var/obj/effect/decal/cleanable/roguerune/pickrune
	var/runenameinput = input(user, "符文", "全部符文") as null|anything in GLOB.t4rune_types
	pickrune = GLOB.rune_types[runenameinput]
	if(!pickrune)
		return
	var/turf/Turf = get_turf(user)
	if(locate(/obj/effect/decal/cleanable/roguerune) in Turf)
		to_chat(user, span_cult("这里已经有一道符文了。"))
		return
	var/structures_in_way = check_for_structures_and_closed_turfs(loc, pickrune)
	if(structures_in_way == TRUE)
		to_chat(user, span_cult("有建筑、符文或墙壁挡在前面。"))
		return
	var/chosen_keyword
	if(pickrune.req_keyword)
		chosen_keyword = stripped_input(user, "新符文的关键词", "符文", max_length = MAX_NAME_LEN)
		if(!chosen_keyword)
			return FALSE
	if(!is_bled)
		playsound(loc, get_sfx("genslash"), 100, TRUE)
		user.visible_message(span_warning("[user]割开了[user.p_their()]手掌！"), \
			span_cult("我割开了自己的手掌！"))
		if(user.blood_volume)
			user.apply_damage(pickrune.scribe_damage, BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		is_bled = TRUE
	var/crafttime = (10 SECONDS - ((user.get_skill_level(/datum/skill/magic/arcane)) * 5))

	user.visible_message(span_warning("[user]开始用[user.p_their()]刀刃刻画什么！"), \
		span_notice("我开始拖动刀刃，刻出符号与印记的形状。"))
	playsound(loc, 'sound/magic/bladescrape.ogg', 100, TRUE)
	if(do_after(user, crafttime, target = src))
		if(QDELETED(src) || !pickrune)
			return
		user.visible_message(span_warning("[user]用[user.p_their()][src]刻出了一道奥术符文！"), \
		span_notice("我以刀刃刻完符号与圆环，留下了一道[pickrune.name]。"))
		new pickrune(Turf, chosen_keyword)

/obj/item/weapon/knife/dagger/proc/check_for_structures_and_closed_turfs(loc, obj/effect/decal/cleanable/roguerune/rune_to_scribe)
	for(var/turf/T in range(loc, rune_to_scribe.runesize))
		//check for /sturcture subtypes in the turf's contents
		for(var/obj/structure/S in T.contents)
			return TRUE		//Found a structure, no need to continue
		//check if turf itself is a /turf/closed subtype
		if(istype(T,/turf/closed))
			return TRUE
		//check if rune in the turfs contents
		for(var/obj/effect/decal/cleanable/roguerune/R in T.contents)
			return TRUE
		//Return false if nothing in range was found
	return FALSE

/obj/item/rogueweapon/huntingknife/stoneknife
	possible_item_intents = list(/datum/intent/dagger/cut,/datum/intent/dagger/chop)
	name = "石刀"
	desc = "一把粗糙打制的石刀。"
	icon_state = "stone_knife"
	smeltresult = null
	max_integrity = 50
	max_blade_int = 100
	wdefense = 1
	resistance_flags = FLAMMABLE
	picklvl = 0.3

/obj/item/rogueweapon/huntingknife/stoneknife/kukri
	name = "玉库克里刀"
	desc = "一把玉制库克里刀。与其说是兵器，不如说更偏向仪式用品；它略显脆弱，得轻拿轻放。"
	icon = 'icons/roguetown/gems/gem_jade.dmi'
	icon_state = "kukri_jade"
	max_integrity = 75
	max_blade_int = 50
	wdefense = 3
	resistance_flags = FIRE_PROOF | ACID_PROOF
	sellprice = 75

/obj/item/rogueweapon/huntingknife/stoneknife/opalknife
	name = "欧泊小刀"
	desc = "一把以欧泊雕成的美丽小刀。它并非为战斗打造，却在某些赤精灵仪式中不可或缺。"
	icon = 'icons/roguetown/gems/gem_opal.dmi'
	icon_state = "knife_opal"
	max_integrity = 75
	max_blade_int = 50
	wdefense = 3
	resistance_flags = FIRE_PROOF | ACID_PROOF
	sellprice = 105

/obj/item/rogueweapon/huntingknife/idagger/silver/elvish
	name = "精灵匕首"
	desc = "这把美丽匕首采用精巧的精灵风设计，也更加锋利。"
	force = 22
	icon_state = "elfdagger"
	item_state = "elfdag"
	last_used = 0
	is_silver = FALSE
	picklvl = 1.2

/obj/item/rogueweapon/huntingknife/idagger/silver/elvish/drow
	name = "黑暗精灵匕首"
	desc = "一把来自地下黑域、刃形如波的凶恶匕首。"
	force = 18
	last_used = 0
	is_silver = TRUE
	picklvl = 1.2

/obj/item/rogueweapon/huntingknife/idagger/navaja
	possible_item_intents = list(/datum/intent/dagger/thrust,/datum/intent/dagger/cut,  /datum/intent/dagger/thrust/pick)
	name = "纳瓦哈折刀"
	desc = "一把可折叠的伊特鲁里亚刀，因便于携带而深受商人、佣兵与农夫喜爱。它的刀柄较长，能容下尺寸可观、攻击距离不错的刀刃。"
	force = 5
	icon_state = "navaja_c"
	item_state = "elfdag"
	var/extended = 0
	wdefense = 2
	sellprice = 30 //shiny :o
	picklvl = 1.0

/obj/item/rogueweapon/huntingknife/idagger/navaja/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	if(extended)
		force = 20
		wdefense = 6
		wdefense_dynamic = 6
		w_class = WEIGHT_CLASS_NORMAL
		throwforce = 23
		icon_state = "navaja_o"
		attack_verb = list("砍伤", "刺伤", "切开", "撕裂", "扯裂", "剁碎", "割伤")
		sharpness = IS_SHARP
		playsound(user, 'sound/items/knife_open.ogg', 100, TRUE)
		equip_delay_self = initial(equip_delay_self)
		unequip_delay_self = initial(unequip_delay_self)
		inv_storage_delay = initial(inv_storage_delay)
	else
		force = 5
		w_class = WEIGHT_CLASS_SMALL
		throwforce = 5
		icon_state = "navaja_c"
		attack_verb = list("戳击", "捅刺")
		sharpness = IS_BLUNT
		wdefense = 2
		wdefense_dynamic = 2
		equip_delay_self = 0 SECONDS
		unequip_delay_self = 0 SECONDS
		inv_storage_delay = 0 SECONDS

/obj/item/rogueweapon/huntingknife/throwingknife
	name = "铁制投刃"
	desc = "颇为矛盾；既然它本是拿来投掷的，为何还叫作刀刃？还是说，掷出后能割伤人的那一刻，才让它成了刀刃？……那箭矢也算投刃吗？</br>这把匕首可以藏在靴子里，需要时便能迅速抽出。"
	item_state = "bone_dagger"
	force = 10
	throwforce = 22
	throw_speed = 4
	max_integrity = 50
	armor_penetration = 30
	wdefense = 1
	icon_state = "throw_knifei"
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 25, "embedded_fall_chance" = 10)
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/chop)
	smeltresult = null
	sellprice = 1
	thrown_damage_flag = "piercing"		//Checks piercing type like an arrow.
	picklvl = 0.8

/obj/item/rogueweapon/huntingknife/throwingknife/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -3,"wx" = -4,"wy" = -3,"ex" = 5,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/huntingknife/throwingknife/kazengun
	name = "东方投刃"
	desc = "一把由整块金属磨制并开锋而成的四尖投刀。它的设计正是为了解决基础投刃的一项弱点； \
	更多尖端意味着它更容易尖端先着地。 </br>这把匕首可以藏在靴子里，需要时便能迅速抽出。"
	icon_state = "easttossblade"
	picklvl = 0.8

/obj/item/rogueweapon/huntingknife/throwingknife/steel
	name = "钢制投刃"
	desc = "有传闻说某些海上劫掠者会把这玩意塞进金属管里，用爆炸粉末将其发射得又快又远。大概是流行不起来的。 </br>这把匕首可以藏在靴子里，需要时便能迅速抽出。"
	item_state = "bone_dagger"
	throwforce = 28
	max_integrity = 100
	armor_penetration = 40
	icon_state = "throw_knifes"
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 30, "embedded_fall_chance" = 5)
	sellprice = 2
	picklvl = 0.9

/obj/item/rogueweapon/huntingknife/throwingknife/steel/ancient
	name = "远古投刃"
	desc = "一片抛光过的吉布兰泽，被精细雕琢成投掷匕首。它是齐佐不死密教的心头好，尤其受她的刺客偏爱；还有什么工具比它更适合抹过别人的喉咙？ </br>这把匕首可以藏在靴子里，需要时便能迅速抽出。"
	icon_state = "throw_knifea"
	picklvl = 0.6

/obj/item/rogueweapon/huntingknife/throwingknife/steel/ancient/decrepit
	name = "残破投刃"
	desc = "几块磨损严重的青铜碎片，被粗糙地磨成投掷匕首。照这成色，你还不如直接把餐具砸过去。 </br>这把匕首可以藏在靴子里，需要时便能迅速抽出。"
	color = "#bb9696"
	force = 7
	throwforce = 16
	randomize_blade_int_on_init = TRUE
	picklvl = 0.6

/obj/item/rogueweapon/huntingknife/throwingknife/silver
	name = "银制投刃"
	desc = "算是银匕首的近亲；更薄、更脆弱，但投掷精度异常出色。老练的邪祟猎手常会在身上暗藏一把，以备不时之需。 </br>这把匕首可以藏在靴子里，需要时便能迅速抽出。"
	item_state = "bone_dagger"
	force = 10
	throwforce = 20
	armor_penetration = 50
	max_integrity = 150
	wdefense = 3
	icon_state = "throw_knifesil"
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 50, "embedded_fall_chance" = 0)
	is_silver = TRUE
	sellprice = 6
	picklvl = 0.9

/obj/item/rogueweapon/huntingknife/throwingknife/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 3,\
	)

/obj/item/rogueweapon/huntingknife/throwingknife/psydon
	name = "普赛顿投刃"
	desc = "一种把白银送进异端体内的非常规手段；不过普赛顿显然对此颇为欣赏。真要逼急了，它也能当匕首用，虽然显然没那么好使。 </br>这把匕首可以藏在靴子里，需要时便能迅速抽出。"
	item_state = "bone_dagger"
	force = 10
	throwforce = 20
	armor_penetration = 50
	max_integrity = 150
	wdefense = 3
	icon_state = "throw_knifep"
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 50, "embedded_fall_chance" = 0)
	is_silver = TRUE
	sellprice = 6
	picklvl = 0.9

/obj/item/rogueweapon/huntingknife/throwingknife/psydon/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 3,\
	)

/obj/item/rogueweapon/huntingknife/throwingknife/bauernwehr
	name = "鲍恩维尔刀"
	desc = "朝圣者最亲近的伙伴，一截短小却锋利的刀刃，装在木制握柄上。在格伦泽尔霍夫，这类刀被称作“鲍恩维尔刀”，能让任何辛劳都有所回应。这把刀可以藏在靴子里。"
	icon_state = "throw_knifei"
	wdefense = 1
	max_blade_int = 250
	max_integrity = 250
	force = 10
	throwforce = 10
	throw_speed = 2
	armor_penetration = 20
	embedding = list("embedded_pain_multiplier" = 5, "embed_chance" = 75, "embedded_fall_chance" = 10)
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver, /datum/intent/snip, /datum/intent/dagger/sucker_punch)
	picklvl = 0.8

/obj/item/rogueweapon/huntingknife/scissors
	possible_item_intents = list(/datum/intent/snip, /datum/intent/dagger/thrust, /datum/intent/dagger/cut)
	max_integrity = 100
	name = "铁剪刀"
	desc = "铁制剪刀，可用于从衣物上拆取还能用的材料。"
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "iscissors"
	inv_storage_delay = null

/obj/item/rogueweapon/huntingknife/scissors/steel
	force = 14
	max_integrity = 150
	name = "钢剪刀"
	desc = "实心钢制剪刀，可用于从衣物上拆取还能用的材料；比铁剪刀更耐用，也稍微更危险一点。"
	icon_state = "sscissors"
	smeltresult = /obj/item/ingot/steel

/datum/intent/snip // The salvaging intent!
	name = "剪裁"
	icon_state = "insnip"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0
	no_attack = TRUE
	releasedrain = 0
	blade_class = BCLASS_PUNCH

/obj/item/rogueweapon/huntingknife/scissors/attack(mob/living/M, mob/living/user)
	// Check if using snip intent and targeting a human's head or skull
	if(user.used_intent.type == /datum/intent/snip && ishuman(M))
		var/mob/living/carbon/human/H = M
		// Check if targeting the head or skull zone
		if(user.zone_selected == BODY_ZONE_HEAD || user.zone_selected == BODY_ZONE_PRECISE_SKULL)
			var/list/options = list("发型", "面部毛发", "修整发型")
			var/chosen = input(user, "你想修整什么？", "发型修整") as null|anything in options
			if(!chosen)
				return

			switch(chosen)
				if("发型")
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
					var/list/valid_hairstyles = list()
					for(var/hair_type in hair_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/head/hair = new hair_type()
						valid_hairstyles[hair.name] = hair_type

					var/new_style = input(user, "选择对方发型", "发型修整") as null|anything in valid_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user]开始修整[H]的发型……"), span_notice("我开始修整[H == user ? "自己的" : "[H]的"]发型……"))
						if(!do_after(user, 30 SECONDS, target = H))
							to_chat(user, span_warning("修整被打断了！"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/head/current_hair = null
							for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
								current_hair = hair_feature
								break

							if(current_hair)
								var/datum/customizer_entry/hair/hair_entry = new()
								hair_entry.hair_color = current_hair.hair_color

								// Preserve gradients and their colors
								if(istype(current_hair, /datum/bodypart_feature/hair/head))
									hair_entry.natural_gradient = current_hair.natural_gradient
									hair_entry.natural_color = current_hair.natural_color
									if(hasvar(current_hair, "hair_dye_gradient"))
										hair_entry.dye_gradient = current_hair.hair_dye_gradient
									if(hasvar(current_hair, "hair_dye_color"))
										hair_entry.dye_color = current_hair.hair_dye_color

								var/datum/bodypart_feature/hair/head/new_hair = new()
								new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)
								hair_choice.customize_feature(new_hair, H, null, hair_entry)

								head.remove_bodypart_feature(current_hair)
								head.add_bodypart_feature(new_hair)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user]修整好了[H]的发型。"), span_notice("我修整好了[H == user ? "自己的" : "[H]的"]发型。"))
								H.add_stress(/datum/stressevent/fresh_haircut)

				if("面部毛发")
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
					var/list/valid_facial_hairstyles = list()
					for(var/facial_type in facial_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/facial/facial = new facial_type()
						valid_facial_hairstyles[facial.name] = facial_type

					var/new_style = input(user, "选择对方面部毛发样式", "发型修整") as null|anything in valid_facial_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user]开始修整[H]的面部毛发……"), span_notice("我开始修整[H == user ? "自己的" : "[H]的"]面部毛发……"))
						if(!do_after(user, 60 SECONDS, target = H))
							to_chat(user, span_warning("修整被打断了！"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/facial/current_facial = null
							for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
								current_facial = facial_feature
								break

							if(current_facial)
								var/datum/customizer_entry/hair/facial/facial_entry = new()
								facial_entry.hair_color = current_facial.hair_color
								facial_entry.accessory_type = current_facial.accessory_type

								var/datum/bodypart_feature/hair/facial/new_facial = new()
								new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)
								facial_choice.customize_feature(new_facial, H, null, facial_entry)

								head.remove_bodypart_feature(current_facial)
								head.add_bodypart_feature(new_facial)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user]修整好了[H]的面部毛发。"), span_notice("我修整好了[H == user ? "自己的" : "[H]的"]面部毛发。"))
								H.add_stress(/datum/stressevent/fresh_haircut)

				if("修整发型")
					user.visible_message(span_notice("[user]开始整理[H]的头发……"), span_notice("我开始整理[H == user ? "自己的" : "[H]的"]头发……"))
					if(!do_after(user, 15 SECONDS, target = H))
						to_chat(user, span_warning("整理被打断了！"))
						return
					playsound(src, 'sound/items/flint.ogg', 50, TRUE)
					user.visible_message(span_notice("[user]整理好了[H]的头发。"), span_notice("我整理好了[H == user ? "自己的" : "[H]的"]头发。"))
					H.add_stress(/datum/stressevent/fresh_haircut)
			return TRUE
	// If not using snip intent on head/skull or not a human, proceed with normal attack
	if(user.used_intent.type == /datum/intent/snip)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/list/options = list("发型", "面部毛发", "修整发型")
			var/chosen = input(user, "你想修整什么？", "发型修整") as null|anything in options
			if(!chosen)
				return

			switch(chosen)
				if("发型")
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
					var/list/valid_hairstyles = list()
					for(var/hair_type in hair_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/head/hair = new hair_type()
						valid_hairstyles[hair.name] = hair_type

					var/new_style = input(user, "选择对方发型", "发型修整") as null|anything in valid_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user]开始修整[H]的发型……"), span_notice("我开始修整[H == user ? "自己的" : "[H]的"]发型……"))
						if(!do_after(user, 60 SECONDS, target = H))
							to_chat(user, span_warning("修整被打断了！"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/head/current_hair = null
							for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
								current_hair = hair_feature
								break

							if(current_hair)
								var/datum/customizer_entry/hair/hair_entry = new()
								hair_entry.hair_color = current_hair.hair_color

								// Preserve gradients and their colors
								if(istype(current_hair, /datum/bodypart_feature/hair/head))
									hair_entry.natural_gradient = current_hair.natural_gradient
									hair_entry.natural_color = current_hair.natural_color
									if(hasvar(current_hair, "hair_dye_gradient"))
										hair_entry.dye_gradient = current_hair.hair_dye_gradient
									if(hasvar(current_hair, "hair_dye_color"))
										hair_entry.dye_color = current_hair.hair_dye_color

								var/datum/bodypart_feature/hair/head/new_hair = new()
								new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)
								hair_choice.customize_feature(new_hair, H, null, hair_entry)

								head.remove_bodypart_feature(current_hair)
								head.add_bodypart_feature(new_hair)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user]修整好了[H]的发型。"), span_notice("我修整好了[H == user ? "自己的" : "[H]的"]发型。"))
								H.add_stress(/datum/stressevent/fresh_haircut)

				if("面部毛发")
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
					var/list/valid_facial_hairstyles = list()
					for(var/facial_type in facial_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/facial/facial = new facial_type()
						valid_facial_hairstyles[facial.name] = facial_type

					var/new_style = input(user, "选择对方面部毛发样式", "发型修整") as null|anything in valid_facial_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user]开始修整[H]的面部毛发……"), span_notice("我开始修整[H == user ? "自己的" : "[H]的"]面部毛发……"))
						if(!do_after(user, 60 SECONDS, target = H))
							to_chat(user, span_warning("修整被打断了！"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/facial/current_facial = null
							for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
								current_facial = facial_feature
								break

							if(current_facial)
								var/datum/customizer_entry/hair/facial/facial_entry = new()
								facial_entry.hair_color = current_facial.hair_color
								facial_entry.accessory_type = current_facial.accessory_type

								var/datum/bodypart_feature/hair/facial/new_facial = new()
								new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)
								facial_choice.customize_feature(new_facial, H, null, facial_entry)

								head.remove_bodypart_feature(current_facial)
								head.add_bodypart_feature(new_facial)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user]修整好了[H]的面部毛发。"), span_notice("我修整好了[H == user ? "自己的" : "[H]的"]面部毛发。"))
								H.add_stress(/datum/stressevent/fresh_haircut)

				if("修整发型")
					user.visible_message(span_notice("[user]开始整理[H]的头发……"), span_notice("我开始整理[H == user ? "自己的" : "[H]的"]头发……"))
					if(!do_after(user, 15 SECONDS, target = H))
						to_chat(user, span_warning("整理被打断了！"))
						return
					playsound(src, 'sound/items/flint.ogg', 50, TRUE)
					user.visible_message(span_notice("[user]整理好了[H]的头发。"), span_notice("我整理好了[H == user ? "自己的" : "[H]的"]头发。"))
					H.add_stress(/datum/stressevent/fresh_haircut)
			return
	return ..()

/obj/item/rogueweapon/huntingknife/attack_obj(obj/O, mob/living/user)
	if(user.used_intent.type == /datum/intent/snip && istype(O, /obj/item))
		var/obj/item/item = O
		if(item.sewrepair && item.salvage_result) // We can only salvage objects which can be sewn!
			var/salvage_time = 70
			salvage_time = (70 - ((user.get_skill_level(/datum/skill/craft/sewing)) * 10))
			if(!do_after(user, salvage_time, target = user))
				return

			if(item.fiber_salvage) //We're getting fiber as base if fiber is present on the item
				new /obj/item/natural/fibers(get_turf(item))
			if(istype(item, /obj/item/storage))
				var/obj/item/storage/bag = item
				bag.emptyStorage()
			var/skill_level = user.get_skill_level(/datum/skill/craft/sewing)
			if(prob(50 - (skill_level * 10))) // We are dumb and we failed!
				to_chat(user, span_info("我手艺不够，糟蹋了一些材料……"))
				playsound(item, 'sound/foley/cloth_rip.ogg', 50, TRUE)
				qdel(item)
				user.mind.add_sleep_experience(/datum/skill/craft/sewing, (user.STAINT)) //Getting exp for failing
				return //We are returning early if the skill check fails!
			item.salvage_amount -= item.torn_sleeve_number
			for(var/i = 1; i <= item.salvage_amount; i++) // We are spawning salvage result for the salvage amount minus the torn sleves!
				var/obj/item/Sr = new item.salvage_result(get_turf(item))
				Sr.color = item.color
			user.visible_message(span_notice("[user]把[item]拆成了可用材料。"))
			playsound(item, 'sound/items/flint.ogg', 100, TRUE)
			qdel(item)
			user.mind.add_sleep_experience(/datum/skill/craft/sewing, (user.STAINT))
	return ..()
