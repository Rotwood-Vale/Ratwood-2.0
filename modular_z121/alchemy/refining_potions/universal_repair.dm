// ============================================================================
// 万能修复溶剂 (Universal Repair Solvent) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 触发：5 级"大地"气味 + 水50/魔力药水30/板油20；技能：大师。
// 效果：泼洒到物件/建筑上时(reaction_obj)，将其耐久、锋利度及二者上限尽数修复如初。
// 框架见 refining_framework.dm。
// ============================================================================

// 中文：成品试剂——万能修复溶剂。它【不靠入体代谢】起效，而是在被【泼洒/浇淋到物件或建筑上】时
//       (触发 reaction_obj)将目标彻底修复：耐久、刃锋(锋利度)、以及它们的【上限】一并还原如初。
//   涉及原版变量：obj_integrity/max_integrity(耐久/耐久上限，/obj)、blade_int/max_blade_int(锋利/锋利上限，
//   /obj/item)——后者用原版 restore_bintegrity() 一并复位到 initial。
/datum/reagent/universal_repair_solvent
	name = "万能修复溶剂"									// In-game name (Universal Repair Solvent).
	description = "循大地的气味、以清水、魔力药水与板油为底精炼的银灰色稠液。浇淋于器物或建筑之上，崩损的耐久与钝去的锋芒都会被尽数补全、如初锻造。"	// Flavour + hint.
	reagent_state = LIQUID									// Liquid solvent.
	color = "#9c7a4d"										// Earthen bronze.
	taste_description = "泥土与金属"							// Taste flavour.
	metabolization_rate = REAGENTS_METABOLISM				// (Irrelevant; effect is on objects, not on drink.)

// 中文：当本溶剂【作用到一个物件/建筑】上时触发——把该 /obj 彻底修复。
//   reaction_obj 在泼洒/暴露试剂于物件时由 reagents.reaction() 调用(见 holder.dm)。
/datum/reagent/universal_repair_solvent/reaction_obj(obj/O, reac_volume)
	. = ..()												// Base behaviour first.
	// 中文：错误防护——目标无效/正被删除则不处理。
	if(!O || QDELETED(O))									// Guard against missing/deleting object.
		return
	// 中文：用量过少视作"只是沾湿"，不足以完成修复——要求至少 5 单位，避免一滴就修好。
	if(reac_volume < 5)										// Needs a meaningful splash.
		return
	// 中文：记录是否确实修复了什么，用于决定是否给出反馈。
	var/repaired = FALSE									// Did we actually restore anything?

	// ---- 修复①：耐久 + 耐久上限(所有 /obj 通用) ----
	// 中文：把耐久上限还原到出厂值(以防被某些磨损机制调低)，再把当前耐久顶满；并清除"损坏/被毁"状态。
	if(O.max_integrity)										// Has a durability system?
		O.max_integrity = initial(O.max_integrity)			// Restore MAX durability.
		O.obj_integrity = O.max_integrity					// Full current durability.
		O.obj_broken = initial(O.obj_broken)				// Un-break (usually FALSE).
		O.obj_destroyed = initial(O.obj_destroyed)			// Clear destroyed flag (usually FALSE).
		repaired = TRUE

	// ---- 修复②：锋利度 + 锋利上限(仅限带刃的 /obj/item) ----
	// 中文：对有刃物品调用原版 restore_bintegrity()，它会把 max_blade_int 与 blade_int 一并复位到 initial，
	//       即"锋利度与锋利上限"双双满血——与磨刀石恢复刀刃品质同源。
	if(isitem(O))											// Only items can have a blade.
		var/obj/item/I = O									// Typed access.
		if(I.max_blade_int)									// Actually has a sharpenable blade?
			I.restore_bintegrity()							// Restore sharpness AND its max.
			repaired = TRUE

	// ---- 收尾：刷新外观并给出反馈 ----
	if(repaired)											// Only react if something was restored.
		O.update_icon()										// Refresh sprite (drop broken overlays, etc.).
		O.visible_message(span_green("[O]在溶剂的浸润下崩损尽复、锋芒重现，宛如刚刚锻造问世！"))	// Visible feedback.

// 中文：示例配方——★按气味等级★：要求【5 级"大地"气味】+ 复合底料(水50 + 魔力药水30 + 板油20) → 万能修复溶剂。
//       "大地"是【石肤药剂】配方的气味；带它的现成材料(指向石肤药剂)有：土之精质[major,3]、鼠尾草[major,3]、
//       火之精质[med,2]、铁粉[med,2] 等；如 土之精质(3)+鼠尾草(3)=6 即满足。
//       底料：水50 + 魔力药水30 + 板油20(均为现成试剂，无酒 → 成品非酒基)。
/datum/alch_refining_formula/universal_repair
	name = "万能修复溶剂"									// Formula name.
	// 中文：★气味档①★ 要求"大地"气味累计达到 5 点(即"5 份大地")。
	required_scent = "大地"									// Require the "earth" scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★复合底料★ 水 50 + 魔力药水 30 + 板油 20。
	required_base = list(/datum/reagent/water = 50, /datum/reagent/medicine/manapot = 30, /datum/reagent/consumable/oil/tallow = 20)	// Composite base.
	// 中文：产物——30 单位万能修复溶剂。
	output_reagents = list(/datum/reagent/universal_repair_solvent = 30)	// Refined output.
	// 中文：所需技能——大师。
	skill_required = SKILL_LEVEL_MASTER						// Master gate.
	// 中文：成功气味词。
	smells_like = "厚土与矿石气"								// Success scent.
