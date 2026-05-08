/// Hides the penis sprite while a chastity device is blocking front access.
/// Covers all penis morphologies — normal cock, sheaths (SHEATH_TYPE_NORMAL), and genital slits
/// (SHEATH_TYPE_SLIT) — all blocked by the same cage/full/penis-blocked traits since they are all
/// penis-type anatomy. Cursed modes 1 and 3 expose front access regardless.
/// Falls through to the upstream visibility check (underwear, HIDEJUMPSUIT, HIDECROTCH) if not blocked.
/datum/sprite_accessory/penis/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/chastity/device = owner?.chastity_device
	if(device)
		if(device.chastity_cursed)
			// Cursed modes 1 and 3 expose penis/sheath/slit access.
			if(!(device.cursed_front_mode == 1 || device.cursed_front_mode == 3))
				return FALSE
		else
			if(HAS_TRAIT(owner, TRAIT_CHASTITY_FULL) || HAS_TRAIT(owner, TRAIT_CHASTITY_CAGE) || HAS_TRAIT(owner, TRAIT_CHASTITY_PENIS_BLOCKED))
				return FALSE
	else
		if(HAS_TRAIT(owner, TRAIT_CHASTITY_FULL) || HAS_TRAIT(owner, TRAIT_CHASTITY_CAGE) || HAS_TRAIT(owner, TRAIT_CHASTITY_PENIS_BLOCKED))
			return FALSE
	if(owner.sexcon && owner.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(owner.underwear)
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDECROTCH)

/// Reorders testicle layers when a cage-type device is worn so they sit beneath the cage overlay.
/// Upstream adjust_appearance_list handles the generic offset; this fires after and only adjusts layers
/// when the wearer's device has a cage sprite that intentionally shows the sack through the bars.
/datum/sprite_accessory/testicles/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT, OFFSET_BELT_F)
	if(!chastity_shows_testicles(owner))
		return

	// Keep exposed testicles under cage/flat-cage overlays while still above body base.
	for(var/mutable_appearance/appearance as anything in appearance_list)
		appearance.layer = min(appearance.layer, -44.6)

/// Returns TRUE if the wearer's chastity device has a cage or flat-cage sprite that renders the sack visible.
/// Used to gate both layer reordering in adjust_appearance_list and the is_visible cage-blocked exception.
/datum/sprite_accessory/testicles/proc/chastity_shows_testicles(mob/living/carbon/owner)
	var/obj/item/chastity/device = owner?.chastity_device
	if(!device)
		return FALSE
	return (device.sprite_acc == /datum/sprite_accessory/chastity/cage) || (device.sprite_acc == /datum/sprite_accessory/chastity/flat)

/datum/sprite_accessory/testicles/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/penis/pp = owner.getorganslot(ORGAN_SLOT_PENIS)
	if(pp && pp.sheath_type == SHEATH_TYPE_SLIT)
		return FALSE
	if(HAS_TRAIT(owner, TRAIT_CHASTITY_FULL))
		return FALSE
	if((HAS_TRAIT(owner, TRAIT_CHASTITY_CAGE) || HAS_TRAIT(owner, TRAIT_CHASTITY_PENIS_BLOCKED)) && !chastity_shows_testicles(owner))
		return FALSE
	if(owner.sexcon && owner.sexcon.bottom_exposed == TRUE)
		return TRUE
	if(owner.underwear)
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDECROTCH)

/// Hides the vagina sprite while a chastity device is blocking front access.
/// Respects cursed mode: modes 2 and 3 expose the vagina regardless of the device being worn.
/// Falls through to the upstream visibility check (underwear, HIDECROTCH, HIDEJUMPSUIT) if not blocked.
/datum/sprite_accessory/vagina/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/chastity/device = owner?.chastity_device
	if(device)
		if(device.chastity_cursed)
			// Cursed mode 2 and 3 expose vagina access.
			if(!(device.cursed_front_mode == 2 || device.cursed_front_mode == 3))
				return FALSE
		else
			if(HAS_TRAIT(owner, TRAIT_CHASTITY_FULL) || HAS_TRAIT(owner, TRAIT_CHASTITY_VAGINA_BLOCKED))
				return FALSE
	else
		if(HAS_TRAIT(owner, TRAIT_CHASTITY_FULL) || HAS_TRAIT(owner, TRAIT_CHASTITY_VAGINA_BLOCKED))
			return FALSE
	if(owner.underwear)
		return FALSE
	return is_human_part_visible(owner, HIDECROTCH|HIDEJUMPSUIT)
