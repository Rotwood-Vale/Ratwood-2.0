/*
* map spawners which represent different tiers of what you might find in fantasy dungeons ฅ^•ﻌ•^ฅ
* these are all very long. remember to use the collapse function on VSC :3c
*/

// this set is general spawners that have a little bit of everything

/obj/effect/spawner/lootdrop/general_loot_low
	name = "low tier general loot spawner"
	icon_state = "genlow"
	lootcount = 1
	loot = list(
		//mats
		/obj/item/natural/bundle/stick = 4,
		/obj/item/natural/fibers = 4,
		/obj/item/natural/stone = 4,
		/obj/item/rogueore/coal	= 3,
		/obj/item/rogueore/iron = 2,
		/obj/item/natural/bundle/fibers = 2,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		//clothing
		/obj/item/clothing/head/roguetown/armingcap = 4,
		/obj/item/clothing/head/roguetown/knitcap = 4,
		/obj/item/clothing/head/roguetown/roguehood = 1,
		/obj/item/clothing/cloak/stabard = 3,
		/obj/item/clothing/cloak/tabard = 3,
		/obj/item/clothing/cloak/raincloak/mortus = 3,
		/obj/item/clothing/cloak/apron = 3,
		/obj/item/clothing/cloak/apron/waist = 3,
		/obj/item/storage/backpack/rogue/backpack/bagpack = 3,
		/obj/item/clothing/suit/roguetown/shirt/undershirt/random = 5,
		/obj/item/storage/belt/rogue/leather/cloth = 4,
		/obj/item/storage/belt/rogue/leather/rope = 3,
		/obj/item/storage/belt/rogue/leather/knifebelt/iron = 2,
		/obj/item/clothing/under/roguetown/tights/vagrant = 4,
		/obj/item/clothing/gloves/roguetown/leather = 2,
		/obj/item/clothing/gloves/roguetown/fingerless = 4,
		/obj/item/clothing/shoes/roguetown/simpleshoes = 4,
		/obj/item/clothing/shoes/roguetown/boots = 4,
		/obj/item/clothing/shoes/roguetown/boots/leather = 4,
		//money
		//has been removed
		//junk
		/obj/item/rogue/instrument/flute = 3,
		/obj/item/ash = 5,
		/obj/item/natural/glass_shard = 5,
		/obj/item/candle/yellow = 3,
		/obj/item/flashlight/flare/torch = 3,
		/obj/item/reagent_containers/glass/bowl = 4,
		/obj/item/reagent_containers/glass/cup = 4,
		/obj/item/reagent_containers/glass/cup/wooden = 4,
		/obj/item/reagent_containers/glass/cup/steel = 1,
		/obj/item/reagent_containers/glass/cup/skull = 1,
		/obj/item/natural/feather = 4,
		/obj/item/paper/scroll = 3,
		/obj/item/rope = 3,
		/obj/item/rope/chain = 3,
		/obj/item/storage/roguebag/crafted = 3,
		/obj/item/clothing/mask/cigarette/pipe = 3,
		/obj/item/paper = 3,
		/obj/item/reagent_containers/glass/bowl = 3,
		/obj/item/storage/bag/tray = 3,
		/obj/item/mundane/puzzlebox/medium = 1,
		/obj/item/mundane/puzzlebox/easy = 1,
		//medical
		/obj/item/needle/thorn = 4,
		/obj/item/natural/cloth = 5,
		//weapons
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow = 2,
		/obj/item/quiver/arrows = 2,
		/obj/item/quiver/javelin = 2,
		/obj/item/quiver/sling = 1,
		/obj/item/weapon/mace/alloy = 2,
		/obj/item/weapon/mace/woodclub/crafted = 3,
		/obj/item/weapon/mace/cudgel = 2,
		/obj/item/weapon/mace/cudgel/copper = 2,
		/obj/item/weapon/mace/wsword = 1,
		/obj/item/weapon/mace/goden/aalloy = 1,
		/obj/item/weapon/flail = 1,
		/obj/item/weapon/huntingknife = 3,
		/obj/item/weapon/huntingknife/stoneknife = 3,
		/obj/item/weapon/huntingknife/copper = 3,
		/obj/item/weapon/huntingknife/idagger/adagger = 3,
		/obj/item/weapon/huntingknife/idagger = 3,
		/obj/item/weapon/woodstaff = 3,
		/obj/item/weapon/sword/short = 2,
		/obj/item/weapon/sword/short/iron/chipped = 2,
		/obj/item/weapon/sword/short/pashortsword = 2,
		/obj/item/weapon/sword/stone = 3,
		/obj/item/weapon/sword/iron = 1,
		/obj/item/weapon/sword/short/messer/copper = 1,
		/obj/item/weapon/sword/falchion/militia = 1,
		/obj/item/weapon/sword/sabre/alloy = 1,
		/obj/item/weapon/katar = 1,
		/obj/item/weapon/spear = 2,
		/obj/item/weapon/spear/aalloy = 3,
		/obj/item/weapon/spear/militia = 1,
		/obj/item/weapon/spear/improvisedbillhook = 1,
		/obj/item/weapon/spear/stone/copper = 2,
		/obj/item/weapon/fishspear = 1,
		/obj/item/weapon/scythe = 2,
		/obj/item/weapon/pitchfork = 2,
		/obj/item/weapon/pitchfork/aalloy = 2,
		//tools
		/obj/item/weapon/shovel = 3,
		/obj/item/weapon/thresher = 3,
		/obj/item/flint = 4,
		/obj/item/weapon/stoneaxe/woodcut = 3,
		/obj/item/weapon/stoneaxe = 3,
		/obj/item/weapon/hammer/stone = 3,
		/obj/item/weapon/tongs = 3,
		/obj/item/weapon/pick = 3,
		//armor
		/obj/item/clothing/suit/roguetown/armor/leather = 2,
		/obj/item/clothing/suit/roguetown/armor/leather/vest = 2,
		/obj/item/clothing/suit/roguetown/armor/leather/hide = 2,
		/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini = 2,
		/obj/item/clothing/suit/roguetown/armor/leather/hide/bikini = 2,
		/obj/item/clothing/suit/roguetown/armor/gambeson/light = 2,
		/obj/item/clothing/under/roguetown/chainlegs/iron = 1,
		/obj/item/clothing/under/roguetown/brayette = 2,
		/obj/item/clothing/under/roguetown/chainlegs/iron/kilt = 1,
		/obj/item/clothing/gloves/roguetown/chain/aalloy = 2,
		/obj/item/clothing/gloves/roguetown/chain/iron = 1,
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron = 2,
		/obj/item/clothing/suit/roguetown/armor/plate/half/aalloy = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/half/iron = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/half/copper = 1,
		/obj/item/clothing/suit/roguetown/armor/longcoat = 2,
		/obj/item/clothing/neck/roguetown/gorget/copper = 1,
		/obj/item/clothing/neck/roguetown/gorget/aalloy = 1,
		/obj/item/clothing/head/roguetown/helmet/coppercap = 1,
		/obj/item/clothing/head/roguetown/helmet/leather = 2,
		/obj/item/clothing/head/roguetown/helmet/horned = 1,
		/obj/item/clothing/head/roguetown/helmet/skullcap = 1,
		/obj/item/clothing/head/roguetown/helmet/bandana = 2,
		//food
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 3,
		/obj/item/reagent_containers/food/snacks/rogue/crackerscooked = 1,
		/obj/item/reagent_containers/powder/salt = 3,
		/obj/item/reagent_containers/food/snacks/egg = 1,
	)

/obj/effect/spawner/lootdrop/general_loot_mid
	name = "mid tier general loot spawner"
	icon_state = "genmid"
	lootcount = 1
	loot = list(
		//mats
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/hide = 3,
		/obj/item/rogueore/coal	= 3,
		/obj/item/rogueore/iron = 2,
		/obj/item/rogueore/silver = 1,
		/obj/item/ingot/iron = 2,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		//clothing
		/obj/item/clothing/head/roguetown/armingcap = 4,
		/obj/item/clothing/head/roguetown/knitcap = 4,
		/obj/item/clothing/head/roguetown/wizhat = 1,
		/obj/item/clothing/head/roguetown/wizhat/black = 1,
		/obj/item/clothing/head/roguetown/archercap = 1,
		/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood = 1,
		/obj/item/clothing/cloak/stabard = 3,
		/obj/item/clothing/cloak/tabard = 3,
		/obj/item/storage/backpack/rogue/satchel = 3,
		/obj/item/clothing/suit/roguetown/shirt/undershirt/random = 5,
		/obj/item/clothing/cloak/raincloak/mortus = 3,
		/obj/item/clothing/cloak/cape = 3,
		/obj/item/clothing/cloak/apron = 3,
		/obj/item/clothing/cloak/apron/waist = 3,
		/obj/item/storage/belt/rogue/leather = 3,
		/obj/item/storage/belt/rogue/leather/knifebelt/iron = 4,
		/obj/item/storage/belt/rogue/leather/knifebelt = 2,
		/obj/item/clothing/under/roguetown/tights/vagrant = 4,
		/obj/item/clothing/gloves/roguetown/leather = 4,
		/obj/item/clothing/shoes/roguetown/boots = 4,
		/obj/item/clothing/shoes/roguetown/boots/leather = 4,
		/obj/item/clothing/shoes/roguetown/boots/nobleboot = 4,
		/obj/item/clothing/shoes/roguetown/ridingboots = 1,
		//money
		//has been removed
		//junk
		/obj/item/rogue/instrument/flute = 3,
		/obj/item/ash = 5,
		/obj/item/natural/glass_shard = 5,
		/obj/item/candle/yellow = 3,
		/obj/item/flashlight/flare/torch = 3,
		/obj/item/reagent_containers/glass/bowl = 4,
		/obj/item/reagent_containers/glass/cup = 4,
		/obj/item/reagent_containers/glass/cup/wooden = 4,
		/obj/item/reagent_containers/glass/cup/steel = 1,
		/obj/item/reagent_containers/glass/cup/skull = 1,
		/obj/item/natural/feather = 4,
		/obj/item/paper/scroll = 3,
		/obj/item/rope = 3,
		/obj/item/rope/chain = 3,
		/obj/item/storage/roguebag/crafted = 3,
		/obj/item/clothing/mask/cigarette/pipe = 3,
		/obj/item/paper = 3,
		/obj/item/reagent_containers/glass/bowl = 3,
		/obj/item/storage/bag/tray = 3,
		/obj/item/mundane/puzzlebox/medium = 1,
		/obj/item/mundane/puzzlebox/easy = 1,
		//medical
		/obj/item/needle = 4,
		/obj/item/natural/cloth = 5,
		/obj/item/natural/bundle/cloth = 3,
		//weapons
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = 4,
		/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 3,
		/obj/item/gun/ballistic/revolver/grenadelauncher/sling = 4,
		/obj/item/quiver/arrows = 2,
		/obj/item/quiver/javelin = 2,
		/obj/item/quiver/sling = 2,
		/obj/item/quiver/Warrows = 1,
		/obj/item/quiver/Wbolts = 1,
		/obj/item/quiver/bolts = 2,
		/obj/item/weapon/mace = 2,
		/obj/item/weapon/mace/cudgel = 2,
		/obj/item/weapon/mace/goden/steel/paalloy = 2,
		/obj/item/weapon/mace/goden = 2,
		/obj/item/weapon/mace/warhammer = 2,
		/obj/item/weapon/mace/steel/palloy = 1,
		/obj/item/weapon/flail = 1,
		/obj/item/weapon/flail/sflail/paflail = 2,
		/obj/item/weapon/huntingknife/idagger/adagger = 3,
		/obj/item/weapon/huntingknife/idagger = 3,
		/obj/item/weapon/huntingknife/idagger/steel/padagger = 3,
		/obj/item/weapon/huntingknife/idagger/steel/parrying = 2,
		/obj/item/weapon/woodstaff = 3,
		/obj/item/weapon/sword/short = 2,
		/obj/item/weapon/sword/short/pashortsword = 2,
		/obj/item/weapon/sword/stone = 3,
		/obj/item/weapon/sword/iron = 1,
		/obj/item/weapon/sword/short/messer/copper = 1,
		/obj/item/weapon/sword/falchion/militia = 1,
		/obj/item/weapon/katar = 1,
		/obj/item/weapon/spear = 2,
		/obj/item/weapon/spear/billhook = 2,
		/obj/item/weapon/spear/aalloy = 3,
		/obj/item/weapon/spear/militia = 1,
		/obj/item/weapon/halberd/bardiche = 2,
		/obj/item/weapon/halberd/bardiche/paalloy = 1,
		/obj/item/weapon/scythe = 2,
		/obj/item/weapon/pitchfork = 2,
		/obj/item/weapon/pitchfork/aalloy = 2,
		/obj/item/weapon/greatsword/aalloy = 2,
		/obj/item/weapon/greatsword/paalloy = 1,
		/obj/item/weapon/woodstaff/quarterstaff/iron = 1,
		/obj/item/weapon/greataxe = 1,
		/obj/item/weapon/stoneaxe/handaxe/copper = 1,
		/obj/item/weapon/stoneaxe/handaxe = 1,
		//tools
		/obj/item/weapon/shovel = 2,
		/obj/item/weapon/shovel/aalloy = 1,
		/obj/item/weapon/thresher = 1,
		/obj/item/flint = 2,
		/obj/item/weapon/stoneaxe/woodcut = 1,
		/obj/item/weapon/hammer/iron = 3,
		/obj/item/weapon/tongs = 1,
		/obj/item/weapon/pick = 3,
		/obj/item/weapon/huntingknife/scissors = 1,
		//armor
		/obj/item/clothing/suit/roguetown/armor/leather/studded = 2,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy = 2,
		/obj/item/clothing/suit/roguetown/armor/leather/hide = 4,
		/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini = 1,
		/obj/item/clothing/suit/roguetown/armor/leather/hide/bikini = 1,
		/obj/item/clothing/suit/roguetown/armor/gambeson = 2,
		/obj/item/clothing/suit/roguetown/armor/gambeson/light = 2,
		/obj/item/clothing/under/roguetown/chainlegs/iron = 2,
		/obj/item/clothing/under/roguetown/brayette = 2,
		/obj/item/clothing/under/roguetown/chainlegs/iron/kilt = 1,
		/obj/item/clothing/gloves/roguetown/chain/aalloy = 2,
		/obj/item/clothing/gloves/roguetown/chain/iron = 2,
		/obj/item/clothing/gloves/roguetown/fingerless_leather = 2,
		/obj/item/clothing/suit/roguetown/armor/chainmail/iron = 2,
		/obj/item/clothing/suit/roguetown/armor/plate/half/aalloy = 1,
		/obj/item/clothing/suit/roguetown/armor/plate/half/iron = 3,
		/obj/item/clothing/suit/roguetown/armor/brigandine/light = 1,
		/obj/item/clothing/suit/roguetown/armor/longcoat = 2,
		/obj/item/clothing/neck/roguetown/chaincoif = 1,
		/obj/item/clothing/neck/roguetown/chaincoif/chainmantle = 1,
		/obj/item/clothing/neck/roguetown/gorget = 1,
		/obj/item/clothing/neck/roguetown/gorget/aalloy = 1,
		/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/guard/aalloy = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/aalloy = 1,
		/obj/item/clothing/head/roguetown/helmet/leather = 2,
		/obj/item/clothing/head/roguetown/helmet/horned = 1,
		/obj/item/clothing/head/roguetown/helmet/skullcap = 1,
		//food
		/obj/item/reagent_containers/food/snacks/rogue/raisins = 3,
		/obj/item/reagent_containers/food/snacks/rogue/crackerscooked = 1,
		/obj/item/reagent_containers/powder/salt = 3,
		/obj/item/reagent_containers/food/snacks/egg = 1,
	)

/obj/effect/spawner/lootdrop/general_loot_hi
	name = "high tier general loot spawner"
	icon_state = "genhi"
	lootcount = 1
	loot = list(
		//mats
		/obj/item/natural/hide/cured = 2,
		/obj/item/rogueore/coal	= 1,
		/obj/item/rogueore/silver = 1,
		/obj/item/ingot/steel = 2,
		//clothing
		/obj/item/clothing/head/roguetown/fancyhat = 1,
		/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood = 1,
		/obj/item/storage/backpack/rogue/satchel = 1,
		/obj/item/storage/backpack/rogue/backpack = 3,
		/obj/item/clothing/cloak/cape = 3,
		/obj/item/storage/belt/rogue/leather/plaquesilver = 3,
		/obj/item/storage/belt/rogue/leather/steel/tasset = 3,
		/obj/item/storage/belt/rogue/leather/knifebelt = 4,
		/obj/item/clothing/shoes/roguetown/boots/nobleboot = 1,
		/obj/item/clothing/shoes/roguetown/ridingboots = 1,
		//money
		//has been removed
		//junk
		/obj/item/reagent_containers/glass/cup/golden/small = 1,
		/obj/item/reagent_containers/glass/cup/skull = 1,
		/obj/item/mundane/puzzlebox/medium = 1,
		/obj/item/mundane/puzzlebox/impossible = 1,
		//medical
		/obj/item/needle = 4,
		/obj/item/natural/bundle/cloth = 3,
		//weapons
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = 4,
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow  = 4,
		/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 3,
		/obj/item/gun/ballistic/revolver/grenadelauncher/sling = 4,
		/obj/item/quiver/arrows = 2,
		/obj/item/quiver/sling = 2,
		/obj/item/quiver/Warrows = 1,
		/obj/item/quiver/Wbolts = 1,
		/obj/item/quiver/bolts = 2,
		/obj/item/quiver/bodkin = 2,
		/obj/item/weapon/mace/steel = 2,
		/obj/item/weapon/mace/goden/steel = 2,
		/obj/item/weapon/mace/warhammer/steel = 2,
		/obj/item/weapon/flail/sflail = 1,
		/obj/item/weapon/huntingknife/idagger/steel = 4,
		/obj/item/weapon/huntingknife/idagger/steel/parrying = 3,
		/obj/item/weapon/huntingknife/idagger/steel/parrying/vaquero = 2,
		/obj/item/weapon/huntingknife/idagger/silver/elvish = 1,
		/obj/item/weapon/huntingknife/idagger/navaja = 3,
		/obj/item/weapon/sword = 2,
		/obj/item/weapon/sword/long = 2,
		/obj/item/weapon/sword/falx = 2,
		/obj/item/weapon/sword/short/falchion = 2,
		/obj/item/weapon/sword/sabre = 2,
		/obj/item/weapon/sword/rapier = 1,
		/obj/item/weapon/sword/sabre/elf = 1,
		/obj/item/weapon/sword/cutlass = 2,
		/obj/item/weapon/katar = 1,
		/obj/item/weapon/spear/billhook = 2,
		/obj/item/weapon/halberd = 2,
		/obj/item/weapon/halberd/glaive = 2,
		/obj/item/weapon/eaglebeak = 1,
		/obj/item/weapon/greatsword = 1,
		/obj/item/weapon/estoc = 1,
		/obj/item/weapon/woodstaff/quarterstaff/steel = 1,
		/obj/item/weapon/greataxe/steel = 1,
		/obj/item/weapon/stoneaxe/woodcut/steel = 1,
		/obj/item/weapon/sword/silver = 1,
		/obj/item/weapon/mace/steel/silver = 1,
		/obj/item/weapon/greataxe/silver = 1,
		/obj/item/weapon/flail/sflail/silver = 1,
		/obj/item/weapon/huntingknife/idagger/silver = 3,
		/obj/item/weapon/mace/warhammer/steel/silver = 1,
		/obj/item/weapon/stoneaxe/woodcut/silver = 1,
		/obj/item/weapon/spear/silver = 1,
		/obj/item/weapon/sword/long/silver = 1,
		/obj/item/weapon/sword/long/kriegmesser/silver = 1,
		/obj/item/weapon/sword/short/silver = 1,
		/obj/item/weapon/sword/rapier/silver = 1,
		/obj/item/weapon/whip/silver = 1,
		/obj/item/weapon/woodstaff/quarterstaff/silver = 1,
		//tools
		/obj/item/weapon/shovel/silver = 1,
		/obj/item/weapon/shovel = 2,
		/obj/item/weapon/shovel/aalloy = 1,
		/obj/item/weapon/stoneaxe/woodcut = 1,
		/obj/item/weapon/hammer/iron = 3,
		/obj/item/weapon/tongs = 1,
		/obj/item/weapon/pick = 3,
		/obj/item/weapon/huntingknife/scissors/steel = 1,
		//armor
		/obj/item/clothing/suit/roguetown/armor/leather/studded = 2,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy = 2,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = 2,
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket = 2,
		/obj/item/clothing/suit/roguetown/armor/gambeson = 2,
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = 2,
		/obj/item/clothing/under/roguetown/chainlegs = 2,
		/obj/item/clothing/under/roguetown/chainlegs/kilt = 1,
		/obj/item/clothing/gloves/roguetown/chain = 2,
		/obj/item/clothing/gloves/roguetown/fingerless_leather = 2,
		/obj/item/clothing/suit/roguetown/armor/chainmail = 2,
		/obj/item/clothing/suit/roguetown/armor/plate/half = 1,
		/obj/item/clothing/suit/roguetown/armor/brigandine = 1,
		/obj/item/clothing/neck/roguetown/chaincoif = 1,
		/obj/item/clothing/neck/roguetown/chaincoif/chainmantle = 1,
		/obj/item/clothing/neck/roguetown/gorget = 1,
		/obj/item/clothing/neck/roguetown/leather = 1,
		/obj/item/clothing/head/roguetown/helmet/kettle = 2,
		/obj/item/clothing/head/roguetown/helmet/sallet = 1,
		/obj/item/clothing/head/roguetown/helmet/sallet/visored = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/guard = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/knight = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/bucket = 1,
		/obj/item/clothing/head/roguetown/helmet/bascinet = 1,
		/obj/item/clothing/head/roguetown/helmet/bascinet/pigface = 1,
		/obj/item/clothing/head/roguetown/helmet/heavy/frogmouth = 1,
		/obj/item/clothing/head/roguetown/helmet/bascinet/etruscan = 1,
		//food
		/obj/item/reagent_containers/food/snacks/fat/salo = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 1,
		/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
	)

//x3 of the above

/obj/effect/spawner/lootdrop/general_loot_low/x3
	name = "low tier general loot spawnerx3"
	icon_state = "genlowx3"
	lootcount = 3

/obj/effect/spawner/lootdrop/general_loot_mid/x3
	name = "mid tier general loot spawnerx3"
	icon_state = "genmidx3"
	lootcount = 3

/obj/effect/spawner/lootdrop/general_loot_hi/x3
	name = "high tier general loot spawnerx3"
	icon_state = "genhix3"
	lootcount = 3

/*
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡤⠀⠀⢀⣀⡀⢄⣀⣀⣀⠀⠠⠀⠒⠀⠈⠉⠛⠩⡉⢂⠑⡄⠀⠐⠒⠂⠤⠄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢏⢢⠀⠀⠀⢀⠄⢊⠜⠋⠉⠁⠀⠀⠀⠀⠀⡠⠒⠉⠀⡠⠃⠑⠺⢄⠀⠀⠀⠀⠉⠑⠢⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠑⣄⠈⡠⠊⠁⠀⠀⠀⠀⠀⠀⠀⢀⠔⢀⠀⠀⠘⠰⣆⠀⠀⠀⢢⠀⠀⠀⠂⠤⢄⡀⠈⠑⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠀⣸⠊⠀⠀⠀⠀⠀⠀⠀⠀⡠⢂⠊⡰⠃⠀⠀⡆⠀⣏⠀⠀⠀⠀⠡⡀⠀⠀⠀⠀⠈⠁⠣⣔⡈⠢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠞⢁⠀⠀⠀⠀⠀⢀⠄⢀⠞⠀⢆⡜⠁⠀⠀⢰⠅⡀⠹⡇⠀⠀⠀⠀⠱⡀⠀⠀⠀⠀⠀⠀⠈⠉⠓⠚⠦⠄⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡡⢋⡔⠁⠀⠀⠀⡰⢀⠎⠠⡝⠀⢸⡜⠀⠀⠀⢀⢃⢡⢣⠀⢣⠀⠀⠀⠀⠀⢡⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠠⢐⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠮⡎⡝⠀⠀⠀⢀⡞⠁⡞⢠⡝⠀⠀⣿⠃⠀⠀⠀⡜⡌⡜⡼⣆⠈⢣⠀⠀⠀⠀⠈⠀⣀⣀⠀⠀⠀⠠⠄⠂⢁⠔⠋⢃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠴⠊⠁⡜⡌⠀⠀⠀⢒⠞⢲⠸⢧⣿⠁⠀⢀⡟⠀⢀⠆⢠⠡⡰⡇⡘⢿⣦⡀⠣⡀⠀⠀⠀⡆⢢⠀⠀⠀⠀⠀⣠⠖⠁⠀⠀⠈⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡙⠀⢠⠁⠀⡌⡄⣎⡗⡡⡌⠀⠀⡼⠇⠀⡜⠀⡬⢤⠧⣇⢱⠀⠑⠱⢄⡈⠢⢄⠀⠇⢢⢣⠀⠀⡠⡪⢲⡆⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣬⠀⢠⡇⠀⡜⡠⠐⢹⡌⠀⡇⠀⢰⢸⠀⢀⠇⡷⡆⠸⠀⡇⢩⠂⢄⠀⠀⠈⠁⠀⠀⠁⡎⡆⡤⢊⠔⠀⠀⣇⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢣⠀⣞⠁⢰⣯⣤⣤⡘⢅⠀⡇⠀⡄⡀⠀⢸⢠⢃⢀⡇⠀⣠⢨⠀⡇⠁⡆⠀⠀⠀⠀⠀⣇⠏⡗⠁⠀⠀⠀⢹⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣎⢞⢰⢸⠀⡘⢈⣶⣶⣾⣵⠀⢳⡇⡇⡇⠀⢸⡎⣌⠸⠥⡀⠉⡄⠀⡇⠀⠀⠀⠀⠀⠀⠚⠀⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠃⡏⢸⠀⡀⣇⢸⠉⢻⡽⢟⠁⠘⢷⢻⡅⠀⣺⣿⣭⣭⣿⣰⢤⣱⠀⠃⢀⡀⠀⠀⠀⠀⠇⢸⠀⠀⠀⠀⠀⠀⡀⠀⠀⡄⠀⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⢰⡏⠀⣇⡿⡦⣃⡘⣁⠎⠀⠀⠈⢻⠱⡀⠘⠛⠿⣟⣻⣿⡷⡝⣷⠀⣸⠀⠀⢸⢀⢲⠀⡆⢰⠀⠀⡇⠀⢠⡇⠀⡸⠀⢀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⡀⠐⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠿⣀⡏⣇⢞⢼⠉⠑⠈⠀⠀⠀⠀⠉⠻⢄⣆⠸⣻⠟⠁⠹⠅⣸⢀⡋⠀⠀⡎⡸⡈⠰⠀⡛⠀⢠⠇⢀⢳⠁⢰⢁⢼⡘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢠⠎⠉⠐⠀⠀⠸⡆⠀⠀⠀⠀⠀⠀⠠⠄⡀⠀⠀⠀⢹⠊⠈⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣘⠢⢤⣠⡔⣎⠀⡇⡌⠃⠀⡸⢠⢣⡇⢆⢠⠁⢠⢻⠀⣌⣸⠀⢃⠎⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢸⣆⠀⠀⠀⠀⢸⠃⠀⠀⢰⠉⠑⠤⠃⠀⡇⠀⠀⠀⠀⢂⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⢲⣿⡟⣾⣾⡦⠱⣸⣿⠘⠀⣰⡡⠁⠸⣇⢀⠇⠀⠎⡌⣼⡪⢷⠸⠃⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠙⠲⠤⠄⠀⠎⠀⠀⠀⠈⢆⢄⠀⠀⢠⠃⠀⠀⠀⠀⠀⠱⡀⠀⠀⠀⠀⠑⠀⠀⠀⠀⠀⠈⠉⡝⠚⠿⠃⠆⡝⡝⡆⡴⠟⢁⠂⢀⢋⣬⢀⢊⡜⡼⠋⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀  ⠀⠑⠒⠂⠁⠀⠀⠀⠀⠀⠀⠀⠈⢢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢰⣣⡘⡀⠀⡎⢀⡧⠂⡏⡰⢱⠊⠀⠀⠀⠈⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀  ⠑⠤⠀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠤⠐⠂⠈⠋⡏⢱⢠⣿⡇⣬⣀⠀⢷⠁⠈⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⡉⠀⠀⡇⠀⠀⠀⠉⠀⠉⠉⠉⠉⠉⠁⣠⡔⠛⢆⠰⡼⣣⠀⠀⠀⠀⠀⠀⡠⠊⠀⡇⣿⣾⠛⠳⠇⠶⣭⣺⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⣀⠤⠤⠴⠿⡷⡀⠘⡄⢻⡿⠆⠀⠀⡠⠔⠁⠀⠀⣀⣿⣽⠟⠠⠠⠐⠂⠙⠋⣁⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
*/
