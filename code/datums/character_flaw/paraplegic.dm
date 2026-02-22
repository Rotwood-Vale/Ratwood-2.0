/datum/charflaw/paraplegic
    name = "Paraplegic (Paralyzed)"
    desc = "Your legs do not function. Nothing, not even prosthetics, will ever fix this. You will require a wheelchair to move around effectively."

/datum/charflaw/paraplegic/on_mob_creation(mob/user)
    if(!ishuman(user))
        return
    var/mob/living/carbon/human/H = user
    H.adjust_triumphs(3)

/datum/charflaw/paraplegic/apply_post_equipment(mob/user)
    if(!ishuman(user))
        return
    var/mob/living/carbon/human/H = user
    // Delay the spawn by 1 second so Virtues have time to apply their traits!
    addtimer(CALLBACK(src, .proc/apply_paraplegia, H), 1 SECONDS)

/datum/charflaw/paraplegic/proc/apply_paraplegia(mob/living/carbon/human/H)
    if(!H || QDELETED(H))
        return
    if(H.buckled)
        H.buckled.unbuckle_mob(H)

    H.gain_trauma(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)

    var/turf/spawn_turf = get_turf(H)
    if(spawn_turf)
        var/obj/structure/chair/wheelchair/W
        
        if(HAS_TRAIT(H, TRAIT_NOBLE))
            W = new /obj/structure/chair/wheelchair/noble(spawn_turf)
        else if(HAS_TRAIT(H, TRAIT_DEFILED_NOBLE) || HAS_TRAIT(H, TRAIT_DISGRACED_NOBLE))
            W = new /obj/structure/chair/wheelchair/noble/purple(spawn_turf)
        else
            W = new /obj/structure/chair/wheelchair(spawn_turf)
            
        W.setDir(H.dir)
        W.buckle_mob(H)

/datum/charflaw/paraplegic/amputee
    name = "Paraplegic (Amputee)"
    desc = "You lost your legs entirely. Because of profound nerve damage, attaching prosthetics will not restore your mobility. You will require a wheelchair."

/datum/charflaw/paraplegic/amputee/apply_paraplegia(mob/living/carbon/human/H)
    // Run the parent proc to apply the trauma and spawn the correct wheelchair
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
