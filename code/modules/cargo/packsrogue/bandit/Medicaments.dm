
/datum/supply_pack/rogue/Medicaments
	group = "Medicaments"
	crate_name = "Gifts of Lyfe"
	crate_type = /obj/structure/closet/crate/chest/merchant

/////////////
// MEDICAL //
/////////////

/datum/supply_pack/rogue/Medicaments/bandages
	name = "一卷绷带"
	cost = 10
	contains = list(/obj/item/natural/bundle/cloth/bandage/full)

/////////////
// POTIONS //
/////////////

/datum/supply_pack/rogue/Medicaments/healthpot
	name = "治疗药水"
	cost = 20
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpot)

/datum/supply_pack/rogue/Medicaments/manapot
	name = "法力药水"
	cost = 15
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/manapot)

/datum/supply_pack/rogue/Medicaments/stampot
	name = "耐力药水"
	cost = 15
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/stampot)

/datum/supply_pack/rogue/Medicaments/healthpotnew
	name = "高级治疗药剂"
	cost = 30
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew)

/datum/supply_pack/rogue/Medicaments/manapotnew
	name = "高级法力药剂"
	cost = 25
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical/strongmanapot)

/datum/supply_pack/rogue/Medicaments/stampotnew
	name = "高级耐力药水"
	cost = 40
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/strongstampot)

/datum/supply_pack/rogue/Medicaments/rotcure
	name = "腐烂治疗药水"
	cost = 200
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure)

/datum/supply_pack/rogue/Medicaments/frankenbrew
	name = "弗兰肯酿"
	cost = 200
	contains = list(/obj/item/reagent_containers/glass/bottle/frankenbrew)

/datum/supply_pack/rogue/Medicaments/emberwine
	name = "余烬酒"
	cost =	120	// It makes a good poison but its moreso to goon with. 
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/emberwine)

///////////
// DRUGS //
///////////

/datum/supply_pack/rogue/Medicaments/westleach
	name = "西池牌烟卷"
	cost = 2
	contains = list(/obj/item/clothing/mask/cigarette/rollie/nicotine)

/datum/supply_pack/rogue/Medicaments/swampweed
	name = "沼麻烟卷"
	cost = 5
	contains = list(/obj/item/clothing/mask/cigarette/rollie/cannabis)

/datum/supply_pack/rogue/Medicaments/ozium
	name = "奥兹姆"
	cost = 10
	contains = list(/obj/item/reagent_containers/powder/ozium)

/datum/supply_pack/rogue/Medicaments/moondust
	name = "月尘"
	cost = 15
	contains = list(/obj/item/reagent_containers/powder/moondust)

/datum/supply_pack/rogue/Medicaments/spice
	name = "香料粉"
	cost = 15
	contains = list(/obj/item/reagent_containers/powder/spice)

/datum/supply_pack/rogue/Medicaments/suidust
	name = "绥尘"
	cost = 20
	contains = list(/obj/item/alch/transisdust)

/////////////////
// PROSTHETICS //
/////////////////

/datum/supply_pack/rogue/Medicaments/bronzeprosthetic
	name = "青铜义体"
	cost = 150
	contains = list(/obj/item/contraption/bronzeprosthetic)

/datum/supply_pack/rogue/Medicaments/prarml
	name = "木制义肢臂（左）"
	cost = 40
	contains = list(/obj/item/bodypart/l_arm/prosthetic/woodleft)

/datum/supply_pack/rogue/Medicaments/prarmr
	name = "木制义肢臂（右）"
	cost = 40
	contains = list(/obj/item/bodypart/r_arm/prosthetic/woodright)

/datum/supply_pack/rogue/Medicaments/prlegl
	name = "木制义肢腿（左）"
	cost = 20
	contains = list(/obj/item/bodypart/l_leg/prosthetic)

/datum/supply_pack/rogue/Medicaments/prlegr
	name = "木制义肢腿（右）"
	cost = 20
	contains = list(/obj/item/bodypart/r_leg/prosthetic)
