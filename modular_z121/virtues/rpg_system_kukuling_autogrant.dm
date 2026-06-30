// ============================================================================
// modular_z121/virtues/rpg_system_kukuling_autogrant.dm
// 自定义特例（Custom override）：账号 KUKULING 自动获得【RPG系统】并满积分
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   需求：当玩家的账号名（ckey）被识别为 KUKULING 时，他所创建的角色一进入游戏，
//   就自动获得【RPG系统】美德的全部效果，并把【系统积分】直接设为 999999。
//
//   两件事各自对应到既有实现：
//     · "RPG系统的美德效果" = /datum/virtue/utility/rpg_system 的 apply_to_human()
//       （授予 TRAIT_RPG_SYSTEM 特性 + 挂载 /datum/component/rpg_system 驱动组件
//        + 授予「打开RPG系统」动词），见 rpg_system.dm。
//     · "RPG系统的积分" = 该驱动组件上的 points 字段（积分存档位）。
//
// 为什么直接调用 apply_to_human() 而不是 apply_virtue()：
//   apply_virtue() 流程开头会先跑 check_triumphs()——本美德 triumph_cost = 99，
//   若 KUKULING 当前凯旋点数不足 99，apply_virtue() 会直接 return、根本不授予。
//   而这里是"无条件自动赠予"，所以绕过点数门槛，直接调用 apply_to_human() 取其
//   全部效果（该 proc 内部用 AddComponent，组件 UNIQUE 去重，重复调用安全）。
//   rpg_system 的 added_traits/added_skills/added_stats 均为空，apply_to_human()
//   本身即承载了这个美德的完整效果，无需再补跑 handle_* 系列。
//
// 为什么做成 grant_kukuling_perks() 而不是直接在此覆写 Login()：
//   "角色进入游戏"对玩家而言就是其思维（mind）接管人物、客户端绑定到该人物的时刻，
//   引擎此时会在该人物上触发 Login()。但 DM 中同一类型路径只能定义一次 Login()——
//   现在已有多个"按账号赠礼"的特例（KUKULING、Sonic121……），若每个文件都各自覆写
//   /mob/living/carbon/human/Login()，会造成"重复定义"硬编译错误。
//   因此统一约定：本目录所有"按账号赠礼"逻辑各自封装为一个【自带 ckey 自检】的 proc，
//   由唯一的登录派发器（account_perks/account_perks.dm 内的那一个 Login() 覆写）在每次
//   登录时逐一调用；每个 proc 自己判断"是不是我的账号"，不是就直接返回。这样新增受惠账号
//   只需"加一个自检 proc + 在派发器里加一行调用"，永不冲突。
//   （派发器的 Login() 开头 . = ..() 会照常链到 /mob/living/Login()，不破坏原有登录流程。）
//
// 为什么用 HAS_TRAIT 做"只授予一次"的闸门：
//   Login() 在每次登录 / 重连 / 灵魂回体时都会触发。用 HAS_TRAIT(src, TRAIT_RPG_SYSTEM)
//   判断：未持有才授予并把积分设为 999999；已持有则什么都不做——避免重连时把玩家
//   已经消费过的积分又重置回 999999。而当 KUKULING 创建并进入一个全新角色（新身体
//   没有该特性）时，会再次满足条件、重新授予，正合"他创建的角色进入游戏即生效"。
//
// 依赖（均为引擎 / 本模块已有内容，本文件只调用，不修改其源文件）：
//   - /mob/living/Login()                              核心登录入口（被 ..() 链到）
//   - /datum/virtue/utility/rpg_system/apply_to_human  RPG系统美德效果（rpg_system.dm）
//   - /datum/component/rpg_system (.points)            RPG系统驱动组件与积分字段
//   - TRAIT_RPG_SYSTEM                                 RPG系统身份特性键（rpg_system.dm 内 #define）
//   - GLOB.virtues                                     美德单例表（按类型取 rpg_system 单例）
//   - ckey                                             /mob 上已归一化的账号名（小写、去特殊字符）
//
// 加载：本文件需在 _load.dm 中、于 "virtues/rpg_system.dm" 之后 #include
//   （需在其后，才能见到 rpg_system.dm 里 #define 的 TRAIT_RPG_SYSTEM）。
//   登录触发由 account_perks/account_perks.dm 的派发器统一调用 grant_kukuling_perks()。
// ============================================================================

// 受惠账号：以 ckey 形式比较。ckey 会把账号名归一化为"全小写、去除特殊字符"，
//   故这里用小写字面量 "kukuling"。如需新增受惠账号，只改这一处常量即可。
#define RPG_SYSTEM_AUTOGRANT_CKEY "kukuling"

// grant_kukuling_perks：KUKULING 账号的"进入游戏即赠礼"逻辑，由登录派发器在每次登录时调用。
//   自带 ckey 自检：不是该账号就直接返回，所以派发器可以无条件调用、无需关心账号匹配。
/mob/living/carbon/human/proc/grant_kukuling_perks()
	// 仅对目标账号生效：ckey 是该玩家归一化后的账号名（派发器在 Login() 的 ..() 之后才调用，
	//   此刻 ckey 已绑定就绪）。不是 KUKULING 就安静返回。
	if(ckey != RPG_SYSTEM_AUTOGRANT_CKEY)
		return
	// 一次性闸门：已持有【RPG系统】就不再重复授予 / 重置积分（保护已消费的积分）。
	if(HAS_TRAIT(src, TRAIT_RPG_SYSTEM))
		return
	// 取【RPG系统】美德单例（GLOB.virtues 以类型为键存放各美德模板单例）。
	var/datum/virtue/utility/rpg_system/granted = GLOB.virtues[/datum/virtue/utility/rpg_system]
	if(!granted)
		return
	// 授予美德的完整效果：特性 + 驱动组件 + 「打开RPG系统」动词（绕过 99 凯旋点门槛）。
	granted.apply_to_human(src)
	// 取出刚挂上的驱动组件，把系统积分直接设为 999999。
	var/datum/component/rpg_system/system = GetComponent(/datum/component/rpg_system)
	if(system)
		system.points = 999999
		to_chat(src, span_nicegreen("【系统提示】检测到世界管理员权限，已为你注入 999999 系统积分。"))
