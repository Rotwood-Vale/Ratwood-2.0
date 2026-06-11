/obj/item/rogueweapon/greataxe/dreamscape
	force = 10
	force_wielded = 35
	name = "异界战斧"
	desc = "一把奇异的斧头，无人知晓它来自何方。它摸起来冰冷，且沉重得异乎寻常。"
	icon_state = "dreamaxe"
	minstr = 13
	max_blade_int = 250
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = null
	associated_skill = /datum/skill/combat/axes
	blade_dulling = DULLING_BASHCHOP
	wdefense = 5
	item_flags = DREAM_ITEM
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/greataxe/dreamscape/active
	// to do, make this burn you if you don't regularly soak it.
	force = 15
	force_wielded = 40
	desc = "一把奇异的斧头，无人知晓它来自何方。它的斧刃灼热滚烫，几乎连握柄都难以持稳。"
	icon_state = "dreamaxeactive"
	max_blade_int = 500
	wdefense = 6
