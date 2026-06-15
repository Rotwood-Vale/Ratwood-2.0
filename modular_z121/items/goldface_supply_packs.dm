// modular_z121 自定义金面售卖包
// 仅通过新增自定义 supply pack 的方式，把铅弹袋加入金面的远程武器分类。

/datum/supply_pack/rogue/ranged_weapons/lead_bullet_quiver
	// 名称对齐项目里 /obj/item/quiver/bullet/lead 的现有翻译。
	name = "铅弹袋"
	// 按需求固定为 80 mammon，不吃主线商店包的随机价格浮动。
	cost = 80
	static_cost = TRUE
	contains = list(
		/obj/item/quiver/bullet/lead,
	)
