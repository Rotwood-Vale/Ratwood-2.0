/// A lesser dryad bound to a sanctified tree by the Dendor soulbind ritual.
/// Differs from the regular dryad:
///   - Does not spread vines passively
///   - No inherent vine-create spell
///   - Special attack (triggered by player's summon_lesser_dryad spell):
///       kneestingers on all 4 cardinals + 5×5 solid vine field around self
///   - Lighter, lower health than the full dryad
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser
	name = "lesser dryad"
	gender = FEMALE
	health = 450
	maxHealth = 450
	melee_damage_lower = 12
	melee_damage_upper = 18
	aggressive = FALSE
	inherent_spells = list()
	base_intents = list(/datum/intent/simple/elementalt2_unarmed/lesser_dryad)
	d_intent = INTENT_PARRY
	move_to_delay = 7 // Reasonable companion speed
	environment_smash = ENVIRONMENT_SMASH_NONE // Does not destroy vines or structures in its path
	robust_searching = TRUE // Use threshold-based stat checking (needed for stat_attack to work)
	stat_attack = SOFT_CRIT // Stops pursuing when target becomes unconscious or paralyzed
	retreat_health = 0 // Never flee at low health
	lose_patience_timeout = 0 // Never give up chasing a target
	/// Cooldown for the special attack (set by the trigger spell).
	var/special_cd = 0
	/// The conjuring player's ckey — used for faction tagging.
	var/conjurer_ckey = null
	/// Back-reference to the spell instance that summoned this dryad.
	var/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/summoner_spell
	/// Mob to follow when ordered to follow (old-style AI).
	var/mob/living/follow_target = null
	/// Turf to guard — dryad walks here and stands until given a new order.
	var/turf/guard_turf = null
	/// Direct reference to the summoning owner — used for auto-defend.
	var/mob/living/owner_mob = null
	/// Brief grace period after a follow order so stale owner-attacker refs do not immediately re-aggro.
	var/ignore_owner_defense_until = 0
	/// Bark armor: current and max integrity of the protective bark layer.
	var/bark_integrity = 250
	var/bark_max_integrity = 250
	/// Whether the bark is fully broken (no protection until repaired).
	var/bark_broken = FALSE
	/// Timer ID for the bark regeneration loop.
	var/bark_regen_timer = null
	/// Timer ID for vine-based health regeneration loop (always running).
	var/vine_regen_timer = null
	/// Timer ID for the blessed frenzy duration.
	var/frenzy_timer = null
	/// Movement speed boost level from blessed frenzy: 0 = none, 1 = 25%, 2 = 50% (bloomstone).
	var/frenzy_boost = 0
	/// Temp: damage type of the current incoming hit, used by adjustBruteLoss.
	var/last_attack_dtype = "blunt"

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/Initialize(mapload, mob/living/carbon/human/owner)
	. = ..()
	// Parent dryad sets unarmed to rank 4 (expert) — lesser inherits that directly.
	faction |= "neutral"
	if(owner)
		owner_mob = owner
		conjurer_ckey = owner.ckey
		// Tag with owner faction so minion_order/lesser_dryad can command it.
		var/faction_tag = "[owner.real_name]_faction"
		faction |= faction_tag
	// Start the vine-based self-heal loop — fires every 10 seconds.
	vine_regen_timer = addtimer(CALLBACK(src, PROC_REF(vine_heal_tick)), 100, TIMER_STOPPABLE)

/// Override vine() to do nothing — lesser dryad does not spread vines passively.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/vine()
	return

/// Override Move() to apply lesser-specific speeds: vine bonus stacks with frenzy speed boost.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/Move(newloc)
	. = ..()
	var/base_delay = (isturf(newloc) && contains_vines(newloc)) ? 5 : 7
	switch(frenzy_boost)
		if(2)  // Bloomstone frenzy: 50% faster
			move_to_delay = max(2, round(base_delay * 0.5))
		if(1)  // Normal frenzy: 25% faster
			move_to_delay = max(2, round(base_delay * 0.75))
		else
			move_to_delay = base_delay

/// Movement controller for the lesser dryad.
/// Priority: combat > defend owner > follow > guard tile > idle (stand still).
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/handle_automated_movement()
	// In combat: let the parent hostile AI handle chasing.
	if(target)
		return ..()
	// Auto-defend the summoner unless we are still inside the brief follow-order grace period.
	if(!QDELETED(owner_mob) && world.time >= ignore_owner_defense_until)
		var/mob/living/attacker = owner_mob.lastattacker_weakref?.resolve()
		if(isliving(attacker) && attacker.stat != DEAD && attacker != src && attacker != owner_mob)
			enemies |= attacker
			GiveTarget(attacker)
			toggle_ai(AI_ON)
			return
	// Follow mode: walk toward the ordered target.
	if(!QDELETED(follow_target))
		if(get_dist(src, follow_target) > 2)
			walk_towards(src, follow_target, move_to_delay)
		else
			walk(src, 0)
		return
	// Guard mode: walk to the assigned turf and stand still once arrived.
	if(guard_turf && !QDELETED(guard_turf))
		if(get_dist(src, guard_turf) > 0)
			walk_towards(src, guard_turf, move_to_delay)
		else
			walk(src, 0)
		return
	// Idle: no orders — stand still.
	walk(src, 0)

/// Self-defense: add only the direct attacker to enemies, ignoring faction allies.
/// Does NOT mass-aggro bystanders the way the default Retaliate() does.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/Retaliate()
	toggle_ai(AI_ON)
	var/mob/living/attacker = lastattacker_weakref?.resolve()
	if(isliving(attacker) && attacker != owner_mob && !faction_check_mob(attacker) && attacker.stat != DEAD)
		enemies |= attacker

/// Zone targeting priority: head → legs (if skull broken) → random (if both skull and legs broken).
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/AttackingTarget()
	if(isliving(target))
		var/mob/living/L = target
		var/skull_broken = FALSE
		for(var/datum/wound/fracture/head/W in L.get_wounds())
			skull_broken = TRUE
			break
		if(!skull_broken)
			zone_selected = BODY_ZONE_HEAD
		else
			// Head is broken — check if both legs are also fractured.
			var/legs_broken = FALSE
			if(iscarbon(target))
				var/mob/living/carbon/C = target
				for(var/legzone in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
					var/obj/item/bodypart/BP = C.get_bodypart(legzone)
					if(BP)
						for(var/datum/wound/fracture/bone in BP.wounds)
							legs_broken = TRUE
							break
					if(legs_broken)
						break
			zone_selected = legs_broken ? pick(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM) : pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	return ..()

/// Special attack: kneestingers on all 4 cardinal tiles + 5×5 solid vine area.
/// Called by /obj/effect/proc_holder/spell/targeted/lesser_dryad_special when the
/// caster targets a turf within range of their lesser dryad.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/dryad_surge(turf/surge_turf)
	if(world.time < special_cd + 40 SECONDS)
		return FALSE
	special_cd = world.time
	visible_message(span_boldwarning("[src] raises its arms — thorns and vines heed the call!"))
	playsound(get_turf(src), 'sound/magic/churn.ogg', 60, TRUE)
	var/turf/T = surge_turf || get_turf(src)
	if(!T)
		return FALSE
	// Kneestingers on cardinal tiles
	for(var/D in GLOB.cardinals)
		var/turf/adj = get_step(T, D)
		if(adj && !isclosedturf(adj) && !locate(/obj/structure/glowshroom) in adj)
			new /obj/structure/glowshroom(adj)
	// 5×5 solid vine field (RANGE_TURFS(2) = 5×5 area)
	for(var/turf/V in RANGE_TURFS(2, T))
		if(!isclosedturf(V) && !locate(/obj/structure/vine) in V)
			new /obj/structure/vine(V)
	return TRUE

/// On vine tiles: rapid_melee = 2 (50% more attacks) and melee damage boosted by 50%.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/MeleeAction(patience = TRUE)
	var/on_vine = isturf(loc) && contains_vines(loc)
	rapid_melee = on_vine ? 2 : 1
	if(on_vine)
		melee_damage_lower = initial(melee_damage_lower) * 1.5
		melee_damage_upper = initial(melee_damage_upper) * 1.5
	. = ..()
	if(on_vine)
		melee_damage_lower = initial(melee_damage_lower)
		melee_damage_upper = initial(melee_damage_upper)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/death(gibbed)
	visible_message(span_boldwarning("[src] dissolves into greenish light..."))
	playsound(get_turf(src), 'sound/items/dig_shovel.ogg', 70, TRUE)
	if(summoner_spell)
		summoner_spell.on_dryad_deleted(src)
	if(bark_regen_timer)
		deltimer(bark_regen_timer)
		bark_regen_timer = null
	if(vine_regen_timer)
		deltimer(vine_regen_timer)
		vine_regen_timer = null
	if(frenzy_timer)
		deltimer(frenzy_timer)
		frenzy_timer = null
	spill_embedded_objects()
	qdel(src)

// BARK ARMOR — protective wood that absorbs damage and regenerates slowly.
// weaker vs slash (bark splinters), decent vs blunt, stronger vs stab.

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/examine(mob/user)
	. = ..()
	. += span_info("A spirit of a sanctified tree, bound to serve by the rites of Dendor. Its bark-skin is etched with glowing sigils, and vines curl idly about its limbs. Though lesser than the great dryads of old, the fury of the forest still rides within.")

/// Record the attacker's intent damage type so adjustBruteLoss can apply correct bark reduction.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/attacked_by(obj/item/I, mob/living/user)
	if(user?.used_intent)
		last_attack_dtype = user.used_intent.item_d_type || "blunt"
	. = ..()
	last_attack_dtype = "blunt"
	if(!QDELETED(src))
		bark_delay_regen()

/// Apply bark armor reduction before brute damage is applied, then degrade bark integrity.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!bark_broken && bark_integrity > 0 && amount > 0 && !forced)
		var/reduction
		switch(last_attack_dtype)
			if("slash")
				reduction = 0.15   // Very weak vs cut — bark splinters against blades
			if("stab")
				reduction = 0.40   // Strong vs stab — bark resists puncture
			else
				reduction = 0.30   // Decent vs blunt — absorbs some impact
		var/absorbed = amount * reduction
		bark_integrity = max(0, bark_integrity - amount)  // Raw incoming damage erodes bark
		amount = max(0, amount - absorbed)
		if(bark_integrity <= 0 && !bark_broken)
			bark_broken = TRUE
			visible_message(span_boldwarning("[src]'s protective bark splinters and breaks!"))
	return ..(amount, updating_health, forced)

/// Restart the regen countdown — called after every hit so regen waits until combat ends.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/bark_delay_regen()
	if(bark_regen_timer)
		deltimer(bark_regen_timer)
		bark_regen_timer = null
	bark_regen_timer = addtimer(CALLBACK(src, PROC_REF(bark_regen_tick)), 100, TIMER_STOPPABLE)  // 10 second combat gap

/// Periodic regen tick: restores 25% of max integrity per tick (or 50% if standing on vines) until full.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/bark_regen_tick()
	bark_regen_timer = null
	if(QDELETED(src) || stat == DEAD)
		return
	var/regen_pct = (isturf(loc) && contains_vines(loc)) ? 0.50 : 0.25
	bark_integrity = min(bark_max_integrity, bark_integrity + round(bark_max_integrity * regen_pct))
	if(bark_integrity >= bark_max_integrity)
		bark_broken = FALSE
		return
	bark_regen_timer = addtimer(CALLBACK(src, PROC_REF(bark_regen_tick)), 100, TIMER_STOPPABLE)  // Continue every 10s

/// Periodic vine-aura self-heal: fires every 30 seconds regardless of combat.
/// Applies a half-strength healing aura when the dryad is standing on vines.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/vine_heal_tick()
	vine_regen_timer = null
	if(QDELETED(src) || stat == DEAD)
		return
	if(isturf(loc) && contains_vines(loc) && health < maxHealth)
		if(!has_status_effect(/datum/status_effect/buff/healing))
			apply_status_effect(/datum/status_effect/buff/healing, 1.5)
		visible_message(span_notice("[src] mends itself in the vines."))
	vine_regen_timer = addtimer(CALLBACK(src, PROC_REF(vine_heal_tick)), 100, TIMER_STOPPABLE)  // Repeat every 10 s

/// Apply a Dendor-blessed frenzy: reduces melee_cooldown for 5 seconds.
/// bloomstone_boost — if TRUE, gives 50% speed boost (bloomstone held); otherwise 25%.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/apply_blessed_frenzy(bloomstone_boost = FALSE)
	if(frenzy_timer)
		deltimer(frenzy_timer)
		frenzy_timer = null
	if(bloomstone_boost)
		melee_cooldown = round(initial(melee_cooldown) * 0.5)
		frenzy_boost = 2
		visible_message(span_boldwarning("[src] blazes with the Treefather's fury — its movements become a blur!"))
	else
		melee_cooldown = round(initial(melee_cooldown) * 0.75)
		frenzy_boost = 1
		visible_message(span_warning("[src] surges with Dendor's blessing, striking faster!"))
	// Visual: druid-armor-style light radius + Living Light outline.
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("dryad_frenzy_outline", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 60, "size" = 1))
	frenzy_timer = addtimer(CALLBACK(src, PROC_REF(end_frenzy)), 50, TIMER_STOPPABLE)  // 5 seconds

/// Revert melee_cooldown, movement speed, light, and outline after the frenzy expires.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/end_frenzy()
	frenzy_timer = null
	melee_cooldown = initial(melee_cooldown)
	frenzy_boost = 0
	set_light(0)
	remove_filter("dryad_frenzy_outline")

/// Override the default parry formula so the dryad can actually block attacks.
/// The standard formula is tuned for players with weapons/bracers; without those items
/// the chance floors at 5% against any skilled attacker. This replacement uses a
/// simplified skill comparison that gives the dryad real parry capability.
/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/attempt_parry(datum/intent/intenty, mob/living/user)
	// Can only react to attacks from the front.
	if(!can_see_cone(user))
		return FALSE
	// Respect parry cooldown inherited from hostile.dm (setparrytime = 30).
	if(world.time < last_parry + setparrytime)
		return FALSE
	// Some incoming intents cannot be parried (e.g. grab, jump).
	if(intenty && !intenty.canparry)
		return FALSE
	last_parry = world.time
	// Expert unarmed (rank 4) = 48% base. Each attacker skill level costs 7%.
	var/prob2defend = get_skill_level(/datum/skill/combat/unarmed) * 12
	var/attacker_skill = intenty?.masteritem ? user.get_skill_level(intenty.masteritem.associated_skill) \
											: user.get_skill_level(/datum/skill/combat/unarmed)
	prob2defend -= (attacker_skill * 7)
	prob2defend = clamp(prob2defend, 5, 75)
	if(!prob(prob2defend))
		return FALSE
	return do_unarmed_parry(0, user)
