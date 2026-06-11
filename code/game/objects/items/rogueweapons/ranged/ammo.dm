#define ARROW_DAMAGE		50
#define BOLT_DAMAGE			70
#define BULLET_DAMAGE		80
#define ARROW_PENETRATION	40
#define BOLT_PENETRATION	50
#define BULLET_PENETRATION	100

//parent of all bolts and arrows ฅ^•ﻌ•^ฅ
/obj/item/ammo_casing/caseless/rogue/
	firing_effect_type = null

//bolts ฅ^•ﻌ•^ฅ

/obj/item/ammo_casing/caseless/rogue/bolt
	name = "弩矢"
	desc = "一支结实的铁制弩矢，轻易就能贯穿头骨。"
	projectile_type = /obj/projectile/bullet/reusable/bolt
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	caliber = "regbolt"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "bolt"
	dropshrink = 0.6
	max_integrity = 10
	force = 10

/obj/item/ammo_casing/caseless/rogue/bolt/decrepit
	name = "破旧弩矢"
	desc = "一支古老弩矢，尖端为磨损青铜。它早已失去数百年前那份光泽。"
	icon_state = "ancientbolt"
	projectile_type = /obj/projectile/bullet/reusable/bolt/decrepit
	color = "#bb9696"

/obj/item/ammo_casing/caseless/rogue/bolt/ancient
	name = "远古弩矢"
	desc = "一支古老弩矢，尖端为抛光吉布兰泽。那薄如剃刀的矢尖比起箭头更像脱壳穿甲体，大多数合金都难以稳稳承受它的冲击。"
	icon_state = "ancientbolt"
	projectile_type = /obj/projectile/bullet/reusable/bolt/ancient

/obj/item/ammo_casing/caseless/rogue/bolt/blunt
	name = "训练弩矢"
	desc = "一支前端包有软垫的弩矢。更烦人，而非致命。"
	projectile_type = /obj/projectile/bullet/reusable/bolt/blunt
	possible_item_intents = list(/datum/intent/mace/strike)
	icon_state = "bolt_blunt"
	force = 5

/obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt
	name = "重型钝头弩矢"
	desc = "一支装有厚重金属头的弩矢。就是用来砸断骨头的。"
	projectile_type = /obj/projectile/bullet/reusable/bolt/heavyblunt
	possible_item_intents = list(/datum/intent/mace/strike)
	icon_state = "bolt_blunt_heavy"
	force = 10

/obj/projectile/bullet/reusable/bolt
	name = "弩矢"
	damage = 70
	damage_type = BRUTE
	armor_penetration = 50
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "bolt_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	speed = 0.5
	npc_simple_damage_mult = 2

/obj/projectile/bullet/reusable/bolt/decrepit
	damage = 40
	armor_penetration = 30
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/decrepit

/obj/projectile/bullet/reusable/bolt/ancient
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/ancient

/obj/projectile/bullet/reusable/bolt/blunt
	damage = 25
	armor_penetration = 0
	embedchance = 1//freak accident
	woundclass = BCLASS_BLUNT
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/blunt
	hitsound = 'sound/combat/hits/blunt/woodblunt (2).ogg'
	speed = 0.3

/obj/projectile/bullet/reusable/bolt/heavyblunt
	damage = 70
	armor_penetration = 50
	embedchance = 2//freak accident
	woundclass = BCLASS_BLUNT
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt
	hitsound = 'sound/combat/hits/blunt/woodblunt (2).ogg'
	icon_state = "bolt_blunt_proj"
	speed = 0.25

/obj/projectile/bullet/reusable/bolt/on_hit(atom/target)
	. = ..()

	var/mob/living/L = firer
	if(!L || !L.mind)
		return

	var/skill_multiplier = 0

	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4

	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT))
		L.mind.add_sleep_experience(/datum/skill/combat/crossbows, L.STAINT * skill_multiplier)

//arrows ฅ^•ﻌ•^ฅ

/obj/item/ammo_casing/caseless/rogue/arrow
	name = "箭"
	desc = "有些造物的本质如此简单，用途如此朴素，\
	让人几乎觉得它们并非出自凡人之手，\
	而是自天地之间自然诞生。去问问你的神吧。"
	projectile_type = /obj/projectile/bullet/reusable/arrow
	caliber = "arrow"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow"
	force = 10
	dropshrink = 0.6
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	max_integrity = 10

/obj/item/ammo_casing/caseless/rogue/arrow/blunt
	name = "钝头箭"
	desc = "献给那些你真的非杀一头扎德不可的时候。"
	icon_state = "arrow_blunt"
	projectile_type = /obj/projectile/bullet/reusable/arrow/blunt
	force = 5
	possible_item_intents = list(/datum/intent/mace/strike)

/obj/item/ammo_casing/caseless/rogue/arrow/stone
	name = "石箭"
	desc = "一根简单箭杆上绑着打制后磨得锋利如剃刀的燧石箭头。民间常说这种箭头比铁制箭头切得更利，但一旦撞上甲胄，也更容易碎裂。"
	max_integrity = 5
	projectile_type = /obj/projectile/bullet/reusable/arrow/stone

/obj/item/ammo_casing/caseless/rogue/arrow/iron
	name = "铁阔头箭"
	icon_state = "ironarrow"
	desc = "一束经蒸汽烤直的箭杆，一端开槽，另一端装着铁制箭头。系上尾羽后，它就会忠实地飞向射手意志所指之处。"
	projectile_type = /obj/projectile/bullet/reusable/arrow/iron

/obj/item/ammo_casing/caseless/rogue/arrow/iron/decrepit
	name = "破旧阔头箭"
	desc = "一支箭，一端装着扁平而磨损的青铜箭头，另一端嵌着腐朽羽毛。这种衰败合金会在命中时炸裂成碎片，把血肉撕得稀烂。"
	icon_state = "ancientarrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/iron/decrepit
	color = "#bb9696"

/obj/item/ammo_casing/caseless/rogue/arrow/steel
	name = "钢锥头箭"
	icon_state = "steelarrow"
	desc = "一束经蒸汽烤直的箭杆，一端开槽，另一端装着钢制箭头。它正是为了对付那些准备更充分的目标而造。"
	projectile_type = /obj/projectile/bullet/reusable/arrow/steel

/obj/item/ammo_casing/caseless/rogue/arrow/steel/ancient
	name = "远古锥头箭"
	desc = "一支箭，一端装着磨尖的抛光吉布兰泽细杆，另一端嵌有羽毛。那薄如刀锋的尖端更像脱壳穿甲体，是足以直接洞穿钢铁的合金细片。"
	icon_state = "ancientarrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/steel/ancient

/obj/projectile/bullet/reusable/arrow
	name = "箭"
	damage = 20
	damage_type = BRUTE
	npc_simple_damage_mult = 2
	armor_penetration = 10
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 25
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	speed = 0.4

/obj/projectile/bullet/reusable/arrow/on_hit(atom/target)
	..()

	var/mob/living/L = firer
	if(!L || !L.mind)
		return

	var/skill_multiplier = 0

	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4

	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/bows, SKILL_LEVEL_EXPERT))
		L.mind.add_sleep_experience(/datum/skill/combat/bows, L.STAINT * skill_multiplier)

/obj/projectile/bullet/reusable/arrow/blunt
	name = "钝头箭"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/blunt
	damage = 15
	armor_penetration = 0
	embedchance = 0
	woundclass = BCLASS_BLUNT

/obj/projectile/bullet/reusable/arrow/stone
	name = "石箭"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone
	accuracy = 60

/obj/projectile/bullet/reusable/arrow/iron
	name = "阔头箭"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron

	damage = 40
	armor_penetration = 20
	embedchance = 30
	npc_simple_damage_mult = 2

/obj/projectile/bullet/reusable/arrow/iron/decrepit
	name = "破旧阔头箭"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron/decrepit
	damage = 20
	armor_penetration = 0

/obj/projectile/bullet/reusable/arrow/steel
	name = "锥头箭"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/steel

	accuracy = 75
	damage = 25
	armor_penetration = 45
	embedchance = 80
	speed = 0.6
	npc_simple_damage_mult = 3

/obj/projectile/bullet/reusable/arrow/steel/ancient
	name = "远古锥头箭"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/steel/ancient

// POISON AMMO


/obj/item/ammo_casing/caseless/rogue/arrow/poison
	name = "毒箭"
	desc = "一束经蒸汽烤直的箭杆，一端开槽，另一端装着锋利箭头。箭头上开有凹槽，内里灌注着令人昏沉的毒药混合物。"
	projectile_type = /obj/projectile/bullet/reusable/arrow/poison
	icon_state = "ironarrow_poison"
	max_integrity = 10 // same as normal arrow; usually breaks on impact with a mob anyway

/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison
	name = "毒石箭"
	desc = "一根简单箭杆上绑着磨得锋利如剃刀的燧石箭头，箭头上还开有细槽，用来残留并携带毒物。"
	projectile_type = /obj/projectile/bullet/reusable/arrow/poison/stone
	icon_state = "arrow_poison"

/obj/projectile/bullet/reusable/arrow/poison
	name = "毒铁箭"
	damage = 20
	damage_type = BRUTE
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	poisontype = /datum/reagent/stampoison
	poisonamount = 2
	slur = 10
	eyeblur = 10
	drowsy = 5

/obj/projectile/bullet/reusable/arrow/poison/stone
	name = "毒石箭"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone


// PYRO AMMO


/obj/item/ammo_casing/caseless/rogue/bolt/pyro
	name = "燃火弩矢"
	desc = "一支涂满易燃药剂的弩矢。"
	projectile_type = /obj/projectile/bullet/bolt/pyro
	possible_item_intents = list(/datum/intent/mace/strike)
	caliber = "regbolt"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "bolt_pyroclastic"
	dropshrink = 0.8
	max_integrity = 10
	force = 10

/obj/projectile/bullet/bolt/pyro
	name = "燃火弩矢"
	desc = "一支涂满易燃药剂的弩矢。"
	damage = 20
	damage_type = BRUTE
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "boltpyro_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt
	range = 15
	hitsound = 'sound/blank.ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "piercing"
	speed = 0.3

/obj/projectile/bullet/bolt/pyro/on_hit(target)
	..()
	if(!ismob(target))
		return
	var/mob/living/M = target
	M.adjust_fire_stacks(6)
	M.adjustFireLoss(15)
	M.ignite_mob()


/obj/item/ammo_casing/caseless/rogue/bolt/water
	name = "水囊弩矢"
	desc = "一支前端嵌着装水玻璃小瓶的弩矢。它会在命中时碎裂，特别适合打灭烦人的灯火。"
	projectile_type = /obj/projectile/bullet/bolt/water
	possible_item_intents = list(/datum/intent/mace/strike)
	caliber = "regbolt"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "bolt_water"
	dropshrink = 0.8
	max_integrity = 10
	force = 0

/obj/projectile/bullet/bolt/water
	name = "水囊弩矢"
	desc = "一支前端嵌着装水玻璃小瓶的弩矢。它会在命中时碎裂，特别适合打灭烦人的灯火。"
	damage = 0
	damage_type = BRUTE
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "boltwater_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/water
	range = 15
	hitsound = 'sound/blank.ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "piercing"
	speed = 0.3

	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

	//explosion values
	var/exp_heavy = 0
	var/exp_light = 0
	var/exp_flash = 0
	var/exp_fire = 1

/obj/projectile/bullet/bolt/water/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		for(var/obj/O in M.contents) //Checks for light sources in the mob's inventory
			O.extinguish() //Extinguishes light sources on the mob you hit with the arrow.
	var/turf/T = get_turf(target)
	for(var/obj/O in T)
		O.extinguish()
//pyro arrows
/obj/item/ammo_casing/caseless/rogue/arrow/pyro
	name = "燃火箭"
	desc = "一支箭，箭头浸透了易燃药剂。"
	projectile_type = /obj/projectile/bullet/arrow/pyro
	possible_item_intents = list(/datum/intent/mace/strike)
	caliber = "arrow"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_pyroclastic"
	dropshrink = 0.8
	max_integrity = 10
	force = 10

/obj/projectile/bullet/arrow/pyro
	name = "燃火箭"
	desc = "一支箭，箭头浸透了易燃药剂。"
	damage = 15
	damage_type = BRUTE
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrowpyro_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow
	range = 15
	hitsound = 'sound/blank.ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "piercing"
	speed = 0.4

/obj/projectile/bullet/arrow/pyro/on_hit(target)
	..()
	if(!ismob(target))
		return
	var/mob/living/M = target
	M.adjust_fire_stacks(4)
	M.adjustFireLoss(10)
	M.ignite_mob()

/obj/item/ammo_casing/caseless/rogue/arrow/water
	name = "水囊箭"
	desc = "一支前端嵌着装水玻璃小瓶的箭矢。它会在命中时碎裂，特别适合打灭烦人的灯火。"
	projectile_type = /obj/projectile/bullet/arrow/water
	possible_item_intents = list(/datum/intent/mace/strike)
	caliber = "arrow"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_water"
	dropshrink = 0.8
	max_integrity = 10
	force = 0

/obj/projectile/bullet/arrow/water
	name = "水囊箭"
	desc = "一支前端嵌着装水玻璃小瓶的箭矢。它会在命中时碎裂，特别适合打灭烦人的灯火。"
	damage = 0
	damage_type = BRUTE
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrowwater_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow
	range = 15
	hitsound = 'sound/blank.ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "piercing"
	speed = 0.4


/obj/projectile/bullet/arrow/water/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		for(var/obj/O in M.contents) //Checks for light sources in the mob's inventory.
			O.extinguish() //Extinguishes light sources on the mob you hit with the arrow.
	var/turf/T = get_turf(target)
	for(var/obj/O in T)
		O.extinguish()

/obj/projectile/bullet/reusable/arrow/poison/stone
	name = "石箭"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone

//mob projectiles

/obj/projectile/bullet/reusable/arrow/orc
	damage = 20
	damage_type = BRUTE
	armor_penetration = 25
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_STAB
	flag = "piercing"
	speed = 2

/obj/projectile/bullet/reusable/arrow/ancient
	damage = 10
	damage_type = BRUTE
	armor_penetration = 25
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_STAB
	flag = "piercing"
	speed = 2
//deep one stone
/obj/projectile/bullet/reusable/deepone
	name = "石块"
	damage = 25
	damage_type = BRUTE
	armor_penetration = 30
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stone1"
	ammo_type = /obj/item/natural/stone
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 50
	woundclass = BCLASS_STAB
	flag = "piercing"
	speed = 10

//Spider projectiles
/obj/projectile/bullet/spider
	name = "蛛网团"
	damage = 10
	damage_type = BRUTE
	icon = 'modular/Mapping/icons/webbing.dmi'
	icon_state = "webglob"
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 0
	//Will not cause wounds.
	woundclass = null
	flag = "piercing"
	speed = 1

/obj/projectile/bullet/spider_shroom
	name = "蛛网团"
	damage = 10
	damage_type = BRUTE
	icon = 'modular/Mapping/icons/webbing.dmi'
	icon_state = "webglob"
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 0
	//Will not cause wounds.
	woundclass = null
	flag = "piercing"
	speed = 2

/obj/projectile/bullet/spider/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		M.apply_status_effect(/datum/status_effect/debuff/vulnerable)
		M.Immobilize(15)
	var/turf/T
	if(isturf(target))
		T = target
	else
		T = get_turf(target)
	var/web = locate(/obj/structure/spider/stickyweb/mirespider) in T.contents
	if(!(web in T.contents))
		new /obj/structure/spider/stickyweb/mirespider(T)

/obj/projectile/bullet/spider_shroom/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		M.apply_status_effect(/datum/status_effect/debuff/vulnerable)
		M.apply_status_effect(/datum/status_effect/buff/druqks)
	var/turf/T
	if(isturf(target))
		T = target
	else
		T = get_turf(target)
	var/web = locate(/obj/structure/spider/stickyweb/mirespider) in T.contents
	if(!(web in T.contents))
		new /obj/structure/spider/stickyweb/mirespider(T)

//Mirespider webs are thinner and will not stop projectiles or obstruct movement as often.
/obj/structure/spider/stickyweb/mirespider
	opacity = 0
	pass_flags = LETPASSTHROW
	debris = null

/obj/structure/spider/stickyweb/mirespider/CanPass(atom/movable/mover, turf/target)
	if(isliving(mover))
		if(prob(25) && !HAS_TRAIT(mover, TRAIT_WEBWALK))
			to_chat(mover, "<span class='danger'>我一时被[src]缠住了。</span>")
			return FALSE
	else if(istype(mover, /obj/projectile))
		return prob(85)
	return TRUE

//Javelins - Basically spears, but to get them working as proper javelins and able to fit in a bag, they are 'ammo'. (Maybe make an atlatl later?)
//Only ammo casing, no 'projectiles'. You throw the casing, as weird as it is.
/obj/item/ammo_casing/caseless/rogue/javelin
	force = 14
	throw_speed = 3		//1 lower than throwing knives, it hits harder + embeds more.
	name = "铁标枪"
	desc = "一种自有文字记载以来便沿用数百年的工具。这一支装着铁头，是民兵与杂牌部队的标准配备。"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "ijavelin"
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_BULKY
	armor_penetration = 40					//Redfined because.. it's not a weapon, it's an 'arrow' basically.
	max_integrity = 50						//Breaks semi-easy, stops constant re-use.
	wdefense = 3							//Worse than a spear
	thrown_bclass = BCLASS_STAB				//Knives are slash, lets try out stab and see if it's too strong in terms of wounding.
	throwforce = 25							//throwing knife is 22, slightly better for being bulkier.
	possible_item_intents = list(/datum/intent/sword/thrust, /datum/intent/spear/bash, /datum/intent/spear/cut)	//Sword-thrust to avoid having 2 reach.
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 35, "embedded_fall_chance" = 10)	//Better than iron throwing knife by 10%
	smeltresult = null
	anvilrepair = /datum/skill/craft/weaponsmithing
	associated_skill = /datum/skill/combat/polearms
	heavy_metal = FALSE						//Stops spin animation, maybe.
	thrown_damage_flag = "piercing"			//Checks peircing protection.

/obj/item/ammo_casing/caseless/rogue/javelin/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = -1,"nx" = 8,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/ammo_casing/caseless/rogue/javelin/steel
	force = 16
	armor_penetration = 50
	name = "钢标枪"
	desc = "一种自有文字记载以来便沿用数百年的工具。这一支装着钢头，最适合用来刺穿护甲！"
	icon_state = "javelin"
	max_integrity = 100						//In-line with other stabbing weapons.
	throwforce = 28							//Equal to steel knife BUT this has peircing damage type so..
	thrown_bclass = BCLASS_PICK				//Bypasses crit protection better than stabbing. Makes it better against heavy-targets.
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 45, "embedded_fall_chance" = 10) //Better than steel throwing knife by 10%

/obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient
	name = "远古标枪"
	desc = "一枚抛光吉布兰泽投射体。古赛昂沉没于祂的泪水之下，而她的飞升带来了此世的终结，只为了让你在挥出致命一击时，得以成神。"
	icon_state = "ajavelin"

/obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient/decrepit
	name = "破旧标枪"
	desc = "一枚磨损青铜投射体。你眼前的便是你的武器；正是它使人类从泥泞中站起，也令古赛昂的诸兽低头。你上次意识到自己还有别的部分是什么时候？你还记得曾以其他方式看待这个世界吗？"
	force = 9
	armor_penetration = 30
	max_integrity = 50		
	throwforce = 20
	color = "#bb9696"
	anvilrepair = null

/obj/item/ammo_casing/caseless/rogue/javelin/silver
	name = "白银标枪"
	desc = "一种自有文字记载以来便沿用数百年的工具。这一支似乎装着银头。也许只是装饰品……或者是某类专门猎手的武器。"
	icon_state = "sjavelin"
	is_silver = TRUE
	throwforce = 25							//Less than steel because it's.. silver. Good at killing vampires/WW's still.
	armor_penetration = 60
	thrown_bclass = BCLASS_PICK				//Bypasses crit protection better than stabbing. Makes it better against heavy-targets.
	smeltresult = /obj/item/ingot/silver // 2 ingots = 2 javelins so this can smelt.

/obj/item/ammo_casing/caseless/rogue/javelin/silver/ComponentInitialize()
	. = ..()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = -3,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 3,\
	)

//Snowflake code to make sure the silver-bane is applied on hit to targeted mob. Thanks to Aurorablade for getting this code to work.
/obj/item/ammo_casing/caseless/rogue/javelin/silver/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(!iscarbon(hit_atom))
		return//abort

//sling bullets

/obj/item/ammo_casing/caseless/rogue/sling_bullet //parent of sling ammo and the temporary sling bullet for stones. shouldn't ever be seen
	name = "飞翔石"
	desc = "你本不该看到这个。"
	projectile_type = /obj/projectile/bullet/sling_bullet
	caliber = "slingbullet"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow"
	force = 5
	throwforce = 20 //you can still throw them
	dropshrink = 0.6
	possible_item_intents = list(INTENT_GENERIC) //not intended to attack with them
	max_integrity = 20

/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone //these should be seen
	name = "石制投石弹"
	desc = "一块为愤怒而打磨的石头。"
	projectile_type = /obj/projectile/bullet/reusable/sling_bullet/stone
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "stone_sling_bullet"

/obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze
	name = "青铜投石弹"
	desc = "一颗小巧的青铜球。握在掌中时，它比看起来沉得多。"
	projectile_type = /obj/projectile/bullet/reusable/sling_bullet/bronze
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "stone_sling_bullet"
	color = "#f9d690"

/obj/item/ammo_casing/caseless/rogue/sling_bullet/decrepit
	name = "破旧投石弹"
	desc = "一颗由磨损青铜制成的弹丸。合金会在你掌中剥落，把手心染上一点点棕红色碎屑。"
	projectile_type = /obj/projectile/bullet/reusable/sling_bullet/decrepit
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "ancient_sling_bullet"
	color = "#bb9696"

/obj/item/ammo_casing/caseless/rogue/sling_bullet/ancient
	name = "远古投石弹"
	desc = "一颗抛光吉布兰泽弹丸。无论是人还是神，越庞大者，倒下时也越沉重。"
	projectile_type = /obj/projectile/bullet/reusable/sling_bullet/ancient
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "ancient_sling_bullet"

/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron
	name = "铁制投石弹"
	desc = "别把它误认成轴承钢珠。"
	projectile_type = /obj/projectile/bullet/reusable/sling_bullet/iron
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "iron_sling_bullet"

/obj/projectile/bullet/sling_bullet //not reusable since stones will break on impact. i couldnt figure out how to prevent that
	name = "投石弹"
	desc = "如果你能看到这行字：快低头。"
	damage = 25
	damage_type = BRUTE
	armor_penetration = 0
	npc_simple_damage_mult = 2
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stone1"
	range = 15
	hitsound = 'sound/combat/hits/blunt/bluntsmall (1).ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "piercing"
	speed = 0.4

/obj/projectile/bullet/sling_bullet/on_hit(atom/target)
	. = ..()

	var/mob/living/L = firer
	if(!L || !L.mind) return

	var/skill_multiplier = 0

	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4

	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/slings, SKILL_LEVEL_LEGENDARY))
		L.mind.add_sleep_experience(/datum/skill/combat/slings, L.STAINT * skill_multiplier)

/obj/projectile/bullet/reusable/sling_bullet //parent for proper reusable sling bullets
	name = "投石弹"
	desc = "如果你能看到这行字：快低头。"
	damage = 25
	damage_type = BRUTE
	armor_penetration = 0
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stone1"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet
	range = 15
	hitsound = 'sound/combat/hits/blunt/bluntsmall (1).ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "piercing"
	speed = 0.4
	npc_simple_damage_mult = 2

/obj/projectile/bullet/reusable/sling_bullet/on_hit(atom/target)
	. = ..()

	var/mob/living/L = firer
	if(!L || !L.mind) return

	var/skill_multiplier = 0

	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4

	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/slings, SKILL_LEVEL_LEGENDARY))
		L.mind.add_sleep_experience(/datum/skill/combat/slings, L.STAINT * skill_multiplier)

/obj/projectile/bullet/reusable/sling_bullet/stone
	name = "石制投石弹"
	damage = 30 //proper stones are better
	armor_penetration = 0
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"

/obj/projectile/bullet/reusable/sling_bullet/bronze
	name = "青铜投石弹"
	damage = 35
	armor_penetration = 20 //Slightly more damage, but with -33% AP.
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"

/obj/projectile/bullet/reusable/sling_bullet/decrepit
	name = "破旧投石弹"
	damage = 15
	armor_penetration = 0
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/decrepit
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"

/obj/projectile/bullet/reusable/sling_bullet/ancient
	name = "远古投石弹"
	damage = 30
	armor_penetration = 30
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/ancient
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"

/obj/projectile/bullet/reusable/sling_bullet/iron
	name = "铁制投石弹"
	damage = 30
	armor_penetration = 30
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball_proj"

/obj/item/ammo_casing/caseless/rogue/bolt/holy
	name = "裂灭弩矢"
	desc = "一支银尖弩矢，内部装有一小瓶圣水。它对活体血肉造成的伤口较浅，但对不洁之物却格外有效；断裂与爆响之后，便是炽烈的惊喜。 </br>“一次洗礼，赦免诸罪。”"
	projectile_type = /obj/projectile/bullet/reusable/bolt/holy
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	caliber = "regbolt"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "bolt_holywater"
	dropshrink = 0.6
	max_integrity = 10
	force = 10

/obj/projectile/bullet/reusable/bolt/holy
	name = "裂灭弩矢"
	damage = 35 //Halved damage, but same penetration.
	damage_type = BRUTE
	armor_penetration = 50
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "bolthwater_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/holy
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	speed = 0.5
	poisontype = /datum/reagent/water/blessed
	poisonamount = 5
	npc_simple_damage_mult = 5 //175, compared to the regular bolt's 140. Slightly more damage, as to imitate its anti-unholy properties on mobs who aren't affected by any form of poison.

//Heavy bolts, for the funny heavy crossbow.
/obj/item/ammo_casing/caseless/rogue/heavy_bolt
	name = "重型弩矢"
	desc = "一支结实的钢制弩矢。也许光靠质量，它就足以轻松刺穿任何东西。"
	projectile_type = /obj/projectile/bullet/reusable/heavy_bolt
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	caliber = "heabolt"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "heavy_bolt"//Temp sprite.
	dropshrink = 0.8
	max_integrity = 10
	force = 12

//+10 damage/pen from bolt.
//Pen increase on heavy crossbow assures these will, effectively, ALWAYS go through.
/obj/projectile/bullet/reusable/heavy_bolt
	name = "重型弩矢"
	damage = 80
	damage_type = BRUTE
	armor_penetration = 80
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "bolt_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/heavy_bolt
	range = 30
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	embedchance = 100
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	speed = 0.3
	npc_simple_damage_mult = 2

/obj/item/ammo_casing/caseless/rogue/heavy_bolt/holy
	name = "木桩弩矢"
	desc = "一根装有尾翼的白银木桩。把黑暗钉回去！"
	projectile_type = /obj/projectile/bullet/reusable/heavy_bolt/holy
	icon_state = "heavy_stake"//Temp sprite.
	max_integrity = 30
	force = 12
	is_silver = TRUE

/obj/projectile/bullet/reusable/heavy_bolt/holy
	name = "木桩弩矢"
	damage = 50
	ammo_type = /obj/item/ammo_casing/caseless/rogue/heavy_bolt/holy
	hitsound = 'sound/combat/hits/hi_bolt (3).ogg'
	speed = 0.5
	poisontype = /datum/reagent/water/blessed
	poisonamount = 5
	npc_simple_damage_mult = 5//RAAAAAA

/obj/item/ammo_casing/caseless/rogue/heavy_bolt/tempest
	name = "风暴弩矢"
	desc = "缠绕其上的防护术让人感觉<b>沉重</b>。矢头里似乎装着某种载荷。\
	这东西究竟是拿来做什么的？"
	projectile_type = /obj/projectile/bullet/reusable/heavy_bolt/tempest
	icon_state = "tempest_bolt"//Temp sprite.
	max_integrity = 30
	force = 12
	is_silver = TRUE//This is ALSO warded. Just as with the silver bolt.

//The super evil murderfuck bolt.
/obj/projectile/bullet/reusable/heavy_bolt/tempest
	name = "风暴弩矢"
	damage = 25
	ammo_type = /obj/item/ammo_casing/caseless/rogue/heavy_bolt/tempest
	hitsound = 'sound/combat/hits/hi_bolt (1).ogg'
	speed = 0.5
	npc_simple_damage_mult = 7

/obj/projectile/bullet/reusable/heavy_bolt/tempest/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		M.apply_status_effect(/datum/status_effect/debuff/exposed)
		M.blind_eyes(6)

#undef ARROW_DAMAGE
#undef BOLT_DAMAGE
#undef BULLET_DAMAGE
#undef ARROW_PENETRATION
#undef BOLT_PENETRATION
#undef BULLET_PENETRATION
