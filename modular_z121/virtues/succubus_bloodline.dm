// ============================================================================
// modular_z121/virtues/succubus_bloodline.dm
// 自定义美德（Custom Virtue）：魅魔血脉 / Succubus Bloodline
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   重制"魅魔血脉"美德。它消耗 24 点凯旋点数，限女性身体，授予三项特性
//   （魅魔血脉 + 美貌 + 传奇情人）。核心玩法挂接到主线已有的"性/ERP"系统：
//   每当有人【射精进入魅魔体内（内射）】时，魅魔随机获得一种持续 12 分钟的
//   "餍足"效果（对应属性 +1）并获得随当前餍足数量递增的心情提升；对方则获得
//   持续 4 分钟的"魅魔之吻"（心情提升'与魅魔交合' + 力量-1、耐力-1）。
//   对方仍处于"魅魔之吻"期间再次内射，不会让魅魔餍足（吻=冷却）。
//   隐藏成长：被内射满 100 次，魅魔进化为"魅魔女王"，意志 +2、耐力 +2。
//
// 为什么所有逻辑都在本文件内：
//   硬性约束要求自定义内容只能放在 modular_z121 下，且不得改动该目录之外的文件。
//   本文件通过"向已有类型追加 var/proc/override/子类型"接入引擎——这属于"追加"
//   而非"修改核心文件"，符合约束。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承 / 覆写，不改其源文件）：
//   - /datum/virtue                         美德基类（modular_azurepeak/_virtue.dm）
//   - /datum/sex_controller/proc/cum_into() 内射结算过程（code/datums/sexcon/sexcon.dm）
//                                           —— 本文件覆写它以挂接"内射钩子"
//   - /datum/status_effect/buff             增益状态效果基类（REFRESH 型，含 effectedstats）
//   - /datum/stressevent                    心情/压力事件基类（stressadd<0 即心情提升）
//   - add_stress/get_stress_event/remove_stress/update_stress（code/modules/mob/living/carbon/stress.dm）
//   - TRAIT_BEAUTIFUL("美貌") / TRAIT_GOODLOVER("传奇情人")（code/__DEFINES/traits.dm）
//   - TRAIT_VIRTUE                          美德授予特性时的统一来源标签
//   - COMSIG_PARENT_EXAMINE                 检视信号（让玩家可在游戏内察觉此特性）
//   - STATKEY_*                             七项属性键（code/__DEFINES/mobs.dm）
//   - change_stat / apply_status_effect     属性调整 / 施加状态效果（引擎过程）
//   - FEMALE                                BYOND 内置性别常量
//
// 加载：本文件需在 modular_z121/_load.dm 中以 #include 引入（已替换旧的 meimo 行）。
// ============================================================================


// ----------------------------------------------------------------------------
// 自定义特性键（Trait keys）
// 为什么定义：用唯一字符串标识"魅魔血脉"与"魅魔女王"身份，供 HAS_TRAIT 判断、
//   检视显示、内射钩子的守门等使用。与 modular_z121/admin/god.dm 里
//   `#define TRAIT_ADMIN_GOD "God"` 的写法保持一致。
// 为什么特性值直接用可读中文名（而非英文 slug）：引擎的玩家"特性自检面板"
//   （screen_objects.dm 遍历 GLOB.roguetraits）会把"特性字符串本身"当作标题显示
//   （如 TRAIT_NOPAIN 的值"无痛"）。把它们登记进 roguetraits 后（见文件末尾
//   register_succubus_bloodline_trait），玩家点开特性列表就能看到体面的中文名。
//   两个串已确认在全项目内未被占用，不会造成 HAS_TRAIT 歧义。
// ----------------------------------------------------------------------------
#define TRAIT_SUCCUBUS_BLOODLINE "魅魔血脉"                                    // 魅魔血脉：核心身份特性（同时作为面板显示名）。
#define TRAIT_SUCCUBUS_QUEEN "魅魔女王"                                        // 魅魔女王：内射满 100 次后的进化身份（同时作为面板显示名）。

// 为什么定义这个常量：把"进化为女王所需的内射次数"集中成一个可读的命名常量，
//   既避免魔法数字散落各处，也便于日后平衡调整。
#define SUCCUBUS_QUEEN_THRESHOLD 100                                           // 进化为魅魔女王所需的累计内射次数。


// ----------------------------------------------------------------------------
// 向 /mob/living/carbon/human 追加运行时状态变量
// 为什么把状态存在 mob 上：内射计数与"是否已是女王"是角色自身的持久状态，
//   存在 mob 上便于覆写的 cum_into 钩子与人物过程直接读写，且随 mob 生命周期存续。
//   在 modular 文件里给核心类型追加 var 属于"追加"，不违反"只改 modular_z121"。
// ----------------------------------------------------------------------------
/// 累计被内射次数。每次合法内射 +1，达到阈值触发女王进化。
/mob/living/carbon/human/var/succubus_internal_count = 0
/// 是否已进化为魅魔女王。用于保证进化奖励只发放一次（幂等守卫）。
/mob/living/carbon/human/var/succubus_is_queen = FALSE


// ----------------------------------------------------------------------------
// 美德定义：魅魔血脉
// 为什么用 /datum/virtue/succubus/bloodline 层级：父类型 /datum/virtue/succubus
//   不设 name（保持抽象），与引擎已有的 /datum/virtue/combat 等无名父类一致——
//   美德菜单以 V.name 为键/过滤条件，无名父类不会污染菜单。
// ----------------------------------------------------------------------------
/datum/virtue/succubus/bloodline
	name = "魅魔血脉"                                                          // 菜单中显示的美德名（Succubus Bloodline）。
	// 为什么这样写描述：用角色口吻交代"女体 + 为情欲而生"的设定基调。
	desc = "我体内觉醒了魅魔的血脉。这具妖娆的女体生来便为情欲而生——当他人在我体内泄出精气，\
			我便能将其化作滋养自身的餍足，而对方则会沉沦于魅魔之吻，久久难以自拔。"
	// 为什么用 custom_text 写清机制：desc 偏氛围，这里把硬性触发与数值讲明白，
	//   方便玩家在选择界面就完全理解代价与回报。
	custom_text = "限女性身体，消耗 24 点凯旋点数。获得特性：魅魔血脉、美貌、传奇情人。\n\
				每当有人射精进入你体内（内射）：你随机获得一种持续 12 分钟的'餍足'（对应属性 +1），\n\
				并获得心情提升——同时拥有的餍足越多，心情提升越大；\n\
				对方则获得持续 4 分钟的'魅魔之吻'（心情提升'与魅魔交合'，力量 -1、耐力 -1）。\n\
				对方仍处于'魅魔之吻'期间再次内射，不会让你餍足。\n\
				隐藏：被内射满 100 次，你将进化为魅魔女王（意志 +2、耐力 +2）。"
	// 为什么消耗 24 点：按需求设定；基类 New() 会自动把"消耗 24 凯旋"追加进 desc。
	triumph_cost = 24
	// 为什么 added_traits 留空：本美德的三项特性需要"仅在女性身体上授予"，
	//   而 handle_traits 通道无法按性别区分（且 virtue datum 是全局单例，
	//   不能安全地按收件人改写它的 added_traits）。故改在 apply_to_human 里
	//   按性别手动 ADD_TRAIT，确保非女性身体不会获得这些特性。
	added_traits = list()

// 为什么重写 apply_to_human：完成两件本美德特有的事——
//   1) 校验"限女性身体"，仅女性身体才授予特性与挂接检视组件（优雅降级）。
//   2) 授予三项特性并挂上检视组件（让该血脉可被玩家在游戏内察觉）。
/datum/virtue/succubus/bloodline/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()                                                                   // 先跑基类逻辑（保留以兼容未来扩展）。

	// 为什么做空值/类型校验：防御极端时序（角色在应用过程中被删除等）导致的空引用。
	if(!istype(recipient))                                                     // 收件人无效 / 非人类 ……
		return                                                                 // …… 直接返回。

	// 为什么校验性别：需求明确"必须为女性身体"。非女性身体不授予任何魅魔特性，
	//   仅给出提示——属于优雅降级，而非报错中断。
	if(recipient.gender != FEMALE)                                             // 当前身体不是女性 ……
		to_chat(recipient, span_warning("魅魔的血脉只在女性的躯体中觉醒——这具身体无法承载它的力量。")) // …… 告知未觉醒。
		return                                                                 // …… 不授予特性、不挂组件。

	// 为什么手动 ADD_TRAIT 而非 added_traits 通道：见上方 added_traits 注释。
	//   来源统一用 TRAIT_VIRTUE，便于与其它美德授予的特性统一管理/清除。
	ADD_TRAIT(recipient, TRAIT_SUCCUBUS_BLOODLINE, TRAIT_VIRTUE)               // 魅魔血脉：核心身份 + 内射钩子守门。
	ADD_TRAIT(recipient, TRAIT_BEAUTIFUL, TRAIT_VIRTUE)                        // 美貌（Beauty）：引擎已有的魅力特性。
	ADD_TRAIT(recipient, TRAIT_GOODLOVER, TRAIT_VIRTUE)                        // 传奇情人（Legendary Lover）：引擎已有的床笫特性。

	// 为什么挂组件：检视检测需要在 recipient 上注册 COMSIG_PARENT_EXAMINE 信号，
	//   而美德 datum 是全局单例不能用于 RegisterSignal(recipient)。组件实例与
	//   recipient 一一绑定，能正确管理信号注册并在 mob 消失时自动清理。
	recipient.AddComponent(/datum/component/succubus_bloodline)               // 绑定检视组件，使血脉可被察觉。


// ----------------------------------------------------------------------------
// 魅魔血脉组件（仅负责"检视可察觉"）
// 为什么用组件：组件与宿主 mob 绑定，提供 Initialize/UnregisterFromParent 生命周期，
//   能干净地注册/反注册检视信号，避免悬空回调。
// 注：核心的"内射触发"不依赖本组件，而是通过覆写 cum_into 全局实现（见文件后半段）。
// ----------------------------------------------------------------------------
/datum/component/succubus_bloodline

// 为什么重写 Initialize：组件创建时注册检视信号，使他人检视该角色时能看到血脉提示。
/datum/component/succubus_bloodline/Initialize()
	. = ..()                                                                   // 调用基类初始化。
	// 为什么类型校验：检视提示与人物语境绑定，挂到非人类上无意义，丢弃组件。
	if(!ishuman(parent))                                                       // 宿主不是人类 ……
		return COMPONENT_INCOMPATIBLE                                          // …… 拒绝挂载，组件自动销毁。
	// 为什么注册 COMSIG_PARENT_EXAMINE：这是引擎在 atom/examine() 末尾发出的检视信号，
	//   携带 (检视者 user, 检视文本列表 .)；据此向检视文本追加一行血脉提示。
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))        // 检视 -> 追加血脉提示。

// 为什么重写 UnregisterFromParent：解绑时撤销注册，避免悬空信号回调。
/datum/component/succubus_bloodline/UnregisterFromParent()
	if(parent)                                                                 // 宿主仍存在 ……
		UnregisterSignal(parent, COMSIG_PARENT_EXAMINE)                       // …… 反注册检视信号。
	return ..()                                                                // 交回基类完成解绑。

// 为什么实现检视回调：满足需求"这一特性应能被玩家在游戏内察觉"。
//   标 SIGNAL_HANDLER：检视信号同步触发，回调内只做拼接文本，不可 sleep。
/datum/component/succubus_bloodline/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER                                                             // 声明为非阻塞信号处理器。
	if(!ishuman(parent))                                                       // 防御：宿主异常则不追加。
		return
	var/mob/living/carbon/human/host = parent                                  // 取得宿主引用。
	// 为什么这样写：给出明确可读的提示，让检视者得知对方拥有魅魔血脉/已是女王。
	if(HAS_TRAIT(host, TRAIT_SUCCUBUS_QUEEN))                                  // 已进化为女王 ……
		examine_list += span_boldwarning("此身散发着令人战栗的强大魅魔气息——这是一位魅魔女王。") // …… 显示女王提示。
	else                                                                       // 普通魅魔血脉 ……
		examine_list += span_warning("此身隐隐流淌着蛊惑人心的魅魔血脉。")        // …… 显示血脉提示。


// ----------------------------------------------------------------------------
// 内射钩子：覆写 /datum/sex_controller/cum_into()
// 为什么覆写这个过程：cum_into 是主线"射精进入体内（内射）"的结算入口
//   （由 ejaculate() 调用）。此处 src 是射精方的性控制器：
//     - src.user                 = 射精者（the giver）
//     - splashed_user || target  = 接受方（被内射者）
//   覆写它能同时、可靠地拿到双方，并且精确对应"内射"语义（区别于 cum_onto 体外）。
// 关键安全做法（为什么先 ..()）：先执行原版内射逻辑，确保即便本钩子后续出错，
//   也不会破坏引擎原有的性结算流程；本钩子的附加逻辑全部包在防御式判断里。
// ----------------------------------------------------------------------------
/datum/sex_controller/cum_into(oral = FALSE, mob/living/carbon/human/splashed_user = null, datum/sex_action/knot_action = null, knot_swap_roles = FALSE, mob/living/carbon/human/knot_btm = null, orifice = SEX_PART_NULL, skip_knot_try = FALSE, consume_charge = TRUE)
	. = ..()                                                                   // 先执行原版内射结算，绝不破坏既有行为。

	// 为什么取 splashed_user||target：与原版 effective_target 取法一致，
	//   即"真正被内射的那一方"。
	var/mob/living/carbon/human/receiver = splashed_user || target            // 接受方（可能是魅魔）。
	var/mob/living/carbon/human/giver = user                                   // 射精方（本性控制器的拥有者）。

	// 为什么层层守门：
	//   - 双方都必须是有效人类；
	//   - 不能是自我射精（贞操溢出等，user==receiver）；
	//   - 接受方必须真的拥有魅魔血脉。
	//   任一不满足则不触发，避免误判与空引用。
	if(!istype(receiver) || !istype(giver))                                   // 任一方无效 ……
		return                                                                 // …… 不触发。
	if(receiver == giver)                                                      // 自我射精 ……
		return                                                                 // …… 不触发。
	if(!HAS_TRAIT(receiver, TRAIT_SUCCUBUS_BLOODLINE))                        // 接受方不是魅魔 ……
		return                                                                 // …… 不触发。

	// 为什么委托给人物过程：把魅魔侧的全部结算逻辑收敛到一个人物过程里，
	//   让覆写体保持极小、清晰，也便于单独测试/维护。
	receiver.succubus_on_internal_ejaculation(giver)                          // 交由魅魔本体处理餍足/魅魔之吻/进化。


// ----------------------------------------------------------------------------
// 魅魔内射结算主过程
// 为什么单独成过程：集中处理"计数与进化 / 冷却判定 / 施加魅魔之吻 / 发放餍足"，
//   逻辑清晰、错误处理集中。
// 参数 giver：本次射精进入魅魔体内的人。
// ----------------------------------------------------------------------------
/mob/living/carbon/human/proc/succubus_on_internal_ejaculation(mob/living/carbon/human/giver)
	// 为什么再次守门：本过程也可能被其它路径调用，保证只有真正的魅魔 + 有效 giver 才结算。
	if(!HAS_TRAIT(src, TRAIT_SUCCUBUS_BLOODLINE))                             // 自身不是魅魔 ……
		return                                                                 // …… 中止。
	if(!istype(giver) || giver == src)                                        // giver 无效或为自身 ……
		return                                                                 // …… 中止。

	// ---- 计数与进化（隐藏成长）----
	// 为什么每次内射都计数：需求是"被内射满 100 次"进化，属于纯物理累计，
	//   不受"魅魔之吻"冷却影响。
	succubus_internal_count++                                                 // 累计内射次数 +1。
	try_succubus_queen_evolution()                                           // 检查是否达到女王进化阈值。

	// ---- 冷却判定 ----
	// 为什么检查 giver 是否已带"魅魔之吻"：需求规定——对方仍处于此状态时再次内射，
	//   魅魔不会餍足。"魅魔之吻"即充当对该 giver 的冷却。
	if(giver.has_status_effect(/datum/status_effect/buff/succubus_bite))      // giver 仍在魅魔之吻状态 ……
		// 为什么仍给一点反馈：让玩家明白"这次没有获得餍足"，避免机制不可见。
		to_chat(src, span_notice("对方仍未从上一次的魅魔之吻中回过神来，这次我并未感到餍足。")) // …… 仅提示，不发放餍足。
		return                                                                 // …… 不施加魅魔之吻、不发放餍足。

	// ---- 给对方施加"魅魔之吻"（4 分钟）----
	// 为什么校验返回值：apply_status_effect 可能被引擎拒绝（返回 null）；
	//   失败时不应谎报，但魅魔侧仍可正常餍足，故此处仅记录失败提示。
	var/datum/status_effect/bite = giver.apply_status_effect(/datum/status_effect/buff/succubus_bite) // 施加魅魔之吻。
	if(!bite && !giver.has_status_effect(/datum/status_effect/buff/succubus_bite)) // 施加失败且对方原本也无此效果 ……
		to_chat(src, span_warning("我的魅魔之吻没能在对方身上生效。"))             // …… 如实提示（不影响下面的餍足结算）。

	// ---- 发放随机"餍足"（12 分钟）并结算心情 ----
	grant_random_succubus_satisfaction()                                      // 随机餍足 + 按当前餍足数量给心情。


// ----------------------------------------------------------------------------
// 女王进化判定
// 为什么用幂等守卫 succubus_is_queen：进化奖励（意志+2、耐力+2）只能发放一次，
//   否则反复内射会无限叠加属性。
// ----------------------------------------------------------------------------
/mob/living/carbon/human/proc/try_succubus_queen_evolution()
	if(succubus_is_queen)                                                     // 已是女王 ……
		return                                                                 // …… 不重复进化。
	if(succubus_internal_count < SUCCUBUS_QUEEN_THRESHOLD)                    // 还没达到 100 次 ……
		return                                                                 // …… 暂不进化。

	succubus_is_queen = TRUE                                                  // 先置位，防止并发/重入重复发奖。
	// 为什么打女王特性：标记进化身份，供检视显示与其它系统识别。
	ADD_TRAIT(src, TRAIT_SUCCUBUS_QUEEN, TRAIT_GENERIC)                       // 授予魅魔女王特性。
	// 为什么用 change_stat 永久加成：进化奖励是永久属性提升；change_stat 自带 1~20 越界保护。
	change_stat(STATKEY_WIL, 2)                                              // 意志 +2。
	change_stat(STATKEY_CON, 2)                                             // 耐力（体质）+2。
	// 为什么给强反馈：这是隐藏的重大成长节点，应让玩家清楚感知到自己进化了。
	to_chat(src, span_boldwarning("无数精气在体内汇聚、沸腾——我的血脉彻底觉醒，进化成了魅魔女王！意志与耐力都因此攀升。")) // 进化提示。


// ----------------------------------------------------------------------------
// 发放随机"餍足"并结算心情
// 为什么集中处理：餍足的"随机选择 + 施加 + 心情按数量递增"是一组紧密相关的逻辑。
// ----------------------------------------------------------------------------
/mob/living/carbon/human/proc/grant_random_succubus_satisfaction()
	// 为什么用静态列表：六种餍足的类型路径固定不变，static 只构建一次，省开销。
	var/static/list/satisfaction_types = list(
		/datum/status_effect/buff/succubus_satisfaction/strength,             // 力量的餍足 -> 力量 +1
		/datum/status_effect/buff/succubus_satisfaction/constitution,         // 耐力的餍足 -> 体质 +1
		/datum/status_effect/buff/succubus_satisfaction/agility,              // 敏捷的餍足 -> 速度 +1
		/datum/status_effect/buff/succubus_satisfaction/perception,           // 感知的餍足 -> 感知 +1
		/datum/status_effect/buff/succubus_satisfaction/wisdom,               // 智慧的餍足 -> 智力 +1
		/datum/status_effect/buff/succubus_satisfaction/will,                 // 意志的餍足 -> 意志 +1
	)

	// 为什么随机抽取：需求是"随机获得一种餍足"。若抽到的已存在，REFRESH 型会刷新时长，
	//   不会重复叠加属性（effectedstats 每个实例只施加一次）。
	var/picked_type = pick(satisfaction_types)                               // 随机抽一种餍足。
	var/datum/status_effect/satisfaction = apply_status_effect(picked_type)  // 施加该餍足（12 分钟）。
	// 为什么校验：若施加失败（且原本也没有该效果），如实提示并停止心情结算，避免谎报。
	if(!satisfaction && !has_status_effect(picked_type))                     // 餍足施加失败 ……
		to_chat(src, span_warning("一阵餍足的暖流涌起又骤然消散——这次的精气未能化作力量。")) // …… 提示失败。
		return                                                                 // …… 不结算心情。

	// ---- 心情结算：按当前"餍足种类数量"递增 ----
	// 为什么统计当前餍足数量：需求规定"同时拥有的餍足越多，心情提升越大"。
	//   遍历六种餍足，数出此刻仍激活的种类数 n（含刚施加的这一种）。
	var/satisfaction_count = 0                                                // 当前激活的餍足种类数。
	for(var/sat_type in satisfaction_types)                                  // 逐一检查六种餍足 ……
		if(has_status_effect(sat_type))                                      // …… 若该种正激活 ……
			satisfaction_count++                                            // …… 计数 +1。

	// 为什么这样给心情：用同一个心情事件的"层数（stacks）"来表达强度——
	//   层数越多，事件的负向 stressadd 越大（越爽）。需求"没有餍足时也给一次心情提升"
	//   自然被覆盖：此刻至少有 1 种餍足（刚施加的），故 satisfaction_count>=1，必给心情。
	add_stress(/datum/stressevent/succubus_satisfaction)                     // 确保心情事件存在（首次创建即 1 层）。
	var/datum/stressevent/mood = get_stress_event(/datum/stressevent/succubus_satisfaction) // 取回该心情事件实例。
	if(mood)                                                                  // 取到实例（理应总能取到）……
		// 为什么直接设 stacks 而非反复 add：层数需精确等于"当前餍足种类数"，
		//   而 add_stress 每次只 +1。直接设值并刷新计时，才能让心情强度准确反映餍足数量。
		mood.stacks = clamp(satisfaction_count, 1, mood.max_stacks)          // 层数 = 当前餍足数量（夹在 1~上限）。
		mood.time_added = world.time                                         // 刷新计时，使心情与最新一次餍足同步延续。
	update_stress()                                                           // 立即重算心情，让数值/HUD 即时生效。

	// 为什么给正反馈：让玩家明确感知"我被餍足了"，并暗示心情随餍足数量增强。
	to_chat(src, span_green("精气化作一阵酥麻的餍足在体内流转，让我倍感愉悦。"))    // 餍足成功提示。


// ----------------------------------------------------------------------------
// 状态效果：餍足（Satisfaction）—— 基类 + 六个子类型
// 为什么用 /datum/status_effect/buff 子类：buff 基类是 REFRESH 型，自带
//   effectedstats（开始施加、结束自动回收，含 1~20 越界保护），是实现"限时属性 +1"
//   最稳妥的方式。重复施加只刷新时长，不会重复加属性。
// ----------------------------------------------------------------------------
/datum/status_effect/buff/succubus_satisfaction                               // 餍足基类（抽象，不直接施加）。
	duration = 12 MINUTES                                                      // 需求：每种餍足持续 12 分钟。
	alert_type = /atom/movable/screen/alert/status_effect/buff/succubus_satisfaction // 统一的 HUD 提示。

// 为什么单独定义 alert 基类：六种餍足共用一套 HUD 图标，子类只改名字即可。
/atom/movable/screen/alert/status_effect/buff/succubus_satisfaction
	name = "餍足"                                                              // HUD 悬浮标题。
	desc = "精气带来的餍足滋养着我的身体。"                                       // 悬浮说明。
	icon_state = "buff"                                                         // 复用引擎已有的通用增益图标，避免新增美术依赖。

// —— 六种具体餍足：各自对应一项属性 +1（用 id 区分，便于 has_status_effect 精确查询）——

/datum/status_effect/buff/succubus_satisfaction/strength                      // 力量的餍足。
	id = "succubus_sat_str"                                                    // 唯一 id。
	effectedstats = list(STATKEY_STR = 1)                                     // 力量 +1。

/datum/status_effect/buff/succubus_satisfaction/constitution                  // 耐力（体质）的餍足。
	id = "succubus_sat_con"
	effectedstats = list(STATKEY_CON = 1)                                     // 体质 +1。

/datum/status_effect/buff/succubus_satisfaction/agility                       // 敏捷（速度）的餍足。
	id = "succubus_sat_spd"
	effectedstats = list(STATKEY_SPD = 1)                                     // 速度 +1。

/datum/status_effect/buff/succubus_satisfaction/perception                    // 感知的餍足。
	id = "succubus_sat_per"
	effectedstats = list(STATKEY_PER = 1)                                     // 感知 +1。

/datum/status_effect/buff/succubus_satisfaction/wisdom                        // 智慧（智力）的餍足。
	id = "succubus_sat_int"
	effectedstats = list(STATKEY_INT = 1)                                     // 智力 +1。

/datum/status_effect/buff/succubus_satisfaction/will                          // 意志的餍足。
	id = "succubus_sat_wil"
	effectedstats = list(STATKEY_WIL = 1)                                     // 意志 +1。


// ----------------------------------------------------------------------------
// 状态效果：魅魔之吻（The Bite of Succubus）
// 为什么做成 buff 子类：需求称其为"buff"，且它附带一个正向心情 + 两项属性惩罚。
//   用 effectedstats 自动施加/回收 力量-1、耐力-1；在 on_apply/on_remove 里
//   挂/摘心情事件，表现"与魅魔交合"的愉悦。
// ----------------------------------------------------------------------------
/datum/status_effect/buff/succubus_bite
	id = "succubus_bite"                                                       // 唯一 id，用作冷却判定与查询。
	duration = 4 MINUTES                                                       // 需求：持续 4 分钟（同时充当冷却时长）。
	alert_type = /atom/movable/screen/alert/status_effect/buff/succubus_bite   // HUD 提示。
	// 为什么这两项惩罚：需求规定 力量 -1、耐力 -1，表现交合后的脱力。
	effectedstats = list(
		STATKEY_STR = -1,                                                     // 力量 -1。
		STATKEY_CON = -1,                                                     // 耐力（体质）-1。
	)

// 为什么重写 on_apply：在效果开始时追加正向心情"与魅魔交合"。
/datum/status_effect/buff/succubus_bite/on_apply()
	. = ..()                                                                   // 先跑基类（处理 effectedstats）。
	if(!.)                                                                     // 基类拒绝（无 owner 等）……
		return FALSE                                                           // …… 中止，让效果自删。
	owner.add_stress(/datum/stressevent/succubus_bite)                       // 追加"与魅魔交合"的心情提升。
	owner.update_stress()                                                      // 立即重算心情，使其即时生效。
	return TRUE                                                                // 保持效果。

// 为什么重写 on_remove：状态结束时撤销心情事件，避免心情污染残留。
/datum/status_effect/buff/succubus_bite/on_remove()
	. = ..()                                                                   // 先让基类回收 effectedstats。
	if(owner)                                                                  // owner 仍有效 ……
		owner.remove_stress(/datum/stressevent/succubus_bite)               // …… 移除心情事件。
		owner.update_stress()                                                  // …… 立即重算心情。

// 为什么单独定义 alert：让中招者在 HUD 看到"魅魔之吻"图标与说明。
/atom/movable/screen/alert/status_effect/buff/succubus_bite
	name = "魅魔之吻"                                                          // HUD 悬浮标题（The Bite of Succubus）。
	desc = "与魅魔交合的余韵令我神魂颠倒，却也抽走了我的力气。"                     // 悬浮说明：解释心情提升与脱力。
	icon_state = "drunk"                                                        // 复用引擎已有图标（沉醉感），避免新增美术依赖。


// ----------------------------------------------------------------------------
// 心情事件（Stress events）
// 为什么 stressadd 取负值：本系统里 stressadd < 0 代表"减压/心情提升"，
//   正是需求中的"mood boost / mood gain"。
// ----------------------------------------------------------------------------

// 餍足心情：随层数（= 当前餍足数量）递增。1 层基础提升，每多 1 层再加一档。
/datum/stressevent/succubus_satisfaction
	timer = 12 MINUTES                                                        // 与餍足时长一致，便于同步延续。
	stressadd = -2                                                            // 基础心情提升（1 种餍足时）。
	stressadd_per_extra_stack = -2                                            // 每多 1 种餍足，再 -2 压力（更爽）。
	max_stacks = 6                                                            // 最多 6 种餍足，对应六项属性。
	desc = span_green("魅魔的餍足：精气化作的愉悦在体内流转，餍足越多，我越是沉醉。") // 心情条目说明。

// 魅魔之吻心情：固定的正向心情"与魅魔交合"。
/datum/stressevent/succubus_bite
	timer = 4 MINUTES                                                         // 与"魅魔之吻"状态时长一致。
	stressadd = -4                                                            // 一次明显的心情提升。
	desc = span_green("与魅魔交合：那销魂的体验让我久久无法平静，心情大好。")        // 需求指定的心情名/说明。


// ----------------------------------------------------------------------------
// 让玩家在游戏内"看得见"这项特性：登记进 GLOB.roguetraits
// ----------------------------------------------------------------------------
// 为什么要登记：引擎的玩家特性自检面板（_onclick/hud/screen_objects.dm）会遍历
//   GLOB.roguetraits，对玩家"拥有的"每一个特性打印「特性名 - 描述」；职业/偏好界面
//   也据此展示特性说明。只有把魅魔血脉/魅魔女王加进这张全局表，玩家点开自己的特性
//   列表时才会看到它们的中文名与说明——这正满足需求"该特性应能被玩家在游戏内察觉"。
//   （检视组件 COMSIG_PARENT_EXAMINE 让"他人"看得见；roguetraits 让"本人"在面板看得见，二者互补。）
//
// 为什么用"运行时追加"而非直接改核心 GLOBAL_LIST_INIT(roguetraits)：
//   硬性约束只能改动 modular_z121；核心表 roguetraits 定义在 code/__DEFINES/traits.dm
//   （目录之外，禁止修改）。故改为在启动钩子里向这张已初始化的全局表追加键值对，
//   这正是本项目登记自定义内容的既定做法（参见 register_life_potential_trait）。
//
// 为什么做成独立 proc 由 custom_bootstrap 调用：
//   #define 按 #include 顺序生效，custom_bootstrap.dm 的包含顺序早于本文件，
//   无法在那里直接引用 TRAIT_SUCCUBUS_* 宏；而 proc 名是全局解析、跨文件可调用。
//   于是把"需要用到本文件宏"的登记逻辑封装在本文件的 proc 内，bootstrap 只按名调用，
//   既遵守宏可见性规则，又复用统一的启动时机（此刻 roguetraits 已完成初始化）。
/proc/register_succubus_bloodline_trait()
	// 防御：核心全局表必须已初始化为 list 才能写入；异常时安静跳过，绝不新建一张
	//   会与核心表脱钩的"假表"，以免登记到一个永远不会被面板读取的列表上。
	if(!islist(GLOB.roguetraits))
		return
	// 写入「特性键 -> 玩家自检描述」。描述用第一人称、span_info 样式，与表中其它条目
	//   （如 TRAIT_NOPAIN = span_info("我感觉不到痛楚。")）的风格保持一致。
	//   幂等：重复调用只是覆盖同一个键，不会产生重复项，二次启动也安全。
	GLOB.roguetraits[TRAIT_SUCCUBUS_BLOODLINE] = span_info("我体内流淌着魅魔的血脉：\
		每当有人在我体内泄出精气，我便能将其化作滋养自身的餍足（随机一项属性提升），并因此心情大好；\
		而对方则会沉沦于我的魅魔之吻。")
	// 为什么也登记女王特性：玩家进化后才会拥有它，面板只显示"已拥有"的特性，
	//   故提前登记不会提前剧透——只有真正进化为女王后，本人才会在面板看到这条。
	GLOB.roguetraits[TRAIT_SUCCUBUS_QUEEN] = span_info("我已是魅魔女王：\
		无尽精气的滋养让我的血脉彻底觉醒，意志与耐力都因此远超常人。")
