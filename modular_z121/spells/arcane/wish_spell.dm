// modular_z121 自定义奥术法术：心想事成（Wish Spell）
// ---------------------------------------------------------------------------
// 设计目标：一个 T4 终极法术。施法者吟唱咒文 -> do_after 引导 10 秒 ->
//           弹出选择菜单 -> 从 7 种愿望效果中选择其一并执行。
//
// 约束：本法术的所有代码都只存在于 modular_z121 内，仅“调用”主线系统的现有
//       proc（change_stat / revive / adjust_skillrank / ADD_TRAIT 等），
//       不修改 modular_z121 之外的任何文件。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm                -> #include 本文件
//   2) modular_z121/spells/_registry.dm     -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数集中定义（文件末尾统一 #undef，避免污染全局命名空间）=====
// 之所以用 #define 把这些“数值旋钮”集中放在顶部，是为了让平衡性调整一目了然，
// 不必在长长的过程代码里到处翻找魔法数字。
#define WISH_MANA_COST        18           // 法术点 / 法力消耗（学习与施放该法术所需的 cost）
#define WISH_CHANNEL_TIME     (10 SECONDS) // do_after 引导时长（蓄力 10 秒）
#define WISH_COOLDOWN         (10800 SECONDS) // 成功施放后的冷却（3 小时）
#define WISH_FATIGUE_DRAIN    80            // 每次施放消耗的疲劳（releasedrain）

#define WISH_WEALTH_AMOUNT    100           // “泼天富贵”生成的金币数量
#define WISH_STAT_BONUS       3             // “属性飞升”为每项主属性永久增加的点数
#define WISH_SKILL_BONUS      2             // “技艺精进”为每个已有技能提升的等级数
#define WISH_TARGET_RANGE     7             // 复活 / 击杀时，可选目标的搜索半径（施法者视野内）

// 自定义特质来源字符串：ADD_TRAIT 用 source 标记“是谁加的特质”，
// 用一个唯一来源可以保证本法术加的特质不会被别的系统误删。
#define WISH_TRAIT_SOURCE     "wish_spell"
// “解放技能上限”所使用的自定义特质。它本身只是一个字符串键，
// 在 get_effective_skill_cap() 里被用作“拥有该特质即可突破上限”的标记。
#define TRAIT_WISH_UNCAPPED   "wish_uncapped"

// 弹出菜单里 7 个愿望的显示文本。用 #define 常量而不是散落的字符串字面量，
// 是为了让“菜单选项”和“switch 分支”一一对应、不会因笔误而对不上。
#define WISH_OPT_RESURRECT    "复活生者（Resurrect Someone）"
#define WISH_OPT_KILL         "夺取性命（Kill Someone）"
#define WISH_OPT_WEALTH       "泼天富贵（Massive Wealth）"
#define WISH_OPT_STATS        "属性飞升（Increase Stats）"
#define WISH_OPT_SKILLS       "技艺精进（Upgrade Skills）"
#define WISH_OPT_BREAKLIMIT   "解放技能上限（Break Skill Limits）"
#define WISH_OPT_TRAIT        "天赋恩赐（Gain Beneficial Trait）"

// ===========================================================================
// 法术本体
// ---------------------------------------------------------------------------
// 选用 /spell/self 作为基类：因为施法者点击图标后只针对“自己”发起引导，
// 真正的“选谁复活 / 杀谁”是在引导成功后再通过弹窗决定的，而不是施法前先点地块。
// 这样最契合“先吟唱蓄力、再许愿”的流程。
/obj/effect/proc_holder/spell/self/wish_spell
	name = "心想事成"
	desc = "传说中近乎万能的终极法术。据说唯有真正参透魔法终极奥秘的大魔导师，方能驾驭它。\n\
	这道法术无法遗忘。"
	school = "transmutation"
	spell_tier = 4                         // T4 法术
	cost = WISH_MANA_COST                  // “法力 / 法术点”消耗 = 18
	releasedrain = WISH_FATIGUE_DRAIN      // 每次施放的疲劳消耗
	chargedrain = 0
	chargetime = WISH_CHANNEL_TIME         // 引导时长（get_chargetime() 会返回它驱动 do_after）
	recharge_time = WISH_COOLDOWN          // 冷却 = 1 小时（由 charge_check 强制执行）
	cooldown_min = WISH_COOLDOWN           // 即便被“加速”到极限，冷却也不会低于 1 小时
	charge_type = "recharge"               // 使用“充能”式冷却（默认）
	human_req = TRUE                       // 只有人类施法者能驾驭
	refundable = FALSE                     // 不可退款 避免绕过冷却
	warnie = "spellwarning"                
	no_early_release = TRUE                // 引导未完成不允许提前释放
	movement_interrupt = TRUE              // 引导期间移动会被打断（终极法术需要专注）
	charging_slowdown = 2                  // 引导时减速，体现“凝聚伟力”的代价
	chargedloop = /datum/looping_sound/invokegen // 引导期间循环播放的施法音效
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "wish_spell"                 // 动作按钮的图标态（若 dmi 暂无该态仅显示为空，不影响编译）
	invocations = list("实现我的愿望吧!") // 咒文（按规格在“开始引导”时喊出）
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	gesture_required = TRUE                // 需要能自由活动的手来施法
	miracle = FALSE
	xp_gain = TRUE
	sound = null                           // 不在 perform 里额外播放音效，引导音由 chargedloop 负责

// ---------------------------------------------------------------------------
// choose_targets：施法入口（点击图标后由 Click -> cast_check -> choose_targets 调用）
// 在这里完成两件“施法前”的事：1) 立即喊出咒文；2) do_after 引导 10 秒。
// 引导成功后才调用 perform() 进入真正的 cast()。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/self/wish_spell/choose_targets(mob/user = usr)
	// 没有施法者就直接撤销，避免空指针。revert_cast() 会把冷却恢复为“可用”状态。
	if(!user)
		revert_cast()
		return

	// 规格要求“开始引导时”就念出咒文，因此这里手动调用一次 invocation()。
	// （稍后在 perform() 中我们会临时屏蔽 invocation，以免咒文被重复喊两遍。）
	invocation(user)

	// 取得引导时长（= chargetime）。用 do_after 实现“可被打断的 10 秒蓄力”。
	var/cast_time = get_chargetime()
	if(cast_time > 0)
		user.visible_message(
			span_warning("[user] 高举双手，磅礴的魔力开始向 [user.p_their()] 周身汇聚，仿佛要向世界本身许下一个愿望……"),
			span_notice("我开始吟诵这道终极法术，魔力正不断汇聚——只要再坚持片刻……")
		)
		// do_after：在 cast_time 期间若施法者移动/被打断/死亡，会返回 FALSE。
		// progress = TRUE 显示进度条；target = user 表示这是对自身的引导动作。
		if(!do_after(user, cast_time, target = user, progress = TRUE))
			to_chat(user, span_warning("我对终极魔力的掌控被打断了，这个愿望落空了！"))
			revert_cast(user) // 引导失败：退还冷却，让施法者可以重新尝试
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
// cast：引导成功后真正执行的逻辑。弹出 7 选 1 菜单并分发到对应效果。
// 返回值约定：
//   - 返回 TRUE  -> perform() 会调用 start_recharge()，进入 1 小时冷却（愿望已实现）。
//   - 返回 FALSE -> 各效果 proc 内部已调用 revert_cast() 退还冷却（愿望取消/失败）。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/self/wish_spell/cast(list/targets, mob/living/user = usr)
	. = ..()
	// 安全校验：施法者必须仍然有效且健在，才能继续许愿。
	if(!user || QDELETED(user))
		revert_cast()
		return FALSE

	// 7 个愿望选项。用 static 列表避免每次施放都重建。
	var/static/list/wish_options = list(
		WISH_OPT_RESURRECT,
		WISH_OPT_KILL,
		WISH_OPT_WEALTH,
		WISH_OPT_STATS,
		WISH_OPT_SKILLS,
		WISH_OPT_BREAKLIMIT,
		WISH_OPT_TRAIT,
	)

	// 弹出 tgui 列表菜单让施法者选择。timeout 留 0 表示不自动超时。
	var/choice = tgui_input_list(user, "魔力已凝聚至顶点——许下你的愿望：", "心想事成", wish_options)

	// 优雅处理“取消/关闭菜单”：没有选择就退还冷却，不浪费这次珍贵的施法。
	if(isnull(choice))
		to_chat(user, span_warning("我迟疑了，终极的魔力悄然消散——这次没有许下任何愿望。"))
		revert_cast()
		return FALSE

	// 把选择分发给各自的效果处理过程。每个过程自行返回 TRUE/FALSE，
	// 并在自身失败路径里负责调用 revert_cast()。
	switch(choice)
		if(WISH_OPT_RESURRECT)
			return wish_resurrect(user)
		if(WISH_OPT_KILL)
			return wish_kill(user)
		if(WISH_OPT_WEALTH)
			return wish_wealth(user)
		if(WISH_OPT_STATS)
			return wish_increase_stats(user)
		if(WISH_OPT_SKILLS)
			return wish_upgrade_skills(user)
		if(WISH_OPT_BREAKLIMIT)
			return wish_break_limits(user)
		if(WISH_OPT_TRAIT)
			return wish_gain_trait(user)

	// 理论上不会走到这里（choice 一定是上面 7 项之一），但仍做兜底以防万一。
	revert_cast()
	return FALSE

// ===========================================================================
// 效果 1：复活生者
// 让施法者从视野内的“尸体”中选择一个，将其满血复活。
// ===========================================================================
/obj/effect/proc_holder/spell/self/wish_spell/proc/wish_resurrect(mob/living/user)
	// 收集施法者视野范围内、状态为 DEAD 的活体生物，建立“显示名 -> 目标”映射。
	var/list/candidates = list()
	for(var/mob/living/L in view(WISH_TARGET_RANGE, user))
		if(L.stat != DEAD)        // 只复活真正死亡的
			continue
		if(QDELETED(L))
			continue
		// 用“名字(ckey)”做键，避免重名导致的选项覆盖；没有 ckey 的就用 REF 兜底。
		var/label = "[L.name] ([L.ckey ? L.ckey : REF(L)])"
		candidates[label] = L

	// 错误处理：附近没有可复活的目标。
	if(!length(candidates))
		to_chat(user, span_warning("我的视野之内没有任何可以复活的逝者。"))
		revert_cast()
		return FALSE

	// 弹窗选择目标。可取消。
	var/chosen_label = tgui_input_list(user, "选择要复活的逝者：", "复活生者", candidates)
	if(isnull(chosen_label))
		to_chat(user, span_warning("我收回了复活的念头。"))
		revert_cast()
		return FALSE

	var/mob/living/target = candidates[chosen_label]
	// 二次校验：从弹窗弹出到玩家点选之间，目标可能已被删除或已被他人复活。
	if(QDELETED(target) || target.stat != DEAD)
		to_chat(user, span_warning("那具躯体已经不在我能触及的彼岸了。"))
		revert_cast()
		return FALSE

	// 把游魂拉回躯体（force = TRUE 强制夺回控制权），再执行满血复活。
	target.grab_ghost(force = TRUE)
	// revive(full_heal = TRUE)：满血复活；若因缺少大脑等原因无法复活会返回 FALSE。
	if(!target.revive(full_heal = TRUE))
		to_chat(user, span_warning("一股力量阻止了复活——这具躯体已无法再容纳生命。"))
		revert_cast()
		return FALSE

	// 表现层：复活成功的提示与小动作。
	target.emote("breathgasp")
	target.Jitter(60)
	target.visible_message(
		span_notice("[target] 在一阵刺目的奥术光辉中猛然睁眼，重新回到了人世！"),
		span_green("我自死亡的彼岸被一股不可抗拒的愿望之力强行拽了回来。")
	)
	to_chat(user, span_notice("我的愿望实现了——[target] 复活了。"))
	return TRUE

// ===========================================================================
// 效果 2：夺取性命
// 让施法者从视野内的活体目标中选择一个，将其立即处死。
// ===========================================================================
/obj/effect/proc_holder/spell/self/wish_spell/proc/wish_kill(mob/living/user)
	// 收集视野内、仍存活、且不是施法者本人的活体。
	var/list/candidates = list()
	for(var/mob/living/L in view(WISH_TARGET_RANGE, user))
		if(L == user)             // 不允许把自己许愿致死
			continue
		if(L.stat == DEAD)        // 已死的没必要再杀
			continue
		if(QDELETED(L))
			continue
		var/label = "[L.name] ([L.ckey ? L.ckey : REF(L)])"
		candidates[label] = L

	// 错误处理：附近没有可击杀目标。
	if(!length(candidates))
		to_chat(user, span_warning("我的视野之内没有可以夺取性命的活物。"))
		revert_cast()
		return FALSE

	// 弹窗选择目标。可取消。
	var/chosen_label = tgui_input_list(user, "选择要夺取性命的目标：", "夺取性命", candidates)
	if(isnull(chosen_label))
		to_chat(user, span_warning("我心生不忍，收回了这个杀念。"))
		revert_cast()
		return FALSE

	var/mob/living/target = candidates[chosen_label]
	// 二次校验：目标可能在选择期间已离开或死亡。
	if(QDELETED(target) || target.stat == DEAD)
		to_chat(user, span_warning("目标已经不在了。"))
		revert_cast()
		return FALSE

	// 反魔法检定：被反魔法保护的目标可以抵御这道致死愿望，体现“几乎万能”而非“绝对万能”。
	if(target.anti_magic_check())
		target.visible_message(
			span_warning("[target] 周身泛起反魔法的涟漪，将那股索命之力震散了！"),
			span_notice("一股致命的意志试图攫住我，却被我身上的反魔法挡了下来！")
		)
		to_chat(user, span_warning("[target] 身上的反魔法抵消了我的愿望。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		revert_cast() // 被抵抗也退还冷却，避免“无效一击”浪费 1 小时
		return FALSE

	// 执行处死：先灌入足以致命的伤害（保证即便有韧性/护甲也必死），再显式调用 death()。
	// 用氧伤 + 钝伤双管齐下，确保各种体型/种族都被压过死亡阈值。
	target.adjustOxyLoss(200)
	target.adjustBruteLoss(200)
	target.updatehealth()
	target.death() // 正式判定死亡（会派发 COMSIG_MOB_DEATH 等信号）

	// 表现层。
	target.visible_message(
		span_danger("[target] 浑身一僵，仿佛被命运本身宣判，无声地倒了下去！"),
		span_userdanger("一个冰冷的愿望攥住了我的性命……我无力回天。")
	)
	to_chat(user, span_danger("我的愿望实现了——[target] 死了。"))
	return TRUE

// ===========================================================================
// 效果 3：泼天富贵
// 在施法者脚下生成一大堆金币。
// ===========================================================================
/obj/effect/proc_holder/spell/self/wish_spell/proc/wish_wealth(mob/living/user)
	var/turf/spot = get_turf(user)
	// 错误处理：施法者不在任何地块上（理论上不会发生，但稳妥起见）。
	if(!spot)
		to_chat(user, span_warning("脚下空无一物，财富无处落脚。"))
		revert_cast()
		return FALSE

	// roguecoin 的 Initialize(mapload, coin_amount) 支持直接指定数量，
	// 因此一次性生成一摞 WISH_WEALTH_AMOUNT 枚金币。
	new /obj/item/roguecoin/gold(spot, WISH_WEALTH_AMOUNT)

	playsound(spot, 'sound/foley/coins1.ogg', 100, TRUE)
	user.visible_message(
		span_notice("一阵金光自 [user] 脚下迸现，叮当作响的金币如泉水般涌出，堆成了一座小山！"),
		span_green("我许下对财富的愿望，[WISH_WEALTH_AMOUNT] 枚金币凭空堆在了我的脚边！")
	)
	return TRUE

// ===========================================================================
// 效果 4：属性飞升
// 永久提升施法者的全部主属性。change_stat() 自带 1~20 的上下限保护。
// ===========================================================================
/obj/effect/proc_holder/spell/self/wish_spell/proc/wish_increase_stats(mob/living/user)
	// 把所有主属性键放进列表，循环逐项 +WISH_STAT_BONUS，避免重复七行近乎相同的代码。
	var/static/list/all_stat_keys = list(
		STATKEY_STR, STATKEY_PER, STATKEY_INT,
		STATKEY_CON, STATKEY_WIL, STATKEY_SPD, STATKEY_LCK,
	)
	for(var/stat_key in all_stat_keys)
		// change_stat 是 /mob/living 的过程：内部用 BUF* 缓冲并把可见值钳制在 [1,20]。
		// 这意味着即使已经满 20，调用也安全（多余的加成会被缓冲吸收，不会出错）。
		user.change_stat(stat_key, WISH_STAT_BONUS)

	user.visible_message(
		span_notice("[user] 周身爆发出耀眼的奥术辉光，整个人的气息都强大了一圈！"),
		span_green("我感到力量、敏锐与意志如潮水般在体内涨满——我的本质被永久地强化了！")
	)
	to_chat(user, span_notice("我的每一项主属性都永久提升了 [WISH_STAT_BONUS] 点（上限 20）。"))
	return TRUE

// ===========================================================================
// 效果 5：技艺精进
// 把施法者“已经掌握”的每个技能各提升 WISH_SKILL_BONUS 级。
// ===========================================================================
/obj/effect/proc_holder/spell/self/wish_spell/proc/wish_upgrade_skills(mob/living/user)
	// 拿到施法者的技能持有者（skill_holder）。ensure_skills() 保证其一定存在。
	var/datum/skill_holder/holder = user.ensure_skills()
	if(!holder)
		to_chat(user, span_warning("我体内没有可供精进的技艺。"))
		revert_cast()
		return FALSE

	var/upgraded_any = FALSE
	// known_skills 是 “技能 datum -> 当前等级” 的关联表。遍历其中真正学过（等级>0）的技能。
	for(var/datum/skill/skill_ref in holder.known_skills)
		if(holder.known_skills[skill_ref] <= SKILL_LEVEL_NONE)
			continue // 完全没入门的技能跳过，避免“凭空”塞经验
		// adjust_skillrank 接收技能“类型路径”，因此传 skill_ref.type。
		// 它会把对应技能提升 amt 级（内部以经验阶梯实现，并自动封顶在 LEGENDARY）。
		user.adjust_skillrank(skill_ref.type, WISH_SKILL_BONUS, silent = FALSE)
		upgraded_any = TRUE

	// 错误处理：施法者一项技能都没有时给出反馈，但仍退还冷却以免白费。
	if(!upgraded_any)
		to_chat(user, span_warning("我还没有任何可供精进的技能。"))
		revert_cast()
		return FALSE

	user.visible_message(
		span_notice("[user] 闭目凝神，仿佛在顷刻间历经了千锤百炼。"),
		span_green("无数经验与领悟涌入脑海——我所掌握的每一门技艺都精进了！")
	)
	to_chat(user, span_notice("我已有的每个技能都提升了 [WISH_SKILL_BONUS] 级。"))
	return TRUE

// ===========================================================================
// 效果 6：解放技能上限
// 让施法者突破技能的“无特质上限（max_untraited_level）”，可练至传奇。
// 注意：本效果只抬高“上限”，绝不改动施法者当前的技能等级——是否真的练到传奇，
//       仍需玩家自己日后去积累。这样它纯粹是“解锁天花板”，而非“白送等级”。
// 实现思路（完全加性、且只惠及拥有该特质者）：
//   1) 一次性把自定义特质 TRAIT_WISH_UNCAPPED 注册进“所有技能”的 trait_uncap 表，
//      值设为 LEGENDARY —— 引擎的 get_effective_skill_cap() 只会在 HAS_TRAIT 时抬高上限，
//      所以这一步对没有该特质的其他玩家没有任何影响。
//   2) 给施法者 ADD_TRAIT 该特质（用 WISH_TRAIT_SOURCE 标记来源，便于追踪/移除）。
// ===========================================================================
/obj/effect/proc_holder/spell/self/wish_spell/proc/wish_break_limits(mob/living/user)
	// 第 1 步：确保 uncap 特质已登记到全部技能的 trait_uncap（全局只需做一次）。
	ensure_wish_uncap_registered()

	// 第 2 步：把“突破上限”的特质永久赋予施法者。
	// 若已拥有则不重复添加，避免在多次许愿后堆叠无意义的同源特质。
	// 仅此而已——这里不调用任何 adjust_skillrank，故当前技能等级保持原样不变。
	if(!HAS_TRAIT(user, TRAIT_WISH_UNCAPPED))
		ADD_TRAIT(user, TRAIT_WISH_UNCAPPED, WISH_TRAIT_SOURCE)

	user.visible_message(
		span_notice("[user] 的身上萦绕起一圈深邃的奥术符文，仿佛挣脱了某种无形的枷锁。"),
		span_green("束缚我天赋的桎梏被彻底打碎了——从此我的精进将再无上限可言！")
	)
	to_chat(user, span_notice("我已解放了技能上限：今后可将技能练至传奇而不受常规封顶限制，但当前的技能等级并不会因此改变。"))
	return TRUE

// 把自定义 uncap 特质登记进“所有技能”的 trait_uncap 表。
// 用一个全局标志位保证整局游戏只执行一次（重复登记没有意义且浪费）。
GLOBAL_VAR_INIT(wish_uncap_registered, FALSE)
/obj/effect/proc_holder/spell/self/wish_spell/proc/ensure_wish_uncap_registered()
	if(GLOB.wish_uncap_registered)
		return // 已登记过，直接返回
	GLOB.wish_uncap_registered = TRUE
	// 遍历技能子系统里的全部技能单例，给每个技能的 trait_uncap 加一条：
	//   TRAIT_WISH_UNCAPPED => SKILL_LEVEL_LEGENDARY
	// 这是纯加性操作：只为“拥有该特质”的人抬高上限，不影响其他任何玩家。
	for(var/skill_type in SSskills.all_skills)
		var/datum/skill/skill_ref = SSskills.all_skills[skill_type]
		if(!skill_ref)
			continue
		// trait_uncap 默认可能为 null，用 LAZYINITLIST 安全地懒初始化成空表再写入。
		LAZYINITLIST(skill_ref.trait_uncap)
		skill_ref.trait_uncap[TRAIT_WISH_UNCAPPED] = SKILL_LEVEL_LEGENDARY

// ===========================================================================
// 效果 7：天赋恩赐
// 让施法者从一组“正面特质”中选择其一，永久获得。
// ===========================================================================
/obj/effect/proc_holder/spell/self/wish_spell/proc/wish_gain_trait(mob/living/user)
	// 候选正面特质：显示名 -> 特质常量。全部为主线已存在的增益型特质，
	// 直接复用其定义即可，不在本模块外新增/修改任何特质。
	var/static/list/beneficial_traits = list(
		"无痛之躯（免疫疼痛）"       = TRAIT_NOPAIN,
		"坚忍不拔（疼痛不致眩晕）"   = TRAIT_NOPAINSTUN,
		"铁石心肠（血腥场面不影响心情）" = TRAIT_STEELHEARTED,
		"传奇情人"                   = TRAIT_GOODLOVER,
		"妙手医者（外科加成）"       = TRAIT_SURGEON,
	)

	// 过滤掉施法者“已经拥有”的特质，避免许了愿却什么也没得到。
	var/list/selectable = list()
	for(var/label in beneficial_traits)
		var/trait_const = beneficial_traits[label]
		if(HAS_TRAIT(user, trait_const))
			continue
		selectable[label] = trait_const

	// 错误处理：所有可选正面特质都已拥有。
	if(!length(selectable))
		to_chat(user, span_warning("我已经拥有了这道愿望所能赋予的全部天赋。"))
		revert_cast()
		return FALSE

	// 弹窗选择想要的特质。可取消。
	var/chosen_label = tgui_input_list(user, "选择你想要永久获得的天赋：", "天赋恩赐", selectable)
	if(isnull(chosen_label))
		to_chat(user, span_warning("我一时拿不定主意，没有选择任何天赋。"))
		revert_cast()
		return FALSE

	var/chosen_trait = selectable[chosen_label]
	// 二次兜底：理论上 chosen_label 一定在表中，但仍校验以防异常输入。
	if(isnull(chosen_trait))
		revert_cast()
		return FALSE

	// 用唯一来源永久赋予该特质。带 source 的 ADD_TRAIT 会一直存在，直到被显式移除。
	ADD_TRAIT(user, chosen_trait, WISH_TRAIT_SOURCE)

	user.visible_message(
		span_notice("[user] 周身浮现出一缕温润的金光，仿佛被命运本身亲手点化。"),
		span_green("一份全新的天赋融入了我的血脉，成为我永久的一部分。")
	)
	to_chat(user, span_notice("我永久获得了天赋：[chosen_label]。"))
	return TRUE

// ===== 清理顶部定义的宏，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef WISH_MANA_COST
#undef WISH_CHANNEL_TIME
#undef WISH_COOLDOWN
#undef WISH_FATIGUE_DRAIN
#undef WISH_WEALTH_AMOUNT
#undef WISH_STAT_BONUS
#undef WISH_SKILL_BONUS
#undef WISH_TARGET_RANGE
#undef WISH_TRAIT_SOURCE
#undef TRAIT_WISH_UNCAPPED
#undef WISH_OPT_RESURRECT
#undef WISH_OPT_KILL
#undef WISH_OPT_WEALTH
#undef WISH_OPT_STATS
#undef WISH_OPT_SKILLS
#undef WISH_OPT_BREAKLIMIT
#undef WISH_OPT_TRAIT
