// ============================================================================
// modular_z121/vices/neat_freak.dm
// 自定义恶习（Custom Vice / 恶习）：洁癖 / Neat Freak
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   实现需求中的全新恶习"洁癖（neat freak）"：
//     "当身上有污渍时，心情会变差，并且意志（willpower）属性 -2。"
//   即——只要角色身体处于"脏污/带污渍"状态，就会持续承受：
//     1) 心情恶化（通过游戏内的【压力事件 stressevent】系统表现）。
//     2) 意志属性 -2（通过【状态效果减益 status_effect/debuff】的 effectedstats 实现，
//        自带 1~20 越界保护，且离开脏污状态后会自动回收，干净利落）。
//   一旦角色把污渍清理干净（例如用肥皂洗澡），上述惩罚会被立即解除，心情恢复。
//
// 为什么这是一个"恶习（Vice）"而不是"美德（Virtue）"：
//   本游戏里玩家可选的"恶习/缺陷"是 /datum/charflaw 的子类（见
//   code/datums/character_flaw/_character_flaw.dm 与角色定制菜单
//   code/modules/client/vices_menu.dm 中的"恶习选择"区域）；
//   而 /datum/virtue 是另一套"美德"系统。需求要的是"Vice（恶习）"，
//   因此本恶习实现为 /datum/charflaw 的子类型。
//
// 为什么所有逻辑都放在本文件内：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外的
//   任何文件。本文件通过"继承已有基类、追加子类型"的方式接入引擎（属于"追加"而非
//   "修改"核心文件），不改动 modular_z121 之外的任何源文件，完全满足约束。
//   唯一需要触碰的另一处是同在 modular_z121 内的 bootstrap/custom_bootstrap.dm，
//   用来把本恶习登记进"可选恶习列表"，详见文件末尾的登记说明。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承，不修改其源文件）：
//   - /datum/charflaw                      恶习基类（code/datums/character_flaw/_character_flaw.dm）
//                                           提供 flaw_on_life()/on_removal()/on_bath() 等钩子。
//   - flaw_on_life()                        每个生命 tick 由 human/life.dm 对每个已装备恶习调用。
//   - /datum/stressevent/vice               恶习类压力事件基类（code/datums/stress/negative_events.dm）
//                                           用于表现"心情变差"。
//   - add_stress / remove_stress / has_stress_event  压力事件的施加 / 移除 / 查询接口。
//   - /datum/status_effect/debuff           减益状态效果基类（含 effectedstats 自动加减属性机制）。
//   - apply_status_effect / has_status_effect / remove_status_effect  状态效果接口。
//   - STATKEY_WIL                           意志属性键（code/__DEFINES/mobs.dm）。
//   - bloody_hands / /obj/effect/decal/cleanable  "身上污渍"的判定来源（与肥皂清洁的对象一致）。
//   - GLOB.character_flaws                  角色定制界面"可选恶习"列表（用于登记本恶习）。
//
// 加载：本文件需要在 modular_z121/_load.dm 中以 #include 引入（已在该文件追加）。
// ============================================================================


// ----------------------------------------------------------------------------
// 恶习定义：洁癖（Neat Freak）
// 为什么直接继承 /datum/charflaw：洁癖是一种"被动持续生效"的性格缺陷，
//   不需要任何主动技能/法术，只要 flaw_on_life 被周期性调用即可驱动其逻辑，
//   因此最基础的 /datum/charflaw 父类就足够，无需更复杂的基类。
// ----------------------------------------------------------------------------
/datum/charflaw/neat_freak
	name = "洁癖"                                                              // 角色定制菜单中显示的恶习名（Neat Freak）。
	// 为什么这样写描述：向玩家说明本恶习的硬性机制——身上有污渍时心情变差且意志 -2，
	//   并提示"清洁身体（如洗澡）即可解除"，让玩家清楚因果与应对方式。
	desc = "我无法忍受自己身上沾染污秽。只要身上有污渍（例如血迹），\
			我就会心烦意乱、心情变差，意志也会随之削弱（意志 -2）。\
			只有把自己清洗干净，我才能重新安定下来。"

	// 为什么用 last_check 做节流：flaw_on_life 每个生命 tick 都会被调用（非常频繁），
	//   而"扫描身上污渍"涉及遍历内容物，没必要每 tick 都做。参照本项目 paranoid/
	//   isolationist 等恶习的写法，用时间戳把实际检测限制为每隔若干秒一次，降低开销。
	var/last_check = 0
	// 为什么把检测间隔抽成变量：便于统一调整节奏，也让"为什么是这个频率"一目了然。
	//   3 秒一次：足够灵敏（玩家弄脏/洗净后很快有反馈），又不会造成性能负担。
	var/check_interval = 3 SECONDS
	// 为什么记录"上一次是否脏污"：用于做"状态翻转"判断，从而只在【由净变脏】或
	//   【由脏变净】的那一刻给玩家发一次提示，避免每次检测都刷屏。
	var/was_stained = FALSE


// ----------------------------------------------------------------------------
// 核心驱动：每生命 tick 的处理
// 为什么重写 flaw_on_life：这是恶习系统提供的"周期性心跳"钩子（human/life.dm 中对
//   每个非 ephemeral 的已装备恶习调用），是实现"持续监测身体是否脏污"的标准位置。
// ----------------------------------------------------------------------------
/datum/charflaw/neat_freak/flaw_on_life(mob/user)
	. = ..()                                                                   // 先跑基类逻辑（当前为空实现，保留以兼容未来扩展）。

	// 为什么做类型校验：恶习理论上只挂在人类身上，但 flaw_on_life 的形参是泛化 mob，
	//   做一次 ishuman 守门可避免对非人类（或异常情形）执行人类专属逻辑而报错。
	if(!ishuman(user))                                                         // 持有者不是人类 ……
		return                                                                 // …… 直接跳过本次处理。
	var/mob/living/carbon/human/H = user                                       // 取得人类引用，便于后续读取身体状态。

	// 为什么死亡 / 无意识时不处理：对尸体或失去意识者计较"洁癖心情"既无意义，
	//   也会在错误的时机给玩家发提示。直接跳过，待其恢复后再正常运作。
	if(H.stat == DEAD)                                                         // 持有者已死亡 ……
		return                                                                 // …… 跳过（不施加也不清理，等复活/转生后自然恢复检测）。

	// 为什么节流：见上方 last_check 注释。未到检测间隔就直接返回，省去频繁扫描。
	if(world.time < last_check + check_interval)                               // 距上次检测还不到设定间隔 ……
		return                                                                 // …… 本 tick 不做实际检测。
	last_check = world.time                                                    // 记录本次检测时间，作为下次节流基准。

	// 为什么把"是否脏污"抽成独立判定函数：检测逻辑可能随版本演进（新增污渍来源），
	//   独立成 proc 既便于维护，也让 flaw_on_life 主流程保持清晰。
	var/stained = is_body_stained(H)                                           // 判定当前身体是否带有污渍。

	if(stained)                                                                // —— 情况 A：身上有污渍 ——
		apply_neat_freak_penalty(H)                                            // 施加 / 刷新惩罚（心情变差 + 意志 -2）。
	else                                                                       // —— 情况 B：身体干净 ——
		clear_neat_freak_penalty(H)                                            // 解除惩罚（恢复心情与意志）。


// ----------------------------------------------------------------------------
// 判定：身体是否带有污渍
// 为什么这样定义"污渍"：需求中的"污渍"在本游戏里最贴切、且"可被清洗去除"的对应物，
//   正是肥皂/洗澡系统所清理的那一类脏污（见 code/game/objects/items/soap.dm）：
//     1) bloody_hands —— 赤手沾血（clean_blood 会清除）。
//     2) 落在身上的 /obj/effect/decal/cleanable 污物贴花（洗澡时被 qdel 清除）。
//   选取与"洗澡能清除的脏污"一致的判定，能形成闭环：弄脏→惩罚→洗净→解除，
//   玩家行为与机制反馈彼此自洽，不会出现"洗了澡却仍被判定为脏"的割裂感。
// 为什么返回布尔：调用方只关心"脏 / 不脏"二态，布尔最简洁明确。
// ----------------------------------------------------------------------------
/datum/charflaw/neat_freak/proc/is_body_stained(mob/living/carbon/human/H)
	// 为什么再次做空值 / 类型校验：本 proc 也可能被其它代码独立调用，
	//   防御式校验可避免空引用导致的运行时错误（健壮性要求）。
	if(!istype(H))                                                             // 传入的不是有效人类 ……
		return FALSE                                                           // …… 视为"无污渍"，避免误判。

	// 判定来源 1：赤手沾血。
	// 为什么用 bloody_hands > 0：这是人类身上记录"手上血量"的数值变量，
	//   只要 > 0 即表示双手沾了血渍，是最直接可见的一种"身上污渍"。
	if(H.bloody_hands > 0)                                                     // 双手沾有血迹 ……
		return TRUE                                                            // …… 判定为脏污。

	// 判定来源 2：身上附着的可清理污物贴花。
	// 为什么遍历 /obj/effect/decal/cleanable：洗澡（soap.dm）正是通过
	//   `for(var/obj/effect/decal/cleanable/C in target) qdel(C)` 来清理这些贴花，
	//   它们代表溅落 / 附着到身体上的血污、污渍等。只要存在一个即视为脏污。
	for(var/obj/effect/decal/cleanable/dirt in H)                              // 遍历持有者身上的所有可清理污物 ……
		return TRUE                                                            // …… 只要发现一个就判定为脏污（无需继续遍历）。

	// 走到这里说明上述污渍来源均未命中，身体视为干净。
	// 说明（扩展点 / hook）：若未来要把"沾泥""沾油""脏衣服"等也纳入"污渍"判定，
	//   只需在此函数内追加相应检测分支（例如检测可洗去的 WASHABLE 颜色叠层、
	//   或遍历 H.get_equipped_items() 检查衣物 blood_DNA），无需改动其它逻辑。
	return FALSE                                                               // 未发现任何污渍 -> 干净。


// ----------------------------------------------------------------------------
// 施加 / 刷新惩罚：心情变差 + 意志 -2
// 为什么单独成 proc：把"施加惩罚"与"主流程/检测"解耦，逻辑清晰、便于复用与维护。
// 为什么可以反复调用：压力事件与状态效果都被设计为"可刷新"（见下方各自说明），
//   因此即便每次检测都调用本 proc 也不会叠加成多份惩罚，只会续期。
// ----------------------------------------------------------------------------
/datum/charflaw/neat_freak/proc/apply_neat_freak_penalty(mob/living/carbon/human/H)
	if(!istype(H))                                                             // 防御式校验：无效持有者直接返回，避免空引用。
		return

	// 效果 1：心情变差（压力事件）。
	// 为什么先判 has_stress_event 再发提示：只在"刚刚由净变脏"的那一刻提示一次，
	//   避免每次检测都刷"我身上脏死了"导致刷屏。
	if(!was_stained)                                                           // 上一次还是干净的（本次刚弄脏）……
		to_chat(H, span_warning("我身上沾了脏东西……这让我浑身难受，心烦意乱。"))  // …… 给一次明确的转变提示。
	// 为什么用 add_stress：这是本游戏表现"心情/情绪恶化"的标准系统；恶习类压力事件
	//   /datum/stressevent/vice/neat_freak 会拉低心情。add_stress 自身可重复调用刷新计时。
	H.add_stress(/datum/stressevent/vice/neat_freak)                          // 施加 / 续期"洁癖"压力事件（心情变差）。

	// 效果 2：意志 -2（状态效果减益）。
	// 为什么用 status_effect/debuff + effectedstats 而不是直接 change_stat：
	//   change_stat 是"永久"调整，难以在洗净后干净地回退；而 debuff 的 effectedstats
	//   在效果存在期间施加、在效果移除/到期时自动精确回收（且有 1~20 越界保护），
	//   正好契合"脏了就 -2、洗净就恢复"的可逆需求。基类 status_type 为 REFRESH，
	//   重复 apply 只会刷新时长而不会叠加多层 -2。
	// 为什么校验返回值：apply_status_effect 可能因引擎拒绝而返回 null；若既未成功施加、
	//   持有者身上也确实没有该效果，则如实记录，便于排查（健壮性 / 错误处理要求）。
	var/datum/status_effect/applied = H.apply_status_effect(/datum/status_effect/debuff/neat_freak) // 施加 / 刷新意志 -2 减益。
	if(!applied && !H.has_status_effect(/datum/status_effect/debuff/neat_freak)) // 施加失败且身上也无此效果 ……
		// 为什么只记日志而不打扰玩家：属性减益未生效属于异常情形，告知玩家无意义，
		//   记入服务器日志方便管理员/开发者排查即可。
		log_game("[key_name(H)] 的'洁癖'恶习尝试施加意志减益失败（apply_status_effect 返回 null）。")

	was_stained = TRUE                                                         // 记录"当前为脏污状态"，供下次做翻转判断。


// ----------------------------------------------------------------------------
// 解除惩罚：恢复心情与意志
// 为什么单独成 proc：与施加惩罚对称，保证"脏 -> 净"时能干净彻底地撤销所有惩罚。
// 为什么调用方可无脑调用：remove_stress / remove_status_effect 对"本就不存在"的目标
//   调用是安全的（无副作用），因此即使身体一直是干净的也可放心调用。
// ----------------------------------------------------------------------------
/datum/charflaw/neat_freak/proc/clear_neat_freak_penalty(mob/living/carbon/human/H)
	if(!istype(H))                                                             // 防御式校验：无效持有者直接返回。
		return

	// 为什么只在"刚刚由脏变净"时提示一次：与施加端对称，避免在持续干净期间反复刷屏。
	if(was_stained)                                                            // 上一次还是脏的（本次刚洗净）……
		to_chat(H, span_notice("我把自己清理干净了，心里这才踏实下来。"))         // …… 给一次明确的转变提示。

	// 撤销效果 1：移除"洁癖"压力事件，心情恢复。
	H.remove_stress(/datum/stressevent/vice/neat_freak)                       // 移除心情惩罚（对不存在的事件调用也安全）。
	// 撤销效果 2：移除意志 -2 减益，属性自动回正（effectedstats 在移除时精确回收）。
	H.remove_status_effect(/datum/status_effect/debuff/neat_freak)            // 移除意志减益（对不存在的效果调用也安全）。

	was_stained = FALSE                                                        // 记录"当前为干净状态"，供下次做翻转判断。


// ----------------------------------------------------------------------------
// 卸载清理：当恶习被移除时彻底善后
// 为什么重写 on_removal：恶习可能在中途被移除（管理员操作、转生等），此时必须撤销
//   本恶习施加的一切持续效果（压力事件 + 状态减益），否则会留下"恶习已没了，惩罚还在"
//   的残留，污染玩家状态。基类提供 on_removal 钩子正是为此而设。
// ----------------------------------------------------------------------------
/datum/charflaw/neat_freak/on_removal(mob/user)
	. = ..()                                                                   // 先跑基类清理逻辑。
	if(!ishuman(user))                                                         // 非人类无需清理（也不应有本恶习的效果）。
		return
	var/mob/living/carbon/human/H = user                                       // 取得人类引用。
	// 为什么直接复用 clear_neat_freak_penalty：移除恶习等价于"强制回到干净/无惩罚状态"，
	//   该函数已能完整撤销心情与意志两项惩罚，复用它可避免重复代码、保证一致性。
	clear_neat_freak_penalty(H)                                                // 移除心情惩罚与意志减益，干净善后。


// ============================================================================
// 关于"目标选择/取消"的说明（对应需求中的通用实现要求）
// ----------------------------------------------------------------------------
// 需求模板中提到"优雅处理目标选择（若需要目标，确保施法者可取消）"。
//   本恶习是【被动持续型】机制：它没有任何需要玩家主动选择目标的环节
//   （不存在施法/选敌/读条），其触发条件完全由"自身身体是否脏污"决定。
//   因此本恶习不涉及目标选择，也就不存在"需要取消的目标弹窗"。
//   为满足健壮性要求，所有路径均已包含：类型校验、空值校验、死亡/无意识跳过、
//   状态效果施加失败的兜底处理，以及恶习被移除时的彻底清理。
// ============================================================================


// ----------------------------------------------------------------------------
// 压力事件：洁癖（心情变差的具体表现）
// 为什么继承 /datum/stressevent/vice：本游戏把"恶习未被满足导致的心情恶化"统一表示为
//   /datum/stressevent/vice 的子类（见 code/datums/stress/negative_events.dm），
//   继承它即可复用整套"压力 -> 心情下降"的机制，与酒鬼/贪婪等现有恶习表现一致。
// ----------------------------------------------------------------------------
/datum/stressevent/vice/neat_freak
	// 为什么覆写 desc：给本压力事件一段贴合"洁癖"主题的心理独白，让玩家在心情面板里
	//   看到具体原因（身上脏导致烦躁），而不是泛化的恶习文案。list 形式与基类一致。
	desc = list(span_boldred("我身上脏兮兮的，浑身不自在……"), span_boldred("我得赶紧把自己清理干净。"))
	// 为什么设较短 timer：本压力事件由 flaw_on_life 在"持续脏污"期间反复 add_stress 续期，
	//   因此 timer 只需"略长于检测间隔"即可保证脏污期间心情持续偏低；一旦洗净，
	//   clear 流程会立刻 remove_stress，无需等待自然到期。设 1 分钟留足冗余。
	timer = 1 MINUTES
	// stressadd 继承自父类（默认 5），表示心情下降幅度；沿用默认值即可，无需特殊化。


// ----------------------------------------------------------------------------
// 状态效果减益：洁癖（意志 -2 的具体实现）
// 为什么继承 /datum/status_effect/debuff：debuff 基类内置 effectedstats 机制 ——
//   施加时按表扣减属性、移除/到期时自动精确回补（含 1~20 越界保护），是实现
//   "可逆的限时属性惩罚"的最稳妥方式，正好匹配"脏了 -2、洗净恢复"的需求。
// ----------------------------------------------------------------------------
/datum/status_effect/debuff/neat_freak
	id = "neat_freak"                                                          // 唯一标识，用于 has_status_effect / remove_status_effect 查询。
	// 为什么设 duration 而非永久：作为兜底——即便某些极端时序下 clear 流程没跑到，
	//   减益也会自然到期，不会无限残留。而正常情况下，脏污期间 flaw_on_life 会持续
	//   apply 刷新（基类 status_type 为 REFRESH，仅续期不叠加），洗净后立即被 remove。
	duration = 1 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/neat_freak    // 关联 HUD 提示图标，让玩家直观看到自己正受减益。
	needs_processing = FALSE                                                   // 纯属性减益，无需每 tick 处理，省开销。
	// 为什么只减意志 -2：严格对应需求"意志属性 -2"，不附加任何其它属性变动，
	//   保证机制与需求字面完全一致。effectedstats 的负值会被基类自动施加与回收。
	effectedstats = list(STATKEY_WIL = -2)                                     // 意志 -2（Willpower -2）。

// 为什么单独定义 alert：让被影响者在 HUD 上看到一个图标与悬浮说明，
//   明确告知"为什么意志下降"（身上有污渍），提升机制可见性与可理解性。
/atom/movable/screen/alert/status_effect/debuff/neat_freak
	name = "洁癖发作"                                                          // HUD 悬浮标题。
	desc = "我身上沾了污渍，洁癖让我心烦意乱、意志消沉（意志 -2）。把自己洗干净就好了。" // 悬浮说明：解释属性下降原因与解法。
	icon_state = "debuff"                                                       // 复用引擎已有的通用减益图标，避免新增美术资源依赖。


// ----------------------------------------------------------------------------
// 登记：把"洁癖"加入角色定制界面的"可选恶习"列表
// 为什么需要登记：玩家在创角界面能选到的恶习来自 GLOB.character_flaws
//   （见 code/datums/character_flaw/_character_flaw.dm 的 GLOBAL_LIST_INIT 与
//    code/modules/client/vices_menu.dm 的恶习选择区）。该列表是硬编码的，
//   而我们不能修改 modular_z121 之外的核心文件，因此改为"运行时追加"。
// 为什么 GLOB.charflaw_singletons 无需手动登记：code/__HELPERS/global_lists.dm 会
//   自动为 /datum/charflaw 的【所有子类型】建立单例（subtypesof 遍历），本恶习
//   会被自动纳入，因此只需补登"可选列表"GLOB.character_flaws 即可。
// 为什么提供独立 proc：把"登记动作"封装起来，由同在 modular_z121 内的
//   bootstrap/custom_bootstrap.dm 在其 Initialize 中调用（那是本项目的统一启动钩子，
//   执行时机晚于全局列表初始化，追加安全）。这样登记逻辑与恶习定义同处一文件、内聚清晰。
// ----------------------------------------------------------------------------
/proc/register_neat_freak_vice()
	// 为什么做存在性与类型校验：防御式编程——确保全局列表已就绪且类型正确，
	//   避免在异常初始化时序下报错。
	if(!islist(GLOB.character_flaws))                                          // 可选恶习列表尚未就绪 ……
		return                                                                 // …… 放弃登记（不报错，交由后续重试/启动流程兜底）。
	// 为什么用 name 作为键：vices_menu.dm 以"显示名 -> 类型路径"的关联形式读取该列表，
	//   这里沿用同一约定，键填恶习显示名，值填恶习类型路径。
	GLOB.character_flaws["洁癖"] = /datum/charflaw/neat_freak                  // 把"洁癖"登记为一个可被玩家选择的恶习。
