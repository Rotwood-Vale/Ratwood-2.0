// ============================================================================
// modular_z121/virtues/wine_sword_immortal.dm
// 自定义美德（Custom Virtue）：酒剑仙 / Wine Sword Immortal
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   实现一个全新的美德"酒剑仙"。角色当年远赴东方习得一套绝世剑法，但唯有饮酒之后
//   方能施展。需求拆解：
//     · 名称：Wine Sword Immortal / 酒剑仙
//     · 消耗：6 点凯旋点数（triumph_cost = 6）
//     · 获得特性：酒剑仙（Wine Sword Immortal）
//     · 特性效果一：免疫醉酒（drunkenness）带来的一切负面减益
//       （正常情况下醉酒会施加智力-2 减益、口齿不清、神志不清、眩晕、毒性伤害乃至
//         强制昏睡——酒剑仙对这些"惩罚"完全免疫）。
//     · 特性效果二：一旦饮酒上头（达到"醉态"阈值），其剑术技能立即被强化到【传奇】等级
//       （SKILL_LEVEL_LEGENDARY）——这正是"醉后方能施展的东方剑法"。
//     · 该特性必须能被玩家在游戏内看到（登记进 GLOB.roguetraits 自检面板）。
//
// 为什么所有逻辑都放在本文件内：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外的任何文件。
//   本文件通过"向已有核心类型追加子类型过程重写（override）"的方式接入引擎，不修改任何
//   核心文件本身——这与本目录既有做法完全一致（参见 genius.dm 重写 adjust_experience、
//   hellblood_descendant.dm 重写 adjustFireLoss）。追加 override 属于"追加子类型过程"，
//   并非"编辑核心文件"，因此满足约束。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承 / 重写，绝不修改其源文件）：
//   - /datum/virtue/combat                          美德战斗系分类父级（modular_azurepeak/virtues/combat.dm）
//   - /mob/living/carbon/handle_status_effects()     醉酒一切减益的唯一汇聚处理点（life.dm:260）
//   - /mob/proc/get_skill_level(skill)               一切技能等级读取的唯一汇聚入口（skill_holder.dm:11）；
//                                                    战斗格挡/闪避均经此读取武器 associated_skill（parry.dm:54）
//   - /datum/skill/combat/swords                     剑术技能（skills/combat.dm:21）
//   - SKILL_LEVEL_LEGENDARY                          传奇技能等级常量 = 6（__DEFINES/skills.dm:9）
//   - mob.drunkenness                                醉酒度数值（carbon 变量，life.dm 内被读写）
//   - /datum/stressevent/drunk                       饮酒正向心情事件（positive_events.dm:56，stressadd=-2）
//   - GLOB.roguetraits                               玩家"特性自检面板"读取的全局特性说明表
//   - ADD_TRAIT / HAS_TRAIT / TRAIT_VIRTUE           特性增删与"美德来源"标签
//
// 加载：本文件需在 modular_z121/_load.dm 中以 #include 引入（已在该文件追加）；
//       特性的玩家可见登记由 bootstrap/custom_bootstrap.dm 调用 register_wine_sword_immortal_trait() 完成。
// ============================================================================


// ----------------------------------------------------------------------------
// 自定义特性键（Trait key）：酒剑仙
// 为什么要定义：用一个唯一字符串标识"持有酒剑仙"的人，便于本文件（及未来其它系统）
//   通过 HAS_TRAIT 判断身份，也作为 ADD_TRAIT 的来源标签使用。
// 为什么用"酒剑仙"这个中文串作为特性值（而非英文 slug）：
//   引擎的玩家特性自检面板（screen_objects.dm:133）会直接把"特性字符串本身"当作标题
//   打印给玩家（参见 genius.dm 对该机制的说明，以及 TRAIT_NOPAIN 的值"无痛"）。
//   因此把特性值写成可读的中文名"酒剑仙"，玩家点开特性列表才能看到体面的名字。
//   经确认该串在本项目中唯一，不会与其它特性造成 HAS_TRAIT 歧义。
// ----------------------------------------------------------------------------
#define TRAIT_WINE_SWORD_IMMORTAL "酒剑仙"

// 醉态阈值：醉酒度达到此值即视为"已上头/已醉"。
// 为什么取 3：引擎在 handle_status_effects() 里正是以 drunkenness >= 3 作为"开始显露醉态、
//   施加醉酒减益（apply_status_effect(/datum/status_effect/buff/drunk)）"的门槛（life.dm:330）。
//   沿用同一阈值，使"剑术强化生效的时机"与"原本会被施加减益的时机"严格对齐——即"上头那一刻，
//   减益本该降临，但酒剑仙非但免疫，反而剑术登峰造极"。单列为常量，便于将来平衡性调整。
//   仅本文件内部使用，文件末尾会 #undef 掉，避免污染全局编译命名空间。
#define WINE_SWORD_DRUNK_THRESHOLD 3


// ----------------------------------------------------------------------------
// 美德定义：酒剑仙
// 为什么归入 /datum/virtue/combat 分支：本美德是纯战斗向（强化剑术），与该目录下
//   duelist（决斗者）、executioner（行刑者）等战斗系美德保持同类。作为 /datum/virtue 的
//   子类型，会被 subtypesof() 自动收录进 GLOB.virtues（见 code/__HELPERS/global_lists.dm），
//   无需任何手动注册。
// ----------------------------------------------------------------------------
/datum/virtue/combat/wine_sword_immortal
	// 菜单中显示的美德名。
	name = "Wine Sword Immortal"
	// 角色内描述（in-character）：呼应"远赴东方习得绝世剑法、唯醉方能施展"的设定。
	desc = "你曾远赴东方，习得一套盖世无双的剑法，却唯有在饮酒之后才能将它尽情施展。"
	// custom_text 用机制语言把硬性规则讲清楚，避免玩家误解触发条件。
	// 为什么单列：desc 偏角色口吻，这里写明两条具体机制——免疫醉酒减益 + 醉后剑术达传奇。
	custom_text = "获得【酒剑仙】特性：\n\
	· 你对醉酒带来的一切负面影响（智力下降、口齿不清、神志不清、眩晕、毒性、昏睡等）完全免疫；\n\
	· 一旦你饮酒上头，体内的东方剑法便会觉醒——你的【剑术】技能会被瞬间提升到【传奇】等级，\n\
	  直到酒意散尽为止。"
	// 消耗 6 点凯旋点数。基类 New() 会自动把"Costs 6 TRIUMPH"追加到 desc；
	// apply_virtue 流程开头的 check_triumphs() 会校验并扣除，点数不足则整条美德不会被授予。
	triumph_cost = 6
	// 为什么"不"用基类的 added_traits 通道授予 TRAIT_WINE_SWORD_IMMORTAL：
	//   apply_virtue 的调用顺序是 apply_to_human() 先于 handle_traits()。把授予逻辑统一收拢到
	//   apply_to_human 里手动 ADD_TRAIT，可让"打标签"与"给出玩家反馈"在同一处完成、时序清晰，
	//   也方便未来若要追加资格校验时就地拦截。added_traits 保持基类默认空 list() 即可。

// apply_to_human：美德被赋予人物时调用。负责授予【酒剑仙】特性并给出醒目反馈。
// 注：本美德没有种族/年龄等准入限制（任何角色皆可习得这套东方剑法），因此这里不做退款拦截；
//     但仍保留对无效目标的防御性检查，避免极端时序下的空引用。
/datum/virtue/combat/wine_sword_immortal/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// 防御性检查：没有有效人物（极端时序下 recipient 可能为 null 或非人类）就直接返回，
	//   避免后续 ADD_TRAIT / to_chat 对空对象操作而运行时报错。
	if(!istype(recipient))
		return

	// 授予"身份标签"，来源标记 TRAIT_VIRTUE（与引擎美德特性约定一致，便于将来统一清理）。
	// 下方两个核心过程重写（get_skill_level / handle_status_effects）都以 HAS_TRAIT 该标签为开关，
	//   因此打上标签后，免疫与剑术强化两项效果即自动随"是否处于醉态"动态生效，无需额外挂载组件。
	ADD_TRAIT(recipient, TRAIT_WINE_SWORD_IMMORTAL, TRAIT_VIRTUE)

	// 给出醒目反馈：纯被动效果对玩家不直观，明确告知"酒剑仙已觉醒、饮酒即可施展剑法"。
	to_chat(recipient, span_nicegreen("一缕东方剑意自你识海深处苏醒——往后只需一壶烈酒入喉，\
									这身盖世剑法便会随醉意倾泻而出。"))


// ----------------------------------------------------------------------------
// 效果二：醉后剑术达【传奇】——重写人类的技能等级读取入口
// 为什么选择重写 /mob/living/carbon/human/get_skill_level(skill)：
//   引擎中"一切技能等级的读取"都唯一汇聚到 /mob/proc/get_skill_level(skill)
//   （skill_holder.dm:11）。战斗格挡/闪避正是经由它读取手中武器的 associated_skill 等级
//   （parry.dm:54 `H.get_skill_level(mainhand.associated_skill) * 20`），而剑类武器的
//   associated_skill 即 /datum/skill/combat/swords（swords.dm:173）。因此只要在这唯一入口
//   对"剑术"的返回值动手脚，就能让"醉后剑术达传奇"在格挡、突破对方格挡、闪避加成等所有用到
//   剑术等级的地方一次性、自动地全面生效，而无需逐个战斗子系统改动。
// 为什么重写在 /mob/living/carbon/human 这一层：本美德只授予人类玩家；在 human 子类型上重写，
//   既精准命中目标群体，又不干扰非人类 mob 的技能逻辑。属"追加子类型 override"，不改核心文件本身。
// ----------------------------------------------------------------------------
/mob/living/carbon/human/get_skill_level(skill)
	// 仅当：①确实持有【酒剑仙】特性；②已饮酒上头（醉酒度达到醉态阈值）时，才考虑强化。
	//   为什么要求达到阈值：设定是"唯有饮酒之后才能施展"，清醒时这身剑法处于封印状态，
	//   读到的应是角色真实剑术等级（透传给 ..()）。
	if(HAS_TRAIT(src, TRAIT_WINE_SWORD_IMMORTAL) && drunkenness >= WINE_SWORD_DRUNK_THRESHOLD)
		// get_skill_level 的入参 skill 可能是"类型路径"（绝大多数调用，如 parry.dm 传
		//   /datum/skill/combat/swords），也可能是"技能实例"。这里两种都兼容地归一成可比较的
		//   类型路径 skill_type，避免因入参形态不同而漏判；无法识别时保持 null，安全落到下方透传分支。
		//   （刻意用显式 if 分支而非内联三元，避免 `?:` 的冒号与 DM 成员访问符冲突导致歧义。）
		var/skill_type = null
		if(ispath(skill))
			// 入参本身就是类型路径：直接用作比较对象。
			skill_type = skill
		else if(istype(skill, /datum/skill))
			// 入参是技能实例：取其 .type 得到对应类型路径（用强类型临时变量做安全的成员访问）。
			var/datum/skill/passed_skill = skill
			skill_type = passed_skill.type
		// 只对"剑术"这一项技能生效；其余技能一律不受影响，照常透传给 ..() 读取真实等级。
		if(skill_type == /datum/skill/combat/swords)
			// 直接返回传奇等级（6）。这是"醉后剑法觉醒"的核心表现：醉态期间剑术恒为传奇。
			return SKILL_LEVEL_LEGENDARY

	// 不满足强化条件（未持特性 / 未醉 / 非剑术）：原样透传给基类，返回角色的真实技能等级，
	//   确保除"醉后剑术"外的一切技能读取行为保持不变。
	return ..()


// ----------------------------------------------------------------------------
// 效果一：免疫醉酒带来的一切减益——重写人类的状态效果处理入口
// 为什么选择重写 /mob/living/carbon/human/handle_status_effects()：
//   引擎中"醉酒的全部后果"都集中在 /mob/living/carbon/handle_status_effects() 的
//   `if(drunkenness) ... ` 区块里一次性结算（life.dm:328-379）：包括施加醉酒状态减益
//   （/datum/status_effect/buff/drunk → 智力-2）、口齿不清(slurring)、神志不清(confused)、
//   眩晕(Dizzy)、毒性伤害(adjustToxLoss)、呕吐(vomit)、视野模糊(blur_eyes)乃至强制昏睡(Sleeping)。
//   这是醉酒减益的"唯一汇聚结算点"。
// 实现思路（为什么用"临时清零 + 调用父级 + 还原"而非逐项反向清理）：
//   我的记忆里反复强调——引擎不给减益标注来源，事后逐项反向清理（如清掉 slurring/confused/dizzy）
//   会误伤其它来源造成的同名状态，既脆弱又不精确。更干净的做法是"治本"：在调用父过程之前，
//   先把 drunkenness 临时清零，使父过程里整段 `if(drunkenness)` 醉酒结算分支根本不会执行
//   （从而一个醉酒减益都不会被施加）；父过程返回后，再把 drunkenness 还原，并补上父过程因被
//   跳过而漏掉的那一行"自然消退"衰减（life.dm:329），保证酒意仍会随时间正常散去。
//   这样做只精准抑制了"醉酒分支"，对其它一切状态（眩晕、嗜睡、抖动等非醉酒来源）毫无影响，
//   也不会重复结算，符合"精确而非一刀切"的原则。
// 为什么仍保留正向心情：需求是"免疫醉酒的【减益】"，而饮酒带来的"心情愉悦"
//   （/datum/stressevent/drunk，stressadd=-2 即心情提升）属于正向恩惠，理应保留——
//   酒剑仙是"只享其利、不受其害"，故还原后手动补回这条正向心情事件。
// ----------------------------------------------------------------------------
/mob/living/carbon/human/handle_status_effects()
	// 仅当：①持有【酒剑仙】特性；②已醉到会触发减益的阈值时，才介入抑制。
	//   阈值以下醉酒分支本就不施加任何减益（仅做衰减），无需介入，直接走默认父过程即可，
	//   既减少不必要的干预、也让低度微醺时的衰减仍由引擎原生处理。
	if(HAS_TRAIT(src, TRAIT_WINE_SWORD_IMMORTAL) && drunkenness >= WINE_SWORD_DRUNK_THRESHOLD)
		// 记下真实醉酒度，稍后还原——这样体外其它读取 drunkenness 的逻辑（如本文件的剑术强化判定）
		//   依旧能看到真实数值，"醉态"对剑术强化的驱动不受影响。
		var/saved_drunkenness = drunkenness
		// 关键一步：临时清零，使父过程里 `if(drunkenness)` 整段醉酒减益结算被完整跳过，
		//   从根上做到"一个醉酒减益都不施加"。
		drunkenness = 0
		// 照常执行父过程，处理除醉酒之外的所有状态效果（眩晕/嗜睡/抖动/口吃等），行为不变。
		. = ..()
		// 还原醉酒度，并补回父过程因被跳过而漏掉的"自然消退"衰减（与 life.dm:329 完全一致的公式），
		//   确保酒意会随时间正常散去，酒剑仙不会因免疫而"永远醉着、剑术永久传奇"。
		drunkenness = max(saved_drunkenness - (saved_drunkenness * 0.04) - 0.01, 0)
		// 保留饮酒的正向恩惠：达到醉态时补回"饮酒愉悦"心情事件；低于阈值（酒意散尽）则移除，
		//   与引擎原生在该处的心情增删逻辑（life.dm:330-337）保持一致，避免心情状态残留。
		if(drunkenness >= WINE_SWORD_DRUNK_THRESHOLD)
			add_stress(/datum/stressevent/drunk)
		else
			remove_stress(/datum/stressevent/drunk)
		// 已自行完成本 tick 的状态处理，返回父过程结果，结束。
		return .

	// 未持特性 / 未达醉态：不做任何干预，原样交由默认父过程处理，保证非酒剑仙行为完全不变。
	return ..()


// ----------------------------------------------------------------------------
// 让玩家在游戏内"看得见"这项特性：登记进 GLOB.roguetraits
// ----------------------------------------------------------------------------
// 为什么要登记：引擎的玩家特性自检面板（screen_objects.dm:133-135）会遍历 GLOB.roguetraits，
//   对玩家"拥有的"每一个特性，打印「特性名 - 描述」。只有把 TRAIT_WINE_SWORD_IMMORTAL 加进
//   这张全局表，玩家点开自己的特性列表时才会看到"酒剑仙"及其说明；否则特性虽已通过 ADD_TRAIT
//   生效，却对玩家不可见，不满足需求"该特性应能被玩家在游戏内看到"。
//
// 为什么用"运行时追加"而不是直接写进核心的 roguetraits 定义：
//   硬性约束要求只能改动 modular_z121。核心表 roguetraits 定义在 code/__DEFINES/traits.dm
//   （本目录之外，禁止修改）。因此改为在启动钩子里向这张已初始化的全局表追加一个键值对——
//   这正是本项目登记自定义特性的既定做法（参见 genius.dm / life_potential.dm 等同款
//   register_*_trait 过程，统一由 bootstrap/custom_bootstrap.dm 调用）。
//
// 为什么做成独立 proc 由 custom_bootstrap 调用：
//   #define 宏按 #include 顺序生效；custom_bootstrap.dm 的包含顺序早于本文件，那里无法直接
//   引用 TRAIT_WINE_SWORD_IMMORTAL 宏。而 proc 名是全局解析的、跨文件可调用。于是把"需要用到
//   本文件宏"的登记逻辑封装进本文件的 proc，bootstrap 只按名调用，既遵守宏的可见性规则，
//   又复用了统一的启动时机（此刻 roguetraits 已完成 GLOBAL_LIST_INIT 初始化）。
/proc/register_wine_sword_immortal_trait()
	// 防御：核心全局表必须已初始化为 list 才能写入；异常情况下安静跳过，绝不新建一张会与
	//   核心表脱钩的"假表"，以免登记到一个永远不会被面板读取的列表上。
	if(!islist(GLOB.roguetraits))
		return
	// 写入「特性键 -> 玩家自检描述」。描述用第一人称、span_info 样式，与表中其它条目
	//   （如 TRAIT_NOPAIN = span_info("我感觉不到痛楚。")）的风格保持一致。
	//   幂等：重复调用只是覆盖同一个键，不会产生重复项，二次启动也安全。
	GLOB.roguetraits[TRAIT_WINE_SWORD_IMMORTAL] = span_info("我是酒剑仙：醉酒从不能伤我分毫，\
		反而能唤醒我那身东方剑法——只要饮酒上头，我的剑术便登峰造极、臻至传奇。")


// ----------------------------------------------------------------------------
// 清理本文件内部使用的数值宏，避免污染全局编译命名空间。
// 为什么保留 TRAIT_WINE_SWORD_IMMORTAL 不 #undef：它是对外可见的"身份标签"，其它系统可能需要
//   用 HAS_TRAIT 查询，这与 modular_z121 内其它特性键（如 TRAIT_GENIUS）保持全局可见的约定一致。
// ----------------------------------------------------------------------------
#undef WINE_SWORD_DRUNK_THRESHOLD
