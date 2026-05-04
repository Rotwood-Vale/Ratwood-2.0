/obj/structure/flora/newtreealt//a visually different version for use in sunnier brighter environments. Would have wanted to make it an easy subtype but it has separate branches and leaves
	name = "tree"
	desc = "The thick core of a tree."
	icon = 'icons/roguetown/misc/treealt.dmi'
	icon_state = "tree1"
	var/tree_type = 1
	var/base_state
	blade_dulling = DULLING_CUT
	opacity = 1
	density = 1
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/woodhit.ogg'
	climbable = FALSE
	static_debris = list(/obj/item/grown/log/tree = 1)
	obj_flags = CAN_BE_HIT | BLOCK_Z_IN_UP | BLOCK_Z_OUT_DOWN
	max_integrity = 400
	//If the tree has been burn beforehand.
	var/burnt = FALSE

/obj/structure/flora/newtreealt/fire_act(added, maxstacks)
	. = ..()
	if(.)
		burnt = TRUE
		if(icon_state != "burnt")
			name = "burnt tree"
			update_icon()

/obj/structure/flora/newtreealt/attack_right(mob/user)
	handle_special_items_retrieval(user, src)

/obj/structure/flora/newtreealt/obj_destruction(damage_flag)//this proc is stupidly long for a destruction proc
	var/turf/NT = get_turf(src)
	var/turf/UPNT = get_step_multiz(src, UP)
	src.obj_flags = CAN_BE_HIT | BLOCK_Z_IN_UP //so the logs actually fall when pulled by zfall
	if(burnt)
		damage_flag = "fire"

	for(var/obj/structure/flora/newtreealt/D in UPNT)//theoretically you'd be able to break trees through a floor but no one is building floors under a tree so this is probably fine
		D.obj_destruction(damage_flag)
	for(var/obj/item/grown/log/tree/I in UPNT)
		UPNT.zFall(I)

	for(var/DI in GLOB.cardinals)
		var/turf/B = get_step(src, DI)
		for(var/obj/structure/flora/newbranchalt/BRANCH in B)//i straight up can't use locate here, it does not work
			if(BRANCH.dir == DI)
				var/turf/BI = get_step(B, DI)
				for(var/obj/structure/flora/newbranchalt/bi in BI)//2 tile end branch
					if(bi.dir == DI)
						bi.obj_flags = CAN_BE_HIT
						bi.obj_destruction(damage_flag)
					for(var/atom/bio in BI)
						BI.zFall(bio)
				for(var/obj/structure/flora/newleafalt/bil in BI)//2 tile end leaf
					bil.obj_destruction(damage_flag)
				BRANCH.obj_flags = CAN_BE_HIT 
				BRANCH.obj_destruction(damage_flag)
			for(var/atom/BRA in B)//unload a sack of rocks on a branch and stand under it, it'll be funny bro
				B.zFall(BRA)
	
	for(var/turf/DIA in block(get_step(src, SOUTHWEST), get_step(src, NORTHEAST)))
		for(var/obj/structure/flora/newleafalt/LEAF in DIA)
			LEAF.obj_destruction(damage_flag)

	if(!istype(NT, /turf/open/transparent/openspace) && !(locate(/obj/structure/flora/roguetree/stump) in NT))//if i don't add the stump check it spawns however many zlevels it goes up because of src recursion
		new /obj/structure/flora/roguetree/stump(NT)
	playsound(src, 'sound/misc/treefall.ogg', 100, FALSE)
	. = ..()

/obj/structure/flora/newtreealt/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS || L.incapacitated() || !(L.mobility_flags & MOBILITY_STAND))
			return
		var/turf/target = get_step_multiz(user, UP)
		if(!istype(target, /turf/open/transparent/openspace))
			to_chat(user, span_warning("I can't climb here."))
			return
		if(!L.can_zTravel(target, UP))
			to_chat(user, span_warning("I can't climb there."))
			return
		var/used_time = 3 SECONDS
		var/exp_to_gain = 0
		var/myskill = SKILL_LEVEL_NOVICE // default for NPCs
		if(L.mind)
			myskill = L.get_skill_level(/datum/skill/misc/climbing)
			if(HAS_TRAIT(L, TRAIT_WOODWALKER))
				exp_to_gain = L.STAINT
			else
				exp_to_gain = L.STAINT/2
			var/obj/structure/table/TA = locate() in L.loc
			if(TA)
				myskill += 1
			else
				var/obj/structure/chair/CH = locate() in L.loc
				if(CH)
					myskill += 1
			used_time = max(70 - (myskill * 10) - (L.STASPD * 3), (HAS_TRAIT(L, TRAIT_WOODWALKER) ? 15 : 30))
		playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
		user.visible_message(span_warning("[user] starts to climb [src]."), span_warning("I start to climb [src]..."))
		if(do_after(L, used_time, target = src))
			var/pulling = user.pulling
			if(ismob(pulling))
				user.pulling.forceMove(target)
			user.forceMove(target)
			user.start_pulling(pulling,supress_message = TRUE)
			playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
			if(L.mind) // idk just following whats going on above
				L.mind.add_sleep_experience(/datum/skill/misc/climbing, exp_to_gain, FALSE)

/obj/structure/flora/newtreealt/attacked_by(obj/item/I, mob/living/user)
	var/was_destroyed = obj_destroyed
	. = ..()
	if(.)
		if(!was_destroyed && obj_destroyed)
			SEND_SIGNAL(user, COMSIG_MOB_FELL_TREE)
			record_featured_stat(FEATURED_STATS_TREE_FELLERS, user)
			record_round_statistic(STATS_TREES_CUT)

/obj/structure/flora/newtreealt/update_icon()
	icon_state = ""
	if(burnt)
		icon_state = "burnt"
		cut_overlays()
		return
	cut_overlays()
	var/mutable_appearance/M
	if(base_state)
		M = mutable_appearance(icon, "[base_state]")
		add_overlay(M)
	M = mutable_appearance(icon, "tree[tree_type]")
	M.dir = dir
	add_overlay(M)

/obj/structure/flora/newtreealt/Initialize(mapload)
	. = ..()
	tree_type = rand(1,2)
	dir = pick(GLOB.cardinals)
	SStreesetup.initialize_me |= src
	build_trees()
	update_icon()
	if(istype(loc, /turf/open/floor/rogue/grass))
		var/turf/T = loc
		T.ChangeTurf(/turf/open/floor/rogue/dirt)

/obj/structure/flora/newtreealt/proc/build_trees()
	var/turf/target = get_step_multiz(src, UP)
	if(istype(target, /turf/open/transparent/openspace))
		var/obj/structure/flora/newtreealt/T = new(target)
		T.base_state = "center-leaf[rand(1,2)]"
		T.update_icon()

/obj/structure/flora/newtreealt/proc/build_branches()
	for(var/D in GLOB.cardinals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/transparent/openspace))
			var/turf/NB = get_step(NT, D)
			if(istype(NB, /turf/open/transparent/openspace) && prob(50))//make an ending branch
				if(prob(50))
					if(!locate(/obj/structure) in NB)
						var/obj/structure/flora/newbranchalt/T = new(NB)
						T.dir = D
					if(!locate(/obj/structure) in NT)
						var/obj/structure/flora/newbranchalt/connector/TC = new(NT)
						TC.dir = D
				else
					if(!locate(/obj/structure) in NB)
						new /obj/structure/flora/newleafalt(NB)
					if(!locate(/obj/structure) in NT)
						var/obj/structure/flora/newbranchalt/TC = new(NT)
						TC.dir = D
			else
				if(!locate(/obj/structure) in NT)
					var/obj/structure/flora/newbranchalt/TC = new(NT)
					TC.dir = D
		else
			if(prob(70))
				if(isopenturf(NT))
					if(!istype(loc, /turf/open/transparent/openspace)) //must be lowest
						if(!locate(/obj/structure) in NT)
							var/obj/structure/flora/newbranchalt/leafless/T = new(NT)
							T.dir = D


/obj/structure/flora/newtreealt/proc/build_leafs()
	for(var/D in GLOB.diagonals)
		var/turf/NT = get_step(src, D)
		if(istype(NT, /turf/open/transparent/openspace))
			if(!locate(/obj/structure) in NT)
				var/obj/structure/flora/newleafalt/corner/T = new(NT)
				T.dir = D


///BRANCHES

/obj/structure/flora/newbranchalt
	name = "branch"
	desc = "A stable branch, should be safe to walk on."
	icon = 'icons/roguetown/misc/treealt.dmi'
	icon_state = "branch-end1"
	attacked_sound = 'sound/misc/woodhit.ogg'
//	var/tree_type = 1
	var/base_state = TRUE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	plane = FLOOR_PLANE
	static_debris = list(/obj/item/grown/log/tree/stick = 1)
	density = FALSE
	max_integrity = 30

/obj/structure/flora/newbranchalt/update_icon()
	icon_state = ""
	cut_overlays()
	var/mutable_appearance/M
	if(base_state)
		M = mutable_appearance(icon, "[base_state]")
		M.dir = pick(GLOB.cardinals)
		add_overlay(M)
	M = mutable_appearance(icon, "branch-end[rand(1,2)]")
	M.dir = dir
	add_overlay(M)

/obj/structure/flora/newbranchalt/Initialize(mapload)
	. = ..()
	if(base_state)
		AddComponent(/datum/component/squeak, list('sound/foley/plantcross1.ogg','sound/foley/plantcross2.ogg','sound/foley/plantcross3.ogg','sound/foley/plantcross4.ogg'), 100)
		base_state = "center-leaf[rand(1,2)]"
	update_icon()

/obj/structure/flora/newbranchalt/connector
	icon_state = "branch-extend"

/obj/structure/flora/newbranchalt/connector/update_icon()
	icon_state = ""
	cut_overlays()
	var/mutable_appearance/M
	if(base_state)
		M = mutable_appearance(icon, "[base_state]")
		M.dir = pick(GLOB.cardinals)
		add_overlay(M)
	M = mutable_appearance(icon, "branch-extend")
	M.dir = dir
	add_overlay(M)

/obj/structure/flora/newbranchalt/leafless
	base_state = FALSE

/obj/structure/flora/newbranchalt/leafless/update_icon()
	icon_state = ""
	cut_overlays()
	var/mutable_appearance/M = mutable_appearance(icon, "branch-end[rand(1,2)]")
	M.dir = dir
	add_overlay(M)

/// LEAF


/obj/structure/flora/newleafalt/corner
	icon = 'icons/roguetown/misc/treealt.dmi'
	icon_state = "corner-leaf1"


/obj/structure/flora/newleafalt/corner/Initialize(mapload)
	. = ..()
	icon_state = "corner-leaf[rand(1,2)]"
	update_icon()

/obj/structure/flora/newleafalt
	name = "leaves"
	icon = 'icons/roguetown/misc/treealt.dmi'
	icon_state = "center-leaf1"
	density = FALSE
	max_integrity = 10
	plane = FLOOR_PLANE

/obj/structure/flora/newleafalt/Initialize(mapload)
	. = ..()
	icon_state = "center-leaf[rand(1,2)]"
	update_icon()
