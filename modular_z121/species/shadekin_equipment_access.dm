// =====================================================================================
// 暗影裔 装备准入修复 / Shadekin equipment-access fix
// -------------------------------------------------------------------------------------
// 问题(Bug)：暗影裔无法穿戴许多常见装备(衣物/护甲/斗篷/手套/鞋/头饰等)。
// 根因：每件衣物(/obj/item/clothing)在 mob_can_equip() 里用 `H.dna.species.type in allowed_race`
//   判定该种族能否穿戴；allowed_race 默认 = 宏 CLOTHED_RACES_TYPES，子类型又改写为
//   NON_DWARVEN_RACE_TYPES / ALL_RACES_TYPES 等。这些宏写死在 code/__DEFINES/roguetown.dm 中，
//   且 **均不含** /datum/species/shadekin → 绝大多数衣物对暗影裔判为"不可穿戴"。
//
// 为什么改用本方案(之前的 bootstrap+initial() 方案失效)：
//   之前试图在启动时用 `initial(类型.allowed_race) += shadekin` 修改"编译期共享列表"。但实测无效——
//   BYOND 的 initial() 对 list 返回的并不可靠地等于实例运行时所用的那个列表对象(可能是副本，或实例
//   在别处另建了列表)，因此对它的追加不会反映到穿戴判定上。
// 关键洞察(可靠的挂载点)：衣物的 mob_can_equip() 会先 `. = ..()`，其链路为
//   /obj/item/clothing/mob_can_equip → ..() → /obj/item/mob_can_equip → M.can_equip(I,...) →
//   /mob/living/carbon/human/can_equip → **dna.species.can_equip(I,...)**，
//   而 allowed_race 检查发生在该 `..()` 返回**之后**。也就是说：种族的 can_equip() 一定在
//   allowed_race 判定**之前**执行，并且能直接拿到待穿戴的物品 I。
// 解决：在 /datum/species/shadekin/can_equip() 里，对"已允许野民(anthromorph)"的衣物**就地**把暗影裔
//   补进它的 allowed_race(改的是真正的实例变量，必然生效)，再 ..()。等控制权回到衣物的 mob_can_equip，
//   allowed_race 检查便会通过。该 proc 是子类型新覆盖，不与基类重复定义(不会编译报错)，且只对暗影裔生效。
//
// Why this approach (the earlier bootstrap+initial() one didn't work): mutating
// `initial(type.allowed_race)` at startup proved ineffective — BYOND's initial() on a list does not
// reliably return the exact list object instances use at equip time, so appends didn't reach the gate.
// Reliable hook: /obj/item/clothing/mob_can_equip() runs `. = ..()` first, whose chain reaches
// dna.species.can_equip(I, ...), and the allowed_race check happens AFTER that returns. So the species'
// can_equip() always runs BEFORE the allowed_race gate and has the item I in hand. We override
// /datum/species/shadekin/can_equip() to add Shadekin into the garment's REAL instance allowed_race
// (guaranteed effective) whenever it already allows Wild-Kin, then call ..(). When control returns to
// the clothing gate, the check passes. This override is a new subtype proc (no duplicate-definition
// compile error) and only affects Shadekin wearers.
//
// 策略仍与"职业准入"一致：镜像已被主线接纳的拟人兽族【野民/anthromorph】——凡允许野民的衣物也允许
// 暗影裔；只允许精灵/哥布林等的专属装备则同样排除。详见 [[custom-species-conventions]] 的 GOTCHA #2。
// Strategy mirrors the job-access fix: shadow Wild-Kin (anthromorph). Garments that fit Wild-Kin fit
// Shadekin; elf/goblin-only gear stays excluded.
// =====================================================================================

// 覆盖暗影裔的装备判定：在主线 allowed_race 关卡之前，把"已允许野民"的衣物补允许暗影裔。
// Override Shadekin's equip check: just before the core allowed_race gate, also allow Shadekin on any
// garment that already allows Wild-Kin.
// 签名必须与基类 /datum/species/can_equip 完全一致，否则覆盖无效。
// The signature must exactly match the base /datum/species/can_equip, or the override won't take effect.
/datum/species/shadekin/can_equip(obj/item/I, slot, disable_warning, mob/living/carbon/human/H, bypass_equip_delay_self = FALSE)
	// 仅处理衣物：allowed_race 关卡只存在于 /obj/item/clothing/mob_can_equip()，非衣物物品不受其约束。
	// Only clothing matters: the allowed_race gate lives solely in /obj/item/clothing/mob_can_equip();
	// non-clothing items aren't gated by it.
	if(istype(I, /obj/item/clothing))
		// 取该衣物实例，准备读/改其 allowed_race。
		// Grab the clothing instance to read/patch its allowed_race.
		var/obj/item/clothing/checked_clothing = I
		// 镜像规则 + 去重 + 防御性 islist 检查：
		//   仅当 allowed_race 是有效列表、已包含野民、且尚未包含暗影裔时，才就地补入暗影裔。
		//   (allowed_race 为空/null 表示不限种族，本就可穿，无需处理。)
		// Mirror rule + de-dupe + defensive islist check: only when allowed_race is a real list that
		// already includes Wild-Kin and not yet Shadekin, append Shadekin in place. (A null/empty
		// allowed_race means "no race restriction" — already wearable, nothing to do.)
		if(islist(checked_clothing.allowed_race) \
			&& (/datum/species/anthromorph in checked_clothing.allowed_race) \
			&& !(/datum/species/shadekin in checked_clothing.allowed_race))
			// 就地追加：改的是衣物实例真正用于判定的那个列表，必然在随后的 allowed_race 关卡中生效。
			// Append in place: this is the very list the gate checks next, so the fix definitely lands.
			checked_clothing.allowed_race += /datum/species/shadekin

	// 继续走主线的种族装备判定(槽位/肢体/no_equip 等)，保持其余行为不变。
	// Continue with the stock species equip logic (slots/limbs/no_equip etc.), leaving the rest unchanged.
	return ..()
