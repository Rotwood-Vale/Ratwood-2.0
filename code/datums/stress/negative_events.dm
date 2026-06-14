/datum/stressevent/vice
	timer = 5 MINUTES
	stressadd = 5
	desc = list(span_boldred("我没有放纵自己的恶习。"),span_boldred("我得满足自己的恶习。"))

// Vice-specific stress events for multiple vices support
/datum/stressevent/vice/nympho
	desc = list(span_boldred("我感到欲火难耐……"),span_boldred("我得满足自己的欲望。"))

/datum/stressevent/vice/baothamarked
	desc = list(span_boldred("我的烙印灼痛难忍……"),span_boldred("我得尽快满足这道烙印的渴求。"))

/datum/stressevent/vice/sadist
	desc = list(span_boldred("我想听见有人呜咽求饶。"),span_boldred("我渴望他人的痛苦。"))

/datum/stressevent/vice/masochist
	desc = list(span_boldred("我需要有人来伤害我。"),span_boldred("我渴望疼痛的感觉。"))

/datum/stressevent/vice/greedy
	desc = list(span_boldred("我需要更多玛门币……"),span_boldred("我手里的这些远远不够！"))

/datum/stressevent/vice/alcoholic
	desc = list(span_boldred("该喝一杯了。"),span_boldred("我需要来点酒。"))

/datum/stressevent/vice/kleptomaniac
	desc = list(span_boldred("我得偷点什么！"),span_boldred("要是不偷东西我就要死了！"))

/datum/stressevent/vice/junkie
	desc = list(span_boldred("该去狠狠干一票了。"),span_boldred("我需要一次真正的飘飘欲仙。"))

/datum/stressevent/vice/smoker
	desc = list(span_boldred("该来一口够劲的烟了。"),span_boldred("我得抽点什么。"))

/datum/stressevent/vice/godfearing
	desc = list(span_boldred("该向我的主神祈祷了。"),span_boldred("我得去拜访主神的领域。"))

/datum/stressevent/chastity_frustration
	timer = INFINITY
	stressadd = 1
	desc = span_red("这束缚快把我逼疯了。")

/datum/stressevent/chastity_flat_cramped
	timer = INFINITY
	stressadd = 1
	desc = span_red("这贞笼对我来说太挤了。")

/datum/stressevent/miasmagas
	timer = 10 SECONDS
	stressadd = 2
	desc = span_red("这里闻起来像死亡一样。")

/datum/stressevent/stinky_aura
	timer = 20 SECONDS
	stressadd = 2
	desc = span_red("附近有什么东西臭得要命。")

/datum/stressevent/peckish
	timer = 10 MINUTES
	stressadd = 1
	desc = span_red("我有点饿了。")

/datum/stressevent/hungry
	timer = 10 MINUTES
	stressadd = 3
	desc = span_red("我饿了。")

/datum/stressevent/starving
	timer = 10 MINUTES
	stressadd = 5
	desc = span_boldred("我快饿死了。")

/datum/stressevent/drym
	timer = 10 MINUTES
	stressadd = 1
	desc = span_red("我有点口渴。")

/datum/stressevent/thirst
	timer = 10 MINUTES
	stressadd = 3
	desc = span_red("我渴了。")

/datum/stressevent/parched
	timer = 10 MINUTES
	stressadd = 5
	desc = span_boldred("我快要渴死了。")

/datum/stressevent/dismembered
	timer = 40 MINUTES
	stressadd = 5
	desc = span_boldred("我失去了一条肢体。")

/datum/stressevent/dwarfshaved
	timer = 40 MINUTES
	stressadd = 6
	desc = span_boldred("我宁可割开自己的喉咙，也不愿剃掉胡子。")

/datum/stressevent/viewdismember
	timer = 15 MINUTES
	max_stacks = 5
	stressadd = 2
	stressadd_per_extra_stack = 2
	desc = span_red("我眼看着人们被肢解屠戮。")

/datum/stressevent/fviewdismember
	timer = 1 MINUTES
	max_stacks = 10
	stressadd = 1
	stressadd_per_extra_stack = 1
	desc = span_red("我看到了可怕的东西！")

/datum/stressevent/viewgib
	timer = 5 MINUTES
	stressadd = 2
	desc = span_red("我看见了骇人的景象。")

/datum/stressevent/guillotinefail
	timer = 5 MINUTES
	stressadd = 3
	desc = span_red("这场处决真是糟透了！")

/datum/stressevent/guillotineexecutorfail
	timer = 15 MINUTES
	stressadd = 5
	desc = span_boldred("我把断头台处决搞砸了！真是奇耻大辱！")

/datum/stressevent/bleeding
	timer = 2 MINUTES
	stressadd = 2
	desc = list(span_red("我觉得自己在流血。"),span_red("我在流血。"))

/datum/stressevent/bleeding/can_apply(mob/living/user)
	if(user.has_flaw(/datum/charflaw/addiction/masochist))
		return FALSE
	return TRUE

/datum/stressevent/painmax
	timer = 1 MINUTES
	stressadd = 2
	desc = span_red("好痛啊！")

/datum/stressevent/painmax/can_apply(mob/living/user)
	if(user.has_flaw(/datum/charflaw/addiction/masochist))
		return FALSE
	return TRUE

/datum/stressevent/freakout
	timer = 15 SECONDS
	stressadd = 2
	desc = span_red("我正在惊慌失措！")

/datum/stressevent/bloodrain
	timer = 1 MINUTES
	stressadd = 4
	desc = span_red("天上下着血雨！我浑身都是血！")

/datum/stressevent/felldown
	timer = 1 MINUTES
	stressadd = 1
	desc = span_red("我摔倒了，真像个蠢货。")

/datum/stressevent/burntmeal
	timer = 2 MINUTES
	stressadd = 2
	desc = span_red("呸！真恶心！")

/datum/stressevent/rotfood
	timer = 2 MINUTES
	stressadd = 4
	desc = span_red("呸！真恶心！")

/datum/stressevent/psycurse
	timer = 5 MINUTES
	stressadd = 5
	desc = span_boldred("糟了！我受到了神罚！")

/datum/stressevent/treefather_loss
	timer = 10 MINUTES
	stressadd = 5
	desc = span_boldred("Treefather 发出悲恸的哀鸣。一棵神圣之树倒下了。")

/datum/stressevent/virginchurch
	timer = INFINITY
	stressadd = 10
	desc = span_boldred("我违背了向 The Gods 立下的贞洁誓言！")

/datum/stressevent/badmeal
	timer = 3 MINUTES
	stressadd = 2
	desc = span_red("这味道恶心得要命！")

/datum/stressevent/vomit
	timer = 3 MINUTES
	stressadd = 2
	max_stacks = 3
	stressadd_per_extra_stack = 2
	desc = span_red("我吐了！")

/datum/stressevent/vomitself
	timer = 3 MINUTES
	stressadd = 2
	max_stacks = 3
	stressadd_per_extra_stack = 2
	desc = span_red("我吐到自己身上了！")

/datum/stressevent/vomitother
	timer = 3 MINUTES
	stressadd = 3
	max_stacks = 3
	stressadd_per_extra_stack = 3
	desc = span_red("我身上沾了别人的呕吐物！")

/datum/stressevent/vomitedonother
	timer = 3 MINUTES
	stressadd = 2
	max_stacks = 3
	stressadd_per_extra_stack = 2
	desc = span_red("我吐到别人身上了！")

/datum/stressevent/cumbad
	timer = 5 MINUTES
	stressadd = 5
	desc = span_boldred("我被凌辱了。")

/datum/stressevent/cumcorpse
	timer = 1 MINUTES
	stressadd = 10
	desc = span_boldred("我都做了些什么？")

/datum/stressevent/shunned_race
	timer = 1 MINUTES
	stressadd = 1
	desc = span_red("最好离远一点。")

/datum/stressevent/shunned_race_xenophobic
	timer = 2 MINUTES
	stressadd = 5
	desc = span_red("最好离远一点。")

/datum/stressevent/gnoll_examine
	timer = 1 MINUTES
	stressadd = 2
	desc = span_red("诸神在上……是豺狼人！！")

/datum/stressevent/paracrowd
	timer = 15 SECONDS
	stressadd = 2
	desc = span_red("这里有太多和我长得不一样的人了。")

/datum/stressevent/parablood
	timer = 15 SECONDS
	stressadd = 3
	desc = span_red("这里到处都是血……简直像战场一样！")

/datum/stressevent/parastr
	timer = 2 MINUTES
	stressadd = 2
	desc = span_red("那头野兽更强……而且很可能轻易就能杀了我！")

/datum/stressevent/paratalk
	timer = 2 MINUTES
	stressadd = 2
	desc = span_red("他们正用邪恶的语言密谋对付我……")

/datum/stressevent/crowd
	timer = 2 MINUTES
	stressadd = 2
	desc = "<span class='red'>为什么大家都在这里……？他们是想杀了我吗？！</span>"

/datum/stressevent/nopeople
	timer = 2 MINUTES
	stressadd = 2
	desc = "<span class='red'>大家都去哪了？是不是出事了？！</span>"

/datum/stressevent/jesterphobia
	timer = 4 MINUTES
	stressadd = 5
	desc = span_boldred("不！快把 Jester 从我身边赶走！")

/datum/stressevent/coldhead
	timer = 60 SECONDS
	stressadd = 1
	desc = span_red("我的脑袋又冷又丑。")

/datum/stressevent/sleepytime
	timer = 40 MINUTES
	stressadd = 2
	desc = span_red("我累了。")

/datum/stressevent/tortured
	stressadd = 3
	max_stacks = 5
	stressadd_per_extra_stack = 2
	desc = span_boldred("我已经被摧毁了。")
	timer = 60 SECONDS

/datum/stressevent/confessed
	stressadd = 3
	desc = span_red("我已坦承自己的罪。")
	timer = 15 MINUTES

/datum/stressevent/confessedgood
	stressadd = 1
	desc = span_red("我已坦承自己的罪，感觉轻松多了。")
	timer = 15 MINUTES

/datum/stressevent/saw_wonder
	stressadd = 4
	desc = span_boldred("<B>我目睹了梦魇般的景象，现在我为自己的性命而恐惧！</B>")
	timer = INFINITY

/datum/stressevent/maniac_woke_up
	stressadd = 10
	desc = span_boldred("不……我想回去……")
	timer = INFINITY

/datum/stressevent/drankrat
	stressadd = 1
	desc = span_red("我从低贱的生物身上饮血了。")
	timer = 1 MINUTES

/datum/stressevent/lowvampire
	stressadd = 1
	desc = span_red("我已经死了……接下来会是什么？")

/datum/stressevent/oziumoff
	stressadd = 10
	desc = span_blue("我还得再来一口。")
	timer = 1 MINUTES

/datum/stressevent/puzzle_fail
	stressadd = 1
	desc = list(span_red("我把时间浪费在那蠢盒子上了。"),span_red("该死的 jester-box。"))
	timer = 5 MINUTES

/datum/stressevent/bowedasnoble
	stressadd = 5
	desc = list(span_boldred("身为贵族，我竟向下等人鞠躬！何等羞辱！"), span_boldred("我竟向下等人低头！真是奇耻大辱！"))
	timer = 10 MINUTES

/datum/stressevent/bowedasnoble/can_apply(mob/living/user)
	return HAS_TRAIT(user, TRAIT_NOBLE)

/datum/stressevent/noble_impoverished_food
	stressadd = 2
	desc = span_boldred("这东西太恶心了。怎么会有人吃这种玩意？")
	timer = 10 MINUTES

/datum/stressevent/noble_desperate
	stressadd = 6
	desc = span_boldred("我竟已沦落到如此绝境了吗？")
	timer = 60 MINUTES

/datum/stressevent/noble_bland_food
	stressadd = 1
	desc = span_red("这种食物根本配不上我的身份。我理应吃得更好……")
	timer = 5 MINUTES

/datum/stressevent/tortured/on_apply(mob/living/user)
	. = ..()
	if(user.client)
		record_round_statistic(STATS_TORTURES)

/datum/stressevent/noble_bad_manners
	stressadd = 1
	desc = span_red("我本该用勺子的……")
	timer = 5 MINUTES

/datum/stressevent/noble_ate_without_table
	stressadd = 1
	desc = span_red("吃这样的饭菜却不用餐桌？真是粗鄙。")
	timer = 2 MINUTES

/datum/stressevent/graggar_culling_unfinished
	stressadd = 1
	desc = span_red("我必须在对手吃掉我的心脏前先吃掉他的！")
	timer = INFINITY

/datum/stressevent/soulchurnerhorror
	timer = 10 SECONDS
	stressadd = 50
	desc = span_red("死者可怖的哀嚎正祈求解脱！我都做了些什么？！")

/datum/stressevent/soulchurner
	timer = 1 MINUTES
	stressadd = 30
	desc = span_red("死者可怖的哀嚎正祈求解脱！")

/datum/stressevent/soulchurnerpsydon
	timer = 1 MINUTES
	stressadd = 1
	desc = span_red("死者可怖的哀嚎正祈求解脱！但我还能忍受这种呼唤……")

/datum/stressevent/sewertouched
	timer = 5 MINUTES
	stressadd = 2
	desc = span_red("腐臭发烂的污水！")

/datum/stressevent/unseemly
	stressadd = 3
	desc = span_red("那张脸令人无法忍受！")
	timer = 3 MINUTES

/datum/stressevent/unseemly_made_love
	stressadd = 3
	desc = span_red("那个丑陋的怪物……碰了我！")
	timer = 30 MINUTES

/datum/stressevent/unseemly_made_love/beautiful
	desc = span_red("那个丑东西……毁了我！")
	timer = 45 MINUTES

/datum/stressevent/leprosy
	stressadd = 1
	desc = span_red("真是个恶心的麻风病人。最好离远一些。")
	timer = 3 MINUTES

/datum/stressevent/uncanny
	stressadd = 2
	desc = span_red("那张脸……不对劲！")
	timer = 3 MINUTES

/datum/stressevent/syoncalamity
	stressadd = 15
	desc = span_boldred("以 Psydon 之名，伟大彗星的碎片已经不复存在！我们接下来该怎么办？！")
	timer = 15 MINUTES

/datum/stressevent/hithead
	timer = 2 MINUTES
	stressadd = 2
	desc = span_red("哎哟，我的头……")

/datum/stressevent/psycurse
	stressadd = 3
	desc = span_boldred("糟了！我受到了神罚！")
	timer = INFINITY

/datum/stressevent/excommunicated
	stressadd = 5
	desc = span_boldred("The Ten 已将我抛弃！")
	timer = INFINITY

/datum/stressevent/apostasy
	stressadd = 3
	desc = span_boldred("叛教的印记落在我身上了！")
	timer = INFINITY

/datum/stressevent/heretic_on_sermon
	stressadd = 5
	desc = span_red("我的 PATRON 对我大失所望！")
	timer = 20 MINUTES

/datum/stressevent/riddle_munch
	stressadd = 10
	desc = span_boldred("也许我本不该那么做……")
	timer = 12 MINUTES
/datum/stressevent/lostchampion
	stressadd = 8
	desc = span_red("我感觉自己失去了冠军勇士！啊，我受创的心啊！")
	timer = 25 MINUTES

/datum/stressevent/lostward
	stressadd = 8
	desc = span_red("我辜负了我的受护者！我的缎带都失去了颜色！")
	timer = 25 MINUTES


/datum/stressevent/necrarevive
	stressadd = 15
	desc = span_boldred("差一点就被彻底抓住了……好冷！")
	timer = 15 MINUTES

/datum/stressevent/blessed_weapon
	stressadd = -3
	timer = INFINITY
	desc = span_green("我正手持一把受祝福的武器！")

/datum/stressevent/naledimasklost
	stressadd = 3
	desc = span_boldred("那副面具！这里的任何人都可能是 djinn。我已经暴露了。")
	timer = INFINITY

/datum/stressevent/shamanhoodlost
	stressadd = 3
	desc = span_boldred("那兜帽！没有它，我的信仰都开始动摇了。我感到羞愧。")
	timer = INFINITY

/datum/stressevent/headless
	stressadd = 3
	desc = span_red("他们的头去哪了？那团火焰又是什么？！")
	timer = 5 MINUTES

/datum/stressevent/hunted // When a hunted character sees someone in a mask
	timer = 2 MINUTES
	stressadd = 3
	desc = span_boldred("我看不见他们的脸！他们是不是已经找到我了！")

/datum/stressevent/profane // When a non-assassin touches a profane dagger
	timer = 3 MINUTES
	stressadd = 4
	desc = span_boldred("我从这把受诅咒的刀刃中听见了亡者的哀号！")

/datum/stressevent/fermented_crab_bad
	stressadd = 2
	desc = span_red("那发酵螃蟹真是腐臭、可憎又恶心。")
	timer = 3 MINUTES

/datum/stressevent/dimwitted
	timer = 10 MINUTES
	stressadd = -4
	desc = span_green("一切都变得简单又美好了……")

/datum/stressevent/feebleminded
	timer = 10 MINUTES
	stressadd = -10
	desc = span_green("嘿嘿……")

/datum/stressevent/arcane_high
	timer = 10 MINUTES
	stressadd = -2
	desc = span_green("自从那场魔法事故之后，万事万物都显得格外滑稽！")

/datum/stressevent/oath_ring_lost
	stressadd = 2
	desc = span_boldred("我誓言的凭证！它被偷走了！")
	timer = INFINITY

// this generally only happens if you're below 10 FOR, this is a little nudge to work on your luck stat
/datum/stressevent/xylixian_pity
	timer = 5 MINUTES
	stressadd = 1
	desc = span_red("Xylix 怜悯了我，让我免于厄运的后果。我必须表现得更好！")

// Prestidigitation water bolt stress events — triggered by being a cat and splashed in the face
/datum/stressevent/water_splashed_cat
	timer = 30 SECONDS
	stressadd = 2
	desc = span_red("喵呜！我的毛和脸全都湿透了。真是太丢脸了。")

/datum/stressevent/water_splashed_noble
	timer = 30 SECONDS
	stressadd = 2
	desc = span_red("岂有此理！竟敢把水泼到我脸上？这种侮辱简直无法容忍。")

/datum/stressevent/water_splashed_noble_cat
	timer = 30 SECONDS
	stressadd = 4
	desc = span_boldred("我的毛和脸都湿透了！这不仅丢人，还侮辱了我高贵的身份！")

/datum/stressevent/stinky_contact
	timer = 15 MINUTES
	stressadd = 2
	desc = span_red("呃！这股恶臭都沾满我全身了！我得把它洗掉，要么就只能等它散去。")
