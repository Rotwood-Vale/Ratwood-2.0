// ============================================================================
// BRASSFACE (浴场商贩机) sales entry for 催乳剂 (Lactation Enhancing Agent).
// 中文：把“催乳剂”成品瓶加入浴场商贩机 BRASSFACE 的售货清单。
//
// WHY this shape (and why it lives here instead of editing bathmaster.dm):
//   The BRASSFACE machine in code/modules/roguetown/roguemachine/merchant/bathmaster.dm
//   does NOT hold a hand-written item list — at attack_hand() it iterates over
//   SSmerchant.supply_packs and shows every pack whose `group` matches the chosen
//   category. SSmerchant auto-collects every subtypesof(/datum/supply_pack/rogue)
//   that has a non-null `contains` (see controllers/subsystem/merchant.dm:24-28).
//   So the ONLY supported way to add a product to BRASSFACE is to define a new
//   /datum/supply_pack/rogue with a matching `group`. Defining that pack here keeps
//   every change inside modular_z121, as the project rules require — no base file edit.
//
//   `group = "Drugs"` is one of the seven categories the bathvend exposes
//   (see bathmaster.dm `categories`), and a drinkable potion fits that tab
//   alongside the other powders/tonics already sold there.
// ============================================================================

// 中文：浴场商贩机的“催乳剂”补给包定义，归入 "Drugs" 分类页。
// WHY subclass /datum/supply_pack/rogue: only this tree is scanned by SSmerchant,
// and the parent sets crate flavour; we only override the sale-specific fields.
/datum/supply_pack/rogue/bath_lactation_enhancer
	// 中文：分类必须等于 bathvend 七个分类之一，否则不会出现在任何页签。
	group = "Drugs"											// Must match a bathvend category to be visible.
	// 中文：货箱名/类型沿用商贩公会通用箱（与其它浴场补给包一致的观感）。
	crate_name = "merchant guild's crate"					// Cosmetic crate label (matches sibling packs).
	crate_type = /obj/structure/closet/crate/chest/merchant	// Cosmetic crate type (matches sibling packs).
	// 中文：货品名称——商贩机清单中显示的条目名。
	name = "催乳剂"											// Display name in the BRASSFACE listing.
	// 中文：售价（曼蒙）。设为 30，与同页中等强度药剂（如纯化月尘）持平，避免破坏经济平衡。
	// WHY 30: in line with the mid-tier consumables already in the "Drugs" tab.
	cost = 30												// Price in mammon (pre-tax).
	// 中文：售出内容——1 个预装满 50 单位催乳剂的玻璃瓶
	//       （见 modular_z121/alchemy/lactation_enhancer_reagent.dm）。
	// WHY non-null contains: SSmerchant skips any pack whose `contains` is null,
	// so this list is also what makes the pack register at all.
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/lactation_enhancer)	// The filled potion bottle.
