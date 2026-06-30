// ============================================================================
// modular_z121/account_perks/warm_power_field.dm
// 自定义特性 + 光环 + 心情事件：温暖力场（Warm Power Field）
// 受惠账号：Sonic121
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   需求：当玩家账号名被识别为 Sonic121 时，他创建的角色一进入游戏，就自动获得一个
//   自定义特性【温暖力场】；该特性会向其周围一定范围内的【玩家】持续散发一种强烈的
//   正向情绪增益——心声为「<Sonic121 的角色名> 就在我身边」。
//
//   需求拆解 → 各自落到引擎里的既有机制：
//     · "自定义特性【温暖力场】" → 一个唯一特性键 TRAIT_WARM_POWER_FIELD，用 ADD_TRAIT 授予；
//        并登记进 GLOB.roguetraits（玩家特性自检面板）、挂检视信号（他人检视可见），双重可见。
//     · "向周围一定范围的玩家持续散发增益" → 一个挂在持有者身上的【光环驱动组件】，
//        通过 SSprocessing 周期性扫描视野内的玩家，给他们施加一个【正向心情事件】。
//     · "强烈的正向情绪增益" → 本游戏用"压力(stress)"表达心情：压力为负 = 心情变好。
//        故事件 stressadd 取较大负值（见 WARM_POWER_FIELD_STRESS），即"巨大的情绪增益"。
//     · "心声为 <角色名> 就在我身边" → 心情事件在"心情面板"按 desc 文本展示；我们把持有者的
//        角色名（real_name）动态写进每位受益者那份事件实例的 desc 里。
//
// 为什么这些代码全部放在 modular_z121 之内：
//   硬性约束：自定义内容只能放在 modular_z121，且不得改动该目录之外的任何文件。本文件只
//   "新增"特性键、组件子类型、心情事件子类型与若干 proc，全部是对既有类型的【追加】，不修改
//   任何核心文件——与本目录既有做法（rpg_system.dm / life_potential.dm 等）完全一致。
//
// 为什么用"组件 + 周期扫描"承载光环，而不是把状态挂在特性上：
//   特性键只是一个布尔标签，无法承载"每个持有者各自的光环处理循环 / 范围 / 节流计时"。
//   组件实例与具体持有者一一绑定，天然提供 Initialize/Destroy 生命周期与 process() 周期回调，
//   宿主消失时自动停机清理，是承载"按持有者独立运行的光环"的正解（与 rpg_system 驱动组件同构）。
//
// 为什么用负压力(stress)而不是直接调心情数值：
//   roguetown 的心情完全由"压力事件(stressevent)"聚合驱动（见 code/modules/mob/living/carbon/stress.dm
//   与 code/datums/stress/）。负的 stressadd 会被 get_stress_amount() 汇总为更低的总压力，
//   从而把玩家推向更好的心情阈值（NICE/GOOD）。这是引擎给情绪加成的【唯一正道】，复用它即"真正
//   执行了所描述的功能"，而非自造一套并行系统。
//
// 依赖（均为引擎 / 本模块已有内容，本文件只调用 / 继承，不修改其源文件）：
//   - /datum/component                       组件基类（承载光环循环与检视信号）
//   - SSprocessing / START_PROCESSING / STOP_PROCESSING / process(delta_time)  周期处理子系统
//   - view(range, center)                    取"以持有者为中心、有视线可见"的范围（光环须可感知，故用视线范围）
//   - /datum/stressevent                     压力事件基类（code/datums/stress/_stressevent.dm）
//   - /mob/living/carbon/add_stress(type)    施加压力事件（仅 /mob/living/carbon 有真正实现）
//   - /mob/living/carbon/get_stress_event(type)  取回某玩家身上的该事件实例（用于写入动态 desc）
//   - COMSIG_PARENT_EXAMINE                   检视信号（atom/examine 末尾发出，用于追加检视文本）
//   - GLOB.roguetraits                        玩家"特性自检面板"读取的全局特性说明表
//   - ADD_TRAIT / HAS_TRAIT                   特性增删与查询
//   - real_name                               人物的"真实角色名"（即需求里要展示的"角色名"）
//
// 加载与注册（均在 modular_z121 内完成）：
//   - modular_z121/_load.dm                       以 #include 引入本文件。
//   - modular_z121/account_perks/account_perks.dm 的登录派发器调用 grant_sonic121_perks()。
//   - modular_z121/bootstrap/custom_bootstrap.dm  在其 Initialize 中调用 register_warm_power_field_trait()。
// ============================================================================


// ----------------------------------------------------------------------------
// 常量定义区
// ----------------------------------------------------------------------------

// 自定义特性键：温暖力场。用一个唯一可读串标识"持有温暖力场"的人。
//   为什么用可读中文串："特性自检面板"会把"特性字符串本身"当作标题展示给玩家
//   （与本目录 TRAIT_RPG_SYSTEM = "RPG系统" 的约定一致），写成"温暖力场"玩家就能看到体面的标题。
#define TRAIT_WARM_POWER_FIELD "温暖力场"

// 授予该特性时使用的 ADD_TRAIT 来源标签：统一、可识别，便于将来需要时统一清理；
//   不复用 TRAIT_VIRTUE / TRAIT_GENERIC，避免与别处授予的同名特性互相干扰。
#define WARM_POWER_FIELD_TRAIT_SOURCE "warm_power_field_grant"

// 受惠账号（ckey 形式）：ckey 会把账号名归一化为"全小写、去特殊字符"，故 Sonic121 → "sonic121"。
//   单列常量，便于将来调整或新增受惠账号只改这一处。
#define WARM_POWER_FIELD_CKEY "sonic121"

// 光环作用半径（格）。为什么是 5：略小于默认视野(7)，是一个"身边"语义合适、又不至于刷屏的范围。
//   单列常量，平衡只改这一处。
#define WARM_POWER_FIELD_RANGE 5

// 心情事件的压力增量。负值=心情变好；取 -8 表示"巨大的情绪增益"
//   （参照正向事件表：moondust_purest 即 -8，属顶级正向增益档）。单列常量，平衡只改这一处。
#define WARM_POWER_FIELD_STRESS -8

// 心情事件的持续时间。为什么是 90 秒：光环每个处理周期都会刷新（重置 time_added），
//   只要还在范围内就持续生效；离开范围后再经约 90 秒自然消退，形成"刚离开余温尚存"的体验。
//   （参照 /datum/stressevent/champion 同类"靠近某人即获益"的事件用 1 分钟量级。）
#define WARM_POWER_FIELD_DURATION (90 SECONDS)


// ----------------------------------------------------------------------------
// 正向心情事件：温暖力场
// 为什么单独定义一个事件类型：心情面板按"事件类型"聚合展示，且每位受益者会各自 new 一份实例
//   （见 /mob/living/carbon/add_stress：stressors[event_type] = new event_type()）。
//   有了独立类型，我们就能在每位受益者那份实例上写入"持有者角色名"的专属 desc，互不串扰。
// ----------------------------------------------------------------------------
/datum/stressevent/warm_power_field
	// 持续时间：见上方常量说明。
	timer = WARM_POWER_FIELD_DURATION
	// 压力增量：负值 → 巨大的正向情绪增益。
	stressadd = WARM_POWER_FIELD_STRESS
	// 默认 desc（兜底）：当极端情况下拿不到持有者角色名时展示这句，保证心情面板不出现空行。
	//   正常情况下，光环每次施加后都会把这句覆盖为带"角色名"的动态文本（见组件 apply_aura_to）。
	desc = span_boldgreen("一股温暖的力场环绕着我，安心极了。")


// ============================================================================
// 光环驱动组件：温暖力场（挂在持有者身上）
// 为什么用组件：与 rpg_system 驱动组件同构——组件与宿主一一绑定，提供生命周期与周期回调，
//   宿主消失自动清理，最适合承载"按持有者独立运行的光环循环 + 检视可见信号"。
// ============================================================================
/datum/component/warm_power_field
	// 唯一组件：同一宿主只允许一个实例，重复 AddComponent 会被丢弃，杜绝双重光环 / 双倍施加。
	dupe_mode = COMPONENT_DUPE_UNIQUE

// Initialize：组件创建时调用。负责类型校验、启动周期处理、挂检视信号（他人检视可见）。
/datum/component/warm_power_field/Initialize()
	. = ..()
	// 光环面向"人类持有者"。挂到非人类身上没有意义（也取不到 real_name），返回 INCOMPATIBLE 让引擎丢弃。
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	// 启动周期处理：之后每个处理周期都会调用 process()，由它扫描范围内玩家并施加增益。
	//   用 SSprocessing：通用低频处理子系统，适合这种"周期性轻量光环巡检"。
	START_PROCESSING(SSprocessing, src)
	// 注册检视信号：引擎在 atom/examine() 末尾发出 COMSIG_PARENT_EXAMINE，携带 (user, examine_list)。
	//   借此让"他人/本人检视持有者"时能看到"周身环绕温暖力场"的提示，满足"特性可见"的要求。
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

// Destroy：组件被销毁（宿主死亡删除 / 被移除）时调用。停止周期处理，避免悬空回调。
//   信号与特性的清理：信号由 UnregisterFromParent / 组件销毁机制处理；特性标签来源是
//   WARM_POWER_FIELD_TRAIT_SOURCE，其生命周期跟随角色本身，这里不强行删除以免与别处冲突。
/datum/component/warm_power_field/Destroy(force, silent)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

// UnregisterFromParent：组件与宿主解绑时调用，撤销检视信号，避免向已解绑的宿主继续追加检视文本。
/datum/component/warm_power_field/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_PARENT_EXAMINE)
	return ..()

// process：每个处理周期执行一次。扫描持有者视野内的"玩家"，逐一施加/刷新温暖力场增益。
//   错误处理贯穿全程：宿主异常 / 已死亡 / 取不到角色名 / 目标非法，均安全跳过，绝不空引用、绝不报错刷屏。
/datum/component/warm_power_field/process(delta_time)
	// 防御①：宿主必须仍是有效人类，否则无从发出光环——直接返回，等待 Destroy 收尾。
	if(!ishuman(parent))
		return
	var/mob/living/carbon/human/host = parent
	// 防御②：死亡的持有者不再散发光环（"温暖"随生命存续而存在）。允许昏迷时仍生效（仍是"在身边"）。
	if(host.stat == DEAD)
		return
	// 取持有者的"角色名"用于心声文本。real_name 是人物真实姓名，即需求所说的"角色名"。
	//   错误处理：万一 real_name 为空（异常人物），回退到显示名 name，再回退到"一位旅人"，确保文本永不为空。
	var/host_name = host.real_name
	if(!host_name)
		host_name = host.name
	if(!host_name)
		host_name = "一位旅人"
	// 遍历"以持有者为中心、有视线可见、半径 WARM_POWER_FIELD_RANGE 内"的所有活体。
	//   为什么用 view 而非 range：温暖力场是"可感知"的，隔着墙不应生效，view 自带视线遮挡判断，语义更贴切。
	for(var/mob/living/target in view(WARM_POWER_FIELD_RANGE, host))
		// 跳过持有者自己：需求是"周围的玩家"，"就在我身边"也指他人感知到 Sonic121 在旁。
		if(target == host)
			continue
		// 仅作用于"玩家"：有 client 才是玩家；NPC / 简单动物没有 client，不在需求范围内。
		if(!target.client)
			continue
		// 心情/压力系统只有 /mob/living/carbon 有真正实现（add_stress 在 /mob 上是空操作）。
		//   非 carbon 目标即便施加也无效，故先过滤，既省开销又表意清晰。
		if(!iscarbon(target))
			continue
		// 跳过已死亡目标：尸体没有心情可言。
		if(target.stat == DEAD)
			continue
		// 对合法目标施加/刷新增益（具体施加与动态 desc 写入封装在 apply_aura_to）。
		apply_aura_to(target, host_name)

// apply_aura_to：给单个目标施加（或刷新）温暖力场心情事件，并把持有者角色名写进该目标那份事件实例的 desc。
//   单独成 proc：把"施加 + 写动态文本 + 首次提示"集中处理，逻辑清晰，将来要加音效/特效也只改这里。
/datum/component/warm_power_field/proc/apply_aura_to(mob/living/carbon/target, host_name)
	// 防御：目标必须是有效 carbon（调用方已过滤，这里再次确认，双保险，避免外部误用导致运行时错误）。
	if(!iscarbon(target))
		return
	// 该目标此前是否已经处于本光环下：用于只在"首次进入光环"时给一次醒目提示，避免每个周期刷屏。
	var/was_present = target.has_stress_event(/datum/stressevent/warm_power_field)
	// 施加压力事件。add_stress 若该事件已存在，会刷新其 time_added（即"续期"）；不存在则新建一份实例。
	//   返回值即该目标身上的事件实例（也可用 get_stress_event 再取，这里直接用返回值更稳妥）。
	var/datum/stressevent/warm_power_field/event = target.add_stress(/datum/stressevent/warm_power_field)
	// 错误处理：极端情况下（例如目标带 TRAIT_NOMOOD 致 can_apply 失败）add_stress 可能不返回实例；
	//   此时安静放弃对该目标的后续处理，绝不对 null 写 desc。
	if(!istype(event))
		return
	// 写入动态心声：把持有者角色名嵌进这份"专属于该受益者"的事件实例 desc。
	//   每周期都重写：这样即便持有者中途改名 / 易容，受益者看到的也始终是最新角色名。
	event.desc = span_boldgreen("[host_name] 就在我身边，一股暖流涌上心头。")
	// 仅在"首次进入光环"时给目标一次提示，强化"被温暖力场笼罩"的即时感知；已在场则不再重复提示。
	if(!was_present)
		to_chat(target, span_nicegreen("你感到一股温暖的力场将你轻轻包裹——[host_name] 就在身边。"))

// on_examine：检视信号回调。当有人（含本人）检视持有者时，在检视文本末尾追加"温暖力场"提示。
//   标 SIGNAL_HANDLER：信号回调为同步调用，绝不能 sleep；本过程只做布尔判断与字符串追加，符合约束。
/datum/component/warm_power_field/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	// 防御：宿主异常或已不再持有该特性，则不追加任何文本（避免特性被移除后检视仍显示残留）。
	if(!ishuman(parent))
		return
	if(!HAS_TRAIT(parent, TRAIT_WARM_POWER_FIELD))
		return
	// 追加可读的检视提示，让检视者明确得知此人周身环绕着令人安心的温暖力场。
	examine_list += span_nicegreen("一圈温暖而令人安心的力场环绕着此人。【温暖力场】")


// ============================================================================
// 授予逻辑：Sonic121 账号"进入游戏即赠礼"
// 由登录派发器（account_perks/account_perks.dm 的唯一 Login() 覆写）在每次登录时调用。
// 自带 ckey 自检：不是该账号就直接返回，所以派发器可无条件调用、无需关心账号匹配。
// ============================================================================
/mob/living/carbon/human/proc/grant_sonic121_perks()
	// 仅对目标账号生效：ckey 是该玩家归一化后的账号名（派发器在 Login() 的 ..() 之后才调用，此刻已就绪）。
	if(ckey != WARM_POWER_FIELD_CKEY)
		return
	// 一次性闸门：已持有【温暖力场】就不再重复授予（保护重连 / 灵魂回体时不重复挂组件与提示）。
	//   当 Sonic121 创建并进入一个全新角色（新身体没有该特性）时，会再次满足条件、重新授予——
	//   正合"他创建的角色进入游戏即生效"。
	if(HAS_TRAIT(src, TRAIT_WARM_POWER_FIELD))
		return
	// 授予身份特性。来源用专属标签 WARM_POWER_FIELD_TRAIT_SOURCE，便于将来需要时统一识别 / 清理。
	ADD_TRAIT(src, TRAIT_WARM_POWER_FIELD, WARM_POWER_FIELD_TRAIT_SOURCE)
	// 挂载光环驱动组件：它承载周期扫描与检视信号。组件 UNIQUE 去重，重复授予不会叠加。
	AddComponent(/datum/component/warm_power_field)
	// 给出醒目反馈，让玩家立刻知道"温暖力场已生效"，否则纯被动光环对玩家不直观。
	to_chat(src, span_nicegreen("【温暖力场】已觉醒——你周身将持续散发令人安心的暖意，温暖你身边的每一位旅人。"))


// ----------------------------------------------------------------------------
// 让玩家在游戏内"看得见"这项特性：登记进 GLOB.roguetraits（特性自检面板）。
// 为什么要登记：引擎的玩家特性自检面板会遍历 GLOB.roguetraits，对玩家"拥有的"每个特性打印
//   「特性名 - 描述」。把 TRAIT_WARM_POWER_FIELD 加进这张全局表，玩家点开特性列表才能看到
//   【温暖力场】及其说明；否则特性虽已生效却对玩家不可见。
// 为什么用"运行时追加"而非改核心表：核心表 roguetraits 定义在 code/__DEFINES/traits.dm
//   （在 modular_z121 之外，禁止修改）。故在启动钩子里向这张已初始化的全局表追加键值对——
//   这是本项目登记自定义特性的既定做法（参见 genius.dm / rpg_system.dm 的 register_*_trait）。
// 为什么做成独立 proc 由 custom_bootstrap 调用：#define 按 #include 顺序生效，bootstrap 包含
//   顺序早于本文件、无法直接引用本文件的宏；而 proc 名全局可解析，跨文件可调用。于是把"需要用到
//   本文件宏"的登记逻辑封装在本文件的 proc 内，bootstrap 只按名调用一次。
// ----------------------------------------------------------------------------
/proc/register_warm_power_field_trait()
	// 防御：核心全局表必须已初始化为 list 才能写入；异常情况下安静跳过，绝不新建一张与核心脱钩的"假表"。
	if(!islist(GLOB.roguetraits))
		return
	// 写入「特性键 -> 玩家自检描述」。第一人称、span_info 样式，与表中其它条目风格一致。幂等：重复调用只覆盖同键。
	GLOB.roguetraits[TRAIT_WARM_POWER_FIELD] = span_info("我拥有【温暖力场】：周身持续散发令人安心的暖意，\
		让我身边一定范围内的人都能获得巨大的情绪慰藉。")
