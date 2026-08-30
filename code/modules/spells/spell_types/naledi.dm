
/obj/effect/proc_holder/spell/invoked/regression
	name = "Regression"
	desc = "Uses Origin Magick to gradually rewind a target's body to a healthier state. The effects happen in order, and only one at a time. Removes embedded objects, stops bleeding, grants health regeneration and energy recovery. The nature of time-based manipulation allows this to work on most targets."
	overlay_state = "regression"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	range = 5
	warnie = "sydwarning"
	movement_interrupt = FALSE
	req_items = list(/obj/item/clothing/neck/roguetown/psicross/naledi)
	sound = list('sound/magic/regression1.ogg','sound/magic/regression2.ogg','sound/magic/regression3.ogg','sound/magic/regression4.ogg')
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 12 SECONDS
	miracle = TRUE
	devotion_cost = 50

/obj/effect/proc_holder/spell/invoked/regression/cast(list/targets, mob/living/user)
	. = ..()
	var/mob/living/owner = user
	var/mob/living/target = targets[1]
	if(!istype(target))
		revert_cast()
		return FALSE
	if(!isliving(target))
		revert_cast()
		return FALSE

	var/obj/effect/temp_visual/origin_restoration/V = new
	target.vis_contents += V
	var/turf/user_turf = get_turf(owner)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, NORTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, NORTHWEST)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, SOUTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, SOUTHWEST)
	if(!istype(target, /mob/living/carbon))
		target.apply_status_effect(/datum/status_effect/buff/originhealing)
		target.visible_message(span_info("Origin arts stabilize [target]!"), span_notice("A brief temporal correction passes through me."))
		return TRUE

	var/mob/living/carbon/C = target

	var/step_check = FALSE

	// Embedded objects
	if(length(C.bodyparts))
		for(var/obj/item/bodypart/BP in C.bodyparts)
			if(!BP)
				continue

			if(length(BP.embedded_objects))
				for(var/obj/item/embedded as anything in BP.embedded_objects)
					if(!embedded)
						continue
					BP.remove_embedded_object(embedded)
					playsound(C.loc, 'sound/surgery/organ1.ogg', 100)
					step_check = TRUE

	if(length(C.simple_embedded_objects))
		for(var/obj/item/embedded as anything in C.simple_embedded_objects)
			if(!embedded)
				continue
			C.simple_remove_embedded_object(embedded)
			playsound(C.loc, 'sound/surgery/organ1.ogg', 100)
			step_check = TRUE

	if(step_check)
		C.visible_message(span_info("Origin arts undo [C]'s embedded objects!"), span_notice("Foreign objects are rewound in time!"))
		return TRUE

	// Wound bleed
	var/list/wAmount = C.get_wounds()
	if(wAmount && length(wAmount))
		for(var/datum/wound/W as anything in wAmount)
			if(!W)
				continue
			if(W.bleed_rate > 0)
				W.set_bleed_rate(0)
				step_check = TRUE

	if(step_check)
		C.visible_message(span_info("Origin arts reverse [C]'s bleeding!"),	span_notice("My bleeding wounds close, as if reverting in time!"))
		return TRUE

	// Healing
	C.visible_message(span_info("Origin arts rewind [C]'s body!"), span_notice("My body slowly recalls to a prior form!"))
	C.apply_status_effect(/datum/status_effect/buff/originhealing)
	return



/obj/effect/temp_visual/origin_restoration
	icon = 'icons/effects/effects.dmi'
	icon_state = "anom"
	duration = 10
	layer = ABOVE_MOB_LAYER
	alpha = 200
	color = "#FFD966"

/obj/effect/temp_visual/origin_restoration/Initialize(mapload)
	. = ..()
	transform = matrix()*3
	animate(src, transform = matrix()*0.1, alpha = 0, time = duration, easing = EASE_IN)
	return INITIALIZE_HINT_NORMAL

/obj/effect/temp_visual/origin_restoration/Destroy()
	if(ismob(loc))
		var/mob/M = loc
		M.vis_contents -= src
	return ..()

/obj/effect/temp_visual/origin_restoration_burst
	icon = 'icons/effects/effects.dmi'
	icon_state = "medi_holo"
	duration = 8
	layer = ABOVE_MOB_LAYER
	alpha = 220
	color = "#FFD966"

/obj/effect/temp_visual/origin_restoration_burst/Initialize(mapload, dir_to_go)
	. = ..()
	var/turf/T = get_step(src, dir_to_go)
	if(T)
		animate(src, pixel_x = (T.x - x) * 32, pixel_y = (T.y - y) * 32, alpha = 0, time = duration)
	return INITIALIZE_HINT_NORMAL

/obj/effect/proc_holder/spell/invoked/convergence
	name = "Convergence"
	desc = "Converges the targets past and present, empowering your Naledi arts to last longer."
	overlay_state = "convergence"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
//	chargedloop = /datum/looping_sound/invokeholy
	chargedloop = null
	req_items = list(/obj/item/clothing/neck/roguetown/psicross/naledi)
	sound = list('sound/magic/convergence1.ogg','sound/magic/convergence2.ogg','sound/magic/convergence3.ogg','sound/magic/convergence4.ogg')
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 10

/obj/effect/proc_holder/spell/invoked/convergence/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		target.visible_message(span_info("A convergence of fates surrounds [target]!"), span_notice("My past and present converge as one!"))
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			C.apply_status_effect(/datum/status_effect/buff/convergence)
		else
			target.adjustBruteLoss(-50)
			target.adjustFireLoss(-50)
		return TRUE
	revert_cast()
	return FALSE


/obj/effect/proc_holder/spell/invoked/stasis
	name = "Stasis"
	desc = "You capture your target's current state in time, reverting them to such a state several seconds later. If under Convergence  when expiring, your target will keep any healing they receive."
	releasedrain = 35
	chargedrain = 1
	chargetime = 30
	recharge_time = 60 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	req_items = list(/obj/item/clothing/neck/roguetown/psicross/naledi)
	sound = 'sound/magic/timeforward.ogg'
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	overlay_state = "sands_of_time"
	var/brute = 0
	var/burn = 0
	var/oxy = 0
	var/toxin = 0
	var/turf/origin
	var/firestacks = 0
	var/divinefirestacks = 0
	var/sunderfirestacks = 0
	var/blood = 0
	var/list/datum/wound/snapshot_wounds
	miracle = TRUE
	devotion_cost = 70

/obj/effect/proc_holder/spell/invoked/stasis/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/self = usr
	var/mob/living/carbon/target = targets[1]
	// Reverse a recently departed soul. Must be done within 1 minute.
	if(target?.stat == DEAD)
		if(!self.has_status_effect(/datum/status_effect/debuff/devitalised))
			if(target.timeofdeath && (world.time - target.timeofdeath) <= 1 MINUTES)
				if(alert(user, "[target] has very recently departed. Sacrifice your Lux to rewind their soul back?", "Origin Restoration", "Restore Them", "Leave Them") == "Restore Them")
					var/obj/effect/temp_visual/origin_restoration/V = new
					target.vis_contents += V
					var/turf/user_turf = get_turf(user)
					new /obj/effect/temp_visual/origin_restoration_burst(user_turf, NORTHEAST)
					new /obj/effect/temp_visual/origin_restoration_burst(user_turf, NORTHWEST)
					new /obj/effect/temp_visual/origin_restoration_burst(user_turf, SOUTHEAST)
					new /obj/effect/temp_visual/origin_restoration_burst(user_turf, SOUTHWEST)
					playsound(target.loc, 'sound/magic/regression1.ogg')
					self.apply_status_effect(/datum/status_effect/debuff/devitalised)
					target.setOxyLoss(0)
					if(target.revive(full_heal = FALSE))
						target.grab_ghost(force = TRUE)
						target.emote("gasp")
						target.Jitter(100)
						if(target.mind)
							target.mind.remove_antag_datum(/datum/antagonist/zombie)
						target.apply_status_effect(/datum/status_effect/debuff/revived)
						target.visible_message(span_blue("[user]'s Lux is forcefully torn away as [target]'s soul is rewound back into their body!"),	span_blue("A distant darkness releases its grip on me. I wake once more, feeling the remnants of a dying light..."))
						return TRUE
					else
						revert_cast()
						return FALSE
				else
					revert_cast()
					return FALSE

	if(isliving(target))
		var/mob/living/carbon/C = target
		C.apply_status_effect(/datum/status_effect/buff/stasis)
		brute = target.getBruteLoss()
		burn = target.getFireLoss()
		oxy = target.getOxyLoss()
		toxin = target.getToxLoss()
		origin = get_turf(target)
		blood = target.get_blood_volume()
		var/datum/status_effect/fire_handler/fire_stacks/fire_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks)
		firestacks = fire_status?.stacks
		var/datum/status_effect/fire_handler/fire_stacks/sunder/sunder_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder)
		sunderfirestacks = sunder_status?.stacks
		var/datum/status_effect/fire_handler/fire_stacks/divine/divine_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/divine)
		divinefirestacks = divine_status?.stacks
		// Snapshot current wounds so we can remove new ones on revert
		snapshot_wounds = target.get_wounds()

		to_chat(target, span_warning("I feel a part of me was left behind..."))
		play_indicator(target,'icons/mob/overhead_effects.dmi', "timestop", 100, OBJ_LAYER)
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = 10 SECONDS)
		return TRUE
	else
		revert_cast()
		return FALSE

/obj/effect/proc_holder/spell/invoked/stasis/proc/remove_buff(mob/living/carbon/target)
	do_teleport(target, origin, no_effects=TRUE)
	var/brutenew = target.getBruteLoss()
	var/burnnew = target.getFireLoss()
	var/oxynew = target.getOxyLoss()
	var/toxinnew = target.getToxLoss()
	target.set_fire_stacks(firestacks || 0)
	target.set_fire_stacks(sunderfirestacks || 0, /datum/status_effect/fire_handler/fire_stacks/sunder)
	target.set_fire_stacks(divinefirestacks || 0, /datum/status_effect/fire_handler/fire_stacks/divine)
	if(target.has_status_effect(/datum/status_effect/buff/convergence))
		if(brutenew>brute)
			target.adjustBruteLoss(brutenew*-1 + brute)
		if(burnnew>burn)
			target.adjustFireLoss(burnnew*-1 + burn)
		if(oxynew>oxy)
			target.adjustOxyLoss(oxynew*-1 + oxy)
		if(toxinnew>toxin)
			target.adjustToxLoss(target.getToxLoss()*-1 + toxin)
		if(target.get_blood_volume() <blood)
			target.set_blood_volume(blood)
	else
		target.adjustBruteLoss(brutenew*-1 + brute)
		target.adjustFireLoss(burnnew*-1 + burn)
		target.adjustOxyLoss(oxynew*-1 + oxy)
		target.adjustToxLoss(target.getToxLoss()*-1 + toxin)
		target.set_blood_volume(blood)
	// Remove any wounds gained after the mark
	for(var/datum/wound/wound as anything in target.get_wounds())
		if(wound in snapshot_wounds)
			continue
		if(wound.bodypart_owner)
			wound.bodypart_owner.remove_wound(wound)
		else
			target.simple_remove_wound(wound)

	playsound(target.loc, 'sound/magic/timereverse.ogg', 100, FALSE)

/obj/effect/proc_holder/spell/invoked/stasis/proc/play_indicator(mob/living/carbon/target, icon_path, overlay_name, clear_time, overlay_layer)
	if(!ishuman(target))
		return
	if(target.stat != DEAD)
		var/mob/living/carbon/humie = target
		var/datum/species/species =	humie.dna.species
		var/list/offset_list
		if(humie.gender == FEMALE)
			offset_list = species.offset_features[OFFSET_HEAD_F]
		else
			offset_list = species.offset_features[OFFSET_HEAD]
			var/mutable_appearance/appearance = mutable_appearance(icon_path, overlay_name, overlay_layer)
			if(offset_list)
				appearance.pixel_x += (offset_list[1])
				appearance.pixel_y += (offset_list[2]+12)
			appearance.appearance_flags = RESET_COLOR
			target.overlays_standing[OBJ_LAYER] = appearance
			target.apply_overlay(OBJ_LAYER)
			update_icon()
			addtimer(CALLBACK(humie, PROC_REF(clear_overhead_indicator), appearance, target), clear_time)

/obj/effect/proc_holder/spell/invoked/stasis/proc/clear_overhead_indicator(appearance,mob/living/carbon/target)
	target.remove_overlay(OBJ_LAYER)
	cut_overlay(appearance, TRUE)
	qdel(appearance)
	update_icon()
	return


//Acceleration
/obj/effect/proc_holder/spell/invoked/acceleration
	name = "Acceleration"
	desc = "Displace a target slightly ahead of local time, dramatically increasing their speed and reactions. When reality catches up, the resulting temporal strain leaves them sluggish and exhausted."
//	fluff_desc = "One of the earliest applications of Origin Magick, Acceleration was first devised to hasten crop growth and shorten agricultural cycles. The experiment revealed a fundamental limitation of the art: while a subject's personal timeline can be advanced, the debt incurred cannot be avoided. Reality inevitably reconciles the discrepancy, repaying every stolen moment in equal measure. Though unsuitable for cultivation, the technique found lasting use among Naledi Viziers as a potent, if taxing, combat tool."
	overlay_state = "accel"
	sound = list('sound/magic/haste.ogg')
	range = 4
	recharge_time = 45 SECONDS
	invocations = list("Aggil!")
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/acceleration/cast(list/targets, mob/living/user)
	. = ..()
	var/mob/living/carbon/owner = user
	var/mob/living/carbon/target = targets[1]

	if(!istype(target))
		revert_cast()
		return FALSE

	var/obj/effect/temp_visual/origin_restoration/V = new
	target.vis_contents += V
	if(target.has_status_effect(/datum/status_effect/buff/accel))
		revert_cast()
		return FALSE
	if(target.has_status_effect(/datum/status_effect/buff/haste))
		revert_cast()
		return FALSE
	var/turf/user_turf = get_turf(owner)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, NORTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, NORTHWEST)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, SOUTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, SOUTHWEST)

	target.visible_message(span_blue("Origin magicks skip [target]'s body ahead in time!"), span_blue("My form is thrown ahead of the present!"))
	if(target.has_status_effect(/datum/status_effect/buff/convergence))
		target.apply_status_effect(/datum/status_effect/buff/accel, 16 SECONDS)
		return TRUE
	target.apply_status_effect(/datum/status_effect/buff/accel)

	return TRUE

/atom/movable/screen/alert/status_effect/buff/accel
	name = "Acceleration"
	desc = "My personal timeline has accelerated. My body moves before I can think!"
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/debuff/decel
	name = "Deceleration"
	desc = "Time is catching up with me. Everything is in slow motion...!"
	icon_state = "debuff"

/datum/status_effect/buff/accel
	id = "acceleration"
	alert_type = /atom/movable/screen/alert/status_effect/buff/accel
	effectedstats = list(STATKEY_SPD = 20)
	duration = 10 SECONDS
	var/afterimage_active = FALSE

/datum/status_effect/buff/accel/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/accel/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_INFINITE_STAMINA, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_GUIDANCE, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_UNCAPPED_SPEED, TRAIT_STATUS_EFFECT(id))

	if(!afterimage_active)
		owner.AddComponent(/datum/component/after_image)
		afterimage_active = TRUE

	to_chat(owner, span_green("My timeline races ahead of the present. I am unbound by time!"))

/datum/status_effect/buff/accel/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_INFINITE_STAMINA, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_GUIDANCE, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_UNCAPPED_SPEED, TRAIT_STATUS_EFFECT(id))

	if(afterimage_active)
		var/datum/component/after_image/after_image_component = owner.GetComponent(/datum/component/after_image)
		if(after_image_component)
			qdel(after_image_component)
		afterimage_active = FALSE
	if(owner.has_status_effect(/datum/status_effect/buff/convergence))
		owner.apply_status_effect(/datum/status_effect/debuff/decel, 8 SECONDS)
	else
		owner.apply_status_effect(/datum/status_effect/debuff/decel, 6 SECONDS)

	to_chat(owner, span_red("Time catches up with me, with its toll."))

/datum/status_effect/buff/accel/nextmove_modifier()
	return 0.5

/datum/status_effect/debuff/decel
	id = "deceleration"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/decel
	effectedstats = list(STATKEY_SPD = -20)
	duration = 6 SECONDS



/datum/status_effect/debuff/decel/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/debuff/decel/on_apply()
	. = ..()

	ADD_TRAIT(owner, TRAIT_NODEF, TRAIT_STATUS_EFFECT(id))
	owner.stamina_add(75)
	to_chat(owner, span_red("Everything feels unbearably slow. I am defenseless!"))

/datum/status_effect/debuff/decel/on_remove()
	. = ..()

	REMOVE_TRAIT(owner, TRAIT_NODEF, TRAIT_STATUS_EFFECT(id))

	to_chat(owner, span_blue("My timeline stabilizes, finally."))

/datum/status_effect/debuff/decel/nextmove_modifier()
	return 2


/obj/effect/temp_visual/origin_haste
	icon = 'icons/effects/effects.dmi'
	icon_state = "chronofield"
	duration = 10
	layer = ABOVE_MOB_LAYER
	alpha = 200
	color = "#66ffcc"

/obj/effect/temp_visual/origin_haste/Initialize(mapload)
	. = ..()
	transform = matrix()*3
	animate(src, transform = matrix()*0.1, alpha = 0, time = duration, easing = EASE_IN)
	return INITIALIZE_HINT_NORMAL

/obj/effect/temp_visual/origin_haste/Destroy()
	if(ismob(loc))
		var/mob/M = loc
		M.vis_contents -= src
	return ..()

///Divergence

/obj/effect/proc_holder/spell/invoked/divergence
	name = "Divergence"
	desc = "Shatters a target across several competing timelines, briefly immobilizing them and spawning 4 to 8 Time Echoes around them. Recovering an echo restores the target's vitality, while destroying one forces reality to violently reconcile the contradiction, inflicting damage."
//	fluff_desc = "The Naledi teach that every living thing exists atop an endless lattice of unrealized possibilities. Divergence tears open that lattice and scatters fragments of a victim's fate across nearby histories. To reclaim an echo is to remember a life that almost was. To destroy one is to deny that possibility ever existed, and reality rarely forgives the contradiction."
	overlay_state = "divergence"
	sound = list('sound/magic/regression1.ogg', 'sound/magic/regression2.ogg', 'sound/magic/regression3.ogg')
	range = 5
	recharge_time = 60 SECONDS
	invocations = list("Naf'ir! Diverge, timeline!")
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/divergence/cast(list/targets, mob/living/user)
	. = ..()
	var/mob/living/target = targets[1]
	if(!istype(target))
		revert_cast()
		return FALSE

	if(target.has_status_effect(/datum/status_effect/debuff/divergence))
		to_chat(user, span_warning("[target] is already fractured across diverging timelines!"))
		revert_cast()
		return FALSE

	target.visible_message(span_blue("Origin Magick shatters [target] across diverging timelines!"), span_blue("I feel myself pulled apart into countless possibilities! I'm not here-- I'm there-- Huh?? Where??"))
	target.apply_status_effect(/datum/status_effect/debuff/divergence, user)
	return TRUE

/proc/arcyne_validate_blink_dest(turf/dest, mob/user)
	if(!dest)
		return "Invalid target location!"
	if(dest.teleport_restricted)
		return "I can't teleport here!"
	var/turf/start = get_turf(user)
	if(dest.z != start.z)
		return "I can only teleport on the same plane!"
	if(istransparentturf(dest))
		return "I cannot teleport to the open air!"
	if(dest.density)
		return "I cannot teleport into a wall!"
	for(var/obj/structure/roguewindow/W in dest)
		if(W.density)
			return "I cannot teleport through a window!"
	for(var/obj/structure/mineral_door/door in dest)
		if(door.density)
			return "I cannot teleport through a door!"
	for(var/obj/structure/bars/B in dest)
		if(B.density)
			return "I cannot teleport through bars!"
	for(var/obj/structure/gate/G in dest)
		if(G.density)
			return "I cannot teleport through a gate!"
	return null

/datum/status_effect/debuff/divergence
	id = "divergence"
	duration = 20 SECONDS

	var/list/fragments = list()

	var/heal_per_fragment = 14
	var/damage_per_fragment = 22

	var/mob/living/caster

/datum/status_effect/debuff/divergence/on_creation(mob/living/new_owner, mob/living/new_caster)
	. = ..()
	if(owner.has_status_effect(/datum/status_effect/buff/convergence))
		heal_per_fragment = 19
		damage_per_fragment = 27

/datum/status_effect/debuff/divergence/on_apply()
	. = ..()

	if(!owner)
		return

	var/turf/center = get_turf(owner)

	owner.Immobilize(2 SECONDS)

	owner.visible_message(
		span_warning("[owner]'s timeline fractures apart!"),
		span_notice("I can feel pieces of myself scattered around me!")
	)

	spawn_fragments(center)

/datum/status_effect/debuff/divergence/on_remove()
	. = ..()

	for(var/obj/effect/divergence_fragment/F in fragments)
		if(!QDELETED(F))
			qdel(F)

	fragments.Cut()

/datum/status_effect/debuff/divergence/proc/spawn_fragments(turf/center)
	if(!center || !owner)
		return

	var/list/candidates = list()

	for(var/turf/T in range(3, center))
		if(T == center)
			continue

		if(get_dist(center, T) < 1)
			continue

		if(arcyne_validate_blink_dest(T, owner))
			continue

		candidates += T

	if(!length(candidates))
		return

	var/list/chosen = list()
	var/count = rand(4, 8)
	var/attempts = 0

	while(length(chosen) < count && attempts < 100)
		attempts++

		var/turf/T = pick(candidates)

		var/valid = TRUE

		for(var/turf/other in chosen)
			if(get_dist(T, other) <= 1)
				valid = FALSE
				break

		if(!valid)
			continue

		chosen += T
		candidates -= T

	for(var/turf/T in chosen)
		var/obj/effect/divergence_afterimage/A = new(center)

		A.appearance = new /mutable_appearance(owner)
		A.color = "#A8C8FF"
		A.alpha = 180

		var/dx = (T.x - center.x) * 32
		var/dy = (T.y - center.y) * 32

		A.pixel_x = rand(-8, 8)
		A.pixel_y = rand(-8, 8)

		animate(A, pixel_x = dx + rand(-12, 12), pixel_y = dy + rand(-12, 12), alpha = 0, transform = matrix() * rand(80, 120) / 100, time = rand(3, 6))
		addtimer(CALLBACK(src, PROC_REF(spawn_fragment), T), rand(3, 6))

/obj/effect/divergence_fragment
	name = "temporal simulacrum"
	desc = "A discarded possibility struggling to remain real."
	density = TRUE
	anchored = TRUE
	alpha = 140
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_OPAQUE

	var/datum/status_effect/debuff/divergence/master
	var/collapsing = FALSE


/obj/effect/divergence_fragment/Initialize(mapload)
	. = ..()

	addtimer(CALLBACK(src, PROC_REF(start_jitter)), 4)
	addtimer(CALLBACK(src, PROC_REF(range_check)), 10, TIMER_LOOP)

	return INITIALIZE_HINT_NORMAL

/obj/effect/divergence_fragment/proc/start_jitter()
	if(QDELETED(src))
		return

	addtimer(CALLBACK(src, PROC_REF(jitter)), 1, TIMER_LOOP)

/obj/effect/divergence_fragment/proc/enable_collision()
	if(QDELETED(src))
		return

	density = TRUE

	addtimer(CALLBACK(src, PROC_REF(jitter)), 1, TIMER_LOOP)

/obj/effect/divergence_fragment/proc/range_check()
	if(QDELETED(src))
		return

	if(!master || !master.owner)
		qdel(src)
		return

	var/mob/living/M = master.owner
	if(!istype(M))
		qdel(src)
		return

	var/turf/T = get_turf(M)
	var/turf/self_turf = get_turf(src)

	if(!T || !self_turf)
		qdel(src)
		return

	// distance threshold (tweak freely)
	if(get_dist(self_turf, T) > 6)
		M.visible_message(span_warning("A fractured timeline collapses as its origin drifts too far away."), span_notice("One of your temporal echoes fades from existence."))
		qdel(src)

/obj/effect/divergence_fragment/proc/jitter()
	if(QDELETED(src))
		return

	pixel_x = rand(-1, 1)
	pixel_y = rand(-1, 1)

/obj/effect/divergence_fragment/proc/copy_target(mob/living/L)
	if(!L)
		return
	appearance = new /mutable_appearance(L)
	alpha = 140
	color = "#A8C8FF"

/obj/effect/divergence_fragment/Crossed(atom/movable/AM)
	. = ..()
	if(!isliving(AM))
		return
	var/mob/living/L = AM
	if(L.cmode)
		to_chat(L, span_warning("I need a calm mind to properly match the simulacrum's frequency. Turn Combat Mode off!"))
		return
	converge()

/obj/effect/divergence_fragment/Bumped(atom/movable/AM)
	. = ..()
	if(!isliving(AM))
		return
	var/mob/living/L = AM
	if(L.cmode)
		to_chat(L, span_warning("I need a calm mind to properly match the simulacrum's frequency. Turn Combat Mode off!"))
		return
	converge()

/obj/effect/divergence_fragment/proc/converge()
	if(collapsing)
		return

	collapsing = TRUE
	if(!master)
		return
	var/mob/living/M = master.owner

	if(M)
		M.adjustBruteLoss(-master.heal_per_fragment)
		M.adjustFireLoss(-master.heal_per_fragment)
		M.adjustOxyLoss(-master.heal_per_fragment)
		M.visible_message(span_blue("[src] rejoins [M]'s timeline."), span_blue("A lost possibility settles back into place, restoring you."))
	master.fragments -= src

	qdel(src)

/obj/effect/divergence_fragment/attackby(obj/item/W, mob/user, params)
	. = ..()
	collapse()

/obj/effect/divergence_fragment/attack_hand(mob/user, list/modifiers)
	. = ..()
	collapse()

/obj/effect/divergence_fragment/proc/collapse()
	if(collapsing)
		return

	collapsing = TRUE
	if(master)
		master.fragments -= src

	var/mob/living/M = master?.owner

	if(M)
		M.adjustBruteLoss(master.damage_per_fragment/2)
		M.adjustFireLoss(master.damage_per_fragment/2)
		M.adjustOxyLoss(master.damage_per_fragment/2)
		M.visible_message(span_danger("Time violently distorts around [M] as a discarded timeline is forced back into reality!"), span_userdanger("One of my fractured timelines violently collapses!"))
		shake_camera(M, 2, 2)
		if(!M.mind && iscarbon(M) && prob(30)) // 30% crit chance on NPCs, baybee
			var/list/limb_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			shuffle(limb_zones)
			for(var/zone in limb_zones)
				var/obj/item/bodypart/L = M.get_bodypart(zone)
				if(L)
					if(L.dismember(damage = 999))
						M.visible_message(span_userdanger("[M]'s timeline rejects one of its possibilities, tearing away a limb!"), span_userdanger("Reality violently disagrees on the existence of one of my limbs!"))
					break


	new /obj/effect/temp_visual/origin_restoration_burst(get_turf(M), NORTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(get_turf(M), NORTHWEST)
	new /obj/effect/temp_visual/origin_restoration_burst(get_turf(M), SOUTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(get_turf(M), SOUTHWEST)
	playsound(get_turf(M), "glassbreak", 90, TRUE)
	playsound(get_turf(M), 'sound/magic/regression2.ogg', 80)

	qdel(src)

/obj/effect/divergence_afterimage
	name = ""
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	alpha = 180

/obj/effect/divergence_afterimage/Initialize(mapload)
	. = ..()
	QDEL_IN(src, 5)

/datum/status_effect/debuff/divergence/proc/spawn_fragment(turf/T)
	if(QDELETED(src))
		return

	var/obj/effect/divergence_fragment/F = new(T)

	F.master = src
	F.copy_target(owner)

	F.dir = pick(NORTH, SOUTH, EAST, WEST)

	F.alpha = 0
	F.transform = matrix() * 0.25

	animate(
		F,
		alpha = 140,
		transform = matrix(),
		time = 2
	)

	fragments += F

// HIEROPHANT UNIQUE SPELL - Obelisks of Power
// On use, create a tile that will disable your Parry/Dodge, but grant you capped INT.
// This is only active while you are standing on said tile.
// Lasts 30 seconds.
// If Combat Mode is off, this will instead restore your Energy.

/obj/effect/proc_holder/spell/invoked/ley_lines
	name = "Obelisks of Power"
	desc = "Creates a circle of arcyne power. Standing within it greatly enhances your spellcasting, increasing your intellect and reducing the cooldown of your spells. If you are not in Combat Mode, the obelisks instead restore your energy at a rapid pace.<br><br>While standing in a Arcyne Loop, you cannot defend yourself.<br><br>This will also grant a spell that makes you quickly move back to your Arcyne Loop."
	overlay_state = "rune2"
	sound = 'sound/magic/chargingold.ogg'
	chargetime = 0
	recharge_time = 3 MINUTES
	releasedrain = 50

	sound = 'sound/magic/swap.ogg'
	var/obj/structure/leyline_circle/active_circle

/obj/effect/proc_holder/spell/invoked/ley_lines/cast(list/targets, mob/living/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!H)
		return FALSE
	if(active_circle && !QDELETED(active_circle))
		qdel(active_circle)
	active_circle = new(get_turf(H), H, src)
	to_chat(H, span_blue("Arcyne sigils spread beneath your feet as Ancient Obelisks fade in from a lost time. A connection forms, a loop, tying these obelisks to the sigils."))
	return TRUE

/obj/effect/proc_holder/spell/invoked/ley_lines/proc/on_circle_removed()
	active_circle = null

/obj/effect/proc_holder/spell/invoked/between_the_lines
	name = "Between the spires"
	desc = "Return instantly to your Arcyne Loop, you addict."
	overlay_state = "rune3"
	recharge_time = 15 SECONDS
	chargetime = 1.5 SECONDS
	releasedrain = 30
	chargedrain = 1
	var/obj/structure/leyline_circle/linked_circle
	var/max_range = 9

/obj/effect/proc_holder/spell/invoked/between_the_lines/cast(list/targets, mob/living/user)
	. = ..()
	if(!user)
		return FALSE
	if(!linked_circle || QDELETED(linked_circle))
		return FALSE
	if(get_dist(user, linked_circle) > max_range)
		user.balloon_alert(user, "too far from my arcyne loop!")
		return FALSE
	var/turf/T = get_turf(linked_circle)
	if(!T)
		return FALSE
	do_teleport(user, T, channel = TELEPORT_CHANNEL_MAGIC)
	playsound(T, 'sound/magic/blink.ogg', 50, TRUE)
	return TRUE


/datum/status_effect/buff/circle_of_power
	id = "circle_of_power"
	duration = -1
	tick_interval = 0.5 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/buff/circle_of_power
	effectedstats = list(STATKEY_INT = 4)
	var/obj/structure/leyline_circle/source_circle

/datum/status_effect/buff/circle_of_power/on_apply()
	. = ..()
	if(owner)
		ADD_TRAIT(owner, TRAIT_NODEF, "[id]")
		ADD_TRAIT(owner, TRAIT_LEYLINE_HASTE, "[id]")	//Once charge calculation overhaul complete, apply trait benefit

/datum/status_effect/buff/circle_of_power/on_remove()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_NODEF, "[id]")
		REMOVE_TRAIT(owner, TRAIT_LEYLINE_HASTE, "[id]")
	. = ..()

/datum/status_effect/buff/circle_of_power/tick()
	. = ..()
	if(QDELETED(owner))
		qdel(src)
		return
	if(!source_circle || QDELETED(source_circle))
		qdel(src)
		return
	if(get_turf(owner) != get_turf(source_circle))
		qdel(src)
		return

/atom/movable/screen/alert/status_effect/buff/circle_of_power
	name = "Circle of Power"
	desc = "The connected Ley Lines sharply empower my arcane prowess!"
	icon_state = "circle_of_power"

/obj/effect/phantom_leyline
	name = "phantom obelisks"
	icon = 'icons/roguetown/misc/64x96.dmi'
	icon_state = "obelisk"
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 180
	pixel_x = 0
	pixel_y = 0
	var/obj/effect/beam_target/beam_anchor

/obj/structure/leyline_circle
	name = "Arcyne Loop"
	desc = "A circle of arcyne power woven into the land."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "astrata_chalky"
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/mob/living/owner
	var/datum/mind/owner_mind
	var/obj/effect/proc_holder/spell/invoked/ley_lines/parent_spell
	var/list/phantom_leylines = list()
	var/list/active_beams = list()
	var/obj/effect/leyline_ring/ring_a
	var/obj/effect/leyline_ring/ring_b

/obj/effect/leyline_ring
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = BELOW_OBJ_LAYER
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "astrata_chalky"

/obj/effect/beam_target
	anchored = TRUE
	density = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = BELOW_OBJ_LAYER

/obj/structure/leyline_circle/Initialize(mapload, mob/living/user, obj/effect/proc_holder/spell/invoked/ley_lines/spell)
	. = ..()
	owner = user
	owner_mind = user?.mind
	parent_spell = spell
	if(owner_mind)
		var/obj/effect/proc_holder/spell/invoked/between_the_lines/BTL = new
		BTL.linked_circle = src
		owner_mind.AddSpell(BTL)
	ring_a = new(loc)
	ring_b = new(loc)
	ring_a.layer = layer + 0.1
	ring_b.layer = layer + 0.2
	ring_a.alpha = 255
	ring_b.alpha = 255
	ring_a.color = "#66AAFF"
	ring_b.color = "#CC88FF"

	rotate_forever(ring_a, matrix(1.8, 0, 0, 0.4, 0, 0), 40 SECONDS, clockwise = TRUE)
	rotate_forever(ring_b, matrix(0.4, 0, 0, 1.8, 0, 0), 40 SECONDS, clockwise = FALSE)
	rotate_forever(src, matrix(), 40 SECONDS, clockwise = TRUE)

	spawn_phantom_leylines()
	START_PROCESSING(SSobj, src)
	QDEL_IN(src, 50 SECONDS)

/obj/structure/leyline_circle/proc/rotate_forever(atom/movable/A, matrix/base_matrix, time, clockwise = TRUE, steps = 24)
	if(!A || !base_matrix)
		return
	var/direction = clockwise ? 1 : -1
	animate(A, transform = base_matrix, time = 0)
	for(var/i in 1 to steps)
		var/matrix/step = matrix(base_matrix)
		step.Turn(direction * 360 * i / steps)
		if(i == steps)
			animate(transform = step, time = time / steps, loop = -1)
		else
			animate(transform = step, time = time / steps)

/obj/structure/leyline_circle/process()
	if(QDELETED(owner))
		qdel(src)
		return
	if(get_turf(owner) == get_turf(src))
		if(owner.cmode)
			owner.remove_status_effect(/datum/status_effect/buff/invigoration)
			if(!owner.has_status_effect(/datum/status_effect/buff/circle_of_power))
				var/datum/status_effect/buff/circle_of_power/B = owner.apply_status_effect(/datum/status_effect/buff/circle_of_power)
				if(B)
					B.source_circle = src
		else
			owner.remove_status_effect(/datum/status_effect/buff/circle_of_power)
			owner.apply_status_effect(/datum/status_effect/buff/invigoration, 5 SECONDS)
		if(!length(active_beams))
			create_beams()
	else
		clear_beams()

/obj/structure/leyline_circle/proc/create_beams()
	clear_beams()
	for(var/obj/effect/phantom_leyline/L in phantom_leylines)
		if(QDELETED(L))
			continue
		var/atom/movable/source = L.beam_anchor || L
		var/datum/beam/B = source.Beam(owner, icon_state = "medbeam", time = 35 SECONDS, maxdistance = 10)
		if(B)
			active_beams += B

/obj/structure/leyline_circle/proc/clear_beams()
	if(!length(active_beams))
		return
	for(var/datum/beam/B in active_beams)
		if(!QDELETED(B))
			qdel(B)
	active_beams.Cut()


/obj/structure/leyline_circle/proc/spawn_phantom_leylines()
	var/turf/T = get_turf(src)
	if(!T)
		return
	var/list/offsets = list(list(2, 3), list(-2, 3), list(2, -2), list(-2, -2))
	for(var/list/O in offsets)
		var/turf/target = locate(T.x + O[1], T.y + O[2], T.z)
		if(!target)
			continue
		var/turf/anchor_turf = locate(target.x, target.y + 1, target.z)
		var/obj/effect/beam_target/BT = new(anchor_turf || target)
		// origin pixel offset stays 0/0 - do not touch these, that's what fixes the endpoint bug
		var/obj/effect/phantom_leyline/L = new(target)
		L.pixel_x = -14   // shift obelisk art left/right to meet the beam's fixed anchor point
		L.pixel_y = -24  // shift obelisk art up/down to meet the beam's fixed anchor point
		L.beam_anchor = BT
		phantom_leylines += L


/obj/structure/leyline_circle/Destroy()
	STOP_PROCESSING(SSobj, src)
	clear_beams()
	if(owner)
		owner.remove_status_effect(/datum/status_effect/buff/circle_of_power)
	if(owner_mind)
		for(var/obj/effect/proc_holder/spell/invoked/between_the_lines/BTL in owner_mind.spell_list)
			if(BTL.linked_circle == src)
				owner_mind.RemoveSpell(BTL)
				break
	for(var/obj/effect/phantom_leyline/L in phantom_leylines)
		if(!QDELETED(L))
			if(L.beam_anchor && !QDELETED(L.beam_anchor))
				qdel(L.beam_anchor)
			qdel(L)
	phantom_leylines.Cut()
	if(ring_a)
		qdel(ring_a)
	if(ring_b)
		qdel(ring_b)
	if(parent_spell)
		parent_spell.on_circle_removed()
	return ..()
