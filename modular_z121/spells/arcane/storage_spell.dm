// modular_z121 自定义奥术法术：储物术（Storage Spell）
// ---------------------------------------------------------------------------
// 设计目标：一个 T1 实用法术。施法者吟唱咒文 -> 框架蓄力 0.5 秒 ->
//           为施法者展开一个“类似背包”的储物界面（一块魔法口袋空间）。
//           储物格的大小取决于“施法者”的奥术技能等级：
//             L1 -> 2×2，L2 -> 3×3，L3 -> 4×4，L4 -> 5×5，L5 -> 6×6，L6 -> 7×7。
//
// 为什么这样实现：
//   - 本服的储物系统是 Vanderlin 风格的“网格（grid）储物”（见 code/.../new_storage/tetris.dm）。
//     一个储物界面的格子尺寸完全由其储物组件的 screen_max_columns / screen_max_rows
//     （以 world.icon_size 为单位的格数）决定。因此“按等级缩放储物大小”=“按等级
//     设置这两个字段”，无需触碰任何主线代码。
//   - 储物空间承载于一个真实的 /obj/item/storage 对象（魔法口袋）。该口袋被放进
//     “施法者自身的 contents（物品栏内容）”里，作为一个不占用手/装备槽的私人空间。
//     【关键 / 取物 BUG 修复】取物的点击流程（_onclick/click.dm 第 227 行附近）只有在
//     “容器位于施法者 contents 中”时才会放行：
//         if(... || (A.loc in contents) || ...) resolveAdjacentClick(...)
//     普通背包之所以能取物，正因为它在装备槽里（装备槽物品也算 contents）。
//     早期版本把口袋放在 nullspace（loc == null），导致 CanReach 从物品沿 loc 链
//     回溯时断在虚空、永远到不了施法者，于是“能放进、却取不出”。把口袋改放进
//     施法者 contents 后，存取与普通背包完全一致。
//   - 口袋随施法者持久存在；每次施放都会把它 forceMove 回“当前施法者”体内，
//     因此即便发生灵魂转移/换身，口袋也会跟随到新身体。
//   - 移动会自动关闭任何打开的储物界面（见 living.dm 中 Move() 里对 active_storage
//     的无条件 close）——这与普通背包表现一致；本法术消耗极低、冷却仅 1 秒，
//     需要时再次施放即可重新展开。
//
// 约束：本法术的所有代码都只存在于 modular_z121 内，仅“调用 / 复用”主线已有的
//       储物组件系统（/obj/item/storage 与 /datum/component/storage），
//       不修改 modular_z121 之外的任何文件。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数集中定义（文件末尾统一 #undef，避免污染全局命名空间）=====
// 把这些“数值旋钮”集中放在顶部，便于平衡性调整时一目了然。
#define STORAGE_MANA_COST      1            // 法力 / 法术点消耗（cost）= 1
#define STORAGE_RESOURCE_COST  3            // 每次施放抽取的疲劳/耐力（releasedrain）= 3（即“法术消耗”）
#define STORAGE_CHANNEL_TIME   (0.5 SECONDS) // 蓄力时长（do_after 引导）= 0.5 秒
#define STORAGE_COOLDOWN       (1 SECONDS)  // 成功施放后的冷却 = 1 秒

// 储物格尺寸的等级换算参数。规格：等级 N -> 边长 (N+1) 的正方形网格。
// 即 L1=2×2 … L6=7×7。用常量表达“边长 = 等级 + 该偏移”，便于日后整体平移曲线。
#define STORAGE_SIZE_OFFSET    1            // 网格边长 = clamp(奥术等级,1,6) + 偏移(=1)
#define STORAGE_MIN_LEVEL      1            // 参与换算的最低等级（未入门也按 1 级算，保证至少 2×2）
#define STORAGE_MAX_LEVEL      6            // 参与换算的最高等级（超过按 6 级封顶，最大 7×7）

// ===========================================================================
// 储物组件：魔法口袋的“容器规则”
// ---------------------------------------------------------------------------
// 继承自 concrete 储物组件。这里只定义“静态默认值”（重量上限、快速存取等）；
// 真正的网格尺寸（screen_max_columns / screen_max_rows）会在每次施法时，由法术
// 依据施法者奥术等级动态写入，因此这里给出的是“最低档 2×2”的安全默认值。
// ===========================================================================
/datum/component/storage/concrete/grid/magic_pocket
	max_w_class = WEIGHT_CLASS_NORMAL   // 单件物品体积上限：与普通背包一致（不能塞进巨型物）
	screen_max_columns = 2              // 默认列数（最低档 2 列）；施法时会被覆盖
	screen_max_rows = 2                 // 默认行数（最低档 2 行）；施法时会被覆盖
	click_gather = TRUE                 // 允许点击地面物品快速拾入
	allow_quick_gather = TRUE           // 允许“一键收纳”
	allow_quick_empty = TRUE            // 允许“一键倾倒”
	allow_dump_out = TRUE               // 允许把内容物倒出
	dump_time = 0                       // 倾倒无需读条（纯魔法空间，开合随心）
	insert_preposition = "in"           // 文字反馈用词：“放进”口袋
	// drop_all_on_destroy 默认为 FALSE：口袋被销毁时内容物随之湮灭（见下方法术 Destroy 的说明）。

// ===========================================================================
// 储物物品：魔法口袋本体
// ---------------------------------------------------------------------------
// 这是一个抽象的“容器对象”，玩家永远不会真正拿在手里——它作为储物界面的载体，
// 被放进施法者自身的 contents 里（不占用任何手/装备槽）。设为 ABSTRACT，确保它即便
// 意外进入物品交互流程也不会被当作普通物品来掉落、交易或夺取，符合“私人魔法空间”的设定。
// 注意：刻意【不】使用 DROPDEL——因为口袋现在长期存放于施法者体内，若误触 dropped()
//       会连同里面的物品一起被销毁；其生命周期改由法术实例统一管理（见法术 Destroy）。
// ===========================================================================
/obj/item/storage/magic_pocket
	name = "魔法储物空间"
	desc = "一片由魔力编织而成的便携储物空间，大小随施法者的奥术造诣而定。"
	icon = 'icons/roguetown/clothing/storage.dmi' // 借用现有储物图标，保证一定有有效图标（玩家几乎不会真正看到它）
	icon_state = "backpack"
	w_class = WEIGHT_CLASS_HUGE          // 设为巨型，避免它被塞进别的容器里造成嵌套悖论
	item_flags = ABSTRACT                // ABSTRACT：不可被当作普通物品交互（不掉落/不可夺取/不显示于剥取菜单）
	component_type = /datum/component/storage/concrete/grid/magic_pocket // 使用上面定义的魔法口袋容器规则

// ===========================================================================
// 法术本体
// ---------------------------------------------------------------------------
// 选用 /spell/self 作为基类：本法术只作用于“施法者自己”（为其展开私人储物界面），
// 不需要在施法前点选地块或他人，因此 self 基类最契合“吟唱蓄力 -> 对自身生效”的流程。
// ===========================================================================
/obj/effect/proc_holder/spell/self/storage_spell
	name = "储物术"
	desc = "一道用魔力编织出的便携储物法术。所造空间的大小，会随施法者的奥术造诣而增长。"
	school = "transmutation"
	spell_tier = 1                         // T1 法术
	cost = STORAGE_MANA_COST               // “法力 / 法术点”消耗 = 1
	releasedrain = STORAGE_RESOURCE_COST   // “法术消耗”：每次施放抽取的疲劳/耐力 = 3
	chargedrain = 0                        // 蓄力过程中不额外持续抽取资源
	chargetime = STORAGE_CHANNEL_TIME      // 蓄力 0.5 秒（get_chargetime() 返回它驱动 do_after）
	recharge_time = STORAGE_COOLDOWN       // 冷却 = 1 秒（由 charge_check 强制执行）
	cooldown_min = STORAGE_COOLDOWN        // 即便被“加速”，冷却也不会低于 1 秒
	charge_type = "recharge"               // 使用“充能”式冷却（默认）
	human_req = TRUE                       // 只有人类施法者能施放（依赖 client/屏幕来展示界面）
	warnie = "spellwarning"
	no_early_release = TRUE                // 引导未完成不允许提前释放
	movement_interrupt = FALSE             // 蓄力极短（0.5 秒），允许移动以免手感笨拙
	charging_slowdown = 0                  // 蓄力如此之短，不施加减速
	chargedloop = /datum/looping_sound/invokegen // 蓄力期间循环播放的施法音效
	associated_skill = /datum/skill/magic/arcane // 储物大小缩放所依据的技能：奥术
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "storage"              // 动作按钮的图标态（若 dmi 暂无该态仅显示为空，不影响编译）
	invocations = list("为我开辟一方储物之境！") // 咒文（按规格在“开始引导”时喊出）
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	gesture_required = TRUE                // 需要能自由活动的手来施法
	miracle = FALSE
	xp_gain = TRUE
	sound = null                           // 蓄力音由 chargedloop 负责；展开音效在 cast 内单独播放

	// 与本法术实例（即“该施法者”）绑定的魔法口袋。spell proc_holder 是按 mind/施法者
	// 独立持有的，因此把口袋引用挂在实例上 = 天然的“每位施法者一个私人空间”，
	// 且可在多次施放间持久保留其中的物品。
	var/obj/item/storage/magic_pocket/linked_pocket

// ---------------------------------------------------------------------------
// Destroy：法术被销毁（如遗忘法术 / 施法者 mind 被清理）时的清理。
// 为避免在 nullspace 中留下孤立的口袋对象，这里一并销毁绑定的口袋。
// 注意：口袋组件 drop_all_on_destroy 为 FALSE，故其内容物会随之湮灭——这符合
//       “魔法空间随施法者消散而坍缩”的设定；只要法术（及其 mind）仍在，物品就一直保留。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/self/storage_spell/Destroy()
	if(!QDELETED(linked_pocket)) // 仅在口袋仍有效时清理，避免重复 qdel
		QDEL_NULL(linked_pocket) // QDEL_NULL：销毁并把引用置空，杜绝悬空指针
	return ..()

// ---------------------------------------------------------------------------
// 等级 -> 网格边长 换算。规格：等级 N -> (N+1) 边长的正方形（L1=2 … L6=7）。
// 用 clamp 处理越界：未入门(0/负)按最低 1 级算（保证至少 2×2），超过 6 级按 6 级封顶
// （最大 7×7），满足“超出范围就近钳制”的要求。独立成 proc 便于单独调参与复用。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/self/storage_spell/proc/get_grid_size_for_skill(skill_level)
	var/effective_level = clamp(skill_level, STORAGE_MIN_LEVEL, STORAGE_MAX_LEVEL)
	return effective_level + STORAGE_SIZE_OFFSET

// ---------------------------------------------------------------------------
// choose_targets：施法入口（点击图标后由 Click -> cast_check -> choose_targets 调用）。
// 在这里完成两件“施法前”的事：1) 立即喊出咒文；2) do_after 引导 0.5 秒。
// 引导成功后才调用 perform() 进入真正的 cast()，从而保证“蓄力被打断则不生效、退还冷却”。
// 该模式与 wish_spell / insight_all_things 等既有自定义法术保持一致。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/self/storage_spell/choose_targets(mob/user = usr)
	// 没有施法者就直接撤销，避免空指针。revert_cast() 会把冷却恢复为“可用”状态。
	if(!user)
		revert_cast()
		return

	// 规格要求“开始引导时”就念出咒文，因此这里手动调用一次 invocation()。
	// （稍后在 perform() 前我们会临时屏蔽 invocation，以免咒文被重复喊两遍。）
	invocation(user)

	// 取得引导时长（= chargetime），用 do_after 实现“可被打断的 0.5 秒蓄力”。
	var/cast_time = get_chargetime()
	if(cast_time > 0)
		user.visible_message(
			span_warning("[user] 屈指轻引，周身魔力如细线般缠绕、编织……"),
			span_notice("我开始以魔力编织一方储物之境，只需一瞬……")
		)
		// do_after：在 cast_time 期间若施法者移动被打断/被眩晕/死亡，会返回 FALSE。
		// progress = TRUE 显示进度条；target = user 表示这是针对自身的引导动作。
		if(!do_after(user, cast_time, target = user, progress = TRUE))
			to_chat(user, span_warning("魔力的丝线散开了，储物之境未能成形。"))
			revert_cast(user) // 引导失败：退还冷却，让施法者可立即重试
			return

	// 引导成功。进入 perform 之前临时清空 invocations，防止 perform 成功后又喊一次咒文。
	var/list/original_invocations = invocations
	var/original_invocation_type = invocation_type
	invocations = null
	invocation_type = "none"
	// /spell/self 的 cast 只作用于施法者本人，targets 传 null 即可。
	perform(null, user = user)
	// 还原咒文设置，避免影响下一次施放。
	invocations = original_invocations
	invocation_type = original_invocation_type

// ---------------------------------------------------------------------------
// cast：引导成功后真正执行的逻辑——确保口袋存在、按等级设定网格大小、为施法者展开界面。
// 返回值约定：
//   - 返回 TRUE  -> perform() 会调用 start_recharge()，进入 1 秒冷却（施法成功）。
//   - 返回 FALSE -> 由本过程调用 revert_cast() 退还冷却（施法失败 / 无法展开界面）。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/self/storage_spell/cast(list/targets, mob/living/user = usr)
	. = ..()
	// 安全校验：施法者必须仍然有效且健在，才能为其展开界面。
	if(!user || QDELETED(user))
		revert_cast()
		return FALSE

	// 必须有 client 才能把储物界面绘制到屏幕上（show_to 内部也会校验，这里提前给出友好反馈）。
	if(!user.client)
		to_chat(user, span_warning("没有意识在场，无法展开储物之境。"))
		revert_cast()
		return FALSE

	// 第 1 步：确保该施法者的魔法口袋已存在（不存在则在“施法者体内”新建一个）。
	// 直接 new 到 user 上 -> 口袋落在施法者 contents 里，使其内容物对施法者“可达”，
	// 从而保证既能放进、也能取出（取物 BUG 的根因正是此前把口袋放在了 nullspace）。
	if(QDELETED(linked_pocket))
		linked_pocket = new /obj/item/storage/magic_pocket(user)

	// 防御性校验：万一创建失败（理论上不会），给出反馈并退还冷却。
	if(QDELETED(linked_pocket))
		to_chat(user, span_warning("储物之境未能凝聚成形，请稍后再试。"))
		revert_cast()
		return FALSE

	// 第 1.5 步：把口袋“归位”到当前施法者体内。
	// 为什么每次都做：口袋是跨多次施放持久存在的；它可能上次留在旧身体里、
	// 或因某些清理流程被移到了别处。只有当 loc == 当前施法者 时，取物点击流程
	// （click.dm 中的 “A.loc in contents” 判定）与 CanReach 才会放行。
	// 仅在确实不在施法者体内时才移动，避免无谓的 forceMove 调用。
	if(linked_pocket.loc != user)
		linked_pocket.forceMove(user)

	// 第 2 步：取得口袋的储物组件，用以读写网格尺寸。
	var/datum/component/storage/pocket_storage = linked_pocket.GetComponent(/datum/component/storage)
	if(!pocket_storage)
		// 组件缺失属于异常情况：销毁这个坏掉的口袋并报错退款，下次施放会重建。
		to_chat(user, span_warning("储物之境的结构紊乱了，它消散了——请重新施法。"))
		QDEL_NULL(linked_pocket)
		revert_cast()
		return FALSE

	// 第 3 步：按“施法者当前奥术等级”计算应有的网格边长（正方形）。
	var/caster_skill = user.get_skill_level(associated_skill)
	var/target_size = get_grid_size_for_skill(caster_skill)

	// 安全策略——“只增不减”：取“历史最大尺寸”和“本次目标尺寸”的较大值。
	// 这样即便施法者等级因某种原因下降，也绝不会把网格缩小而导致已存物品无处安放、
	// 被挤出到虚空而丢失。由于奥术等级实际上几乎只增不减，该策略在正常游玩中与
	// “严格按当前等级”表现一致，同时杜绝了缩小丢物的风险。
	var/new_size = max(pocket_storage.screen_max_columns, target_size)

	// 仅在尺寸确实变化时才改写并重排，避免无谓开销与对已有网格坐标的扰动。
	if(new_size != pocket_storage.screen_max_columns || new_size != pocket_storage.screen_max_rows)
		pocket_storage.screen_max_columns = new_size // 列数 = 边长
		pocket_storage.screen_max_rows = new_size     // 行数 = 边长（正方形）
		// 若口袋里已有物品，扩容后需要按新网格重新计算每件物品的格子坐标。
		// reset_grid_inventory() 是主线提供的标准做法：把内容物逐一取出再以 force 方式
		// 重新放回，从而在新尺寸下重排坐标（空口袋时该调用是无操作，开销可忽略）。
		linked_pocket.reset_grid_inventory()

	// 第 4 步：把储物界面展示给施法者。show_to 会调用 orient2hud 依据上面的网格尺寸绘制。
	// 返回 FALSE 表示因某种原因（如 on_found 拦截、无 client）未能展示。
	if(!pocket_storage.show_to(user))
		to_chat(user, span_warning("储物之境一闪即逝，没能稳定地展开。"))
		revert_cast()
		return FALSE

	// 表现层反馈：音效 + 文字。展示成功，本次施法有效。
	playsound(get_turf(user), 'sound/foley/equip/rummaging-01.ogg', 50, TRUE) // 复用现有“翻找”音效，呼应“打开背包”
	user.visible_message(
		span_notice("[user] 指间魔力翻涌，凭空裂开一道幽微的储物之隙。"),
		span_green("我以魔力编织出一方 [new_size]×[new_size] 的储物之境，随取随放。")
	)
	return TRUE

// ===== 清理顶部定义的宏，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef STORAGE_MANA_COST
#undef STORAGE_RESOURCE_COST
#undef STORAGE_CHANNEL_TIME
#undef STORAGE_COOLDOWN
#undef STORAGE_SIZE_OFFSET
#undef STORAGE_MIN_LEVEL
#undef STORAGE_MAX_LEVEL
