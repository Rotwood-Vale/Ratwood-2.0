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
	name = "\improper bombard charge (SOL)"
	desc = "A hefty bombard charge. Capped by a solid end."
	icon = 'icons/roguetown/weapons/stationary/bombard_projectiles.dmi'
	icon_state = "basic"

/obj/item/cannonball/proc/detonate(turf/T)
	loud_message("An explosion echos in the ears of those whom hear it", hearing_distance = 32)
	forceMove(T)

//HE charge. This WILL delimb and cause many issues.
/obj/item/cannonball/explosive
	name = "\improper bombard charge (HE)"
	desc = "A hefty bombard charge. It's capped by a flat nose."
	icon_state = "explosive"

/obj/item/cannonball/explosive/detonate(turf/T)
	..()
	explosion(T, 2, 4, 6, 8)

//Flare charge. Blinds in a wide radius.
//Intended to alert to number of players in area, but I'll do that later.
/obj/item/cannonball/flare
	name = "\improper bombard charge (FLR)"
	desc = "A hefty bombard charge. Covered by copper bands and capped by an odd nose."
	icon_state = "flare"

/obj/item/cannonball/flare/detonate(turf/T)
	..()
	for(var/mob/living/carbon/human/L in orange(24,T))
		L.flash_act()
		L.blind_eyes(6)
	explosion(T, 0, 0, 0, 7)

//Incendiary charge. Drops a huge blanket of flame across a wide area.
/obj/item/cannonball/incendiary
	name = "\improper bombard charge (INC)"
	desc = "A hefty bombard charge. The end is leaking some matter of substance. \
	You'll need to light this with a torch, before firing it. Be quick!"
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
	name = "\improper bombard charge (SMK)"
	desc = "A hefty bombard charge. It's capped by a flat nose."
	icon_state = "basic"

/obj/item/cannonball/smoke/detonate(turf/T)
	..()
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(4, T, 0)
	smoke.start()
	explosion(T, 0, 0, 0, 3)

//The poison sort.
/obj/item/cannonball/smoke_poison
	name = "\improper bombard charge (SMK-P)"
	desc = "A hefty bombard charge. It's capped by a flat nose."
	icon_state = "poison"

/obj/item/cannonball/smoke_poison/detonate(turf/T)
	..()
	var/datum/effect_system/smoke_spread/poison_gas/smoke_p = new
	smoke_p.set_up(2, T, 0)
	smoke_p.start()
	explosion(T, 0, 0, 0, 3)

//The emberwine sort.
/obj/item/cannonball/smoke_emberwine
	name = "\improper bombard charge (SMK-E)"
	desc = "A hefty bombard charge. It's capped by a needle nose, and poorly bound in some cloth. \
	Whatever is contained within should stay that way, and you far from it."
	icon_state = "emberwine"

/obj/item/cannonball/smoke_emberwine/Initialize()
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
	name = "\improper bombard charge (SMK-C)"
	desc = "A hefty bombard charge. It's capped by a flat nose, and meant for a payload to be inserted before firing. \
	In the absence of a payload, it has a rather small smoke charge inside."
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

/obj/item/cannonball/smoke_custom/Initialize()
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
	name = "\improper bombard charge (FLK)"
	desc = "A hefty bombard charge. It's fitted with a fluted, almost hollow sounding nose. \
	Nasty thing, outlawed in all reasonable realms of the land..."
	icon_state = "braced"

/obj/item/cannonball/canister/detonate(turf/T)
	..()
	canister_detonate()
	spawn(2 SECONDS)//It detonates ABOVE, or something. I 'unno. It's COOL.
	explosion(T, 0, 0, 1, 4)

//A secondary type of 'canister' charge. Small explosions on all turfs in view.
/obj/item/cannonball/cluster
	name = "\improper bombard charge (CLS)"
	desc = "A hefty bombard charge. Rather than a nose piece, it's a bundle of small impact grenades. \
	Nasty thing, outlawed in all reasonable realms of the land..."
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
	name = "\improper canister shrapnel"
	icon_state = "bullet"
	damage = 5//Very many of them, but very low damage and AP.
	range = 12//We want this to go beyond screen, in case of far misses.
	pass_flags = PASSTABLE | PASSGRILLE
	armor_penetration = 20
	damage_type = BRUTE
	woundclass = BCLASS_PICK
	flag = "piercing"
	speed = 2
