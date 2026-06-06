
////////////////////
/// PROSTHETICS ///
//////////////////


/datum/artificer_recipe/prosthetics
	i_type = "Prosthetics"
	hammers_per_item = 5
	skill_level = 2


/////////////
/// Wood ///
///////////


/datum/artificer_recipe/prosthetics/wood/arm_left
	name = "Left Wooden Arm (+2 Plank) (+1 Wooden Cog)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/natural/wood/plank = 2, /obj/item/roguegear/wood/basic = 1)
	created_item = /obj/item/bodypart/l_arm/prosthetic/woodleft

/datum/artificer_recipe/prosthetics/wood/arm_right
	name = "Right Wooden Arm (+2 Plank) (+1 Wooden Cog)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/natural/wood/plank = 2, /obj/item/roguegear/wood/basic = 1)
	created_item = /obj/item/bodypart/r_arm/prosthetic/woodright

/datum/artificer_recipe/prosthetics/wood/leg_left
	name = "Left Wooden Leg (+2 Plank) (+1 Wooden Cog)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/natural/wood/plank = 2, /obj/item/roguegear/wood/basic = 1)
	created_item = /obj/item/bodypart/l_leg/prosthetic

/datum/artificer_recipe/prosthetics/wood/leg_right
	name = "Right Wooden Leg (+2 Plank) (+1 Wooden Cog)"
	required_item = /obj/item/natural/wood/plank
	additional_items = list(/obj/item/natural/wood/plank = 2, /obj/item/roguegear/wood/basic = 1)
	created_item = /obj/item/bodypart/r_leg/prosthetic


///////////////
/// Bronze ///
/////////////


/datum/artificer_recipe/prosthetics/bronze_prosthetic
	name = "bronze prosthetic (+2 Cogs)"
	required_item = /obj/item/ingot/bronze
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/roguegear/bronze)
	created_item = /obj/item/contraption/bronzeprosthetic
	hammers_per_item = 5
	skill_level = 3


/////////////
/// Iron ///
///////////


/datum/artificer_recipe/prosthetics/iron_prosthetic
	name = "iron prosthetic (+2 cogs)"
	required_item = /obj/item/ingot/iron
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/roguegear/bronze)
	created_item = /obj/item/contraption/ironprosthetic
	hammers_per_item = 6
	skill_level = 4


//////////////
/// Steel ///
////////////


/datum/artificer_recipe/prosthetics/steel_prosthetic
	name = "steel prosthetic (+2 cogs)"
	required_item = /obj/item/ingot/steel
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/roguegear/bronze)
	created_item = /obj/item/contraption/steelprosthetic
	hammers_per_item = 8
	skill_level = 5


/////////////
/// Gold ///
///////////


/datum/artificer_recipe/prosthetics/gold_prosthetic
	name = "gold prosthetic (+2 Cogs)"
	required_item = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegear/bronze, /obj/item/roguegear/bronze)
	created_item = /obj/item/contraption/goldprosthetic
	hammers_per_item = 10
	skill_level = 5
