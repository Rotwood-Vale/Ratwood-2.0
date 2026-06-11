/obj/item
	var/baitpenalty = 100 // Using this as bait will incurr a penalty to fishing chance. 100 makes it useless as bait. Lower values are better, but Never make it past 10.
	var/isbait = FALSE	// Is the item in question bait to be used?
	var/list/fishingMods = null

/obj/item/natural/worms
	name = "蠕虫"
	desc = "敢于深入这片黑暗水域的渔夫们最爱的鱼饵。"
	icon_state = "worm1"
	throwforce = 10
	baitpenalty = 10
	isbait = TRUE
	color = "#985544"
	w_class = WEIGHT_CLASS_TINY
	fishingMods=list(
		"commonFishingMod" = 1,
		"rareFishingMod" = 1,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0 // 1 on cerulean aril, 0 on everything else
	)
	
	drop_sound = 'sound/foley/dropsound/food_drop.ogg'
	var/amt = 1

/obj/item/natural/worms/grubs
	name = "蛆虫"
	desc = "绝望者，或胆大者，都会拿它当鱼饵。"
	baitpenalty = 5
	isbait = TRUE
	color = null
	fishingMods=list(
		"commonFishingMod" = 0.85,
		"rareFishingMod" = 1.15,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0, // 1 on cerulean aril, 0 on everything else
	)

/obj/item/natural/worms/grubs/attack_right(mob/user)
	return

/obj/item/natural/worms/Initialize(mapload)
	. = ..()
	dir = rand(0,8)
