GLOBAL_LIST_INIT(character_accents, list("无口音",
	"矮人口音",
	"矮人呓语口音",
	"黑暗精灵口音",
	"精灵口音",
	"格伦泽尔霍夫特口音",
	"北伊特鲁斯卡口音",
	"铁锤堡口音",
	"亚斯玛尔口音",
	"蜥蜴人口音",
	"卢皮安口音",
	"提夫林口音",
	"半兽人口音",
	"城镇兽人口音",
	"嘶声口音",
	"Inzectoid口音",
	"猫科口音",
	"Slopes口音",
	"索特·阿尔-阿塔什口音",
	"贵族口音",
	"山谷口音",
	"风郡口音",
	"信义口音",
	"普伊-梅恩口音",
	"阿瓦尔口音",
	"海盗口音",
	"下城区口音"))

// Global mapping of accent names to their font span lists
GLOBAL_LIST_INIT(accent_spans, list(
	"索特·阿尔-阿塔什口音" = list(SPAN_ELF, SPAN_SANDWAUK),
	"风郡口音" = list(SPAN_KAZENACCENT),
	"贵族口音" = list(SPAN_POSH)
	//Add font-based accents here as needed
))

/mob/living/carbon/human
	var/char_accent = "无口音"
