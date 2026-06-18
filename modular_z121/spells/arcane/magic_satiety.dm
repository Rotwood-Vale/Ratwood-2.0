// modular_z121 自定义奥术法术：魔力果腹（Magic Satiety）
// ---------------------------------------------------------------------------
// 设计目标：一个 T2 实用法术。激活法术 -> 框架蓄力 3 秒 -> 点击选定一名目标
//           （点自己或点他人）-> 为目标恢复一部分饱食度（饥饿值）。
//           恢复量随“施法者”的奥术技能等级缩放；同时给目标施加一个固定时长的
//           心情负面（压力）事件，提示：“我难道只能以魔法果腹吗？”。
//
// 选取/蓄力方式：完全沿用 flight.dm 的做法——以 /spell/invoked 为基类，靠点击
//           选取目标（targets[1]），蓄力由基类 InterceptClickOn 依据 chargetime
//           校验完成；不使用弹窗，也不使用 do_after。
//
// 约束：所有代码都只存在于 modular_z121 内，仅“调用”主线已有系统
//       （mob.adjust_nutrition / carbon.add_stress 与 /datum/stressevent），
//       不修改 modular_z121 之外的任何文件。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数（文件末尾统一 #undef，避免污染全局命名空间）=====
#define SATIETY_MANA_COST       4             // 法力 / 法术点消耗（cost）
#define SATIETY_RESOURCE_COST   20            // 每次施放抽取的疲劳/耐力（releasedrain）
#define SATIETY_CHANNEL_TIME    (3 SECONDS)   // 蓄力时长（由 invoked 基类的点击拦截按 chargetime 校验）
#define SATIETY_COOLDOWN        (30 SECONDS)  // 成功施放后的冷却（30 秒）
#define SATIETY_TARGET_RANGE    7             // 点击选取目标的最大距离（range）

// 饱食度恢复量的缩放参数：最终恢复量 = 基础值 + 奥术等级 * 每级增量。
// 取“适中”量：0 级约 150，6 级约 450（满饱食 NUTRITION_LEVEL_FULL = 1000 作参照）。
// 拆成两个旋钮便于单独微调“底子”与“成长曲线”。
#define SATIETY_RESTORE_BASE    150           // 基础恢复量（即便毫无奥术造诣也能回这么多）
#define SATIETY_RESTORE_PER_LVL 50            // 每级奥术额外恢复量

// 心情负面（压力）事件的固定持续时间。规格要求“固定时长”，因此独立成常量。
#define SATIETY_DEBUFF_DURATION (5 MINUTES)

// ===========================================================================
// 法术本体
// ---------------------------------------------------------------------------
// 选用 /spell/invoked 作为基类（与 flight.dm 一致）：点击图标后进入“点选目标”模式，
// 蓄力满后点击某个生物即对其生效；点自己即作用于自身，点他人即作用于他人。
// 这样既能“对自己或他人施放”，又不需要弹窗或 do_after。
// ===========================================================================
/obj/effect/proc_holder/spell/invoked/magic_satiety
	name = "魔力果腹"
	desc = "一道以魔力充饥的法术。除非身边再无任何食物，否则不建议使用——它会带来精神上的副作用。"
	school = "transmutation"
	spell_tier = 2                          // T2 法术
	cost = SATIETY_MANA_COST                // 法力 / 法术点消耗 = 4
	releasedrain = SATIETY_RESOURCE_COST    // 额外资源消耗（疲劳/耐力）= 20
	chargetime = SATIETY_CHANNEL_TIME       // 蓄力 3 秒（基类点击拦截会校验是否蓄满）
	recharge_time = SATIETY_COOLDOWN        // 冷却 = 30 秒（由 charge_check 强制执行）
	cooldown_min = SATIETY_COOLDOWN         // 即便被“加速”，冷却也不会低于 30 秒
	human_req = TRUE                        // 只有人类施法者能施放
	warnie = "spellwarning"
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "magic_satiety"         // 动作按钮图标态（若 dmi 暂无该态仅显示为空，不影响编译）
	invocations = list("以魔力果腹！")       // 咒文（成功施放时由框架喊出）
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE                  // 未蓄满不允许提前释放
	movement_interrupt = FALSE              // 与 flight.dm 一致：蓄力期间可移动
	charging_slowdown = 1                   // 蓄力时略微减速
	chargedloop = /datum/looping_sound/invokegen // 蓄力期间循环施法音效
	associated_skill = /datum/skill/magic/arcane // 恢复量缩放所依据的技能：奥术
	gesture_required = TRUE                  // 需要能自由活动的手
	range = SATIETY_TARGET_RANGE            // 点选目标的最大距离
	miracle = FALSE
	xp_gain = TRUE
	sound = null                            // 蓄力音由 chargedloop 负责；命中音效在 cast 内单独播放

// ---------------------------------------------------------------------------
// 恢复量缩放：根据“施法者”的奥术技能等级，返回本次恢复的饱食度数值。
// 用 clamp(0,6) 把技能等级限制在合理区间，避免出现负数或异常放大。
// 独立成 proc 便于单独调参与复用，也让 cast() 主流程更清爽。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/magic_satiety/proc/get_restore_amount(skill_level)
	// clamp 处理越界：未入门(0) 取下限，>6 取上限，满足“就近钳制”。
	var/effective_level = clamp(skill_level, 0, 6)
	return SATIETY_RESTORE_BASE + (effective_level * SATIETY_RESTORE_PER_LVL)

// ---------------------------------------------------------------------------
// cast：点击命中目标后由基类 InterceptClickOn -> perform 调用。
// targets[1] 即施法者点中的目标（点自己或点他人）。
// 返回值约定：
//   - TRUE  -> perform() 调用 start_recharge()，进入 30 秒冷却（施法成功）。
//   - FALSE -> 调用 revert_cast() 退还冷却（目标无效 / 被反魔法挡下 / 吃不下）。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/magic_satiety/cast(list/targets, mob/living/user = usr)
	// 点击式选取：targets[1] 必须是活物，否则视为无效目标。
	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		to_chat(user, span_warning("魔力果腹只能施加在活物身上。"))
		revert_cast()
		return FALSE

	var/mob/living/target = target_atom

	// 反魔法检定：被反魔法保护的目标无法接受这道魔力（即便是用来充饥的）。
	if(target.anti_magic_check())
		target.visible_message(
			span_warning("[target] 周身泛起反魔法的涟漪，将那缕充饥魔力挡了下来。"),
			span_notice("一缕外来的魔力试图化作食物涌入我体内，却被我身上的反魔法弹开了。")
		)
		to_chat(user, span_warning("[target] 身上的反魔法抵消了『魔力果腹』。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		revert_cast()
		return FALSE

	// 无饥饿特质（TRAIT_NOHUNGER）的目标本就不会饿，喂魔力没有意义：
	// 给出提示并退还冷却，避免白白浪费一次施法与承受副作用。
	if(HAS_TRAIT(target, TRAIT_NOHUNGER))
		to_chat(user, span_warning("[target] 根本不会感到饥饿，这道法术对 [target.p_them()] 毫无意义。"))
		revert_cast()
		return FALSE

	// 关键：恢复量取决于“施法者”的奥术技能等级（不是目标的）。
	var/caster_skill = user.get_skill_level(associated_skill)
	var/restore_amount = get_restore_amount(caster_skill)

	// 记录施法前的饱食度，用于判断是否真的回了值（已满则没必要承受副作用）。
	var/old_nutrition = target.nutrition
	// adjust_nutrition：正值即增加饱食度，内部已自动钳制在 [0, NUTRITION_LEVEL_FULL]。
	target.adjust_nutrition(restore_amount)

	// 防御性校验：若目标饱食度本就已满（adjust 后没有任何变化），视为“吃不下”，
	// 不施加心情副作用、退还冷却，给出合理反馈。
	if(target.nutrition <= old_nutrition)
		to_chat(user, span_warning("[target] 已经饱了，再多的魔力之食也吃不下了。"))
		revert_cast()
		return FALSE

	// 施加固定时长的心情负面（压力）事件——这正是描述中“精神上的副作用”。
	// add_stress 只对 carbon（人类等）有效；对简单动物等非 carbon 目标会是无操作，
	// 因此这里做类型判断，仅在可承受心情系统的目标上施加，避免无意义调用。
	if(iscarbon(target))
		target.add_stress(/datum/stressevent/magic_satiety)

	// 表现层反馈。
	playsound(get_turf(target), 'sound/misc/eat.ogg', 50, TRUE)
	if(target == user)
		user.visible_message(
			span_notice("[user] 指尖的奥术微光没入口中，[user.p_their()] 神情似乎安定了些许，却又掠过一丝怅然。"),
			span_notice("一股奇异的魔力化作食物的暖意在腹中散开，我的饥饿被压下了——可总觉得，这并不是真正的食物。")
		)
	else
		user.visible_message(
			span_notice("[user] 朝 [target] 轻点一指，一缕化作食物的奥术微光没入 [target] 体内。"),
			span_notice("我将一缕充饥的魔力喂给了 [target]。")
		)
		to_chat(target, span_notice("一股奇异的魔力化作食物的暖意在腹中散开，我的饥饿被压下了——可总觉得，这并不是真正的食物。"))
	return TRUE

// ===========================================================================
// 心情负面（压力）事件：魔力果腹的精神副作用
// ---------------------------------------------------------------------------
// /datum/stressevent 的字段：
//   timer      —— 事件持续时间；carbon.update_stress() 会在到期后自动移除（实现“固定时长”）。
//   stressadd  —— 施加的压力值（正值 = 负面心情）。
//   desc       —— 在心情/压力面板里展示给玩家的描述文字（即规格要求的提示语）。
// 由于 add_stress 会自动 new 出本数据，这里只需声明默认值即可，无需额外逻辑。
// ===========================================================================
/datum/stressevent/magic_satiety
	timer = SATIETY_DEBUFF_DURATION                 // 固定持续时间（到期自动清除）
	stressadd = 2                                   // 适中的负面心情值
	desc = span_red("我难道只能以魔法果腹吗？")        // 规格要求展示的副作用提示语

// ===== 清理顶部定义的宏，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef SATIETY_MANA_COST
#undef SATIETY_RESOURCE_COST
#undef SATIETY_CHANNEL_TIME
#undef SATIETY_COOLDOWN
#undef SATIETY_TARGET_RANGE
#undef SATIETY_RESTORE_BASE
#undef SATIETY_RESTORE_PER_LVL
#undef SATIETY_DEBUFF_DURATION
