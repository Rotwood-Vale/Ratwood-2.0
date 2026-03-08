/**********************Mineral deposits**************************/

/turf/closed/rock //wall piece
	name = "rock"
	desc = "Lichens and moss cling to the jagged contours of the rock face. It is slick with moisture and exudes the heavy odors of dirt, minerals, and petrichor."
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockyash"
	var/smooth_icon = 'icons/turf/smoothrocks.dmi'
	opacity = 1
	density = TRUE
//	layer = EDGED_TURF_LAYER
	temperature = TCMB
	var/environment_type = "asteroid"
	var/turf/open/floor/turf_type = /turf/open/floor
	var/obj/item/mineralType = null
	var/obj/item/natural/rock/rockType = null
	var/mob/living/lastminer //for xp gain and luck shenanigans
	var/mineralAmt = 3
	var/spread = 0 //will the seam spread?
	var/spreadChance = 0 //the percentual chance of an ore spreading to the neighbouring tiles
	var/last_act = 0
	var/scan_state = "" //Holder for the image we display when we're pinged by a mining scanner
	var/defer_change = 0
	smooth = SMOOTH_TRUE | SMOOTH_MORE
	smooth_icon = 'icons/turf/walls/cwall.dmi'
	wallclimb = TRUE
	canSmoothWith = list(/turf/closed/rock/random, /turf/closed/rock)
	turf_type = /turf/open/floor/rogue/naturalstone
	baseturfs = /turf/open/floor/rogue/naturalstone
	mineralAmt = 1
	above_floor = /turf/open/floor/rogue/naturalstone
	mineralType = null
	rockType = null
	spreadChance = 0
	spread = 0
	blade_dulling = DULLING_PICK
	max_integrity = 1000
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg')
	neighborlay = "dirtedge"


/turf/closed/rock/Initialize(mapload)
	if (!canSmoothWith)
		canSmoothWith = list(/turf/closed/rock, /turf/closed/indestructible)
//	var/matrix/M = new
//	M.Translate(-4, -4)
//	transform = M
	icon = smooth_icon
	. = ..()

/turf/closed/rock/Destroy()
	. = ..()
	lastminer = null

/turf/closed/rock/LateInitialize()
	. = ..()
	if (mineralType && mineralAmt && spread && spreadChance)
		for(var/dir in GLOB.cardinals)
			if(prob(spreadChance))
				var/turf/T = get_step(src, dir)
				if(istype(T, /turf/closed/rock/random))
					Spread(T)
	var/turf/open/transparent/openspace/target = get_step_multiz(src, UP)
	if(istype(target))
		target.ChangeTurf(/turf/open/floor/rogue/naturalstone)

/turf/closed/rock/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	if(turf_type)
		underlay_appearance.icon = initial(turf_type.icon)
		underlay_appearance.icon_state = initial(turf_type.icon_state)
		return TRUE
	return ..()

/turf/closed/rock/attackby(obj/item/I, mob/user, params, multiplier)
	if (!user.IsAdvancedToolUser())
		to_chat(usr, span_warning("I don't have the dexterity to do this!"))
		return
	lastminer = user
	..()
	if(istype(I, /obj/item/weapon/pick))
		if(!isliving(user))
			return

		var/mob/living/L = user
		user.doing = FALSE
		// Makes more sense for the check since they always
		// become an open tile afterwards
		while(density && user.Adjacent(src))
			if((L.energy > 0) && (do_after(user, CLICK_CD_MELEE, TRUE, src)))
				..()
				var/olddam = turf_integrity
				if(turf_integrity && turf_integrity > 10)
					if(turf_integrity < olddam)
						if(prob(50))
							if(user.Adjacent(src))
								var/obj/item/natural/stone/S = new(src)
								S.forceMove(get_turf(user))
					if(!density)
						break
			else
				break

/turf/closed/rock/attack_right(mob/user)
	var/obj/item = user.get_active_held_item()
	if(user.used_intent.type == /datum/intent/pick && (user.get_skill_level(/datum/skill/labor/mining) >= SKILL_LEVEL_JOURNEYMAN))
		if(do_after(user, 4 SECONDS, TRUE, src))
			if(!ismineralturf(src))
				return
			src.attackby(item, user, multiplier = 4)
			user.stamina_add(25)
	..()

/turf/closed/rock/turf_destruction(damage_flag)
	if(!(istype(src, /turf/closed)))
		return
	if(damage_flag == "blunt")
		var/obj/item/explo_mineral = mineralType
		var/explo_mineral_amount = mineralAmt
		var/obj/item/natural/rock/explo_rock = rockType
		ScrapeAway()
		GLOB.mined_resource_loc |= get_turf(src)
		queue_smooth_neighbors(src)
		new /obj/item/natural/stone(src)
		if(prob(30))
			new /obj/item/natural/stone(src)
		if (explo_mineral && (explo_mineral_amount > 0))
			if(prob(33)) //chance to spawn ore directly
				new explo_mineral(src)
			if(explo_rock)
				if(prob(23))
					new explo_rock(src)
			SSblackbox.record_feedback("tally", "ore_mined", explo_mineral_amount, explo_mineral)
		else
			return
	else
		if(lastminer.goodluck(2) && mineralType)
	//		to_chat(lastminer, span_notice("Bonus ducks!"))
			new mineralType(src)
		gets_drilled(lastminer)
		queue_smooth_neighbors(src)
	..()

/turf/closed/rock/proc/gets_drilled(mob/living/user, triggered_by_explosion = FALSE, give_exp = TRUE)
	new /obj/item/natural/stone(src)
	if(prob(30))
		new /obj/item/natural/stone(src)
	if (mineralType && (mineralAmt > 0))
		if(prob(33)) //chance to spawn ore directly
			new mineralType(src)
		if(rockType) //always spawn at least 1 rock
			new rockType(src)
			if(prob(23))
				new rockType(src)
		SSblackbox.record_feedback("tally", "ore_mined", mineralAmt, mineralType)
	else if(user?.goodluck(2))
		var/newthing = pickweight(list(/obj/item/natural/rock/salt = 2, /obj/item/natural/rock/iron = 1, /obj/item/natural/rock/coal = 2))
//		to_chat(user, "<span class='notice'>Bonus ducks!</span>")
		new newthing(src)
	var/flags = NONE
	if(defer_change) // TODO: make the defer change var a var for any changeturf flag
		flags = CHANGETURF_DEFER_CHANGE
	ScrapeAway(null, flags)
	addtimer(CALLBACK(src, PROC_REF(AfterChange)), 1, TIMER_UNIQUE)

/turf/closed/rock/attack_animal(mob/living/simple_animal/user)
	if((user.environment_smash & ENVIRONMENT_SMASH_WALLS) || (user.environment_smash & ENVIRONMENT_SMASH_RWALLS))
		gets_drilled(user)
	if(user.can_mine && do_after(user, CLICK_CD_MELEE))
		playsound(src,'sound/combat/hits/onstone/wallhit.ogg', 600, TRUE, 10)
		visible_message(span_warning("[user] smashes [src]!"))
		turf_integrity -= 500
		if(turf_integrity <= 0)
			gets_drilled(user)
	..()

/turf/closed/rock/acid_melt()
	ScrapeAway()

/turf/closed/rock/ex_act(severity, target)
	..()
	switch(severity)
		if(3)
			if (prob(75))
				gets_drilled(null, triggered_by_explosion = TRUE)
		if(2)
			if (prob(90))
				gets_drilled(null, triggered_by_explosion = TRUE)
		if(1)
			gets_drilled(null, triggered_by_explosion = TRUE)
	return

/turf/closed/rock/Spread(turf/T)
	T.ChangeTurf(type)

/turf/closed/rock/random
	///if this isn't empty, swaps to one of them via pickweight
	var/list/mineralSpawnChanceList = list()
	///the chance to swap to something useful
	var/mineralChance = 13
	var/display_icon_state = "rock"
//	layer = ABOVE_MOB_LAYER
	name = "rock"
	desc = "Lichens and moss cling to the jagged contours of the rock face. It is slick with moisture and exudes the heavy odors of dirt, minerals, and petrichor."
	icon = 'icons/turf/walls.dmi'
	icon_state = "minrandbad"
	smooth = SMOOTH_TRUE | SMOOTH_MORE
	smooth_icon = 'icons/turf/walls/cwall.dmi'
	wallclimb = TRUE
	canSmoothWith = list(/turf/closed/rock/random, /turf/closed/rock)
	turf_type = /turf/open/floor/rogue/naturalstone
	above_floor = /turf/open/floor/rogue/naturalstone
	baseturfs = list(/turf/open/floor/rogue/naturalstone)
	mineralSpawnChanceList = list(
		/turf/closed/rock/salt = 5,
		/turf/closed/rock/iron = 15,
		/turf/closed/rock/copper = 10,
		/turf/closed/rock/coal = 25)
	mineralChance = 23

/turf/closed/rock/random/Initialize(mapload)

	mineralSpawnChanceList = typelist("mineralSpawnChanceList", mineralSpawnChanceList)

	if (display_icon_state)
		icon_state = display_icon_state
	. = ..()
	if (prob(mineralChance))
		var/path = pickweight(mineralSpawnChanceList)
		var/turf/T = ChangeTurf(path,null,CHANGETURF_IGNORE_AIR)

		if(T && ismineralturf(T))
			var/turf/closed/rock/M = T
			M.mineralAmt = rand(1, 5)
			M.environment_type = src.environment_type
			M.turf_type = src.turf_type
			M.baseturfs = src.baseturfs
			src = M
			M.levelupdate()

/turf/closed/rock/random/med
	icon_state = "minrandmed"
	mineralChance = 10
	mineralSpawnChanceList = list(
		/turf/closed/rock/salt = 5,
		/turf/closed/rock/gold = 3,
		/turf/closed/rock/silver = 2,
		/turf/closed/rock/iron = 33,
		/turf/closed/rock/elementalmote = 15,
		/turf/closed/rock/cinnabar = 15,
		/turf/closed/rock/copper = 15,
		/turf/closed/rock/tin = 10,
		/turf/closed/rock/coal = 14,
		/turf/closed/rock/gem = 1)

/turf/closed/rock/random/high
	icon_state = "minrandhigh"
	mineralChance = 33
	mineralSpawnChanceList = list(
		/turf/closed/rock/elementalmote = 15,
		/turf/closed/rock/cinnabar = 15,
		/turf/closed/rock/salt = 5,
		/turf/closed/rock/gold = 9,
		/turf/closed/rock/silver = 5,
		/turf/closed/rock/iron = 33,
		/turf/closed/rock/copper = 20,
		/turf/closed/rock/tin = 12,
		/turf/closed/rock/coal = 19,
		/turf/closed/rock/gem = 3)


/turf/closed/rock/random/coppertin/med
	icon_state = "minrandmed"
	mineralChance = 10
	mineralSpawnChanceList = list(/turf/closed/rock/gold = 3,
	/turf/closed/rock/silver = 2,
	/turf/closed/rock/copper = 33,
	/turf/closed/rock/tin = 12,
	/turf/closed/rock/gem = 1)

/turf/closed/rock/random/coppertin/high
	icon_state = "minrandhigh"
	mineralChance = 33
	mineralSpawnChanceList = list(/turf/closed/rock/gold = 9,
	/turf/closed/rock/silver = 5,
	/turf/closed/rock/copper = 22,
	/turf/closed/rock/tin = 15,
	/turf/closed/rock/gem = 3)

/turf/closed/rock/random/ironcoal/med
	icon_state = "minrandmed"
	mineralChance = 10
	mineralSpawnChanceList = list( /turf/closed/rock/salt = 5,
	/turf/closed/rock/gold = 3,
	/turf/closed/rock/silver = 2,
	/turf/closed/rock/iron = 33,
	/turf/closed/rock/coal = 14,
	/turf/closed/rock/gem = 1)

/turf/closed/rock/random/ironcoal/high
	icon_state = "minrandhigh"
	mineralChance = 33
	mineralSpawnChanceList = list(/turf/closed/rock/gold = 9,
	/turf/closed/rock/silver = 5,
	/turf/closed/rock/iron = 33,
	/turf/closed/rock/coal = 19,
	/turf/closed/rock/gem = 3)

/turf/closed/rock/random/boglava/med
	icon_state = "minrandmed"
	mineralChance = 20
	mineralSpawnChanceList = list(/turf/closed/rock/cinnabar = 20,
	/turf/closed/rock/gold = 10,
	/turf/closed/rock/silver = 5,
	/turf/closed/rock/iron = 33,
	/turf/closed/rock/coal = 14,
	/turf/closed/rock/gem = 3)

/turf/closed/rock/random/boglava/high
	icon_state = "minrandhigh"
	mineralChance = 45
	mineralSpawnChanceList = list(/turf/closed/rock/cinnabar = 20,
	/turf/closed/rock/gold = 15,
	/turf/closed/rock/silver = 10,
	/turf/closed/rock/iron = 33,
	/turf/closed/rock/coal = 19,
	/turf/closed/rock/gem = 6)



//begin actual mineral turfs
/turf/closed/rock
//	layer = ABOVE_MOB_LAYER

/turf/closed/rock/gold
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/gold
	rockType = /obj/item/natural/rock/gold
	spreadChance = 5
	spread = 1

/turf/closed/rock/silver
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/silver
	rockType = /obj/item/natural/rock/silver
	spreadChance = 5
	spread = 1

/turf/closed/rock/salt
	icon_state = "mingold"
	mineralType = /obj/item/reagent_containers/powder/salt
	rockType = /obj/item/natural/rock/salt
	spreadChance = 33
	spread = 15

/turf/closed/rock/iron
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/iron
	rockType = /obj/item/natural/rock/iron
	spreadChance = 23
	spread = 5

/turf/closed/rock/copper
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/copper
	rockType = /obj/item/natural/rock/copper
	spreadChance = 27
	spread = 8

/turf/closed/rock/tin
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/tin
	rockType = /obj/item/natural/rock/tin
	spreadChance = 15
	spread = 5

/turf/closed/rock/coal
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/coal
	rockType = /obj/item/natural/rock/coal
	spreadChance = 33
	spread = 11

/turf/closed/rock/elementalmote //chance for elemental motes to drop, low, like with cinnabar
	icon_state = "mingold"
	mineralType = /obj/item/magic/elemental/mote
	rockType = /obj/item/natural/rock/elementalmote
	spreadChance = 23
	spread = 5

/turf/closed/rock/cinnabar
	icon_state = "mingold"
	mineralType = /obj/item/rogueore/cinnabar
	rockType = /obj/item/natural/rock/cinnabar
	spreadChance = 23
	spread = 5

/turf/closed/rock/gem
	icon_state = "mingold"
	mineralType = /obj/item/roguegem/random
	rockType = /obj/item/natural/rock/gem
	spreadChance = 3
	spread = 2

/turf/closed/rock/bedrock
	name = "rock"
	desc = "Seems barren and nigh-indestructable"
	icon_state = "rockyashbed"
//	smooth_icon = 'icons/turf/walls/hardrock.dmi'
	max_integrity = 10000000
	damage_deflection = 99999999
	above_floor = /turf/closed/rock/bedrock

/turf/closed/rock/bedrock/attackby(obj/item/I, mob/user, params, multiplier)
	to_chat(user, span_warning("TOO HARD!"))
	return FALSE

/turf/closed/rock/bedrock/TerraformTurf(path, new_baseturf, flags, defer_change = FALSE, ignore_air = FALSE)
	return

/turf/closed/rock/bedrock/acid_act(acidpwr, acid_volume, acid_id)
	return 0

/turf/closed/rock/bedrock/Melt()
	to_be_destroyed = FALSE
	return src
