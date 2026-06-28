// ============================================================================
// modular_z121/virtues/rpg_system.dm
// 自定义美德（Custom Virtue）：RPG 系统 / RPG System
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   实现一个全新的美德"RPG 系统"。设定上：你是一名"世界旅人"，带着只属于旅人的
//   作弊外挂降临此世——在你眼里，这个世界不过是一款无比真实的 RPG 游戏。
//   该美德会为持有者打开一个专属的"系统面板"：
//     · 击杀怪物可以赚取【系统积分】；
//     · 积分可以在系统商店里兑换各种 物品 / 装备 / 武器 / 消耗品；
//     · 甚至可以用积分直接强化技能（提升技能等级）与属性（提升六维 / 幸运）。
//
//   需求拆解：
//     · 名称：RPG System / RPG 系统
//     · 消耗：99 点凯旋点数（triumph_cost = 99）
//     · 赋予一个"独一无二的系统界面"（玩家可主动呼出的动词 / 菜单）
//     · 击杀怪物 → 获得积分
//     · 积分 → 兑换 物品 / 装备 / 武器 / 消耗品
//     · 积分 → 强化技能、强化属性
//
// 为什么所有逻辑都放在本文件内：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外的任何
//   文件。本文件通过"向已有类型追加子类型 / 组件 / 动词（verb）"的方式接入引擎，不修改
//   任何核心文件，因此完全满足约束。
//   （向核心类型 /mob/living/carbon/human 追加一个 proc/verb，以及向核心类型追加组件，
//     都属于"追加子类型内容"而非"编辑核心文件"——这与本目录既有做法一致，例如
//     life_potential.dm 向核心类型挂组件、genius.dm 追加 proc 重写。）
//
// 为什么用"组件 + 动词"而不是"在美德 datum 单例上直接做"：
//   GLOB.virtues 里的美德 datum 是所有玩家共享的"模板单例"，不能把"某个人的积分 / 信号
//   监听"挂到它身上（会串号）。组件实例与具体的 recipient 一一绑定，能正确地存储这名玩家
//   的积分、注册 / 反注册信号，并在宿主消失时自动清理，是承载"每名玩家独立系统数据"的正解。
//
// 击杀归属（kill attribution）如何判定：
//   引擎里每个 mob 被攻击时都会写入 lastattacker_weakref（见 species.dm 近战 / 远程攻击、
//   simple_animal/animal_defense.dm 等处），它弱引用"最后一个攻击者"。当怪物死亡时，
//   /mob/living/death() 会发出 COMSIG_LIVING_DEATH 信号（death.dm:128）。因此：
//     · 我们给"系统持有者附近的怪物"挂一个一次性的"击杀监听组件"，监听其 COMSIG_LIVING_DEATH；
//     · 怪物一死，就解析它的 lastattacker_weakref，若凶手是持有【RPG 系统】特性的人类，
//       就给那名凶手发放积分。
//   这样无论玩家用近战 / 远程 / 法术哪种方式击杀，归属都准确（都依赖统一的 lastattacker）。
//
// 为什么用"轮询附近怪物并挂监听组件"而不是"重写怪物的 death()"：
//   核心在 /mob/living/death() 之外的多个子类型（hostile/death、rogue/death……）都重写了
//   death()。在 modular 文件里重定义某个已被定义的 death() 路径，会让 ..() 落到父级、跳过
//   核心同名重写的本体（掉落物 / 清理逻辑），破坏所有该类怪物——风险极大且影响全局（连非本
//   美德玩家杀的怪也受影响）。改为"信号 + 组件"则零侵入：不替换任何行为，只是旁听死亡事件。
//   而要给怪物挂上监听，又没有"全局怪物死亡信号"可用，故由持有者的驱动组件每个处理周期扫描
//   自己视野内的敌对怪物，给它们补挂一次性监听组件（组件 UNIQUE 去重，重复扫描不会叠加）。
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承，不修改其源文件）：
//   - /datum/virtue                          美德基类（modular_azurepeak/_virtue.dm）
//   - /datum/component                       组件基类（承载每名玩家的系统数据与信号）
//   - COMSIG_LIVING_DEATH                     生命体死亡信号（code/__DEFINES/components.dm:327）
//   - lastattacker_weakref                    被攻击者记录的"最后攻击者"弱引用（living_defines.dm:12）
//   - SSprocessing / START_PROCESSING / process(delta_time)  处理子系统（周期性扫描视野）
//   - /mob/proc/adjust_triumphs(n, FALSE)     调整凯旋点数（年龄/种族等不符时退款；本美德无门槛）
//   - /mob/living/proc/change_stat(key, amt)  调整属性（内部自带 1~20 越界保护）
//   - /mob/living/proc/get_stat(stat)         读取当前属性值（用于"满级不再扣费"判断）
//   - /mob/proc/get_skill_level(skill)        读取当前技能等级（用于"满级不再扣费"判断）
//   - /mob/proc/adjust_skillrank(skill, amt)  提升技能等级（内部按经验上限封顶到传奇）
//   - /mob/proc/put_in_hands(I)               把兑换出的物品塞进手里（失败则留在脚下地块）
//   - GLOB.roguetraits                        玩家"特性自检面板"读取的全局特性说明表
//   - ADD_TRAIT / HAS_TRAIT / TRAIT_VIRTUE    特性增删与美德来源标签
//
// 加载：本文件需在 modular_z121/_load.dm 中以 #include 引入（已在该文件追加）；
//       特性的玩家可见登记由 bootstrap/custom_bootstrap.dm 调用 register_rpg_system_trait() 完成。
// ============================================================================


// ----------------------------------------------------------------------------
// 自定义特性键（Trait key）：RPG 系统
// 为什么要定义：用一个唯一字符串标识"持有 RPG 系统"的人，便于本文件（击杀监听组件、
//   动词）通过 HAS_TRAIT 判断身份，也作为 ADD_TRAIT 的来源标签使用。
// 为什么用"RPG系统"这个可读串作为特性值（而非英文 slug）：
//   引擎的玩家"特性自检面板"会直接把"特性字符串本身"当作标题显示给玩家（参见
//   life_potential.dm / genius.dm 对该机制的说明，以及 TRAIT_NOPAIN 的值"无痛"）。
//   写成可读名"RPG系统"，玩家点开特性列表时就能看到一个体面的标题。该串在本项目中唯一。
// ----------------------------------------------------------------------------
#define TRAIT_RPG_SYSTEM "RPG系统"

// 本美德的凯旋点数消耗：99 点。需求明确为"消耗 99 点"。
// 单列为常量，便于将来平衡性调整只改这一处。
#define RPG_SYSTEM_TRIUMPH_COST 99

// 击杀监听组件每"巡检"一次的范围（以持有者为中心的视野格数）。
// 为什么是 9：略大于默认视野（7），确保玩家屏幕内（含边缘）正在交战的怪物都能被及时挂上监听。
#define RPG_SYSTEM_SCAN_RANGE 9

// 击杀积分的换算：默认为怪物最大生命值 maxHealth 的 20%，越强的怪给得越多。
// 为什么按 maxHealth：simple_animal 系怪物普遍带 maxHealth，且它与"怪物强度"高度相关，
//   是最稳妥、对所有怪物都可用的强度近似指标（无需为每种怪单独配表）。
// 为什么是 0.2（20%）：需求明确"击杀获得的积分 = 怪物最大生命值的 20%"。例如 100 血的怪给 20 分，
//   200 血的怪给 40 分。单列为常量，平衡只改这一处。
// 注：部分"类人怪物"（NPC，属 /mob/living/carbon/human 子类型）不走这个比例，而是按
//   get_fixed_kill_rewards() 里登记的"固定积分"给分（见下方击杀监听组件）。
#define RPG_SYSTEM_POINTS_PER_MAXHP 0.2
// 单次击杀的保底积分：纯粹用于兜底——防止极低血量怪物经 round() 后算出 0 分（"杀了像没收益"）。
//   故仅设为 1（最低限度的非零保证），不破坏"积分=10% 最大生命值"的基本设定。
#define RPG_SYSTEM_MIN_KILL_POINTS 1

// 强化属性的"基础单价系数"（积分）。实际花费 = 基础系数 × 当前属性值。
// 为什么按当前值线性递增：需求要求"属性越高，强化所需积分越多"——属性越接近上限越珍贵，
//   单价随当前值水涨船高，能自然形成"前期易、后期贵"的成长曲线。
// 为什么进一步上调到 60：配合"击杀积分降为 10% 最大生命值"（收入减半），属性强化要更显珍贵，
//   故拉高系数（系数 60 时：10→11 需 600，15→16 需 900，19→20 需 1200）。单列为常量，平衡只改这一处。
#define RPG_SYSTEM_STAT_COST_BASE 60
// 强化技能的"基础单价系数"（积分）。实际花费 = 基础系数 ×（目标等级）=（当前等级+1）。
// 为什么按目标等级递增：同理，技能越高升级越贵——越往传奇越珍贵。
// 为什么进一步上调到 180：同上，收入减半后技能强化也要更珍贵，故拉高系数（系数 180 时：
//   0→1 需 180，2→3 需 540，5→6 需 1080）。单列为常量，平衡只改这一处。
#define RPG_SYSTEM_SKILL_COST_BASE 180

// 兑换"正向特性 / 天赋"的统一单价（积分）。需求："只收录正向增益特性，价格统一 2000。"
#define RPG_SYSTEM_TRAIT_COST 2000
// 通过本系统购买特性时使用的 ADD_TRAIT 来源标签：统一、可识别，便于将来需要时统一清理；
//   不复用 TRAIT_VIRTUE / TRAIT_GENERIC 等其它来源，避免与别处授予的同名特性互相干扰。
#define RPG_SYSTEM_TRAIT_SOURCE "rpg_system_purchase"


// ----------------------------------------------------------------------------
// 美德定义：RPG 系统
// 为什么归入 /datum/virtue/utility 分支：与 life_potential / genius 等"效用型"美德一致；
//   作为 /datum/virtue 子类型，会被 subtypesof() 自动收录进 GLOB.virtues
//   （见 code/__HELPERS/global_lists.dm），无需手动注册。
// ----------------------------------------------------------------------------
/datum/virtue/utility/rpg_system
	// 菜单中显示的美德名。
	name = "RPG系统"
	// 角色内描述（in-character）：呼应"世界旅人 + 作弊外挂 + 此世即超真实 RPG"的设定。
	desc = "你是来自异界的旅人，持有只属于世界旅人的作弊外挂。对你而言，这个世界不过是一款无比真实的 RPG 游戏。"
	// custom_text 用机制语言把硬性规则讲清楚，避免玩家误解。
	// 为什么单列：desc 偏角色口吻，这里写明"系统面板、击杀得分、积分商店、强化技能 / 属性"。
	custom_text = "获得【RPG系统】特性：\n\
	你会获得一个独一无二的【系统面板】（在指令栏的 IC 分类下呼出「打开RPG系统」）。\n\
	击杀怪物可赚取【系统积分】，积分可在系统商店中兑换 武器 / 装备 / 消耗品 / 材料 / 魔法物品，\n\
	也可直接用于强化你的技能等级与六维属性。"
	// 消耗 99 点凯旋点数。基类 New() 会自动把"Costs 99 TRIUMPH"追加到 desc。
	// check_triumphs() 会在 apply_virtue 流程开头校验并扣除，点数不足则不授予。
	triumph_cost = RPG_SYSTEM_TRIUMPH_COST
	// 为什么"不"用 added_traits 授予 TRAIT_RPG_SYSTEM：
	//   apply_virtue 的调用顺序是 apply_to_human() 先于 handle_traits()。若走 added_traits，
	//   即便我们在 apply_to_human 里因"宿主无效"等原因想中止授予，紧随其后的 handle_traits()
	//   仍会把标签无条件加回，导致"有标签却没有挂上系统组件 / 动词"的不一致。
	//   因此改为在 apply_to_human 校验通过后，手动 ADD_TRAIT，使"标签 = 系统真正就绪"严格一致。

// apply_to_human：美德被赋予人物时调用。负责：校验宿主 → 授予特性 → 挂系统组件 → 授予呼出动词。
/datum/virtue/utility/rpg_system/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// 防御性检查：没有有效人物（极端时序下可能为 null）就直接返回，避免空引用。
	//   本美德无种族 / 年龄 / 性别门槛，所以这里不退款（点数本就该为"获得系统"而花）；
	//   仅在"连个有效人类宿主都没有"的异常情况下安静中止。
	if(!istype(recipient))
		return

	// 通过校验：手动授予"身份标签"，来源标记 TRAIT_VIRTUE（与引擎美德特性约定一致，便于统一清理）。
	//   击杀监听组件正是靠 HAS_TRAIT(killer, TRAIT_RPG_SYSTEM) 来判断"这名凶手是否系统持有者"。
	ADD_TRAIT(recipient, TRAIT_RPG_SYSTEM, TRAIT_VIRTUE)

	// 挂载驱动组件：它承载这名玩家的积分、并周期性给附近怪物补挂"击杀监听"。
	//   组件 UNIQUE 去重，重复赋予不会叠加。AddComponent 返回实例，便于后续即时反馈。
	recipient.AddComponent(/datum/component/rpg_system)

	// 授予"呼出系统面板"的动词。为什么用 verbs +=：这是本项目授予主动能力的既定做法
	//   （参见 modular_azurepeak/virtues/combat.dm）。动词面向 /mob/living/carbon/human，
	//   只有持有者会拥有它；动词内部还会再次校验特性，双保险。
	recipient.verbs += /mob/living/carbon/human/proc/open_rpg_system

	// 给出醒目反馈，让玩家立刻知道"系统已绑定、如何呼出"，否则纯被动机制对玩家不直观。
	to_chat(recipient, span_nicegreen("【系统提示】绑定成功。欢迎来到这个世界，旅人。\
		击杀怪物可赚取系统积分；在指令栏 IC 分类下选择「打开RPG系统」即可呼出你的专属面板。"))


// ============================================================================
// 驱动组件：RPG 系统（挂在持有者身上）
// 为什么用组件：组件天然与宿主 mob 绑定，提供 Initialize / Destroy 生命周期钩子，能干净地
//   持有"这名玩家的积分"、启动 / 停止周期处理，并在宿主消失时自动清理，避免悬空状态。
// ============================================================================
/datum/component/rpg_system
	// 唯一组件：同一 mob 上只允许一个实例，重复 AddComponent 会被丢弃，杜绝重复扫描 / 双份积分。
	dupe_mode = COMPONENT_DUPE_UNIQUE
	// 这名玩家当前的系统积分。所有发放（击杀）与扣除（兑换）都读写此字段，是玩家独立的存档位。
	var/points = 0
	// 系统面板（HTML 浏览器窗口）当前选中的分类页签。
	// 为什么存在组件上：HTML 界面是"无状态重绘"的——每次点击经 Topic() 处理后都整窗重绘，
	//   需要一个持久字段记住"玩家正看哪一页"，才能在重绘时渲染正确的分类。默认进"武器"页。
	//   取值："weapon" / "equipment" / "consumable" / "material" / "magic" / "stat" / "skill"。
	var/current_tab = "weapon"

// Initialize：组件创建时调用，负责类型校验与启动周期扫描。
/datum/component/rpg_system/Initialize()
	. = ..()
	// 系统面板与积分商店面向人类玩家；挂到非人类身上没有意义，返回 INCOMPATIBLE 让引擎丢弃。
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	// 启动周期处理：之后每个处理周期都会调用 process()，由它扫描视野内怪物并补挂击杀监听。
	//   为什么用 SSprocessing：它是通用的低频处理子系统，适合这种"周期性轻量巡检"的需求。
	START_PROCESSING(SSprocessing, src)

// Destroy：组件被销毁（宿主死亡删除 / 被移除）时调用，停止周期处理，避免悬空回调。
//   特性标签来源是 TRAIT_VIRTUE，其生命周期由美德系统管理，这里不重复处理以免冲突。
/datum/component/rpg_system/Destroy(force, silent)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

// process：每个处理周期执行一次，扫描宿主视野内"算作怪物"的目标，给它们补挂一次性击杀监听组件。
//   两类目标会被盯上：
//     1) 敌对 simple_animal（/mob/living/simple_animal/hostile）——本游戏的"怪物"主体，按生命值比例给分；
//     2) 固定积分名单里的"类人怪物"（NPC，属 /mob/living/carbon/human 子类型）——按固定积分给分。
//   普通牲畜 / 其他玩家不在两类之内，不会被挂监听、也就不会错误给分。
/datum/component/rpg_system/process(delta_time)
	// 防御：宿主异常（已删除 / 非人类）直接返回，等待 Destroy 收尾。
	if(!ishuman(parent))
		return
	var/mob/living/carbon/human/host = parent
	// 死亡或离线的持有者不再巡检：尸体 / 空壳不会去打怪，省去无谓扫描。
	if(host.stat == DEAD || !host.client)
		return
	// 遍历以宿主为中心、RPG_SYSTEM_SCAN_RANGE 格内的所有活体。给"算作怪物"的目标补挂监听
	//   （UNIQUE 去重：已挂过的会被自动丢弃，不会叠加 / 重复给分）。
	for(var/mob/living/target in range(RPG_SYSTEM_SCAN_RANGE, host))
		// 跳过自己与已死目标：自己不该被监听；尸体没有"击杀"价值。
		if(target == host || target.stat == DEAD)
			continue
		// 判定是否"算作怪物"：① 可给分的 simple_animal（非友善生物）；或 ② 固定积分名单上的类人怪物。
		//   为什么 ② 先用 ishuman 短路再查固定名单：固定名单里全是 /mob/living/carbon/human 子类型，
		//   非人类目标不可能命中，先 ishuman 过滤可省去对一大堆生物逐一跑名单匹配的开销。
		var/is_monster = is_rewardable_beast(target)
		if(!is_monster && ishuman(target) && get_fixed_reward(target) > 0)
			is_monster = TRUE
		if(is_monster)
			target.AddComponent(/datum/component/rpg_kill_watcher)

// ----------------------------------------------------------------------------
// 固定积分名单：特定"类人怪物"（NPC）按这里登记的固定分值给分，不走 maxHealth 比例。
// 为什么要单列：这些 NPC 都是 /mob/living/carbon/human 子类型，没有 simple_animal 的 maxHealth
//   强度语义，且设计上希望按"怪物种类"给固定奖励（例如疯骑士固定 200、流浪汉固定 30），
//   故用一张"类型路径 => 固定积分"的表来配置。
// 安全性：表里登记的都是 npc 目录下的 NPC 专用 mob 子类型，玩家角色是基类 /mob/living/carbon/human
//   （种族经 DNA 设定，并非这些子类型实例），因此 istype 匹配绝不会命中真实玩家，杜绝"杀玩家给分"。
// ----------------------------------------------------------------------------
/datum/component/rpg_system/proc/get_fixed_kill_rewards()
	// 静态缓存：表内容恒定，首次构建后复用，避免每次调用都重建列表。
	var/static/list/rewards
	if(!rewards)
		rewards = list(
			/mob/living/carbon/human/species/human/northern/highwayman = 80,                 // 拦路强盗
			/mob/living/carbon/human/species/human/northern/militia = 50,                     // 民兵
			/mob/living/carbon/human/species/human/northern/bog_deserters = 40,               // 沼泽逃兵
			/mob/living/carbon/human/species/human/northern/bum = 30,                         // 流浪汉
			/mob/living/carbon/human/species/human/northern/searaider = 80,                   // 海上劫掠者
			/mob/living/carbon/human/species/human/northern/thief = 60,                       // 窃贼
			/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter = 200, // 疯魔寻宝者
			/mob/living/carbon/human/species/human/northern/deranged_knight = 200,            // 癫狂骑士
			/mob/living/carbon/human/species/skeleton = 30,                                   // 骷髅（基础）
			/mob/living/carbon/human/species/skeleton/npc/bogguard = 40,                      // 沼泽骷髅卫
			/mob/living/carbon/human/species/skeleton/npc/summoned = 30,                      // 召唤骷髅
			/mob/living/carbon/human/species/dwarfskeleton = 30,                              // 矮人骷髅
			/mob/living/carbon/human/species/npc/deadite = 50,                                // 亡者
			/mob/living/carbon/human/species/elf/dark/drowraider = 120,                       // 卓尔劫掠者
			/mob/living/carbon/human/species/orc = 120,                                       // 兽人
			/mob/living/carbon/human/species/goblin = 40,                                     // 哥布林
			/mob/living/carbon/human/species/lizardfolk/psy_vault_guard = 200,                // 蜥蜴人秘库守卫
			/mob/living/carbon/human/species/construct/metal/zizoconstruct = 100,             // 兹佐金属构装体
		)
	return rewards

// get_fixed_reward：取某个目标的"固定积分"。命中名单返回其分值，否则返回 0。
//   匹配规则：取名单中"目标 istype 命中、且最具体（最深子类型）"的那条。
//   为什么取最具体：例如骷髅基类登记 30、其子类型 bogguard 登记 40——一只 bogguard 同时
//   istype 命中两条，应按更具体的 bogguard（40）给分；而未单独登记的其它骷髅子类型则回落到基类 30。
/datum/component/rpg_system/proc/get_fixed_reward(mob/living/victim)
	if(!isliving(victim))
		return 0
	var/list/rewards = get_fixed_kill_rewards()
	var/best_type    // 已找到的最具体匹配类型
	for(var/mob_type in rewards)
		if(!istype(victim, mob_type))
			continue
		// 同一目标的所有命中项都在其类型继承链上、彼此为父子关系：若新命中项是当前最优项的
		//   子类型（ispath(新, 旧) 为真），说明它更具体，取而代之。
		if(!best_type || ispath(mob_type, best_type))
			best_type = mob_type
	return best_type ? rewards[best_type] : 0

// ----------------------------------------------------------------------------
// 友善生物名单：simple_animal 目录里"友善 / 不该给分"的生物类型族。
// 需求："击杀 simple_animal 目录下的生物给分，但友善生物除外。"
//   引擎把友善生物集中放在 simple_animal/friendly/ 目录，但它们的类型路径各不相同（宠物在
//   /pet 下、家畜雏类 / 虫豸直接挂在 simple_animal 下），故这里按"类型族"逐一登记。
//   注意：friendly/ 目录里少数其实是 /hostile 子类型（山羊 / 毒蛇 / 蜥蜴等），它们是会反击的
//   野生 / 牲畜，按"战斗 / 可猎杀生物"对待——不在本友善名单内，照常给分。
//   另：roguetown 实际使用的农场牲畜是 rogue/farm 下的 /hostile/retaliate/rogue/* 类型（与此处
//   的原版 /cow、/chicken 路径不同），它们不属"友善"目录、会反击，故也照常给分（可猎杀取肉）。
/datum/component/rpg_system/proc/get_friendly_beast_types()
	// 静态缓存：名单恒定，首次构建后复用。
	var/static/list/friendlies
	if(!friendlies)
		friendlies = list(
			/mob/living/simple_animal/pet,            // 宠物总族：猫 / 狗 / 狐 / 魔宠 等
			/mob/living/simple_animal/butterfly,      // 蝴蝶
			/mob/living/simple_animal/cockroach,      // 蟑螂
			/mob/living/simple_animal/mouse,          // 老鼠
			/mob/living/simple_animal/cow,            // 原版奶牛（友善）
			/mob/living/simple_animal/chick,          // 雏鸡
			/mob/living/simple_animal/chicken,        // 原版母鸡（友善）
			/mob/living/simple_animal/grenchensnacker,// 格兰琴零嘴兽（友善）
		)
	return friendlies

// is_rewardable_beast：判断某生物是否"可给分的 simple_animal 怪物"。
//   规则：是 /mob/living/simple_animal 子类型，且不属于任何"友善生物"类型族。
//   渲染挂载（process）与死亡结算（on_monster_death）共用本判定，保证两处口径一致。
/datum/component/rpg_system/proc/is_rewardable_beast(mob/living/target)
	// 必须是 simple_animal（本需求只针对该目录下的生物）。
	if(!istype(target, /mob/living/simple_animal))
		return FALSE
	// 命中任一友善类型族即排除（友善生物不给分）。
	for(var/friendly_type in get_friendly_beast_types())
		if(istype(target, friendly_type))
			return FALSE
	return TRUE

// award_points：给这名玩家发放击杀积分（由击杀监听组件在确认归属后调用）。
//   单独成 proc 而非外部直接改字段：集中处理"累加 + 反馈"，将来要做积分上限 / 音效也只改这里。
/datum/component/rpg_system/proc/award_points(amount, mob/living/victim)
	// 防御：非正数发放无意义，直接忽略，避免出现"杀怪倒扣分"之类的异常。
	if(amount <= 0)
		return
	// 防御：宿主必须仍是有效人类才发放与播报（极端时序下可能正在被删除）。
	if(!ishuman(parent))
		return
	var/mob/living/carbon/human/host = parent
	// 累加积分。这是玩家的核心成长资源，兑换时再从这里扣除。
	points += amount
	// 即时反馈：用"系统提示"的口吻播报本次收益与当前总积分，强化 RPG 升级打怪的爽感。
	//   victim?.name 做空安全：即使受害者已被 gib / 清理，也不会空引用。
	to_chat(host, span_green("【系统提示】击败了 [victim ? victim.name : "一只怪物"]，获得 [amount] 系统积分。（当前积分：[points]）"))


// ============================================================================
// 击杀监听组件：挂在"系统持有者附近的怪物"身上，一次性旁听其死亡并结算归属
// 为什么独立成组件：它要绑定到"怪物"而非玩家，监听怪物自己的 COMSIG_LIVING_DEATH。
//   组件能在怪物删除时自动清理信号，且 UNIQUE 保证同一只怪只挂一份监听（多名系统玩家围殴
//   同一只怪也只需一份监听，最终按 lastattacker 把分发给真正的最后一击者）。
// ============================================================================
/datum/component/rpg_kill_watcher
	// 唯一组件：同一只怪只允许一个监听实例，重复 AddComponent 会被丢弃。
	dupe_mode = COMPONENT_DUPE_UNIQUE
	// 是否已结算过本次击杀。为什么需要：death() 理论上可能在异常路径被多次触发，
	//   用这个一次性闸门确保"一只怪最多只给一次分"，杜绝刷分。
	var/rewarded = FALSE

// Initialize：监听组件创建时调用，校验宿主为活体并注册死亡信号。
/datum/component/rpg_kill_watcher/Initialize()
	. = ..()
	// 挂到任意活体上即可（敌对 simple_animal 或固定积分名单上的类人 NPC）；非活体无死亡可言，丢弃之。
	//   具体"算不算给分目标"在 process() 挂载时已筛过，这里只需保证宿主是 /mob/living 能发出死亡信号。
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	// 监听宿主（怪物）的死亡信号。引擎在 /mob/living/death() 末尾发出 COMSIG_LIVING_DEATH
	//   （death.dm:128），无论该怪是哪种子类型、其 death() 是否被重写，最终都会 ..() 到这里，
	//   因此监听它能可靠捕获"任何方式造成的死亡"。
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_monster_death))

// on_monster_death：怪物死亡信号回调，负责"解析最后攻击者 → 校验系统持有者 → 发放积分"。
// 为什么标 SIGNAL_HANDLER：信号回调是同步调用，绝不能 sleep。本过程只做弱引用解析、特性
//   判断、积分发放与一次 to_chat，全程不阻塞，符合 SIGNAL_HANDLER 约束。
/datum/component/rpg_kill_watcher/proc/on_monster_death(datum/source, gibbed)
	SIGNAL_HANDLER
	// 一次性闸门：已结算过就直接返回，确保一只怪只给一次分。
	if(rewarded)
		return
	// 防御：宿主必须仍是有效怪物，否则无法读取它的 lastattacker。
	if(!isliving(parent))
		return
	var/mob/living/victim = parent
	// 解析"最后攻击者"。lastattacker_weakref 是弱引用：凶手若已登出 / 被删除，resolve() 返回 null。
	//   为什么用弱引用而非直接存指针：避免怪物因持有凶手强引用而妨碍其被垃圾回收（引擎设计如此）。
	var/mob/living/carbon/human/killer = victim.lastattacker_weakref?.resolve()
	// 必须是"持有 RPG 系统特性的人类"才结算：排除被环境 / 其它怪 / 非系统玩家打死的情况。
	if(!ishuman(killer) || !HAS_TRAIT(killer, TRAIT_RPG_SYSTEM))
		return
	// 取出凶手身上的系统驱动组件（积分存放处）。理论上系统持有者必然挂有该组件；
	//   做空安全判断，万一缺失则安静放弃，绝不空引用。
	var/datum/component/rpg_system/system = killer.GetComponent(/datum/component/rpg_system)
	if(!system)
		return
	// 置一次性闸门：先标记已结算，再发放，避免极端重入下的重复给分。
	rewarded = TRUE
	// 计算本次积分：优先查"固定积分名单"（特定类人怪物给固定分）；否则按 simple_animal 的
	//   最大生命值比例发放。两者都不命中（例如普通玩家 / 牲畜被打死）则不发分。
	var/gain = 0
	// ① 固定积分名单（类人 NPC 怪物）。
	var/fixed = system.get_fixed_reward(victim)
	if(fixed > 0)
		gain = fixed
	// ② 可给分的 simple_animal（非友善生物）：按最大生命值比例给分，并设保底，使强怪多给、弱怪也不至于没收益。
	//   用 system.is_rewardable_beast 复核（该 proc 定义在驱动组件上），确保即便友善生物意外被挂上监听
	//   也不会给分（口径与 process 一致）。
	else if(system.is_rewardable_beast(victim))
		var/mob/living/simple_animal/beast = victim
		gain = max(RPG_SYSTEM_MIN_KILL_POINTS, round(beast.maxHealth * RPG_SYSTEM_POINTS_PER_MAXHP))
	// 两类都不是 → 不在给分范围（杜绝"杀玩家 / 杀牲畜也给分"），安静返回。
	if(gain <= 0)
		return
	// 委托驱动组件统一发放积分并播报反馈。
	system.award_points(gain, victim)


// ============================================================================
// 系统面板动词：玩家主动呼出的"独一无二的系统界面"
// 为什么做成 /mob/living/carbon/human 上的 verb：动词会出现在玩家指令栏，是最直观的"呼出
//   界面"入口；通过 apply_to_human 里的 verbs += 只授予给持有者本人。
// 界面实现（为什么用 HTML 浏览器窗口而非逐级 input 弹窗）：
//   参考牧师"激进路线"提供的奇迹（/obj/effect/proc_holder/spell/self/learnmiracle）所开的
//   "学习奇迹"专属兑换界面——它用 /datum/browser 打开一张 HTML 窗口，所有可购项一览无余、
//   带页签切换与"购买"超链接，点击经 Topic() 即时结算并整窗重绘。本系统照此把原先的"逐级
//   input 弹窗"升级为同款 HTML 面板：商品、价格、是否买得起、强化项的当前值与单价全部一屏可见，
//   单击即买、无需层层点选，体验大幅提升。
//   注意：仅"界面呈现方式"参考它；本系统的【打开方式】保持不变——依旧由下面这个动词呼出
//   （不像牧师那样用一个法术/奇迹来开），满足"不改变 RPG 系统兑换界面的打开方式"的要求。
// ============================================================================
/mob/living/carbon/human/proc/open_rpg_system()
	set name = "打开RPG系统"
	set category = "IC"
	// 二次校验：动词可能因各种原因残留，这里确认"确实持有系统特性"才放行，避免越权使用。
	if(!HAS_TRAIT(src, TRAIT_RPG_SYSTEM))
		to_chat(src, span_warning("【系统提示】你并未绑定任何系统。"))
		return
	// 取出本人的系统驱动组件（积分存放处）。缺失说明状态异常，安静给出提示并中止。
	var/datum/component/rpg_system/system = GetComponent(/datum/component/rpg_system)
	if(!system)
		to_chat(src, span_warning("【系统提示】系统尚未就绪，请稍后再试。"))
		return
	// 把界面逻辑交给组件处理：组件持有积分与商店数据，由它来驱动整套界面交互最自然。
	system.open_interface(src)

// open_interface：呼出 HTML 系统面板（打开浏览器窗口并渲染当前页签）。
//   不再是"阻塞式逐级 input 循环"，而是一次性把整张 HTML 面板推给客户端；之后的所有交互
//   （切页签、购买、强化）都由 Topic() 接管并重绘，open_interface 自身只负责"首次打开"。
/datum/component/rpg_system/proc/open_interface(mob/living/carbon/human/user)
	// 防御：必须有有效的发起者（且就是本组件的宿主、且在线），否则不开界面。
	if(!istype(user) || user != parent || user.stat == DEAD || !user.client)
		return
	// 直接渲染并打开窗口。渲染逻辑集中在 render_ui，便于 Topic() 处理完动作后复用同一套重绘。
	render_ui(user)

// render_ui：构建并推送整张 HTML 系统面板。
//   设计参考 learnmiracle 的 open_learn_ui：顶部显示资源（此处为系统积分）、一排页签导航，
//   下方是当前页签的内容表格；所有可操作项都是 <a href="?src=[REF(src)];..."> 超链接，
//   点击后由本组件的 Topic() 结算。[REF(src)] 指向本组件实例，故 Topic 一定路由回这里。
/datum/component/rpg_system/proc/render_ui(mob/living/carbon/human/user)
	// 防御：宿主无效 / 离线则不渲染（窗口也无处可推）。
	if(!ishuman(parent) || user != parent || !user.client)
		return
	// ---- 顶部：标题 + 当前积分 ----
	var/list/html = list()
	html += "<center><h2>RPG 系统</h2></center>"
	html += "<center>世界旅人的作弊面板</center><hr>"
	html += "当前系统积分：<b>[points]</b><hr>"
	// ---- 页签导航：5 个商品分类 + 强化属性 + 强化技能 ----
	// 当前页签用粗体高亮、非当前页签用超链接，点击发 ?tab=<id> 切换（与 learnmiracle 的 learntab 同理）。
	var/list/tabs = list(
		"weapon" = "武器",
		"equipment" = "装备",
		"consumable" = "消耗品",
		"material" = "材料",
		"magic" = "魔法物品",
		"delicacy" = "美食",
		"artifact" = "神器",
		"trait" = "特性",
		"stat" = "强化属性",
		"skill" = "强化技能",
	)
	var/list/nav = list()
	for(var/tab_id in tabs)
		if(tab_id == current_tab)
			nav += "<b>[tabs[tab_id]]</b>"                                            // 当前页：高亮、不可点
		else
			nav += "<a href=\"?src=[REF(src)];tab=[tab_id]\">[tabs[tab_id]]</a>"      // 其它页：可点切换
	html += jointext(nav, " | ")
	html += "<hr>"
	// ---- 主体：按当前页签渲染对应内容 ----
	//   商品页统一走 render_item_table；属性 / 技能页各有专门渲染（含当前值、递增单价、满级标注）。
	switch(current_tab)
		if("stat")
			html += render_stat_table(user)
		if("skill")
			html += render_skill_table(user)
		if("trait")
			html += render_trait_table(user)
		else
			html += render_item_table(user, current_tab)
	// 组装成单段 HTML，丢进 /datum/browser 并打开。窗口 ID 固定，重复 open 会刷新同一窗口（不会叠窗）。
	var/datum/browser/panel = new(user, "rpg_system_panel", "RPG 系统", 560, 620)
	panel.set_content(jointext(html, ""))
	panel.open()

// ----------------------------------------------------------------------------
// 商店目录（catalog）：把"可兑换的实体物品"集中配置在这里，便于统一维护与扩展。
// 结构约定：关联列表  "玩家可见名" => list(积分价格, 物品类型路径)。
//   为什么按入口分多个 proc 而非一个大表：武器 / 装备 / 消耗品 / 材料 / 魔法物品 在面板里是
//   不同页签，分开返回各自的子表，逻辑清晰；将来要加新货只需往对应 proc 的列表里追加一行。
//   所有类型路径都引用引擎中已存在的 roguetown 物品（含本模块自定义的魔法物品），确保必定可生成、可编译。
//   渲染（render_item_table）与结算（do_buy_item）都通过 get_catalog_for_tab 取同一张表，按"行号"
//   对应商品，故新增分类只需"加一张目录表 + render_ui 页签加一项 + get_catalog_for_tab 加一条分支"。
// ----------------------------------------------------------------------------
/datum/component/rpg_system/proc/get_weapon_catalog()
	return list(
		"狩猎刀（40积分）" = list(40, /obj/item/rogueweapon/huntingknife),                    // 轻便短刀，便宜的入门武器
		"铁剑（80积分）"   = list(80, /obj/item/rogueweapon/sword/iron),                      // 入门级单手剑
		"长矛（110积分）"  = list(110, /obj/item/rogueweapon/spear),                          // 长柄武器，攻击距离更远
		"长剑（140积分）"  = list(140, /obj/item/rogueweapon/sword/long),                     // 更长、伤害更高的剑
		"钢锤（160积分）"  = list(160, /obj/item/rogueweapon/mace/steel),                     // 钝击武器，破甲见长
		"战斧（180积分）"  = list(180, /obj/item/rogueweapon/stoneaxe/battle),                // 重型斧，高伤害
		"三叉戟（210积分）"= list(210, /obj/item/rogueweapon/spear/trident),                  // 高级长柄武器
		"弩（240积分）"    = list(240, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow), // 远程武器（需自备弩矢）
		"投石索（90积分）"= list(90, /obj/item/gun/ballistic/revolver/grenadelauncher/sling),      // 廉价远程武器（需自备弹丸）
		"弓（200积分）"   = list(200, /obj/item/gun/ballistic/revolver/grenadelauncher/bow),        // 远程武器（需自备箭矢）
		"弯刀（150积分）"  = list(150, /obj/item/rogueweapon/sword/falx),                     // 法尔克斯弯刀，劈砍见长
		"短棍（50积分）"   = list(50, /obj/item/rogueweapon/mace/cudgel),                     // 廉价钝器，入门近战
		"重锤（260积分）"  = list(260, /obj/item/rogueweapon/mace/goden),                     // 戈登大棒，重型钝击
		"戟（280积分）"    = list(280, /obj/item/rogueweapon/halberd),                        // 长柄重武器，攻防兼备
		"连枷（170积分）"  = list(170, /obj/item/rogueweapon/flail),                          // 链锤，无视格挡角度
		"刺剑（220积分）"  = list(220, /obj/item/rogueweapon/estoc),                          // 重型刺剑，破甲穿刺
		"木棍（25积分）"   = list(25, /obj/item/rogueweapon/mace/woodclub),                   // 最廉价的钝器
		"短剑（70积分）"   = list(70, /obj/item/rogueweapon/sword/short),                     // 轻便单手短剑
		"草叉（70积分）"   = list(70, /obj/item/rogueweapon/pitchfork),                       // 长柄农具，可作刺击武器
		"鞭子（90积分）"   = list(90, /obj/item/rogueweapon/whip),                            // 长鞭，远距离软兵
		"镐（60积分）"     = list(60, /obj/item/rogueweapon/pick),                            // 矿镐，亦可作刺击武器
		"铁锤（90积分）"   = list(90, /obj/item/rogueweapon/hammer/iron),                     // 铁锻锤，钝击 / 打铁两用
		"巨剑（300积分）"  = list(300, /obj/item/rogueweapon/greatsword),                     // 双手巨剑，高伤害重武器
	)

/datum/component/rpg_system/proc/get_equipment_catalog()
	return list(
		"兜帽（30积分）"     = list(30, /obj/item/clothing/head/roguetown/roguehood),        // 兜帽，遮风蔽脸
		"长靴（40积分）"     = list(40, /obj/item/clothing/shoes/roguetown/boots),           // 基础脚部护具
		"腰包（40积分）"     = list(40, /obj/item/storage/belt/rogue/pouch),                 // 腰间小袋，扩充携带空间
		"皮护腕（50积分）"   = list(50, /obj/item/clothing/wrists/roguetown/bracers/leather), // 轻型皮护腕
		"火把（50积分）"     = list(50, /obj/item/flashlight/flare/torch),                   // 照明工具（黑暗中作战必备）
		"锁链手套（60积分）" = list(60, /obj/item/clothing/gloves/roguetown/chain),          // 手部护具
		"护腕（70积分）"     = list(70, /obj/item/clothing/wrists/roguetown/bracers),        // 金属护腕，护住前臂
		"木盾（70积分）"     = list(70, /obj/item/rogueweapon/shield/wood),                  // 入门盾牌，格挡攻击
		"锁甲头巾（80积分）" = list(80, /obj/item/clothing/neck/roguetown/coif),             // 锁甲头巾，护住头颈
		"皮盔（55积分）"     = list(55, /obj/item/clothing/head/roguetown/helmet/leather),    // 轻型皮制头盔
		"头盔（90积分）"     = list(90, /obj/item/clothing/head/roguetown/helmet),           // 头部护具
		"皮背心（70积分）"   = list(70, /obj/item/clothing/suit/roguetown/armor/leather/vest), // 轻型皮背心
		"皮甲（100积分）"    = list(100, /obj/item/clothing/suit/roguetown/armor/leather),   // 基础躯干护甲
		"水壶盔（110积分）"  = list(110, /obj/item/clothing/head/roguetown/helmet/kettle),   // 宽檐铁盔，遮挡上方
		"铁盾（150积分）"    = list(150, /obj/item/rogueweapon/shield/iron),                 // 中级盾牌，格挡更强
		"轻型半盔（150积分）"= list(150, /obj/item/clothing/head/roguetown/helmet/sallet),   // 半罩式骑士盔
		"厚棉甲（130积分）"  = list(130, /obj/item/clothing/suit/roguetown/armor/gambeson),  // 软质护甲，缓冲钝击
		"板甲手套（140积分）"= list(140, /obj/item/clothing/gloves/roguetown/plate),         // 重型手部护具
		"重型头盔（170积分）"= list(170, /obj/item/clothing/head/roguetown/helmet/heavy),    // 重型头部护具
		"面甲盔（185积分）"  = list(185, /obj/item/clothing/head/roguetown/helmet/bascinet), // 带面甲的骑士盔
		"镶嵌甲（240积分）"  = list(240, /obj/item/clothing/suit/roguetown/armor/brigandine), // 镶钉皮甲，防护与灵活兼顾
		"背包（50积分）"     = list(50, /obj/item/storage/backpack/rogue/backpack),          // 背负容器，扩充携带空间
		"提灯（60积分）"     = list(60, /obj/item/flashlight/flare/torch/lantern),           // 可持续照明的提灯
		"塔盾（220积分）"    = list(220, /obj/item/rogueweapon/shield/tower),                // 大型塔盾，防护面积最大
		"锁子甲（200积分）"  = list(200, /obj/item/clothing/suit/roguetown/armor/chainmail), // 中级躯干护甲
		"板甲（320积分）"    = list(320, /obj/item/clothing/suit/roguetown/armor/plate),     // 高级躯干护甲，防护最强
	)

/datum/component/rpg_system/proc/get_consumable_catalog()
	return list(
		"清水（10积分）"     = list(10, /obj/item/reagent_containers/glass/bottle/rogue/water),      // 解渴的廉价补给
		"箭矢（6积分）"      = list(6, /obj/item/ammo_casing/caseless/rogue/arrow),                  // 弓用弹药
		"石箭（7积分）"      = list(7, /obj/item/ammo_casing/caseless/rogue/arrow/stone),            // 石制弓用弹药
		"弩矢（8积分）"      = list(8, /obj/item/ammo_casing/caseless/rogue/bolt),                   // 弩用弹药
		"铁箭（12积分）"     = list(12, /obj/item/ammo_casing/caseless/rogue/arrow/iron),            // 更锋利的弓用弹药
		"钢箭（20积分）"     = list(20, /obj/item/ammo_casing/caseless/rogue/arrow/steel),           // 钢制弓用弹药，穿透更强
		"啤酒（15积分）"     = list(15, /obj/item/reagent_containers/glass/bottle/rogue/beer),         // 廉价酒水
		"绷带（25积分）"     = list(25, /obj/item/natural/cloth/bandage),                            // 包扎止血
		"面包（30积分）"     = list(30, /obj/item/reagent_containers/food/snacks/rogue/bread),       // 充饥的食物
		"葡萄酒（25积分）"   = list(25, /obj/item/reagent_containers/glass/bottle/rogue/wine),          // 提神的酒水
		"体力药水（50积分）" = list(50, /obj/item/reagent_containers/glass/bottle/rogue/stampot),       // 恢复体力
		"治疗药水（60积分）" = list(60, /obj/item/reagent_containers/glass/bottle/rogue/healthpot),     // 回血
		"魔力药水（60积分）" = list(60, /obj/item/reagent_containers/glass/bottle/rogue/manapot),       // 回蓝
		"解毒剂（70积分）"   = list(70, /obj/item/reagent_containers/glass/bottle/rogue/antidote),      // 解除中毒
		"强效体力药水（100积分）" = list(100, /obj/item/reagent_containers/glass/bottle/rogue/strongstampot),  // 大量恢复体力
		"强效治疗药水（120积分）" = list(120, /obj/item/reagent_containers/glass/bottle/rogue/healthpotnew), // 强力回血
		"强效魔力药水（120积分）" = list(120, /obj/item/reagent_containers/glass/bottle/rogue/strongmanapot),  // 大量回蓝
		"强效解毒剂（140积分）"   = list(140, /obj/item/reagent_containers/glass/bottle/rogue/strong_antidote), // 强力解毒
	)

// get_material_catalog：锻造 / 制作材料目录。需求"在兑换列表中加入材料兑换"。
//   这些都是引擎里矿工 / 自然资源系产出的基础材料，玩家可拿去打造装备 / 制作物品。
// 定价原则（本次价值优化）：材料是"中间原料"，单价必须显著低于用它打成的成品装备
//   （例如成品锁子甲 200、板甲 320），否则"买原料比买成品还贵"就不合理。故整条材料线
//   统一压到 150 以内，按"普通自然物 < 贱金属 < 贵金属 / 宝石"由廉到贵平滑排列，
//   且任何一种金属锭都低于用它锻成的同级武器 / 护甲。
/datum/component/rpg_system/proc/get_material_catalog()
	return list(
		"灰烬（4积分）"     = list(4, /obj/item/ash),                     // 炼金 / 制作的廉价材料
		"石块（5积分）"     = list(5, /obj/item/natural/stone),           // 基础建材 / 制石器材料
		"木材（8积分）"     = list(8, /obj/item/grown/log/tree/small),    // 基础木料（可加工成木板等）
		"布料（10积分）"    = list(10, /obj/item/natural/cloth),          // 缝纫材料
		"玻璃（12积分）"    = list(12, /obj/item/natural/glass),          // 制瓶 / 镶窗等的基础材料
		"鞣制皮革（16积分）"= list(16, /obj/item/natural/hide/cured),     // 制甲 / 皮具材料
		"锡锭（18积分）"    = list(18, /obj/item/ingot/tin),              // 低级金属锭（合金原料）
		"铜锭（22积分）"    = list(22, /obj/item/ingot/copper),           // 低级金属锭
		"铁锭（28积分）"    = list(28, /obj/item/ingot/iron),             // 常用锻造金属锭
		"青铜锭（34积分）"  = list(34, /obj/item/ingot/bronze),           // 合金锭
		"绿宝石（40积分）"  = list(40, /obj/item/roguegem/green),         // 普通宝石，可镶嵌 / 制作材料
		"黄宝石（45积分）"  = list(45, /obj/item/roguegem/yellow),        // 普通宝石，可镶嵌 / 制作材料
		"钢锭（45积分）"    = list(45, /obj/item/ingot/steel),            // 高级锻造金属锭
		"银锭（55积分）"    = list(55, /obj/item/ingot/silver),           // 贵金属锭（克制特定敌人）
		"蓝宝石（60积分）"  = list(60, /obj/item/roguegem/blue),          // 较珍贵的宝石材料
		"金锭（70积分）"    = list(70, /obj/item/ingot/gold),             // 贵金属锭 / 高价值材料
		"紫宝石（70积分）"  = list(70, /obj/item/roguegem/violet),        // 较珍贵的宝石材料
		"黑钢锭（85积分）"  = list(85, /obj/item/ingot/blacksteel),       // 高级合金锭，质地坚硬
		"红宝石（100积分）" = list(100, /obj/item/roguegem/ruby),         // 珍贵宝石，可镶嵌 / 高价值材料
		"钻石（150积分）"   = list(150, /obj/item/roguegem/diamond),      // 最珍贵的宝石材料
	)

// get_magic_catalog：魔法物品目录。需求"加入魔法物品的兑换"。
//   魔法稀有珍贵，定价显著高于普通商品；其中既有引擎自带的魔法道具，也有本模块自定义的魔法物品。
/datum/component/rpg_system/proc/get_magic_catalog()
	return list(
		"见习传送卷轴（90积分）" = list(90, /obj/item/teleportation_scroll/apprentice),               // 入门级一次性魔法传送
		"圣徽（120积分）"       = list(120, /obj/item/clothing/neck/roguetown/psicross),              // 神圣符号，可引导秘法
		"传送卷轴（150积分）"   = list(150, /obj/item/teleportation_scroll),                          // 一次性魔法传送
		"魔法戒指（200积分）"   = list(200, /obj/item/clothing/ring/active),                          // 可激活的魔法戒指
		"随机魔法书（400积分）" = list(400, /obj/item/book/granter/spell/random),                    // 研读后习得一个随机法术
		"传讯术卷轴（150积分）" = list(150, /obj/item/book/granter/spell/blackstone/message),        // 研读后习得【传讯术】（远程传话）
		"羽落术卷轴（200积分）" = list(200, /obj/item/book/granter/spell/blackstone/featherfall),    // 研读后习得【羽落术】（缓降）
		"纵跃术卷轴（220积分）" = list(220, /obj/item/book/granter/spell/blackstone/leap),           // 研读后习得【纵跃术】（跳跃）
		"取物术卷轴（250积分）" = list(250, /obj/item/book/granter/spell/blackstone/fetch),          // 研读后习得【取物术】（隔空取物）
		"排斥术卷轴（260积分）" = list(260, /obj/item/book/granter/spell/blackstone/repel),          // 研读后习得【排斥术】（击退）
		"酸液飞溅卷轴（280积分）" = list(280, /obj/item/book/granter/spell/blackstone/acidsplash),   // 研读后习得【酸液飞溅】
		"坚毅卷轴（290积分）"   = list(290, /obj/item/book/granter/spell/blackstone/fortitude),      // 研读后习得【坚毅】（强韧增益）
		"火球术卷轴（300积分）" = list(300, /obj/item/book/granter/spell/blackstone/fireball),       // 研读后习得【火球术】
		"冰霜箭卷轴（320积分）" = list(320, /obj/item/book/granter/spell/blackstone/frostbolt),      // 研读后习得【冰霜箭】
		"闪电术卷轴（320积分）" = list(320, /obj/item/book/granter/spell/blackstone/lightning),      // 研读后习得【闪电术】
		"吐焰火球卷轴（340积分）" = list(340, /obj/item/book/granter/spell/blackstone/spitfire),     // 研读后习得【吐焰火球】
		"隐身术卷轴（350积分）" = list(350, /obj/item/book/granter/spell/blackstone/invisibility),   // 研读后习得【隐身术】
		"力场墙卷轴（360积分）" = list(360, /obj/item/book/granter/spell/blackstone/forcewall_weak), // 研读后习得【力场墙】（屏障）
		"寒骨卷轴（380积分）"   = list(380, /obj/item/book/granter/spell/blackstone/bonechill),      // 研读后习得【寒骨】（冰霜）
		"疾病射线卷轴（400积分）" = list(400, /obj/item/book/granter/spell/blackstone/sicknessray),  // 研读后习得【疾病射线】
		"强效火球术卷轴（500积分）" = list(500, /obj/item/book/granter/spell/blackstone/greaterfireball), // 研读后习得【强效火球术】
		// —— 法术卷轴（研读后习得对应法术，作用于"人"）——
		"小开锁卷轴（180积分）" = list(180, /obj/item/book/granter/spell/blackstone/lesserknock),     // 研读后习得【小开锁】（开锁）
		"指引卷轴（210积分）"   = list(210, /obj/item/book/granter/spell/blackstone/guidance),        // 研读后习得【指引】（增益）
		"缠绕卷轴（240积分）"   = list(240, /obj/item/book/granter/spell/blackstone/ensnare),         // 研读后习得【缠绕】（束缚）
		"雾化卷轴（260积分）"   = list(260, /obj/item/book/granter/spell/blackstone/aerosolize),      // 研读后习得【雾化】
		"易容卷轴（300积分）"   = list(300, /obj/item/book/granter/spell/blackstone/mirror_transform), // 研读后习得【镜像易容】（变换外貌）
		"巨化卷轴（320积分）"   = list(320, /obj/item/book/granter/spell/blackstone/enlarge),         // 研读后习得【巨化】（体型增大）
		"寻找魔宠卷轴（380积分）" = list(380, /obj/item/book/granter/spell/blackstone/familiar),       // 研读后习得【寻找魔宠】（召唤魔宠，可重复使用）
		"奥术顿悟卷轴（350积分）" = list(350, /obj/item/book/granter/spell_points),                    // 研读后获得 3 点法术点（需奥术新手及以上）
		"虚空奥术顿悟卷轴（650积分）" = list(650, /obj/item/book/granter/spell_points/voiddragon),     // 研读后获得 6 点法术点（需奥术新手及以上）
		// —— 附魔卷轴（对"物品"施加特殊附魔：手持卷轴点击目标物品即可附魔，不是教人法术）——
		//   T1 基础附魔
		"附魔·伐木（150积分）"   = list(150, /obj/item/enchantmentscroll/woodcut),     // 给斧子附魔：高效伐木
		"附魔·采矿（150积分）"   = list(150, /obj/item/enchantmentscroll/mining),      // 给镐子附魔：高效采矿
		"附魔·显照（170积分）"   = list(170, /obj/item/enchantmentscroll/revealing),   // 给物品附魔：光源照明范围翻倍
		"附魔·恒光（180积分）"   = list(180, /obj/item/enchantmentscroll/light),       // 给武器 / 衣物附魔：自身发光
		"附魔·幸运（200积分）"   = list(200, /obj/item/enchantmentscroll/xylix),       // 给衣物附魔：赐予幸运
		"附魔·储物（240积分）"   = list(240, /obj/item/enchantmentscroll/holding),     // 给容器附魔：容量翻倍
		//   T2 高级附魔
		"附魔·长步（240积分）"   = list(240, /obj/item/enchantmentscroll/trekk),       // 给鞋 / 戒指附魔：沼泽中行走自如
		"附魔·蛛行（250积分）"   = list(250, /obj/item/enchantmentscroll/climbing),    // 给衣物附魔：攀爬陡壁
		"附魔·夜视（250积分）"   = list(250, /obj/item/enchantmentscroll/nightvision), // 给衣物附魔：黑暗中视物
		"附魔·锻造（250积分）"   = list(250, /obj/item/enchantmentscroll/smithing),    // 给锤子附魔：打铁更有效
		"附魔·巧手（260积分）"   = list(260, /obj/item/enchantmentscroll/thievery),    // 给手套 / 戒指附魔：偷窃撬锁
		"附魔·羽步（280积分）"   = list(280, /obj/item/enchantmentscroll/featherstep), // 给鞋 / 戒指附魔：加速且脚步无声
		"附魔·抗火（280积分）"   = list(280, /obj/item/enchantmentscroll/fireresist),  // 给衣物附魔：不会被点燃
		"附魔·坚不可摧（300积分）" = list(300, /obj/item/enchantmentscroll/unbreaking), // 给武器 / 衣物附魔：更耐用
		//   T3 强力附魔
		"附魔·武器召回（420积分）" = list(420, /obj/item/enchantmentscroll/returningweapon), // 给戒指 / 项链 / 手套附魔：召回武器
		"附魔·箭术（440积分）"   = list(440, /obj/item/enchantmentscroll/archery),     // 给戒指 / 护腕附魔：提升箭术
		"附魔·愈合（450积分）"   = list(450, /obj/item/enchantmentscroll/woundclosing), // 给戒指附魔：定期闭合伤口
		"附魔·霜幕（460积分）"   = list(460, /obj/item/enchantmentscroll/frostveil),   // 给武器 / 护甲附魔：减速敌人
		"附魔·闪电（480积分）"   = list(480, /obj/item/enchantmentscroll/lightning),   // 给武器附魔：命中电击
		"附魔·凤凰守卫（480积分）" = list(480, /obj/item/enchantmentscroll/phoenixguard), // 给衣物附魔：反伤点燃来犯者
		"附魔·吸血（500积分）"   = list(500, /obj/item/enchantmentscroll/lifesteal),   // 给武器附魔：命中回血
		"附魔·虚空（520积分）"   = list(520, /obj/item/enchantmentscroll/voidtouched), // 给武器附魔：将敌人短暂拽入虚空
		//   T4 神话附魔
		"附魔·荆棘诅咒（700积分）" = list(700, /obj/item/enchantmentscroll/briars),     // 给武器附魔：伤害大增但反噬自身
		"附魔·地狱火焰（750积分）" = list(750, /obj/item/enchantmentscroll/infernalflame), // 给武器 / 衣物附魔：命中点燃
		"附魔·冰冻（780积分）"   = list(780, /obj/item/enchantmentscroll/freeze),      // 给武器 / 衣物附魔：命中冻结
		"附魔·时间回溯（800积分）" = list(800, /obj/item/enchantmentscroll/rewind),     // 给武器 / 衣物附魔：受击后回溯位置
		"附魔·混沌风暴（850积分）" = list(850, /obj/item/enchantmentscroll/chaos_storm), // 给武器附魔：随机混沌效果
		"月光大剑（600积分）"   = list(600, /obj/item/rogueweapon/greatsword/moonlight_greatsword),   // 本模块自定义：高级魔法巨剑
	)

// get_delicacy_catalog：美食（珍馐 / 佳酿）目录。需求"加入昂贵的美食与饮品"。
//   与普通"消耗品"分开成独立页签：消耗品偏功能（药水 / 弹药 / 干粮），美食偏享受 / 奢侈，
//   定价显著高于同等填饱肚子的干粮——卖的是"风味与排场"。
// 重要约束（按需求）：本目录只收录"昂贵的成品 / 熟食"，绝不收录生肉等"未加工原料"。
//   因此这里只放：熟派 / 熟酿蛋等明确的熟食、奶酪 / 蜂蜜等成品、以及各类佳酿；
//   生牛排 / 生禽肉 / 生兔肉等未烹饪肉类属于"原料"，已剔除（玩家若想要生肉应去别处加工，
//   不在"珍馐"之列）。全部为引擎已有的成品食物 / 佳酿。
/datum/component/rpg_system/proc/get_delicacy_catalog()
	return list(
		"饼干（35积分）"     = list(35, /obj/item/reagent_containers/food/snacks/rogue/biscuit),        // 饼干，烤好的成品点心（cookie 图标缺失，改用图标确实存在的 biscuit）
		"奶酪（40积分）"     = list(40, /obj/item/reagent_containers/food/snacks/rogue/cheese),         // 奶酪，成品乳制珍品
		"蜂蜜（45积分）"     = list(45, /obj/item/reagent_containers/food/snacks/rogue/honey),          // 蜂蜜，成品甘味珍品
		"奶酪三明治（50积分）" = list(50, /obj/item/reagent_containers/food/snacks/rogue/sandwich/cheese), // 奶酪三明治，成品餐食（基类 sandwich 无图标，改用有图标的奶酪子类型）
		"熟酿蛋（55积分）"   = list(55, /obj/item/reagent_containers/food/snacks/rogue/stuffedegg/cooked), // 熟酿蛋，烹好的成品菜
		"果馅卷（80积分）"   = list(80, /obj/item/reagent_containers/food/snacks/rogue/strudel),        // 果馅卷，烤好的成品酥点
		"糖渍果馅卷（95积分）" = list(95, /obj/item/reagent_containers/food/snacks/rogue/strudel/sugar), // 糖渍果馅卷，成品甜点
		"红酒（70积分）"     = list(70, /obj/item/reagent_containers/glass/bottle/rogue/redwine),       // 红葡萄酒，餐桌佳酿
		"白葡萄酒（70积分）" = list(70, /obj/item/reagent_containers/glass/bottle/rogue/whitewine),     // 白葡萄酒，清爽佳酿
		"肉派（90积分）"     = list(90, /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat),  // 烤好的肉馅大派，成品硬菜
		"蟹肉派（110积分）"  = list(110, /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/crab), // 烤好的蟹肉派，成品珍馐
		"精灵红酒（150积分）"= list(150, /obj/item/reagent_containers/glass/bottle/rogue/elfred),       // 精灵红酒，名贵佳酿
		"精灵蓝酒（160积分）"= list(160, /obj/item/reagent_containers/glass/bottle/rogue/elfblue),      // 精灵蓝酒，名贵佳酿
		"仙馐蜂蜜（200积分）"= list(200, /obj/item/reagent_containers/food/snacks/rogue/honey/ambrosia), // 仙馐蜂蜜，传说级成品珍馐
	)

// get_artifact_catalog：神器（与神祇相关的圣物）目录。需求"加入与神有关的神器"。
//   收录主神们的圣徽护符——每件都是某位神祇的信物 / 圣物，属"与神相关"的器物；
//   另含受祝的银制圣物作为高阶神器。全部为引擎已有的成品物件。
/datum/component/rpg_system/proc/get_artifact_catalog()
	return list(
		"阿斯特拉塔护符（150积分）" = list(150, /obj/item/clothing/neck/roguetown/psicross/astrata),  // 太阳女神 阿斯特拉塔 的圣徽
		"诺克护符（150积分）"       = list(150, /obj/item/clothing/neck/roguetown/psicross/noc),      // 求知之神 诺克 的圣徽
		"阿比索尔护符（150积分）"   = list(150, /obj/item/clothing/neck/roguetown/psicross/abyssor),  // 深海之神 阿比索尔 的圣徽
		"邓多尔护符（150积分）"     = list(150, /obj/item/clothing/neck/roguetown/psicross/dendor),   // 自然之神 邓多尔 的圣徽
		"奈克拉护符（150积分）"     = list(150, /obj/item/clothing/neck/roguetown/psicross/necra),    // 死亡之神 奈克拉 的圣徽
		"佩斯特拉护符（150积分）"   = list(150, /obj/item/clothing/neck/roguetown/psicross/pestra),   // 医疗之神 佩斯特拉 的圣徽
		"拉沃克斯护符（150积分）"   = list(150, /obj/item/clothing/neck/roguetown/psicross/ravox),    // 战争 / 正义之神 拉沃克斯 的圣徽
		"玛卢姆护符（150积分）"     = list(150, /obj/item/clothing/neck/roguetown/psicross/malum),    // 创造 / 火 之神 玛卢姆 的圣徽
		"埃奥拉护符（150积分）"     = list(150, /obj/item/clothing/neck/roguetown/psicross/eora),     // 羁绊之神 埃奥拉 的圣徽
		"希利克斯护符（150积分）"   = list(150, /obj/item/clothing/neck/roguetown/psicross/xylix),    // 戏谑之神 希利克斯 的圣徽
		"圣印护符（220积分）"       = list(220, /obj/item/clothing/neck/roguetown/psicross/undivided), // 圣座信物，地位与恩典的象征
		"受祝银制圣徽（350积分）"   = list(350, /obj/item/clothing/neck/roguetown/psicross/silver/astrata), // 受祝的银制 阿斯特拉塔 圣物（高阶神器）
	)

// get_catalog_for_tab：把"商品页签 id"映射到对应的商品目录表。
//   渲染（render_item_table）与购买结算（do_buy_item）都通过它取目录，保证两侧看到的是同一张表、
//   同一套顺序——这样 HTML 里按"行号"传参就能稳定对应到正确商品（详见 do_buy_item 的按序号取值）。
/datum/component/rpg_system/proc/get_catalog_for_tab(tab)
	switch(tab)
		if("weapon")
			return get_weapon_catalog()
		if("equipment")
			return get_equipment_catalog()
		if("consumable")
			return get_consumable_catalog()
		if("material")
			return get_material_catalog()
		if("magic")
			return get_magic_catalog()
		if("delicacy")
			return get_delicacy_catalog()
		if("artifact")
			return get_artifact_catalog()
	// 未知页签：返回空表，调用方据此显示"暂无商品"，绝不空引用。
	return list()

// render_item_table：把某个商品页签渲染成 HTML 表格（商品名 / 价格 / 购买）。
//   每行的"购买"按当前积分判定：买得起 → 可点的 <a> 链接（点击发 ?buyitem=<行号>&itemtab=<页签>）；
//   买不起 → 灰字"积分不足"。一屏列全，无需逐个点开，正是参考 learnmiracle 表格式界面的核心收益。
/datum/component/rpg_system/proc/render_item_table(mob/living/carbon/human/user, tab)
	var/list/catalog = get_catalog_for_tab(tab)
	// 空目录兜底：理论上不会，给个友好提示而非空白表格。
	if(!LAZYLEN(catalog))
		return "<i>该分类暂无可兑换的商品。</i>"
	var/list/rows = list()
	rows += "<table width='100%' cellspacing='2' cellpadding='3'>"
	rows += "<tr><th align='left'>商品</th><th width='90'>价格</th><th width='90'>操作</th></tr>"
	// 用"行号"作为购买参数：从 1 开始，与目录的迭代顺序严格一致（BYOND 关联列表保持插入序）。
	//   这样 href 里只需传一个数字，避免把含括号 / 中文的商品名塞进 URL 带来的编码问题。
	var/idx = 0
	for(var/catalog_key in catalog)
		idx++
		var/list/e = catalog[catalog_key]
		// 防御：配置异常的条目跳过，不进表（绝不渲染坏数据）。
		if(!islist(e) || e.len < 2)
			continue
		var/entry_cost = e[1]
		rows += "<tr>"
		rows += "<td>[catalog_key]</td>"                                              // 商品名（已含中文，浏览器直接显示）
		rows += "<td align='center'>[entry_cost]</td>"                               // 价格
		rows += "<td align='center'>"
		if(points >= entry_cost)
			// 买得起：可点购买链接。itemtab 一并带上，Topic 据此确认是在哪张目录里按行号取值。
			rows += "<a href=\"?src=[REF(src)];buyitem=[idx];itemtab=[tab]\">购买</a>"
		else
			// 买不起：灰字标注，按钮不可点（不发链接）。
			rows += "<span style='color:#7f8c8d'>积分不足</span>"
		rows += "</td></tr>"
	rows += "</table>"
	return jointext(rows, "")

// do_buy_item：实际购买结算（由 Topic 在玩家点击"购买"时调用）。
//   tab + index 唯一定位一件商品：取该页签目录的第 index 行，校验积分与类型路径后扣费、生成物品。
//   这是从旧 purchase_item 抽出的"单次成交"核心，去掉了 input 循环——交互改由 HTML 面板驱动。
/datum/component/rpg_system/proc/do_buy_item(mob/living/carbon/human/user, tab, index)
	// 防御：宿主状态校验（点击时玩家可能已死亡 / 离线）。
	if(!ishuman(parent) || user != parent || user.stat == DEAD)
		return
	var/list/catalog = get_catalog_for_tab(tab)
	// 行号健壮性校验：必须落在 [1, 目录长度] 内，越界一律忽略（防伪造 href）。
	if(!LAZYLEN(catalog) || index < 1 || index > catalog.len)
		return
	// 按插入序取出第 index 个键，再取其 (价格, 类型路径)。
	var/catalog_key = catalog[index]   // BYOND 关联列表按下标取到的是"键"
	var/list/entry = catalog[catalog_key]
	if(!islist(entry) || entry.len < 2)
		to_chat(user, span_warning("【系统提示】该商品配置异常，兑换失败。"))
		return
	var/cost = entry[1]      // 该商品的积分价格
	var/item_path = entry[2] // 该商品的物品类型路径
	// 积分校验：不足则明确告知差额，不扣分、不发货（HTML 里本就不该出现可点链接，这里再兜底一次）。
	if(points < cost)
		to_chat(user, span_warning("【系统提示】积分不足。需要 [cost]，你只有 [points]。"))
		return
	// 类型路径健壮性校验：必须是 /obj/item 的子类型才生成，杜绝因配置笔误生成出奇怪的东西。
	if(!ispath(item_path, /obj/item))
		to_chat(user, span_warning("【系统提示】该商品配置异常（无效物品），兑换失败。"))
		return
	// 先扣费，再发货。先扣费可避免"发货成功但扣费抛错"导致的白嫖；即便物品最终落在脚下也算发货成功。
	points -= cost
	// 在玩家脚下的地块生成物品，随后尝试塞进手里：put_in_hands 失败（双手已满）时，物品仍留在
	//   脚下地块（del_on_fail 默认 FALSE），不会凭空消失——玩家捡起即可，体验自洽。
	var/obj/item/bought = new item_path(get_turf(user))
	user.put_in_hands(bought)
	// 反馈本次兑换结果与剩余积分。
	to_chat(user, span_green("【系统提示】兑换成功：[bought.name]。（剩余积分：[points]）"))
	playsound(user, 'sound/misc/click.ogg', 50, FALSE) // 复用引擎已有音效，给一个轻量的"到账"反馈，无需新增音频资源。

// ----------------------------------------------------------------------------
// 递增单价计算：把"花费随当前等级递增"的规则集中在两个 proc 里，菜单展示与实际扣费都调用
//   它们，确保"显示的价"与"扣的价"永远一致（单一事实来源），避免两处各算一遍导致对不上。
// ----------------------------------------------------------------------------
// stat_upgrade_cost：把属性从 current_value 升到 current_value+1 所需的积分。
//   线性递增：当前值越高越贵（需求："属性越高，强化所需积分越多"）。
/datum/component/rpg_system/proc/stat_upgrade_cost(current_value)
	// 防御：把入参夹到合法属性区间 [1,20]，避免异常值算出负价 / 离谱价。
	current_value = clamp(current_value, 1, 20)
	return RPG_SYSTEM_STAT_COST_BASE * current_value

// skill_upgrade_cost：把技能从 current_level 升到 current_level+1 所需的积分。
//   按"目标等级"递增：目标越高越贵（需求："技能越高，强化所需积分越多"）。
/datum/component/rpg_system/proc/skill_upgrade_cost(current_level)
	// 防御：把入参夹到合法等级区间 [0,6]，避免异常值算出负价 / 离谱价。
	current_level = clamp(current_level, 0, SKILL_LEVEL_LEGENDARY)
	return RPG_SYSTEM_SKILL_COST_BASE * (current_level + 1)

// ----------------------------------------------------------------------------
// 强化属性：HTML 表格渲染 + 单次结算。单次花费随该属性当前值递增（封顶 20）。
// 为什么用 change_stat：它是引擎调整属性的统一入口，内部自带 1~20 越界保护（超过 20 的部分
//   会被吸收进 BUF 而非真正生效）。为避免"花了钱却卡在 20 白扣分"，扣费前先用 get_stat 预检。
// ----------------------------------------------------------------------------
// get_attribute_defs：可强化属性的有序表："玩家可见名" => 属性键（STATKEY_*）。
//   渲染与结算共用同一张表，按"行号"对应，保证显示与扣费指向同一项。
//   注意：本引擎里 STATKEY_* 与 STAT_* 取值相同（同为 "strength" 等字符串），同一个键既可传
//   change_stat（写入）也可传 get_stat（读取当前值），无需额外映射。
/datum/component/rpg_system/proc/get_attribute_defs()
	return list(
		"力量 STR" = STATKEY_STR,
		"感知 PER" = STATKEY_PER,
		"智力 INT" = STATKEY_INT,
		"体质 CON" = STATKEY_CON,
		"意志 WIL" = STATKEY_WIL,
		"速度 SPD" = STATKEY_SPD,
		"幸运 LCK" = STATKEY_LCK,
	)

// render_stat_table：把"强化属性"页渲染成 HTML 表格（属性 / 当前值 / 升级花费 / 操作）。
//   每行实时显示当前值与"下一点"的递增单价；已满级显示绿字"已满级"，买不起显示灰字"积分不足"，
//   买得起则给可点的"+1"链接（点击发 ?enhstat=<行号>）。所有属性一屏可见、单击即升。
/datum/component/rpg_system/proc/render_stat_table(mob/living/carbon/human/user)
	var/list/defs = get_attribute_defs()
	var/list/rows = list()
	rows += "<div style='color:#95a5a6;margin-bottom:6px;'>属性越高，强化所需积分越多。</div>"
	rows += "<table width='100%' cellspacing='2' cellpadding='3'>"
	rows += "<tr><th align='left'>属性</th><th width='70'>当前</th><th width='110'>升级花费</th><th width='70'>操作</th></tr>"
	var/idx = 0
	for(var/display in defs)
		idx++
		var/key = defs[display]
		var/cur = user.get_stat(key) // 当前属性值
		rows += "<tr>"
		rows += "<td>[display]</td>"
		rows += "<td align='center'>[cur]</td>"
		if(cur >= 20)
			// 已满级：无单价、无操作。
			rows += "<td align='center'>—</td><td align='center'><span style='color:#2ecc71'>已满级</span></td>"
		else
			var/this_cost = stat_upgrade_cost(cur)
			rows += "<td align='center'>[this_cost]</td>"
			rows += "<td align='center'>"
			if(points >= this_cost)
				rows += "<a href=\"?src=[REF(src)];enhstat=[idx]\">+1</a>"        // 买得起：可点升级
			else
				rows += "<span style='color:#7f8c8d'>积分不足</span>"             // 买不起：灰字
			rows += "</td>"
		rows += "</tr>"
	rows += "</table>"
	return jointext(rows, "")

// do_enhance_attribute：实际的属性 +1 结算（由 Topic 在玩家点击"+1"时调用）。index = 行号。
/datum/component/rpg_system/proc/do_enhance_attribute(mob/living/carbon/human/user, index)
	// 防御：宿主状态校验。
	if(!ishuman(parent) || user != parent || user.stat == DEAD)
		return
	var/list/defs = get_attribute_defs()
	// 行号健壮性校验：越界忽略（防伪造 href）。
	if(index < 1 || index > defs.len)
		return
	var/display = defs[index]   // 第 index 个键即"展示名"
	var/stat_key = defs[display] // 其对应的属性键
	// 以"此刻真实值"为准定价与封顶，杜绝差价 / 越界。
	var/cur = user.get_stat(stat_key)
	// 满级校验：已达 20 则不扣费（否则 change_stat 会把加成吞进 BUF，等于白花积分）。
	if(cur >= 20)
		to_chat(user, span_warning("【系统提示】[display] 已达上限（20），无法继续强化。"))
		return
	var/cost = stat_upgrade_cost(cur) // 本次升级的实际花费（随当前值递增）
	// 积分校验：不足则提示，不扣分（HTML 里本就不该出现可点链接，这里再兜底一次）。
	if(points < cost)
		to_chat(user, span_warning("【系统提示】积分不足。需要 [cost]，你只有 [points]。"))
		return
	// 扣费并 +1。change_stat 内部自带 1~20 封顶，这里再叠一层 get_stat 预检，双保险不浪费积分。
	points -= cost
	user.change_stat(stat_key, 1)
	// 反馈强化结果与剩余积分。
	to_chat(user, span_green("【系统提示】[display] +1（当前 [user.get_stat(stat_key)]），花费 [cost] 积分。（剩余积分：[points]）"))
	playsound(user, 'sound/misc/click.ogg', 50, FALSE)

// ----------------------------------------------------------------------------
// 强化技能：HTML 表格渲染 + 单次结算。单次花费随该技能当前等级递增（封顶传奇 / 6）。
// 为什么用 adjust_skillrank：它是引擎"按等级提升技能"的统一入口，内部按经验阈值把等级封顶到
//   传奇。为避免"已满级仍扣分"，扣费前先用 get_skill_level 预检当前等级。
// ----------------------------------------------------------------------------
// get_skill_defs：可强化技能的有序表："玩家可见名" => 技能类型路径。现已涵盖引擎全部可练技能：
//   战斗（近战 / 远程）、杂项（运动 / 生活 / 社交）、劳作（采集 / 生产）、工艺（锻造 / 制作）、
//   以及四系魔法。渲染与结算共用同一张表，按"行号"对应；将来要开放更多技能，往这张表追加即可。
//   所有技能升级都走统一的 adjust_skillrank，故新增一行即可，无需改动渲染 / 结算逻辑。
/datum/component/rpg_system/proc/get_skill_defs()
	return list(
		// —— 战斗：近战 ——
		"剑术"     = /datum/skill/combat/swords,
		"匕首"     = /datum/skill/combat/knives,
		"斧术"     = /datum/skill/combat/axes,
		"长柄"     = /datum/skill/combat/polearms,
		"钝器"     = /datum/skill/combat/maces,
		"鞭索"     = /datum/skill/combat/whipsflails,   // 鞭 / 连枷类
		"徒手"     = /datum/skill/combat/unarmed,
		"摔角"     = /datum/skill/combat/wrestling,
		"盾防"     = /datum/skill/combat/shields,
		// —— 战斗：远程 ——
		"弓术"     = /datum/skill/combat/bows,
		"弩术"     = /datum/skill/combat/crossbows,
		"投石"     = /datum/skill/combat/slings,
		"火器"     = /datum/skill/combat/firearms,
		// —— 杂项：运动 / 生活 / 社交 ——
		"运动"     = /datum/skill/misc/athletics,
		"攀爬"     = /datum/skill/misc/climbing,
		"游泳"     = /datum/skill/misc/swimming,
		"阅读"     = /datum/skill/misc/reading,
		"医术"     = /datum/skill/misc/medicine,
		"潜行"     = /datum/skill/misc/sneaking,
		"偷窃"     = /datum/skill/misc/stealing,
		"撬锁"     = /datum/skill/misc/lockpicking,
		"骑术"     = /datum/skill/misc/riding,
		"音乐"     = /datum/skill/misc/music,
		"追踪"     = /datum/skill/misc/tracking,
		// —— 劳作：采集 / 生产 ——
		"耕作"     = /datum/skill/labor/farming,
		"采矿"     = /datum/skill/labor/mining,
		"捕鱼"     = /datum/skill/labor/fishing,
		"屠宰"     = /datum/skill/labor/butchering,
		"伐木"     = /datum/skill/labor/lumberjacking,
		// —— 工艺：锻造 / 制作 ——
		"工艺"     = /datum/skill/craft/crafting,
		"锻造武器" = /datum/skill/craft/weaponsmithing,
		"锻造护甲" = /datum/skill/craft/armorsmithing,
		"铁匠"     = /datum/skill/craft/blacksmithing,
		"冶炼"     = /datum/skill/craft/smelting,
		"木工"     = /datum/skill/craft/carpentry,
		"石工"     = /datum/skill/craft/masonry,
		"工程"     = /datum/skill/craft/engineering,
		"烹饪"     = /datum/skill/craft/cooking,
		"缝纫"     = /datum/skill/craft/sewing,
		"制革"     = /datum/skill/craft/tanning,
		"制陶"     = /datum/skill/craft/ceramics,
		"炼金"     = /datum/skill/craft/alchemy,
		// —— 魔法 ——（血魔法按需求不开放强化，故不列入）
		"神圣魔法" = /datum/skill/magic/holy,
		"奥术"     = /datum/skill/magic/arcane,
		"德鲁伊魔法" = /datum/skill/magic/druidic,
	)

// render_skill_table：把"强化技能"页渲染成 HTML 表格（技能 / 当前等级 / 升级花费 / 操作）。
//   行为与 render_stat_table 一致：满级绿字、买不起灰字、买得起给可点的"升级"链接（?enhskill=<行号>）。
//   依赖 mind（技能数据挂在 mind 的 skill_holder 上）；无 mind 时给出提示而非表格。
/datum/component/rpg_system/proc/render_skill_table(mob/living/carbon/human/user)
	// 无 mind 兜底：技能体系尚未就绪，明确告知而非渲染一张操作即失败的表。
	if(!user.mind)
		return "<i>你的意识尚不稳定，暂时无法强化技能。</i>"
	var/list/defs = get_skill_defs()
	var/list/rows = list()
	rows += "<div style='color:#95a5a6;margin-bottom:6px;'>技能越高，强化所需积分越多。</div>"
	rows += "<table width='100%' cellspacing='2' cellpadding='3'>"
	rows += "<tr><th align='left'>技能</th><th width='70'>当前</th><th width='110'>升级花费</th><th width='70'>操作</th></tr>"
	var/idx = 0
	for(var/display in defs)
		idx++
		var/path = defs[display]
		var/lvl = user.get_skill_level(path) // 当前技能等级
		rows += "<tr>"
		rows += "<td>[display]</td>"
		rows += "<td align='center'>[lvl] 级</td>"
		if(lvl >= SKILL_LEVEL_LEGENDARY)
			// 已达传奇：无单价、无操作。
			rows += "<td align='center'>—</td><td align='center'><span style='color:#2ecc71'>已满级</span></td>"
		else
			var/this_cost = skill_upgrade_cost(lvl)
			rows += "<td align='center'>[this_cost]</td>"
			rows += "<td align='center'>"
			if(points >= this_cost)
				rows += "<a href=\"?src=[REF(src)];enhskill=[idx]\">升级</a>"      // 买得起：可点升级
			else
				rows += "<span style='color:#7f8c8d'>积分不足</span>"             // 买不起：灰字
			rows += "</td>"
		rows += "</tr>"
	rows += "</table>"
	return jointext(rows, "")

// do_enhance_skill：实际的技能 +1 级结算（由 Topic 在玩家点击"升级"时调用）。index = 行号。
/datum/component/rpg_system/proc/do_enhance_skill(mob/living/carbon/human/user, index)
	// 防御：宿主状态校验；并且强化技能依赖 mind，无 mind 则中止。
	if(!ishuman(parent) || user != parent || user.stat == DEAD)
		return
	if(!user.mind)
		to_chat(user, span_warning("【系统提示】你的意识尚不稳定，暂时无法强化技能。"))
		return
	var/list/defs = get_skill_defs()
	// 行号健壮性校验：越界忽略（防伪造 href）。
	if(index < 1 || index > defs.len)
		return
	var/display = defs[index]   // 第 index 个键即"展示名"
	var/skill_path = defs[display] // 其对应的技能类型路径
	// 类型路径健壮性校验：必须是 /datum/skill 子类型，杜绝配置笔误。
	if(!ispath(skill_path, /datum/skill))
		to_chat(user, span_warning("【系统提示】该技能配置异常，强化失败。"))
		return
	// 以"此刻真实等级"为准定价与封顶，杜绝差价 / 越界。
	var/lvl = user.get_skill_level(skill_path)
	// 满级校验：已达传奇（6）则不扣费（否则 adjust_skillrank 不会再升，等于白花积分）。
	if(lvl >= SKILL_LEVEL_LEGENDARY)
		to_chat(user, span_warning("【系统提示】[display] 已达传奇等级，无法继续强化。"))
		return
	var/cost = skill_upgrade_cost(lvl) // 本次升级的实际花费（随当前等级递增）
	// 积分校验：不足则提示，不扣分。
	if(points < cost)
		to_chat(user, span_warning("【系统提示】积分不足。需要 [cost]，你只有 [points]。"))
		return
	// 扣费并提升 1 级。adjust_skillrank 内部按经验阈值封顶到传奇，安全。
	points -= cost
	user.adjust_skillrank(skill_path, 1, TRUE) // 第三参 TRUE = 静默，由我们自己统一播报反馈
	// 反馈强化结果与剩余积分。
	to_chat(user, span_green("【系统提示】[display] 已提升至等级 [user.get_skill_level(skill_path)]，花费 [cost] 积分。（剩余积分：[points]）"))
	playsound(user, 'sound/misc/click.ogg', 50, FALSE)

// ----------------------------------------------------------------------------
// 特性兑换：用积分永久获得一项"正向增益特性 / 天赋"，单价统一 RPG_SYSTEM_TRAIT_COST（2000）。
// 需求："加入特性兑换；特性取自 code/__DEFINES/traits.dm；只收录正向增益特性；价格统一 2000。"
// 实现要点（为什么这样写）：
//   - 特性不是 /obj/item，无法走商品目录的"生成实体"流程，故单列目录 + 渲染 + 结算三件套。
//   - 这些 TRAIT_* 宏定义在 modular_z121 之外的 code/__DEFINES/traits.dm；本文件只是"引用"这些
//     编译期常量（宏展开为可读中文串），不修改其源文件，符合"只在 modular_z121 内新增"的约束。
//   - 这些特性大多已登记在 GLOB.roguetraits（玩家特性自检面板），购买后玩家即可在面板看到说明，
//     无需本系统额外登记。
//   - 严格只挑"正向增益"：战斗 / 防护 / 耐力 / 免疫 / 实用 / 求生类；不含负面、诅咒、职业 / 种族受限、
//     或带明显副作用的特性。
// ----------------------------------------------------------------------------
// get_trait_catalog：可兑换特性的有序表（纯特性串列表；串本身即玩家可见名）。
//   渲染与结算共用同一张表，按"行号"对应。将来要增减开放特性，往这张表加 / 删一行即可。
/datum/component/rpg_system/proc/get_trait_catalog()
	return list(
		TRAIT_MEDIUMARMOR,              // 锁甲训练：可无惩罚穿戴中型护甲
		TRAIT_HEAVYARMOR,               // 板甲训练：可无惩罚穿戴重型护甲
		TRAIT_DODGEEXPERT,              // 闪避专家：闪避能力强化
		TRAIT_MAGEARMOR,                // 魔法障壁：法师护甲
		TRAIT_CRITICAL_RESISTANCE,      // 重创抗性：更不易被打出重伤
		TRAIT_PSYDONIAN_GRIT,           // 普赛顿坚毅：疼痛耐受
		TRAIT_STRONGBITE,               // 强力啃咬：徒手撕咬更狠
		TRAIT_STRONGKICK,               // 强力飞踢：飞踢更强
		TRAIT_CIVILIZEDBARBARIAN,       // 拳斗专家：徒手格斗强化
		TRAIT_TAVERN_FIGHTER,           // 酒馆斗士：近身肉搏强化
		TRAIT_SHARPER_BLADES,           // 利刃常锋：武器更不易钝
		TRAIT_NOFALLDAMAGE2,            // 坠落免疫：免疫坠落伤害
		TRAIT_SHOCKIMMUNE,              // 抗电：免疫电击
		TRAIT_EXTREME_TEMPERATURE_IMMUNE, // 极端温度免疫：免疫中暑 / 冻伤
		TRAIT_WATERBREATHING,           // 水下呼吸：可在水下呼吸
		TRAIT_LEECHIMMUNE,              // 拒蛭：水蛭不再叮附
		TRAIT_DRUNK_HEALING,            // 酒疗：体内有足量酒精时缓慢自愈
		TRAIT_BETTER_SLEEP,             // 优眠：睡眠回复精力更多
		TRAIT_ZJUMP,                    // 高跃：可向上跳跃
		TRAIT_LEAPER,                   // 跃袭者：扑跃突进
		TRAIT_JACKOFALLTRADES,          // 万事通：技能升级消耗更低
		TRAIT_SEEPRICES,                // 熟练鉴价师：可看出物品价值
		TRAIT_PERFECT_TRACKER,          // 猎踪大师：必定发现并完美解析踪迹
		TRAIT_INTELLECTUAL,             // 学识者：博学
		TRAIT_NOSTINK,                  // 死鼻：不受恶臭影响
		TRAIT_GOODLOVER,                // 传奇情人：情爱方面的卓越天赋
		// —— 战斗 / 防护（续）——
		TRAIT_NOPAIN,                   // 无痛：感受不到疼痛
		TRAIT_NOPAINSTUN,               // 坚忍：疼痛不再打断动作
		TRAIT_HARDDISMEMBER,            // 难肢解：肢体更不易被卸下
		TRAIT_DUALWIELDER,              // 双持者：可双手各持一把武器
		TRAIT_COMBAT_AWARE,             // 战场警觉：临战感知更敏锐
		TRAIT_HOLYWARRIOR,              // 圣战士：神圣战斗强化
		TRAIT_ASSASSIN,                 // 刺客：暗杀技法
		TRAIT_GRABIMMUNE,               // 势不可挡：免疫被擒抱
		TRAIT_NATURALARMOR,             // 坚韧皮肤：天生护甲
		TRAIT_HARDSHELL,                // 硬壳：额外护甲
		TRAIT_BREADY,                   // 临战就绪：随时进入战斗状态
		TRAIT_DECEIVING_MEEKNESS,       // 伪弱藏锋：示弱诱敌
		TRAIT_NUTCRACKER,               // 碎卵者：攻击要害更狠
		TRAIT_BASHDOORS,                // 破门者：徒手破门
		TRAIT_SCALEARMOR,               // 风蚀鳞甲：鳞甲护体（法师护甲变体）
		TRAIT_HELLSPAWN,                // 地狱后裔：15% 几率免于被点燃
		TRAIT_ADRENALINE_RUSH,          // 肾上腺激涌：危急时迸发
		TRAIT_REGROW_LIMBS,            // 肢体再生：消耗营养再生断肢
		TRAIT_VENOMOUS,                 // 毒腺：啃咬带毒
		TRAIT_COUNTERCOUNTERSPELL,      // 反反制咒：抵御反制法术
		// —— 免疫 / 求生 ——
		TRAIT_NOBREATH,                 // 无息：无需呼吸
		TRAIT_TOXIMMUNE,                // 毒素免疫：免疫毒素
		TRAIT_NOHUNGER,                 // 无饥：不会饥饿
		TRAIT_ZOMBIE_IMMUNE,            // 尸鬼疫免疫：免疫亡者感染
		TRAIT_UNLYCKERABLE,             // 莱克免疫：免疫莱克化
		TRAIT_KNEESTINGER_IMMUNITY,     // 登多尔的赐福：免疫膝刺等
		TRAIT_ROT_EATER,                // 佩斯特拉的赐福：可食用腐败食物
		TRAIT_ORGAN_EATER,              // 格拉加尔的赐福：可食用器官
		TRAIT_CRACKHEAD,                // 巴奥莎的赐福：永不过量
		TRAIT_SEA_DRINKER,              // 深海之民：可饮海水
		TRAIT_NASTY_EATER,              // 异种消化：可食腐败 / 毒物 / 浊水
		TRAIT_WILD_EATER,               // 兽性消化：可食生 / 腐食与浊水
		// —— 感知 / 视觉 / 潜行 ——
		TRAIT_DARKVISION,               // 暗视：黑暗中视物
		TRAIT_ZIZOSIGHT,                // 齐佐的赐福：暗处视物更清
		TRAIT_NOCSIGHT,                 // 诺克的赐福：暗处视物更清
		TRAIT_KEENEARS,                 // 灵敏耳朵：听觉敏锐
		TRAIT_EXTEROCEPTION,            // 外感：可见他人饥渴
		TRAIT_SOUL_EXAMINE,             // 内克拉的赐福：可查验尸体灵魂是否离去
		TRAIT_HERETIC_SEER,             // 异端识者：识别异端
		TRAIT_JUSTICARSIGHT,            // 拉沃克斯之赐：查看罪犯的悬赏 / 罪行
		TRAIT_MATTHIOS_EYES,            // 马西奥斯之眼：看出他人最贵重的物品
		TRAIT_EMPATH,                   // 共情者：洞悉他人情绪
		TRAIT_LIGHT_STEP,               // 轻步：脚步无声
		TRAIT_SLEUTH,                   // 追缉者：追查线索
		TRAIT_WOODWALKER,               // 林行者：林地穿行自如
		TRAIT_WEBWALK,                  // 网行者：蛛网间自由穿行
		// —— 移动 ——
		TRAIT_LONGSTRIDER,              // 长足者：移动更快
		TRAIT_EQUESTRIAN,               // 骑术精湛：骑乘强化
		// —— 工艺 / 职业技艺 ——
		TRAIT_MEDICINE_EXPERT,          // 医道专家：精通医术
		TRAIT_ALCHEMY_EXPERT,           // 炼金专家：精通炼金
		TRAIT_SMITHING_EXPERT,          // 锻冶专家：精通锻造 / 冶炼 / 工程 / 采矿 / 制陶
		TRAIT_SEWING_EXPERT,            // 纺缝专家：精通缝纫 / 制革 / 屠宰
		TRAIT_SURVIVAL_EXPERT,          // 生存专家：精通屠宰 / 烹饪 / 捕鱼 / 制革
		TRAIT_HOMESTEAD_EXPERT,         // 拓荒专家：精通全部劳作技艺
		TRAIT_SELF_SUSTENANCE,          // 自给自足：解锁全部受限工艺技能
		TRAIT_FUSILIER,                 // 火枪手：火器技艺
		TRAIT_MASTER_CARPENTER,         // 木作大师：木工精通
		TRAIT_MASTER_MASON,             // 石作大师：石工精通
		TRAIT_TRAINED_SMITH,            // 受训铁匠：锻造加成
		TRAIT_KAZENGUNITE_SMITH,        // 风郡锻艺：锻造加成
		TRAIT_DWARF_REPAIR,             // 矮人工艺：修理加成
		TRAIT_SQUIRE_REPAIR,            // 侍从技艺：修理加成
		TRAIT_FORGEBLESSED,             // 玛勒姆的赐福：锻造耗力更少
		TRAIT_DYES,                     // 染艺师：染色技艺
		TRAIT_GOODWRITER,               // 妙笔文豪：书写技艺
		TRAIT_SEEDKNOW,                 // 识种者：辨识种子
		TRAIT_CAUTIOUS_FISHER,          // 谨慎渔夫：钓鱼加成
		TRAIT_GRAVEROBBER,              // 老练盗墓贼：盗墓技艺
		TRAIT_GOODTRAINER,              // 良师：教导他人更有效
		TRAIT_OUTDOORSMAN,              // 野外行家：野外生存
		TRAIT_WILDERNESSGUIDE,          // 荒野向导：荒野行进
		TRAIT_WOODSMAN,                 // 老练林人：守护林地时本领更敏锐
		TRAIT_GUARDSMAN,                // 警觉卫兵：守护城镇时本领更敏锐
		TRAIT_RITUALIST,                // 仪式师：可用仪式粉笔
		TRAIT_CICERONE,                 // 酒饮行家：精于品酒
		TRAIT_HUMEN_INGENUITY,          // 人类巧思：睡眠升级更省
		TRAIT_BLACKBAGGER,              // 缉拿技法：可用绞索 / 黑头套擒拿
		TRAIT_ENGINEERING_GOGGLES,      // 工程护目镜：获得护目镜视效
		// —— 魔法 ——
		TRAIT_ARCYNE_T1,                // 奥术训练（新手）
		TRAIT_ARCYNE_T2,                // 奥术训练（学徒）
		TRAIT_ARCYNE_T3,                // 奥术训练（专家）
		TRAIT_ARCYNE_T4,                // 奥术训练（大师）
		TRAIT_MIRROR_MAGIC,             // 镜像魔法
		TRAIT_RESONANCE,                // 共鸣施法者：为周围施法者提供增益
		TRAIT_XYLIX_DEVOTEE,            // 赛利克斯命织者：命运 / 幸运加成
		// —— 其它正向 ——
		TRAIT_FASTSLEEP,                // 速眠者：入睡更快
		TRAIT_STEELHEARTED,             // 铁心：血腥场面不影响心情
		TRAIT_BEAUTIFUL,                // 美貌：容貌出众
		TRAIT_APRICITY,                 // 暖阳恩沐：日间耐力恢复更快
		TRAIT_ABYSSOR_SWIM,             // 阿比索尔的赐福：游泳耗力更少
		TRAIT_XYLIX,                    // 赛利克斯的赐福：盗贼黑话
		TRAIT_TOLERANT,                 // 宽容：不因异族而生恶感
		TRAIT_SILVER_BLESSED,           // 银圣眷者：受银之祝福
	)

// render_trait_table：把"特性"页渲染成 HTML 表格（特性名 / 价格 / 操作）。
//   已拥有的显示绿字"已拥有"（不可重复买）；买不起显示灰字"积分不足"；买得起给可点的"兑换"链接。
/datum/component/rpg_system/proc/render_trait_table(mob/living/carbon/human/user)
	var/list/defs = get_trait_catalog()
	var/list/rows = list()
	rows += "<div style='color:#95a5a6;margin-bottom:6px;'>兑换后永久获得对应正向特性（统一单价 [RPG_SYSTEM_TRAIT_COST] 积分，每项仅可兑换一次）。</div>"
	rows += "<table width='100%' cellspacing='2' cellpadding='3'>"
	rows += "<tr><th align='left'>特性</th><th width='90'>价格</th><th width='90'>操作</th></tr>"
	var/idx = 0
	for(var/trait in defs)
		idx++
		rows += "<tr>"
		rows += "<td>[trait]</td>"                                                    // 特性串本身即可读名
		rows += "<td align='center'>[RPG_SYSTEM_TRAIT_COST]</td>"
		rows += "<td align='center'>"
		if(HAS_TRAIT(user, trait))
			rows += "<span style='color:#2ecc71'>已拥有</span>"                       // 已有：不可重复买
		else if(points >= RPG_SYSTEM_TRAIT_COST)
			rows += "<a href=\"?src=[REF(src)];buytrait=[idx]\">兑换</a>"             // 买得起：可点兑换
		else
			rows += "<span style='color:#7f8c8d'>积分不足</span>"                     // 买不起：灰字
		rows += "</td></tr>"
	rows += "</table>"
	return jointext(rows, "")

// do_buy_trait：实际的特性兑换结算（由 Topic 在玩家点击"兑换"时调用）。index = 行号。
/datum/component/rpg_system/proc/do_buy_trait(mob/living/carbon/human/user, index)
	// 防御：宿主状态校验。
	if(!ishuman(parent) || user != parent || user.stat == DEAD)
		return
	var/list/defs = get_trait_catalog()
	// 行号健壮性校验：越界忽略（防伪造 href）。
	if(index < 1 || index > defs.len)
		return
	var/trait = defs[index]   // 第 index 个特性串
	// 已拥有则不重复扣费 / 不重复添加（HAS_TRAIT 复核，与渲染口径一致）。
	if(HAS_TRAIT(user, trait))
		to_chat(user, span_warning("【系统提示】你已拥有【[trait]】，无需重复兑换。"))
		return
	// 积分校验：不足则提示，不扣分。
	if(points < RPG_SYSTEM_TRAIT_COST)
		to_chat(user, span_warning("【系统提示】积分不足。需要 [RPG_SYSTEM_TRAIT_COST]，你只有 [points]。"))
		return
	// 扣费并永久授予特性。来源用本系统专属标签，便于识别 / 将来统一清理，且不与别处来源冲突。
	points -= RPG_SYSTEM_TRAIT_COST
	ADD_TRAIT(user, trait, RPG_SYSTEM_TRAIT_SOURCE)
	// 反馈兑换结果与剩余积分。
	to_chat(user, span_green("【系统提示】兑换成功，永久获得特性【[trait]】，花费 [RPG_SYSTEM_TRAIT_COST] 积分。（剩余积分：[points]）"))
	playsound(user, 'sound/misc/click.ogg', 50, FALSE)

// ============================================================================
// Topic：HTML 系统面板的点击事件总入口。
// 为什么在组件上实现：面板里的每个链接都是 ?src=[REF(本组件)];key=value，BYOND 会把点击
//   路由到本组件的 Topic()。这里解析 href_list，完成"切页签 / 购买 / 强化"动作，然后整窗重绘，
//   使界面（积分、可负担状态、当前值）立即刷新——这正是参考 learnmiracle 的交互闭环。
// 安全性：所有动作都重新校验"操作者就是本系统持有者本人"，并对行号 / 页签做合法性校验，
//   即便有人伪造 href 也无法越权或刷物品。
// ============================================================================
/datum/component/rpg_system/Topic(href, href_list)
	. = ..()
	// 操作者必须是本组件的宿主本人（在线人类）。否则一律忽略，杜绝他人借 REF 操作你的面板。
	if(!ishuman(parent) || usr != parent)
		return
	var/mob/living/carbon/human/user = parent
	// 死亡 / 离线则不处理（也无窗口可重绘）。
	if(user.stat == DEAD || !user.client)
		return
	// ---- 切换页签 ----
	if(href_list["tab"])
		var/new_tab = href_list["tab"]
		// 仅接受白名单内的页签 id，过滤伪造值。
		if(new_tab in list("weapon", "equipment", "consumable", "material", "magic", "delicacy", "artifact", "trait", "stat", "skill"))
			current_tab = new_tab
	// ---- 购买商品 ----（buyitem = 行号；itemtab = 该行所属页签）
	else if(href_list["buyitem"])
		do_buy_item(user, href_list["itemtab"], text2num(href_list["buyitem"]))
	// ---- 强化属性 ----（enhstat = 行号）
	else if(href_list["enhstat"])
		do_enhance_attribute(user, text2num(href_list["enhstat"]))
	// ---- 强化技能 ----（enhskill = 行号）
	else if(href_list["enhskill"])
		do_enhance_skill(user, text2num(href_list["enhskill"]))
	// ---- 兑换特性 ----（buytrait = 行号）
	else if(href_list["buytrait"])
		do_buy_trait(user, text2num(href_list["buytrait"]))
	// 任一动作处理完毕后整窗重绘，使资源 / 可负担状态 / 当前值即时刷新（无动作的未知 href 也只是重绘）。
	render_ui(user)


// ----------------------------------------------------------------------------
// 让玩家在游戏内"看得见"这项特性：登记进 GLOB.roguetraits
// 为什么要登记：引擎的玩家特性自检面板会遍历 GLOB.roguetraits，对玩家拥有的每个特性打印
//   「特性名 - 描述」。把 TRAIT_RPG_SYSTEM 加进这张表，玩家点开特性列表才能看到"RPG系统"
//   及其说明；否则特性虽已生效，却对玩家不可见。
// 为什么用"运行时追加"而非直接改核心表：核心表 roguetraits 定义在 modular_z121 之外（禁止
//   修改），故在启动钩子里向已初始化的全局表追加键值对——这是本项目登记自定义内容的既定做法。
// 为什么做成独立 proc 由 custom_bootstrap 调用：#define 按 #include 顺序生效，bootstrap 的
//   包含顺序早于本文件，那里无法直接引用 TRAIT_RPG_SYSTEM 宏；而 proc 名全局可解析。于是把
//   "需要用到本文件宏"的登记逻辑封装在本文件 proc 内，bootstrap 只按名调用。
// ----------------------------------------------------------------------------
/proc/register_rpg_system_trait()
	// 防御：核心全局表必须已初始化为 list 才能写入；异常情况下安静跳过，绝不新建脱钩的"假表"。
	if(!islist(GLOB.roguetraits))
		return
	// 写入「特性键 -> 玩家自检描述」，第一人称、span_info 样式，与表中其它条目风格一致。
	//   幂等：重复调用只是覆盖同一个键，二次启动也安全。
	GLOB.roguetraits[TRAIT_RPG_SYSTEM] = span_info("我是世界旅人，持有只属于旅人的系统外挂：\
		击杀怪物可赚取系统积分，积分能兑换 武器 / 装备 / 消耗品 / 材料 / 魔法物品，也能强化我的技能与属性。")


// ----------------------------------------------------------------------------
// 清理本文件内部使用的数值宏，避免污染全局编译命名空间。
// 为什么保留 TRAIT_RPG_SYSTEM 不 #undef：它是对外可见的"身份标签"，击杀监听组件与未来其它
//   系统可能需要用 HAS_TRAIT 查询，这与本目录其它特性键（如 TRAIT_GENIUS）保持全局可见的约定一致。
// ----------------------------------------------------------------------------
#undef RPG_SYSTEM_TRIUMPH_COST
#undef RPG_SYSTEM_SCAN_RANGE
#undef RPG_SYSTEM_POINTS_PER_MAXHP
#undef RPG_SYSTEM_MIN_KILL_POINTS
#undef RPG_SYSTEM_STAT_COST_BASE
#undef RPG_SYSTEM_SKILL_COST_BASE
#undef RPG_SYSTEM_TRAIT_COST
#undef RPG_SYSTEM_TRAIT_SOURCE
