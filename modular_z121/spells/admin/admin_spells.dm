/obj/effect/proc_holder/spell/invoked/adminkill
	name = "AdminKill"
	desc = "Immediately kill the selected target."
	school = "necromancy"
	cost = 0
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 0
	cooldown_min = 0
	devotion_cost = 0
	miracle = FALSE
	associated_skill = /datum/skill/magic/arcane
	range = 20
	invocations = list()
	invocation_type = "none"

/obj/effect/proc_holder/spell/invoked/adminkill/cast(list/targets, mob/living/user)
	if(!isliving(targets[1]))
		to_chat(user, span_warning("I can only use this on living targets."))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	if(target.stat == DEAD)
		to_chat(user, span_notice("[target] is already dead."))
		revert_cast()
		return FALSE

	target.visible_message(span_danger("[target] is struck down by overwhelming admin power!"), span_userdanger("Overwhelming admin power ends my life instantly!"))
	target.death()
	return TRUE

/obj/effect/proc_holder/spell/invoked/adminheal
	name = "AdminHeal"
	desc = "Immediately restore the selected target to full health."
	school = "restoration"
	cost = 0
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 0
	cooldown_min = 0
	devotion_cost = 0
	miracle = FALSE
	associated_skill = /datum/skill/magic/arcane
	range = 20
	invocations = list()
	invocation_type = "none"

/obj/effect/proc_holder/spell/invoked/adminheal/cast(list/targets, mob/living/user)
	if(!isliving(targets[1]))
		to_chat(user, span_warning("I can only heal living targets."))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	if(target.stat == DEAD)
		if(!target.revive(full_heal = TRUE, admin_revive = TRUE))
			to_chat(user, span_warning("[target] cannot be restored."))
			revert_cast()
			return FALSE
		target.visible_message(span_notice("[target] is restored to life by admin power!"), span_green("I am restored in an instant!"))
		return TRUE

	target.fully_heal(admin_revive = TRUE, break_restraints = TRUE)
	target.visible_message(span_notice("[target]'s wounds vanish in an instant!"), span_green("I am completely healed!"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/blink/adminblink
	name = "AdminBlink"
	desc = "Teleport to a selected location within 20 tiles."
	cost = 0
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 0
	cooldown_min = 0
	spell_tier = 1
	gesture_required = FALSE
	no_early_release = FALSE
	charging_slowdown = 0
	invocations = list()
	invocation_type = "none"
	max_range = 20

/obj/effect/proc_holder/spell/invoked/mimicry/copy
	name = "Copy"
	desc = "Create a duplicate of a selected item."
	school = "illusion"
	cost = 0
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 0
	cooldown_min = 0
	devotion_cost = 0
	miracle = FALSE
	associated_skill = /datum/skill/magic/arcane
	range = 1
	invocations = list()
	invocation_type = "none"
	action_icon_state = "mimicry"

/obj/effect/proc_holder/spell/invoked/mimicry/copy/proc/copy_item_state(obj/item/source, obj/item/duplicate)
	duplicate.name = source.name
	duplicate.desc = source.desc
	duplicate.color = source.color
	duplicate.icon_state = source.icon_state
	duplicate.item_state = source.item_state
	duplicate.dir = source.dir
	duplicate.pixel_x = source.pixel_x
	duplicate.pixel_y = source.pixel_y
	duplicate.transform = source.transform

	if(hasvar(source, "amount") && hasvar(duplicate, "amount"))
		duplicate.vars["amount"] = source.vars["amount"]
	if(hasvar(source, "maxamount") && hasvar(duplicate, "maxamount"))
		duplicate.vars["maxamount"] = source.vars["maxamount"]
	if(hasvar(source, "quality") && hasvar(duplicate, "quality"))
		duplicate.vars["quality"] = source.vars["quality"]
	if(hasvar(source, "obj_integrity") && hasvar(duplicate, "obj_integrity"))
		duplicate.vars["obj_integrity"] = source.vars["obj_integrity"]
	if(hasvar(source, "max_integrity") && hasvar(duplicate, "max_integrity"))
		duplicate.vars["max_integrity"] = source.vars["max_integrity"]
	if(hascall(duplicate, "set_quantity") && hasvar(source, "quantity"))
		call(duplicate, "set_quantity")(source.vars["quantity"])
	else if(hasvar(source, "quantity") && hasvar(duplicate, "quantity"))
		duplicate.vars["quantity"] = source.vars["quantity"]

/obj/effect/proc_holder/spell/invoked/mimicry/copy/cast(list/targets, mob/living/user)
	var/atom/target = targets[1]
	if(!istype(target, /obj/item))
		to_chat(user, span_warning("I can only copy items in reach."))
		revert_cast()
		return FALSE

	var/obj/item/target_item = target
	if(target_item.item_flags & ABSTRACT)
		to_chat(user, span_warning("[target_item] has no stable form to copy."))
		revert_cast()
		return FALSE

	var/obj/item/duplicate = new target_item.type(user.drop_location())
	copy_item_state(target_item, duplicate)
	if(!user.put_in_hands(duplicate))
		to_chat(user, span_notice("You copy [target_item], but your hands are full so it drops to the ground."))
	else
		to_chat(user, span_notice("You copy [target_item] into your hands."))
	return TRUE
