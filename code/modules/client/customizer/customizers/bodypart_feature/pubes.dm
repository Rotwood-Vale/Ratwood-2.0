GLOBAL_LIST_INIT(named_body_hair_materials, list(
	"Hair" = BODY_HAIR_MATERIAL_HAIR,
	"Fur" = BODY_HAIR_MATERIAL_FUR,
	"Feathers" = BODY_HAIR_MATERIAL_FEATHERS,
	"Fuzz" = BODY_HAIR_MATERIAL_FUZZ,
	"Braids" = BODY_HAIR_MATERIAL_BRAIDS,//rock and stone
))

/datum/customizer_entry/bodypart_feature/pubes
	var/material = BODY_HAIR_MATERIAL_HAIR

/datum/customizer/bodypart_feature/pubes
	name = "Pubes"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/pubes)
	allows_disabling = TRUE
	default_disabled = TRUE
	var/default_material = BODY_HAIR_MATERIAL_HAIR

/datum/customizer/bodypart_feature/pubes/make_default_customizer_entry(datum/preferences/prefs, changed_entry = TRUE)
	var/datum/customizer_entry/bodypart_feature/pubes/entry = ..()
	entry.material = default_material
	return entry

/datum/customizer/bodypart_feature/pubes/furry
	default_material = BODY_HAIR_MATERIAL_FUR

/datum/customizer/bodypart_feature/pubes/feathered
	default_material = BODY_HAIR_MATERIAL_FEATHERS

/datum/customizer/bodypart_feature/pubes/fuzzy
	default_material = BODY_HAIR_MATERIAL_FUZZ

/datum/customizer/bodypart_feature/pubes/braids
	default_material = BODY_HAIR_MATERIAL_BRAIDS

/datum/customizer_choice/bodypart_feature/pubes
	name = "Pubic Style"
	customizer_entry_type = /datum/customizer_entry/bodypart_feature/pubes
	feature_type = /datum/bodypart_feature/pubes
	sprite_accessories = list(
		/datum/sprite_accessory/pubes/hairy,
		/datum/sprite_accessory/pubes/trim,
		/datum/sprite_accessory/pubes/strip,
		/datum/sprite_accessory/pubes/heart,
		/datum/sprite_accessory/pubes/extreme,
		/datum/sprite_accessory/pubes/cross,
	)

/datum/customizer_choice/bodypart_feature/pubes/customize_feature(
	datum/bodypart_feature/feature,
	mob/living/carbon/human/human,
	datum/preferences/prefs,
	datum/customizer_entry/entry,
)
	var/datum/bodypart_feature/pubes/pubes_feature = feature
	var/datum/customizer_entry/bodypart_feature/pubes/pubes_entry = entry
	pubes_feature.set_material(pubes_entry.material)

/datum/customizer_choice/bodypart_feature/pubes/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/bodypart_feature/pubes/pubes_entry = entry
	pubes_entry.material = sanitize_integer(
		pubes_entry.material,
		BODY_HAIR_MATERIAL_HAIR,
		BODY_HAIR_MATERIAL_BRAIDS,
		BODY_HAIR_MATERIAL_HAIR,
	)

/datum/customizer_choice/bodypart_feature/pubes/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/bodypart_feature/pubes/pubes_entry = entry
	var/material_name = find_key_by_value(GLOB.named_body_hair_materials, pubes_entry.material)
	dat += "<br>Material: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=body_hair_material'>[material_name]</a>"

/datum/customizer_choice/bodypart_feature/pubes/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	if(href_list["customizer_task"] != "body_hair_material")
		return
	var/datum/customizer_entry/bodypart_feature/pubes/pubes_entry = entry
	var/named_material = input(
		user,
		"Choose your pubic hair material:",
		"Character Preference",
		find_key_by_value(GLOB.named_body_hair_materials, pubes_entry.material),
	) as null|anything in GLOB.named_body_hair_materials
	if(isnull(named_material))
		return
	pubes_entry.material = sanitize_integer(
		GLOB.named_body_hair_materials[named_material],
		BODY_HAIR_MATERIAL_HAIR,
		BODY_HAIR_MATERIAL_BRAIDS,
		BODY_HAIR_MATERIAL_HAIR,
	)

///pit hair starts here

/datum/customizer_entry/bodypart_feature/pits
	var/material = BODY_HAIR_MATERIAL_HAIR

/datum/customizer/bodypart_feature/pits
	name = "Armpits"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/pits)
	allows_disabling = TRUE
	default_disabled = TRUE
	var/default_material = BODY_HAIR_MATERIAL_HAIR

/datum/customizer/bodypart_feature/pits/make_default_customizer_entry(datum/preferences/prefs, changed_entry = TRUE)
	var/datum/customizer_entry/bodypart_feature/pits/entry = ..()
	entry.material = default_material
	return entry

/datum/customizer/bodypart_feature/pits/furry
	default_material = BODY_HAIR_MATERIAL_FUR

/datum/customizer/bodypart_feature/pits/feathered
	default_material = BODY_HAIR_MATERIAL_FEATHERS

/datum/customizer/bodypart_feature/pits/fuzzy
	default_material = BODY_HAIR_MATERIAL_FUZZ

/datum/customizer/bodypart_feature/pits/braids
	default_material = BODY_HAIR_MATERIAL_BRAIDS

/datum/customizer_choice/bodypart_feature/pits
	name = "Armpit Style"
	customizer_entry_type = /datum/customizer_entry/bodypart_feature/pits
	feature_type = /datum/bodypart_feature/pits
	sprite_accessories = list(
		/datum/sprite_accessory/pits/trim,
		/datum/sprite_accessory/pits/moderate,
		/datum/sprite_accessory/pits/hairy,
		/datum/sprite_accessory/pits/extreme,
		)

/datum/customizer_choice/bodypart_feature/pits/customize_feature(
	datum/bodypart_feature/feature,
	mob/living/carbon/human/human,
	datum/preferences/prefs,
	datum/customizer_entry/entry,
)
	var/datum/bodypart_feature/pits/pits_feature = feature
	var/datum/customizer_entry/bodypart_feature/pits/pits_entry = entry
	pits_feature.set_material(pits_entry.material)

/datum/customizer_choice/bodypart_feature/pits/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/bodypart_feature/pits/pits_entry = entry
	pits_entry.material = sanitize_integer(
		pits_entry.material,
		BODY_HAIR_MATERIAL_HAIR,
		BODY_HAIR_MATERIAL_BRAIDS,
		BODY_HAIR_MATERIAL_HAIR,
	)

/datum/customizer_choice/bodypart_feature/pits/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/bodypart_feature/pits/pits_entry = entry
	var/material_name = find_key_by_value(GLOB.named_body_hair_materials, pits_entry.material)
	dat += "<br>Material: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=body_hair_material'>[material_name]</a>"

/datum/customizer_choice/bodypart_feature/pits/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	if(href_list["customizer_task"] != "body_hair_material")
		return
	var/datum/customizer_entry/bodypart_feature/pits/pits_entry = entry
	var/named_material = input(
		user,
		"Choose your armpit hair material:",
		"Character Preference",
		find_key_by_value(GLOB.named_body_hair_materials, pits_entry.material),
	) as null|anything in GLOB.named_body_hair_materials
	if(isnull(named_material))
		return
	pits_entry.material = sanitize_integer(
		GLOB.named_body_hair_materials[named_material],
		BODY_HAIR_MATERIAL_HAIR,
		BODY_HAIR_MATERIAL_BRAIDS,
		BODY_HAIR_MATERIAL_HAIR,
	)
