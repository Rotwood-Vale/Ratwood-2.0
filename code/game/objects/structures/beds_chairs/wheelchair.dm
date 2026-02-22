/obj/structure/chair/wheelchair
    // wheelchair: runtime adjustments for buckling and movement
    name = "wheelchair"
    desc = "A wooden chair with wheels. It allows mobility-impaired individuals to move around."
    icon = 'icons/roguetown/misc/structure.dmi'
    icon_state = "wheelchair-empty"
    anchored = FALSE
    can_buckle = 1
    buckle_lying = 0
    max_integrity = 100
    var/last_moved = 0
    var/list/buckle_overlays = list()
    var/list/original_pixel_y = list()
    var/list/original_pixel_x = list()
    
    // Variables to easily swap states for subtypes
    var/empty_state = "wheelchair-empty"
    var/full_state = "wheelchair-full"
    
    // Variable to control movement cooldown
    var/move_delay = 0.5 SECONDS
    item_chair = /obj/item/chair/wheelchair

/obj/structure/chair/wheelchair/relaymove(mob/living/user, direction)
    if(user in buckled_mobs)
        // Return FALSE so the client doesn't predict movement and rubberband!
        if(world.time < last_moved + move_delay) 
            return FALSE 

        // Check if we are currently sitting on a set of stairs
        var/turf/current_turf = get_turf(src)
        var/obj/structure/stairs/S = locate(/obj/structure/stairs) in current_turf

        if(S && direction == S.dir)
            to_chat(user, span_warning("\The [src] rolls back off the stairs as you try to climb up!"))
            
            // Fling them backward!
            var/roll_back_dir = turn(direction, 180)
            step(src, roll_back_dir) 
            
            // Give them a brief cooldown penalty so they can't spam the stairs
            last_moved = world.time + 0.5 SECONDS 
            return FALSE 

        var/turf/T = get_step(src, direction)
        if(T && !T.density)
            if(step(src, direction)) 
                setDir(direction)
                last_moved = world.time
                
                // Combat pixel-shifting and camera wobbling
                for(var/mob/living/M in buckled_mobs)
                    // Force the camera pan speed to match the chair, killing the wobble!
                    M.glide_size = src.glide_size 
                    
                    if(iskobold(M) || iscritter(M) || isgoblinp(M) || isdwarf(M))
                        if(isnull(original_pixel_y[M])) 
                            original_pixel_y[M] = M.pixel_y
                        if(isnull(original_pixel_x[M])) 
                            original_pixel_x[M] = M.pixel_x
                            
                        var/expected_y = original_pixel_y[M] + 5
                        var/expected_x = original_pixel_x[M]
                        
                        // Apply directional shift
                        if(direction == EAST)
                            expected_x += 1
                        else if(direction == WEST)
                            expected_x -= 1
                            
                        if(M.pixel_y != expected_y)
                            M.pixel_y = expected_y
                        if(M.pixel_x != expected_x)
                            M.pixel_x = expected_x
                            
                return TRUE // Return TRUE only if the step actually succeeded
        return FALSE // Return FALSE if they hit a wall

// Dynamically shift X position when the chair turns in place
/obj/structure/chair/wheelchair/setDir(newdir)
    ..()
    for(var/mob/living/M in buckled_mobs)
        if(iskobold(M) || iscritter(M) || isgoblinp(M) || isdwarf(M))
            if(!isnull(original_pixel_x[M])) 
                var/expected_x = original_pixel_x[M]
                if(newdir == EAST)
                    expected_x += 1
                else if(newdir == WEST)
                    expected_x -= 1
                M.pixel_x = expected_x

/obj/structure/chair/wheelchair/handle_layer()
    if(buckled_mobs && buckled_mobs.len)
        var/mob/living/M = buckled_mobs[1]
        if(M && (dir == EAST || dir == WEST))
            layer = ABOVE_MOB_LAYER
        else
            ..() 
    else
        ..()

/obj/structure/chair/wheelchair/post_buckle_mob(mob/living/M)
    . = ..()
    icon_state = full_state 

    if(M)
        M.glide_size = src.glide_size
    
    // elevate and shift small species so they show correctly when buckled
    if(M && (iskobold(M) || iscritter(M) || isgoblinp(M) || isdwarf(M)))
        if(isnull(original_pixel_y[M])) 
            original_pixel_y[M] = M.pixel_y
        if(isnull(original_pixel_x[M])) 
            original_pixel_x[M] = M.pixel_x
            
        M.pixel_y = original_pixel_y[M] + 5
        
        // Check current facing direction and apply X shift
        var/expected_x = original_pixel_x[M]
        if(dir == EAST)
            expected_x += 1
        else if(dir == WEST)
            expected_x -= 1
        M.pixel_x = expected_x
    
    handle_layer()
    last_moved = world.time 

/obj/structure/chair/wheelchair/post_unbuckle_mob(mob/living/M)
    . = ..()
    icon_state = empty_state 

    // restore both pixel_y and pixel_x for small species
    if(M)
        if(!isnull(original_pixel_y[M])) 
            M.pixel_y = original_pixel_y[M]
            original_pixel_y -= M
        if(!isnull(original_pixel_x[M])) 
            M.pixel_x = original_pixel_x[M]
            original_pixel_x -= M

    handle_layer()

// === NOBLE WHEELCHAIR SUBTYPES === //

/obj/structure/chair/wheelchair/noble
    name = "fancy wheelchair"
    desc = "A well-built, lavishly gilded red wheelchair. It allows mobility-impaired individuals of high status to move around in comfort."
    icon_state = "noblewheelchair-empty"
    empty_state = "noblewheelchair-empty"
    full_state = "noblewheelchair-full"
    move_delay = 0.4 SECONDS 
    item_chair = /obj/item/chair/wheelchair/noble

/obj/structure/chair/wheelchair/noble/purple
    name = "fancy wheelchair"
    desc = "A well-built, lavishly gilded purple wheelchair. It allows mobility-impaired individuals of high status to move around in comfort."
    icon_state = "noblewheelchairp-empty"
    empty_state = "noblewheelchairp-empty"
    full_state = "noblewheelchairp-full"
    item_chair = /obj/item/chair/wheelchair/noble/purple
