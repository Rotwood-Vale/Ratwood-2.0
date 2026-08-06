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

// 愚人药水：饮下后一段时间内智力大减、胡言乱语、步履蹒跚。预装 30 单位（与该药水的精炼产量一致，约 15 分钟药效）。
/obj/item/reagent_containers/glass/bottle/rogue/idiot_potion
	name = "愚人药水瓶"
	desc = "一瓶预装的愚人药水，饮下会在一段时间内变得神志迟钝、言语混乱、步履不稳。"
	list_reagents = list(/datum/reagent/idiot_potion = 30)                        // 预装 30 单位（与其精炼产量一致）。

// 虚弱药水：饮下后一段时间内力量大减（-8），四肢发软、气力尽失。预装 30 单位（与该药水的精炼产量一致，约 15 分钟药效）。
/obj/item/reagent_containers/glass/bottle/rogue/weakness_potion
	name = "虚弱药水瓶"
	desc = "一瓶预装的虚弱药水，饮下会在一段时间内力量大减、四肢发软、举手投足都变得沉重吃力。"
	list_reagents = list(/datum/reagent/weakness_potion = 30)                     // 预装 30 单位（与其精炼产量一致）。

// 气化之躯药水：饮下化作雾气之躯，可穿门过窗、怪物不视为敌、免疫常规伤害；唯惧龙卷风。预装 30 单位（与该药水的精炼产量一致，约 6 分钟药效）。
/obj/item/reagent_containers/glass/bottle/rogue/gasification_body
	name = "气化之躯药水瓶"
	desc = "一瓶预装的气化之躯药水，饮下会化作流动的雾气：只能随风飘移或凌空飞行、不能出手开口取物，随意穿门过窗、怪物不再视你为敌、寻常伤害皆无从加害——唯独惧怕被龙卷风吸入撕散。"
	list_reagents = list(/datum/reagent/gasification_body_potion = 30)            // 预装 30 单位（与其精炼产量一致）。

// 麻痹毒药：饮下后依体质分档麻痹——体质18-20仅舌麻失语；14-17连手臂发麻、拿不起用不了物品；≤13周身发麻当场瘫倒、动弹不得。
//   预装 30 单位（与该药水的精炼产量一致，约 3 分钟药效）。
/obj/item/reagent_containers/glass/bottle/rogue/paralytic_poison
	name = "麻痹毒药瓶"
	desc = "一瓶预装的麻痹毒药，饮下会依体质强弱而生轻重不一的麻痹：体质强者仅舌头发麻、难以言语；中平者连手臂也一并发麻、拿不起也用不了东西；孱弱者更会周身失觉、当场瘫软倒地、动弹不得。"
	list_reagents = list(/datum/reagent/paralytic_poison = 30)                    // 预装 30 单位（与其精炼产量一致）。

// 怠惰药水：饮下后一段时间内，(A)每次主动动作（攻击/拾取/使用/施法等一切点击）都有几率被"懒掉"、动作不执行、
//   并嘟囔一句懒话；(B)移动变慢；(C)一切读条动作变慢；(D)若一段时间什么都不做则缓慢回复伤势并补充饥渴（一动即打断）。
//   预装 30 单位（与该药水的精炼产量一致，约 4.5 分钟药效）。
/obj/item/reagent_containers/glass/bottle/rogue/sloth_potion
	name = "怠惰药水瓶"
	desc = "一瓶预装的怠惰药水，饮下会在一段时间内四体发懒、意兴阑珊：动作时常直接作罢、只余一句有气无力的'太累了'，脚步拖沓、做起需耐心的活计也格外磨蹭；可若索性歇着什么都不做，伤势与饥渴反倒会在慵懒的休憩中慢慢缓解。"
	list_reagents = list(/datum/reagent/sloth_potion = 30)                        // 预装 30 单位（与其精炼产量一致）。

// 回忆药剂：饮下并消化满 5 单位后，被传送回上一次睡觉的地点。预装 30 单位（与该药水的精炼产量一致，
//   30 >= 5 的触发阈值，取即可用；一份足够触发一次传送）。
/obj/item/reagent_containers/glass/bottle/rogue/memory_potion
	name = "回忆药剂瓶"
	desc = "一瓶预装的回忆药剂，饮下足量并待其消化后，会被沉睡的记忆牵引、送回上一次安睡之处。"
	list_reagents = list(/datum/reagent/memory_potion = 30)                       // 预装 30 单位（与其精炼产量一致，30 >= 5 触发阈值）。

// 禁欲药水（强制贞洁）：压制高潮、维持快感，约 8 分钟。预装 50 单位（与其精炼产量一致）。
/obj/item/reagent_containers/glass/bottle/rogue/forced_chastity
	name = "禁欲药水瓶"
	desc = "一瓶预装的禁欲药水，饮下后快感堆积却无法高潮——欲泄而不能的甜蜜酷刑。"
	list_reagents = list(/datum/reagent/forced_chastity_potion = 50)              // 预装 50 单位（与其精炼产量一致）。

// 丰盈药水：临时增大性器官尺寸，约 5 分钟。预装 30 单位（与其精炼产量一致）。
/obj/item/reagent_containers/glass/bottle/rogue/enlargement
	name = "丰盈药水瓶"
	desc = "一瓶预装的丰盈药水，饮下后一股暖流蔓延全身——某些部位会暂时比平时更加饱满丰腴。"
	list_reagents = list(/datum/reagent/enlargement_potion = 30)                 // 预装 30 单位（与其精炼产量一致）。
