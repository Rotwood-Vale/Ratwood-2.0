// ============================================================================
// 魔法奥秘（The Mystery of Magic）—— 隶属于诺克献祭法阵的一项仪式
// ----------------------------------------------------------------------------
// 在【已存在的】诺克献祭法阵
//（`/obj/structure/ritualcircle/sacrifice/noc`，定义于 sacrifice_circles.dm）
// 之上新增一项仪式。DM 会跨文件合并同一类型的定义，因此在这里重新打开该类型即可
// 挂上新仪式，而【无需】改动那个共享的法阵文件。
//
// 该仪式要求法阵格子上至少有一件符文遗物（/obj/item/magic/artifact）。成功时，
// 它会【消耗】当场所有的符文遗物，并从全局可习得法术池（GLOB.learnable_spells）中
// 教给主持者一道随机的【非奇迹】法术。所提取法术的等级上限为 3 级；献祭的遗物越多，
// 概率就越向更高（更高级）的层级倾斜。
//
// 遵循项目规则：仅存放于 modular_z121 之下，面向玩家的文本一律使用中文，
// 每一行都以注释解释其“为何如此”。
//
// 依赖项（均已在构建中，未作改动）：
//   - 仪式基础框架：modular_z121\rites\sacrifice_circles.dm
//   - 符文遗物物品：/obj/item/magic/artifact
//       （code\game\objects\items\rogueitems\magic\magic_resources.dm）
//   - 法术池 GLOB.learnable_spells（位于 code\modules\spells\spell_types\wizard\spell_list.dm）；
//       注意 modular_z121\bootstrap\custom_bootstrap.dm 会将 GLOB.custom_learnable_spells
//       并入其中，因此自定义法术同样有资格被抽到。
//   - 法术变量 spell_tier / miracle / zizo_spell（code\modules\spells\spell.dm）
//   - mind.AddSpell()/has_spell()（code\datums\mind.dm）、pickweight()（_lists.dm）
// 需在 modular_z121\_load.dm 中登记（置于 sacrifice_circles.dm 之后）。
// ============================================================================

// --- 可调常量 ---------------------------------------------------------------
// 在仪式选择菜单中显示、并在分派 switch 中用于匹配的标签文本；用 define 保存，
// 使二者永远保持一致、不会悄然出现偏差。
#define MYSTERY_OF_MAGIC_RITE_NAME "魔法奥秘"
// 本仪式所能授予法术的层级硬上限。规格要求所提取法术的最高等级为 T3，
// 因此 spell_tier 高于此值的法术不论献祭多少遗物，都会被排除在法术池之外。
#define MYSTERY_OF_MAGIC_MAX_TIER 3

// 重新打开诺克献祭法阵以登记我们的仪式。基类 attack_hand()
//（在 sacrifice_circles.dm 中）已经强制校验 patron == Noc、TRAIT_RITUALIST 特质、
// 每次歇息只能一次的“仪式已耗尽”冷却，并弹出选择菜单——因此我们只需提供菜单标题与仪式列表。
/obj/structure/ritualcircle/sacrifice/noc
	// 在仪式选择输入框中显示的标题。
	ritual_title = "诺克的献祭仪式"
	// 本法阵提供的仪式。日后若要新增诺克仪式，只需在这里追加字符串
	//（并在下方补上对应的 switch 分支）即可。
	sacrifice_rites = list(MYSTERY_OF_MAGIC_RITE_NAME)

// 将所选仪式分派给其处理过程；在玩家从 `sacrifice_rites` 中选取条目后，
// 由基类 attack_hand() 调用。
/obj/structure/ritualcircle/sacrifice/noc/perform_sacrifice_rite(riteselection, mob/living/user)
	switch(riteselection)
		// 将我们的仪式导向其专属过程。
		if(MYSTERY_OF_MAGIC_RITE_NAME)
			return mystery_of_magic_rite(user)
	// 未识别的选项 -> 基类会礼貌地提示“没有这样的仪式”并退出。
	return ..()

// ----------------------------------------------------------------------------
// 仪式本体。
// 仅在仪式完整完成时返回 TRUE；任何中止/失败都返回 FALSE，从而不消耗任何东西、
// 也不提前花掉每日的“仪式已耗尽”冷却（基类仅在本过程内成功时才标记其耗尽）。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/noc/proc/mystery_of_magic_rite(mob/living/user)
	// --- 守卫 1：主持者需要拥有心智才能承载法术。--------------
	// 法术存放在 /datum/mind 上（AddSpell）；没有心智的生物无法习得法术。
	if(!user.mind)
		to_chat(user, span_smallred("我的心智无法承载这份奥秘。"))
		return FALSE

	// 法阵自身所在的格子即“祭祀法阵”；祭品就摆放在这里。缓存它，使下方每次扫描
	// 内容物时都查看同一个、正确的格子。
	var/turf/altar = get_turf(src)
	if(!altar)
		// 防御性处理：没有所在格子的法阵无法承放祭品。
		to_chat(user, span_warning("这道法阵无处安放祭品，仪式无法开始。"))
		return FALSE

	// --- 守卫 2：必须至少存在一件符文遗物。----------------
	// 提前检查，免得让玩家先念咒，之后才得知法阵上一件都没有。
	if(!count_runed_artifacts(altar))
		to_chat(user, span_smallred("法阵之上必须至少放置一件符文遗物，方能开启这场仪式。"))
		return FALSE

	// --- 守卫 3：必须还有【可供学习】之物。---------------------
	// 现在就构建符合条件的法术池；若它为空（主持者已学会每一道 T3 及以下的非奇迹法术），
	// 则【不消耗】遗物直接中止，免得玩家把它们浪费在一次注定无效的操作上。
	var/list/pool_by_tier = build_spell_pool(user)
	if(!length(pool_by_tier))
		to_chat(user, span_notice("我已通晓所有力所能及的法术，符文遗物中再无新的奥秘可供我汲取。"))
		return FALSE

	// --- 吟唱阶段。----------------------------------------------------
	// 若使用者移动/被打断，do_after() 会返回 FALSE；每一阶段都重新确认遗物仍在，
	// 因此走开（或被人顺走遗物）都会干净地中止、不消耗任何东西。
	// 这些台词呼应诺克的领域：秘密、明月与隐匿的知识。
	if(!do_after(user, 50, target = src))
		return FALSE
	user.say("诺克啊，秘密之父，长夜与明月的守望者！请垂听我的祈求。")
	playsound(altar, 'sound/magic/holyshield.ogg', 80, FALSE, -1)

	if(!count_runed_artifacts(altar)) // 重新校验（世界状态可能已经改变）。
		to_chat(user, span_warning("符文遗物已不在法阵之上，仪式随之中断。"))
		return FALSE
	if(!do_after(user, 50, target = src))
		return FALSE
	user.say("我献上这些镌刻着古老符文的遗物，愿你为我揭开其中沉睡的奥秘。")
	playsound(altar, 'sound/magic/holyshield.ogg', 80, FALSE, -1)

	if(!count_runed_artifacts(altar))
		to_chat(user, span_warning("符文遗物已不在法阵之上，仪式随之中断。"))
		return FALSE
	if(!do_after(user, 50, target = src))
		return FALSE
	user.say("将隐匿于符文之下的知识，倾注入我的心神之中吧！")
	to_chat(user, span_danger("无数细碎的低语涌入脑海，古老的符文在你眼前缓缓亮起又熄灭……"))

	// 收尾前最后一段较短的停顿，让高潮显得郑重而有意为之。
	if(!do_after(user, 30, target = src))
		return FALSE

	// --- 最终校验 + 消耗法阵上的【每一件】遗物。-------------
	// 在消耗的那一刻进行权威计数；若它在上次检查与此刻之间不知怎么跌到了零，则中止。
	var/consumed = consume_runed_artifacts(altar)
	if(consumed <= 0)
		to_chat(user, span_warning("祭品在最后一刻散落，仪式功亏一篑。"))
		return FALSE

	// 防御性处理：法术池是在吟唱之前构建的。重新检查它仍然非空
	//（仪式进行中它通常不会改变，但绝不从“空无一物”里授予法术）。
	if(!length(pool_by_tier))
		to_chat(user, span_warning("奥秘从指间溜走，没有任何法术被习得。"))
		return FALSE

	// --- 掷点并授予所提取的法术。-----------------------------------
	// extract_spell() 会按所消耗遗物的数量为层级掷点加权，再从所选层级中抽出一道具体法术。
	var/chosen_path = extract_spell(pool_by_tier, consumed)
	if(!ispath(chosen_path, /obj/effect/proc_holder/spell))
		// 理应不可能（法术池非空），但万一如此也要安全地失败。
		to_chat(user, span_warning("奥秘在成形前崩解，没有任何法术被习得。"))
		return FALSE

	// 实例化该法术并将其赋予主持者的心智。其方式与 learnspell.dm 授予一道可习得法术
	// 相同（AddSpell 会接好施法动作）。
	var/obj/effect/proc_holder/spell/new_spell = new chosen_path
	if(QDELETED(new_spell))
		to_chat(user, span_warning("奥秘在成形前崩解，没有任何法术被习得。"))
		return FALSE
	user.mind.AddSpell(new_spell)

	// --- 仪式成功的视觉与气氛表现。----------------------------
	icon_state = "noc_active" // 魔法生效期间点亮符文。
	altar.visible_message(span_warning("[consumed] 件符文遗物同时崩解为流转的银辉，环绕着 [user] 旋舞，随后没入其眉心！"))
	playsound(altar, 'sound/magic/churn.ogg', 100, FALSE, -1)
	user.flash_fullscreen("whiteflash") // 月银般的闪光（已确认为有效的闪光状态）。

	// 既然仪式已真正成功，就此花掉每日的仪式额度（与其它祭坛采用同一规则），
	// 使主持者必须先歇息才能进行下一次。
	user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)

	// 收尾确认，点出实际习得的法术名称。
	to_chat(user, span_nicegreen("诺克收下了这场献祭。一道新的法术——「[new_spell.name]」——自符文的奥秘中浮现，自此为我所掌握。"))

	// 短暂延迟后把符文重置回静默状态，复用基类辅助过程，使时机与其它祭坛保持一致。
	addtimer(CALLBACK(src, PROC_REF(reset_rune_state)), 120)
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：当前法阵格子上有多少件符文遗物？
// 既用于开场的存在性检查，也用于仪式过程中的重新校验。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/noc/proc/count_runed_artifacts(turf/altar)
	if(!altar)
		return 0
	var/count = 0
	// istype 会匹配 /obj/item/magic/artifact 及其任意子类型，因此符文遗物的每个变体都会被计入。
	for(var/obj/item/magic/artifact/A in altar)
		count++
	return count

// ----------------------------------------------------------------------------
// 辅助：销毁法阵格子上的【每一件】符文遗物，并报告消耗了多少件。
// 返回数量，使调用方能据此为法术掷点加权，并给出如实的反馈。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/noc/proc/consume_runed_artifacts(turf/altar)
	if(!altar)
		return 0
	var/consumed = 0
	// 先快照到一个临时列表：在遍历格子的实时内容物时进行删除可能会漏掉元素，
	// 因此先收集，再 qdel。
	var/list/to_consume = list()
	for(var/obj/item/magic/artifact/A in altar)
		to_consume += A
	for(var/obj/item/magic/artifact/A in to_consume)
		if(QDELETED(A))
			continue
		qdel(A)
		consumed++
	return consumed

// ----------------------------------------------------------------------------
// 辅助：构建这位主持者仍可学习的法术池。
// 返回一个 “层级”(文本) -> 列表(法术类型路径) 的关联列表。键刻意采用【文本】：
// DM 会把数字列表下标当作【按位置】访问，因此数字键会悄然破坏 pickweight()/查找——
// 文本键可规避这一陷阱。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/noc/proc/build_spell_pool(mob/living/user)
	var/list/pool_by_tier = list()
	// GLOB.learnable_spells 是一份法术【类型路径】列表（法师法术池，外加并入的
	// 自定义法术）。我们以与 learnspell.dm 相同的方式读取每个路径的编译期默认值：
	// 把路径赋给一个有类型的变量，再读取其变量。
	for(var/spell_path in GLOB.learnable_spells)
		// 跳过任何并非法术路径的条目（针对法术池中可能存在的畸形条目作防御）。
		if(!ispath(spell_path, /obj/effect/proc_holder/spell))
			continue
		var/obj/effect/proc_holder/spell/template = spell_path
		// 按要求仅取【非奇迹】法术（奇迹是神职的恩赐，并非奥术）。
		if(template.miracle)
			continue
		// 排除邪恶/异端专属的“zizo”法术：那些法术在 learnspell 中以“是否为异端”作门槛，
		// 不应从一项通用仪式中外泄出去。
		if(template.zizo_spell)
			continue
		// 执行 T3 上限，并忽略任何不合理的负数层级。
		var/tier = template.spell_tier
		if(tier < 0 || tier > MYSTERY_OF_MAGIC_MAX_TIER)
			continue
		// 不提供主持者已经掌握的法术——那会是一次无效操作。
		if(user.mind.has_spell(spell_path))
			continue
		// 将符合条件的法术按其（文本）层级键归入对应桶中。
		var/tkey = "[tier]"
		if(!pool_by_tier[tkey])
			pool_by_tier[tkey] = list()
		pool_by_tier[tkey] += spell_path
	return pool_by_tier

// ----------------------------------------------------------------------------
// 辅助：从法术池中选出一个具体的法术类型路径，并按所消耗遗物的数量为【层级】掷点加权。
//
// 每个可用层级的权重：
//     weight(tier) = (MAX_TIER + 1 - tier) + (artifacts - 1) * (tier + 1)
//   - 当只有 1 件遗物时：低层级权重高于高层级（例如 T0..T3 = 4,3,2,1），
//     因此单件遗物多半会得到一道基础法术。
//   - 随着 `artifacts` 增大，(artifacts-1)*(tier+1) 这一项——对更高层级更大——
//     会逐步把概率质量上移，直至高层级占据主导。这恰好实现了“遗物越多 -> 高级法术
//     几率越高”，而 T3 上限早已在法术池中固化。
// 随后在所选层级内做一次均匀 pick()，挑出实际法术，使某个法术众多的层级
// 不会扭曲各层级之间的概率。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/noc/proc/extract_spell(list/pool_by_tier, artifacts)
	// 防御性守卫：无可挑选之物 -> 没有法术。
	if(!length(pool_by_tier))
		return null
	// 把异常/为零的数量当作单件遗物处理，使加权保持良定义。
	if(artifacts < 1)
		artifacts = 1

	// 仅在【确实有符合条件法术】的层级上构建一张 (文本层级 -> 权重) 表，使我们绝不会掷到空层级。
	var/list/tier_weights = list()
	for(var/tkey in pool_by_tier)
		var/tier = text2num(tkey)
		// 上文所述的加权公式；max(1, ...) 保证权重为正
		//（pickweight 本就会把 0/假 的权重当作 1，但我们让其显式且可预测）。
		var/weight = max(1, (MYSTERY_OF_MAGIC_MAX_TIER + 1 - tier) + (artifacts - 1) * (tier + 1))
		tier_weights[tkey] = weight

	// 加权随机层级；若 pickweight 不知怎么返回了空（在非空、正权重的表上不应发生），
	// 则回退到任意一个有内容的层级。
	var/chosen_tkey = pickweight(tier_weights)
	if(isnull(chosen_tkey) || !pool_by_tier[chosen_tkey])
		chosen_tkey = pick(pool_by_tier)

	// 在所选层级内均匀地挑出一道具体法术。
	var/list/tier_pool = pool_by_tier[chosen_tkey]
	if(!length(tier_pool))
		return null
	return pick(tier_pool)

// --- 清理本文件局部的 define，避免它们泄漏到其它文件中 ---------
#undef MYSTERY_OF_MAGIC_RITE_NAME
#undef MYSTERY_OF_MAGIC_MAX_TIER
