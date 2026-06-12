
/datum/chemical_reaction/lube
	name = "太空润滑剂"
	id = /datum/reagent/lube
	results = list(/datum/reagent/lube = 4)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/silicon = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/impedrezene
	name = "因佩德瑞辛"
	id = /datum/reagent/impedrezene
	results = list(/datum/reagent/impedrezene = 2)
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/oxygen = 1, /datum/reagent/consumable/sugar = 1)

/datum/chemical_reaction/cryptobiolin
	name = "隐生灵素"
	id = /datum/reagent/cryptobiolin
	results = list(/datum/reagent/cryptobiolin = 3)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/oxygen = 1, /datum/reagent/consumable/sugar = 1)

/datum/chemical_reaction/sodiumchloride
	name = "氯化钠"
	id = /datum/reagent/consumable/sodiumchloride
	results = list(/datum/reagent/consumable/sodiumchloride = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/sodium = 1, /datum/reagent/chlorine = 1)

/datum/chemical_reaction/candlefication
	name = "制烛反应"
	id = "candlefication"
	required_reagents = list(/datum/reagent/liquidgibs = 5, /datum/reagent/oxygen  = 5) //
	required_temp = 374
	mob_react = FALSE

/datum/chemical_reaction/candlefication/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/candle(location)

/datum/chemical_reaction/meatification
	name = "肉化反应"
	id = "meatification"
	required_reagents = list(/datum/reagent/liquidgibs = 10, /datum/reagent/consumable/nutriment = 10, /datum/reagent/carbon = 10)
	mob_react = FALSE

/datum/chemical_reaction/meatification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/food/snacks/rogue/meat/steak(location)
	return

/datum/chemical_reaction/carbondioxide
	name = "直接碳氧化"
	id = "burningcarbon"
	results = list(/datum/reagent/carbondioxide = 3)
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/oxygen = 2)
	required_temp = 777 // pure carbon isn't especially reactive.

/datum/chemical_reaction/nitrous_oxide
	name = "一氧化二氮"
	id = /datum/reagent/nitrous_oxide
	results = list(/datum/reagent/nitrous_oxide = 5)
	required_reagents = list(/datum/reagent/ammonia = 2, /datum/reagent/nitrogen = 1, /datum/reagent/oxygen = 2)
	required_temp = 525

//Technically a mutation toxin
/datum/chemical_reaction/mulligan
	name = "穆利根"
	id = /datum/reagent/mulligan
	results = list(/datum/reagent/mulligan = 1)
	required_reagents = list(/datum/reagent/mutationtoxin = 1, /datum/reagent/toxin/mutagen = 1)

////////////////////////////////// foam and foam precursor ///////////////////////////////////////////////////


/datum/chemical_reaction/surfactant
	name = "泡沫表面活性剂"
	id = "foam surfactant"
	results = list(/datum/reagent/fluorosurfactant = 5)
	required_reagents = list(/datum/reagent/fluorine = 2, /datum/reagent/carbon = 2, /datum/reagent/toxin/acid = 1)

/datum/chemical_reaction/foam
	name = "泡沫"
	id = "foam"
	required_reagents = list(/datum/reagent/fluorosurfactant = 1, /datum/reagent/water = 1)
	mob_react = FALSE

/datum/chemical_reaction/foam/on_reaction(datum/reagents/holder, created_volume)
	holder.create_foam(/datum/effect_system/foam_spread,2*created_volume,notification="<span class='danger'>溶液喷涌出大量泡沫！</span>")

/datum/chemical_reaction/metalfoam
	name = "金属泡沫"
	id = "metalfoam"
	required_reagents = list(/datum/reagent/aluminium = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/toxin/acid/fluacid = 1)
	mob_react = FALSE

/datum/chemical_reaction/metalfoam/on_reaction(datum/reagents/holder, created_volume)
	holder.create_foam(/datum/effect_system/foam_spread/metal,5*created_volume,1,"<span class='danger'>溶液喷涌出金属泡沫！</span>")

/datum/chemical_reaction/smart_foam
	name = "智能金属泡沫"
	id = "smart_metal_foam"
	required_reagents = list(/datum/reagent/aluminium = 3, /datum/reagent/smart_foaming_agent = 1, /datum/reagent/toxin/acid/fluacid = 1)
	mob_react = TRUE

/datum/chemical_reaction/smart_foam/on_reaction(datum/reagents/holder, created_volume)
	holder.create_foam(/datum/effect_system/foam_spread/metal/smart,5*created_volume,1,"<span class='danger'>溶液喷涌出金属泡沫！</span>")

/datum/chemical_reaction/ironfoam
	name = "铁泡沫"
	id = "ironlfoam"
	required_reagents = list(/datum/reagent/iron = 3, /datum/reagent/foaming_agent = 1, /datum/reagent/toxin/acid/fluacid = 1)
	mob_react = FALSE

/datum/chemical_reaction/ironfoam/on_reaction(datum/reagents/holder, created_volume)
	holder.create_foam(/datum/effect_system/foam_spread/metal,5*created_volume,2,"<span class='danger'>溶液喷涌出金属泡沫！</span>")

/datum/chemical_reaction/foaming_agent
	name = "发泡剂"
	id = /datum/reagent/foaming_agent
	results = list(/datum/reagent/foaming_agent = 1)
	required_reagents = list(/datum/reagent/lithium = 1, /datum/reagent/hydrogen = 1)

/datum/chemical_reaction/smart_foaming_agent
	name = "智能发泡剂"
	id = /datum/reagent/smart_foaming_agent
	results = list(/datum/reagent/smart_foaming_agent = 3)
	required_reagents = list(/datum/reagent/foaming_agent = 3, /datum/reagent/acetone = 1, /datum/reagent/iron = 1)
	mix_message = "溶液混合成了蓬松的金属泡沫，并顺着容器内壁铺展开来。"


/////////////////////////////// Cleaning and hydroponics /////////////////////////////////////////////////

/datum/chemical_reaction/ammonia
	name = "氨"
	id = /datum/reagent/ammonia
	results = list(/datum/reagent/ammonia = 3)
	required_reagents = list(/datum/reagent/hydrogen = 3, /datum/reagent/nitrogen = 1)

/datum/chemical_reaction/diethylamine
	name = "二乙胺"
	id = /datum/reagent/diethylamine
	results = list(/datum/reagent/diethylamine = 2)
	required_reagents = list (/datum/reagent/ammonia = 1, /datum/reagent/consumable/ethanol = 1)

/datum/chemical_reaction/space_cleaner
	name = "太空清洁剂"
	id = /datum/reagent/space_cleaner
	results = list(/datum/reagent/space_cleaner = 2)
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/plantbgone
	name = "植物去无踪"
	id = /datum/reagent/toxin/plantbgone
	results = list(/datum/reagent/toxin/plantbgone = 5)
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/water = 4)

/datum/chemical_reaction/weedkiller
	name = "除草剂"
	id = /datum/reagent/toxin/plantbgone/weedkiller
	results = list(/datum/reagent/toxin/plantbgone/weedkiller = 5)
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/ammonia = 4)

/datum/chemical_reaction/pestkiller
	name = "杀虫剂"
	id = /datum/reagent/toxin/pestkiller
	results = list(/datum/reagent/toxin/pestkiller = 5)
	required_reagents = list(/datum/reagent/toxin = 1, /datum/reagent/consumable/ethanol = 4)

/datum/chemical_reaction/drying_agent
	name = "干燥剂"
	id = /datum/reagent/drying_agent
	results = list(/datum/reagent/drying_agent = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 2, /datum/reagent/consumable/ethanol = 1, /datum/reagent/sodium = 1)

//////////////////////////////////// Other goon stuff ///////////////////////////////////////////

/datum/chemical_reaction/acetone
	name = /datum/reagent/acetone
	id = /datum/reagent/acetone
	results = list(/datum/reagent/acetone = 3)
	required_reagents = list(/datum/reagent/fuel/oil = 1, /datum/reagent/fuel = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/oil
	name = "油"
	id = /datum/reagent/fuel/oil
	results = list(/datum/reagent/fuel/oil = 3)
	required_reagents = list(/datum/reagent/fuel = 1, /datum/reagent/carbon = 1, /datum/reagent/hydrogen = 1)

/datum/chemical_reaction/phenol
	name = /datum/reagent/phenol
	id = /datum/reagent/phenol
	results = list(/datum/reagent/phenol = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/chlorine = 1, /datum/reagent/fuel/oil = 1)

/datum/chemical_reaction/ash
	name = "灰烬"
	id = /datum/reagent/ash
	results = list(/datum/reagent/ash = 1)
	required_reagents = list(/datum/reagent/fuel/oil = 1)
	required_temp = 480

//water electrolysis
/datum/chemical_reaction/hair_dye
	name = /datum/reagent/hair_dye
	id = /datum/reagent/hair_dye
	results = list(/datum/reagent/hair_dye = 5)
	required_reagents = list(/datum/reagent/colorful_reagent = 1, /datum/reagent/uranium/radium = 1, /datum/reagent/drug/space_drugs = 1)

/datum/chemical_reaction/concentrated_barbers_aid
	name = /datum/reagent/concentrated_barbers_aid
	id = /datum/reagent/concentrated_barbers_aid
	results = list(/datum/reagent/concentrated_barbers_aid = 2)
	required_reagents = list(/datum/reagent/barbers_aid = 1, /datum/reagent/toxin/mutagen = 1)

/datum/chemical_reaction/saltpetre
	name = /datum/reagent/saltpetre
	id = /datum/reagent/saltpetre
	results = list(/datum/reagent/saltpetre = 3)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/nitrogen = 1, /datum/reagent/oxygen = 3)

/datum/chemical_reaction/lye
	name = /datum/reagent/lye
	id = /datum/reagent/lye
	results = list(/datum/reagent/lye = 3)
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/hydrogen = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/lye2
	name = /datum/reagent/lye
	id = /datum/reagent/lye
	results = list(/datum/reagent/lye = 2)
	required_reagents = list(/datum/reagent/ash = 1, /datum/reagent/water = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/royal_bee_jelly
	name = "蜂王浆"
	id = /datum/reagent/royal_bee_jelly
	results = list(/datum/reagent/royal_bee_jelly = 5)
	required_reagents = list(/datum/reagent/toxin/mutagen = 10, /datum/reagent/consumable/honey = 40)

/datum/chemical_reaction/acetone_oxide
	name = "过氧化丙酮"
	id = /datum/reagent/acetone_oxide
	results = list(/datum/reagent/acetone_oxide = 2)
	required_reagents = list(/datum/reagent/acetone = 2, /datum/reagent/oxygen = 1, /datum/reagent/hydrogen_peroxide = 1)

/datum/chemical_reaction/pentaerythritol
	name = "季戊四醇"
	id = /datum/reagent/pentaerythritol
	results = list(/datum/reagent/pentaerythritol = 2)
	required_reagents = list(/datum/reagent/acetaldehyde = 1, /datum/reagent/toxin/formaldehyde = 3, /datum/reagent/water = 1 )

/datum/chemical_reaction/acetaldehyde
	name = "乙醛"
	id = /datum/reagent/acetaldehyde
	results = list(/datum/reagent/acetaldehyde = 3)
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/toxin/formaldehyde = 1, /datum/reagent/water = 1)
	required_temp = 450
