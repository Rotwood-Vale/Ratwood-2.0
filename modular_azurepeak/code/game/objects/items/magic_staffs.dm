#define TOPER_CAST_TIME_REDUCTION 0.1
#define EMERALD_CAST_TIME_REDUCTION 0.15
#define SAPPHIRE_CAST_TIME_REDUCTION 0.2
#define QUARTZ_CAST_TIME_REDUCTION 0.25
#define RUBY_CAST_TIME_REDUCTION 0.3
#define DIAMOND_CAST_TIME_REDUCTION 0.35
#define RIDDLE_OF_STEEL_CAST_TIME_REDUCTION 0.4

//we use discrete staff objs so that they can be easily thrown into loot tables and maps without complex varediting

/obj/item/rogueweapon/woodstaff
	var/cast_time_reduction = null

/obj/item/rogueweapon/woodstaff/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/gemstaff/toper_staff,
		/datum/crafting_recipe/gemstaff/amethyst_staff,
		/datum/crafting_recipe/gemstaff/emerald_staff,
		/datum/crafting_recipe/gemstaff/sapphire_staff,
		/datum/crafting_recipe/gemstaff/quartz_staff,
		/datum/crafting_recipe/gemstaff/ruby_staff,
		/datum/crafting_recipe/gemstaff/diamond_staff,
		/datum/crafting_recipe/gemstaff/riddle_of_steel_staff,
		/datum/crafting_recipe/gemstaff/blacksteelstaffupgrade,
		/datum/crafting_recipe/gemstaff/ducalblacksteelstaffupgrade,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/rogueweapon/woodstaff/toper
	name = "托珀石聚焦法杖"
	desc = "一枚由巨大压力雕琢而成的琥珀色聚焦宝石，安稳镶嵌在这根法杖的杖首。"
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "topazstaff"
	cast_time_reduction = TOPER_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF //imagine the salt
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 34

/obj/item/rogueweapon/woodstaff/amethyst
	name = "紫水晶聚焦法杖"
	desc = "一枚由巨大压力雕琢而成的紫色聚焦宝石，安稳镶嵌在这根法杖的杖首。"
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "amethyststaff"
	cast_time_reduction = TOPER_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)

/obj/item/rogueweapon/woodstaff/emerald
	name = "翠晶聚焦法杖"
	desc = "一枚由巨大压力雕琢而成、闪耀着绿辉的聚焦宝石，安稳镶嵌在这根法杖的杖首。"
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "emeraldstaff"
	cast_time_reduction = EMERALD_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 42

/obj/item/rogueweapon/woodstaff/emerald/blacksteelstaff
	name = "黑钢法杖"
	desc = "一根优质木杖，以黑钢铆钉与配件加固，常为毕业于天穹魔导学院的战斗魔导士所用。杖首安置着一枚效率稍逊、却同样美丽的炼金多佩尔石。也许我能用更好的多佩尔石来强化它？"
	icon_state = "blacksteelstaff"
	max_integrity = 300 // 100 more integrity than a steel quarterstaff due to it's blacksteel nature. Can't smelt it down though :)
	sellprice = 60

/obj/item/rogueweapon/woodstaff/emerald/blacksteelstaff/royal
	name = "公爵黑钢法杖"
	desc = "一根以黑钢铆钉与镶板加固的法师法杖。这是赠予早慧继承人的奢华礼物，既是施法器具，也是身份象征。然而它所用的炼金多佩尔石让它整体上仍只是件较为平庸的导能工具。也许换上真正的多佩尔石会更好？"
	sellprice = 100

/obj/item/rogueweapon/woodstaff/sapphire
	name = "蓝晶聚焦法杖"
	desc = "一枚由巨大压力雕琢而成的美丽蓝色聚焦宝石，安稳镶嵌在这根法杖的杖首。"
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "sapphirestaff"
	cast_time_reduction = SAPPHIRE_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 56

/obj/item/rogueweapon/woodstaff/quartz
	name = "布洛兹石聚焦法杖"
	desc = "一枚由巨大压力雕琢而成、晶莹通透的聚焦宝石，安稳镶嵌在这根法杖的杖首。"
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "quartzstaff"
	cast_time_reduction = QUARTZ_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 88

/obj/item/rogueweapon/woodstaff/ruby
	name = "隆兹石聚焦法杖"
	desc = "一枚由巨大压力雕琢而成、血色鲜明的聚焦宝石，安稳镶嵌在这根法杖的杖首。"
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "rubystaff"
	cast_time_reduction = RUBY_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 100

/obj/item/rogueweapon/woodstaff/diamond
	name = "多佩尔石聚焦法杖"
	desc = "一枚由巨大压力雕琢而成、切面优美的聚焦宝石，安稳镶嵌在这根法杖的杖首。"
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "diamondstaff"
	cast_time_reduction = DIAMOND_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 121

/obj/item/rogueweapon/woodstaff/diamond/blacksteelstaff // Upgraded version, more CDR can be crafted by combining a base Blacksteel Staff with a dorpel
	name = "精制黑钢法杖"
	desc = "一根优质木杖，以黑钢铆钉与配件加固，常为毕业于天穹魔导学院的战斗魔导士所用。杖首安置着一枚崭新而美丽的多佩尔石，闪耀着魔力流光。"
	icon_state = "blacksteelstaff"
	max_integrity = 300 // 100 more integrity than a steel quarterstaff due to it's blacksteel nature. Can't smelt it down though :)
	sellprice = 160

/obj/item/rogueweapon/woodstaff/diamond/blacksteelstaff/royal
	name = "refined ducal blacksteel staff"
	desc = "A mage's staff that has been reinforced with blacksteel rivets and plating. An extravagent gift for a precocious heir that serves as both casting implement and mark of station. Perched atop it is a new beautiful Dorpel that shimmers with magical energies."
	sellprice = 230

/obj/item/rogueweapon/woodstaff/riddle_of_steel
	name = "\improper 谜钢法杖"
	desc = "火焰在这柄强大法杖的聚焦宝石中起舞，其节奏与烈度皆与\
	持杖法师相呼应。"
	icon = 'modular_azurepeak/icons/obj/items/staffs.dmi'
	icon_state = "riddlestaff"
	cast_time_reduction = RIDDLE_OF_STEEL_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH, /datum/intent/special/magicarc)
	gripped_intents = list(SPEAR_BASH, /datum/intent/special/magicarc, /datum/intent/mace/smash/wood)
	sellprice = 400

/obj/item/rogueweapon/woodstaff/riddle_of_steel/magos
	name = "\improper 宫廷魔导士法杖"
	icon_state = "courtstaff"

/obj/item/rogueweapon/woodstaff/naledi
	cast_time_reduction = DIAMOND_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF
	sellprice = 40

/obj/item/rogueweapon/woodstaff/sojourner
	cast_time_reduction = EMERALD_CAST_TIME_REDUCTION
	resistance_flags = FIRE_PROOF

//crafting datums

/datum/crafting_recipe/gemstaff
	abstract_type = /datum/crafting_recipe/gemstaff

/datum/crafting_recipe/gemstaff/toper_staff
	name = "托珀石聚焦法杖"
	result = /obj/item/rogueweapon/woodstaff/toper
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/yellow = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/amethyst_staff
	name = "紫水晶聚焦法杖"
	result = /obj/item/rogueweapon/woodstaff/amethyst
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/amethyst = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/emerald_staff
	name = "翠晶聚焦法杖"
	result = /obj/item/rogueweapon/woodstaff/emerald
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/green = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/sapphire_staff
	name = "蓝晶聚焦法杖"
	result = /obj/item/rogueweapon/woodstaff/sapphire
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/violet = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/quartz_staff
	name = "布洛兹石聚焦法杖"
	result = /obj/item/rogueweapon/woodstaff/quartz
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/blue = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/ruby_staff
	name = "隆兹石聚焦法杖"
	result = /obj/item/rogueweapon/woodstaff/ruby
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/ruby = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/diamond_staff
	name = "多佩尔石聚焦法杖"
	result = /obj/item/rogueweapon/woodstaff/diamond
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/roguegem/diamond = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/riddle_of_steel_staff
	name = "谜钢法杖"
	result = /obj/item/rogueweapon/woodstaff/riddle_of_steel
	reqs = list(/obj/item/rogueweapon/woodstaff = 1,
				/obj/item/riddleofsteel = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/blacksteelstaffupgrade
	name = "精制黑钢法杖"
	result = /obj/item/rogueweapon/woodstaff/diamond/blacksteelstaff
	reqs = list(/obj/item/rogueweapon/woodstaff/emerald/blacksteelstaff = 1,
				/obj/item/roguegem/diamond = 1)
	craftdiff = 0

/datum/crafting_recipe/gemstaff/ducalblacksteelstaffupgrade
	name = "Refined Ducal Blacksteel Staff"
	result = /obj/item/rogueweapon/woodstaff/diamond/blacksteelstaff/royal
	reqs = list(/obj/item/rogueweapon/woodstaff/emerald/blacksteelstaff/royal = 1,
				/obj/item/roguegem/diamond = 1)
	craftdiff = 0
