
/obj/structure/fluff/walldeco
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/decoration.dmi'
	anchored = TRUE
	density = FALSE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER+0.1

/obj/structure/fluff/walldeco/OnCrafted(dirin, user)
	pixel_x = 0
	pixel_y = 0
	switch(dirin)
		if(NORTH)
			pixel_y = 32
		if(SOUTH)
			pixel_y = -32
		if(EAST)
			pixel_x = 32
		if(WEST)
			pixel_x = -32
	. = ..()

/obj/structure/fluff/walldeco/proc/get_attached_wall()
	return

/obj/structure/fluff/walldeco/wantedposter
	name = "匪徒告示"
	desc = "这里张贴着四处流窜的匪徒画像。看看这周有没有新的通缉吧……"
	icon_state = "wanted1"
	layer = BELOW_MOB_LAYER
	pixel_y = 32

/obj/structure/fluff/walldeco/wantedposter/r
	pixel_y = 0
	pixel_x = 32
/obj/structure/fluff/walldeco/wantedposter/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/fluff/walldeco/wantedposter/Initialize(mapload)
	. = ..()
	icon_state = "wanted[rand(1,3)]"
	dir = pick(GLOB.cardinals)

/obj/structure/fluff/walldeco/wantedposter/examine(mob/user)
	. = ..()
	if(user.Adjacent(src))
		if(SSrole_class_handler.bandits_in_round)
			. += span_bold("我看到这片区域最近有匪徒活动。")
			user.playsound_local(user, 'sound/misc/notice (2).ogg', 100, FALSE)
		else
			. += span_bold("看起来最近没有匪徒活动的报告。")

/obj/structure/fluff/walldeco/innsign
	name = "酒馆招牌"
	desc = "饱经风霜的木板标志着一个在冰冷无情的世界中供人歇息之处，在那里，人们可以用乏味的同伴和更乏味的酒来麻痹自己。"
	icon_state = "bar"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/steward
	name = "总管招牌"
	desc = "抛光木料与金箔标志着总管的办公室，他是城主地产和金库的管理者。"
	icon_state = "steward"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/bsmith
	name = "铁匠铺招牌"
	desc = "一块小型的摇摆铁砧招牌标志着铁匠铺，在那里，沾血的硬币为匆忙的修理和二手武器而转手。"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "bsmith"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/goblet
	name = "食堂招牌"
	desc = "一块刻有酒杯的小型摇摆招牌，标志着一处公共食堂。它或许没有城市酒馆的宏伟，但却是一个能在相对安全中用餐和歇息的地方。"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "goblet"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/flower
	name = "浴场招牌"
	desc = "在一个充满疾病与暴力的世界里，浴室是一处难得的歇息之所，人们可以在温暖芬芳的水中洗去疲惫，也洗去罪孽。"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "flower"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/barbersign
	name = "理发师外科医生招牌"
	desc = "标志性的理发师外科医生旋转纹样，在那里，人们可以用钱币换取生命的延续。"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "barbersign"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/barbersignreverse
	name = "理发师外科医生招牌"
	desc = "标志性的理发师外科医生旋转纹样，在那里，人们可以用钱币换取生命的延续。"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "barbersignflip"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/mercenaryflag
	name = "佣兵行会旗帜"
	desc = "一面粗犷的白色旗帜，其上绣着一只血红麻雀，这便是佣兵行会的标记。它由小型佣兵团和独立佣兵组成的松散联盟集合而成——你付多少金子，就能信任他们多少。"
	icon_state = "sparrow"

/obj/structure/fluff/walldeco/xavo
	name = "白橡旗帜"
	desc = "在黑色天空与深红原野的映衬下，一株白橡孤然挺立，高贵而骄傲。这面旗帜的做工精良，由上等亚麻织成，但你对这纹章却毫无印象——或许属于某个已被遗忘的王朝或佣兵团？"
	icon_state = "xavo"

/obj/structure/fluff/walldeco/serpflag
	name = "林德沃姆家族旗帜"
	desc = "黑底之上盘踞着一条可怖的巨蛇，这是林德沃姆家族男爵领的纹章，其家族箴言为'吾业永恒'。由于承受不住城主的先辈们施加的赋税，林德沃姆男爵领被迫放弃领地，逃往首府王田城。如今他们的庄园已沦为此地的弃民栖身之所，在其昔日的荣光废墟中苟延残喘。"
	icon_state = "serpent"

/obj/structure/fluff/walldeco/artificerflag
	name = "技匠行会旗帜"
	desc = "金色的工具在蔚蓝的海洋映衬下闪耀——那片海正是这些工匠们跋涉往来、从事贸易与劳作的水域。这面骄傲的旗帜属于技匠行会，一个由工匠与手艺人组成的集合体，他们共同协作以谋求利益与保护。在某些城市，他们的法定权利甚至堪比小贵族。"
	icon_state = "artificer"

/obj/structure/fluff/walldeco/maidendrape
	name = "黑色挂帘"
	desc = "一块深色的织物挂帘，对不敢标榜自身纹章的人来说，它是一件毫无特征的纯粹装饰。"
	icon_state = "black_drape"
	dir = SOUTH
	pixel_y = 32

/obj/structure/fluff/walldeco/wallshield
	name = "旧墙盾"
	desc = "一面挂在墙上的旧盾牌，其纹章已被岁月侵蚀得残损褪色。既然已无法在战斗中履行职责，它如今的功能纯粹是装饰。"
	icon_state = "wallshield"

/obj/structure/fluff/walldeco/sign/merchantsign
	name = "商会招牌"
	desc = "一块宣传商会服务的招牌——商会是一个遍及世界的广泛商人联盟。在这里，你或许能指望靠卖货赚到些钱，好歹不至于亏本，运气好的话还能凑够一顿饭钱。"
	icon_state = "shopsign_merchant_right"
	plane = -1
	pixel_y = 16

/obj/structure/fluff/walldeco/sign/merchantsign/left
	name = "商会招牌"
	desc = "一块宣传商会服务的招牌——商会是一个遍及世界的广泛商人联盟。在这里，你或许能指望靠卖货赚到些钱，好歹不至于亏本，运气好的话还能凑够一顿饭钱。"
	icon_state = "shopsign_merchant_left"

/obj/structure/fluff/walldeco/psybanner
	name = "太阳教会旗帜"
	desc = "由深紫色丝绸与金色镶边织就的精美旗帜，这是太阳教会的标记。无论阿斯特拉塔的光芒照到世上的哪个角落，都能找到她的追随者——他们宣称对所有教派与神殿拥有至高权威。"
	icon_state = "Psybanner-PURPLE"

/obj/structure/fluff/walldeco/psybanner/red
	name = "奥塔瓦正教会旗帜"
	desc = "由深红丝绸与银线镶边织就的旗帜，这是奥塔瓦正教会的标记——它崇奉创世之神普赛顿，主宰着奥塔瓦国度，并派遣其宗教审判所到邻国铲除异端。"
	icon_state = "Psybanner-RED"

/obj/structure/fluff/walldeco/stone
	name = ""
	desc = ""
	icon_state = "walldec1"
	mouse_opacity = 0

/obj/structure/fluff/walldeco/stone/bronze
	color = "#ff9c1a"

/obj/structure/fluff/walldeco/church/line
	name = ""
	desc = ""
	icon_state = "churchslate"
	mouse_opacity = 0
	layer = ABOVE_NORMAL_TURF_LAYER+0.1
	plane = -8

/obj/structure/fluff/walldeco/stone/Initialize(mapload)
	icon_state = "walldec[rand(1,6)]"
	..()

/obj/structure/fluff/walldeco/maidensigil
	name = "石制纹章"
	desc = ""
	icon_state = "maidensigil"
	mouse_opacity = 0
	dir = SOUTH
	pixel_y = 32

/obj/structure/fluff/walldeco/maidensigil/r
	dir = WEST
	pixel_x = 16

/obj/structure/fluff/walldeco/bigpainting
	name = "暗林午夜"
	desc = "由旅行学者约翰·格吕恩瓦尔德在穿行大陆游历时所绘，这幅画描绘了格伦泽尔霍夫特荒野中的月夜之景。这幅画虽有许多复制品，但仍有少数备受珍视的原本存世。"
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "sherwoods"
	pixel_y = 32
	pixel_x = -16

/obj/structure/fluff/walldeco/bigpainting/lake
	name = "深红湖畔灯塔"
	desc = "由旅行学者约翰·格吕恩瓦尔德在游历各地时所作，这幅画描绘了奥塔瓦乡间一湾宁静的月下湖泊。此画在富人圈中颇受欢迎，即便是上好的复制品也能卖出可观的价钱。"
	icon_state = "lake"

/obj/structure/fluff/walldeco/mona
	name = "陈旧画作"
	desc = "一幅女子肖像画，画框已经风化，颜料正从画布上剥落。岁月并未善待这幅作品，但它仍自有一种独特的韵味。"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "mona"
	pixel_y = 32

/obj/structure/fluff/walldeco/chains
	name = "悬挂锁链"
	alpha = 180
	layer = 4.26
	icon_state = "chains1"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	can_buckle = 1
	buckle_lying = 0
	breakoutextra = 5 MINUTES
	buckleverb = "绑上"
	smeltresult = /obj/item/rope/chain

/obj/structure/fluff/walldeco/chains/Initialize(mapload)
	icon_state = "chains[rand(1,8)]"
	..()

/obj/structure/fluff/walldeco/customflag
	name = "腐木谷旗帜"
	desc = "迎着微风猎猎飘扬的，是一面结实牢固的领地旗帜，上面纹着城主家族的纹章。许多人将以为王室忠诚效力、身披此色为荣。"
	icon_state = "wallflag"

/obj/structure/fluff/walldeco/customflag/Initialize(mapload)
	. = ..()
	if(SSmapping.current_map.map_name == "Rockhill")
		name = "岩丘旗"
	else if(SSmapping.current_map.map_name == "Desert Town")
		name = "阿尔-阿舒尔旗"
		desc = "一面印着苏丹国骄傲纹章色的旗帜在微风中飘扬。"
	else if(SSmapping.current_map.map_name == "Build Your Own Settlement")
		name = "新王田旗"
		desc = "一面印着殖民地骄傲纹章色的旗帜在微风中飘扬。"
	else
		name = "腐木谷旗"
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/structure/fluff/walldeco/customflag/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/structure/fluff/walldeco/customflag/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "wallflag_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)
	M = mutable_appearance(icon, "wallflag_secondary", -(layer+0.1))
	M.color = secondary
	add_overlay(M)

/obj/structure/fluff/walldeco/moon
	name = "诺克派旗帜"
	desc = "一面镀银金属板上悬挂着深紫色的旗布，正中是一张咧嘴邪笑的月牙面孔；诺克的纹章呈现出深深沉思的表情，意在激发其侍僧的领悟力。"
	icon_state = "moon"

/obj/structure/fluff/walldeco/rpainting
	name = "暗黑静物画"
	desc = "一幅描绘覆布桌上的烛台与人类颅骨的画作，是一件朴素阴沉却不失雅致的艺术品。"
	icon_state = "painting_1"

/obj/structure/fluff/walldeco/rpainting/forest
	name = "森林画作"
	desc = "一幅描绘森林与远处雾中城堡的画作，当思绪自行填补细节时，一种神秘感油然而生。"
	icon_state = "painting_2"

/obj/structure/fluff/walldeco/rpainting/crown
	name = "王冠画作"
	desc = "一幅描绘高贵王冠的画作，王冠置于书本之上，旁边还有一颗苹果。这是一件简洁而优雅的作品，展现了一位优秀统治者生活中的基本要素。"
	icon_state = "painting_3"

/obj/structure/fluff/walldeco/med
	name = "冻伤图解"
	desc = "冻伤若不处理，可能导致严重烧伤和组织损伤。虽然回暖可以减轻伤害，但已有的冻伤必须加以治疗。切开患者皮肤，用止血钳夹住防止失血，拉开切口，用手术刀切除坏死组织，然后清创，再移除工具并缝合伤口。"
	icon_state = "medposter"

/obj/structure/fluff/walldeco/med2
	name = "眼部图解"
	desc = "眼部手术是一项精细的操作，需要专注与技巧。确保患者已麻醉无痛，然后小心地切开眼部，用止血钳与牵开器撑开以获得更好视野。谨慎操作眼球将其取出，放入替代品，切开以确保新眼获得健康的血液流通，然后清创并缝合部位。"
	icon_state = "medposter2"

/obj/structure/fluff/walldeco/med3
	name = "断肢接合图解"
	desc = "当肢体被切下时，必须在发生失血之前立即缝合。将肢体对准残端后，动脉将重新开启，你必须缝合肢体。使用骨钳将肢固定到位，然后用组织钳确保肌肉在患者开始活动后不会分离。最后以缝线收尾。"
	icon_state = "medposter3"

/obj/structure/fluff/walldeco/med4
	name = "毒素图解"
	desc = "毒素可迅速随血液传播并压垮患者，因此水蛭在现代医学中已不可或缺。普通水蛭会一直吸血直到完全饱胀，若提前扯下则会伤害患者。一些医学生有幸获得奇蛭——一种实用且特化的水蛭，轻按其腹部即可在吸血或输注血液之间切换。"
	icon_state = "medposter4"

/obj/structure/fluff/walldeco/med5
	name = "灵辉图解"
	desc = "灵辉作为将血液泵输全身的动力源，会自然地在心脏表面层层积聚。经悉心练习，可将其从表面刮取并收集以供进一步使用。这会使患者体弱，他们在自愿捐献灵辉后应适当休息。"
	icon_state = "medposter5"

/obj/structure/fluff/walldeco/med6
	name = "复苏图解"
	desc = "当新手医学生对如何复苏患者感到困惑时，复苏失败可能有几个原因。尽可能对患者进行诊断——问题可能在于失血、重大躯体创伤，甚至是持续性缺氧损伤。调整其体液平衡，处理瘀伤和烧伤，进行心肺复苏。若所有方法都无效，请向你的导师请教。"
	icon_state = "medposter6"

/obj/structure/fluff/walldeco/alarm
	name = "低语警报器"
	icon_state = "alarm"
	desc = "一个安装在墙上的警报装置。"
	pixel_y = 32
	var/next_yap = 0
	var/onoff = 1 //Init on

/obj/structure/fluff/walldeco/alarm/attack_hand(mob/living/user)

	user.changeNext_move(CLICK_CD_MELEE)

	if(!(HAS_TRAIT(user, TRAIT_NOBLE)))
		playsound(src, 'sound/misc/machineno.ogg', 100, TRUE, -1)
		say("把你的手从警报器上挪开，卑微生物！")
		return

	playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
	if(onoff == 0)
		onoff = 1
		icon_state = "alarm"
		say("警戒模式已重新启动。")
		next_yap = 0 //They won't believe us unless we yap again
		return
	if(onoff == 1)
		onoff = 0
		icon_state = "face"
		say("终于能稍作休息了。晚安。")
		return
	else //failsafe
		onoff = 1
		icon_state = "alarm"

/obj/structure/fluff/walldeco/alarm/Crossed(mob/living/user)

	if(onoff == 0)
		return

	if(next_yap > world.time) //Yap cooldown
		return

	if(ishuman(user)) //are we a person?
		var/mob/living/carbon/human/HU = user

		if(HU.anti_magic_check()) //are we shielded?
			return

		if(!(HU in SStreasury.bank_accounts)) //first off- do we not have an account? we'll ALWAYS scream if that's the case
			playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
			say("安全区域发现未知人员，立刻止步！！")
			loud_message("[src]发出尖叫般的警报声", hearing_distance = 12)
			next_yap = world.time + 6 SECONDS
			return

		if(HAS_TRAIT(user, TRAIT_NOBLE))
			say("向您致意，[user.real_name]。尊贵静默期三十息，现已生效。")
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			next_yap = world.time + 30 SECONDS
			return

		if((HU in SStreasury.bank_accounts)) //do we not have an account?
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			say("已记录侍民[user.real_name]进入安全区域。")
			return

		else //?????
			playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
			say("安全区域发现未授权人员，立刻止步！！")
			loud_message("[src]发出尖叫般的警报声", hearing_distance = 12)
			next_yap = world.time + 6 SECONDS

	else
		playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
		say("安全区域发现未知生物，立刻止步！！")
		loud_message("[src]发出尖叫般的警报声", hearing_distance = 12)
		next_yap = world.time + 6 SECONDS

/obj/structure/fluff/walldeco/vinez // overlay vines for more flexibile mapping
	name = "藤蔓"
	desc = "大自然正开始重新夺回此地，缓慢却坚定。"
	icon_state = "vinez"

/obj/structure/fluff/walldeco/vinez/l
	pixel_x = -32

/obj/structure/fluff/walldeco/vinez/r
	pixel_x = 32

/obj/structure/fluff/walldeco/vinez/offset
	name = "藤蔓"
	desc = "大自然正开始重新夺回此地，缓慢却坚定。"
	icon_state = "vinez"
	pixel_y = 32

/obj/structure/fluff/walldeco/vinez/blue
	name = "藤蔓"
	desc = "大自然正开始重新夺回此地，缓慢却坚定。"
	icon_state = "vinez_blue"

/obj/structure/fluff/walldeco/vinez/red
	name = "藤蔓"
	desc = "大自然正开始重新夺回此地，缓慢却坚定。"
	icon_state = "vinez_red"

/obj/structure/fluff/walldeco/bath // suggestive stonework
	name = "传情石雕"
	desc = "品味高雅、引人遐想的女性形态石雕，不花一分钱你就只能看到这种程度了。"
	icon_state = "bath1"
	pixel_x = -32
	alpha = 210

/obj/structure/fluff/walldeco/bath/two
	name = "媚诱石雕"
	desc = "令人浮想联翩、撩拨心弦的女性形态石雕，那身影似乎正召唤你靠近，然而当你触碰时，石头却冰冷而坚硬。"
	icon_state = "bath2"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/three
	name = "挑逗石雕"
	desc = "引人注目、细节丰富的男性形态石雕，其体魄如大力神般雄壮，扭曲于某种巨大的努力之中——它承诺良多，却毫无真实动作。"
	icon_state = "bath3"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/four
	name = "细腻石雕"
	desc = "令人印象深刻、富有魅惑的女性形态石雕，那人影引人靠近，然而你的触碰换不来任何回报，让人不禁想将钱币花到别处去。"
	icon_state = "bath4"
	pixel_y = 32
	pixel_x = 0

/obj/structure/fluff/walldeco/bath/five
	name = "香艳石雕"
	desc = "细节生动、引人遐想的女性形态石雕，那身姿摆出兴奋的姿态，凝固于极乐的瞬间。"
	icon_state = "bath5"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/six
	name = "慷慨石雕"
	desc = "撩拨感官、艳色难掩的女性形态石雕，那人影等待着观者的回应，却永远无法做出回馈。"
	icon_state = "bath6"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/seven
	name = "羞怯石雕"
	desc = "一幅俏皮而引人遐想的女性形态石雕，那人影用手指挑逗着旁观者，邀你奔赴一场永不会开始的激情之举。"
	icon_state = "bath7"
	pixel_x = 32

/obj/structure/fluff/walldeco/bath/gents
	name = "男浴标识"
	desc = "仅限绅士，敬请配合。"
	icon_state = "gents"
	pixel_x = 0
	pixel_y = 32

/obj/structure/fluff/walldeco/bath/ladies
	name = "女浴标识"
	desc = "仅限淑女，敬请配合。"
	icon_state = "ladies"
	pixel_x = 0
	pixel_y = 32

/obj/structure/fluff/walldeco/bath/wallrope
	name = "绳索"
	desc = "一根好绳子能解决大部分问题。"
	icon_state = "wallrope"
	layer = WALL_OBJ_LAYER+0.1
	pixel_x = 0
	pixel_y = 0
	color = "#d66262"

/obj/structure/fluff/walldeco/sign/saiga
	name = "醉醺羚羊"
	desc = "招牌上画着一头踉踉跄跄的野兽，就算吃不上什么好菜好饭，至少也能保证让你喝个烂醉。"
	icon_state = "shopsign_inn_saiga_right"
	plane = -1
	pixel_x = 3
	pixel_y = 16

/obj/structure/fluff/walldeco/sign/saiga/left
	icon_state = "shopsign_inn_saiga_left"

/obj/structure/fluff/walldeco/sign/trophy
	name = "赛加羚羊角战利品"
	desc = "一副固定在墙上的弯角赛加羚羊角战利品，猎手的骄傲。"
	icon_state = "saiga_trophy"
	pixel_y = 32

/obj/effect/decal/shadow_floor
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "shadow_floor"
	mouse_opacity = 0

/obj/effect/decal/shadow_floor/corner
	icon_state = "shad_floorcorn"


/obj/structure/fluff/walldeco/fakewall
	name = "墙……？"
	desc = "它看起来确实像一堵墙……"
	icon = 'icons/turf/walls/stone_wall.dmi'//change this
	icon_state = "stone"//change this
	density = FALSE
	opacity = TRUE
	max_integrity = 100

/obj/structure/fluff/walldeco/bogbanner
	name = "胜利旗帜"
	desc = "一面挂在墙上的红色旗帜，象征着对一切敌人的军事凯旋。"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "bogbanner-whole"
	layer = WALL_OBJ_LAYER+0.1

/obj/structure/fluff/walldeco/bogbanner/brown
	name = "遗忘者旗帜"
	desc = "一面挂在墙上的褪色残破旗帜，其纹章早已被遗忘殆尽。"
	icon_state = "bogbanner-brown"

/obj/structure/fluff/walldeco/bogbanner/zizo
	name = "亵渎旗帜"
	desc = "一面血迹斑斑的旗帜，其上绘有亵渎的齐佐十字，这是齐佐密教的骄傲徽记。"
	icon_state = "bogbanner-zizo"

/obj/structure/fluff/walldeco/bogbanner/bogguard
	name = "沼泽卫队旗帜"
	desc = "一面残破的旗帜，其上绘有一条蛇，这是一支本地沼泽民兵的骄傲军旗。其最后一批成员或死或逃，如今它已成了一段死灭希望的遗物。"
	icon_state = "bogbanner-snake"

/obj/structure/fluff/walldeco/bogbanner/bogguard/animated
	name = "沼泽卫队旗帜"
	desc = "一面残破的旗帜，其上绘有一条蛇，这是一支本地沼泽民兵的骄傲军旗。其最后一批成员或死或逃，如今它已成了一段死灭希望的遗物。"
	icon_state = "bogbanner-snake-anim"
