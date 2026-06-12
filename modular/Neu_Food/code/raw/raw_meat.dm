// Raw meat from land animals.
/obj/item/reagent_containers/food/snacks/rogue/meat
	eat_effect = /datum/status_effect/debuff/uncookedfood
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	name = "肉块"
	icon = 'modular/Neu_Food/icons/raw/raw_meat.dmi'
	icon_state = "meatslab"
	slice_batch = TRUE // so it takes more time, changed from FALSE
	filling_color = "#8f433a"
	rotprocess = SHELFLIFE_SHORT
	chopping_sound = TRUE
	foodtype = MEAT
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	cooked_smell = /datum/pollutant/food/fried_meat
	var/fresh_meat = FALSE
	become_rot_type = /obj/item/reagent_containers/food/snacks/rogue/meat_rotten

/obj/item/reagent_containers/food/snacks/rogue/meat_rotten
	eat_effect = /datum/status_effect/debuff/rotfood
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	name = "腐坏肉块"
	desc = "它曾经还能吃……如今对大多数人来说只剩一团腐臭烂肉。"
	icon = 'modular/Neu_Food/icons/raw/raw_meat.dmi'
	icon_state = "meat_rotten"

/obj/item/reagent_containers/food/snacks/rogue/meat_rotten/Initialize(mapload)
	. = ..()
	src.become_rotten(FALSE)

/obj/item/reagent_containers/food/snacks/rogue/meat_rotten/can_craft_with()
	return TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/attackby(obj/item/I, mob/living/user)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把[src]拍松成炸肉排坯。"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀压！"))
	else 
		return ..()

/* ............. Generic Steak ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/steak
	ingredient_size = 2
	name = "生肉排"
	icon_state = "meatsteak"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	slice_bclass = BCLASS_CHOP


/* ............. Pork (Fatty Sprite) ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/fatty //pork
	name = "生猪肉"
	icon_state = "pork"
	color = "#f093c3"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon
	chopping_sound = TRUE
	cooked_smell = /datum/pollutant/food/fried_meat

/* ............. Bacon ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/bacon
	name = "生培根"
	icon_state = "bacon"
	slice_path = null
	slices_num = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	filling_color = "#8a0000"
	cooked_smell = /datum/pollutant/food/fried_bacon

/* ............. Spider Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/spider // Low-nutrient, kind of gross. Survival food.
	name = "蜘蛛肉"
	icon_state = "spidermeat"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried
	slice_path = null
	slices_num = 0

/obj/item/reagent_containers/food/snacks/rogue/meat/spider/attackby(obj/item/I, mob/living/user)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把[src]拍松成蛛肉炸排坯。"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀压！"))
	else 
		return ..()

/* ............. Whole Bird ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry
	name = "褪毛禽肉"
	icon_state = "halfchicken"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	fried_type = null
	slices_num = 2
	slice_sound = TRUE
	ingredient_size = 4
	cooked_smell = /datum/pollutant/food/cooked_chicken

/* ............. Chicken Cutlet (Drumstick) ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet
	name = "禽肉"
	icon_state = "chickencutlet"
	ingredient_size = 2
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	slices_num = 1
	slice_bclass = BCLASS_CHOP
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried

/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/attackby(obj/item/I, mob/living/user)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把[src]拍松。"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀压！"))
	else 
		return ..()
/* ............. Crab Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/crab
	name = "蟹肉"
	desc = "一块生蟹肉，鲜美得不得了。"
	icon_state = "crabmeatraw"
	slice_path = null
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried
	slices_num = null
	ingredient_size = 1
	cooked_smell = /datum/pollutant/food/fried_crab

/obj/item/reagent_containers/food/snacks/rogue/meat/crab/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, "<span class='notice'>用黄油面皮把蟹肉包起来……</span>")
			if(do_after(user,short_cooktime, target = src))
				user.mind.add_sleep_experience(/datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/crabcakeraw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把它放到桌上！"))
		return TRUE
	. = ..()

/* ............. Cabbit Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit
	name = "生卡比特肉"
	icon_state = "cabbitcutlet"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/rabbit
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	slices_num = 1
	ingredient_size = 1

/* ............. Volf Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf
	name = "生沃尔夫肉"
	icon_state = "volfstrip"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef		//Honestly, we don't need our own minced type on this one.
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried

/* ............. fish chop ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/fish
	name = "鱼柳"
	desc = "一片鱼柳。剖开以后，鱼肉里头看起来其实都差不多。"
	icon_state = "fish_filet"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	slices_num = 1
	ingredient_size = 1
	cooked_smell = /datum/pollutant/food/cooked_fish

/* .........   Shellfish    ................. */
/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
	name = "贝甲肉"
	desc = "取自甲壳类的肉，带着海咸味，口感也和多数鱼肉不同。可切碎成肉糜，或烤制、油炸成熟食。"
	icon_state = "shellfish_meat"
	rotprocess = SHELFLIFE_LONG
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	slices_num = 1
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	cooked_smell = /datum/pollutant/food/fried_shellfish

// MEAT MINCE
/*	.............   Minced meat & stuffing sausages   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/mince
	name = "肉糜"
	icon_state = "meatmince"
	ingredient_size = 2
	slice_path = null
	filling_color = "#8a0000"
	rotprocess = SHELFLIFE_TINY
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/mess(get_turf(src))
	playsound(get_turf(src), 'modular/Neu_Food/sound/meatslap.ogg', 100, TRUE, -1)
	..()
	qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("正在灌制香肠……"))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/fat))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("正在灌制香肠……"))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("正在准备鞑靼生肉……"))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/tartar(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能处理。"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	name = "碎肉糜"

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	name = "碎鱼糜"
	icon_state = "fishmince"

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/rabbit
	name = "卡比特肉糜"
	icon_state = "meatmince"

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry
	name = "禽肉糜"
	icon_state = "meatmince"
	cooked_smell = /datum/pollutant/food/cooked_chicken

/obj/item/reagent_containers/food/snacks/rogue/meat/sausage
	name = "生香肠"
	icon_state = "raw_sausage"
	ingredient_size = 1
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	cooked_smell = /datum/pollutant/food/fried_sausage

/* ............. fish chop ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/fish
	name = "鱼柳"
	desc = "一片鱼柳。剖开以后，鱼肉里头看起来其实都差不多。"
	icon_state = "fish_filet"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	slices_num = 1
	ingredient_size = 1

/* .........   Shellfish    ................. */
/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
	name = "贝甲肉"
	desc = "取自甲壳类的肉，带着海咸味，口感也和多数鱼肉不同。可切碎成肉糜，或烤制、油炸成熟食。"
	icon_state = "shellfish_meat"
	rotprocess = SHELFLIFE_LONG
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	slices_num = 1
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried

/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	eat_effect = null
	slices_num = 0
	name = "炸贝甲肉"
	desc = "油炸过的贝甲肉，略带咸味，却相当鲜美。"
	faretype = FARE_NEUTRAL
	icon_state = "shellfish_meat_cooked"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)

/* ............. Cabbit Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit
	name = "生卡比特肉"
	icon_state = "cabbitcutlet"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/rabbit
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	slices_num = 1
	ingredient_size = 1

/* ............. Volf Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf
	name = "生沃尔夫肉"
	icon_state = "volfstrip"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef		//Honestly, we don't need our own minced type on this one.
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried

// Do NOT add this to the stockpile, they have other uses and are unique in how they're obtained.
/* ............. Gnoll Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll
	name = "生豺狼人肉"
	desc = "从豺狼人身上取下来的肉。诡异的是，它看起来并不像从活物身上切下，反倒像仍旧活着。"
	icon_state = "gnoll"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef		//Honestly, we don't need our own minced type on this one.
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll/seared
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll/seared
	rotprocess = SHELFLIFE_EXTREME
	sellprice = 118

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn
	name = "邪孽胎肉"
	desc = "一块令人作呕的肉团，是对一切美好之物的亵渎……传说它能用来唤出某种邪恶生物。"
	icon_state = "vilespawn"
	slice_path = null
	fried_type = null
	cooked_type = null
	rotprocess = 0
	sellprice = 118

//Gnoll summoning item, crafted from gnoll meat AND a gem, both only obtainable from dead gnolls.  
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn/attack_self(mob/living/user)
	to_chat(user, span_notice("你将[src.name]献给虚空，低声吟唱，呼唤一具宿体……"))
	var/list/candidates = pollGhostCandidates("你想扮演一头不纯豺狼人吗？你将服从于一名主人。", "不纯豺狼人", null, null, 10 SECONDS, "impure_gnoll")
	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("肉块依旧冰冷。没有任何暴虐余响愿意回应这份饥渴。"))
		return
	user.flash_fullscreen("redflash3")
	to_chat(user, span_userdanger("千万声惨叫的回响冲击着你的耳膜，血雨、骨山的幻景涌入脑海！血腥之星听见了你不洁的祈祷！"))
	user.playsound_local(get_turf(user), 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)
	user.emote("agony", forced = TRUE)
	user.Paralyze(4 SECONDS, ignore_canstun = TRUE)
	user.Knockdown(4 SECONDS)

	sleep(7 SECONDS)
	
	var/mob/C = pick(candidates)
	if(istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()
	var/mob/living/carbon/human/H = new(get_turf(user))
	H.key = C.key

	H.set_species(/datum/species/gnoll)
	var/datum/advclass/gnoll_impure/G = new()
	G.equipme(H)
	var/datum/gnoll_prefs/summoned_prefs = C.client?.prefs?.gnoll_prefs
	if(summoned_prefs)
		H.fully_replace_character_name(null, summoned_prefs.ensure_gnoll_name())
	H.regenerate_icons()

	//The summoned gnoll now has its name assigned before the howl plays
	src.visible_message(span_warning("[src.name]猛地鼓胀撕裂，血肉四溅之中，一头不纯豺狼人降临了！"))
	H.emote("howl", TRUE)
	playsound(H.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 80, FALSE, 3)
	H.spawn_gibs(TRUE)
	qdel(C)
	qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn/admin
	name = "扭曲邪孽胎肉"
	desc = "立刻将使用者转化为一头不纯豺狼人。"

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn/admin/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		to_chat(user, "你必须是人类才能测试这个。")
		return

	user.flash_fullscreen("redflash3")
	to_chat(user, span_userdanger("千万声惨叫的回响冲击着你的耳膜，血雨、骨山的幻景涌入脑海！血腥之星听见了你不洁的祈祷！"))
	user.playsound_local(get_turf(user), 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)
	user.emote("agony", forced = TRUE)
	user.Paralyze(4 SECONDS, ignore_canstun = TRUE)
	user.Knockdown(4 SECONDS)

	sleep(7 SECONDS)

	var/mob/living/carbon/human/H = new(get_turf(user))
	H.key = user.key

	H.set_species(/datum/species/gnoll)
	var/datum/advclass/gnoll_impure/C = new()
	C.equipme(H)
	var/datum/gnoll_prefs/summoned_prefs = user.client?.prefs?.gnoll_prefs
	if(summoned_prefs)
		H.fully_replace_character_name(null, summoned_prefs.ensure_gnoll_name())
	H.regenerate_icons()

	user.visible_message(span_warning("[src.name]融入[user]的血肉之中，使其扭曲成一头不纯豺狼人！"))
	H.emote("howl", TRUE)
	playsound(H.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 80, FALSE, 3)
	H.spawn_gibs(TRUE)

	qdel(user)
	qdel(src)
