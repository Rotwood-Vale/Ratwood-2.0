#define BITFLAG_EXPLOSIVE (1<<0)
#define BITFLAG_SHOCKER (1<<1)
#define BITFLAG_ANTIMAGIC (1<<2)

/obj/item/clothing/neck/roguetown/gorget/controllable
	name = "collar of servitude"
	icon_state = "collar_of_servitude"
	desc = "an ordinary gorget that has been imbued with a curse of the explosive sort. It is a powerfui tool designed to keep its wearer \
		servile and obedient under threat of its explosive potential detonating on their necks."

	icon_state = "servitude_collar"
	item_state = "servitude_collar"

	/// Bitflag to determine this collar's functions
	var/collar_flags = BITFLAG_SHOCKER
	/// Whether this collar is locked or nah
	var/collar_unlocked = TRUE
	var/is_going_to_boom = FALSE
	clothing_flags = null

/obj/item/clothing/neck/roguetown/gorget/controllable/Initialize(mapload)
	. = ..()
	if(collar_flags & BITFLAG_ANTIMAGIC)
		var/datum/magic_item/mundane/nomagic/effect = new
		AddComponent(/datum/component/magic_item, effect)

/obj/item/clothing/neck/roguetown/gorget/controllable/shock
	collar_flags = BITFLAG_SHOCKER

/obj/item/clothing/neck/roguetown/gorget/controllable/shock_antimagic
	collar_flags = BITFLAG_SHOCKER | BITFLAG_ANTIMAGIC

/obj/item/clothing/neck/roguetown/gorget/controllable/shock_explosive
	collar_flags = BITFLAG_SHOCKER | BITFLAG_EXPLOSIVE

/obj/item/clothing/neck/roguetown/gorget/controllable/full
	collar_flags = BITFLAG_SHOCKER | BITFLAG_EXPLOSIVE | BITFLAG_ANTIMAGIC

/obj/item/clothing/neck/roguetown/gorget/controllable/examine(mob/user)
	. = ..()
	if(collar_unlocked)
		. += "the red gem gleams faintly, it seems to be unpowered."
	else
		. += "the red gem gleams intensely, piercing your gaze with its aura."

/obj/item/clothing/neck/roguetown/gorget/controllable/Initialize()
	. = ..()

	RegisterSignal(src, COMSIG_ITEM_PRE_UNEQUIP, PROC_REF(tries_to_unequip))

/obj/item/clothing/neck/roguetown/gorget/controllable/Destroy()
	UnregisterSignal(src, COMSIG_ITEM_PRE_UNEQUIP)
	return ..()

/obj/item/clothing/neck/roguetown/gorget/controllable/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_NECK)
		to_chat(user, span_warning("The collar around your neck tightens. Its gemstone flashes red, reminding you of your lowly station."))
		collar_unlocked = FALSE
		return

/obj/item/clothing/neck/roguetown/gorget/controllable/attackby(obj/item/interacted_item, mob/living/user, params)
	. = ..()
	if(!istype(interacted_item, /obj/item/collar_detonator))
		return

	if(!collar_unlocked)
		collar_unlocked = TRUE
		to_chat(user, "The gemstone glow in [src] is fading. Looks like it is safe to remove now!")
	else
		to_chat(user, "\The [src] is already unlocked!")

/obj/item/clothing/neck/roguetown/gorget/controllable/proc/tries_to_unequip(force, atom/newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER
	if(collar_unlocked)
		return

	visible_message(span_warning("The [src] resists the pull to be unlocked!"))
	return COMPONENT_ITEM_BLOCK_UNEQUIP

/obj/item/clothing/neck/roguetown/gorget/controllable/proc/prepare_to_go_boom()
	if(is_going_to_boom)
		is_going_to_boom = FALSE
		audible_message(span_notice("Red aura of the [src] slowly fades away"))
		return

	playsound(src, 'sound/effects/musicbox_windup.ogg', 45)
	visible_message(span_boldwarning("Red aura begins to glow heavily from the [src], It appears to be going off!"))
	audible_message(span_boldwarning("You hear an eerie tune coming out of [src]"))

	addtimer(CALLBACK(src, PROC_REF(go_boom)), 7.5 SECONDS)
	is_going_to_boom = TRUE

/obj/item/clothing/neck/roguetown/gorget/controllable/proc/go_boom()
	if(!(collar_flags & BITFLAG_EXPLOSIVE))
		return

	var/mob/living/carbon/victim = loc
	if(victim?.get_item_by_slot(SLOT_NECK) != src)
		visible_message(span_notice("The red aura eminating from [src] stops!"))
		return

	if(!is_going_to_boom)
		visible_message(span_notice("The red aura eminating from [src] stops!"))
		return

	explosion(src, 1, 1, 2, 3) //first one to make sure wearer is damaged heavily
	explosion(src, 1, 0, 0, 0) //finishes the deal

	if(!istype(loc, /mob/living/carbon))
		qdel(src)
		return
	var/mob/living/carbon/soon_to_be_headless = loc
	var/obj/item/bodypart/head/to_decap = soon_to_be_headless.get_bodypart(BODY_ZONE_HEAD)
	if(to_decap)
		to_decap.dismember(BRUTE) //its a NECK collar

	qdel(src)

/obj/item/clothing/neck/roguetown/gorget/controllable/proc/do_zap()
	if(!(collar_flags & BITFLAG_SHOCKER))
		return

	var/mob/living/carbon/victim = loc
	if(victim?.get_item_by_slot(SLOT_NECK) != src)
		visible_message(span_notice("The red aura eminating from [src] stops!"))
		return

	var/mob/living/carbon/to_zap = loc
	to_zap?.electrocute_act(30, "Lightning Bolt", flags = SHOCK_NOGLOVES)
	return

/obj/item/collar_detonator
	name = "collar detonator"
	desc = "What seems to be an ordinary key at first is actually an enchanted contraption designed to \
		detonate or unlock collars of servitude."
	icon_state = "skeleton_key"
	icon = 'icons/roguetown/items/keys.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.75
	throwforce = 0
	drop_sound = 'sound/items/gems (1).ogg'
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH|ITEM_SLOT_NECK|ITEM_SLOT_RING
	grid_height = 64
	grid_width = 32

/obj/item/collar_detonator/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	. = ..()
	if(!iscarbon(target))
		return

	var/mob/living/carbon/to_bomb = target
	var/obj/item/clothing/neck/roguetown/gorget/controllable/collar = to_bomb.get_item_by_slot(SLOT_NECK)
	if(!istype(collar))
		to_chat(user, span_notice("[target] is not wearing a collar of servitude!"))
		return

	var/list/choices = list()
	if(collar.collar_flags & BITFLAG_EXPLOSIVE)
		choices += "Zap"
	if(collar.collar_flags & BITFLAG_SHOCKER)
		choices += "Explode"

	var/answer = null
	if(choices.len > 1)
		answer = tgui_alert(user, "The choice is thine, my master.", "COLLAR", choices)
	else
		answer = choices[1]

	switch(answer)
		if("Zap")
			collar?.do_zap()
		if("Explode")
			collar?.prepare_to_go_boom()

#undef BITFLAG_EXPLOSIVE
#undef BITFLAG_SHOCKER
#undef BITFLAG_ANTIMAGIC
