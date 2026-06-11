////////////////ENCHANTING RITUALS///////////////////
/datum/runeritual/enchanting
	name = "附魔"
	desc = "附魔系上位仪式。"
	category = "附魔"
	abstract_type = /datum/runeritual/enchanting
	blacklisted = TRUE

/datum/runeritual/enchanting/woodcut
	name = "伐木"
	desc = "适合砍木头。"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1, /obj/item/magic/manacrystal = 1)
	result_atoms = list(/obj/item/enchantmentscroll/woodcut)

/datum/runeritual/enchanting/mining
	name = "采矿"
	desc = "适合开采岩石。"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1, /obj/item/magic/artifact = 1)
	result_atoms = list(/obj/item/enchantmentscroll/mining)

/datum/runeritual/enchanting/xylix
	name = "赛利克斯的恩典"
	desc = "何其幸运！"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1, /obj/item/magic/leyline = 1)
	result_atoms = list(/obj/item/enchantmentscroll/xylix)

/datum/runeritual/enchanting/light
	name = "不屈之光"
	desc = "提供光亮！"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/mote = 2)
	result_atoms = list(/obj/item/enchantmentscroll/light)

/datum/runeritual/enchanting/holding
	name = "紧凑储存"
	desc = "让东西装得更多！"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/ash = 2, /obj/item/magic/fae/dust = 2)
	result_atoms = list(/obj/item/enchantmentscroll/holding)

/datum/runeritual/enchanting/revealing
	name = "揭示之光"
	desc = "亮度翻倍！"
	blacklisted = FALSE
	tier = 1
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1, /obj/item/magic/fae/dust = 2)
	result_atoms = list(/obj/item/enchantmentscroll/revealing)

//T2 Below here


/datum/runeritual/enchanting/nightvision
	name = "黑暗视觉"
	desc = "提供黑暗视野！"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/fae/scale = 1, /obj/item/magic/manacrystal = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/nightvision)

/datum/runeritual/enchanting/unbreaking
	name = "坚不可摧"
	desc = "提升额外耐久！"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/artifact = 1, /obj/item/magic/elemental/shard = 1, /obj/item/magic/manacrystal = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/unbreaking)

/datum/runeritual/enchanting/featherstep
	name = "羽步"
	desc = "让你的步伐更轻、更快！"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/fae/scale = 1, /obj/item/magic/fae/dust = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/featherstep)

/datum/runeritual/enchanting/fireresist
	name = "抗火"
	desc = "提供抗火能力！"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/fang = 1, /obj/item/magic/infernal/ash = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/fireresist)

/datum/runeritual/enchanting/climbing
	name = "蛛行"
	desc = "让攀爬更轻松！"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/shard = 1, /obj/item/magic/infernal/ash = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/climbing)

/datum/runeritual/enchanting/thievery
	name = "盗窃巧手"
	desc = "更擅长扒窃与开锁！"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/fang = 1, /obj/item/magic/obsidian = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/thievery)

/datum/runeritual/enchanting/trekk
	name = "长步"
	desc = "让你更容易穿行于恶劣地形。"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/shard = 1, /obj/item/magic/artifact = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/trekk)

/datum/runeritual/enchanting/smithing
	name = "锻造"
	desc = "让锻造更得心应手。"
	blacklisted = FALSE
	tier = 2
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/shard = 1, /obj/item/magic/elemental/mote = 1, /obj/item/magic/melded/t1 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/smithing)

//T3 below here

/datum/runeritual/enchanting/lifesteal
	name = "生命窃取"
	desc = "从敌人身上吸取生命。"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/fae/core = 1, /obj/item/magic/infernal/fang = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/lifesteal)

/datum/runeritual/enchanting/lightning
	name = "雷击"
	desc = "电击敌人。"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/core = 1, /obj/item/magic/leyline = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/lightning)

/datum/runeritual/enchanting/voidtouched
	name = "虚空之触"
	desc = "将目标短暂传送到附近。"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1, /obj/item/magic/fae/core = 1, /obj/item/magic/voidstone = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/voidtouched)

/datum/runeritual/enchanting/frostveil	//armor enchantment
	name = "霜幕"
	desc = "让敌人受寒。"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/fragment = 1, /obj/item/magic/elemental/shard = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/frostveil)

/datum/runeritual/enchanting/phoenixguard	//armor enchantment
	name = "凤凰守护"
	desc = "让敌人燃烧起来。"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/core = 1, /obj/item/magic/infernal/fang = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/phoenixguard)

/datum/runeritual/enchanting/returningweapon
	name = "归返武器"
	desc = "召回武器。"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/fragment = 1, /obj/item/magic/fae/dust = 2, /obj/item/magic/elemental/mote = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/returningweapon)

/datum/runeritual/enchanting/woundclosing
	name = "闭合伤口"
	desc = "闭合伤口。"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/fae/core = 1, /obj/item/magic/fae/scale = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/woundclosing)

/datum/runeritual/enchanting/archery
	name = "箭术"
	desc = "提升弓术。"
	blacklisted = FALSE
	tier = 3
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/fang = 2, /obj/item/magic/leyline = 2, /obj/item/magic/melded/t2 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/archery)


//T4 Below here


/datum/runeritual/enchanting/briars
	name = "荆棘诅咒"
	desc = "让武器打得更狠，但要付出代价。"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/fae/essence = 1, /obj/item/magic/fae/core = 2, /obj/item/magic/melded/t3 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/briars)

/datum/runeritual/enchanting/infernalflame	//weapon enchantment
	name = "炼狱之焰"
	desc = "让敌人着火。"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/infernal/flame = 1, /obj/item/magic/obsidian = 4, /obj/item/magic/melded/t3 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/infernalflame)


/datum/runeritual/enchanting/freeze	//weapon enchantment
	name = "冻结"
	desc = "把敌人冻进冰块里。"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/fae/essence = 1, /obj/item/magic/infernal/core = 2, /obj/item/magic/melded/t3 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/freeze)


/datum/runeritual/enchanting/rewind
	name = "时序回溯"
	desc = "倒转时间。"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/elemental/relic = 1, /obj/item/magic/fae/core = 2,  /obj/item/magic/melded/t3 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/rewind)

/datum/runeritual/enchanting/chaosstorm
	name = "混沌风暴"
	desc = "引发随机的强大效果。"
	blacklisted = FALSE
	tier = 4
	required_atoms = list(/obj/item/rogueore/cinnabar = 1,/obj/item/paper/scroll = 1,/obj/item/magic/obsidian = 1, /obj/item/magic/manacrystal = 1,  /obj/item/magic/melded/t4 = 1)
	result_atoms = list(/obj/item/enchantmentscroll/chaos_storm)
