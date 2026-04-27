// =====================================================
// MYSTERIOUS ORGAN
// Ripper exclusive surgically implanted grafts.
// Three tiers, all sharing the same slot.
// Passive regen with permanent negative traits on the host.
// =====================================================

/obj/item/organ/mysterious
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	zone = BODY_ZONE_CHEST
	slot = "mysterious_organ"
	healing_factor = 0
	decay_factor = 0

// Tier I — Pale Graft
// Brute/fire/blood/wound regen. CRITICAL_WEAKNESS + CLUMSY.

/obj/item/organ/mysterious/pale
	name = "pale graft"
	desc = "A pale, damp lump of flesh. Unidentifiable. Still warm."

/obj/item/organ/mysterious/pale/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	..()
	ADD_TRAIT(M, TRAIT_CRITICAL_WEAKNESS, "mysterious_organ")
	ADD_TRAIT(M, TRAIT_CLUMSY, "mysterious_organ")

/obj/item/organ/mysterious/pale/Remove(mob/living/carbon/M, special = 0)
	REMOVE_TRAIT(M, TRAIT_CRITICAL_WEAKNESS, "mysterious_organ")
	REMOVE_TRAIT(M, TRAIT_CLUMSY, "mysterious_organ")
	..()

/obj/item/organ/mysterious/pale/on_life()
	..()
	if(organ_flags & ORGAN_FAILING)
		return
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	if(H.blood_volume < BLOOD_VOLUME_NORMAL)
		H.blood_volume = min(H.blood_volume + 15, BLOOD_VOLUME_NORMAL)
	var/list/wCount = H.get_wounds()
	if(wCount.len > 0)
		H.heal_wounds(3)
	H.adjustBruteLoss(-2, 0)
	H.adjustFireLoss(-2, 0)

// Tier II — Withered Graft
// Slow brute/fire regen only. CRITICAL_WEAKNESS only.

/obj/item/organ/mysterious/withered
	name = "withered graft"
	desc = "A desiccated lump of pale meat. Whatever it was, it's barely alive now."

/obj/item/organ/mysterious/withered/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	..()
	ADD_TRAIT(M, TRAIT_CRITICAL_WEAKNESS, "mysterious_organ")

/obj/item/organ/mysterious/withered/Remove(mob/living/carbon/M, special = 0)
	REMOVE_TRAIT(M, TRAIT_CRITICAL_WEAKNESS, "mysterious_organ")
	..()

/obj/item/organ/mysterious/withered/on_life()
	..()
	if(organ_flags & ORGAN_FAILING)
		return
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	H.adjustBruteLoss(-1, 0)
	H.adjustFireLoss(-1, 0)

// Tier III — Blackened Graft
// Full damage regen. CRITICAL_WEAKNESS + CLUMSY + FASTSLEEP.

/obj/item/organ/mysterious/blackened
	name = "blackened graft"
	icon_state = "liver-con"
	desc = "A dense, blackened mass. Nothing about it looks natural."

/obj/item/organ/mysterious/blackened/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	..()
	ADD_TRAIT(M, TRAIT_CRITICAL_WEAKNESS, "mysterious_organ")
	ADD_TRAIT(M, TRAIT_CLUMSY, "mysterious_organ")
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.has_flaw(/datum/charflaw/narcoleptic))
			var/datum/charflaw/narcoleptic/N = new
			H.vices += N
			N.on_mob_creation(H)

/obj/item/organ/mysterious/blackened/Remove(mob/living/carbon/M, special = 0)
	REMOVE_TRAIT(M, TRAIT_CRITICAL_WEAKNESS, "mysterious_organ")
	REMOVE_TRAIT(M, TRAIT_CLUMSY, "mysterious_organ")
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/charflaw/narcoleptic/N = H.get_flaw(/datum/charflaw/narcoleptic)
		if(N)
			N.on_removal(H)
			H.vices -= N
			qdel(N)

/obj/item/organ/mysterious/blackened/on_life()
	..()
	if(organ_flags & ORGAN_FAILING)
		return
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	if(H.blood_volume < BLOOD_VOLUME_NORMAL)
		H.blood_volume = min(H.blood_volume + 20, BLOOD_VOLUME_NORMAL)
	var/list/wCount = H.get_wounds()
	if(wCount.len > 0)
		H.heal_wounds(5)
	H.adjustBruteLoss(-4, 0)
	H.adjustFireLoss(-4, 0)
	H.adjustOxyLoss(-2, 0)
	H.adjustToxLoss(-2, 0)
	H.adjustOrganLoss(ORGAN_SLOT_BRAIN, -3)
	H.adjustCloneLoss(-3, 0)
