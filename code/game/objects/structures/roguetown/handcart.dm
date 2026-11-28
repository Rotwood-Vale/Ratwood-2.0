/obj/structure/handcart
	name = "wooden handcart"
	desc = "A simple, reliable handcart crafted from robust timber, offering modest storage space and serving as a practical means of transporting goods."
	icon = 'icons/roguetown/misc/structure.dmi'
	density = TRUE
	max_integrity = 600
	anchored = FALSE
	climbable = TRUE
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg', 'sound/combat/hits/onwood/woodimpact (2).ogg')
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'

	var/list/stuff_shit = list()
	var/is_metal_handcart = FALSE

	var/current_capacity = 0
	var/maximum_capacity = 60 //arbitrary maximum amount of weight allowed in the cart before it says fuck off

	var/arbitrary_living_creature_weight = 10 // The arbitrary weight for any thing of a mob and living variety
	var/upgrade_level = 0 // This is the carts upgrade level, capacity increases with upgrade level
	var/list/upgrades = list()
	var/upgrade_slot_count = 1
	var/list/cartloadable_structures = list(/obj/structure/fermentation_keg, /obj/structure/closet/crate/chest)
	var/structure_weight = 20
	var/can_upgrade = TRUE // If false, the cart cannot be upgraded. If true, it can be upgraded.
	var/cart_empty_state = "cart-empty" // Icon state for empty cart
	var/cart_full_state = "cart-full" // Icon state for full cart
	facepull = FALSE
	throw_range = 1

/obj/structure/handcart/bronze
	name = "bronze handcart"
	desc = "A spacious handcart crafted from bronze, offering ample storage and room for upgrades."
	icon = 'icons/roguetown/misc/reinforcedhandcart.dmi'
	cart_empty_state = "cart_bronze"
	cart_full_state = "cart_bronze_full"
	max_integrity = 800
	maximum_capacity = 240
	climbable = TRUE
	is_metal_handcart = TRUE
	attacked_sound = list('sound/combat/hits/onmetal/metalimpact (2).ogg', 'sound/combat/hits/onmetal/metalimpact (1).ogg')
	break_sound = 'sound/combat/hits/onmetal/sheet (1).ogg'
	throw_range = 1

/obj/structure/handcart/iron
	name = "iron handcart"
	desc = "A sturdy handcart forged from durable iron, providing slightly more storage space than its wooden counterpart."
	icon = 'icons/roguetown/misc/reinforcedhandcart.dmi'
	cart_empty_state = "cart_iron"
	cart_full_state = "cart_iron_full"
	max_integrity = 1200
	maximum_capacity = 65
	climbable = TRUE
	is_metal_handcart = TRUE
	attacked_sound = list('sound/combat/hits/onmetal/metalimpact (2).ogg', 'sound/combat/hits/onmetal/metalimpact (1).ogg')
	break_sound = 'sound/combat/hits/onmetal/sheet (1).ogg'
	throw_range = 1

/obj/structure/handcart/steel
	name = "steel handcart"
	desc = "An exceptionally durable handcart crafted from steel, boasting greater storage capacity than the iron model."
	icon = 'icons/roguetown/misc/reinforcedhandcart.dmi'
	cart_empty_state = "cart_steel"
	cart_full_state = "cart_steel_full"
	max_integrity = 2000
	maximum_capacity = 260
	upgrade_slot_count = 2
	climbable = TRUE
	is_metal_handcart = TRUE
	attacked_sound = list('sound/combat/hits/onmetal/metalimpact (2).ogg', 'sound/combat/hits/onmetal/metalimpact (1).ogg')
	break_sound = 'sound/combat/hits/onmetal/sheet (1).ogg'
	throw_range = 1

/obj/effect/decal/cleanable/debris/handcart/metal
	name = "metal scraps"
	icon = 'icons/effects/debris.dmi'
	icon_state = "tiny"

/obj/effect/decal/cleanable/debris/handcart/wood
	name = "wooden scraps"
	icon = 'icons/effects/debris.dmi'
	icon_state = "paper_shreds"

/obj/structure/handcart/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += span_info("<font color='#FFFFFF'>Capacity: [current_capacity]/[maximum_capacity].</font>")
		if(length(stuff_shit))
			. += span_info("<font color='#FFFFFF'>It contains: [counting_english_list(stuff_shit)]</font>")
	if(length(upgrades))
		var/list/upgrade_descriptions = list()
		for(var/obj/item/roguegear/wood/cog as anything in upgrades)
			upgrade_descriptions += "[icon2html(cog, user)] <b>[cog.name]</b>"
		if(length(upgrades) == 1)
			. += span_smallnotice("[upgrade_descriptions[1]] upgrade is installed.")
		else
			. += span_smallnotice("[english_list(upgrade_descriptions)] upgrades are installed.")

/obj/structure/handcart/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left click the cart with an empty hand to take out a single item at a time.")
	. += span_info("Left click and drag an item onto the cart to store every item on that turf into the cart; repeat this individually with laid down creatures to place them into the cart, additionally you can enter the cart yourself.")
	. += span_info("Right click cart with an empty hand to dump all the contents out on the turf it's on.")
	. += span_info("Left click the cart with an item in hand to store the item in the cart.")
	. += span_info("Middle click the cart to store all the items on the cart's turf into the cart.")
	if(is_metal_handcart)
		. += span_info("Left click with Armor Plates or a Metal Scrap Kit to repair this cart, alternatively left click with a hammer to repair it; right click to store the hammer.")
	else
		. += span_info("Left click with a Structure Repair Kit to repair this cart. Left click with a hammer to repair it; right click to store the hammer.")

/obj/structure/handcart/Initialize(mapload)
	if(mapload)		// if closed, any item at the crate's loc is put in the contents
		addtimer(CALLBACK(src, PROC_REF(take_contents)), 0)
	. = ..()
	update_icon()

/obj/structure/handcart/container_resist(mob/living/user)
	var/atom/L = drop_location()
	for(var/atom/movable/AM in stuff_shit)
		if(AM == user)
			remove_from(AM)
			AM.forceMove(L)
			break

/obj/structure/handcart/dump_contents()
	var/atom/L = drop_location()
	var/list/cart_contents = stuff_shit.Copy()
	for(var/atom/movable/AM as anything in cart_contents)
		remove_from(AM)
		AM.forceMove(L)
	stuff_shit = list()
	current_capacity = 0
	update_icon()

/obj/structure/handcart/Destroy()
	var/turf/debris_turf = get_turf(src)
	if(debris_turf)
		if(is_metal_handcart)
			new /obj/effect/decal/cleanable/debris/handcart/metal(debris_turf)
		else
			new /obj/effect/decal/cleanable/debris/handcart/wood(debris_turf)
	dump_contents()
	for(var/obj/item/roguegear/wood/cog as anything in upgrades)
		qdel(cog)
	upgrades.Cut()
	return ..()

/obj/structure/handcart/proc/delete_stored_items()
	var/turf/drop_turf = get_turf(src)
	var/list/stored_items = stuff_shit.Copy()
	for(var/atom/movable/stored_item as anything in stored_items)
		remove_from(stored_item)
		if(isliving(stored_item))
			stored_item.forceMove(drop_turf)
			continue
		for(var/atom/movable/nested_item as anything in stored_item.GetAllContents())
			if(QDELETED(nested_item))
				continue
			if(isliving(nested_item))
				nested_item.forceMove(drop_turf)
			else
				qdel(nested_item)
		qdel(stored_item)
	stuff_shit.Cut()
	current_capacity = 0
	update_icon()

/obj/structure/handcart/steel/proc/has_unstable_upgrade()
	for(var/obj/item/roguegear/wood/unstable/cog as anything in upgrades)
		if(!QDELETED(cog))
			return TRUE
	return FALSE

/obj/effect/temp_visual/handcart_cog_sparks
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	randomdir = FALSE
	duration = 0.5 SECONDS
	fade_time = 0.2 SECONDS

/obj/effect/temp_visual/handcart_cog_electricity
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity"
	randomdir = FALSE
	duration = 0.5 SECONDS
	fade_time = 0.2 SECONDS

/obj/structure/handcart/steel/proc/handle_unstable_cog_event(obj/item/roguegear/wood/cog, mob/user)
	if(!has_unstable_upgrade())
		return FALSE
	if(istype(cog, /obj/item/roguegear/wood/basic) && prob(15))
		visible_message(span_warning("The steel handcart's metal cracks and spits electricity as [cog] shatters!"))
		qdel(cog)
		playsound(src, pick('sound/items/Upgradefail1.ogg', 'sound/items/Upgradefail2.ogg'), 100, FALSE)
		Shake(2, 2, 3)
		shake_camera(user, 3, 1)
		var/turf/effect_turf = get_turf(src)
		new /obj/effect/temp_visual/handcart_cog_sparks(effect_turf)
		new /obj/effect/temp_visual/handcart_cog_electricity(effect_turf)
		var/damage = min(round(max_integrity * 0.25), max(obj_integrity - 1, 0))
		if(damage)
			take_damage(damage, BRUTE, "blunt", FALSE)
		return TRUE
	if(istype(cog, /obj/item/roguegear/wood/reliable) && prob(20))
		trigger_cog_explosion(cog, user, FALSE)
		return TRUE
	if(istype(cog, /obj/item/roguegear/wood/unstable) && prob(45))
		trigger_cog_explosion(cog, user, TRUE)
		return TRUE
	return FALSE

/obj/structure/handcart/steel/proc/trigger_cog_explosion(obj/item/roguegear/wood/cog, mob/user, severe)
	var/turf/epicenter = get_turf(src)
	if(!epicenter)
		return FALSE
	if(severe)
		visible_message(span_reallybigredtext("<B><font color='#bb0000'>The unstable cog detonates! A violent blast hurls [user] backwards, shatters the steel handcart, and obliterates its contents!</font></B>"))
	else
		visible_message(span_redtextbig("<B><font color='#bb0000'>The reliable cog explodes! The blast hurls [user] backwards and shatters the steel handcart!</font></B>"))
	qdel(cog)
	delete_stored_items()
	if(severe)
		explosion(epicenter, heavy_impact_range = 2, light_impact_range = 3, flash_range = 3, smoke = TRUE, soundin = pick('sound/misc/explode/explosionclose (1).ogg', 'sound/misc/explode/explosionclose (2).ogg', 'sound/misc/explode/explosionclose (3).ogg'))
	else
		explosion(epicenter, light_impact_range = 2, flash_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/explosionclose (1).ogg', 'sound/misc/explode/explosionclose (2).ogg', 'sound/misc/explode/explosionclose (3).ogg'))
	var/installer_in_heavy_range = apply_cog_explosion_effects(epicenter, severe, user)
	if(isliving(user))
		var/mob/living/initiator = user
		var/knockback_distance = severe ? 2 : 1
		var/knockback_direction = get_dir(src, initiator)
		if(!knockback_direction)
			knockback_direction = initiator.dir
		var/turf/knockback_target = get_ranged_target_turf(initiator, knockback_direction, knockback_distance)
		if(knockback_target)
			initiator.throw_at(knockback_target, knockback_distance, 7)
		var/incapacitation_duration = installer_in_heavy_range ? 8 SECONDS : 4 SECONDS
		initiator.Knockdown(incapacitation_duration)
		initiator.Stun(incapacitation_duration)
		shake_camera(initiator, 4, severe ? 2 : 1)
	obj_integrity = 0
	obj_break("explosion")
	obj_destruction("explosion")
	return TRUE

/obj/structure/handcart/steel/proc/apply_cog_explosion_wound(mob/living/target, damage, wound_class)
	var/zone = BODY_ZONE_CHEST
	var/damage_flag = wound_class == BCLASS_CUT ? "slash" : "blunt"
	var/def_zone = zone
	var/obj/item/bodypart/affected_bodypart
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		affected_bodypart = carbon_target.get_bodypart(zone)
		if(affected_bodypart)
			def_zone = affected_bodypart
	var/armor_block = target.run_armor_check(zone, damage_flag, damage = damage)
	if(!target.apply_damage(damage, BRUTE, def_zone, armor_block))
		return
	if(affected_bodypart)
		affected_bodypart.bodypart_attacked_by(wound_class, damage, zone_precise = zone, silent = TRUE, armor = armor_block)
		if(wound_class == BCLASS_CUT)
			var/datum/wound/dynamic/slash/cut_wound = affected_bodypart.has_wound(/datum/wound/dynamic/slash)
			if(cut_wound && cut_wound.bleed_rate < 1)
				cut_wound.set_bleed_rate(1)
	else
		var/datum/wound/cut_wound = target.simple_woundcritroll(wound_class, max(damage - armor_block, 0), null, zone, silent = TRUE)
		if(wound_class == BCLASS_CUT && cut_wound && cut_wound.bleed_rate < 1)
			cut_wound.set_bleed_rate(1)

/obj/structure/handcart/steel/proc/apply_cog_explosion_effects(turf/epicenter, severe, mob/installer)
	var/installer_in_heavy_range = FALSE
	for(var/mob/living/target in range(4, epicenter))
		var/in_heavy_range = severe && get_dist(target, epicenter) < 2
		var/cut_damage = in_heavy_range ? 40 : 20
		var/blunt_damage = in_heavy_range ? 60 : 40
		apply_cog_explosion_wound(target, cut_damage, BCLASS_CUT)
		apply_cog_explosion_wound(target, blunt_damage, BCLASS_BLUNT)
		if(target == installer)
			installer_in_heavy_range = in_heavy_range
			continue
		var/incapacitation_duration = in_heavy_range ? 8 SECONDS : 4 SECONDS
		target.Knockdown(incapacitation_duration)
		target.Stun(incapacitation_duration)
	for(var/obj/nearby_object in range(4, epicenter))
		if(nearby_object == src || QDELETED(nearby_object))
			continue
		var/distance = get_dist(nearby_object, epicenter)
		var/integrity_damage = severe ? (distance < 2 ? 150 : 75) : 50
		nearby_object.take_damage(integrity_damage, BRUTE, "blunt", FALSE)
	return installer_in_heavy_range

/obj/structure/handcart/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(O) || !isturf(O.loc) || istype(O, /atom/movable/screen))
		return
	if(!istype(user) || user.incapacitated())
		return
	if(!Adjacent(user) || !user.Adjacent(O))
		return
	if(user == O) //try to climb into or onto it
		if(!(user.mobility_flags & MOBILITY_STAND))
			if(!do_after(user, 20, target = src))
				return FALSE
			if(put_in(O, user))
				playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)
			return TRUE
		return ..()
	if(user.used_intent.type == INTENT_HELP || user.used_intent.type == /datum/intent/grab/move)
		if(isliving(O))
			if(!insertion_allowed(O))
				return
			var/list/targets = list(O, src)
			if(!do_after_mob(user, targets, 20))
				return FALSE
			if(put_in(O, user))
				playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)
			return TRUE
		if(!isitem(O) && !is_cartloadable_structure(O))
			return
		if(scoop_from_turf(get_turf(O), user))
			playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)
		return TRUE

/obj/structure/handcart/should_click_on_mouse_up(atom/original_object)
	return original_object == src

/obj/structure/handcart/MiddleClick(mob/user, params)
	if(!Adjacent(user) || user.incapacitated())
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(scoop_from_turf(get_turf(src), user))
		playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)

/obj/structure/handcart/proc/scoop_from_turf(turf/T, mob/user)
	if(!T)
		return FALSE
	var/inserted_anything = FALSE
	for(var/atom/movable/AM_on_ground in T)
		if(AM_on_ground == src || (!isitem(AM_on_ground) && !is_cartloadable_structure(AM_on_ground)))
			continue
		if(!insertion_allowed(AM_on_ground))
			continue
		if(put_in(AM_on_ground, user))
			inserted_anything = TRUE
	return inserted_anything

/obj/structure/handcart/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		if(user.cmode)
			return ..()
		return repair_with_hammer(user, I)
	if(istype(I, /obj/item/repair_kit/metal))
		if(is_metal_handcart)
			return repair_with_kit(I, user)
		return
	if(istype(I, /obj/item/construction/repairkit/structure))
		if(!is_metal_handcart)
			return repair_with_structure_kit(I, user)
		return
	if(istype(I, /obj/item/roguegear/wood))
		if(!can_upgrade)
			to_chat(user, span_warning("[src] cannot be upgraded."))
			return
		var/obj/item/roguegear/wood/cog = I
		var/upgrade_slot = get_upgrade_slot(cog)
		if(isnull(upgrade_slot))
			to_chat(user, span_warning("[src] has no available upgrade slot for [I]."))
			return
		if(istype(src, /obj/structure/handcart/steel))
			var/obj/structure/handcart/steel/steel_cart = src
			if(steel_cart.handle_unstable_cog_event(cog, user))
				return TRUE
		if(!user.transferItemToLoc(cog, src))
			return
		if(!install_upgrade(cog, upgrade_slot))
			cog.forceMove(user.loc)
			to_chat(user, span_warning("There is no room for another upgrade on [src]."))
			return
		playsound(src, pick('sound/combat/hits/onwood/fence_hit1.ogg', 'sound/combat/hits/onwood/fence_hit2.ogg', 'sound/combat/hits/onwood/fence_hit3.ogg'), 100, FALSE)
		shake_camera(user, 1, 1)
		to_chat(user, span_warning("[cog] inserted!"))
		return
	if(!user.cmode)
		if(!insertion_allowed(I))
			return
		if(put_in(I, user))
			playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)
		return
	..()

/obj/structure/handcart/proc/get_repair_skill(mob/living/user)
	if(is_metal_handcart)
		return max(user.get_skill_level(/datum/skill/craft/blacksmithing), user.get_skill_level(/datum/skill/craft/engineering))
	return user.get_skill_level(/datum/skill/craft/carpentry)

/obj/structure/handcart/proc/repair_integrity(mob/living/user, repair_fraction)
	var/repair_skill = get_repair_skill(user)
	var/repair_amount = max_integrity * repair_fraction * (1 + repair_skill * 0.25)
	obj_integrity = min(obj_integrity + repair_amount, max_integrity)
	if(obj_broken && obj_integrity >= max_integrity)
		obj_fix()

/obj/structure/handcart/proc/repair_with_hammer(mob/living/user, obj/item/rogueweapon/hammer/hammer)
	if(obj_integrity >= max_integrity)
		to_chat(user, span_warning("[src] is not damaged."))
		return TRUE
	while(obj_integrity < max_integrity && user.is_holding(hammer) && Adjacent(user))
		if(!do_after(user, CLICK_CD_MELEE, target = src))
			return TRUE
		repair_integrity(user, 0.025)
		if(is_metal_handcart)
			playsound(hammer, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)
		else
			playsound(hammer, pick('sound/items/hammerwood1.ogg','sound/items/hammerwood2.ogg','sound/items/hammerwood3.ogg','sound/items/hammerwood4.ogg','sound/items/hammerwood5.ogg'), 100, FALSE)
		user.visible_message(span_info("[user] repairs [src]!"))
	return TRUE

/obj/structure/handcart/proc/repair_with_kit(obj/item/repair_kit/metal/kit, mob/living/user)
	if(!is_metal_handcart || !kit.can_repair)
		return FALSE
	if(kit.obj_integrity <= 0)
		kit.self_del()
		return TRUE
	if(obj_integrity >= max_integrity)
		to_chat(user, span_warning("[src] is not damaged."))
		return TRUE
	while(obj_integrity < max_integrity && kit.obj_integrity > 0 && user.is_holding(kit) && Adjacent(user))
		user.visible_message(span_notice("[user] starts repairing [src]."), \
			span_notice("I start repairing [src]."))
		if(!do_after(user, 2 SECONDS, target = src))
			return TRUE
		repair_integrity(user, 0.1)
		kit.obj_integrity = max(kit.obj_integrity - 10, 0)
		playsound(kit, 'sound/items/bsmith3.ogg', 100, TRUE, -2)
		user.visible_message(span_info("[user] repairs [src]!"))
	if(kit.obj_integrity <= 0)
		kit.self_del()
	return TRUE

/obj/structure/handcart/proc/repair_with_structure_kit(obj/item/construction/repairkit/structure/kit, mob/living/user)
	if(is_metal_handcart)
		return FALSE
	if(kit.obj_integrity <= 0)
		qdel(kit)
		return TRUE
	if(obj_integrity >= max_integrity)
		to_chat(user, span_warning("[src] is not damaged."))
		return TRUE
	while(obj_integrity < max_integrity && kit.obj_integrity > 0 && user.is_holding(kit) && Adjacent(user))
		user.visible_message(span_notice("[user] starts repairing [src]."), \
			span_notice("I start repairing [src]."))
		playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		if(!do_after(user, 2 SECONDS, target = src))
			return TRUE
		repair_integrity(user, 0.1)
		kit.obj_integrity = max(kit.obj_integrity - 1, 0)
		playsound(user, 'sound/misc/wood_saw.ogg', 100, TRUE)
		user.visible_message(span_info("[user] repairs [src]!"))
	if(kit.obj_integrity <= 0)
		qdel(kit)
	return TRUE

/obj/structure/handcart/proc/install_upgrade(obj/item/roguegear/wood/cog, upgrade_slot = null)
	if(!can_upgrade)
		return FALSE
	var/available_upgrade_slot = get_upgrade_slot(cog)
	if(isnull(available_upgrade_slot) || (!isnull(upgrade_slot) && upgrade_slot != available_upgrade_slot))
		return FALSE
	upgrade_slot = available_upgrade_slot
	if(upgrade_slot)
		var/obj/item/roguegear/wood/old_upgrade = upgrades[upgrade_slot]
		qdel(old_upgrade)
		upgrades[upgrade_slot] = cog
	else
		upgrades += cog
	update_upgrade_capacity()
	update_icon()
	return TRUE

/obj/structure/handcart/proc/get_upgrade_slot(obj/item/roguegear/wood/cog)
	if(length(upgrades) < upgrade_slot_count)
		return 0
	var/lowest_upgrade_level
	var/replace_slot
	for(var/slot in 1 to length(upgrades))
		var/obj/item/roguegear/wood/installed_upgrade = upgrades[slot]
		if(cog.ulevel <= installed_upgrade.ulevel)
			continue
		if(isnull(lowest_upgrade_level) || installed_upgrade.ulevel < lowest_upgrade_level)
			lowest_upgrade_level = installed_upgrade.ulevel
			replace_slot = slot
	return replace_slot

/obj/structure/handcart/proc/update_upgrade_capacity()
	maximum_capacity = initial(maximum_capacity)
	upgrade_level = 0
	for(var/obj/item/roguegear/wood/cog as anything in upgrades)
		maximum_capacity += cog.cart_capacity
		upgrade_level = max(upgrade_level, cog.ulevel + 1)

/obj/structure/handcart/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!length(stuff_shit))
		to_chat(user, span_warning("The cart is empty."))
		return TRUE
	var/list/targets = list()
	for(var/atom/movable/AM as anything in stuff_shit)
		var/display_name = AM.name
		var/duplicate_number = 2
		while(targets[display_name])
			display_name = "[AM.name] ([duplicate_number])"
			duplicate_number++
		targets[display_name] = AM
	var/selected_name = tgui_input_list(user, "Which item you want to take out of the cart?", name, targets)
	if(!selected_name)
		return TRUE
	var/atom/movable/selected_item = targets[selected_name]
	if(!selected_item || !(selected_item in stuff_shit) || !Adjacent(user))
		return TRUE
	remove_from(selected_item)
	if(isitem(selected_item))
		if(!user.put_in_hands(selected_item))
			selected_item.forceMove(get_turf(user))
	else
		selected_item.forceMove(user.loc)
	return TRUE

/obj/structure/handcart/proc/put_in(atom/movable/O, mob/user)
	if(O in stuff_shit)
		return FALSE
	var/weight = get_atom_weight(O)
	if(current_capacity + weight > maximum_capacity)
		if(user)
			to_chat(user, span_warning("The [name] is full."))
		return FALSE
	if(user && user.is_holding(O))
		if(!user.transferItemToLoc(O, src))
			return FALSE
	else
		O.forceMove(src)
	RegisterSignal(O, COMSIG_QDELETING, PROC_REF(remove_from_signal))
	current_capacity += weight
	stuff_shit += O
	update_icon()
	return TRUE

/obj/structure/handcart/proc/get_atom_weight(atom/movable/AM)
	var/weight = 0
	if(isitem(AM))
		var/obj/item/I = AM
		weight = I.w_class
	if(isliving(AM))
		var/mob/living/living_atom = AM
		weight = arbitrary_living_creature_weight * living_atom.mob_size
	if(is_cartloadable_structure(AM))
		weight = max(weight, structure_weight)
	return weight

/obj/structure/handcart/proc/is_cartloadable_structure(atom/movable/AM)
	for(var/path in cartloadable_structures)
		if(istype(AM, path))
			return TRUE
	return FALSE

/obj/structure/handcart/proc/remove_from_signal(atom/movable/source)
	SIGNAL_HANDLER
	remove_from(source, FALSE)

/obj/structure/handcart/proc/remove_from(atom/movable/AM, unregister_signal = TRUE)
	if(!(AM in stuff_shit))
		return FALSE
	if(unregister_signal)
		UnregisterSignal(AM, COMSIG_QDELETING)
	stuff_shit -= AM
	current_capacity = max(current_capacity - get_atom_weight(AM), 0)
	update_icon()
	return TRUE

/obj/structure/handcart/proc/take_contents()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in L)
		if(AM != src && put_in(AM)) // limit reached
			break

/obj/structure/handcart/update_icon()
	. = ..()
	cut_overlays()
	if(upgrade_level)
		if(upgrade_level == 2)
			add_overlay(image(icon = 'icons/roguetown/misc/structure.dmi', icon_state = "ov_upgrade", dir = dir))
		if(upgrade_level == 3)
			add_overlay(image(icon = 'icons/roguetown/misc/structure.dmi', icon_state = "ov_upgrade2", dir = dir))
	if(stuff_shit.len)
		icon_state = cart_full_state
	else
		icon_state = cart_empty_state

/obj/structure/handcart/attack_right(mob/user)
	var/obj/item/held_item = user.get_active_held_item()
	if(istype(held_item, /obj/item/rogueweapon/hammer))
		if(insertion_allowed(held_item) && put_in(held_item, user))
			playsound(loc, 'sound/foley/cartadd.ogg', 100, FALSE, -1)
		return TRUE
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(stuff_shit.len)
		dump_contents()
		visible_message(span_info("[user] dumps out [src]!"))
		playsound(loc, 'sound/foley/cartdump.ogg', 100, FALSE, -1)
	update_icon()

/obj/structure/handcart/get_crafting_contents()
	return stuff_shit.Copy()

/obj/structure/handcart/proc/insertion_allowed(atom/movable/AM)
	if(ismob(AM))
		if(!isliving(AM)) //let's not put ghosts or camera mobs inside closets...
			return FALSE
		var/mob/living/L = AM
		if(L.anchored || (L.buckled && L.buckled != src) || L.incorporeal_move || L.has_buckled_mobs())
			return FALSE
		if(L.mob_size > MOB_SIZE_TINY) // Tiny mobs are treated as items.
			if(L.density)
				return FALSE
		L.stop_pulling()

	else if(isobj(AM))
		if(is_cartloadable_structure(AM))
			if(AM.anchored || AM.has_buckled_mobs())
				return FALSE
		else if((AM.density) || AM.anchored || AM.has_buckled_mobs())
			return FALSE
		if(isitem(AM))
			var/obj/item/I = AM
			if(HAS_TRAIT(I, TRAIT_NODROP) || I.item_flags & ABSTRACT)
				return FALSE
	else // not a mob or object
		return FALSE

	return TRUE

/obj/structure/handcart/Move(atom/newloc, direct, glide_size_override)
	. = ..()
	if (. && pulledby && dir != pulledby.dir)
		setDir(pulledby.dir)
		update_icon()
