/*
	SMUGGLER TRAIN
	Every 25-45 minutes, a shipment of contraband drops at the marked landing area.
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
	addtimer(CALLBACK(src, PROC_REF(arrive)), rand(25 MINUTES, 45 MINUTES))

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
		var/list/notified = list()
		for(var/obj/effect/landmark/smuggler_drop/L in GLOB.landmarks_list)
			for(var/client/C in GLOB.clients)
				if(C in notified)
					continue
				if(!C.mob)
					continue
				if(abs(C.mob.z - L.z) > 1)
					continue
				if(get_dist(C.mob, L) > 20)
					continue
				notified += C
				C << sound('modular_underbelly/sound/train_arrive.ogg', volume = 80)
				to_chat(C.mob, span_warning("A the dock's bell sounds out in the docks. Something arrived."))

	addtimer(CALLBACK(src, PROC_REF(arrive)), rand(25 MINUTES, 45 MINUTES))

/datum/smuggler_train/proc/fill_crate(obj/structure/closet/crate/chest/crate/smuggler/C)
	var/T
	switch(rand(1, 8))
		if(1) // weapons & tools
			C.name = "old weapons crate"
			C.desc = "A battered wooden crate with iron corner guards. It rattles when you move it."
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
				5;  /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller,
				5;  /obj/item/gun/ballistic/firearm/cannon,
				5;  /obj/item/ammo_casing/caseless/bullet/cannonball,
				)
				new T(C)
		if(2) // valuables
			C.name = "strongbox crate"
			C.desc = "A heavy crate reinforced with iron banding. Something inside shifts with a dull clunk."
			new /obj/item/roguecoin/gold(C, rand(10, 25))
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
			C.name = "apothecary crate"
			C.desc = "A crate packed with straw and glass. Handle it carefully."
			for(var/i in 1 to rand(3, 6))
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
			C.name = "provisions crate"
			C.desc = "A plain wooden crate sealed with cheap wax. Smells faintly of bread and earth."
			for(var/i in 1 to rand(5, 12))
				T = pick(
					25; /obj/item/reagent_containers/food/snacks/rogue/bread,
					20; /obj/item/reagent_containers/food/snacks/rogue/crackerscooked,
					18; /obj/item/reagent_containers/food/snacks/butterslice,
					18; /obj/item/reagent_containers/food/snacks/egg,
					20; /obj/item/reagent_containers/food/snacks/rogue/meat/steak,
					20; /obj/item/reagent_containers/food/snacks/rogue/meat/sausage,
					18; /obj/item/reagent_containers/food/snacks/rogue/meat/gabagool,
					15; /obj/item/reagent_containers/food/snacks/grown/wheat,
					12; /obj/item/reagent_containers/glass/bottle/rogue/beer/ratkept,
					12; /obj/item/reagent_containers/glass/bottle/rogue/beer/hagwoodbitter,
					12; /obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat,
					10; /obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead,
					15; /obj/item/seeds/apple,
					12; /obj/item/seeds/berryrogue,
					12; /obj/item/seeds/potato,
					12; /obj/item/seeds/garlick,
				)
				new T(C)
		if(5) // gun supplies
			C.name = "weapons cache"
			C.desc = "A crate with a powder warning scratched into the lid. Whoever sent this knew what they were doing."
			new /obj/item/powderflask(C)
			new /obj/item/quiver/bullet/lead/extended(C)
			for(var/i in 1 to rand(3, 6))
				T = pick(
					35; /obj/item/gun/ballistic/firearm/arquebus_pistol/ironshot,
					35; /obj/item/gun/ballistic/firearm/abomination,
					15; /obj/item/gun/ballistic/firearm/arquebus_pistol/gut_spiller,
					35; /obj/item/quiver/bullet/lead/extended,
					25; /obj/item/powderflask,
					18; /obj/item/quiver/bullet/lead,
					10; /obj/item/quiver/bullet/grapeshot,
					10; /obj/item/underbelly_upgrade/damage,
					10; /obj/item/underbelly_upgrade/silencer,
					10; /obj/item/underbelly_upgrade/capacity,
					10; /obj/item/underbelly_upgrade/aim,
					5;  /obj/item/ammo_casing/caseless/bullet/cannonball,
					5;  /obj/item/gun/ballistic/firearm/cannon,
				)
				new T(C)
		if(6) // flinger shipment - bulk parcels, same stock the shop sells
			C.name = "trade shipment crate"
			C.desc = "A large crate stuffed with wrapped parcels. Each one's got a delivery mark on it that nobody's going to collect."
			for(var/i in 1 to rand(5, 9))
				T = pick(
					30; /obj/item/underbelly_shipment/gabagool,
					25; /obj/item/underbelly_shipment/flour,
					22; /obj/item/underbelly_shipment/grain,
					18; /obj/item/underbelly_shipment/wood,
					15; /obj/item/underbelly_shipment/iron_ore,
					10; /obj/item/underbelly_shipment/ozium,
					8;  /obj/item/underbelly_shipment/moondust,
					6;  /obj/item/underbelly_shipment/spice,
					4;  /obj/item/underbelly_shipment/herozium,
					2;  /obj/item/underbelly_shipment/starsugar,
				)
				new T(C)
		if(7) // rare valuables - gems, jewellery, and stolen finery
			C.name = "valuables crate"
			C.desc = "A crate lined with dark cloth. Whatever's inside was packed by someone who knew its worth."
			for(var/i in 1 to rand(3, 12))
				T = pick(
					30; /obj/item/roguegem/random,
					20; /obj/item/roguegem/blue,
					18; /obj/item/roguegem/green,
					15; /obj/item/roguegem/violet,
					12; /obj/item/roguegem/yellow,
					8;  /obj/item/roguegem/ruby,
					5;  /obj/item/roguegem/diamond,
					20; /obj/item/ingot/gold,
					12; /obj/item/ingot/silver,
					10; /obj/item/ingot/blacksteel,
					18; /obj/item/candle/candlestick/gold,
					12; /obj/item/candle/candlestick/silver,
					15; /obj/item/clothing/ring/gold,
					10; /obj/item/clothing/ring/emerald,
					8;  /obj/item/clothing/ring/ruby,
					6;  /obj/item/clothing/ring/diamond,
					10; /obj/item/clothing/wrists/roguetown/gem/jadebracelet,
					8;  /obj/item/clothing/wrists/roguetown/gem/amberbracelet,
					6;  /obj/item/clothing/wrists/roguetown/gem/coralbracelet,
				)
				new T(C)
		if(8) // seafood
			C.name = "seafood crate"
			C.desc = "A damp crate packed in wet cloth and chipped ice. It reeks of brine."
			for(var/i in 1 to rand(5, 10))
				T = pick(
					24; /obj/item/reagent_containers/food/snacks/fish/crab,
					22; /obj/item/reagent_containers/food/snacks/fish/clam,
					18; /obj/item/reagent_containers/food/snacks/fish/lobster,
					20; /obj/item/reagent_containers/food/snacks/fish/shrimp,
					16; /obj/item/reagent_containers/food/snacks/fish/oyster,
					14; /obj/item/reagent_containers/food/snacks/rogue/meat/crab,
					12; /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish,
					10; /obj/item/reagent_containers/food/snacks/rogue/fryfish/crab,
					10; /obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp,
					8;  /obj/item/reagent_containers/food/snacks/rogue/crabcake,
				)
				new T(C)
