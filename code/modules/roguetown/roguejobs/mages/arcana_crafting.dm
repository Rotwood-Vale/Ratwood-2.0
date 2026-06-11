/datum/crafting_recipe/roguetown/arcana
	req_table = TRUE
	tools = list()
	category = "奥术"
	abstract_type = /datum/crafting_recipe/roguetown/arcana
	skillcraft = /datum/skill/magic/arcane
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/arcana/amethyst
	name = "艾米索兹"
	result = /obj/item/roguegem/amethyst
	reqs = list(/obj/item/natural/stone = 1,
				/datum/reagent/medicine/manapot = 15)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/artifact
	name = "符文器物"
	result = /obj/item/magic/artifact
	reqs = list(/obj/item/natural/rock = 1,
				/datum/reagent/medicine/manapot = 15)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/rawmana
	name = "法力水晶"
	result = /obj/item/magic/manacrystal
	reqs = list(/datum/reagent/medicine/manapot = 45)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/chalk
	name = "粉笔"
	result = /obj/item/chalk
	reqs = list(/obj/item/rogueore/cinnabar = 1,
				/datum/reagent/medicine/manapot = 15)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/ritechalk
	name = "ritual chalk (blessed)"
	skillcraft = /datum/skill/magic/holy
	result = /obj/item/ritechalk
	reqs = list(/obj/item/rogueore/cinnabar = 1,
				/datum/reagent/water/blessed = 15)
	craftdiff = 2
	craft_xp_override = 0

/datum/crafting_recipe/roguetown/arcana/ritechalk_unholy
	name = "ritual chalk (unholy)"
	skillcraft = /datum/skill/magic/holy
	result = /obj/item/ritechalk
	reqs = list(/obj/item/rogueore/cinnabar = 1,
				/datum/reagent/water/cursed = 15)
	craftdiff = 2
	craft_xp_override = 0

/datum/crafting_recipe/roguetown/arcana/infernalfeather
	name = "炼狱羽毛"
	result = /obj/item/natural/feather/infernal
	reqs = list(/obj/item/natural/feather = 1,
				/obj/item/magic/infernal/ash = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/sendingstone
	name = "传讯石"
	result = /obj/item/sendingstonesummoner
	reqs = list(/obj/item/natural/stone = 2,
				/obj/item/roguegem/amethyst = 2,
				/obj/item/magic/melded/t1 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/voidlamptern
	name = "虚空提灯"
	result = /obj/item/flashlight/flare/torch/lantern/voidlamptern
	reqs = list(/obj/item/flashlight/flare/torch/lantern = 1,
				/obj/item/magic/obsidian = 1,
				/obj/item/magic/melded/t1 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/nomagiccollar
	name = "法力束缚项圈"
	result = /obj/item/clothing/neck/roguetown/collar/leather/nomagic
	reqs = list(/obj/item/clothing/neck/roguetown/collar = 1,
				/obj/item/roguegem = 1,
				/obj/item/magic/melded/t2 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/nomagicglove
	name = "法力束缚手套"
	result = /obj/item/clothing/gloves/roguetown/nomagic
	reqs = list(/obj/item/clothing/gloves/roguetown/leather = 1,
				/obj/item/roguegem = 1,
				/obj/item/magic/melded/t3 = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/temporalhourglass
	name = "时序沙漏"
	result = /obj/item/hourglass/temporal
	reqs = list(/obj/item/natural/wood/plank = 4,
				/obj/item/magic/leyline = 1,
				/obj/item/magic/melded/t2 = 1)
	craftdiff = 3


/datum/crafting_recipe/roguetown/arcana/shimmeringlens
	name = "微光透镜"
	result = /obj/item/clothing/ring/active/shimmeringlens
	reqs = list(/obj/item/magic/fae/scale = 1,
				/obj/item/magic/leyline = 1,
				/obj/item/magic/melded/t2 = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/mimictrinket
	name = "拟态饰物"
	result = /obj/item/mimictrinket
	reqs = list(/obj/item/natural/wood/plank = 2,
				/obj/item/magic/melded/t1 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/binding
	name = "束缚镣铐"
	result = /obj/item/rope/chain/bindingshackles
	reqs = list(/obj/item/rope/chain = 2,
				/obj/item/magic/melded/t1 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/bindingt2
	name = "束缚镣铐 (T2)"
	result = /obj/item/rope/chain/bindingshackles/t2
	reqs = list(/obj/item/rope/chain/bindingshackles = 1,
				/obj/item/magic/melded/t2 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/bindingt3
	name = "束缚镣铐 (T3)"
	result = /obj/item/rope/chain/bindingshackles/t3
	reqs = list(/obj/item/rope/chain/bindingshackles/t2 = 1,
				/obj/item/magic/melded/t3 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/bindingt4
	name = "束缚镣铐 (T4)"
	result = /obj/item/rope/chain/bindingshackles/t4
	reqs = list(/obj/item/rope/chain/bindingshackles/t3 = 1,
				/obj/item/magic/melded/t4 = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/bindingt5
	name = "束缚镣铐 (T5)"
	result = /obj/item/rope/chain/bindingshackles/t5
	reqs = list(/obj/item/rope/chain/bindingshackles/t4 = 1,
				/obj/item/magic/voidstone = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/forge
	name = "炼狱熔炉"
	req_table = FALSE
	result = /obj/machinery/light/rogue/forge/arcane
	reqs = list(/obj/item/magic/infernal/core = 1,
				/obj/item/natural/stone = 4)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/nullring
	name = "无魔之戒"
	result = /obj/item/clothing/ring/active/nomag
	reqs = list(/obj/item/clothing/ring/gold = 1,
				/obj/item/magic/voidstone = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/arcana/meldt1
	name = "奥术熔合物"
	result = /obj/item/magic/melded/t1
	reqs = list(/obj/item/magic/infernal/ash = 1,
				/obj/item/magic/fae/dust = 1,
				/obj/item/magic/elemental/mote = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/meldt2
	name = "致密奥术熔合物"
	result = /obj/item/magic/melded/t2
	reqs = list(/obj/item/magic/infernal/fang = 1,
				/obj/item/magic/fae/scale = 1,
				/obj/item/magic/elemental/shard = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/meldt3
	name = "术法织物"
	result = /obj/item/magic/melded/t3
	reqs = list(/obj/item/magic/infernal/core = 1,
				/obj/item/magic/fae/core = 1,
				/obj/item/magic/elemental/fragment = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/meldt4
	name = "魔力汇流"
	result = /obj/item/magic/melded/t4
	reqs = list(/obj/item/magic/infernal/flame = 1,
				/obj/item/magic/fae/essence = 1,
				/obj/item/magic/elemental/relic = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/meldt5
	name = "奥术畸变体"
	result = /obj/item/magic/melded/t5
	reqs = list(/obj/item/magic/melded/t4 = 1,
				/obj/item/magic/voidstone = 1)
	craftdiff = 2

//upward conversions of materials

//fae conversions

/datum/crafting_recipe/roguetown/arcana/fairydust //T1 mage summon loot
	name = "仙灵粉尘 -（2 颗浆果，1 份结晶法力）"
	result = /obj/item/magic/fae/dust
	reqs = list(/obj/item/magic/manacrystal = 1,
				/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/iridescentscale //T2 mage summon loot
	name = "虹彩鳞片 -（2 份仙灵粉尘，1 条鱼）"
	result = /obj/item/magic/fae/scale
	reqs = list(/obj/item/magic/fae/dust = 2,
				/obj/item/reagent_containers/food/snacks/fish = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/heartwoodcore //T3 mage summon loot
	name = "心木核心 -（2 份虹彩鳞片，1 根小原木）"
	result = /obj/item/magic/fae/core
	reqs = list(/obj/item/magic/fae/scale = 2,
				/obj/item/grown/log/tree/small = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/arcana/sylvanessence //T4 mage summon loot
	name = "林地精华 -（4 份心木核心，1 颗绿宝石）"
	result = /obj/item/magic/fae/essence
	reqs = list(/obj/item/magic/fae/core = 4,
				/obj/item/roguegem/green = 1)
	craftdiff = 5

//elemenmtal conversions

/datum/crafting_recipe/roguetown/arcana/elementalmote //T1 mage summon loot
	name = "元素微粒" //making this one a little harder as mining will also produce some
	result = /obj/item/magic/elemental/mote
	reqs = list(/obj/item/magic/manacrystal = 1,
				/obj/item/magic/artifact = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/elementalshard //T2 mage summon loot
	name = "元素碎片"
	result = /obj/item/magic/elemental/shard
	reqs = list(/obj/item/magic/elemental/mote = 2,
				/obj/item/rogueore/copper = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/elementalfragment //T3 mage summon loot
	name = "元素残片"
	result = /obj/item/magic/elemental/fragment
	reqs = list(/obj/item/magic/elemental/shard = 3,
				/obj/item/rogueore/iron = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/arcana/elementalrelic //T4 mage summon loot
	name = "元素遗物"
	result = /obj/item/magic/elemental/relic
	reqs = list(/obj/item/magic/elemental/fragment = 4,
				/obj/item/roguegem/yellow = 1)
	craftdiff = 5

//infernal conversions
/datum/crafting_recipe/roguetown/arcana/infernalash //T1 mage summon loot
	name = "炼狱灰烬"
	result = /obj/item/magic/infernal/ash
	reqs = list(/obj/item/magic/manacrystal = 1,
				/obj/item/ash = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/arcana/hellhoundfang //T2 mage summon loot
	name = "地狱犬之牙"
	result = /obj/item/magic/infernal/fang
	reqs = list(/obj/item/magic/infernal/ash = 2,
				/obj/item/natural/bone = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/infernalcore //T3 mage summon loot
	name = "炼狱核心"
	result = /obj/item/magic/infernal/core
	reqs = list(/obj/item/magic/infernal/fang = 3,
				/obj/item/rogueore/coal = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/arcana/abyssalflame //T4 mage summon loot
	name = "深渊火焰"
	result = /obj/item/magic/infernal/flame
	reqs = list(/obj/item/magic/infernal/core = 2,
				/obj/item/roguegem/ruby = 1)
	craftdiff = 5

//conversion material for some hard to find materials that don't have a use
/datum/crafting_recipe/roguetown/arcana/arcynefission1 //gives some T1 and T2 arcane material
	name = "奥术裂变"
	result = list(/obj/item/magic/manacrystal, /obj/item/magic/manacrystal,
				  /obj/item/magic/manacrystal,
				  /obj/item/magic/infernal/ash,
				  /obj/item/magic/infernal/fang,
				  /obj/item/magic/fae/dust,
				  /obj/item/magic/fae/scale,
				  /obj/item/magic/elemental/mote,
				  /obj/item/magic/elemental/shard)
	reqs = list(/obj/item/natural/cured/essence = 1,
				/datum/reagent/water/salty = 15,
				/obj/item/natural/clay = 5,
				/obj/item/skull = 1,
				/obj/item/rogueore/cinnabar = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/arcana/arcynefission2 //gives T1, T2, and T3 arcane material, sorry Tudon
	name = "arcyne 裂变"
	result = list(/obj/item/magic/manacrystal,
				  /obj/item/magic/manacrystal,
				  /obj/item/magic/manacrystal,
				  /obj/item/magic/manacrystal,
				  /obj/item/magic/manacrystal,
				  /obj/item/magic/infernal/ash,
				  /obj/item/magic/infernal/ash,
				  /obj/item/magic/infernal/fang,
				  /obj/item/magic/infernal/fang,
				  /obj/item/magic/infernal/core,
				  /obj/item/magic/fae/dust,
				  /obj/item/magic/fae/dust,
				  /obj/item/magic/fae/scale,
				  /obj/item/magic/fae/scale,
				  /obj/item/magic/fae/core,
				  /obj/item/magic/elemental/mote,
				  /obj/item/magic/elemental/mote,
				  /obj/item/magic/elemental/shard,
				  /obj/item/magic/elemental/shard,
				  /obj/item/magic/elemental/fragment,)
	reqs = list(/obj/item/phylactery = 1,
				/datum/reagent/water/salty = 15,
				/obj/item/natural/clay = 5,
				/obj/item/rogueore/silver= 1,
				/obj/item/rogueore/cinnabar = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/arcana/findfamiliar
	name = "寻觅魔宠卷轴"
	result = /obj/item/book/granter/spell/blackstone/familiar
	reqs = list(/obj/item/magic/manacrystal = 1,
				/obj/item/paper/scroll = 1)
	craftdiff = 1
