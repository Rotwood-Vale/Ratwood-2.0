/obj/effect/proc_holder/spell/targeted/shapeshift/dendormole
	name = "借来之力"
	desc = "更高位的力量降临于你，使你得以化作登多尔的特异圣兽。"
	invocations = list("鲜血将滋养花朵！")
	invocation_type = "shout"
	overlay_state = "tamebeast"
	human_req = FALSE
	range = -1
	include_user = TRUE
	recharge_time = 120 SECONDS // cause too little is cheaty, too much is pain
	cooldown_min = 50
	action_icon_state = "shapeshift"
	associated_skill = /datum/skill/magic/druidic
	chargetime = 5 SECONDS
	devotion_cost = 200

/obj/effect/proc_holder/spell/targeted/shapeshift/dendormole/cast(list/targets, mob/user = usr)
	// Use wildshape transformation system instead of shapeshift
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		return
	
	// If already in dendormole form, revert back to human
	if(istype(H, /mob/living/carbon/human/species/wildshape/dendormole))
		H.wildshape_untransform()
		return TRUE
	
	// Otherwise transform into dendormole
	H.wildshape_transformation(/mob/living/carbon/human/species/wildshape/dendormole)
	return TRUE

/obj/effect/proc_holder/spell/targeted/shapeshift/mireboi
	name = "匍行者形态"
	desc = "由德鲁伊自登多尔疯狂深林中求得的稀有力量，可使你化作敏捷的蛛形异兽。"
	invocations = list("织网，疾爬！")
	invocation_type = "shout"
	overlay_state = "tamebeast"
	human_req = FALSE
	range = -1
	include_user = TRUE
	recharge_time = 60 SECONDS
	cooldown_min = 60
	action_icon_state = "shapeshift"
	associated_skill = /datum/skill/magic/holy
	chargetime = 10 SECONDS
	devotion_cost = 100

/obj/effect/proc_holder/spell/targeted/shapeshift/mireboi/cast(list/targets, mob/user = usr)
	// Use wildshape transformation system instead of shapeshift
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		return
	
	// If already in mirecrawler form, revert back to human
	if(istype(H, /mob/living/carbon/human/species/wildshape/mirecrawler))
		H.wildshape_untransform()
		return TRUE
	
	// Otherwise transform into mirecrawler
	H.wildshape_transformation(/mob/living/carbon/human/species/wildshape/mirecrawler)
	return TRUE
