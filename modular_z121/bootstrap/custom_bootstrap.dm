SUBSYSTEM_DEF(custom_bootstrap)
	name = "Custom Bootstrap"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_DEFAULT

/proc/get_custom_admin_verbs()
	return list(
		/client/proc/adminspell,
		/client/proc/removeadminspell,
		/client/proc/bless,
		/client/proc/grandcaster,
		/client/proc/god,
		/client/proc/toggle_god_blessings,
		/client/proc/cleanup_world,	// 世界清理指令：必须在此登记，自定义 client 动词才会被挂到管理员的 -GameMaster- 标签下
	)

/datum/controller/subsystem/custom_bootstrap/Initialize(timeofday)
	. = ..()
	if(!islist(GLOB.learnable_spells))
		GLOB.learnable_spells = list()
	if(GLOB.custom_learnable_spells?.len)
		GLOB.learnable_spells |= GLOB.custom_learnable_spells

	// 登记自定义恶习"洁癖"到可选恶习列表（GLOB.character_flaws）。
	// 为什么放在这里：custom_bootstrap 是本项目统一的启动钩子，其 Initialize 执行时机
	//   晚于全局列表（GLOBAL_LIST_INIT）的初始化，此刻追加可选恶习是安全的；
	//   登记逻辑本身定义在 modular_z121/vices/neat_freak.dm 内，这里只做一次调用。
	register_neat_freak_vice()

	var/list/custom_admin_verbs = get_custom_admin_verbs()
	if(islist(GLOB.admin_verbs_admin))
		GLOB.admin_verbs_admin |= custom_admin_verbs
	if(islist(GLOB.admin_verbs_hideable))
		GLOB.admin_verbs_hideable |= custom_admin_verbs

	for(var/client/admin_client in GLOB.admins)
		if(!admin_client?.holder)
			continue
		admin_client.remove_admin_verbs()
		admin_client.add_admin_verbs()
