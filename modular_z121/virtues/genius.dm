// ============================================================================
// modular_z121/virtues/genius.dm
// 自定义美德（Custom Virtue）：天才 / Genius
// ----------------------------------------------------------------------------
// 设计目标（为什么要做这个文件）：
//   实现一个全新的、仅限"年轻"角色（最年轻的年龄档 AGE_ADULT）可选的美德"天才"。
//   它消耗 11 点凯旋点数（triumph_cost = 11），授予被动特性【天才】：
//     - 角色天资卓绝，任何技能"一学就会"——所有技能经验的获取量统一放大到 300%
//       （即经验倍率 ×3）。
//   需求拆解：
//     · 名称：Genius / 天才
//     · 消耗：11 点凯旋点数
//     · 限制：必须为"年轻"年龄（本游戏最年轻的可选年龄档 = AGE_ADULT "Adult"）
//     · 获得特性：天才（Genius）
//     · 特性效果：技能获取经验倍率 ×300%
//     · 该特性必须能被玩家在游戏内看到（登记进 GLOB.roguetraits 自检面板）
//
// 为什么所有逻辑都放在本文件内：
//   按硬性约束，自定义内容只能放在 modular_z121 目录下，且不得改动该目录之外的任何
//   文件。本文件通过"向已有类型追加子类型 / 子类型过程重写（override）"的方式接入引擎，
//   不修改任何核心文件，因此完全满足约束。
//   （向核心类型 /mob/living/carbon/human 追加一个 adjust_experience 重写，属于"追加子类型
//     过程"而非"编辑核心文件"——这与本目录既有做法一致，例如 life_potential.dm /
//     hellblood_descendant.dm 对核心类型追加 override 的用法。）
//
// 依赖（均为引擎已有内容，本文件只调用 / 继承 / 重写，不修改其源文件）：
//   - /datum/virtue                              美德基类（modular_azurepeak/_virtue.dm）
//   - /mob/proc/adjust_experience(skill, amt, …) 全部"技能经验获取"的唯一汇聚入口
//                                                （code/datums/skill_holder.dm:14）
//   - /mob/proc/adjust_triumphs(n, FALSE)        调整凯旋点数（年龄不符时退款）
//   - AGE_ADULT                                  最年轻的可选年龄档常量
//                                                （code/__DEFINES/preferences.dm:120）
//   - GLOB.roguetraits                           玩家"特性自检面板"读取的全局特性说明表
//   - ADD_TRAIT / HAS_TRAIT / TRAIT_VIRTUE       特性增删与美德来源标签
//
// 加载：本文件需在 modular_z121/_load.dm 中以 #include 引入（已在该文件追加）；
//       特性的玩家可见登记由 bootstrap/custom_bootstrap.dm 调用 register_genius_trait() 完成。
// ============================================================================


// ----------------------------------------------------------------------------
// 自定义特性键（Trait key）：天才
// 为什么要定义：用一个唯一字符串标识"持有天才"的人，便于本文件（及未来其它系统）
//   通过 HAS_TRAIT 判断身份，也作为 ADD_TRAIT 的来源标签使用。
// 为什么用"天才"这个中文串作为特性值（而非英文 slug）：
//   引擎的玩家"特性/天赋"自检面板会直接把"特性字符串本身"当作标题显示给玩家
//   （参见 life_potential.dm 对该机制的说明，以及 TRAIT_NOPAIN 的值"无痛"）。
//   因此要让玩家看到一个体面的名字，特性值就写成可读的中文名"天才"。
//   该串在本项目中唯一（已确认无其它特性占用"天才"），不会造成 HAS_TRAIT 歧义。
// ----------------------------------------------------------------------------
#define TRAIT_GENIUS "天才"

// 技能经验获取倍率：300% = ×3。需求明确为"技能获取经验倍率 ×300%"。
// 单独定义为常量，便于将来平衡性调整时只改这一处；本文件末尾会 #undef 掉，避免污染全局命名空间。
#define GENIUS_XP_MULTIPLIER 3


// ----------------------------------------------------------------------------
// 美德定义：天才
// 为什么归入 /datum/virtue/utility 分支：与 life_potential（生命潜能）、never_ending
//   （永无止境）等"效用型"被动美德保持一致；作为 /datum/virtue 子类型，会被
//   subtypesof() 自动收录进 GLOB.virtues（见 code/__HELPERS/global_lists.dm），无需手动注册。
// ----------------------------------------------------------------------------
/datum/virtue/utility/genius
	// 菜单中显示的美德名。
	name = "天才"
	// 角色内描述（in-character）：呼应"声名远扬的天才，一学就会"的设定。
	desc = "我是声名远扬的天才，任何学问只要接触一次便能融会贯通、一学就会。"
	// custom_text 用机制语言把硬性规则讲清楚，避免玩家误解触发条件。
	// 为什么单列：desc 偏角色口吻，这里写明"仅限年轻、获得天才特性、技能经验 ×300%"。
	custom_text = "获得【天才】特性（仅限年轻的角色）：\n\
	你天资卓绝、过目不忘——所获得的一切技能经验都会被放大到 300%（经验倍率 ×3），\n\
	任何技能都学得远比常人迅速。"
	// 消耗 11 点凯旋点数。基类 New() 会自动把"Costs 11 TRIUMPH"追加到 desc。
	// check_triumphs() 会在 apply_virtue 流程开头校验并扣除，点数不足则不授予。
	triumph_cost = 11
	// 为什么"不"用 added_traits 授予 TRAIT_GENIUS：
	//   apply_virtue 的调用顺序是 apply_to_human() 先于 handle_traits()。若走 added_traits，
	//   即便我们在 apply_to_human 里因"年龄不符"判定而想撤销标签，紧随其后的 handle_traits()
	//   仍会把它无条件加回，导致非年轻角色出现"有标签却本不该获得"的越权情形。
	//   因此改为在 apply_to_human 通过年龄校验后，手动 ADD_TRAIT，使"标签 = 资格通过"严格一致。

// apply_to_human：美德被赋予人物时调用。这里负责两件事：
//   1) 校验"仅限年轻"——非年轻角色（年龄档非 AGE_ADULT）退还点数、不授予能力。
//   2) 为合格的人物授予【天才】特性（其经验加成由下方 adjust_experience 重写统一驱动）。
/datum/virtue/utility/genius/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// 防御性检查：没有有效人物（极端时序下可能为 null）就直接返回，避免空引用。
	if(!istype(recipient))
		return

	// 为什么校验年龄："必须为年轻角色"是本美德的硬性设定。
	//   本游戏的可选年龄档为 ALL_AGES_LIST = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)，
	//   其中 AGE_ADULT（"Adult"）是最年轻的一档（也是默认值），即需求所指的"年轻"。
	//   非年轻角色（中年/老年）不应获得"天才"。这里做优雅降级：退还已扣除的点数、
	//   明确告知玩家原因，而不是直接抛错或白扣点数。
	if(recipient.age != AGE_ADULT)
		// 退款：apply_virtue 的调用顺序是 check_triumphs()（已扣 11 点）→ apply_to_human()，
		//   走到这里点数已被扣除，此处全额退还，避免玩家因误选而损失。
		//   adjust_triumphs 第二参 FALSE = 不弹提示音/特效（与 hellblood_descendant.dm 退款一致）。
		if(triumph_cost)
			recipient.adjust_triumphs(triumph_cost, FALSE)
		to_chat(recipient, span_warning("天才的锋芒只在年轻的头脑中闪耀——你已不再年轻，\
										无法觉醒这份天资。"))
		// 直接返回、既不打标签也不施加任何效果：非年轻角色彻底不获得本能力，状态自洽。
		return

	// 通过年龄校验：手动授予"身份标签"，来源标记 TRAIT_VIRTUE（与引擎美德特性约定一致，
	//   便于未来统一清理）。这样标签只在资格真正通过时存在，杜绝"有标签却越权"。
	ADD_TRAIT(recipient, TRAIT_GENIUS, TRAIT_VIRTUE)

	// 给出醒目反馈，让玩家清楚"天才已觉醒"，否则纯被动倍率对玩家不直观。
	to_chat(recipient, span_nicegreen("你的思维如电光石火般敏锐——任何技艺，于你而言皆是一学就会。"))


// ----------------------------------------------------------------------------
// 技能经验倍率：重写人类的经验获取入口
// 为什么选择重写 /mob/living/carbon/human/adjust_experience：
//   引擎中"一切技能经验的获取"都唯一汇聚到 /mob/proc/adjust_experience(skill, amt, …)
//   （定义于 code/datums/skill_holder.dm:14，再转交给 skill_holder.adjust_experience）。
//   无论是做饭、阅读、施法、战斗还是耕作，最终都调用它来加经验。因此在这里对 amt
//   做一次性放大，就能让"天才"对所有技能来源全面、自动地生效，而无需逐个系统改动。
// 为什么重写在 /mob/living/carbon/human 这一层：本美德只授予人类玩家；在 human 子类型上
//   重写，既精准命中目标群体，又不会干扰非人类 mob 的经验逻辑。这属于"追加子类型 override"，
//   不修改核心文件本身，符合约束（与本目录 life_potential.dm 重写 adjustFireLoss 等做法一致）。
// 参数完全沿用基类签名（skill, amt, silent, check_apprentice），并原样透传给 ..()，
//   确保除"放大经验"外的所有原有行为（升级提示、学徒同步等）保持不变。
// ----------------------------------------------------------------------------
/mob/living/carbon/human/adjust_experience(skill, amt, silent = FALSE, check_apprentice = TRUE)
	// 仅当：①确实持有【天才】特性；②本次是"正向经验获取"（amt > 0）时才放大。
	//   为什么要求 amt > 0：adjust_experience 也可能被传入负值用于"扣减/惩罚"经验，
	//   天才的设定是"学得更快"，不应连带把惩罚也放大（否则越天才被罚得越狠，违背直觉）。
	//   因此只放大正向收益，负向/零值原样透传。
	if(amt > 0 && HAS_TRAIT(src, TRAIT_GENIUS))
		amt *= GENIUS_XP_MULTIPLIER

	// 透传给基类完成真正的经验写入与后续处理（升级提示、学徒同步等均不受影响）。
	return ..(skill, amt, silent, check_apprentice)


// ----------------------------------------------------------------------------
// 让玩家在游戏内"看得见"这项特性：登记进 GLOB.roguetraits
// ----------------------------------------------------------------------------
// 为什么要登记：引擎的玩家特性自检面板会遍历 GLOB.roguetraits，对玩家"拥有的"每一个
//   特性，打印「特性名 - 描述」。只有把 TRAIT_GENIUS 加进这张全局表，玩家点开自己的特性
//   列表时才会看到"天才"及其说明；否则特性虽已通过 ADD_TRAIT 生效，却对玩家不可见，
//   不满足需求"该特性应能被玩家在游戏内看到"。
//
// 为什么用"运行时追加"而不是直接写进核心的 roguetraits 定义：
//   硬性约束要求只能改动 modular_z121。核心表 roguetraits 定义在 code/__DEFINES/traits.dm
//   （在本目录之外，禁止修改）。因此改为在启动钩子里向这张已初始化的全局表追加一个键值对
//   ——这正是本项目登记自定义内容的既定做法（参见 life_potential.dm / ancient_creation.dm
//   等同款 register_*_trait 过程，由 bootstrap/custom_bootstrap.dm 统一调用）。
//
// 为什么做成独立 proc 由 custom_bootstrap 调用：
//   #define 是按 #include 顺序生效的；custom_bootstrap.dm 的包含顺序早于本文件，那里无法
//   直接引用 TRAIT_GENIUS 宏。而 proc 名是全局解析的，跨文件可调用。于是把"需要用到本文件
//   宏"的登记逻辑封装在本文件的 proc 内，bootstrap 只按名调用，既遵守宏可见性规则，又复用了
//   统一的启动时机（此刻 roguetraits 已完成初始化）。
/proc/register_genius_trait()
	// 防御：核心全局表必须已初始化为 list 才能写入；异常情况下安静跳过，绝不新建一张
	//   会与核心表脱钩的"假表"，以免登记到一个永远不会被面板读取的列表上。
	if(!islist(GLOB.roguetraits))
		return
	// 写入「特性键 -> 玩家自检描述」。描述用第一人称、span_info 样式，与表中其它条目
	//   （如 TRAIT_NOPAIN = span_info("我感觉不到痛楚。")）的风格保持一致。
	//   幂等：重复调用只是覆盖同一个键，不会产生重复项，二次启动也安全。
	GLOB.roguetraits[TRAIT_GENIUS] = span_info("我是天才：任何技能我都一学就会，\
		所获得的技能经验是常人的三倍（经验倍率 ×300%）。")


// ----------------------------------------------------------------------------
// 清理本文件内部使用的数值宏，避免污染全局编译命名空间。
// 为什么保留 TRAIT_GENIUS 不 #undef：它是对外可见的"身份标签"，其它系统可能需要用
//   HAS_TRAIT 查询，这与 modular_z121 内其它特性键（如 TRAIT_LIFE_POTENTIAL）保持
//   全局可见的约定一致。
// ----------------------------------------------------------------------------
#undef GENIUS_XP_MULTIPLIER
