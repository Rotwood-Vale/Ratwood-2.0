/datum/charflaw/paraplegic
    name = "Paraplegic (Paralyzed)"
    desc = "Your legs do not function. Nothing, not even prosthetics, will ever fix this. You will require a wheelchair to move around effectively."

/datum/charflaw/paraplegic/on_mob_creation(mob/user)
    if(!ishuman(user))
        return
    var/mob/living/carbon/human/H = user
    H.adjust_triumphs(3)

    // Delay the setup by 1 second to let the mob finish spawning and loading onto the map.
    spawn(10)
        apply_paraplegia(H)

// Helper proc to handle the delayed logic
/datum/charflaw/paraplegic/proc/apply_paraplegia(mob/living/carbon/human/H)
    if(!H || QDELETED(H))
        return
	// 1. Unbuckle them from anything they might be buckled to, just in case. This prevents potential softlocks where the player could spawn in buckled to something and be unable to move or interact with the world.
    if(H.buckled)
        H.buckled.unbuckle_mob(H)

    // 2. Apply the brain trauma! This handles the traits and updates the bodyparts automatically.
    H.gain_trauma(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)

    // 3. Spawn and buckle them into the wheelchair
    var/turf/spawn_turf = get_turf(H)
    if(spawn_turf)
        var/obj/structure/chair/wheelchair/W = new(spawn_turf)
        W.setDir(H.dir)
        W.buckle_mob(H)

/datum/charflaw/paraplegic/amputee
    name = "Paraplegic (Amputee)"
    desc = "You lost your legs entirely. Because of profound nerve damage, attaching prosthetics will not restore your mobility. You will require a wheelchair."

/datum/charflaw/paraplegic/amputee/apply_paraplegia(mob/living/carbon/human/H)
    // Run the parent proc to apply the trauma and spawn the wheelchair first
    ..() 

    if(!H || QDELETED(H))
        return
    // Sever and completely delete the actual legs
    var/obj/item/bodypart/L = H.get_bodypart(BODY_ZONE_L_LEG)
    if(L)
        L.drop_limb()
        qdel(L)

    var/obj/item/bodypart/R = H.get_bodypart(BODY_ZONE_R_LEG)
    if(R)
        R.drop_limb()
        qdel(R)
