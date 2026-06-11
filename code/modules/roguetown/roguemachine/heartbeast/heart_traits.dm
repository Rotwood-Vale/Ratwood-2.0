/datum/flesh_trait
	var/name = "基础特性"
	var/description = "一种基础性格特质"
	var/list/conflicting_traits = list() // Types of traits that can't coexist
	var/list/liked_concepts = list() // Topics this trait enjoys
	var/list/preferred_approaches = list()
	var/color = "#ffffff"
	var/required_item
	var/calibration_required = 5

/datum/flesh_trait/deception
	name = "欺诈"
	description = "偏爱谎言、诡计与隐藏含义"
	conflicting_traits = list(/datum/flesh_trait/honest)
	preferred_approaches = list("min_words" = 3, "max_words" = 15, "punctuation" = "?")
	liked_concepts = list(/datum/flesh_concept/lies, /datum/flesh_concept/power, /datum/flesh_concept/fear)
	color = "#8a2be2"
	required_item = /obj/item/alch/artemisia

/datum/flesh_trait/violent
	name = "暴烈" 
	description = "沉溺于攻击、痛苦与毁灭"
	conflicting_traits = list(/datum/flesh_trait/peaceful)
	preferred_approaches = list("min_words" = 1, "max_words" = 8, "punctuation" = "!")
	liked_concepts = list(/datum/flesh_concept/pain, /datum/flesh_concept/blood, /datum/flesh_concept/destruction, /datum/flesh_concept/fear, /datum/flesh_concept/power)
	color = "#dc143c"
	required_item = /obj/item/alch/atropa

/datum/flesh_trait/cautious
	name = "谨慎"
	description = "犹疑不决，厌恶风险"
	conflicting_traits = list(/datum/flesh_trait/impulsive, /datum/flesh_trait/destructive, /datum/flesh_trait/curious)
	preferred_approaches = list("min_words" = 5, "max_words" = 20, "punctuation" = ".")
	liked_concepts = list(/datum/flesh_concept/fear, /datum/flesh_concept/order, /datum/flesh_concept/cowardice)
	color = "#4682b4"
	required_item = /obj/item/alch/valeriana

/datum/flesh_trait/observant
	name = "敏察" 
	description = "善于发现细节与规律"
	conflicting_traits = list(/datum/flesh_trait/impulsive)
	preferred_approaches = list("min_words" = 8, "max_words" = 25, "punctuation" = ".")
	liked_concepts = list(/datum/flesh_concept/memory, /datum/flesh_concept/truth, /datum/flesh_concept/wisdom, /datum/flesh_concept/creation)
	color = "#2e8b57"
	required_item = /obj/item/alch/euphrasia

/datum/flesh_trait/peaceful
	name = "平和"
	description = "偏好和谐与非暴力"
	conflicting_traits = list(/datum/flesh_trait/violent, /datum/flesh_trait/destructive)
	preferred_approaches = list("min_words" = 4, "max_words" = 18, "punctuation" = ".")
	liked_concepts = list(/datum/flesh_concept/mercy, /datum/flesh_concept/love, /datum/flesh_concept/unity, /datum/flesh_concept/creation)
	color = "#90ee90"
	required_item = /obj/item/alch/calendula

/datum/flesh_trait/creative
	name = "富于创造"
	description = "充满想象力且独具新意"
	conflicting_traits = list(/datum/flesh_trait/logical, /datum/flesh_trait/orderly, /datum/flesh_trait/destructive)
	preferred_approaches = list("min_words" = 6, "max_words" = 30, "punctuation" = "?")
	liked_concepts = list(/datum/flesh_concept/creation, /datum/flesh_concept/dreams, /datum/flesh_concept/beauty, /datum/flesh_concept/transformation, /datum/flesh_concept/love)
	color = "#ff69b4"
	required_item = /obj/item/alch/manabloompowder

/datum/flesh_trait/curious
	name = "好奇"
	description = "渴望学习与探索"
	conflicting_traits = list(/datum/flesh_trait/cautious)
	preferred_approaches = list("min_words" = 3, "max_words" = 25, "punctuation" = "?")
	liked_concepts = list(/datum/flesh_concept/truth, /datum/flesh_concept/wisdom, /datum/flesh_concept/memory)
	color = "#ffd700"
	required_item = /obj/item/alch/mentha

/datum/flesh_trait/ambitious
	name = "雄心勃勃"
	description = "受目标与成就驱使"
	conflicting_traits = list(/datum/flesh_trait/peaceful)
	preferred_approaches = list("min_words" = 2, "max_words" = 12, "punctuation" = "!")
	liked_concepts = list(/datum/flesh_concept/power, /datum/flesh_concept/growth)
	color = "#b22222"
	required_item = /obj/item/alch/salvia

/datum/flesh_trait/logical
	name = "理性"
	description = "冷静而有条理"
	conflicting_traits = list(/datum/flesh_trait/chaotic, /datum/flesh_trait/creative)
	preferred_approaches = list("min_words" = 5, "max_words" = 20, "punctuation" = ".")
	liked_concepts = list(/datum/flesh_concept/truth, /datum/flesh_concept/order, /datum/flesh_concept/wisdom)
	color = "#4169e1"
	required_item = /obj/item/alch/hypericum

/datum/flesh_trait/honest
	name = "诚实"
	description = "重视真实与坦率"
	conflicting_traits = list(/datum/flesh_trait/deception)
	preferred_approaches = list("min_words" = 3, "max_words" = 15, "punctuation" = ".")
	liked_concepts = list(/datum/flesh_concept/truth, /datum/flesh_concept/justice)
	color = "#ffffff"
	required_item = /obj/item/alch/taraxacum

/datum/flesh_trait/orderly
	name = "守序"
	description = "偏好结构与秩序"
	conflicting_traits = list(/datum/flesh_trait/chaotic, /datum/flesh_trait/impulsive, /datum/flesh_trait/creative, /datum/flesh_trait/playful)
	preferred_approaches = list("min_words" = 4, "max_words" = 18, "punctuation" = ".")
	liked_concepts = list(/datum/flesh_concept/order)
	color = "#808080"
	required_item = /obj/item/alch/paris

/datum/flesh_trait/impulsive
	name = "冲动"
	description = "顺从一时欲望行事"
	conflicting_traits = list(/datum/flesh_trait/cautious, /datum/flesh_trait/orderly, /datum/flesh_trait/observant, /datum/flesh_trait/philosophical, /datum/flesh_trait/analytical)
	preferred_approaches = list("min_words" = 1, "max_words" = 6, "punctuation" = "!")
	liked_concepts = list(/datum/flesh_concept/freedom, /datum/flesh_concept/chaos)
	color = "#ff4500"
	required_item = /obj/item/alch/urtica

/datum/flesh_trait/territorial
	name = "护地"
	description = "强烈维护自己的地盘与财物"
	conflicting_traits = list()
	preferred_approaches = list("min_words" = 2, "max_words" = 10, "punctuation" = "!")
	liked_concepts = list(/datum/flesh_concept/power, /datum/flesh_concept/courage)
	color = "#8b0000"
	required_item = /obj/item/alch/matricaria

/datum/flesh_trait/dominant
	name = "支配欲强"
	description = "追求掌控与权威"
	conflicting_traits = list()
	preferred_approaches = list("min_words" = 2, "max_words" = 8, "punctuation" = "!")
	liked_concepts = list(/datum/flesh_concept/power, /datum/flesh_concept/greed)
	color = "#daa520"
	required_item = /obj/item/alch/rosa

/datum/flesh_trait/destructive
	name = "毁灭欲强"
	description = "享受破坏与败坏"
	conflicting_traits = list(/datum/flesh_trait/peaceful, /datum/flesh_trait/creative, /datum/flesh_trait/cautious)
	preferred_approaches = list("min_words" = 1, "max_words" = 8, "punctuation" = "!")
	liked_concepts = list(/datum/flesh_concept/destruction, /datum/flesh_concept/decay, /datum/flesh_concept/chaos, /datum/flesh_concept/pain)
	color = "#4b0082"
	required_item = /obj/item/alch/benedictus

/datum/flesh_trait/playful
	name = "顽皮"
	description = "贪玩而爱恶作剧"
	conflicting_traits = list(/datum/flesh_trait/orderly)
	preferred_approaches = list("min_words" = 3, "max_words" = 12, "punctuation" = "?")
	liked_concepts = list(/datum/flesh_concept/chaos, /datum/flesh_concept/companionship)
	color = "#ffa500"
	required_item = /obj/item/alch/symphitum

/datum/flesh_trait/chaotic
	name = "混沌"
	description = "拥抱随机与无序"
	conflicting_traits = list(/datum/flesh_trait/orderly, /datum/flesh_trait/logical)
	preferred_approaches = list("min_words" = 1, "max_words" = 15, "punctuation" = "?")
	liked_concepts = list(/datum/flesh_concept/chaos, /datum/flesh_concept/freedom, /datum/flesh_concept/transformation)
	color = "#9400d3"
	required_item = /obj/item/alch/artemisia

/datum/flesh_trait/philosophical
	name = "富于哲思"
	description = "沉思深奥问题"
	conflicting_traits = list(/datum/flesh_trait/impulsive)
	preferred_approaches = list("min_words" = 8, "max_words" = 30, "punctuation" = "?")
	liked_concepts = list(/datum/flesh_concept/wisdom)
	color = "#2f4f4f"
	required_item = /obj/item/alch/salvia

/datum/flesh_trait/analytical
	name = "善于分析"
	description = "习惯系统地拆解事物"
	conflicting_traits = list(/datum/flesh_trait/impulsive)
	preferred_approaches = list("min_words" = 6, "max_words" = 25, "punctuation" = ".")
	liked_concepts = list(/datum/flesh_concept/truth)
	color = "#483d8b"
	required_item = /obj/item/alch/euphrasia
