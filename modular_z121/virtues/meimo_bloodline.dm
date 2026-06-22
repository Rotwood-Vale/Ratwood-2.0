// ============================================================================
// modular_z121/virtues/meimo_bloodline.dm
// 自定义美德（Custom Virtue）：魅魔血脉 / Meimo Bloodline
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   实现一个全新的、限女性身体的美德"魅魔血脉"。它的代价是【全属性 -6】，
//   换来的特性是【魅魔血脉（Charm Demon Bloodline）】：每到夜晚会进入发情状态，
//   每天仅有一次机会；当持有者与他人交合（在游戏内通过"吸取精气"动作表现）时，
//   可吸取对方精气 —— 自己随机一项属性 +2，对方获得最长 6 分钟的"肾虚"减益。
//
// 为什么所有逻辑都放在本文件内：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外
//   的任何文件。本文件通过"向已有类型追加 var/proc/子类型"的方式接入引擎，
//   不修改任何核心文件，因此完全满足约束。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承，不修改其源文件）：
//   - /datum/virtue                       美德基类（modular_azurepeak/_virtue.dm）
//   - /datum/component                    组件基类（用于挂载夜晚信号与生命周期管理）
//   - /datum/status_effect/debuff         减益状态效果基类（含 effectedstats 机制）
//   - COMSIG_MOB_NIGHTED                  入夜信号（code/controllers/subsystem/nightshift.dm）
//   - STATKEY_*                           七项属性键（code/__DEFINES/mobs.dm）
//   - change_stat / apply_status_effect   属性调整 / 施加状态效果（引擎过程）
//   - FEMALE                              BYOND 内置性别常量
//
// 加载：本文件需要在 modular_z121/_load.dm 中以 #include 引入（已在该文件追加）。
// ============================================================================


// ----------------------------------------------------------------------------
// 自定义特性键（Trait key）
// 为什么要定义：用一个唯一的特性标识来标记"持有魅魔血脉"的人，
//   方便其它系统（或本文件自身）通过 HAS_TRAIT 判断身份，也作为 ADD_TRAIT 的来源标签。
// 为什么用字符串：引擎的特性系统以字符串作为键，与现有 modular_z121/admin/god.dm
//   中 `#define TRAIT_ADMIN_GOD "God"` 的写法保持一致。
// ----------------------------------------------------------------------------
#define TRAIT_CHARM_DEMON_BLOODLINE "charm_demon_bloodline"


// ----------------------------------------------------------------------------
// 向 /mob/living/carbon/human 追加运行时状态变量
// 为什么把状态存在 mob 上而不是组件里：发情/每日机会是"角色身上的状态"，
//   存在 mob 上便于 verb（动词必须是 mob 的过程）直接读写，也避免 verb 反复
//   去 GetComponent 取状态。组件只负责"挂信号 + 生命周期"，状态由 mob 持有。
// 注意：在 modular 文件里给核心类型追加 var 是该项目惯用做法（属于"追加"而非
//   "修改"核心文件），不违反"只改 modular_z121"的约束。
// ----------------------------------------------------------------------------
/// 是否正处于发情状态（夜晚触发，吸取或天亮后清除）。TRUE 时才允许吸取精气。
/mob/living/carbon/human/var/charm_demon_in_estrus = FALSE
/// 当天是否已使用过吸取机会。每晚进入发情时重置为 FALSE，吸取成功后置 TRUE。
/mob/living/carbon/human/var/charm_demon_absorbed_today = FALSE


// ----------------------------------------------------------------------------
// 美德定义：魅魔血脉
// 为什么用 /datum/virtue/charm_demon/meimo_bloodline 这一层级：
//   父类型 /datum/virtue/charm_demon 不设 name（保持抽象），与引擎已有的
//   /datum/virtue/combat、/datum/virtue/utility 等无名父类做法一致 ——
//   美德菜单（vices_menu.dm）以 V.name 作为键/过滤条件，无名父类不会污染菜单。
// ----------------------------------------------------------------------------
/datum/virtue/charm_demon/meimo_bloodline
	name = "魅魔血脉"                                                          // 菜单中显示的美德名（Meimo Bloodline）。
	// 为什么这样写描述：向玩家说明"限女性身体 + 全属性 -6"的代价与发情吸精的回报。
	desc = "我的血脉中流淌着魅魔的力量。这具女性的躯体远比常人孱弱（全属性 -6），\
			但每当夜幕降临，我便会陷入发情，每日一次。若在此时与他人交合，\
			便能吸取对方的精气：自身随机一项属性 +2，而对方则会陷入'肾虚'长达六分钟。"
	// 为什么用 custom_text 补充机制说明：desc 偏角色口吻，这里写清楚硬性触发条件，
	//   方便玩家在选择界面就理解"夜晚发情、每日一次、需限女性身体"。
	custom_text = "限女性身体。代价为全属性 -6。每晚自动进入发情（每日一次机会），\
				发情期间可使用动词菜单中的'吸取精气'对相邻目标发动。"
	// 为什么用 added_stats 施加 -6：这是美德基类提供的标准属性接口，
	//   handle_stats() 会对七项属性逐一调用 change_stat()，而 change_stat 自带
	//   1~20 的下限保护，因此 -6 不会把属性压到非法负值。
	added_stats = list(
		STATKEY_STR = -6,                                                      // 力量 -6
		STATKEY_PER = -6,                                                      // 感知 -6
		STATKEY_INT = -6,                                                      // 智力 -6
		STATKEY_CON = -6,                                                      // 体质 -6
		STATKEY_WIL = -6,                                                      // 意志 -6
		STATKEY_SPD = -6,                                                      // 速度 -6
		STATKEY_LCK = -6,                                                      // 命运 -6（凑齐"全属性 -6"）
	)

// 为什么重写 apply_to_human：除了基类负责的属性扣减外，还要完成两件本美德特有的事：
//   1) 校验"限女性身体" —— 非女性身体则不授予血脉能力（优雅降级，仍保留属性代价）。
//   2) 挂载魅魔血脉组件 —— 由组件负责入夜信号、发情逻辑与吸取动词的授予 / 回收。
/datum/virtue/charm_demon/meimo_bloodline/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()                                                                   // 先跑基类逻辑（目前为空实现，保留以兼容未来基类扩展）。

	// 为什么做空值校验：apply_virtue 理论上总会传入有效 mob，但防御式编程可避免
	//   因极端时序（角色在应用过程中被删除）导致的运行时报错。
	if(!istype(recipient))                                                     // 收件人无效 / 非人类 ……
		return                                                                 // …… 直接返回，避免后续空引用。

	// 为什么校验性别："Restricted female body"是本美德的硬性设定。
	//   非女性身体不应获得魅魔血脉的发情/吸精能力，但属性代价已由基类施加，
	//   因此这里只是"跳过能力授予"并明确告知玩家，属于优雅降级而非直接报错。
	if(recipient.gender != FEMALE)                                             // 若当前身体不是女性 ……
		to_chat(recipient, span_warning("魅魔血脉只在女性的躯体中觉醒——这具身体无法承载它的力量，\
										只留下了血脉带来的虚弱。"))                // …… 提示玩家能力未觉醒（仅保留 -6 代价）。
		return                                                                 // …… 不授予血脉能力。

	// 为什么挂组件而不是直接在这里 RegisterSignal：
	//   美德 datum 是"模板单例"（GLOB.virtues 里每种美德只有一个实例），
	//   不能用它的 src 去 RegisterSignal(recipient)（信号回调会指向错误的 datum）。
	//   组件实例与 recipient 一一绑定，能正确管理信号注册与（死亡 / qdel 时的）自动清理。
	recipient.AddComponent(/datum/component/charm_demon_bloodline)             // 绑定魅魔血脉组件，正式赋予能力。


// ----------------------------------------------------------------------------
// 魅魔血脉组件
// 为什么用组件：组件天然与宿主 mob 绑定，提供 Initialize / UnregisterFromParent /
//   Destroy 生命周期钩子，能干净地完成"注册入夜信号、授予动词、添加特性"以及在
//   宿主消失时"反注册信号、回收动词、移除特性"，避免状态残留与悬空信号。
// ----------------------------------------------------------------------------
/datum/component/charm_demon_bloodline

// 为什么重写 Initialize：组件创建时一次性完成三件事 ——
//   注册入夜信号、给宿主授予"吸取精气"动词、打上血脉特性标签。
/datum/component/charm_demon_bloodline/Initialize()
	. = ..()                                                                   // 调用基类初始化。

	// 为什么做类型校验：本组件依赖人类专属的 verb 与性别/属性机制，
	//   挂到非人类身上没有意义且会出错，返回 COMPONENT_INCOMPATIBLE 让引擎丢弃本组件。
	if(!ishuman(parent))                                                       // 宿主不是人类 ……
		return COMPONENT_INCOMPATIBLE                                          // …… 拒绝挂载，组件自动销毁。

	var/mob/living/carbon/human/host = parent                                  // 取得人类宿主引用，方便后续操作。

	// 为什么注册 COMSIG_MOB_NIGHTED：这是引擎在"入夜"时对每个人类 mob 发出的信号
	//   （nightshift.dm update_tod("night") 中 SEND_SIGNAL）。以此驱动"每晚发情"。
	RegisterSignal(host, COMSIG_MOB_NIGHTED, PROC_REF(on_nighted))             // 入夜 -> 进入发情。

	// 为什么用 verbs += 授予动词：与 modular_azurepeak 现有美德（如 combat_aware /
	//   night_vision）授予自定义动词的做法一致；动词随宿主存在，玩家可在菜单中调用。
	host.verbs += /mob/living/carbon/human/proc/charm_demon_absorb_energy      // 授予"吸取精气"动词。

	// 为什么打特性标签：标记此人拥有魅魔血脉，便于其它系统或调试用 HAS_TRAIT 识别。
	//   来源标签复用特性键本身，移除时一一对应。
	ADD_TRAIT(host, TRAIT_CHARM_DEMON_BLOODLINE, TRAIT_CHARM_DEMON_BLOODLINE)  // 标记血脉身份。

// 为什么重写 UnregisterFromParent：当组件与宿主解绑时，必须撤销 Initialize 里
//   施加的一切（信号、动词、特性），否则会留下悬空信号回调和无法使用的残留动词。
/datum/component/charm_demon_bloodline/UnregisterFromParent()
	if(ishuman(parent))                                                        // 仅当宿主仍是有效人类时才清理 ……
		var/mob/living/carbon/human/host = parent                              // 取得宿主引用。
		UnregisterSignal(host, COMSIG_MOB_NIGHTED)                             // 反注册入夜信号，防止悬空回调。
		host.verbs -= /mob/living/carbon/human/proc/charm_demon_absorb_energy  // 回收"吸取精气"动词。
		REMOVE_TRAIT(host, TRAIT_CHARM_DEMON_BLOODLINE, TRAIT_CHARM_DEMON_BLOODLINE) // 移除血脉特性标签。
		host.charm_demon_in_estrus = FALSE                                     // 清除发情状态，避免残留。
	return ..()                                                                // 交回基类完成解绑。

// 为什么实现入夜信号回调：每晚把宿主切入发情状态，并把"每日一次机会"重置为可用。
// 为什么标 SIGNAL_HANDLER：信号回调是同步调用的，绝不能 sleep；本过程只做赋值与
//   即时聊天/音效提示（均不阻塞），符合 SIGNAL_HANDLER 约束。
/datum/component/charm_demon_bloodline/proc/on_nighted(datum/source)
	SIGNAL_HANDLER                                                             // 声明本过程为非阻塞信号处理器。

	// 为什么再次类型校验：信号触发时宿主理论上一定有效，但防御式校验更稳妥。
	if(!ishuman(parent))                                                       // 宿主异常 ……
		return                                                                 // …… 不处理本次入夜。

	var/mob/living/carbon/human/host = parent                                  // 取得宿主引用。

	// 为什么死亡时不发情：对尸体施加发情状态既无意义也可能误导玩家，直接跳过。
	if(host.stat == DEAD)                                                       // 宿主已死亡 ……
		return                                                                 // …… 跳过本次发情。

	host.charm_demon_in_estrus = TRUE                                          // 进入发情：开放"吸取精气"动词。
	host.charm_demon_absorbed_today = FALSE                                    // 重置当日机会（每天一次）。

	// 为什么给出明显反馈：让玩家知道"现在可以吸取精气了"，否则机制对玩家不可见。
	to_chat(host, span_warning("夜幕降临，魅魔的血脉在体内躁动——我陷入了发情。\
								今夜，我可以从一名交合对象身上吸取精气。"))         // 提示发情已开始。


// ----------------------------------------------------------------------------
// 动词：吸取精气（Absorb Energy）
// 为什么做成动词：发情期间需要由玩家"主动选择目标并发动"，动词是最贴合的交互形式，
//   且可优雅地处理"目标选择 / 取消"。
// 流程：校验血脉与发情状态 -> 收集相邻可选目标 -> 让玩家选择（可取消）->
//        交合读条（可被打断）-> 结算（自身随机 +2，对方获得肾虚减益，消耗当日机会）。
// ----------------------------------------------------------------------------
/mob/living/carbon/human/proc/charm_demon_absorb_energy()
	set name = "吸取精气"                                                       // 动词在面板中显示的名称。
	set category = "魅魔"                                                       // 归入"魅魔"分类，便于玩家查找。
	set desc = "发情期间，与相邻的交合对象交合并吸取其精气。"                       // 动词悬浮说明。

	var/mob/living/carbon/human/user = src                                     // src 即发动者本人；显式命名增强可读性。

	// 为什么先校验血脉特性：动词可能因各种原因残留在不该有它的人身上（如管理员误操作），
	//   用特性做最终守门，确保只有真正的血脉持有者能发动。
	if(!HAS_TRAIT(user, TRAIT_CHARM_DEMON_BLOODLINE))                          // 没有魅魔血脉 ……
		to_chat(user, span_warning("我的体内并没有魅魔的血脉。"))                 // …… 明确拒绝。
		return                                                                 // …… 中止。

	// 为什么校验存活与意识：昏迷/死亡/被束缚时不应能发动交合吸精。
	if(user.stat != CONSCIOUS || user.incapacitated())                        // 非清醒或失能状态 ……
		to_chat(user, span_warning("我现在的状态无法做出这种事。"))              // …… 给出反馈。
		return                                                                 // …… 中止。

	// 为什么校验发情：核心设定是"每到夜晚陷入发情才可吸精"，非发情期一律拒绝。
	if(!user.charm_demon_in_estrus)                                            // 当前未发情 ……
		to_chat(user, span_warning("只有在夜晚陷入发情时，我才能吸取他人的精气。")) // …… 提示需等待夜晚。
		return                                                                 // …… 中止。

	// 为什么校验每日机会：设定为"每天一次机会"，已用过则当晚不可再次发动。
	if(user.charm_demon_absorbed_today)                                        // 今日机会已用尽 ……
		to_chat(user, span_warning("我今天已经吸取过一次精气，欲望暂时被填满了。")) // …… 提示明日再来。
		return                                                                 // …… 中止。

	// ---- 目标收集 ----
	// 为什么用 range(1, user) 收集相邻人类：交合是近身行为，目标必须紧邻发动者；
	//   用关联列表把"显示名"映射到具体 mob，方便弹窗只显示名字、选完反查 mob。
	var/list/candidates = list()                                               // 关联列表：显示名 -> 目标 mob。
	for(var/mob/living/carbon/human/possible_target in range(1, user))         // 遍历发动者周围 1 格内的人类。
		if(possible_target == user)                                            // 跳过自己（不能与自己交合吸精）。
			continue
		if(possible_target.stat == DEAD)                                       // 跳过尸体（无精气可吸）。
			continue
		// 为什么用 real_name 优先、附 ckey 去重：与本项目 bless.dm 的目标选择器一致，
		//   既显示角色名，又能在重名时消歧，避免覆盖丢失目标。
		var/display_name = possible_target.real_name ? possible_target.real_name : possible_target.name // 选取显示名。
		if(candidates[display_name])                                           // 已存在同名 ……
			display_name = "[display_name] ([possible_target])"                // …… 附加引用消歧。
		candidates[display_name] = possible_target                             // 登记 显示名 -> mob。

	// 为什么提前判断空列表：周围没有可吸取对象时直接给出反馈并退出，避免弹出空菜单。
	if(!length(candidates))                                                    // 周围没有合法目标 ……
		to_chat(user, span_warning("我身边没有可以交合的对象。"))                // …… 提示无目标。
		return                                                                 // …… 中止（不消耗机会）。

	// 为什么用 null|anything：让玩家可以直接关闭对话框取消（返回 null 即视为取消）。
	var/chosen_name = input(user, "选择交合并吸取精气的对象：", "吸取精气") as null|anything in sortList(candidates) // 弹出目标选择。
	if(!chosen_name)                                                           // 玩家取消 / 关闭窗口 ……
		return                                                                 // …… 优雅退出，不消耗机会。

	// 为什么再次校验目标：弹窗期间目标可能走开 / 登出 / 死亡 / 被删除，需重新确认有效性。
	var/mob/living/carbon/human/target = candidates[chosen_name]               // 把所选名字反查为 mob。
	if(!istype(target) || QDELETED(target))                                    // 目标已失效 ……
		to_chat(user, span_warning("那个对象已经不在了。"))                      // …… 报告失败。
		return                                                                 // …… 中止。
	if(!user.Adjacent(target))                                                  // 目标已不再相邻（走开了）……
		to_chat(user, span_warning("对方离我太远了，无法交合。"))                // …… 提示需贴近。
		return                                                                 // …… 中止。
	if(target.stat == DEAD)                                                     // 目标在选择过程中死亡 ……
		to_chat(user, span_warning("从尸体身上吸取不到任何精气。"))              // …… 拒绝。
		return                                                                 // …… 中止。

	// ---- 交合读条 ----
	// 为什么用 do_after：交合是需要持续时间的行为；读条期间任一方移动 / 被打断即失败，
	//   这同时充当"与他人发生性行为"这一底层系统的可替换钩子（stub/hook）。
	user.visible_message(span_warning("[user] 紧紧贴上了 [target]……"), \
						span_notice("我贴上 [target]，准备吸取对方的精气……"))     // 公开 + 自我提示，营造交互观感。
	if(!do_after(user, 10 SECONDS, target = target))                           // 10 秒读条，目标作为锚点，移动/打断即失败。
		to_chat(user, span_warning("交合被打断了，吸取失败。"))                  // 读条失败反馈。
		return                                                                 // 中止（不消耗机会，便于重试）。

	// 为什么读条后再次校验：长读条期间状态可能变化，结算前必须确认双方仍有效且相邻。
	if(QDELETED(target) || target.stat == DEAD || !user.Adjacent(target))      // 目标失效 / 死亡 / 走远 ……
		to_chat(user, span_warning("结合在最后一刻失败了，我没能吸到精气。"))    // …… 报告失败。
		return                                                                 // …… 中止（不消耗机会）。

	// ---- 结算：自身随机属性 +2 ----
	// 为什么用随机属性 +2：契合设定"随机一项属性 +2"。从七项属性键里随机抽一项，
	//   用 change_stat 永久加成（change_stat 自带 1~20 上限保护，超界不会出错）。
	var/static/list/stat_pool = list(                                          // 静态列表：可被随机加成的七项属性键（只建一次）。
		STATKEY_STR, STATKEY_PER, STATKEY_INT, STATKEY_CON,                     // 力量 / 感知 / 智力 / 体质
		STATKEY_WIL, STATKEY_SPD, STATKEY_LCK,                                  // 意志 / 速度 / 命运
	)
	var/picked_stat = pick(stat_pool)                                          // 随机抽取一项属性键。
	user.change_stat(picked_stat, 2)                                           // 该项属性永久 +2（精气滋养自身）。

	// ---- 结算：对方获得"肾虚"减益 ----
	// 为什么校验返回值：apply_status_effect 可能因引擎拒绝而返回 null；若失败需如实反馈，
	//   不能谎报"已使对方肾虚"。
	var/datum/status_effect/applied = target.apply_status_effect(/datum/status_effect/debuff/kidney_deficiency) // 施加肾虚（最长 6 分钟）。
	if(!applied && !target.has_status_effect(/datum/status_effect/debuff/kidney_deficiency)) // 施加失败且对方原本也无此效果 ……
		to_chat(user, span_warning("我吸到了精气，但对方似乎不受'肾虚'的影响。"))  // …… 如实告知减益未生效（但自身加成已结算）。

	// ---- 消耗当日机会并退出发情 ----
	// 为什么在成功结算后才置位：失败/取消路径都提前 return，不会误耗机会；
	//   成功后置 absorbed_today=TRUE（今日不可再吸）并清除发情（本次欲望已被满足）。
	user.charm_demon_absorbed_today = TRUE                                     // 标记今日机会已用。
	user.charm_demon_in_estrus = FALSE                                         // 退出发情状态。

	// 为什么给双方反馈：让发动者知道加成了哪项属性，让旁观/目标感知到事件发生。
	user.visible_message(span_warning("[user] 满足地从 [target] 身上退开。"), \
						span_notice("我吸取了 [target] 的精气，身体某处变得更强了。")) // 结算公开 + 自我提示。
	to_chat(target, span_danger("一阵难以言喻的虚脱感涌上全身——我感到肾气被抽空了。")) // 目标侧的肾虚提示。


// ----------------------------------------------------------------------------
// 减益状态效果：肾虚（Kidney Deficiency）
// 为什么做成 /datum/status_effect/debuff 子类：需求要求"对方获得一个名为'肾虚'、
//   最长 6 分钟的效果"。debuff 基类自带 effectedstats（开始施加、结束自动回收，
//   并有 1~20 越界保护），是实现限时属性惩罚最稳妥的方式。
// 命名说明：需求文本称其为 "buff"，但其实质是对被吸取者的负面效果，
//   故在引擎里归类为 debuff（更符合 effectedstats 为负值的语义与 HUD 表现）。
// ----------------------------------------------------------------------------
/datum/status_effect/debuff/kidney_deficiency
	id = "kidney_deficiency"                                                   // 唯一标识，用于 has_status_effect 查询。
	duration = 6 MINUTES                                                       // "最长 6 分钟"：到时自动消失。
	alert_type = /atom/movable/screen/alert/status_effect/debuff/kidney_deficiency // 关联 HUD 提示图标。
	needs_processing = FALSE                                                   // 纯属性减益，无需每 tick 处理，省开销。
	// 为什么减这几项：肾虚在设定上表现为体力 / 精力衰退，故削弱体质、力量、速度与意志，
	//   既贴合"被抽空精气"的观感，又是温和而明确的惩罚（不至于致死）。
	effectedstats = list(
		STATKEY_CON = -3,                                                      // 体质 -3（最直接的"虚弱"体现）。
		STATKEY_STR = -2,                                                      // 力量 -2。
		STATKEY_SPD = -2,                                                      // 速度 -2（行动迟缓）。
		STATKEY_WIL = -1,                                                      // 意志 -1（精神不济）。
	)

// 为什么单独定义 alert：让被影响者在 HUD 上看到一个图标与说明，知道自己处于肾虚减益中。
/atom/movable/screen/alert/status_effect/debuff/kidney_deficiency
	name = "肾虚"                                                              // HUD 悬浮标题（Kidney Deficiency）。
	desc = "我的精气被魅魔吸走了，浑身虚脱乏力，身手也大不如前。"                  // 悬浮说明：解释为什么属性下降。
	icon_state = "debuff"                                                       // 复用引擎已有的通用减益图标，避免新增美术资源依赖。
