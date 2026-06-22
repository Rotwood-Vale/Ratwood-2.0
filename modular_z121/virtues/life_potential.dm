// ============================================================================
// modular_z121/virtues/life_potential.dm
// 自定义美德（Custom Virtue）：生命潜能 / Life Potential
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   实现一个全新的、仅限"血肉之躯"种族的美德"生命潜能"。它消耗 16 点凯旋点数
//   （triumph_cost = 16），授予被动特性【生命潜能】：
//     - 每当持有者进入"濒死状态"（InCritical：生命值跌破濒死阈值且陷入软/硬昏迷）时，
//       有 10% 概率触发为期 3 分钟的【濒死爆发】状态。
//     - 爆发开始瞬间：立即止住一切伤口的流血、并使当前外伤（钝/烧伤）即时恢复一半。
//     - 爆发期间：免疫疼痛、拥有无限耐力，并获得 力量+2 / 速度+2 / 感知+2 / 意志+2。
//     - 爆发结束后：被强制陷入 10 分钟的沉睡（潜能耗尽的代价）。
//
// 为什么所有逻辑都放在本文件内：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外的任何
//   文件。本文件通过"向已有类型追加子类型 / 组件 / 状态效果"的方式接入引擎，
//   不修改任何核心文件，因此完全满足约束。
//
// 为什么没有目标选择（target selection）：
//   本美德是"濒死时自动触发"的被动特性，不需要玩家手动选取目标，因此不存在
//   需要取消的目标弹窗。需求中"目标选择需可取消"的条款在此处自然满足——
//   没有任何会卡住玩家的输入框。所有触发都是自动且非阻塞的。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承，不修改其源文件）：
//   - /datum/virtue                          美德基类（modular_azurepeak/_virtue.dm）
//   - /datum/component                       组件基类（挂载健康信号与生命周期管理）
//   - /datum/status_effect/buff              增益状态效果基类（含 effectedstats 机制）
//   - COMSIG_LIVING_HEALTH_UPDATE            生命值更新信号（每次 updatehealth() 发出）
//   - /mob/living/proc/InCritical()          判定是否处于濒死（软/硬暴击）状态
//   - /mob/living/proc/get_wounds()          取得全部伤口（用于逐一止血）
//   - /datum/wound/proc/set_bleed_rate()     设置单个伤口的流血速率（置 0 即止血）
//   - getBruteLoss / getFireLoss / adjust*   读取并恢复钝伤 / 烧伤
//   - SetSleeping()                          强制睡眠（爆发结束后的代价）
//   - change_stat / get_stat                 属性调整（由 effectedstats 自动驱动）
//   - TRAIT_NOPAIN / TRAIT_NOPAINSTUN        无痛 / 痛苦不打断（"忽视疼痛"）
//   - TRAIT_INFINITE_STAMINA                 无限耐力（"无限耐力 / 不知疲倦"）
//   - NOBLOOD                                种族 species_traits 标志（无血 = 非血肉之躯）
//   - STATKEY_STR / SPD / PER / WIL          四项属性键（code/__DEFINES 中已定义）
//
// 加载：本文件需要在 modular_z121/_load.dm 中以 #include 引入（已在该文件追加）。
// ============================================================================


// ----------------------------------------------------------------------------
// 自定义特性键（Trait key）：生命潜能
// 为什么要定义：用一个唯一字符串标识"持有生命潜能"的人，便于本文件（及未来其它
//   系统）通过 HAS_TRAIT 判断身份，也作为 ADD_TRAIT 的来源标签使用。
// 为什么用字符串：引擎的特性系统以字符串为键，与 modular_z121 内既有写法
//   （如 never_ending.dm 的 TRAIT_DESIGNATED_PERFORMER）保持一致。
// ----------------------------------------------------------------------------
#define TRAIT_LIFE_POTENTIAL "life_potential"

// 濒死爆发触发概率：10%。需求明确为"10% 概率进入濒死爆发"。
// 单独定义为常量，便于将来平衡性调整时只改这一处。
#define LIFE_POTENTIAL_PROC_CHANCE 10

// 濒死爆发持续时间：3 分钟。爆发期间享有全部增益。
#define LIFE_POTENTIAL_BURST_DURATION (3 MINUTES)

// 爆发结束后的强制睡眠时间：10 分钟。这是"透支生命潜能"的代价。
#define LIFE_POTENTIAL_SLEEP_DURATION (10 MINUTES)

// 两次触发之间的最小冷却：5 秒。
// 为什么需要：生命值可能在濒死阈值附近来回抖动（治疗/再受伤），导致 InCritical()
//   在极短时间内反复 false<->true。若不加冷却，理论上同一场濒死会被判定为多次"进入"，
//   带来异常的连续 10% 投骰。5 秒冷却把"同一场濒死事件"的多次抖动合并，既不影响
//   "真正再次濒死"的判定（一般间隔远大于 5 秒），又杜绝抖动刷概率。
#define LIFE_POTENTIAL_REROLL_COOLDOWN (5 SECONDS)


// ----------------------------------------------------------------------------
// 美德定义：生命潜能
// 为什么归入 /datum/virtue/utility 分支：与 never_ending（永无止境）等"效用型"
//   被动美德保持一致；作为 /datum/virtue 子类型，会被 subtypesof() 自动收录进
//   GLOB.virtues，无需手动注册。
// ----------------------------------------------------------------------------
/datum/virtue/utility/life_potential
	// 菜单中显示的美德名。
	name = "生命潜能"
	// 角色内描述（in-character）：呼应"濒死时迸发无限潜能"的设定。
	desc = "每一个生命在濒临死亡之际，都会迸发出无限的潜能，而我的潜能尤为磅礴。"
	// custom_text 用机制语言把硬性规则讲清楚，避免玩家误解触发条件与代价。
	// 为什么单列：desc 偏角色口吻，这里写明"仅限血肉之躯、10% 概率、3 分钟、随后强睡"。
	custom_text = "获得【生命潜能】特性（仅限血肉之躯的种族）：\n\
	当你进入濒死状态时，有 10% 概率进入持续 3 分钟的【濒死爆发】。\n\
	爆发瞬间立即止血、并使外伤恢复一半；爆发期间你免疫疼痛、耐力无限，\n\
	力量+2、速度+2、感知+2、意志+2。\n\
	爆发结束后，你将因潜能透支而被强制沉睡 10 分钟。"
	// 消耗 16 点凯旋点数。基类 New() 会自动把"Costs 16 TRIUMPH"追加到 desc。
	// check_triumphs() 会在 apply_virtue 流程开头校验并扣除，点数不足则不授予。
	triumph_cost = 16
	// 为什么"不"用 added_traits 授予 TRAIT_LIFE_POTENTIAL：
	//   apply_virtue 的调用顺序是 apply_to_human() 先于 handle_traits()。若走 added_traits，
	//   即便我们在 apply_to_human 里因"非血肉之躯"判定而想撤销标签，紧随其后的
	//   handle_traits() 仍会把它无条件加回，导致非血肉种族出现"有标签却无效果"的误导。
	//   因此改为在 apply_to_human 通过血肉校验后，手动 ADD_TRAIT，使"标签 = 能力生效"严格一致。

// apply_to_human：美德被赋予人物时调用。这里负责两件事：
//   1) 校验"仅限血肉之躯"——非血肉种族（带 NOBLOOD 标志，如构造体/玩偶）不授予能力。
//   2) 为合格的人物挂载驱动组件，由组件监听健康变化并处理濒死爆发。
/datum/virtue/utility/life_potential/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// 防御性检查：没有有效人物（极端时序下可能为 null）就直接返回，避免空引用。
	if(!istype(recipient))
		return

	// 为什么校验种族血肉属性："仅限血肉之躯"是本美德的硬性设定。
	//   引擎用种族 species_traits 中的 NOBLOOD 标志来表示"该种族没有血液"
	//   （构造体 construct、玩偶 doll 等即带此标志）。无血 = 非血肉之躯，不应获得
	//   "濒死迸发生命潜能"的能力。这里做优雅降级：保留已选美德（含已扣点数的事实），
	//   但不挂组件、并明确告知玩家能力未觉醒，而不是直接抛错。
	if(NOBLOOD in recipient.dna?.species?.species_traits)
		to_chat(recipient, span_warning("生命潜能源于血肉的本能——而你并非血肉之躯，\
										这份潜能无法在你体内觉醒。"))
		// 直接返回、既不打标签也不挂组件：非血肉种族彻底不获得本能力，状态自洽。
		return

	// 通过血肉校验：手动授予"身份标签"，来源标记 TRAIT_VIRTUE（与引擎美德特性约定一致，
	//   便于未来统一清理）。这样标签只在能力真正生效时存在，杜绝"有标签却无效果"。
	ADD_TRAIT(recipient, TRAIT_LIFE_POTENTIAL, TRAIT_VIRTUE)

	// 为什么挂组件而不是直接 RegisterSignal：美德 datum 是 GLOB.virtues 里的"模板单例"，
	//   不能用它的 src 去注册到 recipient 上（回调会指向错误的 datum）。组件实例与
	//   recipient 一一绑定，能正确管理信号注册并在宿主消失时自动清理。
	//   组件做了 UNIQUE 去重，重复赋予不会叠加。
	recipient.AddComponent(/datum/component/life_potential)


// ----------------------------------------------------------------------------
// 驱动组件：生命潜能
// 为什么用组件：组件天然与宿主 mob 绑定，提供 Initialize / UnregisterFromParent
//   生命周期钩子，能干净地完成"注册健康信号、检测濒死、投骰触发爆发"，并在宿主
//   消失时反注册信号，避免悬空回调。
// ----------------------------------------------------------------------------
/datum/component/life_potential
	// 唯一组件：同一 mob 上只允许一个实例，重复 AddComponent 会被丢弃，杜绝重复监听。
	dupe_mode = COMPONENT_DUPE_UNIQUE
	// 上一次健康更新时是否处于濒死状态。
	// 为什么需要：我们只想在"从非濒死跨入濒死"的那一刻投骰，而 COMSIG_LIVING_HEALTH_UPDATE
	//   每次 updatehealth() 都会触发（频率很高）。用这个布尔做"边沿检测"，确保同一场
	//   濒死不会每个 tick 都重复投骰。
	var/was_in_neardeath = FALSE
	// 触发冷却计时器（由 COOLDOWN_* 宏读写），用于抑制濒死阈值附近的健康值抖动刷骰。
	COOLDOWN_DECLARE(reroll_cd)

// Initialize：组件创建时调用，负责类型校验与信号注册。
/datum/component/life_potential/Initialize()
	. = ..()
	// 本能力依赖人类专属的伤口/属性/睡眠体系，挂到非人类身上没有意义且会出错，
	//   返回 COMPONENT_INCOMPATIBLE 让引擎丢弃本组件。
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/human/host = parent
	// 监听宿主的生命值更新信号。引擎在 updatehealth() 末尾（且在 update_stat() 之后）
	//   发出该信号，此时 InCritical() / stat 均已是最新值，正适合用来判定"是否刚进入濒死"。
	RegisterSignal(host, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(on_health_update))

// UnregisterFromParent：组件与宿主解绑时，撤销 Initialize 注册的信号，避免悬空回调。
//   特性标签由美德的 added_traits 通道（TRAIT_VIRTUE 来源）授予，其生命周期由美德
//   系统管理，这里不重复处理，以免与之冲突。
/datum/component/life_potential/UnregisterFromParent()
	if(parent)
		UnregisterSignal(parent, COMSIG_LIVING_HEALTH_UPDATE)
	return ..()

// on_health_update：健康更新信号回调，负责"濒死边沿检测 + 10% 投骰 + 触发爆发"。
// 为什么标 SIGNAL_HANDLER：信号回调是同步调用，绝不能 sleep。本过程只做布尔判断、
//   随机投骰与一次非阻塞的 apply_status_effect，全程不阻塞，符合 SIGNAL_HANDLER 约束。
/datum/component/life_potential/proc/on_health_update(datum/source)
	SIGNAL_HANDLER

	// 防御：宿主异常则不处理本次更新。
	if(!ishuman(parent))
		return
	var/mob/living/carbon/human/host = parent

	// 为什么先判爆发是否已激活：爆发期间会持续治疗/改变属性，从而不断触发健康更新信号；
	//   若不在此拦截，会造成"爆发中再次投骰/递归触发"。爆发是唯一状态，激活时直接返回。
	//   （状态效果在 on_apply 调用前就已登记进 owner.status_effects，故递归进来这里也能查到。）
	if(host.has_status_effect(/datum/status_effect/buff/life_potential_burst))
		return

	// 死亡者不触发：尸体没有"迸发潜能"的意义；同时把濒死标记复位，
	//   以便其被复活后再次濒死能正常重新投骰。
	if(host.stat == DEAD)
		was_in_neardeath = FALSE
		return

	// 取当前是否处于濒死（软/硬暴击）状态。这是需求所述"进入濒死状态"的引擎判定。
	var/currently_neardeath = host.InCritical()

	// 不在濒死：复位边沿标记，使下次真正跌入濒死时能被识别为"新的一次进入"。
	if(!currently_neardeath)
		was_in_neardeath = FALSE
		return

	// 已经处于濒死且上次也濒死：说明仍是同一场濒死的后续 tick，不重复投骰。
	if(was_in_neardeath)
		return

	// 走到这里 = "刚刚从非濒死跨入濒死"的那一帧。先置标记，确保同场濒死只投一次骰。
	was_in_neardeath = TRUE

	// 冷却未结束则放弃本次触发：抑制阈值附近健康值抖动造成的异常连续投骰。
	if(!COOLDOWN_FINISHED(src, reroll_cd))
		return
	// 立即开始冷却（无论投骰成败都计入），把"同一场濒死事件"压成单次判定。
	COOLDOWN_START(src, reroll_cd, LIFE_POTENTIAL_REROLL_COOLDOWN)

	// 10% 概率判定。prob() 失败则本次濒死不迸发潜能，安静返回（不打扰玩家）。
	if(!prob(LIFE_POTENTIAL_PROC_CHANCE))
		return

	// 投骰成功：施加"濒死爆发"状态效果。一切即时与持续效果都封装在该状态效果内
	//   （on_apply 处理止血/治疗/增益，on_remove 处理强制睡眠），组件只负责触发。
	// 校验返回值：apply_status_effect 可能因引擎拒绝返回 null，此时如实不再做后续假设。
	host.apply_status_effect(/datum/status_effect/buff/life_potential_burst)


// ----------------------------------------------------------------------------
// 状态效果：濒死爆发（Life Potential Burst）
// 为什么做成 /datum/status_effect/buff 子类：
//   - 需求要求一个"限时（3 分钟）的增益状态"，buff 基类自带 effectedstats 机制，
//     能在 on_apply 自动加属性、on_remove 自动减回，并带 1~20 越界保护，最省事且稳妥。
//   - 把"即时效果（止血/回血）"放在 on_apply、"结束代价（强制睡眠）"放在 on_remove，
//     状态自洽：无论是自然到期、被驱散还是宿主删除，都会走对应清理，不留残留增益。
// ----------------------------------------------------------------------------
/datum/status_effect/buff/life_potential_burst
	id = "life_potential_burst"                                                 // 唯一标识，供 has_status_effect 查询去重。
	duration = LIFE_POTENTIAL_BURST_DURATION                                    // 持续 3 分钟，到时自动 on_remove。
	alert_type = /atom/movable/screen/alert/status_effect/buff/life_potential_burst // 关联 HUD 图标与说明。
	needs_processing = FALSE                                                    // 纯"开始/结束"型效果，无需每 tick 处理，省开销。
	// 爆发期间的属性加成：力量/速度/感知/意志各 +2。
	// 为什么用 effectedstats：基类 on_apply/on_remove 会自动加/减这些属性，并把任何
	//   会超过 20 上限的加成自动截断，无需手写边界处理。
	effectedstats = list(
		STATKEY_STR = 2,                                                        // 力量 +2
		STATKEY_SPD = 2,                                                        // 速度 +2
		STATKEY_PER = 2,                                                        // 感知 +2
		STATKEY_WIL = 2,                                                        // 意志 +2
	)

// on_apply：爆发开始瞬间执行。负责：施加属性（基类）→ 止血 → 回血一半 → 授予增益特性。
//   返回 TRUE 表示效果成功生效；返回 FALSE 会让引擎自动移除本效果。
/datum/status_effect/buff/life_potential_burst/on_apply()
	// 先跑基类：应用 effectedstats（四项属性 +2，含越界保护）。
	. = ..()
	// 防御：基类若因故失败（返回假）则不继续施加后续效果，保持状态一致。
	if(!.)
		return
	// 防御：owner 必须是有效人类才能执行伤口/治疗逻辑。
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/host = owner

	// ---- 立即止血 ----
	// 为什么逐一把伤口的流血速率设为 0：需求要求"伤口立即停止流血"。get_wounds()
	//   汇总了 carbon 各肢体上的所有伤口；set_bleed_rate(0) 会把该伤口的流血归零，
	//   并同步扣减肢体/简单伤口的总流血量（bleeding），从而真正止住失血。
	for(var/datum/wound/wound as anything in host.get_wounds())
		if(isnull(wound))                                                       // 跳过列表中可能存在的空项，避免空引用。
			continue
		wound.set_bleed_rate(0)                                                 // 该伤口不再流血。

	// ---- 外伤恢复一半 ----
	// 为什么用当前损伤的一半作为治疗量："伤势立即恢复一半"。分别取当前钝伤/烧伤总量，
	//   各回复其一半（adjustXLoss 传负值表示治疗）。最后一次性 updatehealth() 刷新状态。
	var/brute_to_heal = host.getBruteLoss() * 0.5                               // 当前钝伤的一半。
	var/burn_to_heal = host.getFireLoss() * 0.5                                 // 当前烧伤的一半。
	if(brute_to_heal > 0)
		host.adjustBruteLoss(-brute_to_heal, FALSE)                            // 治疗钝伤（FALSE = 暂不立即刷新，下面统一刷新）。
	if(burn_to_heal > 0)
		host.adjustFireLoss(-burn_to_heal, FALSE)                              // 治疗烧伤（同上，延后刷新）。
	host.updatehealth()                                                         // 统一刷新生命值/状态（仅一次，省开销且避免中途递归）。

	// ---- 授予"爆发"期间的增益特性 ----
	// 为什么用本效果 id 作为特性来源：on_remove 时用同一来源移除，保证一一对应、不误删
	//   其它来源施加的同名特性。
	//   - TRAIT_NOPAIN / TRAIT_NOPAINSTUN：忽视疼痛（不感到痛、也不被痛苦打断动作）。
	//   - TRAIT_INFINITE_STAMINA：无限耐力（stamina_add 检测到此特性会直接返回，疲劳不增长）。
	ADD_TRAIT(host, TRAIT_NOPAIN, id)                                           // 无痛。
	ADD_TRAIT(host, TRAIT_NOPAINSTUN, id)                                       // 痛苦不打断（坚忍）。
	ADD_TRAIT(host, TRAIT_INFINITE_STAMINA, id)                                 // 无限耐力。

	// 给出醒目反馈与音效，让玩家清楚"濒死爆发已触发"，否则机制对玩家不可见。
	host.visible_message(span_warning("[host] 的伤口骤然止血，眼中迸发出不屈的生命光辉！"), \
						span_userdanger("濒死之际，体内的生命潜能轰然迸发！我感受不到疼痛，浑身充满了用不尽的力量！"))
	playsound(host, 'sound/misc/deadbell.ogg', 100, FALSE, -1)                  // 复用引擎已有音效，避免新增音频资源依赖。
	return TRUE

// on_remove：爆发自然结束（或被驱散/宿主删除）时执行。负责：减回属性（基类）→
//   移除增益特性 → 让宿主因潜能透支而强制沉睡 10 分钟。
/datum/status_effect/buff/life_potential_burst/on_remove()
	// 先跑基类：把 effectedstats 的四项属性加成减回去（与 on_apply 对称）。
	. = ..()
	// 防御：owner 仍是有效人类时才执行特性移除与睡眠；宿主已被删除则无需处理。
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/host = owner

	// 移除爆发期间授予的增益特性，来源与 on_apply 一致，确保精确撤销、不误伤其它来源。
	REMOVE_TRAIT(host, TRAIT_NOPAIN, id)
	REMOVE_TRAIT(host, TRAIT_NOPAINSTUN, id)
	REMOVE_TRAIT(host, TRAIT_INFINITE_STAMINA, id)

	// ---- 代价：强制沉睡 10 分钟 ----
	// 为什么用 SetSleeping 且 ignore_canstun = TRUE："状态结束后强制睡眠 10 分钟"是
	//   需求规定的硬性代价。SetSleeping 直接把睡眠剩余时长设为 10 分钟；ignore_canstun
	//   绕过 TRAIT_SLEEPIMMUNE 等抗性，确保"强制"语义成立（即便平时不会困也会睡着）。
	//   仅对存活者施加：若此刻已死亡，让其安息即可，不必再叠加睡眠。
	if(host.stat != DEAD)
		host.SetSleeping(LIFE_POTENTIAL_SLEEP_DURATION, TRUE, TRUE)
		to_chat(host, span_warning("生命潜能燃烧殆尽，无边的倦意将我吞没——我沉沉睡去……"))

// HUD 提示：让爆发期间的持有者在屏幕上看到一个图标与说明，知道自己正处于濒死爆发。
/atom/movable/screen/alert/status_effect/buff/life_potential_burst
	name = "濒死爆发"                                                          // HUD 悬浮标题。
	desc = "濒死之际迸发的生命潜能：无痛、无尽耐力，四维大幅提升。结束后将陷入沉睡。" // 悬浮说明：解释增益与代价。
	icon_state = "buff"                                                         // 复用引擎通用增益图标，避免新增美术资源依赖。


// ----------------------------------------------------------------------------
// 清理本文件内部使用的计时 / 概率宏，避免污染全局编译命名空间。
// 为什么保留 TRAIT_LIFE_POTENTIAL 不 #undef：它是对外可见的"身份标签"，其它系统
//   可能需要用 HAS_TRAIT 查询，这与 modular_z121 内其它特性键（如
//   TRAIT_DESIGNATED_PERFORMER）保持全局可见的约定一致。
// ----------------------------------------------------------------------------
#undef LIFE_POTENTIAL_PROC_CHANCE
#undef LIFE_POTENTIAL_BURST_DURATION
#undef LIFE_POTENTIAL_SLEEP_DURATION
#undef LIFE_POTENTIAL_REROLL_COOLDOWN
