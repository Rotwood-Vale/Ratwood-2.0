/obj/effect/proc_holder/spell/invoked/vigorousexchange
	name = "活力交换"
	desc = "恢复目标的体力，对他人施放时效果翻倍。"
	overlay_icon = 'icons/mob/actions/malummiracles.dmi'
	action_icon = 'icons/mob/actions/malummiracles.dmi'
	overlay_state = "vigorous_exchange"
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	warnie = "sydwarning"
	movement_interrupt = FALSE
	no_early_release = TRUE
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/items/bsmithfail.ogg'
	invocations = list("借火与灰烬之力，让活力再起，凭 玛勒姆 之手，使力量重归！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 3 MINUTES
	chargetime = 2 SECONDS
	miracle = TRUE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	devotion_cost = 30
	
/obj/effect/proc_holder/spell/invoked/heatmetal
	name = "炽金"
	desc= "损伤护甲，迫使目标丢下金属武器，加热钳中的锭料，或熔化单个物品。"
	overlay_icon = 'icons/mob/actions/malummiracles.dmi'
	action_icon = 'icons/mob/actions/malummiracles.dmi'
	overlay_state = "heat_metal"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 15
	warnie = "sydwarning"
	movement_interrupt = FALSE
	no_early_release = TRUE
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/items/bsmithfail.ogg'
	invocations = list("我执掌炽热，我号令火焰，让金属以 玛勒姆 之名俯首！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 2 MINUTES
	chargetime = 2 SECONDS
	miracle = TRUE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	devotion_cost = 40

/obj/effect/proc_holder/spell/invoked/hammerfall
	name = "熔锤坠击"
	desc = "破坏一片区域内的建筑，并可能击倒范围内的生物。"
	overlay_icon = 'icons/mob/actions/malummiracles.dmi'
	action_icon = 'icons/mob/actions/malummiracles.dmi'
	overlay_state = "hammerfall"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 15
	warnie = "sydwarning"
	movement_interrupt = FALSE
	no_early_release = TRUE
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/items/bsmithfail.ogg'
	invocations = list("凭熔火之威，借战锤之重，于 玛勒姆 烈焰中令大地震颤！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 MINUTES
	chargetime = 2 SECONDS
	miracle = TRUE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	devotion_cost = 80
	/// Structural damage the spell does
	var/const/structure_damage = 1000
	/// Radius of the spell
	var/const/radius = 1
	/// Radius of the quake
	var/const/shakeradius = 7
	/// Delay between the ground marking appearing and the effect playing
	var/const/delay = 2 SECONDS

/obj/effect/proc_holder/spell/invoked/hammerfall/cast(list/targets, mob/user = usr)
	var/turf/fallzone = null
	fallzone = get_turf(targets[1])
	if(!fallzone)
		return
	show_visible_message(usr, "[usr] 抬起手臂，唤出一柄缠绕熔火的战锤。随着它被猛然掷向地面，大地在冲击下震颤，连根基都仿佛摇动起来！", "我抬起手臂，唤出一柄缠绕熔火的战锤。随着它被猛然掷向地面，大地在冲击下震颤，连根基都仿佛摇动起来！")
	for(var/turf/open/visual in view(radius, fallzone))
		var/obj/effect/temp_visual/lavastaff/Lava = new /obj/effect/temp_visual/lavastaff(visual)
		animate(Lava, alpha = 255, time = 5)
	sleep(delay)
	for(var/mob/living/carbon/screenshaken in view(shakeradius, fallzone))
		shake_camera(screenshaken, 5, 5)
	for(var/mob/living/carbon/shaken in view(radius, fallzone))
		shaken.apply_effect(1 SECONDS, EFFECT_KNOCKDOWN, 0)
		show_visible_message(shaken, null, "地面剧烈震动，让我摔倒在地。")
	for(var/obj/structure/damaged in view(radius, fallzone))
		if(istype(damaged, /obj/structure/flora/newbranch))
			continue
		damaged.take_damage(structure_damage, BRUTE,"blunt",1)
	for(var/turf/closed/wall/damagedwalls in view(radius, fallzone))
		damagedwalls.take_damage(structure_damage, BRUTE,"blunt",1)
	for(var/turf/closed/mineral/aoemining in view(radius, fallzone))
		aoemining.lastminer = usr
		aoemining.take_damage(structure_damage, BRUTE,"blunt",1)

/obj/effect/proc_holder/spell/invoked/craftercovenant
	name = "匠造之约"
	desc = "将一堆贵重物熔化并塑成单件物品。即便祭品价值不足以造出任何东西，玛勒姆依然会收下它。"
	overlay_icon = 'icons/mob/actions/malummiracles.dmi'
	action_icon = 'icons/mob/actions/malummiracles.dmi'
	overlay_state = "craftercovenant"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 1
	warnie = "sydwarning"
	movement_interrupt = TRUE
	no_early_release = TRUE
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/items/bsmithfail.ogg'
	invocations = list("让钱币化灰，让火焰塑形，以 玛勒姆 之名，令造物诞生！")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 25 MINUTES
	chargetime = 10 SECONDS
	miracle = TRUE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	devotion_cost = 100

/obj/effect/proc_holder/spell/invoked/heatmetal/cast(list/targets, mob/user = usr)
	. = ..()
	var/list/nosmeltore = list(/obj/item/rogueore/coal)
	var/datum/effect_system/spark_spread/sparks = new()
	var/target
	for(var/i in targets)
		target = i
	if (!target)
		return
	if(target in nosmeltore)
		return
	if (istype(target, /obj/item))
		handle_item_smelting(target, user, sparks, nosmeltore)
	else if (iscarbon(target))
		handle_living_entity(target, user, nosmeltore)

/proc/show_visible_message(mob/user, text, selftext)
	var/text_to_send = addtext("<font color='yellow'>", text, "</font>")
	var/selftext_to_send = addtext("<font color='yellow'>", selftext, "</font>")
	user.visible_message(text_to_send, selftext_to_send)

/proc/handle_item_smelting(obj/item/target, mob/user, datum/effect_system/spark_spread/sparks, list/nosmeltore)
	if (!target.smeltresult) return
	var/obj/item/itemtospawn = target.smeltresult
	show_visible_message(user, "[user] 念毕咒语后，[target] 猛地泛起炽光，随即熔成了一块锭料。", null)
	new itemtospawn(get_turf(target))
	sparks.set_up(1, 1, get_turf(target))
	sparks.start()
	qdel(target)

/proc/handle_living_entity(mob/target, mob/user, list/nosmeltore)
	var/obj/item/targeteditem = get_targeted_item(user, target)
	if (!targeteditem || targeteditem.smeltresult == /obj/item/ash || target.anti_magic_check(TRUE,TRUE)) 
		show_visible_message(user, "[user] 念完咒后指向 [target]，可那似乎毫无效果。", "我念完咒后指向 [target]，可那似乎毫无效果。")
		return
	if (istype(targeteditem, /obj/item/rogueweapon/tongs))
		handle_tongs(targeteditem, user)
	else if (should_heat_in_hand(user, target, targeteditem, nosmeltore))
		handle_heating_in_hand(target, targeteditem, user)
	else
		handle_heating_equipped(target, targeteditem, user)

/proc/get_targeted_item(mob/user, mob/target)
	var/target_item
	switch(user.zone_selected)
		if (BODY_ZONE_PRECISE_R_HAND)
			target_item = target.held_items[2]
		if (BODY_ZONE_PRECISE_L_HAND)
			target_item = target.held_items[1]
		if (BODY_ZONE_HEAD)
			target_item = target.get_item_by_slot(SLOT_HEAD)
		if (BODY_ZONE_PRECISE_EARS)
			target_item = target.get_item_by_slot(SLOT_HEAD)
		if (BODY_ZONE_CHEST)
			if(target.get_item_by_slot(SLOT_ARMOR))
				target_item = target.get_item_by_slot(SLOT_ARMOR)
			else if (target.get_item_by_slot(SLOT_SHIRT))
				target_item = target.get_item_by_slot(SLOT_SHIRT)    
		if (BODY_ZONE_PRECISE_NECK)
			target_item = target.get_item_by_slot(SLOT_NECK)
		if (BODY_ZONE_PRECISE_R_EYE)
			target_item = target.get_item_by_slot(ITEM_SLOT_MASK)
		if ( BODY_ZONE_PRECISE_L_EYE)
			target_item = target.get_item_by_slot(ITEM_SLOT_MASK)
		if (BODY_ZONE_PRECISE_NOSE)
			target_item = target.get_item_by_slot(ITEM_SLOT_MASK)
		if (BODY_ZONE_PRECISE_MOUTH)
			target_item = target.get_item_by_slot(ITEM_SLOT_MOUTH)
		if (BODY_ZONE_L_ARM)
			target_item = target.get_item_by_slot(ITEM_SLOT_WRISTS)
		if (BODY_ZONE_R_ARM)
			target_item = target.get_item_by_slot(ITEM_SLOT_WRISTS)
		if (BODY_ZONE_L_LEG)
			target_item = target.get_item_by_slot(ITEM_SLOT_PANTS)
		if (BODY_ZONE_R_LEG)
			target_item = target.get_item_by_slot(ITEM_SLOT_PANTS)
		if (BODY_ZONE_PRECISE_GROIN)
			target_item = target.get_item_by_slot(ITEM_SLOT_PANTS)
		if (BODY_ZONE_PRECISE_R_FOOT)
			target_item = target.get_item_by_slot(ITEM_SLOT_SHOES)
		if (BODY_ZONE_PRECISE_L_FOOT)
			target_item = target.get_item_by_slot(ITEM_SLOT_SHOES)
	return target_item

/proc/handle_tongs(obj/item/rogueweapon/tongs/T, mob/user) //Stole the code from smithing.
	if (!T.hingot) return
	var/tyme = world.time
	T.hott = tyme
	addtimer(CALLBACK(T, TYPE_PROC_REF(/obj/item/rogueweapon/tongs, make_unhot), tyme), 100)
	T.update_icon()
	show_visible_message(user, "[user] 念毕咒语后，[T] 中的锭料开始发出炽亮红光。", "我念毕咒语后，[T] 中的锭料开始发出炽亮红光。")

/proc/handle_heating_in_hand(mob/living/carbon/target, obj/item/targeteditem, mob/user)
	var/datum/effect_system/spark_spread/sparks = new()
	apply_damage_to_hands(target, user)
	target.dropItemToGround(targeteditem)
	show_visible_message(target, "[target] 的 [targeteditem.name] 猛然发亮，灼烧起他们的血肉。", "我的 [targeteditem.name] 猛然发亮，烫得我血肉生疼！")
	target.emote("painscream")
	playsound(get_turf(target), 'sound/misc/frying.ogg', 100, FALSE, -1)
	sparks.set_up(1, 1, get_turf(target))
	sparks.start()

/proc/should_heat_in_hand(mob/user, mob/target, obj/item/targeteditem, list/nosmeltore)
	return ((user.zone_selected == BODY_ZONE_PRECISE_L_HAND && target.held_items[1]) || (user.zone_selected == BODY_ZONE_PRECISE_R_HAND && target.held_items[2])) && !(targeteditem in nosmeltore) && targeteditem.smeltresult

/proc/apply_damage_to_hands(mob/living/carbon/target, mob/user)
	var/obj/item/bodypart/affecting
	var/const/adth_damage_to_apply = 10 //How much damage should burning your hand before dropping the item do.
	if (user.zone_selected == BODY_ZONE_PRECISE_R_HAND)
		affecting = target.get_bodypart(BODY_ZONE_R_ARM)
	else if (user.zone_selected == BODY_ZONE_PRECISE_L_HAND)
		affecting = target.get_bodypart(BODY_ZONE_L_ARM)
	affecting.receive_damage(0, adth_damage_to_apply)

/proc/handle_heating_equipped(mob/living/carbon/target, obj/item/clothing/targeteditem, mob/user)
	var/obj/item/armor = target.get_item_by_slot(SLOT_ARMOR)
	var/obj/item/shirt = target.get_item_by_slot(SLOT_SHIRT)
	var/armor_can_heat = armor && armor.smeltresult && armor.smeltresult != /obj/item/ash
	var/shirt_can_heat = shirt && shirt.smeltresult && shirt.smeltresult != /obj/item/ash // Full damage if no shirt 
	var/damage_to_apply = 20 // How much damage should your armor burning you should do.
	if (user.zone_selected == BODY_ZONE_CHEST)
		if (armor_can_heat && (!shirt_can_heat && shirt))
			damage_to_apply = damage_to_apply / 2 // Halve the damage if only armor can heat but shirt can't.
		if (targeteditem == shirt & armor_can_heat) //this looks redundant but it serves to make sure the damage is doubled if both shirt and armor are metallic.
			apply_damage_if_covered(target, list(BODY_ZONE_CHEST), armor, CHEST, damage_to_apply)
		else if (targeteditem == armor & shirt_can_heat)
			apply_damage_if_covered(target, list(BODY_ZONE_CHEST), shirt, CHEST, damage_to_apply)
	apply_damage_if_covered(target, list(BODY_ZONE_CHEST), targeteditem, CHEST, damage_to_apply)
	apply_damage_if_covered(target, list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM), targeteditem, ARMS|HANDS, damage_to_apply)
	apply_damage_if_covered(target, list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), targeteditem, GROIN|LEGS|FEET, damage_to_apply)
	apply_damage_if_covered(target, list(BODY_ZONE_HEAD), targeteditem, HEAD|HAIR|NECK|NOSE|MOUTH|EARS|EYES, damage_to_apply)
	show_visible_message(target, "[target] 的 [targeteditem.name] 猛然发亮，灼烧起他们的血肉。", "我的 [targeteditem.name] 猛然发亮，烫得我血肉生疼！")
	playsound(get_turf(target), 'sound/misc/frying.ogg', 100, FALSE, -1)

/proc/apply_damage_if_covered(mob/living/carbon/target, list/body_zones, obj/item/clothing/targeteditem, mask, damage)
	var/datum/effect_system/spark_spread/sparks = new()
	var/obj/item/bodypart/affecting = null
	for (var/zone in body_zones)
	{
		if (targeteditem.body_parts_covered & mask)
			affecting = target.get_bodypart(zone)
		if (affecting)
			affecting.receive_damage(0, damage)
			sparks.set_up(1, 1, get_turf(target))
			sparks.start()
	}

/obj/effect/proc_holder/spell/invoked/vigorousexchange/cast(list/targets, mob/living/carbon/user = usr)
	. = ..()
	var/const/starminatoregen = 500 // How much stamina should the spell give back to the caster.
	var/mob/target = targets[1]
	if (!iscarbon(target)) 
		return
	if (target == user)
		target.energy_add(starminatoregen)
		show_visible_message(usr, "[user] 吟诵咒文时，鲜活的火焰在他们周身盘旋。", "我吟诵咒文时，鲜活的火焰在我周身盘旋。我感到精神一振。")
	else if (user.energy > (starminatoregen * 2))
		user.energy_add(-(starminatoregen * 2))
		target.energy_add(starminatoregen * 2)
		show_visible_message(target, "[user] 吟诵咒文时，鲜活的火焰在他们周身盘旋，随后化作一道活力之流涌向 [target]。", "[user] 吟诵咒文时，鲜活的火焰在他们周身盘旋，随后化作一道活力之流涌向我。我感到精神一振。")

/obj/effect/proc_holder/spell/invoked/craftercovenant/cast(list/targets, mob/user = usr)
	. = ..()
	var/tithe = 0
	var/list/doable[][] = list()
	var/const/divine_tax = 2 // Multiplier used to adjust the price that should be paid.
	var/buyprice = 0
	var/turf/altar
	var/datum/effect_system/spark_spread/sparks = new()
	altar = get_turf(targets[1])
	if(!altar)
		return
	for (var/obj/item/sacrifice in altar.contents)
	{
		if (istype(sacrifice, /obj/item/roguecoin/))
			var/obj/item/roguecoin/coincrifice = sacrifice
			tithe += (coincrifice.quantity * coincrifice.sellprice)
		else if (istype(sacrifice, /obj/item/roguestatue/) || istype(sacrifice, /obj/item/clothing/ring/) || istype(sacrifice, /obj/item/roguegem/))
			tithe += sacrifice.sellprice
		qdel(sacrifice)
	}
	buyprice = tithe / divine_tax
	for (var/list/entry in GLOB.anvil_recipe_prices)
	{
		var/obj/item/tentative_item = entry[1] // The recipe
		var/total_sellprice = entry[2] // The precompiled material price
		if (total_sellprice <= buyprice)
			var/obj/itemtorecord = tentative_item
			doable += list(list(itemtorecord.name, itemtorecord))
	}
	if (!doable.len)
		show_visible_message(usr, "[user] 呼唤 玛勒姆 之名时，一阵热浪席卷了这堆祭品。成堆贵重物随之崩解成尘。", "当我呼唤 玛勒姆 之名时，一阵热浪席卷了这堆祭品。成堆贵重物随之崩解成尘。玛勒姆 接受了你的祭品，但显然还远远不够。")
		return
	var/list/doablename = list()
	var/list/item_map = list()
	for (var/list/doableextract in doable)
	{
		doablename += list(doableextract[1])
		item_map[doableextract[1]] = doableextract[2]
	}
	var/itemchoice = input(user, "选择你的恩赐", "可选恩赐") in (doablename)
	if (itemchoice)
		var/obj/item/itemtospawn = item_map[itemchoice]
		if (itemtospawn)
			new itemtospawn.type(altar)
			sparks.set_up(1, 1, altar)
			sparks.start()
			show_visible_message(usr, "[user] 呼唤 玛勒姆 之名时，一阵热浪席卷了这堆祭品。贵重物崩解成尘，又像自火中重生般重新凝成了一件器物。玛勒姆 接受了这次供奉。", "当我呼唤 玛勒姆 之名时，一阵热浪席卷了这堆祭品。贵重物崩解成尘，又像自火中重生般重新凝成了一件器物。玛勒姆 接受了这次供奉。")

GLOBAL_LIST_EMPTY(anvil_recipe_prices)

/proc/add_recipe_to_global(datum/anvil_recipe/recipe)
	var/total_sellprice = 0
	var/obj/item/ingot/bar = recipe.req_bar
	var/obj/item/itemtosend = null
	if (bar)
		total_sellprice += bar.sellprice
		itemtosend = recipe.created_item
	if (recipe.additional_items)
		for (var/obj/additional_item in recipe.additional_items)
			total_sellprice += additional_item.sellprice
	if (islist(recipe.created_item))
		var/list/itemlist = recipe.created_item
		total_sellprice = total_sellprice/itemlist.len
		itemtosend = itemlist[1]
	if (!istype(recipe.created_item, /list))
		itemtosend = recipe.created_item
	if (total_sellprice > 0)
		GLOB.anvil_recipe_prices += list(list(itemtosend, total_sellprice))

/proc/initialize_anvil_recipe_prices()
	for (var/datum/anvil_recipe/armor/recipe)
	{
		add_recipe_to_global(recipe)
	}
	for (var/datum/anvil_recipe/tools/recipe)
	{
		add_recipe_to_global(recipe)
	}
	for (var/datum/anvil_recipe/weapons/recipe)
	{
		add_recipe_to_global(recipe)
	}
	GLOB.anvil_recipe_prices += list(list(new /obj/item/rogue/instrument/flute, 10))
	GLOB.anvil_recipe_prices += list(list(new /obj/item/rogue/instrument/drum, 10))
	GLOB.anvil_recipe_prices += list(list(new /obj/item/rogue/instrument/harp, 20))
	GLOB.anvil_recipe_prices += list(list(new /obj/item/rogue/instrument/trumpet, 20))
	GLOB.anvil_recipe_prices += list(list(new /obj/item/rogue/instrument/lute, 20))
	GLOB.anvil_recipe_prices += list(list(new /obj/item/rogue/instrument/guitar, 30))
	GLOB.anvil_recipe_prices += list(list(new /obj/item/rogue/instrument/accord, 30))
	GLOB.anvil_recipe_prices += list(list(new /obj/item/riddleofsteel, 400))
	GLOB.anvil_recipe_prices += list(list(new /obj/item/dmusicbox, 500))
	// Add any other recipe types if needed

/world/New()
	..()
	initialize_anvil_recipe_prices() // Precompute recipe prices on startup

/obj/effect/proc_holder/spell/invoked/malum_flame_rogue
	name = "玛勒姆 之火"
	desc = "点燃目标。"
	overlay_icon = 'icons/mob/actions/malummiracles.dmi'
	action_icon = 'icons/mob/actions/malummiracles.dmi'
	overlay_state = "malum_fire"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0
	range = 15
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/heal.ogg'
	invocations = list("燃。")
	invocation_type = "whisper"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	miracle = TRUE
	devotion_cost = 15

/obj/effect/proc_holder/spell/invoked/malum_flame_rogue/cast(list/targets, mob/user = usr)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/L = targets[1]
		user.visible_message("<font color='yellow'>[user] 抬手指向了 [L]！</font>")
		if(L.anti_magic_check(TRUE, TRUE))
			return FALSE
		L.adjust_fire_stacks(1, /datum/status_effect/fire_handler/fire_stacks/divine)
		L.ignite_mob()
		return TRUE

	// Spell interaction with ignitable objects (burn wooden things, light torches up)
	else if(isobj(targets[1]))
		var/obj/O = targets[1]
		if(O.fire_act())
			user.visible_message("<font color='yellow'>[user] 指向 [O]，以圣焰将其点燃！</font>")
			return TRUE
		else
			to_chat(user, span_warning("我指向 [O]，但它没能燃起来。"))
			return FALSE
	return FALSE


/obj/effect/temp_visual/lavastaff
	icon_state = "lavastaff_warn"
	duration = 50
