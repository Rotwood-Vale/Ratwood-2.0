/obj/item/pestle
	name = "研杵"
	desc = "一种小巧的、圆头石制工具，常被医师用来捣碎和混合药物。"
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "pestle"
	force = 7
	dropshrink = 0.9
	experimental_inhand = FALSE

	grid_width = 64
	grid_height = 32

//==============================================================================
// Druidic crafting recipes — appear under the "Druidic Trickery" tab in the
// crafting window whenever the player has the required skill-level.
//==============================================================================
/datum/crafting_recipe/roguetown/druidic
	abstract_type = /datum/crafting_recipe/roguetown/druidic
	req_table = FALSE
	always_availible = TRUE      // shows for anyone who has the ingredients; craftdiff gates who can actually make it
	skillcraft = /datum/skill/magic/druidic
	subtype_reqs = FALSE
	verbage_simple = "制备"
	verbage = "制备"
	craftsound = 'sound/foley/mortarpestle.ogg'

/datum/crafting_recipe/roguetown/druidic/blessedseedpowder
	name = "祝圣种子粉"
	result = list(/obj/item/alch/blessedseedpowder)
	reqs = list(
		/obj/item/seeds/treesap = 1,
		/datum/reagent/water/blessed = 10,
	)
	tools = list(/obj/item/pestle = 1)
	craftdiff = SKILL_LEVEL_NOVICE
	time = 2 SECONDS
	craft_xp_override = 5

/obj/item/reagent_containers/glass/mortar
	name = "炼金研钵"
	desc = "一个用于研磨物品的小型厚壁石碗。"
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "mortar"
	dropshrink = 0.75
	amount_per_transfer_from_this = 9
	volume = 100
	experimental_inhand = FALSE
	reagent_flags = OPENCONTAINER|REFILLABLE|DRAINABLE
	spillable = TRUE
	var/obj/item/to_grind

	grid_width = 64
	grid_height = 32

/obj/item/reagent_containers/glass/mortar/examine()
	. += ..()
	if(to_grind)
		. += ("[to_grind]在研钵里。")
	. += span_notice("使用研杵左键点击可将内部物品研磨成炼金材料。使用研杵中键点击可研磨或榨汁。右键点击可将其取出。")

/obj/item/reagent_containers/glass/mortar/attack_right(mob/user)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(to_grind)
		to_chat(user, "<span class='notice'>我从研钵中取出了[to_grind]。</span>")
		if(!user.put_in_hands(to_grind))
			to_chat(user, span_warning("我的手满了！我把[to_grind]掉在了地上。"))
		to_grind = null
		return
	to_chat(user, "<span class='notice'>它是空的。</span>")

/obj/item/reagent_containers/glass/mortar/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/pestle = H.get_active_held_item()
	if(!istype(pestle, /obj/item/pestle))
		to_chat(user, "<span class='warning'>你需要一根研杵来研磨！</span>")
		return
	if(!to_grind)
		to_chat(user, "<span class='warning'>没有什么可研磨的。</span>")
		return
	if((!to_grind.juice_results && !to_grind?.grind_results?.len)) // A lot of reagents are grindable but empty
		to_chat(user, "<span class='warning'>你觉得那不会有效！</span>")
		return
	if(to_grind.juice_results) //prioritize juicing
		to_grind.on_juice()
		reagents.add_reagent_list(to_grind.juice_results)
		to_chat(user, span_notice("我把[to_grind]榨成了细腻的汁液。"))
		if(to_grind.reagents) //food and pills
			to_grind.reagents.trans_to(src, to_grind.reagents.total_volume, transfered_by = user)
			onfill(to_grind, user, silent = FALSE)
		QDEL_NULL(to_grind)
		return
	if(to_grind.grind_results.len) // grind, if there's a grind result
		to_grind.on_grind()
		reagents.add_reagent_list(to_grind.grind_results)
		to_chat(user, span_notice("我把[to_grind]磨成了粉末。"))
		QDEL_NULL(to_grind)
		return

/obj/item/reagent_containers/glass/mortar/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I,/obj/item/pestle))
		if(!to_grind)
			to_chat(user, "<span class='warning'>没有什么可研磨的。</span>")
			return
		if((to_grind.type == /obj/item/seeds/treesap) && reagents.get_reagent_amount(/datum/reagent/water/blessed) >= 10)
			if(!ishuman(user) || user.get_skill_level(/datum/skill/magic/druidic) < SKILL_LEVEL_NOVICE)
				to_chat(user, span_warning("我缺乏德鲁伊的知识，无法从这些种子中提取 登多尔 的祝福。"))
				return
			user.visible_message(span_info("[user]将[to_grind]研磨进圣水，提取出 登多尔 的祝福。"))
			playsound(loc, 'sound/foley/mortarpestle.ogg', 100, FALSE)
			if(do_after(user, 10, target = src))
				reagents.remove_reagent(/datum/reagent/water/blessed, 10)
				new /obj/item/alch/blessedseedpowder(get_turf(src))
				QDEL_NULL(to_grind)
				to_chat(user, span_notice("种子吸收了 登多尔 的祝福，形成了发光粉末。"))
				if(user.mind)
					user.mind.add_sleep_experience(/datum/skill/magic/druidic, 5)
			return
		var/datum/alch_grind_recipe/foundrecipe = find_recipe()
		if(foundrecipe == null)
			to_chat(user, "<span class='warning'>你觉得那不会有效！</span>")
			return
		user.visible_message("<span class='info'>[user]开始研磨[to_grind]。</span>")
		playsound(loc, 'sound/foley/mortarpestle.ogg', 100, FALSE)
		if(do_after(user, 10, target = src))
			user.log_message("ground [to_grind] into [english_list(foundrecipe.valid_outputs, "nothing")] with [src]", LOG_GAME)
			for(var/output in foundrecipe.valid_outputs)
				for(var/i in 1 to foundrecipe.valid_outputs[output])
					new output(get_turf(src))
			if(foundrecipe.bonus_chance_outputs.len > 0)
				for(var/bonus_output in foundrecipe.bonus_chance_outputs)
					var/base_chance = foundrecipe.bonus_chance_outputs[bonus_output]
					var/final_chance = foundrecipe.get_bonus_output_chance(bonus_output, user, base_chance)
					if(final_chance >= roll(1, 100))
						new bonus_output(get_turf(user))
			if(istype(to_grind,/obj/item/rogueore) || istype(to_grind,/obj/item/ingot))
				user.flash_fullscreen("whiteflash")
				var/datum/effect_system/spark_spread/S = new()
				var/turf/front = get_turf(src)
				S.set_up(1, 1, front)
				S.start()
			QDEL_NULL(to_grind)
			if(user.mind)
				user.adjust_experience(/datum/skill/craft/alchemy, user.STAINT, FALSE)
			return
	if(istype(I ,/obj/item/reagent_containers/glass))
		if(user.used_intent.type == INTENT_POUR) //Something like a glass. Player probably wants to transfer TO it.
			testing("attackobj2")
			if(!I.reagents.total_volume)
				to_chat(user, span_warning("[I]是空的！"))
				return

			if(reagents.holder_full())
				to_chat(user, span_warning("[src]已满。"))
				return
			user.visible_message(span_notice("[user]把[I]倒入[src]。"), \
							span_notice("我把[I]倒入[src]。"))
			if(user.m_intent != MOVE_INTENT_SNEAK)
				if(poursounds)
					playsound(user.loc,pick(poursounds), 100, TRUE)
			for(var/i in 1 to 10)
				if(do_after(user, 8, target = src))
					if(!I.reagents.total_volume)
						break
					if(reagents.holder_full())
						break
					if(!I.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user))
						reagents.reaction(src, TOUCH, amount_per_transfer_from_this)
					onfill(I, user, silent = TRUE)
				else
					break
			return

		if(is_drainable() && (user.used_intent.type == /datum/intent/fill)) //A dispenser. Transfer FROM it TO us.
			testing("attackobj3")
			if(!reagents.total_volume)
				to_chat(user, span_warning("[src]是空的！"))
				return

			if(I.reagents.holder_full())
				to_chat(user, span_warning("[I]已满。"))
				return
			if(user.m_intent != MOVE_INTENT_SNEAK)
				if(fillsounds)
					playsound(user.loc,pick(fillsounds), 100, TRUE)
			user.visible_message(span_notice("[user]用[src]装满了[I]。"), \
								span_notice("我用[src]装满了[I]。"))
			for(var/i in 1 to 10)
				if(do_after(user, 8, target = src))
					if(I.reagents.holder_full())
						break
					if(!reagents.total_volume)
						break
					reagents.trans_to(I, amount_per_transfer_from_this, transfered_by = user)
				else
					break

			return
	if(to_grind)
		to_chat(user, "<span class='warning'>[src]已满！</span>")
		return
	var/recipe = find_recipe(I)
	if(recipe == null && I.grind_results == null && I.juice_results == null)
		to_chat(user, "<span class='warning'>[I]不能被研磨！！</span>")
		return
	if(!user.transferItemToLoc(I,src))
		to_chat(user, "<span class='warning'>[I]粘在我手上了！</span>")
		return
	if(!istype(I,/obj/item/pestle) && !to_grind && user.transferItemToLoc(I,src))
		to_chat(user, "<span class='info'>我把[I]加入到[src]中。</span>")
		to_grind = I
		return
	..()

///Looks through all the alch grind recipes to find what it should create, returns the correct one.
/obj/item/reagent_containers/glass/mortar/proc/find_recipe(obj/item/check_item = to_grind)
	for(var/datum/alch_grind_recipe/grindRec in GLOB.alch_grind_recipes)
		if(grindRec.picky)
			if(check_item.type == grindRec.valid_input)
				return grindRec
		else
			if(istype(check_item,grindRec.valid_input))
				return grindRec
	return null
