// ============================================================================
// 气化之躯药水 (Gasification Body Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文总览（为什么这样设计）：
//   触发(气味)：★5 级"停滞的空气"气味★。"停滞的空气"是原版【强效耐力毒药】(big_stam_poison)
//               配方的 smells_like，此前【尚无任何自定义精炼药剂占用】，符合题面"任取一种未被
//               占用的(5 级)气味"的要求；且"停滞/凝滞的空气"这一意象与"化作雾气之躯"高度契合。
//               带该气味且指向 big_stam_poison 的现成材料有：重楼(paris)[major,3]、地狱尘
//               (infernaldust)[med,2]、矿物粉(mineraldust)[minor,1]。例：重楼(3)+地狱尘(2)=5，
//               恰好达成 5 级气味门槛(须为不同类型，原版禁止重复投料)。全程不新增任何材料。
//   液体底料：清水 70 + 强效魔力药水 30(=Great Mana Potion，/datum/reagent/medicine/strongmana)。
//             二者皆为现成试剂、且都不含酒 → 成品为【非酒基】药剂(直接继承 /datum/reagent)。
//   技能要求：炼金 4 级(SKILL_LEVEL_EXPERT 专家)——即题面"Alchemy-Level4"。
//   产物：30 单位气化之躯药水。
//   消化速度：每单位 12 秒(故 30 单位 ≈ 360 秒 ≈ 6 分钟的雾化时长)。
//
//   ★效果(化作一团雾气)★，只在【药剂尚在体内代谢的整段时间】内生效，药力散尽即恢复实体：
//     ① 化作雾气、只能【飘移/飞行】：除移动外【不能做任何其它动作】——不能攻击、说话、拾取/使用物品、
//        施法、做动作(emote)等；且可【凌空飞行】。
//     ② 穿门过窗：可随意穿过门与窗(乃至一切致密障碍——雾气本就无孔不入)。
//     ③ 不被视作敌人：怪物(敌对 simple_animal)不再把你选作攻击目标。
//     ④ 无法被攻击 / 不受伤害：一切常规伤害对你无效。
//     ⑤ 唯一克星——龙卷风：一旦被龙卷风"吸入"(处于其风眼半径内)，每秒流失【自身最大生命的 10%】。
//
//   ★为什么用这些引擎机制来"真正落实"上述效果(而非另造系统)★：
//     · ①"只能移动"——雾气不应能操作实体：
//         - 攻击 / 拾取 / 使用物品 / 点选式施法等【一切鼠标点击行为】→ 监听 COMSIG_MOB_CLICKON 信号并返回
//           COMSIG_MOB_CANCEL_CLICKON。该信号在 /mob/ClickOn 的最前端(click.dm)发出，早于任何攻击/拾取分发；
//           一旦取消，所有点击(左/右/中/Shift/Ctrl/Alt)全被拦下。而【键盘移动】不经 ClickOn，故不受影响。
//         - 说话 → TRAIT_MUTE(say.dm 检查它直接闭口)。做动作(emote) → TRAIT_EMOTEMUTE(emotes.dm 检查它)。
//         - 动作栏施法/主动能力(不经点击) → TRAIT_SPELLCOCKBLOCK(spell.dm cast_check 检查它，直接"无法施法")。
//         - 飞行 → 复用原版飞行术状态 /datum/status_effect/buff/magic_flight(spells/arcane/flight.dm)，
//           与"飞行药水"同源；绑定到药剂代谢生命周期(见 ensure_flight)，使飞行只随药效存续。
//       (注：不采用 notransform——它虽能拦下点击，却【连键盘移动一并冻结】(mob_movement.dm)，与"只能移动"相悖。)
//     · ②穿门过窗 → movement_type 的 UNSTOPPABLE 位。原版移动核心(turf/Enter, turf.dm)会对带 UNSTOPPABLE 的
//       移动者放行一切致密障碍(门/窗/栅栏乃至墙)。本 fork 的门(mineral_door)与窗(roguewindow)对"步行的活体"
//       都【没有】任何 pass_flag 放行钩子(其 CanPass 仅 `return !density`)，故要"随意穿门过窗"只能借 UNSTOPPABLE
//       ——这也是原版数个"穿墙 Boss"采用的同一机制。雾气之躯连实墙也能渗过，是"穿门过窗"的自然超集。
//     · ③不被视作敌人 & ④无法被攻击/不受伤害 → status_flags 的 GODMODE 位。一处开关同时满足两点：
//         - 敌对怪物的 CanAttack()(hostile.dm) 对处于 GODMODE 的目标直接返回 FALSE → 不再选你为目标；
//         - /mob/living 的各 adjust*Loss(damage_procs.dm) 在 GODMODE 下(非 forced)提前返回 → 不吃任何常规伤害。
//     · ⑤龙卷风克星 → 遍历 GLOB.active_tornadoes(gale_winds.dm 维护的活跃龙卷风表；base tornado 及其全部子类
//       abyssors_rage/dust_devil 都会登记于此)，若饮用者处于某龙卷风的 radius 风眼半径内即判定"被吸入"。
//       关键点：carbon/updatehealth()(carbon.dm) 在 GODMODE 下会提前返回、不重算 health；为让龙卷风的流失
//       【真正体现到生命值/致死】，施伤时【临时摘掉 GODMODE】→ forced 施加毒性(=被卷吸撕扯/窒息)→ updatehealth()
//       重算 → 复原 GODMODE。既保留"常规攻击无效"，又让龙卷风成为唯一威胁。
//
//   框架见 refining_framework.dm；成品瓶见 items/custom_potion_bottles.dm。
//   本文件全部内容位于 modular_z121 之下，符合项目硬性约束。
// ============================================================================

// ----------------------------------------------------------------------------
// 中文：消化速度——题面要求"每单位 12 秒"。集中成宏，便于日后调参。
// WHY: reagents.metabolize() 由 SSmobs 驱动、wait=20(每 2 秒)调用一次，每次扣除 metabolization_rate 单位；
//      故"每单位耗时(秒) = 2 ÷ metabolization_rate"。要 12 秒/单位 ⇒ metabolization_rate = 2 ÷ 12 = 1/6。
// ----------------------------------------------------------------------------
#define GASIFICATION_SECONDS_PER_UNIT 12					// Digest one unit every 12 seconds.

// ----------------------------------------------------------------------------
// 中文：被龙卷风吸入时【每秒】流失的生命比例——题面规定 10%(=0.10)。集中成宏，便于调参。
//   以"最大生命"为基准(而非当前生命)：故是线性流失，满血(100)约 10 秒被彻底撕散，作为唯一克星的威慑足够。
// ----------------------------------------------------------------------------
#define GASIFICATION_TORNADO_HP_FRACTION_PER_SEC 0.10		// Lose 10% of max health per second inside a tornado.

// ----------------------------------------------------------------------------
// 中文：★"隐身保活"计时窗口★——把 mob_timers[MT_INVISIBILITY] 顶到未来这么久，用来让身体【始终隐去】。
//   为什么需要它(修正"一移动就现形"的问题)：原版潜行系统 update_sneak_invis()(mob_movement.dm)在【每次移动】时
//   都会重算 alpha，若发现没有隐身计时器就会把身体淡回可见；只有当 MT_INVISIBILITY 处于【未来】时，它才会
//   短路返回、保持隐形。故必须持有一个"未来的隐身计时器"，并【每代谢拍刷新】(窗口 10 秒 >> 代谢拍间隔 2 秒)，
//   移动才不会让本体现形。此法与【隐身药水】完全同源。
// ----------------------------------------------------------------------------
#define GASIFICATION_INVIS_KEEPALIVE (10 SECONDS)			// Keep MT_INVISIBILITY this far in the future so movement can't reveal the body.

// ----------------------------------------------------------------------------
// 中文：★雾贴图放大倍数★——smoke.dmi 的 steam_* 帧本身只有一个图格(32px)大小，直接贴出来会显得很小。
//   给雾贴图叠层一个放大 transform，让它膨成一团更大、更有存在感的雾。BYOND 的 transform 以图标【中心】缩放，
//   故放大后仍居中笼罩在身位上。RESET_TRANSFORM 只是"不叠加身体的形变"，叠层【自身的】transform 依旧生效。
// ----------------------------------------------------------------------------
#define GASIFICATION_MIST_SCALE 2.6							// Enlarge the mist sprite ~2.6x so it reads as a big cloud, not a tiny puff.

// ----------------------------------------------------------------------------
// 中文：本药剂施加各类"特性(trait)"时统一使用的来源标识(source)。用同一 source 添加/移除，才能精确成对撤销，
//   不会误伤其它系统对同一 trait 的施加。取一个本药剂专属的常量字符串即可(与引擎既有 source 不冲突)。
// ----------------------------------------------------------------------------
#define GASIFICATION_TRAIT_SOURCE "gasification_body_potion"	// Unique trait source for clean paired add/remove.

// ----------------------------------------------------------------------------
// 中文：★雾气之躯的粒子外观★——自定义一个粒子类型，作为"化作雾气"时环绕身体的动态雾团。
//   为什么【自建子类】而非复用原版 /particles/mist：原版 /particles/mist 在两处文件里各有定义(易混淆)，
//   且其扩散范围是为环境/瀑布调的；这里另立一个专属类型、把生成范围收拢到"一个身位"，避免依赖歧义定义、
//   也不改动任何原版文件。图标复用现成的 smoke.dmi(steam_* 帧)，不新增美术资源。
//   注：这层动态粒子是"锦上添花"；真正保证"看起来是一团雾"的是那张 RESET_ALPHA 的雾贴图叠层(见 enter_mist_form)。
// ----------------------------------------------------------------------------
/particles/gasification_mist
	name = "雾气之躯"										// Mist-body particle cloud.
	icon = 'icons/effects/particles/smoke.dmi'				// Reuse the existing steam/smoke sheet (no new art).
	icon_state = list("steam_2" = 1, "steam_3" = 1)			// Vary between mist2/mist3 (steam_2/steam_3) only — exclude mist1 (steam_1).
	count = 120												// Cap of simultaneously-live particles (kept modest per-mob).
	spawning = 4											// New particles spawned each tick.
	lifespan = 4 SECONDS									// Each wisp lives ~4s.
	fade = 1 SECONDS										// Fade out over the last second.
	fadein = 0.5 SECONDS									// Ease in over half a second.
	scale = generator("num", 1.6, 3, UNIFORM_RAND)			// Each wisp is enlarged (1.6x–3x) so the cloud reads big, not tiny.
	position = generator("box", list(-22, -24), list(22, 18), UNIFORM_RAND)	// Spread wider than one tile → a large enveloping cloud.
	velocity = generator("box", list(-0.3, 0, 0), list(0.3, 0.35, 0), NORMAL_RAND)	// Slow, gently-rising drift.
	friction = 0.2											// Dampen motion so it lingers around the body.
	grow = 0.002											// Wisps swell as they rise (mist billowing).

// 中文：成品试剂——气化之躯药水。非酒基 → 直接继承 /datum/reagent(不走酒基 refined_potion 基类)。
//   设计：雾化状态与药剂"同生共死"——代谢开始进入雾态、每拍补稳、代谢结束恢复实体。
/datum/reagent/gasification_body_potion
	name = "气化之躯药水"									// In-game name (Gasification Body Potion).
	description = "循停滞空气的气息、以清水与强效魔力药水为底精炼出的乳白色雾液。饮下后周身消融、化作一团流动的雾气：只能随风飘移或凌空飞行，可穿人过物、穿门过窗，再不能挥拳、开口、取物或施法；怪物不视你为敌，寻常兵刃、烈焰与窒息皆无从加害——雾气烧不着，也无需呼吸。唯独被龙卷风吸入时，雾气之躯会被狂风一寸寸撕散。"	// Flavour + full mechanic hint.
	reagent_state = LIQUID									// Liquid potion.
	color = "#e8eef2"										// Milky, misty white.
	taste_description = "一口吸入肺腑却又无从抓握的凉雾"		// Taste flavour (cool, ungraspable mist).
	// 中文：消化速度 = 每单位 12 秒(见宏推导)：1×2/12 = 1/6 单位/拍 ⇒ 恰好 12 秒/单位。
	metabolization_rate = REAGENTS_METABOLISM * 2 / GASIFICATION_SECONDS_PER_UNIT	// 1/6 u per 2s-tick = 12s/unit.

	// 中文：★雾态是否已生效★——保证"进入雾态"的一整套施加只执行一次(防止代谢重入导致重复注册信号/重复加特性)。
	var/mist_form_active = FALSE							// One-shot guard so enter/exit each run exactly once.
	// 中文：★是否由本药剂添加了 GODMODE★——只在"原本没有"时才添加，结束时也只在"是我们加的"时才移除；
	//       避免误清管理员/其它系统预置的 GODMODE。同一瓶药从代谢始至终是同一试剂实例，用实例变量记录即可。
	var/added_godmode = FALSE								// Did WE set GODMODE (so we only clear our own)?
	// 中文：★是否由本药剂添加了 UNSTOPPABLE 移动位★——同理，仅移除自己加的位，避免误清其它来源的穿越能力。
	var/added_unstoppable = FALSE							// Did WE set the UNSTOPPABLE movement bit?
	// 中文：★本药剂实际追加的 pass_flags 位★——记录"我们新加进去的那些位"，结束时精确按位剔除，绝不误伤原有位。
	var/added_pass_flags = 0								// The exact pass_flags bits we OR-ed in (for precise revert).
	// 中文：★身体隐去的实现方式★——不再用裸 alpha=0(移动会被潜行系统重置)，改用【MT_INVISIBILITY 隐身保活计时器】
	//   驱动的隐形(与隐身药水同源)：alpha 渐隐为 0 后，只要持有未来的隐身计时器，update_sneak_invis() 在移动时便会
	//   短路、保持隐形。结束时清计时器并 update_sneak_invis(TRUE) 强制现形。故无需再单独保存/还原 alpha。
	//   (雾贴图叠层带 RESET_ALPHA，独立于本体 alpha，始终显示。)
	// 中文：★雾贴图叠层对象★——手动创建、挂到 mob.vis_contents 的那张"雾"叠层(带 RESET_ALPHA，故不受身体 alpha=0 影响、始终可见)。
	//   保存其引用，结束时精确移除并销毁。它是"看起来像一团雾"的核心保证(即便动态粒子被某些渲染条件隐藏，这张贴图也照常显示)。
	//   ★注★：手动创建(而非经 SSvis_overlays)是为了能【逐帧改写它的 icon_state】做出动画——见 cycle_mist_frame。
	var/obj/effect/overlay/vis/mist_visual = null			// The RESET_ALPHA mist vis-overlay (follows the mob, ignores body alpha; we animate its frame).
	// 中文：★雾贴图动画的循环计时器句柄★——驱动 icon_state 在 steam_2/steam_3 间来回切换，形成"雾在翻涌"的动态；结束时 deltimer。
	var/mist_anim_timer = null								// Looping timer id that alternates the mist frame (steam_2 <-> steam_3).
	// 中文：★进入雾态前的 particles★——保存原粒子(通常为 null)，结束时精确还原，避免吞掉别的系统挂的粒子效果。
	var/saved_particles = null								// Mob's particles before we attached the mist cloud.
	// 中文：★上次结算龙卷风伤害的时刻★——用于按"真实经过的秒数"换算流失量，使"每秒 10%"与实际拍间隔无关、更精确。
	var/last_tornado_tick = 0								// world.time of the previous tornado-damage sampling.
	// 中文：★上次"动作被拦下"提示的时刻★——给被拦点击一个轻量冷却，避免玩家狂点时刷屏。
	var/next_block_msg = 0									// Throttle for the "you're mist, you can't act" feedback.

// ----------------------------------------------------------------------------
// 中文：点击拦截信号处理器——只要处于雾态，任何鼠标点击(攻击/拾取/使用/点选式施法…)都被取消。
//   COMSIG_MOB_CLICKON 在 /mob/ClickOn 最前端发出(先于一切分发)，返回 COMSIG_MOB_CANCEL_CLICKON 即整单取消。
//   注：键盘移动不经 ClickOn，故本拦截【不影响移动】，恰好实现"只能移动、不能行动"。
// WHY SIGNAL_HANDLER: 信号回调必须是非睡眠过程；此处仅做取消与(节流的)提示，符合 SHOULD_NOT_SLEEP。
// ----------------------------------------------------------------------------
/datum/reagent/gasification_body_potion/proc/block_mist_click(mob/source, atom/target, params)
	SIGNAL_HANDLER										// Must not sleep — pure cancel + throttled feedback.
	// 中文：节流提示——每 3 秒最多提示一次，告知玩家雾态无法操作(纯文字，不影响机制)。
	if(source && world.time >= next_block_msg)			// Time to remind again?
		next_block_msg = world.time + 3 SECONDS			// Arm the throttle.
		to_chat(source, span_warning("雾气之躯无法触碰或操作任何实体——我只能随风飘移。"))	// Feedback.
	return COMSIG_MOB_CANCEL_CLICKON					// Cancel the click entirely.

// ----------------------------------------------------------------------------
// 中文：施加/维持飞行术并把它"钉成永久"——完全复用"飞行药水"的稳健做法：避免直接 apply_status_effect(...,-1)
//   触发 magic_flight 的 refresh(-1) 缺陷(会把 duration 算成过去而被立即移除、等于把飞行掐断)。
//   故：若已在飞，直接把现有实例 duration 设为 -1(永久)并抑制"剩 10 秒"警告；若尚未在飞，则以无限时长全新施加。
// ----------------------------------------------------------------------------
/datum/reagent/gasification_body_potion/proc/ensure_flight(mob/living/M)
	// 中文：取当前飞行术实例(若有)。has_status_effect 返回实例或 null。
	var/datum/status_effect/buff/magic_flight/FX = M.has_status_effect(/datum/status_effect/buff/magic_flight)	// Existing flight?
	if(FX)													// Already flying (spell or earlier re-assert).
		FX.duration = -1									// Pin to permanent (won't auto-expire while potion lasts).
		FX.ending_warning_sent = TRUE						// Suppress the "10s left" warning (irrelevant here).
		return FX											// Maintained.
	// 中文：尚未在飞——以无限时长(-1)全新施加(走 apply 的"全新创建"分支，不触发有缺陷的 refresh)。
	return M.apply_status_effect(/datum/status_effect/buff/magic_flight, -1)	// Fresh, permanent flight.

// ----------------------------------------------------------------------------
// 中文：雾贴图逐帧动画——由 enter_mist_form 启动的循环计时器每周期调用一次，在 steam_2 与 steam_3 之间来回切换，
//   使那团雾"翻涌流动"而非定格成一张图(排除 steam_1)。改写 vis_contents 子物件的 icon_state 会即时重绘。
// ----------------------------------------------------------------------------
/datum/reagent/gasification_body_potion/proc/cycle_mist_frame()
	// 中文：错误处理——叠层已被移除/销毁则直接返回(计时器可能在解除前的一瞬仍触发一次)。
	if(!mist_visual || QDELETED(mist_visual))				// Overlay gone — nothing to animate.
		return
	// 中文：在 mist2/mist3(steam_2/steam_3)之间切换到"另一帧"，形成往复的翻涌动画。
	mist_visual.icon_state = (mist_visual.icon_state == "steam_2") ? "steam_3" : "steam_2"	// Toggle mist2 <-> mist3.

// ----------------------------------------------------------------------------
// 中文：进入"雾气之躯"——集中施加全部效果(封锁一切非移动动作 + 飞行 + 穿越 + 免选敌 + 免伤 + 外观淡化)。
//   以 mist_form_active 作一次性守卫，防止代谢重入导致"重复注册信号/重复加特性"等异常。
//   仅对有效的 /mob/living 施加；每一项都先判"原本是否已具备"，只添加缺失的部分，为结束时的精确还原做准备。
// ----------------------------------------------------------------------------
/datum/reagent/gasification_body_potion/proc/enter_mist_form(mob/living/M)
	// 中文：错误处理——目标缺失/正在删除 → 直接返回，避免对无效对象操作而运行时报错。
	if(!M || QDELETED(M))									// No valid drinker.
		return
	// 中文：错误处理——本效果只对 /mob/living 有意义(GODMODE/移动位/受伤管线/特性都定义在 living 层)。
	if(!isliving(M))										// Effect only applies to living mobs.
		return
	// 中文：一次性守卫——已在雾态则不重复施加。
	if(mist_form_active)									// Already applied for this potion instance.
		return
	mist_form_active = TRUE									// Latch: from now on we're the mist owner.

	// ---- ①-a "只能移动"：拦截一切鼠标点击(攻击/拾取/使用/点选施法…) ----
	// 中文：override=TRUE 防御性避免"同源同信号重复注册"抛错(极端重入场景)。
	RegisterSignal(M, COMSIG_MOB_CLICKON, PROC_REF(block_mist_click), override = TRUE)	// Cancel all clicks while misty.

	// ---- ①-b "只能移动"：封锁说话 / 做动作 / 施法(动作栏主动能力) ----
	ADD_TRAIT(M, TRAIT_MUTE, GASIFICATION_TRAIT_SOURCE)			// Can't speak (say.dm checks TRAIT_MUTE).
	ADD_TRAIT(M, TRAIT_EMOTEMUTE, GASIFICATION_TRAIT_SOURCE)		// Can't emote (emotes.dm checks TRAIT_EMOTEMUTE).
	ADD_TRAIT(M, TRAIT_SPELLCOCKBLOCK, GASIFICATION_TRAIT_SOURCE)	// Can't cast spells (spell.dm cast_check).

	// ---- ⑤ 雾体本征：不可燃 + 抗高温 + 无需呼吸(一团水雾，烧不着、也不必呼吸) ----
	// 中文：TRAIT_NOFIRE 让点燃有 90% 直接失败(ignite_mob 检查它)；TRAIT_RESISTHEAT 免疫"着火持续伤害"与高温环境伤害；
	//       TRAIT_NOBREATH 免除呼吸需求(carbon/human 的 life 检查它，跳过整套呼吸/窒息处理)。前两者与【地狱血脉】美德同源做法。
	//       另在 on_mob_life 每拍兜底扑灭偶尔(那 10%)漏过的着火，做到"雾始终不燃"。
	ADD_TRAIT(M, TRAIT_NOFIRE, GASIFICATION_TRAIT_SOURCE)		// Nonflammable — ignite_mob fails 90% of the time.
	ADD_TRAIT(M, TRAIT_RESISTHEAT, GASIFICATION_TRAIT_SOURCE)	// Immune to on-fire tick + hot-environment damage.
	ADD_TRAIT(M, TRAIT_NOBREATH, GASIFICATION_TRAIT_SOURCE)		// No breathing required (mist has no lungs to fill).

	// ---- ①-c "可飞行"：以无限时长挂上飞行术(随药效存续，见 ensure_flight) ----
	ensure_flight(M)										// Grant/maintain permanent flight for the duration.

	// ---- ②不被视作敌人 & ③无法被攻击/不受伤害：GODMODE(仅在原本未开时才由我们开启) ----
	if(!(M.status_flags & GODMODE))							// Only add if not already god (don't clobber admin god).
		M.status_flags |= GODMODE							// Untargetable by hostiles + immune to normal damage.
		added_godmode = TRUE								// Remember we own this flag, to clear it precisely later.

	// ---- ④穿门过窗：UNSTOPPABLE 移动位(仅在原本未带时才由我们添加) ----
	if(!(M.movement_type & UNSTOPPABLE))					// Only add if not already unstoppable.
		M.movement_type |= UNSTOPPABLE						// Seep through doors/windows (and any dense obstacle).
		added_unstoppable = TRUE							// Remember we own this bit.

	// ---- 顺带追加若干 pass_flags：让雾体穿过桌子/玻璃/栅栏/其它 mob 时不产生多余的 Bump 阻挡与撞击 ----
	// 中文：UNSTOPPABLE 已能"不被拦停"，但仍会 Bump 触碰物；追加这些位可让穿越更"顺滑"、不推挤他人。
	//       只 OR 进"当前缺失"的位并记录，结束时按位精确剔除，绝不动到 mob 原有的 pass_flags 位。
	var/desired = PASSTABLE | PASSGLASS | PASSGRILLE | PASSMOB	// Smooth passage through tables/glass/grilles/mobs.
	added_pass_flags = desired & ~M.pass_flags				// Bits WE will add (those not already present).
	M.pass_flags |= added_pass_flags						// Apply only the missing bits.

	// ---- 外观：把【原本的人形贴图彻底隐去】，改以"雾"取代——满足"看上去是一团雾，而非原来的样子" ----
	// 中文：分两步实现，且二者叠加互为保险：
	//   (a) 把身体本体隐去 → 用【MT_INVISIBILITY 隐身保活】驱动的隐形，而非裸 alpha=0：
	//       先把 alpha 渐隐为 0(连同所有肢体/衣物/持械叠层一并不可见)，再把隐身计时器推到未来并 update_sneak_invis()
	//       即时进入隐形态。★关键★：只有持有"未来的隐身计时器"，移动时被调用的 update_sneak_invis() 才会短路、
	//       维持隐形；否则每次移动都会把身体淡回可见(这正是"一移动就现形"的根因，此处予以修正)。计时器每拍刷新。
	//   (b) 追加一张【带 RESET_ALPHA 的"雾"贴图叠层】到 mob.vis_contents：RESET_ALPHA 使该叠层【无视】身体 alpha=0
	//       而照常以自身不透明度显示(本 fork 既有 plasticflaps / love_heart 正是用 RESET_ALPHA 实现"底图隐去、叠层照显")；
	//       vis_contents 令其【自动跟随】mob 移动(雾无方向性，不需随朝向旋转)；其 icon_state 由循环计时器逐帧切换(见 cycle_mist_frame)。
	//   另外把一层动态雾粒子挂到 mob.particles(锦上添花：若渲染条件允许则呈现飘动雾团；即便不显示，(b) 的贴图也已保证效果)。
	animate(M, alpha = 0, time = 1 SECONDS, easing = EASE_IN)	// Dissolve the humanoid body out of sight.
	M.mob_timers[MT_INVISIBILITY] = world.time + GASIFICATION_INVIS_KEEPALIVE	// Keep-alive so movement can't reveal the body.
	M.update_sneak_invis()									// Enter the hidden (rogue_sneaking) state now.
	// 中文：(b) 手动创建"雾"贴图叠层并挂到 mob.vis_contents：
	//   · RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM 使其完全不受身体的 alpha/颜色/形变影响(身体 alpha=0 时它照常满不透明显示)；
	//   · 挂进 vis_contents 使其【自动跟随】mob 移动；
	//   · 手动创建(而非 SSvis_overlays)是为了后续能【逐帧改写 icon_state】做动画。起始帧用 steam_2。
	mist_visual = new /obj/effect/overlay/vis				// Our private mist sprite (we own its lifecycle & frame).
	mist_visual.icon = 'icons/effects/particles/smoke.dmi'	// Reuse the existing steam/smoke sheet (no new art).
	mist_visual.icon_state = "steam_2"						// Start on mist2 (steam_2).
	mist_visual.layer = ABOVE_MOB_LAYER						// Render just above the (now-hidden) mob.
	mist_visual.plane = GAME_PLANE							// Same plane as mobs.
	mist_visual.appearance_flags = RESET_ALPHA | RESET_COLOR | RESET_TRANSFORM	// Ignore body alpha=0/color/transform → always visible.
	mist_visual.transform = matrix() * GASIFICATION_MIST_SCALE	// Scale the (small) steam sprite up into a big, enveloping cloud (centered).
	M.vis_contents += mist_visual							// Attach so it follows the mob automatically.
	// 中文：启动循环计时器，让雾贴图在 steam_2/steam_3 间来回切换(排除 steam_1)，呈现"雾在翻涌"的动态而非一张定格图。
	//   TIMER_STOPPABLE 让 addtimer 返回句柄以便结束时 deltimer；周期 0.6 秒，翻涌节奏柔和。
	mist_anim_timer = addtimer(CALLBACK(src, PROC_REF(cycle_mist_frame)), 0.6 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)	// Alternate the mist frame over time.
	// 中文：动态雾团(锦上添花)——保存原粒子后，挂上专属雾气粒子。
	saved_particles = M.particles							// Remember any pre-existing particles (usually none).
	M.particles = new /particles/gasification_mist()		// Attach the drifting mist cloud around the (now-hidden) body.

// ----------------------------------------------------------------------------
// 中文：退出"雾气之躯"——把 enter_mist_form 施加过的一切【精确还原】(只撤销我们加的部分)，恢复实体。
//   还原 GODMODE 后需要一次 updatehealth() 让生命值重新同步(GODMODE 期间被冻结不算)。
// ----------------------------------------------------------------------------
/datum/reagent/gasification_body_potion/proc/exit_mist_form(mob/living/M)
	// 中文：一次性守卫——未处于雾态则无需还原(防止重复解除)。
	if(!mist_form_active)									// Nothing was applied / already reverted.
		return
	mist_form_active = FALSE								// Un-latch.
	// 中文：错误处理——目标缺失/正在删除 → 无需(也无法)还原，直接返回(守卫已复位，避免残留)。
	if(!M || QDELETED(M))									// Nothing to restore on an invalid mob.
		return

	// ---- 解除点击拦截 ----
	UnregisterSignal(M, COMSIG_MOB_CLICKON)					// Clicks work again.

	// ---- 解除 说话/动作/施法 封锁(按我们专属 source 精确移除) ----
	REMOVE_TRAIT(M, TRAIT_MUTE, GASIFICATION_TRAIT_SOURCE)			// Can speak again.
	REMOVE_TRAIT(M, TRAIT_EMOTEMUTE, GASIFICATION_TRAIT_SOURCE)		// Can emote again.
	REMOVE_TRAIT(M, TRAIT_SPELLCOCKBLOCK, GASIFICATION_TRAIT_SOURCE)	// Can cast again.

	// ---- 解除 不可燃/抗高温/无需呼吸 ----
	REMOVE_TRAIT(M, TRAIT_NOFIRE, GASIFICATION_TRAIT_SOURCE)			// Flammable again.
	REMOVE_TRAIT(M, TRAIT_RESISTHEAT, GASIFICATION_TRAIT_SOURCE)		// Heat can hurt again.
	REMOVE_TRAIT(M, TRAIT_NOBREATH, GASIFICATION_TRAIT_SOURCE)		// Must breathe again.

	// ---- 解除飞行术(随药效终止而落地) ----
	M.remove_status_effect(/datum/status_effect/buff/magic_flight)	// End flight when the potion is gone.

	// ---- 还原 pass_flags：仅剔除我们加过的那些位 ----
	if(added_pass_flags)									// We added some bits.
		M.pass_flags &= ~added_pass_flags					// Remove exactly those, leave the rest intact.
		added_pass_flags = 0								// Reset bookkeeping.

	// ---- 还原 UNSTOPPABLE：仅当是我们添加的才移除(不动其它来源的穿越能力) ----
	if(added_unstoppable)									// We set the bit.
		M.movement_type &= ~UNSTOPPABLE						// Solid again — no more phasing.
		added_unstoppable = FALSE							// Reset bookkeeping.

	// ---- 还原 GODMODE：仅当是我们添加的才清除；随后 updatehealth() 让生命值恢复正常结算 ----
	if(added_godmode)										// We set GODMODE.
		M.status_flags &= ~GODMODE							// Vulnerable again.
		added_godmode = FALSE								// Reset bookkeeping.
		M.updatehealth()									// Resync health now that the godmode freeze is lifted.

	// ---- 还原外观：撤掉"雾"贴图叠层与雾粒子，再把身体 alpha 恢复到进入雾态前的原值(重新显出人形) ----
	// 中文：撤除雾贴图叠层——先停循环动画计时器，再从 vis_contents 摘下并销毁(手动创建的私有对象，需自行 qdel)。
	// 中文：先停掉雾贴图的循环动画计时器(避免悬空回调引用已释放对象)。
	if(mist_anim_timer)										// A looping animation timer is running.
		deltimer(mist_anim_timer)							// Stop alternating frames.
		mist_anim_timer = null								// Drop the handle.
	// 中文：再把雾贴图从 vis_contents 摘下并销毁(手动创建的，需自行 qdel)。
	if(mist_visual)											// We attached a mist overlay.
		M.vis_contents -= mist_visual						// Detach it from the mob.
		qdel(mist_visual)									// Destroy our private overlay object.
		mist_visual = null									// Drop our reference.
	// 中文：还原粒子(把 particles 恢复为进入前保存的值，通常是 null)——只撤销我们挂的雾团，不动别的系统的粒子。
	M.particles = saved_particles							// Restore any prior particles (mist cloud goes away).
	saved_particles = null									// Reset bookkeeping.
	// 中文：恢复人形——清空隐身保活计时器，并以 reset=TRUE 强制 update_sneak_invis 现形(它会把 alpha 淡回默认并 regenerate_icons)。
	//   与隐身药水的收尾完全一致，交由潜行系统权威地恢复本体可见性。
	M.mob_timers[MT_INVISIBILITY] = 0						// Drop the invisibility keep-alive.
	M.update_sneak_invis(TRUE)								// Force reveal + restore alpha (reset path).

// 中文：代谢开始时(每"一份"药剂仅触发一次)——校验目标后进入雾态，并初始化龙卷风结算的时间基准。
/datum/reagent/gasification_body_potion/on_mob_metabolize(mob/living/M)
	. = ..()												// Let the base reagent set up first.
	// 中文：错误处理——目标无效则不施加效果(避免对无效对象操作报错)。
	if(!M || QDELETED(M) || !isliving(M))					// No valid living drinker.
		return
	enter_mist_form(M)										// Apply: no-action lock + flight + phasing + immunity + fade.
	last_tornado_tick = world.time							// Start the tornado-damage clock now.
	// 中文：成功反馈——纯文字提示，不影响机制。
	M.visible_message(span_warning("[M]的身形骤然消融，化作一团流动的雾气！"), span_notice("我的身体化作了雾气——只能随风飘移或飞行，再不能出手、开口或取物；但可穿门过窗，寻常伤害也奈何我不得。"))	// Transform feedback.

// 中文：每代谢一拍——① 校验并补稳雾态各项增益(防止被外力清掉)；② 结算"被龙卷风吸入"的流失；随后交给父类扣减用量。
/datum/reagent/gasification_body_potion/on_mob_life(mob/living/carbon/M)
	// 中文：错误处理——目标缺失/正在删除 → 跳过效果，仍交给父类收尾以保持代谢推进。
	if(!M || QDELETED(M))									// Guard against missing/deleting mob.
		return ..()

	// ---- ① 补稳：若我们添加的增益被外力移除，则补回(使效果贯穿整个药效期) ----
	// 中文：只在"当初是我们加的、如今却没了"时补回，避免抢占/覆盖其它系统的状态。
	if(added_godmode && !(M.status_flags & GODMODE))		// Our godmode got stripped?
		M.status_flags |= GODMODE							// Re-assert damage-immunity/untargetable.
	if(added_unstoppable && !(M.movement_type & UNSTOPPABLE))	// Our phasing got stripped?
		M.movement_type |= UNSTOPPABLE						// Re-assert phasing.
	// 中文：补稳 pass_flags——保证 PASSMOB(穿人)/PASSTABLE/PASSGLASS/PASSGRILLE 始终在位(若被外力清掉则补回)，
	//   使"以雾之身穿过其他人/物"始终生效(CanPass 见 mover.pass_flags & PASSMOB 即放行)。
	if(added_pass_flags && ((M.pass_flags & added_pass_flags) != added_pass_flags))	// Any of our pass bits stripped?
		M.pass_flags |= added_pass_flags					// Re-assert them (keeps pass-through-mobs working).
	if(mist_form_active)									// While still misty...
		ensure_flight(M)									// ...keep flight asserted (may be stripped by resting/knockdown).
		// 中文：★补稳外观(修正"移动就现形")★——每拍把隐身保活计时器顶到未来，使移动时的 update_sneak_invis() 持续短路、
		//   维持隐形；若仍被某动作/系统显出人形，则再淡隐并重申隐形态。与隐身药水的逐拍维持完全同源。
		M.mob_timers[MT_INVISIBILITY] = world.time + GASIFICATION_INVIS_KEEPALIVE	// Refresh keep-alive every tick.
		if(M.alpha != 0)									// Body got revealed by some action/system?
			animate(M, alpha = 0, time = 0.5 SECONDS)		// Fade back to hidden.
			M.update_sneak_invis()							// Re-assert the hidden state.
		// 中文：★兜底扑灭★——TRAIT_NOFIRE 只有 90% 概率避开点燃；若那 10% 漏过而着了火，这里每拍归零火焰层并扑灭，
		//   保证"雾不燃"。set_fire_stacks(0)+extinguish_mob() 均为原版正规接口，未着火时调用无副作用。
		if(M.on_fire || M.fire_stacks > 0)					// Somehow caught fire / accrued fire stacks?
			M.set_fire_stacks(0)							// Zero the stacks so it can't re-ignite.
			M.extinguish_mob()								// Put the fire out now.

	// ---- ② 唯一克星：被龙卷风吸入则按秒流失生命 ----
	handle_tornado_inhalation(M)							// Drain health while caught in a tornado.

	return ..()												// Standard metabolism (consumes metabolization_rate).

// 中文：代谢结束(药剂耗尽/被清除)时——恢复实体(精确撤销我们加过的一切)，并给出反馈。
/datum/reagent/gasification_body_potion/on_mob_end_metabolize(mob/living/M)
	// 中文：错误处理——仅对有效目标还原，避免对无效对象操作报错(exit_mist_form 内部亦有守卫)。
	if(M && !QDELETED(M))									// Valid target?
		exit_mist_form(M)									// Revert everything we applied (only our own additions).
		M.visible_message(span_warning("[M]周身的雾气重新凝实，恢复了血肉之躯。"), span_notice("雾气重新凝聚成形，我恢复了实体，也重新能够行动了。"))	// Restore feedback.
	return ..()												// Let the base finish up.

// ----------------------------------------------------------------------------
// 中文：结算"被龙卷风吸入"的每秒流失。遍历活跃龙卷风表，若饮用者处于任一龙卷风的风眼半径内即视为被吸入；
//   按【真实经过的秒数】换算流失量(=最大生命×10%×经过秒数)，并在施伤瞬间【临时摘除 GODMODE】以便 carbon
//   的 updatehealth() 能真正重算生命(否则 GODMODE 会令其提前返回、伤害不体现)，施完再复原 GODMODE。
// ----------------------------------------------------------------------------
/datum/reagent/gasification_body_potion/proc/handle_tornado_inhalation(mob/living/M)
	// 中文：错误处理——目标无效或全局龙卷风表不存在/为空 → 无需结算(顺带把时间基准推进，避免下次一进风就补算一大段)。
	if(!M || QDELETED(M) || !isliving(M))					// Invalid mob.
		last_tornado_tick = world.time						// Keep the clock fresh.
		return
	if(!GLOB.active_tornadoes || !GLOB.active_tornadoes.len)	// No tornadoes anywhere on the map.
		last_tornado_tick = world.time						// Nothing to sample; advance the clock.
		return

	// ---- 判定是否被吸入：任一活跃龙卷风与饮用者【同 z 层】且距离 <= 其风眼半径 radius 即算 ----
	var/inhaled = FALSE										// Is the drinker inside a tornado's eye-radius?
	for(var/obj/effect/weather/tornado/T as anything in GLOB.active_tornadoes)	// Every active tornado (all subtypes).
		if(!T || QDELETED(T))								// Skip stale/deleting entries defensively.
			continue
		if(T.z != M.z)										// Must be on the same z-level to inhale us.
			continue
		if(get_dist(M, T) <= T.radius)						// Within the swirling eye-radius?
			inhaled = TRUE									// Caught in the tornado.
			break											// One is enough.

	// ---- 计算自上次结算以来真实经过的秒数(deciseconds→seconds)，使"每秒 10%"与拍间隔无关地精确成立 ----
	var/elapsed_seconds = (world.time - last_tornado_tick) / 10	// Real seconds since last sample.
	last_tornado_tick = world.time							// Advance the clock for the next sample.
	// 中文：防御——异常/回绕导致的非正经过时间一律视作 0，避免施加负伤或超大伤害。
	if(elapsed_seconds <= 0)								// Clock anomaly (e.g., first tick, or time rewind).
		return

	// ---- 未被吸入 → 不流失(雾态本身免疫一切常规伤害) ----
	if(!inhaled)											// Safe from tornadoes right now.
		return

	// ---- 被吸入 → 施加"最大生命 × 10% × 经过秒数"的流失，且需临时摘除 GODMODE 才能真正体现到生命值 ----
	var/damage = M.maxHealth * GASIFICATION_TORNADO_HP_FRACTION_PER_SEC * elapsed_seconds	// HP to lose this sample.
	if(damage <= 0)											// Nothing to apply (defensive).
		return
	// 中文：临时摘除 GODMODE——记录我们是否为此摘除，稍后精确复原(不动别的来源)。
	var/lifted_godmode = FALSE								// Did we lift godmode just for this hit?
	if(M.status_flags & GODMODE)							// Currently protected...
		M.status_flags &= ~GODMODE							// ...briefly drop protection so damage registers.
		lifted_godmode = TRUE								// Remember to restore it.
	// 中文：以 forced=TRUE 施加毒性伤害(=被狂风卷吸撕散/窒息)。用毒性通道：它直接计入 carbon.updatehealth 的致死判定。
	M.adjustToxLoss(damage, forced = TRUE)					// Apply the inhalation damage (bypasses any residual guard).
	M.updatehealth()										// Recompute health now that godmode is momentarily lifted.
	// 中文：复原 GODMODE(仅当刚才是我们摘的)——恢复"常规攻击无效"，让龙卷风依旧是唯一威胁。
	if(lifted_godmode)										// We lifted it above.
		M.status_flags |= GODMODE							// Re-arm damage-immunity against normal attacks.
	// 中文：受创反馈——纯文字提示被龙卷风撕扯。
	to_chat(M, span_userdanger("龙卷风正把我的雾气之躯一寸寸撕散——我在飞快地消散！"))	// Feedback: being torn apart.

// ============================================================================
// 配方：★按气味等级★——【5 级"停滞的空气"气味】+ 复合底料(清水70 + 强效魔力药水30) → 气化之躯药水。
//   "停滞的空气"是原版 big_stam_poison(强效耐力毒药)配方的 smells_like，此前未被任何自定义精炼药剂占用；
//   带该气味的现成材料指向 big_stam_poison：重楼(3)+地狱尘(2)=5，凑满 5 点即触发(无需新增材料)。
//   底料 30 单位【强效魔力药水】即题面所述的"Great Mana Potion"(/datum/reagent/medicine/strongmana)。
// ============================================================================
/datum/alch_refining_formula/gasification_body
	name = "气化之躯药水"									// Formula name.
	// 中文：★气味档①★ 要求"停滞的空气"气味累计达到 5 点(即题面的"某种未占用气味，5 级")。
	required_scent = "停滞的空气"							// Require the (unused) "stagnant air" scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★复合底料★ 清水 70 + 强效魔力药水 30(=Great Mana Potion)；均为现成试剂、无酒 → 成品非酒基。
	required_base = list(/datum/reagent/water = 70, /datum/reagent/medicine/strongmana = 30)	// 70 water + 30 great mana potion.
	// 中文：产物——30 单位气化之躯药水。
	output_reagents = list(/datum/reagent/gasification_body_potion = 30)	// Refined output (30 units).
	// 中文：所需技能——炼金 4 级(专家)。技能不足则整锅腐坏(框架 spoil_batch 处理)。
	skill_required = SKILL_LEVEL_EXPERT						// Alchemy level 4 gate.
	// 中文：成功气味词。
	smells_like = "无孔不入的凝滞雾气"						// Success scent.

// 中文：清理本文件作用域内的局部宏，避免泄漏到全局编译环境。
#undef GASIFICATION_SECONDS_PER_UNIT
#undef GASIFICATION_TORNADO_HP_FRACTION_PER_SEC
#undef GASIFICATION_TRAIT_SOURCE
#undef GASIFICATION_INVIS_KEEPALIVE
#undef GASIFICATION_MIST_SCALE
