#define ARCBARRIER_FILTER "arcyne_barrier"

/datum/action/cooldown/spell/conjure_arcyne_ward/barrier
	name = "Conjure Barrier"
	desc = "Conjure an arcyne barrier. Granting long-lasting immunity from attacks of an arcyne nature."
	button_icon_state = "barrier"
	spell_color = GLOW_COLOR_METAL
	invocations = list("Fatum Deterritum!")
	dismiss_invocation = "Fatum Dissipo!"
	regen_invocation = "Fatum Restauro!"
	point_cost = 0
	exclusive_group = "arcyne_ward"
	ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/barrier

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/barrier
	name = "arcyne barrier"
	desc = "An art mastered by Naledi Sojourners. A barrier against the winds of fate, powered by their own spark. Magyks will have no effect upon the user."
	ward_color = "#12f0f0"

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/barrier/setup_ward(mob/living/carbon/human/H)
	..()
	H.apply_status_effect(/datum/status_effect/buff/arcyne_barrier)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/barrier/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_status_effect(/datum/status_effect/buff/arcyne_barrier)
	..()

/datum/status_effect/buff/arcyne_barrier
	id = "arcyne_barrier"
	alert_type = /atom/movable/screen/alert/status_effect/buff/arcyne_barrier
	duration = -1
	var/outline_colour = "#12f0f0"

/atom/movable/screen/alert/status_effect/buff/arcyne_barrier
	name = "Arcyne Barrier"
	desc = "The spark of the arcyne surrounds me, protecting my form from the winds of fate!"

/datum/status_effect/buff/arcyne_barrier/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_SPELL_DISPERSION, MAGIC_TRAIT)
	if(!owner.get_filter(ARCBARRIER_FILTER))
		owner.add_filter(ARCBARRIER_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))

/datum/status_effect/buff/arcyne_barrier/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_SPELL_DISPERSION, MAGIC_TRAIT)
	owner.remove_filter(ARCBARRIER_FILTER)

#undef ARCBARRIER_FILTER
