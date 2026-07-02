// ============================================================================
// 防腐药水 (Anti-corruption Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文总览：
//   触发(气味)：5 级"山间清气"气味(对应原版【坚韧药剂 end_potion / Potion of Enduring Fortitude】
//               配方的 smells_like，在自定义精炼药剂里【尚未被任何配方占用】，符合"任一未使用的
//               自定义气味(5 级)"的要求)。
//   底料：清水 70 + 魔力药水 30(均为现成试剂，无酒 → 成品【非酒基】，普通 /datum/reagent)。
//   技能：专家(SKILL_LEVEL_EXPERT)。
//   效果：把药水【泼洒/浇淋】到目标身上——
//         ① 洒在【食物】上(reaction_obj)：让该食物【永不腐坏】(冻结其腐烂进程)。
//         ② 洒在【尸体】上(reaction_mob)：让该尸体【停止腐烂/僵尸化进程】，保存遗体。
//   为什么用"泼洒(reaction_obj / reaction_mob)"而非"入体代谢(on_mob_life)"：
//         用户描述是"dropped onto food / dropped onto a corpse"，即把液体倾洒到目标之上；
//         原版 reagents.reaction() 会据目标类型分派到 reaction_obj(物件，如食物)与 reaction_mob(生物，
//         如尸体)。这正是"浇在……之上"的语义(参见 holder.dm reaction() 的分派逻辑)。
//   框架见 refining_framework.dm(锅子/配方基类/气味积分算法)。本文件全部位于 modular_z121 之下，符合硬性约束。
// ============================================================================


// ============================================================================
// 1) 成品试剂：防腐药水。
//    中文：本试剂【不靠喝下代谢】起效(所以无需 on_mob_life)，而是在被【泼洒到食物或尸体】时，
//          通过 reaction_obj / reaction_mob 触发"防腐/保存"逻辑。
// ============================================================================
/datum/reagent/anticorruption_potion
	name = "防腐药水"											// In-game name (Anti-corruption Potion).
	// 中文：风味描述——点明来历(气味/底料)与用法(浇在食物或遗体上以防腐)。
	description = "循山间清气般的气味、以清水与魔力药水为底精炼的琥珀色清液。浇淋于食物之上可令其久置不腐；泼洒于遗体之上，则能止住腐朽、封存亡者之躯。"	// Flavour + usage hint.
	reagent_state = LIQUID										// It is a liquid potion.
	color = "#c9b273"											// Pale amber (preserving-resin look).
	taste_description = "清冽的草木与矿盐"						// Taste flavour on contact/taste.
	// 中文：代谢速率——本药靠泼洒起效，代谢速率对效果无关紧要；给一个原版默认值即可(误饮不会有特殊后果)。
	metabolization_rate = REAGENTS_METABOLISM					// (Irrelevant; effect is via splashing, not digestion.)
	// 中文：安全阈值——用量过少视作"只是沾湿"，不足以形成有效的防腐层；低于此量则不触发效果，避免一滴即封存。
	var/preserve_min_volume = 5									// Minimum splash volume for the effect to take hold.


// ----------------------------------------------------------------------------
// 2) 效果①：泼洒到【食物】上 → 让该食物永不腐坏。
//    中文：原版食物的腐烂由 /obj/item/reagent_containers/food/snacks 的 process() 驱动——
//          当且仅当 rotprocess 为真时才会随时间 become_rotten()。因此"防腐"最干净、最彻底的做法就是：
//          把该食物的 rotprocess 置 0(FALSE)【冻结腐烂预算】，并 STOP_PROCESSING 把它移出腐烂处理队列。
//          从此它的 process() 不再推进腐烂，食物永久保鲜。
//    reaction_obj 由 reagents.reaction() 在"试剂接触到一个 /obj"时调用(见 holder.dm)。
// ----------------------------------------------------------------------------
/datum/reagent/anticorruption_potion/reaction_obj(obj/O, reac_volume)
	. = ..()													// Run base behaviour first.
	// 中文：错误处理——目标不存在 / 正在被删除，直接返回，避免运行时报错。
	if(!O || QDELETED(O))										// Guard: missing or deleting target.
		return
	// 中文：错误处理——用量不足以形成有效防腐层时，不生效(仅当作沾湿)。
	if(reac_volume < preserve_min_volume)						// Not enough potion splashed.
		return
	// 中文：类型校验——只对【食物(snacks)】生效；非食物物件一律忽略(例如武器、容器等)。
	if(!istype(O, /obj/item/reagent_containers/food/snacks))		// Only foodstuffs can be preserved.
		return
	var/obj/item/reagent_containers/food/snacks/F = O			// Typed handle for food-specific vars/procs.

	// 中文：错误处理/边界——本身就【不会腐烂】的食物(rotprocess 为 FALSE)无需处理，给出温和反馈后返回，
	//       避免对"永不腐"的食物重复施加，也避免误导玩家以为发生了什么。
	if(!F.rotprocess)											// Food that already never rots.
		F.visible_message(span_notice("[F]并没有会腐坏的迹象，防腐药水只是白白浸润了它。"))	// Gentle no-op feedback.
		return

	// 中文：边界——若食物【已经腐烂】(变成 rotten 态)，防腐药水无法"起死回生"，只保存现状不再恶化；给出提示。
	if(F.eat_effect == /datum/status_effect/debuff/rotfood)		// Already rotten — cannot un-rot.
		F.rotprocess = FALSE									// Freeze the (already-finished) rot budget for good measure.
		STOP_PROCESSING(SSobj, F)								// Ensure it is out of the rot processing queue.
		F.visible_message(span_warning("[F]已然腐坏，防腐药水只能封存住它当下的模样，无法使其复鲜。"))	// Feedback.
		return

	// ---- 正式防腐：冻结腐烂进程，让新鲜食物永久保鲜 ----
	// 中文：把腐烂预算清零 → process() 里 `if(rotprocess)` 不再成立，永不推进 become_rotten()。
	F.rotprocess = FALSE										// Disable the rotting budget → never rots again.
	// 中文：主动把它移出 SSobj 的腐烂处理队列(即便此刻正在其中)，杜绝任何残余推进。
	STOP_PROCESSING(SSobj, F)									// Remove from the rot processing loop.
	// 中文：成功反馈——让周围玩家看到防腐生效。
	F.visible_message(span_green("[F]被防腐药水浸透，泛起一层清亮的光泽，仿佛时光在它身上凝滞——从此不会再腐坏。"))	// Success feedback.


// ----------------------------------------------------------------------------
// 3) 效果②：泼洒到【尸体】上 → 让该尸体停止腐烂/僵尸化，封存遗体。
//    中文：原版尸体的腐烂由 /datum/component/rot(及其子类 /corpse、/simple)驱动——它在 SSroguerot 中
//          随时间累加 amount，到阈值就令肢体 rotted / 骨化 / 甚至化尘、或(僵尸)苏醒。死亡时 death.dm 会
//          LoadComponent(rot_type) 挂上该组件。因此"给尸体防腐"最彻底的做法是：
//            a) 把组件的 amount 清零(重置腐烂计时，参考 fully_heal 的做法 carbon.dm)；
//            b) 停止并移除该腐烂组件(STOP_PROCESSING + qdel) → 不再推进腐烂/僵尸化；
//            c) 把该生物的 rot_type 置 null → 即便日后被复活再死亡，也不会重新挂上腐烂组件。
//    reaction_mob 由 reagents.reaction() 在"试剂接触到一个 /mob/living"时调用(见 holder.dm)。
// ----------------------------------------------------------------------------
/datum/reagent/anticorruption_potion/reaction_mob(mob/living/M, method = TOUCH, reac_volume, show_message = 1, touch_protection = 0)
	. = ..()													// Run base behaviour first.
	// 中文：错误处理——目标无效/正被删除，直接返回。
	if(!istype(M) || QDELETED(M))								// Guard: not a living mob / deleting.
		return
	// 中文：错误处理——用量不足以形成有效防腐层，不生效。
	if(reac_volume < preserve_min_volume)						// Not enough potion splashed.
		return
	// 中文：类型/状态校验——只对【尸体(已死亡)】生效；活人被泼到不受影响(活人不会腐烂，也不该被"封存")。
	if(M.stat != DEAD)											// Only corpses (dead mobs) are preserved.
		return

	// 中文：取出该尸体身上的腐烂组件(用基类 /datum/component/rot 可同时覆盖 /corpse 与 /simple 两种子类)。
	var/datum/component/rot/CR = M.GetComponent(/datum/component/rot)	// The active rot component, if any.

	// 中文：边界——尸体身上没有腐烂组件(可能已被封存/已化尘/本就不腐)，仍给出反馈并把 rot_type 置空以杜绝将来。
	if(!CR)														// No rot component present.
		M.rot_type = null										// Prevent any FUTURE death from re-adding a rot component.
		M.visible_message(span_notice("[M]的遗体并无正在腐朽的迹象，防腐药水在其上凝成一层薄薄的清膜。"))	// Gentle feedback.
		return

	// ---- 正式防腐：冻结并解除腐烂组件 ----
	// 中文：(a) 清零腐烂进度——把已累计的腐烂/僵尸化计时归零(与原版 fully_heal 重置 CR.amount 同法)。
	CR.amount = 0												// Reset accumulated rot/zombification progress.
	// 中文：(b) 停止组件在 SSroguerot 中的处理，并彻底删除该组件——从此不再推进腐烂/骨化/僵尸苏醒。
	STOP_PROCESSING(SSroguerot, CR)								// Take it out of the rot processing loop.
	qdel(CR)													// Fully detach & destroy the rot component.
	// 中文：(c) 断绝将来——把 rot_type 置空，确保即便日后被复活后再次死亡，也不会重新挂上腐烂组件。
	M.rot_type = null											// No rot component will be re-loaded on any future death.
	// 中文：成功反馈——让周围玩家看到遗体被封存。
	M.visible_message(span_green("[M]的遗体被防腐药水浸润，腐朽之气悄然止息，仿佛被永恒封存了下来。"))	// Success feedback.


// ============================================================================
// 4) 精炼配方：山间清气(5 级) + 水70 + 魔力药水30 → 防腐药水。
//    中文：★气味档①(按气味等级)★——要求"山间清气"气味累计达到 5 点。
//      "山间清气"是原版【坚韧药剂 end_potion / Potion of Enduring Fortitude】配方的 smells_like，
//      在自定义精炼药剂中【尚未被占用】，符合"任一未使用的自定义气味(5 级)"的要求。
//      带此气味、指向 end_potion 的现成材料(可凑满 5 点)例如：
//        · 铁粉(irondust) major_pot=end_potion → 3 点
//        · 煤灰(coaldust)/纯净精质(magicdust)/金盏花(calendula)/肌腱(sinew)/土之精质(earthdust) med_pot=end_potion → 各 2 点
//      故 铁粉(3) + 上述任一(2) = 5 点即满足触发。
//    ★底料★：清水 70 + 魔力药水 30(均为现成试剂，无酒 → 成品非酒基)。
// ============================================================================
/datum/alch_refining_formula/anticorruption
	name = "防腐药水"											// Formula name (shown on success & in the guide).
	// 中文：★气味档①★——要求"山间清气"气味累计 5 点(即"5 级山间清气")。
	required_scent = "山间空气"									// Require the "mountain air" scent (end_potion, unused)...
	required_scent_points = 5									// ...at level 5 (>= 5 accumulated points).
	// 中文：★底料★——清水 70 + 魔力药水 30。魔力药水路径 /datum/reagent/medicine/manapot 为现成产物。
	required_base = list(/datum/reagent/water = 70, /datum/reagent/medicine/manapot = 30)	// Base: 70 water + 30 mana potion.
	// 中文：产物——30 单位防腐药水。
	output_reagents = list(/datum/reagent/anticorruption_potion = 30)	// Refined output potion.
	// 中文：所需技能——专家。
	skill_required = SKILL_LEVEL_EXPERT							// Expert gate (per spec).
	// 中文：成功出炉时散发的气味词。
	smells_like = "清冽的防腐草木气"							// Success scent on brew.
