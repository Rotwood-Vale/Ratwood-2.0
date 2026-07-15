// ============================================================================
// 合成配方：涂毒工具袋（Poisoned Tool Pouch）
// ---------------------------------------------------------------------------
// English overview:
//   Hand-craft recipe for the Poisoned Tool Pouch item (items/poisoned_tool_pouch.dm).
//   Category : "通用制造" (General Manufacturing) — this comes automatically from
//              the skill, see below.
//   Skill    : /datum/skill/craft/crafting (name = "通用制造"), level 2 required.
//   Reqs     : tanned leather x1 + fiber x1 + empty glass bottle x1 (all consumed).
//   Tool     : a needle (NOT consumed, only needs to be on hand/nearby).
//
// 中文总览：
//   本文件为“涂毒工具袋”物品（见 items/poisoned_tool_pouch.dm）添加一条手工合成
//   配方，放在制作菜单的【通用制造】分类下，需【通用制造】技能达到 2 级方可制作。
//     材料（均消耗）：鞣制皮革 x1、纤维 x1、空玻璃瓶 x1。
//     工具（不消耗，仅需在手边）：缝衣针 x1。
//
// WHY this base class（为什么选这个父类）：
//   继承 /datum/crafting_recipe/roguetown/survival —— 这正是原版“通用生存/杂项手工”
//   配方族的父类，它已经替我们设好：
//     * skillcraft = /datum/skill/craft/crafting （即“通用制造”技能）；
//     * always_availible = TRUE （由更上层 /datum/crafting_recipe/roguetown/ 继承，
//       无需先学配方即可直接在菜单中看到）。
//   制作菜单的分栏依据是 recipe.cached_category，而它取自 skillcraft 的名字
//   （见 crafting.dm: crafting_recipes[R.cached_category]），因此只要技能是
//   /datum/skill/craft/crafting，本配方就会自动归入【通用制造】栏——无需手写 category。
//
// 约束：本文件只存在于 modular_z121 内，仅“继承/调用”主线现成类型，绝不修改模块外文件。
// 注册：modular_z121/_load.dm -> #include "crafting/poisoned_tool_pouch_recipe.dm"
// ============================================================================

// 中文：涂毒工具袋的合成配方定义（继承通用制造配方族）。
/datum/crafting_recipe/roguetown/survival/poisoned_tool_pouch
	// 中文：制作菜单中显示的名称。
	name = "涂毒工具袋"                                          // Craft-menu display name.

	// 中文：产物——一个空的涂毒工具袋（液体由玩家后续自行倒入）。
	// WHY 单一路径即可：同族的 survival 配方（如缝衣针 tneedle）就是用单一 result 路径，
	// 制作引擎对“单一类型路径”与“list(路径=数量)”两种写法都支持。
	result = /obj/item/reagent_containers/glass/z121_poison_pouch      // The empty pouch item.

	// 中文：材料需求（全部消耗）：
	//   · 鞣制皮革 x1 —— /obj/item/natural/hide/cured（游戏内名“鞣制皮革”），袋体主料；
	//   · 纤维     x1 —— /obj/item/natural/fibers，用于缝合/系口；
	//   · 空玻璃瓶 x1 —— /obj/item/reagent_containers/glass/bottle，作为内衬储液的瓶胆。
	// WHY 这些确切路径：均为主线现成物品类型（已在别处的皮革/缝纫配方中作为材料使用，确认可用）。
	reqs = list(
		/obj/item/natural/hide/cured = 1,                       // 鞣制皮革 x1 / tanned leather.
		/obj/item/natural/fibers = 1,                           // 纤维 x1 / fiber.
		/obj/item/reagent_containers/glass/bottle = 1,          // 空玻璃瓶 x1 / empty glass bottle.
	)

	// 中文：工具需求——缝衣针（仅需在手边，不被消耗）。
	// WHY tools 而非 reqs：crafting_recipe.tools 是“需要但不消耗”的类型清单（见 recipes.dm 注释），
	//   /obj/item/needle 是缝衣针基类，其各子类（如荆棘缝衣针 needle/thorn）经 istype 判定同样满足。
	tools = list(/obj/item/needle)                              // A needle (not consumed).

	// 中文：难度=2 —— 制作成功率公式 prob = 25 - 25*难度 + 25*技能等级（见 crafting.dm）。
	//   代入难度 2：技能 <2 时成功率 ≤0%（做不出），技能 =2 起才 >0%，从而把“需要通用制造 2 级”
	//   做成硬性等级门槛；菜单也会据此显示“适用于 学徒(2 级) 技艺者”。
	// WHY craftdiff = 2: prob = 25 - 25*diff + 25*skill; diff=2 gates skill<2 to <=0% (a hard
	//   level-2 floor) and the recipe panel prints the required level from craftdiff directly.
	craftdiff = 2                                               // Effective minimum: General-Manufacturing level 2.

	// 中文：制作反馈消息里使用的动词（“缝制”），贴合“用针把皮革与瓶胆缝成袋子”的意象。
	verbage_simple = "缝制"                                     // Feedback verb (simple form).
	verbage = "缝制"                                            // Feedback verb.
