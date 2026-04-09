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

/datum/anvil_recipe/kazengunite/jingasa
	name = "Jingasa"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/jingasa

/datum/anvil_recipe/kazengunite/halfmask
	name = "Soldier's Half-Mask"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/mask/rogue/facemask/steel/kazengun

/datum/anvil_recipe/kazengunite/fullmask
	name = "Full Ogre Mask"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/mask/rogue/facemask/steel/kazengun/full

/datum/anvil_recipe/kazengunite/onimask
	name = "Oni Mask (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list (/obj/item/grown/log/tree/small)
	created_item = /obj/item/clothing/mask/rogue/facemask/yoruku_oni

/datum/anvil_recipe/kazengunite/kitsunemask
	name = "Kitsune Mask (+1 Small Log)"
	req_bar = /obj/item/ingot/iron
	additional_items = list (/obj/item/grown/log/tree/small)
	created_item = /obj/item/clothing/mask/rogue/facemask/yoruku_kitsune

/datum/anvil_recipe/kazengunite/gorget
	name = "Kazengunite Gorget"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun

/datum/anvil_recipe/kazengunite/samsibsa
	name = "Samsibsa Scaleplate (+1 Half-Plate, +1 Steel, +2 Cured Leather)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate, /obj/item/ingot/steel, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa

/datum/anvil_recipe/kazengunite/haraate
	name = "Hansimhae Cuirass (+1 Steel, +2 Cloth)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/cloth, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine/haraate

/datum/anvil_recipe/kazengunite/kote
	name = "Jjajeungna Gauntlets"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/gloves/roguetown/plate/kote


/datum/anvil_recipe/kazenguniteweapons
	abstract_type = /datum/anvil_recipe/kazenguniteweapons
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	craftdiff = SKILL_LEVEL_MASTER
	req_trait = TRAIT_KAZENGUNITE_SMITH
	hides_from_books = TRUE

/datum/anvil_recipe/kazenguniteweapons/tanto
	name = "Tanto"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun

/datum/anvil_recipe/kazenguniteweapons/kodachi
	name = "Kodachi"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short/kazengun

/datum/anvil_recipe/kazenguniteweapons/ssangsudo
	name = "Ssangsudo"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo

/datum/anvil_recipe/kazenguniteweapons/kanabo
	name = "Kanabo (+1 Small Log)"
	req_bar = /obj/item/ingot/steel
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/kanabo


/datum/anvil_recipe/kazenguniteweapons/kodachiscabbard
	name = "Plain Lacquer Scabbard (+1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list (/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/scabbard/sword/kazengun/kodachi

/datum/anvil_recipe/kazenguniteweapons/sheath
	name = "Plain Lacquer Sheath (+1 Small Log)"
	req_bar = /obj/item/ingot/steel
	additional_items = list (/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/scabbard/sheath/kazengun



