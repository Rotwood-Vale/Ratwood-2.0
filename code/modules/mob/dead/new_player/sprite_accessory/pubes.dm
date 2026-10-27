/datum/sprite_accessory/pubes
	abstract_type = /datum/sprite_accessory/pubes
	icon = 'icons/mob/sprite_accessory/genitals/pubes.dmi'
	color_key_name = "Color"
	color_key_defaults = list(KEY_HAIR_COLOR)
	layer = 44.5

/datum/sprite_accessory/pubes/proc/get_pubes_suffix(mob/living/carbon/owner)
	var/datum/species/species = owner?.dna?.species
	if(species?.clothes_id == "dwarf")
		return owner.gender == FEMALE ? "d_f" : "d_m"
	if(is_species(owner, /datum/species/elf) && owner.gender == MALE)
		return "e_m"
	if(is_species(owner, /datum/species/halforc))
		return owner.gender == FEMALE ? "h_ft" : "h_mt"
	return owner.gender == FEMALE ? "h_f" : "h_m"

/datum/sprite_accessory/pubes/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return "[icon_state]_[get_pubes_suffix(owner)]"

/datum/sprite_accessory/pubes/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.sexcon && owner.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(owner.underwear)
		return FALSE
	if(!get_location_accessible(owner, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDECROTCH)

/datum/sprite_accessory/pubes/hairy
	icon_state = "pubes_hairy"
	name = "Hairy"

/datum/sprite_accessory/pubes/trim
	icon_state = "pubes_trim"
	name = "Trimmed"

/datum/sprite_accessory/pubes/strip
	icon_state = "pubes_strip"
	name = "Landing Strip"

/datum/sprite_accessory/pubes/heart
	icon_state = "pubes_heart"
	name = "Heart"

/datum/sprite_accessory/pubes/extreme
	icon_state = "pubes_extreme"
	name = "La coupe à la Otavaise"

/datum/sprite_accessory/pubes/cross
	icon_state = "pubes_cross"
	name = "Psycross"


/datum/sprite_accessory/pits
	abstract_type = /datum/sprite_accessory/pits
	icon = 'icons/mob/sprite_accessory/genitals/pits.dmi'
	color_key_name = "Color"
	color_key_defaults = list(KEY_HAIR_COLOR)
	layer = 44.5

/datum/sprite_accessory/pits/proc/get_pits_suffix(mob/living/carbon/owner)
	var/datum/species/species = owner?.dna?.species
	if(species?.clothes_id == "dwarf")
		return owner.gender == FEMALE ? "d_f" : "d_m"
	if(is_species(owner, /datum/species/elf) && owner.gender == MALE)
		return "e_m"
	if(is_species(owner, /datum/species/halforc))
		return owner.gender == FEMALE ? "h_ft" : "h_mt"
	return owner.gender == FEMALE ? "h_f" : "h_m"

/datum/sprite_accessory/pits/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return "[icon_state]_[get_pits_suffix(owner)]"

/datum/sprite_accessory/pits/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.underwear && owner.underwear.covers_breasts)
		return FALSE
	if(!get_location_accessible(owner, BODY_ZONE_CHEST))
		return FALSE
	return is_human_part_visible(owner, HIDEBOOB|HIDEJUMPSUIT)

/datum/sprite_accessory/pits/trim
	icon_state = "pits_trim"
	name = "Trim"

/datum/sprite_accessory/pits/moderate
	icon_state = "pits"
	name = "Moderate"

/datum/sprite_accessory/pits/hairy
	icon_state = "pits_hairy"
	name = "Hairy"

/datum/sprite_accessory/pits/extreme
	icon_state = "pits_extreme"
	name = "La coupe à la Otavaise"
