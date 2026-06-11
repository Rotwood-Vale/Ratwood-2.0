/datum/crafting_recipe/roguetown/survival/skullmask
	name = "头骨面具"
	category = "服饰"
	result = /obj/item/clothing/mask/rogue/skullmask
	reqs = list(
		/obj/item/natural/bone = 3,
		/obj/item/natural/fibers = 1,
		)
	sellprice = 10
	verbage_simple = "制作"
	verbage = "制作"
	craftdiff = 0


/datum/crafting_recipe/roguetown/survival/antlerhood
	name = "鹿角兜帽"
	category = "服饰"
	result = /obj/item/clothing/head/roguetown/antlerhood
	reqs = list(
		/obj/item/natural/hide = 1,
		/obj/item/natural/bone = 2,
		)
	sellprice = 12
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	verbage_simple = "缝制"
	verbage = "缝制"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/tribalrags
	name = "部族破衣"
	category = "服饰"
	result = /obj/item/clothing/suit/roguetown/shirt/tribalrag
	reqs = list(
		/obj/item/natural/hide = 1,
		/obj/item/natural/fibers = 1,
		)
	sellprice = 6
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	verbage_simple = "缝制"
	verbage = "缝制"
	craftdiff = 0

/datum/crafting_recipe/roguetown/leather/neck/leather_collar
	name = "皮项圈"
	category = "服饰"
	result = /obj/item/clothing/neck/roguetown/collar/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	time = 8 SECONDS
	category = "皮革工艺"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/neck/catbell_collar
	name = "猫铃项圈"
	result = /obj/item/clothing/neck/roguetown/collar/catbell
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/catbell = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "皮革工艺"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/neck/cowbell_collar
	name = "牛铃项圈"
	result = /obj/item/clothing/neck/roguetown/collar/cowbell
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/catbell/cow = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "皮革工艺"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/neck/leather_leash
	name = "皮制牵引绳"
	result = /obj/item/leash/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "皮革工艺"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/survival/goodluckcharm
	name = "卡比特脚幸运符"
	category = "服饰"
	result = /obj/item/clothing/neck/roguetown/luckcharm // +1 fortune when worn
	reqs = list(
		/obj/item/natural/rabbitsfoot = 1,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0

// BOUQUETS & CROWNS

/datum/crafting_recipe/roguetown/survival/bouquet_rosa
	name = "Rosa 花束"
	category = "服饰"
	result = /obj/item/bouquet/rosa
	reqs = list(
		/obj/item/alch/rosa = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "整理"
	verbage = "整理"

/datum/crafting_recipe/roguetown/survival/bouquet_salvia
	name = "Salvia 花束"
	category = "服饰"
	result = /obj/item/bouquet/salvia
	reqs = list(
		/obj/item/alch/salvia = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "整理"
	verbage = "整理"

/datum/crafting_recipe/roguetown/survival/bouquet_matricaria
	name = "Matricaria 花束"
	category = "服饰"
	result = /obj/item/bouquet/matricaria
	reqs = list(
		/obj/item/alch/matricaria = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "整理"
	verbage = "整理"

/datum/crafting_recipe/roguetown/survival/bouquet_calendula
	name = "Calendula 花束"
	category = "服饰"
	result = /obj/item/bouquet/calendula
	reqs = list(
		/obj/item/alch/calendula = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "整理"
	verbage = "整理"

/datum/crafting_recipe/roguetown/survival/flowercrown_rosa
	name = "Rosa 花冠"
	category = "服饰"
	result = /obj/item/flowercrown/rosa
	reqs = list(
		/obj/item/alch/rosa = 4,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0
	verbage_simple = "系扎"
	verbage = "系扎"

/datum/crafting_recipe/roguetown/survival/flowercrown_salvia
	name = "Salvia 花冠"
	category = "服饰"
	result = /obj/item/flowercrown/salvia
	reqs = list(
		/obj/item/alch/salvia = 4,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0
	verbage_simple = "系扎"
	verbage = "系扎"

// Amulet
/datum/crafting_recipe/roguetown/survival/pearlcross
	name = "护符（珍珠）"
	category = "服饰"
	result = /obj/item/clothing/neck/roguetown/psicross/pearl
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/pearl = 3,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/bpearlcross
	name = "护符（蓝珍珠） "
	category = "服饰"
	result = /obj/item/clothing/neck/roguetown/psicross/bpearl
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/pearl/blue = 3,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/shellnecklace
	name = "贝壳项链"
	category = "服饰"
	result = /obj/item/clothing/neck/roguetown/psicross/shell
	reqs = list(
		/obj/item/oystershell = 5,
		/obj/item/natural/fibers = 1,
		)

/datum/crafting_recipe/roguetown/survival/shellbracelet
	name = "贝壳手环"
	category = "服饰"
	result = /obj/item/clothing/neck/roguetown/psicross/shell/bracelet
	reqs = list(
		/obj/item/oystershell = 3,
		/obj/item/natural/fibers = 1,
		)

/datum/crafting_recipe/roguetown/survival/abyssoramulet
	name = "阿比索尔 护符"
	category = "服饰"
	result = /obj/item/clothing/neck/roguetown/psicross/abyssor
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/pearl/blue = 1,
		)

/datum/crafting_recipe/roguetown/survival/woodcross
	name = "木制 普赛顿 十字架"
	category = "服饰"
	result = /obj/item/clothing/neck/roguetown/psicross/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/wickercloak
	name = "柳条披风"
	category = "服饰"
	result = /obj/item/clothing/cloak/wickercloak
	reqs = list(
		/obj/item/natural/dirtclod = 1,
		/obj/item/grown/log/tree/stick = 5,
		/obj/item/natural/fibers = 3,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/mentorhat
	name = "旧竹帽"
	category = "服饰"
	result = /obj/item/clothing/head/roguetown/mentorhat
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/fibers = 2,
		)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3
