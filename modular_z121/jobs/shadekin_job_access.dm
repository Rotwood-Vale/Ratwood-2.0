// =====================================================================================
// 暗影裔 职业准入修复 / Shadekin job-access fix
// -------------------------------------------------------------------------------------
// 问题(Bug)：暗影裔无法选择任何职业。
// 根因：主线用 `pref_species.type in job.allowed_races` 判定某种族能否担任某职业；
//   而 job/advclass 的 allowed_races 默认来自宏 RACES_ALL_KINDS(= RACES_DESPISED, RACES_SHUNNED,
//   RACES_TOLERATED, ...)，这些宏写死在 code/__DEFINES/roguetown.dm 里，且 **不含** /datum/species/shadekin。
//   于是对暗影裔而言，每个职业的 `type in allowed_races` 恒为假 → 一个职业都选不了。
// 约束：这些宏位于 modular_z121 之外，禁止修改。因此必须在运行时从 modular_z121 内注入。
//
// Why this exists: a Shadekin can't pick any profession. The engine gates jobs via
// `pref_species.type in job.allowed_races`, and every job/advclass builds allowed_races from the
// RACES_ALL_KINDS family of macros (in code/__DEFINES/roguetown.dm — outside modular_z121, off-limits),
// none of which list /datum/species/shadekin. So the gate is always false for Shadekin. We fix it at
// runtime, from within modular_z121, without touching the macros.
//
// 策略：以已被主线接纳的拟人兽族【野民/Wild-Kin = /datum/species/anthromorph】为"镜像"。
//   anthromorph 已在 RACES_TOLERATED 宏内，凡是允许它的职业/进阶职业，也一并允许暗影裔；
//   凡是限制它的(如贵族专属)，暗影裔同样被排除——从而让暗影裔获得与野民完全一致、合乎设定的职业范围。
// Strategy: mirror the already-accepted anthro race Wild-Kin (/datum/species/anthromorph, which lives in
// RACES_TOLERATED). Wherever a job/advclass allows Wild-Kin, also allow Shadekin; wherever Wild-Kin is
// restricted (e.g. noble-only), Shadekin stays restricted too. This gives Shadekin a lore-consistent
// job range identical to Wild-Kin.
// =====================================================================================

// 日志前缀宏：统一本种族相关日志的标识，避免到处硬编码字符串。必须定义在使用它的 proc 之前
// （DM 预处理器自上而下单遍展开宏）。
// Log-prefix macro: a single identifier for this race's logs. Must be defined BEFORE the proc that uses
// it (the DM preprocessor expands macros top-to-bottom in a single pass).
#define SHADEKIN_LOG_PREFIX "\[Shadekin]"

// 把暗影裔注入所有"允许野民"的职业与进阶职业的 allowed_races 列表。
// 为什么由 custom_bootstrap 调用：custom_bootstrap 的 init_order=0，晚于 SSjob(65) 与
//   SSrole_class_handler(66)，因此调用时这两个子系统都已完成初始化、其职业/进阶职业实例均已就绪。
// Inject Shadekin into the allowed_races of every job/advclass that already allows Wild-Kin.
// Why custom_bootstrap drives it: custom_bootstrap (init_order 0) runs AFTER SSjob (65) and
// SSrole_class_handler (66), so both subsystems are initialized and their job/advclass instances exist.
/proc/grant_shadekin_job_access()
	// 镜像参照种族：已被接纳的拟人兽族【野民】。
	// The mirror reference race: the accepted anthro race Wild-Kin.
	var/mirror_type = /datum/species/anthromorph
	// 目标种族：本次要授予职业准入的暗影裔。
	// The target race we are granting job access to: Shadekin.
	var/shadekin_type = /datum/species/shadekin

	// 统计成功注入的条目数，便于在日志中确认修复是否生效(便于排错)。
	// Count how many entries we patched, so the log can confirm the fix ran (aids debugging).
	var/patched_jobs = 0
	var/patched_classes = 0

	// ---- ① 主线职业 (/datum/job) ----
	// 防御性检查：SSjob 及其 occupations 列表必须存在，否则跳过(避免对空对象迭代导致运行时报错)。
	// Defensive check: SSjob and its occupations list must exist; otherwise skip (avoid iterating null).
	if(SSjob && islist(SSjob.occupations))
		// 遍历所有职业实例。
		// Iterate every job instance.
		for(var/datum/job/checked_job in SSjob.occupations)
			// 仅处理 allowed_races 为有效列表的职业；为空/为 null 表示"不限种族"，本就允许暗影裔，无需处理。
			// Only touch jobs whose allowed_races is a real list; empty/null means "no race restriction",
			// which already permits Shadekin, so nothing to do.
			if(!islist(checked_job.allowed_races))
				continue
			// 镜像规则：野民被允许、且暗影裔尚未在列表中时，才追加暗影裔(去重，避免重复添加)。
			// Mirror rule: only add Shadekin when Wild-Kin is allowed and Shadekin isn't already present (de-dupe).
			if((mirror_type in checked_job.allowed_races) && !(shadekin_type in checked_job.allowed_races))
				checked_job.allowed_races += shadekin_type
				patched_jobs++

	// ---- ② 进阶职业 / 日常职业 (/datum/advclass) ----
	// 进阶职业实例由 SSrole_class_handler 在初始化时一次性创建并缓存在 sorted_class_categories[CTAG_ALLCLASS]。
	// 防御性检查后遍历全部进阶职业，套用同一镜像规则。
	// Advclass instances are created once by SSrole_class_handler and cached in
	// sorted_class_categories[CTAG_ALLCLASS]. After a defensive check, iterate them all and apply the same rule.
	if(SSrole_class_handler && islist(SSrole_class_handler.sorted_class_categories))
		// 取"全部进阶职业"分类列表。
		// Grab the "all advclasses" category list.
		var/list/all_classes = SSrole_class_handler.sorted_class_categories[CTAG_ALLCLASS]
		if(islist(all_classes))
			for(var/datum/advclass/checked_class in all_classes)
				// 同主线职业：仅处理 allowed_races 为有效列表者。
				// As with jobs: only touch ones whose allowed_races is a real list.
				if(!islist(checked_class.allowed_races))
					continue
				// 镜像 + 去重。
				// Mirror + de-dupe.
				if((mirror_type in checked_class.allowed_races) && !(shadekin_type in checked_class.allowed_races))
					checked_class.allowed_races += shadekin_type
					patched_classes++

	// 输出一条启动日志，确认本修复执行情况(便于上线后核对)。
	// Emit a startup log line confirming the fix ran (for post-deploy verification).
	log_world("[SHADEKIN_LOG_PREFIX] granted Shadekin job access: patched [patched_jobs] jobs, [patched_classes] advclasses (mirroring [mirror_type]).")

// 用完即解除该宏，避免它泄漏到其它文件造成潜在的命名冲突。
// Undefine the macro once done so it can't leak into other files and cause name collisions.
#undef SHADEKIN_LOG_PREFIX
