/datum/anvil_recipe/weapons
	abstract_type = /datum/anvil_recipe/weapons
	appro_skill = /datum/skill/craft/weaponsmithing  // inheritance yay !!
	i_type = "武器"

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
	name = "连枷, 古代"
	created_item = /obj/item/rogueweapon/flail/sflail/ancient

/datum/anvil_recipe/weapons/decrepit/flail
	name = "连枷, 衰朽"
	created_item = /obj/item/rogueweapon/flail/sflail/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/dagger
	name = "匕首, 古代"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient

/datum/anvil_recipe/weapons/decrepit/dagger
	name = "匕首, 衰朽"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/knuckles
	name = "指虎, 古代"
	created_item = /obj/item/rogueweapon/knuckles/ancient

/datum/anvil_recipe/weapons/decrepit/knuckles
	name = "指虎, 衰朽"
	created_item = /obj/item/rogueweapon/knuckles/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/shortsword
	name = "短剑, 古代"
	created_item = /obj/item/rogueweapon/sword/short/ancient

/datum/anvil_recipe/weapons/decrepit/shortsword
	name = "短剑, 衰朽"
	created_item = /obj/item/rogueweapon/sword/short/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/gladius
	name = "短罗马剑, 古代"
	created_item = /obj/item/rogueweapon/sword/short/gladius/ancient

/datum/anvil_recipe/weapons/decrepit/gladius
	name = "短罗马剑, 衰朽"
	created_item = /obj/item/rogueweapon/sword/short/gladius/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/khopesh
	name = "镰刀剑, 古代"
	created_item = /obj/item/rogueweapon/sword/sabre/ancient

/datum/anvil_recipe/weapons/decrepit/khopesh
	name = "镰刀剑, 衰朽"
	created_item = /obj/item/rogueweapon/sword/sabre/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/handaxe
	name = "斧, 古代"
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient

/datum/anvil_recipe/weapons/decrepit/handaxe
	name = "斧, 衰朽"
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/mace
	name = "钉锤, 古代"
	created_item = /obj/item/rogueweapon/mace/steel/ancient

/datum/anvil_recipe/weapons/decrepit/mace
	name = "钉锤, 衰朽"
	created_item = /obj/item/rogueweapon/mace/steel/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/warhammer
	name = "战锤, 古代"
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/ancient

/datum/anvil_recipe/weapons/decrepit/warhammer
	name = "战锤, 衰朽"
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/tossblade
	name = "飞刀, 古代 (x4)"
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel/ancient
	createditem_num = 4

/datum/anvil_recipe/weapons/decrepit/tossblade
	name = "飞刀, 衰朽 (x4)"
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel/ancient/decrepit
	createditem_num = 4

/datum/anvil_recipe/weapons/ancient/gsw
	name = "巨剑, 古代 (+2 吉尔青铜)"
	created_item = /obj/item/rogueweapon/greatsword/ancient
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/ingot/gilbranze)

/datum/anvil_recipe/weapons/decrepit/gsw
	name = "巨剑, 衰朽 (+2 合金)"
	created_item = /obj/item/rogueweapon/greatsword/ancient/decrepit
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/ingot/decrepit)

/datum/anvil_recipe/weapons/ancient/bardiche
	name = "长柄刀斧，古代 (+1 小原木, +1 吉尔青铜)"
	created_item = /obj/item/rogueweapon/halberd/bardiche/ancient
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/decrepit/bardiche
	name = "长柄刀斧，衰朽 (+1 小原木, +1 合金)"
	created_item = /obj/item/rogueweapon/halberd/bardiche/ancient/decrepit
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/ancient/grandmace
	name = "巨型钉锤, 净化 (+1 吉尔青铜, +1 小原木)"
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel/ancient

/datum/anvil_recipe/weapons/decrepit/grandmace
	name = "巨型钉锤, 衰朽 (+1 合金, +1 小原木)"
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/spear
	name = "长矛, 古代 (+1 小原木)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/ancient

/datum/anvil_recipe/weapons/decrepit/spear
	name = "长矛, 衰朽(+1 小原木)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/javelin
	name = "标枪, 古代 (+1 小原木) (x2)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient
	createditem_num = 2

/datum/anvil_recipe/weapons/decrepit/javelin
	name = "标枪, 衰朽 (+1 小原木) (x2)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel/ancient/decrepit
	createditem_num = 2

// COPPER

/datum/anvil_recipe/weapons/copper/caxe
	name = "手斧, 铜 (+1 铜)"
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe/copper

/datum/anvil_recipe/weapons/copper/cbludgeon
	name = "短棍, 铜 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel/copper

/datum/anvil_recipe/weapons/copper/cdagger
	name = "小刀, 铜 (x2)"
	created_item = /obj/item/rogueweapon/huntingknife/copper
	createditem_num = 2

/datum/anvil_recipe/weapons/copper/cmesser
	name = "大砍刀, 铜"
	created_item = /obj/item/rogueweapon/sword/short/messer/copper

/datum/anvil_recipe/weapons/copper/cspears
	name = "长矛, 铜 (+1 小原木) (x2)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/stone/copper
	createditem_num = 2

/datum/anvil_recipe/weapons/copper/crhomphaia
	name = "罗姆法亚刀, 铜 (+1 铜)"
	additional_items = list(/obj/item/ingot/copper)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia/copper

// BRONZE

/datum/anvil_recipe/weapons/bronze/katar
	name = "卡塔拳刃, 青铜"
	created_item = /obj/item/rogueweapon/katar/bronze

/datum/anvil_recipe/weapons/bronze/bronzeknuckle
	name = "指虎, 青铜"
	created_item = /obj/item/rogueweapon/knuckles/bronzeknuckles

/datum/anvil_recipe/weapons/bronze/gladius
	name = "短剑, 青铜"
	created_item = /obj/item/rogueweapon/sword/short/gladius

/datum/anvil_recipe/weapons/bronze/sword
	name = "剑, 青铜"
	created_item = /obj/item/rogueweapon/sword/bronze

/datum/anvil_recipe/weapons/bronze/axe
	name = "斧, 青铜"
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/bronze

/datum/anvil_recipe/weapons/bronze/mace
	name = "钉锤, 青铜"
	created_item = /obj/item/rogueweapon/mace/bronze

/datum/anvil_recipe/weapons/bronze/dagger
	name = "匕首, 青铜"
	created_item = /obj/item/rogueweapon/huntingknife/bronze

/datum/anvil_recipe/weapons/bronze/whip
	name = "鞭, 青铜-Tipped (+3 熟皮)"
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/natural/hide/cured, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/whip/bronze

/datum/anvil_recipe/weapons/bronze/spear
	name = "长矛, 青铜 (+1 青铜, +1 小原木)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/bronze

/datum/anvil_recipe/weapons/bronze/trident
	name = "三叉戟, 青铜 (+1 钢, +1 铁, +1 小原木)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/trident

// IRON

/datum/anvil_recipe/weapons/iron/sword
	name = "剑, 铁"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/iron

/datum/anvil_recipe/weapons/iron/swordshort
	name = "短剑, 铁"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/short/iron

/datum/anvil_recipe/weapons/iron/messer
	name = "大砍刀, 铁"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/short/messer/iron

/datum/anvil_recipe/weapons/iron/shotel
	name = "Shotel, Iron (+1 Iron)"
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/sword/long/shotel/iron

/datum/anvil_recipe/weapons/iron/sabre
	name = "军刀, 铁"
	req_blade = /obj/item/blade/iron_sword
	created_item = /obj/item/rogueweapon/sword/sabre/iron

/datum/anvil_recipe/weapons/iron/dagger
	name = "匕首, 铁"
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife/idagger
	createditem_num = 1

/datum/anvil_recipe/weapons/iron/flail
	name = "连枷, 铁"
	created_item = /obj/item/rogueweapon/flail

/datum/anvil_recipe/weapons/iron/huntknife
	name = "猎刀, 铁"
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife
	createditem_num = 1

/datum/anvil_recipe/weapons/steel/greatsword
	name = "巨剑, 钢 (+2 钢)"
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/iron

/datum/anvil_recipe/weapons/iron/claymore
	name = "双手阔剑，铁 (+2 铁)"
	req_blade = /obj/item/blade/iron_sword
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/greatsword/zwei

/datum/anvil_recipe/weapons/iron/handaxe
	name = "手斧, 铁 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/handaxe

/datum/anvil_recipe/weapons/iron/axe
	name = "斧, 铁 (+1 木棍)"
	req_blade = /obj/item/blade/iron_axe
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut

/datum/anvil_recipe/weapons/iron/greataxe
	name = "巨斧, 铁 (+1 铁, +1 小原木)"
	req_blade = /obj/item/blade/iron_axe
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe

/datum/anvil_recipe/weapons/iron/cudgel
	name = "棍棒, 铁 (+1 木棍)"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/cudgel

/datum/anvil_recipe/weapons/iron/mace
	name = "钉锤, 铁 (+1 木棍)"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace

/datum/anvil_recipe/weapons/iron/warhammer
	name = "战锤, 铁 (+1 木棍)"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/mace/warhammer

/datum/anvil_recipe/weapons/iron/spear
	name = "长矛, 铁 (+1 小原木)"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear

/datum/anvil_recipe/weapons/iron/bardiche
	name = "长柄刀斧, 铁 (+1 铁, +1 小原木)"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd/bardiche

/datum/anvil_recipe/weapons/iron/lucerne
	name = "卢塞恩锤, 铁 (+1 铁, +1 小原木)"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak/lucerne

/datum/anvil_recipe/weapons/iron/polemace
	name = "古德达格棍, 铁 (+1 小原木)"
	req_blade = /obj/item/blade/iron_mace
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden

/datum/anvil_recipe/weapons/iron/tossblade
	name = "飞刀, 铁 (x4)"
	req_blade = /obj/item/blade/iron_knife
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife
	createditem_num = 4

/datum/anvil_recipe/weapons/iron/javelin
	name = "标枪, 铁 (+1 小原木) (x2)"
	req_blade = /obj/item/blade/iron_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin
	createditem_num = 2

/datum/anvil_recipe/weapons/iron/claws
	name = "手爪, 铁 (+1 铁)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/handclaw

/datum/anvil_recipe/weapons/iron/maul
	name = "重槌 (+1 铁)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/mace/maul
	craftdiff = 4

/datum/anvil_recipe/weapons/iron/peasantwarflail
	name = "War Flail, Iron (+1 Iron, +2 Small Log)"
	additional_items = list(/obj/item/ingot/iron, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/flail/peasantwarflail

/datum/anvil_recipe/weapons/iron/maciejowski
	name = "Maciejowski, Iron (+1 Iron)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/sword/falchion/militia

/// STEEL WEAPONS
/datum/anvil_recipe/weapons/steel/dagger
	name = "匕首, 钢"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel
	createditem_num = 1

/datum/anvil_recipe/weapons/steel/daggerparrying
	name = "格挡匕首, 钢 (+1 钢)"
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying

/datum/anvil_recipe/weapons/steel/katar
	name = "卡塔拳刃, 钢"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/katar

/datum/anvil_recipe/weapons/steel/punchdagger
	name = "拳刺"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/katar/punchdagger

/datum/anvil_recipe/weapons/steel/steelknuckle
	name = "指虎, 钢"
	created_item = /obj/item/rogueweapon/knuckles

/datum/anvil_recipe/weapons/steel/hurlbat
	name = "投掷棍"
	req_blade = /obj/item/blade/steel_axe
	created_item = /obj/item/rogueweapon/stoneaxe/hurlbat

/datum/anvil_recipe/weapons/steel/rapier
	name = "刺剑, 钢"
	created_item = /obj/item/rogueweapon/sword/rapier

/datum/anvil_recipe/weapons/steel/cutlass
	name = "短弯刀, 钢"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/cutlass

/datum/anvil_recipe/weapons/steel/swordshort
	name = "短剑, 钢"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short

/datum/anvil_recipe/weapons/steel/falchion
	name = "弯刀, 钢"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short/falchion

/datum/anvil_recipe/weapons/steel/messer
	name = "大砍刀, 钢"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/short/messer

/datum/anvil_recipe/weapons/steel/sword
	name = "剑, 钢"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword

/datum/anvil_recipe/weapons/steel/saber
	name = "军刀, 钢"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre

/datum/anvil_recipe/weapons/steel/shamshir
	name = "Shamshir, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre/shamshir

/datum/anvil_recipe/weapons/steel/shashka
	name = "Shashka, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre/steppesman

/datum/anvil_recipe/weapons/steel/hook
	name = "Hook Sword, Steel"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/sabre/hook

/datum/anvil_recipe/weapons/steel/flail
	name = "连枷, 钢"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/flail/sflail

/datum/anvil_recipe/weapons/steel/longsword
	name = "长剑, 钢 (+1 钢)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long

/datum/anvil_recipe/weapons/steel/sharpfeder
	name = "Dueling Longsword, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/frei

/datum/anvil_recipe/weapons/steel/elongsword
	name = "Basket-Hilted Longsword, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/etruscan

/datum/anvil_recipe/weapons/steel/shalal
	name = "Shalal Saber, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/marlin

/datum/anvil_recipe/weapons/steel/shotel
	name = "Shotel, Steel (+1 Steel)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/shotel

/datum/anvil_recipe/weapons/steel/trainingsword
	name = "训练剑，钢 (+1 钢)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/training

/datum/anvil_recipe/weapons/steel/trainingsword
	name = "训练剑，钢 (+1 钢)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/training

/datum/anvil_recipe/weapons/steel/kriegmesser
	name = "战争大砍刀, 钢 (+1 钢)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser

/datum/anvil_recipe/weapons/steel/battleaxe
	name = "战斧, 钢 (+1 钢)"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/stoneaxe/battle

/datum/anvil_recipe/weapons/steel/combatknife
	name = "战斗刀, 钢 (+1 钢)"
	req_blade = /obj/item/blade/steel_knife
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/huntingknife/combat

/datum/anvil_recipe/weapons/steel/mace
	name = "钉锤, 钢 (+1 钢)"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/steel

/datum/anvil_recipe/weapons/steel/swarhammer
	name = "战锤, 钢 (+1 钢)"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel

/datum/anvil_recipe/weapons/steel/greatsword
	name = "巨剑, 钢 (+2 钢)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword

/datum/anvil_recipe/weapons/steel/flamb
	name = "焰形剑, 钢 (+2 钢)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge

/datum/anvil_recipe/weapons/steel/estoc
	name = "穿甲刺剑, 钢 (+1 钢)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/estoc

/datum/anvil_recipe/weapons/steel/axe
	name = "斧, 钢 (+1 木棍)"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/steel

/datum/anvil_recipe/weapons/steel/pulaski
	name = "普拉斯基斧 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/pick

/datum/anvil_recipe/weapons/steel/greataxe
	name = "巨斧, 钢 (+1 钢, +1 小原木)"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel

/datum/anvil_recipe/weapons/steel/greataxe/doublehead
	name = "双头巨斧, 钢 (+2 钢, +1 小原木)"
	req_blade = /obj/item/blade/steel_axe
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/steel/doublehead

/datum/anvil_recipe/weapons/steel/billhook
	name = "钩镰, 钢 (+1 小原木)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/billhook

/datum/anvil_recipe/weapons/steel/halberd
	name = "戟, 钢 (+1 钢, +1 小原木)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/halberd

/datum/anvil_recipe/weapons/steel/eaglebeak
	name = "Eagle's Beak (+1 钢, +1 小原木)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/eaglebeak

/datum/anvil_recipe/weapons/steel/grandmace
	name = "巨型钉锤, 钢 (+1 钢, +1 小原木)"
	req_blade = /obj/item/blade/steel_mace
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/goden/steel

/datum/anvil_recipe/weapons/steel/partizan
	name = "长戟, 钢 (+1 钢, +1 小原木)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/partizan

/datum/anvil_recipe/weapons/steel/naginata
	name = "薙刀, 钢 (+1 大原木)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/) //looong spear
	created_item = /obj/item/rogueweapon/spear/naginata

/datum/anvil_recipe/weapons/steel/boarspear
	name = "野猪矛, 钢 (+1 钢, +1 小原木)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/boar

/datum/anvil_recipe/weapons/steel/lance
	name = "骑枪, 钢 (+1 钢, +1 小原木)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/lance

/datum/anvil_recipe/weapons/steel/tossblade
	name = "飞刀, 钢 (x4)"
	req_blade = /obj/item/blade/steel_knife
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/steel
	createditem_num = 4

/datum/anvil_recipe/weapons/steel/javelin
	name = "标枪, 钢 (+1 小原木) (x2)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/steel
	createditem_num = 2

/datum/anvil_recipe/weapons/steel/fishspear
	name = "捕鱼矛, 钢 (+1 钢, +1 小原木)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/fishspear

/datum/anvil_recipe/weapons/steel/rhomphaia
	name = "罗姆法亚刀, 钢 (+1 钢)"
	req_blade = /obj/item/blade/steel_sword
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/sword/long/rhomphaia

/datum/anvil_recipe/weapons/steel/falx
	name = "镰刃刀, 钢"
	req_blade = /obj/item/blade/steel_sword
	created_item = /obj/item/rogueweapon/sword/falx

/datum/anvil_recipe/weapons/steel/claws
	name = "手爪, 钢 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/handclaw/steel

/datum/anvil_recipe/weapons/steel/maul
	name = "巨槌 (+2 钢)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/mace/maul/grand
	craftdiff = 5

/// UPGRADED WEAPONS

// GOLD

/datum/anvil_recipe/weapons/decorated/sword
	name = "剑, 装饰 (+1 钢 剑)"
	additional_items = list(/obj/item/rogueweapon/sword)
	created_item = /obj/item/rogueweapon/sword/decorated

/datum/anvil_recipe/weapons/decorated/saber
	name = "军刀, 装饰 (+1 钢 军刀)"
	additional_items = list(/obj/item/rogueweapon/sword/sabre)
	created_item = /obj/item/rogueweapon/sword/sabre/dec

/datum/anvil_recipe/weapons/decorated/rapier
	name = "刺剑, 装饰 (+1 钢 刺剑)"
	additional_items = list(/obj/item/rogueweapon/sword/rapier)
	created_item = /obj/item/rogueweapon/sword/rapier/dec

/datum/anvil_recipe/weapons/decorated/longsword
	name = "长剑, 装饰 (+1 钢 长剑)"
	additional_items = list(/obj/item/rogueweapon/sword/long)
	created_item = /obj/item/rogueweapon/sword/long/dec


// SILVER

/datum/anvil_recipe/weapons/silver/elfsaber
	name = "军刀, 精灵 (+1 黄金)"
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/rogueweapon/sword/sabre/elf

/datum/anvil_recipe/weapons/silver/elfdagger
	name = "匕首, 精灵 (+1 白银)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish

/datum/anvil_recipe/weapons/silver/dagger
	name = "匕首, 白银"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver

/datum/anvil_recipe/weapons/silver/shortsword
	name = "短剑, 白银"
	created_item = /obj/item/rogueweapon/sword/short/silver

/datum/anvil_recipe/weapons/silver/sword
	name = "刺剑, 白银 (+1 白银)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/silver

/datum/anvil_recipe/weapons/silver/sword
	name = "刺剑, 白银 (+1 白银)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/sword/rapier/silver

/datum/anvil_recipe/weapons/silver/longsword
	name = "长剑, 白银 (+2 白银, +1 小原木)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/silver

/datum/anvil_recipe/weapons/silver/broadsword
	name = "阔剑, 白银 (+2 白银, +1 小原木)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser/silver

/datum/anvil_recipe/weapons/silver/waraxe
	name = "战斧，白银 (+2 白银, +1 小原木)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/stoneaxe/woodcut/silver

/datum/anvil_recipe/weapons/silver/poleaxe
	name = "长柄战斧, 白银 (+2 白银, +2 小原木s)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/silver

/datum/anvil_recipe/weapons/silver/mace
	name = "钉锤, 白银 (+1 白银)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/mace/steel/silver

/datum/anvil_recipe/weapons/silver/warhammer
	name = "战锤, 白银 (+1 白银, +1 小原木)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/mace/warhammer/steel/silver

/datum/anvil_recipe/weapons/silver/quarterstaff
	name = "四分法杖，白银 (+1 白银, +3 小原木)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/woodstaff/quarterstaff/silver

/datum/anvil_recipe/weapons/silver/spear
	name = "长矛, 白银 (+1 白银, +3 小原木s)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/silver

/datum/anvil_recipe/weapons/silver/morningstar
	name = "晨星锤, 白银 (+1 白银, +1 锁链)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/rope/chain)
	created_item = /obj/item/rogueweapon/flail/sflail/silver

/datum/anvil_recipe/weapons/silver/whip
	name = "鞭，白银 (+1 皮鞭)"
	additional_items = list(/obj/item/rogueweapon/whip)
	created_item = /obj/item/rogueweapon/whip/silver

/datum/anvil_recipe/weapons/silver/tossblade
	name = "飞刀, 白银 (+1 白银)"
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/rogueweapon/huntingknife/throwingknife/silver
	createditem_num = 4

/datum/anvil_recipe/weapons/silver/javelin
	name = "标枪，白银 (+1 白银, +1 小原木)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/ammo_casing/caseless/rogue/javelin/silver
	createditem_num = 2


/datum/anvil_recipe/weapons/bronze/gladius
	name = "短剑, 青铜"
	created_item = /obj/item/rogueweapon/sword/short/gladius
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/spear
	name = "长矛, 青铜 (+1 青铜, +1 小原木)"
	additional_items = list(/obj/item/ingot/bronze, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/bronze
	craftdiff = 2

/datum/anvil_recipe/weapons/bronze/trident
	name = "三叉戟, 青铜 (+1 钢, +1 铁, +1 小原木)"
	req_blade = /obj/item/blade/steel_polearm
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/iron, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/spear/trident
	craftdiff = 4

/datum/anvil_recipe/weapons/bronze/bronzeknuckle
	name = "指虎, 青铜"
	created_item = /obj/item/rogueweapon/knuckles/bronzeknuckles
	craftdiff = 2

/// SHIELDS

/datum/anvil_recipe/weapons/iron/towershield
	name = "塔盾 (+1 小原木)"
	additional_items = list(/obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/shield/tower

/datum/anvil_recipe/weapons/steel/kiteshield
	name = "鸢盾 (+1 钢, +1 熟皮)"
	additional_items = list(/obj/item/ingot/steel, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal

/datum/anvil_recipe/weapons/ancient/shield
	name = "鸢盾, 古代 (+1 吉尔青铜, +1 熟皮)"
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/ancient

/datum/anvil_recipe/weapons/decrepit/shield
	name = "鸢盾, 衰朽 (+1 合金, +1 熟皮)"
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/tower/metal/ancient/decrepit

/datum/anvil_recipe/weapons/ancient/shield
	name = "鸢盾, 古代 (+1 吉尔青铜, +1 熟皮)"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/rogueweapon/shield/gilbranze

/datum/anvil_recipe/weapons/decrepit/shield
	name = "鸢盾, 衰朽 (+1 合金, +1 熟皮)"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/rogueweapon/shield/gilbranze/decrepit

/datum/anvil_recipe/weapons/ancient/shield
	name = "鸢盾, 古代 (+1 吉尔青铜, +1 熟皮)"
	additional_items = list(/obj/item/ingot/gilbranze, /obj/item/ingot/gilbranze, /obj/item/ingot/gilbranze, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/gilbranze/great

/datum/anvil_recipe/weapons/decrepit/shield
	name = "鸢盾, 衰朽 (+1 合金, +1 熟皮)"
	additional_items = list(/obj/item/ingot/decrepit, /obj/item/ingot/decrepit, /obj/item/ingot/decrepit, /obj/item/natural/hide/cured)
	created_item = /obj/item/rogueweapon/shield/gilbranze/great/decrepit

/datum/anvil_recipe/weapons/steel/buckler
	name = "圆盾 (+1 钢)"
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/rogueweapon/shield/buckler

/datum/anvil_recipe/weapons/ancient/buckler
	name = "圆盾, 古代 (+1 吉尔青铜)"
	additional_items = list(/obj/item/ingot/gilbranze)
	created_item = /obj/item/rogueweapon/shield/buckler/ancient

/datum/anvil_recipe/weapons/decrepit/buckler
	name = "圆盾, 衰朽 (+1 吉尔青铜)"
	additional_items = list(/obj/item/ingot/decrepit)
	created_item = /obj/item/rogueweapon/shield/buckler/ancient/decrepit

/datum/anvil_recipe/weapons/iron/roundshield
	name = "盾, 铁 (+1 铁)"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/shield/iron

// CROSSBOW

/datum/anvil_recipe/weapons/steel/xbow
	name = "弩 (+1 小原木, +1 纤维)"
	additional_items = list(/obj/item/grown/log/tree/small, /obj/item/natural/fibers)
	created_item = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow

/datum/anvil_recipe/weapons/iron/bolts
	name = "弩箭 (+2 木棍) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt
	createditem_num = 10
	i_type = "弹药"

/datum/anvil_recipe/weapons/ancient/bolts
	name = "弩箭, 古代 (+2 木棍) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/ancient
	createditem_num = 10
	i_type = "弹药"

/datum/anvil_recipe/weapons/decrepit/bolts
	name = "弩箭, 衰朽 (+2 木棍) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/decrepit
	createditem_num = 10
	i_type = "弹药"

/datum/anvil_recipe/weapons/iron/bluntbolts
	name = "弩箭, 训练 (+2 木棍) (x20)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/blunt
	createditem_num = 10
	i_type = "弹药"
	craftdiff = 1

/datum/anvil_recipe/weapons/iron/heavybluntbolts
	name = "弩箭, 重钝头 (+2 木棍) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/bolt/heavyblunt
	createditem_num = 10
	i_type = "弹药"

// BOW

/datum/anvil_recipe/weapons/iron/arrows
	name = "阔刃箭, 铁 (+2 木棍) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron
	createditem_num = 10
	i_type = "弹药"

/datum/anvil_recipe/weapons/steel/arrows
	name = "穿甲箭, 钢 (+2 木棍) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel
	createditem_num = 10
	i_type = "弹药"

/datum/anvil_recipe/weapons/ancient/arrows
	name = "穿甲箭, 古代 (+2 木棍) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/steel/ancient
	createditem_num = 10
	i_type = "弹药"

/datum/anvil_recipe/weapons/decrepit/arrows
	name = "阔刃箭, 衰朽 (+2 木棍) (x10)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/ammo_casing/caseless/rogue/arrow/iron/decrepit
	createditem_num = 10
	i_type = "弹药"

// SLING

/datum/anvil_recipe/weapons/iron/slingbullets
	name = "投石弹, 铁 (x10)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron
	createditem_num = 10
	i_type = "弹药"

/datum/anvil_recipe/weapons/bronze/slingbullets
	name = "投石弹, 青铜 (x10)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze
	createditem_num = 10
	i_type = "弹药"

/datum/anvil_recipe/weapons/ancient/slingbullets
	name = "投石弹, 古代 (x10)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/ancient
	createditem_num = 10
	i_type = "弹药"

/datum/anvil_recipe/weapons/decrepit/slingbullets
	name = "投石弹, 衰朽 (x10)"
	created_item = /obj/item/ammo_casing/caseless/rogue/sling_bullet/decrepit
	createditem_num = 10
	i_type = "弹药"

// UNIQUE

/datum/anvil_recipe/weapons/iron/execution
	name = "刽子手 剑 (+2 铁)"
	additional_items = list(/obj/item/ingot/iron, /obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/sword/long/exe
	craftdiff = 4


// BLACKSTEEL

/datum/anvil_recipe/weapons/blacksteel/arming
	name = "黑钢 Arming 剑"
	created_item = /obj/item/rogueweapon/sword/blacksteel

/datum/anvil_recipe/weapons/blacksteel/flamberge
	name = "黑钢 焰形剑 (+1 黑钢, +1 Ruby)"
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/ruby)
	created_item = /obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel


/datum/anvil_recipe/weapons/blacksteel/decsword
	name = "黑钢 剑, 装饰 (+1 钢 剑)"
	additional_items = list(/obj/item/rogueweapon/sword)
	created_item = /obj/item/rogueweapon/sword/decorated/blacksteel

//Church Weapons forged from Holy Steel

// HOLY STEEL

/datum/anvil_recipe/weapons/holysteel/church_longsword
	name = "长剑, 圣堂式"
	created_item = /obj/item/rogueweapon/sword/long/church

/datum/anvil_recipe/weapons/holysteel/church_spear
	name = "长矛, 圣堂式 (+1 Holy 钢)"
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/spear/holysee

/datum/anvil_recipe/weapons/holysteel/decasword
	name = "长剑, 十重祝圣 (+1 Holy 钢)"
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/sword/long/undivided

/datum/anvil_recipe/weapons/holysteel/decashield
	name = "盾, 十重祝圣 (+1 Holy 钢)"
	additional_items = list(/obj/item/ingot/steelholy)
	created_item = /obj/item/rogueweapon/shield/tower/holysee

// BLESSED SILVER

/datum/anvil_recipe/weapons/psy/axe
	name = "普赛顿式 战斧 (+1 祝福白银, +1 木棍)"
	created_item = /obj/item/rogueweapon/stoneaxe/battle/psyaxe
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/stick)

/datum/anvil_recipe/weapons/psy/poleaxe
	name = "普赛顿式 长柄战斧 (+2 祝福 白银, +1 小原木)"
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/greataxe/psy

/datum/anvil_recipe/weapons/psy/mace
	name = "普赛顿式 巨型钉锤 (+1 祝福 白银, +1 小原木)"
	created_item = /obj/item/rogueweapon/mace/goden/psy
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/psy/spear
	name = "普赛顿式 长矛 (+1 祝福 白银, +1 小原木)"
	created_item = /obj/item/rogueweapon/spear/psyspear
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/psy/dagger
	name = "普赛顿式 匕首"
	created_item = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger

/datum/anvil_recipe/weapons/psy/shortsword
	name = "普赛顿式 短剑"
	created_item = /obj/item/rogueweapon/sword/short/psy

/datum/anvil_recipe/weapons/psy/katar
	name = "普赛顿式 卡塔拳刃"
	created_item = /obj/item/rogueweapon/katar/psydon

/datum/anvil_recipe/weapons/psy/knuckles
	name = "普赛顿式 指节套"
	created_item = /obj/item/rogueweapon/knuckles/psydon

/datum/anvil_recipe/weapons/psy/cudgel
	name = "普赛顿式 手锤"
	created_item = /obj/item/rogueweapon/mace/cudgel/psy

/datum/anvil_recipe/weapons/psy/halberd
	name = "普赛顿式 戟 (+2 祝福 白银, +1 小原木)"
	created_item = /obj/item/rogueweapon/halberd/psyhalberd
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed, /obj/item/grown/log/tree/small)

/datum/anvil_recipe/weapons/psy/gsword
	name = "普赛顿式 巨剑 (+2 祝福 白银)"
	created_item = /obj/item/rogueweapon/greatsword/psygsword
	additional_items = list(/obj/item/ingot/silverblessed, /obj/item/ingot/silverblessed)

/datum/anvil_recipe/weapons/psy/sword
	name = "普赛顿式 长剑 (+1 祝福 白银)"
	created_item = /obj/item/rogueweapon/sword/long/psysword
	additional_items = list(/obj/item/ingot/silverblessed)

/datum/anvil_recipe/weapons/psy/whip
	name = "普赛顿式 鞭 (+3 熟皮)"
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
