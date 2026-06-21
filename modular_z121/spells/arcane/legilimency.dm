// modular_z121 自定义奥术法术：摄神取念（Legilimency）
// ---------------------------------------------------------------------------
// 设计目标：一个 T3 控制类法术。激活法术 -> 框架蓄力 2 秒 -> 点击选定一名“他人”
//           目标（沿用 flight.dm 的点选方式）-> 目标进行“意志（Willpower）对抗”
//           检定来抵抗施法者的精神侵入；若目标对抗失败，则其暂时丧失对自己身体
//           的控制权，转而由“施法者”接管并操纵该身体；持续时间结束后，双方各自
//           回到自己原本的身体。
//
// 选取/蓄力方式：完全沿用 flight.dm 的做法——以 /spell/invoked 为基类，靠点击
//           选取目标（targets[1]），蓄力由基类 InterceptClickOn 依据 chargetime
//           校验完成；点选阶段施法者可随时取消（移开/点空），不会强制施放。
//
// 约束：所有代码都只存在于 modular_z121 内，仅“调用”主线已有机制
//       （mob.get_stat / anti_magic_check / datum/mind.transfer_to / ghostize /
//        status_effect 框架），不修改 modular_z121 之外的任何文件。
//       “接管身体”复用主线 transfer_to 的灵魂转移接口（resurrect.dm / eora.dm
//        等多处已验证可用），这里只是把它包装成“限时占据、到期归还”。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数（文件末尾统一 #undef，避免污染全局命名空间）=====
#define LEGILIMENCY_MANA_COST     6             // 法力 / 法术点消耗（cost）
#define LEGILIMENCY_CHANNEL_TIME  (2 SECONDS)   // 蓄力时长（由 invoked 基类的点击拦截按 chargetime 校验）
#define LEGILIMENCY_COOLDOWN      (1 MINUTES)   // 成功施放后的冷却（1 分钟）
#define LEGILIMENCY_RESOURCE_COST 15            // “额外资源消耗”：每次施放抽取的疲劳/耐力（releasedrain），强力控制法术故偏高
#define LEGILIMENCY_TARGET_RANGE  7             // 点击选取目标的最大距离（range）

// 施法者“接管中”用的临时特性标记：占据期间挂在施法者“原身”上，
// 用于防止施法者在一次摄神取念尚未结束时再次施放（避免灵魂转移逻辑叠加错乱）。
// 仅在本文件内部使用，作为一个普通的字符串特性与来源字符串即可，无需对外暴露。
#define TRAIT_LEGILIMENCY_CASTER  "legilimency_casting"
#define LEGILIMENCY_TRAIT_SOURCE  "legilimency_spell"

// ===========================================================================
// 法术本体
// ---------------------------------------------------------------------------
// 选用 /spell/invoked 作为基类（与 flight.dm 一致）：点击图标后进入“点选目标”模式，
// 蓄力满后点击某个生物即对其生效。本法术只对“他人”有意义（不能摄取自己），
// 故在 cast() 中显式拒绝把自己当作目标。
// ===========================================================================
/obj/effect/proc_holder/spell/invoked/legilimency
	name = "摄神取念"
	desc = "一道侵入心神的高阶法术。以纯粹的意志撬开目标的心防，若对方的意志不足以抵抗，其身体便会暂时落入我的掌控；持续时间随我的奥术造诣而延长。"
	school = "transmutation"
	spell_tier = 3                              // T3 法术
	cost = LEGILIMENCY_MANA_COST                // “法力 / 法术点”消耗 = 6
	releasedrain = LEGILIMENCY_RESOURCE_COST    // “额外资源消耗”= 15（施法时抽取的疲劳/耐力）
	chargetime = LEGILIMENCY_CHANNEL_TIME       // 蓄力 2 秒（基类点击拦截会校验是否蓄满）
	recharge_time = LEGILIMENCY_COOLDOWN        // 冷却 = 1 分钟（由 charge_check 强制执行）
	cooldown_min = LEGILIMENCY_COOLDOWN         // 即便被“加速”，冷却也不会低于 1 分钟
	human_req = TRUE                            // 只有人类施法者能施放
	warnie = "spellwarning"
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "legilimency"               // 动作按钮图标态（若 dmi 暂无该态仅显示为空，不影响编译）
	invocations = list("现出你的心神来!")        // 咒文（成功施放时由框架喊出）
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	no_early_release = TRUE                      // 未蓄满不允许提前释放
	movement_interrupt = FALSE                  // 与 flight.dm 一致：蓄力期间可移动
	charging_slowdown = 1                        // 蓄力时略微减速
	chargedloop = /datum/looping_sound/invokegen // 蓄力期间循环施法音效
	associated_skill = /datum/skill/magic/arcane // 时长缩放所依据的技能：奥术
	gesture_required = TRUE                      // 需要能自由活动的手
	range = LEGILIMENCY_TARGET_RANGE            // 点选目标的最大距离
	miracle = FALSE
	xp_gain = TRUE
	sound = null                                // 蓄力音由 chargedloop 负责；命中音效在 cast 内单独播放

// ---------------------------------------------------------------------------
// 时长缩放表：根据“施法者”的奥术技能等级，返回接管身体的持续时间（单位：游戏刻）。
// 规格表：L1→5s，L2→10s，L3→20s，L4→40s，L5→80s，L6→160s（逐级翻倍）。
// 用 clamp(1,6) 处理越界：0 级（未入门）按 1 级算，>6 级按 6 级（160s）封顶，
// 满足“超出范围时就近钳制”的要求。把它独立成一个 proc，便于单独调参与复用。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/legilimency/proc/get_duration_for_skill(skill_level)
	switch(clamp(skill_level, 1, 6))
		if(1)
			return 5 SECONDS
		if(2)
			return 10 SECONDS
		if(3)
			return 20 SECONDS
		if(4)
			return 40 SECONDS
		if(5)
			return 80 SECONDS
		if(6)
			return 160 SECONDS
	// 理论上 clamp 后必落入 1~6，这里仅作兜底，返回最低档时长。
	return 5 SECONDS

// ---------------------------------------------------------------------------
// 意志对抗检定：返回 TRUE 表示“施法者压制成功”（目标对抗失败，将被接管），
//               返回 FALSE 表示“目标抵抗成功”（精神侵入被弹开）。
// 设计：施法者一方的“精神强度”= 意志属性 + 奥术技能等级 + 一个随机扰动；
//       目标一方的“抵抗强度”   = 意志属性 + 一个随机扰动。
//       加入随机扰动是为了让势均力敌时双方都有机会，而非纯数值碾压。
// 独立成 proc，便于日后单独调整数值平衡。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/legilimency/proc/win_willpower_contest(mob/living/user, mob/living/target)
	// 施法者的奥术造诣会直接转化为精神侵蚀力，故计入压制方。
	var/caster_skill = user.get_skill_level(associated_skill)
	// 双方各自取“意志”属性作为对抗基础；get_stat 是主线统一的属性读取接口。
	var/caster_power = user.get_stat(STAT_WILLPOWER) + caster_skill + rand(1, 6)
	var/target_power = target.get_stat(STAT_WILLPOWER) + rand(1, 6)
	// 平局判给目标（抵抗方），即“必须严格压过对方意志”才能接管，体现侵入的难度。
	return caster_power > target_power

// ---------------------------------------------------------------------------
// cast：点击命中目标后由基类 InterceptClickOn -> perform 调用。
// targets[1] 即施法者点中的目标。
// 返回值约定：
//   - TRUE  -> perform() 调用 start_recharge()，进入 1 分钟冷却（法术已生效/已耗出）。
//   - FALSE -> 调用 revert_cast() 退还冷却（目标无效 / 点到自己 / 被反魔法挡下 等）。
// 注意：当“目标抵抗成功”时，法术其实已经施放出去了（魔力已消耗），因此返回 TRUE 让
//       其正常进入冷却，仅仅是没有夺取到控制权——这与“对抗检定”的设定一致。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/legilimency/cast(list/targets, mob/living/user = usr)
	// --- 取目标并做基础合法性校验 ---
	var/atom/target_atom = targets[1]
	// 点击式选取：targets[1] 必须是活物，否则视为无效目标并退还冷却。
	if(!isliving(target_atom))
		to_chat(user, span_warning("摄神取念只能施加在活物的心神之上。"))
		revert_cast()
		return FALSE

	var/mob/living/target = target_atom

	// 不能对自己施放：摄取自己的心念没有意义，且会让灵魂转移逻辑自指出错。
	if(target == user)
		to_chat(user, span_warning("我无法摄取自己的心念。"))
		revert_cast()
		return FALSE

	// 目标必须还活着：对一具尸体没有“心神”可夺，直接判无效。
	if(target.stat == DEAD)
		to_chat(user, span_warning("[target] 已无心神可夺——死者的身体不会再听我号令。"))
		revert_cast()
		return FALSE

	// 施法者必须有客户端（是个真正的玩家）：只有真人施法者才能把“控制权”转移到他人身体上。
	if(!user.client)
		revert_cast()
		return FALSE

	// 防重入：禁止“在仍占据他人身体时再次施放摄神取念”，否则会形成“傀儡操纵傀儡”的链式占据，
	// 令灵魂归还时的身体/心智引用彼此错乱（A→占据 B，再从 B 占据 C……，到期归还顺序无法自洽）。
	// 需要同时拦住两种入口，因为施法成功后 transfer_to 会把法术按钮一并搬进被占据的身体（transfer_actions），
	// 施法者完全可以“从傀儡身体里”再点一次本法术——而此时 user 是傀儡身体、并非施法者原身：
	//   情形①：user 是施法者“原身”，且原身仍挂着接管标记（理论上原身在被占据期间没有客户端、
	//           无法发起施法，这里作为冗余保险一并检查）。
	//   情形②：user 是“正被本法术占据中的身体”（身上挂着 legilimency_control 状态）——驱动这具
	//           身体的正是施法者本人，必须禁止其再次施放。这是真正能堵住链式占据的关键判断。
	if(HAS_TRAIT(user, TRAIT_LEGILIMENCY_CASTER) || user.has_status_effect(/datum/status_effect/legilimency_control))
		to_chat(user, span_warning("我的心神仍寄居在他人体内，无法再发动一次摄神取念。"))
		revert_cast()
		return FALSE

	// 反魔法检定：被反魔法保护的目标无法被精神侵入。
	if(target.anti_magic_check())
		target.visible_message(
			span_warning("[target] 周身泛起反魔法的涟漪，将那股侵入心神的魔力挡了下来。"),
			span_notice("一股外来的意志试图钻入我的脑海，却被我身上的反魔法弹开了。")
		)
		to_chat(user, span_warning("[target] 身上的反魔法抵消了『摄神取念』。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		revert_cast()
		return FALSE

	// 防重复占据：若目标身上已经挂着“被接管”状态，说明它正被别人控制，避免叠加冲突。
	if(target.has_status_effect(/datum/status_effect/legilimency_control))
		to_chat(user, span_warning("[target] 的心神已被另一股意志所占据，我无从插足。"))
		revert_cast()
		return FALSE

	// --- 意志对抗检定 ---
	// 这是法术的核心：目标用意志抵抗施法者的精神压制。
	if(!win_willpower_contest(user, target))
		// 目标抵抗成功：精神侵入被弹开，不夺取控制权，但魔力已耗出，故照常进入冷却（返回 TRUE）。
		target.visible_message(
			span_warning("[target] 猛地一震，仿佛奋力甩开了什么无形的东西。"),
			span_green("一股冰冷的意志试图攫住我的心神，但我咬紧牙关，把它逐了出去！")
		)
		to_chat(user, span_warning("[target] 的意志比我预想的更坚韧，我的心神侵入被狠狠弹开了。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 70)
		return TRUE

	// --- 目标对抗失败：施法者接管其身体 ---
	// 时长取决于“施法者”的奥术技能等级（不是目标的）。
	var/caster_skill = user.get_skill_level(associated_skill)
	var/effect_duration = get_duration_for_skill(caster_skill)

	// 重要顺序说明：apply_status_effect 会“同步”执行状态效果的 on_apply，而 on_apply 内部会
	// 立即把施法者的客户端搬入目标身体。一旦搬走，再对 user 发消息就送不到玩家了（玩家已在目标体内）。
	// 因此把面向施法者的提示音与时长告知放在接管“之前”发出。
	playsound(get_turf(target), 'sound/magic/whiteflame.ogg', 70, TRUE)
	to_chat(user, span_info("此次『摄神取念』可维持 [effect_duration / 10] 秒（取决于我的奥术造诣）。"))

	// 把计算好的时长与“施法者引用”一并传给状态效果。
	// apply_status_effect(effect, custom_duration, caster) 会把这两个参数转发给 on_creation()，
	// 由状态效果在 on_apply() 中完成真正的灵魂转移，并在到期/移除时归还身体。
	target.apply_status_effect(/datum/status_effect/legilimency_control, effect_duration, user)

	// 防御性校验：确认接管状态确实挂上了，否则视为失败并退还冷却。
	// （on_apply 内部若发现任何前置条件不满足会返回 FALSE，从而让状态效果自删；此时灵魂尚未转移，
	//   user 仍在自己体内，故下面对 user 的提示与 revert_cast 都能正常生效。）
	if(!target.has_status_effect(/datum/status_effect/legilimency_control))
		to_chat(user, span_warning("精神的桥梁未能架起——什么也没发生。"))
		revert_cast()
		return FALSE

	return TRUE

// ===========================================================================
// 状态效果：摄神取念·接管（Legilimency Control）
// ---------------------------------------------------------------------------
// 这是真正执行“身体接管 / 到期归还”的载体。它挂在“目标身体”上，由 SSfastprocess
// 按 duration 自动到期；到期或被移除时（含目标身体被删除）触发 on_remove 归还身体。
//
// 接管原理（全部复用主线 transfer_to / ghostize）：
//   1) 进入时记下三方引用：施法者原身、施法者心智(mind)、目标原本心智(mind)。
//   2) 施法者心智 transfer_to(目标身体)：施法者客户端被搬入目标身体；
//      目标原本的客户端会被 transfer_to 内部 ghostize 成观察灵魂（被“挤出”身体）。
//   3) 施法者“原身”此刻成为无主躯壳——令其沉睡，避免在被接管期间被随意摆布，
//      并打上 TRAIT_LEGILIMENCY_CASTER 标记以阻止重复施放。
// 归还原理（on_remove）：
//   1) 施法者心智 transfer_to(施法者原身)：把施法者客户端送回自己身体。
//   2) 目标心智 transfer_to(目标身体)：把目标客户端从灵魂状态拉回自己身体。
//   3) 唤醒施法者原身、清除标记。全程对已删除对象做 QDELETED 兜底。
// ===========================================================================
/datum/status_effect/legilimency_control
	id = "legilimency_control"
	// UNIQUE：同一具身体上只允许存在一个“被接管”实例，杜绝多重占据。
	status_type = STATUS_EFFECT_UNIQUE
	// 默认/兜底时长；真正的时长会在 on_creation() 里被施法者传入的值覆盖。
	duration = 5 SECONDS
	// 即使“目标身体”被删除，也要触发 on_remove 把施法者送回自己身体，避免施法者卡在虚空。
	on_remove_on_mob_delete = TRUE
	// 控制类负面效果，给被接管者（归还后）一个可见的状态图标提示。
	alert_type = /atom/movable/screen/alert/status_effect/legilimency_control

	// 施法者“原身”的弱引用：归还时把施法者送回这里。用弱引用以防原身中途被删。
	var/datum/weakref/caster_body_ref
	// 目标“身体”的弱引用：即本状态效果的 owner，归还时把目标心智送回这里。
	var/datum/weakref/target_body_ref
	// 施法者心智（mind 数据本身一般不会被 GC，直接持引用即可；归还时用它搬回原身）。
	var/datum/mind/caster_mind
	// 目标原本的心智：接管前先抓存，归还时用它把目标客户端拉回身体。可能为 null（目标是无心智的 NPC）。
	var/datum/mind/victim_mind
	// 施法者的“技能数据”(/datum/skill_holder)：接管前先抓存其引用。用于在归还时把技能数据强制各归各位，
	// 修复 transfer_to 在“占据活体玩家”场景下会把双方 skill_holder 指针交叉的 Bug（导致技能等级互换）。
	var/datum/skill_holder/caster_skills
	// 目标原本的“技能数据”。占据活体玩家时它会变成“悬挂监听”，归还时若不强制复位就会被错误拖到施法者身上。
	// 目标是无 skill_holder 的简单 NPC 时此值为 null。
	var/datum/skill_holder/victim_skills

// on_creation：在基类把 duration 换算成绝对到期时间之前，先写入施法者算好的时长，
// 并记下施法者引用（随后 ..() 会触发 on_apply 真正执行接管）。
// 形参 custom_duration / caster 来自 apply_status_effect(..., effect_duration, user) 的转发。
/datum/status_effect/legilimency_control/on_creation(mob/living/new_owner, custom_duration, mob/living/caster)
	// 仅在传入了有效正值时覆盖时长，否则保留默认，避免出现 0 或负的时长。
	if(custom_duration && custom_duration > 0)
		duration = custom_duration
	// 记下施法者原身（弱引用，防止其中途被删导致悬空）。
	if(caster)
		caster_body_ref = WEAKREF(caster)
	return ..()

// on_apply：效果挂载时执行“接管”。任一前置条件不满足都返回 FALSE，让基类自删该效果，
// cast() 侧随即检测不到状态效果而退还冷却，保证不会出现“扣了冷却却没接管”的情况。
/datum/status_effect/legilimency_control/on_apply()
	. = ..() // 基类负责挂载/属性处理（本效果无 effectedstats），返回是否成功
	if(!.)
		return FALSE

	// 解析施法者原身；若引用已失效（施法者在蓄力到生效的瞬间消失），则放弃接管。
	var/mob/living/caster = caster_body_ref?.resolve()
	if(QDELETED(caster) || !caster.mind || !caster.client)
		return FALSE

	// owner 即“目标身体”。再次确认其有效。
	if(QDELETED(owner))
		return FALSE

	// 记录目标身体的弱引用，供归还时使用。
	target_body_ref = WEAKREF(owner)
	// 关键：在任何转移发生之前，先抓存“目标原本的心智”。一旦 transfer_to 执行，
	// owner.mind 会被改写为施法者的 mind，届时就再也拿不到目标心智了。
	victim_mind = owner.mind
	// 抓存施法者心智，作为归还时把施法者搬回原身的句柄。
	caster_mind = caster.mind

	// 关键（技能互换 Bug 修复）：在任何 transfer_to 发生之前，先各自抓存“技能数据”引用。
	// 因为 transfer_to 会让 skill_holder 跟随心智在身体间迁移（COMSIG_MIND_TRANSFER + set_current），
	// 而占据活体玩家时，目标自己的 skill_holder 会留下“悬挂监听”，归还途中被错误地拖到施法者身上。
	// 这里先把两个 skill_holder 句柄记下，待 on_remove 末尾再据此把它们强制复位，彻底消除交叉。
	// caster 用 ensure_skills() 确保一定拿得到（施法者必有技能）；目标用 .skills 原样读取（NPC 可能为 null）。
	caster_skills = caster.ensure_skills()
	victim_skills = owner.skills

	// 在“挤出”目标之前先给目标本人发提示——此刻其客户端仍在 owner（目标身体）里，
	// 直接对 owner 发消息一定能送达；转移之后目标客户端被挤成灵魂就不便定位了。
	if(owner.client)
		to_chat(owner, span_userdanger("一股冰冷而强大的意志攫住了你，把你硬生生挤出了自己的身体——你只能眼睁睁看着它被人操纵。"))

	// --- 执行灵魂转移：施法者客户端搬入目标身体 ---
	// force_key_move = TRUE 确保连同 key（客户端）一起搬过去，使施法者真正“操纵”该身体。
	// transfer_to 内部会把目标原本的客户端 ghostize 成观察灵魂（即“目标暂时丧失身体控制权”）。
	caster_mind.transfer_to(owner, TRUE)

	// --- 处理施法者留下的无主躯壳 ---
	// 给原身打上接管标记，阻止施法者（此刻客户端在目标体内，但原身仍在场）被重复施法逻辑利用。
	ADD_TRAIT(caster, TRAIT_LEGILIMENCY_CASTER, LEGILIMENCY_TRAIT_SOURCE)
	// 令无主的原身沉睡，避免被接管期间躯壳被随意操控/搬运；时长略大于接管时长，确保覆盖整个过程。
	// 注意：on_apply 在基类把 duration 换算成绝对到期时间之前调用，此刻 duration 仍是“原始的剩余刻数”，
	//       因此可直接使用，无需再减去 world.time。
	caster.SetSleeping(duration + 10)

	// --- 表现层与告知 ---
	playsound(get_turf(owner), 'sound/magic/soulsteal.ogg', 60, TRUE)
	// 转移完成后，owner 的客户端已变成施法者本人，故这条提示会送达施法者：你已接管该身体。
	to_chat(owner, span_boldwarning("我的意志钻入了这具身体，夺过了它的掌控权——在魔力消散之前，它便是我的傀儡。"))
	return TRUE

// on_remove：效果到期/被移除/owner 被删时触发，负责把双方各自送回自己的身体并清场。
// 全程对可能已被删除的对象做 QDELETED 兜底，保证即使发生意外也不会让玩家卡死在错误的躯体里。
/datum/status_effect/legilimency_control/on_remove()
	// 解析归还所需的两具身体。
	var/mob/living/caster_body = caster_body_ref?.resolve()
	var/mob/living/target_body = target_body_ref?.resolve()

	// --- 第一步：把施法者送回自己的身体 ---
	// 只有当施法者心智仍“寄居在目标身体里”时才需要搬回（避免重复/错误转移）。
	if(caster_mind && !QDELETED(caster_body))
		caster_mind.transfer_to(caster_body, TRUE) // 连同客户端搬回原身
		// 清除沉睡与接管标记，让施法者恢复正常行动。
		caster_body.SetSleeping(0)
		REMOVE_TRAIT(caster_body, TRAIT_LEGILIMENCY_CASTER, LEGILIMENCY_TRAIT_SOURCE)
		to_chat(caster_body, span_notice("维系傀儡的魔力消散了，我的意志被拽回了自己的躯体。"))
	else if(caster_mind && !QDELETED(caster_mind.current))
		// 兜底：原身已不存在，但施法者心智还活着——至少把接管标记从其当前所在身体上清掉，
		// 避免该玩家因残留标记而永久无法再次施放本法术。
		REMOVE_TRAIT(caster_mind.current, TRAIT_LEGILIMENCY_CASTER, LEGILIMENCY_TRAIT_SOURCE)

	// --- 第二步：把目标心智送回自己的身体 ---
	// victim_mind 可能为 null（目标本就是无心智 NPC），那样无需归还。
	if(victim_mind && !QDELETED(target_body))
		// 仅当目标身体此刻不是被目标自己占据时才搬回，避免无意义的重复转移。
		if(victim_mind.current != target_body)
			victim_mind.transfer_to(target_body, TRUE) // 把目标客户端从灵魂状态拉回自己身体
			to_chat(target_body, span_notice("束缚我的意志骤然松脱，我重新夺回了对自己身体的掌控。"))

	// --- 第三步：修复“技能等级互换”Bug —— 把两份技能数据强制各归各位 ---
	// 成因：transfer_to 让 skill_holder 跟随心智迁移（靠 COMSIG_MIND_TRANSFER 信号 + set_current）。
	//       占据活体玩家时，目标自己的 skill_holder 仍挂在目标身体上监听该信号，却已不再被 .skills 指向；
	//       归还时第一步 transfer_to 在目标身体上 SEND_SIGNAL(COMSIG_MIND_TRANSFER)，这个“悬挂监听”被触发，
	//       于是目标的技能数据被错误地拖到了“施法者原身”上——双方技能等级看起来就互换了。
	// 修复思路：skill_holder 的“内容”（known_skills/经验）始终正确，错乱的只是“哪具身体指向哪份数据”。
	//       因此在所有 transfer_to 都结束后，按开场抓存的引用把它们重新钉死：施法者技能→施法者原身，
	//       目标技能→目标身体。先 UnregisterSignal 摘除两份数据在两具身体上的全部 COMSIG_MIND_TRANSFER 监听
	//       （含归还途中产生的悬挂监听），避免随后 set_current 重复注册报错；再用 set_current 干净复位。
	if(caster_skills)
		// 先把施法者技能数据从两具身体上的迁移监听里彻底摘除（未注册时为无害空操作）。
		if(!QDELETED(caster_body))
			caster_skills.UnregisterSignal(caster_body, COMSIG_MIND_TRANSFER)
		if(!QDELETED(target_body))
			caster_skills.UnregisterSignal(target_body, COMSIG_MIND_TRANSFER)
	if(victim_skills)
		// 同样摘除目标技能数据在两具身体上的迁移监听，清掉占据期间遗留的悬挂监听。
		if(!QDELETED(caster_body))
			victim_skills.UnregisterSignal(caster_body, COMSIG_MIND_TRANSFER)
		if(!QDELETED(target_body))
			victim_skills.UnregisterSignal(target_body, COMSIG_MIND_TRANSFER)
	// 把施法者技能数据钉回施法者原身：set_current 会重设 current、重新注册监听并令 caster_body.skills 指回它。
	if(caster_skills && !QDELETED(caster_body))
		caster_skills.set_current(caster_body)
	// 把目标技能数据钉回目标身体（玩家目标）。
	if(victim_skills && !QDELETED(target_body))
		victim_skills.set_current(target_body)
	else if(!QDELETED(target_body) && target_body.skills == caster_skills)
		// 目标本是无 skill_holder 的简单 NPC：避免它残留指向“施法者技能数据”的悬挂指针，
		// 直接置空，需要时引擎会通过 ensure_skills() 给它新建一份空白技能数据。
		target_body.skills = null

	// --- 第四步：清除可能残留的“掉线/SSD”提示（头顶 zzz 标记）---
	// 成因：施法者客户端从目标身体撤离时，主线 /mob/living/Logout() 会无条件给该身体
	//       set_ssd_indicator(TRUE)，留下一个“zzz”掉线标记。对“玩家目标”而言，其本人随后
	//       重新登入身体（Login）会清掉该标记；但若目标本是“简单生物 NPC”（victim_mind 为 null），
	//       撤离后没有任何客户端回到它身上，于是 zzz 标记便无人清除、永久残留在它头顶。
	// 处理：只要目标身体最终回到“无客户端”的状态，就显式调用 set_ssd_indicator(FALSE) 抹掉残留标记，
	//       这同样覆盖“玩家目标因故没能归位（仍是灵魂）”等边角情况——此时身体确实无人控制，清掉也正确。
	if(!QDELETED(target_body) && !target_body.client)
		target_body.set_ssd_indicator(FALSE)

	// 清理引用，避免悬挂。
	caster_mind = null
	victim_mind = null
	caster_skills = null
	victim_skills = null
	caster_body_ref = null
	target_body_ref = null
	return ..()

// 状态效果对应的状态栏图标/提示（归还后，被害者会短暂看到自己曾被夺取过的余韵提示）。
// 复用主线已存在的通用负面状态图标 "debuff"，保证图标一定有效；可日后替换为专属图标。
/atom/movable/screen/alert/status_effect/legilimency_control
	name = "摄神取念"
	desc = "一股外来的意志曾攫住我的心神，夺走了对身体的掌控。"
	icon_state = "debuff"

// ===== 清理顶部定义的宏，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef LEGILIMENCY_MANA_COST
#undef LEGILIMENCY_CHANNEL_TIME
#undef LEGILIMENCY_COOLDOWN
#undef LEGILIMENCY_RESOURCE_COST
#undef LEGILIMENCY_TARGET_RANGE
#undef TRAIT_LEGILIMENCY_CASTER
#undef LEGILIMENCY_TRAIT_SOURCE
