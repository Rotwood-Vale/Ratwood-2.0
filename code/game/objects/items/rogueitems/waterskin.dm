/obj/item/reagent_containers/glass/bottle/waterskin
	name = "水袋"
	desc = "一个皮制水袋。"
	icon_state = "waterskin"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10)
	volume = 75 // 3 cups
	dropshrink = 1
	sellprice = 10
	closed = FALSE
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	obj_flags = CAN_BE_HIT
	reagent_flags = OPENCONTAINER
	w_class =  WEIGHT_CLASS_NORMAL
	drinksounds = list('sound/items/drink_bottle (1).ogg','sound/items/drink_bottle (2).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	poursounds = list('sound/items/fillbottle.ogg')
	sewrepair = TRUE
	desc_uncorked = "一个皮制水袋。袋口的盖子已打开。"

/obj/item/reagent_containers/glass/bottle/waterskin/milk // Filled subtype used by the cheesemaker
	list_reagents = list(/datum/reagent/consumable/milk = 64)

/obj/item/reagent_containers/glass/bottle/waterskin/purifier
	name = "净水水袋"
	desc = "青铜管沿着这只水袋的袋口盘旋延展，构成复杂而令人目眩的图样。"
	icon_state = "water-purifier"
	desc_uncorked = "青铜管沿着这只水袋的袋口盘旋延展，构成复杂而令人目眩的图样。袋口的盖子已打开。"
	var/filtered_reagents = list(/datum/reagent/water/gross) // List of liquids it turns into drinkable water

/obj/item/reagent_containers/glass/bottle/waterskin/purifier/onfill(obj/target, mob/user, silent = FALSE)
	. = ..()
	cleanwater(user, silent)

/obj/item/reagent_containers/glass/bottle/waterskin/purifier/proc/cleanwater(mob/living/carbon/human/user, silent = FALSE)
	// If there is dirty water inside the device, clean it!
	if (hasdirtywater())
		for (var/datum/reagent/R in reagents.reagent_list)
			if(R.type in filtered_reagents)
				var/amt2clean = reagents.get_reagent_amount(R.type)
				reagents.remove_all_type(R, amt2clean)
				reagents.add_reagent(/datum/reagent/water, amt2clean)
		if (!silent)
			playsound(user, 'sound/items/waterfilter.ogg', 40, TRUE)
			to_chat(user, span_hear("我听见[src]内部传来发条嗡鸣与水流咕噜声。"))
			if (prob(25))
				new /obj/effect/temp_visual/small_smoke(user.loc)
				user.visible_message(span_notice("一团蒸汽短暂笼罩了[user]！"), span_notice("装置噼啪作响，喷出一团蒸汽。" + span_warning(" 真烦人！")))


/obj/item/reagent_containers/glass/bottle/waterskin/purifier/proc/hasdirtywater()
	for (var/datum/reagent/R in reagents.reagent_list)
		if(R.type in filtered_reagents)
			return TRUE
	return FALSE

/obj/item/reagent_containers/glass/bottle/waterskin/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum, do_splash = TRUE)
	return
