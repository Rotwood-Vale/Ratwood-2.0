/datum/crafting_recipe/roguetown/survival/net
	name = "网"
	category = "远程"
	result = /obj/item/net
	craftdiff = 2
	reqs = list(
		/obj/item/rope = 2,
		/obj/item/natural/stone = 3,
		)
	verbage_simple = "编织"
	verbage = "编织"

/datum/crafting_recipe/roguetown/survival/bowstring
	name = "纤维弓弦"
	category = "远程"
	result = /obj/item/natural/bowstring
	reqs = list(/obj/item/natural/fibers = 2)
	verbage_simple = "搓制"
	verbage = "搓制"

/datum/crafting_recipe/roguetown/survival/bowpartial
	name = "未上弦短弓"
	category = "远程"
	result = /obj/item/grown/log/tree/bowpartial
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tools = /obj/item/rogueweapon/huntingknife
	verbage_simple = "雕刻"
	verbage = "雕刻"

/datum/crafting_recipe/roguetown/survival/bow
	name = "木弓"
	category = "远程"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	reqs = list(
		/obj/item/natural/bowstring = 1,
		/obj/item/grown/log/tree/bowpartial = 1,
		)
	verbage_simple = "装弦"
	verbage = "装弦"
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/recurvepartial
	name = "未上弦反曲弓"
	category = "远程"
	result = /obj/item/grown/log/tree/bowpartial/recurve
	reqs = list(
		/obj/item/grown/log/tree = 1,
		/obj/item/natural/bone = 2,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 2,
		)
	tools = /obj/item/rogueweapon/huntingknife
	verbage_simple = "雕刻"
	verbage = "雕刻"
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/recurvebow
	name = "反曲弓"
	category = "远程"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	reqs = list(
		/obj/item/natural/bowstring = 1,
		/obj/item/grown/log/tree/bowpartial/recurve = 1,
		)
	verbage_simple = "装弦"
	verbage = "装弦"
	craftdiff = 3

/datum/crafting_recipe/roguetown/survival/longbowpartial
	name = "未上弦长弓"
	category = "远程"
	result = /obj/item/grown/log/tree/bowpartial/longbow
	reqs = list(
		/obj/item/grown/log/tree = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/natural/fibers = 2,
		)
	tools = /obj/item/rogueweapon/huntingknife
	verbage_simple = "雕刻"
	verbage = "雕刻"
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/longbow
	name = "长弓"
	category = "远程"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	reqs = list(
		/obj/item/natural/bowstring = 1,
		/obj/item/grown/log/tree/bowpartial/longbow = 1,
		)
	verbage_simple = "装弦"
	verbage = "装弦"
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/longbow_warden
	name = "Blackhorn 长弓"
	category = "远程"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/warden
	reqs = list(
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow = 1,
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/warden = 1,
	)
	verbage_simple = "重新装弦"
	verbage = "重新装弦"
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/stonearrow
	name = "石箭"
	category = "远程"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/stone
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/stone = 1,
		)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/stonearrow_five
	name = "石箭（x5）"
	category = "远程"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/stone,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone
		)
	reqs = list(
		/obj/item/grown/log/tree/stick = 5,
		/obj/item/natural/stone = 5,
		)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/bluntarrow
	name = "钝头箭"
	category = "远程"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/blunt
	reqs = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/stone = 1,
	)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/bluntarrow_five
	name = "钝头箭（x5）"
	category = "远程"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/blunt,
		/obj/item/ammo_casing/caseless/rogue/arrow/blunt,
		/obj/item/ammo_casing/caseless/rogue/arrow/blunt,
		/obj/item/ammo_casing/caseless/rogue/arrow/blunt,
		/obj/item/ammo_casing/caseless/rogue/arrow/blunt,
	)
	reqs = list(
		/obj/item/grown/log/tree/stick = 5,
		/obj/item/natural/stone = 5,
		)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/poisonarrow
	name = "毒箭"
	category = "远程"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/poison
	reqs = list(
				/obj/item/ammo_casing/caseless/rogue/arrow/iron = 1,
				/datum/reagent/stampoison = 5
				)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/blessedbolt
	name = "圣水弩箭"
	category = "远程"
	result = /obj/item/ammo_casing/caseless/rogue/bolt/holy
	reqs = list(
				/obj/item/ammo_casing/caseless/rogue/bolt = 1,
				/datum/reagent/water/blessed = 5
				)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/poisonarrow_stone
	name = "毒石箭"
	category = "远程"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/stone/poison
	reqs = list(
				/obj/item/ammo_casing/caseless/rogue/arrow/stone = 1,
				/datum/reagent/stampoison = 5
				)
	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/poisonarrow_five //Arrows and bolts can be smithed in batches of five. Makes sense for them to be dipped in batches of five, too
	name = "毒箭（x5）"
	category = "远程"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/poison,
		)
	reqs = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/iron = 5,
		/datum/reagent/stampoison = 25,
		)

	req_table = TRUE

/datum/crafting_recipe/roguetown/survival/poisonarrow_five_stone
	name = "毒石箭（x5）"
	category = "远程"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison,
		/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison,
		)
	reqs = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/stone = 5,
		/datum/reagent/stampoison = 25,
		)

	req_table = TRUE


/datum/crafting_recipe/roguetown/survival/waterbolt_ten
	name = "水弩箭（x10）"
	category = "远程"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
	)
	reqs = list(
		/obj/item/natural/glass_shard = 1,
		/obj/item/grown/log/tree/stick = 10,
		)
	req_table = TRUE
	craftdiff = 0
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/survival/waterbolt_twenty
	name = "水弩箭（x20）"
	category = "远程"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		/obj/item/ammo_casing/caseless/rogue/bolt/water,
		)
	reqs = list(
		/obj/item/natural/glass_shard = 2,
		/obj/item/grown/log/tree/stick = 10,
		)
	req_table = TRUE
	craftdiff = 0
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/survival/waterarrow_ten
	name = "水箭（x10）"
	category = "远程"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		)
	reqs = list(
		/obj/item/natural/glass_shard = 1,
		/obj/item/grown/log/tree/stick = 10,
		)
	req_table = TRUE
	craftdiff = 0
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/survival/waterarrow_twenty
	name = "水箭（x20）"
	category = "远程"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		/obj/item/ammo_casing/caseless/rogue/arrow/water,
		)
	reqs = list(
		/obj/item/natural/glass_shard = 2,
		/obj/item/grown/log/tree/stick = 20,
		)
	req_table = TRUE
	craftdiff = 0
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/survival/slingcraft
	name = "投石索"
	category = "远程"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
	reqs = list(/obj/item/natural/fibers = 6)
	verbage_simple = "搓制"
	verbage = "搓制"
	craftdiff = 1 //you should make some ammo first!

/datum/crafting_recipe/roguetown/survival/slingpouchcraft
	name = "投石索弹袋"
	category = "远程"
	result = /obj/item/quiver/sling/
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/natural/cloth = 1,
		)
	verbage_simple = "制作"
	verbage = "制作"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/stonebullets
	name = "投石索石弹（x2）"
	category = "远程"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		)
	reqs = list(/obj/item/natural/stone = 1)
	verbage_simple = "磨制"
	verbage = "磨制"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/stonebullets10x
	name = "投石索石弹（x10）"
	category = "远程"
	result = list(
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone,
		)
	reqs = list(/obj/item/natural/stone = 5)
	verbage_simple = "磨制"
	verbage = "磨制"
	craftdiff = 0
