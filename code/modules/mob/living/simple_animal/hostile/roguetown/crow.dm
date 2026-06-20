/obj/item/reagent_containers/food/snacks/crow
	name = "扎德"
	desc = "一种常与涅克拉关联的黑鸟。它们曾被训练用于传递消息并因其聪明而受到尊敬，但如今却被视为与害虫无异。"
	icon_state = "crow"
	icon = 'icons/roguetown/mob/monster/crow.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	foodtype = RAW
	verb_say = "吱吱叫"
	verb_yell = "吱吱叫"
	obj_flags = CAN_BE_HIT
	var/dead = FALSE
	eat_effect = /datum/status_effect/debuff/uncookedfood
	fried_type = null
	max_integrity = 10
	sellprice = 0
	blade_dulling = DULLING_CUT
	rotprocess = null
	static_debris = list(/obj/item/natural/feather=1)
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/friedcrow

/obj/item/reagent_containers/food/snacks/rogue/friedcrow
	name = "油炸扎德"
	desc = "拔掉所有羽毛费了些功夫，但最终还是成功了。结果是一份出奇酥脆、即便寡淡的小食。"
	icon = 'icons/roguetown/items/food.dmi'
	icon_state = "fcrow"
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("焦肉" = 1)
	eat_effect = null
	rotprocess = SHELFLIFE_SHORT
	sellprice = 0

/obj/item/reagent_containers/food/snacks/crow/burning(input as num)
	. = ..()
	if(!dead)
		if(burning >= burntime)
			dead = TRUE
			playsound(src, 'sound/vo/mobs/rat/rat_death.ogg', 100, FALSE, -1)
			icon_state = "[icon_state]1"

/obj/item/reagent_containers/food/snacks/crow/dead
	dead = TRUE
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/crow/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	if(dead)
		icon_state = "[icon_state]l"

/obj/item/reagent_containers/food/snacks/crow/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(dead)
		..()
	else
		if(isliving(user))
			var/mob/living/L = user
			if(prob(L.STASPD * 2))
				..()
			else
				if(isturf(loc))
					to_chat(user, span_warning("我没能抓住[src]！"))
					playsound(src, 'sound/vo/mobs/bird/birdfly.ogg', 100, TRUE, -1)
					qdel(src)
					return
	..()

/obj/item/reagent_containers/food/snacks/crow/process()
	..()
	if(dead)
		return
	if(!isturf(loc)) //no floating out of bags
		return
	if(prob(8))
		playsound(src, pick('sound/vo/mobs/bird/CROW_01.ogg','sound/vo/mobs/bird/CROW_02.ogg','sound/vo/mobs/bird/CROW_03.ogg'), 100, TRUE, -1)

/obj/item/reagent_containers/food/snacks/crow/obj_destruction(damage_flag)
	//..()
	if(!dead)
		dead = TRUE
		playsound(src, 'sound/vo/mobs/rat/rat_death.ogg', 100, FALSE, -1)
		icon_state = "[icon_state]1"
		rotprocess = SHELFLIFE_SHORT
		return 1
	. = ..()

/obj/item/reagent_containers/food/snacks/crow/Crossed(mob/living/L)
	. = ..()
	if(!dead)
		playsound(src, 'sound/vo/mobs/bird/birdfly.ogg', 100, TRUE, -1)
		qdel(src)


/obj/item/reagent_containers/food/snacks/crow/attackby(obj/item/I, mob/user, params)
	if(!dead)
		if(isliving(user) && isturf(loc))
			var/mob/living/L = user
			if(prob(L.STASPD * 2))
				..()
			else
				to_chat(user, span_warning("[src]逃走了！"))
				playsound(src, 'sound/vo/mobs/bird/birdfly.ogg', 100, TRUE, -1)
				qdel(src)
				return
	..()
