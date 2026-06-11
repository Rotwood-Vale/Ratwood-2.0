/obj/item/reagent_containers/glass/bottle/rogue/healthpot
	list_reagents = list(/datum/reagent/medicine/healthpot = 50)

/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew
	list_reagents = list(/datum/reagent/medicine/stronghealth = 50)

/obj/item/reagent_containers/glass/bottle/rogue/manapot
	list_reagents = list(/datum/reagent/medicine/manapot = 50)

/obj/item/reagent_containers/glass/bottle/rogue/poison
	list_reagents = list(/datum/reagent/toxin/killersice = 1)

/obj/item/reagent_containers/glass/bottle/rogue/water
	list_reagents = list(/datum/reagent/water = 50)


/obj/item/reagent_containers/glass/bottle/mercury
	list_reagents = list(/datum/reagent/mercury = 50)

/obj/item/reagent_containers/glass/bottle/sleep
	list_reagents = list(/datum/reagent/sleep_powder = 50)

//vanderlin potion stuff//
/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot
	list_reagents = list(/datum/reagent/medicine/strongmana = 50)

/obj/item/reagent_containers/glass/bottle/rogue/stampot
	list_reagents = list(/datum/reagent/medicine/stampot = 50)

/obj/item/reagent_containers/glass/bottle/rogue/strongstampot
	list_reagents = list(/datum/reagent/medicine/strongstam = 50)

/obj/item/reagent_containers/glass/bottle/rogue/antidote
	list_reagents = list(/datum/reagent/medicine/antidote = 50)

/obj/item/reagent_containers/glass/bottle/rogue/strong_antidote
	list_reagents = list(/datum/reagent/medicine/strong_antidote = 50)

/obj/item/reagent_containers/glass/bottle/rogue/berrypoison
	list_reagents = list(/datum/reagent/berrypoison = 15)

/obj/item/reagent_containers/glass/bottle/rogue/strongpoison
	list_reagents = list(/datum/reagent/strongpoison = 15)

/obj/item/reagent_containers/glass/bottle/rogue/stampoison
	list_reagents = list(/datum/reagent/stampoison = 15)

/obj/item/reagent_containers/glass/bottle/rogue/strongstampoison
	list_reagents = list(/datum/reagent/strongstampoison = 15)

/obj/item/reagent_containers/glass/bottle/alchemical/strpot
	list_reagents = list(/datum/reagent/buff/strength = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/perpot
	list_reagents = list(/datum/reagent/buff/perception = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/endpot
	list_reagents = list(/datum/reagent/buff/endurance = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/conpot
	list_reagents = list(/datum/reagent/buff/constitution = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/intpot
	list_reagents = list(/datum/reagent/buff/intelligence = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/spdpot
	list_reagents = list(/datum/reagent/buff/speed = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/lucpot
	list_reagents = list(/datum/reagent/buff/fortune = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/healthpot
	list_reagents = list(/datum/reagent/medicine/healthpot = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew
	list_reagents = list(/datum/reagent/medicine/stronghealth = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/blessedwater
	list_reagents = list(/datum/reagent/water/blessed = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/manapot
	list_reagents = list(/datum/reagent/medicine/manapot = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/strongmanapot
	list_reagents = list(/datum/reagent/medicine/strongmana = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/fermented_crab
	list_reagents = list(/datum/reagent/fermented_crab = 15)

/obj/item/reagent_containers/glass/bottle/alchemical/emberwine
	list_reagents = list(/datum/reagent/consumable/ethanol/beer/emberwine = 5)
	desc = "一个贴着标签的小瓶子，上面写着内含烈焰酒，一种强效催情剂。"

/obj/item/reagent_containers/glass/bottle/alchemical/emberwine/full
	list_reagents = list(/datum/reagent/consumable/ethanol/beer/emberwine = 30)

//////////////////////////
/// ALCOHOLIC BOTTLES ///
//////////////////////////

// BEER - Cheap, Plentiful, Saviours of Family Life
/obj/item/reagent_containers/glass/bottle/rogue/beer
	name = "啤酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "beer_2"
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 50)
	desc = "一瓶装着普通自酿淡啤的酒。它用硬化黏土做了个临时瓶塞。"
	fancy = TRUE

/obj/item/reagent_containers/glass/bottle/rogue/beer/zagul
	name = "扎古尔酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "beer_2"
	list_reagents = list(/datum/reagent/consumable/ethanol/zagul = 50)
	desc = "一只带有海岸扎古尔瓶塞的酒瓶。里面是本地酒坊出产的廉价拉格啤酒。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat
	name = "黑山羊酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/blackgoat = 50)
	desc = "一只带有黑山羊克里克瓶塞的酒瓶。用豺莓酿成的酸果啤酒，口感尖酸。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/ratkept
	name = "护鼠酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/onion = 50)
	desc = "一只令人意外地没有瓶塞的酒瓶。玻璃上刻着\"ONI-N\"，其中的字母\"O\"似乎被彻底刮掉了。可疑。瓶身还贴着一张纸，上面画着一群老鼠在抵挡成堆乞丐、守卫满是酒瓶地窖的图案。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/hagwoodbitter
	name = "鬼木苦酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/hagwoodbitter = 50)
	desc = "一只带有鬼木苦酒瓶塞的酒瓶。这大概是从被格伦泽尔霍夫占领的佐恩地区出口的东西里，最不苦的一样。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/aurorian
	name = "奥罗瑞安草本啤酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/aurorian = 50)
	desc = "一只带有奥罗瑞安酒坊瓶塞的酒瓶。里面是以草本香料混合物酿制的精灵啤酒。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/fireleaf
	name = "火叶酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/fireleaf= 50)
	desc = "一只带有普通叶片瓶塞的酒瓶。里面是以卷心菜蒸馏而成的精灵啤酒。你相当确定自己能做出质量更好的。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/butterhairs
	name = "黄油须酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "ale"
	list_reagents = list(/datum/reagent/consumable/ethanol/butterhairs = 50)
	desc = "一只带有矮人联邦贸易同盟瓶塞的酒瓶。这种名为黄油须的啤酒，被广泛视为矮人最杰出的出口商品之一。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/stonebeardreserve
	name = "石须珍藏酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "ale"
	list_reagents = list(/datum/reagent/consumable/ethanol/stonebeards = 50)
	desc = "一只带有斯陶滕森家族瓶塞的酒瓶。石须珍藏是世上最具传奇色彩的啤酒之一，每年只酿几百桶。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/sazdistal
	name = "斯陶滕森萨兹迪斯塔尔酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "plum_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/sazdistal = 50)
	desc = "一只带有斯陶滕森家族瓶塞的酒瓶。这种奇异液体被视为整个山地家园中最辛辣、酒劲最烈的饮品。各年龄层贵族都会买，尤其是那些一心求死的。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/voddena
	list_reagents = list(/datum/reagent/consumable/ethanol/voddena = 50)
	desc = "一只带有诺尔万丁城瓶塞的酒瓶。里面装着相当纯净清澈的伏登纳酒。"

// WINES - Expensive, Nobleblooded
/obj/item/reagent_containers/glass/bottle/rogue/wine
	name = "葡萄酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "red_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/wine = 50)
	desc = "一瓶装着普通红葡萄酒的酒，多半产自齐班提乌姆。它有一个红陶瓶塞。"
	fancy = TRUE

/obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine
	name = "格伦泽尔霍夫酸酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "red_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/sourwine = 50)
	desc = "一瓶带有黑墨瓶塞的格伦泽尔霍夫经典酒品。里面是以矿泉水稀释过的极酸葡萄酒。"

/obj/item/reagent_containers/glass/bottle/rogue/redwine
	name = "奥塔万红酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "otavan_red"
	list_reagents = list(/datum/reagent/consumable/ethanol/redwine = 50)
	desc = "一只带有奥塔万商人公会瓶塞的酒瓶。标签表明这是一瓶来自币领国、年份尚浅的红葡萄酒。"
	fancy = TRUE

/obj/item/reagent_containers/glass/bottle/rogue/whitewine
	name = "奥塔万白酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "white_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/whitewine = 50)
	desc = "一只带有奥塔万商人公会瓶塞的酒瓶。标签表明这是一瓶来自寒冷北地的甜酒。"
	fancy = TRUE

/obj/item/reagent_containers/glass/bottle/rogue/elfred
	name = "精灵红酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "elven_red"
	list_reagents = list(/datum/reagent/consumable/ethanol/elfred = 50)
	desc = "一只以白银瓶塞装点的酒瓶。标签似乎写着它是产自奥塔瓦的精灵红酒。它的价值很可能比整个村子一年赚的还多！"
	fancy = TRUE

/obj/item/reagent_containers/glass/bottle/rogue/elfblue
	name = "瓦尔莫拉蓝酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "valmora_blue"
	list_reagents = list(/datum/reagent/consumable/ethanol/elfblue = 50)
	desc = "一只以金色瓶塞装点的酒瓶。这便是传奇的瓦尔莫拉蓝酒，出自瓦尔莫拉葡萄园，其主人是一位受人尊崇的黑精灵剑术大师。这瓶酒足以让神明都为之倾倒！"
	fancy = TRUE

/obj/item/reagent_containers/glass/bottle/rogue/luxwine
	name = "卢克辛特内布尔酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "luxwine"
	list_reagents = list(/datum/reagent/consumable/ethanol/luxwine = 50)
	desc = "一只外形华贵、带有阿凡汀瓶塞的酒瓶。隐约能听见某人最黑暗秘密的低语从瓶中传来。"
	fancy = TRUE

//AZURE DRINKS
/obj/item/reagent_containers/glass/bottle/rogue/beer/jagdtrunk
	name = "烈酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "red_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/jagdtrunk = 50)
	desc = "一只带有赛加雄鹿瓶塞的酒瓶。这种深色液体是目前能弄到的、产自格伦泽尔霍夫最烈的酒。草本烈酒，足以把任何病都烧出去。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/apfelweinheim
	name = "阿普费尔魏因海姆苹果酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "ale"
	list_reagents = list(/datum/reagent/consumable/ethanol/apfelweinheim = 50)
	desc = "一只带有阿普费尔魏因海姆瓶塞的酒瓶。里面是来自格伦泽尔霍夫城镇阿普费尔魏因海姆的苹果酒，因加入了梨子并搭配脆甜苹果而备受欢迎。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/rtoper
	name = "利尔瓦斯苹果酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "ale"
	list_reagents = list(/datum/reagent/consumable/ethanol/rtoper = 50)
	desc = "一只带有利尔瓦斯纹章瓶塞的酒瓶。里面是来自利尔瓦斯小王国的一种格外酸涩的苹果酒。传说酿酒师会把酒桶放在沼泽中陈放，因此得到了那股格外强烈的风味。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/nred
	name = "诺尔万丁艾尔酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "ale"
	list_reagents = list(/datum/reagent/consumable/ethanol/nred = 50)
	desc = "一只带有诺尔万丁城瓶塞的酒瓶。里面是哈默霍尔德之地酿得恰到好处的红艾尔。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead
	name = "盾少女蜜酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "red_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/gronnmead = 50)
	desc = "一只带有盾少女酒坊瓶塞的酒瓶。里面是深红色的蜜酒，以格隆高地特产的红莓精制而成。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead
	name = "黄金蜜酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "plum_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/avarmead = 50)
	desc = "一只只有普通瓶塞的酒瓶。里面是阿瓦尔草原酿制的金色蜜酒，味道醇正而酒劲十足。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/avarrice
	name = "阿夫尼克白酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "white_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/avarrice = 50)
	desc = "一只只有普通瓶塞的酒瓶。里面是用阿瓦尔草原所产稻米酿制的浑浊白酒。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/saigamilk
	name = "酿制赛加奶酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "plum_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/saigamilk = 50)
	desc = "一只带有奔跑赛加瓶塞的酒瓶。里面是用赛加奶和盐酿成的酒，乃草原游牧民的常见饮品。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunlager
	name = "山口茶拉格酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/kgunlager = 50)
	desc = "一只带有山口酒坊瓶塞的酒瓶。里面是远方风间郡酿造的淡色拉格，并以绿茶精修出独特风味，甚至比精灵酒还要清淡！"

/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunsake
	name = "阿夫尼克的 White 酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "white_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/kgunsake = 50)
	desc = "一只带有金天鹅瓶塞的酒瓶。里面是以稻米酿成的半透明浅蓝色酒液，深受风间郡军阀与贵族喜爱。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunplum
	name = "梅酒瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "plum_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/kgunplum = 50)
	desc = "一只带有金天鹅瓶塞的酒瓶。里面是以风间群岛常见果实酿成的红金色酒液，深受平民喜爱。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunshochu
	name = "风间烧酎瓶"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "rice_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/kgunshochu = 50)
	desc = "一只带有金天鹅瓶塞的酒瓶。里面是蒸馏米酒制成的清澈烈酒，收口干净利落，在风间郡武士阶层中很受欢迎。"

// Zhongese Drinks
/obj/item/reagent_containers/glass/bottle/rogue/beer/huangjiu
	list_reagents = list(/datum/reagent/consumable/ethanol/huangjiu = 50)
	desc = "一只带有红色封印的酒瓶。里面是酒劲很强、口感甜润的黄米酒，也常被用于烹饪。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/baijiu
	list_reagents = list(/datum/reagent/consumable/ethanol/baijiu = 50)
	desc = "一只带有红色封印的酒瓶。里面是以高粱或米发酵而成的清澈烈酒，深受流浪武人喜爱。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/yaojiu
	list_reagents = list(/datum/reagent/consumable/ethanol/yaojiu = 50)
	desc = "一只带有红色封印的酒瓶。里面是加入多种药草、包括人参在内的甘甜烈性米酒，在中洲大陆常被当作药酒开给病人。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/shejiu
	list_reagents = list(/datum/reagent/consumable/ethanol/shejiu = 50)
	desc = "一只带有红色封印的酒瓶。里面是一条死蛇泡在烈性米酒中。在中洲，人们相信喝这个能增强阳刚之气并促进血液循环。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/murkwine
	list_reagents = list(/datum/reagent/consumable/ethanol/murkwine = 50)
	desc = "一只带有负鼠尾酒坊标记的酒瓶。里面是以浑水和沼草酿成的特制酒，乃伤心地一带的特色。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/nocshine
	list_reagents = list(/datum/reagent/consumable/ethanol/nocshine = 50)
	desc = "一只带有蓝色新月标记的酒瓶。里面是某种极其强烈且带毒的特酿，但据说能强健身体。如果你敢的话。"

/obj/item/reagent_containers/glass/bottle/rogue/beer/whipwine
	list_reagents = list(/datum/reagent/consumable/ethanol/whipwine = 50)
	desc = "一只颜色棕得令人担忧的奇怪酒瓶。瓶身带有蛇首压叶的封印，标记说明其内容物据说有益健康……"

/obj/item/reagent_containers/glass/bottle/rogue/beer/komuchisake
	list_reagents = list(/datum/reagent/consumable/ethanol/komuchisake = 50)
	desc = "一只覆满灰尘、古老而泛着红赭色的酒瓶。上面有一个雕饰精细的金色骷髅封印，瓶身纹样显然来自幕府。看起来里面塞满了草药。"

		//////////////////////////
		/// CLAY BOTTLES ///
		//////////////////////////

/obj/item/reagent_containers/glass/bottle/claybottle/wine
	list_reagents = list(/datum/reagent/consumable/ethanol/wine = 75)
	desc = "一只陶瓶，里面装着普通的红葡萄酒，多半产自齐班提乌姆。它有一个红陶瓶塞。"

/obj/item/reagent_containers/glass/bottle/claybottle/water
	list_reagents = list(/datum/reagent/water = 75)
	desc = "一只没有任何标记的陶瓶。"

/obj/item/reagent_containers/glass/bottle/claybottle/beer
	list_reagents = list(/datum/reagent/consumable/ethanol = 75)
	desc = "一只陶瓶，里面装着普通自酿淡啤。它有一个以硬化黏土做成的临时瓶塞。"

/obj/item/reagent_containers/glass/bottle/claybottle/nred
	list_reagents = list(/datum/reagent/consumable/ethanol/nred = 75)
	desc = "一只带有诺尔万丁城瓶塞的陶瓶。里面是哈默霍尔德之地酿得恰到好处的红艾尔。"

/obj/item/reagent_containers/glass/bottle/claybottle/gronnmead
	list_reagents = list(/datum/reagent/consumable/ethanol/gronnmead = 75)
	desc = "一只带有盾少女酒坊瓶塞的陶瓶。里面是深红色蜜酒，以格隆高地特产的红莓精制而成。"

/obj/item/reagent_containers/glass/bottle/claybottle/whitewine
	list_reagents = list(/datum/reagent/consumable/ethanol/whitewine = 75)
	desc = "一只带有 奥塔万 Merchant Guild 瓶塞的酒瓶。标签表明这是一瓶来自寒冷北地的甜酒。"

/obj/item/reagent_containers/glass/bottle/rogue/emberwine
	list_reagents = list(/datum/reagent/consumable/ethanol/beer/emberwine = 24)
	desc = "一只带有无标记、染着单宁色瓶塞的酒瓶。多半是齐班提乌姆红酒，或其他类似的廉价酒。"
