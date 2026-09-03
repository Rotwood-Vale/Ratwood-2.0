/datum/anvil_recipe/weapons
	abstract_type = /datum/anvil_recipe/weapons
	appro_skill = /datum/skill/craft/weaponsmithing  // inheritance yay !!
	i_type = "Weapons"

/datum/anvil_recipe/weapons/ancient
	abstract_type = /datum/anvil_recipe/weapons/ancient
	req_bar = /obj/item/ingot/gilbranze
	craftdiff = SKILL_LEVEL_JOURNEYMAN // Steel equivalence

/datum/anvil_recipe/weapons/decrepit
	abstract_type = /datum/anvil_recipe/weapons/decrepit
	req_bar = /obj/item/ingot/decrepit
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/weapons/copper
	abstract_type = /datum/anvil_recipe/weapons/copper
	req_bar = /obj/item/ingot/copper
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/weapons/bronze
	abstract_type = /datum/anvil_recipe/weapons/bronze
	req_bar = /obj/item/ingot/bronze
	craftdiff = SKILL_LEVEL_NOVICE //Situationally better than iron, but far more limited in terms of recipes and availability.

/datum/anvil_recipe/weapons/iron
	abstract_type = /datum/anvil_recipe/weapons/iron
	req_bar = /obj/item/ingot/iron
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/anvil_recipe/weapons/steel
	abstract_type = /datum/anvil_recipe/weapons/steel
	req_bar = /obj/item/ingot/steel
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/weapons/decorated
	abstract_type = /datum/anvil_recipe/weapons/decorated
	craftdiff = SKILL_LEVEL_EXPERT
	req_bar = /obj/item/ingot/gold

/datum/anvil_recipe/weapons/silver
	abstract_type = /datum/anvil_recipe/weapons/silver
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/weapons/psy
	abstract_type = /datum/anvil_recipe/weapons/psy
	req_bar = /obj/item/ingot/silverblessed
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/weapons/holysteel
	abstract_type = /datum/anvil_recipe/weapons/holysteel
	req_bar = /obj/item/ingot/steelholy
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/weapons/blacksteel
	abstract_type = /datum/anvil_recipe/weapons/blacksteel
	req_bar = /obj/item/ingot/blacksteel
	craftdiff = SKILL_LEVEL_MASTER


// DECREPIT/ANCIENT ALLOY

/datum/anvil_recipe/weapons/ancient/flail/
	name = "Flail, Ancient"
	created_item = /obj/item/rogueweapon/flail/sflail/ancient
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/decrepit/flail
	name = "Flail, Decrepit"
	created_item = /obj/item/rogueweapon/flail/sflail/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/ancient/dagger
	name = "Dagger, Ancient"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/decrepit/dagger
	name = "Dagger, Decrepit"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/ancient/knuckles
	name = "Knuckles, Ancient"
	created_item = /obj/item/rogueweapon/knuckles/ancient
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/decrepit/knuckles
	name = "Knuckles, Decrepit"
	created_item = /obj/item/rogueweapon/knuckles/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/ancient/shortsword
	name = "Shortsword, Ancient"
	created_item = /obj/item/rogueweapon/sword/short/ancient
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decrepit/shortsword
	name = "Shortsword, Decrepit"
	created_item = /obj/item/rogueweapon/sword/short/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/ancient/gladius
	name = "Gladius, Ancient"
	created_item = /obj/item/rogueweapon/sword/short/gladius/ancient
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decrepit/gladius
	name = "Gladius, Decrepit"
	created_item = /obj/item/rogueweapon/sword/short/gladius/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/ancient/khopesh
	name = "Khopesh, Ancient"
	created_item = /obj/item/rogueweapon/sword/sabre/ancient
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decrepit/khopesh
	name = "Khopesh, Decrepit"
	created_item = /obj/item/rogueweapon/sword/sabre/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/ancient/handaxe
	name = "Axe, Ancient"
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/decrepit/handaxe
	name = "Axe, Decrepit"
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/ancient/mace
	name = "Mace, Ancient"
	created_item = /obj/item/rogueweapon/mace/steel/ancient
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/decrepit/mace
	name = "Mace, Decrepit"
	created_item = /obj/item/rogueweapon/mace/steel/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/ancient/warhammer
	name = "Warhammer, Ancient"
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/ancient
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/decrepit/warhammer
	name = "Warhammer, Decrepit"
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/ancient/tossblade
	name = "Tossblades, Ancient (x4)"
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel/ancient
	createditem_num = 4
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/decrepit/tossblade
	name = "Tossblades, Decrepit (x4)"
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel/ancient/decrepit
	createditem_num = 4
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/ancient/gsw
	name = "Greatsword, Ancient (+2 Gilbranze)"
	created_item = /obj/item/rogueweapon/greatsword/ancient
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/ingot/gilbranze)
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decrepit/gsw
	name = "Greatsword, Decrepit (+2 Alloy)"
	created_item = /obj/item/rogueweapon/greatsword/ancient/decrepit
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/ingot/decrepit)
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/ancient/bardiche
	name = "Bardiche, Ancient (+1 log, +1 Gilbranze)"
	created_item = /obj/item/rogueweapon/halberd/bardiche/ancient
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/decrepit/bardiche
	name = "Bardiche, Decrepit (+1 log, +1 Alloy)"
	created_item = /obj/item/rogueweapon/halberd/bardiche/ancient/decrepit
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/ancient/grandmace
	name = "Grand Mace, Purified (+1 Gilbranze, +1 Small Log)"
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel/ancient
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/decrepit/grandmace
	name = "Grand Mace, Decrepit (+1 Alloy, +1 Small Log)"
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/ancient/spear
	name = "Spear, Ancient (+1 Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/ancient
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/decrepit/spear
	name = "Spear, Decrepit(+1 Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/ancient/javelin
	name = "Javelin, Ancient (+1 Small Log) (x2)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/decrepit/javelin
	name = "Javelin, Decrepit (+1 Small Log) (x2)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient/decrepit
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_AMMO
// COPPER

/datum/anvil_recipe/weapons/copper/caxe
	name = "Hatchet, Copper (+1 Copper)"
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe/copper
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/copper/cbludgeon
	name = "Budgeon, Copper (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel/copper
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/copper/cdagger
	name = "Knife, Copper (x2)"
	created_item = /obj/item/rogueweapon/huntingknife/copper
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/copper/cmesser
	name = "Messer, Copper"
	created_item = /obj/item/rogueweapon/sword/short/messer/copper
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/copper/cspears
	name = "Spear, Copper (+1 Small Log) (x2)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/stone/copper
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/copper/crhomphaia
	name = "Rhomphaia, Copper (+1 Copper)"
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia/copper
	display_category = ITEM_CAT_WEAPONS_SWORDS

// BRONZE

/datum/anvil_recipe/weapons/bronze/katar
	name = "Katar, Bronze"
	created_item = /obj/item/rogueweapon/katar/bronze
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/bronzeknuckle
	name = "Knuckledusters, Bronze"
	created_item = /obj/item/rogueweapon/knuckles/bronzeknuckles
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/bronze/gladius
	name = "Gladius, Bronze"
	created_item = /obj/item/rogueweapon/sword/short/gladius
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/sword
	name = "Sword, Bronze"
	created_item = /obj/item/rogueweapon/sword/bronze
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/bronze/axe
	name = "Axe, Bronze"
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/bronze
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/bronze/mace
	name = "Mace, Bronze"
	created_item = /obj/item/rogueweapon/mace/bronze
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/bronze/dagger
	name = "Dagger, Bronze"
	created_item = /obj/item/rogueweapon/huntingknife/bronze
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/bronze/whip
	name = "Whip, Bronze-Tipped (+3 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/whip/bronze
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/bronze/urumi
	name = "Urumi, Bronze (+1 Bronze)"
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/rogueweapon/whip/urumi/bronze
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/bronze/spear
	name = "Spear, Bronze (+1 Bronze, +1 Small Log)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/bronze
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/bronze/trident
	name = "Trident, Bronze (+1 Steel, +1 Iron, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/trident
	display_category = ITEM_CAT_WEAPONS_POLEARMS

// IRON

/datum/anvil_recipe/weapons/iron/sword
	name = "Sword, Iron"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/swordshort
	name = "Shortsword, Iron"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/short/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/messer
	name = "Messer, Iron"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/short/messer/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/shotel
	name = "Shotel, Iron (+1 Iron)"
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/sword/long/shotel/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/sabre
	name = "Sabre, Iron"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/sabre/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/urumi
	name = "Urumi, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/whip/urumi/iron
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/iron/dagger
	name = "Dagger, Iron"
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife/idagger
	createditem_num = 1
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/iron/flail
	name = "Flail, Iron"
	created_item = /obj/item/rogueweapon/flail
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/iron/huntknife
	name = "Hunting Knife, Iron"
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife
	createditem_num = 1
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/greatsword
	name = "Greatsword, Iron (+2 Iron)"
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/iron
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/claymore
	name = "Claymore, Iron (+2 Iron)"
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/zwei
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/iron/handaxe
	name = "Hatchet, Iron (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/iron/axe
	name = "Axe, Iron (+1 Stick)"
	req_blade = /obj/item/blade/iron_axe
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/iron/greataxe
	name = "Greataxe, Iron (+1 Iron, +1 Small Log)"
	req_blade = /obj/item/blade/iron_axe
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/iron/cudgel
	name = "Cudgel, Iron (+1 Stick)"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/mace
	name = "Mace, Iron (+1 Stick)"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/warhammer
	name = "Warhammer, Iron (+1 Stick)"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/warhammer
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/spear
	name = "Spear, Iron (+1 Small Log)"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/iron/bardiche
	name = "Bardiche, Iron (+1 Iron, +1 Small Log)"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd/bardiche
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/iron/lucerne
	name = "Lucerne, Iron (+1 Iron, +1 Small Log)"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak/lucerne
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/iron/polemace
	name = "Goedendag, Iron (+1 Small Log)"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/tossblade
	name = "Tossblades, Iron (x4)"
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife
	createditem_num = 4
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/iron/javelin
	name = "Javelin, Iron (+1 Small Log) (x2)"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/iron/claws
	name = "Handclaws, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/handclaw
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/iron/maul
	name = "Maul (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/mace/maul
	craftdiff = 4
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/iron/peasantwarflail
	name = "War Flail, Iron (+1 Iron, +2 Small Log)"
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/flail/peasantwarflail
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/iron/maciejowski
	name = "Maciejowski, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/sword/falchion/militia
	display_category = ITEM_CAT_WEAPONS_SWORDS

/// STEEL WEAPONS
/datum/anvil_recipe/weapons/steel/dagger
	name = "Dagger, Steel"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel
	createditem_num = 1
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/daggerparrying
	name = "Parrying Dagger, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/katar
	name = "Katar, Steel"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/katar
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/punchdagger
	name = "Punch Dagger"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/katar/punchdagger
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/steelknuckle
	name = "Knuckles, Steel"
	created_item = /obj/item/rogueweapon/knuckles
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/steel/hurlbat
	name = "Hurlbat"
	req_blade = /obj/item/blade/steel_axe
	created_item = /obj/item/rogueweapon/stoneaxe/hurlbat
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/rapier
	name = "Rapier, Steel"
	created_item = /obj/item/rogueweapon/sword/rapier
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/cutlass
	name = "Cutlass, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/cutlass
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/swordshort
	name = "Shortsword, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/falchion
	name = "Falchion, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short/falchion
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/messer
	name = "Messer, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short/messer
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/sword
	name = "Sword, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/saber
	name = "Sabre, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/shamshir
	name = "Shamshir, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre/shamshir
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/shashka
	name = "Shashka, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre/steppesman
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/hook
	name = "Hook Sword, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre/hook
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/flail
	name = "Flail, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/flail/sflail
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/steel/longsword
	name = "Longsword, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/sharpfeder
	name = "Dueling Longsword, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/frei
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/elongsword
	name = "Basket-Hilted Longsword, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/etruscan
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/shalal
	name = "Shalal Saber, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/marlin
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/shotel
	name = "Shotel, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/shotel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/urumi
	name = "Urumi, Steel (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/whip/urumi
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/steel/trainingsword
	name = "Training Sword, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/training
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/trainingsword
	name = "Training Sword, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/training
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/kriegmesser
	name = "Kriegmesser, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/battleaxe
	name = "Battle Axe, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/stoneaxe/battle
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/combatknife
	name = "Combat Knife, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/combat
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/mace
	name = "Mace, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/steel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/steel/swarhammer
	name = "Warhammer, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/steel/greatsword
	name = "Greatsword, Steel (+2 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/flamb
	name = "Flamberge, Steel (+2 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/estoc
	name = "Estoc, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/estoc
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/axe
	name = "Axe, Steel (+1 Stick)"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/pulaski
	name = "Pulaski axe (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/pick
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/greataxe
	name = "Greataxe, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/greataxe/doublehead
	name = "Double-Headed Greataxe, Steel (+2 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel/doublehead
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/steel/billhook
	name = "Billhook, Steel (+1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/billhook
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/halberd
	name = "Halberd, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/eaglebeak
	name = "Eagle's Beak (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/grandmace
	name = "Grand Mace, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/steel/partizan
	name = "Partizan, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/partizan
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/naginata
	name = "Naginata, Steel (+1 Big Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/) //looong spear
	created_item = /obj/item/rogueweapon/spear/naginata
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/boarspear
	name = "Boar Spear, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/boar
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/lance
	name = "Lance, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/lance
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/tossblade
	name = "Tossblade, Steel (x4)"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel
	createditem_num = 4
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/javelin
	name = "Javelin, Steel (+1 Small Log) (x2)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/steel/fishspear
	name = "Fishing Spear, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/fishspear
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/steel/rhomphaia
	name = "Rhomphaia, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/falx
	name = "Falx, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/falx
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/steel/claws
	name = "Handclaws, Steel (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/handclaw/steel
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/steel/maul
	name = "Grand Maul (+2 Steel)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/maul/grand
	craftdiff = 5
	display_category = ITEM_CAT_WEAPONS_MACES

/// UPGRADED WEAPONS

// GOLD

/datum/anvil_recipe/weapons/decorated/sword
	name = "Sword, Decorated (+1 Steel Sword)"
	additional_items = list(/obj/item/rogueweapon/sword)
	created_item = /obj/item/rogueweapon/sword/decorated
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/saber
	name = "Sabre, Decorated (+1 Steel Sabre)"
	additional_items = list(/obj/item/rogueweapon/sword/sabre)
	created_item = /obj/item/rogueweapon/sword/sabre/dec
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/rapier
	name = "Rapier, Decorated (+1 Steel Rapier)"
	additional_items = list(/obj/item/rogueweapon/sword/rapier)
	created_item = /obj/item/rogueweapon/sword/rapier/dec
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/decorated/longsword
	name = "Longsword, Decorated (+1 Steel Longsword)"
	additional_items = list(/obj/item/rogueweapon/sword/long)
	created_item = /obj/item/rogueweapon/sword/long/dec
	display_category = ITEM_CAT_WEAPONS_SWORDS


// SILVER

/datum/anvil_recipe/weapons/silver/elfsaber
	name = "Sabre, Elvish (+1 Gold)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/rogueweapon/sword/sabre/elf
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/elfdagger
	name = "Dagger, Elvish (+1 Silver)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/silver/dagger
	name = "Dagger, Silver"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/silver/shortsword
	name = "Shortsword, Silver"
	created_item = /obj/item/rogueweapon/sword/short/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/sword
	name = "Arming Sword, Silver (+1 Silver)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/sword
	name = "Rapier, Silver (+1 Silver)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/rapier/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/longsword
	name = "Longsword, Silver (+2 Silver, +1 Small Log)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/broadsword
	name = "Broadsword, Silver (+2 Silver, +1 Small Log)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser/silver
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/silver/waraxe
	name = "War Axe, Silver (+2 Silver, +1 Small Log)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/silver
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/silver/poleaxe
	name = "Poleaxe, Silver (+2 Silver, +2 Small Logs)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/silver
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/silver/mace
	name = "Mace, Silver (+1 Silver)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/mace/steel/silver
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/silver/warhammer
	name = "Warhammer, Silver (+1 Silver, +1 Small Log)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/silver
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/silver/quarterstaff
	name = "Quarterstaff, Silver (+1 Silver, +3 Small Logs)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/woodstaff/quarterstaff/silver
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/silver/spear
	name = "Spear, Silver (+1 Silver, +3 Small Logs)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/silver
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/silver/morningstar
	name = "Morningstar, Silver (+1 Silver, +1 Chain)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/rope/chain)
	created_item = /obj/item/rogueweapon/flail/sflail/silver
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/silver/whip
	name = "Whip, Silver (+1 Leather Whip)"
	additional_items = list(/obj/item/rogueweapon/whip)
	created_item = /obj/item/rogueweapon/whip/silver
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/silver/urumi
	name = "Urumi, Silver (+1 Silver)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/whip/urumi/silver
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/silver/tossblade
	name = "Tossblades, Silver (+1 Silver)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/silver
	createditem_num = 4
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/silver/javelin
	name = "Javelins, Silver (+1 Silver, Small Log)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/silver
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_AMMO


/// SHIELDS

/datum/anvil_recipe/weapons/iron/towershield
	name = "Tower Shield (+1 Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/shield/tower
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/steel/kiteshield
	name = "Kite Shield (+1 Steel, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/ancient/shield
	name = "Kite Shield, Ancient (+1 Gilbranze, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/ancient
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/decrepit/shield
	name = "Kite Shield, Decrepit (+1 Alloy, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/ancient/shield
	name = "Hoplon Shield, Ancient (+1 Gilbranze)"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/rogueweapon/shield/gilbranze
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/decrepit/shield
	name = "Hoplon Shield, Decrepit (+1 Alloy)"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/rogueweapon/shield/gilbranze/decrepit
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/ancient/shield
	name = "Hoplon Greatshield, Ancient (+3 Gilbranze, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/ingot/gilbranze, /obj/item/ingot/gilbranze, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/gilbranze/great
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/decrepit/shield
	name = "Hoplon Greatshield, Decrepit (+3 Alloy, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/ingot/decrepit, /obj/item/ingot/decrepit, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/gilbranze/great/decrepit
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/steel/buckler
	name = "Buckler (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/shield/buckler
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/ancient/buckler
	name = "Buckler, Ancient (+1 Gilbranze)"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/rogueweapon/shield/buckler/ancient
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/decrepit/buckler
	name = "Buckler, Decrepit (+1 Gilbranze)"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/rogueweapon/shield/buckler/ancient/decrepit
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/iron/roundshield
	name = "Shield, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/shield/iron
	display_category = ITEM_CAT_WEAPONS_SHIELDS

// CROSSBOW

/datum/anvil_recipe/weapons/steel/xbow
	name = "Crossbow (+1 Small Log, +1 Fiber)"
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/natural/fibers)
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	display_category = ITEM_CAT_ENG_COMBAT

/datum/anvil_recipe/weapons/iron/bolts
	name = "Crossbow Bolts (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/ancient/bolts
	name = "Bolts, Ancient (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/ancient
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/decrepit/bolts
	name = "Bolts, Decrepit (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/decrepit
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/iron/bluntbolts
	name = "Bolts, Training (+2 Stick) (x20)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/blunt
	createditem_num = 10
	i_type = "Ammo"
	craftdiff = 1
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/iron/heavybluntbolts
	name = "Bolts, Heavy Blunt (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

// BOW

/datum/anvil_recipe/weapons/iron/arrows
	name = "Broadhead Arrows, Iron (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/steel/arrows
	name = "Bodkin Arrows, Steel (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/ancient/arrows
	name = "Bodkin Arrows, Ancient (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel/ancient
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/decrepit/arrows
	name = "Broadhead Arrows, Decrepit (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron/decrepit
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

// SLING

/datum/anvil_recipe/weapons/iron/slingbullets
	name = "Sling Bullets, Iron (x10)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/bronze/slingbullets
	name = "Sling Bullets, Bronze (x10)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/ancient/slingbullets
	name = "Sling Bullets, Ancient (x10)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/ancient
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/decrepit/slingbullets
	name = "Sling Bullets, Decrepit (x10)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/decrepit
	createditem_num = 10
	i_type = "Ammo"
	display_category = ITEM_CAT_WEAPONS_AMMO

// UNIQUE

/datum/anvil_recipe/weapons/iron/execution
	name = "Executioner's Sword (+2 Iron)"
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/sword/long/exe
	craftdiff = 4
	display_category = ITEM_CAT_WEAPONS_SWORDS

// BLACKSTEEL

/datum/anvil_recipe/weapons/blacksteel/arming
	name = "Blacksteel Arming Sword (+1 Blacksteel, +1 Saffira, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/violet, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/decsword
	name = "Blacksteel Arming Sword, Decorated (+1 Steel Arming Sword, +1 Saffira, +1 Gold, +1 Silk)"
	additional_items = list(/obj/item/rogueweapon/sword, /obj/item/ingot/gold, /obj/item/roguegem/violet, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/decorated/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/longword
	name = "Blacksteel Longsword (+2 Blacksteel, +1 Saffira, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/violet, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/long/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/flamberge
	name = "Blacksteel Flamberge (+3 Blacksteel, +1 Rontz, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/ruby, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/rapier
	name = "Blacksteel Rapier (+1 Blacksteel, +1 Gemerald, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/green, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/rapier/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/messer
	name = "Blacksteel Messer (+1 Blacksteel, +1 Rontz, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/ruby, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/short/messer/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/blacksteel/lance
	name = "Blacksteel Lance (+2 Blacksteel, +1 Gemerald +1 Small Log, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/green, /obj/item/grown/log/tree/small, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/spear/lance/blacksteel
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/blacksteel/halberd
	name = "Blacksteel Halberd (+3 Blacksteel, +1 Blortz, +1 Small Log, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/blue, /obj/item/grown/log/tree/small, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/halberd/blacksteel
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/blacksteel/polehammer
	name = "Blacksteel Polehammer (+3 Blacksteel, +1 Toper, +1 Small Log, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/yellow, /obj/item/grown/log/tree/small, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/eaglebeak/blacksteel
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/blacksteel/mace
	name = "Blacksteel Mace (+2 Blacksteel, +1 Toper, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/yellow, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/mace/blacksteel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/blacksteel/warhammer
	name = "Blacksteel Warhammer (+2 Blacksteel, +1 Silk, +1 Toper, +1 Stick)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/yellow, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/warhammer/blacksteel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/blacksteel/knuckles
	name = "Blacksteel Knuckles (+1 Dorpel, +1 Silk)"//unarmed chuds get fucked
	additional_items = list(/obj/item/roguegem/diamond, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/knuckles/blacksteel
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/blacksteel/hurlbat
	name = "Blacksteel Hurlbat (+1 Silk)"
	additional_items = list(/obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/stoneaxe/hurlbat/blacksteel
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/blacksteel/axe
	name = "Blacksteel Axe (+2 Blacksteel, +1 Toper, +1 Silk, +1 Stick)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/yellow, /obj/item/natural/silk, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/battle/blacksteel
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/blacksteel/greataxe
	name = "Blacksteel Greataxe (+3 Blacksteel, +1 Rontz, +1 Small Log, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/ruby, /obj/item/grown/log/tree/small, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/greataxe/blacksteel
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/blacksteel/whip
	name = "Whip, Blacksteel-Tipped (+1 Saffira, +1 Leather Whip, +1 Silk)"
	additional_items = list(/obj/item/roguegem/violet, /obj/item/rogueweapon/whip, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/whip/blacksteel
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/blacksteel/urumi
	name = "Urumi, Blacksteel (+1 Blacksteel, +1 Saffira, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/violet, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/whip/urumi/blacksteel
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/blacksteel/flail
	name = "Blacksteel Flail (+2 Blacksteel, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/flail/blacksteel
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/blacksteel/dagger
	name = "Blacksteel Dagger (+1 Rontz, +1 Silk)"
	additional_items = list(/obj/item/roguegem/ruby, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/blacksteel
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/blacksteel/misericorde
	name = "Blacksteel Misericorde (+1 Blacksteel, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/blacksteel/heavy
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/blacksteel/tossblades
	name = "Blacksteel Tossblades (+1 Silk) (x3)"
	additional_items = list(/obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/blacksteel
	createditem_num = 3
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/blacksteel/javelins
	name = "Javelin, Blacksteel (+1 Blacksteel, +1 Small Log, +1 Silk) (x2)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/grown/log/tree/small, /obj/item/natural/silk)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/blacksteel
	createditem_num = 2
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/blacksteel/bolts
	name = "Crossbow Bolts, Blacksteel (+1 Stick, +1 Silk) (x5)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/natural/silk)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/blacksteel
	createditem_num = 5
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/blacksteel/arrows
	name = "Arrows, Blacksteel (+2 Sticks, +1 Silk) (x5)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick, /obj/item/natural/silk)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/blacksteel
	createditem_num = 5
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/blacksteel/slingbullet
	name = "Sling Bullet, Blacksteel (x5)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/blacksteel
	createditem_num = 5
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/blacksteel/shield
	name = "Blacksteel Shield (+2 Blacksteel, +1 Rontz, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/roguegem/ruby, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/shield/tower/metal/blacksteel
	display_category = ITEM_CAT_WEAPONS_SHIELDS

/datum/anvil_recipe/weapons/blacksteel/handclaws
	name = "Blacksteel Claws (+1 Blacksteel, +1 Dorpel, +1 Silk)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/diamond, /obj/item/natural/silk)//unarmed chuds get fucked
	created_item = /obj/item/rogueweapon/handclaw/blacksteel
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/blacksteel/quarterstaff
	name = "Quarterstaff, Blacksteel (+1 Blacksteel, +3 Small Logs)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/blacksteel/spear
	name = "Spear, Blacksteel (+1 Blacksteel, +1 Gemerald, +2 Small Logs)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/green, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/blacksteel
	display_category = ITEM_CAT_WEAPONS_POLEARMS

//Church Weapons forged from Holy Steel

// HOLY STEEL

/datum/anvil_recipe/weapons/holysteel/church_longsword
	name = "Longsword, Templaric"
	created_item = /obj/item/rogueweapon/sword/long/church
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/holysteel/church_spear
	name = "Spear, Templaric (+1 Holy Steel)"
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/spear/holysee
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/holysteel/decasword
	name = "Longsword, Decablessed (+1 Holy Steel)"
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/sword/long/undivided
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/holysteel/decashield
	name = "Shield, Decablessed (+1 Holy Steel)"
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/shield/tower/holysee
	display_category = ITEM_CAT_WEAPONS_SHIELDS

// BLESSED SILVER

/datum/anvil_recipe/weapons/psy/axe
	name = "Psydonic War Axe (+1 Blessed Silver, +1 Stick)"
	created_item = /obj/item/rogueweapon/stoneaxe/battle/psyaxe
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/psy/poleaxe
	name = "Psydonic Poleaxe (+2 Blessed Silver, +1 Small Log)"
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/psy
	display_category = ITEM_CAT_WEAPONS_AXES

/datum/anvil_recipe/weapons/psy/mace
	name = "Psydonic Grand Mace (+1 Blessed Silver, +1 Small Log)"
	created_item = /obj/item/rogueweapon/mace/goden/psy
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/psy/spear
	name = "Psydonic Spear (+1 Blessed Silver, +1 Small Log)"
	created_item = /obj/item/rogueweapon/spear/psyspear
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/psy/dagger
	name = "Psydonic Dagger"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
	display_category = ITEM_CAT_WEAPONS_DAGGERS

/datum/anvil_recipe/weapons/psy/shortsword
	name = "Psydonic Shortsword"
	created_item = /obj/item/rogueweapon/sword/short/psy
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/psy/katar
	name = "Psydonic Katar"
	created_item = /obj/item/rogueweapon/katar/psydon
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/psy/knuckles
	name = "Psydonic Knuckledusters"
	created_item = /obj/item/rogueweapon/knuckles/psydon
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/psy/cudgel
	name = "Psydonic Handmace"
	created_item = /obj/item/rogueweapon/mace/cudgel/psy
	display_category = ITEM_CAT_WEAPONS_MACES

/datum/anvil_recipe/weapons/psy/halberd
	name = "Psydonic Halberd (+2 Blessed Silver, +1 Small Log)"
	created_item = /obj/item/rogueweapon/halberd/psyhalberd
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	display_category = ITEM_CAT_WEAPONS_POLEARMS

/datum/anvil_recipe/weapons/psy/gsword
	name = "Psydonic Greatsword (+2 Blessed Silver)"
	created_item = /obj/item/rogueweapon/greatsword/psygsword
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/psy/sword
	name = "Psydonic Longsword (+1 Blessed Silver)"
	created_item = /obj/item/rogueweapon/sword/long/psysword
	additional_items = list(/obj/item/ingot/silverblessed)
	display_category = ITEM_CAT_WEAPONS_SWORDS

/datum/anvil_recipe/weapons/psy/whip
	name = "Psydonic Whip (+3 Cured Leather)"
	created_item = /obj/item/rogueweapon/whip/psywhip_lesser
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	display_category = ITEM_CAT_WEAPONS_FLAILS

/// BLESSED SILVER, BULLION VARIANTS - FALLBACK
//cutting out the duplicate variables so it's more clear what these subtypes actually do
/datum/anvil_recipe/weapons/psy/axe/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/poleaxe/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/mace/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/spear/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/dagger/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/shortsword/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/katar/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/knuckles/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/cudgel/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/halberd/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/gsword/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/sword/inq
	req_bar = /obj/item/ingot/silverblessed/bullion

/datum/anvil_recipe/weapons/psy/whip/inq
	req_bar = /obj/item/ingot/silverblessed/bullion
