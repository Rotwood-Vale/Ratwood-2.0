/datum/mob_descriptor/voice
	abstract_type = /datum/mob_descriptor/voice
	slot = MOB_DESCRIPTOR_SLOT_VOICE
	verbage = "%SPEAK%"
	prefix = ""
	suffix = "嗓音"
	show_obscured = TRUE
	var/voice_string

/datum/mob_descriptor/voice/proc/get_speaking_name(voice_gender)
	return "[voice_string ? voice_string : name] [voice_gender]"

/datum/mob_descriptor/voice/ordinary
	name = "普通"
	prefix = ""

/datum/mob_descriptor/voice/monotone
	name = "单调"

/datum/mob_descriptor/voice/deep
	name = "低沉"

/datum/mob_descriptor/voice/soft
	name = "轻柔"

/datum/mob_descriptor/voice/shrill
	name = "尖利"

/datum/mob_descriptor/voice/sleepy
	name = "慵懒"

/datum/mob_descriptor/voice/commanding
	name = "威严"

/datum/mob_descriptor/voice/kind
	name = "和善"

/datum/mob_descriptor/voice/growly
	name = "低吼般"

/datum/mob_descriptor/voice/androgynous
	name = "中性"
	prefix = ""

/datum/mob_descriptor/voice/nasal
	name = "鼻音很重"

/datum/mob_descriptor/voice/refined
	name = "文雅"

/datum/mob_descriptor/voice/cheery
	name = "欢快"

/datum/mob_descriptor/voice/dispassionate
	name = "冷漠"

/datum/mob_descriptor/voice/gravelly
	name = "沙哑"

/datum/mob_descriptor/voice/whiny
	name = "带着哭腔"

/datum/mob_descriptor/voice/melodic
	name = "悦耳"

/datum/mob_descriptor/voice/drawling
	name = "拖长音调"

/datum/mob_descriptor/voice/stilted
	name = "生硬"

/datum/mob_descriptor/voice/grave
	name = "庄重"

/datum/mob_descriptor/voice/doting
	name = "宠溺"

/datum/mob_descriptor/voice/booming
	name = "洪亮"

/datum/mob_descriptor/voice/lisping
	name = "口齿含混"

/datum/mob_descriptor/voice/honeyed
	name = "甜腻"

/datum/mob_descriptor/voice/facetious
	name = "轻佻"

/datum/mob_descriptor/voice/snide
	name = "讥讽"

/datum/mob_descriptor/voice/smoker
	name = "烟嗓"
	voice_string = "烟嗓"

/datum/mob_descriptor/voice/venomous
	name = "恶毒"
