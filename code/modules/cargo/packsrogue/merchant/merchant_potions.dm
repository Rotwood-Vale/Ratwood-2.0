// Merchant Potions. Merchant potions are meant to be relatively cost ineffective and set a CEILING for potion prices
// Normal potion brewer can and should undercut these prices. However this gives merchants more things to sell to fulfill their role as "adventurer shop"
// And hopefully generate demands for potions from other brewer who can offer it cheaper while improving access
// Yes, they are meant to have access to the high tier stat buff potion but not the second tier health or mana potions or any of the poison.
/datum/supply_pack/rogue/potions
	group = "Potions"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

//Only two since that's 4 uses total; two sips each. You only need one sip for cure.
/datum/supply_pack/rogue/potions/rotcure
	name = "腐坏治疗药水"
	cost = 300
	contains = list(
					/obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure,
					/obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure,
				)

/datum/supply_pack/rogue/potions/healthpot
	name = "治疗药水"
	cost = 25
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpot)

/datum/supply_pack/rogue/potions/manapot
	name = "法力药水"
	cost = 25
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/manapot)

/datum/supply_pack/rogue/potions/stamina
	name = "耐力药水"
	cost = 25
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/stampot)

/datum/supply_pack/rogue/potions/antidote
	name = "解毒剂"
	cost = 25
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/antidote)

/datum/supply_pack/rogue/potions/strpot
	name = "力量药水"
	cost = 50
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical/strpot)

/datum/supply_pack/rogue/potions/perpot
	name = "感知药水"
	cost = 50
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical/perpot)

/datum/supply_pack/rogue/potions/endpot
	name = "意志药水"
	cost = 50
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical/endpot)

/datum/supply_pack/rogue/potions/conpot
	name = "体质药水"
	cost = 50
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical/conpot)
					
/datum/supply_pack/rogue/potions/intpot
	name = "智力药水"
	cost = 50
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical/intpot)

/datum/supply_pack/rogue/potions/spdpot
	name = "迅捷药水"
	cost = 50
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical/spdpot)

/datum/supply_pack/rogue/potions/lucpot
	name = "幸运药水"
	cost = 50
	contains = list(/obj/item/reagent_containers/glass/bottle/alchemical/lucpot)
