/obj/item/clothing/suit/roguetown/shirt
	slot_flags = ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|VITALS
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	equip_sound = 'sound/blank.ogg'
	drop_sound = 'sound/blank.ogg'
	pickup_sound =  'sound/blank.ogg'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	sleevetype = "shirt"
	edelay_type = 1
	equip_delay_self = 25
	bloody_icon_state = "bodyblood"
	boobed = TRUE
	sewrepair = TRUE
	flags_inv = HIDEBOOB
	experimental_inhand = FALSE
	salvage_amount = 2

	grid_width = 64
	grid_height = 32

/obj/item/clothing/suit/roguetown/shirt/undershirt
	name = "shirt"
	desc = "Modest and humble. It lets you walk around in public with your dignity intact."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "undershirt"
	item_state = "undershirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|ARMS|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	name = "undervestments"
	desc = "A soft garment designed to prevent chafing from wearing heavy robes all dae and night."
	icon_state = "priestunder"
	item_state = "priestunder"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
	boobed = TRUE
	flags_inv= HIDEBOOB|HIDECROTCH
	body_parts_covered = CHEST|GROIN|ARMS|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/undershirt/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/undershirt/brown
	color = "#6b5445"

/obj/item/clothing/suit/roguetown/shirt/undershirt/lord
	desc = ""
	color = "#616898"

/obj/item/clothing/suit/roguetown/shirt/undershirt/red
	color = "#851a16"

/obj/item/clothing/suit/roguetown/shirt/undershirt/guard
	color = CLOTHING_AZURE

/obj/item/clothing/suit/roguetown/shirt/undershirt/guard/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/undershirt/guard/Destroy()
	GLOB.lordcolor -= src
	return ..()


/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond/lordcolor(primary,secondary)
	if(secondary)
		color = secondary

/obj/item/clothing/suit/roguetown/shirt/undershirt/guardsecond/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/shirt/undershirt/random/Initialize(mapload)
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	return ..()

/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	name = "formal silks"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "puritan_shirt"
	allowed_race = CLOTHED_RACES_TYPES
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	salvage_result = /obj/item/natural/silk
	salvage_amount = 1

/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	name = "tinker suit"
	desc = "Typical fashion of the best engineers."
	icon_state = "artishirt"
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
	name = "low cut tunic"
	desc = "A tunic exposing much of the neck and... shoulders?! How scandalous..."
	icon_state = "lowcut"

/obj/item/clothing/suit/roguetown/shirt/shadowshirt
	name = "silk shirt"
	desc = "A sleeveless shirt woven from glossy material."
	icon_state = "shadowshirt"
	item_state = "shadowshirt"
	r_sleeve_status = SLEEVE_TORN
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|VITALS
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX
	fiber_salvage = FALSE

/obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock
	allowed_race = NON_DWARVEN_RACE_TYPES
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	max_integrity = ARMOR_INT_CHEST_LIGHT_BASE
	armor = ARMOR_PADDED

/obj/item/clothing/suit/roguetown/shirt/apothshirt
	name = "apothecary shirt"
	desc = "When trudging through late-autumn forests, one needs to keep warm."
	icon_state = "apothshirt"
	item_state = "apothshirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
	name = "fancy coat"
	desc = "A fancy tunic and coat combo. How elegant."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	icon_state = "noblecoat"
	item_state = "noblecoat"
	sleevetype = "noblecoat"
	detail_tag = "_detail"
	detail_color = CLOTHING_AZURE
	color = CLOTHING_WHITE
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	name = "tinker suit"
	desc = "Typical fashion of the best engineers."
	icon_state = "artishirt"

//Royal clothing:
//................ Royal Dress (Ball Gown)............... //
/obj/item/clothing/suit/roguetown/shirt/dress/royal
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon = 'icons/roguetown/clothing/shirts_royalty.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_royalty.dmi'
	hiked_base_icon = 'icons/roguetown/clothing/onmob/shirts_royalty.dmi'
	hiked_overlay_icon = 'icons/roguetown/clothing/onmob/hiked/hiked_shirts_royalty.dmi'
	name = "royal gown"
	desc = "An elaborate ball gown, a favoured fashion of queens and elevated nobility in Enigma."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "royaldress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_royalty.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/dress/royal/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/dress/royal/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/shirt/dress/royal/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/dress/royal/Destroy()
	GLOB.lordcolor -= src
	return ..()

//................ Princess Dress ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "pristine dress"
	desc = "A flowy, intricate dress made by the finest tailors in the land for the monarch's children."
	icon_state = "princess"
	boobed = TRUE
	detail_color = CLOTHING_BLUE

//................ Prince Shirt   ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "gilded dress shirt"
	desc = "A gold-embroidered dress shirt specially tailored for the monarch's children."
	icon_state = "prince"
	boobed = TRUE
	detail_color = CLOTHING_MAGENTA

// End royal clothes

/obj/item/clothing/suit/roguetown/shirt/dress/winterdress_light
	name = "cold dress"
	icon = 'icons/roguetown/clothing/shirts_royalty.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_royalty.dmi'
	hiked_base_icon = 'icons/roguetown/clothing/onmob/shirts_royalty.dmi'
	hiked_overlay_icon = 'icons/roguetown/clothing/onmob/hiked/hiked_shirts_royalty.dmi'
	desc = "A thick and comfortable dress popular amongst nobility during winter."
	body_parts_covered = COVERAGE_FULL
	icon_state = "winterdress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_royalty.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

//Is this terrible, yes, but at this point ehhhhhhhh.
/obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_m
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "gilded dress shirt"
	desc = "A gold-embroidered dress shirt tailored for the right hand man."
	icon_state = "prince"
	boobed = TRUE
	detail_color = CLOTHING_AZURE

/obj/item/clothing/suit/roguetown/shirt/dress/royal/hand_f
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "pristine dress"
	desc = "A flowy, intricate dress made by the finest tailors in the land for the right hand man."
	icon_state = "princess"
	boobed = TRUE
	detail_color = CLOTHING_AZURE

/obj/item/clothing/suit/roguetown/shirt/dress/silkydress
	name = "silky dress"
	desc = "Despite not actually being made of silk, the legendary expertise needed to sew this puts the quality on par."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "silkydress"
	item_state = "silkydress"
	sleevetype = null
	sleeved = null
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random/Initialize(mapload)
	color = pick("#e6e5e5", "#249589", "#a32121", "#428138", "#8747b1", "#007fff")
	return ..()

/obj/item/clothing/suit/roguetown/shirt/dress/gown
	icon = 'icons/roguetown/clothing/shirts_gown.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_gown.dmi'
	hiked_base_icon = 'icons/roguetown/clothing/onmob/shirts_gown.dmi'
	hiked_overlay_icon = 'icons/roguetown/clothing/onmob/hiked/hiked_shirts_gown.dmi'
	name = "spring gown"
	desc = "A delicate gown that captures the essence of the season of renewal."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "springgown"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_gown.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_DARK_GREEN
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "summer gown"
	desc = "A breezy flowing gown fit for warm weathers."
	icon_state = "summergown"
	boobed = TRUE
	detail_color = "#e395bb"
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "fall gown"
	desc = "A solemn long-sleeved gown that signifies the season of year's end."
	icon_state = "fallgown"
	boobed = TRUE
	detail_color = "#8b3f00"

/obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "winter gown"
	desc = "A warm elegant gown adorned with soft fur for the cold winter."
	icon_state = "wintergown"
	boobed = TRUE
	detail_color = "#45749d"
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
	icon_state = "sailorblues"

/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/colored
	name = "striped shirt"
	icon_state = "sailorcolorable"
	item_state = "sailorcolorable"
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	boobed_detail = FALSE
	salvage_amount = 1

/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red
	icon_state = "sailorreds"

/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	r_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|ARM_LEFT|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|ARM_RIGHT|VITALS

/obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/Initialize(mapload)
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	return ..()

/obj/item/clothing/suit/roguetown/shirt/shortshirt
	name = "shirt"
	desc = ""
	icon_state = "shortshirt"
	item_state = "shortshirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/shortshirt/random/Initialize(mapload)
	color = pick("#6b5445", "#435436", "#704542", "#79763f")
	return ..()

/obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	name = "shirt"
	desc = ""
	icon_state = "shortshirt"
	item_state = "shortshirt"
	r_sleeve_status = SLEEVE_TORN
	l_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/shirt/shortshirt/bog
	color = "#9ac878"

/obj/item/clothing/suit/roguetown/shirt/rags
	slot_flags = ITEM_SLOT_ARMOR
	name = "rags"
	desc = "From rags to... nope, still rags."
	body_parts_covered = CHEST|GROIN|VITALS
	color = "#b0b0b0"
	icon_state = "rags"
	item_state = "rags"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	dropshrink = null
	fiber_salvage = FALSE

/obj/item/clothing/suit/roguetown/shirt/tribalrag
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "tribalrag"
	desc = ""
	body_parts_covered = CHEST|VITALS
	icon_state = "tribalrag"
	item_state = "tribalrag"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	salvage_result = /obj/item/natural/hide
	salvage_amount = 1
	dropshrink = null

/obj/item/clothing/suit/roguetown/shirt/robe/archivist
	name = "scholar's robe"
	desc = "Robes belonging to seekers of knowledge."
	icon_state = "archivist"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)
	color = null
	sellprice = 100

/obj/item/clothing/suit/roguetown/shirt/tunic
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "tunic"
	desc = "Modest and fashionable, with the right colors."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "tunic"
	boobed = FALSE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	dropshrink = null
	fiber_salvage = FALSE

/obj/item/clothing/suit/roguetown/shirt/tunic/green
	color = CLOTHING_GREEN

/obj/item/clothing/suit/roguetown/shirt/tunic/blue
	color = CLOTHING_BLUE

/obj/item/clothing/suit/roguetown/shirt/tunic/red
	color = CLOTHING_RED

/obj/item/clothing/suit/roguetown/shirt/tunic/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/tunic/white
	color = CLOTHING_WHITE

/obj/item/clothing/suit/roguetown/shirt/tunic/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/tunic/ucolored
	color = COLOR_GRAY

/obj/item/clothing/suit/roguetown/shirt/tunic/random/Initialize(mapload)
	color = pick(CLOTHING_PURPLE, CLOTHING_RED, CLOTHING_BLUE, CLOTHING_GREEN, CLOTHING_BLACK, CLOTHING_WHITE, COLOR_GRAY)
	return ..()

/obj/item/clothing/suit/roguetown/shirt/dress
	slot_flags = ITEM_SLOT_ARMOR
	name = "dress"
	desc = "A simple dress worn by women and the bold."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "dress"
	item_state = "dress"
	hiked_base_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	hiked_overlay_icon = 'icons/roguetown/clothing/onmob/hiked/hiked_shirts.dmi'
	allowed_sex = list(MALE, FEMALE)
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	dropshrink = null

/obj/item/clothing/suit/roguetown/shirt/dress/gen
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "dress"
	desc = "A simple dress worn by women and the bold."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "dressgen"
	item_state = "dressgen"

/obj/item/clothing/suit/roguetown/shirt/dress/gen/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/gen/blue
	color = CLOTHING_BLUE

/obj/item/clothing/suit/roguetown/shirt/dress/gen/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/suit/roguetown/shirt/dress/gen/random/Initialize(mapload)
	color = pick("#6b5445", "#435436", "#704542", "#79763f", CLOTHING_BLUE)
	return ..()

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "chemise"
	desc = "Comfortable yet elegant, it offers both style and comfort for everyday wear."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "silkdress"
	item_state = "silkdress"
	color = "#e6e5e5"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	flags_inv = HIDECROTCH|HIDEBOOB
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX
	dropshrink = null

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/princess
	color = CLOTHING_WHITE

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/princess/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/princess/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/black
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/green
	color = CLOTHING_DARK_GREEN

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/random/Initialize(mapload)
	. = ..()
	color = pick("#e6e5e5", "#52BE80", "#C39BD3", "#EC7063","#5DADE2")

/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "sheer dress"
	desc = "A scandalously short dress made of extra fine fibers for a semi-sheer look."
	body_parts_covered = null
	icon_state = "sexydress"
	sleevetype = null
	sleeved = null
	flags_inv = HIDECROTCH|HIDEBOOB

/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy/random/Initialize(mapload)
	. = ..()
	color = pick(CLOTHING_WHITE, CLOTHING_RED, CLOTHING_PURPLE, CLOTHING_MAGENTA, CLOTHING_TEAL, CLOTHING_BLACK)

/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy/black/Initialize(mapload)
	. = ..()
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/dress/slit
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "slitted dress"
	desc = "A finely sewn dress with a slit to expose the thigh, how scandalous!"
	icon_state = "slitdress"
	item_state = "slitdress"
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/undershirt/webs
	name = "webbed shirt"
	desc = "Exotic silk finely woven into... this? Might as well be wearing a spiderweb."
	icon_state = "webs"
	item_state = "webs"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|ARMS|VITALS
	color = null
	color = null
	salvage_result = /obj/item/natural/silk
	salvage_amount = 1

/obj/item/clothing/suit/roguetown/shirt/jester
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "jester's tunick"
	desc = "Whether it's standup, slapstick, or wrestling nobles to the floor, this tunick can take it all."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "jestershirt"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	boobed = FALSE // for some reason when boobed, the game likes to get rid of the detail and altdetail. I went ahead and just merged it into the main icon.
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	detail_color = CLOTHING_WHITE
	color = CLOTHING_AZURE
	altdetail_color = CLOTHING_WHITE


/obj/item/clothing/suit/roguetown/shirt/jester/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/jester/lordcolor(primary,secondary)
	detail_color = secondary
	color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/shirt/jester/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/jester/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward
	color = null
	name = "ornate silk dress"
	desc = "A dress woven of only the finest, softest silks. Golden thread is inlaid with a deep royal crimson, expressing the owner's exquisitve wealth."
	icon_state = "stewarddress"
	item_state = "stewarddress"

/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic
	name = "ornate silk tunic"
	desc = "A billowing tunic made of the finest silks and softest fabrics. Inlaid with golden thread, this is the height of fashion for the wealthiest of wearers."
	icon_state = "stewardtunic"
	item_state = "stewardtunic"
	fiber_salvage = TRUE

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/loudmouth
	color = null
	name = "crier's garb"
	desc = "A robe that speaks volumes!"
	icon_state = "loudmouthrobe"
	item_state = "loudmouthrobe"

//WEDDING CLOTHES
/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/weddingdress
	name = "wedding silk dress"
	desc = "A dress woven from fine silks, with golden threads inlaid in it. Made for that special day."
	icon_state = "weddingdress"
	item_state = "weddingdress"

/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra
	name = "exotic silk bra"
	desc = "An exquisite bra crafted from the finest silk and adorned with gold rings. It leaves little to the imagination."
	icon_state = "exoticsilkbra"
	item_state = "exoticsilkbra"
	body_parts_covered = CHEST
	flags_inv = null
	slot_flags = ITEM_SLOT_SHIRT
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2
	dropshrink = null

//................ Noble Dress ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/noble
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	name = "noble dress"
	desc = "An elegant dress fit for nobility, crafted with the finest materials and adorned with intricate details."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "nobledress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'


/obj/item/clothing/suit/roguetown/shirt/dress/noble/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/dress/noble/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/shirt/dress/noble/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/shirt/dress/noble/Destroy()
	GLOB.lordcolor -= src
	return ..()

//................ Velvet Dress ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/velvet
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	name = "velvet dress"
	desc = "A luxurious dress made of the finest velvet, soft to the touch and rich in appearance."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "velvetdress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	dropshrink = 0.9

//Servant Clothing:
//................ Maid Dress   ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/maid
	name = "maid dress"
	desc = "A dress befitting the housekeeper of a lord's staff. While not as intricate as a royal's, it is indicative of the house's status."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_maids.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	boobed = TRUE
	icon_state = "maiddress"
	item_state = "maiddress"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK

//................ Servant Gown   ............... //
/obj/item/clothing/suit/roguetown/shirt/dress/maid/servant
	name = "servant gown"
	desc = "A dress worn by those of manors and noble staff. Commonly black, though some estates dye them to their house colors."
	icon_state = "maidgown"
	item_state = "maidgown"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	detail_color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/shirt/undershirt/formal
	name = "formal shirt"
	desc = "A comfortable yet functional dress shirt often worn by the staff of a noble household."
	icon_state = "butlershirt"
	item_state = "butlershirt"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_maids.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon = 'icons/roguetown/clothing/shirts.dmi'
//End Servant Clothing

//kazengite content
/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "black foreign shirt"
	desc = "A shirt typically used by thugs."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "eastshirt1"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	boobed = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "white foreign shirt"
	desc = "A shirt typically used by foreign gangs."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	icon_state = "eastshirt2"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	boobed = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_race = NON_DWARVEN_RACE_TYPES

//Some vanderlin ports, steward clothes and Hand coats//

/obj/item/clothing/suit/roguetown/shirt/dress/steward
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "ornate dark dress"
	desc = "A modest yet decorated dress made of the finest silks and softest fabrics. Inlaid with golden thread, this is the height of fashion for the wealthiest of wearers."
	icon = 'icons/roguetown/clothing/special/steward.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/steward.dmi'
	hiked_base_icon = 'icons/roguetown/clothing/special/onmob/steward.dmi'
	hiked_overlay_icon = 'icons/roguetown/clothing/onmob/hiked/hiked_steward.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/steward.dmi'
	icon_state = "stewarddress"
	item_state = "stewarddress"

/obj/item/clothing/suit/roguetown/shirt/coat/steward
	slot_flags = ITEM_SLOT_ARMOR
	name = "ornate dark tailcoat"
	desc = "A modest yet decorated tailcoat made of the finest silks and softest fabrics. Inlaid with golden thread, this is the height of fashion for the wealthiest of wearers."
	icon = 'icons/roguetown/clothing/special/steward.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/steward.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/steward.dmi'
	icon_state = "stewardtailcoat"
	item_state = "stewardtailcoat"

/obj/item/clothing/suit/roguetown/shirt/coat/hand
	slot_flags = ITEM_SLOT_ARMOR
	name = "noble coat"
	desc = "A fine coat made out of expensive fabrics decorated with golden trims. Fit for a high noble."
	icon = 'icons/roguetown/clothing/special/hand.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/hand.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/hand.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	icon_state = "handcoat"
	item_state = "handcoat"

/obj/item/clothing/suit/roguetown/shirt/noble/hand
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "noble shirt"
	desc = "A silken shirt worn by the upper classes."
	icon = 'icons/roguetown/clothing/special/hand.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/hand.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/hand.dmi'
	icon_state = "fancyshirt"
	item_state = "fancyshirt"

/obj/item/clothing/suit/roguetown/shirt/courtphysician
	name = "sanguine vest"
	desc = "A silk vest, perhaps it will make it another dae without being bloodied."
	boobed = FALSE
	icon_state = "docvest"
	item_state = "docvest"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/courtphys.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/courtphys.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_RED
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/suit/roguetown/shirt/courtphysician/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/suit/roguetown/shirt/courtphysician/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/courtphysician/female
	name = "sanguine blouse"
	desc = "A silk blouse, elegant, but it does you no good in surgery."
	boobed = FALSE
	icon_state = "docblouse"
	item_state = "docblouse"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/courtphys.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/courtphys.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_RED
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/suit/roguetown/shirt/courtphysician/female/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/suit/roguetown/shirt/courtphysician/female/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/desertbra
	name = "desert bra"
	desc = "An exquisite bra crafted from durable cloth. It leaves little to the imagination. Why is it a desert bra and not just a bra?"
	icon_state = "desertbra"
	item_state = "desertbra"
	body_parts_covered = CHEST
	boobed = TRUE
	sleeved = null
	sewrepair = TRUE
	flags_inv = null
	slot_flags = ITEM_SLOT_SHIRT
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 3
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/dress/blue
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "light blue dress"
	desc = "A simple light blue dress, tailored to flatter the figure."
	icon_state = "bluedress"
	item_state = "bluedress"
	sleevetype = null
	sleeved = null
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	boobed = TRUE
	detail_tag = "_detail"
	color = "#ADD8E6"
	detail_color = "#996633"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/dress/etrdress
	name = "low-cut dress"
	desc = "Despite not actually being made of silk, the legendary expertise needed to sew this puts the quality on par."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	icon_state = "etrdress1"
	item_state = "etrdress1"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleevetype = null
	sleeved = null
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_race = NON_DWARVEN_RACE_TYPES
	allowed_sex = list(MALE, FEMALE)
	worn_sprite_sex = FEMALE

/obj/item/clothing/suit/roguetown/shirt/dress/etrdress2
	name = "embroidered dress"
	desc = "Despite not actually being made of silk, the legendary expertise needed to sew this puts the quality on par."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	icon_state = "etrdress2"
	item_state = "etrdress2"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_race = NON_DWARVEN_RACE_TYPES
	allowed_sex = list(MALE, FEMALE)
	worn_sprite_sex = FEMALE

/obj/item/clothing/suit/roguetown/shirt/dress/etrdress3
	name = "strapless gown"
	desc = "Despite not actually being made of silk, the legendary expertise needed to sew this puts the quality on par."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	icon_state = "etrdress3"
	item_state = "etrdress3"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_race = NON_DWARVEN_RACE_TYPES
	detail_tag = "_detail"
	boobed = FALSE
	detail_color = CLOTHING_WHITE
	allowed_sex = list(MALE, FEMALE)
	worn_sprite_sex = FEMALE

/obj/item/clothing/suit/roguetown/shirt/dress/etrdress3/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/dress/green
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "light green dress"
	desc = "A simple light green dress, tailored to flatter the figure."
	icon_state = "greendress"
	item_state = "greendress"
	sleevetype = null
	sleeved = null
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	boobed = TRUE
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	color = "#BEF686"
	detail_color = CLOTHING_WHITE
	altdetail_color = "#996633"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/dress/maidfancy
	name = "valorian maid dress"
	desc = "A dress befitting the housekeeper of a lord's staff. While not as intricate as a royal's, it is indicative of the house's status."
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/sleeves_maids.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	boobed = TRUE
	icon_state = "maiddressfancy"
	item_state = "maiddressfancy"
	detail_tag = "_detail"
	detail_color = CLOTHING_DARK_GREY
	salvage_amount = 1
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/dress/nightgown
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "nightgown"
	desc = "An elegant and enticing nightgown, made for comfort and allure."
	icon_state = "nightgown"
	item_state = "nightgown"
	sleevetype = null
	sleeved = null
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	boobed = TRUE
	color = "#FF0000"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/dress/saree
	name = "saree"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	desc	= "A delicate, unstitched garment that can be draped across the body. It is commonly worn amongst Ranesheni women."
	icon_state = "saree"
	item_state = "saree"
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/bishop
	color = null
	name = "bishop's cassock"
	desc = "Thine authority, divine; thine faith, unfettered."
	icon_state = "bishoprobe"
	item_state = "bishoprobe"
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/dress/tavern
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "tavern dress"
	desc = "A simple green dress with a corset, its skirt has slits for easy movement."
	icon_state = "taverndress"
	item_state = "taverndress"
	sleevetype = null
	sleeved = null
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	boobed = TRUE
	detail_tag = "_detail"
	color = "#BEF686"
	detail_color = "#996633"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/explorer
	name = "explorer's vest"
	desc = "Vest belonging to those who seek knowledge!"
	icon_state = "explorervest"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	boobed = TRUE
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)
	color = null

/obj/item/clothing/suit/roguetown/shirt/fancyjacket
	name = "fancy jacket"
	desc = "My, so modern -- so elegant. Which fine hands sewed this?"
	icon_state = "fancyjacket"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	boobed = FALSE
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)

/obj/item/clothing/suit/roguetown/shirt/fancyjacket/triumph_padded
	name = "dark jacket"
	desc = "A soft jacket of dark leather. All of the swagger, none of the protection."
	icon_state = "dark_jacket"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	sleeved_detail = FALSE

/obj/item/clothing/suit/roguetown/shirt/haori
	name = "haori"
	desc = "A traditional Kazengun outer garment in the form of a short, straight jacket with wide sleeves and side slits."
	icon_state = "haori"
	item_state = "haori"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDEBOOB
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	body_parts_covered = CHEST|VITALS
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/kamishimo
	name = "kamishimo"
	desc = "A sleeveless vest-jacket with wide shoulders, worn over a kimono."
	icon_state = "kamishimo"
	item_state = "kamishimo"
	flags_inv = HIDEBOOB
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	body_parts_covered = CHEST|VITALS
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/kazengun_jacket
	name = "kazengun jacket"
	desc = "Classical Kazengun jacket."
	icon_state = "kazengun_jacket"
	item_state = "kazengun_jacket"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	boobed = TRUE
	flags_inv = HIDEBOOB
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	body_parts_covered = CHEST|VITALS
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	worn_sprite_sex = MALE

/obj/item/clothing/suit/roguetown/shirt/kimono
	name = "kimono"
	desc = ""
	icon_state = "white_kimono"
	item_state = "white_kimono"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	body_parts_covered = CHEST|GROIN|VITALS
	flags_inv= HIDEBOOB|HIDECROTCH
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	var/kimono_colors = list("white", "blue", "black")
	var/picked = FALSE
	var/kimono_final_icon = null
	allowed_sex = list(MALE, FEMALE)
	worn_sprite_sex = FEMALE

/obj/item/clothing/suit/roguetown/shirt/kimono/attack_right(mob/user)
	..()
	if(!picked)
		var/iconH = icon_state
		var/choiceC = input(user, "Choose a color.", "Kimono colors") as anything in kimono_colors
		if(choiceC == "white")
			iconH = "white_kimono"
		if(choiceC == "black")
			iconH = "black_kimono"
		if(choiceC == "blue")
			iconH = "blue_kimono"
		icon_state = iconH
		item_state = iconH
		base_icon_state = iconH
		kimono_final_icon = iconH
		update_icon()
		if(alert("Are you pleased with your kimono?", "Kimono", "Yes", "No") != "Yes")
			icon_state = "white_kimono"
			item_state = "white_kimono"
			base_icon_state = "white_kimono"
			kimono_final_icon = "white_kimono"
			update_icon()
			return
		picked = TRUE
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()

/obj/item/clothing/suit/roguetown/shirt/kimono/equipped(mob/user, slot)
	. = ..()
	if(kimono_final_icon)
		icon_state = kimono_final_icon
		item_state = kimono_final_icon
		update_icon()

/obj/item/clothing/suit/roguetown/shirt/kimono/dropped(mob/user, slot)
	. = ..()
	if(kimono_final_icon)
		icon_state = kimono_final_icon
		item_state = kimono_final_icon
		update_icon()

/obj/item/clothing/suit/roguetown/shirt/kimono2
	name = "long sleeved kimono"
	desc = "Classic kimono from Kazengun islands."
	icon_state = "kimono"
	item_state = "kimono"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	boobed = TRUE
	flags_inv = HIDEBOOB|HIDECROTCH
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/abyssor_leader
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "sylveric robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by exalted abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles the woes of His dream."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "leaderrobe"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/abyssor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "rainfall robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles rainfall."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "rain"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/abyssor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter_sea
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "sea robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles the waves of the great blue."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "sea"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/abyssor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/bared
	name = "bared robe"
	desc = "A robe of basic cloth, it's chest bared open to expose what lay underneath."
	icon_state = "openrobe"
	item_state = "openrobe"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/armor.dmi'
	color = CLOTHING_WHITE
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite
	name = "eoran robe"
	desc = "Holy robes, intended for use by followers of Eora"
	icon_state = "robe_blue"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite/attack_right(mob/user)
	switch(fanatic_wear)
		if(FALSE)
			name = "open eoran robe"
			desc = "Used by more radical followers of the Eoran Church"
			body_parts_covered = null
			icon_state = "straps_blue"
			fanatic_wear = TRUE
			flags_inv = HIDEBOOB
			to_chat(usr, span_warning("Now wearing radically!"))
		if(TRUE)
			name = "eoran robe"
			desc = "Holy robes, intended for use by followers of Eora"
			body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
			icon_state = "robe_blue"
			fanatic_wear = FALSE
			flags_inv = HIDEBOOB|HIDECROTCH
			to_chat(usr, span_warning("Now wearing normally!"))
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite/pink
	name = "eoran robe"
	desc = "Holy robes, intended for use by followers of Eora"
	icon_state = "robe_pink"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite/pink/attack_right(mob/user)
	switch(fanatic_wear)
		if(FALSE)
			name = "open eoran robe"
			desc = "Used by more radical followers of the Eoran Church"
			body_parts_covered = null
			icon_state = "straps_pink"
			fanatic_wear = TRUE
			flags_inv = HIDEBOOB
			to_chat(usr, span_warning("Now wearing radically!"))
		if(TRUE)
			name = "eoran robe"
			desc = "Holy robes, intended for use by followers of Eora"
			body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
			icon_state = "robe_pink"
			fanatic_wear = FALSE
			flags_inv = HIDEBOOB|HIDECROTCH
			to_chat(usr, span_warning("Now wearing normally!"))
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/robe/hag
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "hedge robe"
	desc = "A robe with an ancient design, unknown to tailors and sewers here."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "hag"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/armor.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/robe/leopard
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "leopard robe"
	desc = "An exquisite silky robe with a leopard pattern."
	icon_state = "lpbathrobe"
	item_state = "lpbathrobe"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'
	var/open_wear = FALSE

/obj/item/clothing/suit/roguetown/shirt/robe/leopard/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right-clicking this robe allows for it to be dynamically worn as a traditional robe, or as an open robe that partially exposes the chest.")

/obj/item/clothing/suit/roguetown/shirt/robe/leopard/MiddleClick(mob/user)
	..()
	user.update_inv_shirt()

/obj/item/clothing/suit/roguetown/shirt/robe/leopard/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "bared leopard robe"
			desc = "An exquisite silky robe with a leopard pattern, untied to reveal what's beneath."
			body_parts_covered = GROIN
			icon_state = "lpbathrobe_open"
			item_state = "lpbathrobe_open"
			open_wear = TRUE
			flags_inv = HIDECROTCH
			to_chat(usr, span_warning("You pull back the threaded cloth, baring your heart to Psydonia's eyes."))
		if(TRUE)
			name = "leopard robe"
			desc = "An exquisite silky robe with a leopard pattern."
			body_parts_covered = CHEST|GROIN
			icon_state = "lpbathrobe"
			item_state = "lpbathrobe"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("You cloak yourself in the threaded cloth, veiling your heart from Psydonia's eyes."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/robe/leopard/alt
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "open leopard robe"
	desc = "An exquisite silky robe with a leopard pattern, untied to reveal what's beneath."
	icon_state = "lpbathrobe_open"
	item_state = "lpbathrobe_open"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'
	open_wear = TRUE

/obj/item/clothing/suit/roguetown/shirt/robe/nun_dress
	name = "nun dress"
	desc = ""
	icon_state = "nun_dress"
	item_state = "nun_dress"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	body_parts_covered = CHEST|GROIN|VITALS
	flags_inv= HIDEBOOB|HIDECROTCH
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	allowed_sex = list(MALE, FEMALE)
	worn_sprite_sex = FEMALE

/obj/item/clothing/suit/roguetown/shirt/robe/ravox
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "ravox robe"
	desc = "None are above justice; none are beneath redemption."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "ravoxrobe"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/armor.dmi'
	sleeved = null
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/robe/see
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "see robe"
	desc = "United, we stand - a Pantheon of Ten, shepherding Psydonia's flock towards providence."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "undividedrobe"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/armor.dmi'
	sleeved = null
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/robe/seecleric
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "see clerical robe"
	desc = "United, we walk - a Pantheon of Ten, guiding Psydonia's wanderers towards providence."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "tenclericrobe"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/armor.dmi'
	sleeved = null
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/silkbra
	name = "giltsilk bra"
	desc = "An exquisite bra crafted from the finest silk and adorned with gold rings. It leaves little to the imagination."
	icon_state = "silkbra"
	item_state = "silkbra"
	body_parts_covered = CHEST
	boobed = TRUE
	sewrepair = TRUE
	flags_inv = null
	slot_flags = ITEM_SLOT_SHIRT
	color = CLOTHING_BLACK
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/tunic/rosa
	name = "ivory dress"
	desc = "A finely crafted dress adorned with rosas. A common sight among less silver inclined Otavan nobility."
	icon_state = "rosadress1"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/rosewood.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/rosewood.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/rosewood.dmi'
	boobed = FALSE

/obj/item/clothing/suit/roguetown/shirt/tunic/rosa/five
	name = "sable dress"
	icon_state = "rosadress5"

/obj/item/clothing/suit/roguetown/shirt/tunic/rosa/four
	name = "obsidian dress"
	icon_state = "rosadress4"

/obj/item/clothing/suit/roguetown/shirt/tunic/rosa/six
	name = "maroon dress"
	icon_state = "rosadress6"

/obj/item/clothing/suit/roguetown/shirt/tunic/rosa/three
	name = "velvet dress"
	icon_state = "rosadress3"

/obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat
	name = "regal coat"
	desc = "A finely crafted leather coat adorned with rosas. A favorite among the more modest of Otavan nobility, who choose not to clad themselves in silver."
	icon_state = "rosacoat7"
	icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/rosewood.dmi'
	mob_overlay_icon = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/rosewood.dmi'
	sleeved = 'modular_azurepeak/icons/clothing_port/roguetown/clothing/special/onmob/rosewood.dmi'
	salvage_result = /obj/item/natural/hide/cured
	boobed = FALSE

/obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/four
	name = "stately coat"
	icon_state = "rosacoat10"

/obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/two
	name = "courtly coat"
	icon_state = "rosacoat8"

/obj/item/clothing/suit/roguetown/shirt/elven
	name = "elven suit"
	desc = "A common garnament for Etruscan countryside, each of these suits is woven in adherence to tradition."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	icon_state = "suit"
	item_state = "suit"
	allowed_race = NON_DWARVEN_RACE_TYPES
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|VITALS
	var/elven_colors = list("blue", "red", "beige", "black", "green")
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/shirt/elven/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Elven colors") as anything in elven_colors
		picked = TRUE
		detail_tag = "_[choice]"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()

/obj/item/clothing/suit/roguetown/shirt/elven/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/elven/coat
	name = "elven coat"
	desc = "A common garnament for Etruscan countryside, each of these durable coats is woven in adherence to tradition."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "coat"
	item_state = "coat"
	flags_inv= HIDEBOOB|HIDECROTCH
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	elven_colors = list("blue", "red", "beige", "white", "green", "gray")

/obj/item/clothing/suit/roguetown/shirt/elven/coat/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Elven colors") as anything in elven_colors
		picked = TRUE
		detail_tag = "_[choice]"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/elven/coat/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/elven/coat/alt
	name = "elven furcoat"
	desc = "A common garnament for Etruscan countryside, each of these durable coats is woven in adherence to tradition. Luxurious fur makes it fit for colder regions as well as self-entitled nobility."
	icon_state = "coat_alt"
	item_state = "coat_alt"
	elven_colors = list("blue", "red", "beige", "white")

/obj/item/clothing/suit/roguetown/shirt/elven/coat/alt/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Elven colors") as anything in elven_colors
		picked = TRUE
		detail_tag = "_[choice]"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/elven/coat/alt/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/hammerhold
	name = "hammerhold shirt"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	icon_state = "white_shirt_a"
	item_state = "white_shirt_a"
	allowed_race = NON_DWARVEN_RACE_TYPES
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|GROIN|VITALS
	flags_inv= HIDEBOOB|HIDECROTCH
	var/hammerhold_colors = list("white", "black", "red")
	var/hammerhold_variants = list("a", "b", "c", "d")
	var/picked = FALSE
	var/hammerhold_final_icon = null

/obj/item/clothing/suit/roguetown/shirt/hammerhold/attack_right(mob/user)
	..()
	if(!picked)
		var/iconH = icon_state
		var/choiceC = input(user, "Choose a color.", "Hammerhold colors") as anything in hammerhold_colors
		if(choiceC == "white")
			iconH = "white_shirt"
			hammerhold_variants += list("e", "g")
		if(choiceC == "black")
			iconH = "black_shirt"
			hammerhold_variants += list("e", "g")
		if(choiceC == "red")
			iconH = "red_shirt"
		var/choiceV = input(user, "Choose a variant.", "Hammerhold variants") as anything in hammerhold_variants
		iconH = iconH + "_[choiceV]"
		icon_state = iconH
		item_state = iconH
		base_icon_state = iconH
		hammerhold_final_icon = iconH
		update_icon()
		if(alert("Are you pleased with your shirt?", "Shirt", "Yes", "No") != "Yes")
			icon_state = "white_shirt_a"
			item_state = "white_shirt_a"
			base_icon_state = "white_shirt_a"
			hammerhold_final_icon = "white_shirt_a"
			update_icon()
			return
		picked = TRUE
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()

/obj/item/clothing/suit/roguetown/shirt/hammerhold/equipped(mob/user, slot)
	. = ..()
	if(hammerhold_final_icon)
		icon_state = hammerhold_final_icon
		item_state = hammerhold_final_icon
		update_icon()

/obj/item/clothing/suit/roguetown/shirt/hammerhold/dropped(mob/user, slot)
	. = ..()
	if(hammerhold_final_icon)
		icon_state = hammerhold_final_icon
		item_state = hammerhold_final_icon
		update_icon()

/obj/item/clothing/suit/roguetown/shirt/hammerhold/coat
	name = "noble coat"
	desc = "A noble's cloak inspired by elven culture, worn by the nobility of Hammerhold."
	icon_state = "coat_a"
	item_state = "coat_a"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	hammerhold_colors = list("red", "beige")
	hammerhold_variants = null

/obj/item/clothing/suit/roguetown/shirt/hammerhold/coat/attack_right(mob/user)
	if(!picked)
		var/choiceC = input(user, "Choose a color.", "Hammerhold colors") as anything in hammerhold_colors
		if(choiceC == "beige")
			icon_state = "coat_a"
			item_state = "coat_a"
			hammerhold_final_icon = "coat_a"
		if(choiceC == "red")
			icon_state = "coat_b"
			item_state = "coat_b"
			hammerhold_final_icon = "coat_b"
		update_icon()
		if(alert("Are you pleased with your coat?", "Coat", "Yes", "No") != "Yes")
			icon_state = "coat_a"
			item_state = "coat_a"
			hammerhold_final_icon = "coat_a"
			update_icon()
			return
		picked = TRUE
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_inv_armor()

/obj/item/clothing/suit/roguetown/shirt/undershirt/etrdoublet
	name = "doublet"
	desc = "A comfortable doublet suitable for receptions rather than for hiking."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	icon_state = "etrdoublet"
	item_state = "etrdoublet"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	allowed_sex = list(MALE)
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/shirt/yoroihitatare
	name = "yoroihitatare"
	desc = "Traditional Kazengun samurai ceremonial attire, worn under armor or for official ceremonies."
	icon_state = "yoroihitatare"
	item_state = "yoroihitatare"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	boobed = TRUE
	flags_inv = HIDEBOOB|HIDECROTCH
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
