// ============================================================
// Druidic Staff
// A sacred staff infused with Dendor's living power.
// Has 10 charges that regenerate over time.
// Middle-click while wielding (two-handed):
//   - Targets unblessed planted soil nearby: AOE bless within range 4.
//   - Targets anything else: spawn Dendor vine on that turf.
// ============================================================

/obj/item/rogueweapon/woodstaff/druidic_staff
	name = "druidic staff"
	desc = "A living staff of emerald-green wood, imbued with Dendor's blessing. Its bloomstone focus pulses with mystical power."
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "emeraldstaff"
	slot_flags = ITEM_SLOT_HANDS | ITEM_SLOT_BACK
	anvilrepair = /datum/skill/magic/druidic
	// Do not inherit gem-staff slapcrafting upgrades.
	register_gem_slapcrafting = FALSE
	// Override combat intents — druidic staff uses blunt polearm strikes, not arcane arcing.
	// Alt-intent (RMB self while wielded): dazing strike.
	possible_item_intents = list(SPEAR_BASH, /datum/intent/mace/strike/wood)
	gripped_intents = list(SPEAR_BASH, /datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood, /datum/intent/effect/daze)
	/// Allows this staff to substitute for a harvest bloomstone in druidic crafting recipes.
	tool_behaviour = TOOL_DRUIDIC_CATALYST
	/// Current charges. Regens 1 per 60s via SSprocessing.
	var/charges = 10
	/// Maximum charges.
	var/max_charges = 10
	/// Elapsed time accumulator for charge regen (in deciseconds).
	var/regen_elapsed = 0
	/// Middle-click cooldown — world.time must exceed this to act.
	var/middle_click_cooldown = 0
	/// Whether we are currently registered for middle-click on the wielder.
	var/signals_registered = FALSE
	/// The mob the middle-click signal is currently registered on, if any.
	var/mob/registered_on = null

/obj/item/rogueweapon/woodstaff/druidic_staff/Initialize(mapload)
	. = ..()
	// Do not START_PROCESSING here — charges start at max_charges, so process() would
	// immediately return PROCESS_KILL. handle_middle_click restarts processing when needed.
	set_light(1, 1, 2, l_color = "#73c47a")
	add_filter("druid_blessed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/rogueweapon/woodstaff/druidic_staff/OnCrafted(direction, mob/user)
	. = ..()  
	// del_reqs called qdel() on the bloomstone which returned QDEL_HINT_LETMELIVE,
	// decrementing one charge but keeping it alive. Use del() here to bypass Destroy()
	// entirely so no stone dust is spawned and the stone is cleanly removed.
	if(!user)
		return
	// Check hands first — del_reqs searches hands (and adjacent turfs), not pockets.
	for(var/obj/item/alch/bloomstone/BS in list(user.get_active_held_item(), user.get_inactive_held_item()))
		del(BS)
		return
	// Check the user's turf and all adjacent turfs (matches del_reqs search range).
	for(var/turf/T in range(1, user))
		for(var/obj/item/alch/bloomstone/BS in T)
			del(BS)
			return
/obj/item/rogueweapon/woodstaff/druidic_staff/Destroy()
	if(signals_registered && registered_on)
		_unregister_signals(registered_on)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/rogueweapon/woodstaff/druidic_staff/process(delta_time)
	if(charges >= max_charges)
		return PROCESS_KILL
	regen_elapsed += delta_time
	if(regen_elapsed >= 600)  // 600 dcs = 60 seconds per charge
		regen_elapsed -= 600
		charges = min(charges + 1, max_charges)
		if(charges >= max_charges)
			return PROCESS_KILL

/obj/item/rogueweapon/woodstaff/druidic_staff/examine(mob/user)
	. = ..()
	. += span_info("It has [charges]/[max_charges] charges. Middle-click while wielding: AOE bless unblessed soil plots, or entwine turfs with vines.")

// ---- Equipped / dropped ---------------------------------------------------

/obj/item/rogueweapon/woodstaff/druidic_staff/equipped(mob/user, slot, initial = FALSE, silent = FALSE)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	if(slot & ITEM_SLOT_HANDS)
		_register_signals(user)

/obj/item/rogueweapon/woodstaff/druidic_staff/dropped(mob/user, silent = FALSE)
	. = ..()
	_unregister_signals(user)

/// Registers the middle-click and mob-deletion signals on the given wielder.
/obj/item/rogueweapon/woodstaff/druidic_staff/proc/_register_signals(mob/living/carbon/human/user)
	if(signals_registered)
		return
	signals_registered = TRUE
	registered_on = user
	RegisterSignal(user, COMSIG_MOB_MIDDLECLICKON, PROC_REF(handle_middle_click))
	RegisterSignal(user, COMSIG_QDELETING, PROC_REF(on_registered_mob_deleted))

/// Unregisters all druidic-staff signals from the given mob and clears tracking vars.
/obj/item/rogueweapon/woodstaff/druidic_staff/proc/_unregister_signals(mob/user)
	if(!signals_registered)
		return
	signals_registered = FALSE
	registered_on = null
	UnregisterSignal(user, COMSIG_MOB_MIDDLECLICKON)
	UnregisterSignal(user, COMSIG_QDELETING)

/// Signal handler — fires when the mob we registered signals on is deleted.
/// Clears tracking state so Destroy() skips the unregister attempt on an already-gone mob.
/obj/item/rogueweapon/woodstaff/druidic_staff/proc/on_registered_mob_deleted(datum/source)
	SIGNAL_HANDLER
	signals_registered = FALSE
	registered_on = null

// ---- Middle-click handler -------------------------------------------------

/// Fires on COMSIG_MOB_MIDDLECLICKON while the staff is wielded.
/// Branches on the target: unblessed soil → AOE bless, old/burnt tree → reinvigorate, else → vine+glowshroom.
/obj/item/rogueweapon/woodstaff/druidic_staff/proc/handle_middle_click(mob/living/carbon/human/user, atom/target)
	SIGNAL_HANDLER
	// Skill gate — Journeyman Druidic Trickery required.
	if(user.get_skill_level(/datum/skill/magic/druidic) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("The staff's power eludes me — Journeyman Druidic Trickery is required."))
		return COMSIG_MOB_CANCEL_CLICKON

	// Must be wielded (two-handed) to channel power.
	if(!wielded)
		to_chat(user, span_warning("I must wield the druidic staff with both hands to channel its power."))
		return COMSIG_MOB_CANCEL_CLICKON

	// Charge check.
	if(charges <= 0)
		to_chat(user, span_warning("The druidic staff has no charges remaining. It needs time to regenerate."))
		return COMSIG_MOB_CANCEL_CLICKON

	// Range check — must be within 4 tiles.
	if(get_dist(user, target) > 4)
		return

	// Cooldown check.
	if(world.time < middle_click_cooldown)
		to_chat(user, span_warning("The staff needs a moment to channel again."))
		return COMSIG_MOB_CANCEL_CLICKON

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return

	// Branch: target is or is on a soil plot → AOE bless unblessed planted soils within range 4.
	var/obj/structure/soil/target_soil = null
	if(istype(target, /obj/structure/soil))
		target_soil = target
	else
		target_soil = locate(/obj/structure/soil) in target_turf

	if(target_soil)
		var/amount_blessed = 0
		for(var/obj/structure/soil/soil in range(4, user))
			if(!soil.plant || soil.blessed_time > 0) // Skip plantless or already-blessed plots
				continue
			soil.bless_soil()
			amount_blessed++
		if(amount_blessed <= 0)
			to_chat(user, span_warning("There are no nearby unblessed planted soil plots to bless."))
			return COMSIG_MOB_CANCEL_CLICKON
		charges--
		src.obj_integrity -= (src.max_integrity * 0.02)
		START_PROCESSING(SSprocessing, src)
		middle_click_cooldown = world.time + 100 // 10 seconds
		playsound(get_turf(user), 'sound/magic/churn.ogg', 60, TRUE)
		user.visible_message(span_green("[user] channels Dendor's power through the druidic staff, blessing nearby crops!"), span_green("Dendor's blessing channels from the staff, blessing nearby crops!"))
		return COMSIG_MOB_CANCEL_CLICKON

	// Branch: target is or is on an old or burnt tree → reinvigorate it.
	var/obj/structure/flora/roguetree/target_tree = null
	if(istype(target, /obj/structure/flora/roguetree) && !istype(target, /obj/structure/flora/roguetree/wise) && !istype(target, /obj/structure/flora/roguetree/evil))
		target_tree = target
	else
		for(var/obj/structure/flora/roguetree/RT in target_turf)
			if(!istype(RT, /obj/structure/flora/roguetree/wise) && !istype(RT, /obj/structure/flora/roguetree/evil))
				target_tree = RT
				break
	if(target_tree)
		if(target_tree.reinvigorate_tree(user))
			charges--
			src.obj_integrity -= (src.max_integrity * 0.02)
			START_PROCESSING(SSprocessing, src)
			middle_click_cooldown = world.time + 100 // 10 seconds
			playsound(get_turf(user), 'sound/magic/churn.ogg', 60, TRUE)
			user.visible_message(span_green("[user] draws the druidic staff before [target_tree] — life surges back into the withered bark!"), span_green("You channel the Treefather's power into [target_tree] through the druidic staff!"))
			return COMSIG_MOB_CANCEL_CLICKON
		to_chat(user, span_warning("This tree cannot be reinvigorated."))
		return COMSIG_MOB_CANCEL_CLICKON

	// Branch: permanently-trimmed fey mushroom circle or mature bush — re-enable overgrowth timer.
	var/obj/structure/mushroom_circle/fey/MC = istype(target, /obj/structure/mushroom_circle/fey) ? target : locate(/obj/structure/mushroom_circle/fey) in target_turf
	if(MC && MC.active && MC.permanently_trimmed)
		MC.receive_bless_crop()
		charges--
		src.obj_integrity -= (src.max_integrity * 0.02)
		START_PROCESSING(SSprocessing, src)
		middle_click_cooldown = world.time + 100
		playsound(get_turf(user), 'sound/magic/churn.ogg', 60, TRUE)
		user.visible_message(span_green("[user] channels the Treefather's power into [MC] — the fey energies stir anew!"), span_green("You channel the Treefather's power into [MC] — the fey energies stir anew!"))
		return COMSIG_MOB_CANCEL_CLICKON
	var/obj/structure/bush_sapling/bush = istype(target, /obj/structure/bush_sapling) ? target : locate(/obj/structure/bush_sapling) in target_turf
	if(bush && bush.stage == BUSHSAP_STAGE_MATURE && !bush.dead && bush.permanently_trimmed)
		bush.receive_bless_crop()
		charges--
		src.obj_integrity -= (src.max_integrity * 0.02)
		START_PROCESSING(SSprocessing, src)
		middle_click_cooldown = world.time + 100
		playsound(get_turf(user), 'sound/magic/churn.ogg', 60, TRUE)
		user.visible_message(span_green("[user] channels the Treefather's power into [bush] — growth stirs anew!"), span_green("You channel the Treefather's power into [bush] — growth stirs anew!"))
		return COMSIG_MOB_CANCEL_CLICKON

	// Branch: anything else → spawn a vine and kneestinger on the target turf.
	if(!locate(/obj/structure/vine/dendor) in target_turf)
		new /obj/structure/vine/dendor(target_turf)
	if(!locate(/obj/structure/glowshroom) in target_turf)
		new /obj/structure/glowshroom(target_turf)
	charges--
	src.obj_integrity -= (src.max_integrity * 0.02)
	START_PROCESSING(SSprocessing, src)
	middle_click_cooldown = world.time + 100 // 10 seconds
	playsound(get_turf(user), 'sound/magic/churn.ogg', 60, TRUE)
	user.visible_message(span_green("[user] directs the druidic staff at [target] — vines erupt from the ground!"), span_green("You direct the druidic staff at [target] — vines erupt from the ground!"))
	return COMSIG_MOB_CANCEL_CLICKON

// ============================================================
// Druidic Staff Crafting Recipe
// ============================================================

/datum/crafting_recipe/roguetown/druidic/druidic_staff
	name = "druidic staff"
	result = /obj/item/rogueweapon/woodstaff/druidic_staff
	reqs = list(
		/obj/item/rogueweapon/woodstaff = 1,
		/obj/item/grown/log/tree/blessed = 1,
		/obj/item/alch/bloomstone = 1
	)
	craftdiff = SKILL_LEVEL_MASTER
	craftsound = 'sound/foley/bandage.ogg'
	verbage_simple = "channel"
	verbage = "channels"
