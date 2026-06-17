/datum/migrant_wave/grenzel_envoy
	name = "格伦泽尔霍夫特使团"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/grenzel_envoy
	weight = 50
	downgrade_wave = /datum/migrant_wave/grenzel_envoy_down_one
	roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
		/datum/migrant_role/grenzel/bodyguard = 2,
		/datum/migrant_role/grenzel/priest = 1,
	)
	greet_text = "你们是来自格伦泽尔霍夫特的使团，带着护卫与神父一同出行，代表自己的祖国。"

/datum/migrant_wave/grenzel_envoy_down_one
	name = "格伦泽尔霍夫特使团"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/grenzel_envoy
	downgrade_wave = /datum/migrant_wave/grenzel_envoy_down_two
	roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
		/datum/migrant_role/grenzel/bodyguard = 1,
		/datum/migrant_role/grenzel/priest = 1,
	)
	greet_text = "你们是来自格伦泽尔霍夫特的使团，带着护卫与神父一同出行，代表自己的祖国。"

/datum/migrant_wave/grenzel_envoy_down_two
	name = "格伦泽尔霍夫特使团"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/grenzel_envoy
	downgrade_wave = /datum/migrant_wave/grenzel_envoy_down_three
	roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
		/datum/migrant_role/grenzel/bodyguard = 2,
	)
	greet_text = "你们是来自格伦泽尔霍夫特的使团，带着护卫与神父一同出行，代表自己的祖国。"

/datum/migrant_wave/grenzel_envoy_down_three
	name = "格伦泽尔霍夫特使团"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/grenzel_envoy
	downgrade_wave = /datum/migrant_wave/grenzel_envoy_down_four
	roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
		/datum/migrant_role/grenzel/bodyguard = 1,
	)
	greet_text = "你们是来自格伦泽尔霍夫特的使团，带着护卫与神父一同出行，代表自己的祖国。"

/datum/migrant_wave/grenzel_envoy_down_four
	name = "格伦泽尔霍夫特使团"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/grenzel_envoy
	downgrade_wave = /datum/migrant_wave/grenzel_envoy_down_five
	roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
		/datum/migrant_role/grenzel/priest = 1,
	)
	greet_text = "你们是来自格伦泽尔霍夫特的使团，带着一位神父出行，代表自己的祖国。"

/datum/migrant_wave/grenzel_envoy_down_five
	name = "格伦泽尔霍夫特使团"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/grenzel_envoy
	roles = list(
		/datum/migrant_role/grenzel/envoy = 1,
	)
	greet_text = "你是来自格伦泽尔霍夫特的使节，独自出行，代表自己的祖国。"
