// ============================================================================
// 补血剂 (Blood Tonic) reagent — the product of the simple alchemy formula.
// 中文：这是“补血剂”简易炼金配方的产物试剂。配方：水蛭x2 + 50单位水 + 玻璃瓶x1
//       → 1瓶装满补血剂的玻璃瓶（见 modular_z121/crafting/blood_tonic_recipe.dm）。
// WHY a dedicated reagent: the recipe must (1) stop bleeding from the drinker's
// wounds and (2) restore a large amount of blood. We model both effects in
// on_mob_life(), mirroring how the engine's health potion / lesser-miracle buff
// already touch blood_volume, heal_wounds() and the wound bleed-rate system.
// This file lives ONLY under modular_z121, as required by the project rules.
// ============================================================================

// 中文：补血剂试剂定义，继承 /datum/reagent/medicine 以归入“药剂”大类。
// WHY subclass /datum/reagent/medicine: inherits standard medicine metabolism
// plumbing and groups it with the other brewed potions in the codebase.
/datum/reagent/medicine/blood_tonic
	// 中文：试剂显示名称（中文，贴合本分支的本地化）。
	name = "补血剂"											// In-game name shown to players.
	// 中文：检视/说明文本，描述其止血与补血的功效。
	description = "一种以水蛭熬制的赤褐色浓稠药液，能凝合伤口的渗血并大量补充失去的鲜血。"	// Flavour + mechanical hint.
	// 中文：物理状态为液体，影响泼洒/容器表现。
	reagent_state = LIQUID									// It is a drinkable liquid.
	// 中文：颜色设为“赤褐色”——任务硬性要求。锅中的药液也会因此染成赤褐色。
	color = "#7a2d18"										// REQUIRED reddish-brown colour (tints the pot too).
	// 中文：入口味道描述。
	taste_description = "铁锈与陈血"							// Taste flavour text (iron + old blood).
	// 中文：代谢速率，沿用标准药剂代谢，使疗效随时间平稳释放。
	metabolization_rate = REAGENTS_METABOLISM				// Standard per-tick metabolism speed.
	// 中文：半透明显示，符合其它药水的观感。
	alpha = 180												// Slight transparency, matching other potions.

// 中文：每代谢一拍触发一次的疗效逻辑（M 为饮用者，必为 carbon）。
// WHY: this is where the two promised effects actually execute every life tick.
/datum/reagent/medicine/blood_tonic/on_mob_life(mob/living/carbon/M)
	// 中文：错误防护——若饮用者无效或正在被删除，立即交回父级处理，避免空引用。
	if(!M || QDELETED(M))									// Guard against a missing/deleted mob.
		return ..()											// Defer to parent for clean reagent bookkeeping.

	// 中文：构造体/不流血生物没有血液系统，跳过血量与止血逻辑，避免无意义操作或报错。
	// WHY: constructs (golems, undead constructs) have no real bloodstream.
	if(!M.construct)										// Only living, blood-bearing bodies benefit.
		// ---- 效果一：止血 / Effect 1: stop bleeding from wounds ----
		// 中文：取得该 mob 身上所有伤口（carbon 会汇总各肢体的伤口）。
		var/list/all_wounds = M.get_wounds()				// Collect every wound on the body.
		// 中文：仅在确有伤口时遍历，避免空循环。
		if(length(all_wounds))								// Only iterate if wounds actually exist.
			// 中文：逐个把伤口的出血速率清零——这就是“凝合渗血”的实现。
			for(var/datum/wound/W as anything in all_wounds)	// Walk each wound datum.
				// 中文：防御性判空，列表可能含已失效项。
				if(isnull(W))								// Skip stale/null entries defensively.
					continue								// Move on to the next wound.
				// 中文：set_bleed_rate(0) 会把该伤口对肢体出血的贡献抹平。
				W.set_bleed_rate(0)							// Clamp this wound's bleeding to zero.
		// 中文：刷新出血总值缓存，让 HUD/生命循环立刻反映止血结果。
		M.bleed_rate = M.get_bleed_rate()					// Recompute the cached total bleed rate.

		// ---- 效果二：大量补血 / Effect 2: restore a large amount of blood ----
		// 中文：当血量低于正常值时，每拍回补 20 点，直到恢复到正常血量上限。
		// WHY a min(): never overshoot BLOOD_VOLUME_NORMAL (no infinite blood).
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)			// Only top up if below normal.
			M.blood_volume = min(M.blood_volume + 20, BLOOD_VOLUME_NORMAL)	// Strong, capped refill.

		// ---- 附带：轻度愈合伤口本身，使“止血”更具持续性 ----
		// 中文：顺带愈合少量伤口生命值，否则伤口下一拍可能再次开始渗血。
		if(length(all_wounds))								// Re-use the wound presence we already checked.
			M.heal_wounds(3)								// Gently knock down wound HP each tick.
			// 中文：更新受伤外观贴图，让视觉与数值同步。
			M.update_damage_overlays()						// Keep damage overlays in sync.

	// 中文：交回父级完成标准的试剂消耗与生命循环收尾。
	return ..()											// Let the base medicine reagent finish up.


// ============================================================================
// 装满补血剂的玻璃瓶 — the crafted PRODUCT of the recipe.
// 中文：这是配方的成品——一个预先装好 50 单位补血剂的玻璃瓶。
// WHY a pre-filled bottle subtype: the engine's standard pattern for "a bottle
// that comes filled with potion X" is exactly this (see the vanilla
// /obj/item/reagent_containers/glass/bottle/rogue/healthpot etc. — each just sets
// list_reagents). Because this subtype ONLY ever exists as the craft output,
// having it spawn already filled is correct and needs no extra post-craft code.
// The crafting recipe simply uses this type as its `result`.
// ============================================================================
/obj/item/reagent_containers/glass/bottle/rogue/blood_tonic
	// 中文：瓶子里预装 50 单位补血剂（与其它药水瓶一致的容量）。
	list_reagents = list(/datum/reagent/medicine/blood_tonic = 50)	// Pre-filled with the Blood Tonic.
