/datum/crafting_recipe/roguetown/fishing
	req_table = TRUE

/obj/item/fishingnet

/datum/crafting_recipe/roguetown/fishing/bait
	verbage = "rolls"

/datum/crafting_recipe/roguetown/fishing/bait/red
	name = "chum bait"
	result = list(/obj/item/fishing/bait/meat)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince = 2)

/datum/crafting_recipe/roguetown/fishing/bait/dough
	name = "doughy bait"
	result = list(/obj/item/fishing/bait/dough, /obj/item/fishing/bait/dough)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/doughslice = 1)

/datum/crafting_recipe/roguetown/fishing/bait/gray
	name = "gray bait"
	result = list(/obj/item/fishing/bait/gray)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish = 1,
					/obj/item/reagent_containers/powder/flour = 1)

/datum/crafting_recipe/roguetown/fishing/bait/speckled
	name = "speckled bait"
	result = list(/obj/item/fishing/bait/speckled)
	reqs = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish = 1,
					/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1,
					/obj/item/reagent_containers/powder/flour = 1)

/datum/crafting_recipe/roguetown/fishing/bait/fly
	name = "fly bait"
	result = list(/obj/item/fishing/bait/fly)
	reqs = list(/obj/item/natural/feather = 1,
					/obj/item/natural/fibers = 1)

/datum/crafting_recipe/roguetown/fishing/bait/deluxe
	name = "enchanted bait"
	result = list(/obj/item/fishing/bait/deluxe)
	reqs = list(/obj/item/fishing/bait/speckled = 1,
					/obj/item/reagent_containers/food/snacks/grown/manabloom = 1)

/datum/crafting_recipe/roguetown/fishing/reel/twine
	name = "twine fishing line"
	result = list(/obj/item/fishing/reel/twine)
	reqs = list(/obj/item/natural/fibers = 4,
					/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/fishing/reel/leather
	name = "leather fishing line"
	result = list(/obj/item/fishing/reel/leather)
	reqs = list(/obj/item/natural/hide/cured = 2,
					/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/fishing/reel/silk
	name = "silk fishing line"
	result = list(/obj/item/fishing/reel/silk)
	reqs = list(/obj/item/natural/silk = 2,
					/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/fishing/reel/deluxe
	name = "deluxe fishing line"
	result = list(/obj/item/fishing/reel/deluxe)
	reqs = list(/obj/item/fishing/reel/silk = 4,
					/obj/item/natural/fibers = 4,
					/obj/item/natural/hide/cured = 2,
					/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/fishing/woodenhook
	name = "wooden fishing hook"
	result = list(/obj/item/fishing/hook/wooden)
	reqs = list(/obj/item/grown/log/tree/small = 1,
					/obj/item/natural/fibers = 1,
					/obj/item/natural/thorn = 1)

/datum/crafting_recipe/roguetown/fishing/thornhook
	name = "thorn fishing hook"
	result = list(/obj/item/fishing/hook/thorn)
	reqs = list(/obj/item/natural/thorn = 1,
					/obj/item/natural/fibers = 1,
					/obj/item/grown/log/tree/stick = 1)

/datum/crafting_recipe/roguetown/fishing/deluxehook
	name = "wooden lure"
	result = list(/obj/item/fishing/hook/deluxe)
	reqs = list(/obj/item/fishing/hook/wooden = 1,
					/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)

/datum/crafting_recipe/roguetown/fishing/woodenbobber
	name = "wooden bobber"
	result = list(/obj/item/fishing/line/bobber)
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 1, /obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/fishing/stonesinker
	name = "stone sinker"
	result = list(/obj/item/fishing/line/sinker)
	reqs = list(/obj/item/natural/fibers = 2, /obj/item/natural/stone = 1)

/datum/crafting_recipe/roguetown/fishing/net
	name = "fishing net"
	result = list(/obj/item/fishingnet)
	reqs = list(/obj/item/rope = 6)
