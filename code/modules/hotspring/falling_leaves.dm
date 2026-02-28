/particles/leaf
	icon 		= 'icons/effects/particles/particle.dmi'
	icon_state	= list("leaf1"=5, "leaf2"=6, "leaf3"=5)

	spin		= 6
	position 	= generator("box", list(0,32,0), list(32,48,0))
	gravity 	= list(0, -1, 0.1)
	friction 	= 0.5
	drift 		= generator("circle", 1)
	lifespan = generator("num", 35, 55)
	fade = generator("num", 2, 6)
	spawning = 1
	count = 3
	width = 800
	height = 800

/obj/effect/falling_leaves/New(loc, ...)
	. = ..()
	particles = new/particles/leaf

/particles/sakura
	icon 		= 'icons/effects/particles/particle.dmi'
	icon_state	= "petals1"

	spin		= 6
	position 	= generator("box", list(0,32,0), list(32,48,0))
	gravity 	= list(0, -1, 0.1)
	friction 	= 0.5
	drift 		= generator("circle", 1)
	lifespan = generator("num", 35, 55)
	fade = generator("num", 2, 6)
	spawning = 1
	count = 3
	width = 800
	height = 800

/obj/effect/falling_sakura
	var/obj/effect/abstract/particle_holder/cached/particle_effect

/obj/effect/falling_sakura/Initialize(mapload, ...)
	. = ..()
	particle_effect = new(src, /particles/sakura, 6)
	//render the steam over mobs and objects on the game plane
	particle_effect.vis_flags &= ~VIS_INHERIT_PLANE

/particles/maple_base
	icon		= 'icons/effects/particles/particle.dmi'
	icon_state	= list("leaf1"=5, "leaf2"=6, "leaf3"=5)

	spin		= generator("num", -8, 8)
	position	= generator("box", list(0,32,0), list(32,48,0))
	gravity		= list(0, -1, 0.1)
	friction	= 0.5
	drift		= generator("circle", 1)
	lifespan	= generator("num", 35, 55)
	fade		= generator("num", 2, 6)
	spawning	= 0.25
	count		= 1
	width		= 800
	height		= 800

/particles/maple_base/purple
	color = "#7A3FB0"

/particles/maple_base/blue
	color = "#4A6FE3"

/particles/maple_base/orange
	color = "#E28A1E"

/particles/maple_base/red
	color = "#D63A2F"

/obj/effect/falling_maple
	var/obj/effect/abstract/particle_holder/cached/purple_particles
	var/obj/effect/abstract/particle_holder/cached/blue_particles
	var/obj/effect/abstract/particle_holder/cached/orange_particles
	var/obj/effect/abstract/particle_holder/cached/red_particles

/obj/effect/falling_maple/Initialize(mapload, ...)
	. = ..()

	purple_particles = new(src, /particles/maple_base/purple, 6)
	blue_particles = new(src, /particles/maple_base/blue, 6)
	orange_particles = new(src, /particles/maple_base/orange, 6)
	red_particles = new(src, /particles/maple_base/red, 6)

	purple_particles.vis_flags &= ~VIS_INHERIT_PLANE
	blue_particles.vis_flags &= ~VIS_INHERIT_PLANE
	orange_particles.vis_flags &= ~VIS_INHERIT_PLANE
	red_particles.vis_flags &= ~VIS_INHERIT_PLANE	
