// ============================================================================
// 献给赛利克斯的乐曲（Music dedicated to Xylix）—— 隶属于赛利克斯献祭法阵的一项仪式
// ----------------------------------------------------------------------------
// 在【已存在的】赛利克斯献祭法阵
//（`/obj/structure/ritualcircle/sacrifice/xylix`，定义于 sacrifice_circles.dm）
// 之上新增一项仪式。DM 会跨文件合并同一类型的定义，因此在这里重新打开该类型即可
// 挂上新仪式，而【无需】改动那个共享的法阵文件。
//
// 仪式流程：开场吟唱之后，赛利克斯会【随机】点名一种乐器、一支曲目，以及对演奏者
// 音乐技能等级的【随机】要求；参与者须在 2 分 23 秒（143 秒）内，在法阵上用该乐器
// 演奏起来。一旦在限时内满足全部条件，便授予“赛利克斯的青睐”：持续 30 分钟的 LCK+1，
// 且检视（examine）时会显示“赛利克斯对你的演奏感到满意”。
//
// 遵循项目规则：仅存放于 modular_z121 之下，面向玩家的文本一律使用中文，
// 每一处过程、变量与逻辑块上方都以中文注释解释其“为何如此”。
//
// 依赖项（均已在构建中，未作改动）：
//   - 仪式基础框架：modular_z121\rites\sacrifice_circles.dm
//   - 乐器：/obj/item/rogue/instrument/*（code\game\objects\items\rogueitems\instruments.dm）
//   - 演奏检测：演奏时玩家获得 /datum/status_effect/buff/playing_music，
//       且对应乐器的 var/playing 置为 TRUE（同上文件）
//   - 音乐技能：/datum/skill/misc/music；技能名 skill_to_string()（subsystem\skills.dm）
//   - 属性：STATKEY_LCK（fortune），change_stat 经由状态效果 effectedstats 自动施加/回退
// 需在 modular_z121\_load.dm 中登记（置于 sacrifice_circles.dm 之后）。
// ============================================================================

// --- 可调常量 ---------------------------------------------------------------
// 在仪式选择菜单中显示、并在分派 switch 中用于匹配的标签文本；用 define 保存，
// 使二者永远保持一致、不会悄然出现偏差。
#define XYLIX_MUSIC_RITE_NAME "献给赛利克斯的乐曲"
// 表演的限时：2 分 23 秒 = 143 秒。规格明确要求此时长。
#define XYLIX_MUSIC_TIME_LIMIT (143 SECONDS)
// 限时内对演奏条件进行轮询的间隔。1 秒足够灵敏，开销也极低。
#define XYLIX_MUSIC_POLL_INTERVAL (1 SECONDS)
// 演奏者必须距离法阵多近（以格计）才算“在法阵上”表演。1 = 站在法阵格或紧邻格。
#define XYLIX_MUSIC_PERFORM_RANGE 1
// 成功后“赛利克斯的青睐”增益持续多久。规格要求为 30 分钟。
#define XYLIX_MUSIC_BUFF_DURATION (30 MINUTES)
// 随机抽取“所要求音乐技能等级”的下限与上限（含端点）。设为新手~专家，
// 使要求有高有低、可达成但富于变化。
#define XYLIX_MUSIC_MIN_LEVEL SKILL_LEVEL_NOVICE
#define XYLIX_MUSIC_MAX_LEVEL SKILL_LEVEL_EXPERT

// 可被随机点名的乐器类型池。仅收录确认存在、且属于“手持演奏”的常见乐器
//（刻意排除嗓音 vocals 等 not_held 特例，以保证演奏检测在“手持乐器”上成立）。
// 列表中存放类型路径；显示名通过把路径赋给有类型的变量后读取其 initial(name) 取得。
GLOBAL_LIST_INIT(xylix_music_instruments, list(
	/obj/item/rogue/instrument/lute,      // 鲁特琴
	/obj/item/rogue/instrument/drum,      // 鼓
	/obj/item/rogue/instrument/harp,      // 竖琴
	/obj/item/rogue/instrument/flute,     // 长笛
	/obj/item/rogue/instrument/guitar,    // 吉他
	/obj/item/rogue/instrument/trumpet,   // 小号
	/obj/item/rogue/instrument/accord,    // 手风琴
	/obj/item/rogue/instrument/viola,     // 中提琴
	/obj/item/rogue/instrument/bagpipe,   // 风笛
	/obj/item/rogue/instrument/banjo,     // 班卓琴
	/obj/item/rogue/instrument/harmonica, // 口琴
))

// 可被随机点名的“曲目”名称池。纯属氛围文本：真正可检测的硬性条件是乐器与技能，
// 曲名只是让赛利克斯的点单更有戏剧性。
GLOBAL_LIST_INIT(xylix_music_pieces, list(
	"《愚者的圆舞曲》",
	"《假面之歌》",
	"《月下喜剧》",
	"《骗徒的小调》",
	"《无名者的颂歌》",
	"《七重诡笑》",
	"《幕落之时》",
	"《银铃般的谎言》",
))

// 重新打开赛利克斯献祭法阵以登记我们的仪式。基类 attack_hand()
//（在 sacrifice_circles.dm 中）已经强制校验 patron == Xylix、TRAIT_RITUALIST 特质、
// 每次歇息只能一次的“仪式已耗尽”冷却，并弹出选择菜单——因此我们只需提供菜单标题与仪式列表。
/obj/structure/ritualcircle/sacrifice/xylix
	// 在仪式选择输入框中显示的标题。
	ritual_title = "赛利克斯的献祭仪式"
	// 本法阵提供的仪式。日后若要新增赛利克斯仪式，只需在这里追加字符串
	//（并在下方补上对应的 switch 分支）即可。
	sacrifice_rites = list(XYLIX_MUSIC_RITE_NAME)

// 将所选仪式分派给其处理过程；在玩家从 `sacrifice_rites` 中选取条目后，
// 由基类 attack_hand() 调用。
/obj/structure/ritualcircle/sacrifice/xylix/perform_sacrifice_rite(riteselection, mob/living/user)
	switch(riteselection)
		// 将我们的仪式导向其专属过程。
		if(XYLIX_MUSIC_RITE_NAME)
			return xylix_music_rite(user)
	// 未识别的选项 -> 基类会礼貌地提示“没有这样的仪式”并退出。
	return ..()

// ----------------------------------------------------------------------------
// 仪式本体：开场吟唱 -> 随机点单 -> 启动 143 秒表演窗口。
// 表演的判定是【异步】的（横跨两分多钟），因此本过程在成功启动窗口后即返回 TRUE；
// 真正的成败由 run_performance_window() 在之后的轮询中决定。
// 在任何“开场阶段”被打断时返回 FALSE，从而不花费每日的“仪式已耗尽”冷却。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/xylix/proc/xylix_music_rite(mob/living/user)
	// --- 守卫 1：只有人类才能完成这场表演。----------------------------
	// 演奏检测依赖 held_items 与音乐技能，均假定对象为人形；其它情况明确中止。
	if(!ishuman(user))
		to_chat(user, span_smallred("唯有凡人的双手，才能为赛利克斯奏响乐曲。"))
		return FALSE
	var/mob/living/carbon/human/H = user

	// 法阵自身所在的格子即“祭祀法阵”；表演须在此附近进行。缓存它，供后续的距离判定使用。
	var/turf/altar = get_turf(src)
	if(!altar)
		// 防御性处理：没有所在格子的法阵无法作为表演场地。
		to_chat(H, span_warning("这道法阵没有立足之地，仪式无法开始。"))
		return FALSE

	// --- 守卫 2：确保乐器池非空（防御畸形的全局配置）。----
	if(!length(GLOB.xylix_music_instruments))
		to_chat(H, span_warning("赛利克斯一时想不起任何乐器，仪式无从开始。"))
		return FALSE

	// --- 开场吟唱。----------------------------------------------------
	// do_after() 若被打断（移动/眩晕）会返回 FALSE，使开场即中止、且不花费冷却。
	// 台词呼应赛利克斯的领域：诡计、戏谑与舞台表演。
	if(!do_after(H, 30, target = src))
		return FALSE
	H.say("赛利克斯啊，千面之主，戏谑与诡计的庇佑者！请赏光听我一曲。")
	playsound(altar, 'sound/misc/clownedhehe.ogg', 80, FALSE, -1)

	if(!do_after(H, 30, target = src))
		return FALSE
	H.say("请为我点一支曲子吧——我愿在你的法阵之上倾力献演！")
	playsound(altar, 'sound/misc/clownedhohoho.ogg', 80, FALSE, -1)

	// --- 随机点单：乐器、曲目、技能门槛。-----------------------------
	// 随机选一种乐器类型，并把路径赋给有类型的变量以读取其显示名（initial(name)）。
	var/instrument_type = pick(GLOB.xylix_music_instruments)
	var/obj/item/rogue/instrument/sample = instrument_type
	var/instrument_name = sample.name
	// 随机选一支曲目（纯氛围文本）。若曲目池意外为空则给个兜底名，避免空串。
	var/piece_name = length(GLOB.xylix_music_pieces) ? pick(GLOB.xylix_music_pieces) : "一支即兴小调"
	// 随机抽取所要求的音乐技能等级（含端点）。
	var/required_level = rand(XYLIX_MUSIC_MIN_LEVEL, XYLIX_MUSIC_MAX_LEVEL)

	// --- 锁定“今日仪式”额度。----------------------------------------
	// 开场已经完成、点单即将公布，视为这场仪式正式开始；就此花掉每日额度，
	// 既防止同一人在窗口期内重复开启表演，也与其它祭坛“每次歇息一次”的规则一致。
	H.apply_status_effect(/datum/status_effect/debuff/ritesexpended)

	// 点亮符文以示仪式进行中，并在短暂延迟后复用基类辅助过程将其复位。
	icon_state = "xylix_active"
	addtimer(CALLBACK(src, PROC_REF(reset_rune_state)), 120)

	// --- 向参与者公布赛利克斯的点单与限时。-------------------------
	to_chat(H, span_cultsmall("赛利克斯咧嘴一笑，向你提出要求："))
	to_chat(H, span_notice("在 [DisplayTimeText(XYLIX_MUSIC_TIME_LIMIT)] 内，于法阵之上用【[instrument_name]】演奏 [piece_name]，且你的音乐造诣不得低于【[skill_to_string(required_level)]】。"))
	altar.visible_message(span_warning("法阵边缘回荡起一阵似有若无的诡笑，仿佛某位看客正等待好戏开场。"))

	// --- 启动限时表演窗口（异步轮询）。----------------------------
	// 记录截止时刻，并立即进行第一次轮询；之后由 run_performance_window() 自行续期，
	// 直到成功或超时。所有状态都通过回调参数传递，因此即便同一法阵被多人同时使用也互不干扰。
	var/deadline = world.time + XYLIX_MUSIC_TIME_LIMIT
	run_performance_window(H, instrument_type, required_level, piece_name, deadline, altar)
	return TRUE

// ----------------------------------------------------------------------------
// 限时窗口的轮询心跳：每 XYLIX_MUSIC_POLL_INTERVAL 被调用一次。
// 满足条件 -> 发奖并结束；参与者失效 -> 静默中止；超时 -> 失败提示；否则续约下一次轮询。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/xylix/proc/run_performance_window(mob/living/user, instrument_type, required_level, piece_name, deadline, turf/altar)
	// 成功：在法阵附近、正用指定乐器演奏、且技能达标。
	if(xylix_performance_satisfied(user, instrument_type, required_level, altar))
		xylix_music_reward(user, piece_name)
		return
	// 参与者已不存在（登出/被删除等）——无人可奖，静默收场。
	if(QDELETED(user))
		return
	// 超时：限时已过，本次表演未达赛利克斯之意。
	if(world.time >= deadline)
		to_chat(user, span_warning("约定的时限悄然流逝……赛利克斯耸了耸肩，对这场演奏不置可否。"))
		return
	// 仍在窗口期内——安排下一次轮询。
	addtimer(CALLBACK(src, PROC_REF(run_performance_window), user, instrument_type, required_level, piece_name, deadline, altar), XYLIX_MUSIC_POLL_INTERVAL)

// ----------------------------------------------------------------------------
// 判定：此刻参与者是否满足全部表演条件？
// 任一条件不满足都返回 FALSE，使轮询继续等待，直到达成或超时。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/xylix/proc/xylix_performance_satisfied(mob/living/user, instrument_type, required_level, turf/altar)
	// 参与者或法阵已失效 -> 不可能成功。
	if(QDELETED(user) || QDELETED(altar))
		return FALSE
	// 必须神志清醒地活着才能演奏（昏迷/死亡都不算）。
	if(user.stat != CONSCIOUS)
		return FALSE
	// 必须在法阵之上（或紧邻）进行表演。
	if(get_dist(get_turf(user), altar) > XYLIX_MUSIC_PERFORM_RANGE)
		return FALSE
	// 必须正处于“演奏中”状态——演奏乐器会赋予 playing_music 增益。
	if(!user.has_status_effect(/datum/status_effect/buff/playing_music))
		return FALSE
	// 必须正在演奏的，恰是被点名的那种乐器。
	if(!find_playing_instrument(user, instrument_type))
		return FALSE
	// 音乐造诣必须达到被随机点名的门槛。
	if(user.get_skill_level(/datum/skill/misc/music) < required_level)
		return FALSE
	// 以上皆满足 -> 表演达标。
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：在参与者手中查找一件【正在演奏】且类型匹配的乐器，找到则返回它，否则返回 null。
// 只扫描手持物品：被点名的乐器始终是手持类（嗓音等 not_held 特例已被排除在乐器池外）。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/xylix/proc/find_playing_instrument(mob/living/user, instrument_type)
	// 遍历手持栏；for 的类型过滤会自动跳过空槽与非乐器物品。
	for(var/obj/item/rogue/instrument/instrument in user.held_items)
		// 类型不符则跳过（必须是被点名的乐器或其子类型）。
		if(!istype(instrument, instrument_type))
			continue
		// 该乐器当前正处于演奏状态（attack_self 演奏时会把 playing 置为 TRUE）。
		if(instrument.playing)
			return instrument
	return null

// ----------------------------------------------------------------------------
// 发奖：表演达标时调用一次，授予“赛利克斯的青睐”并给出满意之辞。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/xylix/proc/xylix_music_reward(mob/living/user, piece_name)
	// 防御性处理：参与者可能在心跳间隙失效。
	if(QDELETED(user))
		return
	// 授予增益：30 分钟 LCK+1（属性的施加/回退由状态效果的 effectedstats 自动处理）。
	user.apply_status_effect(/datum/status_effect/buff/xylix_performance)
	// 表演成功的视觉与气氛表现。
	user.visible_message(span_notice("[user] 的 [piece_name] 余音绕梁，四下里爆发出一阵无主的喝彩与诡笑！"), span_green("一阵畅快的暖流涌上心头——赛利克斯被我的演奏取悦了。"))
	playsound(get_turf(user), 'sound/magic/mockery.ogg', 80, FALSE, -1)
	// 规格要求的满意提示语。
	to_chat(user, span_nicegreen("赛利克斯对你的演奏感到满意。"))

// ============================================================================
// “赛利克斯的青睐”增益：30 分钟内 LCK+1。
// 采用基类的静态 effectedstats 机制：在 on_apply 时自动施加 +1 fortune（并在 1..20 间夹取），
// 到期/移除时自动回退，无需我们手动管理属性，避免数值漂移。
// ============================================================================
/datum/status_effect/buff/xylix_performance
	// 稳定的 id，使 has_status_effect()/remove_status_effect() 能找到它。
	id = "xylix_performance"
	// 规格要求的持续时间：30 分钟。
	duration = XYLIX_MUSIC_BUFF_DURATION
	// 再次成功表演会刷新计时（而非叠加），避免重复施加属性。
	status_type = STATUS_EFFECT_REFRESH
	// HUD 提示图标，复用一个已确认存在、且主题契合（戏谑者之乐/好运）的提示贴图。
	alert_type = /atom/movable/screen/alert/status_effect/buff/xylix_performance
	// 规格要求：检视（examine）持有者时显示此句。
	examine_text = "<span class='notice'>赛利克斯对你的演奏感到满意。</span>"
	// 增益效果本体：LCK（fortune）+1。基类会在 on_apply 施加、on_remove/be_replaced 回退。
	effectedstats = list(STATKEY_LCK = 1)

// 持有该增益期间显示的 HUD 提示图标。
/atom/movable/screen/alert/status_effect/buff/xylix_performance
	name = "赛利克斯的青睐"
	desc = "我为赛利克斯献上了一曲，他报以好运的微笑。"
	icon_state = "joy"

// --- 清理本文件局部的 define，避免它们泄漏到其它文件中 ---------
#undef XYLIX_MUSIC_RITE_NAME
#undef XYLIX_MUSIC_TIME_LIMIT
#undef XYLIX_MUSIC_POLL_INTERVAL
#undef XYLIX_MUSIC_PERFORM_RANGE
#undef XYLIX_MUSIC_BUFF_DURATION
#undef XYLIX_MUSIC_MIN_LEVEL
#undef XYLIX_MUSIC_MAX_LEVEL
