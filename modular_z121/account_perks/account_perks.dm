// ============================================================================
// modular_z121/account_perks/account_perks.dm
// 登录派发器（Login dispatcher）：按账号在"角色进入游戏"时统一赠礼
// ----------------------------------------------------------------------------
// 这个文件存在的唯一理由：
//   本目录有多个"按账号赠礼"的特例（KUKULING 自动获得 RPG 系统并满积分、Sonic121 自动获得
//   温暖力场……）。它们都需要在"角色进入游戏"那一刻触发，而该时刻对应引擎在人物上调用的
//   /mob/living/carbon/human/Login()。但 DM 中同一类型路径的 Login() 只能定义一次——若每个特例
//   各自覆写 Login()，会造成"重复定义"硬编译错误。
//
//   因此约定：唯一的 /mob/living/carbon/human/Login() 覆写【只放在本文件】；它在执行完核心登录
//   流程后，逐一调用各特例自己的"赠礼 proc"。每个赠礼 proc 自带 ckey 自检（不是自己的账号就直接
//   返回），所以这里可以无条件依次调用，互不干扰。
//
//   新增一个受惠账号 = 写一个 /mob/living/carbon/human/proc/grant_xxx_perks()（自带 ckey 自检）
//   + 在下面的派发器里加一行调用。永不冲突、零侵入。
//
// 为什么放在 Login() 而不是别处：
//   "角色进入游戏"对玩家而言就是其思维(mind)接管人物、客户端绑定到该人物的时刻，引擎此时在该
//   人物上触发 Login()。核心仅定义了 /mob/living/Login()（code/modules/mob/living/login.dm），
//   并未定义更具体的 human 版本，故这里"新增一个 human 子类型的 Login()"属于纯增量（追加子类型
//   proc），不修改任何核心文件。开头 . = ..() 会照常链到 /mob/living/Login()，不破坏原有登录流程。
//
// 依赖（均为引擎 / 本模块已有内容）：
//   - /mob/living/Login()                              核心登录入口（被 ..() 链到）
//   - /mob/living/carbon/human/proc/grant_kukuling_perks()  KUKULING 赠礼（modular_z121/virtues/rpg_system_kukuling_autogrant.dm）
//   - /mob/living/carbon/human/proc/grant_sonic121_perks()  Sonic121 赠礼（modular_z121/account_perks/warm_power_field.dm）
//
// 加载：本文件需在 _load.dm 中 #include。各赠礼 proc 由 proc 名全局解析，文件包含先后顺序不影响调用。
// ============================================================================

/mob/living/carbon/human/Login()
	// 先执行核心登录流程（绑定客户端、刷新界面等）。务必最先调用，确保下面的赠礼逻辑运行时
	//   客户端与 ckey 均已就绪。
	. = ..()
	// 依次派发各"按账号赠礼"逻辑。每个 proc 内部自带 ckey 自检，不是对应账号即安静返回，
	//   故这里无条件全部调用即可。新增受惠账号时在此追加一行调用。
	grant_kukuling_perks()
	grant_sonic121_perks()
