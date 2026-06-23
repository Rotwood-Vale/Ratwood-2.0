// ============================================================================
// modular_z121/virtues/distortion_variant.dm
// 自定义美德（Custom Virtue）：畸变变种 / Distortion Variant
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   实现一个全新的、需消耗 6 点凯旋点数（triumph_cost = 6）的被动美德"畸变变种"。
//   背景：你曾被施以可怖的实验，肉体因此变得极不稳定——你的种族每天都会切换一次。
//   限制（Requirement）：【仅限血肉之躯（flesh and blood）的角色可获取】。
//   授予特性【畸变变种】，其效果为：
//     - 每天夜晚（游戏内 night 时刻），你的身体会在【剧烈的疼痛】中重塑，随机切换成
//       另一个【血肉之躯】的种族。
//     - 切换的目标【只会是血肉之躯的种族】（绝不会变成构造体 / 史莱姆 / 不死亡灵等）。
//     - 切换种族后，会【清除上一个种族赋予的特性与能力】（见下方关于 set_species 的说明）。
//     - 该特性在游戏内对玩家可见（Make the added trait visible to players）：
//         1) 任何人检视（examine）该角色时，会在检视文本里看到一行【畸变变种】说明（检视组件）；
//         2) 持有者点开自己的特性自检面板时，也能看到【畸变变种】及其说明（登记进 GLOB.roguetraits）。
//
// 关于"切换种族后清除上一个种族的特性与能力"——为什么用 set_species() 即可满足：
//   引擎的 /mob/living/carbon/set_species()（code/datums/dna.dm）在切换时会：
//     1) 先对【旧种族】调用 on_species_loss()：移除旧种族的 inherent_traits（来源 SPECIES_TRAIT）、
//        inherent_skills、inherent_factions、语言、飞行能力（fly.Remove + QDEL_NULL）、移速修正等；
//        各具体种族还可覆写 on_species_loss 清理自己额外授予的能力（如 Ooze 的变形术）。
//     2) 再对【新种族】调用 on_species_gain()：授予新种族的特性 / 技能 / 语言 / 能力。
//   因此"清除上一个种族赋予的特性与能力"由引擎在 set_species 内部完整处理，我们只需调用它，
//   切忌直接改写 dna.species（那样会跳过上述清理，导致旧种族的特性 / 能力残留）。
//   注意：本美德自己的身份特性【畸变变种】来源用 TRAIT_VIRTUE（非 SPECIES_TRAIT），
//   所以 on_species_loss 不会误删它；驱动组件挂在 mob 上（非种族上），换种族也不会丢失。
//
// 为什么所有逻辑都放在本文件内（合规性）：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外的任何文件。
//   本文件仅通过"派生 /datum/virtue 子类型"与"派生 /datum/component / 追加全局 proc"接入引擎——
//   这属于"追加"而非"修改核心文件"，符合约束。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承，不修改其源文件）：
//   - /datum/virtue                              美德基类（modular_azurepeak/_virtue.dm）；
//                                                 apply_virtue() 流程：先 check_triumphs() 扣点，再 apply_to_human()。
//   - /datum/component                            组件基类（挂载入夜信号与生命周期管理）。
//   - COMSIG_MOB_NIGHTED                          入夜信号（nightshift.dm update_tod("night") 对每个人类 mob 发出）。
//   - /mob/living/carbon/set_species(种族, ...)   切换种族（含旧种族清理 + 新种族授予，见上）。
//   - subtypesof(/datum/species)                  枚举全部种族，用于筛选"血肉之躯"候选池。
//   - /datum/species 的字段：name / id / construct / species_traits / inherent_biotypes / changesource_flags。
//   - NOBLOOD / INVISBLOOD（code/__DEFINES/DNA.dm）  种族 species_traits 中的"无血 / 非真实血液"标记。
//   - MOB_UNDEAD（code/__DEFINES/mobs.dm）          不死亡灵生物类型位。
//   - RACE_SWAP（code/__DEFINES/mobs.dm）           "可作为变身 / 换种族目标"的合法标记（排除野化形态等）。
//   - /mob/proc/emote() / Knockdown() / Stun() / Jitter()   实现"剧烈疼痛"的表现（嚎叫 / 倒地 / 抽搐）。
//   - /mob/proc/adjust_triumphs(n, FALSE)        调整凯旋点数（种族不符时退款）。
//   - /datum/component + COMSIG_PARENT_EXAMINE    检视组件，让特性"被他人检视可见"。
//   - GLOB.roguetraits                            玩家特性自检面板的全局表（让特性"被本人面板可见"）。
//   - TRAIT_VIRTUE                                美德授予特性时的统一来源标签（便于统一清理 / 不被换种族误删）。
//
// 加载与注册（均在 modular_z121 内完成）：
//   - modular_z121/_load.dm                       以 #include 引入本文件。
//   - modular_z121/bootstrap/custom_bootstrap.dm  在其 Initialize 中调用 register_distortion_variant_trait()。
// ============================================================================


// ----------------------------------------------------------------------------
// 自定义特性键（Trait key）：畸变变种
// 为什么定义：用一个唯一字符串标识"持有畸变变种美德"的人，供 HAS_TRAIT 判断身份、
//   检视显示、面板登记等共同使用，并作为 ADD_TRAIT 的来源标签。
// 为什么特性值直接用可读中文名"畸变变种"（而非英文 slug）：引擎的玩家特性自检面板
//   （_onclick/hud/screen_objects.dm）会把"特性字符串本身"当作标题打印（[X] - 说明），
//   用可读中文做值，玩家点开面板即可看到体面的特性名"畸变变种"。该串已确认全项目未占用，
//   不会与现有特性造成 HAS_TRAIT 歧义。
// ----------------------------------------------------------------------------
#define TRAIT_DISTORTION_VARIANT "畸变变种"

// 每个夜晚"剧烈疼痛"持续的时长：4 秒。期间角色倒地抽搐，结束时身体完成种族重塑。
// 单列为常量，便于将来平衡性调整时只改这一处。
#define DISTORTION_PAIN_DURATION (4 SECONDS)


// ----------------------------------------------------------------------------
// 工具过程（全局）：判断某个【种族实例】是否为"血肉之躯（flesh and blood）"。
// 为什么做成全局 proc：既要用于"领取美德时校验领取者是否血肉之躯"（在虚拟 datum 单例里调用），
//   也要用于"筛选每日切换的目标种族"（在组件里调用），抽成全局 proc 两处共用、口径一致。
// 判定口径（满足任一排除条件即【非】血肉之躯）：
//   - 不是有效种族 / 缺少 name 或 id：异常或抽象占位种族，排除。
//   - 是构造体（/datum/species/construct 及其全部子类，如金属构装体 / 瓷偶）：非血肉，排除。
//   - 是亡魂（/datum/species/dullahan，设定上是"死而复生"的伪不死）：非血肉之躯，排除。
//   - species_traits 含 NOBLOOD（无血，如瓷偶）：没有"血"，排除。
//   - species_traits 含 INVISBLOOD（非真实血液，如史莱姆 Ooze）：没有真正的血肉，排除。
//   - inherent_biotypes 含 MOB_UNDEAD（不死亡灵生物位）：非活体血肉，排除。
//   其余视为"血肉之躯"。注意：构造体 / 亡魂用 istype 判定，可一并覆盖其未来新增的子种族。
// ----------------------------------------------------------------------------
/proc/distortion_species_is_flesh_and_blood(datum/species/S)
	// 防御：传入的不是有效种族实例，直接判定为"非血肉"，避免空引用。
	if(!istype(S))
		return FALSE
	// 抽象 / 异常占位种族（无名或无 id）不应作为可切换对象，排除。
	if(!S.name || !S.id)
		return FALSE
	// 构造体（瓷偶 / 金属构装体等）整支谱系：以泥土 / 金属 / 魔法塑成，非血肉，排除。
	if(istype(S, /datum/species/construct))
		return FALSE
	// 亡魂（Revenant）：设定为"死而复生"的伪不死，断头亦可活，归类为非血肉之躯，排除。
	if(istype(S, /datum/species/dullahan))
		return FALSE
	// 种族层面的构造体标记（construct = 1）：与上面的 istype 互为补充，双保险排除构造体。
	if(S.construct)
		return FALSE
	// NOBLOOD：该种族"没有血"（如瓷偶），不符合"血肉之躯"的"血"，排除。
	if(NOBLOOD in S.species_traits)
		return FALSE
	// INVISBLOOD：该种族的"血"并非真实血液（如史莱姆 Ooze 的体液），排除。
	if(INVISBLOOD in S.species_traits)
		return FALSE
	// 不死亡灵生物位：非活体血肉，排除。
	if(S.inherent_biotypes & MOB_UNDEAD)
		return FALSE
	// 通过全部排除项：判定为血肉之躯。
	return TRUE


// ----------------------------------------------------------------------------
// 美德定义：畸变变种
// 为什么归入 /datum/virtue/utility 分支：与 life_potential（生命潜能）、hellblood_descendant
//   （地狱血脉后裔）等"效用型"被动美德保持一致；作为 /datum/virtue 子类型，会被
//   global_lists.dm 的 subtypesof() 自动收录进 GLOB.virtues，无需手动注册。
// ----------------------------------------------------------------------------
/datum/virtue/utility/distortion_variant
	// 菜单中显示的美德名（"仅限血肉之躯"是限制说明，不写进名字本身）。
	name = "畸变变种"
	// 角色内描述（in-character）：呼应"被恐怖实验改造、肉体极不稳定、每日变种"的设定基调。
	desc = "你曾被施以可怖的实验，肉体因此变得极不稳定——你的种族每天都会切换一次。\
			每个夜晚，剧痛都会贯穿全身，你的血肉与骨骼在痛苦中重塑成另一副模样。"
	// custom_text 用机制语言把硬性规则讲清楚：适用对象、代价、以及核心效果。
	custom_text = "【仅限血肉之躯（flesh and blood）的角色获取】\n\
	消耗 6 点凯旋点数。获得【畸变变种】特性：\n\
	· 每天夜晚，你会在剧烈的疼痛中随机切换成另一个【血肉之躯】的种族；\n\
	· 变种只会变成血肉之躯的种族，绝不会变成构造体 / 史莱姆 / 亡魂等非血肉种族；\n\
	· 换种族时，上一个种族赋予的特性与能力会被一并清除（由引擎换种族流程处理）。"
	// 消耗 6 点凯旋点数。基类 New() 会自动把"Costs 6 TRIUMPH"追加进 desc；
	//   check_triumphs() 会在 apply_virtue 流程开头校验并扣除；若领取者非血肉之躯，
	//   apply_to_human 会把这笔点数全额退还（见下）。
	triumph_cost = 6
	// 为什么"不"用任何静态通道（added_traits / added_stats 等）：
	//   所有效果都必须先通过"血肉之躯"判定后才允许授予，而 handle_traits / handle_stats 等
	//   都在 apply_to_human 之后【无条件】执行——若把效果放进静态通道，非血肉之躯即便被
	//   apply_to_human 拒绝，仍会被这些 handle_* 施加，造成"应被拒却仍获益"。
	//   因此把【全部】效果（身份特性 + 驱动组件）都收拢进 apply_to_human，在判定通过后才施加；
	//   如此非血肉之躯路径无需回退任何东西，只需退还凯旋点数，逻辑最干净。


// ----------------------------------------------------------------------------
// apply_to_human：美德被赋予人物时调用（早于 handle_traits / handle_stats 等静态通道）。
// 流程：
//   0) 血肉之躯限制：非血肉 → 退款 + 提示，随即返回，绝不授予任何能力。
//   1) 挂载驱动组件（由组件负责：打身份特性标签、监听入夜信号、检视显示）。
// ----------------------------------------------------------------------------
/datum/virtue/utility/distortion_variant/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// 防御：没有有效人物（极端时序下可能为 null）就直接返回，避免后续空引用。
	if(!istype(recipient))
		return

	// ---- 0) 血肉之躯限制：仅血肉之躯可获取 ----
	// 为什么校验：需求明确"必须是血肉之躯的种族"。对构造体 / 史莱姆 / 亡魂等非血肉角色，
	//   "肉体在痛苦中重塑成另一副血肉之躯"在设定上不成立，故优雅降级：退款、提示、不授予能力。
	if(!distortion_species_is_flesh_and_blood(recipient.dna?.species))
		// 退还已扣除的凯旋点数：apply_virtue 顺序是 check_triumphs()（已扣 6 点）→ apply_to_human()。
		//   既然能力对非血肉者不生效，就把点数原数退回；adjust_triumphs 第二参 FALSE = 不弹提示音/特效。
		if(triumph_cost)
			recipient.adjust_triumphs(triumph_cost, FALSE)
		to_chat(recipient, span_warning("畸变变种只在血肉之躯上生效——你的躯体并非血肉所成，\
										这份不稳定的诅咒无法在你身上扎根。"))
		// 直接返回：既不挂组件、也不打标签；已扣的凯旋点数已退还。
		return

	// ---- 1) 挂载驱动组件 ----
	// 为什么挂组件而不是直接在这里 RegisterSignal / ADD_TRAIT：
	//   美德 datum 是 GLOB.virtues 里的"模板单例"，不能用它的 src 去 RegisterSignal(recipient)
	//   （回调会指向错误的 datum）。组件实例与 recipient 一一绑定，能正确管理信号注册与特性，
	//   并在宿主死亡 / qdel 时自动反注册、移除特性，避免悬空回调与状态残留。组件做了 UNIQUE 去重。
	recipient.AddComponent(/datum/component/distortion_variant)

	// 给出醒目反馈，让玩家清楚"畸变变种"已生效，否则纯被动特性对玩家不可见。
	to_chat(recipient, span_nicegreen("一股不安的悸动在血肉深处苏醒——从今往后，每个夜晚，\
										你的身体都将在剧痛中重塑成另一副模样。"))


// ----------------------------------------------------------------------------
// 驱动组件：畸变变种
// 为什么用组件：组件天然与宿主 mob 绑定，提供 Initialize / UnregisterFromParent 生命周期，
//   能干净地完成"注册入夜信号、添加身份特性、注册检视信号"，并在宿主消失时反注册、移除特性，
//   避免悬空回调与残留（与 martins_morning / hellblood_descendant 的做法一致）。
// 该组件集三职于一身：① 监听入夜信号驱动每日变种；② 提供检视可见性；③ 维护身份特性标签。
// ----------------------------------------------------------------------------
/datum/component/distortion_variant
	// 唯一组件：同一 mob 上只允许一个实例，重复 AddComponent 会被丢弃，杜绝重复监听 / 重复变种。
	dupe_mode = COMPONENT_DUPE_UNIQUE
	// 标记"本夜晚的疼痛 + 变种流程"是否正在进行中。
	// 为什么需要：入夜信号理论上每晚只发一次，但用此布尔做幂等保护，避免极端情况下
	//   （信号重入 / 时间系统抖动）在同一个夜晚重复触发疼痛或重复切换种族。
	var/night_in_progress = FALSE

// Initialize：组件创建时调用，负责类型校验、注册入夜信号与检视信号、打上身份特性标签。
/datum/component/distortion_variant/Initialize()
	. = ..()
	// 本能力依赖人类专属的种族（dna.species）/ 睡眠 / 身体体系，挂到非人类身上无意义且会出错，
	//   返回 COMPONENT_INCOMPATIBLE 让引擎丢弃本组件。
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/human/host = parent

	// 注册 COMSIG_MOB_NIGHTED：引擎在"夜晚（night）"时对每个人类 mob 发出该信号
	//   （nightshift.dm update_tod("night") 中 SEND_SIGNAL）。以此驱动"每天夜晚"的变种。
	RegisterSignal(host, COMSIG_MOB_NIGHTED, PROC_REF(on_nighted))

	// 注册 COMSIG_PARENT_EXAMINE：让【畸变变种】特性"被他人检视可见"（见 on_examine）。
	RegisterSignal(host, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

	// 打身份特性标签：标记此人拥有"畸变变种"。来源用 TRAIT_VIRTUE（与引擎美德特性约定一致），
	//   关键：该来源【不是】SPECIES_TRAIT，因此每天 set_species 切换种族时不会被 on_species_loss 误删。
	ADD_TRAIT(host, TRAIT_DISTORTION_VARIANT, TRAIT_VIRTUE)

// UnregisterFromParent：组件与宿主解绑时，撤销 Initialize 注册的信号与特性，避免悬空回调与残留。
/datum/component/distortion_variant/UnregisterFromParent()
	if(ishuman(parent))
		var/mob/living/carbon/human/host = parent
		UnregisterSignal(host, COMSIG_MOB_NIGHTED)       // 反注册入夜信号，防止悬空回调。
		UnregisterSignal(host, COMSIG_PARENT_EXAMINE)    // 反注册检视信号，防止悬空回调。
		REMOVE_TRAIT(host, TRAIT_DISTORTION_VARIANT, TRAIT_VIRTUE)  // 移除身份特性标签（与添加时来源一致）。
	return ..()


// ----------------------------------------------------------------------------
// 工具过程：返回"可作为每日变种目标的【血肉之躯】种族类型清单"（带静态缓存）。
// 为什么带静态缓存：种族集合在运行期固定不变，枚举 subtypesof 并逐一 new 出来判定开销不小；
//   用 static 只在首次调用时构建一次，后续复用，避免每个夜晚重复枚举。
// 为什么额外要求 changesource_flags & RACE_SWAP：RACE_SWAP 是引擎"可作为变身 / 换种族目标"的
//   合法标记。借它把候选限定为玩家可正常游玩的种族，排除野化形态（熊 / 蜘蛛等）与不可游玩的
//   抽象种族，避免把角色变成奇怪或会出错的形态。再叠加 distortion_species_is_flesh_and_blood，
//   确保目标"既是合法可玩种族、又是血肉之躯"。
// ----------------------------------------------------------------------------
/datum/component/distortion_variant/proc/get_target_species_types()
	// static：清单只在首次调用时构建，之后所有实例 / 调用复用同一份。
	var/static/list/cached_types
	if(cached_types)
		return cached_types
	cached_types = list()
	// 枚举所有种族子类型，逐一实例化做判定（与引擎 generate_selectable_species 的做法一致：new 后 qdel）。
	for(var/species_type in subtypesof(/datum/species))
		var/datum/species/candidate = new species_type
		// 同时满足：① 血肉之躯；② 是合法的换种族目标（RACE_SWAP）。
		if(distortion_species_is_flesh_and_blood(candidate) && (candidate.changesource_flags & RACE_SWAP))
			cached_types += species_type
		// 判定完即销毁临时实例，避免内存泄漏（缓存的是【类型路径】而非实例）。
		qdel(candidate)
	return cached_types

// pick_target_species：从血肉之躯候选池中，随机挑选一个与当前种族【不同】的目标种族类型。
// 挑不到（候选池空 / 仅剩当前种族）返回 null，交由上层做"今晚没有变化"的优雅处理。
/datum/component/distortion_variant/proc/pick_target_species(mob/living/carbon/human/host)
	// 防御：宿主无效则无从判断当前种族。
	if(!istype(host))
		return null
	var/list/all_types = get_target_species_types()
	if(!length(all_types))
		return null
	// 取当前种族类型，用于排除"变成自己当前的种族"（需求要求切换为"另一个"种族）。
	var/current_type = host.dna?.species?.type
	var/list/choices = list()
	for(var/candidate_type in all_types)
		if(candidate_type == current_type)
			continue
		choices += candidate_type
	// 没有任何与当前不同的候选时返回 null。
	if(!length(choices))
		return null
	// 等概率随机挑一个，作为今晚的新种族。
	return pick(choices)


// ----------------------------------------------------------------------------
// on_nighted：入夜信号回调。仅做最小处理（防御 + 幂等 + 把重活推迟到普通过程执行）。
// 为什么标 SIGNAL_HANDLER：信号回调是同步调用，绝不能 sleep。这里只做布尔判断与一次
//   非阻塞的 addtimer 排程；真正会"耗时"的疼痛表现与换种族逻辑放进 addtimer 回调
//   （begin_distortion）里执行——那里是普通过程，可安全调用可能较重的 emote / set_species。
// ----------------------------------------------------------------------------
/datum/component/distortion_variant/proc/on_nighted(datum/source)
	SIGNAL_HANDLER

	// 防御：宿主异常则不处理本次入夜。
	if(!ishuman(parent))
		return
	var/mob/living/carbon/human/host = parent

	// 死亡者不触发：对尸体施加疼痛 / 换种族既无意义也会误导玩家，直接跳过。
	if(host.stat == DEAD)
		return

	// 幂等保护：若本夜晚的流程已在进行中，则不重复触发。
	if(night_in_progress)
		return

	// 标记流程开始，进入幂等保护区间（无论后续成败，都会在收尾处复位）。
	night_in_progress = TRUE

	// 把实际流程推迟到普通过程执行（脱离信号上下文），延迟 1 tick 即可。
	addtimer(CALLBACK(src, PROC_REF(begin_distortion)), 1)

// begin_distortion：入夜流程第一阶段——挑选目标种族并施加"剧烈疼痛"，随后排程第二阶段的变种。
// 为什么是普通过程：它由 addtimer 调用，允许调用较重 / 可能 sleep 的过程；
//   且先挑目标、再施加疼痛——若没有任何可切换目标，就不折磨玩家、原样保留现状。
/datum/component/distortion_variant/proc/begin_distortion()
	// 防御：等待期间宿主可能被删除 / 不再是人类 / 已死亡——任一情况都安静收尾。
	if(!ishuman(parent))
		night_in_progress = FALSE
		return
	var/mob/living/carbon/human/host = parent
	if(QDELETED(host) || host.stat == DEAD)
		night_in_progress = FALSE
		return

	// ---- 1. 先挑目标种族 ----
	// 为什么先挑再动手：若没有可切换的血肉之躯目标（极端情况），应原样保留现状、不无谓地折磨玩家。
	var/target_type = pick_target_species(host)
	if(!target_type)
		// 没有任何合法的"另一个血肉之躯种族"可变。如实告知玩家"今晚没有变化"，不做破坏性改动。
		to_chat(host, span_warning("一阵悸动掠过你的血肉，却又归于平静——今晚，你的身体没有发生变化。"))
		night_in_progress = FALSE
		return

	// ---- 2. 施加"剧烈疼痛"的表现 ----
	// 需求："每天夜晚，它会在你切换种族时使你剧痛。"以"嚎叫 + 倒地抽搐"具象化这份痛苦。
	apply_intense_pain(host)

	// ---- 3. 排程第二阶段：疼痛持续 DISTORTION_PAIN_DURATION 后，完成种族切换 ----
	// 用 addtimer 非阻塞延迟，把目标种族类型经回调参数传入 finish_distortion。
	addtimer(CALLBACK(src, PROC_REF(finish_distortion), target_type), DISTORTION_PAIN_DURATION)

// apply_intense_pain：以一组非阻塞表现具象化"剧烈疼痛"——痛苦嚎叫、倒地、抽搐。
// 为什么这样实现：引擎没有单一的"造成纯疼痛"入口；用"强制痛苦嚎叫 emote + 击倒 + 眩晕 + 抖动"
//   组合，既直观传达剧痛、又不会对角色造成永久伤害（变种是诅咒而非致死手段）。所有调用均不 sleep。
/datum/component/distortion_variant/proc/apply_intense_pain(mob/living/carbon/human/host)
	// 防御：宿主无效则不施加。
	if(!istype(host) || QDELETED(host))
		return
	// 叙事提示：让玩家明确"剧痛降临、身体开始重塑"，否则机制对玩家不可见。
	to_chat(host, span_userdanger("毫无征兆地，剧痛贯穿全身——你的血肉翻涌沸腾，骨骼在皮肉下\
									嘎吱重组，仿佛整副躯体都要被撕碎重塑！"))
	// 强制"痛苦嚎叫"emote：forced = TRUE 确保即便非玩家主动也会发出，传达剧痛。
	host.emote("painscream", forced = TRUE)
	// 击倒：疼痛令角色瘫软倒地，持续整个疼痛时长（直到变种完成）。
	host.Knockdown(DISTORTION_PAIN_DURATION)
	// 短暂眩晕：开头 2 秒完全无法行动，强化"被剧痛攫住"的瞬间。
	host.Stun(2 SECONDS)
	// 抖动：身体在痛苦中不受控地抽搐（数值为抖动强度 / 时长，纯表现，不致伤）。
	host.Jitter(100)

// finish_distortion：入夜流程第二阶段——疼痛过后，真正把角色切换成目标血肉之躯种族。
// 为什么是普通过程：它由 addtimer 调用；set_species 可能较重（重建身体 / 器官 / 外观），在此安全执行。
// 关键：通过 set_species() 切换，引擎会先清理旧种族的特性 / 技能 / 语言 / 能力（on_species_loss），
//   再授予新种族对应内容（on_species_gain），从而满足需求"清除上一个种族赋予的特性与能力"。
/datum/component/distortion_variant/proc/finish_distortion(target_type)
	// 无论后续结果如何，先解除幂等标记，让下一个夜晚能重新触发。
	night_in_progress = FALSE

	// 防御：等待期间宿主可能被删除 / 不再是人类 / 已死亡——任一情况都安静返回，不做切换。
	if(!ishuman(parent))
		return
	var/mob/living/carbon/human/host = parent
	if(QDELETED(host) || host.stat == DEAD)
		return

	// 防御：目标种族类型异常（理论上不会，begin_distortion 已校验），或目标恰好已是当前种族，则跳过切换。
	if(!ispath(target_type, /datum/species))
		to_chat(host, span_warning("身体的重塑在最后一刻失了准头——你回过神时，依旧是原来的种族。"))
		return
	if(host.dna?.species?.type == target_type)
		return

	// 取目标种族名用于反馈（实例化前先拿一个临时实例读取 name；set_species 接受类型路径，会自行实例化）。
	//   为什么单独读 name：set_species 内部会 new 一份新种族对象，我们这里只为给玩家一句可读反馈。
	var/datum/species/preview = new target_type
	var/new_name = preview.name
	qdel(preview)  // 仅用于取名的临时实例，用完即销毁，避免泄漏。

	// ---- 执行种族切换 ----
	// set_species(类型路径)：内部 on_species_loss(旧) 清理旧种族特性/技能/语言/能力，
	//   再 on_species_gain(新) 授予新种族内容，并刷新身体/器官/外观（human 覆写里 update_body 等）。
	//   这正是"换种族 + 清除上一个种族的特性与能力"所需的完整流程，无需我们手动逐项清理。
	host.set_species(target_type)

	// 切换后做一次健壮性兜底：确保身份特性【畸变变种】仍在（其来源是 TRAIT_VIRTUE，本不会被
	//   on_species_loss 误删，这里仅作双保险；ADD_TRAIT 幂等，重复添加同源不会出问题）。
	if(!HAS_TRAIT(host, TRAIT_DISTORTION_VARIANT))
		ADD_TRAIT(host, TRAIT_DISTORTION_VARIANT, TRAIT_VIRTUE)

	// 收尾反馈：让玩家清楚自己变成了什么种族，并营造"痛苦重塑后回神"的收束感。
	host.visible_message(span_warning("[host] 在一阵痉挛后瘫软下来，身形竟在众目睽睽下扭曲、重塑……"), \
						span_nicegreen("<b>剧痛终于退去。你回过神来——这副血肉如今属于一个【[new_name]】了。</b>"))


// ----------------------------------------------------------------------------
// on_examine：检视回调，向检视文本追加一行"畸变变种"提示，使特性在游戏内被他人检视可见。
// 为什么标 SIGNAL_HANDLER：检视信号同步触发，回调内只拼接文本、不可 sleep。
// 为什么以 HAS_TRAIT 为条件而非无条件追加：万一特性已被其它系统移除（如美德被清除），
//   提示也应随之消失，保证"看到提示 = 确实拥有特性"严格一致。
// ----------------------------------------------------------------------------
/datum/component/distortion_variant/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	// 防御：宿主异常或已不再持有特性，则不追加任何文本。
	if(!ishuman(parent))
		return
	if(!HAS_TRAIT(parent, TRAIT_DISTORTION_VARIANT))
		return
	// 追加可读的检视提示，让检视者（含本人）明确得知此身肉体极不稳定、每日变种。
	examine_list += span_warning("这具躯体透着一股说不出的不稳定感，仿佛它的形态从不属于任何一个种族。【畸变变种】")


// ----------------------------------------------------------------------------
// 登记过程：把【畸变变种】特性写入玩家可见的特性自检表 GLOB.roguetraits。
// 为什么需要：除了"被他人检视可见"（上面的检视回调）之外，本项目还有一张玩家自检面板
//   （GLOB.roguetraits，screen_objects.dm 遍历它打印玩家"已拥有"的每个特性）。把特性登记进去，
//   持有者才能在面板里看到【畸变变种】及其说明，与 hellblood_descendant / martins_morning 一致。
// 为什么用"运行时追加"而非直接改核心 GLOBAL_LIST_INIT(roguetraits)：
//   硬性约束只能改动 modular_z121；核心表 roguetraits 定义在 code/__DEFINES/traits.dm
//   （目录之外，禁止修改）。故在启动钩子里向这张已初始化的全局表追加键值对——这是本项目
//   登记自定义特性的既定做法。
// 为什么定义在本文件、由 custom_bootstrap 按名调用：
//   #define 宏按 #include 顺序生效，custom_bootstrap.dm 的包含顺序早于本文件，无法在那里
//   直接引用 TRAIT_DISTORTION_VARIANT 宏；而 proc 名是全局解析、跨文件可调用。于是把"需要用到
//   本文件宏"的登记逻辑封装在本文件的 proc 内，bootstrap 只按名调用，既遵守宏可见性规则，
//   又复用统一的启动时机（此刻 roguetraits 已完成 GLOBAL_LIST_INIT 初始化，追加是安全的）。
// ----------------------------------------------------------------------------
/proc/register_distortion_variant_trait()
	// 防御：核心全局表必须已初始化为 list 才能写入；异常时安静跳过，绝不新建脱钩的"假表"。
	if(!islist(GLOB.roguetraits))
		return
	// 写入「特性键 -> 玩家自检描述」。第一人称、span_info 样式，与表中其它条目风格一致；
	//   幂等：重复调用只是覆盖同一个键，二次启动也安全。
	GLOB.roguetraits[TRAIT_DISTORTION_VARIANT] = span_info("我曾被施以可怖的实验，肉体因此极不稳定：\
		每天夜晚，我都会在剧烈的疼痛中随机切换成另一个【血肉之躯】的种族（绝不会变成构造体 / 史莱姆 / 亡魂等\
		非血肉种族），换种族时上一个种族赋予的特性与能力会被一并清除。")


// ----------------------------------------------------------------------------
// 清理本文件内部使用的计时宏，避免污染全局编译命名空间。
// 为什么保留 TRAIT_DISTORTION_VARIANT 不 #undef：它是对外可见的"身份标签"，其它系统可能需要
//   用 HAS_TRAIT 查询，这与 modular_z121 内其它特性键（如 TRAIT_MARTINS_MORNING）保持全局可见的约定一致。
// ----------------------------------------------------------------------------
#undef DISTORTION_PAIN_DURATION
