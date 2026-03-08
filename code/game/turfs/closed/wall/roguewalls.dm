/turf/closed/wall/examine()
	. += ..()
	if(max_integrity)
		var/healthpercent = (turf_integrity/max_integrity) * 100
		switch(healthpercent)
			if(50 to 99)
				. += "It looks slightly damaged."
			if(25 to 50)
				. += "It appears heavily damaged."
			if(1 to 25)
				. +=  "<span class='warning'>It's falling apart!</span>"

/turf/closed/wall/Initialize(mapload)
	if(smooth_icon)
		icon = smooth_icon
	. = ..()


/turf/closed/wall/stone
	name = "stone wall"
	desc = "A wall of smooth unyielding stone."
	icon = 'icons/turf/walls/stone_wall.dmi'
	icon_state = "stone"
	smooth = SMOOTH_MORE
	blade_dulling = DULLING_BASH
	max_integrity = 1800
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	canSmoothWith = list(/turf/closed/wall/stone, /obj/structure/falsewall/stone)
	above_floor = /turf/open/floor/rogue/blocks
	baseturfs = list(/turf/open/floor/rogue/blocks)
	neighborlay = "dirtedge"
	climbdiff = 3
	damage_deflection = 10

/turf/closed/wall/stone/turf_destruction()
	loud_message("The sound of a crumbling stone wall rings out", hearing_distance = 14)
	. = ..()

/turf/closed/wall/stone/unbreakable
	name = "heavy stone wall"
	desc = "Seems nigh-indestructable"
	max_integrity = 10000000
	damage_deflection = 99999999

/turf/closed/wall/stone/unbreakable/attackby(obj/item/I, mob/user, params, multiplier)
	to_chat(user, span_warning("TOO HARD!"))
	return FALSE

/turf/closed/wall/stone/window
	name = "stone window"
	desc = "A window with a solid and sturdy stone frame."
	opacity = FALSE
	max_integrity = 1300

/turf/closed/wall/stone/window/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && ((mover.pass_flags & PASSTABLE) || (mover.pass_flags & PASSGRILLE)) )
		return 1
	return ..()

/turf/closed/wall/stone/window/Initialize(mapload)
	. = ..()
	icon_state = "stone"
	var/mutable_appearance/M = mutable_appearance(icon, "stonehole", layer = ABOVE_NORMAL_TURF_LAYER)
	add_overlay(M)

/turf/closed/wall/stone/window/unbreakable
	name = "heavy stone window"
	desc = "Seems nigh-indestructable"
	max_integrity = 10000000
	damage_deflection = 99999999

/turf/closed/wall/stone/window/unbreakable/attackby(obj/item/I, mob/user, params, multiplier)
	to_chat(user, span_warning("TOO HARD!"))
	return FALSE

/turf/closed/wall/stone/moss
	icon = 'icons/turf/walls/mossy_stone.dmi'
	climbdiff = 4

/turf/closed/wall/stone/moss/unbreakable
	desc = "Seems nigh-indestructable"
	max_integrity = 10000000
	damage_deflection = 99999999

/turf/closed/wall/stone/moss/unbreakable/attackby(obj/item/I, mob/user, params, multiplier)
	to_chat(user, span_warning("TOO HARD!"))
	return FALSE

/turf/closed/wall/stone/window/moss
	icon = 'icons/turf/walls/mossy_stone.dmi'
	climbdiff = 4

/turf/closed/wall/stone/window/moss/unbreakable
	desc = "Seems nigh-indestructable"
	max_integrity = 10000000
	damage_deflection = 99999999

/turf/closed/wall/stone/window/moss/unbreakable/attackby(obj/item/I, mob/user, params, multiplier)
	to_chat(user, span_warning("TOO HARD!"))
	return FALSE

/turf/closed/wall/craftstone
	name = "stone wall"
	desc = "A durable wall made from specially-crafted stone."
	icon = 'icons/turf/walls/craftstone.dmi'
	icon_state = "box"
	smooth = SMOOTH_MORE
	blade_dulling = DULLING_BASH
	max_integrity = 2200
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	canSmoothWith = list(/turf/closed/wall/craftstone)
	above_floor = /turf/open/floor/rogue/blocks
	baseturfs = list(/turf/open/floor/rogue/blocks)
	neighborlay = "dirtedge"
	climbdiff = 3
	damage_deflection = 10

/turf/closed/wall/craftstone/turf_destruction()
	loud_message("The sound of heavy stone bricks crumbling apart rings out", hearing_distance = 14)
	. = ..()

/turf/closed/wall/stonebrick
	name = "brick wall"
	desc = "Rows of overlapping bricks form this wall."
	icon = 'icons/turf/walls/stonebrick.dmi'
	icon_state = "stonebrick"
	smooth = SMOOTH_MORE
	blade_dulling = DULLING_BASH
	max_integrity = 1500
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	canSmoothWith = list(/turf/closed/wall/stonebrick, /turf/closed/wall/wooddark)
	above_floor = /turf/open/floor/rogue/blocks
	baseturfs = list(/turf/open/floor/rogue/blocks)
	neighborlay = "dirtedge"
	climbdiff = 4
	damage_deflection = 20

/turf/closed/wall/wood
	name = "wooden wall"
	desc = "A rough-hewn wall of wood."
	icon = 'icons/turf/walls/roguewood.dmi'
	icon_state = "wood"
	smooth = SMOOTH_MORE
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 1100
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	canSmoothWith = list(/turf/closed/wall/wood, /obj/structure/roguewindow, /obj/structure/roguetent, /turf/closed/wall/wooddark)
//	sheet_type = /obj/item/grown/log/tree/lumber
	above_floor = /turf/open/floor/rogue/ruinedwood
	baseturfs = list(/turf/open/floor/rogue/ruinedwood)
	neighborlay = "dirtedge"
	climbdiff = 3

	burn_power = 20
	spread_chance = 4

/turf/closed/wall/wood/window
	name = "wooden window"
	desc = "A window with a rough-hewn wood frame."
	opacity = FALSE
	max_integrity = 550

/turf/closed/wall/wood/window/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && ((mover.pass_flags & PASSTABLE) || (mover.pass_flags & PASSGRILLE)) )
		return 1
	return ..()

/turf/closed/wall/wood/window/Initialize(mapload)
	. = ..()
	var/mutable_appearance/M = mutable_appearance(icon, "woodhole", layer = ABOVE_NORMAL_TURF_LAYER)
	add_overlay(M)

/turf/closed/wall/tent
	name = "tent"
	desc = "Made from durable fabric stretched over wooden branches."
	icon = 'icons/turf/walls.dmi'
	icon_state = "tent"
	smooth = SMOOTH_FALSE
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 300
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
//	canSmoothWith = list(/turf/closed/wall/wood, /obj/structure/roguewindow, /turf/closed/wall/wooddark)
//	sheet_type = /obj/item/grown/log/tree/lumber
	above_floor = /turf/open/floor/rogue/twig
	baseturfs = list(/turf/open/floor/rogue/twig)
	neighborlay = "dirtedge"
	climbdiff = 1

	burn_power = 20
	spread_chance = 9

/turf/closed/wall/wooddark
	name = "dark wood wall"
	desc = "Made from durable, somewhat darker wood." // i am not sure if the wood is really dark
	icon = 'icons/turf/walls.dmi'
	icon_state = "corner"
	smooth = SMOOTH_FALSE
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 1100
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
//	sheet_type = /obj/item/grown/log/tree/lumber
	above_floor = /turf/open/floor/rogue/ruinedwood
	baseturfs = list(/turf/open/floor/rogue/ruinedwood)
	neighborlay = "dirtedge"
	climbdiff = 3
	burn_power = 20
	spread_chance = 4

/turf/closed/wall/wooddark/horizontal
	icon_state = "horizwooddark"

/turf/closed/wall/wooddark/vertical
	icon_state = "vertwooddark"

/turf/closed/wall/wooddark/end
	icon_state = "endwooddark"

/turf/closed/wall/wooddark/end/east
	dir = 4

/turf/closed/wall/wooddark/end/west
	dir = 8

/turf/closed/wall/wooddark/end/north
	dir = 1

/turf/closed/wall/wooddark/slitted
	icon_state = "slittedwooddark"

/turf/closed/wall/wooddark/window
	name = "dark wood window"
	icon_state = "subwindow"
	opacity = FALSE
	max_integrity = 850

/turf/closed/wall/wooddark/window/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && ((mover.pass_flags & PASSTABLE) || (mover.pass_flags & PASSGRILLE)) )
		return 1
	return ..()

/turf/closed/wall/roofwall
	name = "wooden wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = ""
	smooth = SMOOTH_FALSE
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 1100
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	above_floor = /turf/open/floor/rogue/rooftop
	baseturfs = list(/turf/open/floor/rogue/ruinedwood)
	neighborlay = "dirtedge"
	climbdiff = 3
	burn_power = 20
	spread_chance = 4

/turf/closed/wall/roofwall/center
	icon_state = "roofTurf_I"

/turf/closed/wall/roofwall/middle
	icon_state = "roofTurf_M"

/turf/closed/wall/roofwall/middle/dir1
	dir = 1

/turf/closed/wall/roofwall/middle/dir8
	dir = 8

/turf/closed/wall/roofwall/middle/dir4
	dir = 4

/turf/closed/wall/roofwall/outercorner
	icon_state = "roofTurf_OC"

/turf/closed/wall/roofwall/outercorner/dir1
	dir = 1

/turf/closed/wall/roofwall/outercorner/dir8
	dir = 8

/turf/closed/wall/roofwall/outercorner/dir4
	dir = 4

/turf/closed/wall/roofwall/innercorner
	icon_state = "roofTurf_IC"

/turf/closed/wall/roofwall/innercorner/dir1
	dir = 1

/turf/closed/wall/roofwall/innercorner/dir8
	dir = 8

/turf/closed/wall/roofwall/innercorner/dir4
	dir = 4

/turf/closed/wall/decowood
	name = "decorated wooden wall"
	desc = "Meticulously designed by a professional carpenter."
	icon = 'icons/turf/walls.dmi'
	icon_state = "decowood"
	smooth = SMOOTH_FALSE
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 1100
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
//	sheet_type = /obj/item/grown/log/tree/lumber
	above_floor = /turf/open/floor/rogue/ruinedwood
	baseturfs = list(/turf/open/floor/rogue/ruinedwood)
	neighborlay = "dirtedge"
	climbdiff = 3
	burn_power = 20
	spread_chance = 4

/turf/closed/wall/decowood/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/closed/wall/decowood/vert
	name = "decorated wooden wall"
	icon_state = "decowood-vert"

/turf/closed/wall/decostone
	name = "decorated stone wall"
	desc = "The mason did an excellent job etching details into this wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "decostone-b"
	smooth = SMOOTH_MORE
	blade_dulling = DULLING_BASH
	max_integrity = 1800
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	above_floor = /turf/open/floor/rogue/blocks
	baseturfs = list(/turf/open/floor/rogue/blocks)
	neighborlay = "dirtedge"
	climbdiff = 3

/turf/closed/wall/decostone/long
	icon_state = "decostone-l"

/turf/closed/wall/decostone/long/east_west
	dir = 1

/obj/structure/thronething
	name = "decorated stone wall" // what is thronething??
	icon = 'icons/turf/walls.dmi'
	max_integrity = 0
	opacity = 0
	icon_state = "decostone-l"

/turf/closed/wall/decostone/center
	icon_state = "decostone-c"

/turf/closed/wall/decostone/end
	icon_state = "decostone-e"

/turf/closed/wall/decostone/end/north
	dir = 1

/turf/closed/wall/decostone/end/east
	dir = 4

/turf/closed/wall/decostone/end/west
	dir = 8

/turf/closed/wall/decostone/cand
	icon_state = "decostone-cand"

/turf/closed/wall/decostone/fluffstone
	icon_state = "fluffstone"

//Mildly better than stone-wall due to it being harder to make, plus not loose-stone cobbled together. Also higher climbing diff akin to stone-brick wall.
/turf/closed/wall/brick
	name = "brick wall"
	desc = "Rows of overlapping bricks held together by mortar form a nigh-impenetrable wall of stone."
	icon = 'icons/turf/walls/brick_wall.dmi'
	icon_state = "brick"
	smooth = SMOOTH_MORE
	blade_dulling = DULLING_BASH
	max_integrity = 2000	//200 more than base stone wall
	sheet_type = /obj/item/natural/brick
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	canSmoothWith = list(/turf/closed/wall/brick)
	above_floor = /turf/open/floor/rogue/tile/brick
	baseturfs = list(/turf/open/floor/rogue/tile/brick)
	neighborlay = "dirtedge"
	climbdiff = 4			//Same as stone-brick wall
	damage_deflection = 20

/turf/closed/wall/brick/window
	name = "brick window"
	desc = "A window with a solid and sturdy stone frame."
	opacity = FALSE
	max_integrity = 1500

/turf/closed/wall/shroud //vines
	name = "thick treetop"
	desc = "All the birds flew away before I could see one!"
	icon = 'icons/turf/walls.dmi'
	icon_state = "shroud1"
	smooth = SMOOTH_MORE|SMOOTH_BORDER
	canSmoothWith = null
	baseturfs = /turf/open/floor/rogue/shroud
	blade_dulling = DULLING_CUT
	opacity = 1
	density = TRUE
	max_integrity = 200
//	layer = EDGED_TURF_LAYER /ROGTODO make these have borders and smooth
	temperature = TCMB
	sheet_type = null
	attacked_sound = list('sound/combat/hits/onvine/vinehit.ogg')
	debris = list(/obj/item/grown/log/tree/stick = 1, /obj/item/natural/thorn = 2, /obj/item/natural/fibers = 1)
	climbdiff = 0
	above_floor = /turf/open/floor/rogue/shroud
	var/res = 0
	var/res_replenish

/turf/closed/wall/shroud/attack_right(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(src, "plantcross", 50, FALSE, -1)
		if(do_after(L, rand(5,10), target = src))
			if(!res && world.time > res_replenish)
				res = rand(1,3)
			if(res && prob(50))
				res--
				if(res <= 0)
					res_replenish = world.time + 8 MINUTES
				var/obj/item/B = new /obj/item/grown/log/tree/stick(user.loc)
				user.put_in_hands(B)
				user.visible_message(span_notice("[user] finds [B] in [src]."))
				return
			user.visible_message(span_warning("[user] searches through [src]."))
			if(!res)
				to_chat(user, span_warning("Picked clean... I should try later."))
	..()

/turf/closed/wall/shroud/Initialize(mapload)
	. = ..()
	icon_state = "shroud[pick(1,2)]"
	dir = pick(GLOB.cardinals)
	res = rand(1,3)
	var/turf/open/transparent/openspace/target = get_step_multiz(src, UP)
	if(istype(target))
		target.ChangeTurf(/turf/open/floor/rogue/dirt/road)

/turf/closed/wall/pipe
	name = "metal wall"
	desc = "Solid steel made into an impenetrable obstacle."
	icon = 'icons/turf/pipewall.dmi'
	icon_state = "iron_box"
	smooth = SMOOTH_MORE
	blade_dulling = DULLING_BASH
	max_integrity = 30000
	sheet_type = null
	break_sound = 'sound/combat/hits/onmetal/sheet (1).ogg'
	attacked_sound = list('sound/combat/hits/onmetal/attackpipewall (1).ogg','sound/combat/hits/onmetal/attackpipewall (2).ogg')
	canSmoothWith = list(/turf/closed/wall/pipe)
	above_floor = /turf/open/floor/rogue/concrete
	baseturfs = list(/turf/open/floor/rogue/concrete)
	climbdiff = 4
	damage_deflection = 20

/turf/closed/wall/pipe/corners
	icon_state = "iron_corner"

/turf/closed/wall/pipe/corners/one
	dir = 1

/turf/closed/wall/pipe/corners/four
	dir = 4

/turf/closed/wall/pipe/corners/eight
	dir = 8

/turf/closed/wall/pipe/joint
	icon_state = "iron_joint"

/turf/closed/wall/pipe/joint/one
	dir = 1

/turf/closed/wall/pipe/joint/four
	dir = 4

/turf/closed/wall/pipe/joint/eight
	dir = 8

/turf/closed/wall/pipe/line
	icon_state = "iron_line"

/turf/closed/wall/pipe/line/four
	dir = 4

/turf/closed/wall/stone/blue_moss
	icon = 'icons/turf/walls/blue_mossy.dmi'

/turf/closed/wall/stone/window/blue_moss
	icon = 'icons/turf/walls/blue_mossy.dmi'

/turf/closed/wall/stone/red_moss
	icon = 'icons/turf/walls/red_mossy.dmi'

/turf/closed/wall/stone/red_moss
	icon = 'icons/turf/walls/red_mossy.dmi'
/turf/closed/wall/decostone/mossy
	name = "decorated mossy stone wall"
	desc = "There was much effort put into this wall a long time ago."
	icon = 'icons/turf/Rougewall_mossy.dmi'
	icon_state = "decostone-b-green"
	climbdiff = 4

/turf/closed/wall/decostone/mossy/long
	icon_state = "decostone-l-green"

/turf/closed/wall/decostone/mossy/end
	icon_state = "decostone-e-green"

/turf/closed/wall/decostone/mossy/cand
	icon_state = "decostone-cand-green"

/turf/closed/wall/decostone/mossy/blue
	icon_state = "decostone-b-blue"

/turf/closed/wall/decostone/mossy/blue/long
	icon_state = "decostone-l-blue"

/turf/closed/wall/decostone/mossy/blue/end
	icon_state = "decostone-e-blue"

/turf/closed/wall/decostone/mossy/blue/cand
	icon_state = "decostone-cand-blue"

/turf/closed/wall/decostone/mossy/red
	icon_state = "decostone-b-red"

/turf/closed/wall/decostone/mossy/red/long
	icon_state = "decostone-l-red"

/turf/closed/wall/decostone/mossy/red/end
	icon_state = "decostone-e-red"

/turf/closed/wall/decostone/mossy/red/cand
	icon_state = "decostone-cand-red"

/turf/closed/dungeon_void
	name = "thick dungeon shroud"
	icon = 'icons/turf/walls.dmi'
	icon_state = "shroud1"
