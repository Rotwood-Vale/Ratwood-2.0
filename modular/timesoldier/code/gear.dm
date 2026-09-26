/obj/item/storage/backpack/rogue/satchel/short/timesoldier_ifak
	name = "individiual aid satchel"
	desc = "<span class='yellow'><i>Whenever crates of this stuff came around, we knew we'd have to start digging into our own wounds that following dae. Doubles as a small satchel, too.</i></span>"
	icon = 'modular/timesoldier/sprites/gear.dmi'
	icon_state = "ifak" // ditto as above

/obj/item/reagent_containers/glass/bottle/waterskin/timesoldier
	name = "iron canteen"
	desc = "Also known as the Metal Waterskin, it's commonly used by the Grenzelhoft Military in long expeditions. How did it end up here, though?"
	desc = "Also known as the Metal Waterskin. The cap has been removed."
	icon = 'modular/timesoldier/sprites/gear.dmi'
	icon_state = "canteen"

	volume = 225
	list_reagents = list(
		/datum/reagent/water = 200,
		/datum/reagent/consumable/ethanol/gin = 25
	)
