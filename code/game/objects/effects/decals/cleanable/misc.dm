/obj/effect/decal/cleanable/dirt/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	if(T.tiled_dirt)
		smooth = SMOOTH_MORE
		icon = 'icons/effects/dirt.dmi'
		icon_state = ""
		queue_smooth(src)
	queue_smooth_neighbors(src)

/obj/effect/decal/cleanable/dirt/Destroy()
	queue_smooth_neighbors(src)
	return ..()

/obj/effect/decal/cleanable/dirt/dust
	name = "灰尘"
	desc = ""

/obj/effect/decal/cleanable/greenglow
	name = "发光黏液"
	desc = ""
	icon_state = "greenglow"
	light_power = 3
	light_outer_range =  2
	light_color = LIGHT_COLOR_GREEN
	beauty = -300

/obj/effect/decal/cleanable/greenglow/ex_act()
	return

/obj/effect/decal/cleanable/greenglow/filled/Initialize(mapload)
	. = ..()
	reagents.add_reagent(pick(/datum/reagent/uranium, /datum/reagent/uranium/radium), 5)

/obj/effect/decal/cleanable/dirt/cobweb
	name = "蛛网"
	desc = ""
	icon = 'modular/Mapping/icons/webbing.dmi'
	icon_state = "cobweb1"
	gender = NEUTER
	layer = WALL_OBJ_LAYER
	plane = -1
	resistance_flags = FLAMMABLE
	beauty = -100
	alpha = 200

/obj/effect/decal/cleanable/dirt/cobweb/cobweb2
	icon_state = "cobweb2"

/obj/effect/decal/cleanable/molten_object
	name = "灰色黏糊团"
	desc = ""
	gender = NEUTER
	icon = 'icons/effects/effects.dmi'
	icon_state = "molten"
	mergeable_decal = FALSE
	beauty = -150

/obj/effect/decal/cleanable/molten_object/large
	name = "大团灰色黏糊物"
	icon_state = "big_molten"
	beauty = -300

//Vomit (sorry)
/obj/effect/decal/cleanable/vomit
	name = "呕吐物"
	desc = ""
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	random_icon_states = list("vomit_1", "vomit_2", "vomit_3", "vomit_4")
	beauty = -150
	alpha = 160

/obj/effect/decal/cleanable/vomit/old
	name = "干涸的呕吐物"
	desc = ""

/obj/effect/decal/cleanable/vomit/old/Initialize(mapload)
	. = ..()
	icon_state += "-old"

/obj/effect/decal/cleanable/chem_pile
	name = "化学品堆"
	desc = ""
	gender = NEUTER
	icon_state = "ash"

/obj/effect/decal/cleanable/shreds
	name = "碎布条"
	desc = ""
	icon_state = "shreds"
	gender = PLURAL
	mergeable_decal = FALSE

/obj/effect/decal/cleanable/shreds/ex_act(severity, target)
	if(severity == 1) //so shreds created during an explosion aren't deleted by the explosion.
		qdel(src)

/obj/effect/decal/cleanable/shreds/Initialize(mapload, oldname)
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	if(!isnull(oldname))
		desc = ""
	. = ..()

/obj/effect/decal/cleanable/glitter
	name = "一堆亮粉"
	desc = ""
	icon = 'icons/effects/atmospherics.dmi'
	icon_state = "plasma_old"
	gender = NEUTER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/cleanable/glitter/pink
	name = "粉色亮粉"
	icon_state = "plasma"

/obj/effect/decal/cleanable/glitter/white
	name = "白色亮粉"
	icon_state = "nitrous_oxide"

/obj/effect/decal/cleanable/glitter/blue
	name = "蓝色亮粉"
	icon_state = "freon"

/obj/effect/decal/cleanable/plasma
	name = "稳定等离子体"
	desc = ""
	icon_state = "flour"
	icon = 'icons/effects/tomatodecal.dmi'
	color = "#2D2D2D"

/obj/effect/decal/cleanable/insectguts
	name = "虫子内脏"
	desc = ""
	icon = 'icons/effects/blood.dmi'
	icon_state = "xfloor1"
	random_icon_states = list("xfloor1", "xfloor2", "xfloor3", "xfloor4", "xfloor5", "xfloor6", "xfloor7")

/obj/effect/decal/cleanable/confetti
	name = "彩纸屑"
	desc = ""
	icon = 'icons/effects/confetti_and_decor.dmi'
	icon_state = "confetti"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT //the confetti itself might be annoying enough

/obj/effect/decal/cleanable/confetti/xylix
	desc = "由染色羊皮纸制成的彩色纸屑撒了一地，闻起来怪怪的。"
	icon = 'icons/effects/confetti.dmi'
	mouse_opacity = MOUSE_OPACITY_ICON
	random_icon_states = list("confetti1", "confetti2", "confetti3")

//................	Debris decals (result from crafting or destroying items thats just visual)	............... //
/obj/effect/decal/cleanable/debris
	name = ""
	desc = ""
	icon = 'icons/roguetown/items/crafting.dmi'
	icon_state = "tiny"
	beauty = -20
/obj/effect/decal/cleanable/debris/Initialize(mapload)
	. = ..()
	setDir(pick(GLOB.cardinals))

/obj/effect/decal/cleanable/debris/glassy
	name = "玻璃碎片"
	icon_state = "tiny"
	beauty = -100
/obj/effect/decal/cleanable/debris/glassy/Crossed(mob/living/L)
	. = ..()
	playsound(loc,'sound/foley/glass_step.ogg', 50, FALSE)

/obj/effect/decal/cleanable/debris/stony
	name = "碎石屑"
	icon_state = "pebbly"

/obj/effect/decal/cleanable/debris/woody	// sawdust gets cleared by weather
	name = "锯末"
	icon_state = "woody"
/obj/effect/decal/cleanable/debris/woody/Initialize(mapload)
	START_PROCESSING(SSprocessing, src)
	GLOB.weather_act_upon_list += src
	. = ..()
/obj/effect/decal/cleanable/debris/woody/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	GLOB.weather_act_upon_list -= src
	. = ..()
/obj/effect/decal/cleanable/debris/woody/weather_act_on(weather_trait, severity)
	qdel(src)
