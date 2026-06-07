
//////////////
/// Tools ///
////////////


/datum/artificer_recipe/tools
	i_type = "Tools"
	hammers_per_item = 5
	skill_level = 2

/datum/artificer_recipe/tools/wrench
	name = "Engineering Wrench (+1 cog)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/contraption/linker
	additional_items = list(/obj/item/roguegear/bronze)

/datum/artificer_recipe/tools/headhook
	name = "Headhook, Bronze (+2 Fibers)"
	required_item = /obj/item/ingot/bronze
	created_item = /obj/item/storage/hip/headhook/bronze
	additional_items = list(/obj/item/natural/fibers, /obj/item/natural/fibers)

/datum/artificer_recipe/tools/ironscissors
	name = "Iron Scissors (+1 cog)"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/roguegear/bronze)
	created_item = /obj/item/rogueweapon/huntingknife/scissors

/datum/artificer_recipe/tools/steelscissors
	name = "Steel Scissors (+1 Bronze Cog)"
	required_item = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegear/bronze)
	created_item = /obj/item/rogueweapon/huntingknife/scissors/steel

/datum/artificer_recipe/tools/keys
	name = "Key (x3)"
	required_item = /obj/item/ingot/bronze
	created_item = list(/obj/item/customblank, /obj/item/customblank, /obj/item/customblank)

/datum/artificer_recipe/tools/lamptern
	name = "Lamptern, Bronze (x3)"
	required_item = /obj/item/ingot/bronze
	created_item = list(/obj/item/flashlight/flare/torch/lantern/bronzelamptern, /obj/item/flashlight/flare/torch/lantern/bronzelamptern,
						/obj/item/flashlight/flare/torch/lantern/bronzelamptern)

/datum/artificer_recipe/tools/locks
	name = "Lock (x3)"
	required_item = /obj/item/ingot/bronze
	created_item = list(/obj/item/customlock, /obj/item/customlock, /obj/item/customlock)

/datum/artificer_recipe/tools/lockpicks
	name = "Lockpick (x3)"
	required_item = /obj/item/ingot/iron
	created_item = list(/obj/item/lockpick, /obj/item/lockpick, /obj/item/lockpick)

/datum/artificer_recipe/tools/lockpickring
	name = "Lockpickring (x3)"
	required_item = /obj/item/ingot/iron
	created_item = list(/obj/item/lockpickring, /obj/item/lockpickring, /obj/item/lockpickring)

/datum/artificer_recipe/tools/flint
	name = "Striking Flint x3 (+1 stone)"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/stone)
	created_item = list(/obj/item/flint, /obj/item/flint, /obj/item/flint)

/datum/artificer_recipe/tools/wooden_mallet
	name = "Wooden Mallet"
	required_item = /obj/item/grown/log/tree/small
	created_item = /obj/item/rogueweapon/hammer/wood
	hammers_per_item = 4
