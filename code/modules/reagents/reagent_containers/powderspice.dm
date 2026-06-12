/obj/item/reagent_containers/powder
	name = "默认粉末"
	desc = ""
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "spice"
	item_state = "spice"
	possible_transfer_amounts = list()
	volume = 15
	sellprice = 10
	grid_width = 32
	grid_height = 32
	dropshrink = 0.75

/obj/item/reagent_containers/powder/spice
	name = "香料"
	desc = ""
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "spice"
	item_state = "spice"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/druqks = 15)
	grind_results = list(/datum/reagent/druqks = 15)
	sellprice = 10

/datum/reagent/druqks
	name = "德鲁克斯"
	description = ""
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 16
	metabolization_rate = 0.2

/datum/reagent/druqks/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2)
	M.adjustToxLoss(3, 0)
	..()
	. = 1

/datum/reagent/druqks/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(30)
	if(prob(5))
		if(M.gender == FEMALE)
			M.emote(pick("twitch_s","giggle"))
		else
			M.emote(pick("twitch_s","chuckle"))
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/druqks)
	..()

/atom/movable/screen/fullscreen/druqks
	icon_state = "spa"
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	blend_mode = 0
	show_when_dead = FALSE

/datum/reagent/druqks/overdose_start(mob/living/M)
	M.visible_message(span_warning("[M]鼻中流出了鲜血。"))

/datum/reagent/druqks/on_mob_metabolize(mob/living/M)
	M.overlay_fullscreen("druqk", /atom/movable/screen/fullscreen/druqks)
	M.set_drugginess(30)
	if(M.client)
		ADD_TRAIT(M, TRAIT_DRUQK, "based")
		SSdroning.area_entered(get_area(M), M.client)
//			if(M.client.screen && M.client.screen.len)
//				var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in M.client.screen
//				PM.backdrop(M.client.mob)

/datum/reagent/druqks/on_mob_end_metabolize(mob/living/M)
	M.clear_fullscreen("druqk")
	M.set_drugginess(0)
	M.remove_status_effect(/datum/status_effect/buff/druqks)
	if(M.client)
		REMOVE_TRAIT(M, TRAIT_DRUQK, "based")
		SSdroning.play_area_sound(get_area(M), M.client)
//		if(M.client.screen && M.client.screen.len)
///			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in M.client.screen
//			PM.backdrop(M.client.mob)

/obj/item/reagent_containers/powder/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	. = ..()
	///if the thrown object's target zone isn't the head
	if(thrownthing.target_zone != BODY_ZONE_PRECISE_NOSE)
		return
	if(iscarbon(hit_atom))
		var/mob/living/carbon/C = hit_atom
		if(canconsume(C, silent = TRUE))
			if(reagents.total_volume)
				playsound(C, 'sound/items/sniff.ogg', 100, FALSE)
				record_round_statistic(STATS_DRUGS_SNORTED)
				reagents.trans_to(C, 1, transfered_by = thrownthing.thrower, method = "swallow")
	qdel(src)

/obj/item/reagent_containers/powder/attack(mob/M, mob/user, def_zone)
	if(!canconsume(M, user))
		return FALSE
	if(M == user)
		M.visible_message(span_notice("[user]吸了吸[src]。"))
	else
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			var/obj/item/bodypart/CH = C.get_bodypart(BODY_ZONE_HEAD)
			if(!CH)
				to_chat(user, span_warning("[C.p_theyre(TRUE)]少了点什么。"))
			if(!C.can_smell())
				to_chat(user, span_warning("[C.p_theyre(TRUE)]没有鼻子！"))
			
			user.visible_message(span_danger("[user]试图强迫[C]吸入[src]。"), \
								span_danger("[user]试图强迫我吸入[src]！"))
		
			if(C.cmode)
				if(!CH.grabbedby)
					to_chat(user, span_info("[C.p_they(TRUE)]挣脱了控制。"))
					return FALSE
			if(!do_mob(user, M, 10))
				return FALSE

	playsound(M, 'sound/items/sniff.ogg', 100, FALSE)
	record_round_statistic(STATS_DRUGS_SNORTED)

	if(reagents.total_volume)
		reagents.trans_to(M, reagents.total_volume, transfered_by = user, method = "swallow")
		SEND_SIGNAL(M, COMSIG_DRUG_SNIFFED, user)
		record_featured_stat(FEATURED_STATS_CRIMINALS, user)
		record_round_statistic(STATS_DRUGS_SNORTED)
	qdel(src)
	return TRUE

/*
/obj/item/reagent_containers/pill/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(!dissolvable || !target.is_refillable())
		return
	if(target.is_drainable() && !target.reagents.total_volume)
		to_chat(user, span_warning("[target] is empty! There's nothing to dissolve [src] in."))
		return

	if(target.reagents.holder_full())
		to_chat(user, span_warning("[target] is full."))
		return

	user.visible_message(span_warning("[user]往[target]里偷偷塞了什么！"), span_notice("我把[src]溶进了[target]里。"), null, 2)
	reagents.trans_to(target, reagents.total_volume, transfered_by = user)
	qdel(src)
*/
/obj/item/reagent_containers/powder/flour
	name = "粉末"
	desc = ""
	gender = PLURAL
	icon_state = "flour"
	list_reagents = list(/datum/reagent/floure = 1)
	grind_results = list(/datum/reagent/floure = 10)
	volume = 1
	sellprice = 0

/obj/item/reagent_containers/powder/mana
	name = "闪亮的蓝色粉末"
	desc = ""
	gender = PLURAL
	icon_state = "flour"
	color = "#00b7ff"
	list_reagents = list(/datum/reagent/medicine/manapot = 12)
	grind_results = list(/datum/reagent/medicine/manapot = 12)
	volume = 12
	sellprice = 0

/obj/item/reagent_containers/powder/rocknut
	name = "石果粉"
	desc = ""
	gender = PLURAL
	icon_state = "rocknut"
	volume = 1
	sellprice = 0

/obj/item/reagent_containers/powder/rocknut/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/rocknutdry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/datum/reagent/floure
	name = "面粉"
	description = ""
	color = "#FFFFFF" // rgb: 96, 165, 132

/datum/reagent/floure/on_mob_life(mob/living/carbon/M)
	if(prob(30))
		M.confused = max(M.confused+3,0)
	M.emote(pick("cough"))
	..()

/obj/item/reagent_containers/powder/flour/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/flour(get_turf(src))
	..()
	qdel(src)

/datum/chemical_reaction/graintopowder
	name = "堆粉反应"
	id = "powderpiling"
	required_reagents = list(/datum/reagent/floure = 10)

/datum/chemical_reaction/graintopowder/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/reagent_containers/powder/flour(location)

/obj/item/reagent_containers/powder/salt
	name = "盐"
	desc = ""
	gender = PLURAL
	icon_state = "salt"
	list_reagents = list(/datum/reagent/consumable/sodiumchloride = 15)
	grind_results = list(/datum/reagent/consumable/sodiumchloride = 15)
	volume = 1

/obj/item/reagent_containers/powder/salt/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/salt(get_turf(src))
	..()
	qdel(src)

/obj/item/reagent_containers/powder/ozium
	name = "奥兹姆"
	desc = ""
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "ozium"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/ozium = 15)
	grind_results = list(/datum/reagent/ozium = 15)
	sellprice = 5

/datum/reagent/ozium
	name = "奥兹姆"
	description = ""
	color = "#a5606f" // rgb: 96, 165, 132
	overdose_threshold = 16
	metabolization_rate = 0.2
	taste_description = "苦涩的麻木感"

/datum/reagent/ozium/overdose_process(mob/living/M)
	M.adjustToxLoss(3, 0)
	..()
	. = 1

/datum/reagent/ozium/on_mob_life(mob/living/carbon/M)
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/ozium)
	..()

/datum/reagent/ozium/overdose_start(mob/living/M)
	M.playsound_local(M, 'sound/misc/heroin_rush.ogg', 100, FALSE)
	M.visible_message(span_warning("[M]鼻中流出了鲜血。"))

/obj/item/reagent_containers/powder/moondust
	name = "月尘"
	desc = "一堆泛着虹彩的白色粉末，气味辛烈浓重，闻之会让鼻腔发麻"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "moondust"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/moondust = 15)
	grind_results = list(/datum/reagent/moondust = 15)
	sellprice = 5

/datum/reagent/moondust
	name = "月尘"
	description = ""
	color = "#f9e5fd"
	overdose_threshold = 24
	metabolization_rate = 0.2
	taste_description = "麻木感与月华"

/datum/reagent/moondust/overdose_process(mob/living/M)
	M.adjustToxLoss(3, 0)
	..()
	. = 1

/datum/reagent/moondust/on_mob_metabolize(mob/living/M)
	M.flash_fullscreen("whiteflash")
	animate(M.client, pixel_y = 1, time = 1, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_y = -1, time = 1, flags = ANIMATION_RELATIVE)

/datum/reagent/moondust/on_mob_end_metabolize(mob/living/M)
	animate(M.client)

/datum/reagent/moondust/on_mob_life(mob/living/carbon/M)
	narcolepsy_drug_up(M)
	if(M.reagents.has_reagent(/datum/reagent/moondust_purest))
		M.Sleeping(40, 0)
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/moondust)
	if(prob(10))
		M.flash_fullscreen("whiteflash")
	..()

/datum/reagent/moondust/overdose_start(mob/living/M)
	M.playsound_local(M, 'sound/misc/heroin_rush.ogg', 100, FALSE)
	M.visible_message(span_warning("[M]鼻中流出了鲜血。"))

/obj/item/reagent_containers/powder/moondust_purest
	name = "月尘"
	desc = "一堆闪耀夺目的片状虹彩粉末"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "moondust_purest"
	possible_transfer_amounts = list()
	volume = 18
	list_reagents = list(/datum/reagent/moondust_purest = 18)
	grind_results = list(/datum/reagent/moondust_purest = 15)
	sellprice = 30

/datum/reagent/moondust_purest
	name = "至纯月尘"
	description = ""
	color = "#e7ade9"
	overdose_threshold = 20
	metabolization_rate = 0.2
	taste_description = "纯粹而毫无杂质的能量"

/datum/reagent/moondust_purest/overdose_process(mob/living/M)
	M.adjustToxLoss(3, 0)
	..()
	. = 1

/datum/reagent/moondust_purest/on_mob_metabolize(mob/living/M)
	M.playsound_local(M, 'sound/ravein/small/hello_my_friend.ogg', 100, FALSE)
	M.flash_fullscreen("whiteflash")
	animate(M.client, pixel_y = 1, time = 1, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_y = -1, time = 1, flags = ANIMATION_RELATIVE)

/datum/reagent/moondust_purest/on_mob_end_metabolize(mob/living/M)
	animate(M.client)

/datum/reagent/moondust_purest/on_mob_life(mob/living/carbon/M)
	narcolepsy_drug_up(M)
	if(M.reagents.has_reagent(/datum/reagent/moondust))
		if(!HAS_TRAIT(M, TRAIT_CRACKHEAD))
			M.Sleeping(40, 0)
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/moondust_purest)
	if(prob(20))
		M.flash_fullscreen("whiteflash")
	..()

/datum/reagent/moondust_purest/overdose_start(mob/living/M)
	M.playsound_local(M, 'sound/misc/heroin_rush.ogg', 100, FALSE)
	M.visible_message(span_warning("[M]鼻中流出了鲜血。"))


/obj/item/reagent_containers/powder/starsugar
	name = "星糖"
	desc = "一种强效兴奋剂，让你更接近她所感受到的一切；在许多地方都属禁忌与非法之物。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "starsugar"
	item_state = "starsugar"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/starsugar = 15, /datum/reagent/consumable/nutriment = 24) // monster and newports diet
	grind_results = list(/datum/reagent/starsugar = 15)
	sellprice = 25

/datum/reagent/starsugar
	name = "星糖"
	description = ""
	color = "#e47cdf"
	overdose_threshold = 20
	metabolization_rate = 0.5

/datum/reagent/starsugar/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-0.5, blacklisted_movetypes=(FLYING|FLOATING))
	L.playsound_local(L, 'sound/ravein/small/hello_my_friend.ogg', 100, FALSE)
	L.flash_fullscreen("whiteflash")
	animate(L.client, pixel_y = 1, time = 1, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_y = -1, time = 1, flags = ANIMATION_RELATIVE)

/datum/reagent/starsugar/on_mob_end_metabolize(mob/living/L)
	L.remove_status_effect(/datum/status_effect/buff/starsugar)
	L.remove_movespeed_modifier(type)
	animate(L.client)
	..()

/datum/reagent/starsugar/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("你感到异常亢奋。", "你觉得自己还得更快。", "你觉得自己能掌控一切。")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.AdjustStun(-40, FALSE)
	M.AdjustKnockdown(-40, FALSE)
	M.AdjustUnconscious(-40, FALSE)
	M.AdjustParalyzed(-40, FALSE)
	M.AdjustImmobilized(-40, FALSE)
	M.adjustStaminaLoss(-2, 0)
	M.Jitter(2)
	if(M.reagents.has_reagent(/datum/reagent/herozium))
		if(!HAS_TRAIT(M, TRAIT_CRACKHEAD))
			M.Sleeping(40, 0)
	if(prob(5))
		M.emote(pick("twitch", "shiver", "sniff"))
	narcolepsy_drug_up(M)
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/starsugar)
	if(prob(20))
		M.flash_fullscreen("whiteflash")
	..()
	..()
	. = 1

/datum/reagent/starsugar/overdose_process(mob/living/M)
	M.playsound_local(M, 'sound/misc/heroin_rush.ogg', 100, FALSE)
	M.visible_message(span_warning("[M]鼻中流出了鲜血。"))
	if((M.mobility_flags & MOBILITY_MOVE) && !ismovableatom(M.loc))
		for(var/i in 1 to 4)
			step(M, pick(GLOB.cardinals))
	if(prob(20))
		M.emote("laugh")
	if(prob(15))
		M.visible_message("<span class='danger'>[M]的脸色变得苍白，满是冷汗！</span>")
		M.drop_all_held_items()
	..()
	M.adjustToxLoss(4, 0)
	. = 1

/datum/reagent/herozium
	name = "赫若兹姆"
	description = ""
	reagent_state = LIQUID
	color = "#ff6207"
	overdose_threshold = 20
	metabolization_rate = 0.5

/obj/item/reagent_containers/powder/herozium
	name = "赫若兹姆"
	desc = "甜美而麻木。你喜欢伤害别人吗？它在大多数地区都被明令禁止并严加管制。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "herozium"
	item_state = "herozium"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/herozium = 15)
	grind_results = list(/datum/reagent/herozium = 15)
	sellprice = 30

/atom/movable/screen/fullscreen/herozium
	icon = 'icons/roguetown/maniac/fullscreen_wakeup_lossy_compression.dmi'
	icon_state = "wake_up"
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	blend_mode = 0
	show_when_dead = FALSE


/datum/reagent/herozium/on_mob_life(mob/living/carbon/M)
	M.jitteriness = 0
	M.confused = 0
	M.disgust = 0
	M.set_drugginess(30)
	M.overlay_fullscreen("herozium", /atom/movable/screen/fullscreen/herozium)
	M.apply_status_effect(/datum/status_effect/buff/herozium)
	if(M.reagents.has_reagent(/datum/reagent/ozium))
		if(!HAS_TRAIT(M, TRAIT_CRACKHEAD))
			M.Sleeping(80, 0)
	if(M.reagents.has_reagent(/datum/reagent/starsugar))
		if(!HAS_TRAIT(M, TRAIT_CRACKHEAD))
			M.Sleeping(80, 0)
	if(prob(15))
		M.playsound_local(M, 'sound/misc/heroin_rush.ogg', 100, FALSE)
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction(/datum/charflaw/addiction/junkie)
	..()
	. = 1


/datum/reagent/herozium/on_mob_end_metabolize(mob/living/M)
	M.clear_fullscreen("herozium")
	M.set_drugginess(0)
	M.remove_status_effect(/datum/status_effect/buff/herozium)
	if(M.client)
		SSdroning.play_area_sound(get_area(M), M.client)

/datum/reagent/herozium/overdose_process(mob/living/M)
	if(prob(30))
		var/reaction = rand(1,3)
		switch(reaction)
			if(1)
				M.emote("gag")
			if(2)
				M.emote("snore")
				M.Dizzy(25)
			if(3)
				M.emote("yawn")
	M.Sleeping(40, 0)
	M.adjustOxyLoss(4, 0)
	..()
	. = 1



/datum/reagent/sleep_powder
	name = "昏睡粉"
	description = ""
	color = "#ddd3df" // rgb: 96, 165, 132
	metabolization_rate = 1

// TO DO: eventually rewrite drowsyness code to do this instead then it can be expanded
// The reason why I haven't is because vampire lords have some special code for drowsyness I'll ave to get to...
/datum/reagent/sleep_powder/on_mob_metabolize(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/debuff/knockout)
	..()


/obj/item/reagent_containers/powder/sleep_powder
	name = "粉末"
	desc = ""
	gender = PLURAL
	icon_state = "flour"
	list_reagents = list(/datum/reagent/sleep_powder = 5)
	grind_results = null
	volume = 10
