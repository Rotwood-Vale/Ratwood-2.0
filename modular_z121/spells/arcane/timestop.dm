// modular_z121 自定义奥术法术：时间暂停（Timestop / "THE WORLD!"）
// ---------------------------------------------------------------------------
// 设计目标：以施法者为中心，把一小片方形区域里的时间“冻结”约 9 秒——区域内的
//           生物被定身/禁言/禁止行动，飞行中的弹射物被悬停，所有物体被染成灰白；
//           施法者本人游离于静止之外。时限结束或法术对象被删除时，一切干净复原。
//
// 性能优化要点（本次优化的“为什么”）：
//   1) affected_turfs 改为“关联表(turf => TRUE)”，使 is_in_field() 由 O(n) 的
//      列表线性查找变为 O(1) 哈希查找——该判定在每次被冻结者尝试移动/点击、以及
//      每刻刷新里都会被频繁调用，是热点路径。
//   2) apply_stasis() 把“只需做一次”的工作（注册信号、记录原始状态、加禁言特质、
//      清打字指示）真正只做一次；定身/禁锢只在“即将失效”时才补一刀，而不是每刻
//      都重复施加，避免无谓的状态机/信号开销。
//   3) 解除时按“来源”精确移除我们加的禁言特质，避免在目标本就被他人禁言时泄漏来源。
//
// 约束：所有代码都只存在于 modular_z121 内，仅“调用”主线已有的 CC/特质/信号接口，
//       不修改 modular_z121 之外的任何文件。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数（文件末尾统一 #undef，避免污染全局命名空间）=====
#define TIMESTOP_FIELD_HALF_SIZE 2                 // 力场“半径”：半径 2 => 以中心算 5x5 方形
#define TIMESTOP_FIELD_DURATION (9 SECONDS)        // 力场总持续时间（约 9 秒）
#define TIMESTOP_REFRESH_INTERVAL 1                // 刷新最小间隔（游戏刻）；也用作“定身即将失效”的阈值
#define TIMESTOP_HOLD_DURATION (1 SECONDS)         // 每次补的定身/禁锢时长（需 > REFRESH_INTERVAL）
#define TIMESTOP_NULL_COLOR "__timestop_null_color__" // 标记“原本没有 color”的哨兵值，便于复原成 null
#define TIMESTOP_MUTE_SOURCE "timestop"            // 我们施加禁言特质所用的唯一来源标记
#define TIMESTOP_FIELD_ICON 'modular_z121/assets/spells/timestop/160x160.dmi' // 力场覆盖图标
#define TIMESTOP_SOUND 'modular_z121/assets/spells/timestop/timeparadox2.ogg'  // 力场起止音效

// 时间静止区内统一染成的灰白色。独立成 proc 便于将来按需替换/调参。
/proc/timestop_gray_color()
	return "#F5F5F5"

// 以 center 所在地块为中心，收集 (2*half_size+1) 见方范围内的所有地块。
// 返回“关联表(turf => TRUE)”而非普通列表：这样后续 is_in_field() 能 O(1) 命中。
/proc/timestop_square_turfs(atom/center, half_size = TIMESTOP_FIELD_HALF_SIZE)
	. = list()
	// 没有有效中心地块（例如 center 在 nullspace）直接返回空表，调用方会据此放弃建场。
	var/turf/center_turf = get_turf(center)
	if(!center_turf)
		return

	// 把范围钳制在地图边界内，避免 locate() 取到越界坐标。
	var/min_x = max(center_turf.x - half_size, 1)
	var/max_x = min(center_turf.x + half_size, world.maxx)
	var/min_y = max(center_turf.y - half_size, 1)
	var/max_y = min(center_turf.y + half_size, world.maxy)

	// 逐格收集为关联表的键；值统一为 TRUE，仅用于 O(1) 存在性判断。
	for(var/x in min_x to max_x)
		for(var/y in min_y to max_y)
			var/turf/T = locate(x, y, center_turf.z)
			if(T)
				.[T] = TRUE

// ===========================================================================
// 时间静止力场实体：承载“冻结一片区域”的全部运行期状态与逻辑。
// ===========================================================================
/obj/effect/timestop_field
	name = "stopped time"
	icon = TIMESTOP_FIELD_ICON
	icon_state = "time"
	alpha = 125
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	pixel_x = -64                       // 160x160 图标相对 32px 地块的居中偏移
	pixel_y = -64
	var/mob/living/caster               // 施法者；全程豁免于冻结之外
	var/expires_at = 0                  // 力场到期的绝对时刻（world.time 基准）
	var/next_refresh = 0                // 下一次允许刷新的绝对时刻，用于按 REFRESH_INTERVAL 节流
	var/list/affected_turfs             // 关联表(turf => TRUE)：力场覆盖的地块集合
	var/list/grayed_atoms               // 已被染灰的原子集合（用于复原颜色）
	var/list/original_colors            // 关联表(REF(atom) => 原始 color)：记录染灰前的颜色
	var/list/stopped_movables           // 关联表(movable => state 子表)：被冻结对象及其原始状态

// New：建场。先算覆盖地块，无效则立即自毁；否则注册“进入”信号、定时、并立即冻结一次。
/obj/effect/timestop_field/New(loc, mob/living/new_caster)
	..()
	caster = new_caster
	affected_turfs = timestop_square_turfs(src)
	grayed_atoms = list()
	original_colors = list()
	stopped_movables = list()

	// 错误处理：没有施法者或没能圈出任何地块，则这次建场无意义，直接销毁。
	if(!caster || !length(affected_turfs))
		qdel(src)
		return

	// 起始音效（正常频率）。
	playsound(src, TIMESTOP_SOUND, 75, TRUE)

	// 给每个覆盖地块挂“有人进入”信号：后来者一踏入就被即时冻结，无需依赖逐刻全扫。
	for(var/turf/affected_turf as anything in affected_turfs)
		RegisterSignal(affected_turf, COMSIG_ATOM_ENTERED, PROC_REF(on_turf_entered))

	// 设定到期时刻；next_refresh 置 0 以便本刻就能跑首刷。
	expires_at = world.time + TIMESTOP_FIELD_DURATION
	next_refresh = 0
	refresh_field()                     // 立刻冻结建场瞬间已在场内的一切
	START_PROCESSING(SSfastprocess, src)

// Destroy：彻底拆场。顺序敏感——先停处理、退订信号、解除所有冻结、复原颜色，再清空引用。
/obj/effect/timestop_field/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	// 退订地块“进入”信号。
	if(length(affected_turfs))
		for(var/turf/affected_turf as anything in affected_turfs)
			UnregisterSignal(affected_turf, COMSIG_ATOM_ENTERED)
	// 解除所有被冻结对象（恢复其移动/行动/禁言/弹射物悬停等）。
	release_stopped_movables()
	// 复原所有被染灰对象的颜色。.Copy() 是因为 restore_atom_color 会就地修改 grayed_atoms。
	if(length(grayed_atoms))
		for(var/atom/A as anything in grayed_atoms.Copy())
			restore_atom_color(A)
	// 清空引用，帮助 GC，并避免拆场后信号回调里误用悬挂列表。
	affected_turfs = null
	grayed_atoms = null
	original_colors = null
	stopped_movables = null
	caster = null
	// 结束音效（频率取反，制造“倒带/解冻”的听感）。
	playsound(src, TIMESTOP_SOUND, 75, TRUE, frequency = -1)
	return ..()

// process：每个快速处理刻被调用。到期则自毁；否则按 REFRESH_INTERVAL 节流后刷新力场。
/obj/effect/timestop_field/process()
	// 到点收场：返回 PROCESS_KILL 让子系统也停止调度（Destroy 里还会再 STOP 一次，双保险）。
	if(world.time >= expires_at)
		qdel(src)
		return PROCESS_KILL
	// 尚未到下一次刷新窗口，跳过本刻，省开销。
	if(world.time < next_refresh)
		return

	next_refresh = world.time + TIMESTOP_REFRESH_INTERVAL
	refresh_field()

// is_in_field：判断某物当前是否处于力场覆盖范围内。借助关联表实现 O(1)。
/obj/effect/timestop_field/proc/is_in_field(atom/thing)
	if(!thing)
		return FALSE
	// 地块直接查表；其它原子则查其所在地块。affected_turfs 为 null（拆场后）时返回假，安全。
	if(isturf(thing))
		return affected_turfs?[thing]
	return affected_turfs?[get_turf(thing)]

// track_atom_color：把某原子染成灰白，并记录其原始颜色以便日后复原。
/obj/effect/timestop_field/proc/track_atom_color(atom/A)
	// 跳过无效对象、力场自身、施法者，以及“已经染过”的对象（避免重复记录覆盖原始色）。
	if(!A || QDELETED(A) || A == src || A == caster || (A in grayed_atoms))
		return

	grayed_atoms += A
	// 用哨兵值区分“原本就没有 color”和“原本 color 恰为某值”，确保能精确复原成 null。
	var/original_color = A.color
	original_colors[REF(A)] = isnull(original_color) ? TIMESTOP_NULL_COLOR : original_color
	A.color = timestop_gray_color()

// restore_atom_color：把先前染灰的原子恢复成原始颜色，并清除其记录。
/obj/effect/timestop_field/proc/restore_atom_color(atom/A)
	if(!A)
		return

	var/ref = REF(A)
	// 仅当确有记录时才复原；对象可能已被删除，删除则无需也无法再设颜色。
	if(ref in original_colors)
		if(!QDELETED(A))
			var/original_color = original_colors[ref]
			A.color = (original_color == TIMESTOP_NULL_COLOR) ? null : original_color
		original_colors -= ref          // 真正移除记录条目，而非置 null，保持表干净
	grayed_atoms -= A

// on_turf_entered：覆盖地块的“有人进入”信号回调——后来者一踏入立即被染灰并冻结。
/obj/effect/timestop_field/proc/on_turf_entered(datum/source, atom/movable/arrived, atom/oldloc)
	SIGNAL_HANDLER
	// 跳过无效者、力场自身与施法者。
	if(!arrived || QDELETED(arrived) || arrived == src || arrived == caster)
		return
	// 双保险：确认进入者确实落在力场范围内（多 z / 边界等异常情况）。
	if(!is_in_field(arrived))
		return

	track_atom_color(arrived)
	apply_stasis(arrived)

// block_stasis_move：被冻结对象的“移动前”信号回调——只要还在场内就拦下其移动。
/obj/effect/timestop_field/proc/block_stasis_move(datum/source, atom/newloc)
	SIGNAL_HANDLER
	if(is_in_field(source))
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

// block_stasis_click：被冻结生物的“点击”信号回调——只要还在场内就取消其点击行为。
/obj/effect/timestop_field/proc/block_stasis_click(datum/source, atom/target, params)
	SIGNAL_HANDLER
	if(is_in_field(source))
		return COMSIG_MOB_CANCEL_CLICKON

// apply_stasis：把某可移动体纳入“冻结”状态。
// 关键优化：把只需一次的工作（建状态、注册信号、加禁言、清打字、记录原状态）只做一次；
//          定身/禁锢仅在“即将失效”时补一刀，避免每刻重复施加带来的开销。
/obj/effect/timestop_field/proc/apply_stasis(atom/movable/thing)
	// 跳过无效者、力场自身与施法者。
	if(!thing || QDELETED(thing) || thing == src || thing == caster)
		return
	// 只冻结“生物”和“飞行中的弹射物”；其它物体仅染色，不进入冻结表。
	if(!isliving(thing) && !istype(thing, /obj/projectile))
		return

	// 取/建该对象的状态子表；newly_stopped 标记本次是否为“首次纳入冻结”。
	var/list/state = stopped_movables[thing]
	var/newly_stopped = isnull(state)
	if(newly_stopped)
		state = list()
		stopped_movables[thing] = state
		// 首次冻结才注册“移动前”拦截信号。
		RegisterSignal(thing, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(block_stasis_move))

	if(isliving(thing))
		var/mob/living/target = thing
		if(newly_stopped)
			// 仅在首次记录“被我们冻结之前”的原始 CC 状态，作为解除时的还原依据。
			state["had_paralyzed"] = (target.AmountParalyzed() > 0)
			state["had_immobilized"] = (target.AmountImmobilized() > 0)
			// 首次注册点击拦截、施加禁言（来源唯一，便于精确撤销）、清掉打字指示。
			RegisterSignal(target, COMSIG_MOB_CLICKON, PROC_REF(block_stasis_click))
			ADD_TRAIT(target, TRAIT_MUTE, TIMESTOP_MUTE_SOURCE)
			target.clear_typing_indicator()
		// 强制退出战斗姿态（cmode），开销极小，每次都设以确保被压住。
		target.cmode = 0
		// 定身/禁锢“补刀”：仅当剩余时长 <= 刷新阈值（即将失效）时才再施加，
		// Paralyze 内部以 max 取较大值，故重复补刀不会缩短、也不会无谓抬高时长。
		if(target.AmountParalyzed() <= TIMESTOP_REFRESH_INTERVAL)
			target.Paralyze(TIMESTOP_HOLD_DURATION)
		if(target.AmountImmobilized() <= TIMESTOP_REFRESH_INTERVAL)
			target.Immobilize(TIMESTOP_HOLD_DURATION)
	else if(istype(thing, /obj/projectile))
		var/obj/projectile/projectile = thing
		// 首次记录弹射物原本的 paused 状态，解除时据此还原（避免错误地“恢复成运动”）。
		if(newly_stopped)
			state["had_paused"] = projectile.paused
		projectile.paused = TRUE

// release_stasis：解除单个对象的冻结，尽量把它还原到“被我们冻结之前”的状态。
/obj/effect/timestop_field/proc/release_stasis(atom/movable/thing)
	if(!stopped_movables)
		return

	var/list/state = stopped_movables[thing]
	if(!state)
		return

	// 对象可能已被删除；仅在仍存活时才需要退订信号并还原状态。
	if(!QDELETED(thing))
		UnregisterSignal(thing, COMSIG_MOVABLE_PRE_MOVE)
		if(isliving(thing))
			var/mob/living/target = thing
			UnregisterSignal(target, COMSIG_MOB_CLICKON)
			// 定身/禁锢并非按来源记账，只能用启发式还原：若“此前并未被定身”，
			// 且当前剩余时长不超过我们可能施加的上限，则判定为“是我们造成的”，清零。
			if(!state["had_paralyzed"] && target.AmountParalyzed() <= (TIMESTOP_HOLD_DURATION + TIMESTOP_REFRESH_INTERVAL))
				target.SetParalyzed(0)
			if(!state["had_immobilized"] && target.AmountImmobilized() <= (TIMESTOP_HOLD_DURATION + TIMESTOP_REFRESH_INTERVAL))
				target.SetImmobilized(0)
			// 禁言是“按来源”记账的：无条件移除我们这一来源即可——若目标另有来源的禁言，
			// 它仍会保留，绝不会被我们误解。这样也彻底避免来源泄漏。
			REMOVE_TRAIT(target, TRAIT_MUTE, TIMESTOP_MUTE_SOURCE)
		else if(istype(thing, /obj/projectile))
			var/obj/projectile/projectile = thing
			projectile.paused = !!state["had_paused"]

	stopped_movables -= thing

// release_stopped_movables：解除所有被冻结对象。.Copy() 因为 release_stasis 会就地改表。
/obj/effect/timestop_field/proc/release_stopped_movables()
	if(!length(stopped_movables))
		return

	for(var/atom/movable/thing as anything in stopped_movables.Copy())
		release_stasis(thing)

// refresh_field：每刷新刻执行。先清理“已离场/已删除”的记录，再确保场内一切处于冻结。
/obj/effect/timestop_field/proc/refresh_field()
	// 1) 复原那些已不在场内（或已删除、或是施法者）的染灰对象的颜色。
	//    .Copy() 因为 restore_atom_color 会就地修改 grayed_atoms。
	if(length(grayed_atoms))
		for(var/atom/tracked_atom as anything in grayed_atoms.Copy())
			if(QDELETED(tracked_atom) || !is_in_field(tracked_atom) || tracked_atom == caster)
				restore_atom_color(tracked_atom)

	// 2) 解除那些已不在场内（或已删除、或是施法者）的被冻结对象。
	if(length(stopped_movables))
		for(var/atom/movable/stopped_thing as anything in stopped_movables.Copy())
			if(QDELETED(stopped_thing) || !is_in_field(stopped_thing) || stopped_thing == caster)
				release_stasis(stopped_thing)

	// 3) 兜底全扫：逐地块、逐内容物地染灰并冻结。新进入者已由信号即时处理，这里主要是
	//    对“非移动方式出现（如就地生成/传送）”的对象做安全网；得益于上面的“补刀”优化，
	//    对已冻结对象的本步开销已降到很低（多为一次剩余时长判断即跳过）。
	for(var/turf/affected_turf as anything in affected_turfs)
		track_atom_color(affected_turf)
		for(var/atom/movable/movable_atom as anything in affected_turf)
			if(movable_atom == src || movable_atom == caster)
				continue
			track_atom_color(movable_atom)
			apply_stasis(movable_atom)

// ===========================================================================
// 法术本体：自施法术，引导（若有）后在脚下生成时间静止力场。
// ===========================================================================
/obj/effect/proc_holder/spell/self/timestop
	name = "时间暂停"
	desc = "暂停一小片区域的时间9s，这是能征服世界的力量啊！WRYYYYYYY！"
	school = "transmutation"
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "timestop"
	cost = 12                           // 法术点/法力消耗（T4 高耗）
	releasedrain = 500                  // 施放抽取的巨量疲劳——体现“征服世界”的代价
	chargedrain = 10
	chargetime = 0                      // 当前为即时施放（如需读条，调大此值即可由下方 do_after 生效）
	recharge_time = 2 MINUTES           // 冷却 2 分钟
	cooldown_min = 2 MINUTES            // 即便被加速，冷却也不低于 2 分钟
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 4
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "time"
	gesture_required = TRUE
	invocations = list("THE WORLD!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	sound = null
	miracle = FALSE
	xp_gain = TRUE

// choose_targets：施法入口。若设有引导则先 do_after 读条；随后喊出咒文并进入 perform。
/obj/effect/proc_holder/spell/self/timestop/choose_targets(mob/user = usr)
	// 错误处理：无施法者直接撤销，恢复冷却为可用。
	if(!user)
		revert_cast()
		return

	// 仅当 chargetime > 0 时才读条（当前默认 0 => 即时施放，此块自然跳过）。
	var/cast_time = get_chargetime()
	if(cast_time > 0)
		user.visible_message(span_warning("[user] 高举魔力，仿佛要将整个世界都拽入静止！"), span_notice("我高举魔力，世界啊，准备静止吧......"))
		// 读条期间被打断（移动/受击/死亡）即失败，撤销并退还冷却。
		if(!do_after(user, cast_time, target = user, progress = TRUE))
			to_chat(user, span_warning("我的时流操控被打断了！"))
			revert_cast(user)
			return

	user.visible_message(
		span_warning("[user] 宛如君临世界的魔王般张狂高喝：\"THE WORLD!\""),
		span_notice("我张狂地高喝：\"THE WORLD!\" 世界啊，停下吧！")
	)
	// 临时清空咒文设置，避免 perform 成功后框架又喊一遍（咒文已在上面手动喊出）。
	var/list/original_invocations = invocations
	var/original_invocation_type = invocation_type
	invocations = null
	invocation_type = "none"
	perform(null, user = user)
	invocations = original_invocations
	invocation_type = original_invocation_type


// cast：实际效果——在施法者所在地块生成时间静止力场。
/obj/effect/proc_holder/spell/self/timestop/cast(list/targets, mob/living/user = usr)
	. = ..()
	// 错误处理：施法者不在任何地块上（理论极端情况）则放弃并退还冷却。
	var/turf/origin = get_turf(user)
	if(!origin)
		revert_cast()
		return FALSE

	// 生成力场；其 New() 自带“无有效地块即自毁”的兜底，这里无需重复校验。
	new /obj/effect/timestop_field(origin, user)
	user.visible_message(span_warning("[user] 将周遭的时流生生扭入一片灰白死寂的静止之中！"), span_notice("我将身边一小片区域的时间彻底暂停，而自己仍游离于静止之外。"))
	return TRUE

#undef TIMESTOP_FIELD_HALF_SIZE
#undef TIMESTOP_FIELD_DURATION
#undef TIMESTOP_REFRESH_INTERVAL
#undef TIMESTOP_HOLD_DURATION
#undef TIMESTOP_NULL_COLOR
#undef TIMESTOP_MUTE_SOURCE
#undef TIMESTOP_FIELD_ICON
#undef TIMESTOP_SOUND
