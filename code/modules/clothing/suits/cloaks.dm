//Cloaks. No, not THAT kind of cloak.

/obj/item/clothing/neck/cloak
	name = "棕色斗篷"
	desc = ""
	icon = 'icons/obj/clothing/cloaks.dmi'
	icon_state = "qmcloak"
	item_state = "qmcloak"
	w_class = WEIGHT_CLASS_SMALL
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDESUITSTORAGE

/obj/item/clothing/neck/cloak/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user]正用[src]勒[user.p_them()]自己！看起来[user.p_theyre()]在试图自杀！</span>")
	return(OXYLOSS)

/obj/item/clothing/neck/cloak/hos
	name = "安全主管斗篷"
	desc = ""
	icon_state = "hoscloak"

/obj/item/clothing/neck/cloak/qm
	name = "军需官斗篷"
	desc = ""

/obj/item/clothing/neck/cloak/cmo
	name = "首席医疗官斗篷"
	desc = ""
	icon_state = "cmocloak"

/obj/item/clothing/neck/cloak/ce
	name = "首席工程师斗篷"
	desc = ""
	icon_state = "cecloak"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/cloak/rd
	name = "研究主管斗篷"
	desc = ""
	icon_state = "rdcloak"

/obj/item/clothing/neck/cloak/cap
	name = "舰长斗篷"
	desc = ""
	icon_state = "capcloak"

/obj/item/clothing/neck/cloak/hop
	name = "人事主管斗篷"
	desc = ""
	icon_state = "hopcloak"
