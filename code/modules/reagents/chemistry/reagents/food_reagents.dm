///////////////////////////////////////////////////////////////////
					//Food Reagents
//////////////////////////////////////////////////////////////////


// Part of the food code. Also is where all the food
// 	condiments, additives, and such go.


/datum/reagent/consumable
	name = "食用试剂"
	taste_description = "普通食物"
	taste_mult = 4
	metabolization_rate = REAGENTS_METABOLISM
	var/nutriment_factor = 1
	var/hydration_factor = 0
	var/quality = 0	//affects mood, typically higher for mixed drinks with more complex recipes

/datum/reagent/consumable/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.adjust_nutrition(nutriment_factor * metabolization_rate)
		H.adjust_hydration(hydration_factor * metabolization_rate)
	return ..()

/datum/reagent/consumable/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == INGEST)
		var/mob/living/carbon/human/HM = M

		if(HM.culinary_preferences)
			var/favorite_drink_type = HM.culinary_preferences[CULINARY_FAVOURITE_DRINK]
			if(favorite_drink_type == type)
				if(HM.add_stress(/datum/stressevent/favourite_drink))
					to_chat(HM, span_green("嗯！是我最喜欢的饮品！"))
			else if(ispath(type, favorite_drink_type))
				var/datum/reagent/consumable/favorite_drink_instance = favorite_drink_type
				var/favorite_drink_name = initial(favorite_drink_instance.name)
				if(favorite_drink_name == name)
					if(HM.add_stress(/datum/stressevent/favourite_drink))
						to_chat(HM, span_green("嗯！是我最喜欢的饮品！"))

			var/hated_drink_type = HM.culinary_preferences[CULINARY_HATED_DRINK]
			if(hated_drink_type == type)
				if(HM.add_stress(/datum/stressevent/hated_drink))
					to_chat(HM, span_red("呸！是我最讨厌的饮品！"))
			else if(ispath(type, hated_drink_type))
				var/datum/reagent/consumable/hated_drink_instance = hated_drink_type
				var/hated_drink_name = initial(hated_drink_instance.name)
				if(hated_drink_name == name)
					if(HM.add_stress(/datum/stressevent/hated_drink))
						to_chat(HM, span_red("呸！是我最讨厌的饮品！"))
	return ..()

/datum/reagent/consumable/nutriment
	name = "营养素"
	description = "以纯净形态存在、人体所需的各种维生素、矿物质与碳水化合物。"
	reagent_state = SOLID
	nutriment_factor = BASE_NUTRIMENT_NUTRITION //EVERY 1 NUTRIMENT RESTORES 35 NUTRITION
	color = "#664330" // rgb: 102, 67, 48

	var/brute_heal = 0
	var/burn_heal = 0

/datum/reagent/consumable/nutriment/on_mob_life(mob/living/carbon/M)
	if(prob(50))
		M.heal_bodypart_damage(brute_heal,burn_heal, 0)
		. = 1
	..()

/datum/reagent/consumable/nutriment/on_new(list/supplied_data)
	// taste data can sometimes be ("salt" = 3, "chips" = 1)
	// and we want it to be in the form ("salt" = 0.75, "chips" = 0.25)
	// which is called "normalizing"
	if(!supplied_data)
		supplied_data = data

	// if data isn't an associative list, this has some WEIRD side effects
	// TODO probably check for assoc list?

	data = counterlist_normalise(supplied_data)

/datum/reagent/consumable/nutriment/on_merge(list/newdata, newvolume)
	if(!islist(newdata) || !newdata.len)
		return

	// data for nutriment is one or more (flavour -> ratio)
	// where all the ratio values adds up to 1

	var/list/taste_amounts = list()
	if(data)
		taste_amounts = data.Copy()

	counterlist_scale(taste_amounts, volume)

	var/list/other_taste_amounts = newdata.Copy()
	counterlist_scale(other_taste_amounts, newvolume)

	counterlist_combine(taste_amounts, other_taste_amounts)

	counterlist_normalise(taste_amounts)

	data = taste_amounts

/datum/reagent/consumable/nutriment/vitamin
	name = "维生素"
	description = "以纯净形态存在、人体所需的优质维生素、矿物质与碳水化合物。"

	brute_heal = 1
	burn_heal = 1

/datum/reagent/consumable/nutriment/vitamin/on_mob_life(mob/living/carbon/M)
	if(M.satiety < 600)
		M.satiety += 30
	. = ..()

/datum/reagent/consumable/sugar
	name = "糖"
	description = "一种常见的有机化合物，也叫蔗糖；这种白色、无味的结晶粉末有着令人愉悦的甜味。"
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_mult = 1.5 // stop sugar drowning out other flavours
	nutriment_factor = BASE_SUGAR_NUTRITION
	metabolization_rate = 2 * REAGENTS_METABOLISM
	overdose_threshold = 200 // Hyperglycaemic shock
	taste_description = "甜味"

/datum/reagent/consumable/sugar/overdose_start(mob/living/M)
	to_chat(M, "<span class='danger'>我陷入高血糖休克了！别再吃那些甜食了！</span>")
	M.AdjustSleeping(600, FALSE)
	. = 1

/datum/reagent/consumable/sugar/overdose_process(mob/living/M)
	M.AdjustSleeping(40, FALSE)
	..()
	. = 1

/datum/reagent/consumable/sugar/molasses
	name = "糖蜜"
	color = "#835c5c"

/datum/reagent/consumable/sodiumchloride
	name = "食盐"
	description = "由氯化钠构成的盐，常用于给食物调味。"
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	taste_description = "咸味"

/datum/reagent/consumable/sodiumchloride/reaction_turf(turf/T, reac_volume) //Creates an umbra-blocking salt pile
	if(!istype(T))
		return
	if(reac_volume < 1)
		return
	new/obj/effect/decal/cleanable/food/salt(T)

/datum/reagent/consumable/blackpepper
	name = "黑胡椒"
	description = "由胡椒粒研磨而成的粉末。*阿嚏！*"
	reagent_state = SOLID
	// no color (ie, black)
	taste_description = "胡椒味"

/datum/reagent/drug/mushroomhallucinogen
	name = "蘑菇致幻剂"
	description = "一种从特定蘑菇中提取的强效致幻药物。"
	color = "#E700E7" // rgb: 231, 0, 231
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	taste_description = "蘑菇味"

/datum/reagent/drug/mushroomhallucinogen/on_mob_life(mob/living/carbon/M)
	if(!M.slurring)
		M.slurring = 1
	switch(current_cycle)
		if(1 to 5)
			M.Dizzy(5)
			M.set_drugginess(30)
			if(prob(10))
				M.emote(pick("twitch","giggle"))
		if(5 to 10)
			M.Jitter(10)
			M.Dizzy(10)
			M.set_drugginess(35)
			if(prob(20))
				M.emote(pick("twitch","giggle"))
		if (10 to INFINITY)
			M.Jitter(20)
			M.Dizzy(20)
			M.set_drugginess(40)
			if(prob(30))
				M.emote(pick("twitch","giggle"))
	..()

/datum/reagent/consumable/eggyolk
	name = "蛋黄"
	description = "富含蛋白质。"
	nutriment_factor = 3 * REAGENTS_METABOLISM
	color = "#FFB500"
	taste_description = "鸡蛋味"

/datum/reagent/consumable/honey
	name = "蜂蜜"
	description = "香甜的蜂蜜，会逐渐分解成糖分；具有抗菌与自然愈合特性。"
	color = "#d3a308"
	nutriment_factor = 15 * REAGENTS_METABOLISM
	metabolization_rate = 1 * REAGENTS_METABOLISM
	taste_description = "甜味"

/datum/reagent/consumable/honey/on_mob_life(mob/living/carbon/M)
	M.reagents.add_reagent(/datum/reagent/consumable/sugar,3)
	if(prob(55))
		M.adjustBruteLoss(-1*REM, 0)
		M.adjustFireLoss(-1*REM, 0)
		M.adjustOxyLoss(-1*REM, 0)
		M.adjustToxLoss(-1*REM, 0)
	..()

/datum/reagent/consumable/oil/tallow
	name = "板油"
	description = "由动物脂肪炼制而成的油脂，常用于油炸。"
	nutriment_factor = 20
	color = "#A6987B" // rgb: 48, 32, 0
	taste_description = "炼脂味"
