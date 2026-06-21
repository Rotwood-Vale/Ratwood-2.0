// modular_z121 自定义奥术法术：感官共享（Sensory Sharing）
// ---------------------------------------------------------------------------
// 设计目标：一个 T2 实用 / 羁绊法术。
//   施法者吟唱咒文 -> do_after 引导 3 秒 -> 弹窗从 7 格内选择一名目标 ->
//   目标会收到“是否接受”的弹窗 -> 接受后，双方在 3 分钟内共享感官：
//     · 痛觉（一方受到伤害时，另一方会同步感到部分痛楚）
//     · 愉悦（提供可被外部系统调用的钩子，把愉悦感同步给对方）
//     · 听觉（一方听到的话语会回响进另一方脑海）
//     · 视觉（双方各获得一道“临时法术”，可在自己/对方视角之间切换）
//
// 选取 / 引导方式：沿用 wish_spell.dm 的 /spell/self 引导式做法——点击图标后只对
//   “自己”发起 3 秒 do_after 引导，引导成功后再弹窗选目标、再询问目标是否同意。
//   这样最契合规格里“先吟唱、再选人、对方需同意”的流程，且天然支持中途取消。
//
// 约束：本法术的全部代码都只存在于 modular_z121 内，仅“调用”主线系统现有的接口
//   （apply_damage / reset_perspective / add_stress / mind.AddSpell 等信号与 proc），
//   不修改 modular_z121 之外的任何文件。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数集中定义（文件末尾统一 #undef，避免污染全局命名空间）=====
// 之所以用 #define 把这些“数值旋钮”集中放在顶部，是为了平衡性调整一目了然，
// 不必在长长的过程代码里到处翻找魔法数字。
#define SENSORY_MANA_COST     3              // “法力 / 法术点”消耗（cost）= 3
#define SENSORY_CHANNEL_TIME  (3 SECONDS)    // 引导 / 蓄力时长（do_after）= 3 秒
#define SENSORY_RESOURCE_COST 5              // “额外资源消耗”：每次施放抽取的疲劳/耐力（releasedrain）= 5
#define SENSORY_DURATION      (3 MINUTES)    // 感官共享效果持续时间 = 3 分钟
#define SENSORY_COOLDOWN      (3 MINUTES)    // 成功施放后的冷却 = 3 分钟
#define SENSORY_TARGET_RANGE  7              // 选取目标的最大距离 = 7 格

// 痛觉同步比例：一方实际受到的伤害，会按此比例换算成另一方的“共感疼痛”（耐力损耗）。
// 用 0.5 既能让“痛感共享”有明确体感，又不会让链接双方互相把对方拖死。
#define SENSORY_PAIN_RATIO    0.5
// 单次同步疼痛的上限，避免一次性的巨额伤害把链接对象直接拍晕/拍死。
#define SENSORY_PAIN_CAP      25

// 性快感（性奋值 arousal）同步比例：链接一方在性爱中获得的快感，会按此比例同步给另一方。
// 主线把“性快感”量化为 sexcon.arousal，这里直接复用该数值通道，让“床笫之欢”真正传导给对方。
#define SENSORY_AROUSAL_RATIO 0.5
// 当链接一方“高潮（射精/达到顶点）”时，额外灌注给另一方的性奋值，体现“高潮快感共享”。
#define SENSORY_CLIMAX_AROUSAL 25

// 目标对“是否接受共享”弹窗的应答超时（毫秒级游戏刻）。超时未点则视为拒绝，
// 避免目标挂机时施法者被无限期卡住。
#define SENSORY_PROMPT_TIMEOUT (20 SECONDS)

// ===========================================================================
// 在 /mob/living 上挂一个“当前所属感官链接”的引用。
// 之所以放在 /mob/living 上（而非仅 human），是为了让视觉切换法术、信号处理
// 都能从任意一方的 mob 快速反查到链接 datum，并避免一名 mob 同时存在多条链接。
// （这是在 modular_z121 内对主线类型的“追加变量”，不修改外部文件。）
// ===========================================================================
/mob/living
	// 指向该 mob 当前参与的感官共享链接；为空表示当前没有任何共享。
	var/datum/sensory_share_link/sensory_share_link_custom

// ===========================================================================
// 正向情绪事件：感官共享带来的“愉悦”。
// 主线没有独立的“快感”数值，这里用心情/压力系统（stressevent，stressadd 为负即降压）
// 来承载“愉悦同步”。它作为可被外部系统调用的钩子使用（见 share_pleasure）。
// ===========================================================================
/datum/stressevent/sensory_pleasure
	timer = 1 MINUTES        // 单次愉悦余韵持续 1 分钟
	stressadd = -3           // 负值 = 降低压力 / 带来正面心情（“愉悦”）
	desc = span_boldgreen("我感受到了一阵从感官链接彼端传来的愉悦。")

// ===========================================================================
// 感官共享链接 datum：承载“两名 mob 之间”的所有共享逻辑与生命周期。
// 把状态与信号集中在一个 datum 里，便于在到期 / 一方失效时一次性干净清理，
// 避免信号、临时法术、视角覆写等残留。
// ===========================================================================
/datum/sensory_share_link
	var/mob/living/user_a          // 链接的一方（通常是施法者）
	var/mob/living/user_b          // 链接的另一方（被选中并同意的目标）
	var/active = FALSE             // 链接是否仍然有效（防止清理过程中重入）
	var/relaying_pain = FALSE      // 重入保护：正在“转发疼痛”时为真，避免疼痛在两端无限反弹
	var/expire_timer_id            // 到期定时器 id，便于一方提前失效时清掉它

// New：建立链接。注册双方的痛觉/听觉信号，授予双方“切换视角”的临时法术。
// 形参 a / b 为参与共享的两名活体。
/datum/sensory_share_link/New(mob/living/a, mob/living/b)
	. = ..()
	// 基础校验：两名参与者都必须有效且不同，否则直接自毁，绝不建立半残链接。
	if(!istype(a) || !istype(b) || a == b)
		qdel(src)
		return
	user_a = a
	user_b = b
	active = TRUE
	// 反向引用：让双方都能 O(1) 反查到本链接（视角切换法术、信号处理都依赖它）。
	user_a.sensory_share_link_custom = src
	user_b.sensory_share_link_custom = src
	// 给两端都挂上痛觉、听觉信号，实现“双向”共享。
	register_member_signals(user_a)
	register_member_signals(user_b)
	// 视觉共享：给双方各授予一个“切换视角”的临时法术（见文件末尾的 view 法术）。
	grant_view_spell(user_a)
	grant_view_spell(user_b)

// Destroy：链接销毁时，必须把一切“加上去的东西”对称地撤销干净。
/datum/sensory_share_link/Destroy()
	active = FALSE
	// 注销信号、收回临时法术、复原视角，缺一不可，否则会留下幽灵效果。
	cleanup_member(user_a)
	cleanup_member(user_b)
	user_a = null
	user_b = null
	return ..()

// register_member_signals：为单个成员注册“受伤”和“听到声音”两类信号。
// COMSIG_MOB_APPLY_DAMGE -> 痛觉共享；COMSIG_MOVABLE_HEAR -> 听觉共享。
/datum/sensory_share_link/proc/register_member_signals(mob/living/member)
	if(!istype(member))
		return
	// 受伤信号：在 apply_damage 起始处触发，参数为 (damage, damagetype, def_zone)。
	RegisterSignal(member, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_member_damaged))
	// 听到声音信号：在 Hear() 处触发，参数为一个 hearing_args 列表。
	RegisterSignal(member, COMSIG_MOVABLE_HEAR, PROC_REF(on_member_heard))
	// 性爱快感信号：每次该成员“承受一次性爱动作”时触发，携带本次有效性奋值（快感）。
	// （仅人类拥有 sexcon 才会真正发出此信号；对非人类注册它也无害，只是永不触发。）
	RegisterSignal(member, COMSIG_CARBON_SEX_ACTION_RECEIVED, PROC_REF(on_member_sex_action))
	// 高潮信号：该成员“高潮/射精”时触发，是性快感的顶点，用于把顶点快感共享给对方。
	RegisterSignal(member, COMSIG_MOB_EJACULATED, PROC_REF(on_member_ejaculated))

// cleanup_member：与 New 对称地清理单个成员的全部痕迹。
/datum/sensory_share_link/proc/cleanup_member(mob/living/member)
	if(!member)
		return
	// 注销信号（用 QDELETED 兜底，避免对已删除对象操作）。
	if(!QDELETED(member))
		UnregisterSignal(member, COMSIG_MOB_APPLY_DAMGE)
		UnregisterSignal(member, COMSIG_MOVABLE_HEAR)
		// 同步注销性爱快感 / 高潮信号，与 register_member_signals 严格对称，杜绝残留监听。
		UnregisterSignal(member, COMSIG_CARBON_SEX_ACTION_RECEIVED)
		UnregisterSignal(member, COMSIG_MOB_EJACULATED)
		// 复原视角：若成员此刻正透过对方的眼睛观看，必须拉回自己，避免“黑屏/卡视角”。
		member.reset_perspective(null)
	// 解除反向引用（仅当它确实指向本链接时才清，避免误删别人的链接）。
	if(member.sensory_share_link_custom == src)
		member.sensory_share_link_custom = null
	// 收回临时的“切换视角”法术。
	remove_view_spell(member)

// get_partner：给定链接中的一方，返回另一方（找不到则返回 null）。
// 信号处理与视角切换都靠它来确定“要把感受投射给谁”。
/datum/sensory_share_link/proc/get_partner(mob/living/who)
	if(who == user_a)
		return user_b
	if(who == user_b)
		return user_a
	return null

// ---------------------------------------------------------------------------
// 痛觉共享：当链接中的某一方受到伤害时，把一部分痛楚同步到另一方。
// 由 COMSIG_MOB_APPLY_DAMGE 触发，签名与 apply_damage 的信号发送一致。
// ---------------------------------------------------------------------------
/datum/sensory_share_link/proc/on_member_damaged(mob/living/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	// 链接失效、或正处于“转发疼痛”过程中（防止 A->B->A 无限反弹）时，直接忽略。
	if(!active || relaying_pain)
		return
	// 找到要承受共感疼痛的另一方；任一方已失效则不处理。
	var/mob/living/partner = get_partner(source)
	if(!partner || QDELETED(partner) || QDELETED(source))
		return
	// 死亡的一方不再传导/接收痛觉，避免对尸体反复结算。
	if(partner.stat == DEAD)
		return
	// 把实际伤害按比例换算成“共感疼痛”，并用上限钳制，防止秒杀链接对象。
	var/shared = min(round(damage * SENSORY_PAIN_RATIO), SENSORY_PAIN_CAP)
	if(shared <= 0)
		return
	// 关键：转发期间置位重入保护。下面对 partner 施加的耐力损耗本身也会触发
	// COMSIG_MOB_APPLY_DAMGE，若不加保护就会再次进入本过程造成死循环。
	relaying_pain = TRUE
	// 用 STAMINA（耐力/疲劳）承载“共感疼痛”：能明确体现痛感，又不会造成真实外伤。
	partner.apply_damage(shared, STAMINA)
	relaying_pain = FALSE
	// 表现层反馈：让承痛的一方明确知道这股痛来自感官链接，而非自身受创。
	to_chat(partner, span_danger("一阵并非来自己身的剧痛，顺着感官链接灌入我的神经！"))

// ---------------------------------------------------------------------------
// 听觉共享：当链接中的某一方“听到”话语时，把内容回响进另一方脑海。
// 由 COMSIG_MOVABLE_HEAR 触发，hearing_args 为 Hear() 的参数列表。
// ---------------------------------------------------------------------------
/datum/sensory_share_link/proc/on_member_heard(mob/living/source, list/hearing_args)
	SIGNAL_HANDLER
	if(!active)
		return
	var/mob/living/partner = get_partner(source)
	if(!partner || QDELETED(partner) || QDELETED(source))
		return
	// 取出本次听到的成文消息；为空（如纯音效）则没什么可转达的。
	var/message = hearing_args?[HEARING_MESSAGE]
	if(!message)
		return
	// 避免回声风暴：若发声者本就是链接的另一方（即对方在说话），不再重复回响，
	// 否则两端都在场时同一句话会被来回投射、刷屏。
	var/atom/movable/speaker = hearing_args[HEARING_SPEAKER]
	if(speaker == partner || speaker == source)
		return
	// 把“对方听到的话”作为脑海回响转达给 partner。raw_message 已是处理过的文本。
	to_chat(partner, span_purple("透过感官链接，一段话语在我脑海中回响：\"[message]\""))

// ---------------------------------------------------------------------------
// 愉悦共享（统一入口 + 公共钩子）：把一阵“愉悦”同步给链接中除 origin 之外的另一方。
// 它同时服务于两类来源：
//   1) 内部信号处理（性快感 on_member_sex_action / 高潮 on_member_ejaculated）；
//   2) 任何代表“愉悦”的外部系统（进食满足、按摩等）也可直接调用本钩子。
// 参数：
//   arousal_amount —— 要灌注给对方的性奋值（性快感）。仅人类（有 sexcon）才生效。
//   apply_mood     —— 是否额外施加一次正向心情事件（高潮等“强愉悦”时才置 TRUE，避免刷屏）。
//   message        —— 给对方的文字反馈；为空则不发文字，便于高频的细微快感静默同步。
// 返回 TRUE 表示成功把愉悦传达给了对方。
// ---------------------------------------------------------------------------
/datum/sensory_share_link/proc/share_pleasure(mob/living/origin, arousal_amount = 0, apply_mood = FALSE, message = null)
	if(!active)
		return FALSE
	var/mob/living/partner = get_partner(origin)
	if(!partner || QDELETED(partner))
		return FALSE
	// 死亡的一方不再接收快感，避免对尸体结算。
	if(partner.stat == DEAD)
		return FALSE
	// 性快感走主线的 arousal（性奋值）通道：仅人类拥有 sexcon，故先做类型校验再灌注。
	// 注意：adjust_arousal 只改数值、不发任何信号，因此不存在“快感在两端反弹”的风险，无需重入保护。
	if(arousal_amount > 0 && ishuman(partner))
		var/mob/living/carbon/human/human_partner = partner
		if(human_partner.sexcon)
			human_partner.sexcon.adjust_arousal(arousal_amount)
	// 强愉悦（高潮）才动用心情/压力系统，且仅 carbon 拥有该系统。
	if(apply_mood && iscarbon(partner))
		var/mob/living/carbon/carbon_partner = partner
		carbon_partner.add_stress(/datum/stressevent/sensory_pleasure)
	// 文字反馈按需发送（高频细微快感传 null 以保持安静）。
	if(message)
		to_chat(partner, span_green(message))
	return TRUE

// ---------------------------------------------------------------------------
// 性快感共享：当链接一方“承受一次性爱动作”时，把其中的性快感按比例同步给另一方。
// 由 COMSIG_CARBON_SEX_ACTION_RECEIVED 触发，签名与该信号发送处一致：
//   (initiator, origin_sexcon, action, receiver_part, giving, effective_arousal, effective_pain, force, speed)
// 我们只关心 effective_arousal（本次的有效性快感/性奋增量）。
// ---------------------------------------------------------------------------
/datum/sensory_share_link/proc/on_member_sex_action(mob/living/source, mob/living/initiator, datum/sex_controller/origin_sexcon, datum/sex_action/action, receiver_part, giving, effective_arousal, effective_pain, applied_force, applied_speed)
	SIGNAL_HANDLER
	if(!active)
		return
	// 没有正向快感（例如纯疼痛动作）就没什么可共享的，直接返回。
	if(!effective_arousal || effective_arousal <= 0)
		return
	// 按比例把这次的性快感同步给对方。这是“床笫之欢”的持续传导部分，
	// 频率较高，故 message 传 null（静默同步），只让对方的性奋值自然累积。
	share_pleasure(source, effective_arousal * SENSORY_AROUSAL_RATIO, apply_mood = FALSE, message = null)

// ---------------------------------------------------------------------------
// 高潮共享：当链接一方“高潮/射精”时，把这股顶点快感强烈地同步给另一方。
// 由 COMSIG_MOB_EJACULATED 触发（发出者即高潮的那名 mob）。
// 关键：这里绝不调用 partner.sexcon.ejaculate()，否则会再次发出本信号在两端无限反弹；
//       而是只灌注一笔较大的性奋值 + 一次正向心情 + 文字反馈来表现“共享高潮”。
// ---------------------------------------------------------------------------
/datum/sensory_share_link/proc/on_member_ejaculated(mob/living/source)
	SIGNAL_HANDLER
	if(!active)
		return
	// 顶点快感：灌注固定的高潮性奋值，施加正向心情，并给出明确的文字反馈。
	share_pleasure(source, SENSORY_CLIMAX_AROUSAL, apply_mood = TRUE, message = "链接彼端骤然涌来一阵高潮的快感，让我浑身止不住地一颤！")

// ---------------------------------------------------------------------------
// grant_view_spell / remove_view_spell：为成员授予 / 收回“切换视角”临时法术。
// 视觉共享的“可切换性”由这道临时法术实现——成员可主动在自己与对方视角间切换。
// 授予的对象是 mob.mind（法术挂在思维上），与 void_clone 的处理方式一致。
// ---------------------------------------------------------------------------
/datum/sensory_share_link/proc/grant_view_spell(mob/living/member)
	if(!istype(member) || !member.mind)
		return
	// 已有同名法术则不重复授予，避免动作栏出现两个相同按钮。
	if(member.mind.has_spell(/obj/effect/proc_holder/spell/self/sensory_sharing_view, TRUE))
		return
	member.mind.AddSpell(new /obj/effect/proc_holder/spell/self/sensory_sharing_view)

/datum/sensory_share_link/proc/remove_view_spell(mob/living/member)
	if(!member || !member.mind)
		return
	var/obj/effect/proc_holder/spell/view_spell = member.mind.get_spell(/obj/effect/proc_holder/spell/self/sensory_sharing_view, TRUE)
	if(view_spell)
		member.mind.RemoveSpell(view_spell)

// ---------------------------------------------------------------------------
// expire：到期（或被外部要求结束）时的统一收尾。
// 先给双方发“链接消散”的提示，再 qdel 自身触发 Destroy() 里的对称清理。
// ---------------------------------------------------------------------------
/datum/sensory_share_link/proc/expire()
	if(!active)
		return
	if(user_a && !QDELETED(user_a))
		to_chat(user_a, span_warning("我与对方之间的感官链接渐渐淡去，世界重新只剩下我自己的感受。"))
	if(user_b && !QDELETED(user_b))
		to_chat(user_b, span_warning("我与对方之间的感官链接渐渐淡去，世界重新只剩下我自己的感受。"))
	qdel(src)

// ===========================================================================
// 法术本体：感官共享
// ---------------------------------------------------------------------------
// 基类选 /spell/self：点击图标后只对“自己”发起 3 秒引导，引导成功后再弹窗选人、
// 再询问对方是否同意。符合规格“先吟唱蓄力 -> 选目标 -> 对方需弹窗同意”的流程。
// ===========================================================================
/obj/effect/proc_holder/spell/self/sensory_sharing
	name = "感官共享"
	desc = "一道奇妙的法术，借魔力将两人的感官彼此相连——不只是痛楚，还有愉悦、视觉、听觉等等。"
	school = "transmutation"
	spell_tier = 2                          // T2 法术
	cost = SENSORY_MANA_COST                // “法力 / 法术点”消耗 = 3
	releasedrain = SENSORY_RESOURCE_COST    // “额外资源消耗”= 5（施法抽取的疲劳/耐力）
	chargedrain = 1                         // 引导期间的持续抽取
	chargetime = SENSORY_CHANNEL_TIME       // 引导 3 秒（get_chargetime() 返回它驱动 do_after）
	recharge_time = SENSORY_COOLDOWN        // 冷却 = 3 分钟（由 charge_check 强制执行）
	cooldown_min = SENSORY_COOLDOWN         // 即便被“加速”，冷却也不会低于 3 分钟
	charge_type = "recharge"                // 使用“充能”式冷却（默认）
	human_req = TRUE                        // 只有人类施法者能施放
	warnie = "spellwarning"
	no_early_release = TRUE                 // 引导未完成不允许提前释放
	movement_interrupt = FALSE              // 引导期间允许移动（短引导不必强制定身）
	charging_slowdown = 1                   // 引导时略微减速
	chargedloop = /datum/looping_sound/invokegen // 引导期间循环施法音效
	associated_skill = /datum/skill/magic/arcane
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "sensory_sharing"       // 动作按钮图标态（dmi 暂无该态时仅显示为空，不影响编译）
	invocations = list("感由心生，与你相连！") // 咒文（规格要求“释放需要相应台词”，开始引导时喊出）
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	gesture_required = TRUE                 // 需要能自由活动的手来施法
	miracle = FALSE
	xp_gain = TRUE
	sound = null                            // 引导音由 chargedloop 负责，不在 perform 里额外播放

// ---------------------------------------------------------------------------
// choose_targets：施法入口（点击图标后由 Click -> cast_check -> choose_targets 调用）。
// 完成两件“施法前”的事：1) 立即喊出咒文（满足“释放需要台词”）；2) do_after 引导 3 秒。
// 引导成功后才调用 perform() 进入真正的 cast()。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/self/sensory_sharing/choose_targets(mob/user = usr)
	// 没有施法者就直接撤销，避免空指针。revert_cast() 会把冷却恢复为“可用”。
	if(!user)
		revert_cast()
		return

	// 规格要求“释放时”念出咒文，因此这里手动调用一次 invocation()。
	// （稍后在 perform() 前临时屏蔽 invocation，避免咒文被重复喊两遍。）
	invocation(user)

	// 取得引导时长（= chargetime），用 do_after 实现“可被打断的 3 秒蓄力”。
	var/cast_time = get_chargetime()
	if(cast_time > 0)
		user.visible_message(
			span_warning("[user] 闭目凝神，指尖萦绕起一缕将感官彼此牵连的魔力……"),
			span_notice("我开始引导这道感官共享法术，只需再稳住片刻……")
		)
		// do_after：引导期间若移动被打断/死亡会返回 FALSE。progress 显示进度条，target=user 表自身引导。
		if(!do_after(user, cast_time, target = user, progress = TRUE))
			to_chat(user, span_warning("我对感官魔力的牵引被打断了，链接未能成形。"))
			revert_cast(user) // 引导失败：退还冷却，可重新尝试
			return

	// 引导成功。进入 perform 之前临时清空 invocations，防止 perform 成功后又喊一次咒文。
	var/list/original_invocations = invocations
	var/original_invocation_type = invocation_type
	invocations = null
	invocation_type = "none"
	// /spell/self 的 cast 只面向施法者本人发起，targets 传 null 即可。
	perform(null, user = user)
	// 还原咒文设置，避免影响下一次施放。
	invocations = original_invocations
	invocation_type = original_invocation_type

// ---------------------------------------------------------------------------
// cast：引导成功后真正执行的逻辑。
//   1) 在 7 格内收集可选目标 -> 弹窗选择（可取消）
//   2) 询问目标是否接受（目标侧弹窗，可拒绝/超时）
//   3) 建立 /datum/sensory_share_link 并安排 3 分钟后到期
// 返回值约定：
//   - TRUE  -> perform() 调用 start_recharge()，进入 3 分钟冷却（链接已建立）
//   - FALSE -> 调用 revert_cast() 退还冷却（无目标 / 取消 / 被拒 / 失败）
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/self/sensory_sharing/cast(list/targets, mob/living/user = usr)
	. = ..()
	// 安全校验：施法者必须仍然有效且健在。
	if(!user || QDELETED(user))
		revert_cast()
		return FALSE

	// 同一时刻只允许参与一条感官链接，避免多链接互相干扰、信号叠加。
	if(user.sensory_share_link_custom)
		to_chat(user, span_warning("我已身处一段感官链接之中，无法再开启新的链接。"))
		revert_cast(user)
		return FALSE

	// —— 步骤 1：收集 7 格视野内、存活、且非自身的活体作为候选目标 ——
	var/list/candidates = list()
	for(var/mob/living/L in view(SENSORY_TARGET_RANGE, user))
		if(L == user)            // 不能和自己共享感官
			continue
		if(L.stat == DEAD)       // 死者无法参与共享
			continue
		if(QDELETED(L))
			continue
		if(L.sensory_share_link_custom) // 已在别的链接中的对象不可重复链接
			continue
		// 用“名字(ckey/REF)”做键，避免重名导致选项相互覆盖。
		var/label = "[L.name] ([L.ckey ? L.ckey : REF(L)])"
		candidates[label] = L

	// 错误处理：附近没有任何可链接的对象。
	if(!length(candidates))
		to_chat(user, span_warning("我的视野之内没有可以建立感官链接的对象。"))
		revert_cast(user)
		return FALSE

	// 弹窗让施法者选择目标；可取消（返回 null）。
	var/chosen_label = tgui_input_list(user, "选择要与之共享感官的对象：", "感官共享", candidates)
	if(isnull(chosen_label))
		to_chat(user, span_warning("我收回了建立链接的念头。"))
		revert_cast(user)
		return FALSE

	var/mob/living/target = candidates[chosen_label]
	// 二次校验：从弹窗到点选之间，目标可能已离开视野/死亡/被他人链接。
	if(!validate_target(user, target))
		revert_cast(user)
		return FALSE

	// 反魔法检定：被反魔法保护的目标无法被接入链接（即便是善意的）。
	if(target.anti_magic_check())
		to_chat(user, span_warning("[target] 身上的反魔法挡下了感官链接的魔力。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		revert_cast(user)
		return FALSE

	// —— 步骤 2：询问目标是否接受 ——
	// 提示施法者正在等待对方答复，避免其以为法术卡住。
	to_chat(user, span_notice("我向 [target] 发出了感官链接的邀请，正在等待 [target.p_their()] 答复……"))
	// 目标侧弹窗：接受 / 拒绝；超时未答（SENSORY_PROMPT_TIMEOUT）则视为拒绝。
	var/response = tgui_alert(target, "[user.name] 想要与你共享感官（痛觉、愉悦、视觉、听觉等），持续约 3 分钟。是否接受？", "感官共享邀请", list("接受", "拒绝"), timeout = SENSORY_PROMPT_TIMEOUT)
	if(response != "接受")
		to_chat(user, span_warning("[target] 拒绝了（或未能及时回应）这次感官链接。"))
		to_chat(target, span_notice("我婉拒了这次感官链接。"))
		revert_cast(user)
		return FALSE

	// —— 步骤 3：在询问期间双方可能已移动/失效，建立前再做一次完整校验 ——
	if(!validate_target(user, target))
		revert_cast(user)
		return FALSE
	// 施法者自身在等待期间也可能已失效或已被卷入别的链接。
	if(QDELETED(user) || user.stat == DEAD || user.sensory_share_link_custom)
		to_chat(user, span_warning("链接建立的时机已经错过了。"))
		revert_cast(user)
		return FALSE

	// 建立链接 datum（构造函数内部完成信号注册、视角法术授予与反向引用挂载）。
	var/datum/sensory_share_link/link = new(user, target)
	// 极端兜底：若构造函数因校验失败而自毁，则视为施法失败并退款。
	if(QDELETED(link) || !link.active)
		to_chat(user, span_warning("感官链接在最后一刻没能稳定成形。"))
		revert_cast(user)
		return FALSE

	// 安排 3 分钟后自动到期。把 timer id 记到 link 上，便于一方提前失效时清掉它。
	link.expire_timer_id = addtimer(CALLBACK(link, TYPE_PROC_REF(/datum/sensory_share_link, expire)), SENSORY_DURATION, TIMER_STOPPABLE)

	// 表现层：成功反馈与音效。
	playsound(get_turf(user), 'sound/magic/whiteflame.ogg', 60, TRUE)
	user.visible_message(
		span_notice("[user] 与 [target] 之间似有一缕无形的丝线悄然连起。"),
		span_green("我与 [target] 的感官彼此交融——痛楚、愉悦、所见所闻，自此短暂相通。")
	)
	to_chat(target, span_green("我与 [user] 的感官彼此交融——痛楚、愉悦、所见所闻，自此短暂相通。"))
	// 告知双方：可在动作栏使用新出现的“感官互视”法术切换到对方视角。
	to_chat(user, span_info("动作栏中新增了『感官互视』，可借此切换到对方的视角观察世界。"))
	to_chat(target, span_info("动作栏中新增了『感官互视』，可借此切换到对方的视角观察世界。"))
	return TRUE

// validate_target：建立链接前对“目标是否仍可被链接”的统一校验，避免逻辑分散重复。
// 校验项：存在、非自身、存活、仍在 7 格视野内、且尚未被卷入其他链接。
/obj/effect/proc_holder/spell/self/sensory_sharing/proc/validate_target(mob/living/user, mob/living/target)
	if(QDELETED(target) || !istype(target))
		to_chat(user, span_warning("链接的对象已经不在了。"))
		return FALSE
	if(target == user)
		to_chat(user, span_warning("我无法和自己建立感官链接。"))
		return FALSE
	if(target.stat == DEAD)
		to_chat(user, span_warning("逝者无法参与感官共享。"))
		return FALSE
	// 距离校验：必须仍处在 7 格视野内（用 view 同时满足“可见 + 距离”两个条件）。
	if(!(target in view(SENSORY_TARGET_RANGE, user)))
		to_chat(user, span_warning("[target] 已经离开了我的感知范围。"))
		return FALSE
	if(target.sensory_share_link_custom)
		to_chat(user, span_warning("[target] 已经身处另一段感官链接之中。"))
		return FALSE
	return TRUE

// ===========================================================================
// 临时法术：感官互视（视角切换）
// ---------------------------------------------------------------------------
// 由链接 datum 在建立时授予双方、在结束时收回。作用：在“自己的视角”与
// “对方的视角”之间来回切换，落实规格里“视觉共享提供一个可切换视角的临时法术”。
// 实现完全复用主线 reset_perspective：传入对方 mob 即把 client.eye 设为对方，
// 传入 null 即恢复到自身视角；不转移控制权，仅改变“看到的画面”。
// ===========================================================================
/obj/effect/proc_holder/spell/self/sensory_sharing_view
	name = "感官互视"
	desc = "在自己与感官链接对象的视角之间切换观察。"
	overlay_state = "blink"                 // 复用已存在的图标态，确保按钮一定有图标
	action_icon = 'modular_z121/icon/custompell.dmi'
	releasedrain = 0                        // 切换视角不消耗资源
	chargedrain = 0
	chargetime = 0                          // 即时生效，无需引导
	recharge_time = 1 SECONDS               // 1 秒小冷却，纯防误触连点
	cooldown_min = 1 SECONDS
	associated_skill = /datum/skill/magic/arcane
	miracle = FALSE
	gesture_required = FALSE                // 仅切换视角，不需要空手
	human_req = FALSE                       // 链接双方未必都是人类，故不限制
	invocation_type = "none"               // 切换视角是“心念”行为，不喊咒文

/obj/effect/proc_holder/spell/self/sensory_sharing_view/cast(list/targets, mob/living/user = usr)
	if(!istype(user))
		revert_cast()
		return FALSE
	// 反查自己所属的链接；没有链接说明共享已结束，此时本法术理应已被收回。
	var/datum/sensory_share_link/link = user.sensory_share_link_custom
	if(!link || !link.active)
		to_chat(user, span_warning("感官链接已经消散，我无法再借由它窥见他人的视角。"))
		revert_cast(user)
		return FALSE
	// 找到链接的另一方作为“可切换到的视角源”。
	var/mob/living/partner = link.get_partner(user)
	if(!partner || QDELETED(partner))
		to_chat(user, span_warning("链接彼端空无一人，无从切换视角。"))
		revert_cast(user)
		return FALSE
	// 需要客户端才能改变视角（NPC 无客户端，调用无意义）。
	if(!user.client)
		revert_cast(user)
		return FALSE

	// 切换逻辑：若此刻已在“看对方” -> 拉回自身视角；否则 -> 切到对方视角。
	// 用 client.eye 是否指向 partner 作为当前状态判据，保证开/关严格成对。
	if(user.client.eye == partner)
		user.reset_perspective(null) // 恢复到自身默认视角
		to_chat(user, span_notice("我的视野回到了自己的双眼。"))
	else
		user.reset_perspective(partner) // 把 client.eye 设为对方，借其双眼观察
		to_chat(user, span_notice("我的视野顺着感官链接，切换到了对方的双眼所见。"))
	return TRUE

// ===== 清理顶部定义的宏，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef SENSORY_MANA_COST
#undef SENSORY_CHANNEL_TIME
#undef SENSORY_RESOURCE_COST
#undef SENSORY_DURATION
#undef SENSORY_COOLDOWN
#undef SENSORY_TARGET_RANGE
#undef SENSORY_PAIN_RATIO
#undef SENSORY_PAIN_CAP
#undef SENSORY_AROUSAL_RATIO
#undef SENSORY_CLIMAX_AROUSAL
#undef SENSORY_PROMPT_TIMEOUT
