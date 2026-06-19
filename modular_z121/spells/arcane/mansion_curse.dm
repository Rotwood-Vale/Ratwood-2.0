// modular_z121 自定义奥术法术：魔法邓肯宅邸诅咒（Magic Duncan Mansion Curse）
// ---------------------------------------------------------------------------
// 设计目标：一个 T3 法术。蓄力 5 秒后，在玩家“选定的地块”生成一扇“坚不可摧的宅邸
//           魔法门”；玩家触碰该门即被传送进一处独立的 5x5 魔法宅邸空间——四壁坚不可摧、
//           内部空旷，是荒野中安身歇脚之所。宅邸内有一扇回程门，触碰即送回进入前的位置。
//           · 若宅邸空间内连续 3 分钟无玩家，门会自动消失，但【空间本身被保留】。
//           · 空间内放置的物品/建筑全部留存；同一施法者日后再次施放，进入的是
//             【同一处】既有空间，而非重新生成的新空间。
//           · 只有“玩家”（受客户端操控的生物）才能触碰门进入，NPC/简单生物无效。
//           · 反滥用限制：为避免同一局开出过多宅邸，一旦【主人死亡，或离开本轮
//             （角色从本局消失，例如把自己拖到 /obj/structure/far_travel 退出）】，
//             其整座宅邸空间（连同预留区）都会被回收摧毁。
//           · 冷却 5 分钟。
//
// 架构（“为什么这么拆”）：
//   · 把“持久空间”与“临时门”彻底分离：
//       - /datum/mansion_space   持久存在，登记在 GLOB.mansion_magic_spaces[ckey] 里，
//         按施法者 ckey 一人一处；它持有预留区、内部区域、回程门、回程坐标等。
//         它一旦建立便长存（本局内），从不释放预留区——这正是“空间被保留”的根基。
//       - /obj/structure/mansion_magic_door 只是临时“入口门”，指向某个持久空间；
//         空置 3 分钟即自毁（门消失），但绝不释放其所指向的空间。
//   · 再次施放时：先按 ckey 查注册表——已有空间则“复用”（仅新建一扇入口门接上去），
//     没有才新建空间。从而保证“进入的是同一处空间”。
//   · 用主线“地块预留(turf reservation)”在预留 z 层切出独立区域当宅邸，天然与正常
//     地图隔离；外圈 1 格坚不可摧石墙、内部 5x5 开阔地面；并入一个全亮的独立 area。
//
// 约束：所有代码都只存在于 modular_z121 内，仅“调用”主线已有系统
//       （SSmapping 预留、ChangeTurf、change_area、forceMove、resistance_flags 等），
//       不修改 modular_z121 之外的任何文件。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数（文件末尾统一 #undef，避免污染全局命名空间）=====
#define MANSION_INNER_SIZE       5                 // 宅邸内部开阔空间边长（5x5）
#define MANSION_BLOCK_SIZE       7                 // 预留块边长 = 内部 5 + 外圈墙 2
#define MANSION_CENTER_OFFSET    3                 // 内部中心相对左下角的偏移（1..5 的中点为 3）
#define MANSION_EMPTY_TIMEOUT    (3 MINUTES)       // 空间内连续无玩家多久后，入口门自动消失（空间仍保留）
#define MANSION_OCCUPANCY_INTERVAL (15 SECONDS)    // 空置检测的节流间隔（不必每刻都扫）
#define MANSION_USE_COOLDOWN     (15)              // 单扇门两次传送之间的最小间隔（防抖/防乒乓，单位刻）
// 反滥用回收机制：主人“死亡”或“离开本轮”（角色从本局消失，例如经 /obj/structure/far_travel
// 退出会 qdel 其躯体）时，摧毁其整座宅邸。无需距离/范围参数——只看躯体是否“消失/死亡”。
#define MANSION_FLOOR_TURF       /turf/open/floor/rogue/blocks                 // 宅邸地面
#define MANSION_WALL_TURF        /turf/closed/wall/mineral/rogue/stone/unbreakable // 宅邸坚不可摧外墙
#define MANSION_DOOR_ICON        'icons/roguetown/misc/doors.dmi'             // 复用主线门图标
#define MANSION_DOOR_STATE       "fancy_wood"                                       // 该 dmi 中确实存在的图标态

// 法术数值
#define MANSION_SPELL_COST       6                 // 法术点/法力消耗
#define MANSION_SPELL_DRAIN      100               // 施放抽取的疲劳（“消耗大”）
#define MANSION_SPELL_COOLDOWN   (5 MINUTES)       // 冷却 5 分钟
#define MANSION_CHARGE_TIME      (5 SECONDS)       // 蓄力时长（由 invoked 基类的点击拦截按 chargetime 校验）
#define MANSION_PLACE_RANGE      7                 // 可选定“放门地块”的最大距离（range）

// 全局注册表：施法者 ckey => 其持久宅邸空间。一人一处，长存于本局。
// 这是“再次施放进入同一空间”的关键索引。
GLOBAL_LIST_EMPTY(mansion_magic_spaces)

// ===========================================================================
// 宅邸内部专属区域：全亮、室内、安全。每处持久空间各自 new 一个实例，互不干扰。
// ===========================================================================
/area/mansion_magic
	name = "魔法宅邸空间"
	// 禁用动态光照 => 区域恒为全亮，避免预留 z 层默认漆黑导致空间不可用。
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	// 室内（outdoors 默认 FALSE）：不受天气影响，契合“安心歇脚”。
	outdoors = FALSE
	// 不需要供电逻辑，按“始终无电网”处理即可（光照已由上面强制全亮）。
	always_unpowered = TRUE

// ===========================================================================
// 持久宅邸空间数据：本法术真正“被保留”的实体。它长存于 GLOB 注册表，门来门去都不影响它。
// ===========================================================================
/datum/mansion_space
	var/owner_ckey                             // 归属施法者的 ckey（注册表键）
	var/mob/living/owner_mob                   // 归属施法者的当前躯体；用于监测“死亡/远离”以回收空间
	var/datum/turf_reservation/reservation     // 预留区句柄；空置不释放（保留空间与其中之物），仅主人死亡/远离时释放
	var/area/mansion_magic/interior_area       // 宅邸内部专属区域实例
	var/turf/entry_turf                        // 进入宅邸后的落脚点（回程门旁的内部地块）
	var/turf/last_anchor_turf                  // 入口门最近一次出现在地图上的位置；回收清场时作为占用者的兜底落点（门消失后仍保留）
	var/obj/structure/mansion_return_door/inside_door // 内部回程门（与空间一同长存）
	var/list/return_points                     // 关联表(mob => turf)：记录每人进入前的位置，用于原路送回
	var/obj/structure/mansion_magic_door/active_door  // 当前的入口门（临时；可为 null）

// New：记录归属（ckey 与当前躯体）并初始化容器；真正的“开辟”交由 build_space()，以便施法流程能感知失败。
/datum/mansion_space/New(ckey, mob/living/new_owner)
	owner_ckey = ckey
	owner_mob = new_owner
	return_points = list()

// Destroy：开辟失败、或被回收（主人死亡/远离）时调用。顺序敏感——先停监测、清场，再释放预留区。
/datum/mansion_space/Destroy()
	// 停止主人监测轮询。
	STOP_PROCESSING(SSprocessing, src)
	// 从注册表摘除自己（若已登记），避免悬挂引用。
	if(owner_ckey && GLOB.mansion_magic_spaces[owner_ckey] == src)
		GLOB.mansion_magic_spaces -= owner_ckey
	// 【关键】释放预留区会清空空间内的一切，所以必须先把里面的活物安全送出，避免被一并抹除。
	eject_all_occupants()
	// 拆内部回程门。
	if(inside_door)
		QDEL_NULL(inside_door)
	// 若仍有入口门挂在地图上，一并拆除（门是临时物，空间没了它也无意义）。
	if(active_door)
		QDEL_NULL(active_door)
	// 释放预留区（清空空间与其中之物）。
	if(reservation)
		QDEL_NULL(reservation)
	owner_mob = null
	interior_area = null
	entry_turf = null
	last_anchor_turf = null
	return_points = null
	active_door = null
	return ..()

// build_space：申请预留块并把它“装修”成宅邸（墙、地、区域、回程门）。成功返回 TRUE。
/datum/mansion_space/proc/build_space()
	// 申请 7x7 预留块，默认地块设为宅邸地面。z 省略 => 由系统在预留 z 层寻空位。
	reservation = SSmapping.RequestBlockReservation(MANSION_BLOCK_SIZE, MANSION_BLOCK_SIZE, turf_type_override = MANSION_FLOOR_TURF)
	// 错误处理：申请失败（预留空间耗尽等），无法成形。
	if(!reservation)
		return FALSE

	// 为本宅邸创建独立区域实例（全亮、室内）。
	interior_area = new /area/mansion_magic()

	// 取预留块左下角坐标，作为铺设墙体与地面的基准。
	var/blx = reservation.bottom_left_coords[1]
	var/bly = reservation.bottom_left_coords[2]
	var/blz = reservation.bottom_left_coords[3]
	var/max_offset = MANSION_BLOCK_SIZE - 1     // 最外圈的相对坐标上限（0..6）

	// 逐格装修：最外圈改为坚不可摧墙，其余保持地面；并把每一格并入宅邸专属区域。
	for(var/dx in 0 to max_offset)
		for(var/dy in 0 to max_offset)
			var/turf/T = locate(blx + dx, bly + dy, blz)
			if(!T)
				continue
			// 外圈（任一坐标位于边界）铺设坚不可摧石墙；内部 5x5 维持预留出的地面。
			if(dx == 0 || dy == 0 || dx == max_offset || dy == max_offset)
				// ChangeTurf 返回新地块对象，用其刷新 T，以便后续改属区域。
				T = T.ChangeTurf(MANSION_WALL_TURF, MANSION_FLOOR_TURF)
			assign_turf_to_interior(T)

	// 关键内部坐标：回程门置于内部底排中央，落脚点置于回程门正北一格。
	// 进入者落在门旁而非门上，既不会立刻被弹回，也一眼可见“出口”。
	var/turf/inside_turf = locate(blx + MANSION_CENTER_OFFSET, bly + 1, blz)
	var/turf/arrival_turf = locate(blx + MANSION_CENTER_OFFSET, bly + 2, blz)
	// 错误处理：关键地块缺失（理论上不会，做兜底防止后续空指针）。
	if(!inside_turf || !arrival_turf)
		return FALSE
	entry_turf = arrival_turf
	// 生成内部回程门（独立类型），并指回本空间数据。
	inside_door = new /obj/structure/mansion_return_door(inside_turf, src)
	// 开辟成功后启动“主人监测”轮询：一旦主人死亡、或离开本轮（角色从本局消失），便回收整座宅邸。
	START_PROCESSING(SSprocessing, src)
	return TRUE

// assign_turf_to_interior：把单个地块从其原区域迁入宅邸专属区域（含光照记账）。
/datum/mansion_space/proc/assign_turf_to_interior(turf/T)
	if(!T || !interior_area)
		return
	var/area/old_area = get_area(T)
	// 已在目标区域则无需处理。
	if(old_area == interior_area)
		return
	// 标准迁移三步：旧区域移除、新区域加入、change_area 完成光照/记账。
	if(old_area)
		old_area.contents -= T
	interior_area.contents += T
	T.change_area(old_area, interior_area)

// is_valid：空间是否仍可用（预留区与落脚点都健在）。复用前用它判定，失效则改为重建。
/datum/mansion_space/proc/is_valid()
	if(QDELETED(src))
		return FALSE
	if(!reservation || QDELETED(reservation))
		return FALSE
	if(!entry_turf || QDELETED(entry_turf))
		return FALSE
	return TRUE

// ensure_inside_door：确保内部回程门存在（极端情况下若丢失则补建），保证总能离开。
/datum/mansion_space/proc/ensure_inside_door()
	if(inside_door && !QDELETED(inside_door))
		return
	if(!entry_turf)
		return
	// 回程门应在落脚点正南一格（build_space 中的布置）；据 entry_turf 反推其位置。
	var/turf/inside_turf = locate(entry_turf.x, entry_turf.y - 1, entry_turf.z)
	if(inside_turf)
		inside_door = new /obj/structure/mansion_return_door(inside_turf, src)

// has_player_inside：宅邸内是否还有“玩家”（带客户端的活物）。用于空置判定。
/datum/mansion_space/proc/has_player_inside()
	if(!interior_area)
		return FALSE
	// 只数带客户端的活物（真正的玩家）；遍历 player_list 比逐格扫地块更省。
	for(var/mob/M in GLOB.player_list)
		if(QDELETED(M) || !isliving(M))
			continue
		if(get_area(M) == interior_area)
			return TRUE
	return FALSE

// bind_owner：把空间归属的躯体更新为最新。复用既有空间时调用，
// 以应对“主人换了躯体但 ckey 不变”等情况，保证监测的是当前真正的主人。
/datum/mansion_space/proc/bind_owner(mob/living/new_owner)
	owner_mob = new_owner

// process：周期性监测主人状态，落实“主人死亡 / 离开本轮 => 回收整座宅邸”的反滥用限制。
// 之所以由空间数据自身轮询（而非依附入口门）：门空置 3 分钟会消失，但空间仍在；
// 唯有空间长存，才能在“门已消失”的休眠期里继续监测主人，并在其消失/死亡时及时回收。
//
// 注意：“离开本轮”不是指物理距离远——而是指该法师角色从本局中消失。玩家通过
//       /obj/structure/far_travel 退出本轮时，其末尾会 QDEL_NULL(躯体)，于是 owner_mob
//       变为“已删除/已置空”；QDELETED 对这两种情况都返回真，故下面这一条即可统一捕获。
/datum/mansion_space/process(delta_time)
	// 主人角色已从本轮消失（被 far_travel 退出而删除躯体、或以任何方式被删除）：无主之宅，回收。
	if(QDELETED(owner_mob))
		reclaim("主人已离开本轮")
		return
	// 主人死亡：按规格回收其宅邸。
	if(owner_mob.stat == DEAD)
		reclaim("主人已死亡")

// reclaim：因主人死亡 / 离开本轮而回收整座宅邸。先给相关者提示，再 qdel 自己
//（Destroy 会负责清场——把里面的人送出——并释放预留区）。
/datum/mansion_space/proc/reclaim(reason_text)
	// 防重入：已在删除流程中则不再处理。
	if(QDELETED(src))
		return
	// 给仍在宅邸内的玩家一个明确提示（随后 Destroy 的清场会把他们送出）。
	if(interior_area)
		for(var/mob/M in GLOB.player_list)
			if(QDELETED(M) || !isliving(M))
				continue
			if(get_area(M) == interior_area)
				to_chat(M, span_userdanger("维系这处宅邸的魔力轰然崩解（[reason_text]）——空间正在坍缩！"))
	// 给主人（若仍在）一句提示。
	if(!QDELETED(owner_mob))
		to_chat(owner_mob, span_warning("我那处魔法宅邸的咒力随之消散了（[reason_text]）。"))
	qdel(src)

// eject_all_occupants：把宅邸内所有活物送回安全处。用于回收/释放预留区之前的清场，
// 避免里面的人/物随预留区一并被抹除。
/datum/mansion_space/proc/eject_all_occupants()
	if(!interior_area)
		return
	// 遍历所有活物（含无客户端的简单生物），凡其所在区域为本宅邸的，统统送出。
	for(var/mob/living/M in GLOB.mob_list)
		if(QDELETED(M))
			continue
		if(get_area(M) != interior_area)
			continue
		// 优先送回其进入前位置；失效则退而送到锚点（入口门最近所在地块，必为正常地图地块）。
		var/turf/dest = return_points?[M]
		if(!dest || QDELETED(dest))
			dest = last_anchor_turf
		if(dest && !QDELETED(dest))
			M.forceMove(dest)
			to_chat(M, span_warning("空间坍缩的瞬间，我被一股力量推回了外界。"))
	return_points = list()

// receive_visitor：把一名玩家送入宅邸，并记录其进入前位置以便日后原路送回。
// 由入口门在“被玩家触碰”时调用；返回 TRUE 表示成功（入口门据此重置空置计时）。
/datum/mansion_space/proc/receive_visitor(mob/living/M)
	// 错误处理：空间已失效（落脚点没了）则不传送。
	if(!is_valid())
		to_chat(M, span_warning("门后的空间一片紊乱，我无法踏入。"))
		return FALSE
	// 记录进入前所在地块（触碰者通常站在门外相邻格），作为回程目的地。
	return_points[M] = get_turf(M)
	// 真正传送：forceMove 简单可靠，不受锚定/重力影响。
	M.forceMove(entry_turf)
	playsound(entry_turf, 'sound/magic/blink.ogg', 60, TRUE)
	to_chat(M, span_notice("我触碰宅邸魔法门，眼前景象一花，已置身于一处空旷静谧的石室之中。"))
	return TRUE

// send_visitor_back：把一名玩家送回其进入宅邸前的位置。由内部回程门调用。
/datum/mansion_space/proc/send_visitor_back(mob/living/M)
	// 取该人进入前记录的回程地块；若已失效，则退而送到当前入口门处（若有）。
	var/turf/dest = return_points?[M]
	if(!dest || QDELETED(dest))
		dest = (active_door && !QDELETED(active_door)) ? get_turf(active_door) : null
	// 极端兜底：既无回程记录、又无入口门可去，则放弃（保持原地，避免送进虚空）。
	if(!dest)
		to_chat(M, span_warning("回程的坐标已无处可寻，我只能暂留此地，待门再度开启。"))
		return FALSE
	M.forceMove(dest)
	// 用完即清除该人的回程记录，避免无意义堆积。
	return_points -= M
	playsound(dest, 'sound/magic/blink.ogg', 60, TRUE)
	to_chat(M, span_notice("我触碰回程之门，景象再度一花，已重新回到踏入宅邸之前的位置。"))
	return TRUE

// ===========================================================================
// 入口门（临时）：本法术就地生成的门，指向某个持久空间。空置 3 分钟即自毁，但绝不释放空间。
// ===========================================================================
/obj/structure/mansion_magic_door
	name = "宅邸魔法门"
	desc = "一扇通体流转着奥术辉光的门，门后似乎别有洞天。唯有真正的旅人触碰它，方能被引入门内的空间。"
	icon = MANSION_DOOR_ICON
	icon_state = MANSION_DOOR_STATE
	anchored = TRUE                 // 固定，不可被推动
	density = TRUE                  // 实心：撞上去(Bumped)即视为“触碰”
	opacity = FALSE
	// 坚不可摧：INDESTRUCTIBLE 让主线 take_damage 直接忽略伤害（已核实）。
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	max_integrity = INFINITY
	layer = ABOVE_MOB_LAYER

	// —— 运行期状态 ——
	var/datum/mansion_space/space   // 本门所指向的持久空间（真正的数据载体）
	var/last_use = 0                // 上次传送的时刻，用于 MANSION_USE_COOLDOWN 防抖
	var/empty_since = 0             // 空间“开始空置”的时刻；0 表示当前有玩家（或刚被进入）
	var/next_occupancy_check = 0    // 下次允许做空置检测的时刻，用于节流

// New：把门接到给定的持久空间上，并开始空置检测计时。
// 注意：空间的“开辟”不在这里——由施法流程负责（复用既有或新建），门只负责“接上去”。
/obj/structure/mansion_magic_door/New(loc, datum/mansion_space/linked_space)
	..()
	space = linked_space
	// 记录本门所在地块为空间的“锚点”：用于主人“远离”判定，且门消失后该锚点仍保留。
	if(space)
		space.last_anchor_turf = get_turf(src)
	// 从创建即开始计空置：即便无人进入，满 MANSION_EMPTY_TIMEOUT 门也会消失（空间仍保留）。
	empty_since = world.time
	next_occupancy_check = world.time + MANSION_OCCUPANCY_INTERVAL
	START_PROCESSING(SSobj, src)

// Destroy：门消失。【关键】只解除与空间的关联，绝不释放空间——空间与其中之物继续保留。
/obj/structure/mansion_magic_door/Destroy()
	STOP_PROCESSING(SSobj, src)
	// 若空间当前记录的入口门正是自己，则把它清空（空间从此进入“无门”状态，等待再次施放）。
	if(space && space.active_door == src)
		space.active_door = null
	space = null
	return ..()

// Bumped：实心门被撞上即视为“触碰”——仅“玩家”可被送入宅邸。
/obj/structure/mansion_magic_door/Bumped(atom/movable/AM)
	..()
	try_enter(AM)

// attack_hand：点击门也算“触碰”，作为撞门之外的另一种交互方式。
/obj/structure/mansion_magic_door/attack_hand(mob/user)
	if(try_enter(user))
		return TRUE
	return ..()

// try_enter：统一的“触碰进入”入口。仅允许受客户端操控的活物（玩家）进入。
// 返回 TRUE 表示已处理一次有效进入尝试（无论成功与否的玩家交互）。
/obj/structure/mansion_magic_door/proc/try_enter(atom/movable/AM)
	// 仅玩家：必须是活物且当前有客户端操控；NPC/简单生物一律无效（规格要求）。
	if(!isliving(AM))
		return FALSE
	var/mob/living/M = AM
	if(!M.client)
		// 无客户端（NPC 或掉线躯壳）——按规格不允许进入，直接忽略。
		return FALSE
	// 防御：门或空间已失效。
	if(QDELETED(src) || !space)
		return FALSE
	// 防抖：两次传送之间需间隔 MANSION_USE_COOLDOWN，避免连续 Bumped 造成乒乓/刷屏。
	if(world.time < last_use + MANSION_USE_COOLDOWN)
		return TRUE
	last_use = world.time
	// 真正送入由空间负责；成功则重置“空置计时”。
	if(space.receive_visitor(M))
		empty_since = 0
		playsound(get_turf(src), 'sound/magic/blink.ogg', 60, TRUE)
	return TRUE

// process：按节流间隔检测空置；空间连续无玩家满 MANSION_EMPTY_TIMEOUT 即自毁（仅门消失）。
/obj/structure/mansion_magic_door/process(delta_time)
	// 防御：空间没了（理论不会，因空间长存）则门也失去意义，自毁。
	if(!space)
		qdel(src)
		return
	// 节流：未到下次检测时刻就跳过。
	if(world.time < next_occupancy_check)
		return
	next_occupancy_check = world.time + MANSION_OCCUPANCY_INTERVAL

	// 有玩家在内：刷新“非空置”，倒计时清零。
	if(space.has_player_inside())
		empty_since = 0
		return

	// 当前空置：若是刚开始空置则记下起点；已空置够久则销毁本门（空间保留，Destroy 不释放空间）。
	if(!empty_since)
		empty_since = world.time
		return
	if(world.time - empty_since >= MANSION_EMPTY_TIMEOUT)
		qdel(src)

// ===========================================================================
// 内部回程门：立于宅邸之中，与持久空间一同长存。仅玩家触碰即被送回进入前的位置。
// 刻意做成“独立的 /obj/structure 类型”而非入口门的子类——否则其 New() 的 ..() 会回链到
// 入口门的处理逻辑（开始空置计时/进 SSobj）造成混乱。这里单独复制一份门的外观/坚不可摧属性。
// ===========================================================================
/obj/structure/mansion_return_door
	name = "回程之门"
	desc = "一扇与外界相连的奥术之门。触碰它，便能回到踏入宅邸之前的地方。"
	icon = MANSION_DOOR_ICON
	icon_state = MANSION_DOOR_STATE
	anchored = TRUE                 // 固定，不可被推动
	density = TRUE                  // 实心：撞上去(Bumped)即视为“触碰”
	opacity = FALSE
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	max_integrity = INFINITY
	layer = ABOVE_MOB_LAYER
	// 指回其所属的持久空间：回程目的地、回程记录都存于空间数据中。
	var/datum/mansion_space/space
	var/last_use = 0                // 与入口门各自独立的防抖时钟

// New：记录所属空间引用。
/obj/structure/mansion_return_door/New(loc, datum/mansion_space/linked_space)
	..()
	space = linked_space

// Destroy：仅断开引用即可（空间由其数据统一管理，回程门通常与空间同生共死）。
/obj/structure/mansion_return_door/Destroy()
	space = null
	return ..()

// Bumped：撞上回程门即送回（仅玩家）。
/obj/structure/mansion_return_door/Bumped(atom/movable/AM)
	..()
	try_leave(AM)

// attack_hand：点击回程门也可送回（仅玩家）。
/obj/structure/mansion_return_door/attack_hand(mob/user)
	if(try_leave(user))
		return TRUE
	return ..()

// try_leave：统一的“触碰离开”入口。仅允许受客户端操控的活物（玩家）。
/obj/structure/mansion_return_door/proc/try_leave(atom/movable/AM)
	if(!isliving(AM))
		return FALSE
	var/mob/living/M = AM
	if(!M.client)
		return FALSE
	// 防御：空间已失效（理论不会）。
	if(!space || QDELETED(space))
		to_chat(M, span_warning("门后的归途忽然黯淡了下去……"))
		return TRUE
	// 防抖。
	if(world.time < last_use + MANSION_USE_COOLDOWN)
		return TRUE
	last_use = world.time
	space.send_visitor_back(M)
	playsound(get_turf(src), 'sound/magic/blink.ogg', 60, TRUE)
	return TRUE

// ===========================================================================
// 法术本体：点选式施法术，蓄力 5 秒后在玩家“选定的地块”上生成（或重新接上）入口门。
// ---------------------------------------------------------------------------
// 选用 /spell/invoked（与 flight.dm 一致）：激活后进入“点选目标”模式，蓄力满后点击一处
// 地块即在该处放门——蓄力由基类 InterceptClickOn 依 chargetime 校验，不用 do_after；
// 取消方式也很自然：蓄力未满即点击会失败溃散，或再次点击法术按钮取消选取。
// ===========================================================================
/obj/effect/proc_holder/spell/invoked/mansion_curse
	name = "魔邓肯豪宅术"
	desc = "蓄力片刻后，在选定之地开启一扇坚不可摧的宅邸魔法门，门后是一处可供荒野安身、且会被保留的独立石室空间。"
	school = "transmutation"
	spell_tier = 3                          // T3 法术
	cost = MANSION_SPELL_COST               // 法力/法术点消耗 = 6
	releasedrain = MANSION_SPELL_DRAIN      // 施放抽取的疲劳（“消耗大”）
	chargedrain = 0
	chargetime = MANSION_CHARGE_TIME        // 蓄力 5 秒（基类点击拦截会校验是否蓄满）
	recharge_time = MANSION_SPELL_COOLDOWN  // 冷却 5 分钟（由 charge_check 强制执行）
	cooldown_min = MANSION_SPELL_COOLDOWN   // 即便被“加速”，冷却也不低于 5 分钟
	human_req = TRUE                        // 只有人类施法者能施放
	warnie = "spellwarning"
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "mansion_curse"         // 动作按钮图标态（若 dmi 暂无该态仅显示为空，不影响编译）
	invocations = list("为我开辟空间吧！")    // 咒文（成功施放时由框架喊出）
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE                  // 未蓄满不允许提前释放
	movement_interrupt = FALSE              // 与 flight.dm 一致：蓄力期间可移动
	charging_slowdown = 2                    // 蓄力时减速，体现“凝聚伟力”的代价
	chargedloop = /datum/looping_sound/invokegen // 蓄力期间循环施法音效
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE
	range = MANSION_PLACE_RANGE             // 可选定放门地块的最大距离
	miracle = FALSE
	xp_gain = TRUE

// cast：蓄力满后由基类 InterceptClickOn -> perform 调用；targets[1] 即玩家点选的目标。
// 在选定地块生成入口门——已有持久宅邸则“复用”（把门挪到新选点），没有才新建。
/obj/effect/proc_holder/spell/invoked/mansion_curse/cast(list/targets, mob/living/user = usr)
	// 解析玩家点选的放门地块（点到物体/生物时取其所在地块）。
	var/atom/target_atom = targets[1]
	var/turf/place_turf = get_turf(target_atom)
	// 错误处理：选点无效（无地块）。
	if(!place_turf)
		to_chat(user, span_warning("那里无处可供门扉立足。"))
		revert_cast()
		return FALSE

	// 错误处理：不能把门开在墙里/实心封闭地块上。
	if(isclosedturf(place_turf) || place_turf.density)
		to_chat(user, span_warning("这道门无法在如此封闭之处成形。"))
		revert_cast()
		return FALSE

	// 错误处理：该地块已有入口门，避免在同一格叠门。
	if(locate(/obj/structure/mansion_magic_door) in place_turf)
		to_chat(user, span_warning("那里已经矗立着一扇宅邸魔法门了。"))
		revert_cast()
		return FALSE

	// 错误处理：持久空间按 ckey 归属，没有 ckey 无法绑定/复用，拒绝施放。
	var/owner_key = user.ckey
	if(!owner_key)
		to_chat(user, span_warning("一股莫名的阻滞让这道咒法无法与我相连。"))
		revert_cast()
		return FALSE

	// 查注册表：该施法者是否已拥有一处持久宅邸。
	var/datum/mansion_space/space = GLOB.mansion_magic_spaces[owner_key]

	// 分支 A：已有且仍有效 => 复用同一空间，在选定地块新建一扇入口门接上去。
	if(space && space.is_valid())
		// 更新归属躯体（应对“换了躯体但 ckey 不变”），确保监测的是当前真正的主人。
		space.bind_owner(user)
		// 若该空间当前已有入口门（在别处），视为“把门挪到此处”：先拆旧门（其 Destroy 不释放空间）。
		if(space.active_door && !QDELETED(space.active_door))
			qdel(space.active_door)
		// 极端兜底：内部回程门若丢失则补建，保证进去后总能出来。
		space.ensure_inside_door()
		// 在选定地块放门（door New 会把 last_anchor_turf 更新为该地块）。
		var/obj/structure/mansion_magic_door/door = new(place_turf, space)
		space.active_door = door
		playsound(place_turf, 'sound/magic/whiteflame.ogg', 70, TRUE)
		user.visible_message(
			span_warning("[user] 念诵咒文，于选定之地撕开一道门扉——门后透出的，正是那处熟悉的石室！"),
			span_notice("我在选定的位置再次撕开空间，通往我那处既有宅邸的门扉重新矗立——里面的一切都还在。")
		)
		return TRUE

	// 分支 B：没有（或既有的已失效）=> 新建一处持久空间并登记。
	// 若既有记录已失效，先清理掉它，避免注册表残留坏引用。
	if(space)
		GLOB.mansion_magic_spaces -= owner_key
		qdel(space)
	// 新建空间时一并绑定当前躯体为主人，供“死亡/远离”监测使用。
	space = new /datum/mansion_space(owner_key, user)
	// 错误处理：开辟失败（预留 z 层耗尽等）——丢弃空间、退还冷却、提示。
	if(!space.build_space())
		qdel(space)
		to_chat(user, span_warning("奥术空间无法成形——也许此界的缝隙已被撑满了。"))
		revert_cast()
		return FALSE
	// 登记入注册表，使其长存、可被日后再次施放复用。
	GLOB.mansion_magic_spaces[owner_key] = space
	var/obj/structure/mansion_magic_door/door = new(place_turf, space)
	space.active_door = door
	playsound(place_turf, 'sound/magic/whiteflame.ogg', 70, TRUE)
	user.visible_message(
		span_warning("[user] 念诵咒文，于选定之地撕开一道门扉——门后竟透出一处石室的光亮！"),
		span_notice("我在选定的位置撕开空间，一扇坚不可摧的宅邸魔法门就此矗立——它身后的空间会被保留，但若我死亡，它便会随之坍缩。")
	)
	return TRUE

// ===== 清理顶部定义的宏，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef MANSION_INNER_SIZE
#undef MANSION_BLOCK_SIZE
#undef MANSION_CENTER_OFFSET
#undef MANSION_EMPTY_TIMEOUT
#undef MANSION_OCCUPANCY_INTERVAL
#undef MANSION_USE_COOLDOWN
#undef MANSION_FLOOR_TURF
#undef MANSION_WALL_TURF
#undef MANSION_DOOR_ICON
#undef MANSION_DOOR_STATE
#undef MANSION_SPELL_COST
#undef MANSION_SPELL_DRAIN
#undef MANSION_SPELL_COOLDOWN
#undef MANSION_CHARGE_TIME
#undef MANSION_PLACE_RANGE
