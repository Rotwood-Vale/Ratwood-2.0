// Help apothecary kickstart, one of each seed. Don't want to make it too easy.
/obj/structure/closet/crate/chest/old_crate/apothseed
	name = "apothecary's herb seed crate"
	desc = "A wooden crate used to store basic herbs."

/obj/structure/closet/crate/chest/old_crate/apothseed/Initialize()
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
	name = "apothecary's potion ingredient crate"
	desc = "Labeled: WEEKLY HERB SUPPLY."

/obj/structure/closet/crate/chest/old_crate/apoth_initial_pot/Initialize()
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

/obj/structure/closet/crate/chest/old_crate/sojourner
	name = "sojourner's alchemy crate"
	desc = "Labeled: ´For the holy inquisition.´"

/obj/structure/closet/crate/chest/old_crate/sojourner/Initialize()
	. = ..()
	new /obj/item/recipe_book/alchemy(src)
	new /obj/item/storage/magebag/alchemist(src)
	new /obj/item/reagent_containers/glass/bucket/pot/stone(src)
	new /obj/item/pestle(src)
	new /obj/item/rogueweapon/hoe/stone(src)
	new /obj/item/rogueweapon/shovel(src)
	new /obj/item/ingot/iron(src)
	new /obj/item/grown/log/tree/small(src)
	new /obj/item/reagent_containers/glass/bucket(src)
	new /obj/item/reagent_containers/glass/bottle/rogue(src)
	new /obj/item/reagent_containers/glass/bottle/rogue(src)
	new /obj/item/reagent_containers/glass/bottle/rogue(src)
	new /obj/item/reagent_containers/glass/bottle/rogue(src)