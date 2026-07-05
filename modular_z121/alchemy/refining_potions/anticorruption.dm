// ============================================================================
// 防腐皂 (Anti-corruption Soap) —— 一味【精炼药剂 → 固体成品道具】
// ----------------------------------------------------------------------------
// 中文总览（★本版为改版：由"液体药水泼洒"改为"固体皂块涂抹"★）：
//   背景：上一版做成液体试剂、靠"泼洒(reaction_obj/reaction_mob)"起效，但实测【无法把药水洒到食物上】，
//         因此效果无从触发。改版策略——精炼配方直接产出一块【固体防腐皂】；玩家【手持皂块点击】食物 / 尸体
//         即可涂抹，令其【不再腐坏】。这条交互(afterattack)是原版肥皂/香水等"把道具用在目标上"的标准做法，
//         稳定可靠，不依赖会失败的液体泼洒。
//   触发(气味)：5 级"山间空气"气味(对应原版【坚韧药剂 end_potion / Potion of Enduring Fortitude】配方的
//               smells_like，在自定义精炼药剂里【尚未被任何配方占用】，符合"任一未使用的自定义气味(5 级)")。
//   底料：清水 70 + 魔力药水 30(均为现成试剂)。
//   技能：专家(SKILL_LEVEL_EXPERT)。
//   产物：一块【防腐皂】(固体道具，含若干次使用)——不再是液体试剂。
//   效果(手持皂块点击目标)：
//         ① 点击【食物】：冻结其腐烂进程 → 食物【永不腐坏】。
//         ② 点击【尸体】：停止并解除其腐烂/僵尸化组件 → 遗体【被封存、不再腐朽】。
//   依赖框架：需要 refining_framework.dm 的 /datum/alch_refining_formula 支持【固体产物 output_items】
//             (已在框架中新增该字段并在锅子 process() 中生成)。本文件全部位于 modular_z121 之下，符合硬性约束。
// ============================================================================


// ============================================================================
// 1) 成品道具：防腐皂 /obj/item/anticorruption_soap。
//    中文：一块以炼金精炼出的皂块。手持点击食物或尸体即可涂抹防腐，每次消耗一次使用次数，用尽即碎裂。
//          复用原版肥皂的贴图(items_and_weapons.dmi 的 "soap")，并染成琥珀色以示区别，避免缺图。
// ============================================================================
/obj/item/anticorruption_soap
	name = "防腐皂"											// In-game name (Anti-corruption Soap).
	// 中文：描述——点明来历(精炼)与用法(涂抹食物/遗体以防腐)。
	desc = "一块琥珀色的炼金皂，触之微凉、带着清冽的草木与矿盐气。以皂块涂抹食物可令其久置不腐；抹于遗体之上，则能止住腐朽、封存亡者之躯。"	// Flavour + usage hint.
	icon = 'icons/obj/items_and_weapons.dmi'					// Reuse the vanilla soap sprite sheet (no missing icon).
	icon_state = "soap"											// Soap bar sprite.
	color = "#c9b273"											// Pale amber tint to distinguish it from plain soap.
	w_class = WEIGHT_CLASS_TINY									// Small, pocketable.
	// 中文：NOBLUDGEON——本道具是"涂抹工具"而非武器，点击目标时不产生攻击伤害，只走 afterattack 涂抹逻辑。
	item_flags = NOBLUDGEON										// Not a weapon; clicking a target applies the effect.
	dropshrink = 0.7											// Match soap's dropped size.
	// 中文：剩余使用次数——每成功涂抹一次消耗 1；归零即碎裂消失。
	var/charges = 10											// Number of preservation uses left.
	// 中文：涂抹一次所需的操作时长(do_after)，避免瞬发、给出施用感。
	var/apply_time = 3 SECONDS									// Time to rub the soap onto a target.

// 中文：查看时显示剩余次数，便于玩家掌握消耗。
/obj/item/anticorruption_soap/examine(mob/user)
	. = ..()													// Base examine text first.
	. += span_notice("它还能使用 [charges] 次。")				// Show remaining charges.

// 中文：扣减一次使用次数的辅助过程；用尽则提示并销毁皂块。集中处理，避免各分支重复写。
/obj/item/anticorruption_soap/proc/use_charge(mob/user)
	charges--													// Spend one use.
	if(charges <= 0)											// Exhausted?
		if(user)												// Notify the holder if present.
			to_chat(user, span_warning("[src]在最后一次涂抹后化作了碎屑。"))	// Crumble message.
		qdel(src)												// Destroy the spent soap.

// 中文：核心交互——手持皂块点击一个目标(food/corpse)时触发涂抹防腐。
//   afterattack 由引擎在"用手持物点击某目标"后调用；proximity 表示与目标相邻(近战范围)。
//   参数 target：被点击的目标；user：使用者；proximity：是否贴身(仅近身涂抹有效)。
/obj/item/anticorruption_soap/afterattack(atom/target, mob/user, proximity)
	. = ..()													// Run base behaviour first.
	// 中文：错误处理——必须贴身涂抹；隔空点击无效，直接返回。
	if(!proximity)												// Must be adjacent to rub it on.
		return
	// 中文：错误处理——目标无效/正被删除，直接返回，避免运行时报错。
	if(!target || QDELETED(target))								// Guard: missing/deleting target.
		return
	// 中文：错误处理——皂块已无使用次数(理论上会先被 qdel，这里再兜底一次)。
	if(charges <= 0)											// No uses left (safety net).
		to_chat(user, span_warning("[src]已经用完了。"))		// Empty message.
		return

	// ---- 分支①：目标是【食物】→ 冻结其腐烂进程，令其永不腐坏 ----
	// 中文：原版食物腐烂由 snacks.dm 的 process() 驱动——仅当 rotprocess 为真才随时间 become_rotten()。
	//       故"防腐"最彻底的做法是把 rotprocess 置 0 并 STOP_PROCESSING，令其 process() 不再推进腐烂。
	if(istype(target, /obj/item/reagent_containers/food/snacks))	// Target is food.
		var/obj/item/reagent_containers/food/snacks/F = target	// Typed handle for food-specific vars.
		// 中文：边界——本身就不会腐烂的食物无需处理，给出温和反馈(不消耗次数)。
		if(!F.rotprocess)										// Food that already never rots.
			to_chat(user, span_notice("[F]本就不会腐坏，无需防腐处理。"))	// Gentle no-op.
			return
		// 中文：边界——已经腐烂的食物无法复鲜，只封存现状(不消耗次数，因为无实际保鲜意义)。
		if(F.eat_effect == /datum/status_effect/debuff/rotfood)	// Already rotten.
			to_chat(user, span_warning("[F]已然腐坏，防腐皂也无法使其复鲜。"))	// Cannot un-rot.
			return
		// 中文：涂抹动作——给出提示并等待 apply_time；期间中断则不生效、不消耗次数。
		user.visible_message(span_notice("[user]开始用[src]仔细涂抹[F]。"), span_notice("我开始用[src]涂抹[F]。"))	// Begin rubbing.
		if(!do_after(user, apply_time, target = F))				// Interrupted?
			return
		// 中文：错误处理——do_after 期间目标可能被吃掉/销毁，复查一次。
		if(QDELETED(F))											// Target vanished mid-apply.
			return
		// 中文：正式防腐——冻结腐烂预算 + 移出腐烂处理队列，食物永久保鲜。
		F.rotprocess = FALSE									// Disable the rotting budget → never rots.
		STOP_PROCESSING(SSobj, F)								// Remove it from the rot processing loop.
		user.visible_message(span_green("[F]被防腐皂涂得泛起清亮光泽，仿佛时光在它身上凝滞——从此不会再腐坏。"))	// Success feedback.
		use_charge(user)										// Spend one use.
		return

	// ---- 分支②：目标是【尸体】→ 停止并解除腐烂组件，封存遗体 ----
	// 中文：原版尸体腐烂由 /datum/component/rot(及 /corpse、/simple 子类)在 SSroguerot 中推进，死亡时由
	//       death.dm 的 LoadComponent(rot_type) 挂上。故封存遗体的做法是：清零进度 + 停止并删除组件 +
	//       置空 rot_type(杜绝将来再死时重新挂载)。
	if(isliving(target))										// Target is a mob.
		var/mob/living/M = target								// Typed handle.
		// 中文：状态校验——只对【尸体(已死亡)】生效；活体不腐、也不该被封存。
		if(M.stat != DEAD)										// Only corpses can be preserved.
			to_chat(user, span_warning("[M]还活着，防腐皂只能用于遗体。"))	// Living target rejected.
			return
		// 中文：涂抹动作——提示并等待；中断则不生效、不消耗次数。
		user.visible_message(span_notice("[user]开始用[src]仔细涂抹[M]的遗体。"), span_notice("我开始用[src]涂抹[M]的遗体。"))	// Begin rubbing.
		if(!do_after(user, apply_time, target = M))				// Interrupted?
			return
		// 中文：错误处理——do_after 期间尸体可能被销毁/化尘，复查一次。
		if(QDELETED(M))											// Corpse vanished mid-apply.
			return
		// 中文：取出并解除腐烂组件(用基类 /datum/component/rot 同时覆盖 /corpse 与 /simple)。
		var/datum/component/rot/CR = M.GetComponent(/datum/component/rot)	// Active rot component, if any.
		if(CR)													// Has an ongoing rot process?
			CR.amount = 0										// (a) Reset accumulated rot/zombification progress.
			STOP_PROCESSING(SSroguerot, CR)						// (b) Take it out of the rot processing loop.
			qdel(CR)											// (b) Fully detach & destroy the component.
		// 中文：(c) 断绝将来——置空 rot_type，确保即便日后复活后再死亡，也不会重新挂上腐烂组件。
		M.rot_type = null										// No rot component re-loads on any future death.
		user.visible_message(span_green("[M]的遗体被防腐皂浸润，腐朽之气悄然止息，仿佛被永恒封存了下来。"))	// Success feedback.
		use_charge(user)										// Spend one use.
		return

	// ---- 其它目标：无可防腐之物，给出提示(不消耗次数) ----
	// 中文：既非食物也非尸体——防腐皂对它无从施用，友好提示玩家。
	to_chat(user, span_warning("防腐皂只能用在食物或遗体上。"))	// Nothing to preserve here.


// ============================================================================
// 2) 精炼配方：山间空气(5 级) + 水70 + 魔力药水30 → 一块防腐皂(固体产物)。
//    中文：★气味档①(按气味等级)★——要求"山间空气"气味累计达到 5 点。
//      "山间空气"是原版【坚韧药剂 end_potion / Potion of Enduring Fortitude】配方的 smells_like，
//      在自定义精炼药剂中【尚未被占用】，符合"任一未使用的自定义气味(5 级)"的要求。
//      带此气味、指向 end_potion 的现成材料(可凑满 5 点)例如：
//        · 铁粉(irondust) major_pot=end_potion → 3 点
//        · 煤灰(coaldust)/纯净精质(magicdust)/金盏花(calendula)/肌腱(sinew)/土之精质(earthdust) med_pot=end_potion → 各 2 点
//      故 铁粉(3) + 上述任一(2) = 5 点即满足触发。
//    ★底料★：清水 70 + 魔力药水 30。
//    ★产物★：★固体★——一块防腐皂(output_items)，而非液体试剂(output_reagents 留空)。
// ============================================================================
/datum/alch_refining_formula/anticorruption
	name = "防腐皂"											// Formula name (shown on success & in the guide).
	// 中文：★气味档①★——要求"山间空气"气味累计 5 点(即"5 级山间空气")。
	required_scent = "山间空气"									// Require the "mountain air" scent (end_potion, unused)...
	required_scent_points = 5									// ...at level 5 (>= 5 accumulated points).
	// 中文：★底料★——清水 70 + 魔力药水 30。魔力药水路径 /datum/reagent/medicine/manapot 为现成产物。
	required_base = list(/datum/reagent/water = 70, /datum/reagent/medicine/manapot = 30)	// Base: 70 water + 30 mana potion.
	// 中文：★液体产物为空★——本配方不产试剂，改产固体道具(见下方 output_items)。
	output_reagents = list()									// No liquid product.
	// 中文：★固体产物★——精炼出【一块防腐皂】(列表中一个条目=生成一件)。
	output_items = list(/obj/item/anticorruption_soap)			// Solid product: one bar of anti-corruption soap.
	// 中文：所需技能——专家。
	skill_required = SKILL_LEVEL_EXPERT							// Expert gate (per spec).
	// 中文：成功出炉时散发的气味词。
	smells_like = "清冽的防腐草木气"							// Success scent on brew.
