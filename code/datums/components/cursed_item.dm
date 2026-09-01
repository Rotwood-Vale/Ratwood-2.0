/datum/component/cursed_item
	dupe_mode = COMPONENT_DUPE_UNIQUE
	///trait that will avoid triggering the curse
	var/required_trait
	///used for the text you get upon triggering the curse
	var/item_type
	var/verbed

/datum/component/cursed_item/Initialize(god_trait, item_class, verbiage = "PUNISHED")
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	required_trait = god_trait
	item_type = item_class
	verbed = verbiage

	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))

/datum/component/cursed_item/proc/on_equip()
	SIGNAL_HANDLER
	var/obj/item/I = parent
	if(!ishuman(I.loc))
		return
	var/mob/living/carbon/human/user = I.loc
	if(!HAS_TRAIT(user, required_trait))
		// deferred, not INVOKE_ASYNC: nothing in punish_unworthy sleeps, so async would burn
		// the mob inline in the middle of the equip signal. The original spawn(0) deferred it.
		addtimer(CALLBACK(src, PROC_REF(punish_unworthy), user), 0)

/datum/component/cursed_item/proc/punish_unworthy(mob/living/carbon/human/user)
	to_chat(user, "<font color='red'>UNWORTHY HANDS TOUCHING THIS [item_type], CEASE OR BE [verbed]!</font>")
	user.adjust_fire_stacks(5)
	user.ignite_mob()
	user.Stun(40)

