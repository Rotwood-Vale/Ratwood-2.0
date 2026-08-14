//! Tempo particle effects
/particles/tempo
	icon = 'icons/effects/particles/tempo_particle.dmi'
	width = 100
	height = 100
	count = 4
	spawning = 0.4
	lifespan = 1.5 SECONDS
	fade = 1 SECONDS
	velocity = list(0, 0.4, 0)
	position = list(6, 0, 0)
	drift = generator(GEN_BOX, list(-16, -16, 0), list(16, 16, 0), NORMAL_RAND)
	friction = 0.2
	//gravity = list(0, 1.05)
	//grow = 0.05

/particles/tempo/tempo_one
	icon_state = "tempo1"

/particles/tempo/tempo_two
	icon_state = "tempo2"

/particles/tempo/tempo_three
	icon_state = "tempo3"
