// ============================================================================
// 格拉加尔的凝视（Glaggar's Glance）—— 恐怖之钟的高难度挑战模式
// ----------------------------------------------------------------------------
// 本文件实现一个完整的“波次竞技场”挑战：玩家在恐怖之钟上选择该选项后，
//   1) 30 秒准备期，期间不断响起恐怖之声；
//   2) 准备期结束时，钟周围 8 格内随机挑选 3 名玩家成为“挑战者”；
//   3) 用不可摧毁的壁垒把竞技场围起来，并把非挑战者传送到教堂；
//   4) 依次刷出四波怪物，每波清空后 30 秒刷下一波；
//   5) 通关后存活的挑战者获得“格拉加尔的奖励”（+2 力量 +2 速度）；
//   6) 挑战期间非挑战者若干涉（出现在竞技场内 / 伤害怪物）将被诅咒并传走。
//
// 设计约束：所有自定义内容仅允许放在 modular_z121 下；本任务要求注释使用中文。
// 之所以用“轮询（polling）”而非信号来判定波次清空，是因为本仓库里
// COMSIG_LIVING_ATTACKED_BY 等攻击信号实际上并未被发出，轮询最稳健、最不易出错。
// ============================================================================

// --- 可调常量（集中放在文件顶部，便于平衡性调整）-----------------------------
// 准备期时长：选择挑战后到第一波刷新之间的缓冲时间。
#define GLAGGAR_PREP_TIME (30 SECONDS)
// 每一波被清空后，到下一波刷新之间的间隔时间。
#define GLAGGAR_WAVE_DELAY (30 SECONDS)
// 竞技场半径（切比雪夫距离）：壁垒环建在该半径上，恰好把“无建筑净空区”围住。
// 与恐怖之钟的净空检测半径（TERROR_CLOCK_CLEAR_RANGE）保持一致，均为 6。
#define GLAGGAR_ARENA_RADIUS 6
// 怪物刷新半径：怪物只会出现在钟周围这个较小的范围内，保证它们在场地中央。
#define GLAGGAR_SPAWN_RADIUS 5
// 挑战者人数：准备期结束时最多标记这么多名玩家。
#define GLAGGAR_CHALLENGER_COUNT 3
// 主控制循环的轮询间隔：用于检测波次清空、干涉者、挑战者存活情况等。
#define GLAGGAR_TICK_INTERVAL (1 SECONDS)
// 挑战阶段的状态机取值。
#define GLAGGAR_PHASE_PREP 1          // 准备期
#define GLAGGAR_PHASE_FIGHT 2         // 战斗中（当前波怪物存活）
#define GLAGGAR_PHASE_INTERMISSION 3  // 波次间隙（等待下一波刷新）
#define GLAGGAR_PHASE_DONE 4          // 已结束（胜利/失败/中止），不再轮询
// 所有挑战怪物共用的阵营标签：用它来区分“召唤怪”与“干涉的玩家”，并避免怪物互殴。
#define GLAGGAR_FACTION "glaggar"

// ============================================================================
// 不可摧毁的竞技场壁垒
// 用临时生成的实体结构（而非改 turf）来围场，好处是结束时直接 qdel 即可完整还原，
// 不会破坏地图原有的地块数据。
// ============================================================================
/obj/structure/glaggar_barrier
	name = "格拉加尔的壁垒"
	desc = "一道由不祥之力凝成的栅栏，坚不可摧，将挑战者困在格拉加尔的目光之下。"
	// 复用现成的铁栅栏贴图，避免引入新资源；该 icon/state 在本仓库确实存在。
	icon = 'icons/roguetown/misc/gate.dmi'
	icon_state = "bar1"
	// 阻挡移动 + 视线 + 投射物：dense+opacity 能挡住近战进入与远程攻击穿透。
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	// INDESTRUCTIBLE 让 /obj/structure 的受伤逻辑直接跳过，从根本上无法被破坏。
	resistance_flags = INDESTRUCTIBLE
	// 画在高层，避免被地面贴图盖住。
	layer = ABOVE_MOB_LAYER

// ============================================================================
// 状态效果：格拉加尔的奖励（通关奖励）
// 永久生效，+2 力量 +2 速度；玩家“查看”该效果（悬停状态图标）会看到奖励说明。
// ============================================================================
/datum/status_effect/glaggar_reward
	id = "glaggar_reward"
	// duration = -1 表示永久，不会自动消失。
	duration = -1
	// 不需要每 tick 处理，省去无谓的处理开销。
	needs_processing = FALSE
	// effectedstats 会被状态效果基类在 on_apply/on_remove 时自动加/减，无需手写 change_stat。
	effectedstats = list(STATKEY_STR = 2, STATKEY_SPD = 2)
	// 关联一个自定义警报图标，作为玩家可“查看”的功能入口。
	alert_type = /atom/movable/screen/alert/status_effect/glaggar_reward

// 奖励效果对应的 HUD 警报：name/desc 即玩家查看时显示的文案。
/atom/movable/screen/alert/status_effect/glaggar_reward
	name = "格拉加尔的奖励"
	// 这段 desc 就是需求中“查看该功能时会提示”的内容。
	desc = "你为格拉加尔献上了精彩的杀戮，这是你的奖励。"

// ============================================================================
// 状态效果：格拉加尔的诅咒（惩罚干涉者）
// 持续一段时间，周期性造成伤害并削弱属性，提醒玩家“不要插手挑战”。
// ============================================================================
/datum/status_effect/glaggar_curse
	id = "glaggar_curse"
	// 持续 60 秒后自动消失。
	duration = 60 SECONDS
	// 每 3 秒结算一次伤害。
	tick_interval = 3 SECONDS
	// 削弱属性：诅咒期间 -2 力量 -2 速度（基类会在结束时自动恢复）。
	effectedstats = list(STATKEY_STR = -2, STATKEY_SPD = -2)
	alert_type = /atom/movable/screen/alert/status_effect/glaggar_curse

// 诅咒效果对应的 HUD 警报文案。
/atom/movable/screen/alert/status_effect/glaggar_curse
	name = "格拉加尔的诅咒"
	desc = "你干涉了格拉加尔的试炼，神祇的目光正灼烧着你的灵魂。"

// 诅咒每个 tick 的实际效果：持续灼烧伤害 + 偶尔的痛苦提示。
/datum/status_effect/glaggar_curse/tick()
	// owner 可能在诅咒期间被删除/已死，做空值与状态校验后再施加伤害。
	if(QDELETED(owner) || owner.stat == DEAD)
		return
	// 同时造成灼烧与钝击伤害，模拟“被神祇之力惩罚”的效果。
	owner.adjustFireLoss(8)
	owner.adjustBruteLoss(4)
	// 给受诅咒者一个明确的反馈，强化“别再插手”的信号。
	to_chat(owner, span_danger("格拉加尔的诅咒撕扯着你！"))

// ============================================================================
// 挑战主控制器
// 每一次“格拉加尔的凝视”都会创建一个该 datum 实例，负责整场挑战的生命周期。
// ============================================================================
/datum/glaggar_challenge
	// 触发挑战的恐怖之钟（竞技场中心物体）。
	var/obj/structure/terror_clock/clock
	// 竞技场中心地块（即钟所在地块），缓存下来便于反复做范围计算。
	var/turf/center
	// 挑战锁定的 Z 层：挑战者必须与钟处于同一 Z 层才算有效参与。
	var/z_level = 0
	// 当前阶段（见上面的 GLAGGAR_PHASE_* 状态机）。
	var/phase = GLAGGAR_PHASE_PREP
	// 当前是第几波（1~4），0 表示尚未开始。
	var/current_wave = 0
	// 当前波次仍然“在场”的怪物引用列表，用于判断本波是否被清空。
	var/list/current_wave_mobs = list()
	// 本场挑战的挑战者（玩家 mob）列表。
	var/list/challengers = list()
	// 已生成的壁垒结构列表，结束时统一清除以还原场地。
	var/list/barriers = list()
	// 四波怪物的定义（在 New 中填充）：每一波是一个 (类型 = 数量) 的关联列表。
	var/list/waves = list()
	// 防重入标志：避免在一波刚清空的同一瞬间被重复判定为“通关本波”。
	var/advancing = FALSE

// 构造时填充四波怪物的数据。把波次写成纯数据，后续若要调整只需改这里。
/datum/glaggar_challenge/New()
	..()
	waves = list(
		// 第一波：4 只恶狼。
		list(/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 4),
		// 第二波：斧/矛/卫/弓 骷髅各 1。
		list(
			/mob/living/simple_animal/hostile/rogue/skeleton/axe = 1,
			/mob/living/simple_animal/hostile/rogue/skeleton/spear = 1,
			/mob/living/simple_animal/hostile/rogue/skeleton/guard = 1,
			/mob/living/simple_animal/hostile/rogue/skeleton/bow = 1,
		),
		// 第三波：4 只持斧巨魔猛士。
		list(/mob/living/simple_animal/hostile/retaliate/rogue/troll/axe = 4),
		// 第四波：兽人长矛兵/弓手/劫掠者/蹂躏者各 1。
		list(
			/mob/living/simple_animal/hostile/retaliate/rogue/orc/spear = 1,
			/mob/living/simple_animal/hostile/retaliate/rogue/orc/ranged = 1,
			/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder = 1,
			/mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder/ravager = 1,
		),
	)

// 析构时做一次兜底清理，确保即使异常路径下也不会残留壁垒。
/datum/glaggar_challenge/Destroy()
	remove_barriers()
	clock = null
	center = null
	return ..()

// 启动挑战。由恐怖之钟在玩家选择该选项后调用。
/datum/glaggar_challenge/proc/start(obj/structure/terror_clock/source, mob/living/user)
	// 记录中心物体与中心地块；若钟不在有效地块上则无法开战。
	clock = source
	center = get_turf(clock)
	if(!center)
		// 错误处理：找不到中心地块，直接放弃并通知发起者。
		if(user)
			to_chat(user, span_warning("此处无法举行格拉加尔的试炼。"))
		qdel(src)
		return FALSE
	// 锁定 Z 层，后续以此判断挑战者是否“与钟同层”。
	z_level = center.z
	phase = GLAGGAR_PHASE_PREP
	// 全场预警：营造仪式开始的恐怖氛围。
	clock.visible_message(span_danger("[clock]剧烈震颤，空气骤然冰冷——格拉加尔的目光正在降临……"))
	// 准备期内分多次播放恐怖之声（每 6 秒一次，共 5 次覆盖 30 秒）。
	for(var/i in 0 to 4)
		addtimer(CALLBACK(src, PROC_REF(play_dread_sound)), i * 6 SECONDS)
	// 准备期结束后正式开战。
	addtimer(CALLBACK(src, PROC_REF(finish_prep)), GLAGGAR_PREP_TIME)
	// 启动主控制轮询循环。
	addtimer(CALLBACK(src, PROC_REF(controller_tick)), GLAGGAR_TICK_INTERVAL)
	return TRUE

// 准备期里播放的恐怖音效（随机挑选一种，覆盖较大范围）。
/datum/glaggar_challenge/proc/play_dread_sound()
	// 中心可能在准备期内失效（钟被毁），先做校验。
	if(!center)
		return
	playsound(center, pick('sound/misc/evilevent.ogg', 'sound/misc/demon_attack1.ogg', 'sound/misc/astratascream.ogg'), 100, FALSE, extrarange = 14)

// 准备期结束：选挑战者、围场、清场、刷第一波。
/datum/glaggar_challenge/proc/finish_prep()
	// 若挑战在准备期内已被中止，则不再继续。
	if(phase != GLAGGAR_PHASE_PREP)
		return
	// 钟若已被摧毁，整场挑战作废。
	if(QDELETED(clock) || clock.obj_broken)
		abort_challenge("仪式的载体被摧毁了。")
		return
	// 标记挑战者；若周围根本没有玩家，挑战无意义，直接中止。
	if(!mark_challengers())
		abort_challenge("格拉加尔在周围找不到任何值得注视的灵魂。")
		return
	// 用不可摧毁壁垒围出竞技场。
	erect_barriers()
	// 把竞技场内的非挑战者全部传送到教堂，避免误伤与干涉。
	teleport_non_challengers()
	// 正式刷出第一波。
	start_wave(1)

// 从钟周围 GLAGGAR_ARENA_RADIUS 格内随机挑选最多 GLAGGAR_CHALLENGER_COUNT 名存活玩家。
/datum/glaggar_challenge/proc/mark_challengers()
	// 收集范围内所有“由玩家操控且存活”的人类作为候选。
	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in range(GLAGGAR_ARENA_RADIUS, center))
		// 只挑选有客户端（真正玩家）且未死亡者。
		if(H.ckey && H.stat != DEAD)
			candidates += H
	// 没有任何候选者 -> 返回 FALSE，让上层中止挑战（错误处理）。
	if(!length(candidates))
		return FALSE
	// 打乱后取前 N 名，实现“随机挑选”。
	candidates = shuffle(candidates)
	for(var/mob/living/carbon/human/H in candidates)
		// 取满规定人数后停止。
		if(length(challengers) >= GLAGGAR_CHALLENGER_COUNT)
			break
		challengers += H
		// 明确告知玩家自己被选中，并交代“同层”这一硬性要求。
		to_chat(H, span_danger("格拉加尔的目光落在了你身上——你成为了挑战者！在试炼结束前不要离开这一层。"))
	return TRUE

// 在竞技场半径的“环”上生成不可摧毁壁垒，把场地围起来。
/datum/glaggar_challenge/proc/erect_barriers()
	// 遍历范围内每个地块，只在恰好处于外环（切比雪夫距离==半径）的开放地块上放壁垒。
	for(var/turf/T in range(GLAGGAR_ARENA_RADIUS, center))
		// get_dist 在 BYOND 中返回切比雪夫距离，正好对应方形环的边界。
		if(get_dist(center, T) != GLAGGAR_ARENA_RADIUS)
			continue
		// 已是封闭墙体的地块无需再放壁垒（本就挡路）。
		if(!isopenturf(T))
			continue
		// 生成壁垒并登记，便于结束时清除。
		var/obj/structure/glaggar_barrier/B = new(T)
		barriers += B

// 清除所有壁垒，还原场地。
/datum/glaggar_challenge/proc/remove_barriers()
	for(var/obj/structure/glaggar_barrier/B in barriers)
		qdel(B)
	barriers.Cut()

// 把竞技场内的非挑战者玩家传送到教堂。
/datum/glaggar_challenge/proc/teleport_non_challengers()
	// 先取得教堂落点；若取不到则只能放弃传送（错误处理：不中断挑战，仅记录）。
	var/turf/church = get_church_turf()
	for(var/mob/living/L in range(GLAGGAR_ARENA_RADIUS, center))
		// 只处理玩家操控的角色；放过挑战者与（此刻尚不存在的）召唤怪。
		if(!L.ckey || (L in challengers) || (GLAGGAR_FACTION in L.faction))
			continue
		if(church)
			L.forceMove(church)
			to_chat(L, span_warning("一股无形之力将你逐出了格拉加尔的试炼之地。"))

// 刷出指定序号（1 起）的一波怪物。
/datum/glaggar_challenge/proc/start_wave(wave_index)
	// 越界保护：序号非法直接判定为通关（不应发生，但稳妥起见）。
	if(wave_index > length(waves))
		victory()
		return
	current_wave = wave_index
	// 进入战斗阶段，并清空“在场怪物”列表后重新填充。
	phase = GLAGGAR_PHASE_FIGHT
	advancing = FALSE
	current_wave_mobs.Cut()
	// 取得本波所有可用刷新点。
	var/list/spawn_turfs = get_spawn_turfs()
	// 错误处理：完全没有可刷新地块时，无法继续，中止挑战。
	if(!length(spawn_turfs))
		abort_challenge("没有可供怪物降临的空地，试炼无法进行。")
		return
	// 按数据定义逐类型、逐只生成怪物。
	var/list/this_wave = waves[wave_index]
	for(var/mob_type in this_wave)
		var/count = this_wave[mob_type]
		for(var/i in 1 to count)
			// 在随机刷新点生成怪物。
			var/turf/target = pick(spawn_turfs)
			var/mob/living/M = new mob_type(target)
			// 实例化失败（极端情况）则跳过这一只，不影响其余生成。
			if(QDELETED(M))
				continue
			// 统一阵营：避免不同种类怪物互相攻击，并便于把它们与玩家区分开。
			M.faction = list(GLAGGAR_FACTION)
			current_wave_mobs += M
	// 向全场宣告本波开始。
	if(center)
		clock.visible_message(span_danger("第[current_wave]波降临了！"))

// 主控制轮询：挑战进行期间每隔 GLAGGAR_TICK_INTERVAL 触发一次。
/datum/glaggar_challenge/proc/controller_tick()
	// 已结束则不再重排循环，循环自然终止。
	if(phase == GLAGGAR_PHASE_DONE)
		return
	// 钟被摧毁/损坏 -> 立即中止整场挑战。
	if(QDELETED(clock) || clock.obj_broken)
		abort_challenge("仪式的载体被摧毁了，试炼戛然而止。")
		return
	// 准备期内挑战者尚未选出、场地尚未封闭，无需做任何巡查或胜负判定，
	// 仅保持轮询存活（否则会因“无挑战者”而误判失败）。
	if(phase == GLAGGAR_PHASE_PREP)
		addtimer(CALLBACK(src, PROC_REF(controller_tick)), GLAGGAR_TICK_INTERVAL)
		return
	// 剔除当前波中已死亡或已删除的怪物，得到真正“仍在场”的数量。
	prune_wave_mobs()
	// 校验挑战者：必须有人“存活且与钟同层”，否则挑战失败。
	if(!has_living_challenger())
		fail_challenge()
		return
	// 巡场：把闯入竞技场的非挑战者视为干涉者，予以诅咒并驱离。
	sweep_interferers()
	// 战斗阶段且本波怪物已被清空 -> 推进到下一波或通关。
	if(phase == GLAGGAR_PHASE_FIGHT && !length(current_wave_mobs) && !advancing)
		advancing = TRUE
		if(current_wave >= length(waves))
			// 最后一波也清空了 -> 通关。
			victory()
			return
		else
			// 进入波次间隙，并在 GLAGGAR_WAVE_DELAY 后刷新下一波。
			phase = GLAGGAR_PHASE_INTERMISSION
			if(clock)
				clock.visible_message(span_danger("怪物的嘶吼渐息……但更可怕的存在正在逼近。"))
			addtimer(CALLBACK(src, PROC_REF(start_wave), current_wave + 1), GLAGGAR_WAVE_DELAY)
	// 重排下一次轮询（只要挑战未结束就持续）。
	addtimer(CALLBACK(src, PROC_REF(controller_tick)), GLAGGAR_TICK_INTERVAL)

// 从“在场怪物”列表中移除已删除或已死亡的怪物。
/datum/glaggar_challenge/proc/prune_wave_mobs()
	// 遍历副本，避免在 DM 的 for-in-list 中边遍历边删除导致漏判。
	for(var/mob/living/M in current_wave_mobs.Copy())
		// 怪物被删除或死亡，即视为已被击杀，从在场列表中剔除。
		if(QDELETED(M) || M.stat == DEAD)
			current_wave_mobs -= M

// 是否仍有“存活且与钟同层”的挑战者。
/datum/glaggar_challenge/proc/has_living_challenger()
	for(var/mob/living/C in challengers)
		// 同时满足：未删除、未死亡、与钟同一 Z 层。
		if(!QDELETED(C) && C.stat != DEAD && C.z == z_level)
			return TRUE
	return FALSE

// 巡场驱逐并诅咒非挑战者（竞技场已被壁垒密封，场内出现的非挑战者必属干涉）。
/datum/glaggar_challenge/proc/sweep_interferers()
	for(var/mob/living/L in range(GLAGGAR_ARENA_RADIUS, center))
		// 跳过：非玩家、挑战者本人、以及我们自己的召唤怪。
		if(!L.ckey || (L in challengers) || (GLAGGAR_FACTION in L.faction))
			continue
		// 其余玩家即为干涉者：诅咒并传走。
		curse_interferer(L)

// 对一名干涉者施加诅咒并将其逐出竞技场。
// 备注：这是“非挑战者伤害怪物即被诅咒”的实现/挂钩点——由于场地被不可摧毁且不透明的
// 壁垒密封，任何出现在场内的非挑战者本质上就是在试图近战干涉，故等价处理。
/datum/glaggar_challenge/proc/curse_interferer(mob/living/L)
	// 施加诅咒状态效果（持续伤害 + 属性削弱）。
	L.apply_status_effect(/datum/status_effect/glaggar_curse)
	to_chat(L, span_danger("你胆敢干涉格拉加尔的试炼——诅咒降临于你！"))
	// 同时把干涉者传送到教堂，物理上隔离开挑战区域。
	var/turf/church = get_church_turf()
	if(church)
		L.forceMove(church)

// 通关结算：给存活且同层的挑战者发放奖励，然后清理收场。
/datum/glaggar_challenge/proc/victory()
	phase = GLAGGAR_PHASE_DONE
	if(clock)
		clock.visible_message(span_danger("[clock]发出满足的轰鸣——格拉加尔的试炼已被征服！"))
	// 逐一结算挑战者奖励。
	for(var/mob/living/C in challengers)
		// 只有“未删除、存活、与钟同层”的挑战者才有资格领取奖励。
		if(QDELETED(C) || C.stat == DEAD || C.z != z_level)
			continue
		// 授予永久的“格拉加尔的奖励”（+2 力量 +2 速度，可查看）。
		C.apply_status_effect(/datum/status_effect/glaggar_reward)
		to_chat(C, span_danger("你在格拉加尔的注视下幸存——它的恩赐已铭刻于你的血肉。"))
	// 收尾清理。
	cleanup()

// 失败结算：所有挑战者阵亡或离场，挑战以失败告终。
/datum/glaggar_challenge/proc/fail_challenge()
	phase = GLAGGAR_PHASE_DONE
	if(clock)
		clock.visible_message(span_danger("再无挑战者伫立——格拉加尔失望地移开了目光。"))
	cleanup()

// 异常中止：因钟被毁、无可用场地等原因提前结束。
/datum/glaggar_challenge/proc/abort_challenge(reason)
	phase = GLAGGAR_PHASE_DONE
	if(clock)
		clock.visible_message(span_warning("格拉加尔的试炼中断了：[reason]"))
	cleanup()

// 统一收尾：拆除壁垒、解除钟的占用、销毁本控制器。
/datum/glaggar_challenge/proc/cleanup()
	// 拆除全部壁垒，还原场地。
	remove_barriers()
	// 解除恐怖之钟上的占用标记，使其可以再次使用。
	if(clock && clock.active_challenge == src)
		clock.active_challenge = null
	// 销毁本控制器（phase 已为 DONE，残留的轮询回调会安全地直接返回）。
	qdel(src)

// 计算本波怪物可用的刷新地块：钟周围 GLAGGAR_SPAWN_RADIUS 内的开放、非密集、未被堵塞地块。
/datum/glaggar_challenge/proc/get_spawn_turfs()
	var/list/valid = list()
	for(var/turf/T in range(GLAGGAR_SPAWN_RADIUS, center))
		// 排除封闭/密集地块，以及钟自身所在地块。
		if(!isopenturf(T) || T.density || T == center)
			continue
		// 若地块上存在任何密集物体（含壁垒），则不在此刷新，避免卡住怪物。
		var/blocked = FALSE
		for(var/atom/movable/AM in T)
			if(AM.density)
				blocked = TRUE
				break
		if(blocked)
			continue
		valid += T
	return valid

// 取得用于传送非挑战者/干涉者的“教堂落点”。
/datum/glaggar_challenge/proc/get_church_turf()
	// 优先在教堂礼拜堂区域内寻找一个安全的开放地块。
	var/turf/found = pick_church_turf_in(/area/rogue/indoors/town/church/chapel)
	if(found)
		return found
	// 退路：扩大到整个教堂室内区域（含子区域）。
	found = pick_church_turf_in(/area/rogue/indoors/town/church)
	if(found)
		return found
	// 仍找不到则返回 null，调用方需自行处理（错误处理）。
	return null

// 在指定区域类型内随机挑一个开放、非密集的安全落点。
/datum/glaggar_challenge/proc/pick_church_turf_in(areatype)
	// 取该区域（含子类型）在当前世界中的所有地块。
	var/list/turfs = get_area_turfs(areatype, 0, TRUE)
	if(!length(turfs))
		return null
	// 过滤出适合站人的开放地块。
	var/list/safe = list()
	for(var/turf/T in turfs)
		if(isopenturf(T) && !T.density)
			safe += T
	if(!length(safe))
		return null
	return pick(safe)

// --- 清理文件内的局部宏，避免泄漏到全局命名空间 ------------------------------
#undef GLAGGAR_PREP_TIME
#undef GLAGGAR_WAVE_DELAY
#undef GLAGGAR_ARENA_RADIUS
#undef GLAGGAR_SPAWN_RADIUS
#undef GLAGGAR_CHALLENGER_COUNT
#undef GLAGGAR_TICK_INTERVAL
#undef GLAGGAR_PHASE_PREP
#undef GLAGGAR_PHASE_FIGHT
#undef GLAGGAR_PHASE_INTERMISSION
#undef GLAGGAR_PHASE_DONE
#undef GLAGGAR_FACTION
