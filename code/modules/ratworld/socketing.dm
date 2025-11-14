// Ratworld gem socketing scaffolding
// Adds a generic component that can be attached to items to allow gem socketing.
// Only players with the Magician skill/class (placeholder check) can safely socket.
// Others have a 70% chance to brick the item when attempting.

// Contract:
// - Items may AddComponent(/datum/component/ratworld_socketable, max_sockets)
// - Gems are represented by /obj/item/roguegem subtypes
// - Socketing applies reroll attributes and consumes the gem; gems cannot be removed.

#define RW_SOCKET_BRICK_CHANCE 70

/datum/component/ratworld_socketable
	var/max_sockets = 0
	var/list/socketed = list() // list of type paths of inserted gems, in order

/datum/component/ratworld_socketable/Initialize(_max_sockets)
	. = ..()
	max_sockets = clamp(_max_sockets || 1, 0, 6)
	if(!isitem(parent))
		CRASH("ratworld_socketable attached to non-item")

/datum/component/ratworld_socketable/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/ratworld_socketable/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_PARENT_ATTACKBY, COMSIG_PARENT_EXAMINE))
	return ..()

/datum/component/ratworld_socketable/proc/has_free_socket()
	return length(socketed) < max_sockets

// Simple class/skill gate: treat Court Magician and their apprentices as safe socketers.
// This should later be replaced with a more robust capability check.
/proc/ratworld_is_safe_socketer(mob/living/user)
	if(!user) return FALSE
	if(user.job && (findtext(user.job, "Magician") || findtext(user.job, "Apprentice")))
		return TRUE
	// (Temporarily disabled trait-based safe socketing pending compile investigation)
	return FALSE

// Determine if an item is eligible for socketing (magic+ and correct families)
/proc/ratworld_is_socket_eligible(obj/item/I)
	if(!I) return FALSE
	var/rar = I.vars?["rw_rarity"]
	if(!isnum(rar) || rar < RW_RARITY_MAGIC) return FALSE
	if(istype(I, /obj/item/rogueweapon)) return TRUE
	if(istype(I, /obj/item/gun/ballistic/revolver/grenadelauncher/bow)) return TRUE
	if(istype(I, /obj/item/clothing)) return TRUE
	return FALSE

// Ensure a socketable component is present on eligible items. Defaults to 1 socket.
/proc/ratworld_ensure_socketable(obj/item/I)
	if(!I) return
	if(!ratworld_is_socket_eligible(I)) return
	var/datum/component/ratworld_socketable/S = I.GetComponent(/datum/component/ratworld_socketable)
	if(!S)
		I.AddComponent(/datum/component/ratworld_socketable, 1)

// Core flow: using a gem on a socketable item will attempt to insert it
/datum/component/ratworld_socketable/proc/on_attackby(obj/item/with, mob/living/user, params)
	if(!istype(with, /obj/item/roguegem))
		return FALSE
	var/obj/item/I = parent
	// Enforce item eligibility: only magical (Magic+) items can be socketed
	if(!ratworld_is_socket_eligible(I))
		to_chat(user, span_warning("Only magical items (Magic+) can be socketed."))
		return COMPONENT_NO_AFTERATTACK
	if(!has_free_socket())
		to_chat(user, span_warning("There are no empty sockets on [I]."))
		return COMPONENT_NO_AFTERATTACK
	// Brick check for non-magicians
	if(!ratworld_is_safe_socketer(user))
		if(prob(RW_SOCKET_BRICK_CHANCE))
			to_chat(user, span_danger("I fumble the socketing and ruin [I]!"))
			I.visible_message(span_danger("[user] botches a gem socketing and ruins [I]!"))
			I.flags_1 |= CONDUCT_1 // mark unusable as a placeholder; real implementation should set a broken state
			qdel(with)
			return COMPONENT_NO_AFTERATTACK
	// Safe socket: record the gem type and apply attribute swap reroll
	socketed += with.type
	if(istype(with, /obj/item/roguegem))
		var/obj/item/roguegem/G = with
		ratworld_socket_apply_reroll(G, I, user)
	qdel(with)
	I.visible_message(span_notice("[user] sockets a gem into [I]."))
	return COMPONENT_NO_AFTERATTACK

/datum/component/ratworld_socketable/proc/on_examine(mob/user, list/examine_list)
	var/free = max_sockets - length(socketed)
	examine_list += "<span class='italics'>Sockets:</span> [length(socketed)] / [max_sockets]"
	if(length(socketed))
		var/list/names = list()
		for(var/T in socketed)
			var/obj/item/roguegem/G = T
			names += initial(G.name)
		examine_list += " • Inserted: [english_list(names)]"
	if(free <= 0)
		examine_list += span_warning("No empty sockets remain.")
	else
		examine_list += span_notice("[free] socket(s) free.")

#undef RW_SOCKET_BRICK_CHANCE

// Fallback: Allow using a gem on an eligible item even if it doesn't yet have the socketable component
/obj/item/roguegem/afterattack(atom/target, mob/user, proximity, clickparams)
	..()
	if(!proximity) return
	if(!istype(target, /obj/item)) return
	var/obj/item/I = target
	if(!ratworld_is_socket_eligible(I)) return
	// Ensure component then forward the interaction
	ratworld_ensure_socketable(I)
	// Attackby triggers the component's flow; if no free sockets, it will message
	I.attackby(src, user)
