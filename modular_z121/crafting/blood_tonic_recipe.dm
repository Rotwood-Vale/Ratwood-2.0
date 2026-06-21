// ============================================================================
// Simple alchemy formula: 补血剂 (Blood Tonic).
// 中文：补血剂的简易炼金配方（在炼金台上调配，无需专用药锅）。
//   材料 / Ingredients : 水蛭 x2 + 50 单位水 + 玻璃瓶 x1
//   产物 / Product     : 1 个装满补血剂的玻璃瓶
//
// WHY this shape: we subclass /datum/crafting_recipe/roguetown/alchemy — the same
// base every vanilla alchemy concoction uses. It already provides:
//   * skillcraft = /datum/skill/craft/alchemy   (this IS an alchemy formula)
//   * structurecraft = /obj/structure/fluff/alch (must be done at an alchemy bench)
//   * always_availible = TRUE (inherited from /datum/crafting_recipe/roguetown/)
//   * subtype_reqs = TRUE
// The crafting engine natively supports a REAGENT requirement (here 50u of water),
// pulled from any reagent container in reach — exactly how the vanilla
// "水转酒" (water->wine) recipe consumes water + a bottle to make a filled bottle.
// This file lives ONLY under modular_z121, as required by the project rules.
// ============================================================================

// 中文：补血剂炼金配方定义。
/datum/crafting_recipe/roguetown/alchemy/blood_tonic
	// 中文：制作菜单中显示的名称。
	name = "补血剂"											// Craft-menu display name.
	// 中文：归入“台面”分类——与其它药剂/调配类配方同处一栏。
	category = "台面"										// Tabletop alchemy (concoctions) tab.
	// 中文：产物——1 个预装满补血剂的玻璃瓶（见 alchemy/blood_tonic_reagent.dm）。
	// WHY a list: the engine expects `result` as a list of output type-paths.
	result = list(/obj/item/reagent_containers/glass/bottle/rogue/blood_tonic = 1)	// One filled bottle.
	// 中文：材料需求——水蛭 x2、水 50 单位（试剂，从附近容器中扣取）、空玻璃瓶 x1。
	// WHY /datum/reagent/water as a req: the crafting component treats reagent
	// paths as a volume requirement and drains it from nearby containers.
	reqs = list(
		/obj/item/natural/worms/leech = 2,				// 2 leeches (the blood-rich ingredient).
		/datum/reagent/water = 50,						// 50 units of water (drawn from a container).
		/obj/item/reagent_containers/glass/bottle = 1,	// 1 empty glass bottle to hold the result.
	)
	// 中文：难度设为 2——按制作概率公式，等级 1 的炼金术士成功率 ≤0%，从等级 2 起才可调配，
	//       因此这相当于把“需要 2 级炼金”做成硬门槛（与原始需求一致）。
	// WHY craftdiff = 2: prob = 25 - 25*diff + 25*skill, so skill<2 yields <=0% (a
	// hard level-2 floor) while keeping it a simple, single-step concoction.
	craftdiff = 2											// Effective minimum: level-2 alchemy.
	// 中文：制作反馈消息中使用的动词（“调配”），其余动词沿用炼金基类。
	verbage_simple = "调配"									// Feedback verb (simple form).
	verbage = "调配"										// Feedback verb.
