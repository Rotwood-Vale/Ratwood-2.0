//Hail - Goes down
/particles/weather/ash
	icon_state				= list("ember"=2, "ash"=5, "ash2"=4)
	position				= generator("box", list(-500,-256,0), list(400,500,0))
	grow					= list(-0.01,-0.01)
	gravity					= list(0, -1, 0.5)
	drift					= generator("circle", 0, 1) // Some random movement for variation
	friction				= 0.3  // shed 30% of velocity and drift every 0.1s
	transform				= null // Rain is directional - so don't make it "3D"
	//Weather effects, max values
	maxSpawning				= 250
	minSpawning				= 50
	wind					= 2
	spin					= 0 // explicitly set spin to 0 - there is a bug that seems to carry generators over from old particle effects
	lifespan               = 285   // live for 30s max (fadein + lifespan + fade)
	fade = 1.5
	fadein = 1
/datum/particle_weather/ashstorm
	name = "Ashstorm"
	desc = "firey-ash from a volcano"
	particleEffectType = /particles/weather/ash
	warning_message = span_greenannounce("A thunderious cataclysm thunders in the distance and the skies grow unnaturally dark.")
	late_warning_message = span_greenannounce("The air grows hot and gritty. Ash begins to fall from above.")
	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/ash)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_ash)

	minSeverity = 30
	maxSeverity = 60
	maxSeverityChange = 5
	severitySteps = 5
	probability = 5
	target_trait = PARTICLEWEATHER_ASH

/datum/particle_weather/ashstorm/weather_act(mob/living/L)
	if(issimple(L))
		return
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.apply_weather_temperature(rand(1,3))
	else
		L.adjust_bodytemperature(rand(1,3))
	if(prob(25))
		L.adjust_fire_stacks(1)
		to_chat(L, span_danger("You're caught in a haze of burning, flammable ash!"))
