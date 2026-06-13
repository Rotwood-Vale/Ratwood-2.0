/turf/open/floor/rogue
	desc = ""
	canSmoothWith = null
	smooth = SMOOTH_FALSE
	var/smooth_icon = null
	var/prettifyturf = FALSE
	icon = 'icons/turf/roguefloor.dmi'
	baseturfs = list(/turf/open/transparent/openspace)
	neighborlay = ""

/turf/open/floor/rogue/break_tile()
	return //unbreakable

/turf/open/floor/rogue/burn_tile()
	return //unburnable

/turf/open/floor/rogue/Initialize(mapload)
	if(smooth_icon)
		icon = smooth_icon
	. = ..()

/turf/open/floor/rogue/ruinedwood
	icon_state = "wooden_floor"
	name = "木地板"
	desc = "互相咬合的木地板上布满了万千脚步留下的划痕。"
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/woodland.wav'
//	smooth = SMOOTH_MORE
//	canSmoothWith = list(/turf/closed/mineral/rogue, /turf/closed/mineral, /turf/closed/wall/mineral/rogue/stonebrick, /turf/closed/wall/mineral/rogue/wood, /turf/closed/wall/mineral/rogue/wooddark, /turf/closed/wall/mineral/rogue/decowood, /turf/closed/wall/mineral/rogue/decostone, /turf/closed/wall/mineral/rogue/stone, /turf/closed/wall/mineral/rogue/stone/moss, /turf/open/floor/rogue/cobble, /turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grass)
	neighborlay = "dirtedge"

/turf/open/floor/rogue/ruinedwood/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/ruinedwood/turned
	icon_state = "wooden_floort"
	name = "木地板"
	desc = "互相咬合的木地板上布满了万千脚步留下的划痕。"

/turf/open/floor/rogue/ruinedwood/spiral
	icon_state = "weird1"
	name = "木地板"
	desc = "互相咬合的木地板。"
/turf/open/floor/rogue/ruinedwood/chevron
	icon_state = "weird2"
	name = "木地板"
	desc = "互相咬合的木地板。"

/turf/open/floor/rogue/ruinedwood/platform
	name = "平台"
	desc = "一处可被摧毁的平台。"
	damage_deflection = 8
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/turf/open/floor/rogue/ruinedwood/platform/turf_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/rogue/hay
	icon_state = "hay"
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0

/turf/open/floor/rogue/twig
	name = "树枝地板"
	desc = "一捆捆树枝被平铺在地面上，稍一承重便吱嘎作响、噼啪开裂。"
	icon_state = "twig"
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0

/turf/open/floor/rogue/twig/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/twig/platform
	name = "树枝平台"
	desc = "一处可被摧毁的平台。"
	damage_deflection = 4
	max_integrity = 100		//It's fucking twig.
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/turf/open/floor/rogue/twig/platform/turf_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/rogue/wood
	smooth_icon = 'icons/turf/floors/wood.dmi'
	icon_state = "wooden_floor2"
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	smooth = SMOOTH_MORE
	landsound = 'sound/foley/jumpland/woodland.wav'
	canSmoothWith = list(/turf/open/floor/rogue/wood,/turf/open/floor/carpet)

/turf/open/floor/rogue/wood/nosmooth //these are here so we can put wood floors next to each other but not have them smooth
	name = "木地板"
	desc = "抛光的木地板上满是刮痕，还积着一层挥之不去的污垢。"
	icon_state = "wooden_floor"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue/wood/nosmooth,/turf/open/floor/carpet)

/turf/open/floor/rogue/woodturned
	smooth_icon = 'icons/turf/floors/wood_turned.dmi'
	icon_state = "wooden_floor2t"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue/woodturned,/turf/open/floor/carpet)
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/rogue/woodturned/nosmooth
	name = "木地板"
	desc = "抛光的木地板上满是刮痕，还积着一层挥之不去的污垢。"
	icon_state = "wooden_floort"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue/woodturned/nosmooth,/turf/open/floor/carpet)

/turf/open/floor/rogue/rooftop
	name = "屋顶"
	desc = "层层叠叠的木瓦为建筑与其中的住户遮挡风雨。"
	icon_state = "roof-arw"
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE

/turf/open/floor/rogue/rooftop/north
	dir = 1

/turf/open/floor/rogue/rooftop/east
	dir = 4

/turf/open/floor/rogue/rooftop/west
	dir = 8


/turf/open/floor/rogue/rooftop/Initialize(mapload)
	. = ..()
	icon_state = "roof"

/turf/open/floor/rogue/rooftop/green
	icon_state = "roofg-arw"

/turf/open/floor/rogue/rooftop/green/Initialize(mapload)
	. = ..()
	icon_state = "roofg"

/turf/open/floor/rogue/rooftop/green/north
	dir = 1

/turf/open/floor/rogue/rooftop/green/east
	dir = 4

/turf/open/floor/rogue/rooftop/green/west
	dir = 8

/turf/open/floor/rogue/rooftop/green/corner1
	icon_state = "roofgc1-arw"

/turf/open/floor/rogue/rooftop/green/corner1/Initialize(mapload)
	. = ..()
	icon_state = "roofgc1"

/turf/open/floor/rogue/rooftop/green/corner1/dirone
	dir = 1

/turf/open/floor/rogue/rooftop/green/corner1/dirfour
	dir = 4


/turf/open/floor/rogue/rooftop/green/corner1/direight
	dir = 8


/turf/open/floor/rogue/rooftop/green/corner1/dirfive
	dir = 5

/turf/open/floor/rogue/rooftop/green/corner1/dirnine
	dir = 9

/turf/open/floor/rogue/rooftop/green/corner1/dirsix
	dir = 6


/turf/open/floor/rogue/rooftop/green/corner1/dirten
	dir = 10


/turf/open/floor/rogue/AzureSand
	name = "沙地"
	desc = "温热的沙子，只可惜已经和泥土混在了一起。"
	icon_state = "grimshart"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/AzureSand,)
	neighborlay = "grimshartedge"

/turf/open/floor/rogue/AzureSand/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/AzureSand/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/snow
	name = "雪地"
	desc = "一层轻柔覆盖的大雪。"
	icon_state = "snow"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/snow,)
	neighborlay = "snowedge"
	spread_chance = 0
	temperature = 110
/turf/open/floor/rogue/snow/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/snow/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/snow/attack_right(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		var/obj/item/I = new /obj/item/natural/dirtclod/snow(src)
		if(L.put_in_active_hand(I))
			L.visible_message(span_warning("[L] 捧起了一些雪。"))
			ChangeTurf(/turf/open/floor/rogue/snowpatchy, flags = CHANGETURF_INHERIT_AIR)
		else
			qdel(I)

	. = ..()

/turf/open/floor/rogue/snow/attackby(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/natural/dirtclod/snow))
		for(var/elements in contents)
			if(!istype(elements, /obj/effect/decal/cleanable/blood/footprints/mud))
				continue
			QDEL_NULL(elements)
			to_chat(user, span_notice("我把 [src] 上的脚印都填平了。"))
			qdel(C)

	. = ..()

/turf/open/floor/rogue/snow/Crossed(atom/movable/O)
	..()
	if(!ishuman(O))
		return
	var/mob/living/carbon/human/H = O
	if(HAS_TRAIT(H, TRAIT_LIGHT_STEP))
		return
	update_icon()
	if(water_level)
		START_PROCESSING(SSwaterlevel, src)

/turf/open/floor/rogue/snowrough
	name = "粗雪地"
	desc = "一层粗粝不平的积雪。"
	icon_state = "snowrough"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/snowrough,)
	neighborlay = "snowroughedge"
	spread_chance = 0
	temperature = 110

/turf/open/floor/rogue/snowrough/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/snowrough/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/snowpatchy
	name = "斑驳雪地"
	desc = "半融的积雪下露出了顽强生长的草地。"
	icon_state = "snowpatchy_grass"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	neighborlay = "snowpatchy_grassedge"
	temperature = 110

/turf/open/floor/rogue/snowpatchy/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/grasscold
	name = "冻原草地"
	desc = "被寒冬侵染、冰冷刺骨的草地。"
	icon_state = "grass_cold"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	neighborlay = "grass_coldedge"
	temperature = 160
	var/obj/structure/closet/dirthole/holie
	var/dirt_amt = 3

/turf/open/floor/rogue/grasscold/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/grasscold/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/grasspurple
	name = "菌丝草地"
	desc = "细长的菌丝自地面长出，踩上去软绵绵的。"
	icon_state = "grass_purple"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	neighborlay = "grass_purpleedge"
	var/obj/structure/closet/dirthole/holie
	var/dirt_amt = 3

/turf/open/floor/rogue/grasspurple/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/grasspurple/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/grassgrey
	name = "枯草地"
	desc = "苍白得像一具肿胀的尸体。"
	icon_state = "grass_grey"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	neighborlay = "grass_greyedge"
	var/obj/structure/closet/dirthole/holie
	var/dirt_amt = 3

/turf/open/floor/rogue/grassgrey/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/grassgrey/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/grassred
	name = "红草地"
	desc = "浸润着登多尔之血的草地。"
	icon_state = "grass_red"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	neighborlay = "grass_rededge"
	var/obj/structure/closet/dirthole/holie
	var/dirt_amt = 3

/turf/open/floor/rogue/grassred/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/grassred/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/grassyel
	name = "黄草地"
	desc = "受到 Astrata 之光祝福的草地。"
	icon_state = "grass_yel"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	neighborlay = "grass_yeledge"
	var/obj/structure/closet/dirthole/holie
	var/dirt_amt = 3

/turf/open/floor/rogue/grassyel/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/grassyel/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/grass
	name = "草地"
	desc = "浸透了泥浆和沼泽水的草地。"
	icon_state = "grass"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/dirt/road,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/grassgrey,
						/turf/open/floor/rogue/grasspurple,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	neighborlay = "grassedge"
	spread_chance = 15
	burn_power = 6
	var/obj/structure/closet/dirthole/holie
	var/dirt_amt = 3

/turf/open/floor/rogue/grass/Initialize(mapload)
	dir = pick(GLOB.cardinals)
//	GLOB.dirt_list += src
	. = ..()

/turf/open/floor/rogue/grass/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/dirt/ambush
	name = "泥土"
	desc = "泥土上布满了无数战争留下的疮痍。"
	icon_state = "dirt"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	slowdown = 2
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/grassgrey,
						/turf/open/floor/rogue/grasspurple,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/AzureSand)
	neighborlay = "dirtedge"
	muddy = FALSE
	bloodiness = 20
	dirt_amt = 3
	spread_chance = 8

/turf/open/floor/rogue/dirt
	name = "泥土"
	desc = "泥土上布满了无数战争留下的疮痍。"
	icon_state = "dirt"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	slowdown = 2
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/dunes,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/grassgrey,
						/turf/open/floor/rogue/grasspurple,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/AzureSand)
	neighborlay = "dirtedge"
	var/muddy = FALSE
	var/bloodiness = 20
	var/obj/structure/closet/dirthole/holie
	var/dirt_amt = 3

/turf/open/floor/rogue/dirt/get_slowdown(mob/user)
	. = ..()
	var/negate_slowdown = FALSE

	for(var/obj/item/stick in user.held_items)
		if(stick.walking_stick && !stick.wielded && !user.cmode)
			negate_slowdown = TRUE
			break

	if(HAS_TRAIT(user, TRAIT_LONGSTRIDER))
		negate_slowdown = TRUE

	if(negate_slowdown)
		. -= 2
	return max(., 0)


/turf/open/floor/rogue/dirt/attack_right(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		var/obj/item/I = new /obj/item/natural/dirtclod(src)
		if(L.put_in_active_hand(I))
			L.visible_message(span_warning("[L] picks up some dirt."))
			dirt_amt--
			if(dirt_amt <= 0)
				src.ChangeTurf(/turf/open/floor/rogue/dirt/road, flags = CHANGETURF_INHERIT_AIR)
		else
			qdel(I)
	.=..()

/turf/open/floor/rogue/dirt/MiddleClick(mob/user, params)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	if(L.stat != CONSCIOUS)
		return

	var/obj/item/rogueweapon/shovel/S = L.get_active_held_item()
	if(!istype(S))
		S = L.get_inactive_held_item()
	if(!istype(S))
		for(var/obj/item/rogueweapon/shovel/shovel in L.held_items)
			S = shovel
			break
	if(!istype(S))
		return

	if(S.start_autodig(L, src))
		return TRUE

	return FALSE

/turf/open/floor/rogue/dirt/Destroy()
	if(holie)
		QDEL_NULL(holie)
	return ..()


/turf/open/floor/rogue/dirt/Crossed(atom/movable/O)
	..()
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		if(H.shoes && !HAS_TRAIT(H, TRAIT_LIGHT_STEP))
			var/obj/item/clothing/shoes/S = H.shoes
			if(!istype(S) || !S.can_be_bloody)
				return
			var/add_blood = 0
			if(bloodiness >= BLOOD_GAIN_PER_STEP)
				add_blood = BLOOD_GAIN_PER_STEP
			else
				add_blood = bloodiness
			S.bloody_shoes[BLOOD_STATE_MUD] = min(MAX_SHOE_BLOODINESS,S.bloody_shoes[BLOOD_STATE_MUD]+add_blood)
			S.blood_state = BLOOD_STATE_MUD
			update_icon()
			H.update_inv_shoes()
		if(water_level)
			START_PROCESSING(SSwaterlevel, src)

/turf/open/floor/rogue/dirt/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/dirt/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()
	update_water()

/turf/open/floor/rogue/dirt/update_water()
	water_level = max(water_level-10,0)
	if(water_level > 10) //this would be a switch on normal tiles
		color = "#95776a"
	else
		color = null
	return TRUE

/turf/open/floor/rogue/dirt/road/update_water()
	water_level = max(water_level-10,0)
	for(var/D in GLOB.cardinals)
		var/turf/TU = get_step(src, D)
		if(istype(TU, /turf/open/water))
			if(!muddy)
				become_muddy()
			return TRUE //stop processing
	if(water_level > 10) //this would be a switch on normal tiles
		if(!muddy)
			become_muddy()
//flood process goes here to spread to other turfs etc
//	if(water_level > 250)
//		return FALSE
	if(muddy)
		if(water_level <= 0)
			water_level = 0
			muddy = FALSE
			slowdown = initial(slowdown)
			icon_state = initial(icon_state)
			name = initial(name)
			footstep = initial(footstep)
			barefootstep = initial(barefootstep)
			clawfootstep = initial(clawfootstep)
			heavyfootstep = initial(heavyfootstep)
			track_prob = initial(track_prob) //Hearthstone port.
	return TRUE

/turf/open/floor/rogue/dirt/proc/become_muddy()
	if(!muddy)
		water_level = max(water_level-100,0)
		muddy = TRUE
		icon_state = "mud[rand (1,3)]"
		name = "泥地"
		slowdown = 2
		footstep = FOOTSTEP_MUD
		barefootstep = FOOTSTEP_MUD
		heavyfootstep = FOOTSTEP_MUD
		track_prob = 20 //Hearthstone port.
		bloodiness = 20

/turf/open/floor/rogue/dirt/road
	name = "土路"
	desc = "泥土上布满了无数脚步踩踏的痕迹。"
	icon_state = "road"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/AzureSand,)
	neighborlay = "roadedge"
	slowdown = 0

/turf/open/floor/rogue/dirt/road/attack_right(mob/user)
	return

/turf/open/floor/rogue/dirt/road/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/dirt/nospawn

/turf/open/floor/rogue/grass/nospawn

/turf/open/floor/rogue/sand
	name = "沙地"
	desc = "细密的沙粒在脚下悄然流动，发出轻微的沙沙声。"
	icon = 'icons/turf/sand.dmi'
	icon_state = "sand"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	baseturfs = /turf/open/floor/rogue/sand
	slowdown = 0
	var/sand_amt = 3

/turf/open/floor/rogue/sand/Initialize(mapload)
	. = ..()
	if(prob(15))
		icon_state = "sand[rand(1,4)]"

/turf/open/floor/rogue/sand/attack_right(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(sand_amt <= 0)
			to_chat(L, span_warning("这里已经没有松散的沙子可铲了。"))
			return
		var/obj/item/I = new /obj/item/natural/dirtclod/sand(src)
		if(L.put_in_active_hand(I))
			L.visible_message(span_warning("[L] 铲起了一些沙子。"))
			sand_amt--
		else
			qdel(I)
	. = ..()

/turf/open/floor/rogue/sand/MiddleClick(mob/user, params)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	if(L.stat != CONSCIOUS)
		return

	var/obj/item/rogueweapon/shovel/S = L.get_active_held_item()
	if(!istype(S))
		S = L.get_inactive_held_item()
	if(!istype(S))
		for(var/obj/item/rogueweapon/shovel/shovel in L.held_items)
			S = shovel
			break
	if(!istype(S))
		return

	if(S.start_autodig(L, src))
		return TRUE

	return FALSE

/turf/open/floor/rogue/AzureSand/attack_right(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		var/obj/item/I = new /obj/item/natural/dirtclod/sand(src)
		if(L.put_in_active_hand(I))
			L.visible_message(span_warning("[L] 铲起了一些沙子。"))
		else
			qdel(I)
	. = ..()

/turf/open/floor/rogue/AzureSand/MiddleClick(mob/user, params)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	if(L.stat != CONSCIOUS)
		return

	var/obj/item/rogueweapon/shovel/S = L.get_active_held_item()
	if(!istype(S))
		S = L.get_inactive_held_item()
	if(!istype(S))
		for(var/obj/item/rogueweapon/shovel/shovel in L.held_items)
			S = shovel
			break
	if(!istype(S))
		return

	if(S.start_autodig(L, src))
		return TRUE

	return FALSE

/turf/open/floor/rogue/hay
	name = "干草地"
	desc = "地上散落着干草。睡在这上面也不算最糟。"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "hay"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/dirtland.wav'
	slowdown = 0

/turf/proc/roguesmooth(adjacencies)
	var/list/New
	var/holder

	for(var/A in neighborlay_list)
		cut_overlay("[A]")
		neighborlay_list -= A
	var/usedturf
	if(adjacencies & N_NORTH)
		usedturf = get_step(src, NORTH)
		if(isturf(usedturf))
			var/turf/T = usedturf
			if(neighborlay_override)
				holder = "[neighborlay_override]-n"
				LAZYADD(New, holder)
				neighborlay_list += holder
			else if(T.neighborlay)
				holder = "[T.neighborlay]-n"
				LAZYADD(New, holder)
				neighborlay_list += holder
	if(adjacencies & N_SOUTH)
		usedturf = get_step(src, SOUTH)
		if(isturf(usedturf))
			var/turf/T = usedturf
			if(neighborlay_override)
				holder = "[neighborlay_override]-s"
				LAZYADD(New, holder)
				neighborlay_list += holder
			else if(T.neighborlay)
				holder = "[T.neighborlay]-s"
				LAZYADD(New, holder)
				neighborlay_list += holder
	if(adjacencies & N_WEST)
		usedturf = get_step(src, WEST)
		if(isturf(usedturf))
			var/turf/T = usedturf
			if(neighborlay_override)
				holder = "[neighborlay_override]-w"
				LAZYADD(New, holder)
				neighborlay_list += holder
			else if(T.neighborlay)
				holder = "[T.neighborlay]-w"
				LAZYADD(New, holder)
				neighborlay_list += holder
	if(adjacencies & N_EAST)
		usedturf = get_step(src, EAST)
		if(isturf(usedturf))
			var/turf/T = usedturf
			if(neighborlay_override)
				holder = "[neighborlay_override]-e"
				LAZYADD(New, holder)
				neighborlay_list += holder
			else if(T.neighborlay)
				holder = "[T.neighborlay]-e"
				LAZYADD(New, holder)
				neighborlay_list += holder

	if(New)
		add_overlay(New)
	return New

/turf/open/floor/rogue/underworld/space
	name = "虚空"
	desc = ""
	icon_state = "undervoid"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/dark_ice)
	slowdown = 50

/turf/open/floor/rogue/underworld/space/sparkle_quiet
	name = "虚空"
	desc = ""
	icon_state = "undervoid2"

/turf/open/floor/rogue/underworld/space/quiet
	name = "虚空"
	desc = ""
	icon_state = "undervoid3"

/turf/open/floor/rogue/underworld/road
	name = "灰烬地"
	desc = "闻起来像烧焦的木头。"
	icon_state = "ash"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue, /turf/closed/mineral, /turf/closed/wall/mineral)
	slowdown = 0

/turf/open/floor/rogue/underworld/road/Initialize(mapload)
	. = ..()
	dir = rand(0,8)

/turf/open/floor/rogue/volcanic
	name = "凝固熔岩"
	desc = "它曾怀着地狱般的恶意焚尽所触的一切。如今只剩下坚硬的黑壳，在脚下发出碎裂声。"
	icon_state = "lavafloor"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/dirt/road,/turf/open/floor/rogue/dirt)
	neighborlay = "lavedge"
	temperature = 500

/turf/open/floor/rogue/volcanic/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()


/turf/open/floor/rogue/blocks
	icon_state = "blocks"
	name = "石板地面"
	desc = "这些粗糙的石板被整齐地排列成网格，兼具质朴与整洁的魅力。"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/cobblerock,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/cobble/mossy,)

/turf/open/floor/rogue/blocks/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/blocks/flipped
	dir = 8

/turf/open/floor/rogue/blocks/stonered
	icon_state = "stoneredlarge"
	name = "大块红地砖"
	desc = "精心铺设的大块红色陶土砖，构成令人愉悦的对称图案。"
/turf/open/floor/rogue/blocks/stonered/tiny
	icon_state = "stoneredtiny"
	name = "方形红地砖"
	desc = "精心排列的小方形陶土砖，图案略显朴素。"

/turf/open/floor/rogue/blocks/green
	icon_state = "greenblocks"

/turf/open/floor/rogue/blocks/bluestone
	icon_state = "bluestone2"

/turf/open/floor/rogue/blocks/newstone
	icon_state = "newstone2"

/turf/open/floor/rogue/blocks/newstone/alt
	icon_state = "bluestone"

/turf/open/floor/rogue/blocks/paving
	icon_state = "paving"
/turf/open/floor/rogue/blocks/paving/vert
	icon_state = "paving-t"

/turf/open/floor/rogue/blocks/platform
	name = "平台"
	desc = "一处可被摧毁的平台。"
	damage_deflection = 10
	max_integrity = 800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')

/turf/open/floor/rogue/blocks/platform/turf_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/rogue/greenstone
	icon_state = "greenstone"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	icon = 'icons/turf/greenstone.dmi'

/turf/open/floor/rogue/greenstone/runed
	icon_state = "greenstoneruned"

/turf/open/floor/rogue/greenstone/glyph1
	icon_state = "glyph1"

/turf/open/floor/rogue/greenstone/glyph2
	icon_state = "glyph2"

/turf/open/floor/rogue/greenstone/glyph3
	icon_state = "glyph3"

/turf/open/floor/rogue/greenstone/glyph4
	icon_state = "glyph4"

/turf/open/floor/rogue/greenstone/glyph5
	icon_state = "glyph5"

/turf/open/floor/rogue/greenstone/glyph6
	icon_state = "glyph6"

/turf/open/floor/rogue/hexstone
	icon_state = "hexstone"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/open/floor/rogue/herringbone,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/cobblerock,
						/turf/open/floor/rogue/cobble/mossy,
						/turf/open/floor/rogue/blocks,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/hexstone/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/hexstone/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

//Church floors

/turf/open/floor/rogue/churchmarble
	icon_state = "church_marble"
	name = "大理石地板"
	desc = "抛光的大理石地砖在每一步下都发出清脆回响，是恢弘殿堂中备受珍视的材料。"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/open/floor/rogue/herringbone,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/churchmarble/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/churchmarble/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/church
	icon_state = "church"
	name = "抛光瓷砖地板"
	desc = "尽管灰尘和污垢不断堆积，这些釉面瓷砖历经数十年却几乎毫无刮痕。"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/open/floor/rogue/herringbone,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/church/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/church/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/churchbrick
	icon_state = "church_brick"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/open/floor/rogue/herringbone,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/churchbrick/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/churchbrick/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/churchrough
	icon_state = "church_rough"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/open/floor/rogue/herringbone,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/cobble/mossy,
						/turf/open/floor/rogue/cobblerock,
						/turf/open/floor/rogue/blocks,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/churchrough/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/churchrough/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)
//
/turf/open/floor/rogue/herringbone
	icon_state = "herringbone"
	name = "石制人字地板"
	desc = "这些石砖被精心铺排成相当悦目的图案。"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	neighborlay = "herringedge"
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/herringbone,
						/turf/open/floor/rogue/blocks,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/herringbone/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/herringbone/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/obj/effect/decal/herringbone
	name = "人字地板"
	desc = "这些石砖被精心铺排成相当悦目的图案。"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "herringedge"
	mouse_opacity = 0

/obj/effect/decal/wood/herringbone
	name = "人字地板"
	desc = "细薄木板被精心铺排成相当悦目的图案。"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "herringbonewoodedge"
	mouse_opacity = 0

/obj/effect/decal/wood/herringbone2
	name = "人字地板"
	desc = "细薄木板被精心铺排成相当悦目的图案。"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "herringbonewood2edge"
	mouse_opacity = 0

/turf/open/floor/rogue/ruinedwood/herringbone
	name = "木制人字地板"
	desc = "细薄木板被精心铺排成相当悦目的图案。"
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/woodland.wav'
	icon_state = "herringbonewood"

/turf/open/floor/rogue/ruinedwood/herringbone_clear
	name = "木制人字地板"
	desc = "细薄木板被精心铺排成相当悦目的图案。"
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/woodland.wav'
	icon_state = "herringbonewood2"

/turf/open/floor/rogue/wood/herringbone
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/woodland.wav'
	icon_state = "herringbonewood2"

/turf/open/floor/rogue/cobble
	icon_state = "cobblestone1"
	name = "圆石路"
	desc = "精心铺设在地面上的石砖，铺成了一条更精致、更经久耐用的道路。"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	neighborlay = "cobbleedge"
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/dirt/road,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/grassgrey,
						/turf/open/floor/rogue/grasspurple,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/AzureSand,
						/turf/open/floor/rogue/cobblerock,
						/turf/open/floor/rogue/cobble/mossy,
						/turf/open/floor/rogue/blocks,)

/turf/open/floor/rogue/cobble/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/cobble/Initialize(mapload)
	. = ..()
	icon_state = "cobblestone[rand(1,3)]"

/turf/open/floor/rogue/cobble/mossy
	name = "长满苔藓的鹅卵石"
	desc = "泥土和苔藓爬满了这石砖地面的缝隙。"
	icon_state = "mossystone1"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	neighborlay = "mossystone_edges"
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/dirt/road,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/grassgrey,
						/turf/open/floor/rogue/grasspurple,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/cobblerock,
						/turf/open/floor/rogue/blocks,
						/turf/open/floor/rogue/dirt/desert,
						/turf/open/floor/rogue/dirt/road/desert,
						/turf/open/floor/rogue/desert_grass,)

/turf/open/floor/rogue/cobble/mossy/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/cobble/mossy/Initialize(mapload)
	. = ..()
	icon_state = "mossystone[rand(1,3)]"

/obj/effect/decal/mossy
	name = "苔砖地面"
	desc = "泥土与苔藓已经爬进了这片砖地的缝隙之间。"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "mossyedge"
	mouse_opacity = 0

/obj/effect/decal/cobble/mossy
	name = "苔砖地面"
	desc = "泥土与苔藓已经爬进了这片砖地的缝隙之间。放在室外花园倒很合适，放在家里就未必了。"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "mossystone_edges"
	mouse_opacity = 0

/obj/effect/decal/edge
	name = "石质路缘"
	desc = "一块用于勾勒城市道路边界的石材。"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "border"
	mouse_opacity = 0

/obj/effect/decal/edge_corner
	name = "石质路缘角"
	desc = "一块用于勾勒城市道路边界的石材。"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "border_corner"
	mouse_opacity = 0

/turf/open/floor/rogue/cobblerock
	icon_state = "cobblerock"
	name = "碎石小路"
	desc = "一条由坑洼不平的石头铺成的简陋小路，让行人和车轮都能逃脱泥泞的困扰。"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
//	neighborlay = "cobblerock"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue,
						/turf/closed/mineral,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/cobble/mossy,
						/turf/open/floor/rogue/blocks,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/dirt/road,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/grassgrey,
						/turf/open/floor/rogue/grasspurple,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/dirt/desert,
						/turf/open/floor/rogue/dirt/road/desert,
						/turf/open/floor/rogue/desert_grass,
						/turf/closed/wall/mineral)

/turf/open/floor/rogue/cobblerock/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/obj/effect/decal/cobbleedge
	name = "旧鹅卵石路"
	desc = "侵蚀与岁月让这条路磨损成了半散落的碎石，正缓缓沉回泥土之中。"
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "cobblestone_edges"
	mouse_opacity = 0

/obj/effect/decal/carpet
	name = "异域地毯"
	desc = "炫目的对称纹样流露出某种古老文化的风格。"
	pixel_w = -16
	pixel_z = -17
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "kover"

/obj/effect/decal/carpet/kover_darkred
	name = "乡野红地毯"
	desc = "炫目的对称纹样流露出某种古老文化的风格。"
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "kover_darkred"

/obj/effect/decal/carpet/kover_purple
	name = "乡野紫地毯"
	desc = "炫目的对称纹样流露出某种古老文化的风格。"
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "kover_purple"

/obj/effect/decal/carpet/kover_black
	name = "乡野黑地毯"
	desc = "炫目的对称纹样流露出某种古老文化的风格。"
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "kover_black"

/obj/effect/decal/carpet/square
	name = "绿色地毯"
	desc = "柔软的绿色地毯，让人想起长满青草的原野。"
	pixel_w = -16
	pixel_z = -16
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "greencarpet"

/obj/effect/decal/carpet/square/black
	name = "黑色地毯"
	desc = "黑得如同暴风雨中的夜空。"
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "blackcarpet"

/obj/structure/giantfur
	name = "巨兽毛皮"
	desc = "某种巨型野兽的毛皮，被制成了地垫。"
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "fur"
	density = FALSE
	anchored = TRUE
	plane = -7

/obj/structure/giantfur/small // the irony
	name = "毛皮垫"
	desc = "幼兽的毛皮，被制成了地垫。"
	icon_state = "fur_alt"

/turf/open/floor/rogue/tile
	icon_state = "chess"
	desc = "脚步踏过布满阴谋与诡计的棋盘格地板。"
	landsound = 'sound/foley/jumpland/tileland.wav'
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	footstepstealth = TRUE
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/dirt/road,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/cobble/mossy,
						/turf/open/floor/rogue/blocks,
						/turf/open/floor/rogue/grassgrey,
						/turf/open/floor/rogue/grasspurple,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/tile/masonic
	icon_state = "masonic"
/turf/open/floor/rogue/tile/masonic/single
	icon_state = "masonicsingle"
/turf/open/floor/rogue/tile/masonic/inverted
	icon_state = "masonicsingleinvert"
/turf/open/floor/rogue/tile/masonic/spiral
	icon_state = "masonicspiral"

/turf/open/floor/rogue/tile/bath
	name = "浴池砖"
	desc = "一种适合浴池与水池的特殊防水地面。潮湿时会很滑。"
	icon_state = "bathtile"


/turf/open/floor/rogue/tile/brick
	icon_state = "bricktile"

/turf/open/floor/rogue/tile/bfloorz
	icon_state = "bfloorz"

/turf/open/floor/rogue/tile/tilerg
	icon_state = "tilerg"

/turf/open/floor/rogue/tile/checker
	icon_state = "linoleum"

/turf/open/floor/rogue/tile/checkeralt
	icon_state = "tile"

/turf/open/floor/rogue/tile/brownbrick
	icon_state = "brown"

/turf/open/floor/rogue/tile/harem
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "harem"

/turf/open/floor/rogue/tile/harem1
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "harem1"

/turf/open/floor/rogue/tile/harem2
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "harem2"

/turf/open/floor/rogue/concrete
	icon_state = "concretefloor1"
	name = "石板地板"
	desc = "坚固的石板经过精心雕刻铺设，彼此之间几乎没有一丝缝隙。"
	landsound = 'sound/foley/jumpland/stoneland.wav'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/concrete/Initialize(mapload)
	. = ..()
	icon_state = "concretefloor[rand(1,2)]"
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/concrete/bronze
	color = "#ff9100"

/turf/open/floor/rogue/metal
	icon_state = "plating1"
	desc = "这片金属地面遍布成千上万次锤击留下的刻痕，每一步都会在脚下发出铿锵回响。"
	landsound = 'sound/foley/jumpland/metalland.wav'
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	footstepstealth = TRUE
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/metal/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/metal/barograte
	icon_state = "barograte"
/turf/open/floor/rogue/metal/barograte/open
	icon_state = "barograteopen"

/turf/open/floor/rogue/carpet
	icon_state = "carpet"
	desc = "柔软厚实的织物让脚步也变得轻缓。你进门前记得擦鞋了吗？"
	landsound = 'sound/foley/jumpland/carpetland.wav'
	footstep = FOOTSTEP_CARPET
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	clawfootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/cobble/mossy,
						/turf/open/floor/rogue/cobblerock,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/grasspurple,
						/turf/open/floor/rogue/grassgrey,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/carpet/lord
	icon_state = ""

/turf/open/floor/rogue/carpet/lord/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/turf/open/floor/rogue/carpet/lord/Destroy()
	GLOB.lordcolor -= src
	return ..()

/turf/open/floor/rogue/carpet/lord/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "[icon_state]_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)

/turf/open/floor/rogue/carpet/lord/center
	icon_state = "carpet_c"

/turf/open/floor/rogue/carpet/lord/center/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	..()

/turf/open/floor/rogue/carpet/lord/left
	icon_state = "carpet_l"

/turf/open/floor/rogue/carpet/lord/right
	icon_state = "carpet_r"

/turf/open/floor/rogue/shroud
	name = "树冠"
	icon_state = "treetop1"
	landsound = 'sound/foley/jumpland/dirtland.wav'
	footstep = null
	barefootstep = null
	clawfootstep = null
	heavyfootstep = null
	slowdown = 4

/turf/open/floor/rogue/shroud/Entered(atom/movable/AM, atom/oldLoc)
	..()
	if(isliving(AM))
		if(istype(oldLoc, type))
			playsound(AM, "plantcross", 100, TRUE)

/turf/open/floor/rogue/shroud/Initialize(mapload)
	. = ..()
	icon_state = "treetop[rand(1,2)]"
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/naturalstone
	name = "粗糙石地"
	desc = "这片粗粝的石地因侵蚀或镐击而暴露在空气中，几簇稀疏的地衣在裂缝间勉强存活。"
	icon_state = "digstone"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral)

/turf/open/floor/rogue/naturalstone/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/dark_ice
	name = "黑冰"
	desc = "一块深黑色的岩石表面覆着不自然的寒冰。"
	icon_state = "blackice"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue, /turf/open/floor/rogue/underworld)
	temperature = 100

/turf/open/floor/rogue/dark_ice/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/dark_ice/regular
	name = "冰面"
	desc = "寒冷、寒冷的冰层。你难道不想再往里面看得更深些吗？"

/turf/open/floor/rogue/dark_ice/regular/turf_destruction(damage_flag)
	. = ..()
	visible_message(span_danger("[src] 裂开并崩碎了！"))
	playsound(src, 'sound/foley/waterenter.ogg', 100, FALSE)
	ChangeTurf(/turf/open/water/pond, flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/rogue/dark_ice/regular/Entered(atom/movable/AM)
	..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/H = AM
	if(HAS_TRAIT(H, TRAIT_LIGHT_STEP) || H.m_intent == MOVE_INTENT_SNEAK)
		return
	if(prob(25))
		to_chat(H, span_warning("你脚下的 [src] 开始裂开了！"))
		addtimer(CALLBACK(src, PROC_REF(ice_crack)), 2 SECONDS, TIMER_UNIQUE)
		return
	if(prob(40))
		var/list/possible_turfs = list()
		for(var/turf/T in range(1, H))
			if(T.density)
				continue
			possible_turfs += T
		H.forceMove(pick(possible_turfs))
		to_chat(H, span_warning("我在 [src] 上滑倒了！"))

/turf/open/floor/rogue/dark_ice/regular/proc/ice_crack()
	for(var/mob/living/target in contents)
		target.Knockdown(SHOVE_KNOCKDOWN_HUMAN)
	turf_destruction("blunt")
	return

/obj/structure/roguesand/dune
	name = "dune"
	desc = "A high bank of sand blocks the view beyond it. Reach its top to see across, traveler."

	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "dune_1"

	anchored = TRUE
	density = FALSE
	opacity = TRUE
	mouse_opacity = 0
	max_integrity = 10
	layer = 4.1

	blade_dulling = DULLING_CUT
	attacked_sound = "plantcross"
	destroy_sound = "plantcross"


/obj/structure/roguesand/dune/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/roguegrass) //bro its fine trust me

/obj/structure/roguesand/dune/Crossed(atom/movable/O)
	. = ..()
	if(!isliving(O))
		return
	opacity = FALSE


/obj/structure/roguesand/dune/Uncrossed(atom/movable/O)
	. = ..()
	if(!isliving(O))
		return
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		if(L != O)
			return
	opacity = TRUE

/obj/structure/roguesand/dune/one
	icon_state = "dune_1"

/obj/structure/roguesand/dune/two
	icon_state = "dune_2"

/obj/structure/roguesand/dune/three
	icon_state = "dune_3"

/obj/structure/roguesand/dune/four
	icon_state = "dune_4"

/obj/structure/roguesand/dune/five
	icon_state = "dune_5"

/obj/structure/roguesand/dune/six
	icon_state = "dune_6"
