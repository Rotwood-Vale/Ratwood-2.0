// ============================================================================
// Terror Clock (恐怖之钟)
// A craftable structure that, when activated by hand, lets the user pick a
// monster type and a quantity from a pop-up. The clock then rings once and,
// after a short delay, spawns the chosen monster wave on random open tiles
// around itself. To prevent it from being abused inside settlements, it refuses
// to operate unless its wide surroundings are free of any other buildings.
//
// All player-facing text is intentionally written in Chinese to match the
// fork's localisation; every code line is commented in English per project
// rules. This file lives ONLY under modular_z121, as required.
// ============================================================================

// --- Tunable constants -------------------------------------------------------
// Radius (in tiles) that must be completely clear of other buildings/walls
// before the clock is allowed to summon. Kept in sync with the Glaggar arena
// radius (GLAGGAR_ARENA_RADIUS in glaggar_challenge.dm) — both are 6.
#define TERROR_CLOCK_CLEAR_RANGE 6
// Radius (in tiles) inside which the summoned monsters may randomly appear.
#define TERROR_CLOCK_SUMMON_RANGE 5
// Delay between the clock ringing and the monsters actually materialising.
#define TERROR_CLOCK_SUMMON_DELAY (10 SECONDS)
// Hard cap on how many monsters a single activation may request, so a player
// cannot lag the server by asking for thousands of mobs at once.
#define TERROR_CLOCK_MAX_MONSTERS 10
// The boss-tier "Horrors" category is balance- and performance-sensitive (a void
// dragon alone is round-ending), so it gets a much lower per-summon cap. The
// label here MUST match the category key used in GLOB.terror_clock_roster below.
#define TERROR_CLOCK_BOSS_CATEGORY "梦魇"
#define TERROR_CLOCK_BOSS_MAX 2
// The special top-level option that launches the Glaggar's Glance challenge
// instead of a normal monster summon. Implemented in glaggar_challenge.dm.
#define TERROR_CLOCK_TRIAL_LABEL "格拉加尔的凝视"
// Cooldown enforced between two uses of the clock (any summon OR a trial), so it
// cannot be spammed. 5 minutes, as required.
#define TERROR_CLOCK_COOLDOWN (5 MINUTES)
// Radius (in tiles) the "Horror Bell" cleanses every time it rings: it erases
// non-player corpses, cleanable stains, and unanchored ground items around it.
#define TERROR_CLOCK_PURGE_RANGE 10

// Maps a human-readable Chinese label (shown in the pop-up) to the concrete mob
// typepath it spawns. Every entry is a verified, instantiable hostile mob in
// this codebase (some live in sibling modules that are compiled into the build,
// e.g. wolf_undead from modular_azurepeak, orc from modular_hearthstone), so the
// summon can never resolve to an abstract/missing type.
//
// The roster is a TWO-LEVEL nested list: the outer keys are the category labels
// shown in the first pop-up (野兽/怪物/人形), and each maps to an inner assoc
// list of (species label -> mob typepath) shown in the second pop-up. Keeping it
// nested means the pop-up flow can simply walk one level at a time, and adding a
// new category/species is a pure data edit with no logic change.
GLOBAL_LIST_INIT(terror_clock_roster, list(
	// === Category 1: Beasts (ordinary hostile wildlife & feral livestock) ======
	"野兽" = list(
		"恶狼" = /mob/living/simple_animal/hostile/retaliate/rogue/wolf,           // fast, low-HP pack hunter
		"赤狐" = /mob/living/simple_animal/hostile/retaliate/rogue/fox,            // small, skittish predator
		"野猪" = /mob/living/simple_animal/hostile/retaliate/rogue/swine,          // charging boar
		"公山羊" = /mob/living/simple_animal/hostile/retaliate/rogue/goatmale,     // ram-charging goat
		"公牛" = /mob/living/simple_animal/hostile/retaliate/rogue/bull,           // heavy charging bovine
		"母牛" = /mob/living/simple_animal/hostile/retaliate/rogue/cow,            // bulky but slow
		"野猫" = /mob/living/simple_animal/hostile/retaliate/rogue/cat,            // tiny nuisance clawer
		"母鸡" = /mob/living/simple_animal/hostile/retaliate/rogue/chicken,        // weak swarm filler
		"赛加羚羊" = /mob/living/simple_animal/hostile/retaliate/rogue/saiga,      // fast fleeing game beast
		"巨熊" = /mob/living/simple_animal/hostile/retaliate/rogue/direbear,       // powerful apex predator
	),
	// === Category 2: Monsters (unnatural / monstrous threats) ==================
	"怪物" = list(
		"巨鼠" = /mob/living/simple_animal/hostile/retaliate/rogue/bigrat,         // weak vermin swarm
		"巨型甲虫" = /mob/living/simple_animal/hostile/retaliate/rogue/beetle,     // armoured medium threat
		"泥蟹" = /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab,        // tanky melee
		"岩石蜘蛛" = /mob/living/simple_animal/hostile/retaliate/rogue/spider/rock, // ambusher
		"蜘蛛德莱厄" = /mob/living/simple_animal/hostile/retaliate/rogue/drider,   // spider-folk skirmisher
		"无头骑士" = /mob/living/simple_animal/hostile/retaliate/rogue/headless,   // dangerous undead elite
		"拉弥亚" = /mob/living/simple_animal/hostile/retaliate/rogue/lamia,        // serpentine monster
		"苔背兽" = /mob/living/simple_animal/hostile/retaliate/rogue/mossback,     // mossy turtle-beast
		"巨鼹" = /mob/living/simple_animal/hostile/retaliate/rogue/mole,           // burrowing monster
		"不死之狼" = /mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead, // reanimated wolf (modular_azurepeak)
		"巨魔" = /mob/living/simple_animal/hostile/retaliate/rogue/troll,          // heavy boss-tier monster
	),
	// === Category 3: Humanoids (hostile humanoid combatants) ===================
	"人形" = list(
		"兽人" = /mob/living/simple_animal/hostile/retaliate/rogue/orc,                  // savage orc melee (modular_hearthstone)
		"兽人长矛兵" = /mob/living/simple_animal/hostile/retaliate/rogue/orc/spear,       // reach orc
		"兽人弓手" = /mob/living/simple_animal/hostile/retaliate/rogue/orc/ranged,        // ranged orc
		"兽人劫掠者" = /mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder, // tougher raider orc
		"兽人蹂躏者" = /mob/living/simple_animal/hostile/retaliate/rogue/orc/orc_marauder/ravager, // elite orc bruiser
		"骷髅" = /mob/living/simple_animal/hostile/rogue/skeleton,                        // basic undead melee (note: NO 'retaliate' in path)
		"骷髅斧兵" = /mob/living/simple_animal/hostile/rogue/skeleton/axe,                // axe-armed skeleton
		"骷髅矛兵" = /mob/living/simple_animal/hostile/rogue/skeleton/spear,              // spear-armed skeleton
		"骷髅卫兵" = /mob/living/simple_animal/hostile/rogue/skeleton/guard,              // armoured skeleton
		"骷髅弓手" = /mob/living/simple_animal/hostile/rogue/skeleton/bow,                // ranged skeleton
		// Goblins & lizard-people are carbon/human NPCs (not simple_animals); they
		// self-initialise their species/equipment/AI in Initialize -> after_creation,
		// so a plain new(turf) spawns a fully-formed hostile combatant.
		"哥布林" = /mob/living/carbon/human/species/goblin/npc,                          // standard hostile goblin
		"洞穴哥布林" = /mob/living/carbon/human/species/goblin/npc/cave,                  // cave goblin variant
		"地狱哥布林" = /mob/living/carbon/human/species/goblin/npc/hell,                  // infernal goblin variant
		"蜥蜴人狱卒" = /mob/living/carbon/human/species/lizardfolk/psy_vault_guard/ambush, // HARD lizardfolk guard (hunts on sight)
	),
	// === Category 4: Horrors (boss-tier, truly terrifying summons) =============
	// These are extremely dangerous; each is self-contained (Initialize takes no
	// required summoner/portal arg) so it spawns safely from a plain new(turf).
	"梦魇" = list(
		"炎之原初体" = /mob/living/simple_animal/hostile/retaliate/rogue/primordial/fire,  // fire elemental primordial
		"水之原初体" = /mob/living/simple_animal/hostile/retaliate/rogue/primordial/water, // water elemental primordial
		"风之原初体" = /mob/living/simple_animal/hostile/retaliate/rogue/primordial/air,   // air elemental primordial
		"地狱犬" = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound,   // demonic hound
		"恶鬼" = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend,         // demonic fiend (wound-immune)
		"虚空巨龙" = /mob/living/simple_animal/hostile/retaliate/rogue/voiddragon,         // void dragon — apocalyptic boss
	),
))

// --- The structure itself ----------------------------------------------------
/obj/structure/terror_clock
	// Player-facing identity (Chinese, matching the fork's convention).
	name = "恐怖之钟"
	desc = "一座散发着不祥气息的落地钟。传说敲响它便能召唤令人胆寒的怪物浪潮，使用时务必慎之又慎。"
	// Texture borrowed from the stationary church bell (/obj/structure/stationary_bell):
	// a 96x96 sprite, so it shares that structure's layer/plane below.
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "churchbell"
	// A 96px-wide sprite has its left edge on the tile by default, which makes it
	// LOOK one tile to the right of its real turf. pixel_x = -32 re-centers the
	// sprite over its turf — this is the repo convention for 96x96 structures and
	// it removes the apparent "deviation" between the clock and the arena ring
	// (and the related illusion of edge monsters slipping past the barrier).
	pixel_x = -32
	// The clock is a solid, fixed installation: block movement and stop it from
	// being shoved around so its "clear radius" check stays meaningful.
	density = TRUE
	anchored = TRUE
	// Draw it above mobs like the vanilla clock so the tall sprite looks right.
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	// Combat/destruction profile copied from the vanilla decorative clock so it
	// can be smashed by players who want to stop the summons.
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 200
	integrity_failure = 0.5
	break_sound = "glassbreak"
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	// Internal busy flag: TRUE between the ring and the spawn so the clock cannot
	// be re-triggered (and cannot queue overlapping waves) while it is "charging".
	var/summoning = FALSE
	// The currently-running Glaggar's Glance challenge (if any). While set, the
	// clock is locked into the trial and cannot be used for anything else. The
	// challenge controller clears this back to null when it finishes/aborts.
	var/datum/glaggar_challenge/active_challenge
	// Tracks the 5-minute reuse cooldown shared by both normal summons and trials.
	COOLDOWN_DECLARE(summon_cooldown)

// Handle destruction. The borrowed church-bell texture has no dedicated broken
// state, so we keep the current sprite and just let the parent run its logic
// (integrity/debris/sound) rather than swapping to a non-existent "b..." state.
/obj/structure/terror_clock/obj_break(damage_flag)
	..()

// Main interaction entry point: an empty-hand click activates the summon flow.
/obj/structure/terror_clock/attack_hand(mob/user)
	// Only living mobs can operate the mechanism; defer anything else to default.
	if(!isliving(user))
		return ..()
	var/mob/living/L = user
	// A broken clock is inert; tell the user instead of silently doing nothing.
	if(obj_broken)
		to_chat(L, span_warning("这座钟已经损毁，无法敲响。"))
		return
	// Guard against double-activation while a wave is already pending.
	if(summoning)
		to_chat(L, span_warning("钟声仍在回荡，怪物即将降临，现在无法再次敲响。"))
		return
	// Guard against using the clock while a Glaggar's Glance trial is in progress.
	if(active_challenge)
		to_chat(L, span_warning("格拉加尔的试炼正在进行，此钟暂时无法使用。"))
		return
	// Enforce the 5-minute reuse cooldown shared by summons and trials. We check
	// it BEFORE opening any menu so a player can't even start picking on cooldown.
	if(!COOLDOWN_FINISHED(src, summon_cooldown))
		// Report the remaining time (rounded up to whole seconds) for clarity.
		to_chat(L, span_warning("恐怖之钟的力量尚未恢复，还需 [CEILING(COOLDOWN_TIMELEFT(src, summon_cooldown) / 10, 1)] 秒。"))
		return
	// Apply a standard melee click cooldown so this can't be machine-gun clicked.
	L.changeNext_move(CLICK_CD_MELEE)
	// Refuse to operate if any building/wall sits inside the required clear zone.
	// We check BEFORE prompting so we don't waste the player's menu interaction.
	var/atom/obstruction = get_blocking_building()
	if(obstruction)
		to_chat(L, span_warning("附近 [TERROR_CLOCK_CLEAR_RANGE] 格范围内存在建筑（[obstruction.name]），钟无法运作。请在空旷处使用。"))
		return
	// Pop-up #1: choose the broad CATEGORY first (野兽/怪物/人形). The outer keys
	// of the nested roster are exactly the category labels we want to show.
	var/category = tgui_input_list(L, "你要召唤何种类别的存在？", "恐怖之钟", GLOB.terror_clock_roster)
	// A null choice means the player closed/cancelled the dialog: abort cleanly.
	if(isnull(category))
		return
	// Drill into the chosen category to get its (species label -> typepath) list.
	var/list/species_list = GLOB.terror_clock_roster[category]
	// Defensive guard: a malformed/empty category would leave nothing to pick.
	if(!islist(species_list) || !length(species_list))
		to_chat(L, span_warning("这个类别中没有可召唤的存在，召唤失败。"))
		return
	// Pop-up #2: choose the specific SPECIES within the chosen category.
	var/choice = tgui_input_list(L, "选择具体的[category]种类：", "恐怖之钟", species_list)
	// Cancelled species dialog -> abort.
	if(isnull(choice))
		return
	// Resolve the label back into the real mob typepath; bail if somehow invalid.
	var/mob_type = species_list[choice]
	if(!ispath(mob_type, /mob/living))
		to_chat(L, span_warning("无法识别所选的存在，召唤失败。"))
		return
	// Boss-tier summons are gated to a much smaller maximum than ordinary ones,
	// so a single ring can't drop a swarm of round-ending horrors on the station.
	var/max_amount = (category == TERROR_CLOCK_BOSS_CATEGORY) ? TERROR_CLOCK_BOSS_MAX : TERROR_CLOCK_MAX_MONSTERS
	// Pop-up #3: choose how many to summon, clamped to a safe 1..max_amount range.
	var/amount = tgui_input_number(L, "要召唤多少只？（最多 [max_amount] 只）", "恐怖之钟", 1, max_amount, 1)
	// Cancelled number dialog -> abort.
	if(isnull(amount))
		return
	// Defensively re-clamp in case the UI returned an out-of-band value.
	amount = clamp(round(amount), 1, max_amount)

	// The world may have changed while the menus were open (someone built next
	// to us, or the clock got broken/destroyed), so re-validate every condition.
	if(QDELETED(src) || obj_broken)
		return
	if(summoning)
		to_chat(L, span_warning("钟声仍在回荡，无法再次敲响。"))
		return
	obstruction = get_blocking_building()
	if(obstruction)
		to_chat(L, span_warning("附近出现了建筑（[obstruction.name]），召唤被打断。"))
		return

	// Commit: lock the clock, start the 5-minute reuse cooldown, ring it once,
	// and warn everyone nearby.
	summoning = TRUE
	COOLDOWN_START(src, summon_cooldown, TERROR_CLOCK_COOLDOWN)
	// A single ominous toll (one bell strike, as specified). ring_bell() also runs
	// the Horror Bell cleanse so each toll wipes the battlefield around the clock.
	ring_bell()
	visible_message(span_danger("[src]发出一声低沉的轰鸣，空气中弥漫开令人胆寒的气息……"))
	to_chat(L, span_danger("你敲响了恐怖之钟。[TERROR_CLOCK_SUMMON_DELAY / 10] 秒后，怪物将会降临。"))
	// Schedule the actual spawn after the delay. We pass the chosen type/amount
	// and the activator so the summon proc is fully self-contained.
	addtimer(CALLBACK(src, PROC_REF(do_summon), mob_type, amount, L), TERROR_CLOCK_SUMMON_DELAY)

// Launches the Glaggar's Glance challenge from this clock. Validates the same
// "clear surroundings" rule (the arena needs room) before spinning up the
// dedicated /datum/glaggar_challenge controller, which owns the whole event.
/obj/structure/terror_clock/proc/start_glaggar_challenge(mob/living/user)
	// Re-check the no-buildings rule: the challenge erects a barrier ring at the
	// clear radius, so the surroundings must be clear or the arena can't form.
	var/atom/obstruction = get_blocking_building()
	if(obstruction)
		to_chat(user, span_warning("附近 [TERROR_CLOCK_CLEAR_RANGE] 格范围内存在建筑（[obstruction.name]），无法举行格拉加尔的试炼。"))
		return
	// Guard against a race where a challenge somehow already started.
	if(active_challenge)
		to_chat(user, span_warning("格拉加尔的试炼已在进行中。"))
		return
	// Create the controller and try to start it; mark the clock busy on success.
	var/datum/glaggar_challenge/challenge = new()
	active_challenge = challenge
	// start() returns FALSE and self-deletes on failure; clear our ref if so.
	if(!challenge.start(src, user))
		active_challenge = null
		return
	// The trial counts as a "use": start the shared 5-minute reuse cooldown.
	COOLDOWN_START(src, summon_cooldown, TERROR_CLOCK_COOLDOWN)

// Scans the surrounding CLEAR_RANGE tiles for anything that counts as a
// "building" and returns the first offender found, or null if the area is clear.
// We treat both wall turfs (/turf/closed) and placed structures as buildings.
/obj/structure/terror_clock/proc/get_blocking_building()
	// Walls and other closed turfs are buildings -> any within range blocks use.
	for(var/turf/closed/wall_turf in range(TERROR_CLOCK_CLEAR_RANGE, src))
		return wall_turf
	// Any structure other than ourselves also counts as a building.
	for(var/obj/structure/found in range(TERROR_CLOCK_CLEAR_RANGE, src))
		// Skip our own clock so it never blocks itself.
		if(found == src)
			continue
		return found
	// Nothing obstructive found -> the surroundings are clear enough to summon.
	return null

// Builds and returns the list of turfs around the clock that a monster can
// legally spawn onto (open, non-dense, and not blocked by a dense atom).
/obj/structure/terror_clock/proc/get_valid_spawn_turfs()
	// Accumulate every usable turf so the caller can pick from it at random.
	var/list/valid = list()
	for(var/turf/T in range(TERROR_CLOCK_SUMMON_RANGE, src))
		// Skip walls/space and any inherently impassable turf.
		if(!isopenturf(T) || T.density)
			continue
		// Skip the clock's own tile -> never spawn a monster on top of it.
		if(T == get_turf(src))
			continue
		// Reject the turf if any dense object would trap/overlap the new mob.
		var/blocked = FALSE
		for(var/atom/movable/AM in T)
			if(AM.density)
				blocked = TRUE
				break
		if(blocked)
			continue
		// Turf passed every check -> it is a valid spawn location.
		valid += T
	return valid

// Fires after the delay: actually materialises the requested monster wave.
// Arguments mirror what attack_hand captured at activation time.
/obj/structure/terror_clock/proc/do_summon(mob_type, amount, mob/living/user)
	// Release the busy lock no matter what happens below, so the clock can be
	// used again afterwards (or after a failed attempt).
	summoning = FALSE
	// If the clock was destroyed/deleted or broken during the countdown, abort
	// the summon entirely rather than spawning from a corpse of a structure.
	if(QDELETED(src) || obj_broken)
		return
	// Re-validate the typepath defensively (in case of a bad caller).
	if(!ispath(mob_type, /mob/living))
		return
	// Find every legal spawn tile right now (the map may have shifted).
	var/list/spawn_turfs = get_valid_spawn_turfs()
	// Error handling: with nowhere to place monsters, fail loudly but safely.
	if(!length(spawn_turfs))
		visible_message(span_warning("[src]的钟声归于沉寂——周围没有可供怪物现身的空地，召唤落空了。"))
		return
	// Track how many we actually managed to place for honest feedback.
	var/spawned = 0
	for(var/i in 1 to amount)
		// Pick a random valid tile for each monster so the wave spreads out.
		var/turf/target = pick(spawn_turfs)
		// Guard the instantiation so one bad spawn can't abort the whole wave.
		var/mob/living/M = new mob_type(target)
		if(QDELETED(M))
			continue
		// Kick the newly-spawned mob into an active, target-seeking AI state so it
		// charges the players immediately instead of standing idle until attacked.
		terror_clock_awaken_mob(M)
		spawned++
	// Announce the outcome and play a final flourish if anything appeared. The
	// flourish toll also triggers another Horror Bell cleanse via ring_bell().
	if(spawned)
		visible_message(span_danger("伴随着[src]最后的余音，[spawned] 只怪物凭空浮现，獠牙毕露！"))
		ring_bell()
	else
		// Every spawn failed (e.g. all types qdel'd on Initialize): report it.
		visible_message(span_warning("[src]的钟声散去，却没有任何怪物现身。"))

// Rings the Horror Bell once: plays the toll AND cleanses the surroundings. All
// "bell rings" go through here so the cleanse and the sound never drift apart.
/obj/structure/terror_clock/proc/ring_bell()
	// The single ominous toll, audible over a wide radius.
	playsound(src, 'sound/misc/bell.ogg', 100, FALSE, extrarange = 7)
	// Cleanse the battlefield each time the bell sounds.
	purge_surroundings()

// Horror Bell cleanse: within TERROR_CLOCK_PURGE_RANGE tiles, delete non-player
// corpses, cleanable stains, and unanchored ground items. Deliberately spares
// living mobs, anything a player owns/controls (so corpses stay revivable), the
// clock itself, and the challenge barriers/structures.
/obj/structure/terror_clock/proc/purge_surroundings()
	// Iterate every atom in range once; branch on what kind of thing it is.
	for(var/atom/movable/AM in range(TERROR_CLOCK_PURGE_RANGE, src))
		// --- Non-player corpses ---------------------------------------------
		if(isliving(AM))
			var/mob/living/M = AM
			// Only DEAD bodies are "corpses"; never touch the living.
			if(M.stat != DEAD)
				continue
			// Protect anything that is, or ever was, a player: a present client
			// (ckey) or a mind that still remembers a player key (ghosted but
			// revivable). Such corpses must remain so they can be brought back.
			if(M.ckey || (M.mind && M.mind.key))
				continue
			// Pure NPC/animal corpse -> erase it.
			qdel(M)
			continue
		// --- Cleanable stains (blood, vomit, ash, ...) ----------------------
		if(istype(AM, /obj/effect/decal/cleanable))
			qdel(AM)
			continue
		// --- Unanchored ground items ----------------------------------------
		if(isitem(AM))
			var/obj/item/I = AM
			// Only items lying directly on a turf count as "on the ground";
			// skip things held/stored inside mobs or containers.
			if(!isturf(I.loc))
				continue
			// Respect anchored items (rare, but never yank fixed fixtures).
			if(I.anchored)
				continue
			qdel(I)

// 让刚生成的敌对生物立即进入战斗，而不是站桩等待被玩家先手攻击。
// 根因：/mob/living/simple_animal/hostile 生成时，其 AI 常处于 AI_IDLE —— consider_wakeup()
// 在“附近暂未探测到客户端”时会把 AI 置为 IDLE，此状态下不会主动索敌，直到被打中触发
// Retaliate()→toggle_ai(AI_ON) 才苏醒。这正是“站着不动，被打才反击”的现象。
// 解决办法：生成后立刻强制索敌一次；FindTarget() 命中目标后会经 GiveTarget() 自动把
// AI 切到 AI_ON 并开始追击，从而消除延迟。人形 NPC 走另一套 AI，只需保证其 mode 不是 OFF。
/proc/terror_clock_awaken_mob(mob/living/M)
	// 空值/已删除保护：极端情况下 Initialize 可能已把怪物删除。
	if(QDELETED(M))
		return
	// —— 简单敌对动物（狼 / 骷髅 / 巨魔 / 兽人 / 地狱犬 / 巨熊 / 拉弥亚……）——
	if(istype(M, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/H = M
		// 先确保 AI 主循环处于开启状态（防止它一直处于 IDLE 不处理）。
		H.toggle_ai(AI_ON)
		// 立刻扫描一次目标：命中后 GiveTarget() 会再次确保 AI_ON 并即刻开始追击。
		H.FindTarget()
		return
	// —— 人形 NPC（哥布林 / 强盗 / 癫狂骑士 / 卓尔劫掠者 / 蜥蜴人狱卒……）——
	// 它们用 carbon/human 的 NPC AI：只要 mode≠OFF 且 aggressive=1，handle_combat() 每拍都会
	// 在视野内主动索敌。这些类型默认已是 aggressive=1、mode=NPC_AI_IDLE，这里仅做兜底：
	// 若个别实例卡在 NPC_AI_OFF，则纠正为 IDLE，使其恢复索敌。
	if(ishuman(M))
		var/mob/living/carbon/human/HN = M
		if(HN.mode == NPC_AI_OFF)
			HN.mode = NPC_AI_IDLE

// --- Clean up the file-local defines so they don't leak globally -------------
#undef TERROR_CLOCK_CLEAR_RANGE
#undef TERROR_CLOCK_SUMMON_RANGE
#undef TERROR_CLOCK_SUMMON_DELAY
#undef TERROR_CLOCK_MAX_MONSTERS
#undef TERROR_CLOCK_BOSS_CATEGORY
#undef TERROR_CLOCK_BOSS_MAX
#undef TERROR_CLOCK_TRIAL_LABEL
#undef TERROR_CLOCK_COOLDOWN
#undef TERROR_CLOCK_PURGE_RANGE
