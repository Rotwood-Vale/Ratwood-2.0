/*
The various projectiles used by the bombard.
Later, we'll get proper cannonballs or whatever for them to fire.
For the moment, just small 'charges'.
Listed as 'cannonballs' because we'll just differentiate via var later.
When? Whenever I get to it.
Additionally, these differ from the concepts, because I wish to see them in practice first.
- Carl
*/
//This is a 'solid shot'. Does nothing, as of now.
/obj/item/cannonball
	name = "\improper 臼炮装药（实心）"
	desc = "一枚沉重的臼炮装药，前端封着实心弹头。"
	icon = 'icons/roguetown/weapons/stationary/bombard_projectiles.dmi'
	icon_state = "basic"

/obj/item/cannonball/proc/detonate(turf/T)
	loud_message("爆炸的回响震得闻者双耳嗡鸣", hearing_distance = 32)
	forceMove(T)

//HE charge. This WILL delimb and cause many issues.
/obj/item/cannonball/explosive
	name = "\improper 臼炮装药（高爆）"
	desc = "一枚沉重的臼炮装药，前端封着平头弹帽。"
	icon_state = "explosive"

/obj/item/cannonball/explosive/detonate(turf/T)
	..()
	explosion(T, 2, 4, 6, 8)

//Flare charge. Blinds in a wide radius.
//Intended to alert to number of players in area, but I'll do that later.
/obj/item/cannonball/flare
	name = "\improper 臼炮装药（照明）"
	desc = "一枚沉重的臼炮装药，表面缠着铜箍，前端封着奇异的弹帽。"
	icon_state = "flare"

/obj/item/cannonball/flare/detonate(turf/T)
	..()
	for(var/mob/living/carbon/human/L in orange(24,T))
		L.flash_act()
		L.blind_eyes(6)
	explosion(T, 0, 0, 0, 7)

//Incendiary charge. Drops a huge blanket of flame across a wide area.
/obj/item/cannonball/incendiary
	name = "\improper 臼炮装药（燃烧）"
	desc = "一枚沉重的臼炮装药，尾端正渗出某种可燃物。\
	你得在发射前先用火把把它点燃。动作要快！"
	icon_state = "incendiary"
	var/prepared = FALSE
	var/time_to_go = 100

/obj/item/cannonball/incendiary/process()
	time_to_go--
	if(time_to_go <= 0)
		detonate()

/obj/item/cannonball/incendiary/fire_act()
	light()

/obj/item/cannonball/incendiary/proc/light()
	if(prepared)
		return
	START_PROCESSING(SSfastprocess, src)
	icon_state += "_active"
	prepared = TRUE
	playsound(loc, 'sound/items/firelight.ogg', 100)
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/cannonball/incendiary/extinguish()
	snuff()

/obj/item/cannonball/incendiary/proc/snuff()
	if(!prepared)
		return
	prepared = FALSE
	STOP_PROCESSING(SSfastprocess, src)
	playsound(loc, 'sound/items/firesnuff.ogg', 100)
	icon_state = "incendiary"
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/cannonball/incendiary/detonate(turf/T)
	..()
	if(prepared)
		explosion(T, light_impact_range = 1, flame_range = 7)
	else
		explosion(T, light_impact_range = 1, flame_range = 1)

//SMOKE CHARGES
//The normal sort.
/obj/item/cannonball/smoke
	name = "\improper 臼炮装药（烟幕）"
	desc = "一枚沉重的臼炮装药，前端封着平头弹帽。"
	icon_state = "basic"

/obj/item/cannonball/smoke/detonate(turf/T)
	..()
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(4, T, 0)
	smoke.start()
	explosion(T, 0, 0, 0, 3)

//The poison sort.
/obj/item/cannonball/smoke_poison
	name = "\improper 臼炮装药（毒烟）"
	desc = "一枚沉重的臼炮装药，前端封着平头弹帽。"
	icon_state = "poison"

/obj/item/cannonball/smoke_poison/detonate(turf/T)
	..()
	var/datum/effect_system/smoke_spread/poison_gas/smoke_p = new
	smoke_p.set_up(2, T, 0)
	smoke_p.start()
	explosion(T, 0, 0, 0, 3)

//The emberwine sort.
/obj/item/cannonball/smoke_emberwine
	name = "\improper 臼炮装药（烬酒烟）"
	desc = "一枚沉重的臼炮装药，前端封着尖锥弹帽，还草草裹了几层破布。\
	里头装的东西最好别放出来，而你也最好离它远些。"
	icon_state = "emberwine"

/obj/item/cannonball/smoke_emberwine/Initialize(mapload)
	create_reagents(50)
	var/list/warcrime = list(/datum/reagent/consumable/ethanol/beer/emberwine = 50)
	reagents.add_reagent_list(warcrime)
	. = ..()

/obj/item/cannonball/smoke_emberwine/detonate(turf/T)
	..()
	var/datum/reagents/R = src.reagents
	var/datum/effect_system/smoke_spread/chem/smoke_e = new
	smoke_e.set_up(R, 1, T, FALSE)
	smoke_e.start()
	explosion(T, 0, 0, 0, 3)

//The custom sort.
/obj/item/cannonball/smoke_custom
	name = "\improper 臼炮装药（混装）"
	desc = "一枚沉重的臼炮装药，前端封着平头弹帽，设计上可在发射前装入额外载荷。\
	若没有装入载荷，它内部也自带一份不算大的烟幕药剂。"
	icon_state = "anychem_empty"
	possible_item_intents = list(INTENT_POUR, INTENT_FILL, INTENT_SPLASH, INTENT_GENERIC)

/obj/item/cannonball/smoke_custom/update_icon()
	..()
	cut_overlays()
	if(reagents.total_volume > 0)
		var/mutable_appearance/internal = mutable_appearance('icons/roguetown/weapons/stationary/bombard_projectiles.dmi', "anychem_full_overlay")
		internal.color = mix_color_from_reagents(reagents.reagent_list)
		internal.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		add_overlay(internal)
		icon_state = "anychem_full"
	else
		icon_state = "anychem_empty"
	return

/obj/item/cannonball/smoke_custom/Initialize(mapload)
	create_reagents(50, DRAINABLE | REFILLABLE | AMOUNT_VISIBLE)
	. = ..()

/obj/item/cannonball/smoke_custom/detonate(turf/T)
	..()
	var/datum/reagents/R = src.reagents
	if(reagents.total_volume > 0)
		var/datum/effect_system/smoke_spread/chem/smoke_c = new
		smoke_c.set_up(R, 1, T, FALSE)
		smoke_c.start()
	else
		var/datum/effect_system/smoke_spread/smoke_s = new
		smoke_s.set_up(1, T, 0)
		smoke_s.start()
	explosion(T, 0, 0, 0, 3)

//CANISTER CHARGES
//The actual proper canister charge, which disperses a huge chunk of shrapnel.
/obj/item/cannonball/canister
	name = "\improper 臼炮装药（榴霰）"
	desc = "一枚沉重的臼炮装药，装着带凹槽、敲起来近乎空心的弹帽。\
	这是种恶毒玩意，在任何还算讲理的国度里都属禁物……"
	icon_state = "braced"

/obj/item/cannonball/canister/detonate(turf/T)
	..()
	canister_detonate()
	spawn(2 SECONDS)//It detonates ABOVE, or something. I 'unno. It's COOL.
	explosion(T, 0, 0, 1, 4)

//A secondary type of 'canister' charge. Small explosions on all turfs in view.
/obj/item/cannonball/cluster
	name = "\improper 臼炮装药（集束）"
	desc = "一枚沉重的臼炮装药，前端不是普通弹帽，而是一束小型碰炸榴弹。\
	这是种恶毒玩意，在任何还算讲理的国度里都属禁物……"
	icon_state = "cluster"

/obj/item/cannonball/cluster/detonate(turf/T)
	..()
	for(T in oviewers(7,src))//This is gross.
		explosion(T, 0, 0, 1, 1)//Pepper every tile with a tiny explosion.

/*
The canister effect, when using canister shot or adjacent stuff.
*/
/obj/item/cannonball/proc/canister_detonate(atom/target)
	var/datum/component/shrapnel/canister_shrapnel = new /datum/component/shrapnel()
	target = get_turf(src)
	canister_shrapnel.projectile_type = /obj/projectile/canister_shrap
	canister_shrapnel.radius = 12
	canister_shrapnel.do_shrapnel(src, target)

/obj/projectile/canister_shrap
	name = "\improper 榴霰破片"
	icon_state = "bullet"
	damage = 5//Very many of them, but very low damage and AP.
	range = 12//We want this to go beyond screen, in case of far misses.
	pass_flags = PASSTABLE | PASSGRILLE
	armor_penetration = 20
	damage_type = BRUTE
	woundclass = BCLASS_PICK
	flag = "piercing"
	speed = 2
