/datum/inqports/reliquary/
	category = 1 // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", ✤ RELIQUARY ✤, "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".

/datum/inqports/supplies/
	category = 2  // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", ✤ RELIQUARY ✤, "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".

/datum/inqports/articles/
	category = 3  // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", ✤ RELIQUARY ✤, "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".

/datum/inqports/equipment/
	category = 4 // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", ✤ RELIQUARY ✤, "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".

/datum/inqports/wardrobe/
	category = 5 // Category for the HERMES. They are - "✤ SUPPLIES ✤", "✤ ARTICLES ✤", ✤ RELIQUARY ✤, "✤ WARDROBE ✤", "✤ EQUIPMENT ✤".


/obj/structure/closet/crate/chest/inqcrate/supplies/
	name = "宗审补给箱"

/obj/structure/closet/crate/chest/inqcrate/articles/
	name = "宗审文书箱"

/obj/structure/closet/crate/chest/inqreliquary/relic/

/obj/structure/closet/crate/chest/inqcrate/equipment/
	name = "宗审装备箱"

/obj/structure/closet/crate/chest/inqcrate/wardrobe/
	name = "奥塔瓦精品衣箱"

/// ✤ SUPPLIES ✤ START HERE! WOW!

/datum/inqports/supplies/extrafunding
	name = "（80 银币）额外经费"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/extrafunding
	marquescost = 16
	maximum = 1

/obj/item/roguecoin/silver/inqpile/Initialize(mapload)
	. = ..()
	set_quantity(20)

/obj/structure/closet/crate/chest/inqcrate/supplies/extrafunding/Initialize(mapload)
	. = ..()
	new /obj/item/roguecoin/silver/inqpile(src)
	new /obj/item/roguecoin/silver/inqpile(src)
	new /obj/item/roguecoin/silver/inqpile(src)
	new /obj/item/roguecoin/silver/inqpile(src)

/datum/inqports/supplies/stampstuff
	name = "1 块红脂"
	item_type = /obj/item/reagent_containers/food/snacks/tallow/red
	marquescost = 2

/datum/inqports/supplies/medical
	name = "5 卷布与针"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/medical
	marquescost = 8

/obj/item/natural/bundle/cloth/roll/Initialize(mapload)
	. = ..()
	icon_state = "clothroll2"
	amount = 10
	grid_width = 64

/obj/structure/closet/crate/chest/inqcrate/supplies/medical/Initialize(mapload)
	. = ..()
	new /obj/item/needle(src)
	new /obj/item/needle(src)
	new /obj/item/needle(src)
	new /obj/item/needle(src)
	new /obj/item/needle(src)
	new /obj/item/natural/bundle/cloth/bandage/full(src)
	new /obj/item/natural/bundle/cloth/bandage/full(src)
	new /obj/item/natural/bundle/cloth/bandage/full(src)
	new /obj/item/natural/bundle/cloth/bandage/full(src)

/datum/inqports/supplies/chains
	name = "2 段锁链"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/chains
	marquescost = 6

/datum/inqports/supplies/blessedbolts
	name = "1 箭袋圣水弩矢"
	item_type = /obj/item/quiver/holybolts
	marquescost = 2

/obj/structure/closet/crate/chest/inqcrate/supplies/chains/Initialize(mapload)
	. = ..()
	new /obj/item/rope/chain(src)
	new /obj/item/rope/chain(src)

/datum/inqports/supplies/redpotions
	name = "3 瓶红药"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/redpots
	marquescost = 6

/obj/structure/closet/crate/chest/inqcrate/supplies/redpots/Initialize(mapload)
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)

/datum/inqports/supplies/lifebloodvials
	name = "3 瓶强效红药"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/sredvials
	maximum = 1
	marquescost = 10

/obj/structure/closet/crate/chest/inqcrate/supplies/sredvials/Initialize(mapload)
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew(src)

/datum/inqports/supplies/bluepotions
	name = "3 瓶蓝药"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/bluepots
	marquescost = 8

/obj/structure/closet/crate/chest/inqcrate/supplies/bluepots/Initialize(mapload)
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/manapot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/manapot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/manapot(src)

/datum/inqports/supplies/strongbluevials
	name = "3 瓶强效蓝药"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/sbluevials
	maximum = 1
	marquescost = 16

/obj/structure/closet/crate/chest/inqcrate/supplies/sbluevials/Initialize(mapload)
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/alchemical/strongmanapot(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/strongmanapot(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/strongmanapot(src)

/datum/inqports/supplies/smokes
	name = "4 枚烟雾弹"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/smokes
	marquescost = 8

/obj/structure/closet/crate/chest/inqcrate/supplies/smokes/Initialize(mapload)
	. = ..()
	new /obj/item/bomb/smoke(src)
	new /obj/item/bomb/smoke(src)
	new /obj/item/bomb/smoke(src)
	new /obj/item/bomb/smoke(src)

/datum/inqports/supplies/psybuns
	name = "奥塔瓦面包坊特供"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/psybuns
	marquescost = 8

/obj/structure/closet/crate/chest/inqcrate/supplies/psybuns/Initialize(mapload)
	. = ..()
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/food/snacks/rogue/psycrossbun(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/blessedwater(src)

/datum/inqports/supplies/bottlebombs
	name = "3 枚瓶装炸弹"
	item_type = /obj/structure/closet/crate/chest/inqcrate/supplies/bottlebombs
	marquescost = 12

/obj/structure/closet/crate/chest/inqcrate/supplies/bottlebombs/Initialize(mapload)
	. = ..()
	new /obj/item/bomb(src)
	new /obj/item/bomb(src)
	new /obj/item/bomb(src)

/datum/inqports/supplies/bullion
	name = "6 块祝圣银锭"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic/bullion/
	marquescost = 16

/obj/structure/closet/crate/chest/inqreliquary/relic/bullion/Initialize(mapload)
	. = ..()
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)
	new /obj/item/ingot/silverblessed/bullion(src)


// ✤ ARTICLES ✤ RIGHT HERE! THAT'S RIGHT!

/datum/inqports/articles/quicksilver
	name = "1 份应急药膏"
	item_type = /obj/item/quicksilver
	maximum = 1
	marquescost = 12

/datum/inqports/articles/psycrosssilver
	name = "1 枚银制普赛圣十字"
	item_type = /obj/item/clothing/neck/roguetown/psicross/silver
	marquescost = 14

/datum/inqports/articles/psycross
	name = "1 枚普赛圣十字"
	item_type = /obj/item/clothing/neck/roguetown/psicross
	marquescost = 2

/datum/inqports/articles/indexaccused
	name = "3 个 编目机、3 份控诉书"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/indexaccused
	marquescost = 6

/obj/structure/closet/crate/chest/inqcrate/articles/indexaccused/Initialize(mapload)
	. = ..()
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/paper/inqslip/accusation(src)
	new /obj/item/paper/inqslip/accusation(src)
	new /obj/item/paper/inqslip/accusation(src)

/*
/datum/inqports/articles/indexers
	name = "3 个 编目机"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/indexers
	marquescost = 4

/obj/structure/closet/crate/chest/inqcrate/articles/indexers/Initialize(mapload)
	. = ..()
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)
	new /obj/item/inqarticles/indexer(src)
*/
/*
/datum/inqports/articles/accusations
	name = "3 份控诉书"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/accusations
	marquescost = 8

/obj/structure/closet/crate/chest/inqcrate/articles/accusations/Initialize(mapload)
	. = ..()
	new /obj/item/paper/inqslip/accusation(src)
	new /obj/item/paper/inqslip/accusation(src)
	new /obj/item/paper/inqslip/accusation(src)
*/

/datum/inqports/articles/confessions
	name = "3 份供词"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/confessions
	marquescost = 12

/obj/structure/closet/crate/chest/inqcrate/articles/confessions/Initialize(mapload)
	. = ..()
	new /obj/item/paper/inqslip/confession(src)
	new /obj/item/paper/inqslip/confession(src)
	new /obj/item/paper/inqslip/confession(src)

/datum/inqports/articles/psybles
	name = "3 本普赛登圣书"
	item_type = /obj/structure/closet/crate/chest/inqcrate/articles/psybles
	marquescost = 6

/obj/structure/closet/crate/chest/inqcrate/articles/psybles/Initialize(mapload)
	. = ..()
	new /obj/item/book/rogue/bibble/psy(src)
	new /obj/item/book/rogue/bibble/psy(src)
	new /obj/item/book/rogue/bibble/psy(src)

/datum/inqports/articles/bmirror
	name = "1 面黑镜"
	item_type = /obj/item/inqarticles/bmirror
	marquescost = 8

/datum/inqports/articles/listener
	name = "1 只留神之耳"
	item_type = /obj/item/listeningdevice
	marquescost = 4

/datum/inqports/articles/whisperer
	name = "1 个密语低语器"
	item_type = /obj/item/speakerinq
	marquescost = 8


// ✤ EQUIPMENT ✤ BELONGS HERE! JUST BELOW!

/datum/inqports/equipment/psydonthorns
	name = "1 副普赛登荆棘腕甲"
	item_type = /obj/item/clothing/wrists/roguetown/bracers/psythorns
	marquescost = 12

/datum/inqports/equipment/garrote
	name = "1 条绞喉索"
	item_type = /obj/item/inqarticles/garrote
	marquescost = 4

/datum/inqports/equipment/strangemask
	name = "1 张告解面具"
	item_type = /obj/item/clothing/mask/rogue/facemask/steel/confessor
	marquescost = 10

/datum/inqports/equipment/otavansatchel
	name = "1 个奥塔瓦皮挎包"
	item_type = /obj/item/storage/backpack/rogue/satchel/otavan
	marquescost = 8

/datum/inqports/equipment/psysack
	name = "1 个身份遮蔽器"
	item_type = /obj/item/clothing/mask/rogue/sack/psy
	marquescost = 6

/datum/inqports/equipment/inqcordage
	name = "2 卷审讯绳索"
	item_type = /obj/structure/closet/crate/chest/inqcrate/equipment/inqcordage
	marquescost = 4

/obj/structure/closet/crate/chest/inqcrate/equipment/inqcordage/Initialize(mapload)
	. = ..()
	new /obj/item/rope/inqarticles/inquirycord(src)
	new /obj/item/rope/inqarticles/inquirycord(src)

/datum/inqports/equipment/blackbags
	name = "3 个黑头套"
	item_type = /obj/structure/closet/crate/chest/inqcrate/equipment/blackbags
	marquescost = 8

/obj/structure/closet/crate/chest/inqcrate/equipment/blackbags/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/head/inqarticles/blackbag(src)
	new /obj/item/clothing/head/inqarticles/blackbag(src)
	new /obj/item/clothing/head/inqarticles/blackbag(src)


/datum/inqports/equipment/psydonhelms
	name = "普赛登头盔组"
	item_type = /obj/structure/closet/crate/chest/inqcrate/equipment/psydonhelms
	marquescost = 12
	maximum = 1

/obj/structure/closet/crate/chest/inqcrate/equipment/psydonhelms/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute(src)
	new /obj/item/clothing/head/roguetown/helmet/heavy/psysallet(src)
	new /obj/item/clothing/head/roguetown/helmet/heavy/psybucket(src)
	new /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm(src)

/datum/inqports/equipment/crankbox
	name = "摇柄匣"
	item_type = /obj/structure/closet/crate/chest/inqreliquary/relic/crankbox/
	marquescost = 16
	maximum = 1

/obj/structure/closet/crate/chest/inqreliquary/relic/crankbox/Initialize(mapload)
	. = ..()
	new /obj/item/psydonmusicbox(src)

/datum/inqports/equipment/nocshades
	name = "1 副夜影镜片"
	item_type = /obj/item/clothing/mask/rogue/spectacles/inq
	marquescost = 12

// ✤ WARDROBE ✤ STARTS HERE! YEP!

/obj/item/clothing/neck/roguetown/fencerguard/inq
	color = "#8b1414"
	detail_color = "#99b2b1"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq
	color = "#8b1414"
	detail_color = "#99b2b1"

/datum/inqports/wardrobe/fencerset
	name = "奥塔瓦击剑师精品套装箱"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/fencerset
	marquescost = 12

/obj/structure/closet/crate/chest/inqcrate/wardrobe/fencerset/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq(src)
	new /obj/item/clothing/neck/roguetown/fencerguard/inq(src)
	new /obj/item/clothing/gloves/roguetown/otavan(src)
	new /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan(src)
	new /obj/item/clothing/shoes/roguetown/boots/otavan(src)

/datum/inqports/wardrobe/confessionalcombo
	name = "告解套装"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/confessionalcombo
	marquescost = 10

/obj/structure/closet/crate/chest/inqcrate/wardrobe/confessionalcombo/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/head/roguetown/roguehood/psydon/confessor(src)
	new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor(src)

/datum/inqports/wardrobe/inspectorcoat
	name = "宗审精品大衣与帽饰"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/inspectorcoats
	marquescost = 10

/obj/structure/closet/crate/chest/inqcrate/wardrobe/inspectorcoats/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/head/roguetown/inqhat(src)
	new /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat(src)
	new /obj/item/clothing/head/roguetown/inqhat(src)
	new /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat(src)

/datum/inqports/wardrobe/inspector
	name = "宗审巡察官精选箱"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/inspector
	marquescost = 10

/obj/structure/closet/crate/chest/inqcrate/wardrobe/inspector/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/head/roguetown/inqhat(src)
	new /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat(src)
	new /obj/item/clothing/gloves/roguetown/otavan/inqgloves(src)
	new /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots(src)

/datum/inqports/wardrobe/fencersthree
	name = "击剑师护身棉甲三件套"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/fencersthree
	marquescost = 12

/obj/structure/closet/crate/chest/inqcrate/wardrobe/fencersthree/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq(src)
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq(src)
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan/inq(src)

/datum/inqports/wardrobe/psydonianstandard
	name = "宗审标准配装"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/psydonian
	marquescost = 10

/obj/structure/closet/crate/chest/inqcrate/wardrobe/psydonian/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan(src)
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq(src)
	new /obj/item/clothing/gloves/roguetown/otavan/psygloves(src)
	new /obj/item/clothing/shoes/roguetown/boots/psydonboots(src)

/datum/inqports/wardrobe/nobledressup
	name = "贵族代价箱"
	item_type = /obj/structure/closet/crate/chest/inqcrate/wardrobe/nobledressup
	marquescost = 18

/obj/structure/closet/crate/chest/inqcrate/wardrobe/nobledressup/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/cloak/lordcloak/ladycloak(src)
	new /obj/item/clothing/cloak/lordcloak(src)
	new /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat(src)
	new /obj/item/clothing/suit/roguetown/shirt/dress/royal(src)
	new /obj/item/clothing/wrists/roguetown/royalsleeves(src)
	new /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince(src)
