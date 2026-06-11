/datum/crafting_recipe/roguetown/leather/armor
	abstract_type = /datum/crafting_recipe/roguetown/leather/armor
	category = "护甲"

/datum/crafting_recipe/roguetown/leather/armor/lgorget
	name = "硬化皮护喉"
	result = /obj/item/clothing/neck/roguetown/leather
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/armor/heavybracers
	name = "硬化皮护臂"
	result = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/armor/bracers
	name = "皮护臂"
	result = /obj/item/clothing/wrists/roguetown/bracers/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 10
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/armor/pants
	name = "皮裤"
	result = /obj/item/clothing/under/roguetown/trou/leather
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 10
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/armor/volfhelm
	name = "沃尔夫 头盔"
	result = list(/obj/item/clothing/head/roguetown/helmet/leather/volfhelm)
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fur/wolf = 1, /obj/item/natural/head/volf = 1)
	sellprice = 20
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/armor/volfmantle
	name = "沃尔夫 披肩"
	result = /obj/item/clothing/cloak/volfmantle
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/head/volf = 1)

/datum/crafting_recipe/roguetown/leather/armor/saigahelm
	name = "黄羊头骨盔"
	result = list(/obj/item/clothing/head/roguetown/helmet/leather/saiga)
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/hide = 2, /obj/item/natural/head/saiga = 1)
	sellprice = 20
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_pants
	name = "硬化皮裤"
	result = list(/obj/item/clothing/under/roguetown/heavy_leather_pants)
	reqs = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1,
		)
	sellprice = 20
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_pants/shorts
	name = "硬化皮短裤"
	result = list(/obj/item/clothing/under/roguetown/heavy_leather_pants/shorts)
	reqs = list(
		/obj/item/natural/hide/cured = 2, //they cover less, you see
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1,
		)
	sellprice = 20
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/armor/helmet/advanced
	name = "硬化皮头盔"
	result = /obj/item/clothing/head/roguetown/helmet/leather/advanced
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/reagent_containers/food/snacks/tallow = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/armor/armor
	name = "皮甲"
	result = /obj/item/clothing/suit/roguetown/armor/leather
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/armor/cuirass
	name = "皮胸甲"
	result = /obj/item/clothing/suit/roguetown/armor/leather/cuirass
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/armor/hidearmor
	name = "兽皮甲"
	result = /obj/item/clothing/suit/roguetown/armor/leather/hide
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fur = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor
	name = "硬化皮甲"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	reqs = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/armor/freivest
	name = "击剑短上衣"	//Expensive on purpose.
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter
	reqs = list(
		/obj/item/natural/hide/cured = 4,
		/obj/item/reagent_containers/food/snacks/tallow = 2,
		/obj/item/natural/fibers = 4
	)
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor/coat
	name = "硬化皮外套"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	reqs = list(
		/obj/item/natural/hide/cured = 4,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor/jacket
	name = "硬化皮夹克"
	result = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket
	reqs = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/armor/helmet
	name = "皮头盔"
	result = /obj/item/clothing/head/roguetown/helmet/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/studhood
	name = "加垫皮兜帽"
	result = /obj/item/clothing/head/roguetown/helmet/leather/armorhood
	reqs = list(/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/armor/duelcoat
	name = "皮外套"
	result = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	reqs = list(
		/obj/item/natural/hide/cured = 4,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 1)
	craftdiff = 5
