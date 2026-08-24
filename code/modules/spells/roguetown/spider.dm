
/obj/effect/proc_holder/spell/targeted/spiderconjur
	name = "Conjure Web"
	range = 8
	overlay_state = "null"
	releasedrain = 5
	recharge_time = 30
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/webspin.ogg'
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/targeted/spiderconjur/cast(list/targets,mob/user = usr)
	. = ..()
	if(isopenturf(user.loc))
		var/turf/open/T = user.loc
		var/foundwall
		for(var/X in GLOB.cardinals)
			var/turf/TU = get_step(T, X)
			if(TU && isclosedturf(TU))
				foundwall = TRUE
				break
		if(foundwall)
			if(!locate(/obj/structure/spider/stickyweb) in T)
				new /obj/structure/spider/stickyweb(T)
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/self/spin_web_thin
	name = "Spin Thin Web"
	desc = "Spin a translucent web on your current location."
	overlay_icon = 'icons/mob/actions/roguespells.dmi'
	overlay_state = "webthin"
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	ignore_cockblock = TRUE
	sound = 'sound/misc/nutriment.ogg'

/obj/effect/proc_holder/spell/self/spin_web_thin/cast(mob/living/user)
	var/turf/web_turf = get_turf(user)
	if(!isopenturf(web_turf))
		return TRUE
	user.visible_message(span_notice("[user] begins spinning a thin web."))
	if(!do_after(user, 4 SECONDS, target = user, progress = TRUE))
		revert_cast(user)
		return FALSE
	if(locate(/obj/structure/spider/stickyweb) in web_turf)
		return TRUE
	user.stamina_add(30)
	new /obj/structure/spider/stickyweb/thin(web_turf)
	return TRUE

/obj/effect/proc_holder/spell/self/spin_web_dense
	name = "Spin Dense Web"
	desc = "Spin a thick, opaque web on your current location."
	overlay_icon = 'icons/mob/actions/roguespells.dmi'
	overlay_state = "webdense"
	antimagic_allowed = TRUE
	recharge_time = 30 SECONDS
	ignore_cockblock = TRUE
	sound = 'sound/misc/nutriment.ogg'

/obj/effect/proc_holder/spell/self/spin_web_dense/cast(mob/living/user)
	var/turf/web_turf = get_turf(user)
	if(!isopenturf(web_turf))
		return TRUE
	user.visible_message(span_notice("[user] begins spinning a dense web."))
	if(!do_after(user, 8 SECONDS, target = user, progress = TRUE))
		revert_cast(user)
		return FALSE
	if(locate(/obj/structure/spider/stickyweb) in web_turf)
		return TRUE
	user.stamina_add(60)
	new /obj/structure/spider/stickyweb/thick(web_turf)
	return TRUE
