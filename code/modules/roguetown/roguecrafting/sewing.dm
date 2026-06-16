/datum/crafting_recipe/roguetown/sewing
	abstract_type = /datum/crafting_recipe/roguetown/sewing
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	subtype_reqs = TRUE		//For subtypes of fur

/* craftdif of 0 */

/datum/crafting_recipe/roguetown/sewing/headband
	name = "头带"
	result = list(/obj/item/clothing/head/roguetown/headband)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/allwrappings
	name = "布裹带"
	result = list(/obj/item/clothing/wrists/roguetown/allwrappings)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/peasantcap
	name = "帽子"
	result = list(/obj/item/clothing/head/roguetown/armingcap)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/apron_waist
	name = "围裙"
	result = list(/obj/item/clothing/cloak/apron/waist)
	reqs = list(/obj/item/natural/cloth = 3) // 3 because it thas a storage, but it really just a apron.
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/apron/blacksmith
	name = "皮围裙"
	result = list(/obj/item/clothing/cloak/apron/blacksmith)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/rags
	name = "破布"
	result = list(/obj/item/clothing/suit/roguetown/shirt/rags)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/burial_shroud
	name = "裹尸布"
	result = list(/obj/item/burial_shroud)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/loincloth
	name = "兠裆布"
	result = list(/obj/item/clothing/under/roguetown/loincloth)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/brownloincloth
	name = "棕色兠裆布"
	result = list(/obj/item/clothing/under/roguetown/loincloth/brown)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/linedanklet
	name = "布衬脚环"
	result = list(/obj/item/clothing/shoes/roguetown/boots/clothlinedanklets)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/necramask
	name = "死者面具，重新组装"
	result = list(/obj/item/clothing/head/roguetown/necramask)
	reqs = list(/obj/item/clothing/head/roguetown/necrahood = 1,
				/obj/item/natural/bone = 1)
	craftdiff = 0

/* craftdif of 1 */

/datum/crafting_recipe/roguetown/sewing/clothgloves
	name = "露指手套"
	result = list(/obj/item/clothing/gloves/roguetown/fingerless)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/clothbedsheet
	name = "床单，布质"
	result = list(/obj/item/bedsheet/rogue/cloth)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/fabricbedsheet // cloth bedsheet's fancier looking cousin
	name = "床单，织物"
	result = list(/obj/item/bedsheet/rogue/fabric)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/doublefabricbedsheet
	name = "床单，双层织物"
	result = list(/obj/item/bedsheet/rogue/fabric_double)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/brimmed
	name = "宽沿帽"
	result = list(/obj/item/clothing/head/roguetown/brimmed)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/tunic
	name = "束衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/tunic/white)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/lowcut_shirt
	name = "低领束衣"
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1)
	result = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/noblecoat
	name = "华丽外套"
	result = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
	reqs = list(/obj/item/natural/cloth = 3,
			/obj/item/natural/silk = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/shadowshirt
	name = "丝质衬衣"
	result = /obj/item/clothing/suit/roguetown/shirt/shadowshirt
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 3)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/clothshirt
	name = "衬衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/clothtrou
	name = "工作裤"
	result = list(/obj/item/clothing/under/roguetown/trou)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/longcoat
	name = "长外套"
	result = list(/obj/item/clothing/suit/roguetown/armor/longcoat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/workervest
	name = "条纹束衣"
	result = list(/obj/item/clothing/suit/roguetown/armor/workervest)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/tights
	name = "紧身裤"
	result = list(/obj/item/clothing/under/roguetown/tights/random)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/Reyepatch
	name = "右眼眼罩"
	result = list(/obj/item/clothing/mask/rogue/eyepatch)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/Leyepatch
	name = "左眼眼罩"
	result = list(/obj/item/clothing/mask/rogue/eyepatch/left)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/knitcap
	name = "针织帽"
	result = list(/obj/item/clothing/head/roguetown/knitcap)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/strawhat
	name = "草帽"
	result = list(/obj/item/clothing/head/roguetown/strawhat)
	reqs = list(/obj/item/natural/fibers = 3)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/sack
	name = "麻袋兜帽"
	result = list(/obj/item/clothing/head/roguetown/menacing)
	reqs = list(/obj/item/natural/cloth = 3,)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/basichood
	name = "兜帽"
	result = list(/obj/item/clothing/head/roguetown/roguehood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/lgambeson
	name = "轻型棉甲"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/light)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/clothblindfold
	name = "蒙眼布"
	result = list(/obj/item/clothing/mask/rogue/blindfold)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/duelmask
	name = "决斗者面具"
	result = list(/obj/item/clothing/mask/rogue/duelmask)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/paddedcoif
	name = "加衬护头巾"
	result = list(/obj/item/clothing/neck/roguetown/coif/padded)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/woolencollar
	name = "羊毛领"
	category = "护头巾"
	result = list(/obj/item/clothing/neck/roguetown/collar/woolen)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/gbandages
	name = "绑带（需手套）"
	result = list(/obj/item/clothing/gloves/roguetown/bandages)
	reqs = list(/obj/item/natural/cloth = 3)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/scarf
	name = "围巾（1 纤维，1 布料）"
	result = list(/obj/item/clothing/head/roguetown/scarf)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 1

/* craftdif of 2+ */

/datum/crafting_recipe/roguetown/sewing/wrappings
	name = "太阳裹带"
	result = list(/obj/item/clothing/wrists/roguetown/wrappings)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/nocwrappings
	name = "月亮裹带"
	result = list(/obj/item/clothing/wrists/roguetown/nocwrappings)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/nunveil
	name = "修女面纱"
	result = list(/obj/item/clothing/head/roguetown/nun)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/nunhabit
	name = "修女服"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/nun)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/necramask
	name = "死者面具"
	result = list(/obj/item/clothing/head/roguetown/necramask)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/bone = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/gweightedbandagesalt
	name = "绑带制成加重绑带（需手套）"
	result = list(/obj/item/clothing/gloves/roguetown/bandages/weighted)
	reqs = list(/obj/item/clothing/gloves/roguetown/bandages = 1,
				/obj/item/natural/cloth = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/bandage
	name = "绑带（缝纺）"
	result = list(/obj/item/natural/cloth/bandage)
	reqs = list(/obj/item/natural/silk = 2,
				/obj/item/natural/cloth = 1)

/datum/crafting_recipe/roguetown/sewing/gweightedbandages
	name = "加重绑带（需手套）"
	result = list(/obj/item/clothing/gloves/roguetown/bandages/weighted)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/coif
	name = "护头巾"
	result = list(/obj/item/clothing/neck/roguetown/coif)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/tabard
	name = "战袍"
	result = list(/obj/item/clothing/cloak/tabard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/whitetabard
	name = "战袍（另款）"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/tabardwhite)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stabard
	name = "罩袍"
	result = list(/obj/item/clothing/cloak/stabard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/abyssortemplartabard
	name = "战袍，阿比索尔圣殿骑士"
	result = list(/obj/item/clothing/cloak/abyssortabard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/psydon
	name = "战袍，普赛顿"
	result = list(/obj/item/clothing/cloak/templar/psydon)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/psydon
	name = "战袍，普赛顿 正统派"
	result = list(/obj/item/clothing/cloak/psydontabard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/astrata
	name = "战袍，阿斯特拉塔"
	result = list(/obj/item/clothing/cloak/templar/astrata)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/noc
	name = "战袍，诺克"
	result = list(/obj/item/clothing/cloak/templar/noc)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/dendor
	name = "战袍，登多尔"
	result = list(/obj/item/clothing/cloak/templar/dendor)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/necra
	name = "战袍，内克拉"
	result = list(/obj/item/clothing/cloak/templar/necra)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/abyssor
	name = "战袍，阿比索尔"
	result = list(/obj/item/clothing/cloak/templar/abyssor)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/malum
	name = "战袍，玛勒姆"
	result = list(/obj/item/clothing/cloak/templar/malum)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/eora
	name = "战袍，伊欧拉"
	result = list(/obj/item/clothing/cloak/templar/eora)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/pestra
	name = "战袍，佩斯特拉圣殿骑士"
	result = list(/obj/item/clothing/cloak/templar/pestra)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/pestran
	name = "战袍，佩斯特拉"
	result = list(/obj/item/clothing/cloak/templar/pestran)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/ravox
	name = "战袍，拉沃克斯"
	result = list(/obj/item/clothing/cloak/cleric/ravox)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/ravoxtemplar
	name = "战袍，拉沃克斯圣殿骑士"
	result = list(/obj/item/clothing/cloak/templar/ravox)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/ravoxgorget
	name = "拉沃克斯护颈"
	result = list(/obj/item/clothing/head/roguetown/roguehood/ravoxgorget)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/xylix
	name = "战袍，赛利克斯"
	result = list(/obj/item/clothing/cloak/templar/xylix)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/xylixian
	name = "战袍，赛利克斯圣殿骑士"
	result = list(/obj/item/clothing/cloak/templar/xylixian)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stabard/guard
	name = "罩袍，卫兵"
	result = list(/obj/item/clothing/cloak/stabard/guard)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stabard/bog
	name = "罩袍，沼泽"
	result = list(/obj/item/clothing/cloak/stabard/bog)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/stabard/guardhood
	name = "卫兵兜帽"
	result = list(/obj/item/clothing/cloak/stabard/guardhood)

/datum/crafting_recipe/roguetown/sewing/poncho
	name = "布料披风"
	result = /obj/item/clothing/cloak/poncho
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/robe
	name = "长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/basiceast
	name = "简易多宝长袍"
	result = list(/obj/item/clothing/suit/roguetown/armor/basiceast)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/jesterchest
	name = "小丑上衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/jester)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/jesterhead
	name = "小丑帽"
	result = list(/obj/item/clothing/head/roguetown/jester)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/jingle_bells = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/jestershoes
	name = "小丑鞋"
	result = list(/obj/item/clothing/shoes/roguetown/jester)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1,
				/obj/item/jingle_bells = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/bardress
	name = "酒吧连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/stockdress
	name = "简约连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

//datum/crafting_recipe/roguetown/sewing/Bladress
//	name = "black dress"
//	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/black)
//	reqs = list(/obj/item/natural/cloth = 3,
//				/obj/item/natural/fibers = 1)
//	craftdiff = 4

//datum/crafting_recipe/roguetown/sewing/Bludress
//	name = "blue dress"
//	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/blue)
//	reqs = list(/obj/item/natural/cloth = 3,
//				/obj/item/natural/fibers = 1)
//	craftdiff = 4

//datum/crafting_recipe/roguetown/sewing/Purdress
//	name = "purple dress"
//	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/purple)
//	reqs = list(/obj/item/natural/cloth = 3,
//				/obj/item/natural/fibers = 1)
//	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/slitdress
	name = "开叉连衣裙"
	category = "连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/slit)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/fancyhat
	name = "华丽帽子"
	result = list(/obj/item/clothing/head/roguetown/fancyhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/gambeson
	name = "棉甲"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/armingjacket
	name = "战斗短衣"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/paddedcap
	name = "加衬帽"
	result = /obj/item/clothing/head/roguetown/paddedcap
	reqs = list(/obj/item/natural/fibers = 5)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/bardhat
	name = "吟游诗人帽"
	result = list(/obj/item/clothing/head/roguetown/bardhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/bucklehat
	name = "折帽"
	result = list(/obj/item/clothing/head/roguetown/bucklehat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/puritanhat
	name = "清教徒扣带帽"
	result = list(/obj/item/clothing/head/roguetown/puritan)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/nurseveil
	name = "护士面纱"
	result = list(/obj/item/clothing/head/roguetown/veiled)
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1
	)
	craftdiff = 2
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/archer
	name = "弓箭手帽"
	result = list(/obj/item/clothing/head/roguetown/archercap)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/duelist
	name = "决斗者帽"
	result = list(/obj/item/clothing/head/roguetown/duelhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/witchhat
	name = "女巫帽"
	result = list(/obj/item/clothing/head/roguetown/witchhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/hgambeson
	name = "加衬棉甲"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 4)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/monkwraps
	name = "加衬臂裹带"
	result = list(/obj/item/clothing/wrists/roguetown/bracers/cloth/monk)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/monkheadband
	name = "加衬头带"
	result = list(/obj/item/clothing/head/roguetown/headband/monk)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/heavypadded
	name = "重型加衬护头巾"
	result = list(/obj/item/clothing/neck/roguetown/coif/heavypadding)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/hgambeson/fencer
	name = "击剑衬衣"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/silk = 2)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/chaperon
	name = "风帽"
	result = list(/obj/item/clothing/head/roguetown/chaperon)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/chaperon/noble
	name = "贵族风帽"
	result = list(/obj/item/clothing/head/roguetown/chaperon/noble)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/jupon
	name = "无袖短罩袍"
	result = list(/obj/item/clothing/cloak/stabard/surcoat)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/cotehardie
	name = "修身外套"
	result = list(/obj/item/clothing/cloak/cotehardie)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/armordress
	name = "加衬连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/armor/armordress)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/ragmask
	name = "破布面罩"
	result = list(/obj/item/clothing/mask/rogue/ragmask)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 0
	sellprice = 3

/datum/crafting_recipe/roguetown/sewing/cape
	name = "斗篷"
	result = list(/obj/item/clothing/cloak/cape)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/sexydress
	name = "透纱连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 3)
	craftdiff = 4
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/wizhatblue
	name = "蓝色巫师帽"
	result = list(/obj/item/clothing/head/roguetown/wizhat)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/wizhatred
	name = "红色巫师帽"
	result = list(/obj/item/clothing/head/roguetown/wizhat/red)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/wizhatyellow
	name = "黄色巫师帽"
	result = list(/obj/item/clothing/head/roguetown/wizhat/yellow)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/wizhatgreen
	name = "绿色巫师帽"
	result = list(/obj/item/clothing/head/roguetown/wizhat/green)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/wizhatblack
	name = "黑色巫师帽"
	result = list(/obj/item/clothing/head/roguetown/wizhat/black)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3
	sellprice = 12

/datum/crafting_recipe/roguetown/sewing/cape/desert
	name = "沙漠斗篷"
	result = list(/obj/item/clothing/cloak/cape/crusader)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/cape/rider
	name = "骑手斗篷"
	result = list(/obj/item/clothing/cloak/half/rider)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/cape/half
	name = "短斗篷"
	result = list(/obj/item/clothing/cloak/half)
	reqs = list(/obj/item/natural/silk = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/undervestments
	name = "内礼服"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/priest)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/keffiyeh
	name = "库菲耶"
	result = list(/obj/item/clothing/head/roguetown/roguehood/shalal)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/hijab
	name = "希贾布"
	result = list(/obj/item/clothing/head/roguetown/roguehood/shalal/hijab)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/heavyhood
	name = "重型兜帽"
	result = list(/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/royalgown
	name = "皇家礼袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/royal)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 3)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 45

/datum/crafting_recipe/roguetown/sewing/royaldress
	name = "无瑵连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/royal/princess)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/royalshirt
	name = "镀金礼服衬衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/royal/prince)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/regalrobes
	name = "皇家丝袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/vampire)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/grenzelshirt
	name = "格伦泽尔霍夫特的短上衣"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 4,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/silktunic
	name = "精美丝质束衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 25

/datum/crafting_recipe/roguetown/sewing/silkdress
	name = "精美丝质连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/archivist
	name = "学者长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/archivist)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 25

/datum/crafting_recipe/roguetown/sewing/apothshirt
	name = "药剂师衬衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/apothshirt)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/artificer
	name = "修补匠短上衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/winterdress
	name = "冬装连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/armor/armordress/winterdress)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 25

/datum/crafting_recipe/roguetown/sewing/winterdress_light
	name = "御寒连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/winterdress_light)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 10

/datum/crafting_recipe/roguetown/sewing/skirt
	name = "裙子"
	result = list(/obj/item/clothing/under/roguetown/skirt)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 10

/datum/crafting_recipe/roguetown/sewing/sailorspants
	name = "水手裤"
	result = list(/obj/item/clothing/under/roguetown/tights/sailor)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/sailorshirt_colored
	name = "striped shirt (colorable)"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/colored)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/grenzelpants
	name = "格伦泽尔霍夫特的蓬裤"
	result = list(/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 25

/datum/crafting_recipe/roguetown/sewing/shadowpants
	name = "丝质紧身裤"
	result = list(/obj/item/clothing/under/roguetown/trou/shadowpants)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 18

/datum/crafting_recipe/roguetown/sewing/apothpants
	name = "药剂师裤子"
	result = list(/obj/item/clothing/under/roguetown/trou/apothecary)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/royalsleeves
	name = "皇家护袖"
	result = list(/obj/item/clothing/wrists/roguetown/royalsleeves)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 19

/datum/crafting_recipe/roguetown/sewing/nemes
	name = "尼梅斯头巾"
	result = list(/obj/item/clothing/head/roguetown/headdress)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 10

/datum/crafting_recipe/roguetown/sewing/hatfur
	name = "皮毛帽"
	result = list(/obj/item/clothing/head/roguetown/hatfur)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/shawl
	name = "披巾"
	result = list(/obj/item/clothing/head/roguetown/shawl)
	reqs = list(/obj/item/natural/cloth = 1)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 5

/datum/crafting_recipe/roguetown/sewing/grenzelhat
	name = "格伦泽尔霍夫特的帽子"
	result = list(/obj/item/clothing/head/roguetown/grenzelhofthat)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/articap
	name = "工匠帽"
	result = list(/obj/item/clothing/head/roguetown/articap)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 14

/datum/crafting_recipe/roguetown/sewing/lordlycloak
	name = "贵胄斗篷"
	result = list(/obj/item/clothing/cloak/lordcloak)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/fur = 2,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 35

/datum/crafting_recipe/roguetown/sewing/naledisash
	name = "圣师绶带"
	result = list(/obj/item/clothing/cloak/hierophant)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/ladycloak
	name = "淑女短斗篷"
	result = list(/obj/item/clothing/cloak/lordcloak/ladycloak)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/furovercoat
	name = "毛皮大衣"
	result = list(/obj/item/clothing/cloak/black_cloak)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 1,
				/obj/item/natural/fur = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 22

/datum/crafting_recipe/roguetown/sewing/guildedjacket
	name = "商人短衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/merchant)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 19

/datum/crafting_recipe/roguetown/sewing/buttonedlongcoat
	name = "瘫疫外套"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/physician)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/desertgown
	name = "圣师坎迪斯袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/hierophant)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 4)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 17

/datum/crafting_recipe/roguetown/sewing/halfrobe
	name = "圣师披巾"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 5)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/monkrobe
	name = "教宗卡巴袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/pointfex)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 5)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 15

/datum/crafting_recipe/roguetown/sewing/otavangambeson
	name = "奥塔万棉甲"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan)
	reqs = list(/obj/item/natural/cloth = 5,
				/obj/item/natural/silk = 2,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/sleevelessrobephys
	name = "医师长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/phys)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/sleevelessrobefeld
	name = "军医长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/feld)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/hoodphys
	name = "医师兜帽"
	result = list(/obj/item/clothing/head/roguetown/roguehood/phys)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/hoodfeld
	name = "军医兜帽"
	result = list(/obj/item/clothing/head/roguetown/roguehood/feld)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 13

/datum/crafting_recipe/roguetown/sewing/weddingdress
	name = "婚礼丝质连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/silkdress/weddingdress)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 3)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 40

/datum/crafting_recipe/roguetown/sewing/silkydress
	name = "丝绸连衣裙"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 3)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 50

/datum/crafting_recipe/roguetown/sewing/weaving/springgown
	name = "礼袍（春）"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/silk = 4)
	craftdiff = 6
	sellprice = 85

/datum/crafting_recipe/roguetown/sewing/weaving/summergown
	name = "礼袍（夏）"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown
	reqs = list(/obj/item/natural/fibers = 2,
				/obj/item/natural/cloth = 1,
				/obj/item/natural/silk = 3)
	craftdiff = 6
	sellprice = 70

/datum/crafting_recipe/roguetown/sewing/weaving/fallgown
	name = "礼袍（秋，丝质）"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown
	reqs = list(/obj/item/natural/fibers = 3,
				/obj/item/natural/silk = 2,
				/obj/item/natural/cloth = 2)
	craftdiff = 6
	sellprice = 75

/datum/crafting_recipe/roguetown/sewing/weaving/wintergown
	name = "礼袍（冬）"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown
	reqs = list(/obj/item/natural/fibers = 3,
				/obj/item/natural/silk = 2,
				/obj/item/natural/fur = 1)
	craftdiff = 6
	sellprice = 90

/datum/crafting_recipe/roguetown/sewing/exoticsilkbra
	name = "异域丝质胸衣"
	result = list (/obj/item/clothing/suit/roguetown/shirt/exoticsilkbra)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/anklets
	name = "异域丝质脚环"
	result = list (/obj/item/clothing/shoes/roguetown/anklets)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/exoticsilkbelt
	name = "异域丝质腰带"
	result = list (/obj/item/storage/belt/rogue/leather/exoticsilkbelt)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/exoticsilkmask
	name = "异域丝质面罩"
	result = list (/obj/item/clothing/mask/rogue/exoticsilkmask)
	reqs = list(/obj/item/natural/silk = 5)
	craftdiff = 6

/datum/crafting_recipe/roguetown/sewing/strapless_dress
	name = "无肩带连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/strapless_dress_alt
	name = "无肩带连衣裙（另款）"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/alt)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/paperparasol
	name = "纸伞"
	result = list(/obj/item/rogueweapon/mace/parasol)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2,
				/obj/item/paper/scroll = 3)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/spellsingerrobes
	name = "咒歌者长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe)
	reqs = list(/obj/item/natural/cloth = 6,
				/obj/item/natural/fibers = 4,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 30

/datum/crafting_recipe/roguetown/sewing/spellsingerhat
	name = "咒歌者帽"
	result = list(/obj/item/clothing/head/roguetown/spellcasterhat)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 2)
	tools = list(/obj/item/needle)
	craftdiff = 6
	sellprice = 20

/datum/crafting_recipe/roguetown/sewing/beekeeper
	name = "养蜂人兜帽"
	result = list(/obj/item/clothing/head/roguetown/beekeeper)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 4)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/bandithood
	name = "自由之人裹尸布"
	result = list(/obj/item/clothing/head/roguetown/menacing/bandit)
	reqs = list(/obj/item/natural/cloth = 1)

/datum/crafting_recipe/roguetown/sewing/shroudwhite
	name = "白色裹尸布"
	result = list(/obj/item/clothing/head/roguetown/roguehood/shroudwhite)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/surgicalbag
	name = "外科包"
	result = list(/obj/item/storage/belt/rogue/surgery_bag/empty)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/surgcollar
	name = "外科颈圈"
	result = list(/obj/item/clothing/neck/roguetown/collar/surgcollar)
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/sewing/battleskirt
	name = "布质军裙"
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/fauldedbelt
	name = "带甲片的腰带"
	result = list(/obj/item/storage/belt/rogue/leather/battleskirt/faulds)
	reqs = list(
		/obj/item/natural/cloth = 3,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/reinforced_hood
	name = "加固兜帽"
	result = list(/obj/item/clothing/head/roguetown/roguehood/reinforced)
	reqs = list(
		/obj/item/clothing/head/roguetown/roguehood = 1,
		/obj/item/natural/cloth = 6,
		/obj/item/natural/silk = 1,
		/obj/item/natural/hide/cured = 1
	)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/fineparasol
	name = "精美阳伞"
	result = list(/obj/item/rogueweapon/mace/parasol/noble)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/silk = 4,
				/obj/item/paper/scroll = 2)
	craftdiff = 5
	sellprice = 45

// Maid Clothes //
/datum/crafting_recipe/roguetown/sewing/maidband
	name = "女仆头带"
	result = list(/obj/item/clothing/head/roguetown/maidband)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/servantdress
	name = "侍者连衣裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/maid/servant)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/maidapron
	name = "女仆围裙"
	result = /obj/item/clothing/cloak/apron/maid
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/natural/silk = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/formalshirt
	name = "正装衬衣"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/formal)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/trousershorts
	name = "短裤"
	result = list(/obj/item/clothing/under/roguetown/trou/formal/shorts)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/maiddress
	name = "女仆装"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/maid)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/tailcoat
	name =  "燕尾服"
	result = list(/obj/item/clothing/armor/gambeson/tailcoat)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/formaltrousers
	name = "正装裤"
	result = list(/obj/item/clothing/under/roguetown/trou/formal)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 2)
	craftdiff = 4
