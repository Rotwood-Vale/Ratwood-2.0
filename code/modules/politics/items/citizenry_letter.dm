// Letter of Citizenry - ported from Azure-Peak #6849 (code/modules/politics/items/citizenry_letter.dm).
// Printed by the Nerve Master (steward.dm "printresidency"); claiming it grants TRAIT_RESIDENT,
// which places the bearer under the Golden Bull's protections and the Burgher poll category.
// Ratwood deviations: "Citizen of Azuria" -> "Citizen of the Vale"; AP's paper.dmi doesn't exist
// in ES, so this uses ES's stock parchment art from misc.dmi (same as patronage_writ.dm).

#define TRAIT_CITIZENRY_LETTER "citizenry_letter"

/obj/item/citizenry_letter
	name = "Letter of Citizenry"
	desc = "A sealed letter from the Nerve Master, bearing the Steward's signature."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "paper"
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	var/issuer_name
	var/issuer_year

/obj/item/citizenry_letter/examine(mob/user)
	. = ..()
	var/signature = issuer_name || "the Nerve Master"
	var/year = issuer_year || CALENDAR_EPOCH_YEAR
	. += span_info("The letter reads: <i>\"Be it known to all who read this writ, that the bearer, upon claiming this letter, is enrolled as a Citizen of the Vale and raised to the station of Burgher, bearing the protections and obligations attending that rank under the Golden Bull of Kingsfield.\"</i>")
	. += span_info("<i>Signed in the year [year], [signature].</i>")
	. += span_notice("Left-click in hand to claim its rights.")

/obj/item/citizenry_letter/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return ..()
	if(HAS_TRAIT(user, TRAIT_RESIDENT))
		to_chat(user, span_warning("I am already a Citizen of the Vale."))
		return
	if(user.job == "Steward" || user.job == "Grand Duke")
		to_chat(user, span_warning("This letter is meant for another. I must hand it over."))
		return
	user.visible_message(span_notice("[user] unfolds the letter and accepts its seal."), \
		span_notice("I claim the rights of Citizenry and Burghership granted by this letter."))
	ADD_TRAIT(user, TRAIT_RESIDENT, TRAIT_CITIZENRY_LETTER)
	playsound(get_turf(user), 'sound/misc/gold_license.ogg', 60, FALSE, -1)
	qdel(src)

#undef TRAIT_CITIZENRY_LETTER
