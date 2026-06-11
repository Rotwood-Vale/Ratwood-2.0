/datum/crafting_recipe/roguetown/leather/container
	abstract_type = /datum/crafting_recipe/roguetown/leather/container
	category = "容器"

/datum/crafting_recipe/roguetown/leather/container/pouch
	name = "小袋 x2"
	result = list(/obj/item/storage/belt/rogue/pouch,
				/obj/item/storage/belt/rogue/pouch)
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	sellprice = 6
	craftdiff = 0

/datum/crafting_recipe/roguetown/leather/container/magepouch
	name = "召唤师小袋"
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1,
	)
	result = /obj/item/storage/magebag
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/container/meatbag
	name = "猎物挎包"
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/cloth = 1,
	)
	result = /obj/item/storage/meatbag
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/container/satchel
	name = "挎包"
	result = /obj/item/storage/backpack/rogue/satchel
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/container/satchelshort
	name = "短挎包"
	result = /obj/item/storage/backpack/rogue/satchel/short
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	sellprice = 15
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/container/backpack
	name = "背包"
	result = /obj/item/storage/backpack/rogue/backpack
	reqs = list(/obj/item/natural/hide/cured = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/container/waterskin
	name = "水囊"
	result = /obj/item/reagent_containers/glass/bottle/waterskin
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/container/quiver
	name = "箭袋"
	result = /obj/item/quiver
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)

/datum/crafting_recipe/roguetown/leather/container/javelinbag
	name = "标枪袋"
	result = /obj/item/quiver/javelin
	reqs = list(/obj/item/reagent_containers/food/snacks/tallow = 1,
				/obj/item/rope = 1)

/datum/crafting_recipe/roguetown/leather/container/gwstrap
	name = "重武器背带"
	result = /obj/item/rogueweapon/scabbard/gwstrap
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/rope = 1)

/datum/crafting_recipe/roguetown/leather/container/twstrap
	name = "飞刀弹带"
	result = /obj/item/twstrap
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/rope = 1)

/datum/crafting_recipe/roguetown/leather/container/hurlstrap
	name = "投掷棍弹带"
	result = /obj/item/hurlstrap
	reqs = list(/obj/item/natural/hide/cured = 3,
				/obj/item/rope = 1)

/datum/crafting_recipe/roguetown/leather/container/bmbstrap
	name = "炸弹弹带"
	result = /obj/item/bmbstrap
	reqs = list(/obj/item/natural/hide/cured = 5,
				/obj/item/rope = 2)

/datum/crafting_recipe/roguetown/leather/container/belt
	name = "皮腰带"
	result = /obj/item/storage/belt/rogue/leather
	reqs = list(/obj/item/natural/hide/cured = 1)

/datum/crafting_recipe/roguetown/leather/unleatherbelt
	name = "untie leather belt"
	result = /obj/item/natural/hide/cured
	reqs = list(/obj/item/storage/belt/rogue/leather = 1)
	craftdiff = 0
	verbage_simple = "untie"
	verbage = "unties"

/datum/crafting_recipe/roguetown/leather/container/belt/black
	name = "黑皮腰带"
	result = /obj/item/storage/belt/rogue/leather/black
	reqs = list(/obj/item/natural/hide/cured = 1)

/datum/crafting_recipe/roguetown/leather/container/belt/knifebelt
	name = "投刃腰带"
	result = /obj/item/storage/belt/rogue/leather/knifebelt
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)

/datum/crafting_recipe/roguetown/leather/container/belt/double
	name = "双联腰带"
	result = /obj/item/storage/belt/rogue/leather/double
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)

/datum/crafting_recipe/roguetown/leather/container/belt/suspenders
	name = "背带"
	result = /obj/item/storage/belt/rogue/leather/suspenders/butler
	reqs = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1,
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/container/belt/suspenders_colored
	name = "suspenders (colorable)"
	result = /obj/item/storage/belt/rogue/leather/suspenders/butler/colored
	reqs = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1,
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/container/belt/surgicalbag
	name = "外科医生包"
	result = list(/obj/item/storage/belt/rogue/surgery_bag/empty)
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/container/scabbard/sword
	name = "剑鞘"
	result = list(/obj/item/rogueweapon/scabbard/sword)
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/container/scabbard/dagger
	name = "匕首鞘"
	result = list(/obj/item/rogueweapon/scabbard/sheath)
	reqs = list(
		/obj/item/natural/hide/cured = 1)
	craftdiff = 2
