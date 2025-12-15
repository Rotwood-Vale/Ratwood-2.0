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
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	r_hand = /obj/item/rogueweapon/shield/tower/metal/alloy
	if(prob(33))
		l_hand = /obj/item/rogueweapon/spear/aalloy
	else if(prob(33))
		l_hand = /obj/item/rogueweapon/sword/short/gladius/agladius	// ave
	else
		l_hand = /obj/item/rogueweapon/flail/aflail
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
	visible_message("<b>[src]</b> [msg]")

/mob/living/carbon/human/species/skeleton/npc/summoned/process_ai()
	if(IsDeadOrIncap())
		walk_to(src,0)
		return stat == DEAD // only stop processing if we're dead-dead

	// Handle summoner commands
	switch(command_mode)
		if("follow")
			if(command_target && ismob(command_target))
				var/turf/target_turf = get_turf(command_target)
				if(!target_turf)
					command_mode = "idle"
					return

				var/dist = get_dist(src, command_target)

				// === Handle different z-levels ===
				if(target_turf.z != z)
					var/target_z = target_turf.z

					// Check for stairs underfoot
					var/obj/structure/stairs/the_stairs = locate() in get_turf(src)
					if(the_stairs)
						var/move_dir = (target_z > z) ? the_stairs.dir : GLOB.reverse_dir[the_stairs.dir]
						var/turf/next_step = the_stairs.get_target_loc(move_dir)

						if(next_step)
							// actually move to the stair target turf
							if(src.Move(next_step))
								NPC_THINK("[src] ascends/descends stairs to z [next_step.z]")
								return
						else
							// failsafe, step toward the stair’s target
							step_to(src, the_stairs)
							return

					// Try Z-jump
					if(HAS_TRAIT(src, TRAIT_ZJUMP))
						if(npc_try_jump_to(target_turf))
							return
						else
							sleep(1 SECONDS)
							return

					// Find nearby stairs and move onto them
					for(var/obj/structure/stairs/S in view(5, src))
						var/dir_to_stairs = get_dir(src, S)
						if((target_z > z && S.dir == dir_to_stairs) || (target_z < z && GLOB.reverse_dir[S.dir] == dir_to_stairs))
							step_to(src, S)
							return

					// Can't find a way up/down
					walk(src, 0)
					return

				// === Same-z behavior ===
				if(dist > 2)
					walk_to(src, command_target, 0, 2)
				else
					walk(src, 0)
			else
				command_mode = "idle"

		if("move")
			if(command_target)
				var/turf/T = get_turf(command_target)
				if(!T)
					command_mode = "idle"
					return
				walk_to(src, T, 0, 2)
				if(get_turf(src) == T)
					command_mode = "idle"

		if("attack")
			if(command_target && istype(command_target, /mob))
				if(!should_target(command_target))
					command_mode = "idle"
					command_target = null
				else
					target = command_target
					. = ..() // run parent AI (engage in combat)
					return
			else
				command_mode = "idle"
				command_target = null

		if("idle")
			return ..() // default idle AI (wandering etc.)