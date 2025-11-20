/datum/coven/malum
	name = "Malum"
	desc = "The Coven of the Opinionless God, who teaches that all forged things are merely tools - a blade to kill no different than a hoe to farm. Vampires of this coven are master craftsmen of flame and steel, creating and destroying with equal artistry, for the tool itself is neither good nor evil."
	power_type = /datum/coven_power/malum
	max_level = 4
	icon_state = "malum"
	is_god_coven = TRUE

/datum/coven_power/malum

// Level 1 - Forge Flame
/datum/coven_power/malum/forge_flame
	name = "Forge Flame"
	desc = "Summon flames to your hands, allowing you to wield fire as a weapon or tool. The forge-blessed touch burns all."
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 5
	cooldown_length = 45 SECONDS

/datum/coven_power/malum/forge_flame/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	user.visible_message(span_danger("[user] hurls a gout of flame!"))
	
	if(isliving(target))
		var/mob/living/victim = target
		victim.adjustFireLoss(30)
		victim.fire_stacks = min(victim.fire_stacks + 5, 10)
		to_chat(victim, span_userdanger("Flames sear my flesh!"))
	
	playsound(get_turf(target), 'sound/items/firelight.ogg', 100, TRUE)
	new /obj/effect/hotspot(get_turf(target))
	
	return TRUE

// Level 2 - Metallic Blessing
/datum/coven_power/malum/metallic_blessing
	name = "Metallic Blessing"
	desc = "Harden your skin to the strength of steel, granting resistance to physical harm. Your flesh becomes like wrought iron."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 120 SECONDS
	var/blessing_duration = 60 SECONDS

/datum/coven_power/malum/metallic_blessing/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_notice("My flesh hardens like steel!"))
	user.visible_message(span_warning("[user]'s skin takes on a metallic sheen!"))
	
	ADD_TRAIT(user, TRAIT_FORGEBLESSED, "metallic_blessing")
	ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "metallic_blessing")
	
	addtimer(CALLBACK(src, PROC_REF(remove_blessing), user), blessing_duration)
	return TRUE

/datum/coven_power/malum/metallic_blessing/proc/remove_blessing(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_FORGEBLESSED, "metallic_blessing")
	REMOVE_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "metallic_blessing")
	to_chat(user, span_warning("The metallic blessing fades..."))

// Level 3 - Hammer's Strike
/datum/coven_power/malum/hammers_strike
	name = "Hammer's Strike"
	desc = "Channel Malum's forge-might into a devastating blow that shatters armor and bones alike. Destruction perfected."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 3
	cooldown_length = 90 SECONDS

/datum/coven_power/malum/hammers_strike/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!isliving(target))
		to_chat(user, span_warning("I can only strike the living."))
		return FALSE
	
	var/mob/living/victim = target
	user.visible_message(span_danger("[user] strikes [victim] with forge-empowered might!"))
	
	playsound(get_turf(victim), 'sound/combat/hits/blunt/metalblunt (1).ogg', 100, TRUE)
	
	victim.adjustBruteLoss(50)
	victim.Knockdown(40)
	victim.throw_at(get_edge_target_turf(victim, get_dir(user, victim)), 3, 2)
	
	to_chat(victim, span_userdanger("A crushing blow shatters my body!"))
	
	// Break armor
	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		var/obj/item/clothing/suit/armor = H.get_item_by_slot(ITEM_SLOT_ARMOR)
		if(armor)
			armor.take_damage(50)
	
	return TRUE

// Level 4 - Inferno Incarnate
/datum/coven_power/malum/inferno_incarnate
	name = "Inferno Incarnate"
	desc = "Become living flame, immune to fire while radiating intense heat that burns all nearby. You are the forge given form."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	var/pain_duration = 50 SECONDS

/datum/coven_power/malum/inferno_incarnate/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("I AM THE FORGE! I AM THE FLAME!"))
	user.visible_message(span_danger("[user] erupts into living flame!"))
	
	user.set_light(8, 6, "#ff4400")
	ADD_TRAIT(user, TRAIT_FORGEBLESSED, "inferno_incarnate")
	ADD_TRAIT(user, TRAIT_RESISTHEAT, "inferno_incarnate")
	ADD_TRAIT(user, TRAIT_NOFIRE, "inferno_incarnate")
	
	addtimer(CALLBACK(src, PROC_REF(end_inferno), user), pain_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/malum/inferno_incarnate/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		end_inferno(user)
		return
	
	for(var/mob/living/L in view(4, user))
		if(L == user)
			continue
		L.adjustFireLoss(10)
		L.fire_stacks = min(L.fire_stacks + 2, 10)
		to_chat(L, span_userdanger("The inferno burns me!"))
	
	// Ignite surroundings
	var/turf/T = get_turf(user)
	if(prob(50))
		new /obj/effect/hotspot(T)

/datum/coven_power/malum/inferno_incarnate/proc/end_inferno(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_FORGEBLESSED, "inferno_incarnate")
		REMOVE_TRAIT(user, TRAIT_RESISTHEAT, "inferno_incarnate")
		REMOVE_TRAIT(user, TRAIT_NOFIRE, "inferno_incarnate")
		user.set_light(0)
		to_chat(user, span_warning("The inferno fades..."))
