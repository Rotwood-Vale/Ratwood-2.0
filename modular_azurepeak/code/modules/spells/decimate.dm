// Khan's Decimate / Nightfall spell

/obj/effect/proc_holder/spell/invoked/decimate
    name = "Obliterate"
    desc = "Swing a crushing maul in a wide cone in front of you, battering foes and leaving scars on the earth if you miss."
    range = 3
    associated_skill = /datum/skill/combat/maces
    recharge_time = 6 SECONDS
    cast_without_targets = FALSE
    sound = 'sound/shuz/obliterate/oncast1.ogg'

/obj/effect/proc_holder/spell/invoked/decimate/cast(list/targets, mob/living/carbon/human/user)
    // Only the Khan antagonist should normally have this spell; ensure caller is the Khan datum owner
    if(!user.mind?.has_antag_datum(/datum/antagonist/khan_sahnuzal))
        revert_cast()
        return FALSE

    var/mob/living/carbon/human/M = user

    var/turf/target_turf
    if(LAZYLEN(targets))
        target_turf = get_turf(targets[1])

    // Determine direction and target turfs (use target if provided so diagonals work)
    var/dir
    if(target_turf)
        dir = get_dir(M, target_turf)
    else
        dir = M.dir

    if(!dir)
        dir = SOUTH

    var/turf/center = get_step(M.loc, dir) // inner safe tile
    if(!isturf(center))
        to_chat(M, span_warning("There's nowhere to swing!"))
        return FALSE

    // Build cone tiles
    var/list/cone_turfs = list()

    // Cardinals keep the broader 3-tile cone the player liked
    if(dir in list(NORTH, SOUTH, EAST, WEST))
        for(var/range_step = 2, range_step <= 3, range_step++)
            // Move out to the appropriate distance along the main direction
            var/turf/forward = get_turf(M)
            for(var/j = 1, j <= range_step, j++)
                forward = get_step(forward, dir)
                if(!isturf(forward))
                    break

            if(!isturf(forward))
                continue

            // Determine lateral spread for this distance (wider further out)
            var/max_side = (range_step == 2 ? 1 : 2)

            for(var/side_offset = -max_side, side_offset <= max_side, side_offset++)
                var/turf/offset_turf = forward
                if(side_offset)
                    var/lat_dir = turn(dir, side_offset > 0 ? 90 : -90)
                    for(var/k = 1, k <= abs(side_offset), k++)
                        offset_turf = get_step(offset_turf, lat_dir)
                        if(!isturf(offset_turf))
                            break

                if(isturf(offset_turf) && !(offset_turf in cone_turfs))
                    cone_turfs += offset_turf
    else
        // Diagonals: slightly shorter and tighter cone, no gaps
        var/max_diag_range = 3
        for(var/turf/T in range(max_diag_range, M))
            if(!isturf(T))
                continue
            if(T == get_turf(M) || T == center)
                continue
            if(get_dist(M, T) < 2)
                continue
            if(get_dir(M, T) != dir)
                continue
            if(!(T in cone_turfs))
                cone_turfs += T

    // Play oncast and VO
    playsound(get_turf(M), pick('sound/shuz/obliterate/oncast1.ogg','sound/shuz/obliterate/oncast2.ogg'), 100, TRUE)
    playsound(get_turf(M), pick('sound/shuz/obliterate/vo1.ogg','sound/shuz/obliterate/vo2.ogg','sound/shuz/obliterate/vo3.ogg'), 100, TRUE)

    // Telegraph visuals that last the entire windup: green safe tile + red cone
    var/windup_time = 1.5 SECONDS
    if(isturf(center))
        var/obj/effect/temp_visual/impact_effect/green_laser/safe_marker = new /obj/effect/temp_visual/impact_effect/green_laser(center)
        safe_marker.duration = windup_time
    for(var/turf/X in cone_turfs)
        if(isturf(X))
            var/obj/effect/temp_visual/impact_effect/red_laser/danger_marker = new /obj/effect/temp_visual/impact_effect/red_laser(X)
            danger_marker.duration = windup_time

    // Windup then apply effects
    if(do_after(M, windup_time, target = M))
        // Screen shake for everyone nearby (slightly toned down)
        for(var/mob/living/carbon/screenshaken in view(5, M))
            shake_camera(screenshaken, 3, 3)

        // Gather targets in cone tiles (exclude the inner safe tile)
        var/list/hit_mobs = list()
        for(var/turf/T in cone_turfs)
            if(!isturf(T))
                continue
            for(var/mob/living/L in T)
                if(!L || L == M || L.stat == DEAD)
                    continue
                if(!(L in hit_mobs))
                    hit_mobs += L

        if(!length(hit_mobs))
            // Miss: play miss sound and spawn dreamfiend ichor on every cone tile
            playsound(get_turf(M), pick('sound/shuz/obliterate/miss1.ogg','sound/shuz/obliterate/miss2.ogg'), 100, TRUE)
            for(var/turf/cone_tile in cone_turfs)
                if(isturf(cone_tile))
                    var/obj/effect/decal/cleanable/dreamfiend_ichor/D = new /obj/effect/decal/cleanable/dreamfiend_ichor(cone_tile)
                    D.alpha = 200
                    // Fade out and delete after 5 seconds
                    spawn(5 SECONDS)
                        if(D)
                            animate(D, alpha = 0, time = 1 SECONDS)
                            QDEL_IN(D, 1 SECONDS)
            return TRUE

        // Hit something
        if(length(hit_mobs) > 1)
            playsound(get_turf(M), pick('sound/shuz/obliterate/multi1.ogg','sound/shuz/obliterate/multi2.ogg'), 100, TRUE)
            for(var/mob/living/T in hit_mobs)
                if(!T || T.stat == DEAD)
                    continue
                T.Knockdown(1)
                var/obj/item/bodypart/affecting = T.get_bodypart(BODY_ZONE_HEAD)
                if(!affecting)
                    affecting = T.get_bodypart(BODY_ZONE_CHEST)
                if(affecting)
                    var/damage = rand(25, 65)
                    var/armor = T.run_armor_check(affecting, "blunt", damage = damage)
                    if(T.apply_damage(damage, BRUTE, affecting, armor))
                        affecting.bodypart_attacked_by(BCLASS_SMASH, max(damage - armor, 0), M, affecting.body_zone, crit_message = TRUE)
            return TRUE

        // Isolated target
        if(length(hit_mobs) == 1)
            var/mob/living/iso = hit_mobs[1]
            playsound(get_turf(M), pick('sound/shuz/obliterate/isolated1.ogg','sound/shuz/obliterate/isolated2.ogg'), 100, TRUE)
            
            // Play one of the isolated voice lines with corresponding message
            var/voice_choice = rand(1, 5)
            switch(voice_choice)
                if(1)
                    playsound(get_turf(M), 'sound/shuz/obliterate/hitisolated1.ogg', 100, TRUE)
                    M.say("YOUR END!", forced = "spell")
                if(2)
                    playsound(get_turf(M), 'sound/shuz/obliterate/hitisolated2.ogg', 100, TRUE)
                    M.say("DIE!", forced = "spell")
                if(3)
                    playsound(get_turf(M), 'sound/shuz/obliterate/hitisolated3.ogg', 100, TRUE)
                    M.say("NO ESCAPE!", forced = "spell")
                if(4)
                    playsound(get_turf(M), 'sound/shuz/obliterate/hitisolated4.ogg', 100, TRUE)
                    M.say("FALL!", forced = "spell")
                if(5)
                    playsound(get_turf(M), 'sound/shuz/obliterate/hitisolated5.ogg', 100, TRUE)
                    M.emote("laugh")
            
            iso.Knockdown(1)
            var/obj/item/bodypart/headbp = iso.get_bodypart(BODY_ZONE_HEAD)
            if(!headbp)
                headbp = iso.get_bodypart(BODY_ZONE_CHEST)
            if(headbp)
                var/iso_damage = rand(75, 150)
                var/iso_armor = iso.run_armor_check(headbp, "blunt", damage = iso_damage)
                if(iso.apply_damage(iso_damage, BRUTE, headbp, iso_armor))
                    headbp.bodypart_attacked_by(BCLASS_SMASH, max(iso_damage - iso_armor, 0), M, headbp.body_zone, crit_message = TRUE)
                    // 45% chance to fracture neck (spine) on a solid hit
                    if(prob(45))
                        var/obj/item/bodypart/neckbp = iso.get_bodypart(BODY_ZONE_PRECISE_NECK)
                        if(neckbp)
                            neckbp.add_wound(/datum/wound/fracture/neck, FALSE, TRUE)
            new /obj/effect/temp_visual/bonk_effect(get_turf(iso))
