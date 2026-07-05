// ============================================================================
// 复原药剂 (Restorative Potion) —— 一味【精炼药剂(非酒)】
// ----------------------------------------------------------------------------
// 中文设计说明（为什么这样做）：
//   需求：泼洒【至少 10 单位】到一件物品上，使其"分解回它的原材料"。这里的"原材料"指
//   【合成/锻造该物品所用的配方原料】，而【不是】熔炉熔炼后得到的金属(那是 smeltresult，语义不同)。
//   且需求进一步明确：不仅要认【菜单合成配方】(/datum/crafting_recipe)，也要认【锻造配方】
//   (/datum/anvil_recipe 铁砧锻造)等其它配方体系。
//
//   本引擎里"由配方合成的物品"分属两套互不相同的配方体系，需要分别逆向查表：
//     A) 菜单合成 /datum/crafting_recipe：全部实例收集在 GLOB.crafting_recipes。
//          · result —— 产出的物品类型；
//          · reqs   —— 关联列表 list(材料类型 = 数量)，即被消耗的合成原料。
//     B) 铁砧锻造 /datum/anvil_recipe：全部实例收集在 GLOB.anvil_recipes。
//          · created_item     —— 锻造产出的物品类型；
//          · req_bar / req_blade + using_blade —— 起始工件(锭 或 刃)，锻造从它开始；
//          · additional_items —— 【扁平列表】，锻造过程中用钳子逐一加入并消耗的其它材料(重复项显式重复);
//          · createditem_num  —— 一次锻造批量产出的件数(如投掷刀一次出 4 把)。
//
//   实现思路（统一材料清单 + 逆向查表）：
//     get_synthesis_materials(物品类型) 先查 A 再查 B，把命中配方的原料整理成一张
//     【可实体化材料 -> 数量】的关联表返回：
//       · A：直接取 reqs，过滤掉不能作为独立物品生成的项(如纯试剂路径)。
//       · B：起始工件(req_bar 或 req_blade) 记 1 件，再累加 additional_items 各项；随后【按 createditem_num
//            整除】——因为一次锻造用整套料出 N 件，单独一件只应还原 1/N 的料，借此杜绝"批量锻造再逐件分解"
//            的材料复制刷取漏洞(整除向下取整，故投掷刀这类批量小件通常还原为 0 → 不予分解)。
//     若两套体系都查不到，或整理后无任何可实体化材料 → 该物品"没有可还原的合成公式" → 不分解、保留原物。
//
//   触发点：本药剂【不靠入体代谢】起效，而是在被【泼洒/喷淋到某个 /obj 上】时(触发 reaction_obj)结算，
//   与"万能修复溶剂"(universal_repair.dm)同源——都是物件类效果，走 reagents.reaction() 的 reaction_obj 分支。
//
//   配方(与需求一一对应)：
//     · 气味要求：★毁灭★ 气味 5 级(required_scent="毁灭", required_scent_points=5)。
//       "毁灭"是原版【毒药(毁灭)】配方 doompoison 的 smells_like；带该气味的现成材料指向 doompoison，
//       故凑满 5 点毁灭气味即可(如某 major(3) + 某 med(2))，无需新增任何材料。
//     · 液体底料：清水 70 + 强效魔力药水 30(=Great Mana Potion，/datum/reagent/medicine/strongmana，现成产物)。
//     · 技能要求：炼金 5 级(SKILL_LEVEL_MASTER 大师)。
//     · 产物：30 单位复原药剂。
//
//   框架见 refining_framework.dm；成品瓶见 items/custom_potion_bottles.dm。
//   本文件全部内容位于 modular_z121 之下，符合项目硬性约束。
// ============================================================================

// ----------------------------------------------------------------------------
// 中文：泼洒时的最小生效用量——需求规定"至少 10 单位"才分解物品。低于此仅视作"沾湿"，不生效。
//       用宏集中定义，便于日后统一调整这一阈值。
// ----------------------------------------------------------------------------
#define RESTORATIVE_DISINTEGRATE_MIN_VOLUME 10		// Minimum splashed units required to disintegrate an item.

// 中文：成品试剂——复原药剂。被泼洒到物件上(reaction_obj)时，若用量达标，则把该物件还原为其【合成/锻造原料】。
/datum/reagent/restorative_potion
	name = "复原药剂"											// In-game name (Restorative Potion).
	description = "循毁灭的气息、以清水与强效魔力药水为底精炼出的靛蓝色澄液。将它泼淋于器物之上，凝结其中的匠艺会被溶解剥离，令其崩解、复归为当初用以合成或锻造它的原料。"	// Flavour + hint.
	reagent_state = LIQUID									// Liquid solvent.
	color = "#3b3b8f"										// Deep indigo.
	taste_description = "灰烬与冷铁"							// Taste flavour.
	metabolization_rate = REAGENTS_METABOLISM				// (Irrelevant; effect is on objects, not on drink.)

// 中文：把一件物品的"合成/锻造原料"整理成一张【可实体化材料路径 -> 数量】的关联表。
//       先查【菜单合成配方】(A)，未命中再查【铁砧锻造配方】(B)；都查不到则返回空表。
//   参数 item_type：被分解物品的确切 type。返回：list(材料type = 数量)，可能为空。
/datum/reagent/restorative_potion/proc/get_synthesis_materials(item_type)
	var/list/materials = list()								// Accumulated (material path -> count).

	// ---- A) 逆向查【菜单合成配方】/datum/crafting_recipe(结果 result 恰为该物品) ----
	if(GLOB.crafting_recipes)								// Registry built (world-init).
		for(var/datum/crafting_recipe/R as anything in GLOB.crafting_recipes)	// Scan every menu recipe.
			if(R.result != item_type)						// Not the formula that made this item.
				continue
			if(!islist(R.reqs))								// No ingredient list to read.
				break
			// 中文：reqs 是 list(材料=数量)。只收可实体化(/atom/movable)的项；纯试剂等无法作为物品生成 → 跳过。
			for(var/req_type in R.reqs)					// Each ingredient path.
				var/amount = R.reqs[req_type]				// Its consumed count.
				if(!ispath(req_type, /atom/movable))		// Not spawnable as an object (e.g. a reagent).
					continue
				if(!isnum(amount) || amount <= 0)			// Malformed / zero.
					continue
				materials[req_type] += amount				// Tally it.
			return materials								// Menu recipe found & tallied — done.

	// ---- B) 逆向查【铁砧锻造配方】/datum/anvil_recipe(产物 created_item 恰为该物品) ----
	if(GLOB.anvil_recipes)									// Registry built (world-init).
		for(var/datum/anvil_recipe/A as anything in GLOB.anvil_recipes)	// Scan every forge recipe.
			if(A.created_item != item_type)				// Not the forge recipe that made this item.
				continue
			// 中文：一次锻造的批量件数(用于把整套料摊分到单件)。防御性下限为 1。
			var/batch = A.createditem_num					// How many this recipe yields per craft.
			if(!isnum(batch) || batch < 1)					// Guard against unset/invalid.
				batch = 1
			// 中文：起始工件——使用刃坯则为 req_blade，否则为基础锭 req_bar，各记 1 件。
			var/starting_piece = (A.using_blade && A.req_blade) ? A.req_blade : A.req_bar	// Base workpiece.
			var/list/raw_tally = list()					// Raw (pre-division) material tally.
			if(starting_piece && ispath(starting_piece, /atom/movable))	// Spawnable base piece?
				raw_tally[starting_piece] += 1				// One base bar/blade.
			// 中文：additional_items 是扁平列表，每个元素=锻造中加入并消耗的一件材料(重复项显式重复)，逐项累加。
			if(islist(A.additional_items))					// Extra materials hammered in.
				for(var/extra_type in A.additional_items)	// Each added item (occurrences count).
					if(!ispath(extra_type, /atom/movable))	// Skip non-spawnable entries defensively.
						continue
					raw_tally[extra_type] += 1				// One more of this material.
			// 中文：按批量件数【整除向下取整】把整套料摊到单件，避免"批量锻造→逐件分解"复制刷料。
			for(var/mat_type in raw_tally)					// Convert raw tally into per-single-item amounts.
				var/each = round(raw_tally[mat_type] / batch)	// Floor(total / batch).
				if(each >= 1)								// Only refund whole materials.
					materials[mat_type] += each
			return materials								// Forge recipe found & tallied — done.

	return materials										// Neither system knew this item — empty list.

// 中文：当本药剂【作用到一个物件上】时触发——把该物件还原成其【合成/锻造原料】。
//   reaction_obj 在泼洒/喷淋/暴露试剂于物件时由 reagents.reaction() 调用(见 holder.dm)。
//   参数 O：被作用的物件；reac_volume：作用到"该物件"上的试剂量(喷洒会在多个目标间分摊)。
/datum/reagent/restorative_potion/reaction_obj(obj/O, reac_volume)
	. = ..()												// Base behaviour first.

	// ---- 错误防护①：目标无效 / 正在被删除 → 不处理，避免运行时报错 ----
	if(!O || QDELETED(O))									// Guard against missing/deleting object.
		return

	// ---- 效果范围限定：需求明确为"物品"——只对 /obj/item 生效，避免误分解建筑/机械/地形物件 ----
	// 中文：reaction_obj 对一切 /obj 都会触发；若不加限定，喷洒环境时会连墙体/机器一起处理，属误伤。
	if(!isitem(O))											// Only handheld items count as an "item".
		return
	var/obj/item/I = O										// Typed access to the item.

	// ---- 错误防护②：用量不足 → 只是"沾湿"，不足以完成分解(需求要求 >= 10 单位) ----
	if(reac_volume < RESTORATIVE_DISINTEGRATE_MIN_VOLUME)	// Needs a meaningful splash.
		return

	// ---- 错误防护③：不可摧毁的物品(设有 INDESTRUCTIBLE 抗性标记)不应被分解，防止破坏关键/剧情道具 ----
	if(I.resistance_flags & INDESTRUCTIBLE)					// Item is flagged indestructible.
		I.visible_message(span_warning("[I]被靛蓝色的药液浸透，却纹丝不动、毫无分解的迹象。"))	// Feedback: it resisted.
		return

	// ---- 逆向查配方(菜单合成 + 铁砧锻造)：整理出该物品的可还原原料清单 ----
	var/list/materials = get_synthesis_materials(I.type)	// (material path -> count), possibly empty.
	if(!materials || !materials.len)						// No synthesis/forge formula yields spawnable materials.
		I.visible_message(span_warning("[I]浸透了药液，却毫无变化——它并非由任何可还原的配方合成或锻造而来。"))	// Feedback.
		return

	// ---- 记录物件所在地块——还原出的原料要生成在这里(即便物件在背包/手中，也落到其外层地块) ----
	var/turf/location = get_turf(I)							// Where the raw materials should appear.
	if(!location)											// Somehow off-map (nullspace) → cannot drop materials.
		return												// Bail safely rather than spawning into nullspace.

	// ---- 还原结算：按整理好的清单逐项在原地生成对应数量的原料 ----
	for(var/mat_type in materials)							// Each distinct material.
		var/count = materials[mat_type]						// How many to restore.
		for(var/i in 1 to count)							// Spawn one per unit.
			new mat_type(location)							// Materialize the raw material on the floor.

	// ---- 收尾：销毁已分解的物品并反馈 ----
	I.visible_message(span_green("[I]在药液的侵蚀下层层剥落、轰然崩解，散作一堆当初用以合成它的原料！"))	// Success feedback.
	qdel(I)													// Destroy the now-disintegrated item.

// ============================================================================
// 配方：★按气味等级★——【5 级"毁灭"气味】+ 复合底料(清水70 + 强效魔力药水30) → 复原药剂。
//   "毁灭"是原版 doompoison(毒药·毁灭)配方的 smells_like；带此气味的现成材料指向 doompoison，
//   凑满 5 点毁灭气味即触发(无需新增材料)。底料 30 单位强效魔力药水即需求所述的"Great Mana Potion"。
// ============================================================================
/datum/alch_refining_formula/restorative
	name = "复原药剂"										// Formula name.
	// 中文：★气味档①★ 要求"毁灭"气味累计达到 5 点(即需求的"Doom 5 级")。
	required_scent = "毁灭"									// Require the "doom" scent...
	required_scent_points = 5								// ...at level 5 (>= 5 accumulated points).
	// 中文：★复合底料★ 清水 70 + 强效魔力药水 30(=Great Mana Potion)；均为现成试剂、无酒 → 成品非酒基。
	required_base = list(/datum/reagent/water = 70, /datum/reagent/medicine/strongmana = 30)	// 70 water + 30 great mana potion.
	// 中文：产物——30 单位复原药剂。
	output_reagents = list(/datum/reagent/restorative_potion = 30)	// Refined output (30 units).
	// 中文：所需技能——炼金 5 级(大师)。
	skill_required = SKILL_LEVEL_MASTER						// Alchemy level 5 gate.
	// 中文：成功气味词。
	smells_like = "崩解与铁锈气"								// Success scent.

// 中文：清理本文件作用域内的局部宏，避免泄漏到全局编译环境。
#undef RESTORATIVE_DISINTEGRATE_MIN_VOLUME
