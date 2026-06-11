/datum/alch_grind_recipe/sinew
	valid_input = /obj/item/alch/sinew
	valid_outputs = list(/obj/item/alch/viscera = 1)
	bonus_chance_outputs = list(/obj/item/alch/viscera = 75)

//Runes -> dust
// Unused for now not clogging up the grind recipes
// /datum/alch_grind_recipe/fire_rune
// 	valid_input = /obj/item/rune/spell/fire_rune
// 	valid_outputs = list(/obj/item/alch/firedust = 2)
// 	bonus_chance_outputs = list(/obj/item/alch/firedust = 33)

// /datum/alch_grind_recipe/water_rune
// 	valid_input = /obj/item/rune/spell/water_rune
// 	valid_outputs = list(/obj/item/alch/waterdust = 2)
// 	bonus_chance_outputs = list(/obj/item/alch/waterdust = 33)

// /datum/alch_grind_recipe/air_rune
// 	valid_input = /obj/item/rune/spell/air_rune
// 	valid_outputs = list(/obj/item/alch/airdust = 2)
// 	bonus_chance_outputs = list(/obj/item/alch/airdust = 33)

// /datum/alch_grind_recipe/earth_rune
// 	valid_input = /obj/item/rune/spell/earth_rune
// 	valid_outputs = list(/obj/item/alch/earthdust = 2)
// 	bonus_chance_outputs = list(/obj/item/alch/earthdust = 33)

// /datum/alch_grind_recipe/blank_rune
// 	valid_input = /obj/item/rune/spell/blank_rune
// 	valid_outputs = list(/obj/item/alch/runedust = 2)
// 	bonus_chance_outputs = list(/obj/item/alch/runedust = 33)

//Objects -> dusts
/datum/alch_grind_recipe/crow
	name = "乌鸦"
	valid_input = /obj/item/reagent_containers/food/snacks/crow
	valid_outputs = list(/obj/item/alch/airdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust = 33)

/datum/alch_grind_recipe/bone
	name = "骨头"
	valid_input = /obj/item/alch/bone
	valid_outputs = list( /obj/item/alch/bonemeal = 2)
	bonus_chance_outputs = list(/obj/item/alch/bonemeal = 50)

/datum/alch_grind_recipe/natural_bone
	name = "天然骨骼"
	valid_input = /obj/item/natural/bone
	valid_outputs = list(/obj/item/alch/bonemeal = 1)
	bonus_chance_outputs = list(/obj/item/alch/bonemeal = 2)

/datum/alch_grind_recipe/natural_bone/get_bonus_output_chance(output_path, mob/living/carbon/human/user, base_chance)
	if(output_path != /obj/item/alch/bonemeal || !user)
		return base_chance
	var/alch_level = user.get_skill_level(/datum/skill/craft/alchemy)
	if(alch_level <= SKILL_LEVEL_APPRENTICE)
		return 20
	return 50

/datum/alch_grind_recipe/horn

	valid_input = /obj/item/alch/horn
	valid_outputs = list(/obj/item/alch/earthdust = 1,/obj/item/alch/bonemeal = 2)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 66)

/datum/alch_grind_recipe/fish
	name = "鱼"
	picky = FALSE
	valid_input = /obj/item/reagent_containers/food/snacks/fish
	valid_outputs = list(/obj/item/alch/waterdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/bonemeal = 50)

/datum/alch_grind_recipe/swampweed
	name = "Swampweed"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweed
	valid_outputs = list(/obj/item/alch/swampdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 33)

/datum/alch_grind_recipe/swampweed_dried
	name = "干燥 Swampweed"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry
	valid_outputs = list(/obj/item/alch/swampdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 50,/obj/item/alch/swampdust = 50)

/datum/alch_grind_recipe/westleach
	name = "Westleach"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed
	valid_outputs = list(/obj/item/alch/tobaccodust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust = 33)

/datum/alch_grind_recipe/dry_westleach
	name = "干燥 Westleach"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry
	valid_outputs = list(/obj/item/alch/tobaccodust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust = 50,/obj/item/alch/tobaccodust = 50)

/datum/alch_grind_recipe/fyritius
	name = "Fyritius"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius
	valid_outputs = list(/obj/item/alch/firedust = 1)
	bonus_chance_outputs = list(/obj/item/alch/solardust = 50)

/datum/alch_grind_recipe/poppy
	name = "罂粟"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/rogue/poppy
	valid_outputs = list(/obj/item/reagent_containers/powder/ozium = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust =33,/obj/item/alch/earthdust = 33)

/datum/alch_grind_recipe/seeds
	name = "种子"
	picky = FALSE
	valid_input = /obj/item/seeds
	valid_outputs = list(/obj/item/alch/seeddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust =25,/obj/item/alch/earthdust = 25)

/datum/alch_grind_recipe/stone_dust
	name = "石料"
	valid_input = /obj/item/natural/stone
	valid_outputs = list(/obj/item/alch/stonedust = 1)
	bonus_chance_outputs = list(/obj/item/alch/stonedust = 50)

/datum/alch_grind_recipe/seedsherb
	name = "草药种子"
	picky = FALSE
	valid_input = /obj/item/herbseed
	valid_outputs = list(/obj/item/alch/seeddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust =25,/obj/item/alch/earthdust = 25)

/datum/alch_grind_recipe/ozium
	name = "Ozium"
	valid_input = /obj/item/reagent_containers/powder/ozium
	valid_outputs = list(/obj/item/alch/ozium = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust =25,/obj/item/alch/ozium = 25)

/datum/alch_grind_recipe/sunflower
	name = "向日葵"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/sunflower
	valid_outputs = list(/obj/item/alch/solardust = 1)
	bonus_chance_outputs = list(/obj/item/alch/firedust = 25)

//Ores -> dust
/datum/alch_grind_recipe/gold_ore
	name = "金矿石"
	valid_input = /obj/item/rogueore/gold
	valid_outputs = list(/obj/item/alch/golddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/golddust = 33)

/datum/alch_grind_recipe/silver_ore
	name = "银矿石"
	valid_input = /obj/item/rogueore/silver
	valid_outputs = list(/obj/item/alch/silverdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/silverdust = 33)

/datum/alch_grind_recipe/iron_ore
	name = "铁矿石"
	valid_input = /obj/item/rogueore/iron
	valid_outputs = list(/obj/item/alch/irondust = 1)
	bonus_chance_outputs = list(/obj/item/alch/irondust = 33, /obj/item/alch/runedust = 25)

/datum/alch_grind_recipe/coal_ore
	name = "煤矿石"
	valid_input = /obj/item/rogueore/coal
	valid_outputs = list(/obj/item/alch/coaldust = 1)
	bonus_chance_outputs = list(/obj/item/alch/coaldust = 33, /obj/item/alch/firedust = 25)

/datum/alch_grind_recipe/gold_bar
	name = "金锭"
	valid_input = /obj/item/ingot/gold
	valid_outputs = list(/obj/item/alch/golddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/golddust = 33, /obj/item/alch/firedust = 25)

/datum/alch_grind_recipe/silver_bar
	name = "银锭"
	valid_input = /obj/item/ingot/silver
	valid_outputs = list(/obj/item/alch/silverdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/silverdust = 33, /obj/item/alch/firedust = 25)

/datum/alch_grind_recipe/blessed_silver_bar
	name = "祝圣银锭"
	valid_input = /obj/item/ingot/silverblessed
	valid_outputs = list(/obj/item/alch/silverdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/silverdust = 33, /obj/item/alch/firedust = 25)

/datum/alch_grind_recipe/iron_bar
	name = "铁锭"
	valid_input = /obj/item/ingot/iron
	valid_outputs = list(/obj/item/alch/irondust = 1)
	bonus_chance_outputs = list(/obj/item/alch/irondust = 33, /obj/item/alch/runedust = 25, /obj/item/alch/firedust = 25)

/datum/alch_grind_recipe/puresalt
	name = "纯盐"
	valid_input = /obj/item/reagent_containers/powder/salt
	valid_outputs = list(/obj/item/alch/puresalt = 1)

/datum/alch_grind_recipe/berrypowder
	name = "浆果粉"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/berries/rogue
	valid_outputs = list(/obj/item/alch/berrypowder = 1)
	bonus_chance_outputs = list(/obj/item/alch/waterdust = 25)

/datum/alch_grind_recipe/manabloompowder
	name = "Manabloom 粉"
	valid_input = /obj/item/reagent_containers/food/snacks/grown/manabloom
	valid_outputs = list(/obj/item/alch/manabloompowder = 1)
	bonus_chance_outputs = list(/obj/item/alch/manabloompowder = 25)

/datum/alch_grind_recipe/infernaldust
	name = "地狱尘"
	valid_input = /obj/item/magic/infernal/fang
	valid_outputs = list(/obj/item/alch/infernaldust = 1)
	bonus_chance_outputs = list(/obj/item/alch/firedust = 25)

// Start of gem dust section - I've included gold dust as an additional product because of lesser alchemy, grinding up a gem should give you a bit extra (I mean come on it's a gem)

/datum/alch_grind_recipe/mineraldustyellow  // costs two gold to make
	name = "矿物粉（托珀石）"
	valid_input = /obj/item/roguegem/yellow
	valid_outputs = list(/obj/item/alch/mineraldust = 1, /obj/item/alch/golddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/golddust = 66)

/datum/alch_grind_recipe/mineraldustgreen  // costs 4 gold to make
	name = "矿物粉（翠晶）"
	valid_input = /obj/item/roguegem/green
	valid_outputs = list(/obj/item/alch/mineraldust = 1, /obj/item/alch/earthdust = 1, /obj/item/alch/golddust = 2)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 66)

/datum/alch_grind_recipe/mineraldustviolet // costs 6 gold to make
	name = "矿物粉（蓝晶）"
	valid_input = /obj/item/roguegem/violet
	valid_outputs = list(/obj/item/alch/mineraldust = 1, /obj/item/alch/magicdust = 1, /obj/item/alch/golddust = 3)
	bonus_chance_outputs = list(/obj/item/alch/magicdust = 66)

/datum/alch_grind_recipe/mineraldustblue // costs 8 gold to make
	name = "矿物粉（布洛兹石）"
	valid_input = /obj/item/roguegem/blue
	valid_outputs = list(/obj/item/alch/mineraldust = 1, /obj/item/alch/waterdust = 2, /obj/item/alch/golddust = 4)
	bonus_chance_outputs = list(/obj/item/alch/waterdust = 66)

/datum/alch_grind_recipe/mineraldustdiamond // costs a whopping 18 gold to make, why are you doing this
	name = "矿物粉（钻石）"
	valid_input = /obj/item/roguegem/diamond
	valid_outputs = list(/obj/item/alch/mineraldust = 1, /obj/item/alch/golddust = 6)
	bonus_chance_outputs = list(/obj/item/alch/golddust = 66)

/datum/alch_grind_recipe/mineraldustriddle //why are you doing this...
	name = "矿物粉（Riddle of Steel）"
	valid_input = /obj/item/riddleofsteel
	valid_outputs = list(/obj/item/alch/mineraldust = 2, /obj/item/alch/airdust = 1, /obj/item/alch/irondust = 1, /obj/item/alch/firedust = 1, /obj/item/alch/magicdust = 1, /obj/item/alch/silverdust = 1, /obj/item/alch/coaldust = 1, /obj/item/alch/runedust = 1, /obj/item/alch/waterdust = 1)  // if you're crazy enough to grind a riddle you should get at LEAST one of every dust.
	bonus_chance_outputs = list(/obj/item/alch/mineraldust = 25, /obj/item/alch/airdust = 25, /obj/item/alch/irondust = 25, /obj/item/alch/firedust = 25, /obj/item/alch/magicdust = 25, /obj/item/alch/silverdust = 25, /obj/item/alch/coaldust = 25, /obj/item/alch/runedust = 25, /obj/item/alch/waterdust = 25)

// End of gem dust section


//Herb -> Herbseed
/datum/alch_grind_recipe/atropa_seed
	name = "草药种子（Atropa）"
	valid_input = /obj/item/alch/atropa
	valid_outputs = list(/obj/item/herbseed/atropa = 1)

/datum/alch_grind_recipe/matricaria_seed
	name = "草药种子（Matricaria）"
	valid_input = /obj/item/alch/matricaria
	valid_outputs = list(/obj/item/herbseed/matricaria = 1)

/datum/alch_grind_recipe/symphitum_seed
	name = "草药种子（Symphitum）"
	valid_input = /obj/item/alch/symphitum
	valid_outputs = list(/obj/item/herbseed/symphitum = 1)

/datum/alch_grind_recipe/taraxacum_seed
	name = "草药种子（Taraxacum）"
	valid_input = /obj/item/alch/taraxacum
	valid_outputs = list(/obj/item/herbseed/taraxacum = 1)

/datum/alch_grind_recipe/euphrasia_seed
	name = "草药种子（Euphrasia）"
	valid_input = /obj/item/alch/euphrasia
	valid_outputs = list(/obj/item/herbseed/euphrasia = 1)

/datum/alch_grind_recipe/paris_seed
	name = "草药种子（Paris）"
	valid_input = /obj/item/alch/paris
	valid_outputs = list(/obj/item/herbseed/paris = 1)

/datum/alch_grind_recipe/calendula_seed
	name = "草药种子（Calendula）"
	valid_input = /obj/item/alch/calendula
	valid_outputs = list(/obj/item/herbseed/calendula = 1)

/datum/alch_grind_recipe/mentha_seed
	name = "草药种子（Mentha）"
	valid_input = /obj/item/alch/mentha
	valid_outputs = list(/obj/item/herbseed/mentha = 1)

/datum/alch_grind_recipe/urtica_seed
	name = "草药种子（Urtica）"
	valid_input = /obj/item/alch/urtica
	valid_outputs = list(/obj/item/herbseed/urtica = 1)

/datum/alch_grind_recipe/salvia_seed
	name = "草药种子（Salvia）"
	valid_input = /obj/item/alch/salvia
	valid_outputs = list(/obj/item/herbseed/salvia = 1)

/datum/alch_grind_recipe/hypericum_seed
	name = "草药种子（Hypericum）"
	valid_input = /obj/item/alch/hypericum
	valid_outputs = list(/obj/item/herbseed/hypericum = 1)

/datum/alch_grind_recipe/benedictus_seed
	name = "草药种子（Benedictus）"
	valid_input = /obj/item/alch/benedictus
	valid_outputs = list(/obj/item/herbseed/benedictus = 1)

/datum/alch_grind_recipe/valeriana_seed
	name = "草药种子（Valeriana）"
	valid_input = /obj/item/alch/valeriana
	valid_outputs = list(/obj/item/herbseed/valeriana = 1)

/datum/alch_grind_recipe/artemisia_seed
	name = "草药种子（Artemisia）"
	valid_input = /obj/item/alch/artemisia
	valid_outputs = list(/obj/item/herbseed/artemisia = 1)

/datum/alch_grind_recipe/rosa_seed
	name = "草药种子（Rosa）"
	valid_input = /obj/item/alch/rosa
	valid_outputs = list(/obj/item/herbseed/rosa = 1)
