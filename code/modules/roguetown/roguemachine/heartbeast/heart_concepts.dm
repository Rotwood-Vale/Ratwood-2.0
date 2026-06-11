/datum/flesh_concept
	var/name = "基础概念"
	var/list/tier_questions = alist() // Questions for each tier (1-4)
	var/list/answer_keywords = list() // Keywords accepted in answers across all tiers

/datum/flesh_concept/pain
	name = "痛苦"
	tier_questions = alist(
		1 = list("疼？哎哟？", "难受？", "痛吗？"),
		2 = list("什么是痛苦？", "为什么会疼？", "痛苦是好事吗？"),
		3 = list("受苦有意义吗？", "痛苦会教导人吗？", "痛苦如何改变我们？"),
		4 = list("剧痛会揭示什么真相？", "成长一定需要受苦吗？", "痛苦如何塑造意识？")
	)
	answer_keywords = list("hurt", "pain", "suffering", "agony", "ache", "torment", "anguish")

/datum/flesh_concept/blood
	name = "血液"
	tier_questions = alist(
		1 = list("红红湿湿？", "生命汁液？", "会流血？"),
		2 = list("什么是血？", "血为什么是红的？", "血就是生命？"),
		3 = list("血液会承载记忆吗？", "血液神圣吗？", "血管里流淌的是什么？"),
		4 = list("血液中流淌着怎样的祖辈知识？", "血液是血脉的长河吗？", "血液会记住心智遗忘的东西吗？")
	)
	answer_keywords = list("blood", "bleed", "veins", "life", "red", "flow", "sacrifice")

/datum/flesh_concept/fear
	name = "恐惧"
	tier_questions = alist(
		1 = list("可怕？", "跑？躲？", "坏东西？"),
		2 = list("什么是恐惧？", "恐惧是好事吗？", "为什么害怕？"),
		3 = list("恐惧是在保护我们，还是囚禁我们？", "恐惧之下隐藏着什么？", "恐惧是一种警告吗？"),
		4 = list("畏惧会揭开什么真相？", "恐惧是求生的阴影吗？", "惊骇会揭露隐藏的真实吗？")
	)
	answer_keywords = list("fear", "scared", "afraid", "terror", "dread", "panic", "anxiety")

/datum/flesh_concept/hunger
	name = "饥饿"
	tier_questions = alist(
		1 = list("想吃？", "肚子空空？", "现在就吃？"),
		2 = list("什么是饥饿？", "为什么我们需要食物？", "饥饿会痛吗？"),
		3 = list("饥饿不只是身体上的感觉吗？", "我们真正渴求的是什么？", "饥饿会驱动创造吗？"),
		4 = list("饥饿象征着怎样的存在空洞？", "对血肉的渴求是存在的引擎吗？", "究竟是什么样的饥饿在驱使我们？")
	)
	answer_keywords = list("hunger", "food", "eat", "crave", "starve", "appetite", "desire")

/datum/flesh_concept/love
	name = "爱"
	tier_questions = alist(
		1 = list("感觉真好？", "心里暖暖？", "喜欢别人？"),
		2 = list("什么是爱？", "为什么爱也会让人受伤？", "爱是好事吗？"),
		3 = list("爱是一种联结之力吗？", "爱会带来改变吗？", "爱要求怎样的牺牲？"),
		4 = list("我们真的需要爱，还是那只是内心的自欺？", "爱是联结灵魂的织线吗？", "爱究竟是一种怎样的神圣疯狂？")
	)
	answer_keywords = list("love", "care", "affection", "devotion", "passion", "connection", "bond")

/datum/flesh_concept/death
	name = "死亡"
	tier_questions = alist(
		1 = list("没有了？", "离开了？", "永远睡去？"),
		2 = list("什么是死亡？", "死后会怎样？", "为什么会死？"),
		3 = list("死亡是终结，还是转化？", "帷幕后等待着什么？", "死亡会赋予生命意义吗？"),
		4 = list("宏大寂静中藏着怎样的奥秘？", "死亡是最终的老师吗？", "崩解之后迎来的是什么样的重生？")
	)
	answer_keywords = list("death", "die", "dead", "end", "afterlife", "mortality", "rebirth")

/datum/flesh_concept/time
	name = "时间"
	tier_questions = alist(
		1 = list("现在是什么时候？", "之前？之后？", "白天？黑夜？"),
		2 = list("什么是时间？", "时间会流动？", "时间能停下吗？"),
		3 = list("时间会治愈，还是侵蚀？", "过去是否仍活在我们体内？", "片刻究竟有多重？"),
		4 = list("什么样的永恒当下容纳了一切时间？", "记忆是时间的锚点吗？", "在每个瞬间的缝隙之间，有什么在起舞？")
	)
	answer_keywords = list("time", "past", "future", "now", "moment", "memory", "eternity")

/datum/flesh_concept/dreams
	name = "梦境"
	tier_questions = alist(
		1 = list("睡里画面？", "夜里的故事？", "不是真的？"),
		2 = list("梦是什么？", "梦是真实的吗？", "为什么会做梦？"),
		3 = list("梦会显露隐藏的真相吗？", "闭上眼后，那里存在着怎样的世界？", "在梦里，我们会变得不一样吗？"),
		4 = list("沉睡的心智会游荡到什么样的国度？", "梦会连接集体无意识吗？", "梦境里沉睡着怎样的预言？")
	)
	answer_keywords = list("dream", "sleep", "vision", "nightmare", "unconscious", "fantasy", "prophecy")

/datum/flesh_concept/memory
	name = "记忆"
	tier_questions = alist(
		1 = list("记得东西？", "之前的事？", "旧画面？"),
		2 = list("什么是记忆？", "为什么会遗忘？", "记忆是真的吗？"),
		3 = list("记忆会塑造现实吗？", "有什么被遗忘了，却仍能被感受到？", "我们就是自己的记忆吗？"),
		4 = list("祖辈记忆中残留着怎样的回声？", "记忆存在于时间之外吗？", "被遗忘之物握着怎样的真相？")
	)
	answer_keywords = list("memory", "remember", "forget", "past", "recall", "nostalgia", "echo")

/datum/flesh_concept/truth
	name = "真相"
	tier_questions = alist(
		1 = list("真的东西？", "不是谎话？", "真的真的？"),
		2 = list("什么是真相？", "真相会伤人吗？", "总会有真相吗？"),
		3 = list("真相会有很多个吗？", "事实背后藏着怎样的谎言？", "真相会改变吗？"),
		4 = list("表象真相之下，隐藏着怎样的绝对现实？", "真相是一种主观体验吗？", "当一切谎言被剥离后，剩下的是什么？")
	)
	answer_keywords = list("truth", "real", "true", "fact", "honest", "reality", "authentic")

/datum/flesh_concept/lies
	name = "谎言"
	tier_questions = alist(
		1 = list("不是真的？", "编出来的？", "假的故事？"),
		2 = list("什么是谎言？", "为什么要撒谎？", "谎言是坏的吗？"),
		3 = list("谎言会保护人，还是伤害人？", "欺骗里藏着怎样的真相？", "有些谎言是必要的吗？"),
		4 = list("塑造现实的根本欺骗是什么？", "谎言会造就新的真相吗？", "虚妄帷幕之后藏着什么？")
	)
	answer_keywords = list("lie", "false", "deceive", "illusion", "trick", "untrue", "fiction")

/datum/flesh_concept/power
	name = "力量"
	tier_questions = alist(
		1 = list("强大？", "能让事情发生？", "做主的人？"),
		2 = list("什么是力量？", "如何获得力量？", "力量是好事吗？"),
		3 = list("力量会腐化人，还是揭示人？", "真正的强大是什么？", "力量可以分享吗？"),
		4 = list("宇宙中的哪些力量以权能的形式显现？", "力量意味着责任，还是自由？", "什么样的终极权威统御着存在？")
	)
	answer_keywords = list("power", "strong", "control", "authority", "dominance", "influence", "might")

/datum/flesh_concept/weakness
	name = "软弱"
	tier_questions = alist(
		1 = list("不强？", "做不到？", "弱小？"),
		2 = list("什么是软弱？", "软弱是坏的吗？", "该帮助弱者吗？"),
		3 = list("脆弱本身也是力量吗？", "局限之中会长出什么？", "软弱会教会我们怜悯吗？"),
		4 = list("脆弱中会浮现怎样深刻的真相？", "屈服有时也是胜利吗？", "接纳之中栖居着怎样的力量？")
	)
	answer_keywords = list("weak", "vulnerable", "fragile", "helpless", "limited", "frail", "dependent")

/datum/flesh_concept/creation
	name = "创造"
	tier_questions = alist(
		1 = list("做出新的？", "造东西？", "从无到有？"),
		2 = list("什么是创造？", "为什么要创造？", "怎么创造？"),
		3 = list("创造一定需要毁灭吗？", "是什么火花开启了创造？", "一切艺术都诞生于痛苦吗？"),
		4 = list("驱动创造的神圣冲动是什么？", "宇宙会借造物者做梦吗？", "潜能的虚空里会诞生什么？")
	)
	answer_keywords = list("create", "make", "build", "form", "art", "invent", "generate")

/datum/flesh_concept/destruction
	name = "毁灭"
	tier_questions = alist(
		1 = list("弄坏东西？", "没有了？", "砸碎？"),
		2 = list("什么是毁灭？", "为什么要毁灭？", "毁灭是好事吗？"),
		3 = list("毁灭会为创造腾出空间吗？", "废墟中存在怎样的美？", "终结是必要的吗？"),
		4 = list("怎样的宇宙循环需要崩解？", "毁灭会显露事物的本质形态吗？", "我们要重新开始，就必须先让一切终结吗？")
	)
	answer_keywords = list("destroy", "break", "ruin", "end", "demolish", "shatter", "obliterate")

/datum/flesh_concept/order
	name = "秩序"
	tier_questions = alist(
		1 = list("整整齐齐？", "每样东西都有位置？", "不乱糟糟？"),
		2 = list("什么是秩序？", "为什么秩序是好的？", "怎样建立秩序？"),
		3 = list("秩序是在限制我们，还是保护我们？", "什么样的规律统御着现实？", "混沌是秩序的敌人吗？"),
		4 = list("维系存在的宇宙结构是什么？", "秩序会从混沌中诞生吗？", "支配万物的神圣数学是什么？")
	)
	answer_keywords = list("order", "pattern", "system", "structure", "arrange", "organize", "method")

/datum/flesh_concept/chaos
	name = "混沌"
	tier_questions = alist(
		1 = list("一团乱？", "没有规律？", "一切都随机？"),
		2 = list("什么是混沌？", "混沌是坏的吗？", "为什么会有混沌？"),
		3 = list("混沌会创造自由吗？", "随机之中会浮现怎样的秩序？", "混沌是新奇的源头吗？"),
		4 = list("无序中栖息着怎样的无限可能？", "混沌会孕育新的现实吗？", "法则之间的缝隙里，有什么在起舞？")
	)
	answer_keywords = list("chaos", "random", "disorder", "confusion", "unpredictable", "entropy", "anarchy")

/datum/flesh_concept/beauty
	name = "美"
	tier_questions = alist(
		1 = list("漂亮东西？", "看着舒服？", "好看？"),
		2 = list("什么是美？", "为什么会美？", "美在哪里？"),
		3 = list("美是主观的，还是普遍的？", "究竟是什么让一件事物变得美丽？", "美一定需要不完美吗？"),
		4 = list("以美显现的神圣和谐是什么？", "美会揭示真相吗？", "表象之美之下，存在着怎样的永恒形态？")
	)
	answer_keywords = list("beauty", "beautiful", "pretty", "lovely", "aesthetic", "harmony", "grace")

/datum/flesh_concept/ugliness
	name = "丑陋"
	tier_questions = alist(
		1 = list("不好看？", "看着难受？", "形状不对？"),
		2 = list("什么是丑陋？", "为什么会丑？", "丑陋就是坏的吗？"),
		3 = list("丑陋也有属于自己的美吗？", "令人不适的形态里藏着什么真相？", "丑陋是必要的吗？"),
		4 = list("以丑陋显现的深层现实是什么？", "恐怖之中也自有敬畏吗？", "哪些神圣真相戴着令人厌恶的面具？")
	)
	answer_keywords = list("ugly", "unpleasant", "grotesque", "hideous", "repulsive", "disfigured", "monstrous")

/datum/flesh_concept/sacrifice
	name = "牺牲"
	tier_questions = alist(
		1 = list("舍弃？", "为别人失去？", "为了好事去受伤？"),
		2 = list("什么是牺牲？", "为什么要牺牲？", "牺牲值得吗？"),
		3 = list("牺牲会创造意义吗？", "怎样的转变需要献出代价？", "有所获得之前，一定要先失去吗？"),
		4 = list("怎样的交换必然要求牺牲？", "付出会带来丰盛吗？", "支配奉献的神圣秩序是什么？")
	)
	answer_keywords = list("sacrifice", "offer", "give", "lose", "surrender", "offerings", "devotion")

/datum/flesh_concept/greed
	name = "贪婪"
	tier_questions = alist(
		1 = list("还想要更多？", "不想分享？", "全都是我的？"),
		2 = list("什么是贪婪？", "为什么会贪婪？", "贪婪是好事吗？"),
		3 = list("贪婪会推动进步吗？", "怎样的空虚造就了欲求？", "不断累积其实也是一种贫乏吗？"),
		4 = list("以贪婪显现的存在匮乏是什么？", "无尽欲望造就了有限的生灵吗？", "占有欲试图填补的是怎样的空洞？")
	)
	answer_keywords = list("greed", "want", "desire", "possess", "accumulate", "hoard", "covet")

/datum/flesh_concept/justice
	name = "正义"
	tier_questions = alist(
		1 = list("公平的事？", "好人得好报？", "坏人受恶果？"),
		2 = list("什么是正义？", "正义就是公平吗？", "怎样实现正义？"),
		3 = list("正义是绝对的，还是相对的？", "复仇会维护正义吗？", "仁慈也能是正义的吗？"),
		4 = list("以正义显现的平衡是什么？", "普世法则需要均衡吗？", "衡量行为的天平是什么？")
	)
	answer_keywords = list("justice", "fair", "right", "law", "balance", "equity", "retribution")

/datum/flesh_concept/mercy
	name = "仁慈"
	tier_questions = alist(
		1 = list("不惩罚？", "原谅？", "温柔一点？"),
		2 = list("什么是仁慈？", "为什么要仁慈？", "仁慈是软弱吗？"),
		3 = list("仁慈是力量，还是软弱？", "宽恕会带来怎样的治愈？", "仁慈会同时改变施予者与受领者吗？"),
		4 = list("以仁慈显现的恩典是什么？", "怜悯会超越正义吗？", "流淌于存在中的善意是什么？")
	)
	answer_keywords = list("mercy", "forgive", "compassion", "kindness", "pity", "clemency", "grace")

/datum/flesh_concept/loneliness
	name = "孤独"
	tier_questions = alist(
		1 = list("孤零零？", "没有朋友？", "心里空空？"),
		2 = list("什么是孤独？", "为什么会孤独？", "孤独会让人痛吗？"),
		3 = list("独处和孤独是一回事吗？", "什么样的连接能缓解隔绝感？", "孤独会揭示我们对他人的需求吗？"),
		4 = list("怎样的存在分离造就了孤独？", "灵魂会渴望联结吗？", "在孤立中，我们会忆起怎样的神圣统一？")
	)
	answer_keywords = list("lonely", "alone", "isolated", "solitude", "abandoned", "empty", "separation")

/datum/flesh_concept/companionship
	name = "陪伴"
	tier_questions = alist(
		1 = list("和别人一起？", "不再独自一人？", "朋友？"),
		2 = list("什么是陪伴？", "为什么要在一起？", "独自一人不好吗？"),
		3 = list("联结会定义自我吗？", "什么样的纽带会改变个体？", "成长一定需要陪伴吗？"),
		4 = list("若世间再无活物，一个存在仍能获得陪伴吗？", "灵魂会认出彼此吗？", "众生之间存在着怎样的共鸣？")
	)
	answer_keywords = list("companion", "friend", "together", "bond", "connection", "relationship", "unity")

/datum/flesh_concept/hope
	name = "希望"
	tier_questions = alist(
		1 = list("也许会好？", "觉得会变好？", "不放弃？"),
		2 = list("什么是希望？", "为什么怀抱希望？", "希望有用吗？"),
		3 = list("希望会塑造现实吗？", "黑暗中是什么支撑着希望？", "希望是一种选择，还是一种感受？"),
		4 = list("以希望显现的潜能是什么？", "希望能瞥见未来的可能性吗？", "是什么样的承诺点燃了期待？")
	)
	answer_keywords = list("hope", "optimism", "expect", "faith", "belief", "anticipation", "possibility")

/datum/flesh_concept/despair
	name = "绝望"
	tier_questions = alist(
		1 = list("没有希望？", "全都糟了？", "放弃？"),
		2 = list("什么是绝望？", "为什么会绝望？", "绝望会结束吗？"),
		3 = list("绝望会揭示真相吗？", "无望之中会生出怎样的成长？", "绝望是一种必要的深度吗？"),
		4 = list("以绝望显现的存在真相是什么？", "当你凝视深渊时，深渊也会回望吗？", "彻底放弃之中会诞生怎样的启示？")
	)
	answer_keywords = list("despair", "hopeless", "desperate", "defeat", "sorrow", "anguish", "misery")

/datum/flesh_concept/courage
	name = "勇气"
	tier_questions = alist(
		1 = list("不害怕？", "还是去做？", "勇敢一点？"),
		2 = list("什么是勇气？", "为什么要勇敢？", "勇气是好事吗？"),
		3 = list("勇气一定需要恐惧衬托吗？", "什么样的行为才算勇敢？", "勇气是一种选择，还是一种特质？"),
		4 = list("以勇气显现的力量是什么？", "英勇会超越自我保全吗？", "是什么战胜了恐惧？")
	)
	answer_keywords = list("courage", "brave", "fearless", "bold", "valor", "heroism", "fortitude")

/datum/flesh_concept/cowardice
	name = "怯懦"
	tier_questions = alist(
		1 = list("太害怕？", "逃跑？", "不去做？"),
		2 = list("什么是怯懦？", "为什么会怯懦？", "怯懦是坏的吗？"),
		3 = list("怯懦会保全性命吗？", "谨慎里藏着怎样的智慧？", "恐惧有时也是明智的吗？"),
		4 = list("以怯懦显现的求生本能是什么？", "审慎会伪装成恐惧吗？", "是什么感觉驱使人后退？")
	)
	answer_keywords = list("coward", "fearful", "timid", "afraid", "hesitant", "retreat", "caution")

/datum/flesh_concept/wisdom
	name = "智慧"
	tier_questions = alist(
		1 = list("懂很多？", "聪明？", "明白？"),
		2 = list("什么是智慧？", "怎样获得智慧？", "智慧是好事吗？"),
		3 = list("智慧来自经验吗？", "智慧能被传授吗？", "智慧和知识不一样吗？"),
		4 = list("以智慧显现的领悟是什么？", "真理会在岁月中回响吗？", "贤者能看见怎样的永恒规律？")
	)
	answer_keywords = list("wisdom", "wise", "knowledge", "understanding", "insight", "enlightenment", "sagacity")

/datum/flesh_concept/ignorance
	name = "无知"
	tier_questions = alist(
		1 = list("不知道？", "笨笨的？", "不明白？"),
		2 = list("什么是无知？", "为什么会无知？", "无知是坏的吗？"),
		3 = list("无知是在保护我们，还是限制我们？", "不知情会带来怎样的自由？", "有些无知真的是幸福吗？"),
		4 = list("以无知显现的必要帷幕是什么？", "不知会为惊奇留出空间吗？", "哪些奥秘必须建立在不知之上？")
	)
	answer_keywords = list("ignorance", "ignore", "unknowing", "unaware", "naive", "innocent", "uninformed")

/datum/flesh_concept/freedom
	name = "自由"
	tier_questions = alist(
		1 = list("什么都能做？", "没有规矩？", "自由？"),
		2 = list("什么是自由？", "为什么想要自由？", "自由是好事吗？"),
		3 = list("自由需要承担责任吗？", "一个人独处也能自由吗？", "绝对的自由可能存在吗？"),
		4 = list("以自由显现的解放是什么？", "灵魂会渴望无拘无束的存在吗？", "存在之下的神圣自主是什么？")
	)
	answer_keywords = list("freedom", "free", "liberty", "autonomy", "independence", "unbound", "release")

/datum/flesh_concept/bondage
	name = "束缚"
	tier_questions = alist(
		1 = list("不自由？", "被困住？", "动不了？"),
		2 = list("什么是束缚？", "为什么会被困住？", "束缚是坏的吗？"),
		3 = list("限制会创造意义吗？", "约束之中存在怎样的自由？", "所有存在都会以某种方式被束缚吗？"),
		4 = list("以束缚显现的必要结构是什么？", "形式一定需要限制吗？", "约束存在的神圣法则是什么？")
	)
	answer_keywords = list("bondage", "bound", "trapped", "restricted", "prison", "captive", "constrained")

/datum/flesh_concept/growth
	name = "成长"
	tier_questions = alist(
		1 = list("变大？", "改变是好事？", "学得更多？"),
		2 = list("什么是成长？", "为什么要成长？", "怎样成长？"),
		3 = list("成长一定伴随着不适吗？", "哪些转变是必要的？", "成长能被强迫吗？"),
		4 = list("以成长显现的演化是什么？", "存在会在不断成为中展开吗？", "什么神圣潜能正寻求显现？")
	)
	answer_keywords = list("growth", "grow", "develop", "evolve", "mature", "progress", "transform")

/datum/flesh_concept/decay
	name = "衰朽"
	tier_questions = alist(
		1 = list("变老？", "坏掉？", "不运作了？"),
		2 = list("佩斯特拉是什么？", "为什么是佩斯特拉？", "佩斯特拉是不好的？"),
		3 = list("佩斯特拉的衰朽会为新生命腾出空间吗？", "腐坏之中存在怎样的美？", "终结也是循环的一部分吗？"),
		4 = list("佩斯特拉最伟大的赠礼是什么？", "佩斯特拉的消融是在服务新生吗？", "佩斯特拉要求回归本源的古老规律是什么？")
	)
	answer_keywords = list("decay", "rot", "decompose", "deteriorate", "wither", "fade", "corrupt", "pestra")

/datum/flesh_concept/transformation
	name = "转化"
	tier_questions = alist(
		1 = list("改变东西？", "变得不一样？", "不再相同？"),
		2 = list("什么是转化？", "为什么要改变？", "怎样转化？"),
		3 = list("转化一定需要毁灭吗？", "在改变之中，什么保持不变？", "经历转化之后，我们还是原来的自己吗？"),
		4 = list("以转化显现的蜕变是什么？", "存在会在不同形态之间起舞吗？", "什么永恒本质披着暂时的形状？")
	)
	answer_keywords = list("transform", "change", "become", "metamorphosis", "evolve", "shift", "alter")

/datum/flesh_concept/identity
	name = "身份"
	tier_questions = alist(
		1 = list("我是谁？", "我是？", "自我？"),
		2 = list("什么是身份？", "为什么会有自我？", "身份会改变吗？"),
		3 = list("我们是由记忆定义，还是由行为定义？", "是什么定义了一个人？", "身份会独立存在吗？"),
		4 = list("以身份显现的永恒自我是什么？", "意识会戴上暂时的面具吗？", "驱动存在的神圣火花是什么？")
	)
	answer_keywords = list("identity", "self", "who", "person", "individual", "essence", "soul")

/datum/flesh_concept/unity
	name = "统一"
	tier_questions = alist(
		1 = list("万物一体？", "在一起就相同？", "不再分离？"),
		2 = list("什么是统一？", "为什么要合而为一？", "统一是好事吗？"),
		3 = list("统一一定需要多样性吗？", "是什么连接着万物？", "统一之中还能保有个体性吗？"),
		4 = list("以统一显现的一体性是什么？", "分离能否被阻止，不让它带来毁灭？", "容纳一切部分的神圣整体是什么？")
	)
	answer_keywords = list("unity", "one", "together", "whole", "united", "connected", "harmony")
