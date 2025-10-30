// Jitterskull — a small, jittery floating skull for Halloween

/mob/living/simple_animal/hostile/rogue/jitterskull
    name = "jitterskull"
    desc = "A ghoul of some kind, probably from a forest."
    icon = 'icons/roguetown/mob/monster/jitterskull.dmi'
    icon_state = "jitany"
    icon_living = "jitany"
    icon_dead = null
    mob_biotypes = MOB_UNDEAD|MOB_SPIRIT
    movement_type = FLYING
    environment_smash = ENVIRONMENT_SMASH_NONE
    pass_flags = PASSTABLE|PASSGRILLE
    // Use a blunt, non-cutting base intent; custom bite damage is applied separately
    // Jitterskull uses a special crush intent that rips through armor and heavily damages integrity
    base_intents = list(/datum/intent/simple/jitterskull_crush)
    gender = NEUTER
    speak_chance = 0
    // Move faster to help it secure hits
    turns_per_move = 2
    response_help_continuous = "passes through"
    response_help_simple = "pass through"
    maxHealth = 1000
    health = 1000
    spacewalk = TRUE
    stat_attack = UNCONSCIOUS
    robust_searching = 1
    // Faster than average
    speed = -0.9
    move_to_delay = 1
    harm_intent_damage = 1
    obj_damage = 1
    // Use custom bite attack; keep minimal base damage so base attack flow (hit/miss/defense) still runs
    // We'll apply the heavy damage ourselves in AttackingTarget()
    melee_damage_lower = 1
    melee_damage_upper = 1
    d_type = "blunt"
    attack_verb_simple = "bites"
    attack_verb_continuous = "bites"
    armor_penetration = 100
    // It attacks anything and everything
    attack_same = TRUE
    attack_sound = 'sound/combat/wooshes/bladed/wooshmed (1).ogg'
    dodge_sound = 'sound/combat/dodge.ogg'
    parry_sound = "bladedmedium"
    d_intent = INTENT_PARRY
    speak_emote = list("chatters")
    del_on_death = TRUE
    STALUC = 10
    STASTR = 20
    STACON = 20
    STASPD = 18
    atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
    minbodytemp = 0
    // Empty faction so basic targeting treats everything as valid
    faction = list()
    footstep_type = null
    defprob = 40
    canparry = TRUE
    retreat_health = null
    can_have_ai = FALSE // disable native simple_animal AI; we use an ai_controller
    AIStatus = AI_OFF
    ai_controller = /datum/ai_controller/haunt

    // Behavior control
    var/next_attack_time = 0       // world.time until which we will refrain from attacking
    var/teleport_cooldown_until = 0 // throttle for on-hit teleport reactions
    var/next_idle_chatter_time = 0  // next time we're allowed to idle-chatter
    var/taunt_cooldown_until = 0    // cooldown for taunting after a down
    var/is_dying = FALSE            // guard to prevent re-entrant death sequences
    var/mob/living/reengage_target  // who we plan to reengage after a panic blink
    var/original_alpha = 255
    var/suppress_panic_until = 0      // during/after a strike, ignore panic blink to avoid double-teleport
    var/attack_pose_until = 0         // world.time until which we should remain in attack pose
    var/attack_swing_until = 0        // window covering the active swing where we might ignore counter-hits
    var/ignore_hits_this_swing = FALSE // 50% chance: during attack swing, ignore incoming strikes (no pain/teleport)
    var/next_grab_counter_time = 0    // cooldown before we do another anti-grab counter
    // Critical finisher throttle
    var/next_critical_available_time = 0 // world.time when we can attempt a critical finisher again
    // Near-instant attack cadence
    melee_cooldown = 0.1 SECONDS
    var/is_feasting = FALSE         // currently lingering and consuming an unconscious target
    // Anti-stuck tracking
    var/last_stuck_x = 0
    var/last_stuck_y = 0
    var/stuck_ticks = 0
    // Stalking and aggression flags
    var/is_stalking = FALSE        // briefly TRUE when we blink away and "stare" before re-engaging
    var/angry_until = 0            // during this window, skip whiffs and any artificial waiting
    // Vendetta focus: keep attention on whoever last hurt us for a while
    var/mob/living/vendetta_target = null
    var/vendetta_until = 0
    // Tether throttle to avoid spam teleports
    var/next_tether_allowed = 0
    // Guarding: linger around a helpless target before feasting
    var/is_guarding = FALSE
    var/mob/living/guarding_target = null
    var/guarding_until = 0
    // Searching mode: low alpha while looking for next prey
    var/is_searching = FALSE
    var/next_search_announce_time = 0
    var/no_target_since = 0
    // After a stalk pause ends, briefly guarantee we actually swing instead of trailing
    var/primed_attack_until = 0
    // Track last time we processed post-attack flow to avoid double-handling when mixing signals and fallbacks
    var/last_attack_flow_at = 0


/mob/living/simple_animal/hostile/rogue/jitterskull/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
    return FALSE

/mob/living/simple_animal/hostile/rogue/jitterskull/Initialize()
    . = ..()
    set_light(1.5, 1.5, 2, l_color = "#e6dfbb")
    ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
    ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
    original_alpha = alpha
    // Run our custom bite logic whenever a melee attack succeeds (works with ai_controller ClickOn flow)
    RegisterSignal(src, COMSIG_MOB_AFTERATTACK_SUCCESS, PROC_REF(on_after_attack_success))
    // Make the AI controller move snappier for this pawn
    if(istype(ai_controller))
        var/datum/ai_controller/C = ai_controller
        // Make pathing more responsive so it closes distance quicker
        C.movement_delay = 0.2 SECONDS
    // Start idle chatter loop
    spawn(0)
        idle_chatter_loop()
    // Play spawn cinematic and then resume regular behavior
    spawn(0)
        spawn_cinematic()
    // Periodically reacquire humanoid targets if we "forget" them
    spawn(0)
        search_for_humanoids_loop()
    // Anti-stuck: if we're not making progress toward the target, blink closer and continue stalking
    spawn(0)
        anti_stuck_stalker_loop()
    // Persistent pursuit tether: if the target runs far, re-tether near them periodically
    spawn(0)
        pursuit_tether_loop()

/mob/living/simple_animal/hostile/rogue/jitterskull/Destroy()
    set_light(0)
    UnregisterSignal(src, COMSIG_MOB_AFTERATTACK_SUCCESS)
    . = ..()

// Cinematic: on spawn, appear semi-transparent with smoke, a unique sprite, and a spawn sound.
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/spawn_cinematic()
    if(QDELETED(src) || stat == DEAD)
        return
    // Briefly delay aggression during spawn effect
    next_attack_time = max(next_attack_time, world.time + 20)
    // Be stationary for a short moment to sell the spawn
    Immobilize(15)
    // Visual and audio
    icon_state = "jitspawn"
    alpha = original_alpha
    playsound(src, 'sound/mobs/jitter_spawn.ogg', 80, FALSE)
    // Two quick pulses of smoke around the skull
    spawn_smoke_ring(1)
    sleep(5)
    spawn_smoke_ring(2)
    // Restore visuals shortly after
    sleep(10)
    if(QDELETED(src) || stat == DEAD)
        return
    icon_state = icon_living
    alpha = original_alpha

// Helper: spawn decorative smoke puffs in a ring around us
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/spawn_smoke_ring(radius = 1)
    var/turf/T = get_turf(src)
    if(!T)
        return
    for(var/dx in -radius to radius)
        for(var/dy in -radius to radius)
            if(!dx && !dy)
                continue
            if(abs(dx) != radius && abs(dy) != radius)
                continue // ring only
            var/turf/cur = locate(T.x + dx, T.y + dy, T.z)
            if(!cur || cur.density)
                continue
            new /obj/effect/temp_visual/small_smoke(cur)

// Periodic search: if we lack a target, look specifically for humanoids and set the AI's target
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/search_for_humanoids_loop()
    while(src && !QDELETED(src))
        if(stat != DEAD && !is_feasting && !is_dying)
            // Only act if our AI lacks a current target
            if(ai_controller)
                var/datum/ai_controller/C = ai_controller
                var/mob/current = C.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
                // If we are intentionally stalking or guarding, do not reacquire/alter targets here.
                if(is_stalking || is_guarding)
                    sleep(10)
                    continue
                // If we have a current target and it's helpless, close in and begin guarding
                if(isliving(current))
                    var/mob/living/CH = current
                    if((CH.stat == UNCONSCIOUS || CH.stat == DEAD) && !is_feasting && !is_guarding)
                        if(get_dist(src, CH) > 2)
                            teleport_near_atom(CH, 1, 2)
                        begin_guarding(CH)
                        sleep(10)
                        continue
                // If we currently have a valid target, ensure search visuals are off and timer reset
                if(current && !QDELETED(current) && !(isliving(current) && current:stat == DEAD))
                    if(is_searching)
                        is_searching = FALSE
                        alpha = original_alpha
                    no_target_since = 0
                else
                    // No current target: try vendetta first to avoid search flicker
                    if(vendetta_target && world.time < vendetta_until && !QDELETED(vendetta_target) && (!isliving(vendetta_target) || vendetta_target:stat != DEAD))
                        C.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, vendetta_target)
                        if(is_searching)
                            is_searching = FALSE
                            alpha = original_alpha
                        no_target_since = 0
                        sleep(10)
                        continue
                    // Track how long we've been without a target
                    if(!no_target_since)
                        no_target_since = world.time
                    // After a short debounce without a target, enter search visuals/narration
                    if(world.time >= no_target_since + 30)
                        if(!is_searching)
                            is_searching = TRUE
                            if(alpha != 25)
                                alpha = 25
                            if(world.time >= next_search_announce_time)
                                visible_message(span_notice("The Jitterskull searches for it's next prey."))
                                next_search_announce_time = world.time + 50
                    var/mob/living/carbon/human/best = null
                    var/best_dist = INFINITY
                    // Prefer humanoids in a decent radius
                    // Look a bit farther to avoid dropping interest when someone barely leaves sight
                    for(var/mob/living/carbon/human/H in view(48, src))
                        if(QDELETED(H) || H.stat == DEAD)
                            continue
                        // Ignore if invisible to us
                        if(see_invisible < H.invisibility)
                            continue
                        var/d = get_dist(src, H)
                        if(d < best_dist)
                            best = H; best_dist = d
                    if(best)
                        C.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, best)
                        if(is_searching)
                            is_searching = FALSE
                            alpha = original_alpha
                        no_target_since = 0
        sleep(10) // ~1 second

// Bias default simple_animal target selection toward humanoids (used as fallback outside ai_controller)
/mob/living/simple_animal/hostile/rogue/jitterskull/PickTarget(list/Targets)
    if(!Targets || !Targets.len)
        return ..(Targets)
    // Extract humanoids from the list
    var/list/humans = list()
    for(var/A in Targets)
        if(istype(A, /mob/living/carbon/human))
            humans += A
    var/atom/choose_from = null
    if(humans.len)
        // Pick nearest humanoid
        var/atom/best = null
        var/best_dist = INFINITY
        for(var/atom/H in humans)
            var/d = get_dist(src, H)
            if(d < best_dist)
                best = H; best_dist = d
        choose_from = best
    else
        // No humanoids — fall back to nearest of anything valid
        var/atom/any_best = null
        var/any_best_dist = INFINITY
        for(var/atom/B in Targets)
            var/d2 = get_dist(src, B)
            if(d2 < any_best_dist)
                any_best = B; any_best_dist = d2
        choose_from = any_best
    return choose_from
/mob/living/simple_animal/hostile/rogue/jitterskull/grabbedby(mob/living/carbon/user, supress_message = FALSE, item_override)
    // Allow default grab logic
    . = ..()
    // If newly grabbed and not already countering, schedule an arm-chomp after a short telegraph
    if(world.time >= next_grab_counter_time && length(grabbedby))
        // Find an active grab object from this grabber (if provided) or any
        var/obj/item/grabbing/G = null
        for(var/obj/item/grabbing/OG in grabbedby)
            if(user && OG.grabbee == user)
                G = OG; break
            if(!G)
                G = OG
        if(G)
            next_grab_counter_time = world.time + 100 // ~10s cooldown between counters
            // Telegraph and then bite off the grabbing arm
            spawn(0)
                respond_to_grab(G)

// Telegraph and then attempt to dismember the arm the grabber is using
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/respond_to_grab(obj/item/grabbing/G)
    if(QDELETED(G) || QDELETED(src) || stat == DEAD)
        return
    var/mob/living/carbon/H = G.grabbee
    if(!H || QDELETED(H))
        return
    // Decide which arm is holding the grab
    var/which_zone = BODY_ZONE_R_ARM
    if(istype(H))
        if(H.r_grab == G)
            which_zone = BODY_ZONE_R_ARM
        else if(H.l_grab == G)
            which_zone = BODY_ZONE_L_ARM
        else
            // Fallback: random arm
            which_zone = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
    // Telegraph warning
    var/arm_name = (which_zone == BODY_ZONE_L_ARM) ? "left arm" : "right arm"
    visible_message(span_warning("[src] clamps onto [H]'s [arm_name], preparing to bite!"),
                    span_danger("[src] clamps onto my [arm_name] — it's about to bite!"))
    play_attack_pose(6)
    playsound(src, 'sound/mobs/jitter_eating.ogg', 70, FALSE)
    // Short wind-up; abort if grab breaks or we die
    var/delay = rand(12, 20)
    var/list/checks = list("health" = src.health)
    if(!do_after(user = src, delay = delay, target = H, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob, break_do_after_checks), checks, FALSE)))
        return
    if(QDELETED(G) || QDELETED(H) || !(G in grabbedby))
        return
    // Attempt to sever the grabbing arm
    var/obj/item/bodypart/BP = H.get_bodypart(which_zone)
    if(BP)
        if(!BP.dismember())
            // If dismember failed (armor?), inflict heavy brute as punishment
            H.apply_damage(45, BRUTE, which_zone)
    else
        // If arm already missing, punish the torso
        H.apply_damage(30, BRUTE, BODY_ZONE_CHEST)
    // Release the grab if still present
    if(G && !QDELETED(G))
        qdel(G)
    // Brief retreat and short cooldown before next strike to sell the moment
    teleport_away(6, 10)
    next_attack_time = max(next_attack_time, world.time + rand(8, 18))


// Show the attack pose by forcing icon_state for a short duration, then restore living state
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/play_attack_pose(ticks = 5)
    if(stat == DEAD)
        return
    icon_state = "jitatt"
    attack_pose_until = max(attack_pose_until, world.time + ticks)
    spawn(ticks)
        if(QDELETED(src) || stat == DEAD)
            return
        // Only restore if we haven't extended the pose window in the meantime
        if(world.time >= attack_pose_until)
            icon_state = icon_living

// Ensure we show the attack pose before performing an attack animation/effect
/mob/living/simple_animal/hostile/rogue/jitterskull/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect, item_animation_override = null, datum/intent/used_intent, simplified = TRUE)
    if(is_dying)
        return
    // Show pose first so players see the windup
    play_attack_pose(5)
    return ..(A, visual_effect_icon, used_item, no_effect, item_animation_override, used_intent, simplified)

// Handler: our attack just succeeded against a target — perform custom bite + effects
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/on_after_attack_success(mob/living/source, mob/living/target)
    SIGNAL_HANDLER
    if(QDELETED(target) || stat == DEAD || is_dying)
        return
    // Safety: never process if the target is ourselves
    if(target == src)
        return
    // Don’t layer bites if feasting is in progress
    if(is_feasting)
        return
    // Defer all potentially blocking work to an async helper so the signal handler itself returns immediately.
    spawn(0)
        handle_after_attack_success(target)
    return

/mob/living/simple_animal/hostile/rogue/jitterskull/proc/handle_after_attack_success(mob/living/target)
    if(QDELETED(target) || stat == DEAD || is_dying)
        return
    // Mark that we're handling this attack now (used to dedupe fallbacks)
    last_attack_flow_at = world.time
    // Visual: attack animation that lingers ~0.5s
    play_attack_pose(5)
    // Set our post-hit pause early to avoid any immediate re-engage edge cases
    next_attack_time = world.time + rand(25, 50)
    // Track target so we keep focus post-teleport
    if(isliving(target))
        reengage_target = target
    // SFX: bite
    playsound(src, 'sound/mobs/jitter_attack.ogg', 80, FALSE)
    // While resolving the strike, suppress panic reactions to avoid double teleports if we get hit back
    suppress_panic_until = world.time + 12
    // Track if we should guard after the stalk pause (when the bite downs the victim)
    var/guard_after_stalk = FALSE
    var/mob/living/guard_after_stalk_target = null
    // Heavy custom damage on top of default light hit
    if(isliving(target))
        var/mob/living/L = target
        // Refresh vendetta focus on successful hit so we keep chasing this victim
        vendetta_target = L
        vendetta_until = world.time + 600
        L.apply_damage(125, BRUTE)
        L.visible_message(span_danger("[src] viciously bites [L]!"), span_danger("[src] viciously bites me!"))
        // Shred armor: the bite mangles worn equipment severely so two bites will break most pieces
        if(iscarbon(L))
            var/mob/living/carbon/human/Harm = L
            mangle_worn_armor(Harm)
        // Apply a strong slow for a short duration
        if(iscarbon(L))
            var/mob/living/carbon/Cslow = L
            Cslow.add_movespeed_modifier("JITTERSKULL_BITE", update=TRUE, priority=100, multiplicative_slowdown=4, movetypes=GROUND)
            spawn(5 SECONDS)
                if(Cslow && !QDELETED(Cslow))
                    Cslow.remove_movespeed_modifier("JITTERSKULL_BITE")
        if(L.stat == UNCONSCIOUS && !is_feasting && !is_guarding)
            // Preserve hit-and-run: blink/stalk first, then begin guarding at the end of the pause
            guard_after_stalk = TRUE
            guard_after_stalk_target = L
        // Critical finishers on heavily brutalized targets
        if(L.getBruteLoss() >= 300 && world.time >= next_critical_available_time)
            if(critical_finisher(L))
                // Special finisher handled movement/flow
                ignore_hits_this_swing = FALSE
                return
    // Chance to startle
    if(prob(12) && iscarbon(target))
        var/mob/living/carbon/C = target
        C.Immobilize(30)
        C.visible_message(span_danger("The [src] startles the [C], freezing them in terror!"), \
            span_danger("The [src] startles me!"))
    // Taunt if they’re down
    if(isliving(target))
        var/mob/living/LL = target
        if(LL.stat && world.time >= taunt_cooldown_until)
            taunt_cooldown_until = world.time + 50
            playsound(src, 'sound/mobs/jitter_taunt.ogg', 70, FALSE)
    // Hit-and-run: blink away, then stalk low-alpha and stare for a moment
    if(target && !QDELETED(target))
        var/wait_ticks = rand(50, 150)
        if(world.time < angry_until)
            visible_message(span_warning("Because the jitterskull is angry, it begins the chase early!"))
            wait_ticks = max(0, wait_ticks - rand(40, 80))
        // Keep some space but within reliable reacquire range; slightly closer, LOS not required
        teleport_near_atom(target, 6, 9, FALSE)
        alpha = 20
        // Briefly pause and face the target to build tension
        var/dirface = get_dir(src, target)
        if(dirface)
            dir = dirface
        is_stalking = TRUE
        anchored = TRUE
        // Keep the AI target; anchoring enforces the pause without dropping aggro
        // Local narrate while stalking
        visible_message(span_notice("The jitterskull watches intently from a distance."))
        Immobilize(wait_ticks)
        next_attack_time = max(next_attack_time, world.time + wait_ticks)
        spawn(wait_ticks)
            if(!QDELETED(src))
                is_stalking = FALSE
                anchored = FALSE
                alpha = original_alpha
                // Safety: ensure we still have the target and are within engagement distance after the pause
                if(ai_controller && reengage_target && !QDELETED(reengage_target))
                    var/d2 = get_dist(src, reengage_target)
                    if(d2 >= 12)
                        teleport_near_atom(reengage_target, 6, 9, FALSE)
                    // Restore the AI's target so normal chase can resume
                    var/datum/ai_controller/Cr = ai_controller
                    if(Cr)
                        Cr.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, reengage_target)
                // Prime an immediate swing and suppress trailing
                primed_attack_until = world.time + 30
                next_attack_time = min(next_attack_time, world.time)
                // If the bite downed the victim, start guarding now (after the stalk pause)
                if(guard_after_stalk && guard_after_stalk_target && !QDELETED(guard_after_stalk_target))
                    if(get_dist(src, guard_after_stalk_target) > 2)
                        teleport_near_atom(guard_after_stalk_target, 1, 2)
                    begin_guarding(guard_after_stalk_target)
    else
        var/w2 = rand(50, 150)
        if(world.time < angry_until)
            visible_message(span_warning("Because the jitterskull is angry, it begins the chase early!"))
            w2 = max(0, w2 - rand(40, 80))
        teleport_away(8, 12)
        alpha = 20
        is_stalking = TRUE
        anchored = TRUE
        // Keep the AI target; anchoring enforces the pause without dropping aggro
        // Local narrate while stalking
        visible_message(span_notice("The jitterskull watches intently from a distance."))
        // Fully immobilize during the stalk pause and delay next attack accordingly
        Immobilize(w2)
        next_attack_time = max(next_attack_time, world.time + w2)
        spawn(w2)
            if(!QDELETED(src))
                is_stalking = FALSE
                anchored = FALSE
                alpha = original_alpha
                if(ai_controller && reengage_target && !QDELETED(reengage_target))
                    var/datum/ai_controller/Cr2 = ai_controller
                    if(Cr2)
                        Cr2.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, reengage_target)
                primed_attack_until = world.time + 30
                next_attack_time = min(next_attack_time, world.time)
    // Swing finished; clear ignore flag
    ignore_hits_this_swing = FALSE

// Fallback: if the normal success signal didn't fire (e.g., armor absorbed the damage), force our post-hit flow
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/ensure_post_attack_flow(mob/living/expected)
    if(QDELETED(src) || stat == DEAD || is_dying)
        return
    // Small delay to allow the success signal to arrive first
    sleep(2)
    if(world.time <= last_attack_flow_at + 1)
        return // already handled by success signal
    if(!expected || QDELETED(expected))
        return
    // Loosen adjacency: still require close range so we don't fire on true whiffs
    if(get_dist(src, expected) > 2)
        return
    handle_after_attack_success(expected)

// Helper: crush the integrity of worn clothing/armor so that two bites will break most gear
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/mangle_worn_armor(mob/living/carbon/human/H)
    if(!H || QDELETED(H))
        return
    // Prioritize main protection pieces first, then the rest
    var/list/body_parts = list(H.wear_armor, H.head, H.wear_pants, H.wear_shirt, H.cloak, H.wear_mask, H.gloves, H.shoes, H.wear_neck, H.wear_wrists, H.belt, H.beltl, H.beltr, H.s_store, H.glasses, H.ears, H.wear_ring)
    for(var/obj/item/I in body_parts)
        if(!I)
            continue
        if(istype(I, /obj/item/clothing))
            var/obj/item/clothing/C = I
            if(C.obj_integrity > 0)
                // Remove roughly half the remaining integrity per bite, minimum heavy chunk
                var/amt = max(round(C.max_integrity * 0.55), 80)
                C.take_damage(amt, BRUTE, "slash", armor_penetration = 100)
                if(C.obj_integrity <= 0)
                    H.visible_message(span_danger("[src]'s bite destroys [H]'s [C]!"), span_userdanger("My [C] is destroyed by the [src]!"))

// Decide and execute a critical finisher on a heavily injured target. Returns TRUE if it took over the flow (e.g., started a feast or disengaged).
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/critical_finisher(mob/living/L)
    if(QDELETED(L) || L.stat == DEAD)
        return FALSE
    if(!iscarbon(L))
        return FALSE
    var/mob/living/carbon/C = L
    var/roll = rand(1,100)
    // 60%: knockdown + leg dismember (short wind-up)
    if(roll <= 60)
        var/which_leg = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
        var/leg_name = (which_leg == BODY_ZONE_L_LEG) ? "left leg" : "right leg"
        C.visible_message(span_warning("[src] lunges low for [C]'s [leg_name]!"), span_danger("[src] lunges for my [leg_name]!"))
        play_attack_pose(6)
        // Ensure we don't ignore pain during this wind-up; any hit should interrupt
        ignore_hits_this_swing = FALSE
        attack_swing_until = 0
        var/list/checks = list("health" = src.health)
        if(!do_after(user = src, delay = rand(25, 40), target = C, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob, break_do_after_checks), checks, FALSE)))
            return FALSE
        if(QDELETED(C))
            return FALSE
        var/obj/item/bodypart/BPleg = C.get_bodypart(which_leg)
        if(BPleg)
            if(!BPleg.dismember())
                C.apply_damage(40, BRUTE, which_leg)
        else
            C.apply_damage(30, BRUTE)
        C.Knockdown(2 SECONDS)
        // Set finisher cooldown (20-40s)
        next_critical_available_time = world.time + rand(20 SECONDS, 40 SECONDS)
        return FALSE
    // 20%: arm bite/dismember
    else if(roll <= 80)
        var/which_arm = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
        var/arm_name = (which_arm == BODY_ZONE_L_ARM) ? "left arm" : "right arm"
        C.visible_message(span_warning("[src] goes for [C]'s [arm_name] with a savage bite!"), span_danger("[src] goes for my [arm_name]!"))
        play_attack_pose(5)
        var/obj/item/bodypart/BParm = C.get_bodypart(which_arm)
        if(BParm)
            if(!BParm.dismember())
                C.apply_damage(35, BRUTE, which_arm)
        else
            C.apply_damage(25, BRUTE)
        next_critical_available_time = world.time + rand(20 SECONDS, 40 SECONDS)
        return FALSE
    // 10%: artery crit
    else if(roll <= 90)
        var/obj/item/bodypart/chest/CH = C.get_bodypart(BODY_ZONE_CHEST)
        if(CH)
            CH.add_wound(/datum/wound/artery)
            C.visible_message(span_danger("[src] rends deep, opening an artery on [C]!"), span_userdanger("I feel a hot spray — an artery!"))
        else
            C.apply_damage(30, BRUTE)
        next_critical_available_time = world.time + rand(20 SECONDS, 40 SECONDS)
        return FALSE
    // 5%: head bite then immediate feast
    else if(roll <= 95)
        var/obj/item/bodypart/head/H = C.get_bodypart(BODY_ZONE_HEAD)
        C.visible_message(span_warning("[src] clamps down on [C]'s head!"), span_danger("[src] clamps down on my head!"))
        play_attack_pose(6)
        // Head finisher should also be interruptible on hit
        ignore_hits_this_swing = FALSE
        attack_swing_until = 0
        var/list/checks2 = list("health" = src.health)
        if(!do_after(user = src, delay = rand(18, 28), target = C, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob, break_do_after_checks), checks2, FALSE)))
            return FALSE
        if(H && !H.dismember())
            C.apply_damage(50, BRUTE, BODY_ZONE_HEAD)
        begin_feast(C)
        next_critical_available_time = world.time + rand(20 SECONDS, 40 SECONDS)
        return TRUE
    // 5%: taunt, inflict artery, then deliberately lose interest
    else
        var/obj/item/bodypart/chest/CH2 = C.get_bodypart(BODY_ZONE_CHEST)
        if(CH2)
            CH2.add_wound(/datum/wound/artery)
        else
            C.apply_damage(30, BRUTE)
        playsound(src, 'sound/mobs/jitter_taunt.ogg', 70, FALSE)
        // Disengage for a while and watch the victim bleed out; stay nearby and keep target
        next_attack_time = world.time + rand(30, 60)
        reengage_target = C
        // Blink to a nearby ring to stalk rather than fleeing far away
        teleport_near_atom(C, 12, 16)
        alpha = 20
        // Stalk from the shadows: when they fall unconscious, wait briefly then feast
        spawn(0)
            watch_bleedout_then_feast(C)
        next_critical_available_time = world.time + rand(20 SECONDS, 40 SECONDS)
        return TRUE

// After inflicting an artery and disengaging, keep tabs on the victim. When they fall unconscious, wait briefly and begin feasting.
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/watch_bleedout_then_feast(mob/living/carbon/C)
    if(QDELETED(C) || stat == DEAD || is_dying)
        return
    var/deadline = world.time + 120 SECONDS
    var/announced_guard = FALSE
    while(C && !QDELETED(C) && C.stat != UNCONSCIOUS && C.stat != DEAD && world.time < deadline && !is_dying)
        // Keep within stalking range; if we drift too far, blink back near
        if(get_dist(src, C) > 16)
            teleport_near_atom(C, 12, 16)
            alpha = 20
        if(!announced_guard)
            visible_message(span_notice("The jitterskull guards its kill."))
            announced_guard = TRUE
        sleep(10)
    if(!C || QDELETED(C) || is_dying || stat == DEAD)
        return
    if(C.stat == UNCONSCIOUS)
        // Enter a dedicated guarding phase before the feast
        if(!QDELETED(C) && !is_dying && stat != DEAD)
            if(get_dist(src, C) > 2)
                teleport_near_atom(C, 1, 2)
            begin_guarding(C)
    else if(C.stat == DEAD)
        // If they bled out, we still come to devour the corpse
        if(!QDELETED(C) && !is_dying && stat != DEAD)
            if(get_dist(src, C) > 2)
                teleport_near_atom(C, 1, 2)
            begin_guarding(C)

// Jitterskull occasionally startles nearby targets when attacking
/mob/living/simple_animal/hostile/rogue/jitterskull/AttackingTarget()
    if(is_dying)
        return FALSE
    // Wait windows create tension: if we're still "waiting", don't attack yet
    if(is_feasting)
        return FALSE
    // During intentional stalking pauses, do not attack
    if(is_stalking)
        return FALSE
    // Do not attack while guarding before a feast
    if(is_guarding)
        return FALSE
    if(world.time < next_attack_time)
        return FALSE
    // If our target is invalid or dead, clear it so the AI can search anew
    if(!target || QDELETED(target) || (isliving(target) && target:stat == DEAD))
        if(ai_controller)
            var/datum/ai_controller/Cclear = ai_controller
            Cclear.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, null)
        return FALSE
    // Keep current target remembered for re-engage logic, and avoid self-targeting
    if(target == src)
        // Never attack ourselves; drop target so AI can reacquire
        if(ai_controller)
            var/datum/ai_controller/Cdrop = ai_controller
            Cdrop.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, null)
        return FALSE
    if(isliving(target))
        var/mob/living/TL = target
        reengage_target = TL
        // While vendetta is active, ensure the AI also sticks to this target
        if(world.time < vendetta_until && ai_controller)
            var/datum/ai_controller/Cvend = ai_controller
            if(Cvend.blackboard[BB_BASIC_MOB_CURRENT_TARGET] != TL)
                Cvend.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, TL)
        // If the victim is helpless, begin guarding before feasting
        if(TL.stat == UNCONSCIOUS || TL.stat == DEAD)
            begin_guarding(TL)
            return FALSE
    // Start swing window and 50% chance to ignore counter-hits
    attack_swing_until = world.time + 10
    ignore_hits_this_swing = prob(50)
    if(ignore_hits_this_swing)
        suppress_panic_until = max(suppress_panic_until, attack_swing_until)
    var/angry = (world.time < angry_until)
    // 30% chance to whiff: show the swing but don't actually attack (suppressed while angry)
    if(!angry && world.time >= primed_attack_until && prob(30))
        play_attack_pose(5)
        playsound(src, 'sound/mobs/jitter_attack.ogg', 65, FALSE)
        visible_message(span_warning("[src] snaps at the air and misses!"), span_warning("I snap at the air and miss!"))
        next_attack_time = world.time + rand(8, 18)
        return FALSE
    . = ..()
    if(.)
        // Show a clear attack pose for ~0.5s and play SFX; damage/teleport handled in success signal
        play_attack_pose(5)
        playsound(src, 'sound/mobs/jitter_attack.ogg', 80, FALSE)
        // Briefly suppress panic so getting counter-hit right now doesn't cause a second teleport
        suppress_panic_until = max(suppress_panic_until, world.time + 8)
        // Ensure post-hit flow even if armor fully absorbed and success signal doesn't arrive
        if(isliving(target))
            var/mob/living/EL = target
            spawn(0)
                ensure_post_attack_flow(EL)

// Begin lingering and consuming an unconscious target, with taunt and eating SFX; heals skull fully at the end
// Limb-by-limb feast with slow, interruptible wind-ups. If interrupted, the sequence aborts.
/* Clean reimplementation of begin_feast: dynamic limb selection -> head -> torso devour -> consume remains */
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/begin_guarding(mob/living/victim)
    if(is_dying || is_feasting || is_guarding || QDELETED(victim))
        return
    // Only guard if the victim is actually helpless
    if(!(isliving(victim) && (victim:stat == UNCONSCIOUS || victim:stat == DEAD)))
        return
    is_guarding = TRUE
    guarding_target = victim
    guarding_until = world.time + rand(10 SECONDS, 30 SECONDS)
    // Appear near and linger 1-2 tiles away
    if(get_dist(src, victim) > 2)
        teleport_near_atom(victim, 1, 2)
    // Show guarding text once
    visible_message(span_notice("The jitterskull guards its kill."))
    // Linger loop: hover around at 1-2 tiles, lightly circling
    spawn(0)
        while(is_guarding && !QDELETED(src))
            if(QDELETED(victim) || stat == DEAD || is_dying)
                break
            // Abort guarding if victim is no longer helpless
            if(isliving(victim))
                var/mob/living/LG = victim
                if(LG.stat != UNCONSCIOUS && LG.stat != DEAD)
                    break
            // Keep range at 1-2 tiles
            var/d = get_dist(src, victim)
            if(d < 1)
                step_away(src, victim)
            else if(d > 2)
                step_to(src, victim, 2, 1)
            else
                // Pace around: small random step to a nearby turf on the same ring
                var/dir_choice = pick(NORTH, SOUTH, EAST, WEST)
                step(src, dir_choice)
            // End condition
            if(world.time >= guarding_until)
                break
            sleep(3)
        // Guarding over; decide whether to feast
        if(is_guarding && !QDELETED(victim) && !is_dying && stat != DEAD)
            // Feast if still helpless
            if(isliving(victim))
                var/mob/living/LG2 = victim
                if(LG2.stat == UNCONSCIOUS || LG2.stat == DEAD)
                    begin_feast(LG2)
        // Cleanup state
        is_guarding = FALSE
        guarding_target = null

/mob/living/simple_animal/hostile/rogue/jitterskull/proc/begin_feast(mob/living/victim)
    if(is_feasting || QDELETED(victim))
        return
    is_feasting = TRUE
    reengage_target = victim
    playsound(src, 'sound/mobs/jitter_taunt.ogg', 70, FALSE)
    // Local narrate for feasting begin
    var/msg = ""
    if(isliving(victim) && iscarbon(victim))
        var/mob/living/carbon/FC = victim
        var/has_head = FC.get_bodypart(BODY_ZONE_HEAD) != null
        var/is_dead = (FC.stat == DEAD)
        if(is_dead && !has_head)
            msg = "The jitterskull begins to feast on a cadaver."
        else if(is_dead && has_head)
            msg = "The jitterskull begins to feast on the cadaver."
        else if(!is_dead && !has_head)
            msg = "The jitterskull begins to feast."
        else
            msg = "The jitterskull begins to feast on [FC]'s body."
    else
        msg = "The jitterskull begins to feast."
    visible_message(span_notice(msg))
    // Ensure we are on the cadaver's turf before beginning the feast
    var/turf/victim_turf = get_turf(victim)
    if(victim_turf) forceMove(victim_turf)
    var/linger_time = rand(30, 60)
    next_attack_time = world.time + linger_time + 120
    Immobilize(linger_time)
    var/list/check_health = list("health" = src.health)
    if(!do_after(user = src, delay = linger_time, target = victim, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob, break_do_after_checks), check_health, FALSE)))
        is_feasting = FALSE
        SetImmobilized(0)
        return
    if(QDELETED(victim) || !is_feasting)
        is_feasting = FALSE
        return
    var/list/snaps = list('sound/mobs/jitter_fasteat1.mp3','sound/mobs/jitter_fasteat2.mp3','sound/mobs/jitter_fasteat3.mp3')
    if(iscarbon(victim))
        var/mob/living/carbon/C = victim
        // Dismember intact limbs in any order
        while(is_feasting && C && !QDELETED(C))
            var/list/intact = list()
            for(var/z in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
                var/obj/item/bodypart/_bp = C.get_bodypart(z)
                if(_bp)
                    intact += z
            if(!intact.len)
                break
            var/zone = pick(intact)
            var/label = (zone == BODY_ZONE_L_ARM) ? "left arm" : (zone == BODY_ZONE_R_ARM) ? "right arm" : (zone == BODY_ZONE_L_LEG) ? "left leg" : "right leg"
            C.visible_message(span_warning("[src] clamps its jaws onto [C]'s [label], pulling slowly..."), span_danger("[src] clamps its jaws onto my [label]!"))
            playsound(src, pick(snaps), 75, TRUE)
            check_health["health"] = src.health
            if(!do_after(user = src, delay = rand(50, 80), target = C, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob, break_do_after_checks), check_health, FALSE)))
                is_feasting = FALSE
                SetImmobilized(0)
                return
            if(!is_feasting || QDELETED(C))
                is_feasting = FALSE
                return
            var/obj/item/bodypart/BP = C.get_bodypart(zone)
            if(BP)
                if(BP.dismember())
                    sleep(6)
                else
                    C.apply_damage(35, BRUTE)
        // Head next
        if(is_feasting && C && !QDELETED(C))
            var/obj/item/bodypart/head/HD = C.get_bodypart(BODY_ZONE_HEAD)
            if(HD)
                C.visible_message(span_warning("[src] clamps its jaws around [C]'s head, twisting..."), span_danger("[src] clamps around my head!"))
                playsound(src, pick(snaps), 80, TRUE)
                check_health["health"] = src.health
                if(!do_after(user = src, delay = rand(35, 55), target = C, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob, break_do_after_checks), check_health, FALSE)))
                    is_feasting = FALSE
                    SetImmobilized(0)
                    return
                if(HD && !HD.dismember())
                    C.apply_damage(50, BRUTE, BODY_ZONE_HEAD)
        // Torso devour: gib the body to leave organs, then consume nearby remains (except heads)
        if(is_feasting && C && !QDELETED(C))
            playsound(src, 'sound/mobs/jitter_eating.ogg', 75, FALSE)
            check_health["health"] = src.health
            if(!do_after(user = src, delay = rand(30, 50), target = C, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob, break_do_after_checks), check_health, FALSE)))
                is_feasting = FALSE
                SetImmobilized(0)
                return
            if(!QDELETED(C))
                C.gib()
        if(is_feasting && !QDELETED(src))
            var/turf/TT = get_turf(src)
            if(TT)
                // Slowly consume nearby limbs and organs, leaving heads intact
                for(var/obj/item/I in orange(2, TT))
                    if(istype(I, /obj/item/bodypart/head))
                        continue
                    if(istype(I, /obj/item/bodypart) || istype(I, /obj/item/organ))
                        // Walk up to the gore instead of eating from afar
                        if(get_dist(src, I) > 1)
                            var/tries = 0
                            while(get_dist(src, I) > 1 && tries < 20 && !QDELETED(I) && !QDELETED(src))
                                step_to(src, I, 1, 1)
                                tries++
                                sleep(1)
                        playsound(src, 'sound/mobs/jitter_eating.ogg', 70, FALSE)
                        check_health["health"] = src.health
                        if(!do_after(user = src, delay = rand(15, 30), target = I, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob, break_do_after_checks), check_health, FALSE)))
                            is_feasting = FALSE
                            SetImmobilized(0)
                            return
                        if(!QDELETED(I))
                            qdel(I)
                        // Extra pacing between bites
                        sleep(rand(8, 18))
    else
        for(var/i in 1 to 3)
            if(!is_feasting || QDELETED(victim))
                is_feasting = FALSE
                return
            playsound(src, pick(snaps), 75, TRUE)
            victim.apply_damage(30, BRUTE)
            check_health["health"] = src.health
            if(!do_after(user = src, delay = rand(20, 35), target = victim, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob, break_do_after_checks), check_health, FALSE)))
                is_feasting = FALSE
                SetImmobilized(0)
                return
    if(QDELETED(victim) || !is_feasting)
        is_feasting = FALSE
        return
    playsound(src, 'sound/mobs/jitter_swallow.ogg', 80, FALSE)
    // Heal to full after the feast
    bruteloss = 0; oxyloss = 0; toxloss = 0; fireloss = 0; cloneloss = 0; staminaloss = 0
    health = maxHealth
    updatehealth()
    is_feasting = FALSE
    teleport_away(8, 14)
    next_attack_time = world.time + rand(30, 80)

// React to taking damage by blinking away by default
/mob/living/simple_animal/hostile/rogue/jitterskull/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
    var/ret = ..()
    if(amount > 0)
        // If dying, ignore further reactions
        if(is_dying)
            return ret
        // If we're in a swing window and rolled to ignore hits this swing, do not flinch or teleport
        if(world.time <= attack_swing_until && ignore_hits_this_swing)
            return ret
        // If we're currently executing an attack, don't immediately panic-blink
        if(world.time < suppress_panic_until)
            if(prob(30))
                var/pain_quiet = pick('sound/mobs/jitter_pain1.ogg','sound/mobs/jitter_pain2.ogg','sound/mobs/jitter_pain3.ogg','sound/mobs/jitter_pain4.ogg')
                playsound(src, pain_quiet, 50, FALSE)
            return ret
        // If we're stalking (low-alpha stare), break off and become angry (attack immediately)
        if(is_stalking)
            is_stalking = FALSE
            anchored = FALSE
            alpha = original_alpha
            SetImmobilized(0)
            angry_until = world.time + 50
            next_attack_time = world.time
            suppress_panic_until = 0
            // Local narrate for anger on interrupt
            visible_message(span_warning("The jitterskull gets upset as they're interrupted from stalking their prey."))
            var/mob/att2 = get_mob_by_ckey(lastattackerckey)
            if(att2)
                reengage_target = att2
            return ret
        // If we're guarding a downed target, break off and become angry
        if(is_guarding)
            is_guarding = FALSE
            guarding_target = null
            alpha = original_alpha
            var/mob/attg = get_mob_by_ckey(lastattackerckey)
            if(attg)
                reengage_target = attg
                vendetta_target = attg
                vendetta_until = world.time + 600
            angry_until = world.time + 50
            next_attack_time = world.time
            return ret
        if(is_feasting)
            // Ignore minor incidental hits (e.g., flung limbs) when no attacker is recorded
            if(amount <= 7 && !lastattackerckey)
                return ret
            is_feasting = FALSE
            SetImmobilized(0)
            alpha = original_alpha
            var/mob/att = get_mob_by_ckey(lastattackerckey)
            if(att)
                reengage_target = att
                vendetta_target = att
                vendetta_until = world.time + 600 // ~60s vendetta focus
            else if(isliving(target))
                reengage_target = target
            teleport_cooldown_until = 0
            panic_blink_and_stalk()
            return ret
        // If damage appears environmental (no recorded attacker), don't panic-blink; minor ticks are ignored
        if(!lastattackerckey)
            if(amount <= 2)
                // ignore tiny ambient ticks entirely (e.g., brazier chip damage)
                return ret
            // For larger ambient hits with no attacker, continue into the normal teleport logic below
        // 30% chance to ignore damage and keep charging (no panic blink)
        if(prob(30))
            // Brief flair to show resolve
            visible_message(span_notice("The jitterskull barrels forward, unfazed by the blow!"))
            // Get aggressive for a short window: no whiffs, immediate pressure
            angry_until = max(angry_until, world.time + 40)
            next_attack_time = min(next_attack_time, world.time)
            return ret
        if(world.time >= teleport_cooldown_until)
            var/pain = pick('sound/mobs/jitter_pain1.ogg','sound/mobs/jitter_pain2.ogg','sound/mobs/jitter_pain3.ogg','sound/mobs/jitter_pain4.ogg')
            playsound(src, pain, 70, FALSE)
            teleport_cooldown_until = world.time + 30
            var/mob/attacker = get_mob_by_ckey(lastattackerckey)
            if(attacker)
                reengage_target = attacker
                vendetta_target = attacker
                vendetta_until = world.time + 600
            else if(isliving(target))
                reengage_target = target
            panic_blink_and_stalk()
    return ret

// Retreat helper: teleport away then set a short random wait before we’ll attack again
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/retreat_and_wait()
    if(is_dying)
        return
    teleport_away(4, 7)
    // Random pause window (2–5.5s) before we’re willing to attack again
    next_attack_time = world.time + rand(20, 55)

// Panic reaction: blink far away, fade and freeze for 5–20s, then reappear near target ~10 tiles away
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/panic_blink_and_stalk()
    if(is_dying)
        return
    // Blink further away than usual
    teleport_away(12, 18)
    // Fade more and freeze
    alpha = 20
    // Shorter vanish so it stays engaged
    var/wait_time = rand(25, 60) // vanish duration (2.5–6 seconds)
    next_attack_time = world.time + wait_time
    Immobilize(wait_time)
    var/mob/living/T = reengage_target
    spawn(wait_time)
        // Reappear at full opacity and stalk back near the target
        alpha = original_alpha
        if(T && !QDELETED(T))
            // Keep re-entry at a distance that's still within reacquire range
            teleport_near_atom(T, 6, 9, FALSE)
            // Reappear, then briefly stalk at low alpha while facing target
            alpha = 20
            var/df = get_dir(src, T)
            if(df)
                dir = df
            var/wt = rand(50, 150)
            if(world.time < angry_until)
                visible_message(span_warning("Because the jitterskull is angry, it begins the chase early!"))
                wt = max(0, wt - rand(40, 80))
            is_stalking = TRUE
            anchored = TRUE
            // Keep the AI target; anchoring enforces the pause without dropping aggro
            // Local narrate while stalking
            visible_message(span_notice("The jitterskull watches intently from a distance."))
            Immobilize(wt)
            next_attack_time = max(next_attack_time, world.time + wt)
            // If the victim flees during our stare, cancel early and re-tether
            spawn(1)
                var/t_end = world.time + wt
                while(world.time < t_end && is_stalking && !QDELETED(src) && T && !QDELETED(T))
                    if(get_dist(src, T) >= 10)
                        anchored = FALSE
                        SetImmobilized(0)
                        is_stalking = FALSE
                        teleport_near_atom(T, 10, 14)
                        alpha = 20
                        if(ai_controller && T && !QDELETED(T))
                            var/datum/ai_controller/Cpbret = ai_controller
                            Cpbret.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, T)
                        break
                    sleep(3)
            spawn(max(20, wt))
                if(!QDELETED(src))
                    is_stalking = FALSE
                    anchored = FALSE
                    alpha = original_alpha
                    // Target persisted; anchoring prevented chase
                    primed_attack_until = world.time + 30
                    next_attack_time = min(next_attack_time, world.time)
        else
            // No valid target, reappear nearby instead
            teleport_away(4, 8)

// Teleport to a random nearby open turf at least min_range away
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/teleport_away(min_range = 4, max_range = 7)
    if(is_dying || QDELETED(src))
        return
    var/turf/center = get_turf(src)
    if(!center)
        return
    var/list/options = list()
    var/minx = max(center.x - max_range, 1)
    var/miny = max(center.y - max_range, 1)
    var/maxx = center.x + max_range
    var/maxy = center.y + max_range
    var/z = center.z
    for(var/turf/T in block(locate(minx, miny, z), locate(maxx, maxy, z)))
        if(get_dist(center, T) < min_range)
            continue
        if(T.density)
            continue
        if(!isopenturf(T))
            continue
        options += T
    if(!length(options))
        return
    // Prefer positions that still have line-of-sight to our reengagement target if possible
    var/turf/choice
    if(reengage_target && !QDELETED(reengage_target))
        var/turf/rt = get_turf(reengage_target)
        if(rt)
            var/list/los_opts = list()
            for(var/turf/opt in options)
                if(has_line_of_sight(opt, rt))
                    los_opts += opt
            if(length(los_opts))
                choice = pick(los_opts)
    if(!choice)
        choice = pick(options)
    // Minimal flicker-style vanish/appear messaging
    visible_message(span_notice("[src] flickers out of sight."))
    if(QDELETED(src) || is_dying || QDELETED(choice))
        return
    forceMove(choice)
    visible_message(span_notice("[src] flickers back into sight."))
    // After teleporting, briefly translucent for a spooky effect, then restore quickly
    alpha = 50
    spawn(15)
        if(!QDELETED(src))
            alpha = original_alpha

// Teleport near an atom at roughly a ring between min and max distance
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/teleport_near_atom(atom/A, min_range = 9, max_range = 11, require_los = TRUE)
    if(is_dying || QDELETED(src) || QDELETED(A) || !A.loc)
        return
    var/turf/center = get_turf(A)
    if(!center)
        return
    var/list/candidates = list()
    var/minx = max(center.x - max_range, 1)
    var/miny = max(center.y - max_range, 1)
    var/maxx = center.x + max_range
    var/maxy = center.y + max_range
    var/z = center.z
    for(var/turf/T in block(locate(minx, miny, z), locate(maxx, maxy, z)))
        var/d = get_dist(center, T)
        if(d < min_range || d > max_range)
            continue
        if(T.density || !isopenturf(T))
            continue
        // Optionally restrict to spots with approximate clear LOS to the target turf
        if(!require_los || has_line_of_sight(T, center))
            candidates += T
    if(!length(candidates))
        return
    var/turf/spot = pick(candidates)
    if(QDELETED(src) || is_dying || QDELETED(spot))
        return
    forceMove(spot)

// Simple LOS: step from A to B along approximate straight path; fail on opaque/dense turfs
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/has_line_of_sight(turf/from_turf, turf/to_turf)
    if(!from_turf || !to_turf)
        return FALSE
    if(from_turf.z != to_turf.z)
        return FALSE
    var/turf/cur = from_turf
    var/safety = 0
    while(cur && cur != to_turf && safety < 256)
        safety++
        var/dir_to = get_dir(cur, to_turf)
        var/turf/next = get_step(cur, dir_to)
        if(!next)
            return FALSE
        if(next.opacity || next.density)
            return FALSE
        cur = next
    return TRUE

// If we're not making progress toward our target for a while, blink closer and continue stalking
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/anti_stuck_stalker_loop()
    while(src && !QDELETED(src))
        if(stat != DEAD && !is_dying && !is_feasting && !is_guarding && !is_stalking)
            var/datum/ai_controller/C = ai_controller
            var/mob/living/T = null
            if(C)
                T = C.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
            if(!T || QDELETED(T))
                // reset stuck tracking when target is missing
                last_stuck_x = x; last_stuck_y = y; stuck_ticks = 0
            else
                // If we're far and not moving for a bit, blink nearer and stalk
                var/moved = (x != last_stuck_x || y != last_stuck_y)
                if(moved)
                    stuck_ticks = 0
                else
                    stuck_ticks++
                last_stuck_x = x; last_stuck_y = y
                if(get_dist(src, T) > 2 && stuck_ticks >= 20)
                    // Snap tether near target without entering a stalking pause
                    teleport_near_atom(T, 8, 12)
                    var/df = get_dir(src, T)
                    if(df)
                        dir = df
                    stuck_ticks = 0
                // Distance-based pursuit tether even if we're not stuck, with a short cooldown
                var/dd = get_dist(src, T)
                // Tether a bit sooner so we don't lose interest after a post-hit blink
                if(dd >= 12 && world.time >= next_tether_allowed)
                    next_tether_allowed = world.time + 20
                    // Snap tether near target without entering a stalking pause
                    teleport_near_atom(T, 8, 12)
                    var/df2 = get_dir(src, T)
                    if(df2)
                        dir = df2
        sleep(10)

// Loop that triggers idle chatter at random intervals to build tension
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/idle_chatter_loop()
    while(src && !QDELETED(src))
        if(stat != DEAD && world.time >= next_idle_chatter_time)
            if(prob(60)) // not every window we chatter
                var/chatter = pick('sound/mobs/jitter_chatter1.ogg','sound/mobs/jitter_chatter2.ogg','sound/mobs/jitter_chatter3.ogg','sound/mobs/jitter_chatter4.ogg')
                playsound(src, chatter, 50, FALSE)
            // schedule next opportunity 3–8 seconds from now
            next_idle_chatter_time = world.time + rand(30, 80)
        sleep(rand(20, 40)) // check again in 2–4 seconds

// Periodic leash separate from anti-stuck, to gently keep the skull near its current target when they flee far away
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/pursuit_tether_loop()
    while(src && !QDELETED(src))
        if(stat != DEAD && !is_dying && !is_feasting && !is_guarding && !is_stalking && ai_controller)
            var/datum/ai_controller/C = ai_controller
            var/mob/living/T = C.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
            if(T && !QDELETED(T) && world.time >= next_tether_allowed)
                var/d = get_dist(src, T)
                // Engage tether at a closer gap so we keep pressure without dropping aggro
                if(d >= 16)
                    next_tether_allowed = world.time + 25
                    // Snap tether without entering stalking
                    teleport_near_atom(T, 10, 14)
                    var/df = get_dir(src, T)
                    if(df)
                        dir = df
        sleep(12)

// Custom death sequence: shake, flames, death sound, then burst into gibs
/mob/living/simple_animal/hostile/rogue/jitterskull/death(gibbed)
    if(is_dying)
        return
    is_dying = TRUE
    // Cache turf for loot drop before we potentially delete ourselves
    var/turf/death_turf = get_turf(src)
    // Halt AI to avoid any further actions during death
    toggle_ai(AI_OFF)
    // Ensure we won't move/teleport during death
    SetImmobilized(0)
    Immobilize(50)
    // Spectral flames in cardinal directions (visual only)
    spawn_flames()
    // Play death sound
    playsound(src, 'sound/mobs/jitter_death.ogg', 80, FALSE)
    // Shake violently for ~2.5 seconds while the audio plays
    shake_violently(25)
    // Small spectral burst and gibs
    visible_message(span_warning("[src] bursts apart in a spectral blast!"))
    gib_animation()
    gib()
    // Spawn golden reliquary loot chest with special drops
    if(death_turf)
        var/obj/structure/closet/crate/chest/inqreliquary/C = new(death_turf)
        if(C)
            C.name = "Jitterskull Loot"
            // Make it look golden
            C.icon_state = "chest3"
            C.base_icon_state = "chest3"
            C.keylock = FALSE
            C.locked = FALSE
            // Populate contents
            // 2-4 riddles of steel
            var/riddles = rand(2,4)
            for(var/i in 1 to riddles)
                new /obj/item/riddleofsteel(C)
            // 2-5 diamonds
            var/diamonds = rand(2,5)
            for(var/j in 1 to diamonds)
                new /obj/item/roguegem/diamond(C)
            // One unobtainium: Judgement variants or Holysee Master
            var/list/rare = list(
                /obj/item/rogueweapon/sword/long/judgement/vlord,
                /obj/item/rogueweapon/sword/long/judgement/ascendant,
                /obj/item/rogueweapon/sword/long/holysee/master
            )
            var/choice = pick(rare)
            new choice(C)
            // A pile of coins (gold)
            new /obj/item/roguecoin/gold/pile(C)
    // Ensure cleanup if gib() didn't delete us
    if(!QDELETED(src))
        qdel(src)

// Jitter the sprite in place for the specified number of ticks
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/shake_violently(ticks = 20)
    var/orig_px = pixel_x
    var/orig_py = pixel_y
    for(var/i in 1 to ticks)
        pixel_x = orig_px + rand(-3, 3)
        pixel_y = orig_py + rand(-3, 3)
        sleep(1)
    pixel_x = orig_px
    pixel_y = orig_py

// Spawn short-lived flame visuals in the four cardinal directions
/mob/living/simple_animal/hostile/rogue/jitterskull/proc/spawn_flames()
    var/turf/T = get_turf(src)
    if(!T)
        return
    // Spawn multiple decorative flames along all 8 directions, a few tiles out
    var/list/all_dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
    for(var/d in all_dirs)
        // For each ray, project 2-4 tiles
        var/len = rand(2, 4)
        var/turf/cur = T
        for(var/i in 1 to len)
            cur = get_step(cur, d)
            if(!cur)
                break
            var/obj/effect/temp_visual/jitterskull_flame/F = new /obj/effect/temp_visual/jitterskull_flame(cur)
            F.lifetime = rand(8, 14)

// Simple temp visual for jitterskull death flames (no gameplay effect)
/obj/effect/temp_visual/jitterskull_flame
    icon = 'icons/effects/particles/bonfire.dmi'
    icon_state = "bonfire"
    anchored = TRUE
    mouse_opacity = 0
    layer = EFFECTS_LAYER
    var/lifetime = 10

/obj/effect/temp_visual/jitterskull_flame/Initialize()
    . = ..()
    // Auto-delete shortly after
    spawn(lifetime)
        if(!QDELETED(src))
            qdel(src)
