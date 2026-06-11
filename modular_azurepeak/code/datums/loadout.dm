GLOBAL_LIST_EMPTY(loadout_items)

/datum/loadout_item
	var/name = "父级负载数据"
	var/desc
	var/path
	var/donoritem			//autoset on new if null
	var/list/ckeywhitelist
	var/triumph_cost
	var/keep_loadout_stats = FALSE	// If TRUE, item keeps default values (not nerfed)

/datum/loadout_item/New()
	if(isnull(donoritem))
		if(ckeywhitelist)
			donoritem = TRUE
	if (triumph_cost)
		desc += "消耗[triumph_cost]点凯旋点数。"

/datum/loadout_item/proc/donator_ckey_check(key)
	if(ckeywhitelist && ckeywhitelist.Find(key))
		return TRUE
	return

/datum/loadout_item/proc/nobility_check(client/C)
	// Override this in subtypes that require nobility
	return TRUE

//Miscellaneous

/datum/loadout_item/card_deck
	name = "纸牌组"
	path = /obj/item/toy/cards/deck

/datum/loadout_item/farkle_dice
	name = "法克尔骰子容器"
	path = /obj/item/storage/pill_bottle/dice/farkle

/datum/loadout_item/gaming_dice
	name = "游戏骰子容器"
	path = /obj/item/storage/pill_bottle/dice

/datum/loadout_item/dwarven_dice
	name = "矮人骰子容器"
	path = /obj/item/storage/pill_bottle/dice/dwarven

/datum/loadout_item/bakers_dozen_dice
	name = "面包师十三骰子容器"
	path = /obj/item/storage/pill_bottle/dice/bakers_dozen

/datum/loadout_item/threes_away_dice
	name = "三去无踪骰子容器"
	path = /obj/item/storage/pill_bottle/dice/threes_away

/datum/loadout_item/dice_war_dice
	name = "骰战容器"
	path = /obj/item/storage/pill_bottle/dice/dice_war

/datum/loadout_item/liars_dice
	name = "吹牛骰子容器"
	path = /obj/item/storage/pill_bottle/dice/liars_dice

/datum/loadout_item/dice_poker
	name = "扑克骰子容器"
	path = /obj/item/storage/pill_bottle/dice/dice_poker

/datum/loadout_item/tarot_deck
	name = "塔罗牌组"
	path = /obj/item/toy/cards/deck/tarot

/datum/loadout_item/tarot_deck_majorarcana
	name = "塔罗牌组（大阿卡那）"
	path = /obj/item/toy/cards/deck/tarot/majorarcana

/datum/loadout_item/custom_book
	name = "自定义书籍"
	path = /obj/item/paper/scroll/custom

/datum/loadout_item/hand_mirror
	name = "手镜"
	path = /obj/item/handmirror

//TOOLS

/datum/loadout_item/bauernwehr
	name = "农夫短剑"
	path = /obj/item/rogueweapon/huntingknife/throwingknife/bauernwehr
	triumph_cost = 3

/datum/loadout_item/broom
	name = "扫帚"
	path = /obj/item/broom
	triumph_cost = 1

/datum/loadout_item/soap
	name = "肥皂"
	path = /obj/item/soap
	triumph_cost = 3

/datum/loadout_item/candle
	name = "蜡烛"
	path = /obj/item/candle/yellow
	triumph_cost = 1

/datum/loadout_item/keyring
	name = "钥匙环"
	path = /obj/item/storage/keyring
	triumph_cost = 3

/datum/loadout_item/wooden_bowl
	name = "碗"
	path = /obj/item/reagent_containers/glass/bowl
	triumph_cost = 1

/datum/loadout_item/wooden_cup
	name = "杯子"
	path = /obj/item/reagent_containers/glass/cup/wooden
	triumph_cost = 1

/datum/loadout_item/bottle
	name = "瓶子"
	path = /obj/item/reagent_containers/glass/bottle/rogue
	triumph_cost = 1

/datum/loadout_item/waterskin
	name = "水袋"
	path = /obj/item/reagent_containers/glass/bottle/waterskin
	triumph_cost = 2

/datum/loadout_item/flint
	name = "燧石"
	path = /obj/item/flint
	triumph_cost = 2

/datum/loadout_item/aaneedle
	name = "刺针"
	path = /obj/item/needle/thorn
	triumph_cost = 2

/datum/loadout_item/bandage_roll
	name = "一卷绷带"
	path = /obj/item/natural/bundle/cloth/bandage/full
	triumph_cost = 3

/datum/loadout_item/sack
	name = "麻袋"
	path = /obj/item/storage/roguebag
	triumph_cost = 2

/datum/loadout_item/mallet
	name = "木槌"
	path = /obj/item/rogueweapon/hammer/wood
	triumph_cost = 3

//ANCIENT TOOLS (Ancient Alloy)

/datum/loadout_item/ancient_hammer
	name = "古代锤"
	path = /obj/item/rogueweapon/hammer/ancient/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_tongs
	name = "古代铁钳"
	path = /obj/item/rogueweapon/tongs/ancient/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_pick
	name = "古代镐"
	path = /obj/item/rogueweapon/pick/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_shovel
	name = "古代铲"
	path = /obj/item/rogueweapon/shovel/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_hoe
	name = "古代锄"
	path = /obj/item/rogueweapon/hoe/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_sickle
	name = "古代镰刀"
	path = /obj/item/rogueweapon/sickle/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_thresher
	name = "古代连枷"
	path = /obj/item/rogueweapon/thresher/decrepit
	triumph_cost = 3

/datum/loadout_item/ancient_pitchfork
	name = "古代干草叉"
	path = /obj/item/rogueweapon/pitchfork/decrepit
	triumph_cost = 3

//COOKWARE
/datum/loadout_item/ancient_pan
	name = "古代平底锅"
	path = /obj/item/cooking/pan/decrepit
	triumph_cost = 2

/datum/loadout_item/ancient_pot
	name = "古代锅"
	path = /obj/item/reagent_containers/glass/bucket/pot/decrepit
	triumph_cost = 2

/datum/loadout_item/ancient_platter
	name = "古代大盘"
	path = /obj/item/cooking/platter/decrepit
	triumph_cost = 2

/datum/loadout_item/ancient_bowl
	name = "古代碗"
	path = /obj/item/reagent_containers/glass/bowl/decrepit
	triumph_cost = 2

/datum/loadout_item/ancient_mug
	name = "古代杯"
	path = /obj/item/reagent_containers/glass/cup/decrepitmug
	triumph_cost = 2

/datum/loadout_item/ancient_goblet
	name = "古代高脚杯"
	path = /obj/item/reagent_containers/glass/cup/decrepitgob
	triumph_cost = 2

/datum/loadout_item/ancient_spoon
	name = "古代勺"
	path = /obj/item/kitchen/spoon/decrepit
	triumph_cost = 2

/datum/loadout_item/ancient_fork
	name = "古代叉"
	path = /obj/item/kitchen/fork/decrepit
	triumph_cost = 2

// TENT KITS

/datum/loadout_item/small_tent
    name = "Small Tent"
    path = /obj/item/tent_kit
    triumph_cost = 4

/datum/loadout_item/ger_kit
    name = "Ger Tent"
    path = /obj/item/tent_kit/ger
    triumph_cost = 6

/datum/loadout_item/yurt_tent
     name = "Yurt Tent"
     path = /obj/item/tent_kit/yurt
     triumph_cost = 8

//HATS
/datum/loadout_item/shalal
	name = "库菲耶头巾"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal

/datum/loadout_item/tricorn
	name = "三角帽"
	path = /obj/item/clothing/head/roguetown/helmet/tricorn

/datum/loadout_item/maidband
	name = "女仆发带"
	path = /obj/item/clothing/head/roguetown/maidband

/datum/loadout_item/nurseveil
	name = "护士面纱"
	path = /obj/item/clothing/head/roguetown/veiled

/datum/loadout_item/archercap
	name = "弓手帽"
	path = /obj/item/clothing/head/roguetown/archercap

/datum/loadout_item/articap
	name = "工匠帽"
	path = /obj/item/clothing/head/roguetown/articap

/datum/loadout_item/strawhat
	name = "草帽"
	path = /obj/item/clothing/head/roguetown/strawhat

/datum/loadout_item/witchhat
	name = "女巫帽"
	path = /obj/item/clothing/head/roguetown/witchhat

/datum/loadout_item/witchhat/old
	name = "女巫帽（旧式）"
	path = /obj/item/clothing/head/roguetown/witchhat/old

/datum/loadout_item/bardhat
	name = "诗人帽"
	path = /obj/item/clothing/head/roguetown/bardhat

/datum/loadout_item/duelhat
	name = "决斗帽"
	path = /obj/item/clothing/head/roguetown/duelisthat

/datum/loadout_item/fancyhat
	name = "华丽帽"
	path = /obj/item/clothing/head/roguetown/fancyhat

/datum/loadout_item/furhat
	name = "毛皮帽"
	path = /obj/item/clothing/head/roguetown/hatfur

/datum/loadout_item/smokingcap
	name = "便帽"
	path = /obj/item/clothing/head/roguetown/smokingcap

/datum/loadout_item/headband
	name = "发带"
	path = /obj/item/clothing/head/roguetown/headband

/datum/loadout_item/buckled_hat
	name = "搭扣帽"
	path = /obj/item/clothing/head/roguetown/puritan

/datum/loadout_item/folded_hat
	name = "折帽"
	path = /obj/item/clothing/head/roguetown/bucklehat

/datum/loadout_item/duelist_hat
	name = "决斗者之帽"
	path = /obj/item/clothing/head/roguetown/duelhat

/datum/loadout_item/hood
	name = "兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood

/datum/loadout_item/necromhood
    name = "Necromancer Hood"
    path = /obj/item/clothing/head/roguetown/necromhood

/datum/loadout_item/hijab
	name = "头巾"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab

/datum/loadout_item/heavyhood
	name = "厚兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood

/datum/loadout_item/nunveil
	name = "修女面纱"
	path = /obj/item/clothing/head/roguetown/nun

/datum/loadout_item/papakha
	name = "高筒毛皮帽"
	path = /obj/item/clothing/head/roguetown/papakha

/datum/loadout_item/rosa_crown
	name = "玫瑰花冠"
	path = /obj/item/flowercrown/rosa

/datum/loadout_item/salvia_crown
	name = "鼠尾草花冠"
	path = /obj/item/flowercrown/salvia

/datum/loadout_item/tri_grenzelhoft_hat_capless
	name = "无顶格伦泽尔霍夫特帽"
	path = /obj/item/clothing/head/roguetown/caplessgrenzelhofthat

/datum/loadout_item/loadoutpapakha
	name = "Soft-sided papakha"
	path = /obj/item/clothing/head/roguetown/loadoutpapakha

//CLOAKS
/datum/loadout_item/tabard
	name = "战袍"
	path = /obj/item/clothing/cloak/tabard

/datum/loadout_item/tabard/astrata
	name = "阿斯特拉塔战袍"
	path = /obj/item/clothing/cloak/templar/astrata

/datum/loadout_item/tabard/noc
	name = "诺克战袍"
	path = /obj/item/clothing/cloak/templar/noc

/datum/loadout_item/tabard/dendor
	name = "登多尔战袍"
	path = /obj/item/clothing/cloak/templar/dendor

/datum/loadout_item/tabard/malum
	name = "玛勒姆战袍"
	path = /obj/item/clothing/cloak/templar/malum

/datum/loadout_item/tabard/eora
	name = "伊欧拉战袍"
	path = /obj/item/clothing/cloak/templar/eora

/datum/loadout_item/tabard/pestra
	name = "佩斯特拉战袍"
	path = /obj/item/clothing/cloak/templar/pestra

/datum/loadout_item/tabard/ravox
	name = "拉沃克斯战袍"
	path = /obj/item/clothing/cloak/cleric/ravox

/datum/loadout_item/tabard/abyssor
	name = "阿比索尔战袍"
	path = /obj/item/clothing/cloak/templar/abyssor

/datum/loadout_item/tabard/necra
	name = "内克拉战袍"
	path = /obj/item/clothing/cloak/templar/necra

/datum/loadout_item/tabard/psydon
	name = "普赛顿战袍"
	path = /obj/item/clothing/cloak/templar/psydon

/datum/loadout_item/surcoat
	name = "外罩战袍"
	path = /obj/item/clothing/cloak/stabard

/datum/loadout_item/jupon
	name = "罩袍"
	path = /obj/item/clothing/cloak/stabard/surcoat

/datum/loadout_item/cape
	name = "披肩"
	path = /obj/item/clothing/cloak/cape

/datum/loadout_item/halfcloak
	name = "半披风"
	path = /obj/item/clothing/cloak/half

/datum/loadout_item/duelcape
	name = "决斗者披风"
	path = /obj/item/clothing/cloak/duelistcape

/datum/loadout_item/ridercloak
	name = "骑手斗篷"
	path = /obj/item/clothing/cloak/half/rider

/datum/loadout_item/raincloak
	name = "雨披"
	path = /obj/item/clothing/cloak/raincloak

/datum/loadout_item/furcloak
	name = "毛皮斗篷"
	path = /obj/item/clothing/cloak/raincloak/furcloak

/datum/loadout_item/direcloak
	name = "恐熊斗篷"
	path = /obj/item/clothing/cloak/darkcloak/bear

/datum/loadout_item/lightdirecloak
	name = "轻型恐熊斗篷"
	path = /obj/item/clothing/cloak/darkcloak/bear/light

/datum/loadout_item/volfmantle
	name = "沃尔夫披肩"
	path = /obj/item/clothing/cloak/volfmantle

/datum/loadout_item/eastcloak2
	name = "皮斗篷"
	path = /obj/item/clothing/cloak/eastcloak2

/datum/loadout_item/thief_cloak
	name = "无赖披巾"
	path = /obj/item/clothing/cloak/thief_cloak

/datum/loadout_item/wicker_cloak
	name = "柳编斗篷"
	path = /obj/item/clothing/cloak/wickercloak
/datum/loadout_item/tabardscarlet
	name = "绯红战袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/tabardscarlet

/datum/loadout_item/shroudscarlet
	name = "绯红战袍披巾"
	path = /obj/item/clothing/head/roguetown/roguehood/shroudscarlet

/datum/loadout_item/tabardblack
	name = "黑色战袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/tabardblack

/datum/loadout_item/shroudblack
	name = "黑色战袍披巾"
	path = /obj/item/clothing/head/roguetown/roguehood/shroudblack

/datum/loadout_item/tabardwhite
	name = "白色战袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/tabardwhite

/datum/loadout_item/shroudwhite
	name = "白色战袍披巾"
	path = /obj/item/clothing/head/roguetown/roguehood/shroudwhite

/datum/loadout_item/poncho
	name = "披毯"
	path = /obj/item/clothing/cloak/poncho

/datum/loadout_item/guardhood
	name = "守卫兜帽"
	path = /obj/item/clothing/cloak/stabard/guardhood

//SHOES
/datum/loadout_item/darkboots
	name = "深色靴"
	path = /obj/item/clothing/shoes/roguetown/boots

/datum/loadout_item/babouche
	name = "软皮拖鞋"
	path = /obj/item/clothing/shoes/roguetown/shalal

/datum/loadout_item/nobleboots
	name = "贵族靴"
	path = /obj/item/clothing/shoes/roguetown/boots/nobleboot

/datum/loadout_item/sandals
	name = "凉鞋"
	path = /obj/item/clothing/shoes/roguetown/sandals

/datum/loadout_item/toga_sandals
	name = "华丽凉鞋"
	path = /obj/item/clothing/shoes/roguetown/sandals/toga_sandals

/datum/loadout_item/shortboots
	name = "短靴"
	path = /obj/item/clothing/shoes/roguetown/shortboots

/datum/loadout_item/gladsandals
	name = "角斗士凉鞋"
	path = /obj/item/clothing/shoes/roguetown/gladiator

/datum/loadout_item/ridingboots
	name = "骑靴"
	path = /obj/item/clothing/shoes/roguetown/ridingboots

/datum/loadout_item/ankletscloth
	name = "布踝带"
	path = /obj/item/clothing/shoes/roguetown/boots/clothlinedanklets

/datum/loadout_item/ankletsfur
	name = "毛皮踝带"
	path = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets

/datum/loadout_item/exoticanklets
	name = "异域踝带"
	path = /obj/item/clothing/shoes/roguetown/anklets

/datum/loadout_item/rumaclanshoes
	name = "高底凉鞋"
	path = /obj/item/clothing/shoes/roguetown/armor/rumaclan

/datum/loadout_item/simpleshoes
	name = "简易鞋"
	path = /obj/item/clothing/shoes/roguetown/simpleshoes

//SHIRTS
/datum/loadout_item/longcoat
	name = "长外套"
	path = /obj/item/clothing/suit/roguetown/armor/longcoat

/datum/loadout_item/robe
	name = "长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe

/datum/loadout_item/Necromrobe
    name = "Necromancer Robes"
    path = /obj/item/clothing/suit/roguetown/shirt/robe/necromancer

/datum/loadout_item/phys_robe
	name = "医者长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/phys

/datum/loadout_item/feld_robe
	name = "军医长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/feld

/datum/loadout_item/formalsilks
	name = "礼服丝衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan

/datum/loadout_item/longshirt
	name = "衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/black

/datum/loadout_item/shortshirt
	name = "短袖衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/shortshirt

/datum/loadout_item/sailorshirt
	name = "条纹衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor

/datum/loadout_item/sailorshirt_colorable
	name = "Striped Shirt (Colorable)"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/colored

/datum/loadout_item/sailorjacket
	name = "皮夹克"
	path = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor

/datum/loadout_item/artijacket
	name = "工匠夹克"
	path = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket

/datum/loadout_item/priestrobe
	name = "内衬衣物"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest

/datum/loadout_item/exoticsilkbra
	name = "异域丝胸衣"
	path = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra

/datum/loadout_item/bottomtunic
	name = "低领束腰衫"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut

/datum/loadout_item/tribalrag
	name = "部族布衣"
	path = /obj/item/clothing/suit/roguetown/shirt/tribalrag

/datum/loadout_item/tunic
	name = "束腰衫"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic

/datum/loadout_item/stripedtunic
	name = "条纹束腰衫"
	path = /obj/item/clothing/suit/roguetown/armor/workervest

/datum/loadout_item/formalshirt
	name = "礼服衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal

/datum/loadout_item/servantdress
	name = "仆役长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/maid/servant

/datum/loadout_item/maiddress
	name = "女仆长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/maid

/datum/loadout_item/dress
	name = "长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen

/datum/loadout_item/dress/bardress
	name = "酒馆女侍长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress

/datum/loadout_item/dress/chemise
	name = "衬裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress

/datum/loadout_item/dress/sexydress
	name = "轻薄长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy

/datum/loadout_item/dress/straplessdress
	name = "抹胸长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless

/datum/loadout_item/dress/straplessdress/alt
	name = "抹胸长裙（别式）"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/alt

/datum/loadout_item/dress/silkydress
	name = "丝质长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress

/datum/loadout_item/dress/nobledress
	name = "贵族长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/noble

/datum/loadout_item/dress/velvetdress
	name = "天鹅绒长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/velvet

/datum/loadout_item/dress/winterdress_light
	name = "寒地长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/winterdress_light

/datum/loadout_item/gown
	name = "春装礼裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown

/datum/loadout_item/gown/summer
	name = "夏装礼裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown

/datum/loadout_item/gown/fall
	name = "秋装礼裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown

/datum/loadout_item/gown/winter
	name = "冬装礼裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown

/datum/loadout_item/gown/silkydress
	name = "丝裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress

/datum/loadout_item/noblecoat
	name = "华丽外套"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat

/datum/loadout_item/leathervest
	name = "皮背心"
	path = /obj/item/clothing/suit/roguetown/armor/leather/vest

/datum/loadout_item/nun_habit
	name = "修女服"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/nun

/datum/loadout_item/eastshirt1
	name = "黑色异邦衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1

/datum/loadout_item/eastshirt2
	name = "白色异邦衬衣"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
//PANTS
/datum/loadout_item/loincloth
	name = "兜裆布"
	path = /obj/item/clothing/under/roguetown/loincloth

/datum/loadout_item/tights
	name = "布紧身裤"
	path = /obj/item/clothing/under/roguetown/tights/black

/datum/loadout_item/leathertights
	name = "皮紧身裤"
	path = /obj/item/clothing/under/roguetown/trou/leathertights

/datum/loadout_item/formalshorts
	name = "礼服短裤"
	path = /obj/item/clothing/under/roguetown/trou/formal/shorts

/datum/loadout_item/formaltrousers
	name = "礼服长裤"
	path = /obj/item/clothing/under/roguetown/trou/formal

/datum/loadout_item/trou
	name = "工作长裤"
	path = /obj/item/clothing/under/roguetown/trou

/datum/loadout_item/leathertrou
	name = "皮长裤"
	path = /obj/item/clothing/under/roguetown/trou/leather

/datum/loadout_item/leathershorts
	name = "皮短裤"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts

/datum/loadout_item/sailorpants
	name = "航海裤"
	path = /obj/item/clothing/under/roguetown/tights/sailor

/datum/loadout_item/skirt
	name = "裙子"
	path = /obj/item/clothing/under/roguetown/skirt

/datum/loadout_item/sirwal
	name = "Sirwal"
	path = /obj/item/clothing/under/roguetown/sirwal

//ACCESSORIES
/datum/loadout_item/wrappings
	name = "手缠布"
	path = /obj/item/clothing/wrists/roguetown/wrappings

/datum/loadout_item/allwrappings
	name = "布缠带"
	path = /obj/item/clothing/wrists/roguetown/allwrappings

/datum/loadout_item/spectacles
	name = "眼镜"
	path = /obj/item/clothing/mask/rogue/spectacles

/datum/loadout_item/gloves
	name = "皮手套"
	path = /obj/item/clothing/gloves/roguetown/leather

/datum/loadout_item/fingerless
	name = "露指手套"
	path = /obj/item/clothing/gloves/roguetown/fingerless

/datum/loadout_item/bandages
	name = "绷带手套"
	path = /obj/item/clothing/gloves/roguetown/bandages

/datum/loadout_item/exoticsilkbelt
	name = "异域丝腰带"
	path = /obj/item/storage/belt/rogue/leather/exoticsilkbelt

/datum/loadout_item/butlersuspenders
	name = "吊带"
	path = /obj/item/storage/belt/rogue/leather/suspenders/butler

/datum/loadout_item/butlersuspenders_colorable
	name = "Suspenders (Colorable)"
	path = /obj/item/storage/belt/rogue/leather/suspenders/butler/colored

/datum/loadout_item/ragmask
	name = "布面罩"
	path = /obj/item/clothing/mask/rogue/ragmask

/datum/loadout_item/halfmask
	name = "半面罩"
	path = /obj/item/clothing/mask/rogue/shepherd

/datum/loadout_item/golden_half_mask
	name = "金色半面罩"
	path = /obj/item/clothing/mask/rogue/lordmask

/datum/loadout_item/exoticsilkmask
	name = "异域丝面罩"
	path = /obj/item/clothing/mask/rogue/exoticsilkmask

/datum/loadout_item/duelmask
	name = "决斗者面罩"
	path = /obj/item/clothing/mask/rogue/duelmask

/datum/loadout_item/pipe
	name = "烟斗"
	path = /obj/item/clothing/mask/cigarette/pipe

/datum/loadout_item/pipewestman
	name = "西地烟斗"
	path = /obj/item/clothing/mask/cigarette/pipe/westman

/datum/loadout_item/feather
	name = "羽饰"
	path = /obj/item/natural/feather

/datum/loadout_item/cursed_collar
	name = "诅咒项圈"
	path = /obj/item/clothing/neck/roguetown/cursed_collar

/datum/loadout_item/chastity_belt
	name = "贞操带"
	path = /obj/item/chastity
	triumph_cost = 1

/datum/loadout_item/chastity_cage
	name = "贞操笼"
	path = /obj/item/chastity/chastity_cage
	triumph_cost = 1

/datum/loadout_item/chastity_cage_anal
	name = "带后庭护板的贞操笼"
	path = /obj/item/chastity/chastity_cage/anal
	triumph_cost = 1

/datum/loadout_item/chastity_cage_spiked
	name = "带刺贞操笼"
	path = /obj/item/chastity/chastity_cage/spiked
	triumph_cost = 1

/datum/loadout_item/chastity_cage_spiked_anal
	name = "带后庭护板的带刺贞操笼"
	path = /obj/item/chastity/chastity_cage/spiked_anal
	triumph_cost = 1

/datum/loadout_item/chastity_cage_flat
	name = "平板贞操笼"
	path = /obj/item/chastity/chastity_cage/flat
	triumph_cost = 1

/datum/loadout_item/chastity_cage_flat_anal
	name = "带后庭护板的平板贞操笼"
	path = /obj/item/chastity/chastity_cage/flat/anal
	triumph_cost = 1

/datum/loadout_item/chastity_cage_flat_spiked
	name = "带刺平板贞操笼"
	path = /obj/item/chastity/chastity_cage/flat/spiked
	triumph_cost = 1

/datum/loadout_item/chastity_cage_flat_spiked_anal
	name = "带后庭护板的带刺平板贞操笼"
	path = /obj/item/chastity/chastity_cage/flat/spiked_anal
	triumph_cost = 1

/datum/loadout_item/chastity_insertable
	name = "可插入式贞操具"
	path = /obj/item/chastity/chastity_belt
	triumph_cost = 1

/datum/loadout_item/chastity_insertable_anal
	name = "带后庭护板的可插入式贞操具"
	path = /obj/item/chastity/chastity_belt/anal
	triumph_cost = 1

/datum/loadout_item/chastity_insertable_spiked
	name = "带刺可插入式贞操具"
	path = /obj/item/chastity/chastity_belt/spiked
	triumph_cost = 1

/datum/loadout_item/chastity_insertable_spiked_anal
	name = "带后庭护板的带刺可插入式贞操具"
	path = /obj/item/chastity/chastity_belt/spiked_anal
	triumph_cost = 1

/datum/loadout_item/chastity_combination
	name = "组合式贞操装置"
	path = /obj/item/chastity/intersex
	triumph_cost = 1

/datum/loadout_item/chastity_combination_spiked
	name = "带刺组合式贞操装置"
	path = /obj/item/chastity/intersex/spiked
	triumph_cost = 1

/datum/loadout_item/chastity_cursed
	name = "诅咒贞操装置"
	path = /obj/item/chastity/cursed
	triumph_cost = 4

/datum/loadout_item/cloth_blindfold
	name = "布眼罩"
	path = /obj/item/clothing/mask/rogue/blindfold

/datum/loadout_item/fake_blindfold
	name = "假眼罩"
	path = /obj/item/clothing/mask/rogue/blindfold/fake

/datum/loadout_item/bases
	name = "布制军裙"
	path = /obj/item/storage/belt/rogue/leather/battleskirt

/datum/loadout_item/fauldedbelt
	name = "带垂甲腰带"
	path = /obj/item/storage/belt/rogue/leather/battleskirt/faulds

/datum/loadout_item/tri_cloth_belt
	name = "布腰带"
	path = /obj/item/storage/belt/rogue/leather/cloth

/datum/loadout_item/tri_kazengun_scabbard
	name = "风郡礼仪鞘"
	path = /obj/item/rogueweapon/scabbard/sword/kazengun/noparry/loadout
	triumph_cost = 3

/datum/loadout_item/tri_kazengun_scabbard/nobility_check(client/C)
	var/datum/preferences/P = C.prefs
	if(!P)
		return FALSE
	// Check if user selected Nobility virtue
	if(P.virtue && istype(P.virtue, /datum/virtue/utility/noble))
		return TRUE
	if(P.virtuetwo && istype(P.virtuetwo, /datum/virtue/utility/noble))
		return TRUE
	// Check if user has high priority for any noble, courtier, or yeoman job
	for(var/job_title in GLOB.noble_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.courtier_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.yeoman_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	return FALSE

/datum/loadout_item/tri_shalal_belt
	name = "沙拉尔腰带"
	path = /obj/item/storage/belt/rogue/leather/shalal

// BELTS
/datum/loadout_item/leather
	name = "皮腰带"
	path = /obj/item/storage/belt/rogue/leather

/datum/loadout_item/leather_black
	name = "黑色皮腰带"
	path = /obj/item/storage/belt/rogue/leather/black

/datum/loadout_item/doublebelt
	name = "成对细腰带"
	path = /obj/item/storage/belt/rogue/leather/double

/datum/loadout_item/belt_cloth
	name = "布绶带"
	path = /obj/item/storage/belt/rogue/leather/sash

/datum/loadout_item/belt_rope
	name = "绳腰带"
	path = /obj/item/storage/belt/rogue/leather/rope

// Religious Amulets.

/datum/loadout_item/psicross
	name = "普赛顿十字"
	path = /obj/item/clothing/neck/roguetown/psicross

/datum/loadout_item/psicross_reform
	name = "改革派普赛圣十字"
	path = /obj/item/clothing/neck/roguetown/psicross/reform

/datum/loadout_item/psicross/astrata
	name = "阿斯特拉塔护符"
	path = /obj/item/clothing/neck/roguetown/psicross/astrata

/datum/loadout_item/psicross/noc
	name = "诺克护符"
	path = /obj/item/clothing/neck/roguetown/psicross/noc

/datum/loadout_item/psicross/abyssor
	name = "阿比索尔护符"
	path = /obj/item/clothing/neck/roguetown/psicross/abyssor

/datum/loadout_item/psicross/xylix
	name = "赛利克斯护符"
	path = /obj/item/clothing/neck/roguetown/psicross/xylix

/datum/loadout_item/psicross/dendor
	name = "登多尔护符"
	path = /obj/item/clothing/neck/roguetown/psicross/dendor

/datum/loadout_item/psicross/necra
	name = "内克拉护符"
	path = /obj/item/clothing/neck/roguetown/psicross/necra

/datum/loadout_item/psicross/pestra
	name = "佩斯特拉护符"
	path = /obj/item/clothing/neck/roguetown/psicross/pestra

/datum/loadout_item/psicross/ravox
	name = "拉沃克斯护符"
	path = /obj/item/clothing/neck/roguetown/psicross/ravox

/datum/loadout_item/psicross/malum
	name = "玛勒姆护符"
	path = /obj/item/clothing/neck/roguetown/psicross/malum

/datum/loadout_item/psicross/eora
	name = "伊欧拉护符"
	path = /obj/item/clothing/neck/roguetown/psicross/eora

/datum/loadout_item/psicross/zizo
	name = "远古齐佐十字"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/ancient

/datum/loadout_item/psicross/matthios
	name = "马西奥斯护符"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios

/datum/loadout_item/psicross/graggar
	name = "格拉加尔护符"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar

/datum/loadout_item/psicross/baotha
	name = "巴奥莎护符"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha

/datum/loadout_item/psicross/ten
	name = "十神护符"
	path = /obj/item/clothing/neck/roguetown/psicross/ten

/datum/loadout_item/wedding_band
	name = "银质婚戒"
	path = /obj/item/clothing/ring/band

/datum/loadout_item/chaperon
	name = "兜帽帽冠（普通）"
	path = /obj/item/clothing/head/roguetown/chaperon

/datum/loadout_item/chaperon/alt
	name = "兜帽帽冠（别式）"
	path = /obj/item/clothing/head/roguetown/chaperon/greyscale

/datum/loadout_item/chaperon/burgher
	name = "贵族兜帽帽冠"
	path = /obj/item/clothing/head/roguetown/chaperon/noble

/datum/loadout_item/jesterhat
	name = "弄臣帽"
	path = /obj/item/clothing/head/roguetown/jester

/datum/loadout_item/jestertunick
	name = "弄臣上衣"
	path = /obj/item/clothing/suit/roguetown/shirt/jester

/datum/loadout_item/jestershoes
	name = "弄臣鞋"
	path = /obj/item/clothing/shoes/roguetown/jester

/datum/loadout_item/jestermask
	name = "弄臣面具"
	path = /obj/item/clothing/mask/rogue/xylixmask

/datum/loadout_item/cotehardie
	name = "修身外套"
	path = /obj/item/clothing/cloak/cotehardie

/datum/loadout_item/zcross_iron
	name = "齐佐十字"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen

// NECKLACES & AMULETS
/datum/loadout_item/skull_amulet
	name = "骷髅护符"
	path = /obj/item/clothing/neck/roguetown/skullamulet

/datum/loadout_item/collar_feldcollar
	name = "军医项圈"
	path = /obj/item/clothing/neck/roguetown/collar/feldcollar

/datum/loadout_item/collar_surgcollar
	name = "外科项圈"
	path = /obj/item/clothing/neck/roguetown/collar/surgcollar

/datum/loadout_item/scarf
	name = "围巾"
	path = /obj/item/clothing/head/roguetown/scarf

// MASKS
/datum/loadout_item/skullmask
	name = "骷髅面具"
	path = /obj/item/clothing/mask/rogue/skullmask

/datum/loadout_item/physician_mask
	name = "医师面具"
	path = /obj/item/clothing/mask/rogue/physician

/datum/loadout_item/kitsune_mask
	name = "旧狐面"
	path = /obj/item/clothing/mask/rogue/facemask/yoruku_kitsune

/datum/loadout_item/oni_mask
	name = "旧鬼面"
	path = /obj/item/clothing/mask/rogue/facemask/yoruku_oni

/datum/loadout_item/naledi_lordmask
	name = "旧纳莱迪面具"
	path = /obj/item/clothing/mask/rogue/lordmask/naledi

// CLOAKS
/datum/loadout_item/darkcloak
	name = "深色斗篷"
	path = /obj/item/clothing/cloak/darkcloak

/datum/loadout_item/apron
	name = "围裙"
	path = /obj/item/clothing/cloak/apron

/datum/loadout_item/apron_blacksmith
	name = "铁匠围裙"
	path = /obj/item/clothing/cloak/apron/blacksmith

/datum/loadout_item/apron_waist
	name = "腰围裙"
	path = /obj/item/clothing/cloak/apron/waist

/datum/loadout_item/apron_cook
	name = "厨师围裙"
	path = /obj/item/clothing/cloak/apron/cook

/datum/loadout_item/black_cloak
	name = "毛皮外斗篷"
	path = /obj/item/clothing/cloak/black_cloak

/datum/loadout_item/tribal_cloak
	name = "部族斗篷"
	path = /obj/item/clothing/cloak/tribal

/datum/loadout_item/maidapron
	name = "女仆围裙"
	path = /obj/item/clothing/cloak/apron/maid

/datum/loadout_item/battlenun_cloak
	name = "修女斗篷"
	path = /obj/item/clothing/cloak/battlenun

/datum/loadout_item/hierophant_cloak
	name = "大祭司斗篷"
	path = /obj/item/clothing/cloak/hierophant

/datum/loadout_item/forrester_snow
	name = "雪林人斗篷"
	path = /obj/item/clothing/cloak/forrestercloak/snow

/datum/loadout_item/eastcloak1
	name = "东方斗篷"
	path = /obj/item/clothing/cloak/eastcloak1

/datum/loadout_item/kazengun_cloak
	name = "阵羽织"
	path = /obj/item/clothing/cloak/kazengun

// SHOES
/datum/loadout_item/sandals
	name = "凉鞋"
	path = /obj/item/clothing/shoes/roguetown/sandals

// NECK/GORGETS
/datum/loadout_item/forlorn_collar
	name = "旧失落项圈"
	path = /obj/item/clothing/neck/roguetown/gorget/forlorncollar

// EASTERN CLOTHING
/datum/loadout_item/captain_robe
	name = "东方花纹长袍"
	path = /obj/item/clothing/suit/roguetown/armor/basiceast/captainrobe

/datum/loadout_item/mentor_suit
	name = "东方导师服"
	path = /obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit

/datum/loadout_item/crafteast
	name = "东方工艺袍"
	path = /obj/item/clothing/suit/roguetown/armor/basiceast/crafteast

/datum/loadout_item/doboeast
	name = "东方道袍"
	path = /obj/item/clothing/suit/roguetown/armor/basiceast

// HEADWEAR
/datum/loadout_item/nochood
	name = "诺克兜帽"
	path = /obj/item/clothing/head/roguetown/nochood

/datum/loadout_item/dendormask
	name = "荆棘面具"
	path = /obj/item/clothing/head/roguetown/dendormask

/datum/loadout_item/necrahood
	name = "内克拉兜帽"
	path = /obj/item/clothing/head/roguetown/necrahood

/datum/loadout_item/physhood
	name = "佩斯特拉兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/phys

// ROBES - ASTRATA

/datum/loadout_item/eoramask
	name = "伊欧拉面具"
	path = /obj/item/clothing/head/roguetown/eoramask

/datum/loadout_item/antlerhood
	name = "鹿角兜帽"
	path = /obj/item/clothing/head/roguetown/antlerhood

/datum/loadout_item/briarthorns
	name = "荆棘头饰"
	path = /obj/item/clothing/head/roguetown/padded/briarthorns

/datum/loadout_item/mentorhat
	name = "圆锥导师帽"
	path = /obj/item/clothing/head/roguetown/mentorhat

// ROBES - ASTRATA
/datum/loadout_item/robe_astrata
	name = "太阳长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/astrata

/datum/loadout_item/hood_astrata
	name = "太阳兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/astrata

// ROBES - NOC
/datum/loadout_item/robe_noc
	name = "月亮长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/noc

// ROBES - DENDOR
/datum/loadout_item/robe_dendor
	name = "荆棘长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/dendor

// ROBES - ABYSSOR
/datum/loadout_item/robe_abyssor
	name = "深渊长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor

/datum/loadout_item/hood_abyssor
	name = "深渊兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/abyssor

// ROBES - NECRA
/datum/loadout_item/robe_necra
	name = "哀悼长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/necra

// ROBES - RAVOX
/datum/loadout_item/hood_ravox
	name = "拉沃克斯战袍护喉"
	path = /obj/item/clothing/head/roguetown/roguehood/ravoxgorget

// ROBES - EORA
/datum/loadout_item/robe_eora
	name = "伊欧拉长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/eora

//==========================
// TRIUMPH LOADOUT ITEMS
//==========================
//
// IMPORTANT INFORMATION ABOUT LOADOUT ITEMS:
// All items selected from the loadout system receive the following automatic modifications:
// - ARMOR: Set to ARMOR_PADDED_BAD (basic padded values) and ARMOR_INT_CHEST_LIGHT_BASE max integrity
// - ARMOR CLASS: Set to LIGHT for all armor pieces
// - SELL PRICE: Set to 0 (cannot be sold for profit)
// - CRIT PREVENTION: Removed from clothing items (prevent_crits set to null)
// - WEAPON DAMAGE: Reduced by 30% (force reduced to 70% of original)
// - WEAPON DEFENSE: Reduced by 50% (wdefense halved)
// - SMELT RESULT: Set to ash (cannot be smelted for materials)
// - EXAMINATION: Items show as reproductions when examined
//
// These modifications ensure loadout items provide utility and customization
// without bypassing game progression or economy balance.
// without bypassing game progression or economy balance.
//
//─────────────────────────────────────────────────────────────
// 2 TRIUMPH - Mundane Tools & Basic Items
//─────────────────────────────────────────────────────────────

// TOOLS & OBJECTS
/datum/loadout_item/tri_shovel
	name = "铲子"
	path = /obj/item/rogueweapon/shovel
	triumph_cost = 2

/datum/loadout_item/tri_sickle
	name = "镰刀"
	path = /obj/item/rogueweapon/sickle
	triumph_cost = 2

// BLUNT WEAPONS
/datum/loadout_item/tri_woodclub
	name = "木棍"
	path = /obj/item/rogueweapon/mace/woodclub
	triumph_cost = 2
	keep_loadout_stats = TRUE

// AXES
/datum/loadout_item/tri_bone_axe
	name = "骨斧"
	path = /obj/item/rogueweapon/stoneaxe/boneaxe
	triumph_cost = 2
	keep_loadout_stats = TRUE

/datum/loadout_item/ancient_axe
	name = "古斧"
	path = /obj/item/rogueweapon/stoneaxe/woodcut/steel/ancient
	triumph_cost = 4

// SWORDS
/datum/loadout_item/tri_stone_sword
	name = "石剑"
	path = /obj/item/rogueweapon/sword/stone
	triumph_cost = 2
	keep_loadout_stats = TRUE

/datum/loadout_item/ancient_gladius
	name = "古罗马短剑"
	path = /obj/item/rogueweapon/sword/short/gladius/ancient
	triumph_cost = 4

/datum/loadout_item/ancient_khopesh
	name = "古镰形剑"
	path = /obj/item/rogueweapon/sword/sabre/ancient
	triumph_cost = 4

// DAGGERS & KNIVES
/datum/loadout_item/tri_stone_knife
	name = "石刀"
	path = /obj/item/rogueweapon/huntingknife/stoneknife
	triumph_cost = 2
	keep_loadout_stats = TRUE

// MACES & BLUNT
/datum/loadout_item/ancient_mace
	name = "古钉锤"
	path = /obj/item/rogueweapon/mace/goden/steel/ancient
	triumph_cost = 4

// POLEARMS & SPEARS
/datum/loadout_item/tri_stone_spear
	name = "石矛"
	path = /obj/item/rogueweapon/spear/stone
	triumph_cost = 2
	keep_loadout_stats = TRUE

/datum/loadout_item/tri_bone_spear
	name = "骨矛"
	path = /obj/item/rogueweapon/spear/bonespear
	triumph_cost = 2
	keep_loadout_stats = TRUE

/datum/loadout_item/ancient_spear
	name = "古矛"
	path = /obj/item/rogueweapon/spear/ancient/decrepit
	triumph_cost = 4

// ARMOR & CLOTHING
/datum/loadout_item/ancient_mask
	name = "古面具"
	path = /obj/item/clothing/mask/rogue/facemask/ancient
	triumph_cost = 4

/datum/loadout_item/ancient_kilt
	name = "古褶裙"
	path = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient
	triumph_cost = 4

//─────────────────────────────────────────────────────────────
// 3 TRIUMPH - Wooden Polearms & Noble Clothing
//─────────────────────────────────────────────────────────────

// POLEARMS & SPEARS
/datum/loadout_item/tri_quarterstaff
	name = "长棍"
	path = /obj/item/rogueweapon/woodstaff/quarterstaff
	triumph_cost = 3
	keep_loadout_stats = TRUE

/datum/loadout_item/tri_woodstaff
	name = "木法杖"
	path = /obj/item/rogueweapon/woodstaff
	triumph_cost = 3
	keep_loadout_stats = TRUE

/datum/loadout_item/tri_scythe
	name = "农夫镰刀"
	path = /obj/item/rogueweapon/scythe
	triumph_cost = 3
	keep_loadout_stats = TRUE

// CLOTHING - TABARDS & RELIGIOUS CLOAKS
/datum/loadout_item/tri_astrata_tabard
	name = "阿斯特拉塔罩袍"
	path = /obj/item/clothing/cloak/templar/astratan


/datum/loadout_item/tri_malum_tabard
	name = "玛勒姆罩袍"
	path = /obj/item/clothing/cloak/templar/malumite

/datum/loadout_item/tri_necra_tabard
	name = "内克拉罩袍"
	path = /obj/item/clothing/cloak/templar/necran

/datum/loadout_item/tri_pestra_tabard
	name = "佩斯特拉罩袍"
	path = /obj/item/clothing/cloak/templar/pestran

/datum/loadout_item/tri_eora_tabard
	name = "伊欧拉罩袍"
	path = /obj/item/clothing/cloak/templar/eoran

/datum/loadout_item/tri_xylix_cloak
	name = "赛利克斯披风"
	path = /obj/item/clothing/cloak/templar/xylixian

/datum/loadout_item/tri_psydon_tabard
	name = "普赛顿罩袍"
	path = /obj/item/clothing/cloak/psydontabard

/datum/loadout_item/tri_reform_tabard
	name = "改革派战袍"
	path = /obj/item/clothing/cloak/reformtabard

/datum/loadout_item/tri_abyssor_tabard
	name = "阿比索尔罩袍"
	path = /obj/item/clothing/cloak/abyssortabard

/datum/loadout_item/tri_see_tabard
	name = "教廷战袍"
	path = /obj/item/clothing/cloak/templar/undivided
	triumph_cost = 4

/datum/loadout_item/tri_see_cloak
	name = "教廷斗篷"
	path = /obj/item/clothing/cloak/undivided
	triumph_cost = 4

/datum/loadout_item/tri_justice_tabard
	name = "正义战袍（拉沃克斯）"
	path = /obj/item/clothing/cloak/templar/ravox

// CLOTHING - DRESSES & ROBES
/datum/loadout_item/tri_ornate_dress
	name = "华饰长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward
	triumph_cost = 3

/datum/loadout_item/tri_princess_dress/nobility_check(client/C)
	var/datum/preferences/P = C.prefs
	if(!P)
		return FALSE
	// Check if user selected Nobility virtue
	if(P.virtue && istype(P.virtue, /datum/virtue/utility/noble))
		return TRUE
	if(P.virtuetwo && istype(P.virtuetwo, /datum/virtue/utility/noble))
		return TRUE
	// Check if user has high priority for any noble, courtier, or yeoman job
	for(var/job_title in GLOB.noble_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.courtier_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.yeoman_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	return FALSE

/datum/loadout_item/tri_ornate_tunic
	name = "华饰束腰衫"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/silktunic
	triumph_cost = 3

/datum/loadout_item/tri_princess_dress/nobility_check(client/C)
	var/datum/preferences/P = C.prefs
	if(!P)
		return FALSE
	// Check if user selected Nobility virtue
	if(P.virtue && istype(P.virtue, /datum/virtue/utility/noble))
		return TRUE
	if(P.virtuetwo && istype(P.virtuetwo, /datum/virtue/utility/noble))
		return TRUE
	// Check if user has high priority for any noble, courtier, or yeoman job
	for(var/job_title in GLOB.noble_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.courtier_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.yeoman_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	return FALSE

/datum/loadout_item/tri_princess_dress
	name = "公主长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	triumph_cost = 3

/datum/loadout_item/tri_princess_dress/nobility_check(client/C)
	var/datum/preferences/P = C.prefs
	if(!P)
		return FALSE
	// Check if user selected Nobility virtue
	if(P.virtue && istype(P.virtue, /datum/virtue/utility/noble))
		return TRUE
	if(P.virtuetwo && istype(P.virtuetwo, /datum/virtue/utility/noble))
		return TRUE
	// Check if user has high priority for any noble, courtier, or yeoman job
	for(var/job_title in GLOB.noble_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.courtier_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.yeoman_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	return FALSE

/datum/loadout_item/tri_royal_dress
	name = "皇家长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal
	triumph_cost = 3

/datum/loadout_item/tri_royal_dress/nobility_check(client/C)
	var/datum/preferences/P = C.prefs
	if(!P)
		return FALSE
	// Check if user selected Nobility virtue
	if(P.virtue && istype(P.virtue, /datum/virtue/utility/noble))
		return TRUE
	if(P.virtuetwo && istype(P.virtuetwo, /datum/virtue/utility/noble))
		return TRUE
	// Check if user has high priority for any noble, courtier, or yeoman job
	for(var/job_title in GLOB.noble_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.courtier_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.yeoman_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	return FALSE

/datum/loadout_item/tri_royal_sleeves
	name = "皇家袖套"
	path = /obj/item/clothing/wrists/roguetown/royalsleeves
	triumph_cost = 3

/datum/loadout_item/tri_royal_sleeves/nobility_check(client/C)
	var/datum/preferences/P = C.prefs
	if(!P)
		return FALSE
	// Check if user selected Nobility virtue
	if(P.virtue && istype(P.virtue, /datum/virtue/utility/noble))
		return TRUE
	if(P.virtuetwo && istype(P.virtuetwo, /datum/virtue/utility/noble))
		return TRUE
	// Check if user has high priority for any noble, courtier, or yeoman job
	for(var/job_title in GLOB.noble_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.courtier_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.yeoman_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	return FALSE

/datum/loadout_item/tri_lady_cloak
	name = "女士斗篷"
	path = /obj/item/clothing/cloak/lordcloak/ladycloak
	triumph_cost = 3

/datum/loadout_item/wedding_dress
	name = "婚礼丝裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/weddingdress

/datum/loadout_item/tri_lady_cloak/nobility_check(client/C)
	var/datum/preferences/P = C.prefs
	if(!P)
		return FALSE
	// Check if user selected Nobility virtue
	if(P.virtue && istype(P.virtue, /datum/virtue/utility/noble))
		return TRUE
	if(P.virtuetwo && istype(P.virtuetwo, /datum/virtue/utility/noble))
		return TRUE
	// Check if user has high priority for any noble, courtier, or yeoman job
	for(var/job_title in GLOB.noble_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.courtier_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.yeoman_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	return FALSE

// CLOTHING - HEADWEAR
/datum/loadout_item/tri_circlet
	name = "额环"
	path = /obj/item/clothing/head/roguetown/circlet
	triumph_cost = 3

/datum/loadout_item/tri_circlet/nobility_check(client/C)
	var/datum/preferences/P = C.prefs
	if(!P)
		return FALSE
	// Check if user selected Nobility virtue
	if(P.virtue && istype(P.virtue, /datum/virtue/utility/noble))
		return TRUE
	if(P.virtuetwo && istype(P.virtuetwo, /datum/virtue/utility/noble))
		return TRUE
	// Check if user has high priority for any noble, courtier, or yeoman job
	for(var/job_title in GLOB.noble_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.courtier_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.yeoman_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	return FALSE

/datum/loadout_item/tri_volfhelm
	name = "沃尔夫头盔"
	path = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	triumph_cost = 2

/datum/loadout_item/tri_saiga
	name = "赛加头盔"
	path = /obj/item/clothing/head/roguetown/helmet/leather/saiga
	triumph_cost = 2

// CLOTHING - JEWELRY & ACCESSORIES
/datum/loadout_item/tri_noble_amulet
	name = "贵族护符"
	path = /obj/item/clothing/neck/roguetown/ornateamulet/noble
	triumph_cost = 4

/datum/loadout_item/tri_shell_bracelet
	name = "贝壳手镯"
	path = /obj/item/clothing/neck/roguetown/psicross/shell/bracelet
	triumph_cost = 2

/datum/loadout_item/tri_shell_necklace
	name = "牡蛎壳项链"
	path = /obj/item/clothing/neck/roguetown/psicross/shell
	triumph_cost = 2

// CLOTHING - ARMOR (Alphabetically Ordered)
/datum/loadout_item/tri_desert_coat
	name = "沙地外套"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	triumph_cost = 3

/datum/loadout_item/tri_duelist_coat
	name = "决斗者外套"
	path = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	triumph_cost = 3

/datum/loadout_item/tri_fencing_gambeson
	name = "击剑棉甲（奥塔凡）"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	triumph_cost = 3

/datum/loadout_item/tri_fencing_shirt
	name = "击剑衬衣（衬垫）"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter
	triumph_cost = 3

/datum/loadout_item/tri_gambeson
	name = "棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson
	triumph_cost = 3

/datum/loadout_item/tri_gambeson_light
	name = "轻型棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	triumph_cost = 2

/datum/loadout_item/tri_gambeson_padded
	name = "衬垫棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	triumph_cost = 3

/datum/loadout_item/tri_grenzelhoft_hipshirt
	name = "格伦泽尔霍夫特胯衫"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	triumph_cost = 3

/datum/loadout_item/tri_gronn_byrine_chausses
	name = "拜林护腿"
	path = /obj/item/clothing/under/roguetown/splintlegs/iron/gronn
	triumph_cost = 3

/datum/loadout_item/tri_gronn_byrine_gloves
	name = "拜林手套"
	path = /obj/item/clothing/gloves/roguetown/chain/gronn
	triumph_cost = 3

/datum/loadout_item/tri_gronn_byrine_hauberk
	name = "拜林锁子甲"
	path = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
	triumph_cost = 3

/datum/loadout_item/tri_gronn_fur_pants
	name = "毛皮裤"
	path = /obj/item/clothing/under/roguetown/trou/leather/gronn
	triumph_cost = 3

/datum/loadout_item/tri_gronn_bone_gloves
	name = "骨手套"
	path = /obj/item/clothing/gloves/roguetown/angle/gronnfur
	triumph_cost = 3

/datum/loadout_item/tri_hierophant_gambeson
	name = "大祭司棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant
	triumph_cost = 3

/datum/loadout_item/tri_gronn_ravager_mantle
	name = "掠夺者披肩"
	path = /obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn
	triumph_cost = 3

/datum/loadout_item/tri_huus_quyaq
	name = "胡斯夸亚克（北地）"
	path = /obj/item/clothing/suit/roguetown/armor/leather/Huus_quyaq
	triumph_cost = 3

/datum/loadout_item/tri_kurche
	name = "库尔切（格隆恩）"
	path = /obj/item/clothing/suit/roguetown/armor/kurche
	triumph_cost = 3

/datum/loadout_item/tri_leather_cuirass
	name = "皮胸甲"
	path = /obj/item/clothing/suit/roguetown/armor/leather/cuirass
	triumph_cost = 3

/datum/loadout_item/tri_leather_corslet
	name = "皮短胸甲"
	path = /obj/item/clothing/suit/roguetown/armor/leather/bikini
	triumph_cost = 3

/datum/loadout_item/corset
	name = "紧身胸衣"
	path = /obj/item/clothing/suit/roguetown/armor/corset

/datum/loadout_item/tri_moose_hood
	name = "驼鹿兜帽（萨满）"
	path = /obj/item/clothing/head/roguetown/helmet/leather/shaman_hood
	triumph_cost = 4

/datum/loadout_item/tri_newmoon_hood
	name = "新月兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/reinforced/newmoon
	triumph_cost = 2

/datum/loadout_item/tri_newmoon_jacket
	name = "新月夹克"
	path = /obj/item/clothing/suit/roguetown/armor/leather/newmoon_jacket
	triumph_cost = 3

/datum/loadout_item/tri_newmoon_tunic
	name = "新月束腰衫"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/newmoon
	triumph_cost = 3

/datum/loadout_item/tri_otavan_gambeson
	name = "奥塔凡棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
	triumph_cost = 3

/datum/loadout_item/tri_padded_caftan
	name = "衬垫卡夫坦"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	triumph_cost = 3

/datum/loadout_item/tri_pontifex_gambeson
	name = "大祭长棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
	triumph_cost = 3

/datum/loadout_item/tri_psyaltrist_leather
	name = "灵医皮甲"
	path = /obj/item/clothing/suit/roguetown/armor/leather/studded/psyaltrist
	triumph_cost = 3

/datum/loadout_item/tri_zyb_coat
	name = "沙地外套"
	path = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/zyb
	triumph_cost = 3

/datum/loadout_item/tri_zyb_gambeson
	name = "沙地棉甲"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/zyb
	triumph_cost = 3

/datum/loadout_item/tri_shamanic_coat
	name = "萨满外套"
	path = /obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi
	triumph_cost = 3

/datum/loadout_item/tri_spellcaster_hat
	name = "施法者帽"
	path = /obj/item/clothing/head/roguetown/spellcasterhat
	triumph_cost = 2

/datum/loadout_item/tri_steppe_coat
	name = "草原外套"
	path = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
	triumph_cost = 3

// HELMETS AND HEADWEAR (Alphabetically Ordered)
/datum/loadout_item/tri_grenzelhoft_hat
	name = "格伦泽尔霍夫特帽"
	path = /obj/item/clothing/head/roguetown/grenzelhofthat
	triumph_cost = 2

/datum/loadout_item/tri_hierophant_hood
	name = "大祭司兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/hierophant
	triumph_cost = 2

/datum/loadout_item/tri_armorhood_hood
	name = "铆钉皮兜帽"
	path = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
	triumph_cost = 2

/datum/loadout_item/tri_pontifex_hood
	name = "大祭长兜帽"
	path = /obj/item/clothing/head/roguetown/roguehood/pontifex
	triumph_cost = 2

/datum/loadout_item/tri_zyb_hijab
	name = "沙地头巾"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/zyb
	triumph_cost = 2


// GLOVES (Alphabetically Ordered)
/datum/loadout_item/tri_atgervi_gloves
	name = "阿特格维手套"
	path = /obj/item/clothing/gloves/roguetown/angle/atgervi
	triumph_cost = 2

/datum/loadout_item/tri_eastern_gloves
	name = "东方手套"
	path = /obj/item/clothing/gloves/roguetown/eastgloves2
	triumph_cost = 2

/datum/loadout_item/tri_grenzelhoft_gloves
	name = "格伦泽尔霍夫特手套"
	path = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	triumph_cost = 2

/datum/loadout_item/tri_kote_gloves
	name = "胴丸护手"
	path = /obj/item/clothing/gloves/roguetown/plate/kote
	triumph_cost = 2

/datum/loadout_item/tri_otavan_gloves
	name = "奥塔凡手套"
	path = /obj/item/clothing/gloves/roguetown/otavan
	triumph_cost = 2

/datum/loadout_item/tri_pontifex_gloves
	name = "大祭长手套"
	path = /obj/item/clothing/gloves/roguetown/angle/pontifex
	triumph_cost = 2

// BOOTS & SHOES (Alphabetically Ordered)
/datum/loadout_item/tri_atgervi_boots
	name = "阿特格维靴"
	path = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi


/datum/loadout_item/tri_grenzelhoft_boots
	name = "格伦泽尔霍夫特靴"
	path = /obj/item/clothing/shoes/roguetown/boots/grenzelhoft


/datum/loadout_item/tri_kazengun_boots
	name = "风郡靴"
	path = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun


/datum/loadout_item/tri_otavan_boots
	name = "奥塔凡靴"
	path = /obj/item/clothing/shoes/roguetown/boots/otavan


/datum/loadout_item/tri_rumaclan_boots
	name = "鲁玛氏族靴"
	path = /obj/item/clothing/shoes/roguetown/armor/rumaclan


/datum/loadout_item/tri_shalal_boots
	name = "沙拉尔靴"
	path = /obj/item/clothing/shoes/roguetown/shalal


// PANTS (Alphabetically Ordered)
/datum/loadout_item/tri_atgervi_pants
	name = "阿特格维毛皮裤"
	path = /obj/item/clothing/under/roguetown/trou/leather/atgervi
	triumph_cost = 2

/datum/loadout_item/tri_eastern_pants_1
	name = "东方长裤（黑）"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
	triumph_cost = 2

/datum/loadout_item/tri_eastern_pants_2
	name = "东方长裤（白）"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	triumph_cost = 2

/datum/loadout_item/tri_grenzelhoft_pants
	name = "格伦泽尔霍夫特长裤"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	triumph_cost = 2

/datum/loadout_item/tri_otavan_pants
	name = "奥塔凡长裤"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	triumph_cost = 2

/datum/loadout_item/tri_otavan_generic_pants
	name = "奥塔凡长裤（通用）"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	triumph_cost = 2

/datum/loadout_item/tri_kazengun_pants
	name = "风郡长裤"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun
	triumph_cost = 2

/datum/loadout_item/tri_pontifex_pants
	name = "大祭长长裤"
	path = /obj/item/clothing/under/roguetown/trou/leather/pontifex
	triumph_cost = 2

/datum/loadout_item/tri_zyb_pants
	name = "齐班廷长裤"
	path = /obj/item/clothing/under/roguetown/trou/leather/pontifex/zyb
	triumph_cost = 2


// CLOAKS & CAPES (Alphabetically Ordered)
/datum/loadout_item/tri_eastern_cloak_1
	name = "东方斗篷"
	path = /obj/item/clothing/cloak/eastcloak1


/datum/loadout_item/tri_hierophant_cloak
	name = "大祭司斗篷"
	path = /obj/item/clothing/cloak/hierophant


/datum/loadout_item/tri_kazengun_cloak
	name = "风郡斗篷"
	path = /obj/item/clothing/cloak/kazengun


// NECK ACCESSORIES (Alphabetically Ordered)

/datum/loadout_item/tri_fencerguard
	name = "击剑护领"
	path = /obj/item/clothing/neck/roguetown/fencerguard
	triumph_cost = 4

/datum/loadout_item/tri_naledi_cross
	name = "纳莱迪普赛圣十字"
	path = /obj/item/clothing/neck/roguetown/psicross/naledi

/datum/loadout_item/woolencollar
	name = "羊毛项圈"
	path = /obj/item/clothing/neck/roguetown/collar/woolen

// MASKS (Alphabetically Ordered)

// SHIRTS & ROBES (Alphabetically Ordered)
/datum/loadout_item/tri_hierophant_robe
	name = "大祭司长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	triumph_cost = 2

/datum/loadout_item/tri_pontifex_robe
	name = "大祭长长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/pointfex
	triumph_cost = 2

/datum/loadout_item/slitteddress
	name = "开衩长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/slit

// POLEARMS & STAVES
/datum/loadout_item/tri_naledi_staff
	name = "纳莱迪法杖（装饰）"
	path = /obj/item/rogueweapon/woodstaff/decorative
	triumph_cost = 3


//─────────────────────────────────────────────────────────────
// 10 TRIUMPH - Lord's Cloak
//─────────────────────────────────────────────────────────────

// CLOTHING - CLOAKS
/datum/loadout_item/tri_lord_cloak
	name = "领主斗篷"
	path = /obj/item/clothing/cloak/lordcloak
	triumph_cost = 10

/datum/loadout_item/tri_lord_cloak/nobility_check(client/C)
	var/datum/preferences/P = C.prefs
	if(!P)
		return FALSE
	// Check if user selected Nobility virtue
	if(P.virtue && istype(P.virtue, /datum/virtue/utility/noble))
		return TRUE
	if(P.virtuetwo && istype(P.virtuetwo, /datum/virtue/utility/noble))
		return TRUE
	// Check if user has high priority for any noble, courtier, or yeoman job
	for(var/job_title in GLOB.noble_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.courtier_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	for(var/job_title in GLOB.yeoman_positions)
		if(P.job_preferences[job_title] == JP_HIGH)
			return TRUE
	return FALSE

//==========================
//Donator Section
//==========================
//All these items are stored in the donator_fluff.dm in the azure modular folder for simplicity.
//All should be subtypes of existing weapons/clothes/armor/gear, whatever, to avoid balance issues I guess. Idk, I'm not your boss.

/datum/loadout_item/donator_plex
	name = "赞助者套装 - 阿利塞奥刺剑"
	path = /obj/item/enchantingkit/plexiant
	ckeywhitelist = list("plexiant")

/datum/loadout_item/donator_sru
	name = "赞助者套装 - 翡翠长裙"
	path = /obj/item/enchantingkit/srusu
	ckeywhitelist = list("cheekycrenando")

/datum/loadout_item/donator_strudel
	name = "赞助者套装 - 格伦泽尔霍夫特法师背心"
	path = /obj/item/enchantingkit/strudle
	ckeywhitelist = list("toasterstrudes")

/datum/loadout_item/donator_bat
	name = "赞助者套装 - 手工雕刻竖琴"
	path = /obj/item/enchantingkit/bat
	ckeywhitelist = list("kitchifox")

/datum/loadout_item/donator_mansa
	name = "赞助者套装 - 沃特崔格"
	path = /obj/item/enchantingkit/ryebread
	ckeywhitelist = list("pepperoniplayboy")	//Byond maybe doesn't like spaces. If a name has a space, do it as one continious name.

/datum/loadout_item/donator_rebel
	name = "赞助者套装 - 镀金面罩盔"
	path = /obj/item/enchantingkit/rebel
	ckeywhitelist = list("rebel0")

/datum/loadout_item/donator_bigfoot
	name = "赞助者套装 - 镀金骑士盔"
	path = /obj/item/enchantingkit/bigfoot
	ckeywhitelist = list("bigfoot02")

/datum/loadout_item/donator_bigfoot_axe
	name = "赞助者套装 - 镀金巨斧"
	path = /obj/item/enchantingkit/bigfoot_axe
	ckeywhitelist = list("bigfoot02")

/datum/loadout_item/donator_zydras
	name = "赞助者套装 - 衬垫丝裙"
	path = /obj/item/enchantingkit/zydras
	ckeywhitelist = list("1ceres")

/datum/loadout_item/leather_collar
	name = "皮项圈"
	path = /obj/item/clothing/neck/roguetown/collar/leather

/datum/loadout_item/cowbell_collar
	name = "牛铃项圈"
	path = /obj/item/clothing/neck/roguetown/collar/cowbell

/datum/loadout_item/catbell_collar
	name = "猫铃项圈"
	path = /obj/item/clothing/neck/roguetown/collar/catbell

/datum/loadout_item/catbell
	name = "猫铃"
	path = /obj/item/catbell

/datum/loadout_item/cowbell
	name = "牛铃"
	path = /obj/item/catbell/cow

/datum/loadout_item/rope_leash
	name = "绳牵引绳"
	path = /obj/item/leash

/datum/loadout_item/leather_leash
	name = "皮牵引绳"
	path = /obj/item/leash/leather

/datum/loadout_item/chain_leash
	name = "链牵引绳"
	path = /obj/item/leash/chain

/datum/loadout_item/magic_recipes
	name = "奥术指南"
	path = /obj/item/recipe_book/magic

/datum/loadout_item/alch_recipes
	name = "炼金指南"
	path = /obj/item/recipe_book/alchemy

/datum/loadout_item/leather_recipes
	name = "制革指南"
	path = /obj/item/recipe_book/leatherworking

/datum/loadout_item/sewing_recipes
	name = "裁缝指南"
	path = /obj/item/recipe_book/sewing

/datum/loadout_item/smith_recipes
	name = "锻造指南"
	path = /obj/item/recipe_book/blacksmithing

/datum/loadout_item/engi_recipes
	name = "工程指南"
	path = /obj/item/recipe_book/engineering

/datum/loadout_item/build_recipes
	name = "建造指南"
	path = /obj/item/recipe_book/builder

/datum/loadout_item/potter_recipes
	name = "陶艺指南"
	path = /obj/item/recipe_book/ceramics

/datum/loadout_item/survival_recipes
	name = "生存指南"
	path = /obj/item/recipe_book/survival

/datum/loadout_item/cooking_recipes
	name = "烹饪指南"
	path = /obj/item/recipe_book/cooking

/datum/loadout_item/tenbibble
	name = "《十神之诗与行》"
	path = /obj/item/book/rogue/bibble

/datum/loadout_item/psybibble
	name = "《普赛顿之书》"
	path = /obj/item/book/rogue/bibble/psy

/datum/loadout_item/zizobibble
	name = "《她之真理辞典》"
	path = /obj/item/book/rogue/bibble/zizo

//COSMETICS (Perfumes & Lipsticks)

/datum/loadout_item/perfume_lavender
	name = "薰衣草香水"
	path = /obj/item/perfume/lavender
	triumph_cost = 2

/datum/loadout_item/perfume_cherry
	name = "樱桃香水"
	path = /obj/item/perfume/cherry
	triumph_cost = 2

/datum/loadout_item/perfume_rose
	name = "玫瑰香水"
	path = /obj/item/perfume/rose
	triumph_cost = 2

/datum/loadout_item/perfume_jasmine
	name = "茉莉香水"
	path = /obj/item/perfume/jasmine
	triumph_cost = 2

/datum/loadout_item/perfume_mint
	name = "薄荷香水"
	path = /obj/item/perfume/mint
	triumph_cost = 2

/datum/loadout_item/perfume_vanilla
	name = "香草香水"
	path = /obj/item/perfume/vanilla
	triumph_cost = 2

/datum/loadout_item/perfume_pear
	name = "梨香水"
	path = /obj/item/perfume/pear
	triumph_cost = 2

/datum/loadout_item/perfume_strawberry
	name = "草莓香水"
	path = /obj/item/perfume/strawberry
	triumph_cost = 2

/datum/loadout_item/perfume_cinnamon
	name = "肉桂香水"
	path = /obj/item/perfume/cinnamon
	triumph_cost = 2

/datum/loadout_item/perfume_frankincense
	name = "乳香香水"
	path = /obj/item/perfume/frankincense
	triumph_cost = 2

/datum/loadout_item/perfume_sandalwood
	name = "檀香香水"
	path = /obj/item/perfume/sandalwood
	triumph_cost = 2

/datum/loadout_item/perfume_myrrh
	name = "没药香水"
	path = /obj/item/perfume/myrrh
	triumph_cost = 2

/datum/loadout_item/lipstick_red
	name = "红色唇膏"
	path = /obj/item/azure_lipstick
	triumph_cost = 2

/datum/loadout_item/lipstick_jade
	name = "翠玉色唇膏"
	path = /obj/item/azure_lipstick/jade
	triumph_cost = 2

/datum/loadout_item/lipstick_purple
	name = "紫色唇膏"
	path = /obj/item/azure_lipstick/purple
	triumph_cost = 2

/datum/loadout_item/lipstick_black
	name = "黑色唇膏"
	path = /obj/item/azure_lipstick/black
	triumph_cost = 2

/datum/loadout_item/hair_dye
	name = "染发膏"
	path = /obj/item/hair_dye_cream
	triumph_cost = 2

/datum/loadout_item/branding_stick
	name = "粗制烙印棒"
	path = /obj/item/rogueweapon/surgery/cautery/branding/crude
	triumph_cost = 1

//ADDITIONAL ITEMS

/datum/loadout_item/backpack
	name = "背包"
	path = /obj/item/storage/backpack/rogue/backpack
	triumph_cost = 6

/datum/loadout_item/satchel
	name = "挎包"
	path = /obj/item/storage/backpack/rogue/satchel
	triumph_cost = 5

/datum/loadout_item/otavansatchel
	name = "奥塔万挎包"
	path = /obj/item/storage/backpack/rogue/satchel/otavan
	triumph_cost = 5

/datum/loadout_item/shortsatchel
	name = "短挎包"
	path = /obj/item/storage/backpack/rogue/satchel/short
	triumph_cost = 4

/datum/loadout_item/saddle
	name = "Saddle"
	path = /obj/item/natural/saddle
	triumph_cost = 4

/datum/loadout_item/pouches
	name = "小袋"
	path = /obj/item/storage/belt/rogue/pouch
	triumph_cost = 3

/datum/loadout_item/swatchbook
	name = "裁缝色样簿"
	path = /obj/item/book/rogue/swatchbook
	triumph_cost = 3

/datum/loadout_item/parasol
	name = "纸伞"
	path = /obj/item/rogueweapon/mace/parasol
	triumph_cost = 3

/datum/loadout_item/scabbard
	name = "剑鞘"
	path = /obj/item/rogueweapon/scabbard/sword
	triumph_cost = 1

/datum/loadout_item/scabbard/noble
	name = "Noble Scabbard"
	path = /obj/item/rogueweapon/scabbard/sword/noble
	triumph_cost = 2

/datum/loadout_item/scabbard/royal
	name = "Royal Scabbard"
	path = /obj/item/rogueweapon/scabbard/sword/royal
	triumph_cost = 3

/datum/loadout_item/scabbard/sheathe/noble
	name = "Noble Sheathe"
	path = /obj/item/rogueweapon/scabbard/sheath/noble
	triumph_cost = 1

/datum/loadout_item/scabbard/sheathe/royal
	name = "Royal Sheathe"
	path = /obj/item/rogueweapon/scabbard/sheath/royal
	triumph_cost = 1


/datum/loadout_item/greatweaponstrap
	name = "巨型武器背带"
	path = /obj/item/rogueweapon/scabbard/gwstrap
	triumph_cost = 2

//INSTRUMENTS

/datum/loadout_item/accordion
	name = "手风琴"
	path = /obj/item/rogue/instrument/accord
	triumph_cost = 1

/datum/loadout_item/bagpipe
	name = "风笛"
	path = /obj/item/rogue/instrument/bagpipe
	triumph_cost = 1

/datum/loadout_item/banjo
	name = "班卓琴"
	path = /obj/item/rogue/instrument/banjo
	triumph_cost = 1

/datum/loadout_item/drum
	name = "鼓"
	path = /obj/item/rogue/instrument/drum
	triumph_cost = 1

/datum/loadout_item/flute
	name = "长笛"
	path = /obj/item/rogue/instrument/flute
	triumph_cost = 1

/datum/loadout_item/guitar
	name = "吉他"
	path = /obj/item/rogue/instrument/guitar
	triumph_cost = 1

/datum/loadout_item/harmonica
	name = "口琴"
	path = /obj/item/rogue/instrument/harmonica
	triumph_cost = 1

/datum/loadout_item/harp
	name = "竖琴"
	path = /obj/item/rogue/instrument/harp
	triumph_cost = 1

/datum/loadout_item/hurdygurdy
	name = "手摇风琴"
	path = /obj/item/rogue/instrument/hurdygurdy
	triumph_cost = 1

/datum/loadout_item/jawharp
	name = "口簧琴"
	path = /obj/item/rogue/instrument/jawharp
	triumph_cost = 1

/datum/loadout_item/lute
	name = "鲁特琴"
	path = /obj/item/rogue/instrument/lute
	triumph_cost = 1

/datum/loadout_item/psyaltery
	name = "普赛诗琴"
	path = /obj/item/rogue/instrument/psyaltery
	triumph_cost = 1

/datum/loadout_item/shamisen
	name = "三味线"
	path = /obj/item/rogue/instrument/shamisen
	triumph_cost = 1

/datum/loadout_item/trumpet
	name = "小号"
	path = /obj/item/rogue/instrument/trumpet
	triumph_cost = 1

/datum/loadout_item/viola
	name = "中提琴"
	path = /obj/item/rogue/instrument/viola
	triumph_cost = 1

/datum/loadout_item/vocaltalisman
	name = "歌咏护符"
	path = /obj/item/rogue/instrument/vocals
	triumph_cost = 1


// Unique stuff that doesn't quite fit anywhere else.

/datum/loadout_item/kazengunite_smithing_manual
	name = "火术传书"
	desc = "一本风钢岩锻造手册。阅读后可在铁砧解锁风钢岩护甲与武器配方，但需要懂得风郡语。"
	path = /obj/item/book/granter/trait/kazengunite_smith
	triumph_cost = 3
