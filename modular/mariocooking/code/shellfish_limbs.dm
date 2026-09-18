/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/limb
	icon = 'modular/mariocooking/sprites/shellfish_limbs.dmi'
	list_reagents = list()
	slice_path = null
	slices_num = 0
	ingredient_size = 1
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/limb/cooked
	eat_effect = null
	faretype = FARE_NEUTRAL
	fried_type = null
	cooked_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/crab_leg
	parent_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/limb
	name = "crab leg"
	desc = "A raw leg chopped from a crab. Best cooked before eating."
	icon_state = "crab_leg_raw"
	
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/crab_leg/cooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/crab_leg/cooked
	cooked_smell = /datum/pollutant/food/fried_crab

/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/crab_leg/cooked
	parent_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/limb/cooked
	name = "cooked crab leg"
	desc = "A cooked crab leg, ready to crack and eat."
	icon_state = "crab_leg_cooked"
	taste_description = "sweet crab meat"

/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/crab_claw
	parent_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/limb
	name = "crab claw"
	desc = "A raw claw chopped from a crab. Best cooked before eating."
	icon_state = "crab_claw_raw"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/crab_claw/cooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/crab_claw/cooked
	cooked_smell = /datum/pollutant/food/fried_crab

/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/crab_claw/cooked
	parent_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/limb/cooked
	name = "cooked crab claw"
	desc = "A cooked crab claw with tender meat inside."
	icon_state = "crab_claw_cooked"
	taste_description = "sweet crab meat"

/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/lobster_leg
	parent_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/limb
	name = "lobster leg"
	desc = "A raw leg chopped from a lobster. Best cooked before eating."
	icon_state = "lobster_leg_raw"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/lobster_leg/cooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/lobster_leg/cooked
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/lobster_leg/cooked
	parent_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/limb/cooked
	name = "cooked lobster leg"
	desc = "A cooked lobster leg with delicate meat inside."
	icon_state = "lobster_leg_cooked"
	taste_description = "rich lobster meat"

/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/lobster_claw
	parent_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/limb
	name = "lobster claw"
	desc = "A raw claw chopped from a lobster. Best cooked before eating."
	icon_state = "lobster_claw_raw"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/lobster_claw/cooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/lobster_claw/cooked
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/lobster_claw/cooked
	parent_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/limb/cooked
	name = "cooked lobster claw"
	desc = "A cooked lobster claw packed with rich meat."
	icon_state = "lobster_claw_cooked"
	taste_description = "rich lobster meat"
