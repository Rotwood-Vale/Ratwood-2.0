
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

/obj/effect/proc_holder/spell/self/spin_web
	antimagic_allowed = TRUE
	ignore_cockblock = TRUE
	sound = 'sound/misc/nutriment.ogg'
	overlay_icon = 'icons/mob/actions/roguespells.dmi'
	var/web_type = /obj/structure/spider/stickyweb/thin
	var/spin_time = 4 SECONDS
	var/stamina_cost = 30
	var/web_name = "thin web"

/obj/effect/proc_holder/spell/self/spin_web/cast(mob/living/user)
	var/turf/web_turf = get_turf(user)
	if(!isopenturf(web_turf))
		return TRUE
	user.visible_message(span_notice("[user] begins spinning a [web_name]."))
	if(!do_after(user, spin_time, target = user, progress = TRUE))
		revert_cast(user)
		return FALSE
	if(locate(/obj/structure/spider/stickyweb) in web_turf)
		return TRUE
	user.stamina_add(stamina_cost)
	new web_type(web_turf)
	return TRUE

/obj/effect/proc_holder/spell/self/spin_web/thin
	name = "Spin Thin Web"
	desc = "Spin a translucent web on your current location."
	overlay_state = "webthin"
	recharge_time = 15 SECONDS

/obj/effect/proc_holder/spell/self/spin_web/dense
	name = "Spin Dense Web"
	desc = "Spin a thick, opaque web on your current location."
	overlay_state = "webdense"
	recharge_time = 30 SECONDS
	web_type = /obj/structure/spider/stickyweb/thick
	spin_time = 8 SECONDS
	stamina_cost = 60
	web_name = "dense web"

/// Drow Merc mount summon spells, spider spells of a different kind.

/mob/living/carbon/human
	/// Kept separate from the Equestrian virtue's mount.
	var/datum/weakref/spiderborn_mount

/proc/is_spiderborn_mount_area(area/place)
	if(!place)
		return FALSE
	return place.outdoors \
		|| istype(place, /area/rogue/under/underdark) \
		|| istype(place, /area/rogue/under/underdarker)

/obj/effect/proc_holder/spell/self/call_spider_mount
	name = "Call Drider"
	desc = "Call your saddled drider companion to your side. Usable outdoors or in the Underdark."
	school = "transmutation"
	overlay_state = "book1"
	chargedrain = 0
	chargetime = 0

/obj/effect/proc_holder/spell/self/call_spider_mount/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user) || !HAS_TRAIT(user, TRAIT_SPIDERBORN))
		revert_cast(user)
		return FALSE

	if(user.spiderborn_mount)
		to_chat(user, span_warning("I have already called my darling pet."))
		revert_cast(user)
		return FALSE

	if(!isturf(user.loc) || !is_spiderborn_mount_area(get_area(user)))
		to_chat(user, span_warning("I must be outdoors or in the Underdark to call my drider."))
		revert_cast(user)
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/rogue/drider/spider = new /mob/living/simple_animal/hostile/retaliate/rogue/drider/tame/saddled(get_turf(user))
	spider.owner = user
	user.spiderborn_mount = WEAKREF(spider)

	user.AddSpell(new /obj/effect/proc_holder/spell/self/saddleborn/sendaway/spiderborn)
	user.AddSpell(new /obj/effect/proc_holder/spell/self/saddleborn/whistle/spiderborn)

	user.visible_message(
		span_notice("[user] whistles sharply, and [spider] scuttles to their side."),
		span_notice("I whistle for my drider, and it scuttles to my side.")
	)
	playsound(user, 'sound/magic/saddleborn-call.ogg', 150, FALSE, 5)

	if(!user.buckled)
		spider.buckle_mob(user, TRUE)
		setup_saddleborn_mount_move_delay(user, spider)

	qdel(src)
	return TRUE

/obj/effect/proc_holder/spell/self/saddleborn/sendaway/spiderborn
	name = "Spider: Send Away"
	desc = "Send your drider away while outdoors or in the Underdark."

/obj/effect/proc_holder/spell/self/saddleborn/sendaway/spiderborn/get_mount(mob/living/carbon/human/user)
	if(!ishuman(user) || !HAS_TRAIT(user, TRAIT_SPIDERBORN))
		return null
	return user.spiderborn_mount?.resolve()

/obj/effect/proc_holder/spell/self/saddleborn/whistle/spiderborn
	name = "Spider: Recall"
	desc = "Call your drider to your side. Unlike those wretched surface mounts, the noble drider is unbothered by trivialities like hostile terrain or fauna; an apex in its own right."

/obj/effect/proc_holder/spell/self/saddleborn/whistle/spiderborn/get_mount(mob/living/carbon/human/user)
	if(!ishuman(user) || !HAS_TRAIT(user, TRAIT_SPIDERBORN))
		return null
	return user.spiderborn_mount?.resolve()
