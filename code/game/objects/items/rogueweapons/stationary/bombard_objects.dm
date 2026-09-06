/*
Firstly, the coordinates device. Eventually, I'll add free aim. But for now...
*/
/obj/item/rogueweapon/palantir
	name = "\improper palantir"
	desc = "An arcyne compass, runed and imbued with energy. \
	That is, of course, to say that this is able to detect leyline intersection points. Or LIPs, for short. \
	An incredibly expensive device, likely pried from one of the Queen's own magicians."
	icon = 'icons/roguetown/weapons/stationary/bombard.dmi'
	icon_state = "compass"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	force = 5
	possible_item_intents = list(INTENT_GENERIC)
	var/last_x = "UNKNOWN"
	var/last_y = "UNKNOWN"
	var/last_z = "UNKNOWN"

/obj/item/rogueweapon/palantir/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_FUSILIER))
		. += "<small>Last 'X-LIP' recorded: <span class='warning'>[last_x]</span> <br>\
			Last 'Y-LIP' recorded: <span class='warning'>[last_y]</span> <br>\
			Last 'Z-LIP' recorded: <span class='warning'>[last_z]</span></small>"
	else
		. += "<small>As expected, you've no understanding of the smaller details. Someone trained with smokepowder might know...</small>"

/obj/item/rogueweapon/palantir/afterattack(atom/A, mob/living/user, adjacent, params) //handles coord obtaining
	if(!HAS_TRAIT(user, TRAIT_FUSILIER))
		to_chat(user, "<span class='warning'>This device is beyond your understanding...</span>")
		return
	to_chat(user, "Calculating leyline intersection point. Stand still.")
	loud_message("A palantir's loud whine can be heard", hearing_distance = 24)//"ZEZUZ PYST FROM WHERE?!!"
	if(do_after(user, 12 SECONDS, src))
		A = get_turf(A)
		last_x = obfuscate_x(A.x)
		last_y = obfuscate_y(A.y)
		last_z = A.z
		to_chat(user, "INTERSECTION POINT OF TARGET <br>\
		<small>X-LIP: <span class='warning'>[last_x]</span> <br>\
		Y-LIP: <span class='warning'>[last_y]</span> <br>\
		Z-LIP: <span class='warning'>[last_z]</span></small>")
	else
		to_chat(user, "<span class='warning'>You must remain still!</span>")

//This is a weapon because it makes me chuckle. Sorry.
/obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge
	name = "powder ram"
	desc = "A bulky, heavy rod with a sponge at one end, and a fool at the other. Wholly unsuited for combat."
	icon = 'icons/roguetown/weapons/stationary/bombard64.dmi'
	icon_state = "ramrod"
	item_state = "ramrod"
	w_class = WEIGHT_CLASS_BULKY
	force = 5
	force_wielded = 10
	max_integrity = 25
	wdefense = 2
	wdefense_wbonus = 2
	possible_item_intents = list(INTENT_GENERIC)

//The portable bombard's frame, lacking a barrel.
/obj/item/bombard_frame
	name = "\improper light bombard frame"
	desc = "A light bombard's frame. If you'd the barrel, you could set up a light bombard... <br>\
	<small>To do so, you must have both pieces and 'craft' it.</small>"
	icon = 'icons/roguetown/weapons/stationary/bombard.dmi'
	icon_state = "kit_frame"
	w_class = WEIGHT_CLASS_BULKY
	force = 5
	possible_item_intents = list(INTENT_GENERIC)

//And the barrel it lacks.
/obj/item/bombard_barrel
	name = "\improper light bombard barrel"
	desc = "A light bombard's barrel. If you'd the frame, you could set up a light bombard... <br>\
	<small>To do so, you must have both pieces and 'craft' it.</small>"
	icon = 'icons/roguetown/weapons/stationary/bombard.dmi'
	icon_state = "kit_barrel"
	w_class = WEIGHT_CLASS_BULKY
	force = 5
	possible_item_intents = list(INTENT_GENERIC)

//And the recipe in which we hold it hostage. It shouldn't be survival, but, whatever.
/datum/crafting_recipe/roguetown/survival/bombard
	name = "Portable Bombard (Barrel and Frame)"
	result = /obj/structure/bombard
	category = "Ranged"
	reqs = list(
		/obj/item/bombard_frame = 1,
		/obj/item/bombard_barrel = 1
		)
	skillcraft = /datum/skill/combat/firearms
	craftdiff = 1
	time = 60
