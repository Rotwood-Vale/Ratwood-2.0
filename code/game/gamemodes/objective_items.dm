//Contains the target item datums for Steal objectives.

/datum/objective_item
	var/name = "一个傻乎乎的自行车喇叭！叭叭！"
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
	name = "商人的账册。"
	targetitem = /obj/item/book/rogue/secret/ledger
	difficulty = 2
	excludefromjob = list("Merchant")

/datum/objective_item/steal/rogue/mkey
	name = "万能钥匙。"
	targetitem = /obj/item/roguekey/lord
	difficulty = 3
	excludefromjob = list("Lord", "Knight")

/datum/objective_item/steal/rogue/crown
	name = "领主的王冠。"
	targetitem = /obj/item/clothing/head/roguetown/crown/serpcrown
	difficulty = 3
	excludefromjob = list("Grand Duke", "Suitor", "Knight")
