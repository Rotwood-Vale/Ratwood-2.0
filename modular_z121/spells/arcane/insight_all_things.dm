// modular_z121 自定义奥术法术：洞悉万物（Insight into All Things）
// ---------------------------------------------------------------------------
// 设计目标：一个 T2 实用法术。激活法术 -> 框架蓄力 3 秒 -> 点击选定一名目标
//           （点自己或点他人）-> 目标获得 360° 全方位视野。
//           视野持续时间由“施法者”的奥术技能等级按规格表缩放。
//
// 选取/蓄力方式：完全沿用 flight.dm 的做法——以 /spell/invoked 为基类，靠点击
//           选取目标（targets[1]），蓄力由基类 InterceptClickOn 依据 chargetime
//           校验完成；不使用弹窗，也不使用 do_after。
//
// 约束：所有代码都只存在于 modular_z121 内，仅“调用”主线视野系统的现有机制
//       （human.viewcone_override / hide_cone() / update_cone_show()），
//       不修改 modular_z121 之外的任何文件。该机制已被主线 astrata_gaze 法术
//       验证可用，这里完全复用同一套干净的开/关接口。
//
// 注册方式（均在 modular_z121 内）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数（文件末尾统一 #undef，避免污染全局命名空间）=====
#define INSIGHT_MANA_COST     3             // 法力 / 法术点消耗（cost）
#define INSIGHT_CHANNEL_TIME  (3 SECONDS)   // 蓄力时长（由 invoked 基类的点击拦截按 chargetime 校验）
#define INSIGHT_COOLDOWN      (30 SECONDS)  // 成功施放后的冷却（30 秒）
#define INSIGHT_RESOURCE_COST 10            // “额外资源消耗”：每次施放抽取的疲劳/耐力（releasedrain）
#define INSIGHT_TARGET_RANGE  7             // 点击选取目标的最大距离（range）

// ===========================================================================
// 法术本体
// ---------------------------------------------------------------------------
// 选用 /spell/invoked 作为基类（与 flight.dm 一致）：点击图标后进入“点选目标”模式，
// 蓄力满后点击某个生物即对其生效；点自己即作用于自身，点他人即作用于他人。
// 这样既能“对自己或他人施放”，又不需要弹窗或 do_after。
// ===========================================================================
/obj/effect/proc_holder/spell/invoked/insight_all_things
	name = "洞悉万物"
	desc = "一道实用法术，借由魔力让目标对四周环境了如指掌——任何踏出门去的冒险者都不可或缺的本领。"
	school = "transmutation"
	spell_tier = 2                          // T2 法术
	cost = INSIGHT_MANA_COST                // “法力 / 法术点”消耗 = 3
	releasedrain = INSIGHT_RESOURCE_COST    // “额外资源消耗”= 10（施法时抽取的疲劳/耐力）
	chargetime = INSIGHT_CHANNEL_TIME       // 蓄力 3 秒（基类点击拦截会校验是否蓄满）
	recharge_time = INSIGHT_COOLDOWN        // 冷却 = 30 秒（由 charge_check 强制执行）
	cooldown_min = INSIGHT_COOLDOWN         // 即便被“加速”，冷却也不会低于 30 秒
	human_req = TRUE                        // 只有人类施法者能施放
	warnie = "spellwarning"
	action_icon = 'modular_z121/icon/custompell.dmi'
	overlay_state = "insight"               // 动作按钮图标态（若 dmi 暂无该态仅显示为空，不影响编译）
	invocations = list("为我展示世界的真实!") // 咒文（成功施放时由框架喊出）
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	no_early_release = TRUE                  // 未蓄满不允许提前释放
	movement_interrupt = FALSE              // 与 flight.dm 一致：蓄力期间可移动
	charging_slowdown = 1                   // 蓄力时略微减速
	chargedloop = /datum/looping_sound/invokegen // 蓄力期间循环施法音效
	associated_skill = /datum/skill/magic/arcane // 时长缩放所依据的技能：奥术
	gesture_required = TRUE                  // 需要能自由活动的手
	range = INSIGHT_TARGET_RANGE            // 点选目标的最大距离
	miracle = FALSE
	xp_gain = TRUE
	sound = null                            // 蓄力音由 chargedloop 负责；命中音效在 cast 内单独播放

// ---------------------------------------------------------------------------
// 时长缩放表：根据“施法者”的奥术技能等级，返回 360° 视野的持续时间（单位：游戏刻）。
// 规格表：L1→15s，L2→45s，L3→90s，L4→180s，L5→360s，L6→720s。
// 用 clamp(1,6) 处理越界：0 级（未入门）按 1 级算，>6 级按 6 级（720s）封顶，
// 满足“超出范围时就近钳制”的要求。把它独立成一个 proc，便于单独调参与复用。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/insight_all_things/proc/get_duration_for_skill(skill_level)
	switch(clamp(skill_level, 1, 6))
		if(1)
			return 15 SECONDS
		if(2)
			return 45 SECONDS
		if(3)
			return 90 SECONDS
		if(4)
			return 180 SECONDS
		if(5)
			return 360 SECONDS
		if(6)
			return 720 SECONDS
	// 理论上 clamp 后必落入 1~6，这里仅作兜底，返回最低档时长。
	return 15 SECONDS

// ---------------------------------------------------------------------------
// cast：点击命中目标后由基类 InterceptClickOn -> perform 调用。
// targets[1] 即施法者点中的目标（点自己或点他人）。
// 返回值约定：
//   - TRUE  -> perform() 调用 start_recharge()，进入 30 秒冷却（施法成功）。
//   - FALSE -> 调用 revert_cast() 退还冷却（目标无效 / 被反魔法挡下 / 未生效）。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/invoked/insight_all_things/cast(list/targets, mob/living/user = usr)
	// 点击式选取：targets[1] 必须是活物，否则视为无效目标。
	var/atom/target_atom = targets[1]
	if(!isliving(target_atom))
		to_chat(user, span_warning("洞悉万物只能施加在活物身上。"))
		revert_cast()
		return FALSE

	var/mob/living/target = target_atom

	// 反魔法检定：被反魔法保护的目标无法接受这道增益（即便是善意的）。
	if(target.anti_magic_check())
		target.visible_message(
			span_warning("[target] 周身泛起反魔法的涟漪，将那缕感知魔力挡了下来。"),
			span_notice("一缕外来的感知魔力试图融入我，却被我身上的反魔法弹开了。")
		)
		to_chat(user, span_warning("[target] 身上的反魔法抵消了『洞悉万物』。"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		revert_cast()
		return FALSE

	// 关键：时长取决于“施法者”的奥术技能等级（不是目标的）。
	var/caster_skill = user.get_skill_level(associated_skill)
	var/effect_duration = get_duration_for_skill(caster_skill)

	// 把计算好的时长作为额外参数传给状态效果。
	// apply_status_effect(effect, custom_duration) 会把它转交给 on_creation()，
	// 由状态效果在自身被基类换算成绝对到期时间之前写入 duration。
	target.apply_status_effect(/datum/status_effect/buff/all_seeing_insight, effect_duration)

	// 防御性校验：确认效果确实挂上了，否则视为失败并退还冷却。
	if(!target.has_status_effect(/datum/status_effect/buff/all_seeing_insight))
		to_chat(user, span_warning("感知魔力未能在 [target] 身上扎根——什么也没发生。"))
		revert_cast()
		return FALSE

	// 表现层反馈。
	playsound(get_turf(target), 'sound/magic/whiteflame.ogg', 60, TRUE)
	if(target == user)
		user.visible_message(
			span_notice("[user] 睁开双眼，眸中似有奥术流光一闪——仿佛霎时间看清了身后的一切。"),
			span_green("我的感知豁然铺满四周，前后左右尽收眼底，再无半点死角！")
		)
	else
		user.visible_message(
			span_notice("[user] 朝 [target] 轻点一指，一缕奥术流光没入 [target.p_their()] 双眼。"),
			span_green("我将感知之力赋予了 [target]。")
		)
		to_chat(target, span_green("一股温和的奥术之力涌入双眼，我的感知瞬间铺满四周，前后左右尽收眼底！"))
	// 告知施法者本次时长，便于其据自身技能判断收益。
	to_chat(user, span_info("此次『洞悉万物』的持续时间为 [effect_duration / 10] 秒（取决于我的奥术造诣）。"))
	return TRUE

// ===========================================================================
// 状态效果：全方位视野（360° Vision）
// ---------------------------------------------------------------------------
// 通过主线人类 FOV（视野锥）系统实现：把 viewcone_override 置为 TRUE，
// 再调用 hide_cone() + update_cone_show()，即可彻底隐藏“视野锥遮挡”，
// 从而无视朝向、获得 360° 全向视野。on_remove 负责干净地复原。
//
// status_type 用 STATUS_EFFECT_REPLACE：当目标已拥有该效果时再次施放，
// 直接以“新算出的时长”替换旧实例，避免基类 refresh() 把时长重置回编译期默认值。
// ===========================================================================
/datum/status_effect/buff/all_seeing_insight
	id = "all_seeing_insight"
	alert_type = /atom/movable/screen/alert/status_effect/buff/all_seeing_insight
	status_type = STATUS_EFFECT_REPLACE
	// 默认/兜底时长；真正的时长会在 on_creation() 里被施法者传入的值覆盖。
	duration = 15 SECONDS

// on_creation：在基类把 duration 换算成绝对到期时间之前，先写入施法者算好的时长。
// 形参 custom_duration 来自 apply_status_effect(..., effect_duration) 的转发。
/datum/status_effect/buff/all_seeing_insight/on_creation(mob/living/new_owner, custom_duration)
	// 仅在传入了有效正值时覆盖，否则保留上面的默认时长，避免出现 0 或负的时长。
	if(custom_duration && custom_duration > 0)
		duration = custom_duration
	return ..()

// on_apply：效果挂载时开启 360° 视野。返回 FALSE 会让基类立即自删，所以成功要返回 TRUE。
/datum/status_effect/buff/all_seeing_insight/on_apply()
	. = ..() // 基类负责挂载/属性处理（本效果无 effectedstats），返回是否成功
	if(!.)
		return FALSE
	grant_full_vision() // 开启全向视野
	to_chat(owner, span_notice("我的视野不再受朝向所限——四面八方的一切都清晰可见。"))
	return TRUE

// on_remove：效果结束/被移除时，干净地关闭 360° 视野，恢复正常视野锥。
/datum/status_effect/buff/all_seeing_insight/on_remove()
	revoke_full_vision() // 先复原视野，再交给基类做其余清理
	to_chat(owner, span_warning("那份全向的清明渐渐褪去，我的视野又重新受限于朝向。"))
	return ..()

// grant_full_vision：开启全向视野的具体实现。
// 仅对人类生效——FOV 视野锥系统本就是为带客户端的人类设计的；
// 非人类（简单动物等）没有该视野锥，本就等同于全向视野，无需特殊处理。
/datum/status_effect/buff/all_seeing_insight/proc/grant_full_vision()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.viewcone_override = TRUE  // 让 update_cone_show() 始终走 hide_cone() 分支
	H.hide_cone()               // 立即隐藏当前的视野锥遮挡
	H.update_cone_show()        // 刷新一次，确保状态立刻生效

// revoke_full_vision：关闭全向视野，把目标恢复到普通的方向性视野锥。
// 与 grant_full_vision 对称，保证“有开必有关”，不会留下残留状态。
/datum/status_effect/buff/all_seeing_insight/proc/revoke_full_vision()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.viewcone_override = FALSE // 撤销强制隐藏
	H.hide_cone()               // 先隐藏，避免刷新瞬间出现闪烁
	H.update_cone_show()        // 重新评估是否显示视野锥（恢复正常方向性视野）

// 状态效果对应的状态栏图标/提示。复用主线已存在的 "astrata_gaze" 图标态
// （同为“开启全向视野”的增益），以保证图标一定有效；可日后替换为专属图标。
/atom/movable/screen/alert/status_effect/buff/all_seeing_insight
	name = "洞悉万物"
	desc = "我的感知铺满四周，无视朝向，四面八方尽收眼底。"
	icon_state = "astrata_gaze"

// ===== 清理顶部定义的宏，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef INSIGHT_MANA_COST
#undef INSIGHT_CHANNEL_TIME
#undef INSIGHT_COOLDOWN
#undef INSIGHT_RESOURCE_COST
#undef INSIGHT_TARGET_RANGE
