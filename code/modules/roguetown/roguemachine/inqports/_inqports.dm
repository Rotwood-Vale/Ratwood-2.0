GLOBAL_LIST_EMPTY(inqsupplies)

/datum/inqports
	var/name = null
	var/item_type = null
	var/held_items = list(0, 0)
	var/marquescost = 0
	var/maximum = null // If there's no maximum, it's infinite.
	var/remaining = null // Limited stock items.
	var/category = null // Category for the HERMES. They are -  "✤ SUPPLIES ✤", "✤ ARTICLES ✤", "✤ EQUIPMENT ✤", "✤ RELIQUARY ✤"

/datum/inqports/New()
	..()
	switch(category)
		if(1)
			category = "✤ 圣遗柜 ✤"
		if(2)
			category = "✤ 补给品 ✤"
		if(3)
			category = "✤ 物品 ✤"
		if(4)
			category = "✤ 装备 ✤"
		if(5)
			category = "✤ 衣装 ✤"	
	
	if(name)
		name = "[initial(name)] - ᛉ [marquescost] ᛉ"
	
	if(maximum)
		remaining = maximum
		name = "[initial(name)] ([remaining]/[maximum]) - ᛉ [marquescost] ᛉ"	
	return
