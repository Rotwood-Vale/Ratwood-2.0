/datum/anvil_recipe/tools
	abstract_type = /datum/anvil_recipe/tools
	i_type = "杂项"

// Material parent classes - one skill level lower than weapons
/datum/anvil_recipe/tools/decrepit
	abstract_type = /datum/anvil_recipe/tools/decrepit
	req_bar = /obj/item/ingot/decrepit
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/tools/copper
	abstract_type = /datum/anvil_recipe/tools/copper
	req_bar = /obj/item/ingot/copper
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/tools/iron
	abstract_type = /datum/anvil_recipe/tools/iron
	req_bar = /obj/item/ingot/iron
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/tools/steel
	abstract_type = /datum/anvil_recipe/tools/steel
	req_bar = /obj/item/ingot/steel
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/anvil_recipe/tools/gold
	abstract_type = /datum/anvil_recipe/tools/gold
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/tools/silver
	abstract_type = /datum/anvil_recipe/tools/silver
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/tools/tin
	abstract_type = /datum/anvil_recipe/tools/tin
	req_bar = /obj/item/ingot/tin
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/tools/blacksteel
	abstract_type = /datum/anvil_recipe/tools/blacksteel
	req_bar = /obj/item/ingot/blacksteel
	craftdiff = SKILL_LEVEL_MASTER

// --------- Copper -----------
/datum/anvil_recipe/tools/copper/sickle
	name = "镰刀, 铜 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sickle/copper
	i_type = "工具"

/datum/anvil_recipe/tools/copper/pick
	name = "镐, 铜 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/copper
	i_type = "工具"

/datum/anvil_recipe/tools/copper/pitchfork
	name = "干草叉, 铜 (+2 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork/copper
	i_type = "工具"

/datum/anvil_recipe/tools/copper/lamptern
	name = "提灯, 铜"
	created_item = /obj/item/flashlight/flare/torch/lantern/copper

/datum/anvil_recipe/tools/copper/hammer
	name = "锤, 铜 (+木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/copper
	i_type = "工具"


// --------- ANCIENT ALLOY -----------

/datum/anvil_recipe/tools/decrepit/thresher
	name = "脱粒连枷, 衰朽 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/thresher/decrepit
	i_type = "工具"

/datum/anvil_recipe/tools/decrepit/hoe
	name = "锄头, 衰朽 (+2 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hoe/decrepit
	i_type = "工具"

/datum/anvil_recipe/tools/decrepit/pitchfork
	name = "干草叉, 衰朽 (+2 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork/decrepit
	i_type = "工具"

/datum/anvil_recipe/tools/decrepit/hammer
	name = "锤, 衰朽 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/ancient/decrepit
	i_type = "工具"

/datum/anvil_recipe/tools/decrepit/sickle
	name = "镰刀, 衰朽 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sickle/decrepit
	i_type = "工具"

/datum/anvil_recipe/tools/decrepit/tongs
	name = "钳子, 衰朽"
	created_item = /obj/item/rogueweapon/tongs/ancient/decrepit
	i_type = "工具"

/datum/anvil_recipe/tools/decrepit/pick
	name = "镐, 衰朽 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/decrepit
	i_type = "工具"

/datum/anvil_recipe/tools/decrepit/shovel
	name = "铲, 衰朽 (+2 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/shovel/decrepit
	i_type = "工具"

/datum/anvil_recipe/tools/decrepit/sewingneedle
	name = "针, 衰朽 (x3)"
	created_item = /obj/item/needle/decrepit
	createditem_num = 3

/datum/anvil_recipe/tools/decrepit/pan
	name = "煎锅, 衰朽"
	created_item = /obj/item/cooking/pan/decrepit

/datum/anvil_recipe/tools/decrepit/agobs
	name = "高脚杯 x2"
	created_item = /obj/item/reagent_containers/glass/cup/decrepitgob
	createditem_num = 2

/datum/anvil_recipe/tools/decrepit/amugs
	name = "马克杯, 衰朽 (x3)"
	created_item = /obj/item/reagent_containers/glass/cup/decrepitmug
	createditem_num = 3

/datum/anvil_recipe/tools/decrepit/pot
	name = "炊锅, 衰朽"
	created_item = /obj/item/reagent_containers/glass/bucket/pot/decrepit

/datum/anvil_recipe/tools/decrepit/platter
	name = "大盘, 衰朽 (x3)"
	created_item = /obj/item/cooking/platter/decrepit
	createditem_num = 3

/datum/anvil_recipe/tools/decrepit/bowl
	name = "碗, 衰朽 (x2)"
	created_item = /obj/item/reagent_containers/glass/bowl/decrepit

/datum/anvil_recipe/tools/decrepit/fork
	name = "叉，衰朽 (x3)"
	created_item = /obj/item/kitchen/fork/decrepit
	createditem_num = 3

/datum/anvil_recipe/tools/decrepit/spoon
	name = "勺, 衰朽 (x3)"
	created_item = /obj/item/kitchen/spoon/decrepit
	createditem_num = 3


// --------- IRON -----------

/datum/anvil_recipe/tools/iron/blowrod
	name = "吹制杆"
	created_item = /obj/item/rogueweapon/blowrod

/datum/anvil_recipe/tools/iron/surgerytools
	name = "外科包 (+1 铁, +1 熟皮)"
	additional_items = list(/obj/item/ingot/iron, /obj/item/natural/hide/cured)
	created_item = /obj/item/storage/belt/rogue/surgery_bag/full

/datum/anvil_recipe/tools/iron/torch
	name = "领地火把 (x5) (+1 煤炭)"
	additional_items = list(/obj/item/rogueore/coal)
	created_item = /obj/item/flashlight/flare/torch/metal
	createditem_num = 5
	
/datum/anvil_recipe/tools/iron/pan
	name = "煎锅, 铁"
	created_item = /obj/item/cooking/pan

/datum/anvil_recipe/tools/iron/tallowpot
	name = "兽脂锅, 铁 (x2) (+1 铁)"
	created_item = /obj/item/inqarticles/tallowpot
	createditem_num = 2

/datum/anvil_recipe/tools/iron/keyring
	name = "钥匙环 (x3)"
	created_item = /obj/item/storage/keyring
	createditem_num = 3

/datum/anvil_recipe/tools/iron/sewingneedle
	name = "针, 铁 (x3)"
	created_item = /obj/item/needle
	createditem_num = 3 // They can be refilled with fiber now

/* Movning under Engineering
/datum/anvil_recipe/tools/iron/lockpicks
	name = "开锁器 x3"
	created_item = /obj/item/lockpick
	createditem_num = 3

/datum/anvil_recipe/tools/iron/lockpickring
	name = "开锁环 x3"
	created_item = /obj/item/lockpickring
	createditem_num = 3
*/

/datum/anvil_recipe/tools/iron/branding
	name = "烙铁"
	additional_items = list(/obj/item/ingot/iron)
	created_item = /obj/item/rogueweapon/surgery/cautery/branding

/datum/anvil_recipe/tools/iron/shovel
	name = "铲, 铁 (+2 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/shovel
	i_type = "工具"

/datum/anvil_recipe/tools/iron/hammer
	name = "锤, 铁 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/iron
	i_type = "工具"

/datum/anvil_recipe/tools/iron/handsaw
	name = "手锯, 铁 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/handsaw

/datum/anvil_recipe/tools/iron/chisel
	name = "凿子, 铁"
	created_item = /obj/item/rogueweapon/chisel

/datum/anvil_recipe/tools/iron/tongs
	name = "钳子, 铁"
	created_item = /obj/item/rogueweapon/tongs
	i_type = "工具"

/datum/anvil_recipe/tools/iron/sickle
	name = "镰刀, 铁 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/sickle
	i_type = "工具"

/datum/anvil_recipe/tools/iron/pick
	name = "镐, 铁 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick
	i_type = "工具"

/datum/anvil_recipe/tools/iron/hoe
	name = "锄头, 铁 (+2 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hoe
	i_type = "工具"

/datum/anvil_recipe/tools/iron/pitchfork
	name = "干草叉, 铁 (+2 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick, /obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pitchfork
	i_type = "工具"

/datum/anvil_recipe/tools/iron/lamptern
	name = "提灯, 铁 (x3)"
	created_item = /obj/item/flashlight/flare/torch/lantern
	createditem_num = 3

/datum/anvil_recipe/tools/iron/cups
	name = "杯, 铁 (x3)"
	created_item = /obj/item/reagent_containers/glass/cup
	createditem_num = 3

/datum/anvil_recipe/tools/iron/thresher
	name = "脱粒连枷, 铁 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/thresher
	i_type = "工具"

/datum/anvil_recipe/tools/iron/headhook
	name = "头钩, 铁 (+2 纤维)"
	additional_items = list(/obj/item/natural/fibers, /obj/item/natural/fibers)
	created_item = /obj/item/storage/hip/headhook
	i_type = "工具"

/datum/anvil_recipe/tools/iron/scissors
	name = "剪刀"
	created_item = /obj/item/rogueweapon/huntingknife/scissors
	i_type = "工具"

// --------- Steel -----------

/datum/anvil_recipe/tools/steel/hammer
	name = "羊角锤 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/steel

/datum/anvil_recipe/tools/steel/pick
	name = "镐, 钢 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/steel
	i_type = "工具"

/datum/anvil_recipe/tools/steel/cups
	name = "高脚杯 x2"
	created_item = /obj/item/reagent_containers/glass/cup/steel
	createditem_num = 2

/datum/anvil_recipe/tools/steel/chefknife
	name = "厨刀"
	created_item = /obj/item/rogueweapon/huntingknife/chefknife

/datum/anvil_recipe/tools/steel/cleaver
	name = "切肉刀"
	created_item = /obj/item/rogueweapon/huntingknife/cleaver

/datum/anvil_recipe/tools/steel/scissors
	name = "剪刀"
	created_item = /obj/item/rogueweapon/huntingknife/scissors/steel
	i_type = "工具"

// --------- SILVER -----------

/datum/anvil_recipe/tools/silver/cups
	name = "高脚杯 x2"
	created_item = /obj/item/reagent_containers/glass/cup/silver
	createditem_num = 2

/datum/anvil_recipe/tools/silver/cups/small
	name = "杯 x3"
	created_item = /obj/item/reagent_containers/glass/cup/silver/small
	createditem_num = 3

/datum/anvil_recipe/tools/silver/shovel
	name = "铲, 白银 (+1 白银, +1 小原木)"
	additional_items = list(/obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/shovel/silver

// --------- GOLD RECIPES-----------

/datum/anvil_recipe/tools/gold/cups
	name = "高脚杯 x2"
	created_item = /obj/item/reagent_containers/glass/cup/golden
	createditem_num = 2

/datum/anvil_recipe/tools/gold/cups/small
	name = "杯 x3"
	created_item = /obj/item/reagent_containers/glass/cup/golden/small
	createditem_num = 3

// --------- TIN -----------

/datum/anvil_recipe/tools/tin/cups
	name = "高脚杯 x2"
	created_item = /obj/item/reagent_containers/glass/cup/tin
	createditem_num = 2

/datum/anvil_recipe/tools/tin/cups/small
	name = "杯 x3"
	created_item = /obj/item/reagent_containers/glass/cup/tin/small
	createditem_num = 3


// --------- COOKING RECIPES -----------
/datum/anvil_recipe/tools/iron/pot
	name = "炊锅, 铁"
	created_item = /obj/item/reagent_containers/glass/bucket/pot

/datum/anvil_recipe/tools/iron/kettle
	name = "炊壶, 铁"
	created_item = /obj/item/reagent_containers/glass/bucket/pot/kettle

/datum/anvil_recipe/tools/copper/pot
	name = "炊锅, 铜"
	created_item = /obj/item/reagent_containers/glass/bucket/pot/copper

/datum/anvil_recipe/tools/copper/platter
	name = "大盘, 铜 (x2)"
	created_item = /obj/item/cooking/platter/copper
	createditem_num = 2

/datum/anvil_recipe/tools/tin/platter
	name = "大盘, 锡 (x2)"
	created_item = /obj/item/cooking/platter/pewter
	createditem_num = 2

/datum/anvil_recipe/tools/gold/platter
	name = "大盘, 黄金 (x2)"
	created_item = /obj/item/cooking/platter/gold
	createditem_num = 2

/datum/anvil_recipe/tools/silver/platter
	name = "大盘, 白银 (x2)"
	created_item = /obj/item/cooking/platter/silver
	createditem_num = 2

/datum/anvil_recipe/tools/iron/spoon
	name = "勺, 铁 (x3)"
	created_item = /obj/item/kitchen/spoon/iron
	createditem_num = 3

/datum/anvil_recipe/tools/tin/spoon
	name = "勺, 锡 (x3)"
	created_item = /obj/item/kitchen/spoon/tin
	createditem_num = 3

/datum/anvil_recipe/tools/iron/fork
	name = "叉, 铁 (x3)"
	created_item = /obj/item/kitchen/fork/iron
	createditem_num = 3

/datum/anvil_recipe/tools/tin/fork
	name = "叉, 锡 (x3)"
	created_item = /obj/item/kitchen/fork/tin
	createditem_num = 3

/datum/anvil_recipe/tools/silver/fork
	name = "叉, 白银 (x3)"
	created_item = /obj/item/kitchen/fork/silver
	createditem_num = 3

/datum/anvil_recipe/tools/gold/fork
	name = "叉，黄金 (x3)"
	created_item = /obj/item/kitchen/fork/gold
	createditem_num = 3

/datum/anvil_recipe/tools/decrepit/fork
	name = "叉，衰朽 (x3)"
	created_item = /obj/item/kitchen/fork/decrepit
	createditem_num = 3

/datum/anvil_recipe/tools/iron/bowl
	name = "碗，铁 (x2)"
	created_item = /obj/item/reagent_containers/glass/bowl/iron
	createditem_num = 2
	craftdiff = 1

// --------- CASTING TOOLS -----------

/datum/anvil_recipe/tools/crucible
	name = "坩埚"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/ingot/steel)
	created_item = /obj/item/reagent_containers/glass/crucible
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "铸造"

/datum/anvil_recipe/tools/sprue_funnel
	name = "浇口与漏斗"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/sprue_funnel
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "铸造"

/datum/anvil_recipe/tools/mold_axe
	name = "斧刃模具"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/axe
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "铸造"

/datum/anvil_recipe/tools/mold_sword
	name = "剑刃模具"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/sword
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "铸造"

/datum/anvil_recipe/tools/mold_knife
	name = "刀刃模具"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/knife
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "铸造"

/datum/anvil_recipe/tools/mold_mace
	name = "钉锤头模具"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/mace
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "铸造"

/datum/anvil_recipe/tools/mold_polearm
	name = "长柄刃模具"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/polearm
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "铸造"

/datum/anvil_recipe/tools/mold_plate
	name = "甲片模具"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/mold/plate
	craftdiff = SKILL_LEVEL_MASTER
	i_type = "铸造"

//black steel tools

/datum/anvil_recipe/tools/blacksteel/hammer
	name = "黑钢锤 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/hammer/blacksteel

/datum/anvil_recipe/tools/blacksteel/pick
	name = "黑钢 镐 (+1 木棍)"
	additional_items = list(/obj/item/grown/log/tree/stick)
	created_item = /obj/item/rogueweapon/pick/blacksteel

/datum/anvil_recipe/tools/blacksteel/tongs
	name = "黑钢 钳子"
	created_item = /obj/item/rogueweapon/tongs/blacksteel
	
// --------- HEARTBEAST TOOLS -----------
/datum/anvil_recipe/tools/heartbeast_vials
	name = "血瓶"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/heart_blood_vial
	craftdiff = SKILL_LEVEL_APPRENTICE
	createditem_num = 5

/datum/anvil_recipe/tools/heartbeast_canisters
	name = "血罐"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/heart_blood_canister
	craftdiff = SKILL_LEVEL_APPRENTICE
	createditem_num = 2

/datum/anvil_recipe/tools/aspect_canisters
	name = "Aspect 罐"
	req_bar = /obj/item/ingot/copper
	created_item = /obj/item/heart_canister
	craftdiff = SKILL_LEVEL_APPRENTICE
	createditem_num = 3
