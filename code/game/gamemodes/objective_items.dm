//Contains the target item datums for Steal objectives.

/datum/objective_item
	var/name = "A silly bike horn! Honk!"
	var/targetitem = /obj/item/paper	//typepath of the objective item
	var/difficulty = 9001							//vaguely how hard it is to do this objective
	var/list/excludefromjob = list()				//If you don't want a job to get a certain objective (no captain stealing his own medal, etcetc)
	var/list/altitems = list()				//Items which can serve as an alternative to the objective (darn you blueprints)
	var/list/special_equipment = list()

/datum/objective_item/proc/check_special_completion() //for objectives with special checks (is that slime extract unused? does that intellicard have an ai in it? etcetc)
	return 1

/datum/objective_item/proc/TargetExists()
	return TRUE

/datum/objective_item/steal/New()
	..()
	if(TargetExists())
		GLOB.possible_items += src
	else
		qdel(src)

/datum/objective_item/steal/Destroy()
	GLOB.possible_items -= src
	return ..()

/datum/objective_item/steal/rogue/ledger
	name = "the merchant's catatoma."
	targetitem = /obj/item/book/rogue/secret/ledger
	difficulty = 2
	excludefromjob = list("Merchant")

//^ this is unused.

/datum/objective_item/steal/rogue/mkey
	name = "the master key."
	targetitem = /obj/item/roguekey/lord
	difficulty = 7
	excludefromjob = list("Lord", "Knight")

/datum/objective_item/steal/rogue/crown
	name = "the Lord's crown."
	targetitem = /obj/item/clothing/head/roguetown/crown/serpcrown
	difficulty = 10
	excludefromjob = list("Grand Duke", "Suitor", "Knight")

//^ I truly wonder how they anyone will do this.

/datum/objective_item/steal/rogue/priestmask
	name = "the Bishop's mask."
	targetitem = /obj/item/clothing/head/roguetown/priestmask
	difficulty = 7
	excludefromjob = list("Bishop")

//^ ditto as above. imagine stealing someone's mask off they face.

// For the Solar Visage (Bishop's mask), require the item be bagged inside a sack to count.
/datum/objective_item/steal/rogue/priestmask/check_special_completion(obj/item/I)
	// Walk up the containment chain to see if this item resides inside a sack container
	// Only counts as complete if the mask is inside a /obj/item/storage/roguebag (the sack)
	var/atom/A = I
	while(A)
		if(istype(A, /obj/item/storage/roguebag))
			return TRUE
		// Stop if we've reached a mob inventory; not inside a sack
		if(ismob(A))
			break
		A = A.loc
	return FALSE

/datum/objective_item/steal/rogue/heirloom_sword
	name = "the heirloom sword."
	targetitem = /obj/item/rogueweapon/sword/long/heirloom
	difficulty = 3
	excludefromjob = list()

// easy

/datum/objective_item/steal/rogue/idagger_silver
	name = "a silver hunting dagger."
	targetitem = /obj/item/rogueweapon/huntingknife/idagger/silver
	difficulty = 2
	excludefromjob = list()

// merchant always seems to spawn one.

/datum/objective_item/steal/rogue/tallow_red
	name = "a red tallow."
	targetitem = /obj/item/reagent_containers/food/snacks/tallow/red
	difficulty = 3
	excludefromjob = list()

// inquisitor's manor is full of them.

/datum/objective_item/steal/rogue/quicksilver
	name = "a vial of quicksilver."
	targetitem = /obj/item/quicksilver
	difficulty = 4
	excludefromjob = list()

// inquisitor's manor has one static spawn


/datum/objective_item/steal/rogue/unforgotten
	name = "the Unforgotten blade."
	targetitem = /obj/item/rogueweapon/greatsword/bsword/psy/unforgotten
	difficulty = 7
	excludefromjob = list()


// deep in the inquisitor's manor

/datum/objective_item/steal/rogue/golden_psydon
	name = "the golden Psydonite chalice."
	targetitem = /obj/item/reagent_containers/glass/cup/golden
	difficulty = 8
	excludefromjob = list()

// static spawn in the church vault.

/datum/objective_item/steal/rogue/martyr_sword
	name = "the Martyr's sword."
	targetitem = /obj/item/rogueweapon/sword/long/martyr
	difficulty = 9
	excludefromjob = list("Martyr")

// ditto as above but it's just one room north. at least on dunworld.

/datum/objective_item/steal/rogue/exe_cloth
	name = "the executioner’s cloth-wrapped longsword."
	targetitem = /obj/item/rogueweapon/sword/long/exe/cloth
	difficulty = 7
	excludefromjob = list()

// deep in the north gate barracks.
