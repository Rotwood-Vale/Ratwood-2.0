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
	abstract_type = /datum/anvil_recipe/weapons/
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

/datum/anvil_recipe/weapons/decrepit/flail
	name = "Flail, Decrepit"
	created_item = /obj/item/rogueweapon/flail/sflail/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/dagger
	name = "Dagger, Ancient"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient

/datum/anvil_recipe/weapons/decrepit/dagger
	name = "Dagger, Decrepit"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/knuckles
	name = "Knuckles, Ancient"
	created_item = /obj/item/rogueweapon/knuckles/ancient

/datum/anvil_recipe/weapons/decrepit/knuckles
	name = "Knuckles, Decrepit"
	created_item = /obj/item/rogueweapon/knuckles/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/shortsword
	name = "Shortsword, Ancient"
	created_item = /obj/item/rogueweapon/sword/short/ancient

/datum/anvil_recipe/weapons/decrepit/shortsword
	name = "Shortsword, Decrepit"
	created_item = /obj/item/rogueweapon/sword/short/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/gladius
	name = "Gladius, Ancient"
	created_item = /obj/item/rogueweapon/sword/short/gladius/ancient

/datum/anvil_recipe/weapons/decrepit/gladius
	name = "Gladius, Decrepit"
	created_item = /obj/item/rogueweapon/sword/short/gladius/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/khopesh
	name = "Khopesh, Ancient"
	created_item = /obj/item/rogueweapon/sword/sabre/ancient

/datum/anvil_recipe/weapons/decrepit/khopesh
	name = "Khopesh, Decrepit"
	created_item = /obj/item/rogueweapon/sword/sabre/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/handaxe
	name = "Axe, Ancient"
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient

/datum/anvil_recipe/weapons/decrepit/handaxe
	name = "Axe, Decrepit"
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/mace
	name = "Mace, Ancient"
	created_item = /obj/item/rogueweapon/mace/steel/ancient

/datum/anvil_recipe/weapons/decrepit/mace
	name = "Mace, Decrepit"
	created_item = /obj/item/rogueweapon/mace/steel/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/warhammer
	name = "Warhammer, Ancient"
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/ancient

/datum/anvil_recipe/weapons/decrepit/warhammer
	name = "Warhammer, Decrepit"
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/tossblade
	name = "Tossblades, Ancient (x4)"
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel/ancient
	createditem_num = 4

/datum/anvil_recipe/weapons/decrepit/tossblade
	name = "Tossblades, Decrepit (x4)"
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel/ancient/decrepit
	createditem_num = 4

/datum/anvil_recipe/weapons/ancient/gsw
	name = "Greatsword, Ancient (+2 Gilbranze)"
	created_item = /obj/item/rogueweapon/greatsword/ancient
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/ingot/gilbranze)

/datum/anvil_recipe/weapons/decrepit/gsw
	name = "Greatsword, Decrepit (+2 Alloy)"
	created_item = /obj/item/rogueweapon/greatsword/ancient/decrepit
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/ingot/decrepit)

/datum/anvil_recipe/weapons/ancient/bardiche
	name = "Bardiche, Ancient (+1 log, +1 Gilbranze)"
	created_item = /obj/item/rogueweapon/halberd/bardiche/ancient
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/decrepit/bardiche
	name = "Bardiche, Decrepit (+1 log, +1 Alloy)"
	created_item = /obj/item/rogueweapon/halberd/bardiche/ancient/decrepit
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/ancient/grandmace
	name = "Grand Mace, Purified (+1 Gilbranze, +1 Small Log)"
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel/ancient

/datum/anvil_recipe/weapons/decrepit/grandmace
	name = "Grand Mace, Decrepit (+1 Alloy, +1 Small Log)"
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/spear
	name = "Spear, Ancient (+1 Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/ancient

/datum/anvil_recipe/weapons/decrepit/spear
	name = "Spear, Decrepit(+1 Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/javelin
	name = "Javelin, Ancient (+1 Small Log) (x2)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient
	createditem_num = 2

/datum/anvil_recipe/weapons/decrepit/javelin
	name = "Javelin, Decrepit (+1 Small Log) (x2)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient/decrepit
	createditem_num = 2

// COPPER

/datum/anvil_recipe/weapons/copper/caxe
	name = "Hatchet, Copper (+1 Copper)"
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe/copper

/datum/anvil_recipe/weapons/copper/cbludgeon
	name = "Budgeon, Copper (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel/copper

/datum/anvil_recipe/weapons/copper/cdagger
	name = "Knife, Copper (x2)"
	created_item = /obj/item/rogueweapon/huntingknife/copper
	createditem_num = 2

/datum/anvil_recipe/weapons/copper/cmesser
	name = "Messer, Copper"
	created_item = /obj/item/rogueweapon/sword/short/messer/copper

/datum/anvil_recipe/weapons/copper/cspears
	name = "Spear, Copper (+1 Small Log) (x2)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/stone/copper
	createditem_num = 2

/datum/anvil_recipe/weapons/copper/crhomphaia
	name = "Rhomphaia, Copper (+1 Copper)"
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia/copper

// BRONZE

/datum/anvil_recipe/weapons/bronze/katar
	name = "Katar, Bronze"
	created_item = /obj/item/rogueweapon/katar/bronze

/datum/anvil_recipe/weapons/bronze/bronzeknuckle
	name = "Knuckledusters, Bronze"
	created_item = /obj/item/rogueweapon/knuckles/bronzeknuckles

/datum/anvil_recipe/weapons/bronze/gladius
	name = "Gladius, Bronze"
	created_item = /obj/item/rogueweapon/sword/short/gladius

/datum/anvil_recipe/weapons/bronze/sword
	name = "Sword, Bronze"
	created_item = /obj/item/rogueweapon/sword/bronze

/datum/anvil_recipe/weapons/bronze/axe
	name = "Axe, Bronze"
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/bronze

/datum/anvil_recipe/weapons/bronze/mace
	name = "Mace, Bronze"
	created_item = /obj/item/rogueweapon/mace/bronze

/datum/anvil_recipe/weapons/bronze/dagger
	name = "Dagger, Bronze"
	created_item = /obj/item/rogueweapon/huntingknife/bronze

/datum/anvil_recipe/weapons/bronze/whip
	name = "Whip, Bronze-Tipped (+3 Cured Leather)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/whip/bronze

/datum/anvil_recipe/weapons/bronze/spear
	name = "Spear, Bronze (+1 Bronze, +1 Small Log)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/bronze

/datum/anvil_recipe/weapons/bronze/trident
	name = "Trident, Bronze (+1 Steel, +1 Iron, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/trident

// IRON

/datum/anvil_recipe/weapons/iron/sword
	name = "Sword, Iron"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/iron

/datum/anvil_recipe/weapons/iron/swordshort
	name = "Shortsword, Iron"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/short/iron

/datum/anvil_recipe/weapons/iron/messer
	name = "Messer, Iron"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/short/messer/iron

/datum/anvil_recipe/weapons/iron/sabre
	name = "Sabre, Iron"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/sabre/iron

/datum/anvil_recipe/weapons/iron/dagger
	name = "Dagger, Iron"
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife/idagger
	createditem_num = 1

/datum/anvil_recipe/weapons/iron/flail
	name = "Flail, Iron"
	created_item = /obj/item/rogueweapon/flail

/datum/anvil_recipe/weapons/iron/huntknife
	name = "Hunting Knife, Iron"
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife
	createditem_num = 1

/datum/anvil_recipe/weapons/steel/greatsword
	name = "Greatsword, Iron (+2 Iron)"
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/iron

/datum/anvil_recipe/weapons/iron/claymore
	name = "Claymore, Iron (+2 Iron)"
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/zwei

/datum/anvil_recipe/weapons/iron/handaxe
	name = "Hatchet, Iron (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe

/datum/anvil_recipe/weapons/iron/axe
	name = "Axe, Iron (+1 Stick)"
	req_blade = /obj/item/blade/iron_axe
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut

/datum/anvil_recipe/weapons/iron/greataxe
	name = "Greataxe, Iron (+1 Iron, +1 Small Log)"
	req_blade = /obj/item/blade/iron_axe
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe

/datum/anvil_recipe/weapons/iron/cudgel
	name = "Cudgel, Iron (+1 Stick)"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel

/datum/anvil_recipe/weapons/iron/mace
	name = "Mace, Iron (+1 Stick)"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace

/datum/anvil_recipe/weapons/iron/warhammer
	name = "Warhammer, Iron (+1 Stick)"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/warhammer

/datum/anvil_recipe/weapons/iron/spear
	name = "Spear, Iron (+1 Small Log)"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear

/datum/anvil_recipe/weapons/iron/bardiche
	name = "Bardiche, Iron (+1 Iron, +1 Small Log)"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd/bardiche

/datum/anvil_recipe/weapons/iron/lucerne
	name = "Lucerne, Iron (+1 Iron, +1 Small Log)"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak/lucerne

/datum/anvil_recipe/weapons/iron/polemace
	name = "Goedendag, Iron (+1 Small Log)"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden

/datum/anvil_recipe/weapons/iron/tossblade
	name = "Tossblades, Iron (x4)"
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife
	createditem_num = 4

/datum/anvil_recipe/weapons/iron/javelin
	name = "Javelin, Iron (+1 Small Log) (x2)"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin
	createditem_num = 2

/datum/anvil_recipe/weapons/iron/claws
	name = "Handclaws, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/handclaw

/datum/anvil_recipe/weapons/iron/maul
	name = "Maul (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/mace/maul
	craftdiff = 4

/// STEEL WEAPONS
/datum/anvil_recipe/weapons/steel/dagger
	name = "Dagger, Steel"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel
	createditem_num = 1

/datum/anvil_recipe/weapons/steel/daggerparrying
	name = "Parrying Dagger, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying

/datum/anvil_recipe/weapons/steel/katar
	name = "Katar, Steel"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/katar

/datum/anvil_recipe/weapons/steel/punchdagger
	name = "Punch Dagger"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/katar/punchdagger

/datum/anvil_recipe/weapons/steel/steelknuckle
	name = "Knuckles, Steel"
	created_item = /obj/item/rogueweapon/knuckles

/datum/anvil_recipe/weapons/steel/hurlbat
	name = "Hurlbat"
	req_blade = /obj/item/blade/steel_axe
	created_item = /obj/item/rogueweapon/stoneaxe/hurlbat

/datum/anvil_recipe/weapons/steel/rapier
	name = "Rapier, Steel"
	created_item = /obj/item/rogueweapon/sword/rapier

/datum/anvil_recipe/weapons/steel/cutlass
	name = "Cutlass, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/cutlass

/datum/anvil_recipe/weapons/steel/swordshort
	name = "Shortsword, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short

/datum/anvil_recipe/weapons/steel/falchion
	name = "Falchion, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short/falchion

/datum/anvil_recipe/weapons/steel/messer
	name = "Messer, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short/messer

/datum/anvil_recipe/weapons/steel/sword
	name = "Sword, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword

/datum/anvil_recipe/weapons/steel/saber
	name = "Sabre, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre

/datum/anvil_recipe/weapons/steel/flail
	name = "Flail, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/flail/sflail

/datum/anvil_recipe/weapons/steel/longsword
	name = "Longsword, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long

/datum/anvil_recipe/weapons/steel/trainingsword
	name = "Training Sword, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/training

/datum/anvil_recipe/weapons/steel/trainingsword
	name = "Training Sword, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/training

/datum/anvil_recipe/weapons/steel/kriegmesser
	name = "Kriegmesser, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser

/datum/anvil_recipe/weapons/steel/battleaxe
	name = "Battle Axe, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/stoneaxe/battle

/datum/anvil_recipe/weapons/steel/combatknife
	name = "Combat Knife, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/combat

/datum/anvil_recipe/weapons/steel/mace
	name = "Mace, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/steel

/datum/anvil_recipe/weapons/steel/swarhammer
	name = "Warhammer, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel

/datum/anvil_recipe/weapons/steel/greatsword
	name = "Greatsword, Steel (+2 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword

/datum/anvil_recipe/weapons/steel/flamb
	name = "Flamberge, Steel (+2 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge

/datum/anvil_recipe/weapons/steel/estoc
	name = "Estoc, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/estoc

/datum/anvil_recipe/weapons/steel/axe
	name = "Axe, Steel (+1 Stick)"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel

/datum/anvil_recipe/weapons/steel/pulaski
	name = "Pulaski axe (+1 Stick)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/pick

/datum/anvil_recipe/weapons/steel/greataxe
	name = "Greataxe, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel

/datum/anvil_recipe/weapons/steel/greataxe/doublehead
	name = "Double-Headed Greataxe, Steel (+2 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel/doublehead

/datum/anvil_recipe/weapons/steel/billhook
	name = "Billhook, Steel (+1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/billhook

/datum/anvil_recipe/weapons/steel/halberd
	name = "Halberd, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd

/datum/anvil_recipe/weapons/steel/eaglebeak
	name = "Eagle's Beak (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak

/datum/anvil_recipe/weapons/steel/grandmace
	name = "Grand Mace, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel

/datum/anvil_recipe/weapons/steel/partizan
	name = "Partizan, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/partizan

/datum/anvil_recipe/weapons/steel/naginata
	name = "Naginata, Steel (+1 Big Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/) //looong spear
	created_item = /obj/item/rogueweapon/spear/naginata

/datum/anvil_recipe/weapons/steel/boarspear
	name = "Boar Spear, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/boar

/datum/anvil_recipe/weapons/steel/lance
	name = "Lance, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/lance

/datum/anvil_recipe/weapons/steel/tossblade
	name = "Tossblade, Steel (x4)"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel
	createditem_num = 4

/datum/anvil_recipe/weapons/steel/javelin
	name = "Javelin, Steel (+1 Small Log) (x2)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel
	createditem_num = 2

/datum/anvil_recipe/weapons/steel/fishspear
	name = "Fishing Spear, Steel (+1 Steel, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/fishspear

/datum/anvil_recipe/weapons/steel/rhomphaia
	name = "Rhomphaia, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia

/datum/anvil_recipe/weapons/steel/falx
	name = "Falx, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/falx

/datum/anvil_recipe/weapons/steel/claws
	name = "Handclaws, Steel (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/handclaw/steel

/datum/anvil_recipe/weapons/steel/maul
	name = "Grand Maul (+2 Steel)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/maul/grand
	craftdiff = 5

/// UPGRADED WEAPONS

// GOLD

/datum/anvil_recipe/weapons/decorated/sword
	name = "Sword, Decorated (+1 Steel Sword)"
	additional_items = list(/obj/item/rogueweapon/sword)
	created_item = /obj/item/rogueweapon/sword/decorated

/datum/anvil_recipe/weapons/decorated/saber
	name = "Sabre, Decorated (+1 Steel Sabre)"
	additional_items = list(/obj/item/rogueweapon/sword/sabre)
	created_item = /obj/item/rogueweapon/sword/sabre/dec

/datum/anvil_recipe/weapons/decorated/rapier
	name = "Rapier, Decorated (+1 Steel Rapier)"
	additional_items = list(/obj/item/rogueweapon/sword/rapier)
	created_item = /obj/item/rogueweapon/sword/rapier/dec

/datum/anvil_recipe/weapons/decorated/longsword
	name = "Longsword, Decorated (+1 Steel Longsword)"
	additional_items = list(/obj/item/rogueweapon/sword/long)
	created_item = /obj/item/rogueweapon/sword/long/dec


// SILVER

/datum/anvil_recipe/weapons/silver/elfsaber
	name = "Sabre, Elvish (+1 Gold)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/rogueweapon/sword/sabre/elf

/datum/anvil_recipe/weapons/silver/elfdagger
	name = "Dagger, Elvish (+1 Silver)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish

/datum/anvil_recipe/weapons/silver/dagger
	name = "Dagger, Silver"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver

/datum/anvil_recipe/weapons/silver/shortsword
	name = "Shortsword, Silver"
	created_item = /obj/item/rogueweapon/sword/short/silver

/datum/anvil_recipe/weapons/silver/sword
	name = "Arming Sword, Silver (+1 Silver)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/silver

/datum/anvil_recipe/weapons/silver/sword
	name = "Rapier, Silver (+1 Silver)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/rapier/silver

/datum/anvil_recipe/weapons/silver/longsword
	name = "Longsword, Silver (+2 Silver, +1 Small Log)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/silver

/datum/anvil_recipe/weapons/silver/broadsword
	name = "Broadsword, Silver (+2 Silver, +1 Small Log)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser/silver

/datum/anvil_recipe/weapons/silver/waraxe
	name = "War Axe, Silver (+2 Silver, +1 Small Log)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/silver

/datum/anvil_recipe/weapons/silver/poleaxe
	name = "Poleaxe, Silver (+2 Silver, +2 Small Logs)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/silver

/datum/anvil_recipe/weapons/silver/mace
	name = "Mace, Silver (+1 Silver)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/mace/steel/silver

/datum/anvil_recipe/weapons/silver/warhammer
	name = "Warhammer, Silver (+1 Silver, +1 Small Log)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/silver

/datum/anvil_recipe/weapons/silver/quarterstaff
	name = "Quarterstaff, Silver (+1 Silver, +3 Small Logs)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/woodstaff/quarterstaff/silver

/datum/anvil_recipe/weapons/silver/spear
	name = "Spear, Silver (+1 Silver, +3 Small Logs)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/silver

/datum/anvil_recipe/weapons/silver/morningstar
	name = "Morningstar, Silver (+1 Silver, +1 Chain)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/rope/chain)
	created_item = /obj/item/rogueweapon/flail/sflail/silver

/datum/anvil_recipe/weapons/silver/whip
	name = "Whip, Silver (+1 Leather Whip)"
	additional_items = list(/obj/item/rogueweapon/whip)
	created_item = /obj/item/rogueweapon/whip/silver

/datum/anvil_recipe/weapons/silver/tossblade
	name = "Tossblades, Silver (+1 Silver)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/silver
	createditem_num = 4

/datum/anvil_recipe/weapons/silver/javelin
	name = "Javelins, Silver (+1 Silver, Small Log)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/silver
	createditem_num = 2


/datum/anvil_recipe/weapons/bronze/gladius
	name = "Gladius, Bronze"
	created_item = /obj/item/rogueweapon/sword/short/gladius
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/spear
	name = "Spear, Bronze (+1 Bronze, +1 Small Log)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/bronze
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/trident
	name = "Trident, Bronze (+1 Steel, +1 Iron, +1 Small Log)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/trident
	craftdiff = 4

/datum/anvil_recipe/weapons/bronze/bronzeknuckle
	name = "Knuckles, Bronze"
	created_item = /obj/item/rogueweapon/knuckles/bronzeknuckles
	craftdiff = 2

/// SHIELDS

/datum/anvil_recipe/weapons/iron/towershield
	name = "Tower Shield (+1 Small Log)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/shield/tower

/datum/anvil_recipe/weapons/steel/kiteshield
	name = "Kite Shield (+1 Steel, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal

/datum/anvil_recipe/weapons/ancient/shield
	name = "Kite Shield, Ancient (+1 Gilbranze, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/ancient

/datum/anvil_recipe/weapons/decrepit/shield
	name = "Kite Shield, Decrepit (+1 Alloy, +1 Cured Leather)"
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/ancient/decrepit

/datum/anvil_recipe/weapons/steel/buckler
	name = "Buckler (+1 Steel)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/shield/buckler

/datum/anvil_recipe/weapons/ancient/buckler
	name = "Buckler, Ancient (+1 Gilbranze)"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/rogueweapon/shield/buckler

/datum/anvil_recipe/weapons/iron/roundshield
	name = "Shield, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/shield/iron

// CROSSBOW

/datum/anvil_recipe/weapons/steel/xbow
	name = "Crossbow (+1 Small Log, +1 Fiber)"
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/natural/fibers)
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow

/datum/anvil_recipe/weapons/iron/bolts
	name = "Crossbow Bolts (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/ancient/bolts
	name = "Bolts, Ancient (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/ancient
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/decrepit/bolts
	name = "Bolts, Decrepit (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/decrepit
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/iron/bluntbolts
	name = "Bolts, Training (+2 Stick) (x20)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/blunt
	createditem_num = 10
	i_type = "Ammo"
	craftdiff = 1

/datum/anvil_recipe/weapons/iron/heavybluntbolts
	name = "Bolts, Heavy Blunt (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt
	createditem_num = 10
	i_type = "Ammo"

// BOW

/datum/anvil_recipe/weapons/iron/arrows
	name = "Broadhead Arrows, Iron (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/steel/arrows
	name = "Bodkin Arrows, Steel (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/ancient/arrows
	name = "Bodkin Arrows, Ancient (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel/ancient
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/decrepit/arrows
	name = "Broadhead Arrows, Decrepit (+2 Stick) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron/decrepit
	createditem_num = 10
	i_type = "Ammo"

// SLING

/datum/anvil_recipe/weapons/iron/slingbullets
	name = "Sling Bullets, Iron (x10)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/bronze/slingbullets
	name = "Sling Bullets, Bronze (x10)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/ancient/slingbullets
	name = "Sling Bullets, Ancient (x10)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/ancient
	createditem_num = 10
	i_type = "Ammo"

/datum/anvil_recipe/weapons/decrepit/slingbullets
	name = "Sling Bullets, Decrepit (x10)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/decrepit
	createditem_num = 10
	i_type = "Ammo"

// UNIQUE

/datum/anvil_recipe/weapons/iron/execution
	name = "Executioner's Sword (+2 Iron)"
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/sword/long/exe
	craftdiff = 4


// BLACKSTEEL

/datum/anvil_recipe/weapons/blacksteel/arming
	name = "Blacksteel Arming Sword"
	created_item = /obj/item/rogueweapon/sword/blacksteel

/datum/anvil_recipe/weapons/blacksteel/flamberge
	name = "Blacksteel Flamberge (+1 Blacksteel, +1 Ruby)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/ruby)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel


/datum/anvil_recipe/weapons/blacksteel/decsword
	name = "Blacksteel Sword, Decorated (+1 Steel Sword)"
	additional_items = list(/obj/item/rogueweapon/sword)
	created_item = /obj/item/rogueweapon/sword/decorated/blacksteel

//Church Weapons forged from Holy Steel

// HOLY STEEL

/datum/anvil_recipe/weapons/holysteel/church_longsword
	name = "Longsword, Templaric"
	created_item = /obj/item/rogueweapon/sword/long/church

/datum/anvil_recipe/weapons/holysteel/church_spear
	name = "Spear, Templaric (+1 Holy Steel)"
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/spear/holysee

/datum/anvil_recipe/weapons/holysteel/decasword
	name = "Longsword, Decablessed (+1 Holy Steel)"
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/sword/long/undivided

/datum/anvil_recipe/weapons/holysteel/decashield
	name = "Shield, Decablessed (+1 Holy Steel)"
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/shield/tower/holysee

// BLESSED SILVER

/datum/anvil_recipe/weapons/psy/axe
	name = "Psydonic War Axe (+1 Blessed Silver, +1 Stick)"
	created_item = /obj/item/rogueweapon/stoneaxe/battle/psyaxe
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)

/datum/anvil_recipe/weapons/psy/poleaxe
	name = "Psydonic Poleaxe (+2 Blessed Silver, +1 Small Log)"
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/psy

/datum/anvil_recipe/weapons/psy/mace
	name = "Psydonic Grand Mace (+1 Blessed Silver, +1 Small Log)"
	created_item = /obj/item/rogueweapon/mace/goden/psy
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/psy/spear
	name = "Psydonic Spear (+1 Blessed Silver, +1 Small Log)"
	created_item = /obj/item/rogueweapon/spear/psyspear
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/psy/dagger
	name = "Psydonic Dagger"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger

/datum/anvil_recipe/weapons/psy/shortsword
	name = "Psydonic Shortsword"
	created_item = /obj/item/rogueweapon/sword/short/psy

/datum/anvil_recipe/weapons/psy/katar
	name = "Psydonic Katar"
	created_item = /obj/item/rogueweapon/katar/psydon

/datum/anvil_recipe/weapons/psy/knuckles
	name = "Psydonic Knuckledusters"
	created_item = /obj/item/rogueweapon/knuckles/psydon

/datum/anvil_recipe/weapons/psy/cudgel
	name = "Psydonic Handmace"
	created_item = /obj/item/rogueweapon/mace/cudgel/psy

/datum/anvil_recipe/weapons/psy/halberd
	name = "Psydonic Halberd (+2 Blessed Silver, +1 Small Log)"
	created_item = /obj/item/rogueweapon/halberd/psyhalberd
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/psy/gsword
	name = "Psydonic Greatsword (+2 Blessed Silver)"
	created_item = /obj/item/rogueweapon/greatsword/psygsword
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)

/datum/anvil_recipe/weapons/psy/sword
	name = "Psydonic Longsword (+1 Blessed Silver)"
	created_item = /obj/item/rogueweapon/sword/long/psysword
	additional_items = list(/obj/item/ingot/silverblessed)

/datum/anvil_recipe/weapons/psy/whip
	name = "Psydonic Whip (+3 Cured Leather)"
	created_item = /obj/item/rogueweapon/whip/psywhip_lesser
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)

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
