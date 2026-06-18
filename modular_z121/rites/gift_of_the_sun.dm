// ============================================================================
// 太阳的馈赠（The Gift of the Sun）—— 隶属于阿斯特拉塔献祭法阵的一项仪式
// ----------------------------------------------------------------------------
// 在【已存在的】阿斯特拉塔献祭法阵
//（`/obj/structure/ritualcircle/sacrifice/astrata`，定义于 sacrifice_circles.dm）
// 之上新增一项仪式。DM 会跨文件合并同一类型的定义，因此在这里重新打开该类型即可
// 挂上新仪式，而【无需】改动那个共享的法阵文件。
//
// 该仪式消耗放在法阵格子上的 1 朗兹（红宝石）+ 1 萨菲拉（蓝宝石/violet）+ 1 钻石，
// 随后给予主持者一项永久特性“太阳的馈赠”：仅在【白昼期间】，将其意志与体质各 +2。
// 入夜后该加成会悄然撤除，并在下一个黎明再次回归，只要该特性仍被持有便循环往复。
//
// 材料的传说名 -> 具体类型路径（已在本代码库中确认）：
//   朗兹 Rontz   = /obj/item/roguegem/ruby     （statrontz 戒指使用 ruby 贴图）
//   萨菲拉 Safira = /obj/item/roguegem/violet   （sapphire 戒指熔炼后得到 violet 宝石）
//   钻石 diamond  = /obj/item/roguegem/diamond
//
// 遵循项目规则：仅存放于 modular_z121 之下，面向玩家的文本一律使用中文，
// 每一行都以注释解释其“为何如此”。
//
// 依赖项（均已在构建中，未作改动）：
//   - 仪式基础框架：modular_z121\rites\sacrifice_circles.dm
//   - GLOB.tod 昼夜字符串（code\controllers\subsystem\nightshift.dm）
//   - change_stat()/STATKEY_*（code\modules\mob\living\stats.dm, __DEFINES\mobs.dm）
//   - 状态效果基类（code\datums\status_effects\status_effect.dm）
// 需在 modular_z121\_load.dm 中登记（置于 sacrifice_circles.dm 之后）。
// ============================================================================

// --- 可调常量 ---------------------------------------------------------------
// 在仪式选择菜单中显示、并在分派 switch 中用于匹配的标签文本。用 define 保存，
// 使二者永远保持一致、不会悄然出现偏差。
#define GIFT_OF_THE_SUN_RITE_NAME "太阳的馈赠"
// 白昼期间，该馈赠为意志与体质各增加多少。命名它，使“各 +2”的需求自带说明，
// 且只在唯一一处调整。
#define GIFT_OF_THE_SUN_STAT_BONUS 2

// 重新打开阿斯特拉塔献祭法阵以登记我们的仪式。基类 attack_hand()
//（在 sacrifice_circles.dm 中）已经强制校验 patron == Astrata、TRAIT_RITUALIST 特质、
// 每次歇息只能一次的“仪式已耗尽”冷却，并弹出选择菜单——因此我们只需提供菜单标题与仪式列表。
/obj/structure/ritualcircle/sacrifice/astrata
	// 在仪式选择输入框中显示的标题。
	ritual_title = "阿斯特拉塔的献祭仪式"
	// 本法阵提供的仪式。日后若要新增阿斯特拉塔仪式，只需在这里追加字符串
	//（并在下方补上对应的 switch 分支）即可。
	sacrifice_rites = list(GIFT_OF_THE_SUN_RITE_NAME)

// 将所选仪式分派给其处理过程；在玩家从 `sacrifice_rites` 中选取条目后，
// 由基类 attack_hand() 调用。
/obj/structure/ritualcircle/sacrifice/astrata/perform_sacrifice_rite(riteselection, mob/living/user)
	switch(riteselection)
		// 将我们的仪式导向其专属过程。
		if(GIFT_OF_THE_SUN_RITE_NAME)
			return gift_of_the_sun_rite(user)
	// 未识别的选项 -> 基类会礼貌地提示“没有这样的仪式”并退出。
	return ..()

// ----------------------------------------------------------------------------
// 仪式本体。
// 仅在仪式完整完成时返回 TRUE；任何中止/失败都返回 FALSE，从而不消耗任何东西、
// 也不提前花掉每日的“仪式已耗尽”冷却（基类仅在本过程内成功时才标记其耗尽）。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/astrata/proc/gift_of_the_sun_rite(mob/living/user)
	// --- 守卫 1：只有人类才能承载这份馈赠。----------------------------
	// 该增益会操作 carbon/human 的属性，并假定持有者为人形；遇到其它任何情况
	//（某只动物/构造体不知怎么触发了法阵）都明确地中止。
	if(!ishuman(user))
		to_chat(user, span_smallred("唯有凡人之躯，才能承接阿斯特拉塔的赐福。"))
		return FALSE
	var/mob/living/carbon/human/H = user

	// 法阵自身所在的格子即“祭祀法阵”；祭品就摆放在这里。缓存它，使下方每次扫描
	// 内容物时都查看同一个、正确的格子。
	var/turf/altar = get_turf(src)
	if(!altar)
		// 防御性处理：没有所在格子的法阵无法承放祭品。
		to_chat(H, span_warning("这道法阵无处安放祭品，仪式无法开始。"))
		return FALSE

	// --- 守卫 2：拒绝毫无意义的献祭。------------------------------
	// 该馈赠是永久的；重复授予只会白白浪费三颗珍贵宝石，因此尽早中止并为玩家保留祭品。
	if(H.has_status_effect(/datum/status_effect/buff/gift_of_the_sun))
		to_chat(H, span_notice("阳光的馈赠早已栖居在我体内，无需再次祈求。"))
		return FALSE

	// --- 守卫 3：在漫长吟唱【之前】确认三颗宝石都齐备。----
	// 提前检查，免得让玩家站着念完咒，最后才被告知缺了某颗宝石。
	if(!has_required_offerings(altar, H))
		return FALSE // has_required_offerings() 已经报告了缺失之物。

	// --- 吟唱阶段。----------------------------------------------------
	// 若使用者移动/被打断，do_after() 会返回 FALSE；每一阶段都重新确认宝石仍在，
	// 因此走开（或被人顺走一颗宝石）都会干净地中止、不消耗任何东西。
	// 这些台词呼应阿斯特拉塔的领域：白昼、太阳与绝对秩序。
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("阿斯特拉塔啊，白昼与太阳的至高之主！请垂顾你的仆从。")
	playsound(altar, 'sound/magic/holyshield.ogg', 80, FALSE, -1)

	// 继续之前重新校验（等待期间世界状态可能已经改变）。
	if(!has_required_offerings(altar, H))
		return FALSE
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("我献上红宝石、蓝宝石与钻石，愿它们如群星般在你的日光中燃尽。")
	playsound(altar, 'sound/magic/holyshield.ogg', 80, FALSE, -1)

	if(!has_required_offerings(altar, H))
		return FALSE
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("请将白昼的伟力倾注于我，让我的意志与体魄沐浴于你的荣光！")
	to_chat(H, span_danger("一股温暖的金光自头顶倾泻而下，渗入你的四肢百骸……"))

	// 收尾前最后一段较短的停顿，让高潮显得郑重而有意为之。
	if(!do_after(H, 30, target = src))
		return FALSE

	// --- 最终检查 + 消耗祭品。--------------------------------
	// 在拿取任何东西之前进行权威校验，使消耗绝不会在已残缺的法阵上执行。
	if(!has_required_offerings(altar, H))
		return FALSE
	// 原子化地各移除一颗宝石；若以某种方式失败，则中止授予。
	if(!consume_required_offerings(altar))
		to_chat(H, span_warning("祭品在最后一刻散落，仪式功亏一篑。"))
		return FALSE

	// --- 仪式成功的视觉与气氛表现。----------------------------
	icon_state = "astrata_active" // 魔法生效期间点亮符文。
	altar.visible_message(span_warning("法阵骤然迸发出刺目的金光，三颗宝石在白昼的烈焰中化为齑粉，[H] 仿佛被太阳本身拥入怀中！"))
	playsound(altar, 'sound/magic/holyshield.ogg', 100, FALSE, -1)
	H.flash_fullscreen("yellowflash") // 与咒文相呼应的、太阳般明亮的闪光。

	// --- 授予这项永久的、随昼夜变化的特性。--------------------------
	// apply_status_effect 负责处理增益的生命周期；该效果本身每隔几秒便自行判断当前
	// 是否应当激活 +2/+2（白昼）或撤除（夜晚）。详见下方 /datum/status_effect/buff/gift_of_the_sun。
	H.apply_status_effect(/datum/status_effect/buff/gift_of_the_sun)

	// 既然仪式已真正成功，就此花掉每日的仪式额度（与其它祭坛采用同一规则），
	// 使主持者必须先歇息才能进行下一次。
	H.apply_status_effect(/datum/status_effect/debuff/ritesexpended)

	// 给主持者的收尾确认。
	to_chat(H, span_nicegreen("阿斯特拉塔收下了这场献祭。「太阳的馈赠」已铭刻于你：白昼之下，你的意志与体魄都将更胜往常。"))

	// 短暂延迟后把符文重置回静默状态，复用基类辅助过程，使时机与其它祭坛保持一致。
	addtimer(CALLBACK(src, PROC_REF(reset_rune_state)), 120)
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：三颗所需宝石是否都摆在法阵格子上？
// `complain` 默认开启，使主流程能在一次调用中同时【检查】并【报告】；
// 它会列出每一颗缺失的宝石，让玩家清楚知道还需补放什么。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/astrata/proc/has_required_offerings(turf/altar, mob/living/user, complain = TRUE)
	// 防御性处理：没有格子就没有祭品。
	if(!altar)
		return FALSE
	// `locate(类型) in 格子` 会返回第一个匹配的宝石（基于 istype）。这三颗宝石都是
	// /obj/item/roguegem 之下的同级类型（blood_diamond 是它【自己】的同级类型，
	// 【并非】 diamond 的子类型），因此彼此之间不会被误匹配。
	var/obj/item/roguegem/ruby/rontz_gem = locate() in altar      // 朗兹 Rontz
	var/obj/item/roguegem/violet/safira_gem = locate() in altar   // 萨菲拉 Safira（蓝宝石）
	var/obj/item/roguegem/diamond/diamond_gem = locate() in altar // 钻石 diamond

	// 收集所有缺失之物的名称，以便给出清晰、可操作的反馈。
	var/list/missing = list()
	if(!rontz_gem)
		missing += "朗兹宝石（红宝石）"
	if(!safira_gem)
		missing += "萨菲拉宝石（蓝宝石）"
	if(!diamond_gem)
		missing += "钻石"

	// 有任何缺失 -> 视情况说明，然后报告失败。
	if(length(missing))
		if(complain && user)
			// 使用中文分隔符，使拼接后的列表在句中读起来自然
			//（english_list 默认使用 " and "/", "）。
			to_chat(user, span_smallred("法阵上还缺少献祭所需之物：[english_list(missing, and_text = "、", comma_text = "、")]。需各放上一颗朗兹（红宝石）、萨菲拉（蓝宝石）与钻石。"))
		return FALSE
	// 三颗皆已齐备。
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：从法阵格子上各移除【恰好一颗】所需宝石。
// 仅在三颗全部找到并删除时返回 TRUE；一旦有任何短缺，便停止并返回 FALSE，
// 使调用方能够中止而不会发生部分消耗。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/astrata/proc/consume_required_offerings(turf/altar)
	if(!altar)
		return FALSE
	// 在消耗的那一刻重新定位（不要信任先前捕获的引用——它们在吟唱期间可能已被移动或 qdel）。
	var/obj/item/roguegem/ruby/rontz_gem = locate() in altar
	var/obj/item/roguegem/violet/safira_gem = locate() in altar
	var/obj/item/roguegem/diamond/diamond_gem = locate() in altar
	// 此刻若有任何一颗已不存在，便拒绝消耗其余的。
	if(!rontz_gem || !safira_gem || !diamond_gem)
		return FALSE
	// 全部齐备 -> 各销毁一颗。qdel 会干净地将它们从格子上移除。
	qdel(rontz_gem)
	qdel(safira_gem)
	qdel(diamond_gem)
	return TRUE

// ============================================================================
// “太阳的馈赠”特性，实现为一个随昼夜循环作出反应的永久状态效果。
//
// 为何采用自定义的处理型效果（而非静态的 `effectedstats` 系统）：基类的
// `effectedstats` 会在增益的整个生命周期内【无条件】施加其加成。而我们的加成必须
// 随太阳起落而来去，因此我们让 `effectedstats` 保持为空，转而在 tick() 中依据
// GLOB.tod 自行施加/撤除属性，并记录其当前是否已施加，从而绝不会重复施加或重复撤除
//（那会破坏持有者的属性数值）。
// ============================================================================
/datum/status_effect/buff/gift_of_the_sun
	// 稳定的 id，使 has_status_effect()/remove_status_effect() 能找到它。
	id = "gift_of_the_sun"
	// -1 = 永久：该馈赠持续到死亡/被移除为止，而非定时增益。
	duration = -1
	// 每隔几秒轮询一次昼夜状态。开销很低，且在黎明/黄昏边界处几秒的延迟
	// 对一项被动属性特性而言难以察觉。
	tick_interval = 5 SECONDS
	// 一个生物身上只能存在一份该馈赠；第二次施加会被直接忽略
	//（杜绝任何叠加属性加成的可能）。
	status_type = STATUS_EFFECT_UNIQUE
	// HUD 提示图标，让玩家看到自己持有该特性。复用一个已确认存在的、
	// 阳光/光明主题的提示贴图（"stressvg"，与 guidinglight 所用相同）。
	alert_type = /atom/movable/screen/alert/status_effect/buff/gift_of_the_sun
	// 当有人检视持有者时显示。
	examine_text = "<span class='notice'>SUBJECTPRONOUN 的肌肤上萦绕着一缕白昼的金光。</span>"
	// 记录 +2/+2 的白昼加成【当前】是否已施加，使施加/撤除完美配对、属性数值永不漂移。
	var/bonus_active = FALSE
	// 该馈赠在白昼所赋予的确切属性加成。以数据形式保存，使施加与撤除两个循环互为镜像
	//（单一可信来源）。
	var/list/sun_stats = list(STATKEY_WIL = GIFT_OF_THE_SUN_STAT_BONUS, STATKEY_CON = GIFT_OF_THE_SUN_STAT_BONUS)

// 持有该特性期间显示的 HUD 提示图标。
/atom/movable/screen/alert/status_effect/buff/gift_of_the_sun
	name = "太阳的馈赠"
	desc = "阿斯特拉塔的赐福与我同在。白昼之下，我的意志与体魄都更为强健。"
	icon_state = "stressvg"

// 太阳此刻是否高悬？阿斯特拉塔的馈赠以日光为源，因此我们将完整的白昼与黎明过渡
// 都视作“白昼”（与阿斯特拉塔主神允许信徒在 "day"/"dawn" 期间祈祷的判定一致）。
/datum/status_effect/buff/gift_of_the_sun/proc/is_daytime()
	return (GLOB.tod == "day" || GLOB.tod == "dawn")

// 恰好施加一次白昼属性加成（由 bonus_active 守卫，使反复的白昼 tick 不会持续叠加）。
/datum/status_effect/buff/gift_of_the_sun/proc/apply_sun_bonus()
	if(bonus_active)
		return
	// 防御性处理：绝不在缺失/无效的持有者身上改动属性。
	if(QDELETED(owner))
		return
	for(var/stat in sun_stats)
		owner.change_stat(stat, sun_stats[stat])
	bonus_active = TRUE
	to_chat(owner, span_nicegreen("阳光的馈赠涌入体内——你的意志与体魄在白昼中愈发强健。"))

// 恰好撤除一次白昼属性加成（由 bonus_active 守卫，使我们绝不会去扣减一份当前并未施加的加成）。
/datum/status_effect/buff/gift_of_the_sun/proc/remove_sun_bonus()
	if(!bonus_active)
		return
	// 即便持有者正在被销毁，也要原样回退我们所做的改动。
	if(!QDELETED(owner))
		for(var/stat in sun_stats)
			owner.change_stat(stat, -sun_stats[stat])
		to_chat(owner, span_warning("夜幕降临，阳光的馈赠悄然隐退，你的意志与体魄回归平常。"))
	bonus_active = FALSE

// 使加成与当前时辰相协调：白昼存在，夜晚消失。得益于上方的 bonus_active 守卫，此过程幂等。
/datum/status_effect/buff/gift_of_the_sun/proc/refresh_sun_bonus()
	if(is_daytime())
		apply_sun_bonus()
	else
		remove_sun_bonus()

// 在获得该特性时，立即依据当前时辰设置正确状态（这样在正午举行仪式便会即刻获得加成）。
/datum/status_effect/buff/gift_of_the_sun/on_apply()
	. = ..()
	if(!.) // 基类拒绝施加 -> 不再继续。
		return FALSE
	refresh_sun_bonus()
	return TRUE

// 每次 tick 都重新检查太阳并相应地施加/撤除。
/datum/status_effect/buff/gift_of_the_sun/tick()
	. = ..()
	if(QDELETED(owner))
		return
	refresh_sun_bonus()

// 在失去该特性时（死亡、管理员移除、生物被删除），确保不会在持有者属性上遗留悬空的白昼加成。
/datum/status_effect/buff/gift_of_the_sun/on_remove()
	remove_sun_bonus()
	return ..()

// 若该效果经由 be_replaced 路径被替换/其生物被删除，也在那里清理加成，
// 使属性永远不会被永久性地虚增。
/datum/status_effect/buff/gift_of_the_sun/be_replaced()
	remove_sun_bonus()
	return ..()

// --- 清理本文件局部的 define，避免它们泄漏到其它文件中 ---------
#undef GIFT_OF_THE_SUN_RITE_NAME
#undef GIFT_OF_THE_SUN_STAT_BONUS
