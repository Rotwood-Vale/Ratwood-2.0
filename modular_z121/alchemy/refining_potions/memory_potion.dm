// ============================================================================
// 回忆药剂 (Memory Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 题面需求(逐条对应，见下方实现)：
//   · 名称：回忆药剂 (Memory Potion)。
//   · 底料：清水 70 + 强效魔力药水 30（= 70 water + 30 strong mana potion）。
//   · 技能：炼金 5 级（Alchemy-Level5 = SKILL_LEVEL_MASTER）。
//   · 气味：任取一种【尚未被任何自定义精炼配方使用】的等级5气味 —— 本模块所有既有精炼配方已占用
//           了绝大多数原版配方气味，经核对唯一未被占用的是【"洁净的风"】(强效耐力灵药 big_stamina_potion
//           的 smells_like)。带此气味的现成材料(major=3，指向 big_stamina_potion)有：种子粉 / 炼金奥兹姆 /
//           圣蓟；任取两味同投即 3+3=6 >= 5，满足"5 级洁净的风气味"，且无需新增任何材料。
//   · 效果：若【一口气饮下(并消化满) 5 单位】药剂，饮者会被【传送到其上一次睡觉的地点】。
//   · 产量：30 单位。
//   · 附带：提供预装成品瓶(见 items/custom_potion_bottles.dm)。
//
// 框架(配方基类 /datum/alch_refining_formula、精炼炼药锅、酒基基类)见 refining_framework.dm；
// 本文件只放"回忆药剂"自身所需的三块内容：
//   (A) 记录"上次睡觉地点"的自包含【轮询子系统】(不改动任何核心文件)；
//   (B) 成品试剂 /datum/reagent/memory_potion（消化满 5 单位 → 触发一次传送）；
//   (C) 精炼配方 /datum/alch_refining_formula/memory_potion（气味/底料/产物/技能）。
//
// ★为何用【轮询子系统】记录睡觉地点★：
//   "上次睡觉的地点"必须在【喝药之前】就已经被持续记录下来——否则喝药那一刻无从得知。而睡眠是由核心的
//   /datum/status_effect/incapacitating/sleeping 驱动，其 tick() 定义在 code/…/debuffs.dm(在 modular_z121
//   之外，不可修改)；在本目录重定义同名 tick()/同名过程会"重复定义"而编译报错。因此沿用本项目既有的稳健
//   做法(见 storytellers/god_blessings.dm 的 SSgod_blessings)：自建一个后台子系统，定期【轮询】当前正在
//   睡觉的活体，把其所在格记录为该活体的"上次睡觉地点"。零核心改动、完全自包含。
//
// 遵循项目规则：仅存放于 modular_z121 之下；面向玩家文本一律中文；每段逻辑均以中文注释解释"为何如此"；
//   已在 modular_z121/_load.dm 登记。
// ============================================================================


// --- 可调常量 ---------------------------------------------------------------
// 中文：轮询"谁在睡觉"的间隔。睡眠地点无需秒级精度，10 秒一次足够，开销极低(与 god_blessings 同量级)。
#define MEMORY_POTION_SLEEP_POLL_INTERVAL (10 SECONDS)
// 中文：触发传送所需【已消化】的药量阈值。题面为"5 单位"。
#define MEMORY_POTION_TRIGGER_UNITS 5


// ============================================================================
// (A-1) 在活体上挂一个字段，记录"上次睡觉的地点"。
// ----------------------------------------------------------------------------
// 中文：这是在【本模块文件】里给现成类型 /mob/living 追加一个变量(DM 允许跨文件合并类型定义)，
//   并未修改 modular_z121 之外的任何文件，符合项目铁律。默认 null 表示"从未记录到睡眠"。
//   ——用 /turf 直接引用即可(与核心 dreamwalker 的 linked_turf 同样的做法)；传送前会做有效性校验，
//     万一该格已被 ChangeTurf 替换/失效，则优雅放弃本次传送而不会报错。
// ============================================================================
/mob/living
	// 中文：该活体最近一次"睡觉"所在的地块；由 SSmemory_sleep 子系统在其睡眠期间持续刷新。
	var/turf/memory_potion_last_slept = null


// ============================================================================
// (A-2) 记录睡眠地点的后台轮询子系统 SSmemory_sleep。
// ----------------------------------------------------------------------------
// 中文：每 MEMORY_POTION_SLEEP_POLL_INTERVAL 遍历一次全体活体，凡【正在睡觉】者，就把它当前所在格
//   记为其 memory_potion_last_slept。持续刷新，故最终记录到的即"其睡眠期间(直至醒来)最后所处的地点"，
//   与"上次睡觉的地点"语义一致。
// ============================================================================
SUBSYSTEM_DEF(memory_sleep)
	name = "Memory Sleep Tracker"
	// 中文：仅游戏运行期轮询；SS_BACKGROUND 低优先后台；SS_NO_INIT 无需初始化阶段(与 god_blessings 一致)。
	runlevels = RUNLEVEL_GAME
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = MEMORY_POTION_SLEEP_POLL_INTERVAL
	// 中文：总开关，便于将来按需停用；停用时 fire() 直接空转，绝不影响其它系统。
	var/enabled = TRUE

// 中文：每个轮询周期——把"正在睡觉"的活体的当前所在格，记录为其"上次睡觉的地点"。
/datum/controller/subsystem/memory_sleep/fire(resumed = FALSE)
	// 中文：总开关关闭 → 空转。
	if(!enabled)
		return
	// 中文：防御——全局活体表尚未就绪时什么都不做。
	if(!GLOB.mob_living_list)
		return
	// 中文：遍历所有活体(含无客户端的 NPC——无害；它们通常不会喝药，只是被顺带记录)。
	for(var/mob/living/L in GLOB.mob_living_list)
		// 中文：跳过无效/正在销毁的对象，避免记录到脏引用。
		if(!L || QDELETED(L))
			continue
		// 中文：只在"确实处于睡眠状态"时记录。IsSleeping() 返回其睡眠状态效果(有则真)。
		if(!L.IsSleeping())
			continue
		// 中文：取其当前所在的地块作为睡眠地点。
		var/turf/here = get_turf(L)
		// 中文：地块无效(如恰好不在任何地块上) → 本轮跳过，保留此前已记录的合法地点。
		if(!istype(here))
			continue
		// 中文：刷新记录。睡眠持续期间会被反复覆盖，最终定格在"醒来前最后所处的睡处"。
		L.memory_potion_last_slept = here


// ============================================================================
// (B) 成品试剂：回忆药剂 /datum/reagent/memory_potion。
// ----------------------------------------------------------------------------
// 中文：底料无酒 → 成品为【非酒基】，直接继承普通 /datum/reagent(不走酒基基类)。
//   触发逻辑(题面"一口气饮下 5 单位")落地为本项目既有的稳健写法(参照 gender_swap "消化满 5 单位")：
//   每代谢一拍累加 digested，累计达到 MEMORY_POTION_TRIGGER_UNITS(=5) 且尚未触发过时，执行【一次】传送。
//   （即：需真正摄入并消化满 5 单位，浅尝辄止不足量则不会触发——契合"喝够 5 单位才生效"。）
// ============================================================================
/datum/reagent/memory_potion
	name = "回忆药剂"											// 游戏内名称(Memory Potion)。
	description = "循洁净山风般的气味、以清水与强效魔力药水为底精炼的澄澈药剂。饮下足量后，尘封的睡梦记忆会牵引饮者的身躯，将其送回上一次安睡之处。"	// 风味 + 机制提示。
	reagent_state = LIQUID									// 液态药水。
	color = "#8fb3c7"										// 澄澈的青蓝色。
	taste_description = "清冽的凉意与一缕旧梦的气息"			// 口味风味。
	// 中文：代谢速度——沿用标准值(每拍消化约 metabolization_rate 单位)。以 REAGENTS_METABOLISM 计，
	//   约每 2 秒消化 1 单位，故满 5 单位约 10 秒后触发传送——留出"喝下→回忆涌起→被牵引"的短暂过程感。
	metabolization_rate = REAGENTS_METABOLISM
	// 中文：累计已消化(代谢)的药量；只有累计达阈值才触发，确保"确实喝够并消化了 5 单位"。
	var/digested = 0										// Total amount metabolized so far.
	// 中文：仅触发一次的门闩，防止同一份药反复传送。
	var/teleported = FALSE									// Ensures the teleport happens once.

// 中文：每代谢一拍——累加已消化量；累计满 5 单位且未触发过时，执行一次"回到上次睡处"的传送。
/datum/reagent/memory_potion/on_mob_life(mob/living/carbon/M)
	// 中文：守卫——饮者缺失/正在销毁时，交回父链处理(维持标准代谢流程)后返回。
	if(!M || QDELETED(M))
		return ..()
	// 中文：把本拍代谢掉的量累加进"已消化"计数(按代谢速率近似累加)。
	digested += metabolization_rate							// Accumulate digested amount.
	// 中文：达到阈值且尚未触发 → 触发一次传送(先上门闩，杜绝任何重复)。
	if(!teleported && digested >= MEMORY_POTION_TRIGGER_UNITS)
		teleported = TRUE									// Latch so it never repeats.
		do_memory_teleport(M)								// Perform the "return to last sleep" teleport.
	return ..()

// 中文：执行"传送回上次睡觉的地点"。全程带错误处理：无记录/地点失效/传送失败均【优雅提示、绝不报错】。
/datum/reagent/memory_potion/proc/do_memory_teleport(mob/living/M)
	// 中文：再次守卫饮者有效性(异步/边界情形下的稳妥)。
	if(!M || QDELETED(M))
		return
	// 中文：取出该饮者被子系统记录下来的"上次睡觉地点"。
	var/turf/destination = M.memory_potion_last_slept
	// 中文：★错误处理①★——从无睡眠记录(destination 为 null)：无处可送，给出提示后优雅收场。
	if(isnull(destination))
		to_chat(M, span_warning("你努力回想上一次安睡的地方……却一片空白，药力无处安放，悄然消散。"))
		return
	// 中文：★错误处理②★——记录的地点已失效(被销毁/已不是有效地块，例如该处地形被替换)：同样优雅收场。
	if(QDELETED(destination) || !isturf(destination))
		to_chat(M, span_warning("那段睡梦的记忆已然模糊、无从指引，药力悄然消散。"))
		return
	// 中文：施放前的感官铺垫——本人视角与旁观者各一段应景提示。
	to_chat(M, span_notice("一段安睡的记忆自脑海深处涌起，你的身躯随之被温柔地牵引……"))
	M.visible_message(span_warning("[M]的身影在一阵朦胧中淡去，仿佛被什么悄然带走了。"))
	// 中文：执行传送。用 do_teleport(魔法通道)带默认的进出特效/音效；其返回布尔值表示是否成功。
	//   ★错误处理③★——传送失败(如目标格被完全堵死/跨界受阻)时，据返回值给出失败提示，绝不静默出错。
	if(do_teleport(M, destination, channel = TELEPORT_CHANNEL_MAGIC))
		M.visible_message(span_warning("[M]凭空出现，神情恍惚，像是刚从一场梦中醒来。"))
		to_chat(M, span_notice("你回到了上一次安睡的地方。"))
	else
		to_chat(M, span_warning("回忆的牵引半途受阻，你终究没能回到那处睡梦之地。"))


// ============================================================================
// (C) 精炼配方 /datum/alch_refining_formula/memory_potion。
// ----------------------------------------------------------------------------
// 中文：★按气味等级(气味档①)★——【5 级"洁净的风"气味】+ 复合底料(清水 70 + 强效魔力药水 30) → 回忆药剂。
//   · "洁净的风"是原版【强效耐力灵药 big_stamina_potion】的 smells_like，且经核对【尚未被本模块任何精炼
//     配方占用】，满足题面"任取一种未使用的等级5气味"。
//   · 带此气味的现成材料(major=3，气味指向 big_stamina_potion)：种子粉 / 炼金奥兹姆 / 圣蓟；
//     任取两味同投即 6 点 >= 5，满足"5 级洁净的风气味"——全程不新增任何材料。
//   · 底料"清水 70 + 强效魔力药水 30"均为现成试剂、无酒 → 成品为非酒基。
// ============================================================================
/datum/alch_refining_formula/memory_potion
	name = "回忆药剂"										// 配方名。
	// 中文：★气味档①★ 要求"洁净的风"气味累计达到 5 点(即"5 级洁净的风气味")。不镜像任何现成配方。
	required_scent = "洁净的风"								// Require the (unused) "clean wind" scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★复合底料★ 清水 70 + 强效魔力药水 30(= 70 water + 30 strong mana potion)；均为现成试剂、无酒。
	required_base = list(/datum/reagent/water = 70, /datum/reagent/medicine/strongmana = 30)	// 70 water + 30 strong mana potion.
	// 中文：产物——30 单位回忆药剂(题面指定产量)。
	output_reagents = list(/datum/reagent/memory_potion = 30)	// Refined output (30 units).
	// 中文：所需技能——炼金 5 级(大师)，对应题面 Alchemy-Level5。
	skill_required = SKILL_LEVEL_MASTER						// Alchemy level 5 gate.
	// 中文：成功气味词。
	smells_like = "洁净山风与旧梦"							// Success scent.


// 中文：清理本文件作用域内的局部宏，避免泄漏到全局编译环境。
#undef MEMORY_POTION_SLEEP_POLL_INTERVAL
#undef MEMORY_POTION_TRIGGER_UNITS
