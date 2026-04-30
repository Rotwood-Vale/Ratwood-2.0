// ——————————————————————————————————
// GABAGOOL
// The finest cured meat the Underbelly can source. Likely stolen from some Etruscan wise-guy.
// ——————————————————————————————————

/datum/status_effect/buff/stellarfood
	id = "stellarfood"
	alert_type = /atom/movable/screen/alert/status_effect/buff/stellarfood
	effectedstats = list(STATKEY_LCK = 1, STATKEY_SPD = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/stellarfood
	name = "Stellar Food!"
	desc = "A bite of something truly special. Xylix smiles, and my step feels lighter."
	icon_state = "foodbuff"

/datum/status_effect/buff/stellarfood/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/stellarfood)
	if(owner.has_status_effect(/datum/status_effect/buff/mealbuff))
		owner.remove_status_effect(/datum/status_effect/buff/mealbuff)
	if(owner.has_status_effect(/datum/status_effect/buff/greatmealbuff))
		owner.remove_status_effect(/datum/status_effect/buff/greatmealbuff)

/datum/stressevent/stellarfood
	timer = 20 MINUTES
	stressadd = -3
	desc = list(span_green("That was a meal fit for kings"), span_green("Gabagool, baby. Nothing better."))

/obj/item/reagent_containers/food/snacks/rogue/meat/gabagool
	name = "capocollo"
	desc = "A dense, fragrant cured meat of Etruscan origin. Its smell alone is worth a fat stack of gold coins. The finest, most delicately cured meat available around Grimoria. Wise guys in the Underbelly call it Gabagool, for some reason."
	icon = 'modular_underbelly/sprites/gabagool.dmi'
	icon_state = "gabagool"
	list_reagents = list(/datum/reagent/consumable/nutriment = 80)
	tastes = list("cured meat" = 2, "spice" = 1)
	foodtype = MEAT
	faretype = FARE_LAVISH
	bitesize = 8
	slices_num = 8
	slice_batch = FALSE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/gabagool/slice
	rotprocess = SHELFLIFE_LONG
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/stellarfood
	warming = 15 MINUTES
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	become_rot_type = /obj/item/reagent_containers/food/snacks/rogue/meat/gabaghoul

/obj/item/reagent_containers/food/snacks/rogue/meat/gabagool/update_icon()
	if(slices_num >= 6)
		icon_state = "gabagool_1"
	else if(slices_num >= 3)
		icon_state = "gabagool_2"
	else if(slices_num > 0)
		icon_state = "gabagool_3"
	else
		icon_state = "gabagool_slice"

/obj/item/reagent_containers/food/snacks/rogue/meat/gabagool/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 4)
			slices_num = 5
		if(bitecount == 7)
			slices_num = 2
		if(bitecount == 10)
			changefood(slice_path, eater)
	update_icon()

/obj/item/reagent_containers/food/snacks/rogue/meat/gabagool/slice
	name = "capocollo slice"
	desc = "A precious slice of capocollo. A delicacy and delight in every bite."
	icon_state = "gabagool_slice"
	slices_num = 0
	slice_path = null
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	bitesize = 4
	faretype = FARE_LAVISH
	eat_effect = /datum/status_effect/buff/stellarfood

// ——————————————————————————————————
// GABAGHOUL - if i ever see one of you motherfuckers with this item im gonna ban you.
// ——————————————————————————————————

/obj/item/reagent_containers/food/snacks/rogue/meat/gabaghoul
	name = "gabaghoul"
	desc = "WHAT HAVE YOU DONE?!?!?!"
	icon = 'modular_underbelly/sprites/gabaghoul.dmi'
	icon_state = "gabaghoul"
	foodtype = MEAT
	faretype = FARE_IMPOVERISHED
	bitesize = 8
	slices_num = 8
	slice_batch = FALSE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/gabaghoul/slice
	rotprocess = null
	slice_sound = TRUE
	eat_effect = /datum/status_effect/debuff/rotfood
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/obj/item/reagent_containers/food/snacks/rogue/meat/gabaghoul/update_icon()
	if(slices_num >= 6)
		icon_state = "gabaghoul_1"
	else if(slices_num >= 3)
		icon_state = "gabaghoul_2"
	else if(slices_num > 0)
		icon_state = "gabaghoul_3"
	else
		icon_state = "gabaghoul_slice"

/obj/item/reagent_containers/food/snacks/rogue/meat/gabaghoul/slice
	name = "gabaghoul slice"
	desc = "A slice of gabaghoul. It stares back."
	icon_state = "gabaghoul_slice"
	slices_num = 0
	slice_path = null
	bitesize = 4
	faretype = FARE_IMPOVERISHED
	eat_effect = /datum/status_effect/debuff/rotfood
