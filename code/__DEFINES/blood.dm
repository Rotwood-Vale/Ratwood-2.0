// Blood tints. Sprites are greyscaled from the red channel, then multiplied by one of these.

// Vertebrate blood. Used when a species does not set its own color.
#define BLOOD_COLOR_DEFAULT			"#C80000"
// Dried vertebrate blood. Hemoglobin oxidizes to brown.
#define BLOOD_COLOR_DRIED			"#967c69"

// Fluvian blood. Also arachnids, spider wildshapes, mire crawlers, and mire lurkers.
#define BLOOD_COLOR_BLUE			"#2A9BB8"
// Dried Fluvian blood. Hemocyanin dulls to a gray-blue slate.
#define BLOOD_COLOR_BLUE_DRIED		"#6C8E9D"

GLOBAL_LIST_INIT(drakian_blood_colors, list(
	"red" = list("name" = "Rontz", "color" = "#E00000", "dried" = "#BF7A72"),
	"blue" = list("name" = "Saffira", "color" = "#0025E0", "dried" = "#7277BF"),
	"green" = list("name" = "Gemerald", "color" = "#00E02D", "dried" = "#72BF89"),
	"gold" = list("name" = "Toper", "color" = "#E0A400", "dried" = "#BFB272"),
	"purple" = list("name" = "Amythortz", "color" = "#6C0861", "dried" = "#5C3A55"),
))

/proc/get_dried_blood_color(blood_color)
	if(blood_color == BLOOD_COLOR_BLUE)
		return BLOOD_COLOR_BLUE_DRIED
	for(var/hue in GLOB.drakian_blood_colors)
		var/list/pair = GLOB.drakian_blood_colors[hue]
		if(pair["color"] == blood_color)
			return pair["dried"]
	return BLOOD_COLOR_DRIED
