/datum/anvil_recipe/valuables
	abstract_type = /datum/anvil_recipe/valuables
	appro_skill = /datum/skill/craft/blacksmithing
	craftdiff = SKILL_LEVEL_JOURNEYMAN // These are VALUABLES
	i_type = "Valuables"

/datum/anvil_recipe/valuables/gold
	name = "雕像, 黄金"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/roguestatue/gold
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/silver
	name = "雕像, 白银"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/roguestatue/silver
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/iron
	name = "雕像, 铁"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/roguestatue/iron

/datum/anvil_recipe/valuables/decrepit
	name = "Statue, Decrepit" // decrepit
	req_bar = /obj/item/ingot/decrepit
	created_item = /obj/item/roguestatue/decrepit

/datum/anvil_recipe/valuables/steel
	name = "雕像, 钢"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/roguestatue/steel

/datum/anvil_recipe/valuables/blacksteel
	name = "雕像, 黑钢"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/roguestatue/blacksteel
/*
/datum/anvil_recipe/valuables/eargol
	name = "gold 耳环"
	req_bar = /obj/item/ingot/gold
	created_item = list(/obj/item/rogueacc/eargold,
						/obj/item/rogueacc/eargold,
						/obj/item/rogueacc/eargold)
	type = "Valuables"

/datum/anvil_recipe/valuables/earsil
	name = "silver 耳环"
	req_bar = /obj/item/ingot/silver
	created_item = list(/obj/item/rogueacc/earsilver,
						/obj/item/rogueacc/earsilver,
						/obj/item/rogueacc/earsilver)*/
//	i_type = "Valuables"

/datum/anvil_recipe/valuables/ringg
	name = "戒指, 黄金 (x3)"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/ring/gold
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 3

/datum/anvil_recipe/valuables/ringa
	name = "戒指, 衰朽 (x3)"
	req_bar = /obj/item/ingot/decrepit
	created_item = /obj/item/clothing/ring/decrepit
	createditem_num = 3

/datum/anvil_recipe/valuables/rings
	name = "戒指, 白银 (x3)"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/clothing/ring/silver
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 3

/datum/anvil_recipe/valuables/ringbs
	name = "戒指, 黑钢 (x3)"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/ring/blacksteel
	createditem_num = 3

/datum/anvil_recipe/valuables/ornateamulet
	name = "华饰护符"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/neck/roguetown/ornateamulet
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/skullamulet
	name = "颅骨护符"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/neck/roguetown/skullamulet
	craftdiff = SKILL_LEVEL_EXPERT

//Gold Rings
/datum/anvil_recipe/valuables/emeringg
	name = "翠晶 戒指, 黄金 (+1 翠晶)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegem/green)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/ring/emerald

/datum/anvil_recipe/valuables/rubyg
	name = "隆兹石 戒指, 黄金 (+1 隆兹石)"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	additional_items = list(/obj/item/roguegem/ruby)
	created_item = /obj/item/clothing/ring/ruby

/datum/anvil_recipe/valuables/topazg
	name = "托珀石 戒指, 黄金 (+1 托珀石)"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	additional_items = list(/obj/item/roguegem/yellow)
	created_item = /obj/item/clothing/ring/topaz

/datum/anvil_recipe/valuables/quartzg
	name = "布洛兹石 戒指, 黄金 (+1 布洛兹石)"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	additional_items = list(/obj/item/roguegem/blue)
	created_item = /obj/item/clothing/ring/quartz
	i_type = "Valuables"

/datum/anvil_recipe/valuables/sapphireg
	name = "蓝晶 戒指, 黄金 (+1 蓝晶)"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	additional_items = list(/obj/item/roguegem/violet)
	created_item = /obj/item/clothing/ring/sapphire

/datum/anvil_recipe/valuables/diamondg
	name = "多佩尔石 戒指, 黄金 (+1 多佩尔石)"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	additional_items = list(/obj/item/roguegem/diamond)
	created_item = /obj/item/clothing/ring/diamond

/datum/anvil_recipe/valuables/signet
	name = "印戒"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/ring/signet

/datum/anvil_recipe/valuables/signet/silver
	name = "祝福白银印戒"
	craftdiff = SKILL_LEVEL_MASTER
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/clothing/ring/signet/silver

/datum/anvil_recipe/valuables/signet/silver/inq
	name = "Blessed Silver Signet Ring"
	craftdiff = SKILL_LEVEL_MASTER
	req_bar = /obj/item/ingot/silverblessed/bullion
	created_item = /obj/item/clothing/ring/signet/silver

// Silver ingots are now in play, and as such, the steel rings have been converted to silver with their value adjusted accordingly. -Kyogon

/datum/anvil_recipe/valuables/emerings
	name = "翠晶 戒指, 白银 (+1 翠晶)"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_MASTER
	additional_items = list(/obj/item/roguegem/green)
	created_item = /obj/item/clothing/ring/emeralds

/datum/anvil_recipe/valuables/rubys
	name = "隆兹石 戒指, 白银 (+1 隆兹石)"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_MASTER
	additional_items = list(/obj/item/roguegem/ruby)
	created_item = /obj/item/clothing/ring/rubys

/datum/anvil_recipe/valuables/topazs
	name = "托珀石 戒指, 白银 (+1 托珀石)"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_MASTER
	additional_items = list(/obj/item/roguegem/yellow)
	created_item = /obj/item/clothing/ring/topazs

/datum/anvil_recipe/valuables/quartzs
	name = "布洛兹石 戒指, 白银 (+1 布洛兹石)"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_MASTER
	additional_items = list(/obj/item/roguegem/blue)
	created_item = /obj/item/clothing/ring/quartzs

/datum/anvil_recipe/valuables/sapphires
	name = "蓝晶 戒指, 白银 (+1 蓝晶)"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_MASTER
	additional_items = list(/obj/item/roguegem/violet)
	created_item = /obj/item/clothing/ring/sapphires

/datum/anvil_recipe/valuables/diamonds
	name = "多佩尔石 戒指, 白银 (+1 多佩尔石)"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_MASTER
	additional_items = list(/obj/item/roguegem/diamond)
	created_item = /obj/item/clothing/ring/diamonds

/datum/anvil_recipe/valuables/terminus
	name = "特米努斯之终 (+1 黄金 Bar, +1 钢, +1 隆兹石)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/steel, /obj/item/roguegem/ruby)
	created_item = /obj/item/rogueweapon/sword/long/exe/cloth
	craftdiff = SKILL_LEVEL_MASTER
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"

/datum/anvil_recipe/valuables/dragon
	name = "龙石戒指 (秘密！)"
	req_bar = /obj/item/ingot/blacksteel
	hides_from_books = TRUE
	additional_items = list(/obj/item/ingot/gold, /obj/item/roguegem/blue, /obj/item/roguegem/violet, /obj/item/clothing/neck/roguetown/psicross/silver)
	created_item = /obj/item/clothing/ring/dragon_ring
	craftdiff = SKILL_LEVEL_LEGENDARY

/datum/anvil_recipe/valuables/zcross_iron
	name = "逆十字灵印"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen
	craftdiff = 1

//blacksteel Rings
/datum/anvil_recipe/valuables/emeringbs
	name = "翠晶 戒指, 黑钢 (+1 翠晶)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/roguegem/green)
	created_item = /obj/item/clothing/ring/emeraldbs

/datum/anvil_recipe/valuables/rubybs
	name = "隆兹石 戒指, 黑钢 (+1 隆兹石)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/roguegem/ruby)
	created_item = /obj/item/clothing/ring/rubybs

/datum/anvil_recipe/valuables/topazbs
	name = "托珀石 戒指, 黑钢 (+1 托珀石)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/roguegem/yellow)
	created_item = /obj/item/clothing/ring/topazbs

/datum/anvil_recipe/valuables/quartzbs
	name = "布洛兹石 戒指, 黑钢 (+1 布洛兹石)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/roguegem/blue)
	created_item = /obj/item/clothing/ring/quartzbs
	i_type = "Valuables"

/datum/anvil_recipe/valuables/sapphirebs
	name = "蓝晶 戒指, 黑钢 (+1 蓝晶)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/roguegem/violet)
	created_item = /obj/item/clothing/ring/sapphirebs

/datum/anvil_recipe/valuables/diamondbs
	name = "多佩尔石 戒指, 黑钢 (+1 多佩尔石)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/roguegem/diamond)
	created_item = /obj/item/clothing/ring/diamondbs

/datum/anvil_recipe/valuables/hope
	name = "全能之戒 (秘密！)"
	req_bar = /obj/item/ingot/silver
	hides_from_books = TRUE
	additional_items = list(/obj/item/clothing/ring/statgemerald, /obj/item/clothing/ring/statonyx, /obj/item/clothing/ring/statamythortz, /obj/item/clothing/ring/statrontz)
	created_item = /obj/item/clothing/ring/statdorpel
	craftdiff = SKILL_LEVEL_LEGENDARY

/datum/anvil_recipe/valuables/daemonslayer
	name = "斩魔者 (秘密！)"
	req_bar = /obj/item/ingot/silver
	hides_from_books = TRUE
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver/, /obj/item/ingot/draconic, /obj/item/ingot/weeping, /obj/item/riddleofsteel, /obj/item/grown/log/tree)
	created_item = /obj/item/rogueweapon/greatsword/psygsword/dragonslayer
	appro_skill = /datum/skill/craft/weaponsmithing
	craftdiff = SKILL_LEVEL_LEGENDARY
