//PESTRUSSY

/obj/effect/proc_holder/spell/invoked/diagnose/greater
	name = "Greater Diagnose"
	desc = "A precise divine appraisal: shows reagents, blood level, organ status, and quantified damage."
	overlay_state = "diagnose"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/diagnose.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 8 SECONDS
	miracle = TRUE
	devotion_cost = 0

/obj/effect/proc_holder/spell/invoked/diagnose/greater/cast(list/targets, mob/living/user)
	if(!ishuman(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]

	if(hascall(H, "check_for_injuries"))
		H.check_for_injuries(user)

	to_chat(user, span_notice("--- Divine Diagnosis on [H] ---"))

	if(H.reagents && H.reagents.reagent_list?.len)
		to_chat(user, span_info("Reagents detected:"))
		for(var/datum/reagent/R as anything in H.reagents.reagent_list)
			if(!R || R.volume <= 0) continue
			to_chat(user, "• [R.name]: [round(R.volume, 0.1)]u")
	else
		to_chat(user, span_notice("Reagents detected: none."))

	to_chat(user, span_info("Blood volume: [round(((isnum(H.blood_volume) && H.blood_volume > 0) ? H.blood_volume : (H.reagents && hascall(H.reagents, "get_reagent_amount") ? H.reagents.get_reagent_amount(/datum/reagent/blood) : 0)), 0.1)]u"))

	var/tox = _dg_safe_num(H, list("toxloss"))
	var/oxy = _dg_safe_num(H, list("oxyloss", "oxygen_loss"))
	to_chat(user, span_info("Toxin damage: [tox]"))
	to_chat(user, span_info("Oxygen damage: [oxy]"))

	if(islist(H.bodyparts) && H.bodyparts.len)
		to_chat(user, span_info("Bodyparts damage:"))
		for(var/obj/item/bodypart/B as anything in H.bodyparts)
			var/br = _dg_safe_num(B, list("brute_dam", "brute_damage", "brute"))
			var/bu = _dg_safe_num(B, list("burn_dam", "burn_damage", "burn"))
			if(br > 0 || bu > 0)
				to_chat(user, "• [B.name]: brute [br], burn [bu]")
	else
		to_chat(user, span_notice("No bodypart damage data available."))
	if(islist(H.internal_organs) && H.internal_organs.len)
		to_chat(user, span_info("Internal organs:"))
		for(var/obj/item/organ/O as anything in H.internal_organs)
			var/od = 0
			if(hascall(H, "get_organ_loss") && istext(O.slot) || isnum(O.slot))
				var/tmp_loss = call(H, "get_organ_loss")(O.slot)
				if(isnum(tmp_loss))
					od = tmp_loss
			if(!od)
				var/base = _dg_safe_num(O, list("damage", "organ_damage"))
				var/brorg = _dg_safe_num(O, list("brute_dam", "brute_damage"))
				var/buorg = _dg_safe_num(O, list("burn_dam", "burn_damage"))
				od = base + brorg + buorg
			to_chat(user, "• [O.name]: damage [od]")
	else
		to_chat(user, span_notice("No internal organ data available."))

	return TRUE

/proc/_dg_safe_num(datum/D, list/keys)
	if(!D || !islist(keys)) return 0
	for(var/k in keys)
		if(k in D.vars)
			var/v = D.vars[k]
			if(isnum(v))
				return v
	return 0

/obj/effect/proc_holder/spell/invoked/regrow_limbs
	name = "Limb Regeneration"
	desc = "Miraculously regrow the target's missing limbs without needing any detached parts."
	overlay_state = "regeneratelimb"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 100
	range = 1
	ignore_los = FALSE
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocations = list("Flesh, knit and return!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 100
	recharge_time = 60 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE

/obj/effect/proc_holder/spell/invoked/regrow_limbs/cast(list/targets, mob/living/user = usr)
	if(!ishuman(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]
	if(H.anti_magic_check(TRUE, TRUE))
		return FALSE

	var/list/missing = H.get_missing_limbs()
	if(!length(missing))
		to_chat(user, span_info("[H] has no missing limbs to restore."))
		return TRUE
	H.visible_message(
		span_info("[user] raises a hand - flesh knits upon [H]!"),
		span_notice("Warmth courses through me as limbs reform!")
	)

	H.regenerate_limbs(0)
	if(!(H.mob_biotypes & MOB_UNDEAD))
		for(var/obj/item/bodypart/L as anything in H.bodyparts)
			L.rotted = FALSE
			L.skeletonized = FALSE

	H.update_body()
	return TRUE

/obj/effect/proc_holder/spell/invoked/pestratouch
	name = "Pestra's touch"
	desc = "A steady benediction that mends internal organs and purges infections."
	overlay_state = "miracle"
	clothes_req = FALSE
	releasedrain = 0
	chargedrain = 0
	chargetime = 100
	range = 1
	ignore_los = FALSE
	movement_interrupt = FALSE
	sound = 'sound/magic/churn.ogg'
	spell_tier = 2
	invocations = list("By grace within, be made whole.")
	invocation_type = "whisper"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 100
	recharge_time = 60 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE

/obj/effect/proc_holder/spell/invoked/pestratouch/cast(list/targets, mob/living/user)
    if(!isliving(targets[1]))
        revert_cast()
        return FALSE
    var/mob/living/target = targets[1]
    if(target.anti_magic_check(TRUE, TRUE))
        return FALSE
    if(!ishuman(target))
        to_chat(user, span_warning("This prayer only suits mortal bodies."))
        return FALSE
    var/mob/living/carbon/human/M = target
    for(var/obj/item/organ/organny in M.internal_organs)
        M.adjustOrganLoss(organny.slot, -5)
    for(var/obj/item/bodypart/B in M.bodyparts)
        for(var/datum/wound/W in B.wounds)
            if(W.zombie_infection_timer)
                deltimer(W.zombie_infection_timer)
                W.zombie_infection_timer = null
                to_chat(M, span_warning("A searing purity burns away the rot in your [B.name]."))
            if(W.werewolf_infection_timer)
                deltimer(W.werewolf_infection_timer)
                W.werewolf_infection_timer = null
                to_chat(M, span_warning("A searing purity burns away the taint in your [B.name]."))

    M.update_damage_overlays()

    target.visible_message(
        span_info("[user] murmurs a cleansing benediction over [target]."),
        span_notice("A steady warmth mends your insides and scours away infection.")
    )
    return TRUE


// ZIZOSSY

/obj/effect/proc_holder/spell/invoked/zizo_silence
	name = "Ascendant Edict of Silencing"
	desc = "An unholy hush that stifles prayer and mercy alike. This one is of Zizo's design. Also drains devotion from divine targets."
	overlay_state = "silencezizo"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocations = list("Silence, lesser will. Zizo demands it!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 30
	recharge_time = 50 SECONDS
	miracle = TRUE

/obj/effect/proc_holder/spell/invoked/zizo_silence/cast(list/targets, mob/user = usr)
	if(!targets || !length(targets) || !targets[1] || !isliving(targets[1]))
		revert_cast()
		return FALSE

	if(!user)
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	if(target.anti_magic_check(TRUE, TRUE))
		return FALSE

	target.visible_message(
		span_warning("[user] sketches a crooked sigil in the air - the sound around [target] stutters and dies!"),
		span_warning("A cold, domineering hush clamps my throat - prayers turn to static!")
	)

	var/skill = max(1, user.get_skill_level(associated_skill))
	var/dur_ds = clamp(skill * 4, 4, 20) SECONDS
	var/caster_tier = 1
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/U = user
		if(U.devotion)
			caster_tier = max(1, U.devotion.level)
	var/drain = 50 * caster_tier
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(H.devotion && istype(H.devotion.patron, /datum/patron/divine))
			H.devotion.update_devotion(-drain, 0, silent = TRUE)
			to_chat(H, span_warning("My patron's blessing wanes! (-[drain] devotion)"))

	target.set_silence(dur_ds)
	return TRUE

//NOCUSSY

// =========================
// Blindness (better)
// =========================


/obj/effect/proc_holder/spell/invoked/lesserblindness
	name = "Noc's Veil"
	desc = "Curse a foe with a creeping veil that dims their sight."
	overlay_state = "blindness"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/churn.ogg'
	spell_tier = 2
	invocations = list("Noc blinds thee of thy sins!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 50
	recharge_time = 35 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE
	cost = 3

/obj/effect/proc_holder/spell/invoked/lesserblindness/cast(list/targets, mob/user = usr)
	. = ..()
	if(!targets || !length(targets) || !targets[1] || !isliving(targets[1]))
		revert_cast()
		return FALSE
	var/mob/living/target = targets[1]
	if(target.anti_magic_check(TRUE, TRUE))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/living_darkness_blindness))
		to_chat(user, span_warning("They are already shrouded in living darkness!"))
		revert_cast()
		return FALSE
	target.visible_message(
		span_warning("[user] points at [target]'s eyes!"),
		span_warning("A dim veil settles over my sight!")
	)
	var/level = clamp(max(1, user.get_skill_level(associated_skill)), 1, 6)
	target.apply_status_effect(/datum/status_effect/debuff/living_darkness_blindness, user, level)
	return TRUE

/datum/status_effect/debuff/living_darkness_blindness
	id = "living_darkness_blindness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/living_darkness_blindness

	effectedstats = list("perception" = -3, "fortune" = -3)
	duration = 2 SECONDS
	var/fullscreen_key = "living_darkness_tint" //keep it snowflake its important to avoid conflicts with existing tint
	var/applied = FALSE

/datum/status_effect/debuff/living_darkness_blindness/on_creation(mob/living/new_owner, mob/living/caster, potency)
	var/lvl = 1
	if(isnum(potency))
		lvl = potency
	lvl = clamp(lvl, 1, 6)
	duration = (lvl * 2) SECONDS
	return ..()

/datum/status_effect/debuff/living_darkness_blindness/on_apply()
	. = ..()
	if(!owner)
		return FALSE
	if(istype(owner, /mob/living/carbon))
		var/mob/living/carbon/C = owner
		C.overlay_fullscreen(fullscreen_key, /atom/movable/screen/fullscreen/impaired, 1)
		applied = TRUE
		C.update_sight()
	return TRUE

/datum/status_effect/debuff/living_darkness_blindness/on_remove()
	if(owner && applied && istype(owner, /mob/living/carbon))
		var/mob/living/carbon/C = owner
		C.clear_fullscreen(fullscreen_key, 0)
		C.update_sight()
	return ..()

/atom/movable/screen/alert/status_effect/debuff/living_darkness_blindness
	name = "Living Darkness"
	desc = "A dim veil clouds my vision."
	icon_state = "blind"


//SILENCE

/obj/effect/proc_holder/spell/invoked/silence
	name = "Silence"
	desc = "Clamp shut a voice by holy command, denying speech for a short while."
	overlay_state = "silence"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocations = list("Silence!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 30
	recharge_time = 45 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE

/obj/effect/proc_holder/spell/invoked/silence/cast(list/targets, mob/user = usr)
	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	if(target.anti_magic_check(TRUE, TRUE))
		return FALSE

	target.visible_message(
		span_warning("[user] gestures at [target]'s throat!"),
		span_warning("A crushing hush seals my voice!")
	)

	var/skill = max(1, user.get_skill_level(associated_skill))
	var/dur_s  = clamp(skill * 3, 3, 20)
	var/dur_ds = dur_s SECONDS

	target.set_silence(dur_ds)

	return TRUE