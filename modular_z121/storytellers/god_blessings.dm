// ============================================================================
// 神明的赐福事件（Blessing Event of the Gods）—— 小型惊喜版
// ----------------------------------------------------------------------------
// 需求演变（为什么是现在这个版本）：
//   初版把赐福做成了“持续到换叙述者为止”的属性增益。按最新要求改为：
//     · 每位神明的赐福要更【有辨识度】，不只是堆属性，而像一次【小小的惊喜事件】；
//     · 效果【不宜过强】（聊以助兴的彩蛋，而非战力飞跃）；
//     · 触发概率调整为【1%】。
//   因此本版把每位神的赐福重做成【一次性的、契合该神领域的小惊喜】：多为一件无足轻重
//   的应景小物、或一段轻巧的感官/情绪效果。不再常驻、也无需在换叙述者时清除。
//
// 触发时机（沿用稳健的“轮询子系统”做法，零核心改动）：
//   叙述者唯一切换点是 code 里的 set_storyteller()，但项目铁律是只能改 modular_z121。
//   故由自包含子系统 SSgod_blessings 每隔 GOD_BLESSING_POLL_INTERVAL 轮询
//   SSgamemode.current_storyteller；一旦发现【换了一位神】（含开局首次确定叙述者），
//   就对“这位神的玩家信徒”逐个以 GOD_BLESSING_CHANCE 概率掷骰，命中者获得一次小惊喜。
//
// 关于“目标选择需可优雅取消”这一通用要求在本场景下的落地（为什么这样处理）：
//   本功能是【系统自动降下】的赐福，并不存在一个交互式施法者去手动选目标，因此没有
//   “按钮可点的取消”。与之等价的稳健处理是：凡需要一个落点/目标的效果（如掉落小物），
//   都先用 get_drop_turf() 取得【有效落点】，取不到就【优雅放弃本次效果】（给玩家一句
//   提示、bestow 返回 FALSE，绝不抛错、绝不影响其他信徒）。这就是本场景里的“取消”。
//
// 错误处理（为什么到处是守卫）：
//   - 每个 bestow() 开头都校验 follower 仍有效；
//   - 掉落类统一走 give_gift()，内部校验落点、校验物品确实创建成功（QDELETED）；
//   - 子系统循环里单个信徒失败只返回 FALSE，绝不中断对其他信徒的发放；
//   - 没有对应赐福的神（如沉睡的 Psydon）自然地什么都不做。
//
// 引擎事实（均已确认，本文件只调用、不修改）：
//   - mob.patron 是 /datum/patron【实例】，其 .storyteller 字段存对应叙述者【类型路径】，
//     每位“真神” patron 都设了它（见 code/datums/gods/patrons/*）。据此匹配信徒。
//   - GLOB.player_list = 所有带客户端的 mob = 玩家，正好满足“仅限玩家”。
//   - roguecoin 的 Initialize(mapload, coin_amount) 支持 new(turf, 数量) 一次性给定面额。
//
// 遵循项目规则：仅存放于 modular_z121 之下；面向玩家文本一律中文；每段逻辑都以中文
// 注释解释“为何如此”；已在 modular_z121/_load.dm 登记。
// ============================================================================

// --- 可调常量 ---------------------------------------------------------------
// 每名信徒独立的获赐概率（百分比）。按要求设为 1%——真正的“偶遇式”小惊喜。
#define GOD_BLESSING_CHANCE 1
// 轮询叙述者是否更换的间隔。换叙述者很罕见，10 秒一次足够灵敏、开销极低。
#define GOD_BLESSING_POLL_INTERVAL (10 SECONDS)

// ============================================================================
// 赐福基类：/datum/god_blessing
// ----------------------------------------------------------------------------
// 每位神一个子类型，仅重写 bestow()。基类提供两件通用工具：
//   announce()  —— 纯感官/情绪类效果的“提示 + 应景音效”；
//   give_gift() —— 掉落小物的“选落点 + 生成 + 全场可见提示 + 音效”，自带优雅失败。
// ============================================================================
/datum/god_blessing
	// 赐福的人类可读名称，用于日志与失败提示。
	var/name = "神明的赐福"
	// 这位神的应景音效（子类型各自指定一个【已确认存在】的资源）。
	var/sound

// 赐福主体：对一名信徒施加这位神的小惊喜。返回 TRUE=成功，FALSE=优雅放弃/失败。
// 基类为抽象实现，永远返回 FALSE（防止误把基类挂进映射表时悄悄“成功”）。
/datum/god_blessing/proc/bestow(mob/living/follower)
	return FALSE

// 取一个可供掉落小物的有效落点；取不到（信徒不在地图上等）返回 null，
// 调用方据此优雅放弃——这正是本非交互场景下“目标无效则取消”的实现。
/datum/god_blessing/proc/get_drop_turf(mob/living/follower)
	// 防御：信徒已失效则无落点。
	if(QDELETED(follower))
		return null
	// get_turf 对身处容器内的信徒会回退到容器所在格，符合“掉在脚边”的预期。
	var/turf/drop = get_turf(follower)
	// 不在任何格子上（nullspace）则无处安放。
	if(!isturf(drop))
		return null
	return drop

// 通用感官/情绪效果的提示：给信徒一句中文提示，并就近播放这位神的应景音效。
/datum/god_blessing/proc/announce(mob/living/follower, message)
	if(QDELETED(follower))
		return
	to_chat(follower, span_nicegreen(message))
	// 仅对本人播放，强化“私人小惊喜”的感觉。
	if(sound)
		follower.playsound_local(follower, sound, 60, FALSE)

// 通用“掉落一件小物”的稳健流程：
//   gift_type   —— 要生成的物品类型；
//   message     —— 全场可见的中文提示（已由调用方拼好信徒名）；
//   gift_sound  —— 落地音效（可为 null）；
//   amount      —— 仅对硬币等“可叠数量”的物品传入，其它留空。
// 返回 TRUE=成功掉落，FALSE=无有效落点或生成失败（均为优雅放弃，不抛错）。
/datum/god_blessing/proc/give_gift(mob/living/follower, gift_type, message, gift_sound, amount)
	// 选落点；取不到就优雅放弃，并轻声告知信徒（等价于“目标无效，取消本次效果”）。
	var/turf/drop = get_drop_turf(follower)
	if(!drop)
		to_chat(follower, span_warning("[name]本欲降临，却寻不到落点，这份馈赠悄然消散了。"))
		return FALSE
	// 生成物品：硬币类按数量生成，其余按单件生成。
	var/obj/item/gift
	if(amount)
		gift = new gift_type(drop, amount)
	else
		gift = new gift_type(drop)
	// 防御：极端情况下物品可能在生成中即被销毁，则视为失败。
	if(QDELETED(gift))
		return FALSE
	// 全场可见提示，让旁人也能注意到这桩小奇事。
	follower.visible_message(span_nicegreen(message))
	// 就近播放落地音效（区域可闻）。
	if(gift_sound)
		playsound(drop, gift_sound, 60, TRUE)
	return TRUE

// ============================================================================
// 神圣万神殿（Divine）—— 各神的小惊喜
// ============================================================================

// --- Astrata（日光 / 秩序 / 治疗）：一缕穿云日光，闪光 + 小幅治愈 + 好心情 ----
/datum/god_blessing/astrata
	name = "Astrata 的日光"
	sound = 'sound/magic/astrata_choir.ogg'

/datum/god_blessing/astrata/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	// 金色闪光：仅有客户端者可见，子系统已保证 follower.client 存在。
	follower.flash_fullscreen("yellowflash")
	// 温和治愈：小幅修复钝/烧伤、愈合少量伤口、补一点缺氧——刻意保持“小”。
	follower.heal_overall_damage(5, 5, 0, null, FALSE)
	follower.heal_wounds(2)
	follower.adjustOxyLoss(-5, FALSE)
	follower.updatehealth()
	// 一段“受庇佑”的好心情（情绪事件本就存在于引擎中）。
	if(iscarbon(follower))
		follower.add_stress(/datum/stressevent/blessed)
	announce(follower, "一缕温暖的日光穿透云层洒在我身上，Astrata 的辉光抚平了些许伤痛。")
	return TRUE

// --- Noc（知识 / 魔法 / 书籍）：一闪灵感的低语，并落下一本无名薄册 -----------
/datum/god_blessing/noc
	name = "Noc 的启示"
	sound = 'sound/magic/bless.ogg'
	// 随机低语库：每次惊喜都念出其中一条，增添“偶得灵感”的味道。
	var/static/list/insights = list(
		"……万物皆有其名，而名字之中藏着力量。",
		"……星辰的排布并非偶然，它们是写在夜空里的文字。",
		"……最深的真理，往往就藏在最寻常的事物背后。",
		"……知识从不消亡，它只是等待着被重新想起。",
	)

/datum/god_blessing/noc/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	// 先低语一条神秘知识（感官效果），再落下一本无名之书（实物效果）。
	announce(follower, "脑海中骤然亮起一道灵光[pick(insights)]")
	return give_gift(follower, /obj/item/book, "一本无名的薄册凭空浮现，轻轻落在 [follower] 身旁。", null)

// --- Ravox（荣耀 / 战争 / 武勇）：号角回响，瞬间恢复耐力（“第二口气”）--------
/datum/god_blessing/ravox
	name = "Ravox 的战意"
	sound = 'sound/magic/holyshield.ogg'

/datum/god_blessing/ravox/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	// “第二口气”：把耐力消耗清零并刷新——小而提神，不改变战力上限。
	follower.setStaminaLoss(0, FALSE)
	follower.update_stamina()
	announce(follower, "Zericho 的号角在血脉中骤然回响，疲惫一扫而空，我重新挺直了脊背！")
	return TRUE

// --- Abyssor（流水 / 潮汐 / 渔获）：一条鱼随潮水拍在脚边 ---------------------
/datum/god_blessing/abyssor
	name = "Abyssor 的渔获"
	sound = 'sound/magic/abyssor_splash.ogg'
	// 随机鱼种库，让每次渔获都略有不同。
	var/static/list/fish_types = list(
		/obj/item/reagent_containers/food/snacks/fish/carp,
		/obj/item/reagent_containers/food/snacks/fish/cod,
	)

/datum/god_blessing/abyssor/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	return give_gift(follower, pick(fish_types), "一汪潮水凭空溅起，一条活蹦乱跳的鱼拍在了 [follower] 脚边！", 'sound/magic/abyssor_splash.ogg')

// --- Xylix（无常 / 机缘 / 幸运）：命运掷骰——半数掉几枚铜币，半数只是个玩笑 ---
/datum/god_blessing/xylix
	name = "Xylix 的机缘"
	sound = 'sound/magic/comedy.ogg'

/datum/god_blessing/xylix/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	// 50%：好运降临，落下 1~5 枚铜币。
	if(prob(50))
		return give_gift(follower, /obj/item/roguecoin/copper, "命运之轮咔哒一转，几枚铜币叮当落在 [follower] 身旁！", 'sound/magic/xylix_slip1.ogg', rand(1, 5))
	// 50%：无伤大雅的玩笑——什么也没掉，但平白生出一阵好心情（这本就是 Xylix 的趣味）。
	follower.playsound_local(follower, 'sound/magic/comedy.ogg', 60, FALSE)
	to_chat(follower, span_nicegreen("命运和我开了个小小的玩笑——什么也没发生，我却莫名想笑。"))
	if(iscarbon(follower))
		follower.add_stress(/datum/stressevent/blessed)
	return TRUE

// --- Necra（死亡 / 安宁）：坟墓般的凉意，平复毒性与心绪 ---------------------
/datum/god_blessing/necra
	name = "Necra 的安息"
	sound = 'sound/magic/psydonrespite.ogg'

/datum/god_blessing/necra/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	// 一阵沉静的凉意：驱散少量毒性（“腐朽止息”），并带来片刻心安。
	follower.adjustToxLoss(-8, FALSE)
	follower.updatehealth()
	if(iscarbon(follower))
		follower.add_stress(/datum/stressevent/blessed)
	announce(follower, "一阵腐朽却宁静的凉意漫过周身，Necra 让我的心绪归于沉静，体内的毒性也悄然褪去。")
	return TRUE

// --- Pestra（安康 / 医疗 / 炼金）：一缕药香，缝合伤口、驱散病气 -------------
/datum/god_blessing/pestra
	name = "Pestra 的良方"
	sound = 'sound/magic/churn.ogg'

/datum/god_blessing/pestra/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	// 炼金良方：愈合伤口、修复少量伤势、驱散少量毒性——温和的“小药剂”手感。
	follower.heal_overall_damage(4, 4, 0, null, FALSE)
	follower.heal_wounds(4)
	follower.adjustToxLoss(-4, FALSE)
	follower.updatehealth()
	announce(follower, "一缕清凉的炼金药香拂过，Pestra 的良方为我缝合了伤口、驱散了病气。")
	return TRUE

// --- Malum（劳作 / 锻造 / 矿井）：一声沉响，落下一块铜矿石 -------------------
/datum/god_blessing/malum
	name = "Malum 的矿藏"
	sound = 'sound/magic/clang.ogg'

/datum/god_blessing/malum/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	return give_gift(follower, /obj/item/natural/rock/copper, "随着一声沉闷的金属回响，一块铜矿石滚落在 [follower] 脚边——辛勤劳作的赏赐。", 'sound/magic/clang.ogg')

// --- Eora（爱意 / 正面）：温柔花香，一只玫瑰花冠落入怀中 + 好心情 ----------
/datum/god_blessing/eora
	name = "Eora 的爱意"
	sound = 'sound/magic/eora_bless.ogg'

/datum/god_blessing/eora/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	// 先附上一段“受 Eora 庇佑”的好心情，再落下应景的玫瑰花冠。
	if(iscarbon(follower))
		follower.add_stress(/datum/stressevent/eoran_blessing)
	return give_gift(follower, /obj/item/flowercrown/rosa, "空气里弥漫起温柔的花香，一只玫瑰花冠飘落进 [follower] 的怀中。", 'sound/magic/eora_bless.ogg')

// --- Dendor（自然 / 丰收）：晨露闪烁，一份山林的馈赠出现在身旁 -------------
/datum/god_blessing/dendor
	name = "Dendor 的馈赠"
	sound = 'sound/magic/birdsong.ogg'
	// 随机山野食材库（均为已确认存在的可生长作物）。
	var/static/list/forage = list(
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/nut,
	)

/datum/god_blessing/dendor/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	return give_gift(follower, pick(forage), "晨露在身侧闪烁，一份山林的馈赠悄然出现在 [follower] 身旁。", 'sound/magic/birdsong.ogg')

// 说明：Psydon（和平 / 沉眠）刻意【不】提供赐福——祂正沉睡、放任世界，不主动庇佑。
// 因此下方映射表中没有 Psydon 的条目（自然地不发放任何赐福）。

// ============================================================================
// 异民万神殿（Inhumen）—— 各神的小惊喜
// ============================================================================

// --- Zizo（死灵 / 进步 / 腐朽）：虚空低语，留下一根森冷白骨 -----------------
/datum/god_blessing/zizo
	name = "Zizo 的低语"
	sound = 'sound/magic/zizo_snuff.ogg'

/datum/god_blessing/zizo/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	// 先来一段阴森低语（感官），再留下一根白骨（实物，契合死灵主题）。
	announce(follower, "受诅者的低语自虚空飘来，Zizo 将一缕腐朽的力量轻触我的指尖……")
	return give_gift(follower, /obj/item/natural/bone, "一根森白的骨头凭空出现，落在 [follower] 脚边。", null)

// --- Baotha（香料 / 混沌 / 沉醉）：突如其来的微醺（温和的醉酒状态）---------
/datum/god_blessing/baotha
	name = "Baotha 的微醺"
	sound = 'sound/magic/comedy.ogg'

/datum/god_blessing/baotha/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	// 施加引擎自带的温和“醉酒”状态（INT-2/WIL+1，约 5 分钟）——轻巧的“上头”小惊喜。
	follower.apply_status_effect(/datum/status_effect/buff/drunk)
	announce(follower, "一股甜腻的酒气没来由地涌上头顶，Baotha 让我没缘由地咯咯笑起来，脚步都有些发飘。")
	return TRUE

// --- Graggar（流血 / 食人 / 征服）：血腥味中，一块生肉砸在脚边 ---------------
/datum/god_blessing/graggar
	name = "Graggar 的血食"
	sound = 'sound/magic/barbroar.ogg'

/datum/god_blessing/graggar/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	return give_gift(follower, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef, "一阵血腥味扑面而来，一块生肉重重砸在 [follower] 脚边——征服者的战利品。", 'sound/magic/barbroar.ogg')

// --- Matthios（盗窃 / 贪婪）：几枚铜币神不知鬼不觉地滑入脚边 ----------------
/datum/god_blessing/matthios
	name = "Matthios 的私囊"
	sound = 'sound/foley/coins1.ogg'

/datum/god_blessing/matthios/bestow(mob/living/follower)
	if(QDELETED(follower))
		return FALSE
	return give_gift(follower, /obj/item/roguecoin/copper, "几枚铜币神不知鬼不觉地叮当滑落在 [follower] 脚边——来路不必深究。", 'sound/foley/coins1.ogg', rand(2, 5))

// ============================================================================
// 子系统：SSgod_blessings —— 侦测叙述者更换，并对新任神明的信徒掷骰发放小惊喜
// ----------------------------------------------------------------------------
// 完全自包含于 modular_z121；不改动 code/ 下任何文件。
// ============================================================================
SUBSYSTEM_DEF(god_blessings)
	name = "God Blessings"
	// 仅游戏运行期轮询；SS_BACKGROUND 低优先后台；SS_NO_INIT 无需初始化阶段。
	runlevels = RUNLEVEL_GAME
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = GOD_BLESSING_POLL_INTERVAL
	// 赐福事件总开关，供 GameMaster 管理指令实时启用/停用。默认开启。
	// 关闭时 fire() 直接空转：不再侦测换神、也不再发放任何赐福。
	var/enabled = TRUE
	// 上一次处理过的叙述者类型；用于侦测“是否换了神”。null 起步，开局首次确定即算一次变更。
	var/last_storyteller_type
	// 叙述者类型 -> 赐福【实例】 的惰性缓存（每位神共用一个单例，避免反复 new）。
	var/list/blessing_instances = list()
	// 叙述者类型 -> 赐福【类型】 的映射（编译期类型常量初始化，static 避免每轮重建）。
	// 没有条目的神（如沉睡的 Psydon）不发放赐福。
	var/static/list/blessing_by_storyteller = list(
		// 神圣万神殿
		/datum/storyteller/astrata = /datum/god_blessing/astrata,
		/datum/storyteller/noc = /datum/god_blessing/noc,
		/datum/storyteller/ravox = /datum/god_blessing/ravox,
		/datum/storyteller/abyssor = /datum/god_blessing/abyssor,
		/datum/storyteller/xylix = /datum/god_blessing/xylix,
		/datum/storyteller/necra = /datum/god_blessing/necra,
		/datum/storyteller/pestra = /datum/god_blessing/pestra,
		/datum/storyteller/malum = /datum/god_blessing/malum,
		/datum/storyteller/eora = /datum/god_blessing/eora,
		/datum/storyteller/dendor = /datum/god_blessing/dendor,
		// Psydon 故意缺席（沉睡之神不庇佑）。
		// 异民万神殿
		/datum/storyteller/zizo = /datum/god_blessing/zizo,
		/datum/storyteller/baotha = /datum/god_blessing/baotha,
		/datum/storyteller/graggar = /datum/god_blessing/graggar,
		/datum/storyteller/matthios = /datum/god_blessing/matthios,
	)

// 每个轮询周期：侦测叙述者是否更换；换了就对新任神明的信徒掷骰发放小惊喜。
/datum/controller/subsystem/god_blessings/fire(resumed = FALSE)
	// 总开关：被 GameMaster 停用时直接空转（注意：不更新 last_storyteller_type，
	// 这样停用期间若换了神，重新启用后会“补上”当前这位神的一次掷骰）。
	if(!enabled)
		return
	// 防御：gamemode 子系统未就绪或尚无叙述者时，什么都不做。
	if(!SSgamemode)
		return
	var/datum/storyteller/current = SSgamemode.current_storyteller
	if(!current)
		return
	// 叙述者没变 -> 不重复发放（小惊喜只在“这位神开始执掌”的那一刻掷骰一次）。
	if(current.type == last_storyteller_type)
		return

	// —— 到这里说明换了一位神（或开局首次确定）——
	last_storyteller_type = current.type
	// 取这位神对应的赐福单例；没有就代表这位神不发放赐福（如 Psydon），直接结束。
	var/datum/god_blessing/blessing = get_blessing(current.type)
	if(!blessing)
		return
	// 对这位神的玩家信徒逐个掷骰发放。
	roll_blessings(blessing, current.type)

// 取某位叙述者对应的赐福单例（惰性创建并缓存）；无映射则返回 null。
/datum/controller/subsystem/god_blessings/proc/get_blessing(storyteller_type)
	var/blessing_type = blessing_by_storyteller[storyteller_type]
	if(!blessing_type)
		return null
	// 首次用到时才创建并缓存，之后复用同一个无状态单例。
	if(!blessing_instances[storyteller_type])
		blessing_instances[storyteller_type] = new blessing_type()
	return blessing_instances[storyteller_type]

// 对一位神的玩家信徒逐个以 1% 概率发放其小惊喜。
// blessing        ：该神的赐福实例；
// storyteller_type：当前叙述者类型，用来匹配“信徒”。
/datum/controller/subsystem/god_blessings/proc/roll_blessings(datum/god_blessing/blessing, storyteller_type)
	for(var/mob/living/follower in GLOB.player_list) // 仅遍历带客户端的 mob，即玩家。
		// 防御：跳过失效、无客户端或已死亡者（死者不接受赐福）。
		if(QDELETED(follower) || !follower.client || follower.stat == DEAD)
			continue
		// 必须是这位神的信徒：patron 实例上的 .storyteller 须等于当前叙述者类型。
		var/datum/patron/follower_patron = follower.patron
		if(!follower_patron || follower_patron.storyteller != storyteller_type)
			continue
		// “1% 概率”：对每名信徒独立掷骰。
		if(!prob(GOD_BLESSING_CHANCE))
			continue
		// 发放小惊喜。bestow 内部自带优雅失败：单个信徒失败只返回 FALSE，
		// 绝不抛错、也绝不影响对其他信徒的发放（错误隔离）。
		blessing.bestow(follower)

// --- 清理本文件局部的 define，避免泄漏到其它文件 ----------------------------
#undef GOD_BLESSING_CHANCE
#undef GOD_BLESSING_POLL_INTERVAL

// ============================================================================
// GameMaster 管理指令：启用 / 停用「神明的赐福」事件
// ----------------------------------------------------------------------------
// 为什么是 /client/proc 且 set category="-GameMaster-"：与本项目其它管理指令
//（如 bless、god、grandcaster）完全一致的写法；真正让它出现在 GameMaster 标签下，
// 还需把它登记进 modular_z121/bootstrap/custom_bootstrap.dm 的 get_custom_admin_verbs()
// 列表（已一并登记）。
// 为什么用“显式选择”而非盲目切换：需求是“启用与停用”两个明确动作，因此弹出一个
// 列出当前状态的「启用 / 停用」菜单，让管理员明确选定；菜单可直接关闭以取消。
// ============================================================================
/client/proc/toggle_god_blessings()
	set category = "-GameMaster-"
	set name = "Toggle God Blessings"
	set desc = "启用或停用神明的赐福事件。"

	// 权限校验：这是管理指令，必须具备管理员权限。
	if(!check_rights(R_ADMIN))
		return // check_rights 已自行给出提示，这里静默退出。

	// 防御：子系统理应在运行期存在；若因故缺失则明确报错而非静默失败。
	if(!SSgod_blessings)
		to_chat(src, span_warning("神明赐福子系统尚未就绪，无法切换。"))
		return

	// 读取当前状态，供菜单展示与“无变化”判断。
	var/currently_on = SSgod_blessings.enabled

	// 弹出“启用 / 停用”二选一菜单（菜单标题里附带当前状态）；
	// 用 null|anything 让管理员可直接关闭对话框以取消。
	var/choice = input(src, "神明赐福事件当前为：[currently_on ? "已启用" : "已停用"]。请选择：", "Toggle God Blessings") as null|anything in list("启用", "停用")
	if(!choice) // 管理员取消/关闭了对话框。
		return

	// 把选项解析成目标布尔状态。
	var/want_on = (choice == "启用")

	// 若目标状态与当前一致，则无需改动，明确告知并退出（避免冗余日志）。
	if(want_on == currently_on)
		to_chat(src, span_notice("神明赐福事件已经处于「[currently_on ? "启用" : "停用"]」状态，无需更改。"))
		return

	// 写入新状态。
	SSgod_blessings.enabled = want_on

	// 反馈 + 审计：与其它管理指令一致地记录到管理日志并广播给管理员。
	var/state_text = want_on ? "启用" : "停用"
	to_chat(src, span_notice("你已[state_text]神明的赐福事件。"))
	log_admin("[key_name(usr)] [want_on ? "enabled" : "disabled"] the God Blessings event.")
	message_admins(span_adminnotice("[key_name_admin(usr)] [want_on ? "enabled" : "disabled"] the God Blessings event."))
	// 统计埋点，便于后台分析该指令的使用情况。
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle God Blessings")
