// ============================================================================
// modular_z121/virtues/ancient_creation.dm
// 自定义美德（Custom Virtue）：远古造物 / Ancient Creation
// 种族限制（Restriction）：仅「金属构装体 / Metal Construct」可获取（Metal construction Limited）
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   实现一个全新的被动美德"远古造物"。它消耗 18 点凯旋点数（triumph_cost = 18），
//   授予被动特性【亘古长存 / Ancient existence】，其效果为：
//     - 智力 +1（Intelligence / STATKEY_INT）。
//     - 意志 +1（Will / STATKEY_WIL）。
//     - 识字（Literacy = /datum/skill/misc/reading）技能 +3，最高提升到 6 级。
//     - 工匠系列（Craftsman series = /datum/skill/craft 全部工艺）技能 +3，最高提升到 6 级。
//     - 把工匠系列技能的"等级上限"设为 6 级（传说级 SKILL_LEVEL_LEGENDARY），
//       使持有者日后还能继续通过梦境/训练把它们练到 6 级。
//     - 该特性在游戏内对玩家可见：任何人检视（examine）该角色时，都会在检视文本里
//       看到一行【亘古长存】说明（通过挂载检视组件实现，见文件后半段）。
//
// 关于"金属构造受限"（Metal construction Limited）——这是【种族限制】而非名字：
//   本美德的设定是"一个自远古存活至今、亲历矮人灭绝的个体"，唯有由金属与奥术铸成、
//   能够亘古长存的【金属构装体 /datum/species/construct/metal】才符合这一身份。
//   因此本美德【只能由金属构装体获取】；其它血肉种族无法真正承载这份古老传承。
//
//   引擎层面没有"白名单：仅某族可选"的机制——只有每个种族各自的 restricted_virtues
//   黑名单（在 code/modules/client/vices_menu.dm 与 preferences.dm 中被硬编码读取），
//   而这些都位于 modular_z121 之外、按约束不可修改。所以本美德把种族限制实现在
//   【唯一完全可控的环节】apply_to_human 中：若领取者不是金属构装体，则
//     1) 全额退还已扣除的凯旋点数（避免误选受罚）；
//     2) 不授予任何特性 / 属性 / 技能；
//     3) 给出明确的角色化提示。
//   这样无论选择是如何发生的，最终的机械效果都被严格限制在金属构装体身上。
//
// 为什么所有逻辑都放在本文件内：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外的任何文件。
//   本文件通过"向已有基类 /datum/virtue 派生子类型"的方式接入引擎，仅在 apply_to_human
//   中调用引擎已有的接口（adjust_triumphs / change_stat / adjust_skillrank / ADD_TRAIT），
//   不修改任何核心文件，因此完全满足约束。
//
// 为什么没有外部目标选择（target selection）：
//   本美德是"角色创建时一次性赋予"的纯被动特性，作用对象永远是领取者本人（recipient），
//   不需要玩家手动选取任何外部目标，因此不存在需要取消的目标弹窗。需求中"目标选择需可
//   取消"的条款在此自然满足——全程没有任何会卡住玩家的阻塞式输入框。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承，不修改其源文件）：
//   - /datum/virtue                      美德基类（modular_azurepeak/_virtue.dm）
//   - apply_virtue() 流程                 先 check_triumphs()（扣点），再 apply_to_human()，
//                                         随后依次 handle_traits / handle_skills / handle_stats
//   - /datum/species/construct/metal      金属构装体种族（species_types/.../construct/constructm.dm）
//   - /mob/proc/adjust_triumphs(n, ...)   调整凯旋点数（用于退款）
//   - /mob/proc/change_stat(key, n)       调整属性，内部已做 1~20 钳制
//   - /mob/proc/get_skill_level(skill)    读取当前技能等级（已含上限钳制）
//   - /mob/proc/adjust_skillrank(...)     调整技能等级（直接给经验，不受 cap 限制）
//   - GetSkillRef(path) / subtypesof()    取得技能单例 / 枚举工艺技能子类型
//   - STATKEY_INT / STATKEY_WIL           智力 / 意志属性键（code/__DEFINES/mobs.dm）
//   - SKILL_LEVEL_LEGENDARY (= 6)         传说级，即需求所说的"上限 6"（code/__DEFINES/skills.dm）
//   - TRAIT_*_EXPERT                      解锁各工艺技能等级上限到传说级的特性（traits.dm）
//   - TRAIT_VIRTUE                        美德特性来源标签（统一清理用）
//   - /datum/component                    组件基类（用于挂载"检视可察觉"信号）
//   - COMSIG_PARENT_EXAMINE               检视信号（atom/examine 末尾发出，用于追加检视文本）
//
// 加载：本文件需在 modular_z121/_load.dm 中以 #include 引入（已在该文件追加对应行）。
// ============================================================================


// ----------------------------------------------------------------------------
// 自定义特性键（Trait key）：亘古长存 / Ancient existence
// 为什么要定义：用一个唯一字符串标识"持有远古造物美德"的人，便于本文件（及未来其它
//   系统）通过 HAS_TRAIT 判断身份，也作为 ADD_TRAIT 的来源/特性标签使用。
// 为什么用字符串：引擎的特性系统以字符串为键，与 modular_z121 内既有写法
//   （如 life_potential.dm 的 TRAIT_LIFE_POTENTIAL）保持一致。
// ----------------------------------------------------------------------------
#define TRAIT_ANCIENT_EXISTENCE "ancient_existence"

// 本美德给予的技能加成档数：+3 级。单独定义为常量，便于将来平衡性调整时只改这一处。
#define ANCIENT_CREATION_SKILL_BONUS 3

// 技能可被提升到的最高等级：6 级（= SKILL_LEVEL_LEGENDARY / 传说级）。
// 需求中"up to 6"与"上限设为 6"都对应这一数值，统一引用同一常量避免硬编码魔法数字。
#define ANCIENT_CREATION_SKILL_CAP SKILL_LEVEL_LEGENDARY


// ----------------------------------------------------------------------------
// 美德定义：远古造物
// 为什么归入 /datum/virtue/utility 分支：与 life_potential（生命潜能）、never_ending
//   （永无止境）等"效用型"被动美德保持一致；作为 /datum/virtue 子类型，会被
//   subtypesof() 自动收录进 GLOB.virtues（见 code/__HELPERS/global_lists.dm），无需手动注册。
// ----------------------------------------------------------------------------
/datum/virtue/utility/ancient_creation
	// 菜单中显示的美德名（"金属构造受限"是限制说明，不写进名字本身）。
	name = "远古造物"
	// 角色内描述（in-character）：呼应"自远古存活至今、见证矮人灭绝、知识与技艺历经千年累积"的设定。
	desc = "我是一个自远古便已存在的个体，甚至亲历过矮人一族的灭绝。我的学识横跨数千年的历史，技艺也在漫长的岁月里层层累积。"
	// custom_text 用机制语言把硬性规则讲清楚，避免玩家误解适用种族、加成范围与上限。
	custom_text = "【仅限金属构装体获取】\n\
	获得【亘古长存】特性：\n\
	智力 +1、意志 +1；\n\
	识字技能 +3（最高 6 级）；\n\
	工匠系列全部技能 +3（最高 6 级），并将工匠系列技能的等级上限提升至 6 级（传说级）。"
	// 消耗 18 点凯旋点数。基类 New() 会自动把"Costs 18 TRIUMPH"追加到 desc。
	// check_triumphs() 会在 apply_virtue 流程开头校验并扣除；若领取者非金属构装体，
	//   apply_to_human 会把这笔点数全额退还（见下）。
	triumph_cost = 18
	// 为什么"不"用任何静态通道（added_stats / added_traits / added_skills）：
	//   所有效果都必须先通过"种族限制"判定后才允许授予，而 handle_stats / handle_traits /
	//   handle_skills 都在 apply_to_human 之后无条件执行——若把效果放进静态通道，非构装体
	//   即便被 apply_to_human 拒绝，仍会被这些 handle_* 施加，造成"应被拒却仍获益"。
	//   因此把【全部】效果（属性 / 特性 / 技能）都收拢进 apply_to_human，在种族判定通过后
	//   才逐项手动施加；如此非构装体路径无需回退任何属性，只需退还凯旋点数，逻辑最干净。


// ----------------------------------------------------------------------------
// 工具过程：把某个技能"提升 amount 级、但不超过 cap"。
// 为什么单独抽出：识字与多个工匠技能都要执行相同的"加 N 级、封顶 6"逻辑，
//   抽成一个过程避免重复代码，也便于统一做错误处理与玩家反馈。
// 为什么不直接 adjust_skillrank(+3)：那样可能把已接近上限的技能推过 6 级之外的语义；
//   这里先读当前等级，计算"真正应当增加的级数"，再调用，确保最终恰好落在 cap 上。
// ----------------------------------------------------------------------------
/datum/virtue/utility/ancient_creation/proc/grant_skill_capped(mob/living/carbon/human/recipient, skill_path, amount, cap)
	// 防御：没有有效人物或没有 mind（技能存储依附于 mind）时，直接放弃本次授予，避免空引用。
	if(!istype(recipient) || !recipient.mind)
		return
	// 防御：技能路径必须有效，否则 GetSkillRef 取不到单例，后续会出错。
	if(!skill_path)
		return

	// 取得该技能单例（用于读取名字做反馈）；GetSkillRef 失败时安静返回，避免崩溃。
	var/datum/skill/the_skill = GetSkillRef(skill_path)
	if(!the_skill)
		return

	// 读取当前等级（get_skill_level 已对返回值做了 1~6 钳制，安全）。
	var/current_level = recipient.get_skill_level(skill_path)

	// 已经达到（或超过）上限：无需再加，给出与基类 handle_skills 一致风格的提示后返回。
	if(current_level >= cap)
		to_chat(recipient, span_notice("我对[LOWER_TEXT(the_skill.name)]的造诣早已登峰造极，这份古老的传承无法再为它锦上添花。"))
		return

	// 计算"真正应加的级数"：默认加 amount 级；若会越过 cap，则收窄到恰好顶到 cap 为止。
	//   例如当前 4 级、amount=3、cap=6 时，increase_by 会被收窄为 2，最终停在 6 级。
	var/increase_by = amount
	if((current_level + amount) > cap)
		increase_by = cap - current_level

	// 真正提升技能等级。第三个参数 silent=TRUE：批量授予时抑制单条升级刷屏。
	recipient.adjust_skillrank(skill_path, increase_by, TRUE)


// ----------------------------------------------------------------------------
// 工具过程：种族不符时退还已扣除的凯旋点数。
// 为什么需要：apply_virtue 的调用顺序是 check_triumphs()（已扣点）→ apply_to_human()。
//   当 apply_to_human 判定种族不符而提前返回时，凯旋点数已被扣除，这里全额退还，
//   避免玩家因误选而白白损失 18 点。由于本美德所有效果都在 apply_to_human 内"判定通过后"
//   才手动施加（不走任何静态通道），因此除了退点之外，没有任何属性 / 特性 / 技能需要回退。
// ----------------------------------------------------------------------------
/datum/virtue/utility/ancient_creation/proc/revoke_wrong_species(mob/living/carbon/human/recipient)
	// 退还已扣除的凯旋点数（仅当确有成本时；adjust_triumphs 的第二参 FALSE = 不弹提示音/特效）。
	if(triumph_cost && istype(recipient))
		recipient.adjust_triumphs(triumph_cost, FALSE)


// ----------------------------------------------------------------------------
// apply_to_human：美德被赋予人物时调用（早于 handle_traits / handle_stats）。
// 流程：
//   0) 种族限制：非【金属构装体】→ 退款 + 提示，随即返回，绝不授予任何能力。
//   1) 授予身份特性【亘古长存】，并授予工匠系列的"上限解锁特性"集合（把 cap 提升到 6）。
//   2) 手动施加属性：智力 +1、意志 +1。
//   3) 提升识字（Literacy）技能 +3、封顶 6。
//   4) 枚举工匠系列（全部 /datum/skill/craft）技能，逐一 +3、封顶 6。
// ----------------------------------------------------------------------------
/datum/virtue/utility/ancient_creation/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// 防御性检查：没有有效人物（极端时序下可能为 null）就直接返回，避免后续空引用。
	if(!istype(recipient))
		return

	// ---- 0) 种族限制：仅金属构装体可获取 ----
	// 为什么用 istype 判定 /datum/species/construct/metal：这正是引擎中的"金属构装体"种族
	//   （见 species_types/roguetown/construct/constructm.dm）。istype 同时兼容其未来可能出现的
	//   子种族。判定失败 = 非金属构装体 → 优雅降级：退还点数、提示，绝不授予任何能力。
	if(!istype(recipient.dna?.species, /datum/species/construct/metal))
		revoke_wrong_species(recipient)
		to_chat(recipient, span_warning("这份亘古的传承属于以金属与奥术铸成、能跨越千年长存的造物——\
										而你血肉的躯壳无法承载它。这份力量没有在你身上觉醒。"))
		// 直接返回：既不打标签、不加属性、也不加技能；已扣的凯旋点数已在 revoke_wrong_species 里退还。
		return

	// ---- 1) 授予特性 ----
	// 授予"身份标签"【亘古长存】，来源标记 TRAIT_VIRTUE（与引擎美德特性约定一致，便于统一清理）。
	ADD_TRAIT(recipient, TRAIT_ANCIENT_EXISTENCE, TRAIT_VIRTUE)
	// 挂载"检视可察觉"组件：让【亘古长存】特性在游戏内对玩家可见——任何人检视该角色时，
	//   都会在检视文本里看到一行说明（含本人检视自己）。组件做了 UNIQUE 去重，重复挂载无碍。
	//   为什么用组件而非直接 RegisterSignal：美德 datum 是 GLOB.virtues 的"模板单例"，
	//   不能用它的 src 注册到 recipient 上；组件实例与 recipient 一一绑定，能正确管理信号
	//   注册并在宿主消失时自动反注册，避免悬空回调（与 succubus_bloodline 的做法一致）。
	recipient.AddComponent(/datum/component/ancient_existence)
	// 授予"工匠系列上限解锁特性"集合：引擎用这些 *_EXPERT 特性把对应工艺技能的等级上限
	//   解锁到传说级（6）（见 code/datums/skills/craft.dm 各技能的 trait_uncap）。集齐它们，
	//   即可把【全部】工匠系列技能的上限统一提升到 6 级，实现需求"工匠系列等级上限设为 6"。
	//   覆盖关系：
	//     TRAIT_SMITHING_EXPERT → 武器/护甲锻造、铁匠、冶炼、工程、石工、陶艺
	//     TRAIT_HOMESTEAD_EXPERT → 烹饪、石工、陶艺
	//     TRAIT_SEWING_EXPERT    → 缝纫、皮革工艺
	//     TRAIT_SURVIVAL_EXPERT  → 烹饪、皮革工艺
	//     TRAIT_ALCHEMY_EXPERT   → 炼金术
	//   （通用制造 / 木工默认上限本就是 6，无需特性解锁。）
	var/static/list/craft_uncap_traits = list(
		TRAIT_SMITHING_EXPERT,
		TRAIT_HOMESTEAD_EXPERT,
		TRAIT_SEWING_EXPERT,
		TRAIT_SURVIVAL_EXPERT,
		TRAIT_ALCHEMY_EXPERT,
	)
	for(var/uncap_trait in craft_uncap_traits)
		ADD_TRAIT(recipient, uncap_trait, TRAIT_VIRTUE)

	// ---- 2) 手动施加属性：智力 +1、意志 +1 ----
	// 为什么手动调用 change_stat 而非走 added_stats：见美德定义处说明——确保属性只在种族判定
	//   通过后才施加。change_stat 内部已对结果做 1~20 钳制，无需我们手写边界处理。
	recipient.change_stat(STATKEY_INT, 1)   // 智力 +1
	recipient.change_stat(STATKEY_WIL, 1)   // 意志 +1

	// 没有 mind 时技能系统无处依附（adjust_skillrank 依赖 mind/skill_holder）；
	//   此时特性与属性已生效，但技能部分无法施加，故提示并提前结束。
	if(!recipient.mind)
		to_chat(recipient, span_warning("我感到亘古的智慧在体内苏醒，但此刻的躯壳还无法承载那千年累积的技艺。"))
		return

	// ---- 3) 识字（Literacy）技能 +3、封顶 6 ----
	grant_skill_capped(recipient, /datum/skill/misc/reading, ANCIENT_CREATION_SKILL_BONUS, ANCIENT_CREATION_SKILL_CAP)

	// ---- 4) 工匠系列（全部 /datum/skill/craft）技能 +3、封顶 6 ----
	// 为什么动态枚举而非硬编码列表：直接遍历 /datum/skill/craft 的全部子类型，逐一加成。
	//   subtypesof() 不含抽象基类自身，因此返回的都是具体工艺技能。将来核心新增工艺技能时，
	//   本美德会自动覆盖，无需在此维护一份易过期的清单。
	for(var/craft_path in subtypesof(/datum/skill/craft))
		grant_skill_capped(recipient, craft_path, ANCIENT_CREATION_SKILL_BONUS, ANCIENT_CREATION_SKILL_CAP)

	// 给出醒目的整体反馈，让玩家清楚"远古造物"已经生效，否则纯被动加成对玩家不可见。
	to_chat(recipient, span_nicegreen("千年的记忆与技艺自金属的核心深处奔涌而出——我的心智更为敏锐，万般造物之术皆如本能。"))


// ----------------------------------------------------------------------------
// 检视组件：亘古长存（仅负责"让特性在游戏内对玩家可见"）
// 为什么用组件：组件与宿主 mob 绑定，提供 Initialize / UnregisterFromParent 生命周期，
//   能干净地注册 / 反注册检视信号，并在宿主死亡或被删除时自动清理，避免悬空回调。
//   这与 succubus_bloodline.dm 中"血脉可被检视察觉"的实现保持一致。
// ----------------------------------------------------------------------------
/datum/component/ancient_existence
	// 唯一组件：同一 mob 上只允许一个实例，重复 AddComponent 会被丢弃，杜绝重复监听 / 重复刷文本。
	dupe_mode = COMPONENT_DUPE_UNIQUE

// Initialize：组件创建时做类型校验并注册检视信号。
/datum/component/ancient_existence/Initialize()
	. = ..()
	// 检视提示与人物语境绑定，挂到非人类上无意义，返回 COMPONENT_INCOMPATIBLE 让引擎丢弃本组件。
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	// 注册 COMSIG_PARENT_EXAMINE：引擎在 atom/examine() 末尾发出该信号，携带
	//   (检视者 user, 检视文本列表)。据此向检视文本追加一行【亘古长存】说明。
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

// UnregisterFromParent：组件与宿主解绑时撤销注册，避免悬空信号回调。
/datum/component/ancient_existence/UnregisterFromParent()
	if(parent)
		UnregisterSignal(parent, COMSIG_PARENT_EXAMINE)
	return ..()

// on_examine：检视回调，向检视文本追加一行"亘古长存"提示，使特性在游戏内可见。
// 为什么标 SIGNAL_HANDLER：检视信号同步触发，回调内只拼接文本、不可 sleep。
// 为什么以 HAS_TRAIT 为条件而非无条件追加：万一特性已被其它系统移除（如美德被清除），
//   提示也应随之消失，保证"看到提示 = 确实拥有特性"严格一致。
/datum/component/ancient_existence/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	// 防御：宿主异常或已不再持有特性，则不追加任何文本。
	if(!ishuman(parent))
		return
	if(!HAS_TRAIT(parent, TRAIT_ANCIENT_EXISTENCE))
		return
	// 追加可读的检视提示，让检视者（含本人）明确得知此身拥有【亘古长存】。
	examine_list += span_notice("此身散发着亘古而苍老的气息——仿佛一件历经千年、亲历矮人灭绝的远古造物。【亘古长存】")


// ----------------------------------------------------------------------------
// 登记过程：把【亘古长存】特性写入玩家可见的特性自检表 GLOB.roguetraits。
// 为什么需要：除了"被他人检视可见"（上面的检视组件）之外，本项目还有一张玩家自检面板
//   （GLOB.roguetraits）——玩家点开后能看到自己所有特性的第一人称说明。把特性登记进去，
//   才能让持有者在面板里看到【亘古长存】及其效果说明，与 life_potential 的做法保持一致。
// 为什么定义在本文件：TRAIT_ANCIENT_EXISTENCE 宏在本文件内定义且未被 #undef，登记逻辑写在
//   这里才能引用到该宏（遵守宏的 #include 可见性规则）；实际调用点在 custom_bootstrap 的
//   Initialize 中（那时核心 roguetraits 表已由 GLOBAL_LIST_INIT 完成初始化，追加是安全的）。
// ----------------------------------------------------------------------------
/proc/register_ancient_existence_trait()
	// 防御：核心全局表必须已初始化为 list 才能写入；异常情况下安静跳过，绝不新建一张
	//   会与核心表脱钩的"假表"，以免登记到一个永远不会被面板读取的列表上。
	if(!islist(GLOB.roguetraits))
		return
	// 写入「特性键 -> 玩家自检描述」。描述用第一人称、span_info 样式，与表中其它条目风格一致。
	//   幂等：重复调用只是覆盖同一个键，不会产生重复项，二次启动也安全。
	GLOB.roguetraits[TRAIT_ANCIENT_EXISTENCE] = span_info("我是一件自远古便已存在的造物，\
		甚至亲历过矮人一族的灭绝。漫长的岁月让我心智敏锐（智力、意志各 +1），\
		识字与工匠系列技艺也远超常人（识字、工匠系列技能各 +3，上限可达 6 级）。")


// ----------------------------------------------------------------------------
// 清理本文件内部使用的数值宏，避免污染全局编译命名空间。
// 为什么保留 TRAIT_ANCIENT_EXISTENCE 不 #undef：它是对外可见的"身份标签"，其它系统
//   可能需要用 HAS_TRAIT 查询，这与 modular_z121 内其它特性键（如 TRAIT_LIFE_POTENTIAL）
//   保持全局可见的约定一致。
// ----------------------------------------------------------------------------
#undef ANCIENT_CREATION_SKILL_BONUS
#undef ANCIENT_CREATION_SKILL_CAP
