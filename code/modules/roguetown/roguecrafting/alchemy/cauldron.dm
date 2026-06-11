/obj/machinery/light/rogue/cauldron
	name = "炼药锅"
	desc = "咕嘟咕嘟，辛劳与烦恼。一口用于炼制魔药的大铁锅。"
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "cauldron1"
	base_state = "cauldron"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	max_integrity = 300
	var/list/ingredients = list()
	var/maxingredients = 4
	var/brewing = 0
	var/waterneed = 90 
	var/mob/living/carbon/human/lastuser
	fueluse = 20 MINUTES
	crossfire = FALSE

/obj/machinery/light/rogue/cauldron/update_icon()
	..()
	cut_overlays()
	if(reagents.total_volume > 0)
		if(!brewing)
			var/mutable_appearance/filling = mutable_appearance(icon, "cauldron_full")
			filling.color = mix_color_from_reagents(reagents.reagent_list)
			filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
			add_overlay(filling)
		if(brewing > 0)
			var/mutable_appearance/filling = mutable_appearance(icon, "cauldron_boiling")
			filling.color = mix_color_from_reagents(reagents.reagent_list)
			filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
			add_overlay(filling)
	return

/obj/machinery/light/rogue/cauldron/Initialize(mapload)
	create_reagents(500, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE)
	. = ..()

/obj/machinery/light/rogue/cauldron/Destroy()
	chem_splash(loc, 2, list(reagents))
	qdel(reagents)
	..()

/obj/machinery/light/rogue/cauldron/burn_out()
	brewing = 0
	..()

/*
/obj/machinery/light/rogue/cauldron/examine(mob/user)
	if(ingredients.len)//ingredients.len
		DISABLE_BITFIELD(reagents.flags, AMOUNT_VISIBLE)
	else
		ENABLE_BITFIELD(reagents.flags, AMOUNT_VISIBLE)
	. = ..()
*/

/obj/machinery/light/rogue/cauldron/process()
	..()
	update_icon()
	if(on)
		if(ingredients.len)
			if(brewing < 20)
				if(src.reagents.has_reagent(/datum/reagent/water,waterneed))
					brewing++
					if(prob(10))
						playsound(src, "bubbles", 100, FALSE)
			else if(brewing == 20)
				var/list/outcomes = list()
				for(var/obj/item/ing in src.ingredients)
					if(!istype(ing,/obj/item/alch))
						continue
					var/obj/item/alch/alching = ing
					if(alching.major_pot != null)
						if(outcomes[alching.major_pot] != null)
							outcomes[alching.major_pot] += 3
						else
							outcomes[alching.major_pot] = 3
					if(alching.med_pot != null)
						if(outcomes[alching.med_pot] != null)
							outcomes[alching.med_pot] += 2
						else
							outcomes[alching.med_pot] = 2
					if(alching.minor_pot != null)
						if(outcomes[alching.minor_pot] != null)
							outcomes[alching.minor_pot] += 1
						else
							outcomes[alching.minor_pot] = 1
				sortTim(outcomes,cmp=/proc/cmp_numeric_dsc,associative = 1)
				if(outcomes.len && (outcomes[outcomes[1]] >= 5))
					var/result_path = outcomes[1]
					var/datum/alch_cauldron_recipe/found_recipe = new result_path
					var/amt2raise = lastuser?.STAINT*2
					var/in_cauldron = src?.reagents?.get_reagent_amount(/datum/reagent/water)
					// Handle skillgating
					if(!lastuser)
						brewing = 0
						src.visible_message(span_info("没有炼金术士的指引，炼药锅什么都炼制不出来。"))
						return
					if(found_recipe.skill_required > lastuser?.get_skill_level(/datum/skill/craft/alchemy))
						brewing = 0
						src.visible_message(span_warning("锅中的材料混合成了一团恶心的烂泥！也许需要更高明的炼金术士才能处理这个配方。"))
						if(reagents)
							src.reagents.remove_reagent(/datum/reagent/water, in_cauldron)
						for(var/obj/item/ing in src.ingredients)
							qdel(ing)
						src.reagents.add_reagent(/datum/reagent/yuck, in_cauldron) // 1 to 1 transmutation of yuck
						// Learn from your failure (Yeah you can technically still grind this way you just blow through a lot of ingredients)
						lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE) 
						return
					for(var/obj/item/ing in src.ingredients)
						qdel(ing)
					if(reagents)
						src.reagents.remove_reagent(/datum/reagent/water, in_cauldron)
					if(found_recipe.output_reagents.len)
						src.reagents.add_reagent_list(found_recipe.output_reagents)
					if(found_recipe.output_items.len)
						for(var/itempath in found_recipe.output_items)
							new itempath(get_turf(src))
					//handle player perception and reset for next time
					src.visible_message("<span class='info'>炼药锅沸腾完毕，散发出一股淡淡的[found_recipe.smells_like]气味。</span>")
					lastuser.log_message("brewed [found_recipe.type] in [src] (REAGENTS: [english_list(found_recipe.output_reagents, "none")]) (ITEMS: [english_list(found_recipe.output_items, "none")])", LOG_GAME)
					record_featured_stat(FEATURED_STATS_ALCHEMISTS, lastuser)
					record_round_statistic(STATS_POTIONS_BREWED)
					//give xp for /datum/skill/craft/alchemy
					lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
					playsound(src, "bubbles", 100, TRUE)
					playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)
					ingredients = list()
					brewing = 21
					qdel(found_recipe)
				else
					brewing = 0
					src.visible_message("<span class='info'>[src]中的材料完全无法融合...</span>")
					playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)

/obj/machinery/light/rogue/cauldron/attackby(obj/item/I, mob/user, params)
	if(istype(I,/obj/item/alch))
		if(ingredients.len >= maxingredients)
			to_chat(user, "<span class='warning'>再也装不下别的东西了。</span>")
			return FALSE
		if(!isnull(locate(I.type) in ingredients))
			to_chat(user, "<span class='warning'>[src]里已经有一份[I]了！这会毁了混合物的！</span>")
			return FALSE
		if(!user.transferItemToLoc(I,src))
			to_chat(user, "<span class='warning'>[I]粘在我手上了！</span>")
			return FALSE
		to_chat(user, "<span class='info'>我把[I]加入[src]。</span>")
		ingredients += I
		brewing = 0
		lastuser = user
		playsound(src, "bubbles", 100, TRUE)
		cut_overlays()
		var/mutable_appearance/filling = mutable_appearance(icon, "cauldron_boiling")
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		add_overlay(filling)
		sleep(30)
		update_icon()
		return TRUE
	..()

/obj/machinery/light/rogue/cauldron/attack_hand(mob/user, params)
	if(on)
		if(ingredients.len)
			to_chat(user, "<span class='warning'>正在炼制什么。</span>")
			return
		else
			to_chat(user, "<span class='info'>什么都没在炼。</span>")
			return
	else
		if(ingredients.len)
			var/obj/item/I = ingredients[ingredients.len]
			ingredients -= I
			I.loc = user.loc
			user.put_in_active_hand(I)
			user.visible_message("<span class='info'>[user]从[src]中取出[I]。</span>")
			return
		to_chat(user, "<span class='info'>它是空的。</span>")
		return ..()

/obj/machinery/light/rogue/cauldron/onkick(mob/user)
	if(ingredients.len)
		for(var/obj/item/in_caul in ingredients)
			ingredients -= in_caul
			in_caul.forceMove(get_turf(user))
	if(reagents)
		chem_splash(loc, 2, list(reagents))
		if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
			user.visible_message("<span class='info'>[user]用尾巴猛击[src]，里面的东西洒了一地！</span>")
		else
			user.visible_message("<span class='info'>[user]踢翻了[src]，里面的东西洒了一地！</span>")
	playsound(src, 'sound/items/beartrap2.ogg', 100, FALSE)
	return ..()

/obj/machinery/light/rogue/cauldron/folding
	name = "折叠炼药锅"
	desc = "咕嘟咕嘟，辛劳与烦恼。一口适合炼制魔药的大号便携青铜锅。"
	icon = 'icons/roguetown/misc/gadgets.dmi'
	icon_state = "FoldingCauldronDeployed1"
	base_state = "FoldingCauldronDeployed"
	maxingredients = 3 //-1
	waterneed = 60
	fueluse = 2 MINUTES 

/obj/machinery/light/rogue/cauldron/folding/examine()
	. = ..()
	. += span_blue("右键折叠炼药锅。请先清空它。")

/obj/machinery/light/rogue/cauldron/folding/attack_right(mob/user)
	if(do_after(user, 5 SECONDS, target = src))
		user.visible_message(span_notice("[user]折叠了[src]。"), span_notice("我折叠了[src]。"))
		new /obj/item/folding_table_stored/alchcauldron(drop_location())
		qdel(src)
		return ..()
	return

/obj/machinery/light/rogue/cauldron/folding/Initialize(mapload)
	. = ..()
	burn_out()
	create_reagents(60, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE) //small
	update_icon()
