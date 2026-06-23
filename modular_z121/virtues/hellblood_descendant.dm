// ============================================================================
// modular_z121/virtues/hellblood_descendant.dm
// 自定义美德（Custom Virtue）：地狱血脉后裔 / Hell Bloody Descendants
// 种族限制（Restriction）：仅「提夫林 / Tiefling」可获取（Tiflin race restrictions）
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   实现一个全新的被动美德"地狱血脉后裔"。它消耗 19 点凯旋点数（triumph_cost = 19），
//   授予被动特性【地狱血脉 / Hell Bloodline】，其效果为：
//     - 对火焰伤害免疫（immune to flame damage）：既不会被点燃、也不受高温环境伤害，
//       并且任何来源的灼烧（BURN）伤害都被拦截归零。
//     - 习得火焰系法术（obtain flame series spells）：火球术 / 强效火球术 / 吐焰火球 / 生成营火。
//     - 该特性在游戏内对玩家可见（Make the added trait visible to players）：
//         1) 任何人检视（examine）该角色时，会在检视文本里看到一行【地狱血脉】说明（检视组件）；
//         2) 持有者点开自己的特性自检面板时，也能看到【地狱血脉】及其说明（登记进 GLOB.roguetraits）。
//
// 关于"仅提夫林可获取"——这是【种族限制】而非名字的一部分：
//   设定上，只有体内真正流淌着地狱恶魔之血的【提夫林 /datum/species/tieberian】才能觉醒这份血脉。
//   引擎层面没有"白名单：仅某族可选"机制（各族的 restricted_virtues 黑名单位于 modular_z121
//   之外、按约束不可修改）。因此把种族限制实现在【唯一完全可控的环节】apply_to_human 中：
//   若领取者不是提夫林，则 1) 全额退还已扣的凯旋点数；2) 不授予任何特性/法术；3) 给出角色化提示。
//   这样无论选择如何发生，最终的机械效果都被严格限制在提夫林身上。
//
// 为什么所有逻辑都放在本文件内：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外的任何文件。
//   本文件通过"派生 /datum/virtue 子类型"与"向已有类型追加 proc 覆写/组件"接入引擎——
//   这属于"追加"而非"修改核心文件"，符合约束。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承 / 覆写，不改其源文件）：
//   - /datum/virtue                        美德基类（modular_azurepeak/_virtue.dm）；
//                                           apply_virtue() 流程：先 check_triumphs() 扣点，再 apply_to_human()。
//   - /datum/species/tieberian             提夫林种族（species_types/.../other/tiefling.dm，name="Tiefling"）。
//   - /mob/proc/adjust_triumphs(n, FALSE)  调整凯旋点数（用于种族不符时退款）。
//   - /mob/living/carbon/human/adjustFireLoss  灼烧伤害入口（damage_procs.dm，本文件按种族覆写以实现免疫）。
//   - TRAIT_NOFIRE / TRAIT_RESISTHEAT      不可燃 / 抗高温特性（traits.dm；阻止点燃与高温环境伤害）。
//   - /datum/mind/proc/AddSpell / has_spell  习得 / 查询法术（mind.dm）。
//   - 火焰系法术类型（code/modules/spells/spell_types/wizard/...）：fireball / fireball/greater / spitfire / create_campfire。
//   - /datum/component + COMSIG_PARENT_EXAMINE  检视组件，让特性"被他人检视可见"。
//   - GLOB.roguetraits                     玩家特性自检面板的全局表（traits.dm；让特性"被本人面板可见"）。
//   - TRAIT_VIRTUE                         美德授予特性时的统一来源标签（便于统一清理）。
//
// 加载与注册（均在 modular_z121 内完成）：
//   - modular_z121/_load.dm                以 #include 引入本文件。
//   - modular_z121/bootstrap/custom_bootstrap.dm  在其 Initialize 中调用 register_hellblood_descendant_trait()。
// ============================================================================


// ----------------------------------------------------------------------------
// 自定义特性键（Trait key）：地狱血脉 / Hell Bloodline
// 为什么定义：用一个唯一字符串标识"持有地狱血脉后裔美德"的人，供 HAS_TRAIT 判断身份、
//   火焰免疫的覆写守门、检视显示、面板登记等共同使用。
// 为什么特性值直接用可读中文名"地狱血脉"（而非英文 slug）：引擎的玩家特性自检面板
//   （screen_objects.dm 第 133~135 行）会把"特性字符串本身"当作标题打印（[X] - 说明）。
//   用可读中文做值，玩家点开面板即可看到体面的特性名"地狱血脉"。该串已确认全项目未占用，
//   不会与现有特性造成 HAS_TRAIT 歧义。
// ----------------------------------------------------------------------------
#define TRAIT_HELLBLOOD_DESCENDANT "地狱血脉"


// ----------------------------------------------------------------------------
// 美德定义：地狱血脉后裔
// 为什么归入 /datum/virtue/utility 分支：与 ancient_creation（远古造物）、life_potential
//   （生命潜能）等"效用型"被动美德保持一致；作为 /datum/virtue 子类型，会被 subtypesof()
//   自动收录进 GLOB.virtues（见 code/__HELPERS/global_lists.dm），无需手动注册。
// ----------------------------------------------------------------------------
/datum/virtue/utility/hellblood_descendant
	// 菜单中显示的美德名（"仅限提夫林"是限制说明，不写进名字本身）。
	name = "地狱血脉后裔"
	// 角色内描述（in-character）：呼应"先祖乃地狱恶魔，血脉在你身上尤为彰显"的设定基调。
	desc = "我的先祖乃是来自地狱的恶魔，这份血脉在我身上尤为彰显——烈焰无法灼伤我分毫，\
			地狱之火更是听命于我的召唤。"
	// custom_text 用机制语言把硬性规则讲清楚：适用种族、代价、以及两项核心效果。
	custom_text = "【仅限提夫林（Tiefling）获取】\n\
	消耗 29 点凯旋点数。获得【地狱血脉】特性：\n\
	· 火焰免疫：不会被点燃，免疫一切灼烧（BURN）与高温环境伤害；\n\
	· 火焰系法术：习得 火球术、强效火球术、吐焰火球、生成营火。"
	// 消耗 29 点凯旋点数。基类 New() 会自动把"Costs 29 TRIUMPH"追加进 desc。
	//   check_triumphs() 会在 apply_virtue 流程开头校验并扣除；若领取者非提夫林，
	//   apply_to_human 会把这笔点数全额退还（见下）。
	triumph_cost = 29
	// 为什么"不"用任何静态通道（added_traits / added_skills / added_stats）：
	//   所有效果都必须先通过"种族限制"判定后才允许授予，而 handle_traits / handle_skills /
	//   handle_stats 都在 apply_to_human 之后无条件执行——若把效果放进静态通道，非提夫林
	//   即便被 apply_to_human 拒绝，仍会被这些 handle_* 施加，造成"应被拒却仍获益"。
	//   因此把【全部】效果（特性 / 法术）都收拢进 apply_to_human，在种族判定通过后才施加；
	//   如此非提夫林路径无需回退任何东西，只需退还凯旋点数，逻辑最干净。


// ----------------------------------------------------------------------------
// 工具过程：本美德要授予的"火焰系法术"类型列表。
// 为什么单独成过程返回 static 列表：法术类型路径固定不变，用 static 只构建一次省开销；
//   集中成一处便于将来增删火焰系法术，避免类型清单散落各处。
// 选用的四个法术均为引擎已有的火焰主题法术（code/modules/spells/spell_types/wizard/...）：
//   - 火球术 fireball                       基础单体/小范围火球（projectiles_aoe/fireball.dm）
//   - 强效火球术 fireball/greater           更强的火球（projectiles_aoe/greater_fireball.dm）
//   - 吐焰火球 spitfire                      喷吐火焰弹（projectiles_single/spitfire.dm）
//   - 生成营火 create_campfire              召唤营火（utility/create_campfire.dm），凑齐"火焰系"主题
// ----------------------------------------------------------------------------
/datum/virtue/utility/hellblood_descendant/proc/get_flame_spells()
	// static：列表只在首次调用时创建，后续复用同一份，避免每次施法重复分配内存。
	var/static/list/flame_spells = list(
		/obj/effect/proc_holder/spell/invoked/projectile/fireball,          // 火球术
		/obj/effect/proc_holder/spell/invoked/projectile/fireball/greater,  // 强效火球术
		/obj/effect/proc_holder/spell/invoked/projectile/spitfire,          // 吐焰火球
		/obj/effect/proc_holder/spell/invoked/create_campfire,              // 生成营火
	)
	return flame_spells


// ----------------------------------------------------------------------------
// 工具过程：种族不符时退还已扣除的凯旋点数。
// 为什么需要：apply_virtue 的调用顺序是 check_triumphs()（已扣点）→ apply_to_human()。
//   当 apply_to_human 判定种族不符而提前返回时，凯旋点数已被扣除，这里全额退还，
//   避免玩家因误选而白白损失 19 点。由于本美德所有效果都在 apply_to_human 内"判定通过后"
//   才施加（不走任何静态通道），因此除退点外没有任何特性/法术需要回退。
// ----------------------------------------------------------------------------
/datum/virtue/utility/hellblood_descendant/proc/revoke_wrong_species(mob/living/carbon/human/recipient)
	// 仅当确有成本且收件人有效时退款；adjust_triumphs 第二参 FALSE = 不弹提示音/特效。
	if(triumph_cost && istype(recipient))
		recipient.adjust_triumphs(triumph_cost, FALSE)


// ----------------------------------------------------------------------------
// 工具过程：安全地为收件人授予单个法术（含完整错误处理）。
// 为什么单独抽出：四个火焰法术都要执行相同的"判空 + 去重 + 双路径授予"逻辑，抽成一处
//   避免重复代码，也便于统一做错误处理与失败反馈。
// 为什么用双路径授予（mind.AddSpell 与 mob.AddSpell）：法术既可存放在 /datum/mind 上
//   （随灵魂转移），也可直接挂在 mob 上（mob_spell_list）；有 mind 时优先存 mind（更持久），
//   无 mind 时退而求其次挂在 mob 上。该写法与 modular_z121/admin/grandcaster.dm 完全一致。
// 返回：成功授予返回 TRUE，已拥有/失败返回 FALSE（供调用方统计与反馈）。
// ----------------------------------------------------------------------------
/datum/virtue/utility/hellblood_descendant/proc/grant_flame_spell(mob/living/carbon/human/recipient, spell_path)
	// 防御：收件人无效或法术路径为空，直接判定失败，避免空引用 / new 出错。
	if(!istype(recipient) || !spell_path)
		return FALSE

	// 去重：若已通过 mind 或 mob 拥有同类法术，则不重复授予（重复挂载会出现两个施法按钮）。
	//   先查 mind（has_spell 接受类型路径），再查 mob_spell_list（按 istype 匹配）。
	if(recipient.mind?.has_spell(spell_path))
		return FALSE
	for(var/obj/effect/proc_holder/spell/existing as anything in recipient.mob_spell_list)
		if(istype(existing, spell_path))
			return FALSE

	// 实例化法术对象。new spell_path 失败（路径异常）时 new_spell 为 null，下面会拦截。
	var/obj/effect/proc_holder/spell/new_spell = new spell_path
	// 防御：极端情况下实例化失败，安静放弃本次授予，绝不把 null 塞进法术列表。
	if(!new_spell)
		return FALSE

	// 双路径授予：有 mind 存 mind（AddSpell 内部会接好施法动作 action.Grant），否则挂在 mob 上。
	if(recipient.mind)
		recipient.mind.AddSpell(new_spell, recipient)
	else
		recipient.AddSpell(new_spell)
	return TRUE


// ----------------------------------------------------------------------------
// apply_to_human：美德被赋予人物时调用（早于 handle_traits / handle_skills / handle_stats）。
// 流程：
//   0) 种族限制：非【提夫林】→ 退款 + 提示，随即返回，绝不授予任何能力。
//   1) 授予身份特性【地狱血脉】，并附带 TRAIT_NOFIRE（不可燃）+ TRAIT_RESISTHEAT（抗高温），
//      配合下方 adjustFireLoss 覆写，实现完整的"火焰免疫"。
//   2) 挂载检视组件，让特性"被他人检视可见"。
//   3) 逐一授予火焰系法术（带错误处理与汇总反馈）。
// ----------------------------------------------------------------------------
/datum/virtue/utility/hellblood_descendant/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// 防御：没有有效人物（极端时序下可能为 null）就直接返回，避免后续空引用。
	if(!istype(recipient))
		return

	// ---- 0) 种族限制：仅提夫林可获取 ----
	// 为什么用 istype 判定 /datum/species/tieberian：这正是引擎中的"提夫林"种族
	//   （见 species_types/.../other/tiefling.dm，name = "Tiefling"）。istype 同时兼容其未来
	//   可能出现的子种族。判定失败 = 非提夫林 → 优雅降级：退款、提示，绝不授予任何能力。
	if(!istype(recipient.dna?.species, /datum/species/tieberian))
		revoke_wrong_species(recipient)
		to_chat(recipient, span_warning("这份炽烈的地狱血脉只在提夫林的躯体中流淌——\
										你体内并无恶魔的血，这份力量没有在你身上觉醒。"))
		// 直接返回：既不打标签、也不授法术；已扣的凯旋点数已在 revoke_wrong_species 里退还。
		return

	// ---- 1) 授予特性（身份 + 火焰免疫所需的两项引擎特性）----
	// 身份标签【地狱血脉】，来源统一用 TRAIT_VIRTUE（与引擎美德特性约定一致，便于统一清理）。
	//   它同时充当下方 adjustFireLoss 覆写与检视组件的"守门条件"。
	ADD_TRAIT(recipient, TRAIT_HELLBLOOD_DESCENDANT, TRAIT_VIRTUE)
	// TRAIT_NOFIRE（不可燃）：阻止角色被点燃（ignite() 会因此特性直接失败），从源头杜绝着火。
	ADD_TRAIT(recipient, TRAIT_NOFIRE, TRAIT_VIRTUE)
	// TRAIT_RESISTHEAT（抗高温）：阻止"着火持续伤害"与"高温环境（>正常体温上限）伤害"
	//   （见 species.dm 的 handle_environment：两处都以 !HAS_TRAIT(H, TRAIT_RESISTHEAT) 为前提）。
	ADD_TRAIT(recipient, TRAIT_RESISTHEAT, TRAIT_VIRTUE)

	// ---- 2) 挂载检视组件，让【地狱血脉】被他人检视可见 ----
	// 为什么用组件而非直接 RegisterSignal：美德 datum 是 GLOB.virtues 的"模板单例"，不能用它的
	//   src 注册到 recipient 上；组件实例与 recipient 一一绑定，能正确管理信号注册并在宿主
	//   消失时自动反注册，避免悬空回调（与 ancient_creation / succubus_bloodline 的做法一致）。
	recipient.AddComponent(/datum/component/hellblood_descendant)

	// ---- 3) 授予火焰系法术 ----
	// 没有 mind 时法术只能临时挂在 mob 上（grant_flame_spell 内部已处理双路径），仍尽力授予；
	//   这里统计成功数量，便于给出"是否真正学到法术"的诚实反馈，而非笼统报喜。
	var/granted_count = 0                                   // 实际新授予的法术数量。
	for(var/spell_path in get_flame_spells())              // 遍历四个火焰系法术 ……
		if(grant_flame_spell(recipient, spell_path))      // …… 逐一尝试授予（含去重/错误处理）……
			granted_count++                               // …… 成功则计数 +1。

	// 给出醒目的整体反馈，让玩家清楚"地狱血脉"已生效，否则纯被动特性对玩家不可见。
	if(granted_count > 0)                                  // 至少学到一个新法术 ……
		to_chat(recipient, span_nicegreen("地狱的血脉在体内沸腾——烈焰再也无法伤我，\
											而地狱之火已听命于我的召唤。"))
	else                                                   // 一个都没新授予（通常是早已全部拥有）……
		// 如实提示：火焰免疫已生效，但火焰系法术此前已掌握，没有新增。避免谎报"学会了新法术"。
		to_chat(recipient, span_nicegreen("地狱的血脉在体内沸腾——烈焰再也无法伤我；\
											而那些地狱之火，我本就早已驾驭。"))


// ----------------------------------------------------------------------------
// 火焰免疫核心：覆写 /mob/living/carbon/human/adjustFireLoss
// 为什么覆写这个过程：adjustFireLoss 是引擎施加"灼烧（BURN / fireloss）"伤害的统一入口
//   （damage_procs.dm；apply_damage 的 BURN 分支、火球弹、着火持续伤害等最终都汇聚到它）。
//   在此按种族特性拦截"正向灼烧伤害"，即可实现需求"对火焰伤害免疫"——比逐一堵住每个伤害源
//   更彻底、更不易遗漏。
// 为什么定义在 /mob/living/carbon/human（而非 /mob/living）：基类 adjustFireLoss 定义在
//   /mob/living 上；在更具体的 human 子类型新增同名覆写属于"派生覆写"，不与基类定义冲突，
//   且本美德只授予人类角色，作用域恰好覆盖。这是"追加"而非修改核心文件，符合约束。
// 为什么只拦"正向且非强制"的伤害：
//   - amount > 0 才是"造成灼烧"；amount <= 0 是治疗/扣减灼烧，必须放行，否则连灭火回血都被挡。
//   - !forced 放行强制路径：管理员/特殊机制用 forced=TRUE 时应当生效，免疫不应越权拦截。
// ----------------------------------------------------------------------------
/mob/living/carbon/human/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE)
	// 仅当：本体拥有【地狱血脉】、本次是正向灼烧、且非强制时，拦截并归零本次火焰伤害。
	if(amount > 0 && !forced && HAS_TRAIT(src, TRAIT_HELLBLOOD_DESCENDANT))
		// 返回 FALSE 表示"未实际造成伤害"，与基类"无变化时返回 FALSE"的语义保持一致，
		//   也让调用方据此跳过后续的疼痛/着火表现，避免出现"挨打却毫发无伤"的逻辑矛盾。
		return FALSE
	// 其余情况（治疗、强制、或非地狱血脉者）一律交回基类按原逻辑处理，绝不改变既有行为。
	return ..()


// ----------------------------------------------------------------------------
// 检视组件：地狱血脉（仅负责"让特性在游戏内被他人检视可见"）
// 为什么用组件：组件与宿主 mob 绑定，提供 Initialize / UnregisterFromParent 生命周期，
//   能干净地注册 / 反注册检视信号，并在宿主死亡或被删除时自动清理，避免悬空回调。
//   这与 ancient_creation.dm / succubus_bloodline.dm 中"特性可被检视察觉"的实现保持一致。
// ----------------------------------------------------------------------------
/datum/component/hellblood_descendant
	// 唯一组件：同一 mob 上只允许一个实例，重复 AddComponent 会被丢弃，杜绝重复监听/重复刷文本。
	dupe_mode = COMPONENT_DUPE_UNIQUE

// Initialize：组件创建时做类型校验并注册检视信号。
/datum/component/hellblood_descendant/Initialize()
	. = ..()
	// 检视提示与人物语境绑定，挂到非人类上无意义，返回 COMPONENT_INCOMPATIBLE 让引擎丢弃本组件。
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	// 注册 COMSIG_PARENT_EXAMINE：引擎在 atom/examine() 末尾发出该信号，携带
	//   (检视者 user, 检视文本列表)。据此向检视文本追加一行【地狱血脉】说明。
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

// UnregisterFromParent：组件与宿主解绑时撤销注册，避免悬空信号回调。
/datum/component/hellblood_descendant/UnregisterFromParent()
	if(parent)
		UnregisterSignal(parent, COMSIG_PARENT_EXAMINE)
	return ..()

// on_examine：检视回调，向检视文本追加一行"地狱血脉"提示，使特性在游戏内可见。
// 为什么标 SIGNAL_HANDLER：检视信号同步触发，回调内只拼接文本、不可 sleep。
// 为什么以 HAS_TRAIT 为条件而非无条件追加：万一特性已被其它系统移除（如美德被清除），
//   提示也应随之消失，保证"看到提示 = 确实拥有特性"严格一致。
/datum/component/hellblood_descendant/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	// 防御：宿主异常或已不再持有特性，则不追加任何文本。
	if(!ishuman(parent))
		return
	if(!HAS_TRAIT(parent, TRAIT_HELLBLOOD_DESCENDANT))
		return
	// 追加可读的检视提示，让检视者（含本人）明确得知此身流淌着地狱恶魔的血脉。
	examine_list += span_warning("此身散发着灼热而不祥的地狱气息——恶魔的血脉在其体内沸腾。【地狱血脉】")


// ----------------------------------------------------------------------------
// 登记过程：把【地狱血脉】特性写入玩家可见的特性自检表 GLOB.roguetraits。
// 为什么需要：除了"被他人检视可见"（上面的检视组件）之外，本项目还有一张玩家自检面板
//   （GLOB.roguetraits，screen_objects.dm 遍历它打印玩家"已拥有"的每个特性）。把特性登记进去，
//   才能让持有者在面板里看到【地狱血脉】及其效果说明，与 ancient_creation / life_potential 一致。
// 为什么用"运行时追加"而非直接改核心 GLOBAL_LIST_INIT(roguetraits)：
//   硬性约束只能改动 modular_z121；核心表 roguetraits 定义在 code/__DEFINES/traits.dm
//   （目录之外，禁止修改）。故在启动钩子里向这张已初始化的全局表追加键值对——这正是本项目
//   登记自定义特性的既定做法（参见 register_ancient_existence_trait / register_succubus_bloodline_trait）。
// 为什么定义在本文件、由 custom_bootstrap 按名调用：
//   #define 宏按 #include 顺序生效，custom_bootstrap.dm 的包含顺序早于本文件，无法在那里
//   直接引用 TRAIT_HELLBLOOD_DESCENDANT 宏；而 proc 名是全局解析、跨文件可调用。于是把"需要
//   用到本文件宏"的登记逻辑封装在本文件的 proc 内，bootstrap 只按名调用，既遵守宏可见性规则，
//   又复用统一的启动时机（此刻 roguetraits 已完成 GLOBAL_LIST_INIT 初始化，追加是安全的）。
// ----------------------------------------------------------------------------
/proc/register_hellblood_descendant_trait()
	// 防御：核心全局表必须已初始化为 list 才能写入；异常时安静跳过，绝不新建一张会与核心表
	//   脱钩的"假表"，以免登记到一个永远不会被面板读取的列表上。
	if(!islist(GLOB.roguetraits))
		return
	// 写入「特性键 -> 玩家自检描述」。描述用第一人称、span_info 样式，与表中其它条目风格一致。
	//   幂等：重复调用只是覆盖同一个键，不会产生重复项，二次启动也安全。
	GLOB.roguetraits[TRAIT_HELLBLOOD_DESCENDANT] = span_info("我的先祖乃是来自地狱的恶魔，\
		这份血脉在我身上尤为彰显：烈焰无法灼伤我分毫（免疫一切火焰/灼烧/高温伤害，亦不会被点燃），\
		而地狱之火听命于我的召唤（习得火球术、强效火球术、吐焰火球、生成营火）。")
