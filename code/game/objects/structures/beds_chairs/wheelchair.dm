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
    
    // Variables to easily swap states for subtypes
    var/empty_state = "wheelchair-empty"
    var/full_state = "wheelchair-full"
    
    // NEW: Variable to control movement cooldown
    var/move_delay = 0.5 SECONDS

/obj/structure/chair/wheelchair/relaymove(mob/living/user, direction)
    if(user in buckled_mobs)
        if(world.time < last_moved + move_delay) // FIX: Now uses the variable
            return
        var/turf/T = get_step(src, direction)
        if(T && !T.density)
            step(src, direction)
            setDir(direction)
            last_moved = world.time
            // If any buckled small species had their pixel_y changed by other code,
            // reapply the single +5 boost so they don't need to unbuckle/rebuckle.
            for(var/mob/living/M in buckled_mobs)
                if(iskobold(M) || iscritter(M) || isgoblinp(M) || isdwarf(M))
                    if(isnull(original_pixel_y[M])) 
                        original_pixel_y[M] = M.pixel_y
                    var/expected_y = original_pixel_y[M] + 5
                    if(M.pixel_y != expected_y)
                        M.pixel_y = expected_y

/obj/structure/chair/wheelchair/handle_layer()
    if(buckled_mobs && buckled_mobs.len)
        var/mob/living/M = buckled_mobs[1]
        if(M && (dir == EAST || dir == WEST))
            layer = ABOVE_MOB_LAYER
            // wheelchair sits above mob for east/west; no pixel offsets here
        else
            ..() // Use base behavior for north/south
    else
        ..()

/obj/structure/chair/wheelchair/post_buckle_mob(mob/living/M)
    . = ..()
    icon_state = full_state 
    // elevate small species slightly so their top halves show correctly when buckled
    if(M && (iskobold(M) || iscritter(M) || isgoblinp(M) || isdwarf(M)))
        if(isnull(original_pixel_y[M])) 
            original_pixel_y[M] = M.pixel_y
        // invert offset: raise sprite by 5 pixels (was lowering previously)
        M.pixel_y = original_pixel_y[M] + 5
        // ensure stored original is used if something else resets pixel_y later
        // (we don't loop; reapply happens only when the chair moves)
    handle_layer()
    glide_size = 0
    last_moved = 0

/obj/structure/chair/wheelchair/post_unbuckle_mob(mob/living/M)
    . = ..()
    icon_state = empty_state 

    // restore pixel_y for small species if we changed it
    if(M && !isnull(original_pixel_y[M])) 
        M.pixel_y = original_pixel_y[M]
        original_pixel_y -= M

    handle_layer()
    glide_size = 0


// === NOBLE WHEELCHAIR SUBTYPES === //

/obj/structure/chair/wheelchair/noble
    name = "fancy wheelchair"
    desc = "A well-built, lavishly gilded red wheelchair. It allows mobility-impaired individuals of high status to move around in comfort."
    icon_state = "noblewheelchair-empty"
    empty_state = "noblewheelchair-empty"
    full_state = "noblewheelchair-full"
    
    move_delay = 0.35 SECONDS 

/obj/structure/chair/wheelchair/noble/purple
    name = "fancy wheelchair"
    desc = "A well-built, lavishly gilded purple wheelchair. It allows mobility-impaired individuals of high status to move around in comfort."
    icon_state = "noblewheelchairp-empty"
    empty_state = "noblewheelchairp-empty"
    full_state = "noblewheelchairp-full"
