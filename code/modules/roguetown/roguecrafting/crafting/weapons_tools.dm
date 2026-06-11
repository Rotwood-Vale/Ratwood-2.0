/datum/crafting_recipe/roguetown/survival/peasantry
	abstract_type = /datum/crafting_recipe/roguetown/survival/peasantry
	tools = list(/obj/item/rogueweapon/hammer)
	req_table = TRUE
	skillcraft = /datum/skill/craft/carpentry
	category = "工具"

// /datum/crafting_recipe/roguetown/survival/peasantry/thresher
// 	name = "thresher"
// 	reqs = list(
// 		/obj/item/grown/log/tree/stick = 1,
// 		/obj/item/ingot/iron = 1,
// 		)
// 	result = /obj/item/rogueweapon/thresher
// 	craftdiff = 0

// /datum/crafting_recipe/roguetown/survival/peasantry/shovel
// 	name = "shovel - iron ingot"
// 	reqs = list(
// 		/obj/item/grown/log/tree/stick = 2,
// 		/obj/item/ingot/iron = 1,
// 		)
// 	result = /obj/item/rogueweapon/shovel
// 	craftdiff = 0

// /datum/crafting_recipe/roguetown/survival/peasantry/hoe
// 	name = "hoe - iron ingot"
// 	reqs = list(
// 		/obj/item/grown/log/tree/stick = 2,
// 		/obj/item/ingot/iron = 1,
// 		)
// 	result = /obj/item/rogueweapon/hoe
// 	craftdiff = 0

// /datum/crafting_recipe/roguetown/survival/peasantry/pitchfork
// 	name = "pitchfork - iron ingot"
// 	reqs = list(
// 		/obj/item/grown/log/tree/stick = 2,
// 		/obj/item/ingot/iron = 1,
// 		)
// 	result = /obj/item/rogueweapon/pitchfork
// 	craftdiff = 0

// /datum/crafting_recipe/roguetown/survival/peasantry/peasantwarflail
// 	name = "peasant war flail"
// 	result = /obj/item/rogueweapon/flail/peasantwarflail
// 	reqs = list(
// 		/obj/item/grown/log/tree/small = 2,
// 		/obj/item/rope = 1,
// 		/obj/item/rogueweapon/thresher = 1,
// 		)
// 	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/goedendag
	name = "民兵古登达格棍"
	result = /obj/item/rogueweapon/woodstaff/militia
	reqs = list(
		/obj/item/rogueweapon/woodstaff = 1,
		/obj/item/natural/whetstone = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/waraxe
	name = "民兵铲斧"
	result = /obj/item/rogueweapon/greataxe/militia
	reqs = list(
		/obj/item/rogueweapon/shovel = 1,
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/waraxe/silver
	name = "银制民兵铲斧"
	result = /obj/item/rogueweapon/greataxe/militia/silver
	reqs = list(
		/obj/item/rogueweapon/shovel/silver = 1,
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/waraxe/silver/preblessed
	name = "银制民兵铲斧（预祝圣）"
	result = /obj/item/rogueweapon/greataxe/militia/silver/preblessed
	reqs = list(
		/obj/item/rogueweapon/shovel/silver/preblessed = 1,
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/warspear_pitchfork
	name = "民兵战矛"
	result = /obj/item/rogueweapon/spear/militia
	reqs = list(
		/obj/item/rogueweapon/pitchfork = 1,
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/warflail
	name = "民兵连枷"
	result = /obj/item/rogueweapon/flail/militia
	reqs = list(
		/obj/item/natural/whetstone = 2,
		/obj/item/rogueweapon/thresher = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/warpick
	name = "民兵战镐"
	result = /obj/item/rogueweapon/pick/militia
	reqs = list(
		/obj/item/rogueweapon/pick = 1,
		/obj/item/natural/whetstone = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/peasantry/warpick_steel
	name = "民兵钢战镐 "
	result = /obj/item/rogueweapon/pick/militia/steel
	reqs = list(
		/obj/item/rogueweapon/pick/steel = 1,
		/obj/item/natural/whetstone = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/stoneaxe
	name = "石斧"
	category = "工具"
	result = /obj/item/rogueweapon/stoneaxe
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/stone = 1,
		)

/datum/crafting_recipe/roguetown/survival/woodhammer
	name = "木槌"
	category = "工具"
	result = /obj/item/rogueweapon/hammer/wood
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 1,
		)

/datum/crafting_recipe/roguetown/survival/stonehammer
	name = "石锤"
	category = "工具"
	result = /obj/item/rogueweapon/hammer/stone
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/stone = 1,
		)

/datum/crafting_recipe/roguetown/survival/stonehoe
	name = "石锄"
	category = "工具"
	result = /obj/item/rogueweapon/hoe/stone
	reqs = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/natural/fibers = 1,
		/obj/item/natural/stone = 1,
		)

/datum/crafting_recipe/roguetown/survival/stonetongs
	name = "石钳"
	category = "工具"
	result = /obj/item/rogueweapon/tongs/stone
	reqs = list(
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/stone = 1,
		)

/datum/crafting_recipe/roguetown/survival/stonepick
	name = "石镐"
	category = "工具"
	result = /obj/item/rogueweapon/pick/stone
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/stone = 2,
		)

/datum/crafting_recipe/roguetown/survival/stoneknife
	name = "石刀"
	category = "工具"
	result = /obj/item/rogueweapon/huntingknife/stoneknife
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/stone = 1,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/stonespear
	name = "石矛"
	category = "工具"
	result = /obj/item/rogueweapon/spear/stone
	reqs = list(
		/obj/item/rogueweapon/woodstaff = 1,
		/obj/item/natural/stone = 1,
		)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/stonesword
	name = "石剑"
	category = "工具"
	result = /obj/item/rogueweapon/sword/stone
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 1,
		/obj/item/natural/stone = 3,
		)
	craftdiff = 1


/datum/crafting_recipe/roguetown/survival/woodclub
	name = "木棍"
	category = "工具"
	result = /obj/item/rogueweapon/mace/woodclub/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)

/datum/crafting_recipe/roguetown/survival/billhook
	name = "简易钩镰"
	category = "工具"
	result = /obj/item/rogueweapon/spear/improvisedbillhook
	reqs = list(
		/obj/item/rogueweapon/sickle = 1,
		/obj/item/rope = 1,
		/obj/item/grown/log/tree/small = 1,
		)
	tools = list(/obj/item/rogueweapon/hammer)
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/goedendag
	name = "古登达格棍"
	category = "工具"
	result = /obj/item/rogueweapon/mace/goden
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/rope = 1,
		/obj/item/rogueweapon/hoe = 1,
		)
	tools = list(/obj/item/rogueweapon/hammer)
	craftdiff = 3


/obj/item/rogueweapon/mace/woodclub/crafted
	sellprice = 8

/datum/crafting_recipe/roguetown/survival/woodstaff
	name = "木杖（x3）"
	category = "工具"
	result = list(
		/obj/item/rogueweapon/woodstaff,
		/obj/item/rogueweapon/woodstaff,
		/obj/item/rogueweapon/woodstaff,
		)
	reqs = list(/obj/item/grown/log/tree = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/quarterstaff
	name = "长棍"
	category = "工具"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff)
	reqs = list(/obj/item/grown/log/tree = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/quarterstaff_iron
	name = "铁箍长棍"
	category = "工具"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff/iron)
	reqs = list(
		/obj/item/rogueweapon/woodstaff/quarterstaff = 1,
		/obj/item/ingot/iron = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/quarterstaff_steel
	name = "钢箍长棍"
	category = "工具"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff/steel)
	reqs = list(
		/obj/item/rogueweapon/woodstaff/quarterstaff = 1,
		/obj/item/ingot/steel = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/quarterstaff_silver
	name = "银箍长棍"
	category = "工具"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff/silver)
	reqs = list(
		/obj/item/rogueweapon/woodstaff/quarterstaff = 1,
		/obj/item/ingot/silver = 1,
	)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/quarterstaff_psydonic
	name = "普赛顿 银箍长棍"
	category = "工具"
	result = list(/obj/item/rogueweapon/woodstaff/quarterstaff/psy)
	reqs = list(
		/obj/item/rogueweapon/woodstaff/quarterstaff = 1,
		/obj/item/ingot/silverblessed = 1,
	)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 5

/datum/crafting_recipe/roguetown/survival/quarterstaff_psydonic/bullion
	reqs = list(
		/obj/item/rogueweapon/woodstaff/quarterstaff = 1,
		/obj/item/ingot/silverblessed/bullion = 1,
	)

/datum/crafting_recipe/roguetown/survival/woodsword
	name = "木剑（x2）"
	category = "工具"
	result = list(
		/obj/item/rogueweapon/mace/wsword,
		/obj/item/rogueweapon/mace/wsword,
		)
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/wooddagger
	name = "木匕首（x3）"
	category = "工具"
	result = list(
		/obj/item/rogueweapon/huntingknife/idagger/wood,
		/obj/item/rogueweapon/huntingknife/idagger/wood,
		/obj/item/rogueweapon/huntingknife/idagger/wood
		)
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/woodshield
	name = "木盾"
	category = "工具"
	result = /obj/item/rogueweapon/shield/wood
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/hide = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/heatershield
	name = "鸢形盾"
	category = "工具"
	result = /obj/item/rogueweapon/shield/heater/crafted
	reqs = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/natural/hide/cured = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/obj/item/rogueweapon/shield/heater/crafted
	sellprice = 6


/datum/crafting_recipe/roguetown/survival/bonespear
	name = "骨矛"
	category = "工具"
	result = /obj/item/rogueweapon/spear/bonespear
	reqs = list(
		/obj/item/rogueweapon/woodstaff = 1,
		/obj/item/natural/bone = 2,
		/obj/item/natural/fibers = 1,
		)
	craftdiff = 3


/datum/crafting_recipe/roguetown/survival/boneaxe
	name = "骨斧"
	category = "工具"
	result = /obj/item/rogueweapon/stoneaxe/boneaxe
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/bone = 2,
		/obj/item/natural/fibers = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/woodspade
	name = "木铲"
	category = "工具"
	result = /obj/item/rogueweapon/shovel/small
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stick = 1,
		)
/obj/item/rogueweapon/shovel/small/crafted
	sellprice = 5

/datum/crafting_recipe/roguetown/survival/rod
	name = "鱼竿"
	category = "工具"
	result = /obj/item/fishingrod/crafted
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 2,
		)


/obj/item/fishingrod/crafted
	sellprice = 8

/datum/crafting_recipe/roguetown/survival/fishingcage
	name = "捕鱼笼"
	category = "工具"
	result = /obj/item/fishingcage
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stick = 2,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/strucrepairkit
	name = "建筑修理包"
	category = "工具"
	result = /obj/item/construction/repairkit/structure
	reqs = list(/obj/item/construction/nail = 3,
				/obj/item/natural/wood/plank = 3,
				/obj/item/natural/stoneblock = 3)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 5
