// ============================================================================
// 催乳剂 (Lactation Enhancing Agent) reagent — the product of an alchemy formula.
// 中文：这是“催乳剂”炼金配方的产物试剂。配方：骨头x2 + 玻璃瓶x1 + 50单位水 + 10单位牛奶
//       → 1瓶装满 50 单位催乳剂的玻璃瓶（见 modular_z121/crafting/lactation_enhancer_recipe.dm）。
// WHY a dedicated reagent: the brief asks for a "breastfeeding potion" — when a
// character WHO CAN PRODUCE MILK drinks it, their milk regenerates much faster
// for a limited time. The vanilla milk-regen loop in species.dm only refills
// breasts.milk_stored by HUNGER_FACTOR (0.15) per life tick and costs nutrition.
// We model the boost by topping up breasts.milk_stored directly each metabolism
// tick (capped at milk_max), so the effect is real, self-contained, and obeys
// the project rule that nothing outside modular_z121 may be edited.
// The "certain period of time" falls out naturally: 50u metabolised at
// REAGENTS_METABOLISM per tick gives a bounded duration with no extra timers.
// ============================================================================

// 中文：催乳剂试剂定义，继承 /datum/reagent/medicine 以归入“药剂”大类，
//       与本分支其它酿造药水（如补血剂）保持一致的代谢管线。
// WHY subclass /datum/reagent/medicine: inherits standard medicine metabolism
// plumbing and groups it with the other brewed potions in the codebase.
/datum/reagent/medicine/lactation_enhancer
	// 中文：试剂显示名称（中文，贴合本分支的本地化）。
	name = "催乳剂"											// In-game name shown to players.
	// 中文：检视/说明文本，描述其“加速泌乳恢复”的功效。
	description = "一种以骨粉与鲜奶熬煮的乳白色温润药液，能在一段时间内显著加快泌乳的恢复速度。"	// Flavour + mechanical hint.
	// 中文：物理状态为液体，影响泼洒/容器表现。
	reagent_state = LIQUID									// It is a drinkable liquid.
	// 中文：颜色设为乳白色，锅中的药液也会因此染成乳白色。
	color = "#f5f0e6"										// Milky off-white colour (tints the pot too).
	// 中文：入口味道描述。
	taste_description = "温热的奶香与淡淡骨髓味"				// Taste flavour text (warm milk + faint marrow).
	// 中文：代谢速率，沿用标准药剂代谢，使疗效随时间平稳释放，也决定了药效持续时长。
	metabolization_rate = REAGENTS_METABOLISM				// Standard per-tick metabolism speed.
	// 中文：半透明显示，符合其它药水的观感。
	alpha = 200												// Slight transparency, matching other potions.

	// 中文：每代谢一拍补充的泌乳量（单位/拍）。基础自然恢复仅 HUNGER_FACTOR(0.15)/拍，
	//       此处给到 5/拍，约为自然恢复的 30 倍，即题目所要求的“大幅加快恢复速度”。
	// WHY a tunable var: keeps the balance number in one obvious place and makes the
	// "greatly increase the speed" requirement explicit and easy to adjust.
	var/milk_regen_bonus = 5								// Bonus milk restored per metabolism tick.

// 中文：每代谢一拍触发一次的疗效逻辑（M 为饮用者，必为 carbon）。
// WHY: this is where the promised effect actually executes every life tick.
/datum/reagent/medicine/lactation_enhancer/on_mob_life(mob/living/carbon/M)
	// 中文：错误防护——若饮用者无效或正在被删除，立即交回父级处理，避免空引用。
	if(!M || QDELETED(M))									// Guard against a missing/deleted mob.
		return ..()											// Defer to parent for clean reagent bookkeeping.

	// 中文：泌乳系统只存在于 human 身上（has_breasts() 仅 human 返回有效器官），
	//       非 human 直接跳过疗效，药液无害地代谢掉，避免在无关 mob 上报错。
	// WHY ishuman guard: has_breasts()/ORGAN_SLOT_BREASTS only exist on humans;
	// calling on anything else would be meaningless or runtime-error.
	if(!ishuman(M))											// Only humans have the lactation organ system.
		return ..()											// Harmlessly metabolise on non-humans.

	// 中文：取得乳房器官。能否“产奶”取决于是否拥有该器官，这正是题目所说的
	//       “能够产出乳汁的角色”。
	var/mob/living/carbon/human/H = M						// Narrow the type to reach human procs.
	var/obj/item/organ/breasts/B = H.has_breasts()			// Fetch the breasts organ (or null).

	// 中文：错误处理——没有乳房器官的角色无法产奶，药剂对其无泌乳效果，
	//       直接交回父级正常代谢，不报错、不浪费逻辑。
	if(isnull(B))											// No breasts → cannot produce milk.
		return ..()											// No lactation benefit; just metabolise.

	// 中文：必须处于“泌乳(lactating)”状态才能恢复乳汁——与 species.dm 的自然恢复
	//       判定保持一致。未泌乳者饮用同样无害但无效。
	// WHY mirror the engine check: avoids forcing milk on a non-lactating body,
	// keeping behaviour consistent with the vanilla milk-regen rules.
	if(!B.lactating)										// Not currently lactating → nothing to boost.
		return ..()											// Harmless, but no effect this tick.

	// 中文：仅在尚未装满时补充，避免溢出 milk_max（无限产奶）。
	// WHY the cap: never exceed the organ's milk_max storage ceiling.
	if(B.milk_stored < B.milk_max)							// Only top up if there is free capacity.
		// 中文：用 min() 把本拍补充量限制在“剩余容量”之内，刚好填满即停。
		var/milk_to_add = min(milk_regen_bonus, B.milk_max - B.milk_stored)	// Clamp to remaining space.
		// 中文：把加速恢复的乳汁直接计入存储——这就是“加快泌乳恢复”的实现。
		B.milk_stored += milk_to_add						// Apply the accelerated recovery.

	// 中文：交回父级完成标准的试剂消耗与生命循环收尾（含按 metabolization_rate 扣量）。
	return ..()											// Let the base medicine reagent finish up.


// ============================================================================
// 装满催乳剂的玻璃瓶 — the crafted PRODUCT of the recipe.
// 中文：这是配方的成品——一个预先装好 50 单位催乳剂的玻璃瓶。
// WHY a pre-filled bottle subtype: the engine's standard pattern for "a bottle
// that comes filled with potion X" is a glass/bottle subtype that just sets
// list_reagents (see the vanilla filled-potion bottles). Because this subtype
// ONLY ever exists as the craft output, spawning it already filled is correct
// and needs no extra post-craft code — the recipe simply uses it as `result`.
// ============================================================================
/obj/item/reagent_containers/glass/bottle/rogue/lactation_enhancer
	// 中文：瓶子里预装 50 单位催乳剂（与其它药水瓶一致的容量）。
	list_reagents = list(/datum/reagent/medicine/lactation_enhancer = 50)	// Pre-filled with the potion.
