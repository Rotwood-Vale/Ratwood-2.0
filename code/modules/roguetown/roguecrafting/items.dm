// Generic category for everything that is related to "general survival".
// Includes some skill diff 0 or 1 recipes that make sense like drying rack.
// This is just basically everything under the generic "crafting" skills
// With a few exceptions atm to be cleared out later.
// Quarterstaff, carpentry etc. you know.
// Previously known as items.dm
/datum/crafting_recipe/roguetown/
	always_availible = TRUE

/datum/crafting_recipe/roguetown/survival
	abstract_type = /datum/crafting_recipe/roguetown/survival/
	skillcraft = /datum/skill/craft/crafting

/datum/crafting_recipe/roguetown/survival/tneedle
	name = "缝衣针"
	result = /obj/item/needle/thorn
	reqs = list(
		/obj/item/natural/thorn = 1,
		/obj/item/natural/fibers = 1,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/cloth
	name = "布料"
	result = /obj/item/natural/cloth
	reqs = list(/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	verbage_simple = "缝制"
	verbage = "缝制"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/clothbelt
	name = "布腰带"
	result = /obj/item/storage/belt/rogue/leather/cloth
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0
	verbage_simple = "系绑"
	verbage = "系绑"

/datum/crafting_recipe/roguetown/survival/unclothbelt
	name = "解开布腰带"
	result = /obj/item/natural/cloth
	reqs = list(/obj/item/storage/belt/rogue/leather/cloth = 1)
	craftdiff = 0
	verbage_simple = "解开"
	verbage = "解开"

/datum/crafting_recipe/roguetown/survival/clothsash
	name = "精致绶带"
	result = /obj/item/storage/belt/rogue/leather/sash
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/ropebelt
	name = "绳腰带"
	result = /obj/item/storage/belt/rogue/leather/rope
	reqs = list(/obj/item/rope = 1)
	craftdiff = 0
	verbage_simple = "系绑"
	verbage = "系绑"

/datum/crafting_recipe/roguetown/survival/unropebelt
	name = "解开绳腰带"
	result = /obj/item/rope
	reqs = list(/obj/item/storage/belt/rogue/leather/rope = 1)
	craftdiff = 0
	verbage_simple = "解开"
	verbage = "解开"

/datum/crafting_recipe/roguetown/survival/rope
	name = "绳子"
	result = /obj/item/rope
	reqs = list(/obj/item/natural/fibers = 3)
	verbage_simple = "编织"
	verbage = "编织"

/datum/crafting_recipe/roguetown/survival/rope_leash
	name = "绳制牵引绳"
	result = /obj/item/leash
	reqs = list(/obj/item/rope = 1)
	tools = list(/obj/item/needle)
	verbage_simple = "缝制"
	verbage = "缝制"
	category = "通用"
	always_availible = TRUE

/datum/crafting_recipe/roguetown/survival/chain_leash
	name = "锁链牵引绳"
	result = /obj/item/leash/chain
	reqs = list(/obj/item/rope/chain = 1)
	verbage_simple = "制作"
	verbage = "制作"
	category = "通用"
	always_availible = TRUE

/datum/crafting_recipe/roguetown/survival/torch
	name = "火把"
	result = /obj/item/flashlight/flare/torch
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/fibers = 1,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/breakdowntorch
	name = "拆解火把"
	result = list(
		/obj/item/natural/fibers = 1,
		/obj/item/grown/log/tree/stick = 1,
		)
	reqs = list(
		/obj/item/flashlight/flare/torch = 1
		)
	skillcraft = null
	verbage_simple = "拆解"
	verbage = "拆解"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/mortar
	name = "炼金研钵"
	result = /obj/item/reagent_containers/glass/mortar
	reqs = list(/obj/item/natural/stone = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/pestle
	name = "石杵"
	result = /obj/item/pestle
	reqs = list(/obj/item/natural/stone = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/bag
	name = "麻袋"
	result = /obj/item/storage/roguebag
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/natural/cloth = 1,
		)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing

/datum/crafting_recipe/roguetown/survival/bait
	name = "鱼饵"
	result = /obj/item/bait
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/wheat = 2,
		)
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/survival/sbaita
	name = "甜饵（苹果）"
	result = /obj/item/bait/sweet
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/apple = 2,
		)
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/survival/sbait
	name = "甜饵（浆果）"
	result = /obj/item/bait/sweet
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2,
		)
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/survival/bloodbait
	name = "血饵"
	result = /obj/item/bait/bloody
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat = 2,
		)
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/survival/pipe
	name = "木烟斗"
	result = /obj/item/clothing/mask/cigarette/pipe/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)

/obj/item/clothing/mask/cigarette/pipe/crafted
	sellprice = 6

/datum/crafting_recipe/roguetown/survival/broom
	name = "扫帚"
	result = /obj/item/broom
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/grown/log/tree/stick = 4,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/book_crafting_kit
	name = "制书工具包"
	result = /obj/item/book_crafting_kit
	reqs = list(
		/obj/item/natural/hide = 2,
		/obj/item/natural/cloth = 1,
		)
	tools = list(/obj/item/needle = 1)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/mantrap
	name = "捕人夹"
	result = list(
		/obj/item/restraints/legcuffs/beartrap,
		/obj/item/restraints/legcuffs/beartrap,
		)
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 2,
		/obj/item/ingot/iron = 1,
		)
	req_table = TRUE
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 2
	verbage_simple = "组装"
	verbage = "组装"

/datum/crafting_recipe/roguetown/survival/paperscroll
	name = "羊皮纸卷轴（x3）"
	result = list(
		/obj/item/paper/scroll,
		/obj/item/paper/scroll,
		/obj/item/paper/scroll,
		)
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/datum/reagent/water = 48,
		)
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/prosthetic/woodleftarm
	name = "木臂（左）"
	result = list(/obj/item/bodypart/l_arm/prosthetic/woodleft)
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/prosthetic/woodrightarm
	name = "木臂（右）"
	result = list(/obj/item/bodypart/r_arm/prosthetic/woodright)
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/prosthetic/woodleftleft
	name = "木腿（左）"
	result = list(/obj/item/bodypart/l_leg/prosthetic)
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/prosthetic/woodrightleg
	name = "木腿（右）"
	result = list(/obj/item/bodypart/r_leg/prosthetic)
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/tarot_deck
	name = "塔罗牌组"
	result = list(/obj/item/toy/cards/deck/tarot)
	reqs = list(
		/obj/item/paper/scroll = 3,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/ash = 1,
		)
	skillcraft = /datum/skill/misc/reading
	tools = list(/obj/item/natural/feather)
	req_table = TRUE
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/tarot_deck_majorarcana
	name = "塔罗牌组（大阿卡那）"
	result = list(/obj/item/toy/cards/deck/tarot/majorarcana)
	reqs = list(
		/obj/item/paper/scroll = 3,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/ash = 1,
		)
	skillcraft = /datum/skill/misc/reading
	tools = list(/obj/item/natural/feather)
	req_table = TRUE
	craftdiff = 2

// Woodcutting recipe
/datum/crafting_recipe/roguetown/survival/lumberjacking
	skillcraft = /datum/skill/labor/lumberjacking
	tools = list(/obj/item/rogueweapon/huntingknife = 1)

/datum/crafting_recipe/hair_dye
	name = "染发膏"
	result = /obj/item/hair_dye_cream
	reqs = list(
		/obj/item/reagent_containers/glass/bowl = 1,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 3,
	)

// DIE

/datum/crafting_recipe/roguetown/survival/d4
	name = "骨骰（d4）"
	result = /obj/item/dice/d4
	reqs = list(/obj/item/natural/bone = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/d6
	name = "骨骰（d6）"
	result = /obj/item/dice/d6
	reqs = list(/obj/item/natural/bone = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/d8
	name = "骨骰（d8）"
	result = /obj/item/dice/d8
	reqs = list(/obj/item/natural/bone = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/d10
	name = "骨骰（d10）"
	result = /obj/item/dice/d10
	reqs = list(/obj/item/natural/bone = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/d12
	name = "骨骰（d12）"
	result = /obj/item/dice/d12
	reqs = list(/obj/item/natural/bone = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/d20
	name = "骨骰（d20）"
	result = /obj/item/dice/d20
	reqs = list(/obj/item/natural/bone = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/dye_brush
	name = "染色刷"
	result = /obj/item/dye_brush
	reqs = list(
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/fur = 1
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/whetstone
	name = "磨刀石"
	result = /obj/item/natural/whetstone
	reqs = list(
		/obj/item/natural/stone = 1,
		/obj/item/grown/log/tree/stake = 1,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/rucksack
	name = "背囊"
	result = /obj/item/storage/backpack/rogue/backpack/bagpack
	reqs = list(
		/obj/item/storage/roguebag = 1,
		/obj/item/rope = 1,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/rucksack/crafted
	reqs = list(/obj/item/storage/roguebag = 1,
				/obj/item/rope = 1)

/datum/crafting_recipe/roguetown/survival/handmirror
	name = "手镜"
	result = /obj/item/handmirror
	reqs = list(
		/obj/item/natural/glass = 1,
		/obj/item/grown/log/tree/stick = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/handmirror
	name = "手镜"
	result = /obj/item/handmirror
	reqs = list(
		/obj/item/natural/glass = 1,
		/obj/item/grown/log/tree/stick = 1,
		)
	craftdiff = 2

// Improvised surgey tools. They go here for now (TM)
/datum/crafting_recipe/roguetown/survival/improvisedsaw
	name = "简易手术锯"
	result = /obj/item/rogueweapon/surgery/saw/improv
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/natural/stone = 1,
		/obj/item/grown/log/tree/stick = 1,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/improvisedclamp
	name = "简易牵开器"
	result = /obj/item/rogueweapon/surgery/retractor/improv
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/grown/log/tree/stick = 2,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/improvisedhemo
	name = "简易夹钳"
	result = /obj/item/rogueweapon/surgery/hemostat/improv
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/grown/log/tree/stick = 2,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/improvisedscalpel
	name = "简易手术刀"
	result = /obj/item/rogueweapon/surgery/scalpel/improv
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/whetstone = 1,
		/obj/item/natural/stone = 1,
		)
	craftdiff = 2

// Unfortunately there's no good category for it, yet.
// I don't want ration paper to be too expensive, making wrapped food underused
// So instead, ration paper is a very cheap recipe with parchment and tallow (instead of full fat) that makes 2 wrapper
// However, it is heavily skillgated by cooking skill. At Craftdiff 4, only Innkeep / Cook can make it easily off the bat.
// Servant w/ high int can also make it, but it is a bit harder. Or just be middle aged / old instead lol
// For 1 fat, 1 log (48 reagents), you get 4 tallow + 6 piece of paper yielding 12 ration wrappers with 1 tallow leftover.
/datum/crafting_recipe/roguetown/survival/ration_wrapper
	name = "口粮包装纸（x2）"
	result = list(
		/obj/item/ration,
		/obj/item/ration,
		)
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		)
	skillcraft = /datum/skill/craft/cooking
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/cheele
	name = "cheele"
	result = list(
		/obj/item/natural/worms/leech/cheele
		)
	reqs = list(
		/obj/item/reagent_containers/lux = 1,
		/obj/item/natural/worms/leech = 1,
		)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = SKILL_LEVEL_EXPERT

/datum/crafting_recipe/roguetown/survival/purify_lux
	name = "提纯 Lux"
	result = list(
		/obj/item/heart_blood_canister,
		/obj/item/reagent_containers/lux,
		)
	reqs = list(
		/obj/item/reagent_containers/lux_impure = 1,
		/obj/item/heart_blood_canister/filled = 1,
		)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/purify_lux_vials
	name = "提纯 Lux（小瓶）"
	result = list(
		/obj/item/reagent_containers/lux,
		/obj/item/heart_blood_vial,
		/obj/item/heart_blood_vial,
		/obj/item/heart_blood_vial,
		)
	reqs = list(
		/obj/item/reagent_containers/lux_impure = 1,
		/obj/item/heart_blood_vial/filled = 3,
		)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/purify_lux_compress
	name = "提纯 Lux（压缩）"
	result = list(
		/obj/item/reagent_containers/lux,
		)
	reqs = list(
		/obj/item/reagent_containers/lux_impure = 2,
		)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/bandage
	name = "绷带（医疗）"
	result = list(
		/obj/item/natural/cloth/bandage
	)
	reqs = list(
		/obj/item/natural/cloth = 1,
		/obj/item/natural/silk = 1,
		/obj/item/ash = 1)
	skillcraft = /datum/skill/misc/medicine
	craftdiff = 2

/datum/crafting_recipe/roguetown/ironore
	name = "铁矿石"
	result = /obj/item/rogueore/iron
	reqs = list(
		/obj/item/alch/irondust = 3,
		)
	skillcraft = /datum/skill/craft/smelting
	craftdiff = 2

/datum/crafting_recipe/roguetown/ironore/advanced
	name = "铁矿石（进阶）"
	reqs = list(
		/obj/item/alch/irondust = 2,
		)
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/kneaded_clay
	name = "kneaded clay"
	result = /obj/item/natural/clay/kneaded
	reqs = list(
		/obj/item/natural/clay = 2,
		/datum/reagent/water = 2,
		)
	skillcraft = /datum/skill/craft/ceramics
	req_table = TRUE
	craftdiff = 2
