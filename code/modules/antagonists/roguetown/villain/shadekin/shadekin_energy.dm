/// Component that manages shadekin shadow abilities using the mob's native energy bar.
/// Handles void walk state, passive dark healing, and forced sleep on energy depletion.
/datum/component/shadekin_energy
	var/void_walking = FALSE
	var/void_walk_drain = 0.5
	var/dark_heal_rate = 0.4
	var/forced_sleep = FALSE
	var/dark_energy_regen = 2
	var/dim_energy_regen = 1

/datum/component/shadekin_energy/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/component/shadekin_energy/Destroy()
	UnregisterSignal(parent, COMSIG_LIVING_LIFE)
	return ..()

/// Called every life tick - handles void walk drain, dark healing, energy regen in dark, and forced sleep
/datum/component/shadekin_energy/proc/on_life(datum/source)
	SIGNAL_HANDLER
	var/mob/living/L = parent
	if(!L || QDELETED(L) || L.stat == DEAD)
		return

	var/turf/T = get_turf(L)
	if(!T)
		return
	var/lum = T.get_lumcount()
	var/is_in_dark = (lum < 0.2)
	var/is_in_dim = (lum >= 0.2 && lum < 0.5)
	var/is_sleeping = (L.stat == UNCONSCIOUS || L.IsSleeping())

	if(void_walking)
		L.energy_add(-void_walk_drain)
		if(L.energy <= 0)
			exit_void_walk(L)
			force_sleep(L)
			return

	// Bonus energy regen in darkness/dim (on top of normal energy regen)
	if(is_in_dark)
		L.energy_add(dark_energy_regen)
	else if(is_in_dim)
		L.energy_add(dim_energy_regen)

	// Wake up from forced sleep once energy is sufficiently restored
	if(forced_sleep && is_sleeping && L.energy >= (L.max_energy * 0.5))
		forced_sleep = FALSE

	// Passive dark healing
	if(is_in_dark && !void_walking && L.stat != DEAD)
		apply_dark_healing(L)

/// Apply passive healing in darkness
/datum/component/shadekin_energy/proc/apply_dark_healing(mob/living/L)
	if(L.getBruteLoss() > 0)
		L.adjustBruteLoss(-dark_heal_rate)
	if(L.getFireLoss() > 0)
		L.adjustFireLoss(-dark_heal_rate)

/// Force the shadekin to sleep when energy runs out
/datum/component/shadekin_energy/proc/force_sleep(mob/living/L)
	forced_sleep = TRUE
	to_chat(L, span_userdanger("My energy is completely spent! Darkness overwhelms me as I collapse into slumber..."))
	L.visible_message(span_warning("[L] suddenly collapses, falling into a deep sleep!"), \
		span_userdanger("The shadows claim me... I fall into a deep slumber."))
	L.Sleeping(200)
	L.SetSleeping(200)

/// Enter void walk state
/datum/component/shadekin_energy/proc/enter_void_walk(mob/living/L)
	if(L.energy < (L.max_energy * 0.15))
		to_chat(L, span_warning("I don't have enough energy to enter the void."))
		return FALSE
	void_walking = TRUE
	return TRUE

/// Exit void walk state
/datum/component/shadekin_energy/proc/exit_void_walk(mob/living/L)
	void_walking = FALSE
