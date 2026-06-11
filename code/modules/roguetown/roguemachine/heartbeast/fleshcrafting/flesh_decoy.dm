/mob/living/simple_animal/flesh_decoy
	icon = 'icons/obj/structures/heart_items.dmi'
	name = "血肉诱饵"
	desc = "一具由血肉构成、纹丝不动的魔像，脸上挂着狰狞笑容。你能清楚看出它并非活物，可那腐烂血肉的气味却诡异地诱人。可用中键拾起。"
	icon_state = "flesh_golem"
	icon_living = "flesh_golem"
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = null
	health = 100
	maxHealth = 100

/obj/item/flesh_decoy
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "flesh_golem_item"
	name = "血肉诱饵"
	desc = "一具由血肉构成、纹丝不动的魔像，脸上挂着狰狞笑容。你能清楚看出它并非活物，可那腐烂血肉的气味却诡异地诱人。"
	w_class = WEIGHT_CLASS_SMALL
	var/mob_health = 100
	var/mob_maxHealth = 100

/mob/living/simple_animal/flesh_decoy/death(gibbed)
	. = ..()
	var/obj/item/reagent_containers/food/snacks/rogue/meat/steak/F = new /obj/item/reagent_containers/food/snacks/rogue/meat/steak (src.loc)
	F.become_rotten()
	qdel(src)

/mob/living/simple_animal/flesh_decoy/MiddleClick(mob/living/user)
	. = ..()
	if(user.incapacitated() || !Adjacent(user))
		return

	var/obj/item/flesh_decoy/item = new(user.loc)
	item.mob_health = src.health
	item.mob_maxHealth = src.maxHealth

	if(user.put_in_hands(item))
		visible_message(span_notice("[user]捡起了[src]。"))
		qdel(src)
	else
		to_chat(user, span_danger("你现在没法捡起[src]！"))
		qdel(item)

/obj/item/flesh_decoy/dropped(mob/user, silent = FALSE)
	. = ..()
	if(isturf(loc))
		addtimer(CALLBACK(src, PROC_REF(check_if_thrown)), 1)

/obj/item/flesh_decoy/proc/check_if_thrown()
	if(!throwing && isturf(loc))
		convert_to_mob(loc)

/obj/item/flesh_decoy/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/turf/T = get_turf(hit_atom)

	if(hit_atom.density && !istype(hit_atom, /mob/living))
		var/turf/bounce_turf = get_step(T, turn(throwingdatum.init_dir, 180))
		if(bounce_turf && !bounce_turf.density)
			T = bounce_turf
		else
			for(var/dir in GLOB.cardinals)
				var/turf/adjacent = get_step(T, dir)
				if(adjacent && !adjacent.density)
					T = adjacent
					break

	if(T && !T.density)
		convert_to_mob(T)
	else
		convert_to_mob(get_turf(src))
	return ..()

/obj/item/flesh_decoy/proc/convert_to_mob(turf/T)
	var/mob/living/simple_animal/flesh_decoy/mob = new(T)

	if(mob_health)
		mob.health = mob_health
		mob.maxHealth = mob_maxHealth
	mob.health = min(mob.health, mob.maxHealth)
	visible_message(span_notice("[src]啪嗒一声落到了地上！"))
	playsound(T, 'sound/magic/slimesquish.ogg', 50, TRUE)
	qdel(src)

/obj/item/flesh_decoy/attack_self(mob/user)
	. = ..()
	var/turf/T = get_turf(user)
	if(T)
		convert_to_mob(T)
