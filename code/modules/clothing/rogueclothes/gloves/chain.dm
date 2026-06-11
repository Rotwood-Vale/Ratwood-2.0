/obj/item/clothing/gloves/roguetown/chain
	name = "锁子护手"
	desc = "由相扣钢环制成的护手。除了箭矢外，对常见兵器都有不错的防护。"
	icon_state = "cgloves"
	armor = ARMOR_MAILLE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT)
	resistance_flags = FIRE_PROOF
	blocksound = CHAINHIT
	max_integrity = ARMOR_INT_SIDE_STEEL
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/alch/irondust
	unarmed_bonus = 1.15

/obj/item/clothing/gloves/roguetown/chain/ancient
	name = "远古锁子护手"
	desc = "抛光的吉尔布兰兹环精巧相连，织成连指护手。那条丝线已经断裂，再也无法愈合; 齐佐的升格已注定如此。在她门徒之手中，阻碍世界得救的最后障碍将被拆毁: 生命。"
	icon_state = "acgloves"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/gloves/roguetown/chain/ancient/decrepit
	name = "破败锁子护手"
	desc = "磨损的青铜环彼此相连，形成下垂的连指护手。手指、爪子、利爪; 当它们被锁甲闷在下面腐烂时，全都没什么区别。"
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	color = "#bb9696"
	anvilrepair = null

/obj/item/clothing/gloves/roguetown/chain/psydon
	name = "赛顿缠链手套"
	desc = "黑钢束缚的护手。这些仪式性拘具在自然垂摆时，能帮助偏转难以预料的打击。 </br>我可以调整这些锁链，让它们只垂在手腕上，而非缠绕整条手臂。"
	icon_state = "psydongloveschain"
	item_state = "psydongloveschains"
	// smeltresult = null	//So you can't melt down your start gear for blacksteel brigadines etc.
	var/wrapped = FALSE

/obj/item/clothing/gloves/roguetown/chain/psydon/attack_right(mob/user)
	. = ..()
	if(!wrapped)
		icon_state = "psydongloveschainwrap"
		item_state = "psydongloveschainwrap"
		user.update_inv_wrists()
		user.update_inv_gloves()
		user.update_inv_armor()
		user.update_inv_shirt()
		playsound(user, 'sound/foley/equip/chain_equip.ogg', 50, TRUE)
		wrapped = TRUE
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
		user.update_inv_wrists()
		user.update_inv_gloves()
		user.update_inv_armor()
		user.update_inv_shirt()
		playsound(user, 'sound/foley/equip/chain_equip.ogg', 50, TRUE)
		wrapped = FALSE


/obj/item/clothing/gloves/roguetown/chain/iron
	icon_state = "icgloves"
	desc = "由相扣铁环制成的护手。除了箭矢外，对常见兵器都有不错的防护。"
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/alch/irondust
	max_integrity = ARMOR_INT_SIDE_IRON
