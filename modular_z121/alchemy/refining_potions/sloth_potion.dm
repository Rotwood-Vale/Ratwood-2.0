// ============================================================================
// 怠惰药水 (Potion of Sloth) —— 一味【精炼药剂(非酒·毒药基)】
// ----------------------------------------------------------------------------
// 中文总览（为什么这样设计 / 如何落实）：
//   触发(气味)：★5 级"清新的空气"气味★。"清新的空气"是原版【疾行药水】(spd_potion)配方的 smells_like，
//               此前【尚无任何自定义精炼药剂占用】，符合题面"任取一种未被占用的自定义药水(5 级)气味"的要求。
//               ★为什么偏偏选它★：这是一个刻意的【反讽】取材——用一味【加速/敏捷】药水的气味，去精炼出一味
//               【令人怠惰、连动作都懒得做】的药水，气味与药效在主题上形成强烈反差，恰如"愚人药水"取用"智力
//               药剂(锐思药剂)的气味"那样别有意趣。
//               现实可达性：ingredients.dm 中【风之精质(airdust)】的 major_pot 指向 spd_potion(3 点)、
//               【小米草(euphrasia)】的 major_pot 亦指向 spd_potion(3 点)，二者同投即得 3+3=6 ≥ 5，稳定凑齐
//               "5 级清新的空气"气味(须为不同类型，原版禁止重复投料)，玩家可复现，且无需新增任何材料。
//   液体底料：清水 50 + 板油(tallow/leaf lard) 20 + 毒药(berrypoison) 30(题面"50 水 + 20 板油 + 30 毒药")。
//             三者皆为现成试剂、且都不含酒 → 成品为【非酒基】药剂(直接继承 /datum/reagent，不携带 boozepwr)。
//             ★注意★ has_reagent 判定为【精确类型】，故底料须写成具体产出类型(如 /datum/reagent/berrypoison)。
//   技能要求：炼金 5 级(SKILL_LEVEL_MASTER 大师)——即题面"Alchemy-Level5"。技能不足则整锅腐坏(框架 spoil_batch)。
//   产物：30 单位怠惰药水。
//   消化速度：每单位 9 秒(故 30 单位 ≈ 270 秒 ≈ 4.5 分钟的持续药效)。
//
//   ★效果——"懒得动"(题面)★，只在药剂尚在体内代谢期间生效，共分四项(前两项为常驻，后两项互为得失)：
//     (A) 【动作有几率被懒掉】：每一次主动动作(攻击/拾取/使用物品/点选式施法……任何鼠标点击动作)都有一定几率被
//         "懒过去"——动作直接不执行，取而代之，角色会有气无力地嘟囔出一句慵懒之言，例如
//         "好累啊……光是活着就已经很累了，什么都不想做……"。
//     (B) 【移动变慢】(常驻代价)：整段药效期间移动速度下降。
//     (C) 【读条动作变慢】(常驻代价)：任何涉及"读条(进度条)"的动作(采集/制作/施法引导等 do_after)耗时增加。
//     (D) 【静养自愈】(收益，需换取)：若一段时间【什么都不做】(既不移动也不点击操作)，则伤势缓慢恢复，
//         饥饿与口渴亦随之补充；但只要再度移动/操作，休憩即被打断、需重新静止累积。
//
//   ★为什么用这些引擎机制来"真正落实"上述效果(而非另造系统)★：
//     · (A) "任何主动动作有几率被跳过"——监听 COMSIG_MOB_CLICKON 信号。该信号在 /mob/ClickOn 最前端(click.dm)
//       发出、早于一切攻击/拾取/使用/点选施法的分发；在回调里以 prob(几率) 掷骰，命中则返回
//       COMSIG_MOB_CANCEL_CLICKON —— 这条点击(以及它背后的那次动作)被【整单取消】，恰好实现"这次动作被懒掉了"。
//       未命中则不返回取消标记，动作照常执行。这样"有几率跳过"就精确落在了【每一次动作】的入口上。
//       "取而代之嘟囔一句懒话"——命中跳过时让角色 say() 出一句慵懒之言(众人可闻)。★为何用 INVOKE_ASYNC★：
//       信号回调带 SIGNAL_HANDLER、必须【非睡眠】(SHOULD_NOT_SLEEP)，而 say() 可能睡眠；故 say() 丢进
//       INVOKE_ASYNC 异步执行，既不阻塞信号回调、又能把懒话说出口。
//     · (B) "移动变慢"——add_movespeed_modifier(专属 id, multiplicative_slowdown>0)。整段药效常驻，结束时以同 id
//       remove_movespeed_modifier 精确移除。
//     · (C) "读条变慢"——do_after() 会把延时乘以 user.do_after_coefficent()，而人类的该系数又乘以
//       physiology.do_after_speed(默认 1，越大越慢)。故按引擎注释"临时调整只用 *= / /="的规范：进入时 *= 因子、
//       离开时 /= 因子，即让一切读条动作按比例变慢，且精确还原。(physiology 为人类专有，故本项仅对人类生效。)
//     · (D) "静养自愈"——以"距上次活动(移动/点击)多久"衡量闲置：注册 COMSIG_MOVABLE_MOVED(移动打卡)并复用
//       (A)的点击回调(点击打卡)来刷新"上次活动时刻"；每代谢拍若静止已超过闲置门槛，则用引擎既有 API
//       heal_overall_damage(回钝/烧伤)+adjust_nutrition(补食)+adjust_hydration(补水)真正落实缓慢回复。
//     · ★为何【不】拦截键盘移动★——移动不经 ClickOn，天然不受(A)拦截影响；"懒得动手做事、但还能挪动脚步(只是变慢)"
//       更贴合"怠惰"的意象(不是瘫痪)，也与本模块既有拦截(气化之躯/麻痹毒药)"只拦点击、放行移动"的做法一脉相承。
//
//   框架见 refining_framework.dm；成品瓶见 items/custom_potion_bottles.dm。
//   本药【非酒基】(底料为水/板油/毒药、无任何乙醇)，故成品为普通 /datum/reagent，不携带 boozepwr。
//   本文件全部内容位于 modular_z121 之下，符合项目硬性约束。
// ============================================================================


// ----------------------------------------------------------------------------
// 中文：★消化速度常量★——题面要求【每 1 单位 9 秒】。生命循环(SSmobs, wait=20)每 2 秒触发一次 on_mob_life，
//   每次移除 metabolization_rate 单位；故"每单位耗时(秒) = 2 ÷ metabolization_rate"。要 9 秒/单位 ⇒
//   metabolization_rate = REAGENTS_METABOLISM(=1) × 2 ÷ 9 = 2/9 ≈ 0.2222。抽为宏，便于日后统一调参。
// ----------------------------------------------------------------------------
#define SLOTH_POTION_SECONDS_PER_UNIT 9					// Digest one unit every 9 seconds.

// ----------------------------------------------------------------------------
// 中文：★动作被"懒掉"的几率(百分比)★——题面为"有几率被跳过"，此处取 40%，即每次主动点击动作约四成概率被懒过去。
//   抽为宏，逻辑与文案共用一个真值来源，便于日后统一调参(想更懒就调高，想没那么懒就调低)。
// ----------------------------------------------------------------------------
#define SLOTH_POTION_SKIP_CHANCE 40						// 40% chance any given click-action is skipped ("too lazy").

// ----------------------------------------------------------------------------
// 中文：★嘟囔懒话的防刷屏冷却(仅作用于"说话"这一表现，绝不影响"跳过"本身)★——玩家狂点时，"跳过动作"每次都照常
//   判定生效，但"说出懒话"最多每 SLOTH_POTION_MUTTER_COOLDOWN 才来一句，避免瞬间刷出成排重复台词而扰乱聊天/日志。
//   略大于代谢拍(2 秒)与人正常连点的节奏即可。
// ----------------------------------------------------------------------------
#define SLOTH_POTION_MUTTER_COOLDOWN (2 SECONDS)			// Throttle only the spoken line (never the skip itself).

// ----------------------------------------------------------------------------
// 中文：★持续性副作用——移动减速★。用户要求"移动速度会下降"。以 add_movespeed_modifier 施加一个乘法减速值
//   (数值为正=更慢)。取 1.5，属"明显变慢但不至于寸步难行"的量级(参考：网困=3、臣服=4、受伤减速=1.5)。整段药效期间常驻。
// ----------------------------------------------------------------------------
#define SLOTH_POTION_MOVE_SLOWDOWN 1.5					// Constant movement slowdown while the potion lasts (higher = slower).

// ----------------------------------------------------------------------------
// 中文：★持续性副作用——一切"读条动作"变慢★。用户要求"任何涉及读条(进度条)的动作都会变慢"。do_after() 会把延时
//   乘以 user.do_after_coefficent()，而人类的该系数又乘以 physiology.do_after_speed(默认 1，越大越慢)。故按引擎注释
//   "临时调整请只用 *= 与 /="的规范，进入时 *=、离开时 /= 本系数即可。取 1.5，即所有读条动作耗时增加约 50%。整段药效常驻。
// ----------------------------------------------------------------------------
#define SLOTH_POTION_DO_AFTER_FACTOR 1.5				// Constant do_after/progress-bar slowdown factor (multiplies physiology.do_after_speed).

// ----------------------------------------------------------------------------
// 中文：★"发呆够久才回复"的闲置门槛★。用户要求"若一段时间什么都不做，则伤势缓慢恢复、饥渴也随之补充"。
//   以"距上次活动(移动 或 任何点击动作)已过去多久"衡量；累计静止达本门槛(6 秒)后，才开始每拍缓慢回复。
//   任何移动/点击都会把这个"上次活动时刻"刷新，从而中断休憩、需重新静止累积。
// ----------------------------------------------------------------------------
#define SLOTH_POTION_IDLE_THRESHOLD (6 SECONDS)			// Must be idle this long before idle-regen kicks in.

// ----------------------------------------------------------------------------
// 中文：★闲置回复量(每代谢拍，仅在已达闲置门槛时生效)★——分别是：钝/烧伤各回复量、饥饿(nutrition)与口渴(hydration)补充量。
//   nutrition/hydration 量程为 0-1000、每拍自然消耗约 HUNGER_FACTOR(0.15)，故 +15/拍属"静养时明显回涨"；
//   伤势每拍回 2 点钝伤+2 点烧伤(满血 100)≈ 每秒回 1 点混合伤，属"缓慢恢复"。均抽为宏，便于统一调参。
// ----------------------------------------------------------------------------
#define SLOTH_POTION_IDLE_HEAL 2						// Brute & burn healed per tick while idle-resting.
#define SLOTH_POTION_IDLE_NUTRITION 15					// Nutrition (food) restored per idle tick.
#define SLOTH_POTION_IDLE_HYDRATION 15					// Hydration (water) restored per idle tick.


// ============================================================================
// 成品试剂——怠惰药水。非酒基 → 直接继承 /datum/reagent(不走酒基 refined_potion 基类)。
//   设计：效果与药剂"同生共死"——代谢开始注册点击拦截、代谢期间持续生效、代谢结束精确注销。
// ============================================================================
/datum/reagent/sloth_potion
	name = "怠惰药水"											// In-game name (Potion of Sloth).
	// 中文：检视/说明文本——点明气味来源(疾行药水之"清新的空气")、底料(水/板油/毒药精炼)、以及"动作有几率被懒掉"的功效。
	description = "一瓶循'清新的空气'之气(本是疾行药水的气息)、以清水、板油与毒液精炼而成的粘稠浊浆，色泽昏沉、气味慵倦，仿佛连流动都嫌费劲。饮下后一股深入骨髓的倦怠会缓缓弥漫开来，令人四体发懒、意兴阑珊——伸手做事到一半便再也懒得动弹，只想有气无力地嘟囔一句'太累了'；手脚发沉，走得更慢，做起需要耐心的活计也格外拖沓。可若索性什么都不做、静静歇上一阵，倦怠反倒化作慵懒的休憩，让伤势慢慢愈合、饥渴悄然缓解。"	// Flavour + mechanic hint.
	reagent_state = LIQUID									// Drinkable liquid potion.
	color = "#726b57"										// Dull, drowsy greyish-brown (a listless, sluggish hue).
	taste_description = "一口粘腻、沉滞，尾韵是化不开的困倦与懒意"	// Taste flavour (heavy, drowsy, listless).
	// 中文：半透明显示，与其它自定义药水观感统一。
	alpha = 200												// Slight transparency, matching other potions.
	// 中文：★消化速度★= 每单位 9 秒(见上方宏推导)：REAGENTS_METABOLISM(=1) × 2 / 9 = 2/9 单位/拍。
	metabolization_rate = REAGENTS_METABOLISM * 2 / SLOTH_POTION_SECONDS_PER_UNIT	// 2/9 u per 2s-tick = 9s per unit.

	// 中文：★点击拦截是否已注册★——一次性守卫，保证"注册信号"只做一次、"注销信号"只在注册过时做一次，
	//   防止代谢重入导致重复注册抛错、或未注册就误注销。
	var/laziness_active = FALSE								// One-shot guard: did WE register the click-cancel handler?
	// 中文：★下一次允许"嘟囔懒话"的时刻★——用于给"说话"这一表现做轻量防刷屏(见 SLOTH_POTION_MUTTER_COOLDOWN)。
	//   注意：它只节流"说话"，绝不节流"跳过动作"——跳过每次都照常判定。
	var/next_mutter = 0										// world.time gate for the throttled spoken line (skip is never throttled).
	// 中文：★是否已施加"移动减速"修饰★——一次性守卫，保证减速只加一次、只移除一次(add/remove_movespeed_modifier 成对)。
	var/move_slowed = FALSE									// Did WE add the movespeed modifier?
	// 中文：★是否已施加"读条变慢"(physiology.do_after_speed *= 因子)★——仅人类有 physiology；用它决定离开时是否要 /= 还原。
	var/do_after_slowed = FALSE								// Did WE multiply physiology.do_after_speed (human only)?
	// 中文：★上次"活动"的时刻(world.time)★——移动 或 任何点击动作都会刷新它。用于判定"静止是否已够久可开始休憩回复"。
	var/last_activity = 0									// world.time of the last movement/click (idle timer baseline).
	// 中文：★是否正处于"休憩回复"态★——用于只在"刚进入静养"时给一次提示、"一动就打断"时再给一次提示，避免每拍刷屏。
	var/resting = FALSE										// Are we currently in the idle-regeneration state?

// ----------------------------------------------------------------------------
// 中文：点击拦截信号处理器——这是本药水的效果核心。每一次主动点击动作(攻击/拾取/使用/点选式施法…)进来时，
//   以 prob(SLOTH_POTION_SKIP_CHANCE) 掷骰：命中→取消这次动作(即"懒掉了")并(节流地)嘟囔一句懒话；未命中→放行。
//   COMSIG_MOB_CLICKON 在 /mob/ClickOn 最前端发出(先于一切分发)，返回 COMSIG_MOB_CANCEL_CLICKON 即整单取消。
// WHY SIGNAL_HANDLER: 信号回调必须是非睡眠过程；此处仅做掷骰/取消/异步触发说话，符合 SHOULD_NOT_SLEEP。
// ----------------------------------------------------------------------------
/datum/reagent/sloth_potion/proc/lazy_click_filter(mob/source, atom/target, params)
	SIGNAL_HANDLER											// Must not sleep — dice roll + cancel + async speak only.
	// 中文：错误处理——极端情形下 source 可能缺失/正被删除，则不干预这次点击(放行)，避免对无效对象操作而报错。
	if(!source || QDELETED(source))							// No valid actor.
		return												// Don't cancel — let it pass through untouched.
	// 中文：★活动打卡★——只要玩家尝试点击(无论最终是否被懒掉)，就算作"在活动"，刷新闲置计时(会打断休憩回复)。
	last_activity = world.time								// Any click attempt counts as activity (breaks idle-rest).
	// 中文：掷骰——未命中(约 100-40=60% 情形)则不返回取消标记，动作照常执行。
	if(!prob(SLOTH_POTION_SKIP_CHANCE))						// Not lazy this time.
		return												// Allow the action (no cancel flag).
	// 中文：命中——这次动作被"懒掉"。先(节流地)嘟囔一句懒话，再返回取消标记把动作整单取消。
	if(world.time >= next_mutter)							// Spoken-line throttle window open?
		next_mutter = world.time + SLOTH_POTION_MUTTER_COOLDOWN	// Arm the throttle (throttles the LINE, not the skip).
		// 中文：say() 可能睡眠，而本回调不得睡眠——故异步说出懒话(不阻塞信号回调)。
		INVOKE_ASYNC(src, PROC_REF(utter_lazy_phrase), source)	// Speak the lazy line asynchronously.
	return COMSIG_MOB_CANCEL_CLICKON						// Cancel this action entirely ("too lazy to do it").

// ----------------------------------------------------------------------------
// 中文：嘟囔一句慵懒之言——由 lazy_click_filter 在"动作被跳过"时异步调用。从一组懒话里随机取一句让角色说出(众人可闻)。
//   ignore_spam = TRUE：这是刻意的剧情表现，不应被 say 的防刷屏机制吞掉(真正的防刷屏由上面的 next_mutter 冷却负责)。
// ----------------------------------------------------------------------------
/datum/reagent/sloth_potion/proc/utter_lazy_phrase(mob/living/M)
	// 中文：错误处理——目标缺失/正被删除，或已无法说话(非 living)则直接返回，避免对无效对象调用 say 而报错。
	if(!M || QDELETED(M) || !isliving(M))					// No valid speaker.
		return
	// 中文：慵懒台词库——含题面示例那句，其余为同主题的"懒得动"之言，随机取一句以免千篇一律。
	//   (放在过程内的局部列表即可：仅在"被跳过"时才构建，开销可忽略。)
	var/list/lazy_phrases = list(							// Pool of lazy mutterings (incl. the spec's example line).
		"好累啊……光是活着就已经很累了，什么都不想做……",		// The example line from the spec.
		"唔……等会儿再说吧，现在一点都不想动……",
		"算了算了……这种事……有什么意义呢……",
		"手指头都懒得抬一下……让我再歇会儿……",
		"啊——好困……做这些也太麻烦了……",
		"不想动……真的一点都不想动……"
	)
	// 中文：让角色把懒话说出口(众人可闻)；ignore_spam=TRUE 确保这句刻意的表现不被防刷屏吞掉。
	M.say(pick(lazy_phrases), ignore_spam = TRUE)			// Utter a lazy line for all to hear.

// ----------------------------------------------------------------------------
// 中文：移动打卡信号处理器——只要饮用者【移动】了(COMSIG_MOVABLE_MOVED 在 atom/movable/Moved 最底层发出)，
//   就刷新"上次活动时刻"，从而打断"休憩回复"(必须重新静止累积够 SLOTH_POTION_IDLE_THRESHOLD 才会再次回复)。
// WHY SIGNAL_HANDLER: 信号回调必须是非睡眠过程；此处仅记录一个时刻，符合 SHOULD_NOT_SLEEP。
// ----------------------------------------------------------------------------
/datum/reagent/sloth_potion/proc/on_moved(atom/movable/source, atom/old_loc, dir)
	SIGNAL_HANDLER											// Must not sleep — just stamp the activity time.
	last_activity = world.time								// Movement counts as activity (breaks idle-rest).

// ----------------------------------------------------------------------------
// 中文：施加"怠惰"效果——注册点击拦截信号。以 laziness_active 作一次性守卫，防止代谢重入导致重复注册。
//   仅对有效 /mob/living 施加(点击/动作系统作用于 mob)。
// ----------------------------------------------------------------------------
/datum/reagent/sloth_potion/proc/apply_laziness(mob/living/M)
	// 中文：错误处理——目标缺失/正被删除 → 直接返回，避免对无效对象操作而运行时报错。
	if(!M || QDELETED(M))									// No valid drinker.
		return
	// 中文：错误处理——本效果只对 /mob/living 有意义(ClickOn/动作分发都在 mob 层)；非 living 无从承载，
	//   给出诚实提示后照常代谢、不施加效果。
	if(!isliving(M))										// Effect only applies to living mobs.
		to_chat(M, span_warning("怠惰药水在体内空流转，却找不到可供慵懒的躯体。"))	// Honest non-living notice.
		return
	// 中文：一次性守卫——已注册则不重复注册。
	if(laziness_active)										// Already applied for this potion instance.
		return
	laziness_active = TRUE									// Latch: from now on we own the registered handler.
	// 中文：注册点击拦截。override=TRUE 防御性避免"同源同信号重复注册"抛错(极端重入场景)。
	RegisterSignal(M, COMSIG_MOB_CLICKON, PROC_REF(lazy_click_filter), override = TRUE)	// Gate every click through the laziness roll.

	// ---- ★持续性副作用①：移动减速★（整段药效常驻，不受闲置与否影响） ----
	// 中文：施加移动减速修饰。priority=100、override=TRUE 保证稳定生效且不与自身旧值冲突。用专属 id 便于精确移除。
	if(!move_slowed)										// Add exactly once.
		M.add_movespeed_modifier("sloth_potion", update = TRUE, priority = 100, override = TRUE, multiplicative_slowdown = SLOTH_POTION_MOVE_SLOWDOWN)	// Sluggish movement.
		move_slowed = TRUE									// Remember we added it (for symmetric removal).

	// ---- ★持续性副作用②：读条动作变慢★（整段药效常驻；仅人类有 physiology） ----
	// 中文：按引擎注释"临时调整只用 *= / /="的规范放慢一切 do_after 读条；一次性守卫确保只乘一次，离开时只除一次。
	if(!do_after_slowed && ishuman(M))						// Only humans have physiology; apply once.
		var/mob/living/carbon/human/H = M					// Typed handle for physiology.
		if(H.physiology)									// Safety: physiology must exist.
			H.physiology.do_after_speed *= SLOTH_POTION_DO_AFTER_FACTOR	// Slow every progress-bar action (higher = slower).
			do_after_slowed = TRUE							// Remember so we divide it back on removal.

	// ---- ★闲置回复的活动追踪★：登记移动打卡信号，并把"上次活动时刻"初始化为现在(饮下瞬间不算已静止) ----
	// 中文：注册移动信号以打断休憩；last_activity 置为当前时刻，令玩家须"饮后再静止够久"方能开始回复。
	RegisterSignal(M, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved), override = TRUE)	// Movement breaks idle-rest.
	last_activity = world.time								// Start the idle timer from now.
	resting = FALSE											// Not resting yet (must idle past the threshold first).

	// 中文：施加成功的文字反馈(纯提示，不影响机制)——点明"变懒/变慢"，并暗示"静养可自愈"。
	M.visible_message(span_warning("[M]的动作慢了下来，脚步也变得沉重拖沓，眼神开始涣散，仿佛突然什么都懒得做了。"), \
					span_userdanger("一股深入骨髓的倦怠感涌了上来——你手脚发沉、做什么都慢半拍，只想瘫着不动……不过，若能就这样静静歇上一会儿，倒似乎能让身子慢慢缓过来。"))	// Onset feedback (hints at idle-rest).

// ----------------------------------------------------------------------------
// 中文：解除"怠惰"效果——精确注销我们注册过的点击拦截(只撤销自己加的部分)，恢复正常。
// ----------------------------------------------------------------------------
/datum/reagent/sloth_potion/proc/remove_laziness(mob/living/M)
	// 中文：一次性守卫——未注册则无需注销(防止重复注销)。
	if(!laziness_active)									// Nothing was registered / already reverted.
		return
	laziness_active = FALSE									// Un-latch.
	// 中文：★读条变慢的还原★——即便 mob 已失效，也应尽力把 physiology 上的乘数除回去(它可能仍存活)；故不在无效时早退，
	//   而是各项各自判空还原，确保"我们加的东西都被精确撤销"。
	// ---- 还原①：读条变慢(physiology.do_after_speed /= 因子；与施加处的 *= 严格成对) ----
	if(do_after_slowed)										// We had multiplied it.
		do_after_slowed = FALSE								// Un-latch first (avoid double-restore).
		if(M && ishuman(M))									// Still a human with physiology?
			var/mob/living/carbon/human/H = M				// Typed handle.
			if(H.physiology)								// Physiology still present?
				H.physiology.do_after_speed /= SLOTH_POTION_DO_AFTER_FACTOR	// Exactly undo the *= (progress bars normal again).

	// 中文：错误处理——目标缺失/正被删除 → 其余基于 mob 的注销/移除已无对象可作用；点击/移动信号会随本 reagent 被
	//   qdel 时由信号系统自动清理，故直接返回即可(上面的 do_after 还原已尽力完成)。
	if(!M || QDELETED(M))									// Nothing more to unregister on an invalid mob.
		return
	// 中文：注销点击拦截，动作(攻击/拾取/使用/施法)恢复正常、不再被懒掉。
	UnregisterSignal(M, COMSIG_MOB_CLICKON)					// Clicks act normally again.
	// 中文：注销移动打卡信号(闲置追踪结束)。
	UnregisterSignal(M, COMSIG_MOVABLE_MOVED)				// Stop tracking movement for idle-rest.
	// ---- 还原②：移动减速(移除专属 id 的 movespeed 修饰) ----
	if(move_slowed)											// We had added the slowdown.
		M.remove_movespeed_modifier("sloth_potion")			// Movement speed back to normal.
		move_slowed = FALSE									// Reset bookkeeping.

// 中文：代谢开始时(每"一份"药剂仅触发一次)——校验目标后注册点击拦截，令怠惰效果生效。
/datum/reagent/sloth_potion/on_mob_metabolize(mob/living/M)
	. = ..()												// Let the base reagent set up first.
	// 中文：错误处理——目标无效则不施加效果(避免对无效对象操作报错)；apply_laziness 内部亦有守卫。
	if(!M || QDELETED(M))									// No valid drinker.
		return
	apply_laziness(M)										// Register the click-cancel laziness handler.

// 中文：每代谢一拍——① 补挂点击拦截(极少数首拍未挂上的兜底，apply_laziness 有守卫故可安全重复调用)；
//   随后交给父类扣减用量并推进代谢。(拦截是信号，一次注册即持续存在，无需每拍重复注册——守卫会挡掉重复。)
/datum/reagent/sloth_potion/on_mob_life(mob/living/carbon/M)
	// 中文：错误处理——目标缺失/正被删除 → 跳过补挂，仍交给父类收尾以保持代谢推进(否则药剂会卡住不减少)。
	if(!M || QDELETED(M))									// Guard against a missing/deleting mob.
		return ..()
	// 中文：仅对有效 living 兜底补挂(若初次未挂上)；已挂上时守卫会直接返回，不会重复注册。
	if(isliving(M) && !laziness_active)						// Handler somehow not attached yet?
		apply_laziness(M)									// Attach it now (idempotent via the guard).
	// 中文：★闲置回复★——若"距上次活动"已达闲置门槛，则本拍缓慢回复伤势、并补充饥饿与口渴；一旦玩家再动(移动/点击)，
	//   last_activity 会被刷新、条件不再满足，回复即刻中断。仅对有效 living 生效。
	if(isliving(M))											// Only living mobs can rest & recover.
		handle_idle_rest(M)									// Do the idle-gated regeneration bookkeeping.
	return ..()												// Standard metabolism (consumes metabolization_rate, decrements volume).

// ----------------------------------------------------------------------------
// 中文：闲置回复处理——每代谢拍调用。判断"是否已静止够久"：
//   · 达门槛 → 进入/维持"休憩"态：缓慢回复钝/烧伤、补充饥饿(nutrition)与口渴(hydration)；首次进入时给一次提示。
//   · 未达门槛(刚动过) → 若此前在休憩，则退出休憩态并给一次"被打断"的提示。
// 所有回复都用引擎既有 API 真正落实(heal_overall_damage / adjust_nutrition / adjust_hydration)，非空转。
// ----------------------------------------------------------------------------
/datum/reagent/sloth_potion/proc/handle_idle_rest(mob/living/M)
	// 中文：错误处理——目标失效则不处理(调用方已判 living，这里再兜底一层防删除竞态)。
	if(!M || QDELETED(M))									// Guard against a vanishing mob.
		return
	// 中文：计算静止时长(自上次移动/点击起)。达到门槛才回复。
	var/idle_for = world.time - last_activity				// How long since last activity.
	if(idle_for < SLOTH_POTION_IDLE_THRESHOLD)				// Not idle long enough yet.
		// 中文：刚动过——若此前正在休憩，则退出休憩态并提示"被打断"(仅切换时提示一次，避免刷屏)。
		if(resting)											// Was resting, now interrupted by activity.
			resting = FALSE									// Leave the rest state.
			to_chat(M, span_notice("你一动，那份慵懒的静谧便散了，身体也停下了自我修复。"))	// Interruption notice (once).
		return
	// 中文：已静止够久——进入/维持休憩态。首次进入时给一次"开始静养自愈"的提示。
	if(!resting)											// Just crossed into the rested state.
		resting = TRUE										// Enter the rest state.
		to_chat(M, span_notice("你彻底松弛下来，什么也不做的慵懒里，身体正一点点缓慢地自我修复、饥渴也悄然缓解……"))	// Onset-of-rest notice (once).
	// ---- 真正落实回复：伤势 + 饥饿 + 口渴 ----
	// 中文：伤势缓慢恢复——回复钝伤与烧伤各 SLOTH_POTION_IDLE_HEAL 点(heal_overall_damage 会自动更新血量)。
	M.heal_overall_damage(brute = SLOTH_POTION_IDLE_HEAL, burn = SLOTH_POTION_IDLE_HEAL)	// Slowly mend injuries.
	// 中文：饥饿(食)与口渴(水)补充——adjust_nutrition/adjust_hydration 是 /mob 通用 API，正值即补充。
	M.adjust_nutrition(SLOTH_POTION_IDLE_NUTRITION)			// Replenish food need.
	M.adjust_hydration(SLOTH_POTION_IDLE_HYDRATION)			// Replenish water need.

// 中文：代谢结束(药剂耗尽/被清除)时——精确注销点击拦截(只撤销我们加过的部分)，恢复正常，并给出"倦意退去"的提示。
/datum/reagent/sloth_potion/on_mob_end_metabolize(mob/living/M)
	// 中文：仅对有效目标注销并反馈(remove_laziness 内部亦有守卫)。
	if(M && !QDELETED(M))									// Valid target?
		var/was_active = laziness_active					// Remember whether we actually had the handler attached.
		remove_laziness(M)									// Unregister our click-cancel handler (only our own addition).
		if(was_active)										// Only message if the laziness was actually in effect.
			to_chat(M, span_notice("那股深重的倦怠感如退潮般散去，你的手脚重新听使唤了，又愿意动起来了。"))	// Recovery feedback.
	return ..()												// Let the base finish up (final volume cleanup, etc.).


// ============================================================================
// 精炼配方：★按气味等级(气味档①)★ —— 5 级"清新的空气"气味 + 底料(水50 + 板油20 + 毒药30) → 怠惰药水 30。技能：大师(炼金 5 级)。
// ----------------------------------------------------------------------------
// 中文：
//   · "清新的空气"是【疾行药水(spd_potion)】配方的气味，且未被其它精炼配方占用(题面要求"未使用的 5 级气味")。
//     带此气味、指向 spd_potion 的现成材料有：风之精质(airdust, major=3)、小米草(euphrasia, major=3)、
//     焦尘粉(feaudust, major=3)、荨麻(urtica, med=2)、缬草(valeriana, med=2)、艾蒿(artemisia, med=2)、
//     西池烟叶粉(tobaccodust, minor=1)…… 取【风之精质 + 小米草】即 3+3=6 ≥ 5，稳定满足"5 级清新的空气"气味
//     (两种不同材料，符合原版禁止重复投料的规则)，玩家可复现、且无需新增任何材料。
//   · 底料用【现成试剂】：清水 50 + 板油(tallow) 20 + 毒药(berrypoison) 30。三者均非乙醇，故成品【非酒基】，
//     output 直接注入普通试剂、不携带 boozepwr。
//   · ★注意★ has_reagent 判定为【精确类型】，故底料须写成具体产出类型(水/板油/毒药皆为具体可产出试剂)。
//   · ★煮沸阈值★：本配方底料合计 50+20+30 = 100 单位，远超精炼锅的起沸下限 waterneed(60，见 refining_framework.dm)，
//     可正常起沸熬制，无需额外改动。
// ============================================================================
/datum/alch_refining_formula/sloth_potion
	name = "怠惰药水"										// Formula name.
	// 中文：★气味档①★ 要求"清新的空气"气味累计达到 5 点(即题目的"5 级未使用气味")。
	required_scent = "清新的空气"							// Require the "fresh air" scent (spd_potion's smell, unused)...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points; airdust 3 + euphrasia 3 = 6).
	// 中文：★复合底料★ 清水 50 + 板油(tallow) 20 + 毒药(berrypoison) 30(现成试剂；无酒 → 成品非酒基)。
	required_base = list(/datum/reagent/water = 50,			// 50 water.
						/datum/reagent/consumable/oil/tallow = 20,	// 20 leaf lard (tallow).
						/datum/reagent/berrypoison = 30)	// 30 poison (berrypoison).
	// 中文：产物——30 单位怠惰药水(单批产出 30)。
	output_reagents = list(/datum/reagent/sloth_potion = 30)	// Refined output: 30u Potion of Sloth.
	// 中文：所需技能——大师(炼金 5 级，SKILL_LEVEL_MASTER == 5)。技能不足则整锅腐坏(框架 spoil_batch 处理)。
	skill_required = SKILL_LEVEL_MASTER						// Alchemy Level 5 (Master) gate.
	// 中文：成功时的气味词。
	smells_like = "教人昏昏欲睡的慵倦浊气"					// Success scent.


// 中文：清理本文件作用域内的局部宏，避免它们泄漏到全局编译环境、与他处同名定义冲突。
#undef SLOTH_POTION_SECONDS_PER_UNIT
#undef SLOTH_POTION_SKIP_CHANCE
#undef SLOTH_POTION_MUTTER_COOLDOWN
#undef SLOTH_POTION_MOVE_SLOWDOWN
#undef SLOTH_POTION_DO_AFTER_FACTOR
#undef SLOTH_POTION_IDLE_THRESHOLD
#undef SLOTH_POTION_IDLE_HEAL
#undef SLOTH_POTION_IDLE_NUTRITION
#undef SLOTH_POTION_IDLE_HYDRATION
