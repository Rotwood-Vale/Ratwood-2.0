/datum/carebox_table
	abstract_type = /datum/carebox_table
	/// Amount of cycles the character has to go through before receiving a carebox
	var/cycles = 4
	/// Extra info in the picking prompt
	var/addendum = ""
	/// Flavor of the sender of the package
	var/sender = "资助人"

	/// Amount of loot to pick from 'loot'
	var/loot_choice = 1
	/// Amount of random loot to get from unpicked `loot`
	var/random_loot = 0
	/// Extra loot always awarded
	var/list/extra_loot
	/// Table of /datum/carebox_loot to pick from
	var/list/loot

/datum/carebox_table/wretch
	addendum = "\n所有包裹都含有 1 瓶治疗药水。\n你还会额外获得 1 个随机选项。"
	cycles = 4
	random_loot = 1
	extra_loot = list(
		/datum/carebox_loot/wretch/potion,
	)
	loot = list(
		/datum/carebox_loot/wretch/steel_mask,
		/datum/carebox_loot/wretch/steel_ingot,
		/datum/carebox_loot/wretch/iron_ingot,
		/datum/carebox_loot/wretch/gambeson,
		/datum/carebox_loot/wretch/leather_clothes,
		/datum/carebox_loot/wretch/leather_armor,
		/datum/carebox_loot/wretch/stampot,
		/datum/carebox_loot/wretch/manapot,
		/datum/carebox_loot/wretch/raisin_loaf,
		/datum/carebox_loot/wretch/quiver,
		/datum/carebox_loot/wretch/throwing_knifes,
		/datum/carebox_loot/wretch/pouch_coins_mid,
		/datum/carebox_loot/wretch/chain_rope,
		/datum/carebox_loot/wretch/lantern_bedroll,
		/datum/carebox_loot/wretch/pouch_medicine,
		/datum/carebox_loot/wretch/bottle_bomb,
		/datum/carebox_loot/wretch/zizite_cross,
	)
