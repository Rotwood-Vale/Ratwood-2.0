#define EXPORT_TIME 2.5 MINUTES
#define EXPORT_TIME_TESTING 5 SECONDS

/obj/item/roguemachine/navigator
	name = "navigator"
	desc = "A machine that attracts the attention of trading balloons."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "ballooner"
	density = TRUE
	blade_dulling = DULLING_BASH
	var/next_airlift
	max_integrity = 0
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
	/// A fixed tax on all items sold through the balloon that overrides queens tax. Used for blackmarket
	var/fixed_tax = 0
	/// Motto displayed at the top of the vendor interface
	var/motto = "NAVIGATOR - Your goods, airborne."

/obj/item/roguemachine/navigator/examine()
	. = ..()
	var/export_time = EXPORT_TIME
	#ifdef LOCALTEST
	export_time = EXPORT_TIME_TESTING
	#endif
	. += span_notice("This machine attracts trading balloons every [DisplayTimeText(export_time)]. Goods are sucked into the air and mammons are dropped after tax has been collected.")

/obj/item/roguemachine/navigator/blackmarket
	name = "suspicious navigator"
	desc = "Freedom has a price."
	motto = "NA?!G@#OR - ████ ██████ █████████ - FREEDOM OF TRANSACTION."
	fixed_tax = 0.5 // 50% taxation and rip off to encourage people to risk it with merchant / others

/obj/structure/roguemachine/balloon_pad
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = ""
	density = FALSE
	layer = BELOW_OBJ_LAYER
	anchored = TRUE

/obj/item/roguemachine/navigator/attack_hand(mob/living/user)
	if(!anchored)
		return ..()
	user.changeNext_move(CLICK_CD_INTENTCAP)

	var/contents

	contents += "<center>[motto]<BR>"
	contents += "--------------<BR>"
	if(fixed_tax > 0)
		contents += "HANDLER'S FEE: [fixed_tax * 100] %<BR>"
	contents += "Next Balloon: [time2text((next_airlift - world.time), "mm:ss")]</center><BR>"

	if(!user.can_read(src, TRUE))
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 300)
	popup.set_content(contents)
	popup.open()

/obj/item/roguemachine/navigator/update_icon()
	if(!anchored)
		w_class = WEIGHT_CLASS_BULKY
		set_light(0)
		return
	w_class = WEIGHT_CLASS_GIGANTIC
	set_light(2, 2, 2, l_color = "#1b7bf1")

/obj/item/roguemachine/navigator/Initialize(mapload)
	. = ..()
	if(anchored)
		START_PROCESSING(SSroguemachine, src)
	update_icon()
	if(SSmerchant_trade)
		SSmerchant_trade.register_market_watcher(src)
	for(var/X in GLOB.alldirs)
		var/T = get_step(src, X)
		if(!T)
			continue
		new /obj/structure/roguemachine/balloon_pad(T)

/obj/item/roguemachine/navigator/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	if(SSmerchant_trade)
		SSmerchant_trade.unregister_market_watcher(src)
	set_light(0)
	return ..()

/obj/item/roguemachine/navigator/process()
	if(!anchored)
		return TRUE
	var/export_time = EXPORT_TIME
	#ifdef LOCALTEST
		export_time = EXPORT_TIME_TESTING
	#endif
	if(world.time > next_airlift)
		next_airlift = world.time + export_time
		var/play_sound = FALSE
		for(var/D in GLOB.alldirs)
			var/budgie = 0
			var/turf/T = get_step(src, D)
			if(!T)
				continue
			var/obj/structure/roguemachine/balloon_pad/E = locate() in T
			if(!E)
				continue
			for(var/obj/I in T)
				if(I.anchored || !isturf(I.loc) || istype(I, /obj/item/roguecoin)|| istype(I, /obj/structure/handcart))
					continue
				var/prize = I.get_real_price() * (1 - fixed_tax)
				if(prize >= 1)
					play_sound=TRUE
					budgie += prize
					I.visible_message(span_warning("[I] is sucked into the air!"))
					qdel(I)
			budgie = round(budgie)
			record_round_statistic(STATS_TRADE_VALUE_EXPORTED, budgie)
			if(budgie > 0)
				play_sound=TRUE
				E.budget2change(budgie)
				budgie = 0
		if(play_sound)
			playsound(src.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)

// ---- Economy 3 (merchant_trade) market pool bucket helpers ----
// Ported from AP code/controllers/subsystem/rogue/market_pools.dm (Economy 3 PR #7000).
// Only the subset needed by SSmerchant_trade's Initialize()/pool bookkeeping is included here;
// get_navigator_bucket_for_item(), get_market_pool_tier_for_category(), get_market_theme_for_category(),
// all_market_pool_categories(), compute_market_pool_capacity(), and get_navigator_refusal_message()
// were left out because they depend on /obj/item vars (is_carved, was_crafted) that ES has not
// ported yet - they belong to the goldface/silverface TGUI rework, not the core subsystem.

/proc/get_navigator_bucket_for_category(category)
	switch(category)
		if(ITEM_CAT_WEAPONS_SWORDS, ITEM_CAT_WEAPONS_DAGGERS, ITEM_CAT_WEAPONS_AXES, ITEM_CAT_WEAPONS_POLEARMS, ITEM_CAT_WEAPONS_MACES, ITEM_CAT_WEAPONS_FLAILS, ITEM_CAT_WEAPONS_SHIELDS, ITEM_CAT_WEAPONS_AMMO)
			return NAVIGATOR_BUCKET_WEAPONS
		if(ITEM_CAT_ARMOR_LIGHT)
			return NAVIGATOR_BUCKET_ARMOR_LIGHT
		if(ITEM_CAT_ARMOR_HELMETS, ITEM_CAT_ARMOR_CHESTPIECES, ITEM_CAT_ARMOR_LEGS, ITEM_CAT_ARMOR_NECK, ITEM_CAT_ARMOR_BOOTS, ITEM_CAT_ARMOR_GLOVES, ITEM_CAT_ARMOR_MASKS, ITEM_CAT_ARMOR_BRACERS, ITEM_CAT_ARMOR_BELTS, ITEM_CAT_ARMOR_BARDING)
			return NAVIGATOR_BUCKET_ARMOR_HEAVY
		if(ITEM_CAT_GARMENT_COMMON, ITEM_CAT_TAILOR_MISC, ITEM_CAT_CLOTH_MASK)
			return NAVIGATOR_BUCKET_GARMENT_COMMON
		if(ITEM_CAT_GARMENT_FINE)
			return NAVIGATOR_BUCKET_GARMENT_FINELUX
		if(ITEM_CAT_ENG_MACHINERY, ITEM_CAT_ENG_CONSTRUCTION, ITEM_CAT_ENG_COMBAT, ITEM_CAT_ENG_TRIGGERS, ITEM_CAT_ENG_MISC)
			return NAVIGATOR_BUCKET_ENGINEERING
		if(ITEM_CAT_VALUABLES_RINGS, ITEM_CAT_VALUABLES_HOLY, ITEM_CAT_DECORATION)
			return NAVIGATOR_BUCKET_VALUABLES_LOOTED
		if(ITEM_CAT_POTTERY)
			return NAVIGATOR_BUCKET_POTTERY
		if(ITEM_CAT_TROPHY)
			return NAVIGATOR_BUCKET_TROPHIES
		if(ITEM_CAT_INSTRUMENT)
			return NAVIGATOR_BUCKET_INSTRUMENTS
		if(ITEM_CAT_SEAFOOD)
			return NAVIGATOR_BUCKET_SEAFOOD
		if(ITEM_CAT_POTION, ITEM_CAT_REAGENT_ALCHEMICAL, ITEM_CAT_REAGENT_ARCANE, ITEM_CAT_ARCYNE_GEARS)
			return NAVIGATOR_BUCKET_POTIONS_REAGENTS
		if(ITEM_CAT_MAGICAL)
			return NAVIGATOR_BUCKET_ENCHANTMENTS
		if(ITEM_CAT_FOODSTUFF_FRESH, ITEM_CAT_FOODSTUFF_PRESERVED)
			return NAVIGATOR_BUCKET_REFUSED_FOOD
		if(ITEM_CAT_RAW_MATERIAL_MINERAL, ITEM_CAT_RAW_MATERIAL_ORGANIC, ITEM_CAT_SALVAGE, ITEM_CAT_LIVESTOCK, ITEM_CAT_TOOLS_COOKWARE, ITEM_CAT_TOOLS_FIELD, ITEM_CAT_TOOLS_WORKSHOP, ITEM_CAT_TOOLS_SUNDRIES, ITEM_CAT_TOOLS_ROGUE, ITEM_CAT_COMPONENTS, ITEM_CAT_SMITHING_MISC)
			return NAVIGATOR_BUCKET_REFUSED_BULK
	return NAVIGATOR_BUCKET_MISCELLANEOUS

/proc/all_navigator_buckets()
	return list(
		NAVIGATOR_BUCKET_WEAPONS,
		NAVIGATOR_BUCKET_ARMOR_LIGHT,
		NAVIGATOR_BUCKET_ARMOR_HEAVY,
		NAVIGATOR_BUCKET_GARMENT_COMMON,
		NAVIGATOR_BUCKET_GARMENT_FINELUX,
		NAVIGATOR_BUCKET_ENGINEERING,
		NAVIGATOR_BUCKET_VALUABLES_CRAFTED,
		NAVIGATOR_BUCKET_VALUABLES_LOOTED,
		NAVIGATOR_BUCKET_CARVED,
		NAVIGATOR_BUCKET_POTTERY,
		NAVIGATOR_BUCKET_TROPHIES,
		NAVIGATOR_BUCKET_ENCHANTMENTS,
		NAVIGATOR_BUCKET_INSTRUMENTS,
		NAVIGATOR_BUCKET_SEAFOOD,
		NAVIGATOR_BUCKET_POTIONS_REAGENTS,
		NAVIGATOR_BUCKET_MISCELLANEOUS,
	)

/proc/get_navigator_bucket_pool_baseline(bucket)
	switch(bucket)
		if(NAVIGATOR_BUCKET_WEAPONS)
			return NAVIGATOR_BUCKET_POOL_WEAPONS
		if(NAVIGATOR_BUCKET_ARMOR_LIGHT)
			return NAVIGATOR_BUCKET_POOL_ARMOR_LIGHT
		if(NAVIGATOR_BUCKET_ARMOR_HEAVY)
			return NAVIGATOR_BUCKET_POOL_ARMOR_HEAVY
		if(NAVIGATOR_BUCKET_GARMENT_COMMON)
			return NAVIGATOR_BUCKET_POOL_GARMENT_COMMON
		if(NAVIGATOR_BUCKET_GARMENT_FINELUX)
			return NAVIGATOR_BUCKET_POOL_GARMENT_FINELUX
		if(NAVIGATOR_BUCKET_ENGINEERING)
			return NAVIGATOR_BUCKET_POOL_ENGINEERING
		if(NAVIGATOR_BUCKET_VALUABLES_CRAFTED)
			return NAVIGATOR_BUCKET_POOL_VALUABLES_CRAFTED
		if(NAVIGATOR_BUCKET_VALUABLES_LOOTED)
			return NAVIGATOR_BUCKET_POOL_VALUABLES_LOOTED
		if(NAVIGATOR_BUCKET_CARVED)
			return NAVIGATOR_BUCKET_POOL_CARVED
		if(NAVIGATOR_BUCKET_POTTERY)
			return NAVIGATOR_BUCKET_POOL_POTTERY
		if(NAVIGATOR_BUCKET_TROPHIES)
			return NAVIGATOR_BUCKET_POOL_TROPHIES
		if(NAVIGATOR_BUCKET_ENCHANTMENTS)
			return NAVIGATOR_BUCKET_POOL_ENCHANTMENTS
		if(NAVIGATOR_BUCKET_INSTRUMENTS)
			return NAVIGATOR_BUCKET_POOL_INSTRUMENTS
		if(NAVIGATOR_BUCKET_SEAFOOD)
			return NAVIGATOR_BUCKET_POOL_SEAFOOD
		if(NAVIGATOR_BUCKET_POTIONS_REAGENTS)
			return NAVIGATOR_BUCKET_POOL_POTIONS_REAGENTS
		if(NAVIGATOR_BUCKET_MISCELLANEOUS)
			return NAVIGATOR_BUCKET_POOL_MISCELLANEOUS
	return 0

/proc/get_navigator_bucket_theme(bucket)
	switch(bucket)
		if(NAVIGATOR_BUCKET_WEAPONS, NAVIGATOR_BUCKET_ARMOR_LIGHT, NAVIGATOR_BUCKET_ARMOR_HEAVY)
			return MARKET_THEME_WARGEAR
		if(NAVIGATOR_BUCKET_POTIONS_REAGENTS, NAVIGATOR_BUCKET_ENCHANTMENTS)
			return MARKET_THEME_ARCYNE
		if(NAVIGATOR_BUCKET_GARMENT_COMMON, NAVIGATOR_BUCKET_GARMENT_FINELUX)
			return MARKET_THEME_GARMENTS
		if(NAVIGATOR_BUCKET_SEAFOOD)
			return MARKET_THEME_FOODSTUFFS
		if(NAVIGATOR_BUCKET_VALUABLES_CRAFTED, NAVIGATOR_BUCKET_VALUABLES_LOOTED, NAVIGATOR_BUCKET_CARVED, NAVIGATOR_BUCKET_POTTERY, NAVIGATOR_BUCKET_TROPHIES, NAVIGATOR_BUCKET_INSTRUMENTS)
			return MARKET_THEME_LOOT
		if(NAVIGATOR_BUCKET_ENGINEERING)
			return MARKET_THEME_ENGINEERING
	return MARKET_THEME_MISC

/proc/get_navigator_bucket_pop_scale(bucket)
	switch(bucket)
		if(NAVIGATOR_BUCKET_VALUABLES_LOOTED)
			return MARKET_POOL_POP_SCALE_VALUABLES_LOOTED
	return MARKET_POOL_POP_SCALE

/proc/compute_navigator_bucket_capacity(bucket, pop_count, list/theme_jitters)
	var/baseline = get_navigator_bucket_pool_baseline(bucket)
	if(baseline <= 0)
		return 0
	var/scale = get_navigator_bucket_pop_scale(bucket)
	var/pop_mult = 1 + scale * max(0, pop_count - MARKET_POOL_POP_REFERENCE)
	var/theme = get_navigator_bucket_theme(bucket)
	var/jitter = theme_jitters ? (theme_jitters[theme] || 1.0) : (MARKET_POOL_JITTER_LOW + rand() * (MARKET_POOL_JITTER_HIGH - MARKET_POOL_JITTER_LOW))
	return round(baseline * pop_mult * jitter)

/proc/roll_market_theme_jitters()
	var/list/themes = list(MARKET_THEME_WARGEAR, MARKET_THEME_ARCYNE, MARKET_THEME_GARMENTS, MARKET_THEME_FOODSTUFFS, MARKET_THEME_LOOT, MARKET_THEME_RAWS, MARKET_THEME_ENGINEERING, MARKET_THEME_MISC)
	var/list/out = list()
	for(var/theme in themes)
		out[theme] = MARKET_POOL_JITTER_LOW + rand() * (MARKET_POOL_JITTER_HIGH - MARKET_POOL_JITTER_LOW)
	return out

/proc/compute_pop_count_for_pools()
	return length(GLOB.clients)

/proc/market_theme_label(theme)
	switch(theme)
		if(MARKET_THEME_WARGEAR)
			return "Wargear"
		if(MARKET_THEME_ARCYNE)
			return "Arcyne Goods"
		if(MARKET_THEME_GARMENTS)
			return "Garments"
		if(MARKET_THEME_FOODSTUFFS)
			return "Foodstuffs"
		if(MARKET_THEME_LOOT)
			return "Luxuries"
		if(MARKET_THEME_RAWS)
			return "Raw Stock"
		if(MARKET_THEME_ENGINEERING)
			return "Engineered Wares"
	return "Sundries"

/proc/build_market_theme_dispatch(list/theme_jitters)
	if(!length(theme_jitters))
		return ""
	var/list/glut = list()
	var/list/scarce = list()
	for(var/theme in theme_jitters)
		var/j = theme_jitters[theme]
		if(j >= MARKET_THEME_HIGH_JITTER)
			scarce += market_theme_label(theme)
		else if(j <= MARKET_THEME_LOW_JITTER)
			glut += market_theme_label(theme)
	var/list/parts = list()
	if(length(scarce))
		parts += "Scarce: [english_list(scarce)]"
	if(length(glut))
		parts += "In Glut: [english_list(glut)]"
	if(!length(parts))
		return "Markets steady across the board."
	return "This week: [jointext(parts, "; ")]."
