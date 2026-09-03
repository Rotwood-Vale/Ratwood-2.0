/datum/bodypart_feature/hair
	var/hair_color = "#FFFFFF"
	var/natural_gradient = /datum/hair_gradient/none
	var/natural_color = "#FFFFFF"
	var/hair_dye_gradient = /datum/hair_gradient/none
	var/hair_dye_color = "#FFFFFF"

/datum/bodypart_feature/hair/bodypart_overlays(mutable_appearance/standing)
	add_gradient_overlay(standing, natural_gradient, natural_color)
	add_gradient_overlay(standing, hair_dye_gradient, hair_dye_color)

/datum/bodypart_feature/hair/proc/add_gradient_overlay(mutable_appearance/standing, gradient_type, gradient_color)
	if(gradient_type == /datum/hair_gradient/none || isnull(gradient_type))
		return
	var/datum/hair_gradient/gradient = HAIR_GRADIENT(gradient_type)
	var/icon/temp = icon(gradient.icon, gradient.icon_state)
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	var/icon/temp_hair = icon(accessory.icon, accessory.icon_state)
	temp.Blend(temp_hair, ICON_ADD)
	var/mutable_appearance/gradient_appearance = mutable_appearance(temp)
	gradient_appearance.color = gradient_color
	standing.overlays += gradient_appearance

/datum/bodypart_feature/hair/head
	name = "Hair"
	feature_slot = BODYPART_FEATURE_HAIR
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/hair/facial
	name = "Facial Hair"
	feature_slot = BODYPART_FEATURE_FACIAL_HAIR
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/face_detail
	name = "Face Detail"
	feature_slot = BODYPART_FEATURE_FACE_DETAIL
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/accessory
	name = "Accessory"
	feature_slot = BODYPART_FEATURE_ACCESSORY
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/crest
	name = "Crest"
	feature_slot = BODYPART_FEATURE_CREST
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/underwear
	name = "Underwear"
	feature_slot = BODYPART_FEATURE_UNDERWEAR
	body_zone = BODY_ZONE_CHEST
	var/obj/item/undies/underwear_item

/datum/bodypart_feature/underwear/set_accessory_type(new_accessory_type, colors, mob/living/carbon/owner)
	accessory_type = new_accessory_type
	var/datum/sprite_accessory/underwear/accessory = SPRITE_ACCESSORY(accessory_type)
	if(!isnull(colors))
		accessory_colors = colors
	else
		accessory_colors = accessory.get_default_colors(color_key_source_list_from_carbon(owner))
	accessory_colors = accessory.validate_color_keys_for_owner(owner, colors)
	underwear_item = new accessory.underwear_type(owner)
	if(owner.underwear)
		qdel(owner.underwear)
	owner.underwear = underwear_item
	underwear_item.undies_feature = src
	underwear_item.color = accessory_colors

/datum/bodypart_feature/legwear
	name = "Legwear"
	feature_slot = BODYPART_FEATURE_LEGWEAR
	body_zone = BODY_ZONE_CHEST
	var/obj/item/legwears/legwear_item

/datum/bodypart_feature/legwear/set_accessory_type(new_accessory_type, colors, mob/living/carbon/owner)
	accessory_type = new_accessory_type
	var/datum/sprite_accessory/legwear/accessory = SPRITE_ACCESSORY(accessory_type)
	if(!isnull(colors))
		accessory_colors = colors
	else
		accessory_colors = accessory.get_default_colors(color_key_source_list_from_carbon(owner))
	accessory_colors = accessory.validate_color_keys_for_owner(owner, colors)
	legwear_item = new accessory.legwear_type(owner)
	if(owner.legwear_socks)
		qdel(owner.legwear_socks)
	owner.legwear_socks = legwear_item
	legwear_item.legwears_feature = src
	legwear_item.color = accessory_colors

/datum/bodypart_feature/chastity
	name = "Chastity"
	feature_slot = BODYPART_FEATURE_CHASTITY
	body_zone = BODY_ZONE_CHEST
	var/obj/item/chastity/chastity_item

/datum/bodypart_feature/chastity/set_accessory_type(new_accessory_type, colors, mob/living/carbon/owner)
	. = ..()
	if(!chastity_item)
		var/datum/sprite_accessory/chastity/accessory = SPRITE_ACCESSORY(accessory_type)
		chastity_item = new accessory.chastity_type(owner)
	if(owner.chastity_device && owner.chastity_device != chastity_item)
		QDEL_NULL(owner.chastity_device)
	owner.chastity_device = chastity_item
	chastity_item.chastity_feature = src
	chastity_item.color = accessory_colors

/datum/bodypart_feature/pubes
	name = "Pubic Hair"
	feature_slot = BODYPART_FEATURE_PUBES
	body_zone = BODY_ZONE_CHEST
	var/material = BODY_HAIR_MATERIAL_HAIR

/datum/bodypart_feature/pubes/proc/set_material(new_material)
	material = sanitize_integer(
		new_material,
		BODY_HAIR_MATERIAL_HAIR,
		BODY_HAIR_MATERIAL_BRAIDS,
		BODY_HAIR_MATERIAL_HAIR,
	)
	switch(material)
		if(BODY_HAIR_MATERIAL_FUR)
			name = "Pubic Fur"
		if(BODY_HAIR_MATERIAL_FEATHERS)
			name = "Pubic Feathers"
		if(BODY_HAIR_MATERIAL_FUZZ)
			name = "Pubic Fuzz"
		if(BODY_HAIR_MATERIAL_BRAIDS)
			name = "Pubic Braids"
		else
			name = "Pubic Hair"
	return material

/datum/bodypart_feature/pubes/proc/get_description_name()
	switch(material)
		if(BODY_HAIR_MATERIAL_FUR)
			return "pubic fur"
		if(BODY_HAIR_MATERIAL_FEATHERS)
			return "pubic feathers"
		if(BODY_HAIR_MATERIAL_FUZZ)
			return "pubic fuzz"
		if(BODY_HAIR_MATERIAL_BRAIDS)
			return "pubic braids"
	return "pubic hair"

/datum/bodypart_feature/pits
	name = "Armpit Hair"
	feature_slot = BODYPART_FEATURE_PITS
	body_zone = BODY_ZONE_CHEST
	var/material = BODY_HAIR_MATERIAL_HAIR

/datum/bodypart_feature/pits/proc/set_material(new_material)
	material = sanitize_integer(
		new_material,
		BODY_HAIR_MATERIAL_HAIR,
		BODY_HAIR_MATERIAL_BRAIDS,
		BODY_HAIR_MATERIAL_HAIR,
	)
	switch(material)
		if(BODY_HAIR_MATERIAL_FUR)
			name = "Armpit Fur"
		if(BODY_HAIR_MATERIAL_FEATHERS)
			name = "Armpit Feathers"
		if(BODY_HAIR_MATERIAL_FUZZ)
			name = "Armpit Fuzz"
		if(BODY_HAIR_MATERIAL_BRAIDS)
			name = "Armpit Braids"
		else
			name = "Armpit Hair"
	return material

/datum/bodypart_feature/pits/proc/get_description_name()
	switch(material)
		if(BODY_HAIR_MATERIAL_FUR)
			return "armpit fur"
		if(BODY_HAIR_MATERIAL_FEATHERS)
			return "armpit feathers"
		if(BODY_HAIR_MATERIAL_FUZZ)
			return "armpit fuzz"
		if(BODY_HAIR_MATERIAL_BRAIDS)
			return "armpit braids"
	return "armpit hair"
