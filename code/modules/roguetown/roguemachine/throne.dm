GLOBAL_VAR(king_throne)

/obj/structure/roguethrone
	name = "谷地王座"
	desc = "一张宽大的王座，足以盛下领主那庞大的威仪。若你一头雾水，就戴上王冠后说出“咽喉的秘密”。"
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "throne"
	density = FALSE
	can_buckle = 1
	pixel_x = -32
	max_integrity = 999999
	buckle_lying = FALSE
	obj_flags = NONE
	var/rebel_leader_sit_time = 0
	var/notified_rebel_able = FALSE

/obj/structure/roguethrone/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 8)

/obj/structure/roguethrone/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE
	M.reset_offsets("bed_buckle")

/obj/structure/roguethrone/Initialize(mapload)
	. = ..()
	if(GLOB.king_throne == null)
		GLOB.king_throne = src
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/structure/roguethrone/Destroy()
	if(GLOB.king_throne == src)
		GLOB.king_throne = null
	GLOB.lordcolor -= src
	return ..()

/obj/structure/roguethrone/process()
	var/dt = 1 SECONDS
	process_rebel_leader_sit(dt)
	. = ..()

/obj/structure/roguethrone/proc/process_rebel_leader_sit(dt)
	if(!length(buckled_mobs))
		return
	var/mob/living/user = buckled_mobs[1]
	if(user.stat != CONSCIOUS)
		return
	var/datum/antagonist/prebel/P = user.mind?.has_antag_datum(/datum/antagonist/prebel)
	if(!P)
		return
	if(rebel_leader_sit_time == 0)
		to_chat(user, span_notice("终于，我坐上王座了。等我在这里坐得更稳些，就能宣告胜利。周围的其他叛军会帮我更快站稳脚跟。"))
	var/time_modifier = 1.0
	/// Increase modifier for every other conscious rebel in view
	for(var/mob/living/living_mob in view(7, loc))
		if(living_mob == user)
			continue
		if(living_mob.stat != CONSCIOUS)
			continue
		var/datum/antagonist/prebel/rebel_antag = living_mob.mind?.has_antag_datum(/datum/antagonist/prebel)
		if(!rebel_antag)
			continue
		time_modifier += REBEL_THRONE_SPEEDUP_PER_PERSON
	rebel_leader_sit_time += (dt * time_modifier)
	if(rebel_leader_sit_time >= REBEL_THRONE_TIME && !notified_rebel_able)
		notified_rebel_able = TRUE
		to_chat(user, span_notice("就是现在，该宣告我们的胜利了！"))

/obj/structure/roguethrone/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "throne_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)
	M = mutable_appearance(icon, "throne_secondary", -(layer+0.1))
	M.color = secondary
	add_overlay(M)
