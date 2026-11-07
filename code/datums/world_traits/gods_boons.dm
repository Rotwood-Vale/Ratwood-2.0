/datum/world_trait/dendor_fertility
	name = "Dendor's Blessing"
	desc = "Increases the fertility of crops, making them grow faster and heartier."

/datum/world_trait/dendor_drought
	name = "Dendor's Malus"
	desc = "Decreases the fertility of crops, making them grow slower."

/datum/world_trait/pestra_mercy
	name = "Pestra's Mercy"
	desc = "Corpses rot slower."

/datum/world_trait/matthios_fingers
	name = "Matthios' Fingers"
	desc = "Improves thief's chance of a successful pickpocket."

/datum/world_trait/necra_requiem
	name = "Necra's Requiem"
	desc = "New corpses won't become deadites."

/datum/world_trait/zizo_defilement
	name = "Zizo's Defilement"
	desc = "Deadites will rise in the town."

/datum/world_trait/zizo_pet_cementery
	name = "Zizo's Pet Cementery"
	desc = "Deadite animals will rise frequently and appear instead of regular animals."

/datum/world_trait/abyssor_rage
	name = "Abyssor's Rage"
	desc = "Drowning is more deadly."

/datum/world_trait/malum_diligence
	name = "Malum's Diligence"
	desc = "Mined rocks have additional yields."
/*	- Unused for now
/datum/world_trait/noc_wisdom
	name = "Noc's Wisdom"
	desc = "All magic actions cost less mana."
*/
/datum/world_trait/baotha_revelry
	name = "Baotha's Revelry"
	desc = "Alcohol lasts longer."

/datum/world_trait/zizo_pitch
	name = "Zizo's Pitch"

/datum/world_trait/zizo_blood
	name = "Zizo's Blood"

/datum/world_trait/zizo_noise
	name = "Zizo's Noise"

/datum/world_trait/zizo_rot
	name = "Zizo's Rot"
	processes = TRUE
	var/list/spots = list()
	var/next_spawn = 0

/datum/world_trait/zizo_rot/New()
	. = ..()
	for(var/area/rogue/outdoors/town/A in world)
		if(istype(A, /area/rogue/outdoors/town/roofs))
			continue
		for(var/turf/open/floor/T in A)
			spots += T

/datum/world_trait/zizo_rot/process()
	if(world.time < next_spawn || !length(spots))
		return
	for(var/obj/structure/blight_pillar/P as anything in tracked_items.Copy())
		if(QDELETED(P))
			tracked_items -= P
	if(length(tracked_items) >= 6)
		return
	next_spawn = world.time + 5 MINUTES
	var/turf/T = pick(spots)
	if(T.density || (locate(/obj/structure) in T) || (locate(/mob/living) in T))
		return
	tracked_items += new /obj/structure/blight_pillar(T)

/datum/world_trait/zizo_toil
	name = "Zizo's Toil"

/datum/world_trait/zizo_strand
	name = "Zizo's Strand"

/datum/world_trait/zizo_bite
	name = "Zizo's Bite"
