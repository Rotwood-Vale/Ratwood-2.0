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

	// 登记自定义恶习"病娇"到可选恶习列表（GLOB.character_flaws）。
	// 为什么放在这里：与上面的"洁癖"登记同理——custom_bootstrap 的 Initialize 执行时机
	//   晚于全局列表（GLOBAL_LIST_INIT）的初始化，此刻向"可选恶习列表"追加是安全的；
	//   登记逻辑本身定义在 modular_z121/vices/yandere.dm 内，这里只做一次调用。
	register_yandere_vice()

	// 登记自定义恶习"脸盲症"到可选恶习列表（GLOB.character_flaws）。
	// 为什么放在这里：与上面的"洁癖""病娇"登记同理——custom_bootstrap 的 Initialize 执行时机
	//   晚于全局列表（GLOBAL_LIST_INIT）的初始化，此刻向"可选恶习列表"追加是安全的；
	//   登记逻辑本身定义在 modular_z121/vices/facial_blindness.dm 内，这里只做一次调用。
	register_facial_blindness_vice()

	// 登记自定义美德"生命潜能"的特性到玩家可见的特性表（GLOB.roguetraits）。
	// 为什么放在这里：与上面同理——此刻核心表 roguetraits 已由 GLOBAL_LIST_INIT 完成
	//   初始化，向其追加一个键值对，玩家点开特性自检面板时即可看到"生命潜能"及其说明。
	//   登记逻辑定义在 modular_z121/virtues/life_potential.dm 内（那里才有对应的特性宏），
	//   这里只按 proc 名做一次调用，遵守宏的 #include 可见性规则。
	register_life_potential_trait()

	// 登记自定义美德"远古造物"的【亘古长存】特性到玩家可见的特性表（GLOB.roguetraits）。
	// 为什么放在这里：与上面同理——此刻核心表 roguetraits 已由 GLOBAL_LIST_INIT 完成初始化，
	//   向其追加一个键值对，玩家点开特性自检面板时即可看到"亘古长存"及其说明。
	//   登记逻辑定义在 modular_z121/virtues/ancient_creation.dm 内（那里才有对应的特性宏），
	//   这里只按 proc 名做一次调用，遵守宏的 #include 可见性规则。
	register_ancient_existence_trait()

	// 登记自定义美德"永无止境"的【指定演员】特性到玩家可见的特性表（GLOB.roguetraits）。
	// 为什么放在这里：与上面同理——此刻核心表 roguetraits 已由 GLOBAL_LIST_INIT 完成初始化，
	//   向其追加一个键值对，玩家点开特性自检面板时即可看到"指定演员"及其说明。
	//   登记逻辑定义在 modular_z121/virtues/never_ending.dm 内（那里才有对应的特性宏
	//   TRAIT_DESIGNATED_PERFORMER），这里只按 proc 名做一次调用，遵守宏的 #include 可见性规则。
	// Register the never-ending virtue's "Designated Performer" trait into the player-visible
	// GLOB.roguetraits, same rationale as the registrations above.
	register_designated_performer_trait()

	// 登记自定义美德"魅魔血脉"的【魅魔血脉 / 魅魔女王】特性到玩家可见的特性表（GLOB.roguetraits）。
	// 为什么放在这里：与上面同理——此刻核心表 roguetraits 已由 GLOBAL_LIST_INIT 完成初始化，
	//   向其追加键值对后，玩家点开特性自检面板即可看到这两项特性及其说明，满足"该特性应能被
	//   玩家在游戏内察觉"的需求。登记逻辑定义在 modular_z121/virtues/succubus_bloodline.dm 内
	//   （那里才有对应的 TRAIT_SUCCUBUS_* 宏），这里只按 proc 名做一次调用，遵守宏的 #include 可见性规则。
	// Register the succubus bloodline virtue's "Succubus Bloodline / Succubus Queen" traits into the
	// player-visible GLOB.roguetraits, same rationale as the registrations above.
	register_succubus_bloodline_trait()

	// 登记自定义美德"马丁的早晨"的【马丁的早晨】特性到玩家可见的特性表（GLOB.roguetraits）。
	// 为什么放在这里：与上面同理——此刻核心表 roguetraits 已由 GLOBAL_LIST_INIT 完成初始化，
	//   向其追加键值对后，玩家点开特性自检面板即可看到"马丁的早晨"及其说明。
	//   登记逻辑定义在 modular_z121/virtues/martins_morning.dm 内（那里才有对应的
	//   TRAIT_MARTINS_MORNING 宏），这里只按 proc 名做一次调用，遵守宏的 #include 可见性规则。
	// Register the Martin's Morning virtue's trait into the player-visible GLOB.roguetraits,
	// same rationale as the registrations above.
	register_martins_morning_trait()

	// 登记自定义美德"地狱血脉后裔"的【地狱血脉】特性到玩家可见的特性表（GLOB.roguetraits）。
	// 为什么放在这里：与上面同理——此刻核心表 roguetraits 已由 GLOBAL_LIST_INIT 完成初始化，
	//   向其追加键值对后，提夫林玩家点开特性自检面板即可看到【地狱血脉】及其说明，满足"该特性
	//   应能被玩家在游戏内察觉"的需求。登记逻辑定义在 modular_z121/virtues/hellblood_descendant.dm
	//   内（那里才有对应的 TRAIT_HELLBLOOD_DESCENDANT 宏），这里只按 proc 名做一次调用，遵守宏的
	//   #include 可见性规则。
	// Register the Hell Bloody Descendants virtue's "Hell Bloodline" trait into the player-visible
	// GLOB.roguetraits, same rationale as the registrations above.
	register_hellblood_descendant_trait()

	// 登记自定义美德"天才"的【天才】特性到玩家可见的特性表（GLOB.roguetraits）。
	// 为什么放在这里：与上面同理——此刻核心表 roguetraits 已由 GLOBAL_LIST_INIT 完成初始化，
	//   向其追加键值对后，年轻角色点开特性自检面板即可看到【天才】及其说明，满足"该特性
	//   应能被玩家在游戏内看到"的需求。登记逻辑定义在 modular_z121/virtues/genius.dm 内
	//   （那里才有对应的 TRAIT_GENIUS 宏），这里只按 proc 名做一次调用，遵守宏的 #include 可见性规则。
	// Register the Genius virtue's "Genius" trait into the player-visible GLOB.roguetraits,
	// same rationale as the registrations above.
	register_genius_trait()

	// 登记自定义美德"畸变变种"的【畸变变种】特性到玩家可见的特性表（GLOB.roguetraits）。
	// 为什么放在这里：与上面同理——此刻核心表 roguetraits 已由 GLOBAL_LIST_INIT 完成初始化，
	//   向其追加键值对后，血肉之躯角色点开特性自检面板即可看到【畸变变种】及其说明，满足"该特性
	//   应能被玩家在游戏内看到"的需求。登记逻辑定义在 modular_z121/virtues/distortion_variant.dm 内
	//   （那里才有对应的 TRAIT_DISTORTION_VARIANT 宏），这里只按 proc 名做一次调用，遵守宏的
	//   #include 可见性规则。
	// Register the Distortion Variant virtue's trait into the player-visible GLOB.roguetraits,
	// same rationale as the registrations above.
	register_distortion_variant_trait()

	// 登记自定义美德"醉剑仙"的【醉剑仙】特性到玩家可见的特性表（GLOB.roguetraits）。
	// 为什么放在这里：与上面同理——此刻核心表 roguetraits 已由 GLOBAL_LIST_INIT 完成初始化，
	//   向其追加键值对后，玩家点开特性自检面板即可看到【醉剑仙】及其说明，满足"该特性应能被
	//   玩家在游戏内看到"的需求。登记逻辑定义在 modular_z121/virtues/wine_sword_immortal.dm 内
	//   （那里才有对应的 TRAIT_WINE_SWORD_IMMORTAL 宏），这里只按 proc 名做一次调用，遵守宏的
	//   #include 可见性规则。
	// Register the Wine Sword Immortal virtue's trait into the player-visible GLOB.roguetraits,
	// same rationale as the registrations above.
	register_wine_sword_immortal_trait()

	// 登记自定义美德"RPG系统"的【RPG系统】特性到玩家可见的特性表（GLOB.roguetraits）。
	// 为什么放在这里：与上面同理——此刻核心表 roguetraits 已由 GLOBAL_LIST_INIT 完成初始化，
	//   向其追加键值对后，玩家点开特性自检面板即可看到【RPG系统】及其说明，满足"该特性应能被
	//   玩家在游戏内看到"的需求。登记逻辑定义在 modular_z121/virtues/rpg_system.dm 内（那里才有
	//   对应的 TRAIT_RPG_SYSTEM 宏），这里只按 proc 名做一次调用，遵守宏的 #include 可见性规则。
	// Register the RPG System virtue's trait into the player-visible GLOB.roguetraits,
	// same rationale as the registrations above.
	register_rpg_system_trait()

	// 登记自定义特性【温暖力场】到玩家可见的特性表（GLOB.roguetraits），同上理由：此刻核心表已初始化，
	//   追加后 Sonic121 点开特性自检面板即可看到【温暖力场】及其说明。登记逻辑定义在
	//   modular_z121/account_perks/warm_power_field.dm 内（那里才有 TRAIT_WARM_POWER_FIELD 宏），
	//   这里只按 proc 名做一次调用，遵守宏的 #include 可见性规则。
	// Register the custom "Warm Power Field" trait into the player-visible GLOB.roguetraits.
	register_warm_power_field_trait()

	// 修复"暗影裔无法选择任何职业"的 Bug：把暗影裔注入所有已允许【野民/anthromorph】的
	//   职业(/datum/job)与进阶职业(/datum/advclass)的 allowed_races 列表。
	// 为什么放在这里：custom_bootstrap 的 init_order(0) 晚于 SSjob(65) 与 SSrole_class_handler(66)，
	//   此刻两套职业实例均已就绪，可安全遍历改写；登记逻辑定义在 modular_z121/jobs/shadekin_job_access.dm。
	// Fix the "Shadekin can't pick any profession" bug: inject Shadekin into the allowed_races of every
	// job/advclass that already allows Wild-Kin (anthromorph). Safe here because custom_bootstrap (init
	// order 0) runs after SSjob (65) and SSrole_class_handler (66), so all instances exist.
	grant_shadekin_job_access()

	// 注：暗影裔的"装备准入"修复已改为在 /datum/species/shadekin/can_equip() 内就地放行
	//   （见 modular_z121/species/shadekin_equipment_access.dm），无需在此做启动期注入。
	// Note: the Shadekin equipment-access fix now lives in /datum/species/shadekin/can_equip()
	// (see modular_z121/species/shadekin_equipment_access.dm); no startup-time injection needed here.

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
