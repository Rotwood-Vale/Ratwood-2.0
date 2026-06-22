// =============================================================================
// 自定义美德：永无止境 (never-ending)
// Custom Virtue: "never-ending"
//
// 设计说明 / Design notes:
//   - 消耗 99 点凯旋点数 (TRIUMPH). Costs 99 TRIUMPH points to take.
//   - 授予特性「指定演员」(Designated Performer). Grants the "Designated Performer" trait.
//   - 特性效果：每天一次，死亡三分钟后以完美状态复活，但会失去全部记忆，
//     技能进度也会回退到刚进入游戏时的状态。
//     Characteristic effect: once per day, three minutes after death the bearer is
//     resurrected in a perfect state, but loses all memories and has skill progress
//     reset to the state it was in when they first entered the game.
//
// 约束 / Constraints:
//   - 本文件完全位于 modular_z121 之内，不修改任何外部代码。
//     This file lives entirely inside modular_z121 and modifies no external code.
//   - 复活/技能重置/记忆清除全部通过主线已存在的接口实现：
//     Resurrection / skill reset / memory wipe all hook into existing mainline procs:
//       * mob/living/proc/revive(full_heal, admin_revive)  -> 完美复活 perfect heal
//       * mob.skills.known_skills / skill_experience        -> 技能存储 skill storage
//       * datum/mind/proc/wipe_memory()                     -> 清除笔记记忆 wipe notes
// =============================================================================

// 「指定演员」特性的字符串 ID。用作 ADD_TRAIT 的 trait define，便于其它系统查询。
// String identifier for the "Designated Performer" trait, queryable via HAS_TRAIT elsewhere.
#define TRAIT_DESIGNATED_PERFORMER "designated_performer"

// 复活前的等待时间：3 分钟。剧本里的「随后不久」即被量化为三分钟。
// Delay before resurrection happens: 3 minutes ("soon after" the script ends).
#define NEVER_ENDING_REVIVE_DELAY (3 MINUTES)

// 每日冷却：复活能力每天只能触发一次（以真实游戏时间 24 小时计）。
// Daily cooldown: the resurrection may only fire once per (real) day = 24 hours.
#define NEVER_ENDING_DAILY_COOLDOWN (24 HOURS)


// -----------------------------------------------------------------------------
// 美德数据 / The virtue datum
// 归入 utility 分支，与「不朽」「夜视」等其它效用型美德保持一致。
// Filed under the utility branch, matching deathless / night_vision, etc.
// 因为是 /datum/virtue 的子类型，全局列表会通过 subtypesof() 自动收录，无需手动注册。
// As a /datum/virtue subtype it is auto-registered into GLOB.virtues via subtypesof().
// -----------------------------------------------------------------------------
/datum/virtue/utility/never_ending
	// 美德名称 / Display name shown in the virtue selection UI.
	name = "永无止境"
	// 角色内描述 / In-character description of the fantasy.
	desc = "我是这出剧本里举足轻重的演员。每当我走向结局，随后不久，诸神便会再次将我推上舞台。"
	// 额外说明：把机制清楚地讲给玩家，避免他们误以为这是无限免死金牌。
	// Custom addendum so players understand the exact, limited mechanic.
	custom_text = "获得「指定演员」特性：每天一次，死亡 3 分钟后以完美状态复活；\n\
	但复活会使你失去全部记忆（请进行相应的角色扮演），\n\
	并且所有技能进度都会回退到你刚进入游戏时的状态。"
	// 消耗 99 点凯旋点数。基类 New() 会自动把这条信息追加到 desc 里。
	// 99 TRIUMPH cost; the base New() appends a "Costs 99 TRIUMPH" line to desc.
	triumph_cost = 99
	// 通过标准 added_traits 通道授予特性，来源标记为 TRAIT_VIRTUE，便于统一管理/清除。
	// Grant the trait through the standard added_traits channel (TRAIT_VIRTUE source).
	added_traits = list(TRAIT_DESIGNATED_PERFORMER)

// apply_to_human：在美德被赋予人物时调用，这里负责挂上真正驱动效果的组件。
// apply_to_human: called when the virtue is granted; attaches the component that drives the effect.
/datum/virtue/utility/never_ending/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// 防御性检查：没有有效的人物就直接返回，避免空引用运行时报错。
	// Defensive guard: bail out on a missing recipient to avoid runtime null errors.
	if(!recipient)
		return
	// 挂载「永无止境」组件。组件本身做去重处理，重复赋予不会叠加。
	// Attach the never-ending component; it is unique-duped so re-applying is a no-op.
	recipient.AddComponent(/datum/component/never_ending_performer)


// -----------------------------------------------------------------------------
// 驱动组件 / The driving component
// 把所有「运行期」逻辑（监听死亡、计时、复活、技能快照）封装进组件，
// 这样美德 datum 保持纯数据，组件负责挂在具体 mob 上的行为。
// All runtime behaviour (death listening, timing, revival, skill snapshot) lives here,
// keeping the virtue datum as pure data and the per-mob behaviour in the component.
// -----------------------------------------------------------------------------
/datum/component/never_ending_performer
	// 设为唯一组件：同一个 mob 上只允许存在一个，重复 AddComponent 会被丢弃。
	// Unique component: only one instance per mob; duplicate AddComponent calls are dropped.
	dupe_mode = COMPONENT_DUPE_UNIQUE
	// 进入游戏时的技能等级快照（skill datum -> level）。复活时据此还原。
	// Snapshot of skill levels at game entry (skill datum -> level); restored on revival.
	var/list/initial_known_skills
	// 进入游戏时的技能经验快照（skill datum -> exp）。与等级快照配套还原。
	// Snapshot of skill experience at game entry (skill datum -> exp); restored alongside levels.
	var/list/initial_skill_experience
	// 标记当前是否已经安排了一次待执行的复活，避免对同一次死亡重复计时。
	// Flag marking that a revival is already scheduled, so one death can't queue several timers.
	var/revive_pending = FALSE
	// 每日复活能力的冷却计时器（由 COOLDOWN_* 宏读写）。
	// Cooldown tracker for the once-per-day revival, read/written by the COOLDOWN_* macros.
	COOLDOWN_DECLARE(daily_revive_cd)

// Initialize：组件创建时调用，负责类型校验、拍摄技能快照、注册死亡信号。
// Initialize: runs on component creation; validates type, snapshots skills, hooks death.
/datum/component/never_ending_performer/Initialize()
	. = ..()
	// 只有人类（carbon/human）才有完整的技能/记忆/复活体系，其它类型不兼容。
	// Only carbon humans have the full skill/memory/revive systems; reject anything else.
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/performer = parent
	// 立刻拍下「刚进入游戏时」的技能状态。美德在出生流程中赋予，此刻即为起始状态。
	// Snapshot the "just entered the game" skill state now; the virtue is granted during
	// spawn setup, so this moment represents the character's starting skills.
	snapshot_initial_skills(performer)
	// 监听该人物的死亡信号。每次死亡都会触发 on_performer_death。
	// Listen for this performer's death; each death triggers on_performer_death.
	RegisterSignal(performer, COMSIG_LIVING_DEATH, PROC_REF(on_performer_death))

// snapshot_initial_skills：把当前技能等级与经验深拷贝保存，作为「初始状态」基准。
// snapshot_initial_skills: deep-copies current skill levels & experience as the baseline.
/datum/component/never_ending_performer/proc/snapshot_initial_skills(mob/living/carbon/human/performer)
	// 防御性检查：人物失效就放弃拍摄，留空快照在复活时会被安全跳过。
	// Guard: if the performer is invalid, skip; empty snapshots are handled safely on revive.
	if(QDELETED(performer))
		return
	// ensure_skills() 保证技能持有者存在（首次访问时会惰性创建）。
	// ensure_skills() guarantees the skill_holder exists (lazily created on first access).
	var/datum/skill_holder/holder = performer.ensure_skills()
	if(!holder)
		return
	// .Copy() 做浅拷贝即可：键是全局唯一的技能单例，值是数字，互不共享引用。
	// A shallow .Copy() suffices: keys are global skill singletons and values are numbers.
	initial_known_skills = holder.known_skills?.Copy()
	initial_skill_experience = holder.skill_experience?.Copy()

// on_performer_death：死亡信号回调。判断冷却，符合条件则排程一次三分钟后的复活。
// on_performer_death: death signal handler; checks cooldown and schedules a +3min revival.
/datum/component/never_ending_performer/proc/on_performer_death(datum/source, gibbed)
	// SIGNAL_HANDLER：声明这是信号回调，禁止在其中执行可能 sleep 的操作。
	// SIGNAL_HANDLER: marks this as a signal callback; no sleeping operations allowed here.
	SIGNAL_HANDLER
	var/mob/living/carbon/human/performer = parent
	// 防御：人物已被删除（例如尸体被销毁）则无从复活，直接返回。
	// Guard: a deleted performer (e.g. corpse destroyed) cannot be revived; bail out.
	if(QDELETED(performer))
		return
	// 若已被肢解成碎块（gibbed），身体已不存在，本能力无法把碎块拼回。
	// If the body was gibbed there is nothing left to bring back; the power cannot act.
	if(gibbed)
		to_chat(performer, span_warning("你的躯体已四分五裂，连诸神也无法将这具残骸重新搬上舞台……"))
		return
	// 每日冷却未结束则本次死亡不再触发复活，提示玩家原因。
	// If the daily cooldown is still ticking, this death does not trigger a revival.
	if(!COOLDOWN_FINISHED(src, daily_revive_cd))
		to_chat(performer, span_warning("诸神今日已让你登过一次台了，这一次，你必须长眠。"))
		return
	// 若已有一次复活在排程中，避免重复计时（例如极端情况下信号重入）。
	// Avoid double-scheduling if a revival is already queued (e.g. signal re-entry).
	if(revive_pending)
		return
	// 立即开始每日冷却，确保「每天一次」从触发那一刻起计。
	// Start the daily cooldown immediately so "once per day" counts from this trigger.
	COOLDOWN_START(src, daily_revive_cd, NEVER_ENDING_DAILY_COOLDOWN)
	// 标记复活已排程。
	// Mark a revival as queued.
	revive_pending = TRUE
	// 给玩家一段叙事提示，营造「等待重新登台」的氛围。
	// Flavour message to set up the "waiting to be put back on stage" beat.
	to_chat(performer, span_notice("<b>幕布落下了……但你的故事尚未写完。静候片刻，诸神会让你重返舞台。</b>"))
	// 三分钟后执行复活。使用 addtimer 以非阻塞方式延迟，不会卡住信号链。
	// Schedule the revival in 3 minutes via a non-blocking addtimer (won't stall the signal).
	addtimer(CALLBACK(src, PROC_REF(resurrect_performer)), NEVER_ENDING_REVIVE_DELAY)

// resurrect_performer：计时器到点后执行的实际复活逻辑，包含完整错误处理。
// resurrect_performer: the actual revival logic run when the timer fires, with full error handling.
/datum/component/never_ending_performer/proc/resurrect_performer()
	// 无论结果如何，先清掉「待复活」标记，让后续死亡能重新排程。
	// Clear the pending flag first so later deaths can schedule again regardless of outcome.
	revive_pending = FALSE
	var/mob/living/carbon/human/performer = parent
	// 防御：等待期间人物可能被彻底删除，此时无对象可复活。
	// Guard: the performer may have been deleted during the wait; nothing to revive.
	if(QDELETED(performer))
		return
	// 防御：若在三分钟内已被他人复活（例如神迹治疗），则诸神无需出手，直接结束。
	// Guard: if already revived by other means within the window, the gods need not act.
	if(performer.stat != DEAD)
		return
	// 核心复活：full_heal = TRUE 触发完整治疗，admin_revive = TRUE 绕过常规可复活限制，
	// 并在 human/fully_heal 中再生四肢与器官，从而达到「完美状态」。
	// Core revival: full_heal=TRUE triggers a full heal, admin_revive=TRUE bypasses the
	// normal revivability checks and regenerates limbs/organs for a "perfect state".
	performer.revive(full_heal = TRUE, admin_revive = TRUE)
	// 复活后若仍为死亡状态，说明存在我们无法克服的阻碍（如缺失大脑），优雅放弃。
	// If still dead afterwards, some blocker we can't overcome exists (e.g. no brain); give up gracefully.
	if(performer.stat == DEAD)
		to_chat(performer, span_warning("有什么东西阻止了你的回归……这一次，舞台仍向你紧闭。"))
		return
	// 把可能仍在以鬼魂形式旁观的玩家送回躯体，确保他们真正「重新登台」。
	// Pull the player's spectating ghost (if any) back into the body so they truly return.
	return_ghost_to_body(performer)
	// 失去全部记忆：清空角色笔记，并以强提示要求玩家进行失忆角色扮演。
	// Lose all memories: wipe the character's notes and strongly prompt amnesia roleplay.
	wipe_performer_memories(performer)
	// 技能回退：把技能等级/经验还原到进入游戏时的快照。
	// Reset skills: restore levels/experience to the game-entry snapshot.
	restore_initial_skills(performer)
	// 终幕提示：告诉玩家复活已完成及其代价。
	// Closing message: tell the player the revival completed and its cost.
	to_chat(performer, span_nicegreen("<b>诸神再次将你推上舞台。你以崭新而完美的姿态归来——却已记不起自己曾是谁。</b>"))

// return_ghost_to_body：若玩家死亡后变成观察者鬼魂，尝试把其客户端送回复活的躯体。
// return_ghost_to_body: if the player became an observer ghost on death, try to re-enter the body.
/datum/component/never_ending_performer/proc/return_ghost_to_body(mob/living/carbon/human/performer)
	// 若客户端已经在躯体里（从未离开），无需处理。
	// If the client is already in the body (never left), nothing to do.
	if(performer.client)
		return
	// 没有 mind 就无法定位对应的鬼魂，放弃。
	// Without a mind we cannot locate the matching ghost; abort.
	if(!performer.mind)
		return
	// 查找与该人物绑定、且当前持有客户端的鬼魂。
	// Find the ghost bound to this performer that currently holds a client.
	var/mob/dead/observer/ghost = performer.mind.get_ghost(ghosts_with_clients = TRUE)
	// 找到鬼魂则调用主线的 reenter_corpse()，它内部会做安全校验（如能否回到躯体）。
	// If found, call mainline reenter_corpse(); it performs its own safety checks internally.
	if(ghost)
		ghost.reenter_corpse()

// wipe_performer_memories：清除角色记忆。复用主线 mind.wipe_memory() 清空笔记本，
// 再附上一段醒目的失忆提示，作为角色扮演的硬性约束。
// wipe_performer_memories: clears memories via mainline mind.wipe_memory() and posts a
// prominent amnesia prompt as a roleplay constraint.
/datum/component/never_ending_performer/proc/wipe_performer_memories(mob/living/carbon/human/performer)
	// 有 mind 才有可清除的记忆笔记。
	// Only minds carry the memory notes we can wipe.
	if(performer.mind)
		// wipe_memory() 是主线提供的接口，会把 mind.memory 文本清空。
		// wipe_memory() is the mainline hook that blanks the mind.memory text.
		performer.mind.wipe_memory()
	// 强提示：游戏无法强制玩家「忘记」，因此用醒目文本明确告知失忆的角色扮演要求。
	// Strong prompt: the engine can't force a player to forget, so we spell out the RP rule.
	to_chat(performer, span_userdanger("你的脑海一片空白——过往的一切记忆都已消散。从此刻起，请将你的角色当作毫无前尘记忆之人来扮演。"))

// restore_initial_skills：把技能等级与经验还原到进入游戏时的快照状态。
// restore_initial_skills: rolls skill levels & experience back to the game-entry snapshot.
/datum/component/never_ending_performer/proc/restore_initial_skills(mob/living/carbon/human/performer)
	// 没有有效快照（极端情况下拍摄失败）就跳过，避免把技能清成空表。
	// If no valid snapshot exists (snapshot failed in an edge case), skip to avoid wiping skills empty.
	if(!islist(initial_known_skills) || !islist(initial_skill_experience))
		return
	// 取得技能持有者；若不存在则没有可还原的对象。
	// Fetch the skill holder; without one there is nothing to restore.
	var/datum/skill_holder/holder = performer.ensure_skills()
	if(!holder)
		return
	// 直接以快照副本覆盖内部存储。known_skills / skill_experience 即为引擎的真实技能状态，
	// 覆盖它们即可让所有等级/经验回到起始值；再次 .Copy() 防止快照被后续训练改写。
	// Overwrite the engine's real skill state with snapshot copies. known_skills / skill_experience
	// ARE the canonical stores, so replacing them resets all levels/exp; copy again so future
	// training can't mutate our preserved snapshot.
	holder.known_skills = initial_known_skills.Copy()
	holder.skill_experience = initial_skill_experience.Copy()

// 取消两个仅在本文件内使用的计时宏，避免污染全局编译命名空间。
// （TRAIT_DESIGNATED_PERFORMER 保留为全局可见，便于其它系统用 HAS_TRAIT 查询，
//   与 modular_z121 内 TRAIT_WISH_UNCAPPED 等的约定保持一致。）
// Undefine the two file-local timing macros to keep the global namespace clean.
// (TRAIT_DESIGNATED_PERFORMER is intentionally left defined so other systems can query it
//  via HAS_TRAIT, matching the convention of TRAIT_WISH_UNCAPPED, etc., in modular_z121.)
#undef NEVER_ENDING_REVIVE_DELAY
#undef NEVER_ENDING_DAILY_COOLDOWN
