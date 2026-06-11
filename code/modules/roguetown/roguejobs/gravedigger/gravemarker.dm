/datum/crafting_recipe/roguetown/gravemarker
	name = "墓碑标记"
	result = /obj/structure/gravemarker
	reqs = list(/obj/item/grown/log/tree/stick = 1)
	time = 10 SECONDS
	verbage_simple = "捆扎"
	verbage = "捆扎"
	craftsound = 'sound/foley/Building-01.ogg'
	structurecraft = /obj/structure/closet/dirthole
	craftdiff = 0

/datum/crafting_recipe/roguetown/gravemarker/TurfCheck(mob/user, turf/T)
	if(!(locate(/obj/structure/closet/dirthole) in T))
		to_chat(user, span_warning("这里没有坟墓。"))
		return FALSE
	for(var/obj/structure/closet/dirthole/D in T)
		if(D.stage != 4)
			to_chat(user, span_warning("这座坟墓还没填平。"))
			return FALSE
	if(locate(/obj/structure/gravemarker) in T)
		to_chat(user, span_warning("这座坟墓已经被祝圣过了。"))
		return FALSE
	return TRUE

/obj/structure/gravemarker
	name = "墓碑标记"
	desc = "一块向逝者致意的朴素墓碑标记。"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "gravemarker1"
	density = FALSE
	max_integrity = 0
	static_debris = list(/obj/item/grown/log/tree/stick = 1)
	anchored = TRUE
	layer = 2.91
	obj_flags = UNIQUE_RENAME
	var/wrotesign

/obj/structure/gravemarker/examine(mob/user)
	. = ..()
	if(wrotesign)
		if(!user.is_literate())
			. += "我不识字。反正这上头的名字如今也没多大意义了。"
		else
			. += span_notice("一块墓碑标记。上面写着... \"[wrotesign]\".")


/obj/structure/gravemarker/attackby(obj/item/W, mob/user, params)
	if(!user.cmode)
		if(!user.is_literate())
			to_chat(user, span_warning("我不会写字。它将继续无名。"))
			return
		if((user.used_intent.blade_class == BCLASS_STAB) && (W.wlength == WLENGTH_SHORT))
			if(wrotesign)
				to_chat(user, span_warning("这里已经刻了字。"))
				return
			else
				var/inputty = stripped_input(user, "有人长眠于此。或许我该刻下一个名字？", "", null, 200)
				if(inputty && !wrotesign)
					wrotesign = inputty
					name = "[inputty]"
		else
			to_chat(user, span_warning("唉，这样不行。要是用某种短而尖锐的东西去刻，也许能留下字迹。比如一把刀。"))
			return

/obj/structure/gravemarker/Destroy()
	var/turf/T = get_turf(src)
	if(T)
		new /obj/item/grown/log/tree/stick(T)
	..()

/mob/dead/new_player/proc/reducespawntime(amt)
	if(ckey)
		if(amt)
			if(GLOB.respawntimes[ckey])
				GLOB.respawntimes[ckey] = GLOB.respawntimes[ckey] + amt

/obj/structure/gravemarker/OnCrafted(dir, mob/user)
	icon_state = "gravemarker[rand(1,3)]"
	for(var/obj/structure/closet/dirthole/hole in loc)
		if(pacify_coffin(hole, user))
			to_chat(user, span_notice("我感到他们的灵魂终于得到了安宁……"))
			SEND_SIGNAL(user, COMSIG_GRAVE_CONSECRATED, hole)
			record_round_statistic(STATS_GRAVES_CONSECRATED)
	return ..()
