
/datum/supply_pack/rogue/Supplies
	group = "Supplies"
	crate_name = "Gifts of Toil"
	crate_type = /obj/structure/closet/crate/chest/merchant

//////////////
// SUPPLIES //
//////////////

/datum/supply_pack/rogue/Supplies/cloth
	name = "Cloth"
	cost = 2
	contains = list(/obj/item/natural/cloth)

/datum/supply_pack/rogue/Supplies/rope
	name = "Rope"
	cost = 5
	contains = list(/obj/item/rope)

/datum/supply_pack/rogue/Supplies/chain
	name = "Chain"
	cost = 5
	contains = list(/obj/item/rope/chain)

/datum/supply_pack/rogue/Supplies/Satchel
	name = "Satchel"
	cost = 10
	contains = list(/obj/item/storage/backpack/rogue/satchel)

/datum/supply_pack/rogue/Supplies/backpack
	name = "Backpack"
	cost = 15
	contains = list(/obj/item/storage/backpack/rogue/backpack)

/datum/supply_pack/rogue/Supplies/belt
	name = "Leather Belt"
	cost = 5
	contains = list(/obj/item/storage/belt/rogue/leather)

/datum/supply_pack/rogue/Supplies/sack
	name = "Sack"
	cost = 5
	contains = list(/obj/item/storage/roguebag)

/datum/supply_pack/rogue/Supplies/scroll
	name = "Scroll"
	cost = 5
	contains = list(/obj/item/paper/scroll)

/datum/supply_pack/rogue/Supplies/paper
	name = "Paper"
	cost = 2
	contains = list(/obj/item/paper)

/datum/supply_pack/rogue/Supplies/quill
	name = "Quill"
	cost = 2
	contains = list(/obj/item/natural/feather)

/datum/supply_pack/rogue/Supplies/hardtack
	name = "Hardtack"
	cost = 10
	contains = list(/obj/item/reagent_containers/food/snacks/rogue/crackerscooked)

/datum/supply_pack/rogue/Supplies/needle
	name = "Needle"
	cost = 5
	contains = list(/obj/item/needle)

/datum/supply_pack/rogue/Supplies/Lamp
	name = "Lamptern"
	cost = 5
	contains = list(/obj/item/flashlight/flare/torch/lantern)

/datum/supply_pack/rogue/Supplies/gwstrap
	name = "Greatweapon Strap"
	cost = 15
	contains = list(/obj/item/rogueweapon/scabbard/gwstrap)

/datum/supply_pack/rogue/Supplies/scabbard
	name = "Sword Scabbard"
	cost = 10
	contains = list(/obj/item/rogueweapon/scabbard/sword)

/datum/supply_pack/rogue/Supplies/sheath
	name = "Dagger Sheath"
	cost = 5
	contains = list(/obj/item/rogueweapon/scabbard/sheath)

/datum/supply_pack/rogue/Supplies/hknife
	name = "Hunting Knife"
	cost = 5
	contains = list(/obj/item/rogueweapon/huntingknife)

/datum/supply_pack/rogue/Supplies/dagger
	name = "Iron Dagger"
	cost = 10
	contains = list(/obj/item/rogueweapon/huntingknife/idagger)

/datum/supply_pack/rogue/Supplies/daggerss
	name = "Steel Dagger"
	cost = 20
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/steel)

/datum/supply_pack/rogue/Supplies/daggersil
	name = "Silver Dagger"
	cost = 80
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/silver)

/datum/supply_pack/rogue/Supplies/Waterskin
	name = "Waterskin"
	cost = 10
	contains = list(/obj/item/reagent_containers/glass/bottle/waterskin)

/datum/supply_pack/rogue/Supplies/flint
	name = "Flint"
	cost = 5
	contains = list(/obj/item/flint)

/datum/supply_pack/rogue/Supplies/chalk
	name = "Stick Of Chalk"
	cost = 5
	contains = list(/obj/item/chalk)

/datum/supply_pack/rogue/Supplies/bedroll
	name = "Bedroll"
	cost = 5
	contains = list(/obj/item/bedroll)

/datum/supply_pack/rogue/Supplies/soap
	name = "Bar of Soap"
	cost = 10	// Hahaha why not
	contains = list(/obj/item/soap)

//////////////
// UTILITY //
//////////////

/datum/supply_pack/rogue/Supplies/rubyband
	name = "Matthian SCOMSTONE"
	cost = 20
	contains = list(/obj/item/mattcoin)

/datum/supply_pack/rogue/Supplies/Dragonscale
	name = "Dragonscale Necklace"
	cost = 1200
	contains = list(/obj/item/clothing/neck/roguetown/dragon_scale)

/datum/supply_pack/rogue/Supplies/smokebomb
	name = "Smoke Bomb"
	cost = 30
	contains = list(/obj/item/bomb/smoke)

/datum/supply_pack/rogue/Supplies/bomb
	name = "Fire Bomb"
	cost =	60
	contains = list(/obj/item/bomb)

/datum/supply_pack/rogue/Supplies/leathercollar
	name = "Leather Collar"
	cost =	20
	contains = list(/obj/item/clothing/neck/roguetown/collar/leather)

/datum/supply_pack/rogue/Supplies/chainleash
	name = "Chain Leash"
	cost =	20
	contains = list(/obj/item/leash/chain)

/datum/supply_pack/rogue/Supplies/lockpicks
	name = "Lockpicks"
	cost = 25	// More expensive if your class doesn't have them.
	contains = list(/obj/item/lockpickring/mundane)

/datum/supply_pack/rogue/Supplies/grapplinghook
	name =	"Grappling Hook"
	cost =	1000	// You're better off stealing this.
	contains = list(/obj/item/grapplinghook)

/datum/supply_pack/rogue/Supplies/climbing_gear
	name = "Climbing Gear"
	cost = 800		// Really fucking good, you can drop down z-levels and hang there. 
	contains = list(/obj/item/clothing/climbing_gear)

/datum/supply_pack/rogue/Supplies/pick
	name = "Iron Pick"
	cost = 12		// Also a thing you can just kinda find, though moderately useful.
	contains = list(/obj/item/rogueweapon/pick)

/datum/supply_pack/rogue/Supplies/pick/steel
	name = "Steel Pick"
	cost = 35
	contains = list(/obj/item/rogueweapon/pick/steel)

//////////////
// COOKING  //		//Very basic ingredients. Nothing like meat or fruits, you can go and get those yourself. Buying components for everyone on your own will add up quickly. What are YOU bringing for the Matthios potluck?
//////////////

/datum/supply_pack/rogue/Supplies/cooking/flour
	name = "Flour"
	cost = 2	//Base component.
	contains = list(/obj/item/reagent_containers/powder/flour)

/datum/supply_pack/rogue/Supplies/cooking/rice
	name = "Rice Grains"
	cost = 2	//Base component.
	contains = list(/obj/item/reagent_containers/food/snacks/grown/rice)

/datum/supply_pack/rogue/Supplies/cooking/butter
	name = "Butter"
	cost = 5	//Base component.
	contains = list(/obj/item/reagent_containers/food/snacks/butter)

/datum/supply_pack/rogue/Supplies/cooking/carrot
	name = "Raw Carrot"
	cost = 2	//Base component.
	contains = list(/obj/item/reagent_containers/food/snacks/grown/carrot)

/datum/supply_pack/rogue/Supplies/cooking/cackleberry
	name = "One Egg"
	cost = 2	//Base component.
	contains = list(/obj/item/reagent_containers/food/snacks/egg)

/datum/supply_pack/rogue/Supplies/cooking/peppermill
	name = "Pepper Mill"
	cost = 35	//You're basically paying for an OK quantity of easy steak meals.
	contains = list(/obj/item/reagent_containers/peppermill)
