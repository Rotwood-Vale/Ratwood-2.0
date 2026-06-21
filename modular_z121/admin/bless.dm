// ============================================================================
// modular_z121/admin/bless.dm
// 自定义内容 —— 改造管理员指令 "Bless"（祝福）。
// 设计目标（为什么这样做）：
//   原本的 Bless 只能授予一种 3 分钟的 "God's Blessings" 增益。
//   现在需求是：先让管理员从【三种祝福效果】中选择一种，再【按角色名】选择目标，
//   然后把所选效果应用到该目标身上，同时保留原有效果不变。
//   为了不破坏其它系统，所有逻辑都封装在本文件内（modular_z121 根目录之下）。
// 依赖（均为引擎已有内容，本文件只调用、不修改）：
//   - /datum/status_effect/buff           （增益状态效果基类，含 effectedstats 机制）
//   - STATKEY_* 属性键定义（code/__DEFINES/mobs.dm）
//   - TRAIT_* 特性定义（code/__DEFINES/traits.dm）
//   - mob/living 上的 heal_*/get_wounds/SetSleeping 等过程
// 本文件已经在 modular_z121/_load.dm 第 53 行被 include，无需改动加载列表。
// ============================================================================


// ----------------------------------------------------------------------------
// 效果一（已调整）：God's Blessings / 神之祝福
// 调整需求（为什么改）：原本效果一过强（完全无痛 + 无限耐力 + 忽略减速），
//   现在要把它降级为一个温和的祝福：
//     - 轻微治疗伤势（minor recovery of injuries）
//     - 减轻部分痛感（reduction of some pain，而非完全无痛）
//     - 降低部分耐力消耗（reduction of some endurance consumption，而非无限耐力）
//   持续时间维持 3 分钟不变。
// 实现选择（为什么用这两个特性）：
//   - TRAIT_ADRENALINE_RUSH：在 get_complex_pain() 里把肢体疼痛 ×0.5，并把痛觉
//     阈值按 (STAWIL+5) 计算 —— 即 "减轻部分痛感" 而非彻底无痛，正合需求。
//   - TRAIT_FORTITUDE：在 stamina_add() 里把耐力消耗 ×0.5 —— 即 "降低部分耐力
//     消耗" 而非无限耐力，正合需求。
//   不再使用 TRAIT_NOPAIN / TRAIT_INFINITE_STAMINA / TRAIT_IGNORE*SLOWDOWN，
//   以避免把效果一变回 "完全免疫" 的过强版本。
// ----------------------------------------------------------------------------
/datum/status_effect/buff/gods_blessings
	id = "gods_blessings"                                                       // Unique status id used by has_status_effect / alert lookups.
	duration = 3 MINUTES                                                        // Duration kept at 3 minutes per the request.
	tick_interval = 10 SECONDS                                                  // Heal-over-time cadence: every 10 seconds.
	alert_type = /atom/movable/screen/alert/status_effect/buff/gods_blessings   // HUD alert shown to the blessed player.

// 为什么重写 on_apply：在效果开始时立刻授予 "部分减痛 + 部分省力" 两个温和特性。
/datum/status_effect/buff/gods_blessings/on_apply()
	. = ..()                                                                    // Run base apply (also processes effectedstats); capture its success flag.
	if(!.)                                                                      // If the base apply rejected the effect (e.g. no owner)...
		return FALSE                                                           // ...abort so the status effect self-deletes cleanly.

	ADD_TRAIT(owner, TRAIT_ADRENALINE_RUSH, id)                                 // Grant: halve felt pain + raise pain threshold (partial pain relief, NOT immunity).
	ADD_TRAIT(owner, TRAIT_FORTITUDE, id)                                       // Grant: halve stamina/endurance consumption (partial relief, NOT infinite).

	owner.update_stamina()                                                      // Refresh stamina HUD/movement so the lighter cost takes effect.
	owner.updatehealth()                                                        // Refresh health HUD/state.
	return TRUE                                                                 // Report success so the effect stays applied.

// 为什么每 tick 治疗：实现 "轻微治愈伤势" 的祝福主体；同时检测死亡以避免给尸体回血。
/datum/status_effect/buff/gods_blessings/tick()
	if(owner.stat == DEAD)                                                      // If the owner died mid-blessing...
		qdel(src)                                                              // ...remove the effect; reviving corpses is not this verb's job.
		return                                                                 // Stop processing this tick.

	owner.heal_overall_damage(2, 2, 8, null, FALSE)                            // Minor brute/burn mend each tick (no immediate health update).
	owner.adjustOxyLoss(-1, FALSE)                                             // Slowly recover a little oxygen loss.
	owner.adjustToxLoss(-1, FALSE)                                             // Slowly recover a little toxin loss.
	owner.heal_wounds(1)                                                        // Knit shut open wounds bit by bit (minor injury recovery).
	owner.updatehealth()                                                        // Recalculate overall health once per tick.

// 为什么在 on_remove 清理特性：状态结束时必须撤销授予的特性，
//   否则祝福过期后玩家仍永久减痛/省力，造成数值污染。
/datum/status_effect/buff/gods_blessings/on_remove()
	. = ..()                                                                    // Let the base remove effectedstats first.
	REMOVE_TRAIT(owner, TRAIT_ADRENALINE_RUSH, id)                              // Revoke the partial pain relief.
	REMOVE_TRAIT(owner, TRAIT_FORTITUDE, id)                                    // Revoke the partial endurance relief.
	owner.update_stamina()                                                      // Refresh stamina now that the trait is gone.
	owner.updatehealth()                                                        // Refresh health now that the traits are gone.

// 为什么需要独立 alert：让被祝福者在 HUD 上看到一个图标和说明，知道自己处于增益中。
/atom/movable/screen/alert/status_effect/buff/gods_blessings
	name = "God's Blessings"                                                    // Alert title shown on hover.
	desc = "Divine favor eases my pain, lightens my fatigue, and slowly mends my injuries." // Alert tooltip describing the milder effect.
	icon_state = "regenerative_core"                                            // Alert icon reused from existing buff art.


// ----------------------------------------------------------------------------
// 效果二（新增）：Divine Vigor / 神圣活力
// 需求：为目标提供 "10 分钟的生命恢复效果" + "全属性 +1"。
// 实现思路（为什么这样做）：
//   - 用 effectedstats 一次性给全部 7 项属性 +1，状态结束自动撤销，无需手写还原。
//   - 用 10 分钟 duration + 每 10 秒 tick 的回血实现 "持续生命恢复"。
// ----------------------------------------------------------------------------
/datum/status_effect/buff/divine_vigor
	id = "divine_vigor"                                                         // Unique id for this new blessing.
	duration = 10 MINUTES                                                       // Requirement: the recovery effect lasts 10 minutes.
	tick_interval = 10 SECONDS                                                  // Heal-over-time cadence (every 10 seconds for 10 minutes).
	alert_type = /atom/movable/screen/alert/status_effect/buff/divine_vigor     // HUD alert for this buff.
	// 为什么在这里声明全属性 +1：基类 on_apply/on_remove 会自动施加并在结束时回收，
	//   并自带 1~20 的越界保护，是最稳妥的属性加成方式。
	effectedstats = list(
		STATKEY_STR = 1,                                                        // +1 Strength.
		STATKEY_PER = 1,                                                        // +1 Perception.
		STATKEY_INT = 1,                                                        // +1 Intelligence.
		STATKEY_CON = 1,                                                        // +1 Constitution.
		STATKEY_WIL = 1,                                                        // +1 Willpower.
		STATKEY_SPD = 1,                                                        // +1 Speed.
		STATKEY_LCK = 1,                                                        // +1 Fortune (rounds out "full attribute +1").
	)

// 为什么重写 tick：提供持续 10 分钟的生命恢复主体，并防止给死者回血。
/datum/status_effect/buff/divine_vigor/tick()
	if(owner.stat == DEAD)                                                      // Guard: never heal a corpse.
		qdel(src)                                                              // Remove the effect if the owner died.
		return                                                                 // Bail out of this tick.

	owner.heal_overall_damage(3, 3, 8, null, FALSE)                            // Recover brute/burn each tick (a touch stronger than effect one).
	owner.adjustOxyLoss(-2, FALSE)                                             // Recover oxygen loss.
	owner.adjustToxLoss(-2, FALSE)                                             // Recover toxin loss.
	owner.adjustCloneLoss(-1, FALSE)                                           // Mend cellular/clone damage too for a "full" recovery feel.
	owner.heal_wounds(1)                                                        // Gradually close wounds.
	owner.updatehealth()                                                        // Recompute health after this tick's healing.

// 为什么需要 alert：让目标知道自己获得了 10 分钟的活力恢复增益。
/atom/movable/screen/alert/status_effect/buff/divine_vigor
	name = "Divine Vigor"                                                       // Alert title.
	desc = "Holy vitality knits my body whole over ten minutes and sharpens every attribute." // Alert tooltip describing the why.
	icon_state = "regenerative_core"                                            // Reuse existing regen icon to avoid new asset deps.


// ----------------------------------------------------------------------------
// 效果三（新增）：Avatar of War / 战神附体
// 需求：5 分钟内 —— 伤口不流血、无痛感、无限耐力、+4 STR/+4 SPD/+4 CON/+4 意志；
//       效果结束后强制目标沉睡 3 分钟（代价）。
// 实现思路（为什么这样做）：
//   - 用 effectedstats 施加四项 +4 加成，结束自动回收。
//   - 用特性实现 "无痛 + 无限耐力"。
//   - 用 tick 每隔几秒把所有伤口 bleed_rate 归零，实现 "伤口不流血"。
//   - 在 on_remove 里强制 SetSleeping(3 分钟) 实现 "结束后沉睡" 的代价。
// ----------------------------------------------------------------------------
/datum/status_effect/buff/avatar_of_war
	id = "avatar_of_war"                                                        // Unique id for this new blessing.
	duration = 5 MINUTES                                                        // Requirement: the war state lasts 5 minutes.
	tick_interval = 2 SECONDS                                                   // Tight cadence so freshly-opened wounds are zeroed quickly.
	alert_type = /atom/movable/screen/alert/status_effect/buff/avatar_of_war    // HUD alert for this buff.
	// 为什么 +4 四项：直接对应需求里的 +4 STR / +4 SPD / +4 CON / +4 意志。
	effectedstats = list(
		STATKEY_STR = 4,                                                        // +4 Strength.
		STATKEY_SPD = 4,                                                        // +4 Speed.
		STATKEY_CON = 4,                                                        // +4 Constitution.
		STATKEY_WIL = 4,                                                        // +4 Willpower.
	)

// 为什么重写 on_apply：在效果开始时立刻授予无痛与无限耐力相关特性。
/datum/status_effect/buff/avatar_of_war/on_apply()
	. = ..()                                                                    // Run base apply (processes the +4 effectedstats).
	if(!.)                                                                      // If base apply failed...
		return FALSE                                                           // ...abort and self-delete.

	ADD_TRAIT(owner, TRAIT_NOPAIN, id)                                          // "无痛感": pain is not felt at all.
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, id)                                      // Pain can no longer interrupt/stun the target.
	ADD_TRAIT(owner, TRAIT_INFINITE_STAMINA, id)                               // "无限耐力": stamina never runs out.
	ADD_TRAIT(owner, TRAIT_IGNORESLOWDOWN, id)                                  // Ignore generic slowdown (part of the relentless feel).
	ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, id)                            // Wounds never slow the warrior down.

	owner.setStaminaLoss(0)                                                     // Start with a full stamina bar.
	owner.update_stamina()                                                      // Apply the stamina reset.
	owner.updatehealth()                                                        // Refresh health/state.
	return TRUE                                                                 // Keep the effect applied.

// 为什么每 tick 处理流血：伤口随时可能在战斗中产生，必须周期性把所有伤口的
//   bleed_rate 归零，才能保证 "5 分钟内伤口不流血" 的承诺始终成立。
/datum/status_effect/buff/avatar_of_war/tick()
	if(owner.stat == DEAD)                                                      // If the warrior dies during the effect...
		qdel(src)                                                              // ...end the effect (on_remove will still run).
		return                                                                 // Stop this tick.

	// 为什么遍历伤口并 set_bleed_rate(0)：这是引擎里 "止血" 的标准做法，
	//   逐个伤口将流血速率清零，确保血量不再因伤口流失。
	for(var/datum/wound/wound as anything in owner.get_wounds())                // Iterate every wound the target currently has.
		if(isnull(wound))                                                      // Defensive: skip any null entry in the wound list.
			continue                                                           // Move to the next wound.
		wound.set_bleed_rate(0)                                                 // Force this wound to stop bleeding.

	owner.setStaminaLoss(0, FALSE)                                             // Keep stamina pinned (reinforces infinite endurance).
	owner.update_stamina()                                                      // Push the stamina state to the mob.

// 为什么在 on_remove 强制沉睡：这是效果三设计的代价机制 ——
//   "force the target to sleep for 3 minutes after the effect ends"。
//   同时必须撤销所有授予的特性，避免战神状态残留。
/datum/status_effect/buff/avatar_of_war/on_remove()
	. = ..()                                                                    // Base remove first (revokes the +4 effectedstats).
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, id)                                       // Revoke no-pain.
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, id)                                   // Revoke pain-stun immunity.
	REMOVE_TRAIT(owner, TRAIT_INFINITE_STAMINA, id)                            // Revoke infinite stamina.
	REMOVE_TRAIT(owner, TRAIT_IGNORESLOWDOWN, id)                              // Revoke slowdown immunity.
	REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, id)                        // Revoke damage-slowdown immunity.
	owner.update_stamina()                                                      // Refresh stamina after traits removed.
	owner.updatehealth()                                                        // Refresh health after traits removed.

	// 为什么加死亡判断：如果目标已经死亡，让尸体 "沉睡" 既无意义也可能报错，
	//   所以只有在目标仍存活时才施加 3 分钟强制睡眠这一代价。
	if(owner && owner.stat != DEAD)                                            // Only enforce the sleep cost on a living owner.
		owner.SetSleeping(3 MINUTES, ignore_canstun = TRUE)                   // Force 3 minutes of sleep (ignore_canstun so the cost always lands).
		to_chat(owner, span_warning("The war-fury drains away and drags me into a deep, exhausted sleep.")) // Tell the player why they collapsed.

// 为什么需要 alert：让目标看到自己处于战神状态，并提示其会有结束后的睡眠代价。
/atom/movable/screen/alert/status_effect/buff/avatar_of_war
	name = "Avatar of War"                                                      // Alert title.
	desc = "I feel no pain and never tire; my wounds will not bleed - but when this fades I will collapse into sleep." // Alert tooltip with the cost.
	icon_state = "regenerative_core"                                            // Reuse existing icon to avoid new asset deps.


// ----------------------------------------------------------------------------
// 目标选择助手（按角色名选择）
// 为什么单独写这个过程：需求要求 "select the target ... using the player character's name"，
//   而引擎自带的 adminspell_get_target() 是按客户端 key 选人，且位于 modular_z121
//   之外不可修改。因此在本文件内实现一个 "按角色名" 的选择器。
// 返回值：选中的 /mob/living；若管理员取消或无可选目标，返回 null（调用方据此优雅退出）。
// ----------------------------------------------------------------------------
/client/proc/bless_get_target_by_name()
	// 为什么用关联列表：把 "显示名" 映射到 "mob"，让 input() 只展示角色名，
	//   选完再用名字反查到具体 mob。
	var/list/name_to_mob = list()                                              // Assoc list: display name -> mob.

	// 为什么遍历 GLOB.player_list：这是所有在线玩家 mob 的全局列表，与原版
	//   adminspell_get_target 使用的来源一致。
	for(var/mob/living/candidate in GLOB.player_list)                          // Walk every living player mob in the round.
		if(!candidate.client)                                                  // Skip mobs with no controlling client (logged-out/NPC shells).
			continue                                                           // Not a selectable player target.

		// 为什么优先用 real_name：角色名通常存于 real_name；为空时回退到 name。
		var/display_name = candidate.real_name ? candidate.real_name : candidate.name // Pick the character's display name.

		// 为什么处理重名：两个角色可能同名，直接覆盖会丢失目标；附加 ckey 以消歧。
		if(name_to_mob[display_name])                                          // If this name is already taken by another mob...
			display_name = "[display_name] ([candidate.ckey])"               // ...disambiguate by appending the player's ckey.

		name_to_mob[display_name] = candidate                                 // Register the (possibly disambiguated) name -> mob mapping.

	// 为什么提前判断空列表：没有任何可选目标时给出明确反馈并退出，避免弹出空菜单。
	if(!length(name_to_mob))                                                   // No valid targets exist...
		to_chat(src, span_warning("There are no living player characters available to bless.")) // ...inform the admin.
		return null                                                           // Signal "cancel/abort" to the caller.

	// 为什么用 null|anything：让管理员可以直接关闭对话框取消（返回 null 即取消）。
	var/chosen_name = input(src, "Select the character to bless:", "Bless - Target") as null|anything in sortList(name_to_mob) // Prompt by name.
	if(!chosen_name)                                                          // Admin pressed cancel / closed the dialog...
		return null                                                           // ...abort gracefully.

	// 为什么再校验一次：弹窗期间目标可能登出/被删，需重新确认 mob 仍然有效。
	var/mob/living/target = name_to_mob[chosen_name]                          // Resolve the chosen name back to a mob.
	if(!istype(target) || QDELETED(target))                                   // If the target vanished while the menu was open...
		to_chat(src, span_warning("That character is no longer available.")) // ...report the failure.
		return null                                                           // ...and abort.

	return target                                                            // Hand the validated target back to bless().


// ----------------------------------------------------------------------------
// 管理员指令主体：Bless
// 新流程（为什么这样设计）：
//   1) 先弹出 "三选一" 的效果菜单（先选效果）。
//   2) 再按角色名选择目标（后选目标，且可随时取消）。
//   3) 应用所选状态效果，并完成日志/反馈/封禁审计。
// ----------------------------------------------------------------------------
/client/proc/bless()
	set category = "-GameMaster-"                                              // Place this verb under the GameMaster admin tab.
	set name = "Bless"                                                         // Verb name shown to admins.
	set desc = "Choose one of three blessings, then apply it to a selected character."  // Updated description.

	// 为什么先校验权限：这是管理指令，必须确保调用者拥有管理员权限。
	if(!check_rights(R_ADMIN))                                                 // Reject anyone without admin rights.
		return                                                                // Silently abort (check_rights already warns).

	// 为什么用静态关联列表：把 "可读的效果名" 映射到对应的状态效果类型，
	//   既能给 input() 展示友好名称，又能直接拿到类型路径；static 避免每次重建。
	var/static/list/blessing_options = list(
		"God's Blessings (3 min: minor healing, some pain relief, less fatigue)" = /datum/status_effect/buff/gods_blessings, // Effect 1 (adjusted to a milder buff).
		"Divine Vigor (10 min health recovery + all attributes +1)" = /datum/status_effect/buff/divine_vigor,        // Effect 2 (new).
		"Avatar of War (5 min: no bleed/pain, infinite stamina, +4 STR/SPD/CON/WIL, then 3 min sleep)" = /datum/status_effect/buff/avatar_of_war, // Effect 3 (new).
	)

	// 为什么先选效果：需求要求 "Choosing bless now should provide three effects to choose from"。
	var/chosen_label = input(src, "Choose a blessing to grant:", "Bless - Effect") as null|anything in blessing_options // Show the 3-option menu.
	if(!chosen_label)                                                         // Admin cancelled the effect menu...
		return                                                                // ...abort the whole command.

	// 为什么用映射取类型：把用户看到的标签转换成实际要应用的状态效果类型路径。
	var/effect_type = blessing_options[chosen_label]                          // Resolve label -> status effect typepath.
	if(!effect_type)                                                          // Defensive: should never happen, but guard anyway...
		to_chat(src, span_warning("Invalid blessing selection."))            // ...report the inconsistency.
		return                                                                // ...and abort.

	// 为什么后选目标：需求要求选完效果后 "select the target ... using the player character's name"。
	var/mob/living/target = bless_get_target_by_name()                       // Pick the target character by name (returns null on cancel).
	if(!target)                                                              // No valid target / admin cancelled...
		return                                                                // ...abort (helper already gave feedback if needed).

	// 为什么要求存活：三种祝福都依赖治疗/属性/睡眠等机制，对尸体施加既无效又易出错。
	if(target.stat == DEAD)                                                   // If the chosen character is dead...
		to_chat(src, span_warning("[target] must be alive to receive a blessing.")) // ...explain why it can't be applied.
		return                                                                // ...and abort.

	// 为什么记录 already_blessed：状态基类是 REFRESH 型，重复施加会刷新时长；
	//   提前记录有无该效果，便于给出 "刷新" 还是 "首次授予" 的精确反馈与日志。
	var/already_blessed = target.has_status_effect(effect_type)              // Was this exact blessing already active?

	// 为什么用 apply_status_effect 并校验返回值：实际施加效果；若引擎拒绝（返回 null），
	//   说明效果未生效，需要立即向管理员报错而不是谎报成功。
	var/datum/status_effect/applied = target.apply_status_effect(effect_type) // Apply (or refresh) the chosen blessing.
	if(!applied && !already_blessed)                                         // Apply failed and there was no prior instance to refresh...
		to_chat(src, span_warning("Failed to apply the blessing to [target]. The effect may have been rejected."))  // ...report failure.
		return                                                                // ...and abort before logging a false success.

	// 为什么提取可读名：日志与聊天反馈里展示效果名比展示类型路径更清晰。
	// 为什么用 template 取 initial(id)：REFRESH 刷新路径下 apply_status_effect 返回 null，
	//   无法从 applied 实例取 id；改为从类型路径读取其初始 id，保证刷新/首次都能拿到名字。
	var/datum/status_effect/template = effect_type                           // Treat the typepath as a template to read compile-time vars.
	var/effect_name = initial(template.id)                                   // Human-readable effect id, valid even on the refresh path.

	// 为什么区分刷新/首次：给管理员、目标、以及管理日志提供精确的行为描述。
	if(already_blessed)                                                       // The blessing was already active and just got refreshed...
		to_chat(src, span_notice("Refreshed '[chosen_label]' on [target]."))                 // Admin feedback.
		to_chat(target, span_notice("A familiar blessing is renewed upon me."))               // Target feedback.
		log_admin("[key_name(usr)] refreshed blessing [effect_name] on [key_name(target)].")  // Plain admin log.
		message_admins(span_adminnotice("[key_name_admin(usr)] refreshed blessing [effect_name] on [key_name_admin(target)].")) // Broadcast to admins.
		admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] has refreshed a blessing ([effect_name]) on you.</font>") // Ticket trail.
	else                                                                      // The blessing was freshly granted...
		to_chat(src, span_notice("Granted '[chosen_label]' to [target]."))                    // Admin feedback.
		to_chat(target, span_notice("A divine blessing settles over me."))                    // Target feedback.
		log_admin("[key_name(usr)] granted blessing [effect_name] to [key_name(target)].")    // Plain admin log.
		message_admins(span_adminnotice("[key_name_admin(usr)] granted blessing [effect_name] to [key_name_admin(target)].")) // Broadcast to admins.
		admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] has blessed you ([effect_name]).</font>") // Ticket trail.

	// 为什么记录统计：保留原版的管理动作统计埋点，便于后台分析使用频率。
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Bless")            // Tally one use of the Bless verb.
