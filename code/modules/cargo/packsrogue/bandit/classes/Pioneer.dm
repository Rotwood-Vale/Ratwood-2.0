/datum/supply_pack/rogue/Pioneer
	group = "Pioneer"
	crate_name = "Gifts of Engineering"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/Pioneer/gambeson
	name = "Gambeson"
	cost = 5
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson)

/datum/supply_pack/rogue/Pioneer/hgambeson
	name = "Heavy Gambeson"
	cost = 15
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)

/datum/supply_pack/rogue/Pioneer/leather
	name = "Leather Armor"
	cost = 10
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather)

/datum/supply_pack/rogue/Pioneer/leather/studded
	name = "Studded Leather Armor"
	cost = 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/studded)

/datum/supply_pack/rogue/Pioneer/leather/heavy
	name = "Hardened Leather Armor"
	cost = 20
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy)

/datum/supply_pack/rogue/Pioneer/leather/hcoat
	name = "Hardened Leather Coat"
	cost = 30
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat)

/datum/supply_pack/rogue/Pioneer/gorget
	name = "Gorget"
	cost = 20
	contains = list(/obj/item/clothing/neck/roguetown/gorget)

/datum/supply_pack/rogue/Pioneer/gorget
	name = "Steel Coif"
	cost = 30
	contains = list(/obj/item/clothing/neck/roguetown/chaincoif)

/datum/supply_pack/rogue/Pioneer/leather/Lbracers
	name = "Leather Bracers"
	cost = 5
	contains = list(/obj/item/clothing/wrists/roguetown/bracers/leather)

/datum/supply_pack/rogue/Pioneer/leather/hbracers
	name = "Hardened Leather Bracers"
	cost = 10
	contains = list(/obj/item/clothing/wrists/roguetown/bracers/leather/heavy)

/datum/supply_pack/rogue/Pioneer/leather/lgloves
	name = "Leather Gloves"
	cost = 5
	contains = list(/obj/item/clothing/gloves/roguetown/leather)

/datum/supply_pack/rogue/Pioneer/leather/hlgloves
	name = "Heavy Leather Gloves"
	cost = 10
	contains = list(/obj/item/clothing/gloves/roguetown/angle)

/datum/supply_pack/rogue/Pioneer/leather/flgloves
	name = "Fingerless Leather Gloves"
	cost = 10
	contains = list(/obj/item/clothing/gloves/roguetown/fingerless_leather)

/datum/supply_pack/rogue/Pioneer/leather/pants
	name = "Leather Trousers"
	cost = 10
	contains = list(/obj/item/clothing/under/roguetown/trou/leather)

/datum/supply_pack/rogue/Pioneer/leather/hpants
	name = "Hardened Leather Trousers"
	cost = 20
	contains = list(/obj/item/clothing/under/roguetown/heavy_leather_pants)

/datum/supply_pack/rogue/Pioneer/leather/lhelmet
	name = "Leather Helmet"
	cost = 5
	contains = list(/obj/item/clothing/head/roguetown/helmet/leather)

/datum/supply_pack/rogue/Pioneer/leather/hlhelmet
	name = "Hardened Leather Helmet"
	cost = 10
	contains = list(/obj/item/clothing/head/roguetown/helmet/leather/advanced)

/datum/supply_pack/rogue/Pioneer/leather/khelmet
	name = "Kettle Helmet"
	cost = 20
	contains = list(/obj/item/clothing/head/roguetown/helmet/kettle)

//Weaponry. They can't get a backup shovel.

/datum/supply_pack/rogue/Pioneer/parrydag
	name = "Parry Dagger"
	cost = 30
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/steel/parrying)

//Tools of the trade.

/datum/supply_pack/rogue/Pioneer/Mancatcher
	name = "Mancatcher"
	cost = 10
	contains = list(/obj/item/restraints/legcuffs/beartrap)

/datum/supply_pack/rogue/Pioneer/hammer
	name = "Smith hammer"
	cost = 20
	contains = list(/obj/item/rogueweapon/hammer/iron)

/datum/supply_pack/rogue/Pioneer/tongs
	name = "Smith tongs"
	cost = 20
	contains = list(/obj/item/rogueweapon/tongs)

/datum/supply_pack/rogue/Pioneer/cogs
	name = "Cogs"
	cost = 20
	contains = list(/obj/item/roguegear/bronze = 2)

/datum/supply_pack/rogue/Pioneer/bmbstrap
	name = "Bombdolier"
	cost = 70
	contains = list(/obj/item/bmbstrap)

//Meh grenades.

/datum/supply_pack/rogue/Pioneer/impactgrenade_smoke
	name = "Impact grenade (smoke)"
	cost = 20
	contains = list(/obj/item/impact_grenade/smoke)

/datum/supply_pack/rogue/Pioneer/impactgrenade_healing
	name = "Impact grenade (healing)"
	cost = 20
	contains = list(/obj/item/impact_grenade/smoke/healing_gas)

//Great grenades.

/datum/supply_pack/rogue/Pioneer/impactgrenade_poison
	name = "Impact grenade (poison)"
	cost = 45
	contains = list(/obj/item/impact_grenade/smoke/poison_gas)

/datum/supply_pack/rogue/Pioneer/impactgrenade_fire
	name = "Impact grenade (fire)"
	cost = 45
	contains = list(/obj/item/impact_grenade/smoke/fire_gas)

//Wild grenades.

/datum/supply_pack/rogue/Pioneer/impactgrenade_explosion
	name = "Impact grenade (explosion)"
	cost = 60
	contains = list(/obj/item/impact_grenade/explosion)

/datum/supply_pack/rogue/Pioneer/impactgrenade_blind
	name = "Impact grenade (blind)"
	cost = 60
	contains = list(/obj/item/impact_grenade/smoke/blind_gas)

/datum/supply_pack/rogue/Pioneer/impactgrenade_mute
	name = "Impact grenade (mute)"
	cost = 20
	contains = list(/obj/item/impact_grenade/smoke/mute_gas)

//WMDs.

/datum/supply_pack/rogue/Pioneer/blackpowder_stick
	name = "Blackpowder stick"
	cost = 100//From 35. Why was this 35? OOOUGH.
	contains = list(/obj/item/tntstick)

//WMDs, but for bombard and smokepowder stuff. Zezuz Pyst!!!
//A serious investment just to get started.
//Not even bringing up the other costs.
/datum/supply_pack/rogue/Pioneer/bombard_frame
	name = "Bombard frame"
	cost = 250
	contains = list(/obj/item/bombard_frame)

/datum/supply_pack/rogue/Pioneer/bombard_barrel
	name = "Bombard barrel"
	cost = 250
	contains = list(/obj/item/bombard_barrel)

/datum/supply_pack/rogue/Pioneer/bombard_palantir
	name = "Palantir"
	cost = 250
	contains = list(/obj/item/rogueweapon/palantir)

/datum/supply_pack/rogue/Pioneer/bombard_sponge
	name = "Bombard sponge"
	cost = 150
	contains = list(/obj/item/rogueweapon/woodstaff/quarterstaff/bombard_sponge)

/datum/supply_pack/rogue/Pioneer/smokepowder_flask
	name = "Smokepowder flask"
	cost = 150
	contains = list(/obj/item/powderflask)

//WMDs, but shells for the above!!!!
//Smoke bombard charges.
/datum/supply_pack/rogue/Pioneer/bombard_charge_smoke
	name = "Bombard charge (smoke)"
	cost = 50
	contains = list(/obj/item/cannonball/smoke)

/datum/supply_pack/rogue/Pioneer/bombard_charge_poison
	name = "Bombard charge (smoke - poison)"
	cost = 125
	contains = list(/obj/item/cannonball/smoke_poison)

/datum/supply_pack/rogue/Pioneer/bombard_charge_custom
	name = "Bombard charge (smoke - custom)"
	cost = 300
	contains = list(/obj/item/cannonball/smoke_custom)

//Dangerous bombard charges.
/datum/supply_pack/rogue/Pioneer/bombard_charge_canister
	name = "Bombard charge (canister)"
	cost = 125
	contains = list(/obj/item/cannonball/canister)

/datum/supply_pack/rogue/Pioneer/bombard_charge_explosive
	name = "Bombard charge (explosive)"
	cost = 400
	contains = list(/obj/item/cannonball/explosive)

/datum/supply_pack/rogue/Pioneer/bombard_charge_incendiary
	name = "Bombard charge (incendiary)"
	cost = 600
	contains = list(/obj/item/cannonball/incendiary)

//Misc bombard charges.
/datum/supply_pack/rogue/Pioneer/bombard_charge_flare
	name = "Bombard charge (flare)"
	cost = 85
	contains = list(/obj/item/cannonball/flare)
