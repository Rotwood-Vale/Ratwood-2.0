/datum/objective/bandit
	name = "匪徒"
	explanation_text = "向神像献上财物。"

/datum/objective/bandit/check_completion()
	if(SSmapping.retainer.bandit_contribute >= SSmapping.retainer.bandit_goal)
		return TRUE

/datum/objective/bandit/update_explanation_text()
	..()
	explanation_text = "向贪婪神像献上 [SSmapping.retainer.bandit_goal] 枚玛门币。"


/datum/objective/delf
	name = "德尔芙"
	explanation_text = "向母亲献上蜂蜜。"

/datum/objective/delf/check_completion()
	if(SSmapping.retainer.delf_contribute >= SSmapping.retainer.delf_goal)
		return TRUE

/datum/objective/delf/update_explanation_text()
	..()
	explanation_text = "向母亲献上 [SSmapping.retainer.delf_goal] 份蜂蜜。"

/datum/objective/werewolf
	name = "征服"
	explanation_text = "你已被荒野的疯神登多尔所触碰, 也许源于一记咬伤……又或是一份可怖的赐福。而你现在饿得发狂, 饿得无以复加。登多尔许诺的形态将无比可怖, 但蜕变的过程也将痛苦万分。莫惧满月, 让盛宴开始吧。"
	team_explanation_text = "狼化症是一种可怖的疾病, 零散记载可追溯数百年前。究竟是何等疯狂驱使登多尔造出这般畸变, 凡人根本无从理解; 而无论缘由为何, 他都既不愿也无法将其收回。每夜的变身与暴涨的体型, 会让躯体陷入永不满足的饥饿之中, 驱使宿主做出野兽般的狂暴行径。"
	triumph_count = 5

/datum/objective/werewolf/check_completion()
	if(vampire_werewolf() == "werewolf")
		return TRUE

/datum/objective/vampire
	name = "征服"
	explanation_text = "终结狼人带来的威胁, 或与他们联手对抗十神的势力。"
	team_explanation_text = "狼人和吸血鬼之间的宿怨可追溯到远古之初。两方究竟会彼此毁灭, 还是找到共存之道, 一同面对这片土地上的凡人？"
	triumph_count = 5

/datum/objective/vampire/check_completion()
	if(vampire_werewolf() == "vampire")
		return TRUE
