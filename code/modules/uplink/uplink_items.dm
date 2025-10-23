// Minimal uplink catalog scaffolding

GLOBAL_LIST_EMPTY(uplink_items)       // registry of item typepaths (unused in MVP)
GLOBAL_LIST_EMPTY(uplink_categories)  // registry of category names

// Build a small, safe default catalog for MVP/debug. Extend or override as needed.
/proc/get_uplink_items(datum/game_mode/gamemode, allow_sales = TRUE, allow_restricted = TRUE, other_filter = list())
	var/list/catalog = list()

	// Weapons category
	var/category = "Weapons"
	catalog[category] = list()

	var/datum/uplink_item/steel_dagger = new
	steel_dagger.name = "Steel Dagger"
	steel_dagger.category = category
	steel_dagger.desc = "A sturdy steel dagger. Quick and concealable."
	steel_dagger.item = /obj/item/rogueweapon/huntingknife/idagger/steel
	steel_dagger.cost = 2
	catalog[category][steel_dagger.name] = steel_dagger

	var/datum/uplink_item/steel_woodaxe = new
	steel_woodaxe.name = "Steel Woodcutting Axe"
	steel_woodaxe.category = category
	steel_woodaxe.desc = "A steel woodcutter's axe. Doubles as a vicious weapon."
	steel_woodaxe.item = /obj/item/rogueweapon/stoneaxe/woodcut/steel
	steel_woodaxe.cost = 5
	catalog[category][steel_woodaxe.name] = steel_woodaxe

	var/datum/uplink_item/steel_greataxe = new
	steel_greataxe.name = "Steel Greataxe"
	steel_greataxe.category = category
	steel_greataxe.desc = "A massive steel greataxe. Slow but devastating."
	steel_greataxe.item = /obj/item/rogueweapon/greataxe/steel
	steel_greataxe.cost = 5
	catalog[category][steel_greataxe.name] = steel_greataxe

	var/datum/uplink_item/steel_mace = new
	steel_mace.name = "Steel Mace"
	steel_mace.category = category
	steel_mace.desc = "A heavy steel mace. Blunt and brutal."
	steel_mace.item = /obj/item/rogueweapon/mace/steel
	steel_mace.cost = 5
	catalog[category][steel_mace.name] = steel_mace

	var/datum/uplink_item/steel_warhammer = new
	steel_warhammer.name = "Steel Warhammer"
	steel_warhammer.category = category
	steel_warhammer.desc = "A formidable steel warhammer. Delivers crushing blows."
	steel_warhammer.item = /obj/item/rogueweapon/mace/warhammer/steel
	steel_warhammer.cost = 5
	catalog[category][steel_warhammer.name] = steel_warhammer

	var/datum/uplink_item/steel_quarterstaff = new
	steel_quarterstaff.name = "Steel Quarterstaff"
	steel_quarterstaff.category = category
	steel_quarterstaff.desc = "A sturdy steel quarterstaff. Versatile and reliable."
	steel_quarterstaff.item = /obj/item/rogueweapon/woodstaff/quarterstaff/steel
	steel_quarterstaff.cost = 3
	catalog[category][steel_quarterstaff.name] = steel_quarterstaff

	var/datum/uplink_item/steel_pick = new
	steel_pick.name = "Steel Militia Pick"
	steel_pick.category = category
	steel_pick.desc = "A rugged steel pickaxe. Useful for mining and combat."
	steel_pick.item = /obj/item/rogueweapon/pick/militia/steel
	steel_pick.cost = 4
	catalog[category][steel_pick.name] = steel_pick

	var/datum/uplink_item/steel_claws = new
	steel_claws.name = "Steel Katar"
	steel_claws.category = category
	steel_claws.desc = "A katar. Used by pugilists all around Ferentia."
	steel_claws.item = /obj/item/rogueweapon/katar
	steel_claws.cost = 5
	catalog[category][steel_claws.name] = steel_claws

	var/datum/uplink_item/steel_greatsword = new
	steel_greatsword.name = "Steel Greatsword"
	steel_greatsword.category = category
	steel_greatsword.desc = "A massive steel greatsword. Might be able to chop anything in half!"
	steel_greatsword.item = /obj/item/rogueweapon/greatsword
	steel_greatsword.cost = 7
	catalog[category][steel_greatsword.name] = steel_greatsword

	var/datum/uplink_item/steel_longsword = new
	steel_longsword.name = "Steel Longsword"
	steel_longsword.category = category
	steel_longsword.desc = "A finely crafted steel longsword. Balanced for both cutting and thrusting."
	steel_longsword.item = /obj/item/rogueweapon/sword/long
	steel_longsword.cost = 5
	catalog[category][steel_longsword.name] = steel_longsword

	var/datum/uplink_item/falx = new
	falx.name = "Falx"
	falx.category = category
	falx.desc = "A curved falx, perfect for slashing through armor."
	falx.item = /obj/item/rogueweapon/sword/falx
	falx.cost = 5
	catalog[category][falx.name] = falx


	var/datum/uplink_item/blacksteel_longsword = new
	blacksteel_longsword.name = "Blacksteel Longsword"
	blacksteel_longsword.category = category
	blacksteel_longsword.desc = "An incredibly rare Blacksteel Longsword. We've sourced this from some Psydonite vault. Use it well."
	blacksteel_longsword.item = /obj/item/rogueweapon/sword/long/blackflamb
	blacksteel_longsword.cost = 15
	catalog[category][blacksteel_longsword.name] = blacksteel_longsword

	var/datum/uplink_item/random_magic_staff/random_magic_staff = new
	random_magic_staff.name = "Random Magical Staff"
	random_magic_staff.category = category
	random_magic_staff.desc = "A staff imbued with a random gem."
	random_magic_staff.cost = 10
	catalog[category][random_magic_staff.name] = random_magic_staff


	// Armours category
	var/category_armour = "Armours"
	catalog[category_armour] = list()

	var/datum/uplink_item/leather_studded = new
	leather_studded.name = "Studded Leather"
	leather_studded.category = category_armour
	leather_studded.desc = "A reinforced leather vest with metal studs. Light protection with good mobility."
	leather_studded.item = /obj/item/clothing/suit/roguetown/armor/leather/studded
	leather_studded.cost = 4
	catalog[category_armour][leather_studded.name] = leather_studded

	var/datum/uplink_item/gambeson = new
	gambeson.name = "Padded Gambeson"
	gambeson.category = category_armour
	gambeson.desc = "A padded arming jacket. Comfortable and offers good protection."
	gambeson.item = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	gambeson.cost = 4
	catalog[category_armour][gambeson.name] = gambeson

	var/datum/uplink_item/brigandine_light = new
	brigandine_light.name = "Brigandine (Light)"
	brigandine_light.category = category_armour
	brigandine_light.desc = "A light brigandine with metal plates riveted under cloth. Balanced defense."
	brigandine_light.item = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	brigandine_light.cost = 6
	catalog[category_armour][brigandine_light.name] = brigandine_light

	var/datum/uplink_item/chainmail_steel = new
	chainmail_steel.name = "Chainmail (Steel)"
	chainmail_steel.category = category_armour
	chainmail_steel.desc = "A steel chain shirt. Solid all-round protection."
	chainmail_steel.item = /obj/item/clothing/suit/roguetown/armor/chainmail/
	chainmail_steel.cost = 5
	catalog[category_armour][chainmail_steel.name] = chainmail_steel

	var/datum/uplink_item/plate_half_steel = new
	plate_half_steel.name = "Half-Plate Cuirass (Steel)"
	plate_half_steel.category = category_armour
	plate_half_steel.desc = "A solid steel half-plate cuirass. Heavier but excellent protection."
	plate_half_steel.item = /obj/item/clothing/suit/roguetown/armor/plate/half/
	plate_half_steel.cost = 7
	catalog[category_armour][plate_half_steel.name] = plate_half_steel

	var/datum/uplink_item/plate_scale = new
	plate_scale.name = "Scale Cuirass"
	plate_scale.category = category_armour
	plate_scale.desc = "Overlapping metal scales offering good coverage and flexibility."
	plate_scale.item = /obj/item/clothing/suit/roguetown/armor/plate/scale
	plate_scale.cost = 5
	catalog[category_armour][plate_scale.name] = plate_scale

	var/datum/uplink_item/hard_trousers = new
	hard_trousers.name = "Hardened Trousers"
	hard_trousers.category = category_armour
	hard_trousers.desc = "Trousers reinforced with hardened leather patches. Offers decent leg protection."
	hard_trousers.item = /obj/item/clothing/under/roguetown/heavy_leather_pants
	hard_trousers.cost = 3
	catalog[category_armour][hard_trousers.name] = hard_trousers

	var/datum/uplink_item/hard_bracers = new
	hard_bracers.name = "Hardened Leather Bracers"
	hard_bracers.category = category_armour
	hard_bracers.desc = "Leather bracers reinforced with hardened patches. Provides forearm protection."
	hard_bracers.item = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	hard_bracers.cost = 2
	catalog[category_armour][hard_bracers.name] = hard_bracers

	var/datum/uplink_item/bevor = new
	bevor.name = "Steel Bevor"
	bevor.category = category_armour
	bevor.desc = "A steel bevor to protect the neck and lower face."
	bevor.item = /obj/item/clothing/neck/roguetown/bevor
	bevor.cost = 3
	catalog[category_armour][bevor.name] = bevor

	var/datum/uplink_item/steel_gaunts = new
	steel_gaunts.name = "Steel Gauntlets"
	steel_gaunts.category = category_armour
	steel_gaunts.desc = "A pair of steel gauntlets to protect the hands and wrists."
	steel_gaunts.item = /obj/item/clothing/gloves/roguetown/plate
	steel_gaunts.cost = 3
	catalog[category_armour][steel_gaunts.name] = steel_gaunts

	var/datum/uplink_item/warden_upgraded = new
	warden_upgraded.name = "Forester's Brigandine"
	warden_upgraded.category = category_armour
	warden_upgraded.desc = "We stole this from a Warden, just last week. It's been upgraded for better protection."
	warden_upgraded.item = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded
	warden_upgraded.cost = 6
	catalog[category_armour][warden_upgraded.name] = warden_upgraded


	var/category_tools = "Tools"
	catalog[category_tools] = list()

	var/datum/uplink_item/lockpick_set = new
	lockpick_set.name = "Lockpick Set"
	lockpick_set.category = category_tools
	lockpick_set.desc = "A set of lockpicks for opening locked doors and containers."
	lockpick_set.item = /obj/item/lockpickring/mundane
	lockpick_set.cost = 2
	catalog[category_tools][lockpick_set.name] = lockpick_set

	var/datum/uplink_item/grapplinghook = new
	grapplinghook.name = "Grappling Hook"
	grapplinghook.category = category_tools
	grapplinghook.desc = "A grappling hook for scaling walls and obstacles."
	grapplinghook.item = /obj/item/grapplinghook
	grapplinghook.cost = 3
	catalog[category_tools][grapplinghook.name] = grapplinghook

	var/datum/uplink_item/chains = new
	chains.name = "Set of Chains"
	chains.category = category_tools
	chains.desc = "A sturdy set of chains. Useful for restraining targets."
	chains.item = /obj/item/rope/chain
	chains.cost = 1
	catalog[category_tools][chains.name] = chains

	var/datum/uplink_item/lantern = new
	lantern.name = "Lamptern"
	lantern.category = category_tools
	lantern.desc = "A portable lamptern to light your way in dark places."
	lantern.item = /obj/item/flashlight/flare/torch/lantern
	lantern.cost = 2
	catalog[category_tools][lantern.name] = lantern

	var/datum/uplink_item/zbane = new
	zbane.name = "Zizo's Bane"
	zbane.category = category_tools
	zbane.desc = "We harvested some Zizo's bane from the Underdark for you to use. Grind this into a powder to use it."
	zbane.item = /obj/item/reagent_containers/food/snacks/zizo_bane
	zbane.cost = 5
	catalog[category_tools][zbane.name] = zbane

	var/datum/uplink_item/smokebomb = new
	smokebomb.name = "Smoke Bomb"
	smokebomb.category = category_tools
	smokebomb.desc = "A small bomb that releases a cloud of smoke when thrown."
	smokebomb.item = /obj/item/bomb/smoke
	smokebomb.cost = 3
	catalog[category_tools][smokebomb.name] = smokebomb

	var/datum/uplink_item/blind_gas = new
	blind_gas.name = "Blind Gas Bomb"
	blind_gas.category = category_tools
	blind_gas.desc = "A bomb that releases a gas causing temporary blindness."
	blind_gas.item = /obj/item/impact_grenade/smoke/blind_gas
	blind_gas.cost = 4
	catalog[category_tools][blind_gas.name] = blind_gas

	var/datum/uplink_item/mute_gas = new
	mute_gas.name = "Mute Gas Bomb"
	mute_gas.category = category_tools
	mute_gas.desc = "A bomb that releases a gas causing temporary muteness."
	mute_gas.item = /obj/item/impact_grenade/smoke/mute_gas
	mute_gas.cost = 4
	catalog[category_tools][mute_gas.name] = mute_gas

	var/datum/uplink_item/surgbag = new
	surgbag.name = "Surgery Bag"
	surgbag.category = category_tools
	surgbag.desc = "A bag containing basic surgical tools and supplies."
	surgbag.item = /obj/item/storage/belt/rogue/surgery_bag/full
	surgbag.cost = 5
	catalog[category_tools][surgbag.name] = surgbag
	
	var/datum/uplink_item/bandages = new
	bandages.name = "Bandages"
	bandages.category = category_tools
	bandages.desc = "We call them bandages, but in reality, it's just a bundle of cloth."
	bandages.item = /obj/item/natural/bundle/cloth
	bandages.cost = 1
	catalog[category_tools][bandages.name] = bandages

	var/category_consumables = "Consumables"
	catalog[category_consumables] = list()

	var/datum/uplink_item/healing_potion = new
	healing_potion.name = "Strong Healing Vial"
	healing_potion.category = category_consumables
	healing_potion.desc = "A potent vial that contains strong red."
	healing_potion.item = /obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew
	healing_potion.cost = 3
	catalog[category_consumables][healing_potion.name] = healing_potion

	var/datum/uplink_item/mana_pot = new
	mana_pot.name = "Strong Mana Vial"
	mana_pot.category = category_consumables
	mana_pot.desc = "A potent vial that contains strong blue."
	mana_pot.item = /obj/item/reagent_containers/glass/bottle/alchemical/strongmanapot
	mana_pot.cost = 3
	catalog[category_consumables][mana_pot.name] = mana_pot

	var/datum/uplink_item/strpot = new
	strpot.name = "Strength Vial"
	strpot.category = category_consumables
	strpot.desc = "A vial that temporarily increases physical strength."
	strpot.item = /obj/item/reagent_containers/glass/bottle/alchemical/strpot
	strpot.cost = 2
	catalog[category_consumables][strpot.name] = strpot

	var/datum/uplink_item/spdpot = new
	spdpot.name = "Speed Vial"
	spdpot.category = category_consumables
	spdpot.desc = "A vial that temporarily increases speed."
	spdpot.item = /obj/item/reagent_containers/glass/bottle/alchemical/spdpot
	spdpot.cost = 2
	catalog[category_consumables][spdpot.name] = spdpot

	var/datum/uplink_item/lucpot = new
	lucpot.name = "Fortune vial"
	lucpot.category = category_consumables
	lucpot.desc = "A vial that temporarily increases luck."
	lucpot.item = /obj/item/reagent_containers/glass/bottle/alchemical/lucpot
	lucpot.cost = 2
	catalog[category_consumables][lucpot.name] = lucpot

	// Uniques category
	var/category_uniques = "Uniques"
	catalog[category_uniques] = list()

	var/datum/uplink_item/crimson_mask = new
	crimson_mask.name = "Mask of the Crimson Order"
	crimson_mask.category = category_uniques
	crimson_mask.desc = "A crimson-gilded gold mask. Grants +2 to all stats, but marks you with Critical Weakness. In Challenge Mode, it seals to your face."
	crimson_mask.item = /obj/item/clothing/mask/rogue/facemask/goldmask/crimson_order
	crimson_mask.cost = 15
	catalog[category_uniques][crimson_mask.name] = crimson_mask




	return catalog

/**
 * Uplink Items
 * Base datum; subtypes can be defined elsewhere (e.g., holiday specials)
 */
/datum/uplink_item
	var/name = "item name"
	var/category = "item category"
	var/desc = "item description"
	var/item = null            // Path to the item to spawn (optional)
	var/refund_path = null     // Alternative path for refunds
	var/cost = 0
	var/refund_amount = 0
	var/refundable = FALSE
	var/surplus = 100
	var/cant_discount = FALSE
	var/limited_stock = -1
	var/list/include_modes = list()
	var/list/exclude_modes = list()
	var/list/restricted_roles = list()
	var/player_minimum
	var/purchase_log_vis = TRUE
	var/restricted = FALSE
	var/illegal_tech = FALSE

/datum/uplink_item/proc/get_discount()
	return pick(4;0.75,2;0.5,1;0.25)

/datum/uplink_item/proc/purchase(mob/user, datum/component/uplink/U)
	var/atom/A = spawn_item(item, user, U)
	if(purchase_log_vis && U.purchase_log)
		U.purchase_log.LogPurchase(A, src, cost)

/datum/uplink_item/proc/spawn_item(spawn_path, mob/user, datum/component/uplink/U)
	if(!spawn_path)
		return
	var/atom/A
	if(ispath(spawn_path))
		A = new spawn_path(get_turf(user))
	else
		A = spawn_path
	if(ishuman(user) && istype(A, /obj/item))
		var/mob/living/carbon/human/H = user
		if(H.put_in_hands(A))
			to_chat(H, "[A] materializes into your hands!")
			return A
	to_chat(user, "[A] materializes onto the floor.")
	return A

// Special uplink item: spawns a random magical staff with weighted rarity.
/datum/uplink_item/random_magic_staff/purchase(mob/user, datum/component/uplink/U)
	// Common weights for basic gems; rarer for diamond and riddle of steel.
	var/selected = pick(
		5; /obj/item/rogueweapon/woodstaff/toper,
		5; /obj/item/rogueweapon/woodstaff/amethyst,
		5; /obj/item/rogueweapon/woodstaff/emerald,
		4; /obj/item/rogueweapon/woodstaff/sapphire,
		4; /obj/item/rogueweapon/woodstaff/quartz,
		3; /obj/item/rogueweapon/woodstaff/ruby,
		2; /obj/item/rogueweapon/woodstaff/diamond,
		1; /obj/item/rogueweapon/woodstaff/riddle_of_steel
	)
	var/atom/A = spawn_item(selected, user, U)
	if(purchase_log_vis && U.purchase_log)
		U.purchase_log.LogPurchase(A, src, cost)
