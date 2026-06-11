/datum/reagent/toxin/spidervenom_inert
	name = "惰性阿拉格精华"
	description = "离开蜘蛛本体后，这份毒液已经衰弱。必须先用结合催化剂将其强化。"
	silent_toxin = TRUE
	reagent_state = SOLID
	color = "#003d99"
	toxpwr = 0
	taste_description = "蓝莓"
	metabolization_rate = 10
	var/venom_resistance

/obj/item/reagent_containers/spidervenom_inert
	list_reagents = list(/datum/reagent/toxin/spidervenom_inert = 10)
	name = "苍白蛛腺"
	desc = "一团软塌塌的苍白腺体，里面灌满了致命阿拉格蜘蛛的毒液。摸起来冷冰冰的。"
	icon = 'modular/Mapping/icons/webbing.dmi'
	icon_state = "gland"

/datum/reagent/toxin/spidervenom_paralytic
	name = "阿拉格精华"
	description = "一种强力神经毒素，会让肌肉僵硬并抽搐。"
	silent_toxin = TRUE
	reagent_state = SOLID
	color = "#99005e"
	toxpwr = 0
	taste_description = "覆盆子"
	metabolization_rate = 0.01
	var/venom_resistance

/obj/item/reagent_containers/glass/bottle/alchemical/spidervenom_paralytic
	list_reagents = list(/datum/reagent/toxin/spidervenom_paralytic = 1)
	desc = "一个不祥的小瓶，里面装满了致命阿拉格蜘蛛的毒液。摸起来有些发热。"

/datum/reagent/toxin/spidervenom_paralytic/on_mob_metabolize(mob/living/L)
	..()
	venom_resistance += ((L.STACON - 10) * 5)
	venom_resistance += ((L.STAWIL - 10) * 3)
	venom_resistance += ((L.STASTR - 10) * 2)
	venom_resistance += (L.STALUC)
	
	if(venom_resistance <= 0)
		venom_resistance = 0
		venom_resistance += (L.STALUC * 5)

/datum/reagent/toxin/spidervenom_paralytic/on_mob_end_metabolize(mob/living/L)
	..()

/datum/reagent/toxin/spidervenom_paralytic/on_mob_life(mob/living/carbon/M)
	..()
	if(!(current_cycle % 5) && !(prob(venom_resistance / 5)))
		M.Paralyze(50)
	if(current_cycle >= 60 && !(current_cycle % 5) && prob(venom_resistance))
		M.reagents.remove_reagent(/datum/reagent/toxin/spidervenom_paralytic, 100)
