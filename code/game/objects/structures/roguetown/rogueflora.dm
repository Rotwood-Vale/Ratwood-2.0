#define SEARCHTIME 12 // Standard search cooldown = 1.2 seconds
//newtree

/obj/structure/flora/roguetree
	name = "古树"
	desc = "一棵连精灵都爱不起来的古老邪树。"
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "t1"
	opacity = 1
	density = 1
	max_integrity = 200
	blade_dulling = DULLING_CUT
	pixel_x = -16
	layer = 4.81
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/woodhit.ogg'
	debris = list(/obj/item/grown/log/tree/stick = 2)
	static_debris = list(/obj/item/grown/log/tree = 1)
	alpha = 200
	var/stump_type = /obj/structure/flora/roguetree/stump
	metalizer_result = /obj/machinery/light/rogue/lanternpost
	smeltresult = /obj/item/rogueore/coal

/obj/structure/flora/roguetree/attack_right(mob/user)
	handle_special_items_retrieval(user, src)

/obj/structure/flora/roguetree/attackby(obj/item/I, mob/living/user, params)
	if(!isliving(user) || user.used_intent.blade_class != BCLASS_CHOP)
		return ..()
	var/mob/living/L = user
	if(L.client && !L.client.prefs?.autowoodcut)
		return ..()
	if(user.doing)
		return ..()
	user.doing = FALSE
	while(!QDELETED(src) && user.Adjacent(src))
		if((L.energy > 0) && do_after(user, 1.5 SECONDS, TRUE, src))
			if(QDELETED(src))
				break
			..()
		else
			break

/obj/structure/flora/roguetree/attacked_by(obj/item/I, mob/living/user)
	var/was_destroyed = obj_destroyed
	. = ..()
	if(.)
		if(!was_destroyed && obj_destroyed)
			SEND_SIGNAL(user, COMSIG_MOB_FELL_TREE)
			record_featured_stat(FEATURED_STATS_TREE_FELLERS, user)
			record_round_statistic(STATS_TREES_CUT)

/obj/structure/flora/roguetree/spark_act()
	fire_act()

/obj/structure/flora/roguetree/Initialize(mapload)
	. = ..()

/*
	if(makevines)
		var/turf/target = get_step_multiz(src, UP)
		if(istype(target, /turf/open/transparent/openspace))
			target.ChangeTurf(/turf/open/floor/rogue/shroud)
			var/makecanopy = FALSE
			for(var/D in GLOB.cardinals)
				if(!makecanopy)
					var/turf/NT = get_step(src, D)
					for(var/obj/structure/flora/roguetree/R in NT)
						if(R.makevines)
							makecanopy = TRUE
							break
			if(makecanopy)
				for(var/D in GLOB.cardinals)
					var/turf/NT = get_step(target, D)
					if(NT)
						if(istype(NT, /turf/open/transparent/openspace) || istype(NT, /turf/open/floor/rogue/shroud))
							NT.ChangeTurf(/turf/closed/wall/shroud)
							for(var/X in GLOB.cardinals)
								var/turf/NA = get_step(NT, X)
								if(NA)
									if(istype(NA, /turf/open/transparent/openspace))
										NA.ChangeTurf(/turf/open/floor/rogue/shroud)
*/

	if(istype(loc, /turf/open/floor/rogue/grass))
		var/turf/T = loc
		T.ChangeTurf(/turf/open/floor/rogue/dirt)

/obj/structure/flora/roguetree/obj_destruction(damage_flag)
	if(stump_type)
		new stump_type(loc)
	playsound(src, 'sound/misc/treefall.ogg', 100, FALSE)
	. = ..()


/obj/structure/flora/roguetree/Initialize(mapload)
	. = ..()
	icon_state = "t[rand(1,16)]"

/obj/structure/flora/roguetree/proc/bless_tree(mob/user)
	if(obj_integrity < max_integrity)
		obj_integrity = min(max_integrity, obj_integrity + round(max_integrity / 2))
		return TRUE
	return FALSE

/obj/structure/flora/roguetree/proc/reinvigorate_tree(mob/user)
	if(type == /obj/structure/flora/roguetree)
		spawn_reinvigorated_tree()
		if(isliving(user) && user.mind)
			user.mind.add_sleep_experience(/datum/skill/magic/druidic, 20)
		return TRUE
	return FALSE

/obj/structure/flora/roguetree/proc/spawn_reinvigorated_tree()
	new /obj/structure/flora/newtree(get_turf(src))
	qdel(src)
	return TRUE

/obj/structure/flora/roguetree/evil/Initialize(mapload)
	. = ..()
	icon_state = "wv[rand(1,2)]"
	soundloop = new(src, FALSE)
	soundloop.start()

/obj/structure/flora/roguetree/evil/Destroy()
	soundloop.stop()
	if(controller)
		controller.endvines()
		controller.tree = null
	controller = null
	. = ..()

/obj/structure/flora/roguetree/evil
	var/datum/looping_sound/boneloop/soundloop
	var/datum/vine_controller/controller

/obj/structure/flora/roguetree/evil/reinvigorate_tree(mob/user)
	var/turf/T = get_turf(src)
	for(var/D in GLOB.cardinals)
		var/turf/adj = get_step(T, D)
		if(!isclosedturf(adj) && !locate(/obj/structure/glowshroom) in adj)
			new /obj/structure/glowshroom(adj)
	// Evil trees cleansed by Dendor's blessing become sanctified, not merely regrown.
	new /obj/structure/flora/roguetree/wise/sanctified(T)
	qdel(src)
	if(isliving(user) && user.mind)
		user.mind.add_sleep_experience(/datum/skill/magic/druidic, 50)
	return TRUE

/obj/structure/flora/roguetree/wise
	name = "圣树"
	desc = "一棵受祝福的原初古树，古老得超越岁月。传说它正是树父本身的化身，仅仅站在它身旁，德鲁伊便会被灌注野性的能量。"
	icon_state = "mystical"
	max_integrity = 400
	var/activated = FALSE
	var/cooldown = FALSE
	var/retaliation_messages = list(
		"别再伤害森林了！",
		"Dendor 庇护此地！",
		"自然之怒！",
		"滚开，闯入者！"
	)

/obj/structure/flora/roguetree/wise/Initialize(mapload)
	. = ..()
	icon_state = "mystical"

/obj/structure/flora/roguetree/wise/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(activated && !cooldown)
		retaliate(user)


/obj/structure/flora/roguetree/wise/proc/retaliate(mob/living/target)
	if(cooldown || !istype(target) || !activated)
		return

	cooldown = TRUE
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 5 SECONDS)

	var/message = pick(retaliation_messages)
	say(span_danger("[message]"))

	var/atom/throw_target = get_edge_target_turf(src, get_dir(src, target))
	target.throw_at(throw_target, 4, 2)
	target.adjustBruteLoss(8)

/obj/structure/flora/roguetree/wise
	var/examine_plays_music = TRUE

/obj/structure/flora/roguetree/wise/examine(mob/user)
	. = ..()
	if(examine_plays_music)
		SEND_SOUND(user, sound(null))
		playsound(user, 'sound/music/tree.ogg', 80)

/obj/structure/flora/roguetree/wise/bless_tree(mob/user)
	if(obj_integrity < max_integrity)
		obj_integrity = min(max_integrity, obj_integrity + 50)
		return TRUE
	return FALSE

/// Converts an unsanctified wise tree into a sanctified wise tree.
/// Called from blesscrop when blessed seed powder is held.
/obj/structure/flora/roguetree/wise/reinvigorate_tree(mob/user)
	if(istype(src, /obj/structure/flora/roguetree/wise/sanctified))
		return FALSE  // already sanctified in some form
	var/turf/T = get_turf(src)
	new /obj/structure/flora/roguetree/wise/sanctified/wise(T)
	qdel(src)
	if(isliving(user) && user.mind)
		user.mind.add_sleep_experience(/datum/skill/magic/druidic, 50)
	return TRUE

/obj/structure/flora/roguetree/wise/proc/notify_nearby_dendorites()
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		if(H.patron?.type != /datum/patron/divine/dendor)
			continue
		if(H.z != z)
			continue
		if(get_dist(H, src) > 10)
			continue
		H.add_stress(/datum/stressevent/treefather_loss)
		var/tree_dir = dir2text(get_dir(H, src))
		to_chat(H, span_boldwarning("我[tree_dir]方向的一棵圣树倒下了！这片土地的自然能量似乎受到了扰乱。"))
		playsound(H, 'sound/misc/jack_killing_2.ogg', 60, FALSE)

/obj/structure/flora/roguetree/wise/proc/fling_nearby_mobs()
	for(var/mob/living/L in range(3, src))
		if(L.stat == DEAD)
			continue
		var/atom/throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(L, src)))
		if(!throwtarget)
			continue
		L.safe_throw_at(throwtarget, 4, 1, force = MOVE_FORCE_STRONG)
		L.Knockdown(2 SECONDS)

/obj/structure/flora/roguetree/wise/obj_destruction(damage_flag)
	fling_nearby_mobs()
	notify_nearby_dendorites()
	return ..()

/obj/structure/flora/roguetree/burnt
	name = "烧焦的树"
	desc = "也许是闪电，也许是战火，夺去了这棵曾经生机勃勃的树木的生命。"
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "t1"
	stump_type = /obj/structure/flora/roguetree/stump/burnt
	pixel_x = -32

/obj/structure/flora/roguetree/burnt/Initialize(mapload)
	. = ..()
	icon_state = "t[rand(1,4)]"

/obj/structure/flora/roguetree/burnt/reinvigorate_tree(mob/user)
	spawn_reinvigorated_tree()
	if(isliving(user) && user.mind)
		user.mind.add_sleep_experience(/datum/skill/magic/druidic, 20)
	return TRUE

/obj/structure/flora/roguetree/stump/burnt
	name = "烧焦树桩"
	desc = "这截树桩已经被烧得焦黑。也许有人想用最省事的办法烧出木炭。"
	icon_state = "st1"
	icon = 'icons/roguetown/misc/96x96.dmi'
	stump_type = null
	pixel_x = -32
	metalizer_result = /obj/machinery/anvil

/obj/structure/flora/roguetree/stump/burnt/Initialize(mapload)
	. = ..()
	icon_state = "st[rand(1,2)]"

/obj/structure/flora/roguetree/stump/pine
	name = "松树桩"
	icon_state = "dead4"
	icon = 'icons/obj/flora/pines.dmi'
	static_debris = list(/obj/item/rogueore/coal/charcoal = 1)
	stump_type = null
	pixel_x = -32

/obj/structure/flora/roguetree/stump/pine/Initialize(mapload)
	. = ..()
	icon_state = "dead[rand(4,5)]"

/obj/structure/flora/roguetree/underworld
	name = "尖啸树"
	desc = "到处都是人的脸。"
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "screaming1"
	opacity = 1
	density = 1

/obj/structure/flora/roguetree/underworld/Initialize(mapload)
	. = ..()
	icon_state = "screaming[rand(1,3)]"

/obj/structure/flora/roguetree/stump
	name = "树桩"
	desc = "有人把这棵树砍倒了。"
	icon_state = "t1stump"
	opacity = 0
	max_integrity = 100
	climbable = TRUE
	climb_time = 0
	layer = TABLE_LAYER
	plane = GAME_PLANE
	blade_dulling = DULLING_CUT
	// debris = list(/obj/item/grown/log/tree/stick = 1) // Removed for lumberjacking/handcart upgrade PR
	static_debris = list(/obj/item/grown/log/tree/small = 1)
	alpha = 255
	pixel_x = -16
	climb_offset = 14
	stump_type = FALSE
	metalizer_result = /obj/machinery/anvil
	var/lumber_amount = 1
	var/lumber = /obj/item/grown/log/tree/small

/obj/structure/flora/roguetree/stump/Initialize(mapload)
	. = ..()
	icon_state = "t[rand(1,4)]stump"

/obj/structure/flora/roguetree/stump/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/rogueweapon/shovel))
		var/skill_level = user.get_skill_level(/datum/skill/labor/lumberjacking)
		var/dig_time = (120 - (skill_level * 15)) / 2
		playsound(src, 'sound/items/dig_shovel.ogg', 80, TRUE)
		if(!do_after(user, dig_time, target = user))
			return
		to_chat(user, span_notice("我把[src]挖了出来。"))
		new lumber(get_turf(src))
		playsound(src, destroy_sound, 100, TRUE)
		qdel(src)
		return TRUE
	if(user.used_intent.blade_class == BCLASS_CHOP && lumber_amount)
		var/skill_level = user.get_skill_level(/datum/skill/labor/lumberjacking)
		var/lumber_time = (120 - (skill_level * 15))
		playsound(src, 'sound/misc/woodhit.ogg', 100, TRUE)
		if(!do_after(user, lumber_time, target = user))
			return
		lumber_amount = rand(lumber_amount, max(lumber_amount, round(skill_level / 2)))
		var/essense_sound_played = FALSE //This is here so the sound wont play multiple times if the essense itself spawns multiple times
		for(var/i = 0; i < lumber_amount; i++)
			if(prob(skill_level + user.goodluck(2)))
				new /obj/item/grown/log/tree/small/essence(get_turf(src))
				if(!essense_sound_played)
					essense_sound_played = TRUE
					to_chat(user, span_warning("Dendor 正看顾着我们……"))
					playsound(src,pick('sound/items/gem.ogg'), 100, FALSE)
			else
				new lumber(get_turf(src))
		if(!skill_level)
			to_chat(user, span_info("要是我更熟练一些，本可以弄到更多木料……"))
		user.mind.add_sleep_experience(/datum/skill/labor/lumberjacking, (user.STAINT*0.5))
		playsound(src, destroy_sound, 100, TRUE)
		qdel(src)
		return TRUE
	else
		..()

/obj/structure/flora/roguetree/stump/log
	name = "远古朽木"
	desc = "一截早在久远年代便被自然残酷摧折的树木遗骸。"
	icon_state = "log1"
	opacity = 0
	max_integrity = 200
	blade_dulling = DULLING_CUT
	static_debris = list(/obj/item/grown/log/tree = 1)
	climb_offset = 14
	stump_type = FALSE

/obj/structure/flora/roguetree/stump/log/Initialize(mapload)
	. = ..()
	icon_state = "log[rand(1,2)]"

	AddComponent(/datum/component/hiding_spot, \
		"已经有人躲在%LOCATION里了！", \
		"我躲进了%LOCATION里！", \
		"我从%LOCATION里钻了出来！")

//newbushes

/obj/structure/flora/roguegrass
	name = "草"
	desc = "翠绿、柔软，充满生机。"
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "grass1"
	attacked_sound = "plantcross"
	destroy_sound = "plantcross"
	max_integrity = 2
	blade_dulling = DULLING_CUT
	debris = list(/obj/item/natural/fibers = 1)

/obj/structure/flora/roguegrass/spark_act()
	fire_act()

/obj/structure/flora/roguegrass/Initialize(mapload)
	update_icon()
	AddComponent(/datum/component/roguegrass)
	. = ..()

/obj/structure/flora/roguegrass/update_icon()
	icon_state = "grass[rand(1, 6)]"

/obj/structure/flora/roguegrass/verdant
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "sparsegrass_1"

/obj/structure/flora/roguegrass/verdant/Initialize(mapload)
	. = ..()
	if(prob(60))
		icon_state = "sparsegrass_[rand(1, 3)]"
	else
		icon_state = "fullgrass_[rand(1, 3)]"

/obj/structure/flora/roguegrass/reedbush
	name = "芦丛"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "reedbush_1"
	max_integrity = 1

/obj/structure/flora/roguegrass/reedbush/Initialize(mapload)
	. = ..()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/roguegrass/water
	name = "草"
	desc = "这片草地湿漉漉的，满是泥泞。"
	icon_state = "swampgrass"
	max_integrity = 5

/obj/structure/flora/roguegrass/water/reeds
	name = "芦苇"
	desc = "这种植物在水中繁茂生长，掩藏着危险。"
	icon_state = "reeds"
	opacity = 1
	max_integrity = 10
	layer = 4.1
	blade_dulling = DULLING_CUT

/obj/structure/flora/roguegrass/water/update_icon()
	dir = pick(GLOB.cardinals)

/datum/component/roguegrass/Initialize()
	RegisterSignal(parent, list(COMSIG_MOVABLE_CROSSED), PROC_REF(Crossed))

/datum/component/roguegrass/proc/Crossed(datum/source, atom/movable/AM)
	var/atom/A = parent

	if(isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == MOVE_INTENT_SNEAK)
			return
		else
			if(!(HAS_TRAIT(L, TRAIT_AZURENATIVE) && L.m_intent != MOVE_INTENT_RUN))
				playsound(A.loc, "plantcross", 100, FALSE, -1)
			var/oldx = A.pixel_x
			animate(A, pixel_x = oldx+1, time = 0.5)
			animate(pixel_x = oldx-1, time = 0.5)
			animate(pixel_x = oldx, time = 0.5)
			L.consider_ambush()
	return


/obj/structure/flora/roguegrass/bush
	name = "灌木丛"
	desc = "一丛灌木。上面爬满了蜘蛛，但也许里面藏着什么有用的东西..."
	icon_state = "bush2"
	layer = ABOVE_ALL_MOB_LAYER
	var/res_replenish
	blade_dulling = DULLING_CUT
	max_integrity = 100
	destroy_sound = "plantcross"
	climbable = FALSE
	dir = SOUTH
	debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1, /obj/item/natural/thorn = 2)
	var/list/looty = list()
	var/bushtype

/obj/structure/flora/roguegrass/bush/Initialize(mapload)
	AddComponent(/datum/component/hiding_spot)
	if(isnull(bushtype))
		var/area/rogue/bush_area = get_area(src)
		if(!bush_area.town_area)
			if(prob(88))
				bushtype = pickweight(list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue=5,
						/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison=3,
						/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed=1))
		else
			desc += "可惜，在这座城镇里多年的采摘已让它寸草不生。"
	loot_replenish()
	pixel_x += rand(-3,3)
	return ..()

/obj/structure/flora/roguegrass/bush/proc/loot_replenish()
	if(bushtype)
		looty += bushtype
	if(prob(66))
		looty += /obj/item/natural/thorn
	looty += /obj/item/natural/fibers


/obj/structure/flora/roguegrass/bush/Crossed(atom/movable/AM)
	..()
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == MOVE_INTENT_RUN && (L.mobility_flags & MOBILITY_STAND))
			if(!ishuman(L))
				to_chat(L, span_warning("我被荆棘划伤了！"))
				L.apply_damage(5, BRUTE)

			else
				var/mob/living/carbon/human/H = L
				if(prob(20))
					if(!HAS_TRAIT(src, TRAIT_PIERCEIMMUNE))
//						H.throw_alert("embeddedobject", /atom/movable/screen/alert/embeddedobject)
						var/obj/item/bodypart/BP = pick(H.bodyparts)
						var/obj/item/natural/thorn/TH = new(src.loc)
						BP.add_embedded_object(TH, silent = TRUE)
						BP.receive_damage(10)
						to_chat(H, span_danger("[TH]刺穿了我的[BP.name]！"))
				else
					var/obj/item/bodypart/BP = pick(H.bodyparts)
					to_chat(H, span_warning("一根荆棘[pick("划过","割破","划伤")]了我的[BP.name]。"))
					BP.receive_damage(10)

/obj/structure/flora/roguegrass/bush/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_INTENTCAP)
		playsound(src.loc, "plantcross", 50, FALSE, -1)
		if(do_after(L, SEARCHTIME, target = src))
			if(!looty.len && (world.time > res_replenish))
				loot_replenish()
			if(prob(50) && looty.len)
				if(looty.len == 1)
					res_replenish = world.time + 8 MINUTES
				var/obj/item/B = pick_n_take(looty)
				if(B)
					B = new B(user.loc)
					user.put_in_hands(B)
					user.visible_message(span_notice("[user]在[src]中找到了[B]。"))
					return
			user.visible_message(span_warning("[user]在[src]里摸索着。"))
			if(looty.len)
				attack_hand(user)
			if(!looty.len)
				to_chat(user, span_warning("被摘光了... 我该晚点再来。"))

/obj/structure/flora/roguegrass/bush/update_icon()
	icon_state = "bush[rand(2, 4)]"

/obj/structure/flora/roguegrass/bush/CanAStarPass(ID, travel_dir, caller)
	if(ismovableatom(caller))
		var/atom/movable/mover = caller
		if(mover.pass_flags & PASSGRILLE)
			return TRUE
	if(travel_dir == dir)
		return FALSE // just don't even try, not even if you can climb it
	return ..()

/obj/structure/flora/roguegrass/bush/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSGRILLE))
		return 1
	if(get_dir(loc, target) == dir)
		return 0
	return 1

/obj/structure/flora/roguegrass/bush/westleach
	name = "红叶灌木"
	desc = "粗大的红叶从中探出，散发着诱人的气味。"
	icon_state = "bush1"

/obj/structure/flora/roguegrass/bush/westleach/update_icon()
	return

/obj/structure/flora/roguegrass/bush/westleach/loot_replenish()
	. = ..()
	if(prob(50))
		looty += /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed

/obj/structure/flora/roguegrass/bush/westleach/Initialize(mapload)
	bushtype = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed
	return ..()

/obj/structure/flora/roguegrass/bush/wall
	name = "巨灌木"
	desc = "一丛灌木。这株的根系厚实得足以挡住去路。"
	opacity = TRUE
	density = TRUE
	climbable = FALSE
	icon_state = "bushwall1"
	max_integrity = 150
	debris = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1, /obj/item/natural/thorn = 1)
	attacked_sound = 'sound/misc/woodhit.ogg'

/obj/structure/flora/roguegrass/bush/wall/Initialize(mapload)
	. = ..()
	icon_state = "bushwall[pick(1,2)]"

/obj/structure/flora/roguegrass/bush/wall/update_icon()
	return

/obj/structure/flora/roguegrass/bush/wall/tall
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "tallbush1"
	opacity = 1
	pixel_x = -16
	debris = null
	static_debris = null

/obj/structure/flora/roguegrass/bush/wall/tall/Initialize(mapload)
	. = ..()
	icon_state = "tallbush[pick(1,2)]"


/obj/structure/flora/roguegrass/bush/winter
	icon_state = "bush1winter"
/obj/structure/flora/roguegrass/bush/winter/Initialize(mapload)
	. = ..()
	icon_state = "bush[pick(1,2,3,4)]winter"
/obj/structure/flora/roguegrass/bush/winter/wall
	icon_state = "bush5winter"
/obj/structure/flora/roguegrass/bush/wall/winter/Initialize(mapload)
	. = ..()
	icon_state = "bush[pick(5,6)]winter"

/obj/structure/flora/rogueshroom
	name = "蘑菇"
	desc = "蘑菇大概是这片土地上唯一真正快乐的东西。"
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "mush1"
	opacity = 0
	density = 0
	max_integrity = 120
	blade_dulling = DULLING_CUT
	pixel_x = -16
	layer = 4.81
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/treefall.ogg'
	static_debris = list( /obj/item/grown/log/tree/small = 1)
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	dir = SOUTH
	var/random_mush_zone = TRUE

/obj/structure/flora/rogueshroom/attack_right(mob/user)
	handle_special_items_retrieval(user, src)

/obj/structure/flora/rogueshroom/Initialize(mapload)
	. = ..()
	if(random_mush_zone)
		icon_state = "mush[rand(1,5)]"
	if(icon_state == "mush5")
		static_debris = list(/obj/item/natural/thorn=1, /obj/item/grown/log/tree/small = 1)
	pixel_x += rand(8,-8)
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/flora/rogueshroom/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSGRILLE))
		return 1
	if(get_dir(loc, target) == dir)
		return 0
	return 1

/obj/structure/flora/rogueshroom/CanAStarPass(ID, travel_dir, caller)
	if(ismovableatom(caller))
		var/atom/movable/mover = caller
		if(mover.pass_flags & PASSGRILLE)
			return TRUE
	if(travel_dir == dir)
		return FALSE // just don't even try, not even if you can climb it
	return ..()

/obj/structure/flora/rogueshroom/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(get_dir(leaving.loc, new_location) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/flora/rogueshroom/fire_act(added, maxstacks)
	if(added <= 5)
		return
	return ..()

/obj/structure/flora/rogueshroom/obj_destruction(damage_flag)
	new /obj/structure/flora/shroomstump(loc, initial(icon_state), icon)
	. = ..()

/obj/structure/flora/shroomstump
	name = "菇桩"
	desc = "它曾是一朵非常快乐的蘑菇。现在不是了。"
	icon_state = "mush1stump"
	opacity = 0
	max_integrity = 100
	climbable = TRUE
	climb_time = 0
	density = TRUE
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	plane = GAME_PLANE
	layer = TABLE_LAYER
	blade_dulling = DULLING_CUT
	static_debris = null
	debris = null
	alpha = 255
	pixel_x = -16
	climb_offset = 14
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/treefall.ogg'

/obj/structure/flora/shroomstump/Initialize(mapload)
	. = ..()
	icon_state = "t[rand(1,4)]stump"

/obj/structure/flora/shroomstump/obj_destruction(damage_flag)
	if(prob(50))
		new /obj/item/grown/log/tree/small(get_turf(src))
	else
		new /obj/item/grown/log/tree/stick(get_turf(src))
		new /obj/item/grown/log/tree/stick(get_turf(src))
	return ..()

/obj/structure/roguerock
	name = "岩石"
	desc = "一块从地面突起的石头。"
	icon_state = "rock1"
	icon = 'icons/roguetown/misc/foliage.dmi'
	opacity = 0
	max_integrity = 50
	climbable = TRUE
	climb_time = 30
	density = TRUE
	layer = TABLE_LAYER
	blade_dulling = DULLING_BASH
	static_debris = null
	debris = null
	alpha = 255
	climb_offset = 14
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 1)

/obj/structure/roguerock/Initialize(mapload)
	. = ..()
	icon_state = "rock[rand(1,4)]"

//Thorn bush

/obj/structure/flora/roguegrass/thorn_bush
	name = "荆棘丛"
	desc = "一丛带刺灌木。走路当心。"
	icon_state = "thornbush"
	layer = ABOVE_ALL_MOB_LAYER
	blade_dulling = DULLING_CUT
	max_integrity = 35
	climbable = FALSE
	dir = SOUTH
	debris = list(/obj/item/natural/thorn = 3, /obj/item/grown/log/tree/stick = 1)

/obj/structure/flora/roguegrass/thorn_bush/update_icon()
	icon_state = "thornbush"
//WIP

// fyrituis bush -- STONEKEEP PORT
/obj/structure/flora/roguegrass/pyroclasticflowers
	name = "奇异花丛"
	desc = "一簇极其易燃的危险花朵。"
	icon_state = "pyroflower1"
	layer = ABOVE_ALL_MOB_LAYER
	max_integrity = 1
	climbable = FALSE
	dir = SOUTH
	debris = list(/obj/item/natural/fibers = 1)
	max_integrity = 9999 // From base 1. So antag don't get to destroy it easily :).
	var/list/looty = list()
	var/bushtype
	var/res_replenish

/obj/structure/flora/roguegrass/pyroclasticflowers/update_icon()
	icon_state = "pyroflower[rand(1,3)]"

/obj/structure/flora/roguegrass/pyroclasticflowers/Initialize(mapload)
	. = ..()
	if(prob(88))
		bushtype = pickweight(list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1))
	loot_replenish2()
	pixel_x += rand(-3,3)

/obj/structure/flora/roguegrass/pyroclasticflowers/proc/loot_replenish2()
	if(bushtype)
		looty += bushtype
	if(prob(66))
		looty += /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius

// pyroflower cluster looting
/obj/structure/flora/roguegrass/pyroclasticflowers/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_INTENTCAP)
		playsound(src.loc, "plantcross", 80, FALSE, -1)
		if(do_after(L, SEARCHTIME, target = src))
			if(!looty.len && (world.time > res_replenish))
				loot_replenish2()
			if(prob(50) && looty.len)
				if(looty.len == 1)
					res_replenish = world.time + 8 MINUTES
				var/obj/item/B = pick_n_take(looty)
				if(B)
					B = new B(user.loc)
					user.put_in_hands(B)
					user.visible_message("<span class='notice'>[user]在[src]中找到了[B]。</span>")
					return
			user.visible_message("<span class='warning'>[user]在[src]里翻找着。</span>")
			if(!looty.len)
				to_chat(user, "<span class='warning'>已经被摘光了……我该晚些再来。</span>")

// swarmpweed bush -- STONEKEEP PORT
/obj/structure/flora/roguegrass/swampweed
	name = "一丛沼烟草"
	desc = "一种适合拿来抽的绿色根茎。"
	icon_state = "swampweed1"
	layer = ABOVE_ALL_MOB_LAYER
	max_integrity = 1
	climbable = FALSE
	dir = SOUTH
	debris = list(/obj/item/natural/fibers = 1)
	var/list/looty = list()
	var/bushtype
	var/res_replenish

/obj/structure/flora/roguegrass/swampweed/Initialize(mapload)
	. = ..()
	icon_state = "swampweed[rand(1,3)]"
	if(prob(88))
		bushtype = pickweight(list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 1))
	loot_replenish3()
	pixel_x += rand(-3,3)

/obj/structure/flora/roguegrass/swampweed/proc/loot_replenish3()
	if(bushtype)
		looty += bushtype
	if(prob(66))
		looty += /obj/item/reagent_containers/food/snacks/grown/rogue/swampweed

/obj/structure/flora/roguegrass/swampweed/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_INTENTCAP)
		playsound(src.loc, "plantcross", 80, FALSE, -1)
		if(do_after(L, SEARCHTIME, target = src))
			if(!looty.len && (world.time > res_replenish))
				loot_replenish3()
			if(prob(50) && looty.len)
				if(looty.len == 1)
					res_replenish = world.time + 8 MINUTES
				var/obj/item/B = pick_n_take(looty)
				if(B)
					B = new B(user.loc)
					user.put_in_hands(B)
					if(HAS_TRAIT(user, TRAIT_WOODWALKER))
						var/obj/item/C = new B.type(user.loc)
						user.put_in_hands(C)
					user.visible_message("<span class='notice'>[user]在[src]中找到了[HAS_TRAIT(user, TRAIT_WOODWALKER) ? "两份" : ""][B]。</span>")
					return
			user.visible_message("<span class='warning'>[user]在[src]里翻找着。</span>")
			if(!looty.len)
				to_chat(user, "<span class='warning'>已经被摘光了……我该晚些再来。</span>")

/obj/structure/flora/roguegrass/pumpkin
	name = "野南瓜丛"
	desc = "被藤蔓疯长缠绕着的野生南瓜。"
	icon_state = "pumpkin1"
	max_integrity = 1
	climbable = FALSE
	dir = SOUTH
	debris = list(/obj/item/natural/fibers = 2)
	var/list/looty = list(/obj/item/natural/shellplant/pumpkin, /obj/item/natural/fibers)

/obj/structure/flora/roguegrass/pumpkin/Initialize(mapload)
	. = ..()
	icon_state = "pumpkin[rand(1,2)]"
	if(prob(78))
		looty += /obj/item/natural/shellplant/pumpkin
	if(prob(32))
		looty += /obj/item/natural/shellplant/pumpkin
	if(prob(24))
		looty += /obj/item/natural/fibers
	if(prob(7))
		looty += /obj/item/natural/shellplant/pumpkin
	pixel_x += rand(-3,3)
	pixel_y += rand(0,6)

/obj/structure/flora/roguegrass/pumpkin/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_INTENTCAP)
		playsound(src.loc, "plantcross", 80, FALSE, -1)
		if(do_after(L, SEARCHTIME, target = src))
			if(looty.len && prob(75))
				var/obj/item/B = pick_n_take(looty)
				if(B)
					B = new B(user.loc)
					user.put_in_hands(B)
					user.visible_message("<span class='notice'>[user]在[src]中找到了[B]。</span>")
					if(!looty.len)
						to_chat(user, "<span class='warning'>已经没有别的可找了。</span>")
						qdel(src)
					return
			user.visible_message("<span class='warning'>[user]在[src]里翻找着。</span>")

// cute underdark mushrooms from dreamkeep

/obj/structure/flora/rogueshroom/unhappy
	name = "尸腐菌"
	icon_state = "scarymush"
	icon = 'icons/roguetown/misc/foliagemushroom48x64.dmi'
	desc = "这朵蘑菇看上去像是活着、甚至会思考，让你也不由得多想了几分。"
	random_mush_zone = FALSE
	max_integrity = 240
	pixel_x = -8
	var/mush_light_range = 3
	var/mush_light_power = 3
	var/mush_light_color = "#850707"
	var/int_req = 14
	var/trait_required = TRAIT_WOODSMAN
	var/special_examine = "仔细看去，它菌盖搏动的节律竟与人类心跳一致。你想起这种东西会长在尸体上，模仿那具尸体生前独有的节拍。"
	var/list/abyssal_screams = list(
		'modular_azurepeak/sound/mobs/abyssal/abyssal_attack.ogg',
		'modular_azurepeak/sound/mobs/abyssal/abyssal_attack2.ogg',
		'modular_azurepeak/sound/mobs/abyssal/abyssal_aggro.ogg',
		'modular_azurepeak/sound/mobs/abyssal/abyssal_pain.ogg',
		'modular_azurepeak/sound/mobs/abyssal/abyssal_teleport.ogg',
		'modular_azurepeak/sound/mobs/abyssal/murderbeast.ogg'
	)
	static_debris = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 1)
	var/rare_mush_bonus_drop = /obj/item/reagent_containers/powder/ozium
	var/mush_animate = TRUE
	var/mush_scream = TRUE

/obj/structure/flora/rogueshroom/unhappy/Initialize(mapload)
	. = ..()
	if(mush_animate)
		animate(src, icon_state = "[icon_state]animated", delay = rand(1, 100), loop = -1, time = 10)

/obj/structure/flora/rogueshroom/unhappy/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir)
	. = ..()
	if(damage_amount > 0 && mush_scream)
		playsound(src, pick(abyssal_screams), 50, FALSE)

/obj/structure/flora/rogueshroom/unhappy/obj_destruction(damage_flag)
	playsound(src, pick(abyssal_screams), 60, FALSE)
	if(prob(7) && rare_mush_bonus_drop)
		new rare_mush_bonus_drop(loc)
	. = ..()

/obj/structure/flora/rogueshroom/unhappy/examine(mob/user)
	. = ..()

	var/can_special = FALSE
	if(user?.client?.holder || istype(user, /mob/dead/observer/admin))
		can_special = TRUE

	else if(HAS_TRAIT(user, TRAIT_WOODSMAN))
		can_special = TRUE
	else if(istype(user, /mob/living))
		if(int_req && hasvar(user, "STAINT") && user:STAINT >= int_req)
			can_special = TRUE

	if(can_special)
		. += span_infection("\n[special_examine]")

/obj/structure/flora/rogueshroom/unhappy/white
	name = "骨髓盖菇"
	icon_state = "scarymush1"
	desc = "你发誓这些蘑菇以前没这么邪门，简直像是 Baotha 亲手掀开了某层遮蔽。"
	mush_light_range = 4
	mush_light_power = 2
	mush_light_color = "#e2e2e2"
	int_req = 0
	special_examine = "你想起了最近那场荒野大师的集会。明明没过去多久，可人们一直都以为这些蘑菇应当是快乐而色彩鲜艳的。据说罪魁祸首就是这朵菇的孢子，就好像……它们集体决定不再继续愚弄人类了一样。"
	static_debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/small = 1)
	rare_mush_bonus_drop = /mob/living/simple_animal/hostile/rogue/mirespider_lurker/mushroom
	mush_animate = FALSE

/obj/structure/flora/rogueshroom/unhappy/fat
	name = "溃疡菌凳"
	icon_state = "scarymush2"
	desc = "一朵苍白的蘑菇，表面布满渗液的疮口。你莫名觉得自己正被什么盯着。"
	mush_light_range = 0
	mush_light_power = 0
	mush_light_color = null
	int_req = 20
	max_integrity = 480
	special_examine = "在学者眼中，这种蘑菇仿佛每一处疮口里都长着一只眼睛。然而一旦解剖开来，那些眼睛却又像早已融化消失了一样。"
	static_debris = list(/obj/item/grown/log/tree = 1)
	rare_mush_bonus_drop = /obj/item/rogueore/iron
	mush_animate = TRUE

/obj/structure/flora/rogueshroom/unhappy/angel
	name = "悲泣天使菇"
	icon_state = "angelmush"
	desc = "人们相信，这种蘑菇上的每一朵都源自久远年代里天使落下的泪滴。"
	mush_light_range = 3
	mush_light_power = 3
	mush_light_color = "#e2e2e2"
	int_req = 10
	special_examine = "这种蘑菇与一种极度凶残的“哭泣天使菇”外形完全相同，不过幸运的是，后者并非这片土地上的原生物种。"
	static_debris = null
	mush_animate = FALSE

/obj/structure/flora/rogueshroom/unhappy/random

/obj/structure/flora/rogueshroom/unhappy/random/Initialize(mapload)
	. = ..()
	var/list/mushroom_types = list(
		/obj/structure/flora/rogueshroom/unhappy       = 249,
		/obj/structure/flora/rogueshroom/unhappy/white = 249,
		/obj/structure/flora/rogueshroom/unhappy/fat   = 249,
		/obj/structure/flora/rogueshroom/unhappy/angel = 249,
		/obj/structure/flora/rogueshroom/unhappy/metal = 1,
	)
	var/mushroom_type = pickweight(mushroom_types)
	new mushroom_type(loc)
	qdel(src)

/obj/structure/flora/rogueshroom/unhappy/New(loc)
	..()
	if(mush_light_power > 0)
		set_light(mush_light_range, mush_light_range, mush_light_power, l_color = mush_light_color)

/obj/structure/flora/rogueshroom/happy
	name = "幽暗蘑菇"
	icon_state = "happymush1"
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	desc = "蘑菇大概是这片受诅之地里少数还算快乐的生灵。"

/obj/structure/flora/rogueshroom/happy/mushroom2
	icon_state = "happymush2"

/obj/structure/flora/rogueshroom/happy/mushroom3
	icon_state = "happymush3"

/obj/structure/flora/rogueshroom/happy/mushroom4
	icon_state = "happymush4"

/obj/structure/flora/rogueshroom/happy/mushroom5
	icon_state = "happymush5"

/obj/structure/flora/rogueshroom/happy/random

/obj/structure/flora/rogueshroom/happy/random/Initialize(mapload)
	. = ..()
	icon_state = "happymush[rand(1,5)]"

/obj/structure/flora/rogueshroom/happy/New(loc)
	..()
	set_light(3, 3, 3, l_color ="#5D3FD3")

/obj/structure/flora/rogueshroom/unhappy/metal
	name = "金属蘑菇"
	icon_state = "metal"
	icon = 'icons/roguetown/misc/foliagemushroom60x64.dmi'
	desc = "一朵难以理解的金属蘑菇，表面泛着奇异光泽。它近乎坚不可摧，但只要够执拗，什么都能被放倒。"
	max_integrity = 3250
	pixel_x = -14
	blade_dulling = DULLING_PICK
	special_examine = "嗯，真古怪。"
	mush_light_range = 0
	mush_light_power = 0
	mush_light_color = null
	int_req = 20
	mush_animate = FALSE
	static_debris = list(/obj/item/rogueore/iron = 8)
	mush_scream = FALSE

/obj/structure/flora/mushroomcluster
	name = "蘑菇簇"
	desc = "一大簇泛着奇异微光的蘑菇。"
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "mushroomcluster"
	density = TRUE
	max_integrity = 60

/obj/structure/flora/mushroomcluster/unhappy
	desc = "一簇原生于幽暗地底的蘑菇。"
	icon_state = "mushroomclusterunhappy"

/obj/structure/flora/mushroomcluster/New(loc)
	..()
	set_light(1.5, 1.5, 1.5, l_color ="#5D3FD3")

/obj/structure/flora/tinymushrooms
	name = "小蘑菇圈"
	desc = "一簇细小蘑菇，正长成某种可疑的环状。"
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "tinymushrooms"
	max_integrity = 30

/obj/structure/flora/tinymushrooms/unhappy
	icon_state = "tinymushrooms"
	desc = "一簇原生于幽暗地底的小蘑菇。"
	icon_state = "tinymushroomsunhappy"

/obj/structure/flora/roguetree/pine
	name = "松树"
	icon_state = "pine1"
	desc = ""
	icon = 'icons/obj/flora/pines.dmi'
	pixel_w = -24
	density = 0
	static_debris = list(/obj/item/grown/log/tree = 2)
	stump_type = null

/obj/structure/flora/roguetree/pine/Initialize(mapload)
	. = ..()
	icon_state = "pine[rand(1, 4)]"

/obj/structure/flora/roguetree/pine/burn()
	new /obj/structure/flora/roguetree/pine/dead(get_turf(src))
	qdel(src)

/obj/structure/flora/roguetree/pine/dead
	name = "枯死松树"
	icon_state = "dead1"
	max_integrity = 50
	static_debris = list(/obj/item/rogueore/coal/charcoal = 1)
	resistance_flags = FIRE_PROOF
	stump_type = /obj/structure/flora/roguetree/stump/pine

/obj/structure/flora/roguetree/pine/dead/Initialize(mapload)
	. = ..()
	icon_state = "dead[rand(1, 3)]"

/obj/structure/flora/roguetree/pine/dead/reinvigorate_tree(mob/user)
	var/turf/tree_turf = get_turf(src)
	new /obj/structure/flora/roguetree/pine(tree_turf)
	qdel(src)
	if(isliving(user) && user.mind)
		user.mind.add_sleep_experience(/datum/skill/magic/druidic, 20)
	return TRUE

//A smattering of jungle-themed assets. The default artstyle of SS13 is far too bright so they all have a color to darken them down to more of a roguetown pallette
//trees

#define COLOR_JUNGLE			"#9bb6ae"

/obj/structure/flora/roguetree/jungle//version with mechanics this time
	name = "丛林树"
	color = COLOR_JUNGLE
	// desc = "Scant, precious shade."
	stump_type = /obj/structure/flora/roguetree/stump/palm
	icon = 'icons/obj/flora/jungletrees.dmi'
	icon_state = "tree"
	pixel_x = -48
	pixel_y = -20
	max_integrity = 300
	debris = list(/obj/item/grown/log/tree/stick = 2)
	static_debris = list(/obj/item/grown/log/tree = 3)

/obj/structure/flora/roguetree/jungle/Initialize(mapload)
	. = ..()
	icon_state = "tree[rand(1, 6)]"

/obj/structure/flora/roguetree/jungle/small
	pixel_y = 0
	pixel_x = -32
	icon = 'icons/obj/flora/jungletreesmall.dmi'
	max_integrity = 200
	debris = list(/obj/item/grown/log/tree/stick = 2)
	static_debris = list(/obj/item/grown/log/tree = 2)

/obj/structure/flora/roguetree/jungle/small/Initialize(mapload)
	. = ..()
	icon_state = "tree[rand(1, 6)]"

//bushes

/obj/structure/flora/roguegrass/bush/jungle
	name = "丛林灌木"
	desc = ""
	color = COLOR_JUNGLE
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "bushb"

/obj/structure/flora/roguegrass/bush/jungle/Initialize(mapload)
	. = ..()
	if(prob(30))
		icon_state = "busha[rand(1, 3)]"
	else if(prob(50))
		icon_state = "bushb[rand(1, 3)]"
	else
		icon_state = "bushc[rand(1, 3)]"

/obj/structure/flora/roguegrass/herb/random
	name = "随机药草"
	desc = "哈，我有麻烦了。"

/obj/structure/flora/roguegrass/bush/jungle/large
	color = COLOR_JUNGLE
	icon = 'icons/obj/flora/largejungleflora.dmi'
	icon_state = "bush"
	pixel_x = -16
	pixel_y = -12
	layer = ABOVE_ALL_MOB_LAYER
	opacity = TRUE
	attacked_sound = 'sound/misc/woodhit.ogg'
	max_integrity = 100
	debris = list(/obj/item/natural/fibers = 2, /obj/item/grown/log/tree/stick = 1, /obj/item/grown/log/tree/small = 1)
	static_debris = list(/obj/item/grown/log/tree/small = 1)

/obj/structure/flora/roguegrass/bush/jungle/large/Initialize(mapload)
	. = ..()
	icon_state = "bush[pick(1,2,3)]"

//Jungle grass

/obj/structure/flora/roguegrass/jungle
	name = "丛林草"
	desc = ""
	color = COLOR_JUNGLE
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "grassa"

/obj/structure/flora/roguegrass/jungle/Initialize(mapload)
	. = ..()
	icon_state = "grassa[rand(1, 5)]"

/obj/structure/flora/roguegrass/jungle/sparse
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "grassb"

/obj/structure/flora/roguegrass/jungle/sparse/Initialize(mapload)
	. = ..()
	icon_state = "grassb[rand(1, 5)]"
