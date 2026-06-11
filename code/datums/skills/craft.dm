/datum/skill/craft
	abstract_type = /datum/skill/craft
	name = "制造"
	desc = ""
	color = "#4e7bb1"

/datum/skill/craft/crafting
	name = "通用制造"
	desc = "决定我是否能够制作不属于其他制造技能分类的各类物品。"
	dreams = list(
		"...当我望向草甸时，脚下能感到青草的触感；我架起篝火与帐篷，随后沉沉睡去……",
		"...我用湖边采来的木头与石头做成铲子，在泥地里翻找蠕虫。鱼竿静静立在一旁，迫不及待要为我带来一餐，就像祖父教我的那样……"
	)
	expert_name = "工匠"

/datum/skill/craft/weaponsmithing
	name = "武器锻造"
	desc = "决定我是否能够锻造各类武器。也是在工作台上成功修复武器所必需的技能。"
	dreams = list(
		"...在黄金与虚无中淬炼，只以日月开锋，我的造物终于完成。这一把……这一把将刺穿天穹……",
		"...汗水顺着额头滑落，每一次敲击都让手臂酸痛不已，但终于，刀刃成形了。这是一件钢铁与黄金铸成、镶着 rontz 宝石的杰作……",
		"...一位老猎人站在柜台前，张口就要两打箭矢。他笑着递给我一捆木枝……"
	)
	expert_name = "武器匠"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY, TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/armorsmithing
	name = "护甲锻造"
	desc = "决定我是否能够锻造各类护甲。也是在工作台上成功修复护甲所必需的技能。"
	dreams = list(
		"...我立于 deadite 群中，它们的牙与爪都无法在我的护甲上留下凹痕。那是我的造物。我的杰作……",
		"...老兵那副残破得几乎认不出的护甲，正如他身上的伤疤一般累累。可若不是我的手艺，他早已倒下。凭借熟练的双手与半日工夫，这副护甲重获新生，比初锻成时更坚固……"
	)
	expert_name = "甲匠"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY, TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/blacksmithing
	name = "铁匠"
	desc = "决定我是否能够锻造武器和护甲之外的各类铁器。也是在工作台上成功修复它们所必需的技能。"
	dreams = list(
		"...我低头听着老匠人的训斥，他责怪我整夜疏于照看熔炉，实在太过浪费……",
		"...我不断锤打着一块奇异的蓝色金属。它仿佛在诱惑我，乞求自己被塑造成一顶秘密之冠……",
		"...炉火已经点燃，锻炉轰然咆哮。今天是个好日子，火焰之主祝福了我的铁匠铺，让它成为世间最伟大的那一座……"
	)
	expert_name = "铁匠大师"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY, TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/smelting
	name = "冶炼"
	desc = "提高我冶炼出的锭材品质，从而提升它们的售价，但不会影响成品的实际功能。"
	dream_cost_base = 1
	dreams = list(
		"...矿渣化作闪亮碎片剥落，只剩下一条发光的银锭。它带着某种使命般的光泽，已准备好被塑形成器……",
		"...我在炉火的高温下无休无止地劳作；每一次投献，火焰都会咆哮着回赠我可供塑形的金属……"

	)
	expert_name = "冶炼师"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY, TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)


/datum/skill/craft/carpentry
	name = "木工"
	desc = "决定我是否能够制作并修复各类木制物品与结构，包括木制义肢。"
	dreams = list(
		"...我精准地落下一锤，将又一枚木钉敲入原位。我的技艺把单纯的木头化作庇护与安逸……",
		"...随着我架起一根又一根梁木，房屋逐渐成形。新木与锯屑的气味充满空气，墙面拔地而起，屋顶也开始闭合。这是从我双手中诞生的居所……",
		"...我坐了下来，却听不见半点声响，完全没有。那令人发毛的吱呀噩梦终于散去，我的思绪开始回到它的构造本身……"
	)
	expert_name = "木匠"
	// Niche skill, no gating

/datum/skill/craft/masonry
	name = "石工"
	desc = "决定我是否能够制作并修复各类石制品、宝石制品。"
	dreams = list(
		"...一座堡垒。坚不可摧。长存不朽。一砖一砖，一层一层，一石再一石。这便是我的得意之作。这便是创造之道……",
		"...“3、4 和 5 可以导出 90 度角。”那位漂泊于虚空中的老精灵师傅这样告诉我，并向我展示石匠角尺如何同时指引寻常与奇异的角度……"
	)
	expert_name = "石匠"
	// No longer niche with gemcarving etc
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/engineering
	name = "工程"
	desc = "决定我是否能够制作或修复各类机械结构，包括拉杆、活板门，以及青铜义肢、抓钩等青铜制品。"
	dreams = list(
		"...那些奇异装置对我而言如同熟面孔。我的机器内部运作皆系于齿轮。齿轮便是它们的心脏、它们的头脑、它们的意志……",
		"...三根拉杆摆在我面前。一根会把我投入酸液，一根会放出毒气，只有一根能让我脱困。月光恰好照在其中之一上，而我伸出了手……",
		"...我以稳定的双手塑造一条新肢体，每一个关节与齿轮都为补回失去之物而设计。我的工作是一份沉默的承诺；他们将再次行走……"
	)
	expert_name = "工程师"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY, TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)


/datum/skill/craft/cooking
	name = "烹饪"
	desc = "提高烹饪与食材处理速度。未掌握时为 -25%，新手为 0%，之后每级 +50%。达到熟练工后，我可以在桶中发酵作物。"
	dreams = list(
		"...在噼啪作响的营火上，一大块新鲜肉排滋滋作响，香气弥漫四周。最简单的料理，往往也是最难臻于完美的……",
		"...我的刀压上整轮奶酪，细细削去表皮上的瑕疵。接下来是鸡蛋与面团，它们很快就会揉合成一道美妙餐食……",
		"...一个独眼厨子当着我的面开始捣碎苹果，再把它们填进派皮里。他一边教我那秘密配料，一边几乎止不住流口水……"
	)
	expert_name = "厨师"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SURVIVAL_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/sewing
	name = "缝纫"
	desc = "决定我是否能够制作并修复各类缝纫相关物品。"
	dreams = list(
		"...随着岁月流逝，那句箴言也越发令人窒息。缝、织、断线，缝、织、再把针引两次线……",
		"...我翻过布料，在礼服的两层夹里缝进一个秘密，把自己的姓名缩写藏在里面。在某些文化中，这是禁忌的记号……反正我本来也不太喜欢那位新娘……"
	)
	expert_name = "裁缝"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SEWING_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SURVIVAL_EXPERT = SKILL_LEVEL_JOURNEYMAN,
	TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_JOURNEYMAN,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/tanning
	name = "皮革工艺"
	desc = "决定我是否能够制作或修复各类皮革制品。还能缩短鞣皮架上的作业时间，并使每级技能为每张皮最低产出额外 +1，同时提高从鞣制毛皮中获得 wilderness essence 的几率。"
	dreams = list(
		"...我的刀刃刮去皮上的肉与脂肪，将这张毛皮处理干净，使它终能被制成献给领主的华美披风……",
		"...那名猎人嗓音粗糙如树皮，皮肤也像木纹般饱经风霜；他一边向我展示缝制手法，一边发出爽朗大笑……"
	)
	expert_name = "鞣皮匠"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_SEWING_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SURVIVAL_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_JOURNEYMAN,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/ceramics
	name = "陶艺"
	desc = "负责将黏土制作成花瓶及其他精致工艺品。"
	dreams = list(
		"...陶轮不断旋转、旋转……而我看着一件艺术品从它中央缓缓生长出来……",
		"...一团黏土被塑成了一尊美丽雕像。这是对 Malum 祝福与 Xylix 灵感的见证。是一件纯粹的美之作……"
	)
	expert_name = "陶匠"
	max_untraited_level = SKILL_LEVEL_APPRENTICE
	trait_uncap = list(TRAIT_HOMESTEAD_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SMITHING_EXPERT = SKILL_LEVEL_LEGENDARY,
	TRAIT_SELF_SUSTENANCE = SKILL_LEVEL_JOURNEYMAN)

/datum/skill/craft/alchemy
	name = "炼金术"
	desc = "决定我能够酿制何种药剂，以及我能接触到哪些嬗变与炼金配方。"
	dreams = list(
		"...硫磺的气味灼烧着我的鼻腔……我尝到了铁锈味……烟雾散去时，我低头望进坩埚中的倒影……那位 Queen 正回望着我……她看起来像是在哭泣……"
	)
	expert_name = "炼金术师"
	max_untraited_level = SKILL_LEVEL_JOURNEYMAN // Special, we just gate the best potions away
	trait_uncap = list(TRAIT_ALCHEMY_EXPERT = SKILL_LEVEL_LEGENDARY)

/datum/skill/craft/alchemy/skill_level_effect(level, datum/mind/mind)
	if(level > SKILL_LEVEL_MASTER)
		ADD_TRAIT(mind?.current, TRAIT_LEGENDARY_ALCHEMIST, type)
		//SEND_GLOBAL_SIGNAL(COMSIG_ATOM_ADD_TRAIT, (mind?.current, TRAIT_LEGENDARY_ALCHEMIST)
	else if(HAS_TRAIT(mind?.current, TRAIT_LEGENDARY_ALCHEMIST))
		REMOVE_TRAIT(mind?.current, TRAIT_LEGENDARY_ALCHEMIST, type)
		//SEND_GLOBAL_SIGNAL(COMSIG_ATOM_ADD_TRAIT, (mind?.current, TRAIT_LEGENDARY_ALCHEMIST)
