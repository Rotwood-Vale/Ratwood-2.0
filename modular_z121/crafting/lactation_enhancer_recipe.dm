// ============================================================================
// Alchemy formula: 催乳剂 (Lactation Enhancing Agent).
// 中文：催乳剂的炼金配方（在炼金台上调配）。
//   材料 / Ingredients : 骨头 x2 + 玻璃瓶 x1 + 50 单位水 + 10 单位牛奶
//   产物 / Product     : 1 个装满 50 单位催乳剂的玻璃瓶
//
// WHY this shape: we subclass /datum/crafting_recipe/roguetown/alchemy — the same
// base every vanilla alchemy concoction uses. It already provides:
//   * skillcraft = /datum/skill/craft/alchemy   (this IS an alchemy formula)
//   * structurecraft = the alchemy bench         (must be done at an alchemy bench)
//   * always_availible = TRUE (inherited from /datum/crafting_recipe/roguetown/)
//   * subtype_reqs = TRUE
// The crafting engine natively supports REAGENT requirements (the 50u water and
// 10u milk here), pulled from any reagent container in reach — exactly how the
// existing 补血剂 (blood tonic) recipe consumes water + a bottle to make a filled
// bottle. This file lives ONLY under modular_z121, as required by the project rules.
// ============================================================================

// 中文：催乳剂炼金配方定义。
/datum/crafting_recipe/roguetown/alchemy/lactation_enhancer
	// 中文：制作菜单中显示的名称。
	name = "催乳剂"											// Craft-menu display name.
	// 中文：归入“台面”分类——与其它药剂/调配类配方同处一栏。
	category = "台面"										// Tabletop alchemy (concoctions) tab.
	// 中文：产物——1 个预装满催乳剂的玻璃瓶（见 alchemy/lactation_enhancer_reagent.dm）。
	// WHY a list: the engine expects `result` as a list of output type-paths.
	result = list(/obj/item/reagent_containers/glass/bottle/rogue/lactation_enhancer = 1)	// One filled bottle.
	// 中文：材料需求——骨头 x2、空玻璃瓶 x1、水 50 单位、牛奶 10 单位（试剂从附近容器扣取）。
	// WHY reagent paths as reqs: the crafting component treats a reagent type-path
	// as a volume requirement and drains it from nearby reagent containers.
	reqs = list(
		/obj/item/natural/bone = 2,						// 2 bones (ground for the bone-meal base).
		/obj/item/reagent_containers/glass/bottle = 1,	// 1 empty glass bottle to hold the result.
		/datum/reagent/water = 50,						// 50 units of water (drawn from a container).
		/datum/reagent/consumable/milk = 10,			// 10 units of milk (the lactogenic ingredient).
	)
	// 中文：难度设为 2——按制作概率公式 prob = 25 - 25*diff + 25*skill，等级 1 的炼金术士
	//       成功率 ≤0%，从等级 2 起才可调配，因此这相当于“需要 2 级炼金”的硬门槛
	//       （与题目“要求炼金等级 2”一致）。
	// WHY craftdiff = 2: skill<2 yields <=0% success (a hard level-2 floor) while
	// keeping it a simple, single-step concoction.
	craftdiff = 2											// Effective minimum: level-2 alchemy.
	// 中文：制作反馈消息中使用的动词（“调配”），其余动词沿用炼金基类。
	verbage_simple = "调配"									// Feedback verb (simple form).
	verbage = "调配"										// Feedback verb.
