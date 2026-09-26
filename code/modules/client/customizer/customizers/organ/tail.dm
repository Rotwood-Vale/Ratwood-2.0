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

/datum/customizer_entry/organ/tail
	var/fertility = TRUE

/datum/customizer_choice/organ/tail/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	if(entry.accessory_type != /datum/sprite_accessory/tail/manticore)
		return
	var/datum/customizer_entry/organ/tail/tail_entry = entry
	dat += "<br>Fertile: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=fertile'>[tail_entry.fertility ? "Fertile" : "Sterile"]</a>"

/datum/customizer_choice/organ/tail/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	if(entry.accessory_type != /datum/sprite_accessory/tail/manticore || href_list["customizer_task"] != "fertile")
		return
	var/datum/customizer_entry/organ/tail/tail_entry = entry
	tail_entry.fertility = !tail_entry.fertility

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
		/datum/sprite_accessory/tail/tailmaw2_headstripes
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
	)
	allows_accessory_color_customization = TRUE
