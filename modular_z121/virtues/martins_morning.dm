// ============================================================================
// modular_z121/virtues/martins_morning.dm
// 自定义美德（Custom Virtue）：马丁的早晨 / Martin's Morning
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   实现一个全新的、需消耗 23 点凯旋点数（triumph_cost = 23）的美德"马丁的早晨"。
//   它的限制是【只能由"能够睡眠"的角色选取】（不带致命失眠 TRAIT_NOSLEEP）。
//   授予特性【马丁的早晨】：
//     - 每天清晨（游戏内 dawn 时刻），角色会被【强制沉睡 30 秒】。
//     - 30 秒后醒来时，角色的"职业"会随机切换为另一个职业 —— 连同其装备、技能、
//       特性等一并替换，仿佛他从一开始就选择了这个职业。
//
// 为什么把"职业"实现为 /datum/advclass（进阶职业）而不是 /datum/job：
//   在 Ratwood/RogueTown 中，玩家在出生时真正"选择"的职业（农夫、铁匠、猎人、
//   吟游诗人……）都是 /datum/advclass 数据单（见 _advclass.dm），它通过 equipme()
//   一次性应用【外观装备 outfit + 属性 subclass_stats + 技能 subclass_skills +
//   特性 traits_applied + 语言 + 社会等级 + 法术点……】，这正是"仿佛从一开始就
//   选择了这个职业"的语义。因此随机切换 advclass 是最贴合需求的实现。
//
// 为什么所有逻辑都放在本文件内（合规性）：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外的
//   任何文件。本文件仅通过"继承已有基类 / 向已有类型追加 var、proc"的方式接入引擎，
//   不修改任何核心源文件，因此完全满足约束。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承，不修改其源文件）：
//   - /datum/virtue                              美德基类（modular_azurepeak/_virtue.dm）
//   - /datum/component                           组件基类（挂载清晨信号与生命周期管理）
//   - COMSIG_MOB_DAWNED                          入晨信号（nightshift.dm update_tod("dawn")）
//   - TRAIT_NOSLEEP                              致命失眠特性（= "不能睡眠"，用于限制判定）
//   - /mob/living/proc/SetSleeping()             设置睡眠剩余时长（强制沉睡 / 唤醒）
//   - /datum/advclass + advclass.equipme()       进阶职业数据单与其装备逻辑（参照实现）
//   - SSrole_class_handler.sorted_class_categories  全部 advclass 实例（按类别分桶）
//   - CTAG_PILGRIM / CTAG_TOWNER                 日常职业类别标签（候选池来源）
//   - /mob/living/carbon/human/proc/delete_equipment()  清空全部穿戴 / 手持装备
//   - /datum/skill_holder（mob.skills）          技能存储（重置技能用）
//   - change_stat / adjust_skillrank_up_to / equipOutfit / grant_language  应用职业内容
//   - ADVENTURER_TRAIT                           advclass 特性的来源标签（添加 / 撤销对应）
//
// 加载：本文件需在 modular_z121/_load.dm 中以 #include 引入（已在该文件追加）。
// ============================================================================


// ----------------------------------------------------------------------------
// 自定义特性键（Trait key）：马丁的早晨
// 为什么要定义：用一个唯一字符串标识"持有马丁的早晨"的人，便于本文件（及未来其它
//   系统）通过 HAS_TRAIT 判断身份，也作为 ADD_TRAIT 的来源标签使用。
// 为什么用字符串：引擎的特性系统以字符串为键，与 modular_z121 内既有写法
//   （如 never_ending.dm 的 TRAIT_DESIGNATED_PERFORMER）保持一致。
// ----------------------------------------------------------------------------
#define TRAIT_MARTINS_MORNING "martins_morning"

// 每个清晨强制沉睡的时长：30 秒。需求明确为"强制睡眠 30 秒，醒来后切换职业"。
// 单列为常量，便于将来平衡性调整时只改这一处。
#define MARTINS_MORNING_SLEEP_DURATION (30 SECONDS)


// ----------------------------------------------------------------------------
// 美德定义：马丁的早晨
// 为什么归入 /datum/virtue/utility 分支：与 never_ending（永无止境）、life_potential
//   （生命潜能）等"效用型"被动美德保持一致；作为 /datum/virtue 子类型，会被
//   global_lists.dm 的 subtypesof() 自动收录进 GLOB.virtues，无需手动注册。
// ----------------------------------------------------------------------------
/datum/virtue/utility/martins_morning
	// 菜单中显示的美德名（Martin's Morning）。
	name = "马丁的早晨"
	// 角色内描述（in-character）：保留需求给出的、带有荒诞童谣感的氛围文本。
	// 为什么照搬这段意象：它是该美德的"风味"，让玩家在选择界面就感受到其古怪基调。
	desc = "马丁马丁，每天清晨当你醒来，马丁马丁，总有一个角色在等待。\
			变成一条龙，好可爱好可爱；变成一个原始人，不太帅不太帅。\
			郭莫是你的好朋友，萝娜是你喜欢的女孩。马丁马丁马丁，你是超人，飞得好快。\
			马丁马丁马丁，你的故事太奇怪。"
	// custom_text 用机制语言把硬性规则讲清楚，避免玩家误解触发条件与代价。
	// 为什么单列：desc 偏氛围，这里写明"限能睡眠者、每天清晨强睡 30 秒、醒后随机换职业"。
	custom_text = "获得特性【马丁的早晨】（仅限能够睡眠的角色）：\n\
		每天清晨，你都会被强制沉睡 30 秒。醒来之后，你的职业会随机切换为另一种——\n\
		连同装备、技能、特性等一并替换，仿佛你从一开始就选择了这个新职业。"
	// 消耗 23 点凯旋点数。基类 New() 会自动把"Costs 23 TRIUMPH"追加到 desc；
	//   check_triumphs() 会在 apply_virtue 流程开头校验并扣除，点数不足则不授予。
	triumph_cost = 23
	// 为什么"不"用 added_traits 通道授予 TRAIT_MARTINS_MORNING：
	//   apply_virtue 的调用顺序是 apply_to_human() 先于 handle_traits()。若走 added_traits，
	//   即便我们在 apply_to_human 里因"不能睡眠"判定而拒绝授予能力，紧随其后的
	//   handle_traits() 仍会把标签无条件加回，造成"有标签却无效果"的误导。
	//   因此改为在 apply_to_human 通过"能睡眠"校验后，由组件手动 ADD_TRAIT，
	//   使"标签 = 能力生效"严格一致。

// apply_to_human：美德被赋予人物时调用。这里负责两件事：
//   1) 校验"只能由能睡眠的角色选取"——带致命失眠（TRAIT_NOSLEEP）者无法被强制入睡，
//      该美德的核心机制（清晨强睡）对其无意义，故优雅降级、不授予能力。
//   2) 为合格的人物挂载驱动组件，由组件监听清晨信号并处理强睡与职业切换。
/datum/virtue/utility/martins_morning/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// 防御性检查：没有有效的人类（极端时序下可能为 null）就直接返回，避免空引用报错。
	if(!istype(recipient))
		return

	// 为什么校验 TRAIT_NOSLEEP："必须是能睡眠的角色"是本美德的硬性限制。
	//   TRAIT_NOSLEEP（致命失眠）的角色无法入睡，"清晨强睡 30 秒"无法成立，
	//   因此对其做优雅降级：保留已选美德（含已扣点数的既成事实），但不挂组件、
	//   不打标签，并明确告知玩家能力未生效，而不是直接抛错卡死流程。
	if(HAS_TRAIT(recipient, TRAIT_NOSLEEP))
		to_chat(recipient, span_warning("马丁的早晨需要一觉沉眠才能开启——可你根本无法入睡，\
										这份古怪的祝福在你身上沉寂了。"))
		// 退还已扣除的凯旋点数：apply_virtue 的顺序是 check_triumphs()（已扣 23 点）→ apply_to_human()。
		//   既然能力对失眠者不生效，就把点数原数退回，避免"花了钱什么都没得到"。
		//   adjust_triumphs 第二参 FALSE = 不弹提示音/特效。此退款做法与 ancient_creation.dm 一致。
		if(triumph_cost)
			recipient.adjust_triumphs(triumph_cost, FALSE)
		return

	// 为什么挂组件而不是直接在这里 RegisterSignal：
	//   美德 datum 是 GLOB.virtues 里的"模板单例"，不能用它的 src 去 RegisterSignal(recipient)
	//   （回调会指向错误的 datum）。组件实例与 recipient 一一绑定，能正确管理信号注册，
	//   并在宿主死亡 / qdel 时自动反注册，避免悬空回调。组件做了 UNIQUE 去重，重复赋予不叠加。
	recipient.AddComponent(/datum/component/martins_morning)


// ----------------------------------------------------------------------------
// 驱动组件：马丁的早晨
// 为什么用组件：组件天然与宿主 mob 绑定，提供 Initialize / UnregisterFromParent
//   生命周期钩子，能干净地完成"注册清晨信号、添加特性"，并在宿主消失时反注册信号、
//   移除特性，避免状态残留与悬空回调。
// ----------------------------------------------------------------------------
/datum/component/martins_morning
	// 唯一组件：同一 mob 上只允许一个实例，重复 AddComponent 会被丢弃，杜绝重复监听。
	dupe_mode = COMPONENT_DUPE_UNIQUE
	// 标记"本清晨的强睡 + 换职业流程"是否正在进行中。
	// 为什么需要：清晨信号理论上每天只发一次，但用此布尔做幂等保护，避免极端情况下
	//   （信号重入 / 时间系统抖动）在同一个清晨重复强睡或重复切换职业。
	var/morning_in_progress = FALSE
	// ---- 法术基线快照（用于"快照与还原"式法术清理）----
	// 为什么需要快照：法术存放在 mind.spell_list，且不记录"来源"，无法直接区分
	//   "职业法术"与"种族先天 / 局内学习"的法术。我们在能力授予的那一刻（组件 Initialize，
	//   此时玩家出生装备/原始职业法术/种族法术均已就位）拍下一份"基线"，作为该角色不可
	//   剥夺的法术底线。每次换职业时：先把法术还原到基线（删除基线之后新增的一切——
	//   即上一个职业带来的法术与局内学习的法术），再叠加新职业的法术。这样既能彻底清除
	//   旧职业残留，又不会误删种族先天法术等无法重新授予的能力。
	/// 基线快照是否已拍摄（幂等保护，避免重复快照覆盖真正的初始状态）。
	var/baseline_spells_snapshotted = FALSE
	/// 基线时刻 mind.spell_list 中所有法术的"类型"集合（作为"保留底线"的判定依据）。
	var/list/baseline_spell_types
	/// 基线时刻的法术点数（总点数），换职业时据此还原，避免点数逐日累加。
	var/baseline_spell_points = 0
	/// 基线时刻的已用法术点数，与总点数配套还原。
	var/baseline_used_spell_points = 0

// Initialize：组件创建时调用，负责类型校验、注册清晨信号、打上身份特性标签。
/datum/component/martins_morning/Initialize()
	. = ..()
	// 本能力依赖人类专属的职业 / advclass / 技能 / 睡眠体系，挂到非人类身上没有意义且会出错，
	//   返回 COMPONENT_INCOMPATIBLE 让引擎丢弃本组件。
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/human/host = parent

	// 注册 COMSIG_MOB_DAWNED：这是引擎在"清晨（dawn）"时对每个人类 mob 发出的信号
	//   （nightshift.dm update_tod("dawn") 中 SEND_SIGNAL）。以此驱动"每天清晨"的触发。
	RegisterSignal(host, COMSIG_MOB_DAWNED, PROC_REF(on_dawned))

	// 打身份特性标签：标记此人拥有"马丁的早晨"，便于本文件及其它系统用 HAS_TRAIT 识别。
	//   来源标签复用特性键本身，移除时一一对应。
	ADD_TRAIT(host, TRAIT_MARTINS_MORNING, TRAIT_MARTINS_MORNING)

	// 立即拍摄法术基线快照。组件在出生流程的 apply_character_post_equipment 阶段被挂载，
	//   此刻角色的"原始职业法术 + 种族先天法术 + 出生法术点"都已就位，正是理想的基线时机。
	//   （若此刻 mind 尚未就绪，快照会安全跳过，并在首次换职业时惰性补拍。）
	snapshot_baseline_spells(host)

// UnregisterFromParent：组件与宿主解绑时，撤销 Initialize 注册的信号与特性，避免悬空回调与残留。
/datum/component/martins_morning/UnregisterFromParent()
	if(ishuman(parent))
		var/mob/living/carbon/human/host = parent
		UnregisterSignal(host, COMSIG_MOB_DAWNED)                                  // 反注册清晨信号，防止悬空回调。
		REMOVE_TRAIT(host, TRAIT_MARTINS_MORNING, TRAIT_MARTINS_MORNING)           // 移除身份特性标签。
	return ..()

// on_dawned：清晨信号回调。负责把宿主切入"强制沉睡 30 秒"，并排程 30 秒后的职业切换。
// 为什么标 SIGNAL_HANDLER：信号回调是同步调用，绝不能 sleep。本过程只做布尔判断、
//   一次非阻塞的 SetSleeping 与一次 addtimer 排程（均不阻塞），符合 SIGNAL_HANDLER 约束。
//   真正会"耗时"的换装 / 换技能逻辑被放进 addtimer 的回调（on_morning_wake）里执行，
//   那里是普通过程，允许 sleep。
/datum/component/martins_morning/proc/on_dawned(datum/source)
	SIGNAL_HANDLER

	// 防御：宿主异常则不处理本次清晨。
	if(!ishuman(parent))
		return
	var/mob/living/carbon/human/host = parent

	// 死亡者不触发：对尸体施加强睡 / 换职业既无意义也会误导玩家，直接跳过。
	if(host.stat == DEAD)
		return

	// 幂等保护：若本清晨的流程已在进行中，则不重复强睡 / 排程。
	if(morning_in_progress)
		return

	// 二次校验"能睡眠"：玩家可能在游戏中后天获得 TRAIT_NOSLEEP（如某些事件 / 状态）。
	//   既然失眠者无法被强睡，此时跳过本次清晨流程（不报错，仅安静返回）。
	if(HAS_TRAIT(host, TRAIT_NOSLEEP))
		return

	// 标记流程开始，进入幂等保护区间。
	morning_in_progress = TRUE

	// 给出醒目的叙事反馈，让玩家明白"又一个马丁的早晨开始了"，否则机制对玩家不可见。
	to_chat(host, span_notice("<b>马丁，马丁……清晨来临，一阵无法抗拒的睡意将你拉入梦乡。\
								当你醒来时，你又会成为另一个人……</b>"))

	// 强制沉睡 30 秒。SetSleeping 直接把睡眠剩余时长设为目标值；
	//   ignore_canstun = TRUE 绕过 TRAIT_SLEEPIMMUNE 等抗性，确保"强制"语义成立。
	host.SetSleeping(MARTINS_MORNING_SLEEP_DURATION, TRUE, TRUE)

	// 30 秒后（即"醒来时"）执行职业切换。用 addtimer 非阻塞延迟，不会卡住信号链。
	//   回调指向组件自身的 on_morning_wake，由它完成唤醒与换职业。
	addtimer(CALLBACK(src, PROC_REF(on_morning_wake)), MARTINS_MORNING_SLEEP_DURATION)

// on_morning_wake：强睡计时器到点后执行——确保宿主醒来，然后执行随机换职业。
// 为什么是普通过程（非 SIGNAL_HANDLER）：它由 addtimer 调用，允许 sleep；
//   而装备 / 技能应用过程（equipOutfit 等）可能 sleep，必须在这种上下文里执行。
/datum/component/martins_morning/proc/on_morning_wake()
	// 无论后续结果如何，先解除幂等标记，让下一个清晨能重新触发。
	morning_in_progress = FALSE

	// 防御：等待期间宿主可能被删除或不再是人类。
	if(!ishuman(parent))
		return
	var/mob/living/carbon/human/host = parent
	if(QDELETED(host))
		return

	// 防御：等待期间宿主可能已死亡——死人不换职业，安静返回。
	if(host.stat == DEAD)
		return

	// 明确唤醒宿主：把睡眠剩余时长清零，保证"醒来"这一语义在换职业前成立
	//   （即便存在其它来源叠加的睡眠，也以本机制"醒来即换"为准）。
	host.SetSleeping(0)

	// 执行真正的随机职业切换（含完整错误处理）。
	do_profession_switch(host)

// do_profession_switch：核心逻辑——挑选一个不同的随机职业（advclass），撤销当前职业的
//   属性 / 特性影响，清空技能与装备，再以新职业完整重装，"仿佛从一开始就选了它"。
/datum/component/martins_morning/proc/do_profession_switch(mob/living/carbon/human/host)
	// 为什么 set waitfor = FALSE：本过程内部会调用 equipOutfit 等可能 sleep 的过程，
	//   而它由 addtimer 的回调链触发。设为不等待可避免长时间阻塞 SStimer 子系统，
	//   与引擎 advclass.equipme() 同样采用 `set waitfor = FALSE` 的设计意图一致。
	set waitfor = FALSE
	// 防御：宿主无效直接退出。
	if(!istype(host) || QDELETED(host))
		return

	// ---- 1. 挑选新职业 ----
	// 为什么先挑选再动手：若没有可切换的候选职业，应当原样保留现状，不破坏玩家已有装备 / 技能。
	var/datum/advclass/new_profession = pick_random_profession(host)
	if(!new_profession)
		// 没有任何合法候选（极端情况：子系统未就绪 / 候选都被过滤掉）。
		//   如实告知玩家"今天没有变化"，不做任何破坏性改动。
		to_chat(host, span_warning("马丁的早晨今天失了灵——你醒来后，依旧是原来的自己。"))
		return

	// ---- 2. 撤销当前职业（advclass）施加的属性与特性 ----
	// 为什么要撤销：需求要求新职业"仿佛从一开始就选择"，即不应叠加上一个职业的属性 / 特性。
	//   我们尽力把当前 advclass 的影响回退，再应用新职业，使结果尽量干净。
	undo_current_profession(host)

	// ---- 3. 清空技能 ----
	// 为什么清空：新职业的技能应当从零基线重新给予（adjust_skillrank_up_to 只升不降，
	//   若不清空，旧职业的高技能会被保留，违背"从头开始"的语义）。
	reset_skills(host)

	// ---- 4. 清空当前装备 ----
	// 为什么用 delete_equipment：它会安全销毁全部穿戴与手持物品（不掉落满地），
	//   为穿上新职业的整套装束腾出所有槽位。
	host.delete_equipment()

	// ---- 5. 法术还原到基线 ----
	// 删除"基线之后新增的一切法术"（上一个职业的职业法术、局内学习的法术），并把法术点
	//   还原到基线，避免点数与法术逐日累加。基线本身（种族先天 / 原始职业 / 出生法术）保留。
	//   随后第 6 步会叠加新职业的法术点，由引擎重新发放新职业对应的法术。
	restore_spells_to_baseline(host)

	// ---- 6. 以新职业完整重装 ----
	// 在新职业身上应用：外观装备 + 属性 + 技能 + 特性 + 语言 + 社会等级 + 法术点 等。
	apply_profession(host, new_profession)

	// ---- 7. 反馈 ----
	// 给出醒目提示，让玩家清楚自己变成了什么职业，并营造"马丁的早晨"的荒诞收尾。
	host.visible_message(span_warning("[host] 揉了揉眼睛，仿佛变了一个人。"), \
						span_nicegreen("<b>你睁开眼——你现在是【[new_profession.name]】了。\
										你的故事，确实太奇怪了。</b>"))

// pick_random_profession：从"日常职业"类别（朝圣者 / 镇民）中随机挑选一个与当前不同、
//   且与本角色（种族 / 性别 / 年龄 / 守护神）兼容的 advclass 实例。挑不到返回 null。
/datum/component/martins_morning/proc/pick_random_profession(mob/living/carbon/human/host)
	// 防御：角色数据子系统未就绪 / 缺失则无法挑选。
	if(!SSrole_class_handler || !islist(SSrole_class_handler.sorted_class_categories))
		return null

	// 为什么选 CTAG_PILGRIM + CTAG_TOWNER：这两类标签下挂的是玩家可正常选取的"日常职业"
	//   （农夫、铁匠、猎人、吟游诗人……），既符合"随机变成另一个职业"的预期，又能避开
	//   反派 / 特殊机制类（如刺客、僵尸、部落等）造成的破坏性副作用。
	var/list/category_pool = list()
	if(islist(SSrole_class_handler.sorted_class_categories[CTAG_PILGRIM]))
		category_pool |= SSrole_class_handler.sorted_class_categories[CTAG_PILGRIM]
	if(islist(SSrole_class_handler.sorted_class_categories[CTAG_TOWNER]))
		category_pool |= SSrole_class_handler.sorted_class_categories[CTAG_TOWNER]

	// 在候选池基础上做兼容性过滤，得到本角色真正可以变成的职业列表。
	var/list/valid_choices = list()
	for(var/datum/advclass/candidate as anything in category_pool)
		// 跳过无效项（防御列表中混入空值）。
		if(!istype(candidate))
			continue
		// 跳过"当前职业"：需求要求切换为"另一个"职业。host.advjob 记录的是当前 advclass 名。
		if(candidate.name == host.advjob)
			continue
		// 兼容性校验：避免给角色套上其种族 / 性别 / 年龄 / 守护神不允许的职业，
		//   否则可能出现外观错乱或与角色设定冲突。
		if(!profession_is_compatible(host, candidate))
			continue
		valid_choices += candidate

	// 没有任何合法候选时返回 null，交由上层做"今天没有变化"的优雅处理。
	if(!length(valid_choices))
		return null

	// 从合法候选里等概率随机挑一个，作为今天的新职业。
	return pick(valid_choices)

// profession_is_compatible：判断某个 advclass 是否与本角色兼容。
// 为什么不直接复用 advclass.check_requirements：后者内含 prob(pickprob) 随机门、
//   maximum_possible_slots 名额限制与 PQ 检查，这些会让"是否可选"带上随机性与全局副作用，
//   不适合用作纯粹的"兼容性筛选"。这里只复刻其中确定性的、与角色身体强相关的子集
//   （性别 / 种族 / 年龄 / 守护神），保证筛选结果稳定且无副作用。
/datum/component/martins_morning/proc/profession_is_compatible(mob/living/carbon/human/host, datum/advclass/candidate)
	// 性别限制：若该职业限定性别且本角色性别不在其中，则不兼容。
	//   （此处不处理种族 gender_swapping 的复杂换算，保守地按当前 gender 判断，足够安全。）
	if(length(candidate.allowed_sexes) && !(host.gender in candidate.allowed_sexes))
		return FALSE
	// 种族允许列表：allowed_races 存的是种族 type。若设置了且本角色种族不在其中，则不兼容。
	if(length(candidate.allowed_races) && !(host.dna.species.type in candidate.allowed_races))
		return FALSE
	// 种族禁止列表：若本角色种族被该职业明确禁止，则不兼容。
	if(length(candidate.disallowed_races) && (host.dna.species.type in candidate.disallowed_races))
		return FALSE
	// 年龄限制：若设置了允许年龄段且本角色年龄不在其中，则不兼容。
	if(length(candidate.allowed_ages) && !(host.age in candidate.allowed_ages))
		return FALSE
	// 守护神限制：若设置了允许守护神且本角色的守护神不在其中，则不兼容。
	if(length(candidate.allowed_patrons) && !(host.patron in candidate.allowed_patrons))
		return FALSE
	// 全部限制均通过：兼容。
	return TRUE

// undo_current_profession：尽力撤销"当前 advclass"对角色施加的属性与特性影响，
//   以便新职业能在尽量干净的基线上应用，贴合"从一开始就选了新职业"的语义。
/datum/component/martins_morning/proc/undo_current_profession(mob/living/carbon/human/host)
	// 通过当前 advjob 名反查当前职业数据单。若查不到（如 advjob 为空、或为
	//   adaptive_name 生成的组合名），说明无从精确回退——直接返回，跳过本步即可
	//   （这是可接受的、有文档说明的降级：不回退旧加成，仅叠加新职业）。
	if(!host.advjob)
		return
	var/datum/advclass/current = SSrole_class_handler.get_advclass_by_name(host.advjob)
	if(!istype(current))
		return

	// 撤销当前职业的特性：equipme 当初是以 ADVENTURER_TRAIT 为来源添加 traits_applied 的，
	//   这里以同一来源逐一移除，做到精确撤销、不误伤其它来源施加的同名特性。
	if(length(current.traits_applied))
		for(var/trait in current.traits_applied)
			REMOVE_TRAIT(host, trait, ADVENTURER_TRAIT)

	// 撤销当前职业的属性加成：把 subclass_stats 的每项增量反向施加回去。
	//   注意（已知局限）：change_stat 会把属性夹在 1~20。若当初的加成曾被上限截断，
	//   反向回退可能与"完全精确还原"略有偏差。这是温和且可接受的近似，已在此说明。
	if(length(current.subclass_stats))
		for(var/stat in current.subclass_stats)
			host.change_stat(stat, -current.subclass_stats[stat])

// reset_skills：把角色的全部技能清空到"无"基线，便于新职业从零授予技能。
// 为什么直接重置存储而不用 adjust_skillrank 负向调整：后者会产生大量"技能下降"的聊天刷屏，
//   且需要逐级回退；直接清空底层存储（known_skills / skill_experience）更干净、无副作用，
//   与 never_ending.dm 直接覆写技能快照的做法思路一致。
/datum/component/martins_morning/proc/reset_skills(mob/living/carbon/human/host)
	// ensure_skills() 保证技能持有者存在（首次访问时惰性创建）。
	var/datum/skill_holder/holder = host.ensure_skills()
	if(!holder)
		return
	// 清空"已知技能等级"表：清空后所有技能等级回落到 SKILL_LEVEL_NONE（get_skill_level 的缺省）。
	holder.known_skills = list()
	// 把"技能经验"逐项归零：保留键（技能单例）不变，仅把经验值清零，
	//   这样后续 adjust_skillrank_up_to 能从 0 经验正确地把新职业技能升到目标等级。
	for(var/skill in holder.skill_experience)
		holder.skill_experience[skill] = 0

// snapshot_baseline_spells：拍摄角色当前法术状态作为"不可剥夺的基线"。
// 为什么以"类型集合"而非实例来记录：换职业时我们只需判断"某法术是否属于基线"，
//   用类型比对即可（与引擎 has_spell / RemoveSpell 的按类型匹配思路一致）；基线法术
//   在还原时从不被删除，因此无需保存其实例用于重建。
/datum/component/martins_morning/proc/snapshot_baseline_spells(mob/living/carbon/human/host)
	// 幂等：已拍摄过就不再覆盖，确保基线永远是"最初"状态。
	if(baseline_spells_snapshotted)
		return
	// 没有 mind 就没有 spell_list / 法术点可言；此时不强行快照，留待首次换职业时惰性补拍。
	if(!host?.mind)
		return
	// 记录基线法术的类型集合。逐一取每个法术实例的 type 存入列表。
	baseline_spell_types = list()
	for(var/obj/effect/proc_holder/spell/S in host.mind.spell_list)
		baseline_spell_types += S.type
	// 记录基线法术点数（用 || 0 把可能为 null 的初值规整为数字，便于后续算术与还原）。
	baseline_spell_points = host.mind.spell_points || 0
	baseline_used_spell_points = host.mind.used_spell_points || 0
	// 标记快照完成，进入幂等保护。
	baseline_spells_snapshotted = TRUE

// restore_spells_to_baseline：把角色法术还原到基线——删除基线之后新增的所有法术，
//   并把法术点还原到基线值。基线法术（种族先天 / 原始职业 / 出生发放）一律保留。
/datum/component/martins_morning/proc/restore_spells_to_baseline(mob/living/carbon/human/host)
	// 防御：没有 mind 无从处理法术。
	if(!host?.mind)
		return
	// 惰性补拍：若 Initialize 时 mind 尚未就绪导致未拍快照，则此刻把"当前状态"当作基线，
	//   并直接返回（既然此刻才确立基线，就没有"基线之后新增"的法术需要删除）。
	if(!baseline_spells_snapshotted)
		snapshot_baseline_spells(host)
		return
	// 删除"非基线"法术：遍历 spell_list 的副本（避免在遍历中修改原列表导致漏删），
	//   凡类型不在基线集合中的法术，即为上一个职业 / 局内学习新增的，予以移除。
	for(var/obj/effect/proc_holder/spell/S in host.mind.spell_list.Copy())
		if(!(S.type in baseline_spell_types))
			host.mind.RemoveSpell(S)
	// 法术点还原到基线：防止"每天叠加新职业法术点"导致点数无限累加。
	//   新职业的法术点会在随后的 apply_profession → adjust_spellpoints 中重新叠加上来。
	host.mind.spell_points = baseline_spell_points
	host.mind.used_spell_points = baseline_used_spell_points

// apply_profession：在角色身上应用一个 advclass 的全部"职业内容"。
// 为什么不直接调用 advclass.equipme()：equipme() 末尾会调用 apply_character_post_equipment()，
//   后者会按玩家预设重新施加【美德 / 缺陷 / 出身 / 种族加成 / 装载物】等。这会带来两个严重问题：
//     1) 重新施加"马丁的早晨"美德 → 走 apply_virtue → check_triumphs 会再次扣 23 凯旋点（每天扣！）；
//     2) 重复施加缺陷 / 出身 / 种族加成，造成属性与特性不断叠加。
//   因此这里手动复刻 equipme() 中"与职业本身相关"的部分（装备 / 属性 / 技能 / 特性 / 语言 /
//   社会等级 / 法术点 / 藏匿物品 / 战斗音乐），刻意跳过 post-equipment，规避上述副作用。
/datum/component/martins_morning/proc/apply_profession(mob/living/carbon/human/host, datum/advclass/profession)
	// 防御：参数无效则不操作。
	if(!istype(host) || !istype(profession))
		return

	// ---- 外观装备 ----
	// 穿上新职业的整套服装 / 道具。equipOutfit 可能 sleep，故本过程运行在 addtimer 回调里（允许 sleep）。
	if(profession.outfit)
		host.equipOutfit(profession.outfit)

	// ---- 记录当前职业名 ----
	// advjob 是引擎用来标识"角色当前 advclass"的字段（examine、下次回退都依赖它）。
	host.advjob = profession.name

	// ---- 特性 ----
	// 以 ADVENTURER_TRAIT 为来源添加新职业特性（与 equipme 保持一致，便于将来按同一来源回退）。
	//   跳过该角色种族明确禁用的特性，避免冲突。
	if(length(profession.traits_applied))
		for(var/trait in profession.traits_applied)
			if(trait in host.dna.species.banned_traits)
				continue
			ADD_TRAIT(host, trait, ADVENTURER_TRAIT)

	// ---- 语言 ----
	// 授予新职业附带的语言。语言为叠加授予、无明显副作用，故不强求回退旧语言（可接受的近似）。
	if(length(profession.subclass_languages))
		for(var/lang in profession.subclass_languages)
			host.grant_language(lang)

	// ---- 属性 ----
	// 施加新职业的属性加成（change_stat 自带 1~20 夹取保护）。
	if(length(profession.subclass_stats))
		for(var/stat in profession.subclass_stats)
			host.change_stat(stat, profession.subclass_stats[stat])

	// ---- 技能 ----
	// 把新职业技能升至目标等级。silent = TRUE 抑制"技能提升"刷屏（一次性大量授予时尤其需要）。
	if(length(profession.subclass_skills))
		for(var/skill in profession.subclass_skills)
			host.adjust_skillrank_up_to(skill, profession.subclass_skills[skill], TRUE)

	// ---- 藏匿物品 ----
	// 把新职业的藏匿物品登记进 mind.special_items（需要有 mind 才有该存储）。
	if(length(profession.subclass_stashed_items) && host.mind)
		for(var/stashed_item in profession.subclass_stashed_items)
			host.mind.special_items[stashed_item] = profession.subclass_stashed_items[stashed_item]

	// ---- 法术点 ----
	// 若新职业提供初始法术点，则按量发放（需要有 mind）。
	if(profession.subclass_spellpoints > 0)
		host.mind?.adjust_spellpoints(profession.subclass_spellpoints)

	// ---- 社会等级 ----
	// 覆盖角色的社会等级为新职业设定（影响 examine 等表现）。
	if(profession.subclass_social_rank)
		host.social_rank = profession.subclass_social_rank

	// ---- 战斗音乐 ----
	// 若新职业定义了战斗模式 BGM，则同步给角色（与 advclass.post_equip 行为一致）。
	if(profession.cmode_music)
		host.cmode_music = profession.cmode_music


// ----------------------------------------------------------------------------
// 清理本文件内部使用的计时宏，避免污染全局编译命名空间。
// 为什么保留 TRAIT_MARTINS_MORNING 不 #undef：它是对外可见的"身份标签"，其它系统
//   可能需要用 HAS_TRAIT 查询，这与 modular_z121 内其它特性键（如
//   TRAIT_DESIGNATED_PERFORMER、TRAIT_LIFE_POTENTIAL）保持全局可见的约定一致。
// ----------------------------------------------------------------------------
#undef MARTINS_MORNING_SLEEP_DURATION
