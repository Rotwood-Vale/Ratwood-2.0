/obj/effect/proc_holder/spell/self/magos_book_bind
	name = "Magos' Book Bind"
	desc = "Bind a spellbook by middle-clicking it, allowing the tome to be recalled to your hand."
	recharge_time = 30 SECONDS
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	cost = 1
	spell_tier = 1
	invocations = list("Redi ad manum.")//return to hand, i think
	invocation_type = "whisper"
	action_icon_state = "summons"

	var/obj/item/book/spellbook/bound_spellbook

/obj/effect/proc_holder/spell/self/magos_book_bind/cast(list/targets, mob/living/user = usr)
	if(!bound_spellbook)
		to_chat(user, span_warning("I have no spellbook bound. I must middle-click one first."))
		revert_cast()
		return FALSE
	if(QDELETED(bound_spellbook))
		to_chat(user, span_warning("I can no longer sense my bound spellbook."))
		bound_spellbook = null
		revert_cast()
		return FALSE
	if(bound_spellbook.loc == user)
		to_chat(user, span_notice("My bound spellbook is already in my possession."))
		revert_cast()
		return FALSE
	if(user.get_active_held_item() && user.get_inactive_held_item())
		to_chat(user, span_warning("I need a free hand to recall my bound spellbook."))
		revert_cast()
		return FALSE
	if(ismob(bound_spellbook.loc))
		var/mob/holder = bound_spellbook.loc
		holder.dropItemToGround(bound_spellbook)
	bound_spellbook.visible_message(span_warning("[bound_spellbook] vanishes in a swirl of arcyne energy!"))
	if(!user.put_in_hands(bound_spellbook))
		to_chat(user, span_warning("My bound spellbook resists the summons."))
		revert_cast()
		return FALSE
	user.visible_message(span_warning("[bound_spellbook] appears in [user]'s hand in a swirl of arcyne energy!"), span_notice("I recall [bound_spellbook] to my hand."))
	playsound(user, 'sound/magic/unmagnet.ogg', 60, TRUE)
	return TRUE
