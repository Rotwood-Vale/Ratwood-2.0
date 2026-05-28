//T1, Baotha's version of Eora's Bud (now renamed True Peace Bloom). Applies the TRAIT_CRACKHEAD baothans have.
/datum/action/cooldown/spell/griefflower
	name = "False Serenity Bloom"
	desc = "A gift for those whom you have choosen as worthy of Her grace, to be able to imbibe in Her gifts as you do."
	clothes_req = FALSE
	range = 7
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "bloom"
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 10
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	recharge_time = 30 MINUTES //To avoid spamming this shit and giving all heretics florida-man crackhead superpowers. No Bro.

/datum/action/cooldown/spell/griefflower/cast(mob/living/user)
	var/turf/T = get_turf(user)
	if(!isclosedturf(T))
		new /obj/item/clothing/ring/griefflower(T)
		return TRUE

	to_chat(user, span_warning("The targeted location is blocked. Her gift cannot be invoked."))
	revert_cast()
	return FALSE

/obj/item/clothing/ring/griefflower
	name = "rosa ring"
	desc = "Once a flower of love, now touched by Baotha's hand. Its petals whisper of desire, despair, and the kind of longing that never dies. Worn by those who cannot let go."
	icon_state = "peaceflower"
	item_state = "peaceflower"
	icon = 'icons/roguetown/items/produce.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'

/obj/item/clothing/ring/griefflower/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_RING)
		user.apply_status_effect(/datum/status_effect/buff/griefflower)

/obj/item/clothing/ring/griefflower/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.wear_ring == src)
		user.remove_status_effect(/datum/status_effect/buff/griefflower)
