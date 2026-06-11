/datum/roguestock/import
	import_only = TRUE
	stable_price = TRUE

/datum/roguestock/import/crackers
	name = "口粮箱"
	desc = "低含水量、耐储存的面包。"
	item_type = /obj/item/roguebin/crackers
	export_price = 100
	importexport_amt = 1

/obj/item/roguebin/crackers/Initialize(mapload)
	. = ..()
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)

/obj/structure/closet/crate/chest/steward
	lockid = "steward"
	locked = TRUE
	masterkey = TRUE

/datum/roguestock/import/redpotion
	name = "治疗药水箱"
	desc = "救人性命的红色药水。"
	item_type = /obj/structure/closet/crate/chest/steward/redpotion
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/redpotion/Initialize(mapload)
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)

/datum/roguestock/import/rotpotion
	name = "祛腐药水箱"
	desc = "一箱稀有而抢手的祛腐药水。"
	item_type = /obj/structure/closet/crate/chest/steward/rotpotion
	export_price = 400		//Expensive, 200 each roughly. Four uses total, as only 5u needed to reverse rot. Each bottle is 10u.
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/rotpotion/Initialize(mapload)
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure(src)

/datum/roguestock/import/knight
	name = "骑士装备箱"
	desc = "新任骑士的起始装备。"
	item_type = /obj/structure/closet/crate/chest/steward/knight
	export_price = 500
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/knight/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/heavy/knight(src)
	new /obj/item/clothing/gloves/roguetown/plate(src)
	new /obj/item/clothing/under/roguetown/platelegs(src)
	new /obj/item/clothing/cloak/tabard/knight/guard(src)
	new /obj/item/clothing/neck/roguetown/bevor(src)
	new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk(src)
	new /obj/item/clothing/suit/roguetown/armor/plate/full(src)
	new /obj/item/clothing/shoes/roguetown/boots/armor(src)
	new /obj/item/storage/keyring/guardcastle(src)
	new /obj/item/storage/belt/rogue/leather/steel(src)
	new /obj/item/rogueweapon/sword/long(src)

/datum/roguestock/import/warden
	name = "看守装备箱"
	desc = "新任看守的起始装备。"
	item_type = /obj/structure/closet/crate/chest/steward/warden
	export_price = 250
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/warden/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/cloak/wardencloak(src)
	new /obj/item/storage/keyring/guard(src)
	new /obj/item/clothing/suit/roguetown/armor/leather/studded/warden(src)
	new /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick(src)
	new /obj/item/rogueweapon/huntingknife/idagger/warden_machete(src)
	new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/warden(src)

/datum/roguestock/import/manatarms
	name = "兵士装备箱"
	desc = "新任兵士的起始装备。"
	item_type = /obj/structure/closet/crate/chest/steward/manatarms
	export_price = 250
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/manatarms/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/bascinet(src)
	new /obj/item/clothing/under/roguetown/chainlegs(src)
	new /obj/item/clothing/cloak/stabard/surcoat/guard(src)
	new /obj/item/clothing/gloves/roguetown/plate(src)
	new /obj/item/clothing/neck/roguetown/gorget(src)
	new /obj/item/clothing/suit/roguetown/armor/chainmail(src)
	new /obj/item/clothing/suit/roguetown/armor/plate/half(src)
	new /obj/item/clothing/shoes/roguetown/boots/armor(src)
	new /obj/item/storage/keyring/guardcastle(src)
	new /obj/item/storage/belt/rogue/leather/steel(src)
	new /obj/item/rogueweapon/spear(src)

/datum/roguestock/import/crossbow
	name = "十字弩箱"
	desc = "一箱内含 3 把十字弩和 3 个装满的箭袋。"
	item_type = /obj/structure/closet/crate/chest/steward/crossbow
	export_price = 300
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/crossbow/Initialize(mapload)
	. = ..()
	new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(src)
	new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(src)
	new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(src)
	new /obj/item/quiver/bolts(src)
	new /obj/item/quiver/bolts(src)
	new /obj/item/quiver/bolts(src)

/datum/roguestock/import/saigabuck
	name = "雄赛加羚"
	desc = "一头驯服并配有异乡马鞍的雄赛加羚。"
	item_type = /obj/structure/closet/crate/chest/steward/saigabuck
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/saigabuck/Initialize(mapload)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled(src)

/datum/roguestock/import/volfcrate
	name = "沃尔夫箱"
	desc = "一只愤怒的野生沃尔夫被塞进了这个箱子里。等它送到时，多半已经饿坏了。"
	item_type = /obj/structure/closet/crate/chest/steward/volfcrate
	export_price = 300
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/volfcrate/Initialize(mapload)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/wolf(src)

/datum/roguestock/import/bearcrate
	name = "恐熊箱"
	desc = "一群疯子声称他们把一整头成年的熊塞进了这个箱子里。他们唯一能保证的是它会很生气。"
	item_type = /obj/structure/closet/crate/chest/steward/bearcrate
	export_price = 1000
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/bearcrate/Initialize(mapload)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/direbear(src)

/datum/roguestock/import/horsecrate
	name = "马匹箱"
	desc = "谷地里一种陌生的坐骑。与赛加不同，马拥有独特的未分趾单蹄。"
	item_type = /obj/structure/closet/crate/chest/steward/horsecrate
	export_price = 500
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/horsecrate/Initialize(mapload)
	. = ..()
	switch(rand(1,3))
		if(1)
			new /mob/living/simple_animal/hostile/retaliate/rogue/horse/male/white/tame/saddled(src)
		if(2)
			new /mob/living/simple_animal/hostile/retaliate/rogue/horse/male/brown/tame/saddled(src)
		if(3)
			new /mob/living/simple_animal/hostile/retaliate/rogue/horse/male/black/tame/saddled(src)

/datum/roguestock/import/ponycrate
	name = "迷你矮马箱"
	desc = "这种新奇的小马被培育得格外娇小，但作为英勇坐骑却毫不逊色。"
	item_type = /obj/structure/closet/crate/chest/steward/ponycrate
	export_price = 1500
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/ponycrate/Initialize(mapload)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/pony
	switch(rand(1,3))
		if(1)
			pony = new/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/white/tame/saddled(src)
		if(2)
			pony = new/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/brown/tame/saddled(src)
		if(3)
			pony = new/mob/living/simple_animal/hostile/retaliate/rogue/horse/male/black/tame/saddled(src)
	pony.transform = pony.transform.Scale(0.7, 0.7)

/datum/roguestock/import/cow
	name = "奶牛"
	desc = "农夫最好的伙伴，稳定提供牛奶和肉。"
	item_type = /obj/structure/closet/crate/chest/steward/cow
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/cow/Initialize(mapload)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/cow(src)

/datum/roguestock/import/bull
	name = "公牛"
	desc = "长角且具有攻击性，是建立牛群所必需的。"
	item_type = /obj/structure/closet/crate/chest/steward/bull
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/bull/Initialize(mapload)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/bull(src)

/datum/roguestock/import/goat
	name = "母山羊"
	desc = "牛奶、皮革和脂肪的多用途来源。"
	item_type = /obj/structure/closet/crate/chest/steward/goat
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/goat/Initialize(mapload)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/goat(src)

/datum/roguestock/import/goatmale
	name = "公山羊"
	desc = "长着胡子的公山羊，可以装鞍骑乘。"
	item_type = /obj/structure/closet/crate/chest/steward/goatmale
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/goatmale/Initialize(mapload)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/goatmale(src)

/datum/roguestock/import/chicken
	name = "鸡"
	desc = "稳定的蛋和肉来源。"
	item_type = /obj/structure/closet/crate/chest/steward/chicken
	export_price = 50
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/chicken/Initialize(mapload)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/chicken(src)

/datum/roguestock/import/farmequip
	name = "农具箱"
	desc = "一箱内含草叉、镰刀、锄头和一些种子。"
	item_type = /obj/structure/closet/crate/chest/steward/farmequip
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/farmequip/Initialize(mapload)
	. = ..()
	new /obj/item/rogueweapon/hoe(src)
	new /obj/item/rogueweapon/pitchfork(src)
	new /obj/item/rogueweapon/sickle(src)
	new /obj/item/seeds/apple(src)
	new /obj/item/seeds/wheat(src)
	new /obj/item/seeds/berryrogue(src)

/datum/roguestock/import/blacksmith
	name = "铁匠箱"
	desc = "石头、煤炭、铁锭、木料箱，还有装着锤子和铁钳的桶。"
	item_type = /obj/structure/closet/crate/chest/steward/blacksmith
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/blacksmith/Initialize(mapload)
	. = ..()
	new /obj/item/rogueweapon/hammer/iron(src)
	new /obj/item/rogueweapon/tongs(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/rogueore/coal(src)
	new /obj/item/rogueore/coal(src)
	new /obj/item/ingot/iron(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/roguebin(src)
	new /obj/item/reagent_containers/glass/bucket(src)

/datum/roguestock/import/craftsman
	name = "工匠箱"
	desc = "手锯、凿子、锤子。"
	item_type = /obj/structure/closet/crate/chest/steward/craftsman
	export_price = 60
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/craftsman/Initialize(mapload)
	. = ..()
	new /obj/item/rogueweapon/hammer/wood(src)
	new /obj/item/rogueweapon/chisel(src)
	new /obj/item/rogueweapon/handsaw(src)

/datum/roguestock/import/glasscrate
	name = "玻璃箱"
	desc = "一箱玻璃，可用于窗户、修补和工艺品。"
	item_type = /obj/structure/closet/crate/chest/steward/glasscrate
	export_price = 150
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/glasscrate/Initialize(mapload)
	. = ..()
	new /obj/item/natural/glass(src)
	new /obj/item/natural/glass(src)
	new /obj/item/natural/glass(src)
	new /obj/item/natural/glass(src)
	new /obj/item/natural/glass(src)

/datum/roguestock/import/tailor
	name = "裁缝箱"
	desc = "一箱基础裁缝工具。"
	item_type = /obj/structure/closet/crate/chest/steward/tailor
	export_price = 150
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/tailor/Initialize(mapload)
	. = ..()
	new /obj/item/rogueweapon/huntingknife/scissors/steel(src)
	new /obj/item/needle(src)
	new /obj/item/grown/log/tree/small(src)
	new /obj/item/grown/log/tree/small(src)
	new /obj/item/natural/bundle/fibers(src)
	new /obj/item/grown/log/tree/stick(src)
	new /obj/item/grown/log/tree/stick(src)

/datum/roguestock/import/keyringsset
	name = "兵士钥匙圈套装箱"
	desc = "供新雇员使用的一套钥匙。"
	item_type = /obj/structure/closet/crate/chest/steward/keyringsset
	export_price = 100
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/keyringsset/Initialize(mapload)
	. = ..()
	new /obj/item/storage/keyring/guardcastle(src)
	new /obj/item/storage/keyring/guardcastle(src)
	new /obj/item/storage/keyring/guardcastle(src)
	new /obj/item/storage/keyring/guardcastle(src)

/datum/roguestock/import/alcoholset
	name = "酒水箱"
	desc = "一箱精选啤酒与烈酒，适合宴饮。"
	item_type = /obj/structure/closet/crate/chest/steward/alcoholset
	export_price = 800
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/alcoholset/Initialize(mapload)
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/nred(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/voddena(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/whitewine(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/redwine(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/elfred(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/kgunplum(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/aurorian(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/butterhairs(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/kgunshochu(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/apfelweinheim(src)

/datum/roguestock/import/minecarttracks
	name = "矿车轨道"
	desc = "一箱内含一百段矿车轨道和四段制动轨道"
	item_type = /obj/structure/closet/crate/chest/steward/minecarttracks
	export_price = 310
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/minecarttracks/Initialize(mapload)
	. = ..()
	for(var/i = 1 to 100)
		new /obj/item/rotation_contraption/minecart_rail(src)
	for(var/i = 1 to 4)
		new /obj/item/rotation_contraption/minecart_rail/railbreak(src)

/datum/roguestock/import/rotationalnetwork
	name = "传动网络"
	desc = "一箱内含十个大齿轮、十六个小齿轮、三个齿轮箱、三个垂直齿轮箱和二十根传动轴"
	item_type = /obj/structure/closet/crate/chest/steward/rotationalnetwork
	export_price = 362
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/rotationalnetwork/Initialize(mapload)
	. = ..()
	for(var/i = 1 to 10)
		new /obj/item/rotation_contraption/large_cog(src)
	for(var/i = 1 to 16)
		new /obj/item/rotation_contraption/cog(src)
	for(var/i = 1 to 3)
		new /obj/item/rotation_contraption/horizontal(src)
	for(var/i = 1 to 3)
		new /obj/item/rotation_contraption/vertical(src)
	for(var/i = 1 to 20)
		new /obj/item/rotation_contraption/shaft(src)

/datum/roguestock/import/waterwheels
	name = "水轮"
	desc = "一箱五个水轮"
	item_type = /obj/structure/closet/crate/chest/steward/waterwheels
	export_price = 75
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/waterwheels/Initialize(mapload)
	. = ..()
	for(var/i = 1 to 5)
		new /obj/item/rotation_contraption/waterwheel(src)

/datum/roguestock/import/stoneblocks
	name = "石砖"
	desc = "一箱二十块石砖，可用于建造"
	item_type = /obj/structure/closet/crate/chest/steward/stoneblocks
	export_price = 40
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/stoneblocks/Initialize(mapload)
	. = ..()
	for(var/i = 1 to 20)
		new /obj/item/natural/stoneblock(src)

/datum/roguestock/import/planks
	name = "木板"
	desc = "一箱二十块木板，可用于建造"
	item_type = /obj/structure/closet/crate/chest/steward/planks
	export_price = 60
	importexport_amt = 1

/obj/structure/closet/crate/chest/steward/planks/Initialize(mapload)
	. = ..()
	for(var/i = 1 to 20)
		new /obj/item/natural/wood/plank(src)
