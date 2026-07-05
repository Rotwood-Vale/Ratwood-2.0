// ============================================================================
// 把"精炼药剂"配方接入原版炼金指南 (Refined Potions in the Alchemy Guide)
// ----------------------------------------------------------------------------
// 中文总览：
//   问题：自定义的精炼配方 /datum/alch_refining_formula 既不是 /datum/alch_cauldron_recipe，也不是
//         配方书 /obj/item/recipe_book 默认认识的任何类型，因此【不会】出现在原版炼金指南"炼金秘要"
//         (/obj/item/recipe_book/alchemy) 里，详情也无法渲染。
//   做法：在【不改动 recipe_book.dm / recipe_books_list.dm(均在 modular_z121 之外)】的前提下，对既有的
//         炼金指南子类型【覆盖三个过程】，把精炼配方挂进去，并单独归入"精炼药剂"分类：
//         1) New()                ——把 /datum/alch_refining_formula(抽象基类)加入该书的 types，
//                                    配方书会自动展开其所有子类(具体配方)逐条列出。
//         2) get_recipe_category()——对精炼配方返回固定分类"精炼药剂"，从而在书中单列一个分类标签。
//         3) generate_recipe_html()——为精炼配方渲染详情(气味要求/液体底料/产物/功效/酒性)，
//                                    其余类型一律交回父级处理。
//   说明：覆盖【子类型 /obj/item/recipe_book/alchemy 上的过程】是合法的方法重写(父类已定义这些过程)，
//         不会与原文件冲突；且只影响"炼金秘要"这一本指南，不波及其它配方书。
//   本文件位于 modular_z121 根目录之下，符合项目硬性约束。
// ============================================================================

// 中文：开书前把精炼配方基类加入 types。用 `types + list(...)` 生成一份【实例独有】的新列表(不改动
//       类级共享列表、也不会随多次 New 累积)，再交给父级 New() 据此构建分类。
// WHY before ..(): 父级 /obj/item/recipe_book/New() 会调用 generate_categories() 读取 types，
//       故必须在 ..() 之前把我们的类型加进去，"精炼药剂"分类才会被建出来。
/obj/item/recipe_book/alchemy/New()
	// 中文：把精炼配方抽象基类追加进本书的配方类型表(配方书会自动展开为各具体子配方)。
	types = types + list(/datum/alch_refining_formula)		// Add refining formulas (abstract base -> subtypes).
	. = ..()												// Parent builds categories from the updated types.

// 中文：为精炼配方指定固定分类"精炼药剂"；其余类型沿用父级逻辑。
/obj/item/recipe_book/alchemy/get_recipe_category(path)
	// 中文：命中精炼配方 → 归入"精炼药剂"分类(书中会出现同名分类按钮)。
	if(ispath(path, /datum/alch_refining_formula))			// One of our refining formulas?
		return "精炼药剂"									// Refined Potions category.
	// 中文：非精炼配方 → 交回父级按原逻辑取分类。
	return ..()												// Defer to vanilla for everything else.

// 中文：渲染某条精炼配方的详情页；非精炼配方一律交回父级。
/obj/item/recipe_book/alchemy/generate_recipe_html(path, user)
	// 中文：只接管精炼配方；其它类型保持原版渲染。
	if(!ispath(path, /datum/alch_refining_formula))			// Not a refining formula?
		return ..()											// Let the vanilla book render it.

	// 中文：实例化一份临时配方对象，用于读取其字段与方法(读毕即 qdel，沿用配方书的临时实例做法)。
	var/datum/alch_refining_formula/formula = new path()	// Temp instance to read fields/procs.

	// 中文：拼装详情 HTML，外层沿用配方书的 recipe-content 容器以套用既有样式。
	var/html = "<div class='recipe-content'>"				// Match the book's styling wrapper.
	// --- 标题 ---
	html += "<h2 class='recipe-title'>[formula.name]</h2>"
	// --- 调制场所与分类 ---
	html += "<p><strong>类别：</strong>精炼药剂（于「精炼炼药锅」中调制）</p>"
	// --- 所需技能(沿用 SSskills 的等级名) ---
	html += "<p><strong>所需炼金技能：</strong>[SSskills.level_names_plain[formula.skill_required]] 级</p>"

	// --- 气味要求(两种触发方式择一展示) ---
	if(formula.required_scent)								// Mode ①: scent-level.
		html += "<p><strong>气味要求：</strong>累计 [formula.required_scent_points] 点【[formula.required_scent]】气味（投入带此气味的原版炼金材料即可，主气味=3 点、次=2、微=1）</p>"
	else if(formula.base_recipe)							// Mode ②: recipe-family.
		var/datum/alch_cauldron_recipe/base_rec = formula.base_recipe	// Typed for initial().
		html += "<p><strong>气味要求：</strong>材料气味须以【[initial(base_rec.name)]】为主，积分达 5 点</p>"

	// --- 液体底料(逐项列出试剂名与用量) ---
	if(length(formula.required_base))
		var/list/base_parts = list()						// Readable "name x amount" pieces.
		for(var/base_reagent in formula.required_base)		// Each base component.
			var/datum/reagent/R = base_reagent				// Typed for initial(name).
			base_parts += "[initial(R.name)] [formula.required_base[base_reagent]] 单位"
		html += "<p><strong>液体底料：</strong>[jointext(base_parts, " ＋ ")]</p>"

	// --- 产物(逐项列出试剂名与产量) ---
	if(length(formula.output_reagents))
		var/list/out_parts = list()							// Readable output pieces.
		for(var/out_reagent in formula.output_reagents)		// Each product.
			var/datum/reagent/R = out_reagent				// Typed for initial(name).
			out_parts += "[initial(R.name)] [formula.output_reagents[out_reagent]] 单位"
		html += "<p><strong>产物：</strong>[jointext(out_parts, " ＋ ")]</p>"

	// --- 固体产物(若配方产出实体道具，如防腐皂，逐一列出物品名) ---
	if(length(formula.output_items))
		var/list/item_parts = list()						// Readable item-name pieces.
		for(var/itempath in formula.output_items)			// Each solid item path.
			var/obj/item/I = itempath						// Typed for initial(name).
			item_parts += "[initial(I.name)]"
		html += "<p><strong>产物（实体）：</strong>[jointext(item_parts, " ＋ ")]</p>"

	// --- 功效(优先取首个产物试剂的说明；若无试剂产物则取首个固体产物的说明) ---
	if(length(formula.output_reagents))
		var/first_output = formula.output_reagents[1]		// First product reagent path.
		var/datum/reagent/R = first_output					// Typed for initial(description).
		var/effect_text = initial(R.description)			// The product's flavour/effect text.
		if(effect_text)
			html += "<p><strong>功效：</strong>[effect_text]</p>"
	else if(length(formula.output_items))					// Item-only product → describe the item.
		var/first_item = formula.output_items[1]			// First product item path.
		var/obj/item/I = first_item							// Typed for initial(desc).
		var/effect_text = initial(I.desc)					// The item's flavour/effect text.
		if(effect_text)
			html += "<p><strong>功效：</strong>[effect_text]</p>"

	// --- 酒性(若为酒基药剂，提示醉酒与大致酒劲) ---
	if(formula.is_alcoholic())								// Alcohol-based?
		html += "<p><strong>酒性：</strong>此乃酒基药剂，饮下会像饮酒般上头（大致酒劲约 [formula.get_boozepwr()]）。</p>"

	html += "</div>"										// Close recipe-content.

	// 中文：释放临时实例。
	qdel(formula)											// Free the temp instance.
	return html
