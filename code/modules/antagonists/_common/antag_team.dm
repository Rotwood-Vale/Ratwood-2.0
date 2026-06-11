GLOBAL_LIST_EMPTY(antagonist_teams)

//A barebones antagonist team.
/datum/team
	var/list/datum/mind/members = list()
	var/name = "队伍"
	var/member_name = "成员"
	var/list/objectives = list() //common objectives, these won't be added or removed automatically, subtypes handle this, this is here for bookkeeping purposes.
	var/show_roundend_report = TRUE

/datum/team/New(starting_members)
	. = ..()
	GLOB.antagonist_teams += src
	if(starting_members)
		if(islist(starting_members))
			for(var/datum/mind/M in starting_members)
				add_member(M)
		else
			add_member(starting_members)

/datum/team/Destroy(force, ...)
	GLOB.antagonist_teams -= src
	. = ..()

/datum/team/proc/is_solo()
	return members.len == 1

/datum/team/proc/add_member(datum/mind/new_member)
	members |= new_member

/datum/team/proc/remove_member(datum/mind/member)
	members -= member

//Display members/victory/failure/objectives for the team
/datum/team/proc/roundend_report()
	if(!show_roundend_report)
		return

	var/list/report = list()

	report += span_header("[name]:")
	report += "以下是[member_name]："
	report += printplayerlist(members)

	if(objectives.len)
		report += span_header("团队目标如下：")
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				report += "<B>目标 #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>成功！</span>"
			else
				report += "<B>目标 #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>失败。</span>"
				win = FALSE
			objective_count++
		if(win)
			report += span_greentext("[name]成功了！")
		else
			report += span_redtext("[name]失败了！")
		report += "<br>"


	return "<div class='panel redborder'>[report.Join("<br>")]</div>"
