// ============================================================================
// modular_z121/items/custom_potion_bottles.dm
// 自定义药水成品瓶（Pre-filled bottles for modular_z121 custom potions）
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   modular_z121 的精炼炼金体系（alchemy/refining_potions/*）里的各种"药水"本体都是试剂
//   （/datum/reagent/...），需要经"精炼"流程酿入锅 / 瓶才能使用——本身没有"拿来即用的成品瓶物品"。
//   而 RPG 系统商店的兑换流程 do_buy_item 是 `new 物品类型(...)` 生成一个"物品"，无法直接生成"试剂"。
//   因此这里为每种自定义药水补一个"预装 50 单位该药水的玻璃瓶物品"，让它们能像 healthpot / manapot
//   一样被当作即用消耗品在商店里兑换。
//
// 为什么这样写就够了：
//   参照引擎既有成品药水瓶（如 /obj/item/reagent_containers/glass/bottle/rogue/healthpot）的写法——
//   仅需继承 rogue 玻璃瓶基类、设置 list_reagents（预装 50 单位对应试剂）即可；图标 / 行为等全部
//   沿用基类（clear_bottle1，含液面填充叠层），与其它药水瓶表现一致，无需新增美术资源。
//   （本模块既有的 /blood_tonic、/lactation_enhancer 成品瓶就是同样只设 list_reagents 的写法。）
//
// 加载：本文件需在 modular_z121/_load.dm 中以 #include 引入（已在该文件追加）。
// 依赖：均为已存在的自定义试剂（见 alchemy/refining_potions/*、alchemy/*_reagent.dm），本文件只引用不修改。
// ============================================================================

// 精力药剂：短时增益体力 / 精力。
/obj/item/reagent_containers/glass/bottle/rogue/vigor_potion
	name = "精力药剂瓶"                                                          // 玻璃瓶显示名。
	desc = "一瓶预装的精力药剂，饮下可短时振奋精力。"                             // 简要说明。
	list_reagents = list(/datum/reagent/vigor_potion = 50)                       // 预装 50 单位（与其它药水瓶一致）。

// 暖心酒剂：温暖身心的酒基药剂。
/obj/item/reagent_containers/glass/bottle/rogue/heart_tonic
	name = "暖心酒剂瓶"
	desc = "一瓶预装的暖心酒剂，暖身暖心。"
	list_reagents = list(/datum/reagent/consumable/ethanol/refined_potion/heartwarming_tonic = 50)

// 温酒：驱寒的温热酒液。
/obj/item/reagent_containers/glass/bottle/rogue/warm_wine
	name = "温酒瓶"
	desc = "一瓶预装的温酒，入喉暖身、驱散寒意。"
	list_reagents = list(/datum/reagent/consumable/ethanol/refined_potion/warm_wine = 50)

// 克林卡特：精炼酒基药剂。
/obj/item/reagent_containers/glass/bottle/rogue/klinkat
	name = "克林卡特瓶"
	desc = "一瓶预装的克林卡特精炼酒剂。"
	list_reagents = list(/datum/reagent/consumable/ethanol/refined_potion/klinkat = 50)

// 驱兽药水：短时驱赶 / 威慑怪物。
/obj/item/reagent_containers/glass/bottle/rogue/monster_repel
	name = "驱兽药水瓶"
	desc = "一瓶预装的驱兽药水，可在一段时间内令野兽退避。"
	list_reagents = list(/datum/reagent/monster_repel_potion = 50)

// 隐身药水：短时隐形。
/obj/item/reagent_containers/glass/bottle/rogue/invisibility
	name = "隐身药水瓶"
	desc = "一瓶预装的隐身药水，饮下可短时隐匿身形。"
	list_reagents = list(/datum/reagent/invisibility_potion = 50)

// 飞行药水：短时飞行。
/obj/item/reagent_containers/glass/bottle/rogue/flying
	name = "飞行药水瓶"
	desc = "一瓶预装的飞行药水，饮下可短时凌空飞行。"
	list_reagents = list(/datum/reagent/flying_potion = 50)

// 万能修复溶剂：泼洒 / 施用于物品以修复其损耗。
/obj/item/reagent_containers/glass/bottle/rogue/universal_repair
	name = "万能修复溶剂瓶"
	desc = "一瓶预装的万能修复溶剂，施于物品可修复其损耗。"
	list_reagents = list(/datum/reagent/universal_repair_solvent = 50)

// 变性药水：改变饮用者的生理性别。
/obj/item/reagent_containers/glass/bottle/rogue/gender_swap
	name = "变性药水瓶"
	desc = "一瓶预装的变性药水，饮下将改变身体的生理性别。"
	list_reagents = list(/datum/reagent/gender_swap_potion = 50)

// 媚药：强效催情药剂。
/obj/item/reagent_containers/glass/bottle/rogue/aphrodisiac
	name = "媚药瓶"
	desc = "一瓶预装的媚药，气息暧昧，饮下会强烈催情。"
	list_reagents = list(/datum/reagent/forced_estrus_aphrodisiac = 50)

// 防腐（改版）：已由"液体药水"改为【固体防腐皂 /obj/item/anticorruption_soap】，
//   成品直接由「精炼炼药锅」产出、手持点击食物/尸体施用，不再是可装瓶的液体试剂，
//   故此处不再提供预装液体瓶(原 /datum/reagent/anticorruption_potion 已移除)。

// 硬化药剂：短时减免受到的钝击伤害。
/obj/item/reagent_containers/glass/bottle/rogue/hardened_potion
	name = "硬化药剂瓶"
	desc = "一瓶预装的硬化药剂，饮下可在一段时间内减免钝击伤害。"
	list_reagents = list(/datum/reagent/medicine/hardened_potion = 50)            // 硬化药剂继承自 medicine 分支。

// 防蚂蟥药水：短时令水蛭无法附身吸血。
/obj/item/reagent_containers/glass/bottle/rogue/anti_leech
	name = "防蚂蟥药水瓶"
	desc = "一瓶预装的防蚂蟥药水，饮下可在一段时间内令水蛭无法附身吸血。"
	list_reagents = list(/datum/reagent/anti_leech_potion = 50)

// 身体再生药剂：饮用并消化满 10 单位后再生已失去的四肢。此处预装 50 单位，足量触发再生。
/obj/item/reagent_containers/glass/bottle/rogue/bodily_regeneration
	name = "身体再生药剂瓶"
	desc = "一瓶预装的身体再生药剂，饮下足量并待其消化后可重新长出失去的肢体。"
	list_reagents = list(/datum/reagent/bodily_regeneration_potion = 50)          // 50 >= 10 的生效阈值，管理员测试即取即用。

// 复原药剂：泼洒/喷淋到物品上以将其分解回原材料。预装 50 单位（远超单件所需的 10 单位阈值）。
/obj/item/reagent_containers/glass/bottle/rogue/restorative_potion
	name = "复原药剂瓶"
	desc = "一瓶预装的复原药剂，泼于器物之上可将其崩解、复归为最初的原料。"
	list_reagents = list(/datum/reagent/restorative_potion = 50)                  // 50 >= 10 的单件分解阈值，取即可用。

// 荧光药水：饮下后自体持续发光，光强随体内残留药量强弱。预装 50 单位（与该药水的精炼产量一致，满量=最亮）。
/obj/item/reagent_containers/glass/bottle/rogue/luminescent_potion
	name = "荧光药水瓶"
	desc = "一瓶预装的荧光药水，饮下可在一段时间内自体发光，且光芒随体内药量多寡而强弱变化。"
	list_reagents = list(/datum/reagent/luminescent_potion = 50)                  // 预装 50 单位（与其它药水瓶一致）。
