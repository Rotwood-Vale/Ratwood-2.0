/obj/machinery/light/rogue/cauldron
	name = "cauldron"
	desc = "Bubble, Bubble, toil and trouble. A great iron cauldron for brewing potions. Kick it to spill the contents, or add ingredients to brew potions!"
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "cauldron1"
	base_state = "cauldron"
	density = TRUE
	opacity = FALSE
	anchored = TRUE
	max_integrity = 300
	var/list/ingredients = list()
	var/list/pending_batches = list()
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
	create_reagents(240, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE)
	. = ..()

/obj/machinery/light/rogue/cauldron/Destroy()
	chem_splash(loc, 2, list(reagents))
	qdel(reagents)
	..()

/obj/machinery/light/rogue/cauldron/burn_out()
	brewing = 0
	pending_batches = list()
	..()

/obj/machinery/light/rogue/cauldron/proc/resolve_batch(list/batch_ings)
	var/list/outcomes = list()
	for(var/obj/item/ing in batch_ings)
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
	var/amt2raise = lastuser?.STAINT*2
	if(outcomes.len && (outcomes[outcomes[1]] >= 5))
		var/result_path = outcomes[1]
		var/datum/alch_cauldron_recipe/found_recipe = new result_path
		var/required_base = found_recipe.required_base_reagent
		var/in_cauldron = 0
		for(var/datum/reagent/R in reagents.reagent_list)
			if(istype(R, required_base))
				in_cauldron += R.volume
		in_cauldron = round(in_cauldron, 0.01)
		if(in_cauldron < found_recipe.required_base_amount)
			visible_message(span_warning("The mixture demands a different base liquid — the ingredients refuse to combine!"))
			var/wrong_amt = 0
			for(var/datum/reagent/R in reagents.reagent_list)
				if(istype(R, /datum/reagent/water) || istype(R, /datum/reagent/blood))
					wrong_amt += R.volume
			wrong_amt = round(wrong_amt, 0.01)
			if(reagents && wrong_amt > 0)
				reagents.remove_all_type(/datum/reagent/water, wrong_amt, strict=0)
				reagents.remove_all_type(/datum/reagent/blood, wrong_amt, strict=0)
			for(var/obj/item/ing in batch_ings)
				qdel(ing)
			reagents.add_reagent(/datum/reagent/yuck, max(wrong_amt, 1))
			lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
			qdel(found_recipe)
			return
		if(found_recipe.skill_required > lastuser?.get_skill_level(/datum/skill/craft/alchemy))
			visible_message(span_warning("The ingredients in the cauldron melds together into a disgusting mess! Perhaps a more skilled alchemist is needed for this recipe."))
			if(reagents)
				reagents.remove_all_type(required_base, in_cauldron, strict=0)
			for(var/obj/item/ing in batch_ings)
				qdel(ing)
			reagents.add_reagent(/datum/reagent/yuck, in_cauldron)
			lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
			return
		for(var/obj/item/ing in batch_ings)
			qdel(ing)
		if(reagents)
			reagents.remove_all_type(required_base, found_recipe.required_base_amount, strict=0)
		if(found_recipe.output_reagents.len)
			reagents.add_reagent_list(found_recipe.output_reagents)
		if(found_recipe.output_items.len)
			for(var/itempath in found_recipe.output_items)
				new itempath(get_turf(src))
		visible_message("<span class='info'>The cauldron finishes boiling with a faint [found_recipe.smells_like] smell.</span>")
		record_featured_stat(FEATURED_STATS_ALCHEMISTS, lastuser)
		record_round_statistic(STATS_POTIONS_BREWED)
		lastuser?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
		playsound(src, "bubbles", 100, TRUE)
		playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)
		qdel(found_recipe)
	else
		visible_message("<span class='info'>The ingredients in the [src] fail to meld together at all...</span>")
		playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)
		for(var/obj/item/ing in batch_ings)
			qdel(ing)

/obj/machinery/light/rogue/cauldron/MiddleClick(mob/user, params)
	. = ..()
	if(!user.Adjacent(src))
		return
	if(!on)
		to_chat(user, span_warning("The cauldron isn't lit."))
		return
	if(!ingredients.len)
		to_chat(user, span_warning("There is nothing to stir aside yet."))
		return
	if(user.get_skill_level(/datum/skill/craft/alchemy) < SKILL_LEVEL_MASTER)
		to_chat(user, span_warning("My hands move to stir, but I lack the mastery to mix these essences..."))
		return
	if(pending_batches.len)
		to_chat(user, span_warning("The cauldron can only hold two mixed recipes at once. Empty it first."))
		return
	pending_batches += list(ingredients.Copy())
	ingredients = list()
	brewing = 0
	user.visible_message(span_notice("[user] stirs [src] with practiced precision."), span_notice("I stir [src], mixing one recipe without affecting the next."))

/*
/obj/machinery/light/rogue/cauldron/examine(mob/user)
	if(ingredients.len)//ingredients.len
		DISABLE_BITFIELD(reagents.flags, AMOUNT_VISIBLE)
	else
		ENABLE_BITFIELD(reagents.flags, AMOUNT_VISIBLE)
	. = ..()
*/

/obj/machinery/light/rogue/cauldron/examine(mob/user)
	. = ..()
	if(!reagents || !reagents.total_volume)
		return
	if(!user.mind)
		return
	var/alch_skill = user.get_skill_level(/datum/skill/craft/alchemy)
	if(alch_skill < SKILL_LEVEL_APPRENTICE)
		return
	if(alch_skill >= SKILL_LEVEL_EXPERT || HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST))
		. += span_notice("My trained eye reads the cauldron's contents precisely:")
		var/list/rlist = reagents.reagent_list
		for(var/r_entry in rlist)
			var/datum/reagent/R = r_entry
			. += span_notice(" - [R.name]: [R.volume] units")
		if(pending_batches.len)
			for(var/i in 1 to pending_batches.len)
				. += span_notice("Stirred batch [i]:")
				for(var/obj/item/ing in pending_batches[i])
					. += span_notice(" - [ing.name]")
		if(ingredients.len)
			. += span_notice("[pending_batches.len ? "Next batch:" : "Ingredients inside:"]")
			for(var/obj/item/ing in ingredients)
				. += span_notice(" - [ing.name]")
		return
	if(alch_skill >= SKILL_LEVEL_JOURNEYMAN)
		. += span_notice("I can smell the cauldron's contents:")
		var/list/rlist2 = reagents.reagent_list
		for(var/r_entry in rlist2)
			var/datum/reagent/R = r_entry
			. += span_notice(" - [R.name]")
		return
	if(alch_skill >= SKILL_LEVEL_APPRENTICE)
		var/datum/reagent/dominant
		var/list/rlist3 = reagents.reagent_list
		for(var/r_entry in rlist3)
			var/datum/reagent/R = r_entry
			if(!dominant || R.volume > dominant.volume)
				dominant = R
		if(dominant)
			. += span_notice("I can faintly smell [dominant.name] above all else in the cauldron.")

/obj/machinery/light/rogue/cauldron/process()
	..()
	update_icon()
	if(on)
		if(ingredients.len || pending_batches.len)
			if(brewing < 20)
				if(src.reagents.has_reagent(/datum/reagent/water, 120) || src.reagents.has_reagent(/datum/reagent/blood, 120))
					brewing++
					if(prob(10))
						playsound(src, "bubbles", 100, FALSE)
			else if(brewing == 20)
				if(!lastuser)
					brewing = 0
					src.visible_message(span_info("The cauldron can't brew anything without an alchemist to guide it."))
					return
				var/list/all_batches = pending_batches.Copy()
				if(ingredients.len)
					all_batches += list(ingredients.Copy())
				for(var/list/batch in all_batches)
					resolve_batch(batch)
				pending_batches = list()
				ingredients = list()
				brewing = 21

/obj/machinery/light/rogue/cauldron/attackby(obj/item/I, mob/user, params)
	if(istype(I,/obj/item/alch))
		if(ingredients.len >= maxingredients)
			to_chat(user, "<span class='warning'>Nothing else can fit.</span>")
			return FALSE
		if(!isnull(locate(I.type) in ingredients))
			to_chat(user, "<span class='warning'>There is already \a [I] in [src]! That would ruin the mixture!</span>")
			return FALSE
		if(!user.transferItemToLoc(I,src))
			to_chat(user, "<span class='warning'>[I] is stuck to my hand!</span>")
			return FALSE
		to_chat(user, "<span class='info'>I add [I] to [src].</span>")
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
		if(ingredients.len || pending_batches.len)
			to_chat(user, "<span class='warning'>Something's brewing.</span>")
			return
		else
			to_chat(user, "<span class='info'>Nothing's brewing.</span>")
			return
	else
		if(ingredients.len)
			var/obj/item/I = ingredients[ingredients.len]
			ingredients -= I
			I.loc = user.loc
			user.put_in_active_hand(I)
			user.visible_message("<span class='info'>[user] pulls [I] from [src].</span>")
			return
		to_chat(user, "<span class='info'>It's empty.</span>")
		return ..()

/obj/machinery/light/rogue/cauldron/onkick(mob/user)
	if(ingredients.len)
		for(var/obj/item/in_caul in ingredients)
			ingredients -= in_caul
			in_caul.forceMove(get_turf(user))
	if(reagents)
		chem_splash(loc, 2, list(reagents))
		if(HAS_TRAIT(user, TRAIT_LAMIAN_TAIL))
			user.visible_message("<span class='info'>[user] tailslams [src] over, spilling it's contents!</span>")
		else
			user.visible_message("<span class='info'>[user] kicks [src], spilling it's contents!</span>")
	playsound(src, 'sound/items/beartrap2.ogg', 100, FALSE)
	return ..()

/obj/machinery/light/rogue/cauldron/folding
	name = "folding cauldron"
	desc = "Bubble, Bubble, toil and trouble. A great protable bronze cauldron for brewing potions. Kick to spill the contents, or add ingredients to brew potions! Can be folded up and stored when not in use."
	icon = 'icons/roguetown/misc/gadgets.dmi'
	icon_state = "FoldingCauldronDeployed1"
	base_state = "FoldingCauldronDeployed"
	maxingredients = 3 //-1
	waterneed = 60
	fueluse = 2 MINUTES 

/obj/machinery/light/rogue/cauldron/folding/examine()
	. = ..()
	. += span_blue("Right-Click to fold the cauldron. Empty it first.")

/obj/machinery/light/rogue/cauldron/folding/attack_right(mob/user)
	if(do_after(user, 5 SECONDS, target = src))
		user.visible_message(span_notice("[user] folds [src]."), span_notice("You fold [src]."))
		new /obj/item/folding_table_stored/alchcauldron(drop_location())
		qdel(src)
		return ..()
	return

/obj/machinery/light/rogue/cauldron/folding/Initialize(mapload)
	. = ..()
	burn_out()
	create_reagents(120, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE)
	update_icon()
