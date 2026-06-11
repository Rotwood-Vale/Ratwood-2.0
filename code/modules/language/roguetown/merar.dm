/datum/language/merar
	name = "梅拉尔语"
	desc = "(用 ,f 说)祖先曾踏过的沙海回响在这门沙哑的语言之中。它多由咕噜声与短促喵鸣组成，若说话者情绪激动，偶尔也会夹杂嘶声或喵叫。它源自沙漠部族与由迅捷塔巴西统治的诸王国，语调锋利而直接。若你耳力敏锐，还能从中听出些许吉赞的影响。"
	speech_verb = "咕噜"
	ask_verb = "喵噜着问"
	exclaim_verb = "嘶声喝道"
	key = "f"
	flags = LANGUAGE_HIDE_ICON_IF_UNDERSTOOD | LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD
	space_chance = 80
	default_priority = 90
	icon_state = "beastial"
	spans = list(SPAN_MERAR)
	syllables = list(
	    "za","az","ze","ez","zi","iz","zo","oz","zu","uz","zs","sz","ha","ah","he","eh","hi","ih",
	    "ho","oh","hu","uh","hs","sh","la","al","le","el","li","il","lo","ol","lu","ul","ls","sl","ka","ak","ke","ek",
	    "ki","ik","ko","ok","ku","uk","ks","sk","sa","as","se","es","si","is","so","os","su","us","ss","ss","ra","ar",
	    "re","er","ri","ir","ro","or","ru","ur","rs","sr","a","a","e","e","i","i","o","o","u","u","s","s" 
	)
