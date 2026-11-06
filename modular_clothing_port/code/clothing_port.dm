/obj/item/clothing
	var/base_icon_state
	var/custom_design

#define CLOTHING_AZUROSA			"#5e50e9"
#define CLOTHING_CHALK_WHITE		"#f4ecde"
#define CLOTHING_DARK_GREY			"#505050"
#define CLOTHING_GOLD				"#f9a602"
#define CLOTHING_GOLD_METALLIC		"#b0955d"
#define CLOTHING_SCARLET			"#b8252c"
#define CLOTHING_YARROW				"#f0cb76"
#define COLOR_MAP (CLOTHING_COLOR_MAP + EXTENDED_COLOR_MAP)
#define EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD 3
#define EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS 2
#define HERESYDESC_BAOTHA_RELIC "A relic of Baotha's debauched design"
#define HERESYDESC_ZIZO_ICON "It bears the grim zcross of Zizo"
#define CLOTHING_COLOR_MAP list(	\
	"Red" = CLOTHING_RED,			\
	"Purple" = CLOTHING_PURPLE,		\
	"Black" = CLOTHING_BLACK,		\
	"Brown" = CLOTHING_BROWN,		\
	"Green" = CLOTHING_GREEN,		\
	"Blue" = CLOTHING_BLUE,			\
	"Yellow" = CLOTHING_YELLOW,		\
	"Teal" = CLOTHING_TEAL,			\
	"Azure" = CLOTHING_AZURE,		\
	"Azurosa" = CLOTHING_AZUROSA,	\
	"White" = CLOTHING_WHITE,		\
	"Orange" = CLOTHING_ORANGE,		\
	"Magenta" = CLOTHING_MAGENTA	\
)
#define EXTENDED_COLOR_MAP list(					\
	"Burlap" = CLOTHING_BURLAP,						\
	"Chalk White" = CLOTHING_CHALK_WHITE,			\
	"Chestnut" = CLOTHING_CHESTNUT,					\
	"Cream" = CLOTHING_CREAM,						\
	"Dark Grey" = CLOTHING_DARK_GREY,				\
	"Dirt" = CLOTHING_DIRT,							\
	"Dunked in Water" = CLOTHING_DUNKED_WATER,		\
	"Eggplant" = CLOTHING_EGGPLANT,					\
	"Gold" = CLOTHING_GOLD,							\
	"Gold Metallic" = CLOTHING_GOLD_METALLIC,		\
	"Gilded" = CLOTHING_GILDED,						\
	"Gulf Blue" = CLOTHING_GULF_BLUE,				\
	"Light Grey" = CLOTHING_LIGHT_GREY,				\
	"Madder" = CLOTHING_MADDER,						\
	"Mage Blue" = CLOTHING_MAGE_BLUE,				\
	"Mage Green" = CLOTHING_MAGE_GREEN,				\
	"Mage Grey" = CLOTHING_MAGE_GREY,				\
	"Mage Yellow" = CLOTHING_MAGE_YELLOW,			\
	"Muddy Yellow" = CLOTHING_MUDDY_YELLOW,			\
	"Maroon" = CLOTHING_MAROON,						\
	"Olive" = CLOTHING_OLIVE,						\
	"Orchil" = CLOTHING_ORCHIL,						\
	"Otavan Brown" = CLOTHING_OTAVAN_BROWN,			\
	"Peasant Brown" = CLOTHING_PEASANT_BROWN,		\
	"Periwinkle Blue" = CLOTHING_PERIWINKLE_BLUE,	\
	"Red Ochre" = CLOTHING_RED_OCHRE,				\
	"Russet" = CLOTHING_RUSSET,						\
	"Scarlet" = CLOTHING_SCARLET,					\
	"Tan" = CLOTHING_TAN,							\
	"Violet" = CLOTHING_VIOLET,						\
	"Woad Blue" = CLOTHING_WOAD_BLUE,				\
	"Wisteria" = CLOTHING_WISTERIA,					\
	"Wine Red" = CLOTHING_WINE_RED,					\
	"Yellow Ochre" = CLOTHING_YELLOW_OCHRE,			\
	"Yellow Weld" = CLOTHING_YELLOW_WELD,			\
	"Yarrow" = CLOTHING_YARROW						\
)
#define CLOTHING_CHESTNUT			"#613613"
#define CLOTHING_CREAM				"#fffdd0"
#define CLOTHING_DIRT				"#7c6d5c"
#define CLOTHING_DUNKED_WATER		"#bbbbbb"
#define CLOTHING_EGGPLANT			"#5d4356"
#define CLOTHING_GILDED				"#f6b66e"
#define CLOTHING_GULF_BLUE			"#7bb6b0"
#define CLOTHING_LIGHT_GREY			"#999999"
#define CLOTHING_MADDER				"#d74c34"
#define CLOTHING_MAGE_BLUE			"#4756d8"
#define CLOTHING_MAGE_GREEN			"#759259"
#define CLOTHING_MAGE_GREY			"#6c6c6c"
#define CLOTHING_MAGE_YELLOW		"#c1b144"
#define CLOTHING_MAROON				"#550000"
#define CLOTHING_MUDDY_YELLOW		"#b5b004"
#define CLOTHING_OLIVE				"#98bf64"
#define CLOTHING_ORCHIL				"#66023c"
#define CLOTHING_OTAVAN_BROWN		"#553a39"
#define CLOTHING_PEASANT_BROWN		"#685542"
#define CLOTHING_PERIWINKLE_BLUE	"#8f99fb"
#define CLOTHING_RED_OCHRE			"#913831"
#define CLOTHING_RUSSET				"#7f461b"
#define CLOTHING_TAN				"#d6a790"
#define CLOTHING_VIOLET				"#5b2294"
#define CLOTHING_WINE_RED			"#995264"
#define CLOTHING_WISTERIA			"#b07bb6"
#define CLOTHING_WOAD_BLUE			"#597fb9"
#define CLOTHING_YELLOW_OCHRE		"#cb9d06"
#define CLOTHING_YELLOW_WELD		"#f4c430"

/obj/item/clothing/suit/roguetown/shirt/fancyjacket/triumph_padded
	name = "dark jacket"
	desc = "A soft jacket of dark leather. All of the swagger, none of the protection."
	icon_state = "dark_jacket"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	sleeved_detail = FALSE

/obj/item/clothing/cloak/rangercloak
	name = "ranger cloak"
	desc = "A traditionally elven cloak said to help blend in with the woods."
	icon_state = "ranger"
	item_state = "ranger"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	resistance_flags = FIRE_PROOF
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/bandolier
	name = "bandolier"
	desc = "A sash that's pelted with pouches, perfect for carrying plenty of pint-sized pieces. </br>'Hail to the King, baby.'"
	color = null
	icon_state = "bandolier"
	item_state = "bandolier"
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	salvage_result = /obj/item/natural/hide/cured
	grid_width = 64
	grid_height = 96
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/sleevedtabard
	name = "sleeved tabard"
	desc = "A tabard with a light sleeve and pauldron sewn on, it lacks the explicit detailing of other tabards in exchange."
	color = null
	boobed = TRUE
	icon_state = "halfsurcoat"
	item_state = "halfsurcoat"
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "shirt"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/psydontabard
	name = "psydonian tabard"
	desc = "A tabard worn by the adherents of the Holy Psydonic Inquisition. Delicate stitchwork professes the psycross with pride."
	color = null
	icon_state = "psydontabard"
	item_state = "psydontabard"
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	custom_design = TRUE
	var/open_wear = FALSE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/psydontabard/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right-clicking this cloak allows for it to be dynamically worn as a traditional tabard, or as a sleeveless robe that partially exposes the chest.")

/obj/item/clothing/cloak/tabard/psydontabard/MiddleClick(mob/user)
	..()
	user.update_inv_shirt()

/obj/item/clothing/cloak/tabard/psydontabard/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "opened psydonian tabard"
			desc = "A tabard worn by the adherents of the Holy Psydonic Inquisition, peeled back to reveal its enduring innards."
			body_parts_covered = GROIN
			icon_state = "psydontabardalt"
			item_state = "psydontabardalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH
			to_chat(usr, span_warning("ENDURING, like the MARTYRS who'll guide the faithful-and-pious to PARADISE."))
		if(TRUE)
			name = "psydonian tabard"
			desc = "A tabard worn by the adherents of the Holy Psydonic Inquisition. Delicate stitchwork professes the psycross with pride."
			body_parts_covered = CHEST|GROIN
			icon_state = "psydontabard"
			item_state = "psydontabard"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("VEILED, like the CORPSES who've been shepherded by your steel to the AFTERLYFE."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/psydontabard/black
	name = "blessed tabard"
	desc = "A tabard worn by the worshippers of Psydon. A funeral shroud for the paradise that could've been, and a solemn vow to continue the struggle towards salvation."
	icon_state = "blackpsydontabard"
	item_state = "blackpsydontabard"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/psydontabard/black/MiddleClick(mob/user)
	..()
	user.update_inv_shirt()

/obj/item/clothing/cloak/tabard/psydontabard/black/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "opened blessed tabard"
			desc = "A tabard worn by the worshippers of Psydon, peeled back to reveal its mourning innards."
			body_parts_covered = GROIN
			icon_state = "blackpsydontabardalt"
			item_state = "blackpsydontabardalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH
			to_chat(usr, span_warning("You pull back the threaded burlap, baring your heart to Psydonia's eyes."))
		if(TRUE)
			name = "blessed tabard"
			desc = "A tabard worn by the worshippers of Psydon. A funeral shroud for the paradise that could've been, and a solemn vow to continue the struggle towards salvation."
			body_parts_covered = CHEST|GROIN
			icon_state = "blackpsydontabard"
			item_state = "blackpsydontabard"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("You cloak yourself in the threaded burlap, veiling your heart from Psydonia's eyes."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/psydontabard/white
	name = "traditional tabard"
	desc = "A traditional tabard worn by the worshippers of Psydon, fashioned into a sleeveless garment that harks back to the ancient yils of the Holy Inquisition."
	icon_state = "whitepsydontabard"
	item_state = "whitepsydontabard"
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	custom_design = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/psydontabard/white/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right-clicking this cloak allows for it to be dynamically worn as a traditional tabard, or as a sleeveless robe that partially exposes the chest.")

/obj/item/clothing/cloak/tabard/psydontabard/white/MiddleClick(mob/user)
	..()
	user.update_inv_shirt()

/obj/item/clothing/cloak/tabard/psydontabard/white/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "opened traditional tabard"
			desc = "A traditional tabard worn by the worshippers of Psydon, fashioned into a bared sleeveless garment that harks back to the ancient yils of the Holy Inquisition."
			body_parts_covered = GROIN
			icon_state = "whitepsydontabardalt"
			item_state = "whitepsydontabardalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH
			to_chat(usr, span_warning("You pull back the threaded cloth, baring your heart to Psydonia's eyes."))
		if(TRUE)
			name = "traditional tabard"
			desc = "A traditional tabard worn by the worshippers of Psydon, fashioned into a sleeveless garment that harks back to the ancient yils of the Holy Inquisition."
			body_parts_covered = CHEST|GROIN
			icon_state = "whitepsydontabard"
			item_state = "whitepsydontabard"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("You cloak yourself in the threaded cloth, veiling your heart from Psydonia's eyes."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/psydontabard/white/alt
	name = "opened traditional tabard"
	desc = "A traditional tabard worn by the worshippers of Psydon, fashioned into a bared sleeveless garment that harks back to the ancient yils of the Holy Inquisition."
	body_parts_covered = GROIN
	icon_state = "whitepsydontabardalt"
	item_state = "whitepsydontabardalt"
	flags_inv = HIDECROTCH
	open_wear = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/templar/astratancleric
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	name = "astratan cloak"
	desc = "A golden-colored cloak with frayed edges, bearing the radiant hues of Astrata. It marks the wearer as a beacon of light amidst the chaos of battle."
	icon_state = "astrataclerictabard"
	sleevetype = "shirt"
	boobed = FALSE
	resistance_flags = FIRE_PROOF
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/templar/astratancleric/grey
	name = "frayed cloak"
	desc = "A flowing cloak with frayed edges, cut in the style of Astratan clergy. Its plain cloth takes dye readily."
	icon_state = "greyastrataclerictabard"
	resistance_flags = FLAMMABLE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/templar/necrancleric
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	name = "necran cloak"
	desc = "A dark, battle-worn cloak secured with a silver buckle. Marked with the somber symbols of Necra, its frayed hem bears testament to endless skirmishes with death."
	icon_state = "necraclerictabard"
	boobed = FALSE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/templar/ravoxcleric
	name = "justice cloak"
	desc = "A tattered red tabard dyed in the bold colors of Ravox. Its striking crimson fabric stands out on the front lines, signaling unyielding judgment."
	icon_state = "justiceclerictabard"
	boobed = FALSE
	body_parts_covered = CHEST|GROIN
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK|ITEM_SLOT_MASK
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/templar/undividedcleric
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = TRUE
	name = "undivided devotee tabard"
	desc = "The refuge of the TEN upon my back. A Undivided Pantheon, to carry the light amongst the ever-present darkness that looms ahead."
	icon_state = "tenclerictabard"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/templar/undivided_alt
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	alternate_worn_layer = TABARD_LAYER
	boobed = TRUE
	name = "undivided templar tabard"
	desc = "The refuge of the TEN upon my back. A Undivided House, standing eternal against the encroaching darkness."
	icon_state = "seetabardalt"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/toga/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right-clicking this cloak allows for it to be dynamically worn traditionally, or with a side pulled down that partially exposes the chest.")

/obj/item/clothing/cloak/tabard/toga/MiddleClick(mob/user)
	..()
	user.update_inv_shirt()

/obj/item/clothing/cloak/tabard/toga
	name = "toga"
	desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity."
	icon_state = "toga"
	item_state = "toga"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	boobed = FALSE
	custom_design = FALSE
	color = "#FFFFFF"
	detail_tag = "_detail"
	detail_color = "#FAC55C"
	var/open_wear = FALSE

/obj/item/clothing/cloak/tabard/toga/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "bared toga"
			desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity, bared open to reveal what's beneath."
			body_parts_covered = GROIN
			icon_state = "togaalt"
			item_state = "togaalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH
			to_chat(usr, span_warning("You pull back a sleeve, baring what lies beneath to Psydonia's eyes."))
		if(TRUE)
			name = "toga"
			desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity."
			body_parts_covered = CHEST|GROIN
			icon_state = "toga"
			item_state = "toga"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("You pull up your sleeve, veiling what lies beneath from Psydonia's eyes."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/toga/alt
	name = "bared toga"
	desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity, bared open to reveal what's beneath."
	icon_state = "togaalt"
	item_state = "togaalt"
	flags_inv = HIDECROTCH
	body_parts_covered = GROIN
	open_wear = TRUE

/obj/item/clothing/cloak/tabard/toga/dress
	name = "toga"
	desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity."
	icon_state = "togadress"
	item_state = "togadress"
	boobed = TRUE
	open_wear = FALSE

/obj/item/clothing/cloak/tabard/toga/dress/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "bared toga"
			desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity, bared open to reveal what's beneath."
			body_parts_covered = GROIN
			icon_state = "togadressalt"
			item_state = "togadressalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH
			to_chat(usr, span_warning("You pull back a strap, baring what lies beneath to Psydonia's eyes."))
		if(TRUE)
			name = "toga"
			desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity."
			body_parts_covered = CHEST|GROIN
			icon_state = "togadress"
			item_state = "togadress"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("You pull up your strap, veiling what lies beneath from Psydonia's eyes."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/toga/dress/alt
	name = "bared toga"
	desc = "The ancestral predecessor to Psydonia's many tabards, worn by the townsfolk, heroes, and villains of antiquity, bared open to reveal what's beneath."
	icon_state = "togadressalt"
	item_state = "togadressalt"
	flags_inv = HIDECROTCH
	body_parts_covered = GROIN
	open_wear = TRUE

/obj/item/clothing/cloak/tabard/stabard
	name = "surcoat"
	desc = "An outer garment commonly worn by soldiers."
	icon_state = "stabard"
	boobed = TRUE
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/stabard/surcoat
	name = "jupon"
	icon_state = "surcoat"
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/tabard/stabard/surcoat/short
	name = "short jupon"
	icon_state = "surcoat_short"
	body_parts_covered = CHEST
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'

/obj/item/clothing/cloak/scout
	name = "scout cloak"
	desc = "A weathered cape cut short at the flank."
	icon_state = "scout_cloak"
	item_state = "scout_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/cape/inquisitorgold
	name = "golden order cloak"
	desc = "A time honored cloak inlaid with golden threading, the stitchwork tethers it to the Golden Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from heathens, cultists, and the ever-looming threat of another calamity."
	icon_state = "inquisitor_cloak"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "inquisitor"
	color = null

/obj/item/clothing/cloak/cape/inquisitorsilver
	name = "silver order cloak"
	desc = "A time honored cloak inlaid with silver threading, the stitchwork tethers it to the Silver Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from monsters, creechers, and the ever-looming threat of the Archdevil's return."
	icon_state = "sinquisitor_cloak"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "inquisitor"
	color = null

/obj/item/clothing/cloak/half/shadowcloak
	name = "stalker cloak"
	desc = "A heavy leather cloak held together by a gilded pin, depicting the Grand Duke's house. The sign of a faithful servant."
	icon_state = "shadowcloak"
	color = null
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/half/shadowcloak/spymaster
	name = "hand's cloak"
	desc = "Crafted not for warmth, but to complete an imposing silhouette. It is tailored to shroud both the hilt of a hidden blade and the true intentions of its wearer from prying eyes."
	icon_state = "handcloak"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/poncho/fancycoat
	name = "fancy coat"
	desc = "A loose garment that is usually draped across ones upper body. No one's quite sure of its cultural origin but it does look fancy."
	icon_state = "fancycoat"
	item_state = "fancycoat"
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	flags_inv = HIDECROTCH|HIDEBOOB
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_ARMOR
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	nodismemsleeves = TRUE
	color = CLOTHING_WHITE
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/poncho/fancycoat/trimmed
	name = "trimmed fancy coat"
	desc = "A loose garment that is usually draped across ones upper body. No one's quite sure of its cultural origin but it does look fancy. This one has been trimmed to show ones legs. How scandalous."
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	icon_state = "noblecoattrimmed"
	item_state = "noblecoattrimmed"

/obj/item/clothing/cloak/absolutionistrobe/black
	name = "blessed robe"
	desc = "Weep for what was lost. Pray for those who may yet be saved. Endure, in His name."
	icon_state = "blackabsolutionistrobe"
	item_state = "blackabsolutionistrobe"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/apron/waist/maid
	name = "maid apron"
	desc = "A fancy, somewhat short apron usually worn by servants."
	body_parts_covered = null
	icon_state = "maidapron"
	item_state = "maidapron"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/maids.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/maids.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/maids.dmi'

/obj/item/clothing/cloak/scaledcloak
	name = "scaled cloak"
	desc = "A light cloak covered in shimmering metal scales. Beautiful even if too light to protect it's wearer from more than other travel cloaks."
	icon_state = "scalecloak"
	item_state = "scalecloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	boobed = FALSE
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_BACK_R|ITEM_SLOT_BACK_L
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	detail_tag = "_detail"
	detail_color = "#405996"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/sash
	name = "sash"
	desc = "A large sash that can be draped across one's torso."
	icon_state = "sash"
	item_state = "sash"
	boobed = FALSE
	slot_flags = ITEM_SLOT_CLOAK|ITEM_SLOT_BACK_R|ITEM_SLOT_BACK_L|ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/half/duelcape
	name = "duelist cape"
	desc = "A flamboyant red duelists cape that is sure to catch the eye."
	icon_state = "duelistcape"
	item_state = "duelistcape"
	color = CLOTHING_SCARLET
	nodismemsleeves = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_GOLD_METALLIC
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "shirt"
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	allowed_race = NON_DWARVEN_RACE_TYPES
	inhand_mod = FALSE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/half/duelcape/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/half/duelcape/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/cloak/half/duelcape/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/rosa
	name = "regal cloak"
	desc = "A finely crafted cloak of silk adorned with rosas."
	icon_state = "rosacloak7"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/rosewood.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/rosewood.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/rosewood.dmi'
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/cloak/rosa/two
	name = "courtly cloak"
	icon_state = "rosacloak8"

/obj/item/clothing/cloak/sash/dupatta
	name = "dupatta"
	desc = "A regional variant of the humble sash, loosely fit to fight against the Ranesheni heat."
	icon_state = "dupatta"
	item_state = "dupatta"
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	altdetail_tag = "_detailalt"
	altdetail_color = CLOTHING_WHITE
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_cloaks.dmi'
	sleevetype = "shirt"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/cloaks.dmi'

/obj/item/clothing/cloak/sash/dupatta/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/cloak/sash/dupatta/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/clothing/shoes/roguetown/courtphysician
	name = "sanguine shoes"
	desc = "Leather shoes, the solemn tap of these bears grim news, or salvation."
	icon_state = "docshoes"
	item_state = "docshoes"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/courtphys.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/courtphys.dmi'
	salvage_result = /obj/item/natural/hide/cured
	sewrepair = TRUE

/obj/item/clothing/shoes/roguetown/courtphysician/female
	name = "sanguine heels"
	desc = "Leather heels, the solemn tap of these bears grim news, or salvation."
	icon_state = "docheels"
	item_state = "docheels"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/courtphys.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/courtphys.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_RED

/obj/item/clothing/shoes/roguetown/courtphysician/female/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/shoes/roguetown/courtphysician/female/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_HEELS, 2)
	stepnoise_flag = STEPNOISE_HEELS

/obj/item/clothing/shoes/roguetown/courtphysician/female/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/shoes/roguetown/rosa
	name = "ivory shoes"
	desc = "Finely crafted shoes of silk and leather."
	icon_state = "rosashoes1"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/rosewood.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/rosewood.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/rosewood.dmi'

/obj/item/clothing/shoes/roguetown/rosa/three
	name = "silvered shoes"
	icon_state = "rosashoes3"

/obj/item/clothing/shoes/roguetown/rosa/four
	name = "obsidian shoes"
	icon_state = "rosashoes4"

/obj/item/clothing/shoes/roguetown/rosa/five
	name = "sable shoes"
	icon_state = "rosashoes5"

/obj/item/clothing/shoes/roguetown/rosa/seven
	name = "regal shoes"
	icon_state = "rosashoes7"

/obj/item/clothing/shoes/roguetown/rosa/eight
	name = "courtly shoes"
	icon_state = "rosashoes8"

/obj/item/clothing/shoes/roguetown/rosa/nine
	name = "royal shoes"
	icon_state = "rosashoes9"

/obj/item/clothing/shoes/roguetown/rosa/ten
	name = "stately shoes"
	icon_state = "rosashoes10"

/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/spymaster
	name = "hand's gloves"
	desc = "Supple silk, cut at the fingertips to ensure absolute precision."
	icon_state = "handgloves"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/gloves.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/gloves.dmi'

/obj/item/clothing/gloves/roguetown/rosa
	name = "ivory gloves"
	desc = "Finely crafted gloves of silk and leather."
	icon_state = "rosagloves1"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/rosewood.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/rosewood.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/rosewood.dmi'
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/gloves/roguetown/rosa/three
	name = "silvered gloves"
	icon_state = "rosagloves3"

/obj/item/clothing/gloves/roguetown/rosa/four
	name = "obsidian gloves"
	icon_state = "rosagloves4"

/obj/item/clothing/gloves/roguetown/rosa/five
	name = "sable gloves"
	icon_state = "rosagloves5"

/obj/item/clothing/gloves/roguetown/rosa/six
	name = "maroon gloves"
	icon_state = "rosagloves6"

/obj/item/clothing/gloves/roguetown/rosa/seven
	name = "regal gloves"
	icon_state = "rosagloves7"

/obj/item/clothing/gloves/roguetown/rosa/eight
	name = "courtly gloves"
	icon_state = "rosagloves8"

/obj/item/clothing/gloves/roguetown/rosa/nine
	name = "royal gloves"
	icon_state = "rosagloves9"

/obj/item/clothing/gloves/roguetown/rosa/ten
	name = "stately gloves"
	icon_state = "rosagloves10"

/obj/item/clothing/head/roguetown/roguehood/eorahood
	name = "opera hood"
	desc = "An opera mask worn by the faithful of Eora, usually during their rituals. Comes with a hood that can be pulled up for warmth."
	color = null
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/64x64/head.dmi'
	icon_state = "eorahood"
	bloody_icon = 'icons/effects/blood64.dmi'
	bloody_icon_state = "helmetblood"
	worn_x_dimension = 64
	worn_y_dimension = 64
	resistance_flags = FIRE_PROOF
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 180
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/undivided
	name = "undivided hood"
	desc = "A hood of those devoted to upholding the deca-divinity in their dae to dae duties."
	color = null
	icon_state = "undividedhood"
	item_state = "undividedhood"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEEARS|HIDEHAIR|HIDEFACIALHAIR
	block2add = null
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 180
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/roguehood/ravox
	name = "ravox hood"
	desc = "A hood of those devoted to upholding Justicar's will. Justice might be blind but not it's servants."
	color = null
	icon_state = "ravoxhood"
	item_state = "ravoxhood"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEEARS|HIDEHAIR|HIDEFACIALHAIR
	block2add = null
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 180
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/circlet/carvedgem/porcelain
	name = "porcelain circlet"
	desc = "An ornate circlet made out of porcelain."
	icon_state = "circlet_porcelain"
	toggle_icon_state = FALSE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/explorerhat
	name = "explorer's hat"
	desc = "How many secrets can I uncover this week?"
	icon_state = "explorerhat"
	item_state = "explorerhat"
	sewrepair = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/deserthood
	name = "desert hood"
	desc = "If only it was this warm."
	icon_state = "desert_hood"
	item_state = "desert_hood"
	sewrepair = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/tiyon
	name = "tiyon"
	desc = "A fancy cloth headdress."
	icon_state = "tiyon"
	sewrepair = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/doublehennin
	name = "dual hennin"
	desc = "A fancy hennin framed by two cones that sit atop ones head. Worn most commonly by the old-fashioned and elderly."
	icon_state = "hennin_double"
	sewrepair = TRUE
	detail_tag = "_detail"
	color = CLOTHING_WHITE
	detail_color = CLOTHING_WHITE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/veiledhat
	name = "veiled hat"
	desc = "A luxurious, wide-brimmed hat defined by two flanking sheets of cloth sewn under the brim, it frames the face well."
	icon_state = "veilhat"
	sewrepair = TRUE
	detail_tag = "_detail"
	color = CLOTHING_WHITE
	detail_color = CLOTHING_WHITE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/flotsam
	name = "flotsam bonnet"
	desc = "A flexible cloth bonnet of elven fashion that holds a strong resemblance to a leaf. Worn oft by those who dwell in forests and swamps."
	icon_state = "flotsam"
	sewrepair = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/nightcap
	name = "nitecap"
	desc = "A simple nightcap, used to keep the baldest of heads warm during the nite."
	icon_state = "link"
	sewrepair = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/durag
	name = "durag"
	desc = "A fashionable garment worn to protect one's hair."
	icon_state = "durag"
	sewrepair = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/longveil
	name = "long veil"
	desc = "A long, trailing veil made of cloth meant to conceal ones hair. Often worn by soilbrides and the devout."
	icon_state = "headveil"
	detail_tag = "_detail"
	detail_color = CLOTHING_CHALK_WHITE
	sewrepair = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/flamboyant
	name = "flamboyant hat"
	desc = "A luxurious purple feathered hat with wide brim."
	icon_state = "flamboyant"
	item_state = "flamboyant"
	sewrepair = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/maidhead
	name = "maid headdress"
	desc = "A decorative cloth headband clearly indicating the wearer as a maid."
	icon_state = "maidhead"
	item_state = "maidhead"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/maids.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/maids.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/maids.dmi'

/obj/item/clothing/head/roguetown/courtphysician
	name = "sanguine hat"
	desc = "A hat for keeping the splattered blood out of your face, for when your trade is required."
	icon_state = "dochat1"
	item_state = "dochat1"
	detail_tag = "_detail"
	detail_color = CLOTHING_RED
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/courtphys.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/courtphys.dmi'
	salvage_result = /obj/item/natural/silk
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/courtphysician/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/head/roguetown/courtphysician/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/courtphysician/female
	name = "sanguine cap"
	desc = "A cap for keeping the splattered blood out of your hair, for when your trade is required."
	icon_state = "dochat2"
	item_state = "dochat2"
	detail_tag = "_detail"
	detail_color = CLOTHING_RED

/obj/item/clothing/head/roguetown/courtphysician/female/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/head/roguetown/courtphysician/female/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/headband/fur
	name = "fur headband"
	desc = "A rough thick fur headband, worn by the more rugged folk."
	icon_state = "fur_headband"
	item_state = "fur_headband"
	body_parts_covered = HEAD|HAIR|EARS
	salvage_result = /obj/item/natural/hide/cured
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/menacing/executioner
	name = "executioners hood"
	icon_state = "dungeoneer"
	color = null
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/mask/rogue/spectacles/thin
	name = "thin-lensed spectacles"
	icon_state = "glassesa"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/masks.dmi'

/obj/item/clothing/mask/rogue/faceveil
	name = "simple veil"
	desc = "A remarkably plain veil meant to conceal ones face... if you wore this, a gust of wind would be all it takes to reveal your identity."
	icon_state = "faceveil"
	flags_inv = HIDEFACE|HIDESNOUT
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	grid_width = 32
	grid_height = 32
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/masks.dmi'

/obj/item/clothing/mask/rogue/faceveil/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/rummaging-03.ogg', null, (UPD_HEAD|UPD_MASK))

/obj/item/clothing/mask/rogue/spectacles/sglasses
	name = "smokey onyxa spectacles"
	desc = "Death has come to your little town, Sheriff. Now, you can either ignore it, or you can help me to stop it."
	icon_state = "sglasses"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/masks.dmi'

/obj/item/clothing/mask/rogue/shepherd/shadowmask/spymaster
	name = "hand's halfmask"
	icon_state = "handmask"
	desc = "A sleek, contoured halfmask of silk."
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/masks.dmi'

/obj/item/clothing/mask/rogue/physician/feld
	name = "feldsher's mask"
	desc = "Tragedy, neutrality, and comedy; the guise of a master, tempered against the most sorrowful and sudden consequences of bad medicine."
	icon_state = "pestramask"
	item_state = "pestramask"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/masks.dmi'

/obj/item/clothing/mask/rogue/physician/phys
	name = "physicker's mask"
	desc = "A beaked guise, stuffed with herbs to keep one's humors unmarred during more grizzlesome labors."
	icon_state = "feldmask"
	item_state = "feldmask"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/masks.dmi'

/obj/item/clothing/mask/rogue/xylixmask/weathered
	name = "weathered mask"
	item_state = "xylix_weathered"
	icon_state = "xylix_weathered"
	desc = "An ancient ceramic face. It looks weathered, the sort molded by Xylixian worshippers of many yils past. Even when cast aside, it feels like the hardened clay has never left your hands. As if it always finds a way back into your palms."

	max_integrity = 200
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/masks.dmi'

/obj/item/clothing/mask/rogue/xylixmask/ceramic
	name = "ceramic mask"
	item_state = "ceramicmask"
	icon_state = "ceramicmask"
	desc = "An ivory ceramic mask, plain and vacant. What is a joke with a smile missing? Ever so drought of what used to be painted with colors and joy."
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/masks.dmi'

/obj/item/clothing/neck/roguetown/cravat
	name = "cravat"
	desc = "An otavan fashion, a strip of tied cloth that can be donned on the neck to make oneself look more sophisticated."
	icon_state = "cravat"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/neck.dmi'

/obj/item/clothing/neck/roguetown/ruffle
	name = "ruffled collar"
	desc = "A ridiculous lace collar typically worn by jesters."
	icon_state = "ruffle"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/neck.dmi'

/obj/item/clothing/neck/roguetown/collar/fur
	name = "fur collar"
	desc = "A thick ruff of trapped fur, worn about the shoulders."
	icon_state = "furscarf"
	item_state = "furscarf"
	salvage_result = /obj/item/natural/fur
	salvage_amount = 1
	sewrepair = TRUE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/neck.dmi'

/obj/item/clothing/under/roguetown/loincloth/deprived
	color = "#464040"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/pants.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'

/obj/item/clothing/under/roguetown/tights/hose
	name = "cloth hosen"
	icon_state = "hose"
	item_state = "hose"
	desc = "A pair of cloth leggings, traditionally worn in conjunction with one's shortclothes. These can be combined with maille hosen for \
	the perfect blend of function-and-fashion; just pray no one has the mind to aim below the belt."
	body_parts_covered = LEGS|FEET
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	flags_inv = null
	color = null
	detail_color = CLOTHING_WHITE
	altdetail_color = CLOTHING_WHITE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/pants.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'

/obj/item/clothing/under/roguetown/tights/hose/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/under/roguetown/tights/hose/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/clothing/under/roguetown/tights/dhoti
	name = "dhoti"
	icon_state = "dhoti"
	item_state = "dhoti"
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	desc = "A pair of baggy pants of Ranesheni origin, with a long banner-like cloth draped between the two pant legs."
	salvage_result = /obj/item/natural/cloth
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/pants.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'

/obj/item/clothing/under/roguetown/skirt/desert
	name = "desert skirt"
	desc = "At least it cools me off, but what of the modesty?"
	icon_state = "desertskirt"
	item_state = "desertskirt"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/pants.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'

/obj/item/clothing/under/roguetown/skirt/short
	name = "short skirt"
	desc = "short, flowing, and not very modest."
	item_state = "surcoatshortskirt"
	icon_state = "surcoatshortskirt"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/pants.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'

/obj/item/clothing/under/roguetown/skirt/courtphysician
	name = "sanguine skirt"
	desc = "An elegant velvet skirt that does you no good when running to someone's aid."
	icon_state = "docskirt"
	item_state = "docskirt"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/courtphys.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/courtphys.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_RED
	alternate_worn_layer = (SHIRT_LAYER)
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/under/roguetown/skirt/courtphysician/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/clothing/under/roguetown/skirt/courtphysician/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/under/roguetown/skirt/formal
	name = "knee-high skirt"
	desc = "A fitted skirt tailored to follow the line of the legs, narrowing toward the hem."
	icon_state = "formalskirt"
	item_state = "formalskirt"
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/pants.dmi'
	sleevetype = "skirt"
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/pants.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/undivided
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "undivided robe"
	desc = "Undivided, we stand - a Pantheon of Ten, shepherding Psydonia's flock towards providence."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "undividedrobe"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = null
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/robe/undividedcleric
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "undivided clerical robe"
	desc = "Undivided, we walk - a Pantheon of Ten, guiding Psydonia's wanderers towards providence."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "tenclericrobe"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = null
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/robe/ravox
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "ravox robe"
	desc = "None are above justice; none are beneath redemption."
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	icon_state = "ravoxrobe"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = null
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/robe/bared
	name = "bared robe"
	desc = "A robe of basic cloth, it's chest bared open to expose what lay underneath."
	icon_state = "openrobe"
	item_state = "openrobe"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/armor.dmi'
	color = CLOTHING_WHITE
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/leopard/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right-clicking this robe allows for it to be dynamically worn as a traditional robe, or as an open robe that partially exposes the chest.")

/obj/item/clothing/suit/roguetown/shirt/robe/leopard
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "leopard robe"
	desc = "An exquisite silky robe with a leopard pattern."
	icon_state = "lpbathrobe"
	item_state = "lpbathrobe"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'
	var/open_wear = FALSE

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
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'
	open_wear = TRUE

/obj/item/clothing/suit/roguetown/shirt/fancyjacket
	name = "fancy jacket"
	desc = "My, so modern -- so elegant. Which fine hands sewed this?"
	icon_state = "fancyjacket"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	boobed = FALSE
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)

/obj/item/clothing/suit/roguetown/shirt/explorer
	name = "explorer's vest"
	desc = "Vest belonging to those who seek knowledge!"
	icon_state = "explorervest"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	boobed = TRUE
	flags_inv = HIDECROTCH|HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)
	color = null

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/bishop
	color = null
	name = "bishop's cassock"
	desc = "Thine authority, divine; thine faith, unfettered."
	icon_state = "bishoprobe"
	item_state = "bishoprobe"
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'

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
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'

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
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/courtphysician
	name = "sanguine vest"
	desc = "A silk vest, perhaps it will make it another dae without being bloodied."
	boobed = FALSE
	icon_state = "docvest"
	item_state = "docvest"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/courtphys.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/courtphys.dmi'
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
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/courtphys.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/courtphys.dmi'
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

/obj/item/clothing/suit/roguetown/shirt/dress/maidfancy
	name = "valorian maid dress"
	desc = "A dress befitting the housekeeper of a lord's staff. While not as intricate as a royal's, it is indicative of the house's status."
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/sleeves_maids.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	boobed = TRUE
	icon_state = "maiddressfancy"
	item_state = "maiddressfancy"
	detail_tag = "_detail"
	detail_color = CLOTHING_DARK_GREY
	salvage_amount = 1
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/dress/saree
	name = "saree"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	desc	= "A delicate, unstitched garment that can be draped across the body. It is commonly worn amongst Ranesheni women."
	icon_state = "saree"
	item_state = "saree"
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'

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
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'

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
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'

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
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'

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
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/tunic/rosa
	name = "ivory dress"
	desc = "A finely crafted dress adorned with rosas. A common sight among less silver inclined Otavan nobility."
	icon_state = "rosadress1"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/rosewood.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/rosewood.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/rosewood.dmi'
	boobed = FALSE

/obj/item/clothing/suit/roguetown/shirt/tunic/rosa/three
	name = "velvet dress"
	icon_state = "rosadress3"

/obj/item/clothing/suit/roguetown/shirt/tunic/rosa/four
	name = "obsidian dress"
	icon_state = "rosadress4"

/obj/item/clothing/suit/roguetown/shirt/tunic/rosa/five
	name = "sable dress"
	icon_state = "rosadress5"

/obj/item/clothing/suit/roguetown/shirt/tunic/rosa/six
	name = "maroon dress"
	icon_state = "rosadress6"

/obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat
	name = "regal coat"
	desc = "A finely crafted leather coat adorned with rosas. A favorite among the more modest of Otavan nobility, who choose not to clad themselves in silver."
	icon_state = "rosacoat7"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/rosewood.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/rosewood.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/rosewood.dmi'
	salvage_result = /obj/item/natural/hide/cured
	boobed = FALSE

/obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/two
	name = "courtly coat"
	icon_state = "rosacoat8"

/obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/four
	name = "stately coat"
	icon_state = "rosacoat10"

/obj/item/storage/belt/rogue/leather/beltshawl
	name = "belt shawl"
	desc = "A fancy shawl worn around the waist."
	icon_state = "beltshawl"
	item_state = "beltshawl"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/belts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/belts.dmi'

/obj/item/storage/belt/rogue/leather/battleskirt/loincloth
	name = "cloth loincloth"
	desc = "A fine leather strap with a crude cloth covering, notched above the loincloth."
	icon_state = "loincloth"
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/belts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/belts.dmi'

/obj/item/storage/belt/rogue/leather/battleskirt/loincloth/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/storage/belt/rogue/leather/iron
	name = "iron belt"
	desc = "A fine leather belt that's been sleeved within many segments of iron, protecting its delicate innards from prying hands-and-blades."
	icon_state = "ironplaque"
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/belts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/belts.dmi'

/obj/item/storage/belt/rogue/leather/sash/maid
	name = "cloth sash"
	desc = "A pliable sash made of wool meant to wrap tightly around the waist."
	item_state = "maidsash"
	icon_state = "maidsash"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/maids.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/maids.dmi'

/obj/item/storage/belt/rogue/leather/belthooks
	name = "belt hooks"
	desc = "Etruscan-designed leather-wrapped hooks with an actuating hinge. To clip things to other things."
	icon_state = "belthooks"

	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/belts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/belts.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/hag
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "wyrd robe"
	desc = "A robe with an ancient design, unknown to tailors and sewers here."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "hag"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/cloak/tabard/stabard/crusader
	name = "surcoat of the golden order"
	desc = "A regal surcoat, inlaid with golden threading. The stitchwork tethers it to the Golden Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from heathens, cultists, and the ever-looming threat of another calamity. This variant bears the psicruciformic sigil of the Psydonic and Necran \
	orders."
	icon_state = "crusader_surcoat"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/crusader.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/crusader.dmi'
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/crusader.dmi'
	custom_design = TRUE

/obj/item/clothing/cloak/tabard/stabard/crusader/t
	name = "surcoat of the silver order"
	desc = "A noble surcoat, inlaid with silver threading. The stitchwork tethers it to the Silver Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from monsters, deadites, and the ever-looming threat of another calamity. This variant bears the psicruciformic sigil of the Psydonic and Necran \
	orders."
	icon_state = "crusader_surcoatt2"

/obj/item/clothing/cloak/tabard/stabard/crusader/astrata
	name = "surcoat of the golden order"
	desc = "A regal surcoat, inlaid with golden threading. The stitchwork tethers it to the Golden Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from heathens, cultists, and the ever-looming threat of another calamity. This variant bears the duocruciformic sigil of the Astratan and Ravoxian \
	orders."
	icon_state = "acrusader_surcoat"

/obj/item/clothing/cloak/tabard/stabard/crusader/t/astrata
	name = "surcoat of the silver order"
	desc = "A noble surcoat, inlaid with silver threading. The stitchwork tethers it to the Silver Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from monsters, deadites, and the ever-looming threat of another calamity. This variant bears the duocruciformic sigil of the Astratan and Ravoxian \
	orders."
	icon_state = "acrusader_surcoatt2"

/obj/item/clothing/cloak/tabard/stabard/crusader/undivided
	name = "surcoat of the golden order"
	desc = "A regal surcoat, inlaid with golden threading. The stitchwork tethers it to the Golden Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from heathens, cultists, and the ever-looming threat of another calamity. This variant bears the unicruciform sigil of the Undivided and Erranteer \
	orders."
	icon_state = "ucrusader_surcoat"

/obj/item/clothing/cloak/tabard/stabard/crusader/t/undivided
	name = "surcoat of the silver order"
	desc = "A noble surcoat, inlaid with silver threading. The stitchwork tethers it to the Silver Orders; a catch-all term for the various faith-militances that \
	ward Psydonia from monsters, deadites, and the ever-looming threat of another calamity. This variant bears the unicruciform sigil of the Undivided and Erranteer \
	orders."
	icon_state = "ucrusader_surcoatt2"

/obj/item/clothing/cloak/tabard/stabard/crusader/bsteel
	name = "surcoat of the blacksteel order"
	desc = "A venerated surcoat, inlaid with blacksteel threading. The stitchwork tethers it to the Blacksteel Order; an ancient faith-militance whose roots trace \
	all the way back to Psydonia's first crusaders. Uniquely welcoming to both Psydonic and Undivided patroneers, and irreversibly valorant against the dreaded \
	Avantyne Legion. </br>'Happiness must be fought for, lest all hope perish from the face of this world.'"
	icon_state = "crusader_surcoatb3"

/obj/item/clothing/cloak/tabard/stabard/crusader/heavy
	name = "overvestments"
	desc = "A heavy surcoat that offers complete modesty and protection against the weather, but leaves the thinner-framed with sorer shoulders. Commonly seen upon \
	the bods of paladin-errants, priests, and pilgrims across Psydonia's more intemperate climates."
	icon_state = "priest_surcoat"

/obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "rainfall robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles rainfall."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "rain"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/abyssor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter_sea
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "sea robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles the waves of the great blue."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "sea"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/abyssor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/robe/abyssor_leader
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "sylveric robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by exalted abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles the woes of His dream."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "leaderrobe"
	icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/special/onmob/abyssor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	sleeved = 'modular_clothing_port/icons/ap/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/storage/backpack/rogue/backpack_trader
	name = "traders chests"
	desc = "Bulky, heavy, enormous. You're the rat in the world with a lot of shinies in your pockets for sell."
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/back.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/back.dmi'
	icon_state = "backpack_trader"
	item_state = "backpack_trader"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_L
	resistance_flags = FIRE_PROOF
	equip_delay_self = 5 SECONDS
	unequip_delay_self = 10 SECONDS
	strip_delay = 5 SECONDS
	max_integrity = 400
	sellprice = 150
	pickup_sound = 'sound/foley/equip/equip_armor.ogg'
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	bloody_icon_state = "bodyblood"
	sewrepair = TRUE
	var/active_item = FALSE

/obj/item/storage/backpack/rogue/backpack_trader/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	if(slot == SLOT_BACK_L)
		active_item = TRUE
		user.change_stat(STATKEY_SPD, -4)
		to_chat(user, span_monkeyhive("uGH! I hate this thing....my back"))

/obj/item/storage/backpack/rogue/backpack_trader/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
	user.change_stat(STATKEY_SPD, 4)
	to_chat(user, span_monkeyhive("Finally....some rest"))

/obj/item/clothing/cloak/twilight_elven
	name = "elven cloak"
	desc = "It is said that this design might predate the War in Heaven and the consequient fall of the ancient Elven Empire."
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "cape"
	item_state = "cape"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	inhand_mod = TRUE
	var/elven_colors = list("Blue Cloak", "Red Cloak", "Blue Furcloak", "Red Furcloak")
	var/picked = FALSE

/obj/item/clothing/cloak/twilight_elven/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/roguetown/cloak)

/obj/item/clothing/cloak/twilight_elven/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a style.", "Elven styles") as anything in elven_colors
		picked = TRUE
		switch(choice)
			if("Blue Cloak")
				detail_tag = "_blue"
			if("Red Cloak")
				detail_tag = "_red"
			if("Blue Furcloak")
				detail_tag = "_blue_alt"
			if("Red Furcloak")
				detail_tag = "_red_alt"
			if("Blue Short Cloak")
				detail_tag = "_blue"
			if("Red Short Cloak")
				detail_tag = "_red"
			if("Blue Short Furcloak")
				detail_tag = "_blue_alt"
			if("Red Short Furcloak")
				detail_tag = "_red_alt"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			update_icon()

/obj/item/clothing/cloak/twilight_elven/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/cloak/twilight_elven/short
	name = "elven shortcloak"
	icon_state = "cape_short"
	item_state = "cape_short"
	elven_colors = list("Blue Short Cloak", "Red Short Cloak", "Blue Short Furcloak", "Red Short Furcloak")

/obj/item/clothing/cloak/twilight_scarf
	name = "scarf"
	desc = "A long piece of cloth, meant to be worn around one's neck, Keeps you warm even under colder winds."
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "scarf"
	item_state = "scarf"
	inhand_mod = TRUE
	var/elven_colors = list("blue", "black", "green", "beige", "brown", "white")
	var/picked = FALSE

/obj/item/clothing/cloak/twilight_scarf/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Elven colors") as anything in elven_colors
		picked = TRUE
		detail_tag = "_[choice]"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			update_icon()

/obj/item/clothing/cloak/twilight_scarf/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/cloak/bishop
	name = "bishop cape"
	desc = ""
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "bishop_cape"
	item_state = "bishop_cape"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	inhand_mod = TRUE

/obj/item/clothing/cloak/bishop/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/roguetown/cloak)

/obj/item/clothing/cloak/templar/eoran/alt
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "tabard_blue"
	item_state = "tabard_blue"
	var/eora_colors = list("Blue Tabard", "Pink Tabard")
	var/picked = FALSE
	var/eora_final_icon = null

/obj/item/clothing/cloak/templar/eoran/alt/attack_right(mob/user)
	..()
	if(!picked)
		var/choiceC = input(user, "Choose a color.", "Eora colors") as anything in eora_colors
		if(choiceC == "Blue Tabard")
			icon_state = "tabard_blue"
			item_state = "tabard_blue"
			eora_final_icon = "tabard_blue"
		if(choiceC == "Pink Tabard")
			icon_state = "tabard_pink"
			item_state = "tabard_pink"
			eora_final_icon = "tabard_pink"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
		if(alert("Are you pleased with your tabard?", "Tabard", "Yes", "No") != "Yes")
			icon_state = "tabard_blue"
			item_state = "tabard_blue"
			eora_final_icon = "tabard_blue"
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_cloak()
			update_icon()
			return
		picked = TRUE

/obj/item/clothing/cloak/templar/eoran/alt/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/cloak/templar/eoran/alt/equipped(mob/user, slot)
	. = ..()
	if(eora_final_icon)
		icon_state = eora_final_icon
		item_state = eora_final_icon
		update_icon()

/obj/item/clothing/cloak/templar/eoran/alt/dropped(mob/user, slot)
	. = ..()
	if(eora_final_icon)
		icon_state = eora_final_icon
		item_state = eora_final_icon
		update_icon()

/obj/item/clothing/cloak/sheriff
	name = "sheriff's cloak"
	desc = "Плащ-накидка с вышитой серебряной геральдикой дозора."
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/special/citywatch_armor.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/special/onmob/citywatch_armor.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/special/onmob/citywatch_armor.dmi'
	icon_state = "sheriffcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER

/obj/item/clothing/cloak/etrcape
	name = "wanderer's cape"
	desc = "A stylish raincoat that protects you from the rain and makes you look great"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "etrcape"
	item_state = "etrcape"
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	inhand_mod = FALSE
	color = null
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/cloak/bandolier/inq
	name = "inquisitorial bandolier"
	desc = "A masterworked leather bandolier, lined with silvered fittings and sturdy loops for the tools of inquiry. Every strap serves a purpose; every buckle stands ready for the next hunt."
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "inqbandolier"
	item_state = "inqbandolier"

/obj/item/clothing/shoes/roguetown/boots/hammerhold_boots
	name = "hammerhold boots"
	desc = ""
	icon_state = "boots"
	item_state = "boots"
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/boots.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/boots.dmi'

/obj/item/clothing/shoes/roguetown/hammerhold_shoes
	name = "hammerhold shoes"
	desc = ""
	icon_state = "shoes"
	item_state = "shoes"
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/boots.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/boots.dmi'

/obj/item/clothing/head/roguetown/stewardtophat
	name = "top hat"
	icon_state = "stewardtophat"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/special/noble.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/roguetown/eaststrawhat
	name = "worn rice hat"
	desc = "A wicker rice hat."
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	icon_state = "eaststrawhat"
	flags_inv = HIDEEARS
	sewrepair = TRUE
	var/hides_ears = TRUE

/obj/item/clothing/head/roguetown/eaststrawhat/MiddleClick(mob/user, params)
	. = ..()
	hides_ears = !hides_ears
	flags_inv = hides_ears ? HIDEEARS : null

/obj/item/clothing/head/roguetown/twilight_elven_hat
	name = "elven burka"
	desc = "A warm hat, designed to protect long elven ears from cold winds of northen Valoria."
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/head_48.dmi'
	icon_state = "elven_hat"
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/twilight_hammerhold_hat
	name = "kokoshnik"
	desc = ""
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/head_48.dmi'
	icon_state = "white_mage_headwear"
	flags_inv = HIDEEARS
	var/hammerhold_colors = list("white", "blue")
	var/hammerhold_variants = null
	var/picked = FALSE
	var/hammerhold_final_icon = null

/obj/item/clothing/head/roguetown/twilight_hammerhold_hat/attack_right(mob/user)
	..()
	if(!picked)
		var/choiceC = input(user, "Choose a color.", "Hammerhold colors") as anything in hammerhold_colors
		if(choiceC == "white")
			icon_state = "white_mage_headwear"
		if(choiceC == "blue")
			icon_state = "blue_mage_headwear"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		if(alert("Are you pleased with your kokoshnik?", "Kokoshnik", "Yes", "No") != "Yes")
			icon_state = "white_mage_headwear"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			return
		picked = TRUE

/obj/item/clothing/head/roguetown/twilight_hammerhold_hat/attack_right(mob/user)
	if(!picked)
		var/choiceV = input(user, "Choose a variant.", "Hammerhold colors") as anything in hammerhold_variants
		if(choiceV == "a")
			icon_state = "headwear_a"
			hammerhold_final_icon = "headwear_a"
		if(choiceV == "b")
			icon_state = "headwear_b"
			hammerhold_final_icon = "headwear_b"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		if(alert("Are you pleased with your hat?", "hat", "Yes", "No") != "Yes")
			icon_state = "headwear_a"
			hammerhold_final_icon = "headwear_a"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			return
		picked = TRUE

/obj/item/clothing/head/roguetown/twilight_hammerhold_hat/equipped(mob/user, slot)
	. = ..()
	if(hammerhold_final_icon)
		icon_state = hammerhold_final_icon
		item_state = hammerhold_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/twilight_hammerhold_hat/dropped(mob/user, slot)
	. = ..()
	if(hammerhold_final_icon)
		icon_state = hammerhold_final_icon
		item_state = hammerhold_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/twilight_hammerhold_hat/peasant
	name = "hammerhold hat"
	desc = ""
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/head_48.dmi'
	icon_state = "headwear_a"
	flags_inv = HIDEEARS
	hammerhold_colors = null
	hammerhold_variants = list("a", "b")
	picked = FALSE

/obj/item/clothing/head/roguetown/nunTA
	name = "nun hood"
	desc = ""
	icon_state = "nun_hood"
	item_state = "nun_hood"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	slot_flags = ITEM_SLOT_HEAD
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/nunTA/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	if(flags_inv & HIDE_HEADTOP)
		flags_inv &= ~HIDE_HEADTOP
	else
		flags_inv |= HIDE_HEADTOP
	user.update_inv_head()

/obj/item/clothing/head/roguetown/roguehood/bishop
	name = "bishop hood"
	desc = ""
	color = null
	icon_state = "bishop_hood"
	item_state = "bishop_hood"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 180
	resistance_flags = FIRE_PROOF
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/roguehood/bishop/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CHOSEN, "VISAGE")

/obj/item/clothing/head/roguetown/antlers
	name = "old antlers"
	desc = "Old antlers which you can wear on helmet, hood....or straight on your head!"
	icon_state = "antlers"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/head_48.dmi'
	alternate_worn_layer  = 8.9
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_NECK
	resistance_flags = FIRE_PROOF
	var/picked = FALSE
	var/rogavid = list("halo", "knighty")
	var/antlers_final_icon = null

/obj/item/clothing/head/roguetown/antlers/attack_right(mob/user)
	..()
	if(!picked)
		var/chooseA = input(user, "What will you choose?", "Where you got it?") as anything in rogavid
		if(chooseA == "halo")
			icon_state = "antlers"
			antlers_final_icon = "antlers"
		if(chooseA == "knighty")
			icon_state = "antlers_knighty"
			antlers_final_icon = "antlers_knighty"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		if(alert("Are you pleased with your antlers?", "Antlers", "Yes", "No") != "Yes")
			icon_state = "antlers"
			antlers_final_icon = "antlers"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			return
		picked = TRUE

/obj/item/clothing/head/roguetown/antlers/equipped(mob/user, slot)
	. = ..()
	if(antlers_final_icon)
		icon_state = antlers_final_icon
		item_state = antlers_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/antlers/dropped(mob/user, slot)
	. = ..()
	if(antlers_final_icon)
		icon_state = antlers_final_icon
		item_state = antlers_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/gasa
	name = "gasa"
	flags_inv = HIDEEARS
	icon_state = "gasa"
	item_state = "gasa"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/clothing/kazengun_n_burger.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/roguetown/torioigasa
	name = "torioigasa"
	flags_inv = HIDEEARS
	icon_state = "torioigasa"
	item_state = "torioigasa"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/clothing/kazengun_n_burger.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/roguetown/roningasa
	name = "roningasa"
	flags_inv = HIDEEARS
	icon_state = "roningasa"
	item_state = "roningasa"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/clothing/kazengun_n_burger.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/roguetown/sandogasa
	name = "sandogasa"
	flags_inv = HIDEEARS
	icon_state = "sandogasa"
	item_state = "sandogasa"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/clothing/kazengun_n_burger.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/roguetown/roguehood/burgerhood
	name = "noble hood"
	desc = "Шёлковый капюшон, показывающий высокий статус владельца. По крайней мере выглядит сносно."
	color = null
	icon_state = "burgerhood"
	item_state = "burgerhood"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/clothing/kazengun_n_burger.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/clothing/onmob/kazengun_n_burger.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	detail_tag = "_detail"
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	color = "#de5013"
	detail_color = "#e3ab12"
	toggle_icon_state = TRUE
	max_integrity = 180
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/duelhat/etrusca
	name = "etruscan duelist hat"
	desc = "A dainty looking feathered hat that is actually quite heavy and thick, Duelists from Etrusca are known to value winning fights without dirtying the white feather on top"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	icon_state = "duelisthat"
	item_state = "duelisthat"
	color = null

/obj/item/clothing/head/roguetown/hscarf
	desc = "Шёлковая повязка, что часто находится на голове чаще всего или моряка, или пирата!"
	name = "head scarf"
	icon_state = "headscarf"
	item_state = "headscarf"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/clothing/kazengun_n_burger.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/clothing/onmob/kazengun_n_burger.dmi'
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/head/roguetown/duelhat/etrhat
	name = "wanderer's hat"
	desc = "A comfortable hat that will make you look elegant and protect you from the weather."
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	icon_state = "etrhat"
	item_state = "etrhat"
	color = null

/obj/item/clothing/head/roguetown/onhelm
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP|ITEM_SLOT_MASK
	flags_inv = HIDEEARS
	icon = 'modular_clothing_port/icons/ta/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/head/roguetown/onhelm/tw_d_horns
	name = "horns helmkleinod"
	desc = "A pair of imposing iron horns designed to be mounted atop a helmet, giving the wearer a beastly silhouette to strike fear into the hearts of their enemies."
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/32x48/onhelm.dmi'
	icon_state = "d_horns"
	item_state = "d_horns"

/obj/item/clothing/head/roguetown/onhelm/tw_d_basic
	name = "helm's chaperon"
	desc = "A simple but elegant cloth burlet worn over a helmet. It serves both to deflect the beating sun and to display the wearer's heraldic colors with pride."
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/32x48/onhelm.dmi'
	icon_state = "d_basic"
	item_state = "d_basic"

/obj/item/clothing/mask/rogue/facemask/xylixmask
	name = "xylixian mask"
	desc = "A ceramic mask, forever stuck with the joyful smile its patron god favors. While it will shatter easily from blows, its smug countenance shall taunt its foes."
	max_integrity = 50
	armor = null
	drop_sound = 'sound/foley/brickdrop.ogg'
	pickup_sound = 'sound/foley/brickdrop.ogg'
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/masks.dmi'
	icon_state = "xylixmask"
	item_state = "xylixmask"
	detail_tag = "_l"
	altdetail_tag = "_r"
	color = "#FFFFFF"
	detail_color = "#4756d8"
	altdetail_color = "#b8252c"
	anvilrepair = /datum/skill/craft/ceramics
	smeltresult = null

/obj/item/clothing/mask/rogue/facemask/xylixmask/Initialize()
	..()
	update_icon()

/obj/item/clothing/mask/rogue/facemask/xylixmask/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/clothing/mask/rogue/eyepatch/fake
	desc = "An eyepatch, fitted for the right eye. It has an almost imperceptible gap so that you can see something."
	block2add = null
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/masks.dmi'

/obj/item/clothing/mask/rogue/eyepatch/left/fake
	desc = "An eyepatch, fitted for the left eye. It has an almost imperceptible gap so that you can see something."
	block2add = null
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/masks.dmi'

/obj/item/clothing/suit/roguetown/shirt/twilight_elven
	name = "elven suit"
	desc = "A common garnament for Etruscan countryside, each of these suits is woven in adherence to tradition."
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	icon_state = "suit"
	item_state = "suit"
	allowed_race = NON_DWARVEN_RACE_TYPES
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|VITALS
	var/elven_colors = list("blue", "red", "beige", "black", "green")
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Elven colors") as anything in elven_colors
		picked = TRUE
		detail_tag = "_[choice]"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat
	name = "elven coat"
	desc = "A common garnament for Etruscan countryside, each of these durable coats is woven in adherence to tradition."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "coat"
	item_state = "coat"
	flags_inv= HIDEBOOB|HIDECROTCH
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	elven_colors = list("blue", "red", "beige", "white", "green", "gray")

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat/attack_right(mob/user)
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

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat/alt
	name = "elven furcoat"
	desc = "A common garnament for Etruscan countryside, each of these durable coats is woven in adherence to tradition. Luxurious leovarg fur makes it fit for colder regions as well as self-entitled nobility."
	icon_state = "coat_alt"
	item_state = "coat_alt"
	elven_colors = list("blue", "red", "beige", "white")

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat/alt/attack_right(mob/user)
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

/obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat/alt/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold
	name = "hammerhold shirt"
	desc = ""
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
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

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/attack_right(mob/user)
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

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/equipped(mob/user, slot)
	. = ..()
	if(hammerhold_final_icon)
		icon_state = hammerhold_final_icon
		item_state = hammerhold_final_icon
		update_icon()

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dropped(mob/user, slot)
	. = ..()
	if(hammerhold_final_icon)
		icon_state = hammerhold_final_icon
		item_state = hammerhold_final_icon
		update_icon()

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/coat
	name = "boyar coat"
	desc = "Боярский плащ вдохновленный эльфийской культурой, который носят знатные представители Хаммерхолда"
	icon_state = "coat_a"
	item_state = "coat_a"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	hammerhold_colors = list("red", "beige")
	hammerhold_variants = null

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/coat/attack_right(mob/user)
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

/obj/item/clothing/suit/roguetown/shirt/robe/nunTA
	name = "nun dress"
	desc = ""
	icon_state = "nun_dress"
	item_state = "nun_dress"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	body_parts_covered = CHEST|GROIN|VITALS
	flags_inv= HIDEBOOB|HIDECROTCH
	allowed_race = NON_DWARVEN_RACE_TYPES
	allowed_sex = list(FEMALE)
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'

/obj/item/clothing/suit/roguetown/shirt/kimono
	name = "kimono"
	desc = ""
	icon_state = "white_kimono"
	item_state = "white_kimono"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	body_parts_covered = CHEST|GROIN|VITALS
	flags_inv= HIDEBOOB|HIDECROTCH
	allowed_race = NON_DWARVEN_RACE_TYPES
	allowed_sex = list(FEMALE)
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	var/kimono_colors = list("white", "blue", "black")
	var/picked = FALSE
	var/kimono_final_icon = null

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

/obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite
	name = "eoran robe"
	desc = "Holy robes, intended for use by followers of Eora"
	icon_state = "robe_blue"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'

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
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'

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
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

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
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

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
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/kamishimo
	name = "kamishimo"
	desc = "A sleeveless vest-jacket with wide shoulders, worn over a kimono."
	icon_state = "kamishimo"
	item_state = "kamishimo"
	flags_inv = HIDEBOOB
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	body_parts_covered = CHEST|VITALS
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

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
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'

/obj/item/clothing/suit/roguetown/shirt/dress/etrdress
	name = "low-cut dress"
	desc = "Despite not actually being made of silk, the legendary expertise needed to sew this puts the quality on par."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	icon_state = "etrdress1"
	item_state = "etrdress1"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleevetype = null
	sleeved = null
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_sex = list(FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/shirt/dress/etrdress2
	name = "embroidered dress"
	desc = "Despite not actually being made of silk, the legendary expertise needed to sew this puts the quality on par."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	icon_state = "etrdress2"
	item_state = "etrdress2"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_sex = list(FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/shirt/undershirt/etrdoublet
	name = "doublet"
	desc = "A comfortable doublet suitable for receptions rather than for hiking."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	icon_state = "etrdoublet"
	item_state = "etrdoublet"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	allowed_sex = list(MALE)
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/shirt/dress/etrdress3
	name = "strapless gown"
	desc = "Despite not actually being made of silk, the legendary expertise needed to sew this puts the quality on par."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	icon_state = "etrdress3"
	item_state = "etrdress3"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	flags_inv = HIDECROTCH|HIDEBOOB
	allowed_sex = list(FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
	detail_tag = "_detail"
	boobed = FALSE
	detail_color = CLOTHING_WHITE

/obj/item/clothing/suit/roguetown/shirt/dress/etrdress3/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/storage/belt/rogue/leather/hammerhold_sash
	name = "hammerhold sash"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/belts.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/belts.dmi'
	icon_state = "hammerhold_sash"
	detail_tag = "_belt"

/obj/item/clothing/mask/rogue/blindfold/psydon
	name = "blessed blindfold"
	desc = "You will not conquer. You will endure. In pain, you affirm the Architect's design."
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/masks.dmi'
	icon_state = "psyblindfold"
	item_state = "psyblindfold"
	tint = 1

/obj/item/clothing/head/hooded/desert_hood
	name = "desert cloak hood"
	desc = "This one will shelter me from the sand."
	icon_state = "desert_hood"
	item_state = "desert_hood"
	icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_clothing_port/icons/ta/modular_twilight_axis/icons/roguetown/clothing/onmob/head_48.dmi'
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEHAIR
	detail_tag = "_detail"

/obj/item/clothing/head/hooded/desert_hood/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/head/hooded/desert_hood/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/datum/loadout_item/port_storage_backpack_rogue_backpack_trader
	name = "Traders chests"
	path = /obj/item/storage/backpack/rogue/backpack_trader

/datum/loadout_item/port_clothing_cloak_bandolier
	name = "Bandolier"
	path = /obj/item/clothing/cloak/bandolier

/datum/loadout_item/port_clothing_cloak_bishop
	name = "Bishop cape"
	path = /obj/item/clothing/cloak/bishop

/datum/loadout_item/port_clothing_cloak_etrcape
	name = "Wanderer's cape"
	path = /obj/item/clothing/cloak/etrcape

/datum/loadout_item/port_clothing_cloak_rangercloak
	name = "Ranger cloak"
	path = /obj/item/clothing/cloak/rangercloak

/datum/loadout_item/port_clothing_cloak_rosa
	name = "Regal cloak"
	path = /obj/item/clothing/cloak/rosa

/datum/loadout_item/port_clothing_cloak_sash
	name = "Sash"
	path = /obj/item/clothing/cloak/sash

/datum/loadout_item/port_clothing_cloak_scaledcloak
	name = "Scaled cloak"
	path = /obj/item/clothing/cloak/scaledcloak

/datum/loadout_item/port_clothing_cloak_scout
	name = "Scout cloak"
	path = /obj/item/clothing/cloak/scout

/datum/loadout_item/port_clothing_cloak_sheriff
	name = "Sheriff's cloak"
	path = /obj/item/clothing/cloak/sheriff

/datum/loadout_item/port_clothing_cloak_sleevedtabard
	name = "Sleeved tabard"
	path = /obj/item/clothing/cloak/sleevedtabard

/datum/loadout_item/port_clothing_cloak_twilight_elven
	name = "Elven cloak"
	path = /obj/item/clothing/cloak/twilight_elven

/datum/loadout_item/port_clothing_cloak_twilight_scarf
	name = "Scarf (twilight scarf)"
	path = /obj/item/clothing/cloak/twilight_scarf

/datum/loadout_item/port_clothing_cloak_absolutionistrobe_black
	name = "Blessed robe"
	path = /obj/item/clothing/cloak/absolutionistrobe/black

/datum/loadout_item/port_clothing_cloak_bandolier_inq
	name = "Inquisitorial bandolier"
	path = /obj/item/clothing/cloak/bandolier/inq

/datum/loadout_item/port_clothing_cloak_cape_inquisitorgold
	name = "Golden order cloak"
	path = /obj/item/clothing/cloak/cape/inquisitorgold

/datum/loadout_item/port_clothing_cloak_cape_inquisitorsilver
	name = "Silver order cloak"
	path = /obj/item/clothing/cloak/cape/inquisitorsilver

/datum/loadout_item/port_clothing_cloak_half_duelcape
	name = "Duelist cape (duelcape)"
	path = /obj/item/clothing/cloak/half/duelcape

/datum/loadout_item/port_clothing_cloak_poncho_fancycoat
	name = "Fancy coat (fancycoat)"
	path = /obj/item/clothing/cloak/poncho/fancycoat

/datum/loadout_item/port_clothing_cloak_rosa_two
	name = "Courtly cloak"
	path = /obj/item/clothing/cloak/rosa/two

/datum/loadout_item/port_clothing_cloak_sash_dupatta
	name = "Dupatta"
	path = /obj/item/clothing/cloak/sash/dupatta

/datum/loadout_item/port_clothing_cloak_tabard_toga
	name = "Toga (toga)"
	path = /obj/item/clothing/cloak/tabard/toga

/datum/loadout_item/port_clothing_cloak_templar_astratancleric
	name = "Astratan cloak"
	path = /obj/item/clothing/cloak/templar/astratancleric

/datum/loadout_item/port_clothing_cloak_templar_necrancleric
	name = "Necran cloak"
	path = /obj/item/clothing/cloak/templar/necrancleric

/datum/loadout_item/port_clothing_cloak_templar_ravoxcleric
	name = "Justice cloak"
	path = /obj/item/clothing/cloak/templar/ravoxcleric

/datum/loadout_item/port_clothing_cloak_templar_undivided_alt
	name = "Undivided templar tabard"
	path = /obj/item/clothing/cloak/templar/undivided_alt

/datum/loadout_item/port_clothing_cloak_templar_undividedcleric
	name = "Undivided devotee tabard"
	path = /obj/item/clothing/cloak/templar/undividedcleric

/datum/loadout_item/port_clothing_cloak_twilight_elven_short
	name = "Elven shortcloak"
	path = /obj/item/clothing/cloak/twilight_elven/short

/datum/loadout_item/port_clothing_gloves_roguetown_rosa
	name = "Ivory gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa

/datum/loadout_item/port_clothing_head_hooded_desert_hood
	name = "Desert cloak hood"
	path = /obj/item/clothing/head/hooded/desert_hood

/datum/loadout_item/port_clothing_head_roguetown_antlers
	name = "Old antlers"
	path = /obj/item/clothing/head/roguetown/antlers

/datum/loadout_item/port_clothing_head_roguetown_courtphysician
	name = "Sanguine hat"
	path = /obj/item/clothing/head/roguetown/courtphysician

/datum/loadout_item/port_clothing_head_roguetown_deserthood
	name = "Desert hood"
	path = /obj/item/clothing/head/roguetown/deserthood

/datum/loadout_item/port_clothing_head_roguetown_doublehennin
	name = "Dual hennin"
	path = /obj/item/clothing/head/roguetown/doublehennin

/datum/loadout_item/port_clothing_head_roguetown_durag
	name = "Durag"
	path = /obj/item/clothing/head/roguetown/durag

/datum/loadout_item/port_clothing_head_roguetown_eaststrawhat
	name = "Worn rice hat"
	path = /obj/item/clothing/head/roguetown/eaststrawhat

/datum/loadout_item/port_clothing_head_roguetown_explorerhat
	name = "Explorer's hat (explorerhat)"
	path = /obj/item/clothing/head/roguetown/explorerhat

/datum/loadout_item/port_clothing_head_roguetown_flamboyant
	name = "Flamboyant hat"
	path = /obj/item/clothing/head/roguetown/flamboyant

/datum/loadout_item/port_clothing_head_roguetown_flotsam
	name = "Flotsam bonnet"
	path = /obj/item/clothing/head/roguetown/flotsam

/datum/loadout_item/port_clothing_head_roguetown_gasa
	name = "Gasa"
	path = /obj/item/clothing/head/roguetown/gasa

/datum/loadout_item/port_clothing_head_roguetown_hscarf
	name = "Head scarf"
	path = /obj/item/clothing/head/roguetown/hscarf

/datum/loadout_item/port_clothing_head_roguetown_longveil
	name = "Long veil"
	path = /obj/item/clothing/head/roguetown/longveil

/datum/loadout_item/port_clothing_head_roguetown_maidhead
	name = "Maid headdress"
	path = /obj/item/clothing/head/roguetown/maidhead

/datum/loadout_item/port_clothing_head_roguetown_nightcap
	name = "Nitecap"
	path = /obj/item/clothing/head/roguetown/nightcap

/datum/loadout_item/port_clothing_head_roguetown_nunTA
	name = "Nun hood"
	path = /obj/item/clothing/head/roguetown/nunTA

/datum/loadout_item/port_clothing_head_roguetown_roningasa
	name = "Roningasa"
	path = /obj/item/clothing/head/roguetown/roningasa

/datum/loadout_item/port_clothing_head_roguetown_sandogasa
	name = "Sandogasa"
	path = /obj/item/clothing/head/roguetown/sandogasa

/datum/loadout_item/port_clothing_head_roguetown_stewardtophat
	name = "Top hat"
	path = /obj/item/clothing/head/roguetown/stewardtophat

/datum/loadout_item/port_clothing_head_roguetown_tiyon
	name = "Tiyon"
	path = /obj/item/clothing/head/roguetown/tiyon

/datum/loadout_item/port_clothing_head_roguetown_torioigasa
	name = "Torioigasa"
	path = /obj/item/clothing/head/roguetown/torioigasa

/datum/loadout_item/port_clothing_head_roguetown_twilight_elven_hat
	name = "Elven burka"
	path = /obj/item/clothing/head/roguetown/twilight_elven_hat

/datum/loadout_item/port_clothing_head_roguetown_twilight_hammerhold_hat
	name = "Kokoshnik"
	path = /obj/item/clothing/head/roguetown/twilight_hammerhold_hat

/datum/loadout_item/port_clothing_head_roguetown_veiledhat
	name = "Veiled hat"
	path = /obj/item/clothing/head/roguetown/veiledhat

/datum/loadout_item/port_clothing_mask_rogue_faceveil
	name = "Simple veil"
	path = /obj/item/clothing/mask/rogue/faceveil

/datum/loadout_item/port_clothing_neck_roguetown_cravat
	name = "Cravat"
	path = /obj/item/clothing/neck/roguetown/cravat

/datum/loadout_item/port_clothing_neck_roguetown_ruffle
	name = "Ruffled collar"
	path = /obj/item/clothing/neck/roguetown/ruffle

/datum/loadout_item/port_clothing_shoes_roguetown_courtphysician
	name = "Sanguine shoes"
	path = /obj/item/clothing/shoes/roguetown/courtphysician

/datum/loadout_item/port_clothing_shoes_roguetown_hammerhold_shoes
	name = "Hammerhold shoes"
	path = /obj/item/clothing/shoes/roguetown/hammerhold_shoes

/datum/loadout_item/port_clothing_shoes_roguetown_rosa
	name = "Ivory shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa

/datum/loadout_item/port_clothing_cloak_apron_waist_maid
	name = "Maid apron"
	path = /obj/item/clothing/cloak/apron/waist/maid

/datum/loadout_item/port_clothing_cloak_half_shadowcloak_spymaster
	name = "Hand's cloak"
	path = /obj/item/clothing/cloak/half/shadowcloak/spymaster

/datum/loadout_item/port_clothing_cloak_poncho_fancycoat_trimmed
	name = "Trimmed fancy coat"
	path = /obj/item/clothing/cloak/poncho/fancycoat/trimmed

/datum/loadout_item/port_clothing_cloak_tabard_psydontabard_black
	name = "Blessed tabard"
	path = /obj/item/clothing/cloak/tabard/psydontabard/black

/datum/loadout_item/port_clothing_cloak_tabard_psydontabard_white
	name = "Traditional tabard"
	path = /obj/item/clothing/cloak/tabard/psydontabard/white

/datum/loadout_item/port_clothing_cloak_tabard_stabard_crusader
	name = "Surcoat of the golden order"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader

/datum/loadout_item/port_clothing_cloak_tabard_toga_alt
	name = "Bared toga"
	path = /obj/item/clothing/cloak/tabard/toga/alt

/datum/loadout_item/port_clothing_cloak_tabard_toga_dress
	name = "Toga (dress)"
	path = /obj/item/clothing/cloak/tabard/toga/dress

/datum/loadout_item/port_clothing_cloak_templar_astratancleric_grey
	name = "Frayed cloak"
	path = /obj/item/clothing/cloak/templar/astratancleric/grey

/datum/loadout_item/port_clothing_cloak_templar_eoran_alt
	name = "Eoran tabard (alt)"
	path = /obj/item/clothing/cloak/templar/eoran/alt

/datum/loadout_item/port_clothing_gloves_roguetown_rosa_eight
	name = "Courtly gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/eight

/datum/loadout_item/port_clothing_gloves_roguetown_rosa_five
	name = "Sable gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/five

/datum/loadout_item/port_clothing_gloves_roguetown_rosa_four
	name = "Obsidian gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/four

/datum/loadout_item/port_clothing_gloves_roguetown_rosa_nine
	name = "Royal gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/nine

/datum/loadout_item/port_clothing_gloves_roguetown_rosa_seven
	name = "Regal gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/seven

/datum/loadout_item/port_clothing_gloves_roguetown_rosa_six
	name = "Maroon gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/six

/datum/loadout_item/port_clothing_gloves_roguetown_rosa_ten
	name = "Stately gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/ten

/datum/loadout_item/port_clothing_gloves_roguetown_rosa_three
	name = "Silvered gloves"
	path = /obj/item/clothing/gloves/roguetown/rosa/three

/datum/loadout_item/port_clothing_head_roguetown_courtphysician_female
	name = "Sanguine cap"
	path = /obj/item/clothing/head/roguetown/courtphysician/female

/datum/loadout_item/port_clothing_head_roguetown_duelhat_etrhat
	name = "Wanderer's hat"
	path = /obj/item/clothing/head/roguetown/duelhat/etrhat

/datum/loadout_item/port_clothing_head_roguetown_duelhat_etrusca
	name = "Etruscan duelist hat"
	path = /obj/item/clothing/head/roguetown/duelhat/etrusca

/datum/loadout_item/port_clothing_head_roguetown_headband_fur
	name = "Fur headband"
	path = /obj/item/clothing/head/roguetown/headband/fur

/datum/loadout_item/port_clothing_head_roguetown_menacing_executioner
	name = "Executioners hood"
	path = /obj/item/clothing/head/roguetown/menacing/executioner

/datum/loadout_item/port_clothing_head_roguetown_onhelm_tw_d_basic
	name = "Helm's chaperon"
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_basic

/datum/loadout_item/port_clothing_head_roguetown_onhelm_tw_d_horns
	name = "Horns helmkleinod"
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_horns

/datum/loadout_item/port_clothing_head_roguetown_roguehood_bishop
	name = "Bishop hood"
	path = /obj/item/clothing/head/roguetown/roguehood/bishop

/datum/loadout_item/port_clothing_head_roguetown_roguehood_burgerhood
	name = "Noble hood"
	path = /obj/item/clothing/head/roguetown/roguehood/burgerhood

/datum/loadout_item/port_clothing_head_roguetown_roguehood_eorahood
	name = "Opera hood"
	path = /obj/item/clothing/head/roguetown/roguehood/eorahood

/datum/loadout_item/port_clothing_head_roguetown_roguehood_ravox
	name = "Ravox hood"
	path = /obj/item/clothing/head/roguetown/roguehood/ravox

/datum/loadout_item/port_clothing_head_roguetown_roguehood_undivided
	name = "Undivided hood"
	path = /obj/item/clothing/head/roguetown/roguehood/undivided

/datum/loadout_item/port_clothing_head_roguetown_twilight_hammerhold_hat_peasant
	name = "Hammerhold hat"
	path = /obj/item/clothing/head/roguetown/twilight_hammerhold_hat/peasant

/datum/loadout_item/port_clothing_mask_rogue_blindfold_psydon
	name = "Blessed blindfold"
	path = /obj/item/clothing/mask/rogue/blindfold/psydon

/datum/loadout_item/port_clothing_mask_rogue_eyepatch_fake
	name = "Eyepatch"
	path = /obj/item/clothing/mask/rogue/eyepatch/fake

/datum/loadout_item/port_clothing_mask_rogue_facemask_xylixmask
	name = "Xylixian mask"
	path = /obj/item/clothing/mask/rogue/facemask/xylixmask

/datum/loadout_item/port_clothing_mask_rogue_physician_feld
	name = "Feldsher's mask"
	path = /obj/item/clothing/mask/rogue/physician/feld

/datum/loadout_item/port_clothing_mask_rogue_physician_phys
	name = "Physicker's mask"
	path = /obj/item/clothing/mask/rogue/physician/phys

/datum/loadout_item/port_clothing_mask_rogue_spectacles_sglasses
	name = "Smokey onyxa spectacles"
	path = /obj/item/clothing/mask/rogue/spectacles/sglasses

/datum/loadout_item/port_clothing_mask_rogue_spectacles_thin
	name = "Thin-lensed spectacles"
	path = /obj/item/clothing/mask/rogue/spectacles/thin

/datum/loadout_item/port_clothing_mask_rogue_xylixmask_ceramic
	name = "Ceramic mask"
	path = /obj/item/clothing/mask/rogue/xylixmask/ceramic

/datum/loadout_item/port_clothing_mask_rogue_xylixmask_weathered
	name = "Weathered mask"
	path = /obj/item/clothing/mask/rogue/xylixmask/weathered

/datum/loadout_item/port_clothing_neck_roguetown_collar_fur
	name = "Fur collar"
	path = /obj/item/clothing/neck/roguetown/collar/fur

/datum/loadout_item/port_clothing_shoes_roguetown_boots_hammerhold_boots
	name = "Hammerhold boots"
	path = /obj/item/clothing/shoes/roguetown/boots/hammerhold_boots

/datum/loadout_item/port_clothing_shoes_roguetown_courtphysician_female
	name = "Sanguine heels"
	path = /obj/item/clothing/shoes/roguetown/courtphysician/female

/datum/loadout_item/port_clothing_shoes_roguetown_rosa_eight
	name = "Courtly shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/eight

/datum/loadout_item/port_clothing_shoes_roguetown_rosa_five
	name = "Sable shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/five

/datum/loadout_item/port_clothing_shoes_roguetown_rosa_four
	name = "Obsidian shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/four

/datum/loadout_item/port_clothing_shoes_roguetown_rosa_nine
	name = "Royal shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/nine

/datum/loadout_item/port_clothing_shoes_roguetown_rosa_seven
	name = "Regal shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/seven

/datum/loadout_item/port_clothing_shoes_roguetown_rosa_ten
	name = "Stately shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/ten

/datum/loadout_item/port_clothing_shoes_roguetown_rosa_three
	name = "Silvered shoes"
	path = /obj/item/clothing/shoes/roguetown/rosa/three

/datum/loadout_item/port_clothing_suit_roguetown_shirt_courtphysician
	name = "Sanguine vest"
	path = /obj/item/clothing/suit/roguetown/shirt/courtphysician

/datum/loadout_item/port_clothing_suit_roguetown_shirt_desertbra
	name = "Desert bra"
	path = /obj/item/clothing/suit/roguetown/shirt/desertbra

/datum/loadout_item/port_clothing_suit_roguetown_shirt_explorer
	name = "Explorer's vest (explorer)"
	path = /obj/item/clothing/suit/roguetown/shirt/explorer

/datum/loadout_item/port_clothing_suit_roguetown_shirt_fancyjacket
	name = "Fancy jacket"
	path = /obj/item/clothing/suit/roguetown/shirt/fancyjacket

/datum/loadout_item/port_clothing_suit_roguetown_shirt_haori
	name = "Haori"
	path = /obj/item/clothing/suit/roguetown/shirt/haori

/datum/loadout_item/port_clothing_suit_roguetown_shirt_kamishimo
	name = "Kamishimo"
	path = /obj/item/clothing/suit/roguetown/shirt/kamishimo

/datum/loadout_item/port_clothing_suit_roguetown_shirt_kazengun_jacket
	name = "Kazengun jacket"
	path = /obj/item/clothing/suit/roguetown/shirt/kazengun_jacket

/datum/loadout_item/port_clothing_suit_roguetown_shirt_kimono
	name = "Kimono"
	path = /obj/item/clothing/suit/roguetown/shirt/kimono

/datum/loadout_item/port_clothing_suit_roguetown_shirt_kimono2
	name = "Long sleeved kimono"
	path = /obj/item/clothing/suit/roguetown/shirt/kimono2

/datum/loadout_item/port_clothing_suit_roguetown_shirt_silkbra
	name = "Giltsilk bra"
	path = /obj/item/clothing/suit/roguetown/shirt/silkbra

/datum/loadout_item/port_clothing_suit_roguetown_shirt_twilight_elven
	name = "Elven suit"
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_elven

/datum/loadout_item/port_clothing_suit_roguetown_shirt_twilight_hammerhold
	name = "Hammerhold shirt"
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold

/datum/loadout_item/port_clothing_suit_roguetown_shirt_yoroihitatare
	name = "Yoroihitatare"
	path = /obj/item/clothing/suit/roguetown/shirt/yoroihitatare

/datum/loadout_item/port_clothing_under_roguetown_loincloth_deprived
	name = "Large loincloth"
	path = /obj/item/clothing/under/roguetown/loincloth/deprived

/datum/loadout_item/port_clothing_under_roguetown_skirt_courtphysician
	name = "Sanguine skirt"
	path = /obj/item/clothing/under/roguetown/skirt/courtphysician

/datum/loadout_item/port_clothing_under_roguetown_skirt_desert
	name = "Desert skirt"
	path = /obj/item/clothing/under/roguetown/skirt/desert

/datum/loadout_item/port_clothing_under_roguetown_skirt_formal
	name = "Knee-high skirt (formal)"
	path = /obj/item/clothing/under/roguetown/skirt/formal

/datum/loadout_item/port_clothing_under_roguetown_skirt_short
	name = "Short skirt"
	path = /obj/item/clothing/under/roguetown/skirt/short

/datum/loadout_item/port_clothing_under_roguetown_tights_dhoti
	name = "Dhoti"
	path = /obj/item/clothing/under/roguetown/tights/dhoti

/datum/loadout_item/port_clothing_under_roguetown_tights_hose
	name = "Cloth hosen"
	path = /obj/item/clothing/under/roguetown/tights/hose

/datum/loadout_item/port_storage_belt_rogue_leather_belthooks
	name = "Belt hooks"
	path = /obj/item/storage/belt/rogue/leather/belthooks

/datum/loadout_item/port_storage_belt_rogue_leather_beltshawl
	name = "Belt shawl"
	path = /obj/item/storage/belt/rogue/leather/beltshawl

/datum/loadout_item/port_storage_belt_rogue_leather_hammerhold_sash
	name = "Hammerhold sash"
	path = /obj/item/storage/belt/rogue/leather/hammerhold_sash

/datum/loadout_item/port_storage_belt_rogue_leather_iron
	name = "Iron belt"
	path = /obj/item/storage/belt/rogue/leather/iron

/datum/loadout_item/port_clothing_cloak_tabard_psydontabard_white_alt
	name = "Opened traditional tabard"
	path = /obj/item/clothing/cloak/tabard/psydontabard/white/alt

/datum/loadout_item/port_clothing_cloak_tabard_stabard_crusader_astrata
	name = "Surcoat of the golden order (astrata)"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/astrata

/datum/loadout_item/port_clothing_cloak_tabard_stabard_crusader_bsteel
	name = "Surcoat of the blacksteel order"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/bsteel

/datum/loadout_item/port_clothing_cloak_tabard_stabard_crusader_heavy
	name = "Overvestments"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/heavy

/datum/loadout_item/port_clothing_cloak_tabard_stabard_crusader_t
	name = "Surcoat of the silver order"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/t

/datum/loadout_item/port_clothing_cloak_tabard_stabard_crusader_undivided
	name = "Surcoat of the golden order (undivided)"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/undivided

/datum/loadout_item/port_clothing_cloak_tabard_stabard_surcoat_short
	name = "Short jupon"
	path = /obj/item/clothing/cloak/tabard/stabard/surcoat/short

/datum/loadout_item/port_clothing_cloak_tabard_toga_dress_alt
	name = "Bared toga (alt)"
	path = /obj/item/clothing/cloak/tabard/toga/dress/alt

/datum/loadout_item/port_clothing_gloves_roguetown_fingerless_shadowgloves_spymaster
	name = "Hand's gloves"
	path = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/spymaster

/datum/loadout_item/port_clothing_head_roguetown_circlet_carvedgem_porcelain
	name = "Porcelain circlet"
	path = /obj/item/clothing/head/roguetown/circlet/carvedgem/porcelain

/datum/loadout_item/port_clothing_mask_rogue_eyepatch_left_fake
	name = "Eyepatch (fake)"
	path = /obj/item/clothing/mask/rogue/eyepatch/left/fake

/datum/loadout_item/port_clothing_mask_rogue_shepherd_shadowmask_spymaster
	name = "Hand's halfmask"
	path = /obj/item/clothing/mask/rogue/shepherd/shadowmask/spymaster

/datum/loadout_item/port_clothing_suit_roguetown_shirt_courtphysician_female
	name = "Sanguine blouse"
	path = /obj/item/clothing/suit/roguetown/shirt/courtphysician/female

/datum/loadout_item/port_clothing_suit_roguetown_shirt_dress_blue
	name = "Light blue dress (blue)"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/blue

/datum/loadout_item/port_clothing_suit_roguetown_shirt_dress_etrdress
	name = "Low-cut dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/etrdress

/datum/loadout_item/port_clothing_suit_roguetown_shirt_dress_etrdress2
	name = "Embroidered dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/etrdress2

/datum/loadout_item/port_clothing_suit_roguetown_shirt_dress_etrdress3
	name = "Strapless gown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/etrdress3

/datum/loadout_item/port_clothing_suit_roguetown_shirt_dress_green
	name = "Light green dress (green)"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/green

/datum/loadout_item/port_clothing_suit_roguetown_shirt_dress_maidfancy
	name = "Valorian maid dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/maidfancy

/datum/loadout_item/port_clothing_suit_roguetown_shirt_dress_nightgown
	name = "Nightgown (nightgown)"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/nightgown

/datum/loadout_item/port_clothing_suit_roguetown_shirt_dress_saree
	name = "Saree"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/saree

/datum/loadout_item/port_clothing_suit_roguetown_shirt_dress_tavern
	name = "Tavern dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/tavern

/datum/loadout_item/port_clothing_suit_roguetown_shirt_fancyjacket_triumph_padded
	name = "Dark jacket"
	path = /obj/item/clothing/suit/roguetown/shirt/fancyjacket/triumph_padded

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_abyssor_leader
	name = "Sylveric robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_leader

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_abyssor_painter
	name = "Rainfall robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_abyssor_painter_sea
	name = "Sea robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter_sea

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_bared
	name = "Bared robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/bared

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_hag
	name = "Wyrd robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/hag

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_leopard
	name = "Leopard robe (leopard)"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/leopard

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_nunTA
	name = "Nun dress"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/nunTA

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_ravox
	name = "Ravox robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/ravox

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_undivided
	name = "Undivided robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/undivided

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_undividedcleric
	name = "Undivided clerical robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/undividedcleric

/datum/loadout_item/port_clothing_suit_roguetown_shirt_tunic_rosa
	name = "Ivory dress"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa

/datum/loadout_item/port_clothing_suit_roguetown_shirt_tunic_rosacoat
	name = "Regal coat"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat

/datum/loadout_item/port_clothing_suit_roguetown_shirt_twilight_elven_coat
	name = "Elven coat"
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat

/datum/loadout_item/port_clothing_suit_roguetown_shirt_twilight_hammerhold_coat
	name = "Boyar coat"
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/coat

/datum/loadout_item/port_clothing_suit_roguetown_shirt_undershirt_etrdoublet
	name = "Doublet"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/etrdoublet

/datum/loadout_item/port_storage_belt_rogue_leather_battleskirt_loincloth
	name = "Cloth loincloth"
	path = /obj/item/storage/belt/rogue/leather/battleskirt/loincloth

/datum/loadout_item/port_storage_belt_rogue_leather_sash_maid
	name = "Cloth sash (maid)"
	path = /obj/item/storage/belt/rogue/leather/sash/maid

/datum/loadout_item/port_clothing_cloak_tabard_stabard_crusader_t_astrata
	name = "Surcoat of the silver order (astrata)"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/t/astrata

/datum/loadout_item/port_clothing_cloak_tabard_stabard_crusader_t_undivided
	name = "Surcoat of the silver order (undivided)"
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/t/undivided

/datum/loadout_item/port_clothing_suit_roguetown_shirt_dress_silkdress_bishop
	name = "Bishop's cassock"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/bishop

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_eora_resprite
	name = "Eoran robe (resprite)"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_leopard_alt
	name = "Open leopard robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/leopard/alt

/datum/loadout_item/port_clothing_suit_roguetown_shirt_tunic_rosa_five
	name = "Sable dress"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/five

/datum/loadout_item/port_clothing_suit_roguetown_shirt_tunic_rosa_four
	name = "Obsidian dress"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/four

/datum/loadout_item/port_clothing_suit_roguetown_shirt_tunic_rosa_six
	name = "Maroon dress"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/six

/datum/loadout_item/port_clothing_suit_roguetown_shirt_tunic_rosa_three
	name = "Velvet dress"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosa/three

/datum/loadout_item/port_clothing_suit_roguetown_shirt_tunic_rosacoat_four
	name = "Stately coat"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/four

/datum/loadout_item/port_clothing_suit_roguetown_shirt_tunic_rosacoat_two
	name = "Courtly coat"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/two

/datum/loadout_item/port_clothing_suit_roguetown_shirt_twilight_elven_coat_alt
	name = "Elven furcoat"
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat/alt

/datum/loadout_item/port_clothing_suit_roguetown_shirt_robe_eora_resprite_pink
	name = "Eoran robe (pink)"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/eora/resprite/pink
