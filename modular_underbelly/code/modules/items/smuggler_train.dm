/*
	SMUGGLER TRAIN
	Every 30-60 minutes, a shipment of contraband drops at the marked landing area.
	Place /obj/effect/landmark/smuggler_drop tiles on the map where crates should appear.
	Leftover crates from the previous run are destroyed when the next one fires.
	Everyone on the same Z level hears the rumble.
*/

GLOBAL_VAR(smuggler_train)

/obj/effect/landmark/smuggler_drop
	name = "smuggler drop point"

/obj/effect/landmark/smuggler_drop/Initialize(mapload)
	. = ..()
	if(!GLOB.smuggler_train)
		GLOB.smuggler_train = new /datum/smuggler_train()

// The crates that appear at each drop point
/obj/structure/closet/crate/chest/crate/smuggler
	name = "cargo crate"
	desc = "A battered wooden crate. Whoever packed this wasn't planning to get caught."

/datum/smuggler_train
	var/list/active_crates = list()

/datum/smuggler_train/New()
	addtimer(CALLBACK(src, PROC_REF(arrive)), rand(30 MINUTES, 60 MINUTES))

/datum/smuggler_train/proc/arrive()
	for(var/obj/A in active_crates)
		if(!QDELETED(A))
			qdel(A)
	active_crates.Cut()

	var/target_z = 0
	for(var/obj/effect/landmark/smuggler_drop/L in GLOB.landmarks_list)
		if(!target_z)
			target_z = L.z
		var/obj/structure/closet/crate/chest/crate/smuggler/crate = new(L.loc)
		fill_crate(crate)
		active_crates += crate

	if(target_z)
		for(var/client/C in GLOB.clients)
			if(C.mob && C.mob.z == target_z)
				C << sound('modular_underbelly/sound/train_arrive.ogg', volume = 80)
				to_chat(C.mob, span_warning("A low rumble shakes the pipes above. Something came through."))

	addtimer(CALLBACK(src, PROC_REF(arrive)), rand(30 MINUTES, 60 MINUTES))

/datum/smuggler_train/proc/fill_crate(obj/structure/closet/crate/chest/crate/smuggler/C)
	var/T
	switch(rand(1, 4))
		if(1) // weapons & tools
			for(var/i in 1 to rand(2, 3))
				T = pick(
					30; /obj/item/rogueweapon/huntingknife/idagger/steel,
					25; /obj/item/rogueweapon/huntingknife/idagger/navaja,
					20; /obj/item/rogueweapon/katar/punchdagger,
					18; /obj/item/lockpick,
					15; /obj/item/lockpickring/mundane,
					15; /obj/item/rogueweapon/knuckles,
					12; /obj/item/rogueweapon/mace/cudgel,
					12; /obj/item/rogueweapon/spear,
					10; /obj/item/rogueweapon/flail,
					8;  /obj/item/rogueweapon/sword/short,
					6;  /obj/item/rogueweapon/mace/warhammer,
					5;  /obj/item/rogueweapon/stoneaxe/woodcut/steel,
					3;  /obj/item/rogueweapon/knuckles/defacer,
					1;  /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller,
					1;  /obj/item/gun/ballistic/firearm/cannon,
					1;  /obj/item/ammo_casing/caseless/bullet/cannonball,
				)
				new T(C)
		if(2) // valuables
			new /obj/item/roguecoin/gold(C, rand(8, 20))
			for(var/i in 1 to rand(1, 3))
				T = pick(
					30; /obj/item/ingot/iron,
					25; /obj/item/ingot/steel,
					20; /obj/item/ingot/silver,
					15; /obj/item/ingot/gold,
					5;  /obj/item/ingot/blacksteel,
					5;  /obj/item/ingot/silverblessed,
				)
				new T(C)
		if(3) // reagents
			for(var/i in 1 to rand(3, 5))
				T = pick(
					30; /obj/item/reagent_containers/glass/bottle/rogue/healthpot,
					20; /obj/item/reagent_containers/glass/bottle/rogue/stampot,
					15; /obj/item/reagent_containers/glass/bottle/rogue/manapot,
					15; /obj/item/reagent_containers/glass/bottle/rogue/poison,
					10; /obj/item/reagent_containers/glass/bottle/rogue/beer/ratkept,
					10; /obj/item/reagent_containers/glass/bottle/rogue/blood_red,
				)
				new T(C)
		if(4) // supplies
			for(var/i in 1 to rand(3, 5))
				T = pick(
					20; /obj/item/reagent_containers/food/snacks/rogue/bread,
					20; /obj/item/reagent_containers/food/snacks/rogue/meat/steak,
					15; /obj/item/reagent_containers/food/snacks/rogue/meat/sausage,
					15; /obj/item/seeds/apple,
					10; /obj/item/seeds/berryrogue,
					10; /obj/item/seeds/potato,
					10; /obj/item/seeds/garlick,
				)
				new T(C)
