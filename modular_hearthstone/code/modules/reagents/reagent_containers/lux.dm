/obj/item/reagent_containers/lux
	name = "lux"
	desc = "The stuff of lyfe and souls, retrieved from within a hopefully-willing donor. It's a bit clammy and squishy, like a half-fried egg."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux"
	item_state = "lux"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/vitae = 5)
	grind_results = list(/datum/reagent/vitae = 5)
	sellprice = 100
	dropshrink = 0.7

/datum/reagent/vitae
	name = "Vitae"
	description = "The extracted and processed essence of life."
	color = "#7d8e98" // rgb: 96, 165, 132
	overdose_threshold = 10
	metabolization_rate = 0.1

/datum/reagent/vitae/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, 0.25*REM)
	M.adjustFireLoss(0.25*REM, 0)
	..()
	. = 1

/datum/reagent/vitae/on_mob_life(mob/living/carbon/M)
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/vitae)
	..()

/obj/item/reagent_containers/lux_impure
	name = "impure lux"
	desc = "The stuff of lyfe and souls, retrieved from within a hopefully-willing donor. It's eerie and impure, requiring purification."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux_impure"
	item_state = "lux_impure"
	sellprice = 15
	dropshrink = 0.7

/obj/item/reagent_containers/lux/attack(mob/living/M, mob/user)
	testing("attack")
	if(!user.cmode)

		if(M.construct)
			if(M == user)
				user.visible_message(span_notice("[user] puts [src] against [user.p_their()] frame and absorbs it."), span_notice("I absorb [src], feeling my energy return."))
			else
				user.visible_message(span_notice("[user] attempts to press [src] to [M]."), span_notice("I attempt to press [src] to [M]."))
				if(!do_mob(user, M, 30))
					return
				user.visible_message(span_notice("[user] presses [src] against [M]."), span_notice("I press [src] against [M]."))
				to_chat(M, span_notice("I absorb [src], feeling my energy return."))
			M.energy_add(750)
			playsound(M.loc,'sound/magic/cosmic_expansion.ogg', rand(30,60), TRUE)
			qdel(src)

		else
			return ..()
	else
		return ..()

/obj/item/reagent_containers/lux_impure/attack(mob/living/M, mob/user)
	testing("attack")
	if(!user.cmode)

		if(M.construct)
			if(M == user)
				user.visible_message(span_notice("[user] puts [src] against [user.p_their()] frame and absorbs it."), span_notice("I absorb [src], feeling my energy return."))
			else
				user.visible_message(span_notice("[user] attempts to press [src] to [M]."), span_notice("I attempt to press [src] to [M]."))
				if(!do_mob(user, M, 30))
					return
				user.visible_message(span_notice("[user] presses [src] against [M]."), span_notice("I press [src] against [M]."))
				to_chat(M, span_notice("I absorb [src], feeling my energy return."))
			M.energy_add(500)
			playsound(M.loc,'sound/magic/cosmic_expansion.ogg', rand(30,60), TRUE)
			qdel(src)

		else
			return ..()
	else
		return ..()
