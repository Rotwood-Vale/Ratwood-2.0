// modular_z121 自定义奥术法术：视觉共享（Visual Sharing）
// ---------------------------------------------------------------------------
// 设计目标：一个 T2 实用 / 羁绊法术。
//   施法者吟唱咒文 -> do_after 引导 3 秒 -> 弹窗从 7 格内选择一名目标 ->
//   目标会收到“是否接受”的弹窗 -> 接受后，双方在 3 分钟内共享视觉：
//   双方各获得一道“临时法术”，可在“自己的视角”与“对方的视角”之间随时切换。
//   切换到对方视角时，是“真·借眼视物”——明暗远近、夜视、可见隐形、方向性视野盲区
//   乃至失明的临时绕过，都与对方完全一致，而非仅仅把镜头挪到对方身上。
//
// 选取 / 引导方式：沿用 wish_spell.dm 的 /spell/self 引导式做法——点击图标后只对
//   “自己”发起 3 秒 do_after 引导，引导成功后再弹窗选目标、再询问目标是否同意。
//   这样最契合“先吟唱、再选人、对方需同意”的流程，且天然支持中途取消。
//
// 约束：本法术的全部代码都只存在于 modular_z121 内，仅“调用”主线系统现有的接口
//   （reset_perspective / update_remote_sight / update_cone_show / mind.AddSpell 等），
//   不修改 modular_z121 之外的任何文件。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
//   （沿用既有类型路径 /obj/effect/proc_holder/spell/self/sensory_sharing，
//     故仅改“显示名”为“视觉共享”，无需改动上述两处注册。）
// ---------------------------------------------------------------------------

// ===== 可调参数集中定义（文件末尾统一 #undef，避免污染全局命名空间）=====
// 之所以用 #define 把这些“数值旋钮”集中放在顶部，是为了平衡性调整一目了然，
// 不必在长长的过程代码里到处翻找魔法数字。
#define SENSORY_MANA_COST     3              // “法力 / 法术点”消耗（cost）= 3
#define SENSORY_CHANNEL_TIME  (3 SECONDS)    // 引导 / 蓄力时长（do_after）= 3 秒
#define SENSORY_RESOURCE_COST 5              // “额外资源消耗”：每次施放抽取的疲劳/耐力（releasedrain）= 5
#define SENSORY_DURATION      (3 MINUTES)    // 视觉共享效果持续时间 = 3 分钟
#define SENSORY_COOLDOWN      (3 MINUTES)    // 成功施放后的冷却 = 3 分钟
#define SENSORY_TARGET_RANGE  7              // 选取目标的最大距离 = 7 格

// 目标对“是否接受共享”弹窗的应答超时（毫秒级游戏刻）。超时未点则视为拒绝，
// 避免目标挂机时施法者被无限期卡住。
#define SENSORY_PROMPT_TIMEOUT (20 SECONDS)

// ===========================================================================
// 在 /mob/living 上挂一个“当前所属视觉共享链接”的引用。
// 之所以放在 /mob/living 上（而非仅 human），是为了让视角切换法术、各视觉覆写
// 都能从任意一方的 mob 快速反查到链接 datum，并避免一名 mob 同时存在多条链接。
// （这是在 modular_z121 内对主线类型的“追加变量”，不修改外部文件。）
// ===========================================================================
/mob/living
	// 指向该 mob 当前参与的视觉共享链接；为空表示当前没有任何共享。
	var/datum/sensory_share_link/sensory_share_link_custom

// ===========================================================================
// 视觉共享链接 datum：承载“两名 mob 之间”的视觉共享状态与生命周期。
// 把状态集中在一个 datum 里，便于在到期 / 一方失效时一次性干净清理，
// 避免临时法术、视角覆写、视野锥等残留。
// ===========================================================================
/datum/sensory_share_link
	var/mob/living/user_a          // 链接的一方（通常是施法者）
	var/mob/living/user_b          // 链接的另一方（被选中并同意的目标）
	var/active = FALSE             // 链接是否仍然有效（防止清理过程中重入）
	var/expire_timer_id            // 到期定时器 id，便于一方提前失效时清掉它

// New：建立链接。授予双方“切换视角”的临时法术，并启动视野锥同步轮询。
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
	// 反向引用：让双方都能 O(1) 反查到本链接（视角切换法术、各视觉覆写都依赖它）。
	user_a.sensory_share_link_custom = src
	user_b.sensory_share_link_custom = src
	// 视觉共享：给双方各授予一个“切换视角”的临时法术（见文件末尾的 view 法术）。
	grant_view_spell(user_a)
	grant_view_spell(user_b)
	// 启动轻量轮询：当某一方正“借用对方的眼睛”时，需要持续把其视野锥朝向同步到对方的当前朝向，
	// 否则对方转身后，借眼者看到的视野锥仍停在旧方向。用 SSfastprocess 每刻校正一次即可（见 process）。
	START_PROCESSING(SSfastprocess, src)

// Destroy：链接销毁时，必须把一切“加上去的东西”对称地撤销干净。
/datum/sensory_share_link/Destroy()
	active = FALSE
	// 先停掉轮询，避免清理过程中 process 再访问已半拆解的链接。
	STOP_PROCESSING(SSfastprocess, src)
	// 收回临时法术、复原视角/视野/失明，缺一不可，否则会留下幽灵效果。
	cleanup_member(user_a)
	cleanup_member(user_b)
	user_a = null
	user_b = null
	return ..()

// process：每个处理刻被 SSfastprocess 调用一次。
// 唯一职责：为“当前正借用对方眼睛”的成员，把其视野锥持续校正到对方的最新朝向（需跟手）。
/datum/sensory_share_link/process()
	if(!active)
		return
	sync_borrowed_cone(user_a)
	sync_borrowed_cone(user_b)

// sync_borrowed_cone：若 viewer 此刻正透过 partner 的眼睛观看，则刷新其视野锥，
// 使锥体朝向 / 形状跟随 partner 的当前状态（具体改写见 /mob/living/carbon 的 update_vision_cone 覆写）。
/datum/sensory_share_link/proc/sync_borrowed_cone(mob/living/viewer)
	if(!viewer || QDELETED(viewer) || !viewer.client)
		return
	var/mob/living/partner = get_partner(viewer)
	if(!partner || QDELETED(partner))
		return
	// client.eye 指向 partner 才说明“正在借眼”；否则该成员看的是自己，无需处理。
	if(viewer.client.eye != partner)
		return
	// 确保锥体保持显示（show_cone 内部有 cone_showing 短路，已显示时几乎零开销）。
	viewer.update_cone_show()
	// 性能优化：仅当对方“转了向”（锥体朝向需要变化）时才做较重的锥体重算，
	// 对方原地不动的每一刻都直接跳过，避免无谓地反复重建遮挡图像。
	if(viewer.hud_used && viewer.hud_used.fov && viewer.hud_used.fov.dir == partner.dir)
		return
	viewer.update_vision_cone()

// cleanup_member：与 New 对称地清理单个成员的全部痕迹。
/datum/sensory_share_link/proc/cleanup_member(mob/living/member)
	if(!member)
		return
	if(!QDELETED(member))
		// 复原视角：若成员此刻正透过对方的眼睛观看，必须拉回自己，避免“黑屏/卡视角”。
		member.reset_perspective(null)
		// 关键：链接结束时若成员正“借眼视物”，光是拉回镜头还不够，必须重算视觉，
		// 否则之前被远程接管的 sight/see_in_dark/lighting_alpha 会残留，造成视觉异常。
		member.update_sight()
		// 同步复原视野锥：先 update_cone_show() 决定是否显示，再 update_vision_cone() 把朝向
		// 校正回成员自己的 dir，确保链接结束后本人的方向性视野立刻、完整地恢复正常。
		member.update_cone_show()
		member.update_vision_cone()
		// 复原失明状态：链接结束后，若成员本就失明（借眼期间被暂时绕过），此刻应立即重新盖回黑幕。
		member.update_blindness()
	// 解除反向引用（仅当它确实指向本链接时才清，避免误删别人的链接）。
	if(member.sensory_share_link_custom == src)
		member.sensory_share_link_custom = null
	// 收回临时的“切换视角”法术。
	remove_view_spell(member)

// get_partner：给定链接中的一方，返回另一方（找不到则返回 null）。
// 视角切换与各视觉覆写都靠它来确定“要借谁的眼睛 / 把视觉投射给谁”。
/datum/sensory_share_link/proc/get_partner(mob/living/who)
	if(who == user_a)
		return user_b
	if(who == user_b)
		return user_a
	return null

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
		to_chat(user_a, span_warning("我与对方之间的视觉链接渐渐淡去，眼前重新只剩下自己的所见。"))
	if(user_b && !QDELETED(user_b))
		to_chat(user_b, span_warning("我与对方之间的视觉链接渐渐淡去，眼前重新只剩下自己的所见。"))
	qdel(src)

// ===========================================================================
// 法术本体：视觉共享
// ---------------------------------------------------------------------------
// 基类选 /spell/self：点击图标后只对“自己”发起 3 秒引导，引导成功后再弹窗选人、
// 再询问对方是否同意。符合“先吟唱蓄力 -> 选目标 -> 对方需弹窗同意”的流程。
// ===========================================================================
/obj/effect/proc_holder/spell/self/sensory_sharing
	name = "视觉共享"
	desc = "一道奇妙的法术，借魔力将两人的视觉彼此相连——可随时切换，透过对方的双眼观察世界。"
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
	invocations = list("以我之眼，见你所见！") // 咒文（“释放需要相应台词”，开始引导时喊出）
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

	// “释放时”念出咒文，因此这里手动调用一次 invocation()。
	// （稍后在 perform() 前临时屏蔽 invocation，避免咒文被重复喊两遍。）
	invocation(user)

	// 取得引导时长（= chargetime），用 do_after 实现“可被打断的 3 秒蓄力”。
	var/cast_time = get_chargetime()
	if(cast_time > 0)
		user.visible_message(
			span_warning("[user] 闭目凝神，指尖萦绕起一缕将视觉彼此牵连的魔力……"),
			span_notice("我开始引导这道视觉共享法术，只需再稳住片刻……")
		)
		// do_after：引导期间若移动被打断/死亡会返回 FALSE。progress 显示进度条，target=user 表自身引导。
		if(!do_after(user, cast_time, target = user, progress = TRUE))
			to_chat(user, span_warning("我对视觉魔力的牵引被打断了，链接未能成形。"))
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

	// 同一时刻只允许参与一条视觉链接，避免多链接互相干扰。
	if(user.sensory_share_link_custom)
		to_chat(user, span_warning("我已身处一段视觉链接之中，无法再开启新的链接。"))
		revert_cast(user)
		return FALSE

	// —— 步骤 1：收集 7 格视野内、存活、且非自身的活体作为候选目标 ——
	var/list/candidates = list()
	for(var/mob/living/L in view(SENSORY_TARGET_RANGE, user))
		if(L == user)            // 不能和自己共享视觉
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
		to_chat(user, span_warning("我的视野之内没有可以建立视觉链接的对象。"))
		revert_cast(user)
		return FALSE

	// 弹窗让施法者选择目标；可取消（返回 null）。
	var/chosen_label = tgui_input_list(user, "选择要与之共享视觉的对象：", "视觉共享", candidates)
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
		to_chat(user, span_warning("[target] 身上的反魔法挡下了视觉链接的魔力。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		revert_cast(user)
		return FALSE

	// —— 步骤 2：询问目标是否接受 ——
	// 提示施法者正在等待对方答复，避免其以为法术卡住。
	to_chat(user, span_notice("我向 [target] 发出了视觉链接的邀请，正在等待 [target.p_their()] 答复……"))
	// 目标侧弹窗：接受 / 拒绝；超时未答（SENSORY_PROMPT_TIMEOUT）则视为拒绝。
	var/response = tgui_alert(target, "[user.name] 想要与你共享视觉（可切换至彼此视角观察），持续约 3 分钟。是否接受？", "视觉共享邀请", list("接受", "拒绝"), timeout = SENSORY_PROMPT_TIMEOUT)
	if(response != "接受")
		to_chat(user, span_warning("[target] 拒绝了（或未能及时回应）这次视觉链接。"))
		to_chat(target, span_notice("我婉拒了这次视觉链接。"))
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

	// 建立链接 datum（构造函数内部完成视角法术授予、反向引用挂载与轮询启动）。
	var/datum/sensory_share_link/link = new(user, target)
	// 极端兜底：若构造函数因校验失败而自毁，则视为施法失败并退款。
	if(QDELETED(link) || !link.active)
		to_chat(user, span_warning("视觉链接在最后一刻没能稳定成形。"))
		revert_cast(user)
		return FALSE

	// 安排 3 分钟后自动到期。把 timer id 记到 link 上，便于一方提前失效时清掉它。
	link.expire_timer_id = addtimer(CALLBACK(link, TYPE_PROC_REF(/datum/sensory_share_link, expire)), SENSORY_DURATION, TIMER_STOPPABLE)

	// 表现层：成功反馈与音效。
	playsound(get_turf(user), 'sound/magic/whiteflame.ogg', 60, TRUE)
	user.visible_message(
		span_notice("[user] 与 [target] 之间似有一缕无形的丝线悄然连起。"),
		span_green("我与 [target] 的视觉彼此相连——自此短暂之间，我可透过 [target.p_their()] 双眼观察世界。")
	)
	to_chat(target, span_green("我与 [user] 的视觉彼此相连——自此短暂之间，我可透过 [user] 的双眼观察世界。"))
	// 告知双方：可在动作栏使用新出现的“视角切换”法术切换到对方视角。
	to_chat(user, span_info("动作栏中新增了『视角切换』，可借此切换到对方的视角观察世界。"))
	to_chat(target, span_info("动作栏中新增了『视角切换』，可借此切换到对方的视角观察世界。"))
	return TRUE

// validate_target：建立链接前对“目标是否仍可被链接”的统一校验，避免逻辑分散重复。
// 校验项：存在、非自身、存活、仍在 7 格视野内、且尚未被卷入其他链接。
/obj/effect/proc_holder/spell/self/sensory_sharing/proc/validate_target(mob/living/user, mob/living/target)
	if(QDELETED(target) || !istype(target))
		to_chat(user, span_warning("链接的对象已经不在了。"))
		return FALSE
	if(target == user)
		to_chat(user, span_warning("我无法和自己建立视觉链接。"))
		return FALSE
	if(target.stat == DEAD)
		to_chat(user, span_warning("逝者无法参与视觉共享。"))
		return FALSE
	// 距离校验：必须仍处在 7 格视野内（用 view 同时满足“可见 + 距离”两个条件）。
	if(!(target in view(SENSORY_TARGET_RANGE, user)))
		to_chat(user, span_warning("[target] 已经离开了我的感知范围。"))
		return FALSE
	if(target.sensory_share_link_custom)
		to_chat(user, span_warning("[target] 已经身处另一段视觉链接之中。"))
		return FALSE
	return TRUE

// ===========================================================================
// 真·借眼视物：覆写 /mob/living/update_remote_sight。
// ---------------------------------------------------------------------------
// 这是“真正看到对方所见”的关键。主线的 carbon/simple_animal 在 update_sight() 中，
// 当 client.eye 不是自己时会调用 `client.eye.update_remote_sight(观看者)`，若其返回
// TRUE，则“接管观看者的全部视觉参数”。我们正是借此把【被观看方(src)】的真实视觉
// （夜视距离 see_in_dark、视觉标志 sight、可见隐形 see_invisible、亮度敏感 lighting_alpha）
// 原样赋给【观看者(user)】，从而获得一份“有血有肉、与对方一致”的视角，而非仅仅把镜头
// 挪到对方身上、却仍用自己的眼睛去看（那会出现“对方在暗处看得见、我却一片漆黑”的割裂感）。
//
// 作用域控制：本覆写只在“src 正处于一段有效视觉链接、且观看者正是链接另一方”时才接管；
// 其它任何远程观看（摄像头、附身等）一律 return ..() 走原版逻辑，绝不影响链接之外的行为。
// ===========================================================================
/mob/living/update_remote_sight(mob/living/user)
	// 取出 src（被观看方）当前所属的视觉链接；没有链接就完全交还给原版逻辑。
	var/datum/sensory_share_link/link = sensory_share_link_custom
	if(!link || !link.active)
		return ..()
	// 仅当“观看者恰是本链接的另一方”时才接管；否则不是我们该管的远程观看。
	if(link.get_partner(user) != src)
		return ..()
	// 把被观看方(src)的真实视觉参数整套复制给观看者(user)，实现“看到对方之所见”。
	user.sight = sight                       // 视觉标志（透视墙体/看穿生物等能力）
	user.see_in_dark = see_in_dark           // 夜视距离（决定黑暗中能看多远）
	user.see_invisible = see_invisible       // 可见隐形等级（能否看见隐身/灵体等）
	user.lighting_alpha = lighting_alpha      // 亮度平面透明度（黑暗的呈现强度）
	user.sync_lighting_plane_alpha()          // 立即把上面的 lighting_alpha 应用到光照平面
	// 返回 TRUE：告诉观看者的 update_sight() “视觉已被远程接管”，跳过其自身的视觉重算。
	return TRUE

// ===========================================================================
// 复刻“对方的视野锥”：覆写 /mob/living/carbon 的 update_cone_show / update_vision_cone。
// ---------------------------------------------------------------------------
// 需求：借眼观看时，不要给一个“环视四周”的上帝视角，而要原样复刻对方的方向性视野锥
//       ——对方朝哪看、视野盲区在哪，借眼者就一模一样地受限。
//
// 原理：主线视野锥本质是一层屏幕空间遮罩，其“朝向”取自 hud_used.fov(_blocker).dir，
//       由 update_vision_cone() 设定（dullahan 借“分离的头”远程观看时，正是把 dir 设成
//       远端身体的朝向——见 vision_cone.dm 第 80-90 行，本实现沿用同一思路）。
//       而“是否显示锥体”由 update_cone_show() 决定，原版在 client.eye≠自己时会强制隐藏。
//
// 为何覆写在 /mob/living/carbon 而非 /mob/living：主线已在 /mob/living 定义了
//       update_vision_cone()，无法再重复定义；在更具体的 /mob/living/carbon 上覆写既能
//       拦截人类（视野锥本就是为带客户端的人类设计），其 ..() 又能回落到 /mob/living 原版。
//
// 作用域控制：仅当“自己正借用视觉链接对方的眼睛（client.eye==对方）”时才改写；
//       其它所有情况一律 return ..()，绝不影响链接之外（含 dullahan）的原有视野锥行为。
// ===========================================================================

// 小工具：判断 src 此刻是否正“借用某位视觉链接对方的眼睛”，是则返回那位对方，否则返回 null。
/mob/living/proc/sensory_borrowed_eye_partner()
	var/datum/sensory_share_link/link = sensory_share_link_custom
	if(!link || !link.active || !client || !client.eye || client.eye == src)
		return null
	var/mob/living/partner = link.get_partner(src)
	// client.eye 必须正好指向链接对方，才算“借其眼睛”。
	if(partner && client.eye == partner)
		return partner
	return null

// update_cone_show 覆写：借眼时强制“显示锥体”（这样才能呈现对方的方向性视野），
// 而不是走原版“client.eye≠自己 -> 隐藏锥体”的分支（那会变成无锥的环视视角）。
/mob/living/carbon/update_cone_show()
	if(sensory_borrowed_eye_partner())
		return show_cone()
	return ..()

// update_vision_cone 覆写：借眼时，把自己的视野锥朝向 / 形状同步成对方的，
// 使“盲区方向”与对方完全一致；非借眼情况回落原版（含 dullahan 分支）。
/mob/living/carbon/update_vision_cone()
	var/mob/living/partner = sensory_borrowed_eye_partner()
	if(!partner)
		return ..()
	if(client && hud_used && hud_used.fov)
		// 朝向跟随对方当前 dir：对方一转身，借眼者的视野盲区随之转向。
		hud_used.fov.dir = partner.dir
		hud_used.fov_blocker.dir = partner.dir
		// 形状（icon_state）尽量复刻对方：对方若因眼伤/独眼而视野更窄，借眼者也照样受限。
		if(partner.hud_used && partner.hud_used.fov)
			hud_used.fov.icon_state = partner.hud_used.fov.icon_state
			hud_used.fov_blocker.icon_state = partner.hud_used.fov_blocker.icon_state
		else
			// 对方没有可用的锥体 HUD（如无客户端的 NPC）时，退化为标准战斗视野锥兜底。
			hud_used.fov.icon_state = "combat"
			hud_used.fov_blocker.icon_state = "combat_v"
		// 触发 SSincone 做一次锥体遮挡的图像刷新（与原版同样的收尾步骤）。
		START_PROCESSING(SSincone, client)

// ===========================================================================
// 失明者借眼复明：覆写 /mob/living/update_blindness。
// ---------------------------------------------------------------------------
// 背景：主线的“失明”并不是靠视觉变量实现，而是往客户端屏幕盖一层全屏黑幕
//       （overlay_fullscreen("blind", ...)，见 status_procs.dm）。这层黑幕独立于
//       client.eye —— 即便我们把镜头挪到了对方身上、并用 update_remote_sight 把对方的
//       视觉参数套到了失明者身上，只要这层黑幕还在，失明者依旧只看得见一片漆黑。
//
// 需求（已与使用者确认）：视觉共享既然把“视觉”整套相连，失明者在借用对方眼睛期间
//       应当能真正看见对方之所见——即魔法暂时绕过其自身的失明。
//
// 做法：当 src 正借用视觉链接对方的眼睛时，本覆写改为“清除失明黑幕”，让借来的画面得以显示；
//       其余任何情况一律 return ..() 走原版逻辑（该失明仍失明）。一旦切回自身视角或链接结束，
//       只要再调用一次 update_blindness()（切换/清理流程里都会调用），原版逻辑就会按其真实状态
//       重新盖回黑幕，失明立刻恢复——魔法绕过仅在“正借眼”的那段时间内有效。
//
// 作用域：只在“正借眼”时才接管，绝不影响链接之外的任何失明判定。
// ===========================================================================
/mob/living/update_blindness()
	// 正在借用对方的眼睛 -> 清除本人的失明全屏黑幕，使借来的画面可见。
	if(sensory_borrowed_eye_partner())
		clear_fullscreen("blind")
		return
	// 其它情况：交还原版逻辑，由其依据 TRAIT_BLIND / eye_blind / stat 决定是否盖回黑幕。
	return ..()

// ===========================================================================
// 临时法术：视角切换
// ---------------------------------------------------------------------------
// 由链接 datum 在建立时授予双方、在结束时收回。作用：在“自己的视角”与
// “对方的视角”之间来回切换，落实“视觉共享提供一个可切换视角的临时法术”。
// 实现复用主线 reset_perspective：传入对方 mob 即把 client.eye 设为对方，
// 传入 null 即恢复到自身视角；不转移控制权，仅改变“看到的画面”。
// ===========================================================================
/obj/effect/proc_holder/spell/self/sensory_sharing_view
	name = "视角切换"
	desc = "在自己与视觉链接对象的视角之间切换观察。"
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
		to_chat(user, span_warning("视觉链接已经消散，我无法再借由它窥见他人的视角。"))
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
		// 切回自身后立即重算视觉：client.eye==自己时，carbon/simple_animal 的 update_sight()
		// 会跳过 update_remote_sight，转而依据自身器官/装备复原本人视觉，撤销之前的“借眼”。
		user.update_sight()
		// 立即复原视野锥：回到自身视角后应恢复本人的方向性视野锥（否则要等下次转向才更新）。
		// 先 update_cone_show()（此时不再借眼，会回落原版逻辑重新显示自己的锥体），
		// 再 update_vision_cone() 把锥体朝向校正回自己的 dir。
		user.update_cone_show()
		user.update_vision_cone()
		// 复原失明状态：此时已不再借眼，原版 update_blindness 会按本人真实状态决定是否盖回黑幕，
		// 失明者切回自身后将立刻重新失明（魔法绕过仅在借眼期间有效）。
		user.update_blindness()
		to_chat(user, span_notice("我的视野回到了自己的双眼。"))
	else
		user.reset_perspective(partner) // 把 client.eye 设为对方，借其双眼观察
		// 切到对方后立即重算视觉：此时 client.eye==partner，update_sight() 会调用
		// partner.update_remote_sight(user)（即上面的覆写），把对方的真实视觉套到我身上。
		user.update_sight()
		// 立即让“借来的视野锥”生效：update_cone_show() 借眼时会强制显示锥体，
		// update_vision_cone() 则把锥体朝向 / 形状同步成对方的——于是连视野盲区都与对方一致。
		user.update_cone_show()
		user.update_vision_cone()
		// 失明者借眼复明：清除本人的失明黑幕，使借来的画面得以显示（详见 update_blindness 覆写）。
		user.update_blindness()
		to_chat(user, span_notice("我的视野顺着视觉链接切换到对方身上——所见、明暗、乃至朝向盲区，皆与对方一致。"))
	return TRUE

// ===== 清理顶部定义的宏，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef SENSORY_MANA_COST
#undef SENSORY_CHANNEL_TIME
#undef SENSORY_RESOURCE_COST
#undef SENSORY_DURATION
#undef SENSORY_COOLDOWN
#undef SENSORY_TARGET_RANGE
#undef SENSORY_PROMPT_TIMEOUT
