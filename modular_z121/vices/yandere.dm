// ============================================================================
// modular_z121/vices/yandere.dm
// 自定义恶习（Custom Vice / 恶习）：病娇 / Yandere
// ----------------------------------------------------------------------------
// 需求（为什么要做这个文件）：
//   实现一个全新的"病娇（Yandere）"恶习，进入游戏后：
//     1) 随机指定场上的某位【玩家】作为"暗恋对象（crush）"。
//     2) 自动习得【寻人术】（Person Searching Technique），方便追踪暗恋对象。
//     3) 把暗恋对象自动加入"熟人名单（known_people / 相识之人）"。
//     4) 当能【看见】暗恋对象时——心情达到顶峰（强力正面情绪）。
//     5) 当【看不见】暗恋对象时——心情持续变差（负面情绪逐级累加）。
//     6) 当超过 5 分钟看不见暗恋对象时——会不断地嘶喊对方的名字。
//
// 为什么这是一个"恶习（Vice）"而不是"美德（Virtue）"：
//   本游戏里玩家可选的"恶习/缺陷"是 /datum/charflaw 的子类（见
//   code/datums/character_flaw/_character_flaw.dm 与角色定制菜单
//   code/modules/client/vices_menu.dm 的"恶习选择"区域）；/datum/virtue 是另一套
//   "美德"系统。需求要的是"Vice（恶习）"，故本恶习实现为 /datum/charflaw 的子类型。
//
// 为什么所有逻辑都放在本文件内（合规性说明）：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外的任何
//   文件。本文件通过"继承已有基类、追加子类型 / 追加运行时登记"的方式接入引擎（属于
//   "追加"而非"修改"核心文件），不改动 modular_z121 之外的任何源文件。唯一需要触碰的
//   另一处是同在 modular_z121 内的 bootstrap/custom_bootstrap.dm，用于把本恶习登记进
//   "可选恶习列表"，详见文件末尾的登记说明。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承，不修改其源文件）：
//   - /datum/charflaw                       恶习基类，提供 on_mob_creation/flaw_on_life/on_removal 钩子。
//   - flaw_on_life()                         每个生命 tick 由 human/life.dm 对每个已装备非 ephemeral 恶习调用。
//   - /datum/mind/AddSpell() / RemoveSpell() 动态授予 / 收回法术（code/datums/mind.dm）。
//   - /obj/effect/proc_holder/spell/self/locate_person  本项目自定义的【寻人术】
//                                            （modular_z121/spells/arcane/locate_person.dm）。
//   - /datum/mind/i_know_person()            把某人加入"我"的 known_people 熟人名单（code/datums/mind.dm）。
//   - /datum/stressevent + add_stress/remove_stress/has_stress_event  心情/情绪系统（code/datums/stress 与
//                                            code/modules/mob/living/carbon/stress.dm）。
//   - can_see()                              简易视线判定（code/__HELPERS/unsorted.dm）。
//   - /mob/living/say() / emote()            让角色"喊出"暗恋对象的名字。
//   - GLOB.human_list                        遍历场上人类以挑选暗恋对象 / 解析暗恋对象引用。
//   - GLOB.character_flaws                   角色定制界面"可选恶习"列表（用于登记本恶习）。
//
// 加载：本文件需在 modular_z121/_load.dm 中以 #include 引入（已在该文件追加）。
// ============================================================================


// ----------------------------------------------------------------------------
// 可调参数（#define）。集中放在文件顶部，便于统一调节节奏，并在文件末尾 #undef，
// 避免污染全局宏命名空间（与本项目其它自定义法术文件的写法保持一致）。
// ----------------------------------------------------------------------------
// 为什么要做检测节流：flaw_on_life 每个生命 tick 都会被调用（非常频繁），而"找暗恋
//   对象、算视线、改心情"没必要每 tick 都跑。3 秒一次：既灵敏又不造成性能负担。
#define YANDERE_CHECK_INTERVAL (3 SECONDS)
// 为什么单列视线判定距离：can_see 需要一个最大距离参数；取略大于默认屏幕视野
//   （world.view 通常为 7）的值，保证"屏幕里能看到就算看见"，避免边缘误判为看不见。
#define YANDERE_SIGHT_RANGE 9
// 为什么是 5 分钟：严格对应需求"看不见超过 5 分钟就不断嘶喊名字"的阈值。
#define YANDERE_ABSENCE_SCREAM_THRESHOLD (5 MINUTES)
// 为什么给嘶喊设冷却：避免每个检测 tick 都喊导致刷屏/刷音；约 12~18 秒喊一次，
//   既表现出"病态执念"，又不至于完全占满聊天与音效通道。
#define YANDERE_SCREAM_COOLDOWN_MIN (12 SECONDS)
#define YANDERE_SCREAM_COOLDOWN_MAX (18 SECONDS)
// 为什么指定暗恋对象要可重试：游戏刚开局时其他玩家可能尚未完全生成（仍在创角/读条），
//   一次找不到就等一会儿再找，直到场上出现可作为暗恋对象的玩家为止。
#define YANDERE_DESIGNATE_RETRY (30 SECONDS)
// 为什么有初始延迟：on_mob_creation 触发时本人/他人都可能还没准备好（mind 未就绪、
//   仍在 advsetup）。先等一小段时间再尝试指定，能拿到更稳定、更完整的玩家快照。
#define YANDERE_INITIAL_DELAY (15 SECONDS)


// ----------------------------------------------------------------------------
// 恶习定义：病娇（Yandere）
// 为什么直接继承 /datum/charflaw：病娇是一种"被动持续生效"的性格缺陷，靠 flaw_on_life
//   周期性驱动即可，不需要更复杂的基类。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere
	name = "病娇"                                                              // 角色定制菜单中显示的恶习名（Yandere）。
	// 为什么这样写描述：向玩家说明核心机制——开局随机暗恋一名玩家、自动获得寻人术、
	//   见到对方时心花怒放、见不到时心情每况愈下，久久不见还会失控地呼喊其名。
	desc = "我的心里只装得下一个人。进入这个世界后，我会不由自主地深深爱上某个人。\
			我天生懂得【寻人术】，能循着 ta 的气息找到 ta，并把 ta 牢牢记在心里。\
			只要能看见心爱之人，我便心花怒放；一旦见不到 ta，我就坐立难安、心情每况愈下；\
			若太久见不到 ta，我会失了分寸，一遍又一遍地呼喊 ta 的名字……"

	// —— 暗恋对象的标识 ——
	// 为什么同时存"弱引用 + 名字"：弱引用（WEAKREF）能在对象被删除（如被碎尸/gib）时
	//   安全失效、不阻止 GC，是持有"另一个 mob"的标准安全做法；而名字（real_name）作为
	//   兜底——即便弱引用因故失效、但同名肉体仍在场上，也能像寻人术那样按名字找回，
	//   提升健壮性。两者配合，既不内存泄漏，又尽量不"丢失"暗恋对象。
	var/datum/weakref/crush_ref = null                                         // 暗恋对象的弱引用。
	var/crush_name = null                                                      // 暗恋对象的真名（兜底查找用，也用于嘶喊与提示文案）。

	// —— 流程状态 ——
	// 为什么需要 designated 标志：暗恋对象只指定一次；指定成功后就不再重复挑选，
	//   否则会"见异思迁"，与"病娇专一"的设定相悖。
	var/designated = FALSE                                                     // 是否已成功指定暗恋对象。
	// 为什么记录下次可尝试指定的时间：指定可能因"暂时没有可选玩家"而失败，需要隔一段时间
	//   重试；用时间戳节流重试频率，避免每 tick 都做一次全表扫描。
	var/next_designate_attempt = 0                                             // 下一次允许尝试"指定暗恋对象"的世界时间。

	// 为什么记录是否由本恶习授予了寻人术：玩家也可能本来就会寻人术。只有"确实是我们授予的"
	//   才在恶习移除时收回，避免误删玩家自己习得的法术（健壮性 / 不破坏玩家既有状态）。
	var/granted_spell = FALSE                                                  // 寻人术是否由本恶习授予。

	// —— 周期性逻辑的节流与计时 ——
	var/last_check = 0                                                         // 上次执行核心检测的时间（节流用）。
	// 为什么把"上次看见的时间"独立记录：需求 6 要求"看不见超过 5 分钟才嘶喊"，必须记下
	//   最近一次看见暗恋对象的时刻，才能算出"已经多久没见到"。
	var/last_seen_time = 0                                                     // 最近一次"看见暗恋对象"的世界时间。
	var/next_scream = 0                                                        // 下一次允许嘶喊的世界时间（嘶喊冷却）。
	// 为什么记住"上次能否看见"：用于做状态翻转判断，从而只在【由见到变看不见】或
	//   【由看不见变见到】的那一刻给玩家发一次提示，避免每个检测 tick 都刷屏。
	var/was_visible = TRUE                                                     // 上一次检测时是否能看见暗恋对象。


// ----------------------------------------------------------------------------
// 创建钩子：恶习刚挂到角色身上时
// 为什么重写 on_mob_creation：在这里给"首次指定暗恋对象"设一个初始延迟。
//   注意——此刻角色的 mind 往往尚未就绪（参见 badsight 等恶习的注释），因此这里
//   绝不立刻指定，只设定"最早可在 YANDERE_INITIAL_DELAY 之后尝试"，真正的指定放到
//   flaw_on_life 里反复重试（那时 mind / 其他玩家更可能已经就绪）。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere/on_mob_creation(mob/user)
	. = ..()                                                                   // 先跑基类逻辑（当前为空实现，保留以兼容未来扩展）。
	// 为什么把"最近看见时间"先设为当前时刻：避免恶习一上身、暗恋对象还没指定时，
	//   就因为 last_seen_time=0 而被判定为"已经几百分钟没见到"从而立刻开始嘶喊。
	last_seen_time = world.time
	// 设定首次指定的最早时间（给世界一点时间把所有玩家生成完毕）。
	next_designate_attempt = world.time + YANDERE_INITIAL_DELAY


// ----------------------------------------------------------------------------
// 核心驱动：每生命 tick 的处理
// 为什么重写 flaw_on_life：这是恶习系统提供的"周期性心跳"钩子（human/life.dm 对每个
//   非 ephemeral 的已装备恶习调用），是实现"持续指定 / 持续监测视线与心情"的标准位置。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere/flaw_on_life(mob/user)
	. = ..()                                                                   // 先跑基类逻辑。

	// 为什么做类型校验：恶习理论上只挂在人类身上，但 flaw_on_life 形参是泛化 mob；
	//   一次 ishuman 守门可避免对非人类执行人类专属逻辑而报错（健壮性）。
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user                                       // 取得人类引用。

	// 为什么死亡时不处理：对尸体计较"病娇心情/嘶喊"既无意义，也会在错误时机打扰玩家。
	//   待其复活/转生后自然恢复处理。
	if(H.stat == DEAD)
		return

	// 节流：未到检测间隔就直接返回，省去频繁扫描与运算。
	if(world.time < last_check + YANDERE_CHECK_INTERVAL)
		return
	last_check = world.time                                                    // 记录本次检测时间，作为下次节流基准。

	// —— 阶段一：若尚未指定暗恋对象，则尝试指定 ——
	// 为什么放在每 tick（节流后）里反复尝试：开局玩家陆续就绪，单次尝试可能失败；
	//   反复重试可保证"只要场上出现合适的玩家，就一定会指定一个暗恋对象"。
	if(!designated)
		// 仍在等待初始延迟 / 重试间隔时，本次不尝试。
		if(world.time < next_designate_attempt)
			return
		try_designate_crush(H)                                                 // 尝试指定（成功会把 designated 置 TRUE）。
		return                                                                 // 指定当 tick 不再继续往下走（等下一 tick 进入正常监测）。

	// —— 阶段二：已指定暗恋对象，进入"视线 + 心情 + 嘶喊"的常规监测 ——
	process_crush_state(H)


// ----------------------------------------------------------------------------
// 指定暗恋对象（需求 1/2/3 的落地点）
// 为什么单独成 proc：把"一次性指定 + 授予寻人术 + 加入熟人"的复合逻辑与主循环解耦，
//   便于阅读、重试与维护。
// 为什么需要 mind：授予法术（AddSpell）与加入熟人名单（i_know_person）都依赖角色的 mind；
//   若此刻 mind 还没就绪，就推迟到下次重试，不强行执行以免空引用。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere/proc/try_designate_crush(mob/living/carbon/human/H)
	if(!istype(H))                                                             // 防御式校验：无效持有者直接返回。
		return
	// 为什么先安排好"下次重试时间"：无论本次成功与否，都先把重试时钟往后拨，
	//   这样即便中途 return 也不会出现"同一 tick 反复全表扫描"的情况。
	next_designate_attempt = world.time + YANDERE_DESIGNATE_RETRY

	// mind 未就绪 -> 推迟重试（AddSpell / i_know_person 都要用到 mind）。
	if(!H.mind)
		return
	// 角色仍在高级创角流程中（advsetup）-> 推迟，等其完全成型再指定，拿到稳定快照。
	if(H.advsetup)
		return

	// 收集"可作为暗恋对象"的候选玩家。
	var/list/candidates = get_crush_candidates(H)
	if(!length(candidates))
		// 为什么不报错只静默重试：开局或孤身一人时场上确实可能没有合适对象，
		//   这是正常情形；等以后有玩家出现时下一次重试自然会成功。
		return

	// 从候选中随机挑一个作为暗恋对象（需求 1："随机指定一名玩家"）。
	var/mob/living/carbon/human/crush = pick(candidates)
	if(!istype(crush))                                                         // 极端兜底：挑出来的不是有效人类则放弃本次，等待重试。
		return

	// 记录暗恋对象（弱引用 + 真名，原因见字段定义处注释）。
	crush_ref = WEAKREF(crush)
	crush_name = crush.real_name
	designated = TRUE                                                          // 标记"已指定"，今后不再重新挑人（病娇专一）。
	last_seen_time = world.time                                               // 以指定时刻作为"最近看见"的起点，避免立刻触发嘶喊。

	// 需求 2：自动习得【寻人术】。
	grant_locate_spell(H)

	// 需求 3：把暗恋对象自动加入"我"的熟人名单（known_people）。
	// 为什么用 i_know_person：这是引擎里"把某人记进我的相识名单"的标准接口；加入后，
	//   寻人术（只允许追踪 known_people 里的人）就能顺理成章地锁定这位暗恋对象，
	//   两个需求点（熟人 + 寻人术）由此自洽地联动起来。
	if(H.mind)
		H.mind.i_know_person(crush)

	// 给玩家一段私密的"心动揭示"提示（只有病娇本人知道暗恋对象是谁）。
	to_chat(H, span_boldnotice("我的心猛地一颤……我深深地爱上了 [crush_name]。\
		从今往后，我的世界里只有 ta。我必须时时刻刻知道 ta 在哪里。"))
	// 心动当下也给一点点正面情绪铺垫（轻微，不喧宾夺主；真正的"顶峰"留给"看见"时）。
	to_chat(H, span_green("只是想到 ta，我的心里就泛起一阵甜蜜。"))


// ----------------------------------------------------------------------------
// 收集候选暗恋对象
// 为什么这样筛选："随机指定一名玩家"——所以候选必须是【真正的玩家】（有 ckey 的角色），
//   而非 NPC；必须不是自己；必须活着（暗恋一具一开局就是的尸体没有意义）；必须有 mind。
//   同时排除掉同样患有病娇恶习者也不必要——这里不做该排除，允许互相暗恋，更有戏剧性。
// 为什么允许 SSD（暂时掉线）玩家：用 ckey 而非 client 判定"是否玩家"，这样即便对方
//   此刻短暂掉线，其肉体仍是一名玩家角色，依然是合理的暗恋对象。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere/proc/get_crush_candidates(mob/living/carbon/human/H)
	var/list/candidates = list()
	for(var/mob/living/carbon/human/other in GLOB.human_list)
		if(other == H)                                                         // 不能暗恋自己。
			continue
		if(QDELETED(other))                                                    // 跳过正在被删除的无效对象。
			continue
		if(!other.ckey)                                                        // 没有 ckey -> 不是玩家角色（NPC）-> 排除。
			continue
		if(!other.mind)                                                        // 没有 mind 的异常对象 -> 排除。
			continue
		if(other.stat == DEAD)                                                 // 一开局就是死人 -> 排除（暗恋对象应当是活人）。
			continue
		candidates += other
	return candidates


// ----------------------------------------------------------------------------
// 授予【寻人术】
// 为什么先查 has_spell：玩家也许本就会寻人术（自己学的）。仅在其尚未拥有时才授予，
//   并用 granted_spell 标记"这是我们给的"，以便恶习移除时只收回我们自己授予的那一份，
//   绝不误删玩家自学的法术（健壮性 / 不破坏既有状态）。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere/proc/grant_locate_spell(mob/living/carbon/human/H)
	if(!H.mind)                                                                // 没有 mind 无法挂载法术 -> 放弃（理论上调用前已校验，这里再兜一层）。
		return
	if(H.mind.has_spell(/obj/effect/proc_holder/spell/self/locate_person))     // 已经会寻人术（玩家自学或重复授予）……
		return                                                                 // …… 不重复授予，也不标记为"我们给的"。
	// 新建一份寻人术实例并授予。AddSpell 会把它加入 spell_list 并在角色 HUD 上挂出技能按钮。
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/locate_person(null))
	granted_spell = TRUE                                                       // 标记：这份寻人术是本恶习授予的，移除恶习时应当收回。
	to_chat(H, span_green("一种本能在我心底苏醒——我学会了【寻人术】，能循着爱人的气息找到 ta。"))


// ----------------------------------------------------------------------------
// 解析当前的暗恋对象引用
// 为什么这样找：优先用弱引用解析（最快、最准）；解析失败（对方被删除/弱引用失效）时，
//   再按真名遍历 GLOB.human_list 兜底（与寻人术 find_known_human 同思路），尽量不"丢人"。
// 为什么返回 null 是合法结果：当暗恋对象彻底不存在（被碎尸 gib / 永久离场）时返回 null，
//   调用方据此把"看不见"逻辑跑起来（心情变差 + 嘶喊），这恰恰符合病娇设定。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere/proc/resolve_crush()
	// 路径一：弱引用解析。
	var/mob/living/carbon/human/crush = crush_ref?.resolve()
	if(istype(crush) && !QDELETED(crush))
		return crush
	// 路径二：按真名兜底查找（弱引用失效，但可能有同名肉体仍在场）。
	if(crush_name)
		for(var/mob/living/carbon/human/other in GLOB.human_list)
			if(QDELETED(other))
				continue
			if(other.real_name == crush_name)
				// 找回后顺手刷新弱引用，让下次解析重新走快路径。
				crush_ref = WEAKREF(other)
				return other
	return null                                                                // 实在找不到 -> 暗恋对象当前不可达。


// ----------------------------------------------------------------------------
// 常规监测：视线 + 心情 + 嘶喊（需求 4/5/6 的落地点）
// 为什么把这三件事合在一个 proc 里：它们都由"当前能否看见暗恋对象"这一个判断分流，
//   合在一起能保证三者状态始终一致（看见=正面情绪、清零不见计时；看不见=负面情绪累加、
//   到点嘶喊），避免分散后出现自相矛盾的中间态。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere/proc/process_crush_state(mob/living/carbon/human/H)
	if(!istype(H))                                                             // 防御式校验。
		return

	var/mob/living/carbon/human/crush = resolve_crush()                        // 解析暗恋对象（可能为 null，表示彻底不可达）。
	// 判定"此刻能否看见暗恋对象"：对象存在、且视线判定通过，才算看见。
	var/can_see_crush = (crush && can_see_crush(H, crush))

	if(can_see_crush)
		handle_seeing_crush(H)                                                 // 看见 -> 心情达到顶峰，并清零"不见"计时。
	else
		handle_missing_crush(H)                                                // 看不见 -> 心情持续变差，必要时嘶喊其名。


// ----------------------------------------------------------------------------
// 视线判定：当前能否看见暗恋对象
// 为什么不只用 can_see：引擎的 can_see 只做"距离 + 沿途遮挡（opacity）"的近似判定，
//   不区分 z 层（楼层）。若暗恋对象在另一层但 x/y 恰好接近，get_dist 仍可能误判为"近"，
//   从而把"隔着楼层"错认成"看得见"。因此这里先强制要求"同一 z 层"，再交给 can_see。
// 为什么要求双方都在 turf 上：若任一方处于容器内/虚空（无 turf），谈不上"看见"，直接判否。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere/proc/can_see_crush(mob/living/carbon/human/H, mob/living/carbon/human/crush)
	if(!istype(H) || !istype(crush))                                           // 任一方无效 -> 看不见。
		return FALSE
	var/turf/my_turf = get_turf(H)
	var/turf/crush_turf = get_turf(crush)
	if(!my_turf || !crush_turf)                                                // 任一方不在地块上（在容器/虚空里）-> 看不见。
		return FALSE
	if(my_turf.z != crush_turf.z)                                              // 不在同一楼层 -> 看不见（弥补 can_see 不判 z 层的缺陷）。
		return FALSE
	// 距离 + 视线遮挡近似判定（沿途有不透明物体则视线被挡）。
	return can_see(H, crush, YANDERE_SIGHT_RANGE)


// ----------------------------------------------------------------------------
// 处理"看见暗恋对象"：心情达到顶峰（需求 4）
// 为什么用正面压力事件（stressadd 为负）：本游戏的"心情"由各压力事件的 stressadd 累加
//   决定，负值代表"心情变好"。给一个强负值（见 /datum/stressevent/yandere_bliss）即可让
//   心情冲到最高档（get_stress_threshold 中 <= -4 即 STRESS_THRESHOLD_NICE / "I feel great!"）。
// 为什么同时移除"思念"负面事件：看见与看不见是互斥状态，进入"看见"时必须清掉"看不见"
//   累加的负面情绪，否则两者并存会互相抵消，破坏"见到就心花怒放"的强烈对比。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere/proc/handle_seeing_crush(mob/living/carbon/human/H)
	// 状态翻转提示：仅在"由看不见 -> 看见"那一刻提示一次，避免持续看见时刷屏。
	if(!was_visible)
		to_chat(H, span_green("我看见 [crush_name] 了！我的心瞬间被幸福填满，全世界都明亮了起来。"))
	was_visible = TRUE                                                         // 记录当前为"看见"状态，供下次翻转判断。
	last_seen_time = world.time                                               // 刷新"最近看见时间"，重置 5 分钟嘶喊计时。

	// 施加 / 续期"心花怒放"正面情绪；移除"思念之苦"负面情绪（互斥处理）。
	H.add_stress(/datum/stressevent/yandere_bliss)
	H.remove_stress(/datum/stressevent/yandere_longing)


// ----------------------------------------------------------------------------
// 处理"看不见暗恋对象"：心情持续变差（需求 5），久未见则嘶喊其名（需求 6）
// 为什么用"可叠层"的负面压力事件：需求 5 是"心情【持续】变差"，即越久不见越难受。
//   /datum/stressevent/yandere_longing 设了 max_stacks 与 stressadd_per_extra_stack，
//   每个检测间隔 add_stress 一次就会把 stacks 往上叠一层（直到上限），从而实现"逐级恶化"；
//   一旦重新看见，handle_seeing_crush 会 remove_stress 把事件整体清掉，stacks 归零，
//   下次再不见时又从最轻一级重新累积——完美对应"见到回暖、不见恶化"的心情曲线。
// 为什么同时移除"心花怒放"正面事件：与"看见"分支对称，保证两种心情状态互斥、不并存。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere/proc/handle_missing_crush(mob/living/carbon/human/H)
	// 状态翻转提示：仅在"由看见 -> 看不见"那一刻提示一次，避免持续看不见时刷屏。
	if(was_visible)
		to_chat(H, span_warning("[crush_name] 不在我的视线里了……我开始坐立难安，心里空落落的。"))
	was_visible = FALSE                                                        // 记录当前为"看不见"状态，供下次翻转判断。

	// 施加 / 累加"思念之苦"负面情绪；移除"心花怒放"正面情绪（互斥处理）。
	H.add_stress(/datum/stressevent/yandere_longing)
	H.remove_stress(/datum/stressevent/yandere_bliss)

	// 需求 6：若"已经超过 5 分钟没看见"，则开始不断嘶喊暗恋对象的名字。
	// 为什么用 last_seen_time 计算：它只在"真正看见"时被刷新，因此
	//   (world.time - last_seen_time) 正是"连续看不见的时长"。
	if(world.time - last_seen_time >= YANDERE_ABSENCE_SCREAM_THRESHOLD)
		try_scream_crush_name(H)


// ----------------------------------------------------------------------------
// 嘶喊暗恋对象的名字（需求 6 的具体表现）
// 为什么用 say + emote 组合："喊名字"应当是周围人都能听见的发声行为：say 让名字作为
//   台词喊出来（forced 表示强制发声，不受玩家输入控制），emote("scream") 补一个嘶吼动作
//   与音效，二者叠加出"失控嘶喊"的效果。
// 为什么加冷却（next_scream）：避免每个检测 tick 都喊导致刷屏/刷音；约 12~18 秒一次，
//   既病态又不至于完全占满聊天与音效。
// 为什么校验意识状态：昏迷/被束缚说不出话时硬喊既不合理也可能触发引擎异常，故仅在清醒时喊。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere/proc/try_scream_crush_name(mob/living/carbon/human/H)
	if(!istype(H))                                                             // 防御式校验。
		return
	if(H.stat != CONSCIOUS)                                                    // 非清醒（昏迷/濒死等）-> 喊不出来，跳过。
		return
	if(world.time < next_scream)                                              // 仍在嘶喊冷却中 -> 本次不喊。
		return
	if(!crush_name)                                                            // 异常：没有名字可喊 -> 跳过（健壮性）。
		return
	// 设定下一次允许嘶喊的时间（随机化，显得更"失控"而非机械整点）。
	next_scream = world.time + rand(YANDERE_SCREAM_COOLDOWN_MIN, YANDERE_SCREAM_COOLDOWN_MAX)

	// 从若干句式里随机挑一句来喊，避免每次都一模一样、更显癫狂。
	var/list/cries = list(
		"[crush_name]……！[crush_name]！你在哪里？！",
		"[crush_name]！回到我身边来！求你了……",
		"[crush_name]…… [crush_name]…… 我快疯了，我要见到你！",
		"[crush_name]！！！别离开我！！！",
	)
	var/cry = pick(cries)

	// 先做一个"嘶吼"动作（带音效，周围可见可闻），再把名字作为强制台词喊出来。
	H.emote("scream", forced = TRUE)
	// forced 传入一个非空值，表示这是系统强制发声（绕过常规的玩家输入限制）。
	H.say(cry, forced = "yandere_vice")
	// 给玩家本人一条内心独白，强化"被执念支配"的代入感。
	to_chat(H, span_boldwarning("我控制不住自己……我必须喊出 ta 的名字，否则我会发疯。"))


// ----------------------------------------------------------------------------
// 卸载清理：当恶习被移除时彻底善后
// 为什么重写 on_removal：恶习可能中途被移除（管理员操作、转生等），此时必须撤销本恶习
//   施加的一切持续效果（两类压力事件）并收回我们授予的寻人术，否则会留下"恶习已没了、
//   效果还在"的残留，污染玩家状态。
// 为什么不动 known_people：把暗恋对象从熟人名单移除属于破坏性操作，且玩家也可能本就认识
//   对方；保留熟人记录无害，故不强行删除（最小副作用原则）。
// ----------------------------------------------------------------------------
/datum/charflaw/yandere/on_removal(mob/user)
	. = ..()                                                                   // 先跑基类清理逻辑。
	if(!ishuman(user))                                                         // 非人类无需清理。
		return
	var/mob/living/carbon/human/H = user

	// 撤销两类心情效果（对不存在的事件调用 remove_stress 也安全，无副作用）。
	H.remove_stress(/datum/stressevent/yandere_bliss)
	H.remove_stress(/datum/stressevent/yandere_longing)

	// 收回寻人术——但仅限"确实由本恶习授予"的那一份（granted_spell 为真），
	//   避免误删玩家自学的同名法术。
	if(granted_spell && H.mind)
		// RemoveSpell 按"名字 + 类型"匹配并删除一份实例；这里遍历找出寻人术实例后移除。
		for(var/obj/effect/proc_holder/spell/self/locate_person/S in H.mind.spell_list)
			H.mind.RemoveSpell(S)
			break                                                              // 只收回一份（我们也只授予了一份）。
		granted_spell = FALSE                                                  // 复位标记，防止重复收回。


// ============================================================================
// 心情事件定义
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// 正面情绪：心花怒放（看见暗恋对象时）
// 为什么 stressadd 取强负值：负的 stressadd 代表"心情变好"；取 -8 足以把心情推到最高档
//   （阈值 <= -4 即 STRESS_THRESHOLD_NICE，触发"I feel great!"），对应需求 4"心情达到顶峰"。
// 为什么 timer 取较长值：本事件由 flaw_on_life 在"持续看见"期间反复 add_stress 续期
//   （每次刷新 time_added），因此只要还能看见就不会过期；timer 设 2 分钟留足冗余，
//   即便某 tick 漏检也不会瞬间掉档。一旦看不见，handle_missing_crush 会立即 remove。
// ----------------------------------------------------------------------------
/datum/stressevent/yandere_bliss
	timer = 2 MINUTES
	stressadd = -8                                                             // 强力正面情绪（心情顶峰）。
	desc = span_green("我能看见我心爱的人，世界都变得无比美好。")


// ----------------------------------------------------------------------------
// 负面情绪：思念之苦（看不见暗恋对象时，逐级恶化）
// 为什么用 stacks 实现"持续变差"：需求 5 要求"心情【持续】变差"。每个检测间隔
//   add_stress 一次会把 stacks +1（上限 max_stacks），实际心情 = stressadd +
//   (stacks-1) * stressadd_per_extra_stack，于是越久不见、心情越糟，逐级累加。
// 数值设计：base 2 + 每层 +2，最多 6 层 -> 最高 2 + 5*2 = 12（落在"非常焦躁"档附近），
//   既能明显恶化心情，又不至于一上来就把人逼到崩溃；配合 5 分钟后的嘶喊，层层递进。
// 为什么 timer 取较长值：与正面事件同理——靠 flaw_on_life 反复续期维持；只要还看不见就
//   不断 add_stress 刷新 time_added，事件不会过期、stacks 也不回落；一旦重新看见，
//   handle_seeing_crush 会 remove_stress 把它整体清掉，stacks 归零。
// ----------------------------------------------------------------------------
/datum/stressevent/yandere_longing
	timer = 2 MINUTES
	stressadd = 2                                                              // 看不见时的基础负面情绪。
	max_stacks = 6                                                             // 最多叠 6 层（封顶，避免无限恶化）。
	stressadd_per_extra_stack = 2                                             // 每多叠一层，额外 +2 负面情绪（逐级恶化）。
	desc = span_red("我看不见我心爱的人……这种思念如同蚂蚁啃噬着我的心。")


// ============================================================================
// 登记：把"病娇"加入角色定制界面的"可选恶习"列表
// ----------------------------------------------------------------------------
// 为什么需要登记：玩家在创角界面能选到的恶习来自 GLOB.character_flaws（见
//   code/datums/character_flaw/_character_flaw.dm 的 GLOBAL_LIST_INIT 与
//   code/modules/client/vices_menu.dm 的恶习选择区）。该列表是硬编码的，而我们不能修改
//   modular_z121 之外的核心文件，因此改为"运行时追加"。
// 为什么 GLOB.charflaw_singletons 无需手动登记：code/__HELPERS/global_lists.dm 会自动为
//   /datum/charflaw 的【所有子类型】建立单例（subtypesof 遍历），本恶习会被自动纳入，
//   因此只需补登"可选列表"GLOB.character_flaws 即可。
// 为什么提供独立 proc：把"登记动作"封装起来，由同在 modular_z121 内的
//   bootstrap/custom_bootstrap.dm 在其 Initialize 中调用（那是本项目统一的启动钩子，
//   执行时机晚于全局列表初始化，追加安全）。这样登记逻辑与恶习定义同处一文件、内聚清晰。
// ============================================================================
/proc/register_yandere_vice()
	// 防御式校验：确保可选恶习列表已就绪且类型正确，避免异常初始化时序下报错。
	if(!islist(GLOB.character_flaws))
		return
	// 以"显示名 -> 类型路径"的约定登记（与 vices_menu.dm 的读取方式一致）。
	GLOB.character_flaws["病娇"] = /datum/charflaw/yandere


// ----------------------------------------------------------------------------
// #undef：清理本文件定义的临时宏，避免污染全局宏命名空间（与项目其它文件写法一致）。
// ----------------------------------------------------------------------------
#undef YANDERE_CHECK_INTERVAL
#undef YANDERE_SIGHT_RANGE
#undef YANDERE_ABSENCE_SCREAM_THRESHOLD
#undef YANDERE_SCREAM_COOLDOWN_MIN
#undef YANDERE_SCREAM_COOLDOWN_MAX
#undef YANDERE_DESIGNATE_RETRY
#undef YANDERE_INITIAL_DELAY
