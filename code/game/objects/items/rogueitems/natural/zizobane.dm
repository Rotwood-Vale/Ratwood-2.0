/obj/structure/zizo_bane
	name = "齐佐祸根"
	desc = "一种生长在腐败之地的小型紫色蘑菇。"
	icon = 'icons/obj/flora/rogueflora.dmi'
	icon_state = "zizo_bane"
	density = FALSE
	anchored= TRUE
	var/time_delay = 0

/obj/structure/zizo_bane/Initialize(mapload)
	. = ..()
	var/matrix/M = matrix()
	M.Scale(0.6, 0.6)
	transform = M

/obj/structure/zizo_bane/Crossed(atom/movable/arrived)
	if(time_delay < world.time)
		if(isliving(arrived))
			make_gas()
			time_delay = world.time + 20 SECONDS

/obj/structure/zizo_bane/proc/make_gas()
	visible_message(span_warn("[src]猛地喷出一团孢子云！"))
	var/datum/effect_system/smoke_spread/zizosleep/S = new
	playsound(get_turf(src), "sound/items/mushroom_step.ogg", 100)
	S.set_up(2, loc)
	S.start()

/obj/structure/zizo_bane/attack_hand(mob/living/carbon/human/user)
	playsound(src.loc, "plantcross", 80, FALSE, -1)
	user.visible_message(span_warning("[user]开始把[src]从土里拔出来。"))
	if(do_after(user, 3 SECONDS, target = src))
		var/obj/item/reagent_containers/food/snacks/zizo_bane/z =  new /obj/item/reagent_containers/food/snacks/zizo_bane/ (get_turf(src))
		user.put_in_active_hand(z)
		qdel(src)
	
/obj/item/reagent_containers/food/snacks/zizo_bane
	name = "齐佐祸根"
	desc = "一种生长在腐败之地的小型紫色蘑菇。"
	icon = 'icons/obj/flora/rogueflora.dmi'
	icon_state = "zizo_bane"
	filling_color = "#772681"
	bitesize = 1
	foodtype = VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/sleep_powder = 5)
	tastes = list("麻痹般的薄荷味" = 1,"紫色怪味" = 1)
	eat_effect = /datum/status_effect/debuff/knockout
	mill_result = /obj/item/reagent_containers/powder/sleep_powder
	grind_results = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/sleep_powder = 5)
	rotprocess = 30 MINUTES
