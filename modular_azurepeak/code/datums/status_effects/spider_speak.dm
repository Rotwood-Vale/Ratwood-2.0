/atom/movable/screen/alert/status_effect/buff/spider_speak
	name = "蜘蛛语"
	desc = "我能像蜘蛛那样用舌头发出咔嗒声交流。"
	icon_state = "buff"

/datum/status_effect/buff/spider_speak
	id = "spider_speak"
	alert_type = /atom/movable/screen/alert/status_effect/buff/spider_speak
	duration = 2700 SECONDS
	examine_text = "SUBJECTPRONOUN偶尔会轻轻弹动舌头，发出咔嗒声"

/datum/status_effect/buff/spider_speak/on_apply()
	owner.faction += "spiders"
	return TRUE

/datum/status_effect/buff/spider_speak/on_remove()
	owner.faction -= "spiders"
	return TRUE
