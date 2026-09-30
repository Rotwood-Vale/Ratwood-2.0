//! Tempo particle effects
/particles/tempo
	icon = 'icons/effects/particles/tempo_particle.dmi'
	width = 50
	height = 50
	count = 4
	spawning = 0.4
	lifespan = 1.5 SECONDS
	fade = 1 SECONDS
	velocity = list(0, 2, 0)
	position = generator(GEN_BOX, list(-16, -16, 0), list(16, 16, 0), NORMAL_RAND)
	drift = 0
	friction = 0
	scale = 0.3

/particles/tempo/tempo_one
	icon_state = "tempo1"

/particles/tempo/tempo_two
	icon_state = "tempo2"

/particles/tempo/tempo_three
	icon_state = "tempo3"
