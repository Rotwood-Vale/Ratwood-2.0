// ============================================================================
// 内克拉的死亡帷幕（Necra's Death Curtain）—— 隶属于内克拉献祭法阵的一项仪式
// ----------------------------------------------------------------------------
// 在【已存在的】内克拉献祭法阵
//（`/obj/structure/ritualcircle/sacrifice/necra`，定义于 sacrifice_circles.dm）
// 之上新增一项仪式。DM 会跨文件合并同一类型的定义，因此在这里重新打开该类型即可
// 挂上新仪式，而【无需】改动那个共享的法阵文件。
//
// 该仪式要求法阵格子上有一份 LUX（灵辉，/obj/item/reagent_containers/lux）。成功时，
// 它会消耗该 LUX，并赋予主持者一项一次性的“死亡帷幕”特性：一旦主持者死亡，
// 在死亡 5 秒后将以“一半的状态”（约 50% 生命）被复活；该特性触发后即被消耗。
//
// 遵循项目规则：仅存放于 modular_z121 之下，面向玩家的文本一律使用中文，
// 每一处过程、变量与逻辑块上方都以中文注释解释其“为何如此”。
//
// 依赖项（均已在构建中，未作改动）：
//   - 仪式基础框架：modular_z121\rites\sacrifice_circles.dm
//   - LUX 物品：/obj/item/reagent_containers/lux（modular_hearthstone，已 include）
//   - 死亡信号 COMSIG_LIVING_DEATH（由 /mob/living/death() 发出）
//   - revive()/take_overall_damage()/grab_ghost()（code\modules\mob\living\...）
//   - 复活后虚弱 debuff：/datum/status_effect/debuff/revived
// 需在 modular_z121\_load.dm 中登记（置于 sacrifice_circles.dm 之后）。
// ============================================================================

// --- 可调常量 ---------------------------------------------------------------
// 在仪式选择菜单中显示、并在分派 switch 中用于匹配的标签文本；用 define 保存，
// 使二者永远保持一致、不会悄然出现偏差。
#define NECRA_DEATH_CURTAIN_RITE_NAME "死亡帷幕"
// 主持者死亡之后、被帷幕拉回人世之前需要等待的时间。规格要求为“死亡 5 秒后”。
#define NECRA_DEATH_CURTAIN_REVIVE_DELAY (5 SECONDS)
// 复活后所恢复到的生命占最大生命的比例。规格要求为“一半的状态”，故为 0.5。
#define NECRA_DEATH_CURTAIN_HEALTH_FRACTION 0.5

// 重新打开内克拉献祭法阵以登记我们的仪式。基类 attack_hand()
//（在 sacrifice_circles.dm 中）已经强制校验 patron == Necra、TRAIT_RITUALIST 特质、
// 每次歇息只能一次的“仪式已耗尽”冷却，并弹出选择菜单——因此我们只需提供菜单标题与仪式列表。
/obj/structure/ritualcircle/sacrifice/necra
	// 在仪式选择输入框中显示的标题。
	ritual_title = "内克拉的献祭仪式"
	// 本法阵提供的仪式。日后若要新增内克拉仪式，只需在这里追加字符串
	//（并在下方补上对应的 switch 分支）即可。
	sacrifice_rites = list(NECRA_DEATH_CURTAIN_RITE_NAME)

// 将所选仪式分派给其处理过程；在玩家从 `sacrifice_rites` 中选取条目后，
// 由基类 attack_hand() 调用。
/obj/structure/ritualcircle/sacrifice/necra/perform_sacrifice_rite(riteselection, mob/living/user)
	switch(riteselection)
		// 将我们的仪式导向其专属过程。
		if(NECRA_DEATH_CURTAIN_RITE_NAME)
			return necra_death_curtain_rite(user)
	// 未识别的选项 -> 基类会礼貌地提示“没有这样的仪式”并退出。
	return ..()

// ----------------------------------------------------------------------------
// 仪式本体。
// 仅在仪式完整完成时返回 TRUE；任何中止/失败都返回 FALSE，从而不消耗任何东西、
// 也不提前花掉每日的“仪式已耗尽”冷却（基类仅在本过程内成功时才标记其耗尽）。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/necra/proc/necra_death_curtain_rite(mob/living/user)
	// --- 守卫 1：只有人类才能承载这份赐福。----------------------------
	// 复活逻辑操作 carbon/human 的躯体与生命，并假定持有者为人形；遇到其它任何情况
	//（某只动物/构造体不知怎么触发了法阵）都明确地中止。
	if(!ishuman(user))
		to_chat(user, span_smallred("唯有凡人之躯，才能被内克拉的死亡帷幕所眷顾。"))
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
	// 死亡帷幕是一次性的、在触发前持续存在的特性；重复授予只会白白浪费一份珍贵的 LUX，
	// 因此尽早中止并为玩家保留祭品。
	if(H.has_status_effect(/datum/status_effect/buff/necra_death_curtain))
		to_chat(H, span_notice("死亡帷幕已悬于我命途之上，无需再次祈求。"))
		return FALSE

	// --- 守卫 3：在漫长吟唱【之前】确认 LUX 已就位。----
	// 提前检查，免得让玩家站着念完咒，最后才被告知缺了 LUX。
	if(!has_required_lux(altar))
		to_chat(H, span_smallred("法阵之上必须放置一份「灵辉」（LUX），方能开启这场仪式。"))
		return FALSE

	// --- 吟唱阶段。----------------------------------------------------
	// 若使用者移动/被打断，do_after() 会返回 FALSE；每一阶段都重新确认 LUX 仍在，
	// 因此走开（或被人顺走 LUX）都会干净地中止、不消耗任何东西。
	// 这些台词呼应内克拉的领域：死亡、彼岸的幽冥少女与生死之间的帷幕。
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("内克拉啊，幽冥少女，长眠与彼岸的执掌者！请垂听我的祈求。")
	playsound(altar, 'sound/magic/churn.ogg', 80, FALSE, -1)

	// 继续之前重新校验（等待期间世界状态可能已经改变）。
	if(!has_required_lux(altar))
		to_chat(H, span_warning("灵辉已不在法阵之上，仪式随之中断。"))
		return FALSE
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("我献上这一缕生命之灵辉，恳请你为我留一道返回人世的缝隙。")
	playsound(altar, 'sound/magic/churn.ogg', 80, FALSE, -1)

	if(!has_required_lux(altar))
		to_chat(H, span_warning("灵辉已不在法阵之上，仪式随之中断。"))
		return FALSE
	if(!do_after(H, 50, target = src))
		return FALSE
	H.say("当死亡前来叩门，请以你的帷幕将我轻轻送回！")
	to_chat(H, span_danger("一阵彻骨的寒意缠绕上你的脊背，仿佛有一层无形的薄纱披覆于身……"))

	// 收尾前最后一段较短的停顿，让高潮显得郑重而有意为之。
	if(!do_after(H, 30, target = src))
		return FALSE

	// --- 最终校验 + 消耗 LUX。--------------------------------
	// 在拿取任何东西之前进行权威校验，使消耗绝不会在已残缺的法阵上执行。
	if(!has_required_lux(altar))
		return FALSE
	// 移除恰好一份 LUX；若以某种方式失败，则中止授予。
	if(!consume_required_lux(altar))
		to_chat(H, span_warning("灵辉在最后一刻消散，仪式功亏一篑。"))
		return FALSE

	// --- 仪式成功的视觉与气氛表现。----------------------------
	icon_state = "necra_active" // 魔法生效期间点亮符文。
	altar.visible_message(span_warning("法阵渗出缕缕幽冷的灰雾，凝成一层薄纱般的帷幕，悄然没入 [H] 的身影之中。"))
	playsound(altar, 'sound/magic/churn.ogg', 100, FALSE, -1)
	H.flash_fullscreen("blackflash") // 死亡主题的暗色闪光（已确认为有效的闪光状态）。

	// --- 授予这项一次性的“死亡帷幕”特性。--------------------------
	// apply_status_effect 负责处理增益的生命周期；该效果本身会监听持有者的死亡，
	// 并在 5 秒后以“一半的状态”将其复活、随后自我消耗。详见下方
	// /datum/status_effect/buff/necra_death_curtain。
	H.apply_status_effect(/datum/status_effect/buff/necra_death_curtain)

	// 既然仪式已真正成功，就此花掉每日的仪式额度（与其它祭坛采用同一规则），
	// 使主持者必须先歇息才能进行下一次。
	H.apply_status_effect(/datum/status_effect/debuff/ritesexpended)

	// 给主持者的收尾确认。
	to_chat(H, span_nicegreen("内克拉收下了这场献祭。「死亡帷幕」已笼罩于你：若你殒命，五息之后将以残存之躯重返人间。"))

	// 短暂延迟后把符文重置回静默状态，复用基类辅助过程，使时机与其它祭坛保持一致。
	addtimer(CALLBACK(src, PROC_REF(reset_rune_state)), 120)
	return TRUE

// ----------------------------------------------------------------------------
// 辅助：法阵格子上是否有一份 LUX？
// 用 `locate(类型) in 格子`（基于 istype），它会匹配 /obj/item/reagent_containers/lux
// 及其子类型（如 eora 的“炽耀果粒”等价物），但【不会】匹配作为同级类型的不纯灵辉
// （lux_impure），因为后者并非 lux 的子类型——恰好符合“一份 LUX”的要求。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/necra/proc/has_required_lux(turf/altar)
	// 防御性处理：没有格子就没有祭品。
	if(!altar)
		return FALSE
	var/obj/item/reagent_containers/lux/found_lux = locate() in altar
	// 找到则为真，未找到则为假。
	return !isnull(found_lux)

// ----------------------------------------------------------------------------
// 辅助：从法阵格子上移除【恰好一份】 LUX。
// 仅在确实找到并删除时返回 TRUE；否则返回 FALSE，使调用方能够中止而不误判为成功。
// ----------------------------------------------------------------------------
/obj/structure/ritualcircle/sacrifice/necra/proc/consume_required_lux(turf/altar)
	if(!altar)
		return FALSE
	// 在消耗的那一刻重新定位（不要信任先前捕获的引用——它在吟唱期间可能已被移动或 qdel）。
	var/obj/item/reagent_containers/lux/found_lux = locate() in altar
	if(!found_lux)
		return FALSE
	// 销毁这份 LUX。qdel 会干净地将它从格子上移除。
	qdel(found_lux)
	return TRUE

// ============================================================================
// “死亡帷幕”特性，实现为一个永久存在、监听持有者死亡的一次性状态效果。
//
// 为何采用监听信号的状态效果：该效果在被授予后必须长期潜伏，直到持有者死亡那一刻；
// 它通过注册 COMSIG_LIVING_DEATH 来捕捉死亡事件，安排一个 5 秒的定时器，
// 届时再以“一半的状态”将其复活，并在触发后自我消耗（一次性）。
// ============================================================================
/datum/status_effect/buff/necra_death_curtain
	// 稳定的 id，使 has_status_effect()/remove_status_effect() 能找到它。
	id = "necra_death_curtain"
	// -1 = 永久：在被触发消耗之前，该帷幕一直伴随主持者，而非定时增益。
	duration = -1
	// 一个生物身上只能存在一份该帷幕；第二次施加会被直接忽略（杜绝叠加）。
	status_type = STATUS_EFFECT_UNIQUE
	// HUD 提示图标，让玩家看到自己身负此特性。复用一个已确认存在的、
	// 与复活相关的提示贴图（"revived"），主题契合。
	alert_type = /atom/movable/screen/alert/status_effect/buff/necra_death_curtain
	// 当有人检视持有者时显示。
	examine_text = "<span class='notice'>SUBJECTPRONOUN 身上萦绕着一层若有若无的灰色帷幕。</span>"
	// 防重入标志：记录死亡是否已经触发过帷幕，避免在极端情况下（死亡信号被多次发出）
	// 重复安排复活。
	var/triggered = FALSE

// 持有该特性期间显示的 HUD 提示图标。
/atom/movable/screen/alert/status_effect/buff/necra_death_curtain
	name = "死亡帷幕"
	desc = "内克拉的帷幕悬于我命途之上。若我殒命，将于片刻后以残躯重返人世。"
	icon_state = "revived"

// 在获得该特性时，注册对持有者死亡事件的监听。
/datum/status_effect/buff/necra_death_curtain/on_apply()
	. = ..()
	if(!.) // 基类拒绝施加 -> 不再继续。
		return FALSE
	// 监听 /mob/living/death() 发出的 COMSIG_LIVING_DEATH 信号；其首个附带参数为
	// gibbed（是否被血肉横飞地摧毁）。
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_owner_death))
	return TRUE

// 在失去该特性时（被消耗、管理员移除或生物被删除），解除信号监听。
// 注：即便此处不显式解除，datum 在 qdel 时也会自动清理其注册的信号；此处显式处理只为稳妥。
/datum/status_effect/buff/necra_death_curtain/on_remove()
	if(owner)
		UnregisterSignal(owner, COMSIG_LIVING_DEATH)
	return ..()

// 死亡信号处理器：在持有者死亡的那一刻被调用。
// 标注 SIGNAL_HANDLER：信号处理器必须同步、且不可休眠，因此这里只做轻量工作——
// 安排一个延时回调，真正的复活在 attempt_resurrection() 中进行。
/datum/status_effect/buff/necra_death_curtain/proc/on_owner_death(datum/source, gibbed)
	SIGNAL_HANDLER
	// 已经触发过则不再重复安排（防御性）。
	if(triggered)
		return
	// 若躯体被彻底摧毁（gibbed），便没有可供复活的身躯；帷幕无能为力，直接放弃。
	// 此时不在信号处理器内 qdel 自身（生物多半正被销毁），交由 on_remove 自动清理。
	if(gibbed)
		return
	// 标记为已触发，并安排在规定延时后尝试复活。
	triggered = TRUE
	addtimer(CALLBACK(src, PROC_REF(attempt_resurrection)), NECRA_DEATH_CURTAIN_REVIVE_DELAY)

// 真正执行复活：在死亡若干秒后由定时器调用，将主持者以“一半的状态”拉回人世。
// 无论成功与否，本过程结束时都会消耗掉帷幕（一次性）。
/datum/status_effect/buff/necra_death_curtain/proc/attempt_resurrection()
	// 防御性处理：效果或持有者在这 5 秒内已被销毁，则无事可做。
	if(QDELETED(src))
		return
	if(QDELETED(owner) || !ishuman(owner))
		// 持有者已不存在或不再是人形躯体——清理掉帷幕。
		qdel(src)
		return
	var/mob/living/carbon/human/H = owner

	// 若在这段窗口期内主持者已被他人（或其它方式）救活，帷幕之力便无需动用，悄然消散。
	if(H.stat != DEAD)
		to_chat(H, span_notice("死亡帷幕察觉到你仍在人世，于是悄然消散。"))
		qdel(src)
		return

	// 先把玩家的灵魂拉回躯体（即便其已化为幽灵游离在外），否则复活后会是一具空壳。
	H.grab_ghost(force = TRUE)

	// 先“完全治愈式复活”：revive(full_heal = TRUE) 会【先】治愈再判断可否复活，
	// 因而 can_be_revived() 必定通过，确保一次干净的归来；而被斩首/脑死/血肉横飞的
	// 躯体会令其返回 FALSE，则维持死亡。
	if(!H.revive(full_heal = TRUE))
		H.visible_message(span_warning("一层灰色帷幕在 [H] 身上一闪即逝，却未能将其残破的躯壳唤回。"))
		qdel(src)
		return

	// 此刻其已满血复生；再将之削减到“一半的状态”：施加等于最大生命一半的钝伤，
	// 使最终生命停在约 50%。
	var/brute_to_apply = H.maxHealth * (1 - NECRA_DEATH_CURTAIN_HEALTH_FRACTION)
	H.take_overall_damage(brute_to_apply)
	H.updatehealth()

	// 套用与游戏内所有复活一致的“复生虚弱”临时 debuff（短暂的属性惩罚），以示代价。
	H.apply_status_effect(/datum/status_effect/debuff/revived)

	// 复活的视觉与气氛表现。
	H.visible_message(span_warning("一层灰色的帷幕自虚无中垂落，将 [H] 重新裹入人世——其残躯艰难地恢复了气息！"), span_green("死亡帷幕将我自彼岸拽回，我以残存之躯重返人间。"))
	playsound(get_turf(H), 'sound/magic/revive.ogg', 80, FALSE, -1)
	H.emote("breathgasp")

	// 一次性使用：消耗掉帷幕（qdel 会触发 on_remove 解除信号监听）。
	qdel(src)

// --- 清理本文件局部的 define，避免它们泄漏到其它文件中 ---------
#undef NECRA_DEATH_CURTAIN_RITE_NAME
#undef NECRA_DEATH_CURTAIN_REVIVE_DELAY
#undef NECRA_DEATH_CURTAIN_HEALTH_FRACTION
