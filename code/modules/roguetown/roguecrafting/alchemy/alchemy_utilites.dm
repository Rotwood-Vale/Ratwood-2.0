GLOBAL_LIST_INIT(alch_tier_easy, list(
	/obj/item/alch/symphitum,
	/obj/item/alch/taraxacum,
	/obj/item/alch/mentha,
	/obj/item/alch/urtica,
	/obj/item/alch/atropa,
	/obj/item/alch/seeddust,
	/obj/item/alch/paris,
	/obj/item/alch/matricaria,
	/obj/item/alch/euphrasia,
	/obj/item/alch/berrypowder,
	/obj/item/alch/calendula,
	/obj/item/alch/hypericum,
	/obj/item/alch/benedictus,
	/obj/item/alch/valeriana,
	/obj/item/alch/artemisia,
	/obj/item/alch/manabloompowder,
	/obj/item/alch/salvia,
	/obj/item/alch/ozium,
	/obj/item/alch/rosa,
	/obj/item/reagent_containers/powder/ozium,
	/obj/item/reagent_containers/food/snacks/grown/wheat,
	/obj/item/reagent_containers/powder/ozium,
	/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
	/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry,
	/obj/item/reagent_containers/food/snacks/grown/garlick/rogue,
	/obj/item/reagent_containers/food/snacks/grown/onion/rogue,
	/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry,
	/obj/item/reagent_containers/food/snacks/grown/vegetable/turnip,
	/obj/item/reagent_containers/food/snacks/grown/carrot,
	/obj/item/reagent_containers/food/snacks/grown/potato/rogue,
	/obj/item/reagent_containers/food/snacks/grown/oat,
	/obj/item/reagent_containers/food/snacks/grown/rice,
	/obj/item/reagent_containers/food/snacks/grown/apple,
	/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
	/obj/item/reagent_containers/food/snacks/grown/fruit/lemon,
	/obj/item/reagent_containers/food/snacks/grown/fruit/lime,
	/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine,

	/obj/item/reagent_containers/food/snacks/rogue/meat/steak,
	/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf,
	/obj/item/reagent_containers/food/snacks/rogue/meat/steak/rat,
	/obj/item/reagent_containers/food/snacks/rogue/meat/fish,
	/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
))

GLOBAL_LIST_INIT(alch_tier_medium, list(
	/obj/item/alch/viscera,
	/obj/item/alch/sinew,
	/obj/item/alch/horn,
	/obj/item/alch/tobaccodust,
	/obj/item/alch/puresalt,
	/obj/item/alch/swampdust,
	/obj/item/alch/stonedust,
	/obj/item/alch/bonemeal,
	/obj/item/alch/bone,
	/obj/item/alch/coaldust,
	/obj/item/alch/irondust,
	/obj/item/alch/waterdust,
	/obj/item/alch/airdust,
	/obj/item/alch/earthdust,
	/obj/item/alch/firedust,
	/obj/item/alch/runedust,


	/obj/item/reagent_containers/food/snacks/rogue/meat/chickentender,
	/obj/item/reagent_containers/powder/moondust,
	/obj/item/reagent_containers/powder/spice,
	/obj/item/alch/transisdust,
	/obj/item/reagent_containers/food/snacks/sugar,
	/obj/item/reagent_containers/food/snacks/grown/rogue/poppy,
	/obj/item/reagent_containers/food/snacks/grown/nut,
	/obj/item/reagent_containers/food/snacks/tallow,
	/obj/item/reagent_containers/food/snacks/fat,
	/obj/item/reagent_containers/food/snacks/egg,
	/obj/item/reagent_containers/food/snacks/rogue/honey,
	/obj/item/reagent_containers/food/snacks/rogue/meat/fatty,
	/obj/item/reagent_containers/food/snacks/rogue/meat/spider,
	/obj/item/reagent_containers/food/snacks/rogue/meat/crab,
	/obj/item/reagent_containers/food/snacks/rogue/meat/ham/boar,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z,
	/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit,
	/obj/item/reagent_containers/food/snacks/rogue/meat/steak/bear,
	/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll
))

GLOBAL_LIST_INIT(alch_tier_complex, list(
	/obj/item/alch/silverdust,
	/obj/item/alch/golddust,
	/obj/item/alch/solardust,
	/obj/item/alch/infernaldust,
	/obj/item/alch/mineraldust,
	/obj/item/alch/feaudust,
	/obj/item/alch/magicdust,

	/obj/item/natural/cured/essence,
	/obj/item/grown/log/tree/small/essence,
	/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged,
	/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime,
	/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z
))

GLOBAL_LIST_EMPTY(alch_round_runes)

/datum/asset/simple/alchemy_ui
	assets = list(
		"alchemy_colb.png"     = 'icons/tgui/colb.png',
		"alchemy_couldron.png" = 'icons/tgui/couldron.png',
		"alchemy_slot.png"     = 'icons/tgui/slot.png',
		"alchemy_layer.png"    = 'icons/tgui/layer.png'
	)

GLOBAL_VAR_INIT(alch_generated_red, 0)
GLOBAL_VAR_INIT(alch_generated_green, 0)
GLOBAL_VAR_INIT(alch_generated_blue, 0)

/proc/pick_balanced_rune_color(list/current_item_runes)
	var/list/candidates = list()
	var/list/all_colors = list(ALCH_RUNE_RED, ALCH_RUNE_GREEN, ALCH_RUNE_BLUE)

	for(var/col in all_colors)
		if((current_item_runes[col] || 0) < 3)
			candidates += col

	if(!candidates.len)
		return null

	var/total_red = GLOB.alch_generated_red
	var/total_green = GLOB.alch_generated_green
	var/total_blue = GLOB.alch_generated_blue
	var/max_gen = max(total_red, total_green, total_blue) + 5

	var/list/weighted_colors = list()
	for(var/col in candidates)
		var/gen_count = 0
		switch(col)
			if(ALCH_RUNE_RED) gen_count = total_red
			if(ALCH_RUNE_GREEN) gen_count = total_green
			if(ALCH_RUNE_BLUE) gen_count = total_blue

		var/weight = max_gen - gen_count
		weighted_colors[col] = weight

	return pickweight(weighted_colors)

/proc/generate_runes_for_tier(tier)
	var/target_points = 0
	switch(tier)
		if(ALCH_TIER_EASY)
			var/roll = rand(1, 100)
			if(roll <= 50) target_points = 1
			else if(roll <= 80) target_points = 2
			else target_points = 3
		if(ALCH_TIER_MEDIUM)
			if(prob(70)) target_points = 4
			else target_points = 5
		if(ALCH_TIER_COMPLEX)
			target_points = 6

	var/list/result = list(
		ALCH_RUNE_RED   = 0,
		ALCH_RUNE_GREEN = 0,
		ALCH_RUNE_BLUE  = 0
	)

	var/points_left = target_points
	while(points_left > 0)
		var/chosen_color = pick_balanced_rune_color(result)
		if(!chosen_color)
			break

		result[chosen_color] += 1
		points_left--

		switch(chosen_color)
			if(ALCH_RUNE_RED) GLOB.alch_generated_red++
			if(ALCH_RUNE_GREEN) GLOB.alch_generated_green++
			if(ALCH_RUNE_BLUE) GLOB.alch_generated_blue++

	for(var/r in result)
		if(result[r] <= 0)
			result -= r

	return result

/proc/init_alchemy_runes()
	var/list/round_runes = GLOB.alch_round_runes
	round_runes.Cut()

	GLOB.alch_generated_red = 0
	GLOB.alch_generated_green = 0
	GLOB.alch_generated_blue = 0

	var/list/easy_pool = GLOB.alch_tier_easy.Copy()
	easy_pool = shuffle(easy_pool)

	var/list/guaranteed_easy = list(
		list(ALCH_RUNE_RED = 1),
		list(ALCH_RUNE_GREEN = 1),
		list(ALCH_RUNE_BLUE = 1),
		list(ALCH_RUNE_RED = 2),
		list(ALCH_RUNE_GREEN = 2),
		list(ALCH_RUNE_BLUE = 2)
	)

	for(var/list/preset in guaranteed_easy)
		if(!easy_pool.len)
			break
		var/item_type = easy_pool[1]
		easy_pool.Cut(1, 2)
		round_runes[item_type] = preset.Copy()

		for(var/c in preset)
			switch(c)
				if(ALCH_RUNE_RED) GLOB.alch_generated_red += preset[c]
				if(ALCH_RUNE_GREEN) GLOB.alch_generated_green += preset[c]
				if(ALCH_RUNE_BLUE) GLOB.alch_generated_blue += preset[c]

	for(var/item_type in easy_pool)
		round_runes[item_type] = generate_runes_for_tier(ALCH_TIER_EASY)

	var/list/med_pool = GLOB.alch_tier_medium.Copy()
	med_pool = shuffle(med_pool)

	var/list/guaranteed_med = list(
		list(ALCH_RUNE_RED = 3, ALCH_RUNE_GREEN = 1),
		list(ALCH_RUNE_GREEN = 3, ALCH_RUNE_BLUE = 1),
		list(ALCH_RUNE_BLUE = 3, ALCH_RUNE_RED = 1)
	)

	for(var/list/preset in guaranteed_med)
		if(!med_pool.len)
			break
		var/item_type = med_pool[1]
		med_pool.Cut(1, 2)
		round_runes[item_type] = preset.Copy()

		for(var/c in preset)
			switch(c)
				if(ALCH_RUNE_RED) GLOB.alch_generated_red += preset[c]
				if(ALCH_RUNE_GREEN) GLOB.alch_generated_green += preset[c]
				if(ALCH_RUNE_BLUE) GLOB.alch_generated_blue += preset[c]

	for(var/item_type in med_pool)
		round_runes[item_type] = generate_runes_for_tier(ALCH_TIER_MEDIUM)

	var/list/complex_pool = GLOB.alch_tier_complex.Copy()
	for(var/item_type in complex_pool)
		round_runes[item_type] = generate_runes_for_tier(ALCH_TIER_COMPLEX)


/obj/item/proc/setup_alchemical_runes()
	if(runes && runes.len)
		return

	var/list/round_runes = GLOB.alch_round_runes
	if(!round_runes || !round_runes.len)
		init_alchemy_runes()
		round_runes = GLOB.alch_round_runes

	var/list/base_runes = null
	if(round_runes[type])
		base_runes = round_runes[type]
	else
		for(var/parent_type in round_runes)
			if(istype(src, parent_type))
				base_runes = round_runes[parent_type]
				break

	if(!base_runes || !base_runes.len)
		return
	
	if(prob(1.5))
		var/rainbow_tier = 1
		if(type in GLOB.alch_tier_complex)
			rainbow_tier = 3
		else if(type in GLOB.alch_tier_medium)
			rainbow_tier = 2
		else
			for(var/t in GLOB.alch_tier_complex)
				if(istype(src, t))
					rainbow_tier = 3
					break
			if(rainbow_tier == 1)
				for(var/t in GLOB.alch_tier_medium)
					if(istype(src, t))
						rainbow_tier = 2
						break

		runes = list(ALCH_RUNE_RAINBOW = rainbow_tier)
		return

	runes = base_runes.Copy()
