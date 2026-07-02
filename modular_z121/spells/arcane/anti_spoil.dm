// modular_z121 自定义奥术法术：防腐净化 / Anti-Spoil
// ---------------------------------------------------------------------------
// 设计目标：一个 T1（一阶）低耗实用法术。激活法术 -> 短暂蓄力 -> 点击选定
//           【一件食物】-> 移除它的“变质(Spoiled/发霉发馊)”与“腐烂(Rotten)”
//           状态，把它复原成“新鲜(Fresh)”品质。
//
// 为什么这样做（why）：本 fork 的食物腐败由主线 snacks.dm 驱动，其“新鲜度”其实
//   是由两个量共同表达的——
//     1) `warming`：新鲜度计时量。初值 = 5 分钟（正数=热乎/新鲜）；随着 process()
//        逐 tick 递减，越负越“不新鲜/变质(Spoiled/stale)”。examine 的
//        “very fresh / going stale / about to rot” 文本正是由它算出的。
//     2) `become_rotten()` 造成的“已腐烂(Rotten)”终态：当 warming 跌破 -rotprocess
//        时触发，会把 eat_effect 改成 /datum/status_effect/debuff/rotfood、
//        改名为 "rotten X"、变色、叠加苍蝇贴图，并 STOP_PROCESSING 停止继续处理。
//   因此“恢复新鲜”= 同时撤销这两层状态：把 warming 复位到初值（去掉“变质”），
//   并逆转 become_rotten() 的全部改动（去掉“腐烂”），最后重新启动腐败流程让它
//   日后还能正常变质。
//
// 选取/蓄力方式：沿用 magic_satiety.dm / flight.dm 的做法——以 /spell/invoked
//   为基类，靠点击选取目标（targets[1]），蓄力由基类 InterceptClickOn 依据
//   chargetime 校验完成；不使用弹窗，也不使用 do_after。玩家可再次点击法术图标
//   （deactivate）来【取消】选取，符合“优雅取消”的要求。
//
// 约束：所有代码只存在于 modular_z121 内，仅“调用/复用”主线已有系统（snacks.dm
//   的 warming/rotprocess/eat_effect 字段与 begin_rotting 处理），不修改
//   modular_z121 之外的任何文件。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数（文件末尾统一 #undef，避免污染全局命名空间）=====
#define ANTISPOIL_MANA_COST      1             // 法力 / 法术点消耗（cost）= 1（符合 T1 低耗定位）
#define ANTISPOIL_RESOURCE_COST  8             // 每次施放抽取的疲劳/耐力（releasedrain），小额
#define ANTISPOIL_CHANNEL_TIME   (1 SECONDS)   // 蓄力时长（由 invoked 基类点击拦截按 chargetime 校验）
#define ANTISPOIL_COOLDOWN       (10 SECONDS)  // 成功施放后的冷却
#define ANTISPOIL_TARGET_RANGE   7             // 点击选取目标的最大距离（range）

// ===========================================================================
// 法术本体
// ---------------------------------------------------------------------------
// 选用 /spell/invoked 作为基类：点击图标进入“点选目标”模式，蓄满后点击某件食物即
// 对其生效。这样既能精准点选一件食物，又不需要弹窗或 do_after。
// ===========================================================================
/obj/effect/proc_holder/spell/invoked/anti_spoil
	name = "防腐净化"                              // 玩家可见名（中文，符合本项目约定）
	desc = "一道朴素的一阶奥术。指尖微光拂过一件腐坏的食物，驱散其上的馊腐与霉烂，令它重归新鲜。"
	school = "transmutation"                      // 变形/转化系：改变物体状态
	spell_tier = 1                               // T1（一阶）法术
	cost = ANTISPOIL_MANA_COST                   // 法力 / 法术点消耗 = 1
	releasedrain = ANTISPOIL_RESOURCE_COST       // 额外资源消耗（疲劳/耐力）= 8
	chargetime = ANTISPOIL_CHANNEL_TIME          // 蓄力 1 秒（基类点击拦截会校验是否蓄满）
	recharge_time = ANTISPOIL_COOLDOWN           // 冷却 = 10 秒（由 charge_check 强制执行）
	cooldown_min = ANTISPOIL_COOLDOWN            // 即便被“加速”，冷却也不会低于 10 秒
	human_req = TRUE                             // 只有人类施法者能施放
	warnie = "spellwarning"                      // 施法失败/警告用的图标态
	action_icon = 'modular_z121/icon/custompell.dmi' // 动作按钮图标来源（项目自定义法术图集）
	overlay_state = "anti_spoil"                 // 动作按钮图标态（若 dmi 暂无该态仅显示为空，不影响编译）
	invocations = list("腐朽退散，鲜洁如初！")       // 咒文（成功施放时由框架喊出，中文）
	invocation_type = "shout"                    // 以“喊出”的方式念咒
	glow_color = GLOW_COLOR_ARCANE               // 施法辉光颜色（奥术）
	glow_intensity = GLOW_INTENSITY_LOW          // 低强度辉光（低阶小术）
	no_early_release = TRUE                      // 未蓄满不允许提前释放
	movement_interrupt = FALSE                   // 与 magic_satiety 一致：蓄力期间允许移动
	charging_slowdown = 1                        // 蓄力时略微减速
	chargedloop = /datum/looping_sound/invokegen // 蓄力期间循环施法音效
	associated_skill = /datum/skill/magic/arcane // 关联技能：奥术（用于 xp_gain 判定）
	gesture_required = TRUE                      // 需要能自由活动的手来引导法术
	range = ANTISPOIL_TARGET_RANGE               // 点选目标的最大距离
	miracle = FALSE                              // 非神术/奇迹
	xp_gain = TRUE                               // 成功施放给予奥术经验
	sound = null                                 // 蓄力音由 chargedloop 负责；命中音效在 cast 内单独播放

// ---------------------------------------------------------------------------
// restore_freshness：把一件食物“复原为新鲜”的核心逻辑，独立成 proc 便于复用与调参。
// 参数 F 为已判定合法的目标食物。返回 TRUE 表示确实改变了状态（有东西被复原），
// 返回 FALSE 表示该食物本就新鲜、无需处理（供 cast 决定是否退还冷却）。
//
// why：把“判定”与“执行”分离——cast() 负责类型/合法性校验与表现层反馈，本 proc 只
// 专注于精确地撤销主线 become_rotten() 与 warming 老化所带来的两层状态。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/anti_spoil/proc/restore_freshness(obj/item/reagent_containers/food/snacks/F)
	// did_anything：只要撤销了“变质”或“腐烂”任一层，就置 TRUE；用于最终返回值。
	var/did_anything = FALSE

	// ---- 第一层：撤销“已腐烂(Rotten)”终态 ----
	// 判据：become_rotten() 的就地腐烂会把 eat_effect 设为 /datum/status_effect/debuff/rotfood。
	// 只有处于该终态才需要逆转外观与字段（否则会把正常食物的字段误改）。
	if(F.eat_effect == /datum/status_effect/debuff/rotfood)
		// become_rotten() 曾用同样的 mutable_appearance 叠加苍蝇贴图；这里重建一个
		// 完全相同的 MA 再 cut_overlay，即可按外观匹配移除那层苍蝇覆盖（DM 按外观比对）。
		var/mutable_appearance/rotflies = mutable_appearance('icons/roguetown/mob/rotten.dmi', "rotten")
		F.cut_overlay(rotflies)                          // 去掉苍蝇乱飞的腐烂贴图

		// 逐一把 become_rotten() 改动过的字段复位到该食物类型的“出厂初值”，
		// 用 initial() 取编译期默认值，保证复原到它本来的新鲜形态而非硬编码。
		F.color = initial(F.color)                       // 复原被染成的腐坏灰紫色 "#6c6897"
		F.name = initial(F.name)                         // 去掉 "rotten " 前缀，恢复本名
		F.eat_effect = initial(F.eat_effect)             // 清除 rotfood 负面进食效果
		F.slices_num = initial(F.slices_num)             // 恢复可切片数（腐烂时被清 0）
		F.slice_path = initial(F.slice_path)             // 恢复切片产物路径（腐烂时被清 null）
		F.cooktime = initial(F.cooktime)                 // 恢复烹饪时间（腐烂时被清 0）
		did_anything = TRUE                              // 记录：确实撤销了“腐烂”这一层

	// ---- 第二层：撤销“变质/发馊(Spoiled/stale)”老化 ----
	// warming 越负越不新鲜；把它复位到出厂初值（默认 5 分钟正数=最新鲜），
	// examine 的新鲜度文本随即回到 “very fresh”。用 initial() 而非硬编码以适配各类食物。
	// 只有当它当前确实“不如初值新鲜”时才处理，避免对本就满新鲜的食物做无意义写入。
	if(F.warming < initial(F.warming))
		F.warming = initial(F.warming)                   // 复位新鲜度计时量 -> 重新变得“很新鲜”
		did_anything = TRUE                              // 记录：确实撤销了“变质”这一层

	// ---- 复原后：重新启动腐败流程 ----
	// become_rotten() 触发时会 STOP_PROCESSING 停止老化；若这件食物本会腐坏(rotprocess)，
	// 复原后需重新挂回 SSobj 处理，使其日后仍能按正常节奏再次变质（否则会“永鲜”）。
	// 复用主线的 begin_rotting()（内部即 START_PROCESSING(SSobj, src)），语义清晰且安全。
	if(did_anything && F.rotprocess)
		F.begin_rotting()

	return did_anything

// ---------------------------------------------------------------------------
// cast：点击命中目标后由基类 InterceptClickOn -> perform 调用。
// targets[1] 即施法者点中的目标。
// 返回值约定：
//   - TRUE  -> perform() 调用 start_recharge()，进入冷却（施法成功）。
//   - FALSE -> 调用 revert_cast() 退还冷却（目标无效 / 反魔法 / 无需处理）。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/anti_spoil/cast(list/targets, mob/living/user = usr)
	// 防御性校验：理论上 targets 恒有一个元素，但仍先判空，避免异常点击导致运行时报错。
	if(!length(targets))
		to_chat(user, span_warning("没有选中任何目标。"))
		revert_cast()
		return FALSE

	var/atom/target_atom = targets[1]

	// 类型校验：本法术只作用于食物（/obj/item/reagent_containers/food/snacks）。
	// 点到非食物（人、地板、其它物件）时给出提示并退还冷却——这也是“优雅处理无效目标”。
	if(!istype(target_atom, /obj/item/reagent_containers/food/snacks))
		to_chat(user, span_warning("『防腐净化』只能施加在食物上。"))
		revert_cast()
		return FALSE

	var/obj/item/reagent_containers/food/snacks/food = target_atom

	// 防御性校验：目标可能在蓄力期间被销毁（吃掉/烧掉等）。QDELETED 判定可避免对
	// 失效对象继续操作导致运行时报错。anti_magic_check() 仅定义于 /mob，故食物对象
	// 不适用反魔法检定，这里改为对象存活性校验。
	if(QDELETED(food))
		to_chat(user, span_warning("目标食物已经不在了。"))
		revert_cast()
		return FALSE

	// 调用核心逻辑执行复原；返回 FALSE 表示这件食物本就新鲜，无需净化。
	// 此时不消耗冷却（退还），给出合理反馈，避免玩家白白空放。
	if(!restore_freshness(food))
		to_chat(user, span_warning("[food] 本就新鲜可口，无需净化。"))
		revert_cast()
		return FALSE

	// ---- 表现层反馈（成功）----
	// 播放一声轻柔的“净化”音效并刷新外观（虽然改 color/name 会自动刷新，这里显式
	// update_icon 兜底，确保切片数等衍生外观也同步）。
	playsound(get_turf(food), 'sound/magic/whiteflame.ogg', 40, TRUE)
	food.update_icon()
	user.visible_message(
		span_notice("[user] 指尖泛起一缕奥术微光，拂过 [food]——馊腐霉气尽数消散，它重新变得新鲜。"),
		span_notice("我以奥术之力驱散了 [food] 上的腐坏，令它重归新鲜。")
	)
	return TRUE

// ===== 清理顶部定义的宏，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef ANTISPOIL_MANA_COST
#undef ANTISPOIL_RESOURCE_COST
#undef ANTISPOIL_CHANNEL_TIME
#undef ANTISPOIL_COOLDOWN
#undef ANTISPOIL_TARGET_RANGE
