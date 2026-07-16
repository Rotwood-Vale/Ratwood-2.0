// ===========================================================================
// modular_z121 自定义炼金配方：猎魔人剑油 x7（Witcher-style Sword Oils）
// ---------------------------------------------------------------------------
// English overview:
//   Seven alchemy-bench recipes (one per sword oil). All of them subclass the
//   vanilla /datum/crafting_recipe/roguetown/alchemy base, live in the same
//   "台面" (bench concoctions) tab as every other alchemy formula, and demand
//   Alchemy skill level 1 (craftdiff = 1). Products are defined in
//   modular_z121/items/sword_oils.dm.
//
// 中文总览：
//   七种剑油的炼金台配方，与原版炼金配方同一分类（“台面”），统一要求
//   【炼金 1 级】。产物（剑油瓶）定义见 modular_z121/items/sword_oils.dm。
//
// WHY 继承 /datum/crafting_recipe/roguetown/alchemy：这是原版所有“炼金台调配”
//   配方共用的基类，它已经提供：
//     * skillcraft = /datum/skill/craft/alchemy（判定用炼金技能）
//     * structurecraft = /obj/structure/fluff/alch（必须在炼金台旁调配）
//     * subtype_reqs = TRUE（材料需求按“类型及其子类”匹配——因此“板油”一项
//       同时接受软板油/红板油等变体，“玻璃瓶”一项接受 rogue 瓶全家族）
//     * always_availible = TRUE（配方对所有人可见，由技能门槛把关）
//   引擎的合成组件原生支持【试剂需求】（如 20u 圣水）——会自动从触手可及的
//   任意容器中扣取，与原版“水转酒”等配方的行为完全一致。
//
// WHY craftdiff = 1：合成成功率公式为 prob = 25 - 25*diff + 25*skill：
//   炼金 0 级 → 0%（造不出来）；炼金 1 级 → 25% 起步并随等级提升——
//   这正是“需要炼金技能 1 级”这一需求在本引擎里的标准表达（原版同难度
//   配方如“炼金瓶”“手工薄荷烟卷”均采用 craftdiff = 1）。
//
// 材料路径备忘（全部为主线/其它模块已存在的类型，本文件只引用不修改）：
//   板油        = /obj/item/reagent_containers/food/snacks/tallow （modular/Neu_Food）
//   强效毒药    = /datum/reagent/strongpoison                     （5u 即一剂满量毒药）
//   西池烟叶粉  = /obj/item/alch/tobaccodust                      （即“Westleach Dust”）
//   灰烬        = /obj/item/ash
//   肌腱        = /obj/item/alch/sinew
//   尾骨        = /obj/item/alch/bone
//   苍白蛛腺    = /obj/item/reagent_containers/spidervenom_inert  （即“Spider Gland”，泥沼蛛掉落）
//   沼泽烟叶粉  = /obj/item/alch/swampdust                        （即“Swampweed Dust”）
//   火之精质    = /obj/item/alch/firedust                         （即“Fire Essentia”）
//   圣水        = /datum/reagent/water/blessed                    （试剂需求，从容器扣取）
//   银粉        = /obj/item/alch/silverdust
//   祝圣种子粉  = /obj/item/alch/blessedseedpowder                （即“Blessed Seed Powder”）
//   骨粉        = /obj/item/alch/bonemeal                         （即“Bone Meal”）
//   玻璃瓶      = /obj/item/reagent_containers/glass/bottle/rogue （按任务指定路径）
//
// 注册方式：modular_z121/_load.dm -> #include "crafting/sword_oil_recipes.dm"
// ===========================================================================

// ===========================================================================
// 剑油配方共享基类：把七个配方完全一致的字段（分类/难度/动词）收拢到一处，
// 避免七份拷贝粘贴；abstract_type 确保这个“半成品基类”自身不会出现在合成菜单里。
// ===========================================================================
/datum/crafting_recipe/roguetown/alchemy/sword_oil
	// 中文：抽象基类标记——引擎的配方枚举会跳过 abstract_type 与自身相等的类型，
	//       因此只有下面七个具体子类会出现在合成菜单中。
	abstract_type = /datum/crafting_recipe/roguetown/alchemy/sword_oil
	// 中文：归入“台面”分类——与其它炼金台调配配方（奥兹姆/月尘等）同处一栏。
	category = "台面"
	// 中文：难度 1 = 硬性要求炼金技能 1 级（0 级成功率为 0%，见文件头公式说明）。
	craftdiff = 1
	// 中文：制作反馈消息中使用的动词（“调配”），与炼金基类保持一致的口吻。
	verbage_simple = "调配"
	verbage = "调配"

// ===========================================================================
// 绞刑者之油：板油 + 强效毒药 + 西池烟叶粉 + 灰烬 + 玻璃瓶
// 克制：人形生物（人类、蜥蜴人、兽人、哥布林等）。
// ===========================================================================
/datum/crafting_recipe/roguetown/alchemy/sword_oil/hanged_man
	// 中文：合成菜单中显示的名称。
	name = "绞刑者之油"
	// 中文：产物——1 瓶绞刑者之油（可涂抹 3 次，见 items/sword_oils.dm）。
	result = list(/obj/item/z121_sword_oil/hanged_man = 1)
	// 中文：材料需求。强效毒药按【试剂】需求扣取 5 单位（正好一剂满量毒药，
	//       从手边任意容器——例如小瓶装强效毒药——中自动抽取）。
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,	// 板油 x1（油脂基底）
		/datum/reagent/strongpoison = 5,						// 强效毒药 5u（“绞刑者”的毒性来源）
		/obj/item/alch/tobaccodust = 1,							// 西池烟叶粉 x1（Westleach Dust）
		/obj/item/ash = 1,										// 灰烬 x1
		/obj/item/reagent_containers/glass/bottle/rogue = 1,	// 玻璃瓶 x1（盛装容器，按任务指定路径）
	)

// ===========================================================================
// 兽类之油：板油 + 肌腱 + 尾骨 + 西池烟叶粉 + 玻璃瓶
// 克制：熊、狼、巨兽与野外掠食动物等普通兽类。
// ===========================================================================
/datum/crafting_recipe/roguetown/alchemy/sword_oil/beast
	// 中文：合成菜单中显示的名称。
	name = "兽类之油"
	// 中文：产物——1 瓶兽类之油。
	result = list(/obj/item/z121_sword_oil/beast = 1)
	// 中文：材料需求（全部为实体材料，无试剂项）。
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,	// 板油 x1（油脂基底）
		/obj/item/alch/sinew = 1,								// 肌腱 x1（Sinew，兽类同源材料）
		/obj/item/alch/bone = 1,								// 尾骨 x1（Tail Bone）
		/obj/item/alch/tobaccodust = 1,							// 西池烟叶粉 x1（Westleach Dust）
		/obj/item/reagent_containers/glass/bottle/rogue = 1,	// 玻璃瓶 x1
	)

// ===========================================================================
// 蛛形怪之油：板油 + 苍白蛛腺 + 沼泽烟叶粉 + 肌腱 + 玻璃瓶
// 克制：蜘蛛、毒虫与地底巢穴生物。
// ===========================================================================
/datum/crafting_recipe/roguetown/alchemy/sword_oil/arachnid
	// 中文：合成菜单中显示的名称。
	name = "蛛形怪之油"
	// 中文：产物——1 瓶蛛形怪之油。
	result = list(/obj/item/z121_sword_oil/arachnid = 1)
	// 中文：材料需求。
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,	// 板油 x1（油脂基底）
		/obj/item/reagent_containers/spidervenom_inert = 1,		// 苍白蛛腺 x1（Spider Gland，泥沼蛛掉落）
		/obj/item/alch/swampdust = 1,							// 沼泽烟叶粉 x1（Swampweed Dust）
		/obj/item/alch/sinew = 1,								// 肌腱 x1（Sinew）
		/obj/item/reagent_containers/glass/bottle/rogue = 1,	// 玻璃瓶 x1
	)

// ===========================================================================
// 恶魔之油：板油 + 火之精质 + 圣水 + 灰烬 + 玻璃瓶
// 克制：恶魔、地狱犬与炼狱召唤物。
// ===========================================================================
/datum/crafting_recipe/roguetown/alchemy/sword_oil/demon
	// 中文：合成菜单中显示的名称。
	name = "恶魔之油"
	// 中文：产物——1 瓶恶魔之油。
	result = list(/obj/item/z121_sword_oil/demon = 1)
	// 中文：材料需求。圣水按【试剂】需求扣取 20 单位（从手边任意容器自动抽取，
	//       与原版“水银”配方消耗圣水的方式一致）。
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,	// 板油 x1（油脂基底）
		/obj/item/alch/firedust = 1,							// 火之精质 x1（Fire Essentia）
		/datum/reagent/water/blessed = 20,						// 圣水 20u（神圣性的来源）
		/obj/item/ash = 1,										// 灰烬 x1
		/obj/item/reagent_containers/glass/bottle/rogue = 1,	// 玻璃瓶 x1
	)

// ===========================================================================
// 诅咒之油：板油 + 银粉 + 西池烟叶粉 + 圣水 + 玻璃瓶
// 克制：狼人、受诅咒的兽化者与惧银的怪物。
// ===========================================================================
/datum/crafting_recipe/roguetown/alchemy/sword_oil/cursed
	// 中文：合成菜单中显示的名称。
	name = "诅咒之油"
	// 中文：产物——1 瓶诅咒之油。
	result = list(/obj/item/z121_sword_oil/cursed = 1)
	// 中文：材料需求。
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,	// 板油 x1（油脂基底）
		/obj/item/alch/silverdust = 1,							// 银粉 x1（Silver Dust——克制惧银者的核心）
		/obj/item/alch/tobaccodust = 1,							// 西池烟叶粉 x1（Westleach Dust）
		/datum/reagent/water/blessed = 20,						// 圣水 20u
		/obj/item/reagent_containers/glass/bottle/rogue = 1,	// 玻璃瓶 x1
	)

// ===========================================================================
// 吸血鬼之油：板油 + 银粉 + 圣水 + 祝圣种子粉 + 玻璃瓶
// 克制：吸血鬼及血裔、血魔法相关的敌人。
// ===========================================================================
/datum/crafting_recipe/roguetown/alchemy/sword_oil/vampire
	// 中文：合成菜单中显示的名称。
	name = "吸血鬼之油"
	// 中文：产物——1 瓶吸血鬼之油。
	result = list(/obj/item/z121_sword_oil/vampire = 1)
	// 中文：材料需求。
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,	// 板油 x1（油脂基底）
		/obj/item/alch/silverdust = 1,							// 银粉 x1（Silver Dust）
		/datum/reagent/water/blessed = 20,						// 圣水 20u
		/obj/item/alch/blessedseedpowder = 1,					// 祝圣种子粉 x1（Blessed Seed Powder）
		/obj/item/reagent_containers/glass/bottle/rogue = 1,	// 玻璃瓶 x1
	)

// ===========================================================================
// 食尸生物之油：板油 + 银粉 + 骨粉 + 圣水 + 玻璃瓶
// 克制：骷髅、丧尸、亡灵杂兵等不死者。
// ===========================================================================
/datum/crafting_recipe/roguetown/alchemy/sword_oil/necrophage
	// 中文：合成菜单中显示的名称。
	name = "食尸生物之油"
	// 中文：产物——1 瓶食尸生物之油。
	result = list(/obj/item/z121_sword_oil/necrophage = 1)
	// 中文：材料需求。
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,	// 板油 x1（油脂基底）
		/obj/item/alch/silverdust = 1,							// 银粉 x1（Silver Dust）
		/obj/item/alch/bonemeal = 1,							// 骨粉 x1（Bone Meal）
		/datum/reagent/water/blessed = 20,						// 圣水 20u
		/obj/item/reagent_containers/glass/bottle/rogue = 1,	// 玻璃瓶 x1
	)
