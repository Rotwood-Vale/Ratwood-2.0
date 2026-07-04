// Hag Boon System - Spells, Buffs, Traits, and Curses
// These are the boon datum definitions that manifest from enchanted moss and magical items

/// Base hag boon datum
/datum/hag_boon
	var/true_name
	var/datum/component/hag_curio_tracker/tracker
	var/name = "Unnamed Boon"
	var/desc = "No description"
	var/points = 50 // Default point value for crafting
	var/hag_curse = FALSE // Mark curses separately
	var/hag_is_valid = TRUE
	var/hag_trait = FALSE
	var/transmutable = TRUE

/datum/hag_boon/New(_true_name, _tracker, set_points)
	true_name = _true_name
	tracker = _tracker
	if(!isnull(set_points))
		points = set_points
	. = ..()
	apply_to_target()

/datum/hag_boon/Destroy()
	remove_from_target()
	return ..()

/datum/hag_boon/proc/find_target()
	if(tracker)
		return tracker.find_target(true_name)
	return null

/datum/hag_boon/proc/apply_to_target()
	return

/datum/hag_boon/proc/remove_from_target()
	return

// ================== SPELLS ==================

/datum/hag_boon/spell
	name = "Spell"
	var/spell_type = null

/datum/hag_boon/spell/apply_to_target()
	var/mob/living/L = find_target()
	if(!L?.mind || !spell_type)
		return
	L.mind.AddSpell(new spell_type)

/datum/hag_boon/spell/remove_from_target()
	var/mob/living/L = find_target()
	if(!L?.mind || !spell_type)
		return
	L.mind.RemoveSpell(spell_type)

/datum/hag_boon/spell/spider_speak
	name = "Spider's Whisper"
	desc = "Communicate with spiders and small creatures."
	points = 45
	spell_type = /obj/effect/proc_holder/spell/invoked/spiderspeak

/datum/hag_boon/spell/twist_food
	name = "Twist Food"
	desc = "Transform foodstuffs into nourishing meals."
	points = 60
	spell_type = /obj/effect/proc_holder/spell/self/hag_twist_food

/datum/hag_boon/spell/find_riches
	name = "Find Riches"
	desc = "Locate valuables hidden in the world."
	points = 70
	spell_type = /obj/effect/proc_holder/spell/self/hag_find_riches

/datum/hag_boon/spell/banish
	name = "Banish"
	desc = "Send enemies to distant places."
	points = 85
	spell_type = /obj/effect/proc_holder/spell/invoked/hag_banish

// ================== BUFFS ==================

/datum/hag_boon/buff
	name = "Blessing"
	var/status_type = null

/datum/hag_boon/buff/apply_to_target()
	var/mob/living/L = find_target()
	if(!L || !status_type)
		return
	L.apply_status_effect(status_type, type, tracker, points, true_name)

/datum/hag_boon/buff/remove_from_target()
	var/mob/living/L = find_target()
	if(!L || !status_type)
		return
	L.remove_status_effect(status_type)

/datum/hag_boon/buff/storm_rebirth
	name = "Storm Rebirth"
	desc = "Resilience in the face of adversity. You always come back."
	points = 65
	status_type = /datum/status_effect/buff/hag_boon/storm_rebirth

/datum/hag_boon/buff/natural_communion
	name = "Natural Communion"
	desc = "Communicate with nature itself. The forest accepts you."
	points = 40
	status_type = /datum/status_effect/buff/hag_boon/natural_communion

/datum/hag_boon/buff/creeping_moss
	name = "Creeping Moss"
	desc = "Moss grows on your skin, slowly mending wounds."
	points = 40
	status_type = /datum/status_effect/buff/hag_boon/creeping_moss

// ================== CURSES (Buffs with curse flag) ==================

/datum/hag_boon/buff/curse
	name = "Curse"
	hag_curse = TRUE
	transmutable = FALSE

/datum/hag_boon/buff/curse/choking_moss
	name = "Choking Moss"
	desc = "Thick bog-filth clings to your throat and lungs."
	points = 40
	status_type = /datum/status_effect/buff/hag_boon/creeping_moss/curse

/datum/hag_boon/buff/curse/waterlogged
	name = "Waterlogged"
	desc = "Your lungs fill with water, yet you do not drown. You are bound to the bogs."
	points = 25
	status_type = /datum/status_effect/curse/waterlogged

/datum/hag_boon/buff/curse/slumber
	name = "Cursed Slumber"
	desc = "Sleep calls to you, incessant and hungry."
	points = 20
	status_type = /datum/status_effect/curse/hag_slumber

// ================== TRAITS ==================

/datum/hag_boon/trait
	name = "Trait"
	hag_trait = TRUE
	var/trait_to_apply = null

/datum/hag_boon/trait/apply_to_target()
	var/mob/living/L = find_target()
	if(!L || !trait_to_apply)
		return
	ADD_TRAIT(L, trait_to_apply, "hag_boon")

/datum/hag_boon/trait/remove_from_target()
	var/mob/living/L = find_target()
	if(!L || !trait_to_apply)
		return
	REMOVE_TRAIT(L, trait_to_apply, "hag_boon")

/datum/hag_boon/trait/wyrd_labourer
	name = "Wyrd Labourer"
	desc = "Your hands are strong and unyielding. You can mend what others would discard."
	points = 60
	trait_to_apply = TRAIT_WYRD_LABOURER

/datum/hag_boon/trait/bogwalker
	name = "Bogwalker"
	desc = "The swamp does not slow you. You move through it as if walking on solid ground."
	points = 55

/datum/hag_boon/trait/bogwalker/apply_to_target()
	var/mob/living/L = find_target()
	if(!L)
		return
	ADD_TRAIT(L, TRAIT_LEECHIMMUNE, "hag_boon")
	ADD_TRAIT(L, TRAIT_KNEESTINGER_IMMUNITY, "hag_boon")

/datum/hag_boon/trait/bogwalker/remove_from_target()
	var/mob/living/L = find_target()
	if(!L)
		return
	REMOVE_TRAIT(L, TRAIT_LEECHIMMUNE, "hag_boon")
	REMOVE_TRAIT(L, TRAIT_KNEESTINGER_IMMUNITY, "hag_boon")

// ================== TRAIT CURSES ==================

/datum/hag_boon/trait/curse
	name = "Trait Curse"
	hag_curse = TRUE
	transmutable = FALSE

/datum/hag_boon/trait/curse/ugly
	name = "Unseemly"
	desc = "Your face becomes uncanny and wrong."
	points = 10

/datum/hag_boon/trait/curse/ugly/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_UNSEEMLY, "hag_curse")

/datum/hag_boon/trait/curse/ugly/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_UNSEEMLY, "hag_curse")

/datum/hag_boon/trait/curse/silver_weakness
	name = "Silver Weakness"
	desc = "Silver burns like holy acid."
	points = 50

/datum/hag_boon/trait/curse/silver_weakness/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_SILVER_WEAK, "hag_curse")

/datum/hag_boon/trait/curse/silver_weakness/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_SILVER_WEAK, "hag_curse")

/datum/hag_boon/trait/curse/no_run
	name = "Sluggish Limbs"
	desc = "Your legs no longer answer urgent commands."
	points = 60

/datum/hag_boon/trait/curse/no_run/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_NORUN, "hag_curse")

/datum/hag_boon/trait/curse/no_run/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_NORUN, "hag_curse")

/datum/hag_boon/trait/curse/critical_weakness
	name = "Critical Weakness"
	desc = "Blows that others survive now cripple you."
	points = 75

/datum/hag_boon/trait/curse/critical_weakness/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_CRITICAL_WEAKNESS, "hag_curse")

/datum/hag_boon/trait/curse/critical_weakness/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_CRITICAL_WEAKNESS, "hag_curse")

/datum/hag_boon/trait/curse/no_spells
	name = "Spellbane Tongue"
	desc = "Ancient words catch in your throat before they can form."
	points = 100
	hag_is_valid = TRUE

/datum/hag_boon/trait/curse/no_spells/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_SPELLCOCKBLOCK, "hag_curse")

/datum/hag_boon/trait/curse/no_spells/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_SPELLCOCKBLOCK, "hag_curse")

/datum/hag_boon/trait/curse/mute
	name = "Silenced Tongue"
	desc = "Your voice is stolen by the Mossmother."
	points = 100

/datum/hag_boon/trait/curse/mute/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_PERMAMUTE, "hag_curse")

/datum/hag_boon/trait/curse/mute/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_PERMAMUTE, "hag_curse")

/datum/hag_boon/trait/curse/no_defense
	name = "Defenseless"
	desc = "You can no longer dodge nor parry."
	points = 100

/datum/hag_boon/trait/curse/no_defense/apply_to_target()
	var/mob/living/L = find_target()
	if(L)
		ADD_TRAIT(L, TRAIT_NODEF, "hag_curse")

/datum/hag_boon/trait/curse/no_defense/remove_from_target()
	var/mob/living/L = find_target()
	if(L)
		REMOVE_TRAIT(L, TRAIT_NODEF, "hag_curse")

// ================== ITEM BOONS ==================

/datum/hag_boon/item
	name = "Item Boon"

/datum/hag_boon/item/hag_axe
	name = "Gnarled Axe"
	desc = "A wickedly sharp axe that regrows on natural turf."
	points = 80

/datum/hag_boon/item/hag_sword
	name = "Gnarled Sword"
	desc = "A perfectly balanced blade that mends itself on sacred ground."
	points = 75

/datum/hag_boon/item/hag_spear
	name = "Gnarled Polearm"
	desc = "A long reach weapon that regenerates when planted in soil."
	points = 75

/datum/hag_boon/item/wyrd_cross
	name = "Wyrd Cross"
	desc = "A mystical cross that shifts between forms to suit the wielder."
	points = 100

/datum/hag_boon/item_debt
	name = "Item Debt"
	desc = "A mounting debt tied to accepted hag-crafted artifacts."
	points = 0
	transmutable = FALSE

/datum/hag_boon/item_debt/proc/add_points(amount)
	points += max(0, amount)

/datum/hag_boon/revival_debt
	name = "Soul Tether"
	desc = "A portion of your vitality is bound to the Hag who pulled you from the brink."
	points = 50
	transmutable = FALSE

// ================== CURSES (Direct curse tree) ==================

/datum/hag_boon/curse
	name = "Curse"
	hag_curse = TRUE
	transmutable = FALSE
	var/status_type = /datum/status_effect/debuff/hag_curse

/datum/hag_boon/curse/apply_to_target()
	var/mob/living/L = find_target()
	if(!L)
		return
	L.apply_status_effect(status_type, type, tracker, points, true_name)

/datum/hag_boon/curse/remove_from_target()
	var/mob/living/L = find_target()
	if(!L)
		return
	L.remove_status_effect(status_type)

/datum/hag_boon/curse/rotting_touch
	name = "Rotting Touch"
	desc = "Your touch accelerates decay and decomposition."
	points = 65
	status_type = /datum/status_effect/debuff/hag_curse/rotting_touch

/datum/hag_boon/curse/storm_weakness
	name = "Storm-Scarred"
	desc = "Your soul was dragged back through a lightning storm and your body paid the price."
	points = 85
	status_type = /datum/status_effect/debuff/hag_curse/storm_weakness

/datum/hag_boon/curse_scar
	name = "Curse Scar"
	desc = "A lingering mark of corruption claimed by the Mossmother."
	points = 0
	transmutable = FALSE


// ================== HAG SPELLS ==================

/obj/effect/proc_holder/spell/self/hag_twist_food
	name = "Twist Food"
	desc = "Saturate your active held food with Mossmother's vitality."
	recharge_time = 20 SECONDS
	invocation_type = "whisper"
	invocations = list("Twist and thrive")

/obj/effect/proc_holder/spell/self/hag_twist_food/cast(mob/living/user)
	var/obj/item/reagent_containers/food/snacks/F = user.get_active_held_item()
	if(!istype(F))
		to_chat(user, span_warning("I must hold food in my active hand to twist it."))
		revert_cast()
		return FALSE
	if(!F.reagents)
		to_chat(user, span_warning("This meal has no essence to twist."))
		revert_cast()
		return FALSE

	F.reagents.add_reagent(/datum/reagent/consumable/nutriment, 2)
	F.reagents.add_reagent(/datum/reagent/medicine/stronghealth, 2)
	to_chat(user, span_notice("The [F] writhes briefly, now rich with unnatural vigor."))
	return TRUE


/obj/effect/proc_holder/spell/self/hag_find_riches
	name = "Find Riches"
	desc = "Coax hidden valuables from the roots beneath your feet."
	recharge_time = 90 SECONDS
	invocation_type = "whisper"
	invocations = list("Roots, reveal what glitters")

/obj/effect/proc_holder/spell/self/hag_find_riches/cast(mob/living/user)
	var/turf/T = get_turf(user)
	if(!T)
		return FALSE

	var/list/loot_table = list(
		/obj/item/roguecoin/copper/pile = 50,
		/obj/item/roguecoin/silver/pile = 25,
		/obj/item/roguecoin/gold = 8,
		/obj/item/roguegem = 4,
	)

	var/path = pickweight(loot_table)
	new path(T)
	to_chat(user, span_notice("The roots cough up a small tribute from the mud."))
	return TRUE


/obj/effect/proc_holder/spell/invoked/hag_banish
	name = "Banish"
	desc = "Attempt to cast a victim into the dream." 
	recharge_time = 3 MINUTES
	range = 7
	invocation_type = "whisper"
	invocations = list("Sink beneath the waking world")

/obj/effect/proc_holder/spell/invoked/hag_banish/cast(list/targets, mob/living/user)
	var/mob/living/carbon/human/target = targets[1]
	if(!istype(target) || target == user)
		revert_cast()
		return FALSE

	if(teleport_to_dream(target, 10000, 800))
		to_chat(user, span_notice("[target] slips into the dreambound mire."))
		return TRUE

	to_chat(user, span_warning("The dream refuses to take [target]."))
	return FALSE


// ================== HAG STATUS EFFECTS ==================

/datum/status_effect/buff/hag_boon
	id = "hag_boon_generic"
	duration = -1
	tick_interval = 5 SECONDS
	var/boon_type
	var/datum/component/hag_curio_tracker/tracker_ref
	var/boon_points = 1
	var/source_true_name
	var/suppress_tracker_cleanup = FALSE

/datum/status_effect/buff/hag_boon/on_creation(mob/living/new_owner, set_boon_type, datum/component/hag_curio_tracker/set_tracker, set_points, set_true_name)
	boon_type = set_boon_type
	tracker_ref = set_tracker
	if(set_points)
		boon_points = set_points
	if(set_true_name)
		source_true_name = set_true_name
	return ..()

/datum/status_effect/buff/hag_boon/proc/clear_source_boon()
	if(!tracker_ref || !boon_type)
		return FALSE
	var/lookup_name = source_true_name || owner?.real_name
	if(!lookup_name)
		return FALSE
	if(tracker_ref.remove_boon_by_type(lookup_name, boon_type))
		suppress_tracker_cleanup = TRUE
		return TRUE
	return FALSE

/datum/status_effect/buff/hag_boon/on_remove()
	if(!suppress_tracker_cleanup && tracker_ref && owner)
		var/lookup_name = source_true_name || owner.real_name
		if(lookup_name)
			tracker_ref.remove_boon_by_type(lookup_name, boon_type)
	return ..()


/datum/status_effect/buff/hag_boon/storm_rebirth
	id = "hag_storm_rebirth"
	alert_type = /atom/movable/screen/alert/status_effect/buff/hag_storm_rebirth
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/buff/hag_storm_rebirth
	name = "Storm Rebirth"
	desc = "Death once bends around me, but the debt it leaves behind will be severe."
	icon_state = "buff"

/datum/status_effect/buff/hag_boon/storm_rebirth/on_apply()
	if(!..())
		return FALSE
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(handle_death))
	return TRUE

/datum/status_effect/buff/hag_boon/storm_rebirth/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)
	return ..()

/datum/status_effect/buff/hag_boon/storm_rebirth/proc/handle_death(mob/living/L, gibbed)
	SIGNAL_HANDLER
	if(gibbed || !L || L.stat != DEAD)
		return

	L.visible_message(span_boldwarning("[L]'s body crackles with violent storm-energy!"))
	L.Jitter(100)
	playsound(get_turf(L), 'sound/magic/unmagnet.ogg', 100, TRUE)
	for(var/mob/living/victim in orange(2, L))
		if(victim == L)
			continue
		var/turf/throw_target = get_edge_target_turf(L, get_dir(L, victim))
		victim.throw_at(throw_target, 5, 3)

	L.grab_ghost(force = TRUE)
	L.revive(full_heal = TRUE, admin_revive = FALSE)
	if(L.mind)
		L.mind.remove_antag_datum(/datum/antagonist/zombie)
	L.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)

	var/lookup_name = source_true_name || L.real_name
	if(tracker_ref && lookup_name)
		var/datum/hag_boon/source_boon = tracker_ref.find_boon_by_type(lookup_name, boon_type)
		if(source_boon)
			tracker_ref.transmute_boons_to_curse(lookup_name, list(source_boon), /datum/hag_boon/curse/storm_weakness, 85)
		else
			tracker_ref.grant_boon(lookup_name, /datum/hag_boon/curse/storm_weakness, 85)
	else
		L.apply_status_effect(/datum/status_effect/debuff/hag_curse/storm_weakness, boon_type, tracker_ref, 85, lookup_name)

	to_chat(L, span_boldwarning("The bog drags me back to life, but leaves my body terribly frail."))
	qdel(src)


/datum/status_effect/buff/hag_boon/natural_communion
	id = "hag_natural_communion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/hag_natural_communion
	tick_interval = 2 SECONDS
	var/energy_cooldown = 0
	var/static/list/natural_turfs = list(
		/turf/open/floor/rogue/dirt,
		/turf/open/floor/rogue/snow,
		/turf/open/floor/rogue/grass,
		/turf/open/floor/rogue/grassyel,
		/turf/open/floor/rogue/grassred,
		/turf/open/floor/rogue/grasscold,
		/turf/open/water/swamp,
	)

/atom/movable/screen/alert/status_effect/buff/hag_natural_communion
	name = "Natural Communion"
	desc = "Nature replenishes me while I stand upon untamed ground."
	icon_state = "buff"

/datum/status_effect/buff/hag_boon/natural_communion/on_apply()
	energy_cooldown = world.time
	return ..()

/datum/status_effect/buff/hag_boon/natural_communion/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/turf/T = get_turf(H)
	if(!is_type_in_list(T, natural_turfs))
		return

	var/stam_regen = 0.05 * H.max_stamina
	H.stamina_add(-stam_regen)

	if(world.time >= energy_cooldown)
		energy_cooldown = world.time + 25 SECONDS
		var/energy_regen = 0.05 * H.max_energy
		H.energy_add(energy_regen)


/datum/status_effect/buff/hag_boon/creeping_moss
	id = "hag_creeping_moss"
	alert_type = /atom/movable/screen/alert/status_effect/buff/hag_creeping_moss
	duration = -1
	tick_interval = 2 SECONDS
	var/moss_layer = 0
	var/total_healed = 0
	var/heal_threshold = 200
	var/movespeed_id
	var/static/list/natural_turfs = list(
		/turf/open/floor/rogue/dirt,
		/turf/open/floor/rogue/snow,
		/turf/open/floor/rogue/grass,
		/turf/open/floor/rogue/grassyel,
		/turf/open/floor/rogue/grassred,
		/turf/open/floor/rogue/grasscold,
		/turf/open/water/swamp,
	)

/atom/movable/screen/alert/status_effect/buff/hag_creeping_moss
	name = "Creeping Moss"
	desc = "Living moss slowly creeps over my body, knitting wounds and weighing me down."
	icon_state = "buff"

/datum/status_effect/buff/hag_boon/creeping_moss/on_apply()
	movespeed_id = "hag_creeping_moss_[REF(src)]"
	return ..()

/datum/status_effect/buff/hag_boon/creeping_moss/on_remove()
	if(owner && movespeed_id)
		owner.remove_movespeed_modifier(movespeed_id)
	return ..()

/datum/status_effect/buff/hag_boon/creeping_moss/proc/update_moss_slowdown()
	if(!owner || !movespeed_id)
		return
	owner.add_movespeed_modifier(movespeed_id, update = TRUE, priority = 10, multiplicative_slowdown = (0.15 * moss_layer), movetypes = GROUND)

/datum/status_effect/buff/hag_boon/creeping_moss/proc/grow_moss()
	moss_layer = min(moss_layer + 1, 6)
	update_moss_slowdown()

/datum/status_effect/buff/hag_boon/creeping_moss/proc/trim_moss()
	moss_layer = max(moss_layer - 1, 0)
	update_moss_slowdown()

/datum/status_effect/buff/hag_boon/creeping_moss/tick()
	if(!owner)
		return

	var/turf/T = get_turf(owner)
	if(!is_type_in_list(T, natural_turfs))
		return

	if(owner.getBruteLoss() > 0)
		owner.adjustBruteLoss(-0.5, FALSE)
	if(owner.getFireLoss() > 0)
		owner.adjustFireLoss(-0.25, FALSE)

	total_healed += (2 + (2 * moss_layer))
	if(total_healed >= heal_threshold && moss_layer < 6)
		total_healed = 0
		grow_moss()


/datum/status_effect/buff/hag_boon/creeping_moss/curse
	id = "hag_choking_moss"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hag_choking_moss

/atom/movable/screen/alert/status_effect/debuff/hag_choking_moss
	name = "Choking Moss"
	desc = "Parasitic moss creeps over me and tries to force itself into my lungs."
	icon_state = "debuff"

/datum/status_effect/buff/hag_boon/creeping_moss/curse/tick()
	..()
	if(!owner)
		return
	if(moss_layer >= 6)
		owner.adjustOxyLoss(10)
		if(prob(10))
			to_chat(owner, span_userdanger("The moss forces its way into my throat. I can't breathe!"))
	if(owner.on_fire && moss_layer > 0)
		if(prob(10))
			to_chat(owner, span_danger("Flames sear away part of the parasitic moss!"))
			trim_moss()


/datum/status_effect/curse/waterlogged
	id = "hag_waterlogged"
	alert_type = /atom/movable/screen/alert/status_effect/curse/waterlogged
	duration = -1
	tick_interval = 2 SECONDS
	var/next_fall_warning = 0

/atom/movable/screen/alert/status_effect/curse/waterlogged
	name = "Waterlogged"
	desc = "Water drags at my limbs and worms its way into my lungs."
	icon_state = "debuff"

/datum/status_effect/curse/waterlogged/on_apply()
	next_fall_warning = world.time
	return ..()

/datum/status_effect/curse/waterlogged/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/turf/T = get_turf(H)
	if(!istype(T, /turf/open/water))
		return

	if(H.stat != DEAD)
		var/stam_drain = 10
		if(!H.stamina_add(stam_drain) && (H.mobility_flags & MOBILITY_STAND))
			if(world.time >= next_fall_warning)
				next_fall_warning = world.time + 10 SECONDS
				to_chat(H, span_userdanger("The murky depths claim my footing!"))
			H.Knockdown(30)
		if(!(H.mobility_flags & MOBILITY_STAND))
			H.adjustOxyLoss(6)


/datum/status_effect/curse/hag_slumber
	id = "hag_slumber"
	alert_type = /atom/movable/screen/alert/status_effect/curse/hag_slumber
	duration = -1
	tick_interval = 1 MINUTES
	var/dream_drag_armed = FALSE

/atom/movable/screen/alert/status_effect/curse/hag_slumber
	name = "Cursed Slumber"
	desc = "Natural sleep evades me, but the dream drags at my soul."
	icon_state = "debuff"

/datum/status_effect/curse/hag_slumber/on_apply()
	dream_drag_armed = FALSE
	return ..()

/datum/status_effect/curse/hag_slumber/tick()
	if(!ishuman(owner) || owner.stat == DEAD)
		return

	var/mob/living/carbon/human/H = owner
	if(H.has_status_effect(/datum/status_effect/debuff/sleepytime))
		if(dream_drag_armed)
			return
		dream_drag_armed = TRUE
		addtimer(CALLBACK(src, PROC_REF(clear_standard_sleep)), 5 SECONDS)
		to_chat(H, span_warning("My exhaustion fades... replaced by a cold, heavy pressure behind my eyes."))
		addtimer(CALLBACK(src, PROC_REF(force_dream_drag)), 1 MINUTES)
		return

	if(prob(20))
		H.apply_status_effect(/datum/status_effect/debuff/sleepytime)

/datum/status_effect/curse/hag_slumber/proc/clear_standard_sleep()
	var/mob/living/carbon/human/H = owner
	if(!H || H.stat == DEAD)
		return
	H.remove_status_effect(/datum/status_effect/debuff/sleepytime)
	to_chat(H, span_notice("Wakefulness surges through me, but something hungry tugs from the deep."))

/datum/status_effect/curse/hag_slumber/proc/force_dream_drag()
	var/mob/living/carbon/human/H = owner
	dream_drag_armed = FALSE
	if(!H || H.stat == DEAD)
		return

	to_chat(H, span_userdanger("The Dream reaches out and grips my heart!"))
	H.Knockdown(10)
	H.blur_eyes(20)
	teleport_to_dream(H, 10000, 10000)


/datum/status_effect/debuff/hag_curse
	id = "hag_curse_generic"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hag_curse
	duration = -1
	tick_interval = 5 SECONDS
	var/boon_type
	var/datum/component/hag_curio_tracker/tracker_ref
	var/curse_points = 1
	var/source_true_name
	var/suppress_tracker_cleanup = FALSE

/atom/movable/screen/alert/status_effect/debuff/hag_curse
	name = "Hag Curse"
	desc = "The Mossmother's malice festers in my body."
	icon_state = "debuff"

/datum/status_effect/debuff/hag_curse/on_creation(mob/living/new_owner, set_boon_type, datum/component/hag_curio_tracker/set_tracker, set_points, set_true_name)
	boon_type = set_boon_type
	tracker_ref = set_tracker
	if(set_points)
		curse_points = set_points
	if(set_true_name)
		source_true_name = set_true_name
	return ..()

/datum/status_effect/debuff/hag_curse/proc/clear_source_boon()
	if(!tracker_ref || !boon_type)
		return FALSE
	var/lookup_name = source_true_name || owner?.real_name
	if(!lookup_name)
		return FALSE
	if(tracker_ref.remove_boon_by_type(lookup_name, boon_type))
		suppress_tracker_cleanup = TRUE
		return TRUE
	return FALSE

/datum/status_effect/debuff/hag_curse/on_remove()
	if(!suppress_tracker_cleanup && tracker_ref && owner)
		var/lookup_name = source_true_name || owner.real_name
		if(lookup_name)
			tracker_ref.remove_boon_by_type(lookup_name, boon_type)
	return ..()


/datum/status_effect/debuff/hag_curse/storm_weakness
	id = "hag_storm_weakness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hag_storm_weakness
	needs_processing = FALSE
	effectedstats = list(
		STATKEY_CON = -5,
	)

/atom/movable/screen/alert/status_effect/debuff/hag_storm_weakness
	name = "Storm-Scarred"
	desc = "Your soul was dragged back through a lightning storm. Your physical constitution is shattered."
	icon_state = "debuff"


/datum/status_effect/debuff/hag_curse/rotting_touch
	id = "hag_rotting_touch"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hag_rotting_touch
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/hag_rotting_touch
	name = "Rotting Touch"
	desc = "Food decays to filth in my hands."
	icon_state = "debuff"

/datum/status_effect/debuff/hag_curse/rotting_touch/on_apply()
	if(!..())
		return FALSE
	RegisterSignal(owner, COMSIG_ITEM_EQUIPPED, PROC_REF(handle_touch))
	return TRUE

/datum/status_effect/debuff/hag_curse/rotting_touch/on_remove()
	UnregisterSignal(owner, COMSIG_ITEM_EQUIPPED)
	return ..()

/datum/status_effect/debuff/hag_curse/rotting_touch/proc/handle_touch(datum/source, obj/item/I, slot)
	SIGNAL_HANDLER
	if(!owner || owner.stat == DEAD || !(slot & ITEM_SLOT_HANDS))
		return

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return

	var/obj/item/reagent_containers/food/snacks/food = I
	if(!istype(food))
		return

	if(food.eat_effect == /datum/status_effect/debuff/rotfood)
		return

	to_chat(H, span_warning("Your touch withers [food] instantly!"))

	if(food.become_rot_type)
		var/obj/item/reagent_containers/food/snacks/rotten_food = new food.become_rot_type(food.loc)
		if(food.reagents && rotten_food?.reagents)
			food.reagents.trans_to(rotten_food.reagents, food.reagents.maximum_volume)
		H.dropItemToGround(food, TRUE, TRUE)
		rotten_food.forceMove(get_turf(H))
		qdel(food)
	else
		food.become_rotten()

	curse_points--

	if(curse_points <= 0)
		to_chat(H, span_notice("The oily, putrid sensation in my hands finally fades."))
		UnregisterSignal(owner, COMSIG_ITEM_EQUIPPED)
		if(!clear_source_boon())
			H.remove_status_effect(/datum/status_effect/debuff/hag_curse/rotting_touch)
