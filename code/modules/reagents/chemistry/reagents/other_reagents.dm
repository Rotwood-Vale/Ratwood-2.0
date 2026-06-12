/datum/reagent/blood
	data = list("donor"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null,"cloneable"=null,"factions"=null,"quirks"=null)
	name = "血液"
	color = "#C80000" // rgb: 200, 0, 0
	metabolization_rate = 5 //fast rate so it disappears fast.
	taste_description = "铁腥味"
	taste_mult = 1.3
	glass_icon_state = "glass_red"
	glass_name = "一杯番茄汁"
	glass_desc = ""
	shot_glass_icon_state = "shotglassred"
/datum/reagent/blood/shitty
	name = "污血"
	color = "#941010" // rgb: 148, 16, 16
	taste_description = "腐败的铁腥味"
	taste_mult = 1.5
	glass_name = "一杯脏番茄汁"

/datum/reagent/blood/reaction_mob(mob/living/L, method=TOUCH, reac_volume)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		if(C.get_blood_id() == /datum/reagent/blood && (method == INJECT || (method == INGEST && C.dna && C.dna.species && (DRINKSBLOOD in C.dna.species.species_traits || HAS_TRAIT(C, TRAIT_HEMOPHAGE)))))
			if(!data || !(data["blood_type"] in get_safe_blood(C.dna.blood_type)) || !HAS_TRAIT(C,TRAIT_NASTY_EATER))
				C.reagents.add_reagent(/datum/reagent/toxin, reac_volume * 0.5)
			else
				C.blood_volume = min(C.blood_volume + round(reac_volume, 0.1), BLOOD_VOLUME_MAXIMUM)
//Dirty blood shouldn't go in your veins!
/datum/reagent/blood/shitty/reaction_mob(mob/living/L, method=TOUCH, reac_volume)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		if(C.get_blood_id() == /datum/reagent/blood && (method == INJECT || (method == INGEST && C.dna && C.dna.species && (DRINKSBLOOD in C.dna.species.species_traits || HAS_TRAIT(C, TRAIT_HEMOPHAGE)))))
			if(!data || !(data["blood_type"] in get_safe_blood(C.dna.blood_type)) || !(HAS_TRAIT(C, TRAIT_NASTY_EATER) && HAS_TRAIT(C, TRAIT_WILD_EATER)))
				C.reagents.add_reagent(/datum/reagent/toxin, reac_volume * 0.8)
			else
				C.blood_volume = min(C.blood_volume + round(reac_volume, 0.1), BLOOD_VOLUME_MAXIMUM)

/datum/reagent/blood/on_merge(list/mix_data)
	if(data && mix_data)
		if(data["blood_DNA"] != mix_data["blood_DNA"])
			data["cloneable"] = 0 //On mix, consider the genetic sampling unviable for pod cloning if the DNA sample doesn't match.
	return 1

/datum/reagent/blood/reaction_turf(turf/T, reac_volume)//splash the blood all over the place
	if(!istype(T))
		return
	if(reac_volume < 3)
		return

	var/obj/effect/decal/cleanable/blood/B = locate() in T //find some blood here
	if(!B)
		B = new(T)
	if(data["blood_DNA"])
		B.add_blood_DNA(list(data["blood_DNA"] = data["blood_type"]))

/datum/reagent/blood/reaction_mob(mob/living/L, method=TOUCH, reac_volume)
	if(method == INGEST) // Make sure you DRANK the blood before giving damage
		..()

/datum/reagent/blood/on_mob_life(mob/living/carbon/H)//I hate you
	..()
	if(HAS_TRAIT(H, TRAIT_HEMOPHAGE))
		H.adjust_nutrition(10)
		H.adjust_hydration(10)
		if(H.blood_volume < BLOOD_VOLUME_NORMAL)
			H.blood_volume = min(H.blood_volume+4, BLOOD_VOLUME_NORMAL)//Less effective than just water.
		return
	if(HAS_TRAIT(H, TRAIT_NASTY_EATER))
		return
	H.add_nausea(12) //Over 8 units will cause puking

/datum/reagent/blood/shitty/reaction_mob(mob/living/L, method=TOUCH, reac_volume)
	if (method == INGEST)
		..()
/datum/reagent/blood/shitty/on_mob_life(mob/living/carbon/H)
	..()
	if(HAS_TRAIT(H, TRAIT_HEMOPHAGE))
		H.adjust_nutrition(3)
		H.adjust_hydration(3)
		if(H.blood_volume < BLOOD_VOLUME_NORMAL)
			H.blood_volume = min(H.blood_volume+2, BLOOD_VOLUME_NORMAL)//Much less effective than just water.
		if(prob(5))
			to_chat(H, span_red("这远远不够……我必须找到更好的命血来源……"))
		return
	if(HAS_TRAIT(H, TRAIT_NASTY_EATER) && HAS_TRAIT(H, TRAIT_WILD_EATER))
		return
	H.add_nausea(18) //Do not drink dirty blood!

/datum/reagent/blood/green
	color = "#05af01"

/datum/reagent/liquidgibs // Editor's note: what the fuck
	name = "碎肉浆"
	color = "#CC4633"
	description = "你绝对不会想知道这里面装的是什么。"
	taste_description = "恶心的铁腥味"
	shot_glass_icon_state = "shotglassred"

/datum/reagent/water
	name = "水"
	description = "一种由氢和氧组成的无处不在的化学物质。"
	color = "#6a9295"
	taste_description = "水"
	var/cooling_temperature = 2
	glass_icon_state = "glass_clear"
	glass_name = "一杯水"
	glass_desc = ""
	shot_glass_icon_state = "shotglassclear"
	var/hydration = 12
	alpha = 100
	taste_mult = 0.1

/datum/chemical_reaction/grosswaterify
	name = "脏水"
	id = /datum/reagent/water/gross
	results = list(/datum/reagent/water/gross = 2)
	required_reagents = list(/datum/reagent/water/gross = 1, /datum/reagent/water = 1)

/datum/reagent/water/reaction_mob(mob/living/M, method = TOUCH, reac_volume)
	if(!isliving(M))
		return ..()

	if(method in list(TOUCH, VAPOR, PATCH))
		var/mob/living/L = M

		// 120u of water cools 100 temperature- or one level of temperature (A bucket/stonepot)
		var/cooling = reac_volume * (100 / 120)

		L.bodytemperature = max(L.bodytemperature - cooling, BODYTEMP_COLD_LEVEL_ONE_MAX)	//Will never put someone at level 2 cold

	return ..()

#define WATER_BLOOD_RESTORE 5
/datum/reagent/water/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(HAS_TRAIT(H, TRAIT_HEMOPHAGE))
			M.add_nausea(2)
		else
			H.adjust_hydration(hydration)
			if(M.blood_volume < BLOOD_VOLUME_NORMAL)
				M.blood_volume = min(M.blood_volume+WATER_BLOOD_RESTORE, BLOOD_VOLUME_NORMAL)
		if(M.bodytemperature > BODYTEMP_NORMAL_MIN + 5)	//drinking water lowers a persons temperature up to the 'normal' minimum
			M.adjust_bodytemperature(-5)
	..()
#undef WATER_BLOOD_RESTORE

/datum/reagent/water/gross
	taste_description = "某种令人作呕的东西"
	color = "#98934bc6"
	harmful = TRUE
/datum/reagent/water/gross/sewage
	taste_description = "令人反胃的硫磺和腐烂粪臭"

/datum/reagent/water/gross/reaction_mob(mob/living/L, method=TOUCH, reac_volume)
	if(method == INGEST) // Make sure you DRANK the toxic water before giving damage
		..()

/datum/reagent/water/gross/on_mob_life(mob/living/carbon/M)
	..()
	if(HAS_TRAIT(M, TRAIT_NASTY_EATER) || HAS_TRAIT(M, TRAIT_WILD_EATER)) // lets orcs, goblins and dendorites drink bogwater
		return
	M.adjustToxLoss(1)
	M.add_nausea(12) //Over 8 units will cause puking
/datum/reagent/water/gross/sewage/reaction_mob(mob/living/L, method=TOUCH, reac_volume)
	if (method == INGEST)
		..()
/datum/reagent/water/gross/sewage/on_mob_life(mob/living/carbon/M)
	..()
	//I am not putting in a NASTY_EATER check for this. He's the god of bloodshed, not the god of coprophagia.
	M.adjustToxLoss(4) //Horrible day for poop drinkers
	M.add_nausea(20)
/datum/chemical_reaction/grosswaterboil //boiling water purifies it
	name = "脏水净化"
	id = /datum/reagent/water
	results = list(/datum/reagent/water = 1)
	required_reagents = list(/datum/reagent/water/gross = 1)
	required_temp = 375

/datum/reagent/water/bathwater
	taste_description = "洗澡水"
	color = "#c9e5eec6"

/datum/reagent/water/salty
	taste_description = "盐味"
	color = "#417ac5c6"

/datum/reagent/water/salty/reaction_mob(mob/living/L, method=TOUCH, reac_volume)
	if(method == INGEST) // Make sure you DRANK the salty water before losing hydration
		..()

/datum/reagent/water/salty/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!(HAS_TRAIT(H, TRAIT_NOHUNGER) || HAS_TRAIT(H, TRAIT_SEA_DRINKER))) // Small edit for readability. De Morgans Law my beloved
			H.adjust_hydration(-hydration)  //saltwater dehydrates more than it hydrates
			M.adjustToxLoss(0.25) // Slightly toxic
			M.add_nausea(2)
		else if(HAS_TRAIT(H, TRAIT_SEA_DRINKER))
			H.adjust_hydration(hydration)
	..()

/datum/chemical_reaction/saltwaterify
	name = "盐水"
	id = /datum/reagent/water/salty
	results = list(/datum/reagent/water/salty = 2)
	required_reagents = list(/datum/reagent/water/salty = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/saltwaterboil //boiling water purifies it
	name = "盐水净化"
	id = /datum/reagent/water
	results = list(/datum/reagent/water = 1)
	required_reagents = list(/datum/reagent/water/salty = 1)
	required_temp = 375

/datum/chemical_reaction/saltwaterboil/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/reagent_containers/powder/salt(location)
	new /obj/item/reagent_containers/powder/salt(location)
	new /obj/item/reagent_containers/powder/salt(location)

/*
 *	Water reaction to turf
 */

/turf/open
	var/water_level = 0
	var/last_water_update
	var/max_water = 500

/turf/open/proc/add_water(amt)
	if(!amt)
		return
	var/shouldupdate = FALSE
	if(water_level <= 0)
		if(amt > 0)
			shouldupdate = TRUE
	var/newwater = water_level + amt
	if(newwater >= max_water)
		water_level = max_water
	else
		water_level = newwater
	water_level = round(water_level)
	if(water_level > 0)
		START_PROCESSING(SSwaterlevel, src)
	if(shouldupdate)
		update_water()

	if(amt > 101)
		for(var/obj/effect/decal/cleanable/blood/target in src)
			qdel(target)

	return TRUE

/turf/open/proc/update_water()
	return TRUE

/datum/reagent/water/reaction_turf(turf/T, reac_volume)
	if(isopenturf(T))
		var/turf/open/OT = T
		if(reac_volume >= 5)
			OT.add_water(reac_volume * 3) //nuprocet)

		var/obj/effect/hotspot/hotspot = (locate(/obj/effect/hotspot) in T)
		if(hotspot)
			new /obj/effect/temp_visual/small_smoke(T)
			qdel(hotspot)

	if(iswallturf(T))
		if(!T.color)
			return
		if(volume < 10)
			T.visible_message(span_warning("[T]还需要更多水才能洗掉那层<font color=[T.color]>颜料</font>！"))
			return
		T.visible_message(span_notice("[T]上的<font color=[T.color]>颜料</font>被洗掉了！"))
		T.color = initial(T.color)

/*
 *	Water reaction to an object
 */

/datum/reagent/water/reaction_obj(obj/O, reac_volume)
	O.extinguish()
	O.acid_level = 0

	if(isstructure(O))
		if(!O.color)
			return
		if(volume < 10)
			O.visible_message(span_warning("[O]还需要更多水才能洗掉那层<font color=[O.color]>颜料</font>！"))
			return
		O.visible_message(span_notice("[O]上的<font color=[O.color]>颜料</font>被洗掉了！"))
		O.color = initial(O.color)

	if(istype(O, /obj/item/roguebin))
		var/obj/item/roguebin/RB = O
		if(!RB.kover)
			if(RB.reagents)
				RB.reagents.add_reagent(src.type, reac_volume)

	else if(istype(O, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RB = O
		if(RB.reagents)
			RB.reagents.add_reagent(src.type, reac_volume)


/*
 *	Water reaction to a mob
 */

/datum/reagent/water/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with water can help put them out!
	if(!istype(M))
		return
	if(method == TOUCH)
		M.adjust_fire_stacks(-(reac_volume / 10))
		M.SoakMob(FULL_BODY)
//		for(var/obj/effect/decal/cleanable/blood/target in M)
//			qdel(target)
	..()

/datum/reagent/water/holywater
	name = "圣水"
	description = "被某位神祇赐福过的水。"
	color = "#E0E8EF" // rgb: 224, 232, 239
	glass_icon_state  = "glass_clear"
	glass_name = "一杯圣水"
	glass_desc = ""
	self_consuming = TRUE //divine intervention won't be limited by the lack of a liver

/datum/reagent/water/holywater/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_HOLY, type)

/datum/reagent/water/holywater/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_HOLY, type)
	..()


/datum/reagent/water/holywater/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.adjust_hydration(hydration)
	var/old_count = LAZYACCESS(data, "misc")
	LAZYSET(data, "misc", old_count + 1)
	M.jitteriness = min(M.jitteriness+4,10)
	if(data >= 25)		// 10 units, 45 seconds @ metabolism 0.4 units & tick rate 1.8 sec
		if(!M.stuttering)
			M.stuttering = 1
		M.stuttering = min(M.stuttering+4, 10)
		M.Dizzy(5)
	if(data >= 60)	// 30 units, 135 seconds
		M.jitteriness = 0
		M.stuttering = 0
		holder.remove_reagent(type, volume)	// maybe this is a little too perfect and a max() cap on the statuses would be better??
		return
	holder.remove_reagent(type, 0.4)	//fixed consumption to prevent balancing going out of whack

/datum/reagent/water/holywater/reaction_turf(turf/T, reac_volume)
	..()
	if(!istype(T))
		return
	T.Bless()

/datum/reagent/hydrogen_peroxide
	name = "过氧化氢"
	description = "一种无处不在的化学物质，由氢和氧以及氧组成。" //intended intended
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha)
	taste_description = "灼烧般的水味"
	var/cooling_temperature = 2
	glass_icon_state = "glass_clear"
	glass_name = "一杯过氧化水"
	glass_desc = ""
	shot_glass_icon_state = "shotglassclear"

/*
 *	Water reaction to turf
 */

/datum/reagent/hydrogen_peroxide/reaction_turf(turf/open/T, reac_volume)
	if(!istype(T))
		return
	if(reac_volume >= 5)
		T.MakeSlippery(TURF_WET_WATER, 10 SECONDS, min(reac_volume*1.5 SECONDS, 60 SECONDS))
/*
 *	Water reaction to a mob
 */

/datum/reagent/hydrogen_peroxide/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with h2o2 can burn them !
	if(!istype(M))
		return
	if(method == TOUCH)
		M.adjustFireLoss(2, 0) // burns
	..()

/datum/reagent/fuel/unholywater		//if you somehow managed to extract this from someone, dont splash it on myself and have a smoke
	name = "亵渎之水"
	description = "某种根本不该存在于这个位面的东西。"
	taste_description = "苦难"

/datum/reagent/fuel/unholywater/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == TOUCH || method == VAPOR)
		M.reagents.add_reagent(type,reac_volume/4)
		return
	return ..()

/datum/reagent/fuel/unholywater/on_mob_life(mob/living/carbon/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3, 150)
	M.adjustToxLoss(2, 0)
	M.adjustFireLoss(2, 0)
	M.adjustOxyLoss(2, 0)
	M.adjustBruteLoss(2, 0)
	holder.remove_reagent(type, 1)
	return TRUE

/datum/reagent/hellwater			//if someone has this in their system they've really pissed off an eldrich god
	name = "地狱之水"
	description = "你的血肉！在燃烧！"
	taste_description = "灼烧"

/datum/reagent/hellwater/on_mob_life(mob/living/carbon/M)
	M.adjust_fire_stacks(5)
	M.ignite_mob()			//Only problem with igniting people is currently the commonly availible fire suits make you immune to being on fire
	M.adjustToxLoss(1, 0)
	M.adjustFireLoss(1, 0)		//Hence the other damages... ain't I a bastard?
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5, 150)
	holder.remove_reagent(type, 1)

/datum/reagent/medicine/omnizine/godblood
	name = "神血"
	description = "会缓慢治疗所有类型的伤害，过量阈值较高，并闪耀着神秘力量。"
	overdose_threshold = 150

///Used for clownery
/datum/reagent/lube
	name = "太空润滑剂"
	description = "润滑剂是一种施加在两个运动表面之间、用以降低摩擦与磨损的物质。嘿嘿。"
	color = "#009CA8" // rgb: 0, 156, 168
	taste_description = "樱桃味" // by popular demand
	var/lube_kind = TURF_WET_LUBE ///What kind of slipperiness gets added to turfs.

/datum/reagent/lube/reaction_turf(turf/open/T, reac_volume)
	if (!istype(T))
		return
	if(reac_volume >= 1)
		T.MakeSlippery(lube_kind, 15 SECONDS, min(reac_volume * 2 SECONDS, 120))

///Stronger kind of lube. Applies TURF_WET_SUPERLUBE.
/datum/reagent/lube/superlube
	name = "超级无敌润滑剂"
	description = "这玩意因\[已编辑\]事件后已被全面取缔。"
	lube_kind = TURF_WET_SUPERLUBE

/datum/reagent/spraytan
	name = "喷雾美黑剂"
	description = "一种喷涂在皮肤上、用于加深肤色的物质。"
	color = "#FFC080" // rgb: 255, 196, 128  Bright orange
	metabolization_rate = 10 * REAGENTS_METABOLISM // very fast, so it can be applied rapidly.  But this changes on an overdose
	overdose_threshold = 11 //Slightly more than one un-nozzled spraybottle.
	taste_description = "酸橙味"

/datum/reagent/spraytan/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1)
	if(ishuman(M))
		if(method == PATCH || method == VAPOR)
			var/mob/living/carbon/human/N = M
			if(N.dna.species.id == "human")
				switch(N.skin_tone)
					if("african1")
						N.skin_tone = "african2"
					if("indian")
						N.skin_tone = "african1"
					if("arab")
						N.skin_tone = "indian"
					if("asian2")
						N.skin_tone = "arab"
					if("asian1")
						N.skin_tone = "asian2"
					if("mediterranean")
						N.skin_tone = "african1"
					if("latino")
						N.skin_tone = "mediterranean"
					if("caucasian3")
						N.skin_tone = "mediterranean"
					if("caucasian2")
						N.skin_tone = pick("caucasian3", "latino")
					if("caucasian1")
						N.skin_tone = "caucasian2"
					if ("albino")
						N.skin_tone = "caucasian1"

			if(MUTCOLORS in N.dna.species.species_traits) //take current alien color and darken it slightly
				var/newcolor = ""
				var/len = length(N.dna.features["mcolor"])
				for(var/i=1, i<=len, i+=1)
					var/ascii = text2ascii(N.dna.features["mcolor"],i)
					switch(ascii)
						if(48)
							newcolor += "0"
						if(49 to 57)
							newcolor += ascii2text(ascii-1)	//numbers 1 to 9
						if(97)
							newcolor += "9"
						if(98 to 102)
							newcolor += ascii2text(ascii-1)	//letters b to f lowercase
						if(65)
							newcolor +="9"
						if(66 to 70)
							newcolor += ascii2text(ascii+31)	//letters B to F - translates to lowercase
						else
							break
				if(ReadHSV(newcolor)[3] >= ReadHSV("#7F7F7F")[3])
					N.dna.features["mcolor"] = newcolor
			N.regenerate_icons()



		if(method == INGEST)
			if(show_message)
				to_chat(M, "<span class='notice'>这味道糟透了。</span>")
	..()


/datum/reagent/spraytan/overdose_process(mob/living/M)
	metabolization_rate = 1 * REAGENTS_METABOLISM

	if(ishuman(M))
		var/mob/living/carbon/human/N = M
		N.hairstyle = "Spiky"
		N.facial_hairstyle = "Shaved"
		N.facial_hair_color = "000"
		N.hair_color = "000"
		if(!(HAIR in N.dna.species.species_traits)) //No hair? No problem!
			N.dna.species.species_traits += HAIR
		if(N.dna.species.use_skintones)
			N.skin_tone = "orange"
		else if(MUTCOLORS in N.dna.species.species_traits) //Aliens with custom colors simply get turned orange
			N.dna.features["mcolor"] = "f80"
		N.regenerate_icons()
		if(prob(7))
			if(N.wear_pants)
				M.visible_message(pick("<b>[M]</b>的衣领毫无预兆地竖了起来。", "<b>[M]</b>炫耀似地绷紧了[M.p_their()]手臂。"))
			else
				M.visible_message("<b>[M]</b>炫耀似地绷紧了[M.p_their()]手臂。")
	if(prob(10))
		M.say(pick("这玩意也太顶了。", "你就是世上一切糟糕事物的集合。", "除了'拿脑袋撞砖墙'之外你还玩什么运动？", "别见外，尽管朝我最狠的一击来吧。", "我叫约翰，而且我恨你们每一个人。"), forced = /datum/reagent/spraytan)
	..()
	return

#define MUT_MSG_IMMEDIATE 1
#define MUT_MSG_EXTENDED 2
#define MUT_MSG_ABOUT2TURN 3

/datum/reagent/mutationtoxin
	name = "稳定突变毒素"
	description = "一种会让目标人类化的毒素。"
	color = "#5EFF3B" //RGB: 94, 255, 59
	metabolization_rate = 0.2 //metabolizes to prevent micro-dosage
	taste_description = "史莱姆味"
	var/race = /datum/species/human
	var/list/mutationtexts = list( "你感觉不太舒服。" = MUT_MSG_IMMEDIATE,
									"你的皮肤感觉有些不对劲。" = MUT_MSG_IMMEDIATE,
									"你的四肢开始变成另一种形状。" = MUT_MSG_EXTENDED,
									"你的肢体末端开始扭曲变形。" = MUT_MSG_EXTENDED,
									"你感觉自己随时都会发生变化！" = MUT_MSG_ABOUT2TURN)
	var/cycles_to_turn = 20 //the current_cycle threshold / iterations needed before one can transform

/datum/reagent/mutationtoxin/on_mob_life(mob/living/carbon/human/H)
	. = TRUE
	if(!istype(H))
		return
	if(!(H.dna?.species) || !(H.mob_biotypes & MOB_ORGANIC))
		return

	if(prob(10))
		var/list/pick_ur_fav = list()
		var/filter = NONE
		if(current_cycle <= (cycles_to_turn*0.3))
			filter = MUT_MSG_IMMEDIATE
		else if(current_cycle <= (cycles_to_turn*0.8))
			filter = MUT_MSG_EXTENDED
		else
			filter = MUT_MSG_ABOUT2TURN

		for(var/i in mutationtexts)
			if(mutationtexts[i] == filter)
				pick_ur_fav += i
		to_chat(H, "<span class='warning'>[pick(pick_ur_fav)]</span>")

	if(current_cycle >= cycles_to_turn)
		var/datum/species/species_type = race
		H.set_species(species_type)
		H.reagents.del_reagent(type)
		to_chat(H, "<span class='warning'>你变成[LOWER_TEXT(initial(species_type.name))]了！</span>")
	..()

#undef MUT_MSG_IMMEDIATE
#undef MUT_MSG_EXTENDED
#undef MUT_MSG_ABOUT2TURN

/datum/reagent/mulligan
	name = "穆利根毒素"
	description = "这种毒素会迅速改变人类的基因，常被急需更换身份的辛迪加间谍与刺客使用。"
	color = "#5EFF3B" //RGB: 94, 255, 59
	metabolization_rate = INFINITY
	taste_description = "史莱姆味"

/datum/reagent/mulligan/on_mob_life(mob/living/carbon/human/H)
	..()
	if (!istype(H))
		return
	to_chat(H, "<span class='warning'><b>我咬紧牙关忍痛，身体正在迅速突变！</b></span>")
	H.visible_message("<b>[H]</b>突然变形了！")
	randomize_human(H)

/datum/reagent/serotrotium
	name = "血清素素"
	description = "一种能促进人体集中分泌血清素神经递质的化合物。"
	color = "#202040" // rgb: 20, 20, 40
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	taste_description = "苦味"

/datum/reagent/serotrotium/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		if(prob(7))
			M.emote(pick("twitch","drool","moan","gasp"))
	..()

/datum/reagent/oxygen
	name = "氧"
	description = "一种无色无味的气体。虽说长在树上，但依然相当珍贵。"
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_mult = 0 // oderless and tasteless

/datum/reagent/copper
	name = "铜"
	description = "一种延展性极高的金属。铜制品不算太耐用，但很适合用来做电线。"
	reagent_state = SOLID
	color = "#6E3B08" // rgb: 110, 59, 8
	taste_description = "金属味"

/datum/reagent/nitrogen
	name = "氮"
	description = "一种无色、无味、无臭的气体。它是一种简单窒息剂，能悄无声息地取代关键的氧气。"
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_mult = 0

/datum/reagent/hydrogen
	name = "氢"
	description = "一种无色、无味、无臭、非金属、极易燃的双原子气体。"
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_mult = 0

/datum/reagent/potassium
	name = "钾"
	description = "一种柔软、低熔点的固体，能轻易被刀切开，与水会发生剧烈反应。"
	reagent_state = SOLID
	color = "#A0A0A0" // rgb: 160, 160, 160
	taste_description = "甜味"

/datum/reagent/mercury
	name = "汞"
	description = "一种在室温下呈液态的奇特金属，会造成神经退行性损伤，对大脑极其有害。"
	color = "#484848" // rgb: 72, 72, 72A
	taste_mult = 0 // apparently tasteless.

/datum/reagent/mercury/on_mob_life(mob/living/carbon/M)
	if((M.mobility_flags & MOBILITY_MOVE))
		step(M, pick(GLOB.cardinals))
	if(prob(5))
		M.emote(pick("twitch","drool","moan"))
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1)
	..()

/datum/reagent/sulfur
	name = "硫"
	description = "一种病态发黄的固体，以臭味闻名，但在生化学中其实比看上去有用得多。"
	reagent_state = SOLID
	color = "#BF8C00" // rgb: 191, 140, 0
	taste_description = "臭鸡蛋味"

/datum/reagent/carbon
	name = "碳"
	description = "一种易碎的黑色固体，虽然物理性质不算惊艳，却构成了已知一切生命的基础。很了不起。"
	reagent_state = SOLID
	color = "#1C1300" // rgb: 30, 20, 0
	taste_description = "发酸的粉笔味"

/datum/reagent/carbon/reaction_turf(turf/T, reac_volume)
	var/obj/effect/decal/cleanable/dirt/D = locate() in T.contents
	if(!D)
		new /obj/effect/decal/cleanable/dirt(T)

/datum/reagent/chlorine
	name = "氯"
	description = "一种淡黄色气体，以强氧化性闻名。尽管它能构成许多无害分子，但单质本身绝不安全。"
	reagent_state = GAS
	color = "#FFFB89" //pale yellow? let's make it light gray
	taste_description = "氯味"

/datum/reagent/chlorine/on_mob_life(mob/living/carbon/M)
	M.take_bodypart_damage(1*REM, 0, 0, 0)
	. = 1
	..()

/datum/reagent/fluorine
	name = "氟"
	description = "一种活泼得离谱的化学元素，仿佛整个宇宙都不想让它以这种形态存在。"
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "酸味"

/datum/reagent/fluorine/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(1*REM, 0)
	. = 1
	..()

/datum/reagent/sodium
	name = "钠"
	description = "一种柔软的银色金属，能轻易被刀切开。它现在还不是盐，所以别往薯片上撒。"
	reagent_state = SOLID
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "带咸味的金属"

/datum/reagent/phosphorus
	name = "磷"
	description = "一种偏红的粉末，极易燃烧。虽然有很多不同形态，但核心特性总是差不多。"
	reagent_state = SOLID
	color = "#832828" // rgb: 131, 40, 40
	taste_description = "醋味"

/datum/reagent/lithium
	name = "锂"
	description = "一种银色金属，以极低密度闻名；拿它来让人冷静往往会过于有效。"
	reagent_state = SOLID
	color = "#808080" // rgb: 128, 128, 128
	taste_description = "金属味"

/datum/reagent/lithium/on_mob_life(mob/living/carbon/M)
	if((M.mobility_flags & MOBILITY_MOVE))
		step(M, pick(GLOB.cardinals))
	if(prob(5))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/glycerol
	name = "甘油"
	description = "甘油是一种简单的多元醇化合物，味甜且毒性很低。"
	color = "#D3B913"
	taste_description = "甜味"

/datum/reagent/space_cleaner/sterilizine
	name = "灭菌剂"
	description = "为手术做准备时用于给伤口消毒。"
	color = "#D0EFEE" // space cleaner but lighter
	taste_description = "苦味"

/datum/reagent/iron
	name = "铁"
	description = "纯铁是一种金属。"
	reagent_state = SOLID
	taste_description = "铁味"

	color = "#606060" //pure iron? let's make it violet of course

/datum/reagent/iron/on_mob_life(mob/living/carbon/C)
	if(C.blood_volume < BLOOD_VOLUME_NORMAL)
		C.blood_volume += 0.5
	..()

/datum/reagent/gold
	name = "金"
	description = "金是一种致密、柔软而闪亮的金属，也是已知延展性最强的金属。"
	reagent_state = SOLID
	color = "#F7C430" // rgb: 247, 196, 48
	taste_description = "昂贵的金属味"

/datum/reagent/silver
	name = "银"
	description = "一种柔软、银白且有光泽的过渡金属，拥有所有元素中最高的导电性，以及所有金属中最高的导热性。"
	reagent_state = SOLID
	color = "#D0D0D0" // rgb: 208, 208, 208
	taste_description = "昂贵但还算讲理的金属味"

/datum/reagent/uranium
	name ="铀"
	description = "一种锕系中的玉绿色金属化学元素，带有弱放射性。"
	reagent_state = SOLID
	color = "#5E9964" //this used to be silver, but liquid uranium can still be green and it's more easily noticeable as uranium like this so why bother?
	taste_description = "像金属。"

/datum/reagent/uranium/reaction_turf(turf/T, reac_volume)
	if(reac_volume >= 3)
		var/obj/effect/decal/cleanable/greenglow/GG = locate() in T.contents
		if(!GG)
			GG = new/obj/effect/decal/cleanable/greenglow(T)
		GG.reagents.add_reagent(type, reac_volume)

/datum/reagent/uranium/radium
	name = "镭"
	description = "镭是一种碱土金属，具有极强放射性。"
	reagent_state = SOLID
	color = "#00CC00" // ditto
	taste_description = "蓝色与后悔"

/datum/reagent/bluespace
	name = "蓝空尘"
	description = "由微观蓝空晶体组成的粉尘，具有轻微的空间扭曲特性。"
	reagent_state = SOLID
	color = "#0000CC"
	taste_description = "噼啪作响的蓝色"

/datum/reagent/bluespace/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == TOUCH || method == VAPOR)
		do_teleport(M, get_turf(M), (reac_volume / 5), asoundin = 'sound/blank.ogg', channel = TELEPORT_CHANNEL_BLUESPACE) //4 tiles per crystal
	..()

/datum/reagent/bluespace/on_mob_life(mob/living/carbon/M)
	if(current_cycle > 10 && prob(15))
		to_chat(M, "<span class='warning'>我感觉很不稳定……</span>")
		M.Jitter(2)
		current_cycle = 1
		addtimer(CALLBACK(M, TYPE_PROC_REF(/mob/living, bluespace_shuffle)), 30)
	..()

/mob/living/proc/bluespace_shuffle()
	do_teleport(src, get_turf(src), 5, asoundin = 'sound/blank.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)

/datum/reagent/aluminium
	name = "铝"
	description = "一种银白色、可延展的硼族金属元素。"
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	taste_description = "金属味"

/datum/reagent/silicon
	name = "硅"
	description = "一种四价类金属元素，化学活性低于它的同族类比物碳。"
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	taste_mult = 0

/datum/reagent/fuel
	name = "焊接燃料"
	description = "焊机所需燃料。可燃。"
	color = "#660000" // rgb: 102, 0, 0
	taste_description = "恶心的金属味"
	glass_icon_state = "dr_gibb_glass"
	glass_name = "一杯焊接燃料"
	glass_desc = ""

/datum/reagent/fuel/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with welding fuel to make them easy to ignite!
	if(method == TOUCH || method == VAPOR)
		M.adjust_fire_stacks(reac_volume / 10)
		return
	..()

/datum/reagent/fuel/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(1, 0)
	..()
	return TRUE

/datum/reagent/space_cleaner
	name = "太空清洁剂"
	description = "一种用来清洁物品的化合物。现在次氯酸钠含量提升 50%！"
	color = "#A5F0EE" // rgb: 165, 240, 238
	taste_description = "酸味"
	reagent_weight = 0.6 //so it sprays further

/datum/reagent/space_cleaner/reaction_obj(obj/O, reac_volume)
	if(istype(O, /obj/effect/decal/cleanable))
		qdel(O)
	else
		if(O)
			O.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			SEND_SIGNAL(O, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)

/datum/reagent/space_cleaner/reaction_turf(turf/T, reac_volume)
	if(reac_volume >= 1)
		T.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
		SEND_SIGNAL(T, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
		for(var/obj/effect/decal/cleanable/C in T)
			qdel(C)

/datum/reagent/space_cleaner/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == TOUCH || method == VAPOR)
		M.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.lip_style)
					H.lip_style = null
					H.update_body()
			for(var/obj/item/I in C.held_items)
				SEND_SIGNAL(I, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
			if(C.wear_mask)
				if(SEND_SIGNAL(C.wear_mask, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD))
					C.update_inv_wear_mask()
			if(ishuman(M))
				var/mob/living/carbon/human/H = C
				if(H.head)
					if(SEND_SIGNAL(H.head, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD))
						H.update_inv_head()
				if(H.wear_armor)
					if(SEND_SIGNAL(H.wear_armor, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD))
						H.update_inv_armor()
				else if(H.wear_pants)
					if(SEND_SIGNAL(H.wear_pants, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD))
						H.update_inv_w_uniform()
				if(H.shoes)
					if(SEND_SIGNAL(H.shoes, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD))
						H.update_inv_shoes()
			SEND_SIGNAL(M, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)

/datum/reagent/space_cleaner/ez_clean
	name = "E-Z 清洁剂"
	description = "由华夫公司出售的强效酸性清洁剂。会影响有机物，而对其他物体影响较小。"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "酸味"

/datum/reagent/space_cleaner/ez_clean/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(3.33)
	M.adjustFireLoss(3.33)
	M.adjustToxLoss(3.33)
	..()

/datum/reagent/space_cleaner/ez_clean/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	..()
	if((method == TOUCH || method == VAPOR))
		M.adjustBruteLoss(1.5)
		M.adjustFireLoss(1.5)

/datum/reagent/cryptobiolin
	name = "隐生灵素"
	description = "隐生灵素会引起混乱和眩晕。"
	color = "#ADB5DB" //i hate default violets and 'crypto' keeps making me think of cryo so it's light blue now
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "酸味"

/datum/reagent/cryptobiolin/on_mob_life(mob/living/carbon/M)
	M.Dizzy(1)
	if(!M.confused)
		M.confused = 1
	M.confused = max(M.confused, 20)
	..()

/datum/reagent/impedrezene
	name = "因佩德瑞辛"
	description = "因佩德瑞辛是一种麻醉剂，会通过减缓高级脑细胞功能来削弱人的能力。"
	color = "#E07DDD" // pink = happy = dumb
	taste_description = "麻木感"

/datum/reagent/impedrezene/on_mob_life(mob/living/carbon/M)
	M.jitteriness = max(M.jitteriness-5,0)
	if(prob(80))
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2*REM)
	if(prob(50))
		M.drowsyness = max(M.drowsyness, 3)
	if(prob(10))
		M.emote("drool")
	..()

/datum/reagent/fluorosurfactant//foam precursor
	name = "氟表面活性剂"
	description = "一种全氟化磺酸，与水混合时会产生泡沫。"
	color = "#9E6B38" // rgb: 158, 107, 56
	taste_description = "金属味"

/datum/reagent/foaming_agent// Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "发泡剂"
	description = "与轻金属和强酸混合时会生成金属泡沫的试剂。"
	reagent_state = SOLID
	color = "#664B63" // rgb: 102, 75, 99
	taste_description = "金属味"

/datum/reagent/smart_foaming_agent //Smart foaming agent. Functions similarly to metal foam, but conforms to walls.
	name = "智能发泡剂"
	description = "与轻金属和强酸混合时会生成贴合区域边界的金属泡沫。"
	reagent_state = SOLID
	color = "#664B63" // rgb: 102, 75, 99
	taste_description = "金属味"

/datum/reagent/ammonia
	name = "氨"
	description = "一种腐蚀性物质，常用于肥料或家用清洁剂。"
	reagent_state = GAS
	color = "#404030" // rgb: 64, 64, 48
	taste_description = "辛烈味"

/datum/reagent/diethylamine
	name = "二乙胺"
	description = "一种仲胺，具轻微腐蚀性。"
	color = "#604030" // rgb: 96, 64, 48
	taste_description = "铁味"

/datum/reagent/carbondioxide
	name = "二氧化碳"
	reagent_state = GAS
	description = "一种常由含碳燃料燃烧产生的气体。你的肺里也一直在产生它。"
	color = "#B0B0B0" // rgb : 192, 192, 192
	taste_description = "某种难以言喻之物"

/datum/reagent/nitrous_oxide
	name = "一氧化二氮"
	description = "一种强力氧化剂，可作火箭燃料，也可在手术中用作麻醉剂。"
	reagent_state = LIQUID
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	color = "#808080"
	taste_description = "甜味"

/datum/reagent/nitrous_oxide/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == VAPOR)
		M.drowsyness += max(round(reac_volume, 1), 2)

/datum/reagent/nitrous_oxide/on_mob_life(mob/living/carbon/M)
	M.drowsyness += 2
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.blood_volume = max(H.blood_volume - 10, 0)
	if(prob(20))
		M.losebreath += 2
		M.confused = min(M.confused + 2, 5)
	..()

/datum/reagent/stimulum
	name = "兴奋气"
	description = "一种不稳定的实验性气体，能大幅提高吸入者的精力，但会随时间推移造成不断增加的毒素伤害。"
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5 // Because stimulum/nitryl are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "E1A116"
	taste_description = "酸味"

/datum/reagent/stimulum/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_STUNIMMUNE, type)
	ADD_TRAIT(L, TRAIT_SLEEPIMMUNE, type)

/datum/reagent/stimulum/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_STUNIMMUNE, type)
	REMOVE_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	..()

/datum/reagent/stimulum/on_mob_life(mob/living/carbon/M)
	M.adjustStaminaLoss(-2*REM, 0)
	M.adjustToxLoss(current_cycle*0.1*REM, 0) // 1 toxin damage per cycle at cycle 10
	..()

/datum/reagent/nitryl
	name = "硝速气"
	description = "一种高反应性气体，会让你感觉自己更快。"
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5 // Because stimulum/nitryl are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "90560B"
	taste_description = "灼烧感"

/datum/reagent/nitryl/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-1, blacklisted_movetypes=(FLYING|FLOATING))

/datum/reagent/nitryl/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(type)
	..()

/////////////////////////Colorful Powder////////////////////////////
//For colouring in /proc/mix_color_from_reagents

/datum/reagent/colorful_reagent/powder
	name = "凡俗粉末" //the name's a bit similar to the name of colorful reagent, but hey, they're practically the same chem anyway
	var/colorname = "none"
	description = "一种用于给东西染色的粉末。"
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 207, 54, 0
	taste_description = "教室后排的味道"

/datum/reagent/colorful_reagent/powder/New()
	if(colorname == "none")
		description = "一种看起来相当普通的粉末。它看上去不像能把什么东西染上色……"
	else if(colorname == "invisible")
		description = "一种隐形粉末。很遗憾，正因为它看不见，也看不出它能把什么染上色……"
	else
		var/display_colorname = colorname
		switch(colorname)
			if("red")
				display_colorname = "红色"
			if("orange")
				display_colorname = "橙色"
			if("yellow")
				display_colorname = "黄色"
			if("green")
				display_colorname = "绿色"
			if("blue")
				display_colorname = "蓝色"
			if("purple")
				display_colorname = "紫色"
			if("black")
				display_colorname = "黑色"
			if("white")
				display_colorname = "白色"
		description = "一种[display_colorname]粉末，可用于把东西染成[display_colorname]。"

/datum/reagent/colorful_reagent/powder/red
	name = "红色粉末"
	colorname = "red"
	color = "#DA0000" // red
	random_color_list = list("#FC7474")

/datum/reagent/colorful_reagent/powder/orange
	name = "橙色粉末"
	colorname = "orange"
	color = "#FF9300" // orange
	random_color_list = list("#FF9300")

/datum/reagent/colorful_reagent/powder/yellow
	name = "黄色粉末"
	colorname = "yellow"
	color = "#FFF200" // yellow
	random_color_list = list("#FFF200")

/datum/reagent/colorful_reagent/powder/green
	name = "绿色粉末"
	colorname = "green"
	color = "#A8E61D" // green
	random_color_list = list("#A8E61D")

/datum/reagent/colorful_reagent/powder/blue
	name = "蓝色粉末"
	colorname = "blue"
	color = "#00B7EF" // blue
	random_color_list = list("#71CAE5")

/datum/reagent/colorful_reagent/powder/purple
	name = "紫色粉末"
	colorname = "purple"
	color = "#DA00FF" // purple
	random_color_list = list("#BD8FC4")

/datum/reagent/colorful_reagent/powder/invisible
	name = "隐形粉末"
	colorname = "invisible"
	color = "#FFFFFF00" // white + no alpha
	random_color_list = list(null)	//because using the powder color turns things invisible

/datum/reagent/colorful_reagent/powder/black
	name = "黑色粉末"
	colorname = "black"
	color = "#1C1C1C" // not quite black
	random_color_list = list("#8D8D8D")	//more grey than black, not enough to hide my true colors

/datum/reagent/colorful_reagent/powder/white
	name = "白色粉末"
	colorname = "white"
	color = "#FFFFFF" // white
	random_color_list = list("#FFFFFF") //doesn't actually change appearance at all

// used by crayons, can't color living things but still used for stuff like food recipes

/datum/reagent/colorful_reagent/powder/red/crayon
	name = "红色蜡笔粉"
	can_colour_mobs = FALSE

/datum/reagent/colorful_reagent/powder/orange/crayon
	name = "橙色蜡笔粉"
	can_colour_mobs = FALSE

/datum/reagent/colorful_reagent/powder/yellow/crayon
	name = "黄色蜡笔粉"
	can_colour_mobs = FALSE

/datum/reagent/colorful_reagent/powder/green/crayon
	name = "绿色蜡笔粉"
	can_colour_mobs = FALSE

/datum/reagent/colorful_reagent/powder/blue/crayon
	name = "蓝色蜡笔粉"
	can_colour_mobs = FALSE

/datum/reagent/colorful_reagent/powder/purple/crayon
	name = "紫色蜡笔粉"
	can_colour_mobs = FALSE

//datum/reagent/colorful_reagent/powder/invisible/crayon

/datum/reagent/colorful_reagent/powder/black/crayon
	name = "黑色蜡笔粉"
	can_colour_mobs = FALSE

/datum/reagent/colorful_reagent/powder/white/crayon
	name = "白色蜡笔粉"
	can_colour_mobs = FALSE

//////////////////////////////////Hydroponics stuff///////////////////////////////

/datum/reagent/plantnutriment
	name = "通用营养液"
	description = "某种营养液。你实在看不出它具体是什么，最好连同获得方式一起上报。"
	color = "#000000" // RBG: 0, 0, 0
	var/tox_prob = 0
	taste_description = "植物肥料"

/datum/reagent/plantnutriment/on_mob_life(mob/living/carbon/M)
	if(prob(tox_prob))
		M.adjustToxLoss(1*REM, 0)
		. = 1
	..()

/datum/reagent/plantnutriment/eznutriment
	name = "E-Z 营养液"
	description = "富含电解质，这正是植物所渴求的。"
	color = "#376400" // RBG: 50, 100, 0
	tox_prob = 10

/datum/reagent/plantnutriment/left4zednutriment
	name = "尸变前夜"
	description = "一种不稳定营养液，会让植物比平时更频繁地发生突变。"
	color = "#1A1E4D" // RBG: 26, 30, 77
	tox_prob = 25

/datum/reagent/plantnutriment/robustharvestnutriment
	name = "丰产剂"
	description = "一种极为强效的营养液，可阻止植物突变。"
	color = "#9D9D00" // RBG: 157, 157, 0
	tox_prob = 15







// GOON OTHERS



/datum/reagent/fuel/oil
	name = "油"
	description = "会燃起带烟的小火，可用来制取灰烬。"
	reagent_state = LIQUID
	color = "#2D2D2D"
	taste_description = "油味"

/datum/reagent/stable_plasma
	name = "稳定等离子体"
	description = "被锁定为液态的不可燃等离子体，无法被点燃，也不会变成气态或固态。"
	reagent_state = LIQUID
	color = "#2D2D2D"
	taste_description = "苦味"
	taste_mult = 1.5

/datum/reagent/iodine
	name = "碘"
	description = "常作为营养成分加入食盐中；单独品尝时味道可就没那么讨喜了。"
	reagent_state = LIQUID
	color = "#BC8A00"
	taste_description = "金属味"

/datum/reagent/bromine
	name = "溴"
	description = "一种棕褐色高活性液体。可用于抑制自由基，但绝不是给人喝的。"
	reagent_state = LIQUID
	color = "#D35415"
	taste_description = "化学药剂味"

/datum/reagent/pentaerythritol
	name = "季戊四醇"
	description = "慢点来，这又不是拼字比赛！"
	reagent_state = SOLID
	color = "#E66FFF"
	taste_description = "酸味"

/datum/reagent/acetaldehyde
	name = "乙醛"
	description = "有点像塑料。尝起来像死人。"
	reagent_state = SOLID
	color = "#EEEEEF"
	taste_description = "死人味" //made from formaldehyde, ya get da joke ?

/datum/reagent/acetone_oxide
	name = "丙酮过氧化物"
	description = "被奴役的氧气"
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "酸味"


/datum/reagent/acetone_oxide/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people kills people!
	if(!istype(M))
		return
	if(method == TOUCH)
		M.adjustFireLoss(2, FALSE) // burns,
		M.adjust_fire_stacks((reac_volume / 10))
	..()



/datum/reagent/phenol
	name = "苯酚"
	description = "一种带羟基的芳香碳环，是某些药物的有用前驱体，但本身没有治疗效果。"
	reagent_state = LIQUID
	color = "#E7EA91"
	taste_description = "酸味"

/datum/reagent/ash
	name = "灰烬"
	description = "据说凤凰会从中重生，但你从没亲眼见过。"
	reagent_state = LIQUID
	color = "#515151"
	taste_description = "灰味"

/datum/reagent/acetone
	name = "丙酮"
	description = "一种滑腻、略具致癌性的液体，在日常生活中有着许多普通用途。"
	reagent_state = LIQUID
	color = "#AF14B7"
	taste_description = "酸味"

/datum/reagent/colorful_reagent
	name = "缤纷试剂"
	description = "彻底品尝彩虹吧。"
	reagent_state = LIQUID
	var/list/random_color_list = list("#00aedb","#a200ff","#f47835","#d41243","#d11141","#00b159","#00aedb","#f37735","#ffc425","#008744","#0057e7","#d62d20","#ffa700")
	color = "#C8A5DC"
	taste_description = "彩虹味"
	var/can_colour_mobs = TRUE

/datum/reagent/colorful_reagent/New()
	SSticker.OnRoundstart(CALLBACK(src,PROC_REF(UpdateColor)))

/datum/reagent/colorful_reagent/proc/UpdateColor()
	color = pick(random_color_list)

/datum/reagent/colorful_reagent/on_mob_life(mob/living/carbon/M)
	if(can_colour_mobs)
		M.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)
		return ..()

/datum/reagent/colorful_reagent/reaction_mob(mob/living/M, reac_volume)
	if(can_colour_mobs)
		M.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)
		..()

/datum/reagent/colorful_reagent/reaction_obj(obj/O, reac_volume)
	if(O)
		O.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)
	..()

/datum/reagent/colorful_reagent/reaction_turf(turf/T, reac_volume)
	if(T)
		T.add_atom_colour(pick(random_color_list), WASHABLE_COLOUR_PRIORITY)
	..()

/datum/reagent/hair_dye
	name = "量子染发剂"
	description = "有很高概率把你变成疯科学家的模样。"
	reagent_state = LIQUID
	var/list/potential_colors = list("0ad","a0f","f73","d14","d14","0b5","0ad","f73","fc2","084","05e","d22","fa0") // fucking hair code
	color = "#C8A5DC"
	taste_description = "酸味"

/datum/reagent/hair_dye/New()
	SSticker.OnRoundstart(CALLBACK(src,PROC_REF(UpdateColor)))

/datum/reagent/hair_dye/proc/UpdateColor()
	color = pick(potential_colors)

/datum/reagent/hair_dye/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(method == TOUCH || method == VAPOR)
		if(M && ishuman(M))
			var/mob/living/carbon/human/H = M
			H.hair_color = pick(potential_colors)
			H.facial_hair_color = pick(potential_colors)
			H.update_hair()

/datum/reagent/barbers_aid
	name = "理发师之助"
	description = "面向全世界脱发问题的解决方案。"
	reagent_state = LIQUID
	color = "#A86B45" //hair is brown
	taste_description = "酸味"

/datum/reagent/concentrated_barbers_aid
	name = "浓缩理发师之助"
	description = "面向全世界脱发问题的浓缩解决方案。"
	reagent_state = LIQUID
	color = "#7A4E33" //hair is dark browmn
	taste_description = "酸味"

/datum/reagent/saltpetre
	name = "硝石"
	description = "易爆。争议。第三样东西。"
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	taste_description = "清凉的盐味"

/datum/reagent/charcoal
	name = "木炭"
	description = "烧过的木头。"
	reagent_state = SOLID
	color = "#020202" // rgb: 96, 165, 132
	taste_description = "灰味"

/datum/reagent/lye
	name = "碱液"
	description = "也就是氢氧化钠。要是把这当职业来做，多少显得有点无趣。"
	reagent_state = LIQUID
	color = "#FFFFD6" // very very light yellow
	taste_description = "酸味"

/datum/reagent/drying_agent
	name = "干燥剂"
	description = "一种除湿剂，可用于把物体弄干。"
	reagent_state = LIQUID
	color = "#A70FFF"
	taste_description = "干燥感"

/datum/reagent/drying_agent/reaction_turf(turf/open/T, reac_volume)
	if(istype(T))
		T.MakeDry(ALL, TRUE, reac_volume * 5 SECONDS)		//50 deciseconds per unit

// Bee chemicals

/datum/reagent/royal_bee_jelly
	name = "蜂王浆"
	description = "若将蜂王浆注入太空蜂后体内，那只蜂后会分裂成两只蜂。"
	color = "#00ff80"
	taste_description = "奇异的蜂蜜味"

/datum/reagent/royal_bee_jelly/on_mob_life(mob/living/carbon/M)
	if(prob(2))
		M.say(pick("嗡嗡……","嗡嗡 嗡嗡","嗡嗡嗡嗡嗡嗡……"), forced = "royal bee jelly")
	..()

//Misc reagents

/datum/reagent/growthserum
	name = "生长血清"
	description = "一种商业化学品，号称专为帮助中老年男性重振雄风而设计。"//not really it just makes you a giant
	color = "#ff0000"//strong red. rgb 255, 0, 0
	var/current_size = 1
	taste_description = "苦味" // apparently what viagra tastes like

/datum/reagent/growthserum/on_mob_life(mob/living/carbon/H)
	var/newsize = current_size
	switch(volume)
		if(0 to 19)
			newsize = 1.25
		if(20 to 49)
			newsize = 1.5
		if(50 to 99)
			newsize = 2
		if(100 to 199)
			newsize = 2.5
		if(200 to INFINITY)
			newsize = 3.5

	H.resize = newsize/current_size
	current_size = newsize
	H.update_transform()
	..()

/datum/reagent/growthserum/on_mob_end_metabolize(mob/living/M)
	M.resize = 1/current_size
	M.update_transform()
	..()

/datum/reagent/plastic_polymers
	name = "塑料聚合物"
	description = "构成塑料的石油基成分。"
	color = "#f7eded"
	taste_description = "塑料味"

/datum/reagent/glitter
	name = "通用闪粉"
	description = "如果你能看到这段描述，请联系程序员。"
	color = "#FFFFFF" //pure white
	taste_description = "塑料味"
	reagent_state = SOLID
	var/glitter_type = /obj/effect/decal/cleanable/glitter

/datum/reagent/glitter/reaction_turf(turf/T, reac_volume)
	if(!istype(T))
		return
	new glitter_type(T)

/datum/reagent/glitter/pink
	name = "粉色闪粉"
	description = "会到处乱飞的粉色亮片"
	color = "#ff8080" //A light pink color
	glitter_type = /obj/effect/decal/cleanable/glitter/pink

/datum/reagent/glitter/white
	name = "白色闪粉"
	description = "会到处乱飞的白色亮片"
	glitter_type = /obj/effect/decal/cleanable/glitter/white

/datum/reagent/glitter/blue
	name = "蓝色闪粉"
	description = "会到处乱飞的蓝色亮片"
	color = "#4040FF" //A blueish color
	glitter_type = /obj/effect/decal/cleanable/glitter/blue

/datum/reagent/pax
	name = "帕克斯"
	description = "一种无色液体，会压制服用者的暴力倾向。"
	color = "#AAAAAA55"
	taste_description = "水味"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

/datum/reagent/pax/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_PACIFISM, type)

/datum/reagent/pax/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_PACIFISM, type)
	..()

/datum/reagent/pax/peaceborg
	name = "合成帕克斯"
	description = "一种会压制服用者暴力倾向的无色液体。比普通帕克斯更便宜易合成，但失效更快。"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM

/datum/reagent/peaceborg
	can_synth = FALSE

/datum/reagent/peaceborg/confuse
	name = "眩晕溶液"
	description = "会让目标失去平衡并感到头晕"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "眩晕感"
	can_synth = TRUE

/datum/reagent/peaceborg/confuse/on_mob_life(mob/living/carbon/M)
	if(M.confused < 6)
		M.confused = CLAMP(M.confused + 3, 0, 5)
	if(M.dizziness < 6)
		M.dizziness = CLAMP(M.dizziness + 3, 0, 5)
	if(prob(20))
		to_chat(M, "你感到一阵迷糊和失衡。")
	..()

/datum/reagent/peaceborg/tire
	name = "疲惫溶液"
	description = "一种极其微弱的体力毒素，会让目标疲惫，但完全无害。"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "疲惫感"
	can_synth = TRUE

/datum/reagent/peaceborg/tire/on_mob_life(mob/living/carbon/M)
	var/healthcomp = (100 - M.health)	//DOES NOT ACCOUNT FOR ADMINBUS THINGS THAT MAKE YOU HAVE MORE THAN 200/210 HEALTH, OR SOMETHING OTHER THAN A HUMAN PROCESSING THIS.
	if(M.getStaminaLoss() < (45 - healthcomp))	//At 50 health you would have 200 - 150 health meaning 50 compensation. 60 - 50 = 10, so would only do 10-19 stamina.)
		M.adjustStaminaLoss(10)
	if(prob(30))
		to_chat(M, "你该坐下来歇一会儿了……")
	..()

/datum/reagent/spider_extract
	name = "蜘蛛萃取液"
	description = "一种来自奥斯特拉利库斯星区的高度专用提取物，用于制造育母蜘蛛。"
	color = "#ED2939"
	taste_description = "天旋地转"
	can_synth = FALSE

/// Improvised reagent that induces vomiting. Created by dipping a dead mouse in welder fluid.
/datum/reagent/yuck
	name = "有机浆糊"
	description = "由多种颜色液体混合而成，会引发呕吐。"
	glass_name = "一杯……呕！"
	glass_desc = ""
	color = "#545000"
	taste_description = "内脏味"
	taste_mult = 4
	can_synth = FALSE
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	var/yuck_cycle = 0 //! The `current_cycle` when puking starts.

/datum/reagent/yuck/on_mob_add(mob/living/L)
	if(HAS_TRAIT(src, TRAIT_NOHUNGER)) //they can't puke
		holder.del_reagent(type)

#define YUCK_PUKE_CYCLES 3 		// every X cycle is a puke
#define YUCK_PUKES_TO_STUN 3 	// hit this amount of pukes in a row to start stunning
/datum/reagent/yuck/on_mob_life(mob/living/carbon/C)
	if(!yuck_cycle)
		if(prob(8))
			var/dread = pick("有什么东西在我胃里蠕动……", \
				"一阵湿漉漉的低吼从我胃里传来……", \
				"有那么一瞬间你觉得周围在动，但其实在动的是你的胃……")
			to_chat(C, "<span class='danger'>[dread]</span>")
			yuck_cycle = current_cycle
	else
		var/yuck_cycles = current_cycle - yuck_cycle
		if(yuck_cycles % YUCK_PUKE_CYCLES == 0)
			if(yuck_cycles >= YUCK_PUKE_CYCLES * YUCK_PUKES_TO_STUN)
				holder.remove_reagent(type, 5)
			C.vomit(rand(14, 26), stun = yuck_cycles >= YUCK_PUKE_CYCLES * YUCK_PUKES_TO_STUN)
	if(holder)
		return ..()
#undef YUCK_PUKE_CYCLES
#undef YUCK_PUKES_TO_STUN

/datum/reagent/yuck/on_mob_end_metabolize(mob/living/L)
	yuck_cycle = 0 // reset vomiting
	return ..()

/datum/reagent/yuck/on_transfer(atom/A, method=TOUCH, trans_volume)
	if(method == INGEST || !iscarbon(A))
		return ..()

	A.reagents.remove_reagent(type, trans_volume)
	A.reagents.add_reagent(/datum/reagent/fuel, trans_volume * 0.75)
	A.reagents.add_reagent(/datum/reagent/water, trans_volume * 0.25)

	return ..()

/datum/reagent/cellulose
	name = "纤维素纤维"
	description = "一种结晶状多葡萄糖聚合物，植物们都对它赞不绝口。"
	reagent_state = SOLID
	color = "#E6E6DA"
	taste_mult = 0
