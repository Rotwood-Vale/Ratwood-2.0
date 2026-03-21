/datum/sprite_accessory/chastity
	abstract_type = /datum/sprite_accessory/chastity
	icon = 'modular/icons/obj/lewd/chastity_overlays.dmi'
	// Keep chastity between base bodyparts (45) and breast-adj overlays (44).
	// Using a midpoint avoids same-layer contention with chest/body sprites.
	layer = 44.5
	color_keys = 1
	color_key_names = "Chastity"
	var/chastity_type = /obj/item/chastity

/datum/sprite_accessory/chastity/proc/get_chastity_suffix(mob/living/carbon/owner)
	var/datum/species/species = owner?.dna?.species
	if(species?.clothes_id == "dwarf")
		return owner.gender == FEMALE ? "d_f" : "d_m"
	if(is_species(owner, /datum/species/elf) && owner.gender == MALE)
		return "e_m"
	return owner.gender == FEMALE ? "h_f" : "h_m"

/datum/sprite_accessory/chastity/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return "[icon_state]_[get_chastity_suffix(owner)]"

/datum/sprite_accessory/chastity/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(H.underwear)
		return FALSE
	return is_human_part_visible(owner, HIDECROTCH)

/datum/sprite_accessory/chastity/full
	name = "Full Belt"
	icon_state = "cage_belt"
	chastity_type = /obj/item/chastity

/datum/sprite_accessory/chastity/cage
	name = "Cage"
	icon_state = "cage_standard"
	chastity_type = /obj/item/chastity/chastity_cage

/datum/sprite_accessory/chastity/anal
	name = "Anal Shield"
	icon_state = "cage_belt_shield"
	chastity_type = /obj/item/chastity/chastity_belt/anal

/datum/sprite_accessory/chastity/spiked
	name = "Spiked Cage"
	icon_state = "cage_standard_spiked"
	chastity_type = /obj/item/chastity/chastity_cage/spiked

/datum/sprite_accessory/chastity/spiked_anal
	name = "Spiked Cage with Anal"
	icon_state = "cage_standard_spikeshield"
	chastity_type = /obj/item/chastity/chastity_cage/spiked_anal

/datum/sprite_accessory/chastity/spiked_belt
	name = "Spiked Belt"
	icon_state = "cage_belt_spiked"
	chastity_type = /obj/item/chastity/chastity_belt/spiked

/datum/sprite_accessory/chastity/spiked_belt_anal
	name = "Spiked Belt with Anal"
	icon_state = "cage_belt_spikeshield"
	chastity_type = /obj/item/chastity/chastity_belt/spiked_anal

/datum/sprite_accessory/chastity/flat
	name = "Flat Cage"
	icon_state = "cage_flat"
	chastity_type = /obj/item/chastity/chastity_cage/flat

/datum/sprite_accessory/chastity/intersex
	name = "Intersex Cage"
	icon_state = "cage_intersex"
	chastity_type = /obj/item/chastity/intersex

/datum/sprite_accessory/chastity/cursed_belt
	name = "Cursed Belt"
	icon_state = "cage_cursedb"
	chastity_type = /obj/item/chastity/cursed

/datum/sprite_accessory/chastity/cursed_cage
	name = "Cursed Cage"
	icon_state = "cage_cursed_cock"
	chastity_type = /obj/item/chastity/cursed

/datum/sprite_accessory/chastity/cursed_flat
	name = "Cursed Flat Cage"
	icon_state = "cage_cursed_flat"
	chastity_type = /obj/item/chastity/cursed

/datum/sprite_accessory/chastity/cursed_intersex
	name = "Cursed Intersex"
	icon_state = "cage_cursed_intersex"
	chastity_type = /obj/item/chastity/cursed
