/obj/item/reagent_containers/lux
	name = "灵辉"
	desc = "生命与灵魂之物，从一个大概自愿的供体体内取出。它有点湿黏又软塌塌的，像半熟的煎蛋。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux"
	item_state = "lux"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/vitae = 5)
	grind_results = list(/datum/reagent/vitae = 5)
	sellprice = 100
	dropshrink = 0.7

/datum/reagent/vitae
	name = "命髓"
	description = "提取并加工后的生命精华。"
	color = "#7d8e98" // rgb: 96, 165, 132
	overdose_threshold = 10
	metabolization_rate = 0.1

/datum/reagent/vitae/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, 0.25*REM)
	M.adjustFireLoss(0.25*REM, 0)
	..()
	. = 1

/datum/reagent/vitae/on_mob_life(mob/living/carbon/M)
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/vitae)
	..()

/obj/item/reagent_containers/lux_impure
	name = "不纯灵辉"
	desc = "生命与灵魂之物，从一个大概自愿的供体体内取出。它令人不安且不纯净，需要净化。"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux_impure"
	item_state = "lux_impure"
	sellprice = 15
	dropshrink = 0.7
