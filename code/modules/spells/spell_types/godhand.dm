/obj/item/melee/touch_attack
	name = "\improper 伸出的手掌"
	desc = ""
	var/catchphrase = "击掌！"
	var/on_use_sound = null
	var/obj/effect/proc_holder/spell/targeted/touch/attached_spell
	icon = 'icons/obj/balloons.dmi'
	lefthand_file = 'icons/mob/inhands/misc/touchspell_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/touchspell_righthand.dmi'
	icon_state = "syndballoon"
	item_state = null
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 0
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	var/charges = 1

/obj/item/melee/touch_attack/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/melee/touch_attack/attack(mob/target, mob/living/carbon/user)
	if(!iscarbon(user)) //Look ma, no hands
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, "<span class='warning'>我伸不出手！</span>")
		return
	..()

/obj/item/melee/touch_attack/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	user.say(catchphrase, forced = "spell")
	playsound(get_turf(user), on_use_sound,50,TRUE)
	charges--
	if(charges <= 0)
		qdel(src)

/obj/item/melee/touch_attack/Destroy()
	if(attached_spell)
		attached_spell.on_hand_destroy(src)
	return ..()
