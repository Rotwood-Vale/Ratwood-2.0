/datum/team/nation
	name = "国度"

/datum/antagonist/separatist
	name = "分离主义者"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	var/datum/team/nation/nation

/datum/antagonist/separatist/create_team(datum/team/nation/new_team)
	if(!new_team)
		return
	nation = new_team

/datum/antagonist/separatist/get_team()
	return nation

/datum/antagonist/separatist/greet()
	to_chat(owner, "<B>我是一名分离主义者！[nation.name] 万岁！和你的战友一起捍卫这片新生土地的主权！</B>")
