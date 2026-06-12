/datum/chemical_reaction/formaldehyde
	name = /datum/reagent/toxin/formaldehyde
	id = "Formaldehyde"
	results = list(/datum/reagent/toxin/formaldehyde = 3)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/oxygen = 1, /datum/reagent/silver = 1)
	required_temp = 420

/datum/chemical_reaction/fentanyl
	name = /datum/reagent/toxin/fentanyl
	id = /datum/reagent/toxin/fentanyl
	results = list(/datum/reagent/toxin/fentanyl = 1)
	required_reagents = list(/datum/reagent/drug/space_drugs = 1)
	required_temp = 674

/datum/chemical_reaction/cyanide
	name = "氰化物"
	id = /datum/reagent/toxin/cyanide
	results = list(/datum/reagent/toxin/cyanide = 3)
	required_reagents = list(/datum/reagent/fuel/oil = 1, /datum/reagent/ammonia = 1, /datum/reagent/oxygen = 1)
	required_temp = 380

/datum/chemical_reaction/facid
	name = "氟硫酸"
	id = /datum/reagent/toxin/acid/fluacid
	results = list(/datum/reagent/toxin/acid/fluacid = 4)
	required_reagents = list(/datum/reagent/toxin/acid = 1, /datum/reagent/fluorine = 1, /datum/reagent/hydrogen = 1, /datum/reagent/potassium = 1)
	required_temp = 380

/datum/chemical_reaction/nitracid
	name = "硝酸"
	id = /datum/reagent/toxin/acid/nitracid
	results = list(/datum/reagent/toxin/acid/nitracid = 2)
	required_reagents = list(/datum/reagent/toxin/acid/fluacid = 1, /datum/reagent/nitrogen = 1, /datum/reagent/oxygen = 1)
	required_temp = 380

/datum/chemical_reaction/sulfonal
	name = /datum/reagent/toxin/sulfonal
	id = /datum/reagent/toxin/sulfonal
	results = list(/datum/reagent/toxin/sulfonal = 3)
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/diethylamine = 1, /datum/reagent/sulfur = 1)

/datum/chemical_reaction/chloralhydrate
	name = "水合氯醛"
	id = /datum/reagent/toxin/chloralhydrate
	results = list(/datum/reagent/toxin/chloralhydrate = 1)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/chlorine = 3, /datum/reagent/water = 1)

/datum/chemical_reaction/mutetoxin //i'll just fit this in here snugly between other unfun chemicals :v
	name = "缄默毒素"
	id = /datum/reagent/toxin/mutetoxin
	results = list(/datum/reagent/toxin/mutetoxin = 2)
	required_reagents = list(/datum/reagent/uranium = 2, /datum/reagent/water = 1, /datum/reagent/carbon = 1)

/datum/chemical_reaction/heparin
	name = "肝素"
	id = "Heparin"
	results = list(/datum/reagent/toxin/heparin = 4)
	required_reagents = list(/datum/reagent/toxin/formaldehyde = 1, /datum/reagent/sodium = 1, /datum/reagent/chlorine = 1, /datum/reagent/lithium = 1)
	mix_message = "<span class='danger'>混合物变稀了，颜色也完全褪去。</span>"

/datum/chemical_reaction/bonehurtingjuice
	name = "伤骨汁"
	id = /datum/reagent/toxin/bonehurtingjuice
	results = list(/datum/reagent/toxin/bonehurtingjuice = 5)
	required_reagents = list(/datum/reagent/toxin/mutagen = 1, /datum/reagent/toxin/itching_powder = 3, /datum/reagent/consumable/milk = 1)
	mix_message = "<span class='danger'>混合物突然变得澄清，看起来几乎和水一模一样。你莫名生出一股强烈的饮用冲动。</span>"
