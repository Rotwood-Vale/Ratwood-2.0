/datum/crafting_recipe/roguetown/leather
	abstract_type = /datum/crafting_recipe/roguetown/leather
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	subtype_reqs = TRUE		//Makes it so fur-subtypes work. Basically if anything is just 'obj/item/natural/fur' - it'll take any fur. If it specifies 'natural/fur/direbear' - it will still require direbear.
	display_category = ITEM_CAT_ARMOR_LIGHT

/datum/crafting_recipe/roguetown/leather/bedroll
	name = "bedroll"
	result = /obj/item/bedroll
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/rope = 1)
	tools = list(/obj/item/needle)
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 2
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/peltbedsheet
	name = "bedsheet, pelt"
	result = /obj/item/bedsheet/rogue/pelt
	reqs = list(/obj/item/natural/fibers = 1,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 1
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/doublepeltbedsheet
	name = "bedsheet, double pelt"
	result = /obj/item/bedsheet/rogue/double_pelt
	reqs = list(/obj/item/natural/fibers = 1,
				/obj/item/natural/fur = 2)
	tools = list(/obj/item/needle)
	craftdiff = 1
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/corset
	name = "corset"
	result = /obj/item/clothing/suit/roguetown/armor/corset
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	sellprice = 15
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_LIGHT

/datum/crafting_recipe/roguetown/leather/gloves
	name = "leather gloves"
	result = list(/obj/item/clothing/gloves/roguetown/leather,
	/obj/item/clothing/gloves/roguetown/leather)
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 10
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/crafting_recipe/roguetown/leather/heavygloves
	name = "heavy leather gloves"
	result = /obj/item/clothing/gloves/roguetown/angle
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 20
	craftdiff = 3
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/crafting_recipe/roguetown/leather/fingerless_leather_gloves
	name = "fingerless leather gloves"
	result = /obj/item/clothing/gloves/roguetown/fingerless_leather
	reqs = list(
		/obj/item/natural/hide/cured = 1
		)
	sellprice = 20
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_GLOVES

/datum/crafting_recipe/roguetown/leather/bandana
	name = "leather bandana"
	result = /obj/item/clothing/head/roguetown/helmet/bandana
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 27
	craftdiff = 0
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/crafting_recipe/roguetown/leather/tricorn
	name = "leather tricorn"
	result = /obj/item/clothing/head/roguetown/helmet/tricorn
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 27
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/crafting_recipe/roguetown/leather/hood
	name = "leather hood"
	result = /obj/item/clothing/head/roguetown/roguehood
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 26
	craftdiff = 1
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/crafting_recipe/roguetown/leather/vest
	name = "leather vest"
	result = /obj/item/clothing/suit/roguetown/armor/leather/vest
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 1
	display_category = ITEM_CAT_ARMOR_LIGHT

/datum/crafting_recipe/roguetown/leather/bikini
	name = "leather corslet"
	result = /obj/item/clothing/suit/roguetown/armor/leather/bikini
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 26
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_LIGHT

/datum/crafting_recipe/roguetown/leather/hidebikini
	name = "hide corslet"
	result = /obj/item/clothing/suit/roguetown/armor/leather/hide/bikini
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fur = 1)
	sellprice = 26
	craftdiff = 2
	display_category = ITEM_CAT_ARMOR_LIGHT

/datum/crafting_recipe/roguetown/leather/cloak
	name = "rain cloak"
	result = /obj/item/clothing/cloak/raincloak/brown
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 2
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/apron/blacksmith
	name = "leather apron"
	result = /obj/item/clothing/cloak/apron/blacksmith
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/cloakfur
	name = "fur cloak"
	result = /obj/item/clothing/cloak/raincloak/furcloak/crafted
	reqs = list(/obj/item/natural/hide/cured = 1,/obj/item/natural/fur = 2)
	craftdiff = 2
	display_category = ITEM_CAT_TAILOR_MISC

/obj/item/clothing/cloak/raincloak/furcloak/crafted
	sellprice = 55

/datum/crafting_recipe/roguetown/leather/papakha
	name = "papakha hat"
	result = /obj/item/clothing/head/roguetown/papakha/crafted
	reqs = list(/obj/item/natural/fur = 1, /obj/item/natural/fibers = 2)
	craftdiff = 1
	display_category = ITEM_CAT_ARMOR_HELMETS

/obj/item/clothing/head/roguetown/papakha/crafted
	sellprice = 10

/datum/crafting_recipe/roguetown/leather/saddle
	name = "saddle"
	result = /obj/item/natural/saddle
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 2
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/whip
	name = "leather whip"
	result = /obj/item/rogueweapon/whip
	reqs = list(/obj/item/natural/hide/cured = 2,/obj/item/natural/stone = 1)
	sellprice = 39
	craftdiff = 1
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/crafting_recipe/roguetown/leather/drum
	name = "Drum"
	result = /obj/item/rogue/instrument/drum
	reqs = list(/obj/item/natural/hide/cured = 2,/obj/item/grown/log/tree/small = 1)
	craftdiff = 2
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/vest/sailor
	name = "leather sea jacket"
	result = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 1
	display_category = ITEM_CAT_ARMOR_LIGHT

/datum/crafting_recipe/roguetown/leather/darkcloak
	name = "dark cloak"
	result = list(/obj/item/clothing/cloak/darkcloak)
	reqs = list(/obj/item/natural/fur = 2,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 5
	sellprice = 80
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/bearcloak
	name = "direbear cloak"
	result = list(/obj/item/clothing/cloak/darkcloak/bear)
	reqs = list(/obj/item/natural/fur/direbear = 1,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 4
	sellprice = 80
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/lightbearcloak
	name = "light direbear cloak"
	result = list(/obj/item/clothing/cloak/darkcloak/bear/light)
	reqs = list(/obj/item/natural/fur/direbear = 1,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 4
	sellprice = 80
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/leathertights
	name = "leather tights"
	result = list(/obj/item/clothing/under/roguetown/trou/leathertights)
	reqs = list(/obj/item/natural/hide/cured = 2)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 10
	display_category = ITEM_CAT_ARMOR_LEGS

/datum/crafting_recipe/roguetown/leather/neck/leather_leash
	name = "leather leash"
	result = /obj/item/leash/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	always_availible = TRUE
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/skillbook
	name = "unfinished skillbook"
	result = /obj/item/skillbook/unfinished
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/paper = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	structurecraft = null//surely it's possible to stitch a book and paper together without a drying rack...
	craftdiff = 1
	always_availible = TRUE
	display_category = ITEM_CAT_BOOK_WRIT

/datum/crafting_recipe/roguetown/leather/doctormask
	name = "plague mask"
	result = /obj/item/clothing/mask/rogue/physician
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/bone = 1)
	craftdiff = 2
	display_category = ITEM_CAT_CLOTH_MASK

/datum/crafting_recipe/roguetown/leather/leathermask
	name = "leather mask"
	display_category = ITEM_CAT_ARMOR_MASKS
	result = /obj/item/clothing/mask/rogue/facemask/leather
	reqs = list(/obj/item/natural/hide/cured = 2)
	tools = list(/obj/item/needle)
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/cloak_bandolier
	name = "bandolier"
	result = /obj/item/clothing/cloak/bandolier
	reqs = list(/obj/item/natural/hide/cured = 2, /obj/item/rope = 1)
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	display_category = ITEM_CAT_TAILOR_MISC

/datum/crafting_recipe/roguetown/leather/cloak_bandolier_inq
	name = "inquisitorial bandolier"
	result = /obj/item/clothing/cloak/bandolier/inq
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_fingerless_shadowgloves_spymaster
	name = "hand's gloves"
	result = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/spymaster
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa
	name = "ivory gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_eight
	name = "courtly gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/eight
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_five
	name = "sable gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/five
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_four
	name = "obsidian gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/four
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_nine
	name = "royal gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/nine
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_seven
	name = "regal gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/seven
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_six
	name = "maroon gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/six
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_ten
	name = "stately gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/ten
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/gloves_roguetown_rosa_three
	name = "silvered gloves"
	result = /obj/item/clothing/gloves/roguetown/rosa/three
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/head_roguetown_headband_fur
	name = "fur headband"
	result = /obj/item/clothing/head/roguetown/headband/fur
	reqs = list(/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	display_category = ITEM_CAT_ARMOR_HELMETS

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_boots_hammerhold_boots
	name = "hammerhold boots"
	result = /obj/item/clothing/shoes/roguetown/boots/hammerhold_boots
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_courtphysician
	name = "sanguine shoes"
	result = /obj/item/clothing/shoes/roguetown/courtphysician
	reqs = list( /obj/item/natural/hide/cured = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 3
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_courtphysician_female
	name = "sanguine heels"
	result = /obj/item/clothing/shoes/roguetown/courtphysician/female
	reqs = list( /obj/item/natural/hide/cured = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 3
	display_category = ITEM_CAT_ARMOR_BOOTS

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_hammerhold_shoes
	name = "hammerhold shoes"
	result = /obj/item/clothing/shoes/roguetown/hammerhold_shoes
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa
	name = "ivory shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_eight
	name = "courtly shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/eight
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_five
	name = "sable shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/five
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_four
	name = "obsidian shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/four
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_nine
	name = "royal shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/nine
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_seven
	name = "regal shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/seven
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_ten
	name = "stately shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/ten
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/shoes_roguetown_rosa_three
	name = "silvered shoes"
	result = /obj/item/clothing/shoes/roguetown/rosa/three
	reqs = list( /obj/item/natural/hide/cured = 1, /obj/item/natural/silk = 2 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/suit_roguetown_shirt_tunic_rosacoat
	name = "regal coat"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat
	reqs = list( /obj/item/natural/hide/cured = 2, /obj/item/natural/silk = 2, /obj/item/alch/rosa = 1 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/suit_roguetown_shirt_tunic_rosacoat_four
	name = "stately coat"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/four
	reqs = list( /obj/item/natural/hide/cured = 2, /obj/item/natural/silk = 2, /obj/item/alch/rosa = 1 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/suit_roguetown_shirt_tunic_rosacoat_two
	name = "courtly coat"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/two
	reqs = list( /obj/item/natural/hide/cured = 2, /obj/item/natural/silk = 2, /obj/item/alch/rosa = 1 )
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	craftdiff = 5
	display_category = ITEM_CAT_GARMENT_FINE

/datum/crafting_recipe/roguetown/leather/belt_rogue_leather_belthooks
	name = "belt hooks"
	result = /obj/item/storage/belt/rogue/leather/belthooks
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/leather/belt_rogue_leather_hammerhold_sash
	name = "hammerhold sash"
	result = /obj/item/storage/belt/rogue/leather/hammerhold_sash
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON

/datum/crafting_recipe/roguetown/leather/belt_rogue_leather_iron
	name = "iron belt"
	result = /obj/item/storage/belt/rogue/leather/iron
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	display_category = ITEM_CAT_GARMENT_COMMON
