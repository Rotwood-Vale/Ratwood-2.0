/datum/crafting_recipe/roguetown/survival/skullmask
	display_category = ITEM_CAT_CLOTH_MASK
	name = "skull mask"
	category = "Clothes"
	result = /obj/item/clothing/mask/rogue/skullmask
	reqs = list(
		/obj/item/natural/bone = 3,
		/obj/item/natural/fibers = 1,
		)
	sellprice = 10
	verbage_simple = "craft"
	verbage = "crafted"
	craftdiff = 0


/datum/crafting_recipe/roguetown/survival/antlerhood
	display_category = ITEM_CAT_GARMENT_COMMON
	name = "antlerhood"
	category = "Clothes"
	result = /obj/item/clothing/head/roguetown/antlerhood
	reqs = list(
		/obj/item/natural/hide = 1,
		/obj/item/natural/bone = 2,
		)
	sellprice = 12
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	verbage_simple = "sew"
	verbage = "sews"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/tribalrags
	display_category = ITEM_CAT_GARMENT_COMMON
	name = "tribal rags"
	category = "Clothes"
	result = /obj/item/clothing/suit/roguetown/shirt/tribalrag
	reqs = list(
		/obj/item/natural/hide = 1,
		/obj/item/natural/fibers = 1,
		)
	sellprice = 6
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	verbage_simple = "sew"
	verbage = "sews"
	craftdiff = 0

/datum/crafting_recipe/roguetown/leather/neck/leather_collar
	display_category = ITEM_CAT_ARMOR_NECK
	name = "leather collar"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/collar/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	time = 8 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/neck/catbell_collar
	display_category = ITEM_CAT_ARMOR_NECK
	name = "catbell collar"
	result = /obj/item/clothing/neck/roguetown/collar/catbell
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/catbell = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/neck/cowbell_collar
	display_category = ITEM_CAT_ARMOR_NECK
	name = "cowbell collar"
	result = /obj/item/clothing/neck/roguetown/collar/cowbell
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/catbell/cow = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/neck/leather_leash
	display_category = ITEM_CAT_TAILOR_MISC
	name = "leather leash"
	result = /obj/item/leash/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/survival/goodluckcharm
	display_category = ITEM_CAT_TAILOR_MISC
	name = "cabbit's foot luck charm"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/luckcharm // +1 fortune when worn
	reqs = list(
		/obj/item/natural/rabbitsfoot = 1,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0

// BOUQUETS & CROWNS

/datum/crafting_recipe/roguetown/survival/bouquet_rosa
	display_category = ITEM_CAT_TAILOR_MISC
	name = "rosa bouquet"
	category = "Clothes"
	result = /obj/item/bouquet/rosa
	reqs = list(
		/obj/item/alch/rosa = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

/datum/crafting_recipe/roguetown/survival/bouquet_salvia
	display_category = ITEM_CAT_TAILOR_MISC
	name = "salvia bouquet"
	category = "Clothes"
	result = /obj/item/bouquet/salvia
	reqs = list(
		/obj/item/alch/salvia = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

/datum/crafting_recipe/roguetown/survival/bouquet_matricaria
	display_category = ITEM_CAT_TAILOR_MISC
	name = "matricaria bouquet"
	category = "Clothes"
	result = /obj/item/bouquet/matricaria
	reqs = list(
		/obj/item/alch/matricaria = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

/datum/crafting_recipe/roguetown/survival/bouquet_calendula
	display_category = ITEM_CAT_TAILOR_MISC
	name = "calendula bouquet"
	category = "Clothes"
	result = /obj/item/bouquet/calendula
	reqs = list(
		/obj/item/alch/calendula = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

/datum/crafting_recipe/roguetown/survival/flowercrown_rosa
	display_category = ITEM_CAT_TAILOR_MISC
	name = "rosa crown"
	category = "Clothes"
	result = /obj/item/flowercrown/rosa
	reqs = list(
		/obj/item/alch/rosa = 4,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0
	verbage_simple = "tied"
	verbage = "ties"

/datum/crafting_recipe/roguetown/survival/flowercrown_salvia
	display_category = ITEM_CAT_TAILOR_MISC
	name = "salvia crown"
	category = "Clothes"
	result = /obj/item/flowercrown/salvia
	reqs = list(
		/obj/item/alch/salvia = 4,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0
	verbage_simple = "tied"
	verbage = "ties"

// Amulet
/datum/crafting_recipe/roguetown/survival/pearlcross
	display_category = ITEM_CAT_TAILOR_MISC
	name = "amulet (pearls)"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/pearl
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/pearl = 3,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/bpearlcross
	display_category = ITEM_CAT_TAILOR_MISC
	name = "amulet (blue pearls) "
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/bpearl
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/pearl/blue = 3,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/shellnecklace
	display_category = ITEM_CAT_TAILOR_MISC
	name = "shell necklace"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/shell
	reqs = list(
		/obj/item/oystershell = 5,
		/obj/item/natural/fibers = 1,
		)

/datum/crafting_recipe/roguetown/survival/shellbracelet
	display_category = ITEM_CAT_TAILOR_MISC
	name = "shell bracelet"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/shell/bracelet
	reqs = list(
		/obj/item/oystershell = 3,
		/obj/item/natural/fibers = 1,
		)

/datum/crafting_recipe/roguetown/survival/abyssoramulet
	display_category = ITEM_CAT_TAILOR_MISC
	name = "amulet of abyssor"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/abyssor
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/pearl/blue = 1,
		)

/datum/crafting_recipe/roguetown/survival/woodcross
	display_category = ITEM_CAT_TAILOR_MISC
	name = "wooden psycross"
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/wickercloak
	display_category = ITEM_CAT_GARMENT_COMMON
	name = "wicker cloak"
	category = "Clothes"
	result = /obj/item/clothing/cloak/wickercloak
	reqs = list(
		/obj/item/natural/dirtclod = 1,
		/obj/item/grown/log/tree/stick = 5,
		/obj/item/natural/fibers = 3,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/mentorhat
	name = "worn bamboo hat"
	category = "Clothes"
	result = /obj/item/clothing/head/roguetown/mentorhat
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/fibers = 2,
		)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3
