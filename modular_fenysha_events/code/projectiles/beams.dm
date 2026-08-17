

/obj/projectile/beam
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 20
	damage_type = BURN
	flag = "fire"
	eyeblur = 4
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_outer_range = 1
	light_power = 1.4
	light_color = LIGHT_COLOR_RED
	ricochets_max = 50
	ricochet_chance = 80
	reflectable = REFLECT_NORMAL
	woundclass = BCLASS_BURN

/obj/projectile/beam/laser
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser
	damage = 25

/obj/projectile/beam/laser/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/burned = target
		burned.ignite_mob()
	else if(isturf(target))
		impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser/wall

/// Hitscan laser. Fires and resolves its whole path instantly, leaving a tracer beam.
/obj/projectile/beam/laser/hitscan
	icon_state = null
	hitscan = TRUE
	nondirectional_sprite = TRUE
	impact_effect_type = null

/obj/projectile/beam/laser/rapid
	name = "rapid fire laser"
	damage = 20

/obj/projectile/beam/laser/rapid/hitscan
	icon_state = null
	hitscan = TRUE
	nondirectional_sprite = TRUE
	impact_effect_type = null

/obj/projectile/beam/laser/practice
	name = "practice laser"
	damage = 0

/obj/projectile/beam/laser/heavy
	name = "heavy laser"
	icon_state = "heavylaser"
	damage = 40
	tracer_type = /obj/effect/projectile/tracer/heavy_laser
	muzzle_type = /obj/effect/projectile/muzzle/heavy_laser
	impact_type = /obj/effect/projectile/impact/heavy_laser

/obj/projectile/beam/laser/heavy/hitscan
	icon_state = null
	hitscan = TRUE
	nondirectional_sprite = TRUE
	impact_effect_type = null
	hitscan_light_intensity = 3
	muzzle_flash_intensity = 6
	impact_light_intensity = 7

/// Gains damage and grows the further it travels.
/obj/projectile/beam/laser/accelerator
	name = "accelerator laser"
	icon_state = "scatterlaser"
	range = 255
	damage = 6
	/// Sprite scale gained per tile travelled.
	var/size_per_tile = 0.1
	/// Cap on the scale multiplier.
	var/max_scale = 4

/obj/projectile/beam/laser/accelerator/Range()
	. = ..()
	damage += 7
	transform = matrix() * min(1 + (decayedRange - range) * size_per_tile, max_scale)

/obj/projectile/beam/weak
	damage = 15

/obj/projectile/beam/weak/penetrator
	armor_penetration = 50

/obj/projectile/beam/practice
	name = "practice laser"
	damage = 0

/obj/projectile/beam/scatter
	name = "laser pellet"
	icon_state = "scatterlaser"
	damage = 7.5

/obj/projectile/beam/xray
	name = "\improper X-ray beam"
	icon_state = "xray"
	damage = 15
	range = 15
	flag = "piercing"
	armor_penetration = 100
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE | PASSMOB
	impact_effect_type = /obj/effect/temp_visual/impact_effect/green_laser
	light_color = LIGHT_COLOR_GREEN
	tracer_type = /obj/effect/projectile/tracer/xray
	muzzle_type = /obj/effect/projectile/muzzle/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/beam/xray/hitscan
	icon_state = null
	hitscan = TRUE
	nondirectional_sprite = TRUE
	impact_effect_type = null
	hitscan_light_color_override = LIGHT_COLOR_GREEN
	muzzle_flash_color_override = LIGHT_COLOR_GREEN
	impact_light_color_override = LIGHT_COLOR_GREEN

/// Deals stamina damage rather than burning.
/obj/projectile/beam/disabler
	name = "disabler beam"
	icon_state = "omnilaser"
	damage = 30
	damage_type = STAMINA
	flag = "magic"
	speed = 1.6
	woundclass = null
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_color = LIGHT_COLOR_BLUE
	tracer_type = /obj/effect/projectile/tracer/disabler
	muzzle_type = /obj/effect/projectile/muzzle/disabler
	impact_type = /obj/effect/projectile/impact/disabler

/obj/projectile/beam/disabler/weak
	damage = 15

/obj/projectile/beam/disabler/hitscan
	icon_state = null
	hitscan = TRUE
	nondirectional_sprite = TRUE
	impact_effect_type = null
	hitscan_light_color_override = LIGHT_COLOR_BLUE
	muzzle_flash_color_override = LIGHT_COLOR_BLUE
	impact_light_color_override = LIGHT_COLOR_BLUE

/obj/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	damage = 50
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_color = LIGHT_COLOR_BLUE
	tracer_type = /obj/effect/projectile/tracer/pulse
	muzzle_type = /obj/effect/projectile/muzzle/pulse
	impact_type = /obj/effect/projectile/impact/pulse

/obj/projectile/beam/pulse/shotgun
	damage = 30

/obj/projectile/beam/pulse/heavy
	name = "heavy pulse laser"
	icon_state = "pulse1_bl"

/obj/projectile/beam/pulse/hitscan
	icon_state = null
	hitscan = TRUE
	nondirectional_sprite = TRUE
	impact_effect_type = null
	hitscan_light_color_override = LIGHT_COLOR_BLUE
	muzzle_flash_color_override = LIGHT_COLOR_BLUE
	impact_light_color_override = LIGHT_COLOR_BLUE

/obj/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	damage = 30
	impact_effect_type = /obj/effect/temp_visual/impact_effect/green_laser
	light_color = LIGHT_COLOR_GREEN

/obj/projectile/beam/emitter/hitscan
	icon_state = null
	hitscan = TRUE
	nondirectional_sprite = TRUE
	impact_effect_type = null
	muzzle_type = /obj/effect/projectile/muzzle/laser
	tracer_type = /obj/effect/projectile/tracer/laser
	impact_type = /obj/effect/projectile/impact/laser
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = LIGHT_COLOR_GREEN
	muzzle_flash_intensity = 6
	muzzle_flash_range = 2
	muzzle_flash_color_override = LIGHT_COLOR_GREEN
	impact_light_intensity = 7
	impact_light_range = 2.5
	impact_light_color_override = LIGHT_COLOR_GREEN
