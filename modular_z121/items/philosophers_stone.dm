// ===========================================================================
// modular_z121 自定义物品：贤者之石（Philosopher's Stone）
// ---------------------------------------------------------------------------
// 设计目标：一件传说级炼金终极造物。持握它点击目标 / 使用自身，可实现三种奇迹：
//   效果 1：把普通石头点石成金（变成金矿石）——无冷却。
//   效果 2：把容器里的“水”嬗变为任意一种药水——冷却 3 分钟。
//   效果 3：凭空创造物品——冷却时间与所造物品的“价值(sellprice)”正相关，
//           且只能创造价值大于 1 的物品。
//
// 约束（严格遵守项目规则）：本文件只存在于 modular_z121 内，仅“调用”主线系统
//   的现有类型 / proc（/obj/item/rogueore/gold、/datum/reagents、
//   /datum/alch_cauldron_recipe、sellprice 等），绝不修改 modular_z121 之外
//   的任何文件。
//
// 注册方式（均在 modular_z121 内）：
//   modular_z121/_load.dm -> #include "items/philosophers_stone.dm"
//
// 贴图：'modular_z121/icon/item.dmi' 内唯一图标态 "Philosopher's Stone"。
// ===========================================================================

// ===== 数值旋钮（集中定义，文件末尾统一 #undef，避免污染全局命名空间）=====
// 之所以集中放这些魔法数字，是为了让后续平衡性调整一目了然。
#define PHILO_STONE_ICON             'modular_z121/icon/item.dmi'   // 物品贴图文件（本模块内）
#define PHILO_STONE_STATE            "Philosopher's Stone"          // 贴图内唯一图标态名（32x32 标准尺寸，无需缩放修正）

#define PHILO_TRANSMUTE_CHANNEL      (1 SECONDS)                    // 点石成金 / 嬗变水时的引导时长（纯表现，非冷却）
#define PHILO_POTION_COOLDOWN        (3 MINUTES)                    // 效果 2（水→药水）的冷却时间：3 分钟

// 效果 3（凭空造物）：冷却 = 物品价值 × 每点价值秒数，并钳制在上下限之间。
#define PHILO_CREATE_MIN_VALUE       1                              // 可被创造的最低价值门槛（严格“大于 1”，故实际要求 > 此值）
#define PHILO_CREATE_CD_PER_VALUE    (3 SECONDS)                    // 每 1 点价值折算的冷却秒数
#define PHILO_CREATE_CD_MIN          (5 SECONDS)                    // 造物冷却下限
#define PHILO_CREATE_CD_MAX          (30 MINUTES)                   // 造物冷却上限
#define PHILO_CREATE_SEARCH_CAP      50                             // 造物搜索菜单最多展示的候选数量（防止列表爆炸）

// —— 合成配方（在精炼炼药锅中炼成贤者之石）相关常量 ——
#define PHILO_SYNTH_POTION_AMOUNT    10                             // 合成所需：每一种药水各需的最小单位数（原版+精炼药水皆为 10u）

// ===========================================================================
// 物品本体定义
// ---------------------------------------------------------------------------
// 直接继承 /obj/item：贤者之石只是一件手持道具，靠 pre_attack / attack_self
// 两个交互钩子驱动三种效果，无需任何特殊父类。
// ===========================================================================
/obj/item/philosophers_stone
	name = "贤者之石"                                             // 物品名（中文），点击查看时显示
	desc = "传说中炼金术的终极追求：一块违背世间常理的赤红晶石。\n\
	它能将顽石点化为黄金，将净水嬗变为百药，甚至凭空造物——只要付出相应的代价。"  // 描述文本（换行使用 \ 续行）
	icon = PHILO_STONE_ICON                                       // 使用本模块贴图文件
	icon_state = PHILO_STONE_STATE                                // 使用唯一图标态
	w_class = WEIGHT_CLASS_TINY                                   // 体积“微小”：与一块普通石头相当，便于握持收纳
	force = 5                                                     // 基础打击力（当武器抡打时很弱，它不是武器）
	throwforce = 5                                                // 投掷伤害（同样很低）
	throw_range = 5                                               // 可投掷距离
	sellprice = 5000                                              // 它本身价值连城（也让它自身满足“价值>1”的造物规则）
	max_integrity = 1000                                          // 极高结构完整度：几乎不会被摧毁

	// —— 冷却记账变量（用 world.time 绝对时间戳记录“冷却结束时刻”）——
	var/potion_cd_end = 0                                         // 效果 2（水→药水）的冷却结束时刻；<= world.time 表示可用
	var/create_cd_end = 0                                        // 效果 3（凭空造物）的冷却结束时刻；<= world.time 表示可用

// —— 效果 3 的“可造物品目录”全局缓存 —— //
// 为避免每次造物都重新扫描上千种物品类型，用一个全局静态列表缓存一次扫描结果：
// 元素为“价值 initial(sellprice) 严格大于 PHILO_CREATE_MIN_VALUE 的物品类型路径”。
GLOBAL_LIST_EMPTY(philo_creatable_item_types)

// ===========================================================================
// examine：查看物品时附带显示两个冷却的当前状态，方便玩家掌握节奏。
// ===========================================================================
/obj/item/philosophers_stone/examine(mob/user)
	. = ..()                                                      // 先取得父类的标准描述行
	// 效果 2 冷却提示：若仍在冷却，算出剩余秒数并展示；否则显示“就绪”。
	if(potion_cd_end > world.time)
		var/secs_left = round((potion_cd_end - world.time) / 10)  // world.time 单位是十分之一秒(deciseconds)，/10 得到秒
		. += span_warning("嬗变净水之力尚在凝聚（还需 [secs_left] 秒）。")
	else
		. += span_notice("嬗变净水之力：已就绪。")
	// 效果 3 冷却提示：同上。
	if(create_cd_end > world.time)
		var/secs_left = round((create_cd_end - world.time) / 10)  // 同样换算成秒
		. += span_warning("凭空造物之力尚在凝聚（还需 [secs_left] 秒）。")
	else
		. += span_notice("凭空造物之力：已就绪。")

// ===========================================================================
// pre_attack：手持贤者之石点击“某个目标”时最先触发的钩子。
// 返回 TRUE 会中断后续的 attackby/afterattack 链（即“消费掉”这次点击）。
// 我们据目标类型分发到效果 1（点石成金）或效果 2（水→药水）；其余情况放行。
// ---------------------------------------------------------------------------
/obj/item/philosophers_stone/pre_attack(atom/A, mob/living/user, params)
	// 错误处理：没有目标或没有使用者时，交还给父类默认逻辑，避免空指针。
	if(!A || !user)
		return ..()

	// 分支①：目标是“石头”（小石子 /obj/item/natural/stone 或巨石 /obj/item/natural/rock）→ 点石成金。
	if(istype(A, /obj/item/natural/stone) || istype(A, /obj/item/natural/rock))
		transmute_stone_to_gold(A, user)                         // 执行效果 1
		return TRUE                                              // 消费本次点击，阻止把石头当武器砸

	// 分支②：目标是“试剂容器”（瓶 / 杯 / 桶等一切 /obj/item/reagent_containers）→ 尝试水→药水。
	if(istype(A, /obj/item/reagent_containers))
		// 仅当容器里确实含水时才拦截并施法；否则放行给父类（保留正常的喝/倒等交互）。
		var/obj/item/reagent_containers/container = A               // 类型转换以便访问 reagents
		if(container.reagents && container.reagents.has_reagent(/datum/reagent/water))
			transmute_water_to_potion(container, user)           // 执行效果 2
			return TRUE                                          // 消费本次点击
		// 不含水：不拦截，走原有交互逻辑。
		return ..()

	// 其余目标：不属于本石之力的作用范围，交还父类默认行为。
	return ..()

// ===========================================================================
// attack_self：贤者之石在手中被“对自身使用”（激活手持物）时触发 → 效果 3 凭空造物。
// ===========================================================================
/obj/item/philosophers_stone/attack_self(mob/user)
	create_item_from_nothing(user)                               // 直接进入凭空造物流程
	return TRUE                                                   // 表示已处理该交互

// ===========================================================================
// 效果 1：点石成金（无冷却）
// 把被点击的“石头”原地嬗变为金矿石。巨石产出多块，小石子产出一块。
// ===========================================================================
/obj/item/philosophers_stone/proc/transmute_stone_to_gold(atom/target, mob/living/user)
	// 二次校验：目标可能在派发过程中已被删除。
	if(QDELETED(target))
		to_chat(user, span_warning("那块石头已经不在了。"))       // 反馈失败原因
		return

	// 邻近校验：只能对“伸手可及”的石头施法，避免隔空点金。
	if(!user.Adjacent(target))
		to_chat(user, span_warning("我得先靠近那块石头才能点化它。")) // 距离太远的提示
		return

	// 记录石头所在地块，作为金矿石的生成位置。
	var/turf/spot = get_turf(target)
	if(!spot)                                                     // 极端情况下石头不在任何地块上
		to_chat(user, span_warning("这块石头无处安放，点化失败。"))  // 兜底错误处理
		return

	// 表现层：给一个短暂引导，让“点化”有仪式感（这不是冷却，可随时被打断）。
	user.visible_message(
		span_notice("[user] 将赤红的贤者之石按在石头上，晶石表面泛起流动的金色光纹……"),  // 旁观者视角
		span_notice("我将贤者之石抵住这块顽石，引导它向黄金嬗变……")                        // 自身视角
	)
	if(!do_after(user, PHILO_TRANSMUTE_CHANNEL, target = user))    // 引导 1 秒；被打断则返回 FALSE
		to_chat(user, span_warning("点化被打断了。"))              // 引导失败反馈
		return

	// 引导成功后再次确认目标仍在（引导期间可能被他人破坏 / 捡走）。
	if(QDELETED(target) || !user.Adjacent(target))
		to_chat(user, span_warning("石头在我完成点化前离开了我的掌控。"))  // 目标失效兜底
		return

	// 依据石头体量决定金矿石产出数量：巨石(boulder) 出 3 块，小石子出 1 块。
	var/gold_count = istype(target, /obj/item/natural/rock) ? 3 : 1
	// 逐块生成金矿石 /obj/item/rogueore/gold（主线现成类型，直接复用）。
	for(var/i in 1 to gold_count)
		var/obj/item/rogueore/gold/nugget = new /obj/item/rogueore/gold(spot)  // 在原地块生成一块金矿石
		nugget.pixel_x = rand(-6, 6)                             // 随机像素偏移，让多块金矿石散落得更自然
		nugget.pixel_y = rand(-6, 6)

	// 销毁原石头，完成“点石成金”的等价替换。
	qdel(target)

	// 表现层：金光与音效。
	playsound(spot, 'sound/foley/coins1.ogg', 60, TRUE)          // 借用金币音效表现“黄金诞生”
	user.visible_message(
		span_notice("石头在金色辉光中彻底化作了黄金！"),          // 旁观者视角成功提示
		span_green("点石成金！这块顽石已变成了实打实的金矿石。")   // 自身视角成功提示
	)

// ===========================================================================
// 效果 2：净水嬗变为任意药水（冷却 3 分钟）
// 从主线炼金锅配方 /datum/alch_cauldron_recipe 的全部子类中挑选一种药水，
// 把容器里当前的液体（含水）整体转化为该药水。
// ===========================================================================
/obj/item/philosophers_stone/proc/transmute_water_to_potion(obj/item/reagent_containers/container, mob/living/user)
	// 冷却校验：仍在冷却中则拒绝并告知剩余时间。
	if(potion_cd_end > world.time)
		var/secs_left = round((potion_cd_end - world.time) / 10)  // 剩余秒数
		to_chat(user, span_warning("嬗变净水之力尚未凝聚完成，还需 [secs_left] 秒。"))
		return

	// 安全校验：容器与其试剂持有者必须有效。
	if(QDELETED(container) || !container.reagents)
		to_chat(user, span_warning("这个容器无法承载嬗变之力。"))  // 容器失效兜底
		return

	// 邻近校验：容器需在伸手可及处。
	if(!user.Adjacent(container))
		to_chat(user, span_warning("我得先够到那个容器。"))
		return

	// 取出容器的试剂持有者，读取当前液体总量。
	var/datum/reagents/holder = container.reagents
	var/convert_amount = holder.total_volume                     // 当前容器内液体的总体积（将被整体转化）
	// 错误处理：容器里其实没有液体可转化（理论上前面已确保含水，这里再兜一层）。
	if(convert_amount <= 0)
		to_chat(user, span_warning("容器里没有可供嬗变的液体。"))
		return

	// 构建“可选药水目录”：显示名 -> 配方数据单例。
	var/list/catalog = get_potion_catalog()
	if(!length(catalog))                                         // 极端情况下没有任何配方可用
		to_chat(user, span_warning("我脑海中没有任何药水的配方。"))
		return

	// 弹出选择菜单，让玩家挑选想要嬗变成的药水。
	var/choice = tgui_input_list(user, "将容器中的净水嬗变为哪一种药水？", "贤者之石 · 百药嬗变", catalog)
	// 处理“取消 / 关闭菜单”：不消耗冷却，直接返回。
	if(isnull(choice))
		to_chat(user, span_notice("我收回了嬗变之力。"))
		return

	// 取出所选配方数据单例（可能是原版配方，也可能是精炼配方，二者类型不同）。
	var/datum/recipe = catalog[choice]
	// 依据实际类型取出该配方的“产出试剂表”，并（若为酒基精炼配方）算出应携带的酒劲。
	var/list/output_reagents = null                              // 产出试剂表 list(试剂路径 = 基准量)
	var/booze = 0                                                // 成品酒劲；仅酒基精炼药剂 > 0
	if(istype(recipe, /datum/alch_cauldron_recipe))              // 分支：原版炼药锅配方
		var/datum/alch_cauldron_recipe/vanilla = recipe
		output_reagents = vanilla.output_reagents
	else if(istype(recipe, /datum/alch_refining_formula))        // 分支：本模块精炼炼药锅配方
		var/datum/alch_refining_formula/refined = recipe
		output_reagents = refined.output_reagents
		booze = refined.get_boozepwr()                          // 酒基→按“酒底+技能”换算强度；非酒基→0
	// 二次校验：所选配方仍然有效且确实包含产出试剂。
	if(!recipe || !length(output_reagents))
		to_chat(user, span_warning("这个配方无法成形。"))
		return

	// 引导（短暂、可被打断，纯表现）。
	user.visible_message(
		span_notice("[user] 将贤者之石浸入 [container] 的液面，容器中的液体开始翻涌变色……"),  // 旁观者视角
		span_notice("我以贤者之石搅动净水，引导它嬗变为[choice]……")                          // 自身视角
	)
	if(!do_after(user, PHILO_TRANSMUTE_CHANNEL, target = user))    // 引导 1 秒
		to_chat(user, span_warning("嬗变被打断了。"))
		return

	// 引导后重新校验容器与液体（期间可能被喝掉 / 倒空 / 移出射程）。
	if(QDELETED(container) || !container.reagents || !user.Adjacent(container))
		to_chat(user, span_warning("嬗变完成前，容器离开了我的掌控。"))
		return
	// 以嬗变时刻的实际液体量为准，避免期间被人加/减液体导致数值错乱。
	convert_amount = min(holder.total_volume, holder.maximum_volume)
	if(convert_amount <= 0)
		to_chat(user, span_warning("容器已经空了，嬗变落空。"))
		return

	// 计算配方产出试剂的“比例总和”，用于把 convert_amount 按比例分摊给多种产出试剂。
	var/total_ratio = 0
	for(var/reagent_path in output_reagents)
		total_ratio += output_reagents[reagent_path]            // 累加每种产出试剂的配方基准量
	if(total_ratio <= 0)                                         // 防御除零：配方比例异常
		to_chat(user, span_warning("这个配方的比例失衡，无法嬗变。"))
		return

	// 先清空容器现有的一切液体（把“水”与其他杂质一并抹去）。
	holder.clear_reagents()
	// 再按比例注入所选药水的各产出试剂，总量恰好等于此前的液体体积。
	for(var/reagent_path in output_reagents)
		var/portion = convert_amount * (output_reagents[reagent_path] / total_ratio)  // 该试剂应占的体积
		if(portion <= 0)                                        // 跳过比例为 0 的项，避免加入无意义的 0 单位
			continue
		// 酒基精炼药剂需随试剂写入 boozepwr（存入 data，随装瓶/转移保留，喝下才会像喝酒一样上头）；
		// 其余药水（原版配方 / 非酒基精炼）直接注入即可。
		if(booze > 0)
			holder.add_reagent(reagent_path, portion, list("boozepwr" = booze))  // 携带酒劲注入
		else
			holder.add_reagent(reagent_path, portion)          // 普通注入

	// 启动 3 分钟冷却。
	potion_cd_end = world.time + PHILO_POTION_COOLDOWN

	// 表现层：成功反馈与音效。
	playsound(get_turf(container), 'sound/items/drink_gen (1).ogg', 60, TRUE)  // 借用倒液音效
	user.visible_message(
		span_notice("[container] 中的液体尽数化作了[choice]！"),   // 旁观者视角
		span_green("百药嬗变成功——容器里的净水已变成了[choice]。")  // 自身视角
	)

// ===========================================================================
// get_potion_catalog：构建并缓存“药水选择目录”。
// 收录两大来源的药水（均为主线/本模块现成数据，不新增任何配方）：
//   ① 原版炼药锅配方 /datum/alch_cauldron_recipe 的全部子类；
//   ② 本模块“精炼炼药锅”配方 /datum/alch_refining_formula 的全部子类
//      （由框架的 get_alch_refining_formulas() 提供已实例化的单例）。
// 以“配方名”为键放入静态列表；用 static 保证整局只构建一次。
// ===========================================================================
/obj/item/philosophers_stone/proc/get_potion_catalog()
	// static 局部变量：函数多次调用之间保持同一份缓存，只在首次构建。
	var/static/list/potion_catalog = null
	if(potion_catalog)                                           // 已构建过则直接返回缓存
		return potion_catalog

	potion_catalog = list()                                      // 首次调用：初始化空表

	// —— 来源①：原版炼药锅配方 —— //
	// subtypesof 会排除抽象基类 /datum/alch_cauldron_recipe 本身，只取具体药水配方。
	for(var/recipe_type in subtypesof(/datum/alch_cauldron_recipe))
		var/datum/alch_cauldron_recipe/recipe = new recipe_type() // 实例化配方数据（轻量数据单例）
		// 只收录“确实有产出试剂”的配方，跳过异常/空配方。
		if(!length(recipe.output_reagents))
			continue
		// 生成一个不重复的显示名：优先用配方自带 name，缺失则退回类型名。
		add_potion_entry(potion_catalog, recipe.name ? recipe.name : "[recipe_type]", recipe)

	// —— 来源②：本模块精炼炼药锅配方 —— //
	// 直接复用框架的惰性构建器：它返回所有 /datum/alch_refining_formula 子类的实例（含酒基/非酒基）。
	for(var/datum/alch_refining_formula/formula in get_alch_refining_formulas())
		// 同样只收录有液体产物的配方（纯固体产物配方无法“注入容器”，故跳过）。
		if(!length(formula.output_reagents))
			continue
		// 给精炼药剂的显示名加一个后缀标记，便于玩家区分它来自“精炼”体系。
		add_potion_entry(potion_catalog, "[formula.name ? formula.name : "[formula.type]"]（精炼）", formula)

	return potion_catalog

// ===========================================================================
// add_potion_entry：把一条药水记录写入目录，并在重名时追加序号后缀，
// 避免不同配方因同名而在关联列表里相互覆盖（vanilla 与精炼两套体系都会用到）。
// ===========================================================================
/obj/item/philosophers_stone/proc/add_potion_entry(list/catalog, label, datum/recipe)
	var/unique_label = label                                     // 起始显示名
	var/dedup = 1                                                // 重名计数器
	while(catalog[unique_label])                                 // 若该名已被占用
		dedup++                                                  // 序号自增
		unique_label = "[label] ([dedup])"                       // 生成 “名字 (2)” 之类的不重复键
	catalog[unique_label] = recipe                               // 记录：显示名 -> 配方/配方数据单例

// ===========================================================================
// 效果 3：凭空造物（冷却时间与所造物品价值正相关）
// 玩家输入关键词搜索物品，从“价值>1 且名称匹配”的候选中挑选一件并凭空造出。
// ===========================================================================
/obj/item/philosophers_stone/proc/create_item_from_nothing(mob/living/user)
	// 冷却校验：仍在冷却则拒绝并告知剩余时间。
	if(create_cd_end > world.time)
		var/secs_left = round((create_cd_end - world.time) / 10)  // 剩余秒数
		to_chat(user, span_warning("凭空造物之力尚未凝聚完成，还需 [secs_left] 秒。"))
		return

	// 让玩家输入搜索关键词（比如“sword / 剑 / gold”），以在海量物品中定位目标。
	var/search = tgui_input_text(user, "想凭空创造什么？输入名称关键词进行搜索：", "贤者之石 · 凭空造物")
	// 处理“取消 / 空输入”。
	if(isnull(search) || !length(trim(search)))
		to_chat(user, span_notice("我打消了造物的念头。"))
		return
	search = lowertext(trim(search))                             // 统一转小写并去空白，便于不区分大小写匹配

	// 取得（并在首次时构建）“类型 -> 小写名称”的可造物品索引。
	var/list/creatable = get_creatable_index()

	// —— 第一步：给每个“名称包含关键词”的候选打一个【相关度分数】 ——
	// 关联列表：物品类型 -> 相关度综合分（分越高越靠前）。
	// 综合分 = 相关度档位×1000 - 名称长度：
	//   · 相关度档位主导排序：完全相等(4) > 前缀命中(3) > 词首命中(2) > 任意子串命中(1)；
	//   · 同档位内再按“名称越短＝越贴近关键词”微调（减去名称长度），让最精准的结果浮到最前。
	var/list/scored = list()
	for(var/item_type as anything in creatable)
		var/iname = creatable[item_type]                         // 预先缓存好的小写名称
		if(!iname)
			continue
		var/pos = findtext(iname, search)                        // 关键词在名称中的首次出现位置（0 = 未命中）
		if(!pos)                                                 // 名称里没有关键词 → 与本次搜索无关，跳过
			continue
		// 判定相关度档位。
		var/rank
		if(iname == search)                                      // 名称与关键词完全相同 → 最相关
			rank = 4
		else if(pos == 1)                                        // 关键词位于名称开头 → 前缀命中
			rank = 3
		else if(copytext(iname, pos - 1, pos) == " ")            // 关键词紧跟在空格后 → 命中某个单词的词首
			rank = 2
		else                                                     // 仅出现在名称中间 → 普通子串命中
			rank = 1
		// 写入综合分：档位放大 1000 倍占主导，再减去名称长度做同档位内的“精准度”微调。
		scored[item_type] = rank * 1000 - length(iname)

	// 错误处理：没有任何匹配项。
	if(!length(scored))
		to_chat(user, span_warning("我无法在脑海中构想出名为“[search]”且值得创造之物。"))
		return

	// —— 第二步：按综合分【降序】排序，让最相关的排在最前 ——
	// sortTim + cmp_numeric_dsc + associative：对“类型 -> 分数”关联列表按分数从高到低重排其键顺序。
	sortTim(scored, cmp = /proc/cmp_numeric_dsc, associative = TRUE)

	// —— 第三步：取排名最靠前的若干项，构建“显示名 -> 物品类型”菜单（保持相关度顺序）——
	var/list/matches = list()
	var/shown = 0                                                // 已放入菜单的条目数
	for(var/obj/item/item_type as anything in scored)
		if(shown >= PHILO_CREATE_SEARCH_CAP)                     // 达到展示上限即停（此时保留的都是最相关的）
			break
		var/iname = initial(item_type.name)                      // 用原始大小写名称展示，更美观
		var/value = initial(item_type.sellprice)                 // 附带价值，帮助玩家判断冷却代价
		var/label = "[iname]（价值 [value]）"                     // 菜单显示文本
		// 不同物品可能同名同价，导致关联列表键相互覆盖：此处追加序号后缀确保键唯一。
		var/unique_label = label
		var/dedup = 1
		while(matches[unique_label])
			dedup++
			unique_label = "[label] #[dedup]"
		matches[unique_label] = item_type                        // 记录：显示名 -> 物品类型
		shown++

	// 弹出候选菜单让玩家最终选择（列表已按相关度排序，最贴近的在最上方）。
	var/choice = tgui_input_list(user, "选择要凭空创造的物品（冷却将随其价值增长）：", "贤者之石 · 凭空造物", matches)
	// 处理取消。
	if(isnull(choice))
		to_chat(user, span_notice("我在琳琅满目的可能性前犹豫，最终什么也没造。"))
		return

	// 取出所选物品类型并做最终校验。
	var/chosen_type = matches[choice]
	if(!ispath(chosen_type, /obj/item))                         // 理论不会发生，兜底防止异常路径
		to_chat(user, span_warning("这件造物的形态无法稳定成形。"))
		return

	// 再次读取其价值并强制执行“价值必须大于 1”的规则（双保险）。
	var/obj/item/final_sample = chosen_type
	var/final_value = initial(final_sample.sellprice)
	if(final_value <= PHILO_CREATE_MIN_VALUE)
		to_chat(user, span_warning("贤者之石不屑于创造如此廉价之物（价值须大于 [PHILO_CREATE_MIN_VALUE]）。"))
		return

	// 引导（短暂、可被打断，纯表现）。
	user.visible_message(
		span_notice("[user] 高举贤者之石，赤红晶石迸发出耀眼光华，空气中开始凝聚出某种形体……"),  // 旁观者视角
		span_notice("我引导贤者之石之力，将“[choice]”从虚无中具现……")                          // 自身视角
	)
	if(!do_after(user, PHILO_TRANSMUTE_CHANNEL, target = user))    // 引导 1 秒
		to_chat(user, span_warning("造物在成形前崩解了。"))
		return

	// 确定造物落点：优先用户所在地块。
	var/turf/spot = get_turf(user)
	if(!spot)                                                     // 极端兜底：用户不在任何地块
		to_chat(user, span_warning("脚下空无一物，造物无处具现。"))
		return

	// 真正“凭空造出”物品实例。
	var/obj/item/created = new chosen_type(spot)
	// 尝试直接塞进玩家手里；塞不下就留在脚下地块。
	user.put_in_hands(created)

	// 依据物品价值计算并启动冷却：冷却 = 价值 × 每点秒数，钳制在上下限内。
	var/cd = clamp(final_value * PHILO_CREATE_CD_PER_VALUE, PHILO_CREATE_CD_MIN, PHILO_CREATE_CD_MAX)
	create_cd_end = world.time + cd

	// 表现层：成功反馈与音效。
	playsound(spot, 'sound/magic/blink.ogg', 50, TRUE)          // 一道奥术具现音效
	user.visible_message(
		span_notice("一件[created]在光芒中凭空出现在了 [user] 手中！"),  // 旁观者视角
		span_green("凭空造物成功——[created]已然成形。（造物之力将休眠 [round(cd/10)] 秒）")  // 自身视角，附带冷却提示
	)

// ===========================================================================
// get_creatable_index：构建并缓存“价值>1 的可造物品”索引。
// 返回一个【关联列表】：物品类型路径 -> 该类型名称的小写形式。
// 之所以把“小写名称”一并缓存进去，是因为搜索时要对每个候选做不区分大小写的匹配；
// 预先算好可避免每次搜索都对上千个物品重复 initial(name)+lowertext，显著降低开销。
// 扫描 /obj/item 全部子类，只保留 initial(sellprice) 严格大于门槛者。全局缓存，整局只扫一次。
// ===========================================================================
/obj/item/philosophers_stone/proc/get_creatable_index()
	// 若全局缓存已构建，直接复用（关联列表非空即视为已构建）。
	if(length(GLOB.philo_creatable_item_types))
		return GLOB.philo_creatable_item_types

	// 首次构建：遍历所有物品子类。
	for(var/obj/item/item_type as anything in subtypesof(/obj/item))
		// 禁止贤者之石自我复制：跳过它自身及其任何子类型，杜绝“造石生石”的滚雪球作弊。
		if(ispath(item_type, /obj/item/philosophers_stone))
			continue
		// initial(item_type.sellprice) 取得该类型编译期默认价值，不实例化、开销低。
		if(initial(item_type.sellprice) <= PHILO_CREATE_MIN_VALUE)
			continue                                              // 价值不达标者不收录
		var/iname = initial(item_type.name)                       // 该类型默认名称
		if(!iname)                                                // 跳过没有名称的异常类型（无法搜索/展示）
			continue
		// 记录“类型 -> 小写名称”，供搜索时快速匹配。
		GLOB.philo_creatable_item_types[item_type] = lowertext(iname)
	return GLOB.philo_creatable_item_types

// ###########################################################################
// 合成配方：在【精炼炼药锅】中炼成贤者之石
// ---------------------------------------------------------------------------
// 需求（全部投入精炼炼药锅 /obj/machinery/light/rogue/cauldron/refining）：
//   · 液体：原版炼药锅可炼的【每一种药水】各 10 单位 + 精炼炼药锅可炼的【每一种药水】各 10 单位；
//   · 固体：每一种【宝石】各一颗 + 一颗【虚空石】(作为合成触发标志)；
//   · 门槛：炼制者的炼金技能须达到【传奇(6 级)】，方能成功。
//
// 实现要点（本模块内、不改动模块外文件）：
//   1) 精炼锅本只接受 /obj/item/alch 气味材料作固体投料(且上限 4 格)——这里【覆盖其 attackby】，
//      额外允许把【宝石】与【虚空石】放进去(不占用常规 4 格上限，因本配方需十余种宝石)。
//   2) 精炼锅 process() 已在框架里挂好钩子(见 refining_framework.dm)：每次沸腾结算先调用本文件的
//      try_philosophers_stone_synthesis()。只有锅里【有虚空石】时它才接管结算；校验齐全 → 炼成贤者之石。
//   3) “每种药水”不写死：运行时从 subtypesof(/datum/alch_cauldron_recipe) 与 get_alch_refining_formulas()
//      动态汇总它们的产出试剂，未来新增任何药水都会自动纳入配方需求。
// ###########################################################################

// ===========================================================================
// attackby 覆盖：让精炼炼药锅额外接受【宝石】与【虚空石】作为合成材料。
// 其余物品（含原版 /obj/item/alch 气味材料、倒入液体的容器等）一律交回父类原逻辑处理。
// ===========================================================================
/obj/machinery/light/rogue/cauldron/refining/attackby(obj/item/I, mob/user, params)
	// 只特殊处理“宝石 / 虚空石”这两类合成专用固体材料。
	if(istype(I, /obj/item/roguegem) || istype(I, /obj/item/magic/voidstone))
		// 禁止同类型重复投入：对应“每种宝石各一颗”，也避免重复占位。
		if(!isnull(locate(I.type) in ingredients))
			to_chat(user, span_warning("[src]里已经有一份[I]了！"))
			return FALSE
		// 把材料从玩家手上转移进锅内（失败通常是被别的东西粘住/无法移动）。
		if(!user.transferItemToLoc(I, src))
			to_chat(user, span_warning("[I]粘在我手上了！"))
			return FALSE
		// 成功放入：登记进 ingredients（★刻意不检查 maxingredients★，因本配方需要十余种宝石，远超常规 4 格）。
		to_chat(user, span_info("我把[I]作为合成材料放入了[src]。"))
		ingredients += I                                          // 记录该固体材料
		brewing = 0                                              // 投料会重置沸腾进度（与原版投料行为一致）
		lastuser = user                                         // 记录最后操作者（结算时用于技能判定/给经验）
		playsound(src, "bubbles", 100, TRUE)                    // 投料音效
		return TRUE
	// 非合成材料：走精炼锅继承来的原版投料/倒液逻辑。
	return ..()

// ===========================================================================
// try_philosophers_stone_synthesis：贤者之石的“终极合成”结算。
// 由精炼锅 process() 在每次沸腾结算时调用（见 refining_framework.dm 的钩子）。
// 返回值约定：
//   · 返回 TRUE  → 本锅是一次“贤者之石合成”，已由本 proc 独占结算（成功或给出失败原因），process() 应就此结束；
//   · 返回 FALSE → 锅内没有虚空石，不是本配方，process() 继续走常规精炼/回退逻辑。
// ===========================================================================
/obj/machinery/light/rogue/cauldron/refining/proc/try_philosophers_stone_synthesis(mob/living/user, amt2raise)
	// —— 触发判定：以【虚空石】为签名材料。没有虚空石 → 不是本配方，立即放行。——
	var/obj/item/magic/voidstone/void_core = locate(/obj/item/magic/voidstone) in ingredients
	if(!void_core)
		return FALSE                                            // 非贤者之石合成，交回常规逻辑

	// —— 自此本 proc 独占结算（无论成败都返回 TRUE，避免 process() 再输出“材料无法融合”之类的误导信息）——

	// 技能门槛：必须达到【传奇(6 级)】炼金。
	if(!user || user.get_skill_level(/datum/skill/craft/alchemy) < SKILL_LEVEL_LEGENDARY)
		brewing = 0                                             // 结算失败，复位沸腾进度（材料/液体不消耗，可再尝试）
		visible_message(span_warning("锅中的伟力剧烈翻涌，却因炼金造诣不足而无法凝聚成形——唯有传奇级(6 级)的炼金宗师方能点化贤者之石。"))
		return TRUE

	// 固体校验：每一种要求的宝石都必须在锅内各有一颗。
	for(var/gem_type in get_philo_required_gems())
		if(isnull(locate(gem_type) in ingredients))            // 缺哪种宝石就明确提示哪种
			var/obj/item/gem_sample = gem_type                 // 仅用类型读取名称
			brewing = 0
			visible_message(span_warning("合成贤者之石还缺少一颗[initial(gem_sample.name)]。"))
			return TRUE

	// 液体校验：每一种要求的药水都必须在锅内达到至少 PHILO_SYNTH_POTION_AMOUNT 单位。
	for(var/reagent_path in get_philo_required_potions())
		if(!reagents.has_reagent(reagent_path, PHILO_SYNTH_POTION_AMOUNT))
			var/datum/reagent/reagent_sample = reagent_path    // 仅用类型读取名称
			brewing = 0
			visible_message(span_warning("合成贤者之石还缺少至少 [PHILO_SYNTH_POTION_AMOUNT] 单位的[initial(reagent_sample.name)]。"))
			return TRUE

	// —— 校验全部通过：消耗材料并炼成贤者之石 ——
	// 逐一扣除每种药水各 PHILO_SYNTH_POTION_AMOUNT 单位（多出的部分留在锅里，不强行清空）。
	for(var/reagent_path in get_philo_required_potions())
		reagents.remove_reagent(reagent_path, PHILO_SYNTH_POTION_AMOUNT)
	// 销毁全部固体材料（宝石 + 虚空石都熔入成品）。
	for(var/obj/item/ing in ingredients)
		qdel(ing)
	ingredients = list()                                        // 清空固体材料列表
	// 在锅子所在地块生成成品——贤者之石。
	new /obj/item/philosophers_stone(get_turf(src))

	// —— 反馈 / 统计 / 经验 / 音效 / 收尾 ——
	visible_message(span_notice("锅中万药归一，宝石尽数熔于虚空之力，一颗散发着赤红光华的贤者之石缓缓成形！"))
	record_featured_stat(FEATURED_STATS_ALCHEMISTS, user)      // 记入“炼金术士”特色统计
	record_round_statistic(STATS_POTIONS_BREWED)               // 记入本局炼药统计
	user?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)  // 给予炼金经验
	playsound(src, 'sound/misc/smelter_fin.ogg', 60, FALSE)    // 完成音效
	brewing = 21                                                // 标记为已完成（与框架其它成功路径一致）
	return TRUE

// ===========================================================================
// get_philo_required_potions：动态汇总“合成所需的全部药水试剂路径”。
// 来源①原版炼药锅配方 /datum/alch_cauldron_recipe 的全部产出试剂；
// 来源②精炼炼药锅配方 /datum/alch_refining_formula 的全部产出试剂。
// 用 static 缓存，整局只汇总一次；未来新增任何药水都会自动纳入需求（无需改本配方）。
// ===========================================================================
/obj/machinery/light/rogue/cauldron/refining/proc/get_philo_required_potions()
	var/static/list/required_potions = null
	if(required_potions)                                         // 已汇总则直接复用缓存
		return required_potions

	required_potions = list()
	// —— 来源①：原版炼药锅可炼的每一种药水 —— //
	for(var/recipe_type in subtypesof(/datum/alch_cauldron_recipe))
		var/datum/alch_cauldron_recipe/vanilla = new recipe_type()
		for(var/reagent_path in vanilla.output_reagents)
			if(ispath(reagent_path, /datum/reagent))            // 只收试剂产物（跳过物品产物）
				required_potions |= reagent_path                // |= 保证去重
	// —— 来源②：精炼炼药锅可炼的每一种药水 —— //
	for(var/datum/alch_refining_formula/refined in get_alch_refining_formulas())
		for(var/reagent_path in refined.output_reagents)
			if(ispath(reagent_path, /datum/reagent))
				required_potions |= reagent_path
	return required_potions

// ===========================================================================
// get_philo_required_gems：合成所需的“每一种宝石各一颗”清单。
// 采用显式清单（而非 subtypesof），以【排除】调试基类 /obj/item/roguegem 本体、随机宝石生成器
// /random，以及血钻/纳莱迪等稀有特殊宝石——只要求常见的成套彩宝，既贴合“每种宝石”又不至于强求 boss 掉落物。
// ===========================================================================
/obj/machinery/light/rogue/cauldron/refining/proc/get_philo_required_gems()
	var/static/list/required_gems = list(
		/obj/item/roguegem/green,		// 祖母绿
		/obj/item/roguegem/blue,		// 蓝宝石
		/obj/item/roguegem/yellow,		// 黄宝石
		/obj/item/roguegem/violet,		// 紫晶
		/obj/item/roguegem/ruby,		// 红宝石
		/obj/item/roguegem/diamond,		// 钻石
		/obj/item/roguegem/onyxa,		// 缟玛瑙
		/obj/item/roguegem/jade,		// 翡翠
		/obj/item/roguegem/oyster,		// 珍珠
		/obj/item/roguegem/coral,		// 珊瑚
		/obj/item/roguegem/turq,		// 绿松石
		/obj/item/roguegem/amber,		// 琥珀
		/obj/item/roguegem/opal,		// 蛋白石
		/obj/item/roguegem/chitin,		// 甲壳石
		/obj/item/roguegem/amethyst,	// 紫水晶
	)
	return required_gems

// ===== 清理顶部宏定义，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef PHILO_STONE_ICON
#undef PHILO_STONE_STATE
#undef PHILO_TRANSMUTE_CHANNEL
#undef PHILO_POTION_COOLDOWN
#undef PHILO_CREATE_MIN_VALUE
#undef PHILO_CREATE_CD_PER_VALUE
#undef PHILO_CREATE_CD_MIN
#undef PHILO_CREATE_CD_MAX
#undef PHILO_CREATE_SEARCH_CAP
#undef PHILO_SYNTH_POTION_AMOUNT
