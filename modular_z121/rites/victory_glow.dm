// ============================================================================
// 胜利荣光（Victory Glow）—— 隶属于拉沃克斯献祭法阵的一项仪式
// ----------------------------------------------------------------------------
// 在【已存在的】拉沃克斯献祭法阵
//（`/obj/structure/ritualcircle/sacrifice/ravox`，定义于 sacrifice_circles.dm）
// 之上新增一项仪式。DM 会跨文件合并同一类型的定义，因此在这里重新打开该类型即可
// 挂上新仪式，而【无需】改动那个共享的法阵文件。
//
// 该仪式要求法阵格子上放置三颗“悬赏首级”。成功时消耗这三颗首级，并赋予主持者一段
// 10 分钟的“胜利荣光”增益。在增益持续期间，每当主持者【进入战斗姿态（cmode）】时：
//   · 耐力消耗 -10%
//   · 力量 STR +1、敏捷 SPD +1、体质 CON +1
//   · 转换率 +5%
//   · 闪避率 +5%
// 离开战斗姿态时，这些战斗加成会自动撤除；再次进入又会恢复，直到增益到期。
//
// 实现说明（“确保各效果实际生效 / 提供挂钩或桩”）：
//   - STR/SPD/CON +1 通过 change_stat 真实施加（SPD 即移动速度属性，CON 还能提高
//     冲刺时不掉耐力的概率，因此这三项本身就实质性地兼顾了“转换/移动”与“耐力”）。
//   - 闪避率 +5% 通过授予真实存在、且被战斗系统读取的 TRAIT_DODGEEXPERT 实现
//     （先例：starsugar 增益正是这样临时授予该特质）。
//   - 耐力消耗 -10% 与 转换率 +5% 这两项百分比修正，没有可直接写入的单一系数变量，
//     因此以一个自定义标记特质 TRAIT_VICTORY_GLOW + 一组带注释的百分比常量作为
//     “集成挂钩”：相应战斗子系统可读取该标记与常量来施加修正（此即题目允许的桩/挂钩）。
//
// 遵循项目规则：仅存放于 modular_z121 之下，面向玩家的文本一律使用中文，
// 每一处过程、变量与逻辑块上方都以中文注释解释其“为何如此”。
//
// 依赖项（均已在构建中，未作改动）：
//   - 仪式基础框架：modular_z121\rites\sacrifice_circles.dm
//   - 悬赏首级：/obj/item/bodypart/head（人形断头，赏金机所认）或
//       /obj/item/natural/head（兽类悬赏首级，使用 bounty_heads.dmi）
//   - 战斗姿态标志 mob.cmode（code\modules\mob\mob_defines.dm）
//   - change_stat / STATKEY_*（code\modules\mob\living\stats.dm, __DEFINES\mobs.dm）
//   - 真实闪避特质 TRAIT_DODGEEXPERT（code\__DEFINES\traits.dm）
// 需在 modular_z121\_load.dm 中登记（置于 sacrifice_circles.dm 之后）。
// ============================================================================

// --- 可调常量 ---------------------------------------------------------------
// 在仪式选择菜单中显示、并在分派 switch 中用于匹配的标签文本；用 define 保存，
// 使二者永远保持一致、不会悄然出现偏差。
#define VICTORY_GLOW_RITE_NAME "胜利荣光"
// 增益总时长。规格要求为 10 分钟。
#define VICTORY_GLOW_DURATION (10 MINUTES)
// 轮询战斗姿态的间隔。cmode 没有切换信号，故以 1 秒心跳侦测进出战斗姿态，足够灵敏、开销极低。
#define VICTORY_GLOW_POLL_INTERVAL (1 SECONDS)
// 仪式所需的悬赏首级数量。规格要求为 3 颗。
#define VICTORY_GLOW_REQUIRED_HEADS 3
// 进入战斗姿态时施加的属性加成（真实生效）。
#define VICTORY_GLOW_STR_BONUS 1
#define VICTORY_GLOW_SPD_BONUS 1
#define VICTORY_GLOW_CON_BONUS 1
// 百分比修正常量（供集成挂钩与提示文本引用）：耐力消耗 -10%、转换率 +5%、闪避率 +5%。
#define VICTORY_GLOW_ENDURANCE_MOD 10
#define VICTORY_GLOW_SHIFT_MOD 5
#define VICTORY_GLOW_DODGE_MOD 5
// 自定义标记特质：作为“耐力消耗 -10% / 转换率 +5%”的集成挂钩。特质本质就是字符串，
// 在此自定义即可（不改动 code/ 下的特质定义文件）。
#define TRAIT_VICTORY_GLOW "victory_glow"

// 重新打开拉沃克斯献祭法阵以登记我们的仪式。基类 attack_hand()
//（在 sacrifice_circles.dm 中）已经强制校验 patron == Ravox、TRAIT_RITUALIST 特质、
// 每次歇息只能一次的“仪式已耗尽”冷却，并弹出选择菜单——因此我们只需提供菜单标题与仪式列表。
/obj/structure/ritualcircle/sacrifice/ravox
	// 在仪式选择输入框中显示的标题。
	ritual_title = "拉沃克斯的献祭仪式"
	// 本法阵提供的仪式。日后若要新增拉沃克斯仪式，只需在这里追加字符串
	//（并在下方补上对应的 switch 分支）即可。
	sacrifice_rites = list(VICTORY_GLOW_RITE_NAME)

// 将所选仪式分派给其处理过程；在玩家从 `sacrifice_rites` 中选取条目后，
// 由基类 attack_hand() 调用。
/obj/structure/ritualcircle/sacrifice/ravox/perform_sacrifice_rite(riteselection, mob/living/user)
	switch(riteselection)
		// 将我们的仪式导向其专属过程。
		if(VICTORY_GLOW_RITE_NAME)
			return victory_glow_rite(user)
	// 未识别的选项 -> 基类会礼貌地提示“没有这样的仪式”并退出。
	return ..()

// ----------------------------------------------------------------------------
// 仪式本体。
// 仅在仪式完整完成时返回 TRUE；任何中止/失败都返回 FALSE，从而不消耗任何祭品、
// 也不提前花掉每日的“仪式已耗尽”冷却（基类仅在本过程内成功时才标记其耗尽）。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/ravox/proc/victory_glow_rite(mob/living/user)
	// --- 守卫 1：只有人类才能承载这份荣光。----------------------------
	// 增益依赖战斗姿态与人形属性；其它情况明确中止。
	if(!ishuman(user))
		to_chat(user, span_smallred("唯有凡人的战士，才能承接拉沃克斯的胜利荣光。"))
		return FALSE
	var/mob/living/carbon/human/H = user

	// 法阵自身所在的格子即“祭祀法阵”；首级摆放于此。缓存它，供后续扫描使用。
	var/turf/altar = get_turf(src)
	if(!altar)
		// 防御性处理：没有所在格子的法阵无法承放祭品。
		to_chat(H, span_warning("这道法阵无处安放祭品，仪式无法开始。"))
		return FALSE

	// --- 守卫 2：拒绝毫无意义的献祭。------------------------------
	// 胜利荣光为唯一增益；若主持者已持有，重复举行只会白白浪费三颗首级，故尽早中止。
	if(H.has_status_effect(/datum/status_effect/buff/victory_glow))
		to_chat(H, span_notice("胜利的荣光仍萦绕于我，无需再次祈求。"))
		return FALSE

	// --- 守卫 3：在漫长吟唱【之前】确认首级数量足够。----
	// 提前检查，免得让玩家站着念完咒，最后才被告知首级不够。
	if(length(get_bounty_heads(altar)) < VICTORY_GLOW_REQUIRED_HEADS)
		to_chat(H, span_smallred("法阵之上必须放置 [VICTORY_GLOW_REQUIRED_HEADS] 颗悬赏首级，方能开启这场仪式。"))
		return FALSE

	// --- 吟唱阶段。----------------------------------------------------
	// do_after() 若被打断（移动/眩晕）会返回 FALSE；每一阶段都重新确认首级仍在，
	// 因此走开（或被人顺走首级）都会干净地中止、不消耗任何东西。
	// 台词呼应拉沃克斯的领域：正义、武勇与对宿敌的胜利。
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("拉沃克斯啊，正义之锋，守护弱者的护佑者！请垂顾你的战士。")
	playsound(altar, 'sound/magic/holyshield.ogg', 80, FALSE, -1)

	// 继续之前重新校验（等待期间世界状态可能已经改变）。
	if(length(get_bounty_heads(altar)) < VICTORY_GLOW_REQUIRED_HEADS)
		to_chat(H, span_warning("法阵上的首级不足，仪式随之中断。"))
		return FALSE
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("我将这些伏诛之敌的首级献于你前，作为我武勇与裁决的明证！")
	playsound(altar, 'sound/magic/holyshield.ogg', 80, FALSE, -1)

	if(length(get_bounty_heads(altar)) < VICTORY_GLOW_REQUIRED_HEADS)
		to_chat(H, span_warning("法阵上的首级不足，仪式随之中断。"))
		return FALSE
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("请以胜利的荣光加持于我，让我在每一场战斗中所向披靡！")
	to_chat(H, span_danger("一股炽烈的暖流自心口奔涌而出，仿佛凯旋的号角正在血脉中长鸣……"))

	// 收尾前最后一段较短的停顿，让高潮显得郑重而有意为之。
	if(!do_after(H, 30, target = src))
		return FALSE

	// --- 最终校验 + 消耗三颗首级。--------------------------------
	// 在拿取任何东西之前进行权威校验，使消耗绝不会在数量不足时执行。
	if(length(get_bounty_heads(altar)) < VICTORY_GLOW_REQUIRED_HEADS)
		return FALSE
	// 销毁恰好 3 颗首级；若以某种方式失败，则中止后续效果。
	if(!consume_bounty_heads(altar))
		to_chat(H, span_warning("首级在最后一刻散落，仪式功亏一篑。"))
		return FALSE

	// --- 仪式成功的视觉与气氛表现。----------------------------
	icon_state = "ravox_active" // 魔法生效期间点亮符文。
	altar.visible_message(span_warning("法阵腾起一道金色的辉光，如凯旋的旌旗般缠绕上 [H] 的身躯！"))
	playsound(altar, 'sound/magic/holyshield.ogg', 100, FALSE, -1)
	H.flash_fullscreen("yellowflash") // 胜利般的金色闪光（已确认为有效的闪光状态）。

	// --- 授予 10 分钟的“胜利荣光”增益（其内部按战斗姿态动态施加战斗加成）。----
	H.apply_status_effect(/datum/status_effect/buff/victory_glow)

	// 既然仪式已真正成功，就此花掉每日的仪式额度（与其它祭坛采用同一规则），
	// 使主持者必须先歇息才能进行下一次。
	H.apply_status_effect(/datum/status_effect/debuff/ritesexpended)

	// 给主持者的收尾确认。
	to_chat(H, span_nicegreen("拉沃克斯收下了这场献祭。胜利荣光将伴随你 10 分钟：每当你进入战斗姿态，便会更强、更快、更难被击倒。"))

	// 短暂延迟后把符文重置回静默状态，复用基类辅助过程，使时机与其它祭坛保持一致。
	addtimer(CALLBACK(src, PROC_REF(reset_rune_state)), 120)
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：收集法阵格子上所有可作“悬赏首级”的物品并返回列表。
// 同时接纳两类首级：人形断头 /obj/item/bodypart/head（赏金机认可的悬赏首级）
// 与兽类悬赏首级 /obj/item/natural/head（取自 bounty_heads.dmi）——两者皆视为合法首级，
// 以最大程度契合玩家对“悬赏首级”的理解。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/ravox/proc/get_bounty_heads(turf/altar)
	var/list/heads = list()
	// 防御性处理：没有格子就没有祭品。
	if(!altar)
		return heads
	// 遍历格子上的物品，凡属上述两类首级者皆收入列表。
	for(var/obj/item/candidate in altar)
		if(istype(candidate, /obj/item/bodypart/head) || istype(candidate, /obj/item/natural/head))
			heads += candidate
	return heads

// ----------------------------------------------------------------------------
// 辅助：从法阵格子上销毁【恰好 VICTORY_GLOW_REQUIRED_HEADS 颗】悬赏首级。
// 仅在数量足够且全部成功销毁时返回 TRUE；否则返回 FALSE，使调用方能够中止而不误判。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/ravox/proc/consume_bounty_heads(turf/altar)
	if(!altar)
		return FALSE
	// 在消耗的那一刻重新收集（不要信任先前捕获的列表——其中的物品可能已被移动或 qdel）。
	var/list/heads = get_bounty_heads(altar)
	// 数量不足则拒绝消耗，避免部分消耗。
	if(length(heads) < VICTORY_GLOW_REQUIRED_HEADS)
		return FALSE
	// 仅销毁所需数量的首级（多放的不予销毁，归还给玩家的善意）。
	for(var/i in 1 to VICTORY_GLOW_REQUIRED_HEADS)
		var/obj/item/head = heads[i]
		// 极端防御：列表项此刻若已失效则中止（理论上不会发生，因为刚刚收集过）。
		if(QDELETED(head))
			return FALSE
		qdel(head)
	return TRUE

// ============================================================================
// “胜利荣光”增益：持续 10 分钟；其战斗加成仅在【战斗姿态（cmode）】下生效。
//
// 为何采用轮询型效果：cmode 的切换（toggle_cmode）不发出任何信号，因此本效果以
// 1 秒心跳轮询 owner.cmode，进入战斗姿态时施加全部战斗加成、离开时撤除；并用
// combat_active 标志确保施加/撤除严格成对，避免属性数值漂移。
// （此模式与“太阳的馈赠”按昼夜开关属性的思路一致，只是触发条件换成了战斗姿态。）
// ============================================================================
/datum/status_effect/buff/victory_glow
	// 稳定的 id，使 has_status_effect()/remove_status_effect() 能找到它；
	// 同时用作 ADD_TRAIT/REMOVE_TRAIT 的来源标签，使特质增减一一对应。
	id = "victory_glow"
	// 规格要求的总时长：10 分钟。
	duration = VICTORY_GLOW_DURATION
	// 一个生物身上只能存在一份荣光；第二次施加会被直接忽略（杜绝叠加）。
	status_type = STATUS_EFFECT_UNIQUE
	// 以固定心跳轮询战斗姿态。
	tick_interval = VICTORY_GLOW_POLL_INTERVAL
	// HUD 提示图标，复用一个已确认存在、且主题契合（号召参战/战意）的提示贴图。
	alert_type = /atom/movable/screen/alert/status_effect/buff/victory_glow
	// 检视（examine）持有者时显示。
	examine_text = "<span class='notice'>SUBJECTPRONOUN 周身萦绕着一层金色的胜利荣光。</span>"
	// 记录战斗加成【当前】是否已施加，使施加/撤除完美配对、属性数值永不漂移。
	var/combat_active = FALSE
	// 进入战斗姿态时施加的属性加成；以数据形式保存，使施加与撤除两个循环互为镜像（单一可信来源）。
	var/list/combat_stats = list(STATKEY_STR = VICTORY_GLOW_STR_BONUS, STATKEY_SPD = VICTORY_GLOW_SPD_BONUS, STATKEY_CON = VICTORY_GLOW_CON_BONUS)

// 持有该增益期间显示的 HUD 提示图标。
/atom/movable/screen/alert/status_effect/buff/victory_glow
	name = "胜利荣光"
	desc = "拉沃克斯的荣光与我同在。每当我进入战斗姿态，便会更强、更快、更难被击倒。"
	icon_state = "call_to_arms"

// 主持者此刻是否处于战斗姿态？荣光的战斗加成只在战斗姿态下生效。
/datum/status_effect/buff/victory_glow/proc/in_combat_mode()
	return (!QDELETED(owner) && owner.cmode)

// 施加战斗加成（由 combat_active 守卫，使反复的“仍在战斗”心跳不会重复叠加）。
/datum/status_effect/buff/victory_glow/proc/apply_combat_bonus()
	if(combat_active)
		return
	// 防御性处理：绝不在缺失/无效的持有者身上改动属性。
	if(QDELETED(owner))
		return
	// 真实施加 STR/SPD/CON 加成（SPD 即移动速度，CON 还提升冲刺保耐力的概率）。
	for(var/stat in combat_stats)
		owner.change_stat(stat, combat_stats[stat])
	// 真实的闪避增强：授予战斗系统实际读取的 TRAIT_DODGEEXPERT，作为“闪避率 +[VICTORY_GLOW_DODGE_MOD]%”的实现。
	ADD_TRAIT(owner, TRAIT_DODGEEXPERT, id)
	// 集成挂钩：标记“耐力消耗 -[VICTORY_GLOW_ENDURANCE_MOD]% / 转换率 +[VICTORY_GLOW_SHIFT_MOD]%”。
	// 相应战斗子系统可据此标记与上述常量施加对应百分比修正。
	ADD_TRAIT(owner, TRAIT_VICTORY_GLOW, id)
	combat_active = TRUE
	to_chat(owner, span_nicegreen("胜利的荣光在你周身燃起——力量、迅捷与坚韧涌入四肢，疲惫也仿佛被驱散了几分！"))

// 撤除战斗加成（由 combat_active 守卫，使我们绝不会去回退一份当前并未施加的加成）。
/datum/status_effect/buff/victory_glow/proc/remove_combat_bonus()
	if(!combat_active)
		return
	// 即便持有者正在被销毁，也要原样回退我们所做的改动。
	if(!QDELETED(owner))
		for(var/stat in combat_stats)
			owner.change_stat(stat, -combat_stats[stat])
		REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, id)
		REMOVE_TRAIT(owner, TRAIT_VICTORY_GLOW, id)
		to_chat(owner, span_warning("你退出了战斗姿态，胜利的荣光也随之黯淡下来。"))
	combat_active = FALSE

// 使战斗加成与当前姿态相协调：战斗姿态下施加，否则撤除。得益于上方守卫，此过程幂等。
/datum/status_effect/buff/victory_glow/proc/refresh_combat_bonus()
	if(in_combat_mode())
		apply_combat_bonus()
	else
		remove_combat_bonus()

// 在获得增益时，立即依据当前姿态设置正确状态（若举行仪式时本就处于战斗姿态，则即刻生效）。
/datum/status_effect/buff/victory_glow/on_apply()
	. = ..()
	if(!.) // 基类拒绝施加 -> 不再继续。
		return FALSE
	refresh_combat_bonus()
	return TRUE

// 每次心跳都重新检查战斗姿态并相应地施加/撤除。
/datum/status_effect/buff/victory_glow/tick()
	. = ..()
	if(QDELETED(owner))
		return
	refresh_combat_bonus()

// 在失去增益时（到期、死亡、管理员移除、生物被删除），确保不会遗留悬空的战斗加成。
/datum/status_effect/buff/victory_glow/on_remove()
	remove_combat_bonus()
	return ..()

// 若该效果经由 be_replaced 路径被替换/其生物被删除，也在那里清理加成，
// 使属性与特质永远不会被遗留。
/datum/status_effect/buff/victory_glow/be_replaced()
	remove_combat_bonus()
	return ..()

// --- 清理本文件局部的 define，避免它们泄漏到其它文件中 ---------
#undef VICTORY_GLOW_RITE_NAME
#undef VICTORY_GLOW_DURATION
#undef VICTORY_GLOW_POLL_INTERVAL
#undef VICTORY_GLOW_REQUIRED_HEADS
#undef VICTORY_GLOW_STR_BONUS
#undef VICTORY_GLOW_SPD_BONUS
#undef VICTORY_GLOW_CON_BONUS
#undef VICTORY_GLOW_ENDURANCE_MOD
#undef VICTORY_GLOW_SHIFT_MOD
#undef VICTORY_GLOW_DODGE_MOD
#undef TRAIT_VICTORY_GLOW
