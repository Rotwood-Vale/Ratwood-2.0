/datum/migrant_wave
	abstract_type = /datum/migrant_wave
	/// Name of the wave
	var/name = "移民波次"
	/// Assoc list of roles types to amount
	var/list/roles = list()
	/// If defined, this is the minimum active migrants required to roll the wave
	var/min_active = null
	/// If defined, this is the maximum active migrants required to roll the wave
	var/max_active = null
	/// If defined, this is the minimum population playing the game that is required for wave to roll
	var/min_pop = null
	/// If defined, this is the maximum population playing the game that is required for wave to roll
	var/max_pop = null
	/// If defined, this is the maximum amount of times this wave can spawn
	var/max_spawns = null
	/// The relative probability this wave will be picked, from all available waves
	var/weight = 20
	/// Name of the latejoin spawn landmark for the wave to decide where to spawn
	var/spawn_landmark = "Pilgrim"
	/// Text to greet all players in the wave with
	var/greet_text
	/// Whether this wave can roll at all. If not, it can still be forced to be ran, or used as "downgrade" wave
	var/can_roll = TRUE
	/// What type of wave to downgrade to on failure
	var/downgrade_wave
	/// If defined, this will be the wave type to increment for purposes of checking `max_spawns`
	var/shared_wave_type = null
	/// Whether we want to spawn people on the rolled location, this may not be desired for bandits or other things that set the location
	var/spawn_on_location = TRUE
	/// Triumph contributions for this wave type (ckey -> amount)
	var/list/triumph_contributions = list()
	/// Total triumph invested in this wave
	var/triumph_total = 0
	/// Threshold at which this wave is guaranteed to be next
	var/triumph_threshold = 25
	/// Whether triumph contributions reset after wave spawns
	var/reset_contributions_on_spawn = TRUE

/datum/migrant_wave/proc/get_roles_amount()
	var/amount = 0
	for(var/role_type in roles)
		amount += roles[role_type]
	return amount

/datum/migrant_wave/pilgrim
	name = "朝圣之旅"
	downgrade_wave = /datum/migrant_wave/pilgrim_down_one
	roles = list(
		/datum/migrant_role/pilgrim = 4,
	)
	greet_text = "为逃离不幸与苦难，你与几名幸存者正逐渐接近谷地，寻找庇护与工作。你们终于快要到了，几乎就快到了……"

/datum/migrant_wave/pilgrim_down_one
	name = "朝圣之旅"
	downgrade_wave = /datum/migrant_wave/pilgrim_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/pilgrim = 3,
	)
	greet_text = "为逃离不幸与苦难，你与几名幸存者正逐渐接近谷地，寻找庇护与工作。你们终于快要到了，几乎就快到了……"

/datum/migrant_wave/pilgrim_down_two
	name = "朝圣之旅"
	downgrade_wave = /datum/migrant_wave/pilgrim_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/pilgrim = 2,
	)
	greet_text = "为逃离不幸与苦难，你与几名幸存者正逐渐接近谷地，寻找庇护与工作。你们终于快要到了，几乎就快到了……"

/datum/migrant_wave/pilgrim_down_three
	name = "朝圣之旅"
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/pilgrim = 1,
	)
	greet_text = "为逃离不幸与苦难，你与几名幸存者正逐渐接近谷地，寻找庇护与工作。你们终于快要到了，几乎就快到了……"

/datum/migrant_wave/adventurer
	name = "冒险小队"
	downgrade_wave = /datum/migrant_wave/adventurer_down_one
	roles = list(
		/datum/migrant_role/adventurer = 4,
	)
	greet_text = "你与一群值得信赖的伙伴结伴远行，追寻刺激、荣耀与财富，最终闯进了谷地下方那片迷雾弥漫、湿冷阴郁的沼泽，也许还把自己卷进了远超预想的麻烦之中。"

/datum/migrant_wave/adventurer_down_one
	name = "冒险小队"
	downgrade_wave = /datum/migrant_wave/adventurer_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/adventurer = 3,
	)
	greet_text = "你与一群值得信赖的伙伴结伴远行，追寻刺激、荣耀与财富，最终闯进了谷地下方那片迷雾弥漫、湿冷阴郁的沼泽，也许还把自己卷进了远超预想的麻烦之中。"

/datum/migrant_wave/adventurer_down_two
	name = "冒险小队"
	downgrade_wave = /datum/migrant_wave/adventurer_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/adventurer = 2,
	)
	greet_text = "你与一群值得信赖的伙伴结伴远行，追寻刺激、荣耀与财富，最终闯进了谷地下方那片迷雾弥漫、湿冷阴郁的沼泽，也许还把自己卷进了远超预想的麻烦之中。"

/datum/migrant_wave/adventurer_down_three
	name = "冒险小队"
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/adventurer = 1,
	)
	greet_text = "你与一群值得信赖的伙伴结伴远行，追寻刺激、荣耀与财富，最终闯进了谷地下方那片迷雾弥漫、湿冷阴郁的沼泽，也许还把自己卷进了远超预想的麻烦之中。"

/datum/migrant_wave/bandit
	name = "强盗袭击"
	downgrade_wave = /datum/migrant_wave/bandit_down_one
	can_roll = FALSE
	weight = 16
	spawn_landmark = "Bandit"
	roles = list(
		/datum/migrant_role/bandit = 4,
	)

/datum/migrant_wave/bandit_down_one
	name = "强盗袭击"
	downgrade_wave = /datum/migrant_wave/bandit_down_two
	can_roll = FALSE
	spawn_landmark = "Bandit"
	roles = list(
		/datum/migrant_role/bandit = 3,
	)

/datum/migrant_wave/bandit_down_two
	name = "强盗袭击"
	downgrade_wave = /datum/migrant_wave/bandit_down_three
	can_roll = FALSE
	spawn_landmark = "Bandit"
	roles = list(
		/datum/migrant_role/bandit = 2,
	)

/datum/migrant_wave/bandit_down_three
	name = "强盗袭击"
	can_roll = FALSE
	spawn_landmark = "Bandit"
	roles = list(
		/datum/migrant_role/bandit = 1,
	)

/datum/migrant_wave/assassin
	name = "刺客袭杀"
	downgrade_wave = /datum/migrant_wave/assassin
	can_roll = FALSE
	weight = 12
	roles = list(
		/datum/migrant_role/assassin = 4,
	)

/datum/migrant_wave/gnolls
	name = "豺狼人袭击"
	downgrade_wave = /datum/migrant_wave/gnolls
	can_roll = FALSE
	weight = 12
	roles = list(
		/datum/migrant_role/gnoll = 4,
	)
