/mob/living/carbon/human/species/skeleton/npc/summoned
	var/mob/living/caster // The summoner who owns this NPC
	var/tmp/command_mode = "idle" // "follow", "move", "attack", "idle"
	var/tmp/command_target // turf or mob depending on command
	var/list/friendly_factions = list() // factions to not target
	skel_outfit = /datum/outfit/job/roguetown/npc/skeleton/npc/summoned


/datum/outfit/job/roguetown/npc/skeleton/npc/summoned/pre_equip(mob/living/carbon/human/H)
	.=..()
	H.STASTR = 14
	H.STASPD = 8
	H.STACON = 6 // Slightly tougher now!
	H.STAWIL = 15
	H.STAINT = 1
	name = "Skeleton Soldier"
	cloak = /obj/item/clothing/cloak/stabard/surcoat/guard // Ooo Spooky Old Dead MAA
	head = /obj/item/clothing/head/roguetown/helmet/heavy/aalloy
	mask = /obj/item/clothing/mask/rogue/facemask/aalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	if(prob(33))
		l_hand = /obj/item/rogueweapon/spear/aalloy
	else if(prob(33))
		l_hand = /obj/item/rogueweapon/flail/aflail
		r_hand = /obj/item/rogueweapon/shield/tower/metal/alloy/skeleton
	else
		l_hand = /obj/item/rogueweapon/sword/short/gladius/agladius	// ave
		r_hand = /obj/item/rogueweapon/shield/tower/metal/alloy/skeleton


	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

/obj/item/rogueweapon/shield/tower/metal/alloy/skeleton
	force = 10
	desc = "A hefty tower shield, wrought from frayed bronze. Looped with dried kelp and reeking of saltwater, you'd assume that this had been fished out from the remains of a long-sunken warship. This one seems half rotted."

/mob/living/carbon/human/species/skeleton/npc/summoned/should_target(atom/target)
	if(ismob(target))
		var/mob/living/L = target
		if(L == caster)
			return FALSE
		if(L.faction && (L.faction in faction))
			return FALSE
	return ..() // fall back to normal targeting

/mob/living/carbon/human/species/skeleton/npc/summoned/proc/set_command(command, target)
	switch(command)
		if("follow")
			command_mode = "follow"
			command_target = target // caster
		if("move")
			if(isturf(target))
				command_mode = "move"
				command_target = target
		if("attack")
			if(ismob(target))
				command_mode = "attack"
				command_target = target
		if("idle")
			command_mode = "idle"
			command_target = null

/mob/living/carbon/human/species/skeleton/npc/summoned/proc/receive_command_text(msg)
	if(!IsDeadOrIncap())
		visible_message("<b>[src]</b> [msg]")

/mob/living/carbon/human/species/skeleton/npc/summoned/process_ai()
	if(IsDeadOrIncap())
		walk_to(src, 0)
		return stat == DEAD

	switch(command_mode)
		if("follow")
			if(!command_target || !ismob(command_target))
				command_mode = "idle"
				walk(src, 0)
				return

			var/turf/target_turf = get_turf(command_target)
			if(!target_turf)
				command_mode = "idle"
				walk(src, 0)
				return

			var/dist = get_dist(src, command_target)

			// === Handle different z-levels ===
			if(target_turf.z != z)
				var/target_z = target_turf.z

				var/obj/structure/stairs/the_stairs = locate() in get_turf(src)
				if(the_stairs)
					var/move_dir = (target_z > z) ? the_stairs.dir : GLOB.reverse_dir[the_stairs.dir]
					var/turf/next_step = the_stairs.get_target_loc(move_dir)
					if(next_step)
						Move(next_step)
						return
					else
						step_to(src, the_stairs)
						return

				if(HAS_TRAIT(src, TRAIT_ZJUMP))
					if(npc_try_jump_to(target_turf))
						return
					sleep(1 SECONDS)
					return

				for(var/obj/structure/stairs/S in view(5, src))
					var/dir_to_stairs = get_dir(src, S)
					if((target_z > z && S.dir == dir_to_stairs) || (target_z < z && GLOB.reverse_dir[S.dir] == dir_to_stairs))
						step_to(src, S)
						return

				walk(src, 0)
				return

			// === Same-z follow ===
			if(dist > 2)
				walk_to(src, command_target, 0, 2)
			else
				walk(src, 0)
			return

		if("move")
			walk_to(src, 0)
			if(!command_target)
				command_mode = "idle"
				clear_path()
				pathfinding_target = null
				return

			if(get_dist(src, command_target) <= 1)
				command_mode = "idle"
				command_target = null
				clear_path()
				pathfinding_target = null
				return

			if(pathfinding_target != command_target)
				start_pathing_to(command_target)

			if(length(myPath))
				move_along_path()
			return

		if("attack")
			walk_to(src, 0)
			if(command_target && istype(command_target, /mob))
				if(!should_target(command_target))
					command_mode = "idle"
					command_target = null
					return
				target = command_target
				. = ..()
				return

			command_mode = "idle"
			command_target = null
			return

		if("idle")
			. = ..()
			return