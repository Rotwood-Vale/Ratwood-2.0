// I love the Kazengunite armour so much. Why not make it?
// Requires you to actually read the Kazengunite smithing manual to learn how to make this.
// I thought about it, why not have it in the loadout? So Kazengunite smiths can choose to ... catch up on how to actually make this.
// Franky, more content like this is really interesting.w

/datum/anvil_recipe/kazengunite
	abstract_type = /datum/anvil_recipe/kazengunite
	appro_skill = /datum/skill/craft/armorsmithing
	i_type = "Armor"
	craftdiff = SKILL_LEVEL_MASTER
	req_trait = TRAIT_KAZENGUNITE_SMITH
	hides_from_books = TRUE


/datum/anvil_recipe/kazengunite/kabuto
	name = "Kabuto (+1 Steel, +1 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/kabuto


/datum/anvil_recipe/kazengunite/halfmask
	name = "Soldier's Half-Mask"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/mask/rogue/facemask/steel/kazengun


/datum/anvil_recipe/kazengunite/gorget
	name = "Kazengunite Gorget"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun


/datum/anvil_recipe/kazengunite/samsibsa
	name = "Samsibsa Scaleplate (+1 Half-Plate, Steel, +1 Steel, +2 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate, /obj/item/ingot/steel, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa


/datum/anvil_recipe/kazengunite/kote
	name = "Jjajeungna Gauntlets"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/gloves/roguetown/plate/kote


/datum/anvil_recipe/kazengunite/ssangsudo
	name = "Ssangsudo"
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo
