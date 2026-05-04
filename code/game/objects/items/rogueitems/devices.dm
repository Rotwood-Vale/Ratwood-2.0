/obj/item/gem_device
	name = "rontz"
	icon_state = "ruby_cut"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "Its facets shine so brightly.."
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	var/usage_prompt
	resistance_flags = FIRE_PROOF

/obj/item/gem_device/attack_self(mob/living/user)
	var/alert = alert(user, "Do I want to use this? \n[usage_prompt]", "Enchanted Gem", "Yes", "No")
	if(alert != "Yes")
		return
	if(!on_use(user))
		to_chat(user, span_warning("\The [src] glows, then fizzles out!"))
		return
	to_chat(user, span_warning("With a bright spark \the [src] disappears!"))
	qdel(src)

/obj/item/gem_device/proc/on_use(mob/living/user)
	return FALSE

/obj/item/gem_device/goldface
	name = "gemerald"
	icon_state = "emerald_cut"
	desc = "Glints with verdant brilliance."
	usage_prompt = "Summon GOLDFACE"

/obj/item/gem_device/goldface/on_use(mob/living/user)
	var/turf/step_turf = get_step(get_turf(user), user.dir)
	do_sparks(3, TRUE, step_turf)
	new /obj/structure/roguemachine/goldface(step_turf)
	to_chat(user, span_notice("With a bright flash, a GOLDFACE appears in front of you!"))
	return TRUE

// Meant for BYOS
/obj/item/gem_device/throne
	name = "throne gem"
	icon_state = "diamond_cut"
	desc = "A brilliant blue gem humming with royal power, created by a skilled Magos. There's a miniature throne inside."
	usage_prompt = "Manifest a throne"
	color = "#4FA8FF"
	is_important = TRUE
	var/obj/structure/roguethrone/summoned_throne
	var/obj/structure/roguemachine/titan/summoned_throat

/obj/item/gem_device/throne/attack_self(mob/living/user)
	if(summoned_throne && !QDELETED(summoned_throne))
		to_chat(user, span_warning("The gem already has a manifested throne. Use the gem on that throne to absorb it."))
		return
	var/turf/step_turf = get_step(get_turf(user), user.dir)
	if(!step_turf)
		return
	do_sparks(3, TRUE, step_turf)
	playsound(step_turf, 'sound/magic/clang.ogg', 75, TRUE)
	summoned_throne = new /obj/structure/roguethrone(step_turf)
	summoned_throat = new /obj/structure/roguemachine/titan(step_turf)
	to_chat(user, span_notice("A throne manifests before me!"))

/obj/item/gem_device/throne/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return
	if(!istype(target, /obj/structure/roguethrone))
		return
	var/obj/structure/roguethrone/target_throne = target
	if(target_throne != summoned_throne)
		to_chat(user, span_warning("This throne is not bound to the gem."))
		return
	if(length(target_throne.buckled_mobs))
		to_chat(user, span_warning("I cannot absorb the throne while someone is seated on it."))
		return
	var/turf/flash_turf = get_turf(target_throne)
	if(summoned_throat && !QDELETED(summoned_throat))
		qdel(summoned_throat)
	qdel(target_throne)
	summoned_throne = null
	summoned_throat = null
	do_sparks(3, TRUE, flash_turf)
	playsound(flash_turf, 'sound/magic/charged.ogg', 75, TRUE)
	to_chat(user, span_notice("The throne collapses back into the gem."))
