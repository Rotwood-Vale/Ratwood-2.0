// modular_z121 自定义奥术法术：神锋无影（Sectumsempra）
// ---------------------------------------------------------------------------
// 设计目标：一个 T4“单体精准”法术。激活法术 -> 0.8 秒蓄力 -> 瞄准 9 格内的一名活物
//           -> 射出一道无形利刃，在“命中的那一处部位”上撕开一道恐怖的深长撕裂创，
//           追求“一击致命”。与追求大范围的高级法术不同，本法术把全部杀伤集中于
//           单一目标的“受击部位”，伤害强度对标 T4 法术的定位。
//
// 本次调整（三点）：
//   1) 伤害集中到“受击部位”：不再把割伤分散到目标全身，而是把恐怖的撕裂伤害
//      全部灌注到投射物实际命中的那一处肢体上（局部、深、致命）。
//   2) 不强制锁定命中部位、也不强制瞄准活物：受击部位取施法者“当前瞄准的部位”
//      （zone_selected），而非硬编码锁死为胸口；施放时只要朝某个方向瞄准即可发射，
//      投射物会朝瞄准方向飞出，命中活物时才结算撕裂（与 arcyne_bolt 一致）。
//   3) 改用投射物法术基类：完全比照主线“奥术飞矢”（arcyne_bolt）的做法，继承
//      /obj/effect/proc_holder/spell/invoked/projectile，由基类负责发射投射物、
//      命中目标，命中伤害由弹道系统按 woundclass 自然结算到受击部位。
//
// 弧射特性（独立弹种，非写死在法术上）：完全比照奥术飞矢（arcyne_bolt）——把弧射效果
//           做成一个单独的投射物子型 /obj/projectile/energy/sectumsempra_bolt/arc（带 arcshot），
//           法术在 cast() 中依据施法者是否切到“弧射意图”（magicarc）来择一发射标准版或弧射版。
//           弧射版划出抛物线越过沿途盟友头顶（清醒友军自动闪避），但作为代价少造成伤害。
//
// 灵感来源：哈利·波特系列小说中的同名魔咒。咒文与表现文本均为本项目原创撰写，
//           不复制任何原著文字。
//
// 约束：所有代码仅存在于 modular_z121 内，只“调用”主线已有的弹道 / 伤口 / 断肢系统
//       （弹道伤害结算、bodypart.add_wound、bodypart.dismember），不修改 modular_z121
//       之外的任何文件。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数（文件末尾统一 #undef，避免污染全局命名空间）=====
#define SECTUM_MANA_COST          9             // 法力 / 法术点消耗（cost）= 9
#define SECTUM_RESOURCE_COST      10            // “额外资源消耗”：每次施放抽取的疲劳/耐力（releasedrain）= 10
#define SECTUM_CHANNEL_TIME       (0.6 SECONDS) // 蓄力时长 = 0.6 秒（由基类点击拦截按 chargetime 校验）
#define SECTUM_COOLDOWN           (1 SECONDS)   // 成功施放后的冷却 = 1 秒（短冷却换取单体高爆发）
#define SECTUM_TARGET_RANGE       9             // 瞄准 / 投射的最大距离 = 9 格

// ===== 伤害模型参数：实现“集中于受击部位的恐怖撕裂 + 近乎一击致命”（T4 强度）=====
#define SECTUM_BASE_LACERATION    40            // 受击部位的基础 BRUTE 撕裂伤害（未计奥术加成）
#define SECTUM_LACERATION_PER_LVL 7             // 奥术等级每 +1，受击部位额外增加的 BRUTE 撕裂伤害
#define SECTUM_DISMEMBER_LEVEL    3             // 触发“斩断受击肢体”所需的最低奥术等级（T4 高造诣易斩落）

// ===========================================================================
// 法术本体
// ---------------------------------------------------------------------------
// 继承 /obj/effect/proc_holder/spell/invoked/projectile（与 arcyne_bolt 完全一致）：
// 激活后进入“瞄准”模式，蓄力满即朝瞄准点发射一枚投射物；命中由弹道系统判定，
// 命中伤害由投射物的 damage / woundclass 自然结算到受击部位。
// 本子类只做两件事：
//   - 重写 cast()：强制要求“瞄准活物”，否则优雅取消并退还冷却；
//   - 重写 ready_projectile()：按施法者奥术造诣动态调高投射物伤害，并把施法等级
//     传给投射物，供命中后追加“恐怖撕裂创 + 斩肢”使用。
// ===========================================================================
/obj/effect/proc_holder/spell/invoked/projectile/sectumsempra
	name = "神锋无影"                          // 玩家可见名（中文）
	desc = "极致的锋锐之咒。与追求大范围杀伤的高阶法术不同，它把全部锋芒凝于一线，\
		射出一道无形利刃，只在命中的那一处皮肉上撕开一道恐怖的深长裂创，专为\
		‘一击毙命’而生。锋刃会划出一道抛物线越过沿途盟友头顶，再笔直落向被瞄准的敌人。" // 玩家可见描述
	school = "evocation"                       // 归类为塑能系（直接造成伤害的攻击法术）
	spell_tier = 4                             // T4 法术
	cost = SECTUM_MANA_COST                    // 法力 / 法术点消耗 = 9
	releasedrain = SECTUM_RESOURCE_COST        // 额外资源消耗 = 10（施法时抽取的疲劳/耐力）
	chargedrain = 1                            // 蓄力期间每刻的额外抽取
	chargetime = SECTUM_CHANNEL_TIME           // 蓄力 = 0.8 秒（基类点击拦截会校验是否蓄满）
	recharge_time = SECTUM_COOLDOWN            // 冷却 = 1.2 秒（由 charge_check 强制执行）
	cooldown_min = SECTUM_COOLDOWN             // 即便被“加速”，冷却也不会低于 1.2 秒
	range = SECTUM_TARGET_RANGE                // 瞄准 / 投射目标的最大距离 = 9 格
	projectile_type = /obj/projectile/energy/sectumsempra_bolt // 本法术发射的投射物类型
	human_req = TRUE                           // 只有人类施法者能施放
	warnie = "spellwarning"                    // 施法警示样式（沿用项目通用值）
	action_icon = 'modular_z121/icon/custompell.dmi' // 动作按钮图标来源（项目自定义法术图标集）
	overlay_state = "sectumsempra"             // 动作按钮图标态（若 dmi 暂无该态仅显示为空，不影响编译）
	// 咒文：成功施放（蓄力满）时由框架喊出。原创撰写的中文吟唱，呼应“锋锐斩裂”的主题。
	invocations = list("锋出无影，斩！")
	invocation_type = "shout"                  // 以“呼喊”方式念出咒文（满足“施法须念台词”的要求）
	glow_color = GLOW_COLOR_ARCANE             // 施法辉光：奥术色
	glow_intensity = GLOW_INTENSITY_MEDIUM     // 辉光强度（T4 用中等，比低阶更醒目）
	no_early_release = TRUE                     // 未蓄满不允许提前释放，避免半蓄力空放
	movement_interrupt = FALSE                  // 蓄力期间可移动，命中靠投射物结算
	charging_slowdown = 2                       // 蓄力时减速（专注引导锋刃）
	chargedloop = /datum/looping_sound/invokegen // 蓄力期间循环施法音效
	associated_skill = /datum/skill/magic/arcane // 伤害缩放所依据的技能：奥术
	gesture_required = TRUE                      // 需要能自由活动的手来挥出斩击
	miracle = FALSE                              // 非奇迹（属于可学习的奥术法术）
	xp_gain = TRUE                               // 成功施放可获得奥术经验
	sound = list('sound/magic/whiteflame.ogg')   // 发射时的施法音效

// ---------------------------------------------------------------------------
// cast：蓄力满后由基类点击拦截调用。targets[1] 即施法者瞄准点中的对象/地块。
// 不限制“必须瞄准活物”：无论瞄准的是敌人、地面还是墙体，都直接朝瞄准方向发射一道
// 投射物（命中由弹道系统判定，真正的撕裂结算在命中活物时才发生）。
//
// 弧射形态选择（完全比照 arcyne_bolt）：本重写不把弧射效果写死在法术/投射物上，而是
// 依据施法者“当前手持意图”动态切换弹种——
//   - 切到“弧射意图”（/datum/intent/special/magicarc，需法师杖/法术书等可弧射武器）时，
//     发射带 arcshot 的弧射版投射物（越过盟友头顶）；
//   - 否则发射不弧射的标准版投射物（直线飞行）。
// 选好弹种后交由投射物基类 /projectile/cast 完成发射、命中与进入冷却。
// 返回值约定：
//   - TRUE  -> 基类发射投射物并 start_recharge()，进入冷却。
//   - FALSE -> revert_cast() 退还冷却（优雅取消，避免空耗冷却）。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/projectile/sectumsempra/cast(list/targets, mob/living/user = usr)
	// 防御性校验：仅要求存在一个瞄准点（targets[1]），不再校验其是否为活物。
	if(!length(targets))
		revert_cast()
		return FALSE

	// 依据施法者当前意图选择弹种：仅人类施法者才有 a_intent，故先确认类型再读取。
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/datum/intent/active_intent = human_user.a_intent
		// 处于“弧射意图”时改用弧射版投射物（越过盟友头顶的抛物线弹道）。
		if(istype(active_intent, /datum/intent/special/magicarc))
			projectile_type = /obj/projectile/energy/sectumsempra_bolt/arc
		else
			// 否则使用标准直线版投射物。
			projectile_type = /obj/projectile/energy/sectumsempra_bolt
	else
		// 非人类施法者（理论上被 human_req 拦截）兜底为标准版，避免空指针。
		projectile_type = /obj/projectile/energy/sectumsempra_bolt

	// 表现层：施法者朝瞄准方向斩出无形利刃的提示（不依赖目标类型，避免对地块产生怪异文本）。
	user.visible_message(span_danger("[user] 手腕一振，一道几乎无形的锋刃朝瞄准的方向疾射而出！"))
	to_chat(user, span_notice("我将神锋无影凝作一线，朝瞄准的方向斩出。"))

	// 交由投射物基类完成发射 / 命中 / 进入冷却。
	. = ..()

// ---------------------------------------------------------------------------
// ready_projectile：基类在“准备好弹道、即将 fire() 之前”对每枚投射物调用的钩子。
// 在这里按施法者奥术造诣动态调高投射物伤害（造诣越高、刃越利），并把施法者的
// 奥术等级写入投射物，供命中后判断是否斩断受击肢体。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/projectile/sectumsempra/ready_projectile(obj/projectile/P, atom/target, mob/user, iteration)
	// 仅处理本法术的专属投射物；类型不符则直接返回，避免误改其它弹种。
	var/obj/projectile/energy/sectumsempra_bolt/bolt = P
	if(!istype(bolt))
		return

	// 取奥术等级并钳到非负，未入门按 0 级处理，避免负数导致伤害异常。
	var/arcane_level = max(user?.get_skill_level(associated_skill), 0)
	// 受击部位伤害 = （基础撕裂伤害 + 等级 * 每级加成）* 弧射伤害系数。
	// 标准版系数为 1（满伤害）；弧射版系数 < 1（少造成伤害），实现两种弹道的差异化平衡。
	bolt.damage = round((SECTUM_BASE_LACERATION + (arcane_level * SECTUM_LACERATION_PER_LVL)) * bolt.arc_damage_mult)
	// 记录施法者奥术等级，供命中后的“恐怖撕裂创 / 斩肢”逻辑使用。
	bolt.caster_arcane_level = arcane_level

// ===========================================================================
// 投射物：无形锋刃（Sectumsempra Bolt）
// ---------------------------------------------------------------------------
// 比照 arcyne_bolt 的投射物：自身带有真实 damage，命中时由弹道系统按 woundclass
// 把伤害结算到“受击部位”。woundclass 取 BCLASS_CUT，使命中自然产生“撕裂/割创”，
// 满足“恐怖撕裂伤害”的核心需求。命中后再追加一道更深的撕裂创并尝试斩断该部位。
// ===========================================================================
/obj/projectile/energy/sectumsempra_bolt
	name = "无形锋刃"                          // 投射物名（中文）
	icon = 'modular_z121/icon/projectiles.dmi'  // 使用本法术专属的贴图资源（modular_z121 内的自定义图集）
	icon_state = "sectumsempra"                 // 该图集中唯一的贴图态：神锋无影专属弹道贴图
	damage = SECTUM_BASE_LACERATION             // 默认受击伤害（实际伤害会在 ready_projectile 内按造诣覆盖）
	damage_type = BRUTE                         // 物理类伤害
	woundclass = BCLASS_CUT                     // 以“割裂”方式结算伤害——命中即在受击部位造成撕裂创
	nodamage = FALSE                            // 由弹道系统正常结算伤害到受击部位（与 arcyne_bolt 一致）
	speed = 0.6                                 // 飞行速度（比普通弹更快，体现“疾如闪电”的锋锐）
	// 注意：标准版不设 arcshot（直线飞行）。弧射效果由独立的 /arc 子型承载，由法术按意图择一发射。
	muzzle_type = null                          // 不显示枪口特效（无形）
	impact_type = null                          // 不显示命中特效（命中观感由消息/音效负责）
	hitsound = 'sound/combat/hits/bladed/genchop (1).ogg' // 命中音：刃器劈砍声
	// 命中时由 ready_projectile 写入的施法者奥术等级，用于判断是否斩断受击肢体。
	var/caster_arcane_level = 0
	// 弧射伤害系数：标准版为 1（不减伤）。弧射版会下调此值，体现“越过盟友头顶”换取的代价
	//（与 arcyne_bolt 的弧射形态少造成伤害的设计一致）。在 ready_projectile 内乘算到最终伤害。
	var/arc_damage_mult = 1

// ---------------------------------------------------------------------------
// 弧射版投射物（独立子型，承载 arcshot 效果）：
// 与主线 /obj/projectile/energy/arcynebolt/arc 同理——把弧射效果做成单独的弹种，
// 而不是写死在法术或标准弹上。法术在 cast() 中按“弧射意图”择一发射本子型。
// ---------------------------------------------------------------------------
/obj/projectile/energy/sectumsempra_bolt/arc
	name = "弧射·无形锋刃"                      // 弧射版投射物名（中文）
	// 弧射：划出抛物线越过沿途盟友头顶，再落向瞄准方向；间接弹道上的清醒友军可自动闪避。
	arcshot = TRUE
	// 弧射形态少造成 25% 伤害（系数 0.75），作为越障弹道的平衡代价。
	arc_damage_mult = 0.75

// on_hit：投射物命中某物时由弹道系统调用。
// 返回值遵循主线投射物接口：BULLET_ACT_BLOCK 表示被挡下，BULLET_ACT_HIT 表示有效命中。
/obj/projectile/energy/sectumsempra_bolt/on_hit(atom/target, blocked = FALSE)
	// 只对活物结算斩击；命中墙体/物件等非生物时走父级默认逻辑（直接消失）。
	if(!isliving(target))
		return ..()

	var/mob/living/living_target = target
	// 命中被完全格挡（blocked == 100）时不结算伤害，交回父级处理。
	if(blocked == 100)
		return ..()

	// 反魔法检定（先于伤害结算）：被反魔法保护的目标会让这道锋刃凭空溃散，施法失败。
	if(living_target.anti_magic_check())
		visible_message(span_warning("[src] 在触及 [living_target] 的刹那化作一缕碎光，被反魔法尽数驱散了！"))
		playsound(get_turf(living_target), 'sound/magic/magic_nulled.ogg', 100)
		return BULLET_ACT_BLOCK

	// 先执行父级命中流程：弹道系统据 damage / woundclass / def_zone 把撕裂伤害结算到“受击部位”。
	. = ..()
	if(. == BULLET_ACT_BLOCK)
		return .

	// 命中表现：受击部位骤然迸裂、鲜血飞溅，强化“恐怖撕裂”的临场感。
	living_target.visible_message(
		span_danger("[living_target] 被一道无形利刃掠过，受击之处骤然绽开一道深可见骨的恐怖裂创，鲜血激涌而出！"),
		span_userdanger("一道看不见的锋刃精准割开了我的身体，受创处传来撕心裂肺的剧痛与汹涌的鲜血！")
	)

	// 把“恐怖撕裂创 + 斩肢”集中追加到受击部位（不再波及全身）。
	apply_concentrated_laceration(living_target)
	return .

// ---------------------------------------------------------------------------
// apply_concentrated_laceration：把额外的恐怖撕裂创集中施加到“受击部位”。
// 通过 src.def_zone 取得弹道系统判定的受击部位，仅在该处追加深长撕裂创，
// 并在施法者造诣足够时尝试将该受击肢体整个斩落，体现“一击致命”。
// ---------------------------------------------------------------------------
/obj/projectile/energy/sectumsempra_bolt/proc/apply_concentrated_laceration(mob/living/target)
	// 目标无敌（GODMODE）时不再追加任何效果，直接返回。
	if(target.status_flags & GODMODE)
		return

	// 类人 carbon 目标：把撕裂创集中到“受击肢体”上。
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		// 取受击部位对应的肢体；def_zone 即弹道系统判定/施法者瞄准的部位（未被强制锁死）。
		var/obj/item/bodypart/hit_part = carbon_target.get_bodypart(check_zone(def_zone))
		// 受击肢体已不存在（极端情况，例如刚被打掉）时无法追加局部创伤，安全返回。
		if(!hit_part)
			return
		// 在受击肢体上追加一道“可怖割伤”（高流血、深创），由主线伤口系统接管出血/缝合等后续。
		hit_part.add_wound(/datum/wound/slash/large, TRUE)
		// 高造诣斩肢：奥术等级达到阈值时，尝试把“受击的这一处肢体”整个斩落。
		try_dismember_hit_part(carbon_target, hit_part)
		return

	// 拥有“简易伤口系统”的非类人生物：追加一道等效的简易割伤（无独立肢体可结算）。
	if(HAS_TRAIT(target, TRAIT_SIMPLE_WOUNDS))
		target.simple_add_wound(/datum/wound/slash/large, TRUE)
		return

	// 兜底：其余活物（无肢体/无伤口系统）已由父级 ..() 结算过受击伤害，这里无需再处理。

// ---------------------------------------------------------------------------
// try_dismember_hit_part：在满足条件时把“受击的这一处肢体”整个斩落。
// 仅在施法者奥术等级达到阈值、且目标未受“防断肢”保护时触发；
// 调用主线 bodypart.dismember()，由其内部处理护甲、断肢音效与残肢生成。
// ---------------------------------------------------------------------------
/obj/projectile/energy/sectumsempra_bolt/proc/try_dismember_hit_part(mob/living/carbon/target, obj/item/bodypart/part)
	// 受击肢体已失效则无需斩断。
	if(QDELETED(part))
		return FALSE
	// 造诣不足（低于阈值等级）时不触发斩肢，保留给高阶施法者的强力收割。
	if(caster_arcane_level < SECTUM_DISMEMBER_LEVEL)
		return FALSE
	// 目标带有“不可断肢”特性时跳过（尊重主线的免疫设计）。
	if(HAS_TRAIT(target, TRAIT_NODISMEMBER))
		return FALSE

	// 以割裂类型（BCLASS_CUT）请求斩断受击肢体；护甲/部位限制由 dismember 内部判定。
	// 传入本投射物伤害作为破甲参考，并以发射者（施法者）作为 user 归因。
	var/mob/living/caster = firer
	if(part.dismember(BRUTE, BCLASS_CUT, caster, part.body_zone, damage))
		// 斩落成功时的额外表现，凸显“无形利刃齐根斩断受击部位”的恐怖。
		target.visible_message(
			span_danger("那道无形的锋刃去势不止，竟将 [target] 的[part.name]自受创处齐根斩落！"),
			span_userdanger("我甚至来不及惨叫——那道看不见的利刃已将我的[part.name]整个削断！")
		)
		return TRUE
	return FALSE

// ===== 清理顶部定义的宏，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef SECTUM_MANA_COST
#undef SECTUM_RESOURCE_COST
#undef SECTUM_CHANNEL_TIME
#undef SECTUM_COOLDOWN
#undef SECTUM_TARGET_RANGE
#undef SECTUM_BASE_LACERATION
#undef SECTUM_LACERATION_PER_LVL
#undef SECTUM_DISMEMBER_LEVEL
