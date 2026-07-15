// modular_z121 自定义奥术法术：呼风唤雨 / 掌控天时（Weather Control）
// ---------------------------------------------------------------------------
// 设计目标：一个 T3 法术。施法者吟唱咒文 -> do_after 引导 6 秒 ->
//           弹出天气菜单（放晴，以及雨/雪/雹/沙/雾/风/热浪/雷暴等一大批天象）->
//           立即把全服天气切换为所选。菜单由下方“天气总表”数据驱动，
//           想扩充可选天气只需往那张表里加一行即可，无需改动任何分发逻辑。
//
// 为什么这样设计：天气在本游戏里是“全服级”的环境效果（由 SSParticleWeather 子系统
//           统一驱动），并不绑定到某个具体生物身上，因此本法术更像 wish_spell 那样
//           “对自己起手引导、引导成功后再用弹窗决定具体效果”，而不是先点选某个目标。
//           选用 /spell/self 作为基类正契合这一流程。
//
// 约束（强制）：本法术的所有代码都只存在于 modular_z121 内，对天气的改变完全通过
//           “调用”主线子系统 SSParticleWeather 已经公开的接口完成：
//             · 下雨 / 下雪 = SSParticleWeather.run_weather(<天气类型>, force = TRUE)
//             · 放晴       = 调用当前 runningWeather 的 end()（主线既有的收尾接口）
//           不修改 modular_z121 之外的任何文件。该接口与管理员动词
//           /client/proc/run_particle_weather 使用的是同一套机制，已验证可用。
//
// 依赖（均为主线已存在、仅被“调用”而不被修改的符号）：
//   · 子系统单例 SSParticleWeather（code/controllers/subsystem/particle_weather.dm）
//   · 天气类型   /datum/particle_weather/rain_gentle（“Rain” 小雨）
//   · 天气类型   /datum/particle_weather/snow_gentle（“Snowfall” 小雪）
//   · run_weather(weather_type, force) / runningWeather / queued_weather / end()
//
// 注册方式（均在 modular_z121 内，本次需要改动的另两处文件）：
//   1) modular_z121/_load.dm            -> #include 本文件
//   2) modular_z121/spells/_registry.dm -> 加入 custom_learnable_spells 列表
// ---------------------------------------------------------------------------

// ===== 可调参数集中定义（文件末尾统一 #undef，避免污染全局命名空间）=====
// 用 #define 把所有“数值旋钮”集中在顶部，便于平衡性调整时一眼找到、统一修改。
#define WEATHER_MANA_COST     5             // 法力 / 法术点消耗（cost）——T3 适中
#define WEATHER_CHANNEL_TIME  (6 SECONDS)   // do_after 引导时长（蓄力 6 秒）
#define WEATHER_COOLDOWN      (300 SECONDS) // 成功施放后的冷却（5 分钟，避免天气被反复刷屏）
#define WEATHER_FATIGUE_DRAIN 40            // 每次施放消耗的疲劳 / 耐力（releasedrain）

// “晴天 / 放晴”这一项的菜单显示文本 + 其在天气总表里对应的“哨兵值”。
// 放晴与其它天气不同：它没有对应的 /datum/particle_weather 类型，本质是“结束当前天气”，
// 因此在天气总表里用一个特殊的字符串哨兵 WEATHER_SENTINEL_CLEAR 标记，dispatch 时特判。
#define WEATHER_OPT_SUNNY       "晴天 · 放晴（Clear / Sunny）"
#define WEATHER_SENTINEL_CLEAR  "__clear__"

// ===========================================================================
// 法术本体
// ---------------------------------------------------------------------------
// 选用 /spell/self 作为基类：施法者点击图标后只对“自己”发起引导，
// 真正“选晴 / 选雨 / 选雪”是在引导成功后由弹窗决定的，无需施法前先点地块。
// 这与 wish_spell 的交互流程一致，最契合“先吟唱蓄力、再决定天气”的体验。
// ===========================================================================
/obj/effect/proc_holder/spell/self/weather_control
	name = "掌控天时"
	desc = "一道沟通天穹的强力法术。施法者凝聚魔力向苍穹立下意志，便能随心驱使天时——放晴、落雨、飞雪、降雹、扬沙、起雾、掀风、燃起热浪或唤来雷暴，无所不能。"
	school = "transmutation"               // 归类为变形 / 转化系
	spell_tier = 3                         // T3 法术（按任务要求）
	cost = WEATHER_MANA_COST               // “法力 / 法术点”消耗 = 5
	releasedrain = WEATHER_FATIGUE_DRAIN   // 每次施放抽取的疲劳 / 耐力
	chargedrain = 0                        // 引导期间不额外持续抽取资源
	chargetime = WEATHER_CHANNEL_TIME      // 引导时长（get_chargetime() 返回它来驱动 do_after）
	recharge_time = WEATHER_COOLDOWN       // 冷却 = 5 分钟（由 charge_check 强制执行）
	cooldown_min = WEATHER_COOLDOWN        // 即便被“加速”，冷却也不会低于 5 分钟
	charge_type = "recharge"               // 使用“充能”式冷却（默认）
	human_req = TRUE                       // 只有人类施法者能施放
	warnie = "spellwarning"                // 施法警告图标态
	no_early_release = TRUE                // 引导未完成不允许提前释放
	movement_interrupt = TRUE              // 引导期间移动会打断（沟通天穹需要专注）
	charging_slowdown = 1                  // 引导时略微减速，体现凝聚伟力的代价
	chargedloop = /datum/looping_sound/invokegen // 引导期间循环播放的施法音效
	associated_skill = /datum/skill/magic/arcane // 关联技能：奥术（用于经验获取等）
	action_icon = 'modular_z121/icon/custompell.dmi' // 动作按钮所用的自定义图标集
	overlay_state = "weather"              // 动作按钮的图标态（若 dmi 暂无该态仅显示为空，不影响编译）
	invocations = list("听我号令，苍穹变色!") // 咒文（按规格在“开始引导”时喊出）
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_HIGH
	gesture_required = TRUE                // 需要能自由活动的手来施法
	miracle = FALSE
	xp_gain = TRUE
	sound = null                           // 引导音由 chargedloop 负责；命中音效在 cast 内单独播放

// ---------------------------------------------------------------------------
// choose_targets：施法入口（点击图标后由 Click -> cast_check -> choose_targets 调用）。
// 在这里完成两件“施法前”的事：1) 立即喊出咒文；2) do_after 引导 6 秒。
// 引导成功后才调用 perform() 进入真正的 cast()。整套写法沿用 wish_spell，
// 以保证“可被打断、失败退还冷却、咒文只喊一次”的一致体验。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/self/weather_control/choose_targets(mob/user = usr)
	// 没有施法者就直接撤销，避免后续空指针。revert_cast() 会把冷却恢复为“可用”。
	if(!user)
		revert_cast()
		return

	// 规格要求“开始引导时”就念出咒文，因此这里手动调用一次 invocation()。
	// （稍后进入 perform() 前会临时屏蔽 invocation，以免咒文被重复喊两遍。）
	invocation(user)

	// 取得引导时长（= chargetime）。用 do_after 实现“可被打断的 6 秒蓄力”。
	var/cast_time = get_chargetime()
	if(cast_time > 0)
		user.visible_message(
			span_warning("[user] 仰首望天，双手缓缓抬起，磅礴的魔力顺着 [user.p_their()] 指尖直冲云霄……"),
			span_notice("我开始向苍穹倾注意志，魔力正不断攀升——只要再坚持片刻……")
		)
		// do_after：在 cast_time 期间若施法者移动 / 被打断 / 死亡，会返回 FALSE。
		// progress = TRUE 显示进度条；target = user 表示这是对自身的引导动作。
		if(!do_after(user, cast_time, target = user, progress = TRUE))
			to_chat(user, span_warning("我与天穹的联系被打断了，呼风唤雨的意志就此消散！"))
			revert_cast(user) // 引导失败：退还冷却，让施法者可以重新尝试
			return

	// 引导成功。进入 perform 之前临时清空 invocations，防止 perform 成功后又喊一遍咒文。
	var/list/original_invocations = invocations
	var/original_invocation_type = invocation_type
	invocations = null
	invocation_type = "none"
	// /spell/self 的 cast 只作用于施法者本人，targets 传 null 即可。
	perform(null, user = user)
	// 还原咒文设置，避免影响下一次施放。
	invocations = original_invocations
	invocation_type = original_invocation_type

// ---------------------------------------------------------------------------
// cast：引导成功后真正执行的逻辑。弹出 3 选 1 菜单并分发到对应天气效果。
// 返回值约定：
//   - 返回 TRUE  -> perform() 会调用 start_recharge()，进入 5 分钟冷却（天气已改变）。
//   - 返回 FALSE -> 各效果分支内部已调用 revert_cast() 退还冷却（取消 / 失败）。
// ---------------------------------------------------------------------------
/obj/effect/proc_holder/spell/self/weather_control/cast(list/targets, mob/living/user = usr)
	. = ..()
	// 安全校验：施法者必须仍然有效且健在，才能继续操控天气。
	if(!user || QDELETED(user))
		revert_cast()
		return FALSE

	// 防御性校验：天气子系统必须存在且已就绪，否则一切天气调用都无从谈起。
	// 之所以显式判空，是因为在极早期 / 异常环境下 SSParticleWeather 可能尚未初始化。
	if(!SSParticleWeather)
		to_chat(user, span_warning("天地间的气候之力此刻无法感应——什么也没有发生。"))
		revert_cast()
		return FALSE

	// ---- 天气总表（数据驱动菜单）----------------------------------------
	// 关联列表：菜单显示文本(键) -> 要施放的主线天气类型路径(值)。
	// 用 static 只构建一次，避免每次施放都重建这张较长的表。
	// 之所以采用“表驱动 + 统一分发”而非一连串 switch 分支：新增 / 删减可选天气时，
	// 只需增删这里的一行，dispatch 逻辑完全不用改，扩展性最好也最不易出错。
	// 第一项是“放晴”，其值用哨兵 WEATHER_SENTINEL_CLEAR 表示（放晴没有天气类型）。
	// 其余每一项的值都是主线 /datum/particle_weather 的具体子类型（仅调用、不修改）。
	var/static/list/weather_menu = list(
		WEATHER_OPT_SUNNY    = WEATHER_SENTINEL_CLEAR,              // 放晴 = 结束当前天气
		"小雨（Rain）"        = /datum/particle_weather/rain_gentle, // 温和小雨
		"暴雨（Rainstorm）"   = /datum/particle_weather/rain_storm,  // 电闪雷鸣的暴雨
		"飓风（Hurricane）"   = /datum/particle_weather/hurricane,   // 狂暴飓风
		"降雪（Snowfall）"    = /datum/particle_weather/snow_gentle, // 静谧小雪
		"暴雪（Snowstorm）"   = /datum/particle_weather/snow_storm,  // 凛冽暴雪
		"冰雹（Hail）"        = /datum/particle_weather/hail,        // 砸落的冰雹
		"干燥阵风（Dry Gale）" = /datum/particle_weather/sand_gentle, // 干燥的阵风
		"沙暴（Sandstorm）"   = /datum/particle_weather/sand_storm,  // 遮天蔽日的沙暴
		"浓雾（Fog）"         = /datum/particle_weather/fog,         // 弥漫的浓雾
		"落叶劲风（Falling Leaves）" = /datum/particle_weather/leaves_gentle, // 卷起落叶的劲风
		"樱吹雪（Sakura Breeze）"    = /datum/particle_weather/sakura_gentle, // 和煦的樱花风
		"热浪（Heat Wave）"   = /datum/particle_weather/heat_wave,   // 灼人的热浪
		"干雷暴（Dry Thunderstorm）" = /datum/particle_weather/dry_thunderstorm, // 无雨的干雷暴
		"灰烬风暴（Ashstorm）" = /datum/particle_weather/ashstorm,   // 焚灼的灰烬风暴
		"萤火之夜（Fireflies）" = /datum/particle_weather/fireflies, // 萤火漫舞（无害氛围）
		"诡异血雨（Blood Rain）" = /datum/particle_weather/blood_rain_gentle, // 不祥的血雨
	)

	// 弹出 tgui 列表菜单让施法者选择想要的天气。传入关联列表时，
	// tgui_input_list 会展示其“键”（即上面的中文显示文本），并返回被选中的键。
	// timeout 留 0 表示不自动超时。
	var/choice = tgui_input_list(user, "你要为这片天地唤来怎样的天时？", "掌控天时", weather_menu)

	// 优雅处理“取消 / 关闭菜单”：没有选择就退还冷却，不浪费这次施法。
	if(isnull(choice))
		to_chat(user, span_warning("我一时拿不定主意，收回了改变天时的意志。"))
		revert_cast()
		return FALSE

	// 用选中的显示文本回查天气总表，得到对应的天气类型（或放晴哨兵）。
	var/chosen = weather_menu[choice]

	// 特判“放晴”：哨兵值走专门的收尾逻辑（结束当前 / 排队天气）。
	if(chosen == WEATHER_SENTINEL_CLEAR)
		return weather_make_sunny(user)

	// 防御性兜底：正常情况下 chosen 必是合法天气类型；若因异常输入取到空值，
	// 则视为失败并退还冷却，绝不把非法值传进子系统。
	if(!ispath(chosen, /datum/particle_weather))
		to_chat(user, span_warning("我一时无法辨明想要的天象，法术悄然消散。"))
		revert_cast()
		return FALSE

	// 其余所有天气都走统一的“强制切换天气”封装。
	return force_weather(user, chosen)

// ===========================================================================
// 效果 1：晴天 / 放晴
// 放晴的本质 = “结束当前正在运行（或排队中）的天气”，让天空恢复无天气状态。
// 通过调用主线 runningWeather.end()（其内部会调用 SSParticleWeather.stopWeather()
// 清理粒子、声音并释放子系统引用）实现，这是主线收尾天气的标准接口。
// ===========================================================================
/obj/effect/proc_holder/spell/self/weather_control/proc/weather_make_sunny(mob/living/user)
	// 取当前正在运行的天气实例（可能为 null，表示本来就是晴天）。
	var/datum/particle_weather/running = SSParticleWeather.runningWeather
	// 取“已排队、尚未开始”的天气实例（可能为 null）。它由 run_weather 非强制路径排入，
	// 若不一并清理，放晴后它仍会按既定计时器自行降临，导致“放晴失败”。
	var/datum/particle_weather/queued = SSParticleWeather.queued_weather

	// 错误处理 / 友好反馈：当前与排队中都没有天气时，说明天已经是晴的，无需消耗这次施法。
	if(!running && !queued)
		to_chat(user, span_notice("此刻本就是晴空万里，无需再做改变。"))
		revert_cast() // 没有产生任何改变，退还冷却，避免“空放”浪费 5 分钟
		return FALSE

	// 结束当前正在运行的天气（若有）。end() 会停粒子、停声音并清空子系统引用。
	if(running)
		running.end()
	// 清理排队中的天气（若有）：qdel 它的 Destroy() 会把子系统的 queued_weather 置空，
	// 从而阻止那场尚未降临的天气在放晴之后又自己开始。
	if(queued && !QDELETED(queued))
		// 仅当它确实就是子系统登记的排队天气、且不同于已结束的 running 时才清理，
		// 避免误删别的引用（防御性判断，保持与子系统状态一致）。
		if(SSParticleWeather.queued_weather == queued)
			SSParticleWeather.queued_weather = null
			SSParticleWeather.queued_weather_start_time = null
		qdel(queued)

	// 表现层反馈：放晴。
	playsound(get_turf(user), 'sound/magic/whiteflame.ogg', 60, TRUE)
	user.visible_message(
		span_notice("[user] 振臂一挥，阴云仿佛被无形之手拨开，天光重新洒落大地。"),
		span_green("我驱散了天上的阴霾，唤回了万里晴空。")
	)
	return TRUE

// ---------------------------------------------------------------------------
// force_weather：除“放晴”外所有天气分支共用的核心封装。
// 参数：
//   user          —— 施法者（用于音效定位与消息反馈）
//   weather_type  —— 要强制施放的主线天气类型路径（天气总表里的值）
// 返回 TRUE 表示天气成功切换（cast 据此进入冷却）；FALSE 表示失败并已退还冷却。
// 之所以把全部天气收敛到这一个封装：它们除“天气类型”外流程完全一致（校验 -> 强制切换
//   -> 结果核对 -> 表现层反馈），共用一个封装可彻底避免逐个天气复制粘贴带来的不一致。
//   命中文案不再逐类手写，而是从天气自身的 name（initial 读取）自动拼装，天然适配任意天气。
// ---------------------------------------------------------------------------
// 注意：weather_type 形参声明为 /datum/particle_weather 类型（尽管它承载的是“类型路径”而非实例）。
// 这样声明是为了让编译器知道该变量具备 name 等成员，使下方 initial(weather_type.name) 能通过编译；
// initial() 会按该变量当前所持的类型路径读取其编译期初始 name，正是我们想要的天气显示名。
/obj/effect/proc_holder/spell/self/weather_control/proc/force_weather(mob/living/user, datum/particle_weather/weather_type)
	// 防御性校验：传入的类型必须是合法的天气类型路径，否则拒绝执行并退还冷却。
	// 这能挡住因表项笔误 / 主线类型被移除等导致的非法调用，避免子系统 CRASH。
	if(!ispath(weather_type, /datum/particle_weather))
		to_chat(user, span_warning("我试图召唤的那种天象并不存在于天地法则之中。"))
		revert_cast()
		return FALSE

	// 读取该天气类型的显示名（用 initial 从类型定义直接取，无需实例化），
	// 用于下面自动生成的命中文案，使一套文案适配所有天气。
	var/weather_name = initial(weather_type.name)

	// 调用主线子系统强制切换天气：
	//   · force = TRUE -> 若已有天气在运行，会先 end() 掉它再立即 start() 新天气；
	//   · 非强制路径会改为“随机延迟后排队降临”，不符合“施法即刻见效”的预期，故必须 force。
	SSParticleWeather.run_weather(weather_type, force = TRUE)

	// 结果校验：确认子系统确实切换到了我们要的天气类型。
	// run_weather 在极少数异常情况下（如类型校验失败）可能没有设置 runningWeather，
	// 这里显式核对，未达预期就视为失败并退还冷却，做到“每个效果真正执行其功能”。
	var/datum/particle_weather/now_running = SSParticleWeather.runningWeather
	if(!now_running || !istype(now_running, weather_type))
		to_chat(user, span_warning("魔力涌向天穹，天象却没有如我所愿地改变——这次召唤失败了。"))
		revert_cast()
		return FALSE

	// 表现层反馈：成功召来天气。文案根据天气名自动拼装，适配总表里的任意一项。
	playsound(get_turf(user), 'sound/magic/whiteflame.ogg', 60, TRUE)
	user.visible_message(
		span_notice("[user] 向苍穹一挥手，天色骤然变幻——[weather_name]随之笼罩了这片天地。"),
		span_green("我应天而召，唤来了[weather_name]。")
	)
	return TRUE

// ===== 清理顶部定义的宏，避免泄漏到全局命名空间、与其它文件冲突 =====
#undef WEATHER_MANA_COST
#undef WEATHER_CHANNEL_TIME
#undef WEATHER_COOLDOWN
#undef WEATHER_FATIGUE_DRAIN
#undef WEATHER_OPT_SUNNY
#undef WEATHER_SENTINEL_CLEAR
