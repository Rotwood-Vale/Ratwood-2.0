GLOBAL_LIST_EMPTY(faithlist)

GLOBAL_LIST_EMPTY(preference_faiths)

/datum/faith
	/// Name of the faith
	var/name
	/// Description of the faith
	var/desc = "一个相信应当去 GitHub 报告这个问题的信仰 - 你本不该看到这段文字，说明有人忘了给这个信仰填写描述。"
	/// People most likely to practice this faith
	var/worshippers = "程序员"
	/// Our "primary" patron god
	var/datum/patron/godhead = /datum/patron
	/// Whether or not this faith can be accessed in preferences
	var/preference_accessible = TRUE
