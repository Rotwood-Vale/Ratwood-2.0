// Help apothecary kickstart, one of each seed. Don't want to make it too easy.
/obj/structure/closet/crate/chest/old_crate/apothseed
	name = "药剂师草药种子箱"
	desc = "用于存放基础草药的木箱。"

/obj/structure/closet/crate/chest/old_crate/apothseed/Initialize(mapload)
	. = ..()
	new /obj/item/herbseed/matricaria(src)
	new /obj/item/herbseed/symphitum(src)
	new /obj/item/herbseed/taraxacum(src)
	new /obj/item/herbseed/atropa(src)
	new /obj/item/herbseed/euphrasia(src)
	new /obj/item/herbseed/paris(src)
	new /obj/item/herbseed/calendula(src)
	new /obj/item/herbseed/mentha(src)
	new /obj/item/herbseed/urtica(src)
	new /obj/item/herbseed/salvia(src)
	new /obj/item/herbseed/hypericum(src)
	new /obj/item/herbseed/benedictus(src)
	new /obj/item/herbseed/valeriana(src)
	new /obj/item/herbseed/artemisia(src)
	new /obj/item/herbseed/rosa(src)
	new /obj/item/seeds/swampweed(src)
	new /obj/item/seeds/pipeweed(src)

// Basic potion ingredients for initial supply of red & blue potions.
// Everything else should be acquired by them.
/obj/structure/closet/crate/chest/old_crate/apoth_initial_pot
	name = "药剂师药剂原料箱"
	desc = "标签上写着：每周草药补给。"

/obj/structure/closet/crate/chest/old_crate/apoth_initial_pot/Initialize(mapload)
	. = ..()
	new /obj/item/alch/calendula(src)
	new /obj/item/alch/calendula(src)
	new /obj/item/alch/calendula(src)
	new /obj/item/alch/viscera(src)
	new /obj/item/alch/viscera(src)
	new /obj/item/alch/viscera(src)
	new /obj/item/alch/bonemeal(src)
	new /obj/item/alch/bonemeal(src)
	new /obj/item/alch/bonemeal(src)
	new /obj/item/alch/berrypowder(src)
	new /obj/item/alch/berrypowder(src)
	new /obj/item/alch/berrypowder(src)
