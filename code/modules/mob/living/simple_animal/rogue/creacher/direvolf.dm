
//see volf.dm for parent animal
/mob/living/simple_animal/hostile/retaliate/rogue/wolf/dire
	icon = 'icons/roguetown/mob/monster/direvolf.dmi'
	name = "direvolf"
	desc = "A large snarling beast of mangy fur and yellowed teeth. Direvolves oft hail from mountaineous areas and are known to attack hapless travelers in the deep forests when prey is scarce."
	icon_state = "direvolf_brown"
	icon_living = "direvolf_brown"
	icon_dead = "direvolf_brown_dead"
	pixel_x = -8
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf = 2,//bigger volf, better meat
						/obj/item/alch/viscera = 2,
						/obj/item/alch/sinew = 1,
						/obj/item/natural/bone = 2)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf = 3, //bigger volf, better meat
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 3,
						/obj/item/natural/fur/wolf = 2,
						/obj/item/natural/bone = 3)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf = 4, //bigger volf, better meat
						/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/natural/hide = 3,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 2,
						/obj/item/alch/viscera = 4,
						/obj/item/natural/fur/wolf = 3,
						/obj/item/natural/bone = 4)
	health = BEAR_HEALTH	//volf is 120, direbear is 500
	maxHealth = BEAR_HEALTH
	melee_damage_lower = 50		// Ouch!!
	melee_damage_upper = 60
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES // silly furniture won't stop our boy
	food_type = list(/obj/item/reagent_containers/food/snacks,
					/obj/item/bodypart, //a delicious meal
					/obj/item/organ,
					/obj/item/natural/bone,
					/obj/item/natural/hide)
	STACON = 12
	STASTR = 13 //same stats as direbear. It's dire, ser.
	STASPD = 9
	remains_type = /obj/effect/decal/remains/direwolf

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/dire/Initialize(mapload)
	. = ..()
	var/color = pick("brown", "black", "white")
	icon_state = "direvolf_[color]"
	icon_living = "direvolf_[color]"
	icon_dead = "direvolf_[color]_dead"
	update_icon()

/obj/effect/decal/remains/direwolf
	name = "remains"
	desc = "Whether by starvation, disease, inter-pack conflict, or an unlucky kick from a saiga, this direvolf has died."
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/direvolf.dmi'
