// Manticore Tail Organ
// On insertion, automatically attaches the intimate_reaction/manticore_tail
// component which produces movement and sex-received flavor text.
// Works with all existing tail-based sex actions (tailjob, tailpegging, etc.)
// because it occupies the standard ORGAN_SLOT_TAIL.

/obj/item/organ/tail/manticore
	name = "manticore tail"
	desc = "A thick, undulating appendage of dark-furred base \
		tapering into reddish serpentine scales, tipped with a \
		maw-like orifice ringed by interlocking bonelike plates. \
		Even severed, the feelers inside still twitch."
	icon_state = "severedtail"
	accessory_type = /datum/sprite_accessory/tail/manticore
	can_wag = TRUE
	organ_dna_type = /datum/organ_dna/tail
	var/fertility = TRUE
	var/pregnant = FALSE
	var/impregnation_probability = IMPREG_PROB_DEFAULT
	/// Whether the tail orifice is currently engorged/aroused.
	var/maw_engorged = FALSE
	/// The intimate_reaction component reference, for cleanup.
	var/datum/component/intimate_reaction/manticore_tail/reaction_component

/obj/item/organ/tail/manticore/Initialize(mapload)
	. = ..()
	reaction_component = AddComponent(/datum/component/intimate_reaction/manticore_tail)

/obj/item/organ/tail/manticore/Destroy()
	reaction_component = null
	return ..()

/obj/item/organ/tail/manticore/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	. = ..()
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(reaction_component)
		reaction_component.bind_to_wearer(H)
	update_maw_state()

/obj/item/organ/tail/manticore/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	if(ishuman(M) && reaction_component)
		reaction_component.unbind_from_wearer(M)
	var/datum/status_effect/creampie_leak/leak = M?.has_status_effect(/datum/status_effect/creampie_leak/long) || M?.has_status_effect(/datum/status_effect/creampie_leak)
	if(leak?.orifice & SEX_PART_TAIL_MAW)
		leak.orifice &= ~SEX_PART_TAIL_MAW
		if(!leak.orifice)
			M.remove_status_effect(leak)
	M?.remove_status_effect(/datum/status_effect/facial/internal/tailmaw)
	. = ..()
	maw_engorged = FALSE
	wagging = FALSE

/obj/item/organ/tail/manticore/imprint_organ_dna(datum/organ_dna/organ_dna)
	..()
	var/datum/organ_dna/tail/tail_dna = organ_dna
	tail_dna.fertility = fertility

/obj/item/organ/tail/manticore/be_impregnated(mob/living/carbon/human/father)
	if(!owner || owner.stat == DEAD || !fertility)
		return FALSE
	if(pregnant)
		to_chat(owner, span_love("I feel a surge of warmth in my belly again..."))
		return FALSE
	to_chat(owner, span_love("I feel a surge of warmth in my belly, I'm definitely pregnant!"))
	pregnant = TRUE
	return TRUE

/datum/organ_dna/tail
	var/fertility = TRUE

/datum/organ_dna/tail/imprint_organ(obj/item/organ/organ)
	..()
	if(istype(organ, /obj/item/organ/tail/manticore))
		var/obj/item/organ/tail/manticore/tail = organ
		tail.fertility = fertility

/obj/item/organ/tail/manticore/proc/get_examine_text(mob/living/carbon/human/looker)
	if(!owner)
		return
	if(maw_engorged)
		return "The maw at [owner.p_their()] tail's tip is splayed open, feelers writhing visibly and slick with sweet-smelling nectar."
	return "The bonelike plates at [owner.p_their()] tail's tip are sealed tightly shut, with only a faint bead of fluid visible at the seam."

/obj/item/organ/tail/manticore/proc/update_maw_state()
	if(!owner || !owner.sexcon)
		return
	var/new_state = owner.sexcon.arousal > 30
	if(new_state == maw_engorged)
		return
	maw_engorged = new_state
	wagging = maw_engorged
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.update_body_parts(TRUE)

/proc/get_manticore_tail(mob/living/carbon/human/H)
	var/obj/item/organ/tail/manticore/tail = H?.getorganslot(ORGAN_SLOT_TAIL)
	if(istype(tail))
		return tail
	return null

/mob/living/carbon/human/get_extra_mob_descriptors()
	. = ..()
	if(get_manticore_tail(src))
		. += /datum/mob_descriptor/manticore_tail

/datum/mob_descriptor/manticore_tail
	name = "Manticore tail"
	descriptor_color = "#ff66cc"
	aroused_descriptor_color = "#ff5555"

/datum/mob_descriptor/manticore_tail/can_describe(mob/living/described)
	return ishuman(described) && get_manticore_tail(described)

/datum/mob_descriptor/manticore_tail/get_description(mob/living/described)
	var/obj/item/organ/tail/manticore/tail = get_manticore_tail(described)
	. = tail?.get_examine_text()
	if(!tail)
		return
	var/datum/status_effect/creampie_leak/leak = described.has_status_effect(/datum/status_effect/creampie_leak/long) || described.has_status_effect(/datum/status_effect/creampie_leak)
	if(leak?.orifice & SEX_PART_TAIL_MAW)
		. += " Fluid is leaking from the tail maw."
	else if(described.has_status_effect(/datum/status_effect/facial/internal/tailmaw))
		. += " The tail maw is stained with fluid."

/datum/mob_descriptor/manticore_tail/get_standalone_text(mob/living/described, mob/watcher)
	return get_coalesce_text(described, null, watcher)
