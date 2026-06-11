/datum/patron/godless
	name = "科学"
	domain = "本体真实"
	desc = "不要神，也不要王，只有人！神虽然存在，但你对他们嗤之以鼻。"
	worshippers = "疯子、野兽与部分矮人"
	virtues = "独立、理性、批判性思维"
	sins = "信仰、迷信、依赖"
	associated_faith = /datum/faith/godless
	preference_accessible = FALSE
	undead_hater = FALSE
	confess_lines = list(
		"神明毫无价值！",
		"我不需要神！",
		"我自己就是我的神！",
		"不要神，也不要主宰！",
	)

/datum/patron/godless/can_pray(mob/living/follower)
	. = ..()
	to_chat(follower, span_danger("Zarlz Zarwin 与 psyvolution 听不见我的祈祷！"))
	return FALSE	//heathen

/datum/patron/godless/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("没有任何特别的缘由，[target]却痊愈了！")
	*message_self = span_notice("我的伤口毫无缘由地愈合了。")
