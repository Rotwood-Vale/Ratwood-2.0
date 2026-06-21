// modular_z121 自定义奥术法术：神锋无影（Sectumsempra）
// ---------------------------------------------------------------------------
// 设计目标：一个 T4“单体爆发”法术。激活法术 -> 0.8 秒蓄力 -> 点选 9 格内的一名目标
//           -> 射出一道无形利刃，在命中目标身上撕开多道极深的“破碎割伤”，
//           追求“一击致命”。与追求大范围的高级法术不同，本法术把全部杀伤
//           集中于单一目标，伤害强度对标 T4 法术的定位（高于一般 T3 攻击咒）。
//
// 弧射特性（本次新增）：投射物以“弧射（arcshot）”方式飞行——像主线“奥术飞矢”
//           （arcyne_bolt）切换到弧射意图时那样，划出一道抛物线越过沿途盟友的头顶，
//           最终笔直落向被点选的目标。这样在己方队列后方也能安全狙杀单一敌人，
//           而清醒的友军（间接弹道目标）会自动闪避，不会误伤。
//
// 灵感来源：哈利·波特系列小说中的同名魔咒。咒文与表现文本均为本项目原创撰写，
//           不复制任何原著文字。
//
// 选取/蓄力方式：沿用 pain.dm（钻心剜骨）的成熟做法——以 /spell/invoked 为基类，
//           点选目标即 targets[1]；在 cast() 中先做 0.8 秒蓄力（基类点击拦截依
//           chargetime 校验），再手动发射自定义投射物，命中后由投射物回调本法术
//           的结算 proc。投射物方案天然支持“被墙体/护甲/反魔法拦下”等失败分支。
//
// 约束：所有代码仅存在于 modular_z121 内，只“调用”主线已有的伤害 / 伤口 / 断肢系统
//       （apply_damage、bodypart.add_wound、bodypart.dismember），不修改 modular_z121
//       之外的任何文件。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数（文件末尾统一 #undef，避免污染全局命名空间）=====
#define SECTUM_MANA_COST       9              // 法力 / 法术点消耗（cost）= 9，符合 T3 规格
#define SECTUM_RESOURCE_COST   10             // “额外资源消耗”：每次施放抽取的疲劳/耐力（releasedrain）= 10
#define SECTUM_CHANNEL_TIME    (0.8 SECONDS)  // 蓄力时长 = 0.8 秒（由基类点击拦截按 chargetime 校验）
#define SECTUM_COOLDOWN        (1.2 SECONDS)  // 成功施放后的冷却 = 1.2 秒（短冷却换取单体高爆发）
#define SECTUM_TARGET_RANGE    9              // 点选 / 投射的最大距离 = 9 格

// ===== 伤害模型参数：实现“破碎割伤 + 近乎一击致命”的核心数值（T4 强度）=====
// 升为 T4 后整体上调：单道割伤更深、碎裂道数更多、斩肢门槛更低，确保单体爆发对标 T4。
#define SECTUM_BASE_SLASH      26             // 每一道割伤的基础 BRUTE 伤害（未计奥术加成；由 18 上调至 26）
#define SECTUM_SLASH_PER_LEVEL 5              // 奥术等级每 +1，每道割伤额外增加的 BRUTE 伤害（由 4 上调至 5）
#define SECTUM_BASE_FRAGMENTS  4              // 基础“碎裂”割伤的道数（由 3 上调至 4，命中即撕开更多深创）
#define SECTUM_DISMEMBER_LEVEL 3              // 触发“断肢”所需的最低奥术等级（由 4 下调至 3，T4 更易斩落肢体）

// ===========================================================================
// 法术本体
// ---------------------------------------------------------------------------
// 选用 /spell/invoked 作为基类（与 pain.dm 一致）：点击图标后进入“点选目标”模式，
// 蓄力满后点击某个目标即对其结算。这样既满足“需要选定单一目标”，又能通过
// revert_cast() 在任意失败/取消分支下退还冷却。
// ===========================================================================
/obj/effect/proc_holder/spell/invoked/sectumsempra
	name = "神锋无影"                          // 玩家可见名（中文）
	desc = "极致的锋锐之咒。与追求大范围杀伤的高阶法术不同，它把全部锋芒凝于一线，\
		以一道无形利刃撕裂单一目标，专为‘一击毙命’而生。锋刃会划出一道抛物线\
		越过沿途盟友的头顶，再笔直落向被锁定的敌人。" // 玩家可见描述（中文，含弧射说明）
	school = "evocation"                       // 归类为塑能系（直接造成伤害的攻击法术）
	spell_tier = 4                             // T4 法术（由 T3 提升，伤害随之对标 T4）
	cost = SECTUM_MANA_COST                    // 法力 / 法术点消耗 = 9
	releasedrain = SECTUM_RESOURCE_COST        // 额外资源消耗 = 10（施法时抽取的疲劳/耐力）
	chargedrain = 1                            // 蓄力期间每刻的额外抽取（沿用 pain.dm 的取值）
	chargetime = SECTUM_CHANNEL_TIME           // 蓄力 = 0.8 秒（基类点击拦截会校验是否蓄满）
	recharge_time = SECTUM_COOLDOWN            // 冷却 = 1.2 秒（由 charge_check 强制执行）
	cooldown_min = SECTUM_COOLDOWN             // 即便被“加速”，冷却也不会低于 1.2 秒
	range = SECTUM_TARGET_RANGE                // 点选 / 投射目标的最大距离 = 9 格
	human_req = TRUE                           // 只有人类施法者能施放
	warnie = "spellwarning"                    // 施法警示样式（沿用项目通用值）
	action_icon = 'modular_z121/icon/custompell.dmi' // 动作按钮图标来源（项目自定义法术图标集）
	overlay_state = "sectumsempra"             // 动作按钮图标态（若 dmi 暂无该态仅显示为空，不影响编译）
	// 咒文：成功施放（蓄力满）时由框架喊出。此处为原创撰写的中文吟唱，呼应“锋锐斩裂”的主题。
	invocations = list("锋出无影，斩！")
	invocation_type = "shout"                  // 以“呼喊”方式念出咒文（满足“施法须念台词”的要求）
	glow_color = GLOW_COLOR_ARCANE             // 施法辉光：奥术色
	glow_intensity = GLOW_INTENSITY_MEDIUM     // 辉光强度（T3 用中等，比低阶更醒目）
	no_early_release = TRUE                     // 未蓄满不允许提前释放，避免半蓄力空放
	movement_interrupt = FALSE                  // 与 pain.dm 一致：蓄力期间可移动，命中靠投射物结算
	charging_slowdown = 2                       // 蓄力时减速（专注引导锋刃）
	chargedloop = /datum/looping_sound/invokegen // 蓄力期间循环施法音效
	associated_skill = /datum/skill/magic/arcane // 伤害缩放所依据的技能：奥术
	gesture_required = TRUE                      // 需要能自由活动的手来挥出斩击
	miracle = FALSE                              // 非奇迹（属于可学习的奥术法术）
	xp_gain = TRUE                               // 成功施放可获得奥术经验
	sound = null                                 // 蓄力音由 chargedloop 负责；命中音在结算 proc 内单独播放
	// 本法术发射的投射物类型；独立成变量便于子类或管理工具替换弹种。
	var/projectile_type = /obj/projectile/energy/sectumsempra_bolt

// ===========================================================================
// 投射物：无形锋刃（Sectumsempra Bolt）
// ---------------------------------------------------------------------------
// 用一道高速、几乎不可见的能量投射物承载斩击。它本身只负责“命中判定 + 反魔法拦截”，
// 真正的破碎割伤结算交回 casting_spell（保持伤害逻辑集中、便于调参）。
// ===========================================================================
/obj/projectile/energy/sectumsempra_bolt
	name = "无形锋刃"                          // 投射物名（中文）
	icon = 'modular_z121/icon/projectiles.dmi'  // 使用本法术专属的贴图资源（modular_z121 内的自定义图集）
	icon_state = "sectumsempra"                 // 该图集中唯一的贴图态：神锋无影专属弹道贴图
	// 注：不再使用 color 染色——旧贴图借用通用白色光点，需染色才像“无形利刃”；
	// 如今已有专属贴图，叠加颜色乘算反而会污染美术原本的配色，故移除染色。
	damage = 0                                  // 投射物自身不直接结算伤害；伤害全部走 casting_spell 结算
	damage_type = BRUTE                         // 名义伤害类型为钝/物理（实际割裂在结算 proc 内施加）
	nodamage = TRUE                             // 标记为“无直接伤害”，避免与结算 proc 重复扣血
	speed = 0.6                                 // 飞行速度（比普通弹更快，体现“疾如闪电”的锋锐）
	// 弧射：与主线“奥术飞矢”弧射形态一致，令投射物划出抛物线越过沿途盟友头顶，再落向目标。
	// 弹道系统据此把沿途的“间接弹道目标”（清醒的友军/路人）视为可闪避，从而不会误伤队友；
	// 而被点选的目标作为“直接目标”仍会被正常命中。
	arcshot = TRUE
	muzzle_type = null                          // 不显示枪口特效（无形）
	impact_type = null                          // 不显示命中特效（命中观感由结算 proc 的消息/音效负责）
	hitsound = 'sound/combat/hits/bladed/genchop (1).ogg' // 命中音：刃器劈砍声
	// 命中后回调用：指向发射本投射物的法术实例，结算时调用其 apply_sectumsempra()。
	var/obj/effect/proc_holder/spell/invoked/sectumsempra/casting_spell
	// 记录命中部位，确保“显示命中处”与“割伤结算处”一致，避免弹道偏斜导致错位。
	var/target_zone

// on_hit：投射物命中某物时由弹道系统调用。
// 返回值约定遵循主线投射物接口：BULLET_ACT_BLOCK 表示被挡下，BULLET_ACT_HIT 表示有效命中。
/obj/projectile/energy/sectumsempra_bolt/on_hit(atom/target, blocked = FALSE)
	// 只对活物结算斩击；命中墙体/物件等非生物时走父级默认逻辑（直接消失）。
	if(!isliving(target))
		return ..()

	var/mob/living/living_target = target
	// 命中被完全格挡（blocked == 100，例如盾牌/护甲完全抵消）时不结算伤害。
	if(blocked == 100)
		return ..()

	// 反魔法检定：被反魔法保护的目标会让这道锋刃凭空溃散，施法失败。
	if(living_target.anti_magic_check())
		visible_message(span_warning("[src] 在触及 [living_target] 的刹那化作一缕碎光，被反魔法尽数驱散了！"))
		playsound(get_turf(living_target), 'sound/magic/magic_nulled.ogg', 100)
		return BULLET_ACT_BLOCK

	// 先执行父级命中流程（处理通用命中逻辑），若父级判定为被挡则直接返回。
	. = ..()
	if(. == BULLET_ACT_BLOCK)
		return .

	// 没有合法的施法者（firer 非生物）时无法结算，按普通命中收尾。
	if(!isliving(firer))
		return BULLET_ACT_HIT

	var/mob/living/caster = firer
	// 没有回调法术实例（异常情况，例如法术已被删除）时无法结算，安全退出。
	if(!casting_spell)
		return BULLET_ACT_HIT

	// 把真正的破碎割伤结算交回法术本体；若结算失败则提示施法者（目标可能免疫等）。
	if(!casting_spell.apply_sectumsempra(living_target, caster, target_zone))
		to_chat(caster, span_warning("[living_target] 似乎不受这道锋刃所伤。"))
		return BULLET_ACT_HIT

	return BULLET_ACT_HIT

// ===========================================================================
// cast：蓄力满后点击命中目标，由基类 InterceptClickOn -> perform 调用。
// targets[1] 即施法者点中的目标。
// 返回值约定：
//   - TRUE  -> perform() 调用 start_recharge()，进入 1.2 秒冷却（施法成功）。
//   - FALSE -> 调用 revert_cast() 退还冷却（目标无效 / 取消 / 发射失败）。
// ===========================================================================
/obj/effect/proc_holder/spell/invoked/sectumsempra/cast(list/targets, mob/living/user = usr)
	// 若施法者正在演奏/持续动作（curplaying），先安全打断，避免与施法状态冲突（沿用 pain.dm）。
	if(user?.curplaying)
		user.curplaying.on_mouse_up()

	// 防御性校验：targets 必须存在且首项为活物，否则视为无效选取并退还冷却（优雅取消）。
	if(!length(targets))
		revert_cast()
		return FALSE
	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		to_chat(user, span_warning("神锋无影只能斩向活物。"))
		revert_cast()
		return FALSE

	var/mob/living/target = target_atom
	// 不允许把这道致命斩击对准自己，防止误操作自残。
	if(target == user)
		to_chat(user, span_warning("我不能将这道锋刃斩向自己。"))
		revert_cast()
		return FALSE

	// 发射投射物；任何发射失败都退还冷却，保证不会“空耗冷却”。
	if(!fire_sectumsempra_projectile(user, target))
		revert_cast()
		return FALSE

	// 表现层：施法者挥手斩出无形利刃的提示文本。
	user.visible_message(span_danger("[user] 手腕一振，一道几乎无形的锋刃疾射向 [target]！"))
	to_chat(user, span_notice("我将神锋无影凝作一线，直取 [target] 的要害。"))
	return TRUE

// ---------------------------------------------------------------------------
// fire_sectumsempra_projectile：构造并发射自定义投射物。
// 独立成 proc 便于复用与单独调参（命中修正、弹道准备等都集中于此）。
// 返回 TRUE 表示成功发射，FALSE 表示发射前置条件不满足。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/sectumsempra/proc/fire_sectumsempra_projectile(mob/living/user, atom/target)
	// 用户或目标已失效（例如施法瞬间被删除）时不发射，避免运行时错误。
	if(QDELETED(user) || QDELETED(target))
		return FALSE

	// 在施法者所在格生成投射物。
	var/obj/projectile/energy/sectumsempra_bolt/projectile = new projectile_type(user.loc)
	// 统一以胸口作为命中/结算部位：作为“要害单体爆发”，固定打击躯干更稳定，也避免弹道随机偏斜后错位。
	projectile.def_zone = BODY_ZONE_CHEST
	projectile.target_zone = BODY_ZONE_CHEST
	// 回填回调引用，让投射物命中后能调回本法术结算破碎割伤。
	projectile.casting_spell = src
	// 命中修正：沿用现有投射法术的做法，让智力与奥术造诣略微提高命中率（体现“精准”）。
	projectile.accuracy += (user.STAINT - 9) * 4
	projectile.bonus_accuracy += (user.STAINT - 8) * 3
	if(user.mind)
		projectile.bonus_accuracy += (user.get_skill_level(associated_skill) * 5)
	// 标记发射者，供 on_hit 内识别施法者与做反伤判定。
	projectile.firer = user
	// 计算弹道并发射（朝目标方向）。
	projectile.preparePixelProjectile(target, user)
	projectile.fire()
	return TRUE

// ---------------------------------------------------------------------------
// get_slash_damage：根据施法者的奥术等级，返回“单道割伤”的 BRUTE 伤害。
// 基础值随等级线性提升，体现“造诣越高、刃越利”。独立成 proc 便于调参。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/sectumsempra/proc/get_slash_damage(mob/living/user)
	// 取奥术等级，钳到 [0, +∞)，未入门按 0 级处理，避免负数导致伤害异常。
	var/arcane_level = max(user?.get_skill_level(associated_skill), 0)
	// 每道割伤伤害 = 基础值 + 等级 * 每级加成。
	return SECTUM_BASE_SLASH + (arcane_level * SECTUM_SLASH_PER_LEVEL)

// ---------------------------------------------------------------------------
// get_fragment_count：根据奥术等级返回“碎裂割伤”的道数。
// 等级越高，刃锋分裂越多，单体总伤害越接近“一击致命”，从而对标 T4 定位。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/sectumsempra/proc/get_fragment_count(mob/living/user)
	// 取奥术等级并钳到非负。
	var/arcane_level = max(user?.get_skill_level(associated_skill), 0)
	// 道数 = 基础道数 + 每 2 级 +1（用整除实现），高造诣可撕开更多伤口。
	return SECTUM_BASE_FRAGMENTS + round(arcane_level / 2)

// ===========================================================================
// apply_sectumsempra：核心效果结算——在目标身上施加“破碎割伤”。
// 由投射物 on_hit 在确认命中、且通过反魔法检定后调用。
// 返回 TRUE 表示成功造成效果，FALSE 表示目标免疫/无法结算（用于上层提示）。
// ===========================================================================
/obj/effect/proc_holder/spell/invoked/sectumsempra/proc/apply_sectumsempra(mob/living/target, mob/living/user, preferred_zone = null)
	// 入参防御：目标或施法者失效则结算失败。
	if(QDELETED(target) || QDELETED(user))
		return FALSE
	// 处于无敌（GODMODE）的目标不受伤害，视为结算失败。
	if(target.status_flags & GODMODE)
		return FALSE

	// 计算本次每道割伤的伤害与道数（均依施法者奥术造诣缩放）。
	var/slash_damage = get_slash_damage(user)
	var/fragment_count = get_fragment_count(user)

	// 命中表现：凄厉的劈裂声 + 受击者惨叫，强化“恐怖斩裂”的临场感。
	playsound(get_turf(target), 'sound/combat/hits/bladed/genchop (1).ogg', 100)
	target.visible_message(
		span_danger("[target] 周身骤然迸开一连串无形的深长裂口，鲜血如注般飙溅而出！"),
		span_userdanger("无数看不见的利刃同时割裂了我的身体，剧痛与喷涌的鲜血几乎将我吞没！")
	)

	// 对“类人 carbon”目标：把割伤分散到多个肢体上，制造“碎裂式”多处深创（核心观感）。
	if(iscarbon(target))
		return apply_carbon_sectumsempra(target, user, slash_damage, fragment_count, preferred_zone)

	// 对“拥有简易伤口系统”的非类人生物（如部分怪物）：施加等效的简易割伤并扣血。
	if(HAS_TRAIT(target, TRAIT_SIMPLE_WOUNDS))
		return apply_simple_sectumsempra(target, user, slash_damage, fragment_count)

	// 兜底：其余活物（无肢体/无伤口系统）直接结算等量 BRUTE 总伤害，确保“效果切实生效”。
	target.apply_damage(slash_damage * fragment_count, BRUTE)
	return TRUE

// ---------------------------------------------------------------------------
// apply_carbon_sectumsempra：对类人目标的“破碎割伤”结算。
// 逐一在多个肢体上施加深长割伤（add_wound）+ BRUTE 伤害，并对直接命中的部位
// 在高造诣时尝试斩断肢体，最大化“一击致命”的威胁。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/sectumsempra/proc/apply_carbon_sectumsempra(mob/living/carbon/target, mob/living/user, slash_damage, fragment_count, preferred_zone)
	// 收集目标当前实际存在的肢体，作为“可被割裂”的候选池。
	var/list/obj/item/bodypart/available_parts = target.bodyparts?.Copy()
	// 没有任何肢体可割（异常情况）时，退化为直接结算总 BRUTE 伤害，保证仍有效果。
	if(!length(available_parts))
		target.apply_damage(slash_damage * fragment_count, BRUTE)
		return TRUE

	// 优先锁定“投射物命中部位”作为第一刀的落点，使表现与结算一致。
	var/obj/item/bodypart/primary_part = target.get_bodypart(check_zone(preferred_zone || user?.zone_selected))
	// 若指定部位不存在（已断肢等），退而选用候选池中的第一个肢体。
	if(!primary_part)
		primary_part = available_parts[1]

	// 记录已经被割过的肢体，尽量让多道割伤分散到不同部位（更像“全身碎裂”）。
	var/list/obj/item/bodypart/already_cut = list()

	// 依据道数循环施加割伤；每一道都尽量挑一个尚未被割的肢体。
	for(var/i in 1 to fragment_count)
		// 第一刀固定落在主命中部位；其余刀优先选未割过的肢体。
		var/obj/item/bodypart/cut_part = (i == 1) ? primary_part : pick_uncut_bodypart(available_parts, already_cut)
		// 若已无未割肢体可选，则回落到主命中部位，叠加更深的创伤。
		if(!cut_part)
			cut_part = primary_part
		// 记入已割集合，降低重复挑中同一肢体的概率。
		already_cut |= cut_part
		// 在该肢体上施加一道“可怖割伤”（高流血、深创），由主线伤口系统接管出血/缝合等后续。
		cut_part.add_wound(/datum/wound/slash/large, TRUE)
		// 同时对该部位结算 BRUTE 伤害，以割裂（BCLASS_CUT）的方式扣血，真正威胁生命。
		target.apply_damage(slash_damage, BRUTE, cut_part.body_zone)

	// 高造诣斩肢：奥术等级达到阈值时，尝试把直接命中的肢体整个斩落，制造“致命一击”。
	try_dismember(target, user, primary_part, slash_damage)

	return TRUE

// ---------------------------------------------------------------------------
// pick_uncut_bodypart：从候选肢体中挑选一个尚未被割过的部位。
// 用于让多道割伤尽量分散到全身不同肢体，强化“碎裂”观感。
// 找不到未割部位时返回 null（由调用方决定回落策略）。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/sectumsempra/proc/pick_uncut_bodypart(list/obj/item/bodypart/available_parts, list/obj/item/bodypart/already_cut)
	// 过滤出还没被割过、且仍然有效的肢体。
	var/list/obj/item/bodypart/candidates = list()
	for(var/obj/item/bodypart/part as anything in available_parts)
		if(QDELETED(part))
			continue
		if(part in already_cut)
			continue
		candidates += part
	// 有候选则随机挑一个（避免每次都按固定顺序割），否则返回 null。
	if(length(candidates))
		return pick(candidates)
	return null

// ---------------------------------------------------------------------------
// try_dismember：在满足条件时尝试斩断指定肢体，作为“一击致命”的高潮表现。
// 仅在施法者奥术等级达到阈值、且目标未受“防断肢”保护时才会触发。
// 调用主线 bodypart.dismember()，由其内部处理护甲、断肢音效与残肢生成。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/sectumsempra/proc/try_dismember(mob/living/carbon/target, mob/living/user, obj/item/bodypart/part, slash_damage)
	// 肢体已失效则无需斩断。
	if(QDELETED(part))
		return FALSE
	// 造诣不足（低于阈值等级）时不触发斩肢，保留给高阶施法者的强力收割。
	if(max(user?.get_skill_level(associated_skill), 0) < SECTUM_DISMEMBER_LEVEL)
		return FALSE
	// 目标带有“不可断肢”特性时跳过（尊重主线的免疫设计）。
	if(HAS_TRAIT(target, TRAIT_NODISMEMBER))
		return FALSE

	// 以割裂类型（BCLASS_CUT）请求斩断该肢体；护甲/部位限制由 dismember 内部判定。
	// 传入 slash_damage 作为破甲参考，并以本法术施法者作为 user 归因。
	if(part.dismember(BRUTE, BCLASS_CUT, user, part.body_zone, slash_damage))
		// 斩落成功时的额外表现，凸显“无形利刃齐根斩断”的恐怖。
		target.visible_message(
			span_danger("一道无形的锋刃自 [target] 的[part.name]齐根掠过，竟将其整个斩落！"),
			span_userdanger("我甚至来不及惨叫——那道看不见的利刃已将我的[part.name]整个削断！")
		)
		return TRUE
	return FALSE

// ---------------------------------------------------------------------------
// apply_simple_sectumsempra：对“简易伤口系统”非类人生物的结算。
// 这类生物没有可独立结算的肢体，于是叠加多道简易割伤并按总量扣血，
// 在保持效果一致（多道深创 + 高伤害）的同时避免触碰类人专属的肢体逻辑。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/sectumsempra/proc/apply_simple_sectumsempra(mob/living/target, mob/living/user, slash_damage, fragment_count)
	// 按道数叠加简易割伤；simple_add_wound 由主线简易伤口系统处理出血等表现。
	for(var/i in 1 to fragment_count)
		target.simple_add_wound(/datum/wound/slash/large, TRUE)
	// 一次性结算全部 BRUTE 总伤害（道数 * 单道伤害），确保杀伤力到位。
	target.apply_damage(slash_damage * fragment_count, BRUTE)
	return TRUE

// ===== 清理顶部定义的宏，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef SECTUM_MANA_COST
#undef SECTUM_RESOURCE_COST
#undef SECTUM_CHANNEL_TIME
#undef SECTUM_COOLDOWN
#undef SECTUM_TARGET_RANGE
#undef SECTUM_BASE_SLASH
#undef SECTUM_SLASH_PER_LEVEL
#undef SECTUM_BASE_FRAGMENTS
#undef SECTUM_DISMEMBER_LEVEL
