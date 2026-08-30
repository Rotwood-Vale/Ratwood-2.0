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
	req_bar = /obj/item/ingot/steel


/datum/anvil_recipe/kazengunite/kabuto
	name = "Kabuto (+1 Steel, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/head/roguetown/helmet/heavy/kabuto


/datum/anvil_recipe/kazengunite/halfmask
	name = "Soldier's Half-Mask"
	created_item = /obj/item/clothing/mask/rogue/facemask/steel/kazengun


/datum/anvil_recipe/kazengunite/gorget
	name = "Kazengunite Gorget"
	created_item = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun


/datum/anvil_recipe/kazengunite/samsibsa
	name = "Samsibsa Scaleplate (+1 Half-Plate, Steel, +1 Steel, +2 Cured Leather)"
	additional_items = list(/obj/item/clothing/suit/roguetown/armor/plate, /obj/item/ingot/steel, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa


/datum/anvil_recipe/kazengunite/kote
	name = "Jjajeungna Gauntlets"
	created_item = /obj/item/clothing/gloves/roguetown/plate/kote


/datum/anvil_recipe/kazengunite/ssangsudo
	name = "Ssangsudo"
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo

// I do not know why the kazen craftbook is so limited, so here is some more stuff because YAAAY more kazen stuff! //

/datum/anvil_recipe/kazengunite/mulyeog
	name = "Hwando"
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre/mulyeog

/datum/anvil_recipe/kazengunite/armoredsandals
	name = "Armored Sandals (+1 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured)
	created_item = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun

/datum/anvil_recipe/kazengunite/kabuto
	name = "Jingasa (+1 Cloth)"
	additional_items = list(/obj/item/natural/cloth)
	created_item = /obj/item/clothing/head/roguetown/helmet/kettle/jingasa

/datum/anvil_recipe/kazengunite/tanto
	name = "Steel Tanto"
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun

/datum/anvil_recipe/kazengunite/haraate
	name = "Hansimhae Cuirass (+1 Steel, +2 Cloth)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/cloth, /obj/item/natural/cloth)
	created_item = /obj/item/clothing/suit/roguetown/armor/brigandine/haraate

/datum/anvil_recipe/kazengunite/naginata
	name = "Naginata (+1 Big Log)"
	additional_items = list(/obj/item/grown/log/tree/)
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	req_blade = /obj/item/blade/steel_polearm
	created_item = /obj/item/rogueweapon/spear/naginata

/datum/anvil_recipe/kazengunite/kanabo
	name = "Kanabo (+1 Steel, +2 Small Log)"
	appro_skill = /datum/skill/craft/weaponsmithing
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/, /obj/item/grown/log/tree/small)
	i_type = "Weapons"
	req_blade = /obj/item/blade/steel_polearm
	created_item = /obj/item/rogueweapon/mace/goden/kanabo
	
/datum/anvil_recipe/kazengunite/kodachi
	name = "Kodachi"
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short/kazengun
	