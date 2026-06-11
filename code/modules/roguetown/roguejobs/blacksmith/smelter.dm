
/obj/item
//	var/smeltresult defined on obj within artificer/contraptions
	var/smelt_bar_num = 1 //variable for tracking how many bars things smelt back into for multi-bar items
// MULTIBAR SMELTING WAS DISABLED FOR BALANCE REASONS
// DO NOT RE-ENABLE IT UNTIL FURTHER NOTICE

/obj/machinery/light/rogue/smelter
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "石炉"
	desc = "一座被岁月与高温侵蚀过的石制熔炉。"
	icon_state = "cavesmelter0"
	base_state = "cavesmelter"
	anchored = TRUE
	density = TRUE
	climbable = TRUE
	climb_time = 0
	climb_offset = 10
	on = TRUE

	/// Which ores are contained within us?
	var/list/contained_items = list()

	/// How many items can we contain?
	var/max_contained_items = 1

	/// How many ticks of smelting we've done
	var/smelting_progress = 0

	/// How many ticks of smelting necessary to get the finished product
	var/smelting_ticks = 20

	/// Are we currently smelting?
	var/actively_smelting = FALSE

	/// Who smelted the ore?
	var/datum/mind/smelter_mind

	fueluse = 30 MINUTES
	crossfire = FALSE

/obj/machinery/light/rogue/smelter/examine(mob/user, params)
	. = ..()
	. += span_info("它一次最多能容纳 [max_contained_items] 份矿石。")
	. += span_info("左键可放入物品。若放入的是燃料物品，会弹出提示询问你是想添燃料还是直接熔炼。右键点击熔炉则只会将物品放进去用于熔炼。")
	if(length(contained_items))
		. += span_notice("往里一看，你能看到：")
		for(var/obj/item/item as anything in contained_items)
			. += span_info("- [item]")

/obj/machinery/light/rogue/smelter/attackby(obj/item/attacking_item, mob/living/user, params)
	if(istype(attacking_item, /obj/item/rogueweapon/tongs))
		var/obj/item/rogueweapon/tongs/tongs = attacking_item
		if(tongs.hingot)
			if(length(contained_items) >= max_contained_items)
				to_chat(user, span_warn("[src]已经满了！"))
				return
			add_item(tongs.hingot, user)
			tongs.hingot = null
			tongs.update_icon()
		else
			if(actively_smelting) // Prevents an exp gain exploit. - Foxtrot
				to_chat(user, span_warning("[src]正在熔炼。等它完成，或者用水把它浇灭后再把里面的东西取出来。"))
				return
			if(!length(contained_items))
				to_chat(user, span_warn("里面没什么可取出的。"))
				return
			var/obj/item/item_to_remove = contained_items[contained_items.len]
			contained_items -= item_to_remove
			item_to_remove.forceMove(tongs)
			tongs.hingot = item_to_remove
			if(user.mind && isliving(user) && tongs.hingot?.smeltresult) // Prevents an exploit with coal and runtimes with everything else
				if(!istype(tongs.hingot, /obj/item/rogueore) && tongs.hingot?.smelted) // Burning items to ash won't level smelting.
					var/mob/living/L = user
					user.mind.add_sleep_experience(/datum/skill/craft/smelting, L.STAINT * 2, FALSE)// Smelting is already a timesink, this is justified to accelerate levelling
			user.visible_message(span_info("[user] retrieves \the [item_to_remove] from \the [src]."), span_info("你从[src]中取出了[item_to_remove]。"))
			if(on)
				var/tyme = world.time
				tongs.hott = tyme
				addtimer(CALLBACK(tongs, TYPE_PROC_REF(/obj/item/rogueweapon/tongs, make_unhot), tyme), 20 SECONDS)
			tongs.update_icon()
		return

	if(istype(attacking_item, /obj/item/rogueweapon/hammer))
		to_chat(user, span_warning("[attacking_item]应该在铁砧上使用，而不是对着[src]！"))
		return

	if(attacking_item.firefuel)
		. = ..()
		if(!.) //False/null if using the item as fuel. If true, we want to try smelt it so go onto next segment.
			return

	if(attacking_item.smeltresult)
		add_item(attacking_item, user) // Adds the item to the smelter's contained_items list, if it can be smelted.
		return

	to_chat(user, span_warning("[attacking_item]不能被熔炼。"))

/obj/machinery/light/rogue/smelter/attack_right(mob/user)
	var/obj/item/held_item = user.get_active_held_item()
	if(istype(held_item, /obj/item/rogueweapon/tongs))
		attackby(held_item, user)
		return

	if(held_item?.smeltresult)
		add_item(held_item, user)

	return ..()

// Gaining experience from just retrieving bars with your hands would be a hard-to-patch exploit.
/obj/machinery/light/rogue/smelter/attack_hand(mob/user, params)
	if(on)
		to_chat(user, span_warning("太烫了，不能直接徒手取出金属条。"))
		return

	if(length(contained_items))
		var/obj/item/item = contained_items[contained_items.len]
		contained_items -= item
		item.loc = user.loc
		user.put_in_active_hand(item)
		user.visible_message(span_info("[user]从[src]中取出了[item]。"))
		return

	return ..()

/obj/machinery/light/rogue/smelter/proc/add_item(obj/item/smelting_item, mob/user)
	if(!smelting_item)
		return

	if(length(contained_items) >= max_contained_items)
		to_chat(user, span_warning("[smelting_item.name]可以熔炼，但[src]已经满了。"))
		return

	user.dropItemToGround(smelting_item)
	smelting_item.forceMove(src)
	contained_items += smelting_item
	if(!isliving(user) || !user.mind)
		contained_items[smelting_item] = SMELTERY_LEVEL_SPOIL
	else
		var/smelter_exp = user.get_skill_level(/datum/skill/craft/smelting) // 0 to 6
		if(smelter_exp < 6)
			contained_items[smelting_item] = min(6, floor(rand(smelter_exp*15 + 10, max(30, smelter_exp*25))/25)+1) // Math explained below
		else
			contained_items[smelting_item] = 6 // Guarantees a return of 6 no matter how extra experience past 3000 you have.
		/*
		RANDOMLY PICKED NUMBER ACCORDING TO SMELTER SKILL:
			NO SKILL: 		between 10 and 30
			NOVICE:	 		between 25 and 30
			APPRENTICE:	 	between 40 and 50
			JOURNEYMAN: 	between 55 and 75
			EXPERT: 		between 70 and 100
			MASTER: 		between 85 and 125
			LEGENDARY: 		between 100 and 150

		PICKED NUMBER GETS DIVIDED BY 25 AND ROUNDED DOWN TO CLOSEST INTEGER, +1.
		RESULT DETERMINES QUALITY OF BAR. SEE code/__DEFINES/skills.dm
			1 = SPOILED
			2 = POOR
			3 = NORMAL
			4 = GOOD
			5 = GREAT
			6 = EXCELLENT
		*/
	user.visible_message(span_warning("[user]往[src]里放了什么东西。"))
	smelting_progress = 0

/obj/machinery/light/rogue/smelter/process()
	..()

	if(!on || !length(contained_items))
		return

	if(smelting_progress < smelting_ticks)
		smelting_progress++
		playsound(src.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
		actively_smelting = TRUE
		return

	if(smelting_progress != smelting_ticks)
		return

	handle_smelting()

/obj/machinery/light/rogue/smelter/proc/handle_smelting()
	for(var/obj/item/item as anything in contained_items)
		if(item.smeltresult)
			// disabled for now, balance reasons
			// while(item.smelt_bar_num)
			// 	item.smelt_bar_num--
			// 	var/obj/item/result = new item.smeltresult(src, contained_items[item])
			// 	contained_items += result
			// contained_items -= item
			var/obj/item/result = new item.smeltresult(src, contained_items[item])
			contained_items -= item
			contained_items += result
			qdel(item)
	playsound(src,'sound/misc/smelter_fin.ogg', 100, FALSE)
	visible_message(span_notice("[src]熔炼完成了。"))
	smelting_progress = smelting_ticks + 1
	actively_smelting = FALSE

/obj/machinery/light/rogue/smelter/burn_out()
	smelting_progress = 0
	actively_smelting = FALSE
	..()

/obj/machinery/light/rogue/smelter/great
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "巨型熔炉"
	desc = "矮人工程学的巅峰之作，也是马鲁姆赐福火晶的奇迹，使其能够冶炼更高阶的合金。"
	icon_state = "smelter0"
	base_state = "smelter"
	anchored = TRUE
	density = TRUE
	max_contained_items = 4
	smelting_ticks = 30
	climbable = FALSE

/obj/machinery/light/rogue/smelter/great/handle_smelting()
	var/alloy //moving each alloy to it's own var allows for possible additions later
	// Steel Alloy requires a 1 coal to 1 iron ratio. Yes. Doesn't make sense but it is to make
	// Steel more expensive to make
	var/steelalloycoal
	var/steelalloyiron
	var/bronzealloy
	var/purifiedalloy
	var/blacksteelalloy // Idk why Blacksteel were removed but we don't have an overabundance of steel and such anymore

	for(var/obj/item/item as anything in contained_items)
		if(item.smeltresult == /obj/item/rogueore/coal)
			steelalloycoal += 1
		if(item.smeltresult == /obj/item/rogueore/coal/charcoal)
			steelalloycoal += 1
		if(item.smeltresult == /obj/item/ingot/iron)
			steelalloyiron += 1
		if(item.smeltresult == /obj/item/ingot/tin)
			bronzealloy = bronzealloy + 1
		if(item.smeltresult == /obj/item/ingot/copper)
			bronzealloy = bronzealloy + 2
		if(item.smeltresult == /obj/item/ingot/aaslag)
			purifiedalloy = purifiedalloy + 3
		if(item.smeltresult == /obj/item/ingot/gold)
			purifiedalloy = purifiedalloy + 2
		if(item.smeltresult == /obj/item/ingot/silver)
			blacksteelalloy = blacksteelalloy + 1
		if(item.smeltresult == /obj/item/ingot/steel)
			blacksteelalloy = blacksteelalloy + 2

	if(steelalloycoal == 1 && steelalloyiron == 3)
		max_contained_items = 4
		alloy = /obj/item/ingot/steel // 3 bars is an awkward number to work with, considering most people order things that need 2 bars
	else if(bronzealloy == 7)
		alloy = /obj/item/ingot/bronze
	else if(purifiedalloy == 11)
		max_contained_items = 4
		alloy = /obj/item/ingot/gilbranze // 3 aaslag, 1 gold, makes 4 gilbranze, 2 is too few to be worth doing anything with
	else if(blacksteelalloy == 7)
		max_contained_items = 2 // 1 ingot is too few to do anything meaningful with and makes prices too high to sell anything
		alloy = /obj/item/ingot/blacksteel
	else
		alloy = null

	if(alloy)
		// The smelting quality of all ores added together, divided by the number of ores, and then rounded to the lowest integer (this isn't done until after the for loop)
		var/floor_mean_quality = SMELTERY_LEVEL_SPOIL
		var/ore_deleted = 0
		for(var/obj/item/item in contained_items)
			floor_mean_quality += contained_items[item]
			ore_deleted += 1
			contained_items -= item
			qdel(item)
		floor_mean_quality = floor(floor_mean_quality/ore_deleted)
		for(var/i in 1 to max_contained_items)
			var/obj/item/result = new alloy(src, floor_mean_quality)
			contained_items += result
	else
		for(var/obj/item/item in contained_items)
			if(item.smeltresult)
				var/obj/item/result = new item.smeltresult(src, contained_items[item])
				contained_items -= item
				contained_items += result
				qdel(item)

	playsound(src,'sound/misc/smelter_fin.ogg', 100, FALSE)
	visible_message(span_notice("\The [src] finished smelting."))
	max_contained_items = initial(max_contained_items)
	smelting_progress = smelting_ticks + 1
	actively_smelting = FALSE

/obj/machinery/light/rogue/smelter/bronze
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "青铜熔炉"
	desc = "一件人类制造的器物，这座熔炉能够炼出青铜或铁。"
	icon_state = "brosmelter0"
	base_state = "brosmelter"
	anchored = TRUE
	density = TRUE
	max_contained_items = 4
	smelting_ticks = 40
	climbable = FALSE

/obj/machinery/light/rogue/smelter/bronze/handle_smelting()
	var/alloy //moving each alloy to it's own var allows for possible additions later
	var/bronzealloy
	for(var/obj/item/item in contained_items)
		if(item.smeltresult == /obj/item/ingot/tin)
			bronzealloy = bronzealloy + 1
		if(item.smeltresult == /obj/item/ingot/copper)
			bronzealloy = bronzealloy + 2
	if(bronzealloy == 7)
		testing("BRONZE ALLOYED")
		alloy = /obj/item/ingot/bronze
	else
		alloy = null

	if(alloy)
		// The smelting quality of all ores added together, divided by the number of ores, and then rounded to the lowest integer (this isn't done until after the for loop)
		var/floor_mean_quality = SMELTERY_LEVEL_SPOIL
		var/ore_deleted = 0
		for(var/obj/item/item in contained_items)
			floor_mean_quality += contained_items[item]
			ore_deleted += 1
			contained_items -= item
			qdel(item)
		floor_mean_quality = floor(floor_mean_quality/ore_deleted)
		for(var/i in 1 to max_contained_items)
			var/obj/item/result = new alloy(src, floor_mean_quality)
			contained_items += result
	else
		for(var/obj/item/item in contained_items)
			if(item.smeltresult)
				var/obj/item/result = new item.smeltresult(src, contained_items[item])
				contained_items -= item
				contained_items += result
				qdel(item)

	playsound(src,'sound/misc/smelter_fin.ogg', 100, FALSE)
	visible_message(span_notice("\The [src] finished smelting."))
	max_contained_items = initial(max_contained_items)
	smelting_progress = smelting_ticks + 1
	actively_smelting = FALSE

/obj/machinery/light/rogue/smelter/hiron
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "炼铁炉"
	desc = "一件人类制造的器物，这座熔炉能够大量炼铁。"
	icon_state = "hironsmelter0"
	base_state = "hironsmelter"
	anchored = TRUE
	density = TRUE
	max_contained_items = 6
	smelting_ticks = 45
	climbable = FALSE
