/particles/weather/leaves
	icon_state	= list("leaf1"=7, "leaf2"=1, "leaf3"=1)
	spin		= 6
	position 	= generator("box", list(-500,-256,0), list(400,500,0))
	gravity 	= list(0, -1, 0.1)
	friction    = 0.3
	transform 	= null
	lifespan = 55
	fadein = 6
	//Weather effects, max values
	maxSpawning            = 25
	minSpawning            = 3
	wind                   = 2


/particles/weather/leaves/sakura
	icon_state	= "petals1"
	position 	= generator("box", list(-500,-256,0), list(400,500,0))
	gravity 	= list(0, -1, 0.1)
	friction 	= 0.5
	transform 	= null
	lifespan = 55
	fadein = 6
	//Weather effects, max values
	maxSpawning            = 30
	minSpawning            = 5
	wind                   = 1

/datum/particle_weather/leaves_gentle
	name = "劲风落叶"
	desc = "和缓的风卷起林间落叶，轻轻掠过大地。"
	particleEffectType = /particles/weather/leaves
	warning_message = span_greenannounce("轻风自各地林间吹来，拂过整片大地。")
	late_warning_message = span_greenannounce("一阵突如其来的风将落叶卷得漫天飞舞。")
	scale_vol_with_severity = TRUE

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 40
	target_trait = PARTICLEWEATHER_LEAVES

/datum/particle_weather/leaves_storm
	name = "狂风落叶"
	desc = "强劲的风席卷而来，将林间落叶搅得四散翻飞。"
	particleEffectType = /particles/weather/leaves
	warning_message = span_greenannounce("猛烈的风从林海之间呼啸而过，横扫整片大地。")
	late_warning_message = span_greenannounce("一阵狂猛的风将落叶卷得漫天乱舞。")
	scale_vol_with_severity = TRUE

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 20
	target_trait = PARTICLEWEATHER_LEAVES

/datum/particle_weather/sakura_gentle
	name = "樱风和煦"
	desc = "柔和的风穿过花木，卷起片片樱瓣。"
	particleEffectType = /particles/weather/leaves/sakura
	warning_message = span_greenannounce("爱意弥漫，一阵和缓的风穿过开花的林木。")
	late_warning_message = span_greenannounce("忽然袭来的一阵风，将花叶吹得四下飘散。")
	scale_vol_with_severity = TRUE

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 0
	target_trait = PARTICLEWEATHER_SAKURA

/datum/particle_weather/sakura_storm
	name = "樱风渐烈"
	desc = "花木之间风势渐长，漫天樱瓣翻卷不休。"
	particleEffectType = /particles/weather/leaves/sakura
	warning_message = span_greenannounce("爱意弥漫，强风穿行于繁花林木之间。")
	late_warning_message = span_greenannounce("忽然袭来的一阵狂风，将花叶吹得漫天乱舞。")
	scale_vol_with_severity = TRUE

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 0
	target_trait = PARTICLEWEATHER_SAKURA
