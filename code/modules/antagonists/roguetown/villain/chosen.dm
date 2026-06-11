/datum/antagonist/chosen
	name = "天选者" // special role that basically just exists to give
	job_rank = ROLE_CHOSEN // storytellers the ability to add objectives to whoever. this is probably
	show_in_roundend = FALSE // terrible because i dont know what the fuck i'm doing beyond  guessing and reading code.
	increase_votepwr = FALSE // like this, what does this do?
	rogue_enabled = TRUE // or this? I DONT KNOW BECAUSE THERES NO DOCUMENTATION
	antagpanel_category = "自定义叙事者" // hopefully gets the point across
	antag_flags = FLAG_FAKE_ANTAG
	confess_lines = list(
		"我的目标超乎你的理解！",
	)
/datum/antagonist/chosen/on_gain()
	greet()
	return ..()

/datum/antagonist/chosen/on_removal()
	to_chat(owner.current, span_userdanger("我对那些任务的记忆正在消散。我刚才到底在做什么来着……？"))
	return ..()

/datum/antagonist/chosen/greet()
	to_chat(owner.current,span_userdanger("我被某个外在存在，或是我脑海中的那颗肿瘤选中去完成任务……我必须活下去，才能接收进一步的指示。"))
	owner.announce_objectives()
	return ..()
