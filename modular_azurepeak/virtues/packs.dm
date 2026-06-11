// Virtue Packs - Triumph-cost combinations of virtues that make thematic sense together

/datum/virtue/pack
	/// List of virtue types that this pack grants
	var/list/granted_virtues = list()

/datum/virtue/pack/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	// Apply all virtues in the pack
	for(var/virtue_path in granted_virtues)
		var/datum/virtue/V = GLOB.virtues[virtue_path]
		if(V)
			// Apply the virtue's effects without checking triumphs (pack already cost triumphs)
			V.apply_to_human(recipient)
			V.handle_traits(recipient)
			V.handle_skills(recipient)
			V.handle_stashed_items(recipient)
			V.handle_added_languages(recipient)
			V.handle_stats(recipient)

// Bronze Golem Pack: Both Bronze Arms
// For those who have replaced both arms with mechanical prosthetics
/datum/virtue/pack/bronzegolem
	name = "青铜魔像（-3 TRI）"
	desc = "出于财富、厄运，或也许只是实验，我的双臂都被青铜义肢所取代。我半人半机，是一具行走着的工艺明证。"
	triumph_cost = 3
	granted_virtues = list(
		/datum/virtue/utility/bronzearm_r,
		/datum/virtue/utility/bronzearm_l
	)
	custom_text = "授予双重青铜臂美德：\n\
	- 青铜臂（右）：右臂替换为青铜义肢\n\
	- 青铜臂（左）：左臂替换为青铜义肢\n\
	- 因钻研机关结构而获得+1工程技能"

// Enchanting Performer Pack: Socialite + Performer + Second Voice
// For entertainers, bards, and charismatic performers
/datum/virtue/pack/enchanter
	name = "迷人演者（-12 TRI）"
	desc = "无论舞台还是沙龙，我都是其中的主人。美丽、多才，也能凭借声音与魅力化身万千人物。我的表演令人沉醉，而我的社交风度足以打开每一扇门。"
	triumph_cost = 12
	granted_virtues = list(
		/datum/virtue/utility/socialite,
		/datum/virtue/utility/performer,
		/datum/virtue/utility/secondvoice
	)
	custom_text = "授予三项完美艺人的美德：\n\
	- 社交名流：美丽、共情、善于取悦他人等特质，并藏有一面手镜\n\
	- 表演者：可选择藏起的乐器，音乐技能+4，并获得胡桃夹子\n\
	- 第二嗓音：能够完美模仿另一道声音，并在两者之间切换"

// Traveling Scholar Pack: Linguist + Rich and Shrewd + Equestrian
// For worldly scholars who have traveled extensively and accumulated wealth and knowledge
/datum/virtue/pack/travelingscholar
	name = "游历学者（-15 TRI）"
	desc = "远方旅途让我在财富与见识上都变得富足。我会说多种语言，懂得万物价值，也能熟练骑乘。世界便是我的图书馆，每一条道路都在教我新的东西。"
	triumph_cost = 15
	granted_virtues = list(
		/datum/virtue/utility/linguist,
		/datum/virtue/items/rich,
		/datum/virtue/utility/riding
	)
	custom_text = "授予三项见多识广旅者的美德：\n\
	- 智识之人：智力+1，阅读+3，可选择3门语言，可查看属性，并藏有制书工具包（INTELLECTUAL）\n\
	- 富有而精明：获得鉴价法术、查看价格能力，并藏有钱袋（SEEPRICES）\n\
	- 骑术娴熟：可召来并与珍爱的坐骑建立联系，获得学徒级骑术、藏有马鞍，并可在骑乘时穿门而过（EQUESTRIAN）"

// Scrappy Survivor Pack: Cunning Provisioner + Forester + Feral Appetite
/datum/virtue/pack/scrappysurvivor
	name = "顽强求生者（-10 TRI）"
	desc = "我熬过了艰难岁月。贫穷、饥荒或流放都教会了我如何靠手头之物活下去。我会捕鱼、耕种、采集，而最重要的是，我什么都吃得下。变质口粮？生肉？无所谓，我吃完照样继续前行。"
	triumph_cost = 10
	granted_virtues = list(
		/datum/virtue/utility/forester,
		/datum/virtue/utility/feral_appetite
	)
	custom_text = "授予两项老练幸存者的美德：\n\
	- 林野之人：获得烹饪、运动、耕作、捕鱼、伐木技能与一把可靠锄头（HOMESTEAD_EXPERT 特质）\n\
	- 野性胃口：可安全食用生食、有毒或腐坏食物（NASTY_EATER 特质）"

// High Society Pack: Nobility + Socialite
/datum/virtue/pack/highsociety
	name = "上流社会（-12 TRI）"
	desc = "我生来便享有特权，在最上等的圈子里长大。贵族之血流淌于我体内，我能轻易读出他人情绪，而我的魅力足以打开每一扇门。财富、美貌与地位，本就是我的天赋权利。"
	triumph_cost = 12
	granted_virtues = list(
		/datum/virtue/utility/noble,
		/datum/virtue/utility/socialite
	)
	custom_text = "授予两项贵族美德：\n\
	- 贵胄：贵族身份、阅读技能、+15贵族收入，并藏有传家护符与厚实钱袋\n\
	- 社交名流：美丽、共情、善于取悦他人等特质，并藏有一面手镜"

// Trusted Housekeeper Pack: Resident + Cunning Provisioner
/datum/virtue/pack/housekeeper
	name = "可靠管家（-9 TRI）"
	desc = "我已在这座城市的各个宅邸中服务多年，负责烹饪、清扫与管理储备。我熟悉每一条街道，在此也有自己的住处，而我的厨艺更是无人能及。城市信任我，我也知道如何把日子过下去。"
	triumph_cost = 9
	granted_virtues = list(
		/datum/virtue/utility/resident,
		/datum/virtue/utility/granary
	)
	custom_text = "授予两项城市仆役的美德：\n\
	- 居民：城市居民身份、金库账户与城内居所\n\
	- 精明补给者：烹饪与捕鱼技能，并藏有食物袋（HOMESTEAD_EXPERT）"

// Broken Soul Pack: Ugly + Tolerant + Deadened
/datum/virtue/pack/brokensoul
	name = "破碎灵魂（-3 TRI）"
	desc = "生活待我残酷。我的外貌令旁人退避三舍，我学会了承受多数人无法承受之物，而我麻木得太久，几乎已记不起情感原本是什么样子。我是靠苦难存活至今的活生生证明。"
	triumph_cost = 3
	granted_virtues = list(
		/datum/virtue/utility/ugly,
		/datum/virtue/utility/tolerant,
		/datum/virtue/utility/deadened
	)
	custom_text = "授予三项弃民美德：\n\
	- 丑陋：外貌不堪，不受尸臭影响（UNSEEMLY + NOSTINK 特质）\n\
	- 宽容：对某些种族不再产生压力，接受面更广\n\
	- 麻木：完全失去情感（NOMOOD 特质）"
