// This is just a bit of fun while making an example for global signal
/datum/component/edit_complainer
	var/list/say_lines

/datum/component/edit_complainer/Initialize(list/text)
	if(!ismovableatom(parent))
		return COMPONENT_INCOMPATIBLE

	var/static/list/default_lines = list(
		"CentCom 的挥霍又扯断了一缕丝线。",
		"织网又被牵动了一下。",
		"谁知道这些重压何时才会终于击碎形体？",
		"即便此刻，也仍有微光透过裂隙。",
		"CentCom 又一次僭越权柄，扭曲了知识。",
		"mansus 之中弥漫着一股不安的气息。",
		)
	say_lines = text || default_lines

	RegisterSignal(SSdcs, COMSIG_GLOB_VAR_EDIT, PROC_REF(var_edit_react))

/datum/component/edit_complainer/proc/var_edit_react(datum/source, list/arguments)
	var/atom/movable/master = parent
	master.say(pick(say_lines))
