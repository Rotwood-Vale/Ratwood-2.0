/// Divine pantheon storytellers
#define DIVINE_STORYTELLERS list( \
	/datum/storyteller/astrata, \
	/datum/storyteller/noc, \
	/datum/storyteller/ravox, \
	/datum/storyteller/abyssor, \
	/datum/storyteller/xylix, \
	/datum/storyteller/necra, \
	/datum/storyteller/pestra, \
	/datum/storyteller/malum, \
	/datum/storyteller/eora, \
	/datum/storyteller/dendor, \
	/datum/storyteller/psydon, \
)

//Yeah-yeah, he's not the same pantheon but suck it up, buttercup. We not makin' more defines.

/// Inhumen pantheon storytellers
#define INHUMEN_STORYTELLERS list( \
	/datum/storyteller/zizo, \
	/datum/storyteller/baotha, \
	/datum/storyteller/graggar, \
	/datum/storyteller/matthios, \
)

/// All storytellers
#define STORYTELLERS_ALL (DIVINE_STORYTELLERS + INHUMEN_STORYTELLERS)

/datum/storyteller/psydon
	name = "Psydon"
	vote_desc = "和平主宰一切。不会有恶人现身。祂的子民终于得以安歇，因为他们已赢得片刻喘息。"
	desc = "Psydon 几乎不会干预世事，事件会较为常见，因为祂对世界采取放任态度。可将其视为一种“延展版”体验。"
	welcome_text = "一阵温和的微风吹过寂静的街道……"
	weight = 6
	always_votable = TRUE
	color_theme = "#80ced8"
	preferred_gnoll_mode = GNOLL_SCALING_NONE

	//Has no influence, your actions will not impact him his spawn rates. Cus he's asleep.
	//Tl;dr - higher event spawn rates to keep stuff interesting, no god intervention, no antags. (Raids and omens will still happen at normal rate.)
	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.2,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_INTERVENTION = 0,			//No god intervention, cus he's asleep.
		EVENT_TRACK_CHARACTER_INJECTION = 0,	//No antagonist spawns.
	)

/datum/storyteller/astrata
	name = "Astrata"
	vote_desc = "秩序主宰一切。所有事件都被完美平衡，不偏不倚。她的恩泽照耀着贵族与他们的法令。"
	desc = "Astrata 会带来均衡而多样的体验。可将其视作默认体验。"
	welcome_text = "日光的暖意将我从沉眠中唤醒……"
	weight = 6
	always_votable = TRUE
	follower_modifier = LOWER_FOLLOWER_MODIFIER
	color_theme = "#FFD700"
	preferred_gnoll_mode = GNOLL_SCALING_DOUBLE

	influence_sets = list(
	"Set 1" = list(
		STATS_LAWS_AND_DECREES_MADE = list("name" = "颁布的法律与法令：", "points" = 2.75, "capacity" = 45),
	),
	"Set 2" = list(
		STATS_ALIVE_NOBLES = list("name" = "贵族人数：", "points" = 2.5, "capacity" = 60),
	),
	"Set 3" = list(
		STATS_NOBLE_DEATHS = list("name" = "贵族死亡数：", "points" = -3.75, "capacity" = -60),
		STATS_PEOPLE_SMITTEN = list("name" = "遭神罚者：", "points" = 4, "capacity" = 40),
	),
	"Set 4" = list(
		STATS_ASTRATA_REVIVALS = list("name" = "神圣复苏次数：", "points" = 6, "capacity" = 75),
		STATS_PRAYERS_MADE = list("name" = "祈祷次数：", "points" = 2.25, "capacity" = 65),
	),
	"Set 5" = list(
		STATS_TAXES_COLLECTED = list("name" = "征收的税款：", "points" = 0.2, "capacity" = 80),
	))

/datum/storyteller/noc
	name = "Noc"
	vote_desc = "知识主宰一切。事件整体平稳，却仍可能受 arcyne 干预。祂的恩泽照耀着追逐更高理想之人。"
	desc = "Noc 会尝试带来更多魔法相关事件。"
	welcome_text = "空气中噼啪作响，弥漫着 arcyne 能量……"
	weight = 4
	always_votable = TRUE
	color_theme = "#F0F0F0"
	preferred_gnoll_mode = GNOLL_SCALING_DOUBLE

	tag_multipliers = list(
		TAG_MAGICAL = 1.2,
		TAG_HAUNTED = 1.1,
	)
	cost_variance = 25

	influence_sets = list(
		"Set 1" = list(
			STATS_BOOKS_PRINTED = list("name" = "印制的书籍：", "points" = 2, "capacity" = 40),
		),
		"Set 2" = list(
			STATS_LITERACY_TAUGHT = list("name" = "传授的识字教育：", "points" = 20, "capacity" = 140),
		),
		"Set 3" = list(
			STATS_BOOKS_BURNED = list("name" = "焚毁的书籍：", "points" = -2, "capacity" = -50),
		),
		"Set 4" = list(
			STATS_SKILLS_DREAMED = list("name" = "梦中习得的技能：", "points" = 0.325, "capacity" = 100),
		),
	)

/datum/storyteller/ravox
	name = "Ravox"
	vote_desc = "荣耀主宰一切。袭击、恶人和凶兆更容易降临。祂的恩泽照耀着钢铁交击与战争呐喊。"
	desc = "Ravox 会让袭击自然发生，而不只是在大量人员死亡时才出现。"
	welcome_text = "“Zericho 的号角正在远方回响……”"
	weight = 4
	always_votable = TRUE
	color_theme = "#228822"
	preferred_gnoll_mode = GNOLL_SCALING_DOUBLE

	tag_multipliers = list(
		TAG_RAID = 1.3,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 0.75,
		EVENT_TRACK_PERSONAL = 0.9,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 1,	//Gaurenteed antagonist spawn
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 2,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_COMBAT_SKILLS = list("name" = "习得的战斗技能：", "points" = 1.065, "capacity" = 90),
		),
		"Set 2" = list(
			STATS_PARRIES = list("name" = "成功招架次数：", "points" = 0.052, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_WARCRIES = list("name" = "战吼次数：", "points" = 0.35, "capacity" = 50),
		),
		"Set 4" = list(
			STATS_YIELDS = list("name" = "投降次数：", "points" = -4.25, "capacity" = -40),
		),
	)

/datum/storyteller/abyssor
	name = "Abyssor"
	vote_desc = "流水主宰一切。事件整体平稳，却常随潮汐起伏而变化。祂的恩泽照耀着捕鱼者、吸蛭者与溺亡者。"
	desc = "Abyssor 喜欢降下与水和贸易相关的事件。"
	welcome_text = "天际逐渐昏暗，乌云为将至的风暴汇聚……"
	weight = 4
	always_votable = TRUE
	color_theme = "#3366CC"
	preferred_gnoll_mode = GNOLL_SCALING_DOUBLE

	tag_multipliers = list(
		TAG_WATER = 1.3,
		TAG_TRADE = 1.2,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_FISH_CAUGHT = list("name" = "捕获的鱼：", "points" = 1.75, "capacity" = 85),
		),
		"Set 2" = list(
			STATS_WATER_CONSUMED = list("name" = "饮用的水量：", "points" = 0.014, "capacity" = 90),
		),
		"Set 3" = list(
			STATS_ABYSSOR_REMEMBERED = list("name" = "铭记 Abyssor 次数：", "points" = 1.1, "capacity" = 50),
			STATS_ALIVE_AXIAN = list("name" = "axian 人数：", "points" = 8, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_LEECHES_EMBEDDED = list("name" = "附着的水蛭：", "points" = 0.75, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_PEOPLE_DROWNED = list("name" = "溺亡人数：", "points" = 12, "capacity" = 75),
			STATS_BATHS_TAKEN = list("name" = "沐浴次数：", "points" = 4.5, "capacity" = 60),
		)
	)

/datum/storyteller/xylix
	name = "Xylix"
	vote_desc = "无常主宰一切。没有什么注定不变，但一切皆有可能。祂的恩泽照耀着机缘与奇想之举。"
	desc = "Xylix 是不可预测的变数，拨动着命运之轮。"
	welcome_text = "“……好吧，这就是香料和美酒过量后的下场！”"
	weight = 4
	always_votable = TRUE
	event_repetition_multiplier = 0
	forced = TRUE
	color_theme = "#AA8888"
	preferred_gnoll_mode = GNOLL_SCALING_RANDOM

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1.75,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 0,
		EVENT_TRACK_RAIDS = 0,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_LAUGHS_MADE = list("name" = "欢笑次数：", "points" = 0.225, "capacity" = 85),
		),
		"Set 2" = list(
			STATS_PEOPLE_MOCKED = list("name" = "嘲弄他人次数：", "points" = 5, "capacity" = 60),
		),
		"Set 3" = list(
			STATS_CRITS_MADE = list("name" = "造成重创次数：", "points" = 0.26, "capacity" = 90),
		),
		"Set 4" = list(
			STATS_SONGS_PLAYED = list("name" = "演奏的歌曲：", "points" = 0.675, "capacity" = 70),
			STATS_MOAT_FALLERS = list("name" = "跌入护城河者：", "points" = 4, "capacity" = 50),
		)
	)

/datum/storyteller/necra
	name = "Necra"
	vote_desc = "死亡主宰一切。事件发生得更少，恶人也更难出现。她的恩泽照耀着将不死者重新送回坟墓之人。"
	desc = "Necra 的节奏极慢，极少带来新的来客。"
	welcome_text = "“在 Zenmarke 的封地中，弥漫着腐朽的气息……”"
	weight = 4
	always_votable = TRUE
	color_theme = "#888888"
	preferred_gnoll_mode = GNOLL_SCALING_DOUBLE

	tag_multipliers = list(
		TAG_HAUNTED = 1.3,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.25,
		EVENT_TRACK_PERSONAL = 0.7,
		EVENT_TRACK_MODERATE = 1.25,
		EVENT_TRACK_INTERVENTION = 1.25,
		EVENT_TRACK_CHARACTER_INJECTION = 0.5,	//High-chance antagonist spawn
		EVENT_TRACK_OMENS = 1.25,
		EVENT_TRACK_RAIDS = 0.5,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_DEATHS = list("name" = "死亡总数：", "points" = 1.35, "capacity" = 100),
		),
		"Set 2" = list(
			STATS_GRAVES_CONSECRATED = list("name" = "祝圣的坟墓：", "points" = 3.75, "capacity" = 80),
		),
		"Set 3" = list(
			STATS_GRAVES_ROBBED = list("name" = "被盗掘的坟墓：", "points" = -3.75, "capacity" = -40),
		),
		"Set 4" = list(
			STATS_DEADITES_KILLED = list("name" = "击杀的 deadite：", "points" = 6.25, "capacity" = 90),
		),
		"Set 5" = list(
			STATS_VAMPIRES_KILLED = list("name" = "击杀的吸血鬼：", "points" = 12.5, "capacity" = 70),
			STATS_SKELETONS_KILLED = list("name" = "击杀的骷髅：", "points" = 5, "capacity" = 50),
		)
	)

/datum/storyteller/pestra
	name = "Pestra"
	vote_desc = "安康主宰一切。事件整体平稳，却也会因熟练之手而偏转。她的恩泽照耀着缝合者与炼金术士。"
	desc = "Pestra 让一切保持简明，但会稍稍偏向炼金相关内容。"
	welcome_text = "器械碰撞作响，炼金奇迹在沸腾翻涌……"
	color_theme = "#AADDAA"
	preferred_gnoll_mode = GNOLL_SCALING_DOUBLE

	tag_multipliers = list(
		TAG_ALCHEMY = 1.2,
		TAG_MEDICAL = 1.2,
		TAG_NATURE = 1.1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_POTIONS_BREWED = list("name" = "酿制的药剂：", "points" = 5.25, "capacity" = 80),
		),
		"Set 2" = list(
			STATS_WOUNDS_SEWED = list("name" = "缝合的伤口：", "points" = 0.48, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_LUX_HARVESTED = list("name" = "提取的 Lux：", "points" = 8, "capacity" = 70),
			STATS_LUX_REVIVALS = list("name" = "Lux 复生次数：", "points" = 16, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_ROT_CURED = list("name" = "治愈的腐败：", "points" = 5, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_FOOD_ROTTED = list("name" = "腐坏的食物：", "points" = 0.26, "capacity" = 80),
		)
	)

/datum/storyteller/malum
	name = "Malum"
	vote_desc = "劳作主宰一切。神明干预会更常出现。祂的恩泽照耀着杰作与矿井。"
	desc = "Malum 崇尚辛勤劳动，因此比其他神更常出手干预。"
	welcome_text = "炽热钢铁被反复锻打，百双满是老茧的手正在辛劳……"
	color_theme = "#D4A56C"
	preferred_gnoll_mode = GNOLL_SCALING_DOUBLE

	tag_multipliers = list(
		TAG_WORK = 1.5,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.2,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,	//Gaurenteed antagonist spawn
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_MASTERWORKS_FORGED = list("name" = "锻造的杰作：", "points" = 7, "capacity" = 85),
		),
		"Set 2" = list(
			STATS_ROCKS_MINED = list("name" = "开采的岩石：", "points" = 0.26, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_CRAFT_SKILLS = list("name" = "习得的工艺技能：", "points" = 0.55, "capacity" = 90),
		),
		"Set 4" = list(
			STATS_BEARDS_SHAVED = list("name" = "剃掉的胡须：", "points" = -4, "capacity" = -40),
			STATS_ALIVE_DWARVES = list("name" = "矮人人数：", "points" = 4, "capacity" = 45),
		),
	)

/datum/storyteller/eora
	name = "Eora"
	vote_desc = " 爱意主宰一切。正面的际遇更常出现，而袭击鲜少发生。她的恩泽照耀着恋情。"
	desc = "Eora 憎恶死亡并鼓励爱意。袭击不会自然升级，只有死亡才会将其引来。"
	welcome_text = "“空气里弥漫着爱意？不，那是窗台上新鲜烤派的香气！”"
	color_theme = "#9966CC"
	preferred_gnoll_mode = GNOLL_SCALING_DOUBLE

	tag_multipliers = list(
		TAG_WIDESPREAD = 1.5,
		TAG_BOON = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.4,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,	//Gaurenteed antagonist spawn
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 0,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_KISSES_MADE = list("points" = 7, "capacity" = 70),
		),
		"Set 2" = list(
			STATS_PLEASURES = list("name" = "享乐次数：", "points" = 5, "capacity" = 50),
		),
		"Set 3" = list(
			STATS_HUGS_MADE = list("name" = "拥抱次数：", "points" = 2.5, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_CLINGY_PEOPLE = list("name" = "黏人者：", "points" = 6.5, "capacity" = 75),
		)
	)

/datum/storyteller/dendor
	name = "Dendor"
	vote_desc = " 自然主宰一切。过度生长与 Verevolves 更容易出现。祂的恩泽照耀着丰收与狼人。"
	desc = "Dendor 喜欢降下自然主题的事件。"
	welcome_text = "栖枝 zads 的咯咯怪笑，与晨露闪烁的微光……"
	weight = 4
	always_votable = TRUE
	color_theme = "#664422"
	preferred_gnoll_mode = GNOLL_SCALING_DOUBLE

	tag_multipliers = list(
		TAG_NATURE = 1.5,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 0.8,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,	//Gaurenteed antagonist spawn
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_TREES_CUT = list("name" = "砍倒的树木：", "points" = -0.35, "capacity" = -45),

		),
		"Set 2" = list(
			STATS_PLANTS_HARVESTED = list("name" = "收获的植物：", "points" = 0.75, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_FOREST_DEATHS = list("name" = "森林中的死亡：", "points" = 6, "capacity" = 90),
		),
		"Set 4" = list(
			STATS_WEREVOLVES = list("name" = "werevolves 数量：", "points" = 12.5, "capacity" = 65),
		),
	)

// INHUMEN

/datum/storyteller/zizo
	name = "Zizo"
	vote_desc = "混沌主宰一切。恶人必将现身，而 deadite 也会更加凶残。她的恩泽照耀着尸体，无论圣洁、尊贵，还是复苏之躯。"
	desc = "Zizo 以风险与回报为食，偏爱大胆而难测之人。"
	welcome_text = "一阵阴森的风拂过，携来受诅者的哀嚎……"
	weight = 4
	always_votable = TRUE
	color_theme = "#CC4444"
	preferred_gnoll_mode = GNOLL_SCALING_FLAT

	tag_multipliers = list(
		TAG_MAGICAL = 1.2,
		TAG_GAMBLE = 1.5,
		TAG_TRICKERY = 1.3,
		TAG_UNEXPECTED = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.2,
		EVENT_TRACK_MODERATE = 1.1,
		EVENT_TRACK_INTERVENTION = 1.5,
		EVENT_TRACK_CHARACTER_INJECTION = 1,	//Gaurenteed antagonist spawn
		EVENT_TRACK_OMENS = 1.3,
		EVENT_TRACK_RAIDS = 0.8,
	)

	cost_variance = 50  // Events will be highly variable in cost

	influence_sets = list(
		"Set 1" = list(
			STATS_NOBLE_DEATHS = list("name" = "死去的贵族：", "points" = 5.5, "capacity" = 80),
		),
		"Set 2" = list(
			STATS_DEADITES_WOKEN_UP = list("name" = "唤醒的 deadite：", "points" = 4, "capacity" = 85),
		),
		"Set 3" = list(
			STATS_CLERGY_DEATHS = list("name" = "死去的教士：", "points" = 12, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_TORTURES = list("name" = "施行的折磨：", "points" = 5.25, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_BOOKS_BURNED = list("name" = "焚毁的书籍：", "points" = -5, "capacity" = -50),
		),
	)

/datum/storyteller/baotha
	name = "Baotha"
	vote_desc = "香料主宰一切。事件会更加混乱且负面。她的恩泽照耀着醉鬼与瘾君子。"
	desc = "Baotha 沉迷混沌，使事件与现实都变得难以预测。"
	welcome_text = "空气中弥漫着甜得发腻的酒香与香料气息……"
	weight = 4
	always_votable = TRUE
	color_theme = "#9933FF"
	preferred_gnoll_mode = GNOLL_SCALING_RANDOM

	tag_multipliers = list(
		TAG_INSANITY = 1.4,
		TAG_MAGIC = 1.2,
		TAG_DISASTER = 1.1,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.1,
		EVENT_TRACK_PERSONAL = 1.2,
		EVENT_TRACK_MODERATE = 1.3,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 0.7,	//High chance antagonist spawn
		EVENT_TRACK_OMENS = 1.5,
		EVENT_TRACK_RAIDS = 1.2,
	)

	cost_variance = 30  // Makes events more erratic in timing

	influence_sets = list(
		"Set 1" = list(
			STATS_DRUGS_SNORTED = list("name" = "吸食的药物：", "points" = 4, "capacity" = 85),
		),
		"Set 2" = list(
			STATS_ALCOHOL_CONSUMED = list("name" = "饮下的酒精：", "points" = 0.042, "capacity" = 90),
		),
		"Set 3" = list(
			STATS_ALCOHOLICS = list("name" = "酒鬼人数：", "points" = 3.25, "capacity" = 60),
		),
		"Set 4" = list(
			STATS_JUNKIES = list("name" = "瘾君子人数：", "points" = 9, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_KNOTTED_NOT_LUPIANS = list("name" = "非 Lupian 的结缔次数：", "points" = 2.5, "capacity" = 50),
		),
		"Set 6" = list(
			STATS_IMPREGNATIONS = list("name" = "受孕次数：", "points" = 5, "capacity" = 50),
		),
	)

/datum/storyteller/graggar
	name = "Graggar"
	vote_desc = " Inhumenity 主宰一切。恶人必将现身，袭击也会更加频繁。祂的恩泽照耀着流血与食人。"
	desc = "Graggar 鼓励战争与征服，使战斗成为解决一切的手段。"
	welcome_text = "滚滚烟柱穿过街巷，散发着灰烬与鲜血的腥味……"
	weight = 4
	always_votable = TRUE
	color_theme = "#8B3A3A"
	preferred_gnoll_mode = GNOLL_SCALING_DYNAMIC

	tag_multipliers = list(
		TAG_BATTLE = 1.6,
		TAG_BLOOD = 1.3,
		TAG_WAR = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 0.8,
		EVENT_TRACK_PERSONAL = 0.7,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_INTERVENTION = 1.5,
		EVENT_TRACK_CHARACTER_INJECTION = 1,	//Gaurenteed antagonist spawn
		EVENT_TRACK_OMENS = 0.9,
		EVENT_TRACK_RAIDS = 2.5,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_BLOOD_SPILT = list("name" = "流下的鲜血：", "points" = 0.03, "capacity" = 60),
		),
		"Set 2" = list(
			STATS_ORGANS_EATEN = list("name" = "吞食的内脏：", "points" = 5, "capacity" = 70),
		),
		"Set 3" = list(
			STATS_DEATHS = list("name" = "死亡人数：", "points" = 5, "capacity" = 115),
			STATS_ASSASSINATIONS = list("name" = "成功刺杀次数：", "points" = 20, "capacity" = 100),
		),
		"Set 4" = list(
			STATS_PEOPLE_GIBBED = list("name" = "被碎尸者：", "points" = 3.5, "capacity" = 55),
		)
	)

	cost_variance = 10  // Less randomness, more direct

/datum/storyteller/matthios
	name = "Matthios"
	vote_desc = "盗窃主宰一切。匪盗横行无忌。祂的恩泽照耀着偷盗与献给某座神龛的供奉。"
	desc = "Matthios 操弄财富与腐化，奖赏那些愿意交易的人。"
	welcome_text = "钱币叮当作响，刚签好的悬赏文书上墨迹尚未滴干……"
	weight = 4
	always_votable = TRUE
	color_theme = "#8B4513"
	preferred_gnoll_mode = GNOLL_SCALING_RANDOM

	tag_multipliers = list(
		TAG_TRADE = 1.4,
		TAG_CORRUPTION = 1.3,
		TAG_LOOT = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.1,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_INTERVENTION = 1.3,
		EVENT_TRACK_CHARACTER_INJECTION = 1.5,	//Gaurenteed antagonist spawn
		EVENT_TRACK_OMENS = 1.1,
		EVENT_TRACK_RAIDS = 0.6,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_ITEMS_PICKPOCKETED = list("name" = "扒窃得手的物品：", "points" = 4.5, "capacity" = 80),
		),
		"Set 2" = list(
			STATS_SHRINE_VALUE = list("name" = "献给神像的价值：", "points" = 0.08, "capacity" = 70),
		),
		"Set 3" = list(
			STATS_GREEDY_PEOPLE = list("name" = "贪婪者人数：", "points" = 6.5, "capacity" = 70),
			STATS_KLEPTOMANIACS = list("name"= "盗窃癖人数：", "points" = 5, "capacity" = 25)
		),
		"Set 4" = list(
			STATS_LOCKS_PICKED = list("name" = "撬开的锁：", "points" = 3.75, "capacity" = 80),
			STATS_GRAVES_ROBBED = list("name" = "盗掘的坟墓：", "points" = 5.25, "capacity" = 60),
		)
	)

	cost_variance = 15  // Keeps a balance between predictability and randomness
