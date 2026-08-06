// ============================================================================
// 记忆之吻 (Memory Kiss Token) 制作配方
// ----------------------------------------------------------------------------
// 中文：在炼金台上调配——取一枚宝石，以清水为媒，铭刻心绪于其中。
//   材料：任意宝石 x1 + 水 50 单位
//   产物：记忆之吻 x1
//   需求：炼金 1 级（学徒即可）
// ============================================================================

/datum/crafting_recipe/roguetown/alchemy/memory_kiss_token
	name = "记忆之吻"
	category = "台面"
	result = list(/obj/item/memory_kiss_token = 1)
	reqs = list(
		/obj/item/roguegem = 1,
		/datum/reagent/water = 50,
	)
	craftdiff = 1
	verbage_simple = "制作"
	verbage = "制作"
