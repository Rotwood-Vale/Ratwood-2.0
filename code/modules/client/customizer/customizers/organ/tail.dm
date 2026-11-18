/datum/customizer/organ/tail
	name = "Tail"
	abstract_type = /datum/customizer/organ/tail

/datum/customizer_choice/organ/tail
	name = "Tail"
	organ_type = /obj/item/organ/tail
	organ_slot = ORGAN_SLOT_TAIL
	organ_dna_type = /datum/organ_dna/tail
	customizer_entry_type = /datum/customizer_entry/organ/tail
	abstract_type = /datum/customizer_choice/organ/tail

/datum/customizer_choice/organ/tail/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	if(entry.accessory_type == /datum/sprite_accessory/tail/manticore)
		organ_dna.organ_type = /obj/item/organ/tail/manticore
	var/datum/organ_dna/tail/tail_dna = organ_dna
	var/datum/customizer_entry/organ/tail/tail_entry = entry
	tail_dna.fertility = tail_entry.fertility
	tail_dna.tailmaw_fluid = (tail_entry.tailmaw_fluid in GLOB.tailmaw_fluid_options) ? tail_entry.tailmaw_fluid : "Default"

/datum/customizer_entry/organ/tail
	var/fertility = TRUE
	var/tailmaw_fluid = "Default"

/datum/customizer_choice/organ/tail/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/tail/tail_entry = entry
	if(!(tail_entry.tailmaw_fluid in GLOB.tailmaw_fluid_options))
		tail_entry.tailmaw_fluid = "Default"

/datum/customizer_choice/organ/tail/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	if(organ_type != /obj/item/organ/tail/manticore && entry.accessory_type != /datum/sprite_accessory/tail/manticore)
		return
	var/datum/customizer_entry/organ/tail/tail_entry = entry
	dat += "<br>Fertile: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=fertile'>[tail_entry.fertility ? "Fertile" : "Sterile"]</a>"
	dat += "<br>Fluid: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=fluid'>[tail_entry.tailmaw_fluid]</a>"

/datum/customizer_choice/organ/tail/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	if(organ_type != /obj/item/organ/tail/manticore && entry.accessory_type != /datum/sprite_accessory/tail/manticore)
		return
	var/datum/customizer_entry/organ/tail/tail_entry = entry
	switch(href_list["customizer_task"])
		if("fertile")
			tail_entry.fertility = !tail_entry.fertility
		if("fluid")
			var/editing_slot = prefs.default_slot
			var/old_choice = entry.customizer_choice_type
			var/old_fluid = tail_entry.tailmaw_fluid
			var/choice = tgui_input_list(user, "Choose your tailmaw's fluid.", "Tailmaw Fluid", GLOB.tailmaw_fluid_options, old_fluid)
			if(!(choice in GLOB.tailmaw_fluid_options) || !user || user.client != prefs.parent || prefs.default_slot != editing_slot || prefs.get_customizer_entry_for_customizer_type(customizer_type) != entry || entry.customizer_choice_type != old_choice || tail_entry.tailmaw_fluid != old_fluid)
				return
			tail_entry.tailmaw_fluid = choice

/datum/customizer/organ/tail/vulpkanin
	customizer_choices = list(/datum/customizer_choice/organ/tail/vulpkanin)

/datum/customizer_choice/organ/tail/vulpkanin
	name = "Vulpkian Tail"
	organ_type = /obj/item/organ/tail/vulpkanin
	sprite_accessories = list(
		/datum/sprite_accessory/tail/fox,
		/datum/sprite_accessory/tail/fox2,
		/datum/sprite_accessory/tail/eevee,
		/datum/sprite_accessory/tail/fennec,
		/datum/sprite_accessory/tail/jackal,
		/datum/sprite_accessory/tail/tamamo_kitsune
		)

/datum/customizer/organ/tail/lupian
	customizer_choices = list(/datum/customizer_choice/organ/tail/lupian)

/datum/customizer_choice/organ/tail/lupian
	name = "Lupian Tail"
	organ_type = /obj/item/organ/tail/lupian
	sprite_accessories = list(
		/datum/sprite_accessory/tail/otie,
		/datum/sprite_accessory/tail/shepherd,
		/datum/sprite_accessory/tail/australian_shepherd,
		/datum/sprite_accessory/tail/jackal,
		/datum/sprite_accessory/tail/wolf,
		/datum/sprite_accessory/tail/fox,
		/datum/sprite_accessory/tail/fox2,
		/datum/sprite_accessory/tail/husky
		)

/datum/customizer/organ/tail/tabaxi
	customizer_choices = list(/datum/customizer_choice/organ/tail/tabaxi)

/datum/customizer_choice/organ/tail/tabaxi
	name = "Tabaxi Tail"
	organ_type = /obj/item/organ/tail/cat
	sprite_accessories = list(
		/datum/sprite_accessory/tail/catbig,
		/datum/sprite_accessory/tail/cat,
		/datum/sprite_accessory/tail/tiger,
		/datum/sprite_accessory/tail/leopard,
		/datum/sprite_accessory/tail/lynx,
		)

/datum/customizer/organ/tail/lizard
	customizer_choices = list(/datum/customizer_choice/organ/tail/lizard)

/datum/customizer_choice/organ/tail/lizard
	name = "Sissean Tail"
	organ_type = /obj/item/organ/tail/lizard
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/lizard/smooth,
		/datum/sprite_accessory/tail/lizard/dtiger,
		/datum/sprite_accessory/tail/lizard/ltiger,
		/datum/sprite_accessory/tail/lizard/spikes,
		/datum/sprite_accessory/tail/cat,
		/datum/sprite_accessory/tail/monkey,
		/datum/sprite_accessory/tail/axolotl,
		/datum/sprite_accessory/tail/batl,
		/datum/sprite_accessory/tail/bats,
		/datum/sprite_accessory/tail/bee,
		/datum/sprite_accessory/tail/catbig,
		/datum/sprite_accessory/tail/twocat,
		/datum/sprite_accessory/tail/corvid,
		/datum/sprite_accessory/tail/cow,
		/datum/sprite_accessory/tail/data_shark,
		/datum/sprite_accessory/tail/eevee,
		/datum/sprite_accessory/tail/fennec,
		/datum/sprite_accessory/tail/fish,
		/datum/sprite_accessory/tail/fox,
		/datum/sprite_accessory/tail/fox2,
		/datum/sprite_accessory/tail/hawk,
		/datum/sprite_accessory/tail/horse,
		/datum/sprite_accessory/tail/husky,
		/datum/sprite_accessory/tail/insect,
		/datum/sprite_accessory/tail/kangaroo,
		/datum/sprite_accessory/tail/kitsune,
		/datum/sprite_accessory/tail/lab,
		/datum/sprite_accessory/tail/murid,
		/datum/sprite_accessory/tail/orca,
		/datum/sprite_accessory/tail/otie,
		/datum/sprite_accessory/tail/rabbit,
		/datum/sprite_accessory/tail/redpanda,
		/datum/sprite_accessory/tail/pede,
		/datum/sprite_accessory/tail/sergal,
		/datum/sprite_accessory/tail/shark,
		/datum/sprite_accessory/tail/shepherd,
		/datum/sprite_accessory/tail/australian_shepherd,
		/datum/sprite_accessory/tail/jackal,
		/datum/sprite_accessory/tail/skunk,
		/datum/sprite_accessory/tail/stripe,
		/datum/sprite_accessory/tail/straighttail,
		/datum/sprite_accessory/tail/squirrel,
		/datum/sprite_accessory/tail/tamamo_kitsune,
		/datum/sprite_accessory/tail/tentacle,
		/datum/sprite_accessory/tail/tiger,
		/datum/sprite_accessory/tail/wolf,
		/datum/sprite_accessory/tail/guilmon,
		/datum/sprite_accessory/tail/sharknofin,
		/datum/sprite_accessory/tail/raptor,
		/datum/sprite_accessory/tail/lunasune,
		/datum/sprite_accessory/tail/spade,
		/datum/sprite_accessory/tail/leopard,
		/datum/sprite_accessory/tail/deer,
		/datum/sprite_accessory/tail/raccoon,
		/datum/sprite_accessory/tail/sabresune,
		/datum/sprite_accessory/tail/rattlesnake,
		/datum/sprite_accessory/tail/lynx,
		/datum/sprite_accessory/tail/pinecone,
		/datum/sprite_accessory/tail/manticore,
		/datum/sprite_accessory/tail/large_snake,
		/datum/sprite_accessory/tail/large_snake_plain
	)

/datum/customizer/organ/tail/axian
	customizer_choices = list(/datum/customizer_choice/organ/tail/axian)

/datum/customizer_choice/organ/tail/axian
	name = "Axian Tail"
	organ_type = /obj/item/organ/tail/akula
	sprite_accessories = list(
		/datum/sprite_accessory/tail/shark,
		/datum/sprite_accessory/tail/sharknofin,
		)

/datum/customizer/organ/tail/tiefling
	customizer_choices = list(/datum/customizer_choice/organ/tail/tiefling)
	allows_disabling = TRUE

/datum/customizer/organ/tail/dullahan
	customizer_choices = list(/datum/customizer_choice/organ/tail/dullahan)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/tail/dullahan
	name = "Dullahan Tail"
	organ_type = /obj/item/organ/tail/dullahan
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/dullahan,
		/datum/sprite_accessory/tail/dullahan/heart,
		/datum/sprite_accessory/tail/cat,
		/datum/sprite_accessory/tail/monkey,
		/datum/sprite_accessory/tail/axolotl,
		/datum/sprite_accessory/tail/batl,
		/datum/sprite_accessory/tail/bats,
		/datum/sprite_accessory/tail/bee,
		/datum/sprite_accessory/tail/catbig,
		/datum/sprite_accessory/tail/twocat,
		/datum/sprite_accessory/tail/corvid,
		/datum/sprite_accessory/tail/cow,
		/datum/sprite_accessory/tail/data_shark,
		/datum/sprite_accessory/tail/eevee,
		/datum/sprite_accessory/tail/fennec,
		/datum/sprite_accessory/tail/fish,
		/datum/sprite_accessory/tail/fox,
		/datum/sprite_accessory/tail/fox2,
		/datum/sprite_accessory/tail/hawk,
		/datum/sprite_accessory/tail/horse,
		/datum/sprite_accessory/tail/husky,
		/datum/sprite_accessory/tail/insect,
		/datum/sprite_accessory/tail/kangaroo,
		/datum/sprite_accessory/tail/kitsune,
		/datum/sprite_accessory/tail/lab,
		/datum/sprite_accessory/tail/murid,
		/datum/sprite_accessory/tail/orca,
		/datum/sprite_accessory/tail/otie,
		/datum/sprite_accessory/tail/rabbit,
		/datum/sprite_accessory/tail/redpanda,
		/datum/sprite_accessory/tail/pede,
		/datum/sprite_accessory/tail/sergal,
		/datum/sprite_accessory/tail/shark,
		/datum/sprite_accessory/tail/shepherd,
		/datum/sprite_accessory/tail/australian_shepherd,
		/datum/sprite_accessory/tail/jackal,
		/datum/sprite_accessory/tail/skunk,
		/datum/sprite_accessory/tail/stripe,
		/datum/sprite_accessory/tail/straighttail,
		/datum/sprite_accessory/tail/squirrel,
		/datum/sprite_accessory/tail/tamamo_kitsune,
		/datum/sprite_accessory/tail/tentacle,
		/datum/sprite_accessory/tail/tiger,
		/datum/sprite_accessory/tail/wolf,
		/datum/sprite_accessory/tail/guilmon,
		/datum/sprite_accessory/tail/sharknofin,
		/datum/sprite_accessory/tail/raptor,
		/datum/sprite_accessory/tail/leopard,
		/datum/sprite_accessory/tail/deer,
		/datum/sprite_accessory/tail/raccoon,
		/datum/sprite_accessory/tail/sabresune,
		/datum/sprite_accessory/tail/lizard/smooth,
		/datum/sprite_accessory/tail/lizard/dtiger,
		/datum/sprite_accessory/tail/lizard/ltiger,
		/datum/sprite_accessory/tail/lizard/spikes,
		/datum/sprite_accessory/tail/rattlesnake,
		/datum/sprite_accessory/tail/lynx,
		/datum/sprite_accessory/tail/pinecone,
		/datum/sprite_accessory/tail/scorpian,
		/datum/sprite_accessory/tail/manticore,
		/datum/sprite_accessory/tail/tailmaw,
		/datum/sprite_accessory/tail/tailmaw2,
		/datum/sprite_accessory/tail/tailmaw2_head,
		/datum/sprite_accessory/tail/tailmaw2_stripes,
		/datum/sprite_accessory/tail/tailmaw2_headstripes
		)
	allows_accessory_color_customization = TRUE

/datum/customizer_choice/organ/tail/tiefling
	name = "Tiefling Tail"
	organ_type = /obj/item/organ/tail/tiefling
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/tiefling,
		/datum/sprite_accessory/tail/tiefling/heart,
		/datum/sprite_accessory/tail/tiefling/spade
		)
	allows_accessory_color_customization = TRUE

/datum/customizer/organ/tail/demihuman
	customizer_choices = list(/datum/customizer_choice/organ/tail/demihuman)
	allows_disabling = TRUE

/datum/customizer_choice/organ/tail/demihuman
	name = "Half-Kinhuman Tail"
	organ_type = /obj/item/organ/tail
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/cat,
		/datum/sprite_accessory/tail/monkey,
		/datum/sprite_accessory/tail/axolotl,
		/datum/sprite_accessory/tail/batl,
		/datum/sprite_accessory/tail/bats,
		/datum/sprite_accessory/tail/bee,
		/datum/sprite_accessory/tail/catbig,
		/datum/sprite_accessory/tail/twocat,
		/datum/sprite_accessory/tail/corvid,
		/datum/sprite_accessory/tail/cow,
		/datum/sprite_accessory/tail/data_shark,
		/datum/sprite_accessory/tail/eevee,
		/datum/sprite_accessory/tail/fennec,
		/datum/sprite_accessory/tail/fish,
		/datum/sprite_accessory/tail/fox,
		/datum/sprite_accessory/tail/fox2,
		/datum/sprite_accessory/tail/hawk,
		/datum/sprite_accessory/tail/horse,
		/datum/sprite_accessory/tail/husky,
		/datum/sprite_accessory/tail/insect,
		/datum/sprite_accessory/tail/kangaroo,
		/datum/sprite_accessory/tail/kitsune,
		/datum/sprite_accessory/tail/lab,
		/datum/sprite_accessory/tail/murid,
		/datum/sprite_accessory/tail/orca,
		/datum/sprite_accessory/tail/otie,
		/datum/sprite_accessory/tail/rabbit,
		/datum/sprite_accessory/tail/redpanda,
		/datum/sprite_accessory/tail/pede,
		/datum/sprite_accessory/tail/sergal,
		/datum/sprite_accessory/tail/shark,
		/datum/sprite_accessory/tail/shepherd,
		/datum/sprite_accessory/tail/australian_shepherd,
		/datum/sprite_accessory/tail/jackal,
		/datum/sprite_accessory/tail/skunk,
		/datum/sprite_accessory/tail/stripe,
		/datum/sprite_accessory/tail/straighttail,
		/datum/sprite_accessory/tail/squirrel,
		/datum/sprite_accessory/tail/tamamo_kitsune,
		/datum/sprite_accessory/tail/tentacle,
		/datum/sprite_accessory/tail/tiger,
		/datum/sprite_accessory/tail/wolf,
		/datum/sprite_accessory/tail/guilmon,
		/datum/sprite_accessory/tail/sharknofin,
		/datum/sprite_accessory/tail/raptor,
		/datum/sprite_accessory/tail/spade,
		/datum/sprite_accessory/tail/leopard,
		/datum/sprite_accessory/tail/deer,
		/datum/sprite_accessory/tail/raccoon,
		/datum/sprite_accessory/tail/sabresune,
		/datum/sprite_accessory/tail/lizard/smooth,
		/datum/sprite_accessory/tail/lizard/dtiger,
		/datum/sprite_accessory/tail/lizard/ltiger,
		/datum/sprite_accessory/tail/lizard/spikes,
		/datum/sprite_accessory/tail/rattlesnake,
		/datum/sprite_accessory/tail/lynx,
		/datum/sprite_accessory/tail/owl,
		/datum/sprite_accessory/tail/pinecone,
		/datum/sprite_accessory/tail/forked_long,
		/datum/sprite_accessory/tail/haven,
		/datum/sprite_accessory/tail/swallow,
		/datum/sprite_accessory/tail/zorzor,
		/datum/sprite_accessory/tail/manticore,
		/datum/sprite_accessory/tail/scorpian,
		/datum/sprite_accessory/tail/large_snake,
		/datum/sprite_accessory/tail/large_snake_plain,
		/datum/sprite_accessory/tail/tailmaw,
		/datum/sprite_accessory/tail/tailmaw2,
		/datum/sprite_accessory/tail/tailmaw2_head,
		/datum/sprite_accessory/tail/tailmaw2_stripes,
		/datum/sprite_accessory/tail/tailmaw2_headstripes
		)

/datum/customizer/organ/tail/anthro
	customizer_choices = list(/datum/customizer_choice/organ/tail/anthro)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/tail/anthro
	name = "Wild-Kin Tail"
	organ_type = /obj/item/organ/tail/anthro
	sprite_accessories = list(
		/datum/sprite_accessory/tail/cat,
		/datum/sprite_accessory/tail/monkey,
		/datum/sprite_accessory/tail/axolotl,
		/datum/sprite_accessory/tail/batl,
		/datum/sprite_accessory/tail/bats,
		/datum/sprite_accessory/tail/bee,
		/datum/sprite_accessory/tail/catbig,
		/datum/sprite_accessory/tail/twocat,
		/datum/sprite_accessory/tail/corvid,
		/datum/sprite_accessory/tail/cow,
		/datum/sprite_accessory/tail/data_shark,
		/datum/sprite_accessory/tail/eevee,
		/datum/sprite_accessory/tail/fennec,
		/datum/sprite_accessory/tail/fish,
		/datum/sprite_accessory/tail/fox,
		/datum/sprite_accessory/tail/fox2,
		/datum/sprite_accessory/tail/hawk,
		/datum/sprite_accessory/tail/horse,
		/datum/sprite_accessory/tail/husky,
		/datum/sprite_accessory/tail/insect,
		/datum/sprite_accessory/tail/kangaroo,
		/datum/sprite_accessory/tail/kitsune,
		/datum/sprite_accessory/tail/lab,
		/datum/sprite_accessory/tail/murid,
		/datum/sprite_accessory/tail/orca,
		/datum/sprite_accessory/tail/otie,
		/datum/sprite_accessory/tail/rabbit,
		/datum/sprite_accessory/tail/redpanda,
		/datum/sprite_accessory/tail/pede,
		/datum/sprite_accessory/tail/sergal,
		/datum/sprite_accessory/tail/shark,
		/datum/sprite_accessory/tail/shepherd,
		/datum/sprite_accessory/tail/australian_shepherd,
		/datum/sprite_accessory/tail/jackal,
		/datum/sprite_accessory/tail/skunk,
		/datum/sprite_accessory/tail/stripe,
		/datum/sprite_accessory/tail/straighttail,
		/datum/sprite_accessory/tail/squirrel,
		/datum/sprite_accessory/tail/tamamo_kitsune,
		/datum/sprite_accessory/tail/tentacle,
		/datum/sprite_accessory/tail/tiger,
		/datum/sprite_accessory/tail/wolf,
		/datum/sprite_accessory/tail/guilmon,
		/datum/sprite_accessory/tail/sharknofin,
		/datum/sprite_accessory/tail/raptor,
		/datum/sprite_accessory/tail/lunasune,
		/datum/sprite_accessory/tail/spade,
		/datum/sprite_accessory/tail/leopard,
		/datum/sprite_accessory/tail/deer,
		/datum/sprite_accessory/tail/raccoon,
		/datum/sprite_accessory/tail/sabresune,
		/datum/sprite_accessory/tail/lizard/smooth,
		/datum/sprite_accessory/tail/lizard/dtiger,
		/datum/sprite_accessory/tail/lizard/ltiger,
		/datum/sprite_accessory/tail/lizard/spikes,
		/datum/sprite_accessory/tail/rattlesnake,
		/datum/sprite_accessory/tail/lynx,
		/datum/sprite_accessory/tail/owl,
		/datum/sprite_accessory/tail/pinecone,
		/datum/sprite_accessory/tail/forked_long,
		/datum/sprite_accessory/tail/haven,
		/datum/sprite_accessory/tail/swallow,
		/datum/sprite_accessory/tail/zorzor,
		/datum/sprite_accessory/tail/manticore,
		/datum/sprite_accessory/tail/scorpian,
		/datum/sprite_accessory/tail/large_snake,
		/datum/sprite_accessory/tail/large_snake_plain,
		/datum/sprite_accessory/tail/largestriped,
		/datum/sprite_accessory/tail/tailmaw,
		/datum/sprite_accessory/tail/tailmaw2,
		/datum/sprite_accessory/tail/tailmaw2_head,
		/datum/sprite_accessory/tail/tailmaw2_stripes,
		/datum/sprite_accessory/tail/tailmaw2_headstripes,
		/datum/sprite_accessory/tail/shadekin,
		/datum/sprite_accessory/tail/shadekin/short,
		)

/datum/customizer/organ/tail/dullahan
	customizer_choices = list(/datum/customizer_choice/organ/tail/dullahan)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/tail/dullahan
	name = "Revenant Tail"
	organ_type = /obj/item/organ/tail/dullahan
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/dullahan,
		/datum/sprite_accessory/tail/dullahan/heart,
		/datum/sprite_accessory/tail/cat,
		/datum/sprite_accessory/tail/monkey,
		/datum/sprite_accessory/tail/axolotl,
		/datum/sprite_accessory/tail/batl,
		/datum/sprite_accessory/tail/bats,
		/datum/sprite_accessory/tail/bee,
		/datum/sprite_accessory/tail/catbig,
		/datum/sprite_accessory/tail/twocat,
		/datum/sprite_accessory/tail/corvid,
		/datum/sprite_accessory/tail/cow,
		/datum/sprite_accessory/tail/data_shark,
		/datum/sprite_accessory/tail/eevee,
		/datum/sprite_accessory/tail/fennec,
		/datum/sprite_accessory/tail/fish,
		/datum/sprite_accessory/tail/fox,
		/datum/sprite_accessory/tail/fox2,
		/datum/sprite_accessory/tail/hawk,
		/datum/sprite_accessory/tail/horse,
		/datum/sprite_accessory/tail/husky,
		/datum/sprite_accessory/tail/insect,
		/datum/sprite_accessory/tail/kangaroo,
		/datum/sprite_accessory/tail/kitsune,
		/datum/sprite_accessory/tail/lab,
		/datum/sprite_accessory/tail/murid,
		/datum/sprite_accessory/tail/orca,
		/datum/sprite_accessory/tail/otie,
		/datum/sprite_accessory/tail/rabbit,
		/datum/sprite_accessory/tail/redpanda,
		/datum/sprite_accessory/tail/pede,
		/datum/sprite_accessory/tail/sergal,
		/datum/sprite_accessory/tail/shark,
		/datum/sprite_accessory/tail/shepherd,
		/datum/sprite_accessory/tail/australian_shepherd,
		/datum/sprite_accessory/tail/jackal,
		/datum/sprite_accessory/tail/skunk,
		/datum/sprite_accessory/tail/stripe,
		/datum/sprite_accessory/tail/straighttail,
		/datum/sprite_accessory/tail/squirrel,
		/datum/sprite_accessory/tail/tamamo_kitsune,
		/datum/sprite_accessory/tail/tentacle,
		/datum/sprite_accessory/tail/tiger,
		/datum/sprite_accessory/tail/wolf,
		/datum/sprite_accessory/tail/guilmon,
		/datum/sprite_accessory/tail/sharknofin,
		/datum/sprite_accessory/tail/raptor,
		/datum/sprite_accessory/tail/leopard,
		/datum/sprite_accessory/tail/deer,
		/datum/sprite_accessory/tail/raccoon,
		/datum/sprite_accessory/tail/sabresune,
		/datum/sprite_accessory/tail/lizard/smooth,
		/datum/sprite_accessory/tail/lizard/dtiger,
		/datum/sprite_accessory/tail/lizard/ltiger,
		/datum/sprite_accessory/tail/lizard/spikes,
		/datum/sprite_accessory/tail/rattlesnake,
		/datum/sprite_accessory/tail/manticore,
		/datum/sprite_accessory/tail/scorpian,
		/datum/sprite_accessory/tail/lynx,
		/datum/sprite_accessory/tail/tailmaw,
		/datum/sprite_accessory/tail/tailmaw2,
		/datum/sprite_accessory/tail/tailmaw2_head,
		/datum/sprite_accessory/tail/tailmaw2_stripes,
		/datum/sprite_accessory/tail/tailmaw2_headstripes,
		/datum/sprite_accessory/tail/lunasune,
		/datum/sprite_accessory/tail/spade,
		/datum/sprite_accessory/tail/owl,
		/datum/sprite_accessory/tail/pinecone,
		/datum/sprite_accessory/tail/forked_long,
		/datum/sprite_accessory/tail/haven,
		/datum/sprite_accessory/tail/swallow,
		/datum/sprite_accessory/tail/zorzor,
		/datum/sprite_accessory/tail/large_snake,
		/datum/sprite_accessory/tail/large_snake_plain,
		/datum/sprite_accessory/tail/largestriped,
		/datum/sprite_accessory/tail/shadekin,
		/datum/sprite_accessory/tail/shadekin/short,
	)
	allows_accessory_color_customization = TRUE

/datum/customizer/organ/tail/harpy
	name = "Harpy Plumage"
	customizer_choices = list(/datum/customizer_choice/organ/tail/harpy)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/tail/harpy
	name = "Harpy Plumage"
	organ_type = /obj/item/organ/tail/harpy
	generic_random_pick = TRUE
	sprite_accessories = list(
		/datum/sprite_accessory/tail/corvid,
		/datum/sprite_accessory/tail/hawk,
		/datum/sprite_accessory/tail/owl,
		/datum/sprite_accessory/tail/forked_long,
		/datum/sprite_accessory/tail/haven,
		/datum/sprite_accessory/tail/swallow,
		/datum/sprite_accessory/tail/pinecone
	)

/datum/customizer/organ/tail/manticore
	name = "Tail Maw"
	customizer_choices = list(/datum/customizer_choice/organ/tail/manticore)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/tail/manticore
	name = "Manticore Tail"
	organ_type = /obj/item/organ/tail/manticore
	sprite_accessories = list(
		/datum/sprite_accessory/tail/manticore,
		/datum/sprite_accessory/tail/tailmaw/spriteless,
		/datum/sprite_accessory/tail/tailmaw,
		/datum/sprite_accessory/tail/tailmaw2,
		/datum/sprite_accessory/tail/tailmaw2_head,
		/datum/sprite_accessory/tail/tailmaw2_stripes,
		/datum/sprite_accessory/tail/tailmaw2_headstripes,
		/datum/sprite_accessory/tail/tiefling/tailmaw,
		/datum/sprite_accessory/tail/tiefling/heart/tailmaw,
		/datum/sprite_accessory/tail/tiefling/spadeheart/tailmaw,
		/datum/sprite_accessory/tail/tiefling/spade/tailmaw,
	)
	allows_accessory_color_customization = TRUE

/datum/customizer/organ/tail/manticore/lamia
	name = "Tailmaw (No Sprite)"
	customizer_choices = list(/datum/customizer_choice/organ/tail/manticore/lamia)

/datum/customizer_choice/organ/tail/manticore/lamia
	name = "Tailmaw (No Sprite)"
	sprite_accessories = list(/datum/sprite_accessory/tail/tailmaw/spriteless)
	allows_accessory_color_customization = FALSE

/datum/customizer/organ/tail/manticore/tailed
	name = "Tailmaw"

/datum/customizer_choice/organ/tail/manticore/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	if(entry.accessory_type != /datum/sprite_accessory/tail/tailmaw/spriteless)
		return
	organ_dna.organ_type = /obj/item/organ/tail/manticore/spriteless
	var/datum/organ_dna/visual_dna = get_tailmaw_visual_dna(prefs)
	if(visual_dna)
		organ_dna.accessory_type = visual_dna.accessory_type
		organ_dna.accessory_colors = visual_dna.accessory_colors
		qdel(visual_dna)

/// Match the last enabled normal tail entry, as the ordinary organ-DNA pipeline does.
/proc/get_tailmaw_visual_dna(datum/preferences/prefs)
	if(!prefs?.pref_species)
		return null
	var/datum/organ_dna/visual_dna
	for(var/datum/customizer_entry/entry as anything in prefs.customizer_entries)
		if(!istype(entry) || entry.disabled || !ispath(entry.customizer_type, /datum/customizer/organ/tail) || ispath(entry.customizer_type, /datum/customizer/organ/tail/manticore))
			continue
		if(!(entry.customizer_type in prefs.pref_species.customizers))
			continue
		var/datum/customizer_choice/organ/tail/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		if(!istype(choice))
			continue
		QDEL_NULL(visual_dna)
		visual_dna = choice.create_organ_dna(entry, prefs)
	if(visual_dna)
		return visual_dna
	var/obj/item/organ/tail/species_tail = prefs.pref_species.organs?[ORGAN_SLOT_TAIL]
	if(!ispath(species_tail, /obj/item/organ/tail))
		return null
	visual_dna = new /datum/organ_dna/tail()
	visual_dna.organ_type = species_tail
	visual_dna.accessory_type = initial(species_tail.accessory_type)
	visual_dna.accessory_colors = initial(species_tail.accessory_colors)
	if(visual_dna.accessory_type && !visual_dna.accessory_colors)
		var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(visual_dna.accessory_type)
		if(istype(accessory))
			visual_dna.accessory_colors = accessory.get_default_colors(color_key_source_list_from_prefs(prefs))
	return visual_dna
