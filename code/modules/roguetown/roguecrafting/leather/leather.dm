/datum/crafting_recipe/roguetown/leather
	abstract_type = /datum/crafting_recipe/roguetown/leather
	tools = list(/obj/item/needle)
	structurecraft = /obj/machinery/tanningrack
	skillcraft = /datum/skill/craft/tanning
	subtype_reqs = TRUE		//Makes it so fur-subtypes work. Basically if anything is just 'obj/item/natural/fur' - it'll take any fur. If it specifies 'natural/fur/direbear' - it will still require direbear.

/datum/crafting_recipe/roguetown/leather/bedroll
	name = "床铺卷"
	result = /obj/item/bedroll
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/rope = 1)
	tools = list(/obj/item/needle)
	verbage_simple = "制作"
	verbage = "制作"
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/peltbedsheet
	name = "床单，皮毛"
	result = /obj/item/bedsheet/rogue/pelt
	reqs = list(/obj/item/natural/fibers = 1,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/doublepeltbedsheet
	name = "双人床单，皮毛"
	result = /obj/item/bedsheet/rogue/double_pelt
	reqs = list(/obj/item/natural/fibers = 1,
				/obj/item/natural/fur = 2)
	tools = list(/obj/item/needle)
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/corset
	name = "束身衣"
	result = /obj/item/clothing/suit/roguetown/armor/corset
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	sellprice = 15
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/gloves
	name = "皮手套"
	result = list(/obj/item/clothing/gloves/roguetown/leather,
	/obj/item/clothing/gloves/roguetown/leather)
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 10
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/heavygloves
	name = "厚皮手套"
	result = /obj/item/clothing/gloves/roguetown/angle
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 20
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/fingerless_leather_gloves
	name = "露指皮手套"
	result = /obj/item/clothing/gloves/roguetown/fingerless_leather
	reqs = list(
		/obj/item/natural/hide/cured = 1
		)
	sellprice = 20
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/bandana
	name = "皮头巾"
	result = /obj/item/clothing/head/roguetown/helmet/bandana
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 27
	craftdiff = 0

/datum/crafting_recipe/roguetown/leather/tricorn
	name = "皮三角帽"
	result = /obj/item/clothing/head/roguetown/helmet/tricorn
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 27
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/hood
	name = "皮兜帽"
	result = /obj/item/clothing/head/roguetown/roguehood
	reqs = list(/obj/item/natural/hide/cured = 1)
	sellprice = 26
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/vest
	name = "皮背心"
	result = /obj/item/clothing/suit/roguetown/armor/leather/vest
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/bikini
	name = "皮胸甲"
	result = /obj/item/clothing/suit/roguetown/armor/leather/bikini
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 26
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/hidebikini
	name = "兽皮胸甲"
	result = /obj/item/clothing/suit/roguetown/armor/leather/hide/bikini
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fur = 1)
	sellprice = 26
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/cloak
	name = "雨披"
	result = /obj/item/clothing/cloak/raincloak/brown
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/apron/blacksmith
	name = "皮围裙"
	result = /obj/item/clothing/cloak/apron/blacksmith
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/cloakfur
	name = "毛皮披风"
	result = /obj/item/clothing/cloak/raincloak/furcloak/crafted
	reqs = list(/obj/item/natural/hide/cured = 1,/obj/item/natural/fur = 2)
	craftdiff = 2

/obj/item/clothing/cloak/raincloak/furcloak/crafted
	sellprice = 55

/datum/crafting_recipe/roguetown/leather/papakha
	name = "帕帕哈帽"
	result = /obj/item/clothing/head/roguetown/papakha/crafted
	reqs = list(/obj/item/natural/fur = 1, /obj/item/natural/fibers = 2)
	craftdiff = 1

/obj/item/clothing/head/roguetown/papakha/crafted
	sellprice = 10

/datum/crafting_recipe/roguetown/leather/saddle
	name = "马鞍"
	result = /obj/item/natural/saddle
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/whip
	name = "皮鞭"
	result = /obj/item/rogueweapon/whip
	reqs = list(/obj/item/natural/hide/cured = 2,/obj/item/natural/stone = 1)
	sellprice = 39
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/drum
	name = "鼓"
	result = /obj/item/rogue/instrument/drum
	reqs = list(/obj/item/natural/hide/cured = 2,/obj/item/grown/log/tree/small = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/vest/sailor
	name = "海员皮夹克"
	result = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	reqs = list(/obj/item/natural/hide/cured = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/leather/darkcloak
	name = "暗色披风"
	result = list(/obj/item/clothing/cloak/darkcloak)
	reqs = list(/obj/item/natural/fur = 2,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 5
	sellprice = 80

/datum/crafting_recipe/roguetown/leather/bearcloak
	name = "恐熊披风"
	result = list(/obj/item/clothing/cloak/darkcloak/bear)
	reqs = list(/obj/item/natural/fur/direbear = 1,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 4
	sellprice = 80

/datum/crafting_recipe/roguetown/leather/lightbearcloak
	name = "轻型恐熊披风"
	result = list(/obj/item/clothing/cloak/darkcloak/bear/light)
	reqs = list(/obj/item/natural/fur/direbear = 1,
				/obj/item/natural/hide/cured = 4)
	craftdiff = 4
	sellprice = 80

/datum/crafting_recipe/roguetown/leather/leathertights
	name = "皮紧身裤"
	result = list(/obj/item/clothing/under/roguetown/trou/leathertights)
	reqs = list(/obj/item/natural/hide/cured = 2)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 10

/datum/crafting_recipe/roguetown/leather/neck/leather_leash
	name = "皮制牵引绳"
	result = /obj/item/leash/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/skillbook
	name = "未完成的技能书"
	result = /obj/item/skillbook/unfinished
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/paper = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	structurecraft = null//surely it's possible to stitch a book and paper together without a drying rack...
	craftdiff = 1
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/doctormask
	name = "瘟疫面具"
	result = /obj/item/clothing/mask/rogue/physician
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/bone = 1)
	craftdiff = 2
