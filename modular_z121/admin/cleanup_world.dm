// =============================================================================
// 世界清理管理指令 —— "Clean up the world"
// 归类：-GameMaster-
// 行为：管理员触发后，先发布一条全服醒目公告，告知玩家 60 秒后将进行清扫，
//       请大家收好地上需要的物品；60 秒后删除整张地图地面上的下列杂物：
//       器官、武器、头颅、肢体、骨头、肉、腐肉，以及“非玩家”尸体。
// 设计要点（为什么这样写）：
//   * 用类型缓存(typecache)而非逐个 istype()，因为世界物品数量庞大，
//     O(1) 的关联数组查找能显著降低单次清理造成的卡顿。
//   * 倒计时通过 addtimer 异步排程，避免阻塞游戏主循环；管理员在确认前可取消。
//   * 尸体只删“从未被玩家控制过”的，绝不误删可复活/可返回的玩家躯体。
// 仅本文件 + _load.dm 的一行 include 改动，全部位于 modular_z121 之内。
// =============================================================================

// 倒计时时长（单位：游戏刻 deciseconds）。做成宏，使“公告文案”与“定时器”共用
// 同一数值，避免两处各写一遍而产生不一致。60 SECONDS 经 time.dm 宏展开为 600。
#define WORLD_CLEANUP_DELAY (60 SECONDS)

// -----------------------------------------------------------------------------
// 目标物品类型缓存
// 返回一个 type -> TRUE 的关联表，包含所有需要被清理的物品“基类及其子类”。
// 之所以独立成 proc：倒计时结束后的真正删除逻辑会再次调用它，集中维护一处即可。
// -----------------------------------------------------------------------------
/proc/world_cleanup_item_typecache()
	// typecacheof() 会把列表中每个基类连同其所有子类一并展开进缓存，
	// 因此“头颅”(/obj/item/bodypart/head) 已被“肢体”(/obj/item/bodypart) 覆盖，
	// “生肉/腐肉”同属 rogue/meat 基类（腐肉只改名不换类型）也一并覆盖。
	return typecacheof(list(
		/obj/item/organ,                                       // 器官（内脏、眼睛等）
		/obj/item/rogueweapon,                                 // 武器（roguetown 所有武器的基类）
		/obj/item/bodypart,                                    // 肢体（含 /obj/item/bodypart/head 头颅子类）
		/obj/item/natural/bone,                                // 骨头
		/obj/item/reagent_containers/food/snacks/rogue/meat,   // 肉（生肉 + 同类型的腐肉）
	))

// -----------------------------------------------------------------------------
// 判断单个物品是否应被清理
// 把“是否删除”的判定独立出来，便于阅读，也便于以后扩展更多边界规则。
// -----------------------------------------------------------------------------
/proc/world_cleanup_should_delete_item(obj/item/I, list/item_typecache)
	// 物品已在删除队列/为空，直接跳过，避免对失效对象二次操作。
	if(QDELETED(I))
		return FALSE
	// 只清理“掉在地面上”的物品：loc 必须是 turf。
	// 这样背包、容器、尸体身上、载具内携带的物品都会被保留。
	if(!isturf(I.loc))
		return FALSE
	// 命中目标类型缓存即可删除。
	if(item_typecache[I.type])
		return TRUE
	// 额外兜底“腐肉/腐烂食物”：某些腐烂食物可能并非 rogue/meat 子类，
	// 但其 eat_effect 会在腐烂后被置为 rotfood。据此再捞一遍，确保腐肉被清掉。
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/snack = I
		if(snack.eat_effect == /datum/status_effect/debuff/rotfood)
			return TRUE
	return FALSE

// -----------------------------------------------------------------------------
// 判断某个躯体是否为“可被清理的非玩家尸体”
// 安全第一：任何曾经/正在与玩家关联的躯体都必须保留。
// -----------------------------------------------------------------------------
/proc/world_cleanup_is_npc_corpse(mob/living/L)
	// 类型保险：非 living 的 mob（如 /mob/dead/observer 灵魂）一律不处理。
	if(!istype(L))
		return FALSE
	// 已在删除队列则跳过。
	if(QDELETED(L))
		return FALSE
	// 必须确实是“尸体”——已死亡。活着的 NPC 不在清扫范围内。
	if(L.stat != DEAD)
		return FALSE
	// 必须躺在地面（loc 为 turf），而非被容器/载具/其他生物携带。
	if(!isturf(L.loc))
		return FALSE
	// 关键保护：只要该躯体当前持有 client（在线）、ckey/key（占用过账号）、
	// 或绑定了 mind（拥有意识/可被玩家附身返回），就视为“玩家相关”，绝不删除。
	if(L.client || L.ckey || L.key || L.mind)
		return FALSE
	return TRUE

// -----------------------------------------------------------------------------
// 真正执行清理（倒计时结束后由定时器回调）
// initiator_name：触发者的 key_name 字符串，仅用于日志与管理频道广播。
// -----------------------------------------------------------------------------
/proc/world_cleanup_perform(initiator_name)
	// 预先构建一次类型缓存，循环内重复查表，避免反复重建。
	var/list/item_typecache = world_cleanup_item_typecache()
	var/deleted_items = 0     // 统计已删除的地面物品数量，便于反馈与排查。
	var/deleted_corpses = 0   // 统计已删除的非玩家尸体数量。

	// —— 第一步：清理地面物品 ——
	// 遍历世界所有 /obj/item。逐个交由判定函数决定是否删除。
	// 用 try/catch 兜住极端情况下单个对象删除时可能抛出的运行时错误，
	// 保证一颗坏对象不会中断整轮清理（满足“某项效果失败仍继续”的要求）。
	for(var/obj/item/I in world)
		try
			if(!world_cleanup_should_delete_item(I, item_typecache))
				continue
			qdel(I)
			deleted_items++
		catch(var/exception/item_error)
			// 记录但不中断：把出错对象与原因写入管理日志，方便事后定位。
			log_admin("World cleanup failed to delete an item ([I ? I.type : "null"]): [item_error]")

	// —— 第二步：清理非玩家尸体 ——
	// 遍历 GLOB.dead_mob_list（全体死亡生物，性能远优于再遍历一遍 world），
	// 仅删除通过非玩家尸体校验的躯体。
	for(var/mob/living/L in GLOB.dead_mob_list)
		try
			if(!world_cleanup_is_npc_corpse(L))
				continue
			qdel(L)
			deleted_corpses++
		catch(var/exception/corpse_error)
			log_admin("World cleanup failed to delete a corpse ([L ? L.type : "null"]): [corpse_error]")

	// —— 第三步：结果回执 ——
	// 把本轮清理的统计结果写入管理日志并广播到管理频道，形成可追溯记录。
	log_admin("World cleanup (triggered by [initiator_name]) removed [deleted_items] ground item(s) and [deleted_corpses] non-player corpse(s).")
	message_admins(span_adminnotice("World cleanup (triggered by [initiator_name]) removed [deleted_items] ground item(s) and [deleted_corpses] non-player corpse(s)."))

// -----------------------------------------------------------------------------
// 管理指令本体（GameMaster 分类下的可调用动词）
// -----------------------------------------------------------------------------
/client/proc/cleanup_world()
	set category = "-GameMaster-"
	set name = "Clean up the world"
	set desc = "Announce a 60-second warning, then delete loose organs, weapons, heads, limbs, bones, meat, rotten meat, and non-player corpses from the ground."

	// 权限校验：只有具备管理员权限者可执行，防止越权调用。
	if(!check_rights(R_ADMIN))
		return

	// 二次确认对话框：给管理员一个“优雅取消”的入口（满足可取消的要求）。
	// 选择 Cancel 或直接关闭弹窗（返回值非 "Yes"）都会安全中止。
	var/confirm = alert(src,
		"This will broadcast a server-wide warning and, in 60 seconds, delete loose organs, weapons, heads, limbs, bones, meat, rotten meat, and non-player corpses from every ground tile. Proceed?",
		"Clean up the world",
		"Yes", "Cancel")
	if(confirm != "Yes")
		// 明确告知已取消，避免管理员误以为指令已生效。
		to_chat(src, span_notice("World cleanup cancelled. No announcement was made and nothing will be deleted."))
		return

	// 发布全服醒目公告：使用 priority_announce 弹出带标题的高亮通知并播放提示音，
	// 让全场玩家都能注意到清扫预告，从而有时间收好地面上需要保留的物品。
	priority_announce(
		"The world will be cleaned in 60 seconds! Loose organs, weapons, heads, limbs, bones, meat, rotten meat, and stray corpses left on the ground will be swept away. Please pick up anything you wish to keep!",
		title = "WORLD CLEANUP INCOMING",
		sound = 'sound/misc/bell.ogg')

	// 即时反馈给触发者本人 + 写入管理日志/管理频道，形成操作留痕。
	to_chat(src, span_notice("World cleanup announced. Ground items and non-player corpses will be purged in 60 seconds."))
	log_admin("[key_name(usr)] started a world cleanup; the ground purge will run in 60 seconds.")
	message_admins(span_adminnotice("[key_name_admin(usr)] started a world cleanup; the ground purge will run in 60 seconds."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Clean up the world")

	// 排程 60 秒后执行真正的删除逻辑。使用 addtimer 异步回调全局 proc，
	// 既不阻塞主循环，也保证倒计时与公告文案中的 60 秒一致。
	// 传入 key_name(usr) 作为发起者标识，供清理完成后的日志与广播使用。
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(world_cleanup_perform), key_name(usr)), WORLD_CLEANUP_DELAY)

// 用完即清，避免该宏名泄漏到其他文件污染全局命名空间。
#undef WORLD_CLEANUP_DELAY
