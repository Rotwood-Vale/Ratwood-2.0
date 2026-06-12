// Just store all of the alcohol reagents that isn't base tg here
/datum/reagent/consumable/ethanol/beer
	name = "啤酒"
	description = ""
	color = "#a17c10" // rgb: 102, 67, 0
	nutriment_factor = 0.1
	boozepwr = 25
	taste_description = "麦芽酒"
	glass_name = "一杯啤酒"
	glass_desc = ""

/datum/reagent/consumable/ethanol/rum
	name = "朗姆酒"
	description = "朗姆酒都去哪了？"
	color = "#5f3b23" // rgb: 102, 67, 0
	boozepwr = 40
	taste_description = "带有焦糖与香草气息的甜味"

/datum/reagent/consumable/ethanol/cider
	name = "苹果西打"
	boozepwr = 40
	taste_description = "苹果的清脆鲜爽"
	glass_name = "一杯西打"
	color = "#6aa945"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/cider/pear
	name = "梨子西打"
	boozepwr = 40
	taste_description = "梨子细腻而甜润的风味"
	glass_name = "一杯梨子西打"
	color = "fffc6c"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/cider/strawberry
	name = "草莓西打"
	boozepwr = 40
	taste_description = "一丝草莓的甜香"
	color = "#da4d4d"
	glass_name = "一杯草莓西打"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/aqua_vitae
	name = "生命之水"
	boozepwr = 150
	taste_description = "死亡"
	color = "#6e6e6e"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/brandy
	name = "苹果白兰地"
	boozepwr = 60
	taste_description = "带焦糖橡木气息的白兰地"
	glass_name = "一杯白兰地"
	color = "#6aa945"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/brandy/pear
	name = "梨子白兰地"
	boozepwr = 60
	taste_description = "熟梨与一丝香料气息"
	color = "b9b607"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/brandy/strawberry
	name = "草莓白兰地"
	boozepwr = 60
	taste_description = "浓烈的甜味与顺滑余韵"
	color = "#bb1a1a"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/brandy/tangerine
	name = "橘子白兰地"
	boozepwr = 60
	taste_description = "香料与一抹柑橘风味"
	color = "#bb751a"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/brandy/plum
	name = "李子白兰地"
	boozepwr = 60
	taste_description = "紫色果香般的甜味与香草气息"
	color = "#5c0449"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/wine
	name = "葡萄酒"
	boozepwr = 30
	taste_description = "酒香"
	glass_name = "一杯葡萄酒"
	color = "#8a0b0b"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/light
	name = "淡啤酒"
	description = "一种自旧地古代起便开始酿造的酒精饮品；这一款热量和酒精含量都更低。"
	boozepwr = 5 //Space Europeans hate it
	taste_description = "刷锅水"
	glass_name = "一杯淡啤酒"
	glass_desc = ""

/datum/reagent/consumable/ethanol/green
	name = "绿色啤酒"
	description = "一种自旧地古代起便开始酿造的酒精饮品；这一款被染成了喜庆的绿色。"
	color = "#A8E61D"
	taste_description = "绿色尿骚水"
	glass_icon_state = "greenbeerglass"
	glass_name = "一杯绿色啤酒"
	glass_desc = ""

/datum/reagent/consumable/ethanol/green/on_mob_life(mob/living/carbon/M)
	if(M.color != color)
		M.add_atom_colour(color, TEMPORARY_COLOUR_PRIORITY)
	return ..()

/datum/reagent/consumable/ethanol/green/on_mob_end_metabolize(mob/living/M)
	M.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, color)

/datum/reagent/consumable/ethanol/ale
	name = "艾尔啤酒"
	description = "一种用发芽大麦和酵母酿成的深色酒精饮品。"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 25
	taste_description = "浓郁的大麦艾尔风味"
	glass_icon_state = "aleglass"
	glass_name = "一杯艾尔啤酒"
	glass_desc = ""


// BEERS - Imported for now, later the styles will be 'mockable', if and when I get to brewing.

// Humen Production - Underwhelming, but cheap.

/datum/reagent/consumable/ethanol/zagul
	name = "扎古尔酿"
	boozepwr = 15
	taste_description = "廉价尿骚水"
	color = "#DBD77F"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/gin
	name = "金酒"
	boozepwr = 65
	taste_description = "浓烈的松针气息"
	color = "#809978"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/spottedhen
	name = "斑母鸡"
	boozepwr = 15
	taste_description = "廉价尿骚水"
	color = "#DBD77F"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/hagwoodbitter
	name = "鬼木苦啤"
	boozepwr = 25
	taste_description = "寡淡的清脆感"
	color = "#BBB525"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/blackgoat
	name = "黑山羊克里克"
	boozepwr = 25
	taste_description = "扑面而来的酸味"
	color = "#401806"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/onion
	name = "洋葱干邑"
	boozepwr = 10
	taste_description = "辛香、甜感与麦芽余韵"
	color = "#683e00"
	quality = DRINK_NICE

// Elf Production - LEAF-LOVERS MOTHERFUCKER

/datum/reagent/consumable/ethanol/aurorian
	name = "曙光酿"
	boozepwr = 5
	taste_description = "隐约的草本余调"
	color = "#5D8A8A"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/fireleaf // cabbbage
	name = "火叶酒"
	boozepwr = 2
	taste_description = "糟糕的烈酒味"
	color = "#475e45"
	quality = DRINK_NICE

// Dwarven Production - Best in the Realms

/datum/reagent/consumable/ethanol/butterhairs
	name = "黄油发丝"
	boozepwr = 30
	taste_description = "浓郁奶油香"
	color = "#5D8A8A"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/stonebeards
	name = "石须珍藏"
	boozepwr = 40
	taste_description = "强烈的燕麦烈酒风味"
	color = "#5D8A8A"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/voddena // Definitely Actually Just Vodka Now.
	name = "沃德娜"
	boozepwr = 40  // now it's just vodka
	taste_description = "纯净的烈酒味"
	color = "#a1a1a1"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/sazdistal // Definitely Not Vodka.
	name = "萨兹蒸馏"
	boozepwr = 55  // holy shit
	taste_description = "辣椒、生姜与泥土味"
	color = "#2D1D1D"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/limoncello
	name = "柠檬甜酒"
	boozepwr = 45  // holy shit
	taste_description = "灼热而带柠檬香"
	color = "#d2da63"
	quality = DRINK_GOOD

// Generic Rice
/datum/reagent/consumable/ethanol/ricewine
	name = "米酒"
	taste_description = "花香甜味中带着淡淡鲜味。"
	color = "#F5E6C4" // rgb: 210, 218, 99
	boozepwr = 30

/datum/reagent/consumable/ethanol/ricespirit
	name = "米烧酒"
	taste_description = "干净的灼热感与干爽收尾。"
	color = "#F8FDFC" // rgb: 210, 218, 99
	boozepwr = 55
	quality = DRINK_NICE

// WINE - Fancy.

// Humen Production - Grape Based

/datum/reagent/consumable/ethanol/sourwine // Peasant grade shit.
	name = "酸酒"
	boozepwr = 20
	taste_description = "酸酒味"
	color = "#552b4b"

/datum/reagent/consumable/ethanol/whitewine
	name = "白葡萄酒"
	boozepwr = 30
	taste_description = "甜白葡萄酒风味"
	color = "#F3ED91"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/redwine
	name = "红葡萄酒"
	boozepwr = 30
	taste_description = "单宁厚重的酒味"
	color = "#571111"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/jackberrywine
	name = "杰克莓酒"
	boozepwr = 15
	taste_description = "甜得发腻的新酒"
	color = "#3b2342"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/jackberrywine/aged
	name = "陈年杰克莓酒"
	boozepwr = 30
	taste_description = "甘甜的陈年酒"
	color = "#402249"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/jackberrywine/delectable
	name = "佳酿杰克莓酒"
	boozepwr = 30
	taste_description = "美妙甘甜的陈年酒"
	color = "#652679"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/plum_wine
	name = "梅酒"
	boozepwr = 15
	taste_description = "酸得发腻的新酒"
	color = "#c997d8"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/plum_wine/aged
	name = "陈年梅酒"
	boozepwr = 30
	taste_description = "微酸甘甜的陈年酒"
	color = "#c27cd8"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/plum_wine/delectable
	name = "佳酿梅酒"
	boozepwr = 30
	taste_description = "美妙的酸甜陈年酒"
	color = "#a854c2"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/tangerine
	name = "橘子酒"
	boozepwr = 15
	taste_description = "带柑橘气息的苦甜新酒"
	color = "#e7aa59"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/tangerine/aged
	name = "陈年橘子酒"
	boozepwr = 30
	taste_description = "带柑橘气息的苦甜陈年酒"
	color = "#d68d2d"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/tangerine/delectable
	name = "佳酿橘子酒"
	boozepwr = 30
	taste_description = "美妙的柑橘苦甜陈年酒"
	color = "#eb9321"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/raspberry
	name = "覆盆子酒"
	boozepwr = 15
	taste_description = "酸甜的新酒风味"
	color = "#ee5ea6"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/raspberry/aged
	name = "陈年覆盆子酒"
	boozepwr = 30
	taste_description = "酸甜的陈年酒风味"
	color = "#d83788"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/raspberry/delectable
	name = "佳酿覆盆子酒"
	boozepwr = 30
	taste_description = "美妙的酸甜陈年酒风味"
	color = "#db0d74"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/blackberry
	name = "黑莓酒"
	boozepwr = 15
	taste_description = "微苦酸涩的新酒"
	color = "#861491"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/blackberry/aged
	name = "陈年黑莓酒"
	boozepwr = 30
	taste_description = "微苦酸涩的陈年酒"
	color = "#58065f"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/blackberry/delectable
	name = "佳酿黑莓酒"
	boozepwr = 30
	taste_description = "美妙的微苦酸涩陈年酒"
	color = "#330038"
	quality = DRINK_VERYGOOD

// Elf Production - Berries & Herbal

/datum/reagent/consumable/ethanol/elfred
	name = "精灵红"
	boozepwr = 15
	taste_description = "美妙的果香调"
	color = "#6C0000"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/elfblue
	name = "瓦尔莫拉蓝"
	boozepwr = 50
	taste_description = "圣洁般的甜味"
	color = "#2C9DAF"
	quality = DRINK_FANTASTIC

// Azure Drinks
/datum/reagent/consumable/ethanol/jagdtrunk // JÄGERMEISTER!!!!
	name = "猎饮"
	boozepwr = 55  // gotta be stronk
	taste_description = "辛辣的草药风味"
	color = "#331f18"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/apfelweinheim
	name = "阿佩海默"
	boozepwr = 45
	taste_description = "酸爽清脆与柔和甘甜"
	color = "#e0cb55"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/rtoper
	name = "利尔瓦斯陶珀"
	boozepwr = 40
	taste_description = "压倒性的酸涩"
	color = "#e0a400"
	quality = DRINK_NICE

/datum/reagent/consumable/ethanol/nred
	name = "诺瓦丁红"
	boozepwr = 30
	taste_description = "厚重焦糖调与一丝苦味"
	color = "#543633"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/gronnmead
	name = "拉格纳酿"
	boozepwr = 35
	taste_description = "蜂蜜与红莓香调" //I love red mead ok...
	color = "#772C48"
	quality = DRINK_GOOD

//Avar boozes

/datum/reagent/consumable/ethanol/avarmead
	name = "佐金巴尔"
	boozepwr = 30
	taste_description = "辛香蜂蜜味"
	color = "#e0a400"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/avarrice
	name = "马克科利尔"
	boozepwr = 30
	taste_description = "微酸的甜味"
	color = "#ddcbc9"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/saigamilk //No way, kumys from avar!!!
	name = "博欣阿尔希"
	boozepwr = 15
	taste_description = "起泡、酸咸"
	color = "#dddddd"

//Kazengun boozes

/datum/reagent/consumable/ethanol/kgunlager
	name = "山口淡啤"
	boozepwr = 10 //A PALE imitation actual beer...
	taste_description = "柔和苦味与一丝绿茶香"
	color = "#d7dbbc"

/datum/reagent/consumable/ethanol/kgunsake
	name = "纯米吟酿"
	boozepwr = 50
	taste_description = "干爽的甜味"
	color = "#ccd7e0"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/kgunshochu
	name = "烧酎"
	boozepwr = 60
	taste_description = "干净利落的收尾"
	color = "#F8FDFC"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/kgunplum
	name = "梅酒"
	boozepwr = 30
	taste_description = "酸甜交织"
	color = "#ddb99b"
	quality = DRINK_GOOD

// Zhongese
/datum/reagent/consumable/ethanol/huangjiu
	name = "黄酒"
	boozepwr = 30
	taste_description = "酸甜交织"
	color = "#d8b84c"

/datum/reagent/consumable/ethanol/baijiu
	name = "白酒"
	boozepwr = 60
	taste_description = "炽烈辛辣中带一丝甘甜的酒味"
	color = "#f8fdfc"
	quality = DRINK_GOOD

/datum/reagent/consumable/ethanol/yaojiu
	name = "药酒"
	boozepwr = 50
	taste_description = "带浓厚草本气息的苦甜酒味"
	color = "#8C4B1F"
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/shejiu
	name = "蛇酒"
	boozepwr = 50
	taste_description = "浓烈酒味中带一丝野腥气"
	color = "#C49A6C"
	quality = DRINK_VERYGOOD

// Mead
/datum/reagent/consumable/ethanol/mead
	name = "蜜酒"
	description = "战士爱喝的酒，不过算是便宜货。"
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "甜甜的酒味"
	glass_icon_state = "meadglass"
	glass_name = "一杯蜜酒"
	glass_desc = ""

/datum/reagent/consumable/ethanol/mead/spider
	color = "#660061"

// Special Drugs
/datum/reagent/consumable/ethanol/murkwine // not Toilet wine
	name = "浊水酒"
	boozepwr = 50  // bubba's best
	taste_description = "可疑选择的滋味：浊水与纯乙醇的混合气息"
	color = "#4b1e00"

/datum/reagent/consumable/ethanol/murkwine/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/murkwine)
	M.stamina_add(0.1)
	..()
	. = 1

/datum/reagent/consumable/ethanol/murkwine/on_mob_end_metabolize(mob/living/M)
	M.remove_status_effect(/datum/status_effect/buff/murkwine)

/datum/reagent/consumable/ethanol/nocshine // wait, no, NOCSHINE
	name = "诺克私酿"
	boozepwr = 70  // YEEEEEHAAAWWWWWW
	taste_description = "像是喉咙在融化、鼻毛在燃烧"
	color = "#d8fbfd63"
	quality = DRINK_NICE


/datum/reagent/consumable/ethanol/nocshine/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/nocshine)
	if(HAS_TRAIT(M, TRAIT_CRACKHEAD))
		M.adjustToxLoss(0.1, 0)
	else
		M.adjustToxLoss(0.75, 0)
	..()
	. = 1

/datum/reagent/consumable/ethanol/nocshine/on_mob_end_metabolize(mob/living/M)
	M.remove_status_effect(/datum/status_effect/buff/nocshine)

/datum/reagent/consumable/ethanol/luxwine // oh no.
	name = "光暗同酿" // lux left w/ sugar in a darkened place for quite some time... U could say... Light in Darkness.....
	description = "一种由命髓发酵而成的酒，酒精度极高，滋味也格外阴沉；常被大胆、莽撞或异端之人追逐……"
	boozepwr = 80 // THE END OF THE FUCKING WORLD.
	taste_description = "先是苍绿的麻木，随后是心头燃起的热劲" // heartburn (healing)
	color = "#86cca3"
	quality = DRINK_VERYGOOD // good stuff!

/datum/reagent/consumable/ethanol/luxwine/on_mob_life(mob/living/carbon/M) // stolen healthpot code. i am shameless.
	if(volume > 0.99) // i have no clue if this works.
		M.adjustBruteLoss(-1*REM, 0)
		M.adjustFireLoss(-1*REM, 0)
	..()

/datum/reagent/consumable/ethanol/whipwine // dont ask
	name = "魔鞭酒"
	description = "这是一种最近才传入此地的配方。据说魔鞭酒能让人的力量与耐力提升七倍。"
	boozepwr = 10 // it's a whip. it's an actual whip.
	taste_description = "皮革、苦草药与悔意" // what did you expect
	color = "#3a1d18"

/datum/reagent/consumable/ethanol/komuchisake // if you put this outside the lich dungeon i'll kill you
	name = "神蛇酒"
	description = "这是鞭酒的真正形态。魔蛇酒是三百多年前风玄幕府专门酿制的一种药酒……"
	boozepwr = 60 // ancient lichebrau...
	taste_description = "苦涩、疼痛、铁腥与古老错误" // what did you expect [2]
	color = "#553837"
