
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
	name = "Weave Web"
	desc = "Spin thin webbing, then automatically reinforce it. Move or cancel during reinforcement to leave a thin web. Cooldown begins when weaving ends."
	overlay_state = "webthin"
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE
	ignore_cockblock = TRUE
	sound = 'sound/misc/nutriment.ogg'
	action_icon = 'icons/mob/actions/arachnid_weaving.dmi'
	var/spin_time = 4 SECONDS
	var/stamina_cost = 30

/obj/effect/proc_holder/spell/self/spin_web/proc/can_place(turf/T)
	if(!isfloorturf(T) || T.density || (locate(/obj/structure/bed/rogue/silk) in T))
		return FALSE
	var/web_count = 0
	for(var/obj/structure/spider/stickyweb/web in T)
		if(QDELETED(web))
			continue
		if(!istype(web, /obj/structure/spider/stickyweb/thin))
			return FALSE
		web_count++
	return web_count <= 1

/obj/effect/proc_holder/spell/self/spin_web/cast(mob/living/user)
	var/turf/web_turf = get_turf(user)
	if(user.loc != web_turf || !can_place(web_turf))
		to_chat(user, span_warning("I need bare floor or thin webbing that I can reinforce."))
		revert_cast(user)
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_INFINITE_STAMINA) && user.stamina + stamina_cost > user.max_stamina)
		to_chat(user, span_warning("I am too tired to weave."))
		revert_cast(user)
		return FALSE
	var/obj/structure/spider/stickyweb/existing_web = locate() in web_turf
	var/passes = existing_web ? 1 : 2
	var/completed = 0
	// The legacy spell framework starts processing before cast(); hold this cooldown until we finish.
	STOP_PROCESSING(SSfastprocess, src)
	charge_counter = 0
	user.visible_message(span_notice("[user] begins weaving webbing."))
	for(var/pass in 1 to passes)
		if(!HAS_TRAIT(user, TRAIT_INFINITE_STAMINA) && user.stamina + stamina_cost > user.max_stamina)
			to_chat(user, span_warning("I am too tired to keep weaving."))
			break
		var/reinforcing = !isnull(existing_web)
		var/finished = do_after(user, spin_time, target = reinforcing ? existing_web : user, progress = TRUE)
		if(QDELETED(src))
			return FALSE
		if(!finished || !(src in user.mob_spell_list))
			break
		if((reinforcing && QDELETED(existing_web)) || user.loc != web_turf || (locate(/obj/structure/spider/stickyweb) in web_turf) != existing_web || !can_place(web_turf))
			break
		if(!HAS_TRAIT(user, TRAIT_INFINITE_STAMINA) && user.stamina + stamina_cost > user.max_stamina)
			to_chat(user, span_warning("I am too tired to finish weaving."))
			break
		user.stamina_add(stamina_cost)
		var/created_type = reinforcing ? /obj/structure/spider/stickyweb/thick : /obj/structure/spider/stickyweb/thin
		var/obj/structure/spider/stickyweb/web = new created_type(web_turf)
		web.setDir(user.dir)
		if(reinforcing)
			qdel(existing_web)
			to_chat(user, span_notice("I reinforce the thin webbing into dense silk."))
		existing_web = web
		completed++
		if(pass < passes)
			to_chat(user, span_notice("The thin web is ready. I continue reinforcing it; moving or canceling now will leave it thin."))
	if(!completed)
		revert_cast(user)
		return FALSE
	charge_counter = 0
	// A completed first pass is a successful cast even when reinforcement is interrupted.
	// perform() starts the normal recharge after this proc returns.
	return TRUE

/obj/effect/proc_holder/spell/self/spin_silk_bed
	name = "Spin Silk Bed"
	action_icon = 'icons/mob/actions/arachnid_weaving.dmi'
	desc = "Spread bedroll-soft silk bedding on clear floor. Weave here again to add an overhead veil and ordinary-bed comfort."
	antimagic_allowed = TRUE
	ignore_cockblock = TRUE
	sound = 'sound/misc/nutriment.ogg'
	overlay_state = "bed"
	recharge_time = 30 SECONDS
	var/spin_time = 8 SECONDS
	var/stamina_cost = 60

/obj/effect/proc_holder/spell/self/spin_silk_bed/proc/can_place(turf/T)
	if(!isfloorturf(T) || T.density)
		return FALSE
	var/beds = 0
	for(var/obj/O in T)
		if(QDELETED(O))
			continue
		if(istype(O, /obj/structure/bed/rogue/silk))
			var/obj/structure/bed/rogue/silk/bed = O
			if(bed.upgraded)
				return FALSE
			beds++
			if(beds > 1)
				return FALSE
		else if(istype(O, /obj/structure) || O.density)
			return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/spin_silk_bed/cast(mob/living/user)
	var/turf/T = get_turf(user)
	if(user.loc != T || !can_place(T))
		to_chat(user, span_warning("I need clear floor space or unfinished silk bedding."))
		revert_cast(user)
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_INFINITE_STAMINA) && user.stamina + stamina_cost > user.max_stamina)
		to_chat(user, span_warning("I am too tired to weave a silk bed."))
		revert_cast(user)
		return FALSE
	var/obj/structure/bed/rogue/silk/existing_bed = locate() in T
	user.visible_message(span_notice("[user] begins weaving silk bedding."))
	var/finished = do_after(user, spin_time, target = user)
	if(QDELETED(src))
		return FALSE
	if(!finished)
		revert_cast(user)
		return FALSE
	if(user.loc != T || (locate(/obj/structure/bed/rogue/silk) in T) != existing_bed || !can_place(T))
		to_chat(user, span_warning("There is no longer room for the silk bed."))
		revert_cast(user)
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_INFINITE_STAMINA) && user.stamina + stamina_cost > user.max_stamina)
		to_chat(user, span_warning("I am too tired to finish weaving."))
		revert_cast(user)
		return FALSE
	user.stamina_add(stamina_cost)
	if(existing_bed)
		existing_bed.upgrade()
		to_chat(user, span_notice("I add a sheltering veil over the silk bedding."))
	else
		new /obj/structure/bed/rogue/silk(T)
	return TRUE

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

/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon
	name = "Weave Cocoon"
	desc = "Wrap an adjacent living person, or yourself, in supporting silk. Weaving takes five seconds and movement interrupts it. Three uses; each recovers independently after five minutes. Resist to escape, or cut or break it open."
	action_icon = 'icons/roguetown/misc/rescue_cocoon.dmi'
	overlay_state = "intact"
	range = 1
	include_user = TRUE
	antimagic_allowed = TRUE
	ignore_cockblock = TRUE
	charge_type = "charges"
	recharge_time = 3
	var/list/charge_returns = list()
	var/weaving = FALSE
	var/weave_time = 5 SECONDS
	var/charge_delay = 5 MINUTES

/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/Initialize(mapload)
	. = ..()
	update_icon()

/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/cast_check(skipcharge, mob/user = usr)
	// cast_check uses its argument, not the spell's skipcharge field. Spend only after wrapping succeeds.
	return ..(TRUE, user)

/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/charge_check(mob/user, silent = FALSE)
	if(!weaving && charge_counter > 0)
		return TRUE
	if(!silent)
		var/reason = weaving ? "You are already weaving a cocoon." : "You need time to replenish your cocoon silk."
		to_chat(user, span_warning(reason))
	return FALSE

/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/can_target(mob/living/target)
	return !QDELETED(target) && target.stat != DEAD && isturf(target.loc) && !target.buckled && !length(target.buckled_mobs)

/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/proc/valid_weave(mob/living/user, mob/living/target)
	if(QDELETED(src) || QDELETED(user) || !is_species(user, /datum/species/arachnid) || user.incapacitated() || !isturf(user.loc))
		return FALSE
	return can_target(target) && user.Adjacent(target) && (src in user.mob_spell_list)

/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/cast(list/targets, mob/living/user)
	var/mob/living/patient = length(targets) ? targets[1] : null
	if(!isliving(patient) || !charge_check(user) || !valid_weave(user, patient))
		return FALSE
	weaving = TRUE
	user.visible_message(span_notice("[user] begins wrapping [patient == user ? "themselves" : "[patient]"] in silk, weaving quick, precise layers around their body."), ignored_mobs = list(patient))
	if(patient == user)
		to_chat(patient, span_notice("You draw silk around yourself, carefully weaving a snug, supporting cocoon."))
	else if(patient.stat == CONSCIOUS)
		to_chat(patient, span_notice("[user] begins wrapping you in silk. Each careful pass draws the threads snugly around your body."))
	else
		to_chat(patient, span_notice("Through the haze, you feel something soft drawing close around your body - tight, snug, and oddly comforting."))
	var/finished = do_after(user, weave_time, target = patient, extra_checks = CALLBACK(src, PROC_REF(valid_weave), user, patient))
	if(QDELETED(src))
		return FALSE
	weaving = FALSE
	if(!finished || !valid_weave(user, patient))
		if(!QDELETED(user))
			to_chat(user, span_notice("The wrapping comes loose before you can secure it."))
		if(!QDELETED(patient))
			to_chat(patient, span_notice("The forming layers loosen before they can enclose you."))
		return FALSE
	var/obj/structure/spider/rescue_cocoon/cocoon = new(get_turf(patient))
	if(!cocoon.enclose(patient))
		qdel(cocoon)
		return FALSE
	charge_counter--
	charge_returns += world.time + charge_delay
	START_PROCESSING(SSfastprocess, src)
	cocoon.visible_message(span_notice("[user] draws the final strands into place, enclosing [patient] in a cocoon of layered silk."), ignored_mobs = list(patient))
	if(patient == user)
		to_chat(patient, span_notice("You settle within your finished cocoon, supported by the silk you have drawn around yourself."))
	else if(patient.stat == CONSCIOUS)
		to_chat(patient, span_notice("[user] finishes enclosing you in silk. The cocoon holds your body snugly, yielding slightly as you breathe."))
	else
		to_chat(patient, span_notice("The weaving sensation fades. A steady, enclosing pressure remains around your body."))
	update_icon()
	return TRUE

/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/revert_cast(mob/user = usr)
	// The framework can cancel targeting without a successful cast; no charge was reserved.
	user?.stop_attack()

/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/start_recharge()
	START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/process()
	while(length(charge_returns) && charge_returns[1] <= world.time)
		charge_returns.Cut(1, 2)
		charge_counter = min(initial(recharge_time), charge_counter + 1)
		update_icon()
	if(!length(charge_returns))
		STOP_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/weave_rescue_cocoon/update_icon()
	if(!action)
		return
	action.name = "[name] ([charge_counter]/[initial(recharge_time)])"
	action.build_all_button_icons(force = TRUE)
